Return-Path: <kvm+bounces-55119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6473B2DACA
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 13:22:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7A9457B8AE8
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 11:20:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A7DC2E3702;
	Wed, 20 Aug 2025 11:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="afjsV9O9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8BB2E041D;
	Wed, 20 Aug 2025 11:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755688938; cv=fail; b=FUPJvqemLzNsjvi+IeumdAi9DTymbz3Lj661LFL1hYPRQctbtqqof+bvGR2gNnF5uP67EMuRcOUjJ6PynUjNre6bEm+kAOy3cyHAtJ80g9sEyes85qhPCJW0HrhESG320K790zIEVHI9Ysy1FOFA7ZrtwLxHAK441/Gq4BuMqQM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755688938; c=relaxed/simple;
	bh=IGS1/b+TgiiRf78yTYjz9k45hbFWYWzKo8jJDEQyWlU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=o9FkgRkb1v6dFR8fhQl6a8eB7XK8UVfeIrjzQy6jeQTHUBrt7DfUCFonFRyojZ5iYTgLmNDHw4CNL5S1YStG8UDkUku1/sa9woXJCD5ffTbtpX3CBojAgMVe4OOrgdFLhGuBXEAl3Pi/Y/Edla61UEARSwt4AdnRbFO/yIkTnv8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=afjsV9O9; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755688937; x=1787224937;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=IGS1/b+TgiiRf78yTYjz9k45hbFWYWzKo8jJDEQyWlU=;
  b=afjsV9O9ljLQS2MK8EmvJIhqzZfQkGHx+XKjWwhGfNJ75VCZfw3z3/SN
   q6KCL2pZ74fHZtC4YCEbSerp5VEUlPfHufPG40DyZlxwBgqc53V267QmN
   c/x800/2nAFPleM94uY22kvXjrXI0iw+vQlV++VPUarh3y0uQiKmuDOO6
   XbdXhrZlYEQC0httKu397QKspiY3RCUM2kFJ3EbZ3JTlVdb+4+BqTd3nR
   7tYdB9yqQAqRrXFAyaof4rXyFn23aw6wVsI+aDhP647cqXVbHV/409UID
   e1jhFoGnTV5bF9lkPvFFuzw5hd8nJ1d9GeJB/sdaEdl7L36OVHJMke/cL
   w==;
