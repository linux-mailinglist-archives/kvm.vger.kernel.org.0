Return-Path: <kvm+bounces-46669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BDC66AB80B3
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 10:31:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 93E8016C5ED
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 08:31:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB7B8296736;
	Thu, 15 May 2025 08:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mnnGeNhk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B28295D87;
	Thu, 15 May 2025 08:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747297699; cv=fail; b=ZYd4Lsb5mkMGvS5b3pGFNagrssePWH/Sijj/kK8ToUSWr+p5p9CssZMMCzOsCJqvikM+hDGyGhvxwH/Y11VZOJDaXR6COyoPmBlmKmqYoiYJ+bGuzIutL8DhHEjbRjCnOd758m92kfP5nLfBTvIciEhI5Bj08xtDXN1bfbiKQNY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747297699; c=relaxed/simple;
	bh=1+sYb4qgD1KHfXj0lrK6/AU0RD8wz1X9T8ML8i3Q3+I=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PiSJvM8fJgfwZtXn1rgfagrHyrNBmUwnFsgC58AZn8tVk0PLBdxufN4R7+yuAMIZAkss7bL6PoUQCeFQgAptObhvnuDtzRjAoyIVGqoy+1IT/e7q/cld36DRBw2AS5H4m66ad5Qn2XyG0FBPxVRmDpirIbPtMR9Wa+FLKXVq9IM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mnnGeNhk; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747297698; x=1778833698;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=1+sYb4qgD1KHfXj0lrK6/AU0RD8wz1X9T8ML8i3Q3+I=;
  b=mnnGeNhkjOW9r6qXGSSj0d474w3vsBz0DsS7KFy1wNczXBwWJKEU00gR
   dclt2uMpde3W6m8/7BT65sg5xC6WHaBdEVqvRBU1i8eGPWWUK5X9+9uac
   3U38m8H6zba8H762GOUDAp8XEDQN1xoSr3fPMcs4QmhYXJc490p7InsF2
   vK9u2UH/KRe8npSsO4o4w85GkQLZR/tCVuM2cKvEdLBMytV6wb6wFBaWx
   TiW3tNJ5YCkRb2Orzy117zrOFS4WAS44oK14TfmA8Uc5MQH9fdfeiMQvb
   NY4zAuCCf78Xw1IhWk2ki5/I+nTZkauCn9RdJWZICa8sipy+hPmQLO8vb
   w==;
X-CSE-ConnectionGUID: 3xN7oghmQbSKspSVoGUAZQ==
X-CSE-MsgGUID: ZisiK9AwTRqueMhr6mzbOg==
X-IronPort-AV: E=McAfee;i="6700,10204,11433"; a="66773212"
X-IronPort-AV: E=Sophos;i="6.15,290,1739865600"; 
   d="scan'208";a="66773212"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 01:28:16 -0700
X-CSE-ConnectionGUID: Zvzqm8ZESpOT/f+oAwIfow==
X-CSE-MsgGUID: qfl8aWUsR72lWbTizHSzjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,290,1739865600"; 
   d="scan'208";a="138033190"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 01:28:16 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 15 May 2025 01:28:15 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 15 May 2025 01:28:15 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 15 May 2025 01:28:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZMRKqEdt/9AWH6PrnRr0YBCedp22KpT6V2p3CD0ALBeGuT8Nhg8gNeF6kjRfI20IKaH7FiCN+OVPli+zpb+9/ErM+XZnE4O8dx8yE5dNaxLsFJWsFLutNnEWcHS9ndvKbPPWDGrMTkbK94bUkZIWYi7owjbMZEC980d9UD8WOU23V3OPm/I8HUI1XQutv5mLmDd4XqDPekJUth6TOGnJV2xSdhzrSfEsdQjUBidnbtDP43wb9rqw7Xa+XPBQQMaYIz7hzCH9mwnPdqqBLx8rUwuiXS9QgfytzzttZZuTE+5JNY6ABZX77x7zXBMD6gtXmq4ufjQxwNwaVSLKrU95pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tGDIS3amU/pJfWJgYAJ8A7WxR4w1TIjgMjAkuAbErsQ=;
 b=ZR3305sLnyMaPBIZr0MDtfX4rZFVO2MQPxfrme/XnPtyGvSBZRscWHgL4QybQS1iMskrHHbqCNRZHB8BIiVqma7GK/ejwDSsjJXOHywkV6WiHhXbMZ1D+agzQTWLhPOPTQ8OFn8gb4icxQWtOZ/hZ/qbQ58ODz5REYn759frBwa7DTYuBy2Dtyw5KePbbAB2n1L6YnUuEl6GqzpKg/l98TwJplTbMqh4UX/Ah1gr2PWlgbzAaCvuNs7y0y3XoSj022yzW3yWMJV7K8CK6D+hIUMGBzErqOT6zP54kDzRmdo1/wxVeGfbNwe4Qjt1E3mzKzXlY0nYUb5eyTljjzt5QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA2PR11MB5114.namprd11.prod.outlook.com (2603:10b6:806:114::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Thu, 15 May
 2025 08:28:11 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8722.031; Thu, 15 May 2025
 08:28:11 +0000
Date: Thu, 15 May 2025 16:26:01 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen,
 Dave" <dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "jroedel@suse.de"
	<jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 03/21] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_page_demote()
