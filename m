Return-Path: <kvm+bounces-69553-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CBYCK251e2mMEgIAu9opvQ
	(envelope-from <kvm+bounces-69553-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 15:57:50 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 26914B1396
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 15:57:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2DC9A3032770
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 14:56:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAC9E334C10;
	Thu, 29 Jan 2026 14:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UXjSE4f9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7490819F137;
	Thu, 29 Jan 2026 14:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769698574; cv=fail; b=hQC7q+jiXAM8C4fEOM9jn6dohsQL+GmD8XBrOfiRiEdnhKuyLwgJKALRG+OThy2JOyixTrMVV8RKh1kUPmEAGWgeehl5bJ8QUTAnVQJT0RbMTKefjjgk6aT5JedawpXIXryGzKrrQN4vtFB2A64oAPAEbYy51vp90H4Yol+dY3k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769698574; c=relaxed/simple;
	bh=SOmjdo5Uh5MytXxjs05ZWCdQMc15Dbf/2n2zP41M95w=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dgydvBcsvee7spS4hDXfq1FwVnHE40Tei5t959LZa5yfbIk9v0FquUpNdtfXLIFVYiYbXB0GBlSCs/SA/iCs5qmtcbFoVJz8FuJ31qZzKcbP4fBf33C/3ku4bE+MtKK+E9bWlZXvATJl65t28fcgKWOx6AppFZiBMXf3oOlTTxM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UXjSE4f9; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769698572; x=1801234572;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=SOmjdo5Uh5MytXxjs05ZWCdQMc15Dbf/2n2zP41M95w=;
  b=UXjSE4f9q1QxobafOOF8cPGMFHW7CLCGNiHgQq09obUJ6jIS11yzZjs9
   2LqjGmblbtBuZNE+NKGEzYFyfTOJfgB3d3HTH1rPhWuhBvm3Nxn2dMIs+
   9TEFwkqPtwAAOaKQFTkq4b00moaF0G7Cj/l9SnsctV5rT7uq298wqd0Tl
   z0I4Z5GOaxakFdgpLYAevWWSSk0pVZy3CgX6QEgl9GDaxIXvKvIBaeOQ8
   VihlOhMWsV+j7AjkuZ28AGutjrggYJo7dc3x9KGy9ejybBtkDllyAOR6I
   4XmXXxSScbhd70R+p3jKOenX7idEBgaVEbytSbam+loMOk1mAHfdfWOwL
   A==;
X-CSE-ConnectionGUID: wDqdBth6TK2QxvpSs28nKA==
X-CSE-MsgGUID: yQ1ZSr5CRFankvJ9u4fNEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="73532606"
X-IronPort-AV: E=Sophos;i="6.21,261,1763452800"; 
   d="scan'208";a="73532606"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 06:56:11 -0800
X-CSE-ConnectionGUID: +d/aCetgSsy4uthyL5MMpQ==
X-CSE-MsgGUID: XgulNgU9Td+fVNK+yh824w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,261,1763452800"; 
   d="scan'208";a="207840530"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 06:56:11 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 29 Jan 2026 06:56:11 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 29 Jan 2026 06:56:11 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.12) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 29 Jan 2026 06:56:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=roBCW5+gYW3+yflOwyejqh2KzkHkIC/1Ct3rbxEVbgwXk+5j5RTA7KY6pPBgrk0WPZVK9yvxoBMvOFVvq3n8XzvfdEySaqcGpsGQGKt6xGO5rAXhVl9+/tX0i8rUMsY/2gEefju5EalMQmp7uLVNIJIE7HNx9Nlu/Rf4fmFYYHyxxBiunwmtlSQa5p3HaYI2aSdEd2PvXxCjXk69MW6vBYvixV+9GSEXWI1hvOmW+DraBP9+XOAVdIQ5uEQXMVa+Qi0ztqctCULO5I24D3sy0eLIaMj4hWeSYLZKSsb83kgqsko6azncXKY72LL+Oy20ZshoogBVQbZLU6D0WobkXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ejctOmguQEVgabs2lylf8Dr90iQNXr3fuuKRTgp0doA=;
 b=y+/MHmVoNy+vUTNl4Nbcj7HN4Wh6qfF0ovvK3UEbGlnlFxLJvl7LIp8SrzHgxok5aE6Na0uiIFU8EQYT0xKJB9jcVc89uXPGN2ktTp919O+ZpifpLTEpB0PuHVyQ5VhGxvGPJ4OCy3wEOxtTJw6u1RZTv5UbfITC8/V1fEE9a0RLuYc8FmzTMjz1J1BZVPUtMlgQgikqoCR3zU96sdOI/Fexb81GoRjGRlUpe2sB6jJGkl/a2mZZYKJhllOWv1NLu8WDHK09ja3RZs/a5xBFPpf3Mun9iSK0UCqPGrQA5r2YF02p6O+BJzi6UwrUvFCfDIM4ru0UYJXFo3I+CWQHLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA1PR11MB6196.namprd11.prod.outlook.com (2603:10b6:208:3e8::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Thu, 29 Jan
 2026 14:56:06 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9564.006; Thu, 29 Jan 2026
 14:56:06 +0000
Date: Thu, 29 Jan 2026 22:55:54 +0800
From: Chao Gao <chao.gao@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <x86@kernel.org>, <reinette.chatre@intel.com>,
	<ira.weiny@intel.com>, <kai.huang@intel.com>, <dan.j.williams@intel.com>,
	<yilun.xu@linux.intel.com>, <sagis@google.com>, <vannapurve@google.com>,
	<paulmck@kernel.org>, <nik.borisov@suse.com>, <zhenzhong.duan@intel.com>,
	<seanjc@google.com>, <rick.p.edgecombe@intel.com>, <kas@kernel.org>,
	<dave.hansen@linux.intel.com>, <vishal.l.verma@intel.com>, Farrah Chen
	<farrah.chen@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin"
	<hpa@zytor.com>
Subject: Re: [PATCH v3 06/26] x86/virt/tdx: Prepare to support P-SEAMLDR
 SEAMCALLs
Message-ID: <aXt0+lRvpvf5knKP@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-7-chao.gao@intel.com>
 <e2245231-ee39-40aa-bfdc-e43419fa30f4@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e2245231-ee39-40aa-bfdc-e43419fa30f4@intel.com>
X-ClientProxiedBy: TY4P286CA0015.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:405:2b0::15) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA1PR11MB6196:EE_
X-MS-Office365-Filtering-Correlation-Id: f9f6e7f4-7af9-47a2-291c-08de5f468780
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?lIl5e+mgDI3cJ8sUIi0DZG8uJKNzlhCnbNHA5idb3Du6w75wAQNEaxUa7Al7?=
 =?us-ascii?Q?JyhtL3WEcaiVltUMYkRtt/fQMLCTAjL3ZNMalSXcZeT8/vUgahwW00Fuzmsr?=
 =?us-ascii?Q?2Uegxfv4pNXLWfEjUIJQInwhZ+V9Rm9ftvWPEXHX2rduquh6VcQ6JG5rDxH8?=
 =?us-ascii?Q?0kq6kEIiZUwO9t2kP+N2MFYZoo0cj+BMsrn7jOeGCddVcIHoAYRUfen4+ADs?=
 =?us-ascii?Q?It/79GjhakpWzZ7uzFRT/tRu+bmKh+pgbJe6ZKnmFV5TaQ/LG1i6sEKsNGm8?=
 =?us-ascii?Q?yDIaIyzzqx8thj8H7HeeiTh9ALJmqA0D3/X9Jv1Ok/ai8lz2dAJZr5rCh27E?=
 =?us-ascii?Q?xSz2zip0AdEgqylJot8VkJsnawpBPZbliOzMB6ah/OnSbBMhVc056RKI/TVF?=
 =?us-ascii?Q?fzGEP/tgijm63QN93HVbWge3pP9GgNKTi/b3/aybsWi80zBRrO2rle5SS3Tt?=
 =?us-ascii?Q?NL/K091kHXbN7NKWOWKvmYtWG3q1KbTdlBMSvgLoiblYXAX5gxdx3YRbwkf+?=
 =?us-ascii?Q?R55dV78DlMtNjIG7R0/wL+CYu54QZBIdtBfRxAin+fJEAS/o3det6ywus4ds?=
 =?us-ascii?Q?gBQ5MQw35Y5Rb1e5nZpARLvxgIFJXMSZ70jFbR54IR0MB1qNFqMmeVuDEmir?=
 =?us-ascii?Q?BF6BbcTAmJwSB5pv3wzwRK1Lc5QCcgUycl0PLgLmD43Yc0blYR59dVKYy5Ll?=
 =?us-ascii?Q?xgv+Pvx5C/r9EfR2K+tJploMmR0wF+aicoGUfqrCbozSjeBozmMizzlWq9ir?=
 =?us-ascii?Q?PTmXm2ifXyzfRk+VIfM676RX5BIOhvl2Nc68xqGOAYsP0GflWIWves50El0C?=
 =?us-ascii?Q?tZ4Eqi3DEEVOMuUKbENeVGj5H0mvZs+HdzpNnY8tbt7rciYp1Li4Mw2BWXN9?=
 =?us-ascii?Q?qZWQ2HsGPrE0nK0AtfaEwpt2PLbd4Lv8750fqeo2iexwCj48rCi7ZfSH8LKb?=
 =?us-ascii?Q?exC5psALNAi7yaz+Ivs353+b++pYU4Srw2CmBEIm71T7mY3iPRQs1ArDJ4Vq?=
 =?us-ascii?Q?EqCFDkZR92Md2KZJJzaA0eyDrt0sOBrQgVlgQKVP1s5yVRAXaR9cBc1HorEg?=
 =?us-ascii?Q?qzZ7i6ELA8C7pS7PQXfKYpLl1QwI0W1PtZX4qln/jhbFzZVXt8h/O3BAL1zP?=
 =?us-ascii?Q?yaqjQZY+enxf3fdwTv1UIe1GkxgVDb4lsj1hO87Lu7dUEvy0Dw1zoFZu+yJJ?=
 =?us-ascii?Q?09IidD8TSbRtxWl8ge1M7qg4Jg37Qvu9yl5IhKVhb8Ji0ZTk1Su8f5KvMGMB?=
 =?us-ascii?Q?FZfCP3g84vDBQpuRf9kYDYiKoAQSOLnf3Dr9PcjooFbAuHf7ENiz11gobh4F?=
 =?us-ascii?Q?y80zE0ZaNbyFvU21PSE5LXuYWHtr1VtIArqCRSplsNnFfvJ9K3+HpisWKa6B?=
 =?us-ascii?Q?aqBw3qpL/rwC6AxZuR2IJkrTZpqnKkKJ2oTpRuKYaPQeDFwj4HB4th7PDw/q?=
 =?us-ascii?Q?XAKn0zLNoSTOt6ihGrghuZNi+NAbYPu9QBKjvAlKePHAOq0iK/xE6N1Ts2Mr?=
 =?us-ascii?Q?vD2NY6FA4S+DzVBuEJHYntdRH5AdA/RvJsjQOzhpJqB6DCDKndPT+l1PCFMs?=
 =?us-ascii?Q?3hIv3+RoQaELFP0JAUY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oefOGF+KM5PZwdJ5bDpcgjByXbGZv2+eVDPgUkAPPRTQQNtl5IkHm1NC31yh?=
 =?us-ascii?Q?3eVmK3YL2Oxmc1r6OwhWsIgNHIIXzLes0e8iLCJDCeHy4qNzDgdFIDI5VCOF?=
 =?us-ascii?Q?K/6ZBx9lQjZxmevUrTJNN/ku2dIu3n9SO1npDcKzSK/WyFQZpga2auqHjQgs?=
 =?us-ascii?Q?VQTnXoVOEyWP88NFQxMyZ6lXrchIYY2CuqEm+1rXblf9vFDihP5IDs6nqjTq?=
 =?us-ascii?Q?jlq4Ath6KscJDfMeNbPsKL/cRRb9CL3OgINZ2S74iinSrh3mv7rD0cWasAs6?=
 =?us-ascii?Q?V3zwm0VjYsfC4wp9i163DzdL0NVY9T3ZyRIHZiO6216jZbJgn14sQTq8ZVF1?=
 =?us-ascii?Q?MusLUDgX7vvrfrEupVRum4Z1xnUWrz3ouTQ4bERxFFFC2Cm4yeHJR89704w3?=
 =?us-ascii?Q?GqrRTGkVbd2OJkvcJQ0H/b9tY8PpAPkzDPQZtlA6oq/HNc1c7HhfIaQlABEB?=
 =?us-ascii?Q?J4+QiGge2QXu6jV02E4xhAcyUKlavsnVMyxY5I2mAu6zr41Hb2uR5J+QxJKZ?=
 =?us-ascii?Q?RbsgXowjME1IryXPrUu8GTVhjtXPRWVCwXGzoCmdmh6lUbJkTxsmZw/i7G38?=
 =?us-ascii?Q?9o7slWU+Ihk/lkzuzjUcynoeX2qiL/46JVsECMfnLlrEGRo1CeQ3jFmxqVuS?=
 =?us-ascii?Q?C3IaH6z8jvOvg/smwDfxKA02/VHl8lTx1o2gGu4fL6aB7xwC0FskvvvVUrse?=
 =?us-ascii?Q?mkWCqRza7n2AURLiLuLf4B+X3L9Wrie1OY3U4k+CwXR22FikMNVWQUl4g3H0?=
 =?us-ascii?Q?7P/AMR/v4TGUroXElilwdirjTAJWkzmwVO6hVlt6EoqGHrCMdkZ1e3MfYIbG?=
 =?us-ascii?Q?H1qU9XDN76UcPyafXpNkxC43FIfcRpX9ffXKxr3oskzqAq/eh286NSSZ0w6e?=
 =?us-ascii?Q?Vl7yn+XqdGKMeLHY7B26q+hI0iLQM9Kqw6PO+bMtYqZ+ol8gZ08Mr8Ukz9fU?=
 =?us-ascii?Q?zSvMp+Jh5M+40p/rscm3nMatTEWDlfSlRtg7RZdzEPGJGD8mea6t91De8Qp1?=
 =?us-ascii?Q?HxWwxyuYinIX9dmS48Ae9YMpQ9QScufRon5d9JNqCefG/xRfegXrEBOgUmww?=
 =?us-ascii?Q?S/L+Zg6shqu2lo2OTxNMzE/CT0dKUA7Dt5k0UOf7PI6tu5X8fIPPJxEUCcPu?=
 =?us-ascii?Q?9CPwcT5+Guwla2tEy62Z9D9CNrAkL7W2o78hzy538WAjOOy2zbCbUa81dpHK?=
 =?us-ascii?Q?y3VxQaHNEgcnPdwRisVjbEdTFmygc0OjxCFldfTFG0GhnwFWMj4RsbIyaAV7?=
 =?us-ascii?Q?L899ZByX5t2bi53v7aNpWWcgH22GZby481M/s3aJ+mke4xtdMZuxa5DSE4gO?=
 =?us-ascii?Q?fEXQHtHX5TIlRhcfQIzDTKnsUmtqEqkeVBWHYuL3o6hzsgU+yVo6PJiFbR8K?=
 =?us-ascii?Q?n0BrK34eeIH007EDHlGclysfFhTx+oA4vL86ZPgL3Ly6a0nvLCtioDCdDNtq?=
 =?us-ascii?Q?wzBQkGBeZ8lH54/GFG2DWhudmbDq2QOvE3GjP1pd4iHI48RHZ61hOxavl21a?=
 =?us-ascii?Q?adMyRvAwHRE/1XLBwp2u6qJqAkFXbfjHIfbfN4TMaj0WDdDjhhD83NaISc7R?=
 =?us-ascii?Q?sU2npEGfMv5E5CoWT65RXiHZQjWv5tyE9R3PjGYLHoxKt1+L8NMY5zKJn7BC?=
 =?us-ascii?Q?ElI5vBnKFOCjO3LmG2k9UugQxEt6OAKwSLAjGBxS0RctZ5iInDGDgT/D1Z1m?=
 =?us-ascii?Q?1N7mlqxkVGq/D0dNsPAuJljp9Cw9a8/5lStY19XS5PcBZul8hLMYoK2uapvU?=
 =?us-ascii?Q?VbB0C/Mhtw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f9f6e7f4-7af9-47a2-291c-08de5f468780
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 14:56:06.0475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NbnA2wIljYAJ+4OCXnYYV0Bzsl8N1h4PWN8zxseGeipFYnsT2FU1eSs8pKLcYF8V9splWmasmutp2U1RC3YkrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6196
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69553-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 26914B1396
X-Rspamd-Action: no action

