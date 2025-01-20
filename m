Return-Path: <kvm+bounces-35948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A9A6AA166E0
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 08:05:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3724E1887AEE
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 07:05:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6847918B47C;
	Mon, 20 Jan 2025 07:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ApyXLFlT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27C735968;
	Mon, 20 Jan 2025 07:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737356738; cv=fail; b=o2VD49F+UKFaNlhCgaGAe5sQgGiYEUYjz0CSgTsXkNUVPB7xx9tBiBJ2bZty/noh1/x+1nKgkGJhDPjFQJP2kNUisH3U8gwk/UVobfreA3k723oLKy/+F8RaWNVd9lw/BlKpz2WqQ7Ww+QFNkNjLruxMyjHUIY0mOXKW1xzOItw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737356738; c=relaxed/simple;
	bh=B5bywPvCOpDJbOfiOQm3B32e+zX2O4+WGuLGuJENDMo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IBT9qGTimzeKw3MIXybmyMQJQHAynrttHWPXEFymb5C86JvdsIU45YmCj7Xr9m/gx0h8vTApnr8p/Kum6GVZE4jBSyuP12I0rnRjciWX8zU7h+AV3ojingOypmZb0AT8Ofif+t2I8bmBL/EDEztHxrDzQbuz8m0mmF3GSY21qw0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ApyXLFlT; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737356737; x=1768892737;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=B5bywPvCOpDJbOfiOQm3B32e+zX2O4+WGuLGuJENDMo=;
  b=ApyXLFlT95ItC39diWEBJWmreYrySewoFDwWKaE1g8BlL2iHNeu8pKwz
   oLbTrbjd1TpDoRcULA2m9CLuqcjhFBPwsjSBT05IiBdkq7mS8hhQ2vBgb
   q+1s9gbQu18dlbROKC+2tdd1W/zkTNfuFxPj2GUjVJlRM/6Z+tmx5LN8h
   hcLIaV6oY0lZ+h5vWq2X7udYwALeTKBRIe5WfF4+IBBaBlvYxuPFzUrFD
   nUnc216sDh+w5o0/jKrUeGJ5RooDbvFaas0mckZgvZjiYm3tPDRHZGa0H
   Bn5Y1mVzhGumvsDBOtiL/0q9axgTvHr8t1L3dNKE1+CgML2krSQyatRvO
   Q==;
X-CSE-ConnectionGUID: TcLKInPdT1yGwxtl9hsOiQ==
X-CSE-MsgGUID: Md9y4EZzS5iIc2pjPxegHQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11320"; a="41482367"
X-IronPort-AV: E=Sophos;i="6.13,218,1732608000"; 
   d="scan'208";a="41482367"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2025 23:05:36 -0800
