Return-Path: <kvm+bounces-63810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 387C0C73158
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 10:19:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id 6656F2F771
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 09:14:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B90553093C7;
	Thu, 20 Nov 2025 09:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kevZwi5q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84C430EF74;
	Thu, 20 Nov 2025 09:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763630052; cv=fail; b=B4lXXrf+rgvLlBxJxt398U4GbZaACMvl1MPOYI46yW1TqwrsaP92eTnzFTG4Jsl5vhifbLvTS7wDay1mzg8TveOz15ezA9PlFhsnribZ/9lTTk6fF9bnKHCQaUxzYV4db+MpjsaAMvCWwIuMBsiVKtMJKZnBIbkGvNSjCKxaYfk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763630052; c=relaxed/simple;
	bh=5l8BnWOXtacmxlwDTKfrELUwoH1t92ncLFM72ska2Yo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=oJiervIT5gnHTum0EO3B0GXpzkZk6LhgEHHI8oJdDZgxXsviqJu7gCFos0/ebQsVhQZ50xMrgcoNAB3j+ls7ERyBS4pHjZuIzlrQt0DrIvZdEkqpx4AfUbZfwpixeeGzpimperdlrvNkPjBaezj70Iz5pni8YKESSOyQDJpJBW0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kevZwi5q; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763630051; x=1795166051;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=5l8BnWOXtacmxlwDTKfrELUwoH1t92ncLFM72ska2Yo=;
  b=kevZwi5q82h67SBat7Fxd/cs4HLgLtNjBTeLQMtzXU5NgLhdfFhWJrOa
   LLAto345UqhFuH4hUIkn5R3A+c8Qo4esD4m9yAaV+Xo/sREp2r75FwItC
   5YmHrEi8A1OYFZ/gD9HQN8YAqN7m8ytwE0U5y9fmVoQinpeWe23m3q8Us
   WfVi/LBH/zis+muOCxNOauAwudJJneWxt1hjorsa1yuUHq3vEb31bCJbZ
   Umrkh6ExnPobjXXEQUtGk5l1qwWR4ARo5MJad+fB8PiHWCkX0ajZ4NeLP
   3i6Ch2ebWS8xmYmmlc4KiXPqJxip4p2R21k2ThLLM7KAvcYnNfAUBe8le
   A==;
