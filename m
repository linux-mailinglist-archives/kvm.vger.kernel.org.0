Return-Path: <kvm+bounces-72800-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KNOfLUA4qWnN3AAAu9opvQ
	(envelope-from <kvm+bounces-72800-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 09:01:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1910120D124
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 09:01:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 133633041BF6
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 07:59:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AF53342517;
	Thu,  5 Mar 2026 07:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WXkKL4re"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1624340294;
	Thu,  5 Mar 2026 07:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772697559; cv=fail; b=HM6GMmAaIt7dg0h1ruSLuiuczzIepEIAxMF7Tp2jVLW3ZG0xo8GQcONLYJeGbKit4S5a71k8W1mKNg9mg6cBoq5ADMSF3HS8hE+h+8PIqh5OyCVeud/KnpLAmaNnYbDguL0p3n8S96o+9EP0goYV00asNDkiTVT79G+UGhubMVs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772697559; c=relaxed/simple;
	bh=qgaezfmgkWoa9K/WQYUPxJIQXlLnoIFkL45julm7xfA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=d7TFh4OtJ6MmG9OtTNoSyeEl+kqn/jZC+rGgu1c8Mw8J2g/alS9Y6v1AAxjSOEEUA2aY769E+M1lmmeXGdUqfv2cmhnhovmDfitWLMUBFIg3YJNe5MV09MQVXKbYlchR7HGyuCXm30f0iBDw7fptPRQtOD5KIaGZm8pQDZAvjkY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WXkKL4re; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772697557; x=1804233557;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=qgaezfmgkWoa9K/WQYUPxJIQXlLnoIFkL45julm7xfA=;
  b=WXkKL4reoDZP2C6YifEb08IikipAhK0ZMcICnVWxExxqgxVPByULk4Ya
   0o05gYWkqfGfEHeKXdwnR32eJqntQBFnO5VI3Tb0X/RznfHTIaLH6W+Qk
   o/xTCjEb6aLhQCwrzRgnIeDDvKiN39aQKNHRHcvMqEf5AdV4PxXu/jsJ2
   jtuma+QoAHMtcFqvh8Cc5zKQH8Bfkw9kNpYifA3TtPC0FFIsJ/POEz2Cu
   TeA8lU67wLm9BECyKSfE0bQx9uC00z+oIf7MjJB1+AGck8P690FLx5kDa
   IDLqlBJag+07gObEoDkZOxSfaowUlr6B4RjI5L2m4Mr5QKXtfWZ7oKkY4
   g==;
X-CSE-ConnectionGUID: P3zjEcFsTle+Xm/B9epxqQ==
X-CSE-MsgGUID: PfKH5P/eRGemQR0dyXKH2g==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="73690629"
X-IronPort-AV: E=Sophos;i="6.21,325,1763452800"; 
   d="scan'208";a="73690629"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 23:59:14 -0800
X-CSE-ConnectionGUID: KVfw61vDTDWQKO0LUvf2Ow==
X-CSE-MsgGUID: foJQ6hMjRVexxc5rhv1UvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,325,1763452800"; 
   d="scan'208";a="241610924"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 23:59:09 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 4 Mar 2026 23:59:07 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 4 Mar 2026 23:59:07 -0800
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.67) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 4 Mar 2026 23:59:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OjL/gOMMzLxreasD0znwv58WfP8GGuXCT9q2EEnrifXjHdHfjoPBvEHL27NRuebfBXVbUhtyYIXmFtU36h3wsft8p6L0taIo32c6tMeth+fUb2PrkJg7WvS7ObCB/2u1EAQhAv354+I79VLaZYUqk9fdepKu7hFfpN2m2CllDTGyjl9SDs3scZjTlc4LFLEyyLnXftzX658eAkPryPZWMWP7xL4jjwsITAU6iOgmrFQj9YV+2QolMfiDgwKVALqD+/gHsD1tK3rp2pYgxVs2P7BqklDlUvIw/AR8NmnuBo/CkN/jXFi7+Sr7N3Wf+7xbxDdPyXzNDXu6IdlTPfc9NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e9xO+WF7Y+Bi2LS4MHR954X6mUzd7CtRwPWctVC1f6U=;
 b=we4JjhQGTyS3tHzF3wf5+BzmubIeqcEL5DZHDg+b7raBNWJMPFl0T6GteHIxdh6kUuNArtg5qiUzZH7gcpE5iFugLb/Kr0XVKpmOsALAxgAF5R51RBBVVAh/+HI+okrlYj6tPS5Yyj/nb9PicHEKPGLlDeA/KqQGwHNJidafxpxCZgpfatnr619ZNMy1yNHfeKHcPQhx8qjPt60Nbs/VT8gXUASyYNLe1As/BLLTrrM0IdLkoxqnLkddCXcYuVcDd0Gh8wO4H/OrXauGsuLyxX+NjRO3bPICFv1YyjmFzH8VhEum9txDar43NAtXXWMkrp/lnbCb35vi3r39V3RO8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7472.namprd11.prod.outlook.com (2603:10b6:510:28c::12)
 by DS0PR11MB7768.namprd11.prod.outlook.com (2603:10b6:8:138::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.18; Thu, 5 Mar
 2026 07:59:03 +0000
Received: from PH0PR11MB7472.namprd11.prod.outlook.com
 ([fe80::1bad:44dd:4e60:6475]) by PH0PR11MB7472.namprd11.prod.outlook.com
 ([fe80::1bad:44dd:4e60:6475%5]) with mapi id 15.20.9654.022; Thu, 5 Mar 2026
 07:59:03 +0000
Date: Thu, 5 Mar 2026 15:55:55 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: Re: [PATCH] KVM: x86/mmu: Don't create SPTEs for addresses that
 aren't mappable
Message-ID: <aak3C/kR9o/pJ40n@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260219002241.2908563-1-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260219002241.2908563-1-seanjc@google.com>
X-ClientProxiedBy: SI1PR02CA0032.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::12) To PH0PR11MB7472.namprd11.prod.outlook.com
 (2603:10b6:510:28c::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7472:EE_|DS0PR11MB7768:EE_
X-MS-Office365-Filtering-Correlation-Id: 994a92e3-4ac6-49ee-b941-08de7a8d111c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: Kzm6bR4L2u+uW3VwQZMauGOvyKHgmgHv7xwlDX/rvQjASOSXz5crF9/S0akhLJMkibPQs/JJZgA7AEMD25lFXJlYYo8xdQn2QHyBKBH5itt6e3I5QHVaE5ceiY45mpip9hrV03TqScuPUFVUIFihiZCd5mnF0dQeq4jUB4D+hdrRGUI8nM1G4uW6spfkK+emzvOLt2YTo9nknyIMDYRzlLyCJMN892QQneMyLFgiY5up2M8oIpBAVMdg+K8mxOWYDDngOQ7Qie9ChzrQO0QMGEUOeKRZiyRqbpdEX8eIxmRz57yFy1A2lzL1otnBDeUi/GOEljpgp0VMwddYzTQxgyJoofnvckcCpK/wOcqvzJUoi4/JvzlD0KBw+qV6bgpS3af7S9Rq2zfUBs60Mi0yh3YAZJbuvM40OBqwQwFcMWeXe41K4pxbJN1GDsICTiecqGqJ/+IfprSVnd7cgjfSvc7WtmiWx/Mrt6Wy6OVe/HtXs20f18FYYpJUW5IvypIyIMuMvWaY77lCngh7tFiPuY/SFbgUMBWVIGBycVDKXg4gdixmNqwrQVfCO9M6fP1i+N2i9aIr+GMHO3/MGqIKXyyT4OwFF5RbTt2278F+yVox6HUy3w3ZVYoYd7psNkH4M91qDoJDdpAojneSnaOO079szq25n4i24eisuqBw5yUCRYUYio2acE6668vis419Ca8M1SvgI58KPZnhFOpaSBENBgInFe1+wluqSvSgEMk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lAFYi75vTFQdDqGxEyjkHa2orbRrCfxg41JGB7wqlPdsAYGwV578JNvAzXgv?=
 =?us-ascii?Q?8nTS5zY2FM9MVpUC5ezpJ1wOEAcXlFeUIBPHM+t9O5ucDu5eaDsJ0OB1U4Mr?=
 =?us-ascii?Q?7oMO1Oo7AqbrJOZR7c+eVGBGxARfXkbf1RDnBNRKG9ZxT2WJtv6pCel87WWZ?=
 =?us-ascii?Q?6S5as4c/FbIz53lJ0xUWPvqMuGubCD0fsAuhU3v+q5lSwr27ixF0ML24wATD?=
 =?us-ascii?Q?hZsvqhVZr1yNy38zHqH7wtrpdXcHTDPZh5ydCl2Kgf6Krfw0SvMD470SqCJr?=
 =?us-ascii?Q?BrAdZzGiu7+xNuXS570w0k2PEwVHFm/qHfjw4LxDo+qtUlfAy/6MFgjwPVCn?=
 =?us-ascii?Q?zvBoY5CPX7lINxsvyR6XRWjrJgY9I/isvCN7WrbvW5USpVyED1VstlhAm5Et?=
 =?us-ascii?Q?7DbwJLTE6+HY53eFOcqYXUI5PDlrafqS6pzpnINgRTtXPnASQaQ8Tso3ykFJ?=
 =?us-ascii?Q?pw6A4YJkjPdg3B5DbDopOG8ZxCGW3XM4XwwUcYvYLhaeQmWJF31xSwVPbNX0?=
 =?us-ascii?Q?xa9JYcSYOfSUHVyLRxkEdNbJddFeLkcmbIy6DqZjk6e6jBYzdFr41gtDxjPO?=
 =?us-ascii?Q?Ms9UzLDYgh6QPAaaK1bMd96FdeQjkqbg1bZFnPE6IyvlJ1Ohj3So8BT8Dio8?=
 =?us-ascii?Q?cohoyTNBQ1zN0p611BIVp2mookdO9yhERHROdBdiuaRe7UU+u1cefbK/+PPn?=
 =?us-ascii?Q?BVLSUnmc5VJNxo11QGN68CC+iSNao2Mov++vN7pRZrSNdtRCk7H8Kh3Z+aNg?=
 =?us-ascii?Q?5X8ksNF70hLnTr3W7c/g31UvgdUQDkTIoaOCCdBE4hhPbzHG9XZj0mEkS8rp?=
 =?us-ascii?Q?hsMC8ciXmW1INeyRo+YabQztgCpbVSkZjS6+1idlqP1uEtZmOn8uL+smYXHk?=
 =?us-ascii?Q?gS8Wi1PKmyVJPNjucl4G1BYh/zTFtGSSsQ2IMHk5k3Od+SVdPlj6qBSj8UEj?=
 =?us-ascii?Q?0A3EMhtUAjuK0pYuPYOCM4g4RpjNpSqUtS4O7nPIPh3IQ2J4AxGX5CzMCGi1?=
 =?us-ascii?Q?LLIsMJn2jk0pAW61q86uPCvWW9hCY1WFNVtb511odjRB4+irPj/GPTSV2F5r?=
 =?us-ascii?Q?dQQBA8Go5MAVVbE4MfiMehB3XR4yC6u5xCnx15AOtyn6m453sWCLDAQd6arr?=
 =?us-ascii?Q?3ALolufwHd2yMTuzSQCC8bXYNkqI6IYqT4cs2a9zdMQRdBrFaCft8Khx7RuZ?=
 =?us-ascii?Q?tjnsyOUY9CwbHjstt5pmcAkFgMpahWZsXjNq23LmjQteBzpB7Yp86iOQ2IJ+?=
 =?us-ascii?Q?AQapkAqVEfoQKZmtfEeePhH0psh/Cq7EFg0Gu+2foHHRjRyieRRTG7ADG+s0?=
 =?us-ascii?Q?mZFihT63YXa/O5gBt/TAlMUyT08O7v8KrtLX6flPMpwFBcFPeZNvtN/uYLpD?=
 =?us-ascii?Q?ZemK2yibgYOIWNBWhZMQTzxWXqhyf9bJiDEYsgL10QFZObR5fgBmKdj1NFTj?=
 =?us-ascii?Q?+ypY+xNUgt67rU3y9hK6IJFL1/7RCjuM1/ppX0RjYZgilHJao9rC6sxtpj2V?=
 =?us-ascii?Q?abO/H0rjijSa4YNhKiolqcc85FupiuVG9JtFUPIfJ5CF+preHHJ/yq9oYb1S?=
 =?us-ascii?Q?zDoUV2cfWYl1EdCH18eKUdulffPJF2I9b5QeTk+CHfcv/TEaBkzCThsFsgk5?=
 =?us-ascii?Q?J2rJ4JJjK2GHz9X5Q6Tm9EfSMRJj7ubW8A0sSvTrcfcjXPWpBmQhhFO9p5o5?=
 =?us-ascii?Q?gj8Lx2Y9WlDAJTdWAKqXVZxF/tgsL/lmf3/wcvKlw2wd09+uZxYRNaSIXZt1?=
 =?us-ascii?Q?TayyjaicCA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 994a92e3-4ac6-49ee-b941-08de7a8d111c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7472.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2026 07:59:03.0728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v0SkbTvLwRAAAazUoK4htisIO4F1SnJT8kFM3tlU3yoTfXj8ZownlAe5T5ZrClstGzroyPb5ettY2KmGwXB1TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7768
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 1910120D124
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72800-lists,kvm=lfdr.de];
	RCVD_COUNT_SEVEN(0.00)[10];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yan.y.zhao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	HAS_REPLYTO(0.00)[yan.y.zhao@intel.com];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:replyto,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,yzhao56-desk.sh.intel.com:mid];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Action: no action

