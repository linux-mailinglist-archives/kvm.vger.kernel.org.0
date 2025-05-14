Return-Path: <kvm+bounces-46512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47D17AB70AB
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 18:03:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 86BCB4C296C
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 16:02:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 489E91E9B1A;
	Wed, 14 May 2025 16:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LZt65z8f";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="W2nGS+P8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36151A0BE1;
	Wed, 14 May 2025 16:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747238541; cv=fail; b=V/QVIE6kr8iMIqcNSrzCM6Whyfr3it3kvPY7dgn9RnPLemvvRzrt+pte1nGz2C0Fw00J4U6qgm1/R0q1O6sP+lvsuS/9as2H0mLkyAupr2xbLjpHsEJme7mbP6MrEqo0weYVwpo899s2nN787E6Q+IVSjsKy0JI7NCm9FhsTMVc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747238541; c=relaxed/simple;
	bh=bXVilDlBmqP5K8eZifCWS77Fz4IpjiHsDbSkQSwWYXo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=begOPAcR8vflkk6DDaZhF74fAN+26w9hNwwP91urQuHSjd3a/8ymouDjdrpe2ZTYXpo58w3ytONJVWOjOsoVl5+iT9mbhwEW6r4NaqsTeLHAhsmh4lU0jYqG57PcNTX0eFwEYxp+J8PXD3+wf/vhcmuyrjrfjOTxsuXCPCSZCLY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LZt65z8f; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=W2nGS+P8; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54EDhxol013575;
	Wed, 14 May 2025 16:02:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=bXVilDlBmqP5K8eZif
	CWS77Fz4IpjiHsDbSkQSwWYXo=; b=LZt65z8fyO81e0hRzs58IPVnp4mgPuVFBO
	qswmOwzN438AN0HyxA5WtA5G+Tjg1FgvZwptfUXJuj70K300WDAueaLD/y4gTtG7
	0li4KlzCD52IKFSSpAFwOav2ZNhqIP1/jvkpAI/CO8VP2lxk0Bn2Ml3fHKCNjOwO
	8+LMDU8/R95AuKxGWlxFCaKB2HGahFhDj3ygjjhiOUnxtHXnps8cTzYxK5Fmb6sP
	HbejLO7x/BFzrRZA9aUL08IRDecO8gyRQXzuEp21UY1egzLW6aEqn8kSQ/Rd51s3
	T/9Y6mHOlaj7zFxyxr7w3IHd8N5Qmq5vWc3f+tYIx9sUe2CxXm5w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46mbcht4w6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 16:02:02 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54EFNPWa016326;
	Wed, 14 May 2025 16:02:00 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazlp17010002.outbound.protection.outlook.com [40.93.11.2])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46mc33nkkp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 16:02:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nt4bvGlA587I3nokj058/Ws8eBCIQkrJvh0tNTlDpRaOf4+SZ40BWQj2O9ZAa0zutgtRGDzeJ0wnLelBlwc48dmwsQG+1HTH4aAcTnJvng9N9rhCQXtskjVbihn38PBm+a3o7tEfkZunRVOK5HFxqV2iAjVJpXYzD4sfqD1+fb2Mls+V4vEI3MtMYAlXOYLwUnsqT8ydd6OqGq0CHYnVGF/6GURwRwa2pgyCgIC0AL7++DAC+iiKBm+DQ2LSsKxGHjl+gXp+pNYkS41j8vAAJp6zpByJcYRdxozPJZroiFMltGyBwi1ZHC1j1Y6ds4p2+gQP4oI17fswdqO/azwjqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bXVilDlBmqP5K8eZifCWS77Fz4IpjiHsDbSkQSwWYXo=;
 b=qTWQ41oRfaLfUlZ+37k+H0B5IBR2u5D02j8umqLGJkqwc6fliSXFZEuWknsYui4aqjtR/85qWtWzZSOQLTiyWJmz6z6mWkzajUkMIB9dUWXZRO/HRz9X33a99bSGys5/InK7QVzEasxz3EHbCgwaxXypXZkBEx+b3vEqjBzMv9TPIpzGvhTkg5gptHnBQKIyrfXuPPrX944rQEAtzAFpNWT+DYGGEnMWlGBjY7fvM7p1lRjG/5p0PVdELpue+KGB92GOhicYY3HTc6+VBIp2m4aMYkUVXkMSdZwlleKOgpuwhjmW9WI1VV05HYWD/uljeUifheKOKIwWDlMt3On45A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bXVilDlBmqP5K8eZifCWS77Fz4IpjiHsDbSkQSwWYXo=;
 b=W2nGS+P8Xbijq4oC6pcrw4oL8BdOvs5MtwYNaI5Qb6WpYKQ7W7SiM9v+gs4IPaWglMzIZTRj8cKdDV7EelepSFevcidcDalDXix8MiTBimrirHKHA0sorD7sjCk2x7kCZci5LTAT7PNFFld9nbo1yxTMNL6D1DumJQ4xrfcwywM=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB4471.namprd10.prod.outlook.com (2603:10b6:510:38::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Wed, 14 May
 2025 16:01:58 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%6]) with mapi id 15.20.8699.022; Wed, 14 May 2025
 16:01:58 +0000
