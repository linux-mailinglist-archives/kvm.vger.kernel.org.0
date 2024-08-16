Return-Path: <kvm+bounces-24335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33EE8953ED1
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 03:15:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 81C56B23550
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 01:15:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DBAD15E88;
	Fri, 16 Aug 2024 01:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J3A0D98c"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA1A2904
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 01:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723770931; cv=fail; b=QEfjMyUKpH15t8cR9nXspfrkJ99N2GQcworgDXAJapKXdgyJTdhJ2dTZktwzT/M4/XSx1t2ZAvTKBMZzzJ3PPjsSukUXQu5lC017Uek31Q9Dfo/IW2AC3+so4rIo7t/0ev8BZNiyrGdWR1Z75uKH1sh4/DmZHoCExnERnyvKpmA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723770931; c=relaxed/simple;
	bh=bjIoONxz5Xy2CgazSbxIJtBw3ZxgqUnPARus0E7gZp4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GMOPkTMFbTawXt2tCpgH/96Wvn68oST0m2FIfe+OPZp9qj1r4USheLmWnGL6/WRBxtXrabQf/eqonnmVM64yJ7BjPwIMRZ0FMzBSedcGFySjORwkz3DripY6Qj3xHBypV96rypnQlINHhjbbidw79A/lGHKdbznS/BZ13rIIAVs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J3A0D98c; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723770929; x=1755306929;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bjIoONxz5Xy2CgazSbxIJtBw3ZxgqUnPARus0E7gZp4=;
  b=J3A0D98cnMrS5hZa654QnpDGI2q0iULtlbq1UV0YDoQGdLIIE1MoSONL
   tdS8W5soxQdaPF8i6igJ2yMzWh4NbcLmMtj/EMUobP1d+Lg+LedEIxFtS
   7JElu7oIlOUukPiqvvMZmT0b5ncAhChn1U0zApdQFKWcLetraH5VMKpBT
   JYCkgaEBmdsGi4YmT8p0dPjCV9YKcAuUtDUWsrTX3nafYlWe1fVBF580O
   40Q4SGmYUHxRJOmt5AIFajA0MiBMKeGl41bTxa2yi9SC8+A9At+2RaQH6
   SqLfoeT5z2fHaWWhk3caC7PumrAac2WMLS0IMFn9spSpsVW7TDzd8KRsO
   w==;
X-CSE-ConnectionGUID: l1fem1JTT6y5pBNxfujKNQ==
X-CSE-MsgGUID: 65HULD8CSnWRH1bN7tvN2Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11165"; a="47461271"
X-IronPort-AV: E=Sophos;i="6.10,150,1719903600"; 
   d="scan'208";a="47461271"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2024 18:15:22 -0700
X-CSE-ConnectionGUID: PHJV0tM4QsOKy1rQJK7XnQ==
X-CSE-MsgGUID: Macaye63SleZpUADKxa50A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,150,1719903600"; 
   d="scan'208";a="90299659"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Aug 2024 18:15:21 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 15 Aug 2024 18:15:21 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 15 Aug 2024 18:15:21 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 15 Aug 2024 18:15:21 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 15 Aug 2024 18:15:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xMrnfrk0RsiaqOZ1pmLFoAC81Vog5siynB7gUC/74ASu4bM7kdlDuKr3jgZX/J3LAkI60LY2wwPoG9ty6lsBzUQPIRhaEB+JkSEy2JCigJ+DAG47x83yyDaG2JCzyPE9IAilK7/JemErvrSJgzZeS4gBuWPUarFrzJDWuGPA8ByxiCrVqFtS/RdXpJsUdkqfogGICVKbqGEfXUnTyuaqFlEPOCj4c6qD/DYXFpJt3WqQw8Pj+/MAJxGD8W/pPZAC0U51ZyF30zMsx1vlN+99OOrO2bDsS6kjDiI5OWgdaSavGFDBeCrIKphfiJj5pYF93J77YPlFj3zcLxyc912h7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JqDrEIsPapDNyYvULxf1kaV9HUcXQcfHwRBlQaWLvRQ=;
 b=QDxCG1pAkNGHgY6qsrjM4lwQKSZPy20G1Ck8SkAjXqKAv6KXzMGOK4esCwAoTqtIk1N3uh1dQetGnyWaQUo3gBuN510aRDGnZycm6ewDlZLT8Xvcjyi43ohQ6FFdiYk+080MoBkkD9wB/s7u7A/ESevCTYWKLJPjgYbzY1iRg/MX1SrtfHeK6hlAamCphr6iabZwcv9MK2PfHeL5XDq4O2URjquneE+FNRx8XgjBytzlkzb/qqQqgXLUPKzKEHJVDXt9GXDIm/KzZ65KIYo9Fe2nF3rC8idRsdtmTKbifdtQckB/9qiGBhOrrK1+TDg46QKktcm8KaRgHY8e6mgZfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS0PR11MB8162.namprd11.prod.outlook.com (2603:10b6:8:166::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.18; Fri, 16 Aug
 2024 01:15:19 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%3]) with mapi id 15.20.7875.016; Fri, 16 Aug 2024
 01:15:19 +0000
