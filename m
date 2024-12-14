Return-Path: <kvm+bounces-33815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AA62A9F1DA6
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 10:00:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EFC0C188BB17
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 09:00:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA9C8170A13;
	Sat, 14 Dec 2024 09:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FRbSu22+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41C317BB35
	for <kvm@vger.kernel.org>; Sat, 14 Dec 2024 09:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734166808; cv=fail; b=g4rHFvHzEtQDP+PiQD1Iy/U/mRiuBMNYJ0LFPl3UqnVrDMlfRlO67hcxcROpeUodZIZ6yQMUtwStQEEAboK34kPRIWZskQg4cVv2iQ6LMT0Zo5Uvwz7aZaHs6emuMCSgIVDWaiu1R4Yg4g6j+jzcY0fh/QMvq9UtKRdNZqbkPR0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734166808; c=relaxed/simple;
	bh=QHTV/HVoZkjULR/eoTo/kN/Putq3Q8w6wFKStQb50os=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VsMumcULF+oSB8uK1nSJuSnEIWhR67aPDwWMTUjBlI+YaSrTWVbf1aUlNfUtPLGRBooiJCIB2uLUlOvmTodHQI/P90QHT4kP2Qf3SFNJxUZ4Exz7DXWD45xh1kkQHdUJyBH11Y56cvNI3b9pyEc4B9mQjIYSptZta9tpRYYs2d0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FRbSu22+; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734166806; x=1765702806;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QHTV/HVoZkjULR/eoTo/kN/Putq3Q8w6wFKStQb50os=;
  b=FRbSu22+FC8KUzpQcrxz/rfnX9nGD43RjagG1Phcgq+DkQZJtE72e0E+
   4mdEUA/CRGKgeSuQE+kKObKuz6CnJ1/2IFKCat+orNpEIhWxsYPYmn+cq
   hsEY7oba/8/fneN7KJhOEJOy7K6cCp694YUyKMntGMdJAiK5NHnZGCmsX
   r4kXWhDwdvACisfO3qbeBnvhoDcODOFaJxAl9CamrBxBlunweYLp0iTYA
   eJrNluvWRosTaOMIqtDErXVDECZSZ1gdPtkFLmB9I5oDPXGjtk3D20sHq
   aPaM2Fb9dlc1gNAfOr1uDrK0/PFWymIONqhbqRONBDkeOyKmdJYOa+89P
   A==;
X-CSE-ConnectionGUID: CY6SlENzQoy/RfUWVtjPWA==
X-CSE-MsgGUID: 2BjwE6HoTLuls+PQnnorBA==
X-IronPort-AV: E=McAfee;i="6700,10204,11285"; a="52134847"
X-IronPort-AV: E=Sophos;i="6.12,233,1728975600"; 
   d="scan'208";a="52134847"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2024 01:00:05 -0800
X-CSE-ConnectionGUID: Kl41nV0ZTlmVRqKfqzERhQ==
X-CSE-MsgGUID: ed10PX/6RoW99fRs+yLwDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="101709684"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Dec 2024 01:00:05 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Sat, 14 Dec 2024 01:00:04 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Sat, 14 Dec 2024 01:00:04 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sat, 14 Dec 2024 01:00:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=avISleb8g0jEoR4n4kH21ZzrYG1IkMir+MkAyxi76QpMb2ZjCY56wfIT292NULfMI2RrTAoGFwtCTZoTw8Va1d2Zwyy9QcPwLQj1PO6v3VGTvDILE9YVGLmX7aYiZZfPeKV2Ozb7yXu6dOdLrumav7foIBgHF1VREu3jCS32imPh/9L5YcFVbvVJK+FLHIxYFatQzW1o6XmfEsgpI9Chzamv+QF1IkosJECxm/FJWKDT5QSvpELdkvVAEbi1JfiINZVnVfUh25hl1QA9bbkej8DmTQNxvDjyaXGZkIKGkhKNZ8Pi5Ks4s5i3x8At77g4A+GNO9qpQBrgga4giTvezg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T85BhBQfQGjZRMX+J6GsnLGLYrnQMl7tcEtJo4JoQro=;
 b=IQtDRzKfo8IGZwBL6PUtEWIKCr+kpm1riVC2sZiJCr4TF+HRhu0+A1zV2UEpaj8umc41O5CWv4F0B16Oz8UJ8Plb5UoBLuFPuicmxyzQgsAC3yx0u1XGfzxv04dyjqrkrXVz7sNGrFf2umCuE07NZPI9MWLO+DeiwbXLNTHTUrqbj0E34pGLWFFb+Rjd0UGA/4JYpPG0QQX8u5Ex193ItVjfh50c6dmxXXnzcxdAQu1uovNwqfBgF5gpBURfsHXB4MJYPovTjfPmC8qynou+uVWA4wZfe1bPEyVNWZr8EK49aJsZGdt6At70Q1bFlvDQx75rO8q3w2C0CPOFy6w/rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CO1PR11MB5186.namprd11.prod.outlook.com (2603:10b6:303:9b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.18; Sat, 14 Dec
 2024 08:59:22 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%5]) with mapi id 15.20.8251.015; Sat, 14 Dec 2024
 08:59:21 +0000
