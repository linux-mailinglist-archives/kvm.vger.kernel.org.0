Return-Path: <kvm+bounces-34513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A355A00270
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 02:28:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 35163163249
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 01:28:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E838F157E6B;
	Fri,  3 Jan 2025 01:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y0d6C3E2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4499F1119A;
	Fri,  3 Jan 2025 01:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735867711; cv=fail; b=HEVLndpT5z2PkFWvmXaYUfCO7yAensg8dQf5mJPLuiQ4KvUrYP4+gNAPipyLBcVU50uGdCrjnyZUqxotB7QV7wn+FxM4a2ib+QHRqMQoPzRhfbxE3FxN7YibwZ8NDyI9UGoEDxvxRlOHH1EETcgxnvsfPpHzMaFOOBHGl1xFvcU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735867711; c=relaxed/simple;
	bh=6I7G76Akv+y/AWJtIvY2roUbe4FO0W78edBcm0USqjo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EhgNRyqSZ2j2LZT5Bqnj8kXoL7OpRWoVCfejj3GwkHa/avrTQxs7gVDOVJF1HbK1Fo1pB2CccWPe1g8F2AeoqJ6u/xR/DBXe5ltWC+JFRbsnTp6VZ196rEW+w2o9FicI3Q+EOuJWAIN887UhDuI9Oa+xShXNn6CPCkXXoDYLaPc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y0d6C3E2; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1735867710; x=1767403710;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6I7G76Akv+y/AWJtIvY2roUbe4FO0W78edBcm0USqjo=;
  b=Y0d6C3E2/yexTAy+8Eu6ir7m3eonA4XlIZAXa5m+fSxu0Uu7pjHYCvrC
   luendy9Y1szRjIqFqbqCEtOEBOxW1VK/pA1LQii6ajcBRlQP/79lCbI9t
   aqaPI8RIQCOnpwqw91BfM0rV6Yun8rlBEaEi03F+ln+yF2BUJoR2+J2H1
   prrxfWcdBZ4ohj4+oaccsH1K8gmvhh6ywdO+vxdLw6ol/8WqS8waKJ87t
   ti04Yy4H7kOb/fHJJ/JaJy3YpJcRhwSpGgyVGRMdogOtVP71SKmNLMZdG
   NU1PXRJg8p+xAfwli1pSoALj2dZOkGtnJ+D6QZJrNWnCvq09fRbdfbU0T
   g==;
X-CSE-ConnectionGUID: OEQolZMrQxSJyx9DSHjkWQ==
X-CSE-MsgGUID: yMwteiORSEeLD9vdl6d93Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11303"; a="36021562"
X-IronPort-AV: E=Sophos;i="6.12,286,1728975600"; 
   d="scan'208";a="36021562"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2025 17:28:29 -0800
X-CSE-ConnectionGUID: wiURT8OCQ/SHfWqWzPoOVg==
X-CSE-MsgGUID: j2MTa3xnTOW0j/vVF97aIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="102515497"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 Jan 2025 17:28:29 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 2 Jan 2025 17:28:28 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 2 Jan 2025 17:28:28 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 2 Jan 2025 17:28:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RJTZEbr3Zd7T0+6b3nfRiiXj1kQX/Aly2dddgD51hrCAXUgHVEBz8lGPaHmXTk3jtP8UaUUChVKdsQB6AQwTbfHkpS+n1zdko5nd4RlvC6yasCaVSWaKa4xWPDEsrWuhgBuOxedUFWAiTZAlAuz3XRM4Xf4aCSyYXuSWmxPesYzUTviMKyX9CvpIiX9BNvH2O+Qytzin0yRmhnoEW9MuwuyQC1d1yZ7zbv4cyzo6EGQkzD8e+dXjFjwYyoiu68hr47GS7UucGlCG9Lb+yvlfHeQpXdW4USfJEN78T2vst6rgSRMc9G0l1le8piP/TrDv9aFpOTxfrvPkVaSvPHnwbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6I7G76Akv+y/AWJtIvY2roUbe4FO0W78edBcm0USqjo=;
 b=YbO91mz4fwaK0iZgKTZS0pxXUqN6bzd3skj2GrERiLmlUHuLcDP+SMAOsTkU3uC07FmxV5g0540C/VtpzD7vLvreoLnXTReh3Sr4eP5VZR2Nlgf12xGbDpbehoyDb8gRwBtbdQH4xnKWozcUtCYpDV6d0DMXYD5oJl9urWGzMTekaSeJxh2xaNMemB2VDmaMH1MPGaNNmG3PYLxVQyiJrWn8iB6EGpTu7NuydDINSt5zuQc/hEB3Atx/hHKbaBFw45oqYFav9hNjnwVNzjLE1Ce1GjMoqloDEWcoidaIXw2KnGDPSDqsWw+OxVCaOazt/LR0u5D2H9tL/YPuP4emkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BN9PR11MB5242.namprd11.prod.outlook.com (2603:10b6:408:133::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.13; Fri, 3 Jan
 2025 01:28:16 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8314.013; Fri, 3 Jan 2025
 01:28:16 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "sean.j.christopherson@intel.com"
	<sean.j.christopherson@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 09/13] x86/virt/tdx: Add SEAMCALL wrappers to manage TDX
 TLB tracking