X-CSE-ConnectionGUID: NSYl8AUGTuCDzhtKjgLTZw==
X-CSE-MsgGUID: G4qSWGZxTnOAPm+gI3HG6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,218,1732608000"; 
   d="scan'208";a="106237910"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Jan 2025 23:05:36 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Sun, 19 Jan 2025 23:05:35 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Sun, 19 Jan 2025 23:05:35 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 19 Jan 2025 23:05:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qgLELuuCjAMoogcgZpp+sByFXUIGHQuhlc4KxzHLGxpV55eRf5yvRn63oddzmEokBs8ujavHTkc2399A/O8P48Rv++dtRX+/JzGJzoNWtUbP30afN7D5HKm6A2reVkzARqg+uNNCajn8c4QuPeRa+weqNTue31VwN+tyn0w8EB22+Flaam/I+9T+VKxkSd4jnZxIn9NSP+cLV+GYiG0RoOTv4XO+JK/pocWpxumsIIB+w/O2ijUFPTN9rVBHXG3GOIKDH9iAKX6um6rsNniumvoAP5N6uDHr5EsBfcVNHA3FHf8oMN16MTvOpYjH/JC5YdggeojMR6K4uyOOJGR/NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B5bywPvCOpDJbOfiOQm3B32e+zX2O4+WGuLGuJENDMo=;
 b=sQFM/Yk4D3K6ZPIFUoyCdu7d8OtAnuHbAXzrB9jhPqRgNoe9nSesWdgn24ZPYvhZI6VxZvcqv38Wy4Ajxr4yDeL56M5LmopKn42yVjYCT+j22XVvweVh1tgyNoZh+dmJ42sVrkcNSfqNhPauFylHMQHXF5N5FnsUnZNkKnOquDHga16OJIoBDnARiE99JgvamIp/DfI6RamIGEbnLR7wjNyT4rBBmsdQ6DbKvVm7ZWdJzvi9lO5ZFG+I1PFAvBr/eJRyN6iveFabb9PicU2I7kaDjWCEmaPxbG1hZq4NW+MQX0jxp9m1sEDPCrydXefPuXKZTVxT3RF+PD6fxD4h9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CH3PR11MB8186.namprd11.prod.outlook.com (2603:10b6:610:15a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Mon, 20 Jan
 2025 07:04:58 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%7]) with mapi id 15.20.8356.020; Mon, 20 Jan 2025
 07:04:53 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>, Ankit Agrawal
	<ankita@nvidia.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, Zhi Wang <zhiw@nvidia.com>, "Aniket
 Agashe" <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti Wankhede
	<kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>, "Sethi,
 Vikram" <vsethi@nvidia.com>, "Currid, Andy" <acurrid@nvidia.com>, "Alistair
 Popple" <apopple@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, "Dan
 Williams" <danw@nvidia.com>, "Anuj Aggarwal (SW-GPU)"
	<anuaggarwal@nvidia.com>, Matt Ochs <mochs@nvidia.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 3/3] vfio/nvgrace-gpu: Check the HBM training and C2C
 link status
Thread-Topic: [PATCH v4 3/3] vfio/nvgrace-gpu: Check the HBM training and C2C
 link status
Thread-Index: AQHbaTjPPGrRnACRgEOvzAscEKPwbbMbxNQAgAMthQCAAA1/AIAAAuMAgAA9CbA=
Date: Mon, 20 Jan 2025 07:04:53 +0000
Message-ID: <BN9PR11MB52767422419163F89D0DEC458CE72@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20250117233704.3374-1-ankita@nvidia.com>
	<20250117233704.3374-4-ankita@nvidia.com>
	<20250117205232.37dbabe3.alex.williamson@redhat.com>
	<SA1PR12MB7199DB6748D147F434404629B0E72@SA1PR12MB7199.namprd12.prod.outlook.com>
	<20250119201232.04af85b2.alex.williamson@redhat.com>
 <20250119202252.4fcd2c49.alex.williamson@redhat.com>
