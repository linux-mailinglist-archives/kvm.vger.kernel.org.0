Return-Path: <kvm+bounces-40474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 78C14A577D2
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 04:15:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A1C041768C0
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 03:15:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 158F21531E1;
	Sat,  8 Mar 2025 03:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="moHLR+Ag"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5057DA82;
	Sat,  8 Mar 2025 03:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741403697; cv=fail; b=PBcqJrOksJueLMXIBU2dvfhNjAgvZOxbZ7HATtdY5tz0idcy0JpICUtnjdLGXCAhqnq0cskHXuNPL4Bc4DW0hZXdHXSiPngm4dZCXVAVgvHpDcDEF+a/OMafcX9l0Um2NDcDw6Wsx627LvYh89I6Rxevg7gQpjPhHNLOxmZhu3Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741403697; c=relaxed/simple;
	bh=zbhQnAlexIF3lmGRUq8g44iIJ93QhVJKH3OYk2YWKPs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Fl3w42BVbLQa7VZN1tyxoAA5TFJDlJ7OGdVcRVce0m66VoFxDDKDfQ8afZskGvMP1W1pjyYGVd8CXWyP24i1DL0NktjlkNbrYutXh/+BAnyAbyO9r7v//afCxugMD9Qcew1I1kZKsfQDceMJzajJpLYvH+zPSM1NcY9ZaVDi0eY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=moHLR+Ag; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741403695; x=1772939695;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=zbhQnAlexIF3lmGRUq8g44iIJ93QhVJKH3OYk2YWKPs=;
  b=moHLR+AgP8ZFxo+fqazGYf+oLnPIXIPlY/6zVk4wBvSw2fMKsKrYOGbY
   plwaIWc5T2mkuyvlDiq5phGKejM2Sq9gPTkL+yufBE1z9Cb5Wo/J3GzD/
   +d3ep1Net8jrfILfPLeUrFvX1ijuAYum7y7UtD34ehT5Oar/Kd+rr/T7B
   O6oaIDhX9vQ/bB1sqhtNXQA3jvL2vB+KzdNk7eqSCfPXYo3IocHjEeqy9
   x1w1r9OvOf24+1PHmqKoO7ulIo+JylRJCePyKS3cPzcxq538LqLpKLPJL
   OJwDeA1Z/ooFVy4gWHIuRQS3TDbGNKbrBSJTg2aX5wFq+txW187vejlrB
   A==;
X-CSE-ConnectionGUID: Kxe05miqQluF1HAKIYXSDA==
X-CSE-MsgGUID: HbH0XB/qRLum3W1Jo1ZpQQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11366"; a="30040556"
X-IronPort-AV: E=Sophos;i="6.14,231,1736841600"; 
   d="scan'208";a="30040556"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 19:14:54 -0800