On Wed, Feb 18, 2026 at 04:22:41PM -0800, Sean Christopherson wrote:
> Track the mask of guest physical address bits that can actually be mapped
> by a given MMU instance that utilizes TDP, and either exit to userspace
> with -EFAULT or go straight to emulation without creating an SPTE (for
> emulated MMIO) if KVM can't map the address.  Attempting to create an SPTE
> can cause KVM to drop the unmappable bits, and thus install a bad SPTE.
> E.g. when starting a walk, the TDP MMU will round the GFN based on the
> root level, and drop the upper bits.
> 
> Exit with -EFAULT in the unlikely scenario userspace is misbehaving and
> created a memslot that can't be addressed, e.g. if userspace installed
> memory above the guest.MAXPHYADDR defined in CPUID, as there's nothing KVM
> can do to make forward progress, and there _is_ a memslot for the address.
> For emulated MMIO, KVM can at least kick the bad address out to userspace
> via a normal MMIO exit.
> 
> The flaw has existed for a very long time, and was exposed by commit
> 988da7820206 ("KVM: x86/tdp_mmu: WARN if PFN changes for spurious faults")
> thanks to a syzkaller program that prefaults memory at GPA 0x1000000000000
> and then faults in memory at GPA 0x0 (the extra-large GPA gets wrapped to
> '0').
If the scenario is: when ad bit is disabled, prefault memory at GPA 0x0, then
guest reads memory at GPA 0x1000000000000, would fast_page_fault() fix a wrong
wrapped sptep for GPA 0x1000000000000?