X-CSE-ConnectionGUID: oeqRA3aHR7yFn5PymOklzw==
X-CSE-MsgGUID: WqDk7vqFS22dOS/h9QUAeQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="61589301"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="61589301"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2025 04:22:16 -0700
X-CSE-ConnectionGUID: G6rfDTM8QWmKaGyK6QCMRg==
X-CSE-MsgGUID: 7xM+NkfTRSSv12O/C95PAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="168014158"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2025 04:22:16 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 20 Aug 2025 04:22:15 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 20 Aug 2025 04:22:15 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.64)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 20 Aug 2025 04:22:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xv/Fvsz5srBHHxuCAxrATky1Z2jALKUbTRuHwa/94zcN1CnQhFxYCmSsZmP1wuCqRF83hHXqVQlw0czL3FwMxqDfYX+wuKIp252I+3SOwccDvfoSS931haPc6SzFhT60hqt1F0Z5pER8Aexx7hTl7HMOnx7nO3cO+3lSMAW5VUSyyz+PITWtvQg38G7Y6YCbZBhkoJDotn+1qINgZcH0PmnL+U34/atoYZTEH36nrsSSCSbnlggZ0FqXuSdzrWMo8rAbK1rIj6/KimJn6BFdLHGEgWTsF+PzsMN04cu0nSoK+pee2+P9r3s8iZ2/6yVZazU4geB3ohk3XeZU3aG1Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IGS1/b+TgiiRf78yTYjz9k45hbFWYWzKo8jJDEQyWlU=;
 b=MaQ/l33s3OPnKMiFx0qgHTnjf3ZDpjNzkAkdhyyDhKzfMPdWj32oHluuvsCl9qFlFg8WPIYlV0S7mhTBcmwsSZqs55tq3FC1Zur6o8MxAhWiwxDeGMFey3d6LWfnAmhnlpaDPHjnDaLxxI63RJdhgsf/Aoyl3xxf3WuNxXx8JdMzspx72ewzBm5Pa5f/6QdDfmcE20/rWWcHE9h/ftqN5lKuMDTxHB6p8Y2gK+VVuWJzlIxottPrXuXztKINjCtaBY6NcBz4w0H0gFZzDCTrAdirWM/1mIHPI5cLiI9VAiGJbFU0eKK5VcHslPCgbT2+pKTKpGeIE1s6BethZIzWuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CO1PR11MB4947.namprd11.prod.outlook.com (2603:10b6:303:99::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Wed, 20 Aug
 2025 11:22:12 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.9052.013; Wed, 20 Aug 2025
 11:22:12 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "ashish.kalra@amd.com"
	<ashish.kalra@amd.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kas@kernel.org"
	<kas@kernel.org>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "sagis@google.com" <sagis@google.com>, "Chen, Farrah"
	<farrah.chen@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Gao, Chao" <chao.gao@intel.com>, "Williams, Dan
 J" <dan.j.williams@intel.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v6 7/7] KVM: TDX: Explicitly do WBINVD when no more TDX
 SEAMCALLs
Thread-Topic: [PATCH v6 7/7] KVM: TDX: Explicitly do WBINVD when no more TDX
 SEAMCALLs
Thread-Index: AQHcDKj0KRQjWZhTjEidjLxSJo7SHrRiLIQAgAAdHQCAACfSgIAASCAAgAAR1ICAAAqVgIAG+YkAgAC+koCAAMiWAIAAGUsA
Date: Wed, 20 Aug 2025 11:22:12 +0000
Message-ID: <c736d2040f5452585e670819621d3bae5417fff4.camel@intel.com>
References: <cover.1755126788.git.kai.huang@intel.com>
	 <d8993692714829a2b1671412cdd684781c43d54a.1755126788.git.kai.huang@intel.com>
	 <aJ3qhtzwHIRPrLK7@google.com>
	 <ebd8132d5c0d4b1994802028a2bef01bd45e62a2.camel@intel.com>
	 <aJ4kWcuyNIpCnaXE@google.com>
	 <d2e33db367b503dde2f342de3cedb3b8fa29cc42.camel@intel.com>
	 <aJ5vz33PCCqtScJa@google.com>
	 <f5101cfa773a5dd89dd40ff9023024f4782b8123.camel@intel.com>
	 <acbcfc16-6ccc-4aa8-8975-b33caf36b65f@redhat.com>
	 <a418f9758b5817c70f7345c59111b9e78c0deede.camel@intel.com>
	 <78253405-bff8-476c-a505-3737a499151b@redhat.com>
In-Reply-To: <78253405-bff8-476c-a505-3737a499151b@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CO1PR11MB4947:EE_
x-ms-office365-filtering-correlation-id: 0cd76b5a-b264-4862-0c84-08dddfdbcf25
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MUQvc2JKalV0M3Fjbmw0ZWl5Vk9XTWRaRlhWRVZEbmJIWWx0SkNtUDB0c2F5?=
 =?utf-8?B?ditjVlN6SmN3dDVWbzlSTHh1Zm5ydThxS05YRzFmdUlaL0drWlgyYi9HMS9O?=
 =?utf-8?B?ZTVYN2VmU3RFWi9TZytiRERwUWZVS1d6eVQzbzlrMkxGV3kwcHNWdGNuNWdm?=
 =?utf-8?B?TC9Id3drSkFLeWRXNWxyOVh3dGhwZW9RbW9JbTB3ZWpKVyt6Q2I4d2tuYXlK?=
 =?utf-8?B?ZXFzTk1MRDF6NU5UUTBoaXZSQXBoQTlxTjhHcFp5djhsMTFhWjgrcndudWIz?=
 =?utf-8?B?Q05qR2pkMDI3WnM5RGRtQlhmcHdtK2JWR2pvSUlIdzdDQmMwWkh4NDdsS0RO?=
 =?utf-8?B?REQ0a25TclMwSmJiZkNHZ1JBMmxDcksxU0RidTJZL2JEMFdCZHdodVYxR1Ro?=
 =?utf-8?B?WFFUSUhoNDhxUkxReUNlby9GK2JpbGM5UDJaeDVUalM1Z2c0UFFLMXNDdFcz?=
 =?utf-8?B?SVB0MG9FTmdKQmpsT3BDeTJPZVRHQWw2L0ZrbXZEbmpkNzRNZjQxTnpPYmhy?=
 =?utf-8?B?eVBFMWR3b1FCbWhkMjZwUG9aM0tiZDBaRkNuTVFqdFRCMzVvWVkvbFJlZjBP?=
 =?utf-8?B?SHRYTFJmUlZseWwwU01rVXJmRndqNnBTclZxbnBoMFZWZFBqUDBOOUQ3Rnhn?=
 =?utf-8?B?UGsvaDBVNkxEMDc4TXRzQ3BFSFp0ODltYkR2RzFqSVVWeWVqcU4zMXA0S3ox?=
 =?utf-8?B?dldUMkFYRmt2N2V1OUdudmlDWmdERDljY290bGkzK0ZMMG44RVNKSGQ2d3Ax?=
 =?utf-8?B?Q01JRlRSb0t6MUtRVkRGaVI0RlpmNTh4c2ZVRVladWxvanVyM2JOWG5mTnJU?=
 =?utf-8?B?VHdjYytKS2tUMXRFRjNETVVpNTdUMlhvc0E4NjlULzZUQU9BVUZaVUxqQldK?=
 =?utf-8?B?MUVLL1Q3ZE9vOW5PYkQzR0lkWWtZZmova2dxMTFMeTNTa1FZSnk2TXpGVU8x?=
 =?utf-8?B?SHJjRW42Y09RUUhTb1NidjQxSHltK3c5bCtGMmlNU3FFN2ZBNnhncnhvbHRo?=
 =?utf-8?B?TFR1VFd3ZzU5Vm5TL0sxZjlFQ1Nsc0wySTU3ckhiNk5icGhHUTU1ZEFrNkt0?=
 =?utf-8?B?dVV2OXc0NWozcnUrbDBoWXFZOWlwYU9hSFpYa0hqTWNqTEhPT2ZWcUhYb2pQ?=
 =?utf-8?B?ckc5Nm1ldVI1YlFlTEhFcnpXYlpHQWNqNnAzV2Fvbms3bkl6aHFtVXBLa1NH?=
 =?utf-8?B?NUVVSitPMFEva2x2eWJxR2dQbTRjZ1pGT3IwL1hDRUlZVUJRK2tPQTdoc1Vo?=
 =?utf-8?B?K2xRSUo2SXNnUUFha25CQzZYbXVMTEsrdGt5a0hPdUVuK2MwY1BBWlcyVHUz?=
 =?utf-8?B?dTF5NjQ0K05GTlhnQkx4VEtXTWxKQ0oyMnBFcWJRMUsyc2ZWWS9XVEhaVXRj?=
 =?utf-8?B?clVycmQzWlY1SEgrQlFVQnorOXZ6YzZoVnFpMVNEZ2x3bGUwTU80bnFwN054?=
 =?utf-8?B?RFAvd1Y3UktvL1hsOWpzYVgrenN2S3ArbE1KUk1uV0FYUjlQNWcxSVJLZzZD?=
 =?utf-8?B?cktjcHo3eDdJSUhVU2pFdUxiWUtUQ0J1T05WYXNjL3h6WUd1eWFPOStFeU1h?=
 =?utf-8?B?cmZYUmlMUVcwMHRrMldobWl4NndsZDIyazREeFRKVGVoQ01nSkZUYldGTklo?=
 =?utf-8?B?L2N6OUNvdGVYTUg2aG4yYTNINXRxbVB3bHpITXlVU3VEd0dXK2dHdzR2cHpK?=
 =?utf-8?B?cFR2TC96VFhKemdEdEhqSW5BQ2xHZlJ2QTNxWUdLMDd6UlR2dnhmQmMvOVdY?=
 =?utf-8?B?ZTR5SlJpc0IxYkg5SzhjREhvYWZNTDc2bVZpYUdmRGY1S3JNbXM5L0FZalFt?=
 =?utf-8?B?amVxSEdFalpBNHNzem93eUhLMWc5V0htWlFRemcxK3JYdCtGWUVXSlJ0MnBK?=
 =?utf-8?B?d1Y4MDVMbmxpSjBOMndxdENVeGNldGZDS3VXaXErTEU2UDUxVFh6UFVQSm1B?=
 =?utf-8?B?RUJqQUJQM0ovRVFIZkk0YkI5b1dhSHVWT1JhSHkyaTR6bWdpd2dIUXpCSEMz?=
 =?utf-8?B?b0JGTXVkUUd3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SWVSRlpHVktsVGR4RlJpemhVbnJHWWhaV1ZPTTg5VXNlb1A0RXFvMlNTdDJB?=
 =?utf-8?B?U04rTjRobm5jRUorWWdqUC9VVitFUFVtSHQ0ZWJSSW1TZGV6OXdoQzJYNEdG?=
 =?utf-8?B?NW9lMGlNV1Npa3I5Y0NrYlBmaW9Rc05WZVdqNGxvLzlJeFcrdkUzN0thOElw?=
 =?utf-8?B?RE1CNDJnZDZmaEcwK1RlRU5aN0ZSb1JERk5BaHdoQUh5QmZUOHRWYU1PWmg5?=
 =?utf-8?B?NjBZc3BnM2pMbjJjekFORG9yNXBVNTcreFNmWVVFNWhLenFXTmllQ0ZCZm9a?=
 =?utf-8?B?Rng5dGhNSUpZZEV1c2l2c3RNamgzY0JxNmx5NWpwK1RkSzRJZVJ5RVVGYkhL?=
 =?utf-8?B?dVZ2K1U2T1BvUnJQNXhNM2hvUG1EZENtUG1oOVQ2Q1JEaUttWGpmWUl3TlVJ?=
 =?utf-8?B?ci9KendpeWllais5Z01mcGtNS2dEOTg4UlhpeVBobUJaRmxVZmVGYUJjWFhH?=
 =?utf-8?B?bmNNVS8wZFFiMlZ0OWhxdGRwQmFyRTN1cEJtQlo4ZW9ubUg3S05xeEdPZGcx?=
 =?utf-8?B?Q2wvMUFRNHo3RHRiSzRVQmErNXpNR1p3b2g2TElKUUhtQVdWUEg5QmlVUEZ2?=
 =?utf-8?B?T2R3TVhkbHdqS2t3VlhsTkdVQTB4dVFzb2Fhd1NyWHQ0d0d0SlBQS2JZbklY?=
 =?utf-8?B?M2NZdU9OalFabFlxejRLYlBIT25XMzhBVG1VUTJORmxUZjFDNnUvY2Y4cFF1?=
 =?utf-8?B?ZngvbTIxU3dnQ3c2dTcxbmdnVlVhSmw4cFpkQmtrRG5MVldZNU04eUh5WGEy?=
 =?utf-8?B?SzdRWjdsRUU3RmZKZkpwbkJBTXM2c3dmbFA3K2s0OU5MaTlxdjlTR0kwSU13?=
 =?utf-8?B?RlQ3VGpTZUR3Q1FkbjcwRGtGYitNSjNBVVNyMi9qSG41SHVlbGxzY1FQTGw3?=
 =?utf-8?B?dUt5amlubXUvT3cxaWpvbzZxbU1wWkwvdE9Qa0l6L1lURGRybzVYUllVREZE?=
 =?utf-8?B?dUVtcko0czFqTk1KME5ZczNnaGVONlJnZitENjU2Qnowd252YjVpUlRJM1FB?=
 =?utf-8?B?N1hZczJHNXlOaWZ4NHdId0h5czBrME11a3pJQU5KTmxuazkybE1vY3BGbkVx?=
 =?utf-8?B?UEQweXlFMWhqT1JQU1pCakV1N3dzM0ZIaUQ0YnJZMGN5ZU1jdno0Y1RTYkpW?=
 =?utf-8?B?TWxtSUg2ZjlRWHhzTmF0YjlscnRpUmR3cWpITnlpdno0ZkkzalBWWWc4b2Rr?=
 =?utf-8?B?TkFQR1owNnlwVHBzSmx0Rit6RTJVcVE5S2RidGpLNExoNkV5U3drT2tMV3ln?=
 =?utf-8?B?clJGWS9Wam03T3dmd1FiUTZZVnJMNTQrTTg1dEdrOTZVdk1PUTl4YlNyZG5D?=
 =?utf-8?B?RkZrQnVMaXdyN1lPSzVBdnR6KzQyUDJxTGJwRFFWeEJjOEtYUFNZMnExcVRq?=
 =?utf-8?B?YlJVOGtiNmtncFR2cXJTYVVWUzZPUEtDMHkycmJSYjF4ODlxeldmdlZDcVpT?=
 =?utf-8?B?TERJTU0vSjRQbzZvN1FpampKTEhvUUlVMHp0aDEzcStUSUMvZDFZTkxsR2dK?=
 =?utf-8?B?MjZheDFjMEp4N1hyQ3RDa0x5SExWS2VaTm9KV2dpbEZ4VEtrQTVXdVhIajNk?=
 =?utf-8?B?NXBoSjRmekRSUXZRUktLckZHTDMzdUExaDY0SWdpMElFZ2RJWHB5VVo2SnAv?=
 =?utf-8?B?ODduaVJJM2drRXRSOE9XclJCWlBzN2pzZjhZbTBNN21vWktObXZzVU9VV2wr?=
 =?utf-8?B?SENHblN6YXh1WmhUOW1NU0tRdXdiWVMwa2t1VjZqYnFUenVUNUl1cmMxcDBz?=
 =?utf-8?B?VCtlanIydjdzanN1d1hDUlBIdHN5cXhuMTgvWmhWeUQ3UHRFK0c0OWRPenhI?=
 =?utf-8?B?SXdzejZ3VzNObWkxd3pzV2cycnFvcmdTQmZDWG9FRWowRDhhcTIxRU1EMEZV?=
 =?utf-8?B?VkFNV25aREdMazVSYmQydFg1RnFPQ0tRU2I1aFlhZnZBVURjcTFXNTFRMWlH?=
 =?utf-8?B?NVpSN1hNbEdtSDdFN0o2UjN3T3ZSV2JNVStRdU9aVXUrRDlHcmVKR0M0eEZ2?=
 =?utf-8?B?UVEzRDlHQ0NvOURmR08xNW92WWp1aStlMVoyZUFuS1p0Y0JvZ3lvUnZKQmNW?=
 =?utf-8?B?VC9Jam90eVY2eUExRHoraHVNM0VoL3JPakNWamt2Yk96MnljcXdGejc2bjdi?=
 =?utf-8?Q?lpETLTs56EhoebDxczUnVzjFC?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2011C7712506034C961CABA1CF27E4F4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cd76b5a-b264-4862-0c84-08dddfdbcf25
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2025 11:22:12.2586
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dwFSwlvO6D9uAWV5NIeNUcbd+z2yJUUBZ8A78OSyAkmvXbaWS0lOchFJD8vNWtuhtjF1MKWn2TAWwA6sEOcQqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4947
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA4LTIwIGF0IDExOjUxICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBPbiA4LzE5LzI1IDIzOjUzLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+IE9uIFR1ZSwgMjAyNS0w
OC0xOSBhdCAxMjozMSArMDIwMCwgUGFvbG8gQm9uemluaSB3cm90ZToNCj4gPiA+IDIpIC4uLiBi
dXQgYW55d2F5LCBLVk0gaXMgdGhlIHdyb25nIHBsYWNlIHRvIGRvIHRoZSB0ZXN0LiAgSWYgYW55
dGhpbmcsDQo+ID4gPiBzaW5jZSB3ZSBuZWVkIGEgdjcgdG8gY2hhbmdlIHRoZSB1bm5lY2Vzc2Fy
eSBzdHViLCB5b3UgY291bGQgbW92ZSB0aGF0DQo+ID4gPiBzdHViIHVuZGVyICNpZm5kZWYgQ09O
RklHX0tFWEVDX0NPUkUgYW5kIHJlbmFtZSB0aGUgZnVuY3Rpb24gdG8NCj4gPiA+IHRkeF9jcHVf
Zmx1c2hfY2FjaGVfZm9yX2tleGVjKCkuDQo+ID4gDQo+ID4gQWdyZWVkIG9uIHJlbmFtaW5nIHRv
IHRkeF9jcHVfZmx1c2hfY2FjaGVfZm9yX2tleGVjKCkuDQo+ID4gDQo+ID4gQnV0IHdpdGggdGhl
ICJmb3Jfa2V4ZWMoKSIgcGFydCBpbiB0aGUgZnVuY3Rpb24gbmFtZSwgaXQgYWxyZWFkeSBpbXBs
aWVzDQo+ID4gaXQgaXMgcmVsYXRlZCB0byBrZXhlYywgYW5kIEkga2luZGEgdGhpbmsgdGhlcmUn
cyBubyBuZWVkIHRvIHRlc3QNCj4gPiBJU19FTkFCTEVEKENPTkZJR19LRVhFQ19DT1JFKSBhbnlt
b3JlLg0KPiA+IA0KPiA+IE9uZSBvZiB0aGUgbWFpbiBwdXJwb3NlIG9mIHRoaXMgc2VyaWVzIGlz
IHRvIHVuYmxvY2sgVERYX0hPU1QgYW5kIEtFWEVDIGluDQo+ID4gdGhlIEtjb25maWcsIHNpbmNl
IG90aGVyd2lzZSBJJ3ZlIGJlZW4gdG9sZCBkaXN0cm9zIHdpbGwgc2ltcGx5IGNob29zZSB0bw0K
PiA+IGRpc2FibGUgVERYX0hPU1QgaW4gdGhlIEtjb25maWcuICBTbyBpbiByZWFsaXR5LCBJIHN1
cHBvc2UgdGhleSB3aWxsIGJlIG9uDQo+ID4gdG9nZXRoZXIgcHJvYmFibHkgaW4gbGlrZSA5NSUg
Y2FzZXMsIGlmIG5vdCAxMDAlLg0KPiA+IA0KPiA+IElmIHdlIHdhbnQgdG8gdGVzdCBDT05GSUdf
S0VYRUNfQ09SRSBpbiB0ZHhfY3B1X2ZsdXNoX2NhY2hlX2Zvcl9rZXhlYygpLA0KPiA+IHRoZW4g
aXQgd291bGQgYmUgYSBsaXR0bGUgYml0IHdlaXJkIHRoYXQgd2h5IHdlIGRvbid0IHRlc3QgaXQg
aW4gb3RoZXINCj4gPiBwbGFjZXMsIGUuZy4sIHdoZW4gc2V0dGluZyB1cCB0aGUgYm9vbGVhbi4g
IFRlc3RpbmcgaXQgaW4gYWxsIHBsYWNlcyB3b3VsZA0KPiA+IG1ha2UgdGhlIGNvZGUgdW5uZWNl
c3NhcmlseSBsb25nIGFuZCBoYXJkZXIgdG8gcmVhZC4NCj4gDQo+IE5vIEkgZG9uJ3QgbWVhbiB0
ZXN0aW5nIGl0IHRoZXJlLCBidXQganVzdCBtYWtpbmcNCj4gdGR4X2NwdV9mbHVzaF9jYWNoZV9m
b3Jfa2V4ZWMoKSBhIHN0dWIgd2hlbiBDT05GSUdfS0VYRUNfQ09SRSBpcw0KPiB1bmRlZmluZWQ6
DQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vdGR4LmggYi9hcmNoL3g4
Ni9pbmNsdWRlL2FzbS90ZHguaA0KPiBpbmRleCBlOWEyMTM1ODJmMDMuLjkxMzE5OWIxOTU0YiAx
MDA2NDQNCj4gLS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20vdGR4LmgNCj4gKysrIGIvYXJjaC94
ODYvaW5jbHVkZS9hc20vdGR4LmgNCj4gQEAgLTIxNyw3ICsyMTcsNiBAQCB1NjQgdGRoX21lbV9w
YWdlX3JlbW92ZShzdHJ1Y3QgdGR4X3RkICp0ZCwgdTY0IGdwYSwgdTY0IGxldmVsLCB1NjQgKmV4
dF9lcnIxLCB1Ng0KPiAgIHU2NCB0ZGhfcGh5bWVtX2NhY2hlX3diKGJvb2wgcmVzdW1lKTsNCj4g
ICB1NjQgdGRoX3BoeW1lbV9wYWdlX3diaW52ZF90ZHIoc3RydWN0IHRkeF90ZCAqdGQpOw0KPiAg
IHU2NCB0ZGhfcGh5bWVtX3BhZ2Vfd2JpbnZkX2hraWQodTY0IGhraWQsIHN0cnVjdCBwYWdlICpw
YWdlKTsNCj4gLXZvaWQgdGR4X2NwdV9mbHVzaF9jYWNoZSh2b2lkKTsNCj4gICAjZWxzZQ0KPiAg
IHN0YXRpYyBpbmxpbmUgdm9pZCB0ZHhfaW5pdCh2b2lkKSB7IH0NCj4gICBzdGF0aWMgaW5saW5l
IGludCB0ZHhfY3B1X2VuYWJsZSh2b2lkKSB7IHJldHVybiAtRU5PREVWOyB9DQo+IEBAIC0yMjUs
OCArMjI0LDEzIEBAIHN0YXRpYyBpbmxpbmUgaW50IHRkeF9lbmFibGUodm9pZCkgIHsgcmV0dXJu
IC1FTk9ERVY7IH0NCj4gICBzdGF0aWMgaW5saW5lIHUzMiB0ZHhfZ2V0X25yX2d1ZXN0X2tleWlk
cyh2b2lkKSB7IHJldHVybiAwOyB9DQo+ICAgc3RhdGljIGlubGluZSBjb25zdCBjaGFyICp0ZHhf
ZHVtcF9tY2VfaW5mbyhzdHJ1Y3QgbWNlICptKSB7IHJldHVybiBOVUxMOyB9DQo+ICAgc3RhdGlj
IGlubGluZSBjb25zdCBzdHJ1Y3QgdGR4X3N5c19pbmZvICp0ZHhfZ2V0X3N5c2luZm8odm9pZCkg
eyByZXR1cm4gTlVMTDsgfQ0KPiAtc3RhdGljIGlubGluZSB2b2lkIHRkeF9jcHVfZmx1c2hfY2Fj
aGUodm9pZCkgeyB9DQo+ICAgI2VuZGlmCS8qIENPTkZJR19JTlRFTF9URFhfSE9TVCAqLw0KPiAg
IA0KPiArI2lmZGVmIENPTkZJR19LRVhFQ19DT1JFDQo+ICt2b2lkIHRkeF9jcHVfZmx1c2hfY2Fj
aGVfZm9yX2tleGVjKHZvaWQpOw0KPiArI2Vsc2UNCj4gK3N0YXRpYyBpbmxpbmUgdm9pZCB0ZHhf
Y3B1X2ZsdXNoX2NhY2hlX2Zvcl9rZXhlYyh2b2lkKSB7IH0NCj4gKyNlbmRpZg0KPiArDQoNCkkg
dGhpbmsgb25lIG1pbm9yIGlzc3VlIGhlcmUgaXMsIHdoZW4gQ09ORklHX0lOVEVMX1REWF9IT1NU
IGlzIG9mZiBidXQNCkNPTkZJR19LRVhFQ19DT1JFIGlzIG9uLCB0aGVyZSB3aWxsIGJlIG5vIGlt
cGxlbWVudGF0aW9uIG9mDQp0ZHhfY3B1X2ZsdXNoX2NhY2hlX2Zvcl9rZXhlYygpLiAgVGhpcyB3
b24ndCByZXN1bHQgaW4gYnVpbGQgZXJyb3IsDQp0aG91Z2gsIGJlY2F1c2Ugd2hlbiBURFhfSE9T
VCBpcyBvZmYsIEtWTV9JTlRFTF9URFggd2lsbCBiZSBvZmYgdG9vLCBpLmUuLA0KdGhlcmUgd29u
J3QgYmUgYW55IGNhbGxlciBvZiB0ZHhfY3B1X2ZsdXNoX2NhY2hlX2Zvcl9rZXhlYygpLg0KDQpC
dXQgdGhpcyBzdGlsbCBkb2Vzbid0IGxvb2sgbmljZT8NCg0KQnR3LCB0aGUgYWJvdmUgd2lsbCBw
cm92aWRlIHRoZSBzdHViIGZ1bmN0aW9uIHdoZW4gYm90aCBLRVhFQ19DT1JFIGFuZA0KVERYX0hP
U1QgaXMgb2ZmLCB3aGljaCBzZWVtcyB0byBiZSBhIHN0ZXAgYmFjayB0b28/DQoNCjotKQ0KDQpU
byBtZSwgaXQncyBtb3JlIHN0cmFpZ2h0Zm9yd2FyZCB0byBqdXN0IHJlbmFtZSBpdCB0bw0KdGR4
X2NwdV9mbHVzaF9jYWNoZV9mb3Jfa2V4ZWMoKSBhbmQgcmVtb3ZlIHRoZSBzdHViOg0KDQpkaWZm
IC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vdGR4LmggYi9hcmNoL3g4Ni9pbmNsdWRlL2Fz
bS90ZHguaA0KaW5kZXggZTlhMjEzNTgyZjAzLi41ZTM3YWUxYTQwZTggMTAwNjQ0DQotLS0gYS9h
cmNoL3g4Ni9pbmNsdWRlL2FzbS90ZHguaA0KKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vdGR4
LmgNCkBAIC0yMTcsNyArMjE3LDcgQEAgdTY0IHRkaF9tZW1fcGFnZV9yZW1vdmUoc3RydWN0IHRk
eF90ZCAqdGQsIHU2NCBncGEsDQp1NjQgbGV2ZWwsIHU2NCAqZXh0X2VycjEsIHU2DQogdTY0IHRk
aF9waHltZW1fY2FjaGVfd2IoYm9vbCByZXN1bWUpOw0KIHU2NCB0ZGhfcGh5bWVtX3BhZ2Vfd2Jp
bnZkX3RkcihzdHJ1Y3QgdGR4X3RkICp0ZCk7DQogdTY0IHRkaF9waHltZW1fcGFnZV93YmludmRf
aGtpZCh1NjQgaGtpZCwgc3RydWN0IHBhZ2UgKnBhZ2UpOw0KLXZvaWQgdGR4X2NwdV9mbHVzaF9j
YWNoZSh2b2lkKTsNCit2b2lkIHRkeF9jcHVfZmx1c2hfY2FjaGVfZm9yX2tleGVjKHZvaWQpOw0K
ICNlbHNlDQogc3RhdGljIGlubGluZSB2b2lkIHRkeF9pbml0KHZvaWQpIHsgfQ0KIHN0YXRpYyBp
bmxpbmUgaW50IHRkeF9jcHVfZW5hYmxlKHZvaWQpIHsgcmV0dXJuIC1FTk9ERVY7IH0NCkBAIC0y
MjUsNyArMjI1LDYgQEAgc3RhdGljIGlubGluZSBpbnQgdGR4X2VuYWJsZSh2b2lkKSAgeyByZXR1
cm4gLUVOT0RFVjsNCn0NCiBzdGF0aWMgaW5saW5lIHUzMiB0ZHhfZ2V0X25yX2d1ZXN0X2tleWlk
cyh2b2lkKSB7IHJldHVybiAwOyB9DQogc3RhdGljIGlubGluZSBjb25zdCBjaGFyICp0ZHhfZHVt
cF9tY2VfaW5mbyhzdHJ1Y3QgbWNlICptKSB7IHJldHVybiBOVUxMOw0KfQ0KIHN0YXRpYyBpbmxp
bmUgY29uc3Qgc3RydWN0IHRkeF9zeXNfaW5mbyAqdGR4X2dldF9zeXNpbmZvKHZvaWQpIHsgcmV0
dXJuDQpOVUxMOyB9DQotc3RhdGljIGlubGluZSB2b2lkIHRkeF9jcHVfZmx1c2hfY2FjaGUodm9p
ZCkgeyB9DQogI2VuZGlmIC8qIENPTkZJR19JTlRFTF9URFhfSE9TVCAqLw0KIA0KICNlbmRpZiAv
KiAhX19BU1NFTUJMRVJfXyAqLw0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92bXgvdGR4LmMg
Yi9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jDQppbmRleCAxYmM2ZjUyZTBjZDcuLjM4Mjc5MmUzMWYz
MiAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2t2bS92bXgvdGR4LmMNCisrKyBiL2FyY2gveDg2L2t2
bS92bXgvdGR4LmMNCkBAIC00NTMsNyArNDUzLDcgQEAgdm9pZCB0ZHhfZGlzYWJsZV92aXJ0dWFs
aXphdGlvbl9jcHUodm9pZCkNCiAgICAgICAgICogcmVtb3RlIENQVXMgdG8gc3RvcCB0aGVtLiAg
RG9pbmcgV0JJTlZEIGluIHN0b3BfdGhpc19jcHUoKQ0KICAgICAgICAgKiBjb3VsZCBwb3RlbnRp
YWxseSBpbmNyZWFzZSB0aGUgcG9zc2liaWxpdHkgb2YgdGhlICJyYWNlIi4NCiAgICAgICAgICov
DQotICAgICAgIHRkeF9jcHVfZmx1c2hfY2FjaGUoKTsNCisgICAgICAgdGR4X2NwdV9mbHVzaF9j
YWNoZV9mb3Jfa2V4ZWMoKTsNCiB9DQogDQogI2RlZmluZSBURFhfU0VBTUNBTExfUkVUUklFUyAx
MDAwMA0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYyBiL2FyY2gveDg2
L3ZpcnQvdm14L3RkeC90ZHguYw0KaW5kZXggYzI2ZTJlMDdmZjZiLi5jZDJhMzZkYmJmYzUgMTAw
NjQ0DQotLS0gYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMNCisrKyBiL2FyY2gveDg2L3Zp
cnQvdm14L3RkeC90ZHguYw0KQEAgLTE4NzEsNyArMTg3MSw3IEBAIHU2NCB0ZGhfcGh5bWVtX3Bh
Z2Vfd2JpbnZkX2hraWQodTY0IGhraWQsIHN0cnVjdA0KcGFnZSAqcGFnZSkNCiB9DQogRVhQT1JU
X1NZTUJPTF9HUEwodGRoX3BoeW1lbV9wYWdlX3diaW52ZF9oa2lkKTsNCiANCi12b2lkIHRkeF9j
cHVfZmx1c2hfY2FjaGUodm9pZCkNCit2b2lkIHRkeF9jcHVfZmx1c2hfY2FjaGVfZm9yX2tleGVj
KHZvaWQpDQogew0KICAgICAgICBsb2NrZGVwX2Fzc2VydF9wcmVlbXB0aW9uX2Rpc2FibGVkKCk7
DQogDQpAQCAtMTg4MSw0ICsxODgxLDQgQEAgdm9pZCB0ZHhfY3B1X2ZsdXNoX2NhY2hlKHZvaWQp
DQogICAgICAgIHdiaW52ZCgpOw0KICAgICAgICB0aGlzX2NwdV93cml0ZShjYWNoZV9zdGF0ZV9p
bmNvaGVyZW50LCBmYWxzZSk7DQogfQ0KLUVYUE9SVF9TWU1CT0xfR1BMKHRkeF9jcHVfZmx1c2hf
Y2FjaGUpOw0KK0VYUE9SVF9TWU1CT0xfR1BMKHRkeF9jcHVfZmx1c2hfY2FjaGVfZm9yX2tleGVj
KTsNCg0K

