Return-Path: <kvm+bounces-25938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ECA8D96D7E2
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 14:07:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D0D21C22F02
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 12:07:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72C0919AD9E;
	Thu,  5 Sep 2024 12:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XVMHdQMJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4170B199FB4;
	Thu,  5 Sep 2024 12:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725538046; cv=fail; b=o1ROxUKdea2ujebfhq/TaifE2a1YbIyejN8lSXv1fdiy2dZn36Xo4xBJXNbEQ1PlbAfNZHpo1+Yie+rY/td4+nEaa6pI6JO231T2mrE3wrChCnytu+t1bvnZX2Du4n5xdpvZedDoFdpGkpMhku2x47vi4cwtJn0pN/Lqx9mPHPI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725538046; c=relaxed/simple;
	bh=YtDer1skH91YbDv3MsedyDUmzhMwNhSF6q72STJ8gzs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dpSZpdlSVXNgBQ90fKcFDCfNGo891+k/pMWR6o6+809OK7l6PHTJFWluZKvodVdUyiJvnVcvl1ymQ33j1SCFrBmMwVsKQqRyyu571orKw+psItmCiiaHUnFhhlo4yuIMZ6CuHmlzBrq1ShTqbLdRW5oB6gshCRZVb0Bj6JGMr6M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XVMHdQMJ; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725538045; x=1757074045;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YtDer1skH91YbDv3MsedyDUmzhMwNhSF6q72STJ8gzs=;
  b=XVMHdQMJ+gsRkP71alHP+UwGZ2kKWFYcscz8thV2MR7pTbA2PYMZJBwn
   aE5Ec6bNztGNMKAJPbqIu8oq6wNPQymPoSnABZft9x1VWK3HP9uL6uO04
   C0/236HRG6rdWkAMEXcPqf8HpFNaF0Z8/Qf4G3THQd7NgojlQgdXyFA9K
   Tg6LjZOrvD46rwKCK0RS4UGVa+JLT9ADKhHiZXoC6J18CXUbs6DVx6vzZ
   6g15Wq3WVXcrCjVTSSF7jIIpAO5pbTXXbr35A+sxClRnc5dYDTe93k1dN
   W7l0J+lqTyivY6v8rmeD0+0DXStY4l2jzQW3Ku/03Bh7SyyNqJDlvjFM4
   g==;
X-CSE-ConnectionGUID: zel57T7TT7KGNKjL1ZyK9Q==
X-CSE-MsgGUID: NGNpd0gaSsCxZn/lOg3CMw==
X-IronPort-AV: E=McAfee;i="6700,10204,11185"; a="35635199"
X-IronPort-AV: E=Sophos;i="6.10,204,1719903600"; 
   d="scan'208";a="35635199"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2024 05:07:24 -0700
X-CSE-ConnectionGUID: AxqFBxksQ5m3cx0SalxNhg==
X-CSE-MsgGUID: CPDpoIZsQWWvJkn66lFynQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,204,1719903600"; 
   d="scan'208";a="66127055"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Sep 2024 05:07:25 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 5 Sep 2024 05:07:24 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 5 Sep 2024 05:07:24 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 5 Sep 2024 05:07:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vRk7H776FXburfgOS92Tbg0UsHxNlZqyhFdl80jEUsL9fzCrozx1kLv75FU0EG+rGzOQxAb8c+4JFFoPUWzb/sVZSm0wOodcIUIWF6y+rda4qUGLQz2h4PmjLQUj0drZNQmVNHUNfPhVNjAyn8lwaEsC6FLGMY8cjiZcCnmBu+FmvjXyHjJO9dqhn0vPyXd6K1PXbYhO3sZq7nShk90hLZo6cjb77HoeAlRJDfXBBZMPs6i65JOVuTP7OuLUuT+NPOQGyEBBDDT+3KFOF3apeX4PsDOtUYd7VgMpSNryUMlY7O7Z2VxCUS1q9eRRvGRj+4mojxB1k8ckZtelLhuxXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YtDer1skH91YbDv3MsedyDUmzhMwNhSF6q72STJ8gzs=;
 b=BUMY358ME95u93cXr4ep0Y4JcA/sD8GpSkWcdCS8WO6CQ7jNKkKwT2NxT3dAayxbKI7JIC5eYeGXwwrjc04r6O+TcoCA6m3+rITwBiY6WG+nVHOm64vWNWVaLzukyfSoCOJkg+/ntpHjgLE81c12ueYPNkeJoOmeDzpP9RtrLvLFINT4cpyV8yAzLch1foucKWTtI3jDAFZVnlDa1fj6DEjMLXBRWY+lh6ClS4/H3oJlsF5SX+e5SwxN1ZQDZr3hTkx+gYI90BG1uwPuOW8CQDjfMH/6jDLTjBWu+5WmBVLgioXtawGDZewPPlwzzVYZWYwtxZJoIGELegt/0kVVhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW4PR11MB6666.namprd11.prod.outlook.com (2603:10b6:303:1eb::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24; Thu, 5 Sep
 2024 12:07:20 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%3]) with mapi id 15.20.7918.024; Thu, 5 Sep 2024
 12:07:20 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, Xu Yilun
	<yilun.xu@linux.intel.com>, Mostafa Saleh <smostafa@google.com>, "Alexey
 Kardashevskiy" <aik@amd.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, "pratikrajesh.sampat@amd.com"
	<pratikrajesh.sampat@amd.com>, "michael.day@amd.com" <michael.day@amd.com>,
	"david.kaplan@amd.com" <david.kaplan@amd.com>, "dhaval.giani@amd.com"
	<dhaval.giani@amd.com>, Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>, "david@redhat.com"
	<david@redhat.com>
