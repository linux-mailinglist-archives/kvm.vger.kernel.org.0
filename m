Return-Path: <kvm+bounces-56000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 24AADB39029
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 02:38:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D385D3A58AF
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 00:38:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5FF818C034;
	Thu, 28 Aug 2025 00:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pfa3Iy+a"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC6F79F5;
	Thu, 28 Aug 2025 00:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756341525; cv=fail; b=qLPEzYvi2TkG7PBLIf8ZtQ+60afeYDWjeGlJfUiCaXz86JUlqo9m0+OavNSYc6B+2vMLCbdsRSmgWMZMhrT7UsUp0Pj2WARX19m4zG9QxhdvqhE+b5+EexhG7rI6Jqhk0qtqGpa7r6udWJqM3K3kpA1O/b1aCP+1D+hfRpI17Lc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756341525; c=relaxed/simple;
	bh=s+BOWXqCK3BWNdSVMv46heGFwH2/OVHFoPiqVxS+YOw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qZkS8ZglYVI7+9uwGWjSdnZ2DsECmvMI9UydKgPgPUfYpSYkmT3BugqdJaro38JV0J7jCYAsudoKneqUyhf37R+TbZOSS2C6LWKM7vD2MbHU8EiKm3sjb/EF+U7I+iglc5OezQXySNfv5uG9QeMRPU5/oah24cyIAAzt81AJNIM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pfa3Iy+a; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756341523; x=1787877523;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=s+BOWXqCK3BWNdSVMv46heGFwH2/OVHFoPiqVxS+YOw=;
  b=Pfa3Iy+ays3AoV0DMTiJE11R83UH7PGpuuiwT+6FZqYYtNZkVvf2a77E
   vvc80kqVjtxoQh8a2ZEv/YUqGMhjtErC1KN2o8EJukzcDUIutwUDESeVm
   Q9oYEnceFbVKZgIjLiAFAi1OVj8uT2s/nq9Y7lLOoeSwUruh98K0/427x
   sYl5bC5oeawvJQbk6xjRJ3wwJ8iBSrzMS5aMvLKvV0VlBkLG3k+Ep/eEJ
   fuFyEQb0+es7P5XI/Y/eRUAZAG3r2ShAp2AGp5fITvjoHPsVbzgfkxIpV
   DYNTUjymHscEH++I/L0suy4gvafEEip3/yPlv6SWX3Ihf8bMhumc4kLPx
   A==;
X-CSE-ConnectionGUID: oGrcvRNcSd+k6EDv1Itk2A==
X-CSE-MsgGUID: Robvx4S3ThGsMwtASKhFXA==
X-IronPort-AV: E=McAfee;i="6800,10657,11535"; a="68875656"
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="68875656"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 17:38:43 -0700
X-CSE-ConnectionGUID: Xc9gu9F2QdW6Ll+6dNED+g==
X-CSE-MsgGUID: YU/JJCFETDyfcG/FNPD9NQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="170139653"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 17:38:43 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 17:38:42 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 27 Aug 2025 17:38:42 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.60) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 17:38:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T9mgu0HSQZ0kFN9Y7sksbensKa5/rhrVj9ihDrZp9zFSpd1c0UOPCAccyA0V+oV3SlTB0DWsVKqih1I5CFrf5wcnRsZuVmkTfyd+hIftRMxSz+6Z1EWMr3hLFK9bq3bqSkBpahEQbl/owS4WiwiMMoVgt4XNH6iiHyHqANbCtcXOU+0f+Ivxn23LGOZRntJVDyS9KZ1bs9lKbfJILvFds1EWjN0qg8RphyTHTgvDpLEYs7unrfw5OEAXMQy/XaG1lfc79OtXvV4T0Ll+zV0BxsKZs20XCyZZo7QzX53aVxXRJ1eH2JfDW0it3p+11FlC58riWRBulymjiSNfL5wKUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O9USzk0eRL0cjfl3kW25aZkz9AnmyJA7fUth509QPTA=;
 b=B7y1WRLJXCs+dooSsG3C6Egv1pdvvBwV3fe8H+wQYVFZvlYvW+cBpwAGBmUiQY9ldD+1zlFe8wPi7ihCLiLQxp0r0GhJNMdMTKagtZs9KdgXrF6df5QF2HY+l2aSNObCyEQKvQ+GV21Y2rcNP2v0UZb4qsxG1q3Pr9RthSAphK+uNwlzf9a7bcLbYc54aO0fNHAZZYnRJFjhwqT8D4jOUQnFRS9kLFqwJBn3JA2/Oct6xCSM/K4HVai4BjOOF49byaD6qafaEjs+kTkHNdjmU0MbRGwOEmvKVqpbl1/Ni4gqiC0collQxH6y8X6Zpto1Gk0z5wZ5hwKlatBk3aUIXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by BL1PR11MB6028.namprd11.prod.outlook.com
 (2603:10b6:208:393::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.15; Thu, 28 Aug
 2025 00:38:38 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa%7]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 00:38:38 +0000
