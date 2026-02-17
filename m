Return-Path: <kvm+bounces-71169-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MH/+Bl+xlGlbGgIAu9opvQ
	(envelope-from <kvm+bounces-71169-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 19:20:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7511A14EFFB
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 19:20:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E7CA130417B4
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 18:19:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61F01372B21;
	Tue, 17 Feb 2026 18:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="REL+sBDB"
X-Original-To: kvm@vger.kernel.org
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012051.outbound.protection.outlook.com [40.107.209.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3BA29898B;
	Tue, 17 Feb 2026 18:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771352392; cv=fail; b=DtSpd09bQK5o46sfh4W7C3i1bi6YpJgesw2nOUMdfM29xODIT7Z8C7Lb/+FJOW6HMnc1VSXjy5QBJuQgNFPweQZwyIRqttQHQGMy9FXcDt7dg2aIw9O1SSj4J2QBx+TivWl6AW/MGxxzrcE9AW8oq1hOuekf+kL6QN2Ph9VRqBk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771352392; c=relaxed/simple;
	bh=whVGNeIvMaqbWpPkvQVookUomcd8C/b7VRQRU+4CjNw=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bmZ88d1K0QjlJkCKR8ATXty11IlbuHWHgYkaiNObSVzy1s1toFrTusI7F9Bjiz4RAsdCZ5al8kxB98nW4/Hh3AmEN7HOX0ua8EiNdBmC0RWrbb28zrKPE7U5ey8yGJGjuV2Yqk/bgyT2UTY1V1qD7F2VGWhyFzabV2oVsxsovbc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=REL+sBDB; arc=fail smtp.client-ip=40.107.209.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LUl4yy4p4MbHfJpsapqtGEP3u7quAUtHXYVI/7LhKuqPIvQXYg5veumCQ6U8O4CG6dVo2Oham/aocdHS5URwvgw1SHiH64nVyEA895kfnAEyaLhH4wKKFSlKusQL6KyhBTaC3lwcylekhrsyxoJRECTfRr7ONeVHDIX8n1z7RkB6TrFdRCAtOOO4xFyIMlhnst2PslR05+mtxRp8TVmC67S5+hUBLTvpKqkBByCeH5gLkDxV6EBAdv/P7I2V+DeC1PB/srf0EOUDWXp0hcqMlsO/i+4d8NOXQnMcz6iB+oHxhswIsBoFm7cdhy/uX0ZFtIEw7BmGOaVCvaoYR/prcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WnGbu5aY2oSX73ZiGq17Ft6uxsaLS2Vc+tC+B7Q6ABk=;
 b=TGwBBeDDv0AmKbI9cdCbvg+m0re4oBKIoKYR0txAPL1Wi4LZ9LWTZP6IDH9+V5GfwwuRugiT8ZqEL4GCoN6vrzHuiF4/oD1AhvGheM1KRIrOhoA3URCgMub2XwccIfRCE7SPewQZS1Sw8poq7HAfJ06a16eCG9z3ST3F0R7dRDxaONwBfd0fK/0etyRHah4wTOG1it9qYnQVaLls+rHmoGIrC/BwCi0LV8wlIZ03lX1PD94tJUZqm92MkqLTn2F9QF/IAgxnMaHuZF+MMp67s6ZxSL7Rex6NzHqsD9RTT2vArtGxjLB/rM9NdHRhAoOVV6KXvN1jnWuH7UbscIEyyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WnGbu5aY2oSX73ZiGq17Ft6uxsaLS2Vc+tC+B7Q6ABk=;
 b=REL+sBDBAY/TkBSfna9PfOy8NsXdgBKCSvhrE6vQ5uflnYtchTv80QdWmeiV0mYJ6ejzXIrCE7zOOqql6KyLrb0hu2IoR4w70if2omWY5GnFIRAQjHNITK+obWso9DbjrGGM4diP22gOJY7z/vEJD3vQ0tJkeeaD0lB6y9XfSzg=
Received: from SJ0PR03CA0233.namprd03.prod.outlook.com (2603:10b6:a03:39f::28)
 by CY8PR12MB8363.namprd12.prod.outlook.com (2603:10b6:930:7a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Tue, 17 Feb
 2026 18:19:46 +0000
Received: from MWH0EPF000C6190.namprd02.prod.outlook.com
 (2603:10b6:a03:39f:cafe::45) by SJ0PR03CA0233.outlook.office365.com
 (2603:10b6:a03:39f::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.13 via Frontend Transport; Tue,
 17 Feb 2026 18:19:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000C6190.mail.protection.outlook.com (10.167.249.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Tue, 17 Feb 2026 18:19:46 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 17 Feb
 2026 12:19:46 -0600
Date: Tue, 17 Feb 2026 12:05:11 -0600
From: Michael Roth <michael.roth@amd.com>
To: Sagi Shahar <sagis@google.com>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, "Kiryl
 Shutsemau" <kas@kernel.org>, Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, "H. Peter
 Anvin" <hpa@zytor.com>, Tom Lendacky <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, Vishal Annapurve <vannapurve@google.com>
Subject: Re: [PATCH v3 1/2] KVM: TDX: Allow userspace to return errors to
 guest for MAPGPA
Message-ID: <20260217180511.rvgsx7y45xfmrxvz@amd.com>
References: <20260206222829.3758171-1-sagis@google.com>
 <20260206222829.3758171-2-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260206222829.3758171-2-sagis@google.com>
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6190:EE_|CY8PR12MB8363:EE_
X-MS-Office365-Filtering-Correlation-Id: bf6512fb-684a-42de-753d-08de6e51218b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700013|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZyuMXeoOqq5msrDgYzcdY1NItw7dCqKgQ/vnJtBGVhoQFkiIz1WIsYg8sPAM?=
 =?us-ascii?Q?24aTuRS71f/lxhp5imgFqrkLdMOk/8ygkKE+KpvWmkzLmqzVGqsAbXCpKBNz?=
 =?us-ascii?Q?hrB4M8QpXW46guBKNPIYHjJnZltivx3tZnUYDQxq4knqeT1In8LGzAkCAqMc?=
 =?us-ascii?Q?wLp5BzFqsdmSvLHCPwL9Wrly1jY/h1NoTrf+K+qPQ/FIyyUa5yzQvxvxUOKV?=
 =?us-ascii?Q?LdIqez90QScjKDW05632VlCRgt8uT42OmTNsRp8WS4AKTDEemj72iWCYKqGf?=
 =?us-ascii?Q?SZOUuA0iMGeubefIU1mBi3IFZGJsABLv+K78G6Zh5fpbkQ0xFnnh3EA4P1mT?=
 =?us-ascii?Q?981OqysugKGztBQpNKW7+uAfSlEu6E+Rg2V+PPSK8bk0lfxRj69ba6TeFQ22?=
 =?us-ascii?Q?zWOmqy3M++4vUvO7l9AW2D742gVhrsjLZej2RHLpc+w+ZKGcYYhOR62Q4Dd2?=
 =?us-ascii?Q?Xe1zXSqoORNn//bN1LiJGKwj+SoO7TIKdPAz9y7mNrw+qvk1S4rgvpxIphVW?=
 =?us-ascii?Q?2+d/W/kqiC0BtLEgCVMuKmdmKOPQuFnmCTjs5lKvzusJlcsijw56W7MugWrp?=
 =?us-ascii?Q?/OSYkx65P8P/Rb5mCzQAFk/Y2ZgvZbxSt0TP0Ko/vNK8rwJpYMU3j4RSSfiT?=
 =?us-ascii?Q?OEGhAaXQLsDb0yCuzsc7FFWZ3TP2SkLvP3wK6W6XRua5phTQBO8qd2D3IJ/m?=
 =?us-ascii?Q?CBkrwyOf0jRztgaM9Vgb7jrzy86ATfypCk01hnxQx2PrFW8LGpkA3hwb9m5c?=
 =?us-ascii?Q?WO9Mo8NJH5dcMfTIzqoBD2YihbLVyLxIHI5beHcot3RopaUda/9+8EEIBLaN?=
 =?us-ascii?Q?q/YDfJ/e8srKRUJXrhTsQl53QQ1DCgLJO9nwRMcZdAklXR04OjOLuPQisnrl?=
 =?us-ascii?Q?UqkL6lSOsyi88Te8lLyR8WS/pz91R/Vz8kSWOzc4E8qv+cNT8agUStUQvgxV?=
 =?us-ascii?Q?CZuuF3jVNB/yinek6MMEvWaGq+JHkswMYmronOUo/qLDVwkjS3UKzuAGu2aL?=
 =?us-ascii?Q?JCQ1Hs21xTgx55yeOU/TEeaAs6dvV4Ce5NZ1DX84zzG4+8UJNIDATUpr44A1?=
 =?us-ascii?Q?jRy35TWlFvGMwpNblXfAm+FHb8IAcePoZ2r8EVWHTz/ZwBPC2cGn/TsCiOUd?=
 =?us-ascii?Q?f0RUt4LluiyJIlC63s/pTzY6y3jrngKvilQXvgyTAqBu4R6ppf1unPWvJGjq?=
 =?us-ascii?Q?KcWmvtd0RutS0ky0RCrAn2OpxFvesZiYKlhESFjiX6oKEX2stmxR62+JqRQY?=
 =?us-ascii?Q?z/QxKcNlc0X6edllyl98AhS1lxC/1oALfM5oQbOl6tiaZWkYWmtm93j9xjxH?=
 =?us-ascii?Q?sesrNh7pX1HKyECEc42arEnEWhUD29pIg6TcO62e+PQnEYBReTrS86VywLAy?=
 =?us-ascii?Q?uGWPpjcb3jPimtXJbt7biKkZTE3xhCv9o9G5OHZIBURq4mrzO0lWBxWxx2N1?=
 =?us-ascii?Q?rOB3yrynNuJ4lkzymbBP/wFsTDCWhKrHt1eG8NAZgtX/OiPj5MUCZihORA4O?=
 =?us-ascii?Q?v3naVJUnz+pLRaYx1f1Yl7WnXi5H5ufBpf1BzeG7oPJ1ktBLLB3jnDKbbvtm?=
 =?us-ascii?Q?2NaOkjP/cE8Qkzx6LjhFWpjeBdcyScZR+zS6bTknaJfHVAVBn27QScRo8DiZ?=
 =?us-ascii?Q?qLJlgVUfTsRBeKjEYCsuQQa/B2jVHDO/5mJDMpwWwVtN?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700013)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	9LaLDiS1I8JUa4Cc8KHx7h85i1hQw9RulQ/wO3JOM/+dTFJlMzpJ3gY6F5v76QR4nvOcDJ5YIqV0eNgLGG96VzOxgu4OgHch1PNOGxF/xnj+P9vyc3Rbovfd7F8i+RavZ/gWpJ9NK7zhuC9ERcnG4amf1bk/FtSBotkL8gvoiZFJwjHbcBNbAh8MCz4rn6+c6FyRAel/Uf6oDrbyNZJ75h0HA4Jzl5aVbOxmAUeotnBLPi4CgeYyKfDMI0jNMSxrbAI5tyNOyLelUXKdGFUvW6pC0H6lSKsaG91uiqYrBc65eLCRz55FSGwZ9gEyn+Amv6XF7m2AVG2ULlrJDVQnf4AUdls5FL1uoDq8i5MTtCB9XhjqWPgianpNnJXaH4Ec/KKhTLiYINIzip2TodwZ3JMoJb0t1OMe3HA0NeWNPy+UsT8vIqmbkVHvGPyN3LRI
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2026 18:19:46.6658
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bf6512fb-684a-42de-753d-08de6e51218b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6190.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8363
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71169-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[15];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[michael.roth@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[amd.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 7511A14EFFB
X-Rspamd-Action: no action

On Fri, Feb 06, 2026 at 10:28:28PM +0000, Sagi Shahar wrote:
> From: Vishal Annapurve <vannapurve@google.com>
> 
> MAPGPA request from TDX VMs gets split into chunks by KVM using a loop
> of userspace exits until the complete range is handled.
> 
> In some cases userspace VMM might decide to break the MAPGPA operation
> and continue it later. For example: in the case of intrahost migration
> userspace might decide to continue the MAPGPA operation after the
> migration is completed.
> 
> Allow userspace to signal to TDX guests that the MAPGPA operation should
> be retried the next time the guest is scheduled.
> 
> This is potentially a breaking change since if userspace sets
> hypercall.ret to a value other than EBUSY or EINVAL an EINVAL error code
> will be returned to userspace. As of now QEMU never sets hypercall.ret
> to a non-zero value after handling KVM_EXIT_HYPERCALL so this change
> should be safe.
> 
> Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> Co-developed-by: Sagi Shahar <sagis@google.com>
> Signed-off-by: Sagi Shahar <sagis@google.com>
> ---
>  Documentation/virt/kvm/api.rst |  3 +++
>  arch/x86/kvm/vmx/tdx.c         | 15 +++++++++++++--
>  arch/x86/kvm/x86.h             |  6 ++++++
>  3 files changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 01a3abef8abb..9978cd9d897e 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -8679,6 +8679,9 @@ block sizes is exposed in KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES as a
>  
>  This capability, if enabled, will cause KVM to exit to userspace
>  with KVM_EXIT_HYPERCALL exit reason to process some hypercalls.
> +Userspace may fail the hypercall by setting hypercall.ret to EINVAL
> +or may request the hypercall to be retried the next time the guest run
> +by setting hypercall.ret to EAGAIN.
>  
>  Calling KVM_CHECK_EXTENSION for this capability will return a bitmask
>  of hypercalls that can be configured to exit to userspace.
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 2d7a4d52ccfb..056a44b9d78b 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1186,10 +1186,21 @@ static void __tdx_map_gpa(struct vcpu_tdx *tdx);
>  
>  static int tdx_complete_vmcall_map_gpa(struct kvm_vcpu *vcpu)
>  {
> +	u64 hypercall_ret = READ_ONCE(vcpu->run->hypercall.ret);
>  	struct vcpu_tdx *tdx = to_tdx(vcpu);
>  
> -	if (vcpu->run->hypercall.ret) {
> -		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
> +	if (hypercall_ret) {
> +		if (hypercall_ret == EAGAIN) {
> +			tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_RETRY);
> +		} else if (vcpu->run->hypercall.ret == EINVAL) {
> +			tdvmcall_set_return_code(
> +				vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
> +		} else {
> +			WARN_ON_ONCE(
> +				kvm_is_valid_map_gpa_range_ret(hypercall_ret));
> +			return -EINVAL;
> +		}
> +
>  		tdx->vp_enter_args.r11 = tdx->map_gpa_next;
>  		return 1;
>  	}

Maybe slightly more readable?

    switch (hypercall_ret) {
    case EAGAIN:
        tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_RETRY);
        /* fallthrough */
    case EINVAL:
        tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
        /* fallthrough */
    case 0:
        break;
    case default:
        WARN_ON_ONCE(kvm_is_valid_map_gpa_range_ret(hypercall_ret));
        return -EINVAL;
    }

    tdx->vp_enter_args.r11 = tdx->map_gpa_next;
    return 1;

Either way:

Reviewed-by: Michael Roth <michael.roth@amd.com>

> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index fdab0ad49098..3d464d12423a 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -706,6 +706,12 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
>  			 unsigned int port, void *data,  unsigned int count,
>  			 int in);
>  
> +static inline bool kvm_is_valid_map_gpa_range_ret(u64 hypercall_ret)
> +{
> +	return !hypercall_ret || hypercall_ret == EINVAL ||
> +	       hypercall_ret == EAGAIN;
> +}
> +
>  static inline bool user_exit_on_hypercall(struct kvm *kvm, unsigned long hc_nr)
>  {
>  	return kvm->arch.hypercall_exit_enabled & BIT(hc_nr);
> -- 
> 2.53.0.rc2.204.g2597b5adb4-goog
> 

