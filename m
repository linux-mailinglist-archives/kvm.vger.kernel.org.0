Return-Path: <kvm+bounces-41202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7C9FA649A5
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 11:25:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 28AE816805C
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 10:25:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8A75238D22;
	Mon, 17 Mar 2025 10:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aRdKU9Md"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F07D235BF8
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 10:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742206902; cv=fail; b=rtlPcwwrEbl1PJ4CCdysdqW908ilv4OktRaFQ+MOaiwWlhKeF1MZyuqLTqeMJ9wG00k6zRmSQlTEq/erI5c46viENQKi6Hc3vOaUlcMxDxXuo9zyoIPPzkoUeidE3ETH5S9h+RW6YY42KSbHaZPV3wDR/zZ9AslMzSVWyu/rDIM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742206902; c=relaxed/simple;
	bh=8eZwxGQsbwUhmKhXiHWiRZVa17wjcE+/wofsYMVBd1I=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XmLEjtanLdjMhCQpU4ynBZmlFxIs1r2Np5a0zJ2TaeXpP704frHmStms91yXf5KqSlHwjLuma5p3m41xf+TOOJ4Wl4jojFxc2vnqGkkOqLvPVDDooDVslTx2gAphMm4UQinsj1vhn7JdbDeo/gICQoIy9nOuPaobt8BSluCzCtA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aRdKU9Md; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742206900; x=1773742900;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8eZwxGQsbwUhmKhXiHWiRZVa17wjcE+/wofsYMVBd1I=;
  b=aRdKU9MdrC2TSP8sqHmQmS625tK5glFW7bojRdJmUMwuJIkceXdaB06C
   eHfeLrXTJoYX9m+NIyweEkSOpgVMDPTMyR2H3OEwzU4U/inSJ4p1N28uo
   IJgdhUGtP5ip5sBmZWB8BVgiTailwhyZWwigoc5aYzHcmfDcb5E9WRdH5
   8DxBKewW1ucl2+ssHiqYQoZ5p1cyxv3qPxDKi72SWK/EYEr5r1KKLu6C7
   g0tiHJFbasycaNAK7IKcYJBuE/VH3K+04VXOSzWuxL6lmsqDWQqn+sPny
   kjhr4dSQUe3kmxO/MQO2e/lndZrhXtla+nfkhkiLktKFbTuHGfWKP0Ato
   w==;
X-CSE-ConnectionGUID: gc4GMeZUR/K7EVZjrjHi8A==
X-CSE-MsgGUID: fdPcMF0vS4OEC2R0fffQkg==
X-IronPort-AV: E=McAfee;i="6700,10204,11375"; a="65758085"
X-IronPort-AV: E=Sophos;i="6.14,253,1736841600"; 
   d="scan'208";a="65758085"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 03:21:40 -0700
X-CSE-ConnectionGUID: eY//4nVpSPC4jJgvCu/Rsw==
X-CSE-MsgGUID: D9gG5JcYT2OSb1azQQBkCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,253,1736841600"; 
   d="scan'208";a="121706230"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 03:21:39 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 17 Mar 2025 03:21:38 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 17 Mar 2025 03:21:38 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 17 Mar 2025 03:21:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NX3SDSPPAxGrWCnS83Ie19fS5CtXY/THVtMayvXHp+RokAYmHtlFXgbGE3AkoHFSOjzxdw6yS7Vd5GsquTudoz2Zh1KBvgrGfZc6JXNNI7Nd6BHwawB/faV+A1mk84DBrN59GXjrketzZxAF6pAsSWDSORyDV7d2IPD1d5TDkXamYnyLZRpbw7gOCRRYX4fmHLrcLcce+bUroGG8Br1Piz8llRHgIWKPNYDgLdwJ4Uzj/TbgbKZmJdwNNV0a60Gg0vt2zWpZdmTkVK0kzJp0iOZ17CoRfazqDNSs7hZAhsETSuT8hB4I23YYNDrUf6o8JqQJjcGdHmR6HCESOoYgRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EvTxy2OKg4NiQdp52nxJblkmdzLDUV9ZVmp9A+Maat0=;
 b=FFXF8ibDiZUBn7LoQheIT5FE0dfkNKfvv8qWOLtX0XxD6ywMOHHKK5FIr4lXJ+MJtIrBGs53mtwhwPmBncIaGUuPi5+R5j4daSEqypYOiE2of9ypGbAjo1CQDmGKs4RE1Gx4ieAOZS6iuUojzc5a8Jx3QTLmtCbE8jGTmzuJpTKA4mAAjXZBUlDA4wEhqJmknlFEXRyAg6OIpMrCES6rQ25Eger3ZI7cODTnVnbh3qt0bxn8e1OgI/uH1nc+QHwqmKfVboOobWruGG1G3t9fihpidJNpX0QEXBiJsBIY7rhKMF40IvS8aKNiQWl1yof3aTm7Zo4MgNnIQUdlwEAkfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 CH3PR11MB8466.namprd11.prod.outlook.com (2603:10b6:610:1ae::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.33; Mon, 17 Mar 2025 10:21:23 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%7]) with mapi id 15.20.8534.031; Mon, 17 Mar 2025
 10:21:23 +0000