Message-ID: <aCWlGSZyjP5s0kA8@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030445.32704-1-yan.y.zhao@intel.com>
 <fd626425a201655589b33dd8998bb3191a8f0e2f.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <fd626425a201655589b33dd8998bb3191a8f0e2f.camel@intel.com>
X-ClientProxiedBy: KU2P306CA0014.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:14::8) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA2PR11MB5114:EE_
X-MS-Office365-Filtering-Correlation-Id: b9b74f9c-5f5c-4698-69b3-08dd938a6de1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?D3JRofnPRJ0KL7sFTxXr4shbTsxgOhjwpLU3seSMNWqCVtI8/PULOc7GSaFK?=
 =?us-ascii?Q?KlIQSO4s6IFr0slMc+pZwmRt1MQGKXjwENtkMB8XoaZ1olRCxVjMgC28XbJM?=
 =?us-ascii?Q?3BThSpNX7TB0emiTGPVWHgioLj3Q36pg/JV2cQbnLkiGPsBFUW+v/iL+tSnU?=
 =?us-ascii?Q?vEWMJrP8XYwaidSSPCiEelvI7K8YnFKLYCG7q/yq/v9dFoMFV3kFJ7tchGyW?=
 =?us-ascii?Q?xvW2AIzwBHK8SD2uqVD+lJlWN5X32GIL6erq+4H1kki2wEgZcH2RaOzFs6st?=
 =?us-ascii?Q?wbS1A86Rf50zv78eHLsnLl4AChgItLXNLBAylupWjHSxte0HF9ozJ8QUdLNr?=
 =?us-ascii?Q?wU+ncjPY1lUEK9AXBve5j8+52Obw0tLPD/tAxgEJH3ou33U16tKoXo1lPbZQ?=
 =?us-ascii?Q?2ddbz40U17zqnZp8yzGUlZOkzlbrvOC97l0MIivvJZSDtfIEFeBtW+vgF34k?=
 =?us-ascii?Q?Tp2rgCq0O2hII7t15cGHbt5HP7lurizBMAv1RxlS5mO/zwRkWbufgyo175em?=
 =?us-ascii?Q?gA0yenZwsxogw4v34fxiQ4gn7XvozC24+y6rHwUunw7gMhPRqi13asayNL09?=
 =?us-ascii?Q?HMErtcMo8LbODqgzPCYVBPU2ZOezj8Nwwg3QbQBJLaHov44F3rg6HoU0b6ji?=
 =?us-ascii?Q?iol8vpry3L9bXRxvs6SiRlKC4EKluOapQ+dmYA3AGrdwFnN2USOjVe5OvIrm?=
 =?us-ascii?Q?/FpYnhwm79YNyrs1aroeEIM3KpGmy8GH4+zVujTUNv/I50DQ5aaQWidPOIru?=
 =?us-ascii?Q?/4OcXeuGjjQqKfKDebjskXG6zQk3hOQSMbJTDt/dl1FKHteYdzZ70JvOLfAo?=
 =?us-ascii?Q?6T/XJOfS94BuRl3KBFNWOxo6ownOcKZxhYsrzi63h85aFisfEjBOrTK4BpjA?=
 =?us-ascii?Q?TnFQkuISauJTaYyXBgiwN2CYuOwOxIRCNcVARQcxzJ+F6xOfXYpKliJS5ukd?=
 =?us-ascii?Q?4ImlxogvjAiF4xqC/0idBKf8Ci91vadTV/qnp9OfE+DkdA7C9ZXak9HjC5Ag?=
 =?us-ascii?Q?dDMuH18HRTdNbABJ8ciZA38BzM8AnsKcnopePToB0oLO1ngZMkMELzh76on6?=
 =?us-ascii?Q?iwWvkeebLUSFhTKUQQCwmWoumYdORw8N9Koyp3fwMjSgpy5JjsjdpYjqABO1?=
 =?us-ascii?Q?imfjmRma4d1uRuh11IJWwL57KrjLN6NXQImWxWLExEkPUUhCUkJtMLXCbhvf?=
 =?us-ascii?Q?7T6mMGaxGnrZp0BaOmJxDXSEAHbIS0NgehV7o6I5A4uuMtLLKuYDnnmyYbfM?=
 =?us-ascii?Q?FUeKnlyeBfBXUE1SB5sX+6/bh0BVuQqKtlPYZSggxB2+PItXWjDCTyo2ZTeD?=
 =?us-ascii?Q?gEzFhz1qMjZcy9Vv5KW2AHUY1AQDujYBfSncn953cCgBZhOJvKm+TKzPvWe9?=
 =?us-ascii?Q?xk1S8sZDyJmoAcfLJFUwpp9QxN6U7SxMUgjzZZR4lzlhn/Qp6ZynkgltTa/H?=
 =?us-ascii?Q?TBcvI/T16dA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g8KJ2/DsVy/tVnr9kRoWviV2UybGyeGDg53Ja4NNyZXadikkmIQ6FcwqSBqh?=
 =?us-ascii?Q?AJbr6algme2k4UfL2tEqSxoKkOtZfAyXhNlDST44581yOu+hsxB+L1mY935x?=
 =?us-ascii?Q?iysqYYR3GPKhsQfJ2v/U7C8lDQIeEbbnsz/PVJ3xxA6sfhyrFDKXZJeQxw/1?=
 =?us-ascii?Q?eneYOFUdLWKP2NUj7QlVGjEQYeT5ovL7taZjXrxioX4uESCu4uYeKLTK1QWN?=
 =?us-ascii?Q?NN3d+274Kx7jyGjypqS0y9oL6wEsjITfYff8HBbgLRpcS/O8lQSgtfBgehpN?=
 =?us-ascii?Q?1twRdB8rONEwsU4bATt/cRyv8u2jz+Pb4waXyMmdP2ky9GajPRx2rRwtjTuz?=
 =?us-ascii?Q?wkPz6hbBnr7e1UOTa4iuhH18l+nV2KnQITQWGfeVpQ0TEk0gCTFVwp7XqMW4?=
 =?us-ascii?Q?O9bFwzQYkJUIs9WvpThSD8lpFllwPwHy/ma+zIwLwaF7vPY6YUmyTbqBh7UR?=
 =?us-ascii?Q?kcYWxECjJkzYNUdLZ/0LafGYM3saQFDEXvGxeTDjQGZnJF6TPg+AdyqI5JHq?=
 =?us-ascii?Q?y0Go6EjroDz/X9LPu4Jpri5T+hoZhfe9DCpa9z2FtBTVIsc6v/yXlCM4bF9t?=
 =?us-ascii?Q?lFIKona6SW00pF30u9kwc3afpgNSFvH6QSCoi5mGTs/Y3s49JWBN6MkLU1xf?=
 =?us-ascii?Q?zXoFASg67kAZvFhE89NeoMV5mDLqUGbte/A6u0cqD0zJGQhscmpc2N+zmmQK?=
 =?us-ascii?Q?YNVwt+s+52GW5s7uZIgXIhYmlMfb3wrFh6yp4ayIUomzHpL20loc6C0/GS1n?=
 =?us-ascii?Q?934vt4mDCWzy2HO4xCqho7cVlLxWrK56NoN3J3dbymktJMoz2mxkfDvbgfBG?=
 =?us-ascii?Q?6mWsa/vKRsJjvlskR14qBWE8OwLod8nvdEBGhpTPsNKAUSe8e+rWdgqyf7Xw?=
 =?us-ascii?Q?LCW7TJ9yg5mgN+ktKPvoM9TY2mI5FsIqWHbjnQ08Q+H59O2TYJ2OCwG7qZc/?=
 =?us-ascii?Q?4VSGKmvkkJQoLVqdKmQNNF9IOpnnOrF4Tj29zD06tgw+gZ4gyR5zSk7lCcyw?=
 =?us-ascii?Q?8uGQzwNTzq/3vkxmoRP0PvqgfOuPwAIrj9KDGdS8LNlG635CuUdvoLHxI39s?=
 =?us-ascii?Q?X07j1guPPz8yOQhp2fFKKRnYvBI5B7hTzGKXRS6KJNB5v/djqJ1QOQjnyXwB?=
 =?us-ascii?Q?4PB8dTvqfpvJqno33injyoypBchfHPgITp/L9RXMIKJxDqsAlrcKr41VjQeq?=
 =?us-ascii?Q?Iec5rRbWnLm/yRuVQY4fWvTYw6r5aQFy+/R5Sn1bRoEwAwoY6tbUuHaXwa9j?=
 =?us-ascii?Q?T+qIVpay6iM2YqNAyZNYTq7XWtA2qRAdKGLp93hoWKVz/gxJprfb4SlsAtve?=
 =?us-ascii?Q?EnDTv+aLGtKEAdWg5GN7YrLOBTgIYUINqbDA66tiF/QahqVaI8uP27JsGruE?=
 =?us-ascii?Q?jzd0o7WJzJvNOtBlro4ariW4H7FDyGIRTrmJ4Itt9HZtDI4IXk0gWNhcEmM0?=
 =?us-ascii?Q?0IZAea9ShBCD++I20gpLdHSlMDJEoPRJ87WdSqmZKBdPqOWCTJx0JlU1siLP?=
 =?us-ascii?Q?9mDzR6IJJ0iyR3xCHFsqgCLuaIODjQR9VcjpvR+5hMZdW/5zUQqD7evbzv+S?=
 =?us-ascii?Q?ELEt7EZ21EbUu9ZL+usGK7+rEXOKK6DFQqAicx5B?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b9b74f9c-5f5c-4698-69b3-08dd938a6de1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2025 08:28:11.6428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hr65CBh1p1EWx1p3LYDUcRrjT9BubbGXGBD/M7aK3ZlgbBgvJXpWqSkWCorWL2uFWr9ARxvMSTnp4T4vIbaGbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5114
