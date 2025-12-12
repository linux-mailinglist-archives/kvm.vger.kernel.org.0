Return-Path: <kvm+bounces-65809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 71ECFCB7D5E
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 05:07:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9A9373033718
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 04:07:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C56662F2617;
	Fri, 12 Dec 2025 04:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NZJ5m/Sm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB6D27E1DC;
	Fri, 12 Dec 2025 04:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765512446; cv=fail; b=B5Rlj3GV0fWzgxv3z5kvFvcMjx+MDI2+FI/73kRgQDcu2lmFEznm6YACoKdePYxT53rteoVppgzxiU5gYBFuZ1tzNkIv3CCv+QBCxLKu2qsBa69DDlEMmd3sAfztrpWiy/imkcjnxjV1OkFq3htHUN9DE8ITuzypWF2a2lG7jXc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765512446; c=relaxed/simple;
	bh=YKWkfxag8jNTUCV6IROnUxSu9kWh1ciW0UsNFF/GjWs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TGmiI8fX4yN2+WBJyxenm8T3la9zPEJbCZFp1liDgilqRfO5i9q05NmPF6McYWYPn/iKQwJ0+aK3Vn2zRTqFZpKQ3M11ybuN62rVc8pDdzKH9RS7xVN2VLUi2lg2GQwKyGD6ahBWnAd3LqpKlQ2Ea4KLQ01Wr8mcphsAh+BK5pA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NZJ5m/Sm; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765512444; x=1797048444;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YKWkfxag8jNTUCV6IROnUxSu9kWh1ciW0UsNFF/GjWs=;
  b=NZJ5m/SmCkt7vmDpyoKsKaXzSNA2A5zt7vFJuGH3XUIQgKdJ8wU+KQ2s
   VdNpYVvcmG6YXldERgIQSNT1Hwuv5Ifbdy3ZBsXvP2wDHePo8u+023bX+
   VTAK4a9VEQfPrzAShmch5zpJwAtodnbvFhYc2vWwtw2uTnOQ0jojSa0jz
   ZoNLNpzxgskEFH4Dx6HI9ByzR4u2SaU5nFcmRdpLaBePJgKvPrAxA23Qq
   05Tvl/2Pa8cOKzVr3ui4DwnjyyXuvnmayT9lGSKb0mkL5CRgdPXW1/35p
   v4/mk4H3C7/XY11RsjfLOaKLOa8aL/BkEpqC7OacIF2Q/Wz3E+cjQOrE0
   w==;
