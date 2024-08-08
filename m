Return-Path: <kvm+bounces-23618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 13D5594BD2C
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 14:15:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 91B781F21422
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 12:15:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 715DA18C924;
	Thu,  8 Aug 2024 12:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QnI7/ApI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813991487E1;
	Thu,  8 Aug 2024 12:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723119308; cv=fail; b=No/v+cuaXPceG/i99VFcXKJ2389OIqx8EHyn+p06Dxr/2T+Y/xDzhRba7I0GSTIVNuU8NrfzM9zrrswVZk5zwixbmC0rHUFr1tPaS5FnqEVi/yO+5HkZ4Zyv1IPXadOOmMjzHLSlfVpckLk9d3KBUq2pHF06FYSIzuaFu2VGXGs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723119308; c=relaxed/simple;
	bh=k3o1mA+/AspQf9JZFMdkft/32USsL0aNLK8YQyaiJzU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=V8DPE7x5xxe18HEDEl4EZilA7qM+K+fY34KWK7LF+Q5v5CDtvGzutJCfzHo9t7XWW7mZDuT3c0x8mH1MTcNjqWgVUmnsvg6z4P+owycVD5QYM2sD5hUHeP1UiCzzn1i3Th/r/s/6S72S0TpMjAhQhU01myOuzknd4VLwgxp5j30=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QnI7/ApI; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723119306; x=1754655306;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=k3o1mA+/AspQf9JZFMdkft/32USsL0aNLK8YQyaiJzU=;
  b=QnI7/ApI2Ka7Ixait6i26lNWiZa4DhPBNKxLcNb/OTzNppqsLoLRnsa6
   tTDX2GU9+LBTsD+pF9i80BghQLDYUYLOAztOspotZc2q6AUzBkX2ol6M/
   3vFCSdxeXBmC9GSJtgRVNORgOKnrsP3TVxK3VepN9Ig4tWcHPucLTGeqL
   OARrX/8ECXDa8VlFF2H1yPC1dGuQSfdwAu3rJmO50QJTf0RzR3Jyo5Rt0
   7/Idx/KRL0tma9tyMqlU0DA7eSVTTd/+JymfwP6oWMekyVLxCgsCGM9Zt
   nBmB6L9MAq5m7ljnTwCcLjtuCr06T/7fx/LYQfR+CAofDwiIr58pwDuUe
   w==;
X-CSE-ConnectionGUID: HMfg4DubSfiBJYuPZ5tPVQ==
X-CSE-MsgGUID: g623SWOwT6mcNgR/d2Vb2g==
X-IronPort-AV: E=McAfee;i="6700,10204,11157"; a="25002688"
X-IronPort-AV: E=Sophos;i="6.09,273,1716274800"; 
   d="scan'208";a="25002688"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2024 05:15:06 -0700