On Wed, Jan 28, 2026 at 03:03:14PM -0800, Dave Hansen wrote:
>On 1/23/26 06:55, Chao Gao wrote:
>> P-SEAMLDR is another component alongside the TDX module within the
>> protected SEAM range. P-SEAMLDR can update the TDX module at runtime.
>> Software can talk with P-SEAMLDR via SEAMCALLs with the bit 63 of RAX
>> (leaf number) set to 1 (a.k.a P-SEAMLDR SEAMCALLs).
>
>This text kinda bugs me. It's OK, but needs improvement.
>
>First, don't explain the ABI in the changelog. Nobody cares that it's
>bit 63.
>
>
>Background:
>
>	The TDX architecture uses the "SEAMCALL" instruction to
>	communicate with SEAM mode software. Right now, the only SEAM
>	mode software that the kernel communicates with is the TDX
>	module. But, there are actually some components that run in SEAM
>	mode but that are separate from the TDX module: that SEAM
>	loaders. Right now, the only component that communicates with
>	them is the BIOS which loads the TDX module itself at boot. But,
>	to support updating the TDX module, the kernel now needs to be
>	able to talk to one of the the SEAM loaders: the Persistent
>	loader or "P-SEAMLDR".

Thanks. This is much clearer than my version.

One tiny nit: NP-SEAMLDR isn't SEAM mode software. It is an authenticated code
module (ACM).

