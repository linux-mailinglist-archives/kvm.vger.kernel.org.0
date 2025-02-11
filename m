Return-Path: <kvm+bounces-37808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A675A302AE
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 06:05:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 95876188AE9D
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 05:05:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77F181D86ED;
	Tue, 11 Feb 2025 05:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FO8EoGu8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF6B1CA84;
	Tue, 11 Feb 2025 05:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739250316; cv=fail; b=JNUNHoy+rJNb8KEz3/28J/RwDYzVUm+24ws0bdQwV6p5MgF2579cZm2Je6pUjaj+H5E/oPrM0Cqyauvv1LqW6zgfkMfuNl0ASOyMC9AioY4LihWf7UIMwSPV4THxuJm9VF2TfqKOtBcEBHPiHdV6sTs9AAgAv9fO0HWz6y2sVcQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739250316; c=relaxed/simple;
	bh=Q3SuIFBzcxXrRhufDxx5Y7DX4uzgMnMkg4VfHWdCi/g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hG2WG3oaS2afLnwcUJgyjUezrK8k7OEHtd+o1FlDGQJ6YBXs3ITwJAjb/Miiv41g0IpbQXJ5WZrYdIzOCD2nt87tY00Xu4iQ2rpXsRTWgvLr9+gyY8fF1PseSUS0kPqn9RwhL6kzt8KTHh5lRMVjeYaeqTLvh+mbDhmasEmfD+4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FO8EoGu8; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739250314; x=1770786314;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Q3SuIFBzcxXrRhufDxx5Y7DX4uzgMnMkg4VfHWdCi/g=;
  b=FO8EoGu8PZS0W6h0ulT3KqMm23abzhpYzX1NBBTZ931vJns0RvJ9rI3S
   XJ5pLDEpXqsEQ+jvjrnLTuqt1VLmr2T5DvhR8iGXVLJ+NSMXmQiIkfmN9
   Rh6kKhOFA0ugCvoYAp5KcBaBc4H71EEjptpFFJLsh38t666/UjUw+kY+/
   v/KPa4sDHhu5f1eA2bJHRCVLCtQswU0H6TIhmrrDF18eQOSE0hb8OWgCj
   UgTtOQnI4/fjwn07+au5BbtkhttPueYYG12XAqWLPM3MOcdFrIlZVypy+
   2ETMh6JY6ZWFkbCkuWqQ2nNvFVp47+VyQb0gTNu67ALJ3a7a7SBpdYcRB
   Q==;
X-CSE-ConnectionGUID: 365pDX1pSWiXZeXx1LfFyQ==
X-CSE-MsgGUID: r0ajsIQSTJuEz3iyZz0SaQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="39718785"
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="39718785"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 21:05:14 -0800
X-CSE-ConnectionGUID: F++oFPb1S7yjfkBvtJgSYQ==
X-CSE-MsgGUID: MZRd7zFcRZqHXUtq5RotDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="117597632"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Feb 2025 21:05:14 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 10 Feb 2025 21:05:13 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 10 Feb 2025 21:05:13 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.43) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 10 Feb 2025 21:05:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T0XQUt6nVg9Sud49Uy2iV9cINH7Hiipj5HRw60QS3CPawD5YmefZRWZBdWEZ3JgbfPzQcmM2jL60D9vYTyTE5AsS2um+gqbfSaM+RWf2YNhkQDxvR4oyGy5c18dZtFs9xWiGdvSwbXkZSxqeptmPN6C/DSoiqy1ApnSyovveIsH96E2HxlCqkyDPZ2XKWqev3mib1R14BHh39Y6Vlkhi81CmVJXHDoB65wqGu2qFYuYh4OSGK7MlqlpK3zlyw0sirU3yXRkO0t/b79mmKBNaRtcc1aHjYGWFhAmiaYbaNOQ6jqv6GUIBq1y7GisP5EIVxzg/7GUtodRgRjDzHNWujA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q3SuIFBzcxXrRhufDxx5Y7DX4uzgMnMkg4VfHWdCi/g=;
 b=U40AWOsK2JNziaCCZsMCgj7PcEf6xYe4HvsVJYRZ542xrzF/jc3aAXoCy9CDTmZL5oyngtwsfIQhRD7KBWbF2ni4j8qmNOxHobVhiCVbu4f+zGe8A5eWP6KtyXKNxK3mvTPi33eKE2cqn/EHEIowKYeFAt8Dmg2FZOlQxR0uASVCxRECTTwoc6FPfAwz+HH0i2OXrcUIZ0SwMwEDz/9dS85gsReM0ioiTcQn8prMTLn7D6bCVvUJAH42Xxbqr7r0usvlCdCxiWGJhM6OUC9W9dlbQd5ezcU7XyAdDElDlwE6UJAR5o1Sqkop7EtG+llxIT2Zu+snL3XwfYpHvvIRCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB6687.namprd11.prod.outlook.com (2603:10b6:806:25a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.11; Tue, 11 Feb
 2025 05:05:10 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%5]) with mapi id 15.20.8422.015; Tue, 11 Feb 2025
 05:05:10 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"Lindgren, Tony" <tony.lindgren@intel.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v2 1/8] KVM: x86: Have ____kvm_emulate_hypercall() read
 the GPRs
