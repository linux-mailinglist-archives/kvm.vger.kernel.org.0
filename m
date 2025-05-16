Return-Path: <kvm+bounces-46832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A1ABAABA041
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 17:47:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CB72E1BA7768
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 15:47:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD7161CAA76;
	Fri, 16 May 2025 15:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GvKpeUex";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="0KtmzQAK"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5C71C6FE7;
	Fri, 16 May 2025 15:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747410434; cv=fail; b=S1Q8SCLE1zwcse7GmGYrJcgm+6MSJ00pcgUBI1hG8lMnYkJLAV+PvsTD8mMLt5C9KaTg24tLVWzLJN6KUgtHDDJfLqFfFiDEgvE5EN8d6GrV4mbPrLTXGddMYiQi+1xDed6fgYKiS7UVtut0i6GpRVKHa+5v6AFiK0gaaaGhRMo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747410434; c=relaxed/simple;
	bh=qSwXNvktqjaavriKCjRs73oWgSEsl+TIj45p7IbMsjQ=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LteFHYUjpLyWotABGRDhFSi2yrfT4VkJJ5yP+EEWHKE96sPAgJkBSHNwUSZWDWKXAaT7k3tfIyKsyhDxsaqQwELpD7k8ki5jTP/bPIo25LUdX4W1vVZPle65gezNdee/ulNZEnYjwY/Dg/qDdp61RNO7k4pmTy5dfoAb6EuIKOY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GvKpeUex; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=0KtmzQAK; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54GF0jsD029486;
	Fri, 16 May 2025 15:41:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=szi9gy9SAU9wo/jXHd
	DhRziDa2ItrxQd1zYiW6pYlVY=; b=GvKpeUexpEiujajBdl/WPO7VumJzmykwg2
	014VnenPxKywwaVTMcLMwc79DhD3M0H0ZdQiKnEqRLAZY59+rzdwD8KHami4FDZ6
	UGSgPl1c3ibWD0Dqvf88ZGOdjj6A4y2dDPp5CKK98AmS2uxxvQE/4eiAxhYbLhgw
	IHtye3UD/xZ4srsO5LJkoMdhditjrDeBZAv7CXGSdPC4YaXYGIW7DIYAK28S32d1
	R3oku6chNT8i64ZXZlUPh7g8VV5YlmCGZ2QqwEZt7wjc9/UcX6w/HHPsaKbiOnFF
	vP7Mg6jgKFX3Rm+RhK6CaOGktDa/Xe79DuhWyocGiLOIGPcskS+g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46nrbksn29-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 May 2025 15:41:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54GEpvGU004363;
	Fri, 16 May 2025 15:41:53 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2041.outbound.protection.outlook.com [104.47.58.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46mshmy9jg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 May 2025 15:41:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ps7GDmvf92hlVAK3CaLSM8VIq57q3XlrQU/7xShw6Nf+gklg6eX4zf9iUjqvD+bdtjSaAjRgpY4qtSDPZbvLgX3q9hXUJ6RmjqfZeHjENw28R3UDn+IkxufVUu3Tkz/7fCZTrJIOR81lXqOxzdJmdeNkqQnxI/8uM11zVHG5zWnU34vK651pZU7dYldcNbVZd5Hwx2lvS8G+/AGJ2t/oB+9Zvd67HmEsD1dtKGfeP4s29EnhG+VaAXDMim+RJ1cAOgGkImQl3DYkV99wCKFIBHe7zF/DTyiI9ebnPqmgWY+EUi5EV69CzUzuFoBzgCKgqkF0M4BTm16WeQEXqTS1ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=szi9gy9SAU9wo/jXHdDhRziDa2ItrxQd1zYiW6pYlVY=;
 b=gVeILo9WWIyJQxSPJ7sw6ctZ1oX4BE/JXY0LV3O9DKCeXwKQfA6Ljrx6gNzWiE8/HMYwe9WStm7dGU/ygF5vEb/LKBOvxDQ6z2zHq1yvKS7oqCP9bhT+jq5TAJZkA4ECKB+TIh15oXVnrBdzeNf1WNCKwE1kQOrm5jFkYGBwsfP1GhNxdspQSai9edhhgJoTs8oqnO3wzB7/P9ZqXNotWUS7fCAw1l/+/IWT8/vLg0bpUdmQWRhuNLyKnsGXiuhUH/CGX7dzycOQvl8ZAu8xeVFWVwMYYLUf8zeOtjgqxh/1oc+IAv1nv8t4bMtQzANnBdrZsvpHhtpHQft2zakmBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=szi9gy9SAU9wo/jXHdDhRziDa2ItrxQd1zYiW6pYlVY=;
 b=0KtmzQAK8WmnbHLE2UAu5lb3URHA+rMEe9mnnZwVd6Qb4EM5XZQ3vufBUs+ZQC0saBUsiYGfSoh/t0vhwRwlQMD5/rU8Uo9hvh9Hks/3VkkdaTRxmrMbGQXEWrQMyIDlddKfq8TcfACOU+U8ReNq5JXjp4+nxgDRDMj4Sc/BtsM=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA3PR10MB6971.namprd10.prod.outlook.com (2603:10b6:806:311::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Fri, 16 May
 2025 15:41:50 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%6]) with mapi id 15.20.8699.022; Fri, 16 May 2025
 15:41:50 +0000
