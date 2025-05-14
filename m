Return-Path: <kvm+bounces-46500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 735FDAB6D3E
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 15:49:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 427C14C5D4D
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 13:49:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6337F275106;
	Wed, 14 May 2025 13:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="X+fyPGvB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BBNFze+T"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BCEC190678;
	Wed, 14 May 2025 13:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747230562; cv=fail; b=uZYL4liP23W0a3EnE5heoDf3P7gU/cuUAtu7tBvwIEKok5wf5ZtIi0vXq9MBEixgtzBblHGLADSRmTzJvsoX62UMMBiVUR3q2HnCpRAhUgb/J6r2pJfBxKVuBzhQ2op0d1ehSDiwbxBky5bnYxbZCG5BJOOW1mxaq4fCzGJAWRM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747230562; c=relaxed/simple;
	bh=TJULxq/rVFcYPbbx8RDya6tBpG51bCsquwSS0nJr/Gk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=agoXzC1XekKFuIYybPZu6Ob6Y+Bx6/b5E+a2RwJpi62oENFwtxHKYZayp0GTSfcIu3fgArXD6pa5uK+S71QofAXnROVkEt9+OlMjQYaCCCMUt1K6eMjmgbELeQ6i1LnCIZEKVXR6WiuklQ+P0FkKlYqhvf3lbOi3KbEWPIAOSPA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=X+fyPGvB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BBNFze+T; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54EDhri7020579;
	Wed, 14 May 2025 13:49:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=eNZ7u9euODdQ6P4Qtx
	kyvhXmHs6G2Ssk3HGIrJI5Nyc=; b=X+fyPGvBVLLSGjJz5WjJZG1MrUglMFLbYa
	0cFvlH9YbwAYDjf/AcNmaGN23mjtY/JeZz4Ful1QVFuefE21zj2WYD+gExsbvdwm
	sYwSJzEw6B0WZYi+qaMMqmTk6tsFKrVKp/PT60IL99LmL4ifOxjedZcoZItcfZOa
	REen4lXmiggkq+LHjyHc12o1OMYwuu/TuIHafCJFv7eFCps983soBjcylYVKgggr
	DlhetpkpnmbmdSyr8WmoSxp52CYxdtoyxrF2pwWS9EF4qLjfX9PrCW3kCHQvs1DH
	eLPBKN1dMvTw0XTg5plHk0/bN5zfejky103dqQ6b6DTnikArRRyQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46mbccsrsr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 13:49:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54ECZUe5004506;
	Wed, 14 May 2025 13:49:00 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazlp17010007.outbound.protection.outlook.com [40.93.1.7])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46mqmc2xak-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 13:49:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xLOCGXGZAMCp1PIWdXAhpG+XNrGrvJ08fUmtYRHjmEXo/s78ZsjO5tMKw1G8KdYfyMFrE0JD3UP9w7ajbKba2Hh1/Hwrf4jXWcwBqM0DoRh8x0dzhYIaOJ1neShb2t8XKXlv8Ag4OJQ4bAbDeEVLUqYhWlsSwnKUMSHh+KqSCjK0aq0jqHtSDoyvTeHJxXB2Udcs7hutgq6KSaletAYTB65c6IWSUXkCPjjIX2NfRr5Y8//uz/hx0mffeI7Sb4HUEuyGOkrbsvIDZijOHQTvmK401TaKSPyjomcj1OeZHM4x+se7wcX/PQSkdI//FROtl1X7q/9tV+UTQirNrRKdOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eNZ7u9euODdQ6P4QtxkyvhXmHs6G2Ssk3HGIrJI5Nyc=;
 b=CiWDYX0TTdmvGKJiLzw/8Bj1gueOCVhNFh1M5bUBZjN699pqx7VeiRz7J92EtzlBQg4gD8H/RsFj+c8jP9p2zHMmJwtke2QgCHfhLbrQpegHyd4HnZOSwp222mPF/YPQDAlZEa6aMR29XSxwasK1UZyiny6CQx/llfaaK+5JS2b8p1sVu4hvC3K880ZMW+ABug4DoQSuj4V+NfrxmSOPqZiZDnviDlByDp8BRmVQLbLC1Pf3aXarE6fFHG1BpRCv80/A23E2uzyZfvAI8K8cQANCZML26b+ruNE5ENMvOiKiRGpcQ0CkHdh78HFnhS3O5kCvBJpy3F3ogGWYeZ+8Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eNZ7u9euODdQ6P4QtxkyvhXmHs6G2Ssk3HGIrJI5Nyc=;
 b=BBNFze+TwRyvifDA4ERPhXEZuAseOi3GG7NIDUzoNIaBlt/O6mRyUwAy9ev3xEbnL7sklIEWc1nneJbxmXj+D0vDRX+3rEcZ27jHG8L/l9UXjeSECTDcp449uzVbFirX2QTSkTyDiInKvColyt1QV6Muu9tMj+H5w9SFqnwgPkQ=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA3PR10MB8637.namprd10.prod.outlook.com (2603:10b6:208:577::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.32; Wed, 14 May
 2025 13:48:47 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%6]) with mapi id 15.20.8699.022; Wed, 14 May 2025
 13:48:47 +0000
