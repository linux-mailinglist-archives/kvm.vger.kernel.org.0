Return-Path: <kvm+bounces-66698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E1CA4CDE465
	for <lists+kvm@lfdr.de>; Fri, 26 Dec 2025 04:12:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 31E41300A36E
	for <lists+kvm@lfdr.de>; Fri, 26 Dec 2025 03:11:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB09E1EB5C2;
	Fri, 26 Dec 2025 03:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E73dp5mU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8207253E0B;
	Fri, 26 Dec 2025 03:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766718699; cv=fail; b=cfXSuz2/T1JjazRcP1dsRDmpGxlpqSX7oGAxGVQvP48bRP28PKyk0ke1O/eu8lQGpkyRCWJuFpxDNbQW8zvw1SnL3EL33zU6lLTSYdVXw+rw1yIpFcjRoIaUBaQQ3TN3BQgcWIBge1CIdPaHuSwIVc3o8lr8IiEUpJ4ysaYjq8k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766718699; c=relaxed/simple;
	bh=0cR/ploaPLskucCmp5vQ+BvGNIu+4de9qp3J3WCd98c=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Yji3MhhZGmmEJ/lYmPIMBNxXoDq9krWx5jw4c+WvBVAyZfRctMV5Bc6NYz0Tv8RFffVPoBViphN5JUYzN0i1jbDriS7LmdBGXYWnrmMk9YZNait2KdXvMC/zKMi9z+dq56RrqirbwLT4Pjj8x1SjJbpe0B399HWFcmelLNL7X08=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E73dp5mU; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766718698; x=1798254698;
  h=date:from:to:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=0cR/ploaPLskucCmp5vQ+BvGNIu+4de9qp3J3WCd98c=;
  b=E73dp5mUAuEKUTVK9zyFMh8r3JRYjBu1jytYsYy+WSOwjWz6VNxiImMU
   TlTLlDZBeZrVypR62ysmq5Bw6xK/XPtso/0bUJ9C6dJGFtF9JQ0lOxk4c
   IlP273CCgq47xKb01acsoOQYwYU+U68SbUIg9rf8WkNg5//9BhCufSYI/
   ncQw9OMnLYp+30hdrTZwv2CQxMVbDdlojGi4nmna8mTuvuwaFmew8KlIw
   kWrnEpRmjhoTQnrqvmZ78T6xLX1/+u2dDU3rTNd1/RjKYxmOU2HQ9f3xT
   3c9w+5h+H0iqAYQe9LQ/WBbOgEgQG0hPeYgbBuq90CK94CplKZXqNXxTx
   A==;
X-CSE-ConnectionGUID: CpyNT3GBRr+fRLaurx2rlg==
X-CSE-MsgGUID: E2XBf68JQsOFALQSf6FTQA==
X-IronPort-AV: E=McAfee;i="6800,10657,11652"; a="68375783"
X-IronPort-AV: E=Sophos;i="6.21,177,1763452800"; 
   d="scan'208";a="68375783"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Dec 2025 19:11:37 -0800
X-CSE-ConnectionGUID: YmCFoY7LR1CTNLiHiQEN3w==
X-CSE-MsgGUID: TYDP5ysMTU64Q2JOkA+hjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,177,1763452800"; 
   d="scan'208";a="199959332"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Dec 2025 19:11:37 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 25 Dec 2025 19:11:36 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 25 Dec 2025 19:11:36 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.53) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 25 Dec 2025 19:11:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E+1pb7jpUH0N5Z8jIeSoej+I98g+adv1wF0dDCm3+8Q9OOmixaCXOF4MZg7LRCmjL3KW6vuI/clq0Xhm1ZHRbeSOde4ugVImEMs2cxi0bpCu1DaAS4s8Fvzv0xdBnYrbGh5YPUbmWmTdXv2wZpRU7zxPR7n1D9WpQTHRpvT9Ze35Qn+WxiMbPx/ONxMG3HAj2v4EiJlNWjEsON4JIYWLHBfYCF9FSpo7jwCNr42LkLIuWZXJc6OGxYwhkCLHqYzHa7U3vIqL0AklD0AINGw+3E6ls1WBV1jwWxlCf3vR/8u68NuiATEitPweIoiAWoz0tmar6kaTU7FaCsPR14Oj+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JNUGMD9XNZYfp+b8UiheLheAeeq/HiGHprl3iNnBTuI=;
 b=mKBN9jD3XAxPzLs8oT25vHWlzQz/FqwCK0DZg4UW2WCrlBk0ll9gp4Y651f0uzrA7fuYhk+7pZZHbcP5srYl6W+dLZ5ALYr/AW9Xw7On6YfOkmukmrMKWb2t/T3gyglTts6uj050d0zZda8ZbleBXcqo+S4M2gceth80VmzoFvNXXe303JcJU7sHnqjL9eQXULguvK76isoyehJfe0EdZqtLWi+HHwm6tho87y54X5orarztd3KVTTG/AJbfMIp5/I6YZzJ1iofH54y4qr7k2NURfs3jU8jNw1um4qtEXT8CduX4O6ll4MNvhrgwZ8TLjsrhfUHFz52lmm9Z3aTFUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM4PR11MB6041.namprd11.prod.outlook.com (2603:10b6:8:60::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.10; Fri, 26 Dec 2025 03:11:34 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9456.008; Fri, 26 Dec 2025
 03:11:34 +0000
Date: Fri, 26 Dec 2025 11:09:35 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Michael Roth <michael.roth@amd.com>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>
Subject: Re: [PATCH v2 5/5] KVM: guest_memfd: GUP source pages prior to
 populating guest memory
Message-ID: <aU38b/quNP/Y2J2P@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20251215153411.3613928-1-michael.roth@amd.com>
 <20251215153411.3613928-6-michael.roth@amd.com>
 <aU33Y56qBXgrL5/3@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aU33Y56qBXgrL5/3@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: SI1PR02CA0045.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::16) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM4PR11MB6041:EE_
