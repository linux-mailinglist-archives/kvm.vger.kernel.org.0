Return-Path: <kvm+bounces-71916-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MLkkBnu4n2mKdQQAu9opvQ
	(envelope-from <kvm+bounces-71916-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 04:05:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A841E1A0509
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 04:05:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9FC8030CC8A2
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 03:03:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FB862D595B;
	Thu, 26 Feb 2026 03:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HsOW6fUP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1C112D21B;
	Thu, 26 Feb 2026 03:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772074987; cv=fail; b=dMrAinaS6zGG8M1QZHlnCCIkLubyyIK+VpBaCnVLWO8ugGu1IaVk5yOpjYmlZ0P0IiOfDZhm4KnXH/GNzgdo3Mnwi8yrC7Gyaa5uM8DxXeaYf1kwlCaGy9hPgiZ/wWjqqlR2PvHHaSmL7qwXq9iXPQMWOg5NtUzBdCoIGWg21j4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772074987; c=relaxed/simple;
	bh=o6Wya+OlTYbjWMDhsCbaSH42SIeVkYpgn3Hr4hC1TcQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=EWVJ9W8hOV784gzWW24zGVj3060L0dPZS12n+VnW30+Co5OD8cGSGLBfpIGptWofrbxiAK7kaMoGwOYsho4hKLpi0KnQvsahSlnQKUuLm04Br+c5qZvqdmuln6H9WEzC6DwjcMrvjaFmimrvknkLoTGohl6N23hoOEbjx5jHwbg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HsOW6fUP; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772074987; x=1803610987;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=o6Wya+OlTYbjWMDhsCbaSH42SIeVkYpgn3Hr4hC1TcQ=;
  b=HsOW6fUPfNu8Ttk99ESNXhZbZ55nJO0vhosVy4dPW1hXSeq25531RJFD
   1V/5Jt4Obx8WJDkeZF+3yyDkQbIicWDDHMvnOdpQYL4hMWgBWzHUfhDDQ
   TvKWMBupe2/j7dBY+Mi6m7Jfy9FkTafnlIZIP4tqKXUqcJ8VlnGpyGdb1
   EI37urp8ccK4se4289oix+dA1blV69vMb0/GsyNAYOwaZmC84P1th8An2
   MD+3Q5USIrki98YFwFM1Mn3L8xtfcfCN0L76TlSy/sZp8Q1kJAcIJtCbW
   pei7oG3cYKBUnPjNLhFg6Rc5sN/xU0qCLc8VCW+HbCIt1Kkz5/2Ci6vRf
   g==;
X-CSE-ConnectionGUID: +SZvAvvcQYK7AYcHvjdAmw==
X-CSE-MsgGUID: sFmzNXrFTVmNRtCTEr5Nkw==
X-IronPort-AV: E=McAfee;i="6800,10657,11712"; a="60699529"
X-IronPort-AV: E=Sophos;i="6.21,311,1763452800"; 
   d="scan'208";a="60699529"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2026 19:03:06 -0800
X-CSE-ConnectionGUID: y7EspVIjQKWo6GrLnCBiQQ==
X-CSE-MsgGUID: E57HJcC7Q/2rGilDe6s2ZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,311,1763452800"; 
   d="scan'208";a="216567500"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2026 19:03:05 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 25 Feb 2026 19:03:05 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 25 Feb 2026 19:03:05 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.31) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 25 Feb 2026 19:03:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mKlwX734glJG1oOOVb+FGjUOhtblHgGVZAX4TP9GnD7BsvN+LHz+ucIaqUiqtFbTwFYdT8IsLMGEI5PdSxyfZse3qTYeXiKFBOYxXv/URmNAXW19Q8DmlCaYavF2ij8w+kJ5oBxCGPoCfSnytb1YX/1VXmbXt46bvuJ0SHfhY78s7LqNPcfnytUmJdwIo0hlt9MEtclF5TTCnFrBgXMULvk1lI8TmIsCENhbLD9wCcucVIWd5ohb9WuT1Cy0m5pRxzasbtUculYdB9019rZx5t3+nux6JEQQPseIiAtB+j326noVDutbubU/w9Ewu1JlZqBLGMx/1gfWD8qCuLEA6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0l2jGIVYKIkSlpwqxYXBeoJeWOF7Ahhj4iqPcFdXr+w=;
 b=opFM2x/Zgo2zo+nTENeWk8sVZ/fGuxRp7NRfvEfBkel1UXbQplHifgSDjUIMD9I7b8GsnQOW14LkDJbs1WFxAEfIDZvEzif3GMwESBC0QbvrD94Koq60bnQNV+bbCgyHBKLZyCetlixwiHGgVggfJeCczb7pIrP3eN6RPnrZqZSyO0giivrj5otrlK0/WkJyaOaC3G0s5bk4lZ/N1Z06bNE6rX9XMOYQULz+hKYuB5HnrBTxnyROwINxmIPrNOFEGxVQvTXRB1URjmZZe3YeR0A1qXtLzfDp+ebvH/fdSYnU1IhjpdaKc1wUrU7plL9SDE0FBfrE9+QJU9MLHTJafw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA1PR11MB7386.namprd11.prod.outlook.com (2603:10b6:208:422::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.13; Thu, 26 Feb
 2026 03:02:59 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9654.007; Thu, 26 Feb 2026
 03:02:59 +0000
Date: Thu, 26 Feb 2026 11:02:44 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "sagis@google.com" <sagis@google.com>, "Duan,
 Zhenzhong" <zhenzhong.duan@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "paulmck@kernel.org" <paulmck@kernel.org>,
	"tglx@kernel.org" <tglx@kernel.org>, "yilun.xu@linux.intel.com"
	<yilun.xu@linux.intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v4 21/24] x86/virt/tdx: Avoid updates during
 update-sensitive operations
