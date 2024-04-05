Return-Path: <kvm+bounces-13768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F279489A780
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 01:01:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 509A2B25343
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 23:01:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6860A364A4;
	Fri,  5 Apr 2024 23:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AED04dtO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBED3107A9;
	Fri,  5 Apr 2024 23:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712358093; cv=fail; b=MqH7jbFW+/AgXBAzStMB/9UH2TfVcb9ucm+1+hWniI3FvXIbs3rh+Zfd+gC8AQawJd/QU7P7tpuKqr+pm5ZfBoH3+XffMaAspJfBZZj/d0uh/a1GrGr07oNFjxrh3KQjA5ugwwTLhm6dg1c+Hj7LzqneQv3IZDgh5HHZQiQXqBk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712358093; c=relaxed/simple;
	bh=eHh0/mhDTwoC6tAlP7CLMrCQhAgPfy6Emt8Bq6Mm3b4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=n6LCuvpDrRXZXgpozsq8rFdxgQxn32FhJaYO2FKAlFVXDj3GFk8KacQRv0jf4eGvlQlOHx8Lun9P549MCtoWqmZVSpFHKcT7y9W3LWJ5ZrCt5PJPXBZgmb14lZQJvB0h0VXxT1+QnLVFO2tMan+h2i+9D0Ovprqj2Qr8FEG1CXs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AED04dtO; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712358092; x=1743894092;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=eHh0/mhDTwoC6tAlP7CLMrCQhAgPfy6Emt8Bq6Mm3b4=;
  b=AED04dtOD83+ASPijBtMHSIo8Umf7RpW+l633WkwXs8BOzav9/irXIds
   5I6EbrmSak7o23j8IqXRVLwHFU3Tpi4SftWAbyLTJY+rvBBnR1Xb8jlOl
   4qODoOIbSI2Yd3vSmwOB3szGPDQY8pF4ieXpLLekxxwPe5qlGVkDkqFsN
   K8tusvY7jlIGD05VUEJRVzzL9OaRzcdLbfQt1KAak1z0jbwKXnwkdi5UK
   impxK4N8FP/D8g9HGuoav24rdusaF7EcBXQz8BqObj1IYURt+F4VTo3CX
   fEBdJmMRLfMwUDN7t1hPmgwmEOSb++ZxnTunbUbOuMt0dtihNZ34YqSuJ
   w==;
X-CSE-ConnectionGUID: UwLUDowcTLirr1VQOqWygA==
X-CSE-MsgGUID: SOvNgpQSQ1e45OCjtcqf6w==
X-IronPort-AV: E=McAfee;i="6600,9927,11035"; a="19140877"
X-IronPort-AV: E=Sophos;i="6.07,182,1708416000"; 
   d="scan'208";a="19140877"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2024 16:01:31 -0700
X-CSE-ConnectionGUID: tc7QGVd6Q2m99eZC3FzWYw==
X-CSE-MsgGUID: j6EgvpdVTOWU+iNaYS/f9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,182,1708416000"; 
   d="scan'208";a="23932724"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Apr 2024 16:01:29 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 5 Apr 2024 16:01:29 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 5 Apr 2024 16:01:29 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 5 Apr 2024 16:01:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GgbZh7KQuvoLt4JqX5C6TXvnApBMWzYawZyTQmylrA6Bnv7SE61q3dyHa7m56mQSQTVoZRCeMuRS1uN8klBSrtYERU1cMKio/DDPBvQVwrnWc59lHu3eJqcHnaIuSARiC/03YDEYkMTCjKanus2KLN+JZpdnIsFKtnnoAUXqZhoQuOnou7krxEY7hv/SCUK6eIL5nO7jBQ4ctqebyZrjcRCrcA2spo3zdqHK7hxh7GsLPwdJ7S2gCMaGqbft1JYmgXqQuPpFq7kyx2hO04B6h80SqYuON7BhRlYFaLWbGyqwXlpVJPK/NT952gzzSJm1Z7pLFUYQHkftCE88gEN9eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eHh0/mhDTwoC6tAlP7CLMrCQhAgPfy6Emt8Bq6Mm3b4=;
 b=VliytT8DuKiPN2sKj7K573FRmOlCdtlSxglmg6EBQHJkRjEfCCVJdBZ12y39Ob4LriDBoBIdPWCpeLCEOmBhgMGXvhE9QKjWpGjNZtHHxsmNwjuAiVIRe+ic8+eTPWQGta4ZpI7Z3PbcAJZr44FjixRKDG1koZu4St07BQd9D/FFtMpKS0vvLEyKT/k+hDQJSODLgtfdxHyXjS6RDK3JWj2xGvUKO1zTP3X1roAuvdpAF3whsgarOwWOzSqetabBpNm755V98XoQsBU85THxnASLzOmOLn3JqOKfLw4C+AOFIoXdmELrv7n30Ax7xuBOKJn0Dbr8gFf3lYlAM+bodQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY8PR11MB6939.namprd11.prod.outlook.com (2603:10b6:930:59::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.26; Fri, 5 Apr
 2024 23:01:27 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7452.019; Fri, 5 Apr 2024
 23:01:27 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "seanjc@google.com" <seanjc@google.com>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v5 07/17] KVM: x86: add fields to struct kvm_arch for CoCo
 features
