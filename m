Return-Path: <kvm+bounces-52059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 29C1EB00E6F
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 00:04:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5CF45189F079
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 22:04:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 573D12980D6;
	Thu, 10 Jul 2025 22:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fb7TfgEv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CD421C165;
	Thu, 10 Jul 2025 22:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752185068; cv=fail; b=mMgbaaTufrTSDcD7MraiGompMrcav5KjlMbg0ejtAovxc5AIwihTu523B6kJFwtmknWfL/vcfsfFkaXagnSluuENJDV5rAGZnTpIqQKbEVH6j5NAVfa9JkD60kxT+AJcBoM1pLNtvqLEZBcPp3fMomKeNzn0nxM744v9SqIYC6I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752185068; c=relaxed/simple;
	bh=N7+S73CXXfiO91CT6YmFl3i2lwfuCkbW3MTGHoq7Ss4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=I/JH3WcXU101sSh3ydBWnx72CTAPDZbHTVvrpvNDIxCSYMZ5pr20a0JtXLp/W73hTkxs52w0EMM9SZ6obpgCFO95d5tV56DYrNw8rbgU4YuuNW2EZeUCLLtDu+2nKz3UCKhNPKz7ms9WG5rJkV1W9LpyEKOdHoQzuedglxKLj/w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fb7TfgEv; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752185067; x=1783721067;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=N7+S73CXXfiO91CT6YmFl3i2lwfuCkbW3MTGHoq7Ss4=;
  b=Fb7TfgEv/LSPIP0ScWa3YBVdUD4SVFHMYAnJs4+9bomUwuKhvIfvf5Qr
   vzj1mxFPKbpLs85RO03RiFckQ6BZ8BT2qMmfCr2gtDTp/vB5I7o7mKJBQ
   ZChakoaBaW4QXJMFh4sJklBqIzU0Gg+FKkZCmTnIcvbjIDwyUO7cFm6iK
   IRsN//jZmv2zZe8Q46pL7nLOUam8taDcnTBDekrJtGyC2Jm2yWvwdY9Z0
   ckhwmeIpVFI0Q2o6THjqVD4MWY0aWTQDmRU+HSUFibeq0Q0XId6FrGeSR
   QUqrCyxWP2GHYGZcDLv6BJHTCMGgoA4Q+J7myqPW8MMY92RKe0RgT5rIt
   w==;
X-CSE-ConnectionGUID: XZeeYkkaSIaECm+9Uwvb3g==
X-CSE-MsgGUID: 5fq909WSTOGveL24zformw==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="54606424"
X-IronPort-AV: E=Sophos;i="6.16,301,1744095600"; 
   d="scan'208";a="54606424"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 15:04:26 -0700
X-CSE-ConnectionGUID: j+dQ93NFSTqi5CnXDK32Uw==
X-CSE-MsgGUID: F5Kqc9t1S6u8eXtFjY5pSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,301,1744095600"; 
   d="scan'208";a="155624212"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 15:04:26 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 10 Jul 2025 15:04:25 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 10 Jul 2025 15:04:25 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.55) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 10 Jul 2025 15:04:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i8l9aLJnOAFYkiX3dfCqlcWtiTHCVzxvOW8SqkiV63lHEz1mMyto1p9IKXHAvkIogbdpdQ61Wk8EmXuyqz6MR8YP5p689+yrcI+MHhU2Wtw+7cbpd4YsEoxdG4Z16qFZt6XcHt3xRu9V8VIuWpxdtu0M6ntYbduePTOvEzy/yHdQQmqS4yBF8uHeYSqqOSl0+CIOIjbwuO0ZSXtkQjmhnykC6OoKEVOJMurUCIumWsn0/D+8dJLcEK++5UzM7Y1u/1MRvHxtYLjF0p47yFiFXO2hCFBJuiafuLi0a9nVWFiR3KKaAn13OA3tgse4IXlWKVM/OllIdx2QP9EUi1Lolg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KzRBmZHPubPBghYk5DN4UDNGpuaEhzPjifinM7gOaC8=;
 b=tyl2vmVzz/FfCDxWRLmYOvTlTZV9i8ofVToPKw8vkKFz/sjVgZOTHgZoPMwBcDZykyyDB/Yl44/yVRM50lg05Zprg1I8euf5TEfMOjPGKfGiS6m3Q5jsGhesB7k/ZRLKPrdSa72FddxdQowDBB7UuBtH5sB0EVdlKogO4voCSMckH/UkW3MeFaFwpT1xil8rHT7MTM/8euQj6lkbxlUSAkKrYsLAdJuYi5eGpxj+v3XcXpvAoeYNt89ZGp5EuRvOSvdmQNWw98ihp8yKcQLyM+JiepDWv0K01yZaUjOPrVG58L4qL+XoQ8A5rI45VmYIOTOTxwba3prZSv2hYSn+aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3320.namprd11.prod.outlook.com (2603:10b6:a03:18::25)
 by CH3PR11MB8752.namprd11.prod.outlook.com (2603:10b6:610:1c2::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.24; Thu, 10 Jul
 2025 22:04:04 +0000
Received: from BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b]) by BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b%7]) with mapi id 15.20.8901.024; Thu, 10 Jul 2025
 22:04:03 +0000
