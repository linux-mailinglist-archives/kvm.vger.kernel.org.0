Return-Path: <kvm+bounces-34540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4851A00D9B
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 19:27:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 412D7164939
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 18:27:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A85E91FBEB3;
	Fri,  3 Jan 2025 18:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Uut1rpCZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8ED167DB7;
	Fri,  3 Jan 2025 18:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735928856; cv=fail; b=njnhKZ0Ck8kCjZMYVIJFd8kHgjZ8haCCJihEYoptSSfEloxpdUFB0eQ0vJc2ntp324It9EXQFm0rUrH0ybvRfotlw7nRIURImEgU9yYmmkxVKg9UuP15mslMblDU034GtmvxPxBbfs3fj/CH//09xaB63jvyRjLPNnzNsI9z3MQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735928856; c=relaxed/simple;
	bh=XRXNc2gQzz+2eAnrxS9M+hmvsRzojMKhOznDs4WsnSo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kgjgxQmgotwxw0L1DnV4VSJp6oYQoaA+WEryII3ZGvSk51FiuSwgLA+FVvYU/aa9IlDigLtFA3FL73lUHhT0arxsCJcNmKAaumz+duegS90+fiOV1/tzgLAODDAVZ6r8PO1hqSgYlgtNs0V7rKheN76ewRFQWdIHaiWVAVOcQ2U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Uut1rpCZ; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1735928855; x=1767464855;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=XRXNc2gQzz+2eAnrxS9M+hmvsRzojMKhOznDs4WsnSo=;
  b=Uut1rpCZfQgfo3OKNMIeyZdhngkvmEBtG5UorKINDvjFibIvLZNhDcDo
   +iuwHCtFGoNDy+36J5wYbdjPLbrMsc4J8ER5O9sI9r1H9IszYr4kZ2fk9
   ggfKN8GVdnrsPNxc2LpbYq8OeXU/axcA0vPEiWF9tmBE/zokVrr6GHxc8
   2XlHUXPfXNqLX63Is2zwT74r+Ahj7zD0VjJtbx79oLOdC8cJQy/ALgxaf
   UO1s1EDxC/ijkVzrmRzdFbTDWEIKAzjQTKbqgvglpDkQziJe5d9a7nrbo
   LPRblh8Yb5XUspWd7Evm8P6Rb5mTtYat1GAiaKUPnsoh6hLYMkElV/y4c
   A==;
X-CSE-ConnectionGUID: 0ZGnntulQGqRABfJQki0ng==
X-CSE-MsgGUID: dCaOdP89TySfxallXjTJOQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11304"; a="46759655"
X-IronPort-AV: E=Sophos;i="6.12,286,1728975600"; 
   d="scan'208";a="46759655"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2025 10:27:34 -0800
