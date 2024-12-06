Return-Path: <kvm+bounces-33216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 198079E75B4
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 17:19:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9CA7289E04
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 16:19:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DF4B20C499;
	Fri,  6 Dec 2024 16:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X2M/Tsut"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E04191F75;
	Fri,  6 Dec 2024 16:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733501948; cv=fail; b=Pnta8rUGxlxm9rx41fsMEsQG2APk8ohmySi1VSAdkZmXsY0AU4Z8eUi5BLO7VlTt27PkAQnql7/IFWu3+GzTA9WkvWXgSQrDW0KqK0vwB98ghS3T1BErXgXxkXwRfSCFPb+sOtaVjzK9to/+bM9QksCuIPxri8gDkl2yqDtX7gU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733501948; c=relaxed/simple;
	bh=pfpKOkpOS0648Cf5X94Rbakk7aL96lwJJIcjexFtDmU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mJ/RGczXmy3Am4GBrL+MeoSTJ2TVmF/766q2EggJhW/TXLI14geHaVARkSEKvOMitO8rJrXihhRemapVchDWn8pmVYiBFoLO4bZ3T2gbFGjC/baj4XChp3Eee0eEUOEJzNZ7xsnGYfGmy3rVHCQlDt3gXkKcorilbRdNLUlgiWA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X2M/Tsut; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733501947; x=1765037947;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=pfpKOkpOS0648Cf5X94Rbakk7aL96lwJJIcjexFtDmU=;
  b=X2M/TsutCDfJ4XfMLJBmIm2U/GtwWjMaBzwIk3+MCB+y3U1L+5SRokca
   tt3n38srlq7BzLTFHmW9CSi7WxZEXwHkekq3dA+GUob6pSMoQ57oYlmy0
   uzK3AEPyTb3fdHuTsYUZbgFocB71wRHEJRXbTMv5dYS8gheXzoaD0xUJF
   KZ4w5EiX91lBZg704hJVAee/5T4d4rtWS3TkH1Fa8p7sUFieup/vRXqPQ
   4yFpFQFZzBXBF3L2/WY+XZvA70pc2XL1yaFitK6aoS85vUjxqpfrB2chk
   KonU8RqRwY4YT01bl+q85I8EShtcN9qWbaD6YtdbWWs2nsa95MsHEIk/o
   g==;
X-CSE-ConnectionGUID: fNyoa4FjRY6Uvy80my/Mxw==
X-CSE-MsgGUID: cwufoXBbSJy75pK634Ecew==
X-IronPort-AV: E=McAfee;i="6700,10204,11278"; a="33209860"
X-IronPort-AV: E=Sophos;i="6.12,213,1728975600"; 
   d="scan'208";a="33209860"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2024 08:19:06 -0800
