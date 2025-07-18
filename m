Return-Path: <kvm+bounces-52879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EB828B0A173
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 13:01:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 316EB3AD3C2
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 11:00:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98EFF29B23B;
	Fri, 18 Jul 2025 11:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XkkmxeU+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676DD23C506;
	Fri, 18 Jul 2025 11:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752836461; cv=fail; b=sOfcXpSHWQwMDBr6EVih/qE9c19x+INsfTuDAglh/OPNtLCAL6iL5HuWuX281TlEpNLjhbUmzeaJvlSOgF1ZwiKecBwiQK/EmPaiHz1TsWqXTD1EDNwG86jAIpYClwm5Zp00wVbGJNHPpOwhMh3VyYP8KpRqfME3LthCcY3FG28=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752836461; c=relaxed/simple;
	bh=70bpq6oBhapznUK8Uu08XOYncmVjUlC/q0KLjKXjKoM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PVjQIgJZLfUcXnaJUVv3VkYCPIsjuSLRwOL/w4LnYkMCwmaNcDwl0+t1GP5oSSYUYonZ53R5KG+5CBaRyPi7I9VTfDHVSj9rwUGPGKaq77T03ne1Nb9+ZG2wnWQ2VqScfEiookDQbDc+U4BbTZZq1rGDUjsGvF+WxLEEUpJGeys=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XkkmxeU+; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752836460; x=1784372460;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=70bpq6oBhapznUK8Uu08XOYncmVjUlC/q0KLjKXjKoM=;
  b=XkkmxeU+NMss5w93St4r+GwIcOdF0k3m//lWHdhuyYfc0rgZf3qT+j44
   Mf2UcD3hCrBosNN22d+z0yBByhF297+Q2NQy5QmFrWsYPx1Lg5MDh0B6B
   uytn1PiM2FJaZLjjDcR4OOZi3F91n86xUKHTydt2yn//MK/WUBuTIMC6k
   ORYuWaJrvyEa/N12+DR2HeVyRahisDneD0Ev20TB+R9tZqbtUyMAqAeQN
   f/wEKJIkmCxvQpofcNL6aHiNxcd7EGLUz2doaEteWlj3pNNT1csPNqobC
   593aauvePxPVODlIJ3YwRPOg890FRiKDTvm69bYqF58IkqQiJvtLhy6cg
   A==;
X-CSE-ConnectionGUID: UqxjLaouSQiQ6F1igQom3Q==
X-CSE-MsgGUID: tBOMOFjeRguqTRleSXr7/A==
X-IronPort-AV: E=McAfee;i="6800,10657,11495"; a="80571783"
X-IronPort-AV: E=Sophos;i="6.16,321,1744095600"; 
   d="scan'208";a="80571783"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2025 04:00:59 -0700
X-CSE-ConnectionGUID: Pl9IyOR9TcmlHrFYJDkBAQ==
X-CSE-MsgGUID: BGyI87gPSriFOX+Ghf2zBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,321,1744095600"; 
   d="scan'208";a="158510309"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2025 04:00:59 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 18 Jul 2025 04:00:58 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 18 Jul 2025 04:00:58 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.45) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 18 Jul 2025 04:00:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zO33y0RPXxHIXaY4pf8r7uIcBhQXVlWKdX9AveKbxahcJQGbtbHGlboz0/MtIlxuW169nrTzVLfDrAdWEJ7Jz9fl00a+2Owdq2B44pQVgacojvrExOFRObJguCWjDS0l6bFsCXasI0ELtss3dl/nu9gENalPGd93U0MiR7TzcHC27rKMx917zEN2gMZv0Ln+mrD6i1zQjm+27DK1QhRkXFh0nwrm2LAg/e6zO8BXkrjxbFVa0VwSpLxXq2aLI8lOAVGRaqoBBCEv1bg1dlxndJZyE52v5C/1Mj/WWzRqjWL1bbjAD4wj31BS6eiltHf2hLC2eSumxsyax/3CY6wFDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=70bpq6oBhapznUK8Uu08XOYncmVjUlC/q0KLjKXjKoM=;
 b=WJGsHCatHsGMLk921JsUXlsdVEHNqxUnykre09aDCuHNKa1DErYvH6BBeIrNv3/T3zusUIIXULLyEXIGhisHPj5AtHUJ0viKvZpdGD+1VQNW2KKfodHGLrjhUQNj/oVl2Aj1LLzULy6OPjkm5KuxMGz8qRcLh/uheSOlOMIt9fgS8YOxKABYDC5bOya8jeCHWp8wnPzdhNY+XWF/QfC0nUFGJ5BTyUdwqpl2OuBb0vHMdTj5gRtV8e7C8iF4yX6fKOrwf9QNUft/kFGz6DYPDx1ULgoj9gVgmlgglGLT+PW8+GcQeqIeu3DfN3wYQRXtBPtfdtuIDOWjGDxMrVO6hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.39; Fri, 18 Jul
 2025 11:00:56 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8943.027; Fri, 18 Jul 2025
 11:00:56 +0000
