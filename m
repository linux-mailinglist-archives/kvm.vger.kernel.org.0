Return-Path: <kvm+bounces-52546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 62FC4B068C7
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 23:45:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7BF144E8384
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 21:44:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03D212C1596;
	Tue, 15 Jul 2025 21:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e7XfvtHv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0DCE253954;
	Tue, 15 Jul 2025 21:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752615914; cv=fail; b=rwlAzF6fHCVQ2raojejqs2OIY4wf29XPOQ/ttMTmipZg7FDHlS7ofYBh3wsFjnAmaQnSvJVDPZnzSAGUru03aB6M3tsH6pZlcZ68kCRFq1sClH3hV+YBXv3NzX1Bo0ysTXCMMAI/NC3z3SyKszRTBi9eEFtdjbNe4EqNskuiDoI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752615914; c=relaxed/simple;
	bh=u4PAah1yOY8SxBfKzoFrWkmRBzRCdHBB3KjU6LPRMCg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NmXBHI96J2azOCjNw9bkr84OF8Lui9glEU+JLSGUexIC5Hhc249/G7sxEk3qkS3tJBcYWV4OcR0cIrIDcD8NY5H7EoAOrtVrwcskts3ujwSsWVuESfvwdAAgCG1G0OAYAzwgfZkCnlnrqnySp65ybvuWgaoQDOLDQi3iVttdMd0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e7XfvtHv; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752615913; x=1784151913;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=u4PAah1yOY8SxBfKzoFrWkmRBzRCdHBB3KjU6LPRMCg=;
  b=e7XfvtHv8ufvffD4QriWP/jXritgdKgUtUYTxuE1wjESh2FM3kLwDIp+
   aGMz13FMItp+gTdyPfbxvY/87Q+hqRvfZgiRWin0uV43CLayXsu3c96+e
   miTzWln9liFmvYByHg02cMN8qYZS084xiNEPAq3dGAg/67dDAG5HEUMwA
   kWIwVGA3jITRW7E1wqM/tL0DnMIn4AItgLk+WjDHa6yia00I+88rmgv3R
   r7cSs/hb/qq8YCNmvq5r/xIIpU5PpsdiCFjSjWvdGlcigqddJQxqVHlxk
   9UAqxr2gXVeo1bylV+1PnECkT0JhgxRwBhh4cjUas+G0qmWIywDHFXDPm
   w==;
X-CSE-ConnectionGUID: 6bhyjEYHQGuTeOT1a3Z0Ig==
X-CSE-MsgGUID: fKOElfWzQSKrcrsI7X692A==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="54066529"
X-IronPort-AV: E=Sophos;i="6.16,314,1744095600"; 
   d="scan'208";a="54066529"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 14:45:12 -0700
