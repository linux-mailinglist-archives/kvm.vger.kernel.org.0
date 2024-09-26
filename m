Return-Path: <kvm+bounces-27593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 46A88987B7D
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 01:06:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B81F91F26F04
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 23:06:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AD0B1B0112;
	Thu, 26 Sep 2024 23:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GiPZggWc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6508A1B0100;
	Thu, 26 Sep 2024 23:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727391968; cv=fail; b=F0wzwCuWbetXLRpJOv6F71QP7sDEc7zU+5LEvvS80iIjCCu7ELX1xm3ZCXZn9EPGakChLi1cpus4oMQXO+OKYQHeAVZ6dqHL5MxyrTWTbj5MySUYYOUBhRQ9TuOSH+xTziw2RYqXft8NqSMXpiZfQGwSwXLmuz3uCP46y+bZVMU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727391968; c=relaxed/simple;
	bh=BLQZl+WhAnN3FD5YzZMl9d56qhJa5tRvWgeOi0hnUt4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GVdBNGl3Xv80zEa/fM+5T7qS1gNSV+UU1ECIZx4Mm+gdaeIDBY6kUh5a9x/qmDMd7oZOSUScl+wsCupLWMGkf5l1FO+6R37rzaIhQpz8ByaY6nK37dk2kbzWRG95G+s+oY56qIhac/lRAvOlefm2ouX44Z4drg+Qr3eeFvklOS4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GiPZggWc; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727391967; x=1758927967;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BLQZl+WhAnN3FD5YzZMl9d56qhJa5tRvWgeOi0hnUt4=;
  b=GiPZggWcDGIFNkib7IuHDIlCs1XMwDWec4miL/5s4r37o2TQpSNzDL/v
   DE2KD6D+6yK0f3sIfr2HLMNYJ+caqeeNC9iNx36wqtLJ3bLXIJQy7Zi1v
   dVBaijLTKUmTshqMcAZm2CWm1K923qGLUfRxWU4/vNTSc6BJs6FjE6lrP
   KH4Tsq4EPCF0qIrrrR+xPB7ZEbBpSBc1io9GwNcJmrCjAgljv/r6g8wto
   +bHar7QyJLtHOO24cUBr2d/V9yxhHRTqoocg7nMZQJpNloVmPeInvWSot
   tdTQvaSvppIhXF4ZqTDaI3T4Uug3L9bHKSq8VNkGZCWHrmG9IDd3OLJfI
   A==;
X-CSE-ConnectionGUID: N2TaxjkNSHK3lq7iAeLJ2Q==
X-CSE-MsgGUID: d1T3WHWDR/CVMSUUK6kgWQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11207"; a="26621819"
X-IronPort-AV: E=Sophos;i="6.11,156,1725346800"; 
   d="scan'208";a="26621819"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2024 16:06:06 -0700