Date: Fri, 16 May 2025 16:41:45 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Houghton <jthoughton@google.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>,
        Yang Shi <yang@os.amperecomputing.com>,
        David Hildenbrand <david@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: s390: rename PROT_NONE to PROT_TYPE_DUMMY
Message-ID: <b35c191c-d057-4059-a03f-743cb0df28e3@lucifer.local>
References: <cover.1747338438.git.lorenzo.stoakes@oracle.com>
 <3cbd58e6fb573f9591b43abeec66e6e2f3682f7e.1747338438.git.lorenzo.stoakes@oracle.com>
 <fka5tjy7m75csanhm5sbagzp64yj7rc2hlklvd2qolesjjalx2@bkx4ul3a6byf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fka5tjy7m75csanhm5sbagzp64yj7rc2hlklvd2qolesjjalx2@bkx4ul3a6byf>
X-ClientProxiedBy: LO0P265CA0006.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:355::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA3PR10MB6971:EE_
X-MS-Office365-Filtering-Correlation-Id: 1167eb77-1d1e-430d-cc16-08dd94902cea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xlOryrLdo4X5xJjMp8MerHeLlI+auVkL2CIAvb+epDjhz33SaxBJxhl8BjdL?=
 =?us-ascii?Q?leg3360VODzi+Ojs5l4luW3cEPf4kGnJyk/kfubcuSPajcZ8gjQmrV7f693Y?=
 =?us-ascii?Q?/qtFO+suif9KYnIJyeL9XhrLI1E48lNhAYE9BFQq12USgNpsCGh6nW2mYdba?=
 =?us-ascii?Q?HY02SdHgGxJ9p97ydpHfOnQSTa7jkgrG9qDmVCwK0cf0XSOAtAckGsO8Mez2?=
 =?us-ascii?Q?xAeRCQSobAI+N1nP6z1vALhd3NsUm2CnBYBaU6Z94nt3/Rt4/y1QKYBiB2kK?=
 =?us-ascii?Q?qXYY5ctOCUpRESBXm7nxgNGjzufzwvZ0WboXPzKFoEen/UYJn8tbBNc0oN5F?=
 =?us-ascii?Q?i3qH7/FhF6YQvX5Vpy3DPdiYh6sN0QuD3ikZOp7fXDjZqM/xwRfSmMSw+8iw?=
 =?us-ascii?Q?2tMaUehgN4JuiGLfewAHv4nmycHIM5R+wgJagQXJ7mhX5oVCikt1r//PH1+r?=
 =?us-ascii?Q?kGxKquXKV9FdAv3s1Haon6jDgCUcHnyKsVQP+ho9hSKHb+6lMJgsJ4eDrpq1?=
 =?us-ascii?Q?/gme7UEde518T6NPSUldUCv8NORkKq+QhWhr0v4kBGQn2wlTF7KNtmtocYJz?=
 =?us-ascii?Q?llSHBczj5P8ua2++5SEdnZy9HppVD1bEp3r/yMTbTO8OuvN1LgeCFfbOMb19?=
 =?us-ascii?Q?hJh52CxPboUIGprRqBZ9TJpGVtqLWykyEFFykVYz3L9jBMFjtsaO4YMfuVZZ?=
 =?us-ascii?Q?PEAf0VFsusduNfYRgPZGCVfUb4UNKA69IzY/MuyIpeveyjjOutNSDFM1R8Xj?=
 =?us-ascii?Q?Ky7iqL+ZcGQ/AezHAajwjTJ0DoEa+kXbuVTFMq4hWn6JlNweEMUtOi8anWkk?=
 =?us-ascii?Q?pU4geX5i6LQvZEAJwTaYv9NqBuIC0NHyqNkhVKX44+2fgiYX46QQcmqaJmTn?=
 =?us-ascii?Q?i1rk7Bvnt4gmnykcUtog3ikiSG7bWKIQFQxwOOiQQWB/drvP1Jk5fTo9DbP6?=
 =?us-ascii?Q?MbWvnsBcwY6L2GQfXrU669/kuIYoi65Np6Wd1cHw7URYSTfMVOUL1ywFdSvS?=
 =?us-ascii?Q?ZhoUTdzfLVvR44jLSqQI1FEv6J0Any8GqRGl38BlDPOD89b/6w2J8ZmrMw+O?=
 =?us-ascii?Q?hvlNGAbbX4x5iFUKlsdQnHDu9jhuehRAEm+Pi/P+THRbqL6NBg5KPqHOAv58?=
 =?us-ascii?Q?1Ez9VzsIstOUD6Goh3GKnfT7v/3nAdqiIYzxzuHcAcEP4KnPJcTD910Sps5e?=
 =?us-ascii?Q?LkHtZHkXe439mMQt4C85kwPALBSSoW3XFfqK/qtIhT0jr3oJngh8EC9ZwmY2?=
 =?us-ascii?Q?W6K2LGHU3ERImDms06m6RKf2iL4MqiUHrVAKmAnzufkFMGnsZjdCf0RCHtjy?=
 =?us-ascii?Q?WFw9jKk16NOtnQ3LwWBuhULEZaibzimhLn8Ywoh3z19oH/Kztw5nXhHNprlU?=
 =?us-ascii?Q?ZLPbNpXwdVi5vAndeSAOtsGJHpjmNXdIgVhAVcsb/f6Evo7HOXgf37UsYL1A?=
 =?us-ascii?Q?nWnJSaH/W+QsiUd30qHO42PPbxl3SjZ+TbEEWQwai8XeCw6KgUpStw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yej7B7K+2VJSzC0t67hHdYxxP/zFiRiDKWnBbQzZg4dpfdIa6Olb0cVcE4Ff?=
 =?us-ascii?Q?3O9ZdwyHkh8jlFREwpHqXtbfv4l4qVhtu0QW3JHVSnQeU0SxeC++iRJen7zg?=
 =?us-ascii?Q?j3nU7dxZZESbOUxg72Osj7bcYaVeGgZnC7wT0qTOmaAQYwGLGjqD3LJ9rxB9?=
 =?us-ascii?Q?lgXZWOFApoWKEh1jE+OfxV+1GLjD6qdHRTCHppfXjqZ0EcgsjRv2f4eYeeNN?=
 =?us-ascii?Q?46pPG6GUMmEG4/psbR+8FVKeXCtToyCTHLyboSkfb7b2or6bueWMH2l/nbpu?=
 =?us-ascii?Q?tw18XYfcNRjvDhqQWezdZkx83kXYSNuT1EhrVDliIZmZwaM4NqpZHI++WiDU?=
 =?us-ascii?Q?NbG+z2dZblgLH+r3l51w8NO5NTweUwHI6wAPgECB9zHEdFawlaPtlR+Awcwk?=
 =?us-ascii?Q?XsmumdfxozGbCCuyKtbGc21f4jO+qaoSLJIrUImU9IfpJtiig64XIViy9beh?=
 =?us-ascii?Q?3GE0NzTpjZWhctFsYah2cyNgaVmDhS28eURBZSo7/Q2BOR/OKuM1uA8AZ2S5?=
 =?us-ascii?Q?fx3EizeSwCXH6WNfIqCpzRuAK9hNKFKWCtwWJ2DQIjCkYvFWiw+vWePTAouW?=
 =?us-ascii?Q?HygLULCJLHykThqK8Qpu/V7nkD59y4AvgItmVNdUk+rUpjsS5JVTmpkJR8et?=
 =?us-ascii?Q?m6J/L6B8YiNgxsgFjVMc6FeSWxTJBwYo94EC6IotStG2pOHq1VOU/dIIFTXP?=
 =?us-ascii?Q?BVDXROktt0LG/ISjRDn9iqgaYIJ2swDMbSepPusg3WLGlVf3iDiY6cymBekt?=
 =?us-ascii?Q?QZb056J5lLqdmWGyK7scq1WrhOfdrTZCKbvlpK4Xpov0anbFDpbc3Hr+arYe?=
 =?us-ascii?Q?7aKEUtS5TeBEc7DM3Fcu2xZ8pGJjqoP6T6dSqeTEa1WFpJJXko3Ua3va0YDW?=
 =?us-ascii?Q?v3+oukD1mJts8yHFmfOdDeTqpttynlEfTeNI0C48wRyDX3F0577bxUtPRo4d?=
 =?us-ascii?Q?ujDlPsEisFA2EDy8i8pnMH5vPyd4MRH9sEscziRgGUdKTJ5QpsAUanmlnAol?=
 =?us-ascii?Q?6Gf0IjHHaYcps9KurirJLZFeENRsjM+vLJn1GC8DdrOLanjH/zrfLMtFJLC2?=
 =?us-ascii?Q?u3nj7ZEbxJ0haxUOfnROx4J7d8vn1Zthn5Xu100+TSLFM57WCh+b7iUrnEnW?=
 =?us-ascii?Q?kVN0T0jBHmzvnNgwDD9SQhSheoD13Cqp8QYaSkGdobeFsJ+pwttwekLSDVK1?=
 =?us-ascii?Q?pcP9MQRc3Z2jg2eA5Z5pRg939RxnLiXZCI6oWq5zavrPETsH5XhM3HEa5Qdo?=
 =?us-ascii?Q?Jx/TAGFLM6i7A1AWPiG6wsDb1WST4ABGxjQAoXbjzpneq5xe4Brk0KGlEapz?=
 =?us-ascii?Q?UvfPLYdh+cJSUb6cVCbVp+XSXrZsyFlffKN+x6OL0kUjin1a0zrFns5a/MkX?=
 =?us-ascii?Q?nKFj8JKq7Hj1dkmumVKEJuGR4ZRqmxkZV3LxD3qhFvgjMZNbchAaZa0jwa0A?=
 =?us-ascii?Q?UwbdbLJkRJ9UVRtiuIhwV94d7Qv2lVCXYBhNgPGpNR8Sq70W06iT7QewiSkN?=
 =?us-ascii?Q?WlJnQsDPStzJv6bn+xW+7MW5MSQpdOFmcIsNwatY0RMjArpwEnjHfBGxYpoA?=
 =?us-ascii?Q?tvqOXrYTMWTy3UE56lUZ1heoiO1QayEDVBfi4ECB9eCLdd308qWmAUrvPlt6?=
 =?us-ascii?Q?kg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HqnCXF1UOjRT0eXmohJdiwTDkXhtX7m0Gnbl6wBjlDzxnMuJcISKJgHUX0g/g6cbtSgWyY4Oyrj5LQ/gl/Li1lDOT12k35opR58EXtvw+UfcoNCaEH0bUkbqSf8lsZc8Axt0gkwFqHwmPeqq+5dkqcqHw8BgkLoEojdbuuKBB/RVjWx7rF7XTwO94cUSRtELPbHf+/STqQCGl1hmOFO7LGfjOKgENzdrlIhfypG9rKaJUpubk1yDxoyOuYHMOmxXc02q9MdvDWTqAdicHObCl60w9g/X2nbs1HBBObGmKZOOkLeX0h68roSL77ZDULpeaKdenb/Iaosc/pk0izytU+9wdSq1QuHUXWJTMJ4zffpLhAIEkj0eFpUpHd3KVnUr3b96Mm6wAUs0rgyekdK7ohR+MoAvSC0AM6vxE04+YfnRcVJ21kQqucY4vDZq3wFsU6+iQ/ssJ5+NrQ6WvA2c+ES3uGr5rDTy/NLNRNr347P/w4LfJfvAnj5P6gNnux8TO76n/XTysG1sIUPVflmoWY2OAW3R7vJGFJ2GmkIUzF1DcROTW6G9IR5GYc3AWcYTqyZwgHRa3qJhIHZQBMnLwPpDPiJxyc/Ykaz2FYudu9o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1167eb77-1d1e-430d-cc16-08dd94902cea
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2025 15:41:50.7228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NcuI9QmrNeSFS0iXLP4p4uoeaPZu+5/1N43QWK00PaFwaE2dx2MqsBS7ggcyoCqnByUy4ja1XettIiY/jh4P7BWBCSwK8/48kKz7/AhrQeo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB6971
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-16_05,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505070000
 definitions=main-2505160153