X-CSE-ConnectionGUID: 6cGG8FQVTS67YeETejga+g==
X-CSE-MsgGUID: YN5w+16DRXKwmDsCfG24OA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,272,1716274800"; 
   d="scan'208";a="61296928"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Aug 2024 05:15:05 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 8 Aug 2024 05:15:04 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 8 Aug 2024 05:15:04 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 8 Aug 2024 05:15:04 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 8 Aug 2024 05:15:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DCgnFRA60GOOOo4No/QQWx1wyLZkixutO9MldaBbpv+/X+wCTI4HMoVburKCIddrxJv/32hnN2U/60XYlC7rET97YOWu5a1qleIFsIctvAMgz+LH2125hez1L+u1gCmdbix+F4ZqQd/p4YDmDhdgNzGpcjZFWxHZzjCKEiedfIpsLfCYSFM/Hr7B4U0keAc7DSAePDdJGf/OI55N1HG92YIu2LiTKydIJ8lwjviFpKWFFw2HzmSSlYhQPfCSIqlnd0u6nzFSEjgkPuDIvmOgRZbG7xnOLuPhAFA7qWNDNJgRcolKB88y27/mvgaMn4lfm7RJ9KSBhkGx9IQcTRDgVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k3o1mA+/AspQf9JZFMdkft/32USsL0aNLK8YQyaiJzU=;
 b=d6txFuzmiL0VOyMR6Zt0Lg0LZbzyMTDL60PDWqGAS/dIayYFTL3qM7+aAbXJSSk/uR7Ea88I7qK90SD65XOg52n2kVoZVQS2+NpKbD4WX+qRUx7+SA8OGzXJUYxSuCuJFb31INK7mwzgBTAPk9nZL0nnKx5Htx/Mg1+QE8MYbtEBYyKlzXdhGz57qs6SVyq0akHntT9cUAiG44/B6GFslKBAcYny/mHGrXjQTixpynqEfIG7ryB0HKN2DZHH9vg0URFXIVER+6IF+Rb+0rB8UN9RaVVjgCg41OG7kqbn0dyI7Vlb16yiff3c2Gkpqem2NoknLzeQPs614NoxxE1lhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 PH0PR11MB5192.namprd11.prod.outlook.com (2603:10b6:510:3b::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7828.26; Thu, 8 Aug 2024 12:15:01 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::2dd5:1312:cd85:e1e]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::2dd5:1312:cd85:e1e%3]) with mapi id 15.20.7828.030; Thu, 8 Aug 2024
 12:15:01 +0000
From: "Wang, Wei W" <wei.w.wang@intel.com>
To: James Houghton <jthoughton@google.com>, Sean Christopherson
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Peter Xu
	<peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Oliver Upton
	<oliver.upton@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, "David
 Matlack" <dmatlack@google.com>, Anish Moorthy <amoorthy@google.com>
Subject: RE: [ANNOUNCE] PUCK Agenda - 2024.08.07 - KVM userfault
 (guest_memfd/HugeTLB postcopy)
Thread-Topic: [ANNOUNCE] PUCK Agenda - 2024.08.07 - KVM userfault
 (guest_memfd/HugeTLB postcopy)
Thread-Index: AQHa5GRjQjpjZsmMrUu/bdIMjsA4ErIcE86AgADaINA=
Date: Thu, 8 Aug 2024 12:15:01 +0000
Message-ID: <DS0PR11MB63733F7AEC9B2E80A52C33D4DCB92@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20240801224349.25325-1-seanjc@google.com>
 <CADrL8HXVNcbcuu9qF3wtkccpW6_QEnXQ1ViWEceeS9QGdQUTiw@mail.gmail.com>
