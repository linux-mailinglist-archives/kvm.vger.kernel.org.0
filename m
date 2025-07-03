Return-Path: <kvm+bounces-51375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F6C7AF6AAC
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 08:45:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 80231188B163
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 06:46:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC68C292912;
	Thu,  3 Jul 2025 06:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ExUKd2Of"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E062CA8;
	Thu,  3 Jul 2025 06:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751525134; cv=fail; b=g8LRhnEZL8lFpwAeePu1rev62A+/BeZmyipc0fvB7x0h+qmguiO6yuf/3QiB1lttTRDX3ra9+sRDNp36EhUin/OJ77kf8y2u16wzeUXMBSGTvU4fJAl8G5qYrdJ76480e6BLHrb6vlbRtS2BD0PPc5xDYdCEt1ISMFG7ONN9vDE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751525134; c=relaxed/simple;
	bh=KvlBB5anPlvW5y2/KaA3WU5LkZxogmlS7xkOqRgmR3I=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UpoSmpQ372+QqgBF7SGq/q+BbR5Of7nbgHJWAsdEh/ru+WqgwT3+P3FFYc2/sOgRprIbpOSez3DCv2rNgdhCz7qSolt3ccZYHPYSDoZ9MZlTWJ7pe5xT68O12zcJXp3+65Ew7O2wSI0MVtGEI5HAMDqKVE+f4HnFTJ0h05YAX4g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ExUKd2Of; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751525133; x=1783061133;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=KvlBB5anPlvW5y2/KaA3WU5LkZxogmlS7xkOqRgmR3I=;
  b=ExUKd2OffrITf8JjwcEci+Y0toVjbiCSTK9R/n+m8pYLhT277RBROT5M
   aVLktV0FjIDknUeMDeJTtE7ErLsJMZk0Ifw7AvqUsQPgPpCb4iVWBbT9T
   bD/F77faUjnz8Wpzj7liH7y6eWXagaXCeUcxhIRzOBiBDGx7Hc+ym/z51
   MbnsjFhMx2KFULijIuOAJdcTSYkDIFCxb/P3lJI/0H1aZQxLjmIWfHTyo
   LMj3hBDBG02M8pir3lkAiM4cU1uB/kmlXUng7F/MCNJOFM+es6OJ6rdqH
   U6jWYFR9Ik8wTZd8fApUAd1YzRrktEl06RHseEhqozRo/3bR34tDUze3/
   g==;
X-CSE-ConnectionGUID: zTpzwnnVQha9dzcthsmcNA==
X-CSE-MsgGUID: LYIyjZQxSzuo6usfZY9iKA==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="53951580"
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="53951580"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 23:45:25 -0700
X-CSE-ConnectionGUID: IyocadCXQ8Smw2Pf4FoJkA==
X-CSE-MsgGUID: ONM5rQ0zRCSK3jOafTftIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="158562169"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 23:45:23 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 23:45:22 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 2 Jul 2025 23:45:22 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.55) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 23:45:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bDQH6B+rOR1sfG9raukXPb/iKAIW2VuSDuEfnuWu0jF7rDmSqW7Yg1hGXBbKHSG5RDJl6PwCDIghCATAF9ILIXnD6426dwg71e28eLhdeBdAZy47ku7ACPp80xDc72HSp6uFsvBnJE2g7QDO06KN+DVlHfdiIw0uL0M39/sBrSv/0oa1I6uit7/EX2sREy/9gij7VfYZMEBHuheb0BSw4WFxsifLuC2+7mg1w4KUCQ3Q4MvThOJxDNq9kiZbx5BvB73KrQjAcyyBdYOdNIYlrsUvgKE1mIHxU4sE2S0AdDLVNPgkad6Zt+uht21jT7LAeqt0658xFsTg6lshBn5i5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KvlBB5anPlvW5y2/KaA3WU5LkZxogmlS7xkOqRgmR3I=;
 b=Vghlo9V3Xzgl2fMryqdi6jftQNhmAN+rIu8p3zAOdVoNEfYxG1cefo2S3UbLaxJzODAu2sTtfsADaJkrQjce3Yk8EfOC5AKqrEkWngUaFEhJ/AwJk/PgnvKQO4OoY7xIVRNHZzYXHQkczwffASYqW1puVUtFTzomvsDV260KSsdXoCG170hY2qhf7afSQ0xvCAwb+iIIL2i2TAvws4p/zpdUOPZx0243YV5aOzQzLjoN9qsqQHzj7Zx6ym/U/L9y0uPOpCfMGiyVZ7ZzGXe8102tB5YUDaCC2eR+XlFMTXyq/xU15iTQLBQP61Qsd1/H+wMw0dggUvKgiicV5Msu+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by LV8PR11MB8746.namprd11.prod.outlook.com (2603:10b6:408:202::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.37; Thu, 3 Jul
 2025 06:44:45 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.8880.029; Thu, 3 Jul 2025
 06:44:45 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Brett Creeley <brett.creeley@amd.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] vfio/pds: Fix missing detach_ioas op
