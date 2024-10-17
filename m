Return-Path: <kvm+bounces-29110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A3F79A2C45
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 20:37:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D305F1F239BC
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 18:37:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 705AB18CBE3;
	Thu, 17 Oct 2024 18:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mzYn+E47";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZHZICYY5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9F116EB42;
	Thu, 17 Oct 2024 18:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729190216; cv=fail; b=UiaK+wroBHchxWxpYs6P4Bzyu+48iWUn/WjgStKNq/lbKJLszimf8R/wi9oZDzj9OqqzJVPMKjEovp8ZF1bPWLJwvgbUdNAL0SKbRyw8+mWiK/DxPFW7x4PO1hCC9F16KOxzAW6gLblQ3VnfGYZ3QNBpfbXas9towWXsVzUFzno=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729190216; c=relaxed/simple;
	bh=icesNTxCTeNDmI3L4zMopcnvCh1uzNo8DWV8bndd83s=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 Content-Type:MIME-Version; b=Q6TtthDiDJW2nH97QQ9+xMihyvo2y1eJxpQxLFfRbiheZ2pJ2iyQywGxo4mdPy3wyWaXBbDglz2v1zD4WCyUa1JZnl2h+tJhFdTsp1pgFY01kvcLTP+1CZxwpMFw+44f3lP7owbls4RLz1dhYS0c00Ox4BdQG6NppWWRCNP4JwA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mzYn+E47; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZHZICYY5; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49HFBe0k000356;
	Thu, 17 Oct 2024 18:35:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=LRHMwUQKzykeiGGyi8
	GK4a3P9m7W/5mkguhRAbdWmDQ=; b=mzYn+E47yLD2oKLBfOsX12WjDqsxhvocjy
	Z4g30NlbeQLeSRqbcl3m1KdOv+SfOJc+qxkou6Xxjk7q8gVMVd4ftectTiE+jyuM
	1qed5mu1iFoEDPMi34EN+mKP/g+qPMVCseT+U093C1iM8K9l2UJ/DVGxn9PV3pxQ
	rh6WITPL1SCkOsJfBMISVaAIxN5PalVdZS8Wj6y1AghTFIR7I+QyLGp0c4mx3hyg
	Vuiell/VE+wmt3mi6aLE3K4H/7bPxbVPTFQ4u0ixfDrJ9cKE8pPJcf+xngxtiLdA
	YdHMv40f5tT4UKZDSt8574WNBoQQBVhC7nUe3WfPO6e36MYvmTbA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427h09pk8n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Oct 2024 18:35:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49HHerNS036092;
	Thu, 17 Oct 2024 18:35:58 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 427fjh4b61-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Oct 2024 18:35:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PX1aIL8+1WfFV0vyblBtyOq/EK+tFUx/vpg72RAwRljKVPS4WMjWlWY7K+8Szohcp7YBkSJue7gMycfbsxoVQ9nIrTK3am8BL1b2A5mJ1u3MQqpUZFNpyfSxOjCX6Zjk7IuNeY0DFkSpvtfyaFWZ3iFVG9Ps+ylSW2j0x9LNaXfEcggEG7IB4zaSOXxWpKx/4ktXRSOz6+K/mkVPg00JNmRtNjHbAx5lZH0fIX+1lhi5bYOSr008ANPMFIdy9wItG1vXxMuZQvVXOYpXawXfsLr41rU4JVvkgWwp/hCkQ52UnR5JQK1pGEMk/0oEnrp9AO3CitLpwCPtGXmSqUtXBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LRHMwUQKzykeiGGyi8GK4a3P9m7W/5mkguhRAbdWmDQ=;
 b=nd3wMVVnrYaBkLsrEPc1HI2kMvhg3wQkGMRIE40e1ukyCSQYzw3dh+fSxiUZI/RMuHkdBlvk6LrqOSKjZJRSsYhUOkT5YSSSNf/4Esh358zT+zle1CNE4t/yQWiBbZ2w64uAXgyW28myBnG0U8BeuNjdlRQDWTtLaNO090nXVF0vI+CRlAX84WILSetvG+l+9gz7HT58T+x9493O8GPCPN3v3pw2GLIgpJC6su2El0r0O9xL4YcbIKNYV9ZhOnMVf0scve8xRsdS/ACuTDxk4OIYy2yRCSGDeuwd4ZVDGW79Lyrom7ONJNU1YBt62yRdLu+3LNQY1rUV4FFbNeMP6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LRHMwUQKzykeiGGyi8GK4a3P9m7W/5mkguhRAbdWmDQ=;
 b=ZHZICYY550OPdyZtfamGmigk9ci82+wQ9qQ1H1VrIwjSogdSb3+eMGPfXXZJXnYQHzbKejWi8SuQXZrNv2lj9RP4Ec0l8FtKDHTQt1PPNCt8GHDY+6yVoC/T9ZDOcWFi4wyPgBqCT1SWIXdmH8uMpmj/IMnUc+oDc0K7UgcIQqM=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by DS7PR10MB4989.namprd10.prod.outlook.com (2603:10b6:5:3a9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.23; Thu, 17 Oct
 2024 18:35:55 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%4]) with mapi id 15.20.8069.019; Thu, 17 Oct 2024
 18:35:55 +0000
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
 <8634kx5yqd.wl-maz@kernel.org> <87plnzpvb6.fsf@oracle.com>
 <86sesv3zvf.wl-maz@kernel.org>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-pm@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
        rafael@kernel.org, daniel.lezcano@linaro.org, peterz@infradead.org,
        arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com,
        harisokn@amazon.com, mtosatti@redhat.com, sudeep.holla@arm.com,
        cl@gentwo.org, misono.tomohiro@fujitsu.com, maobibo@loongson.cn,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com
