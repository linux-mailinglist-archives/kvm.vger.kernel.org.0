Return-Path: <kvm+bounces-21848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AD762934D94
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 14:59:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D06051C22AE3
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 12:59:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB13413C8E5;
	Thu, 18 Jul 2024 12:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DB3thVc9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073F413A407
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 12:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721307538; cv=fail; b=UFJaxIiBOPtDGv1N8KmD67lxB9Ob/w5u+QcaPJXbyXXH0re/6M9QxGLmoQlOVIH0uz2lLxBu1VgRcc0FjmFbD4Za7bMAehs0cH44ASY3T+p6zjTH9R+ezu/Rzp2zH+pBZykYXXgUT2GWJ4HNrNUgyPimTOawZk08TSfFdv0J77I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721307538; c=relaxed/simple;
	bh=i1MTVk4VQhD1qltzaXn7a7lg3KaCt5D5dZYNIARL0cc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=h+x6haauYfMC+5VFn9vhU7Uu9KnaOh56XpLkxMW/s8bMgKo+u7VmkrRauTH+00bKvkwdMZLeN1gmdfkLuh0VPqL11UEUEDI4t6w2XmhK/2Y5FBmOVg1Gi7mhY3EyAJqM+p1+LWtHvbcQU5wmg0U7HOiNTRAZe1qeT2fTUv6KJnU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DB3thVc9; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721307536; x=1752843536;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=i1MTVk4VQhD1qltzaXn7a7lg3KaCt5D5dZYNIARL0cc=;
  b=DB3thVc9OXhWmU8c4J1yBZbD7N3zGs9/TFGgARwVwNc+xKaDZInzg0tt
   6IiXIZpt1aaaCV/pq7Va5YdGBX4NNCbzYUtRYroB5vvS13Os+pYCvgdt+
   KLOu+Iv5xbNMB5eXb8hLaAjzlKp4HDomxOlA7DmkAuypskS8MAxcSaYCr
   zNoB8NVPy9xHp5mdohnGiNicPd6QZJ3InzcWoPc8d5CDnMfJ1HkimEDxR
   dlln/XGtvLeUEgq39TXS7NDjTe+hvbuw9DNQn84RocUfRl8CNvhw5YC1B
   Bu6gcZUkyTHMhpCoYXS898Pzdteu4Cj8iuVs8Xhb2zMw0jvp3D0DU1T67
   w==;
X-CSE-ConnectionGUID: z96c5oTpQsOq+GjcPEU0Jw==
X-CSE-MsgGUID: vOvKMB8kToOfOHqoixBUMQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11137"; a="30026577"
X-IronPort-AV: E=Sophos;i="6.09,217,1716274800"; 
   d="scan'208";a="30026577"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 05:58:55 -0700
