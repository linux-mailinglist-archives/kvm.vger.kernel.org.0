Return-Path: <kvm+bounces-71245-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iD+qGpLIlWkrUwIAu9opvQ
	(envelope-from <kvm+bounces-71245-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 15:11:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EC47B156FB3
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 15:11:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B5F1030221CE
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 14:11:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9421328B60;
	Wed, 18 Feb 2026 14:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EOIgsIXQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365DB31A04F;
	Wed, 18 Feb 2026 14:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771423877; cv=fail; b=YpaaOdUgxCbGtnELNB3dlMes/cXys6AQZH8vApiCt6BT2DWwXOKF6JJxqtBw6NS7U6F8q4tgqonefEn/L189SVhHUEz6RDaE3XeJUJIXujAfa1xrFsC5yvpcuQlSzzz/NOoAGRluiNTAK+v4IWkgI2WrXPRm6tEdDFL/CeMQtZA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771423877; c=relaxed/simple;
	bh=HQBdeQeT9YuM0H9cXYO3W8V1UddSFrkHfi84+nZrhmU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KH13MTPwT1hPaKZ52LAGXuCNrAc4gWhq/3jv2qC08r5Bzh05n6pvRXkojafDodvaVqJ/dvl+z4atKu5LcuDIrkfIKc75iZ7tu6DQ5TaOckCDxEJ/CXVAPAINHEnXC+zrhTBqo/3RiqyImtjX1A4VqEGYTNSmrFmdblJnNxweEVI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EOIgsIXQ; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771423874; x=1802959874;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=HQBdeQeT9YuM0H9cXYO3W8V1UddSFrkHfi84+nZrhmU=;
  b=EOIgsIXQMQpaVCycX8zZlBf6f6LiTFPg75kkLrnVK402yMLSv1dhXws2
   47NawSizSYOVhbJKMRplRssIXnhvE1IozoOMsheyp5LK0Jtr+49d2VrMS
   wH3PuUaOjTjDs4rH39N8bjGqrsl/gdCah/G7UStcdhcE6i157H9vBaGkz
   jQgdwJ+8aAvLTIRuYVwBYl0fBM4irJKZU0VyvXYrrkQraAPGnrnc2wLIJ
   uBZxItg5FOyxfU6mn3qE9FC0CzHjJjwxukU2y4m4wDzQS8jad5j/a1dC5
   SsscufY6UQIuLvY4Afk1ONDXhe5XZ6hY4GkjPRDOewShNGCxQxeCN4Mky
   w==;
X-CSE-ConnectionGUID: 9u6WpQcpRkOx681JFW/hjw==
X-CSE-MsgGUID: 1/eLzsITQa2elIFPkkFYTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11704"; a="76335113"
X-IronPort-AV: E=Sophos;i="6.21,298,1763452800"; 
   d="scan'208";a="76335113"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2026 06:11:14 -0800
X-CSE-ConnectionGUID: 0pubv8xJRdeVvbSqXe+ZPw==
X-CSE-MsgGUID: VN/WfFFgS0i+Bor/I8Xv9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,298,1763452800"; 
   d="scan'208";a="214195210"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2026 06:11:14 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 18 Feb 2026 06:11:13 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 18 Feb 2026 06:11:13 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.38) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 18 Feb 2026 06:11:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l4eJ9uIE9Fep9VmUpq6p0BfZJuaszwlB3wHTXSNIkDA22Izs4nWi8nBbaR0W76XSz5Ntcfw9prgqu+4pXHg1/+jIA64JN0wvJJBCcJ+Q2Jvipmkc3nrBnliktWhVY9ziRds85hfRa+nUoBSY3swZH5hwX890nSrSEBpKXazawQ81Ixtsz0bULnQqAmHhtIkNZF28U8NelvTrprS7qww3G4IBAS6/tLCd7rrqRglTqbh4JilLoGhDDloBw4bob9+8sJtB9p3gbYu3NMBJr1ahoDmq8iNXCooJiJRpp8lBuMyOse9kpeUGEiJF5hEBalOkBieN/ICZfsa2whnbAQHvXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HQBdeQeT9YuM0H9cXYO3W8V1UddSFrkHfi84+nZrhmU=;
 b=zEWhFHBJQqeSgG8EtdC8lQtj76j81VO29fjB/N3DljPjyfWIeG+x4HvMxAX+9b6/JrW/+X98M+AJJxWOv0SVN2tn7YuerlTitrbyzCRbIoqFWGVBJb7Vdu7YsbUUNWTP4WW2X0vONx9Sds/2yeRhu+enHfmJFG7lFg+2QDfGZCBRkwm55I0C5AvuuXSR3YSFBwDmlLnjSsDSMv12GiRJdbLJ46KU+ud+B7Licq36tKqKqzhxV2Ln89jHglMRW9FUveAWl7j6DDAJRYJEynqMUTZlixrZnjS+H/osVG8lEz/O1U69+3sme5EgRHmzc/W02p8zyL+7naaR2d477hNqcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ2PR11MB7426.namprd11.prod.outlook.com (2603:10b6:a03:4c4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.14; Wed, 18 Feb
 2026 14:11:10 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9632.010; Wed, 18 Feb 2026
 14:11:09 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "jgross@suse.com"
	<jgross@suse.com>, "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>
CC: "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"tglx@kernel.org" <tglx@kernel.org>, "kas@kernel.org" <kas@kernel.org>,
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
Subject: Re: [PATCH v3 02/16] coco/tdx: Rename MSR access helpers
Thread-Topic: [PATCH v3 02/16] coco/tdx: Rename MSR access helpers
Thread-Index: AQHcoK+n+5dvTXVBxkiWSMTlxQA9I7WIf9aA
Date: Wed, 18 Feb 2026 14:11:09 +0000
Message-ID: <0393b99b86a08b3ce4ae5bae80f1b8ccf737a0c5.camel@intel.com>
References: <20260218082133.400602-1-jgross@suse.com>
	 <20260218082133.400602-3-jgross@suse.com>
In-Reply-To: <20260218082133.400602-3-jgross@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ2PR11MB7426:EE_
x-ms-office365-filtering-correlation-id: d80ff772-f7c8-4da8-9e42-08de6ef790c7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?ZHNEejNsWVY5WWFFYVNCdEhjU3NMdWYvYi9HTk5YUFBrSmZWRHNtV05VV1BO?=
 =?utf-8?B?Z08zdUc3UXN4YXVrWVlqd0VlTFZIVVFEV2pOSk5Sd2FtZzNFMzY3Z1pucjly?=
 =?utf-8?B?eG1JbXdadG5JTmFEUSthRWtsYVFXbS8rVEFwOHczb3Izc0JWWXFNNWVDNGhR?=
 =?utf-8?B?MmpXNkQ0YXFDcDU3d1ErcmUwVVhnd0FMZEovWEVaU2VncFphRmlHTEhQa094?=
 =?utf-8?B?VjFwaFRkQlNjQldOdDJQNkdNazFCZmJqSjl1bEdxRkNpdDNReUtNalpna2tY?=
 =?utf-8?B?L01Wa1k3OFFLM2Q3R1BZYnMwNEkrNzVGTGZTeEFGb3JkSDdsWUgrVzdxaEhO?=
 =?utf-8?B?aHFiNUpWdHY3b0VzWWowUEtrVXBocEdnRGZOQ3czbVhSQ2toM29xSzBjR2N6?=
 =?utf-8?B?dUNHN1pPa2ZuUzlmd2V1a09NY045dk9VemE3MFNmZDhhOVJBdk9lV1ZzVjli?=
 =?utf-8?B?d1BxS3FRMUlXLzFoZSt2WWM0Q2NqcGlSVVp1QVh3USttNzExNUVVeDJ1Tysy?=
 =?utf-8?B?bVhHUENkUW9pQm9NV1Z6ZWJCYlN3NE85TzB0RXJpbzdyb1dSWXdORTRNZHg5?=
 =?utf-8?B?WkM0RzlGYlJaNkNLcEt5TWloQXA0Vk9yZXNUZ1VrMmZFR1Z1RWJJMVQ0ZjRy?=
 =?utf-8?B?Ujljdytvb050MGdZR2tmYjkrUm0xQ3J0T3RCMFFqUnhKL3B5bmJGVy9WVUJO?=
 =?utf-8?B?MXhydEp6QlI4WndOb2JhcUYxZ1NXUEZWcGNnN0dRYXpMN0tUUjVJaE0rbWtS?=
 =?utf-8?B?YXRZdkdmaTYrVy96Q2lvVXFRZmo4MnlqMk4xc296QkwrZlJCNDNBeEtNVVB3?=
 =?utf-8?B?eENLUDdkL3VhZ2ZGOXFQNHZrNXJrN1RSZm1mMzBZT3VFQTdNQVRBd2ZiR3Q3?=
 =?utf-8?B?c002SjhBZitUbHI5ekVmQlRPZEViYmI4M3N6UC9HWWhhQmtGOUlrbHhqNTB4?=
 =?utf-8?B?bk4zQm83K244bjhOYmhSTjhxMTUyVFp3VmdvYXhkVzBjeWtQU3JFUnF6emFm?=
 =?utf-8?B?VGlTbnhpRS9uY2VyUGcweW9vL21iakpxTlM4bFFTdW9rQy9xSVVjQ3NFTzNQ?=
 =?utf-8?B?cTdpZUhJZmdpN1pBSzBIVzFTWHRRdjdUQmo2WXVYVms4cExuQklxTnNYZkpM?=
 =?utf-8?B?MEROZkVXM1FLNmtNQnVJaE91bWhFZHg1dTVTUVdSYTlZcDE5S0dDaWdaajgv?=
 =?utf-8?B?b3ZEeDhFTjJoNC9JL0p3cVZscVQvS1lCYVRadnN3ODE5NUU5ME11TXFncmNB?=
 =?utf-8?B?b1ZuenB4VUgyU015ckZZTWRkVVUzdHBzM2N1QUY1Y2ljYlFjc2ZlQjlzQWdB?=
 =?utf-8?B?cTB1WVdGSFRMdjlhYUlMdWZxQm9iSnBONFl2aE04b09PV3NwYi9XUnVIN0di?=
 =?utf-8?B?WDVMb2lYdUI0VGZjSmhSRFJWMnBuaXlMbkFLSUFOTUdXTkl5a0FyaXR1K2lY?=
 =?utf-8?B?YW15WVpqS0dseUhEQUIxRHcxZE9yU3ExR0FLdEZBLzMwdGZWemtCeXFDazBB?=
 =?utf-8?B?ZTIvYTV5MUd1RzF0cnJMWGcySlpOYThCdXlvMzBjSVpJaHJpY3FaTy93ek0y?=
 =?utf-8?B?TDhNU2Z0VmRwY0k2RFZ3WTZ1eW5uWkNYKzN0UG00MFVjK0FzR0RLR05XRVE4?=
 =?utf-8?B?OW1CRjRBYzZWSlBkaW9tWjRCTms5ZEFxRkNYdHhlaXdIODVTMm1aU3R6Sy8r?=
 =?utf-8?B?em51cE5oRnhoQXVQZEoyR3VpN3BpMEV3Zmxhc1B6WlJOK3VrdHBpSUNXcWJK?=
 =?utf-8?B?SlpuVEREazltWFBnTVFFM2k4RjVzR2Q1VUNXeXRza1R6UWFsZTZKeGFsUHVM?=
 =?utf-8?B?R3lYK2hITURoRWVZVTdXNm9xZnFnSXA0SGlkblVoaWt5OGpiQkpOenI5a28r?=
 =?utf-8?B?QU12dVhkVUdhOUVmdWV4dkhlRndrSUNEVy9rdm5LeERLazhHYmdyUDR3TnJG?=
 =?utf-8?B?WGI1c0o5c05BdWpJRFFDUG5OaU5Nemo0eElPWGpjdnVzWWVndmxURjJUZER4?=
 =?utf-8?B?ZGxDdlV3Y0NtVnZzM1cvYXpyU29NWXYxWnhaVkhkbG42K1NlRjBDWlFkYmhY?=
 =?utf-8?B?U3Z1b1lyZnA4by9Tc2dJZmlxUTkxcjRWb3NZK1VzZWVUaGFHMmJaaisxNTZl?=
 =?utf-8?B?NzRQT1FSY2NYdDdNeGtjd0F4c0k5OElvRUZLWlJ1UEtuY2JNVzJKKzh1a0Nq?=
 =?utf-8?Q?K8DW2qZryqMRryiJw/J696U=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d3ovNHRGeUttejdLYzYrRU4rZjdnUWhkbWtGNUtTcVk5U1U5OXlKZ2ZoU0hi?=
 =?utf-8?B?QVczaXRESGFyRWNLL2NpbmYrSTdHdFJHS3Aya3J5U0tlWFRURWFOWHgwbXFJ?=
 =?utf-8?B?aEROdkxhYXJXMlhtQzdIcmJXUFIwa291Y3Yvd09tTzJ1TjJVWXdNUXNGWXg5?=
 =?utf-8?B?c3B3Y1M3aWMxSlA2bFpTaldtc3RGclQrTDBXR1AyUmpJcTkyMDdkdHpwbTdP?=
 =?utf-8?B?c2pUOUFGUU94NDdZRnlTa1JxaEkxWEhCL0E4T0k4Vjg2L3ZqNkVLcEdzYjVF?=
 =?utf-8?B?ekduM2swQlU0WmRCd2N3aXV3Z3RiUHB5eWdzNldRUEd6eEZydlZiVFBLc2x1?=
 =?utf-8?B?eVpsZlNRYXZkTUs5ZE43T1BMaEIwVm9zbVRHY0ZiVDVHczN0a0MxQysvMzJM?=
 =?utf-8?B?Qk9nS0QvRitaZFU1Y0tvQnZ4N2M5c1RFNkJPdjdNS1F6R1RFWUc2RVZsamV6?=
 =?utf-8?B?WURad204WnQ4VnJUdGsveEZFQ1BKZmFERzdGWm5PYjBtUHRQVGFEK1dkb2xk?=
 =?utf-8?B?b0N3NGlmbXNDRks4eFJaU1orbkVhZE43em91Sk5FSFA0LzJHNFV4U3docGRP?=
 =?utf-8?B?RnZhRFg2ejdWbm1wWDB5bXBiT1htYmFkbm4vRlFaNGl1V2R6ZTdTMDFmOXpa?=
 =?utf-8?B?LytrMTZ5NHVITzk0U0k4TFZOakJnNks2ZWpBZlpQNVB0TnNIdEhBZVEzeE5p?=
 =?utf-8?B?dXgwSGJIREorTm5pQk55NC9YT1hBNWR0TE9pdm8vOERyK284MlR3eGRvNG1k?=
 =?utf-8?B?Mm1Zc0lNWmRLcWp4cDJxY0pTcnB4ZGFSUU9DK0lwM3ZSbjM5U3UrL1pYaHdp?=
 =?utf-8?B?MHNuOWorT0Rtc1hYMlBJWDRQczkxWWQrZllTQWpvc0dNU0lWSEswaXJ4U2w4?=
 =?utf-8?B?TjZacWxzVGV0Qlp0eThKSEFGQTJ0MnNtM0ZlSHpjQ0p3cXh0bS9Tcjd2OFhV?=
 =?utf-8?B?SFJTdnA1cERTL1h3WWhjMCtFYmJxRmtxYm9SR1NNVEdEaG0wQ082b042d3JV?=
 =?utf-8?B?TGdZNTJqMUU0Wk5ocnUrc3h1SWdPcjRWMHl0cFZ3bjVsRU51RUxsQll5aUVQ?=
 =?utf-8?B?RU9FbG1KUjMxclNIVmpNNjRjUE5aTHlzMGJ6SFdtMkE0WGk1aFc0R2RoOEZ2?=
 =?utf-8?B?eWRkWDMwM2NqZFRpSUhKcHY3bU81RTYyOXZxdXNIT0Z4RVNjQmQrVTdMdkFL?=
 =?utf-8?B?Nm1VK3pVN0RCeU1XS1N1L0ZSQVBKbDJqWENIR2MzZ00zcHViVUJkQ28zSElN?=
 =?utf-8?B?UnRsWG1aMFhtclE5aUNPZ3Y0bjlQU3lIRXhqUlFvUXFPZEZWUTBkMTAwd1Nm?=
 =?utf-8?B?UkZvaGdwUmp5R0NIaDdnc3JITHNXNC9Ub0g3ZUcyUWI4WHhaWG42Z2lFVDFG?=
 =?utf-8?B?RWVjc3hXNE5vNGliblFxbnNtOVZOVTJjVXR1dGdCMWZkMng5Q0R3cFpMTDNw?=
 =?utf-8?B?ZXBab1lpZkFtOVhQcEJZNHRvSmJWNndGWCtwNVliLzBQWmtSK1BORWlsd0hs?=
 =?utf-8?B?WkdWRlVHMThYZnJPVWZDUGc5YkNKV2FicmE4NTMvcjhLUVRzbzhXK0svMDBL?=
 =?utf-8?B?Sm8rRHZzNkNYckNJQ1R0WVdFRndCL29IeVdicDVhYll5MTRSUHFOcktGYnRP?=
 =?utf-8?B?WmhzMGVrVkpVNlU2TU9DS1d2d0p0cklrTVM2YlE4R2t4SlJESFBuK3pyTDFR?=
 =?utf-8?B?c1NoZkF5QU5mV2RUUzQvdWlaaksxUEx3MlRubzZwZnpwbjRZemtoRWl2bHVI?=
 =?utf-8?B?cUpNQnRxQW5QOHV3c1BscmdIR044eU1COHkrUmpzUFVXYzdTb2p0RG9BdEF4?=
 =?utf-8?B?VHJtV3dRTUxXVGl2L21kN1BOWjF3c2t2ZzBOZVFNL0ZZb3BVazc5NzJsMUlU?=
 =?utf-8?B?NEdMZkYxWVgvOEt5Zm92bXF4Snc3UWFka0FjU1JvMzVob1FCR2g1a0ZVL3VE?=
 =?utf-8?B?d2d4QVBrbDJEYlV3T0ZDNTM0c29MS1VpQjNEdDVQRlplZlJoZVhhaVJWWW9P?=
 =?utf-8?B?VElySHVPalpqb2dDWTFYV0RJMXhMR3dXZTB0TllidU5iSkJobVluNlV6anh2?=
 =?utf-8?B?THRaMnVmSGtpQlh6OUh5OCt5YTk3SDJGRTR2VDMzaHpNUXl1cFN0Q3pQN2xm?=
 =?utf-8?B?QWZmYTgwaW8xV0svU0wwdkhDZEJzamhKcDlnbUdvTzlpMWJoMmE5UEVMNXhr?=
 =?utf-8?B?emttaUY0QkF5WnRaeG53NzZpSEU3S280aUIyMDhnYUdOZFg2QUV3L3FXTWM2?=
 =?utf-8?B?NjBrcC8rc0lRaFpqcFF1QUtjSEpLL3RMUEdNQ2lsTnA4WWUyYXRNTm1XaWI4?=
 =?utf-8?B?OWd2d3A2Y1d2NzA1Wi8zQ2Q1UW81cXc3aUg0OTROYXdGZUVseit5NHlZeXZG?=
 =?utf-8?Q?PZ9+r2oHmCOA9eo4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E971370FE3802745B7245E7093A1F33A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d80ff772-f7c8-4da8-9e42-08de6ef790c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2026 14:11:09.7626
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dW69VBwqPg9n4CGOcXzfjHIQqrmD5pBsT8c2fNQ0y9w3QTMB2Yr9aPp25I5QnoHmNWjgx2/TFfJiNBaweLXgjRcTTBG1TXvbAXeHYFoOgNA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7426
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_BASE64_TEXT(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_ALL(0.00)[];
	TAGGED_FROM(0.00)[bounces-71245-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.com:email,intel.com:mid,intel.com:dkim,intel.com:email,zytor.com:email];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: EC47B156FB3
X-Rspamd-Action: no action

T24gV2VkLCAyMDI2LTAyLTE4IGF0IDA5OjIxICswMTAwLCBKdWVyZ2VuIEdyb3NzIHdyb3RlOg0K
PiBJbiBvcmRlciB0byBhdm9pZCBhIG5hbWUgY2xhc2ggd2l0aCBzb21lIGdlbmVyYWwgTVNSIGFj
Y2VzcyBoZWxwZXJzDQo+IGFmdGVyIGEgZnV0dXJlIE1TUiBpbmZyYXN0cnVjdHVyZSByZXdvcmss
IHJlbmFtZSB0aGUgVERYIHNwZWNpZmljDQo+IGhlbHBlcnMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5
OiBKdWVyZ2VuIEdyb3NzIDxqZ3Jvc3NAc3VzZS5jb20+DQo+IFJldmlld2VkLWJ5OiBLaXJ5bCBT
aHV0c2VtYXUgPGthc0BrZXJuZWwub3JnPg0KPiBSZXZpZXdlZC1ieTogSC4gUGV0ZXIgQW52aW4g
KEludGVsKSA8aHBhQHp5dG9yLmNvbT4NCj4gLS0tDQpSZXZpZXdlZC1ieTogUmljayBFZGdlY29t
YmUgPHJpY2sucC5lZGdlY29tYmVAaW50ZWwuY29tPg0K

