Return-Path: <kvm+bounces-30613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D66989BC486
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:06:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 59EB01F221ED
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 05:06:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2FB91B3950;
	Tue,  5 Nov 2024 05:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iG5zQ7yg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631E8189F2A
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 05:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730783203; cv=fail; b=j7/uNZHZnrZPxPm54dNTlydgYFsvfK23+Fx6ER7NqEmzjpj5F28ETDUKjTnQ4pQ1d5A1EVaWUEyQ4tbSiF1KQa/lxWEKaRCzuio8QDiqrh/6o1xOdW4Yo+9IYSNB0HVVkJFAI5NuTV6wjSGBYpzjjAIZbuX2+CNr2lQQiW/KrO0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730783203; c=relaxed/simple;
	bh=zUogvnSV9RFwiIxcxBn8q8SbV5Wx8UujKOGiHX0qxys=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RmPGQLd8c4VkicsKbwZO7nv0WHD3SsvszIAyliCuQB+I34fis0X5OoIk0qE7/oHS/e5le/wuSN3a0tKJ0jIyxJIDBbRlXO1os7GI7QpXbQfO8KL/fJe16Fw6RaPRs1yKI01FcGOkmLtEc50yHW/UiKTPSc7CkmNnC14+cuyLtG4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iG5zQ7yg; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730783203; x=1762319203;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zUogvnSV9RFwiIxcxBn8q8SbV5Wx8UujKOGiHX0qxys=;
  b=iG5zQ7ygKoEz8u9by/kWRu6i+IcfKbe2ma4SS0Q0jp6Met+TYDkHhw70
   pUBhf8O/9DEUml3Cfb47p6JyfmOTnVmwjLdpbJQ3kgC11Z7ZZzUR8wkZP
   fRIYOLII1Y3lnU6On2VTogWN11FLTmccfreG0Q+wxUdwfHuHfaHI68K2q
   rCyJdCstYs02qK0eNI+kZkdoaPqXGKxhagBEFRQnKXnwHEyEFuqhlzKAo
   QfS+I35b+k/k0mmf2IB+RPuu4Tx3r2NN8ri3hgLsfU+pAJ1+koEoMyypE
   bxR5x+gnDSEl7+0UNw7aiLZs8Ai1msS8KnOCYWU3YxYukeg/HaicLfD3y
   A==;
X-CSE-ConnectionGUID: ZyeQNEifS2C6nCOek5YbaQ==
X-CSE-MsgGUID: Fu4e8jLOSTGP6kBPXqTvuQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30465109"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30465109"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 21:06:42 -0800
X-CSE-ConnectionGUID: MeJBn16TQ12fnRKSY6he4w==
X-CSE-MsgGUID: Jocx5sKxRvaCaTQmPPS6aw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="88627643"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Nov 2024 21:06:42 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 4 Nov 2024 21:06:41 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 4 Nov 2024 21:06:41 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 4 Nov 2024 21:06:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tEASRIterG8RkdSEhSBbgsimPvvW4rihKccGEXsi2pzRE1zuwoyaBzCwIfDxmSdTa6Qvki3BkLKXdFDDr7lpUTxPHkjt57l7p5eqZKC2J4qfxLjrzJi52cRvRWnHJcJYKU+6CR22pvUjofLgsccq3g4b95AiC9Zv6Gs6/5v9QSZFFKcgZhHlDMYOSUAEzrxRGpocuffUYn5+MhVT/CqHx7uDZAdvHVbDVDmZWO9ssap5exNw6ou95RXvbr2VITAK0Harn1yGSGs6CgTOFM1oWnRQPEep70t3TM18bHMhI9g0XU3ZmYRXuF+53qsd+jsrswTS50i9JfPY+mX1Nn3c4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XFCksN1f0azYSmx8KQO2EF6tv6QFp8ihOLSlrKmakKM=;
 b=PrpiuUocCwD1zRi7MT9A3WmSnVGC0D1EOnhYDmReNNC6tVWJkDclVNZYtFEh6lqW8NtowJbDCHZiLiwX4Dni1xGERb60hRQZpaJldzr2yorHcMbKRYHAAMqFLbbfncaS3/VJdm0LN/ZM+qRYnqwJSOV+T37dAX6g+MWLN4EhVMCMQcBatHRUWZ9wzSuWFXTHloi09kguXHFAmUxBr8TYV5BYb51X7W8EGecsgJJhAmCNK+Pdz+ijQArQEqlIiS/EA/MoNUWwfhO5G4EMceXcGe9P7Qsb+LLcsujnNe5D7/SUmWffpB+QmeWO79gg+eTU6qESds9Q4KxEqX9B/VPtHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SJ0PR11MB7153.namprd11.prod.outlook.com (2603:10b6:a03:48d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Tue, 5 Nov
 2024 05:06:38 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%6]) with mapi id 15.20.8114.028; Tue, 5 Nov 2024
 05:06:38 +0000
