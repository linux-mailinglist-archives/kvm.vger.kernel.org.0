Return-Path: <kvm+bounces-63504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 421A3C67FE4
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 08:37:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id 76BB82A34F
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 07:36:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03DE93043B7;
	Tue, 18 Nov 2025 07:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fSy0iR0a"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A38285041;
	Tue, 18 Nov 2025 07:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763451294; cv=fail; b=HwmEqBi94ntJekJdQy4GTu49RcsjPPcfl7fkofq3kOKRgKwmMRE5CS1kgVLdAIqNmrYjwNzBWbOeyUYi1TY6nsJZTpMF2QKGeR4SWmRpOxopSo7R5BwDiOlca1X993fDtHB4oeAw+ultSAb2Ua1biuJMI+YvAg94FfkWMC5PvYQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763451294; c=relaxed/simple;
	bh=f4qNRJq97M7fBC+rPsEfYf2YVfw4gnTZGnD5kaUU2cc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=prPxqulNxtz2KOF530cBT/+cYVLjd405ksVuNkHH0lhd9mNJy9tvkeq/wdb8HB13cFsb5PD93Z5yBnpsBNNMJNlD2Kb4yNWfbgHyWh1B3wo7QQ96hlCGOIuNZbt2DOCSkCXI/oiWfFaedx2QsPO4lLhUOO3jsm2kF4darZ3pA8E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fSy0iR0a; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763451293; x=1794987293;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=f4qNRJq97M7fBC+rPsEfYf2YVfw4gnTZGnD5kaUU2cc=;
  b=fSy0iR0aSLLpzfVMazhSVUdRN0z7KpQqc4cnT7QZ4j0Kxw/WV7dkhZr3
   xWfRX4s1AlOwESS8PzRh5hncavMLgnt5/g3tpeUZwCCv3YsVkz3CJ1fAD
   qxFcgaCuTvMuRThfi5zIu6PoRGReg2DICb9XmvmP/ugXvckimqhx+lVrA
   q0/CurAISLtedwkBXWSh197r8JtTuanPeGOkbWfkYKgkErx+h/qxwHw4i
   dPtbwbYFnPX6odxGtrNJxZt2PyNVEBMTRtUnNdC4+52lyGfcBAHcMtZ6S
   7vR/gegomzLZ1Ndib+9d4yygemLdKymEcGJtxIV3dShoj8QtGUYHKs7UI
   g==;