Message-ID: <ebc6f8ed-3525-4bd8-8be0-143b1c7e75ee@intel.com>
Date: Mon, 17 Mar 2025 18:21:13 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/7] memory: Attach MemoryAttributeManager to
 guest_memfd-backed RAMBlocks
To: Tony Lindgren <tony.lindgren@linux.intel.com>
CC: David Hildenbrand <david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>,
	Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>, <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
	Williams Dan J <dan.j.williams@intel.com>, Peng Chao P
	<chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>, Xu Yilun
	<yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>, "Maloor, Kishen"
	<kishen.maloor@intel.com>
References: <20250310081837.13123-1-chenyi.qiang@intel.com>
 <20250310081837.13123-7-chenyi.qiang@intel.com>
 <Z9e-0OcFoKpaG796@tlindgre-MOBL1>
 <b158a3ef-b115-4961-a9c3-6e90b49e3366@intel.com>
 <Z9fvNU4EvnI6ScWv@tlindgre-MOBL1>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <Z9fvNU4EvnI6ScWv@tlindgre-MOBL1>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0008.APCP153.PROD.OUTLOOK.COM (2603:1096::18) To
 DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|CH3PR11MB8466:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d47d118-4b5d-4d49-7811-08dd653d7761
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?S3dMSjFHVzM3VytkdlYzVkpZOWJQYUw4ZGpvZUhBQjgvZjRXNVpxNThrQnZP?=
 =?utf-8?B?aHgzZ0NrNWE2L1VtRVpDTW0wUE5JbDZYSVNtR1d2c2VDNzQ2dVplYzdod2Fq?=
 =?utf-8?B?RG9OYm5nd1gyVzBwVnhqMHdrNnNETVNSdW9UL0NvbFZhU29VVFdKcm1UakJz?=
 =?utf-8?B?K1VnbEpmZjBPYVEzeC9ybDQ3bXE2dFAwZ0NkME8rNzNTOS9McGNLVnkvNm9B?=
 =?utf-8?B?bkdNeUU4OG1uM1Bvc0JQYmlrNGJNUFdVUnRuRVc1TkJOUDlsSXZCOUlVSWlm?=
 =?utf-8?B?M3ZDNWN0NDZVcXNXTzROTUxuK3N0cjJZSmZOUmJrcXprSm1RbDJkMUNubmhz?=
 =?utf-8?B?bDhFNm5UcUd1OHczcG9LSS9yd200ZCtENi9GcVBwcDN5YmliVWtsVHM5NGJi?=
 =?utf-8?B?bVN0MXl4eGlPWWRZZisrV0J3TklMQmtPck83MGxseCsyQUlnT3hlWFNubGpU?=
 =?utf-8?B?c2lRNFE5azJoTWFYNHFkVW1GRnBMQUt1U1B0R0dSenF3TWZNekRtS05ZZ3Bq?=
 =?utf-8?B?OC9RYkZaT2s1OHF6U0t3cnRGSFdHd09mM3lMOEZNc2Ewb0NLS2syN1AyY2x3?=
 =?utf-8?B?dmxPbW4xc3pnMTFxVG02WW51bi81YTZTeHNQbGo2V0hOVlNXK3NYYWJaRmEw?=
 =?utf-8?B?ekUyMEpkV0QzYXF1aXRVNXJPK2pRTDNDbDF2L2VGcC9hYWlZVktRNC92Q1Zn?=
 =?utf-8?B?UXo5b3I2ek9Va3RQVThRdWt4K3U1R2ErcXJ6ZzQyc2p4RUdVS2hHNzNDZWlH?=
 =?utf-8?B?Z3p6cE93VGRHOHpzTStnb0xiNko4SGpwL1NDV05qRncvbjNpN3pFTklacEc2?=
 =?utf-8?B?TndMMzF2cThVNEV5bFhHdHlJY1o3bGpWT2dmVk81VmIzZXRhd3ZtRkpkblJL?=
 =?utf-8?B?aDdNM0FSZGRZWEQ2QjRGVkhUZHBsUHBuVFpKS2g0bjY0UXI4aE95WVpkd05H?=
 =?utf-8?B?TFFuMWgvYXV0NGxTc1N2R0tQdWQ0WE5kK0N6bktaV3dZaVJDU2pKc0VNa2Vw?=
 =?utf-8?B?ODdEQlVNYnpnTEhxSEl1UlFCcTNRZk1xb21LVjBQRzF6WW5XbnIxT2xkTnRM?=
 =?utf-8?B?TFJDN2xDckJZMEFhbmNtMVBpR2twZmJFcU5OSWpWSGFaa3duQ0M0MU41ZUxx?=
 =?utf-8?B?OWViZDJPeEdPSVdrVk1yWkdvZDJiM0hxZXNtWEpJbTN5WHd5UG9yVHRRUU9w?=
 =?utf-8?B?b1hablZ6NzNaaTRmaTYyT3dWTkl1SzExMDE2R1I1UVdJSnI0M1lNZTlwMVJE?=
 =?utf-8?B?WEtEbytUaDFwVTB0bk9VSVlsN1VBTUN1MTFvbVU3NVRUTjdvYmNYS2xBMjB0?=
 =?utf-8?B?MDV1dlBzNWpDTHpFTlFoaDUvMk9UaFhTanBOSDFjaTIxcTdYcUJpSkFWMGlC?=
 =?utf-8?B?SjFrR3ZZZkRPWjcxOEptUFoycWRmYUR5Z3Jtb1VLZHNUM3drb0s3S1gxUU0z?=
 =?utf-8?B?eHhOSnozaFRTTWxmYzBwZ1lDZDVQTCtTMi9jeEhGekRoempmMlZ0YzBmZjlm?=
 =?utf-8?B?UWpNeUVaS1E3ZmNtOTlJMDhIdHJJSlBTSzN3dmxvNm5hYjJCNlVQMk5HMlNi?=
 =?utf-8?B?S0Znc2k2cEZSWmg5blVBL2tEOUNyWGhRYVlpYWYwcEZzRWxLc01kZUJpSXR3?=
 =?utf-8?B?MEhKU2lvTHpDMmlYS3ZCQmdxYTVpL0ZYU2xtVFBKNnZ6WkRYR1p6V2NGcWdz?=
 =?utf-8?B?SS9HTFZoTmFCUFRoa2I0Yjd3OWZmNlBIRDdPRkhsSHRTWUdkazcvKzk5VHZn?=
 =?utf-8?B?Z3doNmZZdVYvTExkbkg0WWZnL2F3cFdFQW4zamxSenIyYTN4OGQ4ZGo0RUpo?=
 =?utf-8?B?Ym56WlJ2ZmVEU0puTTVJWUgyUjRkbDdKZDV6ZXdkOUN2RitUMTBnRjFqSTc2?=
 =?utf-8?Q?AVHbs6pmy+rEP?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d3VNSUUrbFovMkpxdXJ6RkV2VGRUeXg5c3hiS1F3Ymg5S0lqdmVIbnVuUnk2?=
 =?utf-8?B?UStQNWJ5bXF6eHVmNHNwVTdiY1Y1bm0vNEpGQTcrSStoZCtBVkxwWjVTblFh?=
 =?utf-8?B?S3BmeGl6U01sQVpTN0RWNDB6UG1QNVZ3VjhZWDBYQ3dNR0lqZThoK3gwWFJ2?=
 =?utf-8?B?SzBVMUJoY1BFTmE0c1d0M3V4ZWlyNm4zcWJSWVNVS2Exb0UxVkovK3gxcGcx?=
 =?utf-8?B?YnFMeWVnVFVXZnpCQkhqV1RURWo4blk3L2JuU1RMbnA4TjNMU1RMK1J3S2h6?=
 =?utf-8?B?MERwK1NpWmEvMlJveC9aVDhxZzFzaHNmdThuZkxIZW42cUFmeUNXemt2WWls?=
 =?utf-8?B?NEh2UUlSaGkwcHhxczBud3pxMHRESE0xaVBzcjIreWtyenpJVWVqSklRdVdT?=
 =?utf-8?B?cEhGSzJ3MVZNUHdja1hmRmRxMzdKVHo0aUZEUmtYYU9UYWtLQWZ5TSs4UXVQ?=
 =?utf-8?B?ZTdpeGoyT29yODErbTMwSnFzOWNtcG4rVTBkQ1hkMmNGUFhBQzg0YmEvZVdN?=
 =?utf-8?B?UkQzRXlMS2RobGtKcmR2UzFZcXo1UXV0T0dZeXl2M3RPb2pCTFg1NlNlYTMx?=
 =?utf-8?B?bUgwek8rQW5tQkZCSTRYVTVTQmFEQVluR2hHcHh5c1VHM0pKa1NhSjVuLzJL?=
 =?utf-8?B?anNBTHcvMWE1dldvZzlBTklzK3ByeEs0MEt0TW1PL1ZBRlpxM2V6SWJwYjRD?=
 =?utf-8?B?TzlMTDY3alpWbk5FZm0zMHJkKzhCbXpHMlJ3Ykp3ZnE0ZWlzSCs0UU1rNVJs?=
 =?utf-8?B?L0lTMGRkYytreEtlR1V5QkVrTjByV3pJZzlEemd4RFZYM2liaXZ5czYzYVMw?=
 =?utf-8?B?VDF5MkpkZlFXNUxCdFdUUlZjWmFqYTNmZ3NsbE0wOXc2UUd6dDlqVTduQ01s?=
 =?utf-8?B?UW84QkVJV2pyWUhzakkrL1dGVlMzaUFndEZvVU9ZL2Y4ODZWdnpndmJBMTM1?=
 =?utf-8?B?UkpEcWRnVmNyeVZwdDZZa1pRaDd3RTRUMGtRYUFkOTBTa2dEeFlFVnU4S21X?=
 =?utf-8?B?bks5RnBJNFRsOWg0Z3lpTjZXemxxUlhvM0RHVGlRSStjcXNnQnJPK3hqbUl6?=
 =?utf-8?B?MDliMkgvQk9BbTN5dU92cWFkK1JLUlA3ZXdYUmdxLzA2aXpzQmdjMDZyZjBZ?=
 =?utf-8?B?SWkzRENNZSsySS81V1d4TThwN2RiczdpSklTejlWREY3QUk2L0ZHM0pXb2NH?=
 =?utf-8?B?N3ZhdjZia1RldEFncHRMNmFPRWd0eVc3cXBnL0xxem1UUnRsbEloS0Z3Vy95?=
 =?utf-8?B?Nk1kL2w5aTRoYkNFUHFkNVJ2ZGJTTWh2V3MwcWhiK2Y3UTdJQi9aMlpvUy9J?=
 =?utf-8?B?SU41djBudnV4V3hoZnlrNnZ6dWl4RGJvMjIrNkxGeDAwMk9KRDRkNXpyN1Qz?=
 =?utf-8?B?WWhXRG5yc2NiUEJoS0tndXVrYXBqcTJ4dXB0MDNkQ0tMZGtKV29qZFNNcXJm?=
 =?utf-8?B?d2NHQjh5YjFhYzV1YnV2VkFveHpUL1I2YVIvSHphaWVkQjVGSGlXdncxZzNm?=
 =?utf-8?B?NFJ0Ny9kZURXK09YZ1lOeXBtMkN5Z01zWVRFU3p2dE0vcVMyQWwzRnlUT1VV?=
 =?utf-8?B?bFNFSEM2Q1JYVkJUMyt2SVhURXltR291c2U2ZGpyUUxVcWZsb2NwV2JMaE14?=
 =?utf-8?B?Qnc3ZkFmRkVpVndNa3d4cGVUOXRLWlZMc3JXUitGa1JNUENBRVhvekw2OFh5?=
 =?utf-8?B?Ri9VeHB3a3ZmMkthOHg2VTdlOGpnMWRUaVFxa3BnVzZQckZsSEoxZDc1eXpq?=
 =?utf-8?B?dFRmd0s4dE9idEw4c0dUMDlTNk94dlMrOVZra0hTM1ZkL1JQbUE5dWNoUUZ6?=
 =?utf-8?B?SXNOTTNQeXo0ZjdNMmx4QklwRXYrL1RvRm9BWGUxY3ROVjg0NUZwaDc1aUFr?=
 =?utf-8?B?WjRlblduWjFWMTRJWXo3c1hqZUtINjVZQldOeVVlLzZzaDNyNVV3WGM3U21S?=
 =?utf-8?B?YlF4dDhPNHVxZFJYQkNkQXFVMU1oRlJEZko1TGZwSEp4ZkhhRjQ5ZGx3ZWtY?=
 =?utf-8?B?ZWNkdHNDWk5nS1gveTloSEhCZXgyUENFK0hlM3FFMHhvdmt5WVF2WmZONncv?=
 =?utf-8?B?NDlUZ0srNXd2MFRTS2dPWWUwUWY4b0lTejM2VElpOFJoZFdNa09IOFZJNDVp?=
 =?utf-8?B?SnhYZXFzOHliRWRPRmRabjdTbU5BanpvWkh6SklKbXczakdvTk5DTytqVUhD?=
 =?utf-8?B?UVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d47d118-4b5d-4d49-7811-08dd653d7761
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2025 10:21:23.0581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1fHwe3CnUXrNRhMl9QSHtyeNahJdpoOfSvYjaxhP2CCx+aTYxI21zgAXZa8yzZzQnNGwBWq6vOq6/5xOByyiTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8466
X-OriginatorOrg: intel.com



