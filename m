Return-Path: <kvm+bounces-34857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8727DA06BA5
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 03:47:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 172221888D65
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 02:47:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DE1084FAD;
	Thu,  9 Jan 2025 02:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RsK04e/W"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF4E39AEB;
	Thu,  9 Jan 2025 02:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736390818; cv=fail; b=Iq8obtj5HZIKhN25CyNXdyZBgkuEIVQw/aycctujgmOtn7KKbR0IcrGgYj7sQZeEL/gIwVTAeiAL4+KbguZmWfqhcwZ1rUfHlycRYchTLnnKR8a7b+ZjpZkseHF5IaQWhxf1Xylhdm5f0RvfhyBagxWQguwNLo11UCgFA+1BPhU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736390818; c=relaxed/simple;
	bh=+z/05XGI41vgoXoucbxJD+I6tViTSxQca0jcwBV0ac8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=U6FH72GK/FAsdLqVjfsJKSd6EhXwoEthN0ufGHhZre8uIAsHDIV7tlphO8QuMDVDuPkVUSmORMsxsUMyTyYNtGnp4mvlXbrefuJkY9vSxx2fE9QCsmA66ADOuiq+J1EP23ix57rbg5Gjf7SVH1J1fyCg8opTTcflcNoYoMMXtLM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RsK04e/W; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736390817; x=1767926817;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+z/05XGI41vgoXoucbxJD+I6tViTSxQca0jcwBV0ac8=;
  b=RsK04e/WnjOGrH7ZhnSxEx+rTYEBND1edszzXBqXZnmzgpDksZ3qyPUD
   U3aSG1rH94HXhfGxuWFky3RWMCvl8ieFHAhUqZJ3oxm4fCRpYi1E7MDNo
   QecAtlid5LMytN4zaG4hYr84l49nGkgEbk6R8FWNkRh7LIM1J1GufYM2n
   DWvS9Qr1KOdBLSoZNHpDYcC0FfkeqORTogrqxSE1hDCMT5JlnL1ckm38F
   7QPcT+rd8aRZvEg01PW73pJoU/betK3wdaLWSfmua5bANRTQbX12GNjzE
   MbrY+TNz+gZw2S1v2ZWhXw6D3QwA4SG75VbFai+bteCYGaVvnDSPiutGc
   Q==;
X-CSE-ConnectionGUID: InzKb8eyTHOFMdUvQCz4jQ==
X-CSE-MsgGUID: MWoU8p6bSu2zcjgKg/i7cQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11309"; a="47211825"
X-IronPort-AV: E=Sophos;i="6.12,300,1728975600"; 
   d="scan'208";a="47211825"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2025 18:46:56 -0800
