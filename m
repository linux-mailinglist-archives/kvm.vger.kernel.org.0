Return-Path: <kvm+bounces-30897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EEF19BE333
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 10:54:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EC39AB2223B
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 09:54:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 447B91DE3A2;
	Wed,  6 Nov 2024 09:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ixwsBWAB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F4F1DE2CC
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 09:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730886775; cv=fail; b=rTXIo3vlzPcVMTr+c7HhZvq8P+hsj4POsHvaKqVMZEPYSbTeLkI/13Iw8BGqYy9XEpFPFCQOH8lfktVSjD7zZrMB+YYuw6uYnB0ubCRcTiqPS1VMWtNYGPgqByJ0ojl19QScHuvcia8TDWpJWuele4TiIF8P+w69P8PgNpYIEF0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730886775; c=relaxed/simple;
	bh=dFVUhnH/cIxawCiCFyBiu/zerSRzquVQB/cVqwnZUBI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=G8KN65AeQyKM5rS6g4o7tEGUCNwEdMTWhhFuDjN7I1DtxaFZxnSSFlCiWmopc7hrdmFJj2DivqrRhn6dfhGB5wJbbZblkuyuHqw+UfkyvSBEwY2OGyooMs9OfNCfDMCThuer4U+OoJlfNEvoDQNfGqdE5DcV/azHbJMGiLgdkOM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ixwsBWAB; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730886774; x=1762422774;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dFVUhnH/cIxawCiCFyBiu/zerSRzquVQB/cVqwnZUBI=;
  b=ixwsBWABlRzHLkNc8hgFEjvKY+1+YAQ8P1079UcrPTKxeYDKeT7nLd2r
   LY93wU2Lyf7At9GLE8ehPFVxKeLOOrBAif+c0y/ruFVzDCfoo5gMAlF98
   mOxLeaFiAAo17jncifVmsUT4KXfJ9PuWVOGjuDAi1KUNmvbVuWgwJ2yGr
   Yj7AjCI+lHT9up8A/JgIzyLmpsN3bTxgTjO+8qHd6NhAFYXyuiU/Usw5E
   7lB/1sEFL7oCIjVzjBWgC1jJh5lxik2MLgSs1muteR3u2U7r2C+MfyeNx
   H3KDJ4MbcIMlfL9WABjL7OpL3FNcnoMb7szZ6b1jA5BFE5qS44u+NoGpm
   A==;
X-CSE-ConnectionGUID: hGqWkpirQaODA0SMCt9tBw==
X-CSE-MsgGUID: v8fIklgHQXif7W1e8k9VAg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30856504"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30856504"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 01:52:53 -0800
X-CSE-ConnectionGUID: BLDHmwg8S4ast5c1y2fS4A==
X-CSE-MsgGUID: 6i79mGhOQhKeRhucAiD0HA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="84590796"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Nov 2024 01:52:14 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 6 Nov 2024 01:52:13 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 6 Nov 2024 01:52:13 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 6 Nov 2024 01:52:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yHjEof3G5kHAokc5m221SWFB3UI9BUlxTkftByeyoOHUdGsMU9BZzI6/Iz9VRv6FE8JtTJGLOhSIxLG8SYcpZosB8JCdfQD9lXV7Rvt4WFYI56FcBuKMLNStzF8d+xS1wNVH8kdNfV9oPRHdbYvhy2b9J2iAmid54tLqqSq59Bn2YbopDhtS9EwifrIwFzSlMhqTO23QAK1EabY/+Vj+obEkThu7s8vDCvL3DWWV93J3WRpjyDyB41wIilLkZMUF1GR1eQd7aU9yQRw8GU0E6kG1h3+K/pVJI9gKRBmiJlBoW1ASvg1I5eAmD6MNipkZ0u0t3Ivwtd54yUWKjDclAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zJ3AIqU70MMlEmWrWz0HPr7L5eTCRXffmxzrzrnFApA=;
 b=usCO7jwRbLIz0WYDnZy1RSLogmUJOg7g8a4OAqGb5dM7zSqfwsJgdOP5wqDv37f1MCOfQPKPbQKOtHvTFdr83+UMJRJjsVXYViI32EykdQZwV+Jp94bBzxM4EcHSDfgZzWrhzK78IIsVm6QWISltIK7+oE9VeVJBJrBZPTrCnqqmfvLuhzhQkwhiJXVnRq33iNKQSGo8kBw5/+mysqWdSQG3Uw8+10D3EJMai4oe8UuCWGv/VIkkgdXh1Vupuu42VyLpl2OMnMhySXRuEowVBQfJjdVjklIajl0RnvuQ4z0Vz1sdRbJPuaZeqw1m/JeUU+tDMTCsPZFRKabD37axzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CH3PR11MB8154.namprd11.prod.outlook.com (2603:10b6:610:15f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Wed, 6 Nov
 2024 09:52:04 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.8137.018; Wed, 6 Nov 2024
 09:52:04 +0000
Message-ID: <0edd54a4-b8ee-423c-9094-af0c841ea140@intel.com>
Date: Wed, 6 Nov 2024 17:56:40 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/13] iommu/vt-d: Add a helper to flush cache for
 updating present pasid entry
