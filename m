Return-Path: <kvm+bounces-59756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B1B23BCB52B
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 03:16:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A35F219E30E4
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 01:16:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A99D21C16A;
	Fri, 10 Oct 2025 01:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GCQYshf+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E295A19E97B;
	Fri, 10 Oct 2025 01:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760058971; cv=fail; b=teKWg9HFH6S76qtf8JnrAPBS9oXmqwapzuPvz1VB2vQeYjOWYJHAx8Dtud9NTohKDPsJl0cuLzDt1yO5G2nHTUXQreiNhqROR8l0p1jhXBKFu7E8urMIqvSgfRrewqJ7M8G9tF5i6Qzgpsx3vH0LSsHI6xylA4HZfq1If26AbIM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760058971; c=relaxed/simple;
	bh=7tw/R2fBIHjiddxRNCgXoZ+p6k0eTePHK42p33ee2cM=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=iTmQvM6Ll63O9XQs8d5/C2yCTZDP+62JS0d5EY4LcFUVpB7JCNA/ttBYXUjOHJRGKAWT8zs3loMYNU8t3cplIURmumQgzKBpbPrRCJRDSNkXu4z5jXFaiQMKXD/2jmIFJ7DBfqhaBTQfABvepleIFSq9Q+XijTUQeDy0odm5YgE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GCQYshf+; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760058970; x=1791594970;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=7tw/R2fBIHjiddxRNCgXoZ+p6k0eTePHK42p33ee2cM=;
  b=GCQYshf+jBNI9bJFfwYL7UdAfxQlYf5B+NM5OE/Fts4VAzfLtI1LtgYc
   GSZ6D1MPH9RruAnbdeAUdLH4h4yHTpLfiwwMNozEtuvcgTgq8H1IVDkc2
   AQKMEP+1yG4C8yDDUKlaMX/DAj9KzmzF196khovdZk4Qo3ih2ZRYMtQdY
   2iHLC/T9SK6FlHzJrRAQgQs+tmA4C3kvj67xAFhgh4pEIlipGtkceBZkh
   YSD0xx0D6oWNYRYzMGgmJgkLTbEaeLJEqmgdGT4h/GcJCtXFosF0ifFQz
   YutJe+BIgZMPzht/kNoFRRhs2y79e8i4YxbsqfAPgl6IYhfeX1hDYklnB
   g==;
X-CSE-ConnectionGUID: Rmt3RhJQS3asFnWjoAisHQ==
X-CSE-MsgGUID: RQbeqNcKRleT+TAkJc1YHw==
X-IronPort-AV: E=McAfee;i="6800,10657,11577"; a="66134199"
X-IronPort-AV: E=Sophos;i="6.19,217,1754982000"; 
   d="scan'208";a="66134199"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2025 18:16:10 -0700
X-CSE-ConnectionGUID: l+16JU0sRNukGHRvIMjs+w==
X-CSE-MsgGUID: p9oEax3bTLyuMiuZWLp/3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,217,1754982000"; 
   d="scan'208";a="179960725"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2025 18:16:09 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 9 Oct 2025 18:16:08 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 9 Oct 2025 18:16:08 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.70) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 9 Oct 2025 18:16:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KWAJfLps9dli0l//nBAca/uRs6u6fvkGEzM+Wi4mfQd9TorxFZLA/kT5TmUDpaBX6/MqkoH8WHErJm3dlq8X2ysmr1+XJ+t6TvvnVk/vuPkRz/z5bYdTjsGcvu6NrYzWWD4zGkepi0o/JiMBAH/7DagIg5tB16/J0Rkxcg+hdiKQF8bh9oSwKmnHfGgT/in/Qp/uQ9KvejLQwIx02RNfqwO72+ISSOISPGGo0JMvOC3ur6+idr+Mc9PGl2WjN9Mis2ADEF4rRxweqRE1BzwscxtJqSjNz9Or2z2K+MJqY9nywP+0X0Ag/BKOa4He4e7x90NubLSwqEAANo7ej/+cKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nhSCoZFc0jttNWyielRh7PhatFxy844v30mUvsKnFVE=;
 b=f3TiFwQgl3MaP+YcekhkSFasxguK36Ph4uJd5JDgSwPCmB+Za8bFJEEKbonVxigMopqE0WuRNM/hI4ocaUKmdu3ecx8qDd+rgK5XYYoJB2zo9mQHZkadBHfsqLSrLsW2Gz3dd7sHXok39v4W/2Hq7dcx+q4d3lvd2b62mC2id6Qt6BwycHg8n4P7aGMOphrJgtYjj54nuYMuqiV/nOzx8YjJbNsU+WFVJq00T8X6wKQJzJ0hcW74UFa1u3w7tAbo4ygrjuFENWu07qdnyz528/D/4Z6GR8Oa9M4K+Eg8O1l7zsj3lxZLDm5vVSCB9D6Spjni08OGF3NUyIo88KyqwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DM3PR11MB8683.namprd11.prod.outlook.com (2603:10b6:8:1ac::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Fri, 10 Oct
 2025 01:16:02 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%4]) with mapi id 15.20.9203.009; Fri, 10 Oct 2025
 01:16:01 +0000
