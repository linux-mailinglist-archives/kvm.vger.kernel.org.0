Return-Path: <kvm+bounces-50240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1397EAE2680
	for <lists+kvm@lfdr.de>; Sat, 21 Jun 2025 01:34:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EFF407AF50B
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 23:33:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C681124167F;
	Fri, 20 Jun 2025 23:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UqImWBTa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D80642A9D;
	Fri, 20 Jun 2025 23:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750462450; cv=fail; b=Twa6sRJQzFeaO/Mwg/nqrZASY2ud0TR+AXAOBCpuJTANAjH3z3ULMtGRKsOuS4HE80YZ+7WsnKiyvMhpJPeTEc22n1C/fEE1gnIXdLdvqM8jNEr4EzQ7RbtaipFGNLgHaJKMACo1io8BN3OY+gD59De4J7q7Xu/5MSvXG2+XYMc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750462450; c=relaxed/simple;
	bh=j5j/ATJA3mIJ5q96tEo2eGG1T4HPEyC6N2rKb7Q8fcM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EoiF/dUd5uSlbhQqRE1aC2ZChlcPlTCj6Rztn8zV8IbFaNSmIO5QflWh2oCQzK0uEtJKYzDYKrIVqTCQGgobkl7QF5zr7yKtaB8lzNs6BRORniNcYrdGi1l5JUu9+5xALb20//hRWLqXubJC25fmGPElSN7bNiD7BvQ5B+07CBg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UqImWBTa; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750462450; x=1781998450;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=j5j/ATJA3mIJ5q96tEo2eGG1T4HPEyC6N2rKb7Q8fcM=;
  b=UqImWBTaSQTMTT4kpCDeXsooN2k5teVyEF1/aN5pBVF5w4wtPAxfeZO2
   rLjx/NNWa4YnNipGG8PyS73F3rNlIyqlfwCqlebNdg6pi8uChPDlNj3yM
   5CchzHNz1evpvo1Q4IZOHdBdYEVSwVp8Pwk5ZVtmtGBh1BBV/uWgpUx9X
   S4jeG3S5e/h6QkXhHrQbjVajc6mhH9KuQQdbtmMk5/NRF4nEt+JwIFcBk
   9aJ/dcR1eW0C8svcEbaTY6zVh/4qkdkXUG4HEyKjOf8o+haSvF/Pu1C3I
   GuXcds6NoA7/nhVyTZZqrqk+W8q7GpjaoSvyix5UlB0O0axqYGJvfABIy
   w==;
X-CSE-ConnectionGUID: FWD03+ssTV2boaVyuYZuEA==
X-CSE-MsgGUID: 9B/Qr+/ZTUqKvDkrkO+2AA==
X-IronPort-AV: E=McAfee;i="6800,10657,11469"; a="52879527"
X-IronPort-AV: E=Sophos;i="6.16,252,1744095600"; 
   d="scan'208";a="52879527"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2025 16:34:09 -0700
X-CSE-ConnectionGUID: S02O2RVlR5iFzc3x67dsAQ==
X-CSE-MsgGUID: shVnTGnwTxmgRd16iI5RSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,252,1744095600"; 
   d="scan'208";a="155050945"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2025 16:34:08 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 20 Jun 2025 16:34:08 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 20 Jun 2025 16:34:08 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.40)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 20 Jun 2025 16:34:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ww3iJArt1QRFHOH+nQ+P3TDNu7trOUaWbP4DvlPynwCbfH3pGkVLqSyCvABroIQsSD4xyg3k1pcVvJL7lYhrzJ5Zc2hjOePvYIUOAbb2kaEN/XWd5ZquXAtEFAnhBp5Ut9HpcWO0BCBSXYHNAO2y4rOR48lnyAK2Mhx9jqid37RCopYjIMXvF07R2iFvRScz/LsP4UP51q6WeHlQFjwhCtG3pduy//VFmQR4XVov8qozvip6/3tl5d5n8/gbh8FPtqe+gDSbS0lswHhpbrLPPWgs1OQBWRwmQEjV4WloSJnCQ0jBuePydjKJwyQxiCKydLnfe42HaIS23AOkh31uTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j5j/ATJA3mIJ5q96tEo2eGG1T4HPEyC6N2rKb7Q8fcM=;
 b=qMlcB0tWjn5nqOCbfIbiNT11wP7d/qbodjUVZEEkEchduaH+aSYEJ5vfVW0awYtOGfQcf2tW5WqtWLL7Dc5oghNx6D//l/gVb4H0XnUfbagILalRjX6LLBOd49K7iYA27O4rKI4qLzc7Klyb16DFfF+uCSnh5jVqzn0clMB/QK/X7IKpZktgH7TkCEGMGZ4LLA4+3YeFgWKE1Rn7mWX5hdJ5jOwqLdZVBkIzyKtbF4RQtU33lNSOKfAzX9VYrh/UJmVoG//70AwBy/CicVEvpwCAsT+r+hxIC4Aq4/FmJ7zCuM2NcQy/kRwxhbkWpQ5T6EPUbHrzJOltpoWSXeAt0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM3PR11MB8716.namprd11.prod.outlook.com (2603:10b6:0:43::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.25; Fri, 20 Jun
 2025 23:34:05 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8835.027; Fri, 20 Jun 2025
 23:34:05 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Annapurve, Vishal" <vannapurve@google.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: Re: [PATCH V4 1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
