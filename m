Return-Path: <kvm+bounces-39230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 78030A457A5
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 09:06:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A50E166B2B
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 08:06:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09D7315B980;
	Wed, 26 Feb 2025 08:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bEgk7iqt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6787A258CCC
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 08:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740557190; cv=fail; b=hG6905cEdDHbhIhs1Yd/ODWuHpeY6xl0EXszq9UU0AXd5H4p+FAirRSNlfP2heHsrICw8mErj6D729TLNE1MISiyT6D5Cbq4kM0hErfYiKTJmMOwhFkSvFgSenC4NnSfGGVXFH2kZlk63Z43E4mkh8iH65W2KMwMmWxBV9BMsfE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740557190; c=relaxed/simple;
	bh=etWFaFxiZXGHlxBnM7PXPhSmfDvalO7lJjLq8vryacc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=F5phX64ZCkBZE7fhGee2cxH788oaUXq6QickDyOSiNQuT+ua7+mGtIyHlyUSyBaACNRAVHIC1fmAPWyCk0kQcom7mIApCfu9QjPGGXerNoAsLcLgJzlVz7EZcEBXHriXjksa8gQmBU3Rc5VTnvsuWfaozXLkKQI2qjX+DQXOMsU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bEgk7iqt; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740557189; x=1772093189;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=etWFaFxiZXGHlxBnM7PXPhSmfDvalO7lJjLq8vryacc=;
  b=bEgk7iqtEJHfsZMcdoSzSWqNXYNeSK/3qQI1+JEdby/pmzZcRRO/mEat
   1UA3gA6A4fRGYGWmkcj9Ajt/CE+rC5yFR0D3+aDTABr/U301Th1UfQjUa
   f90FgOaYKS0rNLtAsGtpTcWAZoDYIVnadKLMR8CWkYvZHGN2/Jj5mCMe3
   aoc5bPDUUs1dmwcf78EeRRfCAk+7sLlYDxVGR76/kFVwWMCHX1UeP4Qhs
   yRZT5Et3hiIpb6oZIzg1d2J2eMuFKRE9VKNImCqjMCO6/JldTKxiORJ8S
   nsLkgxoQpeRCSGJTRl4fArN0RRzlF3QXeJQBdQbMK+/LaJOXlhHRgE463
   w==;
X-CSE-ConnectionGUID: pHjTY4tSSaWmZRqB7o5sZw==
X-CSE-MsgGUID: 28GcDwp7THaTBPifzo37VQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11356"; a="44215808"
X-IronPort-AV: E=Sophos;i="6.13,316,1732608000"; 
   d="scan'208";a="44215808"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 00:06:28 -0800
X-CSE-ConnectionGUID: jAAEdp2/TSeRBedcHZIQEA==
X-CSE-MsgGUID: RYCAFtlTSo6Hq1JPlw3O2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="116485287"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 00:06:27 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 26 Feb 2025 00:06:26 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 26 Feb 2025 00:06:26 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 26 Feb 2025 00:06:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yD5HOtqKuPr2CZ3key6QNu9L86fu5Vxdxjq7JkhaN1gXHavb0PsII1DS+Hjl51zoLGOavEllg0kvfpkYeGuBObunhhHOIngVx79mLkszxiWRVdOESvnY99ne+hLZGCGKkMD4sIlg/mNNknr0M5zS+7xDhoNhRcVeMBWJoEyBrrLH0nkP4FrwMJTWuzLGEeLevIt0gSJqwq8NZSO78wIdBSrb+pfLTxUbe+gxec1abKkgzXCQC1ReSl4iDA1ZpSvkIWPW1ZVvoQS3OvUjjAgUPd/Fo8Wl5BFbocKL5GpikUjZOcZN3kIMOMAE/GhQiSw6sguUZuK0izWNY3m1m5DMLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=llwBxc3YukJbTmGeyOpZHHIEMWKAH/1jMyYS6h8vves=;
 b=IWBN2g4XpMe728lpvuzbuLJlLGSVK6NwneC2OeOccEbVxoZ1VAKOjR5kPqsd2RJS1jfz47Hes/TJRucuFx4sxOeFy3Byo4vfvhYpkUuMgfJq6uqScEBA4UNSp2MTk28YHRI6s9OlcySzQv2L/8PLRJOA0BHlfXoq+z/8CXqYx54qwTS3IxfNbsoLlwhDKfHH0QVfTItQz/y9G8YXTCtIGD7Q3NtqSOMT1BGno4dkQ5ZPy16C2GUYqnoKW1ZbNadZNZhzeVNQn995mkA/y2J/037pnZc6pde/YCXaXFE7HDvv+b5pco3Sz8/tmydJPr2T5IMeUsjPzWL1QUESMJ/Hlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CO1PR11MB5185.namprd11.prod.outlook.com (2603:10b6:303:6e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.21; Wed, 26 Feb
 2025 08:06:25 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%6]) with mapi id 15.20.8466.020; Wed, 26 Feb 2025
 08:06:24 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Yishai Hadas <yishaih@nvidia.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"mst@redhat.com" <mst@redhat.com>
