Return-Path: <kvm+bounces-25884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E06296BF35
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 15:56:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 46E8928A545
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 13:56:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 464511DA108;
	Wed,  4 Sep 2024 13:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dTeuVA2y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F4D1D679F;
	Wed,  4 Sep 2024 13:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725458185; cv=fail; b=cRXYjAS9qyiYyjyiMgwi/Z2ViUv0l50DTPYbB/l69qnTfcCEHnN6kNMcAU45CP+OjPG23ULFB/krITlxz3elPTG363w5EZ4dZYObw26fyWc+e2hHTxIjWgalLz4VhQARfifBP76823Lbw0SwqHuDVVZb169ee9LtKku3fiTNJcI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725458185; c=relaxed/simple;
	bh=bNa1TL5XyN6X54Eas3af1R9TGVVsO7HBknZRXBFUTbw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JJr96bGgiFjG9bQbmt7iksZ3WmFFtIjMnTUaxsQCyMJdfUiBQjOmSwcH1TMBKpS8D8b27zaj4NxjjQikezekeqoKc/GYnUvM6bMJRpHTVAS4VTuvX2Vy9gujqEfpZyJt9sptHs9PlNDYgMv7yWNB5alIJEBZPDA+NYH0M+NUGS0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dTeuVA2y; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725458184; x=1756994184;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=bNa1TL5XyN6X54Eas3af1R9TGVVsO7HBknZRXBFUTbw=;
  b=dTeuVA2yhqaP4WV60EnFovv546SY6Pl/JmGuwEY3Xg3ubekjPaAyI4c0
   Bs/Si9P13Inl1w98DKpeXiHuzYS6AytQ7iJ2IuXkk/qZdH67wCfDFSEvw
   pvYuzygP5X3wUsjwTgpQGor9TTZrZ7IbJ1kzSkrLL6Ck+6MzHW+SdgOEy
   DYSdQTLGhg1ZLir0kGlTexyiATOFUYe6E1hesiyE8XWSBEyoaf1Zv/uv0
   jqzqXhgAcOdLgX7b2v8HAGlKuQpClGkHxqAAw+21Nr/znGDjzl7tGQC34
   WVxgD1rBCXIwGfYJA2vhrW0pZrTE/pvrEpkSt+Z8CsjzRp+LAZACHHUMb
   A==;
X-CSE-ConnectionGUID: 6mDXOHGhTYK3fdySquEOTA==
X-CSE-MsgGUID: iwsPW6qQSMGO7hXi43rn1w==
X-IronPort-AV: E=McAfee;i="6700,10204,11185"; a="41592938"
X-IronPort-AV: E=Sophos;i="6.10,202,1719903600"; 
   d="scan'208";a="41592938"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2024 06:56:23 -0700