Message-ID: <d7a11ebd-48d5-48bf-abac-317d5da80a6a@intel.com>
Date: Thu, 10 Jul 2025 15:04:01 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 08/10] x86/nmi: Enable NMI-source for IPIs delivered as
 NMIs
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>, Thomas Gleixner
	<tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H . Peter
 Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar
	<mingo@redhat.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, Xin Li <xin@zytor.com>,
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	Adrian Hunter <adrian.hunter@intel.com>, Kan Liang
	<kan.liang@linux.intel.com>, Tony Luck <tony.luck@intel.com>, Zhang Rui
	<rui.zhang@intel.com>, Steven Rostedt <rostedt@goodmis.org>, Andrew Cooper
	<andrew.cooper3@citrix.com>, "Kirill A . Shutemov"
	<kirill.shutemov@linux.intel.com>, Jacob Pan <jacob.pan@linux.microsoft.com>,
	Andi Kleen <ak@linux.intel.com>, Kai Huang <kai.huang@intel.com>, "Sandipan
 Das" <sandipan.das@amd.com>, <linux-perf-users@vger.kernel.org>,
	<linux-edac@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-pm@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>
References: <20250612214849.3950094-1-sohil.mehta@intel.com>
 <20250612214849.3950094-9-sohil.mehta@intel.com>
 <aG1laKXYu7Uc4Tsb@google.com>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <aG1laKXYu7Uc4Tsb@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0101.namprd03.prod.outlook.com
 (2603:10b6:a03:333::16) To BYAPR11MB3320.namprd11.prod.outlook.com
 (2603:10b6:a03:18::25)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3320:EE_|CH3PR11MB8752:EE_
