Return-Path: <kvm+bounces-57290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 52B56B52C8B
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 11:03:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 036431730DA
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 09:03:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 007522E7BA5;
	Thu, 11 Sep 2025 09:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b78wSDzE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2B02D4807;
	Thu, 11 Sep 2025 09:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757581392; cv=fail; b=tSZm/dkaOgyKPrMOPG39tgR/phEDa5UY6XVXE9WWfwCwwLo5uKxY5RNcpT9a92JVqEryoWGoVRPu0CbsDQCzKPafhRHzz5jdPYbKrJ93rmjIvrBeGGoDUoXzgQWgEl/RWCp5zQNG9B0jCZWh5ZebeVlcFght8D9wz9v4nVjBCXw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757581392; c=relaxed/simple;
	bh=IAaerO+fnvlzni+pY5u5JfXmTeb2nrHiMqHPslt/B/Y=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Vb8QpqSrDycQ6GFttvGY15fpcektWC+GHTyECpHBmpOUARlaINbxHm1R9X5Hego5KKYuVl8Up6KG6teTbdQv5XphEQv5mAysgD/8l3OiQSv9kU7cp+VC2rxmAgSx2o3GCOZmo66JucMJuDO1K7PMDfq/ls0gc41RZZxMmH9EV6M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b78wSDzE; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757581390; x=1789117390;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=IAaerO+fnvlzni+pY5u5JfXmTeb2nrHiMqHPslt/B/Y=;
  b=b78wSDzEOkYMkPY4fB26vwjFtqwAB1i+R6og0VtZxJ+KrgfJczra3GJn
   SoTUG8ZNN68Scw04xG8s4/kN03JwZPWqqBCxkhEU5+yciKPwLQhuNYTY3
   GE5e5qyKbnbNxtGzYqE3eP5Knj4rtB4pqjg5Hf6kZgt1pFCGKv1HScJNX
   kHfnkseHUDgLJbjPaXIlyLcnSpSdMKIXQiw2R8DlW7iaRb4KxNr5ADmrM
   rKgKQiAnmf5oKrRaT+G1QRm8BG8GyaPYnLEwF+l8mN34LOgi6JBVO4T73
   h0arlgGA0wbdUOpv8HKnMjHY0Js+H9aDgWQvNN19A/y4k4hxQfD9ub5C8
   g==;
X-CSE-ConnectionGUID: zA47Q+RiS/SOC9pVkHMyAQ==
X-CSE-MsgGUID: 8XcIaPZwS92Q0VxusjRXeg==
X-IronPort-AV: E=McAfee;i="6800,10657,11549"; a="47478659"
X-IronPort-AV: E=Sophos;i="6.18,256,1751266800"; 
   d="scan'208";a="47478659"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2025 02:03:09 -0700
X-CSE-ConnectionGUID: O9pwmopvT3qRYns4uwKq9w==
X-CSE-MsgGUID: H4uZ9U9VR2yCb6lac1I8Pw==
X-ExtLoop1: 1
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2025 02:03:09 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 11 Sep 2025 02:03:08 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 11 Sep 2025 02:03:08 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.63) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 11 Sep 2025 02:03:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KhixSsQjprE+9JljWtfeQVC9Vj4GJ2WEywridk/sTzStXT0SgGkXnJkuvcpdJh1zUHj9gKutBe+0yJCa+hHNa3OSsGOJfmOqwDkKMceHOPYLFxoRiyOelmjkhpunOzZ2sHgwyLYJYsC7p2n5Xvm3o282h/eCEX3kbBNBxs2SjlplUtuHr6XpMpx+vQG26FbGWO+HAedXMi6ZQWI82wO5IusCOzjAY4QUcNvkEjTT7rAiWinrY/WsAPPgIKw3vLF80Oap4xkYoH5qfqGSfk0WIFOGYmrL/ib/+AqmfL02wwiNfv7p6iKeMMzzoB5GY5tRdnJxK60X2ifyOeUhVGNIqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fTjvWoks3jSngqFsxK0KUrFksXe9r4oP6CPctCskCxc=;
 b=P5G9wHLAiC0RgLp5Q8m18/zwHfX13B8qGx0C/UZXCmnlDDi5yxzoA+ywgPVy3zC7KTfAwXji5Nj3F+BFb/cq+wJhW7S80ee4Z3g7U5tTvQkaQU3c6r9o4hzMGnDbLmhvhRFxa+iHogYsRn+B29oLZtku447wRRA9dI5EJNN6MSLr5eGV7RHHe/3/qwAtvg33jWqiTZgMo7CJiaigAA7DSaIM2O+kh2+/CElfZX+Zz/XvH3dKoQUO41GSQ6AMUAq+t80taLSWiohYExilRCSuL/kM2CbzOoupms5MxoAdWdKqG8iZKVCYcvo1STKSTMlB6MJKXl5Qst3isNycjY7uzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH3PPFAB4263235.namprd11.prod.outlook.com (2603:10b6:518:1::d41) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 09:03:06 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 09:03:06 +0000
