Return-Path: <kvm+bounces-32401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 680D09D7A13
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 03:26:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC79B162A75
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 02:26:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F6AE1426C;
	Mon, 25 Nov 2024 02:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S8RZaLM/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5A2291E
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 02:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732501605; cv=fail; b=oK6SxJIapv2Lwjv/pWjmCzHwDy1/ZzybjC5uIkBA1X0L1qo72n90XJrP+/28gxwdHEjNdyQbmqJ1ZlgzFQW8UUXoFzQel03wctW0AY8J2rHGCwZp1PRhpzyaw9J0KDOanS/pXlABMoKljiQaKK4OgoGs7Ba+B+kVss2SI3t885E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732501605; c=relaxed/simple;
	bh=yYUWdobZzcRVH31F8CQyUjqbymrZyQIpI16QB2TY5MQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cRf1SpyXXTObaDef9Kcspw89CVWJ/YavDw07INBBSSvnFTvQuDT/o9rhv2lnEXJElSxoipsQMKb/O977yLCRGpfUFbnIOrazYuv3//diZJE0LkMe74mPGOEztYTaJzvf9CRn4IVWGpy+CwKySQgCgrJndUysVI6dJ0Ltl33OXok=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S8RZaLM/; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732501603; x=1764037603;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yYUWdobZzcRVH31F8CQyUjqbymrZyQIpI16QB2TY5MQ=;
  b=S8RZaLM/lxiWr0H96Nid1+L8Unq6b93fzrae0mIc2sBeVvNWVqm55Ccu
   HRZKTwlR1fPlTrbBUOpFbuURslg6t9lrsv2UaJMsimIyMr6E4v/uLkLFM
   czOEKzxJom1BEB1Q39iQtioMHiQ7d0os/UVTmDUBjBFiu1E4XHPyYG/sE
   YoF3iZ6UVelxZrqYf5nTv8TMu/D9mCJbbQF2fHRyYKzhyTXUbHDvaZPFf
   c7xrRB0V4cBpoXCP8Fd7FljVu4b6flpEDYOpgJ57xrpgKBx1kKWBGCkoG
   8sJxExQhk1ptAwULUWJYQUTX4xU0q+0MOC3rHesc9nPpL54ZAbfqUxXVk
   g==;
X-CSE-ConnectionGUID: IRgltQqXTKeIf8NGP9QrsQ==
X-CSE-MsgGUID: Fo1VUL8XSsmcoy7IrEKFgA==
X-IronPort-AV: E=McAfee;i="6700,10204,11266"; a="55094267"
X-IronPort-AV: E=Sophos;i="6.12,182,1728975600"; 
   d="scan'208";a="55094267"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2024 18:26:43 -0800
X-CSE-ConnectionGUID: R1U3pW1rQtarfhY97ueu1A==
X-CSE-MsgGUID: sme+eqdARrOgBwZpCvM1QQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,182,1728975600"; 
   d="scan'208";a="95215051"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Nov 2024 18:26:43 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 24 Nov 2024 18:26:42 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 24 Nov 2024 18:26:42 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.48) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 24 Nov 2024 18:26:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nr4NN1GiUsiCZpTYltX5hyqh6Y0CrZcKIwzy02QyZ7utTZ/8FnCjw5kHZPVnf6kTs8O334rBbx08vKkz7w/O3szeJEHFODT/nVfJhbyggGJrQYeNWkUne+CWLQkVdeUSyVbfWREC7bYyCz8M00zuW3mu4La8xvNvzEluGDQDFsBFsqSOYOfoAuxr5b0oiczHeBKrexOTOfcw4olh6Pgdd0daLZwykaksAONrmmg+7+IL/40cbsOG4ONEmtqgWP+RBjP/9pElI57aLqTD/Z89Rs0mYAQBDCYBr00AzSiiInBNsKzUZmqy8lzhXykPt+LZmGqDJvhgm0m/dSFZFyrquw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iHOBOaAPva2+zwho3+VQUCi50F5HPcQhPv2V1xZjmUU=;
 b=sroZ6QNVvrLcYXJQvwVZ2Ym89WHSQO1OX778DAn3M8OaXVThYkYCDrEMdtFxklTF7Gcl0fdYxbBVU0wI0H/rjYioNK1Vc10Foj13sbigbl7VBpNCg/A+HAAWj65u+65zeR5B1eztyViyCFuFKns4UggDsABqr8L5knJXRyUqZxqIZPJreVxUoXaSECG0Qc58XrmKAyx/wO8juup9qMF/CrHN/RRovYTDGegmCaRjtkXxjkP/lE3zoNTkfxDGOsAa1cZtLf13moJAx/6ZBJ7F19TG4IB1ddCSUgMBqBPMGYj+x+xGbRt1E1gouKpGUnAaO69/ZZ0DO7CGszWCYAumJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CH2PR11MB8836.namprd11.prod.outlook.com (2603:10b6:610:283::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.22; Mon, 25 Nov
 2024 02:26:40 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%5]) with mapi id 15.20.8158.021; Mon, 25 Nov 2024
 02:26:40 +0000
