Return-Path: <kvm+bounces-47093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 370C9ABD392
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 11:37:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1E8257A20F7
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 09:36:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F9D5267F59;
	Tue, 20 May 2025 09:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LSXMPopm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2FDD25DCF6;
	Tue, 20 May 2025 09:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747733852; cv=fail; b=BlrEPbr7w/n/gKPOB6AT+/StW7hwYTZ1LexE5VPzhUHlgtqHFWjN93ng0yvmyI5mtnr1bIuGhGB0r/6dUJ9D6nQic7dtyHgA8HFp/3hQDUlD9Wke7DeHWcxyrREk74WjwtXp0BoxPIUiWa0LU4IwmOZAJdUbqrmZk/a8tXOgJWU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747733852; c=relaxed/simple;
	bh=nGzOa8vLzPyngvFoKhusrUBEB8JzjdhmLO3IktzLiTE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DNjP/NQ9WjEnfNAlUl1SBbS7vgQSRlWQSYuHOMQL3tic9382EeLdRB6lvPK00EkHT/XjFVuDveZPOubCEE814Ix2HSxicvOrkuPcrKhqbqxSznsaAQK3mszIJSwzCSxPbop/Wl+Yc6mSbLDcHyTZCBIKh4dWGnZt7FxBbYHJRos=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LSXMPopm; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747733851; x=1779269851;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=nGzOa8vLzPyngvFoKhusrUBEB8JzjdhmLO3IktzLiTE=;
  b=LSXMPopm98zmq0EmDF7cUiWDZAxxQEuytEQTMfIXdUcchZEse00HRfSq
   l3P0QDcMqRGa7ItOJiEReHFNj8LDU4adFgl+PTwmsCrqaXr/t36IR2fyR
   n86fWxd40fdiK5FQ08+wVDw6iNcmBNIfggY5P6XS5Qr+uUcY+9WscgfY3
   6Dxy71m1oV69UH1ND6Im3OT9E1ujnDsmIyWi7GqF3AjhBeI68aGwuxhFn
   NRTpaViltNBk6N4G4d163HNc+ihamABtLjj42rrHFjv3vXV03mKQoCK6E
   KR2wlxCxEE9RtDYZUF0oAOpb6SywBL3k6fzsDyTzn2Vd6sRoaiSxk/OiA
   g==;
X-CSE-ConnectionGUID: 7oY+B7zzQKGhvoc/V3e1Sw==
X-CSE-MsgGUID: +1stWRAtRniaY69/os9qeQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="67211875"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="67211875"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 02:37:30 -0700
X-CSE-ConnectionGUID: tcLV67QRQ62N2XecIK++7g==
X-CSE-MsgGUID: ElGdyVPtTQmqPzzwGGcttA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="144625720"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 02:37:30 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 20 May 2025 02:37:29 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 20 May 2025 02:37:29 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 20 May 2025 02:37:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xfuMjl0Qaas/c42JBf2hoVv3jTEjHr4CSpjuvToR9KqhRjBzIU3RIQBQrTkknw6Fj91K6vyNLvRo6j0PpqWWqGc18rA2d7NlYSNG7Fl3A8mjou7zmY3A7k0Ax7Gcq7xlh7Squlh/i9k00GRHElN2oG2ilJx3HkawJ1bPAsN7nnBH1LEmP869hu7V7PZyhSKuq9sNtdPbW5T+l6Il3758+fwLVPw0DIogiM27sqEddMH+pNcTXqX8p/xkUzwhKv8Gfv9/AmQdCRNbZYvEvU35A30nV9zav/HDDvmvQ+op6C7rXVMTVkLVRVN3MthIoJBAmDBJbYHKVDv3KDagAdaCtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3WnCpkaKzqvwXekIfk7idlLPklaXmpdBApG44CGMMb4=;
 b=JJkKbOjhfxzBbfAtvFkM/G/DS8Zb2QJNVOMby8BDmd9Kav+E8R97XEjozC9xO+aYpgRjGr7LAQg/FZ1Ttm6mltGzxwxfQVpBikDderH73FNP+MACF67mY2gf4vV+CIGzMMbEfL2n4WfrOboPmZJWETqmTgi+jTjtmc+aMm+M0DBMiOJw696RX1KZxCuRdnbn9ACVUd5JhT5sKGWHdzfX0fC/mAnH+JS+4I/GEjYWzyuXkWEycOykJShegHyLFFWC1ZhcSn8N1b5qjOdR1mw3JGmz6dZXxRJ7YGZj7hgMd19kagfN2JT0DT/HajizdO5qmeRvV6nghxmLYJjCyTL40Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH3PPF25FF87461.namprd11.prod.outlook.com (2603:10b6:518:1::d10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.31; Tue, 20 May
 2025 09:37:00 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%2]) with mapi id 15.20.8746.030; Tue, 20 May 2025
 09:36:59 +0000
