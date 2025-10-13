Return-Path: <kvm+bounces-59946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F8F1BD69A9
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 00:23:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9D133AA6A8
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 22:23:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C24622FE047;
	Mon, 13 Oct 2025 22:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="myR1Bytu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E732F3620;
	Mon, 13 Oct 2025 22:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760394185; cv=fail; b=tpe3PYLUcPYC/10IE12vNjvrX2Dv2bAwzaeaT/nqPJsYqPuP5A81JMw9IsgOfueHACmhr36ryPK9oFPEOCoFgMyypt97UaFmUMvDnohkUBi09bpbREoRDUkut1WrBneByWViPSb2WeB3WQkuv6L4I99vzc3wlo99s5ZpxZMEeok=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760394185; c=relaxed/simple;
	bh=78p1/yfsjyiWUOqp4jwoRvnA/rG/Oezh7D1M3tgn3H0=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=TQwpmKjxxcu2fkDDrR7TrIExqmRVFB7ExnpREq+G7cv9RPDZDaTHvGm5v6PgVwAM5PpRnuo5Xs/J7rGHcIABMzRgZqU1EC4DzMQAilMKUd0aBxDLrFimtR64xSFwY3+Q8a/96RCslvk62Gj71tq10LRiZG2MIEW1PuM+7c+MWmE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=myR1Bytu; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760394184; x=1791930184;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=78p1/yfsjyiWUOqp4jwoRvnA/rG/Oezh7D1M3tgn3H0=;
  b=myR1Bytuc+khwjWZecHPAmG8mlkjsWeg1mpfkVkQO4V06rGkMoLoA8Un
   erpAZIOjX8IzerBWyPBi3bWjzrs60p1Ic8D442MK9bOEw4nI9VKg3jxjQ
   0FVdfrsjH1jpdhS+ru2tvv7Ui3fDPJK1YfXRvlEuc0YXGBwqByTC7Dw3k
   ZoP1rV9m3Gl5iMelPedDgT+N5RY85iLTZJ85Ga8NKshb3T9RCOc43idmL
   V5BQrc9Tv+54JjFsJSo5M3yqnjdhiv9Au7+TsfxHcmM0fhTZLuPhzY4mc
   iPumHmsQuaX4WYJIl6KEM49LG228EG/Q3SKkAaW/kG51KUAc3nZT/t+y/
   A==;
X-CSE-ConnectionGUID: ohPVTB9pSVm1s3Ymz8yg2g==
X-CSE-MsgGUID: fuSK1m3yTCqcd4OsO3XUhw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="66368988"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="66368988"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 15:23:03 -0700
X-CSE-ConnectionGUID: /T8+6zQcTzWG2YqcyvexJA==
X-CSE-MsgGUID: ieoIhbdBSgi6BagS0BJwLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="181515424"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 15:23:03 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 13 Oct 2025 15:23:02 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 13 Oct 2025 15:23:02 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.50)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 13 Oct 2025 15:23:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RvLWbS0AMQDEJfnxoUfSWbDSkb7ttCD6WLQTeg7tB4b7LIwh21SRYE2B4BvZWS3mN9iaJ60ON7qKis+eirgbhnyXCDRKiaHzUZBqp+0ZGUHyBv5HgtqoKKvTDGzQJds/68vIuJArqQxuXl6ZRe2hKj8GLt4cSayFQA6DDLjU/8KbyNzIXTjLXXKdQ/+0RLkWKtPWvPgB0GWwEtTkMRkKEUsZCVEhpmdvmoflv5/aJGlVaZ4vSDmMnAtoydRSiWZoCTsYVLd3mNiMg8rL0r3XIWpU4YSW+/dAuRrWYlwQtQ3PemfdBqheWp8Ylird8uyHaFp6bWxL2ojJMAcdMK0G/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4p3W0m3BRZU1DBNYU0+bs8k0zp4g4gThMFGz+iRkqg8=;
 b=UrxxAKSgjFa3MP4GCnLUSEZGmNwYzeoolXjYKgDdoek5sBK7cWuY1dQL+4r+2N86h3QJecr+DeSxWdr/2RB94GmgaHoz8SddnqUzBeATn+xrptxGGx70nrExjYi9wFuks4MDAPP+8RWvBZ+VizJ8VSy30A1F0aaEdnkq2lrk+j++XQ3knD3I4fqTgHR7vSXLtGm9QQtEe39SgPW1/d1j3lDJLwPz4EdFdyl7vZUJUaa/+avhSNPK0laKCWd7GfecGWaxWTk9XDZ0p6XCB+UkCVvTQr5zgfj9zKVzzr5CpgvBSynVnNl2Giczy1smLP23iQVUUIZ30BAvgvCHiZFRDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by MW3PR11MB4651.namprd11.prod.outlook.com (2603:10b6:303:2c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.13; Mon, 13 Oct
 2025 22:22:58 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%4]) with mapi id 15.20.9203.009; Mon, 13 Oct 2025
 22:22:58 +0000
