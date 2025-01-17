Return-Path: <kvm+bounces-35838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 57E51A15579
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 18:12:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7B96C188B238
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 17:12:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D26411A23A5;
	Fri, 17 Jan 2025 17:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MmzpsLxR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="sMP2sMd6"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F391A238A;
	Fri, 17 Jan 2025 17:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737133872; cv=fail; b=rGkH1PJD12szl/WDPe4ZMVAH60NL1Qt6aLqAqCE7Lk/AjRrOdlKmvRpDlQ+R+Oozb2I66eWJrS+N+hRb8Hmfh9334oWVRiyRrlMu3TbocDERODQ2p7MDnC3asavwlLB6mCru3rrp0HGaUMsI00CUTl5hiTjR7HHGcjrJsiBzkfI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737133872; c=relaxed/simple;
	bh=HWl3SHwgl+7q8cBtQ7dRcFa02fFT5xHrGG4yoLGDByo=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IlLaC2njICoJKxn74PL5vKCl3pQ/pHp3FNsh6yE/fHUgFTrFsnb6Lp63tDBhcqqTeWXycO2X4Thi46RFbDH2hfOWGm5cygJKujwiFPkQAh2B8G32ea03u3utmujApsvRHK4NIEWPjLYWC4j9MYE04siIWfv+vfvOZCDPm1l/pl0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MmzpsLxR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=sMP2sMd6; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50HEfmFe018543;
	Fri, 17 Jan 2025 17:11:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=CGEToPu9nybTv34n7bEGjRb+DZfSP/oGV4zsvvotkPY=; b=
	MmzpsLxR/JxUPTtZ0fSjHv8C+Fk8fjX14KOK1h1DUOA8Uf1lEhFXsIhY1NYLUqxz
	6q5queZ+5raQtFHmdve6PwyOSczrP4NZxov6FZjgljzUYKxOvjVMDheH1ogCVhlg
	BKQG71Xhbif/tdq3jxAPyxV24xLUhAmGsvugiOYL0OTWGp+r4XsARyGUXbaJKokF
	/LvslRsGsqu+1FoACCQBOeWiGBuB/bKpD9e2OzMic1+U7ScRnIRavkAo7+kY2eBq
	M040ROU9R9Z6FWW+BCNd3zrALWW1LxE2O0quOtqvb4ZW2jtQ39ZQuYWF1S3jUTPv
	LFNN8hlxccD1hofMkkE8mQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4478pj9wa7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jan 2025 17:11:05 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50HG1FO0034817;
	Fri, 17 Jan 2025 17:11:05 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 443f3ccrju-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jan 2025 17:11:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sCieOAgwx/d3v5xAXn1ewatkcH335ut90odGAoWHaVpcbiAYwZPLNWOJxY4k+gjHgj30aJx0/hA+PownMXvIxxdaJ/qfzhSg8zobVX8UrM0QK2yGTb4M4vV0Ej7lVsLwjzOdIhCAtS3prpeMT+5P4CGdxfa26SpRs/upngxwxEf3ZPjbFTId5CYOH5wyh/lESduTr3jdrV9iooNVsxvslVK4fK1coGzk3q9X1+FUSm5zGwzYyzAHSblPOb5OP3i3hTXCLlkMXXfRZJMG7YO2aw1CXLwAbtXRc9yWIldrFJjQoqyIcmehfbXF16Gtxhu7P/WdXvMogpNHhW93TWe6SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CGEToPu9nybTv34n7bEGjRb+DZfSP/oGV4zsvvotkPY=;
 b=NUE2F0PX7OVHHPBgAimWf5O3xQP08KEAVpDpjR6/ODa8UmIXrmuEgHWAwNo5Pp1FC7qFqKHPUy/bvvVpuBdCW8NSNAPZdruaw/ZDQjLOHF1wEgwAQYdqJLwoqpEBHjj2NmjELIW7iWAZOsQQwNDCFZPJzrnB4YUl70BD3LwqmXV1wzGdidcDFAEmvf87ymyyKd/RBmX+JW7HFHVS71UlUPxy2LShCzjvOHVxg5zADxmb2ZjE4xyTQ/8l66N15Sgyum6w2pyd+QQHocfDgEZs7EYCE0xY71gMfb8jnscPvBdPUWgBJHKPQh5Gihee8MlqX9BHa6k08XmL0yWRr8zYZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CGEToPu9nybTv34n7bEGjRb+DZfSP/oGV4zsvvotkPY=;
 b=sMP2sMd6hZjcUJ8BynHVvTrSPp8Y2HIIWO0G+CDWox/bM14AfmBBYqt+Kz9wex1p9F8jSZBvrYBADc03TXibwYg89VLu/JzL/DtzfGri3EimbT6D8gXIdO5oLMiQ0i8wXlfpIoQE5FdKZLomHbmPeIPOboBapSz1h86d6SwKmWY=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by BN0PR10MB5061.namprd10.prod.outlook.com (2603:10b6:408:12b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.17; Fri, 17 Jan
 2025 17:11:02 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%3]) with mapi id 15.20.8356.010; Fri, 17 Jan 2025
 17:11:02 +0000