X-CSE-ConnectionGUID: UFfBMzAlQgaTI9nBHFolyw==
X-CSE-MsgGUID: lW0xb+EcR7CU9JcoXkUy9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,213,1728975600"; 
   d="scan'208";a="94310205"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Dec 2024 08:19:06 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 6 Dec 2024 08:19:05 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 6 Dec 2024 08:19:05 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 6 Dec 2024 08:19:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W4kwdJJoGpirH5l/Omsl/pmin9SSdrIZZGwNFFberN6xv9DPywHv32C05N/VNm99nRqf9a1pxEel5Er0RHqhop8byE6FIje3Pwt+bdkYGM02T1/qfSMllrx1zWro+tQDoWVwzGeMq//l4B85gvLr6pZsQifi0b6bjozcscUwkfD49rhM98Fg8inHGDLHnN2coJdQUuG2DQGfzfq3CTWbRrnwnW7w6dhvIX2rLB+74nNGxHX7thyVTHH1RvSfgRjqzroes8SJ63f92OtyDN26Th/LF9pgdNE8ULffejqef1SBQLY/0FWwJXZm3fR2Dt/2jlLHSRKD+iIP5TCmb35Z6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pfpKOkpOS0648Cf5X94Rbakk7aL96lwJJIcjexFtDmU=;
 b=PzZ4jfBnmBywqQOREgop95XkeJqv1IvjeF9Fl+ODwSsDjCYTNiR7SECrlIxzvDItWyJwQlo+Q+UCvfpq+L/GAXEq2yjCxQX70wg+Im7aKuCXwfMGKZPs0LhXcY0BFvjJLMchb7UrkO7dIU7DabvXB0ECnTD52IQNzpA9z49aodXK+9iW/2rRkWX/sYWgeNzp+tJJXG0GQIvrzI32KvFHSOf9ksRpqW/1oP9hUNs0SdKrNrCTniDz5VskrKy6gQzZ+AzqKlLDoCxXa6Y3PTvpcWUdGTaEji4VMudW7T+fP8WnRHEWpLtJNByPf4wuvObbXLpymHOpa3pbYMjQiLtpeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by LV1PR11MB8844.namprd11.prod.outlook.com (2603:10b6:408:2b4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Fri, 6 Dec
 2024 16:18:59 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8207.017; Fri, 6 Dec 2024
 16:18:59 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>
Subject: Re: [PATCH v2 03/25] x86/virt/tdx: Read essential global metadata for
 KVM
Thread-Topic: [PATCH v2 03/25] x86/virt/tdx: Read essential global metadata
 for KVM
Thread-Index: AQHbKv4/vFuDP1VR6k6F9GWSzEVqNbLZHhwAgAB/agCAAAGRAA==
Date: Fri, 6 Dec 2024 16:18:59 +0000
Message-ID: <1414e4599cd9dbeaffe35ca014c4288d662f557b.camel@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
		 <20241030190039.77971-4-rick.p.edgecombe@intel.com>
		 <419a166c-a4a8-46ad-a7ed-4b8ec23ca7d4@intel.com>
	 <47f2547406893baaaca7de5cd84955424940b32b.camel@intel.com>
In-Reply-To: <47f2547406893baaaca7de5cd84955424940b32b.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.2 (3.54.2-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|LV1PR11MB8844:EE_
x-ms-office365-filtering-correlation-id: 82e7d983-abe8-4dbf-0028-08dd1611b0b5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NkVONEtjUXNIZ09uWC83Tzc2MDAvUUVpUE9FV1ZpeFdwWEI1amFqNTVwMTQv?=
 =?utf-8?B?YzZkdmJvK3lPb2ZUaEFDeEY4bHYxOWxqYnc5a2JFSzBKVEpyMDNUeWFxU0Nn?=
 =?utf-8?B?R0VGOTFsQXY2TVlyVHE1TWVGR1FKa04vTlVTZEUwWmZrLzVFZktKZVBUa0Qv?=
 =?utf-8?B?V0RFQkdINE1NRnBad0t2enFvQitsWFVSU2RYVkcvczZnYlIycWNrZmZvZ2Vt?=
 =?utf-8?B?L2IwM0ppYnNmOVdkTldURzgzVXhPQTF1UXRKUTBBNkt4QjRXYUo4TGpITU1I?=
 =?utf-8?B?QWh5WEUweHhhVlhXTXc2ODROZG9JeFl2NmU0K0JneXV1SmRBaEpNR2RCTk1t?=
 =?utf-8?B?TFZ3SGRIa2lLUHpHK1BPVWdLUUVxSFlIdkZDOVpBZHIzcnV3dTFVa1g5WldO?=
 =?utf-8?B?SWM4RkE3aHgxSDJSS01WN05BdW5TcUF0ZndKbzRkTUZnVGFObzM0eTAwdGJy?=
 =?utf-8?B?dzNiM3kzYmpVd1cyRis2eWN0MXlZNXYyT3hqVmoxN29iZExqcG1XOHg5a0Ev?=
 =?utf-8?B?UGc4SGlITlBIdUFMSEpYTmZNbjN5OFRNWTlEbWlGeis0NnBiNmZhcDFKdWo5?=
 =?utf-8?B?VG5Pa215UGlYYi9OVkJjdnVKU1pOVUR4OXdMU1BCSTUveFZPc1NjVm1KOUht?=
 =?utf-8?B?QWNodFpyU3BJTHNyNjR2ZVBNMjNyRFE5Sk01UFdHdVJpZVl0NThmclBvd2R1?=
 =?utf-8?B?UG1PRzR1RTh6M2tvQzVySmpjTkthcWJBREJyQTlmVys1K0FGcC83SDRFdkEx?=
 =?utf-8?B?d2ZSd3I2Zm5xWm1zZmtGZHE2cHVhQ0pRb1VpVzMwMjNGUWV4Y08vYXpkaW54?=
 =?utf-8?B?c3FJcnZXWFA4ZXJmUjVvbHQ5Q2hua0VRanRUdktTeTUyQTBpdTlnWU0rczJ1?=
 =?utf-8?B?Ly80QlIxdmszN2sxdXVUTE83dGhDRmN2V1VoTUVpNGJQYkFJSTZ4UzlVSXph?=
 =?utf-8?B?R2Y0aEExdmlRYnhjNWFyTlErcThLMEg5WFgwcDlaT0RybDR2eTZHb0FCK0Vw?=
 =?utf-8?B?L21ZOEphZkxobER2Vmh5RGg3WUhQVFR6Q09vZ3YwR3FtZUcwUGFXOFlTVW9F?=
 =?utf-8?B?VXNveE5hYmhadW9VOTdNRWVhNXBibDlVMG9RY2NFVU1ZTERXUllGTWpBSmlF?=
 =?utf-8?B?aEloL1NqTnBJbndacmxlSi9DY3pwTElTclBZeWk3am1hWXRHYWtsL29ENVRL?=
 =?utf-8?B?bnBpNUZoM3pGVXFXVjVIVnFrU2NxM0xjNmJMSUE0MU5LaXNJa0E5dC9zY2Rm?=
 =?utf-8?B?V3VqTEdqWlJVN1ZnUTVYeGoyaEd4Z0dDUEY0dzRCUVVzMEF5VzBYWGxJdXZK?=
 =?utf-8?B?SGxlSlN3SUIrRm54TXFaL2JYSWtGbXloUHRHdzRHWHYxcXFYU1p1cDJGd3I0?=
 =?utf-8?B?dlpnKzJqNXZzMmRpNUpacm9ENHpNODJ2cldnZjV0SHF6QXlhcTdjYjVpR3ZX?=
 =?utf-8?B?N2xjSURLNmkxUFY4d2x4WHdHT0NOUmR2RE1uMm1Pb3c4THd2Y3kvT1FSVFFs?=
 =?utf-8?B?OEs4aHQzdGpqWkZiZlNaOUphYmJadXJLNlB0OVJqc2IwK3VBbGR2dTlZVUNt?=
 =?utf-8?B?dXhWNGdPNU9SU05jV3MyZzNKbEtjZS8rNjRGbEpJV1JLbmwrcXhuS3hobm0z?=
 =?utf-8?B?RU5UNVJLajdHNk93b1pEalBpKzJ5WFdmV2F1Vk5GNHEzemhOMjRaMU9RRVJv?=
 =?utf-8?B?WVFzNkpiOGx5MENtY3BxWUE1d3ZkbGVZYklta2wyVzJ1b0huZEdzNGpoQ29S?=
 =?utf-8?B?eDFFZ3VCUWFjVDloVWtwdUZIUmtXWlgwVFdYNFEyR280MGxxZ3lueng5V1FB?=
 =?utf-8?B?R3ZSMFd5R0VUb2c2U2pEVTNqMTBzM245dnFkRjk1RE40K3NFRkRoZk1IZkE3?=
 =?utf-8?B?empvVldyZFhaTnlXZ3EyaVRPR3RVRG5mTTlkNjFXTjNEU1E9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c2hETW5wdjVkRGRIYWsvSG5PMU95VCsvbEpNWGxHOTFEenRhUDFkcGpsSWZp?=
 =?utf-8?B?L2ZTR2srRG1rTUZPOE4vSnM2MFVCOENlM1JldTd3eGt0Sk9WcnBmcUIzMmFI?=
 =?utf-8?B?U0EvZC9TZkNGOVdmTjRDRVlPUjd0ZDBnYUlUbk95VE5FUnhXRUJaa2VsWmNh?=
 =?utf-8?B?S1JOMXBLRUxWdS9pTzkvSEx2ZDUybW5sMEV3ZEtuWmZHcDhDbFlscm1UNlBi?=
 =?utf-8?B?bG91RlZVbHhBQXBJL1NVRDc1MFV1VXE4SW5rUHUwVnVtY0I4bG9sajhqNVUw?=
 =?utf-8?B?OG9RdWE2MzR4VFdRaUtCNlVpRXJ3VzUwMWdSVmFFbHVRdzNRbGJXV3MzYVg3?=
 =?utf-8?B?ME9CbFJlOHYrWEZvT3ptUHdmYmZNaWE4TERJTUI3UE5HWWpnaGR5TUxxQmUr?=
 =?utf-8?B?Z0h2VFpqcEc5cVFpVGVDZ3dZcDdLUm4yY2E0NFRVa3JyYzVpTVd3aThEZFlu?=
 =?utf-8?B?WFhmYld5S1UyWFpyRG8waXMwaUJBd2RBSUdvb1BUQTQ0MHpNSzV0OW5HRnh4?=
 =?utf-8?B?OG5DdzBXTTNndkwxUFluSGhjRmZvdDY4VW5Jc2s1dDJ6MHlIRGoydjk0SjNo?=
 =?utf-8?B?cHBtSklCajdFSkVJM2NWMFZkVE9MUTBCYjB0bnZDUjBDWUN4bm5EL0RMaWgy?=
 =?utf-8?B?R0dKWnNVRnJBYkRsenl2aEl5c2RzdjNzZk4yMThoYlVucW54NXFKTkV2RFVh?=
 =?utf-8?B?K2tTam9EY3NMb2RqZi9FaS9YVXBET2pnRHBOcUREOWhNUC9QcEpOZDFrOG41?=
 =?utf-8?B?ZXk1eXZySnVhQU52aVNtOWFZK1ltdUEyVXdxUW80bzhoZzVoUlJWRzhzU2FP?=
 =?utf-8?B?anBJWFdsMnRLUjFhRUs2NzlydWNXOUJsaGd6SG8vdlF3V2ZFTGdCcytneTJV?=
 =?utf-8?B?YXlzYXV1R2xjTzJFWGNDSkgxb2FmWFo2K2lzcWkrQUhtVWVQaS9paU1tSndF?=
 =?utf-8?B?R3cwSmxzVnpIQlNIUTV5cjBidUt0Nll5TjBFSXI2Y01WZzYyamRWRFM3R3Bh?=
 =?utf-8?B?eXlTUUtrM05aalNWcFYwdXZrNVFlRGVQYXpiUGUwWjNUcFVaeTVGMWVoUUU2?=
 =?utf-8?B?L2NrM1dlNWxnWmlwWCttY1J0OWIycm1mdnRPckxqcGhnYjhZZGVRRG8vOXhq?=
 =?utf-8?B?YW10b000ZS9teVpxY1c1TTVFMGF4K1B5N0l6RzJnQ0pGbnh2eWtNSUI1SnNV?=
 =?utf-8?B?dlBueVNwNDFJUnlaa0pxVDlOYkRybVFoaGhGUGxwL1F5Zk5FUWdhVzBjaDk1?=
 =?utf-8?B?czg3czZYVTU1MFFuSmxCYXhkK3pNZEM3SWJsdUVacnNTS1VFVTEwNFJhTGcv?=
 =?utf-8?B?ME5NTVdxdEZGYk1Tc1VGOXpkOXB0WnVFdXNzOC9naGZyMTBlZUFhUEZFc2w4?=
 =?utf-8?B?Z2JKUG5rcWJvaXNHQ3NIT0p4NGtZWTFQVkNkTWVaK2pMbjdtUmZGckxHTlRk?=
 =?utf-8?B?SUg2K3NXLzNJRCtGVEg3WERvQkprb3ZDbVgranZWMFFEeUZjY29RUzZ0ZHdI?=
 =?utf-8?B?KzM4MzIxVjhnRnJSd0o1bUNTOFBHZlNVMmJyUi9LZy9Ka0xEQ09Ld2JmZGF2?=
 =?utf-8?B?NFRsa1cvQ1J4V2VFYnlCUCsrZ1JKWVpHNUUrUFJsNlRDZ1N6dUVsNkxmOENm?=
 =?utf-8?B?Zzh5SGJDUU9pY0FHVzh6WkVDaGtnY0MwSGh1bDJrVW9WYVEwdjRlOGlmNmt5?=
 =?utf-8?B?KzV1dVZ6QVdQTlJTZGhsQ0tZWFN6ZWtRVzJONERRM1NqbXlJN3FjcEVhVEJz?=
 =?utf-8?B?d2tzNWo5dG04SHZENlRSdU05L0YwV0ZJdHN3WFc5dmdORzhoajRJSkRnaUgv?=
 =?utf-8?B?bEIwcDNlWnZsaktTSE85eXdtQ0FscHBOSlpNbldRY094cXd0U050cVBUd2V3?=
 =?utf-8?B?Vzl0TGhEWThGSDJnS3VHbHRiK3FUTEJpSXplNFdGdFNSYi9CeDFCM0hEL1hK?=
 =?utf-8?B?aDFlWWFpQml0eHdic3pSRFYyaHo2TDk0NEFVc1RmZGpXb003SjhEWFBoRzBY?=
 =?utf-8?B?WlNEQmJSWXlpc1hTanFva2o0UUZKNDA4Y3Z5dFpOQytWTFdKa2oxOHVIZlZM?=
 =?utf-8?B?M1ZJTytrcXhaUkhxeGo3c1RvbkpWS1FxUXNCbXhwR0FHMWFEWC9yQzFsSERN?=
 =?utf-8?Q?4uz4UsOcf+O/++hGzItmuC+wk?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BD5398821030DD44A581DCF3E1027931@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82e7d983-abe8-4dbf-0028-08dd1611b0b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2024 16:18:59.1078
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4AMi0iY6rhkHaEpwj8j/inVdaE3+LFmgsxdET1U+imaAX0cx4fsCWUEMDJvcLAD4A01Hsg8IY2dpjxMUkAx9rQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV1PR11MB8844
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTEyLTA2IGF0IDE2OjEzICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBJ
IHRoaW5rIHdlIGNhbiBhZGQ6DQo+IA0KPiAJaWYgKHN5c2luZm9fdGRfY29uZi0+bnVtX2NwdWlk
X2NvbmZpZyA8PSAzMikNCj4gCQlyZXR1cm4gLUVJTlZBTDsNCg0KU29ycnkgaXQgc2hvdWxkIGJl
Og0KDQoJaWYgKHN5c2luZm9fdGRfY29uZi0+bnVtX2NwdWlkX2NvbmZpZyA+IDMyKQ0KCQlyZXR1
cm4gLUVJTlZBTDsNCg==