Do we need to check fault->addr in fast_page_fault() as well?

>   WARNING: arch/x86/kvm/mmu/tdp_mmu.c:1183 at kvm_tdp_mmu_map+0x5c3/0xa30 [kvm], CPU#125: syz.5.22/18468
>   CPU: 125 UID: 0 PID: 18468 Comm: syz.5.22 Tainted: G S      W           6.19.0-smp--23879af241d6-next #57 NONE
>   Tainted: [S]=CPU_OUT_OF_SPEC, [W]=WARN
>   Hardware name: Google Izumi-EMR/izumi, BIOS 0.20250917.0-0 09/17/2025
>   RIP: 0010:kvm_tdp_mmu_map+0x5c3/0xa30 [kvm]
>   Call Trace:
>    <TASK>
>    kvm_tdp_page_fault+0x107/0x140 [kvm]
>    kvm_mmu_do_page_fault+0x121/0x200 [kvm]
>    kvm_arch_vcpu_pre_fault_memory+0x18c/0x230 [kvm]
>    kvm_vcpu_pre_fault_memory+0x116/0x1e0 [kvm]
>    kvm_vcpu_ioctl+0x3a5/0x6b0 [kvm]
>    __se_sys_ioctl+0x6d/0xb0
>    do_syscall_64+0x8d/0x900
>    entry_SYSCALL_64_after_hwframe+0x4b/0x53
>    </TASK>
> 
> In practice, the flaw is benign (other than the new WARN) as it only
> affects guests that ignore guest.MAXPHYADDR (e.g. on CPUs with 52-bit
> physical addresses but only 4-level paging) or guests being run by a
> misbehaving userspace VMM (e.g. a VMM that ignored allow_smaller_maxphyaddr
> or is pre-faulting bad addresses).
> 
> For non-TDP shadow paging, always clear the unmappable mask as the flaw
> only affects GPAs affected.  For 32-bit paging, 64-bit virtual addresses
> simply don't exist.  Even when software can shove a 64-bit address
> somewhere, e.g. into SYSENTER_EIP, the value is architecturally truncated
> before it reaches the page table walker.  And for 64-bit paging, KVM's use
> of 4-level vs. 5-level paging is tied to the guest's CR4.LA57, i.e. KVM
> won't observe a 57-bit virtual address with a 4-level MMU.