CC: "jasowang@redhat.com" <jasowang@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "parav@nvidia.com"
	<parav@nvidia.com>, "israelr@nvidia.com" <israelr@nvidia.com>,
	"joao.m.martins@oracle.com" <joao.m.martins@oracle.com>, "maorg@nvidia.com"
	<maorg@nvidia.com>
Subject: RE: [PATCH vfio] vfio/virtio: Enable support for virtio-block live
 migration
Thread-Topic: [PATCH vfio] vfio/virtio: Enable support for virtio-block live
 migration
Thread-Index: AQHbhrZYFkmSOD+lUkGgOFaMskgigbNZPJPw
Date: Wed, 26 Feb 2025 08:06:24 +0000
Message-ID: <BN9PR11MB527605EBEB4D6E35994EB8068CC22@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20250224121830.229905-1-yishaih@nvidia.com>
In-Reply-To: <20250224121830.229905-1-yishaih@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CO1PR11MB5185:EE_
x-ms-office365-filtering-correlation-id: d1d2156f-d47e-4bf5-79f5-08dd563c76eb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?7pXjtfVBfCQtTIQcAR8p9aFXCxGd3ut8CJoF+bwEtXTLRkNwpiG1PJM0GdCo?=
 =?us-ascii?Q?LnX7YPoXfSP+0HbNFXbtFqQxkk8uL4881dI3R3wd2yQRqNB/uX0pgSJyS3Lm?=
 =?us-ascii?Q?2isNFJc80mUs68DCXu1UMw6n0YZ7AllrcxmlkTPlNK1IQmk/om71PrIsAEZ7?=
 =?us-ascii?Q?kOCMXUad4vt+LmOD1cb0+UzJdJsMc5xd8dudSTzl25V8bbwv2TVfxyBuIz6S?=
 =?us-ascii?Q?cyouKgCYvA4zqRMw3TO4VEif6y8NnoE2FT/r5YU3uA9/7AuH54I4soMHxnjp?=
 =?us-ascii?Q?RFKT5CsnT5yHTmO5G5O0JJBU8hG0A+8NJVvq7437q/1G2UCQ95eDbb44A80Z?=
 =?us-ascii?Q?EFPZUjoeEVO6QRb0tdRVNH8xk5MmNkrkX56804bRxBjQCS3rfHF7lw0v6pC6?=
 =?us-ascii?Q?Gqa9+NM0b6oapf0wZq3ZY2G8QLtceSAIclB/6xlZoJJpv+IvOwuMVBKViLrR?=
 =?us-ascii?Q?JG5Z6u2Aj2xBQaNQnDnMJY+z34+HASVLHeNqMmj8J1YaTIzwZtOnq2TVQa7L?=
 =?us-ascii?Q?g/LdKM37Jn8Z7s7Xdtq96CX/v//r8Xu0KpnfHWRk3p/djPqIveqLlvsspKLG?=
 =?us-ascii?Q?ut9cgB3OaddAiwUP8QreV65EEnU+j1VeuK6JklB+IibB/S9UuZ+ff2knQzrC?=
 =?us-ascii?Q?2us/GPCvuxnT0ZpJA20hXaeskPVyby1Ie1Wu2odZ1OVSjfnEQcQYF6gq9slD?=
 =?us-ascii?Q?bPUiV+1iriHwsfnelrRhcOjekBbHJyWhG1+L551LPfNACsbnOVzPcPaENJ2M?=
 =?us-ascii?Q?hBha5J5VME5cKSbC06x1voZpB9CdScLgxUtQFh3lLLzLr36yDX9PBqUauiIJ?=
 =?us-ascii?Q?/e+hg8LR52Mgx/oRTrZxwDT5JSqv2uaPAZVoZEeRVvfWK0vL38jZhf8jmoCn?=
 =?us-ascii?Q?f5iYyWTn/UxHKG6Cf0jx9G418EXQ+BkTL3zGYSI9nNDnBdntKYajIQVjGgGD?=
 =?us-ascii?Q?2KEgFMxUlyYjozMxYSjYB+VbdSHgR6Flbp8MqbXuGwdxzjN/coP3FjatHqKC?=
 =?us-ascii?Q?UpOycaMG7ZQgvCxvUgDAr8Zl7ozPJd7Yx+aH6XC8ENBWZHPeDgMzl8ntw6zN?=
 =?us-ascii?Q?r3yc5Pp+FVXP/LigMM2y8yI7uP74p4dDL47GaoZPSGLFbBl8WHRYQYOROAfK?=
 =?us-ascii?Q?xOUCZDy02ipRaTaXECjU/VjR6o4QK6FTXgdOjrqcuXEPlrjkME63tw38KryM?=
 =?us-ascii?Q?PlrpZYuZ3GKhMMZ3tHtcmm6GKOnkn0FrgWQ9HKlfBxQc+AeNSTAPsoYObqxp?=
 =?us-ascii?Q?qZvRptZ/d4OWzU1xzGhiUCFBpnxwwJMWOZopNEgX0Upkzuip0HugyGK78Siz?=
 =?us-ascii?Q?VWEPqu2ps3nVk47svwc/FaYeSJsV2HJN+FgirYHzCOcRVbv6CHoDsmKcPexh?=
 =?us-ascii?Q?pjYvSHw0zaYeoPyGkOcM0lBAz/BpC4nIDWqALL8IadarP8RXo7CrT8W90i9K?=
 =?us-ascii?Q?yEbRIG3yr+4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8lsyK/0OLWdt7NJ9H2i9IYVSKCn+WbA5Hp5YKvo8wABYBSYxZLil8KkZn7xr?=
 =?us-ascii?Q?x8xaU9PdANP/lceXtU2um/2hG/3h2ZjhXQ18yqCfhHWW4Gz3EAS1EjfWJjys?=
 =?us-ascii?Q?6zPX4szfmaYREd54PPjUkUw23jqYcNY/zZN09BXpV0b/k4aA+x54k7Lvl+VK?=
 =?us-ascii?Q?Mwqm2niCL+8UMiphB16Z6UmW3Teqbb9YYEg2qzEPXk+cyA6fwisE38N4s94u?=
 =?us-ascii?Q?GbrTUdVxN6uYYuHN5sLp15ER+QCPTHodnLDY2smC0TJQGXeUGIPQbkgz8qL9?=
 =?us-ascii?Q?KunuQkPfZkBURq+NOu3cID6tXbSU4gQs8LIr66HdopsNqZY3MLi5JAEGqr96?=
 =?us-ascii?Q?kRkmFkcsKUR58VRsl8tdBz38ViW2T1jlEHDBpmuf+NO9YYeBoQCzQSPz296I?=
 =?us-ascii?Q?V3+I9oRv8p/vL85ZybIRwjwuWAS2Hv/rPQTBlWSKvTMOsszjfEsUYfeg1fMJ?=
 =?us-ascii?Q?4F1W2urvRiU0llqOmHPJblt7M/StM3Fbh+rNdLyQLWgUe83NMnY9LRG2fIjY?=
 =?us-ascii?Q?sCez2Zj2xTrNOe+jUhYUOM/Bi0jZXfALnC03UD4CPmUzWIJro0UdpTkUf/Q/?=
 =?us-ascii?Q?GnFVQcoI4RJ56b/r5Iig4AklHseUYJGLppjyFbOKhi8knpHAEXz7Q/vRWwK5?=
 =?us-ascii?Q?9hHdJFnlcX25AhrS/afhXP7f5RjsxHUXUPW7VjEJ4UZTVhmfMOEn0THtvM1o?=
 =?us-ascii?Q?whNQR330MZkHt0xG89I+xSQsWrMn86LehaAskyFpiy0jvq/TUxw3AX99Vhs7?=
 =?us-ascii?Q?Xt2cyc8ZbygsIfsM30/Qt5TnqdbpNVCjjXIHKFeGMfItoQ/9fqIso3GBH7Da?=
 =?us-ascii?Q?p7wWE9cf4HqkZDy3wQNX7rdIMZi7ULXKkkrGjDBerhOaAuA1x07XCcvlg6bA?=
 =?us-ascii?Q?4sRpPCYDqG/cB/Q8F3FzpMozMZlVmRfLFLZSUqEeVBWqH+ncy9T67mrF/WbU?=
 =?us-ascii?Q?0ffKhEaZ9LWvWsuFkdQSGQmgfjTFsgw1E2G60UOHAdaX9tGAACW/bdJWEhAg?=
 =?us-ascii?Q?1SpX2aScgu+LS5ZEjVOf/e0kLxl2xaC8IUmPv6VMUjFliKBEyvcI1exWfSho?=
 =?us-ascii?Q?eca0aU6m2TA6h+Ua/Qy0shjjSzANWps4XHzWGLthqPmKUiN9HAHrxIeLBgYR?=
 =?us-ascii?Q?+OghorFbPt8d/Qcs2gjZVIPkB+6S9lISLFVwMW/X+aZpTLXOsuE/gIX02D0l?=
 =?us-ascii?Q?1OlM2uJzJ4oBVBcc3ZYoH4ztrzLCdvFNjXAlqg24HLUD8sT6B5JTqChC20CJ?=
 =?us-ascii?Q?H2qkOdw4ClDCsyjXIEmmS37oz/U265Vx4jL9e4FI+zePZq5pQsbiC+gZROTc?=
 =?us-ascii?Q?b+r/KE98UO7Ix5wHhI9hem62ij6SXArWzKdKFWT2gOxRAqkYplpafItfLmRK?=
 =?us-ascii?Q?shFHmxHMum4T+Aa4gKyH8fwGC41m0dCjk+nglUrl6U8OOegjy+zsscmedc0S?=
 =?us-ascii?Q?tnQ4lJqzNM8ZQ+4+o/SEZedCeXzcPPgkZgSXvNtaJd6tQ0AkOMB1o9maFE8A?=
 =?us-ascii?Q?CdzwqnvRxcwpWEHC7/rJzIt6GtmMV/QgqEm4gyZcRJ3/DR9gOKe7UJxv7vqr?=
 =?us-ascii?Q?YXW9dLnbPgg2KoYyrV7NO4JkYTG/A6t0+aXay9wC?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d1d2156f-d47e-4bf5-79f5-08dd563c76eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2025 08:06:24.9306
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8ZOcptHuOp3TC6Xec1L/rwNGQGdtx+tBX8yMXXeyUKEnvDvbnHyIzzpPSDDsMIvzS0NHWLYHDebPV97koh8vlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5185
X-OriginatorOrg: intel.com

