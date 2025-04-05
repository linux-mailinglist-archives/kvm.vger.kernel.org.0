Return-Path: <kvm+bounces-42777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CF28A7C76E
	for <lists+kvm@lfdr.de>; Sat,  5 Apr 2025 04:47:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F0C217C73A
	for <lists+kvm@lfdr.de>; Sat,  5 Apr 2025 02:47:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A5CC1AF0AE;
	Sat,  5 Apr 2025 02:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S29DsYXw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="c4hE+wAX"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC329475;
	Sat,  5 Apr 2025 02:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743821224; cv=fail; b=Wdk4k1qd0qHzURbkAoxxIOgAcAkphvwV5dLrCV6CwhZkhkvdpmMDov/83zgCTthjCc9zEpZgErV9V0f3b4f7DUIlmye2lK/drRyLQkD941Nm2lJCkmXOJsHohes/7YN1NqgYo4Z0kKKJiG9vDJQIhkrauhWH2+7XwDnIDppGWPA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743821224; c=relaxed/simple;
	bh=zQdOl9iWosyaAv1pQLXowdFuo9ktWsw9CHgT3yMOnhY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=iRsjIuN7fO8xjF0D2dCu4WB90ES5QjTzuBsQ8deyoAHjYoU68qA+cmVnjNZO1KzYnoZ66KFTggtcCf2b8vIgVwh6iE+0PalBDJrBSkhqtbGU4f5Itl1dlLODta48urPSz2LOpgNMC4C+6APmL4zlQUz7owIiGGmU+ywuQ2k2stI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=S29DsYXw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=c4hE+wAX; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5352gWGF018315;
	Sat, 5 Apr 2025 02:46:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=onmkzmSrbWBHq8Tqmz
	73vbcypikhWINwB1hij/o1qZg=; b=S29DsYXwpgbAK5ED5PXgPfnynNPwJAcQyZ
	2DzN87/GrsnLAjw5VaLLlCK4oS6HDNFI2LB3WKrBJNZzsaStR1TVc7yBMZdBl+0N
	wmYomymM4MPzpqEH+HhmtjI7b1rCDVgEJ4NVT09eH9yUJUFatRliP2Z8PSUBA8jb
	5MtmZze511RFK8m0TGj3VmLah/W4R8WVFL9l5tz5ZwLFQdbCaYQ460EaWUNu1Wjw
	mlbCkYAbbv/b3aRoKUA/Dsc4LMx6MYSwxFZ35rBCZQMMrGQxa5llMod67oGtjTCd
	iVoNqB/yjHGOZ7vwvh44NIh6Jix9vx4NLnxbsZMkhsYX+hk6ib3A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45tua2r0uj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 05 Apr 2025 02:46:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5351XeCV001477;
	Sat, 5 Apr 2025 02:46:06 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45tty5s63n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 05 Apr 2025 02:46:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jLEHgIwfv3scDDz1aUCA/lGCPPrlp8h0hhMBELqMZ+J4JC/umnmPElhfEW9vATcuEofgl3DqoSD3FtWoegKMS00p+oWHJ807iOAKY9kUYWZkq7ZO2OLq/rs3McteDr1E9bAJMpMgo3MBK8K8zLi2ggtNLfYWaGxZTYsOgL0KiLUZnx6Lgh6yyWu9Dqjwh27ggfSah1vYnsP4dM9y0uXj+8MYhDkrz1lL1QC7vCuLeODe/GjyJGQLRxY4m5c3LBFPxP7f0yPlZtjKFrMH1QTR5Cq0nmnOnwKeXg7PzZoiDrcbCt3CyQbAbU7YuCdINpr6HjtJaMApZwR53rRsPryUiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=onmkzmSrbWBHq8Tqmz73vbcypikhWINwB1hij/o1qZg=;
 b=HPoBGl1hfcVlyb8FXfg9it5Pgw2eKbKTFEqe2mAQTyVlGWGHFA88Z2bjmBmrch846UvsWgWr1ZBpYuV/hGRGeI3ugK7ESeeQp3fe7dhIN71HV9sy2mxsMc9GZ4zqxz47L69myzFf3ds37ZVYzVlHkpYfH5OWucEyO25857mezchcYnmmoOycj1PxY1DnryvPROOEwKdiczsF43b8EYVkGT1sGgEOy9jDniusTSjc+UaHZyHVnbWApk4MUQz4aTqSpuSnIt3o5J9NZi7ka/9VYCR150KmnZlbPfHwPSN2gPY53ohEvCHDNa20yal0Y0TwGYlhusT2tRnLWs7T+jnkeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=onmkzmSrbWBHq8Tqmz73vbcypikhWINwB1hij/o1qZg=;
 b=c4hE+wAXwN6UE0iwl6osVTHRKlxaKW4wKk3TjV0ixSd2PaKn4Wp4Lqu0/X2TIL/mQF6/3lyimGSUzLAMzcyjpe9IsWjrFPYP9D3BboXrup1IdbYhuMRY0PXc2j5yLZ7cSMsj/uOU6ZAE8r8xqeiaeffFUGYiGOgbY2t2tRT+fjM=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SJ0PR10MB5565.namprd10.prod.outlook.com (2603:10b6:a03:3d2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.46; Sat, 5 Apr
 2025 02:45:58 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%7]) with mapi id 15.20.8583.043; Sat, 5 Apr 2025
 02:45:57 +0000
