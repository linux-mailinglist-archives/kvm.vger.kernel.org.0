Return-Path: <kvm+bounces-16212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C2F28B699F
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 06:57:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC0511F22A9B
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 04:57:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDE8A14AA7;
	Tue, 30 Apr 2024 04:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Yfz4+HTF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696B614A9D
	for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 04:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714453055; cv=fail; b=NvZZW+PZf4AygrJu1DrBGhzpMojkfh2fINTYy50wunx9K4GHk+TSn1f2bUCxXTMdTs4nvuoQY48byFhB7EzdjG6qcHiiT395UnMmap7layyokxswJVnUfh1V5dw1xNtk50Pe5GUmDk6aSIuxJa3/tZNqFhAwjvbxVqdmTKfc+o8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714453055; c=relaxed/simple;
	bh=RqTISGbycSCV4trLaETZ2sLs+jmkc9DGEbuaACo7JHM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aPkuckscYk1QFFwVet2rwKhOMJ9igSUebwmJUpURuVIW56iHsqoaR78eTJbc/ec4M1Q/UIpFU8JUPqJG7ZdQXEds5jvWEQKTvk7pEPVL3blemsIMvnVCSdUzKKe6YCWBwZhf5HpWmwr1EJo8op48ASZi3mLXXaTQnYGvDAtXH4Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Yfz4+HTF; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714453054; x=1745989054;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RqTISGbycSCV4trLaETZ2sLs+jmkc9DGEbuaACo7JHM=;
  b=Yfz4+HTFciAEgzUII33iNEb4QD6vZXPE7ecTAcqaIjCSjIlgLR1jWaTK
   2f2l20zfkvrOuoIT9Pyet/EXcv3FUMB7EVADqpF0hoCkrvJSJdOPiFmGm
   jKB+ip8aCyMaUUKAbW46SxpDcD3d4E4MUcvJ0QVRj6VToJq9lZjQUcuQW
   1Pb71JNO8hY2xzP0AevaPm6aoEHIAMh2t3lujykBfSOq4LkfzEMrsKXHn
   XThnxNlXb48srHLZSBj+veCgY26LpjsKaeDk9eoJfTdsa1pAzy3kKlj1Z
   QzsMQKFzXYgIiwzLXDj9T/tzJFzlly2ztqRC3oR9Lhm4YXGqS5YUzzURo
   Q==;
X-CSE-ConnectionGUID: vGZtsuMqSwK19nxisUT+uA==
X-CSE-MsgGUID: 8CU2748NQGKdBxuDjd67ug==
X-IronPort-AV: E=McAfee;i="6600,9927,11059"; a="21556957"
X-IronPort-AV: E=Sophos;i="6.07,241,1708416000"; 
   d="scan'208";a="21556957"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2024 21:57:34 -0700
X-CSE-ConnectionGUID: jngiGgo8QVi406sWqDlTwQ==
X-CSE-MsgGUID: FMlxKZ6xQYepCAF2q4mWmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,241,1708416000"; 
   d="scan'208";a="30786936"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Apr 2024 21:57:34 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 29 Apr 2024 21:57:33 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 29 Apr 2024 21:57:33 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 29 Apr 2024 21:57:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L37bdG4F4Lt2O9vgTA5nRWLzPHG0wM3MY6EPFbttYTDTTqW87YlMsspMgs4ZmEQ69Z7XQqvUr+6gpRp3OBtKrQoI7dUTdsh+PvaOeBGB+q1cfWWSsKfNbFVNMZAqdg3pU9Kz4w5+Xzt1xLc4RMWq771IS3Eh2JiI8u6UF0SqW1SSwLq8+9y052NbX5VuNxtieJVr63lW+Gd4m6o6xlYIAoJxfsHIKkO6DwWm+lBmvoL2Tyee0CsGgTY5MDeNudwSSc+zoQ4vFMFaal/S18ixfupYFxv1U07X8cpqgjtwgGo9zjTtbD3QGKsANWimaQKqH0vmxvY5C0VKpPlKS0DWrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wINqqusjVBXvhJM6a908pAEBnmS0iX11wlZoRyoSAws=;
 b=HAa6DUZXFf4+hvHk5YCBrjGhZY42aOHvl/1ujtQQS/66evxYiZA6B54Swh6jq7rfe1D6JCgEkLGHesPVsqtDxUcAWTIqvdTsLkEpeUJdd/Y3ZakzOOZhB5paKrxG56VgjHyrlfUvAAZtbgdLKYLEUUlg/wiFJme9jMhiL4MFc8YQZsQwEV5a50b8j4HLGQmbFMV6eCa47m7xVst/GLiB1KmQu9C+OaDAnLIMA3yeY9H0IEn17WGBTQEFnteHu144mEa9+MgPeYitokKZoyjvefVoWjE/cJTVcVbYP5X3gCYLj5yxd6XywyJx0IfiAF7I8nzQ8Yp75mjwhaJUIy8bxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CH0PR11MB8213.namprd11.prod.outlook.com (2603:10b6:610:18b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.35; Tue, 30 Apr
 2024 04:57:25 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%7]) with mapi id 15.20.7519.031; Tue, 30 Apr 2024
 04:57:25 +0000