Date: Wed, 27 Aug 2025 19:40:25 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Michael Roth
	<michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, Ira Weiny
	<ira.weiny@intel.com>, Vishal Annapurve <vannapurve@google.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>
Subject: Re: [RFC PATCH 02/12] KVM: x86/mmu: Add dedicated API to map
 guest_memfd pfn into TDP MMU
Message-ID: <68afa57959dd8_315529471@iweiny-mobl.notmuch>
References: <20250827000522.4022426-1-seanjc@google.com>
 <20250827000522.4022426-3-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250827000522.4022426-3-seanjc@google.com>
X-ClientProxiedBy: MW4PR04CA0043.namprd04.prod.outlook.com
 (2603:10b6:303:6a::18) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|BL1PR11MB6028:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b80242a-db99-474d-233c-08dde5cb3ac6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?249WI89tcjquPdr9znDZ4NGQ2uR3CggkRU6yPlJ8z2RB4UA3C48GiMI3zpcM?=
 =?us-ascii?Q?IfSj5rWeNLflYJ9n6eX+V3hwJHI71bdgh4bni0HAoBOYrQKbwtAMXrXeIG6o?=
 =?us-ascii?Q?3q3p9KFikLwSOt/vz3Qqw1JC+YXmQn70nTNLDyOx0t/o7uTZJ6Sv2yQWJK1P?=
 =?us-ascii?Q?MZ3NzAHKUO8/SSdibwavQBnOpgJ3GNIUeNCQoMv/uzphwjqSVjllPmtd626O?=
 =?us-ascii?Q?5jpH/x9b3vtzOl4GRedSkkA2m3cqACr8UYVcmtK8AlXkxqidf+FoLpprsj8e?=
 =?us-ascii?Q?6kW1tzURaQIynpjC35MWlq1zTZuzs75mHwQJNrkwr4hkUq+e/bla7jC5inpG?=
 =?us-ascii?Q?OGzx6e8BxrCvnaxSMEeWY8DExaIroAW8xmci58NraAWe38KHVNAzEJ9msjz0?=
 =?us-ascii?Q?ZGVn0J+ZcgdV70ym3yE8P3fCis/SWmEKAATwKCUxknOlJ89INfHCKYusNKL8?=
 =?us-ascii?Q?kN7tAAV2PYm6XSjL3OPXVki1/CYSh6qFXWGB/djYxuYbfgfz7l1F2/JzhwlG?=
 =?us-ascii?Q?Z4xnmp3Swq1+yZml+oJIbIWgsk5nHcne7DP2ttrIgoeIruVDjhZVnXThu0Uc?=
 =?us-ascii?Q?tm0zRfdVAuQXWyAOw/6+VnUj0k0nKvEGhp84Qxbdprgu9R6zMsRbJe7C1nxc?=
 =?us-ascii?Q?HpG5EkRLmkUiUMaxt6E7Z3CJfudeQ2n7ikiKITBW7qVQDXrk6NdwMjEi/zYf?=
 =?us-ascii?Q?jq9mQVQYSbiBdzCI9LYkWh3aUtZy7KOoyVrBSxbp5l1CofDqf58RJhGkHwNZ?=
 =?us-ascii?Q?0AgGCkKTyRNR+5avNb3w49OTEsvSbSrMRcv3XwzgoiDdYI0ejCkD8p0K9v1c?=
 =?us-ascii?Q?vZ5dOjpcz8XI5P1m4jK9jwC/Z9e70t8FiB8Z5Pq6Sgw5cu8yrUQvFk48CqSs?=
 =?us-ascii?Q?ON+DxUSpFk59Etrreo2e0EP23FnfqCRQzXwBKfkrZfjkLhui9QYL5g6LVMQ8?=
 =?us-ascii?Q?jY+fLR+QE7bgmcY4J08LIxbXGXgSnJ35sJz44r31oxVrnR5udqCousSzJezd?=
 =?us-ascii?Q?p6ybAC+XGBJ1OuI8woDbqrfwYp8JOzpXgA08c3+v0BPwXrCrwCoJUd56aLrD?=
 =?us-ascii?Q?l0Q25sv2UkqNdHavg2yQkbYAmBHbPl8udwSu+fTeVn7MRLY3IkVshS3WrVhQ?=
 =?us-ascii?Q?2Ka5Sqs0RJpJxryjk/wTNy0Z3GbQNmzmyw0DydbPbGMYxSqq8w1wi+q0egzk?=
 =?us-ascii?Q?BclzEc63FEgLZ99OCapasAcU8cM0v/cAJWNfjdWXhL4vLVfRF4kiejW2rqvs?=
 =?us-ascii?Q?OSvPPVv6uW6aOmi1BIv+hcAQDaWgO5iwEPC7QtiJ6eWMtCye0j/8jUnp/REX?=
 =?us-ascii?Q?+0e/ybnqKqTjLkszIpL3ggDDPa8Ad0e8Lu8v2BZVB7W9m8kkh3Rykc+PjkNY?=
 =?us-ascii?Q?3smhm+sOgCklRT2pHnrl1yrjwyxm7EWKF3NGCJj46z5mvJ94zA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2cNOfgTojts0op1rwn5ZjsV/osPosOInr6/ZC+sKEYAftz1FHc0KtFREkXNH?=
 =?us-ascii?Q?dJ9hs3TRI3Qxy/72f8ZscJN3pMnnEUNwMxwasSVum8N5yYNsumD0YPUiGEpE?=
 =?us-ascii?Q?MuG1Iq/QDMtsKaxFykjydXnA9XsHCEO1rzYwJEXQbBS84HIE9d42ujjW/2c8?=
 =?us-ascii?Q?dvb4WCxpSe6nFs/306jerVgX8wrFTmq7dG+VGgLg8ehDRPItoo41tide07HD?=
 =?us-ascii?Q?fOo3SI+EQOiNTdCzZUDMIiLvtxof31bQ/cFrshkuFwYLVdccU77GnetvMkLd?=
 =?us-ascii?Q?oBWYlyzj193bj3559yOM5YupJfZBwnIuFq1+QtOHRGmjG9CgtG0qhQV7WhHP?=
 =?us-ascii?Q?6w+PC2L19+OGPeOtUjoWTo4LzblU0E1+asnEdwOvcszOj0J1yGWI0OaQi20h?=
 =?us-ascii?Q?oSPMBKiHkMvmtV1FTlbk6V08QfyzKrhCJCDfRUxGwS3sWBjVpA+KtE7F1+By?=
 =?us-ascii?Q?Pwg3x13S6n/F00MCafzpSh62YHZGtQHSbdh4yRMFCc1mAWHK26594ceGvJ3N?=
 =?us-ascii?Q?P3y0o2dEXh6hjZ6tMfDc536e8iarngjj3aKvS4eJm+RDntmhGZQ8sa9mmUfk?=
 =?us-ascii?Q?omCHVmXCYEN9uLx6Ckz4OwTQfzfvtv/8Mz8ycq/vrU97+WQErLekR73M7r1R?=
 =?us-ascii?Q?6jnwjA7CO7EDknnyWxFQqNjyfqCWvXcm1d4fhqsrtDjCZvapQa4YiOFM71Uh?=
 =?us-ascii?Q?0rVfCaAACRRWf/Iipif9QWbTEkf/rjZ8y9JBxu/porTWaiYfYdcrMa/nhFzV?=
 =?us-ascii?Q?XkutmXiUdysQ+T97+E8Z45LUDBjO9maJLsSepARtUOGV5L8F9aYA59YVJISP?=
 =?us-ascii?Q?/3Yu8sXOVsS//9+bJ9z+9D8e6eOsWOHMnNMXdlUR5XbUcRpA1NBxnwUHo89H?=
 =?us-ascii?Q?Xxta6Mr77hW7iUfbwV+Hz0F+m9MH4snt5Zpie4mt12v6fXAfWrrbUzbygTI4?=
 =?us-ascii?Q?E1yoWAGbmu/OT16VFPaGoAIK5AVTCFqLwmU+trWy5W8HPaaZUYG6XZ17103W?=
 =?us-ascii?Q?EhCJeTTVBs70RFMeILSdX01DXux9Qs5zEbylweJEG7LVbloUU1CeLDcjRgEC?=
 =?us-ascii?Q?+UCsQEiYlLlPENghh5I8TBQF6jlutcGWh+/kxpyXPi3Evjo//D8mMNI8WCkI?=
 =?us-ascii?Q?aPsv7Wr0kZcqyWso4MQcyQ7S8gS2RKZpXji9FWCvErTcQK/i4UsF1tprexGf?=
 =?us-ascii?Q?M4d+8STJP9VwHS4ufPUMi701SxILunKAQ0IFbBO+hygVcTDU+tRferH18q+p?=
 =?us-ascii?Q?CgX9Z1Qf/+fTeULcWrJiVwgZNYRV+Wf/f5pmHsFZSVWdKnc8KGiZ6FkX07dF?=
 =?us-ascii?Q?+ZapElLbDW/WNJKeQWU94Fi5Ne83T2cg+KG8bzxrrSkjRlS84PF0tzpbK1xi?=
 =?us-ascii?Q?a1U7AMJyktk9In6AT9b40o7RsY85srcK0qZ6kit61LW8UUZyFCQeEYVUfSO9?=
 =?us-ascii?Q?OVCLHGF5ofliEOhdNhqAC9D1IhCTwsEy+TEZlYhHM2BZK8ayb8FkGCS8aKNc?=
 =?us-ascii?Q?7asNjkgyQhGpCLBwlFNjZ7Jk+vg3PJ1XPMDgIsjTpihqeOjhU7Lvsub/a1iX?=
 =?us-ascii?Q?jcY9rNcH+d/ctgMnhG5zDxSMPxulqIzf94VIcb7X?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b80242a-db99-474d-233c-08dde5cb3ac6
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 00:38:38.5036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3bxZhteENqbrCdWfeID7vndiE3Gn50+U6xYFmEgVzPsV18158/yTAiKozjsyzYyceAulGfp5tl7hprnl6xIvQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6028
X-OriginatorOrg: intel.com

Sean Christopherson wrote:

[snip]

> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6e838cb6c9e1..d3625e00baf9 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4990,6 +4990,65 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>  	return min(range->size, end - range->gpa);
>  }
>  
> +int kvm_tdp_mmu_map_private_pfn(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
> +{
> +	struct kvm_page_fault fault = {
> +		.addr = gfn_to_gpa(gfn),
> +		.error_code = PFERR_GUEST_FINAL_MASK | PFERR_PRIVATE_ACCESS,
> +		.prefetch = true,
> +		.is_tdp = true,
> +		.nx_huge_page_workaround_enabled = is_nx_huge_page_enabled(vcpu->kvm),
> +
> +		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
> +		.req_level = PG_LEVEL_4K,
> +		.goal_level = PG_LEVEL_4K,
> +		.is_private = true,
> +
> +		.gfn = gfn,
> +		.slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn),
> +		.pfn = pfn,
> +		.map_writable = true,

Why is map_writable set?  Doesn't this get translated into host_writable?

Ira

[snip]