X-MS-Office365-Filtering-Correlation-Id: 428a0167-3ab5-4952-4e90-08ddbffdaed8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bVJCMFdZb20zRERMVnBESno4bWtNZ2crRlU5OGQrMERibUY2RDAyQ3JUWFph?=
 =?utf-8?B?bW1PbjRDYzNnbVJST0dleXk5Zis5WXBpcHE0emlkNmdhSlhRdG5HU1lGTzkx?=
 =?utf-8?B?MnJ0QXErdlk4OWRDTkNlaGwxODl0SFFQODVyd3ZqdzdyRnM0MFJXTTV4OFVO?=
 =?utf-8?B?Tkp5aGhIUC8xR0o0WFE3MGJ6cUlCbVorT3lWeHQ3NVVtSVp1RnV6eFNvRGpj?=
 =?utf-8?B?TmVDVWRXS0cwVGpYTlFIVnB0OHJydEhlUkwxa28xN0xuc2pTcXF6K0MwTDVG?=
 =?utf-8?B?MXNaM3AwbjVuZmduTjNMeUFQT1hQa2RYdUZRNGE0azdPQVNIK1ZzV0U1RzBC?=
 =?utf-8?B?VEZiejV0Ui9DNTVOU0d0Vy9LNWNEMVZqV21jOXEramY5U2U2Y0lXQklra3M2?=
 =?utf-8?B?dGdkVEtxR0dkNVJydjZ3bzU4citHM0tINHQ1cEJybGI1SVU5ck9HU1FZcmtN?=
 =?utf-8?B?ZGhkTzBBMWxMNnRPV2h4a2Z2VExHNHhuejdQZTAzUk11OFVmRmdzaDMzMElk?=
 =?utf-8?B?WHBMQk1PT2J5bkRFWVRrS2hGYkNhbEdMOXk1SzR3VmY0NzFNaUFNSVQ1TFZV?=
 =?utf-8?B?M3U0cmJySll2Y3ZuMVBvaEptSWUrRGM3Sngvc0xZczBGMnc2bXk3TDVuRzEz?=
 =?utf-8?B?cjBNS3NIdjg1R2Q5WmFydVRvaFlIWFZ6NklhT3lYODhzRWFIRmMxamVJb3ZN?=
 =?utf-8?B?clZqNzV4R3N2OUN2WmwwK01Vemxlakw5MWhIM0s0SWpTWFF5VXBmMGJOMVVi?=
 =?utf-8?B?aFYxSVNldExZa05kQngxZncxMG5XVVplSWZpZU1uVndwRmpuZHdPdHkwVVEz?=
 =?utf-8?B?VXU5Y21mR0F6MXlGbmlEQlJzMXFEajI3YU5nNGRDU29TYU44aDN5dkxtSWly?=
 =?utf-8?B?NnpQREdKRUR3cW1TZlFBMnRRV1J0MjdYUUtvbHBJNyt0bjdDcGp5VTV4ZGM5?=
 =?utf-8?B?US9BTm53QXdVZmtocEVuc3g1cEdKdUlqNEVCdTZ5KzhCMkUvbXVtd201S3hi?=
 =?utf-8?B?Wng1ZnFsTHpwSncwRUlHYzNHS3FuMDgrNlZpd21PejBtWmRNaFh3QjVMcWxx?=
 =?utf-8?B?QUhac0dhTnptYkRMMVo3V2lrM3lLbjVxYitOU1FhbVNsRE9USUZTbUx5ZnhH?=
 =?utf-8?B?dzFxTzZkclpWY3RFdW9Rd2gyOFhESUNwS0l3MVVIMldPdi95OThmOHl2dnla?=
 =?utf-8?B?N1Q0ZktYTkx1aDlTL3ZXczJlRUM3OXp4SmI5N2I3S0Z5NlI5MG5leDVHa0Q2?=
 =?utf-8?B?dytyaVJZajFmcit0UGI1eDN4MVhpazJGaTVncTZYWUlWOFZ1SFRCRVZ5TFlQ?=
 =?utf-8?B?QmJ0QnpGbGVoSGJ3ckJOQ2FneWVkalkza3grUmNCQk81dEVtTGYvY1lxMCtW?=
 =?utf-8?B?Mi9KOUFsMkdmRlR6dkpmK25GNWFxTXJCQ0crN0xFZ3Ewa3ZrSUhJM3RFZ05U?=
 =?utf-8?B?S3RpUW5WQXQzUW9jWUNObzlRL2dnQW5hd3l3OUxnYTgrK25xcnlVTExiUjVI?=
 =?utf-8?B?UE5qa2M5ajYvd0pFd1lxNEgxd0ZCRTVZalJzaXhQcWx4Vm12UXA5SDJaVkhq?=
 =?utf-8?B?ZlJNNE40clg4ckxPMkdRNGNnRU9JN2NoSVc5T0d3a2ZQSFg0QkZRT2J3Zzhs?=
 =?utf-8?B?bmxXaVFZS0JmQW8vY3lEQU9jWVVGUnA2N1pzcU14V25HK04veHNHTUhzanY1?=
 =?utf-8?B?Z0dxNmJscldUTzVEN0xRbUtybzAvdHRzOTFiM3owVytsc0x3M1IzWk1OazAr?=
 =?utf-8?B?RGJpRHF4dlN3QjZkYWJ3c2dEWVpBUHBabVlZNkRCL1Y5dWh2aWU4RDg1dkFR?=
 =?utf-8?B?TklqYUloZTVLUlRpSzVNdFdUN1QyKzdQdm44YUV3d2ZFQXBMVVRLUVNDVTdP?=
 =?utf-8?B?cTVjcHdCMEQ1aTRJbmxhK0xLYTRkWm50WElyQ08yNHFLVnZ2UE91aWFpa3pW?=
 =?utf-8?Q?FcPSapv1YEM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3320.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?LzVhczVTU0Zxc2NDekEyaUt1NnNqQ1hPTWhOZ29NMzZTZGE2Znc2SzU5dUg5?=
 =?utf-8?B?MXRiTW15VVd0ZEpyVm1WdXVDMjQxTlVrbEhpcUh5NGhPRDNUMzh4YkNMdCto?=
 =?utf-8?B?Wm15MGZxSXNlNDR5OUw5UHdQQ2NiRmxUc2pRejVKcTdMbjJKRWRhTDNFa0V0?=
 =?utf-8?B?V1BmNUsrMHFja3poTW1JdFFucHpXWkY3S1lJQjBsc2NLNzM0VjFZRDBKYU9p?=
 =?utf-8?B?cjdaaGI3RGlYMkFzVHp1TkxpTlY1blphNUM3dGlxWVhFcnNjb1JzellGU0x5?=
 =?utf-8?B?d1Y1OUxySGllQVh4MTU4clJsV1B5QldiUmY0K1BETjdBVUVPZm1RdkZIUS9V?=
 =?utf-8?B?UTRPSERLbWNFa2NIVVNPMnJPMlJIQnhGNURONC84YVBCUzU5REN1cXkrcWk2?=
 =?utf-8?B?cWZNcXJpN3gxSGZBN0lFUEdaSkxISkRNNnhPUExXcnZHeVovUi9yOGozZlJT?=
 =?utf-8?B?TlB3WnN6N0toZ3dpbUlQOTQ3dVF6SmhGWHNDamloUUUrWnlJdkFyVUxuWmg3?=
 =?utf-8?B?cnpsckNkRHlHVi9ZSnFpa0t0UTNtTWNJTlptN29BM3cydlVMa0M0TWJaVGpl?=
 =?utf-8?B?WDhOZGZGQTU3RHZXYXJFaW9tOE9VclcrTHFnODZHVFZpdHZJRW1YdzlPeWEv?=
 =?utf-8?B?Rjc2aXJrU2pqeGFkcTAvR0NuN1hyNzNLVGcyZTRNU2ZhZlk0Y2IxOHhWMVln?=
 =?utf-8?B?T0Y1NlBZOExLckdnUytKLzQzSW1xRExYYno2Qm9ZaHNTN2ZDS2xrUmhJWjI1?=
 =?utf-8?B?OUZXRWxwZHRnbncyWEFIUnVmVHZDMzlHUGpKS04yVk1FOVZDOENGVFRDT0Yx?=
 =?utf-8?B?aTFtMG9FLzVmYzluY0VlZXNnTEdpUy9VNWdscXdVajBKYm5EenY4WGNqejRC?=
 =?utf-8?B?S2RSdUNmLzZaNnVtWUR3ckRTSWlsUWZWNUhhTUlJSURjUjVaRHp5d1Y5clpD?=
 =?utf-8?B?MmgxWHRxMEU2aTBHZDZ4aUw0M29iMXJZYzgvMVZDd2xlWExWWkZZNWNnTGhC?=
 =?utf-8?B?MVNGV2cwZVRScU55enNIMVdOZGw0Q0Z0SlgvMzM1VEhRQlI2ZVEyS1RYSmJH?=
 =?utf-8?B?VlgwSUVpTGFTbkhvZXUzMlN4SG9YcFhwSFFydnNKU2hZSVpIVnFpZnhuWHZk?=
 =?utf-8?B?d2ZCU2ZYSXVZL2NmeU5yS0ZtTDZhRkErOFRJZGdRci9TZlI3aEZzSkttcWUz?=
 =?utf-8?B?ZHlFazA2elZyY2x1K0lRMzl1aEN6TTNJZWxRMUtNTEhPWTZnMDBsSnV2YXJ6?=
 =?utf-8?B?U2ZoaERjNGVTRlFFcFRxQUU5TzlVRG5JRnVla3BmekJnVVBacmpFVWRHRkhz?=
 =?utf-8?B?U3dvdjZnWDVueGZDK2tYalZEWnRpYkJqZEV5TElnWUdBdHUzYUdPVjFRZ1NT?=
 =?utf-8?B?SGpWN0NiT1JTNWdDZnZ5ZWloblZvRlgyNGdPQjgzVTRkaVpvTFNHd2x0bFBL?=
 =?utf-8?B?b3R1b2ZBMnJGOHVuc3RZZlA2ZXRmMUV3cnlzNnZDV1BiSEh6WHhMNUd4QUdH?=
 =?utf-8?B?Nmw2SnlIL1Z0YjlCNFBrZTZHQ2N2emlmKzUwOUVIR1FLbk43bTU5cldQamVa?=
 =?utf-8?B?UXJvN0RobGdsYUNhOHBTVGIvcEgvOHBVK2J6aEc2bXBkS083OWVWbWIwNHlm?=
 =?utf-8?B?N2oyRS9ra28wQVFja3g3RXhTY0dFUzdxZHEzSnZJTnR1Qk5CUUNLeU12RStW?=
 =?utf-8?B?NDN3eDkyTklpc0hsdGtxVmlvMUxVSVkzQWdzcUNYMkNxdHpKV3RGK252R2ZE?=
 =?utf-8?B?aGFqSnpNdFBDeFRjMTkyZnRKWUxDMzhZWXRqT0E4Y0lkcUxJaXBqaDFFZFQ0?=
 =?utf-8?B?NHpYTUVVMFZNNlhZWDRuOExBZGU5M2dIUnY4QXhZWmIyc0FRcU1ZY0VReDBz?=
 =?utf-8?B?MDlFQWdiZmRHcGNUSm5sbWJqODRQU2dvL1RYYlNkZklzVTZMcUE3akYyUzZh?=
 =?utf-8?B?Q1pGZjlRNkg1Q3F5dTRQNmlCL1V3bTVIbENJSDdiV0x2OWNrMkZ5S2p1bmpV?=
 =?utf-8?B?MnFEV2g2OGdNVFRRY3EwY281dEZrdlFITlNRREMvM0xmMlBTam8vUWtBVVlG?=
 =?utf-8?B?aExocC90aW5ETnBZWDhCMFpEaUJZVk1wYjBnb21QVWJJS3U5MjFHNVB4N285?=
 =?utf-8?Q?qIsUxySD8kD/RpeulJ9/VLMFh?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 428a0167-3ab5-4952-4e90-08ddbffdaed8
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3320.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2025 22:04:03.8655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Qj5MqnMJWtRZdtK2tXG3tj6UaXSqcPjavnz6h/X6Ywsa81ydYpGtCVIahbWyVYX9yJmFgaO3n13tsEJAp0BOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8752
X-OriginatorOrg: intel.com