X-CSE-ConnectionGUID: T9mO5DnOTBChK+//LKWPcA==
X-CSE-MsgGUID: 3swfrXUyTLquQX3nVO2WAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,314,1744095600"; 
   d="scan'208";a="162975405"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 14:45:12 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 15 Jul 2025 14:45:11 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Tue, 15 Jul 2025 14:45:11 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.43) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 15 Jul 2025 14:45:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hQWu06L2BjbokK0RVZnB1YaZ5sBw4N+CKAZdNlHsSoyZa1h3DkXJa7aCTRNjux3HZDg4IM65SCC7HWRq3mpMVgrIsW4jeOMH89KSEorp+ZGWzjkv5Dz/FI39/5ZTsWha/cm3uUXhP1f6gGVd/JSGxmSWmiwIjG3hzFZGGE5wo6S0AJbuEw3NDy/c51uJcXoQEz8sRfxkPfZqqAKKP3vZAEnreZRlKKZnO1i/mEqRWGlKdZ0/JdpfOy6AfTY6iWC7OOndZhZah9E5HhgynRvghN27jWi1qR4KK3BTO6MY01M6CTEIrXXnk3oMwIS1LU71y4IlYEmxQlIEf+pdBbucMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u4PAah1yOY8SxBfKzoFrWkmRBzRCdHBB3KjU6LPRMCg=;
 b=BbSXiKl0WqUWoy6/2C9Phj5NPPlJxpOYSOlMN7IR42MFmU0ec8qQeqIlKzgdK0R8Wxppuogr0ymJl7tWV/hz4ltS0oyfeooFhxGcIOw2gvrQV0SqcQHDd9BqTOgR1zg2J8dszW5j5OkAhDFrWK0FSeX64WDERpKpqZWcNSI1PeCDJKKY9+2bq5W84LafdSVB32U7vTNg1502rp76OQPSiimDSJp2rlj92gUA1VErHELawcYmEhvCxVYHoBgdVZSPf4JXtvHzLDScQmRgCESYvrh0w8wA8l/ea7qEYmNsYvonrgWPyS+QGstYfAlpwfs95bytgb4AdDG5C1egA7o7PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB6969.namprd11.prod.outlook.com (2603:10b6:806:2a9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.23; Tue, 15 Jul
 2025 21:44:22 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8901.033; Tue, 15 Jul 2025
 21:44:21 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Zhao, Yan
 Y" <yan.y.zhao@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "Lindgren, Tony" <tony.lindgren@intel.com>, "bp@alien8.de"
	<bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 0/4] TDX: Clean up the definitions of TDX TD ATTRIBUTES
Thread-Topic: [PATCH v3 0/4] TDX: Clean up the definitions of TDX TD
 ATTRIBUTES
Thread-Index: AQHb9WnbXywL2BsHvUioYRmXGp93gLQzSmoAgABuAYA=
Date: Tue, 15 Jul 2025 21:44:21 +0000
Message-ID: <790d2b19c6fea6e52e20d9ab136e8d69fbc949c7.camel@intel.com>
References: <20250715091312.563773-1-xiaoyao.li@intel.com>
	 <aHZvbok0tr7U4wf1@google.com>
