Return-Path: <kvm+bounces-37813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 21C3DA303DD
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 07:50:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E3F71888CCB
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 06:51:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBA491E9B21;
	Tue, 11 Feb 2025 06:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jk876Sjx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62419190674;
	Tue, 11 Feb 2025 06:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739256649; cv=fail; b=PRY4sDY888UhfQ6BWbVV40aWtsWf+/iDU/yXDjgjSopHjnH4yPMRAofNZ9I2DgFEYYiVIfRvBSFbkXaroboJcq1DyAu/jEC85I/JlpXkl45qdFDfO4Dudi9dYRHZ/klsSkBNJqrwmCcDjncWPcSXIDMKrlG22i8ScO1jbCRdPT4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739256649; c=relaxed/simple;
	bh=1IesRZYt5kIy4RyOlFMg4pGFbbMlBb9jU7dVwK0u3to=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JywM5JQKeKosMVvIpruf2xo6XL5V7gl6H8KFaTpeVkBuB/c7pwOJdiISx4MKWGLp5XRlrsTuN3hrwCfa1VLC1vs9Ch0vUdO9lrEs5f1dO3qUY5Z9f06LdqfEjkOaTf0M/FkeskAPeouaf6h/S+XoGFAGWSJN4lnznEFIWVal4Nk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jk876Sjx; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739256648; x=1770792648;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=1IesRZYt5kIy4RyOlFMg4pGFbbMlBb9jU7dVwK0u3to=;
  b=jk876SjxoD9sePq9pDwaxMc+3cSy/rBqJCvBuulbMO+9TRL4X+Ry9UOS
   W9Q7pgYn5W2lBQkpSDoQU5fUN6vs8Rq5LDQzDNj6ctu2wV22bzE7YuYmE
   nPwiPrwp4vstsEZz/VpNVD46cCSc/LfF38N74dKPLxmxouwaEZ8Y9zcX2
   doEoeS12V1UqavNyJGByoO7PWXVIIMcBpujsaFdedQyFqSQBpHmw5Uj8d
   bIjOecCmMAm31d8ksJ3jui7LWZlo1ML34bOkd1iXL6x19A3sqZWOB7jxa
   jC3lxrzzP16W9y/H8RzJhSnx40CMyTYXm7E8vmhepZPFlE4V5GMWlcEQZ
   A==;
X-CSE-ConnectionGUID: pclpOGisQZimGOQADfouzA==
X-CSE-MsgGUID: rVPFKZXyQOCXW2djO9NwyA==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="39881090"
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="39881090"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 22:50:45 -0800
X-CSE-ConnectionGUID: VgIbtAtyQgemHz1RzqF7UA==
X-CSE-MsgGUID: gvFT8FfHStO8k4Tb/XGpfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="117500115"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Feb 2025 22:50:44 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 10 Feb 2025 22:50:44 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 10 Feb 2025 22:50:44 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 10 Feb 2025 22:50:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aPK5FRKqkwq48rdHQ+N6iNd80a3jtxBi8HqczHNG0kwMI2dz7btG5W3K/8J5hW0q1ZjWE2wQw1PKAegmIY/Qo5Phj9FY1N4L5anqWvwOiUuItWwhU3CzVRYObM6hk+c0JfzbUMREeAYLQdzbkc4SN7yGwyJ8KF8ZHuxTs5B+R3pQ8UUQ2oWxT/0z0DJFputHutyx6hv3PHvRqjnA1mm1gQtynH94eOQ8okFCXo4RHNivKKEo3XAn7UNKiMjduYKTrharN+Ws+znAYRwrvGU66tp8KzJp3P96vc/3WKivnag3N0D4V5AnHBPFVbDrRAMJ5EegYgNoaICzwp70Q34Krg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oOJ7tsNnAMhCxRR+SDWLhynblsalcX39xYg7/48zgYs=;
 b=eVNVTHmnE3IPg3Qkj9gDTDZo4qsEvnbs84ZG60vlTlt9hgBnyzgpG4I/xEHx6WnI7Yq74oYAe8BLJoPjw52d33DDcb+xh2hvjOat1xfQSSyFP0EnmIyJk0lmCLfTTlRVRPblEo1HECOTWqlP21SdK0clMtNw/YnljJFjT2H4pPU7UHudaWEjQ67jv9Pk8fXQQeFS5KYNU9Y+DV3PWVIr4gwJNZ7L51ygfVsVszgjDe/yRu7KzzZ26RwMRBmRZ7uO14CnDLwMnkj4KDgXG+/lLyMeFao5ndYYiIMThxaQ4czUhU1ggH5pgZRo+nBZUzRCNBzNPR7oj4Pq85o7yVgrLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS7PR11MB8805.namprd11.prod.outlook.com (2603:10b6:8:254::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8422.16; Tue, 11 Feb 2025 06:50:01 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8422.015; Tue, 11 Feb 2025
 06:50:01 +0000
Date: Tue, 11 Feb 2025 14:48:53 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <rick.p.edgecombe@intel.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/4] KVM: x86/mmu: Make sure pfn is not changed for
 spurious fault
