Return-Path: <kvm+bounces-52052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 162ABB00A54
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 19:46:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D7E0B7A7875
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 17:44:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C33882F19B6;
	Thu, 10 Jul 2025 17:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cph0HRU+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C182EFDAA;
	Thu, 10 Jul 2025 17:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752169488; cv=fail; b=QOjjJDnpZTKDF/LPUqEF9nkq3JkhYdElBOsa0N5LWNudb8MpRWfPi/EiMLfb1H0itid0gdczmuE5kLfwkb1JbZSGxYAnfaM2XeO+cWs8pnCGoYuUN/RsBWdlQdLUPbs61CJAnBqVpydroVO48Hjhd3bzkCYnTkLLey0CVK0NlB4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752169488; c=relaxed/simple;
	bh=heeZFxw3IGOcWESx+Fag5fccuqetXeGAyssi4QVnJuI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WirLuhaB2zCGIe5v19BrVwjbM9LaCwCJEjd95peAgy/HAkIXn4oujB6XabmGchgWD3vAUdLAZsmHlpPtc7sAJ8jLcC16AC8ZPeKfAFOYlCMUOwH0/n//yifRCGcJDGc74TriitTTvYrb2f9RxbZIckZBseVFV+fX2cfUGl6DNHU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cph0HRU+; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752169487; x=1783705487;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=heeZFxw3IGOcWESx+Fag5fccuqetXeGAyssi4QVnJuI=;
  b=cph0HRU++FZcm0bhxMsMpLTY5GbMtS6F8JHWsnyt4UTr0EMJ8iFDRJXR
   5LGllQ3X17t0H5072QwitP0Nn8kyAhNtRYeW4++k1CsXVjR04vnWmIivu
   dUmH81sm7Axd2H95V66dnzOAcT2gtVkyaC+K2xwyb3p2FT9wCTI9UKMsn
   hu5Tl7n0cWu/eZWGtFInI1zOUlKyCouOVRuKX13J2Y8X0LmR/FlhveY7Y
   dvDQJvOT0hG2q7P+6tpUV9Km8OBNnXmAdFHzfKtxoSpn3kP+/GKkF3NGH
   BkRcc/85Xk1Z1oRbCIQd+UJRcCDbPkRRt2fLlCLa0EFOjvLN5T3rtAZq1
   g==;
X-CSE-ConnectionGUID: Im/piPHxQpy4sDvqu6tN8A==
X-CSE-MsgGUID: egOO4z1FQwWHxSYH8Ru3Zg==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="65523289"
X-IronPort-AV: E=Sophos;i="6.16,301,1744095600"; 
   d="scan'208";a="65523289"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 10:44:46 -0700
