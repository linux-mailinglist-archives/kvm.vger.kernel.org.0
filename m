Return-Path: <kvm+bounces-71303-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id zpTnIP1TlmnIdwIAu9opvQ
	(envelope-from <kvm+bounces-71303-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 01:06:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1065815B116
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 01:06:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AB2AF3034B11
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:06:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 167E6CA6F;
	Thu, 19 Feb 2026 00:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a+A9xqfN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195CE3EBF03;
	Thu, 19 Feb 2026 00:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771459568; cv=fail; b=ukm2S/7F8KH18B3zQw2wD2f8NbVCfGBWsTGoOFQO4mkSHKMAOP2mjQpy5GsF739jHlIn3blgX5ybUoUCgqZXo+sIOVtHF/DDYAr2sczEGt1ebau16FosuAJwQ7dX8Jdl265CvDW7GJVXSra77/Q/pRouBu7C7OTMzY5mgkMbhSw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771459568; c=relaxed/simple;
	bh=oDf83k5Yfu5P+gvk1z9kzslkeBDI0nbb7gg2QADHcuc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HWaZyan6IdjEC1eebdD6N0Z7nDupPsLvovu7aMD8kk5RDRzubYHdpsggCSa/UtT18QJPH/oEQVXA2TFmSt2Qyhj51dE/a3AyZb7hWY+zkK8iZP2LXXxscEeKvItrx0X+mQL2U8PuZaOgj3gvvi9ryVy9paUjCtk3NAckJlLNaqo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a+A9xqfN; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771459567; x=1802995567;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=oDf83k5Yfu5P+gvk1z9kzslkeBDI0nbb7gg2QADHcuc=;
  b=a+A9xqfNMkYN5kn6jw2OQHujzAjN7wMsbnW4xJ0WEvHVxKtAJ7wcodFp
   jrVcuwdXrhsnaONdKTVK4cLybsQ2ZU8h0jX3ODs92qy/GgpRLfV4yWLYy
   UrozB6XMdBGpoRM4NNJy5YAOQteYp3LcIdhJSpug/qP96y0qTV0Sq8Lou
   HVtTPnFh1pyqnwcdI6ugIgD2gR1Tkami47LJvxboCBnDXfRMplIMyVTv9
   uqst7cxb4VH/ovEDpW4YuHcPX9MTx3w6Wk4FtEMY2X1ddAa8X7T6lGpRy
   et0gST/g8q4L8ybjmSo+rZdRrYv2zV81zqEmw9Y2MC58D793TYoQyv8C5
   g==;
X-CSE-ConnectionGUID: Z6+avU9rR2+x/LpioOgNaQ==
X-CSE-MsgGUID: cgLwRSrKSWu2GXJMCElXSA==
X-IronPort-AV: E=McAfee;i="6800,10657,11705"; a="71747061"
X-IronPort-AV: E=Sophos;i="6.21,299,1763452800"; 
   d="scan'208";a="71747061"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2026 16:06:06 -0800
X-CSE-ConnectionGUID: UdVpWk0bT6K5RcJ6Mo4qvQ==
X-CSE-MsgGUID: tIpG8VhPR2+LLit/B86lew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,299,1763452800"; 
   d="scan'208";a="218877272"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2026 16:06:06 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 18 Feb 2026 16:06:05 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 18 Feb 2026 16:06:05 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.58) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 18 Feb 2026 16:06:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D9ufTZww+pnQrBHnqwtieghW4MXa9emVlcyRawB76OZgU6kcek6+RGf205S7wnHH9Br8iKU8YRaeRRYvOkLvieXOj6a0cgGslVTLGHRT0VkyzE2mQXD3hAvvWm+8SDnaGBQ6BUsgj1u2GLS7e91niXmfu5CxD6/6ChuU6qAhh5qh52AzwXkRkNtmbSeAM0FmsiaSUcWl6ruHivepTOMcndRkWpwHRP/CmEj7FHn73WjhUNe6j//A/kD3bXtC6yQZScP5XTbBKaS8o80UwH+LW5P2Kz67MhHQhmG+RQ0jXEuenaSwjjM4GdjuTo7v9Os4DK874eSq8nrL9+SE1inR/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oDf83k5Yfu5P+gvk1z9kzslkeBDI0nbb7gg2QADHcuc=;
 b=VMcdKNB0mLopmcUzsP2iOe+VrwHxB92FXUS+RLJ/BH9HUe8FImKU3JaHn4L9IttN3SVp98+WTIEREKGuhNx9j1ip3yHwhivm9FW/8E5k6xWpWNeJqqEUa6/s137Z/jtqE7IvjaEkAG9RRBGoooJ1VYBRsFlUghwcqHNv3U+0CrpC+fqe+Aa6tbRofT6Z6jf/G9ujDXkXsSX1CIu/Z8n5g2/BWHPGwxekhvtvYvoF30JNpwLvIrucZ6fQ0MyauuV9LDbhyjUE+gxiNmAvYmsK549mQf9gNo10ZG2hwEJTg2oifmJ+5rZcwYokEPv2L9tCcIBYcYwORUJ9vERpjtYXwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB2650.namprd11.prod.outlook.com (2603:10b6:5:c4::18) by
 SN7PR11MB7637.namprd11.prod.outlook.com (2603:10b6:806:340::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.14; Thu, 19 Feb
 2026 00:06:03 +0000
Received: from DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86]) by DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86%6]) with mapi id 15.20.9632.010; Thu, 19 Feb 2026
 00:06:03 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH] KVM: x86/mmu: Don't zero-allocate page table used for
 splitting a hugepage
