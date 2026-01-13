Return-Path: <kvm+bounces-67933-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A2ACD18B05
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 13:24:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id EBEE53008F56
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 12:24:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88BAB38A2A9;
	Tue, 13 Jan 2026 12:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E097CMJs";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dDBdysoH"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FFC38F24C;
	Tue, 13 Jan 2026 12:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768307054; cv=fail; b=WuNGMrr3Rmd4AyV851mVQIizmWXb70ehFy5drm18KQugRRdz/GKXkk7jEGWpcvOCLseNP/Srop9NYunDvwu/CvbK6E4k1IeyoSjbKNNFI2+W0nd4nEXnDVHLW9pzr4QEL35ftvK9ZSyNsYGFguEZa52A7aOgvXJM4tQSSq3iIno=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768307054; c=relaxed/simple;
	bh=I2Wz/4v5FFIlbzauF/oyO4VLYXnQW/8p5aEkZCwYIQk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JfZuxsMosnEzLwZvm1/EqauK6e5rxAC3/jkoQiB9Y286BN8PZ04urE4E1ZS2mqOt3RhKtCE+yOO89G8AOrsfhPTy1HYyc+sYJ7GpuoZoQVYk4pb2Gt3LzHno88qpDozdi5qDnfR9I+qRppD6a9Sy5dl6xaEkBSWQ1UZnWnL/B+A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=E097CMJs; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dDBdysoH; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60D1geCC2812196;
	Tue, 13 Jan 2026 12:23:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=VhxuwKC3bd2QBSkHoEkvAJJogpuXKtH55QL4qFMuTUg=; b=
	E097CMJs6VSBwLb7XCQWdk4C1Z+cVRkz+E7/dqPyHTVdN0O6pd0ee/n4oB/i81X7
	vfUWV1KFKzzBMSIhkJ2I6xR6cR6v5YZegcFBX3lnVH2O/jNjCzQD/UnL6kcns0y8
	fzICi2jgn5bHQrJKMXb+KHCKyYSYWsCPyNTFY1ktkeocSjoKKgbbCR0EXa1rG50c
	zazmi9nBl6bKAxru2LVLSL+2mFZtkCCx5JFMSreLYoauiJV2mD99h59fwh6TxUqu
	gmxCACFv4ly6o1KkGCwSA3nUHFQSHaXZXjwR6NwUqXvWnOT3n4IhO/SMtYrqbuGR
	dmXQTC302lnNmrebrm1z/Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkh7nkfct-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jan 2026 12:23:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60DBWMQ6003903;
	Tue, 13 Jan 2026 12:23:58 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012017.outbound.protection.outlook.com [40.107.200.17])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd78n68a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jan 2026 12:23:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ghIJ9MXLzGRpLXJ7ectdwkJ4h7nMgmYvNqidtLlsbPrtYkYlirb8evjZ5bd/4EIWsWcMwbrv2hosrVnoJJNuFajTAQhxXxbunMU37aK815MPATe5POhGdMRNFL52PE9S0etZcIMp6WkT357d/ZdLZR6xtp1il2kB0+ZIytqdi8KFdG+KP/1LGH03LnRo3vm+h+XvOzXVUPQ9Kqlj14pGQRdShYcWTELE0r3T3XdxeyFRp4a88eSYFY41fU3BL38yObW7rAC0NrGRtOz8Gx3W/FHQE6sP/jSgyrFKDIKZqCIZ6kPcLEChJguDBgRZ0ZU7bxnAU4mMPJQf9Nx0/5saKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VhxuwKC3bd2QBSkHoEkvAJJogpuXKtH55QL4qFMuTUg=;
 b=KAh0THphM1zshb/FSDBBSX+Zssu0jllMk7VGSFLVuI3zu2uSDlBfGEkYk9tOwAVBXy8xUiAYuKa5KeddFx/Y+maNDIPk6WZshcbSqYLW0+9p6Ev5IR4RYXyBbgONckmLTkKzKhSYMKHZlk38bddgydfoik+f36TMSRoaznTHhb9HNb7/JpTW2ioY4u/ZRG8pDG1BeuQzAlK3lmAHjT4HbVONZuqVTCHvpsfhl5kjsfUF/jPAXB9Hl+UqUievqAbUOVEOf8KeoevtEJRBtUyvYpPgSpSKX0hGogAnMV/FZ7YsstHjRlSYp79otmy0DvPwWyvyOAX9BVVChaTaBXxe6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VhxuwKC3bd2QBSkHoEkvAJJogpuXKtH55QL4qFMuTUg=;
 b=dDBdysoHsFxtZgv0/6qm0CeCgsWsDRwYD0d8pt7R5DiaBLMW7vs1JU/JgP2GWeMQO5z4ce5FK+WRE87KPHsoqKvA5l7GJspiTLcAsia+ZhRR0y2alUkUAAtTCZkZTMygN7mFshoFL0goLA4AfyWKXvm5mCLO3o7BZzZ4CTXOLUk=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by PH7PR10MB6652.namprd10.prod.outlook.com (2603:10b6:510:20b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Tue, 13 Jan
 2026 12:23:53 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::54d4:413b:e276:e71d]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::54d4:413b:e276:e71d%5]) with mapi id 15.20.9499.005; Tue, 13 Jan 2026
 12:23:53 +0000
