Return-Path: <kvm+bounces-71183-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6Dy3FLHLlGluHwIAu9opvQ
	(envelope-from <kvm+bounces-71183-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 21:12:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BC56514FE04
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 21:12:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3B04E3053BF7
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 20:11:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41A0E378829;
	Tue, 17 Feb 2026 20:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xnPBT34R"
X-Original-To: kvm@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010043.outbound.protection.outlook.com [52.101.201.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7F73783BA;
	Tue, 17 Feb 2026 20:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771359081; cv=fail; b=g64Ewjeh0phlqNklTIg8FU2yzQY9uDuZuDoP7SPVlrUl20LyloA3C4bQz2z1IoLlku3BsIygiOXJByNGgSIzCwstd80manRJu/mTSVmAGaH+6CdT2mGFiEtQ2YPuR1MkgynXo3e52TKpHwZAH4W5m+4sK1p6mcmsNrlTmLGyZN8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771359081; c=relaxed/simple;
	bh=kOIADqZe1e5oV0D/oC1VH8p5lbqSvuQP7AC4ERqur9Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ThcYWDK9JXMJeNa7qsLJV4hSUBSMyqag/5jqHX3b7Vcf2cP8IFZrD3OgdftDXEU4PDZXn0fpyEZZk24hBlU0ndSoZyMkJQaO9Vyo3sjtOLb1QorJowD7CKllLaiNqZaOKkYiAg5vlgmahiMlIqe7z3e7yV5Rv4OlEzFFW+Wi/Qs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xnPBT34R; arc=fail smtp.client-ip=52.101.201.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UHXOPHCrFS9HArI12bXagThY29uAi96P0xwq4P1cpdE9CQOFWmf61lKomMkx34neOc8+2JWArIrS/to2nTvkxSGZZ67PPl2gQE94GoY9SKCalOIhR7KiQwq2LYwWH8S7tnVm4faBG/+VWx+tS/4/93/W9dcSSa/6B8+K3uZjw2a8XgXw4c5etz/ZjqFCu6LCpP4F0L9VpmTAb47d7+m8dNKV+0L9o+JgB7jRkyOlCaVMUNPI7Ofk4BC+PlrM3h1ByXg9TZGHdK+pbkI9gVpUtgvaDhLdsisWOMHCMEysisg50Pjx8Ib1ACg4hMx+T5IrG7G40kVkgP6ID7ISiihI8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=//F2GhOiDp7dpoyo4ouIb6eodIxceJSkpp/KMnoztT8=;
 b=WW5TTnLDVLgNcbXi9zBsE1FUok1S2Djvt9cZLzdhCuO+XTzFg5/gCmz4PtWtgpI96dQv5LzXwrdgWOp/DicdUZlbZOHMH4M1zfW3oQnCwHl6pJnK/aYXVSbfY27TBNiWn9uNCGKTr07Y9jBJnlb/nVhRPLT+MBGBc2z6Rk0ARC5bNA1Ms5rkfoeupHnUnGzcacOTaG/Flg9tda/CxwhtJRvueeWA7yZaCtz/DojTHjBkYC5pvku5EiakWFuWLY5aXNN8Eu3ooiOoaFNpPdzxnWn8naasI6ZFVFQS8moIgT6jRpJNL2t7rwGI+ABoSQwK1dzr1ZRXWmYB12vti8zA4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=//F2GhOiDp7dpoyo4ouIb6eodIxceJSkpp/KMnoztT8=;
 b=xnPBT34Rhrk7ThJqRPqLsPsgq4y25YJmEviDIsIbuc0MMLz/ylc68GP1Pe3ewM9WgPc/ugH5X+DTXnCCLE0DeG/hzpZVI8/fziP7wJPc1mcu6ekKgh35lpErTDrkVbLkJ59s9JVa/121EZqDEGgsmShA474jgflHhMtCWnOexh8=
Received: from MN2PR12CA0027.namprd12.prod.outlook.com (2603:10b6:208:a8::40)
 by MW4PR12MB7192.namprd12.prod.outlook.com (2603:10b6:303:22a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Tue, 17 Feb
 2026 20:11:15 +0000
Received: from BL6PEPF0001AB57.namprd02.prod.outlook.com
 (2603:10b6:208:a8:cafe::1c) by MN2PR12CA0027.outlook.office365.com
 (2603:10b6:208:a8::40) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.13 via Frontend Transport; Tue,
 17 Feb 2026 20:11:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0001AB57.mail.protection.outlook.com (10.167.241.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Tue, 17 Feb 2026 20:11:14 +0000
Received: from nigeria-2635-os.aus-spse (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 17 Feb
 2026 14:11:12 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <peterz@infradead.org>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <ardb@kernel.org>
CC: <pbonzini@redhat.com>, <aik@amd.com>, <Michael.Roth@amd.com>,
	<KPrateek.Nayak@amd.com>, <Tycho.Andersen@amd.com>,
	<Nathan.Fontenot@amd.com>, <jackyli@google.com>, <pgonda@google.com>,
	<rientjes@google.com>, <jacobhxu@google.com>, <xin@zytor.com>,
	<pawan.kumar.gupta@linux.intel.com>, <babu.moger@amd.com>,
	<dyoung@redhat.com>, <nikunj@amd.com>, <john.allen@amd.com>,
	<darwi@linutronix.de>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH 4/6] x86/sev: Add interface to re-enable RMP optimizations.
Date: Tue, 17 Feb 2026 20:11:02 +0000
Message-ID: <d83cf19bea66c4b4b83be578b6270829b03d81db.1771321114.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1771321114.git.ashish.kalra@amd.com>
References: <cover.1771321114.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB57:EE_|MW4PR12MB7192:EE_
X-MS-Office365-Filtering-Correlation-Id: bf240555-0730-4fa2-b0e2-08de6e60b3f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CsbCerqTpXfl/rJYEqr6/Qw7gvMYY/F6yuNqNvK8iYTRxKW2rv1rUGtAmgHH?=
 =?us-ascii?Q?iSq2cJGboisL5rKn0H34KxOkMAILSygMhPaq/hscK97IhTi58Fkg+9lv/Jx5?=
 =?us-ascii?Q?w8prkiyZCCjAC46wZHIyVT28Vtg6+Xsc+/Q9e9ngpskiePoQyZxp74+hARW8?=
 =?us-ascii?Q?SMogIucoLgtJWB1vfbP3HhvTeVN8rbAZ9EJZk3L5VfmrrJGezwttGauK3gnz?=
 =?us-ascii?Q?vH810u5KnAJ4oAAeP+WF6JyfTWeiUWwLHV1VMZGPJYfdbLoi5UuO2anvCmop?=
 =?us-ascii?Q?6jaDJHUSFxw40fPvcyL5zf6RZlmJ91PsWwFEcBdNJ4pemHBk1Kt23LTG5y2R?=
 =?us-ascii?Q?RmNJ56jfC3R/ODj9tYMO2JaHGEUzdkJbhvAZFUniCUdUg66eqApZGxuyGh3R?=
 =?us-ascii?Q?QSrpaBIgqDjCinWp1wNM4Fu0vaZvP2Axv5JW1TDbVKt5aQrWXIUFzokdJcER?=
 =?us-ascii?Q?ocxe9hrNwwHvTf5fc3QK6SNs18XQlb+eBhOKlquBkMmtXbkJ1DNrglf5lHhM?=
 =?us-ascii?Q?DKnhWTStyXW4MHc2kSfp42zo538VuHVsotnVv7yPmi/r3hLeU3UonnfN8gdv?=
 =?us-ascii?Q?3b+RXuqF3vWoypRYGmKggmnxmkG+2Dx7t7+U+PLjsMYI7Rgg87CN7BUNIrBT?=
 =?us-ascii?Q?/1j2dAAUbhgrejv2tTr0ZlsA/16Mn28gsFf5JBCe2uLbeb+zZj9boEr/5KLb?=
 =?us-ascii?Q?3thg5kVCkJZkrU36Do2zKK/I2vEKs1/Iv9g4FrwbgTXHWmeI2qb7NAv2FmXa?=
 =?us-ascii?Q?7W9hmLba8pKZF4ez9Ho5Wf0FDhZqbH79TzCur6vE5w8bMW02q2GNIyaERD0O?=
 =?us-ascii?Q?XVAn5zPi0yB+XCd7lSE5/uUsKD5TlEAMFLRukCLcMeipQFf1S5y98XUFvOcr?=
 =?us-ascii?Q?LTJxDPiSy2GnxIwq7l1ITctzmIQJuZloM1eEbzDqUmgIYyzZeO0IWIr74E5y?=
 =?us-ascii?Q?4mY3R4+Ev7yADwo0I5PwXnKqUCH8fpPKrvGx1AphZB19cahqrstAHK4os+Fo?=
 =?us-ascii?Q?I4PcDBrEIEdKXEY4fciGgEu+xg7kP3XwLG1dwsid5jeAgSICQ2i7PrM38ipv?=
 =?us-ascii?Q?4B+pnyl7eLCGRPWgwY8M4qTQfMeqHWG3O0jAmJpbsH/AzkgkEW3H6M0co0Ov?=
 =?us-ascii?Q?4HyZpoxukvG2aUiPn5jjfAgvi0X7aksrKdspyU80SZvLuynE3GrY8wIlvz/D?=
 =?us-ascii?Q?5mjDeDakDdKR1FqgC+ocVdDHTfVGXrQTPuHbR7pTQ4Nah0XzbyJgEa6m0axn?=
 =?us-ascii?Q?+G+fL6oqQPJ6iCjju1U6YY29IdfM5S3oJfS+fVdxYcW2PcMbN18H5hbyoNZM?=
 =?us-ascii?Q?M1GZY2uPP1LmXAuy2zfgA5iZ0DtbbhEBq9faKou7P8rj+l21cKoFFNrIjcIE?=
 =?us-ascii?Q?9dp20E3d3vRhJtiWvsDTgSsBTAMYpeO4gHCmeNWnDH3fuYnwEKC7VzZew4Ws?=
 =?us-ascii?Q?691oxayM160PYSnTrTL0KwFB9Jby5B2mX8RT3LMQeqpUeA+Se9Bl8BopzAAH?=
 =?us-ascii?Q?hrnVMHvO4eRoqyXH/PtYrd80c7HnOwLg6e4TeISGk5VPud1cIUPd7DvAJceI?=
 =?us-ascii?Q?eQYGNQHsDv5eUMXFTPfJT87xhYZnsNHx7+WPCflRWtlhHObnGvq+6HzFrijA?=
 =?us-ascii?Q?tScnqBr3ELY5K7g6IwtlAgd/YO/WT6ttTWdMYU4hTJ1Yb/NE/Ds1M6OTVR4W?=
 =?us-ascii?Q?rR7i68ySWxSELGBIfOXn1+Fic1g=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	kw5BaH90D9LKFj3x/eoTwlPfYR1CDXbI7g+K5OiA3r69iDC5bQ0WT4czjXKoB98Silqx8IJ+esyhJrXhAu7BGyRgVe0XkIx/Ak7F0wP/EL88iM//mf9+DaSzA6ifSoXgMWLwnRdgQ5AfnWRyHFu3qMnZ5ASmVyWLU1PV3+a/TlEhIVw55ptmab/FmGHkHZjAiL7cPV2+Ia7dDoNUEmefiGkSuGe3uBOlGPWgV4FmiVQovFFXH2L7/fOG+mZhV+sRWlbxhAjWqKjhw8yf3S0DRcKTCq2UZF4HEqhcUyrTEZX+uhW9rkXDLHd9dgkdeesIgvJ9kI23FBhv536lPyIpdmhInZ1O6uYeaHVXUfyR/B08Jq+5tT41Fe8BaF0tTDeTzlyda2ji5etIg8qywkOVKLx5DXAdLRfgZkhuiF6WhRdIiOGBtxO9YtkX3JzRtEX6
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2026 20:11:14.7823
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bf240555-0730-4fa2-b0e2-08de6e60b3f4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB57.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7192
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_TWELVE(0.00)[33];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7];
	TO_DN_NONE(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Ashish.Kalra@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71183-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[amd.com:+]
X-Rspamd-Queue-Id: BC56514FE04
X-Rspamd-Action: no action

From: Ashish Kalra <ashish.kalra@amd.com>

RMPOPT table is a per-processor table which indicates if 1GB regions of
physical memory are entirely hypervisor-owned or not.

When performing host memory accesses in hypervisor mode as well as
non-SNP guest mode, the processor may consult the RMPOPT table to
potentially skip an RMP access and improve performance.

Events such as RMPUPDATE or SNP_INIT can clear RMP optimizations. Add
an interface to re-enable those optimizations.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/sev.h   |  2 ++
 arch/x86/virt/svm/sev.c      | 17 +++++++++++++++++
 drivers/crypto/ccp/sev-dev.c |  4 ++++
 3 files changed, 23 insertions(+)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 0e6c0940100f..451fb2b2a0f7 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -657,6 +657,7 @@ int rmp_make_shared(u64 pfn, enum pg_level level);
 void __snp_leak_pages(u64 pfn, unsigned int npages, bool dump_rmp);
 void kdump_sev_callback(void);
 void snp_fixup_e820_tables(void);
+int snp_perform_rmp_optimization(void);
 static inline void snp_leak_pages(u64 pfn, unsigned int pages)
 {
 	__snp_leak_pages(pfn, pages, true);
@@ -677,6 +678,7 @@ static inline void __snp_leak_pages(u64 pfn, unsigned int npages, bool dump_rmp)
 static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
 static inline void kdump_sev_callback(void) { }
 static inline void snp_fixup_e820_tables(void) {}
+static inline int snp_perform_rmp_optimization(void) { return 0; }
 #endif
 
 #endif
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index a0d38fc50698..713afcc2fab3 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -1305,6 +1305,23 @@ int rmp_make_shared(u64 pfn, enum pg_level level)
 }
 EXPORT_SYMBOL_GPL(rmp_make_shared);
 
+int snp_perform_rmp_optimization(void)
+{
+	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT))
+		return -EINVAL;
+
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
+		return -EINVAL;
+
+	if (!(rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED))
+		return -EINVAL;
+
+	rmpopt_all_physmem();
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(snp_perform_rmp_optimization);
+
 void __snp_leak_pages(u64 pfn, unsigned int npages, bool dump_rmp)
 {
 	struct page *page = pfn_to_page(pfn);
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 1cdadddb744e..d3df29b0c6bf 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1478,6 +1478,10 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 	}
 
 	snp_hv_fixed_pages_state_update(sev, HV_FIXED);
+
+	/* SNP_INIT clears the RMPOPT table, re-enable RMP optimizations */
+	snp_perform_rmp_optimization();
+
 	sev->snp_initialized = true;
 	dev_dbg(sev->dev, "SEV-SNP firmware initialized, SEV-TIO is %s\n",
 		data.tio_en ? "enabled" : "disabled");
-- 
2.43.0


