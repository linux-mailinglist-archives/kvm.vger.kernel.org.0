Return-Path: <kvm+bounces-54790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 336FFB28193
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 16:24:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 361F95A330C
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 14:24:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38A3E22259B;
	Fri, 15 Aug 2025 14:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ygd86nRJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F121D416E;
	Fri, 15 Aug 2025 14:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755267870; cv=fail; b=MZcxYih1ZilZfrZ+NrRkXvNTcrQYceynN+sIH3FI9hvgncEk/zew2cczato6cPjxDvsE09GU1aPPTLymBke9S8drP4UgggxEcgdVQCqXgwu7BRRxly8CRL9aTunFNAKQxlGxTVZZGnvs72ZvZFI3YAzkVonPGFLVayjOwo/CDCw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755267870; c=relaxed/simple;
	bh=qU+iElujRgDINBBn1pLv3T5XMm5dXzi0WXRAeu87c7s=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cqoRvYq5wvPyo5wQ2Xp1/FiNxFsM+7xTS1CvY11eUIgDnZzCCjoTetCxb2lWeMPNzvhL8qn4CIpAceBsY9ALV+QfCxGvK1o4yJQ8olJVwSnqlFMx4voy9bsQx1Q64D3dZV2U+GxvbyShXyxAkZnean84TsZ/M4ocYELUTDQsBlM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ygd86nRJ; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755267868; x=1786803868;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=qU+iElujRgDINBBn1pLv3T5XMm5dXzi0WXRAeu87c7s=;
  b=Ygd86nRJbvnZSU3I+crfoZnqCvHcR9A0RAXtnMDHNlz/Jk6lXMk/+Dx+
   UpILhFb1mHc/bgfCUQVGBjlVSQsI7Dh8a3agEueLcjmOdX9NDtKdBkt9V
   Ui1GNAhOhKMvzpUUg0FqDNiOYCdTrWiS5RjTslDxcSYFkwwK87zL0MfUd
   J+nI8TIpobFAVoXkv982c+bt6fwyWS8YhcpCMFGYL2kdRBZmFe6ciOIZ5
   trR2Zo1j4ZUB08FdyNfY+WHmdYBDxu7q6zQWryEauXcuQwxrv8xbjDbYp
   mvG+XvMVz8dUYI946mVxLTKlS7SRndCvRWFsLz9OLjAkgh1IQ4Mb88zLL
   w==;