Subject: Re: [PATCH v8 00/11] Enable haltpoll on arm64
In-reply-to: <86sesv3zvf.wl-maz@kernel.org>
Date: Thu, 17 Oct 2024 11:35:54 -0700
Message-ID: <874j5apofp.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4P223CA0008.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::13) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|DS7PR10MB4989:EE_
X-MS-Office365-Filtering-Correlation-Id: 80831f40-f478-4501-e9f2-08dceeda893b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?18TpOrf8O+Ra6e+7xLlPeNFzupI9O0hDrBkFO/bwiHXXdaK14lWcoLgTqVuJ?=
 =?us-ascii?Q?BB+TQHrEhFbe2bOvYkWVpH5jvf46hRhCm4t9xtWnbKb9hcQh5O1S0Qkv7Dtd?=
 =?us-ascii?Q?/+EhauKY6oaDVpjjOGjn6hedNfilqFO2sJ6dp5m0uq3IgVN98YSdWIlDXVQx?=
 =?us-ascii?Q?WwRaEWiBPX0S819DZHYywW4k2buS1AKUp0mYXOHk0jGPtced4pQViKUvDZfP?=
 =?us-ascii?Q?UMr9viszKED8SAPibevUfuBvfMNs8nn8X3VktoOeJhmsjTIp8A5cA6Ao7VG8?=
 =?us-ascii?Q?HBjlYxWJ84c6/7iUn32dOWC4JKIaxmZBe3DIuNyyQtOx4Rj7V8/BEF1w1yOu?=
 =?us-ascii?Q?MsMPqvYVYSVbE+A5eaTlQtXhF2FhLxShQW1SWp4/k9ZdavjXJpKhHHdt8R9S?=
 =?us-ascii?Q?AzyCyl5Ykv2bDKNCFytRQ3hRCntYbrECVUe70Gz6Yonrtluez9C63RtkXQgB?=
 =?us-ascii?Q?g+ga8fdtqnZ6RjXJCi7OARTcrRE4xFhbFGP8a5MldyDzlaxAvtGds59+e9ll?=
 =?us-ascii?Q?8FqEhIWSuO0F39wvaFp5IptvS9b7Ga7bKSKp63mBygD7EI2zIKUJRySNCrNn?=
 =?us-ascii?Q?kRlrRD/B6MM5WjM/el6HyOPmO5PaKiXHzAd6xhpbz10FmULrn7Gmwr/wy/Ey?=
 =?us-ascii?Q?aoHhC7Dtu9VFMi6J9I53kOJVJFOWALnySv9Az6LchamQs8UIJtc8lSAA4BbD?=
 =?us-ascii?Q?f9hxZB5xuEGFxpftAnP89iKwokKDPq6Rwt6/3E2y1s4ihCso4lATK0f1wILl?=
 =?us-ascii?Q?chffCdTuY29KkmC9XHQcCf3EF/4ZfJZCnHOWTn/4HXP1stcOCb4F6wqSKYsF?=
 =?us-ascii?Q?I2O/LdbclBb+S7dkfnVQnowBhkkmDJvuHHYrQEv2VmNXj61lVjqtthDREEfQ?=
 =?us-ascii?Q?FjxTfB2dSvbwhJ8DSol9QZ76DY55xM2GI8YPfvt2ibBd0n8J0RVFUghHYXfE?=
 =?us-ascii?Q?oi9DdcfmXtaZmYkYCIkNoPGG1LA2tDrQEq3HGE03ELJFocAr1gqXMzg9WzjZ?=
 =?us-ascii?Q?ZfGAJD9o4vrSCgUz3v/NSg5WES0Ow2gY6Sn4ayOQrx26YRc9E2k+k9KTuy8j?=
 =?us-ascii?Q?e1JqZpGGP6COYBp1wzOZz/7EVueAYXUWkEJ9wVK8/912ocxJ9+PPopRMBXQo?=
 =?us-ascii?Q?/adtAcXXqH7ywuX7kTwKB2GopBqg/uA0H1TuvnFa4q+f+XHqerVWXTJPnIh2?=
 =?us-ascii?Q?gEG+62d+pJdgzoSJCBhAja4pHqS6Ciq6ZnQ6cXU9FJSkKv+KT0FKcGeloXH0?=
 =?us-ascii?Q?3TVRz6R5Vw3/rT+L2LimNe8Wjl66tTfgo1zwy5ewNpKrBKyKHUjQ7ZlJlGxl?=
 =?us-ascii?Q?3h0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7PpKbwOoV/HHEETyfGCnduzPVy75rC3QOcuD/7T1wT31EwkXykLydXczIkKl?=
 =?us-ascii?Q?rm7I0k6w7RX34VCPcP6N2W7bOYvTaI73vwodIS1GvEjqMcu90J3KJHZ0hmlc?=
 =?us-ascii?Q?eGzAp101e3ABCmVRRCXUYXLlmfWM/uDFAJP1tSDSHRlrM3/khxQ5XPNIiUHL?=
 =?us-ascii?Q?Ep+kfdPZ618Z8dcElpGBAwzAgO+9iKefg97BjHHTaZ8ng/ShcBtF8knq0RjN?=
 =?us-ascii?Q?Mzh+bta44pKY3lVPPF9N9JpXcqcHcsFBvpQY8lJkHpMx2tvHvOYkXO7o+sE+?=
 =?us-ascii?Q?dGnXxQHQGYDwp4XhSm64V+KFR47EyzOVe0qOWIYrvq3up8IFJDVyjp38e6rQ?=
 =?us-ascii?Q?SuyrNAYEQeey30fNAzVmnmEW3QXrELQAC/NeyvsNcHKUrcs3aeck33H0mLEx?=
 =?us-ascii?Q?Ml+dr6XjHqbyKUFDLfkncetIRcbXa6MencjJuAneEGoEjaBb/opVV5ij+y4A?=
 =?us-ascii?Q?5Bvn6tHDNWy2qaffnqXIRr+Sm+RqIYCBvgj2jdycsMC1xOz2k435PoURw1aU?=
 =?us-ascii?Q?ZE3zQ3oUD7ls6gCMAygaiqM8BpdbWHNAHWaeWmTvAcxuHXmFyU6wgEMRgGgv?=
 =?us-ascii?Q?B1GCvB+StFnSbzz+5yXVK3NseY2vZ75moZh+uap53DpNM5bkVxWfDQTooBYb?=
 =?us-ascii?Q?A2IfFvDCji5eNt0rQOFX3Y2Vk7UB5I0ic1ZZaHwsz5P5Ey011dHW7r1qOFyM?=
 =?us-ascii?Q?WPLT6zsK+8rtx9NFJMg41KtNKl2mPVbcPhmtdfwS74SSbt+GNR/EHdtv+OsR?=
 =?us-ascii?Q?nSa2nzo8zXNyFzEkIyQX9EjltgYtXFNBTZNzKmU8RXD5Nz4vRg3lsYfPfaZa?=
 =?us-ascii?Q?Wo5SlEMXCNBxlXt6sITLwzWSarv8aImx3Ed/XDErIbl+YXVCmjEAVVniHz95?=
 =?us-ascii?Q?c4bzIupK/UcPYRcZRMwC+QnMDvyl7fxqjkhVe8Q1Kugp7r+z9DqIlCXfHOnf?=
 =?us-ascii?Q?ocOQ8YDl70gmG2RqgQwfc7JoWMqP2ewLhlyA6t3SIBIuydvOTjAljZToVpL8?=
 =?us-ascii?Q?Hv+LfFY7XIfvhozeCBI4sI0aVKbLKFZ9SY39xGGoMkKnrowKp3Zs6gv4b4lw?=
 =?us-ascii?Q?VRN6eanNRvhBSGR2usSXMjFz3c/+horxp4tW8X4h0nCWscmTOPCN2lIxLRSW?=
 =?us-ascii?Q?+7cR0BTes0cpvCYSBWDlnym14a8qk0fFm6H8Cus1zYUa/e8qZbAdyXMkIjz/?=
 =?us-ascii?Q?o7yhQFkzwsKC5XbytJIEbbHJj+0z26woNDzJmPqcEQtNnOV1Rd/hl4iXuFf8?=
 =?us-ascii?Q?FppAWchGarAZEqXoHWEkrfoMqAT7yuVp2PzF1E0r/PJEuNcT+4dDxMG/HopJ?=
 =?us-ascii?Q?85HN9KhjPjfUeAfig1jIzHeYOJaF19VXKXl7F4lNfM+ovMo5uFGPnJJTzFn2?=
 =?us-ascii?Q?5qpt067EvZpd3AzMnVthmrAlOdpsXtqmHcS/iksxOkvx1TAMFOQFbv9OvxEu?=
 =?us-ascii?Q?DBM8zanQ6Y1t2fWht9QEMm7rU0ko6gzPV55bVwnnIRtypJ9QDlhdwP1LJ2er?=
 =?us-ascii?Q?nn1uv1A1cK1MrlolhRb7mTfTNGmLuwE8C64c/nfbafY+NvM7s1XmPOH7DIRM?=
 =?us-ascii?Q?VhpBrdEOrXQbTNt0txHG7vTX8MZYB36knfO6AjUJ?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Cns3jKyAQXFtanawSVDusHEg9bxROVnrazO+nCuRW/qfgSPGucqhj4wN23mqK8nv3UwtDjD7mVWCEry3R6xYiYAaBn/BhH3f7GZ8j1XJxwh8xXB4OqUF5pOL2UE0/oX0FOU4fwSpSnuYLLskW8lWRGd3OrnF2Q2wUY7jcR//ATnbYMrkST0DidyqURgtTS2W9f6OXTH7oSFnr1Z+NYqQRhAh2vE9+ZOn6lSHPme60FVXYDqZaBalgZOKR4WOnK4ZvZli2GXlKMxtUUkVAq9/8fbTDwLpiP1ENTGHG5WH2LKKAtmbtyMz4Ujy3EtgEezat4L3TpuvJTeY/b8MYNXgVUPLJLVSeQ7BBHleI6esNtafKhvYDkX4Se6ZT76dSsSBLWWDRZ64BBGxQxsojSWp6YXLUOS42ep5g37pkuSFjpi2rSeORj1VnRw4EKo2jvHbDbv6PwtJ+9QT3s/gOngoTty6LCiBYsZ0F92xhZ67eF9ixW3ak7MWwJxzxD2NS2c+We3kJ+4E4t+TF98+ZQgXzhrpleZuMwcIxl4H8FHesupg0N2ZjL76GOW8mEeAC2yZiPoroK7YNFnFWUljdo4V9hzQa0lp9Qw2rHX8+NEABDo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80831f40-f478-4501-e9f2-08dceeda893b
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2024 18:35:55.4420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uwt3NXJL9bYVWgmWHCcbxT1u7IM7LYjrAZmWpauKDmXb0NVYbj1FvXesc1v6Uexv3jAqcdXCZry9KOHFnML1Isvly1+SP1goI+Q32qoZ8W8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4989
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-17_21,2024-10-17_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 spamscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410170126
X-Proofpoint-GUID: FKAU85aj1yxUsHDEwGFB4LYTWJqnFVdh
X-Proofpoint-ORIG-GUID: FKAU85aj1yxUsHDEwGFB4LYTWJqnFVdh


