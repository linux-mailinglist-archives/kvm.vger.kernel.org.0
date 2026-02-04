Return-Path: <kvm+bounces-70147-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YA85Byj5gmm2fwMAu9opvQ
	(envelope-from <kvm+bounces-70147-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 08:45:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 65595E2C88
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 08:45:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A6026304B4F8
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 07:45:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44F6F37C11B;
	Wed,  4 Feb 2026 07:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="phXrn6VN"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010053.outbound.protection.outlook.com [52.101.56.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DC32192FA
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 07:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770191124; cv=fail; b=WKx+l40DN4X9LeaQ9xLVYZ/ORkhiAHQxK7yFkkwZXNhVpGrz35I/LLIixPUPZy+Q92YZF9ymMryXScj5rn6vtqxhYau/Q0NjEi6ynuoZ7gu/ZWJoG3NhY95sW+Yfd1LR9tt62OVipPGylCrdp2DwWwiJ4qJFYPvdnhHim7MvK7I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770191124; c=relaxed/simple;
	bh=iBg6N4yee9wsWZ3WZ31u4yGLp4tiGRoHfy9Xvm8MxvI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GZp66r/QG6W57on6Bvkv+dMQfTeAmFgTfZmi7eStIa5dUW8LnhJ4xnWvywsronGbHj12eOUM2GrZZPZTHTy8wk4I7Jb1qV2ALiuuVgMLmUw3w3O7TlO+JZCGLUzfx766faAzOzdCgBIwJuuFepgl26O1IbuD5ChLU/UIsTSyQUI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=phXrn6VN; arc=fail smtp.client-ip=52.101.56.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uLzROBWvoMhIdJ/Td2RB1gu9H9fZ2d2NBwMNvOlWjaqL9LTzqaHlmcYdMDdekW2Uda1k5zRYduCbqJNKuzTF1/wK+8FWgm2MeHyOFXQmHomHi8AXqpsZp6TMZUHLDfu5xIFp0a1geSR1InnQnbLXrgj3AIp5Nfh3QMYI4x0SL1l+LM2ogiss0oS8/wfknJ5XDCyRoGJqPEggGHimhAgWGfz/k5Od8th+dxHAfbzwf/hV52IqUaTHS5baRy35ehOQTvrKTFBWrhKGfZ+EIZDoNxDjNNtL1V2mk6YRvhZnsCNF9ojbXTHDJRF1RJjWc3y3w94rRzfM2NEYbG+LzMZw8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ed1QI12pKj77V0bpPlT3C/xcaG4hVmQEVklOenQG9eg=;
 b=lbeM3NkmzNnCX4MmTvDf0UUwrQW42FuH69ew/09u/Xo4MGrr4RgxHu2lMhjWzRYq9e5UMzpzYtBv+RMTnqE7qCGGGkT6zc6tkdnYGEhv71MqZqmdKEFV056IGVbREz1Zgw29ERmno11gK8tRhXCiiwJu3QGwrhtdQtvvSkGPwgYDBEYnIU77q9IwbNxzypbAwcny2XiEoXzZMAP0k82B5Y3pe5kbZqieIuCujOGG/S+sC0fxg+up26u9YHMkVOZtAV0svqhjcNZvMcUcERqIsXUJ8qP2Wq3OPS0eR/buiqCCnzM2+4x0MYCmHfuMAUEU8xJsVqbrlAXikMDk8ZgqYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ed1QI12pKj77V0bpPlT3C/xcaG4hVmQEVklOenQG9eg=;
 b=phXrn6VNXcCHj+1YCojhpGq6F5drOt9j8jsW7UeSEzm7XRW1CjLNwu6Q03guWQsNiiZn2O9HoKOkvVTAptSZO52W6iIsDm6XXyK7HVgqhsqiFlWHXcwa5YxOqTwqf/Xe86bo0z0PWoa8eXp6OzZH0Cz4kvi4NQes8i0Jny87CDo=
Received: from SA0PR11CA0112.namprd11.prod.outlook.com (2603:10b6:806:d1::27)
 by CY8PR12MB7169.namprd12.prod.outlook.com (2603:10b6:930:5e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Wed, 4 Feb
 2026 07:45:19 +0000
Received: from SN1PEPF0002636D.namprd02.prod.outlook.com
 (2603:10b6:806:d1:cafe::cb) by SA0PR11CA0112.outlook.office365.com
 (2603:10b6:806:d1::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.13 via Frontend Transport; Wed,
 4 Feb 2026 07:45:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF0002636D.mail.protection.outlook.com (10.167.241.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Wed, 4 Feb 2026 07:45:19 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 4 Feb
 2026 01:45:15 -0600
From: Manali Shukla <manali.shukla@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<kvm@vger.kernel.org>, <x86@kernel.org>, <santosh.shukla@amd.com>,
	<nikunj.dadhania@amd.com>, <Naveen.Rao@amd.com>,
	<dapeng1.mi@linux.intel.com>, <manali.shukla@amd.com>
Subject: [PATCH v1 2/9] x86/apic: Add helper to get maximum number of Extended LVT registers
Date: Wed, 4 Feb 2026 07:44:45 +0000
Message-ID: <20260204074452.55453-3-manali.shukla@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260204074452.55453-1-manali.shukla@amd.com>
References: <20260204074452.55453-1-manali.shukla@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636D:EE_|CY8PR12MB7169:EE_
X-MS-Office365-Filtering-Correlation-Id: a0e2a724-4b0b-42ea-ddd1-08de63c1582d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3nqcSF0+BaOtmCx28J+A1BTHUUkmtBCGLlGHivJ85/jCem6goz3F4AULsJ1I?=
 =?us-ascii?Q?0K1Oq0g9+qX5FyNCyC62G+bTXX/AXvAcZeUa4mnkMOQR4wGl+a58J135z7MN?=
 =?us-ascii?Q?IbYqLDiSNvMnN93NaT1VujXG5dkbWVSE7fT1QnYP0MnAE+EduDxvziTH5LKW?=
 =?us-ascii?Q?JPAJ4eEX4uyYro8UBmkONOFavOKYHzstY8zAm70ILTP1rdmeN3JMUAAs+0+2?=
 =?us-ascii?Q?OQPVNyZNXwDBnrc+JP0P6xANZKZB01F5vAtDebZGBWZYQfBl6M3MJAi01QAt?=
 =?us-ascii?Q?V4D0DPZ5fmc0iRe5n72Czq3m1GgsmWpTDWccTDCnqLyLH3F0CY9hwN8Nmaad?=
 =?us-ascii?Q?FvW0f0jfJSB/e15oOAP/IWSPOJzk3qDfHCTgTZ6quglfs3wEpujrE0z1VYxc?=
 =?us-ascii?Q?e0cNTmbnD26yfiE1l0ic96tjdZbsbUU1zzb4uHaqTvFA392kFZnp78HE1b7T?=
 =?us-ascii?Q?cO5Mfxxqb9QKYEfpFY6kW2AVIzvVp5jJ+EbYr5OJ/P7mrLCOuQRhGVYzbROc?=
 =?us-ascii?Q?HWvY3tVvPSlLDlngnkAhulgQ7DkPXv9QQZw2Wubaanvihj6GmVG3oI1LFjwn?=
 =?us-ascii?Q?NX5+j60NpgMH0rXO3yu6JjCjsiQMH6eOoI1gg3qNjmm2MFGvKeUlEsiAotpv?=
 =?us-ascii?Q?pnw9De6z6WRql+9SCb2+WxiCopOPpVvQspS4je4coYL+D13vWrbtaSy2NlUF?=
 =?us-ascii?Q?3uDDe7KxYxWlSnKDntVyE5xv4z50lNHyY355Y8+XEQc/6G/cK68Remc29w6B?=
 =?us-ascii?Q?HELd/iaKxFMl6QeOhhllEroC3tYTcNytEKfC8z8n7fxTD29FYsPDc0lFa9Tt?=
 =?us-ascii?Q?y2EpRVbyLcryFN3dfMbY6yoqlm4cDG91S3eBwOSFMReUoAwd/WM5yu4yRqNE?=
 =?us-ascii?Q?fKFeETbGdnLX4SoyXM80nlLTnP9j70fODT9bAaeyMHdcJHl+k53lJc/HJ5CI?=
 =?us-ascii?Q?8VCoYBVqVlX/IgBaUY5Sbfm9qntEklTJ6bdO8ZjRxIc3mp6mm/tQJfpHqeHM?=
 =?us-ascii?Q?Ultdy7Lqin9H2KTYWsM9khuOvzT197uWUPHCEyzu3Nn8/Bf8KSEY8aU/q+4g?=
 =?us-ascii?Q?oEwxr2mvlXqh1n49IiVNjlDKuYTQYh/BnIn0DbpJySC4lhqpztzLMI0pCXcN?=
 =?us-ascii?Q?vXO4K28u+G1j0LvYWUi8YBn+6/Mc4oJCbTqhDM51W1AsIit8aGXUCOjMOEU8?=
 =?us-ascii?Q?zNjzlMoyWLdEJ/pkLgXiwqIxKi0hkOWBn/Hc/PTESUU2dRsrGF+T1IFJO06P?=
 =?us-ascii?Q?FzWAMXw6eA2awRnjbJjQ5d/LDH/CpU/66wX8XpMyDw1xgnQAfjvrxRHbsZYF?=
 =?us-ascii?Q?Gl3sgyd3h+GhdheEYhoJX98hRwQt/VEM4WiLZBTriBu36tPLaJFjP1eGYSrM?=
 =?us-ascii?Q?EWvvU6ITYZOPqSBADVzhBQxT8AG77bK55FlyoVkDkgCDWdCPpIzhGxvgmgYK?=
 =?us-ascii?Q?bA36TTebiiNwPi4c0aHQsZA6TDJgo+Kyxya56I0aFSScqgFb1Vji7SNj8OXN?=
 =?us-ascii?Q?O2Jfq0VbMfVmIAhzQQAUI4O7zW1ulGpaZdhlHP+XvB6IEKShXMJtv6zaNUC7?=
 =?us-ascii?Q?/z9w2QqXkSeLiEJpmVWI8d/xOltxEzgIiic3Qx903Mjs76+QP/OIid1SRFK2?=
 =?us-ascii?Q?/76/PDevgHpH50DJJKID++VmZodnT+oDofJdYWxNorD7lCk1HIUhz9rgqE25?=
 =?us-ascii?Q?VilFwg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	DxB7fQyf7hdh3KF8JW0ieYE+NCNedyrmaDpj+hI7laC/P1MajrUcbWyqT+FxSfEMKshl5yt2Bn0o4szlfBoxLmI4NzqDWv7JU1yInCbmNnEZeR5lu4UbFHiQuAgSHqs4vql+9dwMWOupoUbjLL5DznmWPXn9ldzhohEBfDcjHpVFomt0+SeoxTQjMb7LiWd4PVs9O9UVroS2ehfeNtqWrBFL4gCiYHQKq7p76R8lI6XRzsAsN02lp6+Iy6+eL2PHGLTIGqmwsaguA4TiK/LVW6w/C1lJhdK8DOmhxHpXD1/W7AFBansCekJO6mNfcII+r9QeDglC8XhwB0Ir8tLhEBIgalOruJSR3xw5T7xhXgZOURigQqNaPvmjWFENbm7sU3Uqsp+qIQb/yPv5qJPKgA1jzlTfF559l40n4vlIzcgMAAQG+RVhFBY3w4aLqBFQ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 07:45:19.1936
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a0e2a724-4b0b-42ea-ddd1-08de63c1582d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7169
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70147-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[12];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[manali.shukla@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,amd.com:dkim,amd.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 65595E2C88
X-Rspamd-Action: no action

Add lapic_get_max_extlvt() to retrieve the maximum number of Extended
LVT registers supported by the local APIC on AMD processors.  The count
is read from APIC_EFEAT[23:16] (offset 0x400), per AMD APM Volume 2.

Extended LVT registers provide additional interrupt vectors beyond
standard LVT entries, enabling features like Instruction Based Sampling
(IBS). Current AMD processors support four extended LVT entries, but
future processors may support up to 255.

Wrap lapic_get_max_extlvt() with kvm_cpu_get_max_extlvt() for use by
KVM code. Subsequent patches will use this helper to configure the guest's
extended APIC register space.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/include/asm/apic.h     |  1 +
 arch/x86/include/asm/kvm_host.h | 10 ++++++++++
 arch/x86/kernel/apic/apic.c     | 17 +++++++++++++++++
 3 files changed, 28 insertions(+)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index a26e66d66444..d45696563a4e 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -128,6 +128,7 @@ static inline bool apic_is_x2apic_enabled(void)
 extern void enable_IR_x2apic(void);
 
 extern int lapic_get_maxlvt(void);
+extern int lapic_get_max_extlvt(void);
 extern void clear_local_APIC(void);
 extern void disconnect_bsp_APIC(int virt_wire_setup);
 extern void disable_local_APIC(void);
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ecd4019b84b7..df642723cea6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2461,6 +2461,16 @@ static inline int kvm_cpu_get_apicid(int mps_cpu)
 #endif
 }
 
+static inline int kvm_cpu_get_max_extlvt(void)
+{
+#ifdef CONFIG_X86_LOCAL_APIC
+	return lapic_get_max_extlvt();
+#else
+	WARN_ON_ONCE(1);
+	return 0;
+#endif
+}
+
 int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
 
 #define KVM_CLOCK_VALID_FLAGS						\
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index d93f87f29d03..90992ae4852a 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -253,6 +253,23 @@ int lapic_get_maxlvt(void)
 	return lapic_is_integrated() ? GET_APIC_MAXLVT(apic_read(APIC_LVR)) : 2;
 }
 
+/**
+ * lapic_get_max_extlvt - Get number of extended LVT entries
+ */
+int lapic_get_max_extlvt(void)
+{
+	u32 reg;
+
+	if (!boot_cpu_has(X86_FEATURE_EXTAPIC))
+		return 0;
+
+	reg = apic_read(APIC_EFEAT);
+
+	/* Extract extended LVT count from bits 16-23 */
+	return (reg >> 16) & 0xff;
+}
+EXPORT_SYMBOL_GPL(lapic_get_max_extlvt);
+
 /*
  * Local APIC timer
  */
-- 
2.43.0