X-CSE-ConnectionGUID: JA9THrs5QgKIBg7wb2dKiA==
X-CSE-MsgGUID: UnKZFjXvQvCvP0pHHt9FMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,217,1716274800"; 
   d="scan'208";a="50475776"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Jul 2024 05:58:54 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 18 Jul 2024 05:58:54 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 18 Jul 2024 05:58:54 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.45) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 18 Jul 2024 05:58:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wx2AmKGfQCFSQBia5JEJS3FngwzHROaQaoVa2x/lOU5M+gs3i10sLDZEmGQZAhWdNpLiZtn07zuJNpWoj9yOjjjTJLiwuXgCfWca6Sbd/MxMMLQG7IADaqvCqLDxJRmUcAiJYKRw9JGEHXSJX4UYTGlEyPhBuC4wLCxUaoMJ+P9NUEosuwpyfT2Z5r8rKBfyPMvbPtx2yktnYWshgVK2s5QasXfpRGP4LkRo5QLNDsfkc2RorthafJrqtdr7V567Mv/WtqvPyauQBCggGe89bwexiF2imngdQqltRXjLL97uYbI/a5Vf2I7o591dlYjSzgqAkMJUdDuhCFDQsIV+AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7TNLLl6jO1ZDzXA+3tgr3g9R8yc1DYNimasyPRlNp6Y=;
 b=hZY0xr+kQ5WISZG/NjGFDQENStR7Tow5xPUEqpX8pYUTrV/E7fHf7zykokHMOW1vpGRvEQSpWoJ9wgKe4ZUPw/dB8QvDKZrAlO7Du79kJuwP1ymXNv2VL4FLnFbvZw2ISHGgXPfEWnYVXt24557z2fxXAWvmRa0ymB1fE8qoFCjaMWpAH65WP7o7UgZ4sNUER8nb46gLsv/8xNlDUFSPwI3r164weTK7HBPjS4Of8Qfn46uCh2MINLUcOkHrIpZ1P6WR9bY0OVoVockGX+W1begSHTdeTelYR5PrlpGCw98bo2xGjQB/ZR11yPKr57n6LVLec4NXveAGfse4pVKF/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA3PR11MB7582.namprd11.prod.outlook.com (2603:10b6:806:31e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.20; Thu, 18 Jul
 2024 12:58:51 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.7762.027; Thu, 18 Jul 2024
 12:58:51 +0000
Message-ID: <e64e48ee-cc4b-43b5-84b0-d847ec4fbf7a@intel.com>
Date: Thu, 18 Jul 2024 21:02:45 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
To: Jason Gunthorpe <jgg@nvidia.com>, Alex Williamson
	<alex.williamson@redhat.com>
CC: "Tian, Kevin" <kevin.tian@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
	<clg@redhat.com>, Vasant Hegde <vasant.hegde@amd.com>
References: <20240419103550.71b6a616.alex.williamson@redhat.com>
 <BN9PR11MB52766862E17DF94F848575248C112@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240423120139.GD194812@nvidia.com>
 <BN9PR11MB5276B3F627368E869ED828558C112@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240424001221.GF941030@nvidia.com>
 <20240424122437.24113510.alex.williamson@redhat.com>
 <20240424183626.GT941030@nvidia.com>
 <20240424141349.376bdbf9.alex.williamson@redhat.com>
 <20240426141117.GY941030@nvidia.com>
 <20240426141354.1f003b5f.alex.williamson@redhat.com>
 <20240429174442.GJ941030@nvidia.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20240429174442.GJ941030@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0023.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::19) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SA3PR11MB7582:EE_