From: <dan.j.williams@intel.com>
Date: Mon, 13 Oct 2025 15:22:56 -0700
To: Sean Christopherson <seanjc@google.com>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	"Kirill A. Shutemov" <kas@kernel.org>, Sean Christopherson
	<seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<kvm@vger.kernel.org>, Chao Gao <chao.gao@intel.com>, Dan Williams
	<dan.j.williams@intel.com>, Xin Li <xin@zytor.com>, Kai Huang
	<kai.huang@intel.com>, Adrian Hunter <adrian.hunter@intel.com>, <aik@amd.com>
Message-ID: <68ed7bc0c987a_19928100ed@dwillia2-mobl4.notmuch>
In-Reply-To: <20251010220403.987927-1-seanjc@google.com>
References: <20251010220403.987927-1-seanjc@google.com>
Subject: Re: [RFC PATCH 0/4] KVM: x86/tdx: Have TDX handle VMXON during
 bringup
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0205.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::30) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|MW3PR11MB4651:EE_
X-MS-Office365-Filtering-Correlation-Id: 30424b43-00d0-4737-7869-08de0aa7102e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZVhaWU92SlZVU3lqemc1OWI5OGFJNHRpL2FQUmpQM0t5elNoN3dZYUR3ZzdO?=
 =?utf-8?B?VzJZTDRsLzV2SzJ6RlZLcnp6UkcxRGFjeUhib3p2RXV6a1QxeXVuQndySndC?=
 =?utf-8?B?dUJZcVA4Z1grVTBFcDRReU1QcktrVFU4OGp0MUNrU3R1OGRzT0YwUWk1dnh0?=
 =?utf-8?B?eFF5S2RNUU84VE1EeFNXaDNmMi80QlV1dXRuMUZ6blQ4a05aRXpJRTdqRU5W?=
 =?utf-8?B?OTZuczNuVlhLWWh6S2FRWUljak44aUJTSEFTVEMxZ2Q4alhuU1o4MFQrSm11?=
 =?utf-8?B?MEw5M0tMZTJVY0d4cTl2REl1SmtHSmthNnFCdmt1dVdhV0daSWRqUC9QRWxU?=
 =?utf-8?B?cnA0S0dXMmxObHRDT05NdFU2K201Wlg5VmxpSUFMc05xbjhFUm91L0EyZVNI?=
 =?utf-8?B?Z1creGFzakt6L3R0TWxPQ0lSblo2dlp5MkFndkFpcjNNakNlTVJ0bXZnamho?=
 =?utf-8?B?OGpuMGl3VHhiRTZOeDJBZEh0SThyclUzV2Z5WHVoYUpaYmowSFpyVGJJbjNv?=
 =?utf-8?B?M08zQTFNYS9CVVlqK2ppNFphYW1QSGdaMFZ6MVgyWEJMS0ZuMzdwdnFUTi95?=
 =?utf-8?B?K2UrZGlyNk1LTVNjY210czhYakJVRndNQmlLbEEvNFlkSmNXcFRyYXlaRTJs?=
 =?utf-8?B?eXhMa2UvU2MvanlYNDFySXRESWkrNFBBN0RtRHpRcmhoTjlMa3BEYmF6TFZs?=
 =?utf-8?B?NEtjMVJyU2cvZ3R3cjNScGIrZklQOEtKVHRjUTJ6ZWJ4WGJhWWtLYTJWNnVB?=
 =?utf-8?B?OEk1aGV3dWhZSlZsYXpLVHFDWU9IbVpoS1N5V01ZcTZMZVZibFBxYWhrL1B5?=
 =?utf-8?B?ZUhIUzl2YkV4STdoRWRIejlwV01IbW1YUlZqOTkvNERVTUZxTVBvQ2dyNXBy?=
 =?utf-8?B?eXZGTE9KUW93UUYyNHJQdC9ESUpUamViRU5zZDdTK1BiVVAwSUM3dFpOVWZI?=
 =?utf-8?B?Z1I5U3BieHo0bmVYV2J3d2MySExTaGZsdFJ4R3NveVhJSHB1b0ZaT3BKOXJ3?=
 =?utf-8?B?WUFhbFovenRmWGFNbDFBOW9rcWNMZEI5ZmlLRnk3M2hROFM2MHhpdDI1R0pQ?=
 =?utf-8?B?U3IzMlk0aUovZ21uekFmWjRybW0zdkg1RDhPaGRuaENEdFlPd0swSTBSS05F?=
 =?utf-8?B?SFFPcUhlZUpKZDM1OVpkUFRWRU5tZ3FQeWNDM3dTMUozbDgwaWtHYUg0SGR1?=
 =?utf-8?B?MmxtNXFGZGg0WmNUYVhsUUR5aUdVaGg1V0Q4ZzZ2R1RVb1hzV3FuN1FEWGxy?=
 =?utf-8?B?U045QnZTa0RyaS8rMmdBcU5DNmc1S2JJMW1CdmNKN0NJNTJPVW0zVmdPaklm?=
 =?utf-8?B?ZlFJSUtQbkZTbFZmbHRQM1hySm50WCtwcWkyWEZhZ1A1U2M5TWltYUVMSzQy?=
 =?utf-8?B?enhqSVlPU2k1Z256TkFscWR1aEJoK0RBMGpqRlI5OGRJaTRGOHF4YVVyRXJu?=
 =?utf-8?B?MG5qZGFTYmFENUJNUi9iNGpieGJrcFA5RU44MHhLVU1uQ1ViamhqeGw0WFZX?=
 =?utf-8?B?bjBDb1g2WHdYaUs4Z0tYdVh4WjduYmNvdGVKWExxa0F3MTlFL0toS2ZHRWEv?=
 =?utf-8?B?c3BsYVIvS2JCL2dDMzVnVmdkbTg1aWo4UEpHOTEra252MVI2Q0RsWk9NcENG?=
 =?utf-8?B?NXdEcXZEM21ydUtadkJydzNpNEU3U0hGRWhIWXMwdXNkNEl0NjVDRDZLRWtZ?=
 =?utf-8?B?Y1JqSkc1WTdmMlRpV3dIemJnRXRMN1hubEFuYmwxZHFGbUpDeFNSWXRtSW1C?=
 =?utf-8?B?UlJTV2pxdktaa1F1YzN3YmhEZnk5ZnZLQ3hXYmFZNjhCeE56c01mYlBaeXZl?=
 =?utf-8?B?TzJ4T3NvS1dwWHZUNU9veEk4SE1wWWNtS0VRV0IzZUs1ZUlWOHZJaXNYUDB4?=
 =?utf-8?B?NEppUkVwWVdGK0UycjRweXd1RU43em9TZWJ0MkJjbUZuSXFHak9NUXZvUnFO?=
 =?utf-8?Q?lc/WhOn/eRwM1yTWojKgtullT2n5YbBC?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YnA0Zm1MRHZUYkFtVTNKbHBvS1pNVUZCeEtsK1JGS2Y4NTBPTlJTazd3Y1lL?=
 =?utf-8?B?VFcyNlNOb2JZUFovbTJPMTZsZlUwZmdrek9Bb25UZFRkdm1lUFJkV25QSUtT?=
 =?utf-8?B?Z3NhdjFyY09RVXE3Vm9Hd2tHWW9Vb0dnb2Z2VzBxK3lNaEFKd200aithaDhF?=
 =?utf-8?B?dDhQb0Z2cnFLR2o4dmhBKzNRcUoweGluWjJpVnk1UTkrYUJrNnFOUTdtMkQ2?=
 =?utf-8?B?L3o0bHArRTdVa1lNWVVTT1BZcEc4Y1lxTkVZdFpzWXRHaE42YWZ6Q0E1QUJi?=
 =?utf-8?B?MkxvaE5SQmhFZHVBc3J6KzVuWkpES2dCZ28rQ0ZuTWpsOGRZTVZQaWVpdFV4?=
 =?utf-8?B?Ynhteng4dVcwVDEzSWYzcGlMNnJ3Qyt6aXF5anQ0OU9mTEM5V2sxdnVZcHlq?=
 =?utf-8?B?VTlvQnRKRHBmZm43ZEwxclJkZzVoMUtYdVdMNW52eXE5TERxbE8xemlVYk9S?=
 =?utf-8?B?Y0VOUHdpZ0MyQlJ0OTBycmVtK3lJODdDZnFIWlovbGo5YW55Q3pHcXFZZXlP?=
 =?utf-8?B?aWd5eStvV2hmWXVXc2pUNkNmTHNTSHdIekxCd29WR2pNVlJ2SG5iRk81QzF3?=
 =?utf-8?B?azQybDVCazJQd1llRDFEMTVoWFQwY2VwQldqM1k0Z2dFRXB0K0JwWHEyNTFZ?=
 =?utf-8?B?RHQ5Y0FBWkZubUtRVXpFTjVvcEZWTHZGR080ZDhHU1FzcW13eEVQTERwTTFx?=
 =?utf-8?B?VktHM0g4ZFN5eUNtSUkyM0lCQjk5UlJsbE1leGhPbnE2ZW04SURrOXJqRmcr?=
 =?utf-8?B?Uno5WHdzYytqVktOVUpwOWdYWFlJaTNKZ3BTUk80dStOUEJrQjRqUlFFU0Y4?=
 =?utf-8?B?VmR6aGFna3NFNUtwY3JXMXN3YkprZFZtUjhKR1U4eEpmdi9kYmdMdFJ6Zzk0?=
 =?utf-8?B?RWhrLzQ4TG9Ub0tGaE94TzFxb25zbk16N2h6ZHJSbi8wWFQ3VlhkTWw1VEk3?=
 =?utf-8?B?ZDQrbE1JTUZWSDNQMUNXYVk1L3BxTjdXNmhSUnZRN1NpNDBQSXVrVGxMUERP?=
 =?utf-8?B?VWpPRWppSnBCQlFod1o5TS81a2ZmMGVuanFIS25KNHF2RzFyYUpmUithZVBM?=
 =?utf-8?B?b2x2SXZHSUhYdmVrSk01UEpKZ0JlZHNRblV4S2gwSER6ZlQxUUN5V2ZsdGZJ?=
 =?utf-8?B?dW4xangrK29yUHovTnorbzUxYWpEWkFYUWpDWitOVzRHMVhJOFdiRHJLZk92?=
 =?utf-8?B?ZEtxNjlQVzh4dGJyS2lLVVRmdkhsV3BJRi9SN2d1dTRnMXd2ZFI3dnVLNDZZ?=
 =?utf-8?B?M1hZdWFDSktmRkkycmwzTUNIUmx5N3hteVk4d1VVZHRDTm5FOUs2elVycmk5?=
 =?utf-8?B?bm8wNFBGWGtxQTJVOTJCT0VYait2Zzc2MGgxOERHaWJtOVNGM1kyVEkyZGNz?=
 =?utf-8?B?UzlLaE1FTUpjb0tISzZtNUJqb01aNGZwY3pzZFRZRnozTTlwWE5xaEUrNWlj?=
 =?utf-8?B?dzV5UzRxMFdEVktJM3E5aitmYUQxdjJRWmFVWGJYOFdVeFlsSy9WYWUvZkFi?=
 =?utf-8?B?NFV5b3FsOFhhOHJNVEZpVU9KSjRTaWZmZThUdGtxaFU5ZU0zMU1iRmQzSVlB?=
 =?utf-8?B?Nk5UdHZUVmI1aWVkeHF0MCs2bUJSOG9xZWtIWXpMcUQ2d1FqVXdJaDA4VjJq?=
 =?utf-8?B?L0ZCaG5nT1hiOEVOMm1Gd2c0ckN1ZnlsdjlubU1kZk5tenFaT2pJUTBPb2tq?=
 =?utf-8?B?U1RFbzVYdG1CM3djNitIdHdhdFhkVkpDSUE1WWlNUWRlaFBuSjBDNlZlWTNT?=
 =?utf-8?B?UGNaeEpoN0VzelR5T0dJdTVGZVBnTHA2WHNidDB0NWdQdUFYSm1RWUpkSVdM?=
 =?utf-8?B?WGxneXJ2RHVUYmdjQVBqRUR4MkZoR0dwZ0VJQXczME8yanJFSCtCUysrNU5O?=
 =?utf-8?B?ODNMc3cyR1A1V3ErYlZjR1Y1RUkxc01tc2ZpM0JWSmh0dkx0aWVlWlV0RWxS?=
 =?utf-8?B?SURiOHRNZnU5UCt2a3ZoVVdjMzh2NmhlSE5OUU4wczRpNW1DU1JXOFA5YmRr?=
 =?utf-8?B?UXMvKzZ1aFh2LzdRZ1p5a0haY205emVtNGtjSm5wOUEyUmlpNXJvVmQvOFA4?=
 =?utf-8?B?UXI3T0taanU0SVU0bmZ3TVJDUEs4cG5sek16UE1SeDVKdmRiQVJzVmdnY29N?=
 =?utf-8?B?dXdmYVhISlI2UGV0YkRlTXVRMWRqdndvVkxHVkpCNndUaEpMTFJSR0dZcGdB?=
 =?utf-8?B?cXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 30424b43-00d0-4737-7869-08de0aa7102e
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2025 22:22:58.3045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9IfVvnWQGGrg+9rSYS1hNSSwDTP5wyLvgiaMvKgsna0Aci225XbeFiCxf3K/UW39P9qsXnOwXN/vLknG0vjXXfeddPbJ6Bv6U/mHVZRsHwM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4651
X-OriginatorOrg: intel.com

