Return-Path: <kvm+bounces-44934-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DD1DAA4F87
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 17:05:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C03F501BE5
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 15:03:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F84925B670;
	Wed, 30 Apr 2025 15:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R30rurk2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B63199947;
	Wed, 30 Apr 2025 15:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746025376; cv=fail; b=ZFcePFKIc1os2qJb0/np7IJjiVAvZysQgHMGxMFUu90fHrC+hQrMPyyasJd2Tqp0MM4NGL4AOPceOvXafO7QZ9xztf+eIeDg27OWgjTcvIZkOw26tJcSRy3c2yvb5DOitGteTpcSjM/9PL/NwCY0Vk1xYS7lXESVBnUefTLBbAw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746025376; c=relaxed/simple;
	bh=+UB9XyjM7HyvW/wXM/Y7o3/ayEU8vdLueB9jVJDyvlo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tyTG1oAsiqDBRuBI7kApI/yBrCPttO5SAc/W8INjy0TsVudNVJa89hcT+9kYOw26losfaYkv2//ZU+0f69CRAtOybIRsIwNIUK6ubay6+w5e6TbULHNAdnLHtpXIwkwuaLrAh4K6BfDYW9UioTNc/mkRcH0HSHnntqY2s0L00kE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R30rurk2; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746025374; x=1777561374;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+UB9XyjM7HyvW/wXM/Y7o3/ayEU8vdLueB9jVJDyvlo=;
  b=R30rurk2coHP5NUCBv59XqGWqPXGTBCp+QevmPVJPDX2KO5q8umS9Mww
   s/WgKh+fXyd/8LXM2OyRtUZH60OFWwYCKoR+8JYdu063WUZIuMWPMjD/0
   mx+e/7jMguMuJqd5jd++R0q1c3DtvoNxQLU1ni7frCGg8ppW9VCTNZ+xM
   5ERvWxc0OM+jMkYEV+abCr5iAcrn/pqivf/OCL1xbEmIXRL5+4rMO4OW0
   vv33Y3LUNHGFZ+yZFoJKQxGTTPF5m+OBD0DYUibKR6I0pX52N8A35eT7A
   n1P87GrUKd4TiE5/uufVIjYbQq2100najEtp5m1NP2IJoTfYD5uIHyUjs
   g==;
X-CSE-ConnectionGUID: 1E7j1mWXQxSk72rpxruTbQ==
X-CSE-MsgGUID: k0IvGfZ9SmudxHC9H3CD4w==
X-IronPort-AV: E=McAfee;i="6700,10204,11419"; a="35306864"
X-IronPort-AV: E=Sophos;i="6.15,251,1739865600"; 
   d="scan'208";a="35306864"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 08:02:40 -0700
X-CSE-ConnectionGUID: TTCFWDXZRcKt4wa69hcsnw==
X-CSE-MsgGUID: 64g9AxrIRbeG4TslWcPy1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,251,1739865600"; 
   d="scan'208";a="135091873"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 08:02:39 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 30 Apr 2025 08:02:21 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 30 Apr 2025 08:02:21 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 30 Apr 2025 08:02:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yPa54ubIpXD826ffC4/KwlBnfYn/uDU1IvVCNPUeWdqdpVIHn2jlUSUoEhEee4sizB6t7wBC5014e61e7+Kw/p5davyACS+8wK/ICLsOSd+pEhQrHboa9LX6cMj7aP9nAh7EJDK8RoTGADE4x3dXeq6UpdCnlhx1rvBfXT1fJkmk5CLMg6auKVegQQMvBPDQju3CMzjlBhiEF0VmAyYb4/DKApmzUJ9K1neMReZM7lAb3Ia8Z8VDGWH4VvQwQahftWZ/UR7GUtQA2Ggz2P7SdKIKseVnKgSEzva2cLO7r6ZJ4ICIM3SOdvzZI+9WQSpwfwMnZQzBw1qd0qFwDlLRzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BupULyHjXNwxBi4hSFlBF0dtApJ+1tRAVvpBOFpUQ1I=;
 b=N4Aghq4xcOuNaXBaESELCCzdGn7BuSii9XRi0rMqRc8DaDidwM2ODFuYbLLp6cke8+MqOLv/yymp3fZn6vhbsB4TSsEEGjnPvGg657bR9fXB73ikxtO2rTb/FWwE7NAAys3ovJCgXexx+kxShn4bAgMmmef6HMV/UG+q46cDUlcu5EHUdrmjyQU7eKhAAlgnLFFxqm+bSTMTs31M+IUYhrIVdEY48C7gE+jlInhbsCXusShtXDOeCkpiay/dWMGLj1zYmieNl1CcEzph8TNHEYZokS7EuEGpi/bP9tLppoF0mGVQjKMUGHGt6ot79cR1Kt5lEdtkF9IU5I/RV9BIvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 SA1PR11MB8279.namprd11.prod.outlook.com (2603:10b6:806:25c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.19; Wed, 30 Apr
 2025 15:01:47 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%4]) with mapi id 15.20.8678.021; Wed, 30 Apr 2025
 15:01:47 +0000
