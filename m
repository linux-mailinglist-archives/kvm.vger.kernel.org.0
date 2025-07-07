Return-Path: <kvm+bounces-51631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 72F57AFA923
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 03:39:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3C534168C7F
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 01:39:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A4D3246775;
	Mon,  7 Jul 2025 01:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OL5DxU1B"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4FC22FE02;
	Mon,  7 Jul 2025 01:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751851976; cv=fail; b=oi4gYlVj52EEbfdqPwqbomC+cZy0TzRjV+OHQ1j4vSrvsszvdpoGuUbcI7gYTq08/vuWd408zv7ICy+bv1AAmYpYIKr2nZjoATl0/UGL2MzcvRSrPPLLEU5G/41YKTE6ASEeWZ2D2vs4C8XP/oPE8qCr+Ks2qrftc/vumQVdcY4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751851976; c=relaxed/simple;
	bh=9uF0UCyE4ziswKp6hq+f6yhZVWDxW8AOGt9zInrlSkA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OjRdvm7nVwOks3m9dKQFNBaCzyGsDnf6kSJ2k3oC1MaWXxTbTXECp2iWRvijB6yEyoFwZQ32PZUGmB2RFIV9ujxvDS88LC3E8IPrjvbU77rq5aTGRnzeZ2pDwUDYzal26TRjO791x8sQrbkcbDUEUzwOdSiTusqJuTtYeuLphwU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OL5DxU1B; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751851975; x=1783387975;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=9uF0UCyE4ziswKp6hq+f6yhZVWDxW8AOGt9zInrlSkA=;
  b=OL5DxU1BQdl+0ufA/S9QggScHZYZrvIfpyDkhEc1hHnu69ODsMmT5Y2J
   hkS3g1ZdtkuZVWItZSNXBDHqb8aNyqJIkN1NO1xYUSKFoQQ0OJ+f51HED
   Wq2ocP7dOflKuwWetQqewC8kK+xmku1w52Yb/rU8suJylxHKuef0i+8D5
   NYlRzuoNx4QhT1Vourzghg0cH0cJXSljd8D8FzvccMWEEHA6LZbgTG/iT
   ta7q0qrsk7XO0Igx7wbZ5/8zETnMHydybzY+6G3O3J/dqIbhNgizCJRv6
   1n1rhJTIYHIAG3qtwdEdh0CWsMhJLTIB6GXViEwmQWmKuybjlzhETyDPK
   g==;
X-CSE-ConnectionGUID: 9OiySyrXRBujrynywAt0bQ==
X-CSE-MsgGUID: qhB1+UtlTF2ENKDaoScneQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11486"; a="41692127"
X-IronPort-AV: E=Sophos;i="6.16,293,1744095600"; 
   d="scan'208";a="41692127"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2025 18:32:54 -0700
X-CSE-ConnectionGUID: 6nR0QP5USUu74KQM2rTVNQ==
X-CSE-MsgGUID: 8orKc+R0TYuJxLAuMWU+sw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,293,1744095600"; 
   d="scan'208";a="155184374"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2025 18:32:53 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 6 Jul 2025 18:32:52 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Sun, 6 Jul 2025 18:32:52 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.63) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 6 Jul 2025 18:32:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y80rQTpNPmGwZi312NlfeIBfmxpg7aPOsNTDHrzTJryPjvWdsgY3OmoKg5cUWUT+GigJKrlLS9GYONELFuAw1Waii8yehfG1WILMBrouipDK+cLyv4P/MsbvqxwJ5+DcimilVAJUVTXTfXs59UUAaFbr6PMpGRfKHeFOQmwc5dKgEYCVQ+paPrLJTnN4FERdnBWmfhq3lbHVxxsjyJxeEm6tSMr0d0X2eVTzszyzydcVl3iZT6hDixx34hklaMV2k8SXztE1IL/0slPAZeptsR2MRA0AtixmGA34M7KEGLnv6urhsGREo7X8bIEB8vLbMgeoaohUEFpc9q/IY3qDDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AlkSJCfikUxa5BqwV0VWSU1ad0f/GPTQFeL7K3V0i3Y=;
 b=R9jyW1IVxe268IfgSDseD7feP+TBQU15oKIgnePxLvQtFCBYm/44fNpwT6dkqkmPz88RH6VMjLUew8zp8RVQ7kPZOD9gQ6FKQfY5eHaAAMKLViHqDUR8jwX+KoJjTP3St1u3+TkXZD7MkunciAa2sFF46h4vE4gIomqvaB/vPEaVhG21Pvpu8LHhp6y+xsEvlOmc13cn47syPBNizZ0fQkwTcrGzYnVibwmu1+wZXW4Xm+aebYs6GL3BxJgUnTgWNvO4GRkaRczuAp+lY/U9w2JEOw8Ty1kr//a/GgJweGmcFCtj9BSY9elFS1geGFcJk9ewluBl948ExZ8OlkNplg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH7PR11MB5981.namprd11.prod.outlook.com (2603:10b6:510:1e0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.21; Mon, 7 Jul
 2025 01:32:49 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8835.025; Mon, 7 Jul 2025
 01:32:49 +0000
