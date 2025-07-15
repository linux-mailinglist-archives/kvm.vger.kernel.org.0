Return-Path: <kvm+bounces-52409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28EDEB04D93
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 03:49:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 960ED7A67D9
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 01:47:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 859572C3260;
	Tue, 15 Jul 2025 01:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YzYF9NBd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8232C08CE;
	Tue, 15 Jul 2025 01:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752544129; cv=fail; b=KgMt5Q17GRsCYWhwUoSuMaKj5WZ0yoxWMFH7wTxdPw32cQMQyAUhmydhKJmQrhY8drniFBuWKOZCO0ZTMB+gC4KlkLIwP018M234vsduQ4qeCCHk4ONr/eNF7WXbzVdBcwLK4QC+gEcEmfikhyf1Jfcpu/LE/vSlfTK2jpvGDK8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752544129; c=relaxed/simple;
	bh=4fxpO59oDeMLCnPH9T1m++61GtNmxKd9dkpSiOY8350=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FHQhFedsVRNe2fk11ULXC4/UNA/bo321RmenHZBpjA8otJtFC6TSgRjcuD2eYYIBNNlngen1xrV0OatWFEzbiz2KZYx5aMs80hEXeojcOclj3XZN8FX4WcxJaOE0SH80MAL8CFGYeCOiznguEvpPoctLntQIGRyYwhgJ65gKoHY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YzYF9NBd; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752544128; x=1784080128;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=4fxpO59oDeMLCnPH9T1m++61GtNmxKd9dkpSiOY8350=;
  b=YzYF9NBdole00M6LQqOvsmMWKpyRX9ptNFGjrjSd2gR5iFQmGzauJGuY
   ShtLo+vkBxCA04iZQrb45yBXMYg14MYIJ5/HAk62i6Lz7a2CgQn9cp/VQ
   wnqxhLi/BA7L/kWodh6KH8y1VSzA55o1/MrBZeRfqeNM9IGPhIeEJ2TA8
   WpFzRKV3REmh1FDO645pQIKiea1TPXqA6WtdarX5u3HURjzwhbtJCqN9k
   4jlnJZKK4yIVhM7+WfaAxaKUGQBBHvDgQaOIKU2kslgZTtBt4iuOa8AHl
   yaCkBicFC2MGw74ScVmBeoB8T4utbLem3XaNMZGIXqMY7x66maCbCs4hP
   Q==;
X-CSE-ConnectionGUID: R+oeNzzbRNOTMAmgd4UbSw==
X-CSE-MsgGUID: fVUuf0MSTsCjZ4CkMa0fkg==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54687490"
X-IronPort-AV: E=Sophos;i="6.16,312,1744095600"; 
   d="scan'208";a="54687490"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 18:48:47 -0700