X-CSE-ConnectionGUID: PlXm+sukRFSckAMwfD0Jtw==
X-CSE-MsgGUID: NJ2wduzPRAeLQx7LrKvyXA==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="69561193"
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="69561193"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 01:14:05 -0800
X-CSE-ConnectionGUID: /joUznwSSSan2x9Z5xXjOQ==
X-CSE-MsgGUID: LES8P0gDSIyNDHwfoV8Ung==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="196276673"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 01:14:05 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 01:14:05 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 20 Nov 2025 01:14:05 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.13) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 01:14:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r6BtW4/rZbCqwYjzv6lybFkYk/+EjbLc35zLHpewhUCkQlOFuAVGUhSBQQO4IIDhnXFyKg+PWWJ2VF9hnph4jzvvc3+lUN5qLOOUFS0GEIUlO5UPdyXjpufJJLrMUNBge6p182TYOxIhlc7IWp0y5to4mzcbWU6ipUgwuo12f4t1jKnxqt8S+bwwm8em9N/QE/1QbSVbNX/ruOjT27dE8HG0l5T+N7RV2EwJf/JQg6hP4fhn7iqPZ6mQYL9CueSYoqsu+KL+YY5SZR5Y1L8MgkrHCiEEY7c65MM6Ekjof7FBkUGl3Os0OBUxLLGrI5ps3w2QrgQOM5huXPguclI2+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OBRysHQH3WGsgjFZRo+IWfOu7o4Gy8zU6lkM7lRu/i8=;
 b=Fxy4ndJzTUc/dhoaYNcIGMWyUXvyrAkfADPCGkzzyLhGMAkDD1uTUBjVWzrmPnDo/GYl7b4vksH6ZKAiaKlgDW1fL28WwMdxDZXE1xqY2ZmIqsI0c3IqeXtVOPH+1LzMxi0SQciSraLEfcGj7R9OPEjaB/3rPvD/+5FunR+Filf989drvK9KW2nlkMEBzkx7vt+03seIxOgtbTCYq7XdSnDhpMzoKxUMMBV8L6Nk+EzTTf5O3cgqPZ/I8w8zp6owJCSR6+ZdCR7xmP8Bj1KTKvF+Yd/8QnimAy8Q4b5tX7j7z0XqO/9Qcah46dat3no+woQSoqTI5+ThJqmXzcmIfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB8551.namprd11.prod.outlook.com (2603:10b6:510:30d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 09:14:00 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 09:13:59 +0000
Date: Thu, 20 Nov 2025 17:11:48 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Michael Roth <michael.roth@amd.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>
Subject: Re: [PATCH 3/3] KVM: guest_memfd: GUP source pages prior to
 populating guest memory
Message-ID: <aR7bVKzM7rH/FSVh@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20251113230759.1562024-1-michael.roth@amd.com>
 <20251113230759.1562024-4-michael.roth@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251113230759.1562024-4-michael.roth@amd.com>
X-ClientProxiedBy: SI2PR02CA0003.apcprd02.prod.outlook.com
 (2603:1096:4:194::13) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB8551:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b79caa4-c8ec-4438-4bac-08de281523fb
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?jAQytdq9InJiVQR3nk+lLkcejg23Aeb/vqamWb2k7/w97J4+KQ6R9sqUwRju?=
 =?us-ascii?Q?Rk+yJyS4eTqRLQN3O/UGQyvSS38UWsGMkABJ8IlmHLSV+A6Y4LCDXsCVZN6F?=
 =?us-ascii?Q?JzErzKgjgNw30laREwn+Wz8Uun6ItpYfqLLLgX6mEfMKr+k63ByOgRY8Puj3?=
 =?us-ascii?Q?9fW4Gdn2uHwzkg8sgwfzb9w0n/NGkxmBKqL0K6LwYQnPeNynL8D/5phgPN4p?=
 =?us-ascii?Q?4cLDF5b4KCESYd3AUZipeUjNBPrAc2UbSjmWwuJZhLESF+W88ucQRgY2eK8L?=
 =?us-ascii?Q?DthxpKZBtw65Bs5X1nG4o+73zAf2J7/04NkbFJtoP/bdC2p8dY5+TRvHSTaw?=
 =?us-ascii?Q?LsFNQ9ncA80rsSODF4g2sYpNuI2+SkucNQ6pBB+Y4Vfhh1voFpCL027mR4U1?=
 =?us-ascii?Q?+1LnxqY+0s6nqTFE7pcpg4OSI5Hym64VRKzCasfU7v0kM7HJVBtiPKtwL+rP?=
 =?us-ascii?Q?sz6wGoLjoDFKg/n1dBZSFZwMvrw5XRsrGHWqmsuZfHGEfmzPImK/f/C7d3N5?=
 =?us-ascii?Q?jkp4U93IaSGKb70QpjOnRoCJx6UA70G3SL9vExMlTZlQUZjQRu1tCHqQTRsX?=
 =?us-ascii?Q?wcE8E/7DDE/s5dDZUBx9/aOa5rOwIL5w9Zi+dRtS7BEiJCFuShLuCpwNYKZY?=
 =?us-ascii?Q?FtCzcT95U0w1qpHgnktiYgwBM962sKZ3u+gqKf+OCg4fZYt701KtNeDS3mWM?=
 =?us-ascii?Q?2Z4iXO+AjrX48QiXpXqCvq7BE9QkUPxtgbmBJZPCCcY0vtulq49p7tFtvY6Q?=
 =?us-ascii?Q?wv3gaKOsMvV9V5XN8o4ie0wTJeunnnXgvjnVoIRopPCHvazrHOU60VckLCzv?=
 =?us-ascii?Q?DRnVolqpXi7+OgbkC9BEQAWQckEXNGbhRaWioyZR0qmNe6LnLT5Aj501BEFP?=
 =?us-ascii?Q?C5e+kGQ/YS9ELPfn42iHxTm/U7rH4CvUZIhrI8Mt3X2N7S+4pqQhfr1mgBLv?=
 =?us-ascii?Q?n4vZ1cA1ccRX/XWAx3hA49nF6Ne3mWetW8c4CmXSZsuW+rqnpJqAASlAsA03?=
 =?us-ascii?Q?tZilJSdnajiZDgNgWKxJu4m8fEr1bUmqH4X/Qw0aJ1bOu+po5cRDe0F02LXC?=
 =?us-ascii?Q?4NcJyf3CbVJDVAX6UD6v4gU3HWQAHYb9ry4dISxZsV749GwsewxHiVvFKU/R?=
 =?us-ascii?Q?8/iyl6DreQ/LPKUdH920Z3kDawO5IfroJIwftRq0DqB8OqY+pP/ASnp6k6P1?=
 =?us-ascii?Q?xByRfGqFyDGEm6nB9ZPAB+VHFPESSwqGwN+ESb+nY9G3P4u/P/Hnxrk12E7y?=
 =?us-ascii?Q?B63vtvRLJOrDwGEvTDWcaE0G+JjZsn1eCXY9OSqvXkTtfiWDzPZSRTQ9pUvf?=
 =?us-ascii?Q?2RbozYoWGOgVqn9s36PyM4B9L1pdkBgE20Pcaw+sk5vAc/aBIInUWa21DSh3?=
 =?us-ascii?Q?bZdgOGLeL47fCY8/hh1yM3/YvOOwxQDq/HfbtBEN4O1AioKske6BvzpVSd2I?=
 =?us-ascii?Q?4d7GElcNgBpJLUi//igU0enBeviCPh3JCDtbxUXMLoM68XMD4I4UUA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JW8uCcQYGn4t457csJL+pMQXNzTyTkdY9LnTBTtSrMoeR1eUdRh4sP4Q3RzH?=
 =?us-ascii?Q?bg9wuiVg6WeqSF0///ux0s8dYVEmSdwqIvCQhOaMhc6nXv4LpRfB0fN/XA8X?=
 =?us-ascii?Q?xlJfWU1CSFHI0dqyYL+zdapWTboh76m02mgB6oh4Uoo9r7FVu/U8PBWxPsCW?=
 =?us-ascii?Q?LJGOTXW8R8b80d/7STOxjs+yyGTdUMuobCTW7Mt0GCEB45xJeS8XbbaTiVgk?=
 =?us-ascii?Q?+Lw3AR0cm7UxjPhZdFFdUKIN3GWEpBPaLV8scZUTXDZxpekXsnSCdMt6nFGt?=
 =?us-ascii?Q?gePkbzXhUSol90BZojCAnfHxe/QBXC0VimUA0m1Vf+Lzg+ZqEsX5PS7bbm7v?=
 =?us-ascii?Q?9n3iHnETEHxBWRcRk1Wd7a62laXmptBG8l8kBoJWj+encGI59ooUAIHMgZHn?=
 =?us-ascii?Q?0/pr3CTyV5IAuwmj73C7m3hV+RglxRFsaMwlDmFR9FxtJJFF7Z8wzOnMkrto?=
 =?us-ascii?Q?ulCegpHaPZYPuU9xiyqOGdb3s6pfHPa5oQrYy0oXSVg1kjQkn7oqsuvoHpvA?=
 =?us-ascii?Q?aLqMlNZaiqEzX2WH+Ty/y2yUK5M7FVjgTjxPTv6oxMDPH/12JaUqLNdcQ7lS?=
 =?us-ascii?Q?2Dp1Xn0EFOhmkl+5nLVxEbs+YpXFpCqO56fzpsKFy34r+WWCoMoWBHXvrzHb?=
 =?us-ascii?Q?Hyx5gTd1BIgvUnURbJtNYrJNLGkbCfmNwj8PILeGoowE+PxyGRO+RBfv9Rk/?=
 =?us-ascii?Q?XMyuJgbMJSq/T+QcKHnYl9hR0uZxwHDCyqNq3xc7rjfK0x2rYjrEeudZ7M1U?=
 =?us-ascii?Q?Rj7VBMFMMEpFYpyxen0jxwBU+I11BtM2zzRRW/LFKZRbeiYdd7MljzJ8yHJF?=
 =?us-ascii?Q?/rpZpc/jbhjtZXivOUkW5rU8TnrvQpCjTkxBzoHJeL+enembDdVJSJDVSUgP?=
 =?us-ascii?Q?J4QNVzge8jK2uCFMKS8qqF90FvJYC1SPnZw84j0kyT5HqrcwBZC9QHKgq5fR?=
 =?us-ascii?Q?Sh+W7phHFoWI9nqVfIwzq872msCwBaznfL3yJ4sO6NSeKTxTVLMnMEoclJ6O?=
 =?us-ascii?Q?Bl7V6FxMlLCwBPzFeW4YzrJm0ROhXfNKeVzUGzQjWNbgb6HYRLEhpHa+6zpR?=
 =?us-ascii?Q?0pg/agKMSMF1IcP/up7flJ+jB2FKt/OrdLnt2O1WpVwj0lk0PuJLf2LcZG26?=
 =?us-ascii?Q?9B5pZbL8A1KdV3CVX/TU9ofsvquIxaTou6+Y1zm9CSJNt1sC0J11fr0BYMDv?=
 =?us-ascii?Q?vewg6S/d6klY420IvhKDN14BzqLf0d8flgDPKH8l2glEzjr8Sq/QqfC6ZCSn?=
 =?us-ascii?Q?QfzjygEpKsMYH0mIXq/VKKVNxTaX1uD1ku9LfDw0sjb8jAUZptrhNya2zs3c?=
 =?us-ascii?Q?pJz5Bp9ZdnWJTq7BMOr97MQZKHmp4uVUZdEFLYIKjugJN08QAUNEQ7B2y7Ru?=
 =?us-ascii?Q?UJfrht3MWxpKrh54KURAzeJOab+yP3ZnGFzIYFOZeBiYNYggftwyxXssoGEa?=
 =?us-ascii?Q?4ym2vc4+19eeWzwLzjymu36pBCkGKU3Q3xqzTg8Td9x3z7f9+QLOWB0Uqx3F?=
 =?us-ascii?Q?z4omEbPFoakCyY8HSbRhs1w2FWp4BM+0I4MbLVOZemoFNnQjwNfLdvwYDP3Y?=
 =?us-ascii?Q?x1AvrfhdrzOqbrctJprf3KhMGJsljGm3dAVO60dC?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b79caa4-c8ec-4438-4bac-08de281523fb
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 09:13:59.8376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: neEGQ8lOdjg469PM6Ms4uuf0VYR6PqBWeNEJrJc4ixdlh1H+jkT+8t+/h9LSmGDEmsVfWxxF+6X9QilZnaVjTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8551
X-OriginatorOrg: intel.com

On Thu, Nov 13, 2025 at 05:07:59PM -0600, Michael Roth wrote:
> Currently the post-populate callbacks handle copying source pages into
> private GPA ranges backed by guest_memfd, where kvm_gmem_populate()
> acquires the filemap invalidate lock, then calls a post-populate
> callback which may issue a get_user_pages() on the source pages prior to
> copying them into the private GPA (e.g. TDX).
> 
> This will not be compatible with in-place conversion, where the
> userspace page fault path will attempt to acquire filemap invalidate
> lock while holding the mm->mmap_lock, leading to a potential ABBA
> deadlock[1].
> 
> Address this by hoisting the GUP above the filemap invalidate lock so
> that these page faults path can be taken early, prior to acquiring the
> filemap invalidate lock.
> 
> It's not currently clear whether this issue is reachable with the
> current implementation of guest_memfd, which doesn't support in-place
> conversion, however it does provide a consistent mechanism to provide
> stable source/target PFNs to callbacks rather than punting to
> vendor-specific code, which allows for more commonality across
> architectures, which may be worthwhile even without in-place conversion.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c   | 40 ++++++++++++++++++++++++++------------
>  arch/x86/kvm/vmx/tdx.c   | 21 +++++---------------
>  include/linux/kvm_host.h |  3 ++-
>  virt/kvm/guest_memfd.c   | 42 ++++++++++++++++++++++++++++++++++------
>  4 files changed, 71 insertions(+), 35 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 0835c664fbfd..d0ac710697a2 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2260,7 +2260,8 @@ struct sev_gmem_populate_args {
>  };
>  
>  static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pfn,
> -				  void __user *src, int order, void *opaque)
> +				  struct page **src_pages, loff_t src_offset,
> +				  int order, void *opaque)
>  {
>  	struct sev_gmem_populate_args *sev_populate_args = opaque;
>  	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
> @@ -2268,7 +2269,7 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
>  	int npages = (1 << order);
>  	gfn_t gfn;
>  
> -	if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src))
> +	if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src_pages))
>  		return -EINVAL;
>  
>  	for (gfn = gfn_start, i = 0; gfn < gfn_start + npages; gfn++, i++) {
> @@ -2284,14 +2285,21 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
>  			goto err;
>  		}
>  
> -		if (src) {
> -			void *vaddr = kmap_local_pfn(pfn + i);
> +		if (src_pages) {
> +			void *src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i]));
> +			void *dst_vaddr = kmap_local_pfn(pfn + i);
>  
> -			if (copy_from_user(vaddr, src + i * PAGE_SIZE, PAGE_SIZE)) {
> -				ret = -EFAULT;
> -				goto err;
> +			memcpy(dst_vaddr, src_vaddr + src_offset, PAGE_SIZE - src_offset);
> +			kunmap_local(src_vaddr);
> +
> +			if (src_offset) {
> +				src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i + 1]));
> +
> +				memcpy(dst_vaddr + PAGE_SIZE - src_offset, src_vaddr, src_offset);
> +				kunmap_local(src_vaddr);
IIUC, src_offset is the src's offset from the first page. e.g.,
src could be 0x7fea82684100, with src_offset=0x100, while npages could be 512.

