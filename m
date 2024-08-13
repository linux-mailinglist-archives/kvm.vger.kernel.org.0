Return-Path: <kvm+bounces-23926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A2F394FC08
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 04:56:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 404142831A9
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 02:56:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4E4D1A277;
	Tue, 13 Aug 2024 02:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BHNBjEJg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2188F14A96;
	Tue, 13 Aug 2024 02:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723517800; cv=fail; b=EeT/73HbZYeIfkukQ+tCCNUAWJQuacuy5NBGqaK3HhukFm13u39U1k8OEXJsBB7O4EXlfR8CCgOz6HChqzn3BSXS0L57fMrTrgx5GXrbDMcpuxXS1/fqchILev6oHgTw8GkhcEanrS/zmqUEqlrFf9Ll33gXFSYrPj8iuSr+1zs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723517800; c=relaxed/simple;
	bh=UTjJNkznowLsc7Umy9GZnfwBSD1nb51ZQRUpos7Fmy4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iiI/N2a+eBx8u4MGj12fKinRgGoMV8CCIoUiLW+LQ7dGfQgttOV7TxTDbE521MeNmAOys9NWPYDP60UGy/r22q9TWBuvOh7v25qq0EnK74CBhYSp9KlPpM/Sm/7vjdP3twiYkSyYm21UA0yKQTRpHndu68j2vG+9/MX9ZVCWLdU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BHNBjEJg; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723517798; x=1755053798;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UTjJNkznowLsc7Umy9GZnfwBSD1nb51ZQRUpos7Fmy4=;
  b=BHNBjEJgueXp1lBd8S4V5k6JkciS/RfUbW1U42MkH/30Xaq68nw7FzFU
   IQplA97bhUOS9VSiUf4strM+iU4X4F1YR69ytMkBTGvuk1qsKRNKXc6rl
   mT0V+K81ZOHKFXc2McMccMmCcRrQUjv+fmO1G2y+qnGw+uyY2eUVJTjsE
   tGzzfxmBG30Q4KPfyFwUEKlF1e1SS7UpA3KcBUXocIVwbCluHwa6aP7Mw
   PBG3afi+lOHr/2VKCKZCGloAPeqPCEM/+Tu/lDCeF/xx/2hvyOJpc1StY
   WGIK9l1cU6q6+GbeXAfGJNDcziiGC5HaCl+6reTai2/iHqkuSEDD21ueF
   A==;
X-CSE-ConnectionGUID: 1b0Lu/4kSNWYA4eT7jnaqg==
X-CSE-MsgGUID: vHrBlCXkROWqrdP0J3ZtbA==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="21218873"
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="21218873"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 19:56:35 -0700
X-CSE-ConnectionGUID: iiaLH/UsTZyMrN6/vE82PA==
X-CSE-MsgGUID: Hu3jrnOUQfC9ZnxmF92Fmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="59255898"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Aug 2024 19:56:34 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 12 Aug 2024 19:56:33 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 12 Aug 2024 19:56:33 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 12 Aug 2024 19:56:33 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 12 Aug 2024 19:56:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eDihqw9mSPrqE3OckF6XwZbEYSTOpQgT/Hf38EkgJsmmWZqHHQ71gOgrzE9oZdrEKMpagoLJ+akAPkDFTQf0vaomj3CQvFyuwnOVhopDS6ge58dYyKqz4GaKRJ37Z0mEQKcudNcA+SJu82s7Wh47Cqt5caGnjWnx1B5twLeutZGC+YK4xDZQzgKnU8GbJEsZHPaC8HAsGo15nVG1F+1Ma5QdKLPwxmCi1fAxvDotWxLI4v6REKnW6jNBlmkw1Zut8ZMn8D+sr/GbTGMeO4B91hYM90FHlQZ51oOZRGaQ+YjUWm8FkRrjfNDOQokzFYXuRVsI6KZS6wf1qS0SQDplTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zkHI70nbNbyTdN9bXqyo4v/CKoFxlSq2XfL0V5qeLpc=;
 b=T2zJUNiyy+UccnNZkwm7WpA0vPRxCdKReYmqxMZRatipg/69lIOl4c6IbWyDOVhyM/uqEt019p3TZJHW6RdultXJVU9cV73j4MGwR4zzogNlF3UqNJcQrXDJWQSOLerg0QPpsHQulgTCB+jTiCCBjbXWZ3BHgrExznG+78WLNXVXniJzi0zupBhzpp77oUCz7+GwTpG5HeZqGAMGy8qh2ml0KgAOiYCgFUxRmxjnfob1QmLzusS2m/uwSwWwyAm3g3urFUwuBOzW/UGYyswqpyyGMJtu9u0sj5RUp6Ot7qqBGlXPDrnEHYQ/0KVqPdMVSkB94W5zYdF5GN0E2okEOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CY8PR11MB7083.namprd11.prod.outlook.com (2603:10b6:930:51::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.31; Tue, 13 Aug
 2024 02:56:31 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%3]) with mapi id 15.20.7828.030; Tue, 13 Aug 2024
 02:56:30 +0000