X-MS-Office365-Filtering-Correlation-Id: fc6074a4-b9ab-4354-11f8-08dca7295ed6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YjdJcXY0SUdWTWMycHFEd0p2OUh4NXAyNWdva0pDRmdFR2JXRmE0empKRktX?=
 =?utf-8?B?WDViWERrbmxtanhFR21UcFhmQzVSOHl1SjRkWjA2azlKV1dBaFIwZXlYaHFT?=
 =?utf-8?B?TGFmYW95enFhd1VaQlJsRzFQanNtM1hTMFdYbW5VYTEvNkhFRHJnUlVkZXdv?=
 =?utf-8?B?dlAvSVZjd2hxQWg5YWNVVmoxNXlZS05aSGhEbnRrbWhJcjA5TyttMjBpUnVP?=
 =?utf-8?B?amFjazBzWC8vNUllWXIwMXBNWlEyZTJ0cm9DTk5UVGxDQjZpYUEzTlJoaERa?=
 =?utf-8?B?dVQ5YUluczFrTUlDTmhNZEpoQW5OOXF3ZFByazFNbkhVam96Qzh6YUd0bHpV?=
 =?utf-8?B?VTFxMExZcS9aNTF3cjEvUmRmVkJRQmkvUG4rOXZQNFlmTndxeUFTd21xaE01?=
 =?utf-8?B?YjFFeFpWcHo5eXl2TDB0ejBaMGJWbUpzMk5seUo1NnFuN2hxVGdXU2wyUEtK?=
 =?utf-8?B?bDJDa2ZjTFI5dUJ0REFpcS9qK0NyUWJwUVk1dDE4dnBoZFFLZXNoNnVmQ24x?=
 =?utf-8?B?YlprQjhWRUVDbTMraWZxRDdjaWR5M1R5ZjRDQTFEMzZQdWlnempCTlRjeGFX?=
 =?utf-8?B?NFpkUmFpdFRCSDBCc3UwSkVtcjR0ZU52VlRBR2tGVXg1QUxuTDREQzVicllQ?=
 =?utf-8?B?WDZPQnQzMU91Rm9VUmZkMlNJU3dVQklvdnFhVHZKMm9aUlZHUTAvU24rd0RN?=
 =?utf-8?B?czhYM2dEcFpqRkxDVVhVUVdobTFzSi94b3c2MS8vU3FZMWZDSy83ajJnNXBz?=
 =?utf-8?B?bnBTN0ZZZXJHVWZOWWZJQ05RZVVCeHV4RFhFTkdPQzdFc1IyRTBLbDhaUWMz?=
 =?utf-8?B?NXlPZEtsNWFXZ054cXdiejFJeHIxRC9acGd2RnpONmlsL0FQenp3NllYYzF5?=
 =?utf-8?B?THI4a0hrUUYrYk0weHJFbHdoN212UWFacmNWUG4vbU02NVppRmNwUWxmcnBL?=
 =?utf-8?B?Ri9pVWVDMlRCL2oxVStOOExQUlFocWZmT2habllMWGQvdXNpNXdXTzlCZExl?=
 =?utf-8?B?VGd2UlNZMWowaDVoSnBKUU5XQzNDOGNKVHdlbkd1MTlXaFZOeE56RElmS2hp?=
 =?utf-8?B?WFU0dndsVjFMTFczVENhSVJZSkZjNmpIR0NjQnFFVjNGMUp3WU1LQmdVUE5l?=
 =?utf-8?B?alBaQnRtRStoa1FSUWJEblNtbWt3Y3FyQzRUdDZqMlVkS0ZyUWwvL3NxTFNX?=
 =?utf-8?B?dmhCVVhDUzdiY2JudUlaVmYxRG9tZFVWcDZZV0dKd0loZ0pma1lCc1ZPRHpx?=
 =?utf-8?B?V1FWRmdaY0ZRU2pwRnd0U01peGlXWUwyQmVSR0ptVkZ3M1pzdWE5RTFKY2NY?=
 =?utf-8?B?K2RJUERqU0thQkVZRXNFRTlmRWpXQmNUOElCTWxad0RvMFBvc3FvNDU1VytV?=
 =?utf-8?B?dTFVVHpkQ3pIRlJGNlpEWWd0aE56Qmk1MEo3SjdWVWZadk42MklMTTBVN05u?=
 =?utf-8?B?eW8vM2VSV1JzM3psaXIyQXp6dVZkYk83K0J1ZUthQlVqY0RBdG51RHF6N05E?=
 =?utf-8?B?eXVieGVHcWxxSUU2VjNjdnlqZm03SzV0bEZXWElzMTIrODdVbXA3U0c5Vkxi?=
 =?utf-8?B?S05sMWpQZ2g1M04wSDBzdk5HbHJCTzExUDRFQnZ6QkxHN3dka0t4eURQWTRi?=
 =?utf-8?B?QWovcGtRRllyNzU0Q3J4azN3RWJjdm1hQTQvNzFxNjQxZytkN09OQjBhMmlr?=
 =?utf-8?B?dU14bTNMUEVQRXhRSzRuN1crT1UwRnJxZTI3MjhiME12YnhVUmJ6Qmx1V284?=
 =?utf-8?B?MVg3dEpTZ3pjVjZuay9PWmVXK0dYK0Q5UE53aldyajNDVUNzMlZNb2FGUVlq?=
 =?utf-8?B?c3dPa0xaMjg5RkVJREpnZz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RWx2a2s1dytrbU91bEtXbm9EencxWFgrMmk5d3QwVFl1dlFBV0x2U0V3UjVK?=
 =?utf-8?B?dEhkeTZVNVJOQkZuMkpKNC9JOTkvQTVKeURTSHhGWUp5ZVRKVXpCUCtQT1pX?=
 =?utf-8?B?NnJhUjNKdkoxckcyS1BFZFRrc1pPWjJENUhkY2d2VDA2WUZkSDM1akozSzhU?=
 =?utf-8?B?azI3S3kxeFNQN1ZST2IwVWh1bXRUeUV5VHVuSUp3b2dacTVpN2JHb0xkUEpH?=
 =?utf-8?B?cHBwU2toVXpoZ3A2NFNvNG5XZ0svdEtVcGJRTk10dTlLaU1JcWJxdUQxZHpE?=
 =?utf-8?B?WWhqUVZSWlJmQ2ZhZzd0bmt1Y09MS2V0RHZvRnRtaXFzcEd4YkoyajQ5Z3V1?=
 =?utf-8?B?elVaMG1FTENWa3dSamt0SEFwYTB5UGhIb2p2cVdXUVVYVlJ6RmVWZUI1UDJE?=
 =?utf-8?B?NmVuZityQW5TNTlJVnBCUWYwUTNSTmhHRm9HNjJsZWlxaWRhZW81NzdseHZ4?=
 =?utf-8?B?Y1dpSXloZjhZdDNXNHJVVW9scnVrVWppQVlYUUJrdmVQdDA4cWNFV01XNG9s?=
 =?utf-8?B?N3NjbDRCUHpSaFVZRittRU1xRVU5T0duN1RhNVRGOVBJaWdUVzU2ditGeCtq?=
 =?utf-8?B?dzd4ckY0aW9BTTBORWRvNG16aU1jTkovVm00cEVTN3NiNHdyaWdZZ25SdFVN?=
 =?utf-8?B?bHN4TWpjQ21vdWluekxLN25VdHZyaVhVL3ZQR1d5YVBDUHdhRGJ4VFpWaXMx?=
 =?utf-8?B?N1dTenB4bEl4SmRTRzVibHJjMlMzZE5wa2l3Z1p0MEZNYmxrcmRvamhPZk1V?=
 =?utf-8?B?UitRdmRHNWF6b1Z1WjdQYXlFclJSUG5PakFuU2o1bnBPY0ZrZ0ovVHhrYTJs?=
 =?utf-8?B?VCthWVpXb01LbDg4NUJtNGFQNk1IV01qV2VFMURuY1ZHODFRUGFTLzBHMXRZ?=
 =?utf-8?B?Q1A5UXhLQlowTU1GUUJTSzRlMnowRXFONUhxSENFRyttQXh5djhxS1JYelhU?=
 =?utf-8?B?OHlIOHYyd2lxSHU0MCt1ek1RMFZabmoyR0VRWHBOQXNPdmJJZXA0WktPNVpW?=
 =?utf-8?B?RWNzUk10bnp3aTFyWlRSdElBS2JoL2I0YkFocTZSSm4wcVN6ZXdUc0psU1Fu?=
 =?utf-8?B?UUx1RzJsVjF0cFdidU5SU1F3YTVRNnN5aHVtWUlLUThOWlJ4TzRWT01SK2do?=
 =?utf-8?B?c2c5V1lOUjJMdVdqUWU2SzJzTjIvSml1RkRaZFFURkU0ODEwRjZ4ODZncjhr?=
 =?utf-8?B?NG1vWFdwM3FtQlkvVGYvL2h1VFVFeXhrSUd3UnJEdzB6eFBsVFRBeFdKRnFx?=
 =?utf-8?B?YU5Kai9mdFlHL3JBdWZ5enc4YkdGZWZsZmdTSW9zZXJJaUxDNnpLTmVQNmor?=
 =?utf-8?B?NmQ2cDJnRk5pRldhRXlWRkRnZWRkY0lQMGFBUVlHT0x2Q0V2bDM4Z1FCZDNR?=
 =?utf-8?B?UnYwc3dpQUNicmRHcngzaEh3OXM0QlliUEwyTzVUd2N5bDJIeXg1NnpibWgz?=
 =?utf-8?B?aFRBdXJIcFo0WHQ3dW51ZU0zQ2tRbkpoZy92YUx5c1FpTy9kUjRDejZUaThT?=
 =?utf-8?B?RGk5TDk5ZkF0MnhCbTNIYjgvOXlyZGhudnRhaHJrOUhSaTVTUVhsUGxyWi9M?=
 =?utf-8?B?OC93SFBMYytOZ2FmYmNKbGJUNjRxTHRIajJRSWFOV1ZlUHBDQU5BU1ZkRHpz?=
 =?utf-8?B?UG5wZXByQThMZG9qR1U1cHV5ZFJhcEw2VklKTWxLZi9NSGNZeHYxUjhtQXZM?=
 =?utf-8?B?NjM3VG82ZkVsSFdtZ0djQTdyamdZQkRnbGxPK2xjdklsMGc3Q1AvV2o5SmVs?=
 =?utf-8?B?L21SVGhZNmpXbXhtOHAva25UQ3RHcGFZUlMwcGYwRDFKK3gzNmZDZ2pQaVJm?=
 =?utf-8?B?cXJIL1lncnVZeXNoUGkrbUxFeWxHU0xkL3BmK3lRTTd4eUhEOWNSU1IydDNI?=
 =?utf-8?B?MHlydzlIZmtpNVdoZ2JRbWNBZEEzYTRWemR0YWlwTDRSMkowTE1tRUxPaWRY?=
 =?utf-8?B?NnZPWmVJYlZ5bGhJWS9TVUh5S1NpNFdYQi9MTEREN2RRSEw2aUpoUmJsZk9Z?=
 =?utf-8?B?eld2VmJzTk83V0dJRVg1Q0VQMmw3cHNBVk4rNTZyZWZ1LzVKbkNwVTlZQkhi?=
 =?utf-8?B?NXZDZHJMVG5pTnJoeUtCMDM4VG0zQzRrVjNCQ1JKQ212QllmcUt0dlRYdVlk?=
 =?utf-8?Q?i8c60Xyrk2hSmtk03jEL8PjN1?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fc6074a4-b9ab-4354-11f8-08dca7295ed6
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2024 12:58:51.0735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7p6zSqXKE25ip6qovnw/7tStWDH5wVQTgD+XT4s+ONbw0U1bZvX3rvGw6ib9xG65uJ2BqTqJTILUmEjIqhnunw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7582
X-OriginatorOrg: intel.com

