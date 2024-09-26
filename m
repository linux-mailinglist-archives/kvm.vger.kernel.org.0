Return-Path: <kvm+bounces-27545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CFC7F986CF1
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 08:55:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 399E8B237C2
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 06:55:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6594218C006;
	Thu, 26 Sep 2024 06:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UHGzG3RA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEEDE188721;
	Thu, 26 Sep 2024 06:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727333720; cv=fail; b=lHHknTx1yN0tirkiE4VvPEc9pLGwYrUOIPozgJlJ4+p9Obt4XgohfuMQe0c0lpjZHpojEuGOOs2BYMqoXHSQ51Mn1cb5ImXS6VvPPlD8DH7T2lGLpAZDud/XIUiaYvYy+TDSKNNTj5rGo9XodGNTXpFbbvNEVCJewiT/CBw9UBs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727333720; c=relaxed/simple;
	bh=L5jlNNQAJFy7LGxkANOewOOZEzIajCdTyPy7K/LKc+k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=e4EqZkPfkA3YyK0SZDjrUdZ91GL+PDdasp0gYytKQHn9p3KoTOHP0kTgtHtWPdV3XlBmWk4lFy/n7P7CYWbaWltNDhFextnSS+ZfElY9PaDCZwFu8m/SfdhtbCNsvfKMo+44KafrjGXTrAfsyC9rw/rktfW25LddoanlOWqdmC0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UHGzG3RA; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727333719; x=1758869719;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=L5jlNNQAJFy7LGxkANOewOOZEzIajCdTyPy7K/LKc+k=;
  b=UHGzG3RAILll1gYaSIfhuODWxigR5vPVFGjFmbd43uCYf0X+nMBPN17W
   K03gCJPBC4dOaN2ePnJrJnztO3Ab6mWUaZ/N2pBOqB6ALjad8NxVR5K7c
   u4V0OScNSnEazivOiVseQzilwkJTDtrjqDP9nP/Ga7v0rWvRIwdwJJrtd
   Fdhh+TIg5ziQBy3J2CVbLC9qDWMUl7ptjsdtLGraPwVPojYBUFexkPj/e
   5NrFYbWx6AtOIGc0dp/sOojweDow/BB+YreH/Rdb9yk+k2UGNfsQgNlco
   SFKHAnQXwxqgrPTfHtLpoVoJ5qEXQC6lmZ8E5/i0c4Cdg3QkYT16K4E26
   g==;
X-CSE-ConnectionGUID: vbcB1S/FS+KHHFPstsxPUg==
X-CSE-MsgGUID: okwomoVITj6SNuggPxl/fA==
X-IronPort-AV: E=McAfee;i="6700,10204,11206"; a="37766886"
X-IronPort-AV: E=Sophos;i="6.10,259,1719903600"; 
   d="scan'208";a="37766886"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2024 23:55:18 -0700
X-CSE-ConnectionGUID: esDBLHEwQj6ZxmNtiwE95g==
X-CSE-MsgGUID: 7wsFthauQiuFdRSlLVUZcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,259,1719903600"; 
   d="scan'208";a="76846636"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Sep 2024 23:55:18 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 25 Sep 2024 23:55:17 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 25 Sep 2024 23:55:17 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 25 Sep 2024 23:55:16 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 25 Sep 2024 23:55:16 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 25 Sep 2024 23:55:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HPnqZSu5Z/fupnM3ZiCRoTMDqF/O+OxsDC14kOBHTbxXyOOw53RWr0pSzq/egM0HcSpKYFy1e9i/7a81PZErUt3nkLRf8vNhG/gJomJtxLZjV477iyuGt6X/bvAk2c52DUkazv5PfV/Ch94Frr+hamu/J0FrjnSVf6iwl21EiPsoLRJVwWaCD6TSJnqdmThCHpz+IgaD7WvidJNk3sYZ5qUp2SWNdR+DyyYlAZ7eYXIp8xdHkFIMXzyN/ZbvDR86uH1nXTn+C+Gv26hKbo0gIAOGARSgrTYhW7nTFEtssgqKd5jYVuQmE7GYdFIh0HLGQgaoykZnMP0QKjgynAGiyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L5jlNNQAJFy7LGxkANOewOOZEzIajCdTyPy7K/LKc+k=;
 b=p6ShM3WjOr9Y3WxXL2GwzebF7EhJfkI2I9cM8PqfKbc14rOXAvnMTTsp/LkFi2iU+UAk2jc1tTHCW+9ELYK22awJM9KJQ+yNItMbZ0jIrU+55dqShKCGvhkxCzy2j2TqRYMKmYZ/70DgjZ6mKLkNI/tarKZwCf5U3XYx6W1YWsI7Jfoi7udGp2nLgAzqEOAbUamKWnXSTgD3sIUjs25NV/lA3cagX8LpmjNA8kp8yyAuGQDpz/remAgk6zj+1+HxUWOiwa2XCujD856YKG9V2ODIllL3bMXLXdzD0OvC5Lvsl9dysNoFXBJ4HKWK69cawdtIvqIQ4b8U32zDFkks4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM3PR11MB8671.namprd11.prod.outlook.com (2603:10b6:0:42::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.27; Thu, 26 Sep
 2024 06:55:06 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%6]) with mapi id 15.20.8005.021; Thu, 26 Sep 2024
 06:55:06 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Zhi Wang <zhiw@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>, Jason Gunthorpe
	<jgg@nvidia.com>, "Schofield, Alison" <alison.schofield@intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "Jiang, Dave"
	<dave.jiang@intel.com>, "dave@stgolabs.net" <dave@stgolabs.net>,
	"jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"alucerop@amd.com" <alucerop@amd.com>, "Currid, Andy" <acurrid@nvidia.com>,
	Neo Jia <cjia@nvidia.com>, Surath Mitra <smitra@nvidia.com>, Ankit Agrawal
	<ankita@nvidia.com>, Aniket Agashe <aniketa@nvidia.com>, Kirti Wankhede
	<kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	"zhiwang@kernel.org" <zhiwang@kernel.org>