> From: Yishai Hadas <yishaih@nvidia.com>
> Sent: Monday, February 24, 2025 8:19 PM
>=20
>  config VIRTIO_VFIO_PCI
> -	tristate "VFIO support for VIRTIO NET PCI VF devices"
> +	tristate "VFIO support for VIRTIO NET,BLOCK PCI VF devices"
>  	depends on VIRTIO_PCI
>  	select VFIO_PCI_CORE
>  	help
> -	  This provides migration support for VIRTIO NET PCI VF devices
> -	  using the VFIO framework. Migration support requires the
> +	  This provides migration support for VIRTIO NET,BLOCK PCI VF
> +	  devices using the VFIO framework. Migration support requires the
>  	  SR-IOV PF device to support specific VIRTIO extensions,
>  	  otherwise this driver provides no additional functionality
>  	  beyond vfio-pci.

Probably just describe it as "VFIO support for VIRTIO PCI VF devices"?
Anyway one needs to check out the specific id table in the driver for
which devices are supported. and the config option is called as
VIRTIO_VFIO_PCI

>  MODULE_DESCRIPTION(
> -	"VIRTIO VFIO PCI - User Level meta-driver for VIRTIO NET devices");
> +	"VIRTIO VFIO PCI - User Level meta-driver for VIRTIO NET,BLOCK
> devices");

Same here.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

