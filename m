Return-Path: <kvm+bounces-60109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CF334BE0D42
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 23:37:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2E39819C7367
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 21:37:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16C4B3016F5;
	Wed, 15 Oct 2025 21:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fb+Eq9RA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1112FF66A
	for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 21:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760564227; cv=fail; b=KZiSGLygCRUvKVjW4Vt1IIXsRv3RrtH13w8P6YRBLLqauKWCRoBGB7sXN9KUn8dRWSpKfmR7kndcM+u6ZSg26uFVHRfaTz+uUqd6g75/eYjCJJldSiJh1ypJR0XXlG/H0vjxC4GqeAt8zpfJnLFI3xBie8TKkftyhesZgkl4iYw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760564227; c=relaxed/simple;
	bh=run24mWerQY2PKdNJZBdZpG3f2H/23rWfUUkchTZqHo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mVp7iN08RKTMJJpJvQfcDj3kWmn+p1YtN05Q1dLl+OIHUze0m47MAQCeCM0nNDGodHxDXbtWW0fIbdtpDDpIglV+I+aZB6DJDMbnCwva98DUaH1SBxCuG4QWTaQXXdZjDIgiQ1kb3TDgaHtvHHObe/CCmZC9VbeS2SAQRPBViKA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fb+Eq9RA; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760564226; x=1792100226;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=run24mWerQY2PKdNJZBdZpG3f2H/23rWfUUkchTZqHo=;
  b=Fb+Eq9RAS7XnE3TOOOH40y7jGgneunAaKCjAgZ56MSZOhiQIy6YdCJXK
   k7iSow4RuXlXJ1Rqmc1vGelFOZ6Fx2HPyuwNyPxYP4lgsPMM+E/ifzo6j
   6KUfY0/z/fzoPLaZcEm4uNxqSKZOm207KPERD5Kz31b6YyoNmhjJ/3ilu
   ZkMZo3he7czJ8hzlIB0SOaHbyGA2RTLEhtB7b49B4MudBMC8BxM7b+Eo1
   0UWVIfP5Jt2WIG0KXrXaWvD8LAKFmkuuwpxpmsDxwmpE6rlmRII9bVLqY
   SGRYnwmaunxExiWlC/dp2JDbBNfSObqbVg/QkyUeYu9a3Auk1YaqaWa5i
   A==;
X-CSE-ConnectionGUID: RscpVP4CQXqDWvzk6xvvrg==
X-CSE-MsgGUID: 1KZNnEJGThKbRUpYtkUhiw==
X-IronPort-AV: E=McAfee;i="6800,10657,11583"; a="85368451"
X-IronPort-AV: E=Sophos;i="6.19,232,1754982000"; 
   d="scan'208";a="85368451"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2025 14:37:05 -0700