Message-ID: <06f5fc87-b414-4266-a17a-cb2b86111e7a@intel.com>
Date: Fri, 16 Aug 2024 09:19:33 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] Make set_dev_pasid op supportting domain replacement
To: Vasant Hegde <vasant.hegde@amd.com>, <joro@8bytes.org>, <jgg@nvidia.com>,
	<kevin.tian@intel.com>, <baolu.lu@linux.intel.com>
CC: <alex.williamson@redhat.com>, <robin.murphy@arm.com>,
	<eric.auger@redhat.com>, <nicolinc@nvidia.com>, <kvm@vger.kernel.org>,
	<chao.p.peng@linux.intel.com>, <iommu@lists.linux.dev>
References: <20240628085538.47049-1-yi.l.liu@intel.com>
 <99f66c8d-57cf-4f0d-8545-b019dcf78a94@amd.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <99f66c8d-57cf-4f0d-8545-b019dcf78a94@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGBP274CA0020.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::32)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|DS0PR11MB8162:EE_
X-MS-Office365-Filtering-Correlation-Id: 1663f930-bbf8-43c8-d826-08dcbd90e492
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?U0t3REE0YjRCMnBvekNtMk9PN3hNNHFyVDJiZ3p2R3hZZm1oS0lYSzdGa2xT?=
 =?utf-8?B?UFFQek5RRTc3ZEdUV3pDb1FvRXpHR242Tno2ckFkSDdjSXB0cjhqYkRSVDJ4?=
 =?utf-8?B?TUp0bzNpbmZPaWJlb3RUNC9CdUlhSlJnNGRmTFdDZHBGZFFzTkZsemZ2Q2NV?=
 =?utf-8?B?ZmF0VXNhQkM0aFdrQnBxa3VLRzdnbDVGME1GRGZDNjNZdU1WRG81Mm45NVEz?=
 =?utf-8?B?WmowUzhIYjBmTmRhKzBtMmhQaUtRYmZKdEcxMHRiczJ2bGRiRm9OYUdDSWpF?=
 =?utf-8?B?Y1BrZGd4OWVMYVkySFJJSFhtak13UWxYN2U5UGJ1UFhHV2VEQmIrVDNDZnhX?=
 =?utf-8?B?clAvNFRUb1Y4WW5mbkw1eUs5RVJNMFNxbFk3eFQ3ZnFDa2VTb0VRaDRXcWJN?=
 =?utf-8?B?a0NTZHhyS2ZYY1d0TUNSN0tkR1FjY1lOK0FqM25ZSXYyb1lVMG5LNWw0U0xK?=
 =?utf-8?B?d1AyMks4VmJTZS82QlpPazhVVTBjZDJoVUZYWTlNU3pKN2grVEc2b1l4S1Bl?=
 =?utf-8?B?UWpUaVNDZVpCQkFSYkwzYVZ4Zk05cWxFUEs2RzJ6RHZ4RTNIQk5KOE9tSGNN?=
 =?utf-8?B?L2FWeHF2UzZ2OUdXK3JlbTRRNEh6Ym1lbjAvVHlGZmRzeHpuK0ROb0hVd1g5?=
 =?utf-8?B?OFFIT1ZTcTFSRlo0aW5zYTBGK04yekRVdzNzZXA5WVVzK0d5cFY5M3ZGQUlo?=
 =?utf-8?B?V3lCeFJpNnJGRXhEcGNieDJlZWJGQjdTSUd5dENBNHVvYVRweGZpTy9Wc2xh?=
 =?utf-8?B?SlFkQlo5dXlqOTBCZnU3clRtS25PK1NuSUpKUlpOeG56ZUlOanpSa0sxVVR5?=
 =?utf-8?B?QUF3aExyV2tIeW5uRjlOQWo1a0hYL3JncVExWHZ2ZnlDQjk2bTZvbFpmU0Qx?=
 =?utf-8?B?Ty94ZStvZ2RyZWtQa1dFZjlia3psOTlwV1JIUW85elplRk1qN0RLQ1RvL1lV?=
 =?utf-8?B?dG51ZG5xZE9CYUVpZDVIb0xQajZtZERJY2Z4eGFFZFVwWldIM3ZSaTZoTDhU?=
 =?utf-8?B?ZEUxZmxqYzMvRlVEaVNlNU8wcGJ1ZzJMS0xZdERNWjh0bDhMSlFPbjlCTW1Q?=
 =?utf-8?B?Yk4xSFN3UUlHK0dmZkxWYXlyblJldmVDM3gxdnJQMDlic1hSQWcxNzRrV2wx?=
 =?utf-8?B?RkRybzZtK3NneVF2VXpyVUtCZHZsTUpkODh4ZkJJN2k1L3NMWW5zUlNBcG9Q?=
 =?utf-8?B?K0dhb2NwVUZuR2xPOWVkcWM2dUpxNGMyZUMxaEdzZVM2bWsxd2dJTGlwVWU2?=
 =?utf-8?B?YndNdHh4YVVOUkNEOVdWckFQVWJxeWtuUWkxY1AxblpoaHpjV0cyT3JQNkcy?=
 =?utf-8?B?bWV0SUgzQWRzb1Bmd2Q4KzJCa2pQdDVRazJqQVZyWjVIUHZoL3JrSUFaUUJK?=
 =?utf-8?B?eUw0L3BGalkwb3JSUzZKZ2xKcHBDS0FicUkyWlVGcXIzVkJVRWYxZkd4eC9E?=
 =?utf-8?B?d2ozM2t4bDBSN0RWZTZiTlpLL3hLM3gvUEUrazhLelZESm5wT1BicURPMVkx?=
 =?utf-8?B?R3pBTE9EcU1rOFh2eGJGMWFNK056MUZ6VG1SUmdzK3d3TDBqVk9ERDY3NmpR?=
 =?utf-8?B?VmZYenhtYzROcTJJUDFWdWY3c2N0QU9scEU5RkVvMTdMczlERU1HTGp1Y3h3?=
 =?utf-8?B?bkN1RE9Ud1pvK2FLTnNZQnpVY1E3b2lCZlRobklWV1B6VUF6ZVFFQUhZcGpI?=
 =?utf-8?B?Q1JMN0d5VFE2amVRTk10akZUVWV4czBEM0MvSy9vNjFBUGJnOEpHY3ZSWDFZ?=
 =?utf-8?B?KzVLSnd4N0owbnVXakdLTzdmakJSRm9TekZpbjI2ekpQVGRuQUsrVEZKdUNX?=
 =?utf-8?B?RmJ6WXVDNGdSM2J3RVhTUT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?emJOUFkwY0IxK2NDRGg0Z0MzSDBOYUFIK2c0a1VQU1EwamlBK0hKY2NsV3FO?=
 =?utf-8?B?dWNaWGswbFcxVjV4ajFBY0NGZ2haK1FKOVlRTTQrcGFIc2RMcWpKamhuK3cx?=
 =?utf-8?B?QUZhY3VmTGpsV1AzdjV0d21qOERPNG90R0c2N3lLKzNkYmRZeU5SSWw5YVhR?=
 =?utf-8?B?N21JbFVTeXFTME1NSjVBeFVoL3hHUGtVS010a25yTFFieUNqOC9JYmVZTXY1?=
 =?utf-8?B?Qm1LeXk5WE5YeUZGUUhBRWh5M1NENngvS0MraUtwczRRaHBwOUkvdzZxam1h?=
 =?utf-8?B?dUxQZ0J2WTcyTFJSazZaY1ZvZ0xQdW5zeWJqSVc4S3BCQVlCZXIrVXJpZWpK?=
 =?utf-8?B?M0d6M3BTOEVSblRuMUhzTlRHRlhOcEY4MlRRbWNpT2NjQVdjTHlFZFhIMHJK?=
 =?utf-8?B?anAwSEtKZUNvRUY2OUdYUytFV092bXVFTWhSb044aCtueTd2RjhwOTZib1Zu?=
 =?utf-8?B?ZnhTWXJ4cGVSdmV3RjVBcmlEMERJRVlLUGRnN3RaRFdXb2lhZWl2dVRIVm1p?=
 =?utf-8?B?V1VQVmk2eURPcTdWb3BEYnIxM2NDQlVUa29VRm9HTzMyUThSazBQY0dNZVdp?=
 =?utf-8?B?TlNPK0w2cVdwT3pncGY4SGhhQ0VtRE1wNFVERXVPTk9LZ0E0MVV5SFFrL05D?=
 =?utf-8?B?OFpUZEZNQlA2OU4vK3EwVnYrQjE4Q3ltR2hmaVBUZjg2eEhma3Y1TU5Qa0RM?=
 =?utf-8?B?L2RPZ01RalQvTUV3aHdQUGIzcmwzU0htV1VMUHk5YUhXMmJVSkpJNTZlQ284?=
 =?utf-8?B?eTViVHdpcUJPc2ZjSXovcW5ia1J4VjYwbUgvenRTOTlNLzQwK3FjTGZGTXly?=
 =?utf-8?B?bmZSNllMdk5zelo2YVBMWmJULytlYVM5NXNNc3pnRUlFaGRzUEtCZFJOYmpr?=
 =?utf-8?B?NzVWMWNhMVBodFlVejZZRTJQd1hUNVVJQkgrSHNEeWxWREhYOWlsYzNYTWMv?=
 =?utf-8?B?ZGtWdGR5RlVQSlpTUE1sN3ZHeHlTM1NiZ2YzYW1xTktpYmYzN3FKNG9zQUwx?=
 =?utf-8?B?cGNLTzdtL1hxYlk2ZDk0NEk1YUFkbndSL2xMejZFb0F6RlJjUmtKbXN4M29S?=
 =?utf-8?B?VVpqNWJrME5MdDlqTS9TMlR0aklDUlJJUGs0RjJLWEtodk9BeHhSSkNwcy8r?=
 =?utf-8?B?T2RWelVJVDNzeHRLakpzMkc0dTRLWU5pbGRUNjVCZWg1ZGhYNVNzRm5mUmZw?=
 =?utf-8?B?M0dhNDZobDNFMnp0UFN1UVJjVDlobkcxdkFwNy9XZU4xRmU0OTU4Ly9WdFBC?=
 =?utf-8?B?TWN6M0NYajh2bGJZSjZvRHpyeExCUmZkMXkwK0trb0tOMmkrSG90cmp3VkVx?=
 =?utf-8?B?NWJRQTdGMUVwVGQ0ZzZ5dFN0bnZ6MjN3WDlobWl6K2tLVUpXdzNzdEtORFow?=
 =?utf-8?B?Tm03dW1mVmk4QUtVRlFaRkpyM24wM3h4UUtZYmR3cGk3UGJVUjQyNHlkR1Ur?=
 =?utf-8?B?aEc2eHBEb3ZoR3hOM0RiTUNIdUVzdHJ0U2FLazduMktVaDJuR1RNblVmVGtN?=
 =?utf-8?B?WVZtZ3B5T1lxUkQ3QzVaMTl2N3gzMzBJYmpjNlA2ZVpmdWRUa2svcjdSeUtq?=
 =?utf-8?B?cEtLdWdsZSsweVNpVmY3YTJpZkxqa1BCdGR2V0hTMy8xZDk4OXl0dkd3emto?=
 =?utf-8?B?cE1DTHNvenIxMW5ua0NyQnd2NzcvMWlOZG40TjBaTUZYbkkrVTNnbXV2RENE?=
 =?utf-8?B?eEFmSFdhd3grRmQ1UllIQnQwSmFXbkpaY1J2Wnk3YVZMRjZ3UG9sRjNzL2VY?=
 =?utf-8?B?OVY0VHlZVFVtU0FkM3hZV2o2UGkzMUdYUEJRN2NjQnNZRWlWRUhxaFI4LzFv?=
 =?utf-8?B?eXhwZXhoSEFhdjdtVmkvMVJTNHFoRk5uWVdWV2pSdzExSVFMWjU2QUpJOVZn?=
 =?utf-8?B?SFJRMVduTFA5ajQ1Ymlsb2l2cmRCS1FhZFNMbU5qMEJhN0NRQVZ3ZG1qcnU0?=
 =?utf-8?B?cFY2bmJlTlpnaVpUVzdodGZhOWRzVk94NStyaVhSY25aT1hRV01QMndrMHJV?=
 =?utf-8?B?UWVvN1h5dCs4bW5BWm1ibHFOZnZrR1B6MEg4NEVlNys4Y3hYSGlDRUFCRTA0?=
 =?utf-8?B?Rk5BRFY1Y054cE5kcFpieUx2aThUcFFQc0dkT3I5SWpuLzFPaXJBOW1hSk40?=
 =?utf-8?Q?74ICc9SaT4cWSPybL5mh3bhGg?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1663f930-bbf8-43c8-d826-08dcbd90e492
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2024 01:15:19.1152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JThyz2Rg8joLxTYuE04uDDe5TxbLF5IcV+zIds3lGlXJAyD29x1Jqg7+HPIbUNikLFjN97Mx0FAwC7GKRrYXgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8162
X-OriginatorOrg: intel.com

On 2024/8/16 01:49, Vasant Hegde wrote:
> Hi All,
> 
> On 6/28/2024 2:25 PM, Yi Liu wrote:
>> This splits the preparation works of the iommu and the Intel iommu driver
>> out from the iommufd pasid attach/replace series. [1]
>>
>> To support domain replacement, the definition of the set_dev_pasid op
>> needs to be enhanced. Meanwhile, the existing set_dev_pasid callbacks
>> should be extended as well to suit the new definition.
> 
> IIUC this will remove PASID from old SVA domain and attaches to new SVA domain.
> (basically attaching same dev/PASID to different process). Is that the correct?

In brief, yes. But it's not only for SVA domain. Remember that SIOVr1
extends the usage of PASID. At least on Intel side, a PASID may be
attached to paging domains.

> So the expectation is replace existing PASID from PASID table only if old_domain
> is passed. Otherwise sev_dev_pasid() should throw an error right?
> 

yes. If no old_domain passed in, then it is just a normal attachment. As
you are working on AMD iommu, it would be great if you can have a patch to
make the AMD set_dev_pasid() op suit this expectation. Then it can be
incorporated in this series. :)

-- 
Regards,
Yi Liu

