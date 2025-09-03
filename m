Return-Path: <kvm+bounces-56656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id CE4DAB41305
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 05:35:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 763434E2C9F
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 03:35:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E4C12D0278;
	Wed,  3 Sep 2025 03:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bEmQtDHT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C2F2C187;
	Wed,  3 Sep 2025 03:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756870547; cv=fail; b=rKmyVvoiwcT85SzQJzMg2qX8y/BADwSWnTs0dPHXGBpPlydiYzK/ZY3oaiUT+dAM6fMgoK6nmE84nH88XFQeoTmXgNt2P/O0Iia0nFe9wLFauHVekbOGak0nwKta5VaStpwI0GqloQdWUjB7izoe8yPWNHu0aNUl/MAeai9Q+YU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756870547; c=relaxed/simple;
	bh=TnCtuEJLXwVEIQVCwIkRYFkQev6XFW8qfoxmeQh0FWo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=niQQAsny+AnksinJes++RvealdlLOGLwzm+f7fI9U4JE/tIkrjjLiQ2rOSWmggI8Pn2cEpgHvp6WTNARLe1wSHLpww7Zr8UYdofxILMfT2NdzLYnAzuWvuFLViyeFyegZQAibnmtxYzR/lzrKbGaWf3wFxyAvT1KQb5Rgwe09wc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bEmQtDHT; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756870546; x=1788406546;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=TnCtuEJLXwVEIQVCwIkRYFkQev6XFW8qfoxmeQh0FWo=;
  b=bEmQtDHTxUsFAut/CfOsQG/zEgA9tKF61n7ZNOmiM0gBYuG0fuMTGX+f
   xqUDKGggYo/AyALq6OYS2E3lzKCSGMbblaxFYMY5QY9A58c9LgdKSVpzT
   cHZjos1nGOMJskYw4jPM/9URShbzdg3sU/7HCgwepPMmGC8FSxg7dxli7
   PjyWFT7IgGseKxgskmOBFgIW8F47xHrGTSbyc3g1AyjhYNRALY1CIbfCp
   InaicMsxoMp7ny5/03fCb+5P+IvSYKlP2wns+7SE1/4tlGelvMMZ7hgBA
   V9T+wLVFyMwJAM7kBEyFtNcdfb7y5EYX9LGLvtK6junK12Mu3A1rQZFBU
   A==;
