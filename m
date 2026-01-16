Return-Path: <kvm+bounces-68332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id EB302D335AC
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 16:59:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B3D0430209BD
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 15:56:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 067E733FE11;
	Fri, 16 Jan 2026 15:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g6Es71Nd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B50733DEF3;
	Fri, 16 Jan 2026 15:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768578998; cv=fail; b=vFh76ZiJ0RauBbPb9wswdkub39AY3lKUPLZykiUvvj9tPKq2jrumHrk5WDykIteGssRTzqOU6bVJSSLwF5eCJTDISjoVpWpiIqp8Fh7Cga1gpVgR9VkzCJh2X/DbV9NKwJz+7nkOv0CQ50JmD4ONwnYdyz5Ja0eFQ0bnF7jffr8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768578998; c=relaxed/simple;
	bh=gdzxWNH1d/S7moiZ5tNrZNylsyhY6yLcqTudihMI+bI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gOc1Ium/GKAQfl60mW2/KVXH6s7mCP6V2efcPU6Kx1XhJR8uSNecmBuUK36cmJa9p/1hsRM3smYA6pgMgkAa73cMtBswIQDsUYmWvVcHNDvBF+aVwoEkq24rJzLENCJpE29PwhXf9Gukc4tuf0XhILShNa5Rhv505qKMkvdfdFc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g6Es71Nd; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768578992; x=1800114992;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=gdzxWNH1d/S7moiZ5tNrZNylsyhY6yLcqTudihMI+bI=;
  b=g6Es71NdLjMGI3E0Ng/bDQ6lgb0bYrOZw+nZa/ydUI1WDAqPvH9VFq9f
   MV+BU9QIybp83RM0xJSGHfVCJg2qeKSXSok9OE6jTPLCvr662Q6HCyLOn
   MikN5Q0/h4rQ7I8x8VwUR/W+fA+ZVicfCUNtp/mBugbIEzIiLuKB91qCh
   uaFeyv756Fsu/f5//y/pMR7SI4v4mSYGJLAxWFW4t8KOc4crPam0qNA8f
   zQR7vCrea2f24Ow6uMO2minDuGKFe71+pkIGWUtGY+uq/O0rggCuH6amQ
   dwcSy0siIjf5gVw+GBc0aA80hxWUai5y36V+4Kcn01Ph/R49uaEd4nRAI
   g==;
X-CSE-ConnectionGUID: 1EDloz5ASqKffBbq9Z+MFQ==
X-CSE-MsgGUID: gbh7SOD/R6SKfEGuRPG2JA==
X-IronPort-AV: E=McAfee;i="6800,10657,11673"; a="57446988"
X-IronPort-AV: E=Sophos;i="6.21,231,1763452800"; 
   d="scan'208";a="57446988"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 07:56:28 -0800
