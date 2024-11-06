Return-Path: <kvm+bounces-30851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A8189BDF73
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 08:33:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A01EA1F221F2
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 07:33:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8DA01CC8A3;
	Wed,  6 Nov 2024 07:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TETghzzY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFF5176FA4
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 07:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730878390; cv=fail; b=bc4kq3OqIYTtoGCPcA3umuTIFpKoxm4UOfpZwTM5AKGtnrhEsjVpEdGdAWTNKWOyyV/LD7yG+4Kwb0f7kxejt32o+s96qR1LudRWTtDpAbVxhAr8yIY9JpvOJDGJA/6z3QrfPgCPPX0qBtY9seLH1XtLfZSHSqZ/e8v8e1uRcXM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730878390; c=relaxed/simple;
	bh=O6B5/8owMVYRtdbtAXmxYYVC85ob3xCDIzu2w/Ddjko=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RunesHVGDzWZUmcK02lP+WkRq4QGeWW2ByKjQna6iOTOCnLNrBrxhCK0FnoTKPTvKMXUmSpBnmNqh0bymXJCQLM4kQV3xW24RIVANQUO6rRdANcpQilpjiCcKSxH7Bhja7klFC6adLyMZwhPOByuTYxtc+VvMGm+idMmvjfBXU4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TETghzzY; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730878389; x=1762414389;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=O6B5/8owMVYRtdbtAXmxYYVC85ob3xCDIzu2w/Ddjko=;
  b=TETghzzYPy27tMxU2JoZKGZnCkD/Wgrmekz61JNoxg+hlsVtWmp5Dq3b
   glpqcX3eIZFdgP6Prua9uO4d/rV9p0iLhAKb2yJ7aDrkplI/ZMa+w50LG
   yGCFU2aGNEP4c+Q+M9XlZpHV1WyXRyh2SfaaKbcZYlSW9I117AND34kVn
   M2qKPRJGX/nJvXxBa4pz1HbAm2UYpPgLbeCtqWNX+nb+akFn8v26H/ToV
   +0f8GCo0ZHXtvD4SqmzbSmyVxpuYACzt148Vg+DlhSwdDOK0ncFQSKYRE
   TEqCZ+bdfbQjGRqiH4vQVpi1dhf2TBl9SCpHRn7R1zrB4XCdkc3TrJqqR
   g==;