Date: Fri, 4 Apr 2025 22:45:48 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Sean Christopherson <seanjc@google.com>
Cc: David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>,
        kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
        pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
        anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org,
        willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com,
        yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org,
        amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com,
        mic@digikod.net, vbabka@suse.cz, vannapurve@google.com,
        ackerleytng@google.com, mail@maciej.szmigiero.name,
        michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
        isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
        suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
        quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
        quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
        quic_pderrin@quicinc.com, quic_pheragu@quicinc.com,
        catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com,
        oliver.upton@linux.dev, maz@kernel.org, will@kernel.org,
        qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
        shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
        rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com,
        hughd@google.com, jthoughton@google.com, peterx@redhat.com,
        pankaj.gupta@amd.com
Subject: Re: [PATCH v7 0/7] KVM: Restricted mapping of guest_memfd at the
 host and arm64 support
Message-ID: <aizia2elwspxcmfrjote5h7k5wdw2stp42slytkl5visrjvzwi@jj3lwuudiyjk>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Sean Christopherson <seanjc@google.com>, David Hildenbrand <david@redhat.com>, 
	Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, vannapurve@google.com, 
	ackerleytng@google.com, mail@maciej.szmigiero.name, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, 
	quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com, 
	yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, 
	qperret@google.com, keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, 
	hch@infradead.org, jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, 
	fvdl@google.com, hughd@google.com, jthoughton@google.com, peterx@redhat.com, 
	pankaj.gupta@amd.com
References: <20250328153133.3504118-1-tabba@google.com>
 <egk7ltxtgzngmet3dzygvcskvvo34wu333na4dsstvkcezwcjh@6klyi5bjwkwa>
 <894eb67c-a9e4-4ae4-af32-51d8a71ddfc4@redhat.com>
 <Z_BTr9EbC0Vz1uo7@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z_BTr9EbC0Vz1uo7@google.com>
