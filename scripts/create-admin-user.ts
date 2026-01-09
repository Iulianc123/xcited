#!/usr/bin/env tsx
/**
 * Script pentru crearea unui user admin în xcited
 * 
 * Usage:
 *   npx tsx scripts/create-admin-user.ts <email> <password> [name]
 * 
 * Example:
 *   npx tsx scripts/create-admin-user.ts admin@xcited.ro AdminPass123! "Admin User"
 */

import { PrismaClient } from "@prisma/client";
import { PrismaPg } from "@prisma/adapter-pg";
import { Pool } from "pg";
import bcrypt from "bcryptjs";

const databaseUrl = process.env.DATABASE_URL || process.argv[5];

if (!databaseUrl) {
  console.error("❌ DATABASE_URL is not set");
  console.error("");
  console.error("Usage:");
  console.error("  DATABASE_URL=postgresql://... npx tsx scripts/create-admin-user.ts <email> <password> [name]");
  console.error("  OR");
  console.error("  npx tsx scripts/create-admin-user.ts <email> <password> [name] <database_url>");
  console.error("");
  console.error("Example:");
  console.error('  DATABASE_URL="postgresql://user:pass@host:5432/db" npx tsx scripts/create-admin-user.ts admin@xcited.ro AdminPass123! "Admin User"');
  process.exit(1);
}

const pool = new Pool({ connectionString: databaseUrl });
const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter });

const email = process.argv[2];
const password = process.argv[3];
const name = process.argv[4] || "Admin User";

if (!email || !password) {
  console.error("❌ Usage: npx tsx scripts/create-admin-user.ts <email> <password> [name]");
  console.error("");
  console.error("Example:");
  console.error('  npx tsx scripts/create-admin-user.ts admin@xcited.ro AdminPass123! "Admin User"');
  process.exit(1);
}

async function createAdminUser() {
  try {
    console.log("🔐 Creating admin user...");
    console.log(`   Email: ${email}`);
    console.log(`   Name: ${name}`);
    console.log("");

    // Check if user already exists
    const existingUser = await prisma.user.findUnique({
      where: { email },
    });

    if (existingUser) {
      console.log("⚠️  User already exists. Updating to admin...");
      
      const hashedPassword = await bcrypt.hash(password, 10);
      
      await prisma.user.update({
        where: { email },
        data: {
          name,
          password: hashedPassword,
          isAdmin: true,
          emailVerified: new Date(),
        },
      });

      console.log("✅ User updated to admin");
    } else {
      // Hash password
      const hashedPassword = await bcrypt.hash(password, 10);

      // Create admin user
      await prisma.user.create({
        data: {
          email,
          name,
          password: hashedPassword,
          isAdmin: true,
          emailVerified: new Date(),
        },
      });

      console.log("✅ Admin user created successfully!");
    }

    console.log("");
    console.log("📋 Login credentials:");
    console.log(`   Email: ${email}`);
    console.log(`   Password: ${password}`);
    console.log("");
    console.log("⚠️  IMPORTANT: Change the password after first login!");
    console.log("");

  } catch (error: any) {
    console.error("❌ Error creating admin user:", error.message);
    if (error.code === "P2002") {
      console.error("   User with this email already exists");
    }
    process.exit(1);
  } finally {
    await prisma.$disconnect();
  }
}

createAdminUser();