X-CSE-ConnectionGUID: Eb2slPfWQia/GF9vme+x2w==
X-CSE-MsgGUID: kcvT+OiDT1qQmn1Xga9Z0w==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="42059612"
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="42059612"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 23:33:08 -0800
X-CSE-ConnectionGUID: Y99qxqLRSNGfTCU5JxtuFQ==
X-CSE-MsgGUID: oYA+XwV9Q1Kxc3lz65kHFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="85205743"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Nov 2024 23:33:08 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 5 Nov 2024 23:33:07 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 5 Nov 2024 23:33:07 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 5 Nov 2024 23:33:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QUTJsvCxlnKpfXAVKTu/RC1g57Uvb2jT4GEFeCwxkPwonqHq0uBueYn0A6/vKzkO541xsclG0FNHhIK7+QC+1wViJ4/55gYIFOpaXlTQOBUNi910+oksGbFw8wdKK361l7aBy3r4u824taOC18EN9EJvZGtPLePXyUq+vpE9LThAbi6WT0SXjSSwXZ4HNTcCiLn9wHswlUv0lW2kqIVB3Iy1kkDoELjRx9iljKkn+S4t6JsnUzeFOH7oUHmvrk/DfrgltQEIep1FBZQfSHrCBJmFZRoVzfANQ103UOqKVf9RUA3SCguMp/Xj+PVFlES4AWF3BBh5vOTZ3+Mm7NsMtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O6B5/8owMVYRtdbtAXmxYYVC85ob3xCDIzu2w/Ddjko=;
 b=GiqW/nRM6SPcFeZWwH3Mp2r6TxfuAbZFS6+rXaZiNln3pel2Dy4JwnficPa46Kms4FQQcGyiLtcy3Q0dpetZW1uB3mQ4ICEme8jV3UKdME8+jqGeYA7fumS3Ef1H/2/nXKeH/U81Cva+t7e8w5hERR41pl6O0F9kXifask8U2h8BtN5xH4pBL3e2s7+F6sVBGgUVSVV+IkJrOHDmeVdYYuD4sxMLqlSQItvpf3GnPzDuWLZZHimmmqpDxplex77xGApsCn+Y7lVXMVkfmINBUWCLZtCUlYTy+z84U51Rr1cR8jd/zBpnWErvel9FUAe0GcsuYIoZzmil12QaUMTVKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB6442.namprd11.prod.outlook.com (2603:10b6:208:3a9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.18; Wed, 6 Nov
 2024 07:33:05 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8137.018; Wed, 6 Nov 2024
 07:33:04 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, Baolu Lu <baolu.lu@linux.intel.com>,
	"joro@8bytes.org" <joro@8bytes.org>, "jgg@nvidia.com" <jgg@nvidia.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "vasant.hegde@amd.com" <vasant.hegde@amd.com>,
	"will@kernel.org" <will@kernel.org>
Subject: RE: [PATCH v4 05/13] iommu/vt-d: Prepare intel_iommu_set_dev_pasid()
 handle replacement
Thread-Topic: [PATCH v4 05/13] iommu/vt-d: Prepare intel_iommu_set_dev_pasid()
 handle replacement
Thread-Index: AQHbLrwggahcyjOhz0CbdJvK653nqLKn/SUAgAArIwCAAbZP4A==
Date: Wed, 6 Nov 2024 07:33:04 +0000
Message-ID: <BN9PR11MB527611C8ADBB4F76719C81D48C532@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-6-yi.l.liu@intel.com>
 <63b941ed-4f46-47e8-9fdb-211b6413137d@linux.intel.com>
 <0538df75-fb90-4bdd-afc2-c539cd948ddd@intel.com>
In-Reply-To: <0538df75-fb90-4bdd-afc2-c539cd948ddd@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB6442:EE_
x-ms-office365-filtering-correlation-id: cdeb64bc-de73-4c36-3c74-08dcfe35406c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?L2xnWUdnTk1xNDN5aThIRTladDJMWVI5bDgxWnN6Nmo4R0d4TnlmQ08ydENv?=
 =?utf-8?B?ZjJLNmk5MkpDYkM4N0ZNdEFPRldDczhIZkRuMGNIZ085WVVvRS84a1VrT2Ey?=
 =?utf-8?B?QmIrNlFEU21UUnlHTTBNZ0ZXZzcxQWNPdzEya082b2FjNTBFMURjdDNQd2pt?=
 =?utf-8?B?bENoeVNTc2JybWdUcEtPUkVNYjF5L2tTekxITFVZenE1ditMaHpqZHgyZXNF?=
 =?utf-8?B?M1k2NGJZWERuaUZhSmhkTHRSdnNwSnVrQmlBcFVKdGJCZ3MxN3FBNk5SdUZ5?=
 =?utf-8?B?b2R2OUhPNHd4MGI0alhyOFZ5T2hCZVZmait3S1VYd1ByQmRRazdHMnpVOEFz?=
 =?utf-8?B?UFBZUDBQVndFMW1tOFdhS2VjUWJWKzZPSG10MVVHMXBLYXVPTXBTWitvVnho?=
 =?utf-8?B?S3RoNUZsbnNTa0JQTVFDWjhZWlAvK0VDZjNWY2VXV29EOUVVb3pkNlBQSnd2?=
 =?utf-8?B?WXZLeWxtYzkyd3hSSFVKRVp1TGpDWW5za2Y0ZWpBS0tpb0VTVU1VcXhRS0Fh?=
 =?utf-8?B?ZGF0RkR3TkpxUm9aNGk5VVV0UE1FbEhBQlBiV0ozRGNWSTh4dXcyM0hMTDVu?=
 =?utf-8?B?MWtvdW05Rkx6SXN6Zmw5bnhZQkQ1b1QwcDF1VGlqZ1hsTkxOQmJwUEVFbmJt?=
 =?utf-8?B?cHVhNVRmamtCNXU4aFVJemx3Ui9ZV3MzMVZlQnhQbi91OXBaUTFEaHk3OW5r?=
 =?utf-8?B?MHZCR3lmNWE3L041U2kzQzMyNGpqalpkWFViTEh5NXc3NnhBTWlKQ29KZUl5?=
 =?utf-8?B?QlNieE8wTGZ5cUtYaXJsL094bDYyWTlMRHc5NlJiYllteGcxQVNuN3lxVkpH?=
 =?utf-8?B?a3pmM3gzYk9MTStwRVQ3VUtOelRYaHVwMTQ5NENmQktoZ2Nzd09qRTJ5Znlo?=
 =?utf-8?B?U20veG4xRG9TWWVOQ1k5ZU9MU2ZHd1RkeUdEV3Nuc2dGbGxUaStiL0JHeDJw?=
 =?utf-8?B?TXMrSkpKYXp4dkFTL3lXbVpHcElEdXIzb1NpbnBWUFYwQVFlRllqSVo1OFEy?=
 =?utf-8?B?b3dMSlVDaUcyM2xFdUd2ZkVOcURXWWY2MVNxRFl6eHA0UXZTRS9YVGRRZndR?=
 =?utf-8?B?M2RmRlRqVmVtWmxNZkV5TThISENxZ1NWeVVWR201eEdRSlVWeURnbEQ5ZEJL?=
 =?utf-8?B?Wkx0VzRoOGtvbzAxQnd1eHhScERyZkhtVEtmdVhVclNZOHlsTkorWGNCUHVx?=
 =?utf-8?B?aHRsei9BaCsyZ3VETzNaOXRyVWY2aXMvWGxrb0RmSjk3d3MvWnZXVUZhMU5i?=
 =?utf-8?B?dzVZa1VJY1EzMkkwbS9LTEYrZWVRczlJM2FFQWRPNDdSbk83Mk8vczl1dEs3?=
 =?utf-8?B?SHlScy9OMkZmOStoOE92RmZubXYzNmxhODMyeUVOdzdaRmJtMkJJMnQ2T24y?=
 =?utf-8?B?UllYdmx6MHI0Z0MvR0p0TVRCQnZlKzlTdENFMkZ1VTNDMnNBb2t4RjZQNEVu?=
 =?utf-8?B?anVhVm9qMHJlYjRkWDNGcHpJWEF5TFlqTldNandYeitJa0tTTjhKK0xwbWRN?=
 =?utf-8?B?MzNXY21VcmQ2dW92dFBHTkZCM240dEhtZlc0MlcrOFhHWlI2QVZNYmJEbDd3?=
 =?utf-8?B?NHBTRDV1TXFlVW1iZG1lOFVvcXk0aFoxNWcxeWp5NWRBdEZ2N0dURUo2Z09a?=
 =?utf-8?B?MlovTEhuZGNvVjRYNUJMUkRZaE5hNTJxcTlMbHV1Sm9wVVc2S2QzSURCbEhm?=
 =?utf-8?B?QmZCL3krNFRhWjV2MkJYL0NJT1E1M21xVXJWMy9jUDNNOXljTXBJZjBMMWdx?=
 =?utf-8?B?cmpyeHhPbWFpOXpxNG5vQWRHcHRyZCtNQjl0cnYwWDVWYlYreUQ1WENvQ2RP?=
 =?utf-8?Q?AgT3aRYPpRPFmPJp3IpLAAif+Yxi4fJ3ERivQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?emhmczV6RWdtZzhGSDZRQVdlL21nM2VzWVJibmlScGVKeFlnSVNCemNVT0dY?=
 =?utf-8?B?eCtyVHppYjdYZEtpNmtQdFNzQXA1ZDAzUmp0YVhjQXc4TnVDMnQrZFdKMGVS?=
 =?utf-8?B?QjdiS2xFR1dSQTdjejZLTTA1VzFGYlBhbTh1YmFycjRlZjhLMmtTaWVudnRE?=
 =?utf-8?B?RjNuQWRLTUk1b1pleHFTL25Demp6Mm1OR1NGT0dMMnpRZVNpL1FMK0hka2xD?=
 =?utf-8?B?bEI3U2dlbzl6MmtCM0FQZTYvaG5BaC8zaFRCY1liTno5bHdKam1qcEh2UjFU?=
 =?utf-8?B?TjhEMDdCWllNY0VIMzQwNDVkZ2xOcE9COEJtcFcyMUFLdm5lbTExUG1pbHc3?=
 =?utf-8?B?cEZSd2lQL2xoOVlJMFZ0TFp1cS85SDd0VjB3OUxzS2FOUHpFOHhKRHpTamtD?=
 =?utf-8?B?SUlwNVVaOXJ4Zk5DYzNKQ01HYnFlZ0VsUWowTGRGcHhaK002NU8ydFhYMEQy?=
 =?utf-8?B?Q3pNVWNGYzhna3RMNW9iWjlNeUVJMFdWNzYyTStYbVFXejFWR0V5bDZGdEFB?=
 =?utf-8?B?ODZjb2o5Tzhza1lYSTcrN21mL3VCNU8zT3o2QXZJT3hWaHFONFNJc1lxVFVR?=
 =?utf-8?B?ZHQxOVM3UHh5d0NydUFLS0pvWlJWZHI4cWZnb0EvaG80RTU2YkF0b0NQb002?=
 =?utf-8?B?dFR1QVVqdWk3Njl0ejZMVGdpQWhQaXpqc3lXNVVnSElQbWQ3Y05RWHdhbzJ2?=
 =?utf-8?B?M1JXcnFtTjVmc3BNVCtSeklKbFViUW03OWNwMFMxaGR5V2U5anJicklsOEtX?=
 =?utf-8?B?Y2ZrY3JtSjRTR3dzbUtwYlhXVXM3cnBtSDJ2TEU3aTNob1VpM3hqK0lkbXRI?=
 =?utf-8?B?aWxGeDBSN1F5Z2ZXQkFtUDNKeG1CWEZreG80ZEhKd3JVYWpwWXNDS0QxNmJp?=
 =?utf-8?B?T1ZvcDVMYzBnQ1pyenZGL21UOENVUUZkT0ZWQ2w3WlRNd25jb09GeTJZVXlX?=
 =?utf-8?B?NytKRUYxdlc4VDNaQnAzclRjNUtPWkQrTnJyODRHdWRwVS92b1RGMTNldEJV?=
 =?utf-8?B?Z2h0ekJYalRSYlhSV05SQytCbjU3bU5pamh3VldPUEpKcExQcmM0K3I3aTZH?=
 =?utf-8?B?d2lHL1NHci9ieXRSbDhkVnZwYmYwYnBGck1SQXpJbjZKek1WbFNHUkpZV2pT?=
 =?utf-8?B?VXU5VStzNFpDWUFWM2RNalJzcGRtSmpvV2lEeDRQM01DQTZ5dWJTN3l6T2FG?=
 =?utf-8?B?TG80TXE2WmRlbXIwMStkSDFvNVE1c09jbXR2Yk1RSXNGV2oyK1dTSm83dUpG?=
 =?utf-8?B?NTcrV3FDUkhSR0hLR3NZV1lQdk0vOEl4QnZ5TCtKSG9jQlVUVnVrVGVzeGdB?=
 =?utf-8?B?MVg0TUN3Ky9hY3dZS25wQzFlNmRobDZ5MmhiT0NVU1J3WEw3bVViR0QyU1pX?=
 =?utf-8?B?bUsya2JVVnp6MU93cFkvUzBMS2RpMVczbDNqSnExOHNzUStOWXZ0bjlNWHFk?=
 =?utf-8?B?amQ5dXBRVldQVFAyWGxwVi8waW9RUlRkY0FrMDI4a3ZPNEdBVGZDVUVTWjNW?=
 =?utf-8?B?Y2tSK2c3bXRGYXoydHlhTkc0aTVaWE84UldDbEo5Wjk5T29KUm5WdXcrci9G?=
 =?utf-8?B?OUd2NUowcnR0Q21MaFFaczRSYW1CelJvRHhSN2hjcTFNcEVTSHhVMkJZQnJN?=
 =?utf-8?B?QmVpN1BhdUhaUWhZWlJSbkpldmtPaFFnRDdtczRKVkM3WnRDTy8yUmZ3Y0s3?=
 =?utf-8?B?anRBd0JJVVVLZGI1dVY5MTg0bFlxMXZncEdvODBQTGVEd1lXa2lUZkZ5WXlX?=
 =?utf-8?B?dTdaZ0xud1NYWVhpa2VzV2lHaG5WRklpOW9OSDlFNzFGVUQ1MVVzRmRoYWdU?=
 =?utf-8?B?V2kxQkZzMkg4UnhTTkptTFRiSmxsNmpUZXdOc3hsMjZmZGRNYkxmcitYN2hq?=
 =?utf-8?B?VjY5ZjhCVXZaTTRGdE9wZDFiRUJOb29HYWVsa0RwZ0s3YVRvbEZYbjFQN0VJ?=
 =?utf-8?B?S2ZZYU1VeENxcGwyNCtMeWIzYzUwUEpsemlrVGwrQVZjZ3lzS1ArMFM2cVlD?=
 =?utf-8?B?TGpnN2dacHF2N3hzRkluczlWSHkyTzl6OWhrVmF3K0dmQWwvNzBnZ3BWOEJl?=
 =?utf-8?B?K1dkZEVUSmNsMURGTlhaa0dXYXl3bE1YNVBkcVFnaEF1dHI4dWFZRTF4Uitu?=
 =?utf-8?Q?Jko8cE7TNyoj3xSS7pOMy3Ea8?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: cdeb64bc-de73-4c36-3c74-08dcfe35406c
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2024 07:33:04.6902
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: okkbeDsnphj8W9RUeMpJNWtyP8WeLEEs+v0FAm4a4T/6hcn/keZKTc/79Jhz4nhz2b6V4WBXCkgIxTY8j40E+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6442
X-OriginatorOrg: intel.com

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogVHVlc2RheSwg
Tm92ZW1iZXIgNSwgMjAyNCAxOjI0IFBNDQo+IA0KPiBPbiAyMDI0LzExLzUgMTA6NDksIEJhb2x1
IEx1IHdyb3RlOg0KPiA+IE9uIDExLzQvMjQgMjE6MTgsIFlpIExpdSB3cm90ZToNCj4gPj4gVG8g
aGFuZGxlIGRvbWFpbiByZXBsYWNlbWVudCwgdGhlIGludGVsX2lvbW11X3NldF9kZXZfcGFzaWQo
KSBuZWVkcw0KPiB0bw0KPiA+PiBrZWVwIHRoZSBvbGQgY29uZmlndXJhdGlvbiBhbmQgdGhlIHBy
ZXBhcmUgZm9yIHRoZSBuZXcgc2V0dXAuIFRoaXMNCj4gcmVxdWlyZXMNCj4gPj4gYSBiaXQgcmVm
YWN0b3JpbmcgdG8gcHJlcGFyZSBmb3IgaXQuDQo+ID4NCj4gPiBBYm92ZSBkZXNjcmlwdGlvbiBp
cyBhIGJpdCBoYXJkIHRvIHVuZGVyc3RhbmQsIGFyZSB5b3Ugc2F5aW5nDQo+ID4NCj4gPiAuLi4g
dGhlIGludGVsX2lvbW11X3NldF9kZXZfcGFzaWQoKSBuZWVkcyB0byByb2xsIGJhY2sgdG8gdGhl
IG9sZA0KPiA+IGNvbmZpZ3VyYXRpb24gaW4gdGhlIGZhaWx1cmUgcGF0aCwgdGhlcmVmb3JlIHJl
ZmFjdG9yIGl0IHRvIHByZXBhcmUgZm9yDQo+ID4gdGhlIHN1YnNlcXVlbnQgcGF0Y2hlcyAuLi4N
Cj4gDQo+IFRoaXMgaXMgdGhlIHBhcnRpYWwgcmVhc29uLCBidXQgbm90IHRoZSBtb3N0IHJlbGF0
ZWQgcmVhc29uIG9mIHRoaXMgcGF0Y2guDQo+IFNheSB3aXRob3V0IHRoaXMgcGF0Y2gsIHRoZSBp
bnRlbF9pb21tdV9zZXRfZGV2X3Bhc2lkKCkgY2FsbCBhdm9pZCByb2xsDQo+IGJhY2sgdG8gdGhl
IG9sZCBjb25maWd1cmF0aW9uIGluIHRoZSBmYWlsdXJlIHBhdGggYXMgbG9uZyBhcyBpdCBjYWxs
cyB0aGUNCj4gcGFzaWQgcmVwbGFjZSBoZWxwZXJzLiBTbyBJIGNob3NlIHRvIGRlc2NyaWJlIGxp
a2UgdGhlIGFib3ZlLiBNYXliZSBhbm90aGVyDQo+IGNob2ljZSBpcyB0byBuYW1lIHRoaXMgcGF0
Y2ggYXMgY29uc29saWRhdGUgdGhlIGRldl9wYXNpZF9pbmZvIGFkZGluZyBhbmQNCj4gcmVtb3Zp
bmcgdG8gYmUgYSBwYWlyZWQgaGVscGVycy4gVGhpcyBjYW4gYmUgdXNlZCBieSBvdGhlciBzZXRf
ZGV2X3Bhc2lkIG9wDQo+IHdpdGhpbiBpbnRlbCBpb21tdSBkcml2ZXIuDQo+IA0KDQpwYWlyZWQg
aGVscGVycyBpcyBjbGVhcmVyLg0K