In-Reply-To: <CADrL8HXVNcbcuu9qF3wtkccpW6_QEnXQ1ViWEceeS9QGdQUTiw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|PH0PR11MB5192:EE_
x-ms-office365-filtering-correlation-id: 0ad21501-b14a-42e8-24bd-08dcb7a3ba25
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bUw2K0NHY1BWSk0wc0wxbFF1Y1A0R0pmV1JEcXRkUGk4NjZUbnlsdy95eFE2?=
 =?utf-8?B?WG1rUnA5cmlrL0JpTFROc1FpQXIxRzZVQnEwaUJqbHlvUDRxZjcvdE1hdTIz?=
 =?utf-8?B?Ym5HOG12QzZTSFhXVGdSYmtGZFZvS2Q5MG1NNzlrTVYzYlpvL3crZU4weDVO?=
 =?utf-8?B?UWFXS09HdjQ2Z0FTY09oWnFXc3VaSzhwZnRVck9jSStIeDIwaGZpWXR1NHRp?=
 =?utf-8?B?cDNVVXJJQ3BpQ3ZaVnN3K1lmdEZYQnQ1WjA3cjc5dHM2cCtMR2k1c3JrZnFR?=
 =?utf-8?B?UU5sZ3VwdFY4eWFFRk45NmxEbDA3Z21BRkRRN0ZFbHJodXpCaVo1VzNEaThI?=
 =?utf-8?B?L2h4bTVRTldtWG1TcU1JamtyOG5relN0RzNlaVZKNFIwd1pxelhPTnhtc0Jn?=
 =?utf-8?B?UHc2ODNRODFRVC9YRTNtNTBrcEk4QlRsQk5mQUdCS0lJaW1GSE93UEhnc1FT?=
 =?utf-8?B?RE93VXdLZmc1bUw2ek10V1plOXZ1WmsrZVpBaFZLeFVGZVg4SU9ZNUtWbWtW?=
 =?utf-8?B?TC9uK25CUlRXSkdSZkN6RENBSEdSZlkxRFBMOTJvZTFYMFlLRDRUK2M4V3Ax?=
 =?utf-8?B?ckpkdkpwM1dPMGJGWitCNkNzUnlYa3hBL2gwQmd4bzVZclc3UXh2SUxWYmlH?=
 =?utf-8?B?REZIYU5HUkZMWWh1NEZ2bnpJTU1uUHBZek9WR2lrMytRYTd1RG53VGhXVDd0?=
 =?utf-8?B?bDNNcXNWQ2JxUm9ENkJDWXNNelE4Q01HQ1k4QjBqRG9aN3FyZldnbWVrNG9k?=
 =?utf-8?B?V1ZrR2dLZzVHQ1h2cmk3T3g3Z2h5ckw2eVB3Wkh5c1BuZ0ZBaHBGeXZnaG92?=
 =?utf-8?B?Y1JPYzRwOHNhNFNjM1I1TGZ6UG1GZ3ZCZ1lkMmxOMGV1cjRJT1Evd2ljTU1u?=
 =?utf-8?B?Njcxa012aER6RFRaVWhrVzZWV05BUTFjZkZpcGYvUm5rcS9aQWxDc0g3MEZs?=
 =?utf-8?B?MmsyQWlsQVh3bFFibFJsbGoxN3Jxd29rZFVEUTBKYjVreTRCQVVoN0ZmU05N?=
 =?utf-8?B?K2pock1Id0F4MzNHNVN5eFQvVUdvRzBsMWF5L1JOcHZEaTl5ME03UXBkRko0?=
 =?utf-8?B?ekJiYkVPcGlZTEpLQXdxRFNrdGRFZENVNUdnRDVVRUNrc3hJV3lmbW90VUF2?=
 =?utf-8?B?YVpNYVMyTVR0MjZHR0VlZElsM21ubFBoOG40dGhGU0JMNjQxbE0zV21Nc1Bl?=
 =?utf-8?B?YUNuZkdQTXQwNFlKbzFGVXE0ZUJaczJoNUpqay9ITWJmQ0hJZFFnZnhPSVFa?=
 =?utf-8?B?U2pQV0FhTzVrdXFFdTdmWCtPWHJlbzZnUGx2ekV1dDRsRVFseG9VOUNJQ3NR?=
 =?utf-8?B?YVBUai81TStzWXBYbndmRnY5QkRtSG9vQlhpYy9EQ3JvTzVtRlNRV2xxak9h?=
 =?utf-8?B?TC9KNUlYTlNzQjVHbytHeHNQUUtBY1BJa0taR04ySnlRQ2ErZlRQZ1dxYmNi?=
 =?utf-8?B?KzFRWEFSTHlPSlFSSkFJMUpXMENkVzNZbUNyMnFPMWNiSk5jMnRUSTkxRXNV?=
 =?utf-8?B?RXZtYnBobGJzUEtjeks2VWNNdFJWZzdmYTlWVUV4Smd6WjJ0VXlwOXJLbGRn?=
 =?utf-8?B?c1BzVGFQV093bE9ueXpCQU1TVlpLVXB3S0RGVzdEcDU3SWVyeTQyUW85OTBx?=
 =?utf-8?B?R21jcXVSelE3N1FrdGVVNjMwYXRIUFB2c2ZJaFFhUlNWUkZIRzd5LzJIS3NQ?=
 =?utf-8?B?bTdhNFNHYWJ5Qzc5UzIweG8xL05HZ0ViOTVXUmJlWDlVeisvRGhIRmNoQlVV?=
 =?utf-8?B?YUgzRXN4eHhoaU1OVGpuZFlCZ29IbHBnaUMxWXIydG8rWll4bkF3alFpbEZt?=
 =?utf-8?B?S1ZUNnk2OEhOZnRYVzFBaktqWms4QzNJYlJuSmJkUnRjS0kzbkp0Yk9wL3BJ?=
 =?utf-8?B?NW9NOUtmL1pOc0FQcEc3Z01nRW9CeURXdXZLR3ZWSzl1a1E9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U1BGVlMvb1BkckJZbTFrdkZ0RHFva3RWWkUyWGMraHhpR1hoQ1JpOW9wYWx4?=
 =?utf-8?B?WHdzbEMyVEFaOW5tbVBjR2ZubXJFSTY1RU1ITFFHTm5ZMU1rRWNSNWVMWk1H?=
 =?utf-8?B?R2RHek84UXlvVnhVeWJpWkVmdEFjaVFPSnYwbzUyc3JXMDNMWkZKSmRzNlAz?=
 =?utf-8?B?YmJDY01DRVZwd09qaVBWTGIydXAwdGVlUC92N1FGQkVlVFhtK3RzNGxSK2xx?=
 =?utf-8?B?UjdqQTU5WGU1ZkpCSmRoVHVXTWZ6MTRqNXpFU3JFSEFXWlJ3cG4zaTgvY2VI?=
 =?utf-8?B?NEhNQkwzY2wrdDZYMlN4U05ibUNydmlBVzVHUm1DYUF2M3MzSDRveC8zb1hw?=
 =?utf-8?B?M0RyL0ZWYitYYTZSUWJGSDAwb3lEWDA3YVNiOGU1N1B0bUdIbFhQUTE2N2xG?=
 =?utf-8?B?cmdESi8yeE9ZVzBFTkIrWFl3RFI1eFN4Q3IxejBTS29QYjFobjZzby9Uc2pu?=
 =?utf-8?B?N3pDUFpnSEkwOTgvaytINzRDMHZ2bFJNeHBzNFNPTWFlMFllNjhSWjBCSnEr?=
 =?utf-8?B?U0xJWWxPZmVBQ0hNRVVINWtCeHJROC9rdE9pbi9wcHpXL281L0pGYVVGdG4x?=
 =?utf-8?B?OStuZE9EZEQrYUFoZUVHTnBseEQ2RVZMbUtmakFLemJZa0xJTktPZXpLU3oz?=
 =?utf-8?B?OVN4S2E2K2Q1S1Z2SmtOaDlQWmhwN3Rlc1hyWEtUOGR5M3lHNWJGRXpQWCtS?=
 =?utf-8?B?YW1PVjRmWEwvK3E3THlua0pqcmlTSUFZTDlhQ0pzVUp0UUlXajc1Z1VuQjdQ?=
 =?utf-8?B?c1NYbHpha1VobmF0bXNYRSs3MGdqazRTdjIzVmd6emhlM2xKcFA3N2Jmazgz?=
 =?utf-8?B?UVN4MHcxRFZJV091THJEOFNzSTNhTWVxenE1Uzhvbnh5bWtCaStYd0krakRo?=
 =?utf-8?B?SnQrNkU1dlZnVzRoRDdUNlV4c0VDMkdDKzkzTXo3WHdmTDFaSlJHUFdodzVk?=
 =?utf-8?B?aU1zYlFkdnhGSFo1bnA2alNKV1YvR1RIdjdBTlpzUUR1RHRQMDRkVC90ZTYw?=
 =?utf-8?B?N2dyLy8rM3p5bVZRMXE2NWFZRWpPL1p3N0c0Vm50d2ZDdFhjcjRMZU9SY3Vy?=
 =?utf-8?B?VVhGSHU3OTZnVTUwK3pLbWx2c241cmYwaFNmKzRqN3c3OHV5SUpJNkNwTlVt?=
 =?utf-8?B?WHVrdGhlamJaaTdTYzJ1b2NKc1hER0xmM25hK1J5SEVTL1hXK0RFMXc3NTJ1?=
 =?utf-8?B?MVBlTGNYOG8wM1k0cTZqZi9lNW1GSlRFZzI2TzcrdjRpN1ZxWUFFU05rekt5?=
 =?utf-8?B?NFJRSUVhemhQalR1OVZsWXArSk0zbHFud3paZ1UzK3czZjRjVDhybmo0a2Ix?=
 =?utf-8?B?bWlKM3lLaC84bVU5aEVwSzNvbnRidWtnYVVFTWZqL21kN0xuUjliNDQydDVG?=
 =?utf-8?B?SExYVjY0b0c5U3dUaVRwTys3WFJwK0plUHlmUVAyUmpWTVVvRVVXNWdGM1By?=
 =?utf-8?B?NUYxZGxaUGhXMStYZHFaNXpXdlkvdDFBNCtwWExHa09HQVdPSFloeXdrSTRy?=
 =?utf-8?B?bURZeFdzTkQ3bEVLZnI3UGNQZks3cyt0TDl0QmhQMS91bWdVZG1mQ2ZJMzh0?=
 =?utf-8?B?NnRGTmZCRWVRZUdVeVhpMlZ4S1g0RTgvdWl6WHNpY0dtaHh4cDluL3NYUjNo?=
 =?utf-8?B?aTNBdmVwQnh0SDFOOUtoaUJQejJNUkoyTm9pNFFkbXlrOHRETTQzQTU1RHBV?=
 =?utf-8?B?dWQxRytKa2VwU1d3bjFwMDgzNEZkclNBSkczLytvbHZsejNZUXU0RWNpZFpy?=
 =?utf-8?B?M1pSVmhNRVhyeWNtYmdEY3VBVVhxYWdqcUFaNFBLZ1g1bndQUUszWGhFWWY4?=
 =?utf-8?B?M1ErcnU5QjFxSFd6WG9qMklXM2pDcmRmR0FIcnRXVkMwd1lKaVJqVVFJWm0z?=
 =?utf-8?B?dDcxVUd6UFBNbUdwNVJVaHRzbjBZaDU4eERmc2EyT2w4dlN0R0t0RDlHWUNK?=
 =?utf-8?B?Qm5OSEVadjZnYXg5ditIek93bVJJREdOa3UwRklBcXdTRTFFOEFhcE1FSUxW?=
 =?utf-8?B?ZCtGenpRYnoxNlNUWEZnaFJnRWJTcm1jSXh2L2x4MitkZWtNb3Z0KzQ2dXdR?=
 =?utf-8?B?bDRSY215eWJUQm1yclB6UTErdHdIVk9FNC9pYnNSZVZPUE5rQ0d5eERRUUg0?=
 =?utf-8?Q?PWZFdvAPB4oxJbS5TR4MgxtU0?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ad21501-b14a-42e8-24bd-08dcb7a3ba25
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2024 12:15:01.0140
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nLb/aG44LW/j0oWOpxUy+N8m0Q+YM4WXiVRjQhQvXzfh14MC5wl5Biog+ndFpJXN8IrWlADqKUSr649hvWWc+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5192
X-OriginatorOrg: intel.com