Date: Wed, 14 May 2025 14:48:44 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Yang Shi <yang@os.amperecomputing.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [akpm-mm:mm-new 320/331] arch/s390/kvm/gaccess.c:321:2: error:
 expected identifier
Message-ID: <8e506dd6-245f-4987-91de-496c4e351ace@lucifer.local>
References: <202505140943.IgHDa9s7-lkp@intel.com>
 <63ddfc13-6608-4738-a4a2-219066e7a36d@kuka.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63ddfc13-6608-4738-a4a2-219066e7a36d@kuka.com>
X-ClientProxiedBy: LO4P123CA0174.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA3PR10MB8637:EE_
X-MS-Office365-Filtering-Correlation-Id: 37e673ac-9aef-4682-ba5f-08dd92ee0d11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1Q7CP5fJ/IoxMMbfQ3ib53Kcixn10IEyzs8pMm6pusTVprRKWeXn5FQu+3oG?=
 =?us-ascii?Q?EUi88JGvOqAE7e56VPMNDt4xWktzcv6Bgqe+Pu74jp2bQaR2MwTvNTDZr2Bp?=
 =?us-ascii?Q?3oGBGd6akfXQ8d0VwRvZpiu5FahzeAaHzwSxU6pOFiQRYFg3sGMzFFejPU5B?=
 =?us-ascii?Q?UzNKtIRtQ2KzstGLYN+4o2ysX1S1pU4ve9WZrEuE7H4xpVkvFCKo/1HRT38h?=
 =?us-ascii?Q?ycxuqZfpxiSE6sE21qTlpl7B3mpOfZG4oVfsLjGw5vSriL4m7LzTRz1LyvT4?=
 =?us-ascii?Q?5CuEcm2ZcAbYJ6m3ihkKtTeaMmP91GEb77BdD953xz1oBKm4UtTTBV7k/ART?=
 =?us-ascii?Q?oRLdheXSPfNELOZPFD7HT/kLKgzP/kgQ6NfVriT6kJMNacpdrUG2UuJv7qBq?=
 =?us-ascii?Q?il+f+1b4fq0LLJgQ4guj0IZ6TaAzqsZouSgzDj5aQxZB2SOmH4oPso5RD+2m?=
 =?us-ascii?Q?0ur/YeGNeOgOMzaE9EOqiDOlAIcNC/M8+udKibZ7byXdpkvY+TdhlFqDn1Uz?=
 =?us-ascii?Q?DiPnguZfcrvRWvqJpAO/95KbEt9rMP0jnXAhCXn9VLcAggA83vTjGfrnImN1?=
 =?us-ascii?Q?T1SREcfjUNja11VrPam2AYvXCPoQbNiq+KueqtDPBkITJMabZtPXz6KRPbhQ?=
 =?us-ascii?Q?qe1vDyc1jFVl6K6qKAEkwzr5ftISQSwYIk/KZ+YYRWhQfPn0X/p5+GL6rNSx?=
 =?us-ascii?Q?WmjL5EQIZcWC0+046/61fQMM1ZuCWsa1nRXH+/zFlOx9qJjzoltn/mDIcuvT?=
 =?us-ascii?Q?jfs1/70nsbfnQJ8Qm8iZuQfCt4drhGGxhNCr+XhTuT/2TV7d6Sj9JtFU91jy?=
 =?us-ascii?Q?Q8kYgE7CabgaTC2JShXNYfuyPyqX88RssrmViHm9kanq2yjGHHlQeWwUCZk7?=
 =?us-ascii?Q?qhtYO7x8cgN9F0dBcOW7OpP8s4tp2b65SNvSJKoyHX/uA2tjNxzAKsXwxA4a?=
 =?us-ascii?Q?ZtFEpnqBNANFoBJSZhLbkASkDxA4qvwRboB+zJsxQ8+9B4JAkb07REpVxfRu?=
 =?us-ascii?Q?oGbcd1haCNRNKpaQXR9mXS7euHIOsJlenl0XJpCbKJVC7VjfRCT7aN++eBlW?=
 =?us-ascii?Q?GGMEbg/fZRlwWHyQGy3Y5+l0HCLXV6sYwwqQ4Xh6P78uxcprnwdttxKiCHsU?=
 =?us-ascii?Q?IHL+sQq2yQBtQy9TkHkcH6jv5zjL4mjoinKtMCZGxqR6zKxh5IWQb3ctRXP0?=
 =?us-ascii?Q?I8WcH9g8LtSJvYfrLRTsg7Me4GKqAGe/YAWmFLi1fbLA9sok4wNFZ4M5rOsQ?=
 =?us-ascii?Q?DlRlNBkQ1q6FwhHZRE6IvZofK5zAzmVOKuqbJM+af5fywEqN/jgUr1fnHreN?=
 =?us-ascii?Q?5W78SJTlJfmCa1VYq6bteJUIsSZYLkEokgH0DbS1r+xt1U4IMpf7xQ5r8XuX?=
 =?us-ascii?Q?FQvxYGX/ZCClc5jlIRA0N9EEuB4O?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qSLfVtlQPQzYeJJQz/cNqcM8Ygzb4zQCxGoPZCMFAzRPGWLN96/d2IYnmDtM?=
 =?us-ascii?Q?t+Yp06zbnqz6tn/E2zaJ7/r3IFAmoJdQmBan11TisPgAgmgC0EXJFUMdvEg4?=
 =?us-ascii?Q?VfGQFqaklzYMF5TimwELJFlw8BWgRdpAbGywy8zlb0debWNJKviXID5Mb0qO?=
 =?us-ascii?Q?fScKkzhfV3WK3RinzS/JASSJjp+1eNo5Vb+m5yHsbRQQb7Cy9RWiwaLnPskZ?=
 =?us-ascii?Q?gNtUi6T6017ef3froqKV3UutoE5JofwkKySynOcNept4QnWFEiJMr1BYCNIR?=
 =?us-ascii?Q?42Zj2falP7dXV45sasiXzeLRE+hcvyfQ+Ivmmfdg4uthkZtN31sdSKFoAhc0?=
 =?us-ascii?Q?E8REmjbdshgZAx38pMZ14p5kD5xjkgsa8vaJ7R7JPyA/tadcDiygqZnN5FPE?=
 =?us-ascii?Q?wkRQvPZ2G6B6cBu9/gvJ3pP4S4nbLFQ3GGRpb6Ya7XWY3lRB7MitTLEEDDxQ?=
 =?us-ascii?Q?ynR8lkpmWjshQKRkNIEwoAnBlarpw2rsgnbrn1fZbNlgioYtTOAfE9ae/Q4o?=
 =?us-ascii?Q?yOR4L+8RMp9pVM5ayybEDGNLhuH+CMz0BNR8A3saWB1teY6L+jPL2UQIUemY?=
 =?us-ascii?Q?pM8g76M538aRDlr6IeEp8s+VkgkQoRq7XGaBI7brFbvm0g+w5QeT5azYHh64?=
 =?us-ascii?Q?Y5WmgpmPm4yNYB4NS4rLQEpC6oA4GnZdlfuRD+2QiRdIPeRlR56SO6GfbA0H?=
 =?us-ascii?Q?l9XJbBaoavUoc9qNJ/bM3HKuSFme2/WTFvC0mXLjT8HCMJSREy3zP4xn4wnD?=
 =?us-ascii?Q?xDL7LF00u+diyLiAfmcd13nrN+doOxbMK3YnYlNI1wyEI+qbmEi7QXjmCKdK?=
 =?us-ascii?Q?OapBWEQK4Er6Wyx9Q9SlMSovG+ZfwtgD/IeQeKKU85N9p5l/W0r0FiuWmifb?=
 =?us-ascii?Q?mOOocvqJEriWkdVUJLAQlTUWHtLQNaz/M/w0nc0JeCpEA8eonl1CVgy2fMLm?=
 =?us-ascii?Q?8d0JsZ5tRRGdr8knFtMtT8sB/0lQ8s+XMka68KSSQVvhlvmnPp00N0kLOXKv?=
 =?us-ascii?Q?dEgsYQzso2rVjvy267xLAYH6DbfzFm2O3JsaAsJfnnEtx2BbrdSTHXiMQGlh?=
 =?us-ascii?Q?B/ZN4cqwYwD2FbpqVI3tUg4fHVE1b1QRTK1Lk5TawQUYPnnEEihWVLqnscLd?=
 =?us-ascii?Q?N3WNcBj4vIR3Air5fO1R96WB+lZ9OqO/7ZAjRAX11luB3AXa5TeDa/ToZbCc?=
 =?us-ascii?Q?TtNkqCQso92/638VUGUZCfDP/1VkVIEhOLa3x32q6woitRm0pV9dwfRGWurd?=
 =?us-ascii?Q?S+/5Ht2rWsZUb/GXoWGMQ9YTCSWodOZkuk/wNvCkvPQgeaNT7lVgz5olMlgD?=
 =?us-ascii?Q?mFVhaoIUc9NUXRXRDpzymUaCpV1p9OcURd2LUN7z7v8F6veXEQVtDJiemQCc?=
 =?us-ascii?Q?y7lq+x8tOJ6eEBmvzA82Qi9emxGXyJwvohxQ//0NhwjF0G04BSBNAQiavzOg?=
 =?us-ascii?Q?kqBl/y8W87rgSStQR+UK6z+YP/WIlCat5YLGVqq2R6n57hvGi+8cMdiSvU9c?=
 =?us-ascii?Q?GpWs8eyABUZrc5qTyzF+l01gd2rIY1gfTPckj8K8wXmV0279UbuMo99905Yz?=
 =?us-ascii?Q?HJ5l9UCSB+ZHH5tEE3xUGaJznapJsnidNO2aMW26HGLG65i9bMsIzaUL3FPe?=
 =?us-ascii?Q?GQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sVK8e2g/coqPWc3fALBStaPtHoaREj+WZgeD+np8EUNK/9SgpOvPEy0R3JeYLtptecGcAoUlix/YaLvcud/i5CDw960habI2T2X3c6+Ku/nKJeq/u3/JQAFUwZMb1RXNRwaU/VDdRrZZv27J7EiS30ISDQqrIFyaY/hLPAq1hs341y4wwhTSIfc5fXW3scmFIMo4Ye6izNvQ8ydsh68zxwMzUFUx4UUcHCyUzrl60yPzl8EuQ4WV64qZdjk7bisD6dUINmtP0M1q/X+ncxng4hz3A8fH48n6JPovl5QOB1wDMu65LUouLFe6bl+iCWy/vMznWCpz1vQWhodDmjix9++DWKB5BUAYPsqezEkYXp61GEoEwn+KfnL3fESV0qILtxEPwoeY3LJ8SRtvUHpID8p/au21qSuqiELUH5iIc3jTiQ6zDAGMttmk0hUeZvEwCNFhCd2vy4nVrM75Wbm4NVDbS6sqLIwW7pcvUVUBLcbyWUfPzmpO2jF72yUDZSnl3YAwGfXPjtd0s+nG9mwZ5Voi/I1WTjFM/D2y13xCJSJNsmAYbqHqF3X3fuWyIWsSrjTsXVQcbcz9pMf6nfn90baDLsqOBF9tBHUJMBTtWz8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37e673ac-9aef-4682-ba5f-08dd92ee0d11
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 13:48:47.6458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gr3xioS3YaIfWPGiENWPqHp+jNY7PrLbFu2f/VI82iFHYI5g2DGvfzY/rVTf2n5B1hSwKPvTDcZoNw0LKzFgYhiX6eEILPHY1v3DnLZUEBQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8637
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_04,2025-05-14_03,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505070000 definitions=main-2505140122
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDEyMiBTYWx0ZWRfX85Nb+dxn6VGL 87EyfiggLCVaFKKbbVDNRyHtazNPy7LSpztLfNQ9G6bQsAvwBcA5aZfFQPTe8C55iPpLsmm1xbn AfB8ZNgQkQwCT0LhDwXjrtxAVhZbFDiR4xy3YPEkt1mBB3N3VVQV/dRjiUmRRuOvizkDdEdkn6A
 GbwIHEYSQzSdjIknnU5gU469PScOqK6tKgPiXm/cHlNhYBTiVrH1CxoeDfp9DJxNqrHzcRVsnl0 +1pkj0KlmqTNGBmaygWOJUavJGG7A9lgCpp5AbPNwFoW5VPVrzFD/vgqhlNxN0ncLI12QDSeQVE p8gtPxdGhTFTb12ZpCytwz4RGpH3K98sQ6PsBNRMpDwnrxEfjMpjOvTN8c2cI8UetFnYQkGjdKe
 c6NZTici1H+8/4A81JZ/W3cljBr/VrfOFE64cJ+F5tsg3QjrFyXgZkWl1SuwLENhERVGpuTI
