Return-Path: <kvm+bounces-46987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FFBAABC12A
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 16:44:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6CF17189AEB0
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 14:44:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00C58284B52;
	Mon, 19 May 2025 14:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PAApA0J/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nbEjGMaC"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EA1284679;
	Mon, 19 May 2025 14:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747665840; cv=fail; b=QwJg9a0Ry6YyaF2NjR0ZtMJTgzWicQUQ/YFExQQ7KAHh3YVgDG62tdw5K+KFBgX2JX3TUUAtO2lngB87dY41esC1Uam0SL9P/rfg9yRD00aa53nDc3n4eHpM/dA8t7bdNkVnJ7tUWQpNooYZ3kNw82S+mUoNtqPeq125e0qsoMU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747665840; c=relaxed/simple;
	bh=m5OkY7jl+UtIFSR2+Nj7t9YFueVQ4CMuvecp+uxrObE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LJu9uo+4BeZqfgWO8SlI5ejRGLiCJITGu251ivDzD3ujmN87oPip+Hr/+ibThsEGSB/8jl6N2erUrT3k7t9Uxw7mA65QW7lUMM8U25T1oSRPRXkUyA3IcrJAejhh/6hQyHRYnOcjoKcniLfLvL3dik2XjjWj6uoEOQh53w4eO0c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PAApA0J/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nbEjGMaC; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54JEgxgt002138;
	Mon, 19 May 2025 14:43:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=IjPz9E/Udl3vkhtSQn
	tMaTLi8ndHgP2BzI9MWIRyq6c=; b=PAApA0J/VAzTP4i0DNNmIl1M+kzBFziOMA
	XXo64qiyJ2+P0OAC1wWl+g8W90hBbei9njW+bWbBLVStKR5oytgroZ3RT4YU3wH0
	jQMo9INUP/Ek3MMK7WUdrmpko3g1/mdUyX1GBTHv9S79/ihaOFr53tQ+7y/8ahex
	fS5MEGRNUnpDWjy3Lgr+0GM4NtEJ8NXhATMHPtFi1S8vP9b742HKQEGk6RNEV4jB
	wKJyxA4Tp77MijawQ1FY2BYm/BBKGXBvpAmH8G0mrnxVsnP9pe2pEDPbntbt8D+A
	WCIyW5haDN9e8U62FAeVBBsAzsYQairQFU5qmQgfOSfsJnxqdj/Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46pjbcu4jg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 May 2025 14:43:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54JDUkYK015678;
	Mon, 19 May 2025 14:43:40 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazlp17010002.outbound.protection.outlook.com [40.93.11.2])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46pgw6hqms-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 May 2025 14:43:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T/psWFgQP5Lk53wEmcfsX/e8qL1aaj1HlupaC7sgn80MGlTmUp8ga6LOeCq3w42uw6bos5dkXVUzJz4oSsP9HReI/fndp0F/v5VB8q7RBnQiLjeUlbSsPJ0FE0xDMheKJuJGlq4V72E6nghWMH1MHt8StlaDwqiBc7iqWsGkPlsdfKgSWkzWkoVnN+X5SvHQ1Mey7PXx2Dv7+kvwn2RzznyezGD8tvlMTnx/TcMzsSInbeXUr5EINSpJCfJ+XP086YosiTwsQOn2TOOiiOhdFjvHobqvHICu9K7JW3Lk+RbLQzGfmh/bPauL5cy/Oler9B6IQoTlpyOfbqh0mDmJJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IjPz9E/Udl3vkhtSQntMaTLi8ndHgP2BzI9MWIRyq6c=;
 b=HS1+BP+jcGmCNe1GHfGe3gGqt/r4IoFn/2j+8FaXWXrUsDjdjSlH3PFkIQVrYaAw4dCfzQddNPr2odfE1ZZ14OlSN2cZVLnY9Sq9k+fTOQVz+a+SFNkhU75VCd0KVQDDUwx229tyNWPaLkxkCqRCwmDs33FU3P5z+e7gxRXBPQ8GhVRAN5g3/bFhllN+FsN7qe74AGRlOsmqi2lYsQXJG/vf39+Ns0eZZ+Z6zyeiVvKe7r9TtCpIrZaRpYCeaNjHNQ67pwv3f7X8s9hBzu2BCgt4xXRLiJ+orwq7Ge9r6TKPQLAPjaxy9m8361TySjox8/19WdhJZDv51M3BEjfcVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IjPz9E/Udl3vkhtSQntMaTLi8ndHgP2BzI9MWIRyq6c=;
 b=nbEjGMaC2PH4ZdJrc22jphe4gmCVio5+xRlZQoUvvv942tOtqZ8grh/UetZQWQsdSRfkuMnXdfi4A6f4Ra33gbsxcGZ9sM4pvg5Vhh4G3Hd0lZs3GriQzx2k3ayB0+Gf4HUQUnRPlfANYGj1HiCNzFLROgJmsbeYK1hCDyOFGxw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MN2PR10MB4208.namprd10.prod.outlook.com (2603:10b6:208:1d7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Mon, 19 May
 2025 14:43:37 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8746.030; Mon, 19 May 2025
 14:43:37 +0000
Date: Mon, 19 May 2025 15:43:35 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Houghton <jthoughton@google.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>,
        Yang Shi <yang@os.amperecomputing.com>,
        David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mm: madvise: make MADV_NOHUGEPAGE a no-op if !THP
Message-ID: <bb9d43d6-9a66-46db-95c5-686d3cc89196@lucifer.local>
References: <cover.1747338438.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1747338438.git.lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: LO4P265CA0301.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:391::19) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MN2PR10MB4208:EE_
X-MS-Office365-Filtering-Correlation-Id: 95fa1c2e-1668-4633-4cef-08dd96e389d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nQLWxeh6+aaIDBhYcspeHeSpF0n/KeYqskmEZs4TWmWOi4KOcyvNCRmiVwl+?=
 =?us-ascii?Q?n5i0EHTDqmC9buBcEFHjuuw8zN2AjrhGXB7maKWOz/PqIEYcpDpnHe4blMh3?=
 =?us-ascii?Q?f81oXL4mx1qit2cwTwGHHFMtj4WobvXBmqo8G5jD18sUEr9JOWyGYMRoSs32?=
 =?us-ascii?Q?NiQvuBRyUb8TtAOznJ1XBNUbhIabtr8JdUvL1kikL+T1ZXSVQJe0+3gzt6Si?=
 =?us-ascii?Q?+bO+GPX2JICe3xCMTPHcwV5QVdoAY+qNKuOh2oZzV0tznwBXSzdCH6LGvG9l?=
 =?us-ascii?Q?i2XajdXm1RR3s1vD+JTzg8dsSCF+Qvkvc15aYfEiYXk6oXMCQzkuzTeEpICJ?=
 =?us-ascii?Q?jc7WMrVm//EWKm9Y3QnqTfuZBlMHy9dGFdwZY09pSisgSfibycmvEZPWm6x/?=
 =?us-ascii?Q?flELpgFIRk1z4Jt3Ur0Rgpzao7j0NIV3jGVILAVY49nwNo+yCJQOBaJ5Z3GD?=
 =?us-ascii?Q?96okoY6739ATanIhDWxm9rX+Oe7El3CidD1WHeUhq/uxxrpWCxuW1OiFbnfG?=
 =?us-ascii?Q?3BJCqbOiCzsmV5+I7RM7mh1mhrA8tTNngtkOA77qCKXgAUmEkp3m0CajKuyT?=
 =?us-ascii?Q?fGOFU5ofV4J8c0f7VqblsgY7N7iT5w6k3a9AbcoemlowlEMvBOs1AUWBz9W7?=
 =?us-ascii?Q?x5MY6oUJTucyHbCKMsoHx0fpEF7GOpArgIzr86LWmOYc4AYBc6whGBS8CGyN?=
 =?us-ascii?Q?MLXaJc8a4uZY1tDr2brjFJ3HZe7IO0igJtgNc6oCPexudkjN4dSsJ8lEh80h?=
 =?us-ascii?Q?uof+8R4tCnsE0Dzrxx9hfJolPUF4Cz/WnZC5pPH3P14PO/tJ0GyosJwsulwg?=
 =?us-ascii?Q?EVPJCmXXPdgOv43XZ50m5HUj3siCv/jwEK0hBf5F7AqjzaIKzccFjAYgzRc3?=
 =?us-ascii?Q?HvOAWJHFG8NV6i4fInZxUiE+rEZRKv8tqgmlrN0GLkiKwBhJ3nrptJtYBAeR?=
 =?us-ascii?Q?OkwJ+JDN/2JXMiFJVwkk7UL+/0uaX/Nx/hrfZniqLVJMmKQZJAkw3t75u8Ki?=
 =?us-ascii?Q?x1hY25xKEbGf7L58wgyeolYmhGyWb74cB3alNL3k8MNjG+g6Vr7vO/U8YUZ2?=
 =?us-ascii?Q?FrU1pAi10XZ101yenRageT5FTpWdERVcxqOrOeQp8yZBP5AdT7p+ZIJDN/3/?=
 =?us-ascii?Q?+lCCGVcbFKfxrlZGvTMhCQZl1lq5zPREN16HjhQq1LJAlnlgHim6AbHRL42H?=
 =?us-ascii?Q?4dZKx+Wvn2sq1vtUrUrt8BWTwlEXa3MEWTb9IKF5L8ai6wEkZcn1i6QaEwQV?=
 =?us-ascii?Q?j/Rbqe8RvGiiLfVoetMsufxbtU6phJIMmUCjVhpSYOG2dENfZclkP8WuFuue?=
 =?us-ascii?Q?qgVwkyJNguk5N5Ph4HMLcm0Ca9Q4CTJo874kNQZTaCIZsz/I73fSJiGpI+A6?=
 =?us-ascii?Q?cjtpU6FX8D8pWAtPRMRBQiCCDgejQh5wI0whglm/k4jhJpnN4V+SbopNrthj?=
 =?us-ascii?Q?shOXSPMmwzU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VrWgZ4Qb4mThc8DlP8XGoDEQkRGkw1AEUuIibrNy2/6DO2nw1U7EgchTXGOA?=
 =?us-ascii?Q?2d6ty55KQaYg5Wn7Yxua53TTTM7IGR9zumc/X13nMriHR++SMZNhsbbIfEVZ?=
 =?us-ascii?Q?x96ZzHqNximR0/jvpEvmjlbKwl+QliRkn6pB66EKDYDyOdWr8w+WTmBUli7y?=
 =?us-ascii?Q?+na7DSKHAwcVgTcV1OU4QiQNBxLvQpllNz9jAwwX0PHlB0ceBgkzC3DTkcpg?=
 =?us-ascii?Q?qamdajZJp+Y0tLRjGQojDEAL0bw6oWdY3XTRKsN5q2nhVJaC+vgL7loDIJ1/?=
 =?us-ascii?Q?5y1UCc3HTKlT0IJFtApg9hT1q1yzEhej+zWU4xpyCFauFsAZUMogXyJIoDGl?=
 =?us-ascii?Q?1RnI4RI9MVY+4p1nVGbbfGc2fLOXpC2wFB9hUalgW/8YOhlA2NNDCtwA7N60?=
 =?us-ascii?Q?cSFQfWQ38zc6LudMq75AzJz4Bxeew7Tao/OzpstYV1w69dGF0mHvsOWdLgqP?=
 =?us-ascii?Q?HdOahi/OyLNVi224NXg9uylEl2t22G9Z4E3g21WbCAlH3bwRuYI9mX9HmOGn?=
 =?us-ascii?Q?Gl0wkW+54NGoH6jVVbhoKprnBwJrdVKN8WAWg103+tV33NsZCX501BHnu4OB?=
 =?us-ascii?Q?X7cFpeRA9/JY5yo6OPzO4jjiskHyldqt4S1ovVa0BW7NB+sCVpvhmSsLJ3iK?=
 =?us-ascii?Q?D4ox2qlvE9t87MPVw9lpa5u0Stuazx4MxOhXlQRrjBYDnMRS6qyt7r0TcgjL?=
 =?us-ascii?Q?5Ap/oQ7xBJma6+bpVKpDJu1KRdjaRKK/yadCksEyAEVgnjk1R8inUf6NqYFO?=
 =?us-ascii?Q?tsX95auCsTAwP35AzxknzN+Q/PJmNdlToshkdfHKGAJKZNYk3aqrmQa0ZBa7?=
 =?us-ascii?Q?Fe4UD7tgK3bw6YuObvwIQ2b/DA3IxyaGgGZDHCvO1EUj470dfP9spvOIb4lw?=
 =?us-ascii?Q?/LTvZGtYS4AU0ANdLBOlVB/AaVCZHPuWaVvvM7I05nGUQoT2k0jJRtw/Qx6W?=
 =?us-ascii?Q?4WF6J5dYI/vkOB0X+n8HJhxE3unEiW1o90+gGXKVEJrTxoqpVTQajmaR6H5M?=
 =?us-ascii?Q?IkcwvVumRWN0PsSnXGj5LsF3JCmNaBF6Ed4tphUDnW8ntyuMrSpDrVWVAK0H?=
 =?us-ascii?Q?XtYrDAzNZUuWDLusmI94Y9zaAuTDqFFDSyh8KilVJAdtvc2LJLV5jPh+MlMY?=
 =?us-ascii?Q?TVNIn732gIaMuqZ9uYPNtwY5QjQYfxeABn/YhLbBIUCfsWIeutpdne4HcE+Z?=
 =?us-ascii?Q?iNfUlzf1Gn6c3A+C/cLNEaT5HfrsOE8B+q3BGaiI1g80n3ceBlB1j33jc315?=
 =?us-ascii?Q?yhsKcBk3W+so8F519Ev+wxcgzg45B/hHMoVLWZ8mjyA3r1exZAQ3FCovAfCQ?=
 =?us-ascii?Q?chXyFJW1iz4UWZNjdHzfl22jB3DztnM8W801+NRx/mBDbDvO7zOksXN3M5DE?=
 =?us-ascii?Q?SMHNXlFNwYnqdFZH0ipX8JwihmIbEAhR6795pqWwi+X5FOZZuS939m2de/RM?=
 =?us-ascii?Q?fI+Z2gTP7etA+/ny1xkuYVlfE82i+0EpcEMrKcrUuu7DQIAy5IkDkpeqzpOT?=
 =?us-ascii?Q?X3OgEqaFUTHfsy0yC4L1VxKidRNJnMGhW9vgk2OKpVcMAcNpRPP0GxTNx2c9?=
 =?us-ascii?Q?YqMxlhcZZZi5cgaJSFliNbT+d4B7p0m4vIW2usFMnWnQD3jCdLxGnpUClEha?=
 =?us-ascii?Q?Zw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Q13lq8ZlsrLKXs3/58jL29m7MWxz3qa7wVL5Uh64vrkFsMuTDyNiOBkEfLPCRktrQBHIhfJzq2nQi7aSwWXHx0iGO4rY+vxD997y/yI9Dl6d7MFPNIFTDuAKM76ILfzbfb2265bdWutnLz/6X5/FrHX39T3wnwNjP6FYnlUuL1fn6MgbN8b2aXzR35tvOvnAmpkDlp+YLtIUqnzDg7IJb8+/lvs/q6pAt5C5nTYs1rqGllJA9/GvTXgOPoOsNFVUc1f0Kj2DrfNlfj/SSUg60wdYiCxnZqoxQ3iNYav8iZLKCuIQVqCHGNpQJLgXcYKoJOH6QFnkyJU+zOskIRP9XomTeIhfgblzm8R1NVSjoEHYysq0W6oA0gsT/sdyulbuq7/3O7aKKaWHaz3gNQYKkPYXUpdOc4NyVInKb93gW3FwJE7kcAQZNMh0+IXGMwLmsOY94orSjatlgL7fFHV/ajNDXPkHBVI7MSb/76drJKd23TneZb+F1GczTrT5f03JnUWhMMEkaTrgiRRqvCgOZUKrrrrsultPOtHzI+UfYMVm2ArlU1/s+jbT0AfHkfdXHDqDU2H4lRjuVJlt91lfc5zGJ2BU6uXCBfQwpn7dEng=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95fa1c2e-1668-4633-4cef-08dd96e389d6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2025 14:43:37.1941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W6b9JXsIFQV2TQorcF3BvWUduWsBu6FWjV8+rI5tbWOo5e7Bm/pAiqw8wHx4J3LcYEi0wRnf6iau2SV5MgozNYSulb/ZukgJvquiuNrqbTQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4208
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-19_06,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 bulkscore=0 mlxscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505070000 definitions=main-2505190136
X-Authority-Analysis: v=2.4 cv=ec09f6EH c=1 sm=1 tr=0 ts=682b439d cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=TAZUD9gdAAAA:8 a=yPCof4ZbAAAA:8 a=Z4Rwk6OoAAAA:8 a=c5WxeS2ylI4Z0oBxKeoA:9 a=CjuIK1q_8ugA:10 a=f1lSKsbWiCfrRWj5-Iac:22 a=HkZW87K1Qel5hWWM3VKY:22
X-Proofpoint-GUID: ktuHDRvJgvtRMxPUKdL1dORaz8DD24W8
X-Proofpoint-ORIG-GUID: ktuHDRvJgvtRMxPUKdL1dORaz8DD24W8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE5MDEzNiBTYWx0ZWRfX0V90EVYSYKsa FYgg4ypvojiBe3KC7ZUrqm+3dItTQntP7xpvvQBZG6wiM/WJTjNEuSfAKDKHyMXiNGH3+sqcLS9 MrzKOZiYGixV5LNYJaL4uiCVXhoFxdlL6DmB5hiZgWTHLtrxtdvvPSNTmdKaZ5XRYe4cJ9fQG2u
 esY/f5VgTO/6wIBgKS8Rf3oCvGy5W+1NS9xloz3zSiNyif1kp8FRFRNsGXDbvnWrXS8IRh770fY eptMx1gJfrcoD9WRKuxt9QMghfmATKrbC/CceVh9MYeiXf8tzctEdtf6mUAWq3VLLcvnEhNc+Wc N9mptrnq5NZKEyQk1az/0H3h6WS/FyfpMFAmhgP2XbmFAoVshye/TXRZb4wjdFnKJG1cbE3lptG
 xkiLn7eB/gxmbtejYlkxgozH+spm8f9PCH+YPUQNCNq1cid9JC09FhS1SKRRTlNPLQ7Epkv2