Date: Thu, 11 Sep 2025 17:02:51 +0800
From: Chao Gao <chao.gao@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <acme@redhat.com>,
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <hpa@zytor.com>,
	<john.allen@amd.com>, <mingo@kernel.org>, <mingo@redhat.com>,
	<minipli@grsecurity.net>, <mlevitsk@redhat.com>, <namhyung@kernel.org>,
	<pbonzini@redhat.com>, <prsampat@amd.com>, <rick.p.edgecombe@intel.com>,
	<seanjc@google.com>, <shuah@kernel.org>, <tglx@linutronix.de>,
	<weijiang.yang@intel.com>, <x86@kernel.org>, <xin@zytor.com>
Subject: Re: [PATCH v14 11/22] KVM: VMX: Emulate read and write to CET MSRs
Message-ID: <aMKQO8+XwWF5UOSR@intel.com>
References: <20250909093953.202028-1-chao.gao@intel.com>
 <20250909093953.202028-12-chao.gao@intel.com>
 <bd2999b5-f2fc-4d86-a5c8-0d1af4d51bc0@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <bd2999b5-f2fc-4d86-a5c8-0d1af4d51bc0@intel.com>
X-ClientProxiedBy: SG2PR02CA0060.apcprd02.prod.outlook.com
 (2603:1096:4:54::24) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH3PPFAB4263235:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a37c9d8-a76f-4c8b-668a-08ddf1120539
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?k2CD1UCs2AvccvcZn9qRXMuRdFsOvAMeFG0W17aIeBiXSvHL7OMSVe5nEgvU?=
 =?us-ascii?Q?eI/oUtBf1Hv6PXTH/USq6QdKP9Rtjv0AO09bVO4e7M1cIGCZOeWGp/3gmSXD?=
 =?us-ascii?Q?7Hx91shIw867Mj0JRa5Dc6GslHigNxGOHUgQ3UtsvD6L8d4O9GsFqr2hrIK8?=
 =?us-ascii?Q?tw5YdR0vxxakg79TOLURAicCFJ+yipvRDxZkVKNRWR99xZWrAvR6MkwPsSlO?=
 =?us-ascii?Q?yfiXUaYuuBBSY940no8aXufnV+ahqZ+8NmN/JsnyQ5ZAdrEbM3tx5r+ibwUC?=
 =?us-ascii?Q?hVSC880ott7NU12zg9HWTQXPlVKWdAY6hPvFWUsZCtCxyycKxvV/1uLHQo5E?=
 =?us-ascii?Q?3udm/+9DCRFbl5WEwziUjNvGZxUwjRg7F9ZEWTMAXogrTp3f9STTMTTrUrQ5?=
 =?us-ascii?Q?SDQ1ePVSpVsZLIotliH650p4mk8Z3TH8sMnT4dZkO3kabNqYWXe0+RycEnNo?=
 =?us-ascii?Q?Bkd3DloTwQsfVJ6UxW+oU+D9YuJ/S3DEYacwdc6iE3qhvwRMTXWPbdOGILID?=
 =?us-ascii?Q?6hlQPK08JCQMquzoJiU22S87Br2oqcrHNKOc8Em4nyT6g1yRicpwgIbSxCkd?=
 =?us-ascii?Q?L4WkPrHf0Q6UxJ3trOFu7w4Y8Ofq2RFpZkBN/VM0mR92NYweOafLRVlI+v2i?=
 =?us-ascii?Q?UZaC9XfNwWdkGfxoh9XM+5JipNssYzUMKBVVx4h7vKbFdQrS3WEadD2fJvZF?=
 =?us-ascii?Q?ty+It+8nmFf70lpuvforB9G45lzWviXh3SPwWfQwST+tAqIhJUKi1kKY4Bgr?=
 =?us-ascii?Q?Dip9rzO1A7kjEe5hTf5fkd9cSXuOlzf+SjVi5N8yHfVHjPabgU5syr3oeWbv?=
 =?us-ascii?Q?9dbFKiKmdeMkg/j+8rxckqwBTk2zQJiqceCNAjw70ug/KEUz04/C6DAcrxh+?=
 =?us-ascii?Q?EIvjz4dYqJ9FFg7F85rs2noGq9FU3p9vZphSdG5szU4QT/fTkBttulmd41Nz?=
 =?us-ascii?Q?oiOYkWb5Gf4oUYKaXvKDmGcWKLmeX5oKyzWSjNXSzPgbNqaDP305lgaFTNod?=
 =?us-ascii?Q?92ZQBAglxlKaDo3p5nTP2+p3dibXi1JSVhSlB5ojksV+28qsc5Q86fXp0Fld?=
 =?us-ascii?Q?Xl0HeML2y5fEXo2rS+TIfsg177xRMkS5V3OUMb5AQohdrQ8Ihr5+kGMT14IJ?=
 =?us-ascii?Q?ix7qbQ2FKILlKnFsrYxNACNLeGw+hYECj2az/td9w+wZOVnxeV4WPb3Lfa0x?=
 =?us-ascii?Q?RQH/5QV7qH3cym5Rpl8sOy2bvYXQ2RmHzBSN0Ex5lfvxrkHTy8GsxfE/GojC?=
 =?us-ascii?Q?j/UUzEen51u3YcTEc06LxBeIedrY1UzmtD5+14JAVOo9IN5+XqgObvwHV23+?=
 =?us-ascii?Q?dZTgeH3Dai7kW8LZ2vZ5YzvCUGihzDOw8hKieHLpwIcPYDdETekR/hzcYPSh?=
 =?us-ascii?Q?yUEdnkfp2XGjlv/KrE6Q3yPCmL8ozNiuhARnu168OcGCeWaw8N+ACoM2KU4B?=
 =?us-ascii?Q?fgYrPcCj/Z0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kdt0sosq9QGFHvYcroLJBIxR+2b55sI4s3es+Pnvj6cHxVFsCUHwGztfXCJ3?=
 =?us-ascii?Q?Yjl9DsuUKaqmXhXzoeJThsGeHi9eeeuKG/DIvaO2aOyoqGwOLqd63B8l1t5R?=
 =?us-ascii?Q?qZkEIPgO1u/Htdq0OgiPUKUuDuXafJjKWB5V25AgU0XcvMxosLHprk2JWEZD?=
 =?us-ascii?Q?9xrwEm1Goo7RpiD9P3FpacK+/BQ2CTSiD8h09idmAoPbm2DHdadNeGa0+mOX?=
 =?us-ascii?Q?CZmCHKGUJwvM56hfJYjgcOMexX+hqoMSgoQ6KdBn1IshuRI3541ux5ogskrE?=
 =?us-ascii?Q?pMM7wW/cBpl7sq0m6KyykvjY6icsF2TzQpRkj1JsD+Z9FQVhD7stcxRBzmEB?=
 =?us-ascii?Q?YKJRbCWLgQGPcV7kZSvmlZYqCn2b4g8pqg+/hDYDkc5+STUqp5Q/AkqDE+iu?=
 =?us-ascii?Q?GtgoLA+uXwKtB1qInuluVEPMjnhCbSH65hM28M7nR5t+KR3+dgzSTZG2KiIC?=
 =?us-ascii?Q?X6Y1rGdUB+1pfo0Q+NUaqnHRJJiPe9NpfMGFsiN3UwCMA05KlatslZLTtcVi?=
 =?us-ascii?Q?pKp3tdE7T8Yov1e8s2EYe4+RNvGKB2HhSNS6Q+zpbEwxzhGPrQ18gRrS4aUR?=
 =?us-ascii?Q?bbfLv+WdjWuzQ3zbYOhCJtz9e76+FtVnbgtZfGvwAH6ZqL0N+b5vbQf09eug?=
 =?us-ascii?Q?8Brxq4kPUfmniR03R832x8HKzJEb0PKTVsf7iO9w2ahHjlGJHXbLaDfAsMMC?=
 =?us-ascii?Q?Q4zMKKBiSqhJuhNdnk9peyYvumKIb/bkyYtvQKtSq0je2vPKm972A6El0S2f?=
 =?us-ascii?Q?afhT4y7qo1RIbhdhubDEboQsv+yaETeGRKX9t5GjR5PDvFfpzPxr/gKmSylh?=
 =?us-ascii?Q?aic6pRZd1fLp1xuKf4zOYIi2hwXlJ6d2i6AWiU2F3NxRX07LlDUm1yZcVfud?=
 =?us-ascii?Q?vAc7+HjZnSRFnNfdOb8p0tOU3obxE2sE43GlTG/Z1Uy1u01KZS/MzNvAcWNc?=
 =?us-ascii?Q?oVKygDELlOL/OhXK9j3PvXTnZ3HUIPkkqa/7E0BNlRoYSb/w89XHPHW+t3EV?=
 =?us-ascii?Q?BO9Ki+OYxzxHp0c9nPT/WSLPWlA7fjNEHMbhM5zPqPkVeqUoDIWkI/7Y6orp?=
 =?us-ascii?Q?myFH+nzDP0u9twYJXgPDZ2/0DOGaW6rqOCYcPLyFag6lrtdz5OxNhAhpyE1y?=
 =?us-ascii?Q?BvzoWaWzk5gAxG15VUwfWFRA/owpw6rnn3BtqMirFYEgJuBjL6Gb24svcpR3?=
 =?us-ascii?Q?Czjr8Zlf0c3obI98oejg6yYizD3EQC+S1DVsoAGyC9AXFwXYdxgRVIoFA+MY?=
 =?us-ascii?Q?3CX0tTV+VhfCHFSNmtFCXxh5th5D0EsU3EJ0Vznh9H4UQccZv6yngfH1Jfr6?=
 =?us-ascii?Q?AoMRRogfgN2h5Ls2kUMDw/CeY+UvR0upDnjUblJxPbTtrVHPN6N/w3+a/mul?=
 =?us-ascii?Q?URnKVmAp6YH6tkp+D4epfqeNoDCwp2vz0QhawhsSyqPnn7le8BqoeewLwDyv?=
 =?us-ascii?Q?i/UPs2UF8c3FJ9QP6bN/AxTqXxVmLIq2z+b6RjUVlkDVAa63DK/DVVr4fE/M?=
 =?us-ascii?Q?ifQR5YfcG4qEhyxrXwYkm9A72MnnQAcS0YycN+8V49+Mg8uBPJJJkT9rjqVs?=
 =?us-ascii?Q?5wOHbH/NMbDFU04syzXdsE8iVL0R2/StncQUcbKd?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a37c9d8-a76f-4c8b-668a-08ddf1120539
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 09:03:05.8891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AQtq/zflFk82roGjrL4Yz19L/6nqoK60dx6Q+zRmfaJKffKI0QxyEenkvOIqHQKkZBVlzm1tMsOwbApLtWLCiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFAB4263235
X-OriginatorOrg: intel.com

