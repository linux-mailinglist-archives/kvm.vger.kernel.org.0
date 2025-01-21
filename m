Return-Path: <kvm+bounces-36079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 22F10A1759E
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 02:21:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 527D816ADEF
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 01:21:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 843F75674E;
	Tue, 21 Jan 2025 01:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UABcIivX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F56D20328;
	Tue, 21 Jan 2025 01:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737422456; cv=fail; b=Hj3VVNX2CdDNf+luXgPjM7YxwpaPw2J2mLdH8xFyPYMCdPDqPk2Sfi8ITw8hH0ibeQ3ZLbfj4Vqt0Kqfzmp6ssteyvlQsbvhy+FMb67/1B2wYTyZUOcPYnd+q5fh26C0LEF3ymIq7t1xuqTDmz6ryI5BW2XTHf4Fw9RTgAm4WI8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737422456; c=relaxed/simple;
	bh=8qS0hzMOPrvuzx335C3t8MwcJ3Ki1pgdKEu74wNfPUA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hTAp4OKG0h1OaxBx65aI14WHfxniicwb/YefMuckAGPi1CNd2qJps2o6qMYJ4aNBHvuJoQU0RsNgVc2Mh5T7TJx6daxIsxsUIo6mKKAuf2w85Hhv2X+YWdSriGY+nG/cwFuefQy9kHYF2zgKQ24K/HtS/5hTDVWLE6871AYel6c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UABcIivX; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737422454; x=1768958454;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8qS0hzMOPrvuzx335C3t8MwcJ3Ki1pgdKEu74wNfPUA=;
  b=UABcIivXby8QRsY7tdMEuCEPJsKQbRb1f6lbG0NlCgyFhYGojpgH2gTs
   TiVItqYsCSphmc/YgitGF2207rC+iG9oJb0g3xY/Tw8t2cPtGPqG2ayUP
   BAOci3aTMLJT1pu9dEX6z5pmClBdMzFI60psJ4axtdvozyj3QBFLzc7qK
   Q6qljMVwkpy/MaRPzA5AbqZwOIbrgbNxiGSrVFsI7ut6HlEWxDDDZUvMo
   OjWxE4oz8qD00n0BEKY6JFILpaQ7v3JDCsJ0X0eZieus/cv023Jx0bJxJ
   lHpMHOWvze6XmyyqLTdAfjhQdgNzSZTW+AbDgOjjByN4ASGcW5iUfURD4
   w==;
X-CSE-ConnectionGUID: SQu5hhEkRG6ufPFQz+RGYA==
X-CSE-MsgGUID: pD8FIRSIS5K46UNzC5l4yw==
X-IronPort-AV: E=McAfee;i="6700,10204,11321"; a="48411546"
X-IronPort-AV: E=Sophos;i="6.13,220,1732608000"; 
   d="scan'208";a="48411546"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2025 17:20:53 -0800
X-CSE-ConnectionGUID: xOxt6sR4Q7K5xkPrI9sb7g==
X-CSE-MsgGUID: 9CFf2pYAR9ygvY+O044lqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="111628157"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Jan 2025 17:20:52 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 20 Jan 2025 17:20:52 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 20 Jan 2025 17:20:52 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 20 Jan 2025 17:20:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L3g5w183pw501pPrZot+eDLEcUdrJkvW6naoCHhESCsEK5WPF6wAzyZa9UfqxSkFTD7inR1NejbwdDB7Iyki7ZaibgA9yeAr9i/nPTfYEZrBUJK0c9bPU2QooDgm/4jPk0GOsxSwLMacbas4T+/t8NHzsAPH68Kf6gmrW7mRCce8lJo2+Xi+V4wsOrR/SohKZDild0TOkGm/Yq0AV/RsV0OaRjz6Tve8iPEdXDUFu3nlBWsM78iGkVMONrSyaPwwyH5GDQ7CmBBvyO146FG/M8O0LhkcjSEwr+UCu4xSojh1DTdexA3ugxJG5JHyuYumib+iMvErHYSmWR4BARZBOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8qS0hzMOPrvuzx335C3t8MwcJ3Ki1pgdKEu74wNfPUA=;
 b=Basj5aQiQOjhzJwoQaCj3U6BpSLmhXlDey7C8x/HoH2OAeGZSEmfRF8tZoLRi5r8NkXKwHZ4hzPAd9o9DlT370nTAO5HiBY3PvI+rqi1IdL90EkC2vQGUf9LDaDNKd3w//iQXoFyIZksix+u9IvUI4QWfqoKeq12w6l5UlHuEx4yQ7rOjXH/V6ULBRyEyOrW49TxsA43pMQ6zdJE/7MTw3A9cwB5puvHnc/2bg/omIT5UgpQaeob1N86U3HKUgDMc23RGOE/iabfJGiw5SwbCSXCnC16lGlZodzcRHMeN5rB47Dcw7hAM7maSPZCGl/eDT7XyJ3XKWHr+mrFDs0F+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW4PR11MB6690.namprd11.prod.outlook.com (2603:10b6:303:1e8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.20; Tue, 21 Jan
 2025 01:20:49 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%7]) with mapi id 15.20.8356.020; Tue, 21 Jan 2025
 01:20:49 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Ankit Agrawal <ankita@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, Yishai Hadas
	<yishaih@nvidia.com>, "shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, Zhi Wang <zhiw@nvidia.com>