X-CSE-ConnectionGUID: 5cax7ddpQQ6RPAY7mAARkg==
X-CSE-MsgGUID: PYEj6NsaSJev1eX9cW6//Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,156,1725346800"; 
   d="scan'208";a="103135870"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Sep 2024 16:06:05 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 26 Sep 2024 16:06:04 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 26 Sep 2024 16:06:04 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 26 Sep 2024 16:06:04 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 26 Sep 2024 16:06:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kN4lgJp4My8IwdsoHGnAAx/Ep0jO7vOrOAjnJ3ASN9JwE6D+WBnMTWJCE6iwKjXK6KEGBjQHz3tmuyYqMq5PEQd/hQAVfP5A9GDGv/R4tFDy8crvQBnItw/bIUajCoaQ8jlqR2JwJKJqR1zQqSsVOGbJW65dTXuROoiJDOklb+8tfAivt7zkRqyFCzTXOTDKY+oFAcIPCB91thCCT2IZtxwV/Z+u/7RGNh9DaAucL0uhFD3GkI5qzGpBzK6dUhFPS/KUZBMDS91Hk4/FO+6ONWFNoMqlqIcaD0yNxvPtFsv0a2UqdIT3Rn5CJgP/pQN9uVfnM2Fy/K0PxYaCA23wmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Njzr0dn9RGWdPOV4BW+HTU2e0bNuAkk4N8F0udVvvDM=;
 b=LAyHYyW/eAerjJ+561k5oqH583YIrLSVl+h8cgczpNb386idyM7upCO2Qj8ajEXXCp8d0Cq6wUQoLpOMOaXhQLOnURSsarBGD64O5k3UNdNbTWHv4KZfkK7SM4HMbaPzXEGSj2HP3deImJ1P+ysxcE3VIpl+9w6vUZLTKSW8kXKbVlzWizVkFFP0Wwu36Kf73q6fphXzS3v0OpP+E5icCD9m793ahrjHNc3wp79gmR63VosnF0VRsUACOur3XE5KtZODpGAI5QJkIK/VK7nxaw3ABDjHka1OBNs454b95AXZ/Jnqs7IenxaYjSK0GY8yegtafW5rhEmVAZy1KUbrCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB6431.namprd11.prod.outlook.com (2603:10b6:8:b8::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8005.22; Thu, 26 Sep 2024 23:05:56 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7982.022; Thu, 26 Sep 2024
 23:05:56 +0000
Message-ID: <1b14e28b-972e-4277-898f-8e2dcb77e144@intel.com>
Date: Fri, 27 Sep 2024 11:05:48 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/8] x86/virt/tdx: Prepare to support reading other
 global metadata fields
To: "Hansen, Dave" <dave.hansen@intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org" <peterz@infradead.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>
References: <cover.1727173372.git.kai.huang@intel.com>
 <101f6f252db860ad7a7433596006da0d210dd5cb.1727173372.git.kai.huang@intel.com>
 <408dee3f-a466-4746-92d3-adf54d35ec7c@intel.com>
 <62ca1338-2d10-4299-ab7e-361a811bd667@intel.com>
 <a03f740b-6b0c-4a64-9ff1-7eba3ac7a583@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <a03f740b-6b0c-4a64-9ff1-7eba3ac7a583@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0004.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::9) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|DM4PR11MB6431:EE_