Thread-Topic: [PATCH v5 07/17] KVM: x86: add fields to struct kvm_arch for
 CoCo features
Thread-Index: AQHah60wsHP29hDi6kKJ9JlK2WL9iw==
Date: Fri, 5 Apr 2024 23:01:26 +0000
Message-ID: <43d1ade0461868016165e964e2bc97f280aee9d4.camel@intel.com>
References: <20240404121327.3107131-1-pbonzini@redhat.com>
	 <20240404121327.3107131-8-pbonzini@redhat.com>
In-Reply-To: <20240404121327.3107131-8-pbonzini@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY8PR11MB6939:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: chxrrmRY5uTWYCeyGn+AzoxnTvonSYpAH/ieG0tlfXDkTDjSuyZfQxkzvpVjFfVVpJN/Ko8WC/IcXPZsT6E+9McRhb9cJLTDsNVlTXKQ9zkPE2SUrahcQ4Ytnh8oWbXzhylw8KUQBrgS2hWAOM0UnV+qHgSei8aiwVX2S7/hhYG5/mPb20CnNofgtaLNwhpg2IGaQAVNBMZQ7dCTwhu3u0D7Y5RAJXsGUoSxgeQDIP8SbKcaqIlrBGAgwiS6V6UPVKcSgSoZ1JNM5kYwW4Fd07VY0WrkM4UhfzqNr6P2Qc2RmS27i+nQBUgF8+XICOKmyBoaE5zYwjwqQlFIaq0PA/c8lGn4kYseHC0YbvRIbdyxL8r9jG8hStk7AcWtHtO+cVTJuOKCP73PBif17i4T6H0sPoGGhrRkmmbTPyWvGyzNtLPPUe3Co4TSk6zs6NK2unl3ZTcB/0bD0ieEaUSZabc/AjvPylZYOQbr2cUClxEnW7sv+EvZfgDL21BGeXdAQ4tty9VD/WiZJZUrtoRC74lwWVIEBpe86ky0QyF49Cw1mXNjJFvM+56j2NZeKfh3jaYJ+ctftutKJ9vuU+JN7tHRYgUr2xc4skKQ2mCDUxs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Ung3NUZ1aFNYRDV4UlJpc1hhWTZBdlUxYmdkQ0J3Zkg4TThsQ1QzQ1pLd0dj?=
 =?utf-8?B?YUMxYXlTZVZtV3J4cnhRNDJGcDRWYmUrOGhmajNKTkRUWmRXRzRkKzJLa244?=
 =?utf-8?B?UHBMK0ZXMTVOMEduUWIzK1duaExFSmNCYWl2dVV5OUkvSktldTg4cmdYZTBD?=
 =?utf-8?B?RnFuYTgycEM1RWJDdm1maUd0ckJ3YkU1VldDSjhCVlJwUThiWWJHVXNaRkhM?=
 =?utf-8?B?TVB6L1VzU0FkT25ObDFPRDFueDZ4bmV2QWhaWThZZEgvQUFicnN4UlZKWXFQ?=
 =?utf-8?B?NVhjOTFNNTR2QjdWeVNHSmdtd0kvczFXZ3hmcElHWEEzQzRITEMrYlFqeWV1?=
 =?utf-8?B?K0pVdTZSekYvR1NsRXFKOXRPamZZb000Ni84cm1YOVlOSlZ5VVBoamNiRjhQ?=
 =?utf-8?B?c3o3UDMrSFRUVERTWXRocjYzcFlGVDhYc1FacmgvK2F2Mkh0akpiTkdPWlhH?=
 =?utf-8?B?T2d5ZWdUQmI0RDJ1eS85SHJRMU5GZy9wOVJ3bGgyUk9rSmhKWE9CNnBDcm55?=
 =?utf-8?B?eFNoV0lWS3dhRFYwbXMxQWwwMmVEeWNwZVZwU0VSQVdtYVBzYlhxRzBlOEx2?=
 =?utf-8?B?bS90Zld5K2ZEdkhmRlp0bHhQeUs0NHpySTdaelppR0tONFkwa05IMlcxTEtN?=
 =?utf-8?B?bEFpQ0VOYXk3SStBc0pSQkM5N0xyNXJUZG02R3oxSmdXaitEZlYwVDIvenZh?=
 =?utf-8?B?RmdWZlJJd014TGVMQ1p2NVVXQmJONTlTSnFYUTNjYlpwZmFZR016MmdMTXlY?=
 =?utf-8?B?ZHYrLzNGd3FJalZPSFhpUVV0TUhwNVlIVnhXdU83RWRnUzVMRmV5ZGMxc3l4?=
 =?utf-8?B?d1NzWWlyRGhvNFJUL2RCb1FXUSs4eUVvcnNFVlRIUHRsSHY2SXAxOTVUU2Rl?=
 =?utf-8?B?UWg3a29EaXZIRVJQeGc0SGZ5QndScVFVbDVONGhXNkp0ZGRHekMzNG5peU5k?=
 =?utf-8?B?SHBDcDJIV3pKNXZOU1IvOTErOFdGUzRIYmFwTks4OFpZR3J2OUxocHhpaWpQ?=
 =?utf-8?B?ZzcrLytTaW5tZkZtMGdzQThaMEF2d2xOS0NpZE00WDJ0VFI3eEpXUFc2THlJ?=
 =?utf-8?B?TWR0Wm1jRWtCVXBSNElFZGhuWDN4emh3Z3VBZFExUCtjWndia3V2Z0pJRGtj?=
 =?utf-8?B?Tzg5MDh3ZzNvUm41cjdzY2lhTGVuTForRElFRVJuRGp4bmRuc2tjVTV6RXc2?=
 =?utf-8?B?K2NhS3JJbHA0M1BGaGI1WE9uNUZ5V1dodENrNi9UOWVSMEhkZzdKdnZ0YU04?=
 =?utf-8?B?cTE2RDdic1ZkUG5mT1Z3MTJQdllVeDMvMDRsVG9VQmlTWFRBS0JIYzBZMzR4?=
 =?utf-8?B?ZzNpREVvR1lTd0RPOFpIdHNSVTZyb0JZbFBFUGRwYWZndHpyWHZWMzlEMXdG?=
 =?utf-8?B?T2hWWHJQdTRRbWxDTGQza0NVWEJocTlQVGdpSVhXalc0OVlRVTJzRU1kN0kw?=
 =?utf-8?B?eDhMRU1yK3pmK0FVdjc1ZHRGcC9WMGVkc3QyYnlBUW5EdnBMbmQyNjBoTU0z?=
 =?utf-8?B?VlRXRnl6cS9NQTN4YlJFdHRHREdmTVdaZnc5R0M0bytUZ2FpNS9pQXVSZ3BR?=
 =?utf-8?B?TWVPbHV1d3d6clFQVjMxUGhUdm15MmxvK3MxMmozQVphMDUrNjBEZTQwK3lx?=
 =?utf-8?B?UFp3akxWdkdZK3E3MUNxbzVmb05XSTU5bno2aVl4ZERjT0kxN3BlNE9tVUlS?=
 =?utf-8?B?RWZpWUl4ZFNISTNDd0xrYWJPZmJuNXVmRmRpK0EzZnVtL1hFa3dBYUlUdUUy?=
 =?utf-8?B?M2dUTlRvREp3ZGlYUFZid3ZqWm9mejAwS3U3UVdTK1JCUVRxT0lJRnA4TS9F?=
 =?utf-8?B?SkVLVG42dURKb0tjZW9jelV5WHdjZ0FaME9Zd29TZnlCVVN3VzUvbUdlN3lH?=
 =?utf-8?B?YzVMRzRFMEVDWHBiV2NCU3pDTEVqd1U3cGVMYU5nc1A2d2ppMmVwV3hCcmNu?=
 =?utf-8?B?b1dRQ0hCRDE1ajRkWHlCcSswL3RKZWIwUHJoc0pqYWFWRXFXU0pWNHl0LzRE?=
 =?utf-8?B?WmNnWUxJaW5TSTdDWFJRU1JqdzV0OC8xcXR5Wlk3Q2d2dTlPenVQRy9DZVEy?=
 =?utf-8?B?Qk1rb3o0dGZxeFFtd2w0QzhXZGdtMUpVMGNQb1V5QnFTdk9GN1JqYytSVHZU?=
 =?utf-8?B?Ykh5MjE5R1FJa21VaFlBdXFSUHlIZnVBTWpjNnZ6Wm9xZUdmdGFqSXlUTkth?=
 =?utf-8?B?Z0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <60B98E4FC85C83499EA8E980D4651F8C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f77c5c0-059b-42e9-c963-08dc55c452c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2024 23:01:27.0031
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4Gm39TbNJDnKRZEQ/COrosPoHC3WJ/fWrAkRQIrXgsl5WUPnqslcs80d1nKVe23FZXnVzZOngjIDMx/lFV1Vd5hbM6aLhX24H0t5fBrn/Rs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6939
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA0LTA0IGF0IDA4OjEzIC0wNDAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiDCoA0KPiDCoHN0cnVjdCBrdm1fYXJjaCB7DQo+IC3CoMKgwqDCoMKgwqDCoHVuc2lnbmVkIGxv
bmcgdm1fdHlwZTsNCj4gwqDCoMKgwqDCoMKgwqDCoHVuc2lnbmVkIGxvbmcgbl91c2VkX21tdV9w
YWdlczsNCj4gwqDCoMKgwqDCoMKgwqDCoHVuc2lnbmVkIGxvbmcgbl9yZXF1ZXN0ZWRfbW11X3Bh
Z2VzOw0KPiDCoMKgwqDCoMKgwqDCoMKgdW5zaWduZWQgbG9uZyBuX21heF9tbXVfcGFnZXM7DQo+
IMKgwqDCoMKgwqDCoMKgwqB1bnNpZ25lZCBpbnQgaW5kaXJlY3Rfc2hhZG93X3BhZ2VzOw0KPiDC
oMKgwqDCoMKgwqDCoMKgdTggbW11X3ZhbGlkX2dlbjsNCj4gK8KgwqDCoMKgwqDCoMKgdTggdm1f
dHlwZTsNCj4gK8KgwqDCoMKgwqDCoMKgYm9vbCBoYXNfcHJpdmF0ZV9tZW07DQo+ICvCoMKgwqDC
oMKgwqDCoGJvb2wgaGFzX3Byb3RlY3RlZF9zdGF0ZTsNCg0KSSdtIGEgbGl0dGxlIGxhdGUgdG8g
dGhpcyBjb252ZXJzYXRpb24sIHNvIGhvcGVmdWxseSBub3QganVzdCBjb21wbGljYXRpbmcgdGhp
bmdzLiBCdXQgd2h5IG5vdA0KZGVkdWNlIGhhc19wcml2YXRlX21lbSBhbmQgaGFzX3Byb3RlY3Rl
ZF9zdGF0ZSBmcm9tIHRoZSB2bV90eXBlIGR1cmluZyBydW50aW1lPyBMaWtlIGlmDQprdm0uYXJj
aC52bV90eXBlIHdhcyBpbnN0ZWFkIGEgYml0IG1hc2sgd2l0aCB0aGUgYml0IHBvc2l0aW9uIG9m
IHRoZSBLVk1fWDg2XypfVk0gc2V0LA0Ka3ZtX2FyY2hfaGFzX3ByaXZhdGVfbWVtKCkgY291bGQg
Yml0d2lzZS1hbmQgd2l0aCBhIGNvbXBpbGUgdGltZSBtYXNrIG9mIHZtX3R5cGVzIHRoYXQgaGF2
ZSBwcmltYXRlDQptZW1vcnkuIFRoaXMgYWxzbyBwcmV2ZW50cyBpdCBmcm9tIGV2ZXIgdHJhbnNp
dGlvbmluZyB0aHJvdWdoIG5vbi1ub25zZW5zaWNhbCBzdGF0ZXMgbGlrZSB2bV90eXBlID09DQpL
Vk1fWDg2X1REWF9WTSwgYnV0ICFoYXNfcHJpdmF0ZV9tZW1vcnksIHNvIHdvdWxkIGJlIGEgbGl0
dGxlIG1vcmUgcm9idXN0Lg0KDQpQYXJ0bHkgd2h5IEkgYXNrIGlzIHRoZXJlIGlzIGxvZ2ljIGlu
IHRoZSB4ODYgTU1VIFREWCBjaGFuZ2VzIHRoYXQgdHJpZXMgdG8gYmUgZ2VuZXJpYyBidXQgc3Rp
bGwNCm5lZWRzIHNwZWNpYWwgaGFuZGxpbmcgZm9yIGl0LiBUaGUgY3VycmVudCBzb2x1dGlvbiBp
cyB0byBsb29rIGF0IGt2bV9nZm5fc2hhcmVkX21hc2soKSBhcyBURFggaXMNCnRoZSBvbmx5IHZt
IHR5cGUgdGhhdCBzZXRzIGl0LCBidXQgSXNha3UgYW5kIEkgd2VyZSBkaXNjdXNzaW5nIGlmIHdl
IHNob3VsZCBjaGVjayBzb21ldGhpbmcgZWxzZSwNCnRoYXQgZGlkbid0IGFwcGVhciB0byBiZSB0
eWluZyB0b2dldGhlciB0byB1bnJlbGF0ZWQgY29uY2VwdHM6DQpodHRwczovL2xvcmUua2VybmVs
Lm9yZy9rdm0vMjAyNDAzMTkyMzU2NTQuR0MxOTk0NTIyQGxzLmFtci5jb3JwLmludGVsLmNvbS8N
Cg0KU2luY2UgaXQncyBkb3duIHRoZSBtYWlsLCB0aGUgcmVsZXZhbnQgc25pcHBldDoNCiINCj4g
PiAgdm9pZCBrdm1fYXJjaF9mbHVzaF9zaGFkb3dfbWVtc2xvdChzdHJ1Y3Qga3ZtICprdm0sDQo+
ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3Qga3ZtX21lbW9yeV9z
bG90ICpzbG90KQ0KPiA+ICB7DQo+ID4gLSAgICAgICBrdm1fbW11X3phcF9hbGxfZmFzdChrdm0p
Ow0KPiA+ICsgICAgICAgaWYgKGt2bV9nZm5fc2hhcmVkX21hc2soa3ZtKSkNCj4gDQo+IFRoZXJl
IHNlZW1zIHRvIGJlIGFuIGF0dGVtcHQgdG8gYWJzdHJhY3QgYXdheSB0aGUgZXhpc3RlbmNlIG9m
IFNlY3VyZS0NCj4gRVBUIGluIG1tdS5jLCB0aGF0IGlzIG5vdCBmdWxseSBzdWNjZXNzZnVsLiBJ
biB0aGlzIGNhc2UgdGhlIGNvZGUNCj4gY2hlY2tzIGt2bV9nZm5fc2hhcmVkX21hc2soKSB0byBz
ZWUgaWYgaXQgbmVlZHMgdG8gaGFuZGxlIHRoZSB6YXBwaW5nDQo+IGluIGEgd2F5IHNwZWNpZmlj
IG5lZWRlZCBieSBTLUVQVC4gSXQgZW5kcyB1cCBiZWluZyBhIGxpdHRsZSBjb25mdXNpbmcNCj4g
YmVjYXVzZSB0aGUgYWN0dWFsIGNoZWNrIGlzIGFib3V0IHdoZXRoZXIgdGhlcmUgaXMgYSBzaGFy
ZWQgYml0LiBJdA0KPiBvbmx5IHdvcmtzIGJlY2F1c2Ugb25seSBTLUVQVCBpcyB0aGUgb25seSB0
aGluZyB0aGF0IGhhcyBhDQo+IGt2bV9nZm5fc2hhcmVkX21hc2soKS4NCj4gDQo+IERvaW5nIHNv
bWV0aGluZyBsaWtlIChrdm0tPmFyY2gudm1fdHlwZSA9PSBLVk1fWDg2X1REWF9WTSkgbG9va3Mg
d3JvbmcsDQo+IGJ1dCBpcyBtb3JlIGhvbmVzdCBhYm91dCB3aGF0IHdlIGFyZSBnZXR0aW5nIHVw
IHRvIGhlcmUuIEknbSBub3Qgc3VyZQ0KPiB0aG91Z2gsIHdoYXQgZG8geW91IHRoaW5rPw0KDQpS
aWdodCwgSSBhdHRlbXB0ZWQgYW5kIGZhaWxlZCBpbiB6YXBwaW5nIGNhc2UuICBUaGlzIGlzIGR1
ZSB0byB0aGUgcmVzdHJpY3Rpb24NCnRoYXQgdGhlIFNlY3VyZS1FUFQgcGFnZXMgbXVzdCBiZSBy
ZW1vdmVkIGZyb20gdGhlIGxlYXZlcy4gIHRoZSBWTVggY2FzZSAoYWxzbw0KTlBULCBldmVuIFNO
UCkgaGVhdmlseSBkZXBlbmRzIG9uIHphcHBpbmcgcm9vdCBlbnRyeSBhcyBvcHRpbWl6YXRpb24u
DQoNCkkgY2FuIHRoaW5rIG9mDQotIGFkZCBURFggY2hlY2suIExvb2tzIHdyb25nDQotIFVzZSBr
dm1fZ2ZuX3NoYXJlZF9tYXNrKGt2bSkuIGNvbmZ1c2luZw0KLSBHaXZlIG90aGVyIG5hbWUgZm9y
IHRoaXMgY2hlY2sgbGlrZSB6YXBfZnJvbV9sZWFmcyAob3IgYmV0dGVyIG5hbWU/KQ0KICBUaGUg
aW1wbGVtZW50YXRpb24gaXMgc2FtZSB0byBrdm1fZ2ZuX3NoYXJlZF9tYXNrKCkgd2l0aCBjb21t
ZW50Lg0KICAtIE9yIHdlIGNhbiBhZGQgYSBib29sZWFuIHZhcmlhYmxlIHRvIHN0cnVjdCBrdm0N
CiINCg0KVGhpcyBwYXRjaCBzZWVtcyBsaWtlIHRoZSBjb252ZW50aW9uIHdvdWxkIGJlIHRvIGFk
ZCBhbmQgY2hlY2sgYSAiemFwX2xlYWZzX29ubHkiIGJvb2wuIEJ1dCBpdA0Kc3RhcnRzIHRvIGJl
Y29tZSBhIGxvdCBvZiBib29scy4gSWYgaW5zdGVhZCB3ZSBhZGRlZCBhbiBhcmNoX3phcF9sZWFm
c19vbmx5KHN0cnVjdCBrdm0gKmt2bSksIHRoYXQNCmNoZWNrZWQgdGhlIHZtX3R5cGUgd2FzIEtW
TV9YODZfVERYX1ZNLCBpdCBjb3VsZCBtYWtlIHRoZSBjYWxsaW5nIGNvZGUgbW9yZSBjbGVhci4g
QnV0IHRoZW4gSSB3b25kZXINCndoeSBub3QgZG8gdGhlIHNhbWUgZm9yIGhhc19wcml2YXRlX21l
bSBhbmQgaGFzX3Byb3RlY3RlZF9zdGF0ZT8NCg0KT2YgY291cnNlIFREWCBjYW4gYWRqdXN0IGZv
ciBhbnkgZm9ybWF0IG9mIHRoZSBzdGF0ZS4gSnVzdCBzZWVtcyBjbGVhbmVyIHRvIG1lLg0K