X-CSE-ConnectionGUID: MVQlXdbpR2CraP1VnnwBkQ==
X-CSE-MsgGUID: 1cqJfpPFQN2jEiUIUp7JpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,312,1744095600"; 
   d="scan'208";a="188076591"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 18:48:47 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 14 Jul 2025 18:48:46 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 14 Jul 2025 18:48:46 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.63)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 14 Jul 2025 18:48:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V1plWezjD5IWr8D/y7OGPXyRJTvZh6oRACOgLDhvcU5U8xiKwqmG7uBO2ru0KxPDHr9gdRLlqAKfzTgx+epQ7eOdQFJKCqBEADc4goCfFEzdvNwqkMS5vS/Uc1o3eUUMxog3ITKS5fOxN8FL3seRchiL7cQgquT24IyFVu2VCELmOQtlu/0dArJ0q9PfcXkZlqfZhZKfseyENQX020gHntZaSBD2JipyLqzfwPV4ckgiLem22mfDS1S3h4iI0wcyIudqgsjfXKsytp5BdaIUga8++aupaslN4RlcCA8Dag7el0JuP1RCVcVdzLdsdnj7WvuBYX2PwxnqfqlsByIz4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JT537YAHGgpdWgJOqnS3GE56gNtJ+4QGSxgmpkoQkg4=;
 b=BrjdMzQVvC92sdF3Z40Wlkvm3SjZiBRZAn7gxS8pJrKGCa/L8eWCvSn0yKFdhTnRVOlMJ/uzVbmPsTwGHkk11koas1jEEGjzTmwT0ACj3CmJD9aXJJkyaFlAX5RNAhRc0YhReQD6eRBlMoIYnGSCYU5mroyTvIgWmswTxJ3KPePfHAmPcLCMmpjQ+h+bNc8g1PFZGc3A6LrO+zZ4XPfFZTzoMPUhJfauDkfovi2TvTGb2DJzvcZFlVc1/549gaof3tzrquzyRYAXOsdnI3JDUW2bdhfI3+reQUHVVwjyU+cwYfKpOJu8EMJBBwcMRDlnY+/Kak1adeo7YX+O3jIU4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA4PR11MB9203.namprd11.prod.outlook.com (2603:10b6:208:55d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.25; Tue, 15 Jul
 2025 01:47:44 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8922.028; Tue, 15 Jul 2025
 01:47:44 +0000
Date: Tue, 15 Jul 2025 09:10:42 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Michael Roth <michael.roth@amd.com>, <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kai.huang@intel.com>,
	<adrian.hunter@intel.com>, <reinette.chatre@intel.com>,
	<xiaoyao.li@intel.com>, <tony.lindgren@intel.com>,
	<binbin.wu@linux.intel.com>, <dmatlack@google.com>,
	<isaku.yamahata@intel.com>, <ira.weiny@intel.com>, <vannapurve@google.com>,
	<david@redhat.com>, <ackerleytng@google.com>, <tabba@google.com>,
	<chao.p.peng@intel.com>
Subject: Re: [RFC PATCH] KVM: TDX: Decouple TDX init mem region from
 kvm_gmem_populate()
Message-ID: <aHWqkodwIDZZOtX8@yzhao56-desk>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250703062641.3247-1-yan.y.zhao@intel.com>
 <20250709232103.zwmufocd3l7sqk7y@amd.com>
 <aG_pLUlHdYIZ2luh@google.com>
 <aHCUyKJ4I4BQnfFP@yzhao56-desk>
 <20250711151719.goee7eqti4xyhsqr@amd.com>
 <aHEwT4X0RcfZzHlt@google.com>
 <aHSgdEJpY/JF+a1f@yzhao56-desk>
 <aHUmcxuh0a6WfiVr@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aHUmcxuh0a6WfiVr@google.com>
X-ClientProxiedBy: SG2PR02CA0039.apcprd02.prod.outlook.com
 (2603:1096:3:18::27) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA4PR11MB9203:EE_
X-MS-Office365-Filtering-Correlation-Id: ee2c4267-c1f3-49f4-559d-08ddc3419718
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?7RHk1LE9/wuteyaqUESp67ziLt591CqT/5e8LinKtbfs9Wr8s75T7GCLlAA0?=
 =?us-ascii?Q?7IAC1ixP75cgQAdEqLVZmDKjBg5oiQbCES8J5MNTozE2dmqNhAnuJc0PM7mP?=
 =?us-ascii?Q?hFD0TNuGoKmr+xeB5sk6RXVChmp8KQRqeREez9EwJLkJIMx5Z3f8YUSs1wO0?=
 =?us-ascii?Q?PrWk6VSiBFswbnnyYHCpnYYXMl0iiCmQ5bzMkvDULEmyZ5vfiAwK70mGzxnc?=
 =?us-ascii?Q?O9tHkmztiS5OouoKTWg7jA4UHQIffT8XgDMhNCcBfHhaHcys7O37UYK2XYOa?=
 =?us-ascii?Q?cWFamgVae7T7coNIIkF2XlP28iwhQrv6Z0GbV5t37cI9gDvJ/BRxdzUUlwz3?=
 =?us-ascii?Q?Fq6Cg3KZWZ67/zsdJhCmlON7W1OmBBYK5PHPk+Awb1vy7LdrEIgB+m4J0ZtH?=
 =?us-ascii?Q?i0XHJNlwv7Xxe3jRzr3vY/F6rmSBvakpqNzttIvQ4HAtBq7zW0WHlnx4TD2n?=
 =?us-ascii?Q?kwjY11d7LF7Vr2rVOivej19c3ElUkhYyL6kZ6rl5iYE/TMCnxpj5WqjP8OJr?=
 =?us-ascii?Q?xv/QPfQhTx5x8V+4CFJxEvSbOsmmUjO3tlcMQ65OOWL5BFXjwfB66Vr1gfW0?=
 =?us-ascii?Q?GVB9LOf//o9Vv4yDFfAIfxzrzqzV6CA1hhsTmH5F7kEY/JtbYxCVObWGRc7i?=
 =?us-ascii?Q?q0N64gjIr7oVY5sr8IEEDHzhA43aMjncAEC5NOERN03fnyK/N13PQMv323rr?=
 =?us-ascii?Q?ldyXJXA1mIefQCTWVTWQJq9B0bgdYA6h0EWprB5Q7REDYPpmXcXL2Rf5GlvO?=
 =?us-ascii?Q?FozQzZbFUgSA/z5VCZpeTB1gmsLuolsx52vfIQmUpgL6295M0T6im0SblyQD?=
 =?us-ascii?Q?8EriZMrTdVP15PdYv+7JZRfrSPSeZ7FMh6eiv0cwoMDUy6IekPkDSFIHclbr?=
 =?us-ascii?Q?j5r3Uc20X200rcjzwmUrUjF9BdvZapyLxlyYVyfHGIAA+sQ4i6Sx2rry00Hi?=
 =?us-ascii?Q?ParIGrD9jXeODo7LW9/tLOr41ELmK8/VpKZm/c1zY5qujJ8XlRxPLQZ98vOr?=
 =?us-ascii?Q?9w7pNm1migNVyKznARQfTAooITd6KrVJOWvCgkYyeUBzdz/yN2T0BHRubali?=
 =?us-ascii?Q?M6tWLfbIlvbUHPwNeY7vcANaIITR2UceTFW1RfFzK6pcZXZLunygD7odsusM?=
 =?us-ascii?Q?FEfj9bX4TfnTNkj1dm3zB30HyunF/BSk2tX7ZAPXeRGoS3Tw7JwgGQ1rFXT8?=
 =?us-ascii?Q?crgAzm9RfluCzH8YgbqPKv6tXoyprftjtBdZSIGa3uFp8gA+dS6V6B+KzZu4?=
 =?us-ascii?Q?bjgO5/m+yxTO8QDXlgPUl+IoOWE2W4bQD/QhLM/7GvE5653cH7GkDw1lX9eL?=
 =?us-ascii?Q?V2InnhAvEwyVnF53zICApPkzqwT1CCfxfG9cnTIJrEuKCFHRclmAauoDHuYx?=
 =?us-ascii?Q?ii5W3C/fvzwG0tY3pl3PibrCSmwrA+JAS3/FUdVjQdEqzz3fRo+o17jpdBfH?=
 =?us-ascii?Q?yXRS+aNuS3g=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F3oFK/xD5EnqYH6igLGVAyRmAHsiEqRxISzimtF7QwtosPEZKluCYN1uiCjV?=
 =?us-ascii?Q?MK3jjc0XPUsB3FRZ8zH4MjGQLR0sZH+cucAEPH1FLHgM58hOjRGhbkZiqnVm?=
 =?us-ascii?Q?N2cYKvzyi6353Qjnw/7abNqxaQZOtUW0/iSCalGzrWxInK4fVt9B+1W87N2D?=
 =?us-ascii?Q?sPg3O30dbYzlbT/VyFlKvY6967CFXZjWrwRDgS71dkYYBCMF7wBvcNeSyUfC?=
 =?us-ascii?Q?v9Eand8BfOlG7xW/1gwlahA8Z6iOGM/vu4wQQwFahjiKlu7Q4SF2nui05aNr?=
 =?us-ascii?Q?zTHkbDGToqmseG1tr08U3LkynBdxVyE1mGQhQ6nf7+O/BEB9jhIUNEllpP41?=
 =?us-ascii?Q?76OHUoc3w7uC8oXTykyurm3LnJLLx11Lgim+sOeATEaz5BFW5Z2M7yzVz6w2?=
 =?us-ascii?Q?UlBDz1m5TfzYchPlsf8BaHjQe6PMXgWj58hJ8llYxxy/nA37Yve04Lf1TAoV?=
 =?us-ascii?Q?qsU6b95g8Xe/8LLcSkpZ4menxubXQLnbPiBp3NsQWL/nKms6laKepYQwoWx4?=
 =?us-ascii?Q?dRHbnJYFTYb79x5QOnL2XyfK6P3qgXX9tMouHdNncJle86pHn0PWgsQtZqtf?=
 =?us-ascii?Q?xdGrRDWpZygiDWIxH+zlQXwvRk18uyl2G9oSKJtDOHlH5lFX8fAZzMF1xU6X?=
 =?us-ascii?Q?QVFeQhXTuscxGImlVgVjMt6HKbvSwZT0itK/VZaJSyL1EjNjtWGCn/VqML20?=
 =?us-ascii?Q?5wCQl6zLdAaCVFoyBK6dzlEQEzZPgLnKeJwE0yw+WHy9+SJI4qAAvfbZBzly?=
 =?us-ascii?Q?rEk5bxTn5zC8uV6W9ofFvuBAg6ybKcadPc1I7FDslpw2co2e6ae07JXvEmbE?=
 =?us-ascii?Q?v2Vmkp+nqp/61LaTkjhsSAwYkgG2bkmdoqkLu2/1u3a34S7XLYOhjdMhp6GP?=
 =?us-ascii?Q?lnv99ZDa9PaJLL/A6FVHFcQEmFx7QzNQRa+AO5zkpn73q9E0cRRkjmSuamSw?=
 =?us-ascii?Q?xnsfj1eJfhCu4ClNlNnjTah18EFwL7Gh97IghZr2gNCerNGFBNDRjfQ1WZjK?=
 =?us-ascii?Q?csOX78a8Eez8eIELDiDNnYuOzjMrZlyjX9f6K1MLF+n/pZDTB9cnZqeg38AO?=
 =?us-ascii?Q?x3COIe/FYJ1wZAhUMY73HA4tajb5pgUJ64OeF3xwn/bokNzilEnbRIEbTXMl?=
 =?us-ascii?Q?IgX9IbD6p5LFmMOakKogho8HN6MHH86m2Iy5l4a6HAENATQ8CauKRnf5aJSq?=
 =?us-ascii?Q?UxfvXMGxNYs7yyyKtrsP/cmLKVB56zZjKRcGNx5TJAV0nJeLQSLetrnW1mtU?=
 =?us-ascii?Q?cDulWJ7NNDtNgIyFT9M/KJw/F4ZVRzEtFl+5xiv0Cjw4WEP37KE1NyVlP92R?=
 =?us-ascii?Q?GC3/G6sqLBJ/COSd6zy/oJiVoXDf9F2a5WTXCuUGOkSmbsCpqsPNjv+eOAjs?=
 =?us-ascii?Q?BEr2w3KqXqn66w3BDHs5yc/esD27aQ7MIR60WYkjgLUDB+S3pd4IAV59+ejS?=
 =?us-ascii?Q?Jhkz9D5qLYcbFWhL4N2V52blGY1dYNgfMmsgn2hueXLzDtgmYGOblQPBCRcS?=
 =?us-ascii?Q?+YwQ+4GaQt3wcrY/o8yfNqgAiim87dS0OgjR208l2zeyOvN33Blj6rT9fkMl?=
 =?us-ascii?Q?aLuP+fp70hndZ9NktlCIecRwvGZH5MOOJ1OCN4SR?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ee2c4267-c1f3-49f4-559d-08ddc3419718
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2025 01:47:43.3886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mdSmKvzDf3eYnGzmyS+Jb42EhXmG1n0qR2oKOUgkkfMvKREhIkK9LpiQWF1TcT362RRMqpCF0LGK/NEkZE6+CA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9203
X-OriginatorOrg: intel.com

On Mon, Jul 14, 2025 at 08:46:59AM -0700, Sean Christopherson wrote:
> > > 	folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &is_prepared, &max_order);
> > If max_order > 0 is returned, the next invocation of __kvm_gmem_populate() for
> > GFN+1 will return is_prepared == true.
> 
> I don't see any reason to try and make the current code truly work with hugepages.
> Unless I've misundertood where we stand, the correctness of hugepage support is
Hmm. I thought your stand was to address the AB-BA lock issue which will be
introduced by huge pages, so you moved the get_user_pages() from vendor code to
the common code in guest_memfd :)

> going to depend heavily on the implementation for preparedness.  I.e. trying to
> make this all work with per-folio granulartiy just isn't possible, no?
Ah. I understand now. You mean the right implementation of __kvm_gmem_get_pfn()
should return is_prepared at 4KB granularity rather than per-folio granularity.

So, huge pages still has dependency on the implementation for preparedness.


Will you post code [1][2] to fix non-hugepages first? Or can I pull them to use
as prerequisites for TDX huge page v2?

[1] https://lore.kernel.org/all/aG_pLUlHdYIZ2luh@google.com/
[2] https://lore.kernel.org/all/aHEwT4X0RcfZzHlt@google.com/

Thanks!


