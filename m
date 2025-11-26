Return-Path: <kvm+bounces-64748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A425C8BE70
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 21:47:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F39D24E0448
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 20:47:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 288AE33F8B7;
	Wed, 26 Nov 2025 20:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P0BloqyB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5129278165;
	Wed, 26 Nov 2025 20:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764190034; cv=fail; b=mrACKIm7JgY/vL9caA2vPC9wv75lLuyBvQLWcriO/+IfhXcg9Aa/by2rRpGHzmyCfUSuTHYCtcbSU4DvFzolBQIR21TeANJmXshzM8dYkEQ44hTG7yAx7Wa2neUqOIzflHktkrU/l1fbXHGvAl5bFV2Fk1q+0VcB3CHJw2H/SE8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764190034; c=relaxed/simple;
	bh=lZrTo3RRdzkXts59h8edp85xastE56K0wLk3kM/pCVI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=J+xzoNbf5D0y991TJoU0vI+krfO/QyHMk5KZWoZQCSfG4jneUrqRoxcq2VSZ9AZ1ceHUpVuu2seQ8D/YJ+TOJPAUkKUPrtBvsHLyGTU13au0TKZDqI+/EarXp4+8LzhqnZGqmjqTI5bVarCgVfOa/n+zZ8D3S8UnnUg5Y3oymvg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P0BloqyB; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764190033; x=1795726033;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lZrTo3RRdzkXts59h8edp85xastE56K0wLk3kM/pCVI=;
  b=P0BloqyBevxwzwYHWAfzx+MSZvr89772kGVX9WW17629UWH140tJNsKl
   8iRb7VMu+3vXV1+ZhbK3AqnDXX4Ybj+GKsgm3bRD2tHn10yjCaQ/8L6pu
   ihNltknhZQ/UuDDIJz78Syr/T1vS6h06vuXXz1OnP7aa3XzlsPp4wnL07
   2ajwcBHD0Pb+xUjOjYrwvpCWoVuALe/LkzVYKv6ZRPpAM03HFygpbaqTQ
   kjkYLpNP90nCU3zXCYxgflGcK2hgMi2/+pVRcu0vZpo2dAwnVuw6rtG5r
   uAyXJGjvQh3ZLigbYmn/6d6URRb0GZDPw8FgWMSLSR7bOntA40kF+Hngz
   A==;
X-CSE-ConnectionGUID: OqVvFUmoRJywvWR8aL8GLA==
X-CSE-MsgGUID: aydVStcUQui/3KvAcq5gng==
X-IronPort-AV: E=McAfee;i="6800,10657,11625"; a="65422642"
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="65422642"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 12:47:12 -0800
X-CSE-ConnectionGUID: voWKh0kMR6Kp+bYL1yuoWA==
X-CSE-MsgGUID: cxbIKlA7S4iaKuQui/G/AA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="193270608"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 12:47:11 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 26 Nov 2025 12:47:11 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 26 Nov 2025 12:47:11 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.65) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 26 Nov 2025 12:47:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i1Y7CjHFqXh2bNo3g1wqy1YwpIrIhxMcDI0AAzTI/LD0j4SPYsbeVEPGcpgdyCuHC9LKg//Yb45KbHqKOF1JantGDbM3jgKMtAkEOGUEoeCuJ8H1ZwlmeFxgVDTRmn+jkj9jPnnNyzFPQHDvk2XagS8DbVCGCYUUpRUStmZbSn1oVBUJFB2jJ8456KopqCNqUNpR5bILtn99n49KWQtn+AJMx9Iu9vTZFYwFB8FA9QG1UIwbeYjRga/rqavkKWtFp7rU052LDflownPkBaHfZNE0ot4pQ6vf7Kaq4kDP8h4lDb+Ui1yEfzBELQRAUKhr2STd7bKmMiHpps3QBAUPog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lZrTo3RRdzkXts59h8edp85xastE56K0wLk3kM/pCVI=;
 b=EKkwYYc43bUhFUTQjm22clryrTQZiZ5nSGA/6FZloe1e8RRnnx2BDcaQ/vQe0aBJGUxhcem7CLl0xNSavjOa4VUjcM9dXC1B+jLqD2uX6vBA22H6tiyowt/XjAoifE9WjWWUXOxouNGKoCx7jZJHRb+DFBgkPwKg9y9JVpABvTA1DNNH512Hzn+jLMqWm5YuJFrIwifedP8u6rfuWhhJEurEFfGN72kCbIwSWWfw+48X1Ycmin6tF+lMvimBQ4xkQFM5ONGf/oKIAEEL8ZdvMK4FlYVHfAVlNjW4nGHoYOL1nIhQtKmBjDsiMCVDATH3coBqnrFBflvpScrfELHJzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB6378.namprd11.prod.outlook.com (2603:10b6:510:1fa::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Wed, 26 Nov
 2025 20:47:08 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 20:47:07 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "Gao, Chao"
	<chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>
CC: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v4 06/16] x86/virt/tdx: Improve PAMT refcounts allocation
 for sparse memory