In-Reply-To: <aHZvbok0tr7U4wf1@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB6969:EE_
x-ms-office365-filtering-correlation-id: e31b3577-fe1e-4cf3-fdec-08ddc3e8c278
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?U0dtTzlVUjd4QzF2TnAxa0dubEV3Z0hTM0hvNlRKWGYrTFRqamwvaGJpS3Bw?=
 =?utf-8?B?a1hoekxpak9KaEkwNHJkc0UrNFRNbFh2dmlKeGFuSlFCSGUwc25wZUtMVXkv?=
 =?utf-8?B?ZzFJYnZMdXNuaWNMRjNVU09uZG8zT0lPUkZ3MVJEazVlMjNucHhCcmNyc0RO?=
 =?utf-8?B?N0ZGd0VPQ1k0bnBsc09sbHFjc1A3RmVwR2pkQUttdkI3MWU3bStQSzg5cFhD?=
 =?utf-8?B?ZGpGWk1zRnNLbTlNWVFnemZoZE1ObmVYN3crSEVIeVYzY0swVHhpM0FycEtB?=
 =?utf-8?B?VVp5Z21Gd0FXUkpoeXQwMmFnbkxLMVVrOGRnd2NPbk51OXNGOGtXMzZxTU0v?=
 =?utf-8?B?eVVXYUtIalliT1VvY21iZnkvdlF1SnMvUVpqTUNMcGhEdEhDTmIvMWdNcjNU?=
 =?utf-8?B?SmJUeGI1WTFRbHFYTzB4MkpkWVNNUTZEeVdKZTgzUDlKeGwvVDQ3VW95dDJl?=
 =?utf-8?B?em9xYTFvLytkZjBSWWhqU0taYmNEeWlwNFBjS3RyQ2J2aDE4UVkrMlJsMmxB?=
 =?utf-8?B?UFBaU2Z1QXZoRXJqZGR0dHRFVHJGSSt4NmpQYVozQ0piS04xM0dITzg1Wi9F?=
 =?utf-8?B?VzdBTVljRkJ1MnlDVkd6N1FpSk82NDZBUU0xcEtJUHA1UnMzaWpDUkVRZWNH?=
 =?utf-8?B?MmJuNko0Sy9vVVR2SktNTmhySGhsOUF4a0JUeTJRdmVaNmpmczlvNWtrSjRw?=
 =?utf-8?B?cHozclZwTDU3Sy9LNllzN3Y1YU5pUmVmRTZMZVJGejNLdG9hbXFUL2dpaUkx?=
 =?utf-8?B?cEZpelhqcGFjTm45QzNBZG9NSHVVUlJWMnlZRUsvQTdIa1FRU3NxTnhZUmJj?=
 =?utf-8?B?Mm5OR0EwcVpNME5OZE1UOGxmOFRmUFNYdzVneDdNNC8rZGVTR2hjRlEyV1Vs?=
 =?utf-8?B?b0trbkUzWTBjUnBDSmUvUjdMeXdYWC9WTGc0TndMTDg3emNVdG5xTWJOWkZM?=
 =?utf-8?B?dlhGNFNvNGdhdUJZTFRnVDBxVjI3ckpWaDFEYW5ZNy9PUHgzeXZwbytGUXZ6?=
 =?utf-8?B?bFg2Nk1NNGFQdWNjdlZhNDNDTERUNmR4Q3pzelZ5Q2lYVmE1bU9PRGoxalBk?=
 =?utf-8?B?WE9OMlZkVHZTRUVDM2sweXpwcllQU3l2WUsxTWZqM3lLVWMwTmxrRzFDc0sr?=
 =?utf-8?B?Ky8vbVVrUDFVVlZaSmRoV2l1WEVvaFYxUWZtTFZrbDZjaHZiM1l3RUR0M2ww?=
 =?utf-8?B?YmVBOU02OFBUTkpBQkVST1JjMVB3YldpYmFsVjJxQjBZaVkvRDZZQTF1L3dD?=
 =?utf-8?B?VGkzS2tRcXRXOXQ5bWJQOGtNZURCSXlJdXFHNnA1NThVQlhkWmIyazQzaVJ6?=
 =?utf-8?B?T0Exd0haTHNlcWlLc3lSWTJ6TnJDUE5lbnp6SUxwQ3RDUTlCQkVrbDdVNnpi?=
 =?utf-8?B?NEFjUHRpSFZoTzFVSmxxcE14S3dVaTFzSStJVGYrbnU5MzJXOTNNSmZicDl4?=
 =?utf-8?B?MU1oY2FSbXF3dWZ3a2tnQ2lTU0NQZFpvZkZmZ3RBbUNrbnMza1lrd0pMZ3Z5?=
 =?utf-8?B?UDdWR0htOHpGZDcxNVdVNDZvOUNrd0lMN1o4OWpxYkR1V0x6SFd4OEVzalht?=
 =?utf-8?B?OUpzcjFtU0lGTlVyY012eTZ2YmlMcFFtcjUyVVVueGI4bjlpMjhoUjhzQm14?=
 =?utf-8?B?UXdxUG9zZWptWExDYXhPOEo5TEE4Z2FkQTVGdUsrWEc1TWIvR2Jra1pKVnpU?=
 =?utf-8?B?MFJ0dngvM3JZamtMVnQ0SWJraElsWmNsUDFObnFHQnVsUGN6bUhvMTBRTjAy?=
 =?utf-8?B?TmIxQWtFVHp4Z1BRak5BUmowdXBKR01Hc0lpdWJscC9GaDdTQ1FKTHhieENF?=
 =?utf-8?B?SkZwOHE1TjFGTE1XZ3M0bCtzNG8walpveUhKOWQyTVdHR0FKd0J6NUlVaWtV?=
 =?utf-8?B?SlhLUEhVdmhCMEJtS25QMkR0VjVlK1ViNWFLaWpXWlh1cEhscDBoRWtqMmN6?=
 =?utf-8?B?K0NDWXRETGNJMjVJTHdQejZRSm0yTUZSY3FaNzdBQ2RKZXBCZDB6Vk5aWm5E?=
 =?utf-8?B?Ykh3MnpJVG5RPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?STIvM2xkSTVQYmNPMlJYMk5zdHNzb25EZ1FEL2F2WVp3SFd2aUwxeEhQMXRI?=
 =?utf-8?B?L3JSdGdZQitrK2hScWJ0V0xCZjN5R2NzL1UwQUlCUmcyZHB6bFpBc0YwQWV3?=
 =?utf-8?B?TkNqOHNEUE85ck1IaUpDMi9POGNic3F1M2JERkY5VHdrZGZqZU5sWHBmRmZK?=
 =?utf-8?B?VHF3M1d5U0R1NzdjZjdwSFZLK3ZCWlhpWmtrTVFqUDd1dXFPcHRXeTZhYnBS?=
 =?utf-8?B?b1RNVm5hZi9LeTJ1VTBwRHh2eVFhVWo2Q2JMNW5xcVVLc2VHWmtJa1dCNEdP?=
 =?utf-8?B?R2ZLQ1hET2o0dkwyNGplKzVBK0dmNkUrUWhRRUhPVmsvc0hDSG53MGxJNTl6?=
 =?utf-8?B?NVB6Wjh5NERBaXFmY2tFdDVvN2lXVGx3elh5bStMV3gwZC9RdkxZcmdaMFFm?=
 =?utf-8?B?MHYrenl2bjlEUytXc0lnVHpjOVZUZU1PZnoxelRUS1NBbC9JdGlOT0Z0NVI2?=
 =?utf-8?B?OW5OWmREQWxiRjA0eGJCWEx0ajQ1bkhEekpLZGp0MXhSWXNFQVpqc0M1RzNQ?=
 =?utf-8?B?L1VFRXlNTktmbzFSekxHenUyRWFJYXpUVmtrTnJHbGlWQ0JJOVo0VXVVeXdF?=
 =?utf-8?B?OHNxR3RkNWw1TGpCZ2xVTmZrSG1SenJGSmhUSVB2a2l4QTg5dFk3V2ovMWZH?=
 =?utf-8?B?VkluOE4vZ2c5ZFlqNHlBZk10VVNCekE3UE00MWhJRldaajBrYjIraERIL2ND?=
 =?utf-8?B?VE8wVlZJRDloTmlydUp0Z25rUE9SQ0hnOU1BaDhZU29ZSnRnckdwRWQ3QkdS?=
 =?utf-8?B?TzI1VDdSNUR1aUNlbFFoK1hGdWwrZXgyb2VEM0JJNzhETzRpelZ6bHpHMm9Q?=
 =?utf-8?B?K2UwcU8zTmhFaWdkd2NaTVFBeG9XZ2Rtb3FvN0J4SUgxMEx2dEIybGM1bmtl?=
 =?utf-8?B?WW1RYm1XZHpRbDNmc0JSTVc5YjhUaHgxYmQwRnEzU0FHaXExKzBFUzJpVnZq?=
 =?utf-8?B?MXlIVmNCNms1TVQwRDdSLzA3U0hIREtMc3d5UmZidXhIVE8wV3FXQ2VZSU14?=
 =?utf-8?B?TlVYZkp1bE5ZcklBMys5ckV4c0M4bU5kd2IwbVVCN1REdzJjZXp4S3RTdHNQ?=
 =?utf-8?B?b092WXY4eXZiV0crZENTbEEzWVZaL0RaeDdHWTBzNVc0UHd5ZzM2cklmUXRk?=
 =?utf-8?B?VG1ScU5yZmFqS0wxNXc2TmdHbDlNVU1QcEhyWi8xRnJidE1sMCtFaFlkbmRC?=
 =?utf-8?B?VWMzMU5rdlVDK0V4VXNMTWU0Mkg2ZG5LNi9HZUpkV2ZtaXhWdzNvNjJaN3lN?=
 =?utf-8?B?N210SzZzNWwweFlIVDhwbm0vbExTcTU5c2VUUWs3U0gzV3ZoMXdpZCtuVDZO?=
 =?utf-8?B?bjdWTWlmSzQxTTBua3BhK2ZLMjdTMzhBMDVwb3BCaFBFZDZ5elNvOGc3aVEv?=
 =?utf-8?B?ZGN2MWdMTHRESkZvK0JCYVdOTzRndEttU1lYd0hqNG9QbXFHRHFISTFjNlVO?=
 =?utf-8?B?WTVLSDFkMGp2QXhzWlFHSk0vM0VOS3dVU0s1cnVBeERFTkk1ZFp3VytUcHVT?=
 =?utf-8?B?TUlNYWJVb2JuVDI1QlBBajU5Z0hnK0UrTzhBOVdVRXJqZmRlRTYxZ0gycDl5?=
 =?utf-8?B?VzFNK0x2UmpkVEdoL1FuNFM3Um5FYzkvOFVTQWkyMDN2NVZwQXBWZDNSbGcx?=
 =?utf-8?B?Z213VlpxZjVwRm5UcDhzaTVzRS9RbWJCYTdFd3dYR29oSTJoWEVWcmxPc0Jn?=
 =?utf-8?B?VVZMMHR0ZnNhUGgrejE3S1ZUajBYRTl4Uy9vK0hWY2MwaDh6eE1LclFUYmNC?=
 =?utf-8?B?QzNZM21QUy82ekNjQ3NVQWJpbklEeXVSQ0k1ai9PNEVrS01PN2Jya3B1eWNl?=
 =?utf-8?B?NUdlVElONmNEVDBwSUFFSmhUeVpnZlRWLzAvbDdERndlZWxSZ2hEdGRPWVhT?=
 =?utf-8?B?ZXhLNDRMK0I1NFRXQ05hc3pScWM5MjluMFFHRlN0R0pBQW95aDFQbGFSV085?=
 =?utf-8?B?TkUwRHM3WjBEMk1ydkplK3NHRFJJK3VKYldQUWVYcStnaUtueXBDcERsK29o?=
 =?utf-8?B?N0xRc1V0WndiOFhYd2hPVCtoZ1BRV1ZJSDJyTUZLZXl5aVMraHpmNGtxbGVT?=
 =?utf-8?B?WnJsRlBrYWJLdDhqckJ1SElNcGVlNmFnNmdVaEtaL1JzbWZCSFphdGorV0hv?=
 =?utf-8?B?NGVTcVpQd29lbnZLNms0VFlld2IyVkNuUjJvajNIUTBZQVFTZ1FMSjlQVU1S?=
 =?utf-8?B?Snc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <736630C0C3FA6A41A7F6730E0EDCD676@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e31b3577-fe1e-4cf3-fdec-08ddc3e8c278
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2025 21:44:21.8706
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XisbgwIRHuvnp+NP0zicsVkFHN17B3Tjo0dt3kybWcxE6Y9kow6jJtfA22UHAOfPb18yk2dJqfNM+TeAX9kKSYTONLYqBBZoGFTvFMtnFBo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6969
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA3LTE1IGF0IDA4OjEwIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBBY2tlZC1ieTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+
DQoNCkxHVE0gdG9vLiBJIGd1ZXNzIHdlIGhhdmUgd2hhdCB3ZSBuZWVkIHRvIHRyeSB0byBzZW5k
IHRoaXMgdGhyb3VnaCB0aGUgdGlwIHRyZWUuDQpIb3cgYWJvdXQgdGhhdCBmb3IgYSBwbGFuPyBX
ZSBjYW4gd2FpdCBhIGZldyBkYXlzIGFuZCBzZWUgaWYgRGF2ZSBzd2luZ3MgYnkuDQo=