Andrew -

OK, I realise there's an issue here with patch 2/2. We're not accounting
for the fact that madvise() will reject this _anyway_ because
madvise_behavior_valid() will reject it.

I've tried to be especially helpful here to aid Ignacio in his early
contributions, but I think it's best now (if you don't mind Igancio) for me
to figure out a better solution after the merge window.

We're late in the cycle now so I will just resend the 1st patch (for s390)
separately if you're happy to take that for 6.16? It's a simple rename of
an entirely static identifier so should present no risk, and is approved by
the arch maintainers who have also agreed for it to come through the mm
tree.

Apologies for the mess!

Cheers, Lorenzo

On Thu, May 15, 2025 at 09:15:44PM +0100, Lorenzo Stoakes wrote:
> Andrew -
>
> I hope the explanation below resolves your query about the header include
> (in [0]), let me know if doing this as a series like this works (we need to
> enforce the ordering here).
>
> Thanks!
>
> [0]: 20250514153648.598bb031a2e498b1ac505b60@linux-foundation.org
>
>
>
> Currently, when somebody attempts to set MADV_NOHUGEPAGE on a system that
> does not enable CONFIG_TRANSPARENT_HUGEPAGE the confguration option, this
> results in an -EINVAL error arising.
>
> This doesn't really make sense, as to do so is essentially a no-op.
>
> Additionally, the semantics of setting VM_[NO]HUGEPAGE in any case are such
> that, should the attribute not apply, nothing will be done.
>
> It therefore makes sense to simply make this operation a noop.
>
> However, a fly in the ointment is that, in order to do so, we must check
> against the MADV_NOHUGEPAGE constant. In doing so, we encounter two rather
> annoying issues.
>
> The first is that the usual include we would import to get hold of
> MADV_NOHUGEPAGE, linux/mman.h, results in a circular dependency:
>
> * If something includes linux/mman.h, we in turn include linux/mm.h prior
>   to declaring MADV_NOHUGEPAGE.
> * This then, in turn, includes linux/huge_mm.h.
> * linux/huge_mm.h declares hugepage_madvise(), which then tries to
>   reference MADV_NOHUGEPAGE, and the build fails.
>
> This can be reached in other ways too.
>
> So we work around this by including uapi/asm/mman.h instead, which allows
> us to keep hugepage_madvise() inline.
>
> The second issue is that the s390 arch declares PROT_NONE as a value in the
> enum prot_type enumeration.
>
> By updating the include in linux/huge_mm.h, we pull in the PROT_NONE
> declaration (unavoidably, this is ultimately in
> uapi/asm-generic/mman-common.h alongside MADV_NOHUGEPAGE), which collides
> with the enumeration value.
>
> To resolve this, we rename PROT_NONE to PROT_TYPE_DUMMY.
>
> The ordering of these patches is critical, the s390 patch must be applied
> prior to the MADV_NOHUGEPAGE patch, and therefore the two patches are sent
> as a series.
>
> v1:
> * Place patches in series.
> * Correct typo in comment as per James.
>
> previous patches:
> huge_mm.h patch - https://lore.kernel.org/all/20250508-madvise-nohugepage-noop-without-thp-v1-1-e7ceffb197f3@kuka.com/
> s390 patch - https://lore.kernel.org/all/20250514163530.119582-1-lorenzo.stoakes@oracle.com/
>
> Ignacio Moreno Gonzalez (1):
>   mm: madvise: make MADV_NOHUGEPAGE a no-op if !THP
>
> Lorenzo Stoakes (1):
>   KVM: s390: rename PROT_NONE to PROT_TYPE_DUMMY
>
>  arch/s390/kvm/gaccess.c | 8 ++++----
>  include/linux/huge_mm.h | 5 +++++
>  2 files changed, 9 insertions(+), 4 deletions(-)
>
> --
> 2.49.0

