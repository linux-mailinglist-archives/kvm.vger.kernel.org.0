Return-Path: <kvm+bounces-72597-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AO6+NAY8p2mofwAAu9opvQ
	(envelope-from <kvm+bounces-72597-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:52:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E01F1F6691
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:52:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A66F0304890F
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 19:51:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FF7D386575;
	Tue,  3 Mar 2026 19:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lbmwGX4c"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F3438645A;
	Tue,  3 Mar 2026 19:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772567509; cv=fail; b=AJOJXorHoWNgb41Qi4R0sBUSsq+m6FPuurwzdShoURyrXxG0rOg3D69AL4uRckHknhopOnAZjsCaJ/CK9LCpPpQcB2O4l75RLcR5TP3vB9Snel7d+VIGdj3jKtBcPNvTjw8ltGYno5RfSaDK3pCWGPKcjpqqNozTBTGoDyjRlUU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772567509; c=relaxed/simple;
	bh=vMZyHTo9DTGDroB2c/bVAu/13BvvlyEsdF/58/xoD1k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LfBYDXxS+GGHP1QgNqoYCW1t9nb4efAknLfclVNXxxbiyb5tI6S+1O0HPjjyzgJbNX2cuwwbNZ/4pry97Fonei3Wq9ppwfcFYbZjYznXK+j44DGnMt5OkOFCEEhPpz0KTYHOAsyUIwAvDVXN+N5OJMrBlbcUgGclQW7U9+3W/IA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lbmwGX4c; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772567506; x=1804103506;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=vMZyHTo9DTGDroB2c/bVAu/13BvvlyEsdF/58/xoD1k=;
  b=lbmwGX4cahx/jd+Pclwlb71IV8FPSoWKGNl2hsIODn9eiSpxQi80VYI2
   wrLeCIAUczFg9Mfkx6eVPR85dwCtLpsEsJsglvfPf0AjTBZ58NF9RF/qq
   dJiuKhGW9f2wnRgye8EE4/bXTbUEsG49v/G0OJxEOMSgPC8H+ATHKbesE
   H8qmMGK/yfG6Ep7HCOjH/j7bWRje6QdhveEUA3M9ivv8L8NysbRBebnpp
   MolL1UZhOV7Vj7jcWRnEdAzKtoQu/IqMaZy3ZhQ30qLuMjI6/XWjxIada
   V+H/fGRO+j27Y7ZI/UucoivC97/FTAgMd9Z7SO2OvrNlEuDJGJtDchw7/
   A==;
X-CSE-ConnectionGUID: P8hQgZg1SR6lB62a1JMSnQ==
X-CSE-MsgGUID: GWGMdeR+SGumRZYLUjPpBw==
X-IronPort-AV: E=McAfee;i="6800,10657,11718"; a="99094783"
X-IronPort-AV: E=Sophos;i="6.21,322,1763452800"; 
   d="scan'208";a="99094783"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 11:51:45 -0800
X-CSE-ConnectionGUID: ceiM1MdNShO2bmGShgTXTg==
X-CSE-MsgGUID: ToJIiuk0QrSy9SUWCkwv4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,322,1763452800"; 
   d="scan'208";a="222771645"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 11:51:45 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 3 Mar 2026 11:51:45 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 3 Mar 2026 11:51:45 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.38)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 3 Mar 2026 11:51:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mCV/YM1UpVn+/zy2wRmP1gfEdo36AG/9jqv3s22nxQeBEWnrtOHgH992pkFZeSdLjNB0wO1Xw/qugNESYhcqvt0BJf0wh6ElbaSIbWvttBc0x3irgK767zowAG17n2Ygv5tNHYuy/ZjhWIi3/bXu1dCkCCy/sKqvjcFwllvllbt1cZgy6TOdyLc7ksn03eMJdUd6y3YaqKIV7XJeKYhypEAPK50hei9E34GnwrsvKL6QZ6GR5QyA8XnCcz4BiU76S4xjrQlXWFO+W8qXLu20VlOApSATJ7vym+/Esoi08e83+4tSikZbvI2UZwPnA89mmG0v5nfXyRGl43nMmSvlVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vMZyHTo9DTGDroB2c/bVAu/13BvvlyEsdF/58/xoD1k=;
 b=QI8TN/R4IojziiNjkNtex5XF1M6h+1HYbaXprr8j92fn0BcTqTdNPOpDPjZKwrixbx9tDeAmY+3FzZza+wmb7pZen+DRYDvMh9F1JKmyk9VtMKttUhlftvjbfV9H25O2WdgQIN9A0clBhxZuQKcgZq79HCgdo67u2pdezr/3ETmCpMT0qdmK99Gx/sD+N+6DnX7CzUkjh4zh7iR+bykyC4Qb/Y+S5YVmwD5X7OEiATIxv9qMF6Srefil0S3f86Qgra+qsC1nQ/J4HALijn/yQKUR9/DjcEvIq4QF3vAEk+d8UETRucQNi7kp+x8rmE05UYdpK4xTnE0BBRgRiWidBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by LV4PR11MB9466.namprd11.prod.outlook.com (2603:10b6:408:2e3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 19:51:41 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9632.010; Tue, 3 Mar 2026
 19:51:41 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "x86@kernel.org" <x86@kernel.org>, "zhangjiaji1@huawei.com"
	<zhangjiaji1@huawei.com>, "kas@kernel.org" <kas@kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
Subject: Re: [PATCH 14/14] KVM: x86: Add helpers to prepare kvm_run for
 userspace MMIO exit
Thread-Topic: [PATCH 14/14] KVM: x86: Add helpers to prepare kvm_run for
 userspace MMIO exit
Thread-Index: AQHcpfUVg+RNJOrOv0Cmb5EAu8jOw7WTrZgAgAAexoCACFFegIABHFsAgAAGNgCAAAIWAA==
Date: Tue, 3 Mar 2026 19:51:41 +0000
Message-ID: <5ebc1980aca745652b34cad4b7ca3decfc7f0a90.camel@intel.com>
References: <20260225012049.920665-1-seanjc@google.com>
	 <20260225012049.920665-15-seanjc@google.com>
	 <8bed2406e9f5f30f8f01c1da731fae6e040da827.camel@intel.com>
	 <aZ9MDxJ1iEhIbJJ6@google.com> <aaZGTY3CzhaCb1lc@google.com>
	 <4574be9a29d75d565e553579ef6ce915ef33b19b.camel@intel.com>
	 <aac6DGISvMX4krhb@google.com>
In-Reply-To: <aac6DGISvMX4krhb@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|LV4PR11MB9466:EE_
x-ms-office365-filtering-correlation-id: 58e4cf22-2236-486b-56c5-08de795e4a61
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: KtgzjkbifJGRD141xHqBbHwSwaKGnjZZ0b2cFEPKS0mthwX5jdUQ5aFcX4HGGPmqAVFtAgjUg0iu1LRbkXRUzGTr56u1zEtOGAW0unLBhfwjJTLPLEaP93Yq0Xh2CwqP5PEN+oXhqDpnMrvXvloyL+us184CYaOfN77fMK9We4ZwLiHuG3LoGDOooscpjUc38hMLeAXmMSuzswcaVMNyWV1vxkKjaw94/tR1dCtZE5INcKyfSZjT4X6hHlRV+1P6IFaTWkvJMpLcS4leMQ9uTBcNdb5ayHNGWJhX/7l2KeF2+caNg93sUBp9NP2qdvhtu+OwLBrylyiX3PFACX4UTIc1SahEZTgdMhjlJx0cPkxyhxMTiCX6uvlP/L0Dc0sLVfTO5XJqyvvhdOjb0bGUDNCFuN43e9aOoOplAGJM4/uOu82z/UsH3ExYsMunRwvmRIGl7570mYXHErTU4863ToysbWR2iv5YEodNkzQrL9IF3h9QaBQDInTk+JPA56dazn0fTXl9MGiWe2OZc9W4VAxJfibD+ZJzuLd6S4fJ7J+1voe2MKlHEQPm6KtsjNVwvgjMcXqaOPSkpP2TI0xoNPd4aYX3p5rgQWMt2Zyxp/eWhe+Bpi42mHbESYeuM56pAjRLORjWuPsC6Ij0tRUFhpfREbUtu4rsdUiHNHfiQLdERYxT5bZxMVIDCYL9vYXJU8gltwZl5VWsZEOeU7QPrITSEyIh39o35g/f2fXHuuHEVpVcz2UQSAKgnUzuzdqGP9ea0wpPK8SrtVIzghaYRhj7pO1V+/u1MUrMUNs+6ZA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Vi9PbGpKODY3Vld1LzRRcENnNmFqTUlUdWQvdTNwTXRCQUlPUnZsbktHMFBr?=
 =?utf-8?B?WG1yUmdYeTMvcTFOVDNNL3ZXM0dyYnBtSEw0MTcwZkxoaDNUcFNtdzVNT2Uz?=
 =?utf-8?B?TTh2QzB5Y2REelRpWllML3NrRlBnaW9TaFBUTnJGV0JaTUhLYWVyTHNwQXlm?=
 =?utf-8?B?MDVWdUtjZnBUMk1XMkhLaVlJNE9pa1RrS0pQYmIvRUQyL0VOT3hjd3hBUmNi?=
 =?utf-8?B?Zjd0RWRlUmFYN1c1V003RzhPaFFRZ2gyMkFJQkg3ajlZK3duNXNzOERNRGlN?=
 =?utf-8?B?aXR1VGdYYW01QU1PYlJZNFBuRVVTSWFqekFkTnMweWljR0VQVDM3Ri9FRjJR?=
 =?utf-8?B?dmxlOVpmZUFjN2E2WlU0UlhjOFRmWjRkQ2xxb1JsbDRmcFNEVjJzZktPVVRS?=
 =?utf-8?B?QlpwNkxhaS9kTkJ0Q2RIenQwUFlmNW4xYVRMOHBBcGtTY3I4TlZTTmwvckxH?=
 =?utf-8?B?eUdwaHNUWEVHRytNSGNIbVQwN2dEa3Fmb280NkNMTmJVZThuTlhwMkxrbGVE?=
 =?utf-8?B?V1Nna01ONFZGYzlDWVJ4OEhzT2wwZUlQdEFVTjY1dE9XdFo2WVNTK0hRNHN3?=
 =?utf-8?B?OXRxVFhQQjNodkx3bnA1L1p3c0gvMk0vcGNlZFBZTENiWFdmOEU1RWdXYURo?=
 =?utf-8?B?MWxrMWwxcXUvUG91bktMVnhnbnFwUEtaYTF5OUhXYjhwVlpPMHA2RUcrb3Zn?=
 =?utf-8?B?THRSclZmZzVQcTFsditSNnBNUHRWTFRPTklOWWJCdVJYL3haY09uekFLN1Ri?=
 =?utf-8?B?QVY2NU9DQUpsQnNQWStMRDJYVXlZY2N1MGdlT0NORXh6UUpxTnZKbTk3Ukt4?=
 =?utf-8?B?ZE5mMjZhb0w2eGphVUp6RUFBa2NkaGhJV1RtR1VpeUJoUERQUitkYU9uL0N0?=
 =?utf-8?B?TVNIWmM5Zk5Yb0h5YlIwenZ1VkhLcUpvenhyTGxwZkc3NEJSd3BqaW56c25U?=
 =?utf-8?B?NnJIUWZMSVMwVWtrRzBteWI4a3F1WFJwc1pVaXAvRFlmSEVYMXEyM1VuV0Y1?=
 =?utf-8?B?NWhybVgwcDNXbjZuRWhqVEVFR0lLU3JtUC92dXczbkFKZS91b05Qd09BeUU4?=
 =?utf-8?B?NGY3MTZxdytNVFJzUEV1clBjQlpqaVY2cFZ1NXdiMHh4cWo5UHV4NXNBWDJQ?=
 =?utf-8?B?enY4aFIzWTNjWnQ4dHN4U3M4V1EzbGpFRXM0T3R3QmlqNVdiSGM4ZHhjT05I?=
 =?utf-8?B?NFE5QzRGWDVha2pYY2pkQWNvbEdvcW1lN2ZjSi9yS3lPTnZjRnlsa1ZsT21s?=
 =?utf-8?B?bFgvSDVkVVp6YVdxdUhQUE9yTGJQV0I2ZG9VMVN5Q0tKK0Y1MjNrU2tGNVRy?=
 =?utf-8?B?Z0gwNHNzdmdVRWhVTElPRmxuMStmKzFQTGhlWTN3ZmRVZkVKdldtRjRYQ09s?=
 =?utf-8?B?eUhwWlhOSG0xVWNtMlFMYnpyRnRqU0xsOE13MFVYVDR0cFBJcU85dTZ5L2kz?=
 =?utf-8?B?WUVyQ0tJVEVZbmZMR1RjelAvWVF6a2pad0pFNXpibHY3RUd6SXdMcm03bmFI?=
 =?utf-8?B?UXJoK3dCbUU1cW1wcVhzZHh6b0I3WjEvSnhjdEFjaEQ2TFNMT3l0QnVpbFNo?=
 =?utf-8?B?cTh0c21BTzl3cVBQZnlxK3FSLzI3SSs2UjA0VXpNVC9hd2tSUFBaNEc5WVNz?=
 =?utf-8?B?Y29Ndi9PUnc5bXZBS0tHaGFJZG5INVYvNlZOL1BleldickZMMVFPU2I0VW8w?=
 =?utf-8?B?WEg5WmRrZ3ZNcm1TUG1XUFNsMFNUMFZOM3RQZkFZN2ZXM3pYWUxWS1lFS2hn?=
 =?utf-8?B?M3hPeE9YUGZTbmdOSVF6eHcvcXJiSE5ZOWlURVM3NkNJM0ZOQ2R4VVVXOUxz?=
 =?utf-8?B?aGY4K0pBeGVvTEl2V2RZODlWRVBHNzFkNzU4NzNsVDhWRThWMGZhS21WUDZM?=
 =?utf-8?B?L0hFalp4MkJXMURZMFRkd3dLczFVV2U4dUg0MVc0ZUJFR1VhVURmTUg4OEcz?=
 =?utf-8?B?N0ZUbjE5NGxIRmUwbUdzang2UFcya2pXQWFYeG4zRVhSbk84RW1jTncwNEJw?=
 =?utf-8?B?OEVGcHgwQk5Id3BzNGlVcHB6VUx5SW55ZEFPL043QStYRU5jOEl4RUVObXQ4?=
 =?utf-8?B?WWplSVV0dTREUTU0THhkcmNHRktVVE9HWXFiMG9pM0V2alFRbmJmNHlDUlVm?=
 =?utf-8?B?a0l5Y3ZTN1VFZEowWnhhNmpIOTNmMDZ5bkduaWozMXJkNmxwQU1SWGFrQ3da?=
 =?utf-8?B?YjN5QnYrUFM1VFNrb0dKaXlwMXdIdDBLeExLN2dGUEpsUGF6WFpCQ1dRd2po?=
 =?utf-8?B?dlM0bjRxN3hWdWFZbm1LVW5oQTQvK1BGQ3I0NVJYaDlBR0cwUXV2SzA1WG9D?=
 =?utf-8?B?WCt3amZPL2VTUXNpWUVxUU1rT1NpZG1qUkxubHMwS3JQZmw0ZnRzc3ZSQnN4?=
 =?utf-8?Q?B5Y7NRPW1uGFOV7U=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3438B4F483D22146BB245C369DD2BC12@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58e4cf22-2236-486b-56c5-08de795e4a61
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2026 19:51:41.4790
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mD+yVyw3bW0JUoagoGfZnA3+6ASkCWT5ipzMzjWiHzPKJJpo4SNiPEo7/H90OzYA6L5GqF1yIwJRMlEddQ3ansu9lW65g8S7a7oA/Lf3BsM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV4PR11MB9466
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 7E01F1F6691
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72597-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,intel.com:dkim,intel.com:mid];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Action: no action