X-Authority-Analysis: v=2.4 cv=Y+b4sgeN c=1 sm=1 tr=0 ts=68249f4d cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=TAZUD9gdAAAA:8 a=i3X5FwGiAAAA:8 a=NEAV23lmAAAA:8 a=8E26jgbvpXVB1HDeCRUA:9 a=CjuIK1q_8ugA:10 a=f1lSKsbWiCfrRWj5-Iac:22 a=mmqRlSCDY2ywfjPLJ4af:22
X-Proofpoint-GUID: twKo13r1q-CpqLfMjKfTXDOWAXWgmuzJ
X-Proofpoint-ORIG-GUID: twKo13r1q-CpqLfMjKfTXDOWAXWgmuzJ

+cc s390 people, kvm s390 people + lists. sorry for noise but get_maintainers.pl
says there's a lot of you :)

On Wed, May 14, 2025 at 03:28:47PM +0200, Ignacio Moreno Gonzalez wrote:
> Hi,
>
> Due to the line:
>
> include/linux/huge_mm.h:509 '#include <uapi/asm/mman.h>'

BTW, I didn't notice at the time, but shouldn't this be linux/mman.h? You
shouldn't be importing this header this way generally (only other users are arch
code).

But at any rate, you will ultimately import the PROT_NONE declaration.

