Return-Path: <kvm+bounces-36193-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BC946A18842
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 00:19:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 804F87A054C
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 23:19:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BF5C1F8EEA;
	Tue, 21 Jan 2025 23:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CQcOIw5f"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6946B1AA791;
	Tue, 21 Jan 2025 23:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737501580; cv=fail; b=Es+EXUG7qLcHyiUmwb2dbCHzmROG2Xe0tn0X6XoScyx7zv7P5cyuCT1v/zmkNosftvRMHMqqEdCXnIV04Yu9JGXoP6ehYo7Uy0Fi0Vzn/w1rLAMHrBftY5JkHI1jXUVRlA6XpCA9g94cZHo3Ucqaz4KE1sMqDvlkk4KH+QNSZxc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737501580; c=relaxed/simple;
	bh=mb+H3WxQZIfn7fxOXe4bd1m97mk4hhhJAB4l/wXp6Lo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=L796NP/f6XsOec9LZJjs1r6Kv2SSUkfOsBBbJsMh9eD+T3Lpiabrx6W3XB0Fxjzk8F2F1iiiHa49aF/gfYKZgb0AdzdZSoFrqicf7Pxu0R0D06OPeVEyvQ2tFJu2aNzN1Ee4wunEk1p1TXMRGjxw2DKPVip1O5enl7O9QFPZL0k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CQcOIw5f; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737501578; x=1769037578;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=mb+H3WxQZIfn7fxOXe4bd1m97mk4hhhJAB4l/wXp6Lo=;
  b=CQcOIw5f5PzM3pyPLJbxFtJhqUk0lRVIzVusWmDHe1AH6j/yYAwvmg4L
   ZMrWbswljk6xan/V2LcKz/aZ/41F5d4SOkOfvg5WLaHVqO2H2URACDmKC
   JRtvxUddnZ8oDua+m6yP8HerNfxhQJjHc6QwRRJGAuxFTcBAk1x5ndTEP
   CB/2V30NlqEoC8/awMOw885XlJJOrb7Cav4HszeV3MDZtgcb1S3f5bxBz
   tpflktFvSl/fFo/UI+L/HEN37GkUpqj3140FP+hATI+dRStSYVoZ9VXQ2
   8sVx6fLu8rhZUeKB9HQxOIIfYCZVsDAQGTc7BV2kvfmHJM6VoISEyOD2D
   A==;
X-CSE-ConnectionGUID: DV5JY54TTNqw5/nd1WasfQ==
X-CSE-MsgGUID: +Ig2fsB2T/qQu1nQGzdGXQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11322"; a="37966369"
X-IronPort-AV: E=Sophos;i="6.13,223,1732608000"; 
   d="scan'208";a="37966369"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2025 15:19:37 -0800