Message-ID: <Z6ry1SRznsBr0I6G@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250207030640.1585-1-yan.y.zhao@intel.com>
 <20250207030900.1808-1-yan.y.zhao@intel.com>
 <Z6Yhmg2nmUAtp4yn@google.com>
 <Z6bDZWzePT6CAreU@yzhao56-desk.sh.intel.com>
 <Z6p8aukJgpKqg3Rn@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z6p8aukJgpKqg3Rn@google.com>
X-ClientProxiedBy: KL1PR0401CA0026.apcprd04.prod.outlook.com
 (2603:1096:820:e::13) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS7PR11MB8805:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e936726-ce75-4dd3-1197-08dd4a684ec4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?OyzpHzKbykngnPBpZZs4cG1UiECVG3Hs7lmaus7gOVcGQVgYWQh4/J09jPaE?=
 =?us-ascii?Q?Wf7NKn9JTijMpExwIoG4sH3p4xo8ydMFuHnNYFf2hkBijqtafTyir1We5goK?=
 =?us-ascii?Q?A3kEaaql8rKrShmI+aII4pt93Habd0Xuvccjn3+tJgwHf4ct64CDJxyTULx7?=
 =?us-ascii?Q?IrnEwgWa2RPyPV5bBN8SDpS4RBNTE+67hgAcTy3skpVBrvNySjTl1G+SN/gT?=
 =?us-ascii?Q?fQdsXEHb56YnoWKycvMuHgjGHvJM5bP8YB0XQcOrAqriHE3JYc/R/scHIMSS?=
 =?us-ascii?Q?ahLvDSZQZgfaS66pOmlFUWCWgldOAi2C3NVD4CYwC5F3skCgQfD0OUkqb+fI?=
 =?us-ascii?Q?fmGta2NDdiXXoe8K0TC8A4oKWs/S9kfE+yoLePrXxsLnqhEhzs6x1JugrC2g?=
 =?us-ascii?Q?qR8hiK6KFI10rS/NTjMo2hYt9YrpCvmknYi8em6DNZguy0BUkRV1wv6drpEC?=
 =?us-ascii?Q?qVq6zScSeXGF+lKKkASYLb5O7Ao84X5Zk/M9UQjA8kPwenrBHPQPLQ1lvhgm?=
 =?us-ascii?Q?lH283XozzXA1ZLigyPhYGEE/uS1oN+YxcKGmbVaKFEhmAkzol3v0HdPylJ+b?=
 =?us-ascii?Q?EcuF91QhM3ZLm8Y+6RAIoQJ5Q74+rvTUcy8xq+CdtOqzdlRw8yuwQcWp6Wqv?=
 =?us-ascii?Q?M1t6eza8bo2ahVDe+NH+nJXUcf6R7ZB7RlIrHWzXzk0RMdzjZfNSh5/8+AIc?=
 =?us-ascii?Q?TTATEFOhl+15me/D/6FA87t1K0BRnbLHQ+9ZY4XGPa9Es1Ut20vWad4W8auv?=
 =?us-ascii?Q?JIRO4ZnaKX27r6fDo+rG7ioOF0D9Yf8zjrmmmj/r7PzXFDnC1j2bpRHdcfdr?=
 =?us-ascii?Q?bQVFaq2eI2jfF7UFWoKBrcptqf7FmO92jGicAQDv+pcmCNBtKvn/NsHZ/X4N?=
 =?us-ascii?Q?vh5DzpAa/GszUc216TJxxGXq9RUlNx9BTudg98Wq/on8D0McjGX8L+9p+tAt?=
 =?us-ascii?Q?zHx0DNDtYdjeywQayl59Fz0rrLQBiVTmEETRdzefmPwFORFYQ3HJWw5Qnri8?=
 =?us-ascii?Q?AfvNIRQSil+KoR9i9jRADPWCtTmICt6dI4PSU3+17NPWe3zvon6ymu3EB7/b?=
 =?us-ascii?Q?KTCjJFkVbL42WusL0M0CA4RNwWlMDIkIjPbPZMGbsmYBGxsEnuenncKvQfYf?=
 =?us-ascii?Q?FyefFlP+CUVRDS+pqFZSUD8EsAgBC9bRM6NCDkJb0V+crq8xOfjLWw+EQrM+?=
 =?us-ascii?Q?+3LgIEYK2R4+/XcJyrzpO/Hzr2LugfFM4CKbPTqe++fle8nA+nTypBhgGTPs?=
 =?us-ascii?Q?PPPRVoV6CUDhNv+xVFGlZZ0J6Bw163m1T+2lRbTFqNiM6n1WoYaYR5r6uB/7?=
 =?us-ascii?Q?eDq/yfmhy4oxmhmYtMaNjPAZlC7L4H+gkx/yO91gMZGs5vHLXgKlaYTzGU76?=
 =?us-ascii?Q?8tZJEGuuVE2bkaqCxuNLiF+gZ7Yd?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H/TdOsNavKOWYpbmTla/ZaQQdlX7hJ1X7KvfNWFZgwng1n1V6JbBYhYluGnZ?=
 =?us-ascii?Q?4cfyaxDL73Y24k5AcCjxg22myK8VRQQpXXigsVMiZvUnif1CsT9KXKCwfS7/?=
 =?us-ascii?Q?B228/f1gt62Tu+vFSqHAhc+OQngHy1i/zCwz0bczsv7q9UkXLHSwjdiSE5OY?=
 =?us-ascii?Q?XLjbRlZOeT+X80uhJ5wD3gChmXZ97fF2/GqHIXwVMMnAzbpwrbp8xdLpYEh9?=
 =?us-ascii?Q?Gbm/gcrRncbXTEVdVNDJtrb8yWgb8e3bEAlVsMPolqPuEKXTu74GwLjBBxUk?=
 =?us-ascii?Q?lG6yrCJTD/WhKySGF6Lr2o7itqNc4m4YK/tPi1xtY91lDoZB8yF7JiYMnf2N?=
 =?us-ascii?Q?sarlFSfTg33G080Gzf0fhJ31Rdjnedq5I9LQQVFrB1mnnnHP5LsUN2p3Op4v?=
 =?us-ascii?Q?/CHIVvQ097NULf2kvjwgp4ItpTeN6xFKTpFR5Sol90Kt3dodbZBLIuC/wtRC?=
 =?us-ascii?Q?AGAPFBXk4UgSYyFZdGm0PGX6osqpROX9MqqVbFPFbP32YClsCPSLkJNMXtWO?=
 =?us-ascii?Q?tbSwdD6gJHUmBUnyaEEngs9WB0n+IxliET5gpMj5FmsYkM3Qa+SSnICecjGC?=
 =?us-ascii?Q?+jK3140ol1Np1xnlyL4titVgklhfWZ74ubmH/hPLUGCtmIdx5FzwByQIAQHe?=
 =?us-ascii?Q?FFnwc21AmNQFqL33A1jfVwzKOlCFc1c+Yx1DFzbZYFU+txXaaqzWNQct1uid?=
 =?us-ascii?Q?TVN1PqvGryhdVpgG2SYAJ7tLvDju4c3BTTpWqdv52GXLUdztIhqw7V00WDSz?=
 =?us-ascii?Q?kaaxaeLSh+4b6X2Bf1upBkGLCFsy3eoQIZd/NxBrop8waB1NlzE5dKGmD+wZ?=
 =?us-ascii?Q?kCnFsHeiB9xVp+9D69duoNyCEnqvPmA347YkMZzCXqKMgpju513BQA4GVmGu?=
 =?us-ascii?Q?yr1NQDYIDCkaYHMO6bFchFlDgNWEPOP5BxLhJtuKx9YbAn6ZwXeGplg0I5M9?=
 =?us-ascii?Q?MiWVeVgCGZDJNG/JQbQez8P4gKeWyvTZzhswS65fwG8ueFu6ggpf+4ITRxyh?=
 =?us-ascii?Q?yfIN5xFlAv1jw8skO9t0R0vvy1ksg/G98RGIRTGjBmN1zvTUZzfou2zpoAL/?=
 =?us-ascii?Q?34fltQTIqWrrVBcOutMBnWuq7Tmoec4Wjzzaw95kFD84Q5j+vsyPEBbrwfTN?=
 =?us-ascii?Q?xTrCsCbnPfHWzM+FZVmm4nLOxN2NT382sjbx3vrv6XoKYOs199FfjnnE/7t+?=
 =?us-ascii?Q?12Pw3U6nrSnkZwjqNopx0uUz9cvDV15Dqw5smyijySR1LEHF5l7ImYwE7/68?=
 =?us-ascii?Q?UZKFd8j8IDG9DTOBToM2koXOTFl+vNWT8UwZr5YIwDZiSwj4qz6szf0kfWW5?=
 =?us-ascii?Q?PQ4W59Mw8JrOSE+/hvXzKh0bchrg+I96f3jpW+qbZIXYPzx93UssWB5bRvDi?=
 =?us-ascii?Q?w9/w74KmrItQYftnUvHwn3TjfKLYooULn49wA9dGnJ5+f+gTPKUMto/VCZFC?=
 =?us-ascii?Q?6fwWMrFCCzQr9vlDgz4zuGvqUxvDcpvTfSeLEFge5UoG6gCNuWfMtiuDaIah?=
 =?us-ascii?Q?n+qPA4x5hKqRzsQI2ZLe6qaFStaXYk8ROIQXgpLqwR+TfbXZwJfYmKEX2KqQ?=
 =?us-ascii?Q?BLvimyRDmWF4h0Ni0eg8jHR+YA/mZXTx14DLEX8L?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e936726-ce75-4dd3-1197-08dd4a684ec4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2025 06:50:01.6343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HJtEPDAu1Uokq+oJUuULEzks0nNDiNcDDMjLeb+5dFWCn50cwy2+lco7fph50EuZpj0TFwx4ljuXahpMjnuB+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB8805
