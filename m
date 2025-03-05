Return-Path: <kvm+bounces-40144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27CA4A4F90C
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 09:44:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7ED807A72DE
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 08:43:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F6DD1FCD05;
	Wed,  5 Mar 2025 08:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XFVpfVu6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917EC17B4FF;
	Wed,  5 Mar 2025 08:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741164252; cv=fail; b=omyrXVW3kQO1GvBzBiGln00nYA6Tpm2Zfh46/3bJqnODOHzI9l9pFcXBtU8GwK6sz+/rNT1Mioc1ArYOQ673mU6VbVprYW6oAGjhvn5tjJ9o/Uiry6g7HCTezSgm77mVrofi57H1lC9MpaqRaN8tK3C+4gXlk61T+32f0nTjx/Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741164252; c=relaxed/simple;
	bh=u1LLo+U5Vny43yQrGf8UzlVX4+nVseU0FMMwnkrEXhg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=avQlMFqj2pn/Grs1Hk0IVO63Rv0ARcalSkFFUi2m9SFxYxG/ZE/qP4z9uKvUrwA8vI6lpI4BMN6pcbqC8kzYCnx4mhGdmOpM5iCJgAK9cwG1jFfVOf1LK1pkdG5psZpuCdak0tIKWNBssUx0Y/zcdTS0DN2A+RgR+FpfU2j2f/8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XFVpfVu6; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741164251; x=1772700251;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=u1LLo+U5Vny43yQrGf8UzlVX4+nVseU0FMMwnkrEXhg=;
  b=XFVpfVu6OTn5TcnnhIF2KfisbY6zcPpuowRwRRrTI0+J0lNhLug2yt0d
   PnfF7Og6yTptBHLp11BH3oZU7QN1/9JQH69g0TIfrmjUMrP4Zd80DefUO
   4hq500FTFtzDYGU62H60lIiIp+rCyxNACpw4iQM5sBX3vP9Pf5v6P/cnE
   RPqflzq994BZI+4F+RqgrSIfKC37LEFQ5EZy77ujBXDZheR+zYjtF2vGh
   N/PcVi/8MK6oNFrLV/j4enGfMWGx27nYwK2zdVlsGsZjlE31VlftRacu1
   HXh6LIIk2m63U4G/YWKmtv03VvjXnaxd3TqptNe3ZgRYJwjggi4d6pdXP
   w==;
X-CSE-ConnectionGUID: yKlQ3X8IRhyCDOAMJnMkKw==
X-CSE-MsgGUID: RaRYlqXUSjy9FOqAnntTPg==
X-IronPort-AV: E=McAfee;i="6700,10204,11363"; a="42137742"
X-IronPort-AV: E=Sophos;i="6.14,222,1736841600"; 
   d="scan'208";a="42137742"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2025 00:44:10 -0800
