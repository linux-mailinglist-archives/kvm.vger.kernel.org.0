Return-Path: <kvm+bounces-49101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B95DAAD5E90
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 20:52:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 65D971E07A2
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 18:52:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9F06288CB9;
	Wed, 11 Jun 2025 18:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bNXW2N7K"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2692750ED;
	Wed, 11 Jun 2025 18:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749667927; cv=fail; b=KGs0eQwaK+yWb+vh3IKrZgceIjBdAu0eJchV+oUsTAjv2ykoa0z5QOz2cNEwdcdwsP9b/8lGyiLJVHccJz5izIzWb07zRA2Fe3c4P7NcHCnIxufaLD4kvhggMsGqUX82+TXY0GfXN0P2QWDIUoxJRTwHbQTu+JTHuJHh8cRuqWA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749667927; c=relaxed/simple;
	bh=mZsMPv6huoObUkEqgjeuMw2f2+5k7Jjz9LIj9pAxdPk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=l8yH/dAXmiaWWF6ZarHdZBqbUGf13nBNjUOe/nBBKm6o3A8lBwHDWH6WDtdBrgh8Ue6oL/JZczVN3JH314bbdHKDX06mOhM8jppIf/zPYIX0x3EMeVEqWPFYqg/DUFnnPWCCIB4s2dD6lr37azVWXghfxb+Nb8CvL/xb4jQUrKA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bNXW2N7K; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749667926; x=1781203926;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=mZsMPv6huoObUkEqgjeuMw2f2+5k7Jjz9LIj9pAxdPk=;
  b=bNXW2N7KAwkVQm78UNPZErrmoTJqJaYZdh/x0e6WGdIOIv6InQxtNT9s
   gmVmYgxSzrHFhiAauxQ+fGf7q0ECru9Iv8nQxFmWXNNp4tHR5xMxXjGYa
   NlKOuN88wGtSV6DHSB1GB30UwFAO2QNPzO48MoKvxSIrYQoO9YvnkfVmg
   iZy7/VltI7lmpHQG03LP7JEHwQoKpKeMziEN+Q0NQu1dn010Otgv/TUZS
   BNuNcfe4+8nYJZa0q2Ew8hMOmc0c8tSR1MDUjro/yx41Tocplc5QoKMpn
   PbVbtPUFzMPSHZegctrwQPr80U84gOvgAYMV8VNzG6aii2Sl1HPSW99Tc
   Q==;
X-CSE-ConnectionGUID: BZ2prpTgQs2tNhJHcZQXeQ==
X-CSE-MsgGUID: xTSgYUeaTc+TAjdo9i/Vow==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="77222660"
X-IronPort-AV: E=Sophos;i="6.16,228,1744095600"; 
   d="scan'208";a="77222660"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 11:52:04 -0700