Message-ID: <46b7fc65-491f-4965-9d9b-d77901e41dfc@intel.com>
Date: Sat, 14 Dec 2024 17:04:20 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/12] iommufd: Enforce pasid compatible domain for
 PASID-capable device
To: Jason Gunthorpe <jgg@nvidia.com>, "Tian, Kevin" <kevin.tian@intel.com>
CC: "joro@8bytes.org" <joro@8bytes.org>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"vasant.hegde@amd.com" <vasant.hegde@amd.com>
References: <0f93cdeb-2317-4a8f-be22-d90811cb243b@intel.com>
 <20241209145718.GC2347147@nvidia.com>
 <9a3b3ae5-10d2-4ad6-9e3b-403e526a7f17@intel.com>
 <BN9PR11MB5276563840B2D015C0F1104B8C3E2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <a9e7c4cd-b93f-4bc9-8389-8e5e8f3ba8af@intel.com>
 <BN9PR11MB52762E5F7077BF8107BDE07C8C3F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <98229361-52a8-43ef-a803-90a3c7b945a7@intel.com>
 <BN9PR11MB5276E01F29F76F38BE4909828C382@BN9PR11MB5276.namprd11.prod.outlook.com>
 <c91ea47c-ca71-4b37-b66c-821c92e3d191@intel.com>
 <BN9PR11MB5276655399B4523F4CEEA63D8C382@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Z1wrQ+kgV53BsodW@nvidia.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <Z1wrQ+kgV53BsodW@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0003.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::16) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CO1PR11MB5186:EE_