X-Proofpoint-ORIG-GUID: RmuSaM-0OUJgCwtWBgJVtikeuwdg-IlQ
X-Authority-Analysis: v=2.4 cv=OK8n3TaB c=1 sm=1 tr=0 ts=68275cc2 b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=yPCof4ZbAAAA:8 a=TAZUD9gdAAAA:8 a=VnNF1IyMAAAA:8 a=vzhER2c_AAAA:8 a=20KFwNOVAAAA:8 a=tigQPNLc1hilJ32vbdMA:9 a=CjuIK1q_8ugA:10
 a=f1lSKsbWiCfrRWj5-Iac:22 a=0YTRHmU2iG2pZC6F1fw2:22
X-Proofpoint-GUID: RmuSaM-0OUJgCwtWBgJVtikeuwdg-IlQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE2MDE1MyBTYWx0ZWRfXxNsQmvLhVTIA MVBgq9Xa/qY0X4JxIGCq91isrg3Cm6qCmZo5ECiBRdkXrX+kg7E4RdwjK8D8665z6CpNXBtjngI Cp+AGls0NA+HJ3Uc9G6r3PIWTd0QD+OK5ZQ3RZP0S1mPzC2goALEnaO5MJOURQhhaFYHB0b/N1+
 SDeyBnQchzSwLYgF/XrQcWUWtseIPve7qUVBMVVtInPXRCXkKh20JvoPTFtep5BF6bgRQJ3xYy0 wkiqGs+aCLSptSjONtaORzfKyRB0A2dMg7FbiGIciWV7BPcldis3dYKKWyHQBQJU0xnqssNTIb/ lCk87oEuTULKuUGDmviN9rFLoE6ASRDhhx29Jc8jxpn1jOqBOIk68wwDrx3PIGSFJMPsbSxhjdr
 mWDXNFSzPqlugWUeSR8QEciBZ3bwRC2M1htQl1tRaJ25DnxFyTUj9lMYINrTB2mv/a7bNAf/