X-CSE-ConnectionGUID: vvleOHuUSe2mPIc82nSfZA==
X-CSE-MsgGUID: 2/fHHOLqRfSMQAVss2ErRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,202,1719903600"; 
   d="scan'208";a="65798505"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Sep 2024 06:56:24 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 4 Sep 2024 06:56:22 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 4 Sep 2024 06:56:22 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 4 Sep 2024 06:56:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fxku4MtvN0FEX5yljN0MjBF9e1d4fpyspOGj2A3CV7Ma27d4rCGT8dtE4v8K3EPJoO5T/8PfoCVA+VHluWEW3RDwRa8NuUYLXKTOOiwZyz5nmosYZ9ULAfDJML55R+szoSLRShVBRiGiTeOKvASTIjxwHq05MXVjE06b3L+W+MRPUrsP3YFPdMx3AiFx8NLppF9SqsO5sS5XTL1/0QsNyiX8NV7WEe/qW9L2tz/ja51ZwYIyBBovwpQq0+SJXSmUrkRiT5QUymJR3/u4MKVCX1BA2rDMYFSBLRPEg8jUNqKtsW0cp6Mw1SsxWAWZCp3Kb3jdJEmblz2bdGUxSAXciA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bNa1TL5XyN6X54Eas3af1R9TGVVsO7HBknZRXBFUTbw=;
 b=B6dhTEEguBAfUvNCTvMRd/JyzeTqei7la52neduZaIWJN+sCS/d2D5PRIAUsGlqhOMrgh4fgaIrt7RZ0FT9YpH2Vuozu5uireQhWOmjkHrIt2KLEigutWdjcDh5xhryAtpGcSmqcHV9vC+ajJ3ejWY6KfyyvnWSqpQUUa554d+ONKmuRcl4HTtKDKNUMSPJ3Aysd4LlfFRAhm1nOTKi0tK/z+luCI0a1eHI3QlRUZ/dhIqs05Ndcpeqv8m/SjZe5ms/9ljJtjV3oo/Wlzd67Xzdt5rHsIpjdn2PnbcC2lDBhOssHDUxNfSB+tDhSnzNrPhDPIhd/L4DFQCQLWG5mng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB8262.namprd11.prod.outlook.com (2603:10b6:806:26e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23; Wed, 4 Sep
 2024 13:56:20 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.7918.024; Wed, 4 Sep 2024
 13:56:20 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "dmatlack@google.com" <dmatlack@google.com>, "Huang,
 Kai" <kai.huang@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 19/21] KVM: TDX: Add an ioctl to create initial guest
 memory
Thread-Topic: [PATCH 19/21] KVM: TDX: Add an ioctl to create initial guest
 memory
Thread-Index: AQHa/ne7pTzhAEMIUUeBkR4uOlaw8bJHp3+A
Date: Wed, 4 Sep 2024 13:56:20 +0000
Message-ID: <85754805bef1cdbe6079ab549935fee4ec310a62.camel@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
	 <20240904030751.117579-20-rick.p.edgecombe@intel.com>
In-Reply-To: <20240904030751.117579-20-rick.p.edgecombe@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB8262:EE_
x-ms-office365-filtering-correlation-id: c4542c5f-3b36-47c5-872e-08dccce95af4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?U0RLQllNNVRlM3VvR0o4NW1URVBMMjdwYWg1bUlMVVpMUzNoeEVxeVMyNWo3?=
 =?utf-8?B?ZTBMaHlRZWFiakc3RGdvMXRGU0Z5YW5UdkNhYzYyVkFnMnVLVGFCUXdHejc1?=
 =?utf-8?B?VFRyYWpRcDdkVUdtSUxsSlNCZ3diQVJQb2pNTEtua3BCUzJ5aGx6NlFIMEpn?=
 =?utf-8?B?N2U0UDQ0ZjFJdjhEWDZQRU9FZDIxa28xMkdsbUMxYW55QWVoMFVaVVhkVy9m?=
 =?utf-8?B?MlA5bm5pL2xHZ1NmaEFtWkQ0bTJtem5yS1gwbnBicjBIM1AwN25VekE2bkhh?=
 =?utf-8?B?dTNPNm1ZMVFlYXdhdUNwYzV5TDBsWHpyU3hqZytFazR5eHducFR3MnhQeTN5?=
 =?utf-8?B?Q1FYM0pMbFovbTlwc2VURFpaTlRJdUFGQnVCRUFiUzkyUVpIUHRGVDYrRkR1?=
 =?utf-8?B?MWZ1NmVHU1RZbGFycEk0SHEzRWdPdUh4UVlUQzJEdzVDQ3RMR3FteVN1ZitB?=
 =?utf-8?B?Z2xxZy9wd0FQWVpJM3VNYkFrMHJTcDVaVzVIYUptNTRtbGk0KzZ5RUZ5UVVa?=
 =?utf-8?B?c01LSWR1U1ZnUTc3NEN0NG1mMXIzSTkrTUhLdnZzcDdmRTN0M3lmQmVmZ1Zv?=
 =?utf-8?B?L0VGS2hNMDVjU1lmUzR4MkNvcE5FZmtGR0RldWZybTVuVXYzek44UEc3Q1FM?=
 =?utf-8?B?VGxrQ1VaTm53WDlpMHhNYVFPL29QelFQREgrbklJR2ZYWXNiOXJoZFRXdlNw?=
 =?utf-8?B?eWZUS2RLWmtpU1h0YjhpVURHWEw4K1htc0pqKzZlYkExSDRDSCt4RVl1eFRy?=
 =?utf-8?B?bEpVZVhlWForWjZtRHFjckYzN29DY3dqRnlxUUZEZDA1N3lQR0dpRXpST3RR?=
 =?utf-8?B?UjcvWWhjbXRoZzdSUkZSNWhkeVBjcTRVSFZrbWloYmwvYjNHbTFvM093amtI?=
 =?utf-8?B?Snc1SGJnQWZuekhlR0lUanE3Mk56a2o3OURmalVoY2xWalZZUkpzaGt1cld5?=
 =?utf-8?B?RkN5MXRKU1VmWlUwc1JRcTBOZ0hlZzhjTkRlMGNCelkrbDNUQmNhOHJwQWRZ?=
 =?utf-8?B?Z2FlaFZoRnd6N2lTVzdXT2ZOMDNMalBsRjM4N1FjQjFQZVZJR3B5R2o0dUJV?=
 =?utf-8?B?eGxpUU9VVXlTR2gwTUIydUs4K0o1M2V6ZVRZaEczaWo3MytJQzlyaituRHBM?=
 =?utf-8?B?WWluWmVLd0FEb2ZPVUtQb2MxYmRGZEZqZFFUdVFQVzlOVG9ZSFVFWDJyYzhz?=
 =?utf-8?B?d0kyaHc1UlRsenVpeUNueDFRTVNCUEpyYkVDc2xSYnlqSlU4WFlHc2M0N2Y5?=
 =?utf-8?B?RWNTWU9ySms3K3lEWXd5RmdiMEpWZVVUakU5VlgrRjlmQWx2d1lSMThsLzla?=
 =?utf-8?B?RU8xcjdpZ1lkbzVoOUlpNnlRRk16c2NnWW85QVlPZVdMeWZZWGFodS9LMXNB?=
 =?utf-8?B?T3RLNjZ1eEtKM0RZSThKZjN5MFFUS3RHOGxyRGppamd6SHYxZFF5RmNYWW44?=
 =?utf-8?B?K3dOYWFNTDBtTjZTMnFlSkVhVzdBYm13d0RyN3h3cDViTFNsRkJxN1p0SHBD?=
 =?utf-8?B?UFF5MjNNNFRFaFlkd1BCSWtCMWxmb05VRkpwdTRQdzQwbEV3Y0VCcXQ3UXNL?=
 =?utf-8?B?bG02dFZBNmpGWWpBREdSbGx2QlEyVWI0Y01wYnhQMG1OajFwUlZBYXY1ZnNu?=
 =?utf-8?B?STJjSHd4aW9FN0NNOEEzdTZqWGpBRnlZY0U2U3plYmVHMndrUldRNTRObHBi?=
 =?utf-8?B?MU5DdVp1dnZFa25MdytjZWhGaUE2RWJrMVJ6SW9QV2ZzYjFYTDZCa1E1VmYy?=
 =?utf-8?B?WklsZ2ZZVVR2SzI5YTJDdklKMWdCN1VtTDlDOFlUMGVLaWx3VXcyM3p1VnpU?=
 =?utf-8?B?VE92SFhYSU5LZVNuUmc0eFdEVWVIbWF4THkwZFZXbGQ3MTVDZXUzdEZJS2t2?=
 =?utf-8?B?S1BMaW5WSDd3L1o3QkZiMlo4SUJ0em9aV2dFM254UVJJT1E9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TDVWdkRMVytFMk5hd3Y5ZFRid0pBenUvZ3FqZU5rKzkvTXlmQmFXYm5obmhN?=
 =?utf-8?B?UnlONm5VRVRVV2NZSjd5Q3o2SkY5azhsMmtHL0F0Mm1PRk5KbWRqUUtVS0s3?=
 =?utf-8?B?UzI2N3NKbytQeEsvV0pab0UxbHJTMkoyK0JwTjZEVUpVQW02aFg0aXN3akJM?=
 =?utf-8?B?cys3ck9raFFFblFEQmtTYzF0S0JZa3V1MTJRTGpuNUdkUjA1TVB0c2c0dmV0?=
 =?utf-8?B?NG9iaEtaSXNhZlZJSHFTYUZxVE9VcWV0ME5uWHRzek53cjRWK0J1VWwxM3dF?=
 =?utf-8?B?SDBYOFliTVJVM1RqckFmMERKSDhsWmJEUVhISllQUlZvTDlzMnJJSzNQeGxT?=
 =?utf-8?B?RUJlMWx2OTA4YkI4eGtuajVEMkFXazdWcE10Snd3RUJkWWpUaWh6MFVtNi9Q?=
 =?utf-8?B?eXRzSSs1NDN4OUFPSFFHb0JTVzNTUW9NSDE4TWhpVFRUTEJvNDhuS0tjNHJZ?=
 =?utf-8?B?Q1owUHJ1WTlEZEZMNEJBbGgwaEo5UzBJK2xtODZJY3JucVlxTWZFUHdLT1p6?=
 =?utf-8?B?MG5HUDVYbUI2bU5rVVhQMGRuc2Vwb2I0M1BEcUNrRm0wV2ZtZ0lqOGFuZFNr?=
 =?utf-8?B?WWhxR0xRaXBIaURXMEdKaHYzMzZlaGFSdE9reGNCWENvK29KOG9UTGpKM2gx?=
 =?utf-8?B?NDZqOFdRWTFRU1E4YVFjYU9XM08wY1FNcWIyeDFpaWRQZE5RMmI0eER0NnJn?=
 =?utf-8?B?eWZzd3pURFVURXh4ZXNhcFoxRUZlZmtwblVuZHE1L2ZzUUN0eVdzOWgwS2hS?=
 =?utf-8?B?N0Nya0twTWFDRytKSzlTZ0dzQ3Q0SmJTa09sblZJQ2h3WDhXTEsxaXgzcWtQ?=
 =?utf-8?B?MHVTcnpPOTJPL0gwdGR4bGZKdzhJTXVtNFhEaWRiYnI1bXlocnh0WHE2RkMy?=
 =?utf-8?B?ODFqc3NYRkZTKzZuZHRxVTQ4bjdTaC9ueTRhY0pCZGdvVHNqdVJOQTIzSlhX?=
 =?utf-8?B?M2hoUDMvcU5ibzExb3ZYbldpU2VOM1IrWjhZV24wUHVMZitiUk1wY1J1UjAw?=
 =?utf-8?B?cFhpQ3hhdDZQWXJFQW1jazdFa05vb2cwelJyWEpwUTY4S09lWU9VemtBM1NH?=
 =?utf-8?B?dlM2amkwUDBudDhNT25EaHZKeGdCbzB0aDZjMk11VGkyaXF5QkowQndGT1ow?=
 =?utf-8?B?M2M5aWdGZEdUMlg4b3V5aDhpY1ZLSmx4d1E1L054bUZLNE04VzVFZjAxUm1O?=
 =?utf-8?B?NVp2Y2FxL2xFSEV5Tm9vY0ZnNzVaRVpQQWRkb1lEblIyMFRMMUV5aFNabUhY?=
 =?utf-8?B?dXNxMVFvTHlPZjhTN1oyRE9ySW9ISFJHbDR6NVQ0WG9wZ2hRU1UreGJ6M3J5?=
 =?utf-8?B?d2FHMWk5SDZHV1Y5T2g4eVpuWjJUUWJNeDFzR2JwbnJrT0FPQmFZYXR3UUhP?=
 =?utf-8?B?SmFyWG40aUNKQUszaVViN2NMcE82am5UUEdlc3ovUGhYdWpPQTNEY2t0ZXpj?=
 =?utf-8?B?U1JPZm9jVVE4dzhZVjNMSzlDM0NTTFF3RThHMmozcCtnSGN1ZDBmQWZaL0Fj?=
 =?utf-8?B?d3R5VngwSlEzejJ5TXlwUzZ0MnBVeXo1QjlqWm03Rzd1QWNwbFoyaFA2Z2pm?=
 =?utf-8?B?VFZibmtMUFNKUmQ0cTNDZUNJL0Z4bHNBMW1zZXVuZVhmUHl5Y2ZuSVB4QXhI?=
 =?utf-8?B?ampJN2RSUThKM3d5S3MvZk1GRk5HYmdWTW9SVUl0b1ZjNjdxK0srbVJaQ3Z3?=
 =?utf-8?B?YmR6aXpvVHorTUdhdzVqemc3SFZzdGlwNTJUV1g1a0UzakpJdU5wR2pwTHFD?=
 =?utf-8?B?VU9oWlUzV2J2UWNBa2JoSzFKL1lMNTZ1QkM1SWZWQmZDM3FseXFTQWIrbzY0?=
 =?utf-8?B?VGIxMWMwS1QvWDZBRmxMT1lOblUzeXJrYnBOQXBUNGlKWDViSlNmN0J2VmtF?=
 =?utf-8?B?clludFA2OVAxQ0paMXFYNzJ6Z3dMYmIrNlhLc1pKNTlTcTUxNW9kY3N6NDVm?=
 =?utf-8?B?dTA2bVRoNTMydldEUm4wSVJCTThrZzZTK3J4NFZuT1JiY0JZY2UzeWxtekpI?=
 =?utf-8?B?aTZCejhKT1QyMDRNMGZ0aVJxR0JpK1VzY0Z2YmY4T0JJTXNZVXlpTzVveXhz?=
 =?utf-8?B?RTRGa0t0YzY5UVNncmswQUZuc3pFSFJZbWUzclgyZFBZQVVjdklnYjQzNjdx?=
 =?utf-8?B?dG9RWWFPQmlwcEU3MEw2S3NvQlNZazVPYVpnWlNqU0dUSE01TDdiWWErRnBh?=
 =?utf-8?Q?7eLSv/eqRuyyETyMzzhi2TM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3C1D17526F77834E80E6ABC5FBE99034@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4542c5f-3b36-47c5-872e-08dccce95af4
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2024 13:56:20.4458
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NwFQjf4O+eOXnI1Tv10EdnwETGJiUJEbxBueeGCR1r7wgkdPhG7DjjctG0/qAOe4PkJHQnvEOxiUbjS/7LI9XAwzT2mtgTt1wDRWf+DOR9s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8262
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA5LTAzIGF0IDIwOjA3IC0wNzAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToK
PiArc3RhdGljIGludCB0ZHhfZ21lbV9wb3N0X3BvcHVsYXRlKHN0cnVjdCBrdm0gKmt2bSwgZ2Zu
X3QgZ2ZuLCBrdm1fcGZuX3QgcGZuLAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHZvaWQgX191c2VyICpzcmMsIGludCBv
cmRlciwgdm9pZCAqX2FyZykKPiArewo+ICvCoMKgwqDCoMKgwqDCoHU2NCBlcnJvcl9jb2RlID0g
UEZFUlJfR1VFU1RfRklOQUxfTUFTSyB8IFBGRVJSX1BSSVZBVEVfQUNDRVNTOwo+ICvCoMKgwqDC
oMKgwqDCoHN0cnVjdCBrdm1fdGR4ICprdm1fdGR4ID0gdG9fa3ZtX3RkeChrdm0pOwo+ICvCoMKg
wqDCoMKgwqDCoHN0cnVjdCB0ZHhfZ21lbV9wb3N0X3BvcHVsYXRlX2FyZyAqYXJnID0gX2FyZzsK
PiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUgPSBhcmctPnZjcHU7Cj4gK8Kg
wqDCoMKgwqDCoMKgZ3BhX3QgZ3BhID0gZ2ZuX3RvX2dwYShnZm4pOwo+ICvCoMKgwqDCoMKgwqDC
oHU4IGxldmVsID0gUEdfTEVWRUxfNEs7Cj4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IHBhZ2UgKnBh
Z2U7Cj4gK8KgwqDCoMKgwqDCoMKgaW50IHJldCwgaTsKPiArwqDCoMKgwqDCoMKgwqB1NjQgZXJy
LCBlbnRyeSwgbGV2ZWxfc3RhdGU7Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoC8qCj4gK8KgwqDCoMKg
wqDCoMKgICogR2V0IHRoZSBzb3VyY2UgcGFnZSBpZiBpdCBoYXMgYmVlbiBmYXVsdGVkIGluLiBS
ZXR1cm4gZmFpbHVyZSBpZgo+IHRoZQo+ICvCoMKgwqDCoMKgwqDCoCAqIHNvdXJjZSBwYWdlIGhh
cyBiZWVuIHN3YXBwZWQgb3V0IG9yIHVubWFwcGVkIGluIHByaW1hcnkgbWVtb3J5Lgo+ICvCoMKg
wqDCoMKgwqDCoCAqLwo+ICvCoMKgwqDCoMKgwqDCoHJldCA9IGdldF91c2VyX3BhZ2VzX2Zhc3Qo
KHVuc2lnbmVkIGxvbmcpc3JjLCAxLCAwLCAmcGFnZSk7Cj4gK8KgwqDCoMKgwqDCoMKgaWYgKHJl
dCA8IDApCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiByZXQ7Cj4gK8Kg
wqDCoMKgwqDCoMKgaWYgKHJldCAhPSAxKQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqByZXR1cm4gLUVOT01FTTsKPiArCj4gK8KgwqDCoMKgwqDCoMKgaWYgKCFrdm1fbWVtX2lzX3By
aXZhdGUoa3ZtLCBnZm4pKSB7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldCA9
IC1FRkFVTFQ7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGdvdG8gb3V0X3B1dF9w
YWdlOwo+ICvCoMKgwqDCoMKgwqDCoH0KClBhdWxvIGhhZCBzYWlkIGhlIHdhcyBnb2luZyB0byBh
ZGQgdGhpcyBjaGVjayBpbiBnbWVtIGNvZGUuIEkgdGhvdWdodCBpdCB3YXMgbm90CmFkZGVkIGJ1
dCBpdCBhY3R1YWxseSBpcy4gU28gd2UgY2FuIGRyb3AgdGhpcyBjaGVjay4K