X-MS-Office365-Filtering-Correlation-Id: da2b1da7-b570-4631-61a4-08dd1c1d99de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?a0FWQXZ6MkhiWjJnaS9zei94ekRrYnB3RGpUbXpOaTR4K042bXNCdWJrTzJq?=
 =?utf-8?B?Q0VWUXZBTERPMjlubkpPUlZrcS9TbFJwSVFmQXhRb0FPVGRRc1kwUWNoVGN1?=
 =?utf-8?B?RDRXR2hsQzhrZVRZdWpjWDE3NWJ1VXpnV0Z1WWx2SlV2NlFmUzJ4RkFZYjly?=
 =?utf-8?B?UHMxS01TaHpBS0Z5V3dMcis5RDhjc2M4WCtrNnRKbkowWUhVdW9Xa3RDei85?=
 =?utf-8?B?ZkxlNFpidUptNmg5d1ZDWkZabCtvQU45dDN3bzNRZTlNTktaaUh4WklQK1Z6?=
 =?utf-8?B?VUgyNUxDajhyM2xVRExPOEx6VnVBbmFvbEl2a2NnUUdTSlIrK1VybWtYY3lK?=
 =?utf-8?B?aDRYZzFtUHpvMjBHM1Ric1h1a2IwODFxMnlUYS9IOHZ1anJTWTVlMXJaYVZI?=
 =?utf-8?B?M3QyWUVJSU5ZaDd1VEcrYXdxSllTK0dKdVk0UDdIWkY1N1hsN1d6eVA5bHdO?=
 =?utf-8?B?cWc2VGVrQ2VWSUIxQk4wbXJZaFdPUFZvRlg2RFZYMmV2NVNtb1N2cEFKdHVK?=
 =?utf-8?B?TEVWQWtieDFCM3JlOGY1Vk40Yk5ERkxsMlpQbFE0bUIrRVNBUHJGRGZyQ1Jl?=
 =?utf-8?B?OHgwQTg5eWF2V21xVmtqZncvVC83eFpqc3h0ZFhBTXZ5c0xmUlpmUnhQN1V1?=
 =?utf-8?B?V2hRaGtOZHkycXZsV21SUDYwblhJblowYTljN3cwTGc3TkJkeGNIOG1uYlZL?=
 =?utf-8?B?aitITHRpbzRqd1h1NnJTOGZSNFc1TmJacCtJWkNrMUNhT2Q4SGszN0NUTy85?=
 =?utf-8?B?SzUwYnU5NHhlMjJYZmhIbVV1SXo3VkNNWWhaNGMrRzAwaXI5T2gxQlgrUW9u?=
 =?utf-8?B?TTZUbnVwU3RNeHhGeFo2LzJlVHBQVjdZZnJ0UWxWamJrY2hsaEtiWW1OdGFs?=
 =?utf-8?B?STd2K1EwUzBBMlFzQjJ5ZnNYY3ZUZ2NWM0xvMVVoY3A5Qk9uKzlIV1NVclFD?=
 =?utf-8?B?andtbXpDeTZTZjd0QTJ2RmJrOTgrMFZYSUhxa29pM2tZdUxERzd5c0tNaThV?=
 =?utf-8?B?MjJIMytqZ0lBaStWSUlQeDRSbFNhalJIL1YyUkFRdkJqa3Z5Z3gzQTdLTEw5?=
 =?utf-8?B?ZDR2S1doZEtCcVNCMDM4ckN1WStaVWtwMCtCWVNEYzgrZGluSXlNUnkyT1pE?=
 =?utf-8?B?TVJuTEozMXZWbjhiK0NoNlFmd1hEY3R5aDMvUjJxUmUrNks3eElGdUR0M29Q?=
 =?utf-8?B?blljSXlhQTFaUmxaVDFtZ0cyWWplUFIxb1dRd0pTMXpNL2c4SEEySXhoc0dx?=
 =?utf-8?B?TEk3cGhvRlpmMzlhekV1aE9VTFNWS2txZEQ4TCtjdE9mTUpOY081SGVvRjkv?=
 =?utf-8?B?bm5KcVBqdmpwUUpseVpLVTBmRzY0UGlJVEZZODFFN0VySjlLek1zbDhnRWht?=
 =?utf-8?B?MkFZYU5vTHNabmJVclA0TjZaeUhaM1g0RndkQVJMTHUyazc2ZDRPY1JhOG01?=
 =?utf-8?B?cW44ekZnMnlIQ3BtRFRJRHdmd0MxR0IxOGpBY1ZRZGZjWS9DTUpsZkdXMWJE?=
 =?utf-8?B?MS9IQUpOc0M5QlhSNVBLa2QwdHhEVW04QkI1L0NWSHBaSStneEp5K3EwMWJ6?=
 =?utf-8?B?d0hRMDQvUzdnVW4xSU5oQkMwVnpoT0gyYlYwdmM1TVRIeTl3ek9rSDFBUkgy?=
 =?utf-8?B?N0JncU1zUjdpUS9TMmZqZU5scGhtU0xTU2pDZEpUWlgzUHR1VStBSS93Z2w4?=
 =?utf-8?B?SGJ2Y3R6VFFjYlBleEF2dHFlUW5vVk54cHlKc2Zaanc0K3JpbHYwN1FIdzBE?=
 =?utf-8?B?c0J3Yjh1ZllMYituOUVOWU1rZW1iZjNMb25pbnBoSWE4OVFYekNRR3ZLbUda?=
 =?utf-8?B?N3lzZ1FNMU1jRlFqelJRTnpBS1NYeHhteUhVRXNOMi9PTmJjaUVIV0p3emRG?=
 =?utf-8?Q?1cMjKPsgMPD5Z?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VmFUa0oyam9zbzJadFB3MW5ZdkNsTkdNbkE5c1puWVRwbDM5OWkyOHQ1OXVu?=
 =?utf-8?B?MXJjZ3c5UkhhYnZ1Y2xleUExRm12dEpxU2R3U3hzSWdyOWZKWHM3ZnZiK3FS?=
 =?utf-8?B?ZlpQT2g5Yys1VS8zOGY1QVQ4TWw3SHpCSDFYN0JDMGQ4WTJOV3VpTGhjZUhy?=
 =?utf-8?B?dmtFZHZzekt3a0kxK2tySDJJVDZ4Ky9oOWFjeVRBUkJ1YUpWOUcwOU9Tclc0?=
 =?utf-8?B?TmtnWEtsa0lhZkdTOVA2TUdJeGw0S1UyS09lem8rTkFDRkJtdkZ0VEcvWjRO?=
 =?utf-8?B?TGdJSEdWNTZ6anYxWkpIajBnWTFhSkdGUzdrbHJZL2R2eGcrT0E3QVFWWnFM?=
 =?utf-8?B?N0xBQnduUXdxSUY2T0ovbTZOV1lBclFsNlJySTFyTGlraTNzT3g1WkNtL3ZZ?=
 =?utf-8?B?TDA5V3BNQVhmTkpJUit3ay8rbWdjVWhwR1g5RFVFcitoNi9IYm16MWR5cXlI?=
 =?utf-8?B?N1FISTVhUlNOcHZNQWpxejQyYVdUamh5dnZWcGNFdWZ5bW5YVldqQWRHWTlD?=
 =?utf-8?B?NFdPU1FkemQ4Q3ZvK0tKKy9JM2RkQU5KaTJ5b3RIem52RDl2d09RMG9UeU5R?=
 =?utf-8?B?cnZwT3liSVBSd1AxVVU0RFowYlg0VWRDMXUwcDUvR1hEY1U3Sm5seDhFZkZW?=
 =?utf-8?B?WVpVamYzaXJXRFdJNlhhY0IwM2Z0UCtyNGY1ak5BRVpDamJwdWtyb0d3TXFL?=
 =?utf-8?B?Z2NxRlZJclhnenA0SkpueFptN1FMZ2dJYm1VcXJJemVOVGRnVlFiMUJHNmxP?=
 =?utf-8?B?K2pyTVE1dkJKRnpGdFRPV01ScHpRZWFoYXNvVVFiSkI2S2JxdXN3WjhMWlhR?=
 =?utf-8?B?LzJQc0JETXhrWkpJRWdCLzM4SEYxbWk2aUNFZzJTN2hVQk8wd2NzM0pBYVZa?=
 =?utf-8?B?V0RjWS9JSnFvdWk4a200Z2pSTGQyVkwvcFk2cGZoOExrOThjdUM2WEsxSXBw?=
 =?utf-8?B?QkdmU21iVE9DR251TFBXSkdXK25yQzhITzJvY2taVzNkRU0vYUVZaGlHdDNR?=
 =?utf-8?B?aVZZcGZEb0M4NlBYK2NvcVdQQWdNVk85ck9VZ3h6Y3lOcDNlVk53Q2R1d2RE?=
 =?utf-8?B?NFlySEJoMWowdVcwZGw5TElheUdYd2tCV2dHRVFDSlpOQkZMNDhSaHJPekp3?=
 =?utf-8?B?SzJ3YVFhaFUxMENLSW5KbjFrdDBmUGg4VTdUcmc2ZUwwMjhpcWpTbllnZzBW?=
 =?utf-8?B?dE0ycWVhaitZTldvbWk5a2F3a2NKMWY0STVUNGVTb1c2azZtdk5hbC93a3JT?=
 =?utf-8?B?bkdHNWl6UHBSOGIxZEc0RnNhcXlveGQyREpYR2FaWkViRnQ2QkF0cnFzNHVW?=
 =?utf-8?B?WFRidjh4N3Judy93MFFEUXlvS2xMYkQ4QVdhQXFaeTh0NWxZd1FDVmhCNVd5?=
 =?utf-8?B?a21IQ2p3UTNVVHdFUE94czlMbkZLLzRNQTdRdGRkSDdBZ1VBdlJkNExaalBp?=
 =?utf-8?B?K0RiOGY5Rm9wVFBGRmRZZzV0a1ZEYVBRMDZZZUV4R2R0WVU0RktHTFBaOTZD?=
 =?utf-8?B?WHVIeC8yM3pSYUFOenRvMHNqa2JrRWpnYngyZU5uVzFkR0tLSzg3WGNaRjh3?=
 =?utf-8?B?eVBMTnhtODhSOXgyQWxYR1YyL3JIQXRubEN0SDRhSlF3MUtQV3dFbDA5TXUx?=
 =?utf-8?B?R1Y0dlVGOVdFU2h0ZFIrcHVnd1ArSk82c3JiZ2RzdW9BUEpndTk4cC81UEVL?=
 =?utf-8?B?NHpHMW1xdDVvdXlRaCtDT2kwNmY2N0VmN2tIL1RyUHg0bW94ZWZrU1BhTXA4?=
 =?utf-8?B?K3BqUVNVekhyUXdpdGNaV2w2WkRlYVR3WkZva2l0V0svSUxvWFlmWFFKbkky?=
 =?utf-8?B?eUJwR0V6cnliWG5iNG15eEJTb1Z4Zm5ndytTY3ZrMmMyeWJQdklrREt4cng0?=
 =?utf-8?B?SVhkT2lhWXh1a08xenAzM2FZV2RGTzF4RzAvYndRNDcrYjJ6UW5BU2JySnFi?=
 =?utf-8?B?am1ha2F0ek03T2FTQVZTeEt5UXNMZzdDK013R1htWXBWSnNJSkJBRktXS3h5?=
 =?utf-8?B?RTJNQTRIa0pCT0hvVXFkRkhQUDc3VTlUbTZkTGlWNzdDczlWRzQrMEhsUzdF?=
 =?utf-8?B?Umw3bVgyRGlaL2RCT250M1VGaW80cFA4MktDTEdCYmY1UER6ZExZVWFJWmgy?=
 =?utf-8?Q?AIP6k7uskjHC4QJ5jlF8ODjxq?=