X-MS-Office365-Filtering-Correlation-Id: e082fb7b-5ff7-427b-5dcc-08dcde7fc726
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?c0RIQzF6VjdmVWQxNGFPdUxFcGZEM1FxY25RamFZMkVFNVBRZUx6b3NwbnpZ?=
 =?utf-8?B?MzdPOXMvZHVWZzdWVElzcmZlT2t6UWFpWEh0akNhY29pUFE0Z1FjRHhUMVRp?=
 =?utf-8?B?dVdQRnM0UTh0RlFFN01XZDVBSk13K2dBVkdmMXY2akRuZ1pKNmVjUWN4bWFy?=
 =?utf-8?B?WkRzMHlHUFN0dERldGhEMUJDT1haa242QXp1VmVXVGwzYWR3elFiRVBtRUJP?=
 =?utf-8?B?NThXR245b0lJSS9vdEdhdnZzMDhsRVhxdE1Pa3hwWHh5YXN5R2RIK0ZIbVVS?=
 =?utf-8?B?cDZQNFNXS2NxVnR2OWNWeUhGRHNQalhBK041M3hQVG1UUUx1c2FYMjJ6RmFv?=
 =?utf-8?B?eUVYeUJ0cHNvdUpwbnkxcXRlbDF2d0N5V1JjT3RuSC9lcWN6RlAwV3pKOUxk?=
 =?utf-8?B?ZlVJS2lBL0JwL2FSZzh6Qi9GczRJdXpORWRWNXIvYVFoUXdKelVkZmZjVVoy?=
 =?utf-8?B?emIzM1p4dW1JWGZwaGxFMXNRQzE4K3FxWGNCOGhCQ2phMDBNczBZRlB6ZHV2?=
 =?utf-8?B?dHFuSWZTVmFXUGpCcXI5aDFRYS9PdTEvNHVIWUdoczUwRmdzaG1qN29aVWFY?=
 =?utf-8?B?V1Z0VjhKQ2RNNnU1VUEvOFQwdzhTK1ZnWnFFZGxEZmFJem9xRG4zRHluRXR5?=
 =?utf-8?B?Sm9TTE0vdEQvWGFJbmVvaXY1TnJXN0E4MFFIKzFmSGM5Q2tCbnVqTWpSbFJh?=
 =?utf-8?B?UnFmdDBmQUJnOGVkQ1IvZWk1MWc4QzYvM0U3ZUlxTlpxTUVOZUV4anFBNjdI?=
 =?utf-8?B?N3VXOFJPbzk4WEJYTS9xRmdZSjRaRnp3dkpZTGxvekxSQlhsM3NhR01WenpY?=
 =?utf-8?B?MGNua1RMcEVRRm9vZ1pOWFBOejJiRkZmeE0xM0JCQUNQUjBIdkNpQlR3RytU?=
 =?utf-8?B?Y1VFTkNpbWNsOHR4ZkpIUUJBbjRvR3RndnB4OEl4SmEzc3VJSHY0ZFRDdWtH?=
 =?utf-8?B?Sjh2a0pJMHVIS2RFYjRkV1ZCSzR3Wlg0NG9KRnpMQlBZczVGNmJEeWxjRVJm?=
 =?utf-8?B?N1NrNnYvVHpSdFNiWU9DVkc4N2FGT0pPd0VvQTdERjN3N0V1d0dGVXZmQXg1?=
 =?utf-8?B?dDVlRkdNeGNKT1ZXSjFFM080S2NyZ2phejF0NDd4M3E1ZDBHZFAzcGgzczc2?=
 =?utf-8?B?eG8rVEhPSGJ0a1picTZnMkJYRHpBQ2FUelVXdm0yNVFGcGMxNXdSb1E4Q3gv?=
 =?utf-8?B?Z2x6ZFVSQXRwWmEzMXlvREJXYXlDUXBNRWIzNVFLcG4vSHZkc2ZFeWpZaUNX?=
 =?utf-8?B?T1crY01wclIwa1dDenFVMVBoNGZNcnhXNVZoNjVuOEZPeGRVcy95S0RWcjF1?=
 =?utf-8?B?OG9LSnMxSjQrQWVLaDlqamlrYVRTaHpjdmlpdFBFMnQwYTUvTGFWcnNabXow?=
 =?utf-8?B?eERWa1lEVXRTckRRQnd3cGpFU25laUp6Y0ZNRjA1bUtZRzk1L3dsUWpGZ0hp?=
 =?utf-8?B?L0JsdDZUbVRFRzNxL3FaUzcveGwzTlNOcFFKVWtubTZGTzJ3YTBWelE3VllH?=
 =?utf-8?B?U09pNjdHZVl4TS9kUkRaV1ZUd0dhTVM5b3B0NVdUZnpPVmpHM2RER2RVN3la?=
 =?utf-8?B?djBGQVREVDk1UG0ybVFCWUdYQ1NJci9QTWFYSi96SUY1c0tGVHNxRC9IODF1?=
 =?utf-8?B?VWdPZUFWMjZCSXZ6b05UbGNtaElIenprRFhxOGd1MXZzK1lQd1lPS1FqS0Vz?=
 =?utf-8?B?NWJ1MDBuRWU1MEFNOFJnNDZNTGtFT0RrTCtzbXMrem9STnpWaGpWTDcrZDNB?=
 =?utf-8?Q?RjCUXW8yyMO7t33VGZxbJTecQAPa3y7UfkGfqtF?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c0tHQ2QxS2JzL3lFc3FKM1VMM2srQ0JQQy90UnhHMTNIU1JDeS81OU1ybG1a?=
 =?utf-8?B?Ty91Qno3TldhVHFiaml1dEtGK1Nsd0lCanU5S0FuY1ByQWQrMmhvQ1JDVTFN?=
 =?utf-8?B?UFVOWm1LeXdhdkVxZkFEK1gyNFVOeDc1MFNLZHJyS3ZRVlpBZmtLMitxcW13?=
 =?utf-8?B?ZVlhLzVidHhJcWlGZ3U4RU5MQ0xpUy9FYkJwWDJXWG00cCt0V01UNC9Na3pG?=
 =?utf-8?B?TnI4Z1pyNmpkYWJhYjh6cVNsWDRxUStHeWFOOXhqc2tMb1o0Yk5FaWFQOURT?=
 =?utf-8?B?VFdlTGxsR2YvVTZFaUs3ZUtDM1dVMkdlVDc1aFlxa3Q4bkVxd0J3eE9VZUZE?=
 =?utf-8?B?Z0QwVXVBeTREbkV1M0hCTkduN1VKQmRzazVhSWExUWUxQ1BxTXVZL2hMOWtP?=
 =?utf-8?B?dWdTWE5uWlpxVU92RmdrYUIzeHZOVVdVK0gwL0liTTlQNm5WWHFBMG9RY3Ro?=
 =?utf-8?B?dS9ZbWRiSVQrcHhUVysrTi93UE8vUUxJR3puZFA1MndGdEhVeGpwVVBOWTJC?=
 =?utf-8?B?eEdtbWZlakFEV0IzSmUwcWs3MWVoS1VkbWt2R1FtNitGQVpPNnJuVmxkNjVv?=
 =?utf-8?B?amlyYXhSSzdjYVhjWnpwVUhsVGN1a1hucEQzMGRQR21nckhWcDJycW1iWW1R?=
 =?utf-8?B?QWFOYjVDdWFzVlUxYlRidXNnaHk3UFpBL0ZNWjM3dnk2TGdZWlFNU1JBeUxU?=
 =?utf-8?B?Y29ZNTFybzRZR3dYYkhYQ0JGcWRkU2toTWVkc2h2azZMWjNtQjlSMGR3NWdI?=
 =?utf-8?B?NHk0OWFrZDR0MnIxQlNqeDV0QTZ2NWdTTWlIL2VLcXpNZ0ZNdEtibE5vZ3A4?=
 =?utf-8?B?Vk1neTRLcDJ3L2lZdWUyNWJlSjNjeDg2OEo4dDQ4Q3IxdTJkZXhvbWZ2ZDF1?=
 =?utf-8?B?K3YzV0MwZzFEeVZwWXZBVU9ETXQ3bEJIWHZGSUFaWC9nQjZRamNiU09NQUFh?=
 =?utf-8?B?S3ZXR0hXY3JXZXhocDlLbndUbkpHc015dFZUQzBmRlFpV1pHODFrQllkZTRh?=
 =?utf-8?B?L3orYjg0VU1ReVhGV2s3L1liZEo3alhSaE5ZSDlOc2UrZFVPSG5tWFlldnV5?=
 =?utf-8?B?cndyWmtUb25PajlIZ1NXdVdpWEpORmQ0clpKKytoVGViYTR5Sis4OWg2alFj?=
 =?utf-8?B?anRrb044UFRORzVQWFFvUzhCRWRrOFl3bmFBb0VNNnlBMTEyMkhSa2JiMVpo?=
 =?utf-8?B?bHpqYjRzb2pWTGVYdlJOSnJaMlJIWUVtcXVPZkVpeTZoc2NZTE9zUkJKS1RB?=
 =?utf-8?B?NTUyNkU4TU1NQVdhelV1RUpZcjc3NDJURVhMQmZTYVY5UE1wOG9CVXYvanpK?=
 =?utf-8?B?eU5aL3dyZ3pYa2dCcVZQQnVQVk1XYXFFU3FjTVRTTkd5VHBDL3NJbVgvK1Nq?=
 =?utf-8?B?OHVCZjAzbnlrbzBaWllCZDk1Z2lkaGZmZHFTZWY3ZVNSVmNET2Fwb0xOYUsz?=
 =?utf-8?B?MXYySEIxRndJNlZpZUFzUW9OaUlaa25mTFFtMFpTc0ExWWJKTllaNXV4dU5S?=
 =?utf-8?B?UFJTV042T3ZMQ2JLYXNUS3FFZlpUQkpoS2YvMkF5ZkpwU2RXaFplR1ZjWVI2?=
 =?utf-8?B?OUhlUEVwZTJ6a2dwdjZWZXBSVExxR1VoYTFWOEJQSkJmTUJzNkp6YlptSGJr?=
 =?utf-8?B?bXM1cWEybnQ4aWM1Tk1YZEs5aDQ4cW1GZ2RJY0wxNDNiQytjYlc0VmtiQmxl?=
 =?utf-8?B?MEUvV2lST1k1ZUp5ZnpYV1V4d0RzMGg5MGxzQ1I1V1lQdm1DazZTcmJGbXBo?=
 =?utf-8?B?cWlzN1JPdlZTaXB2eUR6NUt0RXBnZ0NNOTlXclNHdEtuRnN1Vm1mKzBrWlQ0?=
 =?utf-8?B?bURJTG81MWcvUm5GUzByVHJDVTR5UE84T1FLTkdVdjdQR211TDNxVlA2WVln?=
 =?utf-8?B?Tm5KOEk5ZUlYTVAwUlNLT01UbUd4UDN3N0Y3ZzRyVnliOFBxaGFXWTlKOVZY?=
 =?utf-8?B?bzFiQnFUM25aUXUzelZYakxySWNpS2c4WTlxS0V6TTN2eU9yQW0zQ3FjcEV3?=
 =?utf-8?B?Z28xTHgyNERVVlZDdk5QM1hqeEdweW9yK2NXZ3d6SVZjQ2taajRYeGYzOVpG?=
 =?utf-8?B?TUdlb2o5Wm1NZTBmTjFzZjlmVzVaVHk1ZUs1ZnFTamdJVG5sZTlRMXV3WWV2?=
 =?utf-8?Q?1Br9Q0ldOQzj5/dxog8C1Z1nF?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e082fb7b-5ff7-427b-5dcc-08dcde7fc726
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2024 23:05:56.5308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2AoJdSebLxh/neFWPcgK+PXxA7U/F0jEUWe3Qag3KCzHyK4tSuR3nyM4wIPpn4Q2VImAmgLL4r7xdQ4wmxzG2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6431
X-OriginatorOrg: intel.com