Date: Tue, 20 May 2025 17:34:46 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"tabba@google.com" <tabba@google.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"Weiny, Ira" <ira.weiny@intel.com>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Message-ID: <aCxMtjuvYHk2oWbc@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030618.352-1-yan.y.zhao@intel.com>
 <dc20a7338f615d34966757321a27de10ddcbeae6.camel@intel.com>
 <c19b4f450d8d079131088a045c0821eeb6fcae52.camel@intel.com>
 <aCcIrjw9B2h0YjuV@yzhao56-desk.sh.intel.com>
 <c98cbbd0d2a164df162a3637154cf754130b3a3d.camel@intel.com>
 <aCrsi1k4y8mGdfv7@yzhao56-desk.sh.intel.com>
 <f9a2354f8265efb9ed99beb871e471f92adf133f.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f9a2354f8265efb9ed99beb871e471f92adf133f.camel@intel.com>
X-ClientProxiedBy: SG2PR02CA0124.apcprd02.prod.outlook.com
 (2603:1096:4:188::9) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH3PPF25FF87461:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a7e4b5d-6991-467e-479a-08dd9781de22
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?kKLi3df/l5QckdkfJ9HE7aiA8+uj57Pwdnhy73ytQH6CrwCJvvAExiZW/Frt?=
 =?us-ascii?Q?aHT50l+p9zlsxtnYuwdXyFNpS6GjEO1gXbHc0IHKbokHkBQxWleWTFxlHkSR?=
 =?us-ascii?Q?0kGuD8c6KPbOqENE4wa8Eq2V9gD/8LGdBI2fnPDgPqbWYWiBzqdUx1/+inT5?=
 =?us-ascii?Q?q5DavLEdAZQ849J1SHOAGFFcPlEUkGKw8aU8ljBFeBXHRhcl+vUIY1hvKF11?=
 =?us-ascii?Q?OovAasYsF49CyBn77Hw+9Tbv07K4GcqKDWj0Oef9X8qMiWssJS9x10TbPK99?=
 =?us-ascii?Q?QZNFsxbptA+zUBkOHVTNLHgJVc43bOAKTVxn1Pi8aN+y75FF2KuzqsMo1mtU?=
 =?us-ascii?Q?x+WGaXQTYGlxclxcQb9ifki1om9UMgmGs1Y+hyUl4QVrcHbr74+ehwPj/Fq7?=
 =?us-ascii?Q?jGG+Mu68KACA2+EQPyHlsrZ3dtC8W1kV9r5goWkHDC2N1bzrBMJRS5X3eXNZ?=
 =?us-ascii?Q?+zIRrAuU699YuIzsm/90OLictepGIT2cRhxFRjztGOFhqdI3KjyDFlMGUZpn?=
 =?us-ascii?Q?ZQBjLCCirNw0ZgVGfUuA6dOB9lMbEgAmMLMYinJMP6NtdYzSsIcZ4vCPs9bc?=
 =?us-ascii?Q?vypUGpPv0wQffxDif5kdj0Iz9NvH+mBmKWy0yv1PZ0GSyGr67YE9vtEWg892?=
 =?us-ascii?Q?FO1ybncvyJ0DiNOlSqubuFK2ZLfVRe5ecs+qtAkIOSsTJZ91e2W2a63NRV3i?=
 =?us-ascii?Q?iZj2yohHkDpy0RD+QF03ZEp8IDhBfpTYfDCbqfcleN3EjvVaw5FwV9YUSZMP?=
 =?us-ascii?Q?iGFKxl7W3trGQdqkac1B+DodqIarX/9yek14LpaAS6joS8WSXDsvesV0KOjy?=
 =?us-ascii?Q?VDhwFfZii8CUTELZX14AR8zrjLOKepn74kiI22NZGR3QOVwlRaUDwCXveKni?=
 =?us-ascii?Q?XOvVhz4F/430n1gIClOAQHWsSfO7fOr0na0dwrk3Of7Ypy99K2CbYJNfNBEI?=
 =?us-ascii?Q?JovOLUfd0qEdSIiLY0o+YG5Hhv6hA8I4AnFamCUgGuuSGtDkjbsU/xl9sd4t?=
 =?us-ascii?Q?e3I2BTBhRKRs1enJFFqqmTMofmTxiqwy9eI3eQOXNHXiyeZLFsC+k1kjQh5y?=
 =?us-ascii?Q?QQah6bPNf/kDSRdDty4WU1PLuuppxysg2Ksmc94UGNQi7GjyY0qQtg8uumRG?=
 =?us-ascii?Q?2IepRCPLlgN3xKTyCcUkrnWaVjOdZwJir3B84UHluF7ZQYwqKzw2jOcaFh9W?=
 =?us-ascii?Q?+RrVAw+YMpsGcHcQetFTAQBPc3C0kohAofrjeASe/Z6w9H13jhybAmaFmsqV?=
 =?us-ascii?Q?fl7RFUumwKP4KM3T5W/4unKJNs8eb8rMe1KHiaIJais3m/fWsRhBCWnbByJ/?=
 =?us-ascii?Q?wnZZGsk9LFLB2ZumN0vxRU0m/VgC9dtM5vNEzSZYYzg9LCPNdEsqmjltl9sT?=
 =?us-ascii?Q?hgortKCqyLkLQViQLJzAKDGK4tQn?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BzMLk/Ew8xLFmRILKTsnNMdD2uqAxpythxrWrflcjpRPhumKDtlG5wp1sd5l?=
 =?us-ascii?Q?bRG2Atu9OxEDuOFKbLZTDBD2MkB8BbS6c89IhuB1KbVaJCcBp2wGsKw0qy1r?=
 =?us-ascii?Q?mDvvZ2qfYOH3cUbI78kDmKOHkJHTuGcnI9S1IwnnktXyYLWxGOy00Ny+mnya?=
 =?us-ascii?Q?uS9AXhNiWd37XFbDCFCkF0yx563nzIUciaIjQrOjtScp/7b0MtK/OIirssSn?=
 =?us-ascii?Q?ptBllQP4PtfsDz/53CLdCoP+LnsZ/4OAT2zVg77U1/7ygf0RQFOb7/dxLXXq?=
 =?us-ascii?Q?GTJ3+TTk+W50iYFnNgY75XYLX3hrcHEh0C1/aX/kO0ngl3VklTJzNNSKyjBs?=
 =?us-ascii?Q?a7h6H798nSjoEd/tN8VEtBJdZr1Z317pfJJDxH6dH/cRcvAE1f6WAfXMtO1h?=
 =?us-ascii?Q?LArFclGGLjik/WOHw1uRD9QRZah4h0z/PVML+th57K6cFzeLHMqblOt9nKxG?=
 =?us-ascii?Q?k36Q/qrCrz2s0QVKRF9lZ+FIOk2J81HeRUCIkRavn/JI+agBwlXoHZHMFF0h?=
 =?us-ascii?Q?gg4ukY9EhpetgDQb2eGmCUnPojUUCQCVPXBHT0XWM4os9k1euOPYa8CF3PZW?=
 =?us-ascii?Q?l+BVDKDsbFFAT1AhafzrHReYJ31Wy89PicWNHGIx74DmNl0Sln6DsWPBBTr5?=
 =?us-ascii?Q?iYT4vm8qMQglHnRfbOJbBoM5OzM9bmgIIWvOa3vSpZIUmo4mAQQs0d3CM9qR?=
 =?us-ascii?Q?o4wE+dX0cqRi4xJq9VRlXXn5soVI5gj1NJDiWAIRXZxXMUFREUU1EjubP0jj?=
 =?us-ascii?Q?Nb4CF/ZZ0g9Au04Or80to8Lexdt/LWX1ZsmUht51yFP0EfT6c+1bgHjEFQso?=
 =?us-ascii?Q?nG4GwxutiHbkqC8ZyYJfpc4CjbRNWBL+ZyIsKMFmkaHUdRt+T4y3bKJ1T4oK?=
 =?us-ascii?Q?EPnrGhYDr2Ys4LMuUOD2AyLeJ23a6nsTW63e0+7skMol1lihENMNsg3bwJr+?=
 =?us-ascii?Q?OPzm3/MBC6/zu22fhGEoux4bLIHl5rPL8GE4rBEkG3Qr5R3d8sSz0OGHHcr4?=
 =?us-ascii?Q?pjQx2XT2b6K+CtW5R03twsjdEsc344FVHPhwLeGgwT96DceHTZjYZKsz8HvI?=
 =?us-ascii?Q?wwNiW5/vE9Ot1abk9DEnJLD6KZ3Dodv8J/Q+/+ZVJZmEqdFqL7ZncvycuS5v?=
 =?us-ascii?Q?2XZg23k2SSjWes8QxEkxRHS9yt8hxY2ecy1DbqsMFNNNbcu8YjG15VANMeq3?=
 =?us-ascii?Q?mciikUFutCvTFrbs3+JeIFFvBW18nHhoGYtugza+nfSJ95+XQ4HhUCNsA4O9?=
 =?us-ascii?Q?d/vD3wrbsE4TH/CdIt1eYgTnkd6HgBv0FpPf2kl5e2AhLT4Dt7929VB1QARo?=
 =?us-ascii?Q?OUeuwwMGSWJrtJFLNmXjYqE4wutPULMxfO4tf8QDSNS4T8TaJInZejpCEX0O?=
 =?us-ascii?Q?lDFqnGaIo0AJuOz648K3EOT1NjCHLDvAxaB1YpiSqrpPgESg9Z1YMISGF15j?=
 =?us-ascii?Q?WvQYAfL10pqjlv9aPg+7PTBdzVTgUsz+hlQEQCbBNdG9XzqsBlI8pYSyhNBV?=
 =?us-ascii?Q?Zm5ETlyq+pVuN9O3bw6Jp1ZkU+pYuQYIKZnvLyeCJEJUR61auxR912s2e9fW?=
 =?us-ascii?Q?Cb8/DzFcLch31ygrmSGscior4Yzp4Knr7FjV4FSa?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a7e4b5d-6991-467e-479a-08dd9781de22
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2025 09:36:59.2638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 79GLAipOUw6B4x8kPyCvXHk38hTBeVwtgC/3gfiiqzpNLtDsJ8H2QB6C68SDiUxWrIQzSwdIGxdZzpv9lkTmuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF25FF87461
X-OriginatorOrg: intel.com

