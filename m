Return-Path: <kvm+bounces-58988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 92D35BA92A2
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 14:11:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 53FDE1693CB
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 12:11:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7ED4305964;
	Mon, 29 Sep 2025 12:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C2CYnLkR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09352FD1DB;
	Mon, 29 Sep 2025 12:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759147857; cv=fail; b=maX3zZo3NXD3FNm1Bz9MUfDr3drlVBQ7481rfBW7OxeDR8KKJB5DxZ9xI7VpnDO5Zmxolgzdl6C95o+m8uYW/v6+ijonJnJS57cA54XjT2k98e/erXa/NMKCMm53b/QaQSsJNdExVj1TV1m+fH5WMMIz+GiV3NFpUBAI3Tz2H9A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759147857; c=relaxed/simple;
	bh=0YX0BVGYgelvwvpADTE6K4L2yT9K+jwrucak51lgm2s=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bMzm1PLEGzGEi6SK0ar0o56jKotIOZ49+k/RUVeL25qQNVv9CYXR5Yx9vBHWf1zlMxkzCb8SU2c9nwYm9wM10nRY4L8n8f70XY1hMIAO8JbaGIfseuNuPxCQaG1yxRPvDbCFrOYYXyU4uyUnnk/EuUmacR3huKcnWyMMmqy6RB4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C2CYnLkR; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759147855; x=1790683855;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=0YX0BVGYgelvwvpADTE6K4L2yT9K+jwrucak51lgm2s=;
  b=C2CYnLkRA8JdydwLPCwriIk6fAKjSt/5ogYCN8YfXQ9tOPCKRBDiwayL
   pRZYWtHDdgdNQ7djimUiSYvf/1fHkAtiMGYxCzwNTvvhm4N/4Z2s9WzQ6
   IruEP67fEQY+LX9wQooW3zPIxh2hC6jF9n8P0Y4pFgVZ5QK3Ezwvrqwsl
   rioODgsxKdW6ocNFjRjLRzD6U8H7bJ+vCZwiRBhoG0DHPWSB1m6lNREtJ
   t+FCn7gqmd0R8N4H/tR+iihbWRVyTKGl8I2XoCgiisCPCguEAAr8O3CwB
   CtAeVnGvMF9frR4mZRJRDvLupSVkwZYxoUEL5F8cVZRAyD0MejKLqZpRQ
   w==;
X-CSE-ConnectionGUID: m730UTuIR9CGK8bTto5xHg==
X-CSE-MsgGUID: 2I77qToYTjGKzk62t40fYw==
X-IronPort-AV: E=McAfee;i="6800,10657,11567"; a="72749601"
X-IronPort-AV: E=Sophos;i="6.18,301,1751266800"; 
   d="scan'208";a="72749601"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 05:10:54 -0700