Message-ID: <281354d3-1f04-483d-a6d0-baf6fdcec376@intel.com>
Date: Wed, 30 Apr 2025 08:01:44 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/7] x86/fpu/xstate: Differentiate default features for
 host and guest FPUs
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "ebiggers@google.com" <ebiggers@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Hansen, Dave" <dave.hansen@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Spassov,
 Stanislav" <stanspas@amazon.de>, "levymitchell0@gmail.com"
	<levymitchell0@gmail.com>, "samuel.holland@sifive.com"
	<samuel.holland@sifive.com>, "Li, Xin3" <xin3.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "vigbalas@amd.com" <vigbalas@amd.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>, "john.allen@amd.com" <john.allen@amd.com>, "Yang,
 Weijiang" <weijiang.yang@intel.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "aruna.ramakrishna@oracle.com"
	<aruna.ramakrishna@oracle.com>, "Gao, Chao" <chao.gao@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "seanjc@google.com" <seanjc@google.com>,
	"x86@kernel.org" <x86@kernel.org>
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
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <f57c6387bf56cba692005d7274d141e1919d22c0.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0150.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::35) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|SA1PR11MB8279:EE_
X-MS-Office365-Filtering-Correlation-Id: c648f62e-0335-4630-104a-08dd87f7ed97
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bS8yUE96OWpaeXZjalh4SEFmRnZrN09FMy9ZbHJNbyszTDlTM0J3TU5GTHNB?=
 =?utf-8?B?RWZIcWxod0hRS1FXZnhjR1lXNktjUVJpbU1FRThQSjZ1bGVoaUdKTURaZ3p1?=
 =?utf-8?B?ZlQxUC9zY0w3TmtmaWR6QmdQK2ZHYjg5My9SOXdSY2FMNHJ0d2NRdFZjOEpj?=
 =?utf-8?B?T2JxTDU3VVhlQWR2cXhSYXpwVVNBbGVoYWxtcU5lODlmVDNXYWtZZG11dWlC?=
 =?utf-8?B?VUVYZnRoQ2Z4OGxNYitnZWF2VDE0dW4wbWdxRkxUOUJWMEFxajZKdktSZnly?=
 =?utf-8?B?RytFWjBTYWdPbGd6d3BpWkh0T09WdElST1ZPRlNkRG1odS93VlZRMzNma0ty?=
 =?utf-8?B?R21LU1dYU1JCTHVYNEJsVVg4cnhudVJKMUthMEVMZGYxOXdRYmZXYU5jNlQ5?=
 =?utf-8?B?U1JsemJncWllWXVBMWUyczRCM3lZRFVPdDZaWWkvZWRkL1JZRGhPcUpyY0xw?=
 =?utf-8?B?UDd5dmxtb2RKU010M091TWUvbWFqSHRrTGJPaXM1eUplZVBzbDY2SWFyRHdh?=
 =?utf-8?B?NTFCNWhjKzlkbEtOQmUxaER1a3R3Tk4xT3B6RThCNzhlbFg3cnZNT3FwVWM5?=
 =?utf-8?B?QVdmb0ZIL3JWbUVtRUw1TmJWR2xOVFNQbVUyTGlTQ2kvbzNvSStVR0dFaVcw?=
 =?utf-8?B?WXA3WFdSUmFXcjd4VHhHNjAxL2ZqTnhUdWxvZE1JNlVuZnFyMitTUDE3ZGZC?=
 =?utf-8?B?VmJpZUVNMk1DRzdaTFZxVnowUUxJTGtrckg1T1hYeFMvdUwwRXdRNVhOZnh6?=
 =?utf-8?B?QzhSdDlMU1RnSFQ1SmxuVHRnY2lYUDdlOW1EbFM4VkNPSFlYRkpTR2Qyc21K?=
 =?utf-8?B?YWRJSEhuakZzeGZvZ25TekJHR1hEWkZUUVdOZjZHQlA5N1FDd25uYXBpSmV3?=
 =?utf-8?B?WjRzbmVlT3M1Tmcrd1VBSmkxYVhsbmFtT0ZiM2EzcXZPK002ZWcyL1c2NDly?=
 =?utf-8?B?cldWRWVrQXc0NU4xWHRKYytxMUYxSWtqSHJKY3JkbGtxT0RqcnJpVzFiZ2JU?=
 =?utf-8?B?YU5hZ3JHUWFGb0dwd2Q2SHZjZ2FzQ21hT1dHOTUrUUE4WEtVbnAvbmJyM2tR?=
 =?utf-8?B?QUttSUxrbElTK0xnSG91U2pCd2J1bStKWno5UWlaL2g4aXQ5eDBydEZxWWFH?=
 =?utf-8?B?Z3FPZTlJNmhWR2FBUlFtTThvcDdlcXQvWm9WTVZpWEFabTFrcVB1U2NaNGIx?=
 =?utf-8?B?ZE9GSnk1RFNCTkVaclI5TWgxOTVjK0wrclNibnVhT01Bc3k4TThTVzFUalk0?=
 =?utf-8?B?aVlFL2E1eVdVdjZnb3ZaWE1FVWtNbFB2eHJyci9DNGp1b1pZditDSy82QUQ1?=
 =?utf-8?B?WFVHSXB3dUZScGYzNHRTeXFkMEZDcmVXUXRNOW9hbmUrWXBDZVBZSXF3WXdr?=
 =?utf-8?B?cTNZVGVidGk0YTBIZktZZlNvb0lMbnZJcmMzRkE1UWRoT3FzRmJzckFaemhY?=
 =?utf-8?B?bjZlcFU3bGRPRUxSTFJsSUh2QURyR2ZtekM4MThLODFsZXRXMGwxdVU5Sm1M?=
 =?utf-8?B?S2JJbzlLYS9obXBCTG9ZVjIvcUl3bS9YNWlZeWJqeHY0aW9QSEV5MTNzb2lK?=
 =?utf-8?B?bEFSRUdYWmFyK0dzRElFZzRqck5vbVVOY1FCTmFZQnBhOG1nTGQ5VUVNSm5N?=
 =?utf-8?B?YnNTeGZ4T2ozU2RRcWJRbmg4dGhlc0lFZy9YSVNlZGs4VDY0MjAwaFp2cmNJ?=
 =?utf-8?B?cDlzcUhvdmFqWmorMUd4VWxuTTV4SkZKNFpyN3Y5dkpXeXZQOHNPWWVjcFdr?=
 =?utf-8?B?Y215QlAwRzlYK0dvRHltaDJyZmxKejRRWW1rTDRoVWlqaEpSVldOUzJ3S2la?=
 =?utf-8?B?NlB4TkxQSGYxc1Ivb3VCRnoyZUxGZTRYanJzai95VTFDa2pqYkpkTUFEMU01?=
 =?utf-8?B?VE11RVVLZ0JBSGpEZ0Jtc0hwNjJYUkJUOTRFTzFXd1FuMGpDanl2c2t2V2Nr?=
 =?utf-8?Q?Bok0TlW6luA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M1B0ZXpwdkpKcWdBYVlLbU90RnY4cmFiRm1oYU1xeUlIYnAzajk2cXEvZWJ1?=
 =?utf-8?B?WVk3QUpVQ1JMaU43UnFtZy83dDBwRzRObW9tdENhS1pFRmZYSURrb2gvWmFp?=
 =?utf-8?B?VUVDOVBxMlVkZ0FkZFV4WG8yRk4ycUJhUkdpWjNMZDJNQm8xamRmOHBMYUJn?=
 =?utf-8?B?U2lUc2RpV1FCYU92eXdFVzJ0L0UzZVQreXNXMW00bEhRa1cyNG1UMmlGS1Ny?=
 =?utf-8?B?d2dJbGZMY1FFSW51empNUWE0SGRrY3JsU05rT216RzdRNzU4QjF1YnVydnov?=
 =?utf-8?B?SStNRzd0cGcyYU9YQWJKZ2VoV2F1MjMvNW9IT3JsdXRJajB0NXc1Vzh6clkv?=
 =?utf-8?B?LzBKSzZreHFtRGMvc1JTaVZ3WUxpZnp3aUM1aFJ6RlRZY09SSjF1cGExZFNL?=
 =?utf-8?B?MDl0eEk1QWJocHNwdTR4eVRLNThUT2tpc0U5WFJxSG1DMlZTL0NHYk83MU5p?=
 =?utf-8?B?dFBoeEJ2Mm1iK0w1a2dJTElmaGN0MFJYbkF0T0dTU3RYWWtudmNzM3N1YXZD?=
 =?utf-8?B?b0llTzlETTdrcFlUaDNoalUyY29ldkJnZ1g3UkNCQW44OG1LSkp1eTRzRUkz?=
 =?utf-8?B?TTI2TWtjQm1qbkxBRlJOMVFjMVV0aEpGZlJqeHAyckUyWXRpMDNpekl5MDBy?=
 =?utf-8?B?OVBUVHp6dmtSMmo4SmNETzN4RUYrR1BCcTJJdVVmN2VrdVQ0cG43Z1Faa2ZQ?=
 =?utf-8?B?Z1BZNURpVnZ1WXJ0WDJVd3RESGhzajN4TG11bExUdTU3Q1F0K2VlcHBIYVp3?=
 =?utf-8?B?V1J1elo4Zy9OOHNVZGJWNGU4VGUrdi9LUmRzRVhvUDBFT3JnZkNBcjJtSUV1?=
 =?utf-8?B?MC9hdzlwNHkzc0d2aHlORUNDUHFSeWpxKzlmQzU5OFovZk56b3luMThhL2R0?=
 =?utf-8?B?bjlROXhXQ25pT3I0UXEycXRaQU1yZ2lTSGovejlCajRFZ0J2dkhhclk5L1Bz?=
 =?utf-8?B?aGhZaStuZkNVNS9wSTVrOS81MjVCSDhOQSt3cm5Ed28rZTV0aVJBQ09DbGlL?=
 =?utf-8?B?ZDAyL2pzRUpvSFZrWFcxNTRQWEsraWlWNjFLcDhyeDBPM2xIdzVBSVFqMlpE?=
 =?utf-8?B?aTVIRlppVnp5eHo3bGNGUUxYc3ZMc2VuQWMxVytOVzJua1ZLUHZhMi9lSHlN?=
 =?utf-8?B?WUU5TSs0UlJXd0pldU5hOHNFNTRvRFZmLzFDMkhsRFh1cFZxU0wzNEdXQlNZ?=
 =?utf-8?B?VjVyVGtIVFMrdFRtV1NrSWhWTElWTEVHMUZEWFRiREVQVTgrcnVvK0xITXph?=
 =?utf-8?B?R0Z5eitpL21NMTJTUWU2UjRvVkNXQTUyREpldllYdGNsMFh0emJDMlRpREQw?=
 =?utf-8?B?MUNtTGhhcVdLbWNDM2tkL2VVdVJhNi9YZFk3RG1uVWwvTVVpT3U2eDJTMmE0?=
 =?utf-8?B?NHJCYXh1SjdTb3dzMXp0YlRQMGlzWVFNUVRpUlU4UjFZaW40MHdkZk4vcThv?=
 =?utf-8?B?QzNDWERhUUtSaXYwNUhXZDl5cGp3MUNrZU9lV1lRbWwzN01SbWxka3dtOEtG?=
 =?utf-8?B?MjZxaEFHSjZaMC9VY0FEWE9tOG5lMHdFV2I4dFJCTmI5dFhGNENHckNDUEFB?=
 =?utf-8?B?ZTV0bWVxcEY1bTV1cVVGbWc1blhyOUJkTFJSVlRqcU5jOGVGVFlHbnVtUVFa?=
 =?utf-8?B?UmlJdlNWS0E4UVBhV2F1ckpQS1NpTXhINVlGSng1UkNUbXdqVElma2phdmI4?=
 =?utf-8?B?OFZTU3h3VUg2S216dUdJbVgwSlFUTkxxRnlsTTQ4Rk90S3pFdEpsb3p2ZkFs?=
 =?utf-8?B?dE5jNzN4SGhtVTdzczZGUlJUcklQaWROL2s3LytYNE1UOUJCekdRNG5rdHRG?=
 =?utf-8?B?eWdWQzg4MmJEZmtnNzRkVGxDYjF0QTZSMUVvVjloa1NSRnFvbllzaXByY3Vz?=
 =?utf-8?B?Y3F6SWg0NEZETEtFaTIxYVFjNWg1UGJvQWJObm5TV24vUTdhSk43L2JoOWI3?=
 =?utf-8?B?SmVUWEFRUlNKd1pxSERaOFF1ZHprZVZlUEVtTGtUWlNmY3V3SC9vMnEvb0cr?=
 =?utf-8?B?TkxTTUhkbExrTmhVOVFuWmdtd1lENnhsaXBZRXp1ZGtQYjRJZUZucE8zMUNn?=
 =?utf-8?B?UVRIS2R1NDJwMXoxekZFZ3B0NW13MFFJQlh5ZHZNZUZkZ0FmQkhqUnRzUlE2?=
 =?utf-8?B?NENjUGQxQmc5K2xrSjJDK21maDdZcHBLdjhYWkdPN3dEQ2ZHek5xeFk1VDBz?=
 =?utf-8?B?NFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c648f62e-0335-4630-104a-08dd87f7ed97
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2025 15:01:47.3172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GaU6U9TYCTPfCb0/OXbBXOvugEp5ozJ3QJWMrpXgZL0wlGBckNFF6e74z6SmRhZvNT1cDOeBRc2q8Am+rKZrCbM2sme6++TVfjBmyjDUNhA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8279
X-OriginatorOrg: intel.com

