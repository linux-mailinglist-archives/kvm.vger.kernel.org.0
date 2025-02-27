Return-Path: <kvm+bounces-39582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C45DA481BD
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 15:42:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 92ED7425DA1
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 14:21:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAC9F235346;
	Thu, 27 Feb 2025 14:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EEcF8W46"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0F0234990;
	Thu, 27 Feb 2025 14:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740666002; cv=fail; b=dLBY0CDZ69aSRT4GEBH12KukRx+QUtjyRXC3LP9xu2z+irXhmCFc5kl1FzpyBM9obswES+Td4OHp76wnidFfGg04fvxgS7QIkF16RFF88W4UB0vwS6iItcPvyakfnh/IKhBYQnPOzVyzyu4kRrnzlcdTpSqE6SGSteviPyUYVbo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740666002; c=relaxed/simple;
	bh=QKEF07RCR8X9TaMWgODTk6lHxli3Ldli138YpdfmqK4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lB6AjLJcE4OiOudgWX0KF8zfzyPC2yGeebUv2e18yUfmL0+UtwH/NM7cgUQDfzcmJNgizwwroksaV13OETP9Gg7v5URvmmbgnLscXT7Zon4hXVcrUjEoQCxHGUx4uG6Q8O9OZmVdlY4NBtivsemIrWvR9oomsdL8J8He+Ylr+MI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EEcF8W46; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740666001; x=1772202001;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QKEF07RCR8X9TaMWgODTk6lHxli3Ldli138YpdfmqK4=;
  b=EEcF8W46ERaymTKc/b1TooiWTLv7/xMhFe6cSaY+lCaYirKLsLpZtgNI
   ZEtjj0Q1NV/nYttP6hNfCf2fnsrRdBwboJ/a5uCG/fOfrH7lmDJ99DlQD
   tdX++y1hj1epifggLLV+3TFwlwyVo+oM3uUZ+dGzzmb+PmvK+DWuKysmk
   GGi6ASA9jnDX5gKijw5M06UYLKD2Tg8hOQHqjZsWRtIqmGv5QcQHNEFFz
   SRd0VRdIqV0XQXmgm/hC1fPQQv8k+pPRRxA5qVV6L97VZgkwcLYWaD157
   8YpdhjZNrKXhVv0Xp8J8KhFBdZeKxLbLbt/Mf94iLwZm9NMk3QJCvi88F
   Q==;
X-CSE-ConnectionGUID: c3gQKU/URK2vBXBCZ+PsSg==
X-CSE-MsgGUID: OUXxu8qzQaOgp644CHCe1w==
X-IronPort-AV: E=McAfee;i="6700,10204,11358"; a="40732261"
X-IronPort-AV: E=Sophos;i="6.13,319,1732608000"; 
   d="scan'208";a="40732261"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 06:20:00 -0800