On 3/17/2025 5:45 PM, Tony Lindgren wrote:
> On Mon, Mar 17, 2025 at 03:32:16PM +0800, Chenyi Qiang wrote:
>>
>>
>> On 3/17/2025 2:18 PM, Tony Lindgren wrote:
>>> Hi,
>>>
>>> On Mon, Mar 10, 2025 at 04:18:34PM +0800, Chenyi Qiang wrote:
>>>> --- a/system/physmem.c
>>>> +++ b/system/physmem.c
>>>> @@ -1885,6 +1886,16 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
>>>>              qemu_mutex_unlock_ramlist();
>>>>              goto out_free;
>>>>          }
>>>> +
>>>> +        new_block->memory_attribute_manager = MEMORY_ATTRIBUTE_MANAGER(object_new(TYPE_MEMORY_ATTRIBUTE_MANAGER));
>>>> +        if (memory_attribute_manager_realize(new_block->memory_attribute_manager, new_block->mr)) {
>>>> +            error_setg(errp, "Failed to realize memory attribute manager");
>>>> +            object_unref(OBJECT(new_block->memory_attribute_manager));
>>>> +            close(new_block->guest_memfd);
>>>> +            ram_block_discard_require(false);
>>>> +            qemu_mutex_unlock_ramlist();
>>>> +            goto out_free;
>>>> +        }
>>>>      }
>>>>  
>>>>      ram_size = (new_block->offset + new_block->max_length) >> TARGET_PAGE_BITS;
>>>
>>> Might as well put the above into a separate memory manager init function
>>> to start with. It keeps the goto out_free error path unified, and makes
>>> things more future proof if the rest of ram_block_add() ever develops a
>>> need to check for errors.
>>
>> Which part to be defined in a separate function? The init function of
>> object_new() + realize(), or the error handling operation
>> (object_unref() + close() + ram_block_discard_require(false))?
> 
> I was thinking the whole thing, including freeing :) But maybe there's
> something more to consider to keep calls paired.

If putting the whole thing separately, I think the rest part to do error
handling still needs to add the same operation. Or I misunderstand
something?

> 
>> If need to check for errors in the rest of ram_block_add() in future,
>> how about adding a new label before out_free and move the error handling
>> there?
> 
> Yeah that would work too.

I'm not sure if we should add such change directly, or we can wait for
the real error check introduced in future.

> 
> Regards,
> 
> Tony


