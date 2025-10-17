Return-Path: <kvm+bounces-60272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B8378BE660F
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 07:13:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 988244EFFD8
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 05:13:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C214530C62B;
	Fri, 17 Oct 2025 05:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PR45+EWv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E1D10F2
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 05:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760677994; cv=fail; b=VhW5YOTViF3sWeN8ksEGM800ihmbHjxTsnl9bTcWhx3QavQErlRxdA8/zTEPjrPXfnJT1gcZny/b75lgPrMh+a6V+dZyen5JWUYHmVCXdHx8d5S6ibAa1pn9+68E136dFQQu4OBMKGlKyeDpCaDPTJ0ZklyaxZoyFrM4UUImOd8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760677994; c=relaxed/simple;
	bh=I1GAIwRLirOZdXAJ05c72d2pv+S8Zmzd4eFik5Xx0iU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mT1XKfnQO7a1Dm1uYtdQfQ9CdGGDKeByVz37oWqe/0FNc6LuF/fu9XJZsCrjC0oQzB8cKAlyUHXB3DHAYm9GDaLqf07nacHw8hMR9oui96x62TfHZaYUuOlnNUQLpGHDW6hDQGqQ8hNmBbDuD8HpvDocG1t63NM4F6IS+Rjxvsc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PR45+EWv; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760677994; x=1792213994;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=I1GAIwRLirOZdXAJ05c72d2pv+S8Zmzd4eFik5Xx0iU=;
  b=PR45+EWvH5k4RuABUOq91NLNUpKjVaCg9s1p+9KJz7DtB6w6/fQi7Y3u
   opewbdXxYJ39QfBU+xMP8xAinZIYAHfFLF2cbsB0Cthi4uhSqN6tOLAtH
   Z+pP87k96LvAIAGS8sYcZB+EGnVEUd6CGh7Wm4T0UytN0xRCY0sNdgSO3
   JANwmhASct17t1ZYgkmmf8WfYvjWNFdFnja8czToklare0VQqLBwV0YJB
   ztmp1d/QMztZjx9M+4Ev+3S1cmoHY+J0XrZuBgRBKTL99NheBodZ5j1/a
   xHlLA58B7cvMPFwYH6Re6sajK8WiRH140j7/1R+3SkrUvy8SJoxY1JYDh
   A==;
X-CSE-ConnectionGUID: AYnS7ib8Rw2594o0r0zFyw==
X-CSE-MsgGUID: b5SD93zZTeqILv4zxPZ+IA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62793050"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62793050"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 22:13:11 -0700
X-CSE-ConnectionGUID: ShUIuZZQQearTi1qfl8QmQ==
X-CSE-MsgGUID: jLHTUeghTV+pCylrrbZtWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="182630142"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 22:13:11 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 16 Oct 2025 22:13:09 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 16 Oct 2025 22:13:09 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.58) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 16 Oct 2025 22:13:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rvHCZ6olW50ykhSEWwhgridxfUDceTt8hc6VU7WWUHPwKCQ6plOB94GL27ttteU0uNBedrWCCULWpKZ+nFqg3FBJ9zP4lG7XFw0pSpAgK/wVhP73jj0mmr7fR9pIVkNgkE57en/PsrOhq0Ku5oUzdxkg3EO7cf4RcGSxDLSgJ9/FRm4YJLMxTpCmqiYraDYnK1ljMNV8L7bsdL3hVtddzyv2/qXSDEr45fXUxyqeNVz5aYqFHcFJQjSSZA44+Yxky3LciZZt+bvEpf+Z7UjD/Lk0jWYRQKah/SMjRTjgz58guHw/yhI/2kOWIPJHAIAwNXbxkW518MJt43P9CIUePQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I1GAIwRLirOZdXAJ05c72d2pv+S8Zmzd4eFik5Xx0iU=;
 b=F9II0SgdkkDiWVT90htVKLPmSAx9Swijk6tF2tnwfs2D13WEJvIBGI5M8gmDwen/ZHUV/sR3OFC56UFZqeq6N8pS2MGbD+WTztV5/dYl9Cr31TQ1oDZs8htOiqvbelfBUppyeDpZc9MD/i8/Ge5lGqXvsO6wKoYoFdZuBvlsZCAlx+AVwvojrX3anzrhIpoLAxLskS2xNn503bt9/SxFO+r/yPNFmoCWHiTKUIMnT0tORh94fb3jCWLYTxxKALm9F7prvHa/MRD154tJnJ3VdyzUSMFYoMTaX3d0IZ7JqZMOx+A6yYpHdYaY7eaN+CP+QQAdMHD7pqZwkmESv1RXKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH8PR11MB7046.namprd11.prod.outlook.com (2603:10b6:510:216::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.11; Fri, 17 Oct
 2025 05:13:02 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 05:13:01 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "nikunj@amd.com" <nikunj@amd.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v4 7/7] KVM: SVM: Add Page modification logging support