Thread-Topic: [PATCH v2 1/8] KVM: x86: Have ____kvm_emulate_hypercall() read
 the GPRs
Thread-Index: AQHbfDAdHdE1vXi33ESmwEUDitMlkbNBjKiA
Date: Tue, 11 Feb 2025 05:05:10 +0000
Message-ID: <2aa9a47831205744f826b66e20001b2c6fde6d68.camel@intel.com>
References: <20250211025442.3071607-1-binbin.wu@linux.intel.com>
	 <20250211025442.3071607-2-binbin.wu@linux.intel.com>
In-Reply-To: <20250211025442.3071607-2-binbin.wu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB6687:EE_
x-ms-office365-filtering-correlation-id: dc5cad5f-e2cd-46de-c313-08dd4a59a8e2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZnBwRFdBbHVzMEdGZzNyV1JOS0t6cDBLb3VMSktSaGE0bU10cHUyd2xNSS9I?=
 =?utf-8?B?dnFpaGpwelEvOWZKY09sSExGRFEzaGJXTm5nLzI5QW1naEdDd2g1bXJpa2xT?=
 =?utf-8?B?YmlCS3JjVFE3U1hUU3dUTFZKZWNSVHdsSVdpSFlOa09ENXBxd2NPWklhVmxM?=
 =?utf-8?B?Q2R6WDF6K0xQYWNNTDJsa2t4bWYvRENCczRVWmRYdWVVeDRoTTdEaHhRZzBR?=
 =?utf-8?B?ZGJhbUpJZ0R1TDNiVzQ3TXJZQ0gwMnVKYzJyeHlXSVF3RGNYb04vNTFDd1hm?=
 =?utf-8?B?S3A4ZXRUeXloeW1zMkRvdGdDeEcxb2UyTGk1YXB4ODY3UlUrcXJ0SEtueUw5?=
 =?utf-8?B?Yng5WkRiczU1dXlPS0QxY2t3TFptVTFkRU9qdmttWjBQdVRYL2laWERtMnVR?=
 =?utf-8?B?aFhXWFAyTVZ2WURJQXZHaElqWUpYSWx2aFJQS0RlNkZXZDZOTm0zSWg4WVMw?=
 =?utf-8?B?TkFjVm55NFJyUWVha3RRVFJYMks4RnppVzBQY1U1bkM0ZXBPdWIycnJlSGNu?=
 =?utf-8?B?aHprRzJuVEdhNVpGaUNyTEZ4QTdTQXIvOU1sRGhwUVBOS2ZSMjFxSDB5Vnc3?=
 =?utf-8?B?VHZCak5NZ05XWms2MXhMSW02MDVIK29CNDYwVVhtZ2haRHRsRnp3TlEvcnQ3?=
 =?utf-8?B?WHQ2Q1JNWGNKZ2plZGhRaHdwcHlqRjY2Y1NteFZENmZaYlYwWWQ5YTVKVG1p?=
 =?utf-8?B?UDFPZml2MlBjeWNQRERWNFJKNFBZbHNBUHBVcFVwcG1YSlI3dnZHc3U2bFFj?=
 =?utf-8?B?eUJCTWZLRG5RbWpsREZvUWxpVTFZT1RVSHhqdHVZOVBOS2hSTzlrZFhxNTlX?=
 =?utf-8?B?REwxc0xtQVVIcmRFQjBaOTEvVDgwYlRtTGVFT213Wmg4SWpTUmNJWTE2Mmps?=
 =?utf-8?B?UzdXMWZyVGpFczE2Yjc5YnhMVWFrS2RmdXBFLzhBUzBYWmkyR2ZRK1Q3R3BW?=
 =?utf-8?B?blNLTzFXS3NHOHJya0JFRG5BcDNtRlU1MFgydnRndDFBeUpuT3dRNWU4ZitZ?=
 =?utf-8?B?MlpFMG1xVmcwK2RHdExnOFViREp1a0hJSGdSYVlqWXlRTXNXV2hDeUFsVXRt?=
 =?utf-8?B?MUl2L3JickNrTmxWbzdlQitSakJLUllySlZaUEJZTUxHT2tpNENpT0dZZzVX?=
 =?utf-8?B?MkEyQmRKRWQ2S0toQURVZzRwQzcxWWcreTBRM0V6N2VMYUVWUzhHVDZ1UVFo?=
 =?utf-8?B?T0F2RUliSzk2a2pnQWxsWE9RUWtSdCs1VlZlOGYvSmk3RnRCRTd3NWQydGNY?=
 =?utf-8?B?RDJVOVcwZW1BSFBmMHRmblJ6cDRrUFo2ejJpNEZjcURxSDN1TTJpSzNwZkFH?=
 =?utf-8?B?a1JmYmYyMS9Tc00xeDVyNWxveUVPTGJITnY0empCNUFjWnFBRmpvV0pnOHZK?=
 =?utf-8?B?a0tGRHRiSjh4SDIwdk40YktxQzBUdjY2ZTZDT2xnTHR4UFBIRmZONFoyRW9o?=
 =?utf-8?B?aWc0MitOalpveUF1YnRYKysycmJlRGV6NXlMdGxTcVhwUFZwN0FwZ1YxOC9V?=
 =?utf-8?B?UDNBaVJIb3lUWVp4RWl2b0hhVjJPVG5JVW9IajVMeEpEeDVHbkJackpnSHRv?=
 =?utf-8?B?OVBxaE5FOWZPakhiOUVsT0EvcHZuRUtKMHJtaExUY25tTm9yeExYR2Q4SXZZ?=
 =?utf-8?B?SXZ3TlRpQmxramJFMXliSEM0c3Y3WDlaQlA3bldCeC9CcDZNS3RXWk0zRU43?=
 =?utf-8?B?MzA2cGJETCtleFNrSUdyYnluNldCaUFBdHQwdmtjMms4djRhSjhWci9wSi82?=
 =?utf-8?B?ajVGbGlJK0EwZjJGQ2tnWnlabG4xUXB5WFNGSERTNEZ5Z2psVlh6dml5K1ZB?=
 =?utf-8?B?SlRiWlVVL0R0aXk4SmdCRWZTWDhaNkJUSUh1TGFFVkczbmpwK3p6ZUV3QzEw?=
 =?utf-8?B?bDRWcTVmQk5NdnVKYlpOVngrMTl6c0RKS2ZkSlRQUFFJd3dwWm5xU1VOVHd5?=
 =?utf-8?Q?gid+o80y1H8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dWNzSEh3bjFCbHBYRGhtUUxzalBqYzlYRHk4MzUxZVpqOXpTRkpRazVXNjhH?=
 =?utf-8?B?OWxRMVV4MnR2Y3BENTM0UTN2UXV1b0RRb2pKMjBjUEl1VVYvbTVEYW44aWhi?=
 =?utf-8?B?ZGowRVJQWEV4UTdQVEY3c3FhOW04WWJWMGllZC9UQktPcVdjT0dyeEtkVUxO?=
 =?utf-8?B?aGVycGZrODVVK213OVdtS0FLMURRYzNtUUE3YzdUN2NQOXEzV0Y0Rm5OSzVC?=
 =?utf-8?B?TE4vbTErajV1MUtZQkZVMlpYamZ4a1ZSQ0tsNFpnaCtTVWhtSDBlQWxRZEJW?=
 =?utf-8?B?UWZ3NTVFd1o2Uk9Sa1lSRk44dDVlOE5wVmVhOXdSRzdpc0Z1bVVaaFlkRGVF?=
 =?utf-8?B?aTlCNmY0dzhvdyswQmxPTFZxdVFJWTJtSERjZUJ4a09NT0thcEdiS1BBRW5o?=
 =?utf-8?B?RHVydXhKeVdQMXJ4TklwamU3SXJDWDl4REdLMmZGaGtsbndZTm5QYldCYnI1?=
 =?utf-8?B?UGdjKzZ2SE50QWk1SkpXRmthSkhTQU5ib05oejZKWktUVWh2ZFIxVlBHeGNU?=
 =?utf-8?B?eEJwRm15QlBNOG5kTURKVGNpSE1VU3p0WlR3UG5yVUd4OS9SZlBvQnAwVGM0?=
 =?utf-8?B?aWZST3dLVzY2RUVudGpncDNva2R4V1dLeGhsamdEZ0pmZkcyV0tBbUMvVEsy?=
 =?utf-8?B?QXF6TkdOSUM5OEVoNXRUMUlXVGRmSlJKRGwyUUZEMDJWZTRlQm5zYXRUb2Vi?=
 =?utf-8?B?WGFneDhWc2JzcU1UYWh5VGc4VXl3cDZlSXdJQy9pbkhrOEphcUszSE9ramsv?=
 =?utf-8?B?MWM2WDZoNzNCNlFlTEF1SWx2MHMra3dDT3o3N21mMklKM1BTcng0K2w5SXNt?=
 =?utf-8?B?dlZ0ZDNRTkNFZUI1NGJKckxiQlJOUERsbTFTdnZQQmk5c09zVzhmMEs1ODFx?=
 =?utf-8?B?dE4xeEdRZUlRQUowUVg5RGxPZ0U3Y1JqQjlxSmtEREV3RDh5eG5vaTREcG90?=
 =?utf-8?B?NTdWTWp6UlpnQWRsSkhSb0ZOSWRlQm5TckZvZTZKcXBMaEQwc0lGMy9jWWdI?=
 =?utf-8?B?MUI4TkhYK2tRNzVWVjZnT3cxaFIvUkx6MVp3OUxFMU8rMGpDZVdQcVo1TFg2?=
 =?utf-8?B?dEo3MnRqb3RGRXhaVzJpMjh1czNVU0pBdmtvOGtnMUp2R21qU2gzaTUrbUdk?=
 =?utf-8?B?VmZIbHA1QzBVTnJuKyt3eXBkS0w0V3R3NGJnWnEydnZEbExGeUN3ZVNlb2d1?=
 =?utf-8?B?bjB3SGVNeWp3RHU4RTAxRWljN2Qwd1YwbGNTMGtOYnUwanRDNlZ5Uk9VZ0xC?=
 =?utf-8?B?anV1NjdrSEx6b1A3aTA0VU4vVkR0U3kyZndMbUFoYlNCQXcyZzZmMGlQVTZr?=
 =?utf-8?B?TnZTeXVEam5UTmpyZW1oc0xnc3ZvRjlDOGRpek5XZFQ5VHo0QnErTHB2Zkh3?=
 =?utf-8?B?TVBWLzBReGhVN2VmOUV1aDF0TDRzTjhTT1ZKUXQ2R0Y4bG05bllpRFFkd2FK?=
 =?utf-8?B?T09tR3JFVzNZbHEvVXFMSUplbzFLeHpoVkVBNW9taUFQVWlqYmVOTWxkMnly?=
 =?utf-8?B?eHk3OVFQaWlzMmhEY0M1aVB0cG13QWFnVURHS2VJZlpXTkd2WEVVZjhtZ2xJ?=
 =?utf-8?B?aFhjbWF3Zm5Jc3lqMWZSTGo1cm5wdC9HamFVUHhEaVJQZ2tiaGpML0VRakkz?=
 =?utf-8?B?MEZwSllZMThqSFF0TnF5ZUhCZmgyU2RZaVZiY1MyU3h5WTMxUnRTRWMwNklt?=
 =?utf-8?B?c1ZJeE9Sd3A3ZkFpY2VyYks3dUhleFQ2QnAvYUpEZ1BySFhMSGRGL3JZTnpH?=
 =?utf-8?B?RTYvWUZnNXJjTTF0M3lGdml5M0V1UmlqeU5CVWRzWnBDZnRyTUw5MGhmOW8w?=
 =?utf-8?B?b1gyZkQ1VlJzanhWMCtCSjYvbU5ZMjlzWHpQQWRyMHptLzdTRnAyQXlEU1NV?=
 =?utf-8?B?UG5DamNVczlNNHkzQ1V1M0dQQ1VSUzBKWjN2b3JTYkx2dWoxME5NQjNZbFdt?=
 =?utf-8?B?TXgvak9XKy8vTDZFWFZlZ01pOVlieURML0FYSFdkUFNNQTMyRGxkVG9nUis0?=
 =?utf-8?B?bEk3S2gwN3owaDRIdDlvUU1UbXV0VTc4TjdVMzU5Tk1INGZyZUI3Q05CandP?=
 =?utf-8?B?bVZCMDVXT1Qvc1pUbzhpRzJpL3MvOTd0WFVCWXRncTE4dmlaUFRmOTVIYWI2?=
 =?utf-8?B?YzZNMkVSSkZHd0NHRHIvcThaSTQ3ay9NVlBKcGVZa1VvVmFLN0JqY1h4cjd0?=
 =?utf-8?B?RHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C656A8D3F12AB24CA97B727B620D0FBF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc5cad5f-e2cd-46de-c313-08dd4a59a8e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2025 05:05:10.2412
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s3NDxLOPipfpKinuniDUmic/jPxF2PDsTG+Qqfrn5HthmHwoTyqXYLEVjimKs3iLHZUq2oRkthe96HGeqspCRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6687
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTAyLTExIGF0IDEwOjU0ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IEhh
dmUgX19fX2t2bV9lbXVsYXRlX2h5cGVyY2FsbCgpIHJlYWQgdGhlIEdQUnMgaW5zdGVhZCBvZiBw
YXNzaW5nIHRoZW0NCj4gaW4gdmlhIHRoZSBtYWNyby4NCj4gDQo+IFdoZW4gZW11bGF0aW5nIEtW
TSBoeXBlcmNhbGxzIHZpYSBURFZNQ0FMTCwgVERYIHdpbGwgbWFyc2hhbGwgcmVnaXN0ZXJzIG9m
DQo+IFREVk1DQUxMIEFCSSBpbnRvIEtWTSdzIHg4NiByZWdpc3RlcnMgdG8gbWF0Y2ggdGhlIGRl
ZmluaXRpb24gb2YgS1ZNDQo+IGh5cGVyY2FsbCBBQkkgX2JlZm9yZV8gX19fX2t2bV9lbXVsYXRl
X2h5cGVyY2FsbCgpIGdldHMgY2FsbGVkLiAgVGhlcmVmb3JlLA0KPiBfX19fa3ZtX2VtdWxhdGVf
aHlwZXJjYWxsKCkgY2FuIGp1c3QgcmVhZCByZWdpc3RlcnMgaW50ZXJuYWxseSBiYXNlZCBvbiBL
Vk0NCj4gaHlwZXJjYWxsIEFCSSwgYW5kIHRob3NlIHJlZ2lzdGVycyBjYW4gYmUgcmVtb3ZlZCBm
cm9tIHRoZQ0KPiBfX2t2bV9lbXVsYXRlX2h5cGVyY2FsbCgpIG1hY3JvLg0KPiANCj4gQWxzbywg
b3BfNjRfYml0IGNhbiBiZSBkZXRlcm1pbmVkIGluc2lkZSBfX19fa3ZtX2VtdWxhdGVfaHlwZXJj
YWxsKCksDQo+IHJlbW92ZSBpdCBmcm9tIHRoZSBfX2t2bV9lbXVsYXRlX2h5cGVyY2FsbCgpIG1h
Y3JvIGFzIHdlbGwuDQo+IA0KPiBObyBmdW5jdGlvbmFsIGNoYW5nZSBpbnRlbmRlZC4NCj4gDQo+
IA0KDQpSZXZpZXdlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0K