From: <dan.j.williams@intel.com>
Date: Thu, 9 Oct 2025 18:16:00 -0700
To: Sean Christopherson <seanjc@google.com>, Chao Gao <chao.gao@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Message-ID: <68e85e503ae05_29801003f@dwillia2-mobl4.notmuch>
In-Reply-To: <aObtM-7S0UfIRreU@google.com>
References: <20250324140849.2099723-1-chao.gao@intel.com>
 <Z_g-UQoZ8fQhVD_2@google.com>
 <aObtM-7S0UfIRreU@google.com>
Subject: Re: [PATCH] KVM: VMX: Flush shadow VMCS on emergency reboot
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0267.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::32) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DM3PR11MB8683:EE_
X-MS-Office365-Filtering-Correlation-Id: 5784e6f7-eb9b-43ea-81ee-08de079a9397
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cWE0YWhibk5qNVdMOHRaTXUvUGFtNWY4ek9ZQVN0d2ZkYlFpakp4TWt1VUt3?=
 =?utf-8?B?WXcxR2RIUVJOZGJwYlFDb0lKaERuc3hzRVBGdytUblBldVZHMVlONlFtRUtv?=
 =?utf-8?B?UXEzendWcmdPWXg3akVnZUN0RFV3WWlibWszVU5PcXkvTGd0MmdsYVdyeUJy?=
 =?utf-8?B?SjBFQisvK2dkeFV5bzJLS3NSRkU5d1NHTUVtcUhGb3BsOXUwRjBtdFFqSDNW?=
 =?utf-8?B?R0FtcDFwWG1GNktVM0ZVUW1mcWFINUpPUEg5c05IaWpNK1VIcUVYR1hWdWl5?=
 =?utf-8?B?TGI3VEYvKzZjaUFSemlIZmNxY1IyKzJEamdtNm5oSHdFQ01TU29BaDJmZDVO?=
 =?utf-8?B?RkF1S3IvMlFWbS9ldUg0RWhNU2hKVE02Zk1rMWs1Z0oyN3dFeHd3NEp6Z2Q3?=
 =?utf-8?B?NGRkdEk5ZWZGRUlLb1hrUzBOdndLc1NHZzY4amgrWGZwdjhuUzhqTVU3eFVY?=
 =?utf-8?B?Y3VQeGRWUmdOenlnazRzS1RaZnYyMW9WV3J0dzNoWU5vMEZHcm1VM3lZZFd2?=
 =?utf-8?B?ME0rZlh1NExTSEkrZFZpWWJVTCtLcEtmaG9hR0prTEUxTHVRVk9EYjVQY2Rl?=
 =?utf-8?B?WEc4QjZYc0hUMDdvaDF1b2ZoN1l3YWxwUCtDcHg1YzU2eWJkaFhkSWVUQ2tx?=
 =?utf-8?B?UGUvU1phb2xiVG5pdlVuQ0VINW00RDJYRTlVNGFpUDIwR3p0azZmcThiV1J4?=
 =?utf-8?B?bGY3MW5UMVdaYWxOSitZeGw3QlE0R3RZWmxyMnFHVUVBVnFUTjZaSWZCVXls?=
 =?utf-8?B?b0Fxbmx6cTJ4UHM1QTV5cndBcm1sUSsweFhQdHdSenV6Q0ttMThBVmFzK1Vi?=
 =?utf-8?B?TEtVQ2lVM29xUEdwM1NoN1l4c2h1WGFlS1k0a0tOTHlEUEdjUHNnd0xCSDY1?=
 =?utf-8?B?WFZGVHJuNHZ6Y0tpNlVXL2lDMXUxRVdKbExFdEJoendXL01ZYzJQaEZUU2Q0?=
 =?utf-8?B?d3VqLzZTeWRNYm1RbFZjMmVOQkJoYW1RVmNjZEw3NVU2Q0tEelNwdHlZbnRX?=
 =?utf-8?B?cmVJaEsvZDNpWFdoSFVKbGtoeFlhRXBKQmtDNkhCWTBqSGJQeFMyaTBLZloy?=
 =?utf-8?B?emEvK2tlMFJ6MSt2NmhwVVVhTHc5MUxUc2F2eGlVd2dHb01xemxQdjNpQ1RY?=
 =?utf-8?B?RHFWM2t0by9lSEliUHJiODFmb2VPdmYwb2hIQUFIZGs1aVpJNmtlWTU1ZEtK?=
 =?utf-8?B?Sk1IYXk3NXlyY2tNTi8xSGYrWnUvNEJXeTFTWUdUUFdBYWt0bzJlUVdMS0s0?=
 =?utf-8?B?S00vaU03a1I3Z1ErMWVsY3VoaklzZUtUQzYyMXZUbE4wUEk2dmRvdVRaeEE0?=
 =?utf-8?B?SWVrWmNXYUdjOVM2TlpCZXhxNHJ3WFlaWEt6RjRab0E4STJHMDlCZkMwSzNL?=
 =?utf-8?B?dXFqV0FzR2trMERsMmxOZ1RYaWM1anUvdzQ3MGZXMm9ISGhnNXF6NHI5MDgx?=
 =?utf-8?B?VFlGRW1GTEZQY1ZDVEF4eXFlY2ZqSyt0a21iT3MwWm9GWURoN0wxd2pGYXBG?=
 =?utf-8?B?Z2c0cmw0NG9tck5BY2lHOVlmWmdHR0tQYlQvUFFNNWw2d3duSzZCWXFPK1FS?=
 =?utf-8?B?aVJBWTZVa3JFVlRVS1A3UGVnWUo1dWVpb0g1L2hUR2p2d1BSWGVpMUZUNGo0?=
 =?utf-8?B?NE1LTkVTWVVqYnZEblF5MENOVWY4dFFSd2MzNVc3cktyOWxYNUxGeFJGdGI1?=
 =?utf-8?B?OC84Nm8vem5zUWtEVkNVeTFGSEtlVzgzY3pJS3JSY3lkMXFESXE0VElKQ0Mz?=
 =?utf-8?B?STQza1hJVnFVMzFVMTRDNEU0RnRMcjNkWldkeHdnQlFRT1NOYWpUUUxyWVBB?=
 =?utf-8?B?NHMyby9Ea1dxYnJXUkxLa001V25YS0NsWmFuWUJmMnJVSkdaNjhDcDY1ekQr?=
 =?utf-8?B?Yk4zZjRjbHh5dVpmUytuME9adzg3MnNNU3FrWkVHNWdUcjZ2SzlaM2tyU3Nz?=
 =?utf-8?Q?LMSUwMWSHigSiCrNGBsy+sIuadzKMXAP?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eFduSjNEL1VKWnlURGJhbVdLSVRGUmpIRTc2aFdxZW5tQ0NLYkRkMWRHdkl1?=
 =?utf-8?B?MnZBczRCUVhxN0VhWm43ci9QaFdzbUltdlR1RDMzdlA2UzF0TzR1Z1pDYSs5?=
 =?utf-8?B?a2Vua3I5ZFptUk5oM3ZnZjBMRzdDcndGT2FpZ0tXWVFFOWxzSmZkV1VUeDBi?=
 =?utf-8?B?Q29Pek5QK0toNy93dFR6ZUZrbW51aFZIbUxtZVRSaHNsZklUbUp5aEFHZUwr?=
 =?utf-8?B?bUhBNGlpa1ZTdE9CQXNYWnp1VjVEY012U0FtV3RtZmtSL1IvTHh5Mk9YVlZm?=
 =?utf-8?B?MXBWR1EwZEtJVEFYRkRSYVJkVzRVSStXMExrYlRwS0tOSzkrQkdSZjZWSG1Y?=
 =?utf-8?B?MGpBaVoyUUZTV042ZW4zcXRNZXlDVzUvRklsc3RCbEZpbytxMFpjaEtJS0Nw?=
 =?utf-8?B?UDhEemZjbVBOaDkyeCtMbi9XOVJUa0FhQXArdWxKbEU1UDhkeHU2QXNBbFBH?=
 =?utf-8?B?U1NZTm9sYzlEMzBaUVo4ODFiTmdMSThGb1NnLzRQWGpMZUpHUnRwMlNCSC9F?=
 =?utf-8?B?dHJQMU9ROTBOSGw3U3lFck0rbmMvN25pZ0gwS2gxSmJ3aEpzZUFkYTB5Q2ZG?=
 =?utf-8?B?UkxvcG1sM1hGWnJmcy8vbnY2ZjV0dFhGMWlZY0l4bjFUa3JmOGJ1d3VzWnVs?=
 =?utf-8?B?SXBpeUZFRmluZ1pHdm1HQ1d4dkpnVGJ4aGk5a1lQTWZyYllHV0l5WU1rVElj?=
 =?utf-8?B?alh3SmdoTCtCdGFGODc3UFg4eWNhdjZlUG54NFJaNzZHKzRFYjBpWFRIcG1U?=
 =?utf-8?B?VldvWDBwcFZrb3ZXODEwVmN3YjcybmpUOUFsa3hiQldoSnNMak9GSWlLc3Rt?=
 =?utf-8?B?TEpaeDJsQlp4L0N5L2xmUE5WRkh6d2xpa0xRZk8wRGszUUJVNGlGczNDd2tI?=
 =?utf-8?B?VnR0RjFQRXZpZ25MenJFU21XVFpqajArRFh2Y2JrWVhMaEVvUWJIRGxwQk9i?=
 =?utf-8?B?aS9BTU5ldXFZampVU3lWZ1hlMlNULzRob09NdTlLL3AreDR1SkRJcGc4ZHJH?=
 =?utf-8?B?eUNYa05oVTRzSmVISDI2MXF4azduTmo0TTZxOGFPclBpWWJtUTlWYUFDMjh6?=
 =?utf-8?B?cnB0aHZWVVBsUTI2aFZBTWpaeHNiY29GOXJuRTJUYkZVY29TRTNtTVNSU3Jz?=
 =?utf-8?B?Qkl3NmtudzZpczJrMlRMdlNydS9NTXErVmNSTG1LSUtOYjgrSjJlMjBmcDFJ?=
 =?utf-8?B?YWV2Y3F4eFF0ZndCMnJRRDc0eWc3Ti9rTHd4WkEvS0VDUGNodGtjM25YK0Fj?=
 =?utf-8?B?My95SUVaZ0daVlorNzlOVTUxY0pCZkhOaU1nWFE2UGN3N2gvbzk4VjhVZlZQ?=
 =?utf-8?B?UDcrWGhLOTZUbW96bW53NFFrY0REcVQ5VGdRT2s1bDBZWCtBUE53blRTN0hs?=
 =?utf-8?B?K0xrUkJ5YjlQYlNhWCtrNFlWMEFYRUZxdW5ZQW5mRVhmNTZjMkZ3ckxTK3JS?=
 =?utf-8?B?OVlwT2pwQ3cxZWc5UGl1TE9pQ0JUR0NYSTAwMkpOMDlMa3c0OFhzcmdwWVE4?=
 =?utf-8?B?U1dGNU10aE9SaXpJWXM3bnR2N3V6MDRuekgrM252RUo3NGU2M1NDN3h2dmdQ?=
 =?utf-8?B?UVUxVk5oMWpkSk42YXVYbmorQWpDOEVMUW9RNEVscGJHZHFPQ1EwYWlhR2JF?=
 =?utf-8?B?RGFlN3NzcWlpTkZOcTlBSUwvZlB6OHFkNzJibmtPdVMzOWpDYkRKUHZLR1pu?=
 =?utf-8?B?clJ6LzI1RzRFNkpKMUFQY1BsL3ZKZkZ1MVpaTUJ1dStCZjRKUE5LaFVXa2xV?=
 =?utf-8?B?ZG02c2RmZmpoTFFXUWtTQjBxanIvK0JaeU9ReDJxb3dhbmkvOHRneFN0a3dJ?=
 =?utf-8?B?citIU1A1d0Q1VXFFbHlxc0JUdWI3ODBuc1RRdWVVaFRGZytJZFFhVExNRGxM?=
 =?utf-8?B?UThRc25LWE01Sk9NdFU4M2JUdDg3Rm5mK1hCYlpFMjI5eTNsQ2dGM3VVNUNi?=
 =?utf-8?B?Kzl5dll0d0lGcUplc21Pa0doSnJUTC9ucWhML0kxWEFKRU92SjVtN1IwdkNM?=
 =?utf-8?B?UllvQkwyMjJ3SFBHWUlXWHFMc1VJS1oyQ0pvWXdqS25lYVZaZWZTZXk3NXBn?=
 =?utf-8?B?YkdKV0tQaGFzc29NaTVoeklTSzZ5YjdhNndkYXR4ZTF3QjBLQU1JZTI4UWRV?=
 =?utf-8?B?dTlmQmpWMWdRR0JOeHZnajRGN3REYXhtZCtTUFB5Uit1cnB6aGhlTUhCakcz?=
 =?utf-8?B?dUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5784e6f7-eb9b-43ea-81ee-08de079a9397
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2025 01:16:01.7341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m1wwoEjX/zLjwfhRX4yTt1Z3R+6ObQ6+4+WvdQU+yJbJbQEATmKDMT6d0Uyl0YJpKmcXyiNNHAT8ro12qJWj8d3616IgKRd10wPyImK+WLU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8683
X-OriginatorOrg: intel.com