To: "Tian, Kevin" <kevin.tian@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "vasant.hegde@amd.com" <vasant.hegde@amd.com>,
	"will@kernel.org" <will@kernel.org>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-3-yi.l.liu@intel.com>
 <BN9PR11MB5276D12FF07A6066CEAAF4308C532@BN9PR11MB5276.namprd11.prod.outlook.com>
 <b6442ba7-7979-4619-8b47-87ee90792517@intel.com>
 <BN9PR11MB5276DC217F91F706C0100A738C532@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB5276DC217F91F706C0100A738C532@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR01CA0187.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::12) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CH3PR11MB8154:EE_
X-MS-Office365-Filtering-Correlation-Id: 35262d49-845b-44cf-f8a3-08dcfe48aae6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?L1JJYVBRcXRWMndQK21NUFBySnMrdm9BdjZUeXNXc2Q1Sy83bnRRWVRIS0lW?=
 =?utf-8?B?aDk2d2dGNnVGQWVaNmtTclQ0T01sTWlRbzJIV1MvUXlsTldHNGtLdjNncHcw?=
 =?utf-8?B?dE9adDIxaEZZMDBrSlFpb0o2SkxVa2pUSTkyOCsyb3ZHQTZEbFREcWVxRGZu?=
 =?utf-8?B?RGdQQTBHMnR5bUtoNW12R3VvU0l6YzcxZTAwaVNSVTkrZVYrdVhPNVFsaFNX?=
 =?utf-8?B?K01ENnV3TXJRVEM4MjI2K3g0VmVwMklLaFQ5bkRaTEF6V0ZFSnd6SU5NL01S?=
 =?utf-8?B?b2xoSGZLanlqOUdIUkViWUp4Z3phYUtLenBvOEdhN25paGpqaUxjYVlMdkE3?=
 =?utf-8?B?VStoazVPVHdCbE1mVHVkWXFZdFlNNXpOczdkVUUyUUk3dmVSR3Btd2NwUEIw?=
 =?utf-8?B?elFmRkdIMmZZQ2tPS0ZNWmtLaWlIVCs1b0pzTkg0b1JJMHFaNERoSGZOVzM5?=
 =?utf-8?B?blJuYkM1U0JmM3RMTXZpQUFkcnV1U3FCRWhEckpDanlYUFozMmxtUXJzZEpE?=
 =?utf-8?B?M2ZYdWNYZ3diY1RTQlZQWmJGbGtSKzVpS3ZhYzc0c2ZQRkx2TkxuS0JjNG5M?=
 =?utf-8?B?RG1FaWtZNEhuaVhpdmlKQ0hvWE9wZWdtcFRldyt3UXVSNlk3ZS9CYWJXNEU3?=
 =?utf-8?B?bFliSUtSL0t4dDQvVlJhYzZxcmJPaHd6Y3dCQlpTU0FOaVVyVDdHYVFjMDRQ?=
 =?utf-8?B?SVVLQ2FMYTdPV040S1M1V20yd1FjRVMrbEVBd2F5ZzUzakpPOUU1OHN3Vitp?=
 =?utf-8?B?Um41NDZLZ2FTTVltUDNhb01CUS9QTUVSbmVsTWF2aEV5d1djTzhCbVJLRnVr?=
 =?utf-8?B?anpNZ3dlQ1BEWjVVRFRDMkFkRXdUamxXNjF0S1ZxUitPdXo2L0N6ZzRvYVZP?=
 =?utf-8?B?YkoyVHhrRW5sUEZQL0lmSzJNamhsSEUza3YyQzZoL1VISGoySGdRQ0l0RDZv?=
 =?utf-8?B?UkVtUVNjNWRlNTJkQmIrcUg2VU5PaHZ4RERrZ2lRejc0TjZUajhlUEdYbnpp?=
 =?utf-8?B?MlVJUDVyN0drdUFEcUh4VmV6T0Vhdnd2L3ZiV3JHM0RTSXNJNzNFempxUW5W?=
 =?utf-8?B?cTROSEM4OWlTKzZnNGhSS1JZUFZZbk01RUVuZ09ORiswb20rczhZdE9xdUh2?=
 =?utf-8?B?akVYZEJQd1dIVEJwTzVKc3NWZExiZEtiRkpyNEx4dTlvZ3JpdXkwampCQUJH?=
 =?utf-8?B?QVVYQjVEb0lRM0VWZXVEN2h5ME5jbXkrckUrb2NmQzR3OFVObFYrRFlmWEl2?=
 =?utf-8?B?QXBMRXRpN01xeWx0eGRhTXcyTjlqVC9kOXRQZFN3Tm85aEFMV2ZZMkx5VE9a?=
 =?utf-8?B?ZnF1UlJXaC8xSTIwVkx1RytFdmtKSlIydVFCSGhYMDRrOFJ1TWxPZGFpVVlD?=
 =?utf-8?B?blUxV1FoM21hV2g2OFVGUmUwV3czQ0RKZG5aU2pDQnczOVNYNHJCR1h6MlBP?=
 =?utf-8?B?SEp6OWVBSTg2Q0luR3djTHZQWW1MNS9VbWY0ekR3VnlWMDlvRmdsSXRhTGFy?=
 =?utf-8?B?QmpVSnBCc1B6NXVpTXFHdmpWdTVHRTVZekFTUHArODlhMjVGSVFkQWxxOERV?=
 =?utf-8?B?UmErUE5ZTkhmUkwvUlh3TXZENEJ3MnRGLzdvYVp0cnBiVU84SGR4UDRZM296?=
 =?utf-8?B?S25ub082Z2c5MjU2R2JxZW1ubUtuaDhPYXVDUVNxVnBlQ2lBbENhSmNGQVdI?=
 =?utf-8?B?cWYyN2l4SDJFek9TOEdtTHFyeURHbWxmclc3UkplV3N1Z0ZPSzc2bTErdVQv?=
 =?utf-8?Q?1YZoSqsaJ2Uf2lyKajkQyvQXIR4LtJutAPpgl+V?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N1JCb2dHdW5vY2FuRjJVZmRQdFRtQmFySG9jTUhyWGNWOVFDdU1sSUtIRzJK?=
 =?utf-8?B?UWdUYlk3UDFhM2xBckxCdlAzMlI5aGNqYmZGdFJtNnZSVHZvSzJlZ3hMU3Rq?=
 =?utf-8?B?N3pYNnJGbU1HVXQxRlZjVkk2VHFoalo3MFdydkZEaVZPTXQ0cG1FUzJFNDNq?=
 =?utf-8?B?Z3dISjZHZFJzam1oOTdwL2N6ZmNRK3Fwb0kxakVJWnR3MThEUGhTQmRSZ1U2?=
 =?utf-8?B?QUNNTjlRMkNCSGw1Znl6OENZMWJlTkljUUsyL2V4REhaMlZ2T0VvL2U5S241?=
 =?utf-8?B?MnIwZVlyNENTUCs1SFZlWFN6b3dFSC9JT2N5RjduQ2xrbG04WUhCYXFKVGQ5?=
 =?utf-8?B?WUZHTHFVeitaUjBZenEwcFV6QnA3U1JBQ0dyUW1nQWlVRmM4M1RGbDNvZWFF?=
 =?utf-8?B?SER4U3NhRUlVMG1GWUlmVnhqZUhpZzlhd2xPb2ZudVJlNGZid2lXZU1qNHB0?=
 =?utf-8?B?dmoxcVpuUy9RMWJsNDZRRmNObGd1SEc2REdyTkxPUkVvSXpMMGZQTmJWdnZP?=
 =?utf-8?B?TlBVL2lrbnBERU01VVlEMmpUZE5LVDRXaDhqZGxoci9RTjUwQ0pRb0RTVE5l?=
 =?utf-8?B?eVpYcWtxSVZodGYvQ2tTL3hBWmxoQVE2aFF5clhMQXJNRVIvbEJVTGxxNmxw?=
 =?utf-8?B?ampkN3dhQ2RYSE9mMG1kUFI0MHNiOGo1Mk9YdTJzSnNTaWVXVGIva2dLcmZx?=
 =?utf-8?B?Ym9kUnFZVVhveEZLRnlVWEphOUhBZlNJUnZqOXR1akNJR0JlelFvMVBqYnVh?=
 =?utf-8?B?VVplMEJhN1Y2SG5TeEhxbmx5VzNDcXBrekxCbGhla1R4d21sWTNySHdKN2h2?=
 =?utf-8?B?bEFRSHdmMlRrNzZaSHNJbGFVcythamRSQVV4TjVhLzNpY2NTZi9lN1pFbjNH?=
 =?utf-8?B?V3BHc0tLVlNraHFtemdIM2EzT01lY3FpNmdKRzN5MDliVjFYOFBBMys1a0p2?=
 =?utf-8?B?aXJ6SE9hM3NXczZVUkowNTIxSktKN0V3NUdYN3l0U256VmtWVmVNekJIYUJo?=
 =?utf-8?B?WUFyWG5Hd0tLMzZJRmU2dlVPL0FZenJJLzVtTEdxbGNBSTcwVjRCak14QkVR?=
 =?utf-8?B?Q0VKODV2MVF5WE9qdElPclVXSTlNUEZLWmtPU2VQMkJidnhWVHFhNTRKcENp?=
 =?utf-8?B?bFRZa3pWTjlkb09nTHJ0aVA5SEtwdlBKZWxUTGh3STViVEtjVG83bWdOZGdV?=
 =?utf-8?B?OHlKZGg2bERUVWdsTlB3MTZLNFlTa0kvWm54M0txMURNb3dLSnFkZFhpNThZ?=
 =?utf-8?B?MHlxamlLTHZGaGgvWFFpT2N0S3o0b3JaSjBzbWRJNmVGOTJQRzNwTmlRSE5H?=
 =?utf-8?B?SUZia2J4b1V4d28xUkNJLzdzUmlmd1NJRll5MEI3UmErdkYxN1Z0Vm5DU2Na?=
 =?utf-8?B?d29iM1ROcisvSUU4cHU3a3crSWMrYTZiUnpTelRYVW5pUnQrblA5bXRvRWpj?=
 =?utf-8?B?UmY0eTNNZmZJY1E4djlFdHdkb1VGOGczdXJjZVh2UkwvVFBnR1lzbjFTbnE1?=
 =?utf-8?B?dk1QQmR1dTNIZmo0WFVNYXdZSzM1MEd1V3NTQWRsdWtiKzR3dzZIdW5lZjEz?=
 =?utf-8?B?ajFBN2xKcitsVGlRN1BnRkhva25UV1gwY0xaY0lDYm95REZzNlRvKzF1S3Vi?=
 =?utf-8?B?TGFyYkhzUkF4NXRVUXpZSXQrREJGNFFkLzlZZGJUU2NBeVlYZjh0amRwWklK?=
 =?utf-8?B?MVdvMHMwTElMRWN2emhObkFHVk04NkkwVGxET1dQVDFLSFJKZUdCcE9WMFp4?=
 =?utf-8?B?bFRWcmZOSzBwN2pzVzJ3a09oSUlUWXFxM2NaSEIwczc3UGFMNm1hdTQ5bFVD?=
 =?utf-8?B?T0g3QkI4bUp5ZUNWYlphdTZDK0FqejRqV1oyZVJtRmdwWEN1MFpTdEVUbUFz?=
 =?utf-8?B?TC9ScWt5eENmZWQxeFFEYUJhKzUvNVlERng4akoveFhFbHRoYmN5VlpRWW1h?=
 =?utf-8?B?MVpqZUREbnNEemFrTzA0VFJRVXF4VFJFRzBCSURRQ1Q3Sm5JbGRYdlQvVDM5?=
 =?utf-8?B?eVVER3owemtNZHpiQytuNjh2V3BvZ1ZxaEl4YzJFcHROTktLQ1VlMGVySVUz?=
 =?utf-8?B?M2FXM2tBWFZRZHdGd0hMSllnTkM2S3BoZHdjSWpFMktRa3UwWklFTEw0c2pp?=
 =?utf-8?Q?Nlb6SjZ1WgjY/sTafMmCmjgCD?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 35262d49-845b-44cf-f8a3-08dcfe48aae6
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2024 09:52:04.1105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4K73gDlnbEi9pYldk4bXWMa6T25RXEfRqlWBmxCnbbeFoq3G8Rs7JnwJUgoN962Z6JYkCWWmAszFRRVV45dKDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8154
X-OriginatorOrg: intel.com