Subject: RE: [RFC PATCH 12/21] KVM: IOMMUFD: MEMFD: Map private pages
Thread-Topic: [RFC PATCH 12/21] KVM: IOMMUFD: MEMFD: Map private pages
Thread-Index: AQHa9WDSA4/jzf2jak2pyUws2LsQ4bI5OEgwgABEaACABIX0AIAALPiAgAEeNQCAAHoIAIAGzr6AgAA6GYCAAA/8AIACDdpwgAA9oICAAABy8A==
Date: Thu, 5 Sep 2024 12:07:20 +0000
Message-ID: <BN9PR11MB527647C57E61C3965420780F8C9D2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <BN9PR11MB5276D14D4E3F9CB26FBDE36C8C8B2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240826123024.GF3773488@nvidia.com>
 <ZtBAvKyWWiF5mYqc@yilunxu-OptiPlex-7050>
 <20240829121549.GF3773488@nvidia.com>
 <ZtFWjHPv79u8eQFG@yilunxu-OptiPlex-7050>
 <20240830123658.GO3773488@nvidia.com>
 <66d772d568321_397529458@dwillia2-xfh.jf.intel.com.notmuch>
 <20240904000225.GA3915968@nvidia.com>
 <66d7b0faddfbd_3975294e0@dwillia2-xfh.jf.intel.com.notmuch>
 <BN9PR11MB527657276D8F5EF06745B7208C9D2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240905120217.GC1358970@nvidia.com>
