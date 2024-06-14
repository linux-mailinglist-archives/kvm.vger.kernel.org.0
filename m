Return-Path: <kvm+bounces-19724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F73F9094B0
	for <lists+kvm@lfdr.de>; Sat, 15 Jun 2024 01:19:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DADFB1F213D8
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 23:18:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB61318FDC9;
	Fri, 14 Jun 2024 23:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KY0HR3aP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2847D1862AC;
	Fri, 14 Jun 2024 23:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718406702; cv=fail; b=pvkHv/OsbBwsLL1fn/lwQPhUlYBOz6AVjhDlbxGs2FEJj0w0HjikIIwo+w8hIjahQAU6+Fw1bgz8xcbXhUeMDHTxxor/Fpo9zKrZ4Xoa281iiiDzaCimSMGkvUenHiX5UhjMqI1/S3KOxQrObJg0nEo7eaVNpMru2uxQs6Sfpa8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718406702; c=relaxed/simple;
	bh=r4ISXemJJJgk3QIPTXCSApLAoa0MMU5cz5afSIvjMig=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=a7LR2Z8daIZmV5qeNpDQrnH1ZndTaLv4/qB8vaoyQKhquI13lmGw5J/5hFLXKTNyuhFxkTgqpkZOR2eUegvobk5RYONE1jPQwzt8WnTXKSgw/1z0MgLfqWr+XYXzpnQf5Zbl56Ix82eqhSPLrU4Emr4uVIjPiGM2+06JP6FBSJE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KY0HR3aP; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718406700; x=1749942700;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=r4ISXemJJJgk3QIPTXCSApLAoa0MMU5cz5afSIvjMig=;
  b=KY0HR3aPCZpzUVadQxULpfbB0aN0Xig+LzHGTcri+oT8YmcffR+hao7x
   dpJQxYaJJUJYzvDfdVEhbvITHF7IbDLxAJGtB3YUjuG/0j+lIpghUlxch
   NwwQ7ZnnkBpN1HBGsHZje3sfFvFcftHXC+S51FxaqLzsIQZHOcPplzNuh
   43jg28Y2HYBJJiH8xhR0zn1wgGk7kLZUon5sbAAdv1mfHs19KaiizftFQ
   c1ZEWibbd19kAzJ9KZwPdunqAFiOTVkXDdHUhilVO8E8Q2dm8ouHXmaaO
   vxzJgscwqh+C57wkkh1SN9ztQ8rfnHTJiRXT+xyERmBhywAnQ8m/tx9vo
   A==;
X-CSE-ConnectionGUID: 5QnkFYJMSfaEf9LqbgKpsQ==
X-CSE-MsgGUID: kEq5PdFMRIy/6MTjvDbSAg==
X-IronPort-AV: E=McAfee;i="6700,10204,11103"; a="37838213"
X-IronPort-AV: E=Sophos;i="6.08,239,1712646000"; 
   d="scan'208";a="37838213"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2024 16:11:40 -0700