User-Agent: NeoMutt/20240425
X-ClientProxiedBy: YQBPR0101CA0262.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:68::24) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SJ0PR10MB5565:EE_
X-MS-Office365-Filtering-Correlation-Id: 59434648-775e-4126-60bd-08dd73ebfe37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7if0vRMAXl3/qr7IYPBhMr/9ADbZstciguqMbo3N/d5FUhGkbZ5wQJtI+6uH?=
 =?us-ascii?Q?OqodA2qh1fIQ/1iGKH0Dq2Rh7cJ4HT/v99TrT4zvdtzN0xLihMErOqmu7idZ?=
 =?us-ascii?Q?5eBWg5zT/wAIHyR8g0yft1zq9TYAGu+Ge+K5ZT7xd8x6lwvM6ntFfrrRh/zq?=
 =?us-ascii?Q?KE2arvcRoBIAUazJoWNnrDA5EphTUR3U4Vnac0XuGkNejvM4rtIEJlwdyWJp?=
 =?us-ascii?Q?acQyKe8b8pKRy7UzZJ6KqN9mzEk4UcNL9GN4t43JSQClxEgm5WNAE76Ed/Rh?=
 =?us-ascii?Q?z4GB5UdLIy4mHdAbVbgTSJsGiT+lMrrUocx4n2y3vx8QYqZdhJIE8GJ7qVLV?=
 =?us-ascii?Q?jTXfP1bVWeMCvp5DwWbCfC5PUDdr4Fqmc028H3xeBVJ0W+7Om8x02Z4d8ogb?=
 =?us-ascii?Q?Kz70+pVnhINf5PawHNlZ3nDJ/MC7q/gmLMZDzxhye4xBmvouMFMaci0Ucygu?=
 =?us-ascii?Q?kAtsTk9gHJePsgQdCMUVkMNoVkCTfgi63pNWCQoENomwZex4UgrG4jnMWNij?=
 =?us-ascii?Q?wfKjFIgRtTewviDGi/oGn4A4jofwdpcE4lrSu+EGFfK4MW8BcnuuUnMmRjX4?=
 =?us-ascii?Q?A4XAoqAgFHQ43xEGtykjc2xG/LOJSI0+6rxrcO4UI615t6jCcYrVfHWjfNy7?=
 =?us-ascii?Q?+DM3LcJy3FUD9o/kgiFxZ/2Q6ABwmSA0ddBMLKQmXFAeDuGOakfwKNZRh9HH?=
 =?us-ascii?Q?HKV2PaZwH12PijHjFegizjkf/0QAEyzOBd9N1We+qKAUaLwTYbC1XjfoCLMM?=
 =?us-ascii?Q?5CGiDQcLc1yUvPhtXTfHV3COhYb3aOJLGKiwEj5S3XpF0BqP+0ZR4JtOKsCD?=
 =?us-ascii?Q?ekZyh7zq/EuQldoljOUNVs7n/IXIFxQCxdzmv8vfgpzX2eUwzGq9tooVuceI?=
 =?us-ascii?Q?AEtZDU9Wv6WgtlJbEBgvJCUYIaUIU46LYsCcTU+nnWqrkXlKh7NlGrhSIFTa?=
 =?us-ascii?Q?htM+E/RRZNMiExKrkCl9oouFiByxqydZtnF7SPcPlHub9WQ+0gIotKAvFDAe?=
 =?us-ascii?Q?wGUv70mB/Kps2VpiGiIkrC6YCdFN27PedbUSo34d4nbS//5rYDInUBi/dU2+?=
 =?us-ascii?Q?6MJN+/VSjhKNWqnXZ6UngWgp33zZgYZGm10OUdV+zfdC57PfQAdFVMx/p6i+?=
 =?us-ascii?Q?0wcCdwXYE4NB658ckSv/y4WDYkgqlcPp9paQfKy8Znj/0fl2cm9S5rSFIfL2?=
 =?us-ascii?Q?Tg9Nnjw3MtH9HxogpxaRQKpcF/RuIiv7UihOMRwVog2+1qzSnVSMlsDhq3W7?=
 =?us-ascii?Q?sdbCO3jv1oKG4sgrDqZgveqx63xdI9xYd4erl9/AOmN1XVfVbUbBWQffXDtI?=
 =?us-ascii?Q?IfL9eEWLnDRPulv23JfR0WwM+pg4JBEGMzuCywrqRMFDsjUQVbUx9A6p6olY?=
 =?us-ascii?Q?2bXsWxGqNN4kYityHAYpz3ycDKxl?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ice10ysiCAhFCOtDiSm32QPin3lyTitQOyH1hJe5YvP0Yagz0U75C+raKFxE?=
 =?us-ascii?Q?uDo49iR+c28K86tGhCPOOUQqf2vc3p+gEeuX2qzmT2PI/HxHHjpwVb8xLbo7?=
 =?us-ascii?Q?SWcKlZRI88weuUNIHiA05BfynhWbEKmm+zDB6xVOYuQn8RL2k3L84U20xXYX?=
 =?us-ascii?Q?nGBlL9s0ytN/OqgS+Qd/HyXdkxGicVe4d55Tg4ny5nfPBpzqyqahQQM0EhG1?=
 =?us-ascii?Q?Ai6TWwNJ2d6/Z2IyMH0nVqAvVlgsfWwOHYOqfIAiuRzEsFzrtnMDaetDFloH?=
 =?us-ascii?Q?We6VXMjCANpx9PmG6a3uV5QnJy/jh7YDzUEUjf84LVd8GWzLaZhHJ3742kqj?=
 =?us-ascii?Q?FP6tPA8Em9yMQ3i4P/BMjHx4y1lQHyxHCbqXYMVXhShxs77QIHgnFQ1S+mmK?=
 =?us-ascii?Q?s21YQkPtMCEMUWDTDt87JZU6B892AFYSK2CgNJUVTSR8LP/oSOQ9zkXTS7fj?=
 =?us-ascii?Q?6fEIlYNERt+DX9PRykbf3RmZyjOh8HD/jeGnKKuBBs5y6euMA1tc5pE9sFGU?=
 =?us-ascii?Q?AjCFTJNXs0KIQc1UqL4Mu6Hvgg+rP7SKYZ48TwNFIuiuDpgXyujjDuQEoDT5?=
 =?us-ascii?Q?7hSxo+Y/vZDcJyl3Iha9hXA5pBxWZppmOI+/PrBZEGsxkuz0HW3twviLCo0j?=
 =?us-ascii?Q?o4tJkFAnKCvPM7aRVRgnEEB8eq/oTu1HYnwNFfrqtbPyf6X+uaRjpvQktF4q?=
 =?us-ascii?Q?CK2SbOffABx+hpb4TAwM5+nsziSYnYIh0R4OX7OfMMtUijr7KTEx2zMWuqKg?=
 =?us-ascii?Q?FIWXpS20/+td2xJJx4BCebovioYfKjDIUWZSWA6C4JOburGf0SAWbbgS6FK3?=
 =?us-ascii?Q?A3gvN5AV6ibrycNNoUbOyYuIhd9iqlLN2mssLfRYWmddPlf+4dp6ayGw7Y3t?=
 =?us-ascii?Q?t6HK28HO3ESfENMkkW8EJOJ8qYL/+XOH+GGHKrcvDwRuAyTvdRczChIjyZjV?=
 =?us-ascii?Q?iLODzIvjKPWtk7rFHYJbwtPQ7QXI8++eAvC4vtCzFpgLumRb7bdGaKsPm39Z?=
 =?us-ascii?Q?ZY70+8gvXpP8De7R/5nzw7iy5z9Vfs064n1mJ5nbt2Zb8pR2S8o9N7YHjXdl?=
 =?us-ascii?Q?aaHSXRb1IjlkvByxLFCXo05ow7laA43BCtouXEy61+ZEefBlkDMgU/gLAffS?=
 =?us-ascii?Q?8MZnwJBLT+TIZSoh7jH2MlfSd2XaeAckH3iz9Mbv7fP21hBJwbRsXb593ZK0?=
 =?us-ascii?Q?xnCENdr5NVoLYE4PDfHRZ/N3yBQcv8aG8HPsgg0F4V8QPnekofGqLAuejAWe?=
 =?us-ascii?Q?HuUW0EYOTOlE0QZ1feqUFBj2vD0JWBSqQV7Xw2EX4JIfpqz1UCoh08haCpWO?=
 =?us-ascii?Q?6PYF4Q3TPNZKmAsNnQKmd3nhRWavu+5xEadlGsXqM33TEOHjqiT+zSBBpJkU?=
 =?us-ascii?Q?jsmhMwlwB1ac5a526/QJ58dnZ3S077MKb/iYpc0DwarR432agBqPiOUKVgX4?=
 =?us-ascii?Q?rW+odfXdBBAl6poHM2ONhXcCHdekqfeLqkR0PFwXCOxdTiiunXJBRp2M4YWU?=
 =?us-ascii?Q?zimL7WPIHakOCaAQeL+28FhEWx7o60s3D1uEMfF/S8pgqM7/XxadamTaNpzO?=
 =?us-ascii?Q?yid+BOihh9mnicLqleHWMYtXHLmTCTPncLTL2uy4?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ooTdWnT5SUh4dOLMCYRZfpY0myjJ+o8yG1kPQcG5nyJEEKhEYoufffksTDl3FQGOejI6b6LRRmRSm1giYwMMQh87sl6t6xZs3BlynAWm3IFI5PKDwVEQv2KxPJCoxVslKPDf0oKKk3mBs9GOmSofjmq9wgXqOy6bUx5AjtUW70IWEdiwmFG5mhs1O7zb4UGMZaCOWN8uhFwmBK1GVKqC5f7UIAVwH1d00OL+w0DED7DcXfr2KYe+DxcqszCZKeqNuV1MPYKoV1XBxqtJvPVPcrrmomDMiTWCeNozTNaQF1mqRylpj1hHuoFveA6oP9y/9ReiIEPR2S/7UDv4RYC7WT/4WxYuu/9Z7ekTNBv2I+XkF8KhiXx78l3U5gJGhYpTN+VVZ1BzUjSgqw4nBbPF4FuHyryoQWA5vurSm2ZiqM8hsOnWHg2guIaT170qFzUTTrRvbqH5RsXWAXHEOh3TfyX8yrv1FSgUNBmdo03zlWTS5qBF7uH5RDEzgj1T/owvRYr4qw4C++WNdnCIlBm9eE6vOZtDkWjgR10RH5+NYNjBy/11oEhw+K+dNFFs5bYUagiTTEjlU83dRGnZS3R6tExJ6dBDjFAKmTCEZov4tcQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59434648-775e-4126-60bd-08dd73ebfe37
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2025 02:45:57.7727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cjq0gviB0nFAtRqC/uNofsmQLF6/UybGl3AXPpLIhVjoul+JFYT+x9AQWUnWzOjUJCmPWRVoKeyKvfu2S4TFmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5565
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-05_01,2025-04-03_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 bulkscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2504050017
X-Proofpoint-GUID: z6QOqSuOMUnCZfOP-uCbXBmZddOm1tn0
X-Proofpoint-ORIG-GUID: z6QOqSuOMUnCZfOP-uCbXBmZddOm1tn0