X-CSE-ConnectionGUID: rCIRCt8DTzqXVZKcbv4uZQ==
X-CSE-MsgGUID: Q1jTmk9KSpqbjMClSJYYUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="132770831"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Jan 2025 10:27:34 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Fri, 3 Jan 2025 10:27:33 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Fri, 3 Jan 2025 10:27:33 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 3 Jan 2025 10:27:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z9RG/58meg4gMZotMT4MGNlr56lyL8SDjC4PcHXDm/GsYa+Xj6ORXAKDcEuG7OkrUEO5qcaKywEgTL9ob6CJN+ziUUEvXn+czcl0zmHvd84h4EPcDktL1gxC8v4paEsBlvZ8z+lcAFkXdGjNOBd+W8AGPFC24H2ldgqGwfELCu64Xij5Pk7hYOpTzf/MeL9Pp3vP7FWPpx0xIpzF+os4qy8NTgwWyyU74M890xjCSsvzWezBEahAgwfftd36rDmwX5aRhcx7I+acXnNjDgB6+QPQtDhica+9QTe6cjHu5LYUINtyPvrTigou0JfgXVBGWLWd7ZT96KjlBxyqSX/EQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XRXNc2gQzz+2eAnrxS9M+hmvsRzojMKhOznDs4WsnSo=;
 b=KiKaZHcrXVIz7B7NEEYlh+huzk9DcR/csP129X3bDnM4AmXdvOyDA6myH+kO0dLV1j2LtioXK1woBSgWjz+Hev2USzGocxgFcnS0MJuUjq0r8tNznFJrkIkAvPZHbh3mSAXRIN5lg6BKUVZpVY+qA8DZjFWhGQJgP3ASkiRpBGv1D/bimloD+AXhwzYixK9ZoUFgychVPJn0jtihr00HacOdyplbcNwf5v0tZvrMNb48DV4Zsl0QRLDIIZF9ilhrgqUTFgo+rCszbDscoisOh8AX6ueRv3TQFYfhhWLgLPIMFtWOfwpuc/WLaU1tbOyDS7lUnfx14NTX05jGtcsuoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA2PR11MB5211.namprd11.prod.outlook.com (2603:10b6:806:fb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.14; Fri, 3 Jan
 2025 18:26:46 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8314.013; Fri, 3 Jan 2025
 18:26:46 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [PATCH 12/13] x86/virt/tdx: Read essential global metadata for
 KVM
Thread-Topic: [PATCH 12/13] x86/virt/tdx: Read essential global metadata for
 KVM
Thread-Index: AQHbXCHXHYKHfIaq90e6OAWpCsfTR7MFYdKA
Date: Fri, 3 Jan 2025 18:26:46 +0000
Message-ID: <65a500bda8dc89968f1308ea10f952312f955683.camel@intel.com>
References: <20250101074959.412696-1-pbonzini@redhat.com>
	 <20250101074959.412696-13-pbonzini@redhat.com>
In-Reply-To: <20250101074959.412696-13-pbonzini@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA2PR11MB5211:EE_
x-ms-office365-filtering-correlation-id: e65a373c-32f3-4326-993b-08dd2c242e79
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?YThrUnhodGZWNWZRNllTV3NmSGs2amhRMmozTGp0YThHOHZQR2hmMktlTllM?=
 =?utf-8?B?bC9abTJFejI0NEs2ZGFJdnUySWJ2K1R1L2JiQjdvYzV5UytHTUs2ZzhJdjRj?=
 =?utf-8?B?YWphb2xPSEVubWJ6OTZJZmJsbU9vL0RLTEhNTVJUSkxMWmo0YldEOVRhWWhC?=
 =?utf-8?B?RTBHdG4rempadDIvdkFtNitJcFhxcGhmYkJUS0dCVllNOHVSUTJDY0Y0V3Bu?=
 =?utf-8?B?QUtGUWMzWVZQbS92bU1jYWdGMS8wSDRKSEJQTVp1RXlpTW42VGVhSm9hSlc3?=
 =?utf-8?B?dW1VUWVrcDhNNk1BMDZicFdNV1dYRzlpbVVWZUpaaXJmYnppNTlsNTZhMjNu?=
 =?utf-8?B?eFdEVWcxYUR4OWs0YUhOTStKbWZLWUcvTVhha0dDdjlJNmpNWFlmTmgyRERP?=
 =?utf-8?B?bDNjVjNiSTZ5SFVPREw3UGp3dUt5RUY5dHlkVytwYWdHZTBESDJMYzhSUnZu?=
 =?utf-8?B?cFNwdjkydWlKTEVrYU1kVFAvcHVweVdQYTdOU1lpUTJVZ0hpV1ZIL3o3TTg0?=
 =?utf-8?B?T2ZyN3pnc2x0MUYySXNoaEQ5MUJGZUNWaExxT3VZK0hhcWEweHlmeE1HM2pE?=
 =?utf-8?B?aUZvenNKRmdwUjk3VjBlN0tNTDFPZ2RubVpxN1FVaS93NVdDc05KK0ZhL2Vv?=
 =?utf-8?B?QXNsUlo1Sm5OTGpPRHloRG1FYVFHdmVoeTE3QUFrUzFYUWd2T2htdnVEd2tO?=
 =?utf-8?B?OGplNTY5bVE3M2UyZDZEZkxDaTZtRVpGYVNreUpJdjdLSlEydkVwdmRKUzBm?=
 =?utf-8?B?RGRqT0VNSkc2MU5EZlliNEZoWUNUTFZlWjRjcGcrVUtiQk8xNTg5RW5DekZx?=
 =?utf-8?B?VTRua3BZbVhCVTZVWkswV3lROHR4UWFCVjR4NkFaRWpxellMZHR5am1mNlhN?=
 =?utf-8?B?N0VyeUx0VngrMjZIQ2pKL1UzYk04MGZ5UVVZY2ZHZEwrNzM5Y0lhQVJlSWZy?=
 =?utf-8?B?ekdUTjdJMm5FWTVycE5DdUIvMUdtejdOb0RRRFIvYUp2ZjN0Z2F4cTNmeTkr?=
 =?utf-8?B?NXorOWdyRi84M0p4RjA3eFZEY2Zia05pWUZOMmZUVTlBbmUyYXVISnZJNFIw?=
 =?utf-8?B?WHh4Q3liVUpEbVo3UHpYNDlmVWExaDFPcEdXU1BtTGo4WnR6c0Q3cEk0dU05?=
 =?utf-8?B?QWRnS1MrWFZyYXUzUnNKaTFtYjMra0laVFFpTGF6V2MyQ0dkN2FxTi9xZW9j?=
 =?utf-8?B?aldESmViRVZuWUlRSER6Qml3cm1haVZvSmRKOXUyUGtLRGJGRVJ2dE81Tm1T?=
 =?utf-8?B?Rzh3QUUvS012S0ZCNG9Lbi96OTF2bXByeFovNS9uU0Y5Q1RmeEpGbTVCUStk?=
 =?utf-8?B?Z04wM3lKdDhvbE9FM3lTc1lqcExBckpINGJXMUdHMkhtMkJ0QjFzNTI3Vzll?=
 =?utf-8?B?WUNTYmZpRCszZmRsVGtIMWNienluZzhQZHFneGtqYzg3QUxac1hLeHhCY1Mx?=
 =?utf-8?B?b1I1TEJna0pJYXlhbVhqYjd6eGw4M1RXeGhTM094ZzZoZ3NwWTBVUzdXWTEx?=
 =?utf-8?B?VmVHb3lsR3Nvdkp6WkczZEdycnVpUTBKdituakZ3MUwvNG9PSk9WUmRLcnRH?=
 =?utf-8?B?anlzUVNjWlpOQVNkaU93K2diVnI0SU5HZmEvdnJ3bHl5Yy9aU05jNFFaZXIy?=
 =?utf-8?B?aTNmT0lHOW1GU1lEbE05UFFxK245dTJ0V3FLbms5WGhyMkJGWDlBay9BMGdq?=
 =?utf-8?B?TVhXaGNHZWZPVDlMUzROVUQwblhQZk1RSnV0Ky9WYmd4RmVLNm41ZUhTMTRk?=
 =?utf-8?B?TVRDQ2ZqVDV5Vi9DdW82K01RQUR5aUVMaGp1Q0JQeVB0S1NaUzVQYWNKQnd6?=
 =?utf-8?B?WDJPSEc4Rk5kaHRQSDh2dDVERm0xdU5wODNCTjdSSmNLTmoxWmRWMEpaa0Iz?=
 =?utf-8?B?RTM3QTd6dTY5Ni9ZeGd3ekRmR09lV01vbTg0Ym9XNkFZM2dFRDE1T2s1dEVs?=
 =?utf-8?B?VUk0RlBMeWI3QzgveHlLYVhrMXM4SnJQeDE3VmxtMWx4c000blM1bkxQMlhm?=
 =?utf-8?B?SFpadXUrbGZ3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RWVGM29YNFFnT0tIZXpodzFZUTZNZ3YwblpUZkFkSFFCN2FHYmt6VmYwRENv?=
 =?utf-8?B?Ym1sNWVBYzNFeTE2b3ZyK0hlajlRK0h3cHI0bE4vZGwzTU1OZ0s5QzFZNXA0?=
 =?utf-8?B?S2JucDB2NldaM2VqdnNZWGJoanFzZHFVeVR2L3RrNVBXSUErTUpIWWtlR0Zl?=
 =?utf-8?B?Mk5ZSGp4WHJWaVBKc1B0K1Z4cGNQclVKQ0dyQnZWZVJoSmg2RmRpelNBcEd4?=
 =?utf-8?B?TzV5VFZHbFVoaHVvU1Z0eWxiWjN0S2pRWXMwVHhPNmdEQjNFdTlSdVh4UkdR?=
 =?utf-8?B?bmFCRVkwVHZRZUFvN2d3UnRDS3pXa2dtUjZuUk9idVk2ZzUxRUg4TUZPUXRp?=
 =?utf-8?B?alVyeFBLUnNERm14SFcvTm9VSmk4YUZ0SEszNU55UjR6cGJXcTBaenFwM2pC?=
 =?utf-8?B?b1J5ODE4OWdETlp1b0xtcDlaTjdpK2JVV01FdzRwaGxIM0hKYU9FTHZwS280?=
 =?utf-8?B?QlRnVDFoRjdwVFZBajFqVE1TM0tOZWlvbjJCZ0hQQjYvMG9JR3NScFVOWi96?=
 =?utf-8?B?WVlrT05UR1ZkUm01Z2dyRUthelp6c1R5Zk0vQStqMEhKNlZ5dUYzMHJMc05R?=
 =?utf-8?B?eEVRcnR0Mmg5RkRwQUFBZlA1Z1VJdDZQbFNHZFdjbUVkQTZ2ZVZTK0EwdmF1?=
 =?utf-8?B?QVZrbFRiaDI4Q2UwZXlRcTdOV1lWN0dKZjdNVVgzcEFYOThsdXRBSENDRzVG?=
 =?utf-8?B?cVVIVFlXZVhoTzJlZkxvVitTWmhvc0JJSlRQR25JQTNqbUh1Q2pEVHRkSzZL?=
 =?utf-8?B?UC9yeElPbWs4Z3pscU9PbFg2V1p1aWZDcWZLNFZKNWsrUGNqSDZ0SFI4dmpU?=
 =?utf-8?B?c2c3cCtmNG0rUkFaMXorSXQ2WVhNNk85K1NSaHBVbzFCZHNSY09RblpieHVC?=
 =?utf-8?B?cUY2L1hTY3VJZ1hzYzhMeWJBTllSbEUrWHNySU9Gc0RlTExHckc1UmZnRkJm?=
 =?utf-8?B?SW1lZEh0bXppTGhWcFdnTU5iL1E2d0p0OXVUcUpUYkxUVC9wbFRhdXVhaEtm?=
 =?utf-8?B?aHNRSTg1YnFMVllqMmFmUWVBSlNzVlZxNGgyUk95TmZOVzFKakNQdmhjYkdO?=
 =?utf-8?B?TS9kekFhSWN4V2Urc01xMEp0Wnl0ejQwNWdlSXBINkZkOGEveVJUUHp6amwx?=
 =?utf-8?B?M1lWWm03bjhzaDVaRTFodHdpYnVORldCUTRyT3JPbVJ4RFJua3RENGM2ZkJi?=
 =?utf-8?B?bGY2NmhxUFYySW5QSEFkRXhjNHlhdnIzaWw2WUVtRlZodVZmcVVnMldyaG50?=
 =?utf-8?B?aWoxUC8yWGNMdUpUSjBkRVFhc3VLK05TUFo1UjdLYnVsSVFObXI4L2NwekxH?=
 =?utf-8?B?STRkdW9ETWZ0TW5pYStHNlYzS2xjeFh6YUxMQTQwdzhCRXdneHU4d0szNWR2?=
 =?utf-8?B?UUdYbmVBQ05WYlhyQUNNdnhwNmViU1JManJsNFNwNmJvdmZiVVJTMUovUWZ1?=
 =?utf-8?B?WldGazZjNEl1M1FZYmFRN2RaNGxEV0szVi84T2xMbUZVb2xEZ2pYcXE3NWJS?=
 =?utf-8?B?bVlQUnFPVUEwWVZZSG0raENXTmpKRzBjNFBmVkw0dG1wU0xGR3ZmakpxcnRU?=
 =?utf-8?B?QVhvcm50dVBudnI0eXNQLy83Z09WT1RWZUMzWlNHTHpLaWxpOG5YcUk1SndQ?=
 =?utf-8?B?dkdjWUF4NUp0NjdaTURNcWZTV2lLTmFXMEEwQjNqeGppcXZwTEVFVHN3U3Vy?=
 =?utf-8?B?UUdzMmZUajhKYVNEaG1KUmxzVUYveWJQcExEMWZSOTRvWnNxc0o3R3NFYW1R?=
 =?utf-8?B?bEl0QUtRWjJDeGd1ODBvcGpQeEdBZzk1UkdNM2V2VUsvQlpwaytlSE1Vdis1?=
 =?utf-8?B?eWMrZ0RsZ21Ob1ZkYnBHT29pK3dEN1ZrME9xWTRyc1Vzb2tDOUpsYUgzbllF?=
 =?utf-8?B?anhUbi80OU5TYnViTmY4SHFQdnVvQmhJelZzNjV2OVlHRTNwUVdBTDFrWnBM?=
 =?utf-8?B?S1g1a2UxZDRFWVAxbTZrbDJoam9hb0puTlpzOGlIdHUvdEh3RjdUeVh3MmJp?=
 =?utf-8?B?Yk9SbW9RbFNVdzlhK09NejRGQU9DWVY3dUpzUTZDTW1TSDRUZ3QwaU9yWEhk?=
 =?utf-8?B?SjdjWnJ1OTFRU1J2Q29qWU5wQ3Z3eUxNSTlrRnZBeHlQZVc0c0ZZSnI4NExF?=
 =?utf-8?B?OXFPbXZyRnRITXZUY0pxSnBDcWM1L0VlV2RHc2FoUWNCYldoaFVDbU5rNndH?=
 =?utf-8?B?akE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6F8519460DB809449EC058536D6D3E91@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e65a373c-32f3-4326-993b-08dd2c242e79
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2025 18:26:46.6288
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +bPcK2LORrfXZnPMxyJBS9OTBGkXPdDqEKzG9Fj2LgMbGr/I7jRqLGGi+0mzXLO9Rd1EhwANp1O7Pcv8c4SHS2akuqAl+yXmwZ2P1JIjQsY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5211
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTAxLTAxIGF0IDAyOjQ5IC0wNTAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBMaW5rOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9rdm0vMDg1M2IxNTVlYzlhYWMwOWM1OTRj
YWE2MDkxNGVkNmVhNGRjMGE3MS5jYW1lbEBpbnRlbC5jb20vwqBbMV0NCj4gTGluazogaHR0cHM6
Ly9jZHJkdjIuaW50ZWwuY29tL3YxL2RsL2dldENvbnRlbnQvNzk1MzgxwqBbMl0NCj4gU2lnbmVk
LW9mZi1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5
OiBSaWNrIEVkZ2Vjb21iZSA8cmljay5wLmVkZ2Vjb21iZUBpbnRlbC5jb20+DQo+IE1lc3NhZ2Ut
SUQ6IDwyMDI0MTAzMDE5MDAzOS43Nzk3MS00LXJpY2sucC5lZGdlY29tYmVAaW50ZWwuY29tPg0K
DQpJdCBsb29rcyBsaWtlIHRoaXMgaGFzIHRoZSBjb2RlIGNoYW5nZXMgZnJvbToNCmh0dHBzOi8v
bG9yZS5rZXJuZWwub3JnL2t2bS8yMDI0MTIyMTAxMDcwNC4xNDE1NS0xLWthaS5odWFuZ0BpbnRl
bC5jb20vDQoNCmJ1dCBub3QgdGhlIGxvZyB1cGRhdGVzLiBUaGUgbWFpbiBtaXNzaW5nIHBpZWNl
IGlzIHRoZSBleHBsYW5hdGlvbiBvZiB3aHkgdG8gZ28NCndpdGggMTI4IHNpemUgb3ZlciB0aGUg
ZG9jdW1lbnRlZCAzMiBhbmQgdG8gY2hlY2sgdGhlIHNpemUgYXQgcnVudGltZS4gSSB0aGluaw0K
dGhlIGhpc3RvcnkgaXMgZ29vZCB0byByZWNvcmQgaW4gdGhlIGxvZy4NCg==

