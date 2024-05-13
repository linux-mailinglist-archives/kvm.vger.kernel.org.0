Return-Path: <kvm+bounces-17301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56D868C3BBF
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 09:12:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 794D41C21013
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 07:12:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0215146A7E;
	Mon, 13 May 2024 07:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bpHjqgIg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA0E1FA1;
	Mon, 13 May 2024 07:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715584343; cv=fail; b=QpiGoWI0Q1E3BA300LcGtaDJ8oo9CAriacstu2aGb1f2FktdUEikQlMAPhbjDDXiHt/yiH3+kPUSxPMYyHZ3ufNptI67DlAFOUp55SO4HrqS/71QoaHkW2bRDJ6GsRxPiC29IQGnY+tOzSSrrTZwVNxJkyNd46l2BsPODFFOLVU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715584343; c=relaxed/simple;
	bh=g4jTQSl9o2kyZtS2VqqfNL3GTR1qnrXWhJz6lnn2jRA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OjHMmWgbXrtgOTgBwj4F1G5cj8vspRtN8dgnFXuaafhCtjsUy6VvmCoDsQ581Y/pY1mtUlQHNJAEp/7KspeFIP0g1kC6+m3YVx2xlBtppDWUb+hdiDSiE5dFJ32B046130SHgW7bNII0oUAOQLIS5OUk8uHtihCBUfijLyNmU1s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bpHjqgIg; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715584341; x=1747120341;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=g4jTQSl9o2kyZtS2VqqfNL3GTR1qnrXWhJz6lnn2jRA=;
  b=bpHjqgIgq0suSVRK5wcaTJzoGwM4OW4ZgOKnWjhzmsAJIE3EQKO/BUCL
   VW7CZD0IHjvRtCE4fN2zblntyO/V18ClkjOGuKArzlh7bkAGTrSnr7iWZ
   2fKBjAD8/8l7IP8ICgC3jXEcxdo0Ibzt9MrAwuCFgdKUGqYwfnyGRUsu9
   bbBRHn1O7zkBWfRyAwRYoOqhgpj+ylA6m3297dfJmIapjfphVwZGigPAs
   iEfibQXU/elTIClhOoPpm//qN6vhVCr00kmM5r0tmpsKUO+qpgxlzm0Xo
   leqy7unIchrxgswYrrunEpH/V8WTF58Z6z50EqmA6E2+CEk0nzJtUywrt
   w==;
X-CSE-ConnectionGUID: 76oyckuXQrOx2TiXJGY0xA==
X-CSE-MsgGUID: uGIFsKPSQKWoQngaNKgQZg==
X-IronPort-AV: E=McAfee;i="6600,9927,11071"; a="36881799"
X-IronPort-AV: E=Sophos;i="6.08,157,1712646000"; 
   d="scan'208";a="36881799"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2024 00:12:20 -0700