X-MS-Exchange-CrossTenant-Network-Message-Id: da2b1da7-b570-4631-61a4-08dd1c1d99de
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2024 08:59:21.8919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GT8gBgVM2bkpDGEFNHs5W/c/kACc8ahkg6XzhNTS4kac7+3Co1CepOPNjzkUeiP1o7p7y0YSG4502fVjw1Gsyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5186
X-OriginatorOrg: intel.com

On 2024/12/13 20:40, Jason Gunthorpe wrote:
> On Fri, Dec 13, 2024 at 07:52:40AM +0000, Tian, Kevin wrote:
> 
>> I'm not sure where that requirement comes from. Does AMD require RID
>> and PASID to use the same format when nesting is disabled? If yes, that's
>> still a driver burden to handle, not iommufd's...
> 
> Yes, ARM and AMD require this too
> 
> The point of the iommufd enforcement of ALLOC_PAGING is to try to
> discourage bad apps - ie apps that only work on Intel. We can check
> the rid attach too if it is easy to do

I have an easy way to enforce RID attach. It is:

If the device is device capable, I would enforce all domains for this
device (either RID or PASID) be flagged. The device capable info is static,
so no need to add extra lock across the RID and PASID attach paths for the
page table format alignment. This has only one drawback. If userspace is
not going to use PASID, it still needs to allocated domain with this flag.
I think AMD may need to confirm if it is acceptable.

