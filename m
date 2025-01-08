Return-Path: <kvm+bounces-34745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F6E3A0532E
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 07:28:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5DAD1163304
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 06:28:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78DD41A76DD;
	Wed,  8 Jan 2025 06:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MOnlZT5z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE921A726F
	for <kvm@vger.kernel.org>; Wed,  8 Jan 2025 06:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736317706; cv=fail; b=jyJjXHowUP5peg9zxevHW/b33mj3k2rosovoWdOggl8gixCBGRmSKRyr+NUISm0ELVdIabO2CH4om+KDu+nHJQe8Asa0S4mRkRNqdqoaneyqgzwc6WxDnHRUrLq8e8NmWAtyOkfo9Hz01T9Lytxr/yOxNCOcbPH6Ex0ufSK8zgg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736317706; c=relaxed/simple;
	bh=3Ynz8r8Yvq+4AQoIfriC1rgQXKET1YlNv0NbCngcMb8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QmIJQiH3zVCT0YU7jEPlGKLlcSqzmwsiOsQMMz46wht3q844zDDM9OM19pP6hpys2EHkFbpalqG8OlbiajuaJhMnNkeghYviNuJafTu0+1SY1xqwsec73+PI2OBI1rVl6tvVmNDleVxk8n8DKft92tbXoSzi35Kd0UbgugO5RhA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MOnlZT5z; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736317704; x=1767853704;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3Ynz8r8Yvq+4AQoIfriC1rgQXKET1YlNv0NbCngcMb8=;
  b=MOnlZT5zBlnJc3SZ2okaa6lLsrc8eQD7RM/5lkUT0KCtNOXrqVwOrE8z
   CWhqNdPqIz9Xx+K0XaoS3K95lkgt6toOl9JMdzRg47z4H2Ani+LxBMuHv
   3xNYBpeKA2RqW0Ql19SMsvyrqqsY18BW4LIRvhsQxBYDKke4sIpNbtAcr
   X8Ljhgydm+JR6K+TO8sbmk5RyBgMMmnkmJPpTH8eQ79Y34oc3As0LiXKC
   vfaQZo1jAovRlmLrC/RiAzoB4AWxyL8bm4e9Meu6EnSkII10bhjXHMeQU
   52NPkFX+HtEVKoz9zy/aP3fjhyacE7K0hbQPbxCE9PPco3NLRPMqioBw+
   w==;
X-CSE-ConnectionGUID: BQA/E0G0QCeuYRfITFFcKQ==
X-CSE-MsgGUID: D+j4Ed/oQfOCoUhbBTaShw==
X-IronPort-AV: E=McAfee;i="6700,10204,11308"; a="24133807"
X-IronPort-AV: E=Sophos;i="6.12,297,1728975600"; 
   d="scan'208";a="24133807"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2025 22:28:24 -0800
X-CSE-ConnectionGUID: VcZt3vnKR3Os67Cvuq71rw==
X-CSE-MsgGUID: JRVPEYBLQYiTSEicF148jw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="126284070"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Jan 2025 22:28:23 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 7 Jan 2025 22:28:23 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 7 Jan 2025 22:28:23 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 7 Jan 2025 22:28:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fw+fkixLyGU+l50V4WRgAAc0odvCIjryC7x8zHAm/z8Q5mdwkkSxRIhztJkAPVFOK4FvsCvp5Wj9v5mbYPCSRFfC7XIXQu2ZZgpVHky0eUV3UkzNVKlvC4IQj5gcYTlt3fUT1qXEgIzbpzu+73jnJ/WqjnoIlcL/qPuholZR/0X/tAkzvoNP4NuV66xvCzty0pcD091iLRftOIoTfI4LtFlKT3ctR9Mn8AkuoUGgLLOghIcP1oGEoBPPo60A7/psTx3gNC+xQZVpvy1U3Hu96cvl2rmzy1ny4f+JI8zI0tK0FfbCEAg5uq4mp19J0aKzyXMJtJKBzrTpndhkM+t6Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mTwHSuBJWAP4CzUZJmd8UtnuLZzFOeG6/VCsTCkN0fE=;
 b=H+bh8RgkgIuAkcQY0No+I4197UyqM6qV6qIzZ9RKpRJX+taip1NaQx+CyqEAakRT6qeeqekzsNVK5z+aUHokCteijt9LrKtnDVCRuhimbrMthhM1dJ7PWDuykiLTWLn2LOoP4BrAbaJFbGRBGWW61+kIWNSj0nfRDnHWs+6lq9FJmbQlM3st2IX4sRdFqcPJ98ev9UWHdr5URNdG19XvyGWk7exKAz8uW2rv4GflrNv/dUC8/h1AwPIWbP5FovX0ZmASZ5e7lu+IyV/z85ukkGdBCuhRfxwyCUb8bwoZgpwbj1Pl2SNpZe0X6Zv0GUjvN+IF3R5D4oNBoSBD5fo7Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 PH7PR11MB5914.namprd11.prod.outlook.com (2603:10b6:510:138::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8314.17; Wed, 8 Jan 2025 06:28:11 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%5]) with mapi id 15.20.8314.018; Wed, 8 Jan 2025
 06:28:11 +0000
