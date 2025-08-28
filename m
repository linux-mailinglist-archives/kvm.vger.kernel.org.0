Return-Path: <kvm+bounces-56129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E6E8B3A44C
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 17:25:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C45C317EC4C
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 15:22:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA1FF222578;
	Thu, 28 Aug 2025 15:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RZwz8TAG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F1B27735;
	Thu, 28 Aug 2025 15:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756394514; cv=fail; b=gAHX8FwC0UUGMNVxpxk2kaUm2w3I1aon4/CoR48sW2zgs1IIcTrHMJi4X3BrOHIjfiFmA40FNAXlDNj2V2b75AOdUtOmzVN9lE8PZpfQOm+D/X8kSwobn94q4AmfqgFg9Fspk4GIQmcrFEC6zgKkK1YDqe6pirFrUQLhv2DviEA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756394514; c=relaxed/simple;
	bh=rVJJj9foEsso1KLz16LjZekdXVQimLfgQ40rfd1a7To=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OJyYLr1OVDIQrRjMFCFUGUzcBADTozoTnLzpN1MVXjWeAglKRFdd4MJ+fdVVWkG6eiY2man/nQ+FLobHaRPzgEBm0bVS3K9Ih/+WJI2d0+oN1ZDhFXXCYED8vZToW/0tnAbc5u+Jk9+8gWliNO7u78EoDEQ1Jl72ty15XSlTB5s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RZwz8TAG; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756394513; x=1787930513;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=rVJJj9foEsso1KLz16LjZekdXVQimLfgQ40rfd1a7To=;
  b=RZwz8TAG3sgxT1kbK5dOpUgo53jWTS3jwpgQ2li3YK5dQab4nnK0NK9w
   FJonFoX2ICiL2clsJAqJSBFVCUzYdIFIq44TQGwVLVsCyy45D6vfjbS9c
   2Awnxtf5Qabxg7XN3ctCXNxBy3XkG1dwCCJoTTVyWH2X5LKmn27jjRdxm
   Hnhss5KdeF+hUZjzmBietqYO2FZ6lD5S7uRA8jUOQyvBPlGrVtsn9PVkx
   sa8iaGmqwgzEGiuLP2pA0Dlm5FnZ3LQrQj0V02DOyySbXnvCE2lwUG4Ot
   yPKjyqnJOKnUExCe/H6RfLwexBMlXGXGfXz8xjI2RJclTtPuv1aH/eYHO
   A==;
X-CSE-ConnectionGUID: iNmyKAg6TKefiMY2hISSSw==
X-CSE-MsgGUID: VK3Ji/9gSOmmIKHHGLYYrg==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="58520158"
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="58520158"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 08:21:52 -0700
X-CSE-ConnectionGUID: ELl+IIuoQsCwrOTmwFMcrg==
X-CSE-MsgGUID: sMDb8kH1SuSpv+0uu2ndUg==
X-ExtLoop1: 1
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 08:21:51 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 08:21:50 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 08:21:50 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.49)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 08:21:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CO2fLd7F9i6J9EDPj8oQ+4MJfNEwlYh9eHirgMtUhLKwI7qybqj1QEehSvSG98/R38+Uw49ITYb7yZPCtU1GC9eO9rUI7XRxY9cUewrdU+kICYLAsR06BpB9pLVV1qsOzfog2/N59ObwrdismreTAxOtVTAFBUBEnGSLEMnnGqWnFqcss0SULxh36EcSW+jAPLrqABTT4MQxqfumCt4doLrLl1XHSXCbdIZIdWvHErr212xP2waIsY6lKvQpgkJkRLgLrjDt2mF5Ca/t2Ef/lGPaQsglcyryqOZwK9H8poy8UHOEn8i3nMW0z2HrEhXlGxoxmnDVd5C72ISvlWzrNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ww20jqXz9AdHi+HNRI2xQRkZImXNDioj0iQShWDFFU0=;
 b=t8YTJ/BwvLiz/MHYuP2VH1fjARljC6tr0R9XYiwz5A72/45hFT6OAU81fx0aelq+twgrznngIFWEhx9WP0w5YFw6LSyZ62jp7uEM6M3Ezfyfpp1HYiK8smGdbPecC7g8oeEoEh0VnqfOfTVzcKqC3jzc/PKRNl0XjoiMAXPF6IWQ/Yuotzk/WYEMEodyE/KhWE1mB2jK1QLiFT70a2GxLZ01fHdlwE8PT/Z2bRSafhaw8RvOizf8QJL7swQBlpLFAyeuikXb/8IdQG7RK+13orywmo7B3ngxTsLryPd+bg3VU404sOx3UVVpOs9g4Zp/Yb4VwYxtjwCWmmEzli0MNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by SA0PR11MB7159.namprd11.prod.outlook.com
 (2603:10b6:806:24b::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.15; Thu, 28 Aug
 2025 15:21:41 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa%7]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 15:21:41 +0000