X-CSE-ConnectionGUID: 7q0Q7zkzRvOj3kmsxjdg7g==
X-CSE-MsgGUID: QEtWYVBITISkdHQqBqKOtQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11523"; a="75037621"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="75037621"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2025 07:24:27 -0700
X-CSE-ConnectionGUID: wgNoS0GZQsCcMYtVYdJdxA==
X-CSE-MsgGUID: PV6owUouQrKKFWunROCn2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="167397562"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2025 07:24:27 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 15 Aug 2025 07:24:26 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 15 Aug 2025 07:24:26 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.68)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 15 Aug 2025 07:24:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O3RKpjG/nb9/Vc/WyqfLo3wdtsQRoPrJ91vGXDvxkKdwguORv5S/DUDgCm1IxtSbHZ9bJ8HkFlEeIqv5xxCJ0Uh07IMHk4c1WY+dq1AUBT8Vn2pfkrutVMR6hn1V5Sg3efYMZCmdYytz6Unf6XMiUd+BCiWxFvGxM4h7vnKbr1I3j2DUloaWvLhNFBFMV2cjhGuS2YvYgNjen1fRemC7HP6WsdoNdHaMaJ53aPg5fglukMYenVs4z14BlgLooKidHI8mbff+YBfE7vc2zSxtafoY76dJzoSIi8hcWT/8pnUxT/EfdFxnsNQviA3+B5fCxVnxKgy6zSUGs0sGAL8j9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H2igbOBhfRTH1UQyJH+FH8ZVZcvb3PQMIdTIlapNwS8=;
 b=Q/I3Os+zZIUU8jEEI7VuhAM9XVBXc3ksHHDfXG++9JEE4SXEFo8shgGNDCD6IOGimcnTP2vd/JZonHUJZnFC4VOea0GG3qUtew4WhOUf8B2HfxH3iTxR7/DUOOoFY0iQOYl+d7ZnZem/4QTSALoxfu4owbdlrJZUdNRTNTubLMh7bnEJcR9BT9L3tKp+gZlToOQp5K30DJjRMAe1IrkvGDNkhD0C2Xcw2NuZSztIe2BaQHhEh5fP5AcE4AWtuocH2ICLA+8Ka6icZ2jLVI2EtGsh48udj0F/0OFdFMIyHhsUZMKVoHRq1VX29vKBj1ZEgQFd6egRtZMPBw0R8dgqkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CY5PR11MB6389.namprd11.prod.outlook.com (2603:10b6:930:3a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.16; Fri, 15 Aug
 2025 14:24:21 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 14:24:19 +0000
Date: Fri, 15 Aug 2025 22:24:07 +0800
From: Chao Gao <chao.gao@intel.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <mlevitsk@redhat.com>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <xin@zytor.com>, Mathias Krause
	<minipli@grsecurity.net>, John Allen <john.allen@amd.com>, "Sean
 Christopherson" <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v12 22/24] KVM: nVMX: Enable CET support for nested guest
Message-ID: <aJ9DB12YVJEyDORD@intel.com>
References: <20250812025606.74625-1-chao.gao@intel.com>
 <20250812025606.74625-23-chao.gao@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250812025606.74625-23-chao.gao@intel.com>
X-ClientProxiedBy: SI2P153CA0017.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::10) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CY5PR11MB6389:EE_
X-MS-Office365-Filtering-Correlation-Id: 23692a6b-af14-4614-8c48-08dddc076bbc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?rXsxPGv+KVj7hLv6zsdyKypLuK3pB6T8At7aiQbhs3SgDPZcNLxvCDwehNtb?=
 =?us-ascii?Q?0tpFj6g+JT2WoN+vaLpNIsBI06PfkfOEnxzULjoMSZp+9khGkWqaQyoVXaFA?=
 =?us-ascii?Q?A1+86nGgATImoQTx/wjkkphvN0sVIewtLsVIw0CZ/1pWY/+H7Z7WHvKbBlIZ?=
 =?us-ascii?Q?mdmE7u8ENUA8UXN3sl3fV4k8rl00t78bqY8v+pNf4OH17EgGiktVw3tdmrzP?=
 =?us-ascii?Q?mOSoZN8WT0M6Zr4Wl+7nWIqI2hsh7f9P9aW3zytda5X30r6N8DHSmsftRlAH?=
 =?us-ascii?Q?Xzys8hYj0Zz+3YF1Ba01NGln5dteAqgASQvFymOtJFtKoSxZ9ND8qWG5YQtH?=
 =?us-ascii?Q?86nRYRIvGTsAeZAPI0GdHbVNRqURRV0fzHXVUl6hs2DptvyTr1SRSS8OKErw?=
 =?us-ascii?Q?ghtHZg6Jk/PP9jincuLuvy8Ok5pdBzIKBb8ehVSkBfvH2ziUopoTwMZP5mW+?=
 =?us-ascii?Q?oGE61h0UJ7eljc3lUMlRgDe3zvi2nD7gPCOA2g6uHg4Cy7L2SMJcXYS45Mx1?=
 =?us-ascii?Q?LKqC01oNRCjyrk8gOjwxJCCtDmqQmCb4nmApFd78K7VzQ9hqagGCm+eWRax1?=
 =?us-ascii?Q?+k4KTEzRMfgAXsPge5ZtOiQOIQEg4fWh6c7FvG2fqgwaB2aiVuGlTt+odU7L?=
 =?us-ascii?Q?ogT5aAj8ZowTHmTm8vTFsK6epm2hV3wm1M6ZbTm69xBRt55JQsw6Pb0IeLdT?=
 =?us-ascii?Q?iFZ69Gp/QYnR4A84gs7EsHAOropsxGK6pbP0y1S8XyxfQuADoYFlIBThTMrt?=
 =?us-ascii?Q?b3Qp2bgfHMHb8FrKwovXAkyRfQ2xI+XmcUkdiWf9ZfmANs5epvB16c0HPCuj?=
 =?us-ascii?Q?YCHys7AKOzHV0RJe3UmkQ09siFsj6sRPrOTzA0u+ibw9WNWg8pKR2ojNFho3?=
 =?us-ascii?Q?vw0v3cffwXFeLKSSMvcj5bJpWvyV4lMJpPKz2PhBAS6X5WsIJCfQFvm++79f?=
 =?us-ascii?Q?0yMmFtz7g5KhrceYVUgP72JOuopQH98oEIZMLDqsKnGOtVJ81bIBHQq0Q6Sc?=
 =?us-ascii?Q?qwzkewU65P1tos9ke0KBHCQLLgWVtDj+5xfSunWAt0jRZTFN9qygTZnbNwFP?=
 =?us-ascii?Q?DY5GQ5g+jDGDMucxXU9MjmW69tmGcuTajRoRx4JRt8UJx327pWOGTnkIXXHS?=
 =?us-ascii?Q?pjrtM31sdqw51iE8ExyNJ69TmpoFvW5HaCR9yKaAwUCqpUGae+QEynxCNhha?=
 =?us-ascii?Q?uthHzK6MtiHVOzJeNcW6xAzBVYDITaZ2zLtDLjyijaNu9Fttr4NuKdza/Ak/?=
 =?us-ascii?Q?Au3wLwvqBYWLfA955tDIJv0waxnibWSluIuF5YXEWTSldklKBLSmLXxPOu6L?=
 =?us-ascii?Q?Dx9qdIazqHq7AGOrquwJpMwBDJ6BqDoKD4iQ6xUieouWXe6ohMyeEVVvDVVW?=
 =?us-ascii?Q?Z95QlEkmDDrwEc5OwS8Fv+D4PNBiPWBR9cZ0iRgXQleebILvnZw63ZwQWNya?=
 =?us-ascii?Q?d1ZLh9E9ZT8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H/RSwQpKlA7PUB4oUyGH00DwH55/00GpREN2lkErZ0ZQc9jo2UW/AimVW8Jy?=
 =?us-ascii?Q?ks552XH0fUpQG53a+yohXZ9Lj1GCMK9srVhl4jk7QpiydN3FK3lJxOxZnAqf?=
 =?us-ascii?Q?Kc6BQzrRh/6pJxvGlwql8KHvVqNwhcyVCq6QEmBAQxhL7gvke/ulZ5rK+3Za?=
 =?us-ascii?Q?M3NdNfrMe4jpHwO0ygn2CUne9+/sZrKQcbpZfSWuimZAKNhVHytrqmdfECK3?=
 =?us-ascii?Q?jndmngqnYsta21G9ASPGDb9TsxdLlJAvMbjjlyID6U25u09Ih7E/CtnMUQrY?=
 =?us-ascii?Q?1p8zoU64nTCbaqXBJahJz+4YrG0uAvtomSV/wmUGPTeKrXqnckMU4/jp3fpd?=
 =?us-ascii?Q?8M5w2egdf6wI/1PBLTPYmJ1IPMnvXzO0P0UGqtjZ3b06k8qRxUChZjfBaixy?=
 =?us-ascii?Q?D93XnBqfVpxjhec4A79LwATFLY2yAPY7xzuebsHGI9EhygFEAnkg9jVuQG4v?=
 =?us-ascii?Q?HHbU/bTDrE/02btim82jhqUiHdZoILI16s0857oPHXobULEvXjpp+0cTwPbc?=
 =?us-ascii?Q?ypaV5gL4XqsstCQgfSXbe4QFKgn6KfC2pPPNN5H6ikWhmVVkqDI3pga83aUU?=
 =?us-ascii?Q?+Yo8ZnqfgzTHltaDUvOgIcrGBBwN4R9txn1X2U8SJ8PNimoK/HGbXR3pRYDe?=
 =?us-ascii?Q?eqyf6Cbsg5xMKwEpof+y0PxMwVvcYNpOZLSFb8G7PyOA0b0y/qtyfP7Jjeh5?=
 =?us-ascii?Q?PuwP3ZJYxY8gkZA9SQrjn6VUmzZ6l0UicfAw0GTyVzTYGQNu2e5Rar0IepXU?=
 =?us-ascii?Q?oZ/BFCQ5pzs4hmrutXqW56vow3Q4s4GCCJ1Ayq+3eE4e4uRCU5nxitIhHt1j?=
 =?us-ascii?Q?c+SUaEO33cFzHDhSdYGv+5y8Rh4AoiL1+eGjjJ7iTWLg3hB7rg1dRAZR06PQ?=
 =?us-ascii?Q?xoKL/Bf4onVkZCefwHXr9VyOnVRSVrWt4b1XiGoUYYw6KpYvZxdvdTW4idFo?=
 =?us-ascii?Q?nV7ibcVwTYlYMqwk8/D7TPbMRL2ZtNS/5IVNsCe852RkLrob6lN+VgWqqiJV?=
 =?us-ascii?Q?CEjenpiHx4/PcYBoXxpT+Uxeayn5fysA9hBwWAuvNnZ7N8JAoz1KeqKzAsJ9?=
 =?us-ascii?Q?Q2LvGyBDXKy0wm1qlWNQ4n0ccPU6BOII5qA4ar9sy1Zio0YDZ8x98GbSKBEW?=
 =?us-ascii?Q?QaOSE5Ht7gLKek+ZYyUSHnZtdMq1Obm0Hu1VS16LH2DqxMazmz1tuF0Fcg/n?=
 =?us-ascii?Q?eGKCNQ7iKgvxerL5vF5mCMzSsl5fx63uMc0tYU/BUvcVdEzLw6+PVbxZ6oRw?=
 =?us-ascii?Q?RUJorMH5fteo6ttznAJpNNxnKz3lXd0n02HXDYK72Q+CiMrrUdFxfE24+WGz?=
 =?us-ascii?Q?9le/uq9chLZiTJVZqI5xh7qDvPGBCbp9dX0UZ/aAa7Y90b3IgKneHdm8sP+5?=
 =?us-ascii?Q?mVMbAjvt7y3cmHKb38ItAbtPXSM5ZQ9DA/teKyznsd+u3/OaCSNvhT8TBrBK?=
 =?us-ascii?Q?BMw6RihSptzhC2helgWxvcMMR57vpxKyinFzNZL/evOU8B71XZw6vY1cfqxT?=
 =?us-ascii?Q?C2jio5YvprrK3ZiQPrRJ177oKiErJHYbkfa+s1MHnu2ight3yNJBWCtnPNIL?=
 =?us-ascii?Q?9t3z81UMMzY3RDF5fKtM/rB1kg8jCvFThARUwK/N?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 23692a6b-af14-4614-8c48-08dddc076bbc
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 14:24:18.9015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i0hIsSs4DwHghvq7CpGU87roQbEvanPkH+ArQ6XAbKPlnC0hTkogdElCepY8G0AnBt4oQu74iKHjfC7pqYkdmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6389
X-OriginatorOrg: intel.com