On Fri, May 16, 2025 at 11:39:19AM -0400, Liam R. Howlett wrote:
> * Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [250515 16:15]:
> > The enum type prot_type declared in arch/s390/kvm/gaccess.c declares an
> > unfortunate identifier within it - PROT_NONE.
> >
> > This clashes with the protection bit define from the uapi for mmap()
> > declared in include/uapi/asm-generic/mman-common.h, which is indeed what
> > those casually reading this code would assume this to refer to.
> >
> > This means that any changes which subsequently alter headers in any way
> > which results in the uapi header being imported here will cause build
> > errors.
> >
> > Resolve the issue by renaming PROT_NONE to PROT_TYPE_DUMMY.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Suggested-by: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
> > Fixes: b3cefd6bf16e ("KVM: s390: Pass initialized arg even if unused")
> > Cc: stable@vger.kernel.org
> > Reported-by: kernel test robot <lkp@intel.com>
> > Closes: https://lore.kernel.org/oe-kbuild-all/202505140943.IgHDa9s7-lkp@intel.com/
> > Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> > Acked-by: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
> > Acked-by: Yang Shi <yang@os.amperecomputing.com>
> > Reviewed-by: David Hildenbrand <david@redhat.com>
>
> Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>

Thanks!

>
> > ---
> >  arch/s390/kvm/gaccess.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> > index f6fded15633a..4e5654ad1604 100644
> > --- a/arch/s390/kvm/gaccess.c
> > +++ b/arch/s390/kvm/gaccess.c
> > @@ -318,7 +318,7 @@ enum prot_type {
> >  	PROT_TYPE_DAT  = 3,
> >  	PROT_TYPE_IEP  = 4,
> >  	/* Dummy value for passing an initialized value when code != PGM_PROTECTION */
> > -	PROT_NONE,
> > +	PROT_TYPE_DUMMY,
> >  };
> >
> >  static int trans_exc_ending(struct kvm_vcpu *vcpu, int code, unsigned long gva, u8 ar,
> > @@ -334,7 +334,7 @@ static int trans_exc_ending(struct kvm_vcpu *vcpu, int code, unsigned long gva,
> >  	switch (code) {
> >  	case PGM_PROTECTION:
> >  		switch (prot) {
> > -		case PROT_NONE:
> > +		case PROT_TYPE_DUMMY:
> >  			/* We should never get here, acts like termination */
> >  			WARN_ON_ONCE(1);
> >  			break;
> > @@ -804,7 +804,7 @@ static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
> >  			gpa = kvm_s390_real_to_abs(vcpu, ga);
> >  			if (!kvm_is_gpa_in_memslot(vcpu->kvm, gpa)) {
> >  				rc = PGM_ADDRESSING;
> > -				prot = PROT_NONE;
> > +				prot = PROT_TYPE_DUMMY;
> >  			}
> >  		}
> >  		if (rc)
> > @@ -962,7 +962,7 @@ int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
> >  		if (rc == PGM_PROTECTION)
> >  			prot = PROT_TYPE_KEYC;
> >  		else
> > -			prot = PROT_NONE;
> > +			prot = PROT_TYPE_DUMMY;
> >  		rc = trans_exc_ending(vcpu, rc, ga, ar, mode, prot, terminate);
> >  	}
> >  out_unlock:
> > --
> > 2.49.0
> >

