Return-Path: <kvm+bounces-44935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 87518AA5053
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 17:33:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 57E669E40B3
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 15:33:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83EE625E811;
	Wed, 30 Apr 2025 15:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R9v4KL29"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744871C84A5;
	Wed, 30 Apr 2025 15:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746027214; cv=fail; b=MSyp4vX/pIoVYRRrb0b70MIDvd9nB/Fo5Ydjtqif/IF1S3Za09hkBScv7yS6+p6Lrz5T00asJRXMidgihTL3C4JlpxIwXSgftmC9GGDNYnsJpziCc1oehDemkqm36nILc40vKPD9nzx/2c5XDMGhR6dZZwZaLXOMo3EcHvxg1/Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746027214; c=relaxed/simple;
	bh=GNqwHnA59XxnCXvXgBUwFgZpnVtdMbomFwkS6Sq5uNs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TE6VO75+N/JsKbDbjvHkARyua9fvRbCW3uwhAk//cUmYExW66QZ6qiUiD9aGnuYkPfICbc62r6rHF+Zc+/NknemyxQreoeXt4wWLu25DlUnWny+YkGirNKGd6UcbKnQ9cw44Q7aXsY6tPXBKAXJlftY1IT9Bg+PqC59CO6B13/g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R9v4KL29; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746027212; x=1777563212;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=GNqwHnA59XxnCXvXgBUwFgZpnVtdMbomFwkS6Sq5uNs=;
  b=R9v4KL29tYQ2JJeXht/NIFv8ScbarLBA5eFZ1dVPvDj1sRE+nPpfK9hp
   yFHIpNp2ga5RhUmuLhpf1r/LaklxoviP7y9d2PTFmS0WgIOVlo/2ygGSP
   CRwDU1eDlXnVtwJP1ZW4jWloW/5/gT5O9m1KMVqANWgtNDr7U1TyUnvT6
   84Q9fjnqmnRtsyb97MrzRqwTuffcs9kTC0t/5H/mhY4Gxi+MJ0C03EWTk
   ZVyr8C3opGcENZi1/sEIApz9tOTbXweAe9JSm6lV29RIjAov/vq17z+7l
   P7tJQ4DC7wPEbakZEWlI/KymA3lHCwQNdOHijvmXV+bLRh6CF9WPntGbU
   g==;
X-CSE-ConnectionGUID: Sp3riuh1TUqcelmJC2+wVQ==
X-CSE-MsgGUID: F9K5Ibk8TqWc5bP+8pmxjg==
X-IronPort-AV: E=McAfee;i="6700,10204,11419"; a="47831193"
X-IronPort-AV: E=Sophos;i="6.15,251,1739865600"; 
   d="scan'208";a="47831193"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 08:33:31 -0700
