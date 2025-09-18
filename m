Return-Path: <kvm+bounces-58050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89A40B872BE
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 23:42:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 41F722A03AC
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 21:42:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 448F92FD1C2;
	Thu, 18 Sep 2025 21:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j+Jb4+25"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C2E2DAFA5;
	Thu, 18 Sep 2025 21:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758231748; cv=fail; b=H9v9HS/8ZKQhDBUnPgeBFGTbuC5lXJaKzuCYGxR1LCTGFxEBkRUhGD+Wdhk6IEc5XDji1Wq0Jx55vxL4YUXyCFF+lBCJ9WRiwgsGbkD7em+sQOMGe+jp+iMaNvK+XSTktpvHrQFdCqncYIILt26DoJUk6lwo/Oukg0lxrxeEY30=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758231748; c=relaxed/simple;
	bh=4PSRDsBIbJ9jzkQ3VrbMkJZLwAlzKrr0Sk3HbGSeIIk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NciHYU5DBDYOHhenj0AbFpA7D3z6ODzVIK3l2hxLTmRRCAX/XQ7JydEiwEi93KI7HOPNHq/IX71kNOn5XRFqcNsZ/7zOJRXJ/FCFBckKPKMA3VPV9sVoRgfn5b/gR7c0Ltk1QxCQv1IQRk4MBDnVghJ77ZMfNRF54wSaB1vrSjE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j+Jb4+25; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758231747; x=1789767747;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4PSRDsBIbJ9jzkQ3VrbMkJZLwAlzKrr0Sk3HbGSeIIk=;
  b=j+Jb4+25WLmh6T/TWz5r162r7Ab7vCPHlHh/jykY6RI52zKG8TNQdIgG
   42sco8EhdDP1uAUTJ9e2M7eaCokc2k3ILBq+4TOraVuAtycUXpjGi8HtV
   Gs5a5l5JiKBepUM8bKIOBiI2fl+3QBmsJzYmw1MohGfx+RzHhEVfzrysc
   sirIeajkE5fZY6rsX65vYg0ExqNHW+M/l7slp1XU3reO+292RYpj9rcfI
   oUuDQ8j3SHlANRP8fbrLz4M2MABDmEphlJUYEW3LzPqxrJ2TXYJpFmTIr
   Upam+BoVvFqNjXEd7A1YFVPK7jIAjZ0YTSytyRLFNrfG642PDArtCQPMZ
   A==;