>
>Then do this part:
>
>> P-SEAMLDR SEAMCALLs differ from SEAMCALLs of the TDX module in terms of
>> error codes and the handling of the current VMCS.
>Except I don't even know how the TDX module handles the current VMCS.
>That probably needs to be in there. Or, it should be brought up in the
>patch itself that implements this. Or, uplifted to the cover letter.

My logic was:

1. The kernel communicates with P-SEAMLDR via SEAMCALL, just like with the TDX
   Module.
2. But P-SEAMLDR SEAMCALLs and TDX Module SEAMCALLs are slightly different.

So we need some tweaks to the low-level helpers to add separate wrappers for
P-SEAMLDR SEAMCALLs.

To me, without mentioning #2, these tweaks in this patch (for separate wrappers
in the next patch) aren't justified.

<snip>

>>  static __always_inline u64 sc_retry(sc_func_t func, u64 fn,
>>  			   struct tdx_module_args *args)
>>  {
>> +	u64 retry_code = TDX_RND_NO_ENTROPY;
>>  	int retry = RDRAND_RETRY_LOOPS;
>>  	u64 ret;
>>  
>> +	if (unlikely(is_seamldr_call(fn)))
>> +		retry_code = SEAMLDR_RND_NO_ENTROPY;
>
>(un)likey() has two uses:
>
>1. It's in performance critical code and compilers have been
>   demonstrated to be generating bad code.
>2. It's in code where it's not obvious what the fast path is
>   and (un)likey() makes the code more readable.
>
>Which one is this?

I think #2 although I am happy to drop "unlikely".

>
>Second, this is nitpicky, but I'd rather this be:
>
>	if (is_seamldr_call(fn))
>		retry_code = SEAMLDR_RND_NO_ENTROPY;
>	else
>		retry_code = TDX_RND_NO_ENTROPY;

Will do.

<snip>

>> +static inline void seamldr_err(u64 fn, u64 err, struct tdx_module_args *args)
>> +{
>> +	/*
>> +	 * Note: P-SEAMLDR leaf numbers are printed in hex as they have
>> +	 * bit 63 set, making them hard to read and understand if printed
>> +	 * in decimal
>> +	 */
>> +	pr_err("P-SEAMLDR (%llx) failed: %#016llx\n", fn, err);
>> +}
>
>Oh, lovely.
>
>Didn't you just propose changing the module SEAMCALL leaf numbers in
>decimal? Isn't it a little crazy to do one in decimal and the other in hex?

Yes, that's crazy. I'll just reuse seamcall_err(), so leaf numbers will be
printed in hex for both the TDX Module and P-SEAMLDR

>
>I'd really rather just see the TDX documentation changed.

I'll submit a request for TDX documentation to display leaf numbers in both hex
and decimal.

>
>But, honestly, I'd probably just leave the thing in hex, drop this hunk,
>and go thwack someone that writes TDX module documentation instead.
>
>>  static __always_inline int sc_retry_prerr(sc_func_t func,
>>  					  sc_err_func_t err_func,
>>  					  u64 fn, struct tdx_module_args *args)
>> @@ -96,4 +119,7 @@ static __always_inline int sc_retry_prerr(sc_func_t func,
>>  #define seamcall_prerr_ret(__fn, __args)					\
>>  	sc_retry_prerr(__seamcall_ret, seamcall_err_ret, (__fn), (__args))
>>  
>> +#define seamldr_prerr(__fn, __args)						\
>> +	sc_retry_prerr(__seamcall, seamldr_err, (__fn), (__args))

This can be dropped if we don't need to add seamldr_err().

