Return-Path: <kvm+bounces-47029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BA9CABC7E4
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 21:34:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AF9473B318B
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 19:34:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22E5820E338;
	Mon, 19 May 2025 19:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Txy6LYzQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vhiAFuK8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9251DE2CE;
	Mon, 19 May 2025 19:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747683255; cv=fail; b=pJoN7qpAWtQDun66PZcN/vt+S3RfKoqrrJAoTiA9mmAJdGnuGNpHTEbwZe98yktRB4xjQghTPqXrAU86gcsoBFbkiMOyAQgblPoqfuisRlN99xInx8Cwd5iVWFDALlCGo1iHzAvJiHAuun6dNvI0E3Pyp6i9o9KTVbs1VkW4Wlk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747683255; c=relaxed/simple;
	bh=CkzJeKDI3/fVt81CC0RYz/9oZ71RszRFYV0yia9H6pw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rBcInLQjVFDJjJBCqDt3hBl5Gho+9PNLmU44s8N8VIst9t28nKMO/m4fQmTiZgWV344qHlJt80oNGtWnhkzbiSrSwNr/Ng7wulhF5JRAIc6eBpyi64l/0ksI55f8sWl8LjZGZ6/kjumZqMj/M+FDH5INZw3+k4cWjujQrvGclJw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Txy6LYzQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vhiAFuK8; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54JGMqb3009188;
	Mon, 19 May 2025 19:33:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=dRp0+tUZjgq6Vfu6Mg
	/UN3e8Ks1ImyJJHnKLOIiENM8=; b=Txy6LYzQl5R9dyQ/PWsQQHpsNj/gVO6OsG
	CKWl/n6Zz7traPmhjj1cD/kK10UXsXIG4LGUa2hK7vhELMfdpWxP9yitK+BIZhSQ
	AMZQwlqewxsDSFyacSdTjxyUInZa4zNCmqwCYouVGJUn+is7osWrYVqSXBCbCLgo
	U8eI/akQWEf1TU/LBzRLkPa0uhNCxK47d0ehiF9VnCTZFvo4ojpcnnGMysPlJyKv
	6RIwttn+s0bICCN5q8yopNFuj4ejt4KzuSJMWHyHeRynZjlgb1MzThFZeMHY451S
	YGkkgRkcpmZYEjfeU0hoqxXoSZoGdLccK700/3CqlSOo1i0T54vw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46pk0vusq6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 May 2025 19:33:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54JItVeQ017346;
	Mon, 19 May 2025 19:33:52 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2047.outbound.protection.outlook.com [104.47.58.47])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46pgw7btb7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 May 2025 19:33:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VTqhQL4dWN/448n0Ui6u+w9mXS4yzKkHfM/Pm8Hem+3qx8Xn8JTCUBy5JloGcbgrrR2BSrozvy24f/ghbhbNjwdzW5LRuLPPtD2LEo2JmkkNgcli/iInqYxBQHpWZQLyJxxXqanqqEXkMacTu9Hkc1IrLux099BTBvgQeGV6lU5w08HHf0kZ5MZCviLppC9kbXWj8NCkqLvciHjYt0IlGZ9sNV7mzdZ8/tfscVHYLX00UPxDcqROgWR8ac0PnBbXPaDvyaBIgz0VhCsjlfa1FIcSszfGlusmDb7hL9G4qQcxDklTi9bF2IHfRXDE/gSaWrgNHwcIYcoSiRTQZ87bMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dRp0+tUZjgq6Vfu6Mg/UN3e8Ks1ImyJJHnKLOIiENM8=;
 b=trHUfaFG0Vs90srKjdrRWZxQzm3i42Ewp3TJ24dXYQryzkYtIbi+tlsnCrtSAjlxv6heSIXDJ3UOp7jHB9VL8u3XnIlOvJHm/uI/xh9CzwuXLKCsqdGgjf0OgkjFPJxXkIdSWwqd7+1gyt8lhHgGHfxC1t3gEP3z1lbn2xM1InwTCd9MGTZ8L00ijwMw4I50D3JXPVRSAhciesEmxrZBLX2VrSzB5RxcZ0yGoYWwfdmf43BzSgJ6EhU28IU510PFDaZOwIXiXEjN62oWE785dDm6I7U4iefJzaMj7HIxWFxawqXCHzNrvhYKv/0ek15qNFyNOYzdQB0qxnOdyusLQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dRp0+tUZjgq6Vfu6Mg/UN3e8Ks1ImyJJHnKLOIiENM8=;
 b=vhiAFuK8yhms7pOtNJtvOgjCOlmv/RDX5EWmTFiGSN0nEnMWvFAqKjurwaPwCFefbUIk8dsC78rmc7nJrVEdXEdbxgwsNcCk2ySOXVQmSsanxN1pzQPLP4huM0zWhk1M0AnmEMCHQmG4VDJbgvtz7r7enDeKKk/e5OdpNo28DwQ=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA0PR10MB7349.namprd10.prod.outlook.com (2603:10b6:208:40d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Mon, 19 May
 2025 19:33:48 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8746.030; Mon, 19 May 2025
 19:33:47 +0000
Date: Mon, 19 May 2025 20:33:45 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Yang Shi <yang@os.amperecomputing.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        James Houghton <jthoughton@google.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>,
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
Message-ID: <2135c0e3-cba6-4415-b3a6-cdaaceb57814@lucifer.local>
References: <cover.1747338438.git.lorenzo.stoakes@oracle.com>
 <bb9d43d6-9a66-46db-95c5-686d3cc89196@lucifer.local>
 <f781e51a-b193-4bd1-abf0-71f816aa0d5e@os.amperecomputing.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f781e51a-b193-4bd1-abf0-71f816aa0d5e@os.amperecomputing.com>
X-ClientProxiedBy: LO4P265CA0204.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:318::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA0PR10MB7349:EE_
X-MS-Office365-Filtering-Correlation-Id: 06df7ac3-dfd3-4e1e-279a-08dd970c1337
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cgn3Sg4AgM8VFtc8YyINgJflYY6BVhac3KnOGjOY4jGtdv2FHbQkGz2Nuy72?=
 =?us-ascii?Q?tJC+2SEBGMuXJO02IJPzjvYbcjo2gc6ONQ2Do2FtusVMwfzdUdLCLqibsAQK?=
 =?us-ascii?Q?A1CPBhPjKuaDtnBXbPNMVY2XorHuV/F+otJ9w+y+8p0KUPYIrwEPrF5q9L4v?=
 =?us-ascii?Q?YDsW/vUbO8nnmg28xaLilTCqD/atA1vxfy1/HoDX61GV73hVuNwIbJL3cxJC?=
 =?us-ascii?Q?HtAFPZt3nvjWuzbcRCKppXjUNPJtWGN+qxYFIt1ZdDCEqDNgQksP/Dh9EX/h?=
 =?us-ascii?Q?Mg8/h5niQp6rV7x0pjdru/9qb89czVbaYXfTTNS239FBSnyNKO0+T1AAWPQ0?=
 =?us-ascii?Q?igeJ2lWXHPouWUJko+t/Qf2udcTyz9YBegjab4vQk+9b1lsj7X17b0hXq2yg?=
 =?us-ascii?Q?bCh3iiJZdQN9iREq+lohYPxl8WMga/0e5qEzulrv6pjvuK/sK78TYuje1iQ8?=
 =?us-ascii?Q?IM10W8Xbxw06/N/FAGQhKCWZgMqS46Qvt4DrZHdbW3Miq+CNvJCiPk56/KxH?=
 =?us-ascii?Q?u7g5IyYwvb+mqAf6JixOyHtM13ObpBdTRGIcSTTf2EpaLn6XP/jn3uPhryQn?=
 =?us-ascii?Q?kQSrmq7Yzx/IEIWt2QbvyYV92yNvtbK0maZhR4RTFZ5lzAhMDnSbyiD77fKE?=
 =?us-ascii?Q?JBJzoRjEGM5cjUpX77MmJYv1QOufUgrXtIRduvfQBofk/WM35SA+vAZFZYAR?=
 =?us-ascii?Q?EuYHy/r6ztb7Lsg+GZYuAoX/cQ6C9ZQ6E50BjnaDA41Xv/c8oBDDZuvGkoqF?=
 =?us-ascii?Q?kWJ3nel8KbJ5t+aSoG+S/d48E9JU1XqH1Ijk8dVyDNVayjmgiQAIlfUPpAmU?=
 =?us-ascii?Q?7Kr69eUjt4xu7KS/rG7PBd5w6tStldi53ueSmsxVkcywJ+ha0OlsUFhdGRv0?=
 =?us-ascii?Q?sUnU12gzrCDmHmVNKjk1KIx5j9/fRSJTfeA+Gu+Y+FQmRU57GsZ+71xag0Xm?=
 =?us-ascii?Q?CJWawDJelaWsVNIp+T5JwMr8MtE7mSvDzuop50NkuZrUH3RXfEaSt3w89siL?=
 =?us-ascii?Q?Gb0zoNB2NVgHKyKSwwT416pfD3F7VhUdjMptl0RES3C65KwJUfZjGEnsZ/PS?=
 =?us-ascii?Q?9dmeFZGSJuVAYMop7WT6LfSHSKVqJe/fpVXpOrcwe0ivtySJIy80Z8W7NH9b?=
 =?us-ascii?Q?hrSgNC8MqXYbeh5LNLna/Atd8uQ+GEGv/zbVBWPLmaKNM2l69/E+OaDYyH3s?=
 =?us-ascii?Q?1+QkK2KaR6bmTYM/S3LqXb875xHTJ4m7gLbwdporlXUxZe63EcVOhFML+N7W?=
 =?us-ascii?Q?LoB4uR4Jp8zhtrq9KLOkBP3iU8rLKYFVzrGn7LwqP6+8W31Jr/cCaMZhMI5R?=
 =?us-ascii?Q?xfWvSGBxyfl6gl2FQR2QQti9fKGH0lFRvTvb55II0GzDDUGo5Au0Km8PyMg1?=
 =?us-ascii?Q?Drcc5NlsA54lulGFxQRrcwAxNhrmkBlbKX3qG+xg3Jko3nvYIpT2FWzkTfg6?=
 =?us-ascii?Q?S9x1ZSTWR28=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qDR0pjUnm1BXl0MZRqHDuldK8JSelDuBI7VYsGMjkcEpYggAbyaFmcitnJm/?=
 =?us-ascii?Q?pwr2bhgJoiYQO/fk2S/LVEdCf5KGLGqfSvRZxKPFBhffs5cxmDB6Sys+F2rY?=
 =?us-ascii?Q?TTMs5ILa614zSw6m8FZiaA9yuvOl/fcf7wCjO4/WwJExNoitMQPV+JMk7N6Z?=
 =?us-ascii?Q?r2Rz7hzW2t3GtXYN/EVTgOZrljv6hDSfUCY4a8OS42OZVjbja71SywwQXT3Q?=
 =?us-ascii?Q?Lmm0asOsvHTsNyyiFbnB4yNXiQ3Ww+E4wYab8DjSL7IVjV559iTCvU9YaNh/?=
 =?us-ascii?Q?bmtvuIs1RgM2OTmQiglBE/QOjIe7dama7uQPh/Jjoz45Ir6B9Y6JlBUNfGEH?=
 =?us-ascii?Q?HwJKJLnZC766us4YIlwCS3iDHjS9p3epuyzMsXV0FfgEcfPVGK4FrcDjr5y9?=
 =?us-ascii?Q?MainIxMmhkHPjcfF6OQ8w31Sy0s+9tigf5YUPa5MHphl0J6TQcO0Lfo8Dnb4?=
 =?us-ascii?Q?KYREnO4+Mii3+qYpfUHhDlRDqASC27ARl+/2RiPOtoBGxLQIC0FfWeph0Rcq?=
 =?us-ascii?Q?/jZauqfcV2wx20YNWGVLY7OEdxhb24wUkj1h6adyGoGAI1rU9kUlEAIAGVZZ?=
 =?us-ascii?Q?k8ONX++ODw8vzLfAaRUBOFBOfDII0UX9Q6W+md4QVmhlMqWQGLl2sYpH8i8u?=
 =?us-ascii?Q?I4Xq8nAJ9tfYUQBQgxXdKXZ9SjdqOkTsYtcmgvL5puuGQcQ9w/jn0wrmQyIS?=
 =?us-ascii?Q?WQqRYjzmYhthXavv/o5w8EyHOBEbWMfkOvIgK7W2j1Of112s6aC/eYiPgYe5?=
 =?us-ascii?Q?fv7xuo1PXPKU7sz8SlLrlxs8fltjlHi5jqcXwR2OHRlImeo4IWMrNTSoyeyA?=
 =?us-ascii?Q?d67Pg/B4mUZRHLzAH3rzy7eoo3YX8BoSr4cgQqyt8QyENiUs/Dc32flQRi8y?=
 =?us-ascii?Q?+1xwb2dq5iYuDeLrIZkj+NRzZVRYHe5kMJwY6AX2cJoWSh9XfMfL/E8izl2L?=
 =?us-ascii?Q?Uw1X7yvrsz2TwFTca3/cZCxKEEfDJl7EPh3z48OLsxHmR7jSDyy6BoW1CPw0?=
 =?us-ascii?Q?9Xz0XPqjuVLCF6nbLgLoNsfZYS0eysJf793ScrvwngvDLAAEOszzNtN8jFiB?=
 =?us-ascii?Q?WtwL/deyHjwV47BOdDHMp6bKL625yLYweNGrh4Yw5InBCLQ4NuamCVJ7XLVB?=
 =?us-ascii?Q?HH2QWgtvxXOhgPgL3I32Yzf0fO9Nx4uByO1OVAMvjQVeUxlR4euFyiU8g2Uf?=
 =?us-ascii?Q?g+nG7T6o8XNQk0y/6+4rM2Go15vTCRI3vrm/raevdrthvrBlqGTXwmrLaxmQ?=
 =?us-ascii?Q?bX1d868kZ5V7gPF7t4348ovMuj/DLy8slL+9zLq/7nLBfDAKtt1bgywrNGfL?=
 =?us-ascii?Q?MIeIoXUZia3tGqT+dvTn/Px6alYJorFI4fzauiCtvov4ZxW6xdd+BZ/rQ4ei?=
 =?us-ascii?Q?g2ZN5tP92X3hBnpU++VkrBnuC3fSqLhHcWyVTTU536py+Kt76RfaHA91dAmc?=
 =?us-ascii?Q?MsDtwjTymzRzDZ/Kmb9T6cVYASNErWqozdjOvHaeHpm0tvWmlKTXO2nEtFb6?=
 =?us-ascii?Q?EmQPZ6VAN9YEqOfpERpSwiCCG5VRG5jiO7ISEcpPEr1aE6/MVZGJ2N1fL6l8?=
 =?us-ascii?Q?SwUnpqXTaasQAsEsR5kN5LRrgzrQ+t6z/gxGjRooDfn3wW3B+FLBgJynhlNz?=
 =?us-ascii?Q?gA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dvnyo0Ltcla1hLKP+8hhnmxxlEgcK4+ftsN7yRtF6ATbIqXKRiDu3TFjVDoNaMHQHOSm+CsRjCKNZCxpf0AkuheloliqZok+32VhHxN0m09wPdi6jCNv2XGD4Ck5ja5dgeuzutjT8riixZwi5a+l1G666fOLSrBmyLmDDxZ54lKZfEcMzxwdcvv3qQ3PH5LOMOjQYSMn88t5TWgrmWFNmgDI/jPFRd8M1ntHqfvgOQlOoxvOkgLdp14apzs2bjuBlg8Q/5EEfVvVABC4XK6/NRNe4ApvHvwQ/4ljDZg+WYOf9U6cGVLDuXUVvfs2DJRqAoxGYwVgM6DbEnIItrlMCZXrK15qH/tRUGmOxSN06Ahg01AcDkLIK4peolwHFwaLvQSp5GjPaiGzd+MC8PU97vYVBXC7h916EyZ4ocW7zVC46eekIqjZY73DllA1IHfE/5Y63zAiAQuFvRxgqvbAyBHFc27azyI2Fe0NNmyR5b/z+deb1YlFJ8DgR+605GK0Yb3yjk+l1IdOgg9BVGAiWamHlMruQebGukcVg0V7jb042Dv3hkj9rMVSOPQp+tZNY5zaUBygec3vSOipuRt0SoM8qJfucREoTkIiRoof76o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06df7ac3-dfd3-4e1e-279a-08dd970c1337
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2025 19:33:47.5084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e59tkLfKbmtl31npeGmUGQta/gq4khqKI1MRwHZI1FaT7dU85gfZ7US6jOphN0hjrsUirBie4PldMsW8lc82kWkcZRWedagN2eksLhen2vQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7349
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-19_07,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 spamscore=0
 adultscore=0 phishscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505070000
 definitions=main-2505190182
X-Proofpoint-ORIG-GUID: usRcH3PRBWVEsd76TLDRj2c7uAS3OA2t
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE5MDE4MiBTYWx0ZWRfX4Br3KAi1Eoa0 GmH7FvZ13i6Dct9vScibOQdgS2P2F/RX3UkbuSipM8zbfEoiM9BLsGkDekBaWqUMwJPk4G+okKp 443LnqwKlO2ADgxmsH6/dhbG+WxpVr/5jH6cX0sFC9IlB5DATD42SEvcTrCKBKgI7LeFkJTaf6l
 eyUYJJ0JVSWbPHdanR3nDjBb1PeUhPNC0/sTdTcyUdyBeG9hrXqHiBrJqXs4ZvFudQ8QPDD93hY 5BlFeQilnWjtW8imFJCAWxoX3L8sdSczC3aExG4xw7bLKX9UAiDslyFK4P5bvLap8Eeryhe6jHR TWM3wLrsJRjKkNwK98ITLe+/6wXKP0tE0/1pqnSsSgHHXtHr0V2g89J1k3zJC+tcz9sMVHuUNYp
 P0AQ7qMG9rhe9VQL8p7DdZJ3/rDdJBvz6BgppSIX2V2Q7zWlTbq35uEXbG09T8H1pg7PIdpZ
X-Authority-Analysis: v=2.4 cv=CMIqXQrD c=1 sm=1 tr=0 ts=682b87a2 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=TAZUD9gdAAAA:8 a=yPCof4ZbAAAA:8 a=Z4Rwk6OoAAAA:8 a=8-kmiBmAeb0cLw4jnqoA:9 a=CjuIK1q_8ugA:10 a=f1lSKsbWiCfrRWj5-Iac:22 a=HkZW87K1Qel5hWWM3VKY:22 cc=ntf
 awl=host:13185
X-Proofpoint-GUID: usRcH3PRBWVEsd76TLDRj2c7uAS3OA2t

On Mon, May 19, 2025 at 12:31:04PM -0700, Yang Shi wrote:
>
>
> On 5/19/25 7:43 AM, Lorenzo Stoakes wrote:
> > Andrew -
> >
> > OK, I realise there's an issue here with patch 2/2. We're not accounting
> > for the fact that madvise() will reject this _anyway_ because
> > madvise_behavior_valid() will reject it.
>
> Good catch. The purpose of this patch is to make MADV_NOHUGEPAGE a no-op, so
> we can just simply bail out early? The point of madvise behavior check is to
> avoid taking mmap_lock and walking vmas for invalid behavior, but it doesn't
> consider no-op (I treat op-op as valid but do nothing), so if we know this
> advise is a no-op, we just bail out by returning 0.

Yeah I was thinking better to just do it in mm/madvise.c to be honest.

>
> Maybe MADV_UNMERGEABLE should be no-op too, it returns 0 for !KSM anyway.

Ack, yes could maybe bundle up?

Anyway I didn't want to delay the s390 fix any longer and this is a mess now so
better to defer to next cycle I think :>)