CC: Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, "Kirti
 Wankhede" <kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)"
	<targupta@nvidia.com>, "Sethi, Vikram" <vsethi@nvidia.com>, "Currid, Andy"
	<acurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John Hubbard
	<jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>, "Anuj Aggarwal
 (SW-GPU)" <anuaggarwal@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 1/3] vfio/nvgrace-gpu: Read dvsec register to determine
 need for uncached resmem
Thread-Topic: [PATCH v4 1/3] vfio/nvgrace-gpu: Read dvsec register to
 determine need for uncached resmem
Thread-Index: AQHbaTjJi7unwSTjxEiLWqb82xzZLrMfQPiQgACmfwCAAItd8A==
Date: Tue, 21 Jan 2025 01:20:49 +0000
Message-ID: <BN9PR11MB52769A516C5C59325E4D307E8CE62@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20250117233704.3374-1-ankita@nvidia.com>
 <20250117233704.3374-2-ankita@nvidia.com>
 <BN9PR11MB5276B46605C1C15EF39808098CE72@BN9PR11MB5276.namprd11.prod.outlook.com>
 <SA1PR12MB7199773CE7D83F39479EB2C2B0E72@SA1PR12MB7199.namprd12.prod.outlook.com>
In-Reply-To: <SA1PR12MB7199773CE7D83F39479EB2C2B0E72@SA1PR12MB7199.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW4PR11MB6690:EE_
x-ms-office365-filtering-correlation-id: 01935df4-1797-409e-da5d-08dd39b9d6fe
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?iso-8859-1?Q?qW7BtX4cE87qX9hoJW918N3rjuV/0vv3c2iYv0cqiYOB0hx70w+Q5WYhhE?=
 =?iso-8859-1?Q?5ns0cBHYtmqmscLUkqk3QZBN1711yhPDvH8GoJTrxu5QL1ExjWOgw4NvLb?=
 =?iso-8859-1?Q?E5q7H49VoqnrOUYqtsilcwAyiO/15K2hWyClZZkbEsdtW12NYVCxHdc6pG?=
 =?iso-8859-1?Q?TNB9WpIkqX+f1EaVOEA11T5aiM5q6/O2ZPKOQ7t2Oa7gxYlFXFhWg2+MKw?=
 =?iso-8859-1?Q?ip0ABAQ4w3GUwgoEX9nTHGKoNexYZQuo1QsETnMY2M+QhDC77AEGFeQ0iW?=
 =?iso-8859-1?Q?JKqHHAwTeOhrLNwPLD9hiBqxspR1TukrEOFtuOiskZL0XYHvbSKuEeaaMW?=
 =?iso-8859-1?Q?1i5RTP4cHxAeVrt0IkFOBQGsiYJFnaKKtFPgBu8Oj+ZaXc+2OzlkpNnmkb?=
 =?iso-8859-1?Q?92/2RuMHLLNjPu2tnJWew3SmODsvsMhN4O8V2ujfazWrPVeArwwcivsWnt?=
 =?iso-8859-1?Q?kzvmtGLK/J+5w/kJ0sgXfx/btPJqBjPKplMuy3zpiF+ABKD3u18ud0XPLN?=
 =?iso-8859-1?Q?9x8JbzCj8O6FkuugBJPaF3ZbZGSokV9yP3RXvv43BwThY7UQ7ldbOSDUzw?=
 =?iso-8859-1?Q?K9Poap1HIaUJeP9wjBZJ/406osIyI8J9VMH46MKJS0VO2o3+8vZXyx4vyp?=
 =?iso-8859-1?Q?+CVxfMMcojnAtQZ2cgHnAKDQzCPXJD7Lir45fqSCmbpVudAqfcxJdN6+Vo?=
 =?iso-8859-1?Q?oQnvrKbhHEivtbp9MuyDpqcMJPddJjQwNkBEIb8/sg09jx5dnePCoUMfsy?=
 =?iso-8859-1?Q?n1OF9EnZoavKAFMGnlTGkOebKiPDBBvc0nVxu/jJ5vP2qfU64rrMQKZgv5?=
 =?iso-8859-1?Q?aB1NgMwg7AfwVQk/TQrcTvZw1z/bjlrT+6X42Kq4lye6jj5bvr5Dhvs/R7?=
 =?iso-8859-1?Q?fL+JWIhGScQi5xNKcYb941wg0PXMZ5GKHfiPYV7iJQRZhtWXOVkpW5MOWR?=
 =?iso-8859-1?Q?QbMfu1+d9EYJNmCagQ857PyrxfPa74073z7xywZcB8cE6F2cVC22QNEPhs?=
 =?iso-8859-1?Q?XuomvRUYo7579r1QN5uE4y0OZTdNLNz4i4PpmVKctEY2Yl1sJHdCm3gWFQ?=
 =?iso-8859-1?Q?CGVeRqcYED5c9ONQ/pqt/k0Mk4HwDdaPnBZTHS1ooA1naKrQ6QN5ZHcjim?=
 =?iso-8859-1?Q?/+psf8Wzvq8YAU3fYO/Y5tFAgDYPq7VP0P0sX6XGal+qUYtbdGM9qnilgu?=
 =?iso-8859-1?Q?wMA+/3uXQ7NghY36lftmCuOWC2eR3867MwgdeNpeM5CeiXLLUhir6Aju8m?=
 =?iso-8859-1?Q?VaDhjFWTvwaVW1fJLGLO0+FXxzfijJXu+axLs3gUkJVZ0vtuo5Z0g7f0/q?=
 =?iso-8859-1?Q?el1fb9xdyPpaKWAdnAFvv1Ic74HpE6q/o64wU0GO+gNmfMcqpsejxOuNBR?=
 =?iso-8859-1?Q?bjeYHFT/8bo1HkGEql9af+T/e48jOTWHmc/DV0BFenL92c14X2q1Nwdtpb?=
 =?iso-8859-1?Q?febrc4aONK0S+LgRCXN50B1MZmpElr1raF48Sq/35N85pHGJTWyoyUyeWH?=
 =?iso-8859-1?Q?2E7hX1SeOH5e1qfAaPrPnf?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?VM/T9T7/67eP37pMDpSk4ECWqUzUKzVWFO1zyj/OzMlECRPbt8Drh1e6sN?=
 =?iso-8859-1?Q?0aH+qtAlc1ZxiKLJ2et3aNVqTCyCMrbiWKDzcybcCW7xNi1VL3BSA1pDNB?=
 =?iso-8859-1?Q?5PakYl8dz054toR6HVH5A7iINcd6ZHC67h9bDPcvmiGYqOauPuzDFM2NvD?=
 =?iso-8859-1?Q?ZI19jHZUbnn/B7GYgg8gppQfvY5wHqQXn9lieEvgu/6cerlvxYOVkh9so1?=
 =?iso-8859-1?Q?MhQjqiBTvSiqKdH5VRfodJpYAKMO56Dio3gDc8PTV/f0JtcOwTAnvttVLl?=
 =?iso-8859-1?Q?V1/RGcic3pozXWwhRq2azgBgZ6QfKOOWL9zZUaOr33mmGucXUbaflwGHnq?=
 =?iso-8859-1?Q?5J8tLLEt7smRS6+KTL79WiMocVh4J5lcZHMDDhELN0PBI6Q7jiesPXALus?=
 =?iso-8859-1?Q?ROA5bF/IeAEE1KTEmKu4/MTbr/SxWGgu2yxoVeCMHzhRHr8wPD3Z4BRJMh?=
 =?iso-8859-1?Q?oSLZkRew2iE27RtrPIiFxxmpu75UUg+NoaBhPmvCAujQYQszLVB5MS3XAH?=
 =?iso-8859-1?Q?gPEKH+JHsfyQNHRHS2/XPEmF+h0VXfSaPF/xMd0kf/Rhkr7fmeddlAzDMm?=
 =?iso-8859-1?Q?fQfzcCR9NKEAxqU74QHSHocFCkHuniFtnzXpJb/oQWmNxMTd37zcB5GRdJ?=
 =?iso-8859-1?Q?7194SPMBFMxrxyyxAJrE7oWZsepCUOCZzhRYD2nugkVPdJWUNPsmRASLF/?=
 =?iso-8859-1?Q?1E4jMG1wiDzCkBnP2VOvgbxmDOirb4wiNF7V7BNeZeUZQZr/wsQrtspvNG?=
 =?iso-8859-1?Q?mX+areUJwE+ZQLz+yhv9EZlOsMj27YUsQw3dk86wQLPSQjEZ//o5h3E6ED?=
 =?iso-8859-1?Q?pexBCrJCUX8MImKKqB5G0MrHp+7t03rGKs1AyZ52lzSbFfEl4JoL6iUO8N?=
 =?iso-8859-1?Q?Wh+/vXF99lt9A89xQxI1VirYE8RLN8wl2H+8HK7Zgix8RnJ+HEXk9JhVvW?=
 =?iso-8859-1?Q?SYp+zv693RdQCQgBj+HfkCldvSS/S2SinWApLWV4Wm+QYXlAgHMTVfmEQX?=
 =?iso-8859-1?Q?mPJppK20GbmnIlA88bYA42An7nsSQoj0JQEww1MKQKsw7x/7gRd793TdZz?=
 =?iso-8859-1?Q?UtXhm37NPxG6YdSVOivzhmAQhFDXMyYnV8f5/XksmBxlK6PkaK9pGUHA8l?=
 =?iso-8859-1?Q?+DPZ3xy76IXXt6CQW7W0MTQ0CqR/eIGqkv5+pKgq9r/2X9d/29Mo5mk6Pp?=
 =?iso-8859-1?Q?4w4BugF4o6ssyZ7pplZ8rvGO408PkHxRDZwwdjRKkIJySkYjH7Fz9A+IWP?=
 =?iso-8859-1?Q?b44JUrtYOZJP/kSkv9zLPpO2OKq3hLc2yYFYrdPmM4MW3QLEOPV61MGX+m?=
 =?iso-8859-1?Q?W2nRzmb4Xwe5yqZEZVr1OQfdwpmZlDSHVR3yQyjEWObd5iX4Yq45nwo5jQ?=
 =?iso-8859-1?Q?Q0s2w7qeRoXznU7bin0lv69VNtkZf5xaVlPeHE6cf/DRdnwEpdpxs6Q83M?=
 =?iso-8859-1?Q?fIFtY5CpCNgcRKQ0Kb9xHZ+4WHmj1e3ji9zgoDIBJlYMj/Jff0MDXuNSwO?=
 =?iso-8859-1?Q?bKfM7gwLQ37J8whxl2+PtL7HjuK9eHFJKdtBiZD47jQ9GbEA8CVGpxbM04?=
 =?iso-8859-1?Q?sZiHdFLSUZS4OIO+u7/VUtbUqU6fhY2xpXsi6rFsTzaew0t31yBrxUa21E?=
 =?iso-8859-1?Q?k3TNxvdGQfQ35KOzSOq7b0LbGwwW7rWDev?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01935df4-1797-409e-da5d-08dd39b9d6fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2025 01:20:49.4609
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w7abeEVVvIRRJm2/CseKHwVK87RhYlZWAZgOUddY9rSxtnlwu43/h2Z5CB/Xk7LAFtbvmX5fQqC2QyD5RBskQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6690
X-OriginatorOrg: intel.com

> From: Ankit Agrawal <ankita@nvidia.com>
> Sent: Tuesday, January 21, 2025 1:02 AM
> >>
> >> @@ -46,6 +51,7 @@ struct nvgrace_gpu_pci_core_device {
> >>=A0=A0=A0=A0=A0=A0 struct mem_region resmem;
> >>=A0=A0=A0=A0=A0=A0 /* Lock to control device memory kernel mapping */
> >>=A0=A0=A0=A0=A0=A0 struct mutex remap_lock;
> >> +=A0=A0=A0=A0 bool has_mig_hw_bug_fix;
> >
> > Is 'has_mig_hw_bug" clearer given GB+ hardware should all inherit
> > the fix anyway?
>=20
> IIUC, are you suggesting an inverted implementation? i.e. use
> has_mig_hw_bug as the struct member with the semantics
> !has_mig_hw_bug_fix?

yes

