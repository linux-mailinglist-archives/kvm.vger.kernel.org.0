Return-Path: <kvm+bounces-56022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68DB0B3921D
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 05:13:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 299D2464C8D
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 03:13:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2827A2620F5;
	Thu, 28 Aug 2025 03:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J32hstrs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194101A23B1;
	Thu, 28 Aug 2025 03:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756350799; cv=fail; b=meW8uUhyAdSVg9ApSjWF8LgMD4swLOk4DlL963iNr+2/Z1VW5jJsTC3QkohVrLSDXjGP5mKx2BBcDxGxqJ6IP79OCnt8f81BN+f4B6P/s/dtp3MGH/F8FPAYXmYH4kyjztYiAcR3AzZQKYw7yv9ycJWLLUmQx+t51jobxtExBDU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756350799; c=relaxed/simple;
	bh=FBbT081HwgenXxYimfarZFiMZZJbh+VdSDpQBC3UqrU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LRFQ+AHwWKxnnReBmNOqYHTnG7aq7JYavbuWbHxFCJdtSIDO815a1aw0YHuD+grNTRaJDKYb+txHM0AT2BRXBoThlXvE/hGIhoIVAO+KTADiF8GSdrBqCOE59vj4LSVmsmHq8UfaLpw6ZrjLfJ1tBEICAdnTfhhWSGThi7QJnSc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J32hstrs; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756350797; x=1787886797;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=FBbT081HwgenXxYimfarZFiMZZJbh+VdSDpQBC3UqrU=;
  b=J32hstrsxo5euL1U/lexuTmjdWYQrxG826VpmjOb19l/7STbKEZ523hP
   Y4Soielz8d/3fj7ac+bqLdshukFo4r6ILrZW34p9PkF78l0xWz+gyAvTc
   BUfQBtURAqmNKkwNDKlMM4YGXODYd3lTundaRtZBWv0WV4hFolxZA6SjX
   FHDY9SjnEJLv2QR0r+OMh5IYnXdItEgL6m3WL2cSMWMUxSCdKxTqXT+Gh
   t9L9am3lfOoXqgLvL9x6Bt/TNYVKFVQ7YzYZlpyVgcRl4J0JiOy4ljl9E
   rEafGX4aajWFnc4ChYMn5HVzfCcjwcEUyDivkCSbfkmnmO5wqac5hCXHh
   Q==;
X-CSE-ConnectionGUID: 4TNKTT2pQ02DO73QLJ6NpQ==
X-CSE-MsgGUID: rwXvkrTnRLqn8dm39cwbsA==
X-IronPort-AV: E=McAfee;i="6800,10657,11535"; a="69204779"
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="69204779"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 20:13:17 -0700
X-CSE-ConnectionGUID: EZhPSbSOSKybJQbX5tDs6A==
X-CSE-MsgGUID: yCMDxwhrTYm5tV+O9gbWnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="174168178"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 20:13:16 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 20:13:15 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 27 Aug 2025 20:13:15 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.55) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 20:13:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U5Ly8j0u2EfpPcM5vs9Kkwbn4lKlbWQp1HD0+WOldV6eeFNUh8LY1rsKDwcSjAz3hCxe+z88weDOmQSsKVnj5EMxVKSleWyeMVpV9s+UVKHThbMlrASWBb7kR4HjWOKQ16Pa/HOUzGLOiQ0MP6BFT6rS9sNedwZU1cgnS7kP0UYvHX0pXwKKybXhzv6wLrkHQGfH61XzIkUdYw3jMy/kYKuMCgLdVSGjpeir/EHOVXmzjds4HJUEu72FuTmnJtXhx1YZS1yk5MugoBJzZVZO0KV2+NKSml+3i24aBuD12Y90oSGrHzauEpI37LL1Iaxn8OH2aNjz9cVMEQoGzVib1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FBbT081HwgenXxYimfarZFiMZZJbh+VdSDpQBC3UqrU=;
 b=boJjj6S/UrwAWuABqzQjmoUJ//6rR7+sAM8XCbcPXQojhvh9wbGJO1Usl4vCesRcTu0qboVS/MNsYk3T9KKBxIpMmcmV6wxfN54i8mFg9Wub8LTPyd2a+3YctbSLp+iQ5ZuHnvVRAGPE+4MoY4gUHfYs/orY5vRZbiZGJtH4MZVJAOcBPvuL1DNYOdsSQFSQlXDbdqdILs9Xyhfop+oDpVAvDJytXrwRM44RLPgClxOswH0LUN9WFZ/9R7xDNVR3bXOS1num6UTnfmkv6zEt1pRs7n9pVTq0DJ3SWXQmgAnHyHVPMK1/6Z5RAv+TfG51JEzynredyl+bmDKCuQQ9rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB6794.namprd11.prod.outlook.com (2603:10b6:510:1b8::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Thu, 28 Aug
 2025 03:13:11 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9052.014; Thu, 28 Aug 2025
 03:13:11 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "Weiny, Ira"
	<ira.weiny@intel.com>