Message-ID: <421c5022-eeef-42b4-b173-63e52d6f4361@intel.com>
Date: Tue, 5 Nov 2024 13:11:13 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/7] iommu/vt-d: Make the blocked domain support PASID
To: Baolu Lu <baolu.lu@linux.intel.com>, <joro@8bytes.org>, <jgg@nvidia.com>,
	<kevin.tian@intel.com>
CC: <alex.williamson@redhat.com>, <eric.auger@redhat.com>,
	<nicolinc@nvidia.com>, <kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
	<iommu@lists.linux.dev>, <zhenzhong.duan@intel.com>, <vasant.hegde@amd.com>,
	<will@kernel.org>
References: <20241104132033.14027-1-yi.l.liu@intel.com>
 <20241104132033.14027-6-yi.l.liu@intel.com>
 <557b9c59-1ecb-485a-9e36-c926180a199b@linux.intel.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <557b9c59-1ecb-485a-9e36-c926180a199b@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR04CA0004.apcprd04.prod.outlook.com
 (2603:1096:4:197::22) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SJ0PR11MB7153:EE_
X-MS-Office365-Filtering-Correlation-Id: a28b68e9-ecf6-4793-ea80-08dcfd57a080
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aXNOWlQ0RGZMYnB4YjlVenUvZVA3dnhpSEtTM2M3Y1k0cS9wZXp2QUhraTBG?=
 =?utf-8?B?Q1A1UEh1T09rNVJOTXhONTA0eVJxbUVoUmg1SXBCeWtaM05Jck81Z04yNy80?=
 =?utf-8?B?RUtxZW9RQUpDOGF5WUFpT0VDMUJnQzZFVVhVQkNHd3QzeTE5Y3lIY0dYU2tE?=
 =?utf-8?B?Q3k4WnMwdUVYUExHejNheFJ6Z1FqQ3B5c2ovVFFpV2VGSDg3SlhlOFRqVmIz?=
 =?utf-8?B?RjhpbHh3blVBOHhKZHRUclZSVEU2ZW12VGtIN2ZheXdnN1FTd2pzTnBrRWNH?=
 =?utf-8?B?QnZKSjFMSDJIM3djdFFmWFduaTVrQXhqM3BNTHpTbXZmRkFsSER1bWpPaHhj?=
 =?utf-8?B?c2Vkb2FFUHJMVlhUTEsyVkdwVnVpUlQ3MEN0Y3lxcTlpSjQ1V29jOWsvZmZM?=
 =?utf-8?B?YUluL2FoNm1PRWhXNWlpQWtjcDJoQ0E1UDhacDZvNDlIKzJQdEY5M29pN2Vq?=
 =?utf-8?B?TWNLR0cyZFlyVytEZFlFRmsyR2dQanFiZFBFUmhxWDhMdWhZRmc3OXMzekJN?=
 =?utf-8?B?K3FLSGZPeDI5d0Z3MUFodEkwUTRjdHJaZ2ZPVGQ4Vyt2RHpIMGpKZ0NIc05j?=
 =?utf-8?B?QjlVR2RjTHE4emRMU05UK2JneVBKek5sdkV2T2ZwMGxPbDhkS01kZFVCc0o3?=
 =?utf-8?B?UTc0UHdmVGxsUUo5Sm9MMU5pSGQ0eTRSZTkramV3NmtwRzZKNllRbTRreitX?=
 =?utf-8?B?Vnppdm1WVGhhQWJpNFV2a2VGcTlnemU1SXFhSFVWUHJ5TGloRWtSa2RwMHdU?=
 =?utf-8?B?Y2pBUEV5ZkRZa3Nmdm5Lb2U0TGkxaGpqOUpnUlNkbWZVdlQ5cGFsTEY4Zll2?=
 =?utf-8?B?SHd1ZXhVL1RjNVJKQTMvdlEyeXB4SjAxRi9HSlo1YU9IMHRIWEJKcE84VDRX?=
 =?utf-8?B?WmFzK2xWbU1kbjRVZDYvUUNFT25UUkJQRXl5QXZmVFR6dUJhYWVNVitaRmRZ?=
 =?utf-8?B?Tk9RMzAzT2h0ekp6aWpBNE53TyszMVVtTEorSW5XUUFpOWhxZXRnUElRVG8w?=
 =?utf-8?B?WWIxT21hcHVPOUYxYTB4Qm5WVVR6V25DMjI1cVJUczZ2U296bWloUTZ0S2tp?=
 =?utf-8?B?QlJqR3Y2bGczZEt3aDN4N2NnVkdyY1ZBVjFjdXR6MXpnM1ZRemxuaXBvRVRi?=
 =?utf-8?B?bGVuZmhWWFJ0RWZHaFZIZWJkcldMMkxzeFdoek8yU1hKVWhMZTJpWjJRMXll?=
 =?utf-8?B?cWJMTG1jdWNxK2tHcTdZdzFDSXIwWTNpbTZ2SndJcWN1b2xZNGVVcVh2Y00y?=
 =?utf-8?B?YTB3ZjY2Vmo4ck9uNVcwNk9CdzBlTXMzWllJeDVVbmd3Zm1pZ3B3UlFxMSsr?=
 =?utf-8?B?QUw2K0F6TEQybjJodTdMNytTemZxbkZ4RjV2VHl2bk8yZzRzYXR1bWduU0dv?=
 =?utf-8?B?aUpaVlBjNGJ2L09kckpGWVVoWTRsODVsVnROOEh4VEljMHlvSFhubjQwakdw?=
 =?utf-8?B?elpkekcwVnFrS01yMHlJSEZiWjhHNFhvOU1RWGcwYVZ3ZmpjT2p5bU9rU09G?=
 =?utf-8?B?SUgvRjdRMmw3aS9pRFBBRlVUVklVbjhjR3h5Si9iUDlJTDFzdHJyODlFK2Y0?=
 =?utf-8?B?MVhxK25TcWVNbXMrWVlVaVdjSHpISE5qNVZYWmk5NHp6OXA0SFcrcE1Hb1ZS?=
 =?utf-8?B?Z2tmOUt0c0E4KzZBbWJtajYwQzFCOWNjUTc4TnBRZDg3QzZ0Y0JrLzFwNHVt?=
 =?utf-8?B?azBzZkh2THN3WEMvTitMQ2FFWUQ1T1pWRS9aMm4vZkpxeG01VzEzUDBsaEVm?=
 =?utf-8?Q?QeLrKp7hlwuDbxx1c8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c0RsYU5DbEFOY1VpbTBzUEIwZzVZdW1IVFFOT25XcTNJZmNpQWExRGQ3NzRH?=
 =?utf-8?B?dWp6ajlSWTE2MGRSU2xBVkJmbEM5WHBTdFZ0eklVODZ1R0hxMGEzY3NWL1Ew?=
 =?utf-8?B?eHJpdE5DRTBwNGpYTlplQ0o3bGQwQXQ3bXozcFkwSTNRRGVQS0YzYXRqa09H?=
 =?utf-8?B?bDVUR05nNnQ2TTRycEtpeGVzRENYd3R5YUZRYnl2dUh3VGtVenRmYjZVbFBv?=
 =?utf-8?B?OExwL0tWdmxvM2xPalZHZTI3Y25STjVrTEpQdTBtSnhacEtLbjl2VFZ4aCty?=
 =?utf-8?B?NDQwclJXRmtmQ2NOWW4zVUdvcnEwa1lIL3BtcHAwSjFaMHYxdWpFOHZVajBu?=
 =?utf-8?B?NnJsdW9RZC9yL0RIb2w0aGEyZm5WM0lvdXdXUitnbm81ZXN1T0dSUHB5eFVu?=
 =?utf-8?B?SlpjMGxTYnVQSDRvQnVCbmZkcVJ0TWVEdVQ4Ymg2c1JvbElkclc2L2pLNERn?=
 =?utf-8?B?eHhtTUZLZFM0Nlc4bnJPM2I3aDUvWFRKQk9yYkM0TEhRRGtKRXQ5blV0Q0Ez?=
 =?utf-8?B?UDR2REsxamp3bXp1NmZoYlppRm1wck1wN2Z5R0pZUEVkaUJlNTB6d3hXaVRs?=
 =?utf-8?B?SXcrbVBvNUN4K2pyMzgwc0MxenVqRGZyS0YrYjNhdUN2NGZQZ21OKzdWRmIr?=
 =?utf-8?B?QlBzZENLZ1NEOXFhd09xdStEaHpzNlhpcTNySXlvQTB6MEplWmZUZHB0Ui92?=
 =?utf-8?B?alNQYzF5NDBHNm5aZEhwOFRRbnBlaURFQmcvaytyUGRRVGFrdGJlZGJCWFVY?=
 =?utf-8?B?TDlIS1JYOHhGZWpuNHBRUjcrclpPMk93VDYyWGFHZUlOVXlLSWhqWHZla0I3?=
 =?utf-8?B?eFRnVm1jY3dSa3NFRE43TWRyZEo2Wmw2SGhCRjBCeFFQVW5mQWNSemZTcG5G?=
 =?utf-8?B?M0ZQM3lIcUFtTVZqNmZxc1dvNjRBbllmQWR5a0NkVFVObS84Z0lyVnpTcDU1?=
 =?utf-8?B?YUsyM1JlZGdoVDBJckNyRTdUMDdTZjdOTGVSaHBtc3UzdktMWE5idFdjaHFu?=
 =?utf-8?B?YWVkMjUzVGlNUkZkWWlydzJwb0ZwTkhvaXJrUVRlVGhCOUJMcldhdWdML2xn?=
 =?utf-8?B?c20rb253NHJzRE5Wb1JLL2pqZWR0dGdwZXpqN0JVMGFubDc5MmpLamlWZXh5?=
 =?utf-8?B?R1VWTzRBWWtPTzRlTkNSRzVSZ0FqdnpxVExYQmZIVlNDaFdheElUWFVOVkM4?=
 =?utf-8?B?ejJJUnFINk5LN3lIUjloR0t5SjZyekw5RXBRRkQ4TXZIMDJ2bExZelB4OWxO?=
 =?utf-8?B?ZnIyN0JJdHBmL0ZaRzZqbTBDQ2VjTzJlRDEzeGVOTXZRVzVLay9GQjczeWti?=
 =?utf-8?B?bkJSUVk0bytMcElpSVZpajVpdzJScnJwYk5ySmxnTTVncUpGTHBMbXRIemJ5?=
 =?utf-8?B?Sjk0ZTNoV0NuMjRjcUNlVDl1R25NaTllTnAzbTJDVnFJOUQ1ZUFRNjIvejV1?=
 =?utf-8?B?WUlzdFZRaHRMcHdnZjhyNUVyOG9xUWZ3Q2xrVDFYcFpOcVhYZVFMdXc0REJ0?=
 =?utf-8?B?Sjk1MGd4NmhOeCtUTkFNYkw4d1ZSR1MxVjZEQUlLTHQrbm1pcjdNUUxBMWJH?=
 =?utf-8?B?T3prNytaeXJZL0JYamZpNXg1VEU3RU55ek1SeUdWUS9JYmNUOGJobWFDNDgw?=
 =?utf-8?B?OEhjcHMxTlRRQkVSY3VoNHJ1V1VxbCt1QmE5cll3ZFRlTzhBSitISnM0Um9Y?=
 =?utf-8?B?ZGlyK3FUcGpISEw3SkFvVmhqcWJ2TDBqc1lWRkh2VnA0a2l5dS9DS1E0NU0r?=
 =?utf-8?B?THdFWE1ydU1FQW5FY2VwZWc3eWp5YUFFaUpFU0ZIZlFzU3pNL3hrb2JpUS83?=
 =?utf-8?B?SzduRG1Zbk0zVDRQNkZBS3JkSDBEUGlMTDlKMHJvYTFleGx5ZC9tTmN4aVNL?=
 =?utf-8?B?L1VtNXp6UzFKU1lWU0dJVS9GRng4NVJCck56Y29aalZ4bTRqTUpUS1hsUXVo?=
 =?utf-8?B?Q21qZGRZVXE2SmczZC9jb0FHNXB5SkNBL3d4ZElSY0xrQWwrN1JQTjZRMk9P?=
 =?utf-8?B?YllVUlpFeURUVmoyQ2h4QUZwSTRzaWUyU3Q5SThxVWQzVFREQVI5cDE3VHNB?=
 =?utf-8?B?eVpwOEsvQmFVdXpIcEcvMzlOWVZyeW4vZkhwQ3BkTHNYVmlkbmNuZHdFVVYr?=
 =?utf-8?Q?P94ctEbd0X8Au7lIt7BZvEe/4?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a28b68e9-ecf6-4793-ea80-08dcfd57a080
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 05:06:37.9849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yOvAKvN4gXiep5Mlr70XSLG5FAbQ9o70VfS+3rNTZ52LbFTAdFcROxulrLCfYvulHtlS505EGJbu4KvWMa6M2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB7153
X-OriginatorOrg: intel.com

