Return-Path: <kvm+bounces-68824-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QOAGC89acWnLGAAAu9opvQ
	(envelope-from <kvm+bounces-68824-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 00:01:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id BD1595F347
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 00:01:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B71685E3D06
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 23:01:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EB39421EE0;
	Wed, 21 Jan 2026 23:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f0L1w8R9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996C733D4E1;
	Wed, 21 Jan 2026 23:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769036478; cv=fail; b=e2r4Y4tmshTNP85ZtkrWj2S3/rqf/aYZeIu3U+7UHJvaWzwTvwEBkhkMS7joqQHMuEnskYbS6OPciMlznfNCOkU9fgAgD87TRzCVeD3aa2cuC40tNGPCDND0v38qrLoQ22f8z9Ty0oJgfqDF71y73xQo42Ye3S+50lDGNsXm6oQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769036478; c=relaxed/simple;
	bh=QFjH9l6cLHn3QjW5PXUA5JuTL9bxTKf2dd7zPprtXUE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=heeIzh1NwV3452Q2yZtnvdlfTLA+npcTK4Mg366TBCKRcT/TS4BmUe+/N4KUf+GrDuwxnqAO+aStQXd26xVnyjULMk4vF5ZlSqznDKKa/s2K/C/E7/Wq9459fEEdtoWMI+ZX+w6EAADR2vwNkWLswYcJRAyyVfpPIJRxxDLzhlE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f0L1w8R9; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769036476; x=1800572476;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=QFjH9l6cLHn3QjW5PXUA5JuTL9bxTKf2dd7zPprtXUE=;
  b=f0L1w8R93zMJjjP2rzRgzKNY73Bg+5BhTyyeuQdRpND9i+KzArXU6AjS
   BFIXArPidM4tyf698KzQAcqDvKdNRKpPgc/hkJnV49WfGdvW3nm/0z2pN
   5qM7kfF+aUwXJwlnRjHNCqjFfbfRNwH4wlOM++rf9aC9QGBjt7YmsstKL
   Vul43bA0EU9p6yIL7WLqb0E2RtB0sUyYFITmS11cnV4F1M5XyOYLdIL0Y
   murh4j5BR36kt746a/Arbu7A5THo+sdOhUVLHH8KJzgBLK5jKDY6Xyuew
   mtPMTOXfLRm44PlUpyq/Ss2+6jzjdx5+K86WFq4HlCrGElJ4sbToM+nvK
   w==;
X-CSE-ConnectionGUID: HmjePlY6RBS7yKj+tZmpYA==
X-CSE-MsgGUID: /XZ8rQmUQf2RahLfDhGPjA==
X-IronPort-AV: E=McAfee;i="6800,10657,11678"; a="81718710"
X-IronPort-AV: E=Sophos;i="6.21,244,1763452800"; 
   d="scan'208";a="81718710"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 15:01:14 -0800
X-CSE-ConnectionGUID: LQmnclaMQDOZ2Q7pw0SvJg==
X-CSE-MsgGUID: Jbv7fm9FSkawFDbGBDcEDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,244,1763452800"; 
   d="scan'208";a="211014914"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 15:01:13 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 21 Jan 2026 15:01:12 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 21 Jan 2026 15:01:12 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.47) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 21 Jan 2026 15:01:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tuasj/a4Koxjm+onIHMYqUJH8JKfzanLxReOEoH6dm6LQgElG9GBfx5yQbPSDshT0+VC86zIvufKJmoJjl/ZIlDdos0Vjo6LR5SXKMpvKcp67Mb+3IMiBRvmkU3Nu+gMlAbvemCvwdkA9/qF4cz6QyJjwvDHSw+vvvJb1NQOW/kBxN7UIbTl8SxWhhERJd4Y4f3+6FUXlZkXoUxXn2Yfcxhpm95P6vkPOymB4p7MLaO0b35dUIyGSdqVItjVpXaGUKpZ84PxoVBSHteMYrpj/gsrPtY5MncPEtbEDyvPmK6E1LHIzmcKRHO3dEJY90n5fXfS3xu4M3wONQTGscYmHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QFjH9l6cLHn3QjW5PXUA5JuTL9bxTKf2dd7zPprtXUE=;
 b=WVTuqTPTWrmo53rjXT3XRAiEm5yG3wlFHXDBp8cMJryc50sDTWhNxo87cL/4OXzu0FE8lNfF8E/GepCvrASrlR8C8yHeX2oUhVSTEuwN3P7JFJGFzGYnnek6l8tj2nGCdSNWgeXr9nU4jZX65dHFNYJj6zc47tflen6dolVIFN2yoqzEknWMejRX7EGbexsAPooHzwhVrFxZblIK+1IbXbMoP4WEncBpRNVUu9y1YhSJbLDNrvyRI8340Gq7Bu4DeAocksq9bVp/xzQULz4SE0XzrXnYrT8a7nbhbyfW4bqg/UsCAwqKGkZfHasXTBKziZSsfjAM/gPrjeS+jGIGdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DM6PR11MB4738.namprd11.prod.outlook.com (2603:10b6:5:2a3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 23:01:07 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9542.009; Wed, 21 Jan 2026
 23:01:06 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Du, Fan" <fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, "david@kernel.org"
	<david@kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>,
	"francescolavra.fl@gmail.com" <francescolavra.fl@gmail.com>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "sagis@google.com" <sagis@google.com>,
	"Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "Miao, Jun" <jun.miao@intel.com>, "Annapurve,
 Vishal" <vannapurve@google.com>, "jgross@suse.com" <jgross@suse.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 19/24] KVM: x86: Introduce per-VM external cache for
 splitting
Thread-Topic: [PATCH v3 19/24] KVM: x86: Introduce per-VM external cache for
 splitting
Thread-Index: AQHcfvbSydlt/e/FU0SaQnkHllxJ3bVb88AAgAEFlwCAAFxeAA==
Date: Wed, 21 Jan 2026 23:01:06 +0000
Message-ID: <313244596b4459326bf65f50849cafe434c76813.camel@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
	 <20260106102331.25244-1-yan.y.zhao@intel.com>
	 <b9487eba19c134c1801a536945e8ae57ea93032f.camel@intel.com>
	 <aXENNKjAKTM9UJNH@google.com>
In-Reply-To: <aXENNKjAKTM9UJNH@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DM6PR11MB4738:EE_
x-ms-office365-filtering-correlation-id: 21b42bc0-e2af-4ad5-0c2a-08de5940f5c4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?eHFUNDFaRmpqSm8reFdsRGIvTFBPS3VmVXdCN2lQVW1WRCtqQXVJYlRrelNQ?=
 =?utf-8?B?M0I4U05sOFdXSFdORWRhYnRZcjh6Smc2WDl6TUQ0RlhOWk1URWF2MFlUVGRX?=
 =?utf-8?B?NGRWOGFuaGl0akIzQ0VBNTV4YTRwS2d6WUhFMmxxVzIvU0E0NS9EaHp6M05Y?=
 =?utf-8?B?c0pXOTdFamNlL1cvYXlqNmk4SWlseEp1c3FMV3gycU1SeVg3RTVUdGlEK0Fy?=
 =?utf-8?B?bVI1T0M0TkZVZU5xcFJJTmFnMTVJS1l6amlBSlliTTNrZDJoQlBwWFRKZFRQ?=
 =?utf-8?B?RzdDY0JpNkF3eVZwd0htdnZ0Q3k4K0J2WVBDTHVqazZNSUhYalJpZGhKWEw5?=
 =?utf-8?B?Uzl1VkdORVJuWFZTT01tSC8vS3cxRnJ6d0NmNDllVSsxN0dLRE5EY2hPN3VW?=
 =?utf-8?B?OGJqbGdwVW5zN2ZvcjJ5aEFVUXI0UTM3TWV2K0psa21IZ2U5K0o1Vll0TEE2?=
 =?utf-8?B?SmNsUndSdnNma0R1VWhQMjJiWnQ4OXVkZ1ZEOTZQWXlVbjdPL0RRTHZEOEZV?=
 =?utf-8?B?bW1DSjFlTlYvUzhNNWlXSlJ5R05lMGdGdE5oeHI2b1RqMjFqcDRVV3pDR0U2?=
 =?utf-8?B?QzlVc0djUDFzc1RzdXNXMi80dHdQbkhsbGV2YlkzeVF1NjY5ejlHc3AwL3dw?=
 =?utf-8?B?bnJDZThiZFc4em40ZFpqcGNnL1lPbTVNaGM3N2tqRk1JOXRHdHJ4SXdBRTlt?=
 =?utf-8?B?Q0VDZVFUZUJQMUxQWEMrTWsyZnNTK1ZFZW9jVUY1b2hweXRiNmlIMnp4NEh1?=
 =?utf-8?B?MFBJUXI1K3JZZExJc1Rxa25yaStYQlJyZXNYd2JiYTRCZ3RzOFF2ZkpjYU5v?=
 =?utf-8?B?S1lkYjVoa3N1UVVkeHNNMG1tcThtM29KMkx3MnF1d04wTG9GaTNzWm5BZzgz?=
 =?utf-8?B?RWErVEhoZFE1MG44UVU2RFR5NGx3dDEzQ1owOGxQbGJnQ212VGhTK09RWDdu?=
 =?utf-8?B?OHRjeEJveTVpWXc3SUs3WUJqa2w3UzNSNTl5ZjYxZi90NTRDQUJrRW1UaEFU?=
 =?utf-8?B?NEVqTU5LVUVXS21ObSs4OEVaUDJwMnY4R3RBT0NWelZiVGFLU0dWMUVMc0x5?=
 =?utf-8?B?aU1OaSs0T3FRNFI3UVZlc2RsV3RKMHRvaFN2ajEzWVNiUmxYdmlnSTJFSzhU?=
 =?utf-8?B?NXUvaERLNWhxaC9ZZlltejdEYVpBQmo2YThSYURpZ0hCU2FxeWZKQWdNclRK?=
 =?utf-8?B?SE9JYlp5VVovSXhaYUNHdnBzY1l4R21kUFJTdU1jRG9BbnFCMlBpbEpDVnNl?=
 =?utf-8?B?amZPR20vdkFLRWVCc04xeUY0dldWTWdzUHRPM01odXFzeUpUUHg5NFA4ZnVs?=
 =?utf-8?B?UlNSbnJYc01KNkd3MG95MFQ1bVJpK1h5ZTJYakpvNHdqdGpvZGlVcnIzVlFJ?=
 =?utf-8?B?SmQ1dnB6Rk41a201b1BsUnpiRHVmemc3UXR4bTQxRlFZL04zeUNORExSUk1o?=
 =?utf-8?B?SllaWWZBRUpaSHhhQi9GVzVteDFqS1RaNzZHcm92L3VWVWxDTGpzcWFPMWZE?=
 =?utf-8?B?dWtiYXQzTi9aQXhxajhaYTN1akNJTEE5cVNSWWpOWHBWdUpjL1NLQWp2U3pD?=
 =?utf-8?B?MmZzVEJtMEVNQlIzaXY2VkRLSU1NZlY5M0NhUm9XN1kyMmg1cWZ2bkc0YlJZ?=
 =?utf-8?B?akNnc3dsY0IwL2JKYVNUcXM3RW1jQTFET1pMN2hYMnhpZDVydGFYOTY5WEhU?=
 =?utf-8?B?MkR6L05QMWdUejNNYmgwRk1QVytCZmNMclpJMi9pR1NmdHBFMzl6VmlOWkxP?=
 =?utf-8?B?L01YVWVKSkhQT2V6aDFRdlFpMG9UY0ZGY2cxajRkdUpwaEFvNGpGTkdMME1M?=
 =?utf-8?B?S1hLZThwL3UrNEt4ZmZhUWgxQU13K0RaQ203aWlOL0JVRnNCMWdjY2hDTnN1?=
 =?utf-8?B?cmlLQnY4cFpqQWZtVEpiemFuWk5aRTlNdEltamFYbmlCSW5KMEh5Q1hBVVBo?=
 =?utf-8?B?N21YNmhXcjRqTmx5NjdmcTV0Qi9uaFg2YWpZWnQ5aGlDUTEyQWVtQjhXTUhy?=
 =?utf-8?B?SVVDcHdyY1dBcmNtQXJWdmxpNGNBS1F3WlRGcitmczdreU04eEo0Ykk4ckdK?=
 =?utf-8?B?R2JnN0pqZi9oZmJ2Q1A1M2t2WnBLSzE3U3IrOHhZUUhoNkFMb0M5OVM2aTJV?=
 =?utf-8?B?SEhoZzNxa250UjV6NURKemw2Vmhkdmk0S09jL2FMNWNvU2IxaDE3Z2xFVFhr?=
 =?utf-8?Q?0DhkKypFtjwqo4HIk7ZQHr0=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VGY1M1hYb0hkVlVPYUNTOVVJL1BaSDBTUi9xUFVySzdLWVhQejlKKzBMN2FB?=
 =?utf-8?B?MU5Lb0lKYkEwYzJaUVBwcnB5eXRGQWJQTVlhbWtTU2FPWjUxZ2sxVFdhVlo2?=
 =?utf-8?B?emRlUkpsc2RldlpXNThoa3FFOGxMN1gzSnNRbEV3ZmorWnJQWmQzaENyVStE?=
 =?utf-8?B?RGVsT3JmeDlVR1dDNDh2ZXlrU054djZreDd3MHFPaHRzTis0a2QwRWpRbFNG?=
 =?utf-8?B?MGtrOEI4MkpXelgvVDg5N0VQVGhibS9OS2ZMdDY1cmY4djJIeUNoV01pL0Y4?=
 =?utf-8?B?Rm5ibTYwNkxIaW1LVXlLVVkvWmJpeUdseWJJZHZJNHQvVGRwUTA3RlZEZXRj?=
 =?utf-8?B?UTVWaXpEY21Kb3ZGOVBEWVZFSzQ1d3IvVjBpdFpvRE9XTVdRbGdBWlBNaWFh?=
 =?utf-8?B?dDlhYWlBZnk2R0REY0xKYVNVbnJDdFJFTnZsdFlNbXpYQVkvdlF2ZCtOZXhP?=
 =?utf-8?B?Y2ZHNk1jQnRKcEF3OUZOamZkckFidlhjTFFKMFBXWmJOLytlSTdqUzFMM2lS?=
 =?utf-8?B?VUsxdGI2YnQ3eE1XcDNob0U3Z1JsSDZLU1FqTzBkTEhqVlk4cERTUFo1VGVv?=
 =?utf-8?B?dDVPUGptQVNGdlF3RnY2Wk1aWFJ1MEVZL2g1Mi83Vzd0OG92TVZDSDhOUHNz?=
 =?utf-8?B?aXJZZ0xXbnRVU2Z5dW9QTzNweHJ4Wmo2T1N6UnBFbjY3V2VkdllJOGNPOTNL?=
 =?utf-8?B?L3NYb05LQmF2YUlrRWdZOWdPNkVrQjF4NnpEUS81REJrdVkyWUN6RVBXZ25m?=
 =?utf-8?B?Q1Y2eG5mbFRIRk85LzN2bmt0TUtPYUhkMnlGOEtmSk1qTnd4QU5kSnZQanpm?=
 =?utf-8?B?Njg0U1JZVDNlNVo4d3IvS1B0NkdWY0lMYm5BdTJRRURMaGZSS2JkRlVUL0dK?=
 =?utf-8?B?ZHVMdnNVNk9sdzV0cHM2REpiK0JSSlZEOUZleHovaXhUcVFjQS9jaUlRajVM?=
 =?utf-8?B?MDBzVWpZSmJlK2hFY0RTU2w1V3NxalZDVE1YUlNtaTJhQ0IxU255Q0lpZlkr?=
 =?utf-8?B?MUZHTGxYWTVKcXhrVDZoeGFDMkh1Sk9JbWxiVVMzTitzTnh5ZDlnZGcreE0v?=
 =?utf-8?B?ZWRwZ0g1bDllU0xuZXhVb3RQWVRqeVc2SzhqMlQvN2hCTHFHZ1JBcmNRYmRi?=
 =?utf-8?B?OU5yaWdQMzNwbUVjV3hlb1RRYnJYN216bE9SOFM4em15Zlo4eitjUmJkYXpJ?=
 =?utf-8?B?anZsSHRLZExtZ2E5Q0Zub1RoUTR2ZklCdDFsQ1c4U1B6MGdhSjZiZ3VYcHkw?=
 =?utf-8?B?UlN2RVpnbmE5Z3MwbmZrU0tYYkZ3WlJKMFJDbmRhK29CV1lWVzkxZjlFS01w?=
 =?utf-8?B?TEw0cCs0azlTMmN1NVVVTDhVdzBxb3BObVlyOU9uMTZoeklMRVAxOCtsRUZa?=
 =?utf-8?B?ZWEzME5PZC82Nko5bHUzeHowK3lJcERzVFJTdVpsaXhlc2orcWFxQi81VVE4?=
 =?utf-8?B?NWl0b3B0b25aQ2VObGg4SzhqNlpENnozdDlKcnFhU1N2d1hjNThOV21MM3Mx?=
 =?utf-8?B?b2hkUVJuRDFJZXFsNzB1bVpvSWtydURwZVN5emhhRnhNNDg4NktTVkhlVWht?=
 =?utf-8?B?eEZqRWFIWDk5NGdzelNMTi91b0lxSFhMZktJdVhCMGRJWkR4b2dvVWhONjN1?=
 =?utf-8?B?QnBPc09ScFYzSDVmcFF0b1hObzZPUUs2aWpTVE9sYlJZbDAzNnNkeWh0RkJq?=
 =?utf-8?B?SkNDNkpQdEVobUo3YUczeDhoK0h1R2VkVTZDbkZLeXA0Y0pzc09oRkxoa09i?=
 =?utf-8?B?anE4c3FGZjhkQUk3QnFxS3Vmckx4cGJMellZWUJZanZNNGFiRUZKNlpIZm5l?=
 =?utf-8?B?a2pGVUZEVFMrVlJQc3RCY3UwQmgrZWwwZFF1NmdYQUxsQVVBSlBJdm95eTJC?=
 =?utf-8?B?eGtsKzk2MXQxRWxnZmhSeVlpeHFabVk3MDhzZFlKTTFOQ0IxTXVFYVM1RWhz?=
 =?utf-8?B?ZEJSWlpBK09UVHNaUzB1TEZkbDRkbHZNSEh3WjRPdjY5Q1IycmJVSmZNY2Vi?=
 =?utf-8?B?anM2Qit3QXhhS3lGeEJTRG9PTzRjTmliNERlY1Rya3UwRTFXNGRlV3FFWC80?=
 =?utf-8?B?WFRiNkRhZm1kcU42d2FmTEh5S0I2RzJxclVZLzY3UGQ0U0VPejJoNSt3Yld6?=
 =?utf-8?B?dkNaRGRHUGhDZ3VjaEt4dFA1cHA1RkVxaC9YOTRramc0enVQd2JVSTZURmhH?=
 =?utf-8?B?OHIyYnhPbHUrSTRrMWhXKzFNejZsTjhDbElPYUJod0JCZFEvbzAzdHY3TzF6?=
 =?utf-8?B?WG5Wa0wxVVV4N1ZFaE14ZllvS3J2WTF1QUNnZGxtNkJ2SDhYVUpjL2s4aStG?=
 =?utf-8?B?NlNTQzJUSHo0cGgxMmVUZlVVNGsxdGdGc3krUUhrcTl1M0QxWXpwUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <87EBD26449CE684D94020556AFF0F44C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21b42bc0-e2af-4ad5-0c2a-08de5940f5c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2026 23:01:06.8534
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HQrWGpI+q/17YfOkxFcStO0EXdsJQj0IBoj/6dKeLH9mdsJeXFzacKePiW030qjN4LceFruqEDU4wDkvCEcYKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4738
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [2.64 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68824-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:helo,ams.mirrors.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[29];
	FREEMAIL_CC(0.00)[intel.com,vger.kernel.org,amd.com,suse.cz,google.com,kernel.org,linux.intel.com,redhat.com,suse.com,gmail.com];
	DKIM_TRACE(0.00)[intel.com:+];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[intel.com,none];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: BD1595F347
X-Rspamd-Action: no action

T24gV2VkLCAyMDI2LTAxLTIxIGF0IDA5OjMwIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBXZWQsIEphbiAyMSwgMjAyNiwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIFR1
ZSwgMjAyNi0wMS0wNiBhdCAxODoyMyArMDgwMCwgWWFuIFpoYW8gd3JvdGU6DQo+ID4gSSBoYXZl
IGJlZW4gdGhpbmtpbmcgd2hldGhlciB3ZSBjYW4gc2ltcGxpZnkgdGhlIHNvbHV0aW9uLCBub3Qg
b25seSBqdXN0DQo+ID4gZm9yIGF2b2lkaW5nIHRoaXMgY29tcGxpY2F0ZWQgbWVtb3J5IGNhY2hl
IHRvcHVwLXRoZW4tY29uc3VtZSBtZWNoYW5pc20NCj4gPiB1bmRlciBNTVUgcmVhZCBsb2NrLCBi
dXQgYWxzbyBmb3IgYXZvaWRpbmcga2luZGEgZHVwbGljYXRlZCBjb2RlIGFib3V0IGhvdw0KPiA+
IHRvIGNhbGN1bGF0ZSBob3cgbWFueSBEUEFNVCBwYWdlcyBuZWVkZWQgdG8gdG9wdXAgZXRjIGJl
dHdlZW4geW91ciBuZXh0DQo+ID4gcGF0Y2ggYW5kIHNpbWlsYXIgY29kZSBpbiBEUEFNVCBzZXJp
ZXMgZm9yIHRoZSBwZXItdkNQVSBjYWNoZS4NCj4gPiANCj4gPiBJSVJDLCB0aGUgcGVyLVZNIERQ
QU1UIGNhY2hlIChpbiB5b3VyIG5leHQgcGF0Y2gpIGNvdmVycyBib3RoIFMtRVBUIHBhZ2VzDQo+
ID4gYW5kIHRoZSBtYXBwZWQgMk0gcmFuZ2Ugd2hlbiBzcGxpdHRpbmcuDQo+ID4gDQo+ID4gLSBG
b3IgUy1FUFQgcGFnZXMsIHRoZXkgYXJlIF9BTFdBWVNfIDRLLCBzbyB3ZSBjYW4gYWN0dWFsbHkg
dXNlDQo+ID4gdGR4X2FsbG9jX3BhZ2UoKSBkaXJlY3RseSB3aGljaCBhbHNvIGhhbmRsZXMgRFBB
TVQgcGFnZXMgaW50ZXJuYWxseS4NCj4gPiANCj4gPiBIZXJlIGluIHRkcF9tbW11X2FsbG9jX3Nw
X2Zvcl9zcGxpdCgpOg0KPiA+IA0KPiA+IAlzcC0+ZXh0ZXJuYWxfc3B0ID0gdGR4X2FsbG9jX3Bh
Z2UoKTsNCj4gPiANCj4gPiBGb3IgdGhlIGZhdWx0IHBhdGggd2UgbmVlZCB0byB1c2UgdGhlIG5v
cm1hbCAna3ZtX21tdV9tZW1vcnlfY2FjaGUnIGJ1dA0KPiA+IHRoYXQncyBwZXItdkNQVSBjYWNo
ZSB3aGljaCBkb2Vzbid0IGhhdmUgdGhlIHBhaW4gb2YgcGVyLVZNIGNhY2hlLiAgQXMgSQ0KPiA+
IG1lbnRpb25lZCBpbiB2MywgSSBiZWxpZXZlIHdlIGNhbiBhbHNvIGhvb2sgdG8gdXNlIHRkeF9h
bGxvY19wYWdlKCkgaWYgd2UNCj4gPiBhZGQgdHdvIG5ldyBvYmpfYWxsb2MoKS9mcmVlKCkgY2Fs
bGJhY2sgdG8gJ2t2bV9tbXVfbWVtb3J5X2NhY2hlJzoNCj4gPiANCj4gPiBodHRwczovL2xvcmUu
a2VybmVsLm9yZy9rdm0vOWU3MjI2MTYwMmJkYWI5MTRjZjdmZjZmN2NiOTIxZTM1Mzg1MTM2ZS5j
YW1lbEBpbnRlbC5jb20vDQo+ID4gDQo+ID4gU28gd2UgY2FuIGdldCByaWQgb2YgdGhlIHBlci1W
TSBEUEFNVCBjYWNoZSBmb3IgUy1FUFQgcGFnZXMuDQo+ID4gDQo+ID4gLSBGb3IgRFBBTVQgcGFn
ZXMgZm9yIHRoZSBURFggZ3Vlc3QgcHJpdmF0ZSBtZW1vcnksIEkgdGhpbmsgd2UgY2FuIGFsc28N
Cj4gPiBnZXQgcmlkIG9mIHRoZSBwZXItVk0gRFBBTVQgY2FjaGUgaWYgd2UgdXNlICdrdm1fbW11
X3BhZ2UnIHRvIGNhcnJ5IHRoZQ0KPiA+IG5lZWRlZCBEUEFNVCBwYWdlczoNCj4gPiANCj4gPiAt
LS0gYS9hcmNoL3g4Ni9rdm0vbW11L21tdV9pbnRlcm5hbC5oDQo+ID4gKysrIGIvYXJjaC94ODYv
a3ZtL21tdS9tbXVfaW50ZXJuYWwuaA0KPiA+IEBAIC0xMTEsNiArMTExLDcgQEAgc3RydWN0IGt2
bV9tbXVfcGFnZSB7DQo+ID4gICAgICAgICAgICAgICAgICAqIFBhc3NlZCB0byBURFggbW9kdWxl
LCBub3QgYWNjZXNzZWQgYnkgS1ZNLg0KPiA+ICAgICAgICAgICAgICAgICAgKi8NCj4gPiAgICAg
ICAgICAgICAgICAgdm9pZCAqZXh0ZXJuYWxfc3B0Ow0KPiA+ICsgICAgICAgICAgICAgICB2b2lk
ICpsZWFmX2xldmVsX3ByaXZhdGU7DQo+ID4gICAgICAgICB9Ow0KPiANCj4gVGhlcmUncyBubyBu
ZWVkIHRvIHB1dCB0aGlzIGluIHdpdGggZXh0ZXJuYWxfc3B0LCB3ZSBjb3VsZCB0aHJvdyBpdCBp
biBhIG5ldyB1bmlvbg0KPiB3aXRoIHVuc3luY19jaGlsZF9iaXRtYXAgKFREUCBNTVUgY2FuJ3Qg
aGF2ZSB1bnN5bmMgY2hpbGRyZW4pLg0KPiANCg0KQWdyZWVkLg0KDQo+IElJUkMsIHRoZSBtYWlu
DQo+IHJlYXNvbiBJJ3ZlIG5ldmVyIHN1Z2dlc3RlZCB1bmlvbml6aW5nIHVuc3luY19jaGlsZF9i
aXRtYXAgaXMgdGhhdCBvdmVybG9hZGluZw0KPiB0aGUgYml0bWFwIHdvdWxkIHJpc2sgY29ycnVw
dGlvbiBpZiBLVk0gZXZlciBtYXJrZWQgYSBURFAgTU1VIHBhZ2UgYXMgdW5zeW5jLCBidXQNCj4g
dGhhdCdzIGVhc3kgZW5vdWdoIHRvIGd1YXJkIGFnYWluc3Q6DQo+IA0KPiBkaWZmIC0tZ2l0IGEv
YXJjaC94ODYva3ZtL21tdS9tbXUuYyBiL2FyY2gveDg2L2t2bS9tbXUvbW11LmMNCj4gaW5kZXgg
M2Q1Njg1MTIyMDFkLi5kNmM2NzY4YzFmNTAgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS9t
bXUvbW11LmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL21tdS9tbXUuYw0KPiBAQCAtMTkxNyw5ICsx
OTE3LDEwIEBAIHN0YXRpYyB2b2lkIGt2bV9tbXVfbWFya19wYXJlbnRzX3Vuc3luYyhzdHJ1Y3Qg
a3ZtX21tdV9wYWdlICpzcCkNCj4gIA0KPiAgc3RhdGljIHZvaWQgbWFya191bnN5bmModTY0ICpz
cHRlKQ0KPiAgew0KPiAtICAgICAgIHN0cnVjdCBrdm1fbW11X3BhZ2UgKnNwOw0KPiArICAgICAg
IHN0cnVjdCBrdm1fbW11X3BhZ2UgKnNwID0gc3B0ZXBfdG9fc3Aoc3B0ZSk7DQo+ICANCj4gLSAg
ICAgICBzcCA9IHNwdGVwX3RvX3NwKHNwdGUpOw0KPiArICAgICAgIGlmIChXQVJOX09OX09OQ0Uo
aXNfdGRwX21tdV9wYWdlKHNwKSkpDQo+ICsgICAgICAgICAgICAgICByZXR1cm47DQo+ICAgICAg
ICAgaWYgKF9fdGVzdF9hbmRfc2V0X2JpdChzcHRlX2luZGV4KHNwdGUpLCBzcC0+dW5zeW5jX2No
aWxkX2JpdG1hcCkpDQo+ICAgICAgICAgICAgICAgICByZXR1cm47DQo+ICAgICAgICAgaWYgKHNw
LT51bnN5bmNfY2hpbGRyZW4rKykNCj4gDQoNCkxHVE0uDQoNCj4gDQo+IEkgbWlnaHQgc2VuZCBh
IHBhdGNoIHRvIGRvIHRoYXQgZXZlbiBpZiB3ZSBkb24ndCBvdmVybG9hZCB0aGUgYml0bWFwLCBh
cyBhDQo+IGhhcmRlbmluZyBtZWFzdXJlLg0KPiANCj4gPiBUaGVuIHdlIGNhbiBkZWZpbmUgYSBz
dHJ1Y3R1cmUgd2hpY2ggY29udGFpbnMgRFBBTVQgcGFnZXMgZm9yIGEgZ2l2ZW4gMk0NCj4gPiBy
YW5nZToNCj4gPiANCj4gPiAJc3RydWN0IHRkeF9kbWFwdF9tZXRhZGF0YSB7DQo+ID4gCQlzdHJ1
Y3QgcGFnZSAqcGFnZTE7DQo+ID4gCQlzdHJ1Y3QgcGFnZSAqcGFnZTI7DQo+ID4gCX07DQo+ID4g
DQo+ID4gVGhlbiB3aGVuIHdlIGFsbG9jYXRlIHNwLT5leHRlcm5hbF9zcHQsIHdlIGNhbiBhbHNv
IGFsbG9jYXRlIGl0IGZvcg0KPiA+IGxlYWZfbGV2ZWxfcHJpdmF0ZSB2aWEga3ZtX3g4Nl9vcHMg
Y2FsbCB3aGVuIHdlIHRoZSAnc3AnIGlzIGFjdHVhbGx5IHRoZQ0KPiA+IGxhc3QgbGV2ZWwgcGFn
ZSB0YWJsZS4NCj4gPiANCj4gPiBJbiB0aGlzIGNhc2UsIEkgdGhpbmsgd2UgY2FuIGdldCByaWQg
b2YgdGhlIHBlci1WTSBEUEFNVCBjYWNoZT8NCj4gPiANCj4gPiBGb3IgdGhlIGZhdWx0IHBhdGgs
IHNpbWlsYXJseSwgSSBiZWxpZXZlIHdlIGNhbiB1c2UgYSBwZXItdkNQVSBjYWNoZSBmb3INCj4g
PiAnc3RydWN0IHRkeF9kcGFtdF9tZW10YWRhdGEnIGlmIHdlIHV0aWxpemUgdGhlIHR3byBuZXcg
b2JqX2FsbG9jKCkvZnJlZSgpDQo+ID4gaG9va3MuDQo+ID4gDQo+ID4gVGhlIGNvc3QgaXMgdGhl
IG5ldyAnbGVhZl9sZXZlbF9wcml2YXRlJyB0YWtlcyBhZGRpdGlvbmFsIDgtYnl0ZXMgZm9yIG5v
bi0NCj4gPiBURFggZ3Vlc3RzIGV2ZW4gdGhleSBhcmUgbmV2ZXIgdXNlZCwgYnV0IGlmIHdoYXQg
SSBzYWlkIGFib3ZlIGlzIGZlYXNpYmxlLA0KPiA+IG1heWJlIGl0J3Mgd29ydGggdGhlIGNvc3Qu
DQo+ID4gDQo+ID4gQnV0IGl0J3MgY29tcGxldGVseSBwb3NzaWJsZSB0aGF0IEkgbWlzc2VkIHNv
bWV0aGluZy4gIEFueSB0aG91Z2h0cz8NCj4gDQo+IEkgKkxPVkUqIHRoZSBjb3JlIGlkZWEgKHNl
cmlvdXNseSwgdGhpcyBtYWRlIG15IHdlZWspLCB0aG91Z2ggSSB0aGluayB3ZSBzaG91bGQNCj4g
dGFrZSBpdCBhIHN0ZXAgZnVydGhlciBhbmQgX2ltbWVkaWF0ZWx5XyBkbyBEUEFNVCBtYWludGVu
YW5jZSBvbiBhbGxvY2F0aW9uLg0KPiBJLmUuIGRvIHRkeF9wYW10X2dldCgpIHZpYSB0ZHhfYWxs
b2NfY29udHJvbF9wYWdlKCkgd2hlbiBLVk0gdG9wcyB1cCB0aGUgUy1FUFQNCj4gU1AgY2FjaGUg
aW5zdGVhZCBvZiB3YWl0aW5nIHVudGlsIEtWTSBsaW5rcyB0aGUgU1AuICBUaGVuIEtWTSBkb2Vz
bid0IG5lZWQgdG8NCj4gdHJhY2sgUEFNVCBwYWdlcyBleGNlcHQgZm9yIG1lbW9yeSB0aGF0IGlz
IG1hcHBlZCBpbnRvIGEgZ3Vlc3QsIGFuZCB3ZSBlbmQgdXANCj4gd2l0aCBiZXR0ZXIgc3ltbWV0
cnkgYW5kIG1vcmUgY29uc2lzdGVuY3kgdGhyb3VnaG91dCBURFguICBFLmcuIGFsbCBwYWdlcyB0
aGF0DQo+IEtWTSBhbGxvY2F0ZXMgYW5kIGdpZnRzIHRvIHRoZSBURFgtTW9kdWxlIHdpbGwgYWxs
b2NhdGVkIGFuZCBmcmVlZCB2aWEgdGhlIHNhbWUNCj4gVERYIEFQSXMuDQoNCkFncmVlZC4NCg0K
Tml0OiBkbyB5b3Ugc3RpbGwgd2FudCB0byB1c2UgdGhlIG5hbWUgdGR4X2FsbG9jX2NvbnRyb2xf
cGFnZSgpIGluc3RlYWQgb2YNCnRkeF9hbGxvY19wYWdlKCkgaWYgaXQgaXMgYWxzbyB1c2VkIGZv
ciBTLUVQVCBwYWdlcz8gIEtpbmRhIG5vdCBzdXJlIGJ1dA0KYm90aCB3b3JrIGZvciBtZS4NCg==

