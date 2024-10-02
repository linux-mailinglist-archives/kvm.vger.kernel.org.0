Return-Path: <kvm+bounces-27834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E0E698E72E
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 01:40:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 38C491C243C6
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 23:40:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 242CD19F105;
	Wed,  2 Oct 2024 23:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i/o2LN4a"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B787194A6C;
	Wed,  2 Oct 2024 23:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727912406; cv=fail; b=KVAZ6g4w97yo9oVKETG4LeD8ijEYDN/aLyGDd8GJ6a8wMID0Y9fLnd+23No7TAhiPRLT8xDdjfyJssVM3m8fP6O/V5jsnyTuCgJSZUctng11i5qr/eaRRx9YlRtSIzo+vDFxNCOrUoj9EPLyQTdE+7ZPibny1cb/ZelOwIZXf70=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727912406; c=relaxed/simple;
	bh=z+cSkknxfNLThiRFPUB4evrO3icO4Zmpmh0XxNY2PHE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qnVLGCkYol2eLXoNlH2H/TsFpo1LxNQSI6LjoIpL3ICxTD5RNn6A2ynYzUsaHQBIN5sgZTQnJiIfF4l0OTw+OAVEoslnWcXncA19RJuslwHXtnGoIu29rNqPVGTQmEMg61OcrChLrpB7vQnK53Pv9lPYwgMc5pn5GwXtuq8nsWM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i/o2LN4a; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727912404; x=1759448404;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=z+cSkknxfNLThiRFPUB4evrO3icO4Zmpmh0XxNY2PHE=;
  b=i/o2LN4aeLplWXUQJD6nM9DgIWxVspWf1DGOuzfdKjS7A5mEjY7s5z1m
   ze+DEtyTzkzoygksVZnFQXLBuiPRm9vxxA0PR+ET+M4Va1c+2aoZmw9+c
   ENyYKGEkGIaRy/oyPa7FNr5x2g149HMQDEZ/NRmkwUNU0wS3oQankOpmR
   hlcUHvT3HqzgSHUEddo81+S/BmvjACBTC6CgI+g3C/rob7Z27aPjIcScd
   P/U2iEnyoSJOvvW686EamsVkysd+dB1OQpX4Y3Y1UPlk+/fkQQXoLNuCt
   RyG5lKnbEgZ5UBprZn5GujDSmBzRjtIHXux38GsDN3Kus+BXrCuxsD5xt
   g==;
X-CSE-ConnectionGUID: rZijul2VSPaA08ZDpiKK1g==
X-CSE-MsgGUID: gYKLIMTPTI6wfGSlHCC7ow==
X-IronPort-AV: E=McAfee;i="6700,10204,11213"; a="27045611"
X-IronPort-AV: E=Sophos;i="6.11,173,1725346800"; 
   d="scan'208";a="27045611"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2024 16:39:58 -0700
X-CSE-ConnectionGUID: as1Jc6lXRnO7GmR55Xz0Dw==
X-CSE-MsgGUID: Slxgq0LeQhKTs8ibMiDALA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,173,1725346800"; 
   d="scan'208";a="79143151"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 Oct 2024 16:39:57 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 2 Oct 2024 16:39:56 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 2 Oct 2024 16:39:56 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 2 Oct 2024 16:39:56 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.49) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 2 Oct 2024 16:39:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=asVOw3pKKmGpu5VfGZsB8r3+iH4TPb8Gj+DhRrYYBlv7S07yQSduAj16rOU8+8bBdXcylRI83MCOnx47wBCjoKY3X2/x0F9rA7U+nvzxRQbP4ijtIhTLbxokKCGI0gtOGs2XOJmyxYvrhW7aD240gVhos1QYgJ81oJOQBmgpYJ4PT8T2ku+XnYJNfdpYMltZVZ55WVU2IeaRXyZsUnQCDma+EGaiNFex/gflIQ92X4KLXUsso+uekcoXXPDuTXAQcCOopX7HhSlUCtdVxOOrVttoui/I3j+fk/fMcI8kz5FtDxCip7+Rq/3OxcWD06jCMq8EQLMOGZ8GLNN71mo3Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z+cSkknxfNLThiRFPUB4evrO3icO4Zmpmh0XxNY2PHE=;
 b=q9o5RAHZGMzytHeR7A/A/nx+gVqzaf8fwX26HNdJlULrGt36ooDp/FrtMj+NSgzXUngerH4JK8vbYMZq5oBsfBBjroABR/0ZawjbZE0yX0wRdo29clCV8Cw0UlZeosD3qVmTQntMxU32IMgxgZVU/hgOCpbRABxOEjk0WxQUTZP24IdJcVFoCc5H4ih5sEvBYzoBsLxIi5PKJOki0/ukRr70QryWrxGBSxvVhMRaMCEXF74nyTz2o3bmh29klIiHCUzOfdJWONh23NajhXabxWPhLKAveLdTTqr4iTl3HOmtgU7nSjIFL9Y1Lip5EBheCT3weRLaEQsgmiMQdEC2Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM6PR11MB4738.namprd11.prod.outlook.com (2603:10b6:5:2a3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Wed, 2 Oct
 2024 23:39:53 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.8005.026; Wed, 2 Oct 2024
 23:39:53 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/25] KVM: TDX: initialize VM with TDX specific
 parameters