Date: Wed, 14 May 2025 17:01:55 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>,
        kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Yang Shi <yang@os.amperecomputing.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com
Subject: Re: [akpm-mm:mm-new 320/331] arch/s390/kvm/gaccess.c:321:2: error:
 expected identifier
Message-ID: <6d415e22-9461-4434-9a0b-25423478674f@lucifer.local>
References: <202505140943.IgHDa9s7-lkp@intel.com>
 <63ddfc13-6608-4738-a4a2-219066e7a36d@kuka.com>
 <8e506dd6-245f-4987-91de-496c4e351ace@lucifer.local>
 <20250514162722.01c6c247@p-imbrenda>
 <0da0f2fc-c97f-4e95-b28e-fa8e7bede9cb@linux.ibm.com>
 <20250514164822.4b44dc5c@p-imbrenda>
 <6f8f3780-902b-49d4-a766-ea2e1a8f85ea@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f8f3780-902b-49d4-a766-ea2e1a8f85ea@linux.ibm.com>
X-ClientProxiedBy: LO4P123CA0460.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::15) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB4471:EE_
X-MS-Office365-Filtering-Correlation-Id: 9852a14a-634a-4241-a415-08dd9300a7fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0tGe35JOuWIl8jFt+TclS6IjBO1g8HpvfcM7eNgw5sWnYu+T4lLoTU9DzuR8?=
 =?us-ascii?Q?VOvElbdrGWC58ku5rurFxFVID9KFhxCYsrUD8tvK7R/Zk+qxc0Sxg3RAf9kV?=
 =?us-ascii?Q?If5Jw/JYZHqASClQewBdOcLfeMqUXu3fo3EBkKuyzhQbNBALXvRiEc8Koy7i?=
 =?us-ascii?Q?rQHp+S3IJYiBekHvs7zFCVYR8v+IstJ5VDW1PkDdUcHbMsnjZAEYzBgTlP7K?=
 =?us-ascii?Q?Wzps6LdbMu76QQwiRRTV7yL207wvsP/KFRaLc/XoN2A37YEx8Dsgfd/eN/Oj?=
 =?us-ascii?Q?BSs2MghShFQcZJBVe0OaIy0THZdqsbu8uSKkasW36EWBwwfGpWzOauzfy/3R?=
 =?us-ascii?Q?7136NCAaeA6Gh/+pxVm4tYrqmdLDVqgtd+TUl6bjtcmkDkrPwujUNJdVOB7p?=
 =?us-ascii?Q?5pVm1rPe3M7VKLvr6jxuMjI5V5HFeaGDMEgKz7uF3Co/9zxnWZJT6Sz2BuZ9?=
 =?us-ascii?Q?WVrP0irZ1EyXioyvwHeIFiMimhZ4TWzjQpYALieaQUQLPOj7U1eLnixUYgW1?=
 =?us-ascii?Q?fwMy910sZSDPbaXx9aaSz7AyvS11AbzN4ZU0ipv6YFXCCIHIIJ9ZzAZQ1FLs?=
 =?us-ascii?Q?JQmxvUff1LMfKfDOsz/RivbpI65wi2LZGcI/s83N4tuOgVluEzNzj/ucH7t1?=
 =?us-ascii?Q?6TIzTSmQ2UuUmCtavy2OqkbzOvvLU3TYl+p+Wbw8fLhzbnr9oXp/l+pWYJZ9?=
 =?us-ascii?Q?G57sSEuTJc+2b2WE6VvKU5kTw9H5qSLZGe0zUc4ESwQBwDbajP5VC2iSc4Qw?=
 =?us-ascii?Q?R2gqz0EL1HGhoMEczHunhldx5A/iKH2gbuNBNKOhFxlZi5xQMUScXICYqX39?=
 =?us-ascii?Q?02Ewop7tKE25QT2aCuERQ8z2MAVdAv1n/JL7ZwAh5Zaqq2TR6UZM1Xo+9cat?=
 =?us-ascii?Q?wJKxqzUFHUNc8dxK2JjG61QkfM/h5oYA9Gp5UHhg6gv1kHDnv1hIoYduQ1RG?=
 =?us-ascii?Q?3zOr9l0HTkzA5+U4bHlaqQkVJl82UsclWM79zFm8+WjQ+f3LxiN76m+Ukfcd?=
 =?us-ascii?Q?3C9OYSYC8isWyoN9A5xBLDHC5IiMbmr6UxZZV6JokS0PTHLswMLJnwA2BJF2?=
 =?us-ascii?Q?yCmkOguMc+Ps44UhGLJtFE/8p/uX6WMxVLuuF52Jz3zJHFL5SMsHJ+A+y7fS?=
 =?us-ascii?Q?05WKH9tPyX4R66WVwBPWVh9RhCCswThlaWGlEFlTRkwswp2OLZxjvS3vp7/d?=
 =?us-ascii?Q?c6DgxjoawEXpE4eRv2RJ7x9xOG8p3RP6owB9tEMyWUzQx4u/ygaL8AwyKA2d?=
 =?us-ascii?Q?vKPk2ZsxnKz+7oCyRHDdf9rzDaNIvQHO75Z+zIHQDJhy7busZ9AomZTjobAZ?=
 =?us-ascii?Q?CBCZNYY+C8rHwVEhaYarlzcDBix9jp5mt7hNR1trtIDQLn4ATbH2u4BKf+El?=
 =?us-ascii?Q?uknxgIyNC1mltU1YnHq8ChbL0geUQcyuc8c1EfGGcUBt4+J40a3o4BUWCIUr?=
 =?us-ascii?Q?H5hCaHuR4Uc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6IxNN6HmOd8opBwxvMoXVn1/Tt8dzb46PE2RD8fR2YekXEVngIerbssq+3ho?=
 =?us-ascii?Q?c8b8U3v3/T0aF4ewizDA1Gp66G2suq4DQl9ySbceK4cZOHyCNTSxzhkN/JOY?=
 =?us-ascii?Q?WYFroEwMq0LUPxga6OXfApnirCrgtU23Vqv2tIIsnHYEc3+ScbNRxqpTNMg+?=
 =?us-ascii?Q?INJ/exXEYAmDQgjzKfGR0TqykPuFg2C6YillNLB+MvckRyDS7++NrZ4Mn97C?=
 =?us-ascii?Q?FhlYnqdq5EZ3wd3pvz3HMlCQm1g+ODoX4pHrVKAup+LF5/6WlOZYP9RgUgkH?=
 =?us-ascii?Q?J/HAKnm3bWQOcRysH7k0wmkTAN6D1IU8PyFEt0bgw/WUnG8JoclYtEE9AzLn?=
 =?us-ascii?Q?m54YudwDScqFvz2AyAKhh4h+KyghVDgn6vXuts08UEavJmFizTxc6mYTF7Nx?=
 =?us-ascii?Q?IQaxRpE9ezIhFbUdZCBxHaEYz+qWHuIZzOZe4R9xVxrrPKr0YnIrZ4cKjquD?=
 =?us-ascii?Q?DRKxO9VQw5QpcD3ThfLUNcG5IP0YyO6OlYYTPStlI5MU8R8aFxxxPNAc91FD?=
 =?us-ascii?Q?NYhi1C9hnqIu8WY8Ep9GZsGbxoeNddG/PUwBqkgtDDVnxvn/hIMpqd9Yv+Cd?=
 =?us-ascii?Q?NaTg+ba/4/gY0D+80UfcbMzA5bU5ynHmxnUpxIrmT9VD5J29DztDGscarA5t?=
 =?us-ascii?Q?PC4uE1U2dmT9Y/vlhmFmZ4FMP1PJFtnYMoFXXltOmM7WAkCIUuaqe0EgrweJ?=
 =?us-ascii?Q?X1UhVIh+igSrRC4XPzyBP7seMejY1Vx6VJlxtFBbhMiEn0rshjNRVU7wdTk/?=
 =?us-ascii?Q?f/k7JC/fW7OZhzWBzQAMLOlltJY6f3IcYFu9bTGyy1A5M0ahCUsMBsCUx/7N?=
 =?us-ascii?Q?eMc0+1s9hT1nE2B/oiEt9SLnt4evrBI3EVk0RJoaQfCK0+FneoO//TZ2vXUB?=
 =?us-ascii?Q?QlbbS8O0PDTCUSOkSJTqB0+ty7BaFK17lA00vKWOf/OxHaLlAhvOy1smvFs0?=
 =?us-ascii?Q?I+l5e89DBZkTC+1jUHqxDMP6aS28eH6soImyaPkFqsmNkPWh/IMAWRgvxYxh?=
 =?us-ascii?Q?cBYLoP+gbiy8DdyQ+2zn9tqN+JJ2ND2LSYQzgyBTOse/i8K13qyu54J9c0wI?=
 =?us-ascii?Q?SrDJrUo6TLaICenDquE/e2qvMOdECQyJFI9tiX2SfJ1UuC4cIKgzWkIXOJKV?=
 =?us-ascii?Q?YsKRE6BLT/xFoGZgldptL9gJmywiwBnXYhj6OgmzsQhiAixzposaSfNJv8Ea?=
 =?us-ascii?Q?Azas9Pu4VRCBFD2TfT0Mg4lb03EYWMYMO+O7yb2VIfUs3gb6BtCsBIZaycFf?=
 =?us-ascii?Q?JigHaFHE4UViYTU+zbPDt0lQuchk8dluxSPzj73vGbBqrcL4Qsr1aW5iwb7f?=
 =?us-ascii?Q?soCJ920EyeiAynlfUAGKUHGbsS8qw5xRmAo3OH/sYzx6EEBgO2ZZYo75TlUQ?=
 =?us-ascii?Q?vFjVqUElAotMYTp7H6txwTYsLFYLqQwUgEuAjp5Yn0V2v38uKrWvYu2pCHCf?=
 =?us-ascii?Q?wU3o4LO1z5Cv9EsMzsFwoPEwu8b0axlctctqKnqZaie7Q1U8FTR32MkDLTlV?=
 =?us-ascii?Q?RKT7aRhxo/gF5CaoXDaVTpDB/b+FNOa4a0CFgxHmv8mFdkMB/8jzD0oLR+C9?=
 =?us-ascii?Q?fsE4vGRaru84TC8f2cquDBVKAQLgNHW+RRYvRupjMC8fciN577ovFigGjqtZ?=
 =?us-ascii?Q?0g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kehr4Ni08uGtooQKUI+h3gmy74Re/mMOOSdfQmjBOaYFAdReHzEoLaGQMqzU5nZyV7U6bYPlAyUKZL9y2Yxj0f1o/vPPaoKgKk2n1boP7G6tGE4pL51De2SLethqRFufXbXO5KJT7uZjHMFfCqMukMPYwUaVpaukK8o2eDCfYMJ6EfDC2V8xXKB6Wm5uz252tVkB+SmlhH+ATf3Ezsj1jlnreEWHdZjS3qn19NesPBqfcJS/Pj6viWre2oPiL4aKj84zjL3JYGnggqniLlknhPaYIkjeVZ1FJ8XSeYZE9ULxLXZUzL8rRE3/+Bd2Tq6b5tdq0vTH4L/VhUwN90WZDMLIFbOdim0YWcj1/NZzj5phQt+7fNIZCpkIIEWplQcum2cjk/4+S3nLQztQoCynMEjRfvbqmmh8FXk2qgkuKvdFXYejw/ZJjed5U2JuqP+hKIcmaHj3CMhwC1Jhf6N9BU+whAoiWvS/xfH81KA/J634bU+/4335w7E2vKkWqMmIT8VVfDC1irt+Wso3MRgj3Cm8YoJV4x5oMJrc3RZl87gcwiyY+WDbAWS+fCClwRuobSTSVWHJujQNE5pJA3CkmmzuhlFDtNotXcEnuFvNEpI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9852a14a-634a-4241-a415-08dd9300a7fb
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 16:01:58.4766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MPAAghNmGJmlU7B6xhe04EP4CQ0oyiHihKamUm/CMnPXOM2l4o4idRpAk8awrNFzQfjTTD2buJfYXGrvFxLEA8FkyaAtTOq/67wfhvDG71c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4471
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_04,2025-05-14_03,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505070000
 definitions=main-2505140142
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDE0MyBTYWx0ZWRfX7HTu9QUV5j9B Kq0ToQ0UffGvHmk+eKJTFBG9jDaXO6zviYEQS/KEY6gHZZabvf0TGczxap2YXB3+OH4wrjcC5Io 1yfR5X+kvuNCS7dwpKiKXpI77MQKq0LHXxva6/Ej1htphUPCGhWMPnESjitT6G8RHcS71moSl6v
 jOEfKUGyA5KMlzgleDEF8CEkCaB9tQFSeAbOB9gKf+WjSJwxcuPAEyMN6kQET3uxQLhQDgd0Sws 6tTlFdvOI71JnkVyai8ysL8ohHeLr4zTuXzkY2DVwQUpeZ/NPN28lQDLgT6ReVhmPUSS+Mqdah6 HFQkR86iN/nVg6KT9os6dQfetIqx3aU6VFuntyPY9TuQg7xZKzopk/jcZVExa/Np3N5xaHklNoK
 cQ04FGKw/mNIFsBgk1C3EZpKzEql8NFqhCpjC2GX3pMqtCblqYN4BfT/7H19JhKH5qEmmR2d
