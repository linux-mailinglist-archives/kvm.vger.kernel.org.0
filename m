Return-Path: <kvm+bounces-50593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 021E0AE7391
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 02:02:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7C1D54A081D
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 00:02:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EA0C1E531;
	Wed, 25 Jun 2025 00:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Obekz9gP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945EF2AD25;
	Wed, 25 Jun 2025 00:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750809741; cv=fail; b=o49pACBIsTHtve1Iq0qXwROki6ZkIWzuKZn/6jNo3/8dJ25THPip7TCosvTVtiFMuxPM67ZQiM/VxUTqK59gAz9wf3geN8WP/HtvMpltoRvCpp23gx8a0RUxU/uc8Q5UweaY4KjqfXLOWZNQ4JDCXsejLD5RJZvtZ8JmMbr4Hcs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750809741; c=relaxed/simple;
	bh=tFOtde9WOwwCClBsLyfqGH6HJsmsz85wcF0Gs2tF974=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bQXYJaPMshyKUzbbGLkU9dwwXbFOUd7oHM7nCyF8d7Kj/YPGo9hko1JNKaBrgmfza+F6O7H7k+x/x3nQj8OjtR42GObf75+8zvN+jePfJQ+9Xx3CogjT9XEpVUC0Cr8vss572PhCuJuRITfWWmf3s8oUoTgFD387eI+G53Xoits=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Obekz9gP; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750809739; x=1782345739;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=tFOtde9WOwwCClBsLyfqGH6HJsmsz85wcF0Gs2tF974=;
  b=Obekz9gPXBKXd18lBfhMUdfbJeWytpIfw7dGCFPRkP7l/oNmDmWWBGRG
   22rBLXprFuOoD8bABXKBkCuUyJzlZa0bi/57n/jBo1sMnDh1LsPhv4cbx
   HbwqjhcBWWmFjAkyjdU4iFU4Ks3VJbPw+HTSPZv5SwjMTDV3NWGhhUZrw
   v+KKQfp1xDpZ9ShBkntUg1+LudabRa+YeyNTDHS690+dY/CXRav3SziJV
   CRQWkUjZJAnif/p5oJsjOJ1YqBBH2f1JtDNoQ8ihXT8M0X/SzDU1/e7Pw
   01FaR14AbQML1JnZEgmmuS1H19fe2YMeriLf7GgDXi0+pifJQFs+YH4+Q
   A==;
X-CSE-ConnectionGUID: SuVwSXMXRKClBPcLpii6Xg==
X-CSE-MsgGUID: +cbO1K87QMCOfHbwyGML2Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11474"; a="53207299"
X-IronPort-AV: E=Sophos;i="6.16,263,1744095600"; 
   d="scan'208";a="53207299"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2025 17:02:18 -0700