Date: Mon, 7 Jul 2025 09:32:37 +0800
From: Chao Gao <chao.gao@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>, <john.allen@amd.com>,
	<weijiang.yang@intel.com>, <minipli@grsecurity.net>, <xin@zytor.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>
Subject: Re: [PATCH v11 00/23] Enable CET Virtualization
Message-ID: <aGsjtapc5igIjng+@intel.com>
References: <20250704085027.182163-1-chao.gao@intel.com>
 <88443d81-78ac-45ad-b359-b328b9db5829@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <88443d81-78ac-45ad-b359-b328b9db5829@intel.com>
X-ClientProxiedBy: SG2PR02CA0009.apcprd02.prod.outlook.com
 (2603:1096:3:17::21) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH7PR11MB5981:EE_
X-MS-Office365-Filtering-Correlation-Id: 4954f6f9-01bc-4d32-78b5-08ddbcf62ef8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ed/bDKOqa5dtO63yMUDTOTCMkwSPVIXvZE3kEjAxeE0kYoMc+fBBdpRx322m?=
 =?us-ascii?Q?Fy8E0z3Fp38kvUCz1lpQbtlcjlcYsAhkwE7MlKAwK5PV7WjPU9wZ/llgJ1Ft?=
 =?us-ascii?Q?Sq0YznEBmqBGloeKOoEDLE8MwcaLVluRAWm3VghMxV5ZuZYi2sn++p4t18Au?=
 =?us-ascii?Q?pBqqF3xCCb6qpi8zCOZBkcHXJZD60fq+qJaTH3sfOOXqr64CgvHQNomN87Y2?=
 =?us-ascii?Q?UAc4Ud9t4RAq5q8TltanjoSBbTb3cQ5BZZ6aANgdviglazrf0M89q2sn23Yq?=
 =?us-ascii?Q?PBWLLGHolhlN9ngSMv7PrF2jTw8BFkUBu2fT388prXqmgn8aQIR7zQmysVL6?=
 =?us-ascii?Q?EklQ+8xV6lat5KnuVknjpDxT5cejZoKbavrogZ7YEM+XCMJExjHaQj/5+5NI?=
 =?us-ascii?Q?tq67OA1+4MLsrEnEkgKqYBxn3YkMOTahrm+poecHt/f9OposST3Dpel70SSt?=
 =?us-ascii?Q?2691IhUHLLdeYp0pgRXuI/b9MpJV4bdPnpaCAE+b65lrP+/cGalbdJ7h0SgI?=
 =?us-ascii?Q?wd/3GMrGA3KhfcXVWYT1pEXtzMu5OlBnpbb2E9Yf/u6KdxxMsiqcbWAXphEd?=
 =?us-ascii?Q?2ouEBUs8/dmzcUHhJVmklT0sDqHg9UShWZE11HQ38SAhxHVPfczmAP/ZhLmV?=
 =?us-ascii?Q?+D3teEhFBtmYW1M81QaIwOYmN5pvIS5HJ63cW5RC1uuuHR+BRu5pCNESh9xD?=
 =?us-ascii?Q?oPHcNgb3zFvSGcXWZyMBLAR9Sj2/pAtIMCskhJ1SD0x0KRlXVe7TJuAEEO8P?=
 =?us-ascii?Q?vv6J6ofk9/qgjYNDkrby5vKDtz4VTxC7+k7t99nMTsilgHIJ8r38oaqY9vIl?=
 =?us-ascii?Q?7vjAs9yYJ34MVr700NqK+oriY/SaucWShT9mT0gXio288WneYWAjn/410tQC?=
 =?us-ascii?Q?WE+Qdwt7v5MfktFUJleHEjHUev4A4Yvu37adA1oy+tc+MjLU2cbVci7vr82i?=
 =?us-ascii?Q?I3G7bOcdSqGIT6uVetQAY/sFs0AfVlnClpDKaxikW1Rq1g7wSCL39dyBIqqe?=
 =?us-ascii?Q?KAUht1EI5w0UInhopJceEwIPT7/9PMf9Ogo4XdZuDAXdqu12czCDSBORBwra?=
 =?us-ascii?Q?cM9pUR30bW1/eykqPCh6xdGF8YamxZSB9NKcr/vkfcJZiWgiPGyyWmKFtCJn?=
 =?us-ascii?Q?63ERAF0LlFYkSK0NEzpCciT9U6mCM5l5Fjx9YcD4DC9rMRIiK/TsFeFHbte7?=
 =?us-ascii?Q?IBjV3ntb7iqpJCUk0fx6nx1fq6lT7ui54by7q1tNstCTJ2f4nJgf4HxKOhq3?=
 =?us-ascii?Q?yyE3ORTIsfcfl9/TyNDzhO2OfkUfb/LGg9NermvEyoRRHZiVxgK6ELM45tgj?=
 =?us-ascii?Q?3DHcvejerVywIu/OJlV0wVivt/8gUaz40Gsk66VCB5lGikb/95TyXrjeRrWp?=
 =?us-ascii?Q?FnPNUxrHY87OJCD2DybtpsNwEiWd4rWS7dXEMJ8IYfgVQ84/Nq9C2MF0XmJO?=
 =?us-ascii?Q?O6HDGn+FjgE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OX812Y+be19v2LVp3DPFDlBEdDVJt0Y7K2JkNshBzJUrr5URe0NImvSXKCdo?=
 =?us-ascii?Q?WdWXgGZVHgr6p9ZVmP49l+45Xa4bOPw5R6OGnZC96uPNsSZu4vxJGGH5XR5V?=
 =?us-ascii?Q?+HugMpkNUMUfTq68QlMHTxjfKJ8JI/IvU8WxZjZvSf2HDTnZ3srkmclVPslG?=
 =?us-ascii?Q?1ErgE3Jsxw0gq4TwT8TUF7CxM2e3r1fUZpIpGCteyNVF3gJHbMKk/BW0qtaB?=
 =?us-ascii?Q?3GIUqJPtjmJ3IEqjB6/fSx9y2Qr04k1CEUPLrrCriq+yerSaeL/t29fUEu79?=
 =?us-ascii?Q?+OEonV/rMt1bCBkqzUblXZN1BWJAcdFYNNkJDipQrhLSWg9wjuCGVgTvSzwK?=
 =?us-ascii?Q?LrciQXIggMZX8o2rbfoXB8kG8BUDPeMeUlVq5yfKXX9ot6eUlhv5SdmqZ8Ut?=
 =?us-ascii?Q?DfMFOhRm2dvvCPmQ2n1EK8eSRR8tl76KTIZILLUM6Q3/XSdjERQqdLql9oD3?=
 =?us-ascii?Q?Hwnt0Frzz6J+pVZ28N1l71gR2n0pf7t2V1GErG981IyOxS24uH4WLTZrlkOC?=
 =?us-ascii?Q?P3H97Z6MYqbTz7A8E9B7uWJqOTMo7CwPE05gpw2IME1+oi3BTY2BEKCNxyK2?=
 =?us-ascii?Q?4ZXxiy/McmqgnhbCEp2TJaysGNKaDzQ5b0JVG8TikOR2GThPZFKSaCOEhEnA?=
 =?us-ascii?Q?cMzG5/xj/gdsQb2T832hB2VFkl6tpJrsuIV7ZOygoxAaIzf/r9iI8V+C6LBH?=
 =?us-ascii?Q?68+QdsZv6w+P/38/wPK+29bzu9yKvCAGwaWVrNWRU7tni3eA+XpImxRQHa5T?=
 =?us-ascii?Q?NesmiQ93yH3bKK5Xh3SkLnEAqHA7iw+XPj+fEp8ZbHe6piKlL4ZIUtoN/SRA?=
 =?us-ascii?Q?nFHC8V6+J7raCHTyrTWsarpB4xNr3kjex8g3xzZf2DKrRR7MepBxMjYC3Bg1?=
 =?us-ascii?Q?9peybUjHPOGXjME9bSAeRCKWX93oyoBdZXf9YrZ/JmCDR7BvGbfqxTLvWFLc?=
 =?us-ascii?Q?CyMibHS4FFtFP7mmJroRbJ8V6qwQ8ikHhEfKsG816uDEwnqPg+Y7kqXyofNo?=
 =?us-ascii?Q?Rx5vTDlz2dcjPCKDBFWy0BSMvkIwj2jHhEmDNA8N5LWW17xrw+Mrw+5tEHeg?=
 =?us-ascii?Q?VcmcyfzoxEg4Z/kJbqxyvva1ezzKK6mf6A21RHmmD7bSkqFJPas18sLp0DBg?=
 =?us-ascii?Q?ZXXwubCTZbqpM9mMYWrZd1Z/SJjCHWpksm671Vmh1md74CZ/zogOLqmRInHE?=
 =?us-ascii?Q?3A1rIY1xclluQN4jfGpPOvCdvq6jtrL0RUlUBsQq/AQVLgY6/s7NTqkTlE7J?=
 =?us-ascii?Q?7hhUhva3u5pz4C5J9YqseiTZjaSqlzeRye1NR4nWUlsI0jAf2GaUCWgMB+ly?=
 =?us-ascii?Q?3wuQLW1Ku5m7cLssW9In2KJG14ThzEMTw5WbISUqauS2uqNKd/raR++9qTTL?=
 =?us-ascii?Q?0Jpr1pJDHUaMQ5rzSYOb4Oct6Tj+b+UQcrvnD2864ROXlLvYhu+3slc06wPT?=
 =?us-ascii?Q?REZhn7qaWZjgH0jLVNdwo+273r1LR3vvVm7XCMhnDfhpGOUkYd8xMlsEnPKo?=
 =?us-ascii?Q?v/IfzkEir1SxYwrTYO1Vl+oB5JS5V8WkumKbhLfvmTRBKuCap2a0K4pQMFET?=
 =?us-ascii?Q?Y9JcDiN2xyDdNYiW/V+iemapF4R8eAfNGfpb9rww?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4954f6f9-01bc-4d32-78b5-08ddbcf62ef8
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2025 01:32:49.6847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mjVm6nJwLdg6UnBqorzbIo0DvzTGPr9fc40tEIplgrDVZMTd0Zu2vCGq/+bz2pqR9hq2jXfr6A1LzBWmtiqvag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5981
X-OriginatorOrg: intel.com