X-CSE-ConnectionGUID: y8gvTJ1zRPOj6iH/3j5ZPA==
X-CSE-MsgGUID: aHSWxHy9QnaIF4Thjro0IA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,301,1744095600"; 
   d="scan'208";a="155787820"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 10:44:45 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 10 Jul 2025 10:44:45 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 10 Jul 2025 10:44:45 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.53)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 10 Jul 2025 10:44:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SGw5YRdpeWBg2J1+v0wsyU8tqLUdQmjHqewhA4RQh9+tIKtUNd+zrMot1T32HLKwSEnCxW43q4+RL0Y8Ml+vG/HaA/mJgD60wJHoOVVMr4QwuwnMhPpxKmaTPBXPgMFLhWxnnE1wrIHZoRlEkGW8yKEWwfeMX9KCNmn2vqWLSeC0q21c3LP1uGI4iM+g7fTvNSmi51L+GzqSvKrlUECPMd7zsR36KuN5A/9EB1PDrSX3BzkKbqimdKdTAyepjbgjKKZDiLk59YRbRuSJ/ivfX2byYDbjQZKcy4/Uy76+LEEW6KU7XLJXATTLAFBQmPWf5PF38x2OLkqYfjyWSvypjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=heeZFxw3IGOcWESx+Fag5fccuqetXeGAyssi4QVnJuI=;
 b=AG5bdgVZCsNbD5jkn0HIg48cpE9q+sWH4uykclRFTvAliIJF+JdmNQTvnY0rnoiVjMs6HB44w/lHmYPdGfqvqZZPQNHKYwrXR8TYagVdn6Mlu41bJYTHUFoypJl15HdStumk1tKQf53AeoF6NMQvIHkqxHWbPneBgupDayMq17vOdschBBcuFwZC7gdZKX7NaPWz64DkltgtUGrzRaSIbr6i+QjN7sXfhPSu/u8v93aTjn1Rbj+5L9gUtzilsRvG0CUY7pE89U0I10shnpW7FY0CIOHTYCby97F5Huv5ElNrn6rP500Mt3b1nV/XeJHBXiclGWg4lm6Ii4cj7gSyGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB8082.namprd11.prod.outlook.com (2603:10b6:8:157::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Thu, 10 Jul
 2025 17:44:43 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8901.028; Thu, 10 Jul 2025
 17:44:43 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "seanjc@google.com" <seanjc@google.com>
Subject: Re: [PATCH] KVM: Documentation: document how KVM is tested
Thread-Topic: [PATCH] KVM: Documentation: document how KVM is tested
Thread-Index: AQHb8YWJalgYXW8KikO2Z7hh3rqpxbQroZYA
Date: Thu, 10 Jul 2025 17:44:42 +0000
Message-ID: <844d7aeec492704bead16ebe163c908deaac8301.camel@intel.com>
References: <20250710102917.250176-1-pbonzini@redhat.com>
In-Reply-To: <20250710102917.250176-1-pbonzini@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB8082:EE_
x-ms-office365-filtering-correlation-id: 0f33b8d9-fa98-4089-8ecf-08ddbfd973ed
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Ynl6NVZhcVpwYlJndmlNeU5qTjh4ZmRIRjdVVTUzcUxiVTBHV1Uxa25IVXl6?=
 =?utf-8?B?Z3JPc3Yyd3IvYmZIczhlOWZncUJXSTZUOUJkWUh1Vy9EQVFCd00zK29VZWtJ?=
 =?utf-8?B?R3dqVFUza0prVStCcnhyS2VNK05TaGJEdkF4S0toNzloaDRnMSs3aTBqWTds?=
 =?utf-8?B?eStPUzgyMHpHSnNkcGNXQXQySVFaNmh4RHpIeDZ1UXB2QXplRnEreHRBRFcx?=
 =?utf-8?B?V0t2Uy9odkVXQWg5Mkk4VzYxTG54aExHWS9iYVZCejNTd0Q1MnR2ZnFRc0JF?=
 =?utf-8?B?TmF6Rnhic2hLZE1sUXcxdmhjK09hVFdlZnNOYVV0RmxBOUxLa29JeklkaStW?=
 =?utf-8?B?ZzlzM1c1TmVNMFlhZVB4NlIzTHY0RTZxWHVvckJUaHBKZHJ2NXRMRkZqTmxQ?=
 =?utf-8?B?RklMamQxZys0L1pqaWs1b25hWWZCNUFKQkpxVmR4VEhIaFRpNnc3WEJFbWU4?=
 =?utf-8?B?WGpzYi9YMmpHREZUUWFvQnZ3ZU12dFNsTWkralE1ekZrZkJaelYvb3BtRmtO?=
 =?utf-8?B?bU5nSjAzWXlvOHNPSFV1dEVzclhYZWV4QlpQNTMrTlJ2ZnkwVmUvQ3c5Y2Rx?=
 =?utf-8?B?MENoTVJTcitrUW5xS3pKSEFuSHRkV1hDYm5TbVJvMDBidnJ3Z043UGlKK3Rp?=
 =?utf-8?B?UXJXVGdhVURpYlc2N1dCYXhOdTQyR09FZDBPSDMxSThYYzdqa1RRR0JBenFJ?=
 =?utf-8?B?a0I5ekY0V0RjQzBvVmgvSzAxZ01RSDlOOGkrYzk2bnZWOW4yNVV4ZlYrYXl6?=
 =?utf-8?B?K2hTWXlObkRHTmVOYVR5L0xhN3hZTTg4ekFNVTB2R20rcUh0TDB4TndTcU1a?=
 =?utf-8?B?NnlTM0d3cW5xRE5YS2VHajJXQ1V1U1VzZjAxSTN4WWNieDVVRGZ3Z3ZyS3lT?=
 =?utf-8?B?VklGWmN6cHVSZndubWxIa0tPL3h6UmovN3dSUXpjNmcrNGQ2VlZwTWd6azRp?=
 =?utf-8?B?eGJybVhXeTUwY09HbzFXZG02SEFLVnVicmdKcUUwQVJhN29xM2dvbGNDV2ZN?=
 =?utf-8?B?L1ZUS0FPYnQ0MWpSM05nK2lMYUlqemk3bWxCMUlBMVpDY3lsUVo5bGNaa1dI?=
 =?utf-8?B?MnlCZGRudHdnWW5aeWNOY01PcGZhRU9PUWtZd1NtZmRmRkFXUmhjcElBTUpC?=
 =?utf-8?B?VUtITW96RTRyRDBBVnFEbU1SNlRCRDJXZkFPODcyczhDK2RhK05oSVBncUcw?=
 =?utf-8?B?ZDFvNGhWVFB5U3VONmY0bXIyNkFhaUFmckc2ZkxCdmdGR0I0cEpkQ1RUZnh4?=
 =?utf-8?B?RG1wMGYwZEhzaTFrRTlTbXVkZGRCdUw0c2czbjBTVUY0bzZRSDJGTjBLSC9m?=
 =?utf-8?B?amJvQ1QzbnBYTGRaWUl2TWNIdkZQK3BzU3FhL2F3TVBGZm5OZ2szenJBNVZD?=
 =?utf-8?B?bHdXbTN0d2E0UXJvN3J6REFDL1JrdW9qUmN6bXJNK0ptcmwwMEJIZzRnOEF3?=
 =?utf-8?B?dzJpME5qMGUvSmErTG5ZRWN3SGVOZW9pT3BMb1M0djNLRU1Zc2hpZStBQUlx?=
 =?utf-8?B?WTNlazVTc3A0c21FaDBIbkJUNzRoS05FeWtUaHVSQW04bmVzMXZFeW9yTXhC?=
 =?utf-8?B?Z0Vrc2F4YW5sbHBmRGhVc2JLMk1LckZHUjVzd01BU25Sc1IxZEVxbjI1Qjh3?=
 =?utf-8?B?cjJEbTIvM0pRdlBRdzM0ZnR2TDJVWTMySldUMFdrTkpnTTFadEg4RXg4Ym5l?=
 =?utf-8?B?UFFkcWhuMmR0NzBjT1FCbHMxRjhDSUZQcUE5RGJndjZBNkFKOUk4aXlRd3lG?=
 =?utf-8?B?c1greG9Kdy8ybUVta3lwR2RPbUpWL0p5UzlaVkxWSjVGOU5OQjVFZjZ6WThI?=
 =?utf-8?B?SmhaMmwydFIrK3NTNzJkWkZ3SUNoSE1TeDhwOFYxNFdiQnFKWVc5azdlbXh3?=
 =?utf-8?B?RUc0dkRxazlFbEp5SUVHQlIybW1aVlE0a3Q3VG1sZFZFbGVXMko2alRFSHRY?=
 =?utf-8?B?R1lrb3VnaExpeTd5b3hLSFBpT3orTTk5MWcxcFBqcmkrMGFmK3hlV1poL1FS?=
 =?utf-8?B?QWpxVkRSdE13PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TVRZME1RbWVjKzRXQjRnREpuSlVBdmlIdFVXZ2x5KzJrYXV1b2MwdWlhUFU4?=
 =?utf-8?B?TVhxY2JaODgyOGx6WDh3bEhBWndtV3ZndkV1akRzR2x1OWd3NkhyOXNDc1I5?=
 =?utf-8?B?blh0ckdOa3ZidDBHSW1MOVJGM0dkTmJ2UU1aVUFrRzFoYkJVR3FuM1ZYcGVJ?=
 =?utf-8?B?RUZmY3ptcHRIRk04RUFMODBPcDdhOEl3SDJLQUNxNmRTdk9ObnZZUVB0aDRC?=
 =?utf-8?B?NSszdjQ5YUhha214YmhENXdScGtNSFhJZkhoQnkrd3ZuYk1pWUFTQ1RTZVVX?=
 =?utf-8?B?OVlxQWF3TXlaOEFpVXh5Ynd0cUJwZGUvUjR5QTkzOHFHMzFObXVjL3JlZFBs?=
 =?utf-8?B?TUtoaVdjZWhUZVBNeGV5UEJTL0VPcTREa2NSc1pyR1VUMnBXNTFYVzVMbzVJ?=
 =?utf-8?B?YStUcmdYVmFka0doVWgvT3ZPdEpsbDV5M1U3aDl1UzlYTTFSTDJPK0hnbUdT?=
 =?utf-8?B?V2J4eElUY3hQRlRoeWhGVWFtcmRlV2t2ellCdnhYVU5WeVlWbjhiRVVGWlR4?=
 =?utf-8?B?OW9jL1k3UUtjcktHV1lLZGZQbHU1a2huZFlha2ZNTkE4R1V1YkhiUFR4R09C?=
 =?utf-8?B?RGg3UTluNUI5ZXBtdEF0clJ4WHI1ZXpIYTVPTVZKeER3dlk5VlNsejQ1blZV?=
 =?utf-8?B?ZUNJd3BjS0NUOExtUDViU0JHVlVEdWppeVptVU1ZYWJnUkNSRGhUQ3FtVytG?=
 =?utf-8?B?YWlvRytLbENWZXlXeFpkTEtZclNrQnVQN1hrNlFaRnlIU2xxdlkrcWJubEgz?=
 =?utf-8?B?N3lNcHQ1cVpQK0NmRjZvOWxhQ0Q3QjdYdW9zVkpZMmo1cXhaUWcxdnNYcUJO?=
 =?utf-8?B?ZFhaZWQwdkJvUUIyQVltamFDN3R3eTRoMWZmaE94TmUxNG1NemJKTVVnL2cr?=
 =?utf-8?B?S0tzMGF6MURyTGt3QjZndGVpdDJONkNqTmlWNVB1dFBxdjAvYVVmSm8weUc0?=
 =?utf-8?B?WW1XamZBRU1oUGUrVndBelh5aGZNTlVmdHo4SFprcjBIWm1JaFlFVldrbmF4?=
 =?utf-8?B?S0ZzeUhaSmlhSHdwbjRUblMyMWVlUHN3dkNOeUxrMkJJNXloRnVJc1h6RjFG?=
 =?utf-8?B?RzdwcmJrbndkcG9qMVh6cXhHdzZPQ2l0a256dWhqME5NWU1YNG85TUxhTTlW?=
 =?utf-8?B?anpYS2VLa0tKeHNTekcvNHdQa3g1SUxDcXF5N0x1bW1uNVMwSVhNRTRwWVdx?=
 =?utf-8?B?VzFKRE9oNTdaQ3dKdHd6Ui9ZSXoyS1pzZkpIUTNuR3VZUjBhQ1pkUS9ZbDZ4?=
 =?utf-8?B?TEYxWUdyRnNQdWF4TjFPTE5jc1JVeFQwT3o5RXArdkorWkRhL2lQcnM5KzhR?=
 =?utf-8?B?QWVyMDZIdmZOM2R4VTBYb1psckNNdVpTTkJiS0tnZ0hXNlZNazhDRk9wbnQ3?=
 =?utf-8?B?WHdyWVYxR1c4dG1ISUpCV25pMWwxZ01UWXhsK1BucDlnc0xua05reW9BMjhp?=
 =?utf-8?B?ZDJJVHJGRFRER29pS0hTSUUyRlkyNEVITU1qTmdIVnFCa3RnUW01WlU1YU8w?=
 =?utf-8?B?TzVnWUJmUVVkY0k4QVpYNGlWMXJVNDRGQnBzZ2U3Y0tzbTBBZDhFMTEvY1ps?=
 =?utf-8?B?cWZweEU3RlRET1RFQW5TZkt4NDZERG0rZC9qdlVZVEVWZmhPQUZRd1crR1BQ?=
 =?utf-8?B?TWkvMmxDdlZzejlLMUdkL2F6UXQ1QlFZZGJLZWcyUFo4a0FpcHAxZ25teFlp?=
 =?utf-8?B?Tk5aWkMyeXFqaGRUUnVrVGk1cTJiNHhlQ0N6Y3BlYXppTWdaeU1yTDRwRGhq?=
 =?utf-8?B?Y3N6QW16OFFoaFVOOVlJL1Q5bzQxckJvS2prSmJNVktPVnoxTWdWaVY2cEJo?=
 =?utf-8?B?VVVMZ3MzTTNDVnB4WmhWUzdsaWQ5NldOa0JDVU11eVdkQi91YU5iU1BndTZz?=
 =?utf-8?B?RzI5czhHYWplS2VScXhjQWIzMkdzVUxEcklJSG1kVHQyUUt6T0dEYitQWUN3?=
 =?utf-8?B?SWFpMXIrWTdOaGxSV2pwNUQvYWxncHRLb3BkNGxJanVvUFFzbDJnVmdzb1Nt?=
 =?utf-8?B?NnhPVjhQRkJoQlZYWWtWMytvSXVDNHNFNEVkbjJzd1ZrVXVWa240RWZPVXlV?=
 =?utf-8?B?RXJTbnlUWmhPV29pdGFaZzBjRWUrKzJkSnEvYXNPcGlTc2FVNzh2ajhlQXYy?=
 =?utf-8?B?ZkxBOXlXcjIwVFgyOVRKTENpazBIRWlUUWducDdYZzNQR3ZLcWdDRE90U0Zz?=
 =?utf-8?B?M1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E9B3D2360EA47D48903CA064CDEFE3F6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f33b8d9-fa98-4089-8ecf-08ddbfd973ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2025 17:44:42.9943
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YgdLk5gscz7Y4P/Lj10Rc98Y14z+80o4iSXvVCgiAUWcD8eyEfIDddKMB4K+PUkLqWlH86VgY5y+7tiI2IM7+IhS50HCdS5fom7wJ8erDVk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8082
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA3LTEwIGF0IDEyOjI5ICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiArQmlnZ2VyIGZlYXR1cmVzLCB1c3VhbGx5IHNwYW5uaW5nIGhvc3QgYW5kIGd1ZXN0DQo+ICvC
oCBUaGVzZSBzaG91bGQgYmUgc3VwcG9ydGVkIGJ5IExpbnV4IGd1ZXN0cywgd2l0aCBsaW1pdGVk
IGV4Y2VwdGlvbnMNCj4gK8KgIGZvciBIeXBlci1WIGZlYXR1cmVzIHRoYXQgYXJlIHRlc3RhYmxl
IG9uIFdpbmRvd3MgZ3Vlc3RzLsKgIEl0IGlzDQo+ICvCoCBzdHJvbmdseSBzdWdnZXN0ZWQgdGhh
dCB0aGUgZmVhdHVyZSBiZSB1c2FibGUgZXhjbHVzaXZlbHkgd2l0aCBvcGVuDQo+ICvCoCBzb3Vy
Y2UgY29kZSwgaW5jbHVkaW5nIGluIGF0IGxlYXN0IG9uZSBvZiBRRU1VIG9yIGNyb3N2bS7CoCBT
ZWxmdGVzdHMNCg0KImJlIHVzYWJsZSBleGNsdXNpdmVseSB3aXRoIG9wZW4gc291cmNlIGNvZGUi
IG1pZ2h0IGJlIGEgbGl0dGxlIGFtYmlndW91cy4gSQ0KdGhpbmsgeW91IG1lYW4gc2hvdWxkIGJl
IHVzYWJsZSB3aXRob3V0IGFueSBjbG9zZWQgc291cmNlIGNvbXBvbmVudHMuIEJ1dCwgaXQNCm1p
Z2h0IGJlIHJlYWQgdGhhdCBpdCBzaG91bGQgbm90IGJlIHVzZWQgd2l0aCBjbG9zZWQgc291cmNl
IGNvbXBvbmVudHMuDQoNCkkgdGhpbmsgeW91IGFsc28gZG9uJ3QgbWVhbiBob3N0IGZpcm13YXJl
LCBldGMuDQoNCk1heWJlIGNsZWFyZXI/DQogICBJdCBpcyBzdHJvbmdseSBzdWdnZXN0ZWQgdGhh
dCB0aGUgZmVhdHVyZSBiZSB1c2FibGUgd2l0aCBhIGZ1bGwgc3RhY2sgb2Ygb3Blbg0KICAgc291
cmNlIHVzZXJzcGFjZSBhbmQgZ3Vlc3QsIGluY2x1ZGluZyBpbiBhdCBsZWFzdCBvbmUgb2YgUUVN
VSBvciBjcm9zdm0uDQoNCkFuZCB0aGFua3MgZm9yIGNsYXJpZnlpbmcgdGhlIHBvbGljeSENCg0K
PiArwqAgc2hvdWxkIHRlc3QgYXQgbGVhc3QgQVBJIGVycm9yIGNhc2VzLsKgIEd1ZXN0IG9wZXJh
dGlvbiBjYW4gYmUNCj4gK8KgIGNvdmVyZWQgYnkgZWl0aGVyIHNlbGZ0ZXN0cyBvZiBgYGt2bS11
bml0LXRlc3RzYGAgKHRoaXMgaXMgZXNwZWNpYWxseQ0KPiArwqAgaW1wb3J0YW50IGZvciBwYXJh
dmlydHVhbGl6ZWQgYW5kIFdpbmRvd3Mtb25seSBmZWF0dXJlcykuwqAgU3Ryb25nDQo+ICvCoCBz
ZWxmdGVzdCBjb3ZlcmFnZSBjYW4gYWxzbyBiZSBhIHJlcGxhY2VtZW50IGZvciBpbXBsZW1lbnRh
dGlvbiBpbiBhbg0KPiArwqAgb3BlbiBzb3VyY2UgVk1NLCBidXQgdGhpcyBpcyBnZW5lcmFsbHkg
bm90IHJlY29tbWVuZGVkLg0KPiArDQo+ICtGb2xsb3dpbmcgdGhlIGFib3ZlIHN1Z2dlc3Rpb25z
IGZvciB0ZXN0aW5nIGluIHNlbGZ0ZXN0cyBhbmQNCj4gK2Bga3ZtLXVuaXQtdGVzdHNgYCB3aWxs
IG1ha2UgaXQgZWFzaWVyIGZvciB0aGUgbWFpbnRhaW5lcnMgdG8gcmV2aWV3DQo+ICthbmQgYWNj
ZXB0IHlvdXIgY29kZS7CoCBJbiBmYWN0LCBldmVuIGJlZm9yZSB5b3UgY29udHJpYnV0ZSB5b3Vy
IGNoYW5nZXMNCj4gK3Vwc3RyZWFtIGl0IHdpbGwgbWFrZSBpdCBlYXNpZXIgZm9yIHlvdSB0byBk
ZXZlbG9wIGZvciBLVk0uDQo+ICsNCj4gK09mIGNvdXJzZSwgdGhlIEtWTSBtYWludGFpbmVycyBy
ZXNlcnZlIHRoZSByaWdodCB0byByZXF1aXJlIG1vcmUgdGVzdHMsDQo+ICt0aG91Z2ggdGhleSBt
YXkgYWxzbyB3YWl2ZSB0aGUgcmVxdWlyZW1lbnQgZnJvbSB0aW1lIHRvIHRpbWUuDQoNCg==