Sean Christopherson wrote:
> Trimmed Cc: to lists, as this is basically off-topic, but I thought you might
> be amused :-)
> 
> On Thu, Apr 10, 2025, Sean Christopherson wrote:
> > On Mon, Mar 24, 2025, Chao Gao wrote:
> > > Ensure the shadow VMCS cache is evicted during an emergency reboot to
> > > prevent potential memory corruption if the cache is evicted after reboot.
> > 
> > I don't suppose Intel would want to go on record and state what CPUs would actually
> > be affected by this bug.  My understanding is that Intel has never shipped a CPU
> > that caches shadow VMCS state.
> > 
> > On a very related topic, doesn't SPR+ now flush the VMCS caches on VMXOFF?  If
> > that's going to be the architectural behavior going forward, will that behavior
> > be enumerated to software?  Regardless of whether there's software enumeration,
> > I would like to have the emergency disable path depend on that behavior.  In part
> > to gain confidence that SEAM VMCSes won't screw over kdump, but also in light of
> > this bug.
> 
> Apparently I completely purged it from my memory, but while poking through an
> internal branch related to moving VMXON out of KVM, I came across this:

Hey, while we on the topic of being off topic about that branch, I
mentioned to Chao that I was looking to post patches for a simple VMX
module. He pointed me here to say "I think Sean is already working on
it". This posting would be to save you the trouble of untangling that
branch, at least in the near term.