[ Add Alexey for question below about SEV-TIO needing to enable SNP from
the PSP driver? ]

Sean Christopherson wrote:
> This is a sort of middle ground between fully yanking core virtualization
> support out of KVM, and unconditionally doing VMXON during boot[0].

Thanks for this, Sean!

> I got quite far long on rebasing some internal patches we have to extract the
> core virtualization bits out of KVM x86, but as I paged back in all of the
> things we had punted on (because they were waaay out of scope for our needs),
> I realized more and more that providing truly generic virtualization
> instrastructure is vastly different than providing infrastructure that can be
> shared by multiple instances of KVM (or things very similar to KVM)[1].
> 
> So while I still don't want to blindly do VMXON, I also think that trying to
> actually support another in-tree hypervisor, without an imminent user to drive
> the development, is a waste of resources, and would saddle KVM with a pile of
> pointless complexity.
> 
> The idea here is to extract _only_ VMXON+VMXOFF and EFER.SVME toggling.  AFAIK
> there's no second user of SVM, i.e. no equivalent to TDX, but I wanted to keep
> things as symmetrical as possible.

Alexey did mention in the TEE I/O call that the PSP driver does need to
turn on SVM. Added him to the Cc to clarify if SEV-TIO needs at least
SVM enabled outside of KVM in some cases.

