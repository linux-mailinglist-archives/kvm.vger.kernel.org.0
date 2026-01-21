Return-Path: <kvm+bounces-68778-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IG+RG55BcWn2fgAAu9opvQ
	(envelope-from <kvm+bounces-68778-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:14:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 120C95DE09
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:14:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 36E819C38FD
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 21:09:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAEE74279E0;
	Wed, 21 Jan 2026 21:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="D+IUgsgo"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013045.outbound.protection.outlook.com [40.93.201.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40894426D3C;
	Wed, 21 Jan 2026 21:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769029744; cv=fail; b=Xl+vUjaMUZHoP9tgYpBMpj+QKWSjO20x811U1ojOzpupL4yZJByelkzJvrTBxtjLipAPjJp5gYAM33ZvyhKmD76J439NwCTgUzm2ZVeOZf9Ouyqanmk9Ha1T5TYeS5xrnPVbQICUX/No4Fxc9Qt6WmYoMV1czllMZr5ZgPLvldY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769029744; c=relaxed/simple;
	bh=M9PiAdbMgGvD8ULRPCjTbYDsInj9LQn4grIBSt44Kcw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LqHbp9Nw5zVKvU+/yAB6hj0aBPnpL51w6kiBhoW9IrcMN/W4dayHlUXSFDQlGN3tLSznOIO3yZk3KNgGRIPphCfF7ihN2R4oet1ZeRqSdPt5TkCreSmRHV22Zzqpq4J8ZO4uRYrKGYCPnwOEKEX88y+L+LcAzaAUfQX3r5H0Ir4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=D+IUgsgo; arc=fail smtp.client-ip=40.93.201.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gelajji/FxlC+j7pOVho7D+tromW4BlVhQ6IqBP5AfkzewyQwu95ZU8Y+n4mzo0p2/Th6+0LJHd/cCjhw7lSwn+qnIE97PvLMKAeNIjNxXEvEEU1ntGKO23Bvsv087//vIhtp5nJvdYe0OqNEMIMsM6/WO435Z9hv/BfpX6WyoEfRiyZs0b54/EGqSYGkBoo9TBJcd1zg1X4tRGAKz9UmhGcfOSMO+w8fEHQMR7aIg0PSBLA4K2gBgYIhLcRlTDIMgKdnROBf32102lf8Y8NEZHhfIyiRrLqn91GQz1GvWZyxLhhDLyBxYe6CKVySlL3kK+qw6jhrcaVULsFnG5uhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bz+r8CJ3m2dC/Yq/BvhOpThEmwk+LYqRw0kIOQAOGDc=;
 b=YSZwdCS/GjPZtQO+TpwKVG7t9+mlHxB8q7B+mZXI1P+hEXSL3/u3nUkObQEJXnhnWWvcFEtgSV0ryKYyoPCPZDx3k84zpC9kn2CsbZOznTEeW/bG1lSVirZRxc/QLF7Z120GvrLdPkeZ5PI8yTAQ16At2TB4YWpz17tridjwVNywiUaxBxFyyYjKDBoWHW72V6VTlWFs/gs/pRv05SfZKU59m8v1bvRgZFuwMf1AvmGBk1a12p0qEUYE8dv1vWrKQva8fIXcHHYaRIW33IeG5XfZC3g/NyQ1p4kYg8uO6+/FQKYRj8dhri+y5w8WzRpxpI8gXAJs8DCdq1u/+O3a4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bz+r8CJ3m2dC/Yq/BvhOpThEmwk+LYqRw0kIOQAOGDc=;
 b=D+IUgsgolBtimWEOGunpx9itcZToB2VMF4XOyuqEbkZ3IGsWr5tlKsvV+ER5C8+L7LvS+QyNzHvrkXNlkVcJeR2a0VYluDk07WZZ0ZT20HWyLkAMl8AC6VJZK2ajrxLSzi6IefuhXHAuZucCgd4xHf+tYizpNjtjCAWanrB/RYc=
Received: from CH2PR16CA0016.namprd16.prod.outlook.com (2603:10b6:610:50::26)
 by IA1PR12MB7639.namprd12.prod.outlook.com (2603:10b6:208:425::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 21:08:52 +0000
Received: from DS3PEPF000099DB.namprd04.prod.outlook.com
 (2603:10b6:610:50:cafe::f2) by CH2PR16CA0016.outlook.office365.com
 (2603:10b6:610:50::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.9 via Frontend Transport; Wed,
 21 Jan 2026 21:08:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS3PEPF000099DB.mail.protection.outlook.com (10.167.17.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Wed, 21 Jan 2026 21:08:51 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 21 Jan
 2026 15:08:49 -0600
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
Subject: [RFC PATCH] x86,fs/resctrl: Support for Global Bandwidth Enforcement and Priviledge Level Zero Association
Date: Wed, 21 Jan 2026 15:08:20 -0600
Message-ID: <cover.1769029700.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DB:EE_|IA1PR12MB7639:EE_
X-MS-Office365-Filtering-Correlation-Id: 59186790-d1e4-47af-962b-08de59314745
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|30052699003|36860700013|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LLiKQTrH2u06zA5zMg7fm3wv9IjY3wTbwvpy+u4ZZqC3DAHD+WHuHxxsJwyh?=
 =?us-ascii?Q?75sdwqGuV6ijdxWElWp1yCwG0MbHlUIBPy8spy4HWMZDYuja2lKRr3xYtN3S?=
 =?us-ascii?Q?XMi6y/fzqePXlPoIsykldWwltrXVoEeorQBqQdLPgQM0ol4wU70n2TGZGutE?=
 =?us-ascii?Q?wFoAK4oVDds2Fdk0o5oFtRhdUa2wy+5Mt4Jt2yRaT1WGBhV3KCPKkN10aujV?=
 =?us-ascii?Q?sUOeIMBcUYN3YRnaqRRBoqWxnee3vCzbp8TTDnNKuN+5MfQx4HBqFCyA+WYL?=
 =?us-ascii?Q?AMng6Gzf8vNNkuMEFSmSUPy7tPFnz+A1OKuJsn1Ipk2e1uY9joSUidFvM9e8?=
 =?us-ascii?Q?Kd3IvSJIbN0N6fbd38TAexypxl6CrdzSwNnDs1ZcYNKPZ0rEDJ7Yd2zwkf8c?=
 =?us-ascii?Q?1J8pMb/3CDpOtq9whI83DtBJB8qA5cF67kZYLak9aPsKj/4Rv2DzFd6hEOyO?=
 =?us-ascii?Q?i8mwymflSJNsHjgPX6PHj3/ivBzOHsBrgmEj50IodYKOker9kNc4Xg/z0tfu?=
 =?us-ascii?Q?urPeliN22/cJQswSZgSXFGCHsjxxE/s+ZLNhSF5h89Rjcyt3LBJPnklTKNIn?=
 =?us-ascii?Q?cDD9A+lPOYJ20t5pDegJ3aN8Z9hyqys2B7sfUymxwLQpJw7RQLM6cchEzSuK?=
 =?us-ascii?Q?AdQ2rRNX9JyBMijkAeEmFFYtAz+H8W4yWWeQoknWP06O0AqXyFjsl4tPJF2J?=
 =?us-ascii?Q?XSl66gqXoqgfqcsyk+jsyYk/XujYFXDnGWwjL+kjnLR4s234BMkGFAihFY0i?=
 =?us-ascii?Q?D0Xpz3G3iGK6Km0H3O4JJYK1YhGOppSWpQARQMH69ELh+HZpi/6RdD+jwnPG?=
 =?us-ascii?Q?zGNbiq3Lf+gpy7sqvdEsWNzPKOifUUdwcYg0Ovrp2J4DV9SEaYW232M3gjjh?=
 =?us-ascii?Q?Q2Nfbwq0w+ERyNu5O6Bwq9zflmwAzrsXnviUyj3AHtJp7Z8oblxDaJroQDG6?=
 =?us-ascii?Q?nC2BR6uQTXuqtxPnmY0PDFo1+ZVAqeBGxXzsl7BqV4/XqXvsuy3NUzZGEzJM?=
 =?us-ascii?Q?MKA2SoSJ7fZLV+mHSGoyZ3qEtjNgGx87eYHjc0+cHuM9Rp8R4pPdKPjBk1Ar?=
 =?us-ascii?Q?ta+ZuVbl9HDOkA8KxRl8ZJeJpgmEhX9uUoUGxzZPmxVjnIiL7LxJY9wWKeFP?=
 =?us-ascii?Q?Cxy01utJmQ1nAQg5XiQ/wDkjThYi3XC5gSXSWPS3biXGomjiAfYI7KI0VpGV?=
 =?us-ascii?Q?ZVwvs+1Wd3Q7QNoGNO7Isend22ioYkeUo5d28LG+f8tZOP+C7g7L1/V9oXt1?=
 =?us-ascii?Q?uhKjpoRbwZWpOnuFyICy5LxZWQoVZ2/ZvxZbsrMuThl7z2e94gMJ8d6vkkOk?=
 =?us-ascii?Q?nBVayF2vLmb+RSOhEZL2RViuRppw8K/4MBp9qwS1puDQ2bRHeo7IWY4jqo03?=
 =?us-ascii?Q?D7hmTgjje7N89jYIZ/hb4ssSDDifJ6jFDM27nTSCUArV5ABcEjvrSMJnhhxi?=
 =?us-ascii?Q?X/4cTSHCPF1njgO1NvqQkb+lEWiVImW8gzOP3c/3E4ySflLOC/Z0N8unM29S?=
 =?us-ascii?Q?otisiB/z8TJoPmqZN/5wl+klB/EzwCYIMMSU0sl7w+F8RndCaomrofYIv8VD?=
 =?us-ascii?Q?1yG97HKv2CfbjKO0GMIauF0gMCqX3cXfF8L7bpK97PeUDAh/FbIH8ElY1oCD?=
 =?us-ascii?Q?ITbsMkWjz5V4E6Aoq9ygvIpgTdKlQHZb76AoZBLDgS5ammSBkVTxkGvXovVn?=
 =?us-ascii?Q?2+SLoi+YJKLd3Ld/Z80PvWNpBXM=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(30052699003)(36860700013)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 21:08:51.6374
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 59186790-d1e4-47af-962b-08de59314745
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099DB.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7639
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
	TAGGED_FROM(0.00)[bounces-68778-lists,kvm=lfdr.de];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[babu.moger@amd.com,kvm@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	DMARC_POLICY_ALLOW(0.00)[amd.com,quarantine];
	DKIM_TRACE(0.00)[amd.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,amd.com:mid,amd.com:dkim];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_TWELVE(0.00)[44];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 120C95DE09
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr


This patch series adds support for Global Bandwidth Enforcement (GLBE),
Global Slow Bandwidth Enforcement (GLSBE) and Priviledge Level Zero
Association (PLZA) in the x86 architecture's fs/resctrl subsystem. The
changes include modifications to the resctrl filesystem to allow users to
configure GLBE settings and associate CPUs and tasks with a separate CLOS
when executiing in CPL0.

The feature documentation is not yet publicly available, but it is expected
to be released in the next few weeks. In the meantime, a brief description
of the features is provided below. Sharing this series as an RFC to gather
initial feedback. Comments are welcome.

Global Bandwidth Enforcement (GLBE) 

AMD Global Bandwidth Enforcement (GLBE) provides a mechanism for software
to specify bandwidth limits for groups of threads that span multiple QOoS
Domains. This collection of QOS Domains is referred to as the GLBE Control
Domain.  The GLBE ceiling is a bandwidth ceiling for L3 External Bandwidth
competitively shared between all threads in a COS (Class of Service) across
all QOS Domains within the GLBE Control Domain.  This complements L3BE L3
External Bandwidth Enforcement (L3BE) which provides L3 eExternal Bandwidth
control on a per QOS Domain granularity.  

Global Slow Bandwidth Enforcement (GLSBE) 

AMD PQoS Global Slow Bandwidth Enforcement (GLSBE) provides a mechanism for
software to specify bandwidth limits for groups of threads that span
multiple QOS Domains. GLSBE operates within the same GLBE Control Domains
defined by GLBE.  The GLSBE ceiling is a bandwidth ceiling for L3 External
Bandwidth to Slow Memory competitively shared between all threads in a COS
in all QOS Domains within the GLBE Control Domain.  This complements L3SMBE
which provides Slow Memory bandwidth control on a per QOS Domain
granularity.  
 
Privilege Level Zero Association (PLZA) 

Privilege Level Zero Association (PLZA) allows the hardware to
automatically associate execution in Privilege Level Zero (CPL=0) with a
specific COS (Class of Service) and/or RMID (Resource Monitoring
Identifier). The QoS feature set already has a mechanism to associate
execution on each logical processor with an RMID or COS. PLZA allows the
system to override this per-thread association for a thread that is
executing with CPL=0. 

The patches are based on top of commit (v6.19-rc5)
Commit 0f61b1860cc3 (tag: v6.19-rc5, tip/tip/urgent) Linux 6.19-rc5
 
Changes include:        
 - Introduction of a new max_bandwidth file for each resctrl resource to
   expose the maximum supported bandwidth.
 - Addition of new schemata GMB and GSMBA interfaces for configuring GLBE
   and GSLBE parameters.
 - Modifications to associate resctrl groups with PLZA.
 - Documentation updates to describe the new functionality.

Interface Changes:
1. A new max_bandwidth file has been added under each resource type
   directory (for example, /sys/fs/resctrl/info/GMB/max_bandwidth) to
   report the maximum bandwidth supported by the resource.

2. New resource types, GMB and GSMBA, have been introduced and are exposed
   through the schemata interface:
   # cat /sys/fs/resctrl/schemata
     GSMBA:0=4096;1=4096
      SMBA:0=8192;1=8192
       GMB:0=4096;1=4096
        MB:0=8192;1=8192
        L3:0=ffff;1=ffff

3. A new plza_capable file has been added under each resource type directory
  (for example, /sys/fs/resctrl/info/GMB/plza_capable) to indicate whether
   the resource supports the PLZA feature.

4. A new plza control file has been added to each resctrl group (for example,
  /sys/fs/resctrl/plza) to enable or disable PLZA association for the group.
  Writing 1 enables PLZA for the group, while writing 0 disables it.


Babu Moger (1):
  x86,fs/resctrl: Add support for Global Bandwidth Enforcement (GLBE)

 Documentation/admin-guide/kernel-parameters.txt | 2 +-
 arch/x86/include/asm/cpufeatures.h              | 2 +-
 arch/x86/kernel/cpu/resctrl/core.c              | 2 ++
 arch/x86/kernel/cpu/scattered.c                 | 1 +
 4 files changed, 5 insertions(+), 2 deletions(-)

-- 
2.34.1