@Kevin, I'd like to echo the prior suggestion for nested domain. It looks
hard to apply the pasid enforcement on it. So I'd like to limit the
ALLOC_PASID flag to paging domains. Also, I doubt if the uapi needs to
mandate the RID part to use this flag. It appears to me it can be done
iommu drivers. If so, no need to mandate it in uapi. So I'm considering
to do below changes to IOMMU_HWPT_ALLOC_PASID. The new definition does not
mandate the RID part of devices, and leaves it to vendors. Hence, the
iommufd only needs to ensure the paging domains used by PASID should be
flagged. e.g. Intel won't fail PASID attach even its RID is using a domain
that is not flagged (e.g. nested domain, under the new definition, nested
domain does not use this flag). While, AMD would fail it if the RID domain
is not using this flag. This has one more benefit, it leaves the
flexibility of using pasid or not to user.

diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 0e27557fb86b..a1a11041d941 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -387,19 +387,20 @@ struct iommu_vfio_ioas {
   *                                   enforced on device attachment
   * @IOMMU_HWPT_FAULT_ID_VALID: The fault_id field of hwpt allocation data is
   *                             valid.
- * @IOMMU_HWPT_ALLOC_PASID: Requests a domain that can be used with PASID. The
- *                          domain can be attached to any PASID on the device.
- *                          Any domain attached to the non-PASID part of the
- *                          device must also be flagged, otherwise attaching a
- *                          PASID will blocked.
- *                          If IOMMU does not support PASID it will return
- *                          error (-EOPNOTSUPP).
+ * @IOMMU_HWPT_ALLOC_PAGING_PASID: Requests a paging domain that can be used
+ *                                 with PASID. The domain can be attached to
+ *                                 any PASID on the device. Vendors may 
require
+ *                                 the non-PASID part of the device use this
+ *                                 flag as well. If yes, attaching a PASID 
will
+ *                                 blocked if non-PASID part is not using it.
+ *                                 If IOMMU does not support PASID it will
+ *                                 return error (-EOPNOTSUPP).
   */
  enum iommufd_hwpt_alloc_flags {
  	IOMMU_HWPT_ALLOC_NEST_PARENT = 1 << 0,
  	IOMMU_HWPT_ALLOC_DIRTY_TRACKING = 1 << 1,
  	IOMMU_HWPT_FAULT_ID_VALID = 1 << 2,
-	IOMMU_HWPT_ALLOC_PASID = 1 << 3,
+	IOMMU_HWPT_ALLOC_PAGING_PASID = 1 << 3,
  };

  /**
-- 
Regards,
Yi Liu

