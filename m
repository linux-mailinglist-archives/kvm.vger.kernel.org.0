Return-Path: <kvm+bounces-46951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 086F2ABB443
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 07:01:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EF94E189410E
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 05:01:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA87F1F03F2;
	Mon, 19 May 2025 05:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AEkRQxf+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF721E98E3;
	Mon, 19 May 2025 05:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747630863; cv=fail; b=N6JKlF5UYiGKsT10CEtTyBsnWZ7Lc/wdam4oV+LpM2mRn0C8zgnuK9sgnF57MKBUTOlz9ZjiZtdsZrzgcF+csUsCT/VpOzT6i1xAWoc0xNBQq3H7VeF+uM1AKbYRknIE0X0pvNuq2Un7hpAUcr83Ste0/EVjpyS0arZvnHEmpaA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747630863; c=relaxed/simple;
	bh=yMcgNW904G7iUW6RtdaAbYGfvz5r/U4HRlr2uuCqddg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DOw4CsIOYmpw4FQZHnCyzADzGLtPqIWip/HG/5/uSBRsEOEOMim1M57EpOfXrLpVM7zx98JAxhZo9Gfrr9ExhS5cr20cAlB39xEu2QgZSCeTq5K8XAAM6VEnysyvHn+O7nwg+B5BmjRQCRIoz0qjvzXLAoPHevzHv79ZLYdIOxo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AEkRQxf+; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747630862; x=1779166862;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=yMcgNW904G7iUW6RtdaAbYGfvz5r/U4HRlr2uuCqddg=;
  b=AEkRQxf+feGuqOEkw0HtQdrymL7j8rCPJet1HekaxmSS/sj628MSYTUb
   H3jovdW6excPUo8d91rXWUL7VECsbkLl/slZX0+iPa/QInlT0s0o04Def
   u1LSRwRLNCM2qyI/NeOgkw52rEbC1qY4sKCTtElR+aDaOZeCa1HdMctDp
   WOwaQ8MeKQIYtpugM9HAYm3IJPniTkX/C+DIZsu+LspmzRFppMByaSyfc
   QETzwQMdrN262favfKAL0Q8keaol7Nz+fu2VRe+nZFqNE+wJe5KnyjHYL
   nE4uMm6Py8UR2qMsO3v0QMtUxCJxEeo0DTY/2zwe32Itas/68nwRWF9aX
   Q==;
X-CSE-ConnectionGUID: nnJkwBsORi+glrd0lw/x8w==
X-CSE-MsgGUID: nqXLlS7FTUm56+hvZZCKSw==
X-IronPort-AV: E=McAfee;i="6700,10204,11437"; a="49668470"
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="49668470"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2025 22:00:57 -0700
X-CSE-ConnectionGUID: /dYnhwFVQHuisJJnoW4+nA==
X-CSE-MsgGUID: TaUKtlhdRLeTTsZo+p1gVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="144125551"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2025 22:00:56 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 18 May 2025 22:00:55 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Sun, 18 May 2025 22:00:55 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 18 May 2025 22:00:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mia/H1lobVXqYXIcjf0G+khKOa/S4SpzkntucoHOm1+tJSbIH3tLS5twLLc54RgIvlbn7GcnV1z5vOuaR3Y3xcW8azux2d7rJiIb8l4ZwDzmJhiyxKDXwQY1WKs/+XbA+9yDlDwwBwdmX2VO5mh321DDpliq4QoxWLqcdXb65eEF+61ag6pwUtv+d3cz9mDlxLgbKtlJu5k6/rO7fnKRg6Srx+Nw1yY8KIhdijHMCXWEah7CV/fiK99S9y0sY48bHCB/OvW3gS9SunzxcdqFPt7lUkIyIWMLzBm2T8a1ExEmFy26T7JhA/QQ//aJS87ERk3Le52azHwQqs+DXiaOXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yMcgNW904G7iUW6RtdaAbYGfvz5r/U4HRlr2uuCqddg=;
 b=CV8vAuPj+xup3ME3N5HL12mFxJ0d6Hj23riRlwxSuQ/BVJF1jcjOEvjCDAhMW3wMEh4Tj1Lq7yeFviptnkPU+8d0V4TEAUeFylAyTpesu7Z1tza23LvUcfdYnp/qwOwPpoVj9CP50SoEHkKsAybmv6MKbaDUZ75PCJR9A0vUKUOTIpsiJmTrhVmTnTz2esEq9wE+xVC2vQ4ENbRX/ROWsSYsFum3argJqNstz89zX+jBTh23aeniUcV3YJz0JTp2XLE6jn4mH1DKrxQiV8AdN0k3uKGie12CSJroS8DE1cBTCnw+h24+e19EqDF29xCVoXkL11m87sGnVvpdzQvZLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by BL3PR11MB6316.namprd11.prod.outlook.com (2603:10b6:208:3b3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Mon, 19 May
 2025 05:00:49 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%3]) with mapi id 15.20.8746.030; Mon, 19 May 2025
 05:00:48 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de"
	<bp@alien8.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>