X-CSE-ConnectionGUID: FtTO/IfpS4q4Axxhbc0q+w==
X-CSE-MsgGUID: MMV0h34GQOemFOZKlraxUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,251,1739865600"; 
   d="scan'208";a="139127003"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 08:33:31 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 30 Apr 2025 08:33:30 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 30 Apr 2025 08:33:30 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 30 Apr 2025 08:33:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l4LV16yHkYUfV0Im6PUdsc9yZ6AiZ7toAMbB3j1x24bH2yoNnosIV4rJLCFXGdGNDKn/GspIRdOxnoJPNFKh8qW0T1hyk9oTZDGrXYIllC1wjJeaPTg2vZWH31vuk63kZQzmbd5Y9a94sSrErGJnwvXqHquUAYLPLpFHt5QR2JvAkXmZ/o5KjtwXimsDPGLUE+nLX+Ba21Vg+3ZnPtiPiJ8JdAp7QdC7RWXAvYbtnHzSYd0TEUXk3O7kUhwVfuM1E4rfg8iV56N/nf/6fH/tljDBgUWxhpADQD93TmbYzxEJtKM/wPLsIDOMkagehrTBNTQEB/LsJmjrx3T9+69Lag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GNqwHnA59XxnCXvXgBUwFgZpnVtdMbomFwkS6Sq5uNs=;
 b=S6nHJwOhAPddPji7LCkLfVmKuWlF/UAUs7wWI+W7pb3wHF1xfgZCuxqZ1H+/ZcoPO5dONenqEsDQYZmIzJJr1g8EtgkC5td+Oevb1Ysr21RFAEbcj6zBptjKeJNfEGQmKkHbYXdGNgbXM1t4sOjr1UfSKU9n2Wtnprc1psHY3OeFoTRrzZb41piHcs/FaqZoKZMxOzqRwEEwsaWUffIpW3H7dxCtramSgI7AzsYcNzz7vLsgu4T5LFXeoRY4XK8Vkb9TiWOuFr+yte/nhMzqb6HdSoRXFBNL6YbtuRpB9Ifh/l25HhZF/3u4S8sktE3DpIqX6AjyAxgasELghQIfCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB7472.namprd11.prod.outlook.com (2603:10b6:510:28c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.31; Wed, 30 Apr
 2025 15:33:24 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.8699.019; Wed, 30 Apr 2025
 15:33:24 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Bae, Chang Seok" <chang.seok.bae@intel.com>
CC: "ebiggers@google.com" <ebiggers@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Hansen, Dave" <dave.hansen@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Spassov,
 Stanislav" <stanspas@amazon.de>, "levymitchell0@gmail.com"
	<levymitchell0@gmail.com>, "samuel.holland@sifive.com"
	<samuel.holland@sifive.com>, "Li, Xin3" <xin3.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "vigbalas@amd.com" <vigbalas@amd.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "john.allen@amd.com" <john.allen@amd.com>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "Yang, Weijiang"
	<weijiang.yang@intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "aruna.ramakrishna@oracle.com"
	<aruna.ramakrishna@oracle.com>, "Gao, Chao" <chao.gao@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "seanjc@google.com" <seanjc@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v5 3/7] x86/fpu/xstate: Differentiate default features for
 host and guest FPUs
Thread-Topic: [PATCH v5 3/7] x86/fpu/xstate: Differentiate default features
 for host and guest FPUs
Thread-Index: AQHbqelZqhZU+Oq6j0yiouUZFd9/N7Ozg2wAgACfzYCAAIHMgIAAgC8AgAQvOgCAAJ7/AIAAG5MAgAAJFwCAAAPrgIACUb4AgAAI14A=
Date: Wed, 30 Apr 2025 15:33:23 +0000
Message-ID: <b1f5bcc441b74bef6efe91da1055a3a4efe13613.camel@intel.com>
References: <20250410072605.2358393-1-chao.gao@intel.com>
	 <20250410072605.2358393-4-chao.gao@intel.com>
	 <f53bea9b13bd8351dc9bba5e443d5e4f4934555d.camel@intel.com>
	 <aAtG13wd35yMNahd@intel.com>
	 <4a4b1f18d585c7799e5262453e4cfa2cf47c3175.camel@intel.com>
	 <aAwdQ759Y6V7SGhv@google.com>
	 <6ca20733644279373227f1f9633527c4a96e30ef.camel@intel.com>
	 <9925d172-94e1-4e7a-947e-46261ac83864@intel.com>
	 <bf9c19457081735f3b9be023fc41152d0be69b27.camel@intel.com>
	 <fbaf2f8e-f907-4b92-83b9-192f20e6ba9c@intel.com>
	 <f57c6387bf56cba692005d7274d141e1919d22c0.camel@intel.com>
	 <281354d3-1f04-483d-a6d0-baf6fdcec376@intel.com>