>@@ -4479,6 +4543,9 @@ static bool is_vmcs12_ext_field(unsigned long field)
> 	case GUEST_IDTR_BASE:
> 	case GUEST_PENDING_DBG_EXCEPTIONS:
> 	case GUEST_BNDCFGS:
>+	case GUEST_S_CET:
>+	case GUEST_SSP:
>+	case GUEST_INTR_SSP_TABLE:
> 		return true;
> 	default:
> 		break;
>@@ -4529,6 +4596,10 @@ static void sync_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,
> 	vmcs12->guest_pending_dbg_exceptions =
> 		vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
> 
>+	cet_vmcs_fields_get(&vmx->vcpu, &vmcs12->guest_s_cet,
>+			    &vmcs12->guest_ssp,
>+			    &vmcs12->guest_ssp_tbl);
>+
> 	vmx->nested.need_sync_vmcs02_to_vmcs12_rare = false;
> }
> 
>@@ -4760,6 +4831,10 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
> 	if (vmcs12->vm_exit_controls & VM_EXIT_CLEAR_BNDCFGS)
> 		vmcs_write64(GUEST_BNDCFGS, 0);
> 
>+	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_CET_STATE)
>+		cet_vmcs_fields_set(vcpu, vmcs12->host_s_cet, vmcs12->host_ssp,
>+				    vmcs12->host_ssp_tbl);
>+

