Return-Path: <kvm+bounces-57732-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AFE14B59AB8
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 16:47:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2392483E69
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 14:43:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3546C3431FC;
	Tue, 16 Sep 2025 14:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W32Tb15A"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F34F33A034;
	Tue, 16 Sep 2025 14:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758033795; cv=fail; b=rOS6mi5gVyy9iFgWZ5LpMVRPlSw8gzl4nYuOVrmbpsMhq3XU0cDmq2Zv33P/p44J2v2TthbDvJBwBZVm2+Rauh4RIHDBjFccpBqJHLnw5V9ViGSnod45bSi10xR6+T2GesbpzLdWSM+3tTpgbsfcltrbMxzF9AX0aWO+rCLHE/0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758033795; c=relaxed/simple;
	bh=hIUY484VsP4ZPONKuwgqNAJx2hfVkwA2AQhVQXjROfw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=g0AlfxdrhN3Pk2YZJ7M5xb/EHuFUUMnSi9LMurIUOrbBed8MET3M/6SDexDL1oQtKnY3vKLUpddsUv8vLsxl4Sod3UWFZX8fb00yd30bcT74SVgOCvOXxYw1tD0xKVhAImdSmokfAHsR5OTHb9bPxEyvcMJynpFJ4rDjz+PTdng=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W32Tb15A; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758033793; x=1789569793;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=hIUY484VsP4ZPONKuwgqNAJx2hfVkwA2AQhVQXjROfw=;
  b=W32Tb15A3kJXwMYvpW2bEW3gF8AUpfHUUCrCEiYBEX7pDUDpSBfF2Oi3
   3xL+1sPt9BpUeivbxdald0QzkQJNLo38FQmqpl/xvQ1OmSbEPBjJnLg1g
   kF0MMfcu5CY4xvCxgz7/WtfJMJgyELIwKKRz2ZRry452N+6495hGjPyba
   aer/G+nXd/TNgcts7zg8VE4zh7UBmM3kU5vVyhCUVo/wl7zpLNEZgqDc7
   lRXtupKkf49TwQHuoayPAQ853W64xErEnfcqdyHszkXAxQMCygIDfWRoP
   eDFhFBXnq0bwDaKfZuFzvCeEOi6iGtTMABPZktpH9AG75Oid3tDefST2V
   w==;
X-CSE-ConnectionGUID: SYSHlS39RhKQqaQKFV+JUw==
X-CSE-MsgGUID: 99K5Y0WDToyvJ8S2ITfs+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11555"; a="60426784"
X-IronPort-AV: E=Sophos;i="6.18,269,1751266800"; 
   d="scan'208";a="60426784"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 07:43:12 -0700