Thread-Topic: [PATCH v4 06/16] x86/virt/tdx: Improve PAMT refcounts allocation
 for sparse memory
Thread-Index: AQHcWoEIX9Tgaj6+NEu+xgbyqcurk7UFEbOAgABk8QA=
Date: Wed, 26 Nov 2025 20:47:07 +0000
Message-ID: <7dd848e5735105ac3bf01b2f2db8b595045f47ad.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-7-rick.p.edgecombe@intel.com>
	 <b3b465e6-cfa0-44d0-bdef-6d37bb26e6e0@suse.com>
In-Reply-To: <b3b465e6-cfa0-44d0-bdef-6d37bb26e6e0@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB6378:EE_
x-ms-office365-filtering-correlation-id: 958b8bac-0627-42e1-87ad-08de2d2cf6fe
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?YXEvWWZ1bklRQmR2Z0pCWTJ5b0ZSMEl1QUt3a3lVRURzUWUvSHpjODFPdkRa?=
 =?utf-8?B?RUl5dHdDUkdRV0c0ZXlBdzE2bDhTVEJNWnZPUDd2dUQyOHc0cXZTa3FCcWpj?=
 =?utf-8?B?cTdLaSs2T1VBaEVIdDdYVjg3WG1RWnNoNWplbkFNN3IyWHJTa0tmdU5GOXV0?=
 =?utf-8?B?akt0djhSamJtd3g1Yk1KMjJWb0U5NDEzazhqTHJpTWlrYlZRSStVdGxnZ3N6?=
 =?utf-8?B?ZW5tS3VrWXcyZWJ1V3N1S1RMVkFUOU5JbkJ2MDZ3cVpZcWdQT3VYM2JlcFVq?=
 =?utf-8?B?WlhXaWZJak95MDVYUmhRSFJOcHJaMjNTbzdCeGNJZlo5WEo5T1RxQ1NyYVcw?=
 =?utf-8?B?SmdDampISlZ3dFdBeEh1T0t5elB2YTB3Sk8xL1FmdXc3b2hWY1l3TW9EKytZ?=
 =?utf-8?B?eHBLSDEzQ0N6dG9weG4yT3BqU3cyUDlPaGpMUUdESU9vSWNtS3MwbkJkYXd3?=
 =?utf-8?B?V0poV1VITjAyNlRTSFoyK1dPdXpJS3NrYW4xTmlBRWQwTElRaUVhWXh1cGI4?=
 =?utf-8?B?STQ2c1hrcGtTalNLV29VYkIxR051UFQ2bFB1VGJoOUNPMlJEY21CcWJEMFpB?=
 =?utf-8?B?RkRVeEFBNGpGYnVuQzBsVU5kK2l3U3ppaHVuZkN4ZklDdCtIY0R4NE1qV09o?=
 =?utf-8?B?WjJOazB5TUFaQUhiOUFCSFNMc0ZKb0VrVGJCdmc5bGpHSklrQ0RuTjhpMUMy?=
 =?utf-8?B?dmlYU0J1Y1dIdUNPcjc3YWlSL0RkVmE3THZNWEhyM2F3eEZSM0VvNktZWWhE?=
 =?utf-8?B?cDRvcFZpRm9vNSt6Szh3TFowclJPTXZ2b1VqZDVBZUUwVkNDclFsV2ExT2NN?=
 =?utf-8?B?VU5kWEVyWjM5QlY0amlxVHJHZXRHVm9BNEc3SkdrenJkeDRncGx1Ykl6SGRn?=
 =?utf-8?B?MXVQODNjRmVLeGNGcDdCQVQ4WnQzTjIxOGNlYjZmUGlXSG5wayswcFJuNmdN?=
 =?utf-8?B?c2xSQ0VhVDNLK0RmVXo1d0xkdDBOR0lFU3pKRm5LZExZcVhYdmxtZmVpSjQ5?=
 =?utf-8?B?ai93VjhtakRyWTdpd0tDdURVVHR2RHYzYVJ0bjRhM1pjTThrNi9RRTF5MlBD?=
 =?utf-8?B?U2cvbnk2UlJNc0pGbzNlQmdwWkRxNk9rVTZOZDlzOUUwdmlXcHJPRFQvVm5w?=
 =?utf-8?B?eFgvSnZYQ2xBcnRvVlFzbDhxaUNHTXdxY1pFVmJFc2FtdytHVURvcVVwRmtm?=
 =?utf-8?B?cDlHVFRwMTVLUTM3SXY3ZUU0VTN0bytrU0lVM0JvYXRTRDJIakxRYW4vcVNO?=
 =?utf-8?B?U1prZHI0d1IvVG8xcVZKRlVzSG5CNklZRkxKVnU4OG9JOWRDaFdqZ282RFFF?=
 =?utf-8?B?V3JqTUhDQzhHNmQzdnVaRitDWWV6UWFleXFRYjV1SHRHdCttdFJmbHRKSCtZ?=
 =?utf-8?B?ZldJSDd1ZEY4eUxNODNLQjNjMmJSSzVRSXNYcjA1V0d0TVA5S2doZFU1OW5X?=
 =?utf-8?B?ZExIZkpVeXNEVDh4d0c5eDc1YS9jNlZGeHBGRmxKaHFYR0p1RFdUWHJDZzRI?=
 =?utf-8?B?Mk5nU2VSLzBUblR1dkplYzRyckR4THp3NDIra3hpQUFQNG9QR212dzhneE1v?=
 =?utf-8?B?K1huT3JJeFllcXczRWdwRDJQakQxc09yZ0RRdFhtYzdYNHZrNTFMM255VUdZ?=
 =?utf-8?B?MWxiRG4yUHUrK3pXMTUvb1pYWTJUZ1ExZnlvU0dkd2dUZER0azZlQUx2dFdw?=
 =?utf-8?B?TWJObENTYTNDWDNpUnpMNitWZFoxMU9EZ1RERktmNnhyQUg3ZVdNREs3N1JQ?=
 =?utf-8?B?Zm5KdnlLNjQvRmV5akdHTjY3ZW93bVpTdHcwRU5HQ2FSS0RhempaVUVLejgx?=
 =?utf-8?B?bFY5eks3MWJyaWdzMm1xSlZjSjdlbk9HQ1Vsd2hQWUVWWDFnOUNqcVZ6a3pz?=
 =?utf-8?B?V3owOEdFVnp6ZWZab1AzUXRVdmQyWEZaazBnM1NLaThweXRoTnVKNitjSjZl?=
 =?utf-8?B?dE5saEt0akcxbXJwZk1GWWRlLzN6cTg4KzNxa1BFMGxmZFl0VUpBZDNZZDVU?=
 =?utf-8?B?WmVJdkdaOFdDT0ZwdEZjZ2JZdU5RdnppblZsdThxYjhka2VhSERXNzY5c0hC?=
 =?utf-8?B?Sk9XUmpKWU9sZFdoWi8yVUFIUTRNOGZNRVJCZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NjN3WmxRVmJ6eng4K0RFeHVoaEprUzd5b2t1SWlHMlNabk43ZXZka1BGVklj?=
 =?utf-8?B?bmQ0TGV1V0ZkRWFUajE0RG1lMkF3b0dGTzJHNUJVZmNteHcvck9DUmMydHBY?=
 =?utf-8?B?bUlZa0xTNjBWZEZ5OWdFMkI3WHVRM1lTTGJZV1RLbjdnVkJSQnI1azFCSXBF?=
 =?utf-8?B?N25qWk13Zi9yRE0xeEMxQmMzMm5OOEN6eldueEpneWxpSHpoK3JpcjVzTUhP?=
 =?utf-8?B?ZUoyMi9BMjc3L3FSeXFncWQzbzgvKzBzY2YycnJjQWFmcE44NWlFVDg1NFky?=
 =?utf-8?B?d1JMejdQclpBaERkUTh6T0Vuakk5WGhPdHhpRmJDS1cxRkJaQ1dhcUwvNGd4?=
 =?utf-8?B?SWtvRmdRRVV2ZDdRd1BWVUZrbDBlT3F4ZmlpQ3B3eXM2cU93OHllSlJzQjFs?=
 =?utf-8?B?MDhLcG9Pd2pLbkl4NVpUSTNHSnphcTFaSkNKNTd3K0x1VmU1dVB1dVE5TGJG?=
 =?utf-8?B?NTU4WUNBR0hmQVFGRkdFS1lOcmtPYTBKeGsySUhzME5jbGl3TUFKaWJiZG5N?=
 =?utf-8?B?UXBvNVFsRXkzclBhaGd1V29NTGxEUDd2TndvRy8zTG5Ka0JIZmJFVC9jYWcz?=
 =?utf-8?B?TmRLb2wrcGR3VTR6U1EvT2NzZlR4Y1k5U3ZVbFVBQ0hJcnhRU2VPcUdidVNn?=
 =?utf-8?B?dnR5YThjTWg5emtqbXJuRWtEQjNyL0MwUndJRGluOUEvYlR2aklrbkF1TWZ5?=
 =?utf-8?B?dEpLRk1ndzgrdVpITEpoZ1Npd1NVb2ZmSCs4SzY5dXoycnhFdEhLVEc4T2hW?=
 =?utf-8?B?ZkV4bTBwTnFaK09rQ0E3K1E5cXdWTkhuWnBnN29ZUmxGeHdPb2EreHk4cHdP?=
 =?utf-8?B?RFNqUzdzKzY4RnM2TldaQWx2aU13NThXL2xSMnhNS2R5NW05bzZrTTNzVEN6?=
 =?utf-8?B?Yy9DV3lLekk1c1NqN2tSamdYUHdpY2Q5a1ZHYjBOQ1kwUVR5R3NZRDgvOGl0?=
 =?utf-8?B?SHNjUkk5bXBqdkFyZW5PdG1paUpRRi9aWEFRVFpWNS9YY0FMaFhwSlJEQTJn?=
 =?utf-8?B?NXVxVGFjOUYyUTFnQ29uYnRIKzJRaGdOeFRYWnJiUzl5QkpqaG9ibHcvWExu?=
 =?utf-8?B?eFNZdThpU3VvK2NLdlNQUkx1dVN5SHpkNElBM2xjUU1xNUJuOUtXOHhwYU91?=
 =?utf-8?B?N3BMd2tvZ3lOTzZqSnRkem43ZWMwS25kL0JjTWFnK25HUEhVR3lyZXBoUHFZ?=
 =?utf-8?B?TUdqUGFFc1lKc3ZRNS9NVWVMWkhuUUZaUGh5eTl6MmxxSkg0WDVaTHQrc2lm?=
 =?utf-8?B?VStETkhESTdLZWZXc2I5SnBmWXhlRnMvMVcxNkNucENCTW4wSEl5TjdZVnpS?=
 =?utf-8?B?cWRnY3dtZzRPc0VHVUoxeElTTVBlM2hlS3lqSklmNkc4Y3J2eHVObVVBdFhj?=
 =?utf-8?B?emtSNjVQQnV2WDlDNWxyaVNiOHZ5eTU2bDFHeHFtdXc0YXpVWDRQS2hQZEh1?=
 =?utf-8?B?K3l5QjBUY1EwZ3MzKzV5elc2QS92YkpFVVdUU2dLZm1WejJEa3dQUVBmYml6?=
 =?utf-8?B?REV3WGZtN2tubWQweHptalBlZSt0T0ZoVG5NNVVXeG1vYWZjZ3l2NzNwTWxP?=
 =?utf-8?B?TTlqK21XMkxVYVVSekl6ZndkRlRqL1hFNnpVOVNIS3VmNlBDYnBqTGU1aFVj?=
 =?utf-8?B?aGlrS2d5OE9WaUt1MWY4clRnbEV2RU1WZmxsU3lSSERUVnNPMFZ0NWV6NWtL?=
 =?utf-8?B?SHNLU2dBcklETGZMZHl2Y0VJenNpQVRHd0FzbU5JVUljYkxIMm8xa0YwQjZW?=
 =?utf-8?B?UlJpek1IWjVMQ01JZno3WmZKeVlqVmdMMVRVZDFXNlpSb2ttanVENDFUNkVW?=
 =?utf-8?B?MlYzUUZidUNWN0ZLdDlvVUZYcFVpTEJ3TlhiZ3MxZmRHemF6aFNpODNlZHhF?=
 =?utf-8?B?K0xWczlNUXk2Zlg5b25EanlrWXlVYUZXdUc3T1V5REloelJHNkJRb1NtTUxn?=
 =?utf-8?B?Q1ZNTjhSdVgzdzAyZXVSUXJJb0RiNWI1bFVsWWpoRlRBS3pvOCtEY3gvbmJH?=
 =?utf-8?B?enAzSmtSMzBsODZYL210VTNSV2tOSm91RFJWUlpZZW1ocFdoRWdPL3h3TVYz?=
 =?utf-8?B?d3Rxd3BlbncrZHp0a09Ua0sxOG5DWm1PVFdZR2x0dEswS3BmZVFtMy92Y0sy?=
 =?utf-8?B?VU9KQUgzbHQ0WXBFUVVmTTBsN3RLQVlVUXlOYnU0ZllUMTRMT2o0ZWxuaFRr?=
 =?utf-8?B?d0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <81069C825960F9428FEAC2EF7BE87413@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 958b8bac-0627-42e1-87ad-08de2d2cf6fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2025 20:47:07.8817
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2wR4lhEeUkQdbbLe+56TLeCnRv9rwg1DFBXhr+qGiyye46LfMpm1eW7VWNzvdPxiWq4vFYjfKFjrmO06eOfHEwcsncrSE0gDg+qglqRP6nI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6378
X-OriginatorOrg: intel.com