Message-ID: <00a1bdf1-1539-4960-93f9-6290307744f7@intel.com>
Date: Tue, 30 Apr 2024 13:00:57 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/12] iommu: Introduce a replace API for device pasid
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <joro@8bytes.org>, <kevin.tian@intel.com>, <baolu.lu@linux.intel.com>,
	<alex.williamson@redhat.com>, <robin.murphy@arm.com>,
	<eric.auger@redhat.com>, <nicolinc@nvidia.com>, <kvm@vger.kernel.org>,
	<chao.p.peng@linux.intel.com>, <iommu@lists.linux.dev>,
	<zhenzhong.duan@intel.com>, <jacob.jun.pan@intel.com>
References: <20240412081516.31168-1-yi.l.liu@intel.com>
 <20240412081516.31168-3-yi.l.liu@intel.com>
 <20240429135512.GC941030@nvidia.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20240429135512.GC941030@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0051.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::6) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CH0PR11MB8213:EE_
X-MS-Office365-Filtering-Correlation-Id: fd283bab-4891-49d3-ca1a-08dc68d206da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|7416005|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?b0tMNmFOS3hGRTRIQkpFVTJiSXMvR0U2ZzdYeEdHY2tud1dYK2YyTHI2MThB?=
 =?utf-8?B?RFROS3l5N0hBYWoxek1ya3hna21tUnFDdTJyT1ZWUTZEYkZydExJaFloQWh1?=
 =?utf-8?B?WDhCc3V3VGNBd0QvWE9zSGZKa2h4bUljbEdJcGtrWGN4UU9uWHo4WEtqMGww?=
 =?utf-8?B?b0wyUXhxU2tCK1g3bTdYU0hpOU9kbUt0MUVKQVhoOHNCY2s1ZS90QWhIbG9U?=
 =?utf-8?B?NmdIMVpsVEZXcGtEQVEyWGJiNENCdHBMb0hFRVQ4MGZBbmQ4TkFjdVplUld3?=
 =?utf-8?B?ZldjbHdmdnBZbEYyQ2J6VHRyejNOZ1pTV1FJeEhvMGJLUHNpVkhvbW5wcUtP?=
 =?utf-8?B?R1MrUlRacnBpR09kVUZjellNSkVLdjJsTEdTQUJXU2xvMlZYTDMvM3pvUmFS?=
 =?utf-8?B?cEUxY3ROZkVuRDJQT2VHOVp5M1orNTdFVDhPelBSKzFvYzdYRGIvMjVnN1Ru?=
 =?utf-8?B?Tks4anp5U1ZmUWw2cC91YmxZVHJBd3hnYVFPMGwyM05hMk95NVNHNExWVGNo?=
 =?utf-8?B?WU4rYUYxQUd1R0JNb1Ezc0Nlc0lrNERpdkhzOVJJbkMzb0pWTG5VRTlXK0ov?=
 =?utf-8?B?VWZkVXZUeXQvUmpkalBWUkpqM2wyVGdwQTlnQnFpdUVqNmdIcENRWGQxWldR?=
 =?utf-8?B?dFlGSzA2dVhHM0dDU1VtTUlLYVNtdFJDczc4WU1WMzA2SjBVQWlkRVJPMXNB?=
 =?utf-8?B?Ym0yckI2Z3pQWHp3K0UrNDFGTVhZNy9XckhvN1d5TGhkb21jendEaWd3Mmln?=
 =?utf-8?B?dmZ2ZVZXNUs0TmplUHBGb21MYk5JbUhjMVo1TDY3d0pkdnNFaTdCeVNaMFdG?=
 =?utf-8?B?WTZzb2hlRXJIMVFEd0FmZnJaR0kzM1VlUjVadDhMMUp2Qmdmcmg4Rk45ZHkr?=
 =?utf-8?B?dTBqVmhFRTdnUTU2MVFPVVdXN1FmbzVjT1FmOHRRQ3cvVmNLenhNd1lQVEY0?=
 =?utf-8?B?TTJXL0k4WUM3Mzl0d2NoclAvd0dSN0ZDTVJabk1iZlQ3bStiWHFITkFTVkFF?=
 =?utf-8?B?WDUrazJxS0t0ZktLZkwrM0ZWTHZDWXduQ0Y0SjFBTWQySTIveGdCUXhiTjQ0?=
 =?utf-8?B?aExXTHFHUng1ZFl1ZTkrdHl1Y1duSHZOK05HdGV4MWpTZ09xYjk5YXE1Y0w2?=
 =?utf-8?B?K3MyTWVuUWV0ejRGamViQ3pnUHVRblVQM1hCU2h6REROSkdjdVdMU1lhSzVi?=
 =?utf-8?B?WTYwNUhSdEliNnYxTmZLY1Y0UXdkdkZtaUNzSFBQdEdtR3lqNXgyUzdKRTgw?=
 =?utf-8?B?SUttcGo3MURmZUNZWkd5YjJXOW5mN0d1UGwrUHlIVHdocmJGaDVld1NjQ3Mz?=
 =?utf-8?B?TXp3N0tINmNmV2lyL01lUUFmb1RESHZ4TlJMYjdvUnE3Q085SHJ4VGhDemdm?=
 =?utf-8?B?d2Rhakl5ZitndVFXeVptYTlTRDhtbTlDVUdiSWdJZDJDTXZlSVFRamUxNXdj?=
 =?utf-8?B?bFBMajdHVGNBV2hQeWtlRTlYYjlkdnQwN2cyeDdKMTEvTm1kNzNFR0p1SEND?=
 =?utf-8?B?ZFM2cTZTSFpSc3k0RnhLTThMTzdrNjVkQUN1QTVoZXFWUjlBWXI0eGh2NXh3?=
 =?utf-8?B?d3lvYmhPTnNVN3c4RzJYaUFPYjd6cml4ZWl5cGZaVDVRMjJzdHVXV1Z0V0RR?=
 =?utf-8?B?eDluOUJxWStYWlVOQjZoUnA1RFdZSDNNcnkvLzZCQ0duaDhLZU1Fb0JZNUVv?=
 =?utf-8?B?V2JuRzNabTFTVFFvdVIvZllGTmJTLzBJQmQ1TjVFeXZoaWJaemRrS3J3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UWZjUExIeXlXUjI1ZXZGRURFVGV4aTRvZmxTdjR1b1RLVzZjcUJzL3hZWlNT?=
 =?utf-8?B?c2c1MUM3UDJTL3NVYXpmSTFiVHR5OHEwNm9KamZlNWNhQ3NjcDJnVnljdVlE?=
 =?utf-8?B?OEdQMW1QWDdtckFPekxVNkZYWkl4R20zeTVMODlmbExGYUtuVjZPSEZZcklq?=
 =?utf-8?B?LzErTlFvWUora1EzZGxUMXdJUndranBJYzF4VmhRaDVGT0NvWDA2NWx6bWxy?=
 =?utf-8?B?SEk1S3JDRFM0M09NbzhYMmpJTVpPVVhkamhoa0V0a1B0bk1DM3R6U0MyZ3pY?=
 =?utf-8?B?ay91bm5MRXA0VUNrbnpOWGVtcjc4N1B5QjJabGh5bWppMVdBSGduL3RNU284?=
 =?utf-8?B?dHdpQStoQWxma3pvNWVXdmdDaXNnOGFRNUJzMXlsUExrT3dqQ21iUFR5ZjVS?=
 =?utf-8?B?aUdYQndSWHZ1M3Vjdmd3elp2d1VYK1VqNVArL09GT3ZTcGVZVXMwZ3dnTllz?=
 =?utf-8?B?V1BxZUU1cjlmc1lidlJ1b0VzT0gyN2RQUjB3Z0VHZ3kxYXBkRlNPa0JVYWt5?=
 =?utf-8?B?czE4UFJaWmtZM0d2djFNTktxY1QyNDcxbWNaS2pxZVNsZXBBQ2ZCQXp4Z1pv?=
 =?utf-8?B?c2QrMmFBVDhaTU8xeHZGaXkrWUdhQzFpZGVjUXFmVmdhM09ucDZ6UjlHWTNa?=
 =?utf-8?B?Nm9RM05oSHJqS1lpR0RHd2FKemdINXYwbVhIUnpsUDVLNXhGelJLRi9PTVZ3?=
 =?utf-8?B?WEZwWjF1VWx5dEtIWSs4Z0xCUEhacDRnc1Yxc0hiaG5GYTlsNmlET1JKRWpD?=
 =?utf-8?B?aWtJWWJjcE9jWTcyN0VNcVIyRy94T1BrdE1YbXd5TjFNNjZYM1d2VENLajMy?=
 =?utf-8?B?VXVNamdKL08wTFloWC8raEFGbnQwcVpJWEdFa0h4M3BpVHdzVGNEWm9lcFRk?=
 =?utf-8?B?Vks0NUFiWFNJZVZPZWNLUGpvaGUvMXlKa1djV0ErNGc4blFEQkxXeTB2NDJ2?=
 =?utf-8?B?aUJxRlVXMzFaNjdLamdLQUQ0YzJLZ2JLRHVXRnBFanRCMmZ1eDh1ZjNZbSty?=
 =?utf-8?B?Nm04aXVHWldKRnhXS3pHek45MkNBamNwaVJTN0VhbnpGWjhleFUvMkUveUFn?=
 =?utf-8?B?bU91SEJuVmdWUExDaWRTa2JYektvZXptM2JZZVIvTjIwbUVsZUpQYTB6dXY4?=
 =?utf-8?B?bENYdFBxTEd4TDBFM2QyU3cyNzYweHdWWW5sWCtVeW1weVFNaVRMdWNxSVNX?=
 =?utf-8?B?MXVQZjJmbjJNanh5N1BTeTR0YlA5VGI5NEtpaFZrUVRZOS9QU3oxaGxuVjg4?=
 =?utf-8?B?dllLMzBPWGtIdy96bnZSRWczeDBVd0Uvd2JxOWFWckMxRHd1VUM5bXNVb3dB?=
 =?utf-8?B?Q3l2bDVDRy9GcWw1S2NMKzFHRkRrR2tBYWxtYTJONWNqUDZ6QlQzSXlQVEUz?=
 =?utf-8?B?Vy8wbzZHT01ZSUZNV25GMVNNb1Z0dUROY1ZNLzdvN29UQkthaGY5TFdxalNy?=
 =?utf-8?B?TnBJMEhFblRRV2w2VGg1cFZUaTRRaDJsMnRCWXlPZDFGVENoODdndFVUcWwz?=
 =?utf-8?B?VDBuU0k1NTJ6dTdBZExnbGdaRC9GNGFFSys2RGgvVkxCNmFKZXVGZllHTitT?=
 =?utf-8?B?bmdNZjZ3anNTZUhBenpBNlR4RjViWmJEbkVQdllwcnJMZkRNLzhmMnBwQ29o?=
 =?utf-8?B?RmxMM3hSR0JDR1YzejRFbzZxeWk1M29ML3NNT3dMQ0RHZFpxQkc2N1Z1ekJP?=
 =?utf-8?B?SkJ5cCtHRy9QVTN3Qmk0a0lHK1ZDbWNlS281N2hrd2Y4Q1J0YmUyVVg4bEV4?=
 =?utf-8?B?eGVZSTJBUktQS21tYnRGYUk3RWUxWU56cnZjY3JJNVh0bGNqT1Nmc3VDTk1H?=
 =?utf-8?B?cnNTaGxxc3ViNEpUMWZaREdwMXR1UkNqZXhwYkJXQTAvRkRKbjJ2VStLcmN4?=
 =?utf-8?B?WVZaZXU0NTFxN0hjWVYwMkpTMmVyUUpSVm9lOE5zNG81Nlh4bXh5TWYvTHM4?=
 =?utf-8?B?YXdLUGZNRzNJRTVCTHFRWlpaSjUvN2JSQUU4VVV6eHVhV3RwUEhXTktMOUlr?=
 =?utf-8?B?Tk5CQmhUTzJ3MEZ1Vi81bW5oMzg3amNvNUFVNTFnenl3cEFhSXp4UjJkUFFI?=
 =?utf-8?B?QWZRRTVMQTRQMEt0Tk80aFBEelBaMEtYOTlsWUE1ZStYdDdzdDRJTVpONjFi?=
 =?utf-8?Q?rR0W4Nj6F6CeHYwaAs5LMak92?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fd283bab-4891-49d3-ca1a-08dc68d206da
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2024 04:57:25.0766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rvwx1hRUTaH5akLz15DYlew/lvGZrn1A3koo2yOmIVuaIKre223wl80CBjZ6rO04MgDtyN/XNT6kxQtonIj2jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8213
X-OriginatorOrg: intel.com