X-CSE-ConnectionGUID: VtsaicIvROaRLAJ6UAXMiA==
X-CSE-MsgGUID: JcF8vbdqRxGmXwVZHUJZjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="116906392"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 06:19:59 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 27 Feb 2025 06:19:59 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 27 Feb 2025 06:19:59 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 27 Feb 2025 06:19:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gIJHEZQnzvZtbPozQGnCilcavDRyIHIbHW+TjIgC1aXeszHMXykrW74IiAVyaLwCgocgkO4ruS1+KRx5G5hgOQQaZ9luCKtky+pcnNjAVtmJPl5XWaWfqC15DpJUXcYHwqFwsXQEMSoHkQCAJLxgB76tsTj/9PtJb1HKmMqeoAxTlQ4Xi+PAxHvLqmAHiF9kFDQvWZj5ewfVq7ErdirZpUCgY5LdkdFXxdInqzkmeBwlR+nIHrxMxBSntGsbWi0CMGAXUHsIkdWK1Iw0q42YUBx8ScqkC1CBtThXBY4MHN7EWgeXVpD/Pn+P98PHTbBs9e0tb0de/OLHAuobVhPAJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KepOAZdBqhstf0UV1hgJj8cQnce/1mwhahllsb4ejBM=;
 b=ZD6fmlv+rEHHRK1jBo7VksnwbyyPu9CYMH7Qw0irEeqkNVGVfnWlF9XPmOo5DyqfTnPgOoGXrTi+4MOWYJ8efspTeu+xlAUk0l1sWT9KFR4xst0tRxZo6PxynAyuzE4b0GkblMHBwVU0wv+L5qLQ3+sANF4pwCZKJN13GA1O34SXheEhns12PB1siWfkrrodYjhvywt0OY/XsFsPWVqJXhF+H7GG3Au+lfOOfnkg8W1Lq0Z9YPAPRwL+2zXhuYNMFCeFCq+bU8zRNF1dzRzhE9Z/EVy0NVLgUBkoXvaYf8RZkwh0FSw4T/ozQ4hr3ATofxNMLt4s9ndrfo1XOqPfKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3605.namprd11.prod.outlook.com (2603:10b6:a03:f5::33)
 by MW4PR11MB6984.namprd11.prod.outlook.com (2603:10b6:303:22e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Thu, 27 Feb
 2025 14:19:14 +0000
Received: from BYAPR11MB3605.namprd11.prod.outlook.com
 ([fe80::1c0:cc01:1bf0:fb89]) by BYAPR11MB3605.namprd11.prod.outlook.com
 ([fe80::1c0:cc01:1bf0:fb89%4]) with mapi id 15.20.8489.019; Thu, 27 Feb 2025
 14:19:14 +0000
Message-ID: <13dad577-8cfe-4d26-9721-ab2acc79fa95@intel.com>
Date: Thu, 27 Feb 2025 16:19:04 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 09/12] KVM: TDX: restore user ret MSRs
To: Xiaoyao Li <xiaoyao.li@intel.com>, <pbonzini@redhat.com>,
	<seanjc@google.com>
CC: <kvm@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
	<kai.huang@intel.com>, <reinette.chatre@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<dmatlack@google.com>, <isaku.yamahata@intel.com>, <nik.borisov@suse.com>,
	<linux-kernel@vger.kernel.org>, <yan.y.zhao@intel.com>, <chao.gao@intel.com>,
	<weijiang.yang@intel.com>
References: <20250129095902.16391-1-adrian.hunter@intel.com>
 <20250129095902.16391-10-adrian.hunter@intel.com>
 <e2c4fa9f-a2af-494b-b4b0-71f11365e36c@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <e2c4fa9f-a2af-494b-b4b0-71f11365e36c@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR04CA0128.eurprd04.prod.outlook.com
 (2603:10a6:803:f0::26) To BYAPR11MB3605.namprd11.prod.outlook.com
 (2603:10b6:a03:f5::33)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3605:EE_|MW4PR11MB6984:EE_