X-CSE-ConnectionGUID: g4iAOVXwSZu/Tg56GucNaw==
X-CSE-MsgGUID: yJnyx56dTUOXqiBXRE3oRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,157,1712646000"; 
   d="scan'208";a="30356838"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 May 2024 00:12:21 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 13 May 2024 00:12:19 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 13 May 2024 00:12:19 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 13 May 2024 00:12:19 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 13 May 2024 00:12:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LvW9RCEQcoBRY2iBaZg8nj9c7LPUerShnrLJ5iYyfyVwghrPvrEKkq62/RlMMW6zsaY9PnaYwS6dWUI3WQdQJi6OlY8VwTqFTLWIcWEIUfwiYek7Eq5kcAcNFcGuQLzmZGxQX5SkwTHjVDJJ064/svc8sJ1HjDpB1rsfee1A8+AY3DyY8s8OBrMfYUt0kNiN6mw5KOT6zJrGTlX4w3Z9nUp+NaHSXEm+RiP7Espr7i2as/B5OpH/KMQxm+gkP2twUC3WmZ1byZ1r9YurYm9PeuHtnFxsTGRz2GOJL8T/Q/BJpXhPAutGnnj+zwiIxkP/p70U/Ajhu5bbMyPMES/crg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qUOK20ehZIVg+D9/Ug6FPsZZtwI+jYVASS+zwZSiOwE=;
 b=KqcdFTseEtXxjWXv/34sS6e3T1UQCppjE9DYdyIs9OoVXUKcMz8Yu+TZeDY6eRd53N8dULRZmlc/fR4e8qHQ72N3VkKKErqd5+g5wLWuQ9NQkoPvmT3mfAGGbzXZlv8i5S8SkUv/RM9fsKtrxLCVEsMTv3/PezC1z2prWECv99vfDKWG7UY6turU8FKku1RZZw81drU26LWgy78GMEBRuvP0K+MGOSMfQNlysfAJUhkrXL3/nRy5LwsBZY++h3H4UI/d4Rcl+uXLw4Tnf1/pR6qH4QUWp619Vx4/rHLuOF7jJ833XBJQyySzWIEM3RRZnfY+30hZoh0yhKa1B4re1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA1PR11MB6686.namprd11.prod.outlook.com (2603:10b6:806:259::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Mon, 13 May
 2024 07:12:17 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7544.052; Mon, 13 May 2024
 07:12:17 +0000
Date: Mon, 13 May 2024 15:11:28 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<jgg@nvidia.com>, <kevin.tian@intel.com>, <iommu@lists.linux.dev>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <dave.hansen@linux.intel.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>, <corbet@lwn.net>,
	<joro@8bytes.org>, <will@kernel.org>, <robin.murphy@arm.com>,
	<baolu.lu@linux.intel.com>, <yi.l.liu@intel.com>
Subject: Re: [PATCH 4/5] vfio/type1: Flush CPU caches on DMA pages in
 non-coherent domains
Message-ID: <ZkG9IEQwi7HG3YBk@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
 <20240507062138.20465-1-yan.y.zhao@intel.com>
 <20240509121049.58238a6f.alex.williamson@redhat.com>
 <Zj33cUe7HYOIfj5N@yzhao56-desk.sh.intel.com>
 <20240510105728.76d97bbb.alex.williamson@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240510105728.76d97bbb.alex.williamson@redhat.com>
X-ClientProxiedBy: SI2PR02CA0019.apcprd02.prod.outlook.com
 (2603:1096:4:195::13) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA1PR11MB6686:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c660d89-547a-40d8-93ed-08dc731c05a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005|7416005;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Z+zU6f0/ex2LE/E+gP2aFML2wIDTdH7ZvIHaf36avHxdCOAhnISvPXxLjuex?=
 =?us-ascii?Q?zOc64s2OcnyAn4roTBdLq3JyJVhUl7/9dep+R+EjSFFSOQtipqJ8wWg+wgul?=
 =?us-ascii?Q?/Gz1IqA7/Lrj28p7ZZP0wcjwcjWtoITgiQ42/YlSSirxAdzFbns8VrR0qr9u?=
 =?us-ascii?Q?9x0VMqkzvCqSjtIR4Q8JphOzzPQdsyI0AS5HViA433wo+aODPh/S01ZSSlzZ?=
 =?us-ascii?Q?9GYkFpWQCdzs48uI+NgwOvGr+PhS0r9/GCyXkhqOmCjQeqK5mPDERdSWWt97?=
 =?us-ascii?Q?CQw3taEL0Wj4M++fYCN28K7qD+50RplkvtClMQ2guzCOkmpwIUS8AobQfkMI?=
 =?us-ascii?Q?1ery4iy78/I+s/GwSS9mHz4F5xABNWIIp1XQSlceAp0e+A93J3ju+ds453wH?=
 =?us-ascii?Q?pA9RSwCzqXXSN2JFZuGirT9tAX9NGb9nNhHGkksNw+wBgZ2NaJxvjJfX2CAL?=
 =?us-ascii?Q?ODzZhyml3W2w+l12Oql+rr9hF1PBt25MwxYWxn51Chyxkn81jnhSzYteMMgH?=
 =?us-ascii?Q?HFcJ9HMjlrmj3NIP+w878VxikWadXIr2J3NbPKQ5sM5uBxJVq15EUUP8Ta45?=
 =?us-ascii?Q?ETIcQjMmLJ2U0oBuzmL+8YyprzPWYLDpgq5U1kfhw8BUVZCDz7fqZpYpcG52?=
 =?us-ascii?Q?xKdyP7bVorfa7o1pcLwjDxzCGIP+HDBAAoDM13fUhLdQsrPfUJoeLAWgQQ8k?=
 =?us-ascii?Q?WwwvqhchPv8OkWhmhFKheLtMlAaQMs3lgtN+a1TQTjcRtQdbc+7nwSqambBW?=
 =?us-ascii?Q?AEJgR1K0P0fT8Qhs+qHEo3+wxI9JaLWS/gU0jn+5ydpKOcHvMcR3Xt1wLsOu?=
 =?us-ascii?Q?4M5QzeHDou5sxmdGxrhWksvP2wv2Mk9Q9wJSXrJLYl1YVD0Jn1lBq06PATpw?=
 =?us-ascii?Q?N5dCmWrBIFw8wMub2JNyRd96lDrJfg9gY/me9k3vO4uFSBHjUNjF7dNb8b4a?=
 =?us-ascii?Q?RhTpafr3Whz/0/hG8L/1kmkWq2tyi+Ua+NtdvGIaMVlIsT8HC8Mh15hmgopf?=
 =?us-ascii?Q?UIZwct16XJ7oWjsGdriygRovkwJM/d0GbbD+nUaaG3eZXjqJ1gELyxt6bqtZ?=
 =?us-ascii?Q?zVaYFHhX05ex8XDRfzDmH2XpuvQe5H3nEWQjncNo8xO5KAQSJd+nf+bbZa3n?=
 =?us-ascii?Q?vxRvngQ6DMcrCxvm7Bdfq1oM76SDXvf2JjArvmvQV9UgBnIGzfXI1di9BCSl?=
 =?us-ascii?Q?PpBgeC1ZBLFXYVSHV1mvRHs+dM0Sxlm3eVv4VajohbKaYU6t2CIh9XN5l940?=
 =?us-ascii?Q?9tbKfxY68V/Bg2/Uq/heOFAXA2t6S505JZ8K3IGLiA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?apzKKPjd4V5ObrWPEdz3JPa04iu2C9Qj9WDeD9ytdDxPx08/9DKDR4x+oR3S?=
 =?us-ascii?Q?QnhXIli58xjudfrzEBYixRvxWggs8hDmGF29KDINmvRc+lDCiE2Z/P/QtmjL?=
 =?us-ascii?Q?eSKssYKvzAL3arvqIA4oivqqVoWadQxnOftxXo+JQCgS9gb1bU3AJzUYGfGf?=
 =?us-ascii?Q?ufFJpkl2wEGIBbm9QhjC7pC9z4xhiFsQEInTTCzrxNtiAOKqPhmICyLYX43T?=
 =?us-ascii?Q?hJdv+rOQTgLyaDRHJhZsdZjAZk2cxZcOePEMmjQKnNHmC+ETET1Nwhgcmi6q?=
 =?us-ascii?Q?UoTkm3ortByy5wO2q8orqoMgX/3WhfW2oJV0UKOzN8LNGAE4B6LHVl1dzbtA?=
 =?us-ascii?Q?y62PQiB8CPvLeyvcKzvnoHWLu5SCgVKbx01TlaXXu1E+uYdBcVmYxUdRAyO9?=
 =?us-ascii?Q?BY7ReDfl4BBD9yRBitb4DebJBFAMdR6ov3gXG//Ek88jidqkinO67XbiWWdk?=
 =?us-ascii?Q?wfmRMD1vDOtG/FBwVHi5EYuKTE8X1SpSm8aNkaZIIkU5WHho+Zo/OwKTBr0O?=
 =?us-ascii?Q?jwOzH0K4LXJA6jZdlbEuaVRPLI74de3pNUH7fkz3J7YEsjI6VlrwTTGR1w2Z?=
 =?us-ascii?Q?iVAIp+L01wCtzicYaAIY2wjGZQz6DOjl8EsG1Qmog0bLRL3l8slfs5Zl1J0K?=
 =?us-ascii?Q?QtVk58O9mw0tVfuJ3ci8nAYKaw1Ly+Itnxp3JDip6VKD2BnpST2CpF0YpLA8?=
 =?us-ascii?Q?Bs/S4VnLBfWX90rYK7wNWjUN0OWu9N9VMn3ky4YAzlsa9lrzxs0+zoxbmUcW?=
 =?us-ascii?Q?UAhCVhsjKzsR7lI98yEJORmUQ0mc/PMDwYQPzvsmRDTX/I3IPmYBnbd334Ca?=
 =?us-ascii?Q?rN6kE/gjlRCJ+xrcUtvIhPAlVNnXvOrzIrV5ZgPCDbI7+hULUDJwBT90nLpH?=
 =?us-ascii?Q?c/8lfqpoF4nxIUFV6k5B5AsRUriuB3TPb01tst853u4TFDpG+UdaUmknp9X7?=
 =?us-ascii?Q?zx27T3tBFgSH9g/526rMVg5bmyw0kn+p1X1qI69gJyG9b/DUSrWvsBxHoznP?=
 =?us-ascii?Q?TxqrzXhLq6PJAz9KMDpNsIuCD2XHDbxhQ1btyv35V142ushfQvMxH6X4ixNd?=
 =?us-ascii?Q?ZFFIcY4YnipIyauVGqMwFIzNoK87fbqKvB6VFAuGYsbt1Oggoa2F1bimvdWy?=
 =?us-ascii?Q?htOIFvww3dOIqHYUTXadXICA7zrMA/NF7+JYJrcFnHH/9MrPQshMBngJB2Hc?=
 =?us-ascii?Q?oe6OkYa7aQAWCoEUlZksBRQ8DD+GVvWLTXrWOKMDJ3d/UXJgHaChELojmW8O?=
 =?us-ascii?Q?7JcyeBSgNhtf0Xe+svv7iculX+hupjWT1Un3rOJnWfW8CCqB45GYhko42lFN?=
 =?us-ascii?Q?n6U6cdZzV7swgE/7jgKaqgelxXShBfmfYMtaG+gzJCdKVwEpGv2YZF7ahUF+?=
 =?us-ascii?Q?6Puh6mfeuPwJPDZVOQOhr+dXfiUYg8iRjFluxVv7Isv2LWRh3tTao89+dcmB?=
 =?us-ascii?Q?WNMu0Inz5Yv3cHppY6nrnoq5v+EmLEpbTKXUWGIMpApJuqF7qNj/neGcdjqx?=
 =?us-ascii?Q?XgcoIghxRDtxd3Ibre9eSzpSDuI0tsynOtGspi/5EZh16UviBolzyWJxoEKV?=
 =?us-ascii?Q?3My5U/vaU91hhacxRkkCMw/opwVA9UH/qBGhUqEr?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c660d89-547a-40d8-93ed-08dc731c05a3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2024 07:12:17.3151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LMRv2SLWR6ovmiO45deBwiC1ApmuTqj+3EbkIn258nN/yzVs5N0wqQSkqIa6IqL93X8x/m6BvuP3qHOTGAjT7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6686
X-OriginatorOrg: intel.com

On Fri, May 10, 2024 at 10:57:28AM -0600, Alex Williamson wrote:
> On Fri, 10 May 2024 18:31:13 +0800
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > On Thu, May 09, 2024 at 12:10:49PM -0600, Alex Williamson wrote:
> > > On Tue,  7 May 2024 14:21:38 +0800
> > > Yan Zhao <yan.y.zhao@intel.com> wrote:  
> > ... 
> > > >  drivers/vfio/vfio_iommu_type1.c | 51 +++++++++++++++++++++++++++++++++
> > > >  1 file changed, 51 insertions(+)
> > > > 
> > > > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > > > index b5c15fe8f9fc..ce873f4220bf 100644
> > > > --- a/drivers/vfio/vfio_iommu_type1.c
> > > > +++ b/drivers/vfio/vfio_iommu_type1.c
> > > > @@ -74,6 +74,7 @@ struct vfio_iommu {
> > > >  	bool			v2;
> > > >  	bool			nesting;
> > > >  	bool			dirty_page_tracking;
> > > > +	bool			has_noncoherent_domain;
> > > >  	struct list_head	emulated_iommu_groups;
> > > >  };
> > > >  
> > > > @@ -99,6 +100,7 @@ struct vfio_dma {
> > > >  	unsigned long		*bitmap;
> > > >  	struct mm_struct	*mm;
> > > >  	size_t			locked_vm;
> > > > +	bool			cache_flush_required; /* For noncoherent domain */  
> > > 
> > > Poor packing, minimally this should be grouped with the other bools in
> > > the structure, longer term they should likely all be converted to
> > > bit fields.  
> > Yes. Will do!
> > 
> > >   
> > > >  };
> > > >  
> > > >  struct vfio_batch {
> > > > @@ -716,6 +718,9 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
> > > >  	long unlocked = 0, locked = 0;
> > > >  	long i;
> > > >  
> > > > +	if (dma->cache_flush_required)
> > > > +		arch_clean_nonsnoop_dma(pfn << PAGE_SHIFT, npage << PAGE_SHIFT);
> > > > +
> > > >  	for (i = 0; i < npage; i++, iova += PAGE_SIZE) {
> > > >  		if (put_pfn(pfn++, dma->prot)) {
> > > >  			unlocked++;
> > > > @@ -1099,6 +1104,8 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
> > > >  					    &iotlb_gather);
> > > >  	}
> > > >  
> > > > +	dma->cache_flush_required = false;
> > > > +
> > > >  	if (do_accounting) {
> > > >  		vfio_lock_acct(dma, -unlocked, true);
> > > >  		return 0;
> > > > @@ -1120,6 +1127,21 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
> > > >  	iommu->dma_avail++;
> > > >  }
> > > >  
> > > > +static void vfio_update_noncoherent_domain_state(struct vfio_iommu *iommu)
> > > > +{
> > > > +	struct vfio_domain *domain;
> > > > +	bool has_noncoherent = false;
> > > > +
> > > > +	list_for_each_entry(domain, &iommu->domain_list, next) {
> > > > +		if (domain->enforce_cache_coherency)
> > > > +			continue;
> > > > +
> > > > +		has_noncoherent = true;
> > > > +		break;
> > > > +	}
> > > > +	iommu->has_noncoherent_domain = has_noncoherent;
> > > > +}  
> > > 
> > > This should be merged with vfio_domains_have_enforce_cache_coherency()
> > > and the VFIO_DMA_CC_IOMMU extension (if we keep it, see below).  
> > Will convert it to a counter and do the merge.
> > Thanks for pointing it out!
> > 
> > >   
> > > > +
> > > >  static void vfio_update_pgsize_bitmap(struct vfio_iommu *iommu)
> > > >  {
> > > >  	struct vfio_domain *domain;
> > > > @@ -1455,6 +1477,12 @@ static int vfio_pin_map_dma(struct vfio_iommu *iommu, struct vfio_dma *dma,
> > > >  
> > > >  	vfio_batch_init(&batch);
> > > >  
> > > > +	/*
> > > > +	 * Record necessity to flush CPU cache to make sure CPU cache is flushed
> > > > +	 * for both pin & map and unmap & unpin (for unwind) paths.
> > > > +	 */
> > > > +	dma->cache_flush_required = iommu->has_noncoherent_domain;
> > > > +
> > > >  	while (size) {
> > > >  		/* Pin a contiguous chunk of memory */
> > > >  		npage = vfio_pin_pages_remote(dma, vaddr + dma->size,
> > > > @@ -1466,6 +1494,10 @@ static int vfio_pin_map_dma(struct vfio_iommu *iommu, struct vfio_dma *dma,
> > > >  			break;
> > > >  		}
> > > >  
> > > > +		if (dma->cache_flush_required)
> > > > +			arch_clean_nonsnoop_dma(pfn << PAGE_SHIFT,
> > > > +						npage << PAGE_SHIFT);
> > > > +
> > > >  		/* Map it! */
> > > >  		ret = vfio_iommu_map(iommu, iova + dma->size, pfn, npage,
> > > >  				     dma->prot);
> > > > @@ -1683,9 +1715,14 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
> > > >  	for (; n; n = rb_next(n)) {
> > > >  		struct vfio_dma *dma;
> > > >  		dma_addr_t iova;
> > > > +		bool cache_flush_required;
> > > >  
> > > >  		dma = rb_entry(n, struct vfio_dma, node);
> > > >  		iova = dma->iova;
> > > > +		cache_flush_required = !domain->enforce_cache_coherency &&
> > > > +				       !dma->cache_flush_required;
> > > > +		if (cache_flush_required)
> > > > +			dma->cache_flush_required = true;  
> > > 
> > > The variable name here isn't accurate and the logic is confusing.  If
> > > the domain does not enforce coherency and the mapping is not tagged as
> > > requiring a cache flush, then we need to mark the mapping as requiring
> > > a cache flush.  So the variable state is something more akin to
> > > set_cache_flush_required.  But all we're saving with this is a
> > > redundant set if the mapping is already tagged as requiring a cache
> > > flush, so it could really be simplified to:
> > > 
> > > 		dma->cache_flush_required = !domain->enforce_cache_coherency;  
> > Sorry about the confusion.
> > 
> > If dma->cache_flush_required is set to true by a domain not enforcing cache
> > coherency, we hope it will not be reset to false by a later attaching to domain 
> > enforcing cache coherency due to the lazily flushing design.
> 
> Right, ok, the vfio_dma objects are shared between domains so we never
> want to set 'dma->cache_flush_required = false' due to the addition of a
> 'domain->enforce_cache_coherent == true'.  So this could be:
> 
> 	if (!dma->cache_flush_required)
> 		dma->cache_flush_required = !domain->enforce_cache_coherency;

Though this code is easier for understanding, it leads to unnecessary setting of
dma->cache_flush_required to false, given domain->enforce_cache_coherency is
true at the most time.

> > > It might add more clarity to just name the mapping flag
> > > dma->mapped_noncoherent.  
> > 
> > The dma->cache_flush_required is to mark whether pages in a vfio_dma requires
> > cache flush in the subsequence mapping into the first non-coherent domain
> > and page unpinning.
> 
> How do we arrive at a sequence where we have dma->cache_flush_required
> that isn't the result of being mapped into a domain with
> !domain->enforce_cache_coherency?
Hmm, dma->cache_flush_required IS the result of being mapped into a domain with
!domain->enforce_cache_coherency.
My concern only arrives from the actual code sequence, i.e.
dma->cache_flush_required is set to true before the actual mapping.

If we rename it to dma->mapped_noncoherent and only set it to true after the
actual successful mapping, it would lead to more code to handle flushing for the
unwind case.
Currently, flush for unwind is handled centrally in vfio_unpin_pages_remote()
by checking dma->cache_flush_required, which is true even before a full
successful mapping, so we won't miss flush on any pages that are mapped into a
non-coherent domain in a short window.

> 
> It seems to me that we only get 'dma->cache_flush_required == true' as
> a result of being mapped into a 'domain->enforce_cache_coherency ==
> false' domain.  In that case the flush-on-map is handled at the time
> we're setting dma->cache_flush_required and what we're actually
> tracking with the flag is that the dma object has been mapped into a
> noncoherent domain.
> 
> > So, mapped_noncoherent may not be accurate.
> > Do you think it's better to put a comment for explanation? 
> > 
> > struct vfio_dma {
> >         ...    
> >         bool                    iommu_mapped;
> >         bool                    lock_cap;       /* capable(CAP_IPC_LOCK) */
> >         bool                    vaddr_invalid;
> >         /*
> >          *  Mark whether it is required to flush CPU caches when mapping pages
> >          *  of the vfio_dma to the first non-coherent domain and when unpinning
> >          *  pages of the vfio_dma
> >          */
> >         bool                    cache_flush_required;
> >         ...    
> > };
> > >   
> > > >  
> > > >  		while (iova < dma->iova + dma->size) {
> > > >  			phys_addr_t phys;
> > > > @@ -1737,6 +1774,9 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
> > > >  				size = npage << PAGE_SHIFT;
> > > >  			}
> > > >  
> > > > +			if (cache_flush_required)
> > > > +				arch_clean_nonsnoop_dma(phys, size);
> > > > +  
> > > 
> > > I agree with others as well that this arch callback should be named
> > > something relative to the cache-flush/write-back operation that it
> > > actually performs instead of the overall reason for us requiring it.
> > >  
> > Ok. If there are no objections, I'll rename it to arch_flush_cache_phys() as
> > suggested by Kevin.
> 
> Yes, better.
> 
> > > >  			ret = iommu_map(domain->domain, iova, phys, size,
> > > >  					dma->prot | IOMMU_CACHE,
> > > >  					GFP_KERNEL_ACCOUNT);
> > > > @@ -1801,6 +1841,7 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
> > > >  			vfio_unpin_pages_remote(dma, iova, phys >> PAGE_SHIFT,
> > > >  						size >> PAGE_SHIFT, true);
> > > >  		}
> > > > +		dma->cache_flush_required = false;
> > > >  	}
> > > >  
> > > >  	vfio_batch_fini(&batch);
> > > > @@ -1828,6 +1869,9 @@ static void vfio_test_domain_fgsp(struct vfio_domain *domain, struct list_head *
> > > >  	if (!pages)
> > > >  		return;
> > > >  
> > > > +	if (!domain->enforce_cache_coherency)
> > > > +		arch_clean_nonsnoop_dma(page_to_phys(pages), PAGE_SIZE * 2);
> > > > +
> > > >  	list_for_each_entry(region, regions, list) {
> > > >  		start = ALIGN(region->start, PAGE_SIZE * 2);
> > > >  		if (start >= region->end || (region->end - start < PAGE_SIZE * 2))
> > > > @@ -1847,6 +1891,9 @@ static void vfio_test_domain_fgsp(struct vfio_domain *domain, struct list_head *
> > > >  		break;
> > > >  	}
> > > >  
> > > > +	if (!domain->enforce_cache_coherency)
> > > > +		arch_clean_nonsnoop_dma(page_to_phys(pages), PAGE_SIZE * 2);
> > > > +  
> > > 
> > > Seems like this use case isn't subject to the unmap aspect since these
> > > are kernel allocated and freed pages rather than userspace pages.
> > > There's not an "ongoing use of the page" concern.
> > > 
> > > The window of opportunity for a device to discover and exploit the
> > > mapping side issue appears almost impossibly small.
> > >  
> > The concern is for a malicious device attempting DMAs automatically.
> > Do you think this concern is valid?
> > As there're only extra flushes for 4 pages, what about keeping it for safety?
> 
> Userspace doesn't know anything about these mappings, so to exploit
> them the device would somehow need to discover and interact with the
> mapping in the split second that the mapping exists, without exposing
> itself with mapping faults at the IOMMU.
> 
> I don't mind keeping the flush before map so that infinitesimal gap
> where previous data in physical memory exposed to the device is closed,
> but I have a much harder time seeing that the flush on unmap to
> synchronize physical memory is required.
> 
> For example, the potential KSM use case doesn't exist since the pages
> are not owned by the user.  Any subsequent use of the pages would be
> subject to the same condition we assumed after allocation, where the
> physical data may be inconsistent with the cached data.  It's easy to
> flush 2 pages, but I think it obscures the function of the flush if we
> can't articulate the value in this case.
>
I agree the second flush is not necessary if we are confident that functions in
between the two flushes do not and will not touch the page in CPU side.
However, can we guarantee this? For instance, is it possible for some IOMMU
driver to read/write the page for some quirks? (Or is it just a totally
paranoid?)
If that's not impossible, then ensuring cache and memory coherency before
page reclaiming is better?

> 
> > > >  	__free_pages(pages, order);
> > > >  }
> > > >  
> > > > @@ -2308,6 +2355,8 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
> > > >  
> > > >  	list_add(&domain->next, &iommu->domain_list);
> > > >  	vfio_update_pgsize_bitmap(iommu);
> > > > +	if (!domain->enforce_cache_coherency)
> > > > +		vfio_update_noncoherent_domain_state(iommu);  
> > > 
> > > Why isn't this simply:
> > > 
> > > 	if (!domain->enforce_cache_coherency)
> > > 		iommu->has_noncoherent_domain = true;  
> > Yes, it's simpler during attach.
> > 
> > > Or maybe:
> > > 
> > > 	if (!domain->enforce_cache_coherency)
> > > 		iommu->noncoherent_domains++;  
> > Yes, this counter is better.
> > I previously thought a bool can save some space.
> > 
> > > >  done:
> > > >  	/* Delete the old one and insert new iova list */
> > > >  	vfio_iommu_iova_insert_copy(iommu, &iova_copy);
> > > > @@ -2508,6 +2557,8 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
> > > >  			}
> > > >  			iommu_domain_free(domain->domain);
> > > >  			list_del(&domain->next);
> > > > +			if (!domain->enforce_cache_coherency)
> > > > +				vfio_update_noncoherent_domain_state(iommu);  
> > > 
> > > If we were to just track the number of noncoherent domains, this could
> > > simply be iommu->noncoherent_domains-- and VFIO_DMA_CC_DMA could be:
> > > 
> > > 	return iommu->noncoherent_domains ? 1 : 0;
> > > 
> > > Maybe there should be wrappers for list_add() and list_del() relative
> > > to the iommu domain list to make it just be a counter.  Thanks,  
> > 
> > Do you think we can skip the "iommu->noncoherent_domains--" in
> > vfio_iommu_type1_release() when iommu is about to be freed.
> > 
> > Asking that is also because it's hard for me to find a good name for the wrapper
> > around list_del().  :)
> 
> vfio_iommu_link_domain(), vfio_iommu_unlink_domain()?

Ah, this is a good name!

> > 
> > It follows vfio_release_domain() in vfio_iommu_type1_release(), but not in
> > vfio_iommu_type1_detach_group().
> 
> I'm not sure I understand the concern here, detach_group is performed
> under the iommu->lock where the value of iommu->noncohernet_domains is
> only guaranteed while this lock is held.  In the release callback the
> iommu->lock is not held, but we have no external users at this point.
> It's not strictly required that we decrement each domain, but it's also
> not a bad sanity test that iommu->noncoherent_domains should be zero
> after unlinking the domains.  Thanks,
I previously thought I couldn't find a name for a domain operation that's
called after vfio_release_domain(), and I couldn't merge list_del() into
vfio_release_domain() given it's not in vfio_iommu_type1_detach_group().

But vfio_iommu_unlink_domain() is a good one.
I'll rename list_del() to vfio_iommu_unlink_domain().

Thanks!
Yan


