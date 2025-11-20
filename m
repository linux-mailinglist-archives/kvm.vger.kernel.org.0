Return-Path: <kvm+bounces-63966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 892E2C75D8A
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 19:01:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id BD8562C1B0
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:01:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02DD92F5A18;
	Thu, 20 Nov 2025 18:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fTPUj8Xe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503443396E1;
	Thu, 20 Nov 2025 18:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763661661; cv=fail; b=i+njF8tsuHPbdZN5T0ONCMbEZR1gUC/ZMQxWQkeRAHndT+AK1Nd9he3Ksoe67X3zsVWybq9ASzURV8KWjPqHjgqEyv9iZ1y2C4z4HHqiOdWCD+Xx+69Sn7u3Y0PgovOVujoIsXYCiYxjiFm7J6lAtGuvPCMDJVD1GXGISsMPYsg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763661661; c=relaxed/simple;
	bh=3wDs1KSh5zYTuaiMI0FudAuCV8NYusm2e8Brw3CItrc=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=aazEjgrAmiqmHeg/jqEGTimj4VynPi05y45VgT9YthXbOagTwt8G6U3uOTBoG43odSSQvcc1uAYtcWAf6ebIzjPjwuvN/mjw6yn5CHnYzvmblaLQwU1r6qLrhWtphPKovGaKoXcz1/ixD+eQ8MroyZyZIp8GlfXPUH9NMHBh1qA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fTPUj8Xe; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763661659; x=1795197659;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=3wDs1KSh5zYTuaiMI0FudAuCV8NYusm2e8Brw3CItrc=;
  b=fTPUj8Xe+eogzLNCfyXwLcury3bUUN3brhwXMyvIt9Ed6STvP/GGt/J9
   GE5UovmS9uSL4WlarQV51eDea8lMCZDbqPWUyKD8rfhp+a4TT0KVZWP5J
   w3pQL7o3RjgRwGqzdR6Idk7QaQa7d++uwzIyYCAk7Pvu0DB/J/cNnr5qN
   5HkTdKTJN1hbkj/pJNDaDEg0Dz+w960aPhRbCpq598n7StYYQg9LQ6j+d
   ydIBL48rB0gPDw+aPJA+N1NpLzsio0I0U74+7I96rx127JiDK2JR2LojL
   AoVIkGGhLWVagB0p8plcMij5X9gv5actVtbIF5qwLRHF1yPVapvMkTZWF
   Q==;
X-CSE-ConnectionGUID: EXJIj84iQOiATazsoILm2Q==
X-CSE-MsgGUID: PrZBF9cpS3mdBek+Gie6eg==
X-IronPort-AV: E=McAfee;i="6800,10657,11619"; a="65688554"
X-IronPort-AV: E=Sophos;i="6.20,213,1758610800"; 
   d="scan'208";a="65688554"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 10:00:59 -0800
X-CSE-ConnectionGUID: PHOedsJ8R22WSDOft54aqA==
X-CSE-MsgGUID: GvUysRXhSzqyqVu6bMqPtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,213,1758610800"; 
   d="scan'208";a="222386102"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 10:00:58 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 10:00:57 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 20 Nov 2025 10:00:57 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.6) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 10:00:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qrpf/vmrYByJs8ic7M0SR5KDlWsq7LMOeoH9N3SnnkGArrIiSkQ0WubEuosVBOR5jCIGBSExqQNMmRC+YGP/hk4IEqKQjGvCBvp/Ks+G8LGnix1Fpd17FqILyjYXL1p2sAxdSIA29j2lok0KBPs9Nmatkvoe4AkW4kTD4pkgtMrX+CoHU+3FoyY+ZBcoS4GBsIm1Fxdw5n2HdiSuZ22m2GtemWtLIbkCzlIQGhaQTbzDi91ewyCCDO79j50gGPiDL28yx63Ys8kLQC3aRC6NPa59blzLAloYmoACembPl6qL0dii2npzwRm99xZROiiAj7b8gVaJg9eRk/JgxJbDXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k7XoQL/yiUb+3YMdWX0Qq6UOklO5DSTw/YhyYQWJlIc=;
 b=NLntQZFHpeY0aZ7G68Iv7rTm3cbgA+x+XnXpwHEDwaibIn5Gg5Vd17XZCm+7NdmEaHPH+R2ucpYww+/FvnycZCty/2iN/uzLS3dnvzb0MPNWi+tG4fakHVq0NYn39hQuHLZD2wya8793fNb/Za/ca5wTuD5fjuYkn03g9Il89oS2og6jOHGbKKTjxrFVl4CJQVQQe2jptrFHjuyMu6IxpWqQI1k3UOe2OFRwO/a4DDgwLdlYCk0y2UdmAbhM10LXOmwPxVorSVyuPH6G/A91QgMpuAKi000Pyz81oD1psF907uxUn8iZ6pLjqldm2HjHqxYYqD/I+hzd4p4kCnlrKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DS0PR11MB8737.namprd11.prod.outlook.com (2603:10b6:8:1a1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Thu, 20 Nov
 2025 18:00:50 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%4]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 18:00:50 +0000