Thread-Topic: [PATCH 14/25] KVM: TDX: initialize VM with TDX specific
 parameters
Thread-Index: AQHa7QnMnUIGjafPIE6UNKd4SDTD+rJ0bq0A
Date: Wed, 2 Oct 2024 23:39:53 +0000
Message-ID: <7b256d52843698785e7d13d43c4e7c46e6fa77b5.camel@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
	 <20240812224820.34826-15-rick.p.edgecombe@intel.com>
In-Reply-To: <20240812224820.34826-15-rick.p.edgecombe@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM6PR11MB4738:EE_
x-ms-office365-filtering-correlation-id: b32c2c15-8bd2-484a-e366-08dce33b83ed
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Y09FaFltRzVGMHNpNDEzSGwzNU95ZVVjNDB4ZkRjUy9QQWd6MUNIbjRZaCta?=
 =?utf-8?B?UFV3WWRiTTdxUlQxbzRBTE41bmR5UVpQaG9kalAvUGlRam0xSGk1SUw2TDZK?=
 =?utf-8?B?QjJuOVJvVnVmd1A1Rjg4NUFxSkZPOGtxTjgwUXRlMWhpNnFDViswWitSNCta?=
 =?utf-8?B?VUJhZWJWaExDUzdZNGgwVlVwbXFQaWd1SzZ2RGl0WmVSTExLeWxKTWI5WjlX?=
 =?utf-8?B?Qitzai9sWTF5dm9xRVEwWE1NOGxmOTdEKzhtMW9ld1dFaURzYWdlOVpYN1A3?=
 =?utf-8?B?dVZxNGh5U1JObk1INVY2QkdENnh2ZHNPS2JwVmd6REVDWXozRExNL0tiVU9T?=
 =?utf-8?B?cWRmOEFiZHdIQ0NUWGhlUWdOc1JkeWVSSXp2US9KVGN6S2ZWU3N2TStWWjNV?=
 =?utf-8?B?bWE0K3BNWTUrMnBlL3pVc1ZxYzI0M0NNdm9SQ21FOENWSmtPOWRBV0wzbElN?=
 =?utf-8?B?eEsvaWQ0TlFJYUEzK1hJcUlxcUhsdUVvZlBjc0drSWl3N1lKN1FHWklKUEJM?=
 =?utf-8?B?Z0VDZzB4b0tUb1UvMkp6U3VRVzVlMy9JZlkycVNMWFduQkh3M0lQVTBFT3ZC?=
 =?utf-8?B?VU5oVm9uVjBBSFNBRnBGVzZXQ25MdzZZcGVsaC85aHFqc0NubUVpdG9WUXFi?=
 =?utf-8?B?RXdnTmpCLzBsN3NzUHJuakl1ZHpGN3pkTWhsN21VdHJBbnlwK1cxbERZUGh1?=
 =?utf-8?B?amtKdnJiclZHcGxIZktDYk1vYlEycDNLVi9LVXpFZWJvQi9md0lNM2JDNExl?=
 =?utf-8?B?YjJabkRZNjI5SWw5QnZQS0ZjRWdvZDZBU1BxZVFiTEhzUEFrNGtFdVZFQUo0?=
 =?utf-8?B?YVF4dVpnU1VVRFNiNFlmNklZLys1bUZTY2l0ZDB3R1d5ejBkUjUyU1o0dWdh?=
 =?utf-8?B?QjhUSDVZbUt1SmFqc1lUTDRtb1liOVVUNkJyeUtudEJ2aVRsRlliWHNxQ1hp?=
 =?utf-8?B?Y2pqRWZOeUJGTXpuTjFwbUp6NkNiYXpkbjJENWxqcE02Y0NQUXFoREJ1aDc3?=
 =?utf-8?B?clNPbGxMRU14bVZpSmtrdEdlSE9jT1BRcHc4LzFSUzNWS2R6bEpvSVhWVm84?=
 =?utf-8?B?Q0lkdWd2YXExK3UxTmRqTnNwL1hodXdBOGJsVHFOTVdIRTU1Y3lKSUZNOWls?=
 =?utf-8?B?LzZrWnRGYUFxOVUwcXNzM2hNT25KMkRJRlB4RW4rcjdhUUU4QmtLNURGZ2xD?=
 =?utf-8?B?TWI1RXhqeGlLTFdSOXg1NnRDYW8xVE9yeHlETHNKV0RaQmVIRlRIYTU1d21P?=
 =?utf-8?B?bjVNVEpIUzdoNXRoMCtERVVDU2lUMUdLamxVNGptVlN0ek4xMlBMTjFKVFRM?=
 =?utf-8?B?eFBQOEw5aTdOOHBCNW5pN1RTSWVvRDEvMTljNzBZbXJ4dGFCck40bUpDN1lk?=
 =?utf-8?B?b1N1c04zenJsMGVlY2txQlhDSk5sL2tuSFp0eXd2NC9zQlQ3ZVd1eVJSN2Fo?=
 =?utf-8?B?bjhCbmpmUWIyUWRQSHYrWUtrSWxzSENWY1VrRUNiWlhmditaMGFWVlYxNElp?=
 =?utf-8?B?TGxDMFFiQzJ5NFloVk5HL1ZCaGE0dVFMN3hybXhJR09UdE93M3dMQWtFazJo?=
 =?utf-8?B?ek1yNjhidUE4T1ZlbFpqVjFweHZrbXY1T0NUNjV5UGxiUXdGcHhQbW9IUUtH?=
 =?utf-8?B?NFpnK28xaE1SYkRXR0QyTm1lOG0xSEMwcThxelpRN2RTOW9WVVBkcW1BRWdm?=
 =?utf-8?B?bTJNUE1Gd1FoMytPaUNvNExIM0xPQXgwdHlrazVFakViMGYxOElmMnVDa3cw?=
 =?utf-8?B?TzJtQkVWcXJNYzJzZFViU3VQMTc5L3RLNkdzN3ZFRVIrSThrU29mY0JCdUlm?=
 =?utf-8?B?YWNKTWZLbXpML01CSWN6QT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OGE4ZklIc2dTNW1jM3VwR3pDSWRtWldjNnhxbmJYRUJBNHVkTHE4aDZBVlZQ?=
 =?utf-8?B?cnNVeUJMblJMVU5ubThoT2dleEkwTTNFelowMVB4RWJZSUJyYlBEUmdic2Vs?=
 =?utf-8?B?bjAwQTFjUjl6SmVjWVAyWTR1dHR1VGdmYklsQmsyMGpTSGdVSkpMdUZEbUN4?=
 =?utf-8?B?RGczRjBNTEFWWEk2b0U2d3Z5OVRxT2dTYWtLUWRmZks3Z3JmTkxxQVBhNG5t?=
 =?utf-8?B?REQrOEZtU3haemtkTGYvYk41TlhCekcyYXFaWWF0SnNvaDg5V29lcmNHWEp4?=
 =?utf-8?B?a3Y0Tit4YzhOSEhGYVI5REsyYnBKSXVKRTZKS3o2WmJZTnVUWEVyMEtJV0JE?=
 =?utf-8?B?VjNVZ2ZWNjVIQ05mTG1XM0xSZ3g4eXJFdlMwN0RYUmNtald4ZDBsM3NrZHlx?=
 =?utf-8?B?YjNhSE4xQm5ZSWxpdEI2Nng4MnhEV216TVpXa25JN1pDSStPUC92ZzI5WE9Q?=
 =?utf-8?B?eFBTQ09oclhoSkpUSnJvd3JXcHhDa2tuZHlQTjhEZnAxdEl1bVNQc21lUkQ3?=
 =?utf-8?B?dmQ4UzZsZTYwSkswa2lEZUZTUlU4TkVlY2U0MmxFTDhSTHV2MWlsakR3OXZE?=
 =?utf-8?B?UlNvTUxBN2JNZGZmZkN1cVZONjJleitadFVxY1pJbFpxeHVlWWs5UmJoT29z?=
 =?utf-8?B?QjJVZnhROG1kMCtaeStEc0pqdFFKVVNINUhzTGNha1NyR0xwVUpwc2Jra01i?=
 =?utf-8?B?WGI1bmpyUnZWckpUVXZVVmd4OUxoR2hKSEpSVWhmSkRwSldnclZMRU1DWXpk?=
 =?utf-8?B?OHRTeFE2WUdhaUVMQ1UvRzFXR3NWU2ZMZGd2YlRVekQ1Y2FUTXhKblVpYzk3?=
 =?utf-8?B?UU5kNEJKVTBvTG9kV0hEbnVFSVVaNFBPMHgvQkt5UmdqaGVzL3RKaHVSZWF0?=
 =?utf-8?B?Y1pCMHg5V0tmdzBJc1NxeEh1Wk5UY0c0UkhWSUFLUmF6RW16VFFSMVYxTzlz?=
 =?utf-8?B?Vk5GUW5OMzJyUEptR25oa1EwaHhsK2hjZWpuVHhRRGNnbk94eHg1a0NacFcx?=
 =?utf-8?B?aVcxMWE4S2FuRTk5WWNQc0NwVG5vMXZOZmEvcG0rWlpreEU0OFY2dldyTkY5?=
 =?utf-8?B?aVNsZVloVWVTNllWOHBBek9acXlXTjRmSmgyVVdBV0lWK1NwUVF4V0JLczRW?=
 =?utf-8?B?WWhpeiszM2JMeExKKzNVc0d0SFJxTm1HSE12RVpZSlp0RGl0MVM1V1k5c1JM?=
 =?utf-8?B?alZ4SU1KNFl4aDFwVTAzZXRncFJBVWppNm92a1ZTVFBjblNXNUp3TElsaDJ3?=
 =?utf-8?B?RnN1cmNhUnBaU083RnlvSGpIY1JDVi96L3hzemFibkh6emVhSXpiWEZRLzFN?=
 =?utf-8?B?NDl0QkdoVFFNZmFBclFMMnhGRjdIR1JEK2pyNUx4ZUZmdlMxS281NVVrOERO?=
 =?utf-8?B?Z2p1VXFwd1ppa2dyK3A4ZzdmMU9YWncyWnpmQXFhUndwQ0JaUnp4bVdQbzdm?=
 =?utf-8?B?V05hc3kxYXBNMTNZQjZIT1lyYWJxSnZsQWxLTFNFKzhYM3dSeXlsdmFPQWhm?=
 =?utf-8?B?eXVXblptNWpCVmIwd2k1azd4b2ljM20rbU5iaDFFQlRxK2ZBMmdMdlBuSHZo?=
 =?utf-8?B?emdqTlpPNjdUVmpxL0tDdGVoT0dkWDI2QUhQc0lvWGhQZUZWZnZ4RGZzUzly?=
 =?utf-8?B?Y1k4UUxNaVNFS0RYMWhlTWt4UHREdE5KODBoOWRaMXBEeWNCdStWYkJwNmdU?=
 =?utf-8?B?NHNYenNONm1mZGVwL3BYdEY3RTNCa3RSWlAwYU9TWjdiYzh4VXhjQ3NuN1RG?=
 =?utf-8?B?V3RXOEJ1UkY3QlhTcFBncFpJSWR5T0NrRWZ1cUZLVlBNMVNLSjlLd3IzWitn?=
 =?utf-8?B?Zk80UHZLR1p6Y251OTNzbTd5eTVQeGtLNmI5UTQvL3JBRDJRWFZmR2liT1c5?=
 =?utf-8?B?WVprU29xTno2Y1VWclZxSkl2V3lDQy8xZkduVmtUN3F6bEZrZTdZU01WQjlJ?=
 =?utf-8?B?Qm1YaVJHNzFQUEZIR2NTY1BWeHNlUUtBY2FaUmZNendQZUVpMlNhL3lzTmF3?=
 =?utf-8?B?T1Y2cmFPb1RjR2pUNURwS0x0aEYvOGlBWGk1Qy9rN3lLSDJPR2o3OTdxd1BK?=
 =?utf-8?B?Ukx6aEZBMWpXVzQ0dE5IbzdYL1dveEFXMTZNR0dpUmhCZXhFSnlwVzVmQnk1?=
 =?utf-8?B?MHU1ZFprb2JFSnRpUXc0RXFhcHJnWUxoWUIwZFl3Mlh3YU5aekI3UElJVXF5?=
 =?utf-8?B?RVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B765AF37085E984EA10AA35454942259@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b32c2c15-8bd2-484a-e366-08dce33b83ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2024 23:39:53.5164
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SPN6llJ4K73GKn5+QJ7KDoPG+yKW95/n0DU80ldn4xrQwuO6FuR//1x9OE6QU9ggvkT/T3/18FZmrQ20hdt2rMziMpgd3BDuw4KVPebwVI0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4738
X-OriginatorOrg: intel.com