Message-ID: <8457e035-40b0-4268-866e-baa737b6be27@intel.com>
Date: Wed, 8 Jan 2025 14:28:02 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] Enable shared device assignment
To: Alexey Kardashevskiy <aik@amd.com>, David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <2737cca7-ef2d-4e73-8b5a-67698c835e77@amd.com>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <2737cca7-ef2d-4e73-8b5a-67698c835e77@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0030.apcprd02.prod.outlook.com
 (2603:1096:4:195::17) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|PH7PR11MB5914:EE_
X-MS-Office365-Filtering-Correlation-Id: 60feaef5-a51b-4e97-6603-08dd2fad9f8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RlZHckVBZjJhZXliVFNTQnlLNXppS09qeE1kbmVYbjlZNWp2amQ1SHE5R0Ex?=
 =?utf-8?B?UllraVFNN2JiZUJKbTJyRUJhZVFqVHp4d01aVkxMOElNMUYzc0ZDMkVTY0Jn?=
 =?utf-8?B?VUlwWmtkN3dWL2NHcCtSMmpUejFxUGU2TjJPVWdXVVRLM3crc3FRdFFhQldo?=
 =?utf-8?B?YmNGWmZPNktDcmhWa3Bsc1FacWdpc2tFRmUwZUM4QTZsa3dQdXZReVhkZHVJ?=
 =?utf-8?B?alBDanc1eng2T09pZ1pDOGZQKzhaYTJFblltY2xiNCs3MVIyOS9CdlNxM0lP?=
 =?utf-8?B?Z1BkRTl5Y3Rwa1VVUyt1Z3pQK2k2bERHRFVXdlh5bnU4cFlndEYwaGhPV255?=
 =?utf-8?B?ajBJL2Z3UkJ2Zks2cDI3WTNxUFdOZzV1QzlqT2xmcFA0MW1jS3BFNnBCbXVr?=
 =?utf-8?B?NlNmUitRODJLNjhPLzNPNWtkQTM5b3VabUdWQzlwYmM5Y2M3MzM2YjJyMVl6?=
 =?utf-8?B?ZjRaM2R6RmpwTGhJWlA0L2xxU3FlVlFieVpoN3Fna2ZodzlUZnVPUnVnTk94?=
 =?utf-8?B?b2g2QXdPUmZJd3ZVY21WSVhxdENKWjB4TEtaYjFlMnZNWGVTMlZkQW9IMGt4?=
 =?utf-8?B?UTYxSXR4NVVDUThVZzA2a1pORUxSZ3BjSkpnTjJSUGdrZ1l0RjJUWDZhZThC?=
 =?utf-8?B?M1BNVktnTkJmMHdVU1IrUXZXY29yNiswOEpsSVZ4bjF3MVVWWGlMTkVMekx2?=
 =?utf-8?B?UysxZXZBVW9DejM4MXZCajlDNVR1Q2tXcERONDVsZGNIYmU5QlZpWGdIVkpY?=
 =?utf-8?B?SERwdmY5OHRncEp0M3o3UGJHVWhYZGVBNEdJVXVjeFhCV2NJeWJnN0ZGbWlZ?=
 =?utf-8?B?R3lvdEl2TGQ5RGtwbHgyZlhBODN6eXNRNFdJT1JBTUN6TlZCU1E2dVdkRU5H?=
 =?utf-8?B?bXpnaGswVG1PVTV0ZzZKYzZUSDNqNmxvck13Uk9GVVFJY3lhbURrWWF4b0JR?=
 =?utf-8?B?OFhHSjNtNUxHOHF1Qkh0SnVndk9oRHJrRENHVWcvNlpRM2pmSUQ0NGROVWRn?=
 =?utf-8?B?bXBRV2trNGhYOW1TQThMa2tHWWFlWUF0S3lNeC9uQkFwNy9DWGhDZjNtZFJa?=
 =?utf-8?B?eVpZNVdBSk9GbFNqZVpqTEhwejlDaG9Kby9Fd2l0TmVoS2tOVGdsYTM0RWd0?=
 =?utf-8?B?a2gwa1cyYjR6c1pHVk1wNzNiR21rRW01WXJ2N2VHZ3ZNaklWWjlwdEV0Y2g0?=
 =?utf-8?B?Z2NNOGJpVnZLTjVwRGJIQXRWd0tIbVJMUG9aTFlST2dzNUJRcS9TQXcrcnhs?=
 =?utf-8?B?VExxOWluUkV4K1VvVjBRNXpvR1pub1p4ODlZZDZzRlRpTTNqdTBnc3NaMStk?=
 =?utf-8?B?NDRyeDJPaWtBMEZhdXE1dFJmbkNuQUd2VzNxdVJrZEpxQW5JNHg5OCtLODFh?=
 =?utf-8?B?L1hCRXZrc244RmhaUGVWS1RML243OEVIWlBEMVZHWGZLZFJXZng1S25XYk5R?=
 =?utf-8?B?clpGdDFzME8xT0hLMVh1MmhsSFVDNHNwSzJPNHgxd2I5Q2FoQXVtOU1XUmlU?=
 =?utf-8?B?cWdsT0JsVTF4SG1pdDBrcnRRa0cvMzFLTkh3cndMaDZId2JkVFQ4K2hCbUww?=
 =?utf-8?B?WU9FdTBsWEhDQlhlcGdaZjNwcnVRZ3FOTVdxQ0J3bmJwSzhJeGI2T0wzb1RD?=
 =?utf-8?B?OE9CbWVHZmo4TFdVYTJsc0N3L1BTRENGRWV6ZEtkdzFISVR0TG1WZ1hDY29w?=
 =?utf-8?B?ZWdvL3Nab3k0TU0vcHlUYWtoUDJpRHprTjhHMXA0OU5hc0JEcTY2YU1VN0tO?=
 =?utf-8?B?ZWZhK1VCU0p5RHN6U3Z6SUw0YkttL0NJbG9sb2k3dEo2aVVoVTlyWStzYWRL?=
 =?utf-8?B?Z3d1ZDhCT012Y1g5Y2xmdz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZGVRdEExSVJrc2FVM0RHQ2hKSE1TV0JSTkdVTWhPUHV3MmgxR2pNWGJHWXdT?=
 =?utf-8?B?UllrbzNoTXZTUXBySHRVczd0ZSs0MFJOeUttWFpXbVg1Q0FKc21jVTV2M1NN?=
 =?utf-8?B?R240MDFTSWRuZmtPb2dqWDcrQmFPQVpqcVN2Z3RJRjg2clF1bUZVVnIrV01l?=
 =?utf-8?B?WE5KVXZLd2ViNzBRRDRHVHdrOWkrWHErdWZ1RUcyVVp0YzR2WEVBdXJpRWR5?=
 =?utf-8?B?bER2NXRSdFpUZUNzM3AzTnNYZlR5TGE3ajFGM2loekp6NEkxRnpVdkxoUmJ4?=
 =?utf-8?B?L2d0WEw2cFg3RXR6L21CSm5zZm1Ob0xlV0lKOUJZb0Z4TEl0N0ZZUTVnYTNQ?=
 =?utf-8?B?YmJ2YmRGcWFWMXhzWTl6TGhpZFZucUE0VjhEK3p6d3YwNTN0Vll3S0FMUit6?=
 =?utf-8?B?TlRpSmp3VGlvKzMrSFIrYVRLUDNrOHRjU3lXcFdEMGNjYlJIcUVscktqQm13?=
 =?utf-8?B?blNEd0ZPNGxsVFR1cHF5M2c3STNqcWU3ZTZFRFBhVDZ2YWFDMnFMUTE5c3FO?=
 =?utf-8?B?T0FGSmlvTUovd2NNOS9UbEhVaEppbTdaSGhqdVg5YjZrdk1VbGFuN1Q5c1R1?=
 =?utf-8?B?MTEzMytSVUxDK0lOMlNINFBVeE1WYTVaaDhSb01jWkdFUmRJZ3NEdlZHWkp5?=
 =?utf-8?B?UW80VjBGc0ZJMUkwRHB5RkxkbXpGem9JdVh0MmhoUlRWa0o4TEtFWXdLV2tz?=
 =?utf-8?B?WHUvOW0wY0kydzk3Z3Jud3RINE1lc2ZRMStZenNKdjF4VnhEcDF5bHlyWFNZ?=
 =?utf-8?B?SDBTSGRnTVllSjVBY3RpZzhKekVodWVwcmYwSm55NXNsUVR3ZVFJSHEwTFBp?=
 =?utf-8?B?OThGcFBmQjVXcnJ3L2ptYzF2anlYVFh3c2JWYkhadWVQVHRDSW5lN2FmTVhh?=
 =?utf-8?B?QTdJM3NZRzVpSEhlTGdnS3ZLQzgwVEVhRTIra2N5aFphNUpHL2tpTjR6Nkw5?=
 =?utf-8?B?ZHZiVWQ4eDJrQjgybXJlVU5nTStRbUY2am15bUVBeVBEa3lrZHRaS2x5YWpU?=
 =?utf-8?B?Slh2bnh2emNDaEhPaSsvRFRWbDlmWkJDaVRtbWZZdlJGSTlTVEQxZnkvSm5o?=
 =?utf-8?B?anhPZEhxcm84YXhsaVRqNjdaVVpqWm1HTGFIWjNSbVd6cVRMVEhDM09DT3Mz?=
 =?utf-8?B?b3FIVTFMTTJrakRVYm9XS1dkWXBKOFhNdlAyNllPeWt2d01GQ2dQYmRSeXFB?=
 =?utf-8?B?emcrZ1hxZWhPOXVCaGNXZ213dW1kTk9zdVcrNGJmWUlDWUkySmlLV2dXeml6?=
 =?utf-8?B?QVY2VjEyUjFoV1JDUU9peEhsSjhQa1RNOEdoNDdMM2JPVHppZnRncEhGV2pT?=
 =?utf-8?B?MU8yQkVKTWw5UEV4d3k0SU1xSGY1NFhtMmtzUllzR2tkaHpzdk5RVkxzVy9L?=
 =?utf-8?B?Z3BiRS9ENnJvUHJJclhyZFI4Rm5XdFRDQzFQQk9SOHJpK1FySmI1VlMxZlV4?=
 =?utf-8?B?YkwxQk1qdmFBY1Y3RXJoVzZ3U2J4THRoeFBuOFZBOGZHTnd3R2JMeUNsck56?=
 =?utf-8?B?SDF4Ync5Y2VGaXZmSE5ETUExMzNsQjZqWjA2c3lQZVdPb3dyOGtNOFo1SUFr?=
 =?utf-8?B?YzhMWnk1QVJsWEF2akhTZWlnUDd6MEY4Q1d3WnR4bjVtNTFJQjdLWjJWTnB0?=
 =?utf-8?B?SWgvdWdiMHdmQ2dpbG11K3lieFFNYUJSVkwrWGMxV1dSUWcwM1o1N01QRXFh?=
 =?utf-8?B?TFBMb2NmMFdXL1lnZUhFUEtrZk5UYWRHQWFzMjZZZHpjeGxmRGJybjdQVi83?=
 =?utf-8?B?cGFtQi95UU1LbTdGQWc3VUIrdWhKdkxjWS9tL1o4Z2lnb0Job0IyNFJKOUhF?=
 =?utf-8?B?eXhHdWM3U3VzUStLc3RkZkhVOUdVcnREankvWGZ4YTQ2QWI3aTZPeXo3ZVNy?=
 =?utf-8?B?QXhQZDdwMkhERUNrbUJPRnRLYXRsZGZJM2xCZ203ZmtGbEJqNGd3dkF2clha?=
 =?utf-8?B?T1ZaajBvcy83ZldyVXN4MG8rVUxEYmcraFBuN3c3Q3pjL0lGTE9rZ281SXpw?=
 =?utf-8?B?TzA1MGJMbVlzVzVlQVJuTmhzKzVsckNUTDM3UWFRdnR6bTgwRzlzZjdNTncr?=
 =?utf-8?B?Rjdxa2ZDeXQ1T1czUWhGS2Y4dExxdFpzTWNHbm1FaVNjZGdNalpOalNzNVRm?=
 =?utf-8?B?TlVRQ2t4VVJ0dDI1VmExOVh4WE9OeTVRVzJ1NEYyVWNMQkZKeXpQYW9VRk5h?=
 =?utf-8?B?QUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 60feaef5-a51b-4e97-6603-08dd2fad9f8d
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2025 06:28:11.2289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S1W1g3J/mtc6l2EFfmP2YkB7gT+ZZqD+n3S06a/Zk8uCEgH5dwy30N/B44cKIcIU9LIy+qJ08+bziN7x3wuWow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5914
X-OriginatorOrg: intel.com