In-Reply-To: <20240905120217.GC1358970@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW4PR11MB6666:EE_
x-ms-office365-filtering-correlation-id: 2c82107b-576b-49f9-be84-08dccda34af7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NkhWOWNvU2ljUjlId3AwcXRhbENpRkpDNzJHQVppbEtvbFJmSUthdlJsaVli?=
 =?utf-8?B?dnB3Sm5PQkJPT25CQ0hXRlRkY3RPdVh3TjlKS3Z4NXlTWGVCcnVFTDQ2ZFpD?=
 =?utf-8?B?elRsa0NtKytnNnVjM1dBenZscndhUjIvdHU0MSszbm0zcm13cmR2SUZuMXR3?=
 =?utf-8?B?T0xQTXcvSWloNlFQOEJTSjZRZ2ptMU1SRDNMQlFsL1ZtRndmRUcrU2oyMUw2?=
 =?utf-8?B?aFd3S2xpQ1gzaENjb2Z2SU5mQ1JyWGY2eklOUzlpUnprNW5oczlrZ3o5eFI5?=
 =?utf-8?B?Nno3TEJ6TzBHMk5WNzJNeGVWSDlhbDMyOFdvMFExa0F0NE9NcXFPbk1id1RR?=
 =?utf-8?B?K2wzamJoVGwwZ3kzZ1R0NCsvZUJ3Y0RKTEtCZEpNeFV1WExkK1pJWlIvdFk1?=
 =?utf-8?B?TjZ4aTBlWGtwZHBRekxXTUxQQXFUQTdoekRjNUthMHBiUDA0S09jY2xTampN?=
 =?utf-8?B?TENMSHVOMkdKRTZvTm9qTmJ2UWVOY0g2bkllRXVoRS9vRTF1ZWVqMVVMaDZQ?=
 =?utf-8?B?ZmkyY3JKT0N1LytDODFxaEF1am5QbVV0VTlLMXA4bHBWUURFcSt4Uk9zak94?=
 =?utf-8?B?bkdTNkgyR1BTMm9ITlpvWFpZUVJ4anRJN1hIcWpMUEIyNy9zcDZjQk0ySmcz?=
 =?utf-8?B?K1BCcGtySzhEWjJ0c3EwZUlkK00rMkZEN1BWK0thQ0VXRnNhMGVuTUg1SFhW?=
 =?utf-8?B?VTVGWUw0MjZyL1pETWtra2NlSTlVTXBRc0N1aFUzTzZFY1VySVpGRFpBaW42?=
 =?utf-8?B?dXNZTXVFdWFkZzRpOTJtNjltaXozKzN4bjRMVkRrOTdxdTRzbFJEVG5UeHRB?=
 =?utf-8?B?WjlQakNuV3FJMmdZRkdkd2lWVnBnUEUrN1pFcndsSG9rcUtzV1ovWXJqa3cy?=
 =?utf-8?B?SkRvZVZSWVM2bkxwT3dZL2w2bVIrUE1KWFpSTEZPM3lkdW9TUlBsUFJzMG5k?=
 =?utf-8?B?U3BzN0RQbjA4U2k0QTBJQld0RjY0U1hLUjJRR3g0bEt0K3dwdHE1Sm1MTkFP?=
 =?utf-8?B?d3lZbmRRSXZHOFdiaVcwbWVYUks5ZWx6OEFZNnhqV2NqNFY5YTRWdHhtWHhJ?=
 =?utf-8?B?cFJpVHkydkhDZXlpYXJ1aGVhM2k1UXQ2aWlUeVdONjdjMzBpMTY5Y01yTFla?=
 =?utf-8?B?YitkQ3dXT25yMDdYbzJsVGQxcE1Mb1Y3bHdVWEEycFdCOUJNem56RUR4Yms3?=
 =?utf-8?B?UUMrUEw0RUVFbUNxZEtwZ1hGSmV0T0ppT1kwVjZNdHF3bzVvNnFPYVBLT0Rt?=
 =?utf-8?B?aCtpc0hPRmg4a0NEOEtFOWFaTDI1VDNvU0h4L2hhTVFlYmZ2c1F2Uk05Lzhr?=
 =?utf-8?B?a3p4T2dBQjhtdmpyMUlrMURTNWxXV3V3N2czc21HbzYxbTllSlk1V0pPOExK?=
 =?utf-8?B?RlJXbVFmZVgrZ2JJYXpKdkx6YUwyeGJoa1FNVDJYSVJzTEtaYnhudGNFT1V6?=
 =?utf-8?B?cENJejRTb1dBNVhxZ0ppOVBsT00xSktrcU5BT0tGdEFNUTl4MjBKYVlSYnpl?=
 =?utf-8?B?RWpSa0FrVGVrSFZKN0haQWlqc3d0V0NENi9DbVNBNWM0aEhSS3cxWmtadDJq?=
 =?utf-8?B?SXNkOUNIWVJ0T3QvTWw0V2dhazVyRTZLZzA2eGc5Y05kTUIrNERNbXhXRGxy?=
 =?utf-8?B?UWdzS01KS1RJY0RZeVVQL3FrUVVNVkIzdHUrNjZPcUEvcG5TakI5YzZRS29s?=
 =?utf-8?B?YnZYdVZEaFEraGxMVUFlYmR3Tnp3UnBLSndmM0dRejNEZmZJNUJnMTB6UlNs?=
 =?utf-8?B?YVpkdEZpTWczaSt5N0laNGtML1ljMmRiOERLNHk3ZnRRZjYzanlDVGZ4TXB5?=
 =?utf-8?B?V1ZWUUdTT29qclVkSFRKZjJPamtHT1B4WTJIeDlpZ1EyMVNReUpaUldFZHFp?=
 =?utf-8?B?Nys2UyttZ0gyWjhXbDNQYjRlUEt5ZlcwTUxCUkxQeEVpTGc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VzdyOUViblhuQmlTcTB1d3VNUCtjWmdFR1BpWFFuaDI0SVhVVS94YjJXUWVl?=
 =?utf-8?B?NDZrQi9TZFJNeWcvNWdkTmphVWhFQVo2SXFjQzZiWE0zTEgwV2hvQ3lNTzdR?=
 =?utf-8?B?WWhUenJCb0pwT1lCaGpyL2FJT1ZvOVV4WUJFb1BGOTFRWTVSVytFVDFJUlV2?=
 =?utf-8?B?Wmk5ZXRocEcrR2d2UGlNQUJjMjZJOFhFYzFqL0RWV3UxVFNVdnNvcnFRMkU4?=
 =?utf-8?B?cjkzd1VrZzJId2x3OFhCb0NCN2UwZkJXUUhEWms5WUtpdncvdUlvSytob3dQ?=
 =?utf-8?B?KzhVOE1zbG1nTUpENVJGb3c0ZXJYVHlRdHpLcjhGeG5JYTYwNWpFWTk5ZWJh?=
 =?utf-8?B?UDIwUEZQMmhkM0ZXdCtrOUR0OE5SR2J5L1VuTEhuSXdKbWRaZFVVRENOQjQr?=
 =?utf-8?B?MHBURzJXeUJyNFo2OHFtenBBUXh1eHF0NTVKcXYwazN3RDVRUzZpVnBzT3Z2?=
 =?utf-8?B?Uk1UVmk2SVFZUENVZUlnWlZxbDEweGV0RWFnb0pMdklFYmE2clhuRU5NU1ZD?=
 =?utf-8?B?bWRuV1VlVk5ZZ0VhbU9qT1VyZ2ZvaFpvSU5wcy95N29Jd0dsUXZZRk9DQThC?=
 =?utf-8?B?VlV1eHFxQ3FoYU1EV1g4Snl5dFdKVlk1MnQxdmRMbk5xOG9tanV6YlZsNEc1?=
 =?utf-8?B?dzFuRzU4c0txVlZaR2YwMm14cEMzQVBBeWYvUVZWUS9zbVNIcGhLS1AzT0s0?=
 =?utf-8?B?QXFrTFVOSlNIWWx6OHZSckJhWFJLR2JIOW1QdCszdjdLRk9ZWWN3K1Y3ZHQ5?=
 =?utf-8?B?N3FlQ0ZoQU5hdWMwcVRQbGFHcmxtMXdMbHJROVk3bld5V0NZaUt6TWNPOWI1?=
 =?utf-8?B?T05QZEZ2OVI0WEx5TVNySmVubzdUcUNtOHk4ME81VEY3SnpHZklETlNaczNx?=
 =?utf-8?B?anZ5c0tQMWtxMDk0NWpKcmNjbWcwUUpJcUxGYUdnVHNOUGVzU2gxMTc2Q2NZ?=
 =?utf-8?B?R0d1R2J1cFIyVlp2MSs3RmVYVWxRK1RmRy8vaUEwOFpob2R3V2xqZEJSYVhC?=
 =?utf-8?B?amswU2pOMFFrY3MwVTEvNzdPS1UrREV2TVNHbVgwVWV5cjZEQmlTaStRR0Rz?=
 =?utf-8?B?MFhhK0NYVDY4UXlNcWtkSGI0UDNGNmhkcnJVeklnUFltblhQS3lxakUzelpl?=
 =?utf-8?B?Z3FiWE1naWRDRUVQbTVOWTFpdnBBSDRIWGdTb1hZMDJXSTFaN1QxNE9Ld3Jq?=
 =?utf-8?B?a2VEN2lVY0puSlE5MVJHYU5jVGJjcEVWWUxOVEdLVEFtN1F2TWRsWXRZSCtC?=
 =?utf-8?B?OHRGU00zT2VDZTZQNUNkQ1pGc25OMExDWjQ3aUFBUGZ4cnBqSlg5SlJZUmtP?=
 =?utf-8?B?VjNtN3Fjb09OZmExOVlFTDJ5SmtUR245eHdzL2l1STduK2labGVCbXJWUGZ3?=
 =?utf-8?B?WnNHUVUzbzdQWGhMUmwxb2VITDh0NkhlNlJJbmI4Y1FHcGIyWURpZDN0cHF5?=
 =?utf-8?B?UUhRMUFnM1MxKzhVdDFJRzFXbElDZ1hIVzFRVVdoOG81eWVVcnJFTmd6TkVi?=
 =?utf-8?B?aCttY20rd3FlSkE2VG1DdmI2MUVOQ0hQalN2UTRiZXhWWlc2WWV0cmd4SmJn?=
 =?utf-8?B?NGdUMWpsRklldzZpK29CbTA4amVTdncwOTJHaC9NNkw0OHFHWkhKVXl2ZlFw?=
 =?utf-8?B?dEJuTnliSHppclZNYnB5OTJNS2I3L1ZJcWVTMWZCaVpxeUY0MHFkeFVGUUtt?=
 =?utf-8?B?eHRhTk5OT3lkb1dTcTVwUFdvelpPeXp6ZTlHRHljYkxaVHZUY1Rxa1hRSy9v?=
 =?utf-8?B?U2VDS3RtMm4wWEllRVJsNTRURTJHb2VEK2dzcWJIVGhmbGU4OGwyT1FPb2dh?=
 =?utf-8?B?RVVDeHp5ZnBzUnNsNit0NVh0MTM3YWcwZnI3QVQrcmQ2bFZ2ZEZxRTBsVHBs?=
 =?utf-8?B?U2ZCRFZ1M2Q1TjlNSmhTbXUvMXRGdGlQWXB3SmlpTEdWUjI4ZEEyRHM1cFhQ?=
 =?utf-8?B?TjFZTjl0SkU2VDVjQXNZbzdjRGxUalpkSTNtaDgxeDZlVkxDbVNVL2hjMXhs?=
 =?utf-8?B?bWtrMHNmRmJjN2wvb3lzaDdlSXlyQ01Vc0RJb3pxQWNreStZdlZMNzJwZEtF?=
 =?utf-8?B?U0xock9vWE80b0N4QnJuTnRoWGN1N3U0WHUxY2xRY0NwY1NFYThVeGtncjgy?=
 =?utf-8?Q?Y5D3j+q2JHSX8MeLEl4fEdjqr?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c82107b-576b-49f9-be84-08dccda34af7
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2024 12:07:20.0268
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9NrNUplQ9hUMxPm0f6x/kwW/DxeVtUKY60xwKTi953oVJAbXOTYvjhfA2K7mpQnSUwBhUjTn4S5bNwnJ+gMLog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6666
X-OriginatorOrg: intel.com

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBUaHVyc2Rh
eSwgU2VwdGVtYmVyIDUsIDIwMjQgODowMiBQTQ0KPiANCj4gT24gVGh1LCBTZXAgMDUsIDIwMjQg
YXQgMDg6Mjk6MTZBTSArMDAwMCwgVGlhbiwgS2V2aW4gd3JvdGU6DQo+IA0KPiA+IENvdWxkIHlv
dSBlbGFib3JhdGUgd2h5IHRoZSBuZXcgdUFQSSBpcyBmb3IgbWFraW5nIHZQQ0kgImJpbmQgY2Fw
YWJsZSINCj4gPiBpbnN0ZWFkIG9mIGRvaW5nIHRoZSBhY3R1YWwgYmluZGluZyB0byBLVk0/DQo+
IA0KPiBJIGRvbid0IHNlZSB3aHkgeW91J2QgZG8gYW55IG9mIHRoaXMgaW4gS1ZNLCBJIG1lYW4g
eW91IGNvdWxkLCBidXQgeW91DQo+IGFsc28gZG9uJ3QgaGF2ZSB0byBhbmQgS1ZNIHBlb3BsZSBk
b24ndCByZWFsbHkga25vdyBhYm91dCBhbGwgdGhlIFZGSU8NCj4gcGFydHMgYW55aG93Lg0KPiAN
Cg0KdGhhdCdzIG5vdCBteSBwb2ludC4gSSB3YXMgYXNraW5nIHdoeSB0aGlzIFZGSU8gdUFQSSBp
cyBub3QgZm9yIGxpbmtpbmcvDQpiaW5kaW5nIGEgdlBDSSBkZXZpY2UgdG8gS1ZNIChub3QgZG8g
aXQgaW4gS1ZNKSB3aGlsZSBtYWtpbmcgaXQganVzdCAnYmluZA0KY2FwYWJsZScuIPCfmIoNCg==

