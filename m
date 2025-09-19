Return-Path: <kvm+bounces-58107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A45A1B87970
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 03:27:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F3AB317C45D
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 01:27:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F7BD233D7B;
	Fri, 19 Sep 2025 01:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YqpBxqu/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E981A9F87;
	Fri, 19 Sep 2025 01:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758245221; cv=fail; b=fmdxDce0LjrmcZRf/ZHkkmFBdvuyWxM1Orv5qum6AqBVsvTgoa2iil2VTKgZfPuMmwVO9Beb8vEXdtyed44SMM4jBtRm+b2XX4IOLJkrJkxQJDsS+sQmmOD+52nDxcRUbivShf8/UW77KR0J8vhUQP5QVkj0J5XidbB7YvA/gho=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758245221; c=relaxed/simple;
	bh=7lOxt8FpjnMumvcrkZ1AhdWBFJD5OM+Jjy+EnN1Mz8o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bjk2S1TrkM81P14nqrAyeMbKRgkpC/wllmh/vW/LWnRfayWHjZOngWQf8g7yi42uq5yxC9JLCeCiXH8SSYPCSrmsl7gPfpLLD/6QSuLy2sOqzXgFjaKsN33h5X7p4o9PySSJTVJiQbMP3gaGuHs4BfGVwKyFZyCCkpCTyVW+3+A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YqpBxqu/; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758245218; x=1789781218;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7lOxt8FpjnMumvcrkZ1AhdWBFJD5OM+Jjy+EnN1Mz8o=;
  b=YqpBxqu/REc5YK5ljAca+MD2AlYdaErv3TrgtCwXWMSlRa8r8N2+l70f
   kIwPvvO11lbvYHP8m6Iiur2bkSYjijw1ibl2ccQg0Lc5dJYTVIPqaQyh9
   wo9DOyTEm1Wbj46uZlSq8IxV2rqsSUKZ9VRAThRZxWbXHoSRrdBPL/cFE
   4Xln3bjjWIPrmqwZAfoP4VKsOrgWNx/8PWqSaNgC0XrCBsaLV3k1IkC/0
   fxepK5fdqViiOXUOSQqUyjrJFmNq4n1RWuTNg3vdkwdugMvPuxtAG7RZA
   IW5IV5tXRGhs/CZbQLvf/V6jkE+ECFsodV7dW8QoFiJCGLXGtu1g7TZFU
   Q==;
X-CSE-ConnectionGUID: Kv7QCQGTSeWgLpgmwkNFaQ==
X-CSE-MsgGUID: zykkNyhURKiJR57Tql3Cag==
X-IronPort-AV: E=McAfee;i="6800,10657,11557"; a="86029677"
X-IronPort-AV: E=Sophos;i="6.18,276,1751266800"; 
   d="scan'208";a="86029677"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 18:26:57 -0700
X-CSE-ConnectionGUID: 3q1TRIrdRjq0uqg+LUifAA==
X-CSE-MsgGUID: uuveskweTYmO+m+J0BT7Yg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,276,1751266800"; 
   d="scan'208";a="174962122"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 18:26:56 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 18 Sep 2025 18:26:55 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 18 Sep 2025 18:26:55 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.12) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 18 Sep 2025 18:26:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Obd+/QHFGOUAyV5gk2HmEzyW8G7WDaIYl2zZxu0mgL6cVoddFNbhcQuidZHxth8koZo69S6iDD3zOCDOXiw5i5Cpu6clsnZ/6jPxlME3OlAf8tyYNPtC00Uq99ae1/ySVc1f8Ug3xztb+B8xPHfbjxkUzyq99OUhy/2LTVtdInW/iVrLXzAafOPxLAKoyjgLYxIjuOsEjhnvPFkarhnvVFNZePeTPREF5EOWLIr5LItUgvpXR97nm5tUx65BVFD3WhWdqyhGZCBOO65SIXd5Rv4xNVQ6hYLXZhmQPoot6+ORrtD1Vr/xHP2QJT4Ryu7F+GMTWS3AJUn8A+RXZat6kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7lOxt8FpjnMumvcrkZ1AhdWBFJD5OM+Jjy+EnN1Mz8o=;
 b=l81F6/cylIm+ITVr4ZB5YjxR3i4coDDW/mZGn+4xzg3CJt63a2kKzxDwxYTtd8oL9gTemFCNzK21b3bZuIn33ScxNkJ0cti6VspiulqSm4v+jdXn+bnd79Dxfy4jHP7piA6AtlDXjAEGyR8mCtrgMmNM6aoqX53I1PzRb/Dh+bVViUqf4Uq3VXwKeAaPOyKZiZC+N9UZLDQRorFASScwJUP11UUOMalempZ+hLJ4YXzhJC7eZqYk6QIlJaXMtrjoqBarf8Jqse2Mq3DAsafbP3UO7cjLeUdjWBKq8qwYmsYkNgwmHmUpm/ePx5GGBJ2jIHKUc2ea0Dat4EWh1iefIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by IA3PR11MB8920.namprd11.prod.outlook.com (2603:10b6:208:578::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Fri, 19 Sep
 2025 01:26:48 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9137.015; Fri, 19 Sep 2025
 01:26:48 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Annapurve, Vishal" <vannapurve@google.com>, "Gao,
 Chao" <chao.gao@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
CC: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v3 02/16] x86/tdx: Add helpers to check return status
 codes