On 27/09/2024 10:26 am, Hansen, Dave wrote:
> On 9/26/24 15:22, Huang, Kai wrote:
>> But Dan commented using typeless 'void *' and 'size' is kinda a step
>> backwards and we should do something similar to build_mmio_read():
> 
> Well, void* is typeless, but at least it knows the size in this case.
> It's not completely aimless.  I was thinking of how things like
> get_user() work.

get_user(x,ptr) only works with simple types:

  * @ptr must have pointer-to-simple-variable type, and the result of
  * dereferencing @ptr must be assignable to @x without a cast.

The compiler knows the type of both @x and @(*ptr), so it knows 
type-safety and size to copy.

I think we can eliminate the __read_sys_metadata_field() by implementing 
it as a macro directly and get rid of 'void *' and 'size':

static int tdh_sys_rd(u64 field_id, u64 *val) {}

/* @_valptr must be pointer to u8/u16/u32/u64 */
#define read_sys_metadata_field(_field_id, _valptr)	\
({							\
	u64 ___tmp;					\
	int ___ret;					\
							\
	BUILD_BUG_ON(MD_FIELD_ELE_SIZE(_field_id) !=	\
		sizeof(*_valptr));			\
							\
	___ret = tdh_sys_rd(_field_id, &___tmp);	\
							\
	*_valptr = ___tmp;				\
	___ret;
})

It sets *_valptr unconditionally but we can also only do it when ___ret 
is 0.

The caller will need to do:

static int get_tdx_metadata_X_which_is_32bit(...)
{
	u32 metadata_X;
	int ret;

	ret = read_sys_metadata_field(MD_FIELD_ID_X, &metadata_X);

	return ret;
}

I haven't compiled and tested but it seems feasible.

Any comments?