X-OriginatorOrg: intel.com

On Wed, May 14, 2025 at 02:19:56AM +0800, Edgecombe, Rick P wrote:
> On Thu, 2025-04-24 at 11:04 +0800, Yan Zhao wrote:
> > From: Xiaoyao Li <xiaoyao.li@intel.com>
> > 
> > Add a wrapper tdh_mem_page_demote() to invoke SEAMCALL TDH_MEM_PAGE_DEMOTE
> > to demote a huge leaf entry to a non-leaf entry in S-EPT. Currently, the
> > TDX module only supports demotion of a 2M huge leaf entry. After a
> > successful demotion, the old 2M huge leaf entry in S-EPT is replaced with a
> > non-leaf entry, linking to the newly-added page table page. The newly
> > linked page table page then contains 512 leaf entries, pointing to the 2M
> > guest private pages.
> > 
> > The "gpa" and "level" direct the TDX module to search and find the old
> > huge leaf entry.
> > 
> > As the new non-leaf entry points to a page table page, callers need to
> > pass in the page table page in parameter "page".
> > 
> > In case of S-EPT walk failure, the entry, level and state where the error
> > was detected are returned in ext_err1 and ext_err2.
> > 
> > On interrupt pending, SEAMCALL TDH_MEM_PAGE_DEMOTE returns error
> > TDX_INTERRUPTED_RESTARTABLE.
> > 
> > [Yan: Rebased and split patch, wrote changelog]
> 
> We should add the level of detail here like we did for the base series ones.
I'll provide changelog details under "---" of each patch in the next version.
 