On 2024/4/29 21:55, Jason Gunthorpe wrote:
> On Fri, Apr 12, 2024 at 01:15:06AM -0700, Yi Liu wrote:
> 
>> -		if (device == last_gdev)
>> +		/*
>> +		 * Rollback the devices/pasid that have attached to the new
>> +		 * domain. And it is a driver bug to fail attaching with a
>> +		 * previously good domain.
>> +		 */
>> +		if (device == last_gdev) {
>> +			WARN_ON(old->ops->set_dev_pasid(old, device->dev,
>> +							pasid, NULL));
>>   			break;
>> -		ops->remove_dev_pasid(device->dev, pasid, domain);
> 
> Suggest writing this as
> 
> if (WARN_ON(old->ops->set_dev_pasid(old, device->dev, pasid, curr)))
>      ops->remove_dev_pasid(device->dev, pasid, domain);
> 
> As we may as well try to bring the system back to some kind of safe
> state before we continue on.
> 
> Also NULL doesn't seem right, if we here then the new domain was
> attached successfully and we are put it back to old.

ok, and given your another remark [1], there is no more need to do rollback
for the last_gdev, just need to break the loop when comes to the last_gdev.

[1] https://lore.kernel.org/linux-iommu/20240417121700.GL3637727@nvidia.com/

>> +	mutex_lock(&group->mutex);
>> +	curr = xa_store(&group->pasid_array, pasid, domain, GFP_KERNEL);
>> +	if (!curr) {
>> +		xa_erase(&group->pasid_array, pasid);
> 
> A comment here about order is likely a good idea..
> 
> At this point the pasid_array and the translation are not matched. If
> we get a PRI at this instant it will deliver to the new domain until
> the translation is updated.

yes.

> There is nothing to do about this race, but lets note it and say the
> concurrent PRI path will eventually become consistent and there is no
> harm in directing PRI to the wrong domain.

If the old and new domain points to the same address space, it is fine.
How about they point to different address spaces? Delivering the PRI to
new domain seems problematic. Or, do we allow such domain replacement
when there is still ongoing DMA?

> Let's also check that receiving a PRI on a domain that is not PRI
> capable doesn't explode in case someone uses replace to change from a
> PRI to non PRI domain.

Just need to refuse the receiving PRI, is it? BTW. Should the PRI cap
be disabled in the devices side and the translation structure (e.g.
PRI enable bit in pasid entry) when the replacement is done?

-- 
Regards,
Yi Liu