X-CSE-ConnectionGUID: F3FdY7NxSNiA8LeahOuiTQ==
X-CSE-MsgGUID: xSUcxfRBQx6ljhOvG0P9Ng==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="53035164"
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="53035164"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 23:34:52 -0800
X-CSE-ConnectionGUID: uU4cAPIhQh2bixH2ZPxIqA==
X-CSE-MsgGUID: I4FO85qtSUe6LWBLgDiVkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="221336551"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 23:34:52 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 23:34:51 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 17 Nov 2025 23:34:51 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.68) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 23:34:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KZwkdczWhCAsGURcmOKt/EmdLZk1qCGsddf01tch/5IKZNAedVDQpbMS2Up/sje6EwXz51eyW5EQ2HbtpuEKebfHqVnrQ3HQEYvaKHAELyIWQtk6Ijn1xlfww961gQqw42sfwaexgZvcmA64JcsZYlTc8tcMvr3TXkEA8xurx8DVOAnp0hhVxnWteTjg989B1X2m/0J3nFOnk5KWUQwWp4ZbFvqJCwNQtwKC91fz9BYp1q0fG+S+Sq5RaXFdAKAPgAPmoH7X3LtO2s1hwaBAwZVzhnvyPkbH5XKXo9nVbgCK/BK+JqjTdw7Hgq1HFDXT3S5mgLyiiPB0CGWWpC47gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f4qNRJq97M7fBC+rPsEfYf2YVfw4gnTZGnD5kaUU2cc=;
 b=McKwLPcH9jNYILF90QgJL+N/0kiKsg47aeXhBRxNaQB5hxpRNh9R52dAadeaNRO0V14QsyMZWOQxDsuJzSNtKFEdLn+cO0zuIKNZ0t9WtaxLXpMnic3qaRxZqolckkLbYqqEyACzt/ev9OAzGT2A+6rU1b2jIpZvOEKxXrBJB4YixPa6HeAdPMDNTHQCDcBKSLTyG17u5qYHVEFlfmd6VSkCrRWDnX80hYAyadIc/QoKl38YShjdnfQoWPy1i7Mb9zEDWAopwDBw0mEQpDocxpXW6QgKLjAUrdhq7wrAEA/bLHZeMQ3lM5vCoBou9ghaaM/BCQcFwWCaEOzTToa/PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by LV8PR11MB8770.namprd11.prod.outlook.com (2603:10b6:408:202::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Tue, 18 Nov
 2025 07:34:49 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.9343.009; Tue, 18 Nov 2025
 07:34:48 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>, "Robin
 Murphy" <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>, Will Deacon
	<will@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, Sumit Semwal <sumit.semwal@linaro.org>,
	=?utf-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>, Kees Cook
	<kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, "Ankit
 Agrawal" <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>, "Shameer
 Kolothum" <skolothumtho@nvidia.com>, Alex Williamson <alex@shazbot.org>
CC: Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-media@vger.kernel.org"
	<linux-media@vger.kernel.org>, "dri-devel@lists.freedesktop.org"
	<dri-devel@lists.freedesktop.org>, "linaro-mm-sig@lists.linaro.org"
	<linaro-mm-sig@lists.linaro.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-hardening@vger.kernel.org"
	<linux-hardening@vger.kernel.org>, Alex Mastro <amastro@fb.com>, Nicolin Chen
	<nicolinc@nvidia.com>
Subject: RE: [PATCH v8 11/11] vfio/nvgrace: Support get_dmabuf_phys
Thread-Topic: [PATCH v8 11/11] vfio/nvgrace: Support get_dmabuf_phys
Thread-Index: AQHcUvHIHaVaajZVFkifGirUUh7qGrT4FWjg
Date: Tue, 18 Nov 2025 07:34:48 +0000
Message-ID: <BN9PR11MB5276FA6ABBDC34CBAEFE9B898CD6A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-11-fd9aa5df478f@nvidia.com>
In-Reply-To: <20251111-dmabuf-vfio-v8-11-fd9aa5df478f@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|LV8PR11MB8770:EE_
x-ms-office365-filtering-correlation-id: aceaed31-fe96-4c43-cbb4-08de2674f442
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?QVlUcHdsc1NOMUVUWmVNU21sR1AyblVaTkVXUStKRDNWd01PVllESVBlemJa?=
 =?utf-8?B?bndKS25JanpYSk9xWkVHSG5tNW4xZzJTNnc1NlRSYzU3M1F2cUtIQmF5Nm9B?=
 =?utf-8?B?VWNRWXhMZXUzQUdqUFFwVkpSTEYwYlBxcTlIalVhZmR0cERkUHlBcXdPV0Zo?=
 =?utf-8?B?OTVyRXpycUpOMG9MRnMwT1lnSW9CeTFudGE5QkV1anZ0ZFB2M2JpMTdpaWVx?=
 =?utf-8?B?YnoyakQ4U0E0cEhoZUF1VUxjNXFUeVBDUHFFS0VGQlM1cXhSTVRZMkhYYTVF?=
 =?utf-8?B?QTFEeS9CMGV1bEV2MnNoUGxOY1Q4RTJnSFFZYnQ0U2V5TTFIMGJVWVdIRHR2?=
 =?utf-8?B?cVM3RGF4TVBzbGVaY3loczdFTno3cGViRXgyek9lRDc2a3JlUEJ5SE5OV1V3?=
 =?utf-8?B?dnhhcUxneEk4bi9wS2lwTjJjRWIzK0ZFeGIycHV3aHM3WS9IRzd5U3BKZ01S?=
 =?utf-8?B?SjZ2dFExdE5yNDRqeGpJd1ZkNG85RnJDZVdvQlBsMys1d3ZFTDBpTGE1bC85?=
 =?utf-8?B?TXVYdytsQjQ5Mno4dGFPVUk2cTZiR1NMclFYeVhxUGhNNk9wTnhydUFDRjhi?=
 =?utf-8?B?RmJOaW5WMHJWV1ZKYWk1VjlQMHBmUjhpTXppeDBwSWRJT3p3MnZiSGFDRExR?=
 =?utf-8?B?Yk4rWGxjakt2Y0MxeDhGMDc5QzhDV3Bvcktlak5qMEhiVk1oRXNRSllTZWJ2?=
 =?utf-8?B?WmxBdDNOdlFNbk5xa0NaYzFXeWU2ZXplaURFNzRUOTRRSXNiQUVaeWlBd3hE?=
 =?utf-8?B?SFJ4azBqNURMdnBWYUpmZDU2S1pOVmlhSjZzekFjNlRCaE1zSDRkT3pXUEwv?=
 =?utf-8?B?Vi9nSDNLNnQvNS9yTjVnb3RnSjNJQzdNQklod1VmcUFEK3lsVjhMT2xtL0ZS?=
 =?utf-8?B?WWZMSGdZTncwbkthV0lrZlpZSUwzejIxb2hSUUtEWlBxbTBXMmNTYUlGRTda?=
 =?utf-8?B?Wi9SOW9uaW0yNUpVNitZMmY5bnduK2daYXFTczVDL2RKUDdCY3ZUckpqeVlG?=
 =?utf-8?B?aVpzcXBMSDdPZWhGY1VoUHBDRXFuRWt4d0VOUGxBNy9xSExYT1diaC8za1Ni?=
 =?utf-8?B?cXovRWtJT3JITkpGcUdCMTcvUnh0TnBvcjVnTjB2T1cwbUdRQnVJWXVVM1Fv?=
 =?utf-8?B?ejdaMmVSMStyWW5Zd2E3b2l1U2dsYTBpZ01FRElVdGNCN1hybmYzcWcranFE?=
 =?utf-8?B?eEh0VWFta3ZBNGxsMDRGUnVwVXAyUzk5d1lMdHpBTUNVOWtyMnlicThlcWFD?=
 =?utf-8?B?R2RhY2c3MExRWE44Q3B3Ykh4R0FRMlZNREZ3bERtQU4vZFN2WHFtSkNVR1dF?=
 =?utf-8?B?S2sxK2UxSFVBcjV3STFpWmNIcjZkWERibEFQYkg0VElXTHdoaDlHNktZaGUr?=
 =?utf-8?B?bFcxWEFYZjUrdzJWYjdDdDZacUg5RHlZZ1ZTbUtodDFCakNGZEtYeXhjc29L?=
 =?utf-8?B?QW13RUFuN3kyUVl4S1dSdmRTdFFDeFh4UzJCTmtrTzAzZUo1REZueGdRM2dY?=
 =?utf-8?B?WE1IUHdJMitSNktxdEVBcFl2eDIxancvYTgvK0VoN0U1WjZtdHlWUVJ5SzFj?=
 =?utf-8?B?dG0rcWZCdWx3Q2FESmR6OEtJdWZISEl5QklNckY5NnU0N1F2NmZJcHU2UFJD?=
 =?utf-8?B?RTlrY3RGK1pxZlRJR0RIbHRUSEV6Q0tTdVRnci9jRWRjM1FhWStTTmVLUkh6?=
 =?utf-8?B?ZU1OdEVOZGNEWXhMZEJEeVQxTWhtUmpUS1lxSjNHVHRWTE1rQWtuM2I1ZlYz?=
 =?utf-8?B?MFczYUpMR3plMEtINjhnSHRIbEw2NVNJTm1vZUo5QnNOOWRtZDF6THhkWUZY?=
 =?utf-8?B?UU83V0x6ajZxVmdETlRKbXhsUklSTkpRSmt4ZWhCUmsyd3hHVks2MUNMNHZy?=
 =?utf-8?B?SEZ1THZkTFQ0eWl3YjFuVE1ERUE3RjBoRzJqUS9qZ3dNOUVxS3VRUmVVYzNn?=
 =?utf-8?B?NHFiUDVqMnNnaWJhUHpxZGhtNk1yYjdjSjJzbTdjT2JlSktSQTd2WUZHRW40?=
 =?utf-8?B?amg4ZFZOVjl0ZjdCMWdzL0QxNHJUZndhekZWK2dtVGNWSDdaT2kxS1ZMaU9w?=
 =?utf-8?B?R2JYMmVFazRHRmFYMU43YUtVdFBXNnk5a0dEdz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UjlWbGdhV05OVUtoWEQvM3M4cVc5eGd6cFJkNUt1QUVZQmI4OGVFYmlOVS9s?=
 =?utf-8?B?UmRSS2N1dGMvMjdVTjFlSmtMVjB2TllaQ3piYXc1Y1hFbDVJOGxPYzZmZTg3?=
 =?utf-8?B?ZEV1VStPZTZ2bFhDN0krblhzRTc4MUdjV3NmTGRoSTNyYnFBeURwQUY2Ymtr?=
 =?utf-8?B?ZnJJM3dvWDZTeDJaODJRVzFqMVhVQ0VtQm54a2NGQUJWNlgrdzE1a1NFbHNB?=
 =?utf-8?B?bi82V0U4Mk9KS1Q5Z3JjanNsVEtMOE0vRUJEL3ZkNnhvLzJUZVp3RkN0eHVz?=
 =?utf-8?B?ODBPamg0dlR0TWZ1Vzk0M0NDQ1JhRGZZbDFxWTExWENqSEF2OUk0cGltRVNX?=
 =?utf-8?B?Z2JqMzVjL2F0Ky84Sk5CdUlqYXBYVlJHSmVqb1dLdFkxN09oam9xRHM1VHhq?=
 =?utf-8?B?SGY4cDhvcit1VEY1a1llcmhBZHhLcWhldC8rdFk0Wkl1bXVQbDFBaDRwUHV6?=
 =?utf-8?B?VmlQc0xHdmhGa3YwQVBBbjBRcURETjJYdkJMWGV1bHlsRFFITlo5ajdwMVI2?=
 =?utf-8?B?UHBySFViWS9NN3RIUzJNR080eXNzYmUzR1haQThjRWxjakNySHcvakwwNHR4?=
 =?utf-8?B?ZW9SaXo0N2xOK1ZBL1NnSStPdlAwd1JjTEltd0lhK3Z5TTFGc21FUjZzZFJ0?=
 =?utf-8?B?eGNqK0xpZjhMU3ZhZm4vdE9FZkFDcjVRU1lUSDJLU0Q0amp0RUR6cXFnMEpH?=
 =?utf-8?B?WFhIcExkempidkRDQVBKbk1DbFB6RXNBUTU3NHNJTzVGNXlCVVg2aks5ZmJM?=
 =?utf-8?B?eXlxbDNmWFVEZVV0M0daOUtWM3RNV0JFV1JiWlFOU2RKRmN4YWl4ZXZpZklk?=
 =?utf-8?B?TDZ1WmJ2VlhVTUpXZWgxeWlBNENyZDdDRHF0NzhCV1h6UC8yNWppa21DWGkx?=
 =?utf-8?B?SzliaE9pa09SeGtxNThDQmQxb3dpdUg1QkpTQlhjSlNrOFpMY3k1TnptczRi?=
 =?utf-8?B?TCsya3Y0QXRYdS82WllKQWdhRHhhckdFOXllZC92cHJsVFBUa29SL1dGbkFv?=
 =?utf-8?B?dUpYT09mMlBFdVhjNm05YVBHODNWUUFRUWcySGZrZE1GalNuaTNlNktvYXZq?=
 =?utf-8?B?bWdLTDhqeURhNTJDS0dDYTVORTAvMGcwUjIwSU5yN3JacWwxUDdKQ1R4dHZl?=
 =?utf-8?B?ZXNTL0VNOUVIajB6citsMkVuUmVnaVhPZ3FiSFRkSGV4M1Jxdnh0ZHVqb0Ru?=
 =?utf-8?B?elBxOVpDYkdvelJpNmdGZ3hrc3g2MjNKWlJrYm1udUk0eEh5N3g4RzZOelVI?=
 =?utf-8?B?TUxxdHA2MWtrSFpHaFRiUHc3c1hqU2pTS3c3bUxDajRGck10ZTdlNmcrS3B1?=
 =?utf-8?B?UW90L2VzRi8vOXdJeFFIUTU5SVNFa3JZem1MYUlaYzIyMWRjVDJQZWhDYnZz?=
 =?utf-8?B?ZjBsQ2pKcUVtMXhLeTI1UjhGRllWZTVqNGFkSVpXRVV6T2FVaWJubTYvRzJY?=
 =?utf-8?B?ZjQxRVorNThVY1ZTQmVBQ1VDTHdlVVRBbVBpRFR6NG5DaGszc1VVb21aNks2?=
 =?utf-8?B?TzlVTnhXa2lRVjUxd2xDdUt6K29mb0NyWVkyTmNQTEtwem1CckJHcm5pYURU?=
 =?utf-8?B?SXJKRFNZOEpVaDRhczc1T0RXMDZ3Yk9ZRG91ckxyQWpmZTA2amRwbEd5emo5?=
 =?utf-8?B?YVJSQ3FVN1B5ZEV3TVBVYkVDWmt4Tk4yVWVBR1VVK0dndGlLSm1IWEk1TWd2?=
 =?utf-8?B?dHpiaTZWS0RBN1htY01BaU5LekVLMEtXam1HYVZFOTAzdjQrREIyeExwVXph?=
 =?utf-8?B?K0Y4ZXh5QnUxZ0NLeERwNjFMMVU0TklNOEJGK1lraVROWTMwblJTL0hOSTNM?=
 =?utf-8?B?LzJKMm1teGFRV2JWaU9rQXZPZlZ1dTU5WFZaVmIxdkV3WlNUUmIrSHpoOFJi?=
 =?utf-8?B?R29BN1Njd0lLVS9rTEl3cWFEYXRpUkhqcnRPa2xXd0VVT3NlR2srdTNock9Q?=
 =?utf-8?B?djVBbkt5Q2ZVcXpmaUkyakRaZi9nVkpUMXZhcEQ0VjBvc3lGckk5Q2x1K2cy?=
 =?utf-8?B?R1U1Z0VrZkxISUt0dWJ6TFNoWC93L0tVNWZBNzR0eTdmOEVYN0NscGcvc1c1?=
 =?utf-8?B?RkttNmhZcTc1ajQ3UjVmN2pzcFhFaFMwaHRjUVl2T3RWYjVUMmdoWVhLalN3?=
 =?utf-8?Q?YrRJitO8HGbig0EZfRhoRmvkN?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: aceaed31-fe96-4c43-cbb4-08de2674f442
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2025 07:34:48.9114
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fQR2p0jPo3DWrLam2OX+HT73UWrOG+pmbRAx/u0npazGaI/sHJuLx9v9ZyFKoIT6msy2E8f8b5/g+zVo2K4EDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8770
X-OriginatorOrg: intel.com

PiBGcm9tOiBMZW9uIFJvbWFub3Zza3kgPGxlb25Aa2VybmVsLm9yZz4NCj4gU2VudDogVHVlc2Rh
eSwgTm92ZW1iZXIgMTEsIDIwMjUgNTo1OCBQTQ0KPiANCj4gRnJvbTogSmFzb24gR3VudGhvcnBl
IDxqZ2dAbnZpZGlhLmNvbT4NCj4gDQo+IENhbGwgdmZpb19wY2lfY29yZV9maWxsX3BoeXNfdmVj
KCkgd2l0aCB0aGUgcHJvcGVyIHBoeXNpY2FsIHJhbmdlcyBmb3IgdGhlDQo+IHN5bnRoZXRpYyBC
QVIgMiBhbmQgQkFSIDQgcmVnaW9ucy4gT3RoZXJ3aXNlIHVzZSB0aGUgbm9ybWFsIGZsb3cgYmFz
ZWQgb24NCj4gdGhlIFBDSSBiYXIuDQo+IA0KPiBUaGlzIGRlbW9uc3RyYXRlcyBhIERNQUJVRiB0
aGF0IGZvbGxvd3MgdGhlIHJlZ2lvbiBpbmZvIHJlcG9ydCB0byBvbmx5DQo+IGFsbG93IG1hcHBp
bmcgcGFydHMgb2YgdGhlIHJlZ2lvbiB0aGF0IGFyZSBtbWFwYWJsZS4gU2luY2UgdGhlIEJBUiBp
cw0KPiBwb3dlciBvZiB0d28gc2l6ZWQgYW5kIHRoZSAiQ1hMIiByZWdpb24gaXMganVzdCBwYWdl
IGFsaWduZWQgdGhlIHRoZXJlIGNhbg0KPiBiZSBhIHBhZGRpbmcgcmVnaW9uIGF0IHRoZSBlbmQg
dGhhdCBpcyBub3QgbW1hcGVkIG9yIHBhc3NlZCBpbnRvIHRoZQ0KPiBETUFCVUYuDQo+IA0KPiBU
aGUgIkNYTCIgcmFuZ2VzIHRoYXQgYXJlIHJlbWFwcGVkIGludG8gQkFSIDIgYW5kIEJBUiA0IGFy
ZWFzIGFyZSBub3QgUENJDQo+IE1NSU8sIHRoZXkgYWN0dWFsbHkgcnVuIG92ZXIgdGhlIENYTC1s
aWtlIGNvaGVyZW50IGludGVyY29ubmVjdCBhbmQgZm9yDQo+IHRoZSBwdXJwb3NlcyBvZiBETUEg
YmVoYXZlIGlkZW50aWNhbGx5IHRvIERSQU0uIFdlIGRvbid0IHRyeSB0byBtb2RlbCB0aGlzDQo+
IGRpc3RpbmN0aW9uIGJldHdlZW4gdHJ1ZSBQQ0kgQkFSIG1lbW9yeSB0aGF0IHRha2VzIGEgcmVh
bCBQQ0kgcGF0aCBhbmQgdGhlDQo+ICJDWEwiIG1lbW9yeSB0aGF0IHRha2VzIGEgZGlmZmVyZW50
IHBhdGggaW4gdGhlIHAycCBmcmFtZXdvcmsgZm9yIG5vdy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6
IEphc29uIEd1bnRob3JwZSA8amdnQG52aWRpYS5jb20+DQo+IFRlc3RlZC1ieTogQWxleCBNYXN0
cm8gPGFtYXN0cm9AZmIuY29tPg0KPiBUZXN0ZWQtYnk6IE5pY29saW4gQ2hlbiA8bmljb2xpbmNA
bnZpZGlhLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogTGVvbiBSb21hbm92c2t5IDxsZW9ucm9AbnZp
ZGlhLmNvbT4NCg0KUmV2aWV3ZWQtYnk6IEtldmluIFRpYW4gPGtldmluLnRpYW5AaW50ZWwuY29t
Pg0K