X-OriginatorOrg: intel.com

On Mon, Feb 10, 2025 at 02:23:38PM -0800, Sean Christopherson wrote:
> On Sat, Feb 08, 2025, Yan Zhao wrote:
> > On Fri, Feb 07, 2025 at 07:07:06AM -0800, Sean Christopherson wrote:
> > > On Fri, Feb 07, 2025, Yan Zhao wrote:
> > > > Make sure pfn is not changed for a spurious fault by warning in the TDP
> > > > MMU. For shadow path, only treat a prefetch fault as spurious when pfn is
> > > > not changed, since the rmap removal and add are required when pfn is
> > > > changed.
> > > 
> > > I like sanity checks, but I don't like special casing "prefetch" faults like this.
> > > KVM should _never_ change the PFN of a shadow-present SPTE.  The TDP MMU already
> > > BUG()s on this, and mmu_spte_update() WARNs on the transition.
> > However, both TDP MMU and mmu_set_spte() return RET_PF_SPURIOUS directly before
> > the BUG() in TDP MMU or mmu_spte_update() could be hit.
> 
> Ah, that's very different than treating a prefetch fault as !spurious though.  I
> would be a-ok with this:
> 
> 	if (is_shadow_present_pte(iter->old_spte) &&
> 	    (fault->prefetch || is_access_allowed(fault, iter->old_spte)) &&
> 	    is_last_spte(iter->old_spte, iter->level)) {
> 		WARN_ON_ONCE(fault->pfn != spte_to_pfn(iter->old_spte));
> 		return RET_PF_SPURIOUS;
> 	}

Thanks!
Will also update the shadow MMU part as below.

	if (is_shadow_present_pte(*sptep)) {
		if (prefetch && is_last_spte(*sptep, level)) {
			WARN_ON_ONCE(pfn != spte_to_pfn(*sptep));
			return RET_PF_SPURIOUS;
		}
	}