Xin wrote a new test [*] and found a bug here. If VM_EXIT_LOAD_CET_STATE is not
set, the guest values should be retained after the nested vm-exit.

so here should be

	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_CET_STATE)
		cet_vmcs_fields_set(vcpu, vmcs12->host_s_cet, vmcs12->host_ssp,
				    vmcs12->host_ssp_tbl);
	else
		cet_vmcs_fields_set(vcpu, vmcs12->guest_s_cet, vmcs12->guest_ssp,
				    vmcs12->guest_ssp_tbl);

This creates a dependency that vmcs12->guest_s_cet/ssp/ssp_tbl must be
up-to-date here. So, vmcs12->guest_s_cet/ssp/ssp_tbl should be synced from
vmcs02 on each nested VM-exit rather than lazily in sync_vmcs02_to_vmcs12_rare().
Specifically, the cet_vmcs_fields_get() in sync_vmcs02_to_vmcs12_rare() should
be moved to sync_vmcs02_to_vmcs12(), and is_vmcs12_ext_field() should return
false for CET VMCS fields.

Note that Xin's test differs from the test I wrote [**] in L2 guest behavior.
His test writes to the S_CET MSR, while my test reads the S_CET MSR, which
is why this bug escaped from my CET test.

[*]: https://github.com/xinli-intel/kvm-unit-tests/commit/f1df81c3189a3328adb47c7dd6cd985830fe738f
[**]: https://lore.kernel.org/kvm/20250626073459.12990-9-minipli@grsecurity.net/

