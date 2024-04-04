Return-Path: <kvm+bounces-13616-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 65E0789909D
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 23:51:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1BA74281D75
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 21:51:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFD7313C3D9;
	Thu,  4 Apr 2024 21:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N8SNpk1s"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605F113BC09;
	Thu,  4 Apr 2024 21:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712267498; cv=fail; b=iH2mwlfSA8YZl4e2PQeIZTdzrIRShROw0sSBBfq2ubpcuh2eDOm7nJ8eF317nxHNKvg6I6BxNjSDqw5bcPspSTIEj82Jx1dFAL75N0BwzdPRc75TGL+qslzm9o9NA2QFaqc36JfXnaf18TEKm1kdd7e9RvzkWyFc5LHKQqVkacg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712267498; c=relaxed/simple;
	bh=D/wXLjThxfY3jyxB1zmVniwzSxRLuHyEdveLujbOBPE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YKiTmcw1OU6GRc/y2341vXi39hv8du/XzAejytgZ5u6NKTFjEh/sjLBgyl7VZUJxXWEpSMJjd4VDykdxrXzRMhf3ZQVQP1i8yCMqAFtJUrW2w4DnpZZHQmY8VNTb7jD1GN8H/wkPwOPtdlybXMb2aQv4cX4F93qwPoi4/7SePNI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N8SNpk1s; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712267496; x=1743803496;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=D/wXLjThxfY3jyxB1zmVniwzSxRLuHyEdveLujbOBPE=;
  b=N8SNpk1shpXG/boFimPPmaHezoIbCMriAocpxlYsSVmR7c8Q5ad9DQl0
   Rl+W6cnQJNeTwaMV2e3j2aDr8ZP97LnDb8SwP+qNo0dy6LCnU4ypJtRWL
   qiAuIDB2ctBG67STUPWxuYHxGknhDrMQhNc7yHEjE3VambqN/mmo0v52H
   JYWJyZ4J7p2hM01Bew77ic7usQU4TD1Fr13d6rntnnnAwixUVvhJ0/r6k
   +mEoB4jEEc69kVpNFHFeCzpEFvtf49urH3+pVJbB/fZK4Kgy+YtQ6F957
   WhRAD5OUemYasY0Gol/5vIsRX5W9tlbW6QlbQqA+WGhkbsIuT89DwiCHQ
   A==;
X-CSE-ConnectionGUID: O+BKNnkqTYO9oZYamqfolA==
X-CSE-MsgGUID: HruOD/8rSmKaKRbj2E0qPg==
X-IronPort-AV: E=McAfee;i="6600,9927,11034"; a="10555805"
X-IronPort-AV: E=Sophos;i="6.07,180,1708416000"; 
   d="scan'208";a="10555805"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2024 14:51:35 -0700
X-CSE-ConnectionGUID: G8SHj0QhTsGds1AbNqbhFg==
X-CSE-MsgGUID: mJAD7p+ESIClRjZDXbbiGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,180,1708416000"; 
   d="scan'208";a="49883686"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Apr 2024 14:51:36 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 4 Apr 2024 14:51:34 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 4 Apr 2024 14:51:34 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 4 Apr 2024 14:51:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iwn1NAEwqyrSaXW4Qm51wgPD1Qs74OrZthlFDbYI6C9/saBh7z0LHFTcXoTPzF4FWj1Utc+YqScGtxqqnyYQvDBp/YX62tWNZoKcQ1AdaQ0YOcdhiTWdpw4nlevTlPJqZiBwb4ft/PbYDn1cELR2T2QltIsDViCTwp9SR6ktMwQ8zvnhsz9S4lE06zexM7DOMUBfN7u8U4NdiCVRmP4bH+7Gf2LTV3mQtfGm8BO5UKOTvSujDIltzQPZitTDdzzlbsfiKrMhYrK3Q/MKu2V/xWRT07RghACZbvg7Uf6yHLEVDlAuEw6S29xN2NTUo3CaIuhqjasD0SbYDTyqxGwDxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D/wXLjThxfY3jyxB1zmVniwzSxRLuHyEdveLujbOBPE=;
 b=T83IT+fQoXvKCc3cy2W2DxOdDKn4p6+Xo3UnyeXIbX7USHRByS+d4lOeA7hQE550k8hi9WYYgeCI+uNZoHr2BIdoW6kfBKViXHnXpfrXQHr8V12Iz8CRgRyr1k+BrybeyWN64OuBkhblAhy4DFe6V/Sg3mlTBpTSivyy8Dni9fQkovWNNUVfRbTiejxI7f2idh6NWy080sdavwiEAnbudvPJ+YwP7N7MMIchYwYpd9ZdoCu+EOUPpNRb9LugvnL1gijDwHLloPRqQXx2AShAsu6GoYiIRk2SmO7WJtx7Ule9zC2Xx0scy9bZTefm/AMa9eailYkYMrssEwipmExEtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB5886.namprd11.prod.outlook.com (2603:10b6:510:135::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.25; Thu, 4 Apr
 2024 21:51:31 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7452.019; Thu, 4 Apr 2024
 21:51:31 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Chen, Bo2"
	<chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Aktas, Erdem"
	<erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v19 078/130] KVM: TDX: Implement TDX vcpu enter/exit path