On 2024/11/6 17:40, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Wednesday, November 6, 2024 4:46 PM
>>
>> On 2024/11/6 15:11, Tian, Kevin wrote:
>>>> From: Liu, Yi L <yi.l.liu@intel.com>
>>>> Sent: Monday, November 4, 2024 9:19 PM
>>>>
>>>> There are more paths that need to flush cache for present pasid entry
>>>> after adding pasid replacement. Hence, add a helper for it. Per the
>>>> VT-d spec, the changes to the fields other than SSADE and P bit can
>>>> share the same code. So intel_pasid_setup_page_snoop_control() is the
>>>> first user of this helper.
>>>
>>> No hw spec would ever talk about coding sharing in sw implementation.
>>
>> yes, it's just sw choice.
>>
>>> and according to the following context the fact is just that two flows
>>> between RID and PASID are similar so you decide to create a common
>>> helper for both.
>>
>> I'm not quite getting why RID is related. This is only about the cache
>> flush per pasid entry updating.
> 
> the comment says:
> 
> +	 * - If (pasid is RID_PASID)
> +	 *    - Global Device-TLB invalidation to affected functions
> +	 *   Else
> +	 *    - PASID-based Device-TLB invalidation (with S=1 and
> +	 *      Addr[63:12]=0x7FFFFFFF_FFFFF) to affected functions
> 
> so that is the only difference between two invalidation flows?