On Tue, May 20, 2025 at 12:53:33AM +0800, Edgecombe, Rick P wrote:
> On Mon, 2025-05-19 at 16:32 +0800, Yan Zhao wrote:
> > > On the opposite, if other non-Linux TDs don't follow 1G->2M->4K accept
> > > order,
> > > e.g., they always accept 4K, there could be *endless EPT violation* if I
> > > understand your words correctly.
> > > 
> > > Isn't this yet-another reason we should choose to return PG_LEVEL_4K instead
> > > of
> > > 2M if no accept level is provided in the fault?
> > As I said, returning PG_LEVEL_4K would disallow huge pages for non-Linux TDs.
> > TD's accept operations at size > 4KB will get TDACCEPT_SIZE_MISMATCH.
> 
> TDX_PAGE_SIZE_MISMATCH is a valid error code that the guest should handle. The
> docs say the VMM needs to demote *if* the mapping is large and the accept size
> is small. But if we map at 4k size for non-accept EPT violations, we won't hit
> this case. I also wonder what is preventing the TDX module from handling a 2MB
> accept size at 4k mappings. It could be changed maybe.
> 
> But I think Kai's question was: why are we complicating the code for the case of
> non-Linux TDs that also use #VE for accept? It's not necessary to be functional,
> and there aren't any known TDs like that which are expected to use KVM today.
> (err, except the MMU stress test). So in another form the question is: should we
> optimize KVM for a case we don't even know if anyone will use? The answer seems
> obviously no to me.
So, you want to disallow huge pages for non-Linux TDs, then we have no need
to support splitting in the fault path, right?