X-MS-Office365-Filtering-Correlation-Id: ca2093d6-ac59-4dc1-fbd4-08de442c797d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?rOK7BOQMsOHV/amLaKtHPR/CQDqNLo2n3YOIa4Yp2/sZaib+/jTCfEVkurag?=
 =?us-ascii?Q?MzTd0syW4OdjlRF/ujQSIbfKwZnH0kOo8WkMvDbzXHEFnYFHdZtervuTtcwG?=
 =?us-ascii?Q?vHeTaSYzQPWp5z3vLEmbyDgzFjWSYHEzMqtah3N9DKm0NyhLZhSirQ3I+RDL?=
 =?us-ascii?Q?dSze2+Bg7pZQ2cYtGDEVJ6hFCilwsdgPhmg+eZw+B+JX8NiGlF1xVladcYWl?=
 =?us-ascii?Q?v8vklFmMzSkfu/auNA3YUyuAMsQLEuL0RErrX9x0JpNWaihTZVXF5IhmV2V4?=
 =?us-ascii?Q?WrvkNWXEGgOgF9CyL/Uiw4FSavFemDxx5wAyUDyxLgy6BdXmqQiW5N2tJhRR?=
 =?us-ascii?Q?skR/tZW0IClr5LFo0knVGumq4r1Rbfur9jeRR25umJOx7K8tZ6WwsufPJ9ns?=
 =?us-ascii?Q?942Drn4OrmibjKqVvBA44dc2H+Ybqisa1/tlCgjIuB/3+mOoTib8uej8/+Cn?=
 =?us-ascii?Q?lh6M/YrBp0qzKJRVdKYdZyPteZiMzGyNlIL0WO/JQv/piQwz9dIEP8mkNKB3?=
 =?us-ascii?Q?ygf4R6bFl9X5sJIbAAya7KcyL6VjdyLxT5ZOUxCIavYudUMQhhp/F2f00wSi?=
 =?us-ascii?Q?wo4CwL+DxkcFNxOmOb25cAAZYL8RbcPwg//Ys/HR7htGVO1mALS+8AjLC9T+?=
 =?us-ascii?Q?sLnayXxq0pMr7GacX+op8xMaECd7kQuoiF4wNk1aDxc43mFtrpvAPLGZromu?=
 =?us-ascii?Q?glprEDiplhK8MJLvm1QJQ2j0urAUDCWOXjlZkE6xHQ5tRpKZ9m1B1LGKAHJs?=
 =?us-ascii?Q?Nfr40YWXTuf/W1cVPUtvTD4brGt0xwrkkzGpJ5myYLHs1a72bmdcNNppQh/J?=
 =?us-ascii?Q?jCE4kzLH9q8fza3R1t8kMZfZwpAi4GiVDMr9LE6IFUtqXssXBVAgRe7G/PPu?=
 =?us-ascii?Q?hYd4zzewFW/g+rexTpJlOhPiR8xLK3K5rmSsa3pBLktC8xDLWPberJXZOFm0?=
 =?us-ascii?Q?k9Z6FUIZTBZDx8kRJizbvZsuA6kY2lIluuJLqJ5QLZTG5n7GXWuVP2akkRIO?=
 =?us-ascii?Q?FQBR4Mz/Qi94zGSdHhad+3mUPR9++1/CTZIR+FisDrpt+y27smfNL3VkOt2z?=
 =?us-ascii?Q?39SooO83j0yynKnxbrM9tMRCShjY41ay6fNDCYIAyJJibHCWiVbFr7bdsIAy?=
 =?us-ascii?Q?L/yy5qHyLrkHeY5iPYvgTW//Heyekk6uISMv1hTLAyJ2sjMkZ5i+Y4BKMs1x?=
 =?us-ascii?Q?zOCyAdHd7xqXi7//y9pp4ByJkRHgsJASMf9R3g8s63WDNzCzT8YQ8XJcQYCk?=
 =?us-ascii?Q?t5cQ1BaOX7Z6SzScb0auI8BvWjNwnwfBj5y889blz5YBMw6U1m7gYKS/KlzM?=
 =?us-ascii?Q?eZtTJBP0dvZ1upAxfstws6smFOMzMNl7Vk0G+YnubAs2A5uoRVhVUAq7mUL3?=
 =?us-ascii?Q?rY3907UQyoX55fxyanwszX59QFUB39h5fW72xoH7m+sIXP7Yy9fruRwaMsp/?=
 =?us-ascii?Q?1NGYAoDDO+VCFjiyzGG6tNs87J6jEZ/7bH1dTnwgVk3zkHudt8M7REnHBfft?=
 =?us-ascii?Q?hXi6Bn8NmO9VFp4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QCnazATyU955PFg+YIAGe7tIVthAt5GppgnbsINKNHDORPaMrIX5qX9Ggdqx?=
 =?us-ascii?Q?dKsVlU4QHQrQG6GvT6AsRAPUCYi0QcL3Xo0w2NuaV9/jdXlBp9WaitOQ98qB?=
 =?us-ascii?Q?2h3gxb9YjNys6EDY3iyROvM3lu4+GCVAbMPzc6O1sIFtEKbz9xruEoYB1x1J?=
 =?us-ascii?Q?UGQ3K+fJQQBKWoz1Q5IIFWpIG1ffYYwW7aOaqIeNFpKpRucx/YH1ehMhFsfV?=
 =?us-ascii?Q?GX6vxqU95mRhHbpWEBSJJwIyHBPIdHAi0oVfYNyxCTNukwHGmylwUi8CxwIH?=
 =?us-ascii?Q?iJV4H3CnHbsGGbE/K42D3pUmPK2oxVyhqkROCUlFrb2UupaFxb9jj3Gm5OlD?=
 =?us-ascii?Q?uNJx3hg3yR/eQAukkqRPT0PEtHkWVEfw3JodxEfBPbTvMrWtKepp990BJXnt?=
 =?us-ascii?Q?qq1PKJ+n20TUR6Gssz1Blkk0mqSCjqB/yT6GWbGvXjhyxOnsjMS4LzxjqpWe?=
 =?us-ascii?Q?+tDG6ZQVadwLW3jnpG4oRMhIJ2PxjSIKJ6hSYTfeVeKM/4rvy7NclMlWEGbL?=
 =?us-ascii?Q?++UpO+zAuwz4HMjU2wBfRFRY0W8Dqb7y2acFMw63mBTo52ZMkxJKw+7YlAhk?=
 =?us-ascii?Q?33eEt8Wi95ypJJc6ox+IcUhjSIWdi92XgX6+453CjKFVolTjX3S1OCZ7B3Y7?=
 =?us-ascii?Q?eGZHZ1TN9KOemff6Q0j0QOa0NxCyqvAoEkgHanvwekT1tGhXIg+BWAncmJcQ?=
 =?us-ascii?Q?bdkmLjuNlpJV7cupD3N93nbDyTeIoGYAJLJBMLsgpJIeUSmb3+3tgvb3WXdy?=
 =?us-ascii?Q?kq9mbnNbMxY90MjwY4owr6PgIMMjpYtPINLGRXvGMCffxb8/FFhD+XF1sKCA?=
 =?us-ascii?Q?IsNCCm1qU+OqdBLrsb4ATtFo6h7G0lR4bGlabVUUdAQayjgj0K3x1JqZXXl8?=
 =?us-ascii?Q?F6R8xxli0A8s+z9fC/GK6Zh+byM85tqLg+hgSedXcaJGypvkRWD63clZUWos?=
 =?us-ascii?Q?jcwuflV9r8RgAVM//TTIhHrz2T5e8NC64QfSWggAdTygoNBqCbkvQjZMf+yw?=
 =?us-ascii?Q?QDSLKtg/grkACwRoNQHoRWMeucZXgNh0Gi2IurEUGtR+MmQDt5N4RxnW4tUI?=
 =?us-ascii?Q?4YOfD1Lq40fncH07ogY9QG7FogRK/0yFO8BUDQs9bA0LnnJZQO5UTNqF5gMs?=
 =?us-ascii?Q?O/0POsop1kNkH6Lh9IZm4lZLV46lqTC/E3Prze/89mGcWsmsaPFA4sbMerTE?=
 =?us-ascii?Q?H0Vd1RsHwq2vxg/WIdzbtBba1cUYqm+HpIw0trdw3aZS77hPobGJFvKRiDTj?=
 =?us-ascii?Q?5lOoRHf7pBEvQ7EuIpn3Fdcm23VpDxNofiW5FRQke6ZoIy+L7xrpf+emrhRW?=
 =?us-ascii?Q?MGWTC099i7+IOOpxq5BqrSrmZ2knAKinMynMjULyZ7ZRz0au4Z513Dd2EhCy?=
 =?us-ascii?Q?h2cDwDFYtf6d895sJIW/1TKLga9HI9XUkc37zT+Zne3QZ9Z62OC52S7Knnun?=
 =?us-ascii?Q?quywR/KXJdMhfhvuBwZd3wR5DqGGBSnI189VRwEzWd+8TXFrQMoxW+V+sbe7?=
 =?us-ascii?Q?/A+3X6ytRWBgjBNBYXMeUIVA7jxl8ubNTx2wOTHA162Wx5OL78Mb+5hgg9og?=
 =?us-ascii?Q?/qbboZVC4KC9OYz6SdlxgdA8e2fCUnpgfcfmgjLT7qOc/3DaRhskDjDJL1oZ?=
 =?us-ascii?Q?+94drVjh2wcMnYLfTBRUqVrzewPcLqGsiO8+pcR7JyeYYFrjfSN6zmlnrrJf?=
 =?us-ascii?Q?kxReFByx4T6kD6yRZjMEZYQSGWYLMuOo0U/ULaFlkwIY0rN2+TfCBOw7TMsH?=
 =?us-ascii?Q?IK3TYydW7w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ca2093d6-ac59-4dc1-fbd4-08de442c797d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Dec 2025 03:11:34.1641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MkFWRJEkxi3ej6lIfXGJPTm1kRBw5JM7HXJ5WobAxhgrINuh4hOnwZsONaAo8ReuagdO0RbtlSIgKOdYEkUseA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6041