> > 
> > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >  arch/x86/include/asm/tdx.h  |  2 ++
> >  arch/x86/virt/vmx/tdx/tdx.c | 20 ++++++++++++++++++++
> >  arch/x86/virt/vmx/tdx/tdx.h |  1 +
> >  3 files changed, 23 insertions(+)
> > 
> > diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> > index 26ffc792e673..08eff4b2f5e7 100644
> > --- a/arch/x86/include/asm/tdx.h
> > +++ b/arch/x86/include/asm/tdx.h
> > @@ -177,6 +177,8 @@ u64 tdh_mng_key_config(struct tdx_td *td);
> >  u64 tdh_mng_create(struct tdx_td *td, u16 hkid);
> >  u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp);
> >  u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data);
> > +u64 tdh_mem_page_demote(struct tdx_td *td, u64 gpa, int level, struct page *page,
> > +			u64 *ext_err1, u64 *ext_err2);
> >  u64 tdh_mr_extend(struct tdx_td *td, u64 gpa, u64 *ext_err1, u64 *ext_err2);
> >  u64 tdh_mr_finalize(struct tdx_td *td);
> >  u64 tdh_vp_flush(struct tdx_vp *vp);
> > diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> > index a66d501b5677..5699dfe500d9 100644
> > --- a/arch/x86/virt/vmx/tdx/tdx.c
> > +++ b/arch/x86/virt/vmx/tdx/tdx.c
> > @@ -1684,6 +1684,26 @@ u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data)
> >  }
> >  EXPORT_SYMBOL_GPL(tdh_mng_rd);
> >  
> > +u64 tdh_mem_page_demote(struct tdx_td *td, u64 gpa, int level, struct page *page,
> > +			u64 *ext_err1, u64 *ext_err2)
> > +{
> > +	struct tdx_module_args args = {
> > +		.rcx = gpa | level,
> 
> This will only ever be level 2MB, how about dropping the arg?
Do you mean hardcoding level to be 2MB in tdh_mem_page_demote()?

The SEAMCALL TDH_MEM_PAGE_DEMOTE supports level of 1GB in current TDX module.

> > +		.rdx = tdx_tdr_pa(td),
> > +		.r8 = page_to_phys(page),
> > +	};
> > +	u64 ret;
> > +
> > +	tdx_clflush_page(page);
> > +	ret = seamcall_ret(TDH_MEM_PAGE_DEMOTE, &args);
> > +
> > +	*ext_err1 = args.rcx;
> > +	*ext_err2 = args.rdx;
> 
> How about we just call these entry and level_state, like the caller.
Not sure, but I feel that ext_err* might be better, because
- according to the spec,
  a) the args.rcx, args.rdx is unmodified (i.e. still hold the passed-in value)
     in case of error TDX_INTERRUPTED_RESTARTABLE.
  b) args.rcx, args.rdx can only be interpreted as entry and level_state in case
     of EPT walk error.
  c) in other cases, they are 0.
