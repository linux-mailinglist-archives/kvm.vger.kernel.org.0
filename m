Return-Path: <kvm+bounces-41000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3637CA60233
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 21:15:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 949E719C56EC
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 20:15:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4D9E1FE452;
	Thu, 13 Mar 2025 20:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="cvIn55C9";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="S41WiJJM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6CE31FDA96;
	Thu, 13 Mar 2025 20:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741896659; cv=fail; b=ZZYy0jNK6YLTJlC2G5laOWa12vnB9ZGRPqVLfqEGHY1fwTRdh/y8qke1LO+fSZvmn3k0cjzMvC9X4T6o+Dyd+ApcBOFbdZQEpXMJGSY3JjsTnfyIjZHjewah6ec3JaKFsK5LTh/4BO2N67Zuo6ofOewko5KltyvmT9+7mNTIoYs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741896659; c=relaxed/simple;
	bh=pBjwUBMZYgLeBw1r2pqZoXtnEBaG+7FIGk1Mj9+g1qA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GD4wC/R5ei80nutWVQ+5vyC6XpgNHYLHv2CWTC5HvzXounZCRziUUmKKHHYOawdw8qn527J0L2NUzLYNSFrDlOI1HUavsoqjHZ61G2benYt9pdjXQqia9EEFziF7PgXPVu7n6pb0tM8a4hqq3Q6RUPZbeFKyehvWQ6vvEREOTyc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=cvIn55C9; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=S41WiJJM; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52DF5DnS009026;
	Thu, 13 Mar 2025 13:10:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=zrGv6cP4lGm2e3q0jjpOKZfIdX2RlafIl44h7Yd66
	0U=; b=cvIn55C9lsaMFOeLDGOHSqpjhelQNMOjhLd0sYvH7z2+NM6JfC/ze+LZ+
	+GVJYF2TxNux5MvdVc3Z+F/t6JYD8xLMkWDLonu3LVXsgMX82wJxfZhpfEnQC5Uu
	bKLBgtm0g5SEmASl5VXYc2VZcAVwVRSNxgf+MDAMq4ezdx0GxP4kyOtmLZisq0sU
	2P/rQuUXUZ2tzZvN0OoJM6vJA6wETSHUt8/vqO0n8aQrntTTYjcZPf20TsqubBxI
	M0lULYAKKFfR/nCQBdjKXs/8Vg0KcavisYYEXd/wqYNvVPvowH9XPAtE8buA0bmO
	2m5uLhU/NA05AhzzB4EEKlknVs7Kw==
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 45au9g67k0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Mar 2025 13:10:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V2NZg0QfAbl3K9jTcAK+XrOx+roUiMfJKnkiYCnT07nmtghyX/u0mIxIWRyL7m0z3H29J7hAFMiE8LuJfBj23y3yrD4yrn6nj6/YorrhSKPwZbiVmg7rwA0qronXST3kW8u0+3/BfNVAK5CqhzRPx5tu6CIHPeL9/bh4vVkdhSEMBATqB05u0kdsp6I1LvL3pWfWX1/TWx1ylO59T9GZo+Vi9roPOq0OfbuI3TiFAZAxkQXOgcHMGLSNkLUx1oyn2FgSA476nx9XFbnfpuLbMcBZzGJMcCL+r5bAkIXpsfOIB4QMiD8b2NV/3J0gdMk3i7ZjcHkowm0wJgbl9sS2VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zrGv6cP4lGm2e3q0jjpOKZfIdX2RlafIl44h7Yd660U=;
 b=j7D6zSisocsZ2QxFku14pXF9/X+iFHk3m94k4MEQV6ZfQDYc8xrAesD477mk4x9SU3vWImDisp4fcOkhyjbv8zoUYKu3j68PE6KCz1TmqhwMmm5hk+UBMLhm5T7PoYEJ/+fY4qp+16V37BQA7ArcPSnUpPR1ySBfgSa7afXZIupSmMVKfBNIgFzxO63x7UyaAUUq2EsKz9qwMvhmruKpuYtb6jvIcN+PzVN8fUm7f1gCeq4BXT0cgPN5x4DafIXVP1dgMeIOkYqgBhRds/ZNZ/0A+GfZbC8H6e71JFekC6jeACySNWkrVnBf2n7CbANB5ll7CQizuQV5t6rSur2fHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zrGv6cP4lGm2e3q0jjpOKZfIdX2RlafIl44h7Yd660U=;
 b=S41WiJJMHzboZyagluVIX/QMRVdnFdMwEAHVwgvz8Sp2qq48aYDFstIxTIRMM1YwnqMPE8eMXKvUxS/RrLsDUcFhj/G70vmpyLMdGSEQVOOnFFKOPe9OKR7rkhCmku3rgM2gE7Sfk99hAqwD7e33MrGwLtxL/YPx7I79ZtzH2q0t1zKNJfWRpkEQAFl4nBbyiQpSeP5ZqD5yMFYA65EibOC7IlQaAhGl6JkJMceB0WGgxjPnY41oX8tT9sSkZBIqNcUNhAhGjMiYxYxPs7D7HbgGmA5lVxc64PcjBh+9FFjyliNQF2gz5dQlFmTodD9ZsS6h/6YtJP2SPISmTbgIBw==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by SJ2PR02MB10313.namprd02.prod.outlook.com
 (2603:10b6:a03:56a::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.28; Thu, 13 Mar
 2025 20:10:41 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%4]) with mapi id 15.20.8534.028; Thu, 13 Mar 2025
 20:10:41 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>
