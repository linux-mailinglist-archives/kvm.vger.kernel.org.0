Return-Path: <kvm+bounces-66898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 51E83CEB317
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 04:33:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E801C300B36A
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 03:33:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1137227B352;
	Wed, 31 Dec 2025 03:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PAUIZgFi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E4A27B343;
	Wed, 31 Dec 2025 03:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767152020; cv=fail; b=AiGnKsNpTwyWM+H3Z3FyzEkHlwsUjTv/LT29xdNBF99GVLFJ6jLm9nRlM2vVGWVNU6s1XFfw6pQAn1YTLAsKKEqsD+h8IkrLuxUu618XNoxDuA+Iih2FU+/SqoM7AZGfrnE+MUEK+6a5el6fmuKndT0s31RMJNxeH3IaMCB/nBY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767152020; c=relaxed/simple;
	bh=8zRTLCnrnAh0zxJhRF5fowzFLL5d+ZW0ov6ApQLYQwI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=V893AOPeKJcPZTE9facJvJ6dCKVibCh0fbRdcRjgMG4AtOun/P+bdgYMtTQTfIwlV30BUu5k94llvUawryqPAErC4Rkyoq4Rgq5BrRsXXHnAJinwsrVAIk1BDneQQoKntLv8XFG753Mtwszw2s8MBd1xhy5ZsxTfCyjGfg6vfjE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PAUIZgFi; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767152018; x=1798688018;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=8zRTLCnrnAh0zxJhRF5fowzFLL5d+ZW0ov6ApQLYQwI=;
  b=PAUIZgFiMHMxGen0GGTSmdmpcuqojuXIvQNjelHtobI7kYYPdXYC007t
   Gk6jeSXzA4YYJu1n2YcOjum/FyDLSxJW/OihIz1bHqO3w4aBaK8/u9L1i
   W+HRSuo0jYo/Uhkm6oyPKYlFomVRWPqXRpawo6R8KA+OIe0NVxrZphFYa
   eftDsueP+PNwyvmBjie+kWOu56DDQLa9lMm1IBUuJU/neWtV7r+XrPcU+
   S7JRIDNXCVseLBwd6FdOPM9FhMQeKgb+0a3hjthcuCj3fCOwZE+vHXw21
   2iKzEPM3O5GXlcOUNctTE2of344cCxF3GHduiIRW9nNC7nVcgHN/52d1f
   A==;
X-CSE-ConnectionGUID: Cer9tkdgQTCY4SwO1gY8Qg==
X-CSE-MsgGUID: AIME1N//TVWRiP/t2/BaJw==
X-IronPort-AV: E=McAfee;i="6800,10657,11657"; a="72584708"
X-IronPort-AV: E=Sophos;i="6.21,190,1763452800"; 
   d="scan'208";a="72584708"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Dec 2025 19:33:38 -0800