Thanks Alexey for your review!

On 1/8/2025 12:47 PM, Alexey Kardashevskiy wrote:
> On 13/12/24 18:08, Chenyi Qiang wrote:
>> Commit 852f0048f3 ("RAMBlock: make guest_memfd require uncoordinated
>> discard") effectively disables device assignment when using guest_memfd.
>> This poses a significant challenge as guest_memfd is essential for
>> confidential guests, thereby blocking device assignment to these VMs.
>> The initial rationale for disabling device assignment was due to stale
>> IOMMU mappings (see Problem section) and the assumption that TEE I/O
>> (SEV-TIO, TDX Connect, COVE-IO, etc.) would solve the device-assignment
>> problem for confidential guests [1]. However, this assumption has proven
>> to be incorrect. TEE I/O relies on the ability to operate devices against
>> "shared" or untrusted memory, which is crucial for device initialization
>> and error recovery scenarios. As a result, the current implementation
>> does
>> not adequately support device assignment for confidential guests,
>> necessitating
>> a reevaluation of the approach to ensure compatibility and functionality.
>>
>> This series enables shared device assignment by notifying VFIO of page
>> conversions using an existing framework named RamDiscardListener.
>> Additionally, there is an ongoing patch set [2] that aims to add 1G page
>> support for guest_memfd. This patch set introduces in-place page
>> conversion,
>> where private and shared memory share the same physical pages as the
>> backend.
>> This development may impact our solution.
>>
>> We presented our solution in the guest_memfd meeting to discuss its
>> compatibility with the new changes and potential future directions
>> (see [3]
>> for more details). The conclusion was that, although our solution may
>> not be
>> the most elegant (see the Limitation section), it is sufficient for
>> now and
>> can be easily adapted to future changes.
>>
>> We are re-posting the patch series with some cleanup and have removed
>> the RFC
>> label for the main enabling patches (1-6). The newly-added patch 7 is
>> still
>> marked as RFC as it tries to resolve some extension concerns related to
>> RamDiscardManager for future usage.
>>
>> The overview of the patches:
>> - Patch 1: Export a helper to get intersection of a MemoryRegionSection
>>    with a given range.
>> - Patch 2-6: Introduce a new object to manage the guest-memfd with
>>    RamDiscardManager, and notify the shared/private state change during
>>    conversion.
>> - Patch 7: Try to resolve a semantics concern related to
>> RamDiscardManager
>>    i.e. RamDiscardManager is used to manage memory plug/unplug state
>>    instead of shared/private state. It would affect future users of
>>    RamDiscardManger in confidential VMs. Attach it behind as a RFC
>> patch[4].
>>
>> Changes since last version:
>> - Add a patch to export some generic helper functions from virtio-mem
>> code.
>> - Change the bitmap in guest_memfd_manager from default shared to default
>>    private. This keeps alignment with virtio-mem that 1-setting in bitmap
>>    represents the populated state and may help to export more generic
>> code
>>    if necessary.
>> - Add the helpers to initialize/uninitialize the guest_memfd_manager
>> instance
>>    to make it more clear.
>> - Add a patch to distinguish between the shared/private state change and
>>    the memory plug/unplug state change in RamDiscardManager.
>> - RFC: https://lore.kernel.org/qemu-devel/20240725072118.358923-1-
>> chenyi.qiang@intel.com/
>>
>> ---
>>
>> Background
>> ==========
>> Confidential VMs have two classes of memory: shared and private memory.
>> Shared memory is accessible from the host/VMM while private memory is
>> not. Confidential VMs can decide which memory is shared/private and
>> convert memory between shared/private at runtime.
>>
>> "guest_memfd" is a new kind of fd whose primary goal is to serve guest
>> private memory. The key differences between guest_memfd and normal memfd
>> are that guest_memfd is spawned by a KVM ioctl, bound to its owner VM and
>> cannot be mapped, read or written by userspace.
> 
> The "cannot be mapped" seems to be not true soon anymore (if not already).
> 
> https://lore.kernel.org/all/20240801090117.3841080-1-tabba@google.com/T/

Exactly, allowing guest_memfd to do mmap is the direction. I mentioned
it below with in-place page conversion. Maybe I would move it here to
make it more clear.

> 
> 
>>
>> In QEMU's implementation, shared memory is allocated with normal methods
>> (e.g. mmap or fallocate) while private memory is allocated from
>> guest_memfd. When a VM performs memory conversions, QEMU frees pages via
>> madvise() or via PUNCH_HOLE on memfd or guest_memfd from one side and
>> allocates new pages from the other side.
>>

[...]

>>
>> One limitation (also discussed in the guest_memfd meeting) is that VFIO
>> expects the DMA mapping for a specific IOVA to be mapped and unmapped
>> with
>> the same granularity. The guest may perform partial conversions, such as
>> converting a small region within a larger region. To prevent such invalid
>> cases, all operations are performed with 4K granularity. The possible
>> solutions we can think of are either to enable VFIO to support partial
>> unmap
>> or to implement an enlightened guest to avoid partial conversion. The
>> former
>> requires complex changes in VFIO, while the latter requires the page
>> conversion to be a guest-enlightened behavior. It is still uncertain
>> which
>> option is a preferred one.
> 
> in-place memory conversion is :)
> 
>>
>> Testing
>> =======
>> This patch series is tested with the KVM/QEMU branch:
>> KVM: https://github.com/intel/tdx/tree/tdx_kvm_dev-2024-11-20
>> QEMU: https://github.com/intel-staging/qemu-tdx/tree/tdx-upstream-
>> snapshot-2024-12-13
> 
> 
> The branch is gone now? tdx-upstream-snapshot-2024-12-18 seems to have
> these though. Thanks,

Thanks for pointing it out. You're right,
tdx-upstream-snapshot-2024-12-18 is the latest branch. I added the fixup
for patch 1 and forgot to update the change here.

> 
>>
>> To facilitate shared device assignment with the NIC, employ the legacy
>> type1 VFIO with the QEMU command:
>>
>> qemu-system-x86_64 [...]
>>      -device vfio-pci,host=XX:XX.X
>>
>> The parameter of dma_entry_limit needs to be adjusted. For example, a
>> 16GB guest needs to adjust the parameter like
>> vfio_iommu_type1.dma_entry_limit=4194304.
>>
>> If use the iommufd-backed VFIO with the qemu command:
>>
>> qemu-system-x86_64 [...]
>>      -object iommufd,id=iommufd0 \
>>      -device vfio-pci,host=XX:XX.X,iommufd=iommufd0
>>
>> No additional adjustment required.
>>
>> Following the bootup of the TD guest, the guest's IP address becomes
>> visible, and iperf is able to successfully send and receive data.

> 


