Return-Path: <kvm+bounces-26091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09408970B3F
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 03:31:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7C68281F7F
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 01:31:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE4B512E48;
	Mon,  9 Sep 2024 01:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OVjo2Wl9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF391101C8;
	Mon,  9 Sep 2024 01:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725845510; cv=fail; b=G49h7ffqbasJJEMcEU3syww2AxRo9xOStcNCi13yViPJWIHzNt6qHcLeW45mz0qgPatD1BQwXw8PfUVtmokJTY0e3mWnGq6JKmdIkHv61qXcYiVwRX+7loz0yMBPQYS6YNY13xjsl35UaLspLlT7jd5+dNaG8Gh6+mC8Y4dQv3g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725845510; c=relaxed/simple;
	bh=YrjhdR6KBlv2i0FDdr8UUSxGjr7xDu0LfCQirRhk16U=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=juXkYKsWBxNyiYWAIVwM1bqfC9UCjerzrjmyYErvTgr9cte2eoTRg41MwrZoDOMievWKlVNlCWt3qrrullTKU5w5gBRNt7nT/id7E8Cfk0NhUA9TMTopUpmtu7tKPyx3lU615/4DeI0+7btMymVPiSyDadjvifIcmHojMjUjQZk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OVjo2Wl9; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725845509; x=1757381509;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=YrjhdR6KBlv2i0FDdr8UUSxGjr7xDu0LfCQirRhk16U=;
  b=OVjo2Wl9U2sEstcF928yr53lxY+NZWWC3uhUvTCL2N6+25a7zgQdSUJg
   vYlpxL0V298ssiFx5u0bYG1ZUqonszXjNPo34LtdGKmpYfwv0UGlhad6l
   HMCEowb0RQMYx0Dvd78jJZOZps0faW/9ODDJ+DDpaRhgRby0LPG6p9TsB
   nE8+cuWaBDbcub1FMmAqFg4SaGcFsryZ4FG1QxN+Lv05RPNUmQqAZXoum
   M9L8Z551BwVhdaiZsZh/vX8JxEH9cgWXG/PGjg0Y/7s194sRDArIpDmf3
   JYYTnaDsj4xprMxW6D2MA/fV3F3jDrI7hNSMZCz4G7y5vmdHKmaff4bTP
   A==;
X-CSE-ConnectionGUID: fhG8MaajT5CxamY8FCZlCA==
X-CSE-MsgGUID: yWWZ3r+8R5iL94jKN5PHwA==
X-IronPort-AV: E=McAfee;i="6700,10204,11189"; a="24393552"
X-IronPort-AV: E=Sophos;i="6.10,213,1719903600"; 
   d="scan'208";a="24393552"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2024 18:31:48 -0700
X-CSE-ConnectionGUID: oba5kmHyS72ccay1fbjHOQ==
X-CSE-MsgGUID: OeIZLr+VRUm7prfjiRG0Yg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,213,1719903600"; 
   d="scan'208";a="70907577"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Sep 2024 18:31:48 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 8 Sep 2024 18:31:47 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 8 Sep 2024 18:31:47 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 8 Sep 2024 18:31:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wy3ZxlPuW3DTOJlJBeE6q7W4qopron06drpxE4XjdBC5WxhcZtwYBx3fNc4nLc929IzPtPBlFSgcFIhcAKzL9N9OspjbO++cSEaBQqMRHt3/P6KQ0mSmZ+C48Cj+7M8bl87aAQyq4qNfgjhIUixYy7b2fu7DdSSaJZaQTkdj36FI9SL+sKoVAUrlZ0L/AjLlj1sgo7CoMB0Qff7/hqP2rn9GbMqwoET63J7O6ATxR/9zAai/ZYKMbMvhBGGdyBd50NBvsWIn1Kmtbwfz5i2Dpc6osoMqN7H8HHs3h6DJVeCjY1kJj2UT/VdtYQC0dDKcSup8IHYbq/7Ao9j8kVYCag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+lahCxHC32/ghmStqOdgHdtiad1bSTTBhin9ppXJOqE=;
 b=HJ1b4SlBvHVnrSSQW6T36Ruhg0eJmoo1nL2/mv6cNwhtGTnVtvOk/0HR8Wv9PXvajJTY91vmVPW8a6r5ZInpXW0pfkYNbuGub4bujqomcnPtmHum9TjrBuZYkyuMeYEABibf/7DP2GybSy3SfyYIU9sjwzLqwofA6eCgYIVING+gZrNAdBk+CjIFW9EMp/Fsg7nxYbj2klulZAPK38h0YtaT95di9R43/qWIdz8F07+o/HewwBOiNpdb3/7kWeYDY/4V5dPnMIV/ZOA7m2uhDIMUO/TL7RIqSRkz2fam5gGszEAfxd/q1xHYKIrqb+4KSPLjlSYnZ7JRPtGQrAHW7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH8PR11MB6756.namprd11.prod.outlook.com (2603:10b6:510:1cb::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7939.20; Mon, 9 Sep 2024 01:31:45 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.7939.017; Mon, 9 Sep 2024
 01:31:43 +0000
Date: Mon, 9 Sep 2024 09:29:47 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH 19/21] KVM: TDX: Add an ioctl to create initial guest
 memory
