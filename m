Return-Path: <kvm+bounces-49555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BD01FAD99FC
	for <lists+kvm@lfdr.de>; Sat, 14 Jun 2025 06:12:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 198743BD4D0
	for <lists+kvm@lfdr.de>; Sat, 14 Jun 2025 04:11:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4AED1C1AB4;
	Sat, 14 Jun 2025 04:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Od00Clv8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="H9RuoL/F"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281082AE6A;
	Sat, 14 Jun 2025 04:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749874331; cv=fail; b=AnPbZdZ/UDBxQ6AH/VxYDSfBuUMe0D0ZCcndxn734z0groO0qRDaSn7qZyuYUsCH3wiF6e89n5q7SZcrFakb5UampzzN3cpyKYPrCpHIZHfE2zvSmNp/sQHuWp8kc34bgISpbJ7Qot4h8r9X6yCzY3s7n6du5uUKYQh1ApSJ/eI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749874331; c=relaxed/simple;
	bh=mCbjlM0Hv02Ux429CkZt7N2vIMerSKxgODchApKtdJU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=b+911lBNQhB2e5tJ7mwDEazXuoEFjJ6A/mdOOzCBviH8reLM+tP3FZukN71NPR8ddWCbyoDERMt8/LMSrBoc/m/XG0qJswcxJsSZ3t+MxKiqCnrVqXksL24/zQHBFlqh4XaAZojEUC0w2lIS5VWDIlknABLivQTCySfWywams0U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Od00Clv8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=H9RuoL/F; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55E3ogOh019005;
	Sat, 14 Jun 2025 04:11:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ejTPu/Gj/u4kFhTVzG
	oEDXbEKrWQcQncyXfS5DyY4b4=; b=Od00Clv8RCT93bcEUw+GsFPZs4K4hIkgwo
	tthWwi6Tj+ubMpqYTdofK6seW9i0yqKTbDftGg8PRO7/J586G/4IDkpo3nGtu99/
	xSp6lUUtKD8oQMHFOguau/OKa4peDgSk3K4eBAZ6ouBNJj9NBicNxqfZd7w/uAEG
	oG7GNkcOSZVopSV0aH21SVwvCGykiTEPO1BWnmgeyoHZcDllcoN7C0JS4nxkW3A2
	rMF4xW8xyyHYOtwoNTWXx+7g3RtQEMwbwyGe3680hR6pC0yz8fuB9aIB55jiits4
	tz8YCI9MldQRCfTM4H2pWkRLblC4hvN/feNJz3Ve1MNVXUnyxjmQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47900er1s8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 14 Jun 2025 04:11:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55E1Xe2W031671;
	Sat, 14 Jun 2025 04:11:39 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013051.outbound.protection.outlook.com [40.93.201.51])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 478yh621g5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 14 Jun 2025 04:11:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tND454yjK/yY7Vil6eIcdGZa4snmEYpeWt+QCgIRzyAAuT02KXrzDgs6LmsEU9SAdarL34jlQlzGImFGrlyvLwSUNaKWePZHamH9c7vWjpPxvnq0o+YaCI+0cJQR359oVYzr2/hFIpJtw4FwJOyaqY49PYGyyR6AM5UrjidvJTcTGxLKD5STaVuNn/qTa2m0ybeYN9j/QWsAlbt/12a0Wwn5oLeOKVsVZpu2OFzrRzV9kfdmBpMBDgO/esT/zFjPV8zQkiyXqfgiLTzTmQWaYMQmNGO7CMuLvWo/DblPQk/L4Cs9bo0aImDv70h2615G6D/jcbUcvhy9IuFO5EzUBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ejTPu/Gj/u4kFhTVzGoEDXbEKrWQcQncyXfS5DyY4b4=;
 b=WV9lrwGNClty0nazOSyllr3sFtsYvot1u/K4MbOInEsUuW1r9o2CYtldcOjEBX4+e4U9GCpnUOEY1YrGL/Px9yf6ymqzD/gtj/aogN0bwHSLpzeKtoQRFG9g6vgeLe+qeLzVn30Bj7RbVnxx9X2AN5+19CUvTGpoETcrYLPmY5DeZLiYaC6xofNTGZVVkkiOtLwqcWnh3b3vCjfRI3xJDqew/M7VA5HoCom8/atystkCCwM4I1r2llyVCblgltmW91eF0lgxGNA+5T+3T8FNTarlmPOiPNJonuT09jn0N85FlHRafKsV7eT2Yagzggt0tuKh9CwGG509NCfSBjkrIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ejTPu/Gj/u4kFhTVzGoEDXbEKrWQcQncyXfS5DyY4b4=;
 b=H9RuoL/FZQNG6xcYtopLYkpoAUdXzyhA+S9uE3kL8Kkk2O6+h3gluXffXtgRKt3lJR9ed0hgHNsQyLczO8OkGOV9GggRNq2PeI9R0Nhvj8h0StXoJodubcW7/ihwVqn7StORFYXter/dywziwgKq5Pv1r5MiSZ/8xAdT52EwaC8=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by IA3PR10MB8137.namprd10.prod.outlook.com (2603:10b6:208:513::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Sat, 14 Jun
 2025 04:11:36 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%6]) with mapi id 15.20.8835.018; Sat, 14 Jun 2025
 04:11:36 +0000
