Return-Path: <kvm+bounces-71326-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qBDyDgOjlmk7iQIAu9opvQ
	(envelope-from <kvm+bounces-71326-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 06:43:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id D6B7115C283
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 06:43:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0EFEA3008C0C
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 05:43:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32F762D0C66;
	Thu, 19 Feb 2026 05:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="o1G/bsIV"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010070.outbound.protection.outlook.com [52.101.56.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117832848AF
	for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 05:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771479807; cv=fail; b=NXWKV+ZMG/TYsY/akUKKwsf6CSm1d21rGrZ2gQ+U4PVL85WiVYT6BR6I7s3NqiVZ/nW8UsFzwJkmu46uF9eXHHl1sdXQ9JBpt56RdsnGcusnF7/LYrsc6ZF0OGwhEZSU4+SU2jBCgugSlaKVXxAwckoxL+JZBq1Mg4DBRP1UmSY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771479807; c=relaxed/simple;
	bh=8UlIliVdArfF/YJI+ITsxTvYakRY8xJ0/vOh4WFuhL0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EBFAnSKKLDqKYFh/U1VctH66F3Q8/cW2pbaV9W2pqIcUZ5ZPFFsnQ3Zr/al39P9/mOPGMzfb9ye7fqGnirFDs3jzqip4xELkW21SiJ9mukkw92BgvQC1qOlQCFsogvXd12o+qd5ldgjRneTjzjERnLqUYdsArubpxe2Hf3QGK90=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=o1G/bsIV; arc=fail smtp.client-ip=52.101.56.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=thHmSYEf2kNHwwYSyt0X3nLlM04/g8uWcQf/jPsTo7lJmvyZsj2UGtdeaggUWYyfsJNZtukNvmbBhEjRC5PUMgnh86v4tMMwZ5+KoqEg8F7tiiIytJ1tSa8oiznHP0aIzvebPSGWx6jokkiWCdTi8w1zDqZI0gMOLDLWyK994L8NVUeyVQANEsJ51QfnQVCnqSQ2pY7vJdIrePAst3syVEg0MW+jpx3ixsI0gCjioySCnTfBNSoqjG/E/lXAtu0KPMeFrkRsJrMPCSPqGwjpcS6to7ldhsjuc1PczauOg3Iez8KX+eaY7xUTzcakRE5S17ensNy9tC3uV4PLR35iKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LfJ9WJFyWYgs+3qS0411eXdpzRsH++ZF7xVlgYIV7Fk=;
 b=w+tdgyR/A+/Vt5cL9BnuRxrKJkHAIx2feWbgwbgCeK38E/YbiCw5NPZUVQOk4cFnEIssFM1a4qpEgG5oTRPWwl3jhs1fpO70adOR9D5mxBCinZFeBANzfAJ51tVKfVZ6nTwG1f+Ycr4drHGTGP7Z8THAB4kX4OxbiwdcC/oN587XmrxFKp8Xf/3q0kPEwxPJd1hO6JJf4B7k4LAAEBhG/GsTYhp/UN5wJZhLn1N2+RzyQAmwBds/5xE99XuNeIUBRYfq+5uAQL+21TtG23QaoxVKJxyUMdMh5MHjtmcDgelolan1ptYwWntvaHzyyrxTBE5YEYQHAP8HgYAXyLgw1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LfJ9WJFyWYgs+3qS0411eXdpzRsH++ZF7xVlgYIV7Fk=;
 b=o1G/bsIVxTGcusr52/P0acBO5FZZLEK5z/wvF8N5f4bKvCwy2tkEnbtXGcPwBErZV9H8AOO/dPQ7yPzHf4SmYf4oRQAeoeA5u4tZEoEymsDu96XxssA/sKETvyI4qPHsOTlpSFUebIlLjMV7Z6975EJZRW3pyh1ZzJk3QwJm8iM=
Received: from SJ0PR13CA0113.namprd13.prod.outlook.com (2603:10b6:a03:2c5::28)
 by BY5PR12MB4196.namprd12.prod.outlook.com (2603:10b6:a03:205::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.15; Thu, 19 Feb
 2026 05:43:22 +0000
Received: from SJ1PEPF00001CDF.namprd05.prod.outlook.com
 (2603:10b6:a03:2c5:cafe::e8) by SJ0PR13CA0113.outlook.office365.com
 (2603:10b6:a03:2c5::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.15 via Frontend Transport; Thu,
 19 Feb 2026 05:43:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CDF.mail.protection.outlook.com (10.167.242.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Thu, 19 Feb 2026 05:43:22 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 18 Feb
 2026 23:43:18 -0600
From: Manali Shukla <manali.shukla@amd.com>
To: <qemu-devel@nongnu.org>
CC: Cornelia Huck <cohuck@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
	<kvm@vger.kernel.org>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Marcelo Tosatti" <mtosatti@redhat.com>, "Michael S . Tsirkin"
	<mst@redhat.com>, "Paolo Bonzini" <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Richard Henderson <richard.henderson@linaro.org>, Naveen
 N Rao <naveen@kernel.org>, Nikunj Dadhaniya <nikunj@amd.com>,
	<manali.shukla@amd.com>
Subject: [PATCH v1 1/8] i386/kvm: Refactor APIC state functions to use generic register pointer
Date: Thu, 19 Feb 2026 05:42:00 +0000
Message-ID: <20260219054207.471303-2-manali.shukla@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260219054207.471303-1-manali.shukla@amd.com>
References: <20260219054207.471303-1-manali.shukla@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDF:EE_|BY5PR12MB4196:EE_
X-MS-Office365-Filtering-Correlation-Id: e2baf6b0-36ee-4d8a-2506-08de6f79cb5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jgXeXdNd7hHTSpWAVBOGfvjewd0m3ehDTLJFkHNaHd4yocFqtIqRUClJP0Me?=
 =?us-ascii?Q?SrjreG298mH+EKBZXj3W0fgZypk1L4DMd8oRSRUw2rS/XZRpkYKit8eYWGTg?=
 =?us-ascii?Q?Ctx40X4TY5uR7jZh6GPJtO3dcfB+BMpanLRwQbJOkKteZ/hahyX+OOmfRXn8?=
 =?us-ascii?Q?1YQ0iVDMrXx6P+qMGBv4e3yLsFsVVePYdVz5VzWA0kb/kgXvKMboONMR1o5c?=
 =?us-ascii?Q?jZBSkk+AWpo+TT/bli/e6sK3MOErj04C6R7DcZukjggDIKSt/xB+8fxRO7C+?=
 =?us-ascii?Q?aMtSqcPnjm8pzCkhGZTPxX8UcxUpk6w+USQhY+qts/5ZcdCUFbaY9geue673?=
 =?us-ascii?Q?BZEf0n4uXJT/LJkwhWUMPyEcttRcl2hBKN+PPEHOAAwf43mCSqxmQzsttl5s?=
 =?us-ascii?Q?bWHN6QpVdbgVkSQy9mKhwIWA15DNPI2iUjw7EM4gHSyBBxupLZLwtY5r/Kou?=
 =?us-ascii?Q?4e+31/jFbtWvwIShWAKXyyT3G/p5GYrl9tt0r7S6dV3Gvxp1gF/wo+yaSCzN?=
 =?us-ascii?Q?9P+BSqg6g77Oh/lGMUN6fNgEZi58xlLlG7hYqFq0JUXh9J22M0Co6Jl35y1C?=
 =?us-ascii?Q?rY8Ur/WKAoYlm/s7cK6H+S9BOj7TODebZpeSsN8HhaDgMOgHVnF/WyLATMKq?=
 =?us-ascii?Q?WrBcDApZcwzzvO0RvKEqJ6bGps7UcXHfgcmkuVeuRqhJDRI4aNY0Bd95TOna?=
 =?us-ascii?Q?2Zo/tfvmRrQe4KpSWQ4xMb0X9Lkex0A7dKlKMJNT/wIiA/2bZzDIYev9NtTa?=
 =?us-ascii?Q?0rw2A6ZA367aPFIqX+qu8xTVQ0fMOkJgyBfYzARFVR+23/Y/vaoDsPGTdokE?=
 =?us-ascii?Q?4YzV1sFlxQsI3KWg5E7ezZja/aF3fU7GIlFYcfbhAvCADjlRG2TlmiM8ECC5?=
 =?us-ascii?Q?CXiUuN+SLwSoF7RHB9BOmI28BFRutzkSvxaSW+EWTMESJXsnD6HdbztNan9G?=
 =?us-ascii?Q?uQdIQfZvSh43lbmGgJsW4pv7VyrtwYB958RooSl8VaqPupS+6APUB+SKvR0Q?=
 =?us-ascii?Q?KIBDdVt4MAhhxzZqDzdk+qqO53eXztcUIcjbvFuuylKBA7CF/SZ5CjlcYWQO?=
 =?us-ascii?Q?5JiR90ut8PDkdRlIKKUedTIysjhnKbdEKvEaClcrKB+F9J/khF9cuaz5a1bb?=
 =?us-ascii?Q?tAmcCD9k4Kn4O4VnUUSK8+OllLpB/qIVWfuRJoFyVxb0b+UaSM1FanNF4KTm?=
 =?us-ascii?Q?V6aVfl8DswYXOeS2KizDfYrRU5P7qAQRw22axxxhZMtBn4naoh35OdByjCjx?=
 =?us-ascii?Q?8ZnueiCaMtsWahnPrfwtNPMdbVothVjoi2ZiNIfb28cdeWlaapo5ZN7gYaRx?=
 =?us-ascii?Q?fSEZdPAhdPQPjVJMrwrQtpnvpKtnfHRxvAsDOjbxtjTXjdE0OhYmUSsYk0wN?=
 =?us-ascii?Q?rlHC8gvBEopA1grd2xqwPfa8pKyfERNwZHWJSiCHf49wFKGsXGC/sQOMUrEH?=
 =?us-ascii?Q?/oR7nucXXqTI2dnuxyNAL8SUu9ZlprqTBW/U30ha/HLRcmnOB4o82lclgU2C?=
 =?us-ascii?Q?ABGJiRVGKhlO3ExGhOg+xRqZxJgt4mej5rpA1335D6Lnio0PiBtyeEV6v/lQ?=
 =?us-ascii?Q?5EVMNESEd1RS01R31zeTZeuF1VU084z5aH82BC3h9gaF/JXIys9UzlQ76un9?=
 =?us-ascii?Q?mHtxMKT/ZFlZGroG8WLEpD/mR4mXIwtyemvfB6bYh/uFABuP53Vosg0JgjAS?=
 =?us-ascii?Q?aGOmoQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	4/ca7JI73MDWWvjBCQd6S2PMBdhLC1YBYB5Cl065tIIftq5+ue2sAzbgzRA/pvoE2sfwJq+ebE0N3idvmvG/i60lSnN7viQ8cQuXtbr4DtFazTB1o/aXT5a1c+U1beoYNl8VfFdyMUEoq8VRG2bQjVGzlDrOG11y1XflPJtlQv9WwhR4oOqdW5GtUT7PEuAlPLqc4muOEDlDmVRIakKC07yTMQjpWzCTrcYqjKfAvOOVednEcsxX7S7U3OyR8NMzQIBZ7BKxmsH4OV0I6dPQeh99bVLpaGYwGC2T5M3ERn4/vs0u4mAf6NZXZD3YXE3QD6Kqlqo7kEU/tNAcwq1hnDiS+N8qK4QgjPnIG5wXyf2MGbIbQHAAWwtkg3F/T/scjubRKPTZ5NSbPo+eJYUcA36SaltKnTg6c0Oi7FJ2VMzrbPJhd/KsmB7unJcSmJ9V
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2026 05:43:22.5467
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e2baf6b0-36ee-4d8a-2506-08de6f79cb5c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4196
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [2.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[redhat.com,habkost.net,vger.kernel.org,gmail.com,google.com,linaro.org,kernel.org,amd.com];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-71326-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[amd.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[manali.shukla@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: D6B7115C283
X-Rspamd-Action: no action

Change kvm_put_apic_state() and kvm_get_apic_state() to accept a void *
instead of struct kvm_lapic_state *, so they can work with both the
legacy 1KB and the 4KB LAPIC2 register layout in later patches.

Update kvm_apic_set_reg() and kvm_apic_get_reg() to take void * with
explicit char * casts for correct pointer arithmetic.

This is a preparation for LAPIC2 ioctl space and extended LVT for AMD
changes.

No functional change intended.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 hw/i386/kvm/apic.c         | 48 +++++++++++++++++++-------------------
 target/i386/kvm/kvm_i386.h |  2 +-
 2 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/hw/i386/kvm/apic.c b/hw/i386/kvm/apic.c
index 1be9bfe36e..c1866c3939 100644
--- a/hw/i386/kvm/apic.c
+++ b/hw/i386/kvm/apic.c
@@ -19,48 +19,48 @@
 #include "kvm/kvm_i386.h"
 #include "kvm/tdx.h"
 
-static inline void kvm_apic_set_reg(struct kvm_lapic_state *kapic,
-                                    int reg_id, uint32_t val)
+static inline void kvm_apic_set_reg(void *regs, int reg_id, uint32_t val)
 {
-    *((uint32_t *)(kapic->regs + (reg_id << 4))) = val;
+    *((uint32_t *)((char *)regs + (reg_id << 4))) = val;
 }
 
-static inline uint32_t kvm_apic_get_reg(struct kvm_lapic_state *kapic,
-                                        int reg_id)
+static inline uint32_t kvm_apic_get_reg(void *regs, int reg_id)
 {
-    return *((uint32_t *)(kapic->regs + (reg_id << 4)));
+    return *((uint32_t *)((char *)regs + (reg_id << 4)));
 }
 
-static void kvm_put_apic_state(APICCommonState *s, struct kvm_lapic_state *kapic)
+static void kvm_put_apic_state(APICCommonState *s, void *regs)
 {
     int i;
 
-    memset(kapic, 0, sizeof(*kapic));
+    memset(regs, 0, KVM_APIC_REG_SIZE);
+
     if (kvm_has_x2apic_api() && s->apicbase & MSR_IA32_APICBASE_EXTD) {
-        kvm_apic_set_reg(kapic, 0x2, s->initial_apic_id);
+        kvm_apic_set_reg(regs, 0x2, s->initial_apic_id);
     } else {
-        kvm_apic_set_reg(kapic, 0x2, s->id << 24);
+        kvm_apic_set_reg(regs, 0x2, s->id << 24);
     }
-    kvm_apic_set_reg(kapic, 0x8, s->tpr);
-    kvm_apic_set_reg(kapic, 0xd, s->log_dest << 24);
-    kvm_apic_set_reg(kapic, 0xe, s->dest_mode << 28 | 0x0fffffff);
-    kvm_apic_set_reg(kapic, 0xf, s->spurious_vec);
+    kvm_apic_set_reg(regs, 0x8, s->tpr);
+    kvm_apic_set_reg(regs, 0xd, s->log_dest << 24);
+    kvm_apic_set_reg(regs, 0xe, s->dest_mode << 28 | 0x0fffffff);
+    kvm_apic_set_reg(regs, 0xf, s->spurious_vec);
     for (i = 0; i < 8; i++) {
-        kvm_apic_set_reg(kapic, 0x10 + i, s->isr[i]);
-        kvm_apic_set_reg(kapic, 0x18 + i, s->tmr[i]);
-        kvm_apic_set_reg(kapic, 0x20 + i, s->irr[i]);
+        kvm_apic_set_reg(regs, 0x10 + i, s->isr[i]);
+        kvm_apic_set_reg(regs, 0x18 + i, s->tmr[i]);
+        kvm_apic_set_reg(regs, 0x20 + i, s->irr[i]);
     }
-    kvm_apic_set_reg(kapic, 0x28, s->esr);
-    kvm_apic_set_reg(kapic, 0x30, s->icr[0]);
-    kvm_apic_set_reg(kapic, 0x31, s->icr[1]);
+    kvm_apic_set_reg(regs, 0x28, s->esr);
+    kvm_apic_set_reg(regs, 0x30, s->icr[0]);
+    kvm_apic_set_reg(regs, 0x31, s->icr[1]);
     for (i = 0; i < APIC_LVT_NB; i++) {
-        kvm_apic_set_reg(kapic, 0x32 + i, s->lvt[i]);
+        kvm_apic_set_reg(regs, 0x32 + i, s->lvt[i]);
     }
-    kvm_apic_set_reg(kapic, 0x38, s->initial_count);
-    kvm_apic_set_reg(kapic, 0x3e, s->divide_conf);
+    kvm_apic_set_reg(regs, 0x38, s->initial_count);
+    kvm_apic_set_reg(regs, 0x3e, s->divide_conf);
+
 }
 
-void kvm_get_apic_state(DeviceState *dev, struct kvm_lapic_state *kapic)
+void kvm_get_apic_state(DeviceState *dev, void *kapic)
 {
     APICCommonState *s = APIC_COMMON(dev);
     int i, v;
diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index 5f83e8850a..ecf21c2cc1 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -56,7 +56,7 @@ bool kvm_has_adjust_clock_stable(void);
 bool kvm_has_exception_payload(void);
 void kvm_synchronize_all_tsc(void);
 
-void kvm_get_apic_state(DeviceState *d, struct kvm_lapic_state *kapic);
+void kvm_get_apic_state(DeviceState *d, void *kapic);
 void kvm_put_apicbase(X86CPU *cpu, uint64_t value);
 
 bool kvm_has_x2apic_api(void);
-- 
2.43.0