- consistent with tdh_mem_page_aug(), tdh_mem_range_block()...


> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(tdh_mem_page_demote);
> 
> Looking in the docs, TDX module gives some somewhat constrained guidance:
> 1. TDH.MEM.PAGE.DEMOTE should be invoked in a loop until it terminates
> successfully.
> 2. The host VMM should be designed to avoid cases where interrupt storms prevent
> successful completion of TDH.MEM.PAGE.DEMOTE.
> 
> The caller looks like:
> 	do {
> 		err = tdh_mem_page_demote(&kvm_tdx->td, gpa, tdx_level, page,
> 					  &entry, &level_state);
> 	} while (err == TDX_INTERRUPTED_RESTARTABLE);
> 
> 	if (unlikely(tdx_operand_busy(err))) {
> 		tdx_no_vcpus_enter_start(kvm);
> 		err = tdh_mem_page_demote(&kvm_tdx->td, gpa, tdx_level, page,
> 					  &entry, &level_state);
> 		tdx_no_vcpus_enter_stop(kvm);
> 	}
> 
> The brute force second case could also be subjected to a
> TDX_INTERRUPTED_RESTARTABLE and is not handled. As for interrupt storms, I guess
You are right.

> we could disable interrupts while we do the second brute force case. So the
> TDX_INTERRUPTED_RESTARTABLE loop could have a max retries, and the brute force
> case could also disable interrupts.
Good idea.

> Hmm, how to pick the max retries count. It's a tradeoff between interrupt
> latency and DOS/code complexity. Do we have any idea how long demote might take?
I did a brief test on my SPR, where the host was not busy :
tdh_mem_page_demote() was called 142 times, with each invocation taking around
10us.
2 invocations were due to TDX_INTERRUPTED_RESTARTABLE.
For each GFN, at most 1 retry was performed.

I will do more investigations.

