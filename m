Return-Path: <kvm+bounces-40472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 71E0FA577BC
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 03:56:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B52C3B38AE
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 02:56:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 204FE14BF8F;
	Sat,  8 Mar 2025 02:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kXc+KZzK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB197C8EB;
	Sat,  8 Mar 2025 02:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741402607; cv=fail; b=V19bBHQCgvB3u+Wr/QiwfOWl0XQvXeJzCaNnYHNBXBA/Lm++fc064QEJ9qC+UB8vbd0TgyJOiCffKPFnss2MQeSInda+gJwxnEIj4KfEa9Cx4FMqaZTk+CtLFBQpw6bI8TVQyui3zgP+AqVkmQ8SZwbgD3HN65MzQ5hO/jtboIA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741402607; c=relaxed/simple;
	bh=3u1q+t0FJZH7Kgzj0bPDdlhi/wTvR+beYrigwUQrLS0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Q7goujVUTyDvgxApePq3qvbZPVmGtrhazk1PHUrK2pSzh02g/nwK3CZS8yrtT/Uau5PhfU0tcwO2XUceWpXpEos6c3WsE2sj/Vr1T+sstgEgsR2wbKOHxqWYDMnJPFqWB4Bkhf4jeyR++eMVQEyG4zbD+QGjkeB1zbE8vYfBb3M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kXc+KZzK; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741402606; x=1772938606;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=3u1q+t0FJZH7Kgzj0bPDdlhi/wTvR+beYrigwUQrLS0=;
  b=kXc+KZzKGTREfNVUMx9UPdPd6gxMua6cdq9dcLcacK2PYtWkrgMXOBH0
   DQfQH+T+y9LiCboPJsGaJ8/23j9ISAwsPJTTTDKCu9TCZ3aiF3TrRhNX6
   nDdfYgtRe3Dc7g78weTgIMXXSW26lzFTAxmq+IuRjRRqRWWKiBiRTJMG9
   PSSV8HETfR0JZgjMlOS4ThOC2N1oYrdmDB+9rKfW7Drl1AUWYsCvZIs9Z
   vGQ/gdp/36ZkkO0QmwN6St8m2ySduFBMc/SM9pxaAhfZty4VVr3vKcbs1
   4T8IoEfusU+ClexAeM1SsJFfS8KaBzcqSCuPYMMHT6jTN1AKxQznYl0t9
   A==;
X-CSE-ConnectionGUID: eHUH928YQDSoWX2sYgEv0g==
X-CSE-MsgGUID: MDuxfHqjSWG0UziLEKzDQw==
X-IronPort-AV: E=McAfee;i="6700,10204,11366"; a="42169283"
X-IronPort-AV: E=Sophos;i="6.14,231,1736841600"; 
   d="scan'208";a="42169283"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 18:56:45 -0800