From: <dan.j.williams@intel.com>
Date: Thu, 20 Nov 2025 10:00:48 -0800
To: Dave Hansen <dave.hansen@intel.com>, Xu Yilun <yilun.xu@linux.intel.com>
CC: <linux-coco@lists.linux.dev>, <linux-pci@vger.kernel.org>,
	<chao.gao@intel.com>, <dave.jiang@intel.com>, <baolu.lu@linux.intel.com>,
	<yilun.xu@intel.com>, <zhenzhong.duan@intel.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@linux.intel.com>,
	<dan.j.williams@intel.com>, <kas@kernel.org>, <x86@kernel.org>
Message-ID: <691f575028ae4_1a375100a0@dwillia2-mobl4.notmuch>
In-Reply-To: <13e894a8-474f-465a-a13a-5d892efbfadb@intel.com>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
 <20251117022311.2443900-9-yilun.xu@linux.intel.com>
 <cfcfb160-fcd2-4a75-9639-5f7f0894d14b@intel.com>
 <aRyphEW2jpB/3Ht2@yilunxu-OptiPlex-7050>
 <62bec236-4716-4326-8342-1863ad8a3f24@intel.com>
 <aR6ws2yzwQumApb9@yilunxu-OptiPlex-7050>
 <13e894a8-474f-465a-a13a-5d892efbfadb@intel.com>
