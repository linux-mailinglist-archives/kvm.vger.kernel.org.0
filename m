Return-Path: <kvm+bounces-56243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C625B3B2FB
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 08:08:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11DB2468499
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 06:08:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CC8B22CBF1;
	Fri, 29 Aug 2025 06:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LQIrhe/B"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2FA207A20;
	Fri, 29 Aug 2025 06:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756447667; cv=fail; b=ME5jo5ifiQouQBjL5MxvKQJGRFJv842SaOc5kPgM+P3SZdwDQsui0Ru9SycIW5w1D88IFB1Bd2n2DXOzScWdEcVoRmSquY1hW1SzxLxQDSn/xlwkgHmwvGTv0sr7q066VmcTJwjfZz4YvxxhRNuw0z1u7VpNQfa4f+WtwLgKDsA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756447667; c=relaxed/simple;
	bh=rVyxyb4doRlz/OM/l16DzEFOSqRdCnIkRp0cm/wHuPs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jIhuHWyZ82nDU5+PngjTpio68fNnooQ8LO0oSJnfnq4ViPXIxd3Er8rG2PCiu0leUUZOHTNUw66DCP6qP+US2f08FCpXR8mnM2mKD0iX4NNw2Ilc8VfRRbL9tltAyvjykx/Xl4JMHRSgPUqW/Brs8E3ku4Ylt4wWLbiM+pB7+Ts=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LQIrhe/B; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756447666; x=1787983666;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=rVyxyb4doRlz/OM/l16DzEFOSqRdCnIkRp0cm/wHuPs=;
  b=LQIrhe/BFqxYYzqjxsZTnZt/bVxI0TdBM6xKhi0uF3s4yL2iyeZNgsBH
   kvBPZXZl0bWqmA2IvIdsxzgbJY6OQbVQ0v8oMqj2rjoSdkBdOT1TeYY4h
   WfXQA2IF2s1HyRzkFYhTPdBpxheT+OoEcRcdZjl9ldcaqT8wx/J0SIMAy
   1C89RL2vSqzeGLZWkwmfOSugJBBGbYZoBJuekhmNhx+z4h1JPunr8N51x
   ++IMj9eSeHQdfiGxxX8iQuB5ELzuSLae6ItnoEhnoYbHiLI43E93ZGcUm
   aio8ogJPPQmop/vbVyEn8PuHpyO2bm6UUxS8Hoi5LKhqlDxaPxCNEpwSm
   A==;