>
> there is a name collision in arch/s390/kvm/gaccess.c, where 'PROT_NONE' is also defined as value for 'enum prot_type'.

That is crazy. Been there since 2022 also...!

>
> A possible fix for this would be to rename PROT_NONE in the enum to PROT_TYPE_NONE.

Yeah this is the correct fix, IMO, but you will need to get that sorted with the
arch maintainers.

I think this suggests we should back out this change for now and try again next
cycle given we haven't much time left.

Have cc'd s390/kvm for s390 maintainers for their input however!

>
> The patch causing this problem was created by me based on a suggestion in the review process of another patch that I submitted first:
>
> https://lore.kernel.org/linux-mm/ee95ddf9-0d00-4523-ad2a-c2410fd0e1a3@lucifer.local/
>
> In case '#include <uapi/asm/mman.h>' causes unexpected trouble, we can also take the patch back... What do you think?

I guess we need to back this out for the time being, since we're so near the end of the cycle.

>
> Thanks and regards
> Ignacio
>
> On 5/14/2025 3:05 AM, kernel test robot wrote:
> >>> arch/s390/kvm/gaccess.c:344:8: error: duplicate case value: '0' and 'PROT_TYPE_LA' both equal '0'
>
>

For convenience, let me include the top of the original report. The full thing
is at https://lore.kernel.org/all/202505140943.IgHDa9s7-lkp@intel.com/