On Mon, Jul 07, 2025 at 12:51:14AM +0800, Xiaoyao Li wrote:
>Hi Chao,
>
>On 7/4/2025 4:49 PM, Chao Gao wrote:
>> Tests:
>> ======================
>> This series passed basic CET user shadow stack test and kernel IBT test in L1
>> and L2 guest.
>> The patch series_has_ impact to existing vmx test cases in KVM-unit-tests,the
>> failures have been fixed here[1].
>> One new selftest app[2] is introduced for testing CET MSRs accessibilities.
>> 
>> Note, this series hasn't been tested on AMD platform yet.
>> 
>> To run user SHSTK test and kernel IBT test in guest, an CET capable platform
>> is required, e.g., Sapphire Rapids server, and follow below steps to build
>> the binaries:
>> 
>> 1. Host kernel: Apply this series to mainline kernel (>= v6.6) and build.
>> 
>> 2. Guest kernel: Pull kernel (>= v6.6), opt-in CONFIG_X86_KERNEL_IBT
>> and CONFIG_X86_USER_SHADOW_STACK options. Build with CET enabled gcc versions
>> (>= 8.5.0).
>> 
>> 3. Apply CET QEMU patches[3] before build mainline QEMU.
>
>You forgot to provide the links of [1][2][3].

Oops, thanks for catching this.

Here are the links:

[1]: KVM-unit-tests fixup:
https://lore.kernel.org/all/20230913235006.74172-1-weijiang.yang@intel.com/
[2]: Selftest for CET MSRs:
https://lore.kernel.org/all/20230914064201.85605-1-weijiang.yang@intel.com/
[3]: QEMU patch:
https://lore.kernel.org/all/20230720111445.99509-1-weijiang.yang@intel.com/

Please note that [1] has already been merged. And [3] is an older version of
CET for QEMU; I plan to post a new version for QEMU after the KVM series is
merged.

