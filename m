Return-Path: <kvm+bounces-38180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D928A36436
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 18:16:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 32F2416BF06
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 17:16:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6E942686A3;
	Fri, 14 Feb 2025 17:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lwv8CKo/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4286D13C9C4;
	Fri, 14 Feb 2025 17:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739553362; cv=fail; b=Ponv8dngCGrQ0KZmzLABJyk+mmJloIeWMAF+vPXhG2jz8vMldrj8MfoVfP1Wl8oB4870CPRy5M1rVNwZPzaQkJArHcjiqLmkL3Nc2YTePJ3N8ufFt4MVXR7t3J1wkNszYc8T0gGFlcqUpIMabASDUw5wRFgK90ZXosLWHyrps+o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739553362; c=relaxed/simple;
	bh=g/LDZ6PMyHtUf8nfS2gLxiekiPTVCV1imHrEzi8a+ko=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=I2Bgm/sJecpDQX8t7E3WnwsNVcD9JCzoAEcbJ5/deODRRt3CZQwj7hC+Zp7gc6pkq2Acr/vXdwTUSZHoMCWyyV57eCrLLyQ9rIQzr8e0+o+J+b0i2E4OvYlDhb4DoAKhTJtgHd9IeW8li4fKbGYnjpIncoRtTsu7dV+nY6AsSrI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lwv8CKo/; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739553361; x=1771089361;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=g/LDZ6PMyHtUf8nfS2gLxiekiPTVCV1imHrEzi8a+ko=;
  b=lwv8CKo/qHkC7/uv+Q2dOqZqoOMVP88e7nC+oenoDjd+MPvdHjrY6cRB
   +plh9o1dUEPDABq9+SQSxbuJ6tvPVbrypMlJc3rhKI17nqJay/IT9sLKD
   N9llgTed5EI6yiaZIxbxt10Bu0wpZKDjIZ34EOLYIesVp7zgEzujwzpLa
   Xtv6vxkfEvO5TFdjUMVdVusmkUomnUElDiJne+KNE6dS2jHdFB0ToJbZY
   lGHUJc50unSAwtFC7BRTymeRMnVe1RF/rK0YScStnAjqcT6OGgplHecYM
   re610UkB+ukU4ORI+u6OplHD93dx1qS/bVMikg4ZK4s+b985SL3dHWTlo
   g==;
X-CSE-ConnectionGUID: aLZYXLU1RCKwa34QxSgjuA==
X-CSE-MsgGUID: FZb6i/muRn63zjhazcPHCQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11345"; a="51284940"
X-IronPort-AV: E=Sophos;i="6.13,286,1732608000"; 
   d="scan'208";a="51284940"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2025 09:16:01 -0800
X-CSE-ConnectionGUID: XjZz23rpRMuS8PR/y7+rSw==
X-CSE-MsgGUID: csF3d3G7RSW3ecYk7HhxGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="144439639"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Feb 2025 09:16:00 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Fri, 14 Feb 2025 09:15:59 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Fri, 14 Feb 2025 09:15:59 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.48) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 14 Feb 2025 09:15:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hj0Lcyn0K/ea8W6Pvh4E6MejoXY3Ufoq73yAsWtET3SbeX804ORQjWT40JTA+hn04SpGF6XyGF73+uuF2vm5q0sZPmmdfr1WlGoiiNdJAFNOePhqjTBjk2CmYu/kx7M/APT9LyJycDooGUsmpEhZPISyOwPRk/kbz4n+VOmbtxw9CAeZTalIbZKiMcVKrczi+x4p4PlGRHDW+3XLs5YPNg6TrFQApp4o/hlaxdlOyG3srl+OKCZ0LQKcOljgpKxFXHMUNhgijMqd8LTZk1Twux2leIpJCkIyEjOU6x6rOJn96zLpQPwabKuDCPcpGm69V/LtKj3l28T9xhxBqZbLXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g/LDZ6PMyHtUf8nfS2gLxiekiPTVCV1imHrEzi8a+ko=;
 b=Tj2FPH1J0D0dhrroLqBXDPUqvRjspdCBDZ0+fAhMxW97G7UPU1pQp1FUX6gGNm3MXillSE4Jc2Krz2bYKoKHtjNVmUbvHHR/DiEFXc1hrqIqmklekFxeMnLkjkLDjqbn8hjTminp9l7hVfYFUfqaJac351U7xx3yt1W/Pjlizmj9zKJ/NuYFEuFhOA0PY8p40JoWSa9PZQtOTWKyz2dAyVBYtLGHzy2psvAouuPxHB2dtRmy2yFQK245pFE3PKGe70pMsP20hiY9lPuq4uibqqvjazvnhL2TrQ5bV25fXgDphXRiwH8gx+fVXClWBY21bXRAAc27aBP2hdo0VEMpkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY5PR11MB6438.namprd11.prod.outlook.com (2603:10b6:930:35::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.14; Fri, 14 Feb
 2025 17:15:57 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8445.013; Fri, 14 Feb 2025
 17:15:57 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Huang, Kai" <kai.huang@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Lindgren, Tony" <tony.lindgren@intel.com>,
	"Hunter, Adrian" <adrian.hunter@intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 09/17] KVM: TDX: Handle SMI request as !CONFIG_KVM_SMM