Date: Fri, 18 Jul 2025 19:00:44 +0800
From: Chao Gao <chao.gao@intel.com>
To: Jason Wang <jasowang@redhat.com>
CC: Cindy Lu <lulu@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "Vitaly
 Kuznetsov" <vkuznets@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "maintainer:X86 ARCHITECTURE (32-BIT AND
 64-BIT)" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, "Peter Zijlstra
 (Intel)" <peterz@infradead.org>, "Kirill A. Shutemov" <kas@kernel.org>, "Xin
 Li (Intel)" <xin@zytor.com>, Rik van Riel <riel@surriel.com>, "Ahmed S.
 Darwish" <darwi@linutronix.de>, "open list:KVM PARAVIRT (KVM/paravirt)"
	<kvm@vger.kernel.org>, "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] kvm: x86: implement PV send_IPI method
Message-ID: <aHopXN73dHW/uKaT@intel.com>
References: <20250718062429.238723-1-lulu@redhat.com>
 <CACGkMEv0yHC7P1CLeB8A1VumWtTF4Bw4eY2_njnPMwT75-EJkg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEv0yHC7P1CLeB8A1VumWtTF4Bw4eY2_njnPMwT75-EJkg@mail.gmail.com>
X-ClientProxiedBy: SG2P153CA0037.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::6)
 To DS0PR11MB8665.namprd11.prod.outlook.com (2603:10b6:8:1b8::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH8PR11MB6780:EE_
X-MS-Office365-Filtering-Correlation-Id: 392a01b7-49d9-4922-786e-08ddc5ea5ea8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?T1UxMWhpV1REaXRHL3ZHaWlyMGFrdjI5OFgzcWdUQTk5enR5RW1LWVgxOVhr?=
 =?utf-8?B?b1dxL3dTb004SDQvZzBnMCs3V2IrUGJ2NkUxdXpmTkt4TWRwa2lYYTRIM1Ar?=
 =?utf-8?B?WnAvV1dzaEgrL240ek5pNGFGYTVvbEd5STk1dE9wMlhHb29yVnlGcVRXSWxS?=
 =?utf-8?B?UHQzUGdiZnZ0aVdyWFJ3dEY1em14aTFRYWtPQ3ljUHJKekZoNU0xWjZkVW1u?=
 =?utf-8?B?b3VzRExrT0M1MWpGaWQwZG9Cc09CRXJUQkh3Vi9KVFY5d0w4cjdzYi9yVXJX?=
 =?utf-8?B?ZFloSXlISXB2ZDhHb1BrTUYrUTlYcGxhQUNFajh4Tk9xemJCWXk0RlQ5WlZY?=
 =?utf-8?B?aDg0WDd5M015NTFoeEFQdW4xV2g0QXYwcXFJOUZ6NXVNWnVJTDRSVkc3TmJ0?=
 =?utf-8?B?T1RoSFJ0T0xpVGRNU3FieENaR09MR2o0MzQ5QU5POFlPQzB0SzZSTlY2L1Yy?=
 =?utf-8?B?WndicmZQUjFBUnJkcHJQekt3aWlQY0VQZVRnSTNXVDRhdmRld2lLREdyN0RL?=
 =?utf-8?B?Qm9IWnEvTUNjczRiRXcwQUdPdDRkQlY3d253N3RwM1lrbXNieDdGa293Q3ZP?=
 =?utf-8?B?eWU0cGlhaWNPZk1YbmZ2QlF4N2dVVGtZM3NsaEpMTUlid2NhYmVUZC9kSGQr?=
 =?utf-8?B?ZzFqWUdEb2xNSm5LQkx4TkRhb01ic1hHeDFpYWY0VUdhSnl2ZFBMRWxGYzJm?=
 =?utf-8?B?TENLcU5lZFhKbTVmVFhJL1h6Yi93cVpJVHFwY2M1dEVHbGwrRVlod2hIdm1v?=
 =?utf-8?B?NWRodFliZ01SL0ltZlpXZ052Uy9ZS0FCdjliTDZtejdrVTVSMm5mcGVCbngy?=
 =?utf-8?B?UUZOS0tsNTAwRW9Eb2dsODBGaFdUam03T3RZZGpaNFZNcXV6M3BLbjE3Rk9H?=
 =?utf-8?B?Q3Bhck00bXpnVnhyWllkeXhyTWlQM1F1NHc0L1JFcUNkZXhsYndXTC9NdW85?=
 =?utf-8?B?N00reEJYZkZPYi8wUk1Nbmp4OFZ0WjBqaU9JSmlOY0hLcmpPWEZtYktDck55?=
 =?utf-8?B?UG4veEp2UjFWTjdnTUxKallGbjR3QlBkTW0vclpqdkFFcG5pMlIyME1pbWdS?=
 =?utf-8?B?eVFRbFFlbDZBNCtnMnFqd1ZtUzZ6YlJlVEk5L24wREVoK28zOVZqVGxSalVL?=
 =?utf-8?B?Qy9xb3F2d3BUSGcwTnVTT29uampUSEw4Zi9IdVMwc3hHSUxnSWhYMFF4REJq?=
 =?utf-8?B?Z2U5QThBeTlGTWJmNkJwWmpFUWtoMy9sNCtBRHA4UVRjQjVrZWZIdGtONHNl?=
 =?utf-8?B?MS9SQVRxR0lSQVRQa0RaNlNzME1tTXp0ZFBKelVMZFJoRWxsQ0x6blU4OThh?=
 =?utf-8?B?ME9vZEhIU3BBWjNROWhBWmlnQXBOYjBoOTRRRWpad1BwTnlDNzc1OUpibm4v?=
 =?utf-8?B?WC9tZjhqUEJGT0VMODM0YUpIK3VGZ05hbHpQQ0pzR1dVVVN5b2VXY1BSZkpF?=
 =?utf-8?B?YXRxaUY0RThpU2pHanQrZkFYT0J4TGVPS3JWQ2p0N0lyQ3dHcCtzWHpqL3Vu?=
 =?utf-8?B?ejdpT09QdDNZbXNwbDBoamM1WklrNVJqZHpjWGdxR2lNRmoyU0ROZXFhZlg2?=
 =?utf-8?B?WWdVZzV0OERPam4rNDFmMjdMRFY3UVB5TUpSeDl0T2FPR2ViUlR0bEtPbDNu?=
 =?utf-8?B?Ykx0QUdLY1hzbDN0dDZES2Z6V3kyMTVvSkdMUVhRVmlVdGZ5YWZtUXhvWm50?=
 =?utf-8?B?YXJhZFV0RHhDd1pmVDdHRklCbGdoUERKZThBK3hoc041a2RTSitnbG5qVEpC?=
 =?utf-8?B?RW9hZS90K2psSTRCajB6eFRKeHFJSnhCMnJuV0xYVGJMZklCSkJJcXg1Wjg5?=
 =?utf-8?B?UUtpZnRxUFJuS1VWUnBmV3FLb2ZxME9qNUsvcHo3eUZmMzVwQWxRTXcva1RV?=
 =?utf-8?B?Vnc3dDFCVnllVngwYmZCMUljSWsvOE96dzBhR0dkSUx0V1RxU2kyanlyd0dI?=
 =?utf-8?Q?OwfW3y9w1M8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U203R2YzK3FObzhBdDlGQ05CZG1pK282b3pvYnZJZUlTRFI1bGJLdVpiWG0r?=
 =?utf-8?B?QnJNSlFUcTJKNDJCYjNGZExiS2ZVQzMwTXo3bUNvYllVSEJtdVFmbFlxRDVY?=
 =?utf-8?B?QmlyREVUaVZEOGErNHJYNmhwNUtwY0huOGNpZDZ6TUtTdTFHNGxSdkJuTHg0?=
 =?utf-8?B?UUNYQU9QZnUwZkQzRjFyMVhuR3VPL0ZhM2FYbGVWWDMrNm1HMndHVkpHRFlw?=
 =?utf-8?B?OUdTdk14WHNJR1dBQ2NKT2U4amFzeUVKRk9vc0hjU0k3NU1maGk0VGxmUjhi?=
 =?utf-8?B?NGRqZzdEbTZDQjVZZ0Z3aWFzV0Q0Y2hMQjRJSy9QWUZ4V2grK3cwZENmNkY4?=
 =?utf-8?B?LzE2alc5cjN2MjEzaU15Q2lUQnE1aTREcE9vUTRSZlk5VStDLzhLd2tORTk5?=
 =?utf-8?B?VGdKbWZVWEN6Ujd5VlhidEZRQWFGa1A5QUJ1djRGc0hlZjEwWjNRZFBOaEVT?=
 =?utf-8?B?cGd2UURFNG1qMlJCaXBERXdXVFNmT1pFazcxN3dVUWt6LzNOQUR5OWZvMzky?=
 =?utf-8?B?QmIvVUh1Qm53R1FqamFZVDFDTHpUQmZsbGRYUWV4TnRsSWdXNHFSUDhYMDFm?=
 =?utf-8?B?UnJXZGRhT3RSU0owZXpnOGdncmdoY3Era2ZNL2RGMlJ5N1hqaFBHaXEwY01X?=
 =?utf-8?B?VkJEZWJucUxYU2Q4V1l4anpmNThXeGk1KzFBOFozTXducDZiSEE3OGE5RzZv?=
 =?utf-8?B?bGNOS29nVFQxUENwV1d5QTB4WStwKzJvWDNVSHkzb3BGNUw4MHdBK3lKWUs5?=
 =?utf-8?B?MUYySEpGTXFFZEhLZkhFd0xRbndidThiUTFZTjRUOHdHNnp0b1puZ3E5MVh3?=
 =?utf-8?B?UlVBbG1TSHBITzFMZjM3SjRmREF3WG5GeDZjdmdrZjdmaUJDbS9UQWxNRWdt?=
 =?utf-8?B?UFpkT2dJVjY5M2VsWW9MaVdCc1oyR1V6d0UrNVdDUFNKVjk5Umd6cUtzUWRN?=
 =?utf-8?B?N2h3YUM4OW9MQzRPTkc2RVB0V0tsTmQ0Z25BZFRDWTRGRVJyNHdVQUYyTkRN?=
 =?utf-8?B?VlF4NmoyS0d5OUxwQVdETVV0Rk1KSmRjNGttQ1M2NnFPN1NvVjg2M3NUZERS?=
 =?utf-8?B?UVhxZzVMQmFJRk14UWllYWF0MFdFOXkzVUpwWjRNZ0Y0bDNtdDhyamNObU9Z?=
 =?utf-8?B?OG10dUloTU96ZS9HaGY1OFJramFHY2JFQUtNaEY2amNrL0lrOTVIK1o3cmw4?=
 =?utf-8?B?Z1BBZEU4QWtjSGYxcURCcGgwUkk1VTlZVnZmRW5UcHhKbHdSZnJtTEFuRllI?=
 =?utf-8?B?aHRzQWdCdWZCUzlUUUg3UVBHQWEyOHdSQkxDKy91K2EvV3pKekgrQmpzc084?=
 =?utf-8?B?S0NTZ2g0UW1zVzNUOU9OSjVheHhjd2xHYlJqZ1JaVmxMVkhaNTFpOEMyTWxt?=
 =?utf-8?B?UExzczhjOVhYRnBoZ1JyQzdFQTZYVUdhQUdqTk5BTUNTNHJUd3ozRE04ekhN?=
 =?utf-8?B?aW1kN1MzTFVsV2xCMmdrTXBlQ3JueEhneHF3UnlZMC9Hc1ZnRUt3YWhLamlQ?=
 =?utf-8?B?b2UvMGRWYjJldVRoR3RWWlRRbzhuUUpxMXR2MmE4OFp3VGtTQkg3bVVjcUcw?=
 =?utf-8?B?QlVSUXVGNE5QckM0T2d1OVJxV0w0cXJsbmE0eVAyT3ZEZWJzZ3prSjJpTkdL?=
 =?utf-8?B?NU9HYm9kMFV0Mkh2Q0JjKytQektGNzA1RDlyQ0ZtR2IraWJsbG96ZVc3VkpP?=
 =?utf-8?B?WEpjYmU1dStUUWdjbzVCM1kyaEdkeHJOLzUyaEh1NUdPRUZqY2d4VjZhbEF5?=
 =?utf-8?B?bkE4TVg2WEt5SG5nNGtZZEN1MkZ2WWZJZ3plVkh1bzZEZjFSQ2pzdGxxRC9O?=
 =?utf-8?B?K1RaRzZ2elhoRGVGNFFWRy80TGJvUEFaa2ZDTWJVYWk5ZGxiaUprVFhRTTla?=
 =?utf-8?B?a0JVcWkyWVdMUlArYnpvMXp5K2VIeXFlWEhqVmVoWlFQc1IyWXZxNUh1d094?=
 =?utf-8?B?VzRCQU5lQVgvdkNQVWRKRy91aitaRXgzYlowbUluTTJRR2JFUTFIMVlxUmhZ?=
 =?utf-8?B?YnFHd1BnVEdYYXpIMG9nVi8xbWsvck9NQyt2dVJJaWxYejE1Um8vRkdHNkl4?=
 =?utf-8?B?V0gxSmMrSDFnOHVjSkZiSDFGMVAvUStiako3bHZmNlpDUDBCbWhOOTNmMXN0?=
 =?utf-8?Q?nF5dYgje0ocEsc91TWl1699G+?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 392a01b7-49d9-4922-786e-08ddc5ea5ea8
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB8665.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2025 11:00:56.3997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PIFlT9/UiFMcGc1k3al9Nha3BRMf//LQrqKYmB3LbYtWIjNc4k4Cnhn2hN8ThRlFeiAOB/pvRUcGNtThfnXP3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6780
X-OriginatorOrg: intel.com

On Fri, Jul 18, 2025 at 03:52:30PM +0800, Jason Wang wrote:
>On Fri, Jul 18, 2025 at 2:25 PM Cindy Lu <lulu@redhat.com> wrote:
>>
>> From: Jason Wang <jasowang@redhat.com>
>>
>> We used to have PV version of send_IPI_mask and
>> send_IPI_mask_allbutself. This patch implements PV send_IPI method to
>> reduce the number of vmexits.

It won't reduce the number of VM-exits; in fact, it may increase them on CPUs
that support IPI virtualization.

With IPI virtualization enabled, *unicast* and physical-addressing IPIs won't
cause a VM-exit. Instead, the microcode posts interrupts directly to the target
vCPU. The PV version always causes a VM-exit.

>>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> Tested-by: Cindy Lu <lulu@redhat.com>
>
>I think a question here is are we able to see performance improvement
>in any kind of setup?

It may result in a negative performance impact.

>
>Thanks
>
>