below diff can fix this issue:

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 7c88fedc27c7..eadd659ae22f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4596,9 +4596,6 @@ static bool is_vmcs12_ext_field(unsigned long field)
	case GUEST_IDTR_BASE:
	case GUEST_PENDING_DBG_EXCEPTIONS:
	case GUEST_BNDCFGS:
-	case GUEST_S_CET:
-	case GUEST_SSP:
-	case GUEST_INTR_SSP_TABLE:
		return true;
	default:
		break;
@@ -4649,10 +4646,6 @@ static void sync_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,
	vmcs12->guest_pending_dbg_exceptions =
		vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
 
-	cet_vmcs_fields_get(&vmx->vcpu, &vmcs12->guest_s_cet,
-			    &vmcs12->guest_ssp,
-			    &vmcs12->guest_ssp_tbl);
-
	vmx->nested.need_sync_vmcs02_to_vmcs12_rare = false;
 }
 
@@ -4759,6 +4752,10 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 
	if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_IA32_EFER)
		vmcs12->guest_ia32_efer = vcpu->arch.efer;
+
+	cet_vmcs_fields_get(&vmx->vcpu, &vmcs12->guest_s_cet,
+			    &vmcs12->guest_ssp,
+			    &vmcs12->guest_ssp_tbl);
 }
 
 /*
@@ -4884,9 +4881,17 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
	if (vmcs12->vm_exit_controls & VM_EXIT_CLEAR_BNDCFGS)
		vmcs_write64(GUEST_BNDCFGS, 0);
 
+	/*
+	 * Load CET state from host state if VM_EXIT_LOAD_CET_STATE is set.
+	 * otherwise CET state should be retained across VM-exit, i.e.,
+	 * guest values should be propagated from vmcs12 to vmcs01.
+	 */
	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_CET_STATE)
		cet_vmcs_fields_set(vcpu, vmcs12->host_s_cet, vmcs12->host_ssp,
				    vmcs12->host_ssp_tbl);
+	else
+		cet_vmcs_fields_set(vcpu, vmcs12->guest_s_cet, vmcs12->guest_ssp,
+				    vmcs12->guest_ssp_tbl);
 
	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PAT) {
		vmcs_write64(GUEST_IA32_PAT, vmcs12->host_ia32_pat);