On 2024/11/5 11:46, Baolu Lu wrote:
> On 11/4/24 21:20, Yi Liu wrote:
>> @@ -4291,15 +4296,18 @@ void domain_remove_dev_pasid(struct iommu_domain 
>> *domain,
>>       kfree(dev_pasid);
>>   }
>> -static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t 
>> pasid,
>> -                     struct iommu_domain *domain)
>> +static int blocking_domain_set_dev_pasid(struct iommu_domain *domain,
>> +                     struct device *dev, ioasid_t pasid,
>> +                     struct iommu_domain *old)
>>   {
>>       struct device_domain_info *info = dev_iommu_priv_get(dev);
>>       struct intel_iommu *iommu = info->iommu;
>>       intel_pasid_tear_down_entry(iommu, dev, pasid, false);
>>       intel_drain_pasid_prq(dev, pasid);
>> -    domain_remove_dev_pasid(domain, dev, pasid);
>> +    domain_remove_dev_pasid(old, dev, pasid);
>> +
>> +    return 0;
>>   }
>>   struct dev_pasid_info *
>> @@ -4664,7 +4672,6 @@ const struct iommu_ops intel_iommu_ops = {
>>       .dev_disable_feat    = intel_iommu_dev_disable_feat,
>>       .is_attach_deferred    = intel_iommu_is_attach_deferred,
>>       .def_domain_type    = device_def_domain_type,
>> -    .remove_dev_pasid    = intel_iommu_remove_dev_pasid,
> 
> This will cause iommu_attach_device_pasid() to fail due to the check and
> failure condition introduced in patch 1/7.

the check introduced in patch 1 were enhanced in patch 3. So removing
remove_dev_pasid op does not fail as intel iommu driver provides
blocked domain which has the set_dev_pasid op.

-- 
Regards,
Yi Liu