Subject: Re: [PATCH v1 08/26] x86/virt/tdx: Add tdx_enable_ext() to enable of
 TDX Module Extensions
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0286.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::21) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DS0PR11MB8737:EE_
X-MS-Office365-Filtering-Correlation-Id: bba8daab-6b1a-4470-6c0d-08de285ebd3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dnA3WUZueHA3WHBnRit5cmdFMW9RTVFCb3ZpcnpnWVpmZHJRa3YvTzY4Rjg1?=
 =?utf-8?B?NEQ3Qm1yaGFkcTBNTmtHckQyd05pcWxuSDNvbStiNTN2dkI2Vk50ejJuejhy?=
 =?utf-8?B?SEhaS3R0S2J4a292STFZSjkyUWVJZTc5UG0ycnNFUklKbkFudzMrcXhVTFM0?=
 =?utf-8?B?cHpGTkcvZ0p0M3h6Y2thTm5xZDZzRng1OUhTV09McW54emJoV1AvNks0cjRo?=
 =?utf-8?B?U3BjcGJRdzMyL2gvT0oyVXhROXFLNnFBT0NiRHBPeXp4ZlJMMjZ0aWVJL1RF?=
 =?utf-8?B?VUVOR2V1Si9XUDliUjMyUC9aWFFZT0FyMkZmZkNTeTBFQ0t0MGQyaTFsczZo?=
 =?utf-8?B?VnRHSGdqOWtjU0VBL2VKZjdWZmRjbFljeDBUKzFZa1J6VmVFQy9oKzFWQXJt?=
 =?utf-8?B?WEkvUEtqWmtJa3VJMlZzSjg5OHN4bWFCTzRPU2NKK3B3TXR5VUttcGFWbWFr?=
 =?utf-8?B?OHZmYzgwYUJiUXA1QWpObU5KZjNFS2JwTFdkVEpuY0E1ZVAvY2c0N1JTRUtL?=
 =?utf-8?B?M0pqUXA5NFNQN25sRkdyTW85K3pITTZCNVlRa25FUmQzdHd0cGVHVkc4eXF2?=
 =?utf-8?B?MFBYWXZEU0V6L2RLWGF1ZEE1VjMxYmdzNUR6K3RTcEt1S2xMUGRaNjdZWnVU?=
 =?utf-8?B?SXcxem5aYldmY3BXU3F4aUZhYjd3d0F1Y2psdm5pM1FHb1kyQUVGaldhUDdk?=
 =?utf-8?B?UXcybmR2Z1BwQlFqVjFDQW9LdUVBRWZyZGx4aHp6OU1IZmhTSGxSL3B4OU9s?=
 =?utf-8?B?WnFicjB6U2FkV21nM0g1SWNFYTNPc3prcnZOUmdvTGt6L09PU1doVmlLdEg3?=
 =?utf-8?B?V0N3c1lTQXNDT2E2N21QRnNpUWFoeG9rekFMZWdvNlFIcm5RUzYwNjNabGJ1?=
 =?utf-8?B?ZldLWTFGRDN6UXF0dUYzcTRta2Jsdzdoa0hmWUVvMnByRlRRdUJseXJvN3lX?=
 =?utf-8?B?MXZwS2VpZkFlaElwZVFRL0kvSDFvek5vS1Jab2ZEZ3pqdWJINnRCcGV4bUw5?=
 =?utf-8?B?VFBVOUJIV3RQdXdDL1YzNDRLTlVsYzROUjZNV3lCNVNFWW9sM0NSOHB6a2Vw?=
 =?utf-8?B?dXlMTzE1a1MrOU1FK0FpSHF1TE5jSlFyZzR2amVabGlzbEZQUmdGWVloZG8r?=
 =?utf-8?B?MkZiZmJyVWtjVVZ6bk5ES2pLUlJBaCtOeGtobWV1dVpEVXZtQU9TaTl6TGVZ?=
 =?utf-8?B?U2ZPVlZBSElWYWNSRWVaRzh0OHlaQUNMS2Z4cGtWZ3hBeWoxa2RVZ3AvY1dw?=
 =?utf-8?B?U2haWXNSZ3lqS3hyMndrd0RrMDJGT2F1NmdiRWJxYmlTWEs3T1U3ZWQ3a09Q?=
 =?utf-8?B?NTU3SzFZbis5elB0MFBHaGx3VllXcHlXT3hpdG5ZRVF6N1U1bzNqbGVvNkx1?=
 =?utf-8?B?emdDMnBodkkzRWxmYXE1TUd1OXVYTklxbllyenhlYjlhdG4yc25RNWxDSnlm?=
 =?utf-8?B?NEN6VjJ6cXVqVktOMlFRMjdUVS9BMlc2dTJLUS95YkZ4aENaUi9qcDQ2N0pR?=
 =?utf-8?B?dmtKajVsZ3lMdHFhbm90ajBtSUR4Zm1YdmxMaXkwb05yb2IvTUtlRUxFNzJq?=
 =?utf-8?B?T29RVitDR0p3OGRiMHZ6YXNYaE9mM0ZReEFUZmNRYndGK2EvUGV5d2E3OFVr?=
 =?utf-8?B?YjA1dVBIa3lkWm9vLzJlbUJPWmNsM0Q4RDlZbkZPNjlkNE5rNmVaNFVjUXM4?=
 =?utf-8?B?ODlkWitQZVdoS0I4V1ZEKzRuUTFkNmxxOVEwT3liYVkzODBVT3RndWtWT1h4?=
 =?utf-8?B?ZnFZM0JzYTdMdFhVOHdkdHcyUTJNSXlQZlZWeERYd2xwS3VqZS9qNDFqV2lJ?=
 =?utf-8?B?a2NPRW15dTgxekI3UG5GUEpONHlDTFlaMkZxQm12VlR2T1A3K1lobFA3Rm51?=
 =?utf-8?B?TitNME52OTBFc3BEWTZQRzRFT21uS2szdjJyR1dubWFNYTF2NGczejNGR2wy?=
 =?utf-8?B?UXd3RjNuWWttQkFLa0U4NWMzN1l2NkhSekJLc0YvQnRrcW0vWnQ3WVlLRzhS?=
 =?utf-8?B?VHBSaWJMcGF3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?THVvK3R3TzhWWG9JanEyRkh3eGdQUWVRMGtvbXlqbFFLdzVRZkc1MEUxcW9r?=
 =?utf-8?B?YVI2OUg2TGlSeU94a3lvdTZ5YzdHMDArQjRKM0xIWEZXblNUeGRmOUNobGE1?=
 =?utf-8?B?Z0xlV3o0bklVUlVpUjk4Q3VwMU9tRGNSWFpsRmN5dU9SbHZkcE9sOS9TTVFi?=
 =?utf-8?B?TTE0aXhWMHhzbW5rQ2VMUEwyckhzeVVmWDBRakVkaTlicVhzQ3YwMUtINnlX?=
 =?utf-8?B?eURtbXdFcFhib0FDazUvRU93T3pYTTVnNVpxQ0lFS2hIeU4vbmN0c3Rjb3Y3?=
 =?utf-8?B?eHFMZXpGdzZjb0d1UzRJaE1ibytJWDVOY3pLUXhjVUJGSEhEeU13d1VuKzFq?=
 =?utf-8?B?Um9iR25CUVVtbWRqTFFITFFXOEFkZVFEZytyNDdEa01QYTdsblhmOEp6UnZz?=
 =?utf-8?B?N1FKSlVLc2s0UlI1bTVVcDNMcHZjakV0d0pyUGNZblBWZHg0ZTRCM1JIeHgw?=
 =?utf-8?B?dGlMUG1ET3BEZ3dKM1RvMTM5YklOekJySHgreFJXSFdIOWhVRUNsS2VDc2t2?=
 =?utf-8?B?VFdHTkx4VVh3cEk3a0wrakpCZ2dhODRhNS9rSG1yczBmWGMyRWx2SFVLMFp6?=
 =?utf-8?B?UExicEJqMFVuZ0VPYXpjVVRaTndWMHNWTHNZOWRKcDBGS2lBRzRuM3hXYjRM?=
 =?utf-8?B?MGNMVTNjemYvdkcrL2c4cG9rcDVuaElHZFdmeWszenRmLzJ0Wk9mWGdvbHVu?=
 =?utf-8?B?dkJVYmtLeldONTRUV0d2bmV5elBuU1NBWktSUEpmcjl2VnYycG9DeWZ2dGJu?=
 =?utf-8?B?MlhRMlFjRG5qOUc2bFNsM1g2Lyt5ZGtGZzB2bVhUNGlhZzlDVlJhb2ZBVXU1?=
 =?utf-8?B?TXNudmpKeDhoVlNJNUtMbTVZK2FwT0ZGK0ZhSjgraldINnlGS1ROQlp0WHRh?=
 =?utf-8?B?aVcwRDA1SmRWd0RDQ1RBUW8rME5oRmU5VE1qRFRYMnlaUHlLUE9sb2tGRDM4?=
 =?utf-8?B?dXpLRUFLM0g4NXJKM3lyN20yblRGWDZIbDJsQWVWOXltaExZcmlCZGh5SFNq?=
 =?utf-8?B?S2xTdytaMzVNWm4vRFc5SUZiMEtWTVpuS01XUlV0M3Q5M0JXZFZ3cERic2JQ?=
 =?utf-8?B?bHNkajAwcHdPSzJJT3FKajIxWkZkbXNSYlNBOXh4K1gxaVJtT2ZwdXg4bWE1?=
 =?utf-8?B?Ull3YmZlLzRDOHB1azg3Y3N4V0VSTVBVR2lpMGJOTThlUHZFM1ZKZzB6UDhj?=
 =?utf-8?B?OGtLWk1ubE5CSVN4Yk0rUkRsS3l3cEhPSXlwOXViMlBNaHdjZnJ4ems1Mmds?=
 =?utf-8?B?OS9xRWRaRWdOMjI0QTB0UkkyaVlDZTcrS3ZaWGRHZUZEVms4M2NybW1YQWVE?=
 =?utf-8?B?UDIyZlhDSUhJYlBHZm5EZ096M1R5QTNTNzJua1pBOW5UbGw1ZUVpL3lZWUov?=
 =?utf-8?B?ZGZPZnBOZ3lpVHVDZm8zSlhiSS9YTjNjMVY4QWg1eUFsSnloYXJpZnM0ZHFZ?=
 =?utf-8?B?b0dPU3VwaWc1dzgxaWxhWTVjUUVibkJ0MFhQT3ZMRnU3WlJ0dWc4TU8vWUhZ?=
 =?utf-8?B?Uy9DZ0lHUHppcUpEM0RDUHM3cEIvQmVRN3RkUXJ2cW9PK0dIUHAwdEhFdHla?=
 =?utf-8?B?S0RmVGc3dzB4YmhXbFVKdGZCSDhHNldKRkVHaWlmeVVYTERSY2hYV1R6NDNO?=
 =?utf-8?B?dFVJWlJPS29zU0h4QmVRZTVReE1TQTRkZEc1VFdvbzlXak94dy9FMExUQU9w?=
 =?utf-8?B?MzRxMVVJaEhDbERMWnduYktjdEdFaXFqMTZnL1NnOVNCT3JPcUl5SHN3NHZB?=
 =?utf-8?B?TlZ2M0l4ZG5UZnU1MGI5ZXpDM3Joa1Q2Vy9HclIxVU5HOHlxVEYzcjE2V1ZV?=
 =?utf-8?B?a2l1Vk8yd2M5eU8vbXR3ZXJ6eW0yNVFScDNNQzFyVDZ1a0NmKytNbTNha2VW?=
 =?utf-8?B?ekdJNWZ4Uzc0b3NxOWFScVYvYnNaaGU2OVFOTHFSWEo2MEpjK0grMDRVMDQz?=
 =?utf-8?B?N0huZnVuZllubFE2U1hoWW5ZYm9mbkJpd2ZJQ2Z5K1FRQmlGdmZSZVF5dzdG?=
 =?utf-8?B?TUhxak0wQmw4YUlaVGM0UDMzSUVjTE5oTHlUWW1NdUhObHlzU3gvVk1OWDNV?=
 =?utf-8?B?MWxCdjIvV2IxL1BpRW5lanVtbmZiUU5KMVFZK0hlSzVpS1pXZkl6c1laaHln?=
 =?utf-8?B?TWlGeXVXTUR6SHk1WUdMLzFmYlFJQWZ1V2hVSXp6Wk50aEQ2RnBMaS9qSStH?=
 =?utf-8?B?M0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bba8daab-6b1a-4470-6c0d-08de285ebd3b
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 18:00:50.1668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4BOX1h+B+pfFyVy1fPo2cRQQAIfChCZUwsncLkdOau2vUO1SMdFOHmv+alwRGoblE49bOuIJfOZ51Rt5xgkHKH64w5Na8YKwkAhhTpVhMYI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8737
X-OriginatorOrg: intel.com

Dave Hansen wrote:
[..]
> Third, are you saying that the original code structure is somehow
> connected to __free()? I thought that all of these were logically
> equivalent:
> 
> 	void *foo __free(foofree) = alloc_foo();
> 
> 	void *foo __free(foofree) = NULL:
> 	foo = alloc_foo();
> 
> 	void *foo __free(foofree) = NULL;
> 	populate_foo(&foo);
> 
> Is there something special about doing the variable assignment at the
> variable declaration spot?

On this topic I argue in cleanup.h that the:

   void *foo __free(foofree) = alloc_foo();

...form, should be preferred. The NULL initialization form potentially
destroys the first-in-last-out ordering of cleanup callbacks.

Linus mentions here [1] though that it is not a hard and fast rule. That
was part of the rationale for documenting the preference in cleanup.h,
but not in coding-style, nor in checkpatch.pl [2].

[1]: http://lore.kernel.org/CAHk-=whPZoi03ZwphxiW6cuWPtC3nyKYS8_BThgztCdgPWP1WA@mail.gmail.com
[2]: http://lore.kernel.org/769268a5035b5a711a375591c25d48d077b46faa.camel@perches.com