Thread-Topic: [PATCH v19 078/130] KVM: TDX: Implement TDX vcpu enter/exit path
Thread-Index: AQHaaI3RGrkueXmr5EGUc0XwC3RdvrFYVSkAgACOOQA=
Date: Thu, 4 Apr 2024 21:51:30 +0000
Message-ID: <1f30ab0f7a4dc09e65613f6dc1642fb821c64037.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <dbaa6b1a6c4ebb1400be5f7099b4b9e3b54431bb.1708933498.git.isaku.yamahata@intel.com>
	 <gnu6i2mz65ie2fmaz6yvmgsod6p67m7inxypujuxq7so6mtg2k@ed7pozauccka>
In-Reply-To: <gnu6i2mz65ie2fmaz6yvmgsod6p67m7inxypujuxq7so6mtg2k@ed7pozauccka>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB5886:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VS7D0uzEldbDKUz0pR7ZdlKDI5dwTjYOHZKNo4CuGS/DCcnUjWe2L2I8butoBhTNOV1MpOAvX+FxUxfymPfwAb+x/kCbDyipWOO0Kgb8Wzbttu5B1ifRi0rnYl9noS1E9qyjsTmAQGojyVUN3JjME6q1zm4xE7KtVJFLVIXJgohl6+LMFxYMbA4hgfz0p690g0P3yTeysqfwU4eYzc9E2GKhCoPDMELHgXwAj5mRc3AvmhSVlB4/Aot5geAL1FVtT+ftrSqDpmNW2JSXRzqw7apVcQlovr6OfnNKwe/acWqYH5iDNRJshFi8DTMnKRyqUfzxy4i2XNkmcobLH0Kd10MKw+OtDRGw3xHaEtLwmADQk+dWEoAXm/ED5Sir5xBfIOLKa6anZtmFvoDBT7W05/CvGwe1hiKVMVLgo5EeBkh4bRRTTZ31y6/yCBBKtiGVl9iW2zKGU34IydKrr8VQZCa5TLWUZUi3u3vvie58ycbH7Veca6/8RVSuS+z2qOguWbtkvFM6ueJwODoJNkceJXt92V8isBcZOYfSsJMEvwawA9pNU7WxU6Ce2TKCxmli70gWpbjpuc/WdayOG5cyWTMQDZKyxfhukPLyZXZzE7dE1VZ8qG1rN4srwsxAEE1lbfKR/lSb9REWc7ou/+8g0wNNhHI/AcQ2l3b4z+Q8ad4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b3Z3cUdWQjd1K2dUUWZBMlMrcTNqZHBzMXhtMjRzS3FRSVk2WmZXNmoxVVlS?=
 =?utf-8?B?UkF5cWxnK1NtR0V1RFc1WVYwYkJ1bE5EUTVXU3QwN1pCNzJiUFkwZ3U3c2xv?=
 =?utf-8?B?aHNacnhsVFdmVitNVGtXcGV6T3JHa1k3V0tCTnVSSGtkdm1FTTd5SjI2cWFj?=
 =?utf-8?B?aTE5SjdDeEllZFpyTmplb0Y5d3pUYm5ueThHSkxzbjE3ZXBIWWpSUk1YTk44?=
 =?utf-8?B?NnVKa1lmSDk3dWhHdVU0d2ExRGRISDZlbEcwaWFuVG55bHloOHp3MFRXYlJ5?=
 =?utf-8?B?ZGVBYzJqMnpqVWFZcmo4QWkzWVpyTjNSanRmQ3lmNDRxZU1tR1JrbzU4WU03?=
 =?utf-8?B?OWYyeUJVc25IcThpMi9yWWt0MmxJVFVFdUlmSFZEUTNLNnYyY3ZiZzdHYmFH?=
 =?utf-8?B?NWxpL2VLZUEweW9zVW8rNUZkNGhEU0tDWFhJaU80Q3NFeVJhZUFWdTBldDdQ?=
 =?utf-8?B?bWhiKzIwU1U1NGtEWTN3MzB5VDE0V3JreEhnR1BLM0c1MzNsWTZGYjgzVS95?=
 =?utf-8?B?LzNFUEUvUUllUWp5L2o5TTVGSmJYSnhHNmJobFlKUExGUFpPOTVRSnBTRlpX?=
 =?utf-8?B?SUpNM3BNSDVIQkI0TFZFZHhXWUxLUEJ6QVFaUzBkVXBoVEpJd0VPMEx5MnRk?=
 =?utf-8?B?VmRGQVdNNS90dEdKeVhmb1JuclRDNmVlS0I1ODlIQURXTm5HSllLemlvSVhq?=
 =?utf-8?B?SlVINldyNjVLZ1d2SHZlYS9MYlV5Rm4zRHpsTmVadWZPdlhNTE1Ic3ROeUpR?=
 =?utf-8?B?N1pLTSt3UU8raURsU0dYWkVYUXFmOHdUVUhJTFlXMUIvWFNMK2RVUldpOHhR?=
 =?utf-8?B?WlZNSGdPSVNwRUkzMS9JYUp1R1pPeWlFWk43T1ZLMGpUSFBISXkzT0pRSmkv?=
 =?utf-8?B?bWhFZ2hGMFd0OXZpeUhCMGFlWFlYbFNUSUJwajZ0bUNFZnVKOUNiWGs3V1gz?=
 =?utf-8?B?YXdmRlptUVZGYVFOV1RkLzFNUStoaVg3c25Rb2tLbnlEb01uVkVMNU52eXNN?=
 =?utf-8?B?MythcFdPODcxN25FTzhvODhBek5EME1uZGhIWm00QktmVGlqT21qb1hRNnZk?=
 =?utf-8?B?UTA5WENLc050bndFNGtDTW8rZDlzbWkvV1g0UGc0bysyM2RRZ0NiaGN3MGRs?=
 =?utf-8?B?ZXpqK2p1WUtRSUxWRDBPSWFseHBPbjQ2Zm1iUk1KNzRLUTlDVnJqVk9HczBN?=
 =?utf-8?B?ckFyejM0Z0JQdktHQ0NyNWh2NmFhOEtoZEhQNGJIY2lQYUk1c2ViU1BPbldi?=
 =?utf-8?B?a0t4cFozUjh0THVHWTFkUjd0L0RSR20wTXFMZ2pxRk8ydlpxSU1aRS9Fc0Q4?=
 =?utf-8?B?cGtLK2xmNTI3VTc5NGVNc2dDcXg1ZnYzcVBoRGsrb3V3bVpQWnNOUmo3M1Q4?=
 =?utf-8?B?Uk1oOUJrYmUvaHloUzdEUjRwbVdNYk5yTmVkWG9mc0lWRW9TcVJXT1hxYjkv?=
 =?utf-8?B?bHp2dlFPbEpWbWdXS2lLR0RnVkRWQk1hWjN0djRrcFpNY0gyT3BXeGdWSk5n?=
 =?utf-8?B?NmRqUFRXSHNudnVnN0IyM2pIWEgwNGJWVnlIZ3hyZEErazFPbi9EczA0QUhJ?=
 =?utf-8?B?eW5QVStvVUZnZHN2Z05uZmtGWFhhVnlHbkNFdjBjVW1nZDVtYVcrQ2lvclZZ?=
 =?utf-8?B?TWwrOHUwUE5pcWIrbTdzaURFcFpUMjhlaGFaaFhSSzVJblJWWDhaR1JsME1L?=
 =?utf-8?B?ZGIxZHhsK0NYK09temhnK21sMUxpZy9zdlJXZllrWW55T2cyZ3cyS3hhaEtG?=
 =?utf-8?B?d1E5czVFYlJVYjRpekc2b29abVYyZnNObzEvNm51aENXNW5xTVk3KzVjK2g1?=
 =?utf-8?B?S05CcHBrUTc1Y1JaK3hiNWN4eFFNckUyUWJBcG82N0EyV01hK0k1TXlVdjNQ?=
 =?utf-8?B?eGw3VXlhanlpL2xtSjhTNitzWVRhT3VMTUQ3cGMwRVFRTmlUNC9COGV0cXBQ?=
 =?utf-8?B?bVBvMElQZUtlbmQrUnpnUWpMM3VXSG1xY2g1K29EKzg1N0ZiM0UzMTFTYmlq?=
 =?utf-8?B?MHlCYVZEV3VuSWd4UHQ3U095Uk03c0ZkaFBEWkt5Z0tkbUZmSzV3bXo3bStR?=
 =?utf-8?B?K2VZdGs5MHVCekpRRFRsVVBxTTRXZHk4alNGWFJsZzNLUDFlWDhuRVJ5U2pM?=
 =?utf-8?B?akxYbkJUMXpZN2h1cVpTOHJGRUd5S1VxMkU2R2JIczhlN3IyeisrUnljcDhB?=
 =?utf-8?B?cGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <788AF21F31136B478573345086301F48@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40a80332-032d-4502-33e0-08dc54f16357
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2024 21:51:31.0097
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FZ4h0mKmmyHpGqle0BcMbnjMFIcJPHRehbb1dcx+jT9mIsqSe8IMG3WcAqlcf4H0BwbNUM+lj9eLNAKQ7AyYgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5886
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA0LTA0IGF0IDE2OjIyICswMzAwLCBLaXJpbGwgQS4gU2h1dGVtb3Ygd3Jv
dGU6DQo+IE9uIE1vbiwgRmViIDI2LCAyMDI0IGF0IDEyOjI2OjIwQU0gLTA4MDAsIGlzYWt1Lnlh
bWFoYXRhQGludGVsLmNvbSB3cm90ZToNCj4gPiBAQCAtNDkxLDYgKzQ5NCw4NyBAQCB2b2lkIHRk
eF92Y3B1X3Jlc2V0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgYm9vbCBpbml0X2V2ZW50KQ0KPiA+
ICAJICovDQo+ID4gIH0NCj4gPiAgDQo+ID4gK3N0YXRpYyBub2luc3RyIHZvaWQgdGR4X3ZjcHVf
ZW50ZXJfZXhpdChzdHJ1Y3QgdmNwdV90ZHggKnRkeCkNCj4gPiArew0KPiANCj4gLi4uDQo+IA0K
PiA+ICsJdGR4LT5leGl0X3JlYXNvbi5mdWxsID0gX19zZWFtY2FsbF9zYXZlZF9yZXQoVERIX1ZQ
X0VOVEVSLCAmYXJncyk7DQo+IA0KPiBDYWxsIHRvIF9fc2VhbWNhbGxfc2F2ZWRfcmV0KCkgbGVh
dmVzIG5vaW5zdHIgc2VjdGlvbi4NCj4gDQo+IF9fc2VhbWNhbGxfc2F2ZWRfcmV0KCkgaGFzIHRv
IGJlIG1vdmVkOg0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L3ZpcnQvdm14L3RkeC9zZWFt
Y2FsbC5TIGIvYXJjaC94ODYvdmlydC92bXgvdGR4L3NlYW1jYWxsLlMNCj4gaW5kZXggZTMyY2Y4
MmVkNDdlLi42YjQzNGFiMTJkYjYgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L3ZpcnQvdm14L3Rk
eC9zZWFtY2FsbC5TDQo+ICsrKyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC9zZWFtY2FsbC5TDQo+
IEBAIC00NCw2ICs0NCw4IEBAIFNZTV9GVU5DX1NUQVJUKF9fc2VhbWNhbGxfcmV0KQ0KPiAgU1lN
X0ZVTkNfRU5EKF9fc2VhbWNhbGxfcmV0KQ0KPiAgRVhQT1JUX1NZTUJPTF9HUEwoX19zZWFtY2Fs
bF9yZXQpOw0KPiAgDQo+ICsuc2VjdGlvbiAubm9pbnN0ci50ZXh0LCAiYXgiDQo+ICsNCj4gIC8q
DQo+ICAgKiBfX3NlYW1jYWxsX3NhdmVkX3JldCgpIC0gSG9zdC1zaWRlIGludGVyZmFjZSBmdW5j
dGlvbnMgdG8gU0VBTSBzb2Z0d2FyZQ0KPiAgICogKHRoZSBQLVNFQU1MRFIgb3IgdGhlIFREWCBt
b2R1bGUpLCB3aXRoIHNhdmluZyBvdXRwdXQgcmVnaXN0ZXJzIHRvIHRoZQ0KDQpBbHRlcm5hdGl2
ZWx5LCBJIHRoaW5rIHdlIGNhbiBleHBsaWNpdGx5IHVzZSBpbnN0cnVtZW50YXRpb25fYmVnaW4o
KS9lbmQoKQ0KYXJvdW5kIF9fc2VhbWNhbGxfc2F2ZWRfcmV0KCkgaGVyZS4NCg0KX19zZWFtY2Fs
bF9zYXZlZF9yZXQoKSBjb3VsZCBiZSB1c2VkIGluIHRoZSBmdXR1cmUgZm9yIG5ldyBTRUFNQ0FM
THMgKGUuZy4sDQpUREguTUVNLklNUE9SVCkgZm9yIFREWCBndWVzdCBsaXZlIG1pZ3JhdGlvbi4g
IEFuZCBmb3IgdGhhdCBJIGRvbid0IHRoaW5rIHRoZQ0KY2FsbGVyKHMpIGlzL2FyZSB0YWdnZWQg
d2l0aCBub2luc3RyLg0K