X-CSE-ConnectionGUID: sGCdiGMET7Cck9v52x7yzw==
X-CSE-MsgGUID: 7DD3NFHETeWW4elFAA01Sg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,231,1736841600"; 
   d="scan'208";a="119975401"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 18:56:45 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 7 Mar 2025 18:56:44 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 7 Mar 2025 18:56:44 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 7 Mar 2025 18:56:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SOGbo6qKpivTBVZHCJpg6mntA8CWAkSXc/x1wxlCr4BifM8idPH61MqvGWsORcdS2gvMXrJ81Gl8XmWMgpaLkrDLX+lb2W4SuzaMKmo13vDGubmXmATxDK+TbsLZl9eY3CppKju0AjhHBfWNI7T0UQzfitxIah1Da1LRqcYKN/DSWMz78EUM8tSDtuvCS2YH5oB+blLGJlqO5pCxOnyXuyIus/8jJO2oSDZx9dOSZLzwy5SG25vyqksBu/oA1fEJu7XwPKug19LmjLw57a9fXXI+gg4FwTS9sv3xXu6d0PqqyPQFy56Wjzf/w7p3CLi+pOJkFhdM94Eo1TdSwfUY9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3u1q+t0FJZH7Kgzj0bPDdlhi/wTvR+beYrigwUQrLS0=;
 b=N6fgwDZBTLf7tVgEfTDGauManBQoTfiRNAzUiitI8EwoNKhlXM0Naz2Yba0pwrhQ3draEANSrwvpe9IXryhBBeH/rGVLLKJ4xtRXchu9GX9WT8kMSTKquDaXnINxgX5tVnLfdBJnJCi+wrCJzCOv6YZTmY6kJ26FOlmg65fd8VDKkG3gin/UCFKrYk+iLeo8gwZ8yu4ohRWeDZeesfjz2yKzX2aMavylbTn37qGJL5UqoG0lkz/gSsgKowQLbTcLwPMutQ5BEEsReBEZzgP7qzMGUm6+LLZuCOP16hs2SsKoBU0WDfGTLlsAW11EjvztC1RBprwHlhe99n6VaWnNvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by MN0PR11MB6280.namprd11.prod.outlook.com (2603:10b6:208:3c0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.18; Sat, 8 Mar
 2025 02:56:41 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8511.017; Sat, 8 Mar 2025
 02:56:41 +0000
Date: Sat, 8 Mar 2025 10:56:32 +0800
From: Chao Gao <chao.gao@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: <tglx@linutronix.de>, <x86@kernel.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>
Subject: Re: [PATCH v3 04/10] x86/fpu/xstate: Correct guest fpstate size
 calculation
Message-ID: <Z8ux4Df3o2PPxXey@intel.com>
References: <20250307164123.1613414-1-chao.gao@intel.com>
 <20250307164123.1613414-5-chao.gao@intel.com>
 <4e18ddd0-a122-449b-bbbd-aeed3475a324@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4e18ddd0-a122-449b-bbbd-aeed3475a324@intel.com>
X-ClientProxiedBy: SGAP274CA0023.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::35)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|MN0PR11MB6280:EE_
X-MS-Office365-Filtering-Correlation-Id: a2387771-5f27-49c9-9439-08dd5decda31
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?qkF4a68e7sBoDLPEn/q8x3A92UVVOnii/x3Uuz5XDgOx53n+qex/EAKdaYpW?=
 =?us-ascii?Q?fAvSgrhl2xwUqTx6WvsMp3LXJoHfr9tROr/RQbCSyF8olRcy7vFQkSeby5CA?=
 =?us-ascii?Q?/ziX1ebuj2I2ZNwMMdBTrqqK9six2bIeQcq0fKrRDnzYYmNkppSWbUwNzlkb?=
 =?us-ascii?Q?XjUyDDqVQa67eHcgTkRYH1VDsz4I7tAKQybERj/hXJeY3PFcV8Cl2MHSMc/1?=
 =?us-ascii?Q?vN5qarJvghs1n6U2vgXAHvHok0uDN2/Pv/2DmbfNMelpbXYCEHcpxpbN1w8T?=
 =?us-ascii?Q?vqy81IDWjp6YRdbvXD+8yl0HClSHIGfsG+xr8V17NxlRlbPi9GoioJxQwfjT?=
 =?us-ascii?Q?BU02dSszgg1hhDmmysgJ+z+yJP4/Yc+erSfRvkiVT0pQ6QV6Mi6yFfBV2LNI?=
 =?us-ascii?Q?+c0h5RKk8Qe6WxE83Wsvyhd4zfi8m+ZgCTzTlcBeCMwoq7fYpa6EwENX4/Q+?=
 =?us-ascii?Q?gwyhKHw9dyEd3P/+HNlIhYiR+Fz6vqatTB1ttspYpEbK9+NP7HLTV5aOglm3?=
 =?us-ascii?Q?IN6mzU5Ui2aTcgi1vVAaRkynu8OYaeLY3Dh6gokuC3H9j8AJnwyXOIao0lMd?=
 =?us-ascii?Q?U7taa3BzGlQ92ij2ZYtJz0Ud6RCuz4sfTYPWtMB1henN8I2btAWolFjKO4xH?=
 =?us-ascii?Q?CqNv+K0WxBzVPFB9m0ltEV9ZS2tD6IUNhmu/rYhyoR3ZrQFIe4OKCWRPwJNQ?=
 =?us-ascii?Q?o2a5tKXK98HkKjyh/OBGrgMi2rQCv8iSgXbCSYVKDEGa10yStfDPW5ZfERvz?=
 =?us-ascii?Q?leLMBgq5s/bGiWMvQ6uxQKecXlGsFzWkIDSAkYBXkqQ5Pvgbaa592arv1m83?=
 =?us-ascii?Q?OpcXcZtJ3pyYPbhYBJLFcKX27FvOsavth9WBzGl7br6GJXS2v1ClbxZXSo14?=
 =?us-ascii?Q?X0fHlumHEFNm2R/6+QuAne3GFb/a2HPYvhUZl+o25teJidphyptTephR04k9?=
 =?us-ascii?Q?zBoxM8I3zLAf5sR0o+2UrKOfi07HyeniqdnUzJAhO6Q6Cyi58naHZ4uK6nFf?=
 =?us-ascii?Q?AxpZzwa1kGJHXV4RUu90Rt7x1mZGcFdj/SWmJdhx2nTNalN2Fo7kNUtBEdH2?=
 =?us-ascii?Q?ZiC/RwIOC1v0lcT+Bi6JfsMf4lKPx4dBbO3rHl3nXveyPhwMs7qyIIEcTmee?=
 =?us-ascii?Q?giXqMAJZkkyvfyz4YzQ94sTtVMErBzUx3R4XBXN/h/DR4QKxJjyIaCe225pk?=
 =?us-ascii?Q?DJ8iId6dV8w0HD3GVjehwRq0V4z0HBRntRhkBN4wcHeoMEBhy2ByeAltD1N0?=
 =?us-ascii?Q?1Qw61ntF3Fz5yOlmEvyhFsMsMXdz1HRJNTvQmjXOrNZ7g5oYkXOi3Or1encJ?=
 =?us-ascii?Q?p7gFZCkDK6DmTAMqt7gFlabnddQITL2kHU1Vzm6h5PF15Xv3u2AJwXgfE+EH?=
 =?us-ascii?Q?VRlcVf+xdRAgcdikU8vQ8DpktPvZ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uh6mHlQfGIbu0GamOxdabxqHClIiuoTTqiGRzKVcjUGCmfet/0lsQvk7vz9z?=
 =?us-ascii?Q?JH8qCo7ueH37sir2D7NOwf7/S87yfBFxkaiboXjol3mJa6opr24lwgjemBZW?=
 =?us-ascii?Q?Hdbs5wmhbqNo/kcLHbVY6jZtdKKvd+6XGIxHf9wyQZr3grhZapt5u2ycIcwJ?=
 =?us-ascii?Q?oIYYY3wvqmiMdt5FofW9kk2pH6/tVi3mxQtzubdmFCQBZJXmabqffCbYH0en?=
 =?us-ascii?Q?NTk35PnOA1HOcfbKc3rFndswfzk4Vo7eAlKWj6LJxl/8q4/EZ6aru/2o1FIL?=
 =?us-ascii?Q?thf/6lWjl3F47+yba41XZ5iBZfYh8MjMPLFEqy7ngtVl9IRXWzEJyde7iSDS?=
 =?us-ascii?Q?DT09REXXa5HOpmugUADSfA15uFr6cw2wLFgkwkkvHn27tnbzMQcuT0eGpr9m?=
 =?us-ascii?Q?DUABCJfjEqFSTyEZmflHxEehO1GOgwjyLsfCVtQ5O2l6vhay501dYyO7Pze4?=
 =?us-ascii?Q?n9sbSdNVd8zY50j6WtlqX0R8ZpPokc4suLAh3y1omUt2WjbTUVbKYSzQO0zn?=
 =?us-ascii?Q?ezp+eLQFtW65CcYbYSYHVN9T4t/OvrDiXFcBGlHPHmscmpjGh35+pVoDh2UM?=
 =?us-ascii?Q?pLtv+ERAnweO1PIpguUtqffFx6w7rY1VokSjzXq4l2RrjYhGNLwXiLyrm9gn?=
 =?us-ascii?Q?UWIU2RjWJpu0hTtN2XuCOR2qlW9xLJqc3DDrPGIhPGMgGEFHivoBaJd2i67X?=
 =?us-ascii?Q?mtoKF3dmMp8EiYZQhTSxfKVfRn3YPK6U64AYc7F7T2ZrnAhA6Hc2mx1SH4Gf?=
 =?us-ascii?Q?nZoWzo9gsdL1McPBSGD47b9Izcw4FpZFgGbdT88knU6yN5tbVZ6cYPqkfpq8?=
 =?us-ascii?Q?s/6SN93w7ioYaHfK9InhuvW+SyQdwRFM1llq+PbMKid1Mm7Hsnw4AvsgETxk?=
 =?us-ascii?Q?CWDZGKkTa6qwo1z6TkjRhCDTcA3WBQIuiuaWsXQsvTgujKs7gEyvmU7HiX4h?=
 =?us-ascii?Q?DnKFYLQaMx5Kda23BTMxu7s7TQfFlmWx92naThhxhefF6duiqqWtZ5BwROaE?=
 =?us-ascii?Q?u4GITkR2H263r1aehV9OOZW1SeOZIqHPiRT4u3tuO5bSiyxa6vE12tvVI1xj?=
 =?us-ascii?Q?LoTTPFzW+/T+jNNTMDR+/Ki10JlQR9bDf/9ELbpL/256rCfoUSG+1vod4rr6?=
 =?us-ascii?Q?uQuJzDIUerBB9yVNLCeox2bxP8+lYqzMnNn7bkvGGeK+KYxEKUAvA4wjr9pS?=
 =?us-ascii?Q?LeIYiDSHl7XhpfeBd9sgyCivjqjfZ/PjbVazLzOkRlrheXPXGjjZwztlVtn5?=
 =?us-ascii?Q?BpvN+JYtjonqlLg4/62KeqfSOHsssavGh8YQTmJL07IZKQEkkc3OAXTb+ujI?=
 =?us-ascii?Q?o+vwRaQ4gOtWe8Tg3l3+TwNSJcyoZ6Nlovk1zkM22dUL85w4/Rxj1Xx0ueJ7?=
 =?us-ascii?Q?USVTlpDUIZ99KCre8zkwGYNwQhWyUFIctoUBXWvmDTNTYZ5YxTcJ155QdhyM?=
 =?us-ascii?Q?ISsXPtK+xGZwwZdN0lLZnFZmH2vlU5EhIG8286pSYSXg/cEjSU7VRa3FVecS?=
 =?us-ascii?Q?MuYrkrbjArvbqCQQroHLWonKMFMy3orC2+zE2TnNr0gxHYKRcp26fa95tXa3?=
 =?us-ascii?Q?i8pxp3owJayzSdQjyaL9TiXCv2Fyw9J2AoXvGt53?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a2387771-5f27-49c9-9439-08dd5decda31
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2025 02:56:41.2142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o1IAe7cRH32jc1sLBQuE5FolIhqO2g6hhCaWtRQFMm13K3Lp1bNv+3kXY3m7MCGGt5ZUK/pPT8wZ/g0Osu6aoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6280
X-OriginatorOrg: intel.com

On Fri, Mar 07, 2025 at 09:53:40AM -0800, Dave Hansen wrote:
>On 3/7/25 08:41, Chao Gao wrote:
>> Note that this issue does not cause any functional problems because the
>> guest fpstate is allocated using vmalloc(), which aligns the size to a
>> full page, providing enough space for all existing supervisor components.
>> On Emerald Rapids CPUs, the guest fpstate after this correction is ~2880
>> bytes.
>
>How about we move up the fpstate pointers at allocation time so they
>just scrape the end of the vmalloc buffer? Basically, move the
>page-alignment padding to the beginning of the first page instead of the
>end of the last page.

That sounds like a good way to detect similar errors and might be helpful for
all other vmalloc'ed buffers.

I can try to implement this for the fpstate pointers. The patch will be put
at the end of the series or even in a separate series.

