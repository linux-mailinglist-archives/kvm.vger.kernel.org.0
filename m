Return-Path: <kvm+bounces-56622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B97CFB40C5B
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 19:45:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 871495649B6
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 17:45:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C67433451A6;
	Tue,  2 Sep 2025 17:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WGOvNx+g"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E4A310654;
	Tue,  2 Sep 2025 17:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756835135; cv=fail; b=NPQKf2kWoBjJGtuuqk4lvUKEuX0YUpZRIaUUklGGdMp62ty1XHSFUO4q3Ldva4lNKLScXqT0FqzrKvz8+9laAv4Elz9dS1Qg2GIKg7rmXjSpfKcgcXze7cgHFNsk1W4A90v2P8ZIrgMr7bJvwr/ytkMCjCbWi+wd2Pl/v+uZ7I8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756835135; c=relaxed/simple;
	bh=46G6rBjnYSZVfIYIt4q3yoi1YyxvbZrhuuoUrGg/wdk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Qf9O70hSLW3BgGYotHg523rySpBXyq3WtJWjX7Zld2g/srjqXlT/VIGVsZxSiTsZwuo+9xI+aGNnS0KBi7/quyz5XgvRnmbf4RnBCyV3Po/CveYny1WWRmkqFNbvs28kJtmuz6fukqMSubmq2ucWAicA7y8/0UmX5eeEEvbLNqc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WGOvNx+g; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756835134; x=1788371134;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=46G6rBjnYSZVfIYIt4q3yoi1YyxvbZrhuuoUrGg/wdk=;
  b=WGOvNx+gqYudTH+tW2bANKAeM4naHvd20BSb+Zrlcnwu2Ylu4ZI4TP3y
   z5nkNjlElip3Ga+PQ4Y+FN5Zp1inhSs5HQTTSF5/FHXjNwaOogXlG7nLn
   0HSGX59xebQXGwxuwZgQuAhjDTFhGeG1jPXA7rH57oTOzQ6P831S5m8GG
   M2I9mkuSFrQKQ0mObYjZi/5EhZEyBHZXioQQ51uGbELL/EWq+zQzOdXF8
   84Fn2D6zDp/HAcRWu1lgUo+b+/LkkxMdAYk8WveuDqnekuviCXQ3fbKvk
   5xSikOlvYrpOG1PJqZ01QYY8jn1TDPHeDWgc9hY6g9IgtNRBWmN48I9ZD
   g==;