X-CSE-ConnectionGUID: i1F4I3YQTsqTzcm1tp3gFw==
X-CSE-MsgGUID: ntzRoKesTBy4Ww6f4lNQsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,232,1754982000"; 
   d="scan'208";a="181832625"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2025 14:37:04 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 15 Oct 2025 14:37:03 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 15 Oct 2025 14:37:03 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.4) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 15 Oct 2025 14:37:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UOAbpHGW+fhWNt2Kz5ob6uCMsmQVYxCnZm43a9G4WG4cfcj2cRzP4QD5k4oD0EJ2zP+ILMTdpN1nwN84ThDEl77cGiGQMxIuIvrKhkWhAZ0GZ4kvkjrMDHWg2+px+t8aoHE6SLsxBb0/T49mWoAlzNbOeQed5LCYT94mAfVCcKfU8Q7ZAv13RAx5WhMocl3Hk6ECr5HD2hplFi1ZxT0I494mujgoi/9dbSowzkJE5dafQvLQmjkXFrUnw3iB97ppGF7K14bYGRm273xFXC2LluYvgN/4MZnF0fAzOSyB058mwvoTunQAvjY87kRQpRofK61R/XbU9bxX4PaCU4drGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=run24mWerQY2PKdNJZBdZpG3f2H/23rWfUUkchTZqHo=;
 b=nI68BW8Afl7eo+4+zs6d/TnTtCMX/slD1RLHNVOdfc6e5AXzyVdVKF4ENmIqrkqxrvA9nQWj82xBHiaRcz/V2XeD/XmHESZoinH4fBTIhq2K8v/JeiYWOTwMaQ7sdhp6FCY36AU0pN4repQZB2jpqFUIw96kinYY0sQwESsh5msnZyuRDI5WdVJP/yoBIxzt+cxV4auNCW8KV83lbgdddPXtGh0Ws1lmAYxX5vI7hLUpRfZRaGhnnVmhdLrMM8x4BcVDOo3f1wDWZFLrdV42Qp2TfHpWHhbdh4UbcWvmLFioVHMtrxIMLdeJD9MjeEZx67x6NsDiZYzFugFhC7HMGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CO1PR11MB4899.namprd11.prod.outlook.com (2603:10b6:303:6e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.11; Wed, 15 Oct
 2025 21:37:01 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9228.010; Wed, 15 Oct 2025
 21:37:01 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "nikunj@amd.com" <nikunj@amd.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"joao.m.martins@oracle.com" <joao.m.martins@oracle.com>, "bp@alien8.de"
	<bp@alien8.de>, "santosh.shukla@amd.com" <santosh.shukla@amd.com>
Subject: Re: [PATCH v4 4/7] KVM: x86: Move nested CPU dirty logging logic to
 common code
Thread-Topic: [PATCH v4 4/7] KVM: x86: Move nested CPU dirty logging logic to
 common code
Thread-Index: AQHcPApHQq5GYUzMbUWZEhHpuKXxubTBhNuAgACYtoCAAAw0AIAAA4EAgAB3QICAAAxDAIAAPSWAgADRp4A=
Date: Wed, 15 Oct 2025 21:37:01 +0000
Message-ID: <0b333ab4b73bcc26bd143b522b4034055ec4e770.camel@intel.com>
References: <20251013062515.3712430-1-nikunj@amd.com>
	 <20251013062515.3712430-5-nikunj@amd.com>
	 <30dd3c26d3e3f6372b41c0d7741abedb5b51d57d.camel@intel.com>
	 <8b1f31fec081c7e570ddec93477dd719638cc363.camel@intel.com>
	 <aO6_juzVYMdRaR5r@google.com>
	 <431935458ca4b0bf078582d6045b0bd7f43abcea.camel@intel.com>
	 <48e668bb-0b5e-4e47-9913-bc8e3ad30661@amd.com>
	 <90621050a295d15ed97b82e2882cb98d3df554d5.camel@intel.com>
	 <c459768f-5f9d-4ce5-95ff-85678452da57@amd.com>
In-Reply-To: <c459768f-5f9d-4ce5-95ff-85678452da57@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CO1PR11MB4899:EE_
x-ms-office365-filtering-correlation-id: f463b0ff-217d-4854-4eac-08de0c32f9e9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?M005VkZmeUFDRjdJb3lkVWFVemZadk1FSk9WUzFYem9sNFFubzVuNjMwd2Ir?=
 =?utf-8?B?NDQ5dnJIN0RzTzlCUzlRMm1yaDBCMzRpS2lickdkYXZXdFd4clBVNWZBRDIz?=
 =?utf-8?B?TmNxYVdTQ2VvcDNaZEhnaDN6Wjg3MUZwWnRyVFRTR0k3aHpUdnBZZ1FSQnNn?=
 =?utf-8?B?R05vQXpoRkxZd29ETzlmdklNL0lMbm5ZNHkwNzRNQVNjNHN3Rmh6WkRvb3Ry?=
 =?utf-8?B?c2xEd3FZbSt6cnBCUU5JZmZPRXBINHhZQWRwWnNvNVBOR0orY0tndlhYeElK?=
 =?utf-8?B?OExPKzRQRDh3dk1Haldac3lldEdLZSs2cERkdHJEMm55VUd5c3BEa1pLRDVh?=
 =?utf-8?B?WExBVnBrY1VON0tHMWsvWnJnTjVJQmRPREtWaG9qcWtqbXplcTB0Y0g4cDZx?=
 =?utf-8?B?TWE0UjhucE95VUhDMEFXMnYzY3BvNGtEbFloYUNZR21BdytSMDJRcE9NbStD?=
 =?utf-8?B?UWN4Qk1mTEFlY2pmNUFQZlZHbmJUVmVTQVVLa2taN256L1lwbWgzOTAwcEZi?=
 =?utf-8?B?TnhCSkVLZXZzQzM4NnhhcEd3UnJpekNZVXkrN25TbnlrN2RXRGYxUkxwT2pz?=
 =?utf-8?B?UUV5bUVmMGhLWXhOT3NaSjk0VGxxUm1vMlV6b0E2NGg1RkpLQ0J0cy9CdU9z?=
 =?utf-8?B?QTFma3dYUEo5NnlHc01lbmVwOFpQcUlpMEg2OGlRWE56WGgrcWNNOE5XaVpK?=
 =?utf-8?B?LytyRFhIN0Vxc1A0RlpFVjhZSTZUd0xkZ1NmOEJ2MGtxUkg1UElWV2JzMGlT?=
 =?utf-8?B?U3M3RE8zUlVPK2tPdTlPb1dNWFF4Z2x5Y1g1ZHFPczkvY3RwRFRGOEZnQ20z?=
 =?utf-8?B?MmxKaFFJT29QbHJlRjM4aDcyTGhzU080SXI0MHphN2Q1VXFQTGtWYitpV0NS?=
 =?utf-8?B?YVdQQWVDK210R1JDR3JFS1R3cXpiSlhxNVdPQ09wV1lHQi8vbEFPdkkvNDZG?=
 =?utf-8?B?SURnb0lOVzJ2UFZWQmNLcFFINkw4N2FxZ2hnMDZtZkV6ME5YR0cxa2NyaHBW?=
 =?utf-8?B?UFpYL0YrRnNZK2MyeFZvU3p6Q2FPOVB5TDNORDRHTEFiRHo4THFoMmEwQUVt?=
 =?utf-8?B?SVhDTTdaTS9nc2dpK1dXSzZTSGFBMTRmRGRKMnBZYnI2bFpmTFJzNEx6MXVr?=
 =?utf-8?B?enhra0syS3dNTGRpS1NhYWZLUFkyNVNVUEI3a2E0S0RXMktpV3VySDl6ZHQv?=
 =?utf-8?B?OHl6U1JaaFVTTUpSZ012dWNHUkw4M3pIZENMMlo3Wm1RTTVvR04wTzNyY21p?=
 =?utf-8?B?cWdUR3ZPSkVYZ05vSGV3M3hvTlRCS2JDbXorYnJ1RG90ejVmRXJQSy9UY0RX?=
 =?utf-8?B?a3FiZ3BHdlVPTkptMEZ0aS91NFd6NmJTWlVUa2lteE80dlhUODZRR1BTbVE2?=
 =?utf-8?B?WDJLWnl0VG04YjdYQVdDaWxiYmZIRTcvYjJIYTkwb0FQbDQ4bE05Zi9BV29s?=
 =?utf-8?B?bWJnVEN1eDBwdldFMTBPMUNScks5b2JOeXdPOEdKK2lSOTlzT1Y0d1FJeHAw?=
 =?utf-8?B?ckQrNHlGL2pBaEIxM2xxcjNrWTM1K3FYTllTeHZNZ2V4TFFydHlVV2Q5WmJQ?=
 =?utf-8?B?L2JTSGtIdVJQTlBicDVrWDUvdVhtOHdMbGlFME5COXhRWmxNaGNCalp1Q2JV?=
 =?utf-8?B?ejRGQlRGWlNRU3grSnFlOEpPWm1lSWh1ZG82MEtORFowbFRjNXJmZnlUWjA4?=
 =?utf-8?B?VUxBcElzdm5kRUxtUDFTb0dPQ09RdjdiSy9FUWNlRG83S3BzNUJkYUhJOStx?=
 =?utf-8?B?VU8vaDJxU3BuVElQRUhtTEI2YkgzL1VDWks2WVhGYUl2VGhBYzJLbXR6Sld4?=
 =?utf-8?B?MStyU1R4SkpwaUk3eUJHaHpaMmVuNzFqeGVOTm1uYWZRYS9kL2NiQkpLejBD?=
 =?utf-8?B?cGlzTytBSTl0SnJQYWx1bHVhMXJ1elRTNmJsU1IxMXJQRTJuMDBWQmVkT1dl?=
 =?utf-8?B?M2ZHMGQxdVBrS1JQc3YyeFdBelUydVVNNGROeStXUCtSbWxFUmtCZzFNS29X?=
 =?utf-8?B?dnpLM1RGZnY5dzVIV3cxWnhOM28yOTdEaWN4U3NHc3kvdk5HaEtGVlg2QnYv?=
 =?utf-8?Q?nY9Q4B?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VTlWRTVsYnM3VHZtR0gvMzJjOCtWT0xHeXhaQ05wZS92ZzNpcFZWcy9wREE3?=
 =?utf-8?B?bWtJWFVSUHFsdEkxR2NoQ1c1d1lEdXRxZkE4UFNNMzQ3STZrb0o2RTFrWHpq?=
 =?utf-8?B?RnJSNDFSeFE5SDhRbHZIRHl5MXJmd3gwSGRYeWdHWWNQYi93OTNQbVQrN011?=
 =?utf-8?B?ckIrNTZCUEk3UzRzM29wNk1sbWNZcGpES3ZlbTZoZHVvT2M1NEUwY3IrSW9K?=
 =?utf-8?B?OWkwalo4U2ZFY0pEQWF1NXhYZEVXN3BUaTUrL0FOcktRc1pzQU1ybXd6Rk1Z?=
 =?utf-8?B?UStWWFUyU3R6MGkrSzdMOHY2VmdjUFpaaGJDSFJqL1BqVThMbGNiWVhtczMz?=
 =?utf-8?B?OVhDMGUvV0xuaFIxbU5NVzlsbm5TZkcwQ2pnNEhKYW9SdXh3NGtXVjZtQU1O?=
 =?utf-8?B?RFV0ODNVSWg2WW1ld1JjMnNqeUZHbWx5TEhQcFJoaVYyNGZVVVRFUXlhWXFR?=
 =?utf-8?B?cWJJUTBKK2w3ZVNzQXhxV24zaUxlN0lSM2hWblN5UEUzQU53OStiRlBNUUpx?=
 =?utf-8?B?N05tNXA3N1cwUWR4MEVSVXd0UUt1QTRmRWIybjJwd3V6N3NpSVZTYjY5TTY1?=
 =?utf-8?B?ZEVObFJlZTk2aWozUjBrYTFDVmwyVG02WjhGUTR2QzRvUlNrbVpyYms1a1J0?=
 =?utf-8?B?aVRrcFczSXNKeXhhYWt5Nll4enV3aUlQU0prYkpwd0hVSUFzQTNYY2dxdkJT?=
 =?utf-8?B?VDFuSXJVUTNqNWFlU3RrWjNPNUkxaGV4c05JcklKNW5nN0VvLzh2T3VxbENh?=
 =?utf-8?B?MDdsTjhDeFhNNEh1azROR2g3QVBkMUdtUnRESDhIazkxb2ptZmVxYjNjR0Fp?=
 =?utf-8?B?cWpJK3NOdzBVck5USkcwZU9GYmp1QkNVOXlTcGNIRlNxRlNHZnNjNUZMUE1K?=
 =?utf-8?B?a0RUSWpRRjNHVG1uRXpkbWFEUXhPY1pDTjQvV1ltM3ZrRzdlY05aRmNZam9X?=
 =?utf-8?B?eUFSNXA5WkhNdU1YMUg0K1cwK3R2WFN2dnZEWW55UnVkdFg5aHZrNkMwTzVj?=
 =?utf-8?B?eTg5a0hMYUg3QnlkdW1hTUlZMWUxL0Y5ZTBxdWRCTDk3QXM5UlBKTlNPSlJ2?=
 =?utf-8?B?dlNMNG51Uk1aL3ptTE5oMFNRTHdvbmlNeEVsSWtYRWJkelAyVWJDaXBDeVlJ?=
 =?utf-8?B?Mk1kMzUwb3Q0QVYrTHA1RUpvV2ZMY2RUaitZN0JGaUk0a0RQaHNhd0EzRGh1?=
 =?utf-8?B?U1NodHBiR0RHREhUMEh2ZXJiemJkYnFtVmtTRllCRjc1TnRUYXdoQVM1Z01O?=
 =?utf-8?B?SmM5cXZHYXBsVytNd3Y1NHBBUmJmc3N3YjVYSVh0cEdIaGNWb2g0emJPRFVF?=
 =?utf-8?B?WFhlSTRYNkE0WnJxZ1pJY3hPK2FpWWk5QkhvcjUzOEFaOHRsTFRsbE5YV1VE?=
 =?utf-8?B?OEdic3pMdktYRXJKMWhtTVczL3lEeDl2TkZtdXk2T01ZanI2bnhucmZIMFZl?=
 =?utf-8?B?d2VLZjc4SFJVUUxVZ0dCcTFTZWFhNW5RMGpZd21xblBlQXd0VFh0Q1JGRlZ6?=
 =?utf-8?B?RkdDamxWRkZwaGROQjlwRis3Vklsdyt2MnkxNHVvdFdxczV6NTVxUUdBR01W?=
 =?utf-8?B?SGdkcUQ0dnBNc01aMDh6M3doTzhYTU1YSTU2QVlaWHYwK3FkQnk4L0ZoZEJi?=
 =?utf-8?B?UWt1UHJFTEtxWldseHdoZGphN2VHemdPU2VwaXF5MjlBRE9qb2xTcGFiQW9X?=
 =?utf-8?B?MHNtSHlzNWczT1VmMUpYY2Mvc3F5dkhiLzM0bEdSM1RaK3pIWFBXOUJqeERJ?=
 =?utf-8?B?bGdXbXd0T3BsOUR1bTR6dHNkUkZZV1JqOE1nTGN6SFMxRlNsS2oyUWt3eVE3?=
 =?utf-8?B?UzZJSm9rUzVxQ0NCaEhaRHR1TGFBV0dDZWFtMEFsS1JFMWtNZHpHNEpwQ1Zx?=
 =?utf-8?B?UGUwbVRDMW5ibm5EMVlqMjA1eUNiYi9ONEoyNll4QVdtOU9ORUQ3UGRQZHl3?=
 =?utf-8?B?SXlDSFVLRWRKVU03SHZMVm1Ib3BUNHlHNGh2SkRxMnNRUW5RR0dadmFGUzVB?=
 =?utf-8?B?VXFKcHBiaDExVUhLSWI3SUpDOHZiOSs4SW5DM1hkZzVtQjFTKzBTakNiY2Z5?=
 =?utf-8?B?ZkNRL2pzWmVETWJISzB0djRIL0t0NTF5Y3BUa1gzM1A1MHBvZ3FjQlBpaHI0?=
 =?utf-8?Q?COzY+TQtNW3b2VZOKLRlbuY5L?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <691AEACF844AD24982AEECB9DCDDD82E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f463b0ff-217d-4854-4eac-08de0c32f9e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2025 21:37:01.3449
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8lzgQGajdnlZfnaPS/oNCZG2qX8xRYVJ9shK7BxmqACHOz8k7WgpUfpXB1j1UNblOSDn8bzbYKMUY9G608+iSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4899
X-OriginatorOrg: intel.com

PiANCj4gSSBoYXZlIHNvbWV0aGluZyBsaWtlIHRoaXMgYXMgYSBzZXBhcmF0ZSBwYXRjaCBpbiBt
eSBzdGFjazoNCj4gDQo+IEZyb20gMjFjM2I5MWFkNTNkZmMyNjgyYzAxNjYzZmU2NWQ2MGM5NDI0
MzE4ZCBNb24gU2VwIDE3IDAwOjAwOjAwIDIwMDENCj4gRnJvbTogTmlrdW5qIEEgRGFkaGFuaWEg
PG5pa3VuakBhbWQuY29tPg0KPiBEYXRlOiBUdWUsIDMwIFNlcCAyMDI1IDA1OjEwOjE1ICswMDAw
DQo+IFN1YmplY3Q6IFtQQVRDSF0gS1ZNOiBWTVg6IFVzZSBjcHVfZGlydHlfbG9nX3NpemUgaW5z
dGVhZCBvZiBlbmFibGVfcG1sIGZvcg0KPiAgUE1MIGNoZWNrcw0KPiANCj4gUmVwbGFjZSB0aGUg
ZW5hYmxlX3BtbCBjaGVjayB3aXRoIGNwdV9kaXJ0eV9sb2dfc2l6ZSBpbiBWTVggUE1MIGNvZGUN
Cj4gdG8gZGV0ZXJtaW5lIHdoZXRoZXIgUE1MIGlzIGVuYWJsZWQgb24gYSBwZXItVk0gYmFzaXMu
IFRoZSBlbmFibGVfcG1sDQo+IG1vZHVsZSBwYXJhbWV0ZXIgaXMgYSBnbG9iYWwgc2V0dGluZyB0
aGF0IGRvZXNuJ3QgcmVmbGVjdCBwZXItVk0NCj4gY2FwYWJpbGl0aWVzLCB3aGVyZWFzIGNwdV9k
aXJ0eV9sb2dfc2l6ZSBhY2N1cmF0ZWx5IGluZGljYXRlcyB3aGV0aGVyDQo+IGEgc3BlY2lmaWMg
Vk0gaGFzIFBNTCBlbmFibGVkLg0KPiANCj4gRm9yIGV4YW1wbGUsIFREWCBWTXMgZG9uJ3QgeWV0
IHN1cHBvcnQgUE1MLiBVc2luZyBjcHVfZGlydHlfbG9nX3NpemUNCj4gZW5zdXJlcyB0aGUgY2hl
Y2sgY29ycmVjdGx5IHJlZmxlY3RzIHRoaXMsIHdoaWxlIGVuYWJsZV9wbWwgd291bGQNCj4gaW5j
b3JyZWN0bHkgaW5kaWNhdGUgUE1MIGlzIGF2YWlsYWJsZS4NCj4gDQo+IFRoaXMgYWxzbyBpbXBy
b3ZlcyBjb25zaXN0ZW5jeSB3aXRoIGt2bV9tbXVfdXBkYXRlX2NwdV9kaXJ0eV9sb2dnaW5nKCks
DQo+IHdoaWNoIGFscmVhZHkgdXNlcyBjcHVfZGlydHlfbG9nX3NpemUgdG8gZGV0ZXJtaW5lIFBN
TCBlbmFibGVtZW50Lg0KDQpJIHdvdWxkIGFkZCB0aGlzIGlzIGEgcHJlcGFyYXRpb24gZm9yIG1v
dmluZyB0aGlzIGNvZGUgb3V0IHRvIHg4NiBjb21tb24NCnRvIHNoYXJlIHdpdGggQU1EIFBNTC4g
IE90aGVyd2lzZSBpdCdzIG5vdCBhIG1hbmRhdG9yeSBjaGFuZ2UsIGFsYmVpdCBpdA0KaXMgc2xp
Z2h0bHkgYmV0dGVyIGluIHRlcm1zIG9mIGNvZGUgY29uc2lzdGVuY3kuDQoNCj4gDQo+IFN1Z2dl
c3RlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KPiBTdWdnZXN0ZWQtYnk6
IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KPiBTaWduZWQtb2ZmLWJ5
OiBOaWt1bmogQSBEYWRoYW5pYSA8bmlrdW5qQGFtZC5jb20+DQoNClRoYW5rcyBmb3IgZG9pbmcg
dGhpczoNCg0KUmV2aWV3ZWQtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCg0K
PiAtLS0NCj4gIGFyY2gveDg2L2t2bS92bXgvdm14LmMgfCAyICstDQo+ICAxIGZpbGUgY2hhbmdl
ZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNo
L3g4Ni9rdm0vdm14L3ZteC5jIGIvYXJjaC94ODYva3ZtL3ZteC92bXguYw0KPiBpbmRleCBhYTFi
YThkYjYzOTIuLjllMGMwZTI5ZDQ3ZSAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva3ZtL3ZteC92
bXguYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jDQo+IEBAIC04MTk5LDcgKzgxOTks
NyBAQCB2b2lkIHZteF91cGRhdGVfY3B1X2RpcnR5X2xvZ2dpbmcoc3RydWN0IGt2bV92Y3B1ICp2
Y3B1KQ0KPiAgew0KPiAgCXN0cnVjdCB2Y3B1X3ZteCAqdm14ID0gdG9fdm14KHZjcHUpOw0KPiAg
DQo+IC0JaWYgKFdBUk5fT05fT05DRSghZW5hYmxlX3BtbCkpDQo+ICsJaWYgKFdBUk5fT05fT05D
RSghdmNwdS0+a3ZtLT5hcmNoLmNwdV9kaXJ0eV9sb2dfc2l6ZSkpDQo+ICAJCXJldHVybjsNCj4g
IA0KPiAgCWlmIChpc19ndWVzdF9tb2RlKHZjcHUpKSB7DQo=