Then it looks like the two memcpy() calls here only work when npages == 1 ?

>  			}
> -			kunmap_local(vaddr);
> +
> +			kunmap_local(dst_vaddr);
>  		}
>  
>  		ret = rmp_make_private(pfn + i, gfn << PAGE_SHIFT, PG_LEVEL_4K,
> @@ -2331,12 +2339,20 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
>  	if (!snp_page_reclaim(kvm, pfn + i) &&
>  	    sev_populate_args->type == KVM_SEV_SNP_PAGE_TYPE_CPUID &&
>  	    sev_populate_args->fw_error == SEV_RET_INVALID_PARAM) {
> -		void *vaddr = kmap_local_pfn(pfn + i);
> +		void *src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i]));
> +		void *dst_vaddr = kmap_local_pfn(pfn + i);
>  
> -		if (copy_to_user(src + i * PAGE_SIZE, vaddr, PAGE_SIZE))
> -			pr_debug("Failed to write CPUID page back to userspace\n");
> +		memcpy(src_vaddr + src_offset, dst_vaddr, PAGE_SIZE - src_offset);
> +		kunmap_local(src_vaddr);
> +
> +		if (src_offset) {
> +			src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i + 1]));
> +
> +			memcpy(src_vaddr, dst_vaddr + PAGE_SIZE - src_offset, src_offset);
> +			kunmap_local(src_vaddr);
> +		}
>  
> -		kunmap_local(vaddr);
> +		kunmap_local(dst_vaddr);
>  	}
>  
>  	/* pfn + i is hypervisor-owned now, so skip below cleanup for it. */
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 57ed101a1181..dd5439ec1473 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -3115,37 +3115,26 @@ struct tdx_gmem_post_populate_arg {
>  };
>  
>  static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> -				  void __user *src, int order, void *_arg)
> +				  struct page **src_pages, loff_t src_offset,
> +				  int order, void *_arg)
>  {
>  	struct tdx_gmem_post_populate_arg *arg = _arg;
>  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
>  	u64 err, entry, level_state;
>  	gpa_t gpa = gfn_to_gpa(gfn);
> -	struct page *src_page;
>  	int ret, i;
>  
>  	if (KVM_BUG_ON(kvm_tdx->page_add_src, kvm))
>  		return -EIO;
>  
> -	if (KVM_BUG_ON(!PAGE_ALIGNED(src), kvm))
> +	/* Source should be page-aligned, in which case src_offset will be 0. */
> +	if (KVM_BUG_ON(src_offset))
	if (KVM_BUG_ON(src_offset, kvm))

>  		return -EINVAL;
>  
> -	/*
> -	 * Get the source page if it has been faulted in. Return failure if the
> -	 * source page has been swapped out or unmapped in primary memory.
> -	 */
> -	ret = get_user_pages_fast((unsigned long)src, 1, 0, &src_page);
> -	if (ret < 0)
> -		return ret;
> -	if (ret != 1)
> -		return -ENOMEM;
> -
> -	kvm_tdx->page_add_src = src_page;
> +	kvm_tdx->page_add_src = src_pages[i];
src_pages[0] ? i is not initialized. 

Should there also be a KVM_BUG_ON(order > 0, kvm) ?

>  	ret = kvm_tdp_mmu_map_private_pfn(arg->vcpu, gfn, pfn);
>  	kvm_tdx->page_add_src = NULL;
>  
> -	put_page(src_page);
> -
>  	if (ret || !(arg->flags & KVM_TDX_MEASURE_MEMORY_REGION))
>  		return ret;
>  
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d93f75b05ae2..7e9d2403c61f 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2581,7 +2581,8 @@ int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_ord
>   * Returns the number of pages that were populated.
>   */
>  typedef int (*kvm_gmem_populate_cb)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> -				    void __user *src, int order, void *opaque);
> +				    struct page **src_pages, loff_t src_offset,
> +				    int order, void *opaque);
>  
>  long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, long npages,
>  		       kvm_gmem_populate_cb post_populate, void *opaque);
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 9160379df378..e9ac3fd4fd8f 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -814,14 +814,17 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
>  
>  #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
> +
> +#define GMEM_GUP_NPAGES (1UL << PMD_ORDER)
Limiting GMEM_GUP_NPAGES to PMD_ORDER may only work when the max_order of a huge
folio is 2MB. What if the max_order returned from  __kvm_gmem_get_pfn() is 1GB
when src_pages[] can only hold up to 512 pages?

