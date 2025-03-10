Return-Path: <kvm+bounces-40544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 277A3A58B27
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 05:11:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B28377A525D
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 04:10:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 335171BD9C9;
	Mon, 10 Mar 2025 04:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NKNpezOO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC4128F5
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 04:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741579898; cv=fail; b=Ko7ou7A5WmWue5n5Njp3o3khPLR4cZge2wLccDXJIdnHDQmN62hATLO+zGcgj10zwkfC5t80iBpAltZ2aUpFfiEIiSHme411Iku63btWoo5/yzxCJyNaRDn76FrHIku3zRpeSQvcjBBNkzN92HBsZrEb2cfVGobO5TCYW0nu00c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741579898; c=relaxed/simple;
	bh=IuzQIuUaBmSY8BriZAKO9zD2W36fdvs4tFfTIb32K6k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RXLr5NyP7RormBUyWnDcn1mFZkT8+0m9Hc88/DF+8eBlxJ4B0f2k4xwAug/5ZbSFVUg2ZQ6pcmN+UNKH9xtRGV8YY3MjLTmjmiZwW/DQAAupHoAZHWrV3HrgQJ1GcE+47dccmbiISWNIxi2yRJFasGkWYQ3OQjfBD8ejDw9DIZw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NKNpezOO; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741579897; x=1773115897;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IuzQIuUaBmSY8BriZAKO9zD2W36fdvs4tFfTIb32K6k=;
  b=NKNpezOOkZLjf0u83MMeOCq1eQ2ccONkqU1lKQukOCZfhMrmm8D1BL1W
   eYzmMal+fY8Eo6xGRXYfkCZR4wnLlO1NPc0GPHe0+prKKBr6Kx9QoUJzc
   8djVfuaSm0a/c1HDxgvKpYWSXEH80mG1e2JObUK2KMF9Z5aZnjkX5qqaT
   ipZorFrGbQLibT3WZIbw184zlQaxLc8PFiqMxAgxoz3X2olnXOEswKyKV
   s3VGgDVXMSeOhhB9UVJcv2ag36in2puey69dEKd8l5pN6wYA57Il+Mjn4
   037waJXxRMsi8rr+m6LFCxQTgALywKi6kL7OKEMnQ8ssuehrpe0+vWPgA
   w==;