X-MS-Office365-Filtering-Correlation-Id: aef9016c-2789-4632-86c8-08dd5739b67b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Y1VvaURVSEN1SkpSM1crelNTcTFsakNic2pkempld2tXazErK1hhQm5pNWFz?=
 =?utf-8?B?dTM4VGNRaFQ4Q1dOOWZqeDRMT3RZUlpBNkFXU2cwQUdkeVhRalFqZHpjQmY5?=
 =?utf-8?B?Ny9GWlRxbmxJRE81OFozOVFFeFVnREhORTFxZEo2NVBHUFlEaFZQLzBsTUtP?=
 =?utf-8?B?QjRudTY1VGFNT1B5a3pYaThHRW5Wbmc1OW9mWVl0WTBlUkVCZU1wcDlTVktB?=
 =?utf-8?B?WjFwNWZadzJHZVN4KzNaaVYva09WMTcwQXpUZ3lEdCt4U1VNMFlTR1hzOTAr?=
 =?utf-8?B?SjFrWDZTZTBtYTgzOXpHSmpvcmlPenUyQnJ2ZmhCYlZPZHNzdzZRazg4T25B?=
 =?utf-8?B?c0NlemNJYkNCdjhPWFUvTlVIY25sb0w4Y1F4bU84SVEzSXhKMnM5a3AvSm1h?=
 =?utf-8?B?QWRoM096aXpBRUNpZHFLZXZZZXBianF4MGlhUnVjUGFiNXZzRC9sUWJETktM?=
 =?utf-8?B?Y0dvYlZ2OS91Sm9FcDkzVHk3UGRTVUcxeENyaDRkOW1TaEVlVEJkR1RKajRi?=
 =?utf-8?B?S2l3R0k3QUxZTXU3c1JFU2NDVFY4TGRpYU5tK3VOM0F3UkhFeHRQVzUwbG5M?=
 =?utf-8?B?RHpMb0p1YnYwMDg0Y0p4VTMvVHVCL29QSXl0am1UYWhTdUhPV2ZFR1JiUDlH?=
 =?utf-8?B?c1Y2S0xuT28vNWMxZE9wR0hPQ3pXS3BGNmZEc0hITmZmN09SRE9JdEQvbmdp?=
 =?utf-8?B?UVpxMGNySXljTDd1bDJCVll3NEl5OSs3amZ4OURmaXMxZ2xzcUpod0R1aktT?=
 =?utf-8?B?WUplQmVJVE1QQ01EbW0vRTd1K1JDMFRsN0FLckRtZE5hL1BxWk10cHF2Q3VE?=
 =?utf-8?B?aUNXU0s5ajQ2OHpTTnZtRVZZODhBQitOSG10TkxieFM4Q3FBM20zZk1FUFdK?=
 =?utf-8?B?SUZNMSsvUzZ1NzRaZnlWYkFxcnkyNEU5ZEc5bCtMNHZUTkcwYkcvd0Noc21r?=
 =?utf-8?B?M1RqNlBEZVN6R1BoUlk0QTliQmVmM1FsK25qa2RrbUdBbVhObklTazRNbERy?=
 =?utf-8?B?U2hZelFsM0Nva1g3d2cxbEYyMnQvbHlSdG9lbkVSUG01UTRxV2tqUkczQnhX?=
 =?utf-8?B?NUg4SFVtUG9DRW95dlQyVU4xQnZCK2tVM2MvUE8xVFE2K1UvMjN3WXlrUXJl?=
 =?utf-8?B?aEZSWmJYWElLc0kyOXhpZGRUK3RDY1BiWTk0MldvKzRsN3E3SXhxTDQxcTZ5?=
 =?utf-8?B?aEoxZHJQdXBlbzZLMFVVTFdJZGJEdDdvTWcxdUhRRGl2OS9Gb0g2b1hZakZU?=
 =?utf-8?B?YzBXZjVoemRtUXlxTkhHZXF2Z0hDMkJEY1ZIQmQ0czBoNU03cFB6MzZGNjFR?=
 =?utf-8?B?MkhDUGxUMzFQeUt2ZHhJYXlUMDNLQVN4WjFPMlJRUGg3UElLRnpSSDVUeXlx?=
 =?utf-8?B?bitkcXExUmlmZ1hRZTU0Q1ZKQTR5N2gySEJCMnJtV0RoTHpuWktkK1hRRTdU?=
 =?utf-8?B?bjdXQUwrdzQyZ09IeGtlMzlsWDVoNHk2c05ZaVR1ZisrNS9oekxNeWxLMzM0?=
 =?utf-8?B?aGN2aENzaUdGUER2cDFOb2dZalBwL29KM3FCQ1VHVWswc1J1MDJDTFJlcS9o?=
 =?utf-8?B?TlZnTXhBTVFXM2dqbmNwRllYbTVmcW5hMllRaXJPQnpUT3EwRkJCb3JxL3RC?=
 =?utf-8?B?RDJjcitaOHpKczR0amRGb1cvSzNYeFBVUmVlWjNEVWs0MmQxN1hUS2lhT1ov?=
 =?utf-8?B?NFlxN3R5YTVhTmhIbjRLWkFvQjBwSS9YMVVFZ2RoNXNoS3RFV1Y0dTMzOHdX?=
 =?utf-8?B?cjNVMmlYcGpTU2t5OE5oQk14bHVlSWJYNWtpaGZxdDY0UVgrNnlHTUdDVUdh?=
 =?utf-8?B?R0RYVC85SGZYUFgvS3RNdFJvOXAyUWhaZ0FuRkxwRlpFUmNVeEt3b1V4VGRE?=
 =?utf-8?Q?xBXSxJy0qazBf?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3605.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bGloaWoxZ1NHYXZiQWhDd0VGWElBUzY2dFFkamZPT1VvQmhpT2ZQVTc5TFVv?=
 =?utf-8?B?VEtHMHlrekRab29Cbm02YzFWb0c1VFZwYnJ4L2diVDhZd3lmMGtvcVZyR0N1?=
 =?utf-8?B?NEhSZkxCRmNhNDkrS1IybHp2NTBLM1hhSUpwWXdVUEdHb1h4djJpVTJSbWdK?=
 =?utf-8?B?ZFd0eTBCQ3FEb3JEcW9XUWYyMUdsMTVaZzNDY2RFNEFBTWVzR1ZQcEV4bW5F?=
 =?utf-8?B?dkpIVm02L001OXNDT1VPUlVBYU96MjMzR240SFhXNnBZaUhUbk9XazZrazJv?=
 =?utf-8?B?OUl0VTZMZmx3Z3Q4SzZsRGhDb2Y4cDJsVXRnTjVCdjFJNDAxd1RNVGZJUTJu?=
 =?utf-8?B?UklIRkFoVkp3czQ2dEl1anpOK1RZbjk2c3lycW1uUjJnNWtXazgrUHZiSG92?=
 =?utf-8?B?NmtWWnQwSi9XMy9SdTUzVEN4Ly9KbTBHYklzaENMOVZhQjdvNVRhamJYS1pM?=
 =?utf-8?B?L0MzL1lQOVJIYU1sMWFuQ1k2K1FhQnQzWlZnclozVXdLUk11b2NWV1dhVWpK?=
 =?utf-8?B?eHhFd09NRU14TnFSbXF5QWFWWnNGNWg3QjVCcGFCazFyaFpBVXh4SWNtanNH?=
 =?utf-8?B?NEY3bDR2L0MxUVNkUFZOV2JEV0NLTGdxYThOM3dQaWMrZVQ1cDFxbUZjZGhi?=
 =?utf-8?B?WWwvYjBYM1FJTlZWR0czdjgxT3VaUUlqZ24vM3FkWkVOeEJ4QncyaWVOdHFz?=
 =?utf-8?B?OG5xRG1RWTR4S0pBYzY3c3d1OVllcTRhbENWQno4dnZ1a3Q4WW1sS3Z4alI1?=
 =?utf-8?B?Q2VGcFhpY3FpNFIyTDg1MzFjT2tra0VpNUpiTUgveElBcytITzNIZGhNU0di?=
 =?utf-8?B?R1hONFplTGgyc0E5cGcyYnR1R3VCTFdYVEszdHdBUCtSTDcydlJNcVUzWU8w?=
 =?utf-8?B?dFNpVmw4ai9Td0FwaWZ2Z1RqV3M2YTMxS2tpTExxV2Z1K25jdjBKOHhDZjJL?=
 =?utf-8?B?Z1U1SlU2dGlZT3Vaeml4UXhwQ0xKeXBqUGlKOTB0RTRzbjRQK05LMEozd3kw?=
 =?utf-8?B?MStvbmJITWRRNjhDUmp4MS93WHk0ZjJiTkhybjg0bWFsUlFHVmFhQ0xSUGtp?=
 =?utf-8?B?ZHJRUEU0QWQ0SjZCeER6RDdBc3lrcXMzTjVtTTJDK3VjZDdkYlVrL2RhcWJO?=
 =?utf-8?B?aS9aK0laUUtPVWg1TU02amI3SnN5U2IyajBoQmNBY2QvanVOY0U1TFE0Mmh2?=
 =?utf-8?B?ZS9WQVVHZHdGVUowUlMvSmpDNGE5bENkMXdEZEwwK0VONms1RnpNaUNVQzE2?=
 =?utf-8?B?NGR6ZThHaVVHd2NiT09tbFk2MU9pbzkxb1JUenJ1bXo5TXNyMGRNa1FSeVpZ?=
 =?utf-8?B?Ym40WmZuUy90VUJTdmVvODQxbDBuNjF4c2xLUFJ3SDZ0cDRDSjdyL0tBK1Fu?=
 =?utf-8?B?ZHUwc3J3K2ZseHo3SUdnN2xVWkMwNUlTamtaamtnTGo0Q0xNb01jcUtPSU1J?=
 =?utf-8?B?T0tuYXJ0K0RJT0ZObGhwdi8vcDQzdk5Hb0E1U29MWldXd1pQTG14KzUxVEZ5?=
 =?utf-8?B?azRWaTdnaENoSExJL1c3MFlOZHBhWTZIMUEvNkxQbjkrcEdLbFJDak9VVDhS?=
 =?utf-8?B?MGVTU0VQdndzTlpNV0haQ0g4RlQ3TExNUHRtYUViOE00OW5HVDRha1YrYmlY?=
 =?utf-8?B?b3g0bk50UGc0bCtMN3NBeHBOR010QlpCOW52cUZaZG8yZS9TUWI3OUZZcVo0?=
 =?utf-8?B?Qm5iQ2FyNlZQY2Q3SktFcTl5RjJPYyt6WVNmWDhvRDAvN0huY1U4R2ZSZDZ6?=
 =?utf-8?B?cm00bm5NWDZWOTdUbDE3c0s5Y0dpMnJhcW9vdjR0QjIxeXkvWVdzOXV4blFr?=
 =?utf-8?B?MVVqYmJJVzdhUDFzOTFEYXhnR01hRlhiN1UwR2FmdFhZZ2Q5MFhkQlhDTE56?=
 =?utf-8?B?SmNQbDU1MmpUWXdFMk1QdmMrZjFsZXhVSDJTQzFYdHNxaENqU1RuVmM4Nm4x?=
 =?utf-8?B?WEhRUmxhZFNDdUE1S05reEc4TVE2czR2emNDb0VZTmtUZzNJQnFwWkxVb2pS?=
 =?utf-8?B?VjBpTWFvR0s1SHdveThVWURDZysvdU5JcHNZc0ZiWS8xbVFrbHVDcDc4ZGRn?=
 =?utf-8?B?YTJHclJReWVFUURweEh3amxpdXNnVWpKc1Fnb1lqNDVGSVF5ZE9DR0gvTDRD?=
 =?utf-8?B?M0NVY1JWREY5U2FPM25FS3BtODRoT1h2Mzc2Y0JxQkIxc0NOTHBuYUV6dWVX?=
 =?utf-8?B?akE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aef9016c-2789-4632-86c8-08dd5739b67b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3605.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2025 14:19:14.7884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0nGI86ZgisuQT59w1BSN+ty+RvE5iUkOxpcOxS3LRdQhuIs7TtPGMFTMYDqvgYgi6H69VVgpztAMo/kVgLTiRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6984