X-CSE-ConnectionGUID: Vf1Bq/YRReixDb3qMP0MAA==
X-CSE-MsgGUID: v4B9GJfaS4qrPB3Rkj+b/Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="58155941"
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="58155941"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 10:45:34 -0700
X-CSE-ConnectionGUID: Gjqn4GcYS0qCa3Arfoi5wg==
X-CSE-MsgGUID: +u+7ffmbTemEtT4Aqi27CQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="171718511"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 10:45:33 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 2 Sep 2025 10:45:32 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 2 Sep 2025 10:45:32 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.76)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 2 Sep 2025 10:45:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hu1mtsYhyXOdiSyeX+dJ1BTGf3U6poFatcR9I63sCHlmKEFORjCpTxExi8ZlK+qOJR7H2A/L0cohBBCMwgMBm+VHQTGVnsdTBgEj8szDSZ1nMF3TiiFnYwaMcS20idNrzbcMGaYry5XSULen38Hayu5ZbkIvPiPxbxGnd0JCgyc/mWU/4emcWKdMuY7/DfOQ2Xre56oX/hBgGYrlEdt+pRXGSG1gZrFGGKcoLYVrtr0Z3V60ANqmJdBqSrkp1Ze1kTg/yF+oVX6+qMMWV+LO1wJ9A19ft6oG6jmmaEqILvSttwbQqdxbV/cvdqSJv3FIgBEaUsbigNLoNQMQ1Fed/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=46G6rBjnYSZVfIYIt4q3yoi1YyxvbZrhuuoUrGg/wdk=;
 b=d+1eXc0R/2pRoLR9Qo80T7uWvvIQZRr6mmwY/I/0nd4zsmIJVEEDzwozzj9PHCCkDjziJM/XTq35dVF/MMBYpsv1fZgztvbEol1Uz5AsD6L+hoXGIq7a47Z5zyaEdf3nMExUUKI7FvcHkfQckz8i4a1wD1+AJP9CuLggGN1hCqiTXv8ah4Uu2S5GiAGoKDc/oetevner7CyK7A1UFKwlCbG8oyzDrdOrbvVymh4qD3Tac3HNO3/8aed8xxQFfR9Lg7WYn+T6kzaDfablYhXkNCDo6/rfQKOiYPxqqFXm5YSBRgTgbtGEODmJ3i40bvBScAJyZQeefFky3T8vHUo+Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BL1PR11MB6001.namprd11.prod.outlook.com (2603:10b6:208:385::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Tue, 2 Sep
 2025 17:45:27 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9094.015; Tue, 2 Sep 2025
 17:45:27 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "tabba@google.com" <tabba@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "ackerleytng@google.com" <ackerleytng@google.com>,
	"kas@kernel.org" <kas@kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Annapurve,
 Vishal" <vannapurve@google.com>, "Miao, Jun" <jun.miao@intel.com>,
	"zhiquan1.li@intel.com" <zhiquan1.li@intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "pgonda@google.com" <pgonda@google.com>
Subject: Re: [RFC PATCH v2 02/23] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_page_demote()
Thread-Topic: [RFC PATCH v2 02/23] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_page_demote()
Thread-Index: AQHcB3+cjpXnNi+6okqfIQv/bzXmILR+LVYAgAADmoCAAhU2gIAAC1kAgAACPAA=
Date: Tue, 2 Sep 2025 17:45:27 +0000
Message-ID: <a35581c9e47d6b32b59021f27b18154fdc10c49e.camel@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
	 <20250807094149.4467-1-yan.y.zhao@intel.com>
	 <281ae89b-9fc3-4a9b-87f6-26d2a96cde49@linux.intel.com>
	 <aLVih+zi8gW5zrJY@yzhao56-desk.sh.intel.com>
	 <87fe45aae8d0812bd3aec956e407c3cc88234b34.camel@intel.com>
	 <aLcrVp6_9gNrp1Bn@google.com>
In-Reply-To: <aLcrVp6_9gNrp1Bn@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BL1PR11MB6001:EE_
x-ms-office365-filtering-correlation-id: 49deb48a-aa97-4939-9102-08ddea48809e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Q2NuRkc1TXR0Tk5nUjlGbVYrazkxUmZDVFRTeDhSUWU5V3l1TUpDTEFUdkVB?=
 =?utf-8?B?TTh2WEtOa2hVakYzMld5VTBkcmYyOXp6ZFFVSUdkMkd6SnVtZnlGbVJHdzU2?=
 =?utf-8?B?VHVsR1RKNzlaV0hBK1plWmk0bVFHTDBqWkc3bUFGTy93aWI2V0JBVDlaTlMx?=
 =?utf-8?B?UXM2bUNzNHZNMU9aZlRIZ2xvdGZsbHYvY1RHZFJzV1NlT1I3YVBQOUdwOE4v?=
 =?utf-8?B?c2tvWExtZUJQTTlxbFJpMUlMeG9zUjlZb05mS3hsRm10eTJ5bk0vdktRb0xF?=
 =?utf-8?B?VWtSeDRyNGQyV3lickM0bXZyVFZ2V2NHT2RVSXNMUDJrWEJZTGROUjZvUUo4?=
 =?utf-8?B?S3FIYXNXSnNacVRQOE9ibFlsN3ZiYzA1MHllZFNCbDg0akNlWTZTcXhpS1lp?=
 =?utf-8?B?RUltVCt6RXFrcHJ6Y2RUdmpEaWVyWmZ5N0orTm5sVlBJQ1ZSSVN3aUpiOHJu?=
 =?utf-8?B?RXFFRVY4bXl2S0RRcXBoWTJua1pVRktJU3VLaDFKM25uV3dXMUJzNEhRR2Jq?=
 =?utf-8?B?c3R1aHN5blRjRm4xZWljcXJyQ29ZcHA3c1dsb3EyZlVvUnVyakYrUHFORllk?=
 =?utf-8?B?dkRGQUdpSmZITXlXU2ZZZ0VkdGFQQ0R3TjNnNEduR0NiSFRWNFdZTzkzZGlY?=
 =?utf-8?B?VTQ1UGovdGo2WE1SN2k5elIvV2ZSeXZmU1dSMEhkaDNIcDk1RzNSSjUvOCs1?=
 =?utf-8?B?ZVFXSUZJREtVcDYxa2tIQ3lvUEl0L21NQVF5c0lUMmRUcEM2cWdxNWxCWGFk?=
 =?utf-8?B?Tm50Y2dEdldGaU9MdFJjRDROZGxYaHpqdWpTUXlmc2RzYWViZDBsUlR4bUJp?=
 =?utf-8?B?dWxzanNGZDZFNGtRS0RsMU5aRzFtV0dPOE9HTFpiMmp5UzIvVVJCK21xTVdI?=
 =?utf-8?B?Rk5ZMUZYUjBoRlZWaHJWVDlVMDRWY00xb1RoOStjUWRvVC9FVnJqdzZGZnlP?=
 =?utf-8?B?RGhTRzZKNk5DRUNHekd5QVhYNHQrQllHcFZaTkFVVWpCM2ZncU1PbkZCdk00?=
 =?utf-8?B?bE9BTXZGeXZ1MWFGeDlYMWIrd3N6ZG1wOWJxZ2ozM3VsazZWbFkwc3RVeUdh?=
 =?utf-8?B?SkJINkN6SlJEQ1Y5bE1ZeXUxZEt3VzRNazMxbHVLV2hRVlJ5SW4wenVYS2xy?=
 =?utf-8?B?dVRpNWYrTUIySmhZMlZJSUdHRjFwZXlGQ2kwK3hQdVVISE8rMFB2dE9YZmdC?=
 =?utf-8?B?UlBjVGlpeFVUeWhxNjcvVmppN2o4Q3NpWWhsMUJzVUhUdmZFN0JaVnY3Nk1y?=
 =?utf-8?B?ak51NGdHRUtLY08zZjlIUHFMZkRRekU0a1dwYzNzbXA1TlkvL0RUTUZZVWFD?=
 =?utf-8?B?SWpTNHQxRWIvUmIyQ1JBMmMyMUVUditNLzJXSnVURllXRnM4MU8zZ2ROaEts?=
 =?utf-8?B?cDFheHpMMGVFZmI3MUx6ZzZrMlgvUC9GeU95aDNQSmh0Y3NwM29pdm5NUExl?=
 =?utf-8?B?ckJkWWdJenBrdWdSRlpFell6MmIzcUx4WXlpaEs2U2s3MWdPQkhrb2FCMy92?=
 =?utf-8?B?R2tNRDZ4RXFqZFVETlo4MldIMzlSdGFhdUpYY08vVDl2R0pkRGljeDZKOGQ2?=
 =?utf-8?B?WVpCbmF6WnJqa2JTRjQ5ei9iT2dzS0FOUzhpbGdBdE1tK1VIUXRHc2V4NEhJ?=
 =?utf-8?B?OHNER2IvMHM0MmhzSXhlU0RDdW0rNGlJYTJmd2dRWUl1N2N4aTJPK3Rka1hu?=
 =?utf-8?B?cHNNS082WFlDNUxNam1ycHE0RU9SYmRHd1BJV004d0tZbXJEUDdBS1dmZ1Jm?=
 =?utf-8?B?NEoxVUxvc2I5ZGlZaXBTU3BKS2RQMWN3c3NkS2l3bUYzM1RKRW9IeFhZeW1Q?=
 =?utf-8?B?ZHhRdk5Ecm5hOTMxaW9qUStldlU1MGlYc1dMLzltTnYvMS91c1FIVjI4MFFj?=
 =?utf-8?B?ZFIxT3BkTjdKR3UrNjdGUHZobFE3UUtzYmFQVmExRTVZUW8vWEJRUGt3RE9Z?=
 =?utf-8?B?K3dmSWw1QllTSUJ4cEE5bGxxOENsdkNMUU1Uc0lKaU9nV1RJNmgydmgwZDM3?=
 =?utf-8?B?djArSHdXM2ZRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z24xUkhDdnRLQlRLL0d2SFdsTnhCYm5pVEdIbkloVlR6QklUT0wrMW40MlAv?=
 =?utf-8?B?SzR0NHZXSEQvZUdGbHlITHVnTDJkd1U3OFZiaHNUbFFlaFNMRnUrVmNyTWJn?=
 =?utf-8?B?WFpkMXNwendSZHdXeERRSXUvemR5ME1kaVBUekpTbDFMcS96OW5DTXMyaTVD?=
 =?utf-8?B?QVN4SVBmUnBqUlNkZW5nbWZuZG1YVHcrQjkzNFdFZDhHcHZheW9ERmNHSmJp?=
 =?utf-8?B?M2k4TURqZXFnSjc0aCtMNExnbHNtKzZzWWNOUGJKODNPeldCRlhmNWdHNGl4?=
 =?utf-8?B?bXJUdFYvSzhNQTBpaFo3SjcvcmFVeDQ2dldCOEI4b1owRnNCN1hYcEdadlRp?=
 =?utf-8?B?OW1nUTJxcXh6akJpaFc0MlNlMDBQdm5YM3RCSGpUbkVjd2wra2tPY3l1b3pq?=
 =?utf-8?B?UDJNejMrdjFxRmFCMVI0OU5yZ0tWa0NjNGVDYml6ZmJLb09rL3dVSlZmME41?=
 =?utf-8?B?N3dFckxQSThRTWl4QXJ3UFhnemcxaWFkajd5NVBjK2hFK0VuRlpOSS9hUXd1?=
 =?utf-8?B?UUc2eUZuYkJJdTEyM2tTMWlpTCt3UUpvMTJCNUd5TUt5WllKUU9Ya3AwWVg4?=
 =?utf-8?B?QkR1cDJhOVV4UFJrNTZCVDlOeGFKazllUzJOV3pzUFlyUzVGYTdGU3VpcEYw?=
 =?utf-8?B?NXh2WUdBNXF1UjJaT3VuWUZLQ2R2OVBqcXgyenZMQWtkOEQ5QjR3Y2ZESmgy?=
 =?utf-8?B?cUhxalJmNXN5S2FPSlVLLytXSzJ6Njk2QkZETkZ5bVkzYU5pZ0pJcFhTVS9n?=
 =?utf-8?B?eTYzbTBOaElrU05HSERRQWt2dFFpQThXL2pKSlg1UkIyNzRFRWxJTkFVRnVD?=
 =?utf-8?B?ZVIxMkxGYmhiMnE1RE4vc0NEdE9NUmlyY0UxWW9GWUt4VjU1Wk9GL0Nsc1dB?=
 =?utf-8?B?cU1pRVI0L0k0blhGVENLTFdtOE9nU3FWYUI1Q2duK3RlTmtTdkJRdFAvbkth?=
 =?utf-8?B?OS9NeTJSTWZiWXNOTWk2WFBWVWZYdmlqaXRKNktNTmVnNVdyYjdVcGROeTYw?=
 =?utf-8?B?NEdYU2I5UEdzRmJWelJndGlVRGxZTDROSWM5NEpvR251b1AxWThCQTZxeWZ4?=
 =?utf-8?B?bUJkMWhFbTdGTkN2eHdnYVUwUE1LYlVoSkh1WVh3RVMyWVluaWRkaGtNMk9S?=
 =?utf-8?B?Q2RJOU03ak5wNE55RXZjRS9JeVdGTUxveFBRMGE0dldXUG5tSllhOEpmblVp?=
 =?utf-8?B?UFdrbnJSaCtnUGRzR1oxTWVUWE14N2lNZitUeUhjMkh4SlcwZklURmhQM1Vj?=
 =?utf-8?B?V1FBZ0QveWNTM1JWVlUvU1ZuOGRJSCtRUkZCekxKdW1XQVdLRU5IVzczZGNC?=
 =?utf-8?B?R1hIZUY4UjVpY3podTU5TTdTMDhoMExUcGZNa1BpM0dvUmpPcVZkV1EzTldK?=
 =?utf-8?B?L0xCdHJGSUhtT1FCRmpSdzhkRXZmZkNaYnBDbi9sWHhneWRGd2pVYzRyMDNz?=
 =?utf-8?B?clM4Ym9EQURaTHYyY0J3aisyTDlNdUF3WW5DakY1TjFNVUx1Y2F0eEZFeFBT?=
 =?utf-8?B?bUV0MGkzTWlULys2QXREOE1PclZVR28vaXhOeE5RUlpqZUNWVndwNmtacmlr?=
 =?utf-8?B?WlIwQ25PREErelBRTHpnTzR2SERMUHBUTWQxQUZlMDI2UWtwbTFrN2hVVnd6?=
 =?utf-8?B?Mnp2OW84ZHlJWi9sdURrYURiS0I2MURvOVhRc0xzMWYyRUtITVV1MnZ6Rjgr?=
 =?utf-8?B?NjBZd0diVDYwdEkvSEtWYUtoLzFqemMrSFFzS2FQMGZyUG5xbFhzdkUreUpn?=
 =?utf-8?B?Zk9RMjlGamdTek14Z1NMK3BjZ0dZbHBuNFVHdzZqcUZvWDV5WmRDZnlPOEls?=
 =?utf-8?B?OGVHaHV6TldNbElHTkVDem1lWXVNc3NuR1BSeldVSUxOMTUvSjJhZ3Z0M3Js?=
 =?utf-8?B?eGJvUm9rbFFSWHc5VzkzV2h3MzNNTURBWDFMUkRlcFFCb3c5cllqdXFQaXpP?=
 =?utf-8?B?dlBRcWQ0aC9kb093Z1FzVGJBV2ltc0wwWDZGaFVpQ1pXbFJjZUFhaHJlYUU5?=
 =?utf-8?B?Y0ovczc3SnNPb1IvdUpBcENWQzc0VXRhNTZyTHRucnFJdHRSRmR4YndNdjJU?=
 =?utf-8?B?RHp1Y2hxSFNIRzAwVm1kTmh6QUpGWU9zWUtaVFhxTVo5RnpBc3ZhbXF5Rk5x?=
 =?utf-8?B?WGIzL1JWQU5vUUdjQnUyWnZDNGd4WDljR0tuc3hHeTk4TVhaUHRLckRmMWxP?=
 =?utf-8?B?R0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BB96B0B734AEAE4993B77400005096A3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49deb48a-aa97-4939-9102-08ddea48809e
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2025 17:45:27.2500
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aXJs5pH5AZeUVSbIvDGRvRrl/lohVD08xTo+74Z30/R+0ye9HuCsi8uTKK48wuu2s3bl+Jh6FVomfhdxfNoHTnc72jC27NEGzLHW1zQebs4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6001
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA5LTAyIGF0IDEwOjM3IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IElmIHRoZXJlIGlzIGEgZmxhZyB3ZSBjb3VsZCBjaGVjayBpdCwgYnV0IHdlIGRp
ZCBub3QgYXNrIGZvciBvbmUgaGVyZS4gV2UNCj4gPiBhbHJlYWR5IGhhdmUgYSBzaXR1YXRpb24g
d2hlcmUgdGhlcmUgYXJlIGJ1ZyBmaXhlcyB0aGF0IEtWTSBkZXBlbmRzIG9uLCB3aXRoDQo+ID4g
bm8gd2F5IHRvIGNoZWNrLg0KPiA+IA0KPiA+IEkgZ3Vlc3MgdGhlIGRpZmZlcmVuY2UgaGVyZSBp
cyB0aGF0IGlmIHRoZSBiZWhhdmlvciBpcyBtaXNzaW5nLCBLVk0gaGFzIGFuDQo+ID4gb3B0aW9u
IHRvIGNvbnRpbnVlIHdpdGgganVzdCBzbWFsbCBwYWdlcy4gQnV0IGF0IHRoZSBzYW1lIHRpbWUs
IGh1Z2UgcGFnZXMNCj4gPiBpcyB2ZXJ5IGxpa2VseSB0byBzdWNjZWVkIGluIGVpdGhlciBjYXNl
LiBUaGUgImZlYXR1cmUiIGlzIGNsb3NlciB0byBjbG9zaW5nDQo+ID4gYSB0aGVvcmV0aWNhbCBy
YWNlLiBTbyB2ZXJ5IG11Y2ggbGlrZSB0aGUgbWFueSBidWdzIHdlIGRvbid0IGNoZWNrIGZvci4g
SSdtDQo+ID4gbGVhbmluZyB0b3dhcmRzIGx1bXBpbmcgaXQgaW50byB0aGF0IGNhdGVnb3J5LiBB
bmQgd2UgY2FuIGFkZCAiaG93IGRvIHdlDQo+ID4gd2FudCB0byBjaGVjayBmb3IgVERYIG1vZHVs
ZSBidWdzIiB0byB0aGUgYXJjaCB0b2RvIGxpc3QuIEJ1dCBpdCdzIHByb2JhYmx5DQo+ID4gZG93
biB0aGUgbGlzdCwgaWYgd2UgZXZlbiB3YW50IHRvIGRvIGFueXRoaW5nLg0KPiA+IA0KPiA+IFdo
YXQgZG8geW91IHRoaW5rPw0KPiANCj4gQ291bGQgd2UgdGFpbnQgdGhlIGtlcm5lbCBhbmQgcHJp
bnQgYSBzY2FyeSBtZXNzYWdlIGlmIGEga25vd24tYnVnZ3kgVERYDQo+IG1vZHVsZSBpcyBsb2Fk
ZWQ/DQoNCklmIHdlIGtub3cgd2hpY2ggVERYIG1vZHVsZXMgaGF2ZSBidWdzLCBJIGd1ZXNzLiBU
aGVyZSBtYXkgYmUgc29tZSBidWdzIHRoYXQNCm9ubHkgYWZmZWN0IHRoZSBndWVzdCwgd2hlcmUg
dGFpbnRpbmcgd291bGQgbm90IGJlIGFwcHJvcHJpYXRlLiBQcm9iYWJseSB3b3VsZA0Kd2FudCB0
byBkbyBpdCBhdCBURFggbW9kdWxlIGxvYWQgdGltZSwgc28gdGhhdCBwZW9wbGUgdGhhdCBkb24n
dCB1c2UgVERYIGRvbid0DQpnZXQgdGhlaXIga2VybmVsIHRhaW50ZWQgZnJvbSBhbiBvbGQgVERY
IG1vZHVsZSBpbiB0aGUgQklPUy4NCg0KV2hhdCB3b3VsZCB5b3Ugd2FudCBhIFREWCBtb2R1bGUg
aW50ZXJmYWNlIGZvciB0aGlzIHRvIGxvb2sgbGlrZT8gTGlrZSBhIGJpdG1hcA0Kb2YgZml4ZWQg
YnVncz8gS1ZNIGtlZXBzIGEgbGlzdCBvZiBidWdzIGl0IGNhcmVzIGFib3V0IGFuZCBjb21wYXJl
cyBpdCB0byB0aGUNCmxpc3QgcHJvdmlkZWQgYnkgVERYIG1vZHVsZT8gSSB0aGluayBpdCBjb3Vs
ZCB3b3JrIGlmIEtWTSBpcyBvayBzZWxlY3RpbmcgYW5kDQprZWVwaW5nIGEgYml0bWFwIG9mIFRE
WCBtb2R1bGUgYnVncy4NCg==