X-CSE-ConnectionGUID: OsCNi84HTnqJg6ZXI7NhdA==
X-CSE-MsgGUID: HhpIVC+gTm2QZyjreda2Kw==
X-IronPort-AV: E=McAfee;i="6700,10204,11368"; a="42672742"
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="42672742"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2025 21:11:36 -0700
X-CSE-ConnectionGUID: 9wIKKp9IT+CwX49qnFo/Vg==
X-CSE-MsgGUID: 3/62N00yTv2rXqZwXdQh9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="150815505"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Mar 2025 21:11:34 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Sun, 9 Mar 2025 21:11:33 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 9 Mar 2025 21:11:33 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 9 Mar 2025 21:11:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FbJtFFQP4Dk5gIhmbYxQO00eLWs7EWWdZLAzCLf7UtA6+xPl/MnPpRU3sju4/45Cnf0842KKYDy30Jh0aRYltSJhQYpykGKz8jCefKhqNhi+tLa00M1T1bEofACc0R14LEVrOUmMnfIBriGG55ty06u/GMDGWniCxaBBrH7viPoapuionqHaPijysqRZ5Vqt4h02DC70ck+n6ksQvJA+u9V8LObU5eEHeMhc6ikaiN1i7Z82uhsn8GQKEPSakyZQThQJA12SeHkjvJd657MtWzCAuiY/zNe7Y0uk6TpHsYSCNTJWyycR1of7vHDuN66NBsHKzaVhqMOldgx/yvUCkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ie0nCQZUI2hUoyaUQ/1PGsNfei62p3zVTaG4fSS9gPQ=;
 b=TTA1rJkweU3hBEUpW/D6gdbAnTOmzAvQ4yj3kfKbMSBCUkQckw+1r7f8mW1TzKtZj6lclWz2hVMpz2M+uuJA1GE1hRSvixF0R3S4QVA6JzUQ8iwdIwz8VsoGMnoqpEdD6JyraGhIlfaqMh6iuu8d6ESvSa2h+ypURQXAjtTFxZ8rxtJyAwDP6c1tQN5Z8nxJ15P6UxpCE8vaLrNtoVYoVc775BIXNhJcL/1YmxSHAqPHehVOWc/PuXujVGbg1Z7plurkz59hCoIKM+LkVwHKWkZNg+vl9MD7CQ7+uw42TniCTdJ/M/y1VzJsNQYOtmGO4KSSZoDoaKxFHXDKJmDfuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB6744.namprd11.prod.outlook.com (2603:10b6:a03:47d::10)
 by DS7PR11MB6248.namprd11.prod.outlook.com (2603:10b6:8:97::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.26; Mon, 10 Mar
 2025 04:11:15 +0000
Received: from SJ0PR11MB6744.namprd11.prod.outlook.com
 ([fe80::fe49:d628:48b1:6091]) by SJ0PR11MB6744.namprd11.prod.outlook.com
 ([fe80::fe49:d628:48b1:6091%6]) with mapi id 15.20.8511.025; Mon, 10 Mar 2025
 04:11:15 +0000
From: "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
To: =?iso-8859-1?Q?Philippe_Mathieu-Daud=E9?= <philmd@linaro.org>,
	"qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
CC: "Liu, Yi L" <yi.l.liu@intel.com>, Pierrick Bouvier
	<pierrick.bouvier@linaro.org>, Alex Williamson <alex.williamson@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	=?iso-8859-1?Q?Alex_Benn=E9e?= <alex.bennee@linaro.org>, Tony Krowiak
	<akrowiak@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>, Halil Pasic
	<pasic@linux.ibm.com>, Thomas Huth <thuth@redhat.com>, David Hildenbrand
	<david@redhat.com>, Igor Mammedov <imammedo@redhat.com>, Matthew Rosato
	<mjrosato@linux.ibm.com>, Tomita Moeko <tomitamoeko@gmail.com>,
	"qemu-ppc@nongnu.org" <qemu-ppc@nongnu.org>, Daniel Henrique Barboza
	<danielhb413@gmail.com>, Eric Farman <farman@linux.ibm.com>, Eduardo Habkost
	<eduardo@habkost.net>, Peter Xu <peterx@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "qemu-s390x@nongnu.org" <qemu-s390x@nongnu.org>, "Eric
 Auger" <eric.auger@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "Harsh
 Prateek Bora" <harshpb@linux.ibm.com>, =?iso-8859-1?Q?C=E9dric_Le_Goater?=
	<clg@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>, Jason Herne
	<jjherne@linux.ibm.com>, =?iso-8859-1?Q?Daniel_P=2E_Berrang=E9?=
	<berrange@redhat.com>, Richard Henderson <richard.henderson@linaro.org>
Subject: RE: [PATCH v2 15/21] hw/vfio/pci: Check CONFIG_IOMMUFD at runtime
 using iommufd_builtin()
Thread-Topic: [PATCH v2 15/21] hw/vfio/pci: Check CONFIG_IOMMUFD at runtime
 using iommufd_builtin()
Thread-Index: AQHbkH9n6UTdqDYxnk2KS04mTYbprbNrsnsw
Date: Mon, 10 Mar 2025 04:11:15 +0000
Message-ID: <SJ0PR11MB67449BEA0E3B4A04E603633C92D62@SJ0PR11MB6744.namprd11.prod.outlook.com>
References: <20250308230917.18907-1-philmd@linaro.org>
 <20250308230917.18907-16-philmd@linaro.org>
In-Reply-To: <20250308230917.18907-16-philmd@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB6744:EE_|DS7PR11MB6248:EE_
x-ms-office365-filtering-correlation-id: ec1eb3da-0e30-49b6-df1d-08dd5f8999f1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?iso-8859-1?Q?7hyw4Ci8hGTPuNpv5Ac7xAzhjMdLKZrIhCRknpP/YwkPB8F8mAgi1capyE?=
 =?iso-8859-1?Q?jT+iWVMW7MFduRXVf4tZjK/GYqnUsef4YbvUVlY/BQN6VBbb8QJ1czQgQu?=
 =?iso-8859-1?Q?9ybwiwgc8UnPvmfPhrDryCRY8weplIJB1jhumcvjItFgjIM2m/0pv4W/0w?=
 =?iso-8859-1?Q?ER0W5q5bPCRGbJmxbHGdyj/Tcw9C3xhBGX9/me6TgzpkSTTegIg4WHPGix?=
 =?iso-8859-1?Q?vUBUvzWqfaYuVXuoQRrOLe+Cky/kFQ9cwAOBL12b62YWlDpYI5cf8zTsxz?=
 =?iso-8859-1?Q?Et6f5lFRzdx1kVQLZ2zZjmu3hJp/f03gP5hjrAn/hMpcftnUkEQyT5wrkr?=
 =?iso-8859-1?Q?p1tX+zTCGerSRtlzsE4M0OpoaM+47vz+ae6QdgjCe9G1jIZmcKGH5QWRRS?=
 =?iso-8859-1?Q?yLW1BQeiuXx5rwM8Iihy33gvx1fo5teygjh6PED0JjOyLOemdp3RuU3lK3?=
 =?iso-8859-1?Q?LM7vCaEWVNojGCydKLOQGvPYViMJqkJHEbmDa6RkGBclWsfv//IFx7CDQR?=
 =?iso-8859-1?Q?J0S6YHGZFXZqt7I1YtGYAKtnUyFj0GJccTGQirJuEL0Lnly335kVVPJ5iX?=
 =?iso-8859-1?Q?y/qL3YFzjhemgSQ1SPfVHUvNx3myqCRgl6afauNAzOHRUYyH49fCavntNz?=
 =?iso-8859-1?Q?Dk5N2UMRKAc4M17E0O2Iacy4rOSRACyFL7nMOGVF70nETQM/9uCwACg9DP?=
 =?iso-8859-1?Q?sMy6Zc8UT1EW5Liqv2+hLS4bFmxLdUfiZDyNlQgngsFtKGueLZxsB8fI2J?=
 =?iso-8859-1?Q?LTnFYxW9OAx0a4ycVr4MGxVuSgxeJAD0IqDpqExZbXpAlaPkv0EAFNsK7e?=
 =?iso-8859-1?Q?ilXXLLgY2XNmn9+749Q8bTLAGbFHgs85PLsmbZLdx8nz4GGz0mez3K2ayb?=
 =?iso-8859-1?Q?ylZSJCPvdLjFScT2VJ4aWE8zUdH/j9zv4XwtIFj79zyC0khayah3MxICq+?=
 =?iso-8859-1?Q?YS3RVyFAto/w8KIg+YpHbG1EC08UaeuauahNbo9eQYtPhjQV/WG05Ayctc?=
 =?iso-8859-1?Q?vSt3oG18cHGRfAjUdNvUYyIFWkT3qeEvkXkWcTLQ59vNzeHigE1tzbl6f5?=
 =?iso-8859-1?Q?al6iEJo0H6jAG9Ln2YK2Txn9JabrWJtAdqbny5SRkqjSG3d14TPkf3DiNb?=
 =?iso-8859-1?Q?hUMNJDPBeSnRPNasbTIJLeVESR4DsZU5deshY+wV+othTRr98ebbT2aRjZ?=
 =?iso-8859-1?Q?52oTlzp5450ngxhHJs9si/LNjnjRQFhDsQN8qJMZSSYW7+6KPXdswWWYr3?=
 =?iso-8859-1?Q?HzvCFv6fya46kscgDMOgnA5iP7H7nl6EMRcrHYrTpfoQjPr4OQ8VjufqUN?=
 =?iso-8859-1?Q?QjKIi2Yvi+zbKQnKXSNwv8j7WH4Nv381PdeaKA2Dx+72Ochut2KQYg43hY?=
 =?iso-8859-1?Q?yzPk/Ib8/yA0YmKV30maxggg0W2dZEjqVBaycY7BPZ/hDSt4aY+cckb/Vs?=
 =?iso-8859-1?Q?kO7akvE257bny/KXEp+hG/iU62P9ekXoyIAZqU98bEJKb5LUDx24VCE++p?=
 =?iso-8859-1?Q?CFi5PqvM6XTUcy5f+Clf+1?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB6744.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?bLSyES1w4CE5IOLP+5nAgKYO9tTpN3avX1tD1cadI+M+2vYsVevRDRYpWw?=
 =?iso-8859-1?Q?h9O8HaJY6dXstN/t/MW/NbxOageL5XS/4Tex/hOcHEldMFsYxL5pfwiQW9?=
 =?iso-8859-1?Q?f9M9MJ1+H+HmGBRuVS+Mo210opzSk/3HvdTgokOBsI5kcn/8sZLyCMbjI2?=
 =?iso-8859-1?Q?I2+XPTDkdOERDoamsqz3IvlEW7DT6bOcvZx6XTjlWHgrOyCVgy167tqtuh?=
 =?iso-8859-1?Q?1mAxeNp4W5zubmCfY6zsGrQOahYrhUb6NxlXTYsIT99rLLhRHE9XJ6HDwY?=
 =?iso-8859-1?Q?nEGcaL3C6OElDh86jgYMA1UqN5CbMRTFzjb79cwAvQzIk40U2NCaS6s44M?=
 =?iso-8859-1?Q?lj8bdfCibSikVa5drAWzc71KdwEYJoPljZyQBmzKDdszWJZ68khD4pvaYo?=
 =?iso-8859-1?Q?14a6EZbD4VSpw8nRFoTAP7FHo3SyUPP+NpkY03HQt+SZP1FTaevrWPNBkt?=
 =?iso-8859-1?Q?RtiO5e5tytZeHJ+gKirSv/lqSX0l1X41rLMkFPal6b8VjmAlTchJnlv7f+?=
 =?iso-8859-1?Q?SCh5aqUzG+bnfYTfab89lCnwj+sTXOtjzbCu7vBYsoXHdlg1RC5imtcS7W?=
 =?iso-8859-1?Q?38mmKxQZqtOvuJTtE/hZeZd96C0y9DLlmnP3MXNwkMZVVBM/4Nx2/H9lhl?=
 =?iso-8859-1?Q?8SywPoVTYQBBQeks8xlWuiv7lCUuhUujJCzETKCpMPkrnH2xYBG2Wu+elh?=
 =?iso-8859-1?Q?hn8VyMjGMIiIqd0olloiaouMIHenGQ7J92xMYQlz50wN7SSB+1WDHlvr26?=
 =?iso-8859-1?Q?kOVzgF54dxSBKcAu+lGA2Q/Dcysprfdx/85bNuJQtfuIG4gxSIrwPxo+up?=
 =?iso-8859-1?Q?qZATfPOqH3T5oSD83APcXcmoIHv9+N4UpmfpWwbeKYVqv5u80di1bo88dn?=
 =?iso-8859-1?Q?kUhgaBOwHs3H0QZeNAqwA2+dHDjhTFroIaNdsxNgRg3R8Wd67g8f93AI4k?=
 =?iso-8859-1?Q?jc8SXPYIupbLu3gc0wrNf4Bioynk/b9cfaOOxd+bdFE29PClWLRcHXHnfN?=
 =?iso-8859-1?Q?riiLFozNlBaFYGc4HPQPKjgLQwP3dlAjmWe/tG0vsG//pSqvJaUuE6QNKl?=
 =?iso-8859-1?Q?svKhjl78eh//j9C6ogTorVbSSYKWacIeqKN4Ty1kOnDe5n8vz4Z2W60xUz?=
 =?iso-8859-1?Q?mGZPpr+08x/w8oAJKBrcJxOWmlsY3shPBCS1eqVOptnzUZdK2QouYnyrr8?=
 =?iso-8859-1?Q?i2ckSGDes7qi5/RwBX3MIBX3B/RhF+0ZJbT317wroIT+RzjvD5zBCXNeVU?=
 =?iso-8859-1?Q?UjhZD1A82sAbn23fIkhrRRl+i5b4IKSeg4MvZnIJ/9JyqP24kkhGQcu0AG?=
 =?iso-8859-1?Q?kctQ+kunKCblaDFXKz0OLNDR5BNo32omA6p7DUUOPyL7sZh88WnqNQuIU8?=
 =?iso-8859-1?Q?26m8CRP6tD5wq9ribIrg6Kp4OP/ra0HCBCkHkwAukLYfV4VvGmZukqxJMT?=
 =?iso-8859-1?Q?kxgVUTsadFYetFIrPnIK62ZO+j2T4YwPc56NPjk6nJm8dyCW1HXE4LK9nR?=
 =?iso-8859-1?Q?d5OdrNwo9xTOnJV7gQxOuG8C3a1CJs1b+XCg0BWV3w7Dv72uptSD8Xabmx?=
 =?iso-8859-1?Q?JsxLMkV3qmR1AsokLk7MKYMY6xNDxUpVL0TAs/tzdB04UL7B24dZRP9x7/?=
 =?iso-8859-1?Q?GVkRHtmubt3R7X0TcbbW3DbvBIhF1X7l5E?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB6744.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec1eb3da-0e30-49b6-df1d-08dd5f8999f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2025 04:11:15.4080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lW/LrUUFLoEk63oOQ+0RbqqFNHOW+IlcirVJEXl+oKtoJOTbhjRDiQq1D1OKuKOZLWI+HbC65b1Dq57CHEHnf0OZTnxjl/m5eCEwsZ7swfA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6248
X-OriginatorOrg: intel.com

Hi Philippe,

>-----Original Message-----
>From: Philippe Mathieu-Daud=E9 <philmd@linaro.org>
>Subject: [PATCH v2 15/21] hw/vfio/pci: Check CONFIG_IOMMUFD at runtime
>using iommufd_builtin()
>
>Convert the compile time check on the CONFIG_IOMMUFD definition
>by a runtime one by calling iommufd_builtin().
>
>Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
>Signed-off-by: Philippe Mathieu-Daud=E9 <philmd@linaro.org>
>---
> hw/vfio/pci.c | 38 ++++++++++++++++++--------------------
> 1 file changed, 18 insertions(+), 20 deletions(-)
>
>diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
>index 9872884ff8a..e83252766d1 100644
>--- a/hw/vfio/pci.c
>+++ b/hw/vfio/pci.c
>@@ -19,7 +19,6 @@
>  */
>
> #include "qemu/osdep.h"
>-#include CONFIG_DEVICES /* CONFIG_IOMMUFD */
> #include <linux/vfio.h>
> #include <sys/ioctl.h>
>
>@@ -2973,11 +2972,10 @@ static void vfio_realize(PCIDevice *pdev, Error
>**errp)
>         if (!(~vdev->host.domain || ~vdev->host.bus ||
>               ~vdev->host.slot || ~vdev->host.function)) {
>             error_setg(errp, "No provided host device");
>-            error_append_hint(errp, "Use -device vfio-pci,host=3DDDDD:BB:=
DD.F "
>-#ifdef CONFIG_IOMMUFD
>-                              "or -device vfio-pci,fd=3DDEVICE_FD "
>-#endif
>-                              "or -device vfio-pci,sysfsdev=3DPATH_TO_DEV=
ICE\n");
>+            error_append_hint(errp, "Use -device vfio-pci,host=3DDDDD:BB:=
DD.F %s"
>+                              "or -device vfio-pci,sysfsdev=3DPATH_TO_DEV=
ICE\n",
>+                              iommufd_builtin()
>+                              ? "or -device vfio-pci,fd=3DDEVICE_FD " : "=
");
>             return;
>         }
>         vbasedev->sysfsdev =3D
>@@ -3412,19 +3410,18 @@ static const Property vfio_pci_dev_properties[] =
=3D {
>                                    qdev_prop_nv_gpudirect_clique, uint8_t=
),
>     DEFINE_PROP_OFF_AUTO_PCIBAR("x-msix-relocation", VFIOPCIDevice,
>msix_relo,
>                                 OFF_AUTO_PCIBAR_OFF),
>-#ifdef CONFIG_IOMMUFD
>-    DEFINE_PROP_LINK("iommufd", VFIOPCIDevice, vbasedev.iommufd,
>-                     TYPE_IOMMUFD_BACKEND, IOMMUFDBackend *),
>-#endif
>     DEFINE_PROP_BOOL("skip-vsc-check", VFIOPCIDevice, skip_vsc_check, tru=
e),
> };
>
>-#ifdef CONFIG_IOMMUFD
>+static const Property vfio_pci_dev_iommufd_properties[] =3D {
>+    DEFINE_PROP_LINK("iommufd", VFIOPCIDevice, vbasedev.iommufd,
>+                     TYPE_IOMMUFD_BACKEND, IOMMUFDBackend *),
>+};
>+
> static void vfio_pci_set_fd(Object *obj, const char *str, Error **errp)
> {
>     vfio_device_set_fd(&VFIO_PCI(obj)->vbasedev, str, errp);
> }
>-#endif
>
> static void vfio_pci_dev_class_init(ObjectClass *klass, void *data)
> {
>@@ -3433,9 +3430,10 @@ static void vfio_pci_dev_class_init(ObjectClass *kl=
ass,
>void *data)
>
>     device_class_set_legacy_reset(dc, vfio_pci_reset);
>     device_class_set_props(dc, vfio_pci_dev_properties);
>-#ifdef CONFIG_IOMMUFD
>-    object_class_property_add_str(klass, "fd", NULL, vfio_pci_set_fd);
>-#endif
>+    if (iommufd_builtin()) {
>+        device_class_set_props(dc, vfio_pci_dev_iommufd_properties);

device_class_set_props() is called twice. Won't it break qdev_print_props()=
 and qdev_prop_walk()?

Thanks
Zhenzhong