Message-ID: <4e02975b-0121-4267-81f5-fb41f4371d81@intel.com>
Date: Mon, 25 Nov 2024 10:31:38 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] vfio/pci: Properly hide first-in-list PCIe extended
 capability
To: Alex Williamson <alex.williamson@redhat.com>
CC: Avihai Horon <avihaih@nvidia.com>, <kvm@vger.kernel.org>, Yishai Hadas
	<yishaih@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>, Maor Gottlieb
	<maorg@nvidia.com>
References: <20241121140057.25157-1-avihaih@nvidia.com>
 <14709dcf-d7fe-4579-81b9-28065ce15f3e@intel.com>
 <20241122094826.142a5d54.alex.williamson@redhat.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20241122094826.142a5d54.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0201.apcprd04.prod.outlook.com
 (2603:1096:4:187::23) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CH2PR11MB8836:EE_
X-MS-Office365-Filtering-Correlation-Id: 68390c46-8d29-4f1c-fb15-08dd0cf89802
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?U0k1dEMwcmJHVEhNY3NvcWtaVjVlU3ZMZXFodmV6OXpVRWJucExWTlAwNm1P?=
 =?utf-8?B?b0Q5Y0M3MGhORmNPYTBnLzNhaXV5RUNUWG9NVzk5TThSWTIrclQ2YUxtYlZw?=
 =?utf-8?B?Y3ROUkF5Nkd5SmpJN2pCdjJIZVdMR2ZHU1lya1YwcHlTSUM4SGVvUHFzM3Zv?=
 =?utf-8?B?UFh2U3Q2SnQwbVpxQi9GcTQ4dk13UzBETVA0anArcklvbE1UcFozNmQzQk9O?=
 =?utf-8?B?Y05ROVNFSFErQ2hYZ0pVTm1OTmt2WHVaWEpxWk1yS1JqN2ZoR0ozaElrbEcz?=
 =?utf-8?B?eHhhTW1NWnhJc3p2V09SSTk3ZzErZEErcUo0aGQrbTU4Mk41eEYweGFhV2wx?=
 =?utf-8?B?dExpYTM3RXVvclp1N2ZjZ2VzaWpxY0ZZbW5PU3pNdUJPd2hPSEdzbk03UzR5?=
 =?utf-8?B?czU1R2gyY2kyMG45eGM1WlNvT1lQc1k3a1lRbjlQdDBaOU1OSnBxVzQvR3hz?=
 =?utf-8?B?L1ZtdDdUSnBIazNmQXNFZ3prNUJDSGdpa2NrNVVCOGE3NitWaEdaOHUvandm?=
 =?utf-8?B?M1grTG04Uzg2VERNbWY5dTUyZGNRYWp4L2VaOGcxQWJBVEd2d0ZVdCtyZVJJ?=
 =?utf-8?B?LzBPZ3hpVms4bnQzRGVPSEl1dGdJOUgxVGE4MjR0U3RCVW52K0JLcjF0TS9Q?=
 =?utf-8?B?UDYwcmJjOStSZXM1dzlCQ0JrbzYvSDB2a3pJT2ZRSzZXY1dkclRHQllOeW1Y?=
 =?utf-8?B?UWlIZUdLSitDOWc0NXNBZnU5TElSeEU1azZ4dnNHbWtNWGxDOXRzeGcybWxI?=
 =?utf-8?B?cXkzQnhGQnhZeURWZk04UkFZQy90alRQUkc0czdib1hEVndOblVoSHFYQktE?=
 =?utf-8?B?b2RibTdxaEJRY0VaZFpiMkRzTzJuZTFOWE1OYllMc0hpZjA1eVdIWGdiU1pF?=
 =?utf-8?B?dkJsUnpLTVRRUk8wTUFvQ0I5UGdJR1FDSDcvZDZCSGRXcmllUkdTanY2WU9Y?=
 =?utf-8?B?WVVubExBM3FzM0Q3N0VtNFZNK2RDWE93aU41Tis2dnZsVWdLU1JqUi9FR1BK?=
 =?utf-8?B?cVo0WWlVeWVQaEhFbHFVMDdmbHZPK0xvSW51QTFsMHlvQytVdzNHQnVRVnlN?=
 =?utf-8?B?NHJrN2ZzaXlIL01NK3BHWnBJbTJSS21WWTRlNmcrZmprdzc5MERNU0dTMG1v?=
 =?utf-8?B?QU9ubWFlN08rWWZYT1ZVRkg0NGxIQmY5SURtZHFjQnI0SVBWRUxDeGtaRjlu?=
 =?utf-8?B?OERUNjFrZnRlM3lRT0xURVl0NGV6b3VIT0FnV25HQ3J4M3EvSmpkcGVuVUJt?=
 =?utf-8?B?U3Q0aHRDTnlRbFZSZ3Q0RzUwaXhrRDRDbER2MnhKZkFLdUhFeG9XSFNBSWxu?=
 =?utf-8?B?NVVXTW1zWlJvZkZTSDI2TzgwUkRpbGdWQ1QzT3d2UGNFYkh1OHEydzdLRkxK?=
 =?utf-8?B?c0dyR29icVFuM0dLdnJUdFp5K1ZML1BmYTBaQmtGalZxb3hGSkxFQWtZUnZY?=
 =?utf-8?B?UVpZSjBOVjNSRnY2K09tTmFVaitodnB1QmVUT25UVi9EQnBlRjc3NUpOWmdO?=
 =?utf-8?B?VFFNYnFneVZqOE5qdG9NY1dnZEV6MmVsc1VqOUMvZXMreUREcXFjb0hYOUsw?=
 =?utf-8?B?SzlkWS9lbjkxVmxyaDI4eWRwV3F4T1ZxMjJPcXRDZE9SNTN5b0lMVnJVeWhw?=
 =?utf-8?B?bm43UkxLdm03NGs2SzkzNERLcEJpdjBMTmVVWUd6WW9zNVk4S0cxUXcrWGtw?=
 =?utf-8?B?a3FUUnJibTE0cmdqdlJFd2xnakRubXFVQ0NiZzRzczRrdVpWUlIzMzYzcEhL?=
 =?utf-8?B?Tk8yYjFvbytPcHVhV0F2SXc0dGVoelVXU0thNW9FeEZPNElxQlJpejYzNk1l?=
 =?utf-8?B?SHhMOTFBelQrWnVuQytrUT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OERlNXpyemppckMwVjVGbHpGQ3R5eHE0Z0srM0xrS3d4OHVZTjdYK2dQb2g3?=
 =?utf-8?B?amlsMWJLcnU5MWxGSU5sSWxSRldZMHNzU1AyL2MzR2hLV2FxL3RPaVRsakQ2?=
 =?utf-8?B?TklwZ0hUOFFSU0RsZ2lZSDVralBGdmpQU0xFT2Q2TElZbWlJUXBhR3h1dnJ2?=
 =?utf-8?B?NWUzVXZGSWxjTjZONVJZUXlNdGN2TzV4TFZaRDZYR0haSEJlUmJRZ1BXQ0Zm?=
 =?utf-8?B?RmVFdHdnRHZlVWJoZm9EZlZnLzBSL0E2Sk1QYkpUWGpheEE5SUtwTk80M2Jw?=
 =?utf-8?B?YURrdWdKUGNiNXF0TkYzM253VFpaS0ZHa2ZlVG00Q0FaU1MvR1o4RlpoQ0lq?=
 =?utf-8?B?TDZkUWRQTU9nK25QR29McjJFTlEzWlhLcStPS3UvSXAxblMvN1JqVEZ6WEhN?=
 =?utf-8?B?d01FZldWSlhRcFVVMkpFaTBJQUN1bnpDeGFSbXRKSkd5YksxTVBuK21BcGhT?=
 =?utf-8?B?TnRtQmliTHVoMUdZNDFkdGF1RVAyQU1oQ29BNkRWTzRqQlNGa3hUSGpSNThs?=
 =?utf-8?B?K0NzSkV2ODcxRmp5UENiZk0yN2xXUER5djYvbkVIZUk1cUtJUDBDdDEwUWYw?=
 =?utf-8?B?NDN1Mk5aQzA4OTQ2eU5mb2tkNlBqNmxZRU9aUTZVSXhiSGNHUUt4WXpTdnls?=
 =?utf-8?B?TTIreUp6U0dKUGx0dCs0dldqQjF0MlpLWC9qeTFQeUV5aGhGQVh1N0NKNHRK?=
 =?utf-8?B?eGZWdTJNSVRFWU9MUlJVL0VFNEFjSHI4bFRIRkc3NWpkdzJQUnV6djBwd2Ja?=
 =?utf-8?B?Q044QTJNRU1pRW5rNG9iSGtVem1TMEpWTEJ0bC9OSDQ3TWV1TUFPa0JIUUpv?=
 =?utf-8?B?M2FwT3VBUWJkY0VVVVpyV1JSdnlkT2p0b0dZd0I3VjY0M2J4UWUwZDVBaDRM?=
 =?utf-8?B?a1pwSklPc2tKODNsMmR3S2s2ejhsamZGbVFxdm5lOENrOUhmc1pNMjM0dWVG?=
 =?utf-8?B?NkdWNVNjd3FZOVA4RWlEbCtOZ0ZHVVdIVjlXbG5pdW13NnRYUjRaUlJmMTYv?=
 =?utf-8?B?Z3Rpd1ZQb1hra3hzMGFKOWM4b2JDb010RXlwMjFjaWJ3dm1SdlVuWThNMGNB?=
 =?utf-8?B?RlRjUU1GeVlYRE1zWTRJSTF2VzF6OER1SGsvZGFzTDVWQTc4VU5VditQbndZ?=
 =?utf-8?B?YzZtRjlheGNGWkxIT0VRWjhRZWJqcEJYNzJZang2ZDBoakVLbURJSUk0djYz?=
 =?utf-8?B?TkpQZDdmOE94WWw2RHI1OWNwbnhvNE9sdEt1T2N6cklKL0p5bE5acWU4SkNz?=
 =?utf-8?B?aTZvaUVwcWFGQkd3V2s5b3hrZS94NGswWlFCWUp1MGt0MW41bVZ1NzlmeTFu?=
 =?utf-8?B?SE41dEVHUHlHNWV5M0IwOUE4MGgzMlZWenM4dmx0NEFyY3hkZDJ6ZUlPa0dT?=
 =?utf-8?B?c3pYVmdPZXVjTlBoNXpSak1oajgxVmxJL1BHak9kd1BiRnZiMVVKNi9YWndw?=
 =?utf-8?B?RytvbW5ubVA5bk5yQndNTE1wNDdGdTVsZy83VHNMTFhPREY5WFhKUC9jb0Vv?=
 =?utf-8?B?Nm5YZnBCM0ZhVUNTQ09jSVdlQXo0QndBNC9USjBpeFZXVDNSM1g3SEVyRE1J?=
 =?utf-8?B?dVoycWs5clFUR252QmNzL3N3SHVDNUxPYXNEckRNZ0NMWUg0c05CUjVUcTAx?=
 =?utf-8?B?OGFJcEhXKzNCbmh3YkozUk91RElsSUR4YW14STcxNExBdElUdnZOUStpblZC?=
 =?utf-8?B?Y1c2V0pJZ0UveXQ4bzF6R0VDZjUyT0RzVStRK2R0cFl4d2dqd2Z1czJwZ20v?=
 =?utf-8?B?YTFpOElqNU9RdlhwS0NITDlQVXRJOHE5UUJ3emVucE8zSmY3MTIxUjBkS1Zh?=
 =?utf-8?B?Z09QTXVOem51eWZUZmcvekFkZUxNMmRSSTBMZElBc3JqVjBXU0VQeTdmWnhv?=
 =?utf-8?B?VDRFcEtrNVE1eGd5aG1ib2h4OEJISlVkVjFuOXJ4Mmh2SDlzVGZMWWNhQUFr?=
 =?utf-8?B?bDg2YzZuUE9GZmdVbGNPYlZwZExmeHVock5wdyt4Y2xTYzROelBsR3IzcTE0?=
 =?utf-8?B?RVQxTVNGa3hDNEd6ZnBkVGNiMGErU0RDUXhOVDlDRHREUDJ3dU56R0NQMWpQ?=
 =?utf-8?B?VlFlODJZVkx3ZGZLK3BrT2ZNclU1N0EwNE1WWmlMMDJSZ1BLMzNtZEx3RURV?=
 =?utf-8?Q?yTzwv/UZofg8vFM5uc0M77Ywd?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 68390c46-8d29-4f1c-fb15-08dd0cf89802
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2024 02:26:40.1478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WDbKjncHol0UU9JkO6+tV6k9w9Qoz1/bpZF3bZuho3WdIv2AXv9RHXWZflD7HGwTmxMgxSMadTTxStyWkNc3uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR11MB8836
X-OriginatorOrg: intel.com