WGlhb3lhbywNCg0KT24gTW9uLCAyMDI0LTA4LTEyIGF0IDE1OjQ4IC0wNzAwLCBSaWNrIEVkZ2Vj
b21iZSB3cm90ZToNCj4gK3N0YXRpYyBpbnQgc2V0dXBfdGRwYXJhbXNfY3B1aWRzKHN0cnVjdCBr
dm1fY3B1aWQyICpjcHVpZCwNCj4gKwkJCQkgc3RydWN0IHRkX3BhcmFtcyAqdGRfcGFyYW1zKQ0K
PiArew0KPiArCWNvbnN0IHN0cnVjdCB0ZHhfc3lzaW5mb190ZF9jb25mICp0ZF9jb25mID0gJnRk
eF9zeXNpbmZvLT50ZF9jb25mOw0KPiArCWNvbnN0IHN0cnVjdCBrdm1fdGR4X2NwdWlkX2NvbmZp
ZyAqYzsNCj4gKwljb25zdCBzdHJ1Y3Qga3ZtX2NwdWlkX2VudHJ5MiAqZW50cnk7DQo+ICsJc3Ry
dWN0IHRkeF9jcHVpZF92YWx1ZSAqdmFsdWU7DQo+ICsJaW50IGk7DQo+ICsNCj4gKwkvKg0KPiAr
CSAqIHRkX3BhcmFtcy5jcHVpZF92YWx1ZXM6IFRoZSBudW1iZXIgYW5kIHRoZSBvcmRlciBvZiBj
cHVpZF92YWx1ZSBtdXN0DQo+ICsJICogYmUgc2FtZSB0byB0aGUgb25lIG9mIHN0cnVjdCB0ZHN5
c2luZm8ue251bV9jcHVpZF9jb25maWcsIGNwdWlkX2NvbmZpZ3N9DQo+ICsJICogSXQncyBhc3N1
bWVkIHRoYXQgdGRfcGFyYW1zIHdhcyB6ZXJvZWQuDQo+ICsJICovDQo+ICsJZm9yIChpID0gMDsg
aSA8IHRkX2NvbmYtPm51bV9jcHVpZF9jb25maWc7IGkrKykgew0KPiArCQljID0gJmt2bV90ZHhf
Y2Fwcy0+Y3B1aWRfY29uZmlnc1tpXTsNCj4gKwkJZW50cnkgPSBrdm1fZmluZF9jcHVpZF9lbnRy
eTIoY3B1aWQtPmVudHJpZXMsIGNwdWlkLT5uZW50LA0KPiArCQkJCQnCoMKgwqDCoMKgIGMtPmxl
YWYsIGMtPnN1Yl9sZWFmKTsNCj4gKwkJaWYgKCFlbnRyeSkNCj4gKwkJCWNvbnRpbnVlOw0KPiAr
DQo+ICsJCS8qDQo+ICsJCSAqIENoZWNrIHRoZSB1c2VyIGlucHV0IHZhbHVlIGRvZXNuJ3Qgc2V0
IGFueSBub24tY29uZmlndXJhYmxlDQo+ICsJCSAqIGJpdHMgcmVwb3J0ZWQgYnkga3ZtX3RkeF9j
YXBzLg0KPiArCQkgKi8NCj4gKwkJaWYgKChlbnRyeS0+ZWF4ICYgYy0+ZWF4KSAhPSBlbnRyeS0+
ZWF4IHx8DQo+ICsJCcKgwqDCoCAoZW50cnktPmVieCAmIGMtPmVieCkgIT0gZW50cnktPmVieCB8
fA0KPiArCQnCoMKgwqAgKGVudHJ5LT5lY3ggJiBjLT5lY3gpICE9IGVudHJ5LT5lY3ggfHwNCj4g
KwkJwqDCoMKgIChlbnRyeS0+ZWR4ICYgYy0+ZWR4KSAhPSBlbnRyeS0+ZWR4KQ0KPiArCQkJcmV0
dXJuIC1FSU5WQUw7DQo+ICsNCj4gKwkJdmFsdWUgPSAmdGRfcGFyYW1zLT5jcHVpZF92YWx1ZXNb
aV07DQo+ICsJCXZhbHVlLT5lYXggPSBlbnRyeS0+ZWF4Ow0KPiArCQl2YWx1ZS0+ZWJ4ID0gZW50
cnktPmVieDsNCj4gKwkJdmFsdWUtPmVjeCA9IGVudHJ5LT5lY3g7DQo+ICsJCXZhbHVlLT5lZHgg
PSBlbnRyeS0+ZWR4Ow0KPiArCX0NCj4gKw0KPiArCXJldHVybiAwOw0KPiArfQ0KDQpXZSBhZ3Jl
ZWQgdG8gbGV0IHRoZSBURFggbW9kdWxlIHJlamVjdCBDUFVJRCBiaXRzIHRoYXQgYXJlIG5vdCBz
dXBwb3J0ZWQgaW5zdGVhZA0Kb2YgaGF2aW5nIEtWTSBkbyBpdC4gV2hpbGUgcmVtb3ZpbmcgY29u
ZGl0aW9uYWwgYWJvdmUgSSBmb3VuZCB0aGF0IHdlIGFjdHVhbGx5DQpzdGlsbCBuZWVkIHNvbWUg
ZmlsdGVyaW5nLg0KDQpUaGUgcHJvYmxlbSBpcyB0aGF0IHRoZSBmaWx0ZXJpbmcgaGVyZSBvbmx5
IGZpbHRlcnMgYml0cyBmb3IgbGVhZnMgdGhhdCBhcmUgaW4NCmt2bV90ZHhfY2FwcywgdGhlIG90
aGVyIGxlYWZzIGFyZSBqdXN0IGlnbm9yZWQuIEJ1dCB3ZSBjYW4ndCBwYXNzIHRob3NlIG90aGVy
DQpsZWFmcyB0byB0aGUgVERYIG1vZHVsZSBmb3IgaXQgdG8gZG8gdmVyaWZpY2F0aW9uIG9uIGJl
Y2F1c2UgdGhlIGluZGV4IHRoZXkgYXJlDQpzdXBwb3NlZCB0byBnbyBpbiBpcyBkZXRlcm1pbmVk
IGJ5IGt2bV90ZHhfY2Fwcy0+Y3B1aWRfY29uZmlncywgc28gdGhlcmUgaXMgbm8NCnBsYWNlIHRv
IHBhc3MgdGhlbS4NCg0KU28gS1ZNIHN0aWxsIG5lZWRzIHRvIG1ha2Ugc3VyZSBubyBsZWFmcyBh
cmUgcHJvdmlkZWQgdGhhdCBhcmUgbm90IGluDQprdm1fdGR4X2NhcHMsIG90aGVyd2lzZSBpdCB3
aWxsIGFjY2VwdCBiaXRzIGZyb20gdXNlcnNwYWNlIGFuZCBpZ25vcmUgdGhlbS4gSXQNCnR1cm5z
IG91dCB0aGlzIGlzIGFscmVhZHkgaGFwcGVuaW5nIGJlY2F1c2UgUUVNVSBpcyBub3QgZmlsdGVy
aW5nIHRoZSBDUFVJRA0KbGVhZnMgdGhhdCBpdCBwYXNzZXMuIEFmdGVyIEkgY2hhbmdlZCBLVk0g
dG8gcmVqZWN0IHRoZSBvdGhlciBsZWFmcywgSSBuZWVkZWQNCnRoZSBmb2xsb3dpbmcgUUVNVSBj
aGFuZ2UgdG8gbm90IHBhc3MgbGVhZnMgbm90IGluIHRkeCBjYXBzOg0KDQpkaWZmIC0tZ2l0IGEv
dGFyZ2V0L2kzODYva3ZtL3RkeC5jIGIvdGFyZ2V0L2kzODYva3ZtL3RkeC5jDQppbmRleCAyOWZm
N2QyZjdlLi45OTA5NjBlYzI3IDEwMDY0NA0KLS0tIGEvdGFyZ2V0L2kzODYva3ZtL3RkeC5jDQor
KysgYi90YXJnZXQvaTM4Ni9rdm0vdGR4LmMNCkBAIC02NDgsMjIgKzY0OCwyOSBAQCBzdGF0aWMg
c3RydWN0IGt2bV90ZHhfY3B1aWRfY29uZmlnDQoqdGR4X2ZpbmRfY3B1aWRfY29uZmlnKHVpbnQz
Ml90IGxlYWYsIHVpbnQzMl8NCiANCiBzdGF0aWMgdm9pZCB0ZHhfZmlsdGVyX2NwdWlkKHN0cnVj
dCBrdm1fY3B1aWQyICpjcHVpZHMpDQogew0KLSAgICBpbnQgaTsNCi0gICAgc3RydWN0IGt2bV9j
cHVpZF9lbnRyeTIgKmU7DQorICAgIGludCBpLCBkZXN0X2NudCA9IDA7DQorICAgIHN0cnVjdCBr
dm1fY3B1aWRfZW50cnkyICpzcmMsICpkZXN0Ow0KICAgICBzdHJ1Y3Qga3ZtX3RkeF9jcHVpZF9j
b25maWcgKmNvbmZpZzsNCiANCiAgICAgZm9yIChpID0gMDsgaSA8IGNwdWlkcy0+bmVudDsgaSsr
KSB7DQotICAgICAgICBlID0gY3B1aWRzLT5lbnRyaWVzICsgaTsNCi0gICAgICAgIGNvbmZpZyA9
IHRkeF9maW5kX2NwdWlkX2NvbmZpZyhlLT5mdW5jdGlvbiwgZS0+aW5kZXgpOw0KKyAgICAgICAg
c3JjID0gY3B1aWRzLT5lbnRyaWVzICsgaTsNCisgICAgICAgIGNvbmZpZyA9IHRkeF9maW5kX2Nw
dWlkX2NvbmZpZyhzcmMtPmZ1bmN0aW9uLCBzcmMtPmluZGV4KTsNCiAgICAgICAgIGlmICghY29u
ZmlnKSB7DQogICAgICAgICAgICAgY29udGludWU7DQogICAgICAgICB9DQorICAgICAgICBkZXN0
ID0gY3B1aWRzLT5lbnRyaWVzICsgZGVzdF9jbnQ7DQorDQorICAgICAgICBkZXN0LT5mdW5jdGlv
biA9IHNyYy0+ZnVuY3Rpb247DQorICAgICAgICBkZXN0LT5pbmRleCA9IHNyYy0+aW5kZXg7DQor
ICAgICAgICBkZXN0LT5mbGFncyA9IHNyYy0+ZmxhZ3M7DQorICAgICAgICBkZXN0LT5lYXggPSBz
cmMtPmVheCAmIGNvbmZpZy0+ZWF4Ow0KKyAgICAgICAgZGVzdC0+ZWJ4ID0gc3JjLT5lYnggJiBj
b25maWctPmVieDsNCisgICAgICAgIGRlc3QtPmVjeCA9IHNyYy0+ZWN4ICYgY29uZmlnLT5lY3g7
DQorICAgICAgICBkZXN0LT5lZHggPSBzcmMtPmVkeCAmIGNvbmZpZy0+ZWR4Ow0KIA0KLSAgICAg
ICAgZS0+ZWF4ICY9IGNvbmZpZy0+ZWF4Ow0KLSAgICAgICAgZS0+ZWJ4ICY9IGNvbmZpZy0+ZWJ4
Ow0KLSAgICAgICAgZS0+ZWN4ICY9IGNvbmZpZy0+ZWN4Ow0KLSAgICAgICAgZS0+ZWR4ICY9IGNv
bmZpZy0+ZWR4Ow0KKyAgICAgICAgZGVzdF9jbnQrKzsNCiAgICAgfQ0KKyAgICBjcHVpZHMtPm5l
bnQgPSBkZXN0X2NudDsNCiB9DQogDQogaW50IHRkeF9wcmVfY3JlYXRlX3ZjcHUoQ1BVU3RhdGUg
KmNwdSwgRXJyb3IgKiplcnJwKQ0KDQo=