X-OriginatorOrg: intel.com

On Fri, Dec 26, 2025 at 10:48:03AM +0800, Yan Zhao wrote:
> > @@ -842,47 +881,38 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> >  	if (!file)
> >  		return -EFAULT;
> >  
> > -	filemap_invalidate_lock(file->f_mapping);
> > -
> >  	npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
> >  	for (i = 0; i < npages; i++) {
> > -		struct folio *folio;
> > -		gfn_t gfn = start_gfn + i;
> > -		pgoff_t index = kvm_gmem_get_index(slot, gfn);
> > -		kvm_pfn_t pfn;
> > +		struct page *src_page = NULL;
> > +		void __user *p;
> >  
> >  		if (signal_pending(current)) {
> >  			ret = -EINTR;
> >  			break;
> >  		}
> >  
> > -		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, NULL);
> > -		if (IS_ERR(folio)) {
> > -			ret = PTR_ERR(folio);
> > -			break;
> > -		}
> > +		p = src ? src + i * PAGE_SIZE : NULL;
> >  
> > -		folio_unlock(folio);
> > +		if (p) {
> > +			ret = get_user_pages_fast((unsigned long)p, 1, 0, &src_page);
> > +			if (ret < 0)
> > +				break;
> > +			if (ret != 1) {
> Put pages in this case? e.g.,
> 
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -1645,6 +1645,9 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>                         if (ret < 0)
>                                 break;
>                         if (ret != 1) {
> +                               while (ret--)
Oops. Need to check if ret == 0, and looks put_page() is not required in this
case given nr_pages == 1.
So, please ignore this comment.
> +                                       put_page(src_page++);
> +
>                                 ret = -ENOMEM;
>                                 break;
>                         }
> 
> 
> 
> 
> > +				ret = -ENOMEM;
> > +				break;
> > +			}
> > +		}
> >  
> > -		ret = -EINVAL;
> > -		if (!kvm_range_has_memory_attributes(kvm, gfn, gfn + 1,
> > -						     KVM_MEMORY_ATTRIBUTE_PRIVATE,
> > -						     KVM_MEMORY_ATTRIBUTE_PRIVATE))
> > -			goto put_folio_and_exit;
> > +		ret = __kvm_gmem_populate(kvm, slot, file, start_gfn + i, src_page,
> > +					  post_populate, opaque);
> >  
> > -		p = src ? src + i * PAGE_SIZE : NULL;
> > -		ret = post_populate(kvm, gfn, pfn, p, opaque);
> > -		if (!ret)
> > -			folio_mark_uptodate(folio);
> > +		if (src_page)
> > +			put_page(src_page);
> >  
> > -put_folio_and_exit:
> > -		folio_put(folio);
> >  		if (ret)
> >  			break;
> >  	}
> >  
> > -	filemap_invalidate_unlock(file->f_mapping);
> > -
> >  	return ret && !i ? ret : i;
> >  }
> >  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_populate);
> > -- 
> > 2.25.1
> > 