Increasing GMEM_GUP_NPAGES to (1UL << PUD_ORDER) is probabaly not a good idea.

Given both TDX/SNP map at 4KB granularity, why not just invoke post_populate()
per 4KB while removing the max_order from post_populate() parameters, as done
in Sean's sketch patch [1]?

Then the WARN_ON() in kvm_gmem_populate() can be removed, which would be easily
triggered by TDX when max_order > 0 && npages == 1:

      WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
              (npages - i) < (1 << max_order));


[1] https://lore.kernel.org/all/aHEwT4X0RcfZzHlt@google.com/

>  long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
>  		       kvm_gmem_populate_cb post_populate, void *opaque)
>  {
>  	struct kvm_memory_slot *slot;
> -	void __user *p;
> -
> +	struct page **src_pages;
>  	int ret = 0, max_order;
> -	long i;
> +	loff_t src_offset = 0;
> +	long i, src_npages;
>  
>  	lockdep_assert_held(&kvm->slots_lock);
>  
> @@ -836,9 +839,28 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>  	if (!file)
>  		return -EFAULT;
>  
> +	npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
> +	npages = min_t(ulong, npages, GMEM_GUP_NPAGES);
> +
> +	if (src) {
> +		src_npages = IS_ALIGNED((unsigned long)src, PAGE_SIZE) ? npages : npages + 1;
> +
> +		src_pages = kmalloc_array(src_npages, sizeof(struct page *), GFP_KERNEL);
> +		if (!src_pages)
> +			return -ENOMEM;
> +
> +		ret = get_user_pages_fast((unsigned long)src, src_npages, 0, src_pages);
> +		if (ret < 0)
> +			return ret;
> +
> +		if (ret != src_npages)
> +			return -ENOMEM;
> +
> +		src_offset = (loff_t)(src - PTR_ALIGN_DOWN(src, PAGE_SIZE));
> +	}
> +
>  	filemap_invalidate_lock(file->f_mapping);
>  
> -	npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
>  	for (i = 0; i < npages; i += (1 << max_order)) {
>  		struct folio *folio;
>  		gfn_t gfn = start_gfn + i;
> @@ -869,8 +891,8 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>  			max_order--;
>  		}
>  
> -		p = src ? src + i * PAGE_SIZE : NULL;
> -		ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);
> +		ret = post_populate(kvm, gfn, pfn, src ? &src_pages[i] : NULL,
> +				    src_offset, max_order, opaque);
Why src_offset is not 0 starting from the 2nd page?

>  		if (!ret)
>  			folio_mark_uptodate(folio);
>  
> @@ -882,6 +904,14 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>  
>  	filemap_invalidate_unlock(file->f_mapping);
>  
> +	if (src) {
> +		long j;
> +
> +		for (j = 0; j < src_npages; j++)
> +			put_page(src_pages[j]);
> +		kfree(src_pages);
> +	}
> +
>  	return ret && !i ? ret : i;
>  }
>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_populate);
> -- 
> 2.25.1
> 