Thread-Topic: [PATCH v4 7/7] KVM: SVM: Add Page modification logging support
Thread-Index: AQHcPApPs5Ht3xATnUuwjLhVdjLj5LTF0VOA
Date: Fri, 17 Oct 2025 05:13:01 +0000
Message-ID: <293a8667840799f396fe4ad445c012e0e33dd189.camel@intel.com>
References: <20251013062515.3712430-1-nikunj@amd.com>
	 <20251013062515.3712430-8-nikunj@amd.com>
In-Reply-To: <20251013062515.3712430-8-nikunj@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH8PR11MB7046:EE_
x-ms-office365-filtering-correlation-id: 8fc8bc80-0bf5-4fe1-faf9-08de0d3bd86f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?SXpFU2xwOTBBTHNTZisyV3R3dVAwQTZ2blFYUDloVzJiNGV5djdHS3VqN3dR?=
 =?utf-8?B?UUNCeUh1eXRaenNiQ1ZEZzl2aDBtRnFvRVQ4T3lzbitLTW0xNzhaN1F3d1RV?=
 =?utf-8?B?aHNPa0g5Szl2V00xTmJsbUZOQXlDUTNJTGVBdnFoaTh1eHBneVRaMTZDQlNa?=
 =?utf-8?B?NzN1eDBOK1QrYXEzT2FjY0haVldURDBjWGtYYThiVzE3WkVqUG04ZVVQbHNW?=
 =?utf-8?B?b0pORkF2M2V3WGNYa1hJSUFFUzZCVXB3YjhncndHODNWamh0Sm9lQU52andr?=
 =?utf-8?B?L2VrQzQxbHpRa0hacnkxNUJWWnpYdEwrWWt3NU5CU3dFK2xZQ3dUdGYvaDlF?=
 =?utf-8?B?TFVncTNkeGtEb2l2dE9WQ0N4ZnduZWJyVncrSUZjdGpsNmFtZ0syYnlMUWNI?=
 =?utf-8?B?d1htT0NFSktwcVZ1Zm5OLzRjU2hEZ2wyTUFqQnI0c3doeWE0eEJvQUtndWxW?=
 =?utf-8?B?R3YxQkRqVnQzRXkybEp4YThKNkMwR0lqQXZFbFNxN1RkeGhlZEY5MTBkQzND?=
 =?utf-8?B?UFVkNE93cCt4eHhTRGVhV1hLdDg4OStlaHVXSUozSUFxL052bTFSN0tLbkwz?=
 =?utf-8?B?ZW1xNjJYQ2tLU1lTT25EN1JkK0VvZzk5MHdHbGhLYWt0NUh0YWl1NHJvZVYw?=
 =?utf-8?B?QzVVMklGUzJsSDFjcC94Qm9HNGRGUEtxcW5VK2VKSlhrU1NMdXZjV2ZCRExh?=
 =?utf-8?B?N1pSU0ZwMFBCUnZnL3NFRmRPUWkxWmpnYmxMbGFSbUVmRUlQL21ZbWpUSnll?=
 =?utf-8?B?U3ViQXNqaU1xSWxnaW9meTNhaGtxSUNrZmNLSFN1YW95NktJYjRHZlNmeDN3?=
 =?utf-8?B?SnRxN3RhTW45RS9FNGFZMTh4aTBtR21mNVlIWXZNalh5NlpCSmZqR0VJbEMz?=
 =?utf-8?B?ekdNZHhEZnQ3RXFaeHZZTkJESVpYOTA2MTJMMjBablFieFh6dGpvZElnS1gw?=
 =?utf-8?B?WTVhSDEyWllaRzcyWnIzV01Xa1U3YytoamoyeTFGNDVUcUNSY3Q3cW11elpD?=
 =?utf-8?B?RlFyYWlBNWsxTTBQNng1b3JUeS96OThqVWhpSHp6UmxOODllTDdtUDVOa1U3?=
 =?utf-8?B?N0gvYWdJcE80aFo2RUwwdVJNUXRucmNXWStCZEF2bEZ6WWllY1pZNDdkQUdk?=
 =?utf-8?B?UXM1SkRVcG9rcXhtTEppM3VJckJYUkkwNFNTOGhmSU5OV2xZT0g5TnR2Ukpx?=
 =?utf-8?B?OWQ2a2czNXFBV2pEZEdLTllLY2MzNi9TTW5BczdpbnBFZWRmanptTDA3L3ho?=
 =?utf-8?B?bTI5UGFWKzBJUWtrbzBvbkJDK3M3ZitWS3FUT3JnTnlsN0JONEc1MVRYeFFk?=
 =?utf-8?B?dWo4M1g1dExsRStOMUdoem5nazgrRjhwK0h5bTFBakFNb2NYVFJMVkdQTDU3?=
 =?utf-8?B?YkpVWllEQlpWcVJYeCt4MWdXSWJtUDN5dDY3V1Fja2o0SXRQWlRHNGN4YlVI?=
 =?utf-8?B?SXdUQmM5SVVDYjVOVzVrQzIxNWFtN2dDSmgwVUU1UGcwK3RXVXpLZnJ4UlBp?=
 =?utf-8?B?cUtSY0dnLys0SCtvTjArU25iNU4xZmRFd003R0FCaWpKY0ZNaHZVckg1UXh2?=
 =?utf-8?B?eUZzanZ5UUNHaEhFc0NDZncyZUNFRUxwbjZhd1lDM2tCZFNrMEtyNzBBeXhP?=
 =?utf-8?B?TWZlVDRaK0lXc1ZDTHgzdFl3Ym9URy9hTnQ1Y0p0ZGM3U3VRKytxbDNTQUJ3?=
 =?utf-8?B?R2J2MUR3R2t4cm51YzJKdkF4d2tCWmk5NVRZU2pEamUxMGNKaWZGaUs2UGVY?=
 =?utf-8?B?dlNxeCt3cm9ZRnlkaVJQVGl1L3pycUhOTG00UmllNzBFU0MwVHJ2Y0FxVUQ5?=
 =?utf-8?B?SDVnREhOU0ZhNExDVUlGamZKRmZRWGQ4OWlDQmpKRDFwL25ZUnBpSmFkbDVl?=
 =?utf-8?B?Tkw4QmpjV1d6Q0d6VDUrVjlIR2VJUVZpSjdVc21NUE9LakEzNTFTR29XTzhU?=
 =?utf-8?B?ZThwYjZlZlhucmt3WU1VcHRpUkRzL0QxeWdGRzNsUTZGSzEzVFdoeEx5dFlY?=
 =?utf-8?B?VnRoTDVSUTJSSUpmZStEVjk0SE40eWJSbGtLdXgrS2xFalU4Q3FHZjVoNjVT?=
 =?utf-8?Q?j3Ff9A?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RGpnYUJORDFMSlF0d1lHSmVXOXFQVHc2WFQxT3JQNGsyZVNPdlROYWlkVi9W?=
 =?utf-8?B?VXZ5V2g1TE5OMmN4UlUwOVRtK0RtVmlEc2VPTG5CeEJ2eFd6dG9qZ0JLN3pF?=
 =?utf-8?B?OTBJSlNKMk5JUXVUcWtyYXZkMHlvVnhRSkdpTU4rWXpIN250THhoUXRlR1FY?=
 =?utf-8?B?NE9VVW96U2MzVGJ6LzhBbGptTUNwVVdEZ2tpUkZab0pIbENLc1l0Tk9UUkxJ?=
 =?utf-8?B?cExQY3pXZEJDMUFpNitYbWhpeEFjVS9DZDcrRnd2dy9ES0F0clBiOXlqNVlH?=
 =?utf-8?B?WVZtZ3dHZTc3c04vMGNETis0dGEvUVFqTENVOWtPMTdnTlBiRFJPV3NBT3Vw?=
 =?utf-8?B?aUgxMitIQXRka2w4SjhlenkrcHBGRTBiRU10MSs4d284WGtlRHNVUGwwcmxu?=
 =?utf-8?B?MVRJOUNtSTgyQllWUk82UWZ6ZEExQWdJbm1CKzRFcXpOSlJUcU1ZQWpPbmRo?=
 =?utf-8?B?WW1PVU5xd3IrQjZqOUNDSGdvTlQwY2tkTVlXYUZzWGNRTklNYnd2SXJwSTBp?=
 =?utf-8?B?STVMVlA4VjhqNWZxVXV6QTJycUExakFNKytFRkdFL29ueUJRcXdSTTh4SldQ?=
 =?utf-8?B?a0hGTWdXWFRVemtTeTJBWjkzaHNHayt0RVQ4VHpBWU1UOXRrWG1RYmd0dEw0?=
 =?utf-8?B?dXNqU1pqQVZWenB3R01Gdm5jMVVvNDVpQldrM1htQjN4S3NEL0lSc3E3ZUI1?=
 =?utf-8?B?TlJtOTVEd29SajdLdDNEQThtenFka1FVdkh1UEN3RnU5Wmt5NFlEcTRmeTBC?=
 =?utf-8?B?MFFPZkRpM1RyOWdTRWZvSGRCRjNIV0t5Tkk4TmRsdlEzS2Fxb2lmdXBycDUz?=
 =?utf-8?B?N3FBWHkwaWVGUjErOHhpYjBkTUJHN0dBT2hMRWluV2UzMVdEa25YcTROcTJp?=
 =?utf-8?B?MUl5UklWdjQvb0VUa0FFYjVvYlpVdEN6OUoyM0lqQXhmazM5cE1CZFk2NTVQ?=
 =?utf-8?B?alJBUUo2L25mNTI4Q2ZyNmF0Zkl4a2ZYVkcra29ZRGJHV01nUDIzcTlRMDRv?=
 =?utf-8?B?OW1BUkhiVTR6aU5qT2VCN1dISDBIVXJOQmZVeGVPZmtnVVlRdllvdStMTk4z?=
 =?utf-8?B?THBvVjUxQVR4SVVWd2NiT1JFSllnTFl4UXRGbE15VVRPbVV3d2V4U0tuYWRv?=
 =?utf-8?B?Qm4wRE1zcWcwb0ZUYklNMGxHajg4Y1R4UTJodnlNUEtkNVgybW1yWVVxOGJy?=
 =?utf-8?B?UlNYOUV3V0kwd1B5dWNuZjd5anZMK0R5dTh0azlOdGwzOHBsS0ZRQmxPTlJw?=
 =?utf-8?B?V2tGWmR2bXBTQXBHZ2JPMzJPTkx5ajdUTjE2RnVPdTVOblRkd2dBQW1QbXI4?=
 =?utf-8?B?c204UUczMEcrQW95NEE4NTkwUlQyREo1Qk16bUllcE40TnMyM0lwV3JmSnky?=
 =?utf-8?B?OG1hUXEzdmgwS24rcDI1RzN5NWNMRDVENDQ3VnA2ZGpDY1RHSW5sVTZ6dWhN?=
 =?utf-8?B?VVlCb3NETG9YcEVIbVpFeGxmVXh5cHNwMVhNQVFwNElBbjgyQk9aN0VpdmdS?=
 =?utf-8?B?ZlhFcDV4ajRyVVVTa1U2S2g1dDFad3o5S0hBaTVPNmZPbTdISzNXUDh1T3FI?=
 =?utf-8?B?SjBucGxTbmxjZjA5eUJKZHpWcmZtRmRxQy83ZnM1eVFjNC96Q1NxQk1kM1Jw?=
 =?utf-8?B?ZWpqTXQvNEdJVWYxR1I3cUwwdUViUkhaNEZPWFBWYnluVHFuUU9aV1pJRVJ2?=
 =?utf-8?B?YXFadG5PSXNyNElzdGtrcm42cmxCNEFGTXV0VlE1SzRRQUlWMHZwL0pHcFo2?=
 =?utf-8?B?VlpXRENzMUVSbElSRkF3YXJsaTMzQWZ5aE94NHhqSi9tb2NuOHF0ZWlwcmMy?=
 =?utf-8?B?MTU1cVVBSjI1TmVPTXA1R2o0cG1kdzdxc3NEQjdMdGRWRjUvTzBKUmk1NkJM?=
 =?utf-8?B?cE45bXRWUmQwRlVYUHlZeEcrbWwzK0ZFYWQ5Mk1WbTd1OEdHZ2pIaW1tdnVL?=
 =?utf-8?B?UWVuWW0zd1RvTWN0WVcxK2tmNjB6Z1dyVDM1a25ZeFBrQWFPK3ltK3R4V3Jv?=
 =?utf-8?B?ekQ0RWdYSmFpcHJDZEp1RzZlMGdsazBsQTBOZExkTzVoOGNBbmxGNWRZMDk1?=
 =?utf-8?B?TWNHQ0pDQzdQNGhYRnh6ejNhek1TMHYwbEhRaHR6WG4wTnFwYmY2TVFaKzFq?=
 =?utf-8?Q?Uc3tICX+q65XvEH4zPr5LwAvC?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5C29EFF2916A31448B8791C69EDC2B3A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fc8bc80-0bf5-4fe1-faf9-08de0d3bd86f
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2025 05:13:01.8312
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xv+HK/XDnNt3jOVC75AtAWwE/8zP2LDO6XOauyVNA60vPrvpa/z9WlvK0BXbsQHkGAQ1zfzyzlndNbQl3IAO7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7046
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTEwLTEzIGF0IDA2OjI1ICswMDAwLCBOaWt1bmogQSBEYWRoYW5pYSB3cm90
ZToNCj4gQEAgLTExNjIsNiArMTE2NCwxNiBAQCBzdGF0aWMgdm9pZCBpbml0X3ZtY2Ioc3RydWN0
IGt2bV92Y3B1ICp2Y3B1LCBib29sIGluaXRfZXZlbnQpDQo+IMKgCWlmICh2Y3B1LT5rdm0tPmFy
Y2guYnVzX2xvY2tfZGV0ZWN0aW9uX2VuYWJsZWQpDQo+IMKgCQlzdm1fc2V0X2ludGVyY2VwdChz
dm0sIElOVEVSQ0VQVF9CVVNMT0NLKTsNCj4gwqANCj4gKwlpZiAoZW5hYmxlX3BtbCkgew0KPiAr
CQkvKg0KPiArCQkgKiBQb3B1bGF0ZSB0aGUgcGFnZSBhZGRyZXNzIGFuZCBpbmRleCBoZXJlLCBQ
TUwgaXMgZW5hYmxlZA0KPiArCQkgKiB3aGVuIGRpcnR5IGxvZ2dpbmcgaXMgZW5hYmxlZCBvbiB0
aGUgbWVtc2xvdCB0aHJvdWdoDQo+ICsJCSAqIHN2bV91cGRhdGVfY3B1X2RpcnR5X2xvZ2dpbmco
KQ0KPiArCQkgKi8NCj4gKwkJY29udHJvbC0+cG1sX2FkZHIgPSAodTY0KV9fc21lX3NldChwYWdl
X3RvX3BoeXModmNwdS0+YXJjaC5wbWxfcGFnZSkpOw0KPiArCQljb250cm9sLT5wbWxfaW5kZXgg
PSBQTUxfSEVBRF9JTkRFWDsNCj4gKwl9DQo+ICsNCj4gwqAJaWYgKHNldl9ndWVzdCh2Y3B1LT5r
dm0pKQ0KPiDCoAkJc2V2X2luaXRfdm1jYihzdm0sIGluaXRfZXZlbnQpOw0KDQpIaSBOaWt1bmos
DQoNCkFzIGFza2VkIGluIGFub3RoZXIgcmVwbHksIGRvZXMgUE1MIHdvcmsgd2l0aCBTRVYqIGd1
ZXN0cz8NCg0KSW4gd2hhdGV2ZXIgY2FzZSwgaXQgd291bGQgYmUgaGVscGZ1bCB0byBkZXNjcmli
ZSB0aGlzIGluIHRoZSBjaGFuZ2Vsb2cuDQo=