Message-ID: <aZ+31DJr0cI7v8C9@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
 <20260212143606.534586-22-chao.gao@intel.com>
 <a0a5301140be5a3d944b1c91914b93017af026fb.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a0a5301140be5a3d944b1c91914b93017af026fb.camel@intel.com>
X-ClientProxiedBy: SI2PR01CA0028.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::21) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA1PR11MB7386:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b7e60d3-7288-4e91-5558-08de74e38c38
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: aCwIk45nelGuTZhPIIzbKBAKc9m4feH+TkrNreIhUsMDiKUXchBcr01oELd7ytb8JINUEu66Leofee7wqD/CLwNBlLHGdilsuCV2t/xTmAMp9jvbGym3hBWqiG0IhO9YXwnUTgKEnBBolrU7ZO/HuX2n61OiJC0D9Abx+phcr2KRCjFSFeZ0gh0ubSMmAuN8FgUdoEN0lmkIE+R9NbbVyfY+xdZA6M7RBgZ7+ORNc4rGqQXteU9rai69C7peZRXc04iwK6wQkzssyF2HYZaiP+5iDw0m9XCvv8Ds/vzoY1JUDm7s4tzVIIiFoOmWHKJMm0fbUERt6Apr/Vh9fpOvveYRJCjFktkpbHQUDEHVOL5bPOZuTR3FzpBF7Ec2rsJSRWF6gyccZe/7t259uC2BUqXjjeK8YvxbEB49s9toLDB6akUZd/uo2zjl/1zlNfCYDcvZRIJdREbTwCiZvKTlDeIx5azzyMn5Fw7R4f6iRy/EQ+D08m+RiWQRMOKvK4U6sAujDGAvpUl8BOSO6xlcf4ph30d9LZAATCKm2OzKr987y1AA+y0KxK+sS6OuZfGwz1p/o79wqZnQ3CPhgNsjrbXK4w/f7cg34P7P3gtE29wKElkliT0l7HZOuXW75P8Bvmbvg59dlXJeVJVSzLD7M12JOAg0UTZrBffCn4vJlcMv2ekhzu+CIc/iY8G79mIsJQSSfnGHNMXXb4wZ2osmNW0CLX7JDkfNmrT5E+2xJ8E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JTt1Cuz8qCDePDCd83USF/82C2s/TAclUd7rjw0TBsyEangnWkeZ6PzeFeA4?=
 =?us-ascii?Q?Uvc8fVpImQ12ZDokDgjb+iHGpta3e6hJ7XdhqzwBcgtK+7gQmdJDJ32k3TjH?=
 =?us-ascii?Q?huA0EC/e0Dyty4fF1x5Fgq1esJt+6n87k2TV5xhHs1zoQn0+ObWz3Hp3933t?=
 =?us-ascii?Q?fqDK1upeI7NW8YLWNDP7GCVLHIlVRI4SPI9pYhnD6pM1wg9p7UO3K3l3t/1a?=
 =?us-ascii?Q?/TEwMRakn8Q4GJc857x3pgSXXFdgY654SjX/tEgKxwXuRElbXvEZgU4463/1?=
 =?us-ascii?Q?cGQgHWg3uov/32L4Fk4mP093upyKYwFrquydOxk05HphxBnuGVkplhvANfCO?=
 =?us-ascii?Q?D+/tYMZhhWV1JsMGThMfxZfXS2UnRXHW2Gw6h82HpBfEQxzFRXD5FpfSwUni?=
 =?us-ascii?Q?9adv7O0tPf58R54D7tQanEYumVXy8GaToFRJK2hadeq3FRBHPST0YYiBeDA1?=
 =?us-ascii?Q?rgCgvs5jjWaqXidiqBXDy27NCodnJCdAGBa4gmqAQH0awdcASB/LtZEVM2bE?=
 =?us-ascii?Q?qn/E8TyCgmNPA6xUSkZHcEMv3JLXSjD+wYsTE8Wh2anGUaVhcpdXN6MMtas9?=
 =?us-ascii?Q?7MDjQrChbzN3kUaZO/kiR3aapu195xc3w2w574LRd4KR8kSSbg4Furkf1gTe?=
 =?us-ascii?Q?+TtjRhKGKkfHxtIwgo6jPncBD+2pmkfdGZJj3iqhFyAdVl1Ve0IZSElIFn6k?=
 =?us-ascii?Q?76yKgIcc4kMNwkgFJ4P4LBcmf7YyBv98EqM4DkAxqHvc1f7STIs1M53SyqkT?=
 =?us-ascii?Q?EAFg9dvf9MTLAYT3/ggtRZrBmNHNW55BKd0ACN3CXUyphX6O/sqRZJrQDvHD?=
 =?us-ascii?Q?uXUfJObUUEuUJKE+1MFbr3l8tzjzru04DAfIIzDbHYkQv6X+oVUkV8SOJIUb?=
 =?us-ascii?Q?tgxuc0EfDfd+A44OE6yCts9Rtozfe1XeMkmOvnAbO6jBhwmeXR47PcWqhisv?=
 =?us-ascii?Q?bHnVCMAX3asKnbQQQMV5tOS0oqG4jtcH0PTOG9tsXovtSUCYgnC+2aums9NA?=
 =?us-ascii?Q?WksyViNQw29JQFqrS2uS8i1I2wSs9Hr12IS9tQITJnLLWjKeFlhl8Bp/4BHB?=
 =?us-ascii?Q?XJVjbzkYXX9fmHDvlxXMTNhQArE2441UTgd/fFsOKSvRsGTOEDqE8Z7Q1p3G?=
 =?us-ascii?Q?MLL9ls7X3evm5lBa7gwZwOP6Firc6mLIW/7ZZeuY/kVMSBQZbOKIbquHJrPZ?=
 =?us-ascii?Q?6OYOtviXoPUlEVpEeoJAoqbSMBT5wvKpBcmIsfGFGoApNWFEvz5toY1Cdymd?=
 =?us-ascii?Q?YgsWxO+bGxARy8rQ4USEVL1llyS0w6bXUlhB7jcH5RWVZaZMSdNBpt2kmMW8?=
 =?us-ascii?Q?b+1VquyBMTGi/jwtjRksPX3phDyVBA82n1OdfH5SSDR+Qk/dOx4U4MAew1wF?=
 =?us-ascii?Q?kUex9GquUMmYj9kxc6cv0J07xYKR4vkP3oJa38X02k/5BChCK54Hy+xYcECm?=
 =?us-ascii?Q?qB4lM64keSGW3S9EqqfFq96p79wlXTNqt6H/gLHM+w7WEAmNB/Fr2POMGFcl?=
 =?us-ascii?Q?QacZILsfsmbH4uqtyjLfIdiQJn6KRfJ1tFcQIEweOHGahM5iQEHqbaNoGVDl?=
 =?us-ascii?Q?Xm3lRYyk/IXa9fa+8qNsJRchDdeqGtbimmFrV1kAqMStvcu3ssxnQIaECEwl?=
 =?us-ascii?Q?bN2CHAl2VwGDt8vTFw/E59uCY9Q99Na9refIAf6k1m3dn3a1SphEJa5DDwVr?=
 =?us-ascii?Q?2Er75IVU4HoxBOVbvgbmMzb7exvVOOmYQq52bcMGJ+h2wgq9S0QPgk86Zpmc?=
 =?us-ascii?Q?0wVjOrjFAA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b7e60d3-7288-4e91-5558-08de74e38c38
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 03:02:59.5135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9gI/3anieWMo4TlZT9vyuj1wjlwZfD+lqE1ZVkTJxI8vmG/FHfjwNXZs9D7P2JlVgCnwjJ0ypW2bDB9SwkteHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7386
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71916-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	RCPT_COUNT_TWELVE(0.00)[26];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: A841E1A0509
X-Rspamd-Action: no action