T24gVHVlLCAyMDI2LTAzLTAzIGF0IDExOjQ0IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IA0KPiA+IFNlZW1zIG9rIGFuZCBhbiBpbXByb3ZlbWVudCBvdmVyIHRoZSBwYXRj
aC4gQnV0IGxvb2tpbmcgYXQgdGhlIG90aGVyDQo+ID4gY2FsbGVycywgdGhlcmUgaXMgcXVpdGUg
YSBiaXQgb2YgbWluKDh1LCBsZW4pIGxvZ2ljIHNwcmVhZCBhcm91bmQuIE1pZ2h0IGJlDQo+ID4g
d29ydGggYSB3aWRlciBjbGVhbnVwIHNvbWVkYXkuDQo+IA0KPiBMT0wsICJtaWdodCIuwqAgOi0p
DQoNClRyeWluZyB0byBub3Qgc2V0IHlvdSBvZmYuLi4gOikNCg0KPiANCj4gRGVmaW5pdGVseSBh
IHByb2plY3QgZm9yIHRoZSBmdXR1cmUgdGhvdWdoLCBlc3BlY2lhbGx5IGdpdmVuIGhvdyBzdWJ0
bGUgYW5kDQo+IGJyaXR0bGUgdGhpcyBhbGwgaXMuDQoNCg==

