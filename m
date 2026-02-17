Return-Path: <kvm+bounces-71176-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SCz1Is++lGnHHQIAu9opvQ
	(envelope-from <kvm+bounces-71176-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 20:17:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E135C14F92E
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 20:17:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5D1FC3051467
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 19:17:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EDEE2D2483;
	Tue, 17 Feb 2026 19:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FN8kv95B"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012066.outbound.protection.outlook.com [52.101.43.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4119C1D5CD1;
	Tue, 17 Feb 2026 19:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771355833; cv=fail; b=TItO6Gqx7unqRiVYGf+GG4hFgJxJKl7jizofLipvxBbUskapsVBx/IPQNA4IheS/R/0yy8QV1dq6vH/4frGYq9Jr5Uijhv44dzHSjelQpr47gh1uykoQKIu9L08OzLVZZEj5kxO07T+R82NZlelS2/gG4Glvhuu+mxNmno5Yy2A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771355833; c=relaxed/simple;
	bh=DNsJrWcFPuSP+Rn/T8T2lR/GNThS2c//7AwXq/sPJ/Q=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UjIHQSFwFkFdaWtawUYq+DKoBHIQ5HnAAgE8dwzR9w8ghSijzGEIi1hM9SIvRrdxmEKgGELjH0A8a3ADb3kM419jsBoQzhQdI/R8QHLSwRzCQsN/dyEIPlJP2LAA7134pQ7rWid3TiHGrEhAsbliQl4Mw2WrvDSjUCME4qQMF6Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FN8kv95B; arc=fail smtp.client-ip=52.101.43.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZmgsQaUU189Tt3yxZSclY5Csy5q81EPOh+T3GnAp+K/PNPMn8geE9CD1HOq3bfw2psK8kQ5IRT7/gJ+KypruWxSwdQGhyHeLGO1rZD53z6Ych/hZGD4l5fzJirbxPLUOZL3QBmXafb+KVqB8ntaF57Hqt+DtIqkEnVbgI+0tA+DSmZN+XMI78Kx3btzr7pEFr0SE6lmthEXD/uIM00MmA2i4O0G8mh/xLCA8fonYfZXGohfl27Ab9u8Av/pr05b3D35vX71GOcJ12xQuPWk+ArASp/ofHzFIyU/RsdWv5J1gONOGF6WUBpT68Ee5e3JAi1TyFmVjtwZSqGyFwKDgTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zB2Hcdt2ZVTxFuj1sgkFccdhImmLzpAAihAZs4MmqFs=;
 b=uiL00GFVJ25vTv5luft6TTMLRqggZuFFXtsYuE1/POwphM0nQXFfASbBYwqWqKn0b97gh4kAYYCphHr1nG5aF5kw3o7200pgyrQnMG0CBxoVm+O6acMuLjMRPfuYw/lHo78ZSpwEKTMujGmKCizqj4d1W6cxtO1ENjBOEwSoAbPlKXyYuBhc1In5q6arh37gtcTVUCmNT1qRc2uLt3GEMrnuoNk7nlTwY7pgAXQbqCNw6MZwhEElf1RH0RgKlo/u01+DvvL7lsLaLr41o3CrbwMZWVqzAnYVUf7bggcoOSb72nV3JSuAC/v6HDH7nDq2WxAvF19rsiginuQ2tydKnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zB2Hcdt2ZVTxFuj1sgkFccdhImmLzpAAihAZs4MmqFs=;
 b=FN8kv95BilC0r+Xf3Q3gGtmGbHTdrfyQkrqM5llrU+w3NWpu/9PtbGy2z1Pj7AdddKZOdXJGQTEOptbm72HZHXeOtlYJwE2YT0BCVMPjlZGX6f2T/H0Z1WYHyLcZMBaT99GhwzjikYH0/X00K5iynHmd3uFVJh8PVkr0gvJvPRA=
Received: from PH8PR07CA0014.namprd07.prod.outlook.com (2603:10b6:510:2cd::25)
 by IA1PR12MB8262.namprd12.prod.outlook.com (2603:10b6:208:3f6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Tue, 17 Feb
 2026 19:16:58 +0000
Received: from SN1PEPF000252A1.namprd05.prod.outlook.com
 (2603:10b6:510:2cd:cafe::2b) by PH8PR07CA0014.outlook.office365.com
 (2603:10b6:510:2cd::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.13 via Frontend Transport; Tue,
 17 Feb 2026 19:16:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF000252A1.mail.protection.outlook.com (10.167.242.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Tue, 17 Feb 2026 19:16:56 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 17 Feb
 2026 13:16:56 -0600
Date: Tue, 17 Feb 2026 13:16:35 -0600
From: Michael Roth <michael.roth@amd.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
CC: Sagi Shahar <sagis@google.com>, Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, Kiryl Shutsemau <kas@kernel.org>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>, Thomas Gleixner <tglx@kernel.org>,
	Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, Vishal Annapurve <vannapurve@google.com>
Subject: Re: [PATCH v3 1/2] KVM: TDX: Allow userspace to return errors to
 guest for MAPGPA
Message-ID: <20260217191635.swit2awsmwrj57th@amd.com>
References: <20260206222829.3758171-1-sagis@google.com>
 <20260206222829.3758171-2-sagis@google.com>
 <20260217180511.rvgsx7y45xfmrxvz@amd.com>
 <037084a1-2019-4bd2-b1ed-7f34f9128e37@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <037084a1-2019-4bd2-b1ed-7f34f9128e37@amd.com>
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A1:EE_|IA1PR12MB8262:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ef5b63e-8582-42de-f747-08de6e591e23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DQatKQyBSXz+0DIu0U9k4zI5iKjiZ/s4UpXeSTcZQ+tJKioOHRPGoYKtAob0?=
 =?us-ascii?Q?zw7h5HIhMDjVjfwmVOEY7/gPZYBZWbsY9cWbPfUebbSouw1IUfSYZF4uhIa2?=
 =?us-ascii?Q?uLzYPyMyMw33wvsetQBUH2TJkaaf5C5j7g/wC64wag4b/u2+4vGMPMEClvV1?=
 =?us-ascii?Q?E/la5vKIRJdy8Dn2xrVPyYMDTbEYofSHX2JzUVZhmGU27H+4SgEgIj93n7yi?=
 =?us-ascii?Q?O0a5TtuAUcwn8pw4CyPFX8FTtCQSlogRxZqS/uAqvWHV0GrkoqDkHfQtu1as?=
 =?us-ascii?Q?Wp2sOlUgTKAl9nYs+sBhRTgMYqGR5+kEUcI6s9A6h0LQZU0Tr4IN2ruQETB1?=
 =?us-ascii?Q?WtsxyU1t0gWfor06n7Tcie/V167pwu8IrXqGTsnlFF1IgOGMz7cpNfcmeEqw?=
 =?us-ascii?Q?dzW/Pqqij24I63pLJ/9PUWK1zM3iHkK43u9+H8B0l88IHVL27BL9mn53/KU0?=
 =?us-ascii?Q?MSnvGH/Zbc3aqUPKesuwmWiWfnDQQrFXPlO06KBsoBxkYQbrKe2q5fgBTHbN?=
 =?us-ascii?Q?gSd1eLdaiiW+wemD6JWQXiH5zhQBKpBNU1K9RnYckrXrTORzMCgOTXM3z0vW?=
 =?us-ascii?Q?Wdb8dvG6rXaHpP+JG1FZ/5H+bf7LlW0jpHS/+WCgPFQZdDP93c4aTko43d7l?=
 =?us-ascii?Q?joR7SAba3go3Ab9o3LXevISotUIcsMQCq5XJlUBGNJoolDp4SA7w6zcLq0rz?=
 =?us-ascii?Q?MTDoqH5GvFvYhGps9UAXGE5uQoUPHN15ABpU4WgQwsPXBiiJmLteTBFQmlVG?=
 =?us-ascii?Q?ZPznfYm8n4EE+OxUxQMr+WDG4NS8exDZftXtHGPJLDP4glKicwrY1IPAQhfr?=
 =?us-ascii?Q?n95QotuoPd3fDz61Zw80ZLaaUdeCNRTkxxjl6MV5wCKh9BaCCtnbnB3Pgzcl?=
 =?us-ascii?Q?HfZn4qtRjXFkefRXczu4AEnXrlh8nZ6ic4fN/f2NZ1cscJIXQqkltJGZDMjW?=
 =?us-ascii?Q?yYNVfG5caHqLPH4HGlSm2k1QjN1BcehCqNOSCoOV1WyNo3OfXTg8A8OfDwkI?=
 =?us-ascii?Q?iET2Y/yytu295+GLgzSm2fnlxngmfgTaDAy0nTnUDPIhjIJuuMbZpK4SR+l4?=
 =?us-ascii?Q?aEQxWFqsMVcFlMtbZpHAdXUi9o9kzRxNfEwoDQlVSl3jqJ7FFja11BVgbIVC?=
 =?us-ascii?Q?yNTjkm7tZcZUu5VqHJbZrKeL9+AReJdNLN9zWg34g6ljplPqAZ7CzCYvhyZa?=
 =?us-ascii?Q?Nv2Lyh3ZJhUhRd4LLPDJYoAt/+Zsgx/+GEieQnd0F1EjdkT+G07GF6J/ieg8?=
 =?us-ascii?Q?4bTOUtNSgHAgkSjmnj+PYg+cs4NhiguLN5+ttElSqyBsCUn6miYd/jfOxP0R?=
 =?us-ascii?Q?6D4A96uGFMj34m1b2PsVSWGU+pcd0P1w6FFyvognihC2Nbi9zbl3nt6AR1NF?=
 =?us-ascii?Q?0JnFONuEGD4dZxKcLobOkN5JLDCjnJO0ifCdiOXIVdU31ei80xS1zGYy44p8?=
 =?us-ascii?Q?zkOgOECQRApo6Z+LbrW4xgNGpDPHVnD6wUd7SGUGeTjyanTMTVivTlS7nKhz?=
 =?us-ascii?Q?SxIPHmH1MkNNwH4OAORJlebWPwS03yAOozAY7X3UySL6whV0MdIzZvLtHTiQ?=
 =?us-ascii?Q?vy/JQk1p60/ComdWloF07HlvHRTBnejyAxXYlxaUXstaN0rxs7ogIuVik4vy?=
 =?us-ascii?Q?+g5L6wCPkgqdP/pZKZ1vyFUQSWZaVgyQa8TH8pr4nzLI?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	9aYx0CBehGOALO6ZZh+AdcKfVB0t0nB4Wwx767iwqlNcw7lvGJEZ97ZDFrpSfkCc9ah52L4+9rDekdG1oDwqyk7XmBiib6vxUh0MCRFL1SopEgGUCZoDthuxQi22Jcy347NOQlMeYO7UcfjhzOOzLXIiMNGe+eRB0k7xInTWvY8bNHtsYed63s7ayMs1dA7PHClR4wP+Z9YHM05J4anxzGhw5JSYxfOAb38RwMEi6HNLxMMpY33I4idEz7nT+X4JciF2HjInagNN4bS6NX4EUprvVz9rocszUMa8VAt1LPjpzBKk/eJTPbIa1SVOQmMRFGUmtLNoNhmxwAPGL2d6qGGnf6cBxpF8Zgvc2stzFj6y7iM7kNtEalmz30WOQB9vuqDSAO7ZTxEnDm35J0Ccm4PWBGV1uCjkEIhpXAbIvA+HZVMc7GwvVarelUTNmGGb
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2026 19:16:56.9343
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ef5b63e-8582-42de-f747-08de6e591e23
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8262
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71176-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[15];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,amd.com:mid,amd.com:dkim,amd.com:email];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[michael.roth@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[amd.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: E135C14F92E
X-Rspamd-Action: no action

On Tue, Feb 17, 2026 at 12:45:52PM -0600, Tom Lendacky wrote:
> On 2/17/26 12:05, Michael Roth wrote:
> > On Fri, Feb 06, 2026 at 10:28:28PM +0000, Sagi Shahar wrote:
> >> From: Vishal Annapurve <vannapurve@google.com>
> >>
> >> MAPGPA request from TDX VMs gets split into chunks by KVM using a loop
> >> of userspace exits until the complete range is handled.
> >>
> >> In some cases userspace VMM might decide to break the MAPGPA operation
> >> and continue it later. For example: in the case of intrahost migration
> >> userspace might decide to continue the MAPGPA operation after the
> >> migration is completed.
> >>
> >> Allow userspace to signal to TDX guests that the MAPGPA operation should
> >> be retried the next time the guest is scheduled.
> >>
> >> This is potentially a breaking change since if userspace sets
> >> hypercall.ret to a value other than EBUSY or EINVAL an EINVAL error code
> >> will be returned to userspace. As of now QEMU never sets hypercall.ret
> >> to a non-zero value after handling KVM_EXIT_HYPERCALL so this change
> >> should be safe.
> >>
> >> Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> >> Co-developed-by: Sagi Shahar <sagis@google.com>
> >> Signed-off-by: Sagi Shahar <sagis@google.com>
> >> ---
> >>  Documentation/virt/kvm/api.rst |  3 +++
> >>  arch/x86/kvm/vmx/tdx.c         | 15 +++++++++++++--
> >>  arch/x86/kvm/x86.h             |  6 ++++++
> >>  3 files changed, 22 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> >> index 01a3abef8abb..9978cd9d897e 100644
> >> --- a/Documentation/virt/kvm/api.rst
> >> +++ b/Documentation/virt/kvm/api.rst
> >> @@ -8679,6 +8679,9 @@ block sizes is exposed in KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES as a
> >>  
> >>  This capability, if enabled, will cause KVM to exit to userspace
> >>  with KVM_EXIT_HYPERCALL exit reason to process some hypercalls.
> >> +Userspace may fail the hypercall by setting hypercall.ret to EINVAL
> >> +or may request the hypercall to be retried the next time the guest run
> >> +by setting hypercall.ret to EAGAIN.
> >>  
> >>  Calling KVM_CHECK_EXTENSION for this capability will return a bitmask
> >>  of hypercalls that can be configured to exit to userspace.
> >> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> >> index 2d7a4d52ccfb..056a44b9d78b 100644
> >> --- a/arch/x86/kvm/vmx/tdx.c
> >> +++ b/arch/x86/kvm/vmx/tdx.c
> >> @@ -1186,10 +1186,21 @@ static void __tdx_map_gpa(struct vcpu_tdx *tdx);
> >>  
> >>  static int tdx_complete_vmcall_map_gpa(struct kvm_vcpu *vcpu)
> >>  {
> >> +	u64 hypercall_ret = READ_ONCE(vcpu->run->hypercall.ret);
> >>  	struct vcpu_tdx *tdx = to_tdx(vcpu);
> >>  
> >> -	if (vcpu->run->hypercall.ret) {
> >> -		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
> >> +	if (hypercall_ret) {
> >> +		if (hypercall_ret == EAGAIN) {
> >> +			tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_RETRY);
> >> +		} else if (vcpu->run->hypercall.ret == EINVAL) {
> >> +			tdvmcall_set_return_code(
> >> +				vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
> >> +		} else {
> >> +			WARN_ON_ONCE(
> >> +				kvm_is_valid_map_gpa_range_ret(hypercall_ret));
> >> +			return -EINVAL;
> >> +		}
> >> +
> >>  		tdx->vp_enter_args.r11 = tdx->map_gpa_next;
> >>  		return 1;
> >>  	}
> > 
> > Maybe slightly more readable?
> > 
> >     switch (hypercall_ret) {
> >     case EAGAIN:
> >         tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_RETRY);
> >         /* fallthrough */
> 
> I think you want a break here, not a fallthrough, so that you don't set
> the return code twice with the last one not being correct for EAGAIN.

Doh, thanks for the catch. I guess a break for the EINVAL case as well would
be more consistent then.

    switch (hypercall_ret) {
    case EAGAIN:
        tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_RETRY);
        break;
    case EINVAL:
        tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
        break;
    case 0:
        break;
    case default:
        WARN_ON_ONCE(kvm_is_valid_map_gpa_range_ret(hypercall_ret));
        return -EINVAL;
    }
  
    tdx->vp_enter_args.r11 = tdx->map_gpa_next;
    return 1;

Thanks,

Mike

> >     switch (hypercall_ret) {
> >     case EAGAIN:
> >         tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_RETRY);
> >         /* fallthrough */
> 
> I think you want a break here, not a fallthrough, so that you don't set
> the return code twice with the last one not being correct for EAGAIN.
> 
> Thanks,
> Tom
> 
> >     case EINVAL:
> >         tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
> >         /* fallthrough */
> >     case 0:
> >         break;
> >     case default:
> >         WARN_ON_ONCE(kvm_is_valid_map_gpa_range_ret(hypercall_ret));
> >         return -EINVAL;
> >     }
> > 
> >     tdx->vp_enter_args.r11 = tdx->map_gpa_next;
> >     return 1;
> 
> Thanks,
> Tom
> 
> >     case EINVAL:
> >         tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
> >         /* fallthrough */
> >     case 0:
> >         break;
> >     case default:
> >         WARN_ON_ONCE(kvm_is_valid_map_gpa_range_ret(hypercall_ret));
> >         return -EINVAL;
> >     }
> > 
> >     tdx->vp_enter_args.r11 = tdx->map_gpa_next;
> >     return 1;
> > 
> > Either way:
> > 
> > Reviewed-by: Michael Roth <michael.roth@amd.com>
> > 
> >> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> >> index fdab0ad49098..3d464d12423a 100644
> >> --- a/arch/x86/kvm/x86.h
> >> +++ b/arch/x86/kvm/x86.h
> >> @@ -706,6 +706,12 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
> >>  			 unsigned int port, void *data,  unsigned int count,
> >>  			 int in);
> >>  
> >> +static inline bool kvm_is_valid_map_gpa_range_ret(u64 hypercall_ret)
> >> +{
> >> +	return !hypercall_ret || hypercall_ret == EINVAL ||
> >> +	       hypercall_ret == EAGAIN;
> >> +}
> >> +
> >>  static inline bool user_exit_on_hypercall(struct kvm *kvm, unsigned long hc_nr)
> >>  {
> >>  	return kvm->arch.hypercall_exit_enabled & BIT(hc_nr);
> >> -- 
> >> 2.53.0.rc2.204.g2597b5adb4-goog
> >>
> 