Subject: [RFC PATCH 16/18] KVM: nVMX: Setup Intel MBEC in nested secondary controls
Date: Thu, 13 Mar 2025 13:36:55 -0700
Message-ID: <20250313203702.575156-17-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250313203702.575156-1-jon@nutanix.com>
References: <20250313203702.575156-1-jon@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR02CA0007.namprd02.prod.outlook.com
 (2603:10b6:510:2d0::18) To LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR02MB10287:EE_|SJ2PR02MB10313:EE_
X-MS-Office365-Filtering-Correlation-Id: 2494825f-b416-400a-c30a-08dd626b20e5
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|52116014|376014|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aInKvUEnOqTDOVz6BFM/whQbRNZf8hOHJ4g5QQ9bTUBHt5MnrgcEj2FhRjTK?=
 =?us-ascii?Q?vFFUGF1y5pqTvjuzhoBiVv3FxlPD3mlniJLuDyILa3dpnDcBinJtYCIOPUjb?=
 =?us-ascii?Q?kLtJzxdiSZYz9ORlwLp37jqCCCBlQCGleNN15YGVP+Lw8vFjQshGUxtEIqfm?=
 =?us-ascii?Q?MebHtVDApbWPQkMlysjtQrFfujBjWhDkoQ8LI0ZhNt9VTxHL6zRMV6YyBb6v?=
 =?us-ascii?Q?Aq+avF47GN5kk4cDmv6JscWM9EtzdIWBZHfSi2gc912O+r3SlxDDmKk8L0tc?=
 =?us-ascii?Q?85MPr1L3io2yM5FiCBMxFX1CRTMRqQ8ORPGOdUXDYt9UNMkiG7uCdJ7WSw6K?=
 =?us-ascii?Q?68H4zcQhh+Cbn2/2DHwmrXh9kU0sD2WgQ8kwHVirbnUL2/tHpgdMD3wyFMVW?=
 =?us-ascii?Q?hJEKq0tEeVwKMaoPEXyaidWDtHxXydTZcjl2TrtfW1bSVl27h4dK9wph6dw8?=
 =?us-ascii?Q?iqS7aRcoHX2q3rLawUzS4m5xR7W6kPbGXEU7z4acOgsEibedqqAatpr9LqP/?=
 =?us-ascii?Q?wb7aiyR64RchJ7lIMuM7W4H//PfXR3qJWKFvntXZjoc1OSUAek+XfrLowHrC?=
 =?us-ascii?Q?JeqVpf2CpXdlZPE4j598BlZkI81D+5thu9g/Fsf7YvvWq1QJuyfwOyWuCTFR?=
 =?us-ascii?Q?GJIZ+GVtJ2DlQP5gmGPLueyh66Y7JtnY5twvz3a9ajc++MC4ZpOfDegNJ8UG?=
 =?us-ascii?Q?d51EvICpECOh/By08DVVXP2Bei4sKVsWxMCLYBezJm+Yksz56LYMgi3jSnCS?=
 =?us-ascii?Q?8kauocJeqG3W6gN2zu/Sp53+XOMeuCMBOmvg1SmzVJk8eFbPbLNzyBuOQT43?=
 =?us-ascii?Q?EtSMx+HBDEEWjipQ1h5kW/t6QzEWiqlIP1v7A4Zq2PZ4J1JeZwQJUWm4wRtV?=
 =?us-ascii?Q?iGzxHz5UvfoNjpThxyJtP1sAfaPSNh47a2ZGpFyD7U6mJYCHGEt9WlvxKMeQ?=
 =?us-ascii?Q?hUpVuXgqKzfjJaByl8z9JGm8sJBaYQn2DubJs7lsxOq4k7WutnFTV4uGDzTJ?=
 =?us-ascii?Q?r3M4QOL5GSpdIBoxNmm6ofzRxWFzt86qdlD3USF2VSn/61Y2aSjJqrra+nb3?=
 =?us-ascii?Q?5RnYpGc94opkIZPGplpHwLNDbyXKOB/6SeUwp8Refwsw8/dxJTA4nJkg1ri0?=
 =?us-ascii?Q?PSYPiH+0dVrTw48f/0meIaNNZ+1kKgJlFZzrg4Rg+D95jSmQmYPDmVu1oxpV?=
 =?us-ascii?Q?/bzuIDhaAmyVAt/nu1mXVxXmzGrEhIROdU8jAksAKm7o5OJoW0bUbeyxz34x?=
 =?us-ascii?Q?AIfG7C6fWRHZq0ktmD37ESzCwsJlvriPocAsoGjwvj319kbeEr9SemAzYmjW?=
 =?us-ascii?Q?2f1ChLLVOBGy5Jsxy3eTOKQIcAvewywGxLYVLwixjNnnjRPZjVI6ZPegiXxv?=
 =?us-ascii?Q?PZIrij1L2qsi6nr8Eq8ctBGFAsAlSYfZsWv+UJFs/nmfBDYv6Lrh9sctVCTL?=
 =?us-ascii?Q?KL/tSUC3pJNmDg7pmWhYb/gIr76cWV0regg26gbU1EkGhNm0fhbGNg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(52116014)(376014)(38350700014)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tbmcpRE3zAfWiEGjyWTx/0v1JRqZwFyLlezvLod9gB+OpE6J7PrhSYBl0+vB?=
 =?us-ascii?Q?erkDAytFOzpEkWoYdAr5c7Nr458N8W3I0seu3ebbFoD3AaZdiqs9dcJ2yLic?=
 =?us-ascii?Q?GYM48g81Jjmd2e7/0fXy+IBEk+zAxEjkJVa5tQhdHewC48gbDBmurU2ss4wG?=
 =?us-ascii?Q?brUJ3FEwqDXfITtWWcNbtmT35f+bUY1l7aPOiqv5nMwxpAYmDlI2ejE4ilOR?=
 =?us-ascii?Q?+K5nJ/1a4fh3nPpy2XUcOjMAM9MYDQabFDEQS3pzESFmkjSwHLR0mFJ5c6qu?=
 =?us-ascii?Q?SZAckMwv3AnEqv07G+TqTuylhqzST3MUs34Jugcv0EdEzkKGovAMvYlhxaPI?=
 =?us-ascii?Q?o0iKWAa8tofhF9XScDl0z3LPVQROCD/p+zCRGlS5v4uRdfPPnXxTQRxz2B14?=
 =?us-ascii?Q?ZLxRGPkaq22CCG+d50cPBMAlvO0SWPOQU7VuLO2dpvaB23dwbUgCKAt00Yoy?=
 =?us-ascii?Q?Wr2KPyjE6a21wn0u/KhglK52ZNX+Lgug/OmFNFjj0It2JjnIVYTWSDSMiFSu?=
 =?us-ascii?Q?eDhkjZfMIYGg/VlOQFgrVWVa8tl2vk4ZITp33YNDGSalnQ1P3rNLmy3+FuGK?=
 =?us-ascii?Q?WeNweOBkWFwLxItozeU4hVHiftm/kEF4/XKRAaNSCURsIfr1skoXr0WZJI5D?=
 =?us-ascii?Q?L6s9kwVH/5aGQ6cdqelENfjQOvxwAw/6oPIaiOzQOLC5yqdOTbbWIkAq5rlf?=
 =?us-ascii?Q?wzt+0124LMbQ4mXNH2EaTMto0cKguciwT0jY/BUFHBp7qFJ8hUjCXk5XEEHP?=
 =?us-ascii?Q?xna4agc1g0W9U5QW9sWpU36qpvw28LmmvM6GI2e8JyXke7O840Nzdqjzi7uH?=
 =?us-ascii?Q?0T4+gggMlpVD9EkJCRch41AK3IW1xFTFc/4NyEaN3hRC5SgiQZwFpKkkLLlV?=
 =?us-ascii?Q?QBqPkjZiYzFskYAQhiz+DRngfbuvTWbP2v/5LU3AVWGBh/Ucg/fmvbl7LHtw?=
 =?us-ascii?Q?FNOAhGCcujEQ3/cCqtl/sAel3UHAJwP1pizCkSrbOz1fyMGuMsdgB+xjjAeF?=
 =?us-ascii?Q?gUeCCvnuWOfoBLJ2T/1GuLI/OHPZSTCmZs02VO9lTy/k/tEPd6xWQkSB43wr?=
 =?us-ascii?Q?ayBGhVmy3UWL8Wq5mtlu9chjrU1S3WK+PLaf2ZxHM3VT+KC984HhQab2K6oZ?=
 =?us-ascii?Q?PtkGoE20ZAGWDTmOUHY/6NPXaLEwV3bJhxrrY/IOwmd/B52OfpD8Zj8m/gHD?=
 =?us-ascii?Q?q2doAbXdVTpf6J9dvxO4LSaBUhsTXucF3mBlUoI6KxTwHo79osWHD7ET8wec?=
 =?us-ascii?Q?xIwTODLPekUOIEzmRmKgFtgclT/F4aLYbo+1YKu83Kq88DZaxrjfc+5iT44M?=
 =?us-ascii?Q?V4db9yyxE7YDxHhkPRL/hevAIUGPiT+ACM8hSsVoaHGrVLAvD1C4c8jwIvck?=
 =?us-ascii?Q?SgBs3CMV7IxrW/YLk7chdcBNvDdKMxWmNwc55uqmyC7A4yZxGneFxZCbIcAx?=
 =?us-ascii?Q?CTwqCB4Xboh5L6I1SzmvJZLvDTJgoCL+FPJb8pzz2WNNe4A9XTyWduF+zB9T?=
 =?us-ascii?Q?GT+8TqsFAdCpehyYRQqrz0I26t8zIoeHGty4rKKOtqABCra9JRA5W812ts+k?=
 =?us-ascii?Q?YpxdIHHk3O5Zw7N5TOCsgQzerMpMYU86x2X/OZczyi5PnPPcJMck/TlIrCy9?=
 =?us-ascii?Q?rg=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2494825f-b416-400a-c30a-08dd626b20e5
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2025 20:10:41.1944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qZct8Ij3IDV/ZYcHdKUAz8usB2/4DtY+EON558Rf5oLl7XmF00M+ba/K8ZNMakcLoFToNYA/ErMRM/W/rbdmFKNSuBxPVo5J2eurPWxk9k4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR02MB10313
X-Proofpoint-GUID: t6p0fNgZzA86u_R8VjWj5M5L5FhhpVfA
X-Proofpoint-ORIG-GUID: t6p0fNgZzA86u_R8VjWj5M5L5FhhpVfA
X-Authority-Analysis: v=2.4 cv=c4erQQ9l c=1 sm=1 tr=0 ts=67d33bc3 cx=c_pps a=ynuEE1Gfdg78pLiovR0MAg==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Vs1iUdzkB0EA:10
 a=H5OGdu5hBBwA:10 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8 a=PtxkKg-d_YREc7Yk-V4A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-13_09,2025-03-13_01,2024-11-22_01
X-Proofpoint-Spam-Reason: safe

Setup Intel Mode Based Execution Control (bit 22) for nested
guest, gated on module parameter enablement.

Signed-off-by: Jon Kohler <jon@nutanix.com>

---
 arch/x86/kvm/vmx/nested.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 931a7361c30f..ce3a6d6dfce7 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -7099,6 +7099,10 @@ static void nested_vmx_setup_secondary_ctls(u32 ept_caps,
 		 */
 		if (cpu_has_vmx_vmfunc())
 			msrs->vmfunc_controls = VMX_VMFUNC_EPTP_SWITCHING;
+
+		if (enable_pt_guest_exec_control)
+			msrs->secondary_ctls_high |=
+				SECONDARY_EXEC_MODE_BASED_EPT_EXEC;
 	}
 
 	/*
-- 
2.43.0