On 7/8/2025 11:37 AM, Sean Christopherson wrote:

> This patch is buggy.  There are at least two implementations of ->send_IPI_mask()
> that this breaks:
> 

Thank you for point this out. I should have been more diligent.


> Looking at all of this again, shoving the NMI source information into the @vector
> is quite brittle.  Nothing forces implementations to handle embedded delivery
> mode information.
> 

I agree. There is already some confusion with NMI_VECTOR and APIC_DM_NMI
used interchangeably sometimes. Adding the new NMI-source vectors with
the encoded delivery mode makes it worse.


> One thought would be to pass a small struct (by value), and then provide macros
> to generate the structure for a specific vector.  That provides some amount of
> type safety and should make it a bit harder to pass in garbage, without making
> the callers any less readable.
>
> struct apic_ipi {
> 	u8 vector;
> 	u8 type;
> };
>  

I am fine with this approach. Though, the changes would be massive since
we have quite a few interfaces and a lot of "struct apic".

	.send_IPI
	.send_IPI_mask
	.send_IPI_mask_allbutself
	.send_IPI_allbutself
	.send_IPI_all
	.send_IPI_self


An option I was considering was whether we should avoid exposing the raw
delivery mode to the callers since it is mainly an APIC internal thing.
The callers should only have to say NMI or IRQ along with the vector and
let the APIC code figure out how to generate it.