>>  int tdx_module_shutdown(void)
>>  {
>>  	struct tdx_module_args args = {};
>> -	int ret, cpu;
>> +	u64 ret;
>> +	int cpu;
>>  
>>  	/*
>>  	 * Shut down the TDX Module and prepare handoff data for the next
>> @@ -1189,9 +1192,21 @@ int tdx_module_shutdown(void)
>>  	 * modules as new modules likely have higher handoff version.
>>  	 */
>>  	args.rcx = tdx_sysinfo.handoff.module_hv;
>> -	ret = seamcall_prerr(TDH_SYS_SHUTDOWN, &args);
>> -	if (ret)
>> -		return ret;
>> +
>> +	if (tdx_supports_update_compatibility(&tdx_sysinfo))
>> +		args.rcx |= TDX_SYS_SHUTDOWN_AVOID_COMPAT_SENSITIVE;
>> +
>> +	ret = seamcall(TDH_SYS_SHUTDOWN, &args);
>> +
>> +	/*
>> +	 * Return -EBUSY to signal that there is one or more ongoing flows
>> +	 * which may not be compatible with an updated TDX module, so that
>> +	 * userspace can retry on this error.
>> +	 */
>> +	if ((ret & TDX_SEAMCALL_STATUS_MASK) == TDX_UPDATE_COMPAT_SENSITIVE)
>> +		return -EBUSY;
>> +	else if (ret)
>> +		return -EIO;
>> 
>
>The changelog says "doing nothing" isn't an option, and we need to depend on
>TDH.SYS.SHUTDOWN to catch such incompatibilities.
>
>To me this means we cannot support module update if TDH.SYS.SHUTDOWN doesn't
>support this "AVOID_COMPAT_SENSITIVE" feature, because w/o it we cannot tell
>whether the update is happening during any sensitive operation.
>

Good point.

I'm fine with disabling updates in this case. The only concern is that it would
block even perfectly compatible updates, but this only impacts a few older
modules, so it shouldn't be a big problem. And the value of supporting old
modules will also diminish over time.

But IMO, the kernel's incompatibility check is intentionally best effort, not a
guarantee. For example, the kernel doesn't verify if the module update is
compatible with the CPU or P-SEAMLDR. So non-compatible updates may slip through
anyway, and the expectation for users is "run non-compatible updates at their
own risk". Given this, allowing updates when one incompatibility check is
not supported (i.e., AVOID_COMPAT_SENSITIVE) is also acceptable. At minimum,
users can choose not to perform updates if the module lacks
AVOID_COMPAT_SENSITIVE support.

I'm fine with either approach, but slightly prefer disabling updates in
this case. Let's see if anyone has strong opinions on this.

