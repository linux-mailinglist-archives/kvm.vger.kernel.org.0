Return-Path: <kvm+bounces-68796-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2KSoFgtEcWn2fgAAu9opvQ
	(envelope-from <kvm+bounces-68796-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:24:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 0601C5DFE5
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:24:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4CCE9881F4D
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 21:20:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A216426EB9;
	Wed, 21 Jan 2026 21:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4PtGgm3w"
X-Original-To: kvm@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010011.outbound.protection.outlook.com [52.101.201.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E04B44105A;
	Wed, 21 Jan 2026 21:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769030124; cv=fail; b=cmdjeVwPWbjzsXsv8f5MCKTg+Nz4hiHa9quibTItTuoXaOpEEth7TmTYIQjMAMY4aA9vJxVJT8Ebac66l0l3nZBvxy6LE87ZmBk1Horzyw/sdgszt/vw1ao20KJ9U1oObK6lpbzv0YAziwSRWd0C9bomOo8TDZ49iHqUW04UQR4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769030124; c=relaxed/simple;
	bh=g9K/divpyNO0LVGbum73cgBwML/httOxdYj+9PJZwIk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jy6cIK1Hm9wg//ZeZ/Il9WSbN+qIXPrmCg+BOUwCq+e/JgsCtf4enHBDuf9onRp2EFxFnG171yY6yp3010fBPSpgIjq7OHRaNArJHWh3KqkNfgfwiuiYdyh4L4OSuaC+6hZUwzsdRjZdpay5f9sApp5eNbh09/3ubVkPcQqoLX8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4PtGgm3w; arc=fail smtp.client-ip=52.101.201.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tUOnOCV54HUfj6VC/cixFqGxPjp0SXS82n5oeaUzcHp0y0VTPKzjOIitruoMm8j78fwaYq/pOg4AzcVAjCw7nfC4GMYr3a39kJCihxQMe9QTi/rL5c9fZYnCZ7Wiu+YtC74/ctwwFwrK2fuHog96jEu1EI4V0nkhbFitoobSyShvrKh+MmSlU4H5UK1dpf8GL1J1G5QsWZMp5BMjtaaxfipsd1Pk9mvT88/EiYfyMrwTYgx7L1EjoLuHIxy5+e5N+uxw3Nw5I8QPAYoweltQ5xpe9EdsGspP8kh2BikEJis36BQE5+Aidb9Qbwwc4R46w108wTq3jvytUMsIDkbFHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g44AbSYRkiGcVxuF87xdaKJfk/yXYofKUBtUfAxi6M0=;
 b=zDD4PIaRMw/KX86V1kunwo6tB7GJNIQT7mn+EcGjrG7VwkJIFgrZMIH++U/T8/abjenqZSQGSorQn3BXpV+GPKAbllUECpUF2PTUtHPJ3HcFejh5Vp9XMz8chtocWl+E8RhK007EuO6TKK1owQtEnhzQo0wM/pj8EIMObOEBV+U6LLzuLHm2jvxtYkJEdFeIAdw62hFRDRWjMO+nAyz2RuJ9PKtNQT4VXTDm0LOiHXQblQHUmjdODdNihrFof00IXU/WduCzdWwdc0izaHZxmddTwvUgwWTFqpDyMnSmoeb0FPCV6w14nkVMhwLKlgwFV4PdkcZlzRZTjh308zsJWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g44AbSYRkiGcVxuF87xdaKJfk/yXYofKUBtUfAxi6M0=;
 b=4PtGgm3wFkjFygP1mekLQd+UQOw9CKGPP7C/RmHgPxrPMmOQoC0YKXo6ssb3qfT3eYeUJ+bHPDIoqZ3leUzv+O50MaO98aN86WYhGqcwPOHgHBpjIwbkyUXMdU78dkUPnkTKXtff4ywNDWI4fg5l/LAf13toKg4qvcz8dCzLKVo=
Received: from BYAPR05CA0064.namprd05.prod.outlook.com (2603:10b6:a03:74::41)
 by LV2PR12MB5798.namprd12.prod.outlook.com (2603:10b6:408:17a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 21:15:17 +0000
Received: from SJ1PEPF00001CEA.namprd03.prod.outlook.com
 (2603:10b6:a03:74:cafe::2c) by BYAPR05CA0064.outlook.office365.com
 (2603:10b6:a03:74::41) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3 via Frontend Transport; Wed,
 21 Jan 2026 21:15:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CEA.mail.protection.outlook.com (10.167.242.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Wed, 21 Jan 2026 21:15:17 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 21 Jan
 2026 15:15:11 -0600
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
Subject: [RFC PATCH 16/19] fs/resctrl: Implement rdtgroup_plza_write() to configure PLZA in a group
Date: Wed, 21 Jan 2026 15:12:54 -0600
Message-ID: <a54bb4c58ee1bf44284af0a9f50ce32dd15383b0.1769029977.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CEA:EE_|LV2PR12MB5798:EE_
X-MS-Office365-Filtering-Correlation-Id: c8acb9e6-a260-4492-e7d1-08de59322d12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|7416014|1800799024|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fQ2v5BqCwwgitALPN//O06dLoXEYKqmiBFmV1eLWXiSZncnlHrVIKjDIqSQA?=
 =?us-ascii?Q?sASm+8KROtfbJHKQw6ey84wiGr/2jisl33auy2Sz/tycLSeeIX9C5VESCNMd?=
 =?us-ascii?Q?IaDmz/8Tph+d7LUcL6YkjFuhc6BaMKhrZZ//kkSgM4UbKE2/Ax6dJD3H3GmS?=
 =?us-ascii?Q?7xSoLdWvQp/TH0A2Nc7lBFMBX9mrVP6NBvfJX1uTpz1reRidfIK8RNb/Nazn?=
 =?us-ascii?Q?+AnuDe9l/Q8aQ7h6i99DozZEJQo1bZusmjZ0VTiLtdz/4Ud5u0oY/0yI3oBK?=
 =?us-ascii?Q?4Ev9w1vV+MEac0dSrJI8h1gCTUyHPupEaiDyY4eQGQyCLHOCAcj4jkNoY6pm?=
 =?us-ascii?Q?e1IL2GflLNhELkxGdWmYm9+3UIRS5IAQ5NS/DpTmxDqGC9zvKvWUaC+lXXai?=
 =?us-ascii?Q?NbdsNCZQzv67+6beQ34wSwjeeKV7YdoLAGh+HJOHheWs/cJsQoitLAmbaIom?=
 =?us-ascii?Q?pS2ngz74q2NHdusaKI3hvnatrIHQt+1RyUgQirY/nuNkZFpk7Kku3hEuaoTI?=
 =?us-ascii?Q?QOFrxpDdIVwtqJHkCkJ5PvEoWkAqs6l58gOKbz5BKgnQVi5nYcG95spT2tUi?=
 =?us-ascii?Q?1RPtHARCt6TpGhkVC3784N84iC0cNcxYSuHn66oOVpgPHRB+ZHbXBhnBma0G?=
 =?us-ascii?Q?bNqc5YJfJX02CUAiP0+Kipuk8/sMcGb1d5WQPBhE7BurKCJAuk6DV4GeqtPk?=
 =?us-ascii?Q?zg+YjAly3SsJm9qHQMw4dPKG4c3OkBsHZWOmKXOQ/vz4tX4+lypYsCXG9+iP?=
 =?us-ascii?Q?uesla3Mqhd/ZIBXp6CYUBhasnoc4LaTQFmOZqYD7/HzCthwto5Ay7aNuOhNF?=
 =?us-ascii?Q?mvXU8sJGN1MDUXB+pQNX6muNIEenr/TvL+etgyUwfvH+XlQSyNPEM5GfCSx/?=
 =?us-ascii?Q?6w4wMRkq4Ge0OR9DmxRlR8AuoNZvnbPQa4XmIP8adJhks2NRXRTE4vpKZ0ZE?=
 =?us-ascii?Q?91bs40ISmdBDffXDTyC0ThdM9OaCOruNReNk6ms0FtRVva80kmPb62ALDL17?=
 =?us-ascii?Q?L2U6irU+3x1ElhU0SEsge4uOpauSyFbg0z3S4JHgc2aQljv3NFS6J5DorcEe?=
 =?us-ascii?Q?lPLcCXhSaTukPZ9i9yNFV5VQ+qMa8gDSIpAFQOQittjmDxEDXsQvbmg8sjIm?=
 =?us-ascii?Q?ikbJgNT8zlbJVfu5nxC+4Z0sKt+PXrIP2pgLhaNWLvsSUpylUYH+jA9QGlJl?=
 =?us-ascii?Q?KnDY+IFlQer4yJbfryu5RW+LoOd4ngWV6vvwim6UwoWVA2Q86fKZF9ai3aL3?=
 =?us-ascii?Q?IspgK3tzsUyp8kDwCH1DhcViJsy5+zVYX5bIr2QcT6KlJLkmTwvlNNwhCzAs?=
 =?us-ascii?Q?eR4v1uwwqgrDfYrgJQGuFGaEA/px/IU3nWFL7U+wZX6/4fzmZ5suT71fsYij?=
 =?us-ascii?Q?TVTlEBsd9Yo1fHu9nDxXOZqts9wvGoq9UOyk7iXUzaBcj9F8Udvk8XPNvwL9?=
 =?us-ascii?Q?xUV40do6sQ/G5PkbFSpGcuzmkmuSMXTaNns7gNdRlGRZbTQP8KO4wlpsbywO?=
 =?us-ascii?Q?n/uaXYN84G3rg+8UEP3ESY6ROlkN472gH+tQetwJB0tWCJP3N7BpUoG6ZTIT?=
 =?us-ascii?Q?B+gbRfBHHl89ElZnaTtQd8Enub7jBohrSFy0wQE3d0XSASXR0Wtz3v4yTn5J?=
 =?us-ascii?Q?wHaeqNqjRXMi0I6UAjf/Jemi+37P+1ZCODoTbztO0loBe6qmrhdHF4GkiBru?=
 =?us-ascii?Q?pAP7DdzaFOGHBuw6nkIQJffbMBo=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(7416014)(1800799024)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 21:15:17.1557
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c8acb9e6-a260-4492-e7d1-08de59322d12
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CEA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5798
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
	TAGGED_FROM(0.00)[bounces-68796-lists,kvm=lfdr.de];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[babu.moger@amd.com,kvm@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	DMARC_POLICY_ALLOW(0.00)[amd.com,quarantine];
	DKIM_TRACE(0.00)[amd.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,amd.com:email,amd.com:dkim,amd.com:mid];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_TWELVE(0.00)[44];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 0601C5DFE5
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Introduce rdtgroup_plza_write() group which enables per group control of
PLZA through the resctrl filesystem and ensure that enabling or disabling
PLZA is propagated consistently across all CPUs belonging to the group.

Enforce the capability checks, exclude default, pseudo-locked and CTRL_MON
groups with sub monitors. Also, ensure that only one group can have PLZA
enabled at a time.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 Documentation/filesystems/resctrl.rst |  5 ++
 fs/resctrl/rdtgroup.c                 | 88 ++++++++++++++++++++++++++-
 2 files changed, 92 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
index 1de55b5cb0e3..8edcc047ffe5 100644
--- a/Documentation/filesystems/resctrl.rst
+++ b/Documentation/filesystems/resctrl.rst
@@ -626,6 +626,11 @@ When control is enabled all CTRL_MON groups will also contain:
 	Available only with debug option. The identifier used by hardware
 	for the control group. On x86 this is the CLOSID.
 
+"plza":
+        When enabled, CPUs or tasks in the resctrl group follow the group's
+        limits while running at Privilege Level 0 (CPL-0). This can only be
+        enabled for CTRL_MON groups.
+
 When monitoring is enabled all MON groups will also contain:
 
 "mon_data":
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index d467b52a0c74..042ae7d63aea 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -896,6 +896,76 @@ static int rdtgroup_plza_show(struct kernfs_open_file *of,
 	return ret;
 }
 
+static ssize_t rdtgroup_plza_write(struct kernfs_open_file *of, char *buf,
+				   size_t nbytes, loff_t off)
+{
+	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
+	struct rdtgroup *rdtgrp, *prgrp;
+	int cpu, ret = 0;
+	bool enable;
+
+	ret = kstrtobool(buf, &enable);
+	if (ret)
+		return ret;
+
+	rdtgrp = rdtgroup_kn_lock_live(of->kn);
+	if (!rdtgrp) {
+		rdtgroup_kn_unlock(of->kn);
+		return -ENOENT;
+	}
+
+	rdt_last_cmd_clear();
+
+	if (!r->plza_capable) {
+		rdt_last_cmd_puts("PLZA is not supported in the system\n");
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	if (rdtgrp == &rdtgroup_default) {
+		rdt_last_cmd_puts("Cannot set PLZA on a default group\n");
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED) {
+		rdt_last_cmd_puts("Resource group is pseudo-locked\n");
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	if (!list_empty(&rdtgrp->mon.crdtgrp_list)) {
+		rdt_last_cmd_puts("Cannot change CTRL_MON group with sub monitor groups\n");
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
+		if (prgrp == rdtgrp)
+			continue;
+		if (enable && prgrp->plza) {
+			rdt_last_cmd_puts("PLZA is already configured on another group\n");
+			ret = -EINVAL;
+			goto unlock;
+		}
+	}
+
+	/* Enable or disable PLZA state and update per CPU state if there is a change */
+	if (enable != rdtgrp->plza) {
+		resctrl_arch_plza_setup(r, rdtgrp->closid, rdtgrp->mon.rmid);
+
+		for_each_cpu(cpu, &rdtgrp->cpu_mask)
+			resctrl_arch_set_cpu_plza(cpu, rdtgrp->closid,
+						  rdtgrp->mon.rmid, enable);
+		rdtgrp->plza = enable;
+	}
+
+unlock:
+	rdtgroup_kn_unlock(of->kn);
+
+	return ret ?: nbytes;
+}
+
 #ifdef CONFIG_PROC_CPU_RESCTRL
 /*
  * A task can only be part of one resctrl control group and of one monitor
@@ -2171,8 +2241,9 @@ static struct rftype res_common_files[] = {
 	},
 	{
 		.name		= "plza",
-		.mode		= 0444,
+		.mode		= 0644,
 		.kf_ops		= &rdtgroup_kf_single_ops,
+		.write		= rdtgroup_plza_write,
 		.seq_show	= rdtgroup_plza_show,
 	},
 };
@@ -3126,11 +3197,19 @@ static void free_all_child_rdtgrp(struct rdtgroup *rdtgrp)
 static void rmdir_all_sub(void)
 {
 	struct rdtgroup *rdtgrp, *tmp;
+	int cpu;
 
 	/* Move all tasks to the default resource group */
 	rdt_move_group_tasks(NULL, &rdtgroup_default, NULL);
 
 	list_for_each_entry_safe(rdtgrp, tmp, &rdt_all_groups, rdtgroup_list) {
+		if (rdtgrp->plza) {
+			for_each_cpu(cpu, &rdtgrp->cpu_mask)
+				resctrl_arch_set_cpu_plza(cpu, rdtgrp->closid,
+							  rdtgrp->mon.rmid, false);
+			rdtgrp->plza = 0;
+		}
+
 		/* Free any child rmids */
 		free_all_child_rdtgrp(rdtgrp);
 
@@ -4090,6 +4169,13 @@ static int rdtgroup_rmdir_ctrl(struct rdtgroup *rdtgrp, cpumask_var_t tmpmask)
 	u32 closid, rmid;
 	int cpu;
 
+	if (rdtgrp->plza) {
+		for_each_cpu(cpu, &rdtgrp->cpu_mask)
+			resctrl_arch_set_cpu_plza(cpu, rdtgrp->closid,
+						  rdtgrp->mon.rmid, false);
+		rdtgrp->plza = 0;
+	}
+
 	/* Give any tasks back to the default group */
 	rdt_move_group_tasks(rdtgrp, &rdtgroup_default, tmpmask);
 
-- 
2.34.1


