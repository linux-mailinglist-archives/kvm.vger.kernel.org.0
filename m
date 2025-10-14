Return-Path: <kvm+bounces-60028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00865BDB1B0
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 21:45:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64EA9580D0D
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 19:45:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B047F2D9EE6;
	Tue, 14 Oct 2025 19:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eITET5vV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47FC52D6E6F;
	Tue, 14 Oct 2025 19:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760471106; cv=fail; b=GSgWI+QshHxkdzvpf+GszTaUcMTL4kdMvLzfXv4E/oSINfSN9sNmmSQ3RlpDWJ1/er9ejUdfYLRLmMQs+vvweuPiUTv2BgJL1SMrfN8WM4q7GAmDrHyLXVBqh5CFCj9H2mK5kill/9xkBcZUgdNuI8UFLiLIN3IMGvdhzaON5+k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760471106; c=relaxed/simple;
	bh=yWfXQkfieCK1YlqYH6EdyB+uZNFGjuQtjem9FOW0DqI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nJf/Y0EVNBLuU1JCKiYo+ZTZSzXQDolTnFroWuryCXGd2yV8gHeurN5hqJAyHa1kvCvfaRQr1jSbnlVF6HFAtoPDhB7Z+fxz3kzHOKLypY8y76tOr3k1bC3r4ZSmJCax5/5fIU5O5QNsdWFzfo5Ln5lIAcY28ScGgkWq6T5Wvb0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eITET5vV; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760471105; x=1792007105;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=yWfXQkfieCK1YlqYH6EdyB+uZNFGjuQtjem9FOW0DqI=;
  b=eITET5vVNtf2anhWRYTV3xD4BxxJHDs1afLBiRpanmEpSDNoO63zP135
   esBcP9hWkRQHdR/I8SreheIuQQqJDmJLd7PEK9VCzu8Qimh3+S2qaXLs9
   YFrM10aFjNWlZCAf/DH8X9i69lQYQFTim6mCTlpnKMsW/nYjShpMEVeE3
   Q5DtUkdLriL+1xgUp+6BGk/Abxw4DUkU8obb5o6EU1O1534hIcsfVq/wZ
   GO5zn/VYh3nBs0Qkd4LA7mdHJYX4s3JjO9k1t/yHfEUJC90DcLDihCMs8
   0crt9hFivkt81G+sycT4plrVRU1awlHOdEdmFI7UIQoVU6tf7vQZ+4OFE
   Q==;
X-CSE-ConnectionGUID: 3A/zhVlPQDWxVrIJHDx9OA==
X-CSE-MsgGUID: bMt+PPEgRmO9+B78u5CpOQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11582"; a="62734938"
X-IronPort-AV: E=Sophos;i="6.19,229,1754982000"; 
   d="scan'208";a="62734938"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 12:45:04 -0700