Thread-Topic: [PATCH] KVM: x86/mmu: Don't zero-allocate page table used for
 splitting a hugepage
Thread-Index: AQHcoRq+UEHAm84aDkiskeBGh/mE57WJJNeA
Date: Thu, 19 Feb 2026 00:06:03 +0000
Message-ID: <bcef2c63d9d918812c61433db5a01717f83ae6c0.camel@intel.com>
References: <20260218210820.2828896-1-seanjc@google.com>
In-Reply-To: <20260218210820.2828896-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB2650:EE_|SN7PR11MB7637:EE_
x-ms-office365-filtering-correlation-id: d3644a92-c0ca-4ace-8633-08de6f4aab9a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?c1JCTE1ENXpXOUFpTUVkR09QWG1kd05qbnNLeGJFWnNkM1pJTkJ4ZUVuWDdw?=
 =?utf-8?B?UjRCZlBTdDBOSVRsUEROMXBsSGI2ajF5dEhlcGZ5QXQrME9PdzVuVlpiR1NQ?=
 =?utf-8?B?VW5zWks1WWxhdUllY3pldE13UUpVcnFCc2ZZUit6THQ2UFlscno4M1ZzNWp4?=
 =?utf-8?B?aHBvYTgzakRiTjRGaDY2UkZ6RHR6M1lrUEZKbEIyWHlMTUFuUWVQbGhhOEVr?=
 =?utf-8?B?dTg1ZjU1V1dWcWlBQzQ1Vks2bG9KK0xmOW42WFRnSU5ZWlNDQjdLTTNmcVhV?=
 =?utf-8?B?R0xGZ1RGZVgzaFhpMGFxeWdIOHpFTFdWbmZOTFEvcC9sSDZmclRvQWJrZnNN?=
 =?utf-8?B?STB2bVJObWFiSzRzMG1DYmxkNkV5Rlg0UlNGMU9nUmpLOUhOWHQxMWI5UU1F?=
 =?utf-8?B?OUJlMlZpYXl6bnYwdklUQ3UxS2JVa2FucC9JbDNvZGhCTkQ3SENkMGhGaGhM?=
 =?utf-8?B?UDl6c3BoUXErTTZBS3U4azYvRmZzaVc3ckphTndJT0k3ZlRaK0lJZGdtU1Bu?=
 =?utf-8?B?Q0M5UzdtWXdVY1RmdWxlVlBqdE0rVEd1VTlJTkxzUWRyMGFwajdRMmtCVUlK?=
 =?utf-8?B?N3p3SmJ6OFVHU3hYMnA5ZVBzQlJrRks5RldGdVJIQkRlZzVScXdydXJKRHY5?=
 =?utf-8?B?SDFTQmZCaERoanRzUCswQW9PamtDTTN3TkJoUkJiQTZnLy9FdWNkc2MwRjBS?=
 =?utf-8?B?T2lYQlg4dTJjc2NwUUVVU1hjNFByTktzb2RqM3FtTkF3cWpxNVJkeDJ6M3V0?=
 =?utf-8?B?aEhCQmkxMXppYktxQ0MzRlRwTmNobTk3V3FYTFRLbXRsWWtZQm41TWljK1d4?=
 =?utf-8?B?d3Z0Qlc3RDdPUVFEL0JVL0Q2THJ0Vis1RzgxdTdzcnBEZ1FOMHA3SktkUCsz?=
 =?utf-8?B?ditSWTFoN0lIMCsrTU54aVNFZ1pHWnh0T09Yc0xsd1lHVWd2clQ5RUdJVzVT?=
 =?utf-8?B?S2wxMEF4MXNpbTN0VTBONVVoQzlRUVFNWVlsdUF4WWw2bGh5RVM3MHVlNmZw?=
 =?utf-8?B?OGV1VjhYUDh5Nk9GcEZxU3ZudlpJSWdYQzBLTUpZYXY5UGViNXpmbE9DOHpv?=
 =?utf-8?B?RWtkeTgwZFJnVXdoRDJ4WGRVSGNUcUZ1OEJBWGRSUisrWEpjNi9kMUx5Qlg4?=
 =?utf-8?B?RzNPS0hySTU1K1U1UUlZK1RXc3JDVkcxaWVOTmxDU2VHOTFQd0VLeG5BTSs2?=
 =?utf-8?B?ZlBTb2d4NmZQalkxVDE5Vytidzh1TU1xOXJjalFHNTRvUy9zemU3Rk1yMXFi?=
 =?utf-8?B?NXVFS2hzOVE2cDQ2KzJPU0xvdk9lcE0vSEYxclhNK0JuYy9nZGpaMERKTUFJ?=
 =?utf-8?B?SzZta2J4ck9YS2ZnQVRESkZWZ0RHZkJDVkM4blgrdzVqTjhoT1RiOW9HUTVF?=
 =?utf-8?B?N2g4L1Z5SDVpNnBvQzJ4YUVibTg5MWVZTVhBalhOT09nRy9lMVdITUMyN0dj?=
 =?utf-8?B?SVN1bzV6Y1cwako0cEtCQXBZNm9TSEVpMXhQYUZ1TjNxTXNCMUpoeGlUZ1lh?=
 =?utf-8?B?V3g2NXdxcXdsL2Y2bzdEeHZGbHRkNllhQUZldUo5akNNVjFsd3hkTUxReHp4?=
 =?utf-8?B?MENuTFdKcFNUWlV2K2tRek00elRSL1ZOd09LNVpLWkF6Tzg0VnMxUTcvT3Ux?=
 =?utf-8?B?TnBKNHVHWGxWQmhhb3NSbFZRaTBOOGpOSG9Xb3lSVFRSNDFueStwKzM1TjY1?=
 =?utf-8?B?ZmpRWlVHV3lVNEpDWS9laXJwN2hxSGxVNFpwdUFTeUdSMlZGbi9HTnVOell0?=
 =?utf-8?B?SDFaOW5DL203cGNJakVRVTdtcVBMSE02YW8yYVFDa2lRcjc3aDJqU1FVNmxZ?=
 =?utf-8?B?clJGTVdRWnBUWnozYjBTMjFJOWZwNmkzakhwMmQxN2FTdjBQUy9PdHhEcCtY?=
 =?utf-8?B?c1d6UVJxMFc4WDhVL2JmeS9DcVhtVWdVVzAzMWR2YnQ0dDczazZSZW9hZkEr?=
 =?utf-8?B?MW8wWU1jb1h6bFRrQTk0amx6aU9pdU1HbmRmaDFsR3hnZmJINnFJMWRrYnoz?=
 =?utf-8?B?bGxEdTFKUUNDenFPcWFPbHNMOXJucjZPemZVWWY3VXI1MmZYZWFnZ1F1Q3Zx?=
 =?utf-8?B?NjZUUlpvdWVKMnRmYUNxbU5Ta2JrTTh6WGZETnVJTDJIWG5wNGplbWg4cUdi?=
 =?utf-8?B?ODF5bUI2eGxmcGdHakFXakhYSGhGN2gzVmVmd0IrTFhjZFlVYVRYYW1mM3M4?=
 =?utf-8?Q?2nV3kjRL97CbWwOEdoLsgvo=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2650.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OC9GV0l4aWVMa1VIZWcwYUlTSjF2T1kyaUJHTE5FdE1LUDBLZDZHbGtKZUxK?=
 =?utf-8?B?eVltQXBWM0t0cU8zQmRLRjc5akxwWENldFZCbm9nZXBPSzcxQjJLYmJlN0ZC?=
 =?utf-8?B?RUdBYjRRK0o4cC83a1EzaW1waVlLUlVhbEw3Q2M2YTVjbDhIODJlazhHeElF?=
 =?utf-8?B?TXlYR2VaS1g1RnIyWlhtb0U3cnR1SHVnSENlbExPQkY5RUxGcXBxN1pZejRq?=
 =?utf-8?B?emExYWFLNFB0Z3hGME9sanNveDF2RGZWQ1RJZmRDK1hEakVnZmZkUk9KUlJZ?=
 =?utf-8?B?Z3E4ZUFIdXhNUHdtTUZRV1pSeXAyclF6VGNjT2JBWjRuNldGTUhIUURTV00r?=
 =?utf-8?B?dGxreUQ2TE10V056L0ljekl0WmF0YXZmYUdWOTBSdzJ2MWZ6SVRlcEh5by8v?=
 =?utf-8?B?NWZCaWgxMzVaa1J2dmpIS3R0Y3lYU25rVDhxYStTbFFzQ3VLVGppbnVEYnpJ?=
 =?utf-8?B?T3IrdkszWi9wRmRLNkM5NlB6Vkp2eGZBaHFGVytWRTFnam9ITFEwZHBFc29I?=
 =?utf-8?B?SWJ4bjQ4ZE5zd1EzK2dsUnJkdnUxRm5FODN5dVVjaUR2bWlYSkZMbXdYb29V?=
 =?utf-8?B?NmEzNk1oQkVMVlhaVVVGMXRaaGRMczhOamVINXFKSEh3SU53dGt0N0M5NHpy?=
 =?utf-8?B?alFFUGVTb3gweU5vb2sxQ2tiOTBOcENuYnZGSWNsNTFzTzFRQVU4Z2RPN3Vi?=
 =?utf-8?B?Ri83Nzk4MkxtaS82OG1Yek9WcytLZGJoSXhmMXRPOUZFQm51QzZVZndFMWFj?=
 =?utf-8?B?cFJPWHJURW1FMEkydWR1RDgrdithdFBlV3c0ekx6T3RQZHNKK2hrdGVJeUNL?=
 =?utf-8?B?bHBmS0MrZUhEOVMxcDNCaXZTMXIxMXFBY05HbnRERUtoZzdvUUVhL05CY05Y?=
 =?utf-8?B?VnBIZi9SZ3ViRXRic2VQS1ltZHdlSjN2L2kwbG1GTFdwZEloQ0RDVWM2NTVP?=
 =?utf-8?B?VWVpR25MOWpCNENlN2dZRnBrYkJBNHlkN1VoVms1UzdVYTUzUXM0NkVzQm1J?=
 =?utf-8?B?SlI3TFRIYmRLUHJvNWVHdTVPTDRmdndxamhWbENNWTB2ZzVURlh3MTNOTEdy?=
 =?utf-8?B?bENhZmdORkpsYm5zVXdnb0sweDZqcjdrL3EzYm9RNDdPdlVXNW5xOVRxMGtP?=
 =?utf-8?B?dlFUY0ZBWkxBYTdOeVQ4c0hRc05DUGNzbDQ3Q0tqVGkveVpJVytrNHN4V0ND?=
 =?utf-8?B?QXRzNVZsV2diYjZBZXd0WU4wNnpKMWlKS003S0FJZ2wzRnliREY4QWt6ZU9F?=
 =?utf-8?B?ZExtVXhWeWVmLzN1cUc4T0UrYVphZWFLQ3VYdWUxYzF3WkpHazFpeFRnblkw?=
 =?utf-8?B?VE54Ky81S1Z1ZjlQdEVlYk5aUVlFeWF5Tk8rVWNhQnZwbGFaTE9jYzhoMkRj?=
 =?utf-8?B?NFdpTzBpeDBLK0EyQkdNb05DTmVzaXBDZC9IQ3MwbjF2VHZCUTVTUDZXeE9O?=
 =?utf-8?B?R1oyS2JnU0YwcG1BNlVLMW1SUFI1N1VvVGpYSVM3NGwrb2JHb0xJMlVIeGFP?=
 =?utf-8?B?RUtwL0h2dFRLUit3YjV4UlBhbm05N2xTOGN1WW91SkRQazN2eE5SNEtaT2sy?=
 =?utf-8?B?QmE3a255MzJSQmc3dFBjOENHdWVDalhoOUErZTNKZkN1UU5LajBBQm5MVWU2?=
 =?utf-8?B?a1gwZUtrTHYxaFZ6YXdDWldtV0IyaXpUdHg1TnphK243OXZQbWRxVlg1b3pJ?=
 =?utf-8?B?MHhzTStsRmRxOGJmRitYcnNnMGlBUUxrQjN3QnlPRDZOdlJTd1VncXFOdFM4?=
 =?utf-8?B?Znk4c3poODE1RVN1cmxuMGIyVURsOVc1aEtiQUhkeEs5K2locGdwWWFZRDZP?=
 =?utf-8?B?ME9VUEZjSjJaNGs5S2M0dlVBMTNaTjZ3SVBnb21xSGlZbVNIbkdPeWlRTGt0?=
 =?utf-8?B?R0V5aThMb3hFb2hKWkltQzd3OGljUDVMVlF0Q01wbkVyekFmV2tuREllNWxQ?=
 =?utf-8?B?M21Fam84UkJLUktFVUJ1UFE2SkgyMEtKbmVmL2dJV3BhR1NBTDdxRDRyWEZZ?=
 =?utf-8?B?c1crbjBxUEhTL1pmdEN2cVM1R0xjZnJzb2ZWKzlwendQU2FEaWZlSllWcHNS?=
 =?utf-8?B?Rm8rMCtoQk9GWnFKcVpPVzVaSW5GQzJNaXQxL0YvY0xtdjA1eHBtdEJhemNK?=
 =?utf-8?B?OFhhdlV6TUtpSGZ4MDVldmN1QjZySWdyOXNRUHI4RUdXdkxBRlRGd2tPQlk0?=
 =?utf-8?B?TWYyYnF5TS9vN0pwcXkrMFF2WXFkNmJKZURTenA3TlBxemd6Sno2Y1pmeW4y?=
 =?utf-8?B?cVZYSVRvSGVtcXd0RkxrMmVqYW9XMWMveCt5MUQxaVZTYk5GUmtHckk4VlQx?=
 =?utf-8?B?Q1k0dVRYOG1SbnF4Mm1tYW1oVGtQam5LUXhrTjFKN3ZvL2wxZGYrdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <67B81FBDF52BC143B920ACC267C99BC9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2650.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3644a92-c0ca-4ace-8633-08de6f4aab9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2026 00:06:03.0380
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rjnls6TKFaavnGYSeHTKFWUuQccbQOD8/I3wvJ5LvxfzQ5XDElORn7tlkW7TDbO9jHji5l7posWSc0n6fE2CBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7637
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_BASE64_TEXT(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71303-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim,intel.com:email];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 1065815B116
X-Rspamd-Action: no action