Message-ID: <77197bcb-574e-4f46-87b5-1b1fe4a75e7f@intel.com>
Date: Tue, 13 Aug 2024 11:00:43 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iommu: Allow ATS to work on VFs when the PF uses IDENTITY
To: Jason Gunthorpe <jgg@nvidia.com>
CC: "Tian, Kevin" <kevin.tian@intel.com>, Lu Baolu <baolu.lu@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>, David Woodhouse <dwmw2@infradead.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, Joerg Roedel
	<joro@8bytes.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, Robin Murphy <robin.murphy@arm.com>, "Suravee
 Suthikulpanit" <suravee.suthikulpanit@amd.com>, Will Deacon
	<will@kernel.org>, "patches@lists.linux.dev" <patches@lists.linux.dev>
References: <0-v1-0fb4d2ab6770+7e706-ats_vf_jgg@nvidia.com>
 <BN9PR11MB52762296EEA7F307A48591518CBA2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240809132845.GG8378@nvidia.com>
 <880c1858-afee-4c30-aac5-5da2925aaf11@intel.com>
 <20240812113555.GP8378@nvidia.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20240812113555.GP8378@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0029.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::20) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CY8PR11MB7083:EE_
X-MS-Office365-Filtering-Correlation-Id: 857e391f-3e6c-49b4-34c0-08dcbb438860
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RG45bTcwUlNWWjlodUNBSTdWN0UzQ2o0dTRoQ2N2TzZuZGxkWEhIb0xnRDN6?=
 =?utf-8?B?UmZOd3U5aDV6RnZSTFhwUVdmalg2aWh0MGJMY3VjWkhJbnhhM0lvYXdkWlpI?=
 =?utf-8?B?QTd1UGdrc0RNTld6TmpRUzQ1VzcyRFZyTjF6ekcrd0tic2VrL1dtNmZsbkF0?=
 =?utf-8?B?bUV3d2ZYaXltdVp0TXlacUIxMUgrKzhNakhMN2dqVVFvMS9td1NHczRFY1I0?=
 =?utf-8?B?Z054bitEQ1JZVk5vWjRudVJSRmdKMUZ5azlFVWNzTEE4emRRU1h1TWh1Ylhx?=
 =?utf-8?B?elBNbVVjVmFPcXVvc1Ivd2ROYzd3aVRyZHBTOG1XRXlYeGFnM083bEZhd2po?=
 =?utf-8?B?bFdlcTNBbHNoNjNMWEdmOGhCSFlnQVhaWjBPMHJVTU1nc1VrTzVsaVBOOVg0?=
 =?utf-8?B?clk2c1dDSnV1QmJ0K2MzcEYxcWk5TjNqNFFhREN3ejdzSzJ3dm1kQUZ1WEQz?=
 =?utf-8?B?THRnUTk3bkRIeG5nOC9pVis2OEQyU1Jaa3JCZlhWUEhHZS9qZlEwT2VZT0lH?=
 =?utf-8?B?ZmRJZ1hMQmpHSzZsRzE4NjFaeFRmeGJaSFB2OWgvTXRHMy9CV3FiV21aWXhj?=
 =?utf-8?B?SWExaGV1UVEyNlpHVGVFeWdSL3VJaFhoWE1qMjJKTkJZK002OHMzWVZwUTRk?=
 =?utf-8?B?ZTVwZFRwMngxQkluMld4V2ZXbTErN1h4cXRLRE45R3FTTDdBU3dEZWNLVGZZ?=
 =?utf-8?B?L0U2Z3ZFVEhJZEVLeVVSSkY1OXo3aEtSUXJQeE1zQWVVUjA2R0FRNFFNcHhN?=
 =?utf-8?B?b0pPa3dGd1lWZ3N5YTEyUDRyckVtVzBLbnFjQ3liVktYaTNHVG5RRUhTcXpw?=
 =?utf-8?B?dVAxM0Z3QlRPYUk5K2Yrd2F4RTBWdUJpcUI0T21lREhJcCs3Y0ViaDBvRjRh?=
 =?utf-8?B?alkrYkxaUHVCVVQyVHB2MzAyTmZmSm9RUkZsQUNnMk5tZENPVUY2S21aN2dJ?=
 =?utf-8?B?WDBEUFhkMy9xbHdoZEFDMU9zUHY2KzBqaTZoUkRKbDlMaDJzZmpBVDFORW54?=
 =?utf-8?B?M3kwdWdSQURidTdsNkYwSlZNK09Ib1RkR3EvYldWZE1Mc1pDOXcrZTRUcHE5?=
 =?utf-8?B?UUpMYlN0Q3Bnc3krVjN4aVhaaFV0RmxhWnlyazlMT2JpMmFraUJNdXJXOVpR?=
 =?utf-8?B?ZDFuS0RRUUxsemY0QWg4UmVFQXUxb1ljaVNKM2NCdVFra0p0TlZESUhiNXV0?=
 =?utf-8?B?TG0zaWc1RkNvdFNFUHRUYVNhR2JVOVQ2MU5FVDBSRUdMOHZ1bTd6cnJqVFdJ?=
 =?utf-8?B?NENhZ0txRllxRyt6eG5LR3hBa0hMZHFyaHhqaEhRRFk2dEF5MWx1RHY0ZDln?=
 =?utf-8?B?V0hTYkRYbFAwZVh1RkFEdjJxZnZpdnVwMkIzVzcwRFN3enJtZWRqL1hma2Iz?=
 =?utf-8?B?SnI5bExRWGlZYmxnb3p5QzFYU0tiSmtMbzlnajN4WDl5OHU4N0wydDRKNGpo?=
 =?utf-8?B?eGlMV3BPanBreEJtSEJRSFFMZ0hadlZFUGdabkRRVWxCVkNka3A5VG83bURK?=
 =?utf-8?B?aHB1R0YwYW1SWFZ4aTNrSVBvdFhsNWZkOEpaOTIxenljRldmSVVJQzNHNXhs?=
 =?utf-8?B?ZGJXMVVzVzB5aFRLc3hNd3N3NnRWNjJhS2hneGhwenp0cjZOMW4wWjBJdzRO?=
 =?utf-8?B?Z2xndnpLeXF5aE9nS2hhaU9jK1VpNUdPSXY3YUNSSzVlOEdMN09ScHhqOVlG?=
 =?utf-8?B?akhsdXphdHN5aGp2c2ZVR0dzV3F1ZkpUVGlPMlZoTWZ1MnBITzc4VTJrQ1M3?=
 =?utf-8?B?RjdpcEpkWWtpdDFLMnFJekV1cWZkTkhDSmdyREdNbm9ySUVIZmhuVGN2RTFG?=
 =?utf-8?B?Mk01V3FLM1NyT09VRHNudz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WTQ5QTRESGJkUEJmVWJaSkFsZWl6cmNuTEd2a0dRZlFnWjliWUY3RTdRdnhI?=
 =?utf-8?B?SG14U3I2ZVJWdlhKZ01xcDZHWnNrRENuTXFLZm92c011Yk5NeXV0dXlrSEIv?=
 =?utf-8?B?NDUreC9qUUVlV1dBNFVQeTZQcUVVNXhwb2pYOGlPVFJqYXZXMHlISDlMMXZS?=
 =?utf-8?B?a0szY1ZrUWxCcXFZdVNyYzRrVndzN0RmWkkvMUdCeDh6ZzA5VThyOXNOM2xF?=
 =?utf-8?B?ZE9JR0pDZDZLd3cyR2NtYzFDYnV1OFFSbGpLMVhoVWg5R3NSWGVjRHJJY0dS?=
 =?utf-8?B?V0VEWHRZdkF6VERCQnA1YnhNc0J4eldteEVrbmYzRWM2WmtRNFlNMmFldFpj?=
 =?utf-8?B?UW82WW9MZjFjVU5JWmlCQnY4ZVdpMFRiV3J4ajE3bzJramN3UWt1cnhMYk55?=
 =?utf-8?B?YkFRb0dBNktTVmJQV2VUbTlqOWtjTTZ3Sm9TTTR3NnBUcW9nckhXU25RRXZl?=
 =?utf-8?B?KzNxczBpaVcxd0IrRVFnYmVzRUZWNVBPMnVYTkhwUjltbldxL2dQWEtFUlRT?=
 =?utf-8?B?czdRaHFtYWZDNG1BdEZBL21yVTFkT3BudHpZTjR5L09aQmZlT1FvWEFqem5m?=
 =?utf-8?B?dm12RVhRZlNUZU5NdnFCVHRLQjl2OWRKZE1iQVlBYXZ5SGtMVWRENnJFWkdH?=
 =?utf-8?B?N2VOWldzWGtFM011MElNREc5dlQzWkpROGUrTkZxcStGUmpkcTVvdW9jUGk0?=
 =?utf-8?B?eXN6SnV2Zng3emJubFZpQzUzV3kvekhyeldtZDhKbHhad2NselRuUXJxMmVK?=
 =?utf-8?B?OGtqMXFCRkhGc3F6TDJ1VDF4Mmdkd29laldGaWNxYUo5VjVGYVVBaXVwT2Jl?=
 =?utf-8?B?QUJTTjhtc2lzVXlLbzdwR1NZZTdNNnZHU0NhWHVUeEFtMHNJWW5vZTFyMXRK?=
 =?utf-8?B?MDBjMHo2ZXlFeVViWEJRNU4wV1RYYzdNSUprS00wWkswbEUwcEZNRmNLd3hW?=
 =?utf-8?B?TjlEWTdiVGpFS2x3NHZ6YkN5UkFjWkwxVDFKQjlaUDhQTmFNVU8rcmlkNXlG?=
 =?utf-8?B?L2xtekxibjh4Z2NmcFQ1bjFJbUpoeTlpVmR3RU8vK1hIOEhmVThqL2lvZFJC?=
 =?utf-8?B?STFLWEIzVFBBd1oyS2ZNUUF2YTV4amFRNlNpUitld3ZCdm5aNC9CNTAvUnNp?=
 =?utf-8?B?OXRHdURucE44aG1raytWVXdsNmYrQS9SSnJBQk82M2Q2VHRGOW5kRkhwajU0?=
 =?utf-8?B?Q1VTUHBUTFU4TFI2WXFGUGpEUnJYMWVkSzBtMUhjU0t5YzdCeHpUZ2p1bEd0?=
 =?utf-8?B?ZDNlUXhNUGtlaERGZ0hjN0NjN2tYNW1QamM3Z0ZUOGlZRndmSkRvRml6T2tH?=
 =?utf-8?B?K3ZuTVZ2ckdvTjJMeFJzcklwaDJKWlh1UUx5MHFiRVB4b3hZRWJYMUlKTWlR?=
 =?utf-8?B?TkQ2cWhXay9PbUtEQWtEdURpbkRmTmphOG1IQ0cydS9Nc3lnQWtQU1ZzN2JN?=
 =?utf-8?B?WDdBUU5neW1zdHNwN0RQYzlUVmtyS3JyaGZFN1IrUUx6YTR6Q09SSGNaeExW?=
 =?utf-8?B?Y3c2V3B3NGRBNXdmTjZWZkh6aTFwbHJlNTVuZVBYY0t2RGpwTzRiRTJReXRM?=
 =?utf-8?B?S0RSK05yNm01VC9LQVQxbGYzWnIxNFBNeWxVeW5BeUhKZ1ozMEpSVVZ0ZHI0?=
 =?utf-8?B?NHk3M0JPZnF4WUlTZzVQYU15d2hXK2dCUWk3aEVHRDYvN0lKbll2ZlFDMGd4?=
 =?utf-8?B?QnRHKzUxK1FrdnZtc3l6SmRlYWxYbmNKL1o4aU00a2poUXMvYVhDMWxIUFI3?=
 =?utf-8?B?bDVEME5KRXZ2bEdDUWdSVWh2WGtvSzJTUzZDRzlKc0hyZnNOR0lpT3RhaThu?=
 =?utf-8?B?amhhTDdBWVp6dTJ2ZnN5dWk1QUFLU01seFIxbnk5ZlI1R01SeWZyQzIxNmdq?=
 =?utf-8?B?eTAxYkFOeG00Y2dMdU5BNXJmbU82aDdsc1FwM1I4cmYzNko0Q29BYjV4b0Zw?=
 =?utf-8?B?OVFja3BMeE82c2p0Y0JtQTlLTkxEM3o4NWgwbDU5NkoxV3ZJdzc5TGd6UGo1?=
 =?utf-8?B?a1B5QllBTnhBRm8wditSVVJpbjBvbFN5bUYzN0hmdS9kc0JlWkEzZkwrQmZI?=
 =?utf-8?B?a093cmJYK1RoOGRJUytVcGpTbklTRTdwYlVJNUlIbE42UG5nRlFWQ3V3ZW92?=
 =?utf-8?Q?NP58YsXXvrP2J7NbIUFS4NYFe?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 857e391f-3e6c-49b4-34c0-08dcbb438860
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2024 02:56:30.7993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Yvnpvo2jPg2OJiWmJWjz87R8kQ/TyFT0jyC+MKolSUSQAf9Ok+GoHRM9YFP8YuA5vVLmgLy51/i3nFq2IEeEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7083
X-OriginatorOrg: intel.com

