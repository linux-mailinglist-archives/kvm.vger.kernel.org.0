Return-Path: <kvm+bounces-63089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 44131C5A83D
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:21:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id 2FE0E24191
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:21:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58274328600;
	Thu, 13 Nov 2025 23:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fpjJKnly"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A262BE63A;
	Thu, 13 Nov 2025 23:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763076084; cv=fail; b=DAqFruuIv3N8LHir9+nbY6aV46397RZ4OyujseMmRhxHwLVsMctV3tsR0tgwdnZNUZSC/18LP/53S5r/nZ3M7IkRgi/C7/jCI9VGURBEaIUYI0x+hD74eGVab7ex/Z1E4KiTp+aZ9+kX4TvCSiCDHThmpQGr7Bf+zPZMz7wXvOM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763076084; c=relaxed/simple;
	bh=R+65tX+/nBmjGI5IKFEpUO0jw3bz46LPhLWjIK9qrb8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=loFRdrFbFe676Do5qXz3uJYlbLRjuwV2dkoTGU+IDxnzJxT8IScw/DJ2vmY8c5eFK0MTNHztzBdlb6xSmku7VEwM8+GV9XKT7VXWl4lsLEIh9H54aRjkvpZQKrqCWV9mYFdOI2mqVYT0LFw22WqAn0GOo1JbXdXZIcAN6/zNFN4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fpjJKnly; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763076083; x=1794612083;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=R+65tX+/nBmjGI5IKFEpUO0jw3bz46LPhLWjIK9qrb8=;
  b=fpjJKnlyQTOHSkcMdxavj8b9hOAAN/gYgc/5RDufk+XTolNaeuttsEZt
   kkfSLZAlhJlKu596Tlk3rPhW3sDMc0oqtC6PWNUWSXh83PE2Ey9uDDxbI
   yg4qfNghdvVGs5VP4mn2UpULgj6czqV2yin4rIqZZ0x9ase97F9RkwbYK
   /V1mLFE+6bC3Cz1SQkTOew8DcPDCLoOeDn0kH/hL6jbuneO47cw4bzBiY
   b5KAP07fDyYiWkMKKBRi4dc/njEtoPJ7bR/jTb/WxlcBlqK39dZ9Ls2Pa
   73RTxJxWXIJdse+ZfShXdU5oBIPXHqaBsHDWorwvR4I3tPnwrnxgaubyb
   A==;
X-CSE-ConnectionGUID: VekJabPKSN+0vMxu78YoNQ==
X-CSE-MsgGUID: z8fSd8dpRxa62j7rseXlpA==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="67770025"
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="67770025"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 15:21:21 -0800
X-CSE-ConnectionGUID: 1XHXwJDWRb+DY700i0RtEw==
X-CSE-MsgGUID: QgKK1H3sRriRiyFhT32XRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="220478712"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 15:21:21 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 15:21:20 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 13 Nov 2025 15:21:20 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.37) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 15:21:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lDc+lwfVYfMVLE9Ezni1J/pHobmm5+ZX0DrvSFr3G+iAb/nvnl0IfcL137Yo4Q15G8ut3NdvmoiRNRRiK22eIiBPVsh7U4lgwCJ0BV5pQlGi/eVMAQMGJdnjCTv/HoIQGbciQ2q/rbCQvxZYMR0YkXt4xIQUUKLnFDn2JNxmsWvDUtL//Svn9Q5jtg4i4Go2lwmieqXLJlkPPQc9qSVfT7dkhS7oyCZ+qbRrKK3WqJlypkCDzzkbQ7l+W8xc8lVC3tnJereF7nJM+6N22EkD38Jzp0B1/7JgKMl7ZqcHqQJamIaplVChGxco0vrhMv8H6WM4X3g3ln4ZRGawW/2Bug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CooBCvXpkbY63axAoNBovPZG3msSxknIn0kH5rXxubk=;
 b=OlPst4FMnP5eDttsBfw4AunNBlW6uhEIJNEdxvWjuKGUYc60a25S3GHg5s2QOYQwu0twiZLjxEQAUGb+DqN7ISlkia/HqxXlyZ36zQaf9s+ozwVAScj5QqJsbmB/0ZP4ePc6qulzZgztuMWwxPbknwhom5X1AkXGCUQg5zlXAgvROP+Xr866LXstkmam3DvBgqRRipwaE8xGWVhMAyyPuwm5d24tjEQ5CRXCwWPxd3fW5r9OFwhHtzQn61u5BRwHxCIK/V8W8+9CogYTJD/24WsG/2FF2oSgGvyCjJ3D86m6d5InIbE5XW1nMU1WrrRAKRI/NgFcKZ6zPp1in95RcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 CO1PR11MB4962.namprd11.prod.outlook.com (2603:10b6:303:99::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.15; Thu, 13 Nov 2025 23:21:17 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%6]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 23:21:17 +0000