X-CSE-ConnectionGUID: eolmXrVkSn+Xfp9yzKEyvg==
X-CSE-MsgGUID: eHbkXbaYTR2XJmiMfW00Ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,228,1744095600"; 
   d="scan'208";a="148184197"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 11:52:04 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 11:52:03 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 11 Jun 2025 11:52:03 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.83) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 11:52:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oqVYthQDD2Kvk3lMUzN9VLAgtEPRL2C//nZw+Poll59D5/LTEH9vPszCakJc1psB64XJfwMI5GPcBC34E9OQsVx0TRO/nKrtueHaa7AozjR1WgoAhxH0OEzj8E+wX2IRtFuoUn0v+NeaOaAHXm/vhYHTXD9yayOhFiG5u2M3Ni0rARKYPrpjWylktw1xZ9M6kHddlAa0WS3xnpbyG0TXq0d5IahjCWfEgfRwa+SGRrC/srInQmX8dxXn/DcNYfvGuPv+1mHanOZu88FLJkbPcDl1AdcJ4KciljKgYwwbmeiV5OvMyZDOM+EaBEcW7EPfqY26jAHb0XeyZs4n6bvhxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mZsMPv6huoObUkEqgjeuMw2f2+5k7Jjz9LIj9pAxdPk=;
 b=o4bI1KGoieR9A9Gt4+AE8CT0KGYroZpEjEGkWFOprEge+LhWWikHurz+x9WSCEQGKVXwDC5qHPly797vHmUbPIy8GodCGpXy3wypDVD3Mf6P0QgKJua2UaoeIyDuR518lA7gsqbHPuuD073fPeU5jQ6fo0C6VCZC9pqtq/z7ulPTS/TZLz0nJvHNJNoREzo4JdyR3HJtWU30wPfFRXJ51r9aqahwHU8A3METhynpvVCeJe2ouujkOMbUtE5jR0biEfP8fMLLismwOo9P0BA7tu5yVGtURjdaM8TI8YsSQYAOLDnvTO7tF2QFtqCghMn3ldtiaHfa26mN1MrDL3eeVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ2PR11MB8401.namprd11.prod.outlook.com (2603:10b6:a03:539::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.18; Wed, 11 Jun
 2025 18:52:01 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8813.024; Wed, 11 Jun 2025
 18:52:01 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>, "Huang,
 Kai" <kai.huang@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Yao, Jiewen" <jiewen.yao@intel.com>, "Lindgren,
 Tony" <tony.lindgren@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [RFC PATCH 3/4] KVM: TDX: Exit to userspace for GetTdVmCallInfo
Thread-Topic: [RFC PATCH 3/4] KVM: TDX: Exit to userspace for GetTdVmCallInfo
Thread-Index: AQHb2a1TbQakduG6E0K+sX62VG3CXrP8HXSAgAESDYCAAAs3gIAA02cAgAABHgCAABiEAIAAB40AgAAWhQCAAAqlAA==
Date: Wed, 11 Jun 2025 18:52:01 +0000
Message-ID: <a746dbb0ffd130996058af92c54e91c4880a1337.camel@intel.com>
References: <20250610021422.1214715-1-binbin.wu@linux.intel.com>
	 <20250610021422.1214715-4-binbin.wu@linux.intel.com>
	 <ff5fd57a-9522-448c-9ab6-e0006cb6b2ee@intel.com>
	 <671f2439-1101-4729-b206-4f328dc2d319@linux.intel.com>
	 <7f17ca58-5522-45de-9dae-6a11b1041317@intel.com>
	 <aEmYqH_2MLSwloBX@google.com>
	 <effb33d4277c47ffcc6d69b71348e3b7ea8a2740.camel@intel.com>
	 <aEmuKII8FGU4eQZz@google.com>
	 <089eeacb231f3afa04f81b9d5ddbb98b6d901565.camel@intel.com>
	 <aEnHYjTGofgGiDTH@google.com>
In-Reply-To: <aEnHYjTGofgGiDTH@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ2PR11MB8401:EE_
x-ms-office365-filtering-correlation-id: d8556f13-f49c-44f4-3798-08dda9190cf7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NnhHUVB0aDB1M1haRE1DRloveGFGaVdCdWhoakFsdnVBeENhdSt5SUZxOTds?=
 =?utf-8?B?NGJJb0lSUHdodG5jRDNnM0RlZmJoY1N3SHZGdnBhNDl4aFh5K3JiNnp6aGpj?=
 =?utf-8?B?K3F0ZGluQTYrWGdBbEtLZHhaWlo2VVFpb1NLOG9hYk9QcE9yaHZGOW9yMmJm?=
 =?utf-8?B?Y3R5NlFZaUh2MGs4dXNkQkFwZm5XV1JBR3ZOZ0FCb3hpK2xJekc3Q3FiVlVa?=
 =?utf-8?B?M1Izd01HTlBRbHJiTGRJWTRGTk9UbFZlU2h5TkZFYWpNSGV0M1JnUEVyL09P?=
 =?utf-8?B?eWZhTGcrbXZ3STUwd0NoeDBkZVlTM2phV1NvN1NnYkVESjc3T2FjY0VTRUQv?=
 =?utf-8?B?SmRDQ2VRdjJhczlBRmg3ejNpelJQUW1yWVo1akYzallPU29FMkgrN3FoT3Jw?=
 =?utf-8?B?UElESkc0R1NWV01YRGY4bGFKb25nWXk4RVlsdUhYNmhzV05jdkV0WVZHNlVh?=
 =?utf-8?B?SDFxVWd2RElQcjF5ZTBreUh5dUFOQTZZbzZleVVkelJ1eVd4T2dZTmxVcFBo?=
 =?utf-8?B?NmNPdDF0cS92NEl1eEk5ZjgraS83L1hWc2t0ajNjVDMwclNpeC81bEQ3cFVJ?=
 =?utf-8?B?OUN0bEV0STVFT0F2Y3ZwYVovZFpKeHRaYUR1d2U4YWtRS1ZyeDFFVlJpZUpk?=
 =?utf-8?B?VmMyWWkwZUk1WW1WWStmb1ppY2UrZVBKcThJZ01jbElHVE41dzNHYW9xN3ZY?=
 =?utf-8?B?RndkeVo3OG5POFIyQUZIZjVtMFdZUFZSV0ZZOFNlUmQweXpaQUgvM0hKNzkw?=
 =?utf-8?B?cmRRV2hiL0ZMb3M0Qmh1YXdlNG82VStDLzhoNlRuNWRKK3R2R0RYSVMxMlNE?=
 =?utf-8?B?U1hhWTM1dU9hdnZyVnRGWUU4WkgwNkFMNGk2VDhEaC94UEdGZWJyK2kzazc3?=
 =?utf-8?B?aEJFVEVRV1lIakc1ZVU4bjdOdkdtQTgxQUVId0pCdnNUZlZYT0pMb2RLc2Rw?=
 =?utf-8?B?WGh5dzhTR3Rpc2FYYTZUc2pMcWJCSDZPcGVGSmkzV0NPMzdRNVJ6dTl2Z3BR?=
 =?utf-8?B?RnJacHpzMlgyd0oybW5MTjVDbHhZYytjK2NkRlhQTXBpQURoMjFVby9UdnBl?=
 =?utf-8?B?MjJMenIwUzlicmdoWnBLK29ndjh0VVk3SkRPZE5NdjFNVnJ0V0FDb21NRkY5?=
 =?utf-8?B?Z0dBSTdBZmJJUG9pd3lsZUU5VjhSRW9xZW9WYzBxWDNXWkgzMmpqVC9Eek9k?=
 =?utf-8?B?Rk5FTUVVYU1JN1NrekpWWTZBTUc1YWF6T0tQeklGREdiZWpNR0FmeTFacnpx?=
 =?utf-8?B?TmFYTVpCMGRBVHJPa3pZdW5QVUNMQ0xwUS9WZUIyWW9vQUxhd2FRNXVZZFQy?=
 =?utf-8?B?MUlyUU1RdDRaQzFEejJjU3JWSU9pYzdyeFdKcSt5bFFUQTRPMDlwcVNzcXE0?=
 =?utf-8?B?LzQ4WFdXK1plSGJPU0RrRElpVmFFbXhGbXM0YlhORzdJeVhZZ1E1Y1N2TE1q?=
 =?utf-8?B?dlpHTTRjRDI0WjlsUkJGZTVYVzgwRFFqOVppUk4rZzB6bjkrVzlwZ1NKRmps?=
 =?utf-8?B?L0VZMEdSVUMxT1YvMTJlNXl4ZFE4R3NiZUJDejRSZHhVUVVsNm1DTjBqa1dK?=
 =?utf-8?B?QUhTNTg0M0VRVy82TnFFUG50dGNSS25QdEgvczcrNThTUnppZ3hGcTR2anFH?=
 =?utf-8?B?bmNrR2ZaajlhMS9keDUzN2FDRnpWUVZrM1RFOHpQTnQySVRJL1BDM1FldXhH?=
 =?utf-8?B?bjNRd1M2STFESEtCcU1hVWgyaHdheEtpRkN5WDVlSEZRd2hiSnkrajFhZjhQ?=
 =?utf-8?B?WGFWdjlRZjE1TDhJWTRzekNpYy9aVVZiS0lZV2NnTnJFamcvTHFUMTNnTm1s?=
 =?utf-8?B?d3JWNzBLVG14ZHF5NEI5VjlGYXU0dXArUXFUaFNSU0ViSm9ZREQ1ZUhEZlN1?=
 =?utf-8?B?M3Z0NWR6Rjl5RlFHa01aMWV0amtVWENJWElTOVBiWDZPd000Q2hKbmZKdkZw?=
 =?utf-8?B?VFp3bk9DVWY2cmlEeVFQcmNOdTBsYVdBcTVuWmYxMlBwYWI0ZjNHekRWQ094?=
 =?utf-8?Q?+Ba4wyfzN1+o/ZvwWjK0KLKeHMeS7E=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eGdxUzZ6WUo2ZUY5VGlVbTRIbk0yMWVIazhuMmtVZ1cyRkN4OXVENUVOSEwy?=
 =?utf-8?B?UzJ4TWFkMnVyb3ROaWZYdmdiMmxzdkFvVkpjYkxLSUNFSGdDTFIvR2J4Nmpp?=
 =?utf-8?B?Z3htTkRGaVZYQk1ZdVJPcTEwYUJjTVlIVEEvY1d6MkZmRzBuMnlHODZ1RlR4?=
 =?utf-8?B?d3dmL2cxZG1DMWR6YXZWWTY4L2dIYjdGamJBYUdPcU53YjZnckpWODA0ejI4?=
 =?utf-8?B?RDNjOTFLdHdpUjQ2bGpvY2hIeXhRVzlFaGRKMFZnOVhpbDhNR3EwVzN3V0xO?=
 =?utf-8?B?QTlPSEp3SzB1U0l2TWVDSnVoeGpEQURkelV5MWY0ekxJWG1QRTFJQ21hVGdW?=
 =?utf-8?B?cEt4RS9WY3ZZRytMK1E1MHNGa3BrL09MSTRaOHh3VzVDb2t2Q1A4RkFweTlo?=
 =?utf-8?B?THA3OXNyNG5CU0ROQmlIcGVuZ0hHVWFCRTBUS1M2NmdTYmpUdEdOWWttcnhN?=
 =?utf-8?B?b2VDSmJ1cnBaNy8vVDhUNmdXMW5KTFpIMDdkaHVYK2lxM3pTTG9UOWlUMGgy?=
 =?utf-8?B?bit6ZVBNUHFGeGp2bVE1WThaZzlKRkFvd1d3c2wzNE45MTloY25tQldmWWpz?=
 =?utf-8?B?cTlkeGh4VmpKWW0wS3J4ajlTTEs3aVVvN1FRS1luN1NLcCtya0g1Q2RnQ2VV?=
 =?utf-8?B?elJoR0VhMjlqeU12ODJwOFhHUGlTczNFVmpvMmtHN2p4dEt0Mys4RlV1SDF2?=
 =?utf-8?B?NitCQ3NiZEtyWmVkNE9wdmNVWnJydEN0NFNNMDcwNTVNbS80WnFWZFNkZUho?=
 =?utf-8?B?MmxNWmFHL2hWekcwMStJQXNrWVVRZlMwdEcyZm5YUXQvSktJRW0yTko3UFBw?=
 =?utf-8?B?VmRpZkhTNHhwZHBQdkplYXREbkMzcDNtTHF3ektEZjlkQ2JiUllyMUJQYXY2?=
 =?utf-8?B?SjJ4M1QzcFp1OVBjamJRT2JKUEFOa0ZkQ01oR2NVWjVoNDhqU05pbUttS0RQ?=
 =?utf-8?B?UlZSR0RCNkpzZWJqSUlwYXRicmlYMU5laHRWMGFMVnM1SW0xbWs1NHlHRDV5?=
 =?utf-8?B?Q21QVzlUSHJmNmZBem00ZGNOR1NpdjJDSi8zeC81NGE1ZzJGTndScHFldmhG?=
 =?utf-8?B?MFBLQjR2K1F4L3d4clFLbzl6Mlk4OERmaWVXK3AwTXl1Szd0d1Bka25nNVJN?=
 =?utf-8?B?U3NjcjNzdFZUNTl4c1Y3TExwZXJwbWFpYXU5Yk9MZnVYWEs2eDh4bnFUQ3pr?=
 =?utf-8?B?Rjg3M3BTQmloamFoUm5qY3RrUEkzeWh4OHpyd0QxRnJwM0VMQ3ZhVDQwbjNB?=
 =?utf-8?B?bkxtclo4N3ZQblByemUxUzVEMTJTN0l1ZG9ERmJGTTF2b3p4L1kzTGdMZWNn?=
 =?utf-8?B?cjlJZEVaK2lZaUJMZDVzZDFNZ1BQZEVMSnJjclhzYW1aclNYaTEzTG0wY0tK?=
 =?utf-8?B?bVBSL1FITm43bCtTWHI2QWE1MUN5dTJwaTdHZjJ3enozTFFqRlR1K1M1RTEw?=
 =?utf-8?B?OStxK0JTdEJvZW1lSVhQSWUzTnVYVVQxdGRwNXNaQUFlNXFJbDNVVDVONlhT?=
 =?utf-8?B?ODhQT1E2MjZraVlkbStDeCt1WW41ZUZyZm13andLVTRLOW9tUTRQSlYyNmhE?=
 =?utf-8?B?dm45V3Zkck5Ka0N1bitDaFpEQkxHSHJUb3ZLai8xTUUxUHF4N08xK0lXd0NJ?=
 =?utf-8?B?UHY3b2R4OFh6d1ZPdFhUaElSTHNpUGh6UnRpNGJuMEJpN1ZPY3ZlSFdqWFVW?=
 =?utf-8?B?c2FJUjFUMi91V1lVN0tiRlNTU1VONGlhRWVpcUVuZnlXdDM2aTVMejh5U2hz?=
 =?utf-8?B?bTdFRDFBRXZ0UktrRHVKcXg0MGpwV0xFNEdyQ2J2L1RGcjY0aGplWWU4cnJL?=
 =?utf-8?B?OVl0YVpUaWFRYVE4dGFGak1zbzJIZ0YrbVBZQnM0UnNzTktSdksxeEdwWnRx?=
 =?utf-8?B?d2M4SU9tbkQ4a25XekFvdTQvekNENGFqYXpwcC9mUHB3emdhaEFvMTBvOTVH?=
 =?utf-8?B?UEMwUkJUVlRoTUY4ZnZTOG04V3VodTF3am9zbVg1ZFJDZUYxVDRBa3ZkV2VR?=
 =?utf-8?B?WVFxaVNUUHRPTFBkR2l0a2cwL1JkY1FqK3RSK1FjQTlmVzZFUk5XSERIWnV6?=
 =?utf-8?B?K09OREFsM3FxVGdtbXVYK2pqdE5zNDE0cDBDQW1oRmk0WXZQUVNNS1BEbXBJ?=
 =?utf-8?B?M3A3cXNkUVRzZTVZczFLUEJmUG01MzRNMkxYdTVzMksvWWJQTi9QMy9ZZjJi?=
 =?utf-8?B?aGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <33E052523A50F048A0543D934D9D502F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8556f13-f49c-44f4-3798-08dda9190cf7
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2025 18:52:01.3028
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fAMEmv4Ogu3orXPq5V9hTSe8GXw/JmodaZae5woIpf+zxG+V5aEyfMW/GrdtNH9JvwetCSKkoQ5kuP0NKpKFu088kGEXWxMrOKlZVpzv3Es=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8401
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA2LTExIGF0IDExOjEzIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IEkgZG9uJ3Qga25vdyBpZiB0aGF0IHdhcyBhIGNvbnNpZGVyYXRpb24gZm9yIHdo
eSBpdCBnb3QgYWRkZWQgdG8gdGhlDQo+ID4gb3B0aW9uYWwNCj4gPiBjYXRlZ29yeS4gVGhlIGlu
cHV0cyB3ZXJlIGdhdGhlcmVkIGZyb20gbW9yZSB0aGFuIGp1c3QgTGludXguDQo+IA0KPiBJZiB0
aGVyZSdzIGFuIGFjdHVhbCB1c2UgY2FzZSBmb3IgVERYIHdpdGhvdXQgYXR0ZXN0YXRpb24sIHRo
ZW4gYnkgYWxsIG1lYW5zLA0KPiBtYWtlIGl0IG9wdGlvbmFsLsKgIEknbSBnZW51aW5lbHkgY3Vy
aW91cyBpZiB0aGVyZSdzIGEgaHlwZXJ2aXNvciB0aGF0IHBsYW5zIG9uDQo+IHByb2R1Y3Rpemlu
ZyBURFggd2l0aG91dCBzdXBwb3J0aW5nIGF0dGVzdGF0aW9uLsKgIEl0J3MgZW50aXJlbHkgcG9z
c2libGUNCj4gKGxpa2VseT8pDQo+IEknbSBtaXNzaW5nIG9yIGZvcmdldHRpbmcgc29tZXRoaW5n
Lg0KDQpPaywgd2lsbCBjaGVjayBiYWNrIGluIHdpdGggdGhlIHN0b3J5Lg0KDQpUaGUgb25seSB0
aGluZ3MgSSBjb3VsZCB0aGluayBvZiBhcmU6DQoxLiBURFggdXNhZ2UgYXMgYSBoYXJkZW5pbmcg
dGhpbmcsIHNpbWlsYXIgdG8gdW5tYXBwaW5nIGd1ZXN0IG1lbW9yeSBmb3IgYWxsDQpwYWdlIHRh
YmxlcyBpbiB0aGUgaG9zdC4NCjIuIFNvbWUgaGlnaGx5IGNvdXBsZWQgZ3Vlc3QvVk1NIGhhcyBh
biBhbHRlcm5hdGUgYXR0ZXN0YXRpb24gc2NoZW1lLg0KDQpNb3JlIGxpa2VseSBpdCB3YXMgdG8g
cmV0cm9hY3RpdmVseSBicmluZyB0aGUgaW5pdGlhbCBLVk0gUFIgaW50byBzcGVjLiBXZSBnb3QN
CnNvbWUgcHJldHR5IHNwZWNpZmljIGRpcmVjdGlvbiBmcm9tIFBhb2xvIHRvIGV4cGxvcmUgR2V0
VGRWbUNhbGxJbmZvIGV4aXRpbmcsIHNvDQppdCBkaWRuJ3QgbWFrZSBtdWNoIG9mIGEgZGlmZmVy
ZW5jZSBvbmUgd2F5IG9yIHRoZSBvdGhlciB1bnRpbCBub3cuDQo=