Thread-Topic: [PATCH] vfio/pds: Fix missing detach_ioas op
Thread-Index: AQHb62+zXBkdls2ivEmpK6S+eG4Pc7Qf9MXg
Date: Thu, 3 Jul 2025 06:44:45 +0000
Message-ID: <BN9PR11MB52760B42D0EBCC5CBC04FB068C43A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20250702163744.69767-1-brett.creeley@amd.com>
In-Reply-To: <20250702163744.69767-1-brett.creeley@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|LV8PR11MB8746:EE_
x-ms-office365-filtering-correlation-id: 61cafb96-7d6b-4184-b846-08ddb9fd18f0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?OHk9CBXOnDian8EH2ExvtPaICGwjGPW3qzTDFPcC3UMQqi/6vOY1hkMbhZTE?=
 =?us-ascii?Q?KbCJLlDIyqsiNaizWuma/jwwLogQOrzD8VgfaH27XC8m9yYgRFkmqyJKIYTE?=
 =?us-ascii?Q?PL3sYgCiXu3/HgpN3unLAlmYPTlveiIzJdv47FBPxSAQC/FbUQk3TbdvzdAn?=
 =?us-ascii?Q?NWpGk/U3E1ldn73q1BCkcduYPhH+GZwvbnuKMXyj4hLBdAnvpEJJskrVewK7?=
 =?us-ascii?Q?kmHbTTXpkd4W+toc/CTyBDKqx8M4Tz1PWXs/6yhktT6MyVx0QWmINk71/U4g?=
 =?us-ascii?Q?rAPqb6j65OosNuKvpzItuigrG2boa86c5Qfa1/ah6osTQnZnVhWpWWWwJNmF?=
 =?us-ascii?Q?wZkwPY7UbVpe/LpErBBomM09LBG1VF2g5wgi+MIu+pgtsGeuxXv3CNR3l7Of?=
 =?us-ascii?Q?HlcL9tFsQW5b6qQNwdtwff6kTR5oQ7F9zcRUvtTmzERkRyGpH4NEtSYDcM/j?=
 =?us-ascii?Q?keefxr5hnyGswHRSliAVfUIDf0N6y0MgOhRxFXszOiIqZsBWX5gqEVGSUfVw?=
 =?us-ascii?Q?n47o7sVA0PBdIuB+hvS7FjJd/Y5uQkQHoq4KmLateHzEAw8ZsP8oKu/riMmQ?=
 =?us-ascii?Q?+QkHUGQH/k5Y5qKlLp2mvpsr83miIEf6L5qG4+whX1eDBlwgOPapuJgqzq24?=
 =?us-ascii?Q?06KP2t4OhanclRDVmQqi37oPT/OgKRoD2Tm2roKyM0XJD4vht8z33Tx/SPeo?=
 =?us-ascii?Q?A3L1ZfvnNeJXDgEqQey1GWchgP1hb3ap6I2kefrNwgguTDNriNUqsL0+S8qg?=
 =?us-ascii?Q?yAizEHEOojdfCKic97T2J+6XXIfTioLTww3tjqCqbA+MyXcd/8xI84b1fbxO?=
 =?us-ascii?Q?EQfkFMU7MdM5wKtwqM0uDqdtx0ukucucuocAXC9LhhaG7mK36S5SMDl7imKz?=
 =?us-ascii?Q?PRKWWRZ6BxPuM3r2qRqVmtQpNsZ7JwPnyZ9c7zI855B+kc8MDxZMQ7UCqD6t?=
 =?us-ascii?Q?gDe0LPhN7T0PV/RF4OHh1Ws3/wCve6l5ARH3/mgJrvK5YcHtTRdwYGnjRI/p?=
 =?us-ascii?Q?uwpSEE50h8UYzKGkzXbkKHbBQynxrT1Ziy4aoA7WWZ10upQAt9nQk6ez6ZLa?=
 =?us-ascii?Q?gw/opGGX6Pnrs4sRtG+Rq6cTjhzM2BPcp7fw4lXSlma7iZlWZJkG13d5LfpM?=
 =?us-ascii?Q?/NwKeM0QLz34M8pknKmUTsqrF4v8oJ6vwo/hGVK0aZ8pJOh4QsxZPQdtaJW+?=
 =?us-ascii?Q?8vc91ofYkedyxtNurSLloARnUw81CD/0Xa1eWj+aS5ZVVC24GEZZDjZDMhFS?=
 =?us-ascii?Q?m/cK3MKg4VjoWJ9ErFojhvXPIjmMpAsud/+paQ2Cs+Z3I3B8x1xOn+kugDyd?=
 =?us-ascii?Q?T0NswWqXTHyCWg0uGPon8hGlOWxewn3exF2nro0G4BWjdzu5fBewy+utylk0?=
 =?us-ascii?Q?+F9o/WwjlJ6wn8xbGUcKvt5bFUWDNLCuHqm4HsNqMngH0VkiDcz+ENdGnajL?=
 =?us-ascii?Q?wWHrzk2ruQvT9LVUE34/ZCaqoqbb7acfz33Y7lVl7Xv51nD6fhXxxw=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wlgC7yN8FPRDAQIR0pPZ40x000ibmUu2Xw+jiAiemZ/lw8BOoQ0Bh3O7coN3?=
 =?us-ascii?Q?RCges1KbWiQO1O+TsEpGlPOm1JobH+RKhqbGCgDMf61wSofvJRL18VGJDl4W?=
 =?us-ascii?Q?41VtZKRRF80kGLhy6ud36nL+Yggxct3hmy7+hicjIr8dFyGp14IZhCjOorF8?=
 =?us-ascii?Q?fblUjbRPzIKXxNei9pTeIgOtBP9OuqOH9CgVR7U+8fXRKVhuGGNRaJ++OLj3?=
 =?us-ascii?Q?UnwbA78Z/JSKOzSAZZ9Ie/Ur1BZ8g87jBEe1Qq9eZ/VHWh2OoZ1ViQ0rcLlF?=
 =?us-ascii?Q?ugI8unB6ze820DcOpFGJ6Y/ZSfKXu2EnrE8pq3vfXUXQrJn/lhHeHw+4VVUu?=
 =?us-ascii?Q?Bu316slLsDVc0Hx6PYr4SODNmHEX/31L4wM59sPbUz/dZHu6CmtSEeeev8ar?=
 =?us-ascii?Q?icp4exbUYxDp7+HVOrc7fC8LTYpRFCRMzumsuGG1Q+TYgIfSlnBbgCch6tot?=
 =?us-ascii?Q?IMIT44uglG13KZmzd0HoNlPqka45qfjeKaVGGyl47WR7Miukv4FZORiWNPEm?=
 =?us-ascii?Q?XR/Kxicua8C6BfTEjLKTtZon1Btlw7TW7MsN6lVPCGCF5xkRczuJ6BbKECKR?=
 =?us-ascii?Q?TwVdZ3qweaRfBu8eNgb4ujhhA9ZnCAnMmBK0qwJskpA7gikMxXK7Mdw/8JyB?=
 =?us-ascii?Q?SzK/oxH+qG9JajHNBuVfAvWwGjUjwksPlx7u9fTzJDSHLeiD0WiF33s8YMCl?=
 =?us-ascii?Q?qKHPULqVaQ89SIL/UVNuBjjidsJTYNXE8jcmdadFfwCXyuoGqZ1+aUPXTuW7?=
 =?us-ascii?Q?Xt/YTXCSTlU6zyTsgaf/tPpFKmPtvg4F+YBYZgpJOSBSJScm8EtRapfa7fJm?=
 =?us-ascii?Q?UOQJKl+rNVHdnT49dKTBicMk8CpKn/7YfmjWhjB8unEz5sv+zC5mgtSeOI1L?=
 =?us-ascii?Q?Ku6jH9Iw6pNFmqDDexkRZh9/5q9ZdvmOZawHuMtfFb78LFh3RUK5aVjo9zB6?=
 =?us-ascii?Q?Fy3Kj9poDojz7df+V7TQ/n4FY7PcFq2YvGcYyqvCTIYb6UhNgow9EcNQklmJ?=
 =?us-ascii?Q?LCCJBGqhcl4MJjNc6Bamtspkl2jdug3C7NwRcypHxKXksG9HM7L8IscxbDGx?=
 =?us-ascii?Q?PWyyjJSz/hj9vwKsOpdRDkQ3BUwUgXAJf/6sH30cSucYPAHgVvE8aQyWRPkS?=
 =?us-ascii?Q?tnqsyrGNbRM5UVNUzIGFNVs+vPJkcQR1cBaeLCQaff9MJbFREHmBkepiQe2r?=
 =?us-ascii?Q?WNZTtK1s4iw5ag2nOC/u8JYWkEXb07bIL8fQowaXa7T5PT9ce/Ypp7z5l3sE?=
 =?us-ascii?Q?/QhHXgQV61FEf4z0prJx+eeEX6/QpU4DeZDa4FkNxO8qtTu4xZvQkQzLK/Jt?=
 =?us-ascii?Q?91JaADSYy2M6woBgiAv2wQJQGl6uir98V52eiEwO34i990gJg8pOgoqKfv7I?=
 =?us-ascii?Q?/g9fTfJ1dJPj94fRHmeJNCdvV5ZLIz1UJqaYNKTrYxgR5TTjeyodQQXt21R6?=
 =?us-ascii?Q?DAyJJlgs2c0xCAaXSeCMXPBnahUrRU8aL8JKujTntvJ3h2aty/x8nntGVTn2?=
 =?us-ascii?Q?35Ap4LhwItKsoy0lgHJCDiOkjYAKDUhYPQ5Sr02kOBCED+BCyUJ5AWZLuxTA?=
 =?us-ascii?Q?sKWhB/yT6lldPuUBMzoMvOkfk25QIdvNbpZEGBZa?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 61cafb96-7d6b-4184-b846-08ddb9fd18f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2025 06:44:45.2511
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IGyXRVJN3pHt8t6wS+WHBrqqZagZJnc1KRkDGlGH1sb/mVbTXNTuSpecLbvKqlLfYEBpwcyx8gWWLiVrgfD/0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8746
X-OriginatorOrg: intel.com

> From: Brett Creeley <brett.creeley@amd.com>
> Sent: Thursday, July 3, 2025 12:38 AM
>=20
> When CONFIG_IOMMUFD is enabled and a device is bound to the
> pds_vfio_pci
> driver, the following WARN_ON() trace is seen and probe fails:
>=20
> WARNING: CPU: 0 PID: 5040 at drivers/vfio/vfio_main.c:317
> __vfio_register_dev+0x130/0x140 [vfio]
> <...>
> pds_vfio_pci 0000:08:00.1: probe with driver pds_vfio_pci failed with err=
or -
> 22
>=20
> This is because the driver's vfio_device_ops.detach_ioas isn't set.
>=20
> Fix this by using the generic vfio_iommufd_physical_detach_ioas
> function.
>=20
> Fixes: 38fe3975b4c2 ("vfio/pds: Initial support for pds VFIO driver")
> Signed-off-by: Brett Creeley <brett.creeley@amd.com>

It's a surprise to see it caught so late...

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