Here's the work-in-progress shortlog:

Chao Gao (2):
      x86/virt/tdx: Move TDX per-CPU initialization into tdx_enable()
      coco/tdx-host: Introduce a "tdx_host" device

Dan Williams (5):
      x86/virt/tdx: Drop KVM_INTEL dependency
      x86/reboot: Convert cpu_emergency_disable_virtualization() to notifier chain
      x86/reboot: Introduce CONFIG_VIRT_X86
      KVM: VMX: Rename vmx_init() to kvm_vmx_init()
      KVM: VMX: Move VMX from kvm_intel.ko to vmx.ko

I can put the finishing touches on it and send it out against
kvm-x86/next after -rc1 is out, or hold off if your extraction is going
ok.

> --
> Author:     Sean Christopherson <seanjc@google.com>
> AuthorDate: Wed Jan 17 16:19:28 2024 -0800
> Commit:     Sean Christopherson <seanjc@google.com>
> CommitDate: Fri Jan 26 13:16:31 2024 -0800
> 
>     KVM: VMX: VMCLEAR loaded shadow VMCSes on kexec()
>     
>     Add a helper to VMCLEAR _all_ loaded VMCSes in a loaded_vmcs pair, and use
>     it when doing VMCLEAR before kexec() after a crash to fix a (likely benign)
>     bug where KVM neglects to VMCLEAR loaded shadow VMCSes.  The bug is likely
>     benign as existing Intel CPUs don't insert shadow VMCSes into the VMCS
>     cache, i.e. shadow VMCSes can't be evicted since they're never cached, and
>     thus won't clobber memory in the new kernel.
> 
> --

At least my approach to the VMX module leaves VMCS clearing with KVM.
Main goal is not regress any sequencing around VMX.

