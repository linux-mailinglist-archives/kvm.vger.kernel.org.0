Return-Path: <kvm+bounces-61138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 52129C0C1F9
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 08:27:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B565F4EEC93
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 07:27:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FD442DE702;
	Mon, 27 Oct 2025 07:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PfpCgdRg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F1B2D595F;
	Mon, 27 Oct 2025 07:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761550031; cv=fail; b=drNBPbX2tCM14JP3OvAJ3shZhsNl1kY1dDiGtd0JCW1b4Q7s1kFgdXz4CFfcS8cewRlF+oN2WJItiO5H05DjOwLx3FQEmNKmwa16aSot365ehIzS+Z0ASzQ69Dje6VdRf+m7w2QgxjggTcJd7xk31QH2Tgc7HYH8H84JJ1Bqhx0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761550031; c=relaxed/simple;
	bh=QxkvEPyCNaFyostp9uuaTud93y4/Cm7o8x26KyOGEDM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=N1FrTs8V8QFPEpg9rnfWjmbzgSRs7D3WzdeVP052C9LZO2L6g9bjrUXta+BLMETDm6Z7FPEoGD+QfLEvB45YLaJizLCiTQSUnv53gkWfKEPI0vSiUgDpEZdS1YFIDFj5dqWTrQVmfz6pYO6VzWoeRvb7BduMHorSDTjdUZPulPw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PfpCgdRg; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761550030; x=1793086030;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QxkvEPyCNaFyostp9uuaTud93y4/Cm7o8x26KyOGEDM=;
  b=PfpCgdRgnl2zQiom0t72LDnBcxxkouMd0wtrqtGYlKsndZghEo1mGEiQ
   YTD0XftIfXhTJgPU+zTuPEpxO32L4kkT0xh7HWGyywPtGsfjF13jpCQYP
   6qLot9nUPR0NYeqMQaPrCq+BW01ArTFLGppZSt2j6ZwNHrIALsUwrtFDo
   rZETF0t5o40DIdOgqMUWWxjJJ7NsJHxaYAVDFfAS0TvENalcm5StNFq7T
   a9Ml2TWFh6iLjDXTPqHqiLg6B9sJV24ViITX2aA167BpXoni6ZLOoQxmS
   S7qOQDyS338t7NMfU/r1sXnJsgGGKgCNNGpJMPOr7cZ9Gb56sRFnilo8f
   g==;