X-CSE-ConnectionGUID: 0Hp2My0rRruw14ZrXEhadg==
X-CSE-MsgGUID: y4s7XSafQ4y/NdWo4YLlNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,231,1763452800"; 
   d="scan'208";a="210290703"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 07:56:28 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 16 Jan 2026 07:56:27 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 16 Jan 2026 07:56:27 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.47) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 16 Jan 2026 07:56:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SIAr4yZMOY8Duf48YCBQOlCH7K4X0yOrpeI6Q79YNA0Sm13Gg3UdR+T1V3CKV7kDs5snKiBJoIcHSXb/lGJ/0OvSof616I6NN2ct0eT6KcOCz/2B+F4bcMlHGltEoHMYzZ+GMZSNzyP4gvp+TN7S21LIsQBM/HIaOnGa0eKvRQ+k2EB9Flw3PAtKSeSaWOcY9NorBZhT8vrthj1wXEYKyF/sofvjBsoUcJAkIfak9odl9b3v3Hzpxt7ZUB+UR9SwQ1yKdZMRbmaockKgV+zh3+xJi6JMd7vGu/gP0n4+XCTgw6xI7JhN/KuBY2m+5EhQMaTQR8F67M1aPoUDMWcidg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qNkHhzuc8cRoaLjyr5zAaFc76S8MWBQdqHszWV4PCZ8=;
 b=DBaCLwJLSv87HsIo7SAAgVG2iGB5Sdkaj2vkGZtVcXeeC04TZEOPyk47aXHTdF0okXdctG2u7t0ATgpdyVvZVwbp6QUCIYemkt1fKNVmrxl9Vr0BpgtQPI2xAU1XEI6KqGiGYjecI/iKW8MFOMAORWP+OvJK6N0biNLuj32BtlD59l6VkuKVGiNUl89rjow+fyf5qgRVVySU7/RBMwb9qhBky6R273wPl3nunLwTgOgXiNEWlzxLqoEXw0D0ZH5DGjvvLw/NnUmhBG2KtoBzeq8NtEqhDRTXQZCC7wJ6msX/ufPzv8hYl6yO+X6Iw7Erl2cq6w6gRL6820Le2SJAMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL0PR11MB3282.namprd11.prod.outlook.com (2603:10b6:208:6a::32)
 by PH0PR11MB7634.namprd11.prod.outlook.com (2603:10b6:510:28d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Fri, 16 Jan
 2026 15:56:23 +0000
Received: from BL0PR11MB3282.namprd11.prod.outlook.com
 ([fe80::5050:537c:f8b:6a19]) by BL0PR11MB3282.namprd11.prod.outlook.com
 ([fe80::5050:537c:f8b:6a19%4]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 15:56:23 +0000
Date: Fri, 16 Jan 2026 16:56:02 +0100
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Maciej Wieczor-Retman
	<m.wieczorretman@pm.me>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, Alexander Potapenko <glider@google.com>,
	<linux-kernel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, kvm
	<kvm@vger.kernel.org>
Subject: Re: [PATCH v8 09/14] x86/mm: LAM compatible non-canonical definition
Message-ID: <aWpb1AnRHW2yupZp@wieczorr-mobl1.localdomain>
References: <cover.1768233085.git.m.wieczorretman@pm.me>
 <0347c61eccf739ad15ec62600f009c212d52e761.1768233085.git.m.wieczorretman@pm.me>
 <2968b97c-5d71-4c05-9013-f275bdbd9cd5@gmail.com>
 <19zLzHKb9uDih-eLthvMnb-TF7WvD5Dk7shNZvYqyzl7wAsyS6s_fXuZG7pMOR4XfouH8Tb1MT7LqHvV5RXQLw==@protonmail.internalid>
 <aWpRwJqjzBxOaRwi@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aWpRwJqjzBxOaRwi@google.com>
X-ClientProxiedBy: DU7P189CA0002.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:552::7) To BL0PR11MB3282.namprd11.prod.outlook.com
 (2603:10b6:208:6a::32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR11MB3282:EE_|PH0PR11MB7634:EE_
X-MS-Office365-Filtering-Correlation-Id: 5476f3ab-77e3-4cb6-bff6-08de5517cc56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dWpVOHhxUEQ5eXhmS3JYaDlqTVl5OUdkNy9sclZ0dGI2bXU5eXYzN2grRGlB?=
 =?utf-8?B?VjFxQzdYQ05ib3RmSUFTZkhvWEY3TXlRSXhjem12VU1KdXN5RENHU1cyRXJL?=
 =?utf-8?B?M0FZaytGQ1lrb2NCcGxWalNtM2p5c3BhbCsxVHVzaFZsWElDWnBTZDlSbWkw?=
 =?utf-8?B?N0J0WDR4MjlRQ0lDaW5LQkpNNStsVENhV3lxeUcxRXFTUG9ZQmk2WFZXSTRr?=
 =?utf-8?B?VTJ0NzdualdFTTEydGtYaTQwbzY1TktUdGptc3d2SUhEb0pwaGtHNE50R0Qz?=
 =?utf-8?B?VERkNCtxaTFmbkZnQ0wvWEZRUWZlT0hlNGU5WDlYTGNHazVISWROcFVrSjlr?=
 =?utf-8?B?U3IzNWlCd3FMRDdrNnFYM0ZIdVNYdld4eVEwVnJyVmJ0NS9oTEZsNFZteEZI?=
 =?utf-8?B?bm4vRnMva3dia2xRV3Bkd3k1N1U5T0JXRHlOK3d6Z1lkaU5JaE5IK3FDV1M5?=
 =?utf-8?B?cHl2cXIxZHBNVjFlMGRHZVNqblZreVRHZUpQRWF0dk1LUUNGYlVCQjVDdGMr?=
 =?utf-8?B?SU83aC9DWE10OVZiOW1hZW9NTkUwRzcrTEtPZllHNmZpU2N4S2lvVFZ0T2ZF?=
 =?utf-8?B?d1BxQ256SUw1RmxvN3FUdHhMOFpKVk40T2llVnpQWFFJQ1FxSllmN1VJUHNv?=
 =?utf-8?B?SHEyUG1HaHdQU3dhT0xLTGFnbzJZQWhnUHJCSm5lVldMS2Jib21vQ1BFWUpP?=
 =?utf-8?B?dWhTdnZ3bldON2REWHQ3M3grYzU3QnphUDhTTHp0RExyak9DVXU3aEtycFdo?=
 =?utf-8?B?Wk9rQld6bWY3dmNhUS9BRjNxSThEZVdpamdhQkozVytEYk4ydzgyOTJVT2dy?=
 =?utf-8?B?WEZXbFpwVFAxeGpDR2dzN2EwMmVrZlRtUjFvVm1LZk1sei9FYll5c2U5SHRp?=
 =?utf-8?B?WTA1ZVlzekxQbk9GMjdoQmFVendmVjBqSFRTeUZIMFRHK0hNemIrRkJLaXFq?=
 =?utf-8?B?WVlGWXZPalV4aGl3N3hFakFpcjJIQURSWnEvNDZ0ZUk5enlFRy90VTNnUkRU?=
 =?utf-8?B?L1BmblRubzl5Q21yVmRCUWtVRjhONTYxZGRaQk1DVUtwTjl6amc2bE0rVlQr?=
 =?utf-8?B?VWw1RnJQNTJXb3lydzUwTzZBVVd2dWV2NkpHd0k3THJrNjJBTXJ3UWVYclUx?=
 =?utf-8?B?aUVFUEpyNlorMFVmQi9LZXhKVkZpT2hLZnN2alEzVEZ1U0R2WklIZVNTbWpq?=
 =?utf-8?B?Wm8yM1NrOUo5ZFpCMWRnVzRLNDNUVXdSN2RzeHR0NlFCNmVRY1NYcllvS2hG?=
 =?utf-8?B?MU9xVENNUFFMVExib2VVd3lFWWFTZ2Vkd2l1VFlSQWNsR3grWGxKZUZWRUht?=
 =?utf-8?B?RzZLWWZEdWhsKzNCcmYydklnaFIrQVFSekRyYlJnZVJhbzQ5Wm8vdmhxZHNk?=
 =?utf-8?B?clgvWFVOLzIxSktzVTlmd3RhblVUd1AzcmduQXZvQVVQa3BjOUdGTERiT1JC?=
 =?utf-8?B?M2lBeXZmODZMaW5TVlNJeGNscnBJMkhVWUZIVlNCZm93dCtNdWNtSStzQVBw?=
 =?utf-8?B?ZlBKODlKaGViZWZZbTdPZjRmV2FNdmJvQkV1OVdEamdNbXY4Z3h0MGU3bndz?=
 =?utf-8?B?M0RnMHJNM1hzVGpDbE5qckd3RzF1T2dpanRtdHhsc1BJSlFDY1o0M1dOSXc2?=
 =?utf-8?B?cVZoaGlyU1JzZjk1SE4rcmtDRUJsVUdCZ0tFWkNxV2NDdTA2ZS9UbHdWZVI4?=
 =?utf-8?B?UW9mY0lXZHdUUk1WUDBUbnJ3SmZCUTdlb2VtOWpQSUFDL0FBQTVGVDFIdkI2?=
 =?utf-8?B?U1BXOXdwK1BKNjVDanpnbDlnbjVPUGloeEIwbGRuZDhoT09DMmNISWlLYk9G?=
 =?utf-8?B?RVRUNDRSeVlnYU5QZ0RaOENjTEgyVmlxaXczbjVnSW13ZnhTUUExT05yblpD?=
 =?utf-8?B?ZFp0WVdOekF2dDFBeERvRGlIRkZic3M4ZENjVVZLVGE2c0x4Ym5CcmFZVXNV?=
 =?utf-8?B?WXV0M0Jmc3N0MHdaTjBiUEo0d0htaGd3aTF1bGVYdmc3VVRqOFhjeGtnWjl2?=
 =?utf-8?B?cm51WU92a1JnRGVvRS9LMVZrODIzL1F2blRXU3JkNFA3VzJTUitVQmE0b3ZG?=
 =?utf-8?B?SE9EOGp1c0JIUFY4cXZLSzBqdGtlbm1odEdOK2F4NEVkT3E5WWVLTnJydDZQ?=
 =?utf-8?Q?eo7A=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3282.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TXVRTWdiK2hNRkhsQWVCTTVtTStzM05oSmxkb0NFNkx5dFJMdzJ2aFNkZXVN?=
 =?utf-8?B?MXlCNlJHUG94SnJnVlJCd1FUUWpTUTREQ01vN0Uxemt2Nmw3bTJOL29ORzBT?=
 =?utf-8?B?ZjRQUWNSZzJuT2REaVVyWkxTUWdTa2tiTUF6NXRZRSthb1JHU0RWTGVaNmdS?=
 =?utf-8?B?eEM3N040SFovVzdFeXk3OUZ0SGJPclRTMHZlZTdIeGZqRUF3Y0ZWSEpLL09v?=
 =?utf-8?B?alNDejdRRlI4cktMeXExS0xnc01iaDZ2N0xCRkxBdTJHVWtac050RnNjdkhs?=
 =?utf-8?B?bTJQSlY0NTN0RGRROXBTTUVUaGY3Smc5ejh5SXdTc04zNC8vOGFKTDA5UUd2?=
 =?utf-8?B?WnJwM1lPRk1nNlZMUnc2OEdVb1JaLzQ5TWtkaW5RTTcrT2lLU25PSmdSVFB4?=
 =?utf-8?B?RUE1YS84Nm03ZlpwckUyMk14UkM4elBHZEdDZXRubkZtT1R4blVOYUtkSGR1?=
 =?utf-8?B?dms1SEdLbVNFOWNQeW0rUldZM2FrTFBTWXZseG5DaUhFSGt5bmJTQmFtM0ta?=
 =?utf-8?B?ZUNRMTRKRzIySGRwL3RKQlVtQ3pVaHBrT2VNTGNEN3NibUhSejFiUHlLck1w?=
 =?utf-8?B?WmR6OFo5NmFYeEVSOWNSOTdYN09ja3VQUjJpcit5eDZweWtXa0NvdEpNZjF1?=
 =?utf-8?B?eU1jY0FkSXY3RVhXam5QdC9UZ25nMldFajBVZ0NQTDNTWGE3SGlqZkwrVnJn?=
 =?utf-8?B?dS9POVdwcllGOUx1ZHhEa24zNjdRd0dRSDk2U01sSHg4TnpUZGh2ZnFqWWcv?=
 =?utf-8?B?eGM4aU5ab1JpMUJYcFhhTkVUN1hlNnNVQktvaEhwNXNDQ2tCdTNaNHVldWtN?=
 =?utf-8?B?UjMwb1hRa3ZLUzI2SzFieFAwcWxicjFTV3ovWHhQR3J3VzJjRHVKNHUrRHV3?=
 =?utf-8?B?em5mMkZDSEFBNzdPNHByejdqRzloMElQUGpBSmRuZi85TjA5UFl2aTFObkp0?=
 =?utf-8?B?MjY0MisrSFdEUnpnRzlTdjZGbC9yWUdkL1VrcWMrMFN2TE15NW40ekZFQ0sx?=
 =?utf-8?B?Z1dUQWozZ2szS0ZZYnJPWlpqZHBaUktQU2xBZDhHTXA4dmhuT21MUVVrbXhS?=
 =?utf-8?B?cDA0dWl2UVpIYzBnU2ZtcWNPWlBONTZDNGEvV2wrcEVJdFlpWmdVenFaMmtZ?=
 =?utf-8?B?akU2RkxHNmczbWVRMEI5OEdabnd6cjIxY29NNmsxK3RIc0pIMTVOVEprR0hj?=
 =?utf-8?B?d05ZSUZsM2Q2MU1IN3R5OHpNL0lqTVZFam1zVWhQSVBYRzJ5d3NEMzBVc2to?=
 =?utf-8?B?bzRQL0NJdEh4WXFDdGFkVGFNNHg5L3RoRTVFcmZxUnh5bEhvNjhGdDJ6ajlB?=
 =?utf-8?B?MjBUTGRGUHF6bm11dXYvU21FZzUyTnNmbkdNNkRheG9aYzZKNTc2TC9WMDVl?=
 =?utf-8?B?N1ZqTDE3WnhHQVozVEpVeUkydlhVVjFvM0d5a2xzc0VlakhWYmh0YW1nYnZt?=
 =?utf-8?B?WVZ6Z0QxYldCa3VBeS95SlEzdkIrNmRiTEJweWxENGhieW14eGdXNW1ZMkQz?=
 =?utf-8?B?MXhDelZqK3owL3F2dlVhNUlzTkU4dE84QVRLZWM5K21NKzJ4UTBRejl6KzBi?=
 =?utf-8?B?OVdYRWlqaXhGUHBRUzlCK2JCbVg0TW5pY25jYStGYmxBcjh4VlRVZjZmMjZv?=
 =?utf-8?B?OUJ2RS81RXJ2RzFGM2tETWQ0Nit5ODFnL3I5ZUFsRm1YbE1BQkR0WWxVZ25X?=
 =?utf-8?B?dEo2cFFocXBYVlFlTnM5TFY5TUE3cHladWZUdmlrcUFsaSs3ZlNkL29pekhJ?=
 =?utf-8?B?Nm0xeVJXN3hUZ1pHOFNPL1k4YkhBVXBSM3kzeXRQV1ArL1hsTVdUVU1sd2tL?=
 =?utf-8?B?L2FyWjJ3WUxRUVZtMlNIM0FhaXRhVFF6MWpIZDFNZnVZcWEwNWlEV2JWK0Fz?=
 =?utf-8?B?aTlLL1BqQUhvNklQZzJFOTF5RWY3Lzg4YjR5QjlqcTFNdnRHVmFFT0xVdDVO?=
 =?utf-8?B?TlB0dnUvRzVUY21IdDNGdGVQZ1RHVUNjUEE2ZXVTd2pIQTd1NkljbE1pZTdh?=
 =?utf-8?B?d0pBaE1aSjRUL0VXUlRMNnFEVTRIYVBzR2RPcmZIQ1BKYWU5ODFDZmJKdWdL?=
 =?utf-8?B?NnpjTkhEc2pkcjBkSTBZZzBiRysxZUYwUDFWamF6YzNrRG9EUW1JTFJvSTJ1?=
 =?utf-8?B?NHErVlV2OWpsQk5pTzRzU000VXNNT0pROGYzQncrZXp2cTJ1RWgxblh3Vktz?=
 =?utf-8?B?STBYOXI4UEgyZ3AwNlptamJoQk91MzdJRTJQOEZxQlZFcFVQeiswZ2RqdUV6?=
 =?utf-8?B?dFNGV2kxeWI0Mzg0SGVKVWthc3pocEYvZ2pqYnU3c0tPWldRVm54ZFR5ZUc5?=
 =?utf-8?B?bjZESXlZNTJjKzdndFVrZWNLSWwybWF4ekIzSGNOcGRlMjhRZFN1eWcyaXlO?=
 =?utf-8?Q?xCK8ils51NnT90vmyAsz8EK2s+19CG9bPg3UI?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5476f3ab-77e3-4cb6-bff6-08de5517cc56
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3282.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 15:56:23.5696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QF4YDvnVpG5MGRWnU0sM47Yjm+7XgdazwRijGvwA16LrX/VscCXVsbeKwTdCunbRKG5lcBiifE9nvJuKM7o2ebhY/GoPIz034khnL/0Euyg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7634
X-OriginatorOrg: intel.com

On 2026-01-16 at 06:57:04 -0800, Sean Christopherson wrote:
>On Fri, Jan 16, 2026, Andrey Ryabinin wrote:
>> On 1/12/26 6:28 PM, Maciej Wieczor-Retman wrote:
>> > diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
>> > index bcf5cad3da36..b7940fa49e64 100644
>> > --- a/arch/x86/include/asm/page.h
>> > +++ b/arch/x86/include/asm/page.h
>> > @@ -82,9 +82,22 @@ static __always_inline void *pfn_to_kaddr(unsigned long pfn)
>> >  	return __va(pfn << PAGE_SHIFT);
>> >  }
>> >
>> > +#ifdef CONFIG_KASAN_SW_TAGS
>> > +#define CANONICAL_MASK(vaddr_bits) (BIT_ULL(63) | BIT_ULL((vaddr_bits) - 1))
>>
>> why is the choice of CANONICAL_MASK() gated at compile time? Shouldn’t this be a
>> runtime decision based on whether LAM is enabled or not on the running system?

What would be appropriate for KVM? Instead of using #ifdefs checking
if(cpu_feature_enabled(X86_FEATURE_LAM))?

>>
>> > +#else
>> > +#define CANONICAL_MASK(vaddr_bits) GENMASK_ULL(63, vaddr_bits)
>> > +#endif
>> > +
>> > +/*
>> > + * To make an address canonical either set or clear the bits defined by the
>> > + * CANONICAL_MASK(). Clear the bits for userspace addresses if the top address
>> > + * bit is a zero. Set the bits for kernel addresses if the top address bit is a
>> > + * one.
>> > + */
>> >  static __always_inline u64 __canonical_address(u64 vaddr, u8 vaddr_bits)
>>
>> +Cc KVM
>
>Thanks!
>
>> This is used extensively in KVM code. As far as I can tell, it may be used to
>> determine whether a guest virtual address is canonical or not.
>
>Yep, KVM uses this both to check canonical addresses and to force a canonical
>address (Intel and AMD disagree on the MSR_IA32_SYSENTER_{EIP,ESP} semantics in
>64-bit mode) for guest addresses.  This change will break KVM badly if KASAN_SW_TAGS=y.

Oh, thanks! That's good to know.

>
>> case, the result should depend on whether LAM is enabled for the guest, not
>> the host (and certainly not a host's compile-time option).
>
>Ya, KVM could roll its own versions, but IMO these super low level helpers should
>do exactly what they say.  E.g. at a glance, I'm not sure pt_event_addr_filters_sync()
>should be subjected to KASAN_SW_TAGS either.  If that's true, then AFAICT the
>_only_ code that wants the LAM-aware behavior is copy_from_kernel_nofault_allowed(),
>so maybe just handle it there?  Not sure that's a great long-term maintenance
>story either though.

Yes, longterm it's probably best to just get it right in here.

-- 
Kind regards
Maciej Wieczór-Retman