Subject: Re: [RFC, PATCH 08/12] KVM: x86/tdp_mmu: Add phys_prepare() and
 phys_cleanup() to kvm_x86_ops
Thread-Topic: [RFC, PATCH 08/12] KVM: x86/tdp_mmu: Add phys_prepare() and
 phys_cleanup() to kvm_x86_ops
Thread-Index: AQHbu2NdArquWBZL3k6ZxRzni0e1trPFhLGAgAM9bgCAAMm8AIAFRXMAgAJ+QICAAHCQAIAHvxCA
Date: Mon, 19 May 2025 05:00:48 +0000
Message-ID: <dfe459c48f3b73cfe2d5878b0804f8d01d13e0e7.camel@intel.com>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
	 <20250502130828.4071412-9-kirill.shutemov@linux.intel.com>
	 <aBn4pfn4aMXcFHd7@yzhao56-desk.sh.intel.com>
	 <t2im27kgcfsl2qltxbf3cear35szyoafczgvmmwootxthnbcdp@dasmg4bdfd6i>
	 <aB1ZplDCPkDCkhQr@yzhao56-desk.sh.intel.com>
	 <2bi4cz2ulrki62odprol253mhxkvjdu3xtq4p6dbndowsufnmu@7kzlzywmi22s>
	 <8668efe87d6e538b5a49a3c7508ade612a6d766b.camel@intel.com>
	 <6b5pkr4eh3l6c2ovp6t2m7phonp4kr2z5k5facrsktcmsyztqo@2hjgi7c455km>