X-CSE-ConnectionGUID: fbPxXZIdSj2BAWnMNMJWzw==
X-CSE-MsgGUID: 3Bqe97+OQKSPVIO9EejoAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,300,1728975600"; 
   d="scan'208";a="103797697"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Jan 2025 18:46:55 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 8 Jan 2025 18:46:54 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 8 Jan 2025 18:46:54 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 8 Jan 2025 18:46:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v/dmsjLtDxTilvsGffA72SEIIyuFNSERUd7rUxvWGYoAcVtfo/qaztMX51vQcgUYvEUQDwPtYUrVofQR2x8V946qSOsbwNHwQjWUG/1fLUBzANGeQ5A25C6dDqeQQf5wQsynEsZr86siS/89S5tZ6tna49zu9VUhV9nwT5pAkZDgZUqBJZpHscQGHv9Ki8XkHNb8p/0JVehIM92p0EE2v5MhH3yhoL0q/zEh3ter3O43H24x59IAFij20ZFBrLkd4XzrAM49DFOSpEl5dGueHkWFI+jKW3eNFHK+6Uw+ZPv7S/IR+IOYV6MzgN7IKvk29E0DXLa4t1rJ3wOQtqN0OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+z/05XGI41vgoXoucbxJD+I6tViTSxQca0jcwBV0ac8=;
 b=iXilg5VvvMniIacpkTJRZkGSyWxuNTu/bl5Fv7EzW9q61yfe9VxuWPK9dmwLZ8vmMYxUj60UhYna4rmc9d/m6ZjgOhe/YGctWCdu2j5qSvfkWq25ZhfJLDl1TjtZXhe9AjQ0V1AhKDsnLuRfRIhQa0cOK0Vp+mTouzKYKM45Jn2L9ZkZTC1Tk8GRPmbmTjUehYP9CXzyZsYqEVFNxJ4+ZOOP6jY78BXDjKaC2PN5QWGvDbv5pGdN92blTLLbLqea8Y4RmIvZThFMvYWdbzBgW4pL+AwHPgv3+P4t1zPpS3Wd5nlE7QpsI9llrAQF3pFc7enkGPpatMcmVT8ALsm68w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA2PR11MB4843.namprd11.prod.outlook.com (2603:10b6:806:fb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.12; Thu, 9 Jan
 2025 02:46:52 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8335.011; Thu, 9 Jan 2025
 02:46:51 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: Re: [PATCH 11/16] KVM: TDX: Always block INIT/SIPI
Thread-Topic: [PATCH 11/16] KVM: TDX: Always block INIT/SIPI
Thread-Index: AQHbSdaN3/8Qprs8nkqRa97lp/p8PbMMqC0AgAAJCICAAHGogIAAxUUAgAAFpQA=
Date: Thu, 9 Jan 2025 02:46:51 +0000
Message-ID: <de52a2dbdcf844483cbc7aef03ffde1d7bc030d9.camel@intel.com>
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
	 <20241209010734.3543481-12-binbin.wu@linux.intel.com>
	 <473c1a20-11c8-4e4e-8ff1-e2e5c5d68332@intel.com>
	 <904c0aa7-8aa6-4ac2-b2d3-9bac89355af1@linux.intel.com>
	 <Z36OYfRW9oPjW8be@google.com>
	 <8fccaab6-fda3-489c-866d-f0463ebbad65@linux.intel.com>
In-Reply-To: <8fccaab6-fda3-489c-866d-f0463ebbad65@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.2 (3.54.2-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA2PR11MB4843:EE_
x-ms-office365-filtering-correlation-id: 5e99fb45-c322-4981-7417-08dd3057def1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Nzk0QksxN1R2MmZsckd3RVEzNlBuc0hqdmxFUWt4UloweGZ4VGs4ekJWVGNI?=
 =?utf-8?B?SEwwTUpydFBnYmhLdVU0NnpGVy9tTmc1S2dXZjlBTkV0QVNQa0dhYkpEck1j?=
 =?utf-8?B?RWVwd0ROUFNnTFJuMnptS1U3MDFzRzc4bUJ1eVkwMUNMM3ZrVCtoL3NUWEVj?=
 =?utf-8?B?WVRlVHhVRTQ3VkJrR2NxaFJUOG9MZFAzRU5rNGVhSnNEemVGMTVtT3NCZnhQ?=
 =?utf-8?B?UHVLVFlNRFY3OXk0V0VhaklNV2ZLSnBmL2NJb1FCT0NWdS9vWENpa0cwM1hW?=
 =?utf-8?B?QTdLWGUyblBrT090MXFnYXlocktBNU1UdHpQNVhzV1F1MExUaWpZakRFMmkx?=
 =?utf-8?B?NGlacWhJdTE4ZTE3M2dFRmxkc2oydkZnVU1UbzBSUHhPYTZhQjJTa2IyYk50?=
 =?utf-8?B?aDZ4UGIrRjltRGxZUTBUV0M3eDJUWitNaU1xblNHamZqRHQwYlE5c0hSaXFt?=
 =?utf-8?B?UE53RGJYaTlaOGpvU1FBZ2pVK2hRQktYeVNEaEZmdkcwNWxweW40VlI2Wkdm?=
 =?utf-8?B?SDlidjhqYUZOVEptOHBsb3hIVTZwQjh0ZnQ1S3lmck0vWFo2UXNUYlRSVlpE?=
 =?utf-8?B?ZFpHWURRYk92V3pGMktDR3UrMjNPWWZkcSsrTi9lTlNyOUZiV3dqNm01UzZK?=
 =?utf-8?B?YzRXWDZ2RGpEalh1VDh4eDhBSDNTamV1WkNISWN3eWlyT0RnS3NpOFE1Njht?=
 =?utf-8?B?ZkpuSVQvQ3BGS1Iwa1QybVVlaHZYeDNhQ0Q5MGl3QWJBQk9ZRkl6bitYc0Mz?=
 =?utf-8?B?ZktaOXBMSGloWHpSUUluYWdQUnh5KzNzMTVISzhBZVZ4M2licGtXczgvRXo0?=
 =?utf-8?B?dlZSRklLNkxLay9ReEoyRjBRM1YyOEs0OEdIY0dYSjBrNnM4dzNIYVNqRFhh?=
 =?utf-8?B?S0JKK1pqN0dKU1ROYSs0Vi9FMExXeXVXaU9qTml3VGxxTHJqeHcwN0V6d1Nv?=
 =?utf-8?B?b0V6dnVNMk9FVy9UMUtJRHJ3cmNnOFZqMFRFM2FBQlFZZkpYSStjbVo1SVdm?=
 =?utf-8?B?UG1zQjhuelBpT1VUZXNEeFFTRGd5YXJWL2I5WFY5aFdYVnVEaVpyeTc4Wkpx?=
 =?utf-8?B?ZUFwcWZFUDZ3MkROMDVNNERFVmZablBVZ3VNVFNvNHNFdm54eXg3Vk9JN0lD?=
 =?utf-8?B?Y0haNW40cG8yKzd3Y0ZMcjE2TnRRK21nQmVvWVBwdStqc0VoUDk1MDBrUklo?=
 =?utf-8?B?cFVPcVlOK29uY3JIOXJpeU1RQUhDZno1YUU2S3hxS0NnRU9icVlXMktRQlJW?=
 =?utf-8?B?QUxvR284dVF4ZW5aSDBBTEVPcjNTREVIWmZuU3p3OTVpVFZ6eGtTTzVnU3d6?=
 =?utf-8?B?eW15eEZqbjhXM2o3V3hhSlhacW1HWE5mbnI4ZXdhczNKNFBNVjBFNmhjTWRk?=
 =?utf-8?B?ZzFEaFB4aFRSWGtsZWIwSUVHNStBSksvT3l5SWZvNno0cDZpamRuK3dubTIx?=
 =?utf-8?B?VEp2djVJNW0rVENvRGxURU5La1dyM210Q1BBRVhtNmp1TW1GRCtPV3hSMEY0?=
 =?utf-8?B?dEZFVUU4UUZpSC9MaUxVRDB2ZElhUGN6eUsvZmY0bDhUOHNCSmk2VWROWVZx?=
 =?utf-8?B?NWJLbEdWbzEzZGVrSkJzN0YyWldjSGFTOXpya29CMHhITHFmSkpBTmRJdlNt?=
 =?utf-8?B?UWl2ZEpyZUw3K0NJUkJsNi8xNWY5eUNLYmZFM2ExcUJ4c0ZuaDFyUUhscGp2?=
 =?utf-8?B?cVpnMUx0UkVXZ2FQSWlsdW9WT2VHMmtwYzc5dDJQdGNqcGJFUHpZVkdLZjhC?=
 =?utf-8?B?WE8wNTgyV2Fkd09uWStjUWUybEgycWVrQ1I5N0hDcVpuNjd0Mm1yRG84ekh6?=
 =?utf-8?B?Q1JHYmJmVTVabVBzMWpGcHQ3elIvN0ZkMVIxLzhmMVlkZzEvL0ppRHN4Ni9p?=
 =?utf-8?B?UXZFM1RuN2pzSnpScGh6OEl3TEpqcUVXSzhMUDF2ZncwTS80OHVaYmJqWEdv?=
 =?utf-8?Q?a+5LK6oSkJwqazFaWQXhe0+SFC0SARhE?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V0dsWUNWT1VjSXRCNFpJdW1KditrTms1enBUL1JSQTRIc3FkQWxyZ2d4NzI5?=
 =?utf-8?B?SzhwQmdOVWxKNGFjWnNlcmxHOTlyOFRGanBaaWhsZGI2NnJpYmcvRmdQeFR5?=
 =?utf-8?B?YVoyVDRWOSs1MTFTQm5FZHhON1VXTW1wQ20yN2c3UDRnSU1aem9nTmpPQXpH?=
 =?utf-8?B?dDEzTWdVUWIrelFmLzhCT1M2NjZUelNtS2FXTFcrdjQ0Vkl4TmxPeDJabFJG?=
 =?utf-8?B?a1BHbGpXY0FsamVDMml4UFRwMTlzb0hKMGpVUEt4T1F0WVM2d2Y0MTQ0dng1?=
 =?utf-8?B?cFc0OUdzaWlUUUpENk80UmY4dFIycDlpL25sZnBWMktsckFyWnVwTjVyWHNQ?=
 =?utf-8?B?ZUNjSFpCN0M3d3RmSG5XSXM5RmdCYmJFRjJka3lYYm5ONVFhbldoY2JVVGVa?=
 =?utf-8?B?bitCM0IxY2Vjc0d1VEZkcS9GVmVXblV1b3oxbE9LeWtQcnRPcnc4RFhzcFBz?=
 =?utf-8?B?WE5DeDRiSU5ud3czcFlpaUFiMmdOQzhmbFZ3MnFOUXJ3SGtReFJ0ZERnaFlN?=
 =?utf-8?B?UzQ1VEpPV1A3S0Y3Q25HckNlVlArVlBvb3R5MDcycVAxVjhIV0lNL1hIRjV1?=
 =?utf-8?B?SzRRS2ZLRVRqTWowemcvT1FPcU93UjFyZEFUMXZsOVNUQUhzcFNTS0FSd2hE?=
 =?utf-8?B?R2duVEtWemozeHM4MzMvOWtzekJ3c1YxOTE2Q21XQnJ2cTIzRkh0VEo2VGVG?=
 =?utf-8?B?MTJINm14MnRUUnBnTFAxeTFEdjE2a0NaY0wwZDVuY0lrTGcxWHByTTRtQm1B?=
 =?utf-8?B?YWQ5VFhtMXVHcFlqMm1haXV2T2luVURvWFcwbzEySmk0SlRVcVV0N1JQNXB2?=
 =?utf-8?B?UFlCWVExQWpmYzZ4Znpzdk0yUGt1NS9ycHd2dit0LzBHRGVrY0V5TW5PRjFT?=
 =?utf-8?B?YXpsTFU1TEM3dXlyY245ZVpvZnlEbEJxMkJURnRlWU9XWU9xN2YzaGVrSTli?=
 =?utf-8?B?MHNGWUVKcGZ1S2VQTHZsdi9VbHJEbVhWWnF3VHVhbThGQ2l1ekZReDRKUVM4?=
 =?utf-8?B?U2llSHozcWR4UjVnaHA2cUFHQ0ZYdXpuMmJiYWd3bEJ0VUxoSUlHbHRPZDFN?=
 =?utf-8?B?bzlscXkrTkhVQldsVVB5ZWNQOFhrWUNodEZKcGtCTjF3NFZNR2NtcllvZWtO?=
 =?utf-8?B?Wm1aNlBNZGxmcnFDV1N0QXBrWFZrd0FkTTdtSkVLN0RRVzZ5aDVBeTczV1Y0?=
 =?utf-8?B?Nm5hQTM0MWNvQU1xSzZCZVg3TXplcXdablVlaE9tci91anRaZCtiT2FBMlNp?=
 =?utf-8?B?bjlIbGVVNVYyc0RQcjloL0huREQ1a2xvak1ZdnlIR2JGeFZKZDNPNDZ4dEdp?=
 =?utf-8?B?MllkNHJIazdBTlp1aWdWamZ5aVF3V3dTL1FmbDNMNUsrZFN0VG80dW1QNld6?=
 =?utf-8?B?SjJQSkxWMFBzL1Nlb2h6clh4cUZjVms0NlZxTkNSTEVXNGZPeG1Pc0F6QW1m?=
 =?utf-8?B?dGZ0NG5uU0haOGNwRjc0MTh1SkpjRDIydnZ2MGZTd1V4VHZGUWNNdGNOdDR6?=
 =?utf-8?B?N3krTkp5QlJ3eDFMcml5RmhLSjgvTTlYeVFKNkJOVTZKdTFmSklQczlvUEpB?=
 =?utf-8?B?YnZ1dll5QnJ5Z1gxQndVU25aa2ZpWlVvVlhpUFE5b2ZKYUc2eGoxekUvbHB4?=
 =?utf-8?B?Smx6dGtNTFhoR0RqdzJmam5tV0hMelB4YWlxUTYvaW80akhkeTJCYXBBdmE1?=
 =?utf-8?B?dEtMeUxRWXdIc2Y5WWZoOGxuYVZPazNWWmViNUVpU3owUCsrVm9aMEFGdXJ6?=
 =?utf-8?B?aWI1b251SDcvYnhEMkFZVWREUWIwQzY4aHR3Q3ZreFNhSVNZY0I2Q3dlNkNK?=
 =?utf-8?B?VUpXbGZrYS9ZWC9PRm8zQWQxV3JnY2pDSUpCZ1A5WnNTTndkYVB2UTU4djQ3?=
 =?utf-8?B?ODNOQWVTYnZ1TDVuU05EKzVYRXRKbDd4dXRjSTVRdUdvSUo5dzI3bklSUnRK?=
 =?utf-8?B?ZjUwbXpMKytrZ2pQZlJ6M1pBRmo5T1RGOEtibzJ0RGN2Uzd2UUpUN1h4dG9w?=
 =?utf-8?B?enptekwvYlluL0ozSGM2ODhWQnJ1ZGRqclhBRjZQeDF1SjgxcHp2L0Vjb09E?=
 =?utf-8?B?aW1MeW1MeXlNVGgySXpDcWxiQ0tVUm8wdmdtWWFlZlhEZHN0MDAwaUtWTGU4?=
 =?utf-8?Q?LK6GxBXXdgzcsrVgp0m/uqWWM?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <444E276B51CDEF42A5BE7FCE7F0964C0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e99fb45-c322-4981-7417-08dd3057def1
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2025 02:46:51.6858
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UiBM/jkYkhPDGVwFv9a5hkaxUsbV4uf8hmhA0eLU+zDMh5OxHauZ5kERLj42e8djSJ8cDO5vtFQwmJv2T2GjZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4843
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTAxLTA5IGF0IDEwOjI2ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+ID4g
PiA+IEkgdGhpbmsgd2UgY2FuIGp1c3Qgc2F5IFREWCBkb2Vzbid0IHN1cHBvcnQgdmNwdSByZXNl
dCBubyBtYXR0ZXIgZHVlIHRvDQo+ID4gPiA+IElOSVQgZXZlbnQgb3Igbm90Lg0KPiA+IFRoYXQn
cyBub3QgZW50aXJlbHkgYWNjdXJhdGUgZWl0aGVyIHRob3VnaC7CoCBURFggZG9lcyBzdXBwb3J0
IEtWTSdzIHZlcnNpb24gb2YNCj4gPiBSRVNFVCwgYmVjYXVzZSBLVk0ncyBSRVNFVCBpcyAicG93
ZXItb24iLCBpLmUuIHZDUFUgY3JlYXRpb24uwqAgRW11bGF0aW9uIG9mDQo+ID4gcnVudGltZSBS
RVNFVCBpcyB1c2Vyc3BhY2UncyByZXNwb25zaWJpbGl0eS4NCj4gPiANCj4gPiBUaGUgcmVhbCBy
ZWFzb24gd2h5IEtWTSBkb2Vzbid0IGRvIGFueXRoaW5nIGR1cmluZyBLVk0ncyBSRVNFVCBpcyB0
aGF0IHdoYXQNCj4gPiBsaXR0bGUgc2V0dXAgS1ZNIGRvZXMvY2FuIGRvIG5lZWRzIHRvIGJlIGRl
ZmVyZWQgdW50aWwgYWZ0ZXIgZ3Vlc3QgQ1BVSUQgaXMNCj4gPiBjb25maWd1cmVkLg0KPiA+IA0K
PiA+IEtWTSBzaG91bGQgYWxzbyBXQVJOIGlmIGEgVERYIHZDUFUgZ2V0cyBJTklULCBubz8NCj4g
DQo+IFRoZXJlIHdhcyBhIEtWTV9CVUdfT04oKSBpZiBhIFREWCB2Q1BVIGdldHMgSU5JVCBpbiB2
MTksIGFuZCBsYXRlciBpdCB3YXMNCj4gcmVtb3ZlZCBkdXJpbmcgdGhlIGNsZWFudXAgYWJvdXQg
cmVtb3ZpbmcgV0FSTl9PTl9PTkNFKCkgYW5kIEtWTV9CVUdfT04oKS4NCj4gDQo+IFNpbmNlIElO
SVQvU0lQSSBhcmUgYWx3YXlzIGJsb2NrZWQgZm9yIFREWCBndWVzdHMsIGEgZGVsaXZlcnkgb2Yg
SU5JVA0KPiBldmVudCBpcyBhIEtWTSBidWcgYW5kIGEgV0FSTl9PTl9PTkNFKCkgaXMgYXBwcm9w
cmlhdGUgZm9yIHRoaXMgY2FzZS4NCg0KQ2FuIFREWCBndWVzdCBpc3N1ZSBJTklUIHZpYSBJUEk/
ICBQZXJoYXBzIEtWTV9CVUdfT04oKSBpcyBzYWZlcj8NCg==