X-CSE-ConnectionGUID: C8r8OKCQRTO055gF75yIZw==
X-CSE-MsgGUID: 1Kg+NbkxQheFM075gos6nA==
X-IronPort-AV: E=McAfee;i="6800,10657,11639"; a="67387697"
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="67387697"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 20:07:23 -0800
X-CSE-ConnectionGUID: awimuTkmQG6nJ/VD26VZRg==
X-CSE-MsgGUID: UgjasLpcSdmTV1TRLz38ww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="197030596"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 20:07:24 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 11 Dec 2025 20:07:23 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 11 Dec 2025 20:07:23 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.46) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 11 Dec 2025 20:07:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WS2wO+XkP9/2yjMPepZEpjOmaA5fNI7jAPjbwUgnHQN590I5TRLJy/adoplEFKEZzJafqak4ILDw+1jsDkg6rFhHi12wXlPmMl4oCXda1cgw4lbbU3HonAKz4BVoBZkYyaHbSkv0WeovlZF10shJqL2qzB7747uC4CNFSeunW7h2HduYWyPknEx4k+ILhiqCJVrSfwuebiPGsIzES82BODk93w+XJt+siNpapXK2SUfUnv3mmzYrjFjIAdjgm9birrG3rBGByxao1exyeaz3XyKGd3yR6aJ+YRO6jXciATXPj0mHDf5qulLS30UtmsnzXkH0UdTRmg/UtQUD7NNZeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PTRpewhA692wNVIBrAKA6idXZCLZORBf3pVYoW2IMwo=;
 b=drEMLoNCMNktAKI1meLsHWRC2soVDWb++W1T1VK8KjxpdTjo55X0oU7G32Y822NxW/4ICEleaH1eXJ1o6MebA9wDRyzlIcbfprpvLCsucKaD7UsDxZb9U1mBD1ls3mO/3O8gKZGX69jZ5Y9+UcTdJzYUJY2Z8BSoFdqAevQ7S38xPvyYFiH2l0UmCPwsVJtmIJHyKPHmrsMix7WJKIY9yd5YdrCFoQsX7gL3WyhNFnAlByLYmBI8mDGUpjfWf2YUhSLhLbAJxdfmcB/zWgwHIVxbELq+UyzTyC6ozq/B/hmrX6PYmZgYHuw4ToK7VITa1DO6eISiJndqeOVYGvLpEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY5PR11MB6533.namprd11.prod.outlook.com (2603:10b6:930:43::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Fri, 12 Dec
 2025 04:07:21 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 04:07:21 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Dan Carpenter <dan.carpenter@linaro.org>, "Winiarski, Michal"
	<michal.winiarski@intel.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, Shameer
 Kolothum <skolothumtho@nvidia.com>, Alex Williamson <alex@shazbot.org>,
	"Vivi, Rodrigo" <rodrigo.vivi@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "intel-xe@lists.freedesktop.org"
	<intel-xe@lists.freedesktop.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org"
	<kernel-janitors@vger.kernel.org>
Subject: RE: [PATCH next] vfio/xe: Fix use after free in
 xe_vfio_pci_alloc_file()
Thread-Topic: [PATCH next] vfio/xe: Fix use after free in
 xe_vfio_pci_alloc_file()
Thread-Index: AQHcZdvSCot/7x5oaE2SEWi11Yfre7Udbb1A
Date: Fri, 12 Dec 2025 04:07:20 +0000
Message-ID: <BN9PR11MB52767D2993ACBCE536EF09B88CAEA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <aTLEXt_h5bWRWC0Z@stanley.mountain>
In-Reply-To: <aTLEXt_h5bWRWC0Z@stanley.mountain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CY5PR11MB6533:EE_
x-ms-office365-filtering-correlation-id: 80fa9ce9-4e78-44fd-fa95-08de3933f2a9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?hMfZkjqsH/SYZzWFEOYhxVBib26Rqq3bRhb6NOQ6LvOzGEmANRQbbQDnxuDp?=
 =?us-ascii?Q?A46I/1uRhkBswcmVYboBvA0DGo9go5GX8YLm7GWaAWErriobfo1092pc05KH?=
 =?us-ascii?Q?qxsaxjlji02uUWPXC/F4yW64MEEvUBTmmyKWjthjGcZF1eN9Cu961gxALWZa?=
 =?us-ascii?Q?jDzHuJwGaKfy60WaCsDh1LvcApLHq88a2Xcj9UjLOJ78XeAh/bADrKhxrVvA?=
 =?us-ascii?Q?D3OE4FeG7vP0IjNjSLdlyzit1zeDBEOx9H7ATIx5HVInBmjMxKpxN3pUayxH?=
 =?us-ascii?Q?EVfcxAAlK8gQi0F80kJUx8JD7Vtkqw3oFZ5f1VGbNz+yT2D7Ml20sSWnEtge?=
 =?us-ascii?Q?mJPDl8nyl1rrAf239lJC5iUd6QGEC3fn+AkJFPiy/H+AT342s0NPS3hOAI9W?=
 =?us-ascii?Q?KqufzNdDDa6gOtGfLXpuFq45fUTspQFNWB+YxbkT7LAIYrUuflq6iEsMgVW2?=
 =?us-ascii?Q?indy9H2I+E+SG/ZdCCVo2VhwNhS+ph3DOQw7WdI+5xONaoNVSkPenuCaECRW?=
 =?us-ascii?Q?vNLVa+0Qj0nA3zt+d1D/6bLzTTm8ZDZeYhqJsdl7TAsiEjh2QULpMuorU8L2?=
 =?us-ascii?Q?73kT9KctgiFocCuKMLLfqDb+Z3Oajgm+ppwaBhiOcQsTYgJE3SoYZJybtlZf?=
 =?us-ascii?Q?ia1Hqpic6v7qjnwQssj/xwY8FFbcTd9WXx0n0gQBPVWUy1VDQBEcL1rL99lx?=
 =?us-ascii?Q?3k7c3axVVnlUyeAw3NBgcqXP+fh0VkNZp5f/+x9HHUnas6qCEozxCXjWs5QG?=
 =?us-ascii?Q?dwcVJyIi3smkculhjJsnW3sQ41DpFhahaG7656WP8l7xltmhg9a3BjKsbkLj?=
 =?us-ascii?Q?vbVbfOHBJmDImEx0dy4P4KtqW3NPHQmjmTPuEjvQVR6A1esqxkV4UjvemA+d?=
 =?us-ascii?Q?AShOp5EpaAgNbac/rKRTfbUysJrbTUYcefFlcEypFIpQxwdMukyxh10wDtd1?=
 =?us-ascii?Q?ZHip1Wqd6KJftJGGabTlqqqVLlR95ypFwS9Hmc+YjzxcO4WRa5Sb9Y/OWFLg?=
 =?us-ascii?Q?xkB+PROV9cwRaocteCQEuqPOFqSunz04QeA9z3jD0q8KskWM/0SM5pSKHi2c?=
 =?us-ascii?Q?F/+DAlDCKPNUyR0hODXoOot5u7Y3GcpPzwHqGf9dDBigmKkycdQcHJgdIPjr?=
 =?us-ascii?Q?6y4E7PP+u4Vy9XZjfMp7n3K91NFr/TFuF0jWihdZJo+4Ix1KVMc88FzoRb/m?=
 =?us-ascii?Q?G8O6zXyvgaRe1fVZR4oASgOC3hR2+k/N0500QwC2ygjCuC+xKW2/lKLQAEuC?=
 =?us-ascii?Q?AJxOhvSJ7x1c0uPdAYPVRZoCtvxliqBapQVzRrQMDGio8qE24giWxXnsnKdx?=
 =?us-ascii?Q?Ndx9UOSg7dz4/PNOhErNBl4jzO5kis+2xlq8IY3HSP8JRsgbHpScvU2feAGk?=
 =?us-ascii?Q?njN2tYYyTFSh2Uqo6bszmYuyg/qODau6Djnc/+wjB6lHYmPtte8DoX99TWvu?=
 =?us-ascii?Q?ZDmnxGT3FRtmI/OGaXPFu+8GPDy0jUjIwDD+Zn1TYf7BaoFQ5XfFwWRoU/Ja?=
 =?us-ascii?Q?VcoMZwZ/o++MYEpeMe0NoBIweclfiW5KrN6c?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fpIyijiMd4hNRxTdpCQsUkOOnjqMxXk/BAFgNHwKtXwFsItzw4bJqeNbq+ft?=
 =?us-ascii?Q?SJgoPInMf8A3kzroR+lFjn8tU9xP4TQoMgC7Mhh+OAv7h8UVDq/2QhEBdhBV?=
 =?us-ascii?Q?/F/xE1nALzIIyfW9b+UaLGgvppT8layovoEH+26W92bKpBf0+6Nc6oSjBHlo?=
 =?us-ascii?Q?tIAc36hMEmMKfhOjWG/KqxNk5pRhD7Dw2ypRCeLIoagx28XlE/O25ggdXyEV?=
 =?us-ascii?Q?tE3ks38jdQFBmRZkQpFIL/m/0J2d+LXw9qbBL7KwHXE5OAYfSWsf9mSDf8v0?=
 =?us-ascii?Q?7tDa4HOvpMzoZuSM52EMIXgczC9H3NW5x2O3JRdCxwdk1q3VuL3QJHdvnrGB?=
 =?us-ascii?Q?ROLJl2mp0pVq1p9lbrEVBOgfTHdP4DOhTjEsrrstz760Im/oHtzhe63UJJeI?=
 =?us-ascii?Q?0xN9iEBOTvPs3CxdrhOfoFs2NEfzKmdlbuXbwcEMs67ucdRDsuPy1hAl98lC?=
 =?us-ascii?Q?qxisxfIowJ2454BOFBLuFvKQr455C9jsKDSg4afZeVYavA8shpZztYonZeIl?=
 =?us-ascii?Q?40HJd5zsWWJ+OL3kcWUpPowaNAoyHpIaBGoNVpybwy3DZl3HZwf23DLMWlZJ?=
 =?us-ascii?Q?95twHI1/mqMeNdHq6KrQci4OICHx4R+efs6C+7gWWaKqnyYoyRzefULX7XNX?=
 =?us-ascii?Q?twJ9QGUjhjU3w/HREWs/tLkwUGi9PPLjhrTGzv+R3jHra7GZ95X5h5oG4qAE?=
 =?us-ascii?Q?IFv15xScYk+ZzTwJneaMjFplbMkmcWYBSirxV+LN5JbEZNl58gZq2V9dBMxh?=
 =?us-ascii?Q?fCyfHS4LTlzb/WI8UvcpN0iDBFr34RgrLTYTYZk+UKHRekxEMX0x4drYo02l?=
 =?us-ascii?Q?9p/5VaOiJToiqNlChLJlsp4vV+en0PIfuI+pqeYhuT+gVOkmgJNMxHNxAT/a?=
 =?us-ascii?Q?b+yxAIdOwVXNwZ9BsNTp2H0HxXcfhknBTyGrrioQiDWb0FG8YDyeTciDNEou?=
 =?us-ascii?Q?anhK84VHfu4knFGMjYd/19uysp56fFoJ+WSw/kQrFP5p1IFZlgOQWHbmjt9r?=
 =?us-ascii?Q?PCScIjLUi3eVDoi85zhKFuKjZeiXCW5WN8uiotf/4pUeRXAM1QXhM4xhnppd?=
 =?us-ascii?Q?YYqnyi19yT1gTcTTYTkvXUfZisLz6UTd5ILzzlN8BQzseS7VaekU9PvhlU7t?=
 =?us-ascii?Q?EJEHKTtY8Zps4/PWQAiS13chKOw+DnWimvkZ6q4ftleHV3UPMBQZeT73A11m?=
 =?us-ascii?Q?EAaVeRRcGGp09+0eDFoPJOaBZSR5CtGUdxn9nLSsCK9wWpoGFAGklKuKNwnO?=
 =?us-ascii?Q?N82Krfj4gPxT9c7orwZQo1r3fZBF7qeVIi8vtwjPOgP36BffpQ/nzV0xR2S/?=
 =?us-ascii?Q?1A4cokTB05ThRzhishkIfPY5eVVCNzEEVvPnO/GIYqJ6n2VTFJ4WRGqXiTvh?=
 =?us-ascii?Q?AUsvtG41g8A+4oiNRtIA9rczPSBFDfvHHsIFue9s+YMR0SwDYABIhi8hbO9w?=
 =?us-ascii?Q?no57QLAVAnGHZ0YyoW17DTsBTeRX6CSy31fZ+5g9Qp5BQAer4hhMXqBRrdJT?=
 =?us-ascii?Q?rm5fYOktv/16k5nsRWn4pP1L7rcQ0F9pYx6HUi/T5p1yDLQEWLPKN32HBopU?=
 =?us-ascii?Q?LtdN9sJqtXZ99ksdpgxVw56TDHL8dcJ3xaRCy9io?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80fa9ce9-4e78-44fd-fa95-08de3933f2a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2025 04:07:21.0344
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fyTsLYaQby6dyO4OXoSns1NBS1wSRJh7R9JrQtNWM+kG51cVu2NlSOchkQB6CxgdKJj9YFaW1LHhGmoa2+dALA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6533
X-OriginatorOrg: intel.com

> From: Dan Carpenter <dan.carpenter@linaro.org>
> Sent: Friday, December 5, 2025 7:39 PM
>=20
> This code frees "migf" and then dereferences it on the next line to get
> the error code.  Preserve the error code before freeing the pointer.
>=20
> Fixes: 2e38c50ae492 ("vfio/xe: Add device specific vfio_pci driver varian=
t for
> Intel graphics")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