Subject: RE: [RFC 00/13] vfio: introduce vfio-cxl to support CXL type-2
 accelerator passthrough
Thread-Topic: [RFC 00/13] vfio: introduce vfio-cxl to support CXL type-2
 accelerator passthrough
Thread-Index: AQHbC61f2Lb2A3OTG02PUPPHuJaIQrJlAGMwgAGgOoCAAwgA0A==
Date: Thu, 26 Sep 2024 06:55:06 +0000
Message-ID: <BN9PR11MB52764AEF07DD9B030F8996458C6A2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240920223446.1908673-1-zhiw@nvidia.com>
 <BN9PR11MB5276B821A9732BF0A9EC67988C6F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <75c0c6f1-07e4-43c1-819c-2182bdd0b47c@nvidia.com>
In-Reply-To: <75c0c6f1-07e4-43c1-819c-2182bdd0b47c@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM3PR11MB8671:EE_
x-ms-office365-filtering-correlation-id: 46684c2d-82d8-45b3-d932-08dcddf82797
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VEhEaEphdVlQT2F1TzVraXpudjFFM2xwQzVpenZHYUJhY3Y2UWdxYVpPUmdh?=
 =?utf-8?B?QWdldFZZMDAzQW5scnpjR0pPVEJoamtMZUMvZFg5dXFZZEtmRkFPTUN6NE5S?=
 =?utf-8?B?WEVaTnhROTF0WTJ3MGNWMWZUcFJWck5mOXc2cVNyRm41MXhyUDVrTnRmbVN1?=
 =?utf-8?B?dFJHQnVtS2g5MG1QcUNTeEg0YnBiakpaWFl3MCtzdXlZVTZaMmgvK2o0S1FR?=
 =?utf-8?B?ZGtEdkpQV3paMjNBQ3JXTXpNYkcwRWNSMm1iR3h6YWZoRWZVMHNnN3pqUzA1?=
 =?utf-8?B?cTFnWUZKMENpY0pDbGg2QmRZTFJWdFVPbWNlVzJMTHpNbDh6NGtWM0RlRGwz?=
 =?utf-8?B?SXhRYVhKMElHc094SEFtWGdxd3pSdk1ONzNieGN5OHEyeFlTZkZMMVhhNGNT?=
 =?utf-8?B?QmtYL0FOeFRlQU9FRXk2VWVpeC9xdExIZjF3UUQrcEFrcHdlUUxVdWgwT0Uw?=
 =?utf-8?B?cjNWRjhraXZsZWdOa2VQanh5QXN2aWl2ZTFvSjNHN0txZGtjeW1LelhEYS9n?=
 =?utf-8?B?N3FDRFhHVkhyMGoxbkNydTlaL2ZaNHNaYzVIQUxzYW1vRkI3czkyUk1hblVn?=
 =?utf-8?B?K21mUGl3aWJZRlA5MEdDT0ZiVjhva2U2aGlEQ3VTOG5VRjRlOEo5ZWh5c3k0?=
 =?utf-8?B?d3djZWR2RVNXUHZJNGJmZXZzY1czL25hdWM4NWNxaUxuc25HS2xDRXQ0ZFVi?=
 =?utf-8?B?a0VGQXBZWDY4SnRQVEZHUVhZWVJGanhzS0pVYnhJTXJBL1NLRDhNNW5WbmNk?=
 =?utf-8?B?V0FGSndxdUJsWHhIUlJCeXZId0lLL2M2dDdzYXZWVUIyRWVrMEFoM0xIN0Uw?=
 =?utf-8?B?bDhVQWhFcmRqRS9oRGQyamhqSy9uTDVZcVk5NEprSmFKREtnbEhab1FMN25p?=
 =?utf-8?B?NDBIaUp3d0RQblhubjRncFlHMFN5c05SQXQzWHRIZEsvbGNRbnUybDhxdFBI?=
 =?utf-8?B?T0Nxa3pRdjN0RUFqeGFlRUwwUU1VUWRXb2JpblNkMk1LeEk4cmhVY0YzZEdh?=
 =?utf-8?B?ZmVPczZlQkhRcGhONkpyMDBNeU82R3dZS3JtakcvWDlwa3dqczE0Zkhic2di?=
 =?utf-8?B?dGpqQmtVSE1mODhiZVJPeEMrMGptaUlFcnJCY09tSDJ1UWNwdWtXRmt4ZFN6?=
 =?utf-8?B?YW4rTnRENytBblBDaWJWRE9FNlpRaFVVSlM3NXFLcW1DdkkydE9rSEFmbkJN?=
 =?utf-8?B?UGNpOVh5Wk43Vk5KWE00MzgwTWxoSFo3U0NNbDNyeTJNZlRFeFh0cmpRZmJh?=
 =?utf-8?B?TWZlV2R2RFF6djdPRkhlQ1NqRE9wdCtCVC9oWS8vRnRsZlBpUFJkMVcxOWVN?=
 =?utf-8?B?MEN1ZGIwNWJlUU90T0N1LzlvcW1MUnhERkZOd2F6bTFLTS9VN2NsdTZvWWJq?=
 =?utf-8?B?WEtwbVlyWDl4c1FScDB5SDRjQ0JFUmtGUHY2Mis4NnJ5VmI5OXV4Z2toNC90?=
 =?utf-8?B?MHNrYkhQRVh0R0VzSjlFeVg4OG9mWEhuYjd1U1dUR3hyK25rb1NoT3FnSyto?=
 =?utf-8?B?bWloRGw5S2NvRUd5Z1BGLzNFM1laSjU2SE5MT3VpdXREQ0pnbmNQV2pXZGpT?=
 =?utf-8?B?TGoxM0VuQTJCdEtaWGVnT1NDS29rc2oxc2RoMytueXF4Mm1Ia01xNWUvbWxa?=
 =?utf-8?B?M3UrR055SFpuNWs4eXczcHpUMWRRcWtvb3dJTUdvRW4xRkgxZnlEQ3V3VHZY?=
 =?utf-8?B?bEg5VUdleHloYWc2UEk5OFVYTHhKcHhFNFhsMFdoRS8xWHJSVTA5b0lTcDhK?=
 =?utf-8?B?ZG90YVhjUWYzZ3A2TFBSZjVSWERVTHBpeUd3cnAxTDhCeEVxZXhOT2swbS9s?=
 =?utf-8?B?c2dLM2NySXJlMlhwQjF5c21WMk9DMlFaRzdMeXJkNGRhYi9pRWk4c3JYd0h3?=
 =?utf-8?B?Y0JLVkUvTTJnd2o1U0J2WlFCQXJjUktadVZkL2QrWFNOM2c9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d0VBL2tCRTNsclNTYU5GZmdObDhFVTVnaDJ5TUZIQVZ6VXZzTmZpdjV2bXov?=
 =?utf-8?B?OXRROEsyWDZIY011TjlDd1BlRDdjcTNOaUtReUZWNkVkZnkrNktMcXRUWVMz?=
 =?utf-8?B?Qzl6bDN4RlMwai9MUDVSckFOZ2ZoNWJvN0FFdXkyK3Y2cGFMdWJMLzRMazUr?=
 =?utf-8?B?dnZZNkpOM2owYjNBOHVtUldNaThxd2l1bk9tUVU1Ykg0ZXc0YncwYU4wUVQr?=
 =?utf-8?B?ekttU0Q2aU0xM09UQ015WGVyTHViOXdwckl6UVNyZE1nSklxR2ZlazRDRTlW?=
 =?utf-8?B?WXo0Q0pOWjFjYjVXd0ZUWFNZWmVJdGtsd1RISW9FRklzNDhrSCtzME1zVVJh?=
 =?utf-8?B?K1pycitaeUFuUERjdlV2ZzA4M2l3YWtaSkVFWUxQSUU5Wit0MTY5cHFqcnJ3?=
 =?utf-8?B?c2RhQkhIWFg0VStUWkVWVi9CblZMMkQrNTZWa3JwRjhBd3hWUUFIRXpRU1Jv?=
 =?utf-8?B?cmxNMjdMR1JWZU92dkFYWmZlUW42QkFwR2JnWVVERTZTR2pTQ3I4bU5JcHBm?=
 =?utf-8?B?UzV4VnoyQTM2aFdkNHRIMjRqQkd6T0RsSEwvcXpTYUk3bGZRVUp4OVRsNTBN?=
 =?utf-8?B?c0VIZjEyYXMvdE02SEwvdktlNDF0MmlGL0dyaU1xRERvbWZoVXpnTGRyNnFR?=
 =?utf-8?B?RHJma3RadXpPZVdydjBDNXUyc0dVTW5KcEVHTjR4bUVVcnYyVnUveDBzaHFL?=
 =?utf-8?B?NDZqbngzdHhRUTAwTGNIMWJkVE9jTVpFMi9DT2g2YUpxQ1ZqRDFFUU93dFJC?=
 =?utf-8?B?dHRSRkp2RmRVZmNYVVBwdFVTTGRvSTR6bm9PMFFEM0xXcTJ2Ym1QZ1YybThO?=
 =?utf-8?B?UmdUd1cralZYOEgweENTVW0wTnhQdlFVYmRHV09GdFM4bDAyRTZNY0x6WHY4?=
 =?utf-8?B?MjdHVzNzVUwyWXRnL3M0aEl5NWxlU0E4U20zNlRHc2dpSmE3ai91TkhISkJl?=
 =?utf-8?B?cnJUTU45V2VvZnpUWHB0Nzh2K0c5QkltUkpVdmJJai9oejU3T2JFaFZYQXdB?=
 =?utf-8?B?TEpPRXArUjUrYkF4Z0lKckxwdS8wWnE5SnQ2ck13emxtSVpQeEVzaExyd0dq?=
 =?utf-8?B?ZEJKVVRMb0ltYlk4UVduUm5TbkxMTzF2eG9GdmlNTDcwNHdBQ3lzenhuR0w1?=
 =?utf-8?B?aTlFa3N2MktFK3hBK0tIVlBmNHlmKzFpMnZhT1VjNW9oWU82aTFCbWZ0cG5I?=
 =?utf-8?B?SjdqWkZLa1VYUWcvN01IZFAycmdsQTdGUXlGM1BKaGRWSnV5Uy9jN082QUZm?=
 =?utf-8?B?KzlQSTVYS3lLM0VWRmxqT0tvSEJVOWlnbkd6ZGV0WkN3U0NqWXl1eUhlbEwy?=
 =?utf-8?B?a2ZnM1R2SFVaVi95RTBVZmx5S0cxVDVidkpQTHpwS25SMmRvaFNkMXovRDI2?=
 =?utf-8?B?LzR2Z3UyajE1Wk10by9oVUg2Z1A2dWp6S2d2b0tUMmxHU0svaXo1NkNJVnNh?=
 =?utf-8?B?SDM0dURuVWJ6eG1CSUdIL1I3WXRaS1hNTVFIeHlBNkFvSkFGQURvMXBLeEw4?=
 =?utf-8?B?R1Njb0VSbDBRb2VNdERZZEE4YXBqWVRhUThIMkh4T0FUL2psNXRlR0pVTWw2?=
 =?utf-8?B?cjJDK2VRVmxveXNQaHRGem8vcndRcmpSYlhINTlEQkZocGxRSUNzc1ZXeFVk?=
 =?utf-8?B?ZUFzUmlSeG5keVA3UkhEeC9uSWxKWGZ0SlR5c3B5SGtjZm9LSFQ5Z1NiclNK?=
 =?utf-8?B?Ni9lalorbHZLUW1HZ2xJYnVQMk9Ra3I5MHRUb2pWZ2kvZGk5ZWRybVMrODlB?=
 =?utf-8?B?RHZpbzNHZXR2NE44eTFheFRUTE1MMXZSMGtjZ0tMRFcxWCttbDBtL2dkcjBV?=
 =?utf-8?B?bXkvUkkveU1TeGhOdUVMWFFpQkhwQytIaloxekoyb3kyOVY1UmozWE5KcmFj?=
 =?utf-8?B?b0IwUzR5bmE5aHk5dXQ1Mm1UV0J0aWRQNXpJL1NPUHltR3RCb1ptMjN5SjZl?=
 =?utf-8?B?WkZpcjBlajJESHBKZ2h6cXRNVm0xbVhlSlBsTFJSOUJ3WmxhM3lJVFZKMzEz?=
 =?utf-8?B?RElJVHllaGxTckxUVDB1d0cwZ1I3RWlXQkZYZFlYdzg0TzlFcGNmcTI0TFNy?=
 =?utf-8?B?ZVllYjJLVElqeHpreWpGbzRZdC9KNlVpK1BETnhZamx6YUpEYnNENVdXWGRX?=
 =?utf-8?Q?1pSTTsekGK/6wZoBJr652gb69?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 46684c2d-82d8-45b3-d932-08dcddf82797
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2024 06:55:06.5571
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y6H0EWQOLpA2Qv9bFabV/q3c7sYuRavrXw+uAYGTNHMQfYdCxS4LjInkA7WQ27xG9SbZ7CSELOQxfX0RqDfgpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8671
X-OriginatorOrg: intel.com