oh, yes. But there are multiple PASID paths that need flush. e.g. the
pasid teardown. However, this path cannot use this helper introduced
here as it modifies the Present bit. Per table 28, the teardown path
should check pgtt to decide between p_iotlb_inv and iotlb_inv.

>>
>>>>
>>>> No functional change is intended.
>>>>
>>>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
>>>> ---
>>>>    drivers/iommu/intel/pasid.c | 54 ++++++++++++++++++++++++-------------
>>>>    1 file changed, 36 insertions(+), 18 deletions(-)
>>>>
>>>> diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
>>>> index 977c4ac00c4c..81d038222414 100644
>>>> --- a/drivers/iommu/intel/pasid.c
>>>> +++ b/drivers/iommu/intel/pasid.c
>>>> @@ -286,6 +286,41 @@ static void pasid_flush_caches(struct
>> intel_iommu
>>>> *iommu,
>>>>    	}
>>>>    }
>>>>
>>>> +/*
>>>> + * This function is supposed to be used after caller updates the fields
>>>> + * except for the SSADE and P bit of a pasid table entry. It does the
>>>> + * below:
>>>> + * - Flush cacheline if needed
>>>> + * - Flush the caches per the guidance of VT-d spec 5.0 Table 28.
>>>
>>> while at it please add the name for the table.
>>
>> sure.
>>
>>>
>>>> + *   ”Guidance to Software for Invalidations“
>>>> + *
>>>> + * Caller of it should not modify the in-use pasid table entries.
>>>
>>> I'm not sure about this statement. As long as the change doesn't
>>> impact in-fly DMAs it's always the caller's right for whether to do it.
>>>
>>> actually based on the main intention of supporting replace it's
>>> quite possible.
>>
>> This comment is mainly due to the clflush_cache_range() within this
>> helper. If caller modifies the pte content, it will need to call
>> this again.
>>
> 
> Isn't it obvious about the latter part?

hmmm, I added it mainly by referring to the below helper. This helper
is for newly setup pasid entries, so in flight DMA is not relevant.

/*
  * This function flushes cache for a newly setup pasid table entry.
  * Caller of it should not modify the in-use pasid table entries.
  */
static void pasid_flush_caches(struct intel_iommu *iommu,
				struct pasid_entry *pte,
			       u32 pasid, u16 did)
{

-- 
Regards,
Yi Liu