Message-ID: <Zt5Pi1zO4oIuUlCV@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-20-rick.p.edgecombe@intel.com>
 <Ztfn5gh5888PmEIe@yzhao56-desk.sh.intel.com>
 <925ef12f51fe22cd9154196a68137b6d106f9227.camel@intel.com>
 <9983d4229ad0f6c75605da8846253d1ffca84ae8.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9983d4229ad0f6c75605da8846253d1ffca84ae8.camel@intel.com>
X-ClientProxiedBy: SI2PR04CA0017.apcprd04.prod.outlook.com
 (2603:1096:4:197::15) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH8PR11MB6756:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c84af47-24aa-4051-24b6-08dcd06f297d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?nRa5wiktnm0qCs3IRq2BBA+IAn827OCQLRVtLX6hZxhViUL0OaLgYqEEXh?=
 =?iso-8859-1?Q?HMr5i41a+cLdfYgmRaDlz1lLUh9IvDgddzlm4YzF5XHU2DMSPRhfj+29P6?=
 =?iso-8859-1?Q?8zHFbkYJu0BScNLAMOUb6ktw9XiF1+ohKYavD8Q5lwiYFdUUMtihmd24iL?=
 =?iso-8859-1?Q?HD+qwJDeLgigAQtomGoJ+0IdzJ8QpsqWT/K0MJ3KnaTEMqqYewKqnY76rL?=
 =?iso-8859-1?Q?h2hMo7CzsJXXW0nnkClZrg+lOye9iEzA9Wp1Mcby/EWUdsiB/NaCOvvJ5j?=
 =?iso-8859-1?Q?vqk889qVULM7WPaU7rMskswpskW+TRMCmgwhRTEv8rENbuY89+4ydOhXhd?=
 =?iso-8859-1?Q?YMvPYdbTglCWuPfiIAJXYaWY3xtsqCBpov1idmcfsW1bVjEIBIyoBN/j38?=
 =?iso-8859-1?Q?wXYQxVGry0HSov0AqElauUcykhOLqrs1MTpDPUxVOXVNEwoAsbLRHhxABI?=
 =?iso-8859-1?Q?AGN34LWeQ2J9cY71Fma/+hx4lZpoL2IDAQjRsdPzHyKoHfpc/sm/gph1Uk?=
 =?iso-8859-1?Q?mipnSl/XhcNlZfRRE6VQ8YIvxUwIhLBFNtUica/1iZoXzfZNz1basxg5x2?=
 =?iso-8859-1?Q?rCBINqJNqiIoyzHmeLIusx0oNa5nUT9xKRJfNyo7OjLDDVILDayKLo4Q6V?=
 =?iso-8859-1?Q?1waNQPJl2XdtA8HZKkN7Tp8Bati/7alruW9K2SFBD8eC3fVAxaYxe2PNel?=
 =?iso-8859-1?Q?Nd0+acgpcyA+SH0FXeBQ9O095NONYuQ13z4fq6wOwJe1Tpj6knfa20786U?=
 =?iso-8859-1?Q?OC4lX4mDUMkqgFVrcwzOXP3vmAj1O1KDLy7ZdmqMwcmA3l6kJ4c97rlcxb?=
 =?iso-8859-1?Q?COr0OO94i8UuS7oc/LBDXK0pWAvneKAOfu+9ndFM3JhvAKP0ydr4DfCg/m?=
 =?iso-8859-1?Q?AFhxoYe8A3aS0ev/CL2MjdpXJq9KO1DUfU0UhAsNVnGFmWXBE9ghBFqNBz?=
 =?iso-8859-1?Q?EqgxDhfFB9EpNGl/KCj+S833qcI/HMf3TBqp1XFwqocC+cvVqd3uVJuzsf?=
 =?iso-8859-1?Q?H6kR/FuhGh1W26mxqyqKQ+WXEZ7Dn6ZskNBKsindUnoJ16GihFiow8Y7HJ?=
 =?iso-8859-1?Q?imDV+upU1AMawLkKRuhLU0cFKNFVPcO3paNdQcc5ONjp3QNl4s7AqI8xnO?=
 =?iso-8859-1?Q?X3kNeuFXqzRmnjtXPHkYb/H2icbOGfJVH/ZSjUNLRmwDiQDdG+doaXZ/to?=
 =?iso-8859-1?Q?RdrYqLMTuODoB/4u3uQJ1KSwdrSFJ69yXFWQ5r9f7Vt/7ue/qBfOJ8YFYz?=
 =?iso-8859-1?Q?DLbTouR3wNhin0crqYnMwkLs0vn2U1qXnzdoUWtLboQ43BKRKfXwewCbvL?=
 =?iso-8859-1?Q?xHA2/u2I5TuX6iKSffUdGdmSfnvegr9ODhmr/ri73OjNxHkEBIAkkUhpRE?=
 =?iso-8859-1?Q?5eCDBJvP/zGilnLSa2ulsB2HE8/ovwLw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?BNodlnehOyUVLS5qttagBe7jJMM9A6K9/AizdzwB0CEr14z1q6g01OO4HV?=
 =?iso-8859-1?Q?EPaSTP3+gpy4VOZFk2w1omnB+CPXADH2MiaPRRXf/DAXU4CZh/YjNC+zQW?=
 =?iso-8859-1?Q?4WX9o1+n5UiAs7UDSosnTPArS6fPQc3/r6+X59lHtFF9dzr5eSAsuOitWm?=
 =?iso-8859-1?Q?SOKhU5e1+eK4t3wzT0hhhuJpp5J7dX0gEOHPUmAYak7ESHAc03MlmpCXks?=
 =?iso-8859-1?Q?3jqAyOYRWsXKQk7lDcP0aQ0eFFyGcRjOajN64KbuCiSISDKf/e0kTZzuJQ?=
 =?iso-8859-1?Q?c8JZFfoL/X9RgIn/oSe3nj3Nxpzaqt/HNCXJBIR4AK8eP9cPcYsWqaaYLi?=
 =?iso-8859-1?Q?l74dQGLd5bFgfXHlrZxqX3nPxlbJttDEpkYQi72XzKqvP2kk8BjRwok8k6?=
 =?iso-8859-1?Q?fPy2MkT1u8GjDHwlwd0JKprWChAOqY9vwYQVOiXVyIxBX7EHKItmLERMhZ?=
 =?iso-8859-1?Q?yUqcQ1YcQfR+5xkFIogxW7CW8z56GGk4zD8IXaPDz++AgF//junrk6bsMa?=
 =?iso-8859-1?Q?tBklt+9CTTwhDBCO/XDS6mePhIvLSUn4F+B230iluHxt5doCypDfXxYOZZ?=
 =?iso-8859-1?Q?SyFhTc1Bu8qNkOimWENo7atgUH6lmoXOCRy11444zhwaATym7H2bCU8UA8?=
 =?iso-8859-1?Q?yo+S4nAudLsQgr6AAlxlzP2loVDyFVrayiwqJzWOTEV+XDXnkrBwqCvse1?=
 =?iso-8859-1?Q?LJmkqmBK4tQVWWYGlRZE4Ka+XZS84+/7zTfsr0yWm/L7eSlgrGSse1laDQ?=
 =?iso-8859-1?Q?4FuzJWnruFgRx2/wkoO6IWLIK7JW5cdbMp+rdHWg/eQLqYf8BMYeQwv8QU?=
 =?iso-8859-1?Q?ahWP6ctWKjiGPSkSEGJspEeYBcYjSj5FLy09PHtzGsXTwix3G9ZQg50XjS?=
 =?iso-8859-1?Q?H+wghv6kLw9hLSkH0c3N2dSPQUbzk1plQbb06WevRKIseVVezMY6bmO32i?=
 =?iso-8859-1?Q?nVjyl29jsS9KQ0UnZWhB4NP4PYwPuhKmXhFeh6XTIcfXACEdn3FGlfEQgw?=
 =?iso-8859-1?Q?H8NR5qEpR5xxpNOKeQXwlcd5qA9vneMPI+q2HhZHkTu8JeYqzesMGmJk0/?=
 =?iso-8859-1?Q?KOy4jG2Z88FTe0pQucC3sqDDlYXgJ1f+4fmwucqcffQGEqEXRIoX4IYmHd?=
 =?iso-8859-1?Q?ZuIY0BmUC8OX0E4oi6VSJUzLa5VM09+892sc/PE2rNEyddhkxIZYgvegOf?=
 =?iso-8859-1?Q?BxvnNIY6H7eaeSBlgWDoIKzP3HcfdmOLZURp1SzSAl18aY1s6+/5fI+FEe?=
 =?iso-8859-1?Q?BHzWO7xYf7K7kPGwyAEbak28zfbUO1IqGQLj/91RXpfaDYSx1QMKY+rB4I?=
 =?iso-8859-1?Q?Dwss5xi8IIr9i7tJJM5nNkArE4gW9h1lwxTpwjxwbykGot7UwaHXhwv/w2?=
 =?iso-8859-1?Q?1m+KSr70MwFxu1FEylO3NtBebUu8YXUauqtadJNYwiff9uo+Wb+GFRLgbx?=
 =?iso-8859-1?Q?KJohcjOHCiQXMO24YqBvCkAOGCZ9AEYxDC1pHvjIiIYIOeVGCRd2TwK6/O?=
 =?iso-8859-1?Q?SjauIa/XCh83Pw5lEPXqgs16ynp9YvLIVKJKDeGDAzLc8DNJ5bdDKTDVP8?=
 =?iso-8859-1?Q?2+ew9o95Kzthf5brvZ+ecrJqieX2GzcstRgrvX1hEc1VVN7Te2nEJlJbco?=
 =?iso-8859-1?Q?HixNg5I37vi82E7mTRJwYknJla79k+Rdhu?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c84af47-24aa-4051-24b6-08dcd06f297d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2024 01:31:43.6846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P56TOKEcsxdyljE/m+bbKUu4Dpway1xiwdEEdbPFyWUlvKHrZRppTTR6WYgr+TvFAq+GalQLGgxTp3eIuqEWow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6756