The original patch for this is at
https://lore.kernel.org/all/20250508-madvise-nohugepage-noop-without-thp-v1-1-e7ceffb197f3@kuka.com/

Original report:


tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   24e96425873f27730d30dcfc639a3995e312e6f2
commit: cd07d277e6acce78e103478ea19a452bcf31013e [320/331] mm: madvise: make MADV_NOHUGEPAGE a no-op if !THP
config: s390-randconfig-r062-20250514
+(https://download.01.org/0day-ci/archive/20250514/202505140943.IgHDa9s7-lkp@intel.com/config)
compiler: clang version 21.0.0git (https://github.com/llvm/llvm-project f819f46284f2a79790038e1f6649172789734ae8)
reproduce (this is a W=1 build):
+(https://download.01.org/0day-ci/archive/20250514/202505140943.IgHDa9s7-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202505140943.IgHDa9s7-lkp@intel.com/

All errors (new ones prefixed by >>):

>> arch/s390/kvm/gaccess.c:321:2: error: expected identifier
     321 |         PROT_NONE,
         |         ^
   include/uapi/asm-generic/mman-common.h:16:19: note: expanded from macro 'PROT_NONE'
      16 | #define PROT_NONE       0x0             /* page can not be accessed */
         |                         ^
>> arch/s390/kvm/gaccess.c:344:8: error: duplicate case value: '0' and 'PROT_TYPE_LA' both equal '0'
     344 |                 case PROT_TYPE_LA:
         |                      ^
   arch/s390/kvm/gaccess.c:337:8: note: previous case defined here
     337 |                 case PROT_NONE:
         |                      ^
   include/uapi/asm-generic/mman-common.h:16:19: note: expanded from macro 'PROT_NONE'
      16 | #define PROT_NONE       0x0             /* page can not be accessed */
         |                         ^