X-CSE-ConnectionGUID: SD8/QYMrQ86Zd8rm2FXrkQ==
X-CSE-MsgGUID: FCnU7CJlQjGKbhpLmfkCRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="120009735"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Mar 2025 19:14:54 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Fri, 7 Mar 2025 19:14:53 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 7 Mar 2025 19:14:53 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 7 Mar 2025 19:14:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h1/D0WUwvtANMjmwPMEnmDhVE23eHHInGBW0i2FR5mBVDAgkMfxS9n1vqHwfy2AoJ/z14HEsKfzfTbs4PQ8VJ1nEX1QEazxtY4NOmrO5EOQDHmXGAdBmuic/dZNXq8QMzj55Q7qDYAxSzqvAtY35knJ7YB6ny2cMfI6DvbNOdfU0+KnjkoIpUwa1hbagBSSRC9SrHpkNKcpAkQheW9BcNggZetEsL9Bu5AXl4d8Psnjql5WF/s67hFtXn8YDeir+FMDPqWG88ctzBx+q89Qgob/VmRyly8z/JtMtwRptePhH3/czBHC17VWnpBu5aZ2qCMp/+kARzMQSBK8taXXPlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YJ0lTEOU+wiKJOkc8q6Db4SODe54ZVuQDXnzWCvX8ko=;
 b=AbW+FjSOQuHdI6PFl5zvNxnZLnTN7dP6r2jCDNmxR/3NeQb7xQGoKsWJVSPtQdWjozzDH0ysRgrEQ1hmePACsdCqQvwLj08oQqdk6zs7j2TEfYFvS1k0Tz9H8MTa5R+Qn6ZpkcTa8aDHN41vjhtcaX4sSSQfa+d8s0GvuOtNpjmeK817ipdynehjeFGOoMGJupQiWzywxBDkQZxK1NLAEjXLmmnwAfSGAgCG+39g4P5pwXwFarTW1O9MeG+cleuUXyUtZ2Z7hQXowIScmF/JdJ2m27l0evKRng/Od3exv019f29k1mgE23m2heW9vW/OEoROnb7FNMnq6CdxQFwukQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CYYPR11MB8385.namprd11.prod.outlook.com (2603:10b6:930:c1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.24; Sat, 8 Mar
 2025 03:14:35 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8511.017; Sat, 8 Mar 2025
 03:14:35 +0000
Date: Sat, 8 Mar 2025 11:14:25 +0800
From: Chao Gao <chao.gao@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: <tglx@linutronix.de>, <x86@kernel.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>
Subject: Re: [PATCH v3 06/10] x86/fpu/xstate: Initialize guest perm with
 fpu_guest_cfg
Message-ID: <Z8u2EWAkqQ+6O5i3@intel.com>
References: <20250307164123.1613414-1-chao.gao@intel.com>
 <20250307164123.1613414-7-chao.gao@intel.com>
 <63044dfe-7f44-4a3d-9a27-82c036232241@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <63044dfe-7f44-4a3d-9a27-82c036232241@intel.com>
X-ClientProxiedBy: SG2PR04CA0201.apcprd04.prod.outlook.com
 (2603:1096:4:187::23) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CYYPR11MB8385:EE_
X-MS-Office365-Filtering-Correlation-Id: 42641706-3b67-4e0f-daaa-08dd5def5a5f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?9cfhfVbMUDLN8U8lnevkddQNRnbseYx0nWykJCoSYV45A6M+fbsdskBj9W7P?=
 =?us-ascii?Q?wBSehW0s13fHNqqKwhwjLldv0PT2JUzms6ptcdt3MQETI2F61LSTD3QBywA3?=
 =?us-ascii?Q?oHW0W7sjc9Ygk/aRe9Qi9aiCaTUL9pA8ZWtOCEB3bnRT3Gw7B/FBmMwk0gsM?=
 =?us-ascii?Q?t52G4DLflfouW5C/s7gPJInE1JT2kcD9ii12w/khZauvzszTNe7te9atuT5f?=
 =?us-ascii?Q?uwQgzcIaEtW/Vvun+UCuRUHyqEUiPCllAIjC0wdlTE8rQNgwehBLyFkXoDap?=
 =?us-ascii?Q?P+ItLNlgqLbLc8eoQuh42OeWmci58fFDGGVc8Szzxg/T0zanYCXA0BPy3HH/?=
 =?us-ascii?Q?dPa8OksfIX3rNbLcn5uVE2zEM1miMEcBTwhoKsPvf2lt454gEmJOppYgBWlw?=
 =?us-ascii?Q?ZeA64xVbDUHGXU4ci/tr2eSPgujmo56V/1zOBAvQM+g3hJpeS3ancjHz7oC7?=
 =?us-ascii?Q?RUtQuImVCqsL0ifMB7t/HN987RWPUdZ7YRe02kxX2G3+ZNd8jQzMfGw+CqzZ?=
 =?us-ascii?Q?RyoGR8weNbR6VKG6i56y4FPP2HytYO5puIBKyzDkQ88ah306Y7i5TX3kNCQG?=
 =?us-ascii?Q?7RlyqwAUtR2YpKsyqLI9Y+Fwn4i7D+Pp0RXd5Ox0/IlocM4Rs7QfO1dCReGz?=
 =?us-ascii?Q?6WHTg43JwiKBh2DQmfEfmP+gHeMbqPyYxIdWM3lVt+s+kVcpg2Rw2RGp86fv?=
 =?us-ascii?Q?IbEaS4JvsAkGYGcRhwT+gknGofikgUmdPg8w4O++8J3HKtvllC+I9c7P9NZ2?=
 =?us-ascii?Q?v9UKLGIATeFzErp19M9op2JbCnOaOQ6BdzsrzmubWsrDUj33//s8MNjQjadp?=
 =?us-ascii?Q?/13YqYXsywxXKIF8hGo2tSx2vS5QbefzkjGPXKXkHqc35LxaLafFl+KWZ0nG?=
 =?us-ascii?Q?d7hT0aXeT0CVzPF1+nhwl0T+lkHAygpqKsEmR5KtTPobmMKBus4lYRlrZWKA?=
 =?us-ascii?Q?GRFXsOwm6z67XRxXx3irY6rmG21COHnpzRfp47YtOEdYAddJlBCKlK5XjOSQ?=
 =?us-ascii?Q?wU6ZTRvIg+SloQEP50QurNoVo9RdXTCZKLWLROMs8D4IB6CF54r78WWrL7ty?=
 =?us-ascii?Q?s84HlV5dLVnITVomHAAzKqzbj7boUCsI48AROK/2t438eTIa6NTzU981lKZO?=
 =?us-ascii?Q?Lzyz5eH7ZAp/WZFJFe+sutSXBDn8XQBFxF6YFzjZ3Lsr9CgfTD3oaMa2e/Ve?=
 =?us-ascii?Q?W2SDhmH6ma9weZ6nwv22gdAV2xKxXW0/9faHR6RoAzRWIgDXteClqoSS8f9U?=
 =?us-ascii?Q?9A5DV7Kxmg0gAdZFkj+N2zezJt/VMH11876g+hQPUnH7C42cBJSmxX3DvfVc?=
 =?us-ascii?Q?XbaggU4KWimbvGs1FMbezioHIEGT/K92ts9DTQLb3CLakABo7gnTzHRRy69l?=
 =?us-ascii?Q?L2BbsZPkqI9bnqh/0thuYLR66CuK?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hu+vqVI1NQGYH3Veet6wK/+LgibFuFONvXzDtjtLzTftKWz4Eq7cfbLvYfSQ?=
 =?us-ascii?Q?wN7+K+2jIqRaapQhIhg/WZjju9huQ86fas6mPBNxo5658F6yX6KV2ruObyoG?=
 =?us-ascii?Q?8Pw4UpYBKYRh0scsPVbhY5e0W7x+gKpFJNZILSljrE0k1LN7Mb4iFcZhg+Qw?=
 =?us-ascii?Q?jVkDfekpQ7RJwldNSVt0asn0ek2Pe91z1sl+u2J8QPWjAgPeQZZPwZDJ1g/9?=
 =?us-ascii?Q?yJgDFWC1msjmI4if0iFrz6tfmI46pKNY3C3dgODvqluTgUfGc/Enykgy5g8K?=
 =?us-ascii?Q?e8C2cxFtLcNpVY2Us3kA0mSeQaha5VMfqg4kQRtGJq8O+C7F0rM/ppgiOCHC?=
 =?us-ascii?Q?pnwmxmKcE2ptebwdf8E5mwGWpiKdzSR3QcADefRvGBGaIm1HUEeaZFMlh9cd?=
 =?us-ascii?Q?wtANvAKuOe/CBYpz0ntCMhtPKXBT5s+NqI5/PM2Uwn4L621/fN3fsmpmhfzj?=
 =?us-ascii?Q?w6sUegU5La2TWfAa2eqGR3jSVmClfB62C2JrZUdPLD5f+yp3ToLI41WWlRmM?=
 =?us-ascii?Q?i9/QGOjimFWUGuQZ9a3iHeoANXqKf4uGX6peTHo5oB/rXewMGpKHNxeC0lry?=
 =?us-ascii?Q?iYWHSmr4BC33mZHhlPcNwCKq4u/jRl3QF/+0KF3qHmAUzGmt3bgiiDg8pdPg?=
 =?us-ascii?Q?VelfKaL4yBZzOdFRPOA9YZ3Qj44qcwUKu2ee1eePi06ECUy3mHX4Ft2gNFqS?=
 =?us-ascii?Q?9731EtF3xg4NfIldKIFkEZ+U0u4/OTRbIYivMLbOZcJEBC6AIiNNhu9jgnsc?=
 =?us-ascii?Q?16244VkpiPtGOLgXBTLrdMjcYi1ymRK2hfq1NQbaSnvWb2ZUzka9LPLEVOqe?=
 =?us-ascii?Q?cGPmndq/rrycK+TzGbtQy/iYw2rm1jTXxqYHKUpQJUMwJVdB39UE64elJpXW?=
 =?us-ascii?Q?ppq894ybedA35cxvCbij4n9RlgfnLhBhPnctg2oS/XPfXqLaL1m8cVv7zLyu?=
 =?us-ascii?Q?xj4DohmkmfBMlgtmcRF0tRWglEBaL3VUyUqPYDtAYVYe5fTCu/66R9//ega5?=
 =?us-ascii?Q?6HV7yoZLMdv1VOnsK8TOjOTLbrGhOZ2Lor1VxT3rPjx8VcmSbWkQjryX2OQW?=
 =?us-ascii?Q?lhE1oxpL3iYoWXaHUc/lpU7GU3BENnkbGQxlcnvebSKqVrBg7Vd3VbLtq8Y6?=
 =?us-ascii?Q?HVLUR9GD7we3wPzCNwsVCsxMwZQVrsUj8AMIDErE+FNCcxI4Xc1wkL86v3tz?=
 =?us-ascii?Q?WyQKB98UkfDc6WSrcVFpLFlZkEMRv+NaUz3TR9YpNyWbu0BM4hUt8efFIH3/?=
 =?us-ascii?Q?IFMXhHJOckFSzKqpc9okqpxzNWRZ1/3W3pLQ8WBqu/I06PmaxB+vIt/5offu?=
 =?us-ascii?Q?bLEcssaH9wmtql0n7DmVhQ3mxMeswIZYZJfX1SqwqYhMVhRphhjjKsPExAHm?=
 =?us-ascii?Q?RgYSFCK6g2oZ07xX64Af6MfV0HO2RCB12mZAZNCipEwPHN1lr6fqrXE+zcyf?=
 =?us-ascii?Q?Olcbm+zSG+oxFJodb11VoWi7Uhj8aXiHHuGtnd62Mdb9Ngc1NMubamn/iNU/?=
 =?us-ascii?Q?JsToWwT+lqStvkwvUIPPFLigRE3RxfVkv4cSuTSrYu3tEh/p6vACSFCR3jLo?=
 =?us-ascii?Q?QC2JtbOV/UNj3nZpllRsDM3kvgCxTmD5mRyLCA/o?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 42641706-3b67-4e0f-daaa-08dd5def5a5f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2025 03:14:35.4827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BFAajMg0D+zUl5fTNZdU9oUBHIDYLZxfkc32MmIFNuOSPPo69PpFNRSNhTsMm+1AGTI3gkJJpF3MTFPiXfjULA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8385
X-OriginatorOrg: intel.com

On Fri, Mar 07, 2025 at 10:14:19AM -0800, Dave Hansen wrote:
>On 3/7/25 08:41, Chao Gao wrote:
>> From: Yang Weijiang <weijiang.yang@intel.com>
>> 
>> Use the new fpu_guest_cfg to initialize guest permissions.
>
>Background, please.
>
>What are the guest permissions currently set to? Why does it need to change?

Ok. Will add:

Currently, fpu->guest_perm is copied from fpu->perm, which is derived from
fpu_kernel_cfg. To separate the guest FPU from the kernel FPU, switch to use
the new fpu_guest_cfg to initialize guest permissions. This ensures that any
future changes to fpu_guest_cfg will automatically update the guest permissions

The __user_state_size is tied to existing uAPIs, so it remains unchanged.

>
>> Note fpu_guest_cfg and fpu_kernel_cfg remain the same for now. So there
>> is no functional change.
>> 
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> [Gao Chao: Extrace this from the previous patch ]
>> Signed-off-by: Chao Gao <chao.gao@intel.com>
>> ---
>>  arch/x86/kernel/fpu/core.c | 11 +++++++++--
>>  1 file changed, 9 insertions(+), 2 deletions(-)
>> 
>> diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
>> index b0c1ef40d105..d7ae684adbad 100644
>> --- a/arch/x86/kernel/fpu/core.c
>> +++ b/arch/x86/kernel/fpu/core.c
>> @@ -534,8 +534,15 @@ void fpstate_reset(struct fpu *fpu)
>>  	fpu->perm.__state_perm		= fpu_kernel_cfg.default_features;
>>  	fpu->perm.__state_size		= fpu_kernel_cfg.default_size;
>>  	fpu->perm.__user_state_size	= fpu_user_cfg.default_size;
>> -	/* Same defaults for guests */
>> -	fpu->guest_perm = fpu->perm;
>> +
>> +	/* Guest permission settings */
>> +	fpu->guest_perm.__state_perm	= fpu_guest_cfg.default_features;
>> +	fpu->guest_perm.__state_size	= fpu_guest_cfg.default_size;
>> +	/*
>> +	 * Set guest's __user_state_size to fpu_user_cfg.default_size so that
>> +	 * existing uAPIs can still work.
>> +	 */
>
>I suspect that readers here will understand that this line:
>
>> +	fpu->guest_perm.__user_state_size = fpu_user_cfg.default_size;
>>  }
>
>means "Set guest's __user_state_size to fpu_user_cfg.default_size". The
>comment basically just literally restates what the code does. That part
>of the comment doesn't add value.

Will drop this useless comment.