X-CSE-ConnectionGUID: OGkJS5P4RCKIsWHegBiMhA==
X-CSE-MsgGUID: pnafBL/6QQCMJTmb+Gl3qw==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="69439244"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="69439244"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 23:07:45 -0700
X-CSE-ConnectionGUID: lPuWPGr8TcmNBrYntRc0oQ==
X-CSE-MsgGUID: C16fjf6VSWmAuryFOmpVwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="174476005"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 23:07:43 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 23:07:42 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 23:07:42 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.70)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 23:07:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p1JJYwaJdXrbdAn6T3xy3r7xo4Ctm9u3wm0kno3+rADqxf1h1j64iYs1n2taUpLdY1VvTC7eEGhGxQJAf4b7elHyDUd0lTVQ/TBm745HdZSzr18OaiN67xu89V9Zf6xXrH5GfEW/rFwhO+HEokt/NFwC8nhi+W/Hxc0d5eMS3tReX5zjTw2Go/Eu5N3MDyimkNCMUf/JI1xaPl2YfpNDKFQfrxebF/sKxdG8ZJ3RuBAi18w7AG4rewe6jFjq3kf0VptJyRCP6EuI2J5scn2On9pVVoEncciEqhOZDt/Ulqxo5t1tl6CG+pIsJ6MS27HJXzl/FEakhE+JC1GQtZxNQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b0faROf2rl+tXlWRsJAMANghEPoAcPoJ/ju4n9NCCDA=;
 b=CACmFuBx7hsvrJt1FVcD7tl6YvQVphFeRMGdG79nL8XfwQK2KzeHE6UjZo7HFaObKsMDSu5IrPEKflHN1WF8AHhVcXVOPzvMHUB6tMmVy2dIL2JCuCds3FQqIwS0OvTNmBbZPTmwdk1PhSjT2BABcD9gByUJHaYDSGrJEijG67Aur/yYsuSBFZLHnl/CzuwVwKr6TKS4wU9SChxWDz5CGJ2SaieyDe2CEUSJid7ey3mPKYmiPw5DB1CbRU8Emf4s/M3RNZd58aNxqJOlDYLWjKnIMcwEuFuMj3qQk9T3wzZvVvMy+w8rA9YBNGzzdfUbynOsdF9x9RdRb5q2o2o2Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA3PR11MB9133.namprd11.prod.outlook.com (2603:10b6:208:572::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Fri, 29 Aug
 2025 06:07:39 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9052.013; Fri, 29 Aug 2025
 06:07:38 +0000
Date: Fri, 29 Aug 2025 14:06:48 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [RFC PATCH 09/12] KVM: TDX: Fold
 tdx_mem_page_record_premap_cnt() into its sole caller
Message-ID: <aLFDeJ8Rk0p8yucV@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
 <20250827000522.4022426-10-seanjc@google.com>
 <aK7Ji3kAoDaEYn3h@yzhao56-desk.sh.intel.com>
 <aK9Xqy0W1ghonWUL@google.com>
 <aK/sdr2OQqYv9DBZ@yzhao56-desk.sh.intel.com>
 <aLCJ0UfuuvedxCcU@google.com>
 <fcfafa17b29cd24018c3f18f075a9f83b7f2f6e6.camel@intel.com>
 <aLC7k65GpIL-2Hk5@google.com>
 <8670cd6065b428c891a7d008500934a57f09b99f.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8670cd6065b428c891a7d008500934a57f09b99f.camel@intel.com>
X-ClientProxiedBy: SG2PR02CA0095.apcprd02.prod.outlook.com
 (2603:1096:4:90::35) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA3PR11MB9133:EE_
X-MS-Office365-Filtering-Correlation-Id: bc3b119d-acea-4677-224d-08dde6c25b3c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?f8/XEGra4/ZybhYKJqpPmLvWxc3/sce1ry+t+ouFO+moG1W4tVVVtuV70t?=
 =?iso-8859-1?Q?ysyu12SXGThbyistTqrFJnW8mghH3j5CrFVAsAU+HA7tSr7oEhUYlDoPrW?=
 =?iso-8859-1?Q?IBkGzAg3Vx6tXIju9sqZa6TFJ+w0icFl/+waXn0EA4h7nREtKJi6Ak5mvC?=
 =?iso-8859-1?Q?6Yv19UMEeTVa1Shh18mbvqlTUT2xqSgzNUO1Q5GqgxJD63Y/jAc8Jjb77N?=
 =?iso-8859-1?Q?diLSllUz51X6YNOL947pso/CUmDPo9SPgtlrU/tpSig1uMEcUlp1/wAnwx?=
 =?iso-8859-1?Q?hHv78aQj07ZZckEApcxsh/BkQg0s35vmE+O48dFC0Q9fzOhufDni3ttEgi?=
 =?iso-8859-1?Q?ZSZsODeJIBSLOrB/XvjHqcNLmFEnrdIIHgqcCzqhTFmDDKyf1QHc54iku3?=
 =?iso-8859-1?Q?b7lVqUP+ILuNQbLSpbKF9S+FD0qEhCySVQadoS43d7+dM7g4T6hvntRgtw?=
 =?iso-8859-1?Q?lUKdrx/dd4uDQBPmfZDhmtpbNwaHCA/bYkCcCLCQ68gHEoIBM8VRV75cmh?=
 =?iso-8859-1?Q?M6ilrvCD8KcrAXpz9/CK4A0gjiKpoOwCH0KYt7rzXLTRKLN9QjNvFGMVuS?=
 =?iso-8859-1?Q?9dVNMZHPTxL7IQEDR4hlW6aRbsootkdjDohTYvryG2IOwAHsG1xHPspy0V?=
 =?iso-8859-1?Q?IrkC/EuXsuBqGC434GVp5tVv8wvAZQQe7Pw3J8B996OC1It4qUztdoWYXy?=
 =?iso-8859-1?Q?UvqCdcvhbVoBxcc5rpMDFtZ7H66hME85ZzcMntOxw46E9RlMsOtrRfDybS?=
 =?iso-8859-1?Q?XH9y9fGsemn+YS7CcI2/aGcDBYslJgNkCsWUhXKnJ6p+HuI/Uz2shtQeSh?=
 =?iso-8859-1?Q?LNLHxAyZy/Cym4Z2bEgmDtc0B4c6Qa6SeUhyECty3sZPRP+BAPP0RbFahv?=
 =?iso-8859-1?Q?6o0X1n8AgJ3IWXx9TtqX7JUC2lf3Ikr8p/YagjxegaaerM2eDLgMSZ/5B5?=
 =?iso-8859-1?Q?Ke4XRseAxoYjsvpfqzbRHKG8SDwA/yHUgwOUU8mDoklnsUpy1PQMvXEVvD?=
 =?iso-8859-1?Q?kQDJpXbLAaZqRmOkxWR2PZ8Qqc4ItcR8K6ethVI99y0PfDYZcu21TQ2CT/?=
 =?iso-8859-1?Q?cwbJMxnJ4ILfmVkLZHQ0rosUk4rYix2JLYctXQckU4fvfowSql0HgqXI8v?=
 =?iso-8859-1?Q?kzMa3WDk6xK4vNKD3K8Ys+eGVVI9cVCwfAzUoz4T68qYAqxiPgs9Np6FJ7?=
 =?iso-8859-1?Q?r5M2gvwgc3LHssi7WUuPdhvtkV+zVdc/SgZM1mr4BmSw1si5asj92jM+tU?=
 =?iso-8859-1?Q?4qERZATV4P6JJZjfd8ahvbUOjVU3KlFo/r/7tfUMecUqBe2fekHXE1srvl?=
 =?iso-8859-1?Q?BS2B8U8+L2W5jEMiREa7w+ieiu/5q5ZOwLlo4nS8lB9NtkfE8Umgd3UKQE?=
 =?iso-8859-1?Q?2iVVzQ8vcMXZsFb7C0+Sf0Ij8bImzFDIBZ0J7Gc9ivFnlzs6fPIdWFi3Ua?=
 =?iso-8859-1?Q?RFKD3iRnJLZoAX03Q6Jt4/OhIHZgmd1Qn1irxwDdQBcJHxau9qvgxPQSKu?=
 =?iso-8859-1?Q?c=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?K850OYKU8W7DQvJAvO0u5s15/QYuh3brUvmUycHFKk4NuYfzm4eERPhWOn?=
 =?iso-8859-1?Q?JMa4NxCdUXE8nFHv8eoDMSwaCftmqmgIDq+tNdaqJut3UNFkwjKC5al7Bg?=
 =?iso-8859-1?Q?Gpyeh1otkneXqcz9q1lm9cvCTII/ZOOCL9WBy6oDIix1dAoNgUU03fCQSU?=
 =?iso-8859-1?Q?QGS1Pj1DyNtQf/b4QkG5aju/zUPCgh5OCbAdPL3aDUhtY3r77iuyi32JfO?=
 =?iso-8859-1?Q?ciejr2Cdq6aeXL6e39CS++PFHSzANQ/wo+pRt9Cb2oZFt4xBTukvnPCFKv?=
 =?iso-8859-1?Q?12oSzhvqbeDhYw+2fCPzWLhOcEyjEvQLLEf4MEDGuQcXsHECqDrAABxz/1?=
 =?iso-8859-1?Q?DQAlm6Oe6X5DDpvafvGdq5k95bosCkn5TZUccgE7FKKhA6zg+nvrdxPeOQ?=
 =?iso-8859-1?Q?oev+lmLWooVTHoTBBC/FzH1kw4jO6V6UTtP6rcveMcCBQVsvmh4xLnvbW5?=
 =?iso-8859-1?Q?hM2UerSOIkZqDCdmgVWbsgKFvJJhvg+gJB9fe+ygO8mbnfq+8DhoMcEEjp?=
 =?iso-8859-1?Q?3fW2h5WHtb5OCxDavrRyDr54sKo+GebKWGrEXdyNucIkE/VyR8qcMs2C2v?=
 =?iso-8859-1?Q?kRsCm/okfUqccEpio5qEaGT6NwqzJ+OAj0M0DAaCt+F94GPlRNFVAQ3Jmv?=
 =?iso-8859-1?Q?hc7yzgFaXgDmkQ6V1KyjC7leZj31Ro5ds9PGbwcPAPxQ6T+t4S3z4EmvQr?=
 =?iso-8859-1?Q?drBaF5GkK9881Cvc5zmTe9Oa2OqFP1Q7X0IRT6dbKkxpdZQymyQrg5JBSC?=
 =?iso-8859-1?Q?u0JpmwoyofKh/K/Td4WI7FIaPCEtQ1muog4LH2X3aCVc4ZjKLiKszrwHyp?=
 =?iso-8859-1?Q?R33HtCgHGwVaaPE8+ei9gfm2f4nJZwoVILtlkws7fr5DeFLJCR/2N4L5AR?=
 =?iso-8859-1?Q?MgGHUnmOKEVrfTw8+WiPsLPWqln0xQS1b67qnaUDIhcxEBr4mAV9NZp4/I?=
 =?iso-8859-1?Q?Xbjn3eusqtGcm6Zq4tyfVxoNa0R+g1qSCc0oJQD6gYCmEKP9r0Pkq6L4bQ?=
 =?iso-8859-1?Q?ESJXwsup5sRGerYJjJgw+A6t78FbLU3+kC4SXqpIaHLK37CzfHXWYpFgyQ?=
 =?iso-8859-1?Q?vefHA8U1+Mr0durkurNlq96VAh+GZuQz7wA25PhSjUHGC0WX/oglN3GJvZ?=
 =?iso-8859-1?Q?Hxu2EkrKGjVt9e3VZ2Rs/PaPpdwk3tz1u/EQ42UjnKWsGOHeF1FTcPriKV?=
 =?iso-8859-1?Q?NHOBZIQZ51I0LLccWX9oelH3OwLuztewPf6dRuD05SobrALrE8nA2+bY1M?=
 =?iso-8859-1?Q?Jlrl0LjGldMF5pTKyX/+6O9bLOX9Xe+45BtkxBUeNbP2tjD85FaXn53mcO?=
 =?iso-8859-1?Q?mi9rO0qJMam9FbRDbh2iDQOeKr8SGR/8hWFEKktQ7K7RbjTo1dbwVHEBlB?=
 =?iso-8859-1?Q?CobV/YMEh3/WGvNSTLiv7s1a9XpgnUP8WwnvFA2sJ6qOnug7884JtLPxSI?=
 =?iso-8859-1?Q?+gxj5gqsCyaHTeAeyYLB4nZSFJaVCdG5/XoHECwGefrsgxEHhW3OGkEpRZ?=
 =?iso-8859-1?Q?nOLbz/GYGBsqYCJOvFZMymLNmLJcCXktyFA6Ml1q9rOC+3AqZkk0GTSE/r?=
 =?iso-8859-1?Q?mcmoNtNVgiwWTWRSstIEpjgwISHaJ9Wb51gtQkgh6UgCO9JFuIC7LAdvL5?=
 =?iso-8859-1?Q?vpl6wX5ctVYUn2JKqKspxUkvWrYjOwzmON?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bc3b119d-acea-4677-224d-08dde6c25b3c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 06:07:38.7873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9NlhFOcVjeMgympaNJdYNZ3OcCuMrDimcpiq9F1ZRupe0t7ODHaJktKATjPP1b423j3iEhn5e+ak+98nxTjWhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9133
X-OriginatorOrg: intel.com

On Fri, Aug 29, 2025 at 05:33:48AM +0800, Edgecombe, Rick P wrote:
> On Thu, 2025-08-28 at 13:26 -0700, Sean Christopherson wrote:
> > Me confused.  This is pre-boot, not the normal fault path, i.e. blocking other
> > operations is not a concern.
> 
> Just was my recollection of the discussion. I found it:
> https://lore.kernel.org/lkml/Zbrj5WKVgMsUFDtb@google.com/
> 
> > 
> > If tdh_mr_extend() is too heavy for a non-preemptible section, then the current
> > code is also broken in the sense that there are no cond_resched() calls.  The
> > vast majority of TDX hosts will be using non-preemptible kernels, so without an
> > explicit cond_resched(), there's no practical difference between extending the
> > measurement under mmu_lock versus outside of mmu_lock.
> > 
> > _If_ we need/want to do tdh_mr_extend() outside of mmu_lock, we can and should
> > still do tdh_mem_page_add() under mmu_lock.
> 
> I just did a quick test and we should be on the order of <1 ms per page for the
> full loop. I can try to get some more formal test data if it matters. But that
> doesn't sound too horrible?
> 
> tdh_mr_extend() outside MMU lock is tempting because it doesn't *need* to be
> inside it. But maybe a better reason is that we could better handle errors
> outside the fault. (i.e. no 5 line comment about why not to return an error in
> tdx_mem_page_add() due to code in another file).
> 
> I wonder if Yan can give an analysis of any zapping races if we do that.
I actually proposed to have write mmu_lock around tdh_mem_page_add() and
tdh_mr_extend(), as in
https://lore.kernel.org/kvm/Ztfn5gh5888PmEIe@yzhao56-desk.sh.intel.com.

I don't see any reason why tdh_mr_extend() can't be done inside mmu_lock
in the pre-boot stage.

But the previous conclusion was that with slots_lock and filemap invalidation
lock, it's ok to invoke tdh_mem_page_add() and tdh_mr_extend() without any
mmu_lock. The nr_premapped can also detect the unexpected zap.

