Return-Path: <kvm+bounces-47031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A079CABC844
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 22:17:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4086F17D7AE
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 20:17:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13B5E2185A6;
	Mon, 19 May 2025 20:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M/i8tz/X"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942002153D6;
	Mon, 19 May 2025 20:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747685830; cv=fail; b=F1+y3L39+4e+kXGFPdKEDDHXNcO1JCojcqcNLOAAOSAJEmvDkleIYzR2Ty2rFtmS6rYc7vX9ltnPd/5gOTe9GzAX8bCD9zJYVwH/f/JNijzAB7y8OyCTW7KV1Bwwsp5BjTQtWZeArJC3WRp0scO0VT9dxRdHFH9JaJOZLN8ba84=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747685830; c=relaxed/simple;
	bh=veZNv6Yjr1tF1V8hu6wxGO2qbLRHlo7Od6vo/TNPa0w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AyULylB18AJPxusmdqcyP+k3AGCnwhj1NqdnznumZUR1XzeF2jEuavCjeT22VHtOYIZ/Te+OcZoivxM5KNeQ8Vt0BdfPPrDVCATLKNDMM4SB9amdTHPKiEXey63UHSfLoQfbbqaxrwy4HfngeB3SnHTq4DXyMjXZO4v32SmYFSs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M/i8tz/X; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747685828; x=1779221828;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=veZNv6Yjr1tF1V8hu6wxGO2qbLRHlo7Od6vo/TNPa0w=;
  b=M/i8tz/XEhSCub/8goDAhrqv7YLBL3SRaNU8MGv7oWA07UedkxXVrfQX
   FnNYwrdW8FTDC3gqIG86jwgO+/Ny3fhNPQHwCJvfBEnqiCcTDgRtWqfK+
   yPLzl+/CtD2iGayGsag6UGT3JbZI0OAlQXlB//aVFNDV3NvZTw7U+mEfx
   McNTJEb8h0z0nLNmv9bJJ2p5yPDUTwCbC9ElU7dwYj2DRCVUsbvlkAbka
   MOiqEPcSdbeASZTF9Iu6e1ZmAEE1NKYXg9ujRMmyTQBuA6flDiF4UE+GF
   PkRPtXV2We/HhXjeU7h6cd5N8OfAQrsU4WiMwDwkVU7BdVxrNsZ8DpWkZ
   Q==;
X-CSE-ConnectionGUID: r2g0DwJMQOGkinOO9VMugg==
X-CSE-MsgGUID: IHWIFcBpTdSHNPjD7F6L2w==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="53397209"
X-IronPort-AV: E=Sophos;i="6.15,301,1739865600"; 
   d="scan'208";a="53397209"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 13:17:07 -0700