T24gVGh1cnNkYXksIEF1Z3VzdCA4LCAyMDI0IDE6MjIgQU0sIEphbWVzIEhvdWdodG9uIHdyb3Rl
Og0KPiBPbiBUaHUsIEF1ZyAxLCAyMDI0IGF0IDM6NDTigK9QTSBTZWFuIENocmlzdG9waGVyc29u
IDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gd3JvdGU6DQo+ID4NCj4gPiBFYXJseSB3YXJuaW5nIGZv
ciBuZXh0IHdlZWsncyBQVUNLIHNpbmNlIHRoZXJlJ3MgYWN0dWFsbHkgYSB0b3BpYyB0aGlzIHRp
bWUuDQo+ID4gSmFtZXMgaXMgZ29pbmcgdG8gbGVhZCBhIGRpc2N1c3Npb24gb24gS1ZNIHVzZXJm
YXVsdFsqXShuYW1lIHN1YmplY3QgdG8NCj4gY2hhbmdlKS4NCj4gDQo+IFRoYW5rcyBmb3IgYXR0
ZW5kaW5nLCBldmVyeW9uZSENCj4gDQo+IFdlIHNlZW1lZCB0byBhcnJpdmUgYXQgdGhlIGZvbGxv
d2luZyBjb25jbHVzaW9uczoNCj4gDQo+IDEuIEZvciBndWVzdF9tZW1mZCwgc3RhZ2UgMiBtYXBw
aW5nIGluc3RhbGxhdGlvbiB3aWxsIG5ldmVyIGdvIHRocm91Z2ggR1VQIC8NCj4gdmlydHVhbCBh
ZGRyZXNzZXMgdG8gZG8gdGhlIEdGTiAtLT4gUEZOIHRyYW5zbGF0aW9uLCBpbmNsdWRpbmcgd2hl
biBpdCBzdXBwb3J0cw0KPiBub24tcHJpdmF0ZSBtZW1vcnkuDQo+IDIuIFNvbWV0aGluZyBsaWtl
IEtWTSBVc2VyZmF1bHQgaXMgaW5kZWVkIG5lY2Vzc2FyeSB0byBoYW5kbGUgcG9zdC1jb3B5IGZv
cg0KPiBndWVzdF9tZW1mZCBWTXMsIGVzcGVjaWFsbHkgd2hlbiBndWVzdF9tZW1mZCBzdXBwb3J0
cyBub24tcHJpdmF0ZQ0KPiBtZW1vcnkuDQo+IDMuIFdlIHNob3VsZCBub3QgaG9vayBpbnRvIHRo
ZSBvdmVyYWxsIEdGTiAtLT4gSFZBIHRyYW5zbGF0aW9uLCB3ZSBzaG91bGQNCj4gb25seSBiZSBo
b29raW5nIHRoZSBHRk4gLS0+IFBGTiB0cmFuc2xhdGlvbiBzdGVwcyB0byBmaWd1cmUgb3V0IGhv
dyB0byBjcmVhdGUNCj4gc3RhZ2UgMiBtYXBwaW5ncy4gVGhhdCBpcywgS1ZNJ3Mgb3duIGFjY2Vz
c2VzIHRvIGd1ZXN0IG1lbW9yeSBzaG91bGQganVzdCBnbw0KPiB0aHJvdWdoIG1tL3VzZXJmYXVs
dGZkLg0KDQpTb3JyeS4uIHN0aWxsIGEgYml0IGNvbmZ1c2VkIGFib3V0IHRoaXMgb25lOiB3aWxs
IGdtZW0gZmluYWxseSBzdXBwb3J0IEdVUCBhbmQgVk1BPw0KRm9yIDEuIGFib3ZlLCBzZWVtcyBu
bywgYnV0IGZvciAzLiBoZXJlLCBLVk0ncyBvd24gYWNjZXNzZXMgdG8gZ21lbSB3aWxsIGdvDQp0
aHJvdWdoIHVzZXJmYXVsdGZkIHZpYSBHVVA/DQpBbHNvLCBob3cgd291bGQgdmhvc3QncyBhY2Nl
c3MgdG8gZ21lbSBnZXQgZmF1bHRlZCB0byB1c2Vyc3BhY2U/DQo=