On Thu, Sep 11, 2025 at 04:05:23PM +0800, Xiaoyao Li wrote:
>On 9/9/2025 5:39 PM, Chao Gao wrote:
>> From: Yang Weijiang <weijiang.yang@intel.com>
>> 
>> Add emulation interface for CET MSR access. The emulation code is split
>> into common part and vendor specific part. The former does common checks
>> for MSRs, e.g., accessibility, data validity etc., then passes operation
>> to either XSAVE-managed MSRs via the helpers or CET VMCS fields.
>
>I planed to continue the review after Sean posts v15 as he promised.
>But I want to raise my question regarding it sooner so I just ask it on v14.
>
>Do we expect to put the accessibility and data validity check always in
>__kvm_{s,g}_msr(), when the handling cannot be put in kvm_{g,s}et_common()
>only? i.e., there will be 3 case:

For checks that are shared between VMX/SVM, I think yes and there is no other
sensible choice to me; other options just cause code duplication. For checks
that are not common, we have to put them into vendor code.

>
>- All the handling in kvm_{g,s}et_common(), when the MSR emulation is common
>to vmx and svm.
>
>- generic accessibility and data validity check in __kvm_{g,s}et_msr() and
>vendor specific handling in {vmx,svm}_{g,s}et_msr()
>
>- generic accessibility and data validity check in __kvm_{g,s}et_msr() ,
>vendor specific handling in {vmx,svm}_{g,s}et_msr() and other generic
>handling in kvm_{g,s}et_common()