PiBGcm9tOiBaaGkgV2FuZyA8emhpd0BudmlkaWEuY29tPg0KPiBTZW50OiBUdWVzZGF5LCBTZXB0
ZW1iZXIgMjQsIDIwMjQgNDozMCBQTQ0KPiANCj4gT24gMjMvMDkvMjAyNCAxMS4wMCwgVGlhbiwg
S2V2aW4gd3JvdGU6DQo+ID4gRXh0ZXJuYWwgZW1haWw6IFVzZSBjYXV0aW9uIG9wZW5pbmcgbGlu
a3Mgb3IgYXR0YWNobWVudHMNCj4gPg0KPiA+DQo+ID4+IEZyb206IFpoaSBXYW5nIDx6aGl3QG52
aWRpYS5jb20+DQo+ID4+IFNlbnQ6IFNhdHVyZGF5LCBTZXB0ZW1iZXIgMjEsIDIwMjQgNjozNSBB
TQ0KPiA+Pg0KPiA+IFsuLi5dDQo+ID4+IC0gQ3JlYXRlIGEgQ1hMIHJlZ2lvbiBhbmQgbWFwIGl0
IHRvIHRoZSBWTS4gQSBtYXBwaW5nIGJldHdlZW4gSFBBIGFuZCBEUEENCj4gPj4gKERldmljZSBQ
QSkgbmVlZHMgdG8gYmUgY3JlYXRlZCB0byBhY2Nlc3MgdGhlIGRldmljZSBtZW1vcnkgZGlyZWN0
bHkuIEhETQ0KPiA+PiBkZWNvZGVycyBpbiB0aGUgQ1hMIHRvcG9sb2d5IG5lZWQgdG8gYmUgY29u
ZmlndXJlZCBsZXZlbCBieSBsZXZlbCB0bw0KPiA+PiBtYW5hZ2UgdGhlIG1hcHBpbmcuIEFmdGVy
IHRoZSByZWdpb24gaXMgY3JlYXRlZCwgaXQgbmVlZHMgdG8gYmUgbWFwcGVkIHRvDQo+ID4+IEdQ
QSBpbiB0aGUgdmlydHVhbCBIRE0gZGVjb2RlcnMgY29uZmlndXJlZCBieSB0aGUgVk0uDQo+ID4N
Cj4gPiBBbnkgdGltZSB3aGVuIGEgbmV3IGFkZHJlc3Mgc3BhY2UgaXMgaW50cm9kdWNlZCBpdCdz
IHdvcnRoeSBvZiBtb3JlDQo+ID4gY29udGV4dCB0byBoZWxwIHBlb3BsZSB3aG8gaGF2ZSBubyBD
WEwgYmFja2dyb3VuZCBiZXR0ZXIgdW5kZXJzdGFuZA0KPiA+IHRoZSBtZWNoYW5pc20gYW5kIHRo
aW5rIGFueSBwb3RlbnRpYWwgaG9sZS4NCj4gPg0KPiA+IEF0IGEgZ2xhbmNlIGxvb2tzIHdlIGFy
ZSB0YWxraW5nIGFib3V0IGEgbWFwcGluZyB0aWVyOg0KPiA+DQo+ID4gICAgR1BBLT5IUEEtPkRQ
QQ0KPiA+DQo+ID4gVGhlIGxvY2F0aW9uL3NpemUgb2YgSFBBL0RQQSBmb3IgYSBjeGwgcmVnaW9u
IGFyZSBkZWNpZGVkIGFuZCBtYXBwZWQNCj4gPiBhdCBAb3Blbl9kZXZpY2UgYW5kIHRoZSBIUEEg
cmFuZ2UgaXMgbWFwcGVkIHRvIEdQQSBhdCBAbW1hcC4NCj4gPg0KPiA+IEluIGFkZGl0aW9uIHRo
ZSBndWVzdCBhbHNvIG1hbmFnZXMgYSB2aXJ0dWFsIEhETSBkZWNvZGVyOg0KPiA+DQo+ID4gICAg
R1BBLT52RFBBDQo+ID4NCj4gPiBJZGVhbGx5IHRoZSB2RFBBIHJhbmdlIHNlbGVjdGVkIGJ5IGd1
ZXN0IGlzIGEgc3Vic2V0IG9mIHRoZSBwaHlzaWNhbA0KPiA+IGN4bCByZWdpb24gc28gYmFzZWQg
b24gb2Zmc2V0IGFuZCB2SERNIHRoZSBWTU0gbWF5IGZpZ3VyZSBvdXQNCj4gPiB3aGljaCBvZmZz
ZXQgaW4gdGhlIGN4bCByZWdpb24gdG8gYmUgbW1hcGVkIGZvciB0aGUgY29ycmVzcG9uZGluZw0K
PiA+IEdQQSAod2hpY2ggaW4gdGhlIGVuZCBtYXBzIHRvIHRoZSBkZXNpcmVkIERQQSkuDQo+ID4N
Cj4gPiBJcyB0aGlzIHVuZGVyc3RhbmRpbmcgY29ycmVjdD8NCj4gPg0KPiANCj4gWWVzLiBNYW55
IHRoYW5rcyB0byBzdW1tYXJpemUgdGhpcy4gSXQgaXMgYSBkZXNpZ24gZGVjaXNpb24gZnJvbSBh
DQo+IGRpc2N1c3Npb24gaW4gdGhlIENYTCBkaXNjb3JkIGNoYW5uZWwuDQo+IA0KPiA+IGJ0dyBp
cyBvbmUgY3hsIGRldmljZSBvbmx5IGFsbG93ZWQgdG8gY3JlYXRlIG9uZSByZWdpb24/IElmIG11
bHRpcGxlDQo+ID4gcmVnaW9ucyBhcmUgcG9zc2libGUgaG93IHdpbGwgdGhleSBiZSBleHBvc2Vk
IHRvIHRoZSBndWVzdD8NCj4gPg0KPiANCj4gSXQgaXMgbm90IGFuIChzaG91bGRuJ3QgYmUpIGVu
Zm9yY2VkIHJlcXVpcmVtZW50IGZyb20gdGhlIFZGSU8gY3hsIGNvcmUuDQo+IEl0IGlzIHJlYWxs
eSByZXF1aXJlbWVudC1kcml2ZW4uIEkgYW0gZXhwZWN0aW5nIHdoYXQga2luZCBvZiB1c2UgY2Fz
ZXMNCj4gaW4gcmVhbGl0eSB0aGF0IG5lZWRzIG11bHRpcGxlIENYTCByZWdpb25zIGluIHRoZSBo
b3N0IGFuZCB0aGVuIHBhc3NpbmcNCj4gbXVsdGlwbGUgcmVnaW9ucyB0byB0aGUgZ3Vlc3QuDQo+
IA0KPiBQcmVzdW1hYmx5LCB0aGUgaG9zdCBjcmVhdGVzIG9uZSBsYXJnZSBDWEwgcmVnaW9uIHRo
YXQgY292ZXJzIHRoZSBlbnRpcmUNCj4gRFBBLCB3aGlsZSBRRU1VIGNhbiB2aXJ0dWFsbHkgcGFy
dGl0aW9uIGl0IGludG8gZGlmZmVyZW50IHJlZ2lvbnMgYW5kDQo+IG1hcCB0aGVtIHRvIGRpZmZl
cmVudCB2aXJ0dWFsIENYTCByZWdpb24gaWYgUUVNVSBwcmVzZW50cyBtdWx0aXBsZSBIRE0NCj4g
ZGVjb2RlcnMgdG8gdGhlIGd1ZXN0Lg0KDQpub24tY3hsIGd1eXMgaGF2ZSBubyBpZGVhIGFib3V0
IHdoYXQgYSByZWdpb24gaXMgYW5kIGhvdyBpdCBpcyBhc3NvY2lhdGVkDQp0byB0aGUgYmFja2lu
ZyBoYXJkd2FyZSByZXNvdXJjZSwgZS5nLiBpdCdzIGNyZWF0ZWQgYnkgc29mdHdhcmUgdGhlbg0K
d2hlbiB0aGUgdmlydHVhbCBDWEwgZGV2aWNlIGlzIGNvbXBvc2VkIGhvdyBpcyB0aGF0IHNvZnR3
YXJlLWRlY2lkZWQNCnJlZ2lvbiB0cmFuc2xhdGVkIGJhY2sgdG8gYSBzZXQgb2YgdmlydHVhbCBD
WEwgaHcgcmVzb3VyY2UgZW51bWVyYWJsZQ0KdG8gdGhlIGd1ZXN0LCBldGMuDQoNCkluIHlvdXIg
ZGVzY3JpcHRpb24sIFFFTVUsIGFzIHRoZSB2aXJ0dWFsIHBsYXRmb3JtLCBtYXAgdGhlIFZGSU8g
Q1hMDQpyZWdpb24gaW50byBkaWZmZXJlbnQgdmlydHVhbCBDWEwgcmVnaW9ucy4gVGhpcyBraW5k
IG9mIHN1Z2dlc3RzIHJlZ2lvbnMNCmFyZSBjcmVhdGVkIGJ5IGh3LCBjb25mbGljdGluZyB3aXRo
IHRoZSBwb2ludCBoYXZpbmcgc3cgY3JlYXRlIGl0Lg0KDQpXZSBuZWVkIGEgZnVsbHkgcGljdHVy
ZSB0byBjb25uZWN0IHJlbGV2YW50IGtub3dsZWRnZSBwb2ludHMgaW4gQ1hMDQpzbyB0aGUgcHJv
cG9zYWwgY2FuIGJlIGJldHRlciByZXZpZXdlZCBpbiB0aGUgVkZJTyBzaWRlLiDwn5iKDQoNCj4g
DQo+ID4+DQo+ID4+IC0gQ1hMIHJlc2V0LiBUaGUgQ1hMIGRldmljZSByZXNldCBpcyBkaWZmZXJl
bnQgZnJvbSB0aGUgUENJIGRldmljZSByZXNldC4NCj4gPj4gQSBDWEwgcmVzZXQgc2VxdWVuY2Ug
aXMgaW50cm9kdWNlZCBieSB0aGUgQ1hMIHNwZWMuDQo+ID4+DQo+ID4+IC0gRW11bGF0aW5nIENY
TCBEVlNFQ3MuIENYTCBzcGVjIGRlZmluZXMgYSBzZXQgb2YgRFZTRUNzIHJlZ2lzdGVycyBpbiB0
aGUNCj4gPj4gY29uZmlndXJhdGlvbiBmb3IgZGV2aWNlIGVudW1lcmF0aW9uIGFuZCBkZXZpY2Ug
Y29udHJvbC4gKEUuZy4gaWYgYSBkZXZpY2UNCj4gPj4gaXMgY2FwYWJsZSBvZiBDWEwubWVtIENY
TC5jYWNoZSwgZW5hYmxlL2Rpc2FibGUgY2FwYWJpbGl0eSkgVGhleSBhcmUgb3duZWQNCj4gPj4g
YnkgdGhlIGtlcm5lbCBDWEwgY29yZSwgYW5kIHRoZSBWTSBjYW4gbm90IG1vZGlmeSB0aGVtLg0K
PiA+DQo+ID4gYW55IHNpZGUgZWZmZWN0IGZyb20gZW11bGF0aW5nIGl0IHB1cmVseSBpbiBzb2Z0
d2FyZSAocGF0Y2gxMCksIGUuZy4gd2hlbg0KPiA+IHRoZSBndWVzdCBkZXNpcmVkIGNvbmZpZ3Vy
YXRpb24gaXMgZGlmZmVyZW50IGZyb20gdGhlIHBoeXNpY2FsIG9uZT8NCj4gPg0KPiANCj4gVGhp
cyBzaG91bGQgYmUgd2l0aCBhIHN1bW1hcnkgYW5kIGxhdGVyIGJlIGRlY2lkZWQgaWYgbWVkaWF0
ZSBwYXNzDQo+IHRocm91Z2ggaXMgbmVlZGVkLiBJbiB0aGlzIFJGQywgaXRzIGdvYWwgaXMganVz
dCB0byBwcmV2ZW50IHRoZSBndWVzdCB0bw0KPiBtb2RpZnkgcFJlZ3MuDQoNCkxvb2sgZm9yd2Fy
ZCB0byB0aGF0IGluZm9ybWF0aW9uIGluIGZ1dHVyZSBwb3N0aW5nLg0KDQo+IA0KPiA+Pg0KPiA+
PiAtIEVtdWxhdGUgQ1hMIE1NSU8gcmVnaXN0ZXJzLiBDWEwgc3BlYyBkZWZpbmVzIGEgc2V0IG9m
IENYTCBNTUlPIHJlZ2lzdGVycw0KPiA+PiB0aGF0IGNhbiBzaXQgaW4gYSBQQ0kgQkFSLiBUaGUg
bG9jYXRpb24gb2YgcmVnaXN0ZXIgZ3JvdXBzIHNpdCBpbiB0aGUgUENJDQo+ID4+IEJBUiBpcyBp
bmRpY2F0ZWQgYnkgdGhlIHJlZ2lzdGVyIGxvY2F0b3IgaW4gdGhlIENYTCBEVlNFQ3MuIFRoZXkg
YXJlIGFsc28NCj4gPj4gb3duZWQgYnkgdGhlIGtlcm5lbCBDWEwgY29yZS4gU29tZSBvZiB0aGVt
IG5lZWQgdG8gYmUgZW11bGF0ZWQuDQo+ID4NCj4gPiBkaXR0bw0KPiA+DQo+ID4+DQo+ID4+IElu
IHRoZSBMMiBndWVzdCwgYSBkdW1teSBDWEwgZGV2aWNlIGRyaXZlciBpcyBwcm92aWRlZCB0byBh
dHRhY2ggdG8gdGhlDQo+ID4+IHZpcnR1YWwgcGFzcy10aHJ1IGRldmljZS4NCj4gPj4NCj4gPj4g
VGhlIGR1bW15IENYTCB0eXBlLTIgZGV2aWNlIGRyaXZlciBjYW4gc3VjY2Vzc2Z1bGx5IGJlIGxv
YWRlZCB3aXRoIHRoZQ0KPiA+PiBrZXJuZWwgY3hsIGNvcmUgdHlwZTIgc3VwcG9ydCwgY3JlYXRl
IENYTCByZWdpb24gYnkgcmVxdWVzdGluZyB0aGUgQ1hMDQo+ID4+IGNvcmUgdG8gYWxsb2NhdGUg
SFBBIGFuZCBEUEEgYW5kIGNvbmZpZ3VyZSB0aGUgSERNIGRlY29kZXJzLg0KPiA+DQo+ID4gSXQn
ZCBiZSBnb29kIHRvIHNlZSBhIHJlYWwgY3hsIGRldmljZSB3b3JraW5nIHRvIGFkZCBjb25maWRl
bmNlIG9uDQo+ID4gdGhlIGNvcmUgZGVzaWduLg0KPiANCj4gVG8gbGV2ZXJhZ2UgdGhlIG9wcG9y
dHVuaXR5IG9mIEYyRiBkaXNjdXNzaW9uIGluIExQQywgSSBwcm9wb3NlZCB0aGlzDQo+IHBhdGNo
c2V0IHRvIHN0YXJ0IHRoZSBkaXNjdXNzaW9uIGFuZCBtZWFud2hpbGUgb2ZmZXJlZCBhbiBlbnZp
cm9ubWVudA0KPiBmb3IgcGVvcGxlIHRvIHRyeSBhbmQgaGFjayBhcm91bmQuIEFsc28gcGF0Y2hl
cyBpcyBnb29kIGJhc2UgZm9yDQo+IGRpc2N1c3Npb24uIFdlIHNlZSB3aGF0IHdlIHdpbGwgZ2V0
LiA6KQ0KPiANCj4gVGhlcmUgYXJlIGRldmljZXMgYWxyZWFkeSB0aGVyZSBhbmQgb24tZ29pbmcu
IEFNRCdzIFNGQyAocGF0Y2hlcyBhcmUNCj4gdW5kZXIgcmV2aWV3KSBhbmQgSSB0aGluayB0aGV5
IGFyZSBnb2luZyB0byBiZSB0aGUgZmlyc3QgdmFyaWFudCBkcml2ZXINCj4gdGhhdCB1c2UgdGhl
IGNvcmUuIE5WSURJQSdzIGRldmljZSBpcyBhbHNvIGNvbWluZyBhbmQgTlZJRElBJ3MgdmFyaWFu
dA0KPiBkcml2ZXIgaXMgZ29pbmcgdXBzdHJlYW0gZm9yIHN1cmUuIFBsdXMgdGhpcyBlbXVsYXRl
ZCBkZXZpY2UsIEkgYXNzdW1lDQo+IHdlIHdpbGwgaGF2ZSB0aHJlZSBpbi10cmVlIHZhcmlhbnQg
ZHJpdmVycyB0YWxrcyB0byB0aGUgQ1hMIGNvcmUuDQo+IA0KDQpZZWFoLCB0aGlzIHNvdW5kcyBh
IGdyZWF0IGZpcnN0IHN0ZXAhDQo=