* Sean Christopherson <seanjc@google.com> [250404 17:48]:
> On Fri, Apr 04, 2025, David Hildenbrand wrote:
> > On 04.04.25 20:05, Liam R. Howlett wrote:
> > > But then again, maybe are are not going through linux-mm for upstream?
> > 
> > [replying to some bits]
> > 
> > As all patches and this subject is "KVM:" I would assume this goes through
> > the kvm tree once ready.
> 
> Yeah, that's a safe assumption.

Okay, thanks.

It still seems strange to have such vast differences in the cover letter
between versions and require others to hunt down the information vs an
updated cover letter with revision history and links.

I did get lost on where the changes since v6 stopped vs new comments
started in the update.

But maybe it's that I'm set in my grumpy old ways.

I really like the cover letter information in the first patch (this
patch 1 of 7..) to have the information in the git log.

> 
> > > It looks like a small team across companies are collaborating on this,
> > > and that's awesome.  I think you need to change how you are doing things
> > > and let the rest of us in on the code earlier.
> > 
> > I think the approach taken to share the different pieces early makes sense,
> > it just has to be clearer what the dependencies are and what is actually the
> > first thing that should go in so people can focus review on that.
> 
> 100% agreed that sharing early makes sense, but I also 100% agree with Liam that
> having multiple series flying around with multiple dependencies makes them all
> unreviewable.  I simply don't have the bandwidth to track down who's doing what
> and where.