X-CSE-ConnectionGUID: OSWDP1jeTsafMolM/WiDBw==
X-CSE-MsgGUID: summ0qXPT9GJ/LgmhHZooQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,269,1751266800"; 
   d="scan'208";a="180096028"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 07:43:10 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 16 Sep 2025 07:43:09 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 16 Sep 2025 07:43:09 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.69) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 16 Sep 2025 07:43:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HaiYfis5NLGZtHtnzrvu5LtXcfcmOiMoWAv54s/MF248eCZ+AHiFbGbYYKlhURFUI/qPc2QVqD1no5g4QdlDSEtPPiApPOnb2cYENcK7LmdWJH0b1c0Iv5lq7bRf9uvUFeQ9YfMFcE92UDa2R73R15elifGNZ3tSE426TJyzZ6Ig5wQ+mf497KMhqr8pA3EsmoFxOdyeA8e56n4QOihC54qpf+yJiWnrlAAk3OFBDVCajGsdxAU1FhGRGpfdxWYupwklA4+XIBBvcTEO8snT71zywK+yzp7CwCrI5Zujm8kQYrfXtq2emQN6Jqec2r6My5i3e1yyTaFyEVt+q0Egnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=16DKR5hAe0hqJG1NVhz6WiFFhVPaA9mpLxVFtZKLD9Q=;
 b=xJHdappTGpOUXtGV5H4bTXUp5vQCTA5JzA+GDPcamkmJHoENuual8PgLA0jbEhrkCBAsxwuczJreW6y6b1xnKDqcDHwpzZVIpNHJO+Qzwd/HOK4hHc2pJbZD2a3GRRoJDMRoT+K1IFrhhIeL2cuWiwc4B3JRU/wS9/eloS3ltittvmkLUn67H5LjN0jIl2wfQ2kWxOM7bCiaMxXGTzWp2nVvjLBkp708DgjKO5GME4JxUQsh+AzDJbDKUbPrj6vO7IIz3bueIBlcIfVABBgdkpVlXBL2/O3Kh1nHwQvNSYDrV0oxtCqUz2OY47SoRsjLs3jt4z/R3QIP/JLule+oCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH7PR11MB6056.namprd11.prod.outlook.com (2603:10b6:510:1d4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Tue, 16 Sep
 2025 14:43:05 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9115.022; Tue, 16 Sep 2025
 14:43:05 +0000
Date: Tue, 16 Sep 2025 22:42:52 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Xiaoyao Li <xiaoyao.li@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <acme@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <john.allen@amd.com>,
	<mingo@kernel.org>, <mingo@redhat.com>, <minipli@grsecurity.net>,
	<mlevitsk@redhat.com>, <namhyung@kernel.org>, <pbonzini@redhat.com>,
	<prsampat@amd.com>, <rick.p.edgecombe@intel.com>, <shuah@kernel.org>,
	<tglx@linutronix.de>, <weijiang.yang@intel.com>, <x86@kernel.org>,
	<xin@zytor.com>
Subject: Re: [PATCH v14 15/22] KVM: x86: Don't emulate instructions guarded
 by CET
Message-ID: <aMl3bAHObST4b1S/@intel.com>
References: <20250909093953.202028-1-chao.gao@intel.com>
 <20250909093953.202028-16-chao.gao@intel.com>
 <8121026d-aede-4f78-a081-b81186b96e9b@intel.com>
 <aMKniY+GguBPe8tK@intel.com>
 <ac7eb055-a3a2-479c-8d21-4ebc262be93b@intel.com>
 <aMQwH8UZQoU90LBr@google.com>
 <aMQ4L8id7f1fK16J@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aMQ4L8id7f1fK16J@google.com>
X-ClientProxiedBy: SG2PR04CA0202.apcprd04.prod.outlook.com
 (2603:1096:4:187::20) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH7PR11MB6056:EE_
X-MS-Office365-Filtering-Correlation-Id: cdaa58a2-dbab-4644-3d36-08ddf52f586d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?cv82Jen9mq3Hv9i2n/lySScvFsOYio4Ge+oM7LOinFxWSVUlJJ4DvPZoa4ZH?=
 =?us-ascii?Q?Pe6Xprz2c7surrRdlbztbSTFIFmvmBjXjPvUm35GO21qnUNi+xOck1CcsVAS?=
 =?us-ascii?Q?NRZa1el5lS/ajRvP7+4f5UPK+ggWzFe26CYR+kT6rTjvOlH+AWqPsn1H97hN?=
 =?us-ascii?Q?2Ah3+pGJSlwdbII2Mi9stPJubPGjkkrXOc5B6fH9IeV5MyL0KyDY9QGqc6Rr?=
 =?us-ascii?Q?xx83gi6spJj5rHxZBD+Mftk76mXpFDiL3QvQLx82b7ApviAFXrUlbL6OJ0yV?=
 =?us-ascii?Q?FFRoWJb572qXrTOAc240NscWZLFuPnloZRxt1IEO0g0tPntUitsnnnhSi8O7?=
 =?us-ascii?Q?TDAqk645+8gm5eGAiC+aLWdMJxBqDYbSkLPAQ8GtZWgeDK1nPlLWJ5sRZGg+?=
 =?us-ascii?Q?NOAcjhs8LJJj8rh7HPvHrN9e1XcB/p3OvIaHNl7xqMp46AGvEjkWK0rBnKAt?=
 =?us-ascii?Q?QdMefp5/L50OGeqT0ZdrDV0ayevrd4Te3lGIGnae3EiZTPQHdNWqNMcdBqYl?=
 =?us-ascii?Q?An26dEsTXNnKo0gwBBs3pgCpE+v+GCPAY6joOfAkCgtGXNRF1pTXvdJjNhcy?=
 =?us-ascii?Q?MkbkT8ybES60sDmL0PetUGTkjkqFGC23YnJ2jAlnfCRxit0wykSJyZDOXSM9?=
 =?us-ascii?Q?ptdk1jBsx6PY2CKvCy3l66ngUzXVTdIgc/xuik8qgjjMlX+L1fQKLPDCxHPN?=
 =?us-ascii?Q?6fbo2liWZd4/2lT3YJykgBfncBWWH4ivsdisaSrsr2jxNhJ+J2fOK0xE2ltH?=
 =?us-ascii?Q?+tUsZAESHOQoH4HRN3xGdA13lXJnOZNbMdiOAkR6+V9Oxm+nA04C/OewB+gf?=
 =?us-ascii?Q?BrBVfq81gxSvgLx4WYF1gxwM/m9qlEONVO2B8vRGpZeMfGqUnHJSqvboBXfO?=
 =?us-ascii?Q?Uty3N7SvA2vTyqYGNIX5DrAxakeiF9XjINZO8tNHpoRa5pV59bR5W9t7Y+uG?=
 =?us-ascii?Q?NGc7ipd/ZLh36Ye0Hqmup6UyJlxef/n90GvUPku6hVz4Z0jYMjaspTwh3JIS?=
 =?us-ascii?Q?9Fya4Hnltejr2EfSeiwWfsl8l3n9xJsZeiL2V4HZTyogpKpemo+LPrGe1sHN?=
 =?us-ascii?Q?EYcUvSveGhCh7rrHc7qCawEcicR9wHl8MNQj7jAj7kjs6UC/X0296X/9hLzC?=
 =?us-ascii?Q?9NDi/ptduNZxH9JeCrHqP3l1d+BZxNul17nJCzw9b9rrdHkdWluDn/x39i8T?=
 =?us-ascii?Q?mLxgZEMt/1PwO3m5GNCwblSdQVZcCqUrsZWafHJ/JLGJ0n+TtuEGB3ccQPjg?=
 =?us-ascii?Q?lXCIdgWmFowJ4kg3JQD/+BJOZQFGY0iPS4Qyb83Pb65vFd8/vVrmcTI58wm/?=
 =?us-ascii?Q?VkA8O/WQlXhj/mdiljLzx3xfmPV0TEidOgCdenpZsE1DpC42Q9p2dBKNOYql?=
 =?us-ascii?Q?ivZ2Msc27Af70MqZK6gPrye8HyVJ/pMXIYEJbAW+zfJJIGIzWeTZ6QkH4tzT?=
 =?us-ascii?Q?7U33mecbYgU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rrdmeb3csh3p+HPPa0tDJL0j5ubg7HnqhnRlw3j6CcqLfbjaKAraxuyS6A9T?=
 =?us-ascii?Q?Ih7t0YhqonLwHnHL5mhzGKQWpte5WW+2VjmgIZZmE5I6fwbF66l/Ve0Eo6Am?=
 =?us-ascii?Q?bIHelQyiKOduPgdeSRpDXbWWLAj2Dy/Sm8ymJhCU3fioR3eToffCjgxfH0US?=
 =?us-ascii?Q?Hlk1d/UaUhFro9k+5zHGyAP5hx/bq6OtYdGOJ2bvsNSVvmZZIdsTkZLWKaTm?=
 =?us-ascii?Q?KfY0/Et/FAt3H4vWUJDlXi2/OOIWavXozGz1mfBOzNbmFhkoLWQYv5/zM9WS?=
 =?us-ascii?Q?eGkXt6yxopmXzJI8Apy3uHl77fsNLMZy1p4F9s7awC/0oit+GcBDkUHihE8i?=
 =?us-ascii?Q?/1frbJs4lsSIoJ9oX0hNuV41mgoyW0vITlbtmUa0fEd8gbqXuAKi1d37kJUT?=
 =?us-ascii?Q?mmBafpqtT33MA3jKNmfdiA08xpxJFugcdLADV++wGauzAIQCkJsjDSnW5c3Q?=
 =?us-ascii?Q?7rMH4/fkg7B6r/br8Vayu/DQ3eVaam+IDakanPwEtSbdYL2aGsHZB+ygmJAR?=
 =?us-ascii?Q?TZP1zIxXhjwsgkG0Vy7j5rED77h6SYxMqz+jj6aTSv2BHzCRopyLnFhvHjGm?=
 =?us-ascii?Q?kPZO3DL1RVmlK+CeV22/klkK2ds7h0ECdzh1cM/vCq/gyHaHS3kRwfBszm3c?=
 =?us-ascii?Q?NKGbMcyBG5m8iHlyT91ou6iFY66jUUXIRX6ps92eg3cdQO0udyUuYZIoedsi?=
 =?us-ascii?Q?mlX7P/TyQc1yUHUb0pSWUb5Vk/J5h7sgXIfaA/Y48fCbHJyTLJICuLLvURZt?=
 =?us-ascii?Q?N75bvHnwnUfzBGOjcrGYLKgGahX62+oaZ3pMua+ou9sNmIjMXVGMRVtbVS2o?=
 =?us-ascii?Q?I8hzt3JNesACayg9Hj+gjJawF81HJhKcp+E0vqTb4v9N8eRbnstmjUpZAlaR?=
 =?us-ascii?Q?tfIbjy/1P0HeQ+h+cR7Gd875OGtwAASrOowvn7PfhLwf+S86wo2AdNVSGNPN?=
 =?us-ascii?Q?+cIWaZhbB4HEv/V5mLaidbftnfY5xl4L1eXsbNX9QWy2CfZxjFDiXKRasBzC?=
 =?us-ascii?Q?RYowxPzIa+ddpWDC8qma9bo5kUAK6S2+pZkABIK9jGzJSrqHM5V+858V5OWF?=
 =?us-ascii?Q?J89gVZb0VgLhrMwDh9dkVGLn+WncE0K5ojml535NgJCnS82hTSrsTIr7yKZG?=
 =?us-ascii?Q?giOv2dXWAyrbuZxzwKSR2ZTurPC3C5OVmufG9gs6/Rhj3cpkTlzXvJNIv0P/?=
 =?us-ascii?Q?y8L19Q8vhxYduBt5vrpHl4dyiNGPFjg+2RsVDFLqCh+mv0XR6XIUSbUUgEyv?=
 =?us-ascii?Q?c+Ta5RSlbHfOSA8KFwLNPIos3GsaxGNOM2c26Hl7adQMcF8D2/Xhnwo/cvht?=
 =?us-ascii?Q?IfXYvljfzP49yR/FfLpEtNP6hjG+2+xweOoMovTbA4D2Sq8fQP7xFV1frkXf?=
 =?us-ascii?Q?FGoNsfslkEgDdolmrH496b3Q61RhW130QZYsQ8FH9Nz3d+1hCeeFTLfzdaP3?=
 =?us-ascii?Q?pH/JLwypyq7KxLzTyd5c+/RuJIlQwYkU/fcosrzCp3zC00j081ggxx6ITNLt?=
 =?us-ascii?Q?guGSyNuNI1+V1O8h3wGsJy7ipKk+EfA6Qh45UAZfcOr8zM+PDoyXMNtLltJ0?=
 =?us-ascii?Q?P4MqtZhZ1m8GUfwGLb0Lbhm45z8Ka6YpQvxqAipo?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cdaa58a2-dbab-4644-3d36-08ddf52f586d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 14:43:05.4305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a9fGTOacWoEVjJURWf+9/9WK2V7plNBJAnqqblxNVhiyuyV8aKFvGxChCHJ05OF9HzT7T8WXRURV38r9K2mXoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6056
X-OriginatorOrg: intel.com

>On second thought, I think it's worth doing the CPL checks.  Explaining why KVM
>doesn't bother with checking privilege level is more work than just writing the
>code.
>
>	/*
>	 * Reject emulation if KVM might need to emulate shadow stack updates
>	 * and/or indirect branch tracking enforcement, which the emulator
>	 * doesn't support.
>	 */
>	if (opcode.flags & (ShadowStack | IndirBrnTrk) &&
>	    ctxt->ops->get_cr(ctxt, 4) & X86_CR4_CET) {
>		u64 u_cet = 0, s_cet = 0;
>
>		/*
>		 * Check both User and Supervisor on far transfers as inter-
>		 * privilege level transfers are impacted by CET at the target
>		 * privilege levels, and that is not known at this time.  The
>	 	 * the expectation is that the guest will not require emulation
>		 * of any CET-affected instructions at any privilege level.
>		 */
>		if (!(opcode.flags & NearBranch)) {
>			u_cet = s_cet = CET_SHSTK_EN | CET_ENDBR_EN;
>		} else if (ctxt->ops->cpl(ctxt) == 3) {
>			u_cet = CET_SHSTK_EN | CET_ENDBR_EN;
>		} else {
>			s_cet = CET_SHSTK_EN | CET_ENDBR_EN;
>		}
>
>		if ((u_cet && ctxt->ops->get_msr(ctxt, MSR_IA32_U_CET, &u_cet)) ||
>		    (s_cet && ctxt->ops->get_msr(ctxt, MSR_IA32_S_CET, &s_cet)))
>			return EMULATION_FAILED;
>
>		if ((u_cet | s_cet) & CET_SHSTK_EN && opcode.flags & ShadowStack)
>			  return EMULATION_FAILED;
>
>		if ((u_cet | s_cet) & CET_ENDBR_EN && opcode.flags & IndirBrnTrk)
>			  return EMULATION_FAILED;
>	}
>
>Side topic, has anyone actually tested that this works?  I.e. that attempts to
>emulate CET-affected instructions result in emulation failure?

I haven't. :(

>I'd love to have
>a selftest for this (hint, hint), but presumably writing one is non-trivial due
>to the need to get the selftest compiled with the necessary annotations, setup,
>and whatnot.

Sure. I'll try to write a selftest for this, but I'm unsure about its
complexity. Can you clarify what you mean by "necessary annotations,
setup..."? It seems to me that some simple assembly code, like
test_em_rdmsr(), should work.

For now, I plan to do a quick test by tweaking KUT's cet.c to force
emulation of CET-affected instructions.