On 2024/11/23 00:48, Alex Williamson wrote:
> On Fri, 22 Nov 2024 20:45:08 +0800
> Yi Liu <yi.l.liu@intel.com> wrote:
> 
>> On 2024/11/21 22:00, Avihai Horon wrote:
>>> There are cases where a PCIe extended capability should be hidden from
>>> the user. For example, an unknown capability (i.e., capability with ID
>>> greater than PCI_EXT_CAP_ID_MAX) or a capability that is intentionally
>>> chosen to be hidden from the user.
>>>
>>> Hiding a capability is done by virtualizing and modifying the 'Next
>>> Capability Offset' field of the previous capability so it points to the
>>> capability after the one that should be hidden.
>>>
>>> The special case where the first capability in the list should be hidden
>>> is handled differently because there is no previous capability that can
>>> be modified. In this case, the capability ID and version are zeroed
>>> while leaving the next pointer intact. This hides the capability and
>>> leaves an anchor for the rest of the capability list.
>>>
>>> However, today, hiding the first capability in the list is not done
>>> properly if the capability is unknown, as struct
>>> vfio_pci_core_device->pci_config_map is set to the capability ID during
>>> initialization but the capability ID is not properly checked later when
>>> used in vfio_config_do_rw(). This leads to the following warning [1] and
>>> to an out-of-bounds access to ecap_perms array.
>>>
>>> Fix it by checking cap_id in vfio_config_do_rw(), and if it is greater
>>> than PCI_EXT_CAP_ID_MAX, use an alternative struct perm_bits for direct
>>> read only access instead of the ecap_perms array.
>>>
>>> Note that this is safe since the above is the only case where cap_id can
>>> exceed PCI_EXT_CAP_ID_MAX (except for the special capabilities, which
>>> are already checked before).
>>>
>>> [1]
>>>
>>> WARNING: CPU: 118 PID: 5329 at drivers/vfio/pci/vfio_pci_config.c:1900 vfio_pci_config_rw+0x395/0x430 [vfio_pci_core]
>>
>> strange, it is not in the vfio_config_do_rw(). But never mind.
>>
>>> CPU: 118 UID: 0 PID: 5329 Comm: simx-qemu-syste Not tainted 6.12.0+ #1
>>> (snip)
>>> Call Trace:
>>>    <TASK>
>>>    ? show_regs+0x69/0x80
>>>    ? __warn+0x8d/0x140
>>>    ? vfio_pci_config_rw+0x395/0x430 [vfio_pci_core]
>>>    ? report_bug+0x18f/0x1a0
>>>    ? handle_bug+0x63/0xa0
>>>    ? exc_invalid_op+0x19/0x70
>>>    ? asm_exc_invalid_op+0x1b/0x20
>>>    ? vfio_pci_config_rw+0x395/0x430 [vfio_pci_core]
>>>    ? vfio_pci_config_rw+0x244/0x430 [vfio_pci_core]
>>>    vfio_pci_rw+0x101/0x1b0 [vfio_pci_core]
>>>    vfio_pci_core_read+0x1d/0x30 [vfio_pci_core]
>>>    vfio_device_fops_read+0x27/0x40 [vfio]
>>>    vfs_read+0xbd/0x340
>>>    ? vfio_device_fops_unl_ioctl+0xbb/0x740 [vfio]
>>>    ? __rseq_handle_notify_resume+0xa4/0x4b0
>>>    __x64_sys_pread64+0x96/0xc0
>>>    x64_sys_call+0x1c3d/0x20d0
>>>    do_syscall_64+0x4d/0x120
>>>    entry_SYSCALL_64_after_hwframe+0x76/0x7e
>>>
>>> Fixes: 89e1f7d4c66d ("vfio: Add PCI device driver")
>>> Signed-off-by: Avihai Horon <avihaih@nvidia.com>
>>> ---
>>> Changes from v1:
>>> * Use Alex's suggestion to fix the bug and adapt the commit message.
>>> ---
>>>    drivers/vfio/pci/vfio_pci_config.c | 20 ++++++++++++++++----
>>>    1 file changed, 16 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
>>> index 97422aafaa7b..b2a1ba66e5f1 100644
>>> --- a/drivers/vfio/pci/vfio_pci_config.c
>>> +++ b/drivers/vfio/pci/vfio_pci_config.c
>>> @@ -313,12 +313,16 @@ static int vfio_virt_config_read(struct vfio_pci_core_device *vdev, int pos,
>>>    	return count;
>>>    }
>>>    
>>> +static const struct perm_bits direct_ro_perms = {
>>> +	.readfn = vfio_direct_config_read,
>>> +};
>>> +
>>>    /* Default capability regions to read-only, no-virtualization */
>>>    static struct perm_bits cap_perms[PCI_CAP_ID_MAX + 1] = {
>>> -	[0 ... PCI_CAP_ID_MAX] = { .readfn = vfio_direct_config_read }
>>> +	[0 ... PCI_CAP_ID_MAX] = direct_ro_perms
>>>    };
>>>    static struct perm_bits ecap_perms[PCI_EXT_CAP_ID_MAX + 1] = {
>>> -	[0 ... PCI_EXT_CAP_ID_MAX] = { .readfn = vfio_direct_config_read }
>>> +	[0 ... PCI_EXT_CAP_ID_MAX] = direct_ro_perms
>>>    };
>>>    /*
>>>     * Default unassigned regions to raw read-write access.  Some devices
>>> @@ -1897,9 +1901,17 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_core_device *vdev, char __user
>>>    		cap_start = *ppos;
>>>    	} else {
>>>    		if (*ppos >= PCI_CFG_SPACE_SIZE) {
>>> -			WARN_ON(cap_id > PCI_EXT_CAP_ID_MAX);
>>> +			/*
>>> +			 * We can get a cap_id that exceeds PCI_EXT_CAP_ID_MAX
>>> +			 * if we're hiding an unknown capability at the start
>>> +			 * of the extended capability list.  Use default, ro
>>> +			 * access, which will virtualize the id and next values.
>>> +			 */
>>> +			if (cap_id > PCI_EXT_CAP_ID_MAX)
>>> +				perm = (struct perm_bits *)&direct_ro_perms;
>>> +			else
>>> +				perm = &ecap_perms[cap_id];
>>>    
>>> -			perm = &ecap_perms[cap_id];
>>>    			cap_start = vfio_find_cap_start(vdev, *ppos);
>>>    		} else {
>>>    			WARN_ON(cap_id > PCI_CAP_ID_MAX);
>>
>> Looks good to me. :) I'm able to trigger this warning by hide the first
>> ecap on my system with the below hack.
>>
>> diff --git a/drivers/vfio/pci/vfio_pci_config.c
>> b/drivers/vfio/pci/vfio_pci_config.c
>> index b2a1ba66e5f1..db91e19a48b3 100644
>> --- a/drivers/vfio/pci/vfio_pci_config.c
>> +++ b/drivers/vfio/pci/vfio_pci_config.c
>> @@ -1617,6 +1617,7 @@ static int vfio_ecap_init(struct vfio_pci_core_device
>> *vdev)
>>    	u16 epos;
>>    	__le32 *prev = NULL;
>>    	int loops, ret, ecaps = 0;
>> +	int iii =0;
>>
>>    	if (!vdev->extended_caps)
>>    		return 0;
>> @@ -1635,7 +1636,11 @@ static int vfio_ecap_init(struct
>> vfio_pci_core_device *vdev)
>>    		if (ret)
>>    			return ret;
>>
>> -		ecap = PCI_EXT_CAP_ID(header);
>> +		if (iii == 0) {
>> +			ecap = 0x61;
>> +			iii++;
>> +		} else
>> +			ecap = PCI_EXT_CAP_ID(header);
>>
>>    		if (ecap <= PCI_EXT_CAP_ID_MAX) {
>>    			len = pci_ext_cap_length[ecap];
>> @@ -1664,6 +1669,7 @@ static int vfio_ecap_init(struct vfio_pci_core_device
>> *vdev)
>>    			 */
>>    			len = PCI_CAP_SIZEOF;
>>    			hidden = true;
>> +			printk("%s set hide\n", __func__);
>>    		}
>>
>>    		for (i = 0; i < len; i++) {
>> @@ -1893,6 +1899,7 @@ static ssize_t vfio_config_do_rw(struct
>> vfio_pci_core_device *vdev, char __user
>>
>>    	cap_id = vdev->pci_config_map[*ppos];
>>
>> +	printk("%s cap_id: %x\n", __func__, cap_id);
>>    	if (cap_id == PCI_CAP_ID_INVALID) {
>>    		perm = &unassigned_perms;
>>    		cap_start = *ppos;
>>
>> And then this warning is gone after applying this patch. Hence,
>>
>> Reviewed-by: Yi Liu <yi.l.liu@intel.com>
>> Tested-by: Yi Liu <yi.l.liu@intel.com>
> 
> Thanks, good testing!
>   
>> But I can still see a valid next pointer. Like the below log, I hide
>> the first ecap at offset 0x100, its ID is zeroed. The second ecap locates
>> at offset==0x150, its cap_id is 0x0018. I can see the next pointer in the
>> guest. Is it expected?
> 
> This is what makes hiding the first ecap unique, the ecap chain always
> starts at 0x100, the next pointer must be valid for the rest of the
> chain to remain.  For standard capabilities we can change the register
> pointing at the head of the list.  This therefore looks like expected
> behavior, unless I'm missing something more subtle in your example.

Got you. I was a little bit misled by the below comment. I thought the
cap_id, version and next would be zeroed. But the code actually only zeros
the cap_id and version. :)

		/*
		 * If we're just using this capability to anchor the list,
		 * hide the real ID.  Only count real ecaps.  XXX PCI spec
		 * indicates to use cap id = 0, version = 0, next = 0 if
		 * ecaps are absent, hope users check all the way to next.
		 */
		if (hidden)
			*(__le32 *)&vdev->vconfig[epos] &=
				cpu_to_le32((0xffcU << 20));
		else
			ecaps++;

>> Guest:
>> 100: 00 00 00 15 00 00 00 00 00 00 10 00 00 00 04 00
>> 110: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> 120: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> 130: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> 140: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> 150: 18 00 01 16 00 00 00 00 00 00 00 00 00 00 00 00
>> 160: 17 00 01 17 05 02 01 00 00 00 00 00 00 00 00 00
>>
>> Host:
>> 100: 01 00 02 15 00 00 00 00 00 00 10 00 00 00 04 00
>> 110: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> 120: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> 130: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> 140: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> 150: 18 00 01 16 00 00 00 00 00 00 00 00 00 00 00 00
>> 160: 17 00 01 17 05 02 01 00 00 00 00 00 00 00 00 00
>>
>>
>> BTW. If the first PCI cap is a unknown cap, will it have a problem? The
>> vfio_pci_core_device->pci_config_map is kept to be PCI_CAP_ID_INVALID,
>> hence it would use the unassigned_perms. But it makes more sense to use the
>> direct_ro_perms introduced here. is it?
> 
> Once we've masked the capability ID, if the guest driver is still
> touching the remaining body of the capability, we're really in the
> space of undefined behavior, imo.  We've already taken the stance that
> inter-capability space is accessible as a necessity for certain
> devices.  It's certainly been suggested that we might want to take a
> more guarded approach, even so far as readjusting the capability layout
> for compatibility.  We might head in that direction but I don't think
> we should start with this bug fix.  Thanks,

sure.

-- 
Regards,
Yi Liu