In-Reply-To: <281354d3-1f04-483d-a6d0-baf6fdcec376@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB7472:EE_
x-ms-office365-filtering-correlation-id: d3fc1eaf-a49b-471d-3e99-08dd87fc5858
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?b0ZDWTJWcEJlTUFLdFRhVlE5TzhNYUZCOGx4YTN3ZCtzRVVwTDU2RGloenY0?=
 =?utf-8?B?TUl3akkvc3B4ZGI4WE5MeDB5UXAvcmM3L2IyQ2Z2ZTVSdnNnQUV6WmljNTNy?=
 =?utf-8?B?anIyL2w0SkE1S1cwWnQwZWVDYldJay9qSDFmRzNsVi9FS0MwbHNuVzFaR1pV?=
 =?utf-8?B?NEVVK0k1RkhGQ3NlUUVZWGExc0xkN3diM3JVWUJlMWdhZ3FEck0wUGNLcU0y?=
 =?utf-8?B?SWlxbmF1RHZPUWgyejdidUlodXZmaWFoNFJGaVJwWUV1aW1MaTZucndxZEVL?=
 =?utf-8?B?SFFZb3JxT0ZtK3hoYi9DUzNnT0lvaHF5aktlSXlkUmhMakVKWVQxYnZaY2lU?=
 =?utf-8?B?L0pUSlZiK0lBaWxvS2FxQ3U3Z0ZpOFl1NFNSWXVuY0VGRVR2d2ltN2srK2p2?=
 =?utf-8?B?TWdKSTZZU08wWDJjV2t4dmU0T0c2QjlPREZHOGR2RE5PYUplaWlnRkdFWXdW?=
 =?utf-8?B?L0tjeEVtU3JLYVIzTEY2SGQ2REVnYWFqTlFZb21jc1BzRFdDd1pDM2o3MXlY?=
 =?utf-8?B?Ykl6bFE1NVlsWHJxbU1MNTh4elNhY3FyR0x5Y2ltekFqU1NvcEdkc2phVVlC?=
 =?utf-8?B?U2tCYy9Xa1lyRXU5RmpORDJBdDVZQ1drbkZLaWxjMUtKanE5OVVBWkZDNlB4?=
 =?utf-8?B?M3VucHI0UkNpckJjV1J0dWRYcFd5R1VWN2R6Wm9Fc3F0SExGY0tBQVplZTlz?=
 =?utf-8?B?bDlnRERKTytaNmd3aXBPcHlsSjdYbnE3enN3RUxPYnEzcklTQmFadjJ4Z1ZG?=
 =?utf-8?B?SDRCOVhyOGZWa1gvUHkrRDJVajdzd1RZMWxSYldiaGFCVmRra090WnVGcDRz?=
 =?utf-8?B?K0NRYnJrcFhoMHhWeUtzbEVKNm00clZ5ZUdFRlNHYWxDZ2NFeDlFOGhDVjhM?=
 =?utf-8?B?NmxKM1o1UnZ6WnVoUm96VEVyWFVhcVY5cVdRcFRIeVZrS2Q4UlBBb3pqazJU?=
 =?utf-8?B?eGJScEIrT3RockVTYUxZK1RJbFNVTmZ6MFV4Y2Y3K3FocHVUSGo5UFdadlFU?=
 =?utf-8?B?aDZwejJOMmJ6d211MkF4Sm1xUER0WWJWMnNSaExxYnhNSzM2R2RXVWhYSjZj?=
 =?utf-8?B?L2pYQkRpaXVOL0ZTV1NBb3Y0Z2cxS1Bva0V3blcweDJmdGJsbjR2czhRcDIw?=
 =?utf-8?B?ZlFPd21sRmxnWnZ1NFd1UlVMNW5aRmVqSVlNeDU4VHZpQVYxNVQ4elA0Vjl2?=
 =?utf-8?B?dDFMUFFXbnk0NDdzNG4wRFFFS2NFTUdPYlBmSTJMSlp5VGF1UjJVdE1TaVlV?=
 =?utf-8?B?Nk4yYXpuajhTV29MVGFjb1kvamxSekxmT0xVZGpVb0RJRjlpWVZWeWkxMjZR?=
 =?utf-8?B?THpRVjJpMmhPdjRYTm13dHFhU0kwOUQwOFRyRWVFUXNyUElOY0FQWnJoQlNr?=
 =?utf-8?B?OGhxbkFJZ3pJdlRSajIrNWlWVjdocm10TGlHdWdWUTBTRkQ4Y3RwdDlLWGc4?=
 =?utf-8?B?NTV3ckJ3VEl3c01FOVlRdGxqOGdsNnlmcUQrUjYwWkdrVkpLZkt3TXAybGFr?=
 =?utf-8?B?cGdpaDRiQ09MVEpWQS9iN3BUeWlHdVVhSWplVDMyU0Z6Z3M2N2tNNDAySFFB?=
 =?utf-8?B?ZVdOY3BDRmFNaERteExsaHp4RDRoemhxNUxuNC9mcmJMYlE2d3Y2ZjFaMVpT?=
 =?utf-8?B?a29Xa09HNGxobzJsU1hRVzhvd0ZlSjVsUDkwanN0WnoxcHZrZldsajIwWlNs?=
 =?utf-8?B?cEdMZlRaa3gxVHdDa1owN2Y5dlFKdk5XdTVKR3o1Z0dtZmM2Q0FnM1FNMnFH?=
 =?utf-8?B?R01XRlp4THJwaDd2Y1AyRW0xNldybzR4cG1oM1BmT1NyMVpTNVZpQUlUQWZa?=
 =?utf-8?B?SkZHWHZoUUV3TjZ0Nnh4bnJRTGdhWHUraE1IY21yQURMSzBsYVVDZVVUOXA0?=
 =?utf-8?B?VEVwZUpQeUdMaGMyM2JmV3VrT01vT05zWEdWVjJ3ZGV3Y0p3NFFENkxhdU9u?=
 =?utf-8?B?U3cyQ3lQWlhVYjE2VUZmbFh2eVZvVklSbWdLNmRWUDVHcnA4N3JGNDFGRVZz?=
 =?utf-8?B?VkFlUGJKNTNRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YjlOdnIwMUl6NzFEQXkvTGJybjhoN3V2MjlIQ0VRK1NvZzQ5cldTTWlBR3gz?=
 =?utf-8?B?MmZzanEwY3pjM0w0WDZieUFydk5TMHlwV3JEWG1STzBWQjNjY0RtaWV2ZUFR?=
 =?utf-8?B?OW1mTmg3M3FmaEJmbHJhblpsTFdlUm1lTnhZQkZ1MmFzTTM1UFF1WUZlR1RU?=
 =?utf-8?B?YVJDWVlNcm05OW5Eb1h3UWRleEorSGhucWdNNW91YVpxM1VVcTdTL0liZloy?=
 =?utf-8?B?TTRkL21EVTBVeGlDWFN6TUJlaGxKZmN3a3M2YkxGMjFKbW5GRkllT3MvSFYw?=
 =?utf-8?B?bVlId2tmNFVpUUxJdEdQMnFtYU90QjRGdWNxNktWTDd2UnF1ZWVnVjNIN3RN?=
 =?utf-8?B?L2ZaclJua0RYUktjT01yN2NoQmlWbXJTYzlDZENKa0FRUXRsR0hFVEZ1VmNK?=
 =?utf-8?B?bGsrOFFka25zMTBYVTVVN0lXeTZ3TUsvNlJTdGY5NGRMTUtFU3VPT09hLzNZ?=
 =?utf-8?B?WEZlWnlBbWpjVnhvN0tWekthcUVTNWlZdHFTaFZLWmVkcHRzSUxtZGp5d21Q?=
 =?utf-8?B?QmM1eGhzVmRUQ1duL2ZVUGRsVDlTbWlOanVjRmFETjR1a0hZNGt4bGY3RzRP?=
 =?utf-8?B?d2laK0xlVzNLSEpjVVFqb1J5dVBMclhBSHhSSVhjanljYkt6RVhNaFZyQ05Y?=
 =?utf-8?B?cnFCYlV1ZFp3VDJQamFyZk1kUHYrVldVZkpMVU5YWkVzckxoQ3pIOWFuV0Nm?=
 =?utf-8?B?ZVg5SWU3VjZpR1J4dUUvVjhaLzc5UFlNaDlYMEJkMEpEaUFBWkcyejByZDRl?=
 =?utf-8?B?cEdoS1lhd3pwa3Y0Y01LRU9VRnpwR3NSeWV1TmJzeUFwUmhLZHZ3dUVBMDR3?=
 =?utf-8?B?RWJnQTdVd1RpT2VEQUlQa1RiRE54Qlc4NkJ2bGRvd2xYczlsVWxrYURweExX?=
 =?utf-8?B?b2pmekViUk96cCt1S3NxUFduNTdxWjkxVzlGY2RIdWtOTzc4RFR6R2thTVBR?=
 =?utf-8?B?bFdhQnlhOE9Gai9VMCt6K1p3bnl0d2dyOTZhZXJrSFp1VEZrMVlHVEJtUGFj?=
 =?utf-8?B?ZTF4cFdaclU0V1ltZ3h0K0s0NzNFRndkWVBFRFJCYXZoYXVyODEyU2ZUN0J6?=
 =?utf-8?B?UmUwbVRrSVk0UWJaZG9JMjZYc2NLU1BPZit6SXRobWlEWURneUNsUWJhSzhQ?=
 =?utf-8?B?NkV0QW1EditQc1JhWCtEb0p2Y2VlWWw3WVNxQ3VqbVl2aW9pNzhZT1JjaFBt?=
 =?utf-8?B?ejJIaWw5SU5qYXg1OVVhQzdTdjZ2U0xLand5RDhpbGdxY2ZGRGNqY3NvbU5l?=
 =?utf-8?B?T0xPbTY5b3lWdUVQb3IrNi9HMXU4TzFSRzF6cFFjZ0g2TngveXJPaE51S0NB?=
 =?utf-8?B?UlFJQWNrTGpKbDU4N0xTK3BybHM5c2ZFc0c1TVpmWVhRMnJ2U2l2UkhzRkxF?=
 =?utf-8?B?dTVxRGdjQVNNZmtnVWVXR2tUZXAxQmxaU3E5TDAzblhoektkN09yQ0tEb2Fv?=
 =?utf-8?B?ZnVYcldvVC9teDF6NnIwdSs2LytzL3VFQWZ3RDgzRGVYbk9pOWFMSzlWeW9Z?=
 =?utf-8?B?dTg1WEJycGhhNFJydEVVcWhCMHpwQyt6bE1HMGF0dGtqM2g0V2JQd05jM2Ew?=
 =?utf-8?B?ZWxhYjdXSzJiek9TWXFOcGlncGl2eEt6K05MS2w4SkFQS3lzekFYK2c4cWVD?=
 =?utf-8?B?YTZmbTkwR0t2TEFPejAzcVpwb0ZWVGEwZklacHFuU0I2ZXIwR3QwMWYyMDR4?=
 =?utf-8?B?Mi9nQWdTdk9DK3FhVVpQV1c0S0Fxdk1mZ0NwN2ZYQWYzSnJjbWEwd0NrTXVT?=
 =?utf-8?B?U3daeTUxVnBUQlZtZVJKU1lMRkh2YWN6L2ZXWUFaTURLRzJ2Nk5mTkI4Tmsr?=
 =?utf-8?B?T3lwVUN2bDBna3FtOUhWbDFybzVBT3BiNVh0VDRIbFpYYlY0ZEJEaDhTZ1dY?=
 =?utf-8?B?bDgzYTdlUzJ3anluRy9aU2YwTFJHNDhPRXhqOWwwcDNIVmhlMkc4VkhVSWxu?=
 =?utf-8?B?V2d2YW1GN0JIcWtzdHpmTmtGL1VhZXdYUG9OMm82Mk1ibzZwSzFndllvT1VI?=
 =?utf-8?B?OWNpTnhXWkEzQW15TlZ6Q09XNkZVTG9uczFNRGVUengvV1E4NlFEK3Ryb3JH?=
 =?utf-8?B?bzFsUWFpVTFqYTZpcUtLYlpvVlZVTnk1dkRwWTYrVDJabzdCVXVPTmVqSStS?=
 =?utf-8?B?SmQrVjBLcmhaNlBDMlF0MW5EOWFnUHdzM2ZNTmhuZkgrUURYaHhGTFYvcWZj?=
 =?utf-8?B?NlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5E2F733DE5F42E4386CF22344C4EEA63@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3fc1eaf-a49b-471d-3e99-08dd87fc5858
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2025 15:33:23.9684
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 97rWfJusqSX/FbFp2VILbA3ZVkFuh7tACC7qygLttvryRTwXOw+v0QLDLazgYxXXoiTuZknJc8r9Chn73M62bkGE5hPb+bcAO6fmewmovT4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7472
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA0LTMwIGF0IDA4OjAxIC0wNzAwLCBDaGFuZyBTLiBCYWUgd3JvdGU6DQo+
IE9uIDQvMjgvMjAyNSA4OjM2IFBNLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90ZToNCj4gPiANCj4g
PiBLVk1fR0VUX1hTQVZFIGlzIHBhcnQgb2YgS1ZNJ3MgQVBJLiBJdCB1c2VzIGZpZWxkcyBjb25m
aWd1cmVkIGluIHN0cnVjdA0KPiA+IGZwdV9ndWVzdC4gSWYgZnB1X3VzZXJfY2ZnLmRlZmF1bHRf
ZmVhdHVyZXMgY2hhbmdlcyB2YWx1ZSAoaW4gdGhlIGN1cnJlbnQgY29kZSkNCj4gPiBpdCB3b3Vs
ZCBjaGFuZ2UgS1ZNJ3MgdUFCSS4gDQo+IA0KPiBOb3QgcXVpdGUuIFRoZSBBQkkgcmVmbGVjdHMg
dGhlIFhTQVZFIGZvcm1hdCBkaXJlY3RseS4gVGhlIFhTQVZFIGhlYWRlciANCj4gaW5kaWNhdGVz
IHdoaWNoIGZlYXR1cmUgc3RhdGVzIGFyZSBwcmVzZW50LCBzbyB3aGlsZSB0aGUgX2NvbnRlbnRz
XyBvZiANCj4gdGhlIGJ1ZmZlciBtYXkgdmFyeSBkZXBlbmRpbmcgb24gdGhlIGZlYXR1cmUgc2V0
LCB0aGUgX2Zvcm1hdF8gaXRzZWxmIA0KPiByZW1haW5zIHVuY2hhbmdlZC4gVGhhdCBkb2Vzbid0
IGNvbnN0aXR1dGUgYSB1QUJJIGNoYW5nZS4NCg0KSGVoLCBvayBzdXJlLg0KDQo+IA0KPiA+IEl0
IHNob3VsZCBiZSBzaW1wbGUuIFR3byBuZXcgY29uZmlndXJhdGlvbiBmaWVsZHMgYXJlIGFkZGVk
IGluIHRoaXMgcGF0Y2ggdGhhdA0KPiA+IG1hdGNoIHRoZSBleGlzdGluZyBjb25jZXB0IGFuZCB2
YWx1ZXMgb2YgZXhpc3RpbmcgY29uZmlndXJhdGlvbnMgZmllbGRzLiBQZXINCj4gPiBTZWFuLCB0
aGVyZSBhcmUgbm8gcGxhbnMgdG8gaGF2ZSB0aGVtIGRpdmVyZ2UuIFNvIHdoeSBhZGQgdGhlbS4g
DQo+IA0KPiBJJ20gZmluZSB3aXRoIGRyb3BwaW5nIHRoZW0gLS0gYXMgbG9uZyBhcyB0aGUgcmVz
dWx0aW5nIGNvZGUgcmVtYWlucyANCj4gY2xlYXIgYW5kIGF2b2lkcyB1bm5lY2Vzc2FyeSBjb21w
bGV4aXR5IGFyb3VuZCBWQ1BVIGFsbG9jYXRpb24uDQo+IA0KPiBIZXJlIGFyZSBzb21lIG9mIHRo
ZSBjb25zaWRlcmF0aW9ucyB0aGF0IGxlZCBtZSB0byBzdWdnZXN0IHRoZW0gaW4gdGhlIA0KPiBm
aXJzdCBwbGFjZToNCj4gDQo+ICAgKiBUaGUgZ3Vlc3Qtb25seSBmZWF0dXJlIG1vZGVsIHNob3Vs
ZCBiZSBlc3RhYmxpc2hlZCBpbiBhIGNsZWFuIGFuZA0KPiAgICAgc3RydWN0dXJlZCB3YXkuDQo+
ICAgKiBUaGUgaW5pdGlhbGl6YXRpb24gbG9naWMgc2hvdWxkIHN0YXkgZXhwbGljaXQgLS0gZXNw
ZWNpYWxseSB0byBtYWtlDQo+ICAgICBpdCBjbGVhciB3aGF0IGNvbnN0aXR1dGVzIGd1ZXN0IGZl
YXR1cmVzLCBldmVuIHdoZW4gdGhleSBtYXRjaCBob3N0DQo+ICAgICBmZWF0dXJlcy4gVGhhdCBu
YXR1cmFsbHkgbGVkIHRvIGludHJvZHVjaW5nIGEgZGVkaWNhdGVkIGRhdGENCj4gICAgIHN0cnVj
dHVyZS4NCj4gICAqIFNpbmNlIHRoZSBWQ1BVIEZQVSBjb250YWluZXIgaW5jbHVkZXMgc3RydWN0
IGZwc3RhdGUsIGl0IGZlbHQNCj4gICAgIGFwcHJvcHJpYXRlIHRvIG1pcnJvciByZWxldmFudCBm
aWVsZHMgd2hlcmUgdXNlZnVsLg0KPiAgICogSW5jbHVkaW5nIHVzZXJfc2l6ZSBhbmQgdXNlcl94
ZmVhdHVyZXMgbWFkZSB0aGUgVkNQVSBhbGxvY2F0aW9uIGxvZ2ljDQo+ICAgICBtb3JlIHN0cmFp
Z2h0Zm9yd2FyZCBhbmQgc2VsZi1jb250YWluZWQuDQo+IA0KPiBBbmQgdG8gY2xhcmlmeSAtLSB0
aGlzIGFkZGl0aW9uIGRvZXNu4oCZdCBuZWNlc3NhcmlseSBpbXBseSBkaXZlcmdlbmNlIA0KPiBm
cm9tIGZwdV9ndWVzdF9jZmcuIEl0cyB1c2FnZSBpcyBsb2NhbCB0byBzZXR0aW5nIHVwIHRoZSBn
dWVzdCBmcHN0YXRlLCANCj4gYW5kIG5vdGhpbmcgbW9yZS4NCg0KSSdkIGxpa2UgdG8gY2xvc2Ug
dGhpcyBvdXQuIEkgc2VlIHRoZXJlIHRoZXJlIGlzIGN1cnJlbnRseSBvbmUgY29uY2VwdCBvZiB1
c2VyDQpmZWF0dXJlcyBhbmQgc2l6ZSwgYW5kIHBlciBTZWFuLCBLVk0gaW50ZW5kcyB0byBzdGF5
IGNvbnNpc3RlbnQgd2l0aCB0aGUgcmVzdCBvZg0KdGhlIGtlcm5lbCAtIGxlYXZpbmcgaXQgYXQg
b25lIGNvbmNlcHQuIFRoaXMgd2FzIG5ldyBpbmZvIHNpbmNlIHlvdSBzdWdnZXN0ZWQNCnRoZSBm
aWVsZHMuIFNvIHdoeSBkb24ndCB5b3UgcHJvcG9zZSBhIHJlc29sdXRpb24gaGVyZSBhbmQgd2Un
bGwganVzdCBnbyB3aXRoDQppdC4NCg==