Message-ID: <df5734e6-c41e-4f3a-bc63-21e6b083fdc9@oracle.com>
Date: Tue, 13 Jan 2026 12:23:50 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/2] SEV-SNP: Add KVM support for SNP certificate
 fetching
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com, jroedel@suse.de,
        thomas.lendacky@amd.com, huibo.wang@amd.com, liam.merwick@oracle.com
References: <20260109231732.1160759-1-michael.roth@amd.com>
From: Liam Merwick <liam.merwick@oracle.com>
Content-Language: en-GB
In-Reply-To: <20260109231732.1160759-1-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P302CA0042.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:317::14) To BN0PR10MB5030.namprd10.prod.outlook.com
 (2603:10b6:408:12a::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5030:EE_|PH7PR10MB6652:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f2ba606-ecd6-4f49-0e69-08de529e9d68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VVVJQlFic3dqREdYc2c3RSs4azBQZGV3elpKYnFhTmZIQWkzZXl5YVJUSG1F?=
 =?utf-8?B?ZlZESFlocnd3RC9YdXdKQlZXVFJOdWU0K1l3cnpNUTI1SmkyTEZxcnBYZTRo?=
 =?utf-8?B?VkxOeHE4cFpHZU1QUEhwSHpKUkpNc2ZCZlBvMnBFZXNNbHVidEVQK1BZN0VN?=
 =?utf-8?B?VGNra0I4cjdSSVRQZWIxRHdVdjlWenFWUDVQUzV0QnBMMmtzamxwNFpOSWkv?=
 =?utf-8?B?RzlWNU5JVDhtM042cm5WNFJzSnYvd3JpYTRaNlhtOVF6eFR1dDAyRlk1VnZu?=
 =?utf-8?B?Rm83WHF2LytVbmNzZjJqTUNDOWQ0cFhycmlFV20rcUI0N1ZSVXVocWtRTVBF?=
 =?utf-8?B?T1J6Qm5KUlRyc1BDelVrWnc0Y05hdEhIcW1icExHQmVGNHFldHhkQmJhQy9V?=
 =?utf-8?B?YU50elROSm1yMFJqV2Z2d0N4WGVqTGVXVDB3b3dqVXVmUEhZR1k5dnVrTm5h?=
 =?utf-8?B?VWs2YlM1WjlLRjJLc0RFNG51bmNqV0VJOWwycXRjZHB3ZFFNR2FNbFAvK2gz?=
 =?utf-8?B?WnIvZTRFeFFjM1kzNy9Nb0xVNFRnMTVBWldOU1ZiNmZwVUpxdDN4Zy92V1Ew?=
 =?utf-8?B?bTdmaDJ4SGErV1hOQTF6Y3hkcXQyZDBaTEsxREx3YW5WY1RGaytZSXFXaTNm?=
 =?utf-8?B?cnowU2xJOEdKSm9tc3c0d0FhRERQVXI5cWF1OWRiclk1aVp4bkVhVHZFcVF2?=
 =?utf-8?B?bmR1aTVHZWV6WjJoNjg5MXhXck43UlQrSzJHSHV3bzgyd1k1U08wbkdSbDFC?=
 =?utf-8?B?OGErdG44T1lJVngxU2FlckZmMHhpNlU3YnpuZSs3RUtNVEE0OFQzd1pENjZD?=
 =?utf-8?B?dlJJZitBV1hXWGJUQ0tadnZ2UTJ6SmdLWWRHNEFBTjR5a1lSVjlaY2NwdnRD?=
 =?utf-8?B?b3o3bllDRjRyc0NWbkZTTlJBWldZU0NRTXNta2xpWDh1a1NHZUVReVQyMnk5?=
 =?utf-8?B?OFZudmczRG9uU1l1UjBlZUlFd3psaWM4SmRSOVZhZG9JTGp6eTl5aUZmYUQ1?=
 =?utf-8?B?TDA3Wm9oKytCdEE2bzFYV3pOUS9pTWJhZXRSSGszTFpRTysvbkkrNDNiek5w?=
 =?utf-8?B?dTNKVVhWVGJ1WGZMTHkvM2RTMUdDczF6dFJkSmtwdWdkV0U1ZjhnRFRnK3Nz?=
 =?utf-8?B?eTNaNHRBdDJuWGdxSE95bmpqeVNBVWpDSm5MTmZ4YU42VTU3bUtzSWZORS9F?=
 =?utf-8?B?ZGh6NFZVQy9MMVVla0FXWnBDczhWRDc5OWR2ZjRZZU1UTkpLM0U5eHhka1Br?=
 =?utf-8?B?aHh6ZHJNNysxd0RBNHhrTWo2Y0JwakcyeHYySThVWXc2RnFrUzZhWVNnOEpH?=
 =?utf-8?B?THBOWXlDVU9CRVZhOTdSQWYyaXN6MUFHVUJ5YTN0RFZsakw2WDdqUVFKSC8v?=
 =?utf-8?B?d2xzWUUyUjh6MG9ycFhvR3hDT0dtMVJIODk1bDVwZy8vNmN4MlNhTGJiQkU1?=
 =?utf-8?B?TGkvWjE2OHViWFF4WXE3ckpNUU1ROU43eWpPVzMrL0Y4Mm40QUlZT2wvZ0kz?=
 =?utf-8?B?eWFkZk5CZnpBRHFNQ2oyUm5JbStYazZZTEZYazhoRjZDVXhvVVIrakdzcHNa?=
 =?utf-8?B?VXk4ZnRRMitRb2dhanZhaGxTMDh4WWs3dkJoL0tYVXJUWG1kUVFLYitRNnJs?=
 =?utf-8?B?N1M5ZDNjRk5LNUtXbitFWExDdzZuNThBdWpEM3Zmdy9kWWZXSUpwTnR2cjBJ?=
 =?utf-8?B?MXppajZpMmNRY1dlWjhPb0ErclVSQ05LVkFkbHR1QzY2aFZpcFkrZk5xZjBU?=
 =?utf-8?B?c1BoTjZkUXRBMHB0RHZnRTdRMk5ITmpzbmFUMkpzaGNad0dGbUdOT3JRTVBF?=
 =?utf-8?B?T3NjbUhaR0VhcTN4R3o5U0hUbmxuWXMvWVdXbHNnLzMyb0dTL1BmWmtKcS9E?=
 =?utf-8?B?NHFBSGNjQVQrNXA4OVgrNkxYVXNxVTZRaU9yRE9ZUGdFUnVUbWVhelMrVHhM?=
 =?utf-8?B?UGpxeCtxTFBYZFlvUTJOZk1tNWtPbFdCTVNDTm9ScUYvbldsZGJ4Sk1NaWgr?=
 =?utf-8?B?RG1ha05UYmxRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aUtQTCtpODhTN3psUHJtTzV0YnBzbnpYUmpLY254Njd1eGhCTThkNi9rS1N5?=
 =?utf-8?B?cTh5OVUwV3pKMkRIUHNRWmdDZ0cySEV1SnNVRmhwYzhKTE9pQ3RFYUswbHB3?=
 =?utf-8?B?UHZ3bUx3WTFMV2x4N3EzdjRmcWhqWUIwZEU5TXhMcDZQMU9sQ0JFUXpxZWp0?=
 =?utf-8?B?ZDQyanBkeUFxL0FLNk1MRE9yMUMrSVl6aGJLVitwY1VlM3lQUlh2Z0lVSkJt?=
 =?utf-8?B?MGpPblJWVlBvUkZCSW9SY1BwV0p1RkFKNThZdGRnYWxRL3c2Wit6UVJEZkZT?=
 =?utf-8?B?dDVTZnROajVBUWh3SWFkS3Vwd2tRY2M0dE45TjRVdHowelpacGFkYmhnenFW?=
 =?utf-8?B?RGRwWU9ubm5MZU1OWTZRS1hpdk1FeW9iNXhtN0hkZkpKdVk3elpWdlhkK1BQ?=
 =?utf-8?B?Mmd2Q3ZWMDJmd1J5SmpHRFpIaGMyNkJZc1p5dXduVWQ0ZUw2a1N3QVN5S3l2?=
 =?utf-8?B?QkhXdWdjakFxOTE1Tnl4OTFIWFRwVVByR0RnV3luWmxKL3c0ZDBlczlmUzVm?=
 =?utf-8?B?eE03akRwNjR4Tjh0MXhqWkRZZVdjNWYyUUZibkp0OEVlSHBnZmg2ZXFHWklG?=
 =?utf-8?B?UnI3LzNKY2wvV0RVSkJ6bXdodW1lZjlSQ3lyV1lDSzE3emdaRGxIaUk5SVNz?=
 =?utf-8?B?ZFhmUUErSWdPektLamxJcVEvOTFEOEg2b3BqVEIwM1gvYy9sWGtaUmgwQW9L?=
 =?utf-8?B?REYxS1B6RnVQZVlxUmtLbFRaODB3OE10RzVqUmhHbWIwOHhDTHV2Mm9QNzli?=
 =?utf-8?B?YnJnbFVsMEd6b2xIdm1LOU14YmJQTGh1ZzdndFFOSXIvejdtTkNQRjdkcS8x?=
 =?utf-8?B?dkc2K0pMQ1FmR3l2SXM5SVlYUVh2dXVtNFNmWXdhb3dxcmxsbFh1ems5bE1z?=
 =?utf-8?B?bFpPNC9rdjROV3ZGZm1WTFd1bzlFbHBGWDZlNlFqdEtXcktoVSs1ZjJMQXNS?=
 =?utf-8?B?TmxiVm81TzlycWIyd2tEaEVxZEpaTEprZ00vM3BHeExHaG1laG9zcUtDa3ZR?=
 =?utf-8?B?SGYrVWtaWjdmb3dtSG1tT2QrY1U0NFpIeWNQOXZaeDdqcW1ra3czdm1UTm9m?=
 =?utf-8?B?cHAwcXh1NlpPbzlFWFVmYWU0d002UmgydjJvRTBPVkRpUEo4UTRIOU90N0RY?=
 =?utf-8?B?alFLRTNTd0l1ZG9SV2grUnZ6V29TOFV4L0RnRTJ3bDVtMEtTZWNobHBWamVM?=
 =?utf-8?B?bVFhVDJzVkdRdkJ4cEx6Y1lyajFYWUdTdlZQUWh5cU9qYWorZW1HeGJtWjVP?=
 =?utf-8?B?ZFdMVVdCNXBrQVhmQ2JPeVV6cThGdUxjczFtTDVKbnJKcEg2TlRDK2JKZXFO?=
 =?utf-8?B?OGQ3WDMrRFRoTEMwWnpldG8yMFg5YW9NVXdOSmVOM0pXQlVLcnlRbDNqV1Qy?=
 =?utf-8?B?T3dNL0ZrYVowMm16bmlzQ1JjYytTMzFNRVVIYWlZdjc1dERpa1FsSGQ2TWtu?=
 =?utf-8?B?ZjJobEVZeitJMHRZWjZ0aHNKeDV0aTNheHhwc3JSVDBGd2QzT1c0aUloN2Iz?=
 =?utf-8?B?VVlMcGpkQjFkdzY5UFRsWjBUUDlnbTlIZlBwZDlpejJ6bUNremlyenNPV3h5?=
 =?utf-8?B?cFFValNDU2tYeUV1TGQ0Q05LSkZCUDlRU004N3BGRDN5bUlMS3g0K2JYUDJH?=
 =?utf-8?B?ZThjM1ZIcE1kSDlJenp6a1NoQUtNUWIxblY5YlhLT0FXTFAwOXN3OVpFU28x?=
 =?utf-8?B?U3BQbnVZeDBnWEQ4NXBSQzVBNEEyMmZFNHpRZy9IaVBlMUhhdnFzUkRiVUY1?=
 =?utf-8?B?UlJMazg1L3Q1WE5KVUJjVTBSUkRFRFBHcGV6NnJWeUg2WWtFMjFCUGgrT2lo?=
 =?utf-8?B?SjBOU2cwSFJlbjNvbjZ0TTdBOW1xUFBHL1YrU1MvN3o3eFVLazVKRGNyalNw?=
 =?utf-8?B?YWpicm92eTVpRzVvNGRuVm1tN1NxTVVhc1JobUJRWlc0V0Ryc3VLZW80cXpR?=
 =?utf-8?B?UHV4QTQrNzkxaGdiQkRMQnNnenV5U2h4bUdwZnpxcXlXb3BUNVpUWmg1bm85?=
 =?utf-8?B?WTFleWxodzVmTTAxcWlyTm5mWXliUGk1SGZ5MlVlSEM2eHh3RWxCUE8vSkp0?=
 =?utf-8?B?TEg2ZFU3bGlDNXdOa1pRTTFjT2IzUXZOUVVYSGZiZDY4d0k5RUhLd1BRcTBQ?=
 =?utf-8?B?T0ZiVUhjeWNwYi8zbDJRRkZqbndFRHJKZklnd0I2dzg3NXZRcmgxWFpzSjdM?=
 =?utf-8?B?VGlSTEFhb2xJTGdjUDRvOTRXeFV3aE5PWDNjdDlSRzlnTTd0aTYrUFN1QUw2?=
 =?utf-8?B?a3NMRUZZd0FIZ212cCtUcjgrK1MvYlRNRXJERmdvbkY3bzVqK1BTMGh3ZVNu?=
 =?utf-8?B?UXhlMXlwWWY1emFmSVZCL0pvN2N0ME13YU8yd0doWHE5aHNTeEY4VjBibDkx?=
 =?utf-8?Q?OYPJ08GX+9Q9yX/I=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZaFCx54VoaWx37lmBA5NhcUvHjftRHjJeHBj/ddJF515fk0XfYHiGMpRoorHqqB7hGTHqXsArPBFixS7urzrTg3LSdQJl6Bgkx2ma+ZO5yQehKjBkUUyTazzfPP2wVd4XGUb9gSPqo3bVRGRD2UmOgAkqh4/j00x+bsNNam4BF/5D+WMBDZ3aumwFRuQPbb8b+ZubQSFpA7Yvk6TPl6zYxOR1CjDA4rloHhj6fctrMRi4DGlUSiom7m4+C7eAXmH2Ql1sy8NJKrOSCINUZfkfcxqAttIQck1XtxjHQhfbzjGmFjYrFsp6+8omRixxDxT33sZgU1MORo9fJojqQCEytdPeNT1b5mTcMLaWtPfsQjR0ZzQCEBfQ3nJCR5ukj0oNLlsM+lIMNMwK1/YN1XDMgnFo4mRRIFJgGdBpuFZgodTceVCFXLp9kq9EmLTWtUvvzSitDR8GrmGHgZebq0YHBhmKw29Ame8CMp590MEY/ViqFAQsj+j5rXM/UjevM+hKZ2XpkWGf/wj7UqFevisifnQlVN6Q+iHfrsJod1n7t5F0YpU0vMviL2peIXFHo3eP76qzepZNHobkDxs/x8HY/0ZYvX28BRySX170VU/oFs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f2ba606-ecd6-4f49-0e69-08de529e9d68
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 12:23:53.5001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PdCT/qBNLm9acCyLDjaVFpS8Cv6rHZR4z62IRLYQnzfzL2YkSM6dRBlPCy9Z2M/Txz3zvqVXDe03A2faJ+5LGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6652
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-13_02,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601130105
X-Proofpoint-GUID: 0hQANdofwma3LFQ66sv94-Ic_OSVeihS
X-Authority-Analysis: v=2.4 cv=X7Bf6WTe c=1 sm=1 tr=0 ts=6966395f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=NEAV23lmAAAA:8 a=yPCof4ZbAAAA:8 a=VNJD47HD1grITCU9GscA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEzMDEwNSBTYWx0ZWRfX7e3w6xytaUVd
 s8hv9DCtexDkyjKa5vB/V3ley5SYuxFL7OUl3l5MvR3RX7D+oSAh3QTLWv4e6M8mDJqrzm6t+6P
 dpf1+zXsMzWdNOWXX/AS9WmbWqCCPyPSG+kLfSoTJ4yc5zKNfQGW4uOBLSdHbgV9LsAYcT/bbGZ
 97yYRzYsH6c3/fGNILHpVS2cO1UT+V1q8zIO0e8dlGpY44NTAQezNJy4OVn5Xb7rphotgORiWZJ
 +c2yR7zm1v7VwsRoSUUWBHE6Hv2z2ryafisckezj4Z7J9SSrPHyz8TA0MHr1qwicQ3o/FEUP1Fl
 5xZdR4kO+Pvw9ok/Iq7QkRJ8yYT2ARat6M5Jn4+z4M0IhCjDT+/lDjDPZa1tCnPd8IORyi0RWIP
 TvTxwEuDENe7KpD6EVqoCc7s1taq2UJHUhSHYw2YgWy/9PU5notkaV04u7QoAzaTFIZNcWgKNnQ
 OcqZ+HpOcIf0Wh9ugfg==
X-Proofpoint-ORIG-GUID: 0hQANdofwma3LFQ66sv94-Ic_OSVeihS



On 09/01/2026 23:17, Michael Roth wrote:
> This patchset is also available at:
> 
>    https://github.com/amdese/linux/commits/snp-certs-v7
> 
> and is based on top of kvm/next (0499add8efd7)
> 
> 
> Overview
> --------
> 
> The GHCB 2.0 specification defines 2 GHCB request types to allow SNP guests
> to send encrypted messages/requests to firmware: SNP Guest Requests and SNP
> Extended Guest Requests. These encrypted messages are used for things like
> servicing attestation requests issued by the guest. Implementing support for
> these is required to be fully GHCB-compliant.
> 

(...)

> 
> Changes since v6:
> 
>   * Incorporate documentation/comment suggestions from Sean, along with
>     additional clarity/grammar fixups.
>   * Don't define SNP_GUEST_VMM_ERR_GENERIC for general use within kernel,
>     instead limit it to a KVM-specific choice of value in lieu of any
>     formally-defined guest message return code for generic/undefined errors.
>   * switch struct kvm_exit_snp_req_certs to using a 'gpa' argument instead
>     of 'gfn' (Sean)
>   * rebase to kvm/next, re-test, and collect R-b/T-b's
> 

v7 also
Tested-by: Liam Merwick <liam.merwick@oracle.com>


(...)
> 
> ----------------------------------------------------------------
> Michael Roth (2):
>        KVM: Introduce KVM_EXIT_SNP_REQ_CERTS for SNP certificate-fetching
>        KVM: SEV: Add KVM_SEV_SNP_ENABLE_REQ_CERTS command
> 
>   Documentation/virt/kvm/api.rst                     | 44 ++++++++++++
>   .../virt/kvm/x86/amd-memory-encryption.rst         | 52 ++++++++++++++-
>   arch/x86/include/uapi/asm/kvm.h                    |  2 +
>   arch/x86/kvm/svm/sev.c                             | 78 ++++++++++++++++++++--
>   arch/x86/kvm/svm/svm.h                             |  1 +
>   include/uapi/linux/kvm.h                           |  9 +++
>   6 files changed, 179 insertions(+), 7 deletions(-)
> 
> 
> 