On 4/28/2025 8:36 PM, Edgecombe, Rick P wrote:
> 
> KVM_GET_XSAVE is part of KVM's API. It uses fields configured in struct
> fpu_guest. If fpu_user_cfg.default_features changes value (in the current code)
> it would change KVM's uABI. 

Not quite. The ABI reflects the XSAVE format directly. The XSAVE header 
indicates which feature states are present, so while the _contents_ of 
the buffer may vary depending on the feature set, the _format_ itself 
remains unchanged. That doesn't constitute a uABI change.

> It should be simple. Two new configuration fields are added in this patch that
> match the existing concept and values of existing configurations fields. Per
> Sean, there are no plans to have them diverge. So why add them. 

I'm fine with dropping them -- as long as the resulting code remains 
clear and avoids unnecessary complexity around VCPU allocation.

Here are some of the considerations that led me to suggest them in the 
first place:

  * The guest-only feature model should be established in a clean and
    structured way.
  * The initialization logic should stay explicit -- especially to make
    it clear what constitutes guest features, even when they match host
    features. That naturally led to introducing a dedicated data
    structure.
  * Since the VCPU FPU container includes struct fpstate, it felt
    appropriate to mirror relevant fields where useful.
  * Including user_size and user_xfeatures made the VCPU allocation logic
    more straightforward and self-contained.

And to clarify -- this addition doesn’t necessarily imply divergence 
from fpu_guest_cfg. Its usage is local to setting up the guest fpstate, 
and nothing more.