X-OriginatorOrg: intel.com

On 25/02/25 09:01, Xiaoyao Li wrote:
> On 1/29/2025 5:58 PM, Adrian Hunter wrote:
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>
>> Several user ret MSRs are clobbered on TD exit.  Restore those values on
>> TD exit and before returning to ring 3.
>>
>> Co-developed-by: Tony Lindgren <tony.lindgren@linux.intel.com>
>> Signed-off-by: Tony Lindgren <tony.lindgren@linux.intel.com>
>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>> TD vcpu enter/exit v2:
>>   - No changes
>>
>> TD vcpu enter/exit v1:
>>   - Rename tdx_user_return_update_cache() ->
>>       tdx_user_return_msr_update_cache() (extrapolated from Binbin)
>>   - Adjust to rename in previous patches (Binbin)
>>   - Simplify comment (Tony)
>>   - Move code change in tdx_hardware_setup() to __tdx_bringup().
>> ---
>>   arch/x86/kvm/vmx/tdx.c | 44 +++++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 43 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>> index e4355553569a..a0f5cdfd290b 100644
>> --- a/arch/x86/kvm/vmx/tdx.c
>> +++ b/arch/x86/kvm/vmx/tdx.c
>> @@ -729,6 +729,28 @@ int tdx_vcpu_pre_run(struct kvm_vcpu *vcpu)
>>       return 1;
>>   }
>>   +struct tdx_uret_msr {
>> +    u32 msr;
>> +    unsigned int slot;
>> +    u64 defval;
>> +};
>> +
>> +static struct tdx_uret_msr tdx_uret_msrs[] = {
>> +    {.msr = MSR_SYSCALL_MASK, .defval = 0x20200 },
>> +    {.msr = MSR_STAR,},
>> +    {.msr = MSR_LSTAR,},
>> +    {.msr = MSR_TSC_AUX,},
>> +};
>> +
>> +static void tdx_user_return_msr_update_cache(void)
>> +{
>> +    int i;
> 
> I think it can be optimized to skip update cache if it the caches are updated already. No need to update the cache after every TD exit.

It might be ok to move tdx_user_return_msr_update_cache() to
tdx_prepare_switch_to_host() but tdx_user_return_msr_update_cache()
should be pretty quick, so probably not worth messing around with
it at this stage.

This patch set is owned by Paolo now, so it is up to him.

> 
>> +    for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++)
>> +        kvm_user_return_msr_update_cache(tdx_uret_msrs[i].slot,
>> +                         tdx_uret_msrs[i].defval);
>> +}
>> +
>>   static bool tdx_guest_state_is_invalid(struct kvm_vcpu *vcpu)
>>   {
>>       struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
>> @@ -784,6 +806,8 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>>         tdx_vcpu_enter_exit(vcpu);
>>   +    tdx_user_return_msr_update_cache();
>> +
>>       kvm_load_host_xsave_state(vcpu);
>>         vcpu->arch.regs_avail &= ~TDX_REGS_UNSUPPORTED_SET;
>> @@ -2245,7 +2269,25 @@ static bool __init kvm_can_support_tdx(void)
>>   static int __init __tdx_bringup(void)
>>   {
>>       const struct tdx_sys_info_td_conf *td_conf;
>> -    int r;
>> +    int r, i;
>> +
>> +    for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++) {
>> +        /*
>> +         * Check if MSRs (tdx_uret_msrs) can be saved/restored
>> +         * before returning to user space.
>> +         *
>> +         * this_cpu_ptr(user_return_msrs)->registered isn't checked
>> +         * because the registration is done at vcpu runtime by
>> +         * tdx_user_return_msr_update_cache().
>> +         */
>> +        tdx_uret_msrs[i].slot = kvm_find_user_return_msr(tdx_uret_msrs[i].msr);
>> +        if (tdx_uret_msrs[i].slot == -1) {
>> +            /* If any MSR isn't supported, it is a KVM bug */
>> +            pr_err("MSR %x isn't included by kvm_find_user_return_msr\n",
>> +                tdx_uret_msrs[i].msr);
>> +            return -EIO;
>> +        }
>> +    }
>>         /*
>>        * Enabling TDX requires enabling hardware virtualization first,
> 