One option is to add a separate set of send_IPI_NMI APIs parallel to
send_IPI ones that we have. But then we would end with >10 ways to
generate IPIs.

Another way would be to assign the NMI vectors in a different range and
use the range to differentiate between IRQ and NMI.

For example:
	IRQ => 0x0-0xFF
	NMI => 0x10000-0x1000F.

However, this would still be fragile and probably have similar issues to
the one you pointed out.

> 
> static __always_inline void __apic_send_IPI_self(struct apic_ipi ipi)

Taking a step back:

Since we are considering changing the interface, would it be worth
consolidating the multiple send_IPI APIs into one or two? Mainly, by
moving the destination information from the function name to the
function parameter.

  apic_send_IPI(DEST, MASK, TYPE, VECTOR)

  DEST   => self, all, allbutself, mask, maskbutself

  MASK   => cpumask

  TYPE   => IRQ, NMI

  VECTOR => Vector number specific to the type.

I like the single line IPI invocation. All of this can still be passed
in a neat "struct apic_ipi" with a macro helping the callers fill the
struct.

These interfaces are decades old. So, maybe I am being too ambitious and
this isn't practically feasible. Thoughts/Suggestions?


Note: Another part of me says there are only a handful of NMI IPI usages
and the heavy lifting isn't worth it. We should fix the bugs, improve
testing and use the existing approach since it is the least invasive :)


