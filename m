Return-Path: <kvm+bounces-71170-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uNpPNpCxlGlbGgIAu9opvQ
	(envelope-from <kvm+bounces-71170-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 19:21:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3296114F020
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 19:21:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7BF4C30579F9
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 18:20:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5FE036F43D;
	Tue, 17 Feb 2026 18:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1gfPIurU"
X-Original-To: kvm@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011036.outbound.protection.outlook.com [52.101.52.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7D028CF4A;
	Tue, 17 Feb 2026 18:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771352417; cv=fail; b=IELmVPyiKqQuqaDJyWGt/+CQFJr3SGRvykxCnZOqQvJh224uvp4fWRZ4qrI6jGMDH+hYTrVthIL47XXbf9hSmNU8TGGmO8uEp5+vy4sDw6pB8nXVS7Vm/HJYJ+z6MxPDHK5YLcHdYzzKsn5Sg7tLmVA5mHzxuVWOM+VL6BMdJ8c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771352417; c=relaxed/simple;
	bh=jGownt6OYMK8h/wePBW2OqKXx5U5TImckFepkXEYtXQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AiN94skk0m+PsTNwR/8YvdImpPntH1bxW5cuZAcGSi5dpbMcH6BmxSyX4kxxOsRAYEwBInZW6huVOG817fRQgNY1NEeaH6Kw/VCyZL0jPJhdBh6cogxje5In4/zBC1NztQLlPuvfC8Zqbs/SGV+UCKGtJn9RdfbLhk27yPRSG6g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1gfPIurU; arc=fail smtp.client-ip=52.101.52.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r+/gH5LCxdvS+eZswepDpVu13ikWZQ87qjvIro4sfsWlE2FYgPWLUGFog87C1q26c9awXOJIHjF6IvPu7WgsLXjh2rzdf+SekyGAu8SWnWPcHfUAthd80X0SZ1cP1LLiXloUekizT7biaSJl2pfJt8t06bTsgbQMg2fiZrLa/jX3tf/XMAuTfHHk9vEHrsfiWyHQI9a+rpFBIOI1z/iBfcYXwNKfoa42IIlDzcTv1wDaLAgzsECH6xkni2JkgVz7uoA1RYCg28q3EKgBxkV0t9ToVISXX2EFBOBwGNjbZTbr0snbmnv1JlnhhCfHzK4G/xzpq8lhG9CMbCmPuOpxaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dkSoMbpPsUqZCqrg3/mDZ3ZjZXRm8aRtuOgY3PUfZzE=;
 b=YiQ7HdDSpPNf683fWtkklyPMTukVaVDmymbyJyCOi45yqQcm9RtESDr49nWzpBNe0uW9LBv65HvvmtR80TEOHmhuiaiPpKX5AcIiYWKFpdw/4uJiiUN48KZsD/1Ep/w8vOJB29PUMvk4cQgex+Nqx49yXLyF7nyFTKAPvcMcE8GRskvlo+v44hvz1TtQDeGlwIA+7ke41ngUQcis9oTofceFzgKOUvaN/UEZ63axV3xS45Md3xSGKfotuO8qqttBI16tbLlPllu6vr3e9ba59De2ClstCSBtYaL2EeA/KutWlPo9GsggX550XcdkqVLbNtOdmG/lYdjHwgsfo0MZjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dkSoMbpPsUqZCqrg3/mDZ3ZjZXRm8aRtuOgY3PUfZzE=;
 b=1gfPIurUlgyt/2w/MhGB0HstGe7bdbXSOnlON5+7OAw2LVjt0gX7bvr6WGJj6rgMyQBVTc6ov1ogWTso10Q4M+3p2tnme5g8HEQ6DvL2j0C9Kgx7TNb625S66Myebw939KuGcIWJuuVtba8MQkpYPjSexql3fsIGyRhQ+/Bo4Ik=
Received: from MW4PR03CA0276.namprd03.prod.outlook.com (2603:10b6:303:b5::11)
 by DM6PR12MB4188.namprd12.prod.outlook.com (2603:10b6:5:215::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Tue, 17 Feb
 2026 18:20:07 +0000
Received: from MWH0EPF000C618E.namprd02.prod.outlook.com
 (2603:10b6:303:b5:cafe::5d) by MW4PR03CA0276.outlook.office365.com
 (2603:10b6:303:b5::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9611.16 via Frontend Transport; Tue,
 17 Feb 2026 18:20:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000C618E.mail.protection.outlook.com (10.167.249.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Tue, 17 Feb 2026 18:20:07 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 17 Feb
 2026 12:20:06 -0600
Date: Tue, 17 Feb 2026 12:19:28 -0600
From: Michael Roth <michael.roth@amd.com>
To: Sagi Shahar <sagis@google.com>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, "Kiryl
 Shutsemau" <kas@kernel.org>, Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, "H. Peter
 Anvin" <hpa@zytor.com>, Tom Lendacky <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: Re: [PATCH v3 2/2] KVM: SEV: Restrict userspace return codes for
 KVM_HC_MAP_GPA_RANGE
Message-ID: <20260217181928.hmesmosowg7yjhj4@amd.com>
References: <20260206222829.3758171-1-sagis@google.com>
 <20260206222829.3758171-3-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260206222829.3758171-3-sagis@google.com>
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C618E:EE_|DM6PR12MB4188:EE_
X-MS-Office365-Filtering-Correlation-Id: 16f5d6e8-cd2a-476a-105a-08de6e512ddc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|82310400026|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vKL9oMKpryEmcol6Mhd6HGDE+iUQWs5RXNIpsgCk4iBoN2Mi/XHdn7lFra3m?=
 =?us-ascii?Q?XoYfkDOlJrZTBfwlHmzCzAOfO//OLS9r/za4kXF556BRiaWj/NgxCpUBZEvw?=
 =?us-ascii?Q?5uHOpZFjmMuw8xcvlNufx0rGp8xAmiVUl2Q6mlQzDWXkeXxejhNReKD2hRbI?=
 =?us-ascii?Q?125cRoTKfQuAatGn4jcgytRTfYrY3JFQfdpMpa9D0OFUNTV12B3bb0TzdD8j?=
 =?us-ascii?Q?ofX0o8dzKXNg8zYPcvris3wCHi+ZV9n8Bg9bH6azvINls3+uco8bpyb5r00Y?=
 =?us-ascii?Q?6kDUSXlSb2MojduUWfqzktf/CfLE7tAAuInViAoQRY55D7lq+s+d/tVdydVb?=
 =?us-ascii?Q?Y2GoFDPZHNonipDN7KKhyGiwDV+2EgJL0nqrn6WkUnM5iiYeR2zJkITC6prP?=
 =?us-ascii?Q?7bSfbjM7RTgHhdhH3BySGuH3Xeizh1XhYl/gASe3/OQLWnHbOrz8uYxiL1WJ?=
 =?us-ascii?Q?CBphOmnzTR7GgJrMVhCfy/G6TZimkl0BTpZuPamYXMfWqxlEUQH+B+G/uDiw?=
 =?us-ascii?Q?DAklXmFBquBdy3LXd1XnKp0qikN3/zwO4p83mk4PLiuOYbeIldk8rW3nic7h?=
 =?us-ascii?Q?Cyszq8KknM2DF5Ro7WH/hWGfcQ1M4u/HW0cA+4/CAkcAn92VbCBRjUMxLzvd?=
 =?us-ascii?Q?VDiW9jt2wKs7JJkmXmMfEF44nBfehKR+PI2BDDpVoq4OfSzBfwZOTGZpsTzV?=
 =?us-ascii?Q?VKT/bIaCGQKlbfcDL258O9EGZdTAT0XTh09/dhstapJPieicZuk3F1K+YEd1?=
 =?us-ascii?Q?BO+1xQHmlF3gK6vuu1Rr/y1EYURn29NeOtIDixreSdI/i2aPrPVLzYV/BEPC?=
 =?us-ascii?Q?HU5KdC6YuJmioExojLBJp3kL5T+Ughxn+qt5+/EnhzmO+ajH6Uci1UI77FWB?=
 =?us-ascii?Q?nxE2/lUAHtugON5fkRrsIEFvCDc0KN/tu+kh27FOOwTOfPC3wBFuG2phlJIt?=
 =?us-ascii?Q?oBriuJEsyY2BkMgVWxaxr6E2mnUYSkQDQxFfcXlgMYA/bWG8kA4Wl1kwH8D/?=
 =?us-ascii?Q?dHjOjfWuJIMFR1Ur9gTVGWqbvuvVN5GuDRbhGMO+pf6DCLFQL6fW191Hyrcb?=
 =?us-ascii?Q?Sdhys3odKxugJF63YRJcv8JUjaGwNk3i/iwKNt5lv+JHY0IHQvgXkd3sxGI8?=
 =?us-ascii?Q?47nuLrR+taGLLXJrtbfFCG3R6htXI/U6HMOep+gyoPS6jRTOQ3xbm9vy8erJ?=
 =?us-ascii?Q?ntR5FHldZ9kbjFM2NR9IAIGNry9J4ykR+WL+X27kXUB1SX9hFp8zlFBmLuYw?=
 =?us-ascii?Q?1XfS6d7x4AsvPKMmS87zey0vB6AEpSfxA9CeLFUNXfuXaSi5Xpzr9VUZ6zUS?=
 =?us-ascii?Q?uWXfcqYO2WCUXBuoHP/n2+zROuJ9MCL+ivZRQyrGilDwvvl/bIYpIP+7VuEv?=
 =?us-ascii?Q?1/tb9hwh80JcIrhAk0hqZGdb+NzsS4PeNXGWkuU6KM8zQYzBZLGxu0bm5XWE?=
 =?us-ascii?Q?KU7uJIhNz7kNu8iwx1qU2GEfPIpMcvsa5BIIySZ8YhfjskIIj+9EJy/WHpjh?=
 =?us-ascii?Q?smb3qm3mmfpgZG99vFBPnKcz5Fqf09GHwiJ5H0nk2qLE3/xjUyRP7RWQ59wU?=
 =?us-ascii?Q?xpuhMg3WV15wO9bz2jmnVMmvAhie7ioQymP3lswQil1XD+jKTqpyhDsyq8v9?=
 =?us-ascii?Q?tR6FC0GMfJzHp1+xidLnk+TNe0N1GXpaQuC+OjN3n5ZkONTT/A5cHl8QKLNV?=
 =?us-ascii?Q?OES27Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(82310400026)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	O2FFZ44nYixbsj7bvhjtII/GAxszJB46+VJiKD0vWfUiTdoCWEfHEvNXIE/c+SALlIGTI6Zs0HYxClsQgLQrJ5pXqOl8bUw1ZuQs7KGs6p244w0Rp7fJHrPU+xlHITfstr8QTgbGwLp9paaZKTQa96MYvn6RB6hEA+XXs2CqC+IrovXh3uWU0U/aZe9X+1SRFZOXN44o//kcojNEJdxZQ6twoSKV0qaDGzq8fpiSv7yZSR0hGhbQ9gBCRQb159KMB+7zcZw4W9pGF70Dlw48U9S9ycdVOZS4RHagQ/U0maWrFAoa8QsvbqCtrrCXwkG9AU76gNxXBCW7aw+khE2HNf5l9kAa1C8J2n6MO2Z+7bD9qfgbE7ddrN/hmCueKWe/caASmbkOMw8Rr3yQYYbn9cqN9Afcf5Jcvp42kdcRo2Y77LzyBsZAevYmG58Vf7ig
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2026 18:20:07.2888
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 16f5d6e8-cd2a-476a-105a-08de6e512ddc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C618E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4188
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
	TAGGED_FROM(0.00)[bounces-71170-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[14];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:mid,amd.com:dkim,amd.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
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
X-Rspamd-Queue-Id: 3296114F020
X-Rspamd-Action: no action

On Fri, Feb 06, 2026 at 10:28:29PM +0000, Sagi Shahar wrote:
> To align with the updated TDX api that allows userspace to request
> that guests retry MAP_GPA operations, make sure that userspace is only
> returning EINVAL or EAGAIN as possible error codes.
> 
> Signed-off-by: Sagi Shahar <sagis@google.com>

Reviewed-by: Michael Roth <michael.roth@amd.com>

> ---
>  arch/x86/kvm/svm/sev.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index f59c65abe3cf..5f78e4c3eb5d 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3722,9 +3722,13 @@ static int snp_rmptable_psmash(kvm_pfn_t pfn)
>  
>  static int snp_complete_psc_msr(struct kvm_vcpu *vcpu)
>  {
> +	u64 hypercall_ret = READ_ONCE(vcpu->run->hypercall.ret);
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> -	if (vcpu->run->hypercall.ret)
> +	if (!kvm_is_valid_map_gpa_range_ret(hypercall_ret))
> +		return -EINVAL;
> +
> +	if (hypercall_ret)
>  		set_ghcb_msr(svm, GHCB_MSR_PSC_RESP_ERROR);
>  	else
>  		set_ghcb_msr(svm, GHCB_MSR_PSC_RESP);
> @@ -3815,10 +3819,14 @@ static void __snp_complete_one_psc(struct vcpu_svm *svm)
>  
>  static int snp_complete_one_psc(struct kvm_vcpu *vcpu)
>  {
> +	u64 hypercall_ret = READ_ONCE(vcpu->run->hypercall.ret);
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	struct psc_buffer *psc = svm->sev_es.ghcb_sa;
>  
> -	if (vcpu->run->hypercall.ret) {
> +	if (!kvm_is_valid_map_gpa_range_ret(hypercall_ret))
> +		return -EINVAL;
> +
> +	if (hypercall_ret) {
>  		snp_complete_psc(svm, VMGEXIT_PSC_ERROR_GENERIC);
>  		return 1; /* resume guest */
>  	}
> -- 
> 2.53.0.rc2.204.g2597b5adb4-goog
> 