X-OriginatorOrg: intel.com

On Sat, Sep 07, 2024 at 12:30:00AM +0800, Edgecombe, Rick P wrote:
> On Wed, 2024-09-04 at 07:01 -0700, Rick Edgecombe wrote:
> > On Wed, 2024-09-04 at 12:53 +0800, Yan Zhao wrote:
> > > > +       if (!kvm_mem_is_private(kvm, gfn)) {
> > > > +               ret = -EFAULT;
> > > > +               goto out_put_page;
> > > > +       }
> > > > +
> > > > +       ret = kvm_tdp_map_page(vcpu, gpa, error_code, &level);
> > > > +       if (ret < 0)
> > > > +               goto out_put_page;
> > > > +
> > > > +       read_lock(&kvm->mmu_lock);
> > > Although mirrored root can't be zapped with shared lock currently, is it
> > > better to hold write_lock() here?
> > > 
> > > It should bring no extra overhead in a normal condition when the
> > > tdx_gmem_post_populate() is called.
> > 
> > I think we should hold the weakest lock we can. Otherwise someday someone
> > could
> > run into it and think the write_lock() is required. It will add confusion.
> > 
> > What was the benefit of a write lock? Just in case we got it wrong?
> 
> I just tried to draft a comment to make it look less weird, but I think actually
> even the mmu_read lock is technically unnecessary because we hold both
> filemap_invalidate_lock() and slots_lock. The cases we care about:
>  memslot deletion - slots_lock protects
>  gmem hole punch - filemap_invalidate_lock() protects
>  set attributes - slots_lock protects
>  others?
> 
> So I guess all the mirror zapping cases that could execute concurrently are
> already covered by other locks. If we skipped grabbing the mmu lock completely
> it would trigger the assertion in kvm_tdp_mmu_gpa_is_mapped(). Removing the
> assert would probably make kvm_tdp_mmu_gpa_is_mapped() a bit dangerous. Hmm. 
> 
> Maybe a comment like this:
> /*
>  * The case to care about here is a PTE getting zapped concurrently and 
>  * this function erroneously thinking a page is mapped in the mirror EPT.
>  * The private mem zapping paths are already covered by other locks held
>  * here, but grab an mmu read_lock to not trigger the assert in
>  * kvm_tdp_mmu_gpa_is_mapped().
>  */
> 
> Yan, do you think it is sufficient?
Yes, with current code base, I think it's sufficient. Thanks!

I asked that question was just to confirm whether we need to guard against the
potential removal of SPTE under a shared lock, given the change is small and
KVM_TDX_INIT_MEM_REGION() is not on performance critical path.