X-CSE-ConnectionGUID: VwlJElvxQByXpx8MqDZGYA==
X-CSE-MsgGUID: RzR6c4FgT6ioqWtuXC4QVw==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="58870972"
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="58870972"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 20:35:45 -0700
X-CSE-ConnectionGUID: vmvylTWgRo2E4lMeFGbZ1g==
X-CSE-MsgGUID: Dug1r05eS+GYKO62JsgPTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="202361329"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 20:35:45 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 2 Sep 2025 20:35:44 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 2 Sep 2025 20:35:44 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (40.107.102.80)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 2 Sep 2025 20:35:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SVBWpyESI7DlHB0h0BtP2ySHAUON1OXAaFYVCWlKF+JEkDw27mcm6H3VvqAG/hUQecwDYBXDsXXg+t5W7hWd5fiBuaaJljEV+4o+bS/GQS8siw6IIdytV5jAOK4seJoWyDwRiSm0EDi86yO6LzPnbmUQqaFlvRNtN7k0CHmIHPIlAL3jEsS9C99HP/WbL6/46p+HCSj+k2SwoA9qxCyb9mIxPTHfUeASBvX9I+TAhHsfWTrsSw1TCY8DcpaVjlmRD9lgVoyCq32wzZI2I4ZvvCAnBgRZuHZFWF9k49e5bQf6g8YXz9r7mDbboBYu25UC17Avg/GCbae8Wn9gnJmddQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U+ul/t4fqtjQLEsGd9G5Xs/9xcZB0ySZB7dTp6hbv5E=;
 b=s8xoy8n2nEniEDZPZCCjP5SaxSOIiHIRui1a0hnYBL8amBTcP4dcduv73nqDWOw9mwuki1cgYk7BE/o0azG8/dp8AuphZHtTLsjJPG5VaTvGxxhTlJvGQlDwJkaSqCug4oaZvNeAoU63/Tutt3PPdpjaKkl8nm/K9IABk55v/Ff3OhDFwGzOxtCPcN/6rlj0lcWkIkY65IUJ0i/rs20ykelTRaiPJYefoHRJA2RWu1eVeDHh5AtIcwO06qRkOrUCsdrWa98NT6c+zNE3JVeID9mW+EbD3Sf24SOKODAZgujm+LN5o2foLpBD2J/7XbCkU1mAeAxPJ5rZavd/63ajGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM6PR11MB4609.namprd11.prod.outlook.com (2603:10b6:5:28f::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9073.27; Wed, 3 Sep 2025 03:35:41 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9073.026; Wed, 3 Sep 2025
 03:35:41 +0000
Date: Wed, 3 Sep 2025 11:34:47 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "ackerleytng@google.com" <ackerleytng@google.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Weiny, Ira" <ira.weiny@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [RFC PATCH v2 12/18] KVM: TDX: Bug the VM if extended the
 initial measurement fails
Message-ID: <aLe3V9mgv/gK4MPV@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250829000618.351013-1-seanjc@google.com>
 <20250829000618.351013-13-seanjc@google.com>
 <aLFiPq1smdzN3Ary@yzhao56-desk.sh.intel.com>
 <8445ac8c96706ba1f079f4012584ef7631c60c8b.camel@intel.com>
 <aLIJd7xpNfJvdMeT@google.com>
 <aLa34QCJCXGLk/fl@yzhao56-desk.sh.intel.com>
 <aLcjppW1eiCrxJPC@google.com>
 <77cd1034c59b23bae2bbf3693bf6a740d283d787.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <77cd1034c59b23bae2bbf3693bf6a740d283d787.camel@intel.com>
X-ClientProxiedBy: SG2P153CA0025.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::12)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM6PR11MB4609:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b9ebae9-1e6e-4180-b472-08ddea9af4c8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?nVD0xHXKSXqQPfRjtPQGQSRd5yAv+je0DRcaBJj8wAT1HX2o1DRhBGpgAoJw?=
 =?us-ascii?Q?tE5SvG3CUZKlxlXQGE52IyVGbqHN0DGqlCCKOakBfZaif2F4syFOrtvBgtWU?=
 =?us-ascii?Q?bm6bDPpXyK/IDKxTWu1L8UFX9lzE+zkSkSFIoboMrskh1iIBZPv3TvdAFZqK?=
 =?us-ascii?Q?CbpchDYqpz2NaIfUSnruVhq77Kd+A8sAONz8HUyUIjOiA8Pevc5XM/mKmus5?=
 =?us-ascii?Q?M1VF+PfmpEgppi0rFBvXhVpnm7nvG7aYpPereHTcuBFy8Pxpct7M8AV29AJj?=
 =?us-ascii?Q?xYrBIFkZ43u0u9WUlSCvSRkbLPj7VCOmt5QkYxYLDy/2jXDk87spk1mkcSYC?=
 =?us-ascii?Q?ADVvz0xVqCJecWuBIPSvfkzS1yvsHjR7UVteZsBWLLMAp6FekyrKJU/jIDvn?=
 =?us-ascii?Q?iKkqz5BRQsWl3gkWFi98+uEM2bFudee1TwjJUmoiPO4Hd6o/4gosuArP75fB?=
 =?us-ascii?Q?ErmLugCqv2o+hG6wxZ/pxFaxXPEr4Yz05oyCdCLPwrkpJsTAGjXITkXxJvA0?=
 =?us-ascii?Q?JTXtn6pkaI9RJ62ydUJ7mdIMpdEp/L6iskrID1DCnHuxz2dC/oi31fOq2fU3?=
 =?us-ascii?Q?6p/l9v0RrOTcFKX0MbFdC1RebkR3x56HKCmNaIIk+v1ZfOWiF4vsS+7OHcvc?=
 =?us-ascii?Q?kMut9/hDtUHTexE4FQTJpUrf1Y2adjCXz3wMb9uHsz9CoowS6/ozcPAtAAT+?=
 =?us-ascii?Q?vtuyZHTutXKRax5hmBcgCuLyFn4bGwKB0VEgENhk7aN+iW+Q3tXqqV8Q91Hs?=
 =?us-ascii?Q?GfPZBYnb1K0q/Xs0P8jelwg6rK/u0WORZajqYn3cEpfRomNbBzOFqAlceGXK?=
 =?us-ascii?Q?QUIFYMtraRoU/3Z8PSYathN1qQb6SOR6Oa+wON+urCjOzMZjFg/NSXpi3KlW?=
 =?us-ascii?Q?puTOlZkNOfHyQyOeyGp3kIofz5anfKVDd/E4/rrjmmaJQnNBxN5rEmJIjYbY?=
 =?us-ascii?Q?FTlKeW32fbWDrMN4BfawjTJQYG4W1TlYd09kC4pTeBDDVz/oFHpMXPtdcIda?=
 =?us-ascii?Q?x0yKGbykMsEFKWKmSmX83CytI4oamg/Puy9vGPNgtfqpTWzMOVMsITfbi42y?=
 =?us-ascii?Q?s/RHkb7xzUhHmXM8N4XBOYk/XRPJTZm1RDBwgCH4FABk54kvFZo7RpLDJGlL?=
 =?us-ascii?Q?JbHjY2pGITZJsoVkck1GJjyrZU0BtC8bAZZOZVm78zdOLWsDYbqlCnkiJjii?=
 =?us-ascii?Q?eznrC9v77PgN3Ya1nT2AfoexshhjyF470KOZOvhDRz3jWR8Y5NAxEwwzjTE0?=
 =?us-ascii?Q?tXV5ISBZWKO77cJ11wS1p3/8wzgg4idM6FST+irYrq9J9bh6j+TweeGXThe4?=
 =?us-ascii?Q?2e06AQPuE/9Xn4kelv5UAasY5LHBKqtEUtboX0MbetUkq125eHRRBJMWo2eO?=
 =?us-ascii?Q?Gqjm9t8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ckk5eroDDJPuY0s6EbNvlpsPMThJB2QduthAPigsLc4cGqiMvN2xbV8mAgUl?=
 =?us-ascii?Q?DnnN9WOjDM8ypqqGT8Zw6tVpe0JS+mz1LIFknRsUTywFMnxTjWQRUtyJkpc3?=
 =?us-ascii?Q?UlCX6T1WsAeKS6XFG4dkOaD+f7wHZJanPnTlNlqm4/y7lRDWz+mbowAi8W/R?=
 =?us-ascii?Q?0GQ8gnfe6VT01U92ItPT1ydyoHtTxBRxF//IPs8tCoKuFDAdMsdWYNh2wx9R?=
 =?us-ascii?Q?KJmDtEUkd6JAna8E3YYthYCa4XAF5CHuXrMDR/+M0nwUup0zyWMwzgduaMPu?=
 =?us-ascii?Q?yAm4iu0nP0uhG7fkooSK+cBMCveWcfiE/U7u/j9KZkPqjC4+gNn1CMa394BF?=
 =?us-ascii?Q?SoVpfS2NC3+0t/E4kyU2/jW3nI7CGtp+Wf5oPGj+dlN1VJiNYHPnvlMoumjG?=
 =?us-ascii?Q?Rfl+pJrneyksY7c5QMJ0mRtjy7FNO0oAGhv5TRcColHo4hMBocI49kfmqBp2?=
 =?us-ascii?Q?SV1SFeSdJUdOrmC5Y8h0tn5Y4Z8Hzg2UdlesMLaMFxqR2pRnw3eY4/NiR3D4?=
 =?us-ascii?Q?kE6PA1VoypQPsPKNtNfDlY6EsWOun0wuICWtzGhXhSffaES8j+xt4nCXKgpn?=
 =?us-ascii?Q?Mv0fy7hrr2N1tar+lhZ2K+ny07WZ6+XJEBaD6uR5RAgN5ZWiTwDwHJLX0Wqm?=
 =?us-ascii?Q?+IN5U96ZiO/Bp8KiDRMzSGdNLCCHcfkWx58SK7MTr999Zr0nap4hHWxkUgmo?=
 =?us-ascii?Q?LvcuTEFZzRuLDWpl4MJuvY5DoXdL3f9xxBXTWDoOYEIJ9OfN/qiRACZfEqPt?=
 =?us-ascii?Q?DPboOx47CEtyaa0CEnTvc69CFJbVNSFK6qbEK001a9LGsrA0CltCvwbyBjHL?=
 =?us-ascii?Q?6xneqlfDEmGXw8kAvLaCeq9Aa5f3ai+Tz5Uk8J9cSYZrHQ1003jdYR89D80d?=
 =?us-ascii?Q?XmZOSZLHPNIBWisN+gXezNPC/h9oR9LLbnOEHLt3eUVoaoyjz7UUMeZwYddC?=
 =?us-ascii?Q?gLN6o6fMziQlGzS0vCy5sqB/A9oA3LlsG3LJDM4RX7C2YfOfBEzNLVF9Wh1J?=
 =?us-ascii?Q?n/rmlyuewFqpmUjnLVT493b4TRrb4+X7lhwMyWTrcl1tUx6T9c6rclJKRjuz?=
 =?us-ascii?Q?ZSfU+tkgZ/0JOWtokiLTTIvuLY7cjoawLUofA2HRMgK7/7jQmQFyHx0gmExx?=
 =?us-ascii?Q?Rt7CghE/jFBC7z4cyp3xd661eCVbDOVHYCqSSfOxSgBse4/jCOLH8XqKSs5q?=
 =?us-ascii?Q?FPOkw52nZxi5M/x+4XEX4hG8rryMBtsYeFm3lLMPIpg+IIi12nLvnjXuxKPi?=
 =?us-ascii?Q?bEmt3RQ2JuvnlG2J4rjJdDmic9kJGVRLHMhuw9Fgl8OxuWNFF6TneoZCCE5u?=
 =?us-ascii?Q?/9FuIyJjQNkAp6Av0vklsr0wkQHI9bf45T+/MNS8iInD86obnRi05NnzCdjb?=
 =?us-ascii?Q?y0xC1+fjIuBka5cbqkDMezVHTh4jEjBhTx6lbNN++OvAdxGPausK4KJDQ1iA?=
 =?us-ascii?Q?D0BNobu/6uDlE6AApzQqh5ai3vK93E0aBZt18YyAGdxG2LJFdmPtqWg9jQ3p?=
 =?us-ascii?Q?axTt0G/TL4u3+rQt0dyaafIqyM0naBVAMl1R7TPGW2vYpp1LDOtV2y6jxuyq?=
 =?us-ascii?Q?1t80lShdDreOOV4tAgOXHc4Ya4s7tbNbo7tHIRCL?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b9ebae9-1e6e-4180-b472-08ddea9af4c8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 03:35:41.1832
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UDldq7CJRzLk08nK/AnhTSFe14H4h18pPqp4nhmXa5YVAoIj61bUjfKSVKVTVxhqWOxi2mgAkT8MDKe2uqe3mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4609
X-OriginatorOrg: intel.com