Message-ID: <43f74a56-e56d-49b6-9652-f46f648b53e1@intel.com>
Date: Thu, 13 Nov 2025 15:21:15 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v1 07/20] KVM: nVMX: Support the extended instruction
 info field
To: Chao Gao <chao.gao@intel.com>, Paolo Bonzini <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<seanjc@google.com>, <zhao1.liu@intel.com>
References: <20251110180131.28264-1-chang.seok.bae@intel.com>
 <20251110180131.28264-8-chang.seok.bae@intel.com>
 <ebda0c03-b21e-48df-a885-8543882a3f3b@redhat.com>
 <aRPo2oxGGEG5LEWv@intel.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <aRPo2oxGGEG5LEWv@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0194.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::19) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|CO1PR11MB4962:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a8e852a-95f1-419c-9ce7-08de230b5899
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?c1dOdzBXNDBNTFpNYy9zTEpMaEZuZFdZbjBoVHFEdHJRdzdhbVpRODhtbUdG?=
 =?utf-8?B?em54RDg3YXEvVGFiYlF5RFpQc3pkZ3p0MFh3b0U0VWN5K0ltWDZDUEZ2OGlL?=
 =?utf-8?B?eDJEVUNwR3hvTEhpVGV3OWxpK2dpVjFoeTJ6cnhFS2RtSDlOM0dKVjZwTWhB?=
 =?utf-8?B?RjlQU1lJYndlOWVrM2tJU1l5ckhUUTVnZ3ZxNGNreHhzblRuNUhpVlNjSFd3?=
 =?utf-8?B?V1VkajgwQVllcDMxL0lPWGpJL0JkWSs1Wll5NmhPZU5vTHZhemNncHgrbzNG?=
 =?utf-8?B?TTAvSnQzdXhDZkpSYXJsQkQ0V2hyZTRvdjJKdzkrQVpjY0s3QXRJTVEvcmpV?=
 =?utf-8?B?Q2MwQjdSNmhNVENCdGI3QXZPOUs1cEhYMFdXUldNYlE3UGhXbmlJOHZNOG9h?=
 =?utf-8?B?dVJwMXY1dVFTTGFMYldrWUhpVzBid2RhMHYrd0xnNXAvTmZmREtxT2NNVTZs?=
 =?utf-8?B?bnFhcDg3NDdFblJDRGRrSWt5UENxcVVlbE9DbkQwQk4zTk1IYzAwMmNUYldM?=
 =?utf-8?B?NGx3MzVyM0ZrQWQzRDM4YWRQNGowdWhkeGNZTEFxZXdpMFFuaFN5ZTBQYW5k?=
 =?utf-8?B?bzBad05PSkdkQW1nRHFkQnZ3MEpzTGJ4M2hiUEQ5UHB2SHZPZkpHU0MxZ21Z?=
 =?utf-8?B?RFFwb3BPWDRRaGQxMUJyeUZ3VUN6MmNzYWtZVitkQ044MWM3ZlJWSXpOZWxD?=
 =?utf-8?B?dHpSOGxPV3l6cmhQT2NEZ09tUllHNUJ0TzBYbU5iaWFiTmlvSUVuMjQ2N25p?=
 =?utf-8?B?RFZUQUJtNEV3ZExnWDk5QUFpY0hKcjVNYml5ZlRXb1E4ZzJaUHdqalk0cThX?=
 =?utf-8?B?SFFOT2FrRldIWldoVGhla2o3Z002VnlscEJTZWlpeWV3UXBFVU5UU0hFc0tR?=
 =?utf-8?B?OGRpQ2Y0YUlXOUlNT2d0WE9LMVZpV2UrSXRlVnJIY1daRVBYbEF3Vkt3bEhw?=
 =?utf-8?B?MGRSUmtCYlhTaWR4NTQrQ0pXRzZEUWpveTVnRjZ3Sms4aExOSW03NFhVcDRW?=
 =?utf-8?B?L3MwVWhvcm1kU1ZUVUFpR3M4TkcrVEFnM1haN2RGZmtRVVVwbWlKZ3luQ0E0?=
 =?utf-8?B?bnp3Vzd2V3kyWiswUGhRUkxoeHpTQ2lldnFTWkpUTDNycC9wdWNLbVZhN0pR?=
 =?utf-8?B?am9pQjcyeDVMZDQvUkRqd20rMmp3UGYwUUMrbmZRZGdPcmtmYXp3ZnErU0JK?=
 =?utf-8?B?UU10bHRMcXYvdlN6U2h2b3NwM3c1K3NTcTFEL3NtVVF2OTNTRWMxazE3R05k?=
 =?utf-8?B?c01MNWlXVXd3ZjlTOU1TSkp0SmE4b1lTYkhNZXRRelNuKzVpQVJqSUUxdkdN?=
 =?utf-8?B?enVzakJPcHl3ZGV2WklSVzUvSVc4OXpLRW9NdS9uenNHa2YrQXNaSU1FcVdP?=
 =?utf-8?B?WmZ3dnljeHZnT25YdmtTdHAyZDRzVzJRUGhxZTR1dTRjYnZ5bFREL2N1cFV0?=
 =?utf-8?B?b1Q4VWtITVQyVHpqRTdlMWlLNFVFN09zUXpCdWUySzBRZ3V1QU9ybXF3cDdT?=
 =?utf-8?B?OHBPSjVlbjVZNVJlSUVoNzVoaTVNZndON0lFRzdGNzlCKzRuMjV1QmdVaE1z?=
 =?utf-8?B?bnBVWHVGcTdhdnd4ZXEwMUZHdGhybDR6My9RRDgvVWVsVndDWHJFcVM5bXBH?=
 =?utf-8?B?M3dzZ05aZTVnOEtqWS9Ea1hzWERzUFRmaXBLcENOZncvSmYwajVLQUZsdDNZ?=
 =?utf-8?B?TzdVZG1UMWFIcnI4SEpxb3MvWFM3MC9YZ1FjMXVOK09hcE5vbktBTjFmRmZa?=
 =?utf-8?B?WFQ5ODlxdGhjdmNVSmJyeHdhTlBVTUtYY040SnF3eXBZeFNzcm9ITWg3dGF6?=
 =?utf-8?B?YVppQjVUMEY2MVJFK1dQSXlIQmlkaFBhUHZtM3hZelZNUmpLanFja211cGxH?=
 =?utf-8?B?ZGFPYzJqUVVuOU4zR0JZSEFVYlVBWERJQ3hHNnlYQ3FwZU9lYkFYbkROSzRp?=
 =?utf-8?Q?nnG4NkbdN4yGCiwi0uS2f9BZZ+uMH7y+?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MDN6ZjZ5dDQ0N2JiMjF0eU5CNVRMUThqTWw3NzJCa2ZQdVRwWDlhOFNOUFdj?=
 =?utf-8?B?Mmxud0JyUjFrd1p2MGR3OTZPcG1Ba0pab1RzUG9tSFZIVi9QbFFSRVVsMnZp?=
 =?utf-8?B?dVJMMTFIMDE5S0V2ZFQ3ZU1JQTkxMTByUFV3WDFYQ1djc294emRHY3RyWk5U?=
 =?utf-8?B?M3ZMT1VxQ3lMTHlFZ20rUXNVeEhjSWMwTEdQTFZRVmt6bGNPcnN0YjZBMzhC?=
 =?utf-8?B?M2k1c2xmcGZrNjF1cW9OSVNpbWxYbnEwUVNzN2hKeEQ4blRTWHBhV3I0Y2lT?=
 =?utf-8?B?akx1MUMyVzhEMlhwbGpnQytZeUdVSDE0dDVMM2ZJWW5Pc0FwK3hleEdlM1ND?=
 =?utf-8?B?b2VvN1RVRVlUUENjWC9tRm4yNEp1UnZYOHhoNDhZR1NHcjVmaldYOEwxZHJI?=
 =?utf-8?B?alBMNmtCS1VPMkZTRWZvRFJGQ2tlTmd1M2FlczgwMkRpaWk5b01DdkdPNW52?=
 =?utf-8?B?NW9BM0k5a1NSM00rZlZkNzJ2R21SdUtFdU1EZGtqclNacklzYXpDWExXY1VL?=
 =?utf-8?B?dGh2YU42cktLVERyQ2wxSmJMVTFnSzAweWxuaDFaNHdRa3hsVTEvY0RIWGQy?=
 =?utf-8?B?RUR2MlVaY0kwZWM0b0x4ZzJJU0lmMlhOZ3BQM1V6b0RUenpxTHk5eFBQbFla?=
 =?utf-8?B?MVRxM0RiM0xIZERQaXNmY1FWZ2Nadi9XNkQxMWFDZ2c1amNoYXRyNE5Wa3dV?=
 =?utf-8?B?TWx2aWZ4emVZNFowTXI3NDQ4N2hQZk1mOU9PeC9tZmI0K3R0OGkrQm9nVFFR?=
 =?utf-8?B?T2J0Uy9GRTNGMFl3QVBQMlZJQ1pmTzlER2x4TnlHbHJJTlFLTmNIOEp1eW1p?=
 =?utf-8?B?eUxrRUZvc1hyVVRwWXlyZzZ5RG9oSWNXSDZhVXJuUUY1Wlo4c3Z2RkhNY3Nk?=
 =?utf-8?B?V2Y2QWIyMUVrK2xFT1ZHb0xlTnVpbUkrZnF5YTYwY0xYV1lRcVpyaVI5cVBp?=
 =?utf-8?B?amdncFVvMm1USE5HN0FhUFV5SjFPTDdvaDhIQ0JndHBQU0RPcWQ4Ky9lYzA1?=
 =?utf-8?B?dm9wTmFLTVBRZDIrb3JvbkVrSldwMzByQ0g3T3Y5TS9RZm1Vei9Eemx2R05R?=
 =?utf-8?B?bWhkYXZSMmt2Q0h6UCtaSnBBT1pWcTh0cDRjbzVxSGw1V0YyZkFXUE50ajlu?=
 =?utf-8?B?OE90QlVDdnVLMkJ3cG16alM0RjduR2IyTkFDWGhxUEpnTUFyUlJsbVA3akFW?=
 =?utf-8?B?UDJNVDNWVDVQazBRTnFMUzlLc0tTc3pzTTVGTklUTlhwcTBLRm8xQzNxaUg0?=
 =?utf-8?B?aXByQnR0cm56cWtVSkJRbU5qYjRKS0c1cTRyNVh3RDVFbmMrTythRzBsLzRR?=
 =?utf-8?B?NXhJV2MwVndOR1dBNGRxSmtvR203M2pKTTRHekR5MFA0YXJvQVgxMkp4NG9z?=
 =?utf-8?B?SVFFc3g0dE1nTzlGbFhha1lveXZSek4zejdWY3c1OWdOeWFVdS9ZRkVxeisw?=
 =?utf-8?B?U2ZPd1BNa0twNHQwNHU0amNiMUJBdmNsdzJHWTlLUFdEVGtMUFpmbE4rSEhD?=
 =?utf-8?B?Q1dtRitiWGVGMWhnWUkxdSs1bWRSd3J3UkNHZ1hmV3g4L213S2VOVUc1SFAz?=
 =?utf-8?B?WnZsL2ExcTd0dlcrdDhWT0hwcnQ3L2xHcFVCTnQ0REZJU3cvYnBSRGpWbVJl?=
 =?utf-8?B?L0RJbUw4c3dlaVE5NU4raHpsemxhWDV2UHNKdUpTaHBvWHd0bHF5ZlA2SkVp?=
 =?utf-8?B?WkpmcGRsRnlNaitxcTBFYjJUN3NOSnUyV2VIMHo0NWV4TTNSdGdlbGxINEJU?=
 =?utf-8?B?dmw1a2txdTB5enQ4VzBqTVVNOTVmSUJGSUdlOTUrTnhnYUxpbVJZSTBSWkJm?=
 =?utf-8?B?MU85YS8vS3djc3ZodWcrN2RMNVFSNGhJY1ZMQzhpLzFnOE9vaXNvRXgvQUZU?=
 =?utf-8?B?eFUzaCt1VG9nQndpbUhDdGg0RFpjVWdGdVNYSERkTVpjbk12Z3pRaXV6SEYv?=
 =?utf-8?B?TDRiNWROOXVSS01wTEVPVnFEeWxQZENWRkZOMzVsL1YxcHFheGt5dHY5cEpu?=
 =?utf-8?B?Mkd2NW9nbkZEajg0SjBSWTZMb01iK1lwdzdSY0VHWjZEM3NEdHY1M3prSnpX?=
 =?utf-8?B?OUtVWjVnM2JpQmZiZThLY0N6endWaVpZQ1FaQ0tGOGdraXBadVhHWTkvbGxa?=
 =?utf-8?B?VG52ckM2ZnlvVUZNaVBjYkNmYUIrb3BCNXlLWmtKNkVnbHJhcE1tTCtNbHpP?=
 =?utf-8?B?NkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a8e852a-95f1-419c-9ce7-08de230b5899
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 23:21:17.3158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2VOcSjSc3JwNV8JsOdr2IRP1eXLuG9/ejUEWqNUFIQ8A8e+O9ZCQpkeceKCBD00OqV9MOP4ScCufyZmhhTjl8mesihnhBiO6ZhtYQhAP2Xg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4962
X-OriginatorOrg: intel.com

On 11/11/2025 5:54 PM, Chao Gao wrote:
> 
> Shouldn't we check guest's capabilities rather than host's,
> 
> i.e., guest_cpu_cap_has(X86_FEATURE_APX)?

Perhaps adding a comment like this would help clarify it:

   /*
    * The APX enumeration guarantees the presence of the extended
    * field. The host CPUID bit alone is sufficient to rely on it.
    */
   static inline bool vmx_ext_insn_info_available(void) {
	return static_cpu_has(X86_FEATURE_APX);
   }