Thread-Topic: [PATCH 09/13] x86/virt/tdx: Add SEAMCALL wrappers to manage TDX
 TLB tracking
Thread-Index: AQHbXCHYNUGT+KYkG0KHjova/NAI17MERUGA
Date: Fri, 3 Jan 2025 01:28:16 +0000
Message-ID: <fb17ae7ec64fa1eb884ab87b1729cdeb79c32871.camel@intel.com>
References: <20250101074959.412696-1-pbonzini@redhat.com>
	 <20250101074959.412696-10-pbonzini@redhat.com>
In-Reply-To: <20250101074959.412696-10-pbonzini@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BN9PR11MB5242:EE_
x-ms-office365-filtering-correlation-id: 97e60683-7bf8-4b4f-94fd-08dd2b95e62d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bG5WQjYvcFVqdkxzUUt2ZkJ2NnFIMFg4M1BpM3NwbVdVYzNKcUpTOW1MdG5J?=
 =?utf-8?B?WjJsK2lPR0ZRRHRMTytWZzgxOWdwUGVTc25YOFcyckhFWm1BMGlnUFhEUXd2?=
 =?utf-8?B?elZrbXgrRFR4bkJhcHNNWUk3cFZHMXNJNDdBUkhlMUQraTNVdzB0VDEyLytv?=
 =?utf-8?B?RUo2bngrQTUxSUEwSWJpa3JZQmhBYTAzSFRPcnFETnZDTU5XMkluWUZSUXNK?=
 =?utf-8?B?ZTZ1M3RIcmQrR01uby9NTWFYZTlMbmxIMFlzQmhOa3ZQeWMrL2lhZmI3RWhq?=
 =?utf-8?B?RE5MQUg3SDQ3TGtIKzNHcHltenZuR2FZdDRiN2owa2ovN0NUSFRiandUU0t4?=
 =?utf-8?B?TFhlaSs2S0NRNUVocnNkVFB2MzBvRVpCQldlTVd5dXVxMERBbG83TWxEUnpH?=
 =?utf-8?B?TXJoRTNTWGl1UFovdkhaTkVZcDV4VTFwNFI5amM0TXdvYUw3RHplNGc2Qnhh?=
 =?utf-8?B?TEJzQ3lXcDNsNlU4WEY1UDZzb2lGU2NsTVordlduKzNRUVJBUytObnp2TENG?=
 =?utf-8?B?N2VqcWovQnIwQmx6TEx2ZlZ2Mmd2WW13NkFBaDBkaUYxNitoK25CUWZSRTZC?=
 =?utf-8?B?MElBdU5NMm9vci9CbXJiZ1F1eFZ5bElpSnlTYVpuVlUrY1VKU2xIVXJGTXhB?=
 =?utf-8?B?TkVHS2pHcFhVcGRNeTJqMG9KSlBRRFVaTFpLYng1dmZYUDFVUmlVd2d2RnZL?=
 =?utf-8?B?a0lCa2hlRFhNWm9nV01SVlJNYzdhUk5BT1ZLK0tHMlBJS0dBZENkaFJwY1hF?=
 =?utf-8?B?MWhoNS9nK044MDBkYlJHckRkLytuV2x6WmgxL2R2dnZDZmZFSGRmdDVGOGlz?=
 =?utf-8?B?NTRmNmQ3dFBFQ3VGNDBxWmtUR2VGQjRYcHduMUJ6VldoRWFZdUVSQ2thQ0dl?=
 =?utf-8?B?UFdySUtjY0REYlpSWW5aNFV4RlppUW5XemFDcFhVSUV6RXFGYmVkcXFzWXl2?=
 =?utf-8?B?NFI0QUVqSkp3SittckkvVmlzOGlRMnFDUDMwdDNRVWtwamZHV3luSDVvakF4?=
 =?utf-8?B?RXFkV0dXLzlxdEFaR3pLMEd2MjNjNyt4OVR2QUZuYllicmVpVHlPRVlzdGFT?=
 =?utf-8?B?TXJicGhHYUFBUTZkZExUZVA2cFI0TkhOT2ZWcVFGZ25rdEVkZzludGU5WXIr?=
 =?utf-8?B?UkRhaUxhc1BmUERQSSt3dVdoTXhOY0ZQU3E2TXNKSVprZ0FOT0hCbTh2RVBC?=
 =?utf-8?B?SHJXTFRNbmFSc0V6ZUhSNldaSnMrclBZVFM3VmpidEJQNFZSYUV1RndGT1BM?=
 =?utf-8?B?SUxEODhzV2Yzc2JqRi9tSFRHSmpZam53R1VSN3dxanVCOTRScERrK1pUSzVx?=
 =?utf-8?B?L2g2b0J0N05VRVFHU1llM3JWVVlHdUpsNjEwbUppcmlLQ1l2RFlmYTYwL004?=
 =?utf-8?B?S2ptakhJTEZFMGhMeFEyN1hLNWlnZ3NPY2FvZ2h0dlRkbko3NVpGMDhSMTJY?=
 =?utf-8?B?MHRsbStMUDVjc29vMzlVWWFhb2t1RVNuU0dUaDFJa0RFS2tpL3Q5NzhsSDFV?=
 =?utf-8?B?RExBRFUwNHZ0L2FLaDREUmhLM0ZTMmNLZWNJblh5aUYzN2s4azFBTEJXUXIw?=
 =?utf-8?B?SVdIWklPZkw3SlV4Kys3WkFmeFBNYzZyNnE0OXB3cWFkTVZYVWpKckhNVWMr?=
 =?utf-8?B?VG5rTndIeFo0YVk0L0RhZUY3Q0I2Vko3NHN6Y0poM0V0Nis2S3BpQlllaXVv?=
 =?utf-8?B?TTQyNVZCd3psd2Qrd0RSZHRodjZDU1pWKzRjalJ4OEx1eE5WK0pEbHJMQ3h0?=
 =?utf-8?B?b1FubVp5NG96OEw5eW5uQ3ROWXVWTm4yM0hscDF6VHJvaEY4azRQMXgybWQv?=
 =?utf-8?B?R3NuVVVWZ2RMM3J5b2UwRGM4STNSVHRGVCtOM2loUzEzSjhVY3lHYWpsZXRD?=
 =?utf-8?B?K2pFRTZZSXp0Y0kzQ3J1KzlUVEgyT3BHRXFqRmhWOGNMeTdITTRwRGpXeXRG?=
 =?utf-8?Q?kvf5svwEjzwMxwCeP7UH//P3n4EzWPiM?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TjMwbEk5eTd6Zlk0TEUyU1FWL1BZbUpkSlhlZGxXZmZncXRFSExPSThTclZi?=
 =?utf-8?B?eVZEUWd0N1dpa2gySHJqQTRuU3Blc3ljZjdxbDNEZzJHdTRFV0xsd3A2bE1a?=
 =?utf-8?B?OVJZMnpaTGRIREsyeHBjRTVWeEw4alRvOU5ldDBaRnJtdGRLM2VsMEZONyty?=
 =?utf-8?B?cXkwS0VBL28xc0F2L2x2dm9KMTM2bjExS3duWnNNMklLdWNZUEdxRVZObnhl?=
 =?utf-8?B?Vi9rbGJsWVllNHJBa1VtZ0tKRm9GSU4wZVYrZ1UyZENWSUx1TnlURUlqOWFJ?=
 =?utf-8?B?cGVFMjZWNmRKUnV2QmYvdmdMSXF0TVEvZ3R0ajdxazl0clZETkZPUm5USzJG?=
 =?utf-8?B?S29wREdkaXJaTlVFLzhlREJqNmxCMXpuWGZ1OUxoSEIzYkJKTmN6eHREdTRE?=
 =?utf-8?B?NDcvV08vY2xobzc4NXIzMXNwaGlmNVlwcitDQ2xMeXJnZzlUN2RVTUlzSmF3?=
 =?utf-8?B?VEpwR05SNjJvUWFObUIxS1JsRk1zUEZmSjY4OUR0VXNSZC9zUnViZTFITllI?=
 =?utf-8?B?cTZ6L3hqUkdZL2JFQVRHNVhCeVQ1empZOEE0ZlJZWU1xUW9QVWhabGdoc09G?=
 =?utf-8?B?dEJjV3Z3VHpyUk81WHB2WVBDcXl2S20xWnl0U2V1aCtOZXNIYlpPNWwwL0VV?=
 =?utf-8?B?THRUeTNua3NKejNnU3pVWG5NbkpQOFdaYUg3VWhpL0R2b0VVbDlKN05pV3h1?=
 =?utf-8?B?bENsTjNabzVkd3E3V1k5TXFZM0NUdk9EdGF4WGMzRmhQei9ZbmRpWHBYSi91?=
 =?utf-8?B?RTRFT0tOZ0ZBaFNQR2tmMG1oeTd0YzgyUFJpdEo1Mlc4L2NidWp6NXdTdktn?=
 =?utf-8?B?a0VLY3I3ODQyN2lMR01EK3RwZW02VEdZZVplYll5U0VBK2lOUnpZT01GRUdG?=
 =?utf-8?B?dGd4aVhJVWJBMHRPeCtqMlJkdEhIQlhXcFZRVVJMQlN2WHl6ZitkekVIUVhE?=
 =?utf-8?B?YzF2MjV3RFFVell1SzluNUVCUGF1U0I5R2RPWTFTUVl6QlB2MEFIMThOZkdt?=
 =?utf-8?B?ZVlodUhYMUozYXlkUHE0NXQ3dDJ1Z2o1US9yODFGS1I0OUU2MzhjVklUMTlU?=
 =?utf-8?B?YmJJSUZvRW02R28rdWlTZDI5NHVsamdPSnBqditHTG1CVEZjdmdPZWwwTFFZ?=
 =?utf-8?B?YkM2VFljQWJVOW9KNkpaUHQ2eEhPc1kxdDRRRnZUNC9LTkJ0OWxGeWtMNEN3?=
 =?utf-8?B?N3hwcmR0OCtCZWhOemZVTkh1b040cmJzajVtU2ZhN3UvcmlubVI5TzIxdTFx?=
 =?utf-8?B?WDdhcTBOd3d6OHQ3bHNILzJmUEFPUDIrdlBjVTFLSDRLVTJ1NFJBL2JaMHZU?=
 =?utf-8?B?T1pVNkNNbitkTGdsaGRIL0ZVRDBuWEl3TTVTaEhiTXdKUkxNc0cyaXU3RnEx?=
 =?utf-8?B?OVUrV3g2V01sR1hBK0pYbGl2Y0FubDlZYXYvY05iaTNlamlsdG5TRlRIelg2?=
 =?utf-8?B?Z05BTDZuSEo5Ni9rSXJVcENrVVkweDR0MmFIalRYNTNKNGhPdWJ5QkR6eWxC?=
 =?utf-8?B?djhlZEJYUWthVTJQazBwVmtNbUJXNk5oUTVsdWZoZWxnMnA5WkU2UXc0ZER3?=
 =?utf-8?B?VXBjdjZQMHdiWnllRDVRanQ1b3ppbjFmNTNta01EUHQ3TEZjK1NuVnBkd1lV?=
 =?utf-8?B?bTVyS0NDOUJLY1JTYkpubXZrcURlSklrbW9rQXM4WU8xK2RlSXpmVDMzaVJK?=
 =?utf-8?B?Y2FxRXBZNVJyTlJGMnVWbGdPSWpTSjJIUmZpcTRQTUd2bnUrNGgwbzl4ZWpn?=
 =?utf-8?B?eU5BSHFNelV6SDM3N09GeFplMjNBYklqVExXZnRsMW9sdFdWNkQvdSt2VXdX?=
 =?utf-8?B?bjJNKzFldUpVS2ZleVZwSnJXbm5mTWxJN2huM2YwMTJ6OHRuSm1VeE9xdndn?=
 =?utf-8?B?MCtROXN5Rnlhb0RIT3BaOVBlRmRwaitwSW83TlpFZitkR1hiM2txOCtUYnJB?=
 =?utf-8?B?N0J1RzJIajF0NWdMbkkrS0hqZ3JNbWp3N0Q0SDdNN0ltZWp6QjgzQnZVbko4?=
 =?utf-8?B?OXlBbHppRlJnM04ya3ViSjhnQXlEMDF5N0M4OW1icEprK2Q0ZFEya0xaS05Y?=
 =?utf-8?B?Mm1XUVN2Zk5Mb09NdEpnSHowYy9Td0tQWVJNK2hkSEhrc3F0ditGT3kxbE4x?=
 =?utf-8?B?cnVCZWY3N2xXdGJIa3FHZ3V0ZUFQR0RSc3pQd2hLeE4wV1NJTElQVUZYdkRF?=
 =?utf-8?B?clE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <46D4325BCF76344D9F90B1143FA5116D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97e60683-7bf8-4b4f-94fd-08dd2b95e62d
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2025 01:28:16.7805
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CaxwIVVqt8py1DYzvKx+ecNexw1lOX2gpMB3iRJqfPvoxydWPfgfmuuowuvmKDQZ5D6tnegW9Vw2q53Y9iwDAFA7CtkmxoOdhpFBiCohwvg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5242
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTAxLTAxIGF0IDAyOjQ5IC0wNTAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBGcm9tOiBJc2FrdSBZYW1haGF0YSA8aXNha3UueWFtYWhhdGFAaW50ZWwuY29tPg0KPiANCj4g
VERYIG1vZHVsZSBkZWZpbmVzIGEgVExCIHRyYWNraW5nIHByb3RvY29sIHRvIG1ha2Ugc3VyZSB0
aGF0IG5vIGxvZ2ljYWwNCj4gcHJvY2Vzc29yIGhvbGRzIGFueSBzdGFsZSBTZWN1cmUgRVBUIChT
LUVQVCBvciBTRVBUKSBUTEIgdHJhbnNsYXRpb25zIGZvciBhDQo+IGdpdmVuIFREIHByaXZhdGUg
R1BBIHJhbmdlLiBBZnRlciBhIHN1Y2Nlc3NmdWwgVERILk1FTS5SQU5HRS5CTE9DSywNCj4gVERI
Lk1FTS5UUkFDSywgYW5kIGtpY2tpbmcgb2ZmIGFsbCB2Q1BVcywgVERYIG1vZHVsZSBlbnN1cmVz
IHRoYXQgdGhlDQo+IHN1YnNlcXVlbnQgVERILlZQLkVOVEVSIG9uIGVhY2ggdkNQVSB3aWxsIGZs
dXNoIGFsbCBzdGFsZSBUTEIgZW50cmllcyBmb3INCj4gdGhlIHNwZWNpZmllZCBHUEEgcmFuZ2Vz
IGluIFRESC5NRU0uUkFOR0UuQkxPQ0suIFdyYXAgdGhlDQo+IFRESC5NRU0uUkFOR0UuQkxPQ0sg
d2l0aCB0ZGhfbWVtX3JhbmdlX2Jsb2NrKCkgYW5kIFRESC5NRU0uVFJBQ0sgd2l0aA0KPiB0ZGhf
bWVtX3RyYWNrKCkgdG8gZW5hYmxlIHRoZSBrZXJuZWwgdG8gYXNzaXN0IHRoZSBURFggbW9kdWxl
IGluIFRMQg0KPiB0cmFja2luZyBtYW5hZ2VtZW50Lg0KPiANCj4gVGhlIGNhbGxlciBvZiB0ZGhf
bWVtX3JhbmdlX2Jsb2NrKCkgbmVlZHMgdG8gc3BlY2lmeSAiR1BBIiBhbmQgImxldmVsIiB0bw0K
PiByZXF1ZXN0IHRoZSBURFggbW9kdWxlIHRvIGJsb2NrIHRoZSBzdWJzZXF1ZW50IGNyZWF0aW9u
IG9mIFRMQiB0cmFuc2xhdGlvbg0KPiBmb3IgYSBHUEEgcmFuZ2UuIFRoaXMgR1BBIHJhbmdlIGNh
biBjb3JyZXNwb25kIHRvIGEgU0VQVCBwYWdlIG9yIGEgVEQNCj4gcHJpdmF0ZSBwYWdlIGF0IGFu
eSBsZXZlbC4NCj4gDQo+IENvbnRlbnRpb25zIGFuZCBlcnJvcnMgYXJlIHBvc3NpYmxlIHdpdGgg
dGhlIFNFQU1DQUxMIFRESC5NRU0uUkFOR0UuQkxPQ0suDQo+IFRoZXJlZm9yZSwgdGhlIGNhbGxl
ciBvZiB0ZGhfbWVtX3JhbmdlX2Jsb2NrKCkgbmVlZHMgdG8gY2hlY2sgdGhlIGZ1bmN0aW9uDQo+
IHJldHVybiB2YWx1ZSBhbmQgcmV0cmlldmUgZXh0ZW5kZWQgZXJyb3IgaW5mbyBmcm9tIHRoZSBm
dW5jdGlvbiBvdXRwdXQNCj4gcGFyYW1zLg0KPiANCj4gVXBvbiBUREguTUVNLlJBTkdFLkJMT0NL
IHN1Y2Nlc3MsIG5vIG5ldyBUTEIgZW50cmllcyB3aWxsIGJlIGNyZWF0ZWQgZm9yDQo+IHRoZSBz
cGVjaWZpZWQgcHJpdmF0ZSBHUEEgcmFuZ2UsIHRob3VnaCB0aGUgZXhpc3RpbmcgVExCIHRyYW5z
bGF0aW9ucyBtYXkNCj4gc3RpbGwgcGVyc2lzdC4NCj4gDQo+IENhbGwgdGRoX21lbV90cmFjaygp
IGFmdGVyIHRkaF9tZW1fcmFuZ2VfYmxvY2soKS4gTm8gZXh0cmEgaW5mbyBpcyByZXF1aXJlZA0K
PiBleGNlcHQgdGhlIFREUiBIUEEgdG8gZGVub3RlIHRoZSBURC4gVERILk1FTS5UUkFDSyB3aWxs
IGFkdmFuY2UgdGhlIFREJ3MNCj4gZXBvY2ggY291bnRlciB0byBlbnN1cmUgVERYIG1vZHVsZSB3
aWxsIGZsdXNoIFRMQnMgaW4gYWxsIHZDUFVzIG9uY2UgdGhlDQo+IHZDUFVzIHJlLWVudGVyIHRo
ZSBURC4gVERILk1FTS5UUkFDSyB3aWxsIGZhaWwgdG8gYWR2YW5jZSBURCdzIGVwb2NoDQo+IGNv
dW50ZXIgaWYgdGhlcmUgYXJlIHZDUFVzIHN0aWxsIHJ1bm5pbmcgaW4gbm9uLXJvb3QgbW9kZSBh
dCB0aGUgcHJldmlvdXMNCj4gVEQgZXBvY2ggY291bnRlci4gVGhlcmVmb3JlLCBzZW5kIElQSXMg
dG8ga2ljayBvZmYgdkNQVXMgYWZ0ZXINCj4gdGRoX21lbV90cmFjaygpIHRvIGF2b2lkIHRoZSBm
YWlsdXJlIGJ5IGZvcmNpbmcgYWxsIHZDUFVzIHRvIHJlLWVudGVyIHRoZQ0KPiBURC4NCg0KVGhp
cyBwYXRjaCBkb2Vzbid0IGltcGxlbWVudCB0aGUgZnVuY3Rpb25hbGl0eSBkZXNjcmliZWQgaW4g
dGhlIGFib3ZlIHBhcmFncmFwaCwNCnRoZSBjYWxsZXIgZG9lcyBpdC4gSXQgYWxzbyBkb2Vzbid0
IGV4cGxhaW4gd2h5IGl0IGxlYXZlcyBpdCBhbGwgZm9yIHRoZSBjYWxsZXJzDQppbnN0ZWFkIG9m
IGltcGxlbWVudGluZyB0aGUgZGVzY3JpYmVkIGZsb3cgb24gdGhlIHg4NiBzaWRlLiBJIHRoaW5r
IERhdmUgd2lsbA0Kd2FudCB0byB1bmRlcnN0YW5kIHRoaXMsIHNvIGhvdyBhYm91dCB0aGlzIGlu
c3RlYWQ6DQoNClNvIHRvIGVuc3VyZSBwcml2YXRlIEdQQSB0cmFuc2xhdGlvbnMgYXJlIGZsdXNo
ZWQsIGNhbGxlcnMgbXVzdCBmaXJzdCBjYWxsDQp0ZGhfbWVtX3JhbmdlX2Jsb2NrKCksIHRoZW4g
dGRoX21lbV90cmFjaygpLCBhbmQgbGFzdGx5IHNlbmQgSVBJcyB0byBraWNrIGFsbA0KdGhlIHZD
UFVzIGFuZCB0cmlnZ2VyIGEgVExCIGZsdXNoIGZvcmNpbmcgdGhlbSB0byByZS1lbnRlci4gRG9u
J3QgZXhwb3J0IGENCnNpbmdsZSBvcGVyYXRpb24gYW5kIGluc3RlYWQgZXhwb3J0IGZ1bmN0aW9u
cyB0aGF0IGp1c3TCoGV4cG9zZSB0aGUgYmxvY2sgYW5kDQp0cmFjayBvcGVyYXRpb25zLiBEbyB0
aGlzIGZvciBhIGNvdXBsZSByZWFzb25zOg0KMS4gVGhlIHZDUFUga2ljayBzaG91bGQgdXNlIEtW
TSdzIGZ1bmN0aW9uYWxpdHkgZm9yIGRvaW5nIHRoaXMsIHdoaWNoIGNhbiBiZXR0ZXINCnRhcmdl
dCBzZW5kaW5nIElQSXMgdG8gb25seSB0aGUgbWluaW11bSByZXF1aXJlZCBwQ1BVcy4NCjIuIHRk
aF9tZW1fdHJhY2soKSBkb2Vzbid0IG5lZWQgdG8gYmUgZXhlY3V0ZWQgaWYgYSB2Q1BVIGhhcyBu
b3QgZW50ZXJlZCBhIFRELA0Kd2hpY2ggaXMgaW5mb3JtYXRpb24gb25seSBLVk0ga25vd3MuDQoz
LiBMZWF2aW5nIHRoZSBvcGVyYXRpb25zIHNlcGFyYXRlIHdpbGwgYWxsb3cgZm9yIGJhdGNoaW5n
IG1hbnkNCnRkaF9tZW1fcmFuZ2VfYmxvY2soKSBjYWxscyBiZWZvcmUgYSB0ZGhfbWVtX3RyYWNr
KCkuIFdoaWxlIHRoaXMgYmF0Y2hpbmcgd2lsbA0Kbm90IGJlIGRvbmUgaW5pdGlhbGx5IGJ5IEtW
TSwgaXQgZGVtb25zdHJhdGVzIHRoYXQga2VlcGluZyBtZW0gYmxvY2sgYW5kIHRyYWNrDQphcyBz
ZXBhcmF0ZSBvcGVyYXRpb25zIGlzIGEgZ2VuZXJhbGx5IGdvb2QgZGVzaWduLg0KDQoNClRoZSBh
Ym92ZSBhbHNvIGxvc2VzIHRoZSBiaXQgYWJvdXQgZW5zdXJpbmcgYWxsIHZDUFVzIGFyZSBraWNr
ZWQgdG8gYXZvaWQgZXBvY2gNCnJlbGF0ZWQgZXJyb3JzLiBJIGRpZG4ndCB0aGluayBpdCB3YXMg
bmVlZGVkIHRvIGp1c3RpZnkgdGhlIHdyYXBwZXJzLg0KDQo+IA0KPiBDb250ZW50aW9ucyBhcmUg
YWxzbyBwb3NzaWJsZSBpbiBUREguTUVNLlRSQUNLLiBGb3IgZXhhbXBsZSwgVERILk1FTS5UUkFD
Sw0KPiBtYXkgY29udGVuZCB3aXRoIFRESC5WUC5FTlRFUiB3aGVuIGFkdmFuY2luZyB0aGUgVEQg
ZXBvY2ggY291bnRlci4NCj4gdGRoX21lbV90cmFjaygpIGRvZXMgbm90IHByb3ZpZGUgdGhlIHJl
dHJpZXMgZm9yIHRoZSBjYWxsZXIuIENhbGxlcnMgY2FuDQo+IGNob29zZSB0byBhdm9pZCBjb250
ZW50aW9ucyBvciByZXRyeSBvbiB0aGVpciBvd24uDQo+IA0KPiBbS2FpOiBTd2l0Y2hlZCBmcm9t
IGdlbmVyaWMgc2VhbWNhbGwgZXhwb3J0XQ0KPiBbWWFuOiBSZS13cm90ZSB0aGUgY2hhbmdlbG9n
XQ0KPiBDby1kZXZlbG9wZWQtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW4uai5jaHJpc3Rv
cGhlcnNvbkBpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24g
PHNlYW4uai5jaHJpc3RvcGhlcnNvbkBpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IElzYWt1
IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEth
aSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogUmljayBFZGdl
Y29tYmUgPHJpY2sucC5lZGdlY29tYmVAaW50ZWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBZYW4g
WmhhbyA8eWFuLnkuemhhb0BpbnRlbC5jb20+DQo+IE1lc3NhZ2UtSUQ6IDwyMDI0MTExMjA3MzY0
OC4yMjE0My0xLXlhbi55LnpoYW9AaW50ZWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBQYW9sbyBC
b256aW5pIDxwYm9uemluaUByZWRoYXQuY29tPg0KPiAtLS0NCj4gIGFyY2gveDg2L2luY2x1ZGUv
YXNtL3RkeC5oICB8ICAyICsrDQo+ICBhcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMgfCAyNyAr
KysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gIGFyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHgu
aCB8ICAyICsrDQo+ICAzIGZpbGVzIGNoYW5nZWQsIDMxIGluc2VydGlvbnMoKykNCj4gDQo+IGRp
ZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS90ZHguaCBiL2FyY2gveDg2L2luY2x1ZGUv
YXNtL3RkeC5oDQo+IGluZGV4IDMyZjM5ODFkNTZjNS4uZjBiN2I3YjdkNTA2IDEwMDY0NA0KPiAt
LS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS90ZHguaA0KPiArKysgYi9hcmNoL3g4Ni9pbmNsdWRl
L2FzbS90ZHguaA0KPiBAQCAtMTQyLDYgKzE0Miw3IEBAIHU2NCB0ZGhfbWVtX3BhZ2VfYWRkKHN0
cnVjdCB0ZHhfdGQgKnRkLCB1NjQgZ3BhLCB1NjQgaHBhLCB1NjQgc291cmNlLCB1NjQgKnJjeCwN
Cj4gIHU2NCB0ZGhfbWVtX3NlcHRfYWRkKHN0cnVjdCB0ZHhfdGQgKnRkLCB1NjQgZ3BhLCB1NjQg
bGV2ZWwsIHU2NCBocGEsIHU2NCAqcmN4LCB1NjQgKnJkeCk7DQo+ICB1NjQgdGRoX3ZwX2FkZGN4
KHN0cnVjdCB0ZHhfdnAgKnZwLCBzdHJ1Y3QgcGFnZSAqdGRjeF9wYWdlKTsNCj4gIHU2NCB0ZGhf
bWVtX3BhZ2VfYXVnKHN0cnVjdCB0ZHhfdGQgKnRkLCB1NjQgZ3BhLCB1NjQgaHBhLCB1NjQgKnJj
eCwgdTY0ICpyZHgpOw0KPiArdTY0IHRkaF9tZW1fcmFuZ2VfYmxvY2soc3RydWN0IHRkeF90ZCAq
dGQsIHU2NCBncGEsIHU2NCBsZXZlbCwgdTY0ICpyY3gsIHU2NCAqcmR4KTsNCj4gIHU2NCB0ZGhf
bW5nX2tleV9jb25maWcoc3RydWN0IHRkeF90ZCAqdGQpOw0KPiAgdTY0IHRkaF9tbmdfY3JlYXRl
KHN0cnVjdCB0ZHhfdGQgKnRkLCB1NjQgaGtpZCk7DQo+ICB1NjQgdGRoX3ZwX2NyZWF0ZShzdHJ1
Y3QgdGR4X3RkICp0ZCwgc3RydWN0IHRkeF92cCAqdnApOw0KPiBAQCAtMTU1LDYgKzE1Niw3IEBA
IHU2NCB0ZGhfdnBfcmQoc3RydWN0IHRkeF92cCAqdnAsIHU2NCBmaWVsZCwgdTY0ICpkYXRhKTsN
Cj4gIHU2NCB0ZGhfdnBfd3Ioc3RydWN0IHRkeF92cCAqdnAsIHU2NCBmaWVsZCwgdTY0IGRhdGEs
IHU2NCBtYXNrKTsNCj4gIHU2NCB0ZGhfdnBfaW5pdF9hcGljaWQoc3RydWN0IHRkeF92cCAqdnAs
IHU2NCBpbml0aWFsX3JjeCwgdTMyIHgyYXBpY2lkKTsNCj4gIHU2NCB0ZGhfcGh5bWVtX3BhZ2Vf
cmVjbGFpbShzdHJ1Y3QgcGFnZSAqcGFnZSwgdTY0ICp0ZHhfcHQsIHU2NCAqdGR4X293bmVyLCB1
NjQgKnRkeF9zaXplKTsNCj4gK3U2NCB0ZGhfbWVtX3RyYWNrKHN0cnVjdCB0ZHhfdGQgKnRkcik7
DQo+ICB1NjQgdGRoX3BoeW1lbV9jYWNoZV93Yihib29sIHJlc3VtZSk7DQo+ICB1NjQgdGRoX3Bo
eW1lbV9wYWdlX3diaW52ZF90ZHIoc3RydWN0IHRkeF90ZCAqdGQpOw0KPiAgI2Vsc2UNCj4gZGlm
ZiAtLWdpdCBhL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYyBiL2FyY2gveDg2L3ZpcnQvdm14
L3RkeC90ZHguYw0KPiBpbmRleCBmMzkxOTdkNGVhZmMuLmM3ZTZmMzBkMGExNCAxMDA2NDQNCj4g
LS0tIGEvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jDQo+ICsrKyBiL2FyY2gveDg2L3ZpcnQv
dm14L3RkeC90ZHguYw0KPiBAQCAtMTU2MSw2ICsxNTYxLDIzIEBAIHU2NCB0ZGhfbWVtX3BhZ2Vf
YXVnKHN0cnVjdCB0ZHhfdGQgKnRkLCB1NjQgZ3BhLCB1NjQgaHBhLCB1NjQgKnJjeCwgdTY0ICpy
ZHgpDQo+ICB9DQo+ICBFWFBPUlRfU1lNQk9MX0dQTCh0ZGhfbWVtX3BhZ2VfYXVnKTsNCj4gIA0K
PiArdTY0IHRkaF9tZW1fcmFuZ2VfYmxvY2soc3RydWN0IHRkeF90ZCAqdGQsIHU2NCBncGEsIHU2
NCBsZXZlbCwgdTY0ICpyY3gsIHU2NCAqcmR4KQ0KPiArew0KPiArCXN0cnVjdCB0ZHhfbW9kdWxl
X2FyZ3MgYXJncyA9IHsNCj4gKwkJLnJjeCA9IGdwYSB8IGxldmVsLA0KPiArCQkucmR4ID0gdGR4
X3Rkcl9wYSh0ZCksDQo+ICsJfTsNCj4gKwl1NjQgcmV0Ow0KPiArDQo+ICsJcmV0ID0gc2VhbWNh
bGxfcmV0KFRESF9NRU1fUkFOR0VfQkxPQ0ssICZhcmdzKTsNCj4gKw0KPiArCSpyY3ggPSBhcmdz
LnJjeDsNCj4gKwkqcmR4ID0gYXJncy5yZHg7DQoNClNpbWlsYXIgdG8gdGhlIG90aGVycywgdGhl
c2UgY291bGQgYmUgY2FsbGVkIGV4dGVuZGVkX2VycjEsIGV4dGVuZGVkX2VycjIuDQoNCj4gKw0K
PiArCXJldHVybiByZXQ7DQo+ICt9DQo+ICtFWFBPUlRfU1lNQk9MX0dQTCh0ZGhfbWVtX3Jhbmdl
X2Jsb2NrKTsNCj4gKw0KPiAgdTY0IHRkaF9tbmdfa2V5X2NvbmZpZyhzdHJ1Y3QgdGR4X3RkICp0
ZCkNCj4gIHsNCj4gIAlzdHJ1Y3QgdGR4X21vZHVsZV9hcmdzIGFyZ3MgPSB7DQo+IEBAIC0xNzM0
LDYgKzE3NTEsMTYgQEAgdTY0IHRkaF9waHltZW1fcGFnZV9yZWNsYWltKHN0cnVjdCBwYWdlICpw
YWdlLCB1NjQgKnRkeF9wdCwgdTY0ICp0ZHhfb3duZXIsIHU2NA0KPiAgfQ0KPiAgRVhQT1JUX1NZ
TUJPTF9HUEwodGRoX3BoeW1lbV9wYWdlX3JlY2xhaW0pOw0KPiAgDQo+ICt1NjQgdGRoX21lbV90
cmFjayhzdHJ1Y3QgdGR4X3RkICp0ZCkNCj4gK3sNCj4gKwlzdHJ1Y3QgdGR4X21vZHVsZV9hcmdz
IGFyZ3MgPSB7DQo+ICsJCS5yY3ggPSB0ZHhfdGRyX3BhKHRkKSwNCj4gKwl9Ow0KPiArDQo+ICsJ
cmV0dXJuIHNlYW1jYWxsKFRESF9NRU1fVFJBQ0ssICZhcmdzKTsNCj4gK30NCj4gK0VYUE9SVF9T
WU1CT0xfR1BMKHRkaF9tZW1fdHJhY2spOw0KPiArDQo+ICB1NjQgdGRoX3BoeW1lbV9jYWNoZV93
Yihib29sIHJlc3VtZSkNCj4gIHsNCj4gIAlzdHJ1Y3QgdGR4X21vZHVsZV9hcmdzIGFyZ3MgPSB7
DQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmggYi9hcmNoL3g4Ni92
aXJ0L3ZteC90ZHgvdGR4LmgNCj4gaW5kZXggODBlNmVmMDA2MDg1Li40YjBhZDUzNmFmZDkgMTAw
NjQ0DQo+IC0tLSBhL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguaA0KPiArKysgYi9hcmNoL3g4
Ni92aXJ0L3ZteC90ZHgvdGR4LmgNCj4gQEAgLTIwLDYgKzIwLDcgQEANCj4gICNkZWZpbmUgVERI
X01FTV9TRVBUX0FERAkJMw0KPiAgI2RlZmluZSBUREhfVlBfQUREQ1gJCQk0DQo+ICAjZGVmaW5l
IFRESF9NRU1fUEFHRV9BVUcJCTYNCj4gKyNkZWZpbmUgVERIX01FTV9SQU5HRV9CTE9DSwkJNw0K
PiAgI2RlZmluZSBUREhfTU5HX0tFWV9DT05GSUcJCTgNCj4gICNkZWZpbmUgVERIX01OR19DUkVB
VEUJCQk5DQo+ICAjZGVmaW5lIFRESF9NTkdfUkQJCQkxMQ0KPiBAQCAtMzUsNiArMzYsNyBAQA0K
PiAgI2RlZmluZSBUREhfU1lTX0tFWV9DT05GSUcJCTMxDQo+ICAjZGVmaW5lIFRESF9TWVNfSU5J
VAkJCTMzDQo+ICAjZGVmaW5lIFRESF9TWVNfUkQJCQkzNA0KPiArI2RlZmluZSBUREhfTUVNX1RS
QUNLCQkJMzgNCj4gICNkZWZpbmUgVERIX1NZU19MUF9JTklUCQkJMzUNCj4gICNkZWZpbmUgVERI
X1NZU19URE1SX0lOSVQJCTM2DQo+ICAjZGVmaW5lIFRESF9QSFlNRU1fQ0FDSEVfV0IJCTQwDQoN
Cg==