T24gV2VkLCAyMDI2LTAyLTE4IGF0IDEzOjA4IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBXaGVuIHNwbGl0dGluZyBodWdlcGFnZXMgaW4gdGhlIFREUCBNTVUsIGRvbid0IHpl
cm8gdGhlIG5ldyBwYWdlIHRhYmxlIG9uDQo+IGFsbG9jYXRpb24gc2luY2UgdGRwX21tdV9zcGxp
dF9odWdlX3BhZ2UoKSBpcyBndWFyYW50ZWVkIHRvIHdyaXRlIGV2ZXJ5DQo+IGVudHJ5IGFuZCB0
aHVzIGV2ZXJ5IGJ5dGUuDQo+IA0KPiBVbmxlc3Mgc29tZW9uZSBwZWVrcyBhdCB0aGUgbWVtb3J5
IGJldHdlZW4gYWxsb2NhdGluZyB0aGUgcGFnZSB0YWJsZSBhbmQNCj4gd3JpdGluZyB0aGUgY2hp
bGQgU1BURXMsIG5vIGZ1bmN0aW9uYWwgY2hhbmdlIGludGVuZGVkLg0KPiANCj4gQ2M6IFJpY2sg
RWRnZWNvbWJlIDxyaWNrLnAuZWRnZWNvbWJlQGludGVsLmNvbT4NCj4gQ2M6IEthaSBIdWFuZyA8
a2FpLmh1YW5nQGludGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogU2VhbiBDaHJpc3RvcGhlcnNv
biA8c2VhbmpjQGdvb2dsZS5jb20+DQo+IA0KDQpSZXZpZXdlZC1ieTogS2FpIEh1YW5nIDxrYWku
aHVhbmdAaW50ZWwuY29tPg0K

