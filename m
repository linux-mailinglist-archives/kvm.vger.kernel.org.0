Return-Path: <kvm+bounces-72999-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WNhZIO6Nqml0TQEAu9opvQ
	(envelope-from <kvm+bounces-72999-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 09:18:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CC0621CFA4
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 09:18:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D047F3079FC9
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 08:15:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00C762D3727;
	Fri,  6 Mar 2026 08:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ClLgG3+R"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240B4293C42;
	Fri,  6 Mar 2026 08:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772784913; cv=fail; b=TLGUqSVVSrByEtqGBEeMNFoqEBhcviDF6Ewq78NfUKQTY3XiMrpqLtPgJpMbR9CufWNswDCLuxwe3UccqZjgP2kZKc8wa82lOQS6rBZ3x9HJame/nQfoSiUZYmdochRtS2pudSNpiGd78V5Cla07/9Xk1BYx436zREQGcOSCMmI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772784913; c=relaxed/simple;
	bh=aVQqrTECIZkC+O1kFou9WGeuO6yPzu81WnKWpSqdUrE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FlOUtXdTJ8OyDz74lTxgzwHwAtGCtd+X1t3Z/9m5WFpco5AxEZ7ZoS0k17MatJwesyPvEpt0ynJunQDfkvBo/qZ/gUn5euCqQ/lZW18Ki4DGph8OV17UMZ1NQui0tPAGbdQyD2Bkq2Apll97Hv5WxRVDztw2Im0dgKHBRwNskQI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ClLgG3+R; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772784912; x=1804320912;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=aVQqrTECIZkC+O1kFou9WGeuO6yPzu81WnKWpSqdUrE=;
  b=ClLgG3+RkVKhkDTkwTD2pueVVAfVe1o91zytN6pvpTV7Lpm9NjpUS86R
   55FXP4C86Mnw2AFe2CzuJYDKRA38NxmIwO9zGcQgVS32ldkDVaVgGmwep
   LrN/ciYa9qBMwkF8EzzI2LFQ1MUaVudKnWWaBmMbGXOkX5qLJPiWe1NVJ
   e9pp9lect9ALSwTNVginngDhawVbPUDUVWpXEcf7iXH+oQP3Zn473JQv1
   0q25OzMtR7Cef7IRHgkAmoFoZyOcKY13Anbym5DcMYd6i/tnY+qpm+G7H
   NXVfCjpU2rrDZbSwB18wkOn6amceOR0LRczw9tJSM+OpIvj71pnf9lCUy
   w==;
X-CSE-ConnectionGUID: GX+lfGOxS/Oj6ewNSaed4A==
X-CSE-MsgGUID: bDtwHKgTQU2aZsVMTFWYdw==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="74076443"
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="74076443"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 00:15:11 -0800
X-CSE-ConnectionGUID: g4thCWKaSS+MtSLybjt/Tw==
X-CSE-MsgGUID: 6639hnVfSnqAR0mduTmStA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="245268248"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 00:15:10 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 6 Mar 2026 00:15:09 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 6 Mar 2026 00:15:09 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.9) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 6 Mar 2026 00:15:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ppZ4q87r6qZ9xcid36p5yxuFkUOiCErow8WJBrUV684+DgskZFqKLuntHg61NFe6WlDUjgETPY2P5ZdpyKKng54arZmYvLkF4YT7AkuVc4nkdF+2P9RGd0bgK9JOzcvnS5f8FgizWx2g/jaO8BDjotcPAXRjsZ4uVRBaDzStzAsUQwKHMWwCwIVUqCf1Vl3sgHgTjmoZumqX5/tAOjDNuisrkF5cQ06Y2FbHsGR33ol/imL/lDLmNtShWMdKNSo5qQRmHow+BKq+mbhpJU9OkNZoDQN1Mi27udIB4yL4Z/YMOmr4HSd7rT2syuCHWB/iczmsxk2srEMs3PwIpOS4Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=owQ/sILSp3VRZv2Rub4+A2gGe6e3ZbNG0Ysr9gDqCLE=;
 b=yYCDqTsTFO0B8Sik6ao2JX7UbKEm40iX+FsdmHppbMttrQSW/Y61Nx6Udf9isQu91IxrNwDNoQIa1Lk6xDCuB1xXGBH/P8XUMIinF7qN+EIN2GnYxKMzU9YzdOyGtlpQCoq4h+XuCSROvMOFoeXHeSIPK0qwGK0Sd6iI053oND+cwykt1wRftkN3Q1Pqa5lMVhRHoJwvt2BeRQ/yha6lppS/i2SezDK+eZBb3pbH78VXUIo9Al37bdREQX6MjG0z0UFdSg8fJ0HmKlLZR5gJjO5PF+rJPlwNepGwwYOrKajE8LTLHvguWWDLzzRi5Wq5x5AYczKO5ZFryOhhDUahGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by MN6PR11MB8145.namprd11.prod.outlook.com (2603:10b6:208:474::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.20; Fri, 6 Mar
 2026 08:15:06 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9678.016; Fri, 6 Mar 2026
 08:15:06 +0000
Date: Fri, 6 Mar 2026 16:14:49 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"sagis@google.com" <sagis@google.com>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"paulmck@kernel.org" <paulmck@kernel.org>, "tglx@kernel.org"
	<tglx@kernel.org>, "yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v4 13/24] x86/virt/seamldr: Shut down the current TDX
 module
Message-ID: <aaqM+eFfQ9qmpzyT@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
 <20260212143606.534586-14-chao.gao@intel.com>
 <0c86d95449543dee0369bd83740b25aae595a5d1.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0c86d95449543dee0369bd83740b25aae595a5d1.camel@intel.com>
X-ClientProxiedBy: SG2PR02CA0042.apcprd02.prod.outlook.com
 (2603:1096:3:18::30) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|MN6PR11MB8145:EE_
X-MS-Office365-Filtering-Correlation-Id: 40e7d425-506a-4f66-de65-08de7b587946
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: eCCsJO1/td8RVc4Mt6tl/7kC7qun0RKeCYtCElW82xpnxFKdYO1U61ef/KB0RlFfMB/XU/VBvTIbyO5GpF7S5p7ytMU4vakhHg1nDMccGcpGB4BqPjIUDtx31phPTtqck1FgAMSYfxe9rhKPsYH2Xrs7EJecp5+D260VA86dwUaTSj2xi7dCJxdO3ZAcaKMZ4HHEwCMdSq6SEEDk5Byp11HsIzR9BINaOjGhv8Dk0dBK34pAZ/hvWUkGipf6HarMz1ALRNQb+J28D4yyV5YLyQpfhlTH7Veu1MOCeuZgpus7fChGmSi3G4+MQwoX0VEd8ClVusvsMIZzD7BFyCFReJq0OX+SWwv0tQ23kS17r2wwTu+ugTatIHDCrF7ScNeUB3L9khjMpyGO01HU9sV1tQLyO3TggeM0p+zaP4ZshDdET9KmeotCcaaygw/f1OIVKu9+XVmqf1qgHtLAaq5acXozDzEf92OH97Ts034N2rco8yIHGMVBcJ0Hku7zdlzOcHUA4cxjIJk8k5GNqQQLbLWE/h3d34++6cPad2z7FyznxYxwS28HINa35Qrxo9LaQuqtIkuq1hXlBYAmd5xaZbm4fL8mtxwa5MwWeQd1ZkvxDQYS4HP1EOSuZ5SMTCxWliIGojECvFlYly5Yv3IAtYXoiX5xYryf/0dNe9O+B20q7DSy777GZ6CV8VSbBPRPp/LCDtLF9L6Ac3ZVoNBLv/so7rqDA+4ZuTEpf2DiIPk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GsYxly3CF8cKaScea7SLHD2/oJ4UHxGOk7wIXxvMKaRmbQhZAAoP29W24twK?=
 =?us-ascii?Q?bJy3yytdxcaRE5jHXhj2Dt6Jt9WlC5SHMe/6HUUHiG1c8IfYcKEEPoDfHtM4?=
 =?us-ascii?Q?Jv5Dc814k1Py1HaoxcoV/5ILfz/3tknh+5ZQu0HOcNMrXoWRVCS5XpiohTfo?=
 =?us-ascii?Q?jyrvkTRNVxHphhNUvY5tJNiNoExh+QY4ICwEL2NktcbveQ1KSOC9ndTws7iC?=
 =?us-ascii?Q?B/O7Wqvjv8B3bJLp+KuMVEdhISoljO22LE7XQbgyKIU2ITz93EzNShgFiiAM?=
 =?us-ascii?Q?XxML5ZMGMDnOWm+tMJeJRxVxaNvxNTiqiUdd/wd2xd2OmdbWsDRVU9Q/IRKM?=
 =?us-ascii?Q?KgRxjFvvBT4mJehlcdjF2REXsb+SjjjTFZCpRqm1pzVcgi2EZk/gSQFpS3gN?=
 =?us-ascii?Q?In1ci5SDDfceYSTHRGFxlOAK5nAS9UwWP9E9zfqk5SpA/FYBMj65aKkDRw+P?=
 =?us-ascii?Q?Ioy7huH4MBwEe9d/kwvpY5mj7E5pCuzYeNegD7/QD3Dh0/2E1iMDIXAmMKmt?=
 =?us-ascii?Q?gBWdKkORnc0VzpNrry8AsRf75NKTPzXTTet5nxxtsfNIyHv3guHHAbBcI5/4?=
 =?us-ascii?Q?tmMQ9XhmpXQ0pH3aVtP3SJxBV2cPIohqbsSUnwqu/i5WXVWKkTBPmfzxxN6/?=
 =?us-ascii?Q?H8qdq5Qlms/8fLmDmJYvAcwRWIPSfvql4SWniV2pHGt/e9d5oMdCmpD0qiO1?=
 =?us-ascii?Q?xOCRj6CaOWdA2aamrz4S8ROkwiS+E4MiY8LsDI968mi+Dc/5wqTFdhNq9KK6?=
 =?us-ascii?Q?goOeyylPP/elPhNwQT2tEmcLjH7ApXeOS+r4emxmPOOxqgpGyrYvI3Kkmo30?=
 =?us-ascii?Q?u/iLdJxNFgXRD5kVPEXXv7OGStPEV5ZOyAke1SqE/iABWDBXFR7BekQxSfGM?=
 =?us-ascii?Q?TwZOKRKYdltRHWyZWc08m6E8TfPr+DOcZniun9SOTf1Xzlbmb3Qie4xjqSRB?=
 =?us-ascii?Q?PV+R09mw6f/oC6LBe2RGzu0G6hYfzCCE9jQX3hThmm1ztUAkbbuoNpeEBvVc?=
 =?us-ascii?Q?VaH5h1+raCLmtTwhShoK89ShyuWQB/bSEPqoB/kW8gYu2rFhNh2MgcDUw0Z2?=
 =?us-ascii?Q?0HwSkIXDNj48lms6ukmeEmr0WH5n/XLtrfbuJaE665A1UA/isdWG9tNpH/YP?=
 =?us-ascii?Q?RXrasVzPZksomqAzzWCx5wa80jyOGg+AZqrlJryxy/KB+TYxcj0EjFzbH0/6?=
 =?us-ascii?Q?sQg4dgFDDjygam5JxN8AQ2Amk2HcreHshgbcnq3wm5emcluCvMw7yENaWqwS?=
 =?us-ascii?Q?Bpc2RHraXrgN4EcjY7W3i7SvuQXcn1fVTad6Ot4Gwvlfnc1E690kUIoCwL5c?=
 =?us-ascii?Q?QI64GpxGJkXFL6Pxn0LGdNNzpmmJYsy6SnzMbqdokFX2tHTVOrhkOyqHC7zi?=
 =?us-ascii?Q?6jO6zCRZQQYkEWZP9UIwhIh4M0EPyovtA7MSSZxRE452Z576ozKaPXr3RBXj?=
 =?us-ascii?Q?Nje+uAq23qn0vGXkmt8JEaJitAJxB5xF261XMAaVwqDURZQFtVtK8ntHIBmQ?=
 =?us-ascii?Q?4WEQEwJqydhQrd4ifTJFlGgavZmDuLJbVGTHjRLacVEbAh+PpqnZHLZ2j/2Y?=
 =?us-ascii?Q?qj7CZbVDmoX7HiudYTm1zg44XxyI45D4APaXnTfeGaQGI6TyTN8WSI5m2DWu?=
 =?us-ascii?Q?1h6gvQX/gDxSQL+Bu1MgD4wGjg842vvBwSkHR3FireZ4y+g+86lukS9GymRV?=
 =?us-ascii?Q?ZoM3fkCMKA/9X7rCuLpnWQiZW9e590ibMOzRPGZZXF4XNGuwvNccA8awiq2P?=
 =?us-ascii?Q?/LYcTES/tw=3D=3D?=
X-Exchange-RoutingPolicyChecked: q2Dl5ga36SZSEP/W4ZVi84oKtF5XqMYigXKDAC6E25i470iyd8wpwqSZge8For4dXTVbUDTAmhgGIm2ovFOhXnTfkNOKCd+XbHy9dIR4VafdpyTyQYTqGQNG7Tm3IClAiTMRnloD1JmcZr2eCIAogfKseGpgPTIjlTuOtG0KRkLC79bOw9gRyLUEFWJeSBZvq7JLN6+0pgYk0lghv9tBs7WMgfEv5Z82LMMRQHDU1WNity+2uN/IzcTPN0D4b7B2DB2T2LmVDX2389iahcanjQkHhvDrhlMj9ju68PkNUYiaSCdLBrnXB6Cpi1hMzYGpTsHexRteCJiuEQ8jNH+pTQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 40e7d425-506a-4f66-de65-08de7b587946
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2026 08:15:05.7585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l4K/hTqhChwzb6vRIy1Kzw3QU7sMf+YmhfhQ3K7JpC9EvHk0xBrFP3Z9GNFUnAwbypaocTQZp29UlEhO89pfdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8145
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 9CC0621CFA4
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72999-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	RCPT_COUNT_TWELVE(0.00)[25];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Action: no action

>> Ideally, the kernel needs to retrieve the handoff versions supported by
>> the current module and the new module and select a version supported by
>> both. But, since the Linux kernel only supports module upgrades, simply
>
>Nit:
>
>Again, ".. the Linux kernel only supports module upgrades ..." sounds like
>describing the behaviour of the current kernel, but for now runtime update
>is not supported yet.

ack. 

>
>I would change to " .. this implementation chooses to only support module
>upgrades".

looks good to me. Will do.

>> --- a/arch/x86/virt/vmx/tdx/tdx.h
>> +++ b/arch/x86/virt/vmx/tdx/tdx.h
>> @@ -46,6 +46,7 @@
>>  #define TDH_PHYMEM_PAGE_WBINVD		41
>>  #define TDH_VP_WR			43
>>  #define TDH_SYS_CONFIG			45
>> +#define TDH_SYS_SHUTDOWN		52
>>  
>>  /*
>>   * SEAMCALL leaf:
>> @@ -118,4 +119,6 @@ struct tdmr_info_list {
>>  	int max_tdmrs;	/* How many 'tdmr_info's are allocated */
>>  };
>>  
>> +int tdx_module_shutdown(void);
>
>This (and future patches) makes couple of tdx_xx() functions visible out of
>tdx.c.  The alternative is to move the main "module update" function out of
>seamldr.c to tdx.c, but that would require making couple of seamldr_xx()s
>(and data structures probably) visible to tdx.c too.

Yes. I'll keep this organization unless someone strongly prefers moving the
main "module update" function and related data structures to tdx.c.

If neither approach is acceptable, a third option would be to remove seamldr.c
entirely and merge it into tdx.c. This would mean adding ~360 LoC to an
existing file that already has ~1900 LoC.