On Wed, Sep 03, 2025 at 08:18:10AM +0800, Edgecombe, Rick P wrote:
> On Tue, 2025-09-02 at 10:04 -0700, Sean Christopherson wrote:
> > On Tue, Sep 02, 2025, Yan Zhao wrote:
> > > But during writing another concurrency test, I found a sad news :
> > > 
> > > SEAMCALL TDH_VP_INIT requires to hold exclusive lock for resource TDR when its
> > > leaf_opcode.version > 0. So, when I use v1 (which is the current value in
> > > upstream, for x2apic?) to test executing ioctl KVM_TDX_INIT_VCPU on different
> > > vCPUs concurrently, the TDX_BUG_ON() following tdh_vp_init() will print error
> > > "SEAMCALL TDH_VP_INIT failed: 0x8000020000000080".
> > > 
> > > If I switch to using v0 version of TDH_VP_INIT, the contention will be gone.
> > 
> > Uh, so that's exactly the type of breaking ABI change that isn't acceptable.  If
> > it's really truly necessary, then we can can probably handle the change in KVM
> > since TDX is so new, but generally speaking such changes simply must not happen.
> > 
> > > Note: this acquiring of exclusive lock was not previously present in the public
> > > repo https://github.com/intel/tdx-module.git, branch tdx_1.5.
> > > (The branch has been force-updated to new implementation now).
> > 
> > Lovely.
> 
> Hmm, this exactly the kind of TDX module change we were just discussing
> reporting as a bug. Not clear on the timing of the change as far as the landing
> upstream. We could investigate whether whether we could fix it in the TDX
> module. This probably falls into the category of not actually regressing any
> userspace. But it does trigger a kernel warning, so warrant a fix, hmm.
> 
> > 
> > > > Acquire kvm->lock to prevent VM-wide things from happening, slots_lock to prevent
> > > > kvm_mmu_zap_all_fast(), and _all_ vCPU mutexes to prevent vCPUs from interefering.
> > > Nit: we should have no worry to kvm_mmu_zap_all_fast(), since it only zaps
> > > !mirror roots. The slots_lock should be for slots deletion.
> > 
> > Oof, I missed that.  We should have required nx_huge_pages=never for tdx=1.
> > Probably too late for that now though :-/
> > 
> > > > Doing that for a vCPU ioctl is a bit awkward, but not awful.  E.g. we can abuse
> > > > kvm_arch_vcpu_async_ioctl().  In hindsight, a more clever approach would have
> > > > been to make KVM_TDX_INIT_MEM_REGION a VM-scoped ioctl that takes a vCPU fd.  Oh
> > > > well.
> > > > 
> > > > Anyways, I think we need to avoid the "synchronous" ioctl path anyways, because
> > > > taking kvm->slots_lock inside vcpu->mutex is gross.  AFAICT it's not actively
> > > > problematic today, but it feels like a deadlock waiting to happen.
> > > Note: Looks kvm_inhibit_apic_access_page() also takes kvm->slots_lock inside
> > > vcpu->mutex.
> > 
> > Yikes.  As does kvm_alloc_apic_access_page(), which is likely why I thought it
> > was ok to take slots_lock.  But while kvm_alloc_apic_access_page() appears to be
> > called with vCPU scope, it's actually called from VM scope during vCPU creation.
> > 
> > I'll chew on this, though if someone has any ideas...
> > 
> > > So, do we need to move KVM_TDX_INIT_VCPU to tdx_vcpu_async_ioctl() as well?
> > 
> > If it's _just_ INIT_VCPU that can race (assuming the VM-scoped state transtitions
> > take all vcpu->mutex locks, as proposed), then a dedicated mutex (spinlock?) would
> > suffice, and probably would be preferable.  If INIT_VCPU needs to take kvm->lock
> > to protect against other races, then I guess the big hammer approach could work?
We need the big hammer approach as INIT_VCPU may race with vcpu_load()
in other vCPU ioctls.