X-CSE-ConnectionGUID: oPFKUhA+R0ycfz3HzBC9jA==
X-CSE-MsgGUID: 8QUIZgcaSo6ckWIgxcu6JQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="60523546"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="60523546"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 14:42:26 -0700
X-CSE-ConnectionGUID: UZ0AzEq/Sk6ePBtFMKU3ug==
X-CSE-MsgGUID: KanG1nlJR1OEsGvJ3x/XAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,276,1751266800"; 
   d="scan'208";a="180946239"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 14:42:25 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 18 Sep 2025 14:42:24 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 18 Sep 2025 14:42:24 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.46) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 18 Sep 2025 14:42:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VfnxWqz6gqV+9VV73fdrF/GcJtsv4hjPUCGW+S8uqtjNzCyaRzJl0axXEP3EUYlHcWAbshikRYUnTnnbrQHRC8QM/k6KiOyS2o3Hu29BXzTf64U/puyNfryKbWRdkmh54MewIRi5HTH4I4JNeDzyzvGpxBwExVR42OnPSiQXzEEN9klpM/bMmi4Fz2czyyDlKdvt7vlIaJArUsqWvX0jvaQPUi84zjPdLu+yhMD98/X+epTLj5Ep2uxgEHXGO+KPVQN+cjwBQ12ZP/7xxrKtPO4xS/Lfwky/VM/ZcGWKQ4RpaLu6xKeAWIloP3sfs0I89ctr1f3UgxAVnqbeHtvb8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4PSRDsBIbJ9jzkQ3VrbMkJZLwAlzKrr0Sk3HbGSeIIk=;
 b=En4LszGApBCfqe77ScQBMeD2XyH7mR5UumssoMd7QRDma6PAZec73KMR2GLUNy+kX340Xrgbpb2LaTunfthWYi84Hc43YQbv5eu+NTCJQbQaE63N8R+zIYmmamQSEnOtsmCZSoTxgof0hqtfgF1y1HcfFeEA6CmI63aWyZ2Rm9BG4TXhXbPpGNFaX1bvuNJ4Yo3rTMi28VgOz12LgNuW34VG4eXfymQ3RRHPMD4ZugaXYqROpSO8GSF/j7vKgGvI23qYt+bUClhsG42gzXczfJqs1faBIMFkWJ2+UkDt/o9CEMI2sTHz9Q1iEbvwOjfYF9dyTqb9MKkY3edEEuHLZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH8PR11MB6730.namprd11.prod.outlook.com (2603:10b6:510:1c6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Thu, 18 Sep
 2025 21:42:21 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 21:42:21 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "john.allen@amd.com"
	<john.allen@amd.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "minipli@grsecurity.net"
	<minipli@grsecurity.net>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>
Subject: Re: [PATCH v15 29/41] KVM: SEV: Synchronize MSR_IA32_XSS from the
 GHCB when it's valid
Thread-Topic: [PATCH v15 29/41] KVM: SEV: Synchronize MSR_IA32_XSS from the
 GHCB when it's valid
Thread-Index: AQHcJDxrz3xGOm0mWkiTyxf0AvaeS7SWLnQAgAAQWgCAAArpgIAAEmYAgAAVbYCAAvB+gIAADMgAgAACsoCAAAr2gIAABUiA
Date: Thu, 18 Sep 2025 21:42:21 +0000
Message-ID: <c64a667d9bcb35a7ffee07391b04334f16892305.camel@intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
	 <20250912232319.429659-30-seanjc@google.com>
	 <aMmynhOnU/VkcXwI@AUSJOHALLEN.amd.com> <aMnAVtWhxQipw9Er@google.com>
	 <aMnJYWKf63Ay+pIA@AUSJOHALLEN.amd.com> <aMnY7NqhhnMYqu7m@google.com>
	 <aMnq5ceM3l340UPH@AUSJOHALLEN.amd.com>
	 <aMxiIRrDzIqNj2Do@AUSJOHALLEN.amd.com> <aMxs2taghfiOQkTU@google.com>
	 <aMxvHbhsRn40x-4g@google.com> <aMx4TwOLS62ccHTQ@AUSJOHALLEN.amd.com>
In-Reply-To: <aMx4TwOLS62ccHTQ@AUSJOHALLEN.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH8PR11MB6730:EE_
x-ms-office365-filtering-correlation-id: 926d53a6-a183-4187-cfa7-08ddf6fc3fb7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?Ull0cHZad3hIREFRdmN5QWhVL1FZS1ZtU0JOSitWTkh2U1FiZ3dmbHJXY0Zl?=
 =?utf-8?B?alo5Z1lpT0NCOW5icFp3S0MvbkFXeElZUngrMFR1d21jSmVDdEZPMW1RRk00?=
 =?utf-8?B?L0h2ZENRUnpwOHU0M2RHQ3FwTDMrY2JhN3ltcjBlQ095dVZQajlpYlhjRjNX?=
 =?utf-8?B?aWdEWmxCN1F4WGZtSW9hUy9mamlHd2JjbHcrRXB4MjZ4YU5Lam5sQ0N4QWdU?=
 =?utf-8?B?K0hkVTlESllBdW1YVXloTGIvR3U5NFRabGxHTG44RGN3eTZSZzZLb3NkdVNh?=
 =?utf-8?B?c05zZ3hNb3ZYWWJ1YitjNFA5MzlsQUlWZkxwQ0Q5anE2aTdUMjBCaER3cDVp?=
 =?utf-8?B?SnVNd3krdWMwWmlvNGRmSXRoWWZXYUlTTDRSYSt1elZ1UGRZR3VDUFpueURY?=
 =?utf-8?B?K2hoNFhsMkdpd0U1YnFxSC95YWs5YXU2Y2Iya3lNcUhyaUg3YzFvbllURXpW?=
 =?utf-8?B?MHFnQkJCa3R6T01rdStiVytnaDY5Z2R6Yk1EQTlkU3dpNkdQNFVEcW1hRnBn?=
 =?utf-8?B?VDMzM2luVGNLSXEzVmJ3c29OMDc1aHBrQUZrNFRNaEtXa1Y5d2hkTUVNWGNm?=
 =?utf-8?B?UW90TmoyS0RoSW85cUhiaURwR0w1WHN3Si9KNk42amYxM0Rsbk9qWllSeEM3?=
 =?utf-8?B?aWNJRy9JejY2NUdaR1ZkdTlac0ZQeHdmUmx6NmJvaXNNM21tRk81MkZXYk1B?=
 =?utf-8?B?c3Jtc2tMU3V2SG0vb0RINEE3Wkk5aGd6b0V6OGhiMGF5cDIyT2VhemVlQ01U?=
 =?utf-8?B?TFZ5azJGVThpSjVyM3VVNFgvS2F2T09zSmtFekRWc2lUbFJwbEdqbHozRDlO?=
 =?utf-8?B?UVo1c3lYTWdaS1Z5L0tNVU9PY0ZDa1c0cE56L3U4bEhFT2lqOU9JYXBZOEVZ?=
 =?utf-8?B?R0NHRTdsWDZ1RXhIZExvaTcvTU5QakZKQU9tU0N4Smo4NURaSldsWTBLMzFV?=
 =?utf-8?B?QzNLYnBBbmpyMDNtNXdRa24vbjk3bGtoUjdmK3lCaVlFTWRuTWg3Q2JVMk5o?=
 =?utf-8?B?V3h2TGxKWmxuWlBMdGNXSGhzK2NETmJiNWp5SzdsdjZRcXQ5ZVhtN0NseUNq?=
 =?utf-8?B?Uk5GUng4eGFIZVk2dytyamlKTlZHNFgwQzY0UkZXMkpTZFNLRytRajFNWDJ6?=
 =?utf-8?B?eXVLNklndlRPbmZPa1R3M2Q2SEI5M2dsRDVuNUZUVVRFSWVmSmJGM3JSTFUx?=
 =?utf-8?B?cjB3OFBTWGh0ZnFkSjVBeDdFTVVZU1ZXTXY1N2hFS041RERSVEdtQUZTSStw?=
 =?utf-8?B?OVVOYzJGa3BmQ3pFajYwdXgxY1VZaU1SWjNmOGgwMDRiQy9SZ2pPK2s3bksv?=
 =?utf-8?B?QXV2VittenVRMTdtK05BSy9hMmNWaU9IZWk2ckJkU2RXb0h0VEFGVUNJZHlp?=
 =?utf-8?B?L05yMDNyaEIrMFBPMzd1ZzNabzlJQ25VVFVWZi8vNDd1OTQ2bW1CT2VTRXVy?=
 =?utf-8?B?T0NWSFlxL09XczhMRUFaekR2YnFuMDJqUkRnTlRxZWQvZVJra054L0psazhr?=
 =?utf-8?B?aE9jczlwK2ErV1JmMmd0azN3WkxUZytuZDc4aFM4Q2FEYWUvQ3NOb08yMkY0?=
 =?utf-8?B?UFRLRlNkMWV0dUFvSGVFVXBhczBwZC9zNGVDRHV2dm9kdUw2TVAxcHExaDd5?=
 =?utf-8?B?VW5ETFBURFZXSWtpY1MxVmN5VERCakdoOVF1T2VzZlVabm41cTFlQUF3eEh5?=
 =?utf-8?B?Y3VqUVRZUDZaQmIxMHJMUThCaTZIdU9GazFlMjgyTXdUZ0JYL042WU9OeEhN?=
 =?utf-8?B?b1UrWS9qVlliNkZwNWw5aStSOGFidHJlT2lva0Erc1g1emtFL3pGbWNPa08z?=
 =?utf-8?B?MFhFK0xabFJqT2JKQmZPNWVzZTh6NEtOLzZ3L2ZWQnY5cGZqNlVKS3YxZkpn?=
 =?utf-8?B?a2F5RVUwcUpGTFZ4YnJFRWVtZGNMTDdFN25lalVGK1VYdWFsVjBZeWduM2la?=
 =?utf-8?B?UDFIMTBVRWtwRC9wUU9nVWkrTXJkUUxJUmhuNmxSUy9pam5jaTg0ZDdjTjVQ?=
 =?utf-8?B?OUJEenFjSHR3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WHJlbm9oTEZNVHZSQXNsdWtTTG5TNzg5Njh3YjZSQW9qQkFqYWU2Sk1aczE1?=
 =?utf-8?B?VEEwVFhuc1RURkEzZkh0cW51ZkM3WWFxd2x1NkM4L3RrWEpPK0V5N0RmWFJY?=
 =?utf-8?B?SXRMTFc5Z3MzVXh4eER1VnpLM2FPNSs4TUFlU1hlbUV5VVFob0kyMTR5SmJ5?=
 =?utf-8?B?bmdhMzhrNi9HL3lDK1NTREhJNFFXVXVvQ2RVYXJ5eDl4ZXV6RVZ0bWRzYUlQ?=
 =?utf-8?B?RDVnUExvM05wblJVbDE3K3R4cHFsMzdlMGZXdzNKUWFZaW5LSzUxcnVZTExE?=
 =?utf-8?B?VDU3T3FFeGYyUHR4d0pvdTRKNWZmV0k4MXI5QXNrczd0dXNlczZiZURObk1k?=
 =?utf-8?B?UXVFclVqRmd5QUFkdkt3M2puS2hMUW5lSWdlNWZNWklIZXRCVHU0NTRSQ3lC?=
 =?utf-8?B?Wk81YmpjVXhVR0V6YUxtOWMyMnZXUndWcWJ1cGVrOHdnVUljbVpKMkdZMXJC?=
 =?utf-8?B?RElSK1pEYnZFUVU2dFB2OVc3V2JnUkhmZ250Y0JxbFVJWFhmb2xMMEpycTRP?=
 =?utf-8?B?K3lDWWhRTVI1bEl4MTQzOFNMTUNTamN0bFgzTDFGeFIzME5ibit5bDJkMVpx?=
 =?utf-8?B?OGJNcEJxMEFaZ1N1amxTTEZmUm5ZMHBYYXRzRmhHYzc3VkVOMXl0akhIaUdN?=
 =?utf-8?B?OTZtYWpEeTNsMVNObzl1bEJNQkc0T2RJbGZEd0RiQ0hMajdDOXd6a0ZEY3hI?=
 =?utf-8?B?eVNRVU1oc1NJL3UwcGJPR1gxMjBPYXFHNmFDQjltQ3c1d1NWakFhaDhac0NH?=
 =?utf-8?B?elFFLzhZb2o4dWV6VnJhcDJNNXA0dE4vTU1FOGFLSGZUK3VSMEJUNVNPKzJ3?=
 =?utf-8?B?T3M0QVZLSlhIcTFMazVzNlZJUVAxbU1SMytkRldjQ2gyY1Q0c2ZXOEVYU3dx?=
 =?utf-8?B?bkVQMjJyNkQxTVlTUEtvVG9waTBlTHl4VVlOaks4Qk9lSjVmN3hBMjl0MU1Y?=
 =?utf-8?B?UHRvaldYaWtlNGZDaWV6Q29FQWRrN0Q3MEpkU2c0QXFwOFVKcHVwVCsrSTBW?=
 =?utf-8?B?M09RWmMvb2FualllRjRiN3JaYWozcDAxUWpjUk9IU0RvSmJUYU42RVV3S0s5?=
 =?utf-8?B?M0RXckg0S2Q3OEN2RGRWOXBFQ0xTQzlmdGE0NDc4OTgwSHRUZ016VUd2Vnl2?=
 =?utf-8?B?VHVsQXJrS0gyd05XMlZZdUtjaS9RdmRtZW8xMlJuYWpYdEhJNGJKWEdQNThy?=
 =?utf-8?B?bGdQQzNIUmNvN2M4YW12MEl1aDRtcmhjRmJ3TytNTWVEbWZuclVCV0Q1TVBn?=
 =?utf-8?B?ckF3U3ZIaHBCWFRKQ3dGY1NBTTEyVVB0a201MDdLeXZBcTJqOU5ZOFhCUlJL?=
 =?utf-8?B?M1V6MHRBNk9QRlBnR2h1VEVNTHhsZjdPVVBFYkw2NTJzUVhVelNab3RzT0Rj?=
 =?utf-8?B?RjRNM013QnhGbi9TcUQxRmJ0K1UzYkVpN1UrVVVubi9leExEblpSdUxiNytp?=
 =?utf-8?B?eVB4Q3M3S2JpRHdkTmUzY2QxWUJVWHB1RmxjVzR0TWR4a0owa3h5NnpaR1B4?=
 =?utf-8?B?clMrbXpGRy9XN1RlUzFLVkdRSzQxYXZJWXNTRy85ODR4SDg3Nm16UGNTbDVE?=
 =?utf-8?B?bllqY1JBSzVubG5VRUtrZXcrdktiTFRSSitWbjE5dGZpTmpIWEFBckRrajVv?=
 =?utf-8?B?UXBaWjh0dHVqSWo0YTZmNnZoZk8rdWZDdDQvbXFKVDByeW5MM252d1o0Z25i?=
 =?utf-8?B?aGRsLy9RSlJtNlJGbXQ3SWRoVVRPdVRZTkszSlcxblpJNG4zU1BDVFRTcG1C?=
 =?utf-8?B?WGkxNlFleUZBSFpyM0NMRjRMa3lKWm9pTmpPT1hXekpyUEo5NlBQUytCOGhj?=
 =?utf-8?B?cUhzNWc4ZER5TzRPV3V3VmRKcUxTNGdzdE81YWxHc2NkRlhuWGR3RUdJa0R5?=
 =?utf-8?B?NVhWYXBreVZOQlNBRTRiZUx6akEyT3VncS9tYkwyNml5WFJZdUNONTZ0YTJJ?=
 =?utf-8?B?Lys3QUxmeDdJKzZQMTFFa2NzamNZUENSVmtFYXBjbUkxQ0N2UW92cldZZXpu?=
 =?utf-8?B?a1VzNG82Y2dXbFpEaW55bkk0VkRId1BCc1MvYmx3VWczRm0zK0pRRmxhb1BU?=
 =?utf-8?B?cDdCMC84OEdFYjhJdE45a3RWZnJyZDhxYXZTWDgvWmk1VmlWK1ZJNHB3ZVF1?=
 =?utf-8?B?Z2l2c0xveldKVEFGcTJPS0lYM0lvQXFjcmQ2Ulk0R1BCRUUvWnZZaEN0UE9i?=
 =?utf-8?B?Y0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4F1C92067CA56A438FFAA7A248FFE93F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 926d53a6-a183-4187-cfa7-08ddf6fc3fb7
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2025 21:42:21.7037
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f5ZdBCzbdGblfAb3NO1oARy7gWe0Rf/aEYFqVbBa3SNjhqlc3FiMO3C18nAB/ozP868zCP36LO36qguwOejHazFVr+3RA9b6vixnHXrYAd4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6730
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA5LTE4IGF0IDE2OjIzIC0wNTAwLCBKb2huIEFsbGVuIHdyb3RlOg0KPiBU
aGUgMzJiaXQgc2VsZnRlc3Qgc3RpbGwgZG9lc24ndCB3b3JrIHByb3Blcmx5IHdpdGggc2V2LWVz
LCBidXQgdGhhdCB3YXMNCj4gYSBwcm9ibGVtIHdpdGggdGhlIHByZXZpb3VzIHZlcnNpb24gdG9v
LiBJIHN1c3BlY3QgdGhlcmUncyBzb21lDQo+IGluY29tcGF0aWJpbGl0eSBiZXR3ZWVuIHNldi1l
cyBhbmQgdGhlIHRlc3QsIGJ1dCBJIGhhdmVuJ3QgYmVlbiBhYmxlIHRvDQo+IGdldCBhIGdvb2Qg
YW5zd2VyIG9uIHdoeSB0aGF0IG1pZ2h0IGJlLg0KDQpZb3UgYXJlIHRhbGtpbmcgYWJvdXQgdGVz
dF8zMmJpdCgpIGluIHRlc3Rfc2hhZG93X3N0YWNrLmM/DQoNClRoYXQgdGVzdCByZWxpZXMgb24g
YSBzcGVjaWZpYyBDRVQgYXJjaCBiZWhhdmlvci4gSWYgeW91IHRyeSB0byB0cmFuc2l0aW9uIHRv
IGENCjMyIGJpdCBjb21wYXRpYmlsaXR5IG1vZGUgc2VnbWVudCB3aXRoIGFuIFNTUCB3aXRoIGhp
Z2ggYml0cyBzZXQgKG91dHNpZGUgdGhlIDMyDQpiaXQgYWRkcmVzcyBzcGFjZSksIGEgI0dQIHdp
bGwgYmUgdHJpZ2dlcmVkIGJ5IHRoZSBIVy4gVGhlIHRlc3QgdmVyaWZpZXMgdGhhdA0KdGhpcyBo
YXBwZW5zIGFuZCB0aGUga2VybmVsIGhhbmRsZXMgaXQgYXBwcm9wcmlhdGVseS4gQ291bGQgaXQg
YmUgcGxhdGZvcm0vbW9kZQ0KZGlmZmVyZW5jZSBhbmQgbm90IEtWTSBpc3N1ZT8NCg==