X-CSE-ConnectionGUID: SUe9buziTGeCBoj91nFbdg==
X-CSE-MsgGUID: 7TS8/7AYTZ2jHUstBbIr5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,229,1754982000"; 
   d="scan'208";a="181514806"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 12:45:04 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 12:45:03 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 14 Oct 2025 12:45:03 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.35)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 12:45:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pn2kWUwyYYyBK7F7ZAyCtmjaNpz8iNgmhu+0N4zmkWhOVRoTZD0zRjEn7/YDkL+alf7ETVr+5EX9P5qFKbcmcRlsIpsefehizIdmTpKicRuipsv/nF8rQ9nk3unmkoyJMzqdnnzcMN54TMr0ZWsBjvJC8UACggydQIlWFud6gI8gdV4NHn7wVxS9yZBBdvaBCSeZIkMJWzaV61KeF5ZmCJx3r5LPGtnS/M8H+Uqjw01w6bcoVWpU3XBBF9TUGoAQqY6WWwr9LbXgFgiHZNOvknAAMN45hqxdl3EEVQCiT8XA22upuCDviTO8lCzIhTwk0GFJykrnMvak3ZFsmPVlgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yWfXQkfieCK1YlqYH6EdyB+uZNFGjuQtjem9FOW0DqI=;
 b=jVRwsNVkT1UNwoW1+4W+MGHq20xvdyCUNxybIVOpJqCnv1swRrSkaSA9sBXoBLfszJu1TtqUn+hsG2PXP0lheqjkUqFb0bBJCZEZI8dtwStq9ELuNw/4WrLUq0IeNAp2qqEimOaz0uxq5U8cAbvWSndL8l/WLlJBGL2Y5FM3NcrjlljShLR+wtDKLaVmdv4Mc0yfzKfxGimmdSi8j5gOUrTyOJVP52ODlT1UJQa0x85Vjh9mxK5xPWImhSiyZvF2qQJlPfew71jDXq6PManhYPrHFNqyZn6G5qe6QDaypE8hV9nlYmesUzHwWvSBBaQ25d/xaxvO7P+GIHzv/FEPJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB5206.namprd11.prod.outlook.com (2603:10b6:510:3f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.10; Tue, 14 Oct
 2025 19:45:00 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9203.009; Tue, 14 Oct 2025
 19:44:57 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Gao, Chao" <chao.gao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "bp@alien8.de"
	<bp@alien8.de>, "kas@kernel.org" <kas@kernel.org>, "Huang, Kai"
	<kai.huang@intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"xin@zytor.com" <xin@zytor.com>
Subject: Re: [RFC PATCH 3/4] KVM: x86/tdx: Do VMXON and TDX-Module
 initialization during tdx_init()
Thread-Topic: [RFC PATCH 3/4] KVM: x86/tdx: Do VMXON and TDX-Module
 initialization during tdx_init()
Thread-Index: AQHcPG9+J7Pdwu/FJEewYPJK0ygzLLTAdwuAgAAYlICAAMKEgIAAuwYA
Date: Tue, 14 Oct 2025 19:44:57 +0000
Message-ID: <c67feb590e3d7027c618f5a725a94a9c73a295b6.camel@intel.com>
References: <20251010220403.987927-1-seanjc@google.com>
	 <20251010220403.987927-4-seanjc@google.com>
	 <ffc9e29aa6b9175bde23a522409a731d5de5f169.camel@intel.com>
	 <aO1oKWbjeswQ-wZO@google.com> <aO4LVTvnsvt/UA+4@intel.com>
In-Reply-To: <aO4LVTvnsvt/UA+4@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB5206:EE_
x-ms-office365-filtering-correlation-id: da011cfa-597e-4878-ca31-08de0b5a27dc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?N3ZEemRpMFN1U3NyM05RdDJXMllhVXB6cWYva2NENDlRalBMa2k4TEMxVnBp?=
 =?utf-8?B?Vk5LUVBzMlBDUmdjK1Nud0lFcXN5NnRld1plWkNFODhHRnVORFhQTU9mSnkv?=
 =?utf-8?B?U2haY2tpdVpKZTd1Q2R1QWJ5S1RYUGtpTityY3lVd2hHVDc4UjFpaWxPNTNW?=
 =?utf-8?B?TGhVc0JacjJ5ZEJvUEtld1dtcGJkUGdGM0xFQmtjR1FGK1pSekdnZzZNRDFX?=
 =?utf-8?B?Zkk3cjAvaDkvOXYrUDlXZVJwektmVUZuenhCRUVLdDBRaTNDaWZDeDczU3hN?=
 =?utf-8?B?L2Q2MzQvWW1nUlVNNGdCM0NIbDNSbmltSXU0cTcxMGxuNHI1VVY3YjViRSsr?=
 =?utf-8?B?NVR1ODFmcWVsYWcwR3ZNaU55VGpMSEJTY1g1RHR4amhhazBYRk53Nk0xYmRh?=
 =?utf-8?B?MnhZenlkclN4cm8xN0FqTEUya1lyRGU1SVhCT0hiV3d1SzZoV1N6UVJxTzZm?=
 =?utf-8?B?SUJiWDM3cjNuOVlYYkRpUmZPd3VvSVdMa2E2d0RFbzkvRWVsRHk4YUh6MDR2?=
 =?utf-8?B?RjVoVm81S3h5U0xWbGtTZFBjR0N4bXhFNDRhb2Q1UmlGMm5Ydmk3cWJkRndN?=
 =?utf-8?B?NVp2aXY3b3Z4SjkwSElFb3pCbUhmdFFUZmI2TUYvY2hwQnJJU0hUNUxkU3Fk?=
 =?utf-8?B?THJsblJmUVBvRG9jMmtvcFA3TW54aUJOWGRmVzdHNStneFkwRDNveWZwcHdu?=
 =?utf-8?B?SG9SL2pJdFVyT2M1L3RSZU12YXhMVXlhV0lqaThmY3FJMTFDVjI5R0RNMWZw?=
 =?utf-8?B?dCt2cHVGZ0VmTEx5cnFISXVVVDk3Z2t1RmVvZGhNeWcybGZlQXpGaFBRdHE4?=
 =?utf-8?B?bHZ5endIVzNvQXk5bk1TT25kTS9pMG9sOEtkckx4NExKaTFQdHB6cmpEQytV?=
 =?utf-8?B?NGRFb2FtbVpsOTg0dWdEMUJSby9pRFAxK0lSdHNMa0NRbHZoV0Z6OGdlWC9h?=
 =?utf-8?B?eFc1eFY3bnAwd0JJTGFGS2R5WEcvR3ZuZTlkWmhXZUt3dmRRYy82SUZDMzAr?=
 =?utf-8?B?Uy9JK1pPVnVBRy9PeXJwLy9sMFJ4eVNpVkNQSVRwTlB5NjFaZVhLa2VYY2E2?=
 =?utf-8?B?bTQyMGZuRmpIOHpVTVlnbnpuM3MvRlNIdkFDNVRrME9sMGdaSVRrM0FIOEZr?=
 =?utf-8?B?Q2hjWjlRSlFySWdFMTcwVHl4bUpRS1M1NXkxTXJ1czcwWU9UWHBDR1h4MG8r?=
 =?utf-8?B?VlpjMldwZ0tBS2hNVkFtdmc1Rzl2MndrQ29MUXUzcHh5dTZ3ZjRWQVpVUFhO?=
 =?utf-8?B?VHlkMjI5c0wyb2RwNUpOSW4yRjh6ZlZVT0RjWUhzODZuUkdUbEJuSDF5eFRz?=
 =?utf-8?B?a3MxMVFWUFcwRzBpUTdvdzlEVWtWaEV0M3ZNYWlUa3dOY2ZCTG5aT2gzYTFz?=
 =?utf-8?B?bU9rRHRnYllLMHlpa01vNytSdmxXQk9yMWVwdlU5M3dtbWgyOW5UWTlyM1NI?=
 =?utf-8?B?eTlZcnZ5L1lrc2Vmamp6L2RtWGQ1OWpUNnRNak9ud2Evb0htOVVIaU4vVU1Y?=
 =?utf-8?B?ZzBEaWJ3VTNHZG9FWkFSUmQ5NWdTQlRBV3hJOUlXZklvdnFPeEZXUmlZbEVj?=
 =?utf-8?B?aDQ1TitVV3FLZWEyOFRRWktjTE1iWklncG12UzdYT0ppbnVWZXl5VnZQZGJi?=
 =?utf-8?B?ZVRHSll1UGlIR05XNjZmYmJZQ05MazhYdEhSRVY1NmxBS1pRTWlQNGZKL3Ja?=
 =?utf-8?B?aFlocDI4T0wxdnJxSC9rTDMvUk1nSmp5U3ZGZUllUVdBRmNTZW43ZzluUmxq?=
 =?utf-8?B?Vm9nKzArL2pSejVkTjVjdlBra1NNNnBQTi83UGxsSGdRTkNrRFJZVjlUNlZa?=
 =?utf-8?B?R1RjK3hJSktUQWgvYzY1ekJmeUdBbGFQcDd1RmVCM2QxZDQ2SDNIckNRYnpE?=
 =?utf-8?B?cnZCbGtGS1F5azU0M2N5aVRvVkg0cXVyVGpUYmUwbk5yQlo3ZnpkaWNUZTNI?=
 =?utf-8?B?VCt3ZnhScHFBcjlpQTRjOU8ydDFhOGszYzBLRkJWcVlsV2I1RzFSdmdvM0Vw?=
 =?utf-8?B?RlR0dUVKY3ZoR25XeFdQU1JGeEhhNWhtdE5INFk2aDBJTTRmVW9NZVBuRkVE?=
 =?utf-8?Q?TOHCgD?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a1dqbHdxbDZEajFJUDF4ZWdNL2xpcVVlOXcvTXB5WHAybkpUVm1GZnRpYW5D?=
 =?utf-8?B?K3B1c0UrYzZmMy9FUmROdkw2NEdLMkVvTjhqRTBqZ2JCN0VubkNJQXN0NG5a?=
 =?utf-8?B?Z01QRTV4Mm5zVXhZZ3FZSU4rUm9DM3JuMUVYSVZEa0dTYSt5R1Ewa3RiNTBx?=
 =?utf-8?B?ZmlLRy93NlRHUURGMmtpOWVqcDIyeEpEejM4STRmUzd5Z3FpdzI5bjJOUUtG?=
 =?utf-8?B?dDk0Z0swODhNZkhYeXBabnpIOGgvYkxHeWJBMEJPY0xEY3lKY2hLNFkrbVNs?=
 =?utf-8?B?NDVKU0pmTmdQYzVyaThxSU1seDhrZXdKMDNWMGxuZ1hjMERlVUxuSHFrQ0Iy?=
 =?utf-8?B?dGZrWWZqUXlCY1JUN3hKUmM5cUVZS3VNd1NUeCs1ZzR0MHdVbmVxV04rSjRQ?=
 =?utf-8?B?ekU0WUdDTXlOaGF2ak14djMzOUt0QkREM0RFakJCSXU0NFV2dTlrZGRRN2tx?=
 =?utf-8?B?My9IeHExUDRsbHMzUFEwSzVEQTU5dEpkQk1yUUtibDF4UVFEM2NWUE42b0hp?=
 =?utf-8?B?TlAwaDJJMEpXMTBldHhnUENWVDdqS2RjWjNXR21ObXJHWk9XY3hpUW5oYSsz?=
 =?utf-8?B?OVdaZXVTYTZtaFkvT215dmZ6c1UvU0prZ2IwSjNnL2RqS3BMRVMxUlBVc0lL?=
 =?utf-8?B?WTdic21TTjB5cEIzaUZJRDZVbmhqcWVOWnZmOE1DWHFIa2lJdktrMklYN2tE?=
 =?utf-8?B?bXVDY1RMNnhDdUtBWGcyOENjTzFIN1VNMDRPbFoxNS9sdUlQUytmbWFCNjlj?=
 =?utf-8?B?RllDbGNLYkxEUEs0NnN2V3lvbWt6QkhZZFhjUlRWdWZYVVBWYUFrcENJL2Na?=
 =?utf-8?B?OWNhb01yeUFub0pGSU56ZDA3YWRlU2srS01yZkhwd2NtZkhkNUlMRGw3aEpY?=
 =?utf-8?B?TUhzK2R6c1pUQklHdGk3NEd0OVpEUStwNmlQbkY3UDlsUmNOTEE5Q21SeXgr?=
 =?utf-8?B?cXlRd1k3S2tRWlY2aDMzd1VpVEJ6L1dLd3c3MzdqS0d5eW4yRlVMNGxDbnhN?=
 =?utf-8?B?czNxTEppbDNWR2ExeWF3dC80NnBPVmxDUU9rSTkreWx6QXk0UVZRUTRHVDFm?=
 =?utf-8?B?d3lSYW5Ib2N1bWwxYU9sanpaR3lBSFFVREVRV29SNUhJck5YdEZPSExFcGUy?=
 =?utf-8?B?QWorY2ZPUHlRZnJkc01yU1AvQ1BIYWRVQ2NITmpqZUd3aHhkaCtleDNSa0V2?=
 =?utf-8?B?VU03WnZKa3FyUWVsbTh1a2pRSk9ZalpqbW53aXBCSyt3cm12bHF0VzN5NjRJ?=
 =?utf-8?B?bFlsR3Fsc3d6b0hnK0JZd3NiazVodlVOT254cHQ1NjEwemVxS2tTZ0FzS0x3?=
 =?utf-8?B?MWt6ajdLb2ZWTlBldjU2UGVjZ0hrakd0clI4S1VVVVAvMjQrYU9EK2RVUFdK?=
 =?utf-8?B?blczTTMwTDBwNnZwOW9weTZ0dFJVZ24wYzZTMCtwY3llQXNCRnRqNTVPdlNH?=
 =?utf-8?B?OVFzbWZuSjhpN1FPNkFuMG1VMmdFa1RHaG0yVGl2bzIxMTVITXErV3JiR3Rz?=
 =?utf-8?B?azlUVE1pQmltTFFTd3IremZjZk4vbExOeVZxVmZHb0NoeGJDSGovRkJFOGIy?=
 =?utf-8?B?WXdTZUdYMG5hWHA4NE13ZWlVYWNDTzNTcFdoZFVJRjFlOGZQQ3U2eEEvZ1pp?=
 =?utf-8?B?TThEQ0plTFAxYWd1VlpUZEFpRTh2dzlFQm4zSG02YTdQZGR6cWVmdGNkYnBy?=
 =?utf-8?B?UllwWHUwSFU3VFc2QVJ4d2syOGhFM0VtcmFIUWJ0bHpncEpRaGtKbXVBK2ZI?=
 =?utf-8?B?NTQwUGdOMjBra3BGRVpQdnFZUmpuSHBWLzR1WC9ZUVEvck9SR1BncnFmQzE5?=
 =?utf-8?B?N0ZhUnl4MGF4cVpxVTlnYWZYbS9QQUNyNXpQY2pDYmFEMFVkaStURGVGK2xk?=
 =?utf-8?B?dDdtMDR2aTdIMWkrZ1ZwZzc5TFZPTW9POUxFZ1NtVUx4MDM0WkYwWU5Rbito?=
 =?utf-8?B?R3FNQmtKL0ZBZnBsUGdwaXQ5aEYzSG11YnZQcWtwY3NWNlRCTUZQRldWcXE4?=
 =?utf-8?B?OVRTaHFGRWgwNGU0eFBvSmk4TExEVG9sNTJYZDFnNlNadTlxVzA0OVFQTmpL?=
 =?utf-8?B?TWpSeFJYTHBFTkpGYW84OGFIdkYvWEhSK1NnanZMMlZLNzlkVmp2YUh2ZjBh?=
 =?utf-8?B?dTArNUlpaGhqYXROZEtZS01ueGl6YWowN1ZzZWE5b3hiUUJObmEyaDlEM0xB?=
 =?utf-8?B?bkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F71DEF1F4CB6464EB1211B677866D45A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da011cfa-597e-4878-ca31-08de0b5a27dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2025 19:44:57.6514
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BUFK9bb6ihNPho0bpOW63Ypf0iXhrU68ZaYLnvn4S2W3nE6X1MX0MFemPAemhq46/TaVW61LawfBGzzZaZvTkMarImf9DsAI7bFX79fi64M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5206
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTEwLTE0IGF0IDE2OjM1ICswODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gSXMg
aXQgYSBnb29kIGlkZWEgdG8gY29uc29saWRhdGUgdGhlIHR3byB0ZHhfb2ZmbGluZV9jcHUoKSBm
dW5jdGlvbnMsIGkuZS4sDQo+IGludGVncmF0ZSBLVk0ncyB2ZXJzaW9uIGludG8geDg2IGNvcmU/
DQoNCisxDQoNCkl0IGZpeGVzIGEgYnVnIHRvby4gQ3VycmVudGx5IGluIF9fdGR4X3RkX2luaXQo
KSBpZiBtaXNjX2NnX3RyeV9jaGFyZ2UoKSBmYWlscywNCml0IHdpbGwgZGVjcmVtZW50IG5yX2Nv
bmZpZ3VyZWRfaGtpZCBpbiB0aGUgZXJyb3IgcGF0aCBiZWZvcmUgaXQgZ290DQppbmNyZW1lbnRl
ZC4NCg0KQW5kIHRoZSBjZ3JvdXBzIHN0dWZmIHRoYXQgZ290IHBsdWNrZWQgZnJvbSB0aGUgcGFz
dCBzZWVtcyB0byBoYXZlIHRoZSBzYW1lDQpwcm9ibGVtLiBJZGVhbGx5IHdlIGNvdWxkIG1vdmUg
TUlTQ19DR19SRVNfVERYIGFjY291bnRpbmcgdG9vIHdpdGggdGhpcyBjaGFuZ2UNCmJlY2F1c2Ug
aXQgYWxzbyBmaXRzLCBhbmQgaXQgd291bGQgZml4IHRoYXQgdG9vLg0K