In-Reply-To: <6b5pkr4eh3l6c2ovp6t2m7phonp4kr2z5k5facrsktcmsyztqo@2hjgi7c455km>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.1 (3.56.1-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|BL3PR11MB6316:EE_
x-ms-office365-filtering-correlation-id: d5ab420e-e001-4877-5d0e-08dd96921f2f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018|7053199007;
x-microsoft-antispam-message-info: =?utf-8?B?Zk1acXNGeTBvWXhPVytHU2s4dlFiTlk0VnVHTjZzNUtVQkJlQWtZcU90T0FK?=
 =?utf-8?B?L1UrS2FiUDBPdExSWWVka211UnArNVA4T1YzOW1tOGZwdjFrRE1mU3U4czd5?=
 =?utf-8?B?a21hQXFLYnpZeVpZcFVrRGh5Z3Q2aFQ5aUlkUFkrU0RKRXgwak9LYU5oQ1Zo?=
 =?utf-8?B?S2N5QkZSMEZGKzRJelh4aTZCVHBoYy8wR0JQV05FQzJlU25XWmd2c0RabDNB?=
 =?utf-8?B?ZytGdVZONlZaL0dzK0x4ZkZuVmtrcmtwOHdjSHFsRUN0a2d4WEVIWEgzSmhQ?=
 =?utf-8?B?RVUxejhkRWFkbGhSdUlPT0RmbDJxQkJvTmdmblUxOWhEOUZQYjVqQkk5UHhK?=
 =?utf-8?B?ekNwd1Ztc2s2NnJNQ01FNXBON2VEb1Vubk1TVGpVWTVXcWlIRFJYVHc5bm55?=
 =?utf-8?B?bzJzdGo3MEJrYXl2aW1lUnB6aFE0a3RBOTVWT2o3YW9tL1NPdjNycU9kTWFD?=
 =?utf-8?B?ZCtHSU9yOVRQcE9ON3Y2bENza0l4RUZXOVZmRi9HMGdldmlSTHdXUkd1LzFr?=
 =?utf-8?B?MVJDcTNSMDM3akdoTXR4MVhPUTRqRU1Ud3FaQ1BSM3EzNkt4dElyVFF2Y3Va?=
 =?utf-8?B?blFBRnVSUisrQ003eDNGbEpyNmNSS1dUY0hhOG5iMTljUzV1SmU0aXZhaXo2?=
 =?utf-8?B?V2swRVV2K1hFTU54SmZGRlNtcVRUbkQ2M0kvUlU0QVk4M3RoOVZvNTgyZmli?=
 =?utf-8?B?M1FCak1hMkluTHZOYUM5R2VuMitzclFON21UdDlGK0hTbC9UQ2VxUTVncTFY?=
 =?utf-8?B?aDg2MDE0cDhZOXpmaTFNa21vTUUwcmdoOHR3TmJMazZyUEQxbzI1NHNURmsz?=
 =?utf-8?B?QlliRmhBMnA1NE5aWm5kWTFFbDZwa1hMc3ZkeC9SbHBlV2dWcHZlUTdzY3dq?=
 =?utf-8?B?S3k5TjRjNWx2cDkzYld1MjBzMUtYUzc2Wko2T2dLMHp4OFMxTWNzUzdtMlVU?=
 =?utf-8?B?bUtNb1Z1NFAzeHpZQXdyRG01M1F0ZTM1MnJRVktTK2tURDRGaSttd3J1WWU4?=
 =?utf-8?B?aHo3ZWM5WENaS1hJd3paR3RjUVNtMitqZHJTTnNyWUowYk5ZVzUrZDZZYVBu?=
 =?utf-8?B?QkJCa0FNd3h6S1h0emx4OC9MNy9MRUwxQnF3bllIV1k4UUtCb2cvYm1JaTNj?=
 =?utf-8?B?UXJQbHdKVU1YYkFmTG1iemxQblQxRkdhNTFXd25DSWpoR2tXSXE1eUl6T0ZE?=
 =?utf-8?B?OHRSTmEyeWRoTE84cGlvVFhtb0VPcjBDRTkwS3Zodm1yMVRoWHE4YVEwZHJh?=
 =?utf-8?B?dWF2WmQ2UXgxb09uTTlYZlBUbTR5UlplNTJaWGJNNTdBc2lpQVR6bGhvd2FW?=
 =?utf-8?B?UWRHV0FPQzlOZFV6amY5SW9IVVcwL3Jha0tqa0tzd0VES3gxL3pkOWxXNHFI?=
 =?utf-8?B?VDZHWWZYUXArMm9Bbk1UdkdIeVBaTWR2bllnL1hQL1V5MUxkS0dIN3dFc3da?=
 =?utf-8?B?ZVhDZmVUdGhxL3B6aExCVDhUOWZBdHNVSmJxb1U5SWdDR0hmNmpFZWF5TkRl?=
 =?utf-8?B?c2R4aGNWcFVLcEJuVWxiYUpXc1JPRHZQWENQd3Y0ZWMycTFRQ2FhRWZZUm1v?=
 =?utf-8?B?b2xJeHNiN2xxZHRSWVVKYWJQVCtreHZiR2ZHZVNVWmZEb2g0YUpsVlRnMTcr?=
 =?utf-8?B?ZkRQYTk2ZG0wUTltKzFIaGk0MWJYbzRaRXNWMGJ2c2lQT2J4S0ZacXErVits?=
 =?utf-8?B?dGhjenF2YmFkVDM0M2h5THQ1T1RlbWZnRG15UDNpMi9EdWU0QkhGRExKU29M?=
 =?utf-8?B?OHNkNGU5d2MwN2dTYlRrdTVJTUVkNDU5QzJvUEJkenhmVGJrN05RUWRRZ29m?=
 =?utf-8?B?Q3BzQ2VUT1RYVWJGdXIxZCtlNENHNTZmRWxxalRVVW1QR04wWGVVNUNodEFG?=
 =?utf-8?B?WnY2dFdneGU1OWF4dGlaTGFUak1lcExWRCtBVCtIZE9ncWxpZkppUk9mWXRs?=
 =?utf-8?B?MXVLN3dibDN1MWgreVU2bHZ0OGtsNWo4TGNDd1BMcjVoNk9PVTU1UWtuQVpQ?=
 =?utf-8?B?SmtwbTF2bGlRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K3R6bGpGSlhmSHhvWVVVMzRVeTRtdURReEk3NFlZQnNSemhBUkNWelM0MzZk?=
 =?utf-8?B?YUF3Q3UxUjRTaVlTcXYraWdDUlFBbU1iaUZkMHRzUEJ3Qzg3WUVEZjd5aVdG?=
 =?utf-8?B?RnZNZGJyVCtORjhpRDd2T1ZDSnhtajVLeXFqWTlYV21oTEJqOGJJMzhJSHhv?=
 =?utf-8?B?eDh6OHlUTXNzN013ZmJXUmduMXFJUU1iU0hpUG40dFVJVStpYmgrVGFDSGgr?=
 =?utf-8?B?a2pkVnBVZFI1cndicnhDYUVoMU8rVEl1bnA0dHNGVDltT0VOcFVZRTIvRjlq?=
 =?utf-8?B?ZjBaNmUvK3NrZ0o0VHp0dTJ5QzUvQ2xxY3g3aHZhOTV1UmgrUG9vc25Fc2x6?=
 =?utf-8?B?ekUyQUNoVjZEdDBpMzU5M0FPa2xLaFBCaFFwN0V6QmdYL2I5cFY3N0VleE1G?=
 =?utf-8?B?emR5NGh1Z051Z1hhWFBYRWl5TEtJdUFxSG9SdmExNDNqSTl3d0pEYURMeStW?=
 =?utf-8?B?UHYzaFpaZ0MwNVF4anNMN0JNTUZBVVg3TUhiTFFqM21wV3hTYUlIZ1RhcE5F?=
 =?utf-8?B?MEMvRGpReXJONzZ3ZG1Icnl6cFJrSENqTmpYeXZDS3hGVzdRaHlJT0Zzc0U1?=
 =?utf-8?B?Um5CbHM2WHJDRFRwWWV2c2EzS0dLdUUvOUZBYkdXbXAycXduc0UydVREODFO?=
 =?utf-8?B?aDBWcHF4TTdKWC9VL0dubUQ3a3RvcGhsdy9TcnNtMlMrWTBaalZ0OGl3ZGNG?=
 =?utf-8?B?MGI3K0MyU1RnQXZxb0NxdjdBNjZTWG5qM1V3NVpJM3QrUHNleUJtb2pJSXht?=
 =?utf-8?B?dDhNTXdxc0ZnYk94ZHlYMDJ5RzNIL3BveUd3elRJYnRRcnlBY3p4b0JJSDhy?=
 =?utf-8?B?K2ZYZmJtRE9vd2NyQkFaZG94S3hVTm1LRXNRT1QrVjdIWDNqdDAyTjBZaWxx?=
 =?utf-8?B?aGNhU21jZWNCdFFJTGxrS0c4ZUs4TWdWbUFqWU8zelNGaUpHN1FtV1lVY3dl?=
 =?utf-8?B?eDVsZGxMSDZqSEc3aWwxTUxUZ3VVMCtHZ21WR2NSTmQ3WGNpYWw1bnUvSlFx?=
 =?utf-8?B?SHNkN0hvV0pteG5qZVdYZTVLWjM1RjZZa1pGTHhUOElCWjZpOFN3U3p2VkdY?=
 =?utf-8?B?Yi96VUdHZ2JSVGtMVTNVZWNXbkczaFNMaDlOY0FGWGFjeW5QZ2tGQVNxSTU5?=
 =?utf-8?B?R09DNTRZcEcyWGdkMFBvTVJQM0FUU242UHk2d3pWOFQ5ZnplSWRRc1IyNk4r?=
 =?utf-8?B?dWE4MEQ2QWM3SDFTay9VWS9FL2ZWSEZoT1ZJc29aUGsxRHRid2tPeGYzUGhs?=
 =?utf-8?B?K2pRb2F0d21takVyN0ZJNkRpUTdGRTNVVi9BcERTcVRPV2lEZytDQ0ZMZXVl?=
 =?utf-8?B?V3NZcFdRMVE3U3N4Qjk1c0dqOTN1MlFybDFiVWNieHhBSHM5dGF3S1Uvb1J0?=
 =?utf-8?B?R3lKUkJ6TC9yTXptbHNHZDZkaDlIOVBqRU5Ebk5sNmU1eE5pd1VoTm5EMWNZ?=
 =?utf-8?B?SE5Gc2lEekMyS1BxOHY4TGNnVTh0S09sMUIwZ3pjM3FadXF6VTFoSmRHS0xy?=
 =?utf-8?B?dlpxclBRMVoyUzFPakUxek9LbktZUHJYRzRwck5XeHVxK3lRQUk0NExhRHBl?=
 =?utf-8?B?eXJWbitiRmVyVnhDdWk0RHM3WkptUktseFFPMlRaOWU2ZWxKWjNNTW5JdEtT?=
 =?utf-8?B?cEZscDA1czUwNlo5SitPU2ZOYTZNUkNwUjhrait5ZG5udGgreXZGZ1Q0cmlD?=
 =?utf-8?B?VW1zdWJJUkloaWdHVURZMzJqNklYYW0xWXdPMFMvTjN3NTdvcG0vWlZSSzd2?=
 =?utf-8?B?aWNWS2VqdHU2VFNxYUo2VGtCRnpRVW9DbHlNQXI3Q0d4Snd3M05uQ0w1Skhl?=
 =?utf-8?B?d0FCaEpGUWRhWnd6OUd6VXljSkdFSVlHUFVBY0Q4QlBOOVZ5ZmtodnVabkhw?=
 =?utf-8?B?QVVVVStvTVpmOVFueGl2RCs2TmlDUXJyZzJjUU9DK1FHK1RxUnNMWXM1TFJh?=
 =?utf-8?B?WUp0WHdKbWZYYVdGeHRpMU84TnFJSHZhbFBqS1ZWNHJvVkQzRzBzaWhJM3FG?=
 =?utf-8?B?OHR0UHNKRVFpZE1IbzNURjFXOC9pUVBhUlFsZEpKTGgzbEJzMTFUWnU0NDZG?=
 =?utf-8?B?K0g5b0gwenRUZDVNclFHY1ZiL0JjMHJiM0FzMGtKR1VmRXkyN25vQmxjRmh6?=
 =?utf-8?Q?gSyMJJiMmu5fTD18ENxSm5t1d?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <942D55B6C92C2F489CE43904D2DFEC89@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5ab420e-e001-4877-5d0e-08dd96921f2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2025 05:00:48.8503
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C5h7u3LMR/H3X9cmSY9BT/Gy+/xwh6vTug3Eb+FnWhfpQAY3GkQYAcL6zEoy/thJ2JM0g90AiYugTmfuUFmtow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6316
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA1LTE0IGF0IDA5OjQzICswMzAwLCBraXJpbGwuc2h1dGVtb3ZAbGludXgu
aW50ZWwuY29tIHdyb3RlOg0KPiBPbiBXZWQsIE1heSAxNCwgMjAyNSBhdCAxMjowMDoxN0FNICsw
MDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+IE9uIE1vbiwgMjAyNS0wNS0xMiBhdCAxMjo1NSAr
MDMwMCwgS2lyaWxsIEEuIFNodXRlbW92IHdyb3RlOg0KPiA+ID4gT24gRnJpLCBNYXkgMDksIDIw
MjUgYXQgMDk6MjU6NThBTSArMDgwMCwgWWFuIFpoYW8gd3JvdGU6DQo+ID4gPiA+IE9uIFRodSwg
TWF5IDA4LCAyMDI1IGF0IDA0OjIzOjU2UE0gKzAzMDAsIEtpcmlsbCBBLiBTaHV0ZW1vdiB3cm90
ZToNCj4gPiA+ID4gPiBPbiBUdWUsIE1heSAwNiwgMjAyNSBhdCAwNzo1NToxN1BNICswODAwLCBZ
YW4gWmhhbyB3cm90ZToNCj4gPiA+ID4gPiA+IE9uIEZyaSwgTWF5IDAyLCAyMDI1IGF0IDA0OjA4
OjI0UE0gKzAzMDAsIEtpcmlsbCBBLiBTaHV0ZW1vdiB3cm90ZToNCj4gPiA+ID4gPiA+ID4gVGhl
IGZ1bmN0aW9ucyBrdm1feDg2X29wczo6bGlua19leHRlcm5hbF9zcHQoKSBhbmQNCj4gPiA+ID4g
PiA+ID4ga3ZtX3g4Nl9vcHM6OnNldF9leHRlcm5hbF9zcHRlKCkgYXJlIHVzZWQgdG8gYXNzaWdu
IG5ldyBtZW1vcnkgdG8gYSBWTS4NCj4gPiA+ID4gPiA+ID4gV2hlbiB1c2luZyBURFggd2l0aCBE
eW5hbWljIFBBTVQgZW5hYmxlZCwgdGhlIGFzc2lnbmVkIG1lbW9yeSBtdXN0IGJlDQo+ID4gPiA+
ID4gPiA+IGNvdmVyZWQgYnkgUEFNVC4NCj4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+IFRo
ZSBuZXcgZnVuY3Rpb24ga3ZtX3g4Nl9vcHM6OnBoeXNfcHJlcGFyZSgpIGlzIGNhbGxlZCBiZWZv
cmUNCj4gPiA+ID4gPiA+ID4gbGlua19leHRlcm5hbF9zcHQoKSBhbmQgc2V0X2V4dGVybmFsX3Nw
dGUoKSB0byBlbnN1cmUgdGhhdCB0aGUgbWVtb3J5IGlzDQo+ID4gPiA+ID4gPiA+IHJlYWR5IHRv
IGJlIGFzc2lnbmVkIHRvIHRoZSB2aXJ0dWFsIG1hY2hpbmUuIEluIHRoZSBjYXNlIG9mIFREWCwg
aXQNCj4gPiA+ID4gPiA+ID4gbWFrZXMgc3VyZSB0aGF0IHRoZSBtZW1vcnkgaXMgY292ZXJlZCBi
eSBQQU1ULg0KPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4ga3ZtX3g4Nl9vcHM6OnBoeXNf
cHJlcGFyZSgpIGlzIGNhbGxlZCBpbiBhIGNvbnRleHQgd2hlcmUgc3RydWN0IGt2bV92Y3B1DQo+
ID4gPiA+ID4gPiA+IGlzIGF2YWlsYWJsZSwgYWxsb3dpbmcgdGhlIGltcGxlbWVudGF0aW9uIHRv
IGFsbG9jYXRlIG1lbW9yeSBmcm9tIGENCj4gPiA+ID4gPiA+ID4gcGVyLVZDUFUgcG9vbC4NCj4g
PiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBXaHkgbm90IGludm9rZSBwaHlzX3ByZXBhcmUoKSBh
bmQgcGh5c19jbGVhbnVwKCkgaW4gc2V0X2V4dGVybmFsX3NwdGVfcHJlc2VudCgpPw0KPiA+ID4g
PiA+ID4gT3IgaW4gdGR4X3NlcHRfc2V0X3ByaXZhdGVfc3B0ZSgpL3RkeF9zZXB0X2xpbmtfcHJp
dmF0ZV9zcHQoKT8NCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBCZWNhdXNlIHRoZSBtZW1vcnkgcG9v
bCB3ZSBhbGxvY2F0ZWQgZnJvbSBpcyBwZXItdmNwdSBhbmQgd2UgbG9zdCBhY2Nlc3MNCj4gPiA+
ID4gPiB0byB2Y3B1IGJ5IHRoZW4uIEFuZCBub3QgYWxsIGNhbGxlcnMgcHJvdmlkZSB2Y3B1Lg0K
PiA+ID4gPiBNYXliZSB3ZSBjYW4gZ2V0IHZjcHUgdmlhIGt2bV9nZXRfcnVubmluZ192Y3B1KCks
IGFzIGluIFsxXS4NCj4gPiA+ID4gVGhlbiBmb3IgY2FsbGVycyBub3QgcHJvdmlkaW5nIHZjcHUg
KHdoZXJlIHZjcHUgaXMgTlVMTCksIHdlIGNhbiB1c2UgcGVyLUtWTQ0KPiA+ID4gPiBjYWNoZT8g
DQo+ID4gPiANCj4gPiA+IEhtLiBJIHdhcyBub3QgYXdhcmUgb2Yga3ZtX2dldF9ydW5uaW5nX3Zj
cHUoKS4gV2lsbCBwbGF5IHdpdGggaXQsIHRoYW5rcy4NCj4gPiANCj4gPiBJIGFtIG5vdCBzdXJl
IHdoeSBwZXItdmNwdSBjYWNoZSBtYXR0ZXJzLg0KPiA+IA0KPiA+IEZvciBub24tbGVhZiBTRVBU
IHBhZ2VzLCBBRkFJQ1QgdGhlICJ2Y3B1LT5hcmNoLm1tdV9leHRlcm5hbF9zcHRfY2FjaGUiIGlz
IGp1c3QNCj4gPiBhbiBlbXB0eSBjYWNoZSwgYW5kIGV2ZW50dWFsbHkgX19nZXRfZnJlZV9wYWdl
KCkgaXMgdXNlZCB0byBhbGxvY2F0ZSBpbjoNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIA0KPiA+ICAgc3AtPmV4dGVybmFsX3NwdCA9wqANCj4gPiAJa3ZtX21tdV9tZW1v
cnlfY2FjaGVfYWxsb2MoJnZjcHUtPmFyY2gubW11X2V4dGVybmFsX3NwdF9jYWNoZSk7DQo+ID4g
DQo+ID4gU28gd2h5IG5vdCB3ZSBhY3R1YWxseSBjcmVhdGUgYSBrbWVtX2NhY2hlIGZvciBpdCB3
aXRoIGFuIGFjdHVhbCAnY3RvcicsIGFuZCB3ZQ0KPiA+IGNhbiBjYWxsIHRkeF9hbGxvY19wYWdl
KCkgaW4gdGhhdC4gIFRoaXMgbWFrZXMgc3VyZSB3aGVuIHRoZSAiZXh0ZXJuYWxfc3B0IiBpcw0K
PiA+IGFsbG9jYXRlZCwgdGhlIHVuZGVybmVhdGggUEFNVCBlbnRyeSBpcyB0aGVyZS4NCj4gDQo+
IFRoaXMgd291bGQgbWFrZSBoYXJkIHRvIGRlYnVnIFBBTVQgbWVtb3J5IGxlYWtzLiBleHRlcm5h
bF9zcHQgcGFnZXMgaW4gdGhlDQo+IHBvb2wgd2lsbCBoYXZlIFBBTVQgbWVtb3J5IHRpZWQgdG8g
dGhlbSwgc28gd2Ugd2lsbCBoYXZlIG5vbi16ZXJvIFBBTVQNCj4gbWVtb3J5IHVzYWdlIHdpdGgg
emVybyBURHMgcnVubmluZy4NCg0KV2h5IGlzIHRoYXQ/ICBBRkFJQ1QgYWxsICdleHRlcm5hbF9z
cHQnIHBhZ2VzIGFyZSBmcmVlZCB3aGVuIFREIGlzIGdvbmUuDQoNCj4gDQo+ID4gRm9yIHRoZSBs
YXN0IGxldmVsIGd1ZXN0IG1lbW9yeSBwYWdlLCBzaW1pbGFyIHRvIFNFViwgd2UgY2FuIGhvb2sg
dGhlDQo+ID4ga3ZtX2FyY2hfZ21lbV9wcmVwYXJlKCkgdG8gY2FsbCB0ZHhfYWxsb2NfcGFnZSgp
IHRvIG1ha2UgUEFNVCBlbnRyeSByZWFkeS4NCj4gDQo+IEkgZG9uJ3QgdGhpbmsga3ZtX2FyY2hf
Z21lbV9wcmVwYXJlKCkgaXMgcmlnaHQgcGxhY2UgdG8gYWxsb2NhdGUgUEFNVA0KPiBtZW1vcnku
IFRIUHMgYXJlIGR5bmFtaWMgYW5kIHBhZ2Ugb3JkZXIgY2FuIGNoYW5nZSBkdWUgdG8gc3BsaXQg
b3INCj4gY29sbGFwc2UgYmV0d2VlbiB0aGUgdGltZSB0aGUgcGFnZSBpcyBhbGxvY2F0ZWQgYW5k
IGdldHMgbWFwcGVkIGludG8gRVBULg0KPiBJIGFtIG5vdCBzdXJlIGlmIFNFViBjb2RlIGlzIGNv
cnJlY3QgaW4gdGhpcyByZWdhcmQuDQoNClllYWgsIGFncmVlZC4gIE5vdCBzdXJlIGhvdyBkb2Vz
IFNFVi1TTlAgaGFuZGxlcyBsYXJnZSBwYWdlIHNwbGl0L21lcmdlIGVpdGhlci4NCg==