Date: Thu, 28 Aug 2025 10:23:28 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Michael Roth
	<michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, Ira Weiny
	<ira.weiny@intel.com>, Vishal Annapurve <vannapurve@google.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>
Subject: Re: [RFC PATCH 12/12] KVM: TDX: Rename nr_premapped to
 nr_pending_tdh_mem_page_adds
Message-ID: <68b07470d9f26_21148294b5@iweiny-mobl.notmuch>
References: <20250827000522.4022426-1-seanjc@google.com>
 <20250827000522.4022426-13-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250827000522.4022426-13-seanjc@google.com>
X-ClientProxiedBy: MW3PR06CA0019.namprd06.prod.outlook.com
 (2603:10b6:303:2a::24) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|SA0PR11MB7159:EE_
X-MS-Office365-Filtering-Correlation-Id: d6585efb-d55f-4397-bc5d-08dde64696dc
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?wsMFNL4+U/H089jBamO1oGBELXqaBp9XXWwcu8wyeHeRWfx2AXtC1LfgB901?=
 =?us-ascii?Q?HnzXUjGY2NKucsRovo4Nh9xg+gLg9zbBE4BUy8rHMjo70B/D/NYMXyKr5cgt?=
 =?us-ascii?Q?G51/LZjUU2Ts8NJ5g+dxxGJ7aKZpQzYFIYOXuV5LS1vUVJt+WSJvLS8sYYuG?=
 =?us-ascii?Q?+CyZW/DAYzHc3HBQkeDXDqGi/b33RwZxaE8k24tFfPlG8Ey4fj5yjaWgoITt?=
 =?us-ascii?Q?6ValqQLMmYzgyQa9Sc9MVjwotNGTCGeXYU3OMuZixckL81IQMyQftj9ZkLyv?=
 =?us-ascii?Q?JkXuIwmbI6sxkHehki3fJRDDIVMNGyWqVL4TXb93DldkwVwDwTb7duOixY69?=
 =?us-ascii?Q?O9Wx8PXScXo5vu1OuwzAKmbsynHFmbLfhklnsYA6v2DCBBULC20m/PNNddZS?=
 =?us-ascii?Q?VkPG7rOut9FOQS5UOyFaIBztFP5sQ9Lcn0FZI1wblAU2itxMyA9v9XTu/V3K?=
 =?us-ascii?Q?xnCa+3uRT3BuUPcMS7i8yQK+Qz1yrUoW/UcAPmmmv7wCgQBAOA44zv0hOfwo?=
 =?us-ascii?Q?uUoEb9kfepRNAs7vC2sE7w0DYQ9992J7I8+8FL0NrC/JQomw1qchdwMfUHqX?=
 =?us-ascii?Q?J76cu8eZGfF6G0ZoZdVcTVV3esi0JPjY+UZTYckNe5XTjPqQ25nM3sWkanqN?=
 =?us-ascii?Q?gC3zjOMy1DVo5TCrAQM0s5+EfIdxOXizDmnL0zUjCmVFiD1JLVpVh0w2YDO6?=
 =?us-ascii?Q?50B7doEuZoIy/OQhR9Ny4bA8dgcKU1G6cS09tVBUBjf3Cx5hpm9K5Ow4WKPh?=
 =?us-ascii?Q?/srpx2WhaJl6g6zyUQNnTjhrVqZErUxpSsiUalyCAXc316MboElNWgQh3uic?=
 =?us-ascii?Q?YcBqc4AYk14jBzUz3gOS9Z5b3PQWywKbdxOUJSxYgtXG+54ABKe5gsa+ZT6l?=
 =?us-ascii?Q?JWtV0c7IPZGVHU02tLhnvS85X60Gkk+GmY12MGbXEfAg/xygcQFjWojduAoZ?=
 =?us-ascii?Q?GyOmXdBLW802uwOADOoPXBqXjKtUBYk4/0jawo5/powlLulu9WDCiu6mW9lq?=
 =?us-ascii?Q?1zhhiP66LUDGKOatnS1K/OV8T+cSKkj5WWXD9ZpwNMZ4/jsvHpX43ma76lA5?=
 =?us-ascii?Q?GuQZFhTdZrt2eD9xweIakWCUsQ2B+RulHMtetiTkf3yG7BlP/PpvsCyPwDKB?=
 =?us-ascii?Q?HGzmpU35a5bsvDq9MkRnUuB87hDIHObg7et9/EG+GbuxvjMmwO5Mw0pVPX/s?=
 =?us-ascii?Q?zkhcgk5Cuduze7URoRH5I6gLT589MEgnAjx9NTA7FIDuWvZSnhuk9A0nkhQg?=
 =?us-ascii?Q?a/mkQPMzfLvFHT+vsOu2n9jccFAebQ0QpX8nVhXDP438654YjamRnI4siR92?=
 =?us-ascii?Q?wknESIKrdPmzDkjp2NvTKhwSstZMciXMXt9alr9aLX2fNiISXKLJ18AnJ+VG?=
 =?us-ascii?Q?NjxOrpkQTz1e9eFW2mB9bkPxknMi70DFVWVaUAEahGZ/EYovkQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qlaUhZi4F1iIQfRz42xVMOfmzI06TQ9M98ng2t6sjHPnWP6mtR5MUcW2MVgG?=
 =?us-ascii?Q?RPy+KuzuATMpmah208Lj3/UhgRjhBb3fk2QacdZJ1WaYSp4V6/X3WV37/zry?=
 =?us-ascii?Q?+skBJ5PE9vzdo9q05R6HTJ266qjnVeudruNg0XxLHf51jMP7oh2OFC7a3v3O?=
 =?us-ascii?Q?7konAR+UDVsoAARUQXVbIyPjdmnhODqxlXsBJ27u/XNAdTEYjwsPOdQWbkCQ?=
 =?us-ascii?Q?dO7mV85R0HZEhQ3O1sJJ9eVfWTjJtpTjsrGcXvtsdWggEOUoENHj6xT7z1dS?=
 =?us-ascii?Q?gAD1H3uGcUKnXLm01kZec5O9tlS0GXXn1YA9QwihzwAlK/6dshfq7hEDwJL9?=
 =?us-ascii?Q?L2TB+74FjVu8ChellkvDMWV/V6MMlgqg9hbqCwAoL0jRCrY6MX0VvlH/9Dc0?=
 =?us-ascii?Q?KY0mI3KPkYLI99AqYXhscrr84INqeOIPP1jfzcBDv/a7XJfOxdV35x2pCz+l?=
 =?us-ascii?Q?MONtXi5RY23lyGjfcb59F/h3EwFcMhNLmF7R2ttImtVWm3kN/VGeyCHOu/Oi?=
 =?us-ascii?Q?ZszMan9mBsrhdqvKY8ESeg0Sqb0yJM3dymiB+RrsqQ9+drSv1Fh3S2EcxP88?=
 =?us-ascii?Q?ux9HhygitX4Bt0Khec8yYuaGY4JHc0Qwr5P7Uj6szcPV+F64hfdQf2xehoNE?=
 =?us-ascii?Q?ia3oHogR+mr+UWAVhDVJvbEeWRkZgmNSqGty2+yDJbxgRS8FGbwZUdY8FrTs?=
 =?us-ascii?Q?y8HxjKTY+2K2+oyKIzCk0Zmape40F/RCqoEhtgKsgd5QVzOz9krv7ShB43Tt?=
 =?us-ascii?Q?n3+qcaa3rgZQrqCe/EXdNVuPt3gmd6H23hQY340kskEXRoKqHg47yrlHIki/?=
 =?us-ascii?Q?I6/52KCJfxr8GSn7hpJK4QhAAkj1HistA5uTy8f9eUyrV1SRcoGlFF7tC0vl?=
 =?us-ascii?Q?d62GZ30ULci9Rb74l3xtKcd6Qmd9Prtki9JgKbLOf12co1/BFqZ+p54qAVDF?=
 =?us-ascii?Q?jPA61+murwh+et38/xZh4XVLxiuJ2RXharCgNxrDWJwreNoxzdL5wMS9B0d3?=
 =?us-ascii?Q?ybaPTA76aTxknTsx4FkE5SQzYU/rXgJMl1nBCBa0vKE/axJ0q79QFnWVn16L?=
 =?us-ascii?Q?iScJhnHyeAJJGTeCd3u6cX1We61SQ7gIxUIMsy6qM4GdGDPCTXWggFsg7ZN4?=
 =?us-ascii?Q?DEXDJJUlLRLOVzD1z5rCELF0njfkVluwLmmbrl2Dux2sdI0MbTuHnaHVbN5u?=
 =?us-ascii?Q?TJI68tfIqBXQSNPfIAWs4La9dX8T8lOcW15DNL/fBkfnjjFecUxrGzaf1/LZ?=
 =?us-ascii?Q?RMVniCZieBhbqvaBslJyorfXyl4FgEAdETWHskonkKgJvrRvOXFci5+QeT9X?=
 =?us-ascii?Q?Cjg6J/Iz5wR01uDuda1YzsL43F904ROkIAss4uzRRc145ACBqYax+g1r++mJ?=
 =?us-ascii?Q?/e/H5ycoQjVG0XGPXeLo5n+bv30GtZBwCVXPpOz4A+1P3zoZkJUDAWTQ1JHv?=
 =?us-ascii?Q?9AOyaijd6QtwDRbm0k9YiDsh18gOTyE6IJlD6sLgM6JZjjbKOYZFTaNYLf1U?=
 =?us-ascii?Q?OCRwWWoyIfZfqetS3SOJmnkF86BAOVzAj0cBU6DUy51277kgWS5oiXmr4MYB?=
 =?us-ascii?Q?bGmL7Po/sc1T0H6IXDMyrdJ6LDvC/K65DkdD/GTA?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d6585efb-d55f-4397-bc5d-08dde64696dc
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 15:21:41.1087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jqXCg2Gb+1EYxyfLWx4Q5b2Xe5NMPjBrhM+43aHgbrchSoDG8lJH4ssQ3vyhQFnqxI/J71ji/pt9dreNDMIKlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB7159
X-OriginatorOrg: intel.com

Sean Christopherson wrote:
> Rename "nr_premapped" to an asurdly verbose "nr_pending_tdh_mem_page_adds"
> to make it explicitly clear what the counter tracks.  "pre-map" is far
> too similar to "pre-fault", especially since tdx_sept_set_private_spte()
> deals with both "pre_fault_allowed" and the counter.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

[snip]