X-CSE-ConnectionGUID: V3nV3dJ/RGOLYU0DKvH2vg==
X-CSE-MsgGUID: 9Nk3D/vjSy2E4VY5i0pD3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,239,1712646000"; 
   d="scan'208";a="40792370"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Jun 2024 16:11:40 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 14 Jun 2024 16:11:38 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 14 Jun 2024 16:11:38 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 14 Jun 2024 16:11:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gp9o4eYWyMqdoLfqJRPLgIDYJaB7RQGXST5ksaJD3XOZNiD4svT22/83cu8EXnV7SK80ibyR7Hb8wWqzApaKsjrydjhG0aFRtpeMLNEpuRCuSI7BSrV0cWpUVhvIMNS96L9LaUXea+PlBJQD0eHAeDs+4DiB8emGpn3jqgS+POujGOnWymDJtZeiOZUTwxYbs7gcZCbWXjoSG0qcZWSWIE3yPtr8ELS0HQKA5aG0gSNoum1dZsKwNEi++djoLVy5Q/xuF3xL3vXr//d2tSTgUBqoN2Xeq2IQrARrxL3dqw7oeoFDgUQffzIcUpRTEh6Q5/Uc/FFld8TL57r26SfdFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r4ISXemJJJgk3QIPTXCSApLAoa0MMU5cz5afSIvjMig=;
 b=StB2kCFP7xmxs40tK/FnmjcprZMI/7foEF9FgF29ZE7hMkXE9CHY33Chn5lpaNrNyjQND9L833Jwg6fgJqaDlL7SX+3vJ7wXPa6+98BFHzotZ79tyWgfuAgwpISoBR0cVrpeZqxaBPaXEsSnchtKXGosqUuIMA1kijL38BzjqVZ/R1qPy0TjNKL6crRTIWjhCz4VsYP/DZOONAWAK0d0AtCejDZTfZBpyIJlaJBPNtOGudFW6QLol00eFr7LeGgTiVix1pOm+0hNggYhMVIdemifXm92lM/TSvROkYqjDnDkKQol32xMb3Cf47kbBGFxatICpr78b1zv7L3mJh6CkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA1PR11MB7853.namprd11.prod.outlook.com (2603:10b6:208:3f7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.25; Fri, 14 Jun
 2024 23:11:35 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7677.024; Fri, 14 Jun 2024
 23:11:35 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "seanjc@google.com"
	<seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>, "sagis@google.com"
	<sagis@google.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
Subject: Re: [PATCH v2 11/15] KVM: x86/tdp_mmu: Reflect tearing down mirror
 page tables
Thread-Topic: [PATCH v2 11/15] KVM: x86/tdp_mmu: Reflect tearing down mirror
 page tables
Thread-Index: AQHastVrZBAtPhU8HEOPIJjeiY0PIbG8OJgAgACqCYCAB6dOgIADcMwA
Date: Fri, 14 Jun 2024 23:11:35 +0000
Message-ID: <dd0fe900fc9437d3a0e6d9640ec1f966055c729b.camel@intel.com>
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
	 <20240530210714.364118-12-rick.p.edgecombe@intel.com>
	 <CABgObfbA1oBc-D++DyoQ-o6uO0vEpp6R9bMo8UjvmRJ73AZzKQ@mail.gmail.com>
	 <c2bab3f7157e6f3b71723cebc0533ef0a908a3b5.camel@intel.com>
	 <20240612183905.GJ386318@ls.amr.corp.intel.com>
In-Reply-To: <20240612183905.GJ386318@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA1PR11MB7853:EE_
x-ms-office365-filtering-correlation-id: 0d602adc-4727-4b64-30dc-08dc8cc75635
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|1800799021|366013|376011|38070700015;
x-microsoft-antispam-message-info: =?utf-8?B?SWpZNWxlMjNnTHliTS9WcnJLR0ZTd3pKTGFUb3VvekJGVzM5OGErMmpwSWZm?=
 =?utf-8?B?Zk9DQ0NYZE9SVTJNWnRVTVNzc25JbU1KWGpwUzZCVStnSkkzTDhLUjl3L3Rz?=
 =?utf-8?B?NEg4QUlSYUtVanJaTjhaTDNSMC8vR0RNNTFtSkdmOWlTOWtwMVZVTXlpVTVn?=
 =?utf-8?B?Z3JPclhWY3hkYUtrcWpYU2lFQ0lCVWQxN1BKZkwrbkQwb2N4T2VWbmVhS1lB?=
 =?utf-8?B?Z0NOdm55VzFocVZUVlVqbFMwdXpCeUdPNmJlVlJnK3FGZWNEa1ByeXphNks2?=
 =?utf-8?B?SVJVenF6TEtiMmNJamxaUGo4NDdTVjZRQjNFeWxjd3RYb21NczJzZEFZSjU3?=
 =?utf-8?B?SHRjalUwWjYxd2ZiNVFBWHhLUXdVbHh0T09xVXc4cjhERGora1dPTUMrWitH?=
 =?utf-8?B?d3N1WmQyUnAyeW45NCs5K042VzJZMDNrTnRrTWZZL0JuVmg3TWZMZWhIM2g5?=
 =?utf-8?B?MHhmeldoVTV3R3VaTU9QUm5nZ1I0YmgydnJrcHduMGpadm50YW9nWHk1c0tN?=
 =?utf-8?B?VGdJYkdSek5hQmVIWnBuTi9lL0dFQ3pxOU9nb1ZzL08zejJFOElOWVRMZGNT?=
 =?utf-8?B?cHRaYk5zWHUvMmNCS0pEcUN0NXQzcTdaNENoOHRxRUVIR3dRTXIrSTdXQm5V?=
 =?utf-8?B?c0tCZnZaZ1hZTUJMaWQ0eHh3UURJL1hSRVd0YkZhUHdDRUFOVUJmU2lrQ0Jv?=
 =?utf-8?B?UUpITVhVNmQ2eU1PSFB5d2xlY0pwZ29ROXBldStKUHd0dzNKaDhFbW55Nnpo?=
 =?utf-8?B?WkJNUzhNeWRnSlpjOEE0eWJCUUxzWkM3T2t4NTF0ekQ5ZkIvZlRaaHMzaits?=
 =?utf-8?B?SVIzazg1WjNhemlzc1JxclphbHJMNTJsbkJYakNuYUVZM1RUVjVjbjl0MzYv?=
 =?utf-8?B?VUVreTlBWFdjb0NyV3NsY28wS2tVblMrdmJpN2svamZHV0tNSG90SlUwa2V0?=
 =?utf-8?B?NTRjL3RkK1hNaWpRNzBEdmJsSGo1Z1JJemMvSGxSOGs3NG9UdjFNaThoT2lF?=
 =?utf-8?B?Q1JvWFhWMjVuR1I5TFpnUVFKTnhob2lUWjZIbkxKZ09wcnd4a0EyWHRnUjl4?=
 =?utf-8?B?TVJvdGtQT05yaVhibnF1dEVwdWFLMFB2ekVhaHhkTkF6N29TSTRINzFrUFFp?=
 =?utf-8?B?N0pzZWVIMkN6TGJYeWxpaitINS9ibFllU1VxQkFZQUdXSXRRSmhlZVU3UWxT?=
 =?utf-8?B?M1hQaVBWS1VFZTUyM0lETGRjc3JMSXdyRXVya0dFbVpJS0pkSjRYTXM5WGZK?=
 =?utf-8?B?OHFWK3dwM0VzSG16VjRIT08wM3BGamhrNEZ5SUFBdkNCbjkyK1VHdGJoc2NZ?=
 =?utf-8?B?eWl6WHJOeGlEa0dpS0RxQUg0TDZ3WHNmL1B0L1ZKRldxR2RFcWozY3I3OUpQ?=
 =?utf-8?B?RE02SFJmWXBzOXdSTmxMNFV6LzcvcXdhRXNSQ1hFNU5HWDRWN3hJN2Z2dXpl?=
 =?utf-8?B?cWhCSE5kVFhqVG9rZHpBMlhZK2RtSmVtQktiWVlXbEVjZldzQURNSGN5T1RR?=
 =?utf-8?B?QU4xekFQYTQrRkVUak0zMkRsOFRNeFFmMVRDd0U2NTQ4S2dwQmd4RnhGTVNu?=
 =?utf-8?B?aExyM2Q5REx0NW8zS2FkTHI4WEplaThOb2tWWk1Cd3ZoTlpGMmJxM1FZUG41?=
 =?utf-8?B?UFkrZ1FVYk5EenREbUQvSTFxVTEzbGxCQ1pYeHA1Vll0d1lXbWl1WHJHT1Zp?=
 =?utf-8?B?czVTVHR0ZzZjMlgrekZseDVraVhpWVhpeTVxTDhVc0hkc1oxZ1dEQko4V2N6?=
 =?utf-8?B?dm01NUJDQmJwNzJFQnVXRXBDU21BcTZEQUtZQzJEanlXdGtDN3dMQzAzbys2?=
 =?utf-8?Q?Ald8QW55THkH21Qb2mr2d0TGFBOAhZBVQ4wJg=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(366013)(376011)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OTd2dVR3RDdvVnVNaGF0YXFEMUV6OVJjYm9wMXFuTVBiaytHdFUzT1dHOUJQ?=
 =?utf-8?B?dWl5VGYxcFlUbkR2aVhlcFlyQmp0L3k5NTZHUVdjbVRwaFduODFscnI3ZVNI?=
 =?utf-8?B?UzY5bG80NGg3b0xMT2p3M2cyb0pIV3pISTV1aGdYMDNIVGMveWYxRllSRzdM?=
 =?utf-8?B?bzB5K0hQNHBydTRTdHRYWE45Ty82ZE9XbHdCdnlVYktaVGdPNkoxNWdMYnNV?=
 =?utf-8?B?c2RSVTFUTEkxZU5QVjFhNzUwdkc4T21sUnMvaENpb2pzcFY5TzJPWVdSWmYz?=
 =?utf-8?B?eHQydFJoVEJsMlgxNUhwcGhyei9xSWNkaFNnK09PTGZwcXowQ293TUs4aTlr?=
 =?utf-8?B?YWZsWGlDVXlkc1poQlpubUZKMDZ2WDU5Vy9QL0xUR1hQSHdVTXpuM1JnM2ZL?=
 =?utf-8?B?WGphSlBzN2VLOTBXaXB4eERUczh4UUlKbjNGNms1SkZPbElNNEwrYlBpUlo1?=
 =?utf-8?B?dUpyNHJLQzlmNG8yUDZUbTZTRTdVdko4Wm1GQWVWcG9rN0hteG5jVXBza25E?=
 =?utf-8?B?QWI3QlN6U09lQUVjc09SOXdFb3BBei96VDQvckVQdVFDTkdsZGFLcFNkcEht?=
 =?utf-8?B?Z0M5dHFWa1NkcThEdk02TDYvODVuQXJOTDBDMWhXSnhpY1Y2eFlxV0Irbkda?=
 =?utf-8?B?VVFOUkxPQ3htNUtKeHdCUU12YitZV3ZGR1BpeVBQQWpTSGhxT1l4eXVIbVdE?=
 =?utf-8?B?dkFaaHozSmMzYmVUUm5acmZQUUZUcXpOamZTVVVTOWR0WXI2TzJjM3FrTnNJ?=
 =?utf-8?B?ZkpMdEVxNU9GQWZqcWk1V3lXeVBTS2kxTnFMTHpzbmJlaExwaUlVMFdieVY0?=
 =?utf-8?B?c3lWOGZKTVNrMXBjTys4UnhxRHpMVmtGZXdzTU5KUVE0TE1PN050SVFxNHNw?=
 =?utf-8?B?bVVXVXB2Q2w3R1R2eFJjM2FIVC80bkkzbTVaRzMydTI3TUo1NHJRSk5uMUR6?=
 =?utf-8?B?VTlsZ2pPanFVUVBQbzczeG93YThCOFpMMTBnQXVWMm91RWtQZFZuTng0cE1Q?=
 =?utf-8?B?cEpZWFN3Tzhwc1dBcElZamd3MmpPWFJOVU55Nzg4S084UEtFZ0E0SUZNVW1v?=
 =?utf-8?B?d1BoOE9hK016QXNmS09yMXptdm5LMVprb3JyckpBTTZUeEQwTG8xY2tiVHJw?=
 =?utf-8?B?MDdOOXhTZitzWWt4bis2RWpmUThzTG1Vck9OM0VSTmFlRFQ2d1RvaHg1OGVx?=
 =?utf-8?B?OUVsY09WQ0M0VmFYUFAxWVBUTTdUcVU5ZGNYYlVwZFQ0L2Z5VGMxVDI0elhS?=
 =?utf-8?B?L0R5bmVIRUlrbTdPTGlzKzNmeVhyaXEwVklzVUNGelZNdzhtMmVqQUtXMnFY?=
 =?utf-8?B?aE9STGxRYjArUlFqSjlhbm9EWmJpUFpkS1Fhc0Y2OVlmRUFJWVNGeVJKdlAv?=
 =?utf-8?B?UzNyZnJyc1EyVFhGS3IxQ2Npc2JMeDhYVmR2MDBYblIySUZxL1dpT0dhZjVP?=
 =?utf-8?B?Y2NJMW1yZlJOcnByTURKazdRakFVeTF0eTRYcEpRSUZ5c0hUaWk0TVZ6d0Qy?=
 =?utf-8?B?OE8zYzBQVEZvUEdkZmkyeVlDUHJ2N2xzVDFLcWxVWmZXeUoxa1VHczU3bEZ5?=
 =?utf-8?B?b1poWm1VNHp6TVBDUy9McGlHcGJ6amV5RlE0Wk5lMDlPUTN5ZC9ocXRCMFAx?=
 =?utf-8?B?Q1d1cGhoWTkzby9QNXlFd2VyN0RzU0pkeHdCY3VLZ0ZsUEVrNmt2NXVqd3BX?=
 =?utf-8?B?R1JoOXpXbTAxZDVRZ2lGU2l2cUZMLzFoMWM1WkdibWF4eEdUSnJhNHRtRjdk?=
 =?utf-8?B?WjFrOVF0ZjJvOXErZWZjNVJQTFZ5U3ZlVkVzWk1pVzJQSmQyM2wyMXNPL0R4?=
 =?utf-8?B?YjZ4QUFiL3NIN1lUU24rR2tPNlowdDdDN0FJdHNJV0lISW44RFhHQlJtQmY1?=
 =?utf-8?B?YWFXWkMzM2s5aVpTbVBJZ1FkU2J0Q2dWMFlBRC95UmV1T0V1VkNUUDMwcnBL?=
 =?utf-8?B?K1VFMEhoNXhFc2NqRjZiZ2UyWkR4ckVZbXVGa0lldTBlYWRNdFlaZmpHY0JR?=
 =?utf-8?B?bWEyOFBwaEhmUmRiMGRHdUZSTlh4b3FiS0NOb0R5cC81b0NObk9xZ0NMOUF3?=
 =?utf-8?B?YWxrR1lHVU44bDZON0ZQa3psNmhNa0lZSEJDWUUvbHBybUZlVzkycXBFS0hU?=
 =?utf-8?B?aFUrNmJSN0o0NFNzTG1kamlxWmxTNjJTQ29EcC9VM2JTckw3YXI1QTB4c3Fo?=
 =?utf-8?B?Q3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BBCD5E9D0B8A884E89620E340FB0060D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d602adc-4727-4b64-30dc-08dc8cc75635
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2024 23:11:35.2365
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TsNd7DTH28nx7G0Jokfztmx0giAfehw8UdhI3+mpFx1z7tK2iSvi8XFchCpfdf+K7WCEydh3jaPjUDUtCojleVKhzu2P85IU+ClEcdVf9Rs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7853
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA2LTEyIGF0IDExOjM5IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gPiBURFggb2YgY291cnNlIGhhcyB0aGUgbGltaXRhdGlvbiBhcm91bmQgdGhlIG9yZGVyaW5n
IG9mIHRoZSB6YXBwaW5nIFMtRVBULg0KPiA+IFNvIEkNCj4gPiByZWFkIHRoZSBjb21tZW50IHRv
IGJlIHJlZmVycmluZyB0byBob3cgdGhlIGltcGxlbWVudGF0aW9uIGF2b2lkcyB6YXBwaW5nDQo+
ID4gYW55DQo+ID4gbm9uLWxlYWYgUFRFcyBkdXJpbmcgVEQgcnVudGltZS4NCj4gPiANCj4gPiBC
dXQgSSdtIGdvaW5nIHRvIGhhdmUgdG8gY2lyY2xlIGJhY2sgaGVyZSBhZnRlciBpbnZlc3RpZ2F0
aW5nIGEgYml0IG1vcmUuDQo+ID4gSXNha3UsDQo+ID4gYW55IGNvbW1lbnRzIG9uIHRoaXMgY29t
bWVudCBhbmQgY29uZGl0aW9uYWw/DQo+IA0KPiBJdCdzIGZvciBsYXJnZSBwYWdlIHBhZ2UgbWVy
Z2Uvc3BsaXQuwqAgQXQgdGhpcyBwb2ludCwgaXQgc2VlbXMgb25seSBjb25mdXNpbmcuDQo+IFdl
IG5lZWQgb25seSBsZWFmIHphcHBpbmcuwqAgTWF5YmUgcmVmbGVjdF9yZW1vdmVkX2xlYWZfc3B0
ZSgpIG9yIHNvbWV0aGluZy4NCj4gTGF0ZXIgd2UgY2FuIGNvbWUgYmFjayB3aGVuIGxhcmdlIHBh
Z2Ugc3VwcG9ydC4NCg0KWWVzLCBJIGRvbid0IHNlZSB0aGUgbmVlZCBmb3IgdGhlIGlzX3NoYWRv
d19wcmVzZW50X3B0ZSgpIGluIHRoaXMgZnVuY3Rpb24uIFRoZQ0KbGVhZiBjaGVjayBpcyBuZWVk
ZWQsIGJ1dCBhY3R1YWxseSBpdCBjb3VsZCBiZSBkb25lIHdlbGwgZW5vdWdoIGluIFREWCBjb2Rl
IGZvcg0Kbm93IChmb3IgYXMgbG9uZyBhcyB3ZSBoYXZlIG5vIGh1Z2UgcGFnZXMpLg0KDQpkaWZm
IC0tZ2l0IGEvYXJjaC94ODYva3ZtL3ZteC90ZHguYyBiL2FyY2gveDg2L2t2bS92bXgvdGR4LmMN
CmluZGV4IDAxNTViODMzMGUxNS4uZTU0ZGQyMzU1MDA1IDEwMDY0NA0KLS0tIGEvYXJjaC94ODYv
a3ZtL3ZteC90ZHguYw0KKysrIGIvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0KQEAgLTE3MjEsNiAr
MTcyMSwxMCBAQCBzdGF0aWMgaW50IHRkeF9zZXB0X3JlbW92ZV9wcml2YXRlX3NwdGUoc3RydWN0
IGt2bSAqa3ZtLA0KZ2ZuX3QgZ2ZuLA0KIHsNCiAgICAgICAgaW50IHJldDsNCiANCisgICAgICAg
LyogT25seSA0ayBwYWdlcyBjdXJyZW50bHksIG5vdGhpbmcgdG8gZG8gZm9yIG90aGVyIGxldmVs
cyAqLw0KKyAgICAgICBpZiAobGV2ZWwgIT0gUEdfTEVWRUxfNEspDQorICAgICAgICAgICAgICAg
cmV0dXJuIDA7DQorDQogICAgICAgIHJldCA9IHRkeF9zZXB0X3phcF9wcml2YXRlX3NwdGUoa3Zt
LCBnZm4sIGxldmVsKTsNCiAgICAgICAgaWYgKHJldCkNCiAgICAgICAgICAgICAgICByZXR1cm4g
cmV0Ow0KDQoNClRoZSBiZW5lZml0cyB3b3VsZCBiZSB0aGF0IHdlIGhhdmUgbGVzcyBtaXJyb3Ig
bG9naWMgaW4gY29yZSBNTVUgY29kZSB0aGF0DQphY3R1YWxseSBpcyBhYm91dCBURFggc3BlY2lm
aWNzIHVucmVsYXRlZCB0byB0aGUgbWlycm9yIGNvbmNlcHQuIFRoZSBkb3duc2lkZXMNCmFyZSBy
ZXR1cm5pbmcgc3VjY2VzcyB0aGVyZSBmZWVscyBraW5kIG9mIHdyb25nLiBJJ20gZ29pbmcgdG8g
bW92ZSBmb3J3YXJkIHdpdGgNCmRyb3BwaW5nIHRoZSBpc19zaGFkb3dfcHJlc2VudF9wdGUoKSBj
aGVjayBhbmQgYWRkaW5nIGEgY29tbWVudCAoc2VlIGJlbG93KSwgYnV0DQpJIHRob3VnaHQgdGhl
IGFsdGVybmF0aXZlIHdhcyB3b3J0aCBtZW50aW9uaW5nIGJlY2F1c2UgSSB3YXMgdGVtcHRlZC4N
Cg0KLyoNCiAqIEV4dGVybmFsIChURFgpIFNQVEVzIGFyZSBsaW1pdGVkIHRvIFBHX0xFVkVMXzRL
LCBhbmQgZXh0ZXJuYWwNCiAqIFBUcyBhcmUgcmVtb3ZlZCBpbiBhIHNwZWNpYWwgb3JkZXIsIGlu
dm9sdmluZyBmcmVlX2V4dGVybmFsX3NwdCgpLg0KICogQnV0IHJlbW92ZV9leHRlcm5hbF9zcHRl
KCkgd2lsbCBiZSBjYWxsZWQgb24gbm9uLWxlYWYgUFRFcyB2aWENCiAqIF9fdGRwX21tdV96YXBf
cm9vdCgpLCBzbyBhdm9pZCB0aGUgZXJyb3IgdGhlIGZvcm1lciB3b3VsZCByZXR1cm4NCiAqIGlu
IHRoaXMgY2FzZS4NCiAqLw0K