Thread-Topic: [PATCH v3 02/16] x86/tdx: Add helpers to check return status
 codes
Thread-Index: AQHcKPM0kXS09sIYlkqJ3JhsHYvc/LSZtwQA
Date: Fri, 19 Sep 2025 01:26:47 +0000
Message-ID: <430fc8f43b049c337b1268d181751280dcb09b33.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
	 <20250918232224.2202592-3-rick.p.edgecombe@intel.com>
In-Reply-To: <20250918232224.2202592-3-rick.p.edgecombe@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|IA3PR11MB8920:EE_
x-ms-office365-filtering-correlation-id: 2069b148-0c92-4cc5-d1f6-08ddf71b9a4c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?dlFxaXFsM1ZGM09wZHdoUnZvUDR0OXJJSCt0cW4vbFJuQjhKVzh6M2tOeHlp?=
 =?utf-8?B?UkpKUUFOR0dseGdraUdXc04rTDkrR3JKYXd5djBuQWhINktvWGNGMFZWdnh5?=
 =?utf-8?B?aEt4eExrK3NoTDd1Y3V2Z0FIczZNRTJ3SWhrZ1pteGdRTzJITGQwUGNZTngw?=
 =?utf-8?B?WkMyK2Z5aXcxZ09VbUFUOUVpbGozVkJhMUFGQnhTbUVoNU4zbFNBS3FEbUFX?=
 =?utf-8?B?dnRLSE1mZE50bWI2djlMVDNNOVRmTnIxSFNBWkFNVEdTZ2lBK2RRTWNwZlcv?=
 =?utf-8?B?R1E2MGlGT0NOL3VKb2FBRHNwNWdtd01QVXlnWUdBWVk2MmVCbWxHV0dXUTRy?=
 =?utf-8?B?UVdEN0dnOXF2MUdxNm5vSHQyaDhkQXRhTGZ1MElOeWplNXdUL25BR3o3cENO?=
 =?utf-8?B?RjczMzRKUVJnRzd1bktpMzRaSFo0WnZ5dEZCNEZPMUZxUXAxU2tnbEgrQlFs?=
 =?utf-8?B?enh0MGxQMFBGZHVKNHpLMmRJT3IycDVjZlBDaGswY291Y1BIZmZvYXZHZ2hG?=
 =?utf-8?B?R0pINmxLenhpbVhNR2RURHRnVTE5b2VhcHJsTlpLc3djL1Y3YVQrUmdUQnhP?=
 =?utf-8?B?cEJTaW4rQVFJVEcwNE4zb3RUVy9uQ2ZMT21hbnQ0aDR2a2pmMHg0VEZkWG5K?=
 =?utf-8?B?Yk5IYzVWN3pESXZwWmJIbjMvdHR4Qm94SVY4VE9XSmF6cWVsd2FiSG5IZTls?=
 =?utf-8?B?NnpkRFZOZTJyTGhSZmtWVm1ETy8xU3pGbEIzQUsxNHFIVkE4SkZ4ZVI5d2xq?=
 =?utf-8?B?dkFRVytDTVZkM2Naa2pvOFhKRzdPTUxOTnVQU2JDUm44QVB2b0dnbTZhbzVG?=
 =?utf-8?B?TC9CV0FUQ2VmeTVHbE53RVNUV3hBMDVmR3NTUlpGUjlRRWJJWEY1YUlzRTlp?=
 =?utf-8?B?aVJKQ2xWSWg4RXVQTTVWSVNjRjdWU3J5SHNFN0lOR1BJRDJCaDFMajFrQkRk?=
 =?utf-8?B?Y3pXV2RiRFRPdDFoQmtjeEsydkNhbGUrZUF3Z0I3SGFhTHlWcTM2Ukh6eWhN?=
 =?utf-8?B?dmFWYmVhQk5LZldOKzZydWRmY3BtazBMTVBvQ1hpR2h6SThQQUtHaGw4dW9M?=
 =?utf-8?B?UFBqRVozSlRFL3doRGhvRk8veUhEUXZ4OE9PZkpzWllQMkh4WFRyUTJzQjRn?=
 =?utf-8?B?OFBLQVpIQXVUR3RlOE53NW5Pdmkyc1JkNWY2RUx0WW5scEJDVm5NQVB5ODMy?=
 =?utf-8?B?OVdCVGwyMGhhOVR5LzRXUm1nZ3k2czhXRDdMUzhJd1BlR2w0U2g5b0lzZFVz?=
 =?utf-8?B?bmJSNHdhUzdvdTA4cmlOdDZwTzB0U25ZaWk1SGl1SFlKb2xDN0U1NWMvNm9k?=
 =?utf-8?B?MnUzaS9MdDNxUFdWQ0hCR2JXdEorblZKdFFuV3RPUVBETHR1SDFtZ3JRR0hH?=
 =?utf-8?B?VGRCNWJlUVh1UjF1bmtBNnJ3VHQ3dS94WHNnWktTYzYyQ3pLN3VLZzE2UmJk?=
 =?utf-8?B?RG1uY0l4RHNiWGpHcWxZY24rK29DbGNydmtOZGt1amM0Ly9lRG00L2orVEdJ?=
 =?utf-8?B?dE9mb21sVHlURi9sSXU0WG1tUFRHSXQzdFk1Lzl0LzFmbkRDcERBck1lZmNF?=
 =?utf-8?B?LzJ1bEwvVHcxSDU5bk1naUhMQTZacER1U2hXbXBLenFiLzgweUNuYnF0K1B4?=
 =?utf-8?B?a1V2dmJtangvQkY0eWR1eUUwY09ORitjb2U1NWhIQnc1QzNIM2tHbHRVcUR4?=
 =?utf-8?B?ZmRtZkxUaC9FTGdHK1RGZHhxUWxDcFZvQk9zZEFxd3c1L1p0Y3krUXVSK0RO?=
 =?utf-8?B?Yi9mdHV0anhVTkQzNnVqODhkMGFHMWVxZkxlOVEvcjdCNUxtdVlYZXJXa25O?=
 =?utf-8?B?RC9PVUVuNmdCWmEzQ2lveUFBT1B0TGVEVVUwQ1VtQ083RVJMYVdZdHRLTnhU?=
 =?utf-8?B?WjZIMG1XN1F5K2lCUU4xUjQ0QzNDaEdBdjBRbDl4aEtmRGVHZnFTakgrQUFC?=
 =?utf-8?Q?eNV4fjFuzKNlV1oq8TyOeNbRAiTsF2h+?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eGpPQktTNi82QlJsSzdtZFlnekx5VTluNlFjd2lyekhFZjFwcU55TXN3YjRr?=
 =?utf-8?B?NTBaWnZuc3k3SDRneXZDUDB1SGovd1BkTWd6WlBiYkVCTGhROVFUUzl4TG9w?=
 =?utf-8?B?bW5ZaWdhRkVzNkNhUEUrTjZjb0xzaFpHaEFjWVQvQXJ4RWdsMVBDcElVcmI3?=
 =?utf-8?B?c1h0KzNvUXJDTVI0dGNIakNSQjFIRjcyakpJYWJBVmFDWk5HZnF0Ni9ZdlFx?=
 =?utf-8?B?RmFaYi95b0lQVFJ5Mnc5bUdObFRHMmNzd1d1ZktXNFZsWWo5eGZpakpJcE12?=
 =?utf-8?B?elNGdnhCQ3FFeG93NXY0NWNJRmZCSmxLc2xONFIzaUxvSllvUEZkSGJpZHdW?=
 =?utf-8?B?blk2ZUJHc2FoMWtVdEViZlNwNXB6MVhFaGwrUHdEQWI2ZkhUaThrT010cUVk?=
 =?utf-8?B?dVI2TEtHMTlhUW5XODFHYk84bU9TYXVYeGdkNFRVWm1Cd1kxNmpKVmJ0b3pi?=
 =?utf-8?B?ckZvTXRFTXVNS2J2TjRMbS9ES2JJcS9qK3F4Ni9PQzhMRzdhcUUxYmk2em84?=
 =?utf-8?B?bU00dlhRbldOcmY1SzBzeGtiMWtCeVpRUmRPUUhoK0VXWHFsd1pybDYwQnFa?=
 =?utf-8?B?SDF0aU4rQllNNjBUTHJydWEvSXhjRXdWUEY1ZGFtL0JwUE1wZ1IvWG5RVzN1?=
 =?utf-8?B?d3Q3QTMwM25USjc1Qkdhd3AvazI2YUtaTkp4K3lsbWVhMWhlSVVxcHpSejls?=
 =?utf-8?B?ZVdaeTVtYWhTSEIyUDdJUC9jOGNIbGs4NmNBTGVaMHY2YW1SMG9zYWVMUWtF?=
 =?utf-8?B?L2ZrZ2xsUC9ZQmdleUVJbnd0YmtuY1AvdU1aM09jeW9PektubDRPU3J2ZWVz?=
 =?utf-8?B?MXFmNE44TzkrVEpyalJ5cDZOUTZGcXRNZmgwR3FxSFhIWEcyNEdHVjdCWFJ6?=
 =?utf-8?B?d3RBVXhvbC9WYzlBQTRrMm51Z1N6eHVkaEdMRFhhQ09WOVFYWEFJeW5OdHA0?=
 =?utf-8?B?R1ExY0M0ajVhZ29ad3NPNExHdkxMYzlpMmcxbU9RN3Q5bUl3RDhUQUlvNjl1?=
 =?utf-8?B?L0pPTU9yRTI5WFVaNWp1KytCTXV0WlFWdkp6Ti9TTTY1c21NTzAweDRKS1J1?=
 =?utf-8?B?RWRxNEthODc3blNUditURzdMYlhwYjVaVEljY0VUWlJNQkhEWGNTV1lmVHV2?=
 =?utf-8?B?RzE5SCtldnVCMFdHdGowckdpSDNQMlU5eFJhSzRuOFRNOFJIaThpSW5RcXZr?=
 =?utf-8?B?ZEpqM1QrWmRjdzFnWXZ5QXpVMzVreHVFQ3BEU3lwTi8xeWhTR1M1aXFXNkt4?=
 =?utf-8?B?ZFRRa3VyMGhSaEFlczBMWE5wVURKQXpEQlUrVXJEazJDTHlTWlFRTFVRVmlt?=
 =?utf-8?B?c0FUSllvNWxKZFVhKzJtdml3UFRVQTNzNnI4dFVoRkxwQVJsckVzSm55eEly?=
 =?utf-8?B?UTZtN08vRS9rUnRGRHE0a2dtS0ZHNEw2N0lPbzhySDlscmxmWVVUT09XWFha?=
 =?utf-8?B?U1NrbFhzbmxtU1NvekhFRHBJTTdxZG92Mmw2UlVnSEZUbU0rcHVCcEhsMnl0?=
 =?utf-8?B?RGFCUEJvOVR1TGJVWmNVSi9DL3JNdlVwR1VFSDNpWnQzTkdiOTBXU2FUYWo5?=
 =?utf-8?B?ZWtndTljSk1nM0VwbkhCRXlMbHJyM290Z05VV1dTRTN3RytGTFIwZlFNMWxC?=
 =?utf-8?B?QlE2VGM1cW1GQWJJQzdIVlhvZktVb0FENHBOOFZ0a0Q4ZzdUK0lHZnh1c2M4?=
 =?utf-8?B?ZHJ4ZGYxbXFNN2V3M2VkZUd1OGtSMTF6V1hlZVJYN1ZIZE5xL2pVTnZBOEFa?=
 =?utf-8?B?SGgwbnFOZ09RKy9jK1lkNkFyNXpPNjQ0SlR2cHJCazkzUmUwY3F0alhjc2hp?=
 =?utf-8?B?VnM0NmU4Y1hlSjNrNnpEOW4vd3k3cHVYVUtZdjkyWlEvVjhDeXc4bndsYkNX?=
 =?utf-8?B?aVBkQXRPemt6bC93bDBwYXpPRHp3NkJQS0lsbFFPSE1PalVxSnpENmxUc0li?=
 =?utf-8?B?UHZpWEhuSHdMbXBON3EzVW5sWGZCdFhtTytIdms1VU4zaXV5Rys3MnRVWTFh?=
 =?utf-8?B?TVpsTktTcTZQQnVlTE55M1Jydy9EdjdzL3AzL2tlczNXcEpvUFl6UmwxRmh6?=
 =?utf-8?B?cS9leWhRbUFibElQVTdhOEszVjlPVnZFeFEyZnRIOC92RGpTQVVxNmIwY3dP?=
 =?utf-8?Q?KWJtgBA8PhiMse2L8H4FqRw4e?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5A768897C1A47E4F86B03CD67D1AF455@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2069b148-0c92-4cc5-d1f6-08ddf71b9a4c
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2025 01:26:48.1195
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aEAkMt5syPr5jObpf8yWENpYbEnBK++O+VvsudMX4H36INN7rTJj5yw/rO7xWrsMF4nGg0IGO6F/On9UwEomlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB8920
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA5LTE4IGF0IDE2OjIyIC0wNzAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToN
Cj4gRnJvbTogIktpcmlsbCBBLiBTaHV0ZW1vdiIgPGtpcmlsbC5zaHV0ZW1vdkBsaW51eC5pbnRl
bC5jb20+DQo+IA0KPiBUaGUgVERYIGVycm9yIGNvZGUgaGFzIGEgY29tcGxleCBzdHJ1Y3R1cmUu
IFRoZSB1cHBlciAzMiBiaXRzIGVuY29kZSB0aGUNCj4gc3RhdHVzIGNvZGUgKGhpZ2hlciBsZXZl
bCBpbmZvcm1hdGlvbiksIHdoaWxlIHRoZSBsb3dlciAzMiBiaXRzIHByb3ZpZGUNCj4gY2x1ZXMg
YWJvdXQgdGhlIGVycm9yLCBzdWNoIGFzIG9wZXJhbmQgSUQsIENQVUlEIGxlYWYsIE1TUiBpbmRl
eCwgZXRjLg0KPiANCj4gSW4gcHJhY3RpY2UsIHRoZSBrZXJuZWwgbG9naWMgY2FyZXMgbW9zdGx5
IGFib3V0IHRoZSBzdGF0dXMgY29kZS4gV2hlcmVhcw0KPiB0aGUgZXJyb3IgZGV0YWlscyBhcmUg
bW9yZSBvZnRlbiBkdW1wZWQgdG8gd2FybmluZ3MgdG8gYmUgdXNlZCBhcw0KPiBkZWJ1Z2dpbmcg
YnJlYWRjcnVtYnMuIFRoaXMgcmVzdWx0cyBpbiBhIGxvdCBvZiBjb2RlIHRoYXQgbWFza3MgdGhl
IHN0YXR1cw0KPiBjb2RlIGFuZCB0aGVuIGNoZWNrcyB0aGUgcmVzdWx0aW5nIHZhbHVlLiBGdXR1
cmUgY29kZSB0byBzdXBwb3J0IER5bmFtaWMNCj4gUEFNVCB3aWxsIGFkZCB5ZXQgbW9kZSBTRUFN
Q0FMTCBlcnJvciBjb2RlIGNoZWNraW5nLiBUbyBwcmVwYXJlIGZvciB0aGlzLA0KCQkgICAgXg0K
CQkgICAgbW9yZQ0KDQo+IGRvIHNvbWUgY2xlYW51cCB0byByZWR1Y2UgdGhlIGJvaWxlciBwbGF0
ZSBlcnJvciBjb2RlIHBhcnNpbmcuDQo+IA0KPiBTaW5jZSB0aGUgbG93ZXIgYml0cyB0aGF0IGNv
bnRhaW4gZGV0YWlscyBhcmUgbmVlZGVkIGZvciBib3RoIGVycm9yDQo+IHByaW50aW5nIGFuZCBh
IGZldyBjYXNlcyB3aGVyZSB0aGUgbG9naWNhbCBjb2RlIGZsb3cgZG9lcyBkZXBlbmQgb24gdGhl
bSwNCj4gZG9u4oCZdCByZWR1Y2UgdGhlIGJvaWxlciBwbGF0ZSBieSBtYXNraW5nIHRoZSBkZXRh
aWwgYml0cyBpbnNpZGUgdGhlDQo+IFNFQU1DQUxMIHdyYXBwZXJzLCByZXR1cm5pbmcgb25seSB0
aGUgc3RhdHVzIGNvZGUuIEluc3RlYWQsIGNyZWF0ZSBzb21lDQo+IGhlbHBlcnMgdG8gcGVyZm9y
bSB0aGUgbmVlZGVkIG1hc2tpbmcgYW5kIGNvbXBhcmlzb25zLg0KPiANCj4gRm9yIHRoZSBzdGF0
dXMgY29kZSBiYXNlZCBjaGVja3MsIGNyZWF0ZSBhIG1hY3JvIGZvciBnZW5lcmF0aW5nIHRoZQ0K
PiBoZWxwZXJzIGJhc2VkIG9uIHRoZSBuYW1lLiBOYW1lIHRoZSBoZWxwZXJzIElTX1REWF9GT08o
KSwgYmFzZWQgb24gdGhlDQo+IGRpc2N1c3Npb24gaW4gdGhlIExpbmsuDQo+IA0KPiBNYW55IG9m
IHRoZSBjaGVja3MgdGhhdCBjb25zdWx0IHRoZSBlcnJvciBkZXRhaWxzIGFyZSBvbmx5IGRvbmUg
aW4gYQ0KPiBzaW5nbGUgcGxhY2UuIEl0IGNvdWxkIGJlIGFyZ3VlZCB0aGF0IHRoZXJlIGlzIG5v
dCBhbnkgY29kZSBzYXZpbmdzIGJ5DQo+IGFkZGluZyBoZWxwZXJzIGZvciB0aGVzZSBjaGVja3Mu
IEFkZCBoZWxwZXJzIGZvciB0aGVtIGFueXdheSBzbyB0aGF0IHRoZQ0KPiBjaGVja3MgbG9vayBj
b25zaXN0ZW50IHdoZW4gdXNlcyB3aXRoIGNoZWNrcyB0aGF0IGFyZSB1c2VkIGluIG11bHRpcGxl
DQo+IHBsYWNlcyAoaS5lLiBzY19yZXRyeV9wcmVycigpKS4NCgkgIF4NCgkgIGkuZS4gb3IgZS5n
LiA/DQo+IA0KPiBGaW5hbGx5LCB1cGRhdGUgdGhlIGNvZGUgdGhhdCBwcmV2aW91c2x5IG9wZW4g
Y29kZWQgdGhlIGJpdCBtYXRoIHRvIHVzZQ0KPiB0aGUgaGVscGVycy4NCj4gDQo+IExpbms6IGh0
dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2bS9hSk55Y1R2azFHRVdnS19RQGdvb2dsZS5jb20vDQo+
IFNpZ25lZC1vZmYtYnk6IEtpcmlsbCBBLiBTaHV0ZW1vdiA8a2lyaWxsLnNodXRlbW92QGxpbnV4
LmludGVsLmNvbT4NCj4gW0VuaGFuY2UgbG9nXQ0KPiBTaWduZWQtb2ZmLWJ5OiBSaWNrIEVkZ2Vj
b21iZSA8cmljay5wLmVkZ2Vjb21iZUBpbnRlbC5jb20+DQo+IA0KDQpbLi4uXQ0KDQo+ICsjaW5j
bHVkZSA8YXNtL3RyYXBuci5oPg0KPiArDQo+ICAvKiBVcHBlciAzMiBiaXQgb2YgdGhlIFREWCBl
cnJvciBjb2RlIGVuY29kZXMgdGhlIHN0YXR1cyAqLw0KPiAtI2RlZmluZSBURFhfU0VBTUNBTExf
U1RBVFVTX01BU0sJCTB4RkZGRkZGRkYwMDAwMDAwMFVMTA0KPiArI2RlZmluZSBURFhfU1RBVFVT
X01BU0sJCQkJMHhGRkZGRkZGRjAwMDAwMDAwVUxMDQoNCk5pdDogdGhlIHdoaXRlc3BhY2UvdGFi
IGNoYW5nZSBoZXJlIGlzIGEgYml0IG9kZD8NCg0KPiAgDQo+ICAvKg0KPiAgICogVERYIFNFQU1D
QUxMIFN0YXR1cyBDb2Rlcw0KPiBAQCAtNTIsNCArNTQsNTQgQEANCj4gICNkZWZpbmUgVERYX09Q
RVJBTkRfSURfU0VQVAkJCTB4OTINCj4gICNkZWZpbmUgVERYX09QRVJBTkRfSURfVERfRVBPQ0gJ
CQkweGE5DQo+ICANCj4gKyNpZm5kZWYgX19BU1NFTUJMRVJfXw0KPiArI2luY2x1ZGUgPGxpbnV4
L2JpdHMuaD4NCj4gKyNpbmNsdWRlIDxsaW51eC90eXBlcy5oPg0KPiArDQo+ICtzdGF0aWMgaW5s
aW5lIHU2NCBURFhfU1RBVFVTKHU2NCBlcnIpDQo+ICt7DQo+ICsJcmV0dXJuIGVyciAmIFREWF9T
VEFUVVNfTUFTSzsNCj4gK30NCj4gDQpbLi4uXQ0KDQo+ICtzdGF0aWMgaW5saW5lIGJvb2wgSVNf
VERYX1NXX0VSUk9SKHU2NCBlcnIpDQo+ICt7DQo+ICsJcmV0dXJuIChlcnIgJiBURFhfU1dfRVJS
T1IpID09IFREWF9TV19FUlJPUjsNCj4gK30NCj4gKw0KPiANCg0KWy4uLl0NCg0KPiArI2RlZmlu
ZSBERUZJTkVfVERYX0VSUk5PX0hFTFBFUihlcnJvcikJCQlcDQo+ICsJc3RhdGljIGlubGluZSBi
b29sIElTXyMjZXJyb3IodTY0IGVycikJXA0KPiArCXsJCQkJCQlcDQo+ICsJCXJldHVybiBURFhf
U1RBVFVTKGVycikgPT0gZXJyb3I7CVwNCj4gKwl9DQoNCkdpdmVuOg0KDQorI2RlZmluZSBURFhf
RVJST1IJCQlfQklUVUxMKDYzKQ0KKyNkZWZpbmUgVERYX1NXX0VSUk9SCQkJKFREWF9FUlJPUiB8
IEdFTk1BU0tfVUxMKDQ3LCA0MCkpDQoNCkkgdGhpbmsgSVNfVERYX1NXX0VSUk9SKCkgY2FuIGFs
c28gdXNlIHRoZSBERUZJTkVfVERYX0VSUk5PX0hFTFBFUigpID8NCg0KPiArDQo+ICtERUZJTkVf
VERYX0VSUk5PX0hFTFBFUihURFhfU1VDQ0VTUyk7DQo+ICtERUZJTkVfVERYX0VSUk5PX0hFTFBF
UihURFhfUk5EX05PX0VOVFJPUFkpOw0KPiArREVGSU5FX1REWF9FUlJOT19IRUxQRVIoVERYX09Q
RVJBTkRfSU5WQUxJRCk7DQo+ICtERUZJTkVfVERYX0VSUk5PX0hFTFBFUihURFhfT1BFUkFORF9C
VVNZKTsNCj4gK0RFRklORV9URFhfRVJSTk9fSEVMUEVSKFREWF9WQ1BVX05PVF9BU1NPQ0lBVEVE
KTsNCj4gK0RFRklORV9URFhfRVJSTk9fSEVMUEVSKFREWF9GTFVTSFZQX05PVF9ET05FKTsNCj4g
Kw0KDQpbLi4uXQ0K