> Emphasis on "only", because leaving VMCS tracking and clearing in KVM is
> another key difference from Xin's series.  The "light bulb" moment on that
> front is that TDX isn't a hypervisor, and isn't trying to be a hypervisor.
> Specifically, TDX should _never_ have it's own VMCSes (that are visible to the
> host; the TDX-Module has it's own VMCSes to do SEAMCALL/SEAMRET), and so there
> is simply no reason to move that functionality out of KVM.
> 
> With that out of the way, dealing with VMXON/VMXOFF and EFER.SVME is a fairly
> simple refcounting game.
> 
> Oh, and I didn't bother looking to see if it would work, but if TDX only needs
> VMXON during boot, then the TDX use of VMXON could be transient.

With the work-in-progress "Host Services", the expectation is that VMX
would remain on especially because there is no current way to de-init
TDX.

Now, the "TDX always-on even outside of Host Services" this series is
proposing gives me slight pause. I.e. Any resources that TDX gobbles, or
features that TDX is incompatible (ACPI S3), need a trip through a BIOS
menu to turn off.  However, if that becomes a problem in practice we can
circle back later to fix that up.

> could simply blast on_each_cpu() and forego the cpuhp and syscore hooks (a
> non-emergency reboot during init isn't possible).  I don't particuarly care
> what TDX does, as it's a fairly minor detail all things concerned.  I went with
> the "harder" approach, e.g. to validate keeping the VMXON users count elevated
> would do the right thing with respect to CPU offlining, etc.
> 
> Lightly tested (see the hacks below to verify the TDX side appears to do what
> it's supposed to do), but it seems to work?  Heavily RFC, e.g. the third patch
> in particular needs to be chunked up, I'm sure there's polishing to be done,
> etc.

Sounds good and I read this as "hey, this is the form I would like to
see, when someone else cleans this up and sends it back to me as a
non-RFC".

Thanks again!