Thread-Topic: [PATCH v2 09/17] KVM: TDX: Handle SMI request as !CONFIG_KVM_SMM
Thread-Index: AQHbfDCwm44BSDL0QU+LEd8n1plraLNC5+IAgABEE4CAA+PhAA==
Date: Fri, 14 Feb 2025 17:15:57 +0000
Message-ID: <90e3514a1fb4b6f656de98513e0b5c3ba0e7abbe.camel@intel.com>
References: <20250211025828.3072076-1-binbin.wu@linux.intel.com>
	 <20250211025828.3072076-10-binbin.wu@linux.intel.com>
	 <Z6v9yjWLNTU6X90d@google.com>
	 <518a71a9-011f-456c-bc99-639a5d69c144@linux.intel.com>
In-Reply-To: <518a71a9-011f-456c-bc99-639a5d69c144@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY5PR11MB6438:EE_
x-ms-office365-filtering-correlation-id: 88adb39e-46f0-47ac-9f15-08dd4d1b3f31
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MDkwMDRtMHMzemxRVVhud3RWajZ5Rk5uRkwrNnVRS3VERGxwdkRtQ2VJSGZ5?=
 =?utf-8?B?NWNsS1U5TmpuQUpReTZ6YUJWa3pYT09lVGQ4TjVCRXlaSTFxdVc5SzUwVlFi?=
 =?utf-8?B?MmFETUZsNUFFK3NxYWxFRGJCSzVMOUFnQU5WSFZyYXVoN0ZMUlBObDE0N3hQ?=
 =?utf-8?B?R1lBNWM4Q0REMkdtY3U2OU03YkxiVll0WGp3U2JtTmFDK3Q1SzhrZDB4dk91?=
 =?utf-8?B?azA5MkxNN1A3ZjQ3SUJCZXZQOVBiUEFnRjFXVWxORlJJQitDNjhWSVpWT2lW?=
 =?utf-8?B?ZUNhaFpHVHZpOUhkUGprOXlpNUdXUUhwczNpWnNpcWRIbHd3S1grbTBBNVdv?=
 =?utf-8?B?OFN3T3BpeitpOVhwRGJBT2loNlBBMEpZbzdtb29CUEVTV2NQVWJSMTNMZE15?=
 =?utf-8?B?MnBqeVhZakVrNVdVVGE3bkw0U3lWai9uWklIOUFVRVpXZzNxNnlkVHBJRFJW?=
 =?utf-8?B?MG1wYWZ0UWF3OHRMUjZOMEFWNVRCU3hZc24xcGFOeHdJNktJRGMwaEw5UGkz?=
 =?utf-8?B?dDhnbitBVEkrTy9EcmNJY1pIb0lNVjIrdm1yQngxekpPUDJTWlZLY2tGT212?=
 =?utf-8?B?MTU5YUxhOTNtNFFvczM0ZWNySzJ3VHRjUkNyWVdpa3hRWk8xTk1zYzVEdnJq?=
 =?utf-8?B?ZXNROWJkWGM5aWV0Mi9aUWluNVAyTHhoeDlHelU0YTVDc2paUU1abHFHRlBi?=
 =?utf-8?B?Tm1PQ01sdjdLMk5CNmQxdWhtRy9MaEdNMjdaVGFISGpLaXh0NWpVOStiZnRY?=
 =?utf-8?B?Y2RFTWEvSTQyUUdsem4wWXNkUHVnczh3LzNFRUFJSG5TRVVndFh0TSt1WEE4?=
 =?utf-8?B?emFUcWdqZG5Dd2pqRzROTUROaDFaSlFvNGFvbHFNNUFvVkNjSVp1eXdDT2F0?=
 =?utf-8?B?QVlKQmo0Tm9QWklUMkhSYVZhM0Z1bmZRODBpTi9ETEgzNXdZNXh1MkFqU2NH?=
 =?utf-8?B?dXdaa2l4dFZqNzdwMVZJanZzeDhHU2YwUDNCVXZKbVBxOGNvSEQxU3hpRDhZ?=
 =?utf-8?B?UDh4ZU9tMkJENW1lSmVwZmxrb1A3VHRONVRBTWkzam81aHdJL3RXbEdvQmFX?=
 =?utf-8?B?S3I3Q1lLWnI5UStQL3IwQkNPcEVlQktvRUhOYmtpSDZMaWUzOWhxY0FjUE54?=
 =?utf-8?B?c3ZReVovWkhWYzliblViUm9Yc3o1U0RESDBsNkxaWEF4Q1pwNmVzTjc0RlN4?=
 =?utf-8?B?K2tFNi92ek5KMTRXcTZ5ZFlQMGNrZ2JZZ05Ja2dmWjBDTUIwK3J6Qyt1Rk9X?=
 =?utf-8?B?SVJmK0FnV0RPU1Jwcm42dVZDaFlOa0Z2TXE4Z0NwRjhSSVh2QlBJRURSV1cr?=
 =?utf-8?B?dkg2Y1JHY0poVzZsVjI2VzZkNmNqd0FIWmd3dWlsYU44OXBkaTZqSmxHM3Yw?=
 =?utf-8?B?MSszRWRlQS9ma1pRZEFZcm1abWxac0VmNDcwTk5xOEVJcDBsWUlhc2t5WkFj?=
 =?utf-8?B?aVJ0YjcrZXk3by9BMnJ1UHJiYnA0c2VWQXhVTGtpQmtZZml3eE45UHcxTTUw?=
 =?utf-8?B?dlZaRGZQVVRwRGEvbzIzQnBadFZ3ZEJ4ODhUUzMxZ0FQZXVxaGZzUDJJQXor?=
 =?utf-8?B?aXllVHhFLzBKdUxpSE1iZjdKNnVyWU9pSE9CR1ZZUm9GS2JHNVhmSG5Sa3p4?=
 =?utf-8?B?VURCTElYa0QrTkhkNUhTaVlGcm9hMGVjL0xYbUp1blUvZVdHZjlWUWk2Y0lG?=
 =?utf-8?B?SFZtSEtKSFFCUFNOVnNINGFLSHFmNVp6Nmp6UG1JM20vOC9xczZORVJKQndO?=
 =?utf-8?B?TEVaUmgvNk9nWHFzbDVmaTVjMUJvL0k3MENVa3YrcjJLcEh1VEtVWHdlUW9M?=
 =?utf-8?B?ZUw2alhqK25tT2lreEJIcGsxa2h4YVNoZnZmUUdzYk5VQ2JLSzQ4TDIxMjVQ?=
 =?utf-8?B?Wkk4VFRPcGY1VGZvTytUTGppUm9mcnloYnowYW4wSUlvY1E4dm1SelhldS9z?=
 =?utf-8?Q?+vpi5JcYh5ked3rsNv2S1mRLEWHNhbTG?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QWlPU0pGeGhYWWs0dUNIb2dsQ21nemwybGJqZW45Qi9iWHJOQkxXd0MwbU9W?=
 =?utf-8?B?OG5uYXIxa2FnazNpY1JYSk1ZeTBFTEU0ZTV5bzA5Sk8wVEdQUXlLYTNOL01T?=
 =?utf-8?B?ZFNwb0M2aFdVaWRGUWZFWEVoQWZvQ0JUSmFscDZUV29yZ2pNaUhncGwwRDVh?=
 =?utf-8?B?UVpiQlFQKzZqbVQ3elhHOEZnSnJ4OWRVQTM0YkxVREtLMUx0cGFTYlpORGwy?=
 =?utf-8?B?VHFVVUgvMjZJd3hLdzhZZkpCRkgyeG1EQWNFRk5IS0xIMG5nZ3pJVXhIWXN3?=
 =?utf-8?B?bkFSNXMrR3dYTHArVmFvb3pHdzhIa0xWYTZaYzk2b2R3ZU5HQzFMTGRMY3FL?=
 =?utf-8?B?WU1CRDVtc3R4d2pXTmxoR2w0T1VrdGJNTUdVazRsSWlmbFA5WjhHclJrMHVh?=
 =?utf-8?B?NFg4TnRaZWJ3RUU1UXZVbWcrMDNSTEJtbUxJWE1LcXN1NEFIQkUzdzZyRnU5?=
 =?utf-8?B?N2pOQWkyZHFUOFcvVVhXek0xTGc4V1l5dC9iM3lCajdmelRuVmZrdG9LdG5w?=
 =?utf-8?B?T3I4aU1CTUw3QzRGaDNLWHNLNWlRdytiOUk3U1Yva01qc1djcXE2eVJ6dko3?=
 =?utf-8?B?ZTdPcEFXRldSM1JxTFFEY2xxRDZEYnJNZ0M5TlBRRjgwV1p2eW9CTkhGcURG?=
 =?utf-8?B?UEtKSXhUQ0RDRDJIRE1sME1vZm9HelZhdHFPSXI4bmM0dTVDVEZkbEdtdXB1?=
 =?utf-8?B?b2FNWFRsYnR4bGZCbGlyUUNIbW9yKzcwaTU2VDhTVCtQUkxvajFWL201WUxD?=
 =?utf-8?B?dEpaT0VUQmVpckMzL1d1cUd4aFA4enlDSFRJcEJiN0xiRmgwU2lNRk15bGRx?=
 =?utf-8?B?eTNCYWVNS3ZrK043SGRsRGxvc1ZsZk1lYnNwMHdSN0ZObWRiRElJcTMwc0lY?=
 =?utf-8?B?Y0FCVFozM3oxSEdPMDgrYzAzWTZZeThHcGY4VldIck1kRGhLNXpwVmZTcjRK?=
 =?utf-8?B?a1JPMUxGdHVwTGdLdG00M2YwaXJvZGMzemNMN3l6VDJLTjAxa2diSS9wcVc0?=
 =?utf-8?B?UFpYYUtvZmNDbnl2SnZBYnM4RUsvRnFXNmVEb2djdENES3BsdHRHTDF3SE9w?=
 =?utf-8?B?TThnaUpZWDZSdGh4cElLSm01NndaR09pU3VjT0ZkYUQvdEQreHFvMzNaS3Zq?=
 =?utf-8?B?Y0hZa0JtSXdIRU9GYkpKcVBSMEp0T3ZJSzFNRk01UW44T2I3K0tyOFhQNUMv?=
 =?utf-8?B?cm04cnY3aSt6cUpHSDJYU2pzRS80QlhyaTdxN2ZMTVlXaVNxWndBYUZ0ZTVo?=
 =?utf-8?B?TllJTUI0ZURIVUJJR0pVTWVTdTQ1aS9HTnphQmJSN2c1Q2w2eWxSejBUOXBF?=
 =?utf-8?B?ZjRrMTZhUDhYUTV3eHZ0bkJSZ1g4N1Iyc1I0L0ZqWWVZSlNRRVQxWGtNZGQ5?=
 =?utf-8?B?N3YvcFZGNi9CZkdMb2ZHN0VsV095Y0tudVFBbUVSMnlrNUR3eEUwc1JkOTRZ?=
 =?utf-8?B?bnIzR25KV2ZOQmt1dTZ1aXFYT3NPR0dqbjNtWi84bnAxYjM3Q01JVlY5dVlF?=
 =?utf-8?B?dmZDRHJxeWxPaTlZZFFxUjEzMlF5RXhvTjMyMmR1WlJaQXh1L2tIdmJyT3du?=
 =?utf-8?B?OFpEZWlQck5sVm9GSTcyTnl0R3d4S2JsV2doMzU2WWRyNmtGSFRxNlRreE9r?=
 =?utf-8?B?d1BVK2xvcmpTanRwTEFzK0lNTjRrVFprWDgyUzlnZ3dqZFBORWhZSFJtWXd1?=
 =?utf-8?B?NEU1dkJjRkVjaXBWa05tODUrMVhDb2ZJTUR3ZUt0YStUbHZDeStzRmZMYXBj?=
 =?utf-8?B?TENwNlp6NW9aUWdTaTZ4K0I4RkNWL0FCRmlLTWxFckVyRE9tcHRlcUJsaUVN?=
 =?utf-8?B?N1h4K2g1MGhsbjcyWTJLa2pWa0ptRUN4dTlLRkRudjYxVEw0dVgrSno5ejVX?=
 =?utf-8?B?WTloL1R6WGxQcFhmaHdKei81UW1FZmlhZU1neDl2VUU4ckNqS3dkb0R5a3dB?=
 =?utf-8?B?V3NUSHI2dVVnQjhMUFcxT3U5aUNwWHFDd0tJS0YraXRjWXNwa2Y4cjZLbkNr?=
 =?utf-8?B?d1FseUJJdlNCK0grVWp5QU5CeC9pbmNJVFNvVmxyWGlxZk9CWTUxSzRVNWNL?=
 =?utf-8?B?VjViN1pmejRDZDFEUHZXbXJ3YkR4aEtpYjJxSkNsMmxETTN3NnVSMWJGeFdu?=
 =?utf-8?B?c3MzdkgyeU02Z3g1UDY4QlU3ZUJSdGo4Zi9OY3FQWW9qbVBnR1BHUnBjWk1O?=
 =?utf-8?B?OUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <242CAEF9FDA82F4CA86C9503E004AEC8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88adb39e-46f0-47ac-9f15-08dd4d1b3f31
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2025 17:15:57.6040
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 157+FUeqpKzRdYJ6dbDw5RnvRjnGaPIdPWGkfF6JZHJAc8TBBvmPHBfWCZHR1XP1rA9ZDKi9Ovpt9cxwvDabnsNzgnJzsfJnxTOh70sKVdg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6438
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTAyLTEyIGF0IDEzOjUxICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+ID4g
UmF0aGVyIHRoYW4gaGF2ZSBhIG1ldHJpYyB0b24gb2Ygc3R1YnMgZm9yIGFsbCBvZiB0aGUgVERY
IHZhcmlhbnRzLCBzaW1wbHkNCj4gPiBvbWl0DQo+ID4gdGhlIHdyYXBwZXJzIHdoZW4gQ09ORklH
X0tWTV9JTlRFTF9URFg9bi7CoCBRdWl0ZSBuZWFybHkgYWxsIG9mIHZteC9tYWluLmMNCj4gPiBj
YW4gZ28NCj4gPiB1bmRlciBhIHNpbmdsZSAjaWZkZWYuwqAgVGhhdCBlbGltaW5hdGVzIGFsbCB0
aGUgc2lsbHkgdHJhbXBvbGluZXMgaW4gdGhlDQo+ID4gZ2VuZXJhdGVkDQo+ID4gY29kZSwgYW5k
IGFsbW9zdCBhbGwgb2YgdGhlIHN0dWJzLg0KPiBUaGFua3MgZm9yIHRoZSBzdWdnZXN0aW9uIQ0K
PiANCj4gU2luY2UgdGhlIGNoYW5nZXMgd2lsbCBiZSBhY3Jvc3MgbXVsdGlwbGUgc2VjdGlvbnMg
b2YgVERYIEtWTSBzdXBwb3J0LA0KPiBpbnN0ZWFkIG9mIG1vZGlmeWluZyB0aGVtIGluZGl2aWR1
YWxseSwgYXJlIHlvdSBPSyBpZiB3ZSBkbyBpdCBpbiBhIHNlcGFyYXRlDQo+IGNsZWFudXAgcGF0
Y2g/DQoNClBhb2xvLCBzaW5jZSB0aGlzIHdvdWxkIGhhdmUgc21hbGwgY2hhbmdlcyBhY3Jvc3Mg
dGhlIHdob2xlIHNlcmllcywgd2Ugd291bGQNCmhhdmUgdG8gZmlndXJlIG91dCBob3cgZ2V0IGl0
IGludG8gdGhlICJxdWV1ZWQiIGt2bS1jb2NvLXF1ZXVlIHBhdGNoZXMuIEkgdGhpbmsNCnRoZSB0
d28gcmVhc29uYWJsZSBvcHRpb25zIHdvdWxkIGJlIHRvIGp1c3QgaGF2ZSB5b3UgZG8gdGhlIGNo
YW5nZSBpbiBrdm0tY29jby0NCnF1ZXVlLCBhbmQgd2Ugd291bGQgbWVyZ2Ugb3VyIGxhdGVyIG90
aGVyIGNoYW5nZXMgYmFjayBpbnRvIHRoZSByZXN1bHRpbmcNCmJyYW5jaC4gT3Igd2UgY291bGQg
anVzdCBkbyB0aGUgbWFjcm8gYXMgYSBjbGVhbnVwIHBhdGNoIGFmdGVyIHRoZSBiYXNlIHNlcmll
cy4NCg0KV2UnbGwgZ28gd2l0aCB0aGUgc2Vjb25kIG9wdGlvbiB1bmxlc3Mgd2UgaGVhciBvdGhl
cndpc2UuDQoNCg==