On 2024/8/12 19:35, Jason Gunthorpe wrote:
> On Mon, Aug 12, 2024 at 05:03:37PM +0800, Yi Liu wrote:
> 
>>> The PASID may require ATS to be enabled (ie SVA), but the RID may be
>>> IDENTITY for performance. The poor device has no idea it is not
>>> allowed to use ATS on the RID side :(
>>
>> If this is the only problematic case, the intel iommu driver in this
>> patch could check the scalable mode before enabling ATS in the
>> probe_device() op. In this way, the legacy mode iommu would keep the old
>> ATS enable policy.
> 
> At some point we will need to address this.. At least when we add
> PASID support to mlx5 it will need something since mlx5 is using ATS
> on the RID right now.
> 
> Supporting ATS with the IDENTITY optimization is a good idea in the
> IOMMU HW. The HW just has to answer the ATS with a 1:1 TA.

looks like Intel scalable mode would allow ATS work even device uses
IDENTITY. Below is what spec says when PGTT is PT.

Chapter 9.6:
Untranslated/Translation Requests (with or without PASID) referencing this
scalable-mode PASID Table Entry bypass address translation and are
processed as pass-through.

> Next, telling the driver that ATS is enabled but doesn't work on the
> RID would allow the driver to deal with it
> 
> Finally, doing things like using IDENTITY through a paging domain
> would be a last resort for troubled devices.

yep. It's another issue then.

-- 
Regards,
Yi Liu