X-CSE-ConnectionGUID: Rgbf6CFdRyaNhQQbddk2Uw==
X-CSE-MsgGUID: IT7QBEc8Tsu/DBvXbBOshQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,301,1751266800"; 
   d="scan'208";a="178603707"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 05:10:54 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 29 Sep 2025 05:10:53 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 29 Sep 2025 05:10:53 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.24)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 29 Sep 2025 05:10:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=osTfPfEimuAGcTv+vKMSslem9BMK+ZPgF23i8aXZglcyU5IU0Gdum6tnjvqtmW4ksOgNgvr9QGTP/6eiHld9o56i2/L26PXk1U1urPJkhVl7b4kS0DlCVYpr8PJ5Xyk+DesDwWfn1VOfl8Rqjm0FvB/fGMCtwgUqeWYqf62CpUqThDV9SfHv4yDw/lIq23v0xSpPV9cB3+4uu3hX4BePT7nfv0uZweMyrTcW9mD8FDNgrzzpMfP4pUT3FybLMItydnlmEAt6drIYckqFjuXyN6f5T4lxTguH9JGv+VxoVmY6MBxUi3IU911kmGCGkmooVE+3zFPxJ5OBiWEic8/I/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0YX0BVGYgelvwvpADTE6K4L2yT9K+jwrucak51lgm2s=;
 b=dHvgP0q291xpGXoPu0pzwLgWMo2eVpkCwd0178BM4ALIAfZhd3YPSHqndC0sJ5olLMRoq1eajuamZvRbIegO2mxraxI2qpBCd7KJ6dCFCxbinDBKs5sIBF+M7I+gUigvmpXT/UTD0KjZKuCsxeAqN3SL0HjN8El4l8ll+hkR0GWQp635KVTPDsCe1pVMm6ctK5D2jfGXRHjDLXUPnGQaWxwwIUERqTqSobF4ovdfIJManl6wSQkH3d8ilmC9zyouj4IRnHZ8Hnpj96JdBSAa6Ej6lYsWiZMwFaUEvo595tPMKdtoqMp77Ksm2BfLAsBMj0qtSaYHVpdiN/KqRyz+8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by MW4PR11MB6984.namprd11.prod.outlook.com (2603:10b6:303:22e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.16; Mon, 29 Sep
 2025 12:10:48 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9160.015; Mon, 29 Sep 2025
 12:10:48 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Annapurve, Vishal" <vannapurve@google.com>, "Gao,
 Chao" <chao.gao@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 12/16] x86/virt/tdx: Add helpers to allow for
 pre-allocating pages
Thread-Topic: [PATCH v3 12/16] x86/virt/tdx: Add helpers to allow for
 pre-allocating pages
Thread-Index: AQHcKPM4drSY0pNBrkCcT+2ZM9x02bSfFAOAgAcZ3QCAAxZxAIAA3fCA
Date: Mon, 29 Sep 2025 12:10:48 +0000
Message-ID: <4a3b48707b896d78b1cfa96ee5c20bece42b9503.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
			 <20250918232224.2202592-13-rick.p.edgecombe@intel.com>
			 <9e72261602bdab914cf7ff6f7cb921e35385136e.camel@intel.com>
		 <f1209625a68d5abd58b7f4063c109d663b318a40.camel@intel.com>
	 <9018c8629c921fae9ee993cd83b5a189616f51b0.camel@intel.com>
In-Reply-To: <9018c8629c921fae9ee993cd83b5a189616f51b0.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|MW4PR11MB6984:EE_
x-ms-office365-filtering-correlation-id: 09dd3b50-2ebe-4340-f995-08ddff5139c3
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?UW9pbVp4MVFUVVhDRXBReCszbGNhdlNmTUxUWTFGYU5RWFhldnpsTm8rb0ZI?=
 =?utf-8?B?ZzFicXN1bCtxM2l2SDdWUUgwMldKc2ltQXJ1YlcrTlBtbXpsa2s1TlJJczNW?=
 =?utf-8?B?ZkpIZEZ6ZmJTaDljMzE1V0xBcVJsY21NMGVsNEVxR2JMUXYvYVpwWXJQQmNL?=
 =?utf-8?B?TUFvb3RJWmpQZkx5NS94ZEhKUHd1ZHZPZ2NwU1A5dGhPN2hoV1cvVHpWd3VP?=
 =?utf-8?B?dDlaSzZOZ0YvWTNSQnVhTkhJdjNPU0E1eHMwMWhvZTJwdGo3djJuK2xQUXFB?=
 =?utf-8?B?UTJGNDdBUjFrM2RjSElVajBrTTZxcmtPck9BbXhabzByQWtuWmpmbXc1MHVq?=
 =?utf-8?B?TjNveGJ1NWpXUW4vWEprbW42MVRSRHJKdWtSSlJvMy9GVk9JRkxadTNzVkhO?=
 =?utf-8?B?ZUROK25mYnRsVmJLSUpVUFF0ZzBQY08xcW1RMUNLUjRGNmtaZDlBVGVxcGFG?=
 =?utf-8?B?UmpqVjZUc0FrQmtSYUtaQXBLSjdpckFENklQa1d3YXBSaEVaTVZuWEVCUHJP?=
 =?utf-8?B?WDcvTkhIdGlOdFZQM1NWSGNvbXUrVXRXMnlWYm02RTBQT1dyeU9UT0dNWEhP?=
 =?utf-8?B?L2VWQTVKRVZ0N0ZYRmdEZFVlaFRTcnFnVmxFeHBsYVVOOWRSVlJyWktHdUx3?=
 =?utf-8?B?V0pNdm41VUxPakwwUm9XZmdJbFd2N0dtbk4rRmZjSDk0WGJPQlk4c0tBMmVV?=
 =?utf-8?B?ckZRdDk4S1U5R090c2xzVUZTNEdQbkxjMFc4MUowcmVmZXJLYTYzTnNoQ0Q2?=
 =?utf-8?B?WjdpR3h6cUdaZWY4MGpHTk56TmVOU0FBRnJTcGNVM2ZWVFh6OWN4R3FnMDhB?=
 =?utf-8?B?ZDhBSWVud09xeXQ1dC8zL2NUYUtzZ1huMEU1dnU2MjZxdzB0Y2Z5aitCUUZw?=
 =?utf-8?B?MDhtd0ZVSnJ6UldCV2U1VXhpd0JPNk9lSG12a0xURlJzQW5yMUNoSTFOZkhO?=
 =?utf-8?B?L0hBUGpDS3g1eU00c3U1YmhUd3RqOWZlRG95aU1seWM3RnRCV3BZV1JFRlFM?=
 =?utf-8?B?bVQ5bTNKUDIrdUZQNGowejFESnJReHNWcGJWRFJhSk9uZFJ2UEZ3dnVPaFV3?=
 =?utf-8?B?TXkxczcyUEdCTElVU3BuOURKQzJCOXA3bkFxbWdmL2srN2dmZmZtNGpUcmhp?=
 =?utf-8?B?RVBPcm1qUk5IMXowK09TNmlzN3hIQW8rUHdFTVlVQmZmVml5Rjgrc3BscU0y?=
 =?utf-8?B?UFBqUHZpb0VzV1JMeUhKb0dFdTEvcktWTFNvcVhmQzNKZlBOeGg4dzhGNGlz?=
 =?utf-8?B?WGxDdHJLVXRBbEhiTXpjUE9ML3VGK3dXK1pIRHV2RDhoekJ5RndNSE91QnUv?=
 =?utf-8?B?STRlZEROaVVaU05lQjRGZ2pSTC8vWGZ3QkF2SkIrOXYrenVNOFlqTkJ2MFNa?=
 =?utf-8?B?KytMR0RjZ0tyYjRNT1BRb3NuSHV2T3dyYzdXVUtrc2IrMk1GQlByNytPT2xv?=
 =?utf-8?B?a2lBRUphUXlIT3p4a0FXczRSTWhHdnZvMHd6L08vcFRBdWJNemcwOHpYZzJF?=
 =?utf-8?B?SDBvSG0vbjF6NnJMWmExZkRYM055c1FXK1pONE1wM3pEK3ZYOUtNRFd6VnRX?=
 =?utf-8?B?QWFOWEhNRE1EWXBjUFc0c2VCM3ZHdWUyZ2ZDNlRrUU9KWnRRWnBqWnBlRllr?=
 =?utf-8?B?R2lGWXpzc3Z2ZVdtNHlkTlhVZTVaYTRSZ3NkMm5yaWVmVWc2bXc5ZllsNmd4?=
 =?utf-8?B?YUczTkdRbVZRazBudkRnc1BUWFUyUCsvOU43U1pFdTQ3NnpObStjZ1VONytq?=
 =?utf-8?B?K0NXanJMdDVWcnNaZnE0YllmS2dsOTBRSEd0ZENCUjEzcE96TCszRkhxd3U3?=
 =?utf-8?B?M3IyWjZvNzhrNDhYMTJsNjZkV25nOEtTU2lZNjZjNEhaaURJckVuckNXOWhK?=
 =?utf-8?B?eERqK0RwSmpva012b3JEeE9HS2c2dlozRGtOTjZrQSs2dTVOekc3d3NjT1gy?=
 =?utf-8?B?WTVORnFUajJZbE5tZDVpTDVxQ05PcWRoU3lvRE84Sm9KUW9iOVY3bjN5aWta?=
 =?utf-8?B?eGFqbTdVT2NLekl1L2oyTkJIdDFMWjdZektPSnkzUE4zeHp6VXljczRWTVlB?=
 =?utf-8?B?RjBRMWV2SGpRTDZBMk5McHNSV2hRNzNXaUZGdz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YzI0ZmdTT29yTXp2UE4yNlFnbUduVCtlMXBCKzdxcXlSY3N0MElTZUJreGw1?=
 =?utf-8?B?ZHVacWREK0UrYjd5YVdSb0lsNE5hbFlvckpNYVVoMlpHdWJTbmVOTXlnakk5?=
 =?utf-8?B?RWJXR0NoSWtYU0tXQ25CVFJHUW1LMVVsaE9mWm9GKzdSRkRTbHRkc1E5Zi9S?=
 =?utf-8?B?SnhvV2NJWmJiOWRsY3hRZGtQYlA2Ris5Rk42TWk3MzM5UnJLZUF1Q1RvWm93?=
 =?utf-8?B?UTZ1OUFoUkFKbWxLYW1kNXdsV0w1VFVSbnhvWUJQT0lmK2NSUlZDSTB5SFEr?=
 =?utf-8?B?LzRYT3RNblgwa0J5NmZUVHVZS3A0cDNJdXM3OERBeGU5cDZaQmc5Rkd0V1Br?=
 =?utf-8?B?Zjg4anpZY3NKS08vOU5OaWtCQkV5MlkzaXVYMXJRUDhGbWE3YnEvV1dPQjhC?=
 =?utf-8?B?eXREb1F1ZmJRNXd0NDNtaWN4Yll0TjVMb1hjaThid2ZHMDMzMHJkMDN1TmhN?=
 =?utf-8?B?VVZJRWFMdHZkQmhWWWttcXBFd3hpeXZHZFFpV0dSMjhWUVdxS3lmVk10T3Fu?=
 =?utf-8?B?ME16UU5jMmt2R3krT3UwS210NDAxYldaRUVUSDI2ZkJURnpkVXhBY2VKU05v?=
 =?utf-8?B?RjEyeDVPNW5BY1A1TzdoUmlFVktrMXBpeS9MbUFhc0VnN2ZpSjgwYS9HVzU3?=
 =?utf-8?B?RTNlVmM0c1AvTStUUm9YdlAxenFSNG5sc21Pem5jZ0JldnhreDRqbitIYW1w?=
 =?utf-8?B?SmtUZThVS0ZrSFJ4V1dpMU84NVBVVHM2bmtROUd0TUdhNjMrbUQ5U0hBR0lU?=
 =?utf-8?B?clMzdGpFcDNrY3hUUWFKNWIrall6S1B4THBNbUZhaWVKYnMwY1BaRnBUb0F5?=
 =?utf-8?B?a2JUU1lnNit3QllUZ2w0anZWU09IUVJ2U3U5OVZrV0R0dlRVcG9Yd2wxbXpY?=
 =?utf-8?B?UFd3UDIxcDdVb3UvR1FpdEpTTjh1MkNZaWJna2ZvQlB3QkNoV2xWTkhRdnR6?=
 =?utf-8?B?NkhmMFR6dXllNHRrTEhWc3lhdnQyYjB6ZnlmVUZpT3VkcU9acnVFT0trWHVE?=
 =?utf-8?B?WjFJQ29ZOFRySW1WV2VhanY2YUYxQ2xTSXJ6bHFrVG43RVJoaDU1MDNTa3NV?=
 =?utf-8?B?eEcvRDcwY2lBdXZ0K2JMaFBIQW45d015dkNjYnFFUnIzUURwT0ZSOGFtRncy?=
 =?utf-8?B?S1NFb05aRUlGbWFab2pwQTFLYVo2QkZaeHZZdFZwK2Zyand4a2tUQlJLTUc1?=
 =?utf-8?B?K2gwT3pqakFKTnhRQ09hL2s5TXlsQUoyQmJXVnJPZ0FGMFNtRXlRTTF4SCsr?=
 =?utf-8?B?ZkZYekVTdXc5eE9tNWZmMGhHbS9peS95QlZES3lSQlFjc0FTSWJRL0lidS9J?=
 =?utf-8?B?cjlnNFF2dkVNaE14NEFZc2ZMY3NSU0d0N3pZMjIrd0dRcVlXOEl3WkVTRWdE?=
 =?utf-8?B?aTFSZE80dTY1bTBVRExYSEhoY3l0QjlDdjNXcXlBQnI4SlBHQ3pTZ1dJOHVh?=
 =?utf-8?B?YlJ5QWU4bUJERGtMUXJQTFZRaFhyUGJqV3RTL2lTbW5jSXVBelRWbEtRZk1S?=
 =?utf-8?B?WGNTUU5SbmlrMkNKV2Z2SUFydkpVNkVCQnZ4c0gvUHluRitYVVB3THhBL1dt?=
 =?utf-8?B?S3VCMkhaKzU4ZnViS2dYWklObVZGVnY5enZOODhuU1hKZWpZdllFY3djN1Qv?=
 =?utf-8?B?T3A4STZUalk1QjRQSlM5Mlg2YWxFTzZJL0tPaTZRM1g4TStHYzRkN1pXckor?=
 =?utf-8?B?RWJ2aUFwNmljc2VVMWMvdXVvNi81ZjltVVFGWmFsakxibnRsSkE4WE5tdjBB?=
 =?utf-8?B?b1pJZ3RHRzJKa3QzMjNna3h0anovVXVVNFpGRE0rLzd4Y3dsTDI4QWRXamds?=
 =?utf-8?B?TXRKVGRIRGxNMHJxbXZTaFdWTW1zMTBLUHJGeGt1NW5Qa05ZQ0N5OWdmTjJQ?=
 =?utf-8?B?cUg2N3Q2eS9BY3BOT3I5YldJMDdDQkdrV2FNN1RkeStyVDdXbXVIQUVxbCt5?=
 =?utf-8?B?L0Ruc3Zwd0daMzFyMFFVb0JLdjhGWUtoZ2tNejllZW11RDNqS2w3TGhQUjhq?=
 =?utf-8?B?YUZSYnFNT3lHRDVjVVF4T1ZEM29XekNWeUNYZUJhUTVTM09nc3Z4V1RyVnlY?=
 =?utf-8?B?RjVMVDBRbnN1VHd0a1dSRHV3RHBVSmdVVXl3cytlL3F1YWd2WENYbE43MUFx?=
 =?utf-8?Q?/Svgs7Z59vIZO1aeIKDyQ0YsI?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4911F8464CCA0C4D961D414C0EA67C75@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09dd3b50-2ebe-4340-f995-08ddff5139c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2025 12:10:48.2630
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Bou4WdAbmRK/OT7NN3eXY+nngB796MM24Q/Z3hJtPhFKiE7pAodggUBLyTq9dKi5MxsqQzlJz+6CrUPEPfmibw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6984
X-OriginatorOrg: intel.com

T24gU3VuLCAyMDI1LTA5LTI4IGF0IDIyOjU2ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biBGcmksIDIwMjUtMDktMjYgYXQgMjM6NDcgKzAwMDAsIEVkZ2Vjb21iZSwgUmljayBQIHdyb3Rl
Og0KPiA+IE9uIE1vbiwgMjAyNS0wOS0yMiBhdCAxMToyMCArMDAwMCwgSHVhbmcsIEthaSB3cm90
ZToNCj4gPiA+IFNpbmNlICdzdHJ1Y3QgdGR4X3ByZWFsbG9jJyByZXBsYWNlcyB0aGUgS1ZNIHN0
YW5kYXJkICdzdHJ1Y3QNCj4gPiA+IGt2bV9tbXVfbWVtb3J5X2NhY2hlJyBmb3IgZXh0ZXJuYWwg
cGFnZSB0YWJsZSwgYW5kIGl0IGlzIGFsbG93ZWQgdG8NCj4gPiA+IGZhaWwgaW4gInRvcHVwIiBv
cGVyYXRpb24sIHdoeSBub3QganVzdCBjYWxsIHRkeF9hbGxvY19wYWdlKCkgdG8NCj4gPiA+ICJ0
b3B1cCIgcGFnZSBmb3IgZXh0ZXJuYWwgcGFnZSB0YWJsZSBoZXJlPw0KPiA+IA0KPiA+IEkgc3lt
cGF0aGl6ZSB3aXRoIHRoZSBpbnR1aXRpb24uIEl0IHdvdWxkIGJlIG5pY2UgdG8ganVzdCBwcmVw
DQo+ID4gZXZlcnl0aGluZyBhbmQgdGhlbiBvcGVyYXRlIG9uIGl0IGxpa2Ugbm9ybWFsLg0KPiA+
IA0KPiA+IFdlIHdhbnQgdGhpcyB0byBub3QgaGF2ZSB0byBiZSB0b3RhbGx5IHJlZG9uZSBmb3Ig
aHVnZSBwYWdlcy4gSW4gdGhlDQo+ID4gaHVnZSBwYWdlcyBjYXNlLCB3ZSBjb3VsZCBkbyB0aGlz
IGFwcHJvYWNoIGZvciB0aGUgcGFnZSB0YWJsZXMsIGJ1dCBmb3INCj4gPiB0aGUgcHJpdmF0ZSBw
YWdlIGl0c2VsZiwgd2UgZG9uJ3Qga25vdyB3aGV0aGVyIHdlIG5lZWQgNEtCIFBBTVQgYmFja2lu
Zw0KPiA+IG9yIG5vdC4gU28gd2UgZG9uJ3QgZnVsbHkga25vdyB3aGV0aGVyIGEgVERYIHByaXZh
dGUgcGFnZSBuZWVkcyBQQU1UDQo+ID4gNEtCIGJhY2tpbmcgb3Igbm90IGJlZm9yZSB0aGUgZmF1
bHQuDQo+ID4gDQo+ID4gU28gd2Ugd291bGQgbmVlZCwgbGlrZSwgc2VwYXJhdGUgcG9vbHMgZm9y
IHBhZ2UgdGFibGVzIGFuZCBwcml2YXRlDQo+ID4gcGFnZXMuwqANCj4gPiANCj4gDQo+IFRoZSBw
cml2YXRlIHBhZ2UgaXRzZWxmIGNvbWVzIGZyb20gdGhlIGd1ZXN0X21lbWZkIHZpYSBwYWdlIGNh
Y2hlLCBzbyB3ZQ0KPiBjYW5ub3QgdXNlIHRkeF9hbGxvY19wYWdlKCkgZm9yIGl0IGFueXdheSBi
dXQgbmVlZCB0byB1c2UgdGR4X3BhbXRfZ2V0KCkNCj4gZXhwbGljaXRseS4NCj4gDQo+IEkgZG9u
J3Qga25vdyBhbGwgZGV0YWlscyBvZiBleGFjdGx5IHdoYXQgaXMgdGhlIGludGVyYWN0aW9uIHdp
dGggaHVnZSBwYWdlDQo+IGhlcmUgLS0gbXkgaW1hZ2luZSB3b3VsZCBiZSB3ZSBvbmx5IGNhbGwg
dGR4X3BhbXRfZ2V0KCkgd2hlbiB3ZSBmb3VuZCB0aGUNCj4gdGhlIHByaXZhdGUgcGFnZSBpcyA0
SyBidXQgbm90IDJNIFsqXSwgYnV0IEkgZG9uJ3Qgc2VlIGhvdyB0aGlzIGNvbmZsaWN0cw0KPiB3
aXRoIHVzaW5nIHRkeF9hbGxvY19wYWdlKCkgZm9yIHBhZ2UgdGFibGUgaXRzZWxmLg0KPiANCj4g
VGhlIHBvaW50IGlzIHBhZ2UgdGFibGUgaXRzZWxmIGlzIGFsd2F5cyA0SywgdGhlcmVmb3JlIGl0
IGhhcyBubw0KPiBkaWZmZXJlbmNlIGZyb20gY29udHJvbCBwYWdlcy4NCj4gDQo+IFsqXSB0aGlz
IGlzIGFjdHVhbGx5IGFuIG9wdGltaXphdGlvbiBidXQgbm90IGEgbXVzdCBmb3Igc3VwcG9ydGlu
Zw0KPiBodWdlcGFnZSB3aXRoIERQQU1UIEFGQUlDVC4gIFRoZW9yZXRpY2FsbHksIHdlIGNhbiBh
bHdheXMgYWxsb2NhdGUgRFBBTVQNCj4gcGFnZXMgdXBmcm9udCBmb3IgaHVnZXBhZ2UgYXQgYWxs
b2NhdGlvbiB0aW1lIGluIGd1ZXN0X21lbWZkIHJlZ2FyZGxlc3MNCj4gd2hldGhlciBpdCBpcyBh
Y3R1YWxseSBtYXBwZWQgYXMgaHVnZXBhZ2UgaW4gUy1FUFQsIGFuZCB3ZSBjYW4gZnJlZSBEUEFN
VA0KPiBwYWdlcyB3aGVuIHdlIHByb21vdGUgNEsgcGFnZXMgdG8gYSBodWdlcGFnZSBpbiBTLUVQ
VCB0byBlZmZlY3RpdmVseQ0KPiByZWR1Y2UgRFBBTVQgcGFnZXMgZm9yIGh1Z2VwYWdlLg0KDQpB
ZnRlciBzZWNvbmQgdGhvdWdodCwgcGxlYXNlIGlnbm9yZSB0aGUgWypdLCBzaW5jZSBJIGFtIG5v
dCBzdXJlIHdoZXRoZXINCmFsbG9jYXRpbmcgRFBBTVQgcGFnZXMgZm9yIGh1Z2VwYWdlIHVwZnJv
bnQgaXMgYSBnb29kIGlkZWEuICBJIHN1cHBvc2UNCmh1Z2VwYWdlIGFuZCA0SyBwYWdlcyBjYW4g
Y29udmVydCB0byBlYWNoIG90aGVyIGF0IHJ1bnRpbWUsIHNvIHBlcmhhcHMNCml0J3MgYmV0dGVy
IHRvIGhhbmRsZSBEUEFNVCBwYWdlcyB3aGVuIEtWTSBhY3R1YWxseSBtYXBzIHRoZSBsZWFmIFRE
WA0KcHJpdmF0ZSBwYWdlLg0KDQpTbyBzZWVtcyBpdCdzIGluZXZpdGFibGUgd2UgbmVlZCB0byBt
YW5hZ2UgYSBwb29sIGZvciB0aGUgbGVhZiBURFggcHJpdmF0ZQ0KcGFnZXMgLS0gZm9yIGh1Z2Vw
YWdlIHN1cHBvcnQgYXQgbGVhc3QsIHNpbmNlIHcvbyBodWdlcGFnZSB3ZSBtYXkgYXZvaWQNCnRo
aXMgcG9vbCAoZS5nLiwgdGhlb3JldGljYWxseSwgd2UgY291bGQgZG8gdGR4X3BhbXRfZ2V0KCkg
YWZ0ZXINCmt2bV9tbXVfZmF1bHRpbl9wZm4oKSB3aGVyZSBmYXVsdC0+cGZuIGlzIHJlYWR5KS4N
Cg0KR2l2ZW4geW91IHNhaWQgIldlIHdhbnQgdGhpcyB0byBub3QgaGF2ZSB0byBiZSB0b3RhbGx5
IHJlZG9uZSBmb3IgaHVnZQ0KcGFnZXMuIiwgSSBjYW4gc2VlIHdoeSB5b3Ugd2FudCB0byB1c2Ug
YSBzaW5nbGUgcG9vbCBmb3IgYm90aCBwYWdlIHRhYmxlDQphbmQgdGhlIGxlYWYgVERYIHByaXZh
dGUgcGFnZXMuDQoNCkJ1dCBtYXliZSBhbm90aGVyIHN0cmF0ZWd5IGlzIHdlIGNvdWxkIHVzZSBz
aW1wbGVzdCB3YXkgZm9yIHRoZSBpbml0aWFsDQpEUEFNVCBzdXBwb3J0IHcvbyBodWdlIHBhZ2Ug
c3VwcG9ydCBmaXJzdCwgYW5kIGxlYXZlIHRoaXMgdG8gdGhlIGh1Z2VwYWdlDQpzdXBwb3J0IHNl
cmllcy4gIEkgZG9uJ3Qga25vdy4gIEp1c3QgbXkgMmNlbnRzLg0K