Thread-Topic: [PATCH V4 1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
Thread-Index: AQHb2raQMvS71doOpkSd//tZsUmNFrQFK1QAgANI6wCAAAL4gIAAKpgAgAEMaACAALJ8gIABx94AgABM3ICAACfUAIAAJO8A
Date: Fri, 20 Jun 2025 23:34:05 +0000
Message-ID: <1989278031344a14f14b2096bb018652ad6df8c2.camel@intel.com>
References: <20250611095158.19398-1-adrian.hunter@intel.com>
	 <20250611095158.19398-2-adrian.hunter@intel.com>
	 <CAGtprH_cpbPLvW2rSc2o7BsYWYZKNR6QAEsA4X-X77=2A7s=yg@mail.gmail.com>
	 <e86aa631-bedd-44b4-b95a-9e941d14b059@intel.com>
	 <CAGtprH_PwNkZUUx5+SoZcCmXAqcgfFkzprfNRH8HY3wcOm+1eg@mail.gmail.com>
	 <0df27aaf-51be-4003-b8a7-8e623075709e@intel.com>
	 <aFNa7L74tjztduT-@google.com>
	 <4b6918e4-adba-48b2-931c-4d428a2775fc@intel.com>
	 <aFVvDh7tTTXhX13f@google.com>
	 <1cbf706a7daa837bb755188cf42869c5424f4a18.camel@intel.com>
	 <CAGtprH8+iz1GqgPhH3g8jGA3yqjJXUF7qu6W6TOhv0stsa5Ohg@mail.gmail.com>
In-Reply-To: <CAGtprH8+iz1GqgPhH3g8jGA3yqjJXUF7qu6W6TOhv0stsa5Ohg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM3PR11MB8716:EE_
x-ms-office365-filtering-correlation-id: 4c6014df-4846-45b7-a124-08ddb052f206
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?b3FxRWZtcTJuaDdBeUlRZTUzK3pZcXJ4UXZmRHc2Z2JvL01IM1M3cDVOUzdB?=
 =?utf-8?B?eU8wVWxnNnM0QUJtQ3EwbWFxbThBZVpqUmhGZTdPS1pCYWJzSEthZjNYUUlq?=
 =?utf-8?B?OHlWWWFtRC9BM20vMzRBdkpmTGl3TzJIb0x0aGk5V2ZlVktoQzRXdnJ2RWlN?=
 =?utf-8?B?QTUzT0ZKVDVQZFJJR1FVTnUrUXZsZVM1RWRCSCsvazVZUk9mbHFTMXhJWXU5?=
 =?utf-8?B?N29FYzcwbS8ybDE5b2tKVlZaRVhPa2dRZmxSOGV3Q2tCK01NeFhtMkNFcU5y?=
 =?utf-8?B?aVRZRE1iNlV4cUhiV3l3SkhEUk95OE03dUNNalR4YyttaExrT3FPRmYrNzFp?=
 =?utf-8?B?VnB5ZTNTRlZVWlRxNE8rU1ZuYjVpRURuTnJoM1dpZHVBb2ZQOC9HZEpRcXRy?=
 =?utf-8?B?VDIwS0RLWlNEQzc2Y01OSzhCRnlrbUtDWmNIZThGaFB4Ti9McE5NVGVCaDRh?=
 =?utf-8?B?U1VBSnorYzI3b09NYVdWU3NzSWpiRmdaMEFmblN5VWJzcHl1ZUVxb0pQbjdy?=
 =?utf-8?B?RnhNTlNrN3hZSEgvUGFmK1orMjdUOENuNmtRUytWL2trcVVXSDR1RDE0bjBy?=
 =?utf-8?B?Mm5EZDBDNWNVQzVSTzd6UXpVbVB2bXVqNHAyY080UDIxVlNzcDdHV2xpZTVr?=
 =?utf-8?B?ZWcwek1VS1NEUFJkMGsyUUpwajBybEpEUDRIdzU0bHNaangrdFZ5ZVRhdVI3?=
 =?utf-8?B?ZVRyMlpGbzFndVlOWVUrNUgvN0M1Y2lleHl6ZnNvck02U1VnZXZURkcra1hT?=
 =?utf-8?B?Yzh2dng2bHJ0Z2YrcGtkYklIZlY1c2pMb09mMk4zN01nWGlEekIrbUxCT3p0?=
 =?utf-8?B?anpkSnU3SzUzc3VXOXBGYkZtVFlWKzlrZGNTblR0cWlUWGQwVVd2ZGNrKy8y?=
 =?utf-8?B?YWNUejFWS1c5ZHRYVmhIS1lYUWNobDR6VDF0aDE2cG9oM1YxS2tqb2NkemZG?=
 =?utf-8?B?T1AwMG5xaVJnMnl1NEtVTFo2V0ZrZHVscmwwWC8zSTlpZ2lheXg1RTc2T2lk?=
 =?utf-8?B?NnlYbDF5Z2JSa3NYUks1SXp6NjY4YUxyOVZ3MDhCdnFhSVQwU05aQUxxUHNG?=
 =?utf-8?B?RDRvVzFqd3B0Q2FBUlUvTFQxTFpQTnJMUXcrSEFVSzZYd1pmZXpyQllaRGZF?=
 =?utf-8?B?T1BabXV6UlUvTnBvanFMY0wzQnpPRkkwNWc3NlNEdm9GMkhyc3dOU1ByTVhE?=
 =?utf-8?B?NWhIMmo4OXRvSmRoRWt1bzB1YnA3QzEwcFo0UjYyTzNxOE9lR0kvazBOR2gy?=
 =?utf-8?B?OUxhUCtERkVlT2tpYWVqMldsaFc4OTFrOEp1TzJvM0t1Uzh6MTRRLzZlTXJM?=
 =?utf-8?B?M0hNN2FPN0dseHBjbUZCc2k4aDRMb0lLeFV3U1NUdmdtOXBJUUdWR01iRWNB?=
 =?utf-8?B?SzFiem5GS0hML3lSRFZlWThucU9rLzAxdFRuZHBJS3JhNGZjQVhFZWdMV3dp?=
 =?utf-8?B?YUpzWnczMzIwOWQvZkRjbHUzWUdiTnhndG8vYk8xN3JxTU05SVNra3NpK0F4?=
 =?utf-8?B?Q0VmdVVDT0tuMGlVMzFwVXRoSEprOW1JT1AyYXZDRWRKMndScXU3cVY1U2JD?=
 =?utf-8?B?V3J4bmVraFM2cm90bXpleDkxd3BUc2pVYzQ0a2ZsRndlaGNJOTVFek96c3RM?=
 =?utf-8?B?a05LeHUwdXdEV01wb2ltb29sRGIxYXVvSHZHaDFNWXNrQzdsZGFYOS8rdVNE?=
 =?utf-8?B?LzZHekJSdHp5QnNvMFJIYjcrOC9xUjI5eDZXUGcwNWhIaHNEMHFFd1o1cGFB?=
 =?utf-8?B?em9LemhrSzVHcjFBNzlFb2ptNzhsWlZHSkh0MzhNVnYzUHhHZWZZZ3BkVkFX?=
 =?utf-8?B?bHQwRlhSQko2bCtWcUZCQVRibFYvaTZML3VEaFpmTWc2SGd5NGlxNG5NTWNK?=
 =?utf-8?B?RFFWQW92YjNUcWI4cWhJWDFlUmppcy8vSWRxYXovczFrUGhaWGF3dlQ4UlVv?=
 =?utf-8?Q?EQPMwfF53IK/Wb5w1MxlnpknXXbxhjO5?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y0YrTkpJKy83U3BmYkRoem1JSVVGV1dHZDcxUjBqZW1sUzRCZlR3UnFTQjhO?=
 =?utf-8?B?a1pram8ya29pSWtDYitzSFVRUWJ0b0pvTllEb3Z3OXpRNVl5NEliTWppcUFn?=
 =?utf-8?B?Lyt6dVpxWEhCUXdMVTh4T2swYlFtajB1QVdtQXRUZldYR0tSQW9waTcvQkdq?=
 =?utf-8?B?QjBtZVg0SFdlN09iUWpHZzNlMGhQRWtpZ29oTkwwYTc5aUZWUGZHdlN6RW9q?=
 =?utf-8?B?cUk0VXlqNVdOWGYwK1BlVUtaWVkzT1NKVGwvRkZ2TEk5eVYxb1dvVFBVWnc2?=
 =?utf-8?B?VXBlN0FYdlhUTm9kVFdVMEE2YzVEdEREVWJuSEpyem9GRGdlcWF5WVltcTFS?=
 =?utf-8?B?RFQ5dWdaTGcwaHFzY2ZxcVhoM0Q0WUlDdnNZdTZySVR2cFMvcTVyRStIbkR5?=
 =?utf-8?B?djBaWlNpWWhGNEN3VnNWZCtSbjJpODR3NVA5YStER1UwMXg5MGZmTUdwenpG?=
 =?utf-8?B?ejg3d0k3bGRrVnl2VSs2ZlpRU3k4dXVWYlR3eW5UTmhJRVdpUkRiVGxTSU55?=
 =?utf-8?B?TlpFdEhYa3F0WStTZUk2d0hnOTZ0YXJjbXloTWdlaVp4Ym5pYlNEUHl5OERn?=
 =?utf-8?B?Vm9MZzdUNjBuekRvckZieUR1NzNMRGRxOXREQUVKZUdSRmRNSEJTZDJ0emJD?=
 =?utf-8?B?NTFsQzFVZ3V0c2FsV2ZlRURuaFRYbGxpTkNWNzkyYmsvR0xBSkRXQkRjY25q?=
 =?utf-8?B?SmVkVG1pd0NreldkUGJnOXZSZHA3citzaHc0R2UreGN5WFA0RjkrMUcyV1V4?=
 =?utf-8?B?aEhTSno0RlAvbG1DY2VsKzJiMG1OVURqVkNZazNBUjB0U1RiR2pkQUR3RlB4?=
 =?utf-8?B?R0lYMnhiM2tQMkg0WjNuOUxQeTF6aGZqaCtYSmk3NUszTXdMckhxWWlXOG00?=
 =?utf-8?B?ODZ1YitaWmJSblZ4Vm1qaCs0dWZxUDBPNjZLN1ZBUFJGV0o1V2YzelZGckhj?=
 =?utf-8?B?VGtWcCtKWlQyTWFMQTErbE5GKzRiQ3l5TVEvcW1TMzd5T09kT0JzSEhac2lL?=
 =?utf-8?B?ODRLbkVHZXVXb05SNTlOdm82Zk90TGQ1OGEzK0kvSXJwQkJnMXB0MDM3azF2?=
 =?utf-8?B?ZEtGTU0wd2cwb0JockhjdVowQWpFeWlIQlBrdDhwUytRZWw1eDZrbUo1YTda?=
 =?utf-8?B?dFZIeXF3SDh0RGlaYitJNU5sQW9hWG8rREVEYlFGczIxQzJTS0FjUkoyTTUx?=
 =?utf-8?B?WnU2OW5JS0FOQWRPZnVZV1NibGFUU0pDQm9uaU5LdUc1VSs0cjZVdzAranBM?=
 =?utf-8?B?b0ZueFJqWGFUeTdEcUhXS3BYMVNLRE8zR0JWdzM2ZGZ3YklMSWExZzMwWFBs?=
 =?utf-8?B?b0hQbW8yOW1mSjd3OEFRVUdRMXNZdmlZcHdmeFJBMXRjeEVkbzU5WWY2NjVG?=
 =?utf-8?B?UnpBOUgzMEt0VDFpUDZRVXdVZWJaVUkyb0NyNVZxYnRRUkpzVlZJdm92Smxv?=
 =?utf-8?B?MVZTcHRtcGV0NHByamd2K2FwcDFNMzhhTmhleHh6bmFWSzduWDJFWjFZdWMy?=
 =?utf-8?B?Um1RcEx3M1BldmlWdDZjcDhzaExUZm1XYlpaY3R2Y3daZ01RWEdkU0R5Qld3?=
 =?utf-8?B?RjR3a0tFc2o1WS9WWFpENDZ4UkdpYy95ZjBGZ3lBTkZjUkNyQ0ZCdUpWeXg0?=
 =?utf-8?B?RjVQd2UrWHhKaVdPelVZWm0wSkp0SmpXek5FUzNNcWdNWjk4WWorbmJXVm5s?=
 =?utf-8?B?L2NlVm1VQ0dJcXg3ZTZrUkQzS2VvUHhlUXRVYjlUMWFBU2Z6d2NQZGZtZzVG?=
 =?utf-8?B?VmpnZkh6RzZtVFRrUTBxMUdWVXN5dzlzRTdtUklsM0xvK3FkeGlyRXVsUDRG?=
 =?utf-8?B?dXNGbzJxM2hSZ1BvS003VExsYmJ0ZjlQelh4MXBaMlQ0T1d3SFhWZnh5S3ZU?=
 =?utf-8?B?VW5FSFFTVzgzZmVwNy9GSzZFWC84by9TaVlhdnp0MjJOSTVpbWRxeXNmUExM?=
 =?utf-8?B?RndEMW0zSWpaWW8rSmhNVlB4ODZIeXk2M0tMSE42YngyN05vaGhtZGo3SjBD?=
 =?utf-8?B?dy9GeEZJN3VyZm9HTUh2ZjZOcmdJb2U0cE5abWZZNGQ4OG9mcUs0eGxMcTNv?=
 =?utf-8?B?dUJ6N204eUFjUU1lVkV0T3VFSTZFNktYbkw1QkF4eFc2dlRFY0Q4amRGTlZF?=
 =?utf-8?B?blFXUWJ2QVpCNHJmMUdDc1c2NmN2UlJvRHZrTlAyUWMxd3VzUVN1VktyZDRk?=
 =?utf-8?B?M1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5C23996CC75F1C4FBFCB890B63A0F00A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c6014df-4846-45b7-a124-08ddb052f206
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2025 23:34:05.0469
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c4G6Htq5T3/xVqiy1d3xOEnBFsK2IwNv86GmoMLOPRv18nBSlV6hzcyA/GMXwFOsKnaP24sRUNTGnAgxcqbjRnWcQmKUf6FIcM3+pa0dA3Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8716
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA2LTIwIGF0IDE0OjIxIC0wNzAwLCBWaXNoYWwgQW5uYXB1cnZlIHdyb3Rl
Og0KPiA+IFNvcnJ5IGlmIEknbSBiZWluZyBkdW1iLCBidXQgd2h5IGRvZXMgaXQgZG8gdGhpcz8g
SXQgc2F2ZXMNCj4gPiBmcmVlaW5nL2FsbG9jYXRpbmcNCj4gPiB0aGUgZ3Vlc3RtZW1mZCBwYWdl
cz8gT3IgdGhlIGluLXBsYWNlIGRhdGEgZ2V0cyByZXVzZWQgc29tZWhvdz8NCj4gDQo+IFRoZSBn
b2FsIGlzIGp1c3QgdG8gYmUgYWJsZSB0byByZXVzZSB0aGUgc2FtZSBwaHlzaWNhbCBtZW1vcnkg
Zm9yIHRoZQ0KPiBuZXh0IGJvb3Qgb2YgdGhlIGd1ZXN0LiBGcmVlaW5nIGFuZCBmYXVsdGluZy1p
biB0aGUgc2FtZSBhbW91bnQgb2YNCj4gbWVtb3J5IGlzIHJlZHVuZGFudCBhbmQgdGltZS1jb25z
dW1pbmcgZm9yIGxhcmdlIFZNIHNpemVzLg0KDQpDYW4geW91IHByb3ZpZGUgZW5vdWdoIGluZm9y
bWF0aW9uIHRvIGV2YWx1YXRlIGhvdyB0aGUgd2hvbGUgcHJvYmxlbSBpcyBiZWluZw0Kc29sdmVk
P8KgKGl0IHNvdW5kcyBsaWtlIHlvdSBoYXZlIHRoZSBmdWxsIHNvbHV0aW9uIGltcGxlbWVudGVk
PykNCg0KVGhlIHByb2JsZW0gc2VlbXMgdG8gYmUgdGhhdMKgcmVidWlsZGluZyBhIHdob2xlIFRE
IGZvciByZWJvb3QgaXMgdG9vIHNsb3cuIERvZXMNCnRoZSBTLUVQVCBzdXJ2aXZlIGlmIHRoZSBW
TSBpcyBkZXN0cm95ZWQ/IElmIG5vdCwgaG93IGRvZXMga2VlcGluZyB0aGUgcGFnZXMgaW4NCmd1
ZXN0bWVtZmQgaGVscCB3aXRoIHJlLWZhdWx0aW5nPyBJZiB0aGUgUy1FUFQgaXMgcHJlc2VydmVk
LCB0aGVuIHdoYXQgaGFwcGVucw0Kd2hlbiB0aGUgbmV3IGd1ZXN0IHJlLWFjY2VwdHMgaXQ/DQoN
Cj4gDQo+ID4gDQo+ID4gVGhlIHNlcmllcyBWaXNoYWwgbGlua2VkIGhhcyBzb21lIGtpbmQgb2Yg
U0VWIHN0YXRlIHRyYW5zZmVyIHRoaW5nLiBIb3cgaXMNCj4gPiBpdA0KPiA+IGludGVuZGVkIHRv
IHdvcmsgZm9yIFREWD8NCj4gDQo+IFRoZSBzZXJpZXNbMV0gdW5ibG9ja3MgaW50cmFob3N0LW1p
Z3JhdGlvbiBbMl0gYW5kIHJlYm9vdCB1c2VjYXNlcy4NCj4gDQo+IFsxXSBodHRwczovL2xvcmUu
a2VybmVsLm9yZy9sa21sL2NvdmVyLjE3NDczNjgwOTIuZ2l0LmFmcmFuamlAZ29vZ2xlLmNvbS8j
dA0KPiBbMl0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC9jb3Zlci4xNzQ5NjcyOTc4Lmdp
dC5hZnJhbmppQGdvb2dsZS5jb20vI3QNCg0KVGhlIHF1ZXN0aW9uIHdhczogaG93IHdhcyB0aGlz
IHJlYm9vdCBvcHRpbWl6YXRpb24gaW50ZW5kZWQgdG8gd29yayBmb3IgVERYPyBBcmUNCnlvdSBz
YXlpbmcgdGhhdCBpdCB3b3JrcyB2aWEgaW50cmEtaG9zdCBtaWdyYXRpb24/IExpa2Ugc29tZSBz
dGF0ZSBpcyBtaWdyYXRlZA0KdG8gdGhlIG5ldyBURCB0byBzdGFydCBpdCB1cD8gDQoNCj4gDQo+
ID4gDQo+ID4gPiDCoMKgIEUuZy4gb3RoZXJ3aXNlIG11bHRpcGxlIHJlYm9vdHMgd291bGQgbWFu
aWZlc3QgYXMgbWVtb3J5IGxlYWtkcyBhbmQNCj4gPiA+IGV2ZW50dWFsbHkgT09NIHRoZSBob3N0
Lg0KPiA+IA0KPiA+IFRoaXMgaXMgaW4gdGhlIGNhc2Ugb2YgZnV0dXJlIGd1ZXN0bWVtZmQgZnVu
Y3Rpb25hbGl0eT8gT3IgdG9kYXk/DQoNClRoaXMgcXVlc3Rpb24gd2FzIG9yaWdpbmFsbHkgaW50
ZW5kZWQgZm9yIFNlYW4sIGJ1dCBJIGdhdGhlciBmcm9tIGNvbnRleHQgdGhhdA0KdGhlIGFuc3dl
ciBpcyBpbiB0aGUgZnV0dXJlLg0KDQo+IA0KPiBJbnRyYWhvc3QtbWlncmF0aW9uIGFuZCBndWVz
dCByZWJvb3QgYXJlIGltcG9ydGFudCB1c2VjYXNlcyBmb3IgR29vZ2xlDQo+IHRvIHN1cHBvcnQg
Z3Vlc3QgVk0gbGlmZWN5Y2xlcy4NCg0KSSBhbSBub3QgY2hhbGxlbmdpbmcgdGhlIHByaW9yaXR5
IG9mIHRoZSB1c2UgY2FzZSAqYXQgYWxsKi4NCg==