X-CSE-ConnectionGUID: 5hukHQPNS06RfmpNBEFbOw==
X-CSE-MsgGUID: dNdWFzhhRy+/FkOrQffVfw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="74967424"
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="74967424"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 00:27:04 -0700
X-CSE-ConnectionGUID: iuTgJbrqQVmZhD4u0VhHOg==
X-CSE-MsgGUID: rJmbf5f+Tq2BlXnApQghQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="184199149"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 00:27:04 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 27 Oct 2025 00:27:03 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 27 Oct 2025 00:27:03 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.14) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 27 Oct 2025 00:27:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WdgEm/KKsSAkhu19K7tnvr6rumW4/Q6Gon+Mb/GZqTqplrEfps1Lh+jPBF/X477a4nUG8SHtHTpeIc6wOy4Kg4bJb55kk+wMogJZV8wgrf0vwNkynAIpihbst3bAwLbIcrNKPM3Ku1NEu7XYIusByXw3FrlCkgRCVlEfz0s8nIaTYncGFUl/poF2T0joipv9wKhdLE5/mTIbyCgZYyG8nLshXzGPEsxwVgbP9GojBqhS3tdbPjbikT5e60HimJ8sPPo7+nAaLVXPVKbRTj6FdlLRQey1yIw65DIrppnFAMCsoqvlLIXlY5nLVkuJAmmyS//EZGhjHzyu1tWloMuZ9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QxkvEPyCNaFyostp9uuaTud93y4/Cm7o8x26KyOGEDM=;
 b=gLIwGfES++4hOJX0BeuSwXx3agqq+UXa1fXbwKBPXW4AN/R8rAKY9Z9Jh2JXm51iyNr5lkXSzLKSqwPaAMBLaXTZAs8CWq1JdrBj+qlwLUX/qWjDXjRim328++XrBauXaKUf6vlXekUVx2PQ4Ps14NahJBkLpcYlkfPHDKL5bhDncprslcX/lTCzDz6N1IlW7IFcqSWSw3w/WMXNS5kbXnmaO8+BEApjIjXW3atfXwZXU9zQ8d+mZxpJy1wbvTE0XFs5LNZn+BOKcUwtg11xgtixhjnl3O12x5C3hGxYhB6uk2q9PJU91H26gTOekNcthFDoLk4zHuvXV13ISe0X7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA0PR11MB7814.namprd11.prod.outlook.com (2603:10b6:208:408::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Mon, 27 Oct
 2025 07:26:56 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.9253.017; Mon, 27 Oct 2025
 07:26:56 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Winiarski, Michal" <michal.winiarski@intel.com>, Alex Williamson
	<alex.williamson@redhat.com>, "De Marchi, Lucas" <lucas.demarchi@intel.com>,
	=?utf-8?B?VGhvbWFzIEhlbGxzdHLDtm0=?= <thomas.hellstrom@linux.intel.com>,
	"Vivi, Rodrigo" <rodrigo.vivi@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Yishai Hadas <yishaih@nvidia.com>, "intel-xe@lists.freedesktop.org"
	<intel-xe@lists.freedesktop.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Brost, Matthew" <matthew.brost@intel.com>, "Wajdeczko, Michal"
	<Michal.Wajdeczko@intel.com>
CC: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "Jani
 Nikula" <jani.nikula@linux.intel.com>, Joonas Lahtinen
	<joonas.lahtinen@linux.intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, "Laguna,
 Lukasz" <lukasz.laguna@intel.com>
Subject: RE: [PATCH v2 26/26] vfio/xe: Add vendor-specific vfio_pci driver for
 Intel graphics
Thread-Topic: [PATCH v2 26/26] vfio/xe: Add vendor-specific vfio_pci driver
 for Intel graphics
Thread-Index: AQHcQtxJWeb+cS5vDUGtKqQJRFxx0LTVn/QA
Date: Mon, 27 Oct 2025 07:26:56 +0000
Message-ID: <BN9PR11MB527607EFA639D5BDCE69B2048CFCA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20251021224133.577765-1-michal.winiarski@intel.com>
 <20251021224133.577765-27-michal.winiarski@intel.com>
In-Reply-To: <20251021224133.577765-27-michal.winiarski@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA0PR11MB7814:EE_
x-ms-office365-filtering-correlation-id: 398185f2-99df-448c-5801-08de152a35a0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|921020|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?N3crNHN3bWZScWFmeEZHZTd0TXRjaFUycVhPc2EzZjd3YldFMkt3QVBKMGo2?=
 =?utf-8?B?L09uaDFzeHVFTnJkaUhOMFJiVXFIUVhQQm5BcGQzc3ZEYjh0aW9JOU90ZEZx?=
 =?utf-8?B?SUhEOFQ4YTNKUDV0Z1FCSUQzYkozS1VLcHp3SlZmS09SUDdiV0ZMRGVRS3Rp?=
 =?utf-8?B?ZXIvZXZKaGVxcHBxL1lYaTdtY2pZbzdLd3h4UEozQ1JhQ0lYbmxFUUdyMHJj?=
 =?utf-8?B?SlFYek5Zb3Rub2V3aXhsR3pZTUxHZkpYSFFCUTRBdGFpQjNleW5kU2tHWnNY?=
 =?utf-8?B?VUdBbmpIemJRTWFFNWROTGdJaXM0eFdFUDk2NFc1UVJvOFBSRlBBQTUwdkhR?=
 =?utf-8?B?ZVJhWXZ0MCtwQnJPdWVYbjNSS0hLUHJ3eDc0K0FUOGNqQnIwcjVUb2Z5ekVQ?=
 =?utf-8?B?M2V4ZHIxaFB0TGhrM1lYcXhoY1RZNUQvY1hYQzE3R050Q2ZQaVg1QjF1R2xC?=
 =?utf-8?B?M29JaFJYSXp4ODJINk9ra0tCZmpWU3kzSU9rb3VIanBDMFFZeWdYaklNZlR4?=
 =?utf-8?B?bXNnVVJHZXltcmZWZ0UzdnNMUDhwY3BVZ2VDZ3ZLNVN3VElyeDVmc2hreHdC?=
 =?utf-8?B?Ymg1eTFNZXBkVmpxZHd6bUIweFMrZXA2K2k5b3Z0dFlkNHBZam5ONDdEdFhp?=
 =?utf-8?B?cy9ZTkh3R2ozZnRuMWR3a2RVcDRpL09aS3JBcXNwdmtadVFETHh1TWgwS01M?=
 =?utf-8?B?c0ZlL3J4a0NpYmc5YVg3b2tpQllianF2Y1lka04wOEREM0VJcWV4aXFRSDY1?=
 =?utf-8?B?MWtKQkk3K1pUd1g3YkJYRFFmYmtvUFpSSnMvYzVzOVZadGNNb2R5cy9WRzVk?=
 =?utf-8?B?MFZFZUp4RGx1YlJkdGdGak5SYWtkRm5CUUVmQW5iNzUzL0UvS2h6eHZremNa?=
 =?utf-8?B?WjNIWVJXTU5OVHNZTTNuYXBNN0JHcjUyZVljR0p1SE82SzlmZlp2TCszM3pR?=
 =?utf-8?B?MTNOak9PNTloaUErQXRJc01mOEdmMmFkdmRZL1Jjb2lIVkRpMjZDSE9xV09W?=
 =?utf-8?B?bllXc005R01vMDlGaUx3L1FLYURIK1dOZnMvR1RmVGJOTXFrR2xRblp1WjJK?=
 =?utf-8?B?SFVoZ2ZLVytaMzFHYjVLbjJOOFMxNm92MnBNMWE5TW1rcFBSby8wbGl1c3l1?=
 =?utf-8?B?TmVhRFAwc1EvMjFsSjlEOHcybFpZeUpUck14cjczd0JuM09XT0g1REFJNFJ2?=
 =?utf-8?B?UC94SnhnUWtpSzRMQVk4Tk5iNnhtWkx4ZkNMSVg2cTFwdnIrLy9MdUtNQUlE?=
 =?utf-8?B?N0dEM0RWa3BhTTVnTjd4ZklTVDdFazdkVmdLZHUrbUVOWjhUZHJHRlZ3bTk4?=
 =?utf-8?B?Z2JPOGFkY3FiYUhGNXJYaGxuNEtSZks2QWMwWG01SWhoODgrR1Fpc204dHhx?=
 =?utf-8?B?Y0lEcTltTWJnMkhneDZncEZ1YXpPZGQxSHdBUDhYNDJJVmtWZ3h6Z0RYcXVG?=
 =?utf-8?B?VTVKQXZpRjZoR2JOcGJqUmNjbm5tNU9mNXMybncveEVleWxoWlJVYm1vclVL?=
 =?utf-8?B?cHY1alBlRG9DempKVWhyaENrb3VWM2lFY29ZZjcxS0NGVG5xUTJnaG4rcFg4?=
 =?utf-8?B?M3JsbWtsdkxVSEpkYTgvN0V2VmhmNkFySnlYUFE5N3Fac092Mk5wcVNtUEhp?=
 =?utf-8?B?Q0kxQ0dqajhLcXVZYWZmcG05dkVST1RkT2xFSGNLSThQME9RWXRUd3VVVm9L?=
 =?utf-8?B?aHRRdUc5dXQydzNpRGM3SjlMekVrQmhqaDdvOEZsVnMxNmh1cUVCa1dkMHhK?=
 =?utf-8?B?b091N3J4OE0yTEh6WHNSS0xNbFpUSUlMK2s0Q0Q0MDBkdFF6TzhiOFNjbjZt?=
 =?utf-8?B?V3RwNkhYNFRtd01xMlovbnZ1eWdHd2V0TjhoQzQ5Uk5nRWs3a2dJUWRtTUsw?=
 =?utf-8?B?UVJ3Ni9xb21XSit0Sll1azNJOG92UExpWDNML1VjWHROR1lHbndFSWloRjBQ?=
 =?utf-8?B?V0lmZS9MdG9iSWxTeHhjRGtPZzVtb05LZUdHZldkRXc4cytjdXJmZWNScEZr?=
 =?utf-8?B?eFlPNXFhYWoxWVpZSWNiM3dCKzVybjdBbURLbDhYUS9SQktnYjhYd2VoU2Zr?=
 =?utf-8?B?TTd0YTg1b2VYUzBjZnVnT0NrOVltM2lOSlR4UT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SXkyK3FsS1V0MWllWTVCeCtUV04xY2ZTZHV1NGZHRXNDMzd2cEJ3U2ZpczFC?=
 =?utf-8?B?OUpIdEhyUnhqNFdGZ1NJVWtKMFJmaGd6U2w1Rjc4aUVLdDVuQkh3eUZuV1po?=
 =?utf-8?B?K28wUTY1TkZvQTVteElzcTFEUWdsblZmS29OSVdEeFQrSmpBNEVkRU9rY2t1?=
 =?utf-8?B?cnQ5WGtaSWMzZ2x2ZnZwdlVybmhZT2JqUXFkUFVPM3h0UDk1ZjdBMzFyWFYv?=
 =?utf-8?B?RDdIUmUrM2tzM080Y2FLT0dPZm9wcHZIWUtrSThPMzBVN3hsVStFdnJhNXdF?=
 =?utf-8?B?WjZKSll0V3EyU1FQeS85RnFvTEFlUjR5RkJJQUxpQzd5VDdWczFXNmlRY3NJ?=
 =?utf-8?B?RTFJc1JsdXFrYjJRQzhBWHovMUQ0S3Z5dlJhU1ZBSlA5dkJGb0N6eXdiK3lw?=
 =?utf-8?B?Mk56S2xLMjdldk5vVFBVb0QxdHo5WURNWmRsMDlMdTNEOFNOYVBWOWRSZkRG?=
 =?utf-8?B?dG9ORWtPWHZCcmxYWm1rY2tqeDFSeS9MMFlNa2VDeUd5UCtMU3NGTjJ4R1dw?=
 =?utf-8?B?NFI3N0lkaFFxOE9KWk1xMnFXdnJ0bHNHbWVwZVdGOWdZSklDM0FlU21tR1ZB?=
 =?utf-8?B?QkVIakRxRHhsaVU3RHMrR0FxdUhoNUVQQTBpaTIxTkFZdFVBOTFiZCtva29l?=
 =?utf-8?B?Szh6UXFKS2xHUmxvN0hHUE1PQnI4QjZOKzIwRHRNbm1zZWpTR1p0b2orOGNZ?=
 =?utf-8?B?OW53dHRybEZ1Y3NHaW8rN0VZdFJtQ3o3aWxiNk9Eci9FbmJ1Ui8rZ3BCbFJY?=
 =?utf-8?B?ZTAyRjZxZ09iQ3VjbWN5VUtaUXRwS0lreXdHQklzQ3hpcEpWMTZpYU1lVHk1?=
 =?utf-8?B?YkswS0NMTVRPT29FSTJLNGxMR2lRdTFKa1RoN2ZuUXVKTXN0RkhUZUdGVG54?=
 =?utf-8?B?T1J4ZWc2RWl1Y1FhZEhBY3ZTWCtoTnZSTWt2VmY5bExTTjljSDZ1cG9GLzVl?=
 =?utf-8?B?bzhmU0JJa3FyeUtvSW9JU0EybGxyd2RFL3RBc3g4R0NFdjE4bzlTQXluczc0?=
 =?utf-8?B?YVArdm1uM0llOStaNlc2YVptbGRJYnYwenFBTHBCd0xtRnpIWE8xaHFEaHdS?=
 =?utf-8?B?R2x2elBHRmV5ZnJETkd4RVNxeDBEN1NRcmxnMWRDeVhLMkdkNTVyaUdaVXZv?=
 =?utf-8?B?cjNwSHpjMVdnY0c0NUVsakx3K2JWYWZWUytvbjZrY2gzV2pWaktHQ0NLTlZa?=
 =?utf-8?B?ZmZkb2VEZmswcXdLRUJCUmh6Y1dGdVpiY1JpR014Vjl5ajNBZmdkL2s3SnNv?=
 =?utf-8?B?bW1CUTIreDljRHVzbVU1OGhSbTNuRE5vWkV0QnZwL0d3WXBzeHdWS3g1MEUz?=
 =?utf-8?B?WldNemVhTDRyYUdxeEd4Ry9QaEF5UW9aVjhhWlhDT0RQcUZWNWU5a2pndzdn?=
 =?utf-8?B?OHJNRGNXd0F6Zitod05MZVViSlpWcVZwTSs0aVVLUG10V3NMbGJ5VHI5Y1g5?=
 =?utf-8?B?UnBJZDJMUmJNUUtsOEtEQWVyTFd2bWIrNldOWlVzK0RQNWNFVllBUG5telE5?=
 =?utf-8?B?K2wySllUblVHNGhxVmpueUdPU1VwMXlxUXlDVFVLN0FjR1pFSEd2UDlCZHZq?=
 =?utf-8?B?OGhGSlVJcWgxa3FlTm5EdjV6d2FZNE5rbG93bHJaZnc4UVMyUEFORG1JUmZ6?=
 =?utf-8?B?UUFOQm96emZnZjluTUsveXdHMXMyYnRHclprcWNvSlovN2tkdGZoaGJnL0Rp?=
 =?utf-8?B?dElKc1FKUUxYVDZFa3NZeEVuWDFrd3lMR2QxZnk3UVhQcCtmeUNXenYzWXZ5?=
 =?utf-8?B?SWwwcm5NTmdTd0tnZURMMWVlU0hkQjBQLzRERFF3enFzUmk4bUFxMllNT3VP?=
 =?utf-8?B?RDhlVTJHb3ZQUktiWU1JMisrS1V4T095dWUvV0NTU2RoanJYK1ZhQVYvWEJU?=
 =?utf-8?B?MVgyMjAzSWhNNTQ4MTA0NFFIZHVQbnVuVjVtT1g0V0J0NFMwYktRNU5abzFI?=
 =?utf-8?B?Qm1PYXVBVnBpNFNWTE5UWUhCY0tiUEJhWG5PZlhFTFJzbnJBSTVlTCtURDZN?=
 =?utf-8?B?b01NSU82eHhKY1d3Mnk5MEpWeWZlVjA4TW9PdEUwc0U4RjZya2RSczdJd1dt?=
 =?utf-8?B?RmRDTTdGOSsySjNpWVlGWFk1QU5TYTI1eDkzRFpQVXpXNzRueldTU25RWlZo?=
 =?utf-8?Q?+B0v+6qgpeFORjIL3D9XfV5Uw?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 398185f2-99df-448c-5801-08de152a35a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2025 07:26:56.5425
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P+nyk0XwfW+n44puU2HdzvJujESNr+Zis1fagx600yyLav5AbRKKku4rbN00yWumB16BaV19n7nU3wNXh5ILcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7814
X-OriginatorOrg: intel.com

PiBGcm9tOiBXaW5pYXJza2ksIE1pY2hhbCA8bWljaGFsLndpbmlhcnNraUBpbnRlbC5jb20+DQo+
IFNlbnQ6IFdlZG5lc2RheSwgT2N0b2JlciAyMiwgMjAyNSA2OjQyIEFNDQo+IFRvOiBBbGV4IFdp
bGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPjsNCg0KWW91IG1heSBuZWVkIHRv
IHJ1biBnZXRfbWFpbnRhaW5lci5wbCBhZ2Fpbi4gQWxleCBqdXN0IGdldHMgYSBuZXcgbWFpbA0K
YWRkcmVzcy4NCg0KDQo=