X-CSE-ConnectionGUID: Lwp86EpCR0Kl1KQtWnKkMQ==
X-CSE-MsgGUID: XTte4YTVTT253OG+HA1xyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="149591575"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2025 00:44:09 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 5 Mar 2025 00:44:08 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 5 Mar 2025 00:44:08 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 5 Mar 2025 00:44:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=REs8jTw7L4ScbFWwOog0ja4IB4dPpHe5QOynuqLXn4jG3DTHRtNUbvkz12dv9++vnZPGbkc5KDgBHcITJiIDjnYJcIfp+cRLxCvhrzhPLvlfXDWc0lUXvMK4+TV5iV29tLhlOO25vy6eWoU/yXSaXWKt8Ve6Hky+9Gvq1UIQmE0owTYH+g+nYbX9yZMNC2oQ9rq4ya2VTh+ZGnoz+pivgtn8OdZ/tbMS0NS3xf7otZYjAlGJBc1quix/IJ07aCT8i5EPFhV9isrmgGuSF5Bm4rmzxWlhm5Xb+/+f9FJspZUPky1Xpi+CD5NYrnMEYCDMAoBUR3v6Ki77RPo7C7LqHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AvSBJ8VGFskhALkUdVR4LUnMV8yNrqudL4vt0SPBiXY=;
 b=hLQI6uSzeYUFkhhNbMhNaudSSmxkeBiNUReDfegd/8hUudsvUSLTXdJO2zFrFZi4D82FHBhY1QtfcoVKXiIKwFpZfeluZqHWokPvNIaCuMSPASN80AnITP6ohBUSv7xoGz+maxpv4ijTOcswB7NxVmmcbFGIZy+4TOtApWKg3qSmXnPpd4BVR7vyDXojWnOW0n7MXHxJe2bqzlDEi2p6HgoCTPfr3StNhVmYKCxNZhzjilG1dv9FqKQHdYoS8ngbfJWoLIYhuufKOhLZd/vzhyn/tG0l1qnteJ4mGL1jefJtpVkskSxTl1xYFYBBiUVnjvFhtkb3epjXTZCYoQ5j1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DM4PR11MB6118.namprd11.prod.outlook.com (2603:10b6:8:b2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.28; Wed, 5 Mar
 2025 08:44:06 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8511.017; Wed, 5 Mar 2025
 08:44:06 +0000
Date: Wed, 5 Mar 2025 16:43:56 +0800
From: Chao Gao <chao.gao@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: <tglx@linutronix.de>, <x86@kernel.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<peterz@infradead.org>, <rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>
Subject: Re: [PATCH v2 3/6] x86/fpu/xstate: Introduce
 XFEATURE_MASK_KERNEL_DYNAMIC xfeature set
Message-ID: <Z8gOzG4uS51cX1Nk@intel.com>
References: <20241126101710.62492-1-chao.gao@intel.com>
 <20241126101710.62492-4-chao.gao@intel.com>
 <21824e7a-092e-40f8-a0f0-972c92ae3900@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <21824e7a-092e-40f8-a0f0-972c92ae3900@intel.com>
X-ClientProxiedBy: KL1PR01CA0119.apcprd01.prod.exchangelabs.com
 (2603:1096:820:3::35) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DM4PR11MB6118:EE_
X-MS-Office365-Filtering-Correlation-Id: fc2037b6-d459-470f-b0e8-08dd5bc1e393
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QnB3R0ZSVTZjZi90WDZVNjE5OWZkUld2d2pkZXJkbXBSRUxsZWxhdzZWVndj?=
 =?utf-8?B?VERlV0wxK0NtdVJ2YXp3SDg3d1U4c1M2eXkvN0M0a1RGY3JxZ3o1Z1dBbjVH?=
 =?utf-8?B?aVFMTzQxbkdyQStzdGlFMVpyRFd2VWZ4Snk3K2wzQ0hWQVNpZGxrR3R4UFl1?=
 =?utf-8?B?OHh1REZBNTRnbWVEYUtYaHNoR0pWZTExaTMyTmRIcUlEbExSZU13QS9lWGdE?=
 =?utf-8?B?bDF1U2pPT0FUV29FU2JreFY4SWJLOXpjNkhCOTlSQkdEMzdwdHFvaWdtenQ5?=
 =?utf-8?B?NFhDR0dGc1NXR0NlOXoxRTR6OHN0V2hhYitaOE16eXZFQldHelNvUy9ZRTJE?=
 =?utf-8?B?aW9pOVRyQVIyS2NHamdpTHlaV0pDQTZ2TG5nWklDbUpFdStZZjdqbCtlajhi?=
 =?utf-8?B?angwM0RESFdzMXhJOW84b3hyOFFvdUtod1JmS1c2QWFreEE5aTYzTUt1SStZ?=
 =?utf-8?B?bTlBMFlHVUNsNkJCd2VyWFA1cFVrVEVhT3lOUEdzYVBwdVI3eDJ4VFI2Ymcz?=
 =?utf-8?B?L0Z3bVZhemdNUVRRZlVxNFJzVWhvMXZrSWRWc2hMbVViYWZlNDU3RVhWdnZS?=
 =?utf-8?B?WGI3bzRoL0FGNmVUc3JBWHBWSUxQZ1dSWWFMZFd2SzcyS2V4Q1JiRHN3RE9n?=
 =?utf-8?B?QWIyd2FFNGlia1RZNUZlOUJWT0FFTENKT1l2ekY3ejE3cWVSL1hPdjFydHo0?=
 =?utf-8?B?Y3E1MWd5YWtMMFVaQUlESlNSaGdNTlM4djZ2UGJKdnMyQ1NsZnBLdkhDaUtk?=
 =?utf-8?B?OVpESXM4UDRmTnVwa1V6S3FvcEZaUVpodzJDOElQSldFeVJSbkFEVE43SVZj?=
 =?utf-8?B?emRTdkxHTTA4MkllaGVsb0FEYkQ4T1BnZEZLRGZISjN0U3RKUmltNnlGaGZD?=
 =?utf-8?B?TzlXN01CbjdWMDBvVUlWN2pNUWc3S3F2Y1c3QWtWRUpBWXVPRFBzbCtSdUY5?=
 =?utf-8?B?ZDJUbkQ0N2x3NVo3ZXRpaG42Y1d1QzhudVVJVXd4dnJBcVpNdnhWV21nVXIv?=
 =?utf-8?B?S3J5K2lOVzRJQnlib2FHejNXYTZ0bVh3aG9uSFNJU09tQk1DVmEwNTVNby9t?=
 =?utf-8?B?Mis2Tm05UzB2Tnd3UjNjbk5HM2M2MzhvK1cwQWJvd3RFSmMrb1NnOGNpZ3lL?=
 =?utf-8?B?Q3JBZE1VUU9FOFhxdkhib2VoaHpzT3d2YmdIT0dvalAzK1hmV3p4SGovb3FH?=
 =?utf-8?B?TTZqN28ydktMOXBLcWlGRHZOY05JQlljbHJPOWNxMjhoRXB4N1dYdmlvRmo2?=
 =?utf-8?B?Z0ZoT29UQ3lnT1lTK25YSXlzcnM3T0VzMkFDeWtLZmxQeTV5MDNLaldoeDlN?=
 =?utf-8?B?YlMzNnM2cElqL1pRUU5TdHcwSmIvcHRQT3ZYQlRWS1o5eUNRVUhadGRzbmxI?=
 =?utf-8?B?RkRnTU1pL3NET2ZkWUs5Q2ZGcDJ3QzBMcTlUVkkvYmFPWG0ya0dpWnNYbG1M?=
 =?utf-8?B?djZTVkQveXZoM1ZwVXV5STU2V3dvdUlqQngwQjdRczZleEdCQmUxL3RJYmhJ?=
 =?utf-8?B?c2swNnE1R2lYSVVCd2dXY2trSTZQenVGTlRNQWwvVUM0QWd0N2gwR09meERj?=
 =?utf-8?B?TGpSSXpYL0p3S29Td25Wb2FvcGJRMlBiOEpETWFHb2tValhrclRFVDNVdk9K?=
 =?utf-8?B?ZlVJaFB1cUdObHZvWnNIK0R3YWd2bWNPYzVkNlZFNlpKOXdFcWZZOUVncThv?=
 =?utf-8?B?Mld0eHJrV1RuUlh5amFWSmZCNUMwUHlSWDA3VTBXUnQzUnl6YnUvR3FIZDlB?=
 =?utf-8?B?NEFuREcyR3VSeWltTWZ4RDJjV1I3SHdvVHBndDk2bEdSd29mdktsTmNmUGJ3?=
 =?utf-8?B?a1gxOG02Q3ZvRW9GeEdHN3V2bEdRbTFFK1RmK2ZQam9IVTNwRWxBVDY3TDIy?=
 =?utf-8?Q?/OYVug74tLNyo?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V3MrQzhkeFNqRTNYdmtoZUpDTHUrMkEyN2JoOGVSeUY2Ni81U1h6cGUvYXI4?=
 =?utf-8?B?bWxrdzM5SllReVhUME9uL241ejZPTHQvR2d5azFFTEorT0xseUp4ajVaMnZu?=
 =?utf-8?B?SmZ2RUdORy9iYWpiSWZXQTJqRmRrOTBFc21VR1AzemlORzcwNnN0NnRFaUs2?=
 =?utf-8?B?SFNuM2NjWXVuSjdXdWtwT0J6ZEJQQWlFVWxZSXFEY3F4SWlMVGJTVzlGU0hI?=
 =?utf-8?B?SFNYMVhGMk1BZjZBK1dVcWZYYjFQYXkydjBSQXRia3QwajMxNTZQNTMzZWdT?=
 =?utf-8?B?bmdwU3NRRXROQkhNcUhzVE5OTG4vWW50V2ZBL3l2b2h5dmQ1SXFmakp6VFFG?=
 =?utf-8?B?L1NiazdVanlIYkxDMS9Lak95TmtIbHlzc0pCbHgzSWYvTEV0c2lMalJQT2Q2?=
 =?utf-8?B?V2MwVS95bklKd3hMZW5tZmlES0QvQk1zUmUwQXNRdERpR0RVWklDQlMwTXVI?=
 =?utf-8?B?TE1iQUdhZVNhYzlSQnE4aS81TFE1QURrMlhYa21NYUUrWFR0TkxUWU8zUGlu?=
 =?utf-8?B?OFRLSUk0ZjhDZ3ZYZXNHQldMU3ZObHhyZVBaR2k2eUlvdFk2aVBMSE9RWG8z?=
 =?utf-8?B?QTFiaHM0NHVLREVUckcxd0d1N0VlWkVkZ3VBaEs2WVVJK2hqeElJMlNRZ3F3?=
 =?utf-8?B?dUlGNmtpVXhpNVlFcDdGS0hoK05qaXhkdWl6a2V4ekpzNDcxTXJnUkNQRE9C?=
 =?utf-8?B?QVcvejR2TlBJMkhpaFkrdDZ2TFMvQzRYV0V0Ly9mU3QxSXhvdlJ6QnBxRzlD?=
 =?utf-8?B?NDRqd0ZkU3VwUFc0cnY2ZEVKQ2pteWI0ekF6NDZ0a1ZCTk4zUW5PNWdtUGVr?=
 =?utf-8?B?YVF1eWZqVnY3dmRCRmxTV2VWczhicm5URGxIT0hOc2FjNUVtSkZldjBlaHVN?=
 =?utf-8?B?aExxb3lPcWhCdHNmTDFYVllOekVlQk9iY3VsK1NYVmt2OHNOVWorTUpLVFhj?=
 =?utf-8?B?TXpNdUZWMjBMTVM2S21EWURyVDdZeWIyWnZ3TEJDeDJ0VmVWczlMeFlSM24y?=
 =?utf-8?B?aTJweXY1WGphS1ViK3c0UUsrdm9Hb0FYdmo5NjFNbS9vWnZLcUpRSXUzOURV?=
 =?utf-8?B?VlJpTW83WlcvMWI4cFBWWHJzeTZlMmZNREo3RFFjY3pQQW9zRnJyb2FaUE1H?=
 =?utf-8?B?b1dKMStKckFpdnozdjJBc1dHakNLMlY1VlhLelg1SzBJL09hVVd1NkQvckZi?=
 =?utf-8?B?T21xV2Uwa3ZDUmcvSlBjK2VlZVQwYXhXdjlWOUk0bFduKy8vTVNpTHhCeWhr?=
 =?utf-8?B?T2lBMVdPOG5nZWNEK2NBMmJqQVBsdVlSc0cwRmNrMWpickIrZkM1MjFIZHU1?=
 =?utf-8?B?ZDhTUlgrbjVxbGhkQnVOVUR2WU1kU0c2dGIvVjF1SFJvL0gySUttUHVaU0FN?=
 =?utf-8?B?cW4vb3hIaGxsUFVFZnBpN3MzZlAvQWlEUjB0K3g5a3lobldiWnRjTEJCazF2?=
 =?utf-8?B?V3c1RUo3dVkvbnBzVnlNU2FsbnM4SENhMWlKRm50MC9tdS9vZDhaVGF4dU80?=
 =?utf-8?B?MDBEY0ltTG43M3BxeS9sMnYxLzQ2OUV3bU9HQWszd3owRkcwQ2ZjSUxqc2xM?=
 =?utf-8?B?U2xiVzk3QlJWM2RQaDNUQmVSMU04dDA5MC9lTEpEcEVEWG1LSXlFMDk2ZkZ5?=
 =?utf-8?B?MmxSbFR0aVlvVytEQXN5UFAzL3FCSVFVa3ArUUZJdGhSYzVuT1U4VUFPYWVC?=
 =?utf-8?B?bGRSQ1ppMFJncU9nOWtrdG9GWEh3b21UOHd3T3p1WmZjUHF1VnErcVJzOFJJ?=
 =?utf-8?B?QWdjQWE3V3Q0WHhjYTJ1ZTdNbWgrRitMV0RrZlVuUXRiWFYxZzd1TlJLQ2xz?=
 =?utf-8?B?MzBlbDFRMnpLemhwNHdVKzUzTmdFLytaTEYvWXhQSTNtazJIbFg4cVpQYWZK?=
 =?utf-8?B?aVFKNHJ4N21xR0pUb2NremRIKy9CNzVkVXg3M1B5VWlWNnp3VlhmMHpObTRq?=
 =?utf-8?B?c3AxcEVkU2xUN2J6emJqV2lGN3l2L2t1eUwzZGJETEtyaytocWpPczVPZ2pU?=
 =?utf-8?B?UVRPaEhrUlBFcGZOajUrNFBTaGhmVWlBSWxkOXRmU3dUL1NqZ0V3ek00SGdh?=
 =?utf-8?B?cFNraVlUVWdlNnIzcmNMTmp5VHpOb2FmSjA1QVg0VnlCSEZPMnhJdDR3ekZh?=
 =?utf-8?Q?W1Ju83nF+UyhvBKBTubCNmnbb?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fc2037b6-d459-470f-b0e8-08dd5bc1e393
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2025 08:44:06.2540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /BZoSu470BIPJjiq8z+WMYV618NGqH1P1QGvoBIcVJ3flJEg6wq+6n7Y/0OlEtmup2sLyUhAxO0d6VBTrNw7NQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6118
X-OriginatorOrg: intel.com

On Tue, Mar 04, 2025 at 02:37:00PM -0800, Dave Hansen wrote:
>Subjects should ideally be written without large identifiers:
>
>	Subject: x86/fpu/xstate: Introduce dynamic kernel features

will do.

>
>On 11/26/24 02:17, Chao Gao wrote:
>> Remove the kernel dynamic feature from fpu_kernel_cfg.default_features
>> so that the bits in xstate_bv and xcomp_bv are cleared and xsaves/xrstors
>> can be optimized by HW for normal fpstate.
>
>I'm really confused why this changelog hunk is here.
>
>Right now, all kernel XSAVE buffers have the same supervisor xfeatures.
>This introduces the idea that they can have different xfeature sets.
>
>The _purpose_ of this is to save space when only some FPUs need a given
>feature. This saves space in 'struct fpu'. It probably doesn't actually
>make XSAVE/XRSTOR any faster because the init optimization is very
>likely to be in place for these features.

Thanks for the detailed explanation. You're absolutely right—this change
aims to reduce the size of struct fpu. I see now that implying a perf
improvement for XSAVE/XRSTOR was misleading, as the underlying optimization
is likely handled by the init optimization. I'll revise the changelog to
clarify this and incorporate your wording to avoid confusion.

>
>I'm not sure what point the changelog was trying to make about xstate_bv
>and xcomp_bv.  xstate_bv[12] would have been 0 if the feature was in its
>init state.