Marc Zyngier <maz@kernel.org> writes:

> On Wed, 16 Oct 2024 22:55:09 +0100,
> Ankur Arora <ankur.a.arora@oracle.com> wrote:
>>
>>
>> Marc Zyngier <maz@kernel.org> writes:
>>
>> > On Thu, 26 Sep 2024 00:24:14 +0100,
>> > Ankur Arora <ankur.a.arora@oracle.com> wrote:
>> >>
>> >> This patchset enables the cpuidle-haltpoll driver and its namesake
>> >> governor on arm64. This is specifically interesting for KVM guests by
>> >> reducing IPC latencies.
>> >>
>> >> Comparing idle switching latencies on an arm64 KVM guest with
>> >> perf bench sched pipe:
>> >>
>> >>                                      usecs/op       %stdev
>> >>
>> >>   no haltpoll (baseline)               13.48       +-  5.19%
>> >>   with haltpoll                         6.84       +- 22.07%
>> >>
>> >>
>> >> No change in performance for a similar test on x86:
>> >>
>> >>                                      usecs/op        %stdev
>> >>
>> >>   haltpoll w/ cpu_relax() (baseline)     4.75      +-  1.76%
>> >>   haltpoll w/ smp_cond_load_relaxed()    4.78      +-  2.31%
>> >>
>> >> Both sets of tests were on otherwise idle systems with guest VCPUs
>> >> pinned to specific PCPUs. One reason for the higher stdev on arm64
>> >> is that trapping of the WFE instruction by the host KVM is contingent
>> >> on the number of tasks on the runqueue.
>> >
>> > Sorry to state the obvious, but if that's the variable trapping of
>> > WFI/WFE is the cause of your trouble, why don't you simply turn it off
>> > (see 0b5afe05377d for the details)? Given that you pin your vcpus to
>> > physical CPUs, there is no need for any trapping.
>>
>> Good point. Thanks. That should help reduce the guessing games around
>> the variance in these tests.
>
> I'd be interested to find out whether there is still some benefit in
> this series once you disable the WFx trapping heuristics.

The benefit of polling in idle is more than just avoiding the cost of
trapping and re-entering. The other benefit is that remote wakeups
can now be done just by setting need-resched, instead of sending an
IPI, and incurring the cost of handling the interrupt on the receiver
side.

But let me get you some numbers with that.

--
ankur