Yes, sharing early is crucial, but we lack the quilt file to stitch them
together in the proper sequence so we can do a proper review.

My main issue is barrier of entry, I have no idea how I can help this
effort as it is today.

> 
> I don't see those two sides as conflicting.  Someone "just" needs to take point
> on collecting, squashing, and posting the various inter-related works as a single
> cohesive series.

It *looks* like all these patches need to go in now (no RFC tags, for
instance), but when you start reading through the cover letters it has
many levels and the effort quickly grows; which branch do I need, what
order, and which of these landed?  This is like SMR, but with code.

> 
> As you said, things are getting there, but I recommend prioritizing that above
> the actual code, otherwise reviewers are going to continue ignoring the individual
> series.
> 
> FWIW, if necessary, I would much prefer a single massive series over a bunch of
> smaller series all pointing at each other, at least for the initial review.
> 

Yes, at least then the dependency order and versions would not be such
an effort to get correct.  If it's really big maybe a git repo would be
a good idea along with the large patch set?  You'd probably be using
that repo to combine/squash and generate the patches anyways.  I still
don't know what patch I need to start with and which ones have landed.

If each part is worth doing on its own, then send one at a time and wait
for them to land.  This might result in wasted time on a plan that needs
to be changed for upstreaming, so I think the big patch bomb/git branch
is the way to go.

Both of these methods will provide better end-to-end testing and code
review than the individual parts being sent out in short succession with
references to each other.

Thanks,
Liam