I'm OK if we don't care non-Linux TDs for now.
This can simplify the splitting code and we can add the support when there's a
need.

> I think this connects the question of whether we can pass the necessary info
> into fault via synthetic error code. Consider this new design:
> 
>  - tdx_gmem_private_max_mapping_level() simply returns 4k for prefetch and pre-
> runnable, otherwise returns 2MB
Why prefetch and pre-runnable faults go the first path, while

>  - if fault has accept info 2MB size, pass 2MB size into fault. Otherwise pass
> 4k (i.e. VMs that are relying on #VE to do the accept won't get huge pages
> *yet*).
other faults go the second path?
 
> What goes wrong? Seems simpler and no more stuffing fault info on the vcpu.
I tried to avoid the double paths.
IMHO, it's confusing to specify max_level from two paths.

The fault info in vcpu_tdx isn't a real problem as it's per-vCPU.
An existing example in KVM is vcpu->arch.mmio_gfn.

We don't need something like the vcpu->arch.mmio_gen because
tdx->violation_gfn_* and tdx->violation_request_level are reset in each
tdx_handle_ept_violation().


BTW, dug into some history:

In v18 of TDX basic series,
enforcing 4KB for pre-runnable faults were done by passing PG_LEVEL_4K to
kvm_mmu_map_tdp_page().
https://lore.kernel.org/all/1a64f798b550dad9e096603e8dae3b6e8fb2fbd5.1705965635.git.isaku.yamahata@intel.com/
https://lore.kernel.org/all/97bb1f2996d8a7b828cd9e3309380d1a86ca681b.1705965635.git.isaku.yamahata@intel.com/

For the other faults, it's done by altering max_level in kvm_mmu_do_page_fault(),
and Paolo asked to use the tdx_gmem_private_max_mapping_level() path.
https://lore.kernel.org/all/CABgObfbu1-Ok607uYdo4DzwZf8ZGVQnvHU+y9_M1Zae55K5xwQ@mail.gmail.com/

For the patch "KVM: x86/mmu: Allow per-VM override of the TDP max page level",
it's initially acked by Paolo in v2, and Sean's reply is at
https://lore.kernel.org/all/YO3%2FgvK9A3tgYfT6@google.com .