X-CSE-ConnectionGUID: R1ScgSf/QE65JC6GO5Y+Pw==
X-CSE-MsgGUID: u3R860icR46nPDOK8c7pMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,223,1732608000"; 
   d="scan'208";a="111946809"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Jan 2025 15:19:37 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 21 Jan 2025 15:19:36 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 21 Jan 2025 15:19:36 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 21 Jan 2025 15:19:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h3pha8gA9I8UlMtH8eiVozliUnAJ+F8gh8xfM7Hp+h4JdP7GYrviVuX+eP+JYr9zaPfCYvxOch6nR5iRBgq8/I6ilFX0DQJV816GkSDswLJoQk3nc8ABlX53tGs05JbjTbdkLWJ+0TH8y/sLxdc7dSEiklgP9W0yOI3wQ7iBjDGZVtqw93zH50eTUCOMLLlDXWP8CRG0x4EB1NOOc2/Y4eIaQFHNe70ydNHrr43gkrkayHCFXiYhnDj/ozkG/j5TSsxeX89uBVd6N0NLGYl1sfmoWbdw1/c0l61JOy/6uBG+RfEnX2oCybPcPo9NO1E9VDW/Ybyd2mTrKAvtgKy4Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mb+H3WxQZIfn7fxOXe4bd1m97mk4hhhJAB4l/wXp6Lo=;
 b=ozni7afzveXJjKmtazGQDiPN7z++YIZoxFzhsvhUdi+GJz3+cmu0uL4xOq4+6TnQwnxuQLk6ZwCoM6fifZN0GmV/7mAGR0qonZOxom/Ee9Q8O79ceMxxn/vRoloJ92hNg6KDIXK6JlAjh+B2/j6hdudol/S1YTM0nZZSpzTL51sEJlAyRE2ETRrIJFD/pK4A63YQ/mKKQwvMv3UMroK9Ug+b/9UeCQmEKcDheGEIdBeI0Iwz1MMVtoiNUKqftBJdnqO5WDdMyY2MJQf5VYzYhseRZ0mqtWZyJuofsk47lyMZ1yysWt+qGfHbuWkvcSj12qlPh4o7MmaZhzQ3HhE0ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH3PR11MB8154.namprd11.prod.outlook.com (2603:10b6:610:15f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.16; Tue, 21 Jan
 2025 23:19:20 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8356.020; Tue, 21 Jan 2025
 23:19:20 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"francescolavra.fl@gmail.com" <francescolavra.fl@gmail.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>
Subject: Re: [PATCH v2 24/25] KVM: x86: Introduce KVM_TDX_GET_CPUID
Thread-Topic: [PATCH v2 24/25] KVM: x86: Introduce KVM_TDX_GET_CPUID
Thread-Index: AQHbKv5FM3B1aLjYHk6i9GmMdsvqorMP32yAgBKAYoA=
Date: Tue, 21 Jan 2025 23:19:20 +0000
Message-ID: <cd9eb487a433533e892f16be2a55b0abe4088456.camel@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
	 <20241030190039.77971-25-rick.p.edgecombe@intel.com>
	 <9e7d3f5c-156b-4257-965d-aae03beb5faa@intel.com>
In-Reply-To: <9e7d3f5c-156b-4257-965d-aae03beb5faa@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH3PR11MB8154:EE_
x-ms-office365-filtering-correlation-id: 63078c4b-1fda-4e06-b1ed-08dd3a7208de
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UHpPejVHcitjVkpZaTlCdHcyMzJ0NVdZTmI1WmRHZlpqYTlHbWY4bHRhNloy?=
 =?utf-8?B?VllsOFlqUC9PVmhvdWNXMUlzNVdXSllsWnE4YU5FZ1NoMEt0UFhZZXJQTjNQ?=
 =?utf-8?B?R001c214bk5GNjlDR3Y1L0ZyWHRPMjVNdkhwa3lLYXNENHNjd2xlaFgyZy8x?=
 =?utf-8?B?aGVoaTkyRTljVDdsZG12MXB6MGU1Yk1ISHhwcnBLZkFEYjJVMHQwdFp5Y2E0?=
 =?utf-8?B?azBDOXljVkVqRGtCYjFvV0ZHY1Z6UGw2ZzFUR0t2MmgwV3NuVndDcWxuSitP?=
 =?utf-8?B?WGdlTWJpUW1KOGJBcGtSb0xGZWxXdkRUOGVMRXduK09xS0NhV2h0NHlDMFdB?=
 =?utf-8?B?d0o5VU0ySFBkUmMxczEyNWc2R2k3dUFsdTVoZWpFdjdmSGFVTk4zSmFGSVVh?=
 =?utf-8?B?RmQ4YlFFT3pwcmdhMXFGU0lBRmJTRFdES1QxNlZTZVB1QVkxa0tCM2dNT3Ex?=
 =?utf-8?B?SjB2RG9NK2VHYUV3RFB3SDFPTUZyQkNxSHhnSXNrT242WEgwMG9CSDJLNnEz?=
 =?utf-8?B?OWEwcUg4WWNkZUxJa2VEQXYvT2JUYWdiZXgybytJYlZVcEo0dXV4OEp5RmFs?=
 =?utf-8?B?WjlXbW95Z2lycTlTZUlIQklBdlBUa2NENHJ0TEJoWU5iOVV2VW1PMzM0cEZ5?=
 =?utf-8?B?NVN6dWNWRU9TVXNFaDczTjhiMCtTU1F0TWJ2d0dKTjZDRlJTY0dTdGtja2dw?=
 =?utf-8?B?UFJ5WEZBS2VVcElyK2huUDE4ZndscjRXc2pqZGVLc3QyRFRrN0dBelpUOTdn?=
 =?utf-8?B?dGZYMUVsVmpVaG94bG1NaVpmSWxUQ1F3cm1YTzk1ekdzdDREb1JvZHo0QTRO?=
 =?utf-8?B?UEhrckxoQUxpSTRhUmYvZkgyVXFBejJQTzNKK09BbENJSStVV2JPK0JMQ1hi?=
 =?utf-8?B?QzRybnU2SGZsakFlL1gydlRyQTNTZjlGc1pObXFqQVR6a25zb1pNYjJQUS95?=
 =?utf-8?B?SFpiR0xsRVhCeWUrc2QyajhIK015TDNCdjJYQklSWGZiSkNQdFBJZEJsVHFj?=
 =?utf-8?B?Q3pYNWxuZTZpbkVNNmtINmNLODRWdTVUMDh0djR4WGR6VXA4V0xwbHY5K1hn?=
 =?utf-8?B?cG84Z0tsT2dUMkV0RndNNGNTSFp6M0Vkc1ZyWHdOZVQyUmxOR2tpUVlLSFh3?=
 =?utf-8?B?UFFGSnZYMXIzTU85c1NPR3QvZkxDK1JwZWI0d01qcm85VmN4bG9Pb0JyN3lF?=
 =?utf-8?B?am9adEIxdXEwT0pwaGlqK3RmaTV0V0NQMU02bXFtSksyUmRnQUg0VGtHZExs?=
 =?utf-8?B?cFd6VXQwTmZvMll2NVNZRlM1eTg1aHNKTlIvK3ZJY29Wc3NRMENRZmFpOEsr?=
 =?utf-8?B?cG0vN1kzOVRXUVNOSUFyZDNvcEhOZzdNWE5Oang5R0h0TG5KYng5YWM0Qmlw?=
 =?utf-8?B?Z05aZmJJNU40RGdNZVVpR0lYWW81Q1pTWTRYM244d05td01lOGZjSGo3dFVt?=
 =?utf-8?B?Z1R6aTE3d2xhWW1tS3IxOTJTWkd4Q0hpNG96Y0VyWVF6cU9EVWpuK1NmL1o3?=
 =?utf-8?B?YTJzWE92RE1BblhGc283WWtRZ3llL0VJOU5JVGpscy8wY3d6VXJRQUlxZnRy?=
 =?utf-8?B?Q2t2ZkFiS2ZnMTVCVFJRVGMwdEczQmY0Kyt0YkExUEU5M3Qvd0RaVldGSFR1?=
 =?utf-8?B?djIzWWY5bFllVHF5dWgzZ1piN2FiRVdMOWlMTWI5Y1dMNzRPNDdDQUFTSUVC?=
 =?utf-8?B?aStMd1JHVy9oRm9KRHJkakRmMzA2dzNwUkNxOVk3ZlBSU1d1VFlFbjJjVUVq?=
 =?utf-8?B?T2ZsdWN6TVN4WTlWOVBMNVpmamtCNnRIY3RsRmhxVUk4TXVuWklKeE9YYktF?=
 =?utf-8?B?WVlVQkd4U2p3UzJJanJicWxDZGJhWGpORFVjVnVldk1YZXpWUHRVM1dKY3BR?=
 =?utf-8?B?VGQ2SnpXM3BXMlFCTHFycFk2ZzBTTTRXZEptQjhhSWh1UllTWHdMWjJ6anRj?=
 =?utf-8?Q?5p3z7eN7zriKFLMJr7ejNsB5qNlGuy7f?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UG03RG8wWnhzRFJEMG93Tm44VnFYS2V5OFYxQmNYblREdTVsQ1VEcWNQMmcr?=
 =?utf-8?B?SVJXbGpRUnk3WlFYbWJITTdLc09ZK1FMTHFMRWxVQklGcm96WlQzeSt3bUww?=
 =?utf-8?B?SEU0K1lqV0dndzBrOFU4ekpGSTRsdlNiVk1icGIyajB3dU43SUpOdytnUmho?=
 =?utf-8?B?VTY3UUcxRi9SVTJIa3BucE9ETW5PZ25lZUNXMWNkckxXYXNJdjBlWVJsb1RB?=
 =?utf-8?B?aVA3UVF6WEVnMUtXNk54R2RzWGJlSUg1SFNuRlB5NlhFY2k3eFNrRUJ5OFF5?=
 =?utf-8?B?VGRZclpuZGdHVzJ0TGs2M0dseDBENzNVamRxK1QzZTF5ODl2TUJsZFNwNGd2?=
 =?utf-8?B?MFpvMSt1aU5FVWpFSmtrT2RMM0Yra1QwMVVGVy9pdDdhOEVNQ2E2ak1xWWdT?=
 =?utf-8?B?L2ZHQjN6VmdBVU1JeGVRM0FUVU44MHJWQ1VNNklhRkYwQjhBUC9pVmFjS01y?=
 =?utf-8?B?ajZXaHczMkpET2ZlL0FNTU1vdTN2VXBsY2w4eGs2M1czVHlKb2xHMWNXQVdR?=
 =?utf-8?B?ZlBkQzlkNTR1WkpxQ1p2blYrTlVwZG1hWW45KytHaU1mdGxqc1psUkRDQUdD?=
 =?utf-8?B?bkdxNUxqc1ROQytmSkYxd2VXcHdzTHJ1NUsvcEZpckYwS3FtZGhrQXB6bStl?=
 =?utf-8?B?UUx0UzlBVFpjbWd6MjV3Z29TTm5QSTdYVUF5eVlCcnEvaEErZ2p1Zm01ME9y?=
 =?utf-8?B?N1Axam5Ba1VLcTdweDlvZFY2MldaYkNEeVZZTHFVa1lEanA4bUhxcXRnTkFK?=
 =?utf-8?B?Z2dVTGF5STBqdnZGcG9yTlZUL3pZb0I0M0g4R0Z5cVUwb3VwQjNNTG9hNGJL?=
 =?utf-8?B?ODhNdkd1aFlGL3pXNXdINlJvYWZZSU5tVUdFYktNcExRYjEycmUrTkJod0ZP?=
 =?utf-8?B?NTdLeFZQVXhZTGZFaXowNmU2cExlUmlvMXI2S29XSkR0cTdaQVQwakRvK0ZF?=
 =?utf-8?B?VDhxT25Cbzl1Rk1rczRHMm85R3pYREc0eFl3NHJsaGpaTzJMUXdZVFUzeUFt?=
 =?utf-8?B?T09BS1AveC9WbFFXK1lEeFhuRmpDV1FVUWtBdkpTb3BWeVB2clYyMjRxR3Z6?=
 =?utf-8?B?YTVTMExaNlhzUFFwRVJTWEttQU1WMkJINTIrc1g3RlhjZFcwaWlsMlh4NDZq?=
 =?utf-8?B?VEFhckg1cDQ4WEgrc0hqclY1RGhwL3BJT2Y1bDdZb2Zua1AralJ5VGY2MklU?=
 =?utf-8?B?QnBQNnBPYXJoUFQvL2hUWTJYUHRsS05iWGhSTEFLSHk1bE5sNmVOQVVOZnl0?=
 =?utf-8?B?Slo1a3hnYWxESDJIc3BYZ1h0VzFvMjZwdFdzU2loVTVURVdmNUh1RURleDNQ?=
 =?utf-8?B?OG5kL0ZHNXhtTURKWStTVG1ZQTlEMTVOa2RPUGJyNHF2QlVJRHpNTXJoZE4y?=
 =?utf-8?B?RDNwN2lJYXdoNVUwT3hjcUpJbVR0eXhENE5Pa2VXRmpvUHBGMGlNbFNEOUFL?=
 =?utf-8?B?b0JSSFlVZjZpUjd1N2RkM0ZoL0ZEb29wdThvRThnbUxseXhQcVMwcmFIYVUy?=
 =?utf-8?B?Z2xrZStJRjhyVVRUT2Q1Q1RyWkg5Y1JiYjR5T2RHNjJvcU5SV1NQV3A0WGs5?=
 =?utf-8?B?V1BWcGduZTNlN296TENRUWIrY2hLTHVZSWRjMXM4L01TLysycGNQTFArTzVw?=
 =?utf-8?B?Z2JMODE2cWpPTHFPeUZSWmduZURZbGdCUG5JdG16V0I4SUNUMm8yajhqVnRi?=
 =?utf-8?B?eTFHK1pZOEFkQmVjZHJJaWdrZTRsN0hoZ0FqL0dmS0tPb0s2WXArWXlpeURz?=
 =?utf-8?B?djJSelZ6WnN4aHRHYWxIQy9HcENmQ1B6UEtxUGlXb2NVc2NBTXUxaW5MQlRD?=
 =?utf-8?B?dkQ4Z3o2aXZLY09nNlhSTUV6MWJIa3lzZkpORTloQ0tqNGUzTWsxNjFVTTdo?=
 =?utf-8?B?c0NSc01XK1NBbmlWWm1tN200ZzF2UEtRMnMrckhDK2tkSUhYTXJIRWlwUWpY?=
 =?utf-8?B?YmxqdXh2c2lwU0ZWWmxETGptdjdMN3BDWEdCS0o3eXF0MFVZTklqVU5DMlZn?=
 =?utf-8?B?ZEFnenArazNGVmRENUxlaVBQY2VaT25zdklYbXZ0RUZtbm9LbE02ZEJENkVQ?=
 =?utf-8?B?MlNwdXRVNkJ6ZHdXRnJ3MDh1YnJadnhhT0FSbmxyNHRUTlBIVzVZYlh4a3dU?=
 =?utf-8?B?cE5KeUY5cllSRjZlTkJoQUZDNk5XcjBmekpnYzNxbllVandSSmZ2c0dRN216?=
 =?utf-8?B?Z3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DAE65F240BFC9A40B1F24ED2300162DF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63078c4b-1fda-4e06-b1ed-08dd3a7208de
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2025 23:19:20.5733
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 019J6jfCVpqRrH5xsb9h/zIlS7yGSc0RlkvYmfX3pVduBwmobluPdgLguA9lkAERLLLZgzT+rS15et7J8j0gzEk/E9VjZtCn+7/nxPV2NVQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8154
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTAxLTEwIGF0IDEyOjQ3ICswODAwLCBYaWFveWFvIExpIHdyb3RlOg0KPiA+
ICsJCW91dHB1dF9lID0gJnRkX2NwdWlkLT5lbnRyaWVzW2ldOw0KPiA+ICsJCWkgKz0gdGR4X3Zj
cHVfZ2V0X2NwdWlkX2xlYWYodmNwdSwgbGVhZiwNCj4gPiArCQkJCQnCoMKgwqDCoCBLVk1fTUFY
X0NQVUlEX0VOVFJJRVMgLSBpIC0gMSwNCj4gPiArCQkJCQnCoMKgwqDCoCBvdXRwdXRfZSk7DQo+
ID4gKwl9DQo+ID4gKw0KPiA+ICsJZm9yIChsZWFmID0gMHg4MDAwMDAwMDsgbGVhZiA8PSAweDgw
MDAwMDA4OyBsZWFmKyspIHsNCj4gPiArCQlvdXRwdXRfZSA9ICZ0ZF9jcHVpZC0+ZW50cmllc1tp
XTsNCj4gPiArCQlpICs9IHRkeF92Y3B1X2dldF9jcHVpZF9sZWFmKHZjcHUsIGxlYWYsDQo+ID4g
KwkJCQkJwqDCoMKgwqAgS1ZNX01BWF9DUFVJRF9FTlRSSUVTIC0gaSAtIDEsDQo+ID4gKwkJCQkJ
wqDCoMKgwqAgb3V0cHV0X2UpOw0KPiANCj4gVGhvdWdoIHdoYXQgZ2V0cyBwYXNzZWQgaW4gZm9y
IG1heF9jbnQgaXMNCj4gDQo+IMKgwqAgS1ZNX01BWF9DUFVJRF9FTlRSSUVTIC0gaSAtIDENCj4g
DQo+IHRkeF92Y3B1X2dldF9jcHVpZF9sZWFmKCkgY2FuIHJldHVybiAibWF4X2NudCsxIiwgaS5l
LiwgDQo+IEtWTV9NQVhfQ1BVSURfRU5UUklFUyAtIGkuDQo+IA0KPiBUaGVuLCBpdCBtYWtlcyBu
ZXh0IHJvdW5kIGkgdG8gYmUgS1ZNX01BWF9DUFVJRF9FTlRSSUVTLCBhbmQNCj4gDQo+IMKgwqAg
b3V0cHV0X2UgPSAmdGRfY3B1aWQtPmVudHJpZXNbaV07DQo+IA0KPiB3aWxsIG92ZXJmbG93IHRo
ZSBidWZmZXIgYW5kIGFjY2VzcyBpbGxlZ2FsIG1lbW9yeS4NCj4gDQo+IFNpbWlsYXIgaXNzdWUg
aW5zaWRlIHRkeF92Y3B1X2dldF9jcHVpZF9sZWFmKCkgYXMgSSByZXBsaWVkIGluIFsqXQ0KPiAN
Cj4gWypdIA0KPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvNzU3NDk2OGEtZjBlMi00OWQ1
LWI3NDAtMjQ1NGEwZjcwYmI2QGludGVsLmNvbS8NCg0KUGVyIEZyYW5jZXNjbydzIGNvbW1lbnQg
aW4gdGhlIG90aGVyIHRocmVhZCwgSSdtIG5vdCBzdXJlIHRoZXJlIGlzIGFuIG9mZi1ieS1vbmUN
CmJ1ZyBoZXJlLiBCdXQgaW4gYW55IGNhc2UgdGhlIGNvZGUgaXMgdG9vIHNlbnNpdGl2ZSB0byBp
c3N1ZXMgbGlrZSB0aGF0Lg0KDQpJbiBsaW5lIHdpdGggRnJhbmNlc2NvJ3Mgb3RoZXIgY29tbWVu
dCB0byBtb3ZlIHRoZSBzdWJsZWFmIGNoZWNraW5nIGludG8NCnRkeF9yZWFkX2NwdWlkKCksIEkg
anVzdCBjaGFuZ2VkIGl0IHRvIHBhc3MgYXJvdW5kIHRoZSByZWFsIGluZGV4IGFuZCBjaGVjaw0K
S1ZNX01BWF9DUFVJRF9FTlRSSUVTIGluIHRkeF9yZWFkX2NwdWlkKCkgdG9vLiBJdCBzZWVtcyBs
ZXNzIGVsZWdhbnQgYnV0IGVhc2llcg0KdG8gcmVhZC4NCg==