Date: Sat, 14 Jun 2025 00:11:22 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Peter Xu <peterx@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Alex Williamson <alex.williamson@redhat.com>, Zi Yan <ziy@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, Alex Mastro <amastro@fb.com>,
        David Hildenbrand <david@redhat.com>, Nico Pache <npache@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>, loongarch@lists.linux.dev,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH 2/5] mm/hugetlb: Remove prepare_hugepage_range()
Message-ID: <4rypovqoa4j6f4fyfqzrm5xeiv3dng5hc5dlfhmnehkydk6gcd@z6f3k3joaoli>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	kvm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Alex Williamson <alex.williamson@redhat.com>, Zi Yan <ziy@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>, 
	Nico Pache <npache@redhat.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, loongarch@lists.linux.dev, linux-mips@vger.kernel.org
References: <20250613134111.469884-1-peterx@redhat.com>
 <20250613134111.469884-3-peterx@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250613134111.469884-3-peterx@redhat.com>
User-Agent: NeoMutt/20250404
X-ClientProxiedBy: YQZPR01CA0067.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:88::14) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|IA3PR10MB8137:EE_
X-MS-Office365-Filtering-Correlation-Id: bd8d44f2-612c-4f16-90ce-08ddaaf98dc9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?i3ZvQ4c6Uw+hQloTSU2cw34BN+PXaLCXUlmCWozBQzBaxkPEXDJJQm86/BYf?=
 =?us-ascii?Q?5bAg0a9YDcHr265/kcRgo5VR5yW56FYzKYqGEvWrxlWhL3nwoYZE6hf96b1f?=
 =?us-ascii?Q?KkCcmLTXHP82311cRMY6nfOgv9RdgqRf1UK8MhaNSQbJ4WxqwMt3WJE++7yA?=
 =?us-ascii?Q?gfy/VrvjW4toTApOOpdnCunSQMN7fZYC5wNxElB/WGdcHHF85rvJnObTHFrM?=
 =?us-ascii?Q?rhKj5acJXS4mzAoJfCrlDRrh3sSD1E8WoVHEgYapqMNL+I8fZZbQEO9RcXZu?=
 =?us-ascii?Q?BthpDZKHWBkOCDEwaxaS7k9sGX+rIsJVGOrbBpXGFrEAwj8E40JOH5J/CMpX?=
 =?us-ascii?Q?/aS692WKesqS4UoeInSw78KYGb2+CguXGFRdUn1ZZv4zjC501Zy45n6QdgaN?=
 =?us-ascii?Q?ghxvMe8TloweE0qEQm14U4G5mGq6mzcCjHAT4PVwTZS8+PUoyo0fdkysHt3o?=
 =?us-ascii?Q?bsHmCL1fQ+JlfM+7PGcCffRoCva12DOxcl4HVlYe/a0h2h7S9ZHDppQYH0SJ?=
 =?us-ascii?Q?kvzcSanc8aegxLxt6KdMpV/+I2gCO3kkQ/i+UT27xX9t1CyciKG5U6mG4/Dq?=
 =?us-ascii?Q?NzpDxq60gC3P4zy3zNvUr+PkiOZLSm4ch7lfuFxS2XHOPrObgJpgMuhWG4Fy?=
 =?us-ascii?Q?WLR/KeGXCA+mXDDPsf2syPF3PXti1HSISPFUXRnhqfN1dz0ubsPib5F1ZRw7?=
 =?us-ascii?Q?hWc2HWUJMMsCQhvnZUqp4aJU74GlPGFZW+AxN1eT+/aQEZ+byiFowyJf02k4?=
 =?us-ascii?Q?PaKKRBZ6V+oEL03BpvGo2Z4hqtTdV026icWFb+R0Gl62yfwI2VzZpJyrAa7X?=
 =?us-ascii?Q?SmBBoTRIG92RpWEC4NXfUcLIHVQz5DCfQ3f6aWC9OuXVpj3eyWjIQrGZdY8E?=
 =?us-ascii?Q?d6LCL6yClow/ooVBDvB+LPX74UsXABoogv9izGax5CDRVuGPFwtswADc6Dhi?=
 =?us-ascii?Q?zmiSQm1glZU1TvdVZf5TF3paS1slPaTnWRE3rYPOvMbIHY6pzg7iNDPZzy6P?=
 =?us-ascii?Q?PTZo3RVs9xTtYAFNqib3hoVmwuagKy9NFO0aN49cSxkYiUUy5RwxAxQYTDWM?=
 =?us-ascii?Q?hpmhWGVyVzJxXXMlyaZJheNH8xNsMRqUsjoTHYW5rGRLH783huHvRpMGE2Wa?=
 =?us-ascii?Q?s6iK8RhUamW2Is/5mgcDFSUTM+hfdMxEAn2ZpB0Xh/xsJJPvlgBywQRUoleW?=
 =?us-ascii?Q?BERhz/Oy6G2nmSFX9qFV8N0x+7qh3R1Kh9D89p+bY0iSQwgVF8/8yl5x+jfG?=
 =?us-ascii?Q?UQF7YYInYdfToqZSS1F2wdZq57buJ7gwuXF0In+1ln8SgkRpEoaZ96msr56y?=
 =?us-ascii?Q?H7zAEt8jrUEYLS+CDJAWXMLTYuAXmfPHblFd/yGEDVMvFkPOYzOCtSxbb3jj?=
 =?us-ascii?Q?+qa26lMWD65quQbmcoqzTRAZmUB1/X7Q8ShFcCERJdpO53kKYFtTMlW98dkd?=
 =?us-ascii?Q?/C+zBGSrTx4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?61a3xA1NI/e/VH+xPFW1ioEVPqEBv6Nw1eRhHNqPjJmZ4Ox5zR4s+8O9DcCC?=
 =?us-ascii?Q?0a4nKfhWFHIh3DIZ14hImZybsbTppIYqXH7TxkKKDKAvaYcJesjcEI1+eu4f?=
 =?us-ascii?Q?zDM0Ru/M9ZhJ0YPt0Vi+1clppOzB1si4FzOjjy4N/+7BtpO0OELfrb423zPW?=
 =?us-ascii?Q?LSSPMkfTTdicwgATR2KsTA7qX759BMQuckK/gwG66Rgez59f6i/+gc4jeaHt?=
 =?us-ascii?Q?Yz/JMC9BrE5m3gwvKr34SmcnLAxGZAM1fGAXRHxUik2SmVPZ8EzDtG6pqPwj?=
 =?us-ascii?Q?r2eAbd/o2id+w1IdfyXHD0W2XAi+D28WvbRcQYRAyosJtW3maqRG/HsLg8cD?=
 =?us-ascii?Q?h3WsTr2Inw0ksQSpJwERTaY0SIopLNYiY2rMBQqAPoDOkHLzS8biK8ERHLhX?=
 =?us-ascii?Q?F76Dsw9oZP7ApwkQFXb+k0fEWNOjm+5B4x/22+ebfvW6/n+h0ZMtL0EJEJqW?=
 =?us-ascii?Q?IyBp9aiGBlGtugV1wVMOv0qBHazzCgixzmmNBwIKysk9aofiNBjYM3jjafRv?=
 =?us-ascii?Q?FJ4IuXW91z93e+mfKkxuSXW1LOqn2/hQL4PU2qZlX5LgPdwPxfM9CRF21oEA?=
 =?us-ascii?Q?1l3lMvU/EzrglHzB9Nxi/5YelOGu53rEmykGutrB7g8vNsEoFxa1gGPK+4g9?=
 =?us-ascii?Q?8IQfj6oyiKFAI8xP+IlaJky3LIbGdWI3KfYIJ8TUEsDrOUJrIswPBZw4L+sW?=
 =?us-ascii?Q?9VSecb/9UD3eGSfTZvsclJkZZ4RYrKOVlzf1/GUWhPT9x+6elMoCNunZHQ2w?=
 =?us-ascii?Q?p6VdxRYqFYrHJ68XTKwwm6oBAHCXHDrytd8yud2ySYyDNSz6XOpgHlWxHS9O?=
 =?us-ascii?Q?DHYIoPwPHKPU7YI7OX06r4UyfYKKUX9q5e0RrO3JLLQShiMBPSZvTD6BaY/A?=
 =?us-ascii?Q?4l/syWkC0AFMXb+Q4kcToMwT2kbLvhaTEgLpr79vS8RJe2KAi2DHfyOO9IRv?=
 =?us-ascii?Q?0m6tgPX57FNWrVqADat+Vvm03veIBIqVF6zqYql0qEa/5pjDdVcfdxEYcCIa?=
 =?us-ascii?Q?bM7KQTXFXDp5/DzhZFXliyzB86P3ZNBTEv2IySRZk+o+WbaswkVISxJbxjXr?=
 =?us-ascii?Q?z83ozRzEi6IV4zPZaWNkHLGtyTtCXugvXpV84es1DIR7K2NnkfdtqEEvbpq6?=
 =?us-ascii?Q?drvyGJ/0JhqT+gkvDuUeBgnc1sg5gvVdIiS2szlt536OG2NcEknWwO/zF2/4?=
 =?us-ascii?Q?6Jp1vqPC0EJZ0tpaSJfxuvY05coVRPRATWFEnIkGlhTglqZiiwWblDUqOzVd?=
 =?us-ascii?Q?EXdKYTztd7GU3JleB0O1C6Oaga+6qMa3WY5oGYKOZYFKhudf6QCUWntGrY+/?=
 =?us-ascii?Q?ZBwqoUnUZPHmbbwBMKBol5prGhFf7Z+Zy2zr4NPdpXoBzV5+sIvMaM5vXLZY?=
 =?us-ascii?Q?f9XzzRVFGN02USKk5L8blTFVBrl2kFV0iT/czBKbE36yjcLdt/ij6YTtd5wl?=
 =?us-ascii?Q?jhpzbBH9jyEvAO0gnjDLQYAoVUtLAOburVpx6DNzhCSMYIAyPdyWjF0P4bj7?=
 =?us-ascii?Q?ew174rcW27Vrkdnv05lJ4A80plaFrFdM1QsPdpCbCVbJCWNuUJ0cdcvcOGv1?=
 =?us-ascii?Q?8UbSN6NPV6rvGDPaAaKXNGDeN1Oxay/gljsWWlI0?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	v6QUjrRgm8Weu/az10VbsW4fIsV8s9x2KnGlxIpHl+PLy9THwewNtsOhxpDLN6tF2SVsEYLdtzCh2hMeSl0gDCsvc2cqhsTm8tP+6waSUG9O0K1ePxRuWoFEIVI9AnozktGpV+VCFctbm4CspY439zVY2zT9oSI/yOJSJQ50mYjM1Il5nBTUq8+sp4/TwlGTw6+5Exvd77AgeIn51AEsw3FkH34H6IQ8vnRPUkYPm9BRCjpglAbjF36lodu76jea1/NuZkuYRlB6MllWOismeJ60HXwuO5MiSh6Kn6YhEZqWUwyhIYb1Tq7rImuTwlUdV8zplZL3kH81wof1YZrcjE+IZ6r/xrEdUVZcbBMUkRCyez10/mgzcqisBmmpSLtE0Ahh63rwDbQvU1sSs0Y+pqf6jAOlV0x234aJshJ+nneCQRhv9i9yt/I5wAq6DgjGRUo/xqySd27NfrjO+YKS8ce8WTXzGkKL+8e0NlfXuyGIXtIIgguG9cmroe8EYf4rL6EPNM/xgBxVRgk64MutxGSqKSmyC3+XNmmmSDBnY2ke8iUEpE8qTVPDKX2ka+perHIzX7hX8N0tZuJCOXbwCxLIMBSqvDAk2FdSYWqEBTg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd8d44f2-612c-4f16-90ce-08ddaaf98dc9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2025 04:11:36.1826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /inewvsez6KDMJub2dYWherwGylC0Xlm7hEWZh3bd2gCig/z3SBOhNhgtfz6hv1NrcyidlNOr8vok7IBU74ebg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8137
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-14_01,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506140031
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE0MDAzMSBTYWx0ZWRfX71hIBjrRF4km 0wzF9Glp59Pb0rah+G3bY3TmDK9k90tjNkROxNeNM2a21mwOJ3MyT1raxlNZDmPNlOqc0wKjlcW PsZsoa8HDV7jgUa/Kh8MswWUIBxJKNWuwYC/ixy2eOM0i59Qraz3JpbToLZTvfczuYU/mEB4J/V
 ru1038xPBDX3WExl1hOs+mNf3MjdpUpt0DC1riF2CLw+/KH3I581hOVSnWRu7lWby/4JIPr8Jqw AYLA6Wj37ynvBQv7guYepclBz2GhUzAKGkC49GyBQCYHI+vYNctFzOEImJYzUieViNIi4xL82T9 J3VqKr5lAsNjtSImSsxSAHGGfPkOaspfhvkcbOkOOTZI+obzEtTwwgkIKaWNNLvgRfQvXMuFoHd
 75s75AFndLzyxduty6v3daBGi0rpUfU1s0VW6uGNqUOwMYNkyFL02LNF3dDzbk1NG/L+7Mkk