Subject: Re: [RFC PATCH 09/12] KVM: TDX: Fold tdx_mem_page_record_premap_cnt()
 into its sole caller
Thread-Topic: [RFC PATCH 09/12] KVM: TDX: Fold
 tdx_mem_page_record_premap_cnt() into its sole caller
Thread-Index: AQHcFuZaMDeZr458G0eulsQOyqpL0bR2NLWAgACpbYCAAIduAA==
Date: Thu, 28 Aug 2025 03:13:11 +0000
Message-ID: <3dc6f577250021f0bda6948dedb4df277f902877.camel@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
	 <20250827000522.4022426-10-seanjc@google.com>
	 <aK7Ji3kAoDaEYn3h@yzhao56-desk.sh.intel.com> <aK9Xqy0W1ghonWUL@google.com>
In-Reply-To: <aK9Xqy0W1ghonWUL@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB6794:EE_
x-ms-office365-filtering-correlation-id: f5305a8e-73f3-4206-568b-08dde5e0d1d9
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?U0VYMDZ2RUoxS0syU2diazVjQk9KQVFYNE1nWW81aS8wRnEyVGUvTy9BYzcx?=
 =?utf-8?B?dHFqS2lzRTYyQW5BTlNoNGlCZEZMZnVBd0UyQlI3U0h1TC9EM0hFNmFVREJG?=
 =?utf-8?B?cktRUG5ZUXJlRndxTnM3d0crV0F1VkVrb3hJSEZxdlU3akVrZWVWNWp2dTRu?=
 =?utf-8?B?cXVOZTJ3cjhzd09mRkpyRGc2L1NWbjQvaTlUZFBXZ1loejVTT0d1YVpTQTI1?=
 =?utf-8?B?Q1c0R1p5aG5pTXN2T0ZCRmk1dmVYNlBhUUVrTDZZM3RSdFgrbGthdkY2Q1FL?=
 =?utf-8?B?bGFwc0pBZEI5Q2NrUnJpYkdDRURnKzFBK3NDRVFKQ083S3FwQTVoTUtacE1p?=
 =?utf-8?B?RjdIOFBFNGgyTi8zR3JQQ0d5RWJpN2h1MjdLaE9oTFJVRzF2WVQvOUFQTy9s?=
 =?utf-8?B?ZnNOSndVQjlRdlUwWUlVUDZNL3ZCY1ZBS29IWThXOENWZ2tzK3Q2REtpYWZ3?=
 =?utf-8?B?V1JYWWFCUDZ5R2Z1enZNdW5jVmF4eU1jYXZHZ0VpcW5LdjVaT0hBNGd3dXVl?=
 =?utf-8?B?WmNLVDY0NmFWdTV5VEFGWEMxRFFENEYvbGZsVFY1Z2VTQTBpL0Z0Nkx1dGEv?=
 =?utf-8?B?dFpzbjJ4SDFGdDgrb3V6OUYvbG5oQVZINkM4bHkzb0tKZTdZZTdzbkFsYXcz?=
 =?utf-8?B?UWhOUXc0bEdrcEZ0L09KNExoajg3UzI3QXowMUtiMytORktRQXRrVjlVV1hx?=
 =?utf-8?B?YmkvMTl1OHBOSjFZenhWYkoyR1A5NHBzZ0Z0d243QTkrY0YwYWk2ZVJtdmVL?=
 =?utf-8?B?RXRzOExrSXB3UnNNcWdZUXF1aE5qY3lNTUE2VDVzakxxUjBRTGg1eVZpMjNQ?=
 =?utf-8?B?NE5mV0dlb3NsTGpUemI2MEN0Sit2TnFoWFFUd052d01VT2l4aktyejVUMjhK?=
 =?utf-8?B?MFVMTDM2UFptcEZkVlZzVSsxVVBONTRFN2hDK2lBcGpReTlBdEpCNUpEM05C?=
 =?utf-8?B?U3JLSGVWZnhNeDYvekVETFdSNktFUjdoTHA1Wis1Y20rTEttelVUZWl2ZGVU?=
 =?utf-8?B?UFkyMUYxV1dvWnYyTlE5TzZEUGFWclBDNFhvNWZ1a29wbkYyZzl1dWliaVZS?=
 =?utf-8?B?OWo0QVBYdlVRc0MwSXZIN3FVR2MyUXBkQnVLamRXUG5UYkRaVjZQeE1JcWNn?=
 =?utf-8?B?ZHp4N2tpclhybEYxRW0vYjFsU2wrUS9oSHdrNWxyYnliYmJMS0dYVkVacUV2?=
 =?utf-8?B?MHlTNG5YeEtmNmJCTktkYWs1WmloR0dGUXhrMTFwOGhmamdhd3RBb242OW0z?=
 =?utf-8?B?WUdrYXBOcmJkbW1sZkVyRTRZYTVPQ1dWVzcwdUNBSkRUUDhnaHJmY2dBaThX?=
 =?utf-8?B?bU1qRUEweHpZZm1lMkgyMUJ2Y210MFlDSnIzdnhGdWlubnZHMHVGVFVIVkU0?=
 =?utf-8?B?WU9UeTdoMGVuVCtwYmpROUphYzR1eFNvVFM4bXM0VWtxZkF2MXNWV1ozL3E1?=
 =?utf-8?B?blJ1ZjludXFjakIzU1dicDEwaFZGNjNKa0VJRmJaUXlXQnJSSlpCc2ZmMTMv?=
 =?utf-8?B?WmJKUE8zWG9xL3VBMGt0NmVUdjArMDFiU3JsZzcrdnUxTVk3bUJ3U1oyMHN6?=
 =?utf-8?B?VlZhbTZhbWozV1dUc1R2cnlScHV1eVZ3akFXQk9BNFg0ekFMeFlqdHY2UVk4?=
 =?utf-8?B?bHI3TWh1N3lPZlZvQ0poRVZ5WlhnQlIxcEpBcFkwREUwSFhwRjlpcXJTSGpU?=
 =?utf-8?B?cms3WDlUTndHeEM3aG83TGFaVVRCMHBqZHYyNUlhNTZGcEVHa2sxOTFuNjFU?=
 =?utf-8?B?dmNQSnpkVWREUEZBZ29CVlJEZEhMUERBbFNoVFFwaVNKMnpoUGdOY1RpSnFh?=
 =?utf-8?B?VHdqL1F0Nk84SlJlY2JvK0IyVWRUVzhEZXl0dmRGTWdmbHRvNkxJUUNKZnJq?=
 =?utf-8?B?d1VFL2ZQeXBTSFpKMHA4TE9mdUxEbnMwY0JraG0xZlB6dk55N3g2U09JSkZz?=
 =?utf-8?B?ZWJDNmEyTndkK1IzenJ0WlloaHpHYnBsei90aFd3YmhDbk9NTWgydEFGUDkr?=
 =?utf-8?B?VFpkMGIrbjN3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?clRoR3NXQlh4QXFYamZzaFlaZm5mZ1ZIVlB1VnNIRHFZSWpyZWJ1TWtld08w?=
 =?utf-8?B?VTJmYzNUd01yekhFa056U2FmaWlSKy95YW1pa3pRNHdldGZiaGJCZUo0NDFq?=
 =?utf-8?B?TTcyM2tCMUNhckdYU2w2ZEVlY1V1dEcyMFROZkFjbVhnSFV4OHNTWWkyakdQ?=
 =?utf-8?B?NG9rTElISTlmbFJ2cXliUmZNaTB4MUlQTGQvSjl6Tmxpak9FT24yeU5WbGlt?=
 =?utf-8?B?alJFYjZ1WTcreGx4djRwd2N0Mm1oMFRGTGNBWnMxUVZuQi81ZmhFbGlqTXpQ?=
 =?utf-8?B?em5yZVNHNXRCNUVHZU05a1Q1SGJmeDZ3OVFHZTNzKzV2VFVLTXJWVXM4TGpO?=
 =?utf-8?B?YTdmOEJFenVtci84cWw4bk9DTkhWK0JnNUdUbVlNYVJUTEErVnkvWnliU2kw?=
 =?utf-8?B?UENsZTlNQmdPWXNKS2NVczlkOU5jeXRVd3ZnUjJJZUdKU09Zai9oWlNoa2V3?=
 =?utf-8?B?eFpLeFdmdGg4c3NMblR2cnY1KzhDZW1qWnQ4cXJUQkdLekx0ZFpxQ3o5bGtv?=
 =?utf-8?B?RlhmMytmM0xjY3lnSEp4eGdCMDNJVy85b3hUenFxY1Q3NlhqMnY1bXZESGVE?=
 =?utf-8?B?RHM5WlV3aHlhN0lNVGRDWWRiaG10R3hxT3dhNHhVS1NYazlxRTBaREF0RWRU?=
 =?utf-8?B?bUJiRXFZOTRndmNNTnptK3pZeUpBckp4Z2hsdlgwS1Ryd2dJa0dXcCtSN2VB?=
 =?utf-8?B?cUUzdDBSbmcrUCtvZWJWaG5kRUhMMmJxZkJBN0dDYUV2WXkyODR6ZVFJRTlj?=
 =?utf-8?B?ZlFYUldYZnBETVFUWEJCQUdqS1RLZ014N2F1Z2ZzMkdqVDQ3Y3p2dFFjRGkx?=
 =?utf-8?B?K2kweVQyeE0zbjFTSmRHRWk1TWtoVWR3dFdDTDdjSXNpZzVzVWRhMW5RR2pk?=
 =?utf-8?B?cVNYekVPY0thVlhwYUZiQ1gwdWJpQWNmY1FlcEtJUnNCdTZIWGMzYXpkU3hR?=
 =?utf-8?B?VHptZFRmOHpDRHZhd2VpTlR0bWtnTVNYdzMraFJYYVBJNDdsdXBHeDM3NEYz?=
 =?utf-8?B?ME9JcWhUME9FMVNWOTNIbEIvQjBEcGFvRlpldm5zaDNBcFBkamZ6cjlGNHRB?=
 =?utf-8?B?YytsSjllM3lwa0kvUklkRTNYaENtZkw1RHg1d09UTXVPQVZ0cUw2MkxndE4r?=
 =?utf-8?B?S043RkdmNDNpcGJRNW9zVEFma1UwbktZUFF2Z2w5YVhtdlNObEZQUTk2em5i?=
 =?utf-8?B?RmRYajNPdis1UkFZbnkvUUZkUk9iczJGWjg1WFg3YVMvVDVMOGQxOVZySitK?=
 =?utf-8?B?N0tGSS9uNTRMNDB1NzdiRDJya3R1aW0xbnBpLzdRR2dqSG5mUUhWNmd3WGM0?=
 =?utf-8?B?ZW9MRVVhWWNIN3J3UEoyK0lXY2Ftby9vTldyRGF1TXRlZnJFUU1PSXpFdUNs?=
 =?utf-8?B?ZTlSSXc5Q0JJbG5wbERWTkZDMXQzeFM3dENEV3dZaVB1WWJ1eUtQQVhvZlRx?=
 =?utf-8?B?Z2prQ1ZhTE42YnVuSjhLOEtoVTIrbWtvQkI0SnlVaGx6Nk5QUHFVS0Y1V1RT?=
 =?utf-8?B?emZXSjJoUnVzeVZDUEEzZmJsdkt5dXNiRHh6N0NUNHl2cjhiZzFZZE1VN0lM?=
 =?utf-8?B?eGkwL2tobXp3WGxzMVg4WXlHbzFYS1JtMmUrZ2pKM2ZleUZYaFB2ZkVET3Fn?=
 =?utf-8?B?WUhDTGcxNHQvRVRFcXlvS3EyMkNLZEdXMlFobkxyTC9jZmtISVNvYlpkYkNP?=
 =?utf-8?B?cDFVeWRRMTZWd2VNMWovRU9CVWRVMDdRK255UVlPUEg2UGp0K3FtUXYrMWlX?=
 =?utf-8?B?bHVnNFdROWltTFV2T0VvanFaWFRGd2tHTms1cjZMSU9jVVVQL3RCYmFMc0Qw?=
 =?utf-8?B?QTAyd1lVSFZHRnRpWU84bGE4TFJhSkx6Yy9iMS9jdU9QRk02WmNzVTEzZzBK?=
 =?utf-8?B?T29sWTB0bkI5UjJSdUdRSmxUczFSRCt5aDBFcG1DaHpyNndDR3VkTU8rc3dt?=
 =?utf-8?B?djUzWDFwWVUxWEp1SmpuRDgxRXdEaDJwUTQyeHYzTk1uZmxtSG1RWCtNenRF?=
 =?utf-8?B?SlpBN0VVT2dnUVNJU1dvb1hQUkNGZzRkekVBZTlGZ1Q2UXJvQmxsVW5IdFFt?=
 =?utf-8?B?aTZEZW9lb3I3bXUxVXF5VWl4ci9jMjA1WXVLWmNiSjh2N25ncVZ5VTlScGhz?=
 =?utf-8?B?dDM3MDR3RkRUUVd2Y0ZRNW90bm9LTjYvM2UvNGtVRkpXWk1zYTZvRkRPMmpY?=
 =?utf-8?Q?ajCwrlsS4vpOpl/1/GdSCEY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <54435E4EDAD6224C890C20112020F21A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5305a8e-73f3-4206-568b-08dde5e0d1d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2025 03:13:11.2146
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LmH0Nm5t3CMpIi/VDn3HgS7Zg54gWFERq+Zi74uoD/Ecs7ruEXF7PN9S9OPSqj8IGHztvfbD0AolAw8wruNVOD8RJlICr0upavkRPHUaFZA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6794
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA4LTI3IGF0IDEyOjA4IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IGUuZy4sIEJlZm9yZSBLVk1fVERYX0ZJTkFMSVpFX1ZNLCBpZiB1c2Vyc3BhY2Ug
cGVyZm9ybXMgYSB6YXAgYWZ0ZXIgdGhlDQo+ID4gVERILk1FTS5QQUdFLkFERCwgdGhlIHBhZ2Ug
d2lsbCBiZSByZW1vdmVkIGZyb20gdGhlIFMtRVBULiBUaGUgY291bnQgb2YNCj4gPiBucl9wcmVt
YXBwZWQgd2lsbCBub3QgY2hhbmdlIGFmdGVyIHRoZSBzdWNjZXNzZnVsIFRESC5NRU0uUkFOR0Uu
QkxPQ0sgYW5kDQo+ID4gVERILk1FTS5QQUdFLlJFTU9WRS4NCj4gDQo+IEV3dy7CoCBJdCB3b3Vs
ZCBiZSBuaWNlIHRvIGNsb3NlIHRoYXQgaG9sZSwgYnV0IEkgc3VwcG9zZSBpdCdzIGZ1dGlsZSwg
ZS5nLiB0aGUNCj4gdW5kZXJseWluZyBwcm9ibGVtIGlzIHVuZXhwZWN0ZWRseSByZW1vdmluZyBw
YWdlcyBmcm9tIHRoZSBpbml0aWFsLCB3aGV0aGVyDQo+IHRoZQ0KPiBWTU0gaXMgZG9pbmcgc3R1
cGlkIHRoaW5ncyBiZWZvcmUgdnMuIGFmdGVyIEZJTkFMSVpFIGRvZXNuJ3QgcmVhbGx5IG1hdHRl
ci4NCj4gDQo+ID4gQXMgYSByZXN1bHQsIHRoZSBURCB3aWxsIHN0aWxsIHJ1biB3aXRoIHVuaW5p
dGlhbGl6ZWQgbWVtb3J5Lg0KPiANCj4gTm8/wqAgQmVjYXVzZSBCTE9DSytSRU1PVkUgbWVhbnMg
dGhlcmUgYXJlIG5vIHZhbGlkIFMtRVBUIG1hcHBpbmdzLsKgIFRoZXJlJ3MgYQ0KPiAiaG9sZSIg
dGhhdCB0aGUgZ3Vlc3QgbWlnaHQgbm90IGV4cGVjdCwgYnV0IHRoYXQgaG9sZSB3aWxsIHRyaWdn
ZXIgYW4gRVBUDQo+IHZpb2xhdGlvbiBhbmQgb25seSBnZXQgImZpbGxlZCIgaWYgdGhlIGd1ZXN0
IGV4cGxpY2l0bHkgYWNjZXB0cyBhbiBBVUcnZCBwYWdlLg0KDQpBaCwgSSBqdXN0IHJlc3BvbmRl
ZCBvbiBhbm90aGVyIHBhdGNoLiBJIHdvbmRlciBpZiB3ZSBjYW4gZ2V0IHJpZCBvZiB0aGUgcHJl
bWFwDQpjbnQuDQoNCj4gDQo+IFNpZGUgdG9waWMsIHdoeSBkb2VzIEtWTSB0b2xlcmF0ZSB0ZGhf
bWVtX3BhZ2VfYWRkKCkgZmFpbHVyZT/CoCBJSVVDLCBwbGF5aW5nDQo+IG5pY2Ugd2l0aCB0ZGhf
bWVtX3BhZ2VfYWRkKCkgZmFpbHVyZSBuZWNlc3NpdGF0ZXMgYm90aCB0aGUNCj4gdGR4X2lzX3Nl
cHRfemFwX2Vycl9kdWVfdG9fcHJlbWFwKCkgY3JhemluZXNzIGFuZCB0aGUgY2hlY2sgaW4NCj4g
dGR4X3RkX2ZpbmFsaXplKCkNCj4gdGhhdCBhbGwgcGVuZGluZyBwYWdlcyBoYXZlIGJlZW4gY29u
c3VtZWQuDQoNClJlYXNvbnMgdGhhdCB0ZGhfbWVtX3BhZ2VfYWRkKCkgY291bGQgZ2V0IEJVU1k6
DQoxLiBJZiB0d28gdkNQVSdzIHRyaWVkIHRvIHRkaF9tZW1fcGFnZV9hZGQoKSB0aGUgc2FtZSBn
cGEgYXQgdGhlIHNhbWUgdGltZSAgdGhleQ0KY291bGQgY29udGVuZCB0aGUgU0VQVCBlbnRyeSBs
b2NrDQoyLiBJZiBvbmUgdkNQVSB0cmllcyB0byB0ZGhfbWVtX3BhZ2VfYWRkKCkgd2hpbGUgdGhl
IG90aGVyIHphcHMgKGkuZS4NCnRkaF9tZW1fcmFuZ2VfYmxvY2soKSkuDQoNCkkgZ3Vlc3Mgc2lu
Y2Ugd2UgZG9uJ3QgaG9sZCBNTVUgbG9jayB3aGlsZSB3ZSB0ZGhfbWVtX3BhZ2VfYWRkKCksIDIg
aXMgYQ0KcG9zc2liaWxpdHkuDQoNCj4gDQo+IFdoYXQgcmVhc29uYWJsZSB1c2UgY2FzZSBpcyB0
aGVyZSBmb3IgZ3JhY2VmdWxseSBoYW5kbGluZyB0ZGhfbWVtX3BhZ2VfYWRkKCkNCj4gZmFpbHVy
ZT8NCj4gDQo+IElmIHRoZXJlIGlzIGEgbmVlZCB0byBoYW5kbGUgZmFpbHVyZSwgSSBnb3R0YSBp
bWFnaW5lIGl0J3Mgb25seSBmb3IgdGhlIC1FQlVTWQ0KPiBjYXNlLsKgIEFuZCBpZiBpdCdzIG9u
bHkgZm9yIC1FQlVTWSwgd2h5IGNhbid0IHRoYXQgYmUgaGFuZGxlZCBieSByZXRyeWluZyBpbg0K
PiB0ZHhfdmNwdV9pbml0X21lbV9yZWdpb24oKT/CoCBJZiB0ZHhfdmNwdV9pbml0X21lbV9yZWdp
b24oKSBndWFyYW50ZWVzIHRoYXQgYWxsDQo+IHBhZ2VzIG1hcHBlZCBpbnRvIHRoZSBTLUVQVCBh
cmUgQUREZWQsIHRoZW4gaXQgY2FuIGFzc2VydCB0aGF0IHRoZXJlIGFyZSBubw0KPiBwZW5kaW5n
IHBhZ2VzIHdoZW4gaXQgY29tcGxldGVzIChldmVuIGlmIGl0ICJmYWlscyIpLCBhbmQgc2ltaWxh
cmx5DQo+IHRkeF90ZF9maW5hbGl6ZSgpIGNhbiBLVk1fQlVHX09OL1dBUk5fT04gdGhlIG51bWJl
ciBvZiBwZW5kaW5nIHBhZ2VzIGJlaW5nDQo+IG5vbi16ZXJvLg0KDQpNYXliZSB3ZSBjb3VsZCB0
YWtlIG1tdSB3cml0ZSBsb2NrIGZvciB0aGUgcmV0cnkgb2YgdGRoX21lbV9wYWdlX2FkZCgpLiBP
ciBtYXliZQ0KZXZlbiBmb3IgYSBzaW5nbGUgY2FsbCBvZiBpdCwgdW50aWwgc29tZW9uZSB3YW50
cyB0byBwYXJhbGxlbGl6ZSB0aGUgb3BlcmF0aW9uLiANCg==