S2lyeWwsIGN1cmlvdXMgaWYgeW91IGhhdmUgYW55IGNvbW1lbnRzIG9uIHRoZSBiZWxvdy4uLg0K
DQpPbiBXZWQsIDIwMjUtMTEtMjYgYXQgMTY6NDUgKzAyMDAsIE5pa29sYXkgQm9yaXNvdiB3cm90
ZToNCj4gPiArc3RhdGljIGludCBwYW10X3JlZmNvdW50X3BvcHVsYXRlKHB0ZV90ICpwdGUsIHVu
c2lnbmVkIGxvbmcgYWRkciwgdm9pZA0KPiA+ICpkYXRhKQ0KPiA+ICt7DQo+ID4gKwlzdHJ1Y3Qg
cGFnZSAqcGFnZTsNCj4gPiArCXB0ZV90IGVudHJ5Ow0KPiA+ICsNCj4gPiArCXBhZ2UgPSBhbGxv
Y19wYWdlKEdGUF9LRVJORUwgfCBfX0dGUF9aRVJPKTsNCj4gPiArCWlmICghcGFnZSkNCj4gPiDC
oMKgwqAJCXJldHVybiAtRU5PTUVNOw0KPiA+IMKgwqAgDQo+ID4gKwllbnRyeSA9IG1rX3B0ZShw
YWdlLCBQQUdFX0tFUk5FTCk7DQo+ID4gKw0KPiA+ICsJc3Bpbl9sb2NrKCZpbml0X21tLnBhZ2Vf
dGFibGVfbG9jayk7DQo+ID4gKwkvKg0KPiA+ICsJICogUEFNVCByZWZjb3VudCBwb3B1bGF0aW9u
cyBjYW4gb3ZlcmxhcCBkdWUgdG8gcm91bmRpbmcgb2YgdGhlDQo+ID4gKwkgKiBzdGFydC9lbmQg
cGZuLiBNYWtlIHN1cmUgdGhlIFBBTVQgcmFuZ2UgaXMgb25seSBwb3B1bGF0ZWQgb25jZS4NCj4g
PiArCSAqLw0KPiA+ICsJaWYgKHB0ZV9ub25lKHB0ZXBfZ2V0KHB0ZSkpKQ0KPiA+ICsJCXNldF9w
dGVfYXQoJmluaXRfbW0sIGFkZHIsIHB0ZSwgZW50cnkpOw0KPiA+ICsJZWxzZQ0KPiA+ICsJCV9f
ZnJlZV9wYWdlKHBhZ2UpOw0KPiA+ICsJc3Bpbl91bmxvY2soJmluaXRfbW0ucGFnZV90YWJsZV9s
b2NrKTsNCj4gDQo+IG5pdDogV291bGRuJ3QgaXQgYmUgYmV0dGVyIHRvIHBlcmZvcm0gdGhlIHB0
ZV9ub25lKCkgY2hlY2sgYmVmb3JlIGRvaW5nIA0KPiB0aGUgYWxsb2NhdGlvbiB0aHVzIGF2b2lk
aW5nIG5lZWRsZXNzIGFsbG9jYXRpb25zPyBJLmUgZG8gdGhlIA0KPiBhbGxvYy9ta19wdGUgb25s
eSBhZnRlciB3ZSBhcmUgMTAwJSBzdXJlIHdlIGFyZSBnb2luZyB0byB1c2UgdGhpcyBlbnRyeS4N
Cg0KWWVzLCBidXQgSSdtIGFsc28gd29uZGVyaW5nIHdoeSBpdCBuZWVkcyBpbml0X21tLnBhZ2Vf
dGFibGVfbG9jayBhdCBhbGwuIEhlcmUgaXMNCm15IHJlYXNvbmluZyBmb3Igd2h5IGl0IGRvZXNu
J3Q6DQoNCmFwcGx5X3RvX3BhZ2VfcmFuZ2UoKSB0YWtlcyBpbml0X21tLnBhZ2VfdGFibGVfbG9j
ayBpbnRlcm5hbGx5IHdoZW4gaXQgbW9kaWZpZWQNCnBhZ2UgdGFibGVzIGluIHRoZSBhZGRyZXNz
IHJhbmdlICh2bWFsbG9jKS4gSXQgbmVlZHMgdG8gZG8gdGhpcyB0byBhdm9pZCByYWNlcw0Kd2l0
aCBvdGhlciBhbGxvY2F0aW9ucyB0aGF0IHNoYXJlIHRoZSB1cHBlciBsZXZlbCBwYWdlIHRhYmxl
cywgd2hpY2ggY291bGQgYmUgb24NCnRoZSBlbmRzIG9mIGFyZWEgdGhhdCBURFggcmVzZXJ2ZXMu
DQoNCkJ1dCBwYW10X3JlZmNvdW50X3BvcHVsYXRlKCkgaXMgb25seSBvcGVyYXRpbmcgb24gdGhl
IFBURSdzIGZvciB0aGUgYWRkcmVzcw0KcmFuZ2UgdGhhdCBURFggY29kZSBhbHJlYWR5IGNvbnRy
b2xzLiBWbWFsbG9jIHNob3VsZCBub3QgZnJlZSB0aGUgUE1EIHVuZGVybmVhdGgNCnRoZSBQVEUg
b3BlcmF0aW9uIGJlY2F1c2UgdGhlcmUgaXMgYW4gYWxsb2NhdGlvbiBpbiBhbnkgcGFnZSB0YWJs
ZXMgaXQgY292ZXJzLg0KU28gd2UgY2FuIHNraXAgdGhlIGxvY2sgYW5kIGFsc28gZG8gdGhlIHB0
ZV9ub25lKCkgY2hlY2sgYmVmb3JlIHRoZSBwYWdlDQphbGxvY2F0aW9uIGFzIE5pa29sYXkgc3Vn
Z2VzdHMuDQoNClNhbWUgZm9yIHRoZSBkZXBvcHVsYXRlIHBhdGguDQo=