X-Proofpoint-ORIG-GUID: _ubHrjVfIFu6NnqnXDkTTUz8CXRM4SQA
X-Authority-Analysis: v=2.4 cv=X/5SKHTe c=1 sm=1 tr=0 ts=684cf67c cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=enOvQawGAAAA:8 a=HUJ4IZbW0sMVnsjnhkUA:9 a=CjuIK1q_8ugA:10 a=OuzhcWw_GC9nAYdNdRwA:22
X-Proofpoint-GUID: _ubHrjVfIFu6NnqnXDkTTUz8CXRM4SQA

* Peter Xu <peterx@redhat.com> [691231 23:00]:
> Only mips and loongarch implemented this API, however what it does was
> checking against stack overflow for either len or addr.  That's already
> done in arch's arch_get_unmapped_area*() functions, hence not needed.

I'm not as confident..

> 
> It means the whole API is pretty much obsolete at least now, remove it
> completely.
> 
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: loongarch@lists.linux.dev
> Cc: linux-mips@vger.kernel.org
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  arch/loongarch/include/asm/hugetlb.h | 14 --------------
>  arch/mips/include/asm/hugetlb.h      | 14 --------------
>  fs/hugetlbfs/inode.c                 |  8 ++------
>  include/asm-generic/hugetlb.h        |  8 --------
>  include/linux/hugetlb.h              |  6 ------
>  5 files changed, 2 insertions(+), 48 deletions(-)
> 
> diff --git a/arch/loongarch/include/asm/hugetlb.h b/arch/loongarch/include/asm/hugetlb.h
> index 4dc4b3e04225..ab68b594f889 100644
> --- a/arch/loongarch/include/asm/hugetlb.h
> +++ b/arch/loongarch/include/asm/hugetlb.h
> @@ -10,20 +10,6 @@
>  
>  uint64_t pmd_to_entrylo(unsigned long pmd_val);
>  
> -#define __HAVE_ARCH_PREPARE_HUGEPAGE_RANGE
> -static inline int prepare_hugepage_range(struct file *file,
> -					 unsigned long addr,
> -					 unsigned long len)
> -{
> -	unsigned long task_size = STACK_TOP;
> -
> -	if (len > task_size)
> -		return -ENOMEM;
> -	if (task_size - len < addr)
> -		return -EINVAL;
> -	return 0;
> -}
> -
>  #define __HAVE_ARCH_HUGE_PTE_CLEAR
>  static inline void huge_pte_clear(struct mm_struct *mm, unsigned long addr,
>  				  pte_t *ptep, unsigned long sz)
> diff --git a/arch/mips/include/asm/hugetlb.h b/arch/mips/include/asm/hugetlb.h
> index fbc71ddcf0f6..8c460ce01ffe 100644
> --- a/arch/mips/include/asm/hugetlb.h
> +++ b/arch/mips/include/asm/hugetlb.h
> @@ -11,20 +11,6 @@
>  
>  #include <asm/page.h>
>  
> -#define __HAVE_ARCH_PREPARE_HUGEPAGE_RANGE
> -static inline int prepare_hugepage_range(struct file *file,
> -					 unsigned long addr,
> -					 unsigned long len)
> -{
> -	unsigned long task_size = STACK_TOP;

arch/mips/include/asm/processor.h:#define STACK_TOP             mips_stack_top()


unsigned long mips_stack_top(void)                                                                                                                                                                                                             
{       
        unsigned long top = TASK_SIZE & PAGE_MASK;                                                                                                                                                                                             
        
        if (IS_ENABLED(CONFIG_MIPS_FP_SUPPORT)) {
                /* One page for branch delay slot "emulation" */                                                                                                                                                                               
                top -= PAGE_SIZE;                                                                                                                                                                                                              
        }                                                                                                                                                                                                                                      
        
        /* Space for the VDSO, data page & GIC user page */                                                                                                                                                                                    
        top -= PAGE_ALIGN(current->thread.abi->vdso->size);                                                                                                                                                                                    
        top -= PAGE_SIZE;
        top -= mips_gic_present() ? PAGE_SIZE : 0;                                                                                                                                                                                             
        
        /* Space for cache colour alignment */                                                                                                                                                                                                 
        if (cpu_has_dc_aliases)
                top -= shm_align_mask + 1;                                                                                                                                                                                                     
        
        /* Space to randomize the VDSO base */                                                                                                                                                                                                 
        if (current->flags & PF_RANDOMIZE)
                top -= VDSO_RANDOMIZE_SIZE;                                                                                                                                                                                                    
        
        return top;                                                                                                                                                                                                                            
}

This seems different than TASK_SIZE.

Code is from:
commit ea7e0480a4b695d0aa6b3fa99bd658a003122113
Author: Paul Burton <paulburton@kernel.org>
Date:   Tue Sep 25 15:51:26 2018 -0700


> -	if (len > task_size)
> -		return -ENOMEM;
> -	if (task_size - len < addr)
> -		return -EINVAL;
> -	return 0;
> -}
> -

Unfortunately, the commit message for the addition of this code are not
helpful.

commit 50a41ff292fafe1e937102be23464b54fed8b78c
Author: David Daney <ddaney@caviumnetworks.com>
Date:   Wed May 27 17:47:42 2009 -0700

... But the dates are helpful.  This code used to use:
#define STACK_TOP      ((TASK_SIZE & PAGE_MASK) - PAGE_SIZE)

It's not exactly task size either.

I don't think this is an issue to remove this check because the overflow
should be caught later (or trigger the opposite search).  But it's not
clear why STACK_TOP was done in the first place.. Maybe just because we
know the overflow here would be an issue later, but then we'd avoid the
opposite search - and maybe that's the point?

Either way, your comment about the same check existing doesn't seem
correct.

I haven't checked loong arch, but I'd be willing to wager this was just
cloned mips code... because this happens so much.

...

Thanks,
Liam