Message-ID: <41925d66-f4b5-4f96-93f6-b29437399005@oracle.com>
Date: Fri, 17 Jan 2025 11:11:01 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vhost/scsi: Fix improper cleanup in
 vhost_scsi_set_endpoint()
From: Mike Christie <michael.christie@oracle.com>
To: Haoran Zhang <wh1sper@zju.edu.cn>
Cc: mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, eperezma@redhat.com,
        virtualization@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <e418a5ee-45ca-4d18-9b5d-6f8b6b1add8e@oracle.com>
 <20250117114400.79792-1-wh1sper@zju.edu.cn>
 <d00be9fa-364c-4b9e-a14e-a3b403e7bd6c@oracle.com>
Content-Language: en-US
In-Reply-To: <d00be9fa-364c-4b9e-a14e-a3b403e7bd6c@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR10CA0018.namprd10.prod.outlook.com
 (2603:10b6:610:4c::28) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|BN0PR10MB5061:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ce77e12-b6d5-4c7a-5189-08dd3719ebda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a0JXOFhvRDRKQU5zcGNlOUxmMERib1lwOGNmMU5Fd0lzbi9QRmF5eWtCMzhD?=
 =?utf-8?B?dEFxbmV0dnMzS1EvQmlRMDdKVHpzTjY0NE5Lek11SWt6alhYK1JkbWpkTUZY?=
 =?utf-8?B?MjZJSmEzV0FVR2p0aGpUV3YyaHl5SkJwY3hiYXRvRlcvVlhXbms3STFvQlRn?=
 =?utf-8?B?ZmE3bnJqTFdTMVh0MUtzQzRPS0hoZzJLb2NMblMrV3VaWDhjMVdIMlZKYU5Z?=
 =?utf-8?B?WjY0N21wZGRYT2N4UU91ZWV1RVBlR3VJbFZXcUVBR2VRQ0J3MmkwdGZRcllM?=
 =?utf-8?B?WlpWS0lDZHU5N3NUYndoREdXL0VKcVVEZWlVejVIaGhLVGM0UFc2TGRyYVla?=
 =?utf-8?B?bkhwZTZRR1JuNWhuc0V1YTVTZ0JFejZiNkYvd3BHMkZkREhieGFZdU1mZ2dm?=
 =?utf-8?B?L1lNcFVyTVlQMHR2WWs4SG5UajltSm9ZQ1EzcTQxa21oREdwL2Z1SUdaRlho?=
 =?utf-8?B?TGFSd1lVRFRyYi9sUGZBMDF6UDZPRitrTVZBOFFRV28wYVl2dmlQd2MrblAw?=
 =?utf-8?B?NDRVNDdvMmlMOE8yVDQ4VTJVS3BTZXREYmk1eDdNM2MzOHFtdXlkc1FDcW1E?=
 =?utf-8?B?NU44RHRJYzRrYnEwRk42QUtPYm9TNklkOHBiZm81VGhxcGNIV0RMZmRUakY0?=
 =?utf-8?B?bEYzSnNlQmxkUkozdFBMU0swOXhqLzFEVGdLWmdIUjJIOG5GaVBaSGtHNlV6?=
 =?utf-8?B?cldDb2lSVmh4M2ozL1hMUmdFK1B3SVhnVWl0U2h1cEtxZG8rRno2NjJTZ012?=
 =?utf-8?B?WWo1NnA0azdYRnJ6YWRSRnkrR1M3NnJZcmE2Zi9iU2ZWclZIUG1Cd0c3VkFX?=
 =?utf-8?B?UHF5azJDVGczdE9IQmg2dFdSRWdkWTdlclVOeXBuVkxDMGpkZG1EdGpHendC?=
 =?utf-8?B?b05OeXdpcDFRNDF0cFNLUTFsREVTb3ZLcGs1eGtJS3AyMmdVeDZFcm1NaUFT?=
 =?utf-8?B?Q2VsN0dJQmlXZml0QXFOWnhjSGRmZmZLV1hWaXByRHFiZXg1VXRwdGRaclVk?=
 =?utf-8?B?clI3bTNGNllPcVhDOHN0NkN6NzZvYUVKcnZJN1hGVFIzQlFuMy9sM2oyZFlW?=
 =?utf-8?B?YnBBM1VEaDFmV0FRMHI2RzR2OHB0c0VMNTIxZ2Z4WXhiWWlWbUpDbnJtZzJ0?=
 =?utf-8?B?dFR2enVtczZ1VXF6N1Y0MmM3UCtMK2JybnpBa0lHbktNbStVTjRXbDVkaE52?=
 =?utf-8?B?T1VlalN4cUp0ZjhBdlVoemdSMlUvVjF4T3pUQXNKdmtZVTRwMzZUL25uemlu?=
 =?utf-8?B?MTFsRU03dkZzb2VPT0NrSnZVeHdTazJHYjhiMS9LUlRKRE1qM29wSm0xSmZG?=
 =?utf-8?B?M3ljT1FHNzM0S0RXclUwaVRlVTFzdTFtdVlUMHV4ZDUySE5UV0xoem9tZjMv?=
 =?utf-8?B?NC9QeTNIY000MCs5ZnBTUVpZWGFsRC9tb1drcmp0Q0Y1YzJlSllIL0hUeS9w?=
 =?utf-8?B?WE9lYnFMR3VWam12MC9kR2plWmgyWm9McVdqdkZETWFka0V2Mm5rb0ZTWlFl?=
 =?utf-8?B?dWVsYzZjdHRzTjFnbFhxTkVIYkFOOU1ickpJYytZbVJsRW0rMzBSOWc1bzl0?=
 =?utf-8?B?bDM0NEhoYWxveVp6QnBpTnVGRVlUZHpvUHUxa2hlL2pXOGt2MkVDYUlmWGdZ?=
 =?utf-8?B?Zk9Hdjk0SzlmeC9oenlBc3JKeG1NdWNuOEU0SXFoZGlKT3RRWkUyUlpOTnBW?=
 =?utf-8?B?MHZ3Y3BpOElndE1RVmdRVlFubHhvMXllNVNIOFlBTGdXYnVnTkMxYUwwV0xS?=
 =?utf-8?B?THNuSFZqZTQ4cHBLNVNWeXdJZzdzMElZYiszUkxmVUQyZjdIMUJXQkh5c0VE?=
 =?utf-8?B?Nk1UdlpsRDFhUis2STRLZDhnRFFNWHdDb1JZaElzaUZlS25haG5ZT215Q0Jx?=
 =?utf-8?Q?59DSreuWSCstp?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dUlDYmtyeFY1WlA1QkY3VkIrOEUzL3poNmFjM0VuRkRXem1iZm1pMkd6WmdC?=
 =?utf-8?B?QmlQcFRicnlEQTFVN3hxQUtnQ1h4a3Q5TWMzRmthWlFvVkdtTTdrK09BTWFT?=
 =?utf-8?B?QXhteHlxbVRCREJ4RkRKblhRLzdBeFp0eU0xMFVpQ1Y3aDBBV1RNeEFZWmtS?=
 =?utf-8?B?c1hGeWhhRDJRWlZoZjd1SU5FcmptY3BJRERXTG5Icnp5U2lvMkFUbnJHOEda?=
 =?utf-8?B?N1FrM3NDcDYzaE81amdIVzZaUWg0Qkd2aWRGZ0ZZemVSbHd6UEJvU2k3STg3?=
 =?utf-8?B?Z3ZNTjd2VVRRb2ZEd0xyS2d5VkVjQlJ2bjRtZTl0TU5OY29GNHc1QlJ2QVhU?=
 =?utf-8?B?aG1uUWc5UzNWWWVyMTNYQnZNUTVFSXZMVHpHZXJzUVo2bHpKQkFxZytZR2Er?=
 =?utf-8?B?eXJBM0d4MEpTVHNTVVpIUkQ1aVdsUHM2SU0xbitkZlJXYjNTL1MrUytZWXFm?=
 =?utf-8?B?ZkZqUkJoSGtWZ0VUaVlvZy9JdlVKRzF6S0tLWlc1N3hKSW9yWUdqNDdTTFFv?=
 =?utf-8?B?NUFJRU9qMmw0ZTR3a1NTWlZ3Q2FmcjlJVDg0QVNkUVh2Vm91cGxmY0FyOUFT?=
 =?utf-8?B?MjlSQmNoeUplc0JjYUUycTVOSFJYSDg5bjNYVFhOQWVzelVoNzI0d2d2dXlI?=
 =?utf-8?B?endWckJlWElCQ3ZZT0s0R2kyT1VrK1cybkt2MDR2U2xZVUZLeGNlRWg1Mkw4?=
 =?utf-8?B?c2d2Q08rMmpRaXZPU25iaXVHWnBDTVphcWlPNk00UmpsSHhldlcxK1R6OXZG?=
 =?utf-8?B?V1F4ZnJzRVBjbXNLNGk4MVhoRG13R0VSbzlrYWVsQlZuZFhKeVdXUW4wUXQ2?=
 =?utf-8?B?My9PelZSSFZXeXplUndlZUtnM3c0Wmk1eXhYZTZoNmpENGU2cEFLcnhTQ1F0?=
 =?utf-8?B?VTNYMjZhbjVWNmRtNHZiUzJ0aHNUbE14djZJR2ZpSFJNNUI3L0UwTzlQbXBX?=
 =?utf-8?B?QkZDUzh6QVgwcCtRclFXdUc0NW9oVDduK0RYaEtIdjVhSlVVR1BkdlU4VkhS?=
 =?utf-8?B?T0xjT0RqTFhUS1MzZ21hWGJRU0FQYkNDTW9uL05WeUs0cTBvTXdmYjgzQmY0?=
 =?utf-8?B?NnJnUmtHOUUveG5EczBHRDRuaitoSy84c1AxR1ErczlNclNzUmxEbHlPVStQ?=
 =?utf-8?B?YnFSN2dYRjhGMERDTXhEVzE3b1N5UkZ3MVREanR0SW90dnBkSXNaUHN4d3JV?=
 =?utf-8?B?NVNSc2EzUXl1bmYvL3JScFFlcklLNzNJOEllMzFXOUpsMkFpQU1hUHdKZHQw?=
 =?utf-8?B?Q3ZMOEVKVVZVUVFmSFB0ZGJTdTVhSU0wWTk0eEhmcktINHZMMGNoUUcremw5?=
 =?utf-8?B?NkMrSG85cUV3aFVrelFHOTBxdFFGczVOeUxSckZWejRiRTEwOUx6ZzE3eG84?=
 =?utf-8?B?anZCdW1DZW1XREF1VTIxMGVwMHdEOW0va0FvbExRK3IyZitpTFdEeGFOcTh5?=
 =?utf-8?B?T05XdXlUVkt3cEh0UzFxYkI3ZVJXMWlzbFpudDJWc2VOaXN0TFhLQmx0dnB5?=
 =?utf-8?B?TUJUSjZZcFRSblUxN3c0aHpCWktEY0VkelVWY09vZEloYVE3MVhPaWFKK0Zr?=
 =?utf-8?B?bkpCQlhhbnIzc1A3TWU0Q2hWTEYyUHppWDZlNllyT05JTW9naGlKa0VtZFBV?=
 =?utf-8?B?NURVNjlXOWc3bjJGR01RSHV6VG5VaURRTWpQeSsvejRzNWxPMGwwU2J4RFBk?=
 =?utf-8?B?U2tWMlQzMGtmMFFoUE8wK3RtcGJnMnVDSFgxL25wQ3JQSm1vcjNCajhySmJw?=
 =?utf-8?B?VlNPdUt3U0RtRXE5bUh3NXYrVUJHbllNWUFJRTJTT09UWUZpVXROLzRiZGlF?=
 =?utf-8?B?WWlrcnZ0VS9ibHFrbjhIbUgzaG9VL3Y1dmVNVjVaQ2ZwYjU0NFRwRDNBZjZr?=
 =?utf-8?B?YWJOd0dkS3F3WHdIRENncE1XbFpsSHFPbHJtVWZOWFArSlo5dzAzWGk0QVhj?=
 =?utf-8?B?cndtb2dEaHRiVnlENUJOK1M1V2FNc3dGV2h1SjBuMTAwQ05za3dyMzVMdUtp?=
 =?utf-8?B?NkExZ1A5RnFKK3A1UUZkM1JNdTEzVHduSU5mMXp4Y1RFaUU1Ymo2dnZsUWxl?=
 =?utf-8?B?TysvMU5BeUFGR0RpSGRIdUVPY1JLRllPU1hqTXpESDh5ZC8vSWY4Tk9UU2lP?=
 =?utf-8?B?TGM4L0pidTBzYVhBZ1JqZ3JlTUlOZnlMaVpsNnBqcE9JM3B1UThPOG9xZy92?=
 =?utf-8?B?dFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JrY6qtEAWjY5E8vYcQ3njS8Qrey7DgArsjaylqKS9ISkIQjDr12bK9ajedLTXfniI+M95cgt48HH1EEqDLUZOxwxqDlNhzGJZATBkptnZwtcUG4f4Wu9d67exspkY1gdxgAIhMHmBameg4pra2hqrHLcY4qoyrb8bf2JuWKzwugVQP34GypkNedaJN39BWYDYLM0sFrjVD6mDtX5T7kMbbL7YiS+CMG65+YKON0JRRppSeg+YIFS5QggK/OzKcJV7YUiyNhWe27+S1m4RBfUBn0C0UHuobBFJx+dV9OdRZmOsVQJ8Fqj6fHIFOE6BYvDdNg3CIqSguyOTD28Hf20/unzf8IrDvhY3JoTfUcATUJwlFO1jw8+ICuKmn8QOa2qk3vZxoTQ5r//8XJq1sjMgSTj2R2WPQC5PtN6JrielM0T8XIXZCMiYlCCChBXNsE9Kgn7cPECWNPjPaawvWWWv8iR0TsyZFpmNFklY3i1N2Dn4GbB1Gjw+72GPZyLQRw+UazdA3OhZumrbE8udhACM/bdTq+ipPy/b8nhgZjkRhjokIq0CnmK/aYWDbw6gePbs9Rrfy3JvmymNrRD8C/MK1rxtkczDYoyF0VclFlBZZc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ce77e12-b6d5-4c7a-5189-08dd3719ebda
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2025 17:11:02.8494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8WF9hgechi+P/Xx6H+OU7axI0L8VGF/i7sdkyfQ8rsZ5cGHPocPKWgNX/UgtGKa6Ru5rUa7yiQAVs4tKaC+9WGa+bdS1f7BKOujup06u9Sc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5061
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-17_06,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501170135
X-Proofpoint-GUID: B9mnzRIDiQUazyI8Rzjcp_iFsl8VLMvB
X-Proofpoint-ORIG-GUID: B9mnzRIDiQUazyI8Rzjcp_iFsl8VLMvB