X-CSE-ConnectionGUID: 88nUt/AeTlOSfR1lUW9sPw==
X-CSE-MsgGUID: rd7gyefXSGOcOILbOyyzcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,190,1763452800"; 
   d="scan'208";a="232037493"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Dec 2025 19:33:38 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 30 Dec 2025 19:33:37 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 30 Dec 2025 19:33:37 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.37) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 30 Dec 2025 19:33:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aY12FbYpeLXBdgPKXOj8nE3ZiH199lo4meEnZnNg/JTEU+k8iK+ngFBzT3bovO6TY5zqIQsEVHfSjonuYk/kL5NlKyttPOuQImybiykWqhevAQ5nCYsjRmbV/4CWPjy6ciyx+7c9sgJUbw/x+09Hcg+1tiRQHt+S5WJUac0OM+ibMXd+qaDySWVz498giomY8xGsWXMF/zF6EPh+grvqnXV2ufDSjWq/1lW7QBv0JtUdv2GMvAUi6ulOBpxeWdVRNHl6d//OeYc0LjnZyk8rgGx3VulttYAehRHub9E6J7IelIaSluW3YiSr6bKiJlVKxT7UYjPe4Roq2lKQMMO2hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=47+GN7fr6ZGrmu1/zJ4C80z7i2o16Shtn+AvqqHSjy4=;
 b=l7fVhBF3sA+/yUmnKAMT60pZZyPQyu7eKmcDQQRf5x7++fxPpsoKAVbSDTAioRfhGwyBKGkJXlcc7p/T7aJImnQEXc7mM8KDmm1ahUif15W21h/6Lht5V8MT9f66DY1ZTQpx8fTnNPAyvGlaTzTu87AIZg6Hnst1onDcn5GXKXxzP7yqbv9aiYgyTMKIJyqkamVq/x+EqUIrU3LkgQDS3rvVkydF5dNe5RC4cRpvFEAhwCSbbiyH5yZbYMPQfq+gv53PJHSsBa0p/NJ/v83j9bsw1UfMl4LgJo3HeZ4IISHTnhE5EGLm7F/Yc2TUBvs5ShcDhttNOTjI3fUCmDq1Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA3PR11MB8023.namprd11.prod.outlook.com (2603:10b6:806:2ff::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.14; Wed, 31 Dec
 2025 03:33:35 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9478.004; Wed, 31 Dec 2025
 03:33:35 +0000
Date: Wed, 31 Dec 2025 11:33:26 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Xin Li <xin@zytor.com>, Yosry Ahmed
	<yosry.ahmed@linux.dev>
Subject: Re: [PATCH v2 1/2] KVM: nVMX: Disallow access to vmcs12 fields that
 aren't supported by "hardware"
Message-ID: <aVSZhhl3GEjj15Kk@intel.com>
References: <20251230220220.4122282-1-seanjc@google.com>
 <20251230220220.4122282-2-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251230220220.4122282-2-seanjc@google.com>
X-ClientProxiedBy: SI2PR02CA0053.apcprd02.prod.outlook.com
 (2603:1096:4:196::16) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA3PR11MB8023:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a408093-29ff-4b6f-3ea1-08de481d60f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?h3PLh/mpatEcykPhRxR/IkV4VcqpaYMNUdrv2alerCfWq7cgh/ZqSr4eh/t2?=
 =?us-ascii?Q?lSXxocG5Kt5TZIfE5McIsTAGcpsnJMsyV6osvVUsE+0ZIPGRFKNHsjhouQDR?=
 =?us-ascii?Q?k9WxwRMoool1aDWsXsl0hiGin9k1J7RiHKcOm3nEz+CXhIxhX8TGKFoMh+K6?=
 =?us-ascii?Q?Bl/sQM0PGh4NVCZknx4REgtrUfmefPaCfO516zLog+XrpmP0KpjYwFp1eb2C?=
 =?us-ascii?Q?d+GbcjxcFXoPJE9J3r6yUHscenolHmUMlYvOlEy/i+sNlRKw40sbXiY+zNu0?=
 =?us-ascii?Q?ICVtpMXgPt7cZrNg1/NHmrq+G9Xb8MXQWo+cplXnKVRcQfN+8wMuE1fecYw4?=
 =?us-ascii?Q?YnoUQ6fUzH9djyX4xN8rW1HLtex29t1VfaNbQ+0GqsNv7L4WHSSAVzRBeewG?=
 =?us-ascii?Q?fbKydiZ+LBCKfo6+e6SjaiX6dRlGmGltoWhPqHG9lblBCPwojiwcKk7dzqGv?=
 =?us-ascii?Q?Il1xJVcn/MBFQfJ4nAOORMQaUdZOFdfwxCILxicoprZZSRPBiD8yCvvNc1rY?=
 =?us-ascii?Q?zX3i9qQM6qPRXGQm6RHfIlaL1A4kHKrT0/IpmMi0QURYE7jUmC9lq5ifo4GV?=
 =?us-ascii?Q?unElzibYb8q17W+kZY7kus150wEd5DLGGGS1FPs2YCJItfElmxx/jVllYLY1?=
 =?us-ascii?Q?4enBx3Tht+6EPrdLZrf9nyZr7DRfXCvX9Lu+x3VC/IWCYGkaRbTCulnUUx4W?=
 =?us-ascii?Q?jz7igbXEjjad9nCNr+IJZ3ndIRAtqdfFsSMpOHWfl0X0MSxU0VxGr2IGIE20?=
 =?us-ascii?Q?sDvobJGUEihLqHhAOb2jY2dwhYFjOGeAexlC8G5D0pa3/1mQ5/ezcVieN+ti?=
 =?us-ascii?Q?G7/usS/dNIdTlZevz9tScmqjmKa5Rpt+ZVB8oF07zkia8Lrgw38Z+tcllEz0?=
 =?us-ascii?Q?94/8V6qEDgYMoqeiDl7H55EUSLGROz9M8PkB64SRbKsGvQXtHbL36bNdAgqY?=
 =?us-ascii?Q?kBv6qlNdwC88R0TQtfTC1ns/Ra20MsPP4FUWDd0Hiz+Astq/NjvOneOaPn86?=
 =?us-ascii?Q?UvVJAJF+xhcG72xiR9kaZV1tRiKJdmrYMvvu75FaytG2uoxw4jAD0/PREGrC?=
 =?us-ascii?Q?4eGzHcUa532ZdJ4CVWUjzP50JYH5dyHjcwwdVNHPZNfmQYP2oNf4lQ8Mp5SJ?=
 =?us-ascii?Q?lNaPGqtKsJNRrKu5GlrsgyxJAK1Tkm8BRfXrEuv/qS1gHDasY1S34/coQPPa?=
 =?us-ascii?Q?FQUAXhdBrwjsajcZOJT/LefBAP1aBviAhsA+cyAeLjEkpQaCNdAHKntD1Utd?=
 =?us-ascii?Q?HVUf9tR3ma+aRV+5eoot9Dv29JkDPzEc3fC5P7MRchjS9vYi4gvCijGB0qsO?=
 =?us-ascii?Q?nkODYtIdE387GFLklJ99vXqJ1Lf9mTJi2JAl0nffFnzw5U4HQ9kiwVU3M/++?=
 =?us-ascii?Q?QFAJRJ6jtUBx+J99KyvxQ/uIdgHXhk0u1hMBO34iWRlRhYkGSBw1Weqb5xVU?=
 =?us-ascii?Q?+u/FC04Y7+mHKdtcAyoW6SfoqPCgRsbvmiOjGKGxN9B+E1tTjXS9Yw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kktZ+BMszFk6K1AEh1+4j0ljGnLC/mPIwhhDU7PRUNh98b+S6UfrPBbEa7JR?=
 =?us-ascii?Q?fPprPI+OfoOSCy8y0odrEYkDMW3YPxc7V/ygrYYjWSOrtzj7clqxwvtGV51F?=
 =?us-ascii?Q?dSJf8wUw6shyO8CJ1pdJuSN06/hWALR8k8Uw0x6Id5xsO5afehKaOe9EN/pH?=
 =?us-ascii?Q?grHM0zWAyZOPa/C/cxApfMWzoEWJacWgCZacRHegr/yA4vjtldjlwzszO6OK?=
 =?us-ascii?Q?t/l7ilc1BWmHfy2h0ZzEozP8Y1S23V62MG2Y0bcevy2bUJI2s3XGvZwgjLWv?=
 =?us-ascii?Q?8190JbNhd7pk/Sl49kq4WkFLL+2X6zJ1OllYIQjYDP1+Pdty+Vhsnq5s64ff?=
 =?us-ascii?Q?CH7/2X1L+hlOnwwNCowdaGSKs0aNYJaA2syfoBD0/oAHMmNRQSj0lSjm8YHd?=
 =?us-ascii?Q?fbeOYnoNKht3RtSqRpiH66JYUQfLBOGz2i1vclmKSqlcoTuId9Z7QDEyzmjm?=
 =?us-ascii?Q?HPLzOpx0FrTnXALJLwobl2XueDbLrYZc1gvUagGDpqHXCo4HvHJoaqofqzjY?=
 =?us-ascii?Q?P5Pgzs4kSTbuf7ndISSIhAA6T36mAIlqBxEJTULttnr2sltPth4ycOkQC9r9?=
 =?us-ascii?Q?UUE6uyChYkeiAUEnfDoL2lqbHA1dmDrBxNtG8gR8ugZKlcBzX56stcpFDxnT?=
 =?us-ascii?Q?Ocr6nqShUUcAgeVHr4RmJUF1D3Ste9TfPh2pNfciLvRQ8wlsChA92gjLQ1PC?=
 =?us-ascii?Q?wiw0MNit5CTPk1liAwMdoFwenFA4ZccwJIf7JZo0HDS3eLdMgQsiNyVkOS6l?=
 =?us-ascii?Q?tkB7SIO0nIcmnPWcv32BhdDea9EDCaFcvxsvIrg5l+8R2dzF+fEMuk0ZwYFb?=
 =?us-ascii?Q?xBg9JGmaMZ+s/FC/jGxgOgH6apkRflqzW/cX40V8E1kZUgKaUb3HVuknm6no?=
 =?us-ascii?Q?R81cfbENuDFOhpS/j323z76NCJn7Ns4Be8rmfUSULJw8GjQiGIIGJwfe8RUd?=
 =?us-ascii?Q?kZrLdJnS71FJ4XiXv1HwL1ss0WepEFT5fwBiE9imO/zgp8+NXc+JX+X1lAOG?=
 =?us-ascii?Q?S4SodTcHoAu1+UTB981AeY+/jAFVaMJHL9AN31UIMHgIvnq2PG7zt8HLmBHq?=
 =?us-ascii?Q?EiupxzLa+86bzCUH4z5786oB8gecybd3RJHF+MySGhbY/1kLCYB0RKo+cuhg?=
 =?us-ascii?Q?5J8ZwdZWCPQCtFUQ6ndzjjNqqaI8lGM61xG1EiDZezY8mm9dcT4x4tIacJLk?=
 =?us-ascii?Q?YKOmBi2fc2bjbhop07Zq/XM77z5kD3MByR87IkMk6p8ijxYCvXRisbG7UQsk?=
 =?us-ascii?Q?VIqsEoLYtnWdjWZlp8Tqk1fMa4PE9D1C4RzpzhFe4iv3euxjOMt1h5fstP63?=
 =?us-ascii?Q?PS7GD2ClnMVpRWTqz+BSnr2JOlbVMQDaN8EnXtKbcPA2i2lMRLsaB+myN1i8?=
 =?us-ascii?Q?0T166Ob1nQ/H2Ed/BWxC4FqiXlhybPWn3FgYdYx1MscUmLrVTBMEzvBpE6vu?=
 =?us-ascii?Q?kvHPZDY8JgynhPMpvvfXLHmzZfQ2cyMf6HV3uiNqpcPnWt41IH2n3LBqMmDn?=
 =?us-ascii?Q?QpwpzzUv6vvVzjsOb20Z0RVAVPDyg+NdgA0FSAMw7MdVn2KvaAy3V6i7MINd?=
 =?us-ascii?Q?1ROcDWfUPh+XA9YbRh1RvHu5fjVUcVrcKq1UTgiAK271BJz8kfhXuLzh9ibn?=
 =?us-ascii?Q?vJ4nJtmqgpYKBHiYsJw8IIOdYbYRWS/qtNUOFYXkvG9VEQ5rIpjr0YV+7Mmw?=
 =?us-ascii?Q?8STZFVLzEZ/5JTI2SfJStBF14Nz3c2RjaCUE15Ne2sjgnDQvXgMU1FStbmBG?=
 =?us-ascii?Q?7oZkMVDCZg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a408093-29ff-4b6f-3ea1-08de481d60f2
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2025 03:33:35.1790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wKTnymYmkeclnXlmhM29td0jeIPyfM1bRaHMx+ukKSLnxvuBP3AR7UCJfET0hahj2lB/qEG67v1S/ODWPkE8nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8023
X-OriginatorOrg: intel.com

On Tue, Dec 30, 2025 at 02:02:19PM -0800, Sean Christopherson wrote:
>Disallow access (VMREAD/VMWRITE) to fields that the loaded incarnation of
>KVM doesn't support, e.g. due to lack of hardware support, as a middle
>ground between allowing access to any vmcs12 field defined by KVM (current
>behavior) and gating access based on the userspace-defined vCPU model (the
>most correct, but costly, implementation).
>
>Disallowing access to unsupported fields helps a tiny bit in terms of
>closing the virtualization hole (see below), but the main motivation is to
>avoid having to weed out unsupported fields when synchronizing between
>vmcs12 and a shadow VMCS.  Because shadow VMCS accesses are done via
>VMREAD and VMWRITE, KVM _must_ filter out unsupported fields (or eat
>VMREAD/VMWRITE failures), and filtering out just shadow VMCS fields is
>about the same amount of effort, and arguably much more confusing.
>
>As a bonus, this also fixes a KVM-Unit-Test failure bug when running on
>_hardware_ without support for TSC Scaling, which fails with the same
>signature as the bug fixed by commit ba1f82456ba8 ("KVM: nVMX: Dynamically
>compute max VMCS index for vmcs12"):
>
>  FAIL: VMX_VMCS_ENUM.MAX_INDEX expected: 19, actual: 17
>
>Dynamically computing the max VMCS index only resolved the issue where KVM
>was hardcoding max index, but for CPUs with TSC Scaling, that was "good
>enough".
>
>Cc: Xin Li <xin@zytor.com>
>Cc: Chao Gao <chao.gao@intel.com>
>Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
>Link: https://lore.kernel.org/all/20251026201911.505204-22-xin@zytor.com
>Link: https://lore.kernel.org/all/YR2Tf9WPNEzrE7Xg@google.com
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