> A duplicate TDR lock inside KVM or maybe even the arch/x86 side would make the
> reasoning easier to follow. Like, you don't need to remember "we take
> slots_lock/kvm_lock because of TDR lock", it's just 1:1. I hate the idea of
> adding more locks, and have argued against it in the past. But are we just
> fooling ourselves though? There are already more locks.
> 
> Another reason to duplicate (some) locks is that if it gives the scheduler more
> hints as far as waking up waiters, etc. The TDX module needs these locks to
> protect itself, so those are required. But when we just do retry loops (or let
> userspace do this), then we lose out on all of the locking goodness in the
> kernel.
> 
> Anyway, just a strawman. I don't have any great ideas.
Do you think the following fix is good?
It moves INIT_VCPU to tdx_vcpu_async_ioctl and uses the big hammer to make it
impossible to contend with other SEAMCALLs, just as for tdh_mr_extend().

It passed my local concurrent test.

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 99381c8b4108..8a6f2feaab41 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3047,16 +3047,22 @@ static int tdx_vcpu_get_cpuid(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)

 static int tdx_vcpu_init(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
 {
-       u64 apic_base;
+       struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
        struct vcpu_tdx *tdx = to_tdx(vcpu);
+       u64 apic_base;
        int ret;

+       CLASS(tdx_vm_state_guard, guard)(vcpu->kvm);
+       if (IS_ERR(guard))
+               return PTR_ERR(guard);
+
        if (cmd->flags)
                return -EINVAL;

-       if (tdx->state != VCPU_TD_STATE_UNINITIALIZED)
+       if (!is_hkid_assigned(kvm_tdx) || tdx->state != VCPU_TD_STATE_UNINITIALIZED)
                return -EINVAL;

+       vcpu_load(vcpu);
        /*
         * TDX requires X2APIC, userspace is responsible for configuring guest
         * CPUID accordingly.
@@ -3075,6 +3081,7 @@ static int tdx_vcpu_init(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
        td_vmcs_setbit32(tdx, PIN_BASED_VM_EXEC_CONTROL, PIN_BASED_POSTED_INTR);

        tdx->state = VCPU_TD_STATE_INITIALIZED;
+       vcpu_put(vcpu);

        return 0;
 }
@@ -3228,10 +3235,18 @@ int tdx_vcpu_async_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
        if (r)
                return r;

-       if (cmd.id != KVM_TDX_INIT_MEM_REGION)
-               return -ENOIOCTLCMD;
-
-       return tdx_vcpu_init_mem_region(vcpu, &cmd);
+       switch (cmd.id) {
+       case KVM_TDX_INIT_MEM_REGION:
+               r = tdx_vcpu_init_mem_region(vcpu, &cmd);
+               break;
+       case KVM_TDX_INIT_VCPU:
+               r = tdx_vcpu_init(vcpu, &cmd);
+               break;
+       default:
+               r = -ENOIOCTLCMD;
+               break;
+       }
+       return r;
 }

 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
@@ -3248,9 +3263,6 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
                return ret;

        switch (cmd.id) {
-       case KVM_TDX_INIT_VCPU:
-               ret = tdx_vcpu_init(vcpu, &cmd);
-               break;
        case KVM_TDX_GET_CPUID:
                ret = tdx_vcpu_get_cpuid(vcpu, &cmd);
                break;


Besides, to unblock testing the above code, I fixed a bug related to vcpu_load()
in current TDX upstream code. Attached the fixup patch below.

Sean, please let me know if you want to include it into this series.
(It still lacks a Fixes tag as I haven't found out which commit is the best fit). 


From 0d1ba6d60315e34bdb0e54acceb6e8dd0fbdb262 Mon Sep 17 00:00:00 2001
From: Yan Zhao <yan.y.zhao@intel.com>
Date: Tue, 2 Sep 2025 18:31:27 -0700
Subject: [PATCH 1/2] KVM: TDX: Fix list_add corruption during vcpu_load()

During vCPU creation, a vCPU may be destroyed immediately after
kvm_arch_vcpu_create() (e.g., due to vCPU id confiliction). However, the
vcpu_load() inside kvm_arch_vcpu_create() may have associate the vCPU to
pCPU via "list_add(&tdx->cpu_list, &per_cpu(associated_tdvcpus, cpu))"
before invoking tdx_vcpu_free().

Though there's no need to invoke tdh_vp_flush() on the vCPU, failing to
dissociate the vCPU from pCPU (i.e., "list_del(&to_tdx(vcpu)->cpu_list)")
will cause list corruption of the per-pCPU list associated_tdvcpus.

Then, a later list_add() during vcpu_load() would detect list corruption
and print calltrace as shown below.

Dissociate a vCPU from its associated pCPU in tdx_vcpu_free() for the vCPUs
destroyed immediately after creation which must be in
VCPU_TD_STATE_UNINITIALIZED state.

kernel BUG at lib/list_debug.c:29!
Oops: invalid opcode: 0000 [#2] SMP NOPTI
RIP: 0010:__list_add_valid_or_report+0x82/0xd0

Call Trace:
 <TASK>
 tdx_vcpu_load+0xa8/0x120
 vt_vcpu_load+0x25/0x30
 kvm_arch_vcpu_load+0x81/0x300
 vcpu_load+0x55/0x90
 kvm_arch_vcpu_create+0x24f/0x330
 kvm_vm_ioctl_create_vcpu+0x1b1/0x53
 ? trace_lock_release+0x6d/0xb0
 kvm_vm_ioctl+0xc2/0xa60
 ? tty_ldisc_deref+0x16/0x20
 ? debug_smp_processor_id+0x17/0x20
 ? __fget_files+0xc2/0x1b0
 ? debug_smp_processor_id+0x17/0x20
 ? rcu_is_watching+0x13/0x70
 ? __fget_files+0xc2/0x1b0
 ? trace_lock_release+0x6d/0xb0
 ? lock_release+0x14/0xd0
 ? __fget_files+0xcc/0x1b0
 __x64_sys_ioctl+0x9a/0xf0
 ? rcu_is_watching+0x13/0x70
 x64_sys_call+0x10ee/0x20d0
 do_syscall_64+0xc3/0x470
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 42 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 37 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index e99d07611393..99381c8b4108 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -837,19 +837,51 @@ void tdx_vcpu_put(struct kvm_vcpu *vcpu)
        tdx_prepare_switch_to_host(vcpu);
 }

+/*
+ * Life cycles for a TD and a vCPU:
+ * 1. KVM_CREATE_VM ioctl.
+ *    TD state is TD_STATE_UNINITIALIZED.
+ *    hkid is not assigned at this stage.
+ * 2. KVM_TDX_INIT_VM ioctl.
+ *    TD transistions to TD_STATE_INITIALIZED.
+ *    hkid is assigned after this stage.
+ * 3. KVM_CREATE_VCPU ioctl. (only when TD is TD_STATE_INITIALIZED).
+ *    3.1 tdx_vcpu_create() transitions vCPU state to VCPU_TD_STATE_UNINITIALIZED.
+ *    3.2 vcpu_load() and vcpu_put() in kvm_arch_vcpu_create().
+ *    3.3 (conditional) if any error encountered after kvm_arch_vcpu_create()
+ *        kvm_arch_vcpu_destroy() --> tdx_vcpu_free().
+ * 4. KVM_TDX_INIT_VCPU ioctl.
+ *    tdx_vcpu_init() transistions vCPU state to VCPU_TD_STATE_INITIALIZED.
+ *    vCPU control structures are allocated at this stage.
+ * 5. kvm_destroy_vm().
+ *    5.1 tdx_mmu_release_hkid(): (1) tdh_vp_flush(), disassociats all vCPUs.
+ *                                (2) puts hkid to !assigned state.
+ *    5.2 kvm_destroy_vcpus() --> tdx_vcpu_free():
+ *        transistions vCPU to VCPU_TD_STATE_UNINITIALIZED state.
+ *    5.3 tdx_vm_destroy()
+ *        transitions TD to TD_STATE_UNINITIALIZED state.
+ *
+ * tdx_vcpu_free() can be invoked only at 3.3 or 5.2.
+ * - If at 3.3, hkid is still assigned, but the vCPU must be in
+ *   VCPU_TD_STATE_UNINITIALIZED state.
+ * - if at 5.2, hkid must be !assigned and all vCPUs must be in
+ *   VCPU_TD_STATE_INITIALIZED state and have been dissociated.
+ */
 void tdx_vcpu_free(struct kvm_vcpu *vcpu)
 {
        struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
        struct vcpu_tdx *tdx = to_tdx(vcpu);
        int i;

+       if (vcpu->cpu != -1) {
+               KVM_BUG_ON(tdx->state == VCPU_TD_STATE_INITIALIZED, vcpu->kvm);
+               tdx_disassociate_vp(vcpu);
+               return;
+       }
        /*
         * It is not possible to reclaim pages while hkid is assigned. It might
-        * be assigned if:
-        * 1. the TD VM is being destroyed but freeing hkid failed, in which
-        * case the pages are leaked
-        * 2. TD VCPU creation failed and this on the error path, in which case
-        * there is nothing to do anyway
+        * be assigned if the TD VM is being destroyed but freeing hkid failed,
+        * in which case the pages are leaked.
         */
        if (is_hkid_assigned(kvm_tdx))
                return;
--
2.43.0