X-CSE-ConnectionGUID: yHtJByXrSJyaN+QepWsktg==
X-CSE-MsgGUID: mQJdShjwRcK/TuHAQnkJAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,301,1739865600"; 
   d="scan'208";a="144464992"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 13:17:07 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 19 May 2025 13:17:06 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 19 May 2025 13:17:06 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 19 May 2025 13:17:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tJRRTFfElXdqT6uhz2Fi8zhrYgeaZ5SYwad8A0uu4vZUShFEYvssmeyRzV/+CraZWgt7Cob+kyqUqeaUzR9R+i3aIjDuwp8KwqH1/bUJpXXqQSz+qKvcNiaPhT1EQgdlLU/u1JELjOsUqkqyoinGVV1qaJWuJ0rDZFL3PlLyfypKpgXXINK1iK+c9w5YFM6ZGXpXforvI8iZ0beAHTrKQN2uwLhsgKttejZi+gFdjkLN+t4L5fIxx0q0PRGFlZVvt4o15lgUrXorgT6vCnj/PDZvFpxHl0M56Qt7FlP+vOjWk67FvwcbL8HUpYZ1k9y/caAdPO170LvYRbWj+/KLhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=veZNv6Yjr1tF1V8hu6wxGO2qbLRHlo7Od6vo/TNPa0w=;
 b=MUZNtS17eAOSiCX7cULuN+vyrU82QWYYaNgNAEEANKPcUkEnriRMvaWhy+khD3W45OdcsKIBrRNGeI5I3dCoTA+yRd1G4MPxfrmb1SuIqbC6Nuq+Ytf7W+Ys0NvkKZ99gkXLdl1MUgle6CPLL0JNGTNfpXjEJVSCEUICp9zQj+qXNwyu1U3Dg1Q2ZG7YDEbka8Vc/vhVVnjDU9ZrAfJKY3km8l3AtLknDQC31IJKOMl0rnBA8aJtXRJCylfEl+jgSKU/tLVw/INeSUGO6DUTBO4ppxIjnkmTQ28R52FG9dwbc6/GqO622rOhsNK0y4W/vUFCLxQK5dUe668O+PDi+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MN2PR11MB4646.namprd11.prod.outlook.com (2603:10b6:208:264::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Mon, 19 May
 2025 20:17:04 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8722.031; Mon, 19 May 2025
 20:17:04 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen,
 Dave" <dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>, "Li,
 Zhiquan1" <zhiquan1.li@intel.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "tabba@google.com" <tabba@google.com>, "Du, Fan"
	<fan.du@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"Weiny, Ira" <ira.weiny@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "ackerleytng@google.com" <ackerleytng@google.com>, "Peng,
 Chao P" <chao.p.peng@intel.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 12/21] KVM: TDX: Determine max mapping level according
 to vCPU's ACCEPT level
Thread-Topic: [RFC PATCH 12/21] KVM: TDX: Determine max mapping level
 according to vCPU's ACCEPT level
Thread-Index: AQHbtMZGizk+eJuph02+8m+gmHBwDrPRMAQAgAO+hQCAAQRFgIADtToAgADkYQA=
Date: Mon, 19 May 2025 20:17:04 +0000
Message-ID: <ad2c04d5d377257e8398775326a268e2aaaf807d.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030713.403-1-yan.y.zhao@intel.com>
	 <7307f6308d6e506bad00749307400fc6e65bc6e4.camel@intel.com>
	 <aCbbkLM/AITIgzXs@yzhao56-desk.sh.intel.com>
	 <f94e752bfedb9334ffc663956a89399f36992ed8.camel@intel.com>
	 <aCrSKudi5mUVNcSv@yzhao56-desk.sh.intel.com>
In-Reply-To: <aCrSKudi5mUVNcSv@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MN2PR11MB4646:EE_
x-ms-office365-filtering-correlation-id: ae5ec4c1-68b9-47b9-1354-08dd97121f15
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NUpWRHl1bXZpUjdwNXA1dGpjUVlsMlFCQ29yVUR0dWRRZWtIem9ISWMyZ3Fs?=
 =?utf-8?B?VEFSN01TeUlSbjJnMC9vUVRWdEMvQ2QrNkdVbnNYVExwRUNqSU1ZSUdyWWdr?=
 =?utf-8?B?LzNQQ3dnWG9oUkdQVTV0K0hqQWptV3RoRFd0cmlrL1VmelFXYmN4blNxU3Vr?=
 =?utf-8?B?R3RYUTZFSjZQaGRDeUdUVFgrckJBVm5NcWdrcWVkZmNrTG04SkMra1FrQUtB?=
 =?utf-8?B?b01obWpLcVRseXJjeVBOdXNoR1ZuRFVaZk1YbzhkekFLQmwzN1A0QVc3OWlP?=
 =?utf-8?B?TDMxQXpHTjI5ZnFPUlk5Q0NCSDFTZndUWkZtOXVTSXIrYS9COGlGMzVGdEhI?=
 =?utf-8?B?QTRkbVF4TDVEOVI2M3NnRWR0QzZPbXRoN29Lakl2c3ZFTmFuT2VQdUk1YnBE?=
 =?utf-8?B?VGVWV3c4Z3JPaUhUSzgrbVNpMFRVL1BmbU5vaW4wWkh6T3pmR1hxd2NWdExy?=
 =?utf-8?B?UXpudDdpQi9XbUhuWkhRWE0xNVB2a2tjUHVZSis3UzlCei92M3cyUXFvMDBy?=
 =?utf-8?B?RXpFYW5CR3A1em1qREhpT3JVTTBnU3ovSmt0aldZVkxlMnFxSytTcG5Nb3lE?=
 =?utf-8?B?TkJRcWhqS1JSQWFacjhINFQ3Q25oK2ZWRmswMnNnSFBCTzVxb1JpM1VMckZX?=
 =?utf-8?B?WWpzQVEySzJTVHpBQjM4OFpySXU3MUpBVUlqSkhINXlsUE5nd0FiWjhrQm52?=
 =?utf-8?B?bHM5QmtqWVpxTEhUOUhqQTFKelcxWXBEcUdwTE1lLy8ycDUyN3NXS3QrZG0y?=
 =?utf-8?B?SjBxeEVHNU11YkxZL01JUzBvaTBZREhzRVczN20vTDNDWXcrYkx0c21Rb1ZS?=
 =?utf-8?B?cTNVMiszNStLMklidlpYZ1BpcnoyZUJGWFpTN1V2WGhVKzQ4M3Z3b0VidERM?=
 =?utf-8?B?aFl0YnhIUHRUVGdmNFNQSlpodWlsNmlOUjFjNTZhWjY5Um0vaDdiTHBCQWVS?=
 =?utf-8?B?aHQ1ZVRmK3lVOTA1cnJPZmF1UVRwdGRPZ3lpVlI5MXowNWlpQW13TXJPYmpN?=
 =?utf-8?B?S0NHOENtL1RwNXJmaExsMGZJbit1UkRpVjYzbVFpZ2VveVhqS3BhQXVhdHBG?=
 =?utf-8?B?SWZJWGdDVzZvL2VPLzZVRGJaTExzV21YUmx0UEF4M3pTQ0VQWCtVWVR4Wm1y?=
 =?utf-8?B?eXpNNFZBbVdvMlR0NmhxM3I3eUJLT2IxOGhweW1tRW1SdzNFRFlNRisvb2ZY?=
 =?utf-8?B?MEpNL1JwTWJLbGorclJ3Z2hmMDlMNUluYXR2a1hycGN6dEVPRTVPVkUyK3NJ?=
 =?utf-8?B?RExTR0Jlbjh5dG5zNTFaVnd1MDljRmtqd1VROVpGWC9LbXNWRmYweHVZalo0?=
 =?utf-8?B?K1pyeVcybnhONU9EcVBJWTBkM0xFZGFCQ09sNWh1WkZhTHlqRXdwb2l0TElG?=
 =?utf-8?B?RTR0YU1ybWVMWW5VVHljK2xyVGJmVHROckhUR21SaFJoQzBpdWNnblYrRGtF?=
 =?utf-8?B?aUF5Q1FwTW9HL0p1NjhSWkM4VjF1cEQ2SWN1amRINlYwOWYvMjFzQzVvN3BP?=
 =?utf-8?B?TnhJYlhWQWQzWSs4eTVXK2t4dlVqbEV2ZHJGajFNeUxraE9KbzFlVGovWWNi?=
 =?utf-8?B?Q3ZkYndOVlZnaHc4YkJmU3pzUWlHd2xXamZ4VkpVRmpPREhyVTY5ZWIwWjlY?=
 =?utf-8?B?YXdrRWxEYjhqRjNlcGcwSmhmQkwxYTN6RU1UT1pmajlsVXV4QXVhWkhiOXJW?=
 =?utf-8?B?bHNuVTNhRzdCaHRzd3gvRTJsN2pqL0dudU51M3B0SzdJU2E4c0hqS3JNNkUz?=
 =?utf-8?B?MDJFNlFyTjVQSlhvazFDVTA4aWxYRmhmUFM2LzhBVzRLT1J4Q0JYa2JLRGRO?=
 =?utf-8?B?QWdSUEhMdUk1RlAyT2dKaklvaHNlUGc4cXpCNkdTTkZES016blZDM0FhbWJ3?=
 =?utf-8?B?c3hsSE9aNlNCem9JYURaK1U5dnMzTEUwQ2pjbjJCWDI3L1grdlpJSkRLTDhp?=
 =?utf-8?B?ekYweDhIVWV5U2tZT2Vsa1gyODVqWDVBM1pDamcyNXc0WDlGRjZVcFdCdkhC?=
 =?utf-8?Q?b9YT09bKhuM3JmyRlW46a90ldArk10=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NjByTXNuME9JaXpIcm1acWxGUFEzWlU4OVloQ1VZTWx5elgwZUtmTWU0N1Nx?=
 =?utf-8?B?akZodk1CUXZHTmt2ZkpZcGJNMGZFek9idmw2YkNZQVpYYjI2RUI3OUViM0xE?=
 =?utf-8?B?ZUU0SVhRTjExQU9SRWZXTC9wejNETi9ZVExtaXZEQ2N0MEdsdmtOamdaRVBa?=
 =?utf-8?B?SGcrcWZpY1pUNzJzNnU5ZWp4Z1Z1VitlOTFiTWFUZkpqRHMzcENLWm5ldUEr?=
 =?utf-8?B?M3NYa2FzS0QvM1ovczY1Mm9kOWNtVnZaUHpycC9XQ0Z3MlF0Z282eGhKVVc0?=
 =?utf-8?B?NEhQVUNxcVB1OGVXdlBnaDhwYi8xTGdTMXJpNlhVdGVXcStoSUdoRW1vbGx5?=
 =?utf-8?B?ZEZtMWN3a0p5Y3N1OFp0VWcxcG9oZ09qczA1K1NUdDFnd0tkZFdSOWxud25E?=
 =?utf-8?B?RENvWFY5R3Z2Uk53UnU5cGZhY2JjRlV1ZUJ2ZmxLcmwzUmdHcDlWTDd0Sk9l?=
 =?utf-8?B?Nmh5MW96MXVMdTNvRTFucTMyV1IzN3ZhQlg3dnkxdzF4Q3BwVHc0REFoU2FL?=
 =?utf-8?B?aTNpWE5tVk5VNUt2V3RkTG5rL1dYTnJwdmlwMTNqSnkvdGV5aS9hZnd1S3ZS?=
 =?utf-8?B?QzMvUHphOW1nSzRWVnFiTmlDQkdXOWYrQWhiL2NSSmpHZGdiMnJwd3lmV1lC?=
 =?utf-8?B?Z2xoMWY4dnh4YXorUURmODBaM2JxN0xPWVRlZG1GbE5UcnZDYksxM1B3enV3?=
 =?utf-8?B?UEZZemFHYUEzeUFUcnhDSVdNTWxaTEx1elRXWXBSRG5CVEVHcldLUFJuUWk4?=
 =?utf-8?B?TjJueUdjb2M1Ri9Eek1GN29URkJVOXJYeHdaRTcyeG05TStHZWU0cnVPTE1t?=
 =?utf-8?B?WHZwNU02c3BUYnZtcU5VaHUweEwxUDlnZUlmL1NDTk1iaXIrSHI4QStWejZp?=
 =?utf-8?B?c1g5Um55dkh2a0pCZVlaZzZJUk1nUkE2YjNYaURIaW9DTkQwNUZlclZINlVm?=
 =?utf-8?B?U0RWaldrM2ZROStvRmN6ZGZWa2w3MlhYTk1oY0NmSG8rZWU1aDNLSllDbUhH?=
 =?utf-8?B?eHdKV2VGamFBUHNTSGRHb05ubXZya3dkVms0eHR4S0dwYVZrQUFlS1JTOEdv?=
 =?utf-8?B?bndZRjB6VjNDTUd6Z0JQbGx6Q1VsU0ZhM215NE9JdGMraS9qdkN2dW04VWtW?=
 =?utf-8?B?WXZoZldYZ3EyUmVHbG53Z1g1R0NMd0NqNG9PSHBIdytCVFJFRDdkT2Q0ejIx?=
 =?utf-8?B?TzlMZ2ZNbXNBU09vSTFnem5lSEdWa0k3cGdKT09pbm5uRVhUbzlyK2dta3o3?=
 =?utf-8?B?VDdJZjkvcVp3N0VQQjdLK1k1c1dTN092NE1EdXFWNjR2cis1cjhuUjZnMG93?=
 =?utf-8?B?cy8xOW4yeE0vYjB1eHM2cktpL2hWMkJacXVQMnoxUm9GYUtTSDB3NC9XaDNW?=
 =?utf-8?B?MHVNS0ZmK0djbm1tUFI0R1ltM1dpYmNVeGUzUXRJdzNqcmRxOEJmaTc1OEtz?=
 =?utf-8?B?M3FqS0tKTFY3MWt3OXZvUll3L0k1bzNESHVyQVhLSVNVV1VrWTN4V1hZM3Yw?=
 =?utf-8?B?RzNUWGVabVltSnRoM044RDc4VGFQbVBvbDJxMG1GakJyK0c3V29CYzc1Q1Er?=
 =?utf-8?B?VUQ2TWEyWGZUa2s5N1hTYllWK0xXbElTYTNxdnpQNXZ6SW43WlQvZGhiSmp3?=
 =?utf-8?B?MmtHZTY1ZDV4K3B3WlBpMkNuZmRzK0hPdlJXbnNlSHZ5MjJOeS84cmtJemVX?=
 =?utf-8?B?YzhrNUxoTGoycFdKdW84VjFQOFdubUlhR0dqMEpEUys2MEZnMXR0bVI2VzRh?=
 =?utf-8?B?TEZPUjNsMjhBOHJDUm9xQ2JqM0d4K0E0M2txcy8vd2dlS0xJWXBuTW50dHlu?=
 =?utf-8?B?VTVjay9CS3E4a1BBT2hpaTJ6eVh3U0VqUXNZc1RpOVI3N1prdlY2ZHZuOUNV?=
 =?utf-8?B?VHJ0Z1poWTVpaEliN21MNE9sVU43VmVBdTkrMjNmMzhmNWJJYjAwa3BHeFRj?=
 =?utf-8?B?c1JpaHNFUkt2b0Q4K0VUZWVDc2owdVdGRUFiL1FVR3ZMWnNSRjdqeTFzK1pq?=
 =?utf-8?B?VHNQTzBFamJKRHFMaEZyN2Y1RVNkZnFmQ2IvMWpsdFZtTGZRMmlSTzYxOTIv?=
 =?utf-8?B?Yjd3RU1pakxSSjdzc3U0WklyVlBjODNHNWlOYXNTRC8xRXUzT09ad0FIY1pl?=
 =?utf-8?B?Z0VhWWU2Mkg2YU5qWlhMaHdKenJRQmdmWndxZlM1RjQ5TG5pd2FoRzRnejJU?=
 =?utf-8?Q?0Toqa/6lKhoVrr1B5rHbKI4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <82BB7773CEEF954B932E261AF5D15D27@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae5ec4c1-68b9-47b9-1354-08dd97121f15
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2025 20:17:04.2739
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ka8LftO/63t1noJYqHih20kmdNWUogmnlRN+SBpyC1mnJBDKKN5nyz5W9MURwXNBt649BQO6ThudWS3m6JygzQL35t9d1Dd8oZdHBWdlvFw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4646
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA1LTE5IGF0IDE0OjM5ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiBJ
dCBzb3VuZHMgbGlrZSBLaXJpbGwgaXMgc3VnZ2VzdGluZyB3ZSBkbyBoYXZlIHRvIGhhdmUgZGVt
b3Rpb24gaW4gdGhlIGZhdWx0DQo+ID4gcGF0aC4gSUlSQyBpdCBhZGRzIGEgbG9jaywgYnV0IHRo
ZSBjb3N0IHRvIHNraXAgZmF1bHQgcGF0aCBkZW1vdGlvbiBzZWVtcyB0bw0KPiA+IGJlDQo+ID4g
YWRkaW5nIHVwLg0KPiBZZXMsIHRob3VnaCBLaXJpbGwgaXMgc3VnZ2VzdGluZyB0byBzdXBwb3J0
IGRlbW90aW9uIGluIHRoZSBmYXVsdCBwYXRoLCBJDQo+IHN0aWxsDQo+IHRoaW5rIHRoYXQgdXNp
bmcgdGR4X2dtZW1fcHJpdmF0ZV9tYXhfbWFwcGluZ19sZXZlbCgpIG1pZ2h0IGJlIG1vcmUgZnJp
ZW5kbHkNCj4gdG8NCj4gb3RoZXIgcG90ZW50aWFsIHNjZW5hcmlvcywgc3VjaCBhcyB3aGVuIHRo
ZSBLVk0gY29yZSBNTVUgcmVxdWVzdHMgVERYIHRvDQo+IHBlcmZvcm0NCj4gcGFnZSBwcm9tb3Rp
b24sIGFuZCBURFggZmluZHMgdGhhdCBwcm9tb3Rpb24gd291bGQgY29uc2lzdGVudGx5IGZhaWwg
b24gYSBHRk4uDQo+IA0KPiBBbm90aGVyIGltcG9ydGFudCByZWFzb24gZm9yIG5vdCBwYXNzaW5n
IGEgbWF4X2ZhdWx0X2xldmVsIGludG8gdGhlIGZhdWx0DQo+IHN0cnVjdA0KPiBpcyB0aGF0IHRo
ZSBLVk0gTU1VIG5vdyBoYXMgdGhlIGhvb2sgcHJpdmF0ZV9tYXhfbWFwcGluZ19sZXZlbCB0byBk
ZXRlcm1pbmUgYQ0KPiBwcml2YXRlIGZhdWx0J3MgbWF4aW11bSBsZXZlbCwgd2hpY2ggd2FzIGlu
dHJvZHVjZWQgYnkgY29tbWl0IGYzMmZiMzI4MjBiMQ0KPiAoIktWTTogeDg2OiBBZGQgaG9vayBm
b3IgZGV0ZXJtaW5pbmcgbWF4IE5QVCBtYXBwaW5nIGxldmVsIikuIFdlJ2QgYmV0dGVyIG5vdA0K
PiB0bw0KPiBpbnRyb2R1Y2UgYW5vdGhlciBtZWNoYW5pc20gaWYgdGhlIHNhbWUgam9iIGNhbiBi
ZSBhY2NvbXBsaXNoZWQgdmlhIHRoZQ0KPiBwcml2YXRlX21heF9tYXBwaW5nX2xldmVsIGhvb2su
DQoNCkhvdyBhYm91dCB0aGUgYWx0ZXJuYXRpdmUgZGlzY3Vzc2VkIG9uIHRoZSB0aHJlYWQgd2l0
aCBLYWk/IEkgZG9uJ3QgdGhpbmsgS2lyaWxsDQp3YXMgc3VnZ2VzdGluZyAjVkUgYmFzZWQgVERz
IG5lZWQgaHVnZSBwYWdlcywganVzdCB0aGF0IHRoZXkgbmVlZCB0byB3b3JrIHdpdGgNCjRrIGFj
Y2VwdHMuIExldCdzIGNvbnRpbnVlIHRoZSBkaXNjdXNzaW9uIG9uIHRoYXQgdGhyZWFkLCBiZWNh
dXNlIEkgdGhpbmsgdGhleQ0KYXJlIGFsbCByZWxhdGVkLiBPbmNlIHdlIGNvbmNsdWRlIHRoZXJl
IHdlIGNhbiBpcm9uIG91dCBhbnkgcmVtYWluaW5nIGlzc3VlcyBvbg0KdGhpcyBzcGVjaWZpYyBw
YXRjaC4NCg0KPiANCj4gVGhlIGNvZGUgaW4gVERYIGh1Z2UgcGFnZSB2OCBbMV1bMl0gc2ltcGx5
IGluaGVyaXRlZCB0aGUgb2xkIGltcGxlbWVudGF0aW9uDQo+IGZyb20NCj4gaXRzIHYxIFszXSwg
d2hlcmUgdGhlIHByaXZhdGVfbWF4X21hcHBpbmdfbGV2ZWwgaG9vayBoYWQgbm90IHlldCBiZWVu
DQo+IGludHJvZHVjZWQNCj4gZm9yIHByaXZhdGUgZmF1bHRzLg0KDQo=