Hi Alex, Jason,

We didn't get any conclusion on the vPASID cap last time. Shall we
have more alignment on it? +Vasant as well.

On 2024/4/30 01:44, Jason Gunthorpe wrote:
> On Fri, Apr 26, 2024 at 02:13:54PM -0600, Alex Williamson wrote:
>> On Fri, 26 Apr 2024 11:11:17 -0300
>> Jason Gunthorpe <jgg@nvidia.com> wrote:
>>
>>> On Wed, Apr 24, 2024 at 02:13:49PM -0600, Alex Williamson wrote:
>>>
>>>> This is kind of an absurd example to portray as a ubiquitous problem.
>>>> Typically the config space layout is a reflection of hardware whether
>>>> the device supports migration or not.
>>>
>>> Er, all our HW has FW constructed config space. It changes with FW
>>> upgrades. We change it during the life of the product. This has to be
>>> considered..
>>
>> So as I understand it, the concern is that you have firmware that
>> supports migration, but it also openly hostile to the fundamental
>> aspects of exposing a stable device ABI in support of migration.
> 
> Well, that makes it sound rude, but yes that is part of it.
> 
> mlx5 is tremendously FW defined. The FW can only cope with migration
> in some limited cases today. Making that compatability bigger is
> ongoing work.
> 
> Config space is one of the areas that has not been addressed.
> Currently things are such that the FW won't support migration in
> combinations that have different physical config space - so it is not
> a problem.
> 
> But, in principle, it is an issue. AFAIK, the only complete solution
> is for the hypervisor to fully synthesize a stable config space.
> 
> So, if we keep this in the kernel then I'd imagine the kernel will
> need to grow some shared infrastructure to fully synthezise the config
> space - not text file based, but basically the same as what I
> described for the VMM.
> 
>>> But that won't be true if the kernel is making decisions. The config
>>> space layout depends now on the kernel driver version too.
>>
>> But in the cases where we support migration there's a device specific
>> variant driver that supports that migration.  It's the job of that
>> variant driver to not only export and import the device state, but also
>> to provide a consistent ABI to the user, which includes the config
>> space layout.
> 
> Yes, we could do that, but I'm not sure how it will work in all cases.
> 
>> I don't understand why we'd say the device programming ABI itself
>> falls within the purview of the device/variant driver, but PCI
>> config space is defined by device specific code at a higher level.
> 
> The "device programming ABI" doesn't contain any *policy*. The layout
> of the config space is like 50% policy. Especially when we start to
> talk about standards defined migration. The standards will set the
> "device programming ABI" and maybe even specify the migration
> stream. They will not, and arguably can not, specify the config space.
> 
> Config space layout is substantially policy of the instance type. Even
> little things like the vendor IDs can be meaningfully replaced in VMs.
> 
>> Regarding "if we accept that text file configuration should be
>> something the VMM supports", I'm not on board with this yet, so
>> applying it to PASID discussion seems premature.
> 
> Sure, I'm just explaining a way this could all fit together.
> 
>> We've developed variant drivers specifically to host the device specific
>> aspects of migration support.  The requirement of a consistent config
>> space layout is a problem that only exists relative to migration.
> 
> Well, I wouldn't go quite so far. Arguably even non-migritable
> instance types may want to adjust thier config space. Eg if I'm using
> a DPU and I get a NVMe/Virtio PCI function I may want to scrub out
> details from the config space to make it more general. Even without
> migration.
> 
> This already happens today in places like VDPA which completely
> replace the underlying config space in some cases.
> 
> I see it as a difference from a world of highly constrained "instance
> types" and a more ad hoc world.
> 
>> is an issue that I would have considered the responsibility of the
>> variant driver, which would likely expect a consistent interface from
>> the hardware/firmware.  Why does hostile firmware suddenly make it the
>> VMM's problem to provide a consistent ABI to the config space of the
>> device rather than the variant driver?
> 
> It is not "hostile firmware"! It accepting that a significant aspect
> of the config layout is actually policy.
> 
> Plus the standards limitations that mean we can't change the config
> space on the fly make it pretty much impossible for the device to
> acutally do anything to help here. Software must fix the config space.
> 
>> Obviously config maps are something that a VMM could do, but it also
>> seems to impose a non-trivial burden that every VMM requires an
>> implementation of a config space map and integration for each device
>> rather than simply expecting the exposed config space of the device to
>> be part of the migration ABI.
> 
> Well, the flip is true to, it is alot of burden on every variant
> device driver implement and on the kernel in general to manage config
> space policy on behalf of the VMM.
> 
> My point is if the VMM is already going to be forced to manage config
> space policy for other good reasons, are we sure we want to put a
> bunch of stuff in the kernel that sometimes won't be used?
> 
>> Also this solution specifically only addresses config space
>> compatibility without considering the more generic issue that a
>> variant driver can expose different device personas.  A versioned
>> persona and config space virtualization in the variant driver is a
>> much more flexible solution.
> 
> It is addressed, the different personas would have their own text file
> maps. The target VMM would have to load the right map. Shared common
> code across all the variant drivers.
> 
> Jason

-- 
Regards,
Yi Liu