X-CSE-ConnectionGUID: Jds0pI5KRA6U3UBygXw8fw==
X-CSE-MsgGUID: QysgdaJxRn2yjQh5PivQjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,263,1744095600"; 
   d="scan'208";a="156634843"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2025 17:02:18 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 24 Jun 2025 17:02:18 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 24 Jun 2025 17:02:18 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.41) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 24 Jun 2025 17:02:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UE7wcvCmL9E5wISYGgsKkwHoBSc2txSQ8j6FvWG768Rh8ow2wsEZ3V/tmvFBJhuMHGRg3DdYUn4jlqQA7lebdh1H5GPhmDT6WeWdB5t2KObmmD5qDM10eu5hS7jBgVO8I+jcUahGGC8G3CQSsrzwpcEPvi+Y+FFD8r8HztuKWX3iUQmN7mj+nuTTqrGrLSXzWYG3gh6KVBvOMXxk2DgPH4P0wA57LPiJ5JX9+2xmUWfho7M0K7Hd2z579ky46cQu3SUPyYNGyCKJQSHgvzoqNng1/U+E0dZmqMWZOGAH1xXPcrL+xHUfyVwPiOL2RoSajbxv79Mp4kN29hFWMjjqKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tFOtde9WOwwCClBsLyfqGH6HJsmsz85wcF0Gs2tF974=;
 b=CK77xIzsJB+OEqcTx6zW8/Yi8IKTZ73ZTNxtN3xU07jNNwzxi2zClU7/6pnPpa8E8LFVSZNFAceIL7IukHu1Z4xveGAdRS8v2byk2hB5tTozGJhkxsxw+HdNmOoFWF/CtH/LnxGdeR8sObDK6nfh/GhHCRyFM0wm1SIjhZscarYc1NWOKyXqIoH8YvA0/WpOMxf69A0FvYkG4asajwxh3Mgu6JpgPVfr67sxCLoD4R8Twhr6EtiL0cFo5OeQUnUZMV0cus/yGe47l3cjDV4uTHEzZtTN+Xw7zT5pHKaiPRIH/SYRl36xiwytetYClcYWlcALQ+Ooj21YCI4yqv5DwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH8PR11MB7022.namprd11.prod.outlook.com (2603:10b6:510:222::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.27; Wed, 25 Jun
 2025 00:01:41 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8857.025; Wed, 25 Jun 2025
 00:01:41 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "ackerleytng@google.com" <ackerleytng@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>, "david@redhat.com"
	<david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"tabba@google.com" <tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"Du, Fan" <fan.du@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Topic: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Index: AQHb1Yuw8TDhKPA9uUiYAoJtWQa0+LPz2/CAgAozpACAB4/5gIAA7nmAgAAX8oCAAO6tAIAAjZiAgAAGKoCACG6bAIAA3+42gAGE44CAABkngIAACJUA
Date: Wed, 25 Jun 2025 00:01:41 +0000
Message-ID: <a3cace55ee878fefc50c68bb2b1fa38851a67dd8.camel@intel.com>
References: <aCVZIuBHx51o7Pbl@yzhao56-desk.sh.intel.com>
	 <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
	 <aEEEJbTzlncbRaRA@yzhao56-desk.sh.intel.com>
	 <CAGtprH_Vj=KS0BmiX=P6nUTdYeAZhNEyjrRFXVK0sG=k4gbBMg@mail.gmail.com>
	 <aE/q9VKkmaCcuwpU@yzhao56-desk.sh.intel.com>
	 <9169a530e769dea32164c8eee5edb12696646dfb.camel@intel.com>
	 <aFDHF51AjgtbG8Lz@yzhao56-desk.sh.intel.com>
	 <6afbee726c4d8d95c0d093874fb37e6ce7fd752a.camel@intel.com>
	 <aFIGFesluhuh2xAS@yzhao56-desk.sh.intel.com>
	 <0072a5c0cf289b3ba4d209c9c36f54728041e12d.camel@intel.com>
	 <aFkeBtuNBN1RrDAJ@yzhao56-desk.sh.intel.com>
	 <draft-diqzh606mcz0.fsf@ackerleytng-ctop.c.googlers.com>
	 <diqzy0tikran.fsf@ackerleytng-ctop.c.googlers.com>
	 <c69ed125c25cd3b7f7400ed3ef9206cd56ebe3c9.camel@intel.com>
	 <diqz34bolnta.fsf@ackerleytng-ctop.c.googlers.com>
In-Reply-To: <diqz34bolnta.fsf@ackerleytng-ctop.c.googlers.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH8PR11MB7022:EE_
x-ms-office365-filtering-correlation-id: 19539e9a-65c8-45cd-03c0-08ddb37b76db
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WjR2RWU2Y29UWHNZaE9kdUZNOG5ZVW0wdW5kVlhXMGUzalpkTnB1QzVmQmRk?=
 =?utf-8?B?SjZzSURLcmU3U2c2VzNzYVIvRmZCcHd2K1FiSVBTMmRjWXV6UlBkL3FjbElJ?=
 =?utf-8?B?NDFhUUdDbDQydURqWDBrUHdmMnQxVWNyaVhtMlVqYUVkNStTcFkyV283eXRj?=
 =?utf-8?B?a0E0S3lrbEp2OUtpUk5TSnV6T1JVMEFZSEVwZUo4bG1LZ3lTMVZ0NFd6VWhu?=
 =?utf-8?B?dDgxSGVpMDFrUmF2a2h2U2MwRUVFV3hmTzBJMk5TT3VYdE9PU05JUTVIQ3hB?=
 =?utf-8?B?UkF2emNucklDS2pxT0hJdXlFdWpta2taeWFzSGZwUEcwL2NlbTFXUjhIbjJV?=
 =?utf-8?B?VXBHd2NzMGxwbFBZellqZXI2Nzk1bGxEYlpvMjFEbGJNYU8rQjdIT3NKSWhX?=
 =?utf-8?B?dWNlZFRpaXZibDNDUDJVVXd1cFFhTDVva3FGenhJZDBqL2E4N1Vpc3Y1K0g1?=
 =?utf-8?B?VXJGQTNmUVFUZGVPL2ZrZjVCSldIWXh0UlhYazBwOGVDcnVCbEUxV2E2anRH?=
 =?utf-8?B?d1BsWkxkRlQrQVNKeEd0bldmU2dKSFNtRFNqM2c1Nmc5aEhmWnNIWTVOQ2NY?=
 =?utf-8?B?MFVoQU5wTDBXTHhhbkwwbVVBK0xYSnZzWkdZZVdXMnVqRGxnUVB6NkYxakZp?=
 =?utf-8?B?ckpOL3FkZ3pyMDA0blJhTjUyTXA5c21Ob09hOTVzUkJoZmtaS1V4RkkyU1Vk?=
 =?utf-8?B?U25RekJJTWlYQjAxYmpHTkJ5ZkllSGNJcllxUEszY2Rnanpoako4ZWVmQW9K?=
 =?utf-8?B?ZVNyYUk3R28wTkVKK0ZVeER0WXJZWUovK2ZoY1M0b2JwN3hibEZRZjBkRFY1?=
 =?utf-8?B?N2R6bEdtNDIzaFJsMlRGaUxJVWRwUjdqVmFjZTZBSHN6K1l6cnEycWgzSXZ6?=
 =?utf-8?B?K25GTktZUGtENGg0Ym9RM3ZKLzRqMHNxUW1SYm50MnAyenR0NGpHMXJnSFc0?=
 =?utf-8?B?ZXVocWxtdDdTR0MxNWhDQTBoTFM3YWlpVXRjc0VDOHpMa1gxYlhLVmJubnRh?=
 =?utf-8?B?TXRwQ214cmorSzdaelJPVHM3bGJFV3hsWnJjMGhsS01nRVNiM0RaU0hEZlEy?=
 =?utf-8?B?NlhRVDYwdmRXb0N0Vy9NNDJEbFl2WEZCdVZ0ajc5N2JoU3VMc0hiTFBjdTc5?=
 =?utf-8?B?SUowVExZWmtoN0kvMERrc1N0UXVaOFc2VXZiQkFNWDlyNW9rK1JlSG5kZEpK?=
 =?utf-8?B?ZVVaS2xWeGc2SXFSdTU4OGwweGt1QUtIR0x1M1NNVUE0a3c1MWhETG4xNHpS?=
 =?utf-8?B?bXk5TlhtcUxUVlhPTmNzRW4vRWpYeUVTYzhMRm1Ja3lmQlNwVlBmV0VOYnBR?=
 =?utf-8?B?RW1EekM3TTg4bU9XS2VQUmd4cVBwemxkMHU3RjhjS2VDYXR1Z1BJNDY5Qmdk?=
 =?utf-8?B?RnFEdlE0RkxjVUZiOVZFRzdEbmZ2NEk0dDk3MUVkSjA2MlFWZXFBdEFpTStv?=
 =?utf-8?B?OXE3Nis0T1JPeWdwUG5FK2hoYjZDNDBPczdLcTFZTUZsMDFsK21GMjlkWkc3?=
 =?utf-8?B?dkQ0cDRDc2VYcDNUN0JiRks5SnZBK1lhbS9kOHI1ajN5cUlVZlZiaHloLzJN?=
 =?utf-8?B?STNWc2FVODhMdkdUNVdQeEh1VmQzeTgrSjcyTzA5TE1oWGp3cTU5QjB1VUhM?=
 =?utf-8?B?ekVWZWdpVFF6UjZiUUoxaWUzMHo0dVJzTTFVWElFZ3dBaG1qdG11V2EyWml4?=
 =?utf-8?B?TCtyMFdaL1NvbGh2dUJ3Zlp0YnN4ZXdWNW9KZDJjVC9Ja1VGdmprSVRjc2JL?=
 =?utf-8?B?WWpBRmxPdnFlNXJVcW5sNFMxMldrUXJFNG11RU9xc2RxMzBla3kxWW1QUXNk?=
 =?utf-8?B?a3FWRUROeGVEa3Jab2tjY1FQUERTVm9KWi9sRUZ1YmxJZmpJNTRiTXQya2Z3?=
 =?utf-8?B?aG1ibzJFSkRFdHJ3VmNMU0VnQU51V2ZTOWtZcUZGR1JhVm1jd3RNR2hPQ3FW?=
 =?utf-8?B?WGZ6b0NKdVlDbnBIb2JBZnNLcytxY3BiYjNucWJ3UCtwZjE5VjJlODEvenNK?=
 =?utf-8?Q?LvnYViVK0I565cS6HMMIHQLQpSKF4Y=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UVZ2dUFDTXppV3U0cVBGT1NCSWhiSmNlTDFOeDBsN1hCVHdpa0VwRnhQVlph?=
 =?utf-8?B?bUlETkxRL2U2ajNYV0laSXJ4Q1hGcTZIbWdjeGlveTlDeGhTcVVEaDBZMkNy?=
 =?utf-8?B?ZEUxK3dyWDNlM0thZEJpWG41TDdXb2U5RGMxZ045VUEyckhmZ3JjWWJFTllO?=
 =?utf-8?B?VkpZWTFxWHVjUEgzRHVCRmhWVHl6aUJ2UlFFdmY1cUZXMHZHREZTT2ZHcFQx?=
 =?utf-8?B?UHpHRlQzTzdIbHdvY1ZJVit0aEc3cXI4enJYTGxITDhJM0ZCTWYxekhqZWJV?=
 =?utf-8?B?Yk9ITWpSRkowZzduTnpNcFB6Z01LTDZ1OUl5d2duMVBBaXlGc3pQbFVuUG40?=
 =?utf-8?B?NDd3aDh4NlZkVUs3bTRLeHFwb3UvemRoSlhsek9PNlhYZi9tOGcra2lxSlZB?=
 =?utf-8?B?NGIyZmVRbm9hUCtGQWZnNFVTNExGVitPUHNrVHd5djVhUWVRUnVaaUhTRHkw?=
 =?utf-8?B?cEx5cVFCSHVCTU1WRUxvZTVaeTl6M1dxaHpvWnBxVzJFVS8rRUtvYllmY2tS?=
 =?utf-8?B?TWZjMUVLZHhIZ0YzdG4zM0E3TG5oanlaV3lFRDhOWjllK1VubzJwTngzOVc5?=
 =?utf-8?B?VkZ2QWptVi84NzBDVnVXSTZSby9SV2Z4Y2ZFZ3c0YUR2SFAvcWkyamdlY01a?=
 =?utf-8?B?eU1xcGlpTjNvTzVTOGZYV1BmcHdKRzlhUytzaE1ZSlBxenp5V256cnNDSmJ5?=
 =?utf-8?B?dkIrTjRsdGxnb2NtSnNRcVE1ZmhRZzh1elk2K3hwMWNrbmQ1TlMxYTBsM2lT?=
 =?utf-8?B?NmNmSmNadmgxTS9jOXNBcWx2T0paWGJVMkFuZ2M0NXcwZUxtWDY1emYvMldH?=
 =?utf-8?B?NkIwQTBML0d3MndEblZkektJSEt3MlFqUkw2M2NlaG5mUmlwWG5sTGJKRGd2?=
 =?utf-8?B?OWRCcmJ6aGRsOC94ZTlBOVM0OGwzbzBiOFdzYndSang0azA3QmZZZ25uLzBz?=
 =?utf-8?B?Z2Z5bitVTEtLWlVwTFNZVnArcTl5am1BbHE1RkRZSXgrbFBnTnhQbU1uYlRP?=
 =?utf-8?B?d3A5Z0tiSlZHYXpOd1pFOFlTZys0eFVRSzJNNTdENlpVTFd6OGhSc3JLWHUx?=
 =?utf-8?B?OVFUMlRRemJCbFBTNi9VY2FKNVllNGYxeXlRSWFKVkYycktNeEtHMWo5Zmt1?=
 =?utf-8?B?MkNZMlllcHZhTzlBMzE3OWxzWUY2VXBkZU1VU0FyOEhBL2tGU3VRREMwM3F6?=
 =?utf-8?B?bGhOb0ZVTmJnN2wwVG5FTGxyditJY3kzM3h2dEFybnJxRG10UWdKQUJscE9w?=
 =?utf-8?B?Q2gvaytuRDN1dDJFRTdVZjVsbnkwcEpXbDcrR2lYVHBJSEFWY0pPQ1BlSXpk?=
 =?utf-8?B?a1JkR1R5N3dOOFFyM0VFc0V6OG5DU0dQQ3hWQlk5MjhkcnMyWmxMNmU5SThO?=
 =?utf-8?B?akxtdTE0VHpxSDRmalhvVDV0VUNVZzFnMGJ4YVFUQ3dWTXJrUWtQOG5wU0Nj?=
 =?utf-8?B?Y3FkMTVyQ1Vodm1CWGF4SjJjRFAwYm9tNXdDVTRxRnZSalkvcWVZaTFhR0Iz?=
 =?utf-8?B?UXlyMUtMM3JCZkZzclgxVU1LdGdIdGNTU21qcXg1SnFRVGw0VGVieFJaYitT?=
 =?utf-8?B?VEcreEhGVlJrRzdZQkp5VXhZTGMveUM5d3BZRUYrZFpJWmFaTVIxZlhYQ3Ex?=
 =?utf-8?B?Q3dMNDJ0YXNHV3lDK1ZTOEpscVJtZkRUaW1jUVhLTDJMbXNBTnhZdHpCZURy?=
 =?utf-8?B?VDVGSGRsczBLazZ2UXZJOFZ3Sy9LaXVLVEhtVHp0dGNnb0cxWXo2ak5pYmpi?=
 =?utf-8?B?eEpkci9EN0dCT1pLNk91SUVrUVJKSllKU0xHL0dNOUZyeWNEV2RsZ3gxZS9C?=
 =?utf-8?B?ZzdnUEZEZCtVbXNLZkVBRzZtRmJKRCtHQ3E2TmNDS0dJVWh4T2VWS1ZnbC9n?=
 =?utf-8?B?MXFFd3hLWmJzM2FtSXhsUkp0dFpIZEZrUFVQcXpQQWJ5bGJ5ek90THBIVTMy?=
 =?utf-8?B?ejhORjJJdElqbzg5QnRSdkxhUFc0WUFJRWg0NnZrWTZHakVDK2RVaHVsZGJQ?=
 =?utf-8?B?QU8xZVJFZFRJOEUvYXFoRVhCSGJ0NmdyWE0vbmlwck1naW9tTzFPQ2NZbGpB?=
 =?utf-8?B?WmVJVDBCZ1NkTTluckpWclNTbFFsZUpqSHBSWll6WmYwenN3WEZ5U0hVTjVX?=
 =?utf-8?B?MVdzTEhyQ2E2M0VtNTJoRmgxYXRaNG5JQzA0YVFuazYwTVJCYndUdnFqN2xZ?=
 =?utf-8?Q?gRZZvIOfs6D/QRvzcmFuYcI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5A50D8B6FAAA764887D0FD12BB951F09@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19539e9a-65c8-45cd-03c0-08ddb37b76db
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2025 00:01:41.2507
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 62g+YoDD8PA7VmU8+6r7027Vb/TAbx+cmQHQFMpoI1KBkHEuHwaKkrZSiYk2i8xDR3Jn1e+Zc5HKZJ8Zz4w7dAXWmURSlGXXLKSifdm7HQI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7022
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA2LTI0IGF0IDE2OjMwIC0wNzAwLCBBY2tlcmxleSBUbmcgd3JvdGU6DQo+
IEkgc2VlLCBsZXQncyBjYWxsIGRlYnVnIGNoZWNraW5nIFRvcGljIDMgdGhlbiwgdG8gc2VwYXJh
dGUgaXQgZnJvbSBUb3BpYw0KPiAxLCB3aGljaCBpcyBURFggaW5kaWNhdGluZyB0aGF0IGl0IGlz
IHVzaW5nIGEgcGFnZSBmb3IgcHJvZHVjdGlvbg0KPiBrZXJuZWxzLg0KPiANCj4gVG9waWMgMzog
SG93IHNob3VsZCBURFggaW5kaWNhdGUgdXNlIG9mIGEgcGFnZSBmb3IgZGVidWdnaW5nPw0KPiAN
Cj4gSSdtIG9rYXkgaWYgZm9yIGRlYnVnZ2luZywgVERYIHVzZXMgYW55dGhpbmcgb3RoZXIgdGhh
biByZWZjb3VudHMgZm9yDQo+IGNoZWNraW5nLCBiZWNhdXNlIHJlZmNvdW50cyB3aWxsIGludGVy
ZmVyZSB3aXRoIGNvbnZlcnNpb25zLg0KDQpPay4gSXQgY2FuIGJlIGZvbGxvdyBvbiB3b3JrIEkg
dGhpbmsuDQoNCj4gDQo+IFJpY2sncyBvdGhlciBlbWFpbCBpcyBjb3JyZWN0LiBUaGUgY29ycmVj
dCBsaW5rIHNob3VsZCBiZQ0KPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvYUZKalpGRmhy
TVdFUGpRR0B5emhhbzU2LWRlc2suc2guaW50ZWwuY29tLy4NCj4gDQo+IFtJTlRFUkZFUkUgV0lU
SCBDT05WRVJTSU9OU10NCj4gDQo+IFRvIHN1bW1hcml6ZSwgaWYgVERYIHVzZXMgcmVmY291bnRz
IHRvIGluZGljYXRlIHRoYXQgaXQgaXMgdXNpbmcgYSBwYWdlLA0KPiBvciB0byBpbmRpY2F0ZSBh
bnl0aGluZyBlbHNlLCB0aGVuIHdlIGNhbm5vdCBlYXNpbHkgc3BsaXQgYSBwYWdlIG9uDQo+IHBy
aXZhdGUgdG8gc2hhcmVkIGNvbnZlcnNpb25zLg0KPiANCj4gU3BlY2lmaWNhbGx5LCBjb25zaWRl
ciB0aGUgY2FzZSB3aGVyZSBvbmx5IHRoZSB4LXRoIHN1YnBhZ2Ugb2YgYSBodWdlDQo+IGZvbGlv
IGlzIG1hcHBlZCBpbnRvIFNlY3VyZS1FUFRzLiBXaGVuIHRoZSBndWVzdCByZXF1ZXN0cyB0byBj
b252ZXJ0DQo+IHNvbWUgc3VicGFnZSB0byBzaGFyZWQsIHRoZSBodWdlIGZvbGlvIGhhcyB0byBi
ZSBzcGxpdCBmb3INCj4gY29yZS1tbS4gQ29yZS1tbSwgd2hpY2ggd2lsbCB1c2UgdGhlIHNoYXJl
ZCBwYWdlLCBtdXN0IGhhdmUgc3BsaXQgZm9saW9zDQo+IHRvIGJlIGFibGUgdG8gYWNjdXJhdGVs
eSBhbmQgc2VwYXJhdGVseSB0cmFjayByZWZjb3VudHMgZm9yIHN1YnBhZ2VzLg0KPiANCj4gRHVy
aW5nIHNwbGl0dGluZywgZ3Vlc3RfbWVtZmQgd291bGQgc2VlIHJlZmNvdW50IG9mIDUxMiAoZm9y
IDJNIHBhZ2UNCj4gYmVpbmcgaW4gdGhlIGZpbGVtYXApICsgMSAoaWYgVERYIGluZGljYXRlcyB0
aGF0IHRoZSB4LXRoIHN1YnBhZ2UgaXMNCj4gbWFwcGVkIHVzaW5nIGEgcmVmY291bnQpLCBidXQg
d291bGQgbm90IGJlIGFibGUgdG8gdGVsbCB0aGF0IHRoZSA1MTN0aA0KPiByZWZjb3VudCBiZWxv
bmdzIHRvIHRoZSB4LXRoIHN1YnBhZ2UuIGd1ZXN0X21lbWZkIGNhbid0IHNwbGl0IHRoZSBodWdl
DQo+IGZvbGlvIHVubGVzcyBpdCBrbm93cyBob3cgdG8gZGlzdHJpYnV0ZSB0aGUgNTEzdGggcmVm
Y291bnQuDQo+IA0KPiBPbmUgbWlnaHQgc2F5IGd1ZXN0X21lbWZkIGNvdWxkIGNsZWFyIGFsbCB0
aGUgcmVmY291bnRzIHRoYXQgVERYIGlzDQo+IGhvbGRpbmcgb24gdGhlIGh1Z2UgZm9saW8gYnkg
dW5tYXBwaW5nIHRoZSBlbnRpcmUgaHVnZSBmb2xpbyBmcm9tIHRoZQ0KPiBTZWN1cmUtRVBUcywg
YnV0IHVubWFwcGluZyB0aGUgZW50aXJlIGh1Z2UgZm9saW8gZm9yIFREWCBtZWFucyB6ZXJvaW5n
DQo+IHRoZSBjb250ZW50cyBhbmQgcmVxdWlyaW5nIGd1ZXN0IHJlLWFjY2VwdGFuY2UuIEJvdGgg
b2YgdGhlc2Ugd291bGQgbWVzcw0KPiB1cCBndWVzdCBvcGVyYXRpb24uDQo+IA0KPiBIZW5jZSwg
Z3Vlc3RfbWVtZmQncyBzb2x1dGlvbiBpcyB0byByZXF1aXJlIHRoYXQgdXNlcnMgb2YgZ3Vlc3Rf
bWVtZmQNCj4gZm9yIHByaXZhdGUgbWVtb3J5IHRydXN0IGd1ZXN0X21lbWZkIHRvIG1haW50YWlu
IHRoZSBwYWdlcyBhcm91bmQgYW5kDQo+IG5vdCB0YWtlIGFueSByZWZjb3VudHMuDQo+IA0KPiBT
byBiYWNrIHRvIFRvcGljIDEsIGZvciBwcm9kdWN0aW9uIGtlcm5lbHMsIGlzIGl0IG9rYXkgdGhh
dCBURFggZG9lcyBub3QNCj4gbmVlZCB0byBpbmRpY2F0ZSB0aGF0IGl0IGlzIHVzaW5nIGEgcGFn
ZSwgYW5kIGNhbiB0cnVzdCBndWVzdF9tZW1mZCB0bw0KPiBrZWVwIHRoZSBwYWdlIGFyb3VuZCBm
b3IgdGhlIFZNPw0KDQpJIHRoaW5rIFlhbidzIGNvbmNlcm4gaXMgbm90IHRvdGFsbHkgaW52YWxp
ZC4gQnV0IEkgZG9uJ3Qgc2VlIGEgcHJvYmxlbSBpZiB3ZQ0KaGF2ZSBhIGxpbmUgb2Ygc2lnaHQg
dG8gYWRkaW5nIGRlYnVnIGNoZWNraW5nIGFzIGZvbGxvdyBvbiB3b3JrLiBUaGF0IGlzIGtpbmQg
b2YNCnRoZSBwYXRoIEkgd2FzIHRyeWluZyB0byBudWRnZS4NCg0KPiANCj4gPiA+IA0KPiA+ID4g
VG9waWMgMjogSG93IHRvIGhhbmRsZSB1bm1hcHBpbmcvc3BsaXR0aW5nIGVycm9ycyBhcmlzaW5n
IGZyb20gVERYPw0KPiA+ID4gDQo+ID4gPiBQcmV2aW91c2x5IEkgd2FzIGluIGZhdm9yIG9mIGhh
dmluZyB1bm1hcCgpIHJldHVybiBhbiBlcnJvciAoUmljaw0KPiA+ID4gc3VnZ2VzdGVkIGRvaW5n
IGEgUE9DLCBhbmQgaW4gYSBtb3JlIHJlY2VudCBlbWFpbCBSaWNrIGFza2VkIGZvciBhDQo+ID4g
PiBkaWZmc3RhdCksIGJ1dCBWaXNoYWwgYW5kIEkgdGFsa2VkIGFib3V0IHRoaXMgYW5kIG5vdyBJ
IGFncmVlIGhhdmluZw0KPiA+ID4gdW5tYXBwaW5nIHJldHVybiBhbiBlcnJvciBpcyBub3QgYSBn
b29kIGFwcHJvYWNoIGZvciB0aGVzZSByZWFzb25zLg0KPiA+IA0KPiA+IE9rLCBsZXQncyBjbG9z
ZSB0aGlzIG9wdGlvbiB0aGVuLg0KPiA+IA0KPiA+ID4gDQo+ID4gPiAxLiBVbm1hcHBpbmcgdGFr
ZXMgYSByYW5nZSwgYW5kIHdpdGhpbiB0aGUgcmFuZ2UgdGhlcmUgY291bGQgYmUgbW9yZQ0KPiA+
ID4gwqDCoCB0aGFuIG9uZSB1bm1hcHBpbmcgZXJyb3IuIEkgd2FzIHByZXZpb3VzbHkgdGhpbmtp
bmcgdGhhdCB1bm1hcCgpDQo+ID4gPiDCoMKgIGNvdWxkIHJldHVybiAwIGZvciBzdWNjZXNzIGFu
ZCB0aGUgZmFpbGVkIFBGTiBvbiBlcnJvci4gUmV0dXJuaW5nIGENCj4gPiA+IMKgwqAgc2luZ2xl
IFBGTiBvbiBlcnJvciBpcyBva2F5LWlzaCBidXQgaWYgdGhlcmUgYXJlIG1vcmUgZXJyb3JzIGl0
IGNvdWxkDQo+ID4gPiDCoMKgIGdldCBjb21wbGljYXRlZC4NCj4gPiA+IA0KPiA+ID4gwqDCoCBB
bm90aGVyIGVycm9yIHJldHVybiBvcHRpb24gY291bGQgYmUgdG8gcmV0dXJuIHRoZSBmb2xpbyB3
aGVyZSB0aGUNCj4gPiA+IMKgwqAgdW5tYXBwaW5nL3NwbGl0dGluZyBpc3N1ZSBoYXBwZW5lZCwg
YnV0IHRoYXQgd291bGQgbm90IGJlDQo+ID4gPiDCoMKgIHN1ZmZpY2llbnRseSBwcmVjaXNlLCBz
aW5jZSBhIGZvbGlvIGNvdWxkIGJlIGxhcmdlciB0aGFuIDRLIGFuZCB3ZQ0KPiA+ID4gwqDCoCB3
YW50IHRvIHRyYWNrIGVycm9ycyBhcyBwcmVjaXNlbHkgYXMgd2UgY2FuIHRvIHJlZHVjZSBtZW1v
cnkgbG9zcyBkdWUNCj4gPiA+IMKgwqAgdG8gZXJyb3JzLg0KPiA+ID4gDQo+ID4gPiAyLiBXaGF0
IEkgdGhpbmsgWWFuIGhhcyBiZWVuIHRyeWluZyB0byBzYXk6IHVubWFwKCkgcmV0dXJuaW5nIGFu
IGVycm9yDQo+ID4gPiDCoMKgIGlzIG5vbi1zdGFuZGFyZCBpbiB0aGUga2VybmVsLg0KPiA+ID4g
DQo+ID4gPiBJIHRoaW5rICgxKSBpcyB0aGUgZGVhbGJyZWFrZXIgaGVyZSBhbmQgdGhlcmUncyBu
byBuZWVkIHRvIGRvIHRoZQ0KPiA+ID4gcGx1bWJpbmcgUE9DIGFuZCBkaWZmc3RhdC4NCj4gPiA+
IA0KPiA+ID4gU28gSSB0aGluayB3ZSdyZSBhbGwgaW4gc3VwcG9ydCBvZiBpbmRpY2F0aW5nIHVu
bWFwcGluZy9zcGxpdHRpbmcgaXNzdWVzDQo+ID4gPiB3aXRob3V0IHJldHVybmluZyBhbnl0aGlu
ZyBmcm9tIHVubWFwKCksIGFuZCB0aGUgZGlzY3Vzc2VkIG9wdGlvbnMgYXJlDQo+ID4gPiANCj4g
PiA+IGEuIFJlZmNvdW50czogd29uJ3Qgd29yayAtIG1vc3RseSBkaXNjdXNzZWQgaW4gdGhpcyAo
c3ViLSl0aHJlYWQNCj4gPiA+IMKgwqAgWzNdLiBVc2luZyByZWZjb3VudHMgbWFrZXMgaXQgaW1w
b3NzaWJsZSB0byBkaXN0aW5ndWlzaCBiZXR3ZWVuDQo+ID4gPiDCoMKgIHRyYW5zaWVudCByZWZj
b3VudHMgYW5kIHJlZmNvdW50cyBkdWUgdG8gZXJyb3JzLg0KPiA+ID4gDQo+ID4gPiBiLiBQYWdl
IGZsYWdzOiB3b24ndCB3b3JrIHdpdGgvY2FuJ3QgYmVuZWZpdCBmcm9tIEhWTy4NCj4gPiANCj4g
PiBBcyBhYm92ZSwgdGhpcyB3YXMgZm9yIHRoZSBwdXJwb3NlIG9mIGNhdGNoaW5nIGJ1Z3MsIG5v
dCBmb3IgZ3Vlc3RtZW1mZCB0bw0KPiA+IGxvZ2ljYWxseSBkZXBlbmQgb24gaXQuDQo+ID4gDQo+
ID4gPiANCj4gPiA+IFN1Z2dlc3Rpb25zIHN0aWxsIGluIHRoZSBydW5uaW5nOg0KPiA+ID4gDQo+
ID4gPiBjLiBGb2xpbyBmbGFncyBhcmUgbm90IHByZWNpc2UgZW5vdWdoIHRvIGluZGljYXRlIHdo
aWNoIHBhZ2UgYWN0dWFsbHkNCj4gPiA+IMKgwqAgaGFkIGFuIGVycm9yLCBidXQgdGhpcyBjb3Vs
ZCBiZSBzdWZmaWNpZW50IGlmIHdlJ3JlIHdpbGxpbmcgdG8ganVzdA0KPiA+ID4gwqDCoCB3YXN0
ZSB0aGUgcmVzdCBvZiB0aGUgaHVnZSBwYWdlIG9uIHVubWFwcGluZyBlcnJvci4NCj4gPiANCj4g
PiBGb3IgYSBzY2VuYXJpbyBvZiBURFggbW9kdWxlIGJ1ZywgaXQgc2VlbXMgb2sgdG8gbWUuDQo+
ID4gDQo+ID4gPiANCj4gPiA+IGQuIEZvbGlvIGZsYWdzIHdpdGggZm9saW8gc3BsaXR0aW5nIG9u
IGVycm9yLiBUaGlzIG1lYW5zIHRoYXQgb24NCj4gPiA+IMKgwqAgdW5tYXBwaW5nL1NlY3VyZSBF
UFQgUFRFIHNwbGl0dGluZyBlcnJvciwgd2UgaGF2ZSB0byBzcGxpdCB0aGUNCj4gPiA+IMKgwqAg
KGxhcmdlciB0aGFuIDRLKSBmb2xpbyB0byA0SywgYW5kIHRoZW4gc2V0IGEgZmxhZyBvbiB0aGUg
c3BsaXQgZm9saW8uDQo+ID4gPiANCj4gPiA+IMKgwqAgVGhlIGlzc3VlIEkgc2VlIHdpdGggdGhp
cyBpcyB0aGF0IHNwbGl0dGluZyBwYWdlcyB3aXRoIEhWTyBhcHBsaWVkDQo+ID4gPiDCoMKgIG1l
YW5zIGRvaW5nIGFsbG9jYXRpb25zLCBhbmQgaW4gYW4gZXJyb3Igc2NlbmFyaW8gdGhlcmUgbWF5
IG5vdCBiZQ0KPiA+ID4gwqDCoCBtZW1vcnkgbGVmdCB0byBzcGxpdCB0aGUgcGFnZXMuDQo+ID4g
PiANCj4gPiA+IGUuIFNvbWUgb3RoZXIgZGF0YSBzdHJ1Y3R1cmUgaW4gZ3Vlc3RfbWVtZmQsIHNh
eSwgYSBsaW5rZWQgbGlzdCwgYW5kIGENCj4gPiA+IMKgwqAgZnVuY3Rpb24gbGlrZSBrdm1fZ21l
bV9hZGRfZXJyb3JfcGZuKHN0cnVjdCBwYWdlICpwYWdlKSB0aGF0IHdvdWxkDQo+ID4gPiDCoMKg
IGxvb2sgdXAgdGhlIGd1ZXN0X21lbWZkIGlub2RlIGZyb20gdGhlIHBhZ2UgYW5kIGFkZCB0aGUg
cGFnZSdzIHBmbiB0bw0KPiA+ID4gwqDCoCB0aGUgbGlua2VkIGxpc3QuDQo+ID4gPiANCj4gPiA+
IMKgwqAgRXZlcnl3aGVyZSBpbiBndWVzdF9tZW1mZCB0aGF0IGRvZXMgdW5tYXBwaW5nL3NwbGl0
dGluZyB3b3VsZCB0aGVuDQo+ID4gPiDCoMKgIGNoZWNrIHRoaXMgbGlua2VkIGxpc3QgdG8gc2Vl
IGlmIHRoZSB1bm1hcHBpbmcvc3BsaXR0aW5nDQo+ID4gPiDCoMKgIHN1Y2NlZWRlZC4NCj4gPiA+
IA0KPiA+ID4gwqDCoCBFdmVyeXdoZXJlIGluIGd1ZXN0X21lbWZkIHRoYXQgYWxsb2NhdGVzIHBh
Z2VzIHdpbGwgYWxzbyBjaGVjayB0aGlzDQo+ID4gPiDCoMKgIGxpbmtlZCBsaXN0IHRvIG1ha2Ug
c3VyZSB0aGUgcGFnZXMgYXJlIGZ1bmN0aW9uYWwuDQo+ID4gPiANCj4gPiA+IMKgwqAgV2hlbiBn
dWVzdF9tZW1mZCB0cnVuY2F0ZXMsIGlmIHRoZSBwYWdlIGJlaW5nIHRydW5jYXRlZCBpcyBvbiB0
aGUNCj4gPiA+IMKgwqAgbGlzdCwgcmV0YWluIHRoZSByZWZjb3VudCBvbiB0aGUgcGFnZSBhbmQg
bGVhayB0aGF0IHBhZ2UuDQo+ID4gDQo+ID4gSSB0aGluayB0aGlzIGlzIGEgZmluZSBvcHRpb24u
DQo+ID4gDQo+ID4gPiANCj4gPiA+IGYuIENvbWJpbmF0aW9uIG9mIGMgYW5kIGUsIHNvbWV0aGlu
ZyBzaW1pbGFyIHRvIEh1Z2VUTEIncw0KPiA+ID4gwqDCoCBmb2xpb19zZXRfaHVnZXRsYl9od3Bv
aXNvbigpLCB3aGljaCBzZXRzIGEgZmxhZyBBTkQgYWRkcyB0aGUgcGFnZXMgaW4NCj4gPiA+IMKg
wqAgdHJvdWJsZSB0byBhIGxpbmtlZCBsaXN0IG9uIHRoZSBmb2xpby4NCj4gPiA+IA0KPiA+ID4g
Zy4gTGlrZSBmLCBidXQgYmFzaWNhbGx5IHRyZWF0IGFuIHVubWFwcGluZyBlcnJvciBhcyBoYXJk
d2FyZSBwb2lzb25pbmcuDQo+ID4gPiANCj4gPiA+IEknbSBraW5kIG9mIGluY2xpbmVkIHRvd2Fy
ZHMgZywgdG8ganVzdCB0cmVhdCB1bm1hcHBpbmcgZXJyb3JzIGFzDQo+ID4gPiBIV1BPSVNPTiBh
bmQgYnV5aW5nIGludG8gYWxsIHRoZSBIV1BPSVNPTiBoYW5kbGluZyByZXF1aXJlbWVudHMuIFdo
YXQgZG8NCj4gPiA+IHlhbGwgdGhpbms/IENhbiBhIFREWCB1bm1hcHBpbmcgZXJyb3IgYmUgY29u
c2lkZXJlZCBhcyBtZW1vcnkgcG9pc29uaW5nPw0KPiA+IA0KPiA+IFdoYXQgZG9lcyBIV1BPSVNP
TiBicmluZyBvdmVyIHJlZmNvdW50aW5nIHRoZSBwYWdlL2ZvbGlvIHNvIHRoYXQgaXQgbmV2ZXIN
Cj4gPiByZXR1cm5zIHRvIHRoZSBwYWdlIGFsbG9jYXRvcj8NCj4gDQo+IEZvciBUb3BpYyAyICho
YW5kbGluZyBURFggdW5tYXBwaW5nIGVycm9ycyksIEhXUE9JU09OIGlzIGJldHRlciB0aGFuDQo+
IHJlZmNvdW50aW5nIGJlY2F1c2UgcmVmY291bnRpbmcgaW50ZXJmZXJlcyB3aXRoIGNvbnZlcnNp
b25zIChzZWUNCj4gW0lOVEVSRkVSRSBXSVRIIENPTlZFUlNJT05TXSBhYm92ZSkuDQoNCkkgZG9u
J3Qga25vdyBpZiBpdCBxdWl0ZSBmaXRzLiBJIHRoaW5rIGl0IHdvdWxkIGJlIGJldHRlciB0byBu
b3QgcG9sbHV0ZSB0aGUNCmNvbmNlcHQgaWYgcG9zc2libGUuDQoNCj4gDQo+ID4gV2UgYXJlIGJ1
Z2dpbmcgdGhlIFREIGluIHRoZXNlIGNhc2VzLg0KPiANCj4gQnVnZ2luZyB0aGUgVEQgZG9lcyBu
b3QgaGVscCB0byBwcmV2ZW50IGZ1dHVyZSBjb252ZXJzaW9ucyBmcm9tIGJlaW5nDQo+IGludGVy
ZmVyZWQgd2l0aC4NCj4gDQo+IDEuIENvbnZlcnNpb25zIGludm9sdmVzIHVubWFwcGluZywgc28g
d2UgY291bGQgYWN0dWFsbHkgYmUgaW4gYQ0KPiDCoMKgIGNvbnZlcnNpb24sIHRoZSB1bm1hcHBp
bmcgaXMgcGVyZm9ybWVkIGFuZCBmYWlscywgYW5kIHRoZW4gd2UgdHJ5IHRvDQo+IMKgwqAgc3Bs
aXQgYW5kIGVudGVyIGFuIGluZmluaXRlIGxvb3Agc2luY2UgcHJpdmF0ZSB0byBzaGFyZWQgY29u
dmVyc2lvbnMNCj4gwqDCoCBhc3N1bWVzIGd1ZXN0X21lbWZkIGhvbGRzIHRoZSBvbmx5IHJlZmNv
dW50cyBvbiBndWVzdF9tZW1mZCBtZW1vcnkuDQo+IA0KPiAyLiBUaGUgY29udmVyc2lvbiBpb2N0
bCBpcyBhIGd1ZXN0X21lbWZkIGlvY3RsLCBub3QgYSBWTSBpb2N0bCwgYW5kIHNvDQo+IMKgwqAg
dGhlcmUgaXMgbm8gY2hlY2sgdGhhdCB0aGUgVk0gaXMgbm90IGRlYWQuIFRoZXJlIHNob3VsZG4n
dCBiZSBhbnkNCj4gwqDCoCBjaGVjayBvbiB0aGUgVk0sIGJlY2F1c2Ugc2hhcmVhYmlsaXR5IGlz
IGEgcHJvcGVydHkgb2YgdGhlIG1lbW9yeSBhbmQNCj4gwqDCoCBzaG91bGQgYmUgY2hhbmdlYWJs
ZSBpbmRlcGVuZGVudCBvZiB0aGUgYXNzb2NpYXRlZCBWTS4NCg0KSG1tLCB0aGV5IGFyZSBib3Ro
IGFib3V0IHVubGlua2luZyBndWVzdG1lbWZkIGZyb20gYSBWTSBsaWZlY3ljbGUgdGhlbi4gSXMg
dGhhdA0KYSBiZXR0ZXIgd2F5IHRvIHB1dCBpdD8NCg0KPiANCj4gPiBPaGhoLi4uIElzDQo+ID4g
dGhpcyBhYm91dCB0aGUgY29kZSB0byBhbGxvdyBnbWVtIGZkcyB0byBiZSBoYW5kZWQgdG8gbmV3
IFZNcz8NCj4gDQo+IE5vcGUsIGl0J3Mgbm90IHJlbGF0ZWQgdG8gbGlua2luZy4gVGhlIHByb3Bv
c2VkIEtWTV9MSU5LX0dVRVNUX01FTUZEDQo+IGlvY3RsIFs0XSBhbHNvIGRvZXNuJ3QgY2hlY2sg
aWYgdGhlIHNvdXJjZSBWTSBpcyBkZWFkLiBUaGVyZSBzaG91bGRuJ3QNCj4gYmUgYW55IGNoZWNr
IG9uIHRoZSBzb3VyY2UgVk0sIHNpbmNlIHRoZSBtZW1vcnkgaXMgZnJvbSBndWVzdF9tZW1mZCBh
bmQNCj4gc2hvdWxkIGJlIGluZGVwZW5kZW50bHkgdHJhbnNmZXJhYmxlIHRvIGEgbmV3IFZNLg0K
DQpJZiBhIHBhZ2UgaXMgbWFwcGVkIGluIHRoZSBvbGQgVEQsIGFuZCBhIG5ldyBURCBpcyBzdGFy
dGVkLCByZS1tYXBwaW5nIHRoZSBzYW1lDQpwYWdlIHNob3VsZCBiZSBwcmV2ZW50ZWQgc29tZWhv
dywgcmlnaHQ/DQoNCkl0IHJlYWxseSBkb2VzIHNlZW0gbGlrZSBndWVzdG1lbWZkIGlzIHRoZSBy
aWdodCBwbGFjZSB0byBrZWVwIHRoZSB0aGUgInN0dWNrDQpwYWdlIiBzdGF0ZS4gSWYgZ3Vlc3Rt
ZW1mZCBpcyBub3QgdGllZCB0byBhIFZNIGFuZCBjYW4gYmUgcmUtdXNlZCwgaXQgc2hvdWxkIGJl
DQp0aGUgb25lIHRvIGRlY2lkZSB3aGV0aGVyIHRoZXkgY2FuIGJlIG1hcHBlZCBhZ2Fpbi4gUmVm
Y291bnRpbmcgb24gZXJyb3IgaXMNCmFib3V0IHByZXZlbnRpbmcgcmV0dXJuIHRvIHRoZSBwYWdl
IGFsbG9jYXRvciBidXQgdGhhdCBpcyBub3QgdGhlIG9ubHkgcHJvYmxlbS4NCg0KSSBkbyB0aGlu
ayB0aGF0IHRoZXNlIHRocmVhZHMgaGF2ZSBnb25lIG9uIGZhciB0b28gbG9uZy4gSXQncyBwcm9i
YWJseSBhYm91dA0KdGltZSB0byBtb3ZlIGZvcndhcmQgd2l0aCBzb21ldGhpbmcgZXZlbiBpZiBp
dCdzIGp1c3QgdG8gaGF2ZSBzb21ldGhpbmcgdG8NCmRpc2N1c3MgdGhhdCBkb2Vzbid0IHJlcXVp
cmUgZm9vdG5vdGluZyBzbyBtYW55IGxvcmUgbGlua3MuIFNvIGhvdyBhYm91dCB3ZSBtb3ZlDQpm
b3J3YXJkIHdpdGggb3B0aW9uIGUgYXMgYSBuZXh0IHN0ZXAuIERvZXMgdGhhdCBzb3VuZCBnb29k
IFlhbj8NCg0KQWNrZXJsZXksIHRoYW5rIHlvdSB2ZXJ5IG11Y2ggZm9yIHB1bGxpbmcgdG9nZXRo
ZXIgdGhpcyBzdW1tYXJ5Lg0K

