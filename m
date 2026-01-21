Return-Path: <kvm+bounces-68783-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IFgULZ9CcWn2fgAAu9opvQ
	(envelope-from <kvm+bounces-68783-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:18:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 443485DEEB
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:18:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 27BD450EA48
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 21:14:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99D23426690;
	Wed, 21 Jan 2026 21:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tt9HLdux"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010010.outbound.protection.outlook.com [52.101.46.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9EC42983A;
	Wed, 21 Jan 2026 21:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769030017; cv=fail; b=C9f30lKnWPRkZ8hgOQ5y7XkeUTsB0PTLhDJhuifI3Cmsy2mse6KN2Eor2MRXRcnBkLL5HaccxbaI2AiCk/W4jLshvvqrFHbL4wdnsDoINHCFj1fVhCahFQPwx96tZ1l/uoBjAzZd8GHe4VZS/kqQ8yZarssk0c+Mfr+ATVLtbcE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769030017; c=relaxed/simple;
	bh=YNHJIyu5XLxzQQcbDOlHz4lAV40riJ3AydCjhHhfrow=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rnr4RFG2tXXNgpMeoShFCF8KyQcI1oWd3eX4EKYTP8+4AkiEir67IdzyQWyJu4JpLHn8EYH6Ducx/GDAgH6d5UxFkhfLFCfkfxuTRWG9AcSCeEp0/Fl1KVyIJha4gKv7rCq3AE/wBnUPfWAUfxp7mkURYgtNalFspgaOUZSO/Yk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tt9HLdux; arc=fail smtp.client-ip=52.101.46.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gI4Dq6dKkUk47JBNRu2Y/v8nj4KvwQXs3JT7fnXq2dbYJy81PWHUxFI/KGzMoz8LPmZDFV/MGTxUhf/06phPm6RIYdOIKv4xGGGSPRkHlw1tumI1OCbPYOfomEWkXy9E0inKRjGmArZP94yhTL1wpQggm8VBqSA2B5HSYlVxs5Al5i1ad0l21pkaW8K/BJ8gXFfPmSTWYNWG2bY4p9OLZjAQslprnLvDjA+EOCzV3Hx4bu9LnPngZdF4uDExJihJuBGEUpJlOZwh6sDom2yewfAAZats3G/BUc/nzPcCFetJYm+URky7Vm34V9t1bxzeQPfKeOzzJXGcJczaWrsbZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xk33vo0tJ3rkkIrL/9jLu72NVf+yXfzEmmi7ECxyveE=;
 b=xUXi778cCvMyAmA1XUgiXIZt2uKmGwHBooHn2h3XVQ+/NyFnmhZz7RavqBoz1mWxIZvZSsb0zY0/snX/cPn+Z6OVATebhpOPPIsdM4YjbkQ75EwWSoMkiLLovpiUeOZIa0tvMJPnnIVd8/56/+E/eAocp/ihvi6X3AAJUKEX6iNaEuNxT1kSFo5fJWdtVNe2R4l2aiM569flXyWntL70PQCXr1F8ORRjM8l0HQI5GCYH5Hob/O2m/lACHr8GdC689FDYhb1N2SuJ+607ppfSCciYmioPTsf85xVV1F7wDyQNPqqPDIfWFUUgwV1291pVHCjBMuFzc1La/0iiGsySxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xk33vo0tJ3rkkIrL/9jLu72NVf+yXfzEmmi7ECxyveE=;
 b=tt9HLduxKCncwSxXaP0fSw/pW6t9zYSRGxMPzWZSlBLc0eEyzkWu6+aO3T4HQdYSK2if41h/iula5EKpzHp6iB4hLOGDtAKRNHR125Q8H8Ff9oGA85ASK1wRj263/Pz9MlG9nmE2U2vij0Sy1rF4LPUgtcL7B101f6cA+QZlkjk=
Received: from SJ0PR05CA0103.namprd05.prod.outlook.com (2603:10b6:a03:334::18)
 by MW4PR12MB5604.namprd12.prod.outlook.com (2603:10b6:303:18d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 21:13:29 +0000
Received: from SJ1PEPF00001CE7.namprd03.prod.outlook.com
 (2603:10b6:a03:334:cafe::fe) by SJ0PR05CA0103.outlook.office365.com
 (2603:10b6:a03:334::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.5 via Frontend Transport; Wed,
 21 Jan 2026 21:13:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CE7.mail.protection.outlook.com (10.167.242.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Wed, 21 Jan 2026 21:13:28 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 21 Jan
 2026 15:13:27 -0600
From: Babu Moger <babu.moger@amd.com>
To: <corbet@lwn.net>, <tony.luck@intel.com>, <reinette.chatre@intel.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <babu.moger@amd.com>,
	<tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <peterz@infradead.org>,
	<juri.lelli@redhat.com>, <vincent.guittot@linaro.org>,
	<dietmar.eggemann@arm.com>, <rostedt@goodmis.org>, <bsegall@google.com>,
	<mgorman@suse.de>, <vschneid@redhat.com>, <akpm@linux-foundation.org>,
	<pawan.kumar.gupta@linux.intel.com>, <pmladek@suse.com>,
	<feng.tang@linux.alibaba.com>, <kees@kernel.org>, <arnd@arndb.de>,
	<fvdl@google.com>, <lirongqing@baidu.com>, <bhelgaas@google.com>,
	<seanjc@google.com>, <xin@zytor.com>, <manali.shukla@amd.com>,
	<dapeng1.mi@linux.intel.com>, <chang.seok.bae@intel.com>,
	<mario.limonciello@amd.com>, <naveen@kernel.org>,
	<elena.reshetova@intel.com>, <thomas.lendacky@amd.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <peternewman@google.com>, <eranian@google.com>,
	<gautham.shenoy@amd.com>
Subject: [RFC PATCH 03/19] fs/resctrl: Add new interface max_bandwidth
Date: Wed, 21 Jan 2026 15:12:41 -0600
Message-ID: <a4ca7d43100132b79adba85a4674c7b46b05bb8c.1769029977.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1769029977.git.babu.moger@amd.com>
References: <cover.1769029977.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE7:EE_|MW4PR12MB5604:EE_
X-MS-Office365-Filtering-Correlation-Id: 79b753ea-6ab7-4e69-957e-08de5931ec8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|7416014|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ApxvQg3Kc72T82WsUW6sIxFaTJJmmb0MzIg7eu3r9Ez3G4Emx/b22EPcdQ0F?=
 =?us-ascii?Q?QVFy6reQtUHsAZd6VUDojQYn0pKqZJxTwqA43JS5R57k//ItOwzipirJMAdT?=
 =?us-ascii?Q?C15GmlghIFUyucAlxYIv1Pv22hHlsClntgOah2454RUm18RSax2oZ5TFEl5y?=
 =?us-ascii?Q?p9nySdRvWFCQ75YNontbm38eAKcx5gy/EkKzUVoJ//9v/ImuDgTTP5dMiEds?=
 =?us-ascii?Q?kZ47vCJqTb24Z8A5Z8K4lWRf8jk97zgI+0n28Vag8VkTUl2YkWarbFwNd9fH?=
 =?us-ascii?Q?XBSDZP0ZbLd8woCeoO/tJn+808eyV8N/hL25QUp02BkY5P3Xf5DT+9l2ycuP?=
 =?us-ascii?Q?sNV9suaYjcixSuAI9fJIfkLDCCkIe1t5fCIjbD7v+VNMgLo6QWhFbr3vcpzl?=
 =?us-ascii?Q?+Q7OqRdjiehHNmMXAz51EpVVStBlyt5S+zbMTAnR5XGd7Psc402CUGEyhJZ6?=
 =?us-ascii?Q?PbnY+gQhaQyRg9NEQNrhwKqXjtxEcDgqEVbRpZ1Hg9tlH2/Uff1D1dr1i0bl?=
 =?us-ascii?Q?ZTlWxZZKkppZjlMAWs9Q7CCz4qOitIN+FIiLzirAg3dFurK2lc2x0tReYH3P?=
 =?us-ascii?Q?6IfVClZifgediOejDVRBa5k1RolWOWjxh1mkAc8+kjgPEhxSuRYMnqIPoSif?=
 =?us-ascii?Q?dplasS9Hh0jQEO1G7Hfn8g/F72n05SK7V8I07GT523/PKKWMJTSl+4mkJRI8?=
 =?us-ascii?Q?PFg4uIdP5HXGdcUJ8yideSbLOAZ2ft2LMZGul9saMRF30KKRSbw5e9avhaMU?=
 =?us-ascii?Q?8eQackFKrHvNHMXcD5t/LOveorGF8PPWo3hg4dBwF6ZiuaWbKWKR/t9GzrYy?=
 =?us-ascii?Q?gsaRlj8DHMiBBbxa3inWnJRQm4YPaJvWJygaBg4K7/4CyZ4ucUhgNBpTdChA?=
 =?us-ascii?Q?NGtJ/8erwpPAzCerRZ8Cp55WXBSb/4raMdSKesJ4ZfQuRXXgaBlr5oBBFmwm?=
 =?us-ascii?Q?v2LV6q1TcSK62Eu6Py01HNGHlBQuqwDhEYFOVfa7bXzYet+1ZT3CfGi5jzMV?=
 =?us-ascii?Q?piYhxj1syzeEwJtXzwy54OR4c4n7p8wWsyVevm0T0eCX5bq7lQZI5L0CDPXI?=
 =?us-ascii?Q?eEiCxcTu53pFJetIR5oX1lfiRHs6hUM6ftgICSVeknKl914kvnVaOOuTjWPu?=
 =?us-ascii?Q?j/dT0x4iy1kIIyKs9qw8xNUqSDFP0XMq8w4Jv5SvfZATWHbQmqrpN4gQFruU?=
 =?us-ascii?Q?pdnv7Oz0+gsU9Mtr+FxmYipmuXd+G7vHxEGsSDXyxeukTabZ0p2iAdedsUGz?=
 =?us-ascii?Q?DZRk3SlDKpZu4NGT7DAPAfbwlrzMFelmXutX2TJVXBe/PtTpHIXy+w/eD1Gy?=
 =?us-ascii?Q?sPj9hb4oK/gFO7+sPQdcy6rZ1S5ka9nhuRCB40i8X5dyAf6WZmQ212b6a0tj?=
 =?us-ascii?Q?OlpRPS1Oyoo4Zpwe04H5M95qOczCRV5VXLQA/P0XjGv/pSSG5A194j65dWJ5?=
 =?us-ascii?Q?xmL7y9KMQXEj6v6mnN7YMtfP8P+auyAeEMhXIt8Q7gn5zqGPlKd69+D2fLVl?=
 =?us-ascii?Q?RAhCL+aA3Pv5+8KihvhcDRGh7CeKVDR4cxwJmNO04Xxya0fu+yFNYCe8qn4a?=
 =?us-ascii?Q?gm42Gfy9yHxgUJLXnqard04I3mh90HMY/LIjzHmy43+/12UFKeAPY8EJZPCf?=
 =?us-ascii?Q?wqrbGZpP8Ip8t3b9Zdp6Diw4Z96OUOFstwDq/1cGIDAZxcEK5kEiDwWV3hde?=
 =?us-ascii?Q?gtDuuZNhldPK66Vx4/zXvaeMMTQ=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(7416014)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 21:13:28.9365
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 79b753ea-6ab7-4e69-957e-08de5931ec8d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5604
X-Spamd-Result: default: False [1.54 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68783-lists,kvm=lfdr.de];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[babu.moger@amd.com,kvm@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	DMARC_POLICY_ALLOW(0.00)[amd.com,quarantine];
	DKIM_TRACE(0.00)[amd.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,amd.com:dkim,amd.com:mid,dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_TWELVE(0.00)[44];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 443485DEEB
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

While min_bandwidth is exposed for each resource under
/sys/fs/resctrl, the maximum supported bandwidth is not currently shown.

Add max_bandwidth to report the maximum bandwidth permitted for a resource.
This helps users understand the limits of the associated resource control
group.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 Documentation/filesystems/resctrl.rst |  6 +++++-
 fs/resctrl/rdtgroup.c                 | 17 +++++++++++++++++
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
index 45dde8774128..94187dd3c244 100644
--- a/Documentation/filesystems/resctrl.rst
+++ b/Documentation/filesystems/resctrl.rst
@@ -224,7 +224,11 @@ Memory bandwidth(MB) subdirectory contains the following files
 with respect to allocation:
 
 "min_bandwidth":
-		The minimum memory bandwidth percentage which
+		The minimum memory bandwidth percentage or units which
+		user can request.
+
+"max_bandwidth":
+		The maximum memory bandwidth percentage or units which
 		user can request.
 
 "bandwidth_gran":
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index ae6c515f4c19..d2eab9007cc1 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -1153,6 +1153,16 @@ static int rdt_min_bw_show(struct kernfs_open_file *of,
 	return 0;
 }
 
+static int rdt_max_bw_show(struct kernfs_open_file *of,
+			   struct seq_file *seq, void *v)
+{
+	struct resctrl_schema *s = rdt_kn_parent_priv(of->kn);
+	struct rdt_resource *r = s->res;
+
+	seq_printf(seq, "%u\n", r->membw.max_bw);
+	return 0;
+}
+
 static int rdt_num_rmids_show(struct kernfs_open_file *of,
 			      struct seq_file *seq, void *v)
 {
@@ -1959,6 +1969,13 @@ static struct rftype res_common_files[] = {
 		.seq_show	= rdt_min_bw_show,
 		.fflags		= RFTYPE_CTRL_INFO | RFTYPE_RES_MB,
 	},
+	{
+		.name		= "max_bandwidth",
+		.mode		= 0444,
+		.kf_ops		= &rdtgroup_kf_single_ops,
+		.seq_show	= rdt_max_bw_show,
+		.fflags		= RFTYPE_CTRL_INFO | RFTYPE_RES_MB,
+	},
 	{
 		.name		= "bandwidth_gran",
 		.mode		= 0444,
-- 
2.34.1