On 1/17/25 10:50 AM, Mike Christie wrote:
>> You are welcome. There is another bug I was about to report, but I'm not
>> sure whether I should create a new thread. I feel that the original design
>> of dynamically allocating new vs_tpgs in vhost_scsi_set_endpoint is not
>> intuitive, and copying TPGs before setting the target doesn't seem
>> logical. Since you are already refactoring the code, maybe I should post
>> it here so we can address these issues in one go.
> Yeah, I'm not sure if being able to call vhost_scsi_set_endpoint multiple
> times and pick up new tpgs is actually a feature or not. 


Oh yeah by this I mean should we just do:

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 718fa4e0b31e..372a7bfda14c 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1699,6 +1699,11 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 		}
 	}
 
+	if (vs->vs_tpg) {
+		ret = -EEXIST;
+		goto out;
+	}
+
 	len = sizeof(vs_tpg[0]) * VHOST_SCSI_MAX_TARGET;
 	vs_tpg = kzalloc(len, GFP_KERNEL);
 	if (!vs_tpg) {

?

I can't tell if being able to call VHOST_SCSI_SET_ENDPOINT multiple
times without calling VHOST_SCSI_CLEAR_ENDPOINT between calls is an
actual feature that the code was trying to support or that is the
root bug. It's so buggy I feel like it was never meant to be called
like this so we should just add a check at the beginning of the function.

The worry would be that if there are userspace tools doing this
and living with the bugs then the above patch would add a regression.
However, I think that's highly unlikely because of how useless/buggy
it is.