X-Authority-Analysis: v=2.4 cv=EtTSrTcA c=1 sm=1 tr=0 ts=6824be7a b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VnNF1IyMAAAA:8 a=PDvsdybP3AEZAJ1VhIIA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13186
X-Proofpoint-ORIG-GUID: 4Gu2uXDhdy33aoaNJDyx27nlxnDLo0KN
X-Proofpoint-GUID: 4Gu2uXDhdy33aoaNJDyx27nlxnDLo0KN

On Wed, May 14, 2025 at 04:52:18PM +0200, Christian Borntraeger wrote:
>
>
> Am 14.05.25 um 16:48 schrieb Claudio Imbrenda:
>
> > > > > > A possible fix for this would be to rename PROT_NONE in the enum to PROT_TYPE_NONE.
> > > >
> > > > please write a patch to rename PROT_NONE in our enum to
> > > > PROT_TYPE_DUMMY, I can review it quickly.
> > > >
> > > > if Paolo has no objections, I'm fine with having the patch go through
> > > > the mm tree
> > >
> > > Yes, lets do a quick fix and I can also do
> > > Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> > >
> > > for a s/PROT_NONE/PROT_TYPE_NONE/g
> > > patch.
> >
> > I'd rather have PROT_TYPE_DUMMY, since it's a dummy value and not
> > something that indicates "no protection"
>
> makes sense.

Thanks for the quick response guys, did you want us to write the patch?

We can put something together quickly if so and cc you on it.

Ack on the comment above, of course!

Cheers, Lorenzo