>
> Thanks,
> Yang
>
>
> >
> > I've tried to be especially helpful here to aid Ignacio in his early
> > contributions, but I think it's best now (if you don't mind Igancio) for me
> > to figure out a better solution after the merge window.
> >
> > We're late in the cycle now so I will just resend the 1st patch (for s390)
> > separately if you're happy to take that for 6.16? It's a simple rename of
> > an entirely static identifier so should present no risk, and is approved by
> > the arch maintainers who have also agreed for it to come through the mm
> > tree.
> >
> > Apologies for the mess!
> >
> > Cheers, Lorenzo
> >
> > On Thu, May 15, 2025 at 09:15:44PM +0100, Lorenzo Stoakes wrote:
> > > Andrew -
> > >
> > > I hope the explanation below resolves your query about the header include
> > > (in [0]), let me know if doing this as a series like this works (we need to
> > > enforce the ordering here).
> > >
> > > Thanks!
> > >
> > > [0]: 20250514153648.598bb031a2e498b1ac505b60@linux-foundation.org
> > >
> > >
> > >
> > > Currently, when somebody attempts to set MADV_NOHUGEPAGE on a system that
> > > does not enable CONFIG_TRANSPARENT_HUGEPAGE the confguration option, this
> > > results in an -EINVAL error arising.
> > >
> > > This doesn't really make sense, as to do so is essentially a no-op.
> > >
> > > Additionally, the semantics of setting VM_[NO]HUGEPAGE in any case are such
> > > that, should the attribute not apply, nothing will be done.
> > >
> > > It therefore makes sense to simply make this operation a noop.
> > >
> > > However, a fly in the ointment is that, in order to do so, we must check
> > > against the MADV_NOHUGEPAGE constant. In doing so, we encounter two rather
> > > annoying issues.
> > >
> > > The first is that the usual include we would import to get hold of
> > > MADV_NOHUGEPAGE, linux/mman.h, results in a circular dependency:
> > >
> > > * If something includes linux/mman.h, we in turn include linux/mm.h prior
> > >    to declaring MADV_NOHUGEPAGE.
> > > * This then, in turn, includes linux/huge_mm.h.
> > > * linux/huge_mm.h declares hugepage_madvise(), which then tries to
> > >    reference MADV_NOHUGEPAGE, and the build fails.
> > >
> > > This can be reached in other ways too.
> > >
> > > So we work around this by including uapi/asm/mman.h instead, which allows
> > > us to keep hugepage_madvise() inline.
> > >
> > > The second issue is that the s390 arch declares PROT_NONE as a value in the
> > > enum prot_type enumeration.
> > >
> > > By updating the include in linux/huge_mm.h, we pull in the PROT_NONE
> > > declaration (unavoidably, this is ultimately in
> > > uapi/asm-generic/mman-common.h alongside MADV_NOHUGEPAGE), which collides
> > > with the enumeration value.
> > >
> > > To resolve this, we rename PROT_NONE to PROT_TYPE_DUMMY.
> > >
> > > The ordering of these patches is critical, the s390 patch must be applied
> > > prior to the MADV_NOHUGEPAGE patch, and therefore the two patches are sent
> > > as a series.
> > >
> > > v1:
> > > * Place patches in series.
> > > * Correct typo in comment as per James.
> > >
> > > previous patches:
> > > huge_mm.h patch - https://lore.kernel.org/all/20250508-madvise-nohugepage-noop-without-thp-v1-1-e7ceffb197f3@kuka.com/
> > > s390 patch - https://lore.kernel.org/all/20250514163530.119582-1-lorenzo.stoakes@oracle.com/
> > >
> > > Ignacio Moreno Gonzalez (1):
> > >    mm: madvise: make MADV_NOHUGEPAGE a no-op if !THP
> > >
> > > Lorenzo Stoakes (1):
> > >    KVM: s390: rename PROT_NONE to PROT_TYPE_DUMMY
> > >
> > >   arch/s390/kvm/gaccess.c | 8 ++++----
> > >   include/linux/huge_mm.h | 5 +++++
> > >   2 files changed, 9 insertions(+), 4 deletions(-)
> > >
> > > --
> > > 2.49.0
>
>