In-Reply-To: <20250119202252.4fcd2c49.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CH3PR11MB8186:EE_
x-ms-office365-filtering-correlation-id: d9a85433-219e-47a7-0833-08dd3920bd53
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TnBhMkRhR2UyNXdsQU5MQS9aR0wxWHlHREc1Q2VMbzhQTit1WVZjVVJna0xo?=
 =?utf-8?B?dXdDc2pLZ0J5UVNwcFp5M1JUUVBkeWlMYnk2VXU5dndwclNHV0E2azRod01V?=
 =?utf-8?B?NnJ2RVFlR2NYb0tVbGdwVUxXQTMza1Y0NGkwZmlTMTJKcERFVGgzOTJUaFpk?=
 =?utf-8?B?NzNOMU1HUGJ1dUpaM0RtbnZCWTBhanFlWmNBRjB2UjZxSkZWVkZ5RFduQzZJ?=
 =?utf-8?B?MDl0WHc4UDlGTVYxZmVLZWN1dUtubnRaeTRIYTJFT0hSNzVzeXdsdllCYkFo?=
 =?utf-8?B?a2YzdFVJRCtNTFVlOS85ZkMzOTUvOFk3OUxNekZ2THZXTHg2UjNxM1BLT3p1?=
 =?utf-8?B?M01rYWx0YmFpN29rdHNpZkgraCtBTElwY1Rzc2pDMUtYeWZ1YzdtNng0T2Vj?=
 =?utf-8?B?a1JOZTZaYldxc21NQWhmcFd4ZDY5cHpYMCtCL0FKMjRYU2gxcHozaGJVdEV5?=
 =?utf-8?B?M2NwOUFFZm9sLzh1dDFHRklUam1XbEErZExHTEFEK0JXYlRaKzdUdlVuWVRn?=
 =?utf-8?B?d3dTMGlXT3ZRYVpTK1E5MG9wNnIvWTZ6Ty9yRDhUVnp3UDBlSWxvWWtQK3ow?=
 =?utf-8?B?TkJxZ2hLay9Oc1k0VHVVS2RqbzB6OHFsdTVzTFhEclFIRTl4cEU4d244MnpG?=
 =?utf-8?B?dEsycUg5NjN1ZWpNNE8yTUpmT1dZN3NzMHNHQzFaY0wvK0VWRklad2llY044?=
 =?utf-8?B?T3lNcnlqTXJZczU1bEl0aEkyT21SM3BOSTI4TDB2dndheGh0RDJ2dTh3TitP?=
 =?utf-8?B?OGRuV2kwdEtuNitwd2YzVkg2MGVDdGxmbklRWkMyV1FBWCtybE1DWGQ1U3Ji?=
 =?utf-8?B?R3Myc1NkakdlZkZrUFdTRzM3clhkWm93WUFzNEVWVlBzMEQzc3plNjZmcGoy?=
 =?utf-8?B?UFNCVXZLbWJUdlFGME9QKzlocGxmKzVDcFBhRzliMHJHTm1Fcy9OYjA0eE5D?=
 =?utf-8?B?d0FncFlOcFIrSHBHaTk1TElodWFjRE1PazVpUlZUdHBJUFR0dXFiZXJHcnl5?=
 =?utf-8?B?SUVYZVIvN0dEeVhtekU1bU1Td0ZFenVEZ21HQ2ZKSlpsdkllcUhQMGVGYWhX?=
 =?utf-8?B?QnNHUGJDZUFobmZKOGxCU0tPblZZMC9hV3h5bHNRdzNqQ2lCOWRiNzF1Ui9v?=
 =?utf-8?B?YTJiZnB4TWFTbndQTFFicFU3M1VBM0U4T1YrWExPckZIbEN4b0JLNEdGUE1Q?=
 =?utf-8?B?aUhBOHFycTFoZVVWMG13ZFhVdzJ2c2NycG1hNGJkWlJVTno4QlBISEtTUXJj?=
 =?utf-8?B?STNacTZnMFQ0TTZyZnNrQ0QyUE01SWU5UEZZR0tTNGoxNzl5bDFDZlVaWUZw?=
 =?utf-8?B?eEhUa09veVEyYlRxZmhMbklVT3ZzT2VMTlhPZGM5SWdYM0tkdWI2cEFKV0dt?=
 =?utf-8?B?VWM4Y3BmZ3VMK2pzT3R6azNnRnJ3VzYvS21XVDBUY2FSNTBQZW5IdFJ5T0Rv?=
 =?utf-8?B?SnRwakJ1SVN0SWplVTFIM3JhL3ovQXRPK3F5MGxaR3V0TzRvdE9MOHNqUjBQ?=
 =?utf-8?B?K2NET0pxYUJ4WkQ5ZVJ0UkpzUHljdUFhSUZEcXBzL3c3dzF1UVdxb1lqL2Jn?=
 =?utf-8?B?Q3N5d3dCc2VBVjEwL3R1U3lKdWVwVHAzVDVNWmVhZVE4SHVpaGxFNndoWVc4?=
 =?utf-8?B?NEozdTNlNC81cnUzeHhyQjkyRTF6Q1B3c0lLbTV4SUVIVHp1bG9hcWFtVXhs?=
 =?utf-8?B?SkpUOUoraHhYL1ZheDRRLzdSenRmaVl3M1VMQXdoRGs1d2NudGxoNkNYZGVW?=
 =?utf-8?B?YTVneEdvSWRVQkUzaFdjOEx5d0wweUtwbzREcmVrSlFPS3hhdHNmOTVadmZZ?=
 =?utf-8?B?Q1BiUzFHeU5OZDVSdUdKWGhtMXJVYVFkTTRSRWFTMGl3ZDJKbXBSVWFaRDVp?=
 =?utf-8?B?SkROdk96QUdETFVPRWpCeEppODQvK3IwVVNUWEg0N1RWdE1RanFrV2RxeFZp?=
 =?utf-8?Q?Fk0t9Dd1VyT2ZHZEuXp+Y8O4P/asZ/+W?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T0hjQXpUM2NINDZxUDlNZkVzbm5OWW5KUC85RkZuOFZXZFVUVisvUVQrV0Ru?=
 =?utf-8?B?b0VJQnZVRW9vR2ZoejlXUUpSUGJseHNTWGt1ajRrb2hLejlTQUxSWmN6RTVM?=
 =?utf-8?B?MDFqWVB3b1lsalZEaGs2SUV0ZWpCYW5mNVVNUTFpRm5leWRvMk1jNk5FYTAz?=
 =?utf-8?B?TWNGMWZ6OWxBbFhxOGp4aU8ySVU0YjBldktFbzQyZFVrWXpXSW04Y2xMOEox?=
 =?utf-8?B?MlNwVkVKeWk4UlZWc014ajdQL3ZqS1Jyb2tmTkdBZW1XTUdiL2FkSkVLSlVn?=
 =?utf-8?B?K3M4cnJ4eG1rU293eXU5OHJpTVJreExhTncvWklNV01jeFpobnM0R3NOK2g3?=
 =?utf-8?B?d3ZlcnE1M2poWWhqbHVFcFZTc3QweEVUb0tpdXVqT2k0aEhhQVhMQmV4U1R4?=
 =?utf-8?B?N0xtbVBQaEhGcnMydDk0cTNJK2JtR2dHWXRRakNtZXZMZlJQcHdPY2NIT1Jl?=
 =?utf-8?B?dzVJckduaFdzcElRZ0E4bEVkRWpUV0diekNYM0hEWnMwWTJmaDVUZzFsTW40?=
 =?utf-8?B?eEZwZW9jRDJ5d0tnMkhUcnV0TG9HS29GcSs4c2Q3WkFSdVdVeEE5SDkzUzJD?=
 =?utf-8?B?SWlNOU9SQ3FLY3JZYkFzUTBLQ2srZFVvMXZZOStCR1ZNTWxMRlc4aGVVdGpR?=
 =?utf-8?B?cjArdnYrcmQ0eEw4c204Q0lrZmp6NFUrY0JJKzYwNUZyQTBhZG05NFlISnM0?=
 =?utf-8?B?NXJwYVBHZTlGcDZ1L2tZdlZZT29SalJrcGc0NS9LZktRS0s0MFpjdVN6L25I?=
 =?utf-8?B?UkdjOXN5cEZsZGxPaXZNVk5FdUlub3JKT3FUbmVSSTQxUW1KU2wzcHYvc0Ni?=
 =?utf-8?B?RmQxVXBmdnExRFJXRk5VMUt3dFNkV0pUWUtJSWZNQ0dBLy9HWXpMdW1JMmVY?=
 =?utf-8?B?cUZNMVh6MGZ0NTBLdllrYVJIQWFzRFYwZ0J4Ukx3VWNrY3huREdsSklGMXRi?=
 =?utf-8?B?MS81MmtrRDMzWUt5Tlo5a0lVQzBBOTFwM0hZUlNlS01HWUhFNk5GVlA3Yk9L?=
 =?utf-8?B?cGs1bDlCN3o2S05MWmQvUTh3R1EvM3ZJMGwrTmMvNVdlaHVIU1RRT2ZaNGEz?=
 =?utf-8?B?OXdjWEhjYmZtZGxpaDQrZzlJMWppK2dUQXZwYytHSlhvUWhHMnRpZ2VIeU0y?=
 =?utf-8?B?VjBCVWg0aEo4YTh2czZDTmxldm9pWDZyNmxCMUpJTXgxZ1oyNElMVzZkdE9Q?=
 =?utf-8?B?TjJPbURUMDF3WHZFM0lSVExwREtPbnhDRDN4YVNPUEsxTXFjY2pvSUZzanhJ?=
 =?utf-8?B?VE00Wkl1UUlhR3BIa2srOWs2OWJXMk0wSmREQndGYVpSemRuR3o2NG43Z2Js?=
 =?utf-8?B?b0JBK1pjZmd6OG9GODZDdnZKdnRxTmlucndOcmNFdW5mUWRkd25WbzVHbkhL?=
 =?utf-8?B?K1VYaUw4TnZTWUYzemVSRGZPdGdqM3BYT001NVV2V2FmL1Q3MVFCMXN0Qkh0?=
 =?utf-8?B?OU8zYzdubjFoUEY4SkNsK3dTMitKYWdFNmRaUkUvdWxuUGxhYUZneUtiK2J6?=
 =?utf-8?B?dWNFVUZ5M3JJajNBdk5pcERES0F3T0pkYzNBSWlkNk9IODhpbkk1UDZ6ZUMv?=
 =?utf-8?B?LzhMSzVnMnVmUklHYXptYXRUZXh1NC83ckhvWmw4TUJidDFyK09ZdXNQOThI?=
 =?utf-8?B?WkVLVmRHYzlSSGlySXV2aUd0MHJ2MTNqajJGNWNVT0M5RzdnYW5Jdmd1azg0?=
 =?utf-8?B?cXZ1RmxkVGtOZDFvL1NMR1dtUHZITVh0aVhXSzZHdk1QOE1rZm8vV3RsemNx?=
 =?utf-8?B?SzFZa0FSbXpZZEx2SlBncDVrK0J6RjEzMU8wRXl6UG9PcU8xNWZwaFQxMVBQ?=
 =?utf-8?B?bkV4ejJWUnRDUCt6Rmg1bDVZMlFuMnN5aEtmUWliR1hUcXQ5YmkxZzd1TEJk?=
 =?utf-8?B?cVZVS254MGdWY05pN0xTL2RRbFVFOHF1OGVodkNFL3NzMVlIaEVLQkszcTF2?=
 =?utf-8?B?WGo4N0lRbzJlaXNFRjdUOHJpNktOaFNGZjRuZS9UVlpkMjFSRk9mRi9obXhD?=
 =?utf-8?B?YVpXTGxGSURsV0xQTkNEZUs4SkdzUUlpRENrN0JTS1JodE5pUkR6VWNCU1hI?=
 =?utf-8?B?QklTdFlxQ3pOaThTQ2ZTY2hSTFAvRlR2M1FLWTdvZUF1Q1ZYQzNRVVE4VXMx?=
 =?utf-8?Q?2jW2/AxgMapE32GIBRahmEmKV?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d9a85433-219e-47a7-0833-08dd3920bd53
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2025 07:04:53.4148
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6FqooILPhID7mEa8vVpWMDgkATJqN7TGrcrQiv1SoaBukcF3WHrGdj8O2e3bKffgHiVvIJg5uA6/xmrT6BZ3mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8186
X-OriginatorOrg: intel.com

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBNb25kYXksIEphbnVhcnkgMjAsIDIwMjUgMTE6MjMgQU0NCj4gDQo+IE9uIFN1biwgMTkg
SmFuIDIwMjUgMjA6MTI6MzIgLTA3MDANCj4gQWxleCBXaWxsaWFtc29uIDxhbGV4LndpbGxpYW1z
b25AcmVkaGF0LmNvbT4gd3JvdGU6DQo+IA0KPiA+IE9uIE1vbiwgMjAgSmFuIDIwMjUgMDI6MjQ6
MTQgKzAwMDANCj4gPiBBbmtpdCBBZ3Jhd2FsIDxhbmtpdGFAbnZpZGlhLmNvbT4gd3JvdGU6DQo+
ID4NCj4gPiA+ID4+ICtFWFBPUlRfU1lNQk9MX0dQTCh2ZmlvX3BjaV9tZW1vcnlfbG9ja19hbmRf
ZW5hYmxlKTsNCj4gPiA+ID4+DQo+ID4gPiA+PsKgIHZvaWQgdmZpb19wY2lfbWVtb3J5X3VubG9j
a19hbmRfcmVzdG9yZShzdHJ1Y3QNCj4gdmZpb19wY2lfY29yZV9kZXZpY2UgKnZkZXYsIHUxNiBj
bWQpDQo+ID4gPiA+PsKgIHsNCj4gPiA+ID4+wqDCoMKgwqDCoMKgIHBjaV93cml0ZV9jb25maWdf
d29yZCh2ZGV2LT5wZGV2LCBQQ0lfQ09NTUFORCwgY21kKTsNCj4gPiA+ID4+wqDCoMKgwqDCoMKg
IHVwX3dyaXRlKCZ2ZGV2LT5tZW1vcnlfbG9jayk7DQo+ID4gPiA+PsKgIH0NCj4gPiA+ID4+ICtF
WFBPUlRfU1lNQk9MX0dQTCh2ZmlvX3BjaV9tZW1vcnlfdW5sb2NrX2FuZF9yZXN0b3JlKTsNCj4g
PiA+ID4+DQo+ID4gPiA+PsKgIHN0YXRpYyB1bnNpZ25lZCBsb25nIHZtYV90b19wZm4oc3RydWN0
IHZtX2FyZWFfc3RydWN0ICp2bWEpDQo+ID4gPiA+PsKgIHsNCj4gPiA+ID4NCj4gPiA+ID4gVGhl
IGFjY2VzcyBpcyBoYXBwZW5pbmcgYmVmb3JlIHRoZSBkZXZpY2UgaXMgZXhwb3NlZCB0byB0aGUg
dXNlciwgdGhlDQo+ID4gPiA+IGFib3ZlIGFyZSBmb3IgaGFuZGxpbmcgY29uZGl0aW9ucyB3aGls
ZSB0aGVyZSBtYXkgYmUgcmFjZXMgd2l0aCB1c2VyDQo+ID4gPiA+IGFjY2VzcywgdGhpcyBpcyB0
b3RhbGx5IHVubmVjZXNzYXJ5Lg0KPiA+ID4NCj4gPiA+IFJpZ2h0LiBXaGF0IEkgY291bGQgZG8g
dG8gcmV1c2UgdGhlIGNvZGUgaXMgdG8gdGFrZSBvdXQgdGhlIHBhcnQNCj4gPiA+IHJlbGF0ZWQg
dG8gbG9ja2luZy91bmxvY2tpbmcgYXMgbmV3IGZ1bmN0aW9ucyBhbmQgZXhwb3J0IHRoYXQuDQo+
ID4gPiBUaGUgY3VycmVudCB2ZmlvX3BjaV9tZW1vcnlfbG9ja19hbmRfZW5hYmxlKCkgd291bGQg
dGFrZSB0aGUgbG9jaw0KPiA+ID4gYW5kIGNhbGwgdGhlIG5ldyBmdW5jdGlvbi4gU2FtZSBmb3IN
Cj4gdmZpb19wY2lfbWVtb3J5X3VubG9ja19hbmRfcmVzdG9yZSgpLg0KPiA+ID4gVGhlIG52Z3Jh
Y2UgbW9kdWxlIGNvdWxkIGFsc28gY2FsbCB0aGF0IG5ldyBmdW5jdGlvbi4gRG9lcyB0aGF0IHNv
dW5kDQo+ID4gPiByZWFzb25hYmxlPw0KPiA+DQo+ID4gTm8sIHRoaXMgaXMgc3RhbmRhcmQgUENJ
IGRyaXZlciBzdHVmZiwgZXZlcnl0aGluZyB5b3UgbmVlZCBpcyBhbHJlYWR5DQo+ID4gdGhlcmUu
ICBQcm9iYWJseSBwY2lfZW5hYmxlX2RldmljZSgpIGFuZCBzb21lIHZhcmlhbnQgb2YNCj4gPiBw
Y2lfcmVxdWVzdF9yZWdpb25zKCkuDQo+ID4NCj4gPiA+ID4gRG9lcyB0aGlzIGRlbGF5IGV2ZW4g
bmVlZCB0byBoYXBwZW4gaW4gdGhlIHByb2JlIGZ1bmN0aW9uLCBvciBjb3VsZCBpdA0KPiA+ID4g
PiBoYXBwZW4gaW4gdGhlIG9wZW5fZGV2aWNlIGNhbGxiYWNrP8KgIFRoYXQgd291bGQgc3RpbGwg
YmUgYmVmb3JlIHVzZXINCj4gPiA+ID4gYWNjZXNzLCBidXQgaWYgd2UgZXhwZWN0IGl0IHRvIGdl
bmVyYWxseSB3b3JrLCBpdCB3b3VsZCBhbGxvdyB0aGUNCj4gPiA+ID4gdHJhaW5pbmcgdG8gaGFw
cGVuIGluIHRoZSBiYWNrZ3JvdW5kIHVwIHVudGlsIHRoZSB1c2VyIHRyaWVzIHRvIG9wZW4NCj4g
PiA+ID4gdGhlIGRldmljZS7CoCBUaGFua3MsDQo+ID4gPiA+DQo+ID4gPiA+IEFsZXgNCj4gPiA+
DQo+ID4gPiBUaGUgdGhvdWdodCBwcm9jZXNzIGlzIHRoYXQgc2luY2UgaXQgaXMgcHVyZWx5IGJh
cmUgbWV0YWwgY29taW5nIHRvIHByb3Blcg0KPiA+ID4gc3RhdGUgd2hpbGUgYm9vdCwgdGhlIG52
Z3JhY2UgbW9kdWxlIHNob3VsZCBwcm9iYWJseSB3YWl0IGZvciB0aGUNCj4gc3RhcnR1cA0KPiA+
ID4gdG8gY29tcGxldGUgZHVyaW5nIHByb2JlKCkgaW5zdGVhZCBvZiBkZWxheWluZyB1bnRpbCBv
cGVuKCkgdGltZS4NCj4gPg0KPiA+IElmIHRoZSBkcml2ZXIgaXMgc3RhdGljYWxseSBsb2FkZWQs
IHRoYXQgbWlnaHQgbWVhbiB5b3UncmUgd2lsbGluZyB0bw0KPiA+IHN0YWxsIGJvb3QgZm9yIHVw
IHRvIDMwcy4gIEluIHByYWN0aWNlIGlzIHRoaXMgZXZlciBhY3R1YWxseSBnb2luZyB0bw0KPiA+
IGZhaWw/ICBUaGFua3MsDQo+IA0KPiBPbiBzZWNvbmQgdGhvdWdodCwgSSBndWVzcyBhIHZmaW8t
cGNpIHZhcmlhbnQgZHJpdmVyIGNhbid0DQo+IGF1dG9tYXRpY2FsbHkgYmluZCB0byBhIGRldmlj
ZSwgd2hldGhlciBzdGF0aWNhbGx5IGJ1aWx0IG9yIG5vdCwgc28NCj4gbWF5YmUgdGhpcyBpc24n
dCBhIGNvbmNlcm4uICBJJ20gbm90IHN1cmUgaWYgdGhlcmUgYXJlIG90aGVyIGNvbmNlcm5zDQo+
IHdpdGggYnVzeSB3YWl0aW5nIGZvciB1cCB0byAzMHMgYXQgZHJpdmVyIHByb2JlLiAgVGhhbmtz
LA0KPiANCg0KQ2FuIHRoaXMgd2FpdCBiZSBsZWZ0IHRvIHVzZXJzcGFjZSBpLmUuIHRoZSB2YXJp
YW50IGRyaXZlciBqdXN0IGRvZXMNCm9uZS1vZmYgY2hlY2sgYW5kIGZhaWwgdGhlIHByb2JlIGlm
IHRoZSBkZXZpY2UgaXMgbm90IHJlYWR5PyBOdmlkaWENCmNhbiBkZXNjcmliZSB0aGUgcmVxdWly
ZW1lbnQgdGhhdCB0aGUgYWRtaW5pc3RyYXRvciBtYXkgbmVlZCB0bw0Kd2FpdCBmb3IgMzBzIHRv
IHJldHJ5IGRyaXZlciBwcm9iZSBpZiB0aGUgMXN0IGF0dGVtcHQgZmFpbHMuLi4NCg==

