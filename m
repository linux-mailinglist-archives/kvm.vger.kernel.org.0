Return-Path: <kvm+bounces-69357-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eVW9FI9Demn34wEAu9opvQ
	(envelope-from <kvm+bounces-69357-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:12:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A181A699F
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:12:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 48FA43007883
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 17:12:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA379248F7C;
	Wed, 28 Jan 2026 17:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a26+wCNM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F18630F94D;
	Wed, 28 Jan 2026 17:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769620354; cv=fail; b=JsIy0LZWZ5WYXr3BC82BdtJ2lHR2i/LdmiLLCdn0R109ytAI5NUMfveWo2qJ7cliHpTL4Xfi9xsGj3EMa5I7CEN7hblAsWJuiB66n6x193nAD//nFUEkZDcIecnawwjpuYSJmOAV5g/NYPIixu0TmKRnUV1evHxkB/eD/uleTgU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769620354; c=relaxed/simple;
	bh=GVhdg8sk+WgAkGYt6Nw9Jo+0oJ4jC+TmxnqP4Z378Gg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ur30IsAfwz6zZo1dyFertmlM25iOuDplpA5F53lVLBWJ0XEg3M2OFF/rCIUiGepl1FadZCBxJdfILVfnf9Xho8z6g531ryJ7F/ZfZ96L29S9CE9V3uNBayCAJbO0yxPWdM1mmqTaFi4msKHxCxzIa3jFDV3jcBqiodEv/AEX8z8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a26+wCNM; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769620350; x=1801156350;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=GVhdg8sk+WgAkGYt6Nw9Jo+0oJ4jC+TmxnqP4Z378Gg=;
  b=a26+wCNMWALNl/h82nlo2E0antREd5GaauO7A56jpr/6nBOid1paeEMF
   Jvmv7sgiRQdKyOrWrbgRXlqdmksZRPjH68i+qdotUpdGUm102lxVbtYh8
   Tp/Isyw8B+fPONxzm7L0xbcitKIJBIUZQD4afCgtm6ophQpb10YUqxVuM
   3PXcc6BcT0LDKYlFODGVQe+tI1MdqeccnLEMJ3Kun1LDwq2JuCgX29ppu
   1wM2i/W97GukraSQgf32KG5jtD74WplNRzMrBJfuat4b7JIc4tzd2xvDn
   fbJcxX//wLbmlZ36v4Cgm+XkhmGk4w0NWrkwIjWVMzhx1CjwlrzhhTwNp
   g==;
X-CSE-ConnectionGUID: 7Pl+U666TBmoLu8vZPmQ6Q==
X-CSE-MsgGUID: letgBHGeT+aMmSKHh7eHEg==
X-IronPort-AV: E=McAfee;i="6800,10657,11685"; a="81156217"
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="81156217"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 09:12:29 -0800
X-CSE-ConnectionGUID: PwT7/e/uQlKKi0fRl6D+Yg==
X-CSE-MsgGUID: vj6X644NSPmqZ6Vrq9u1aQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="207557852"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 09:12:28 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 28 Jan 2026 09:12:27 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 28 Jan 2026 09:12:27 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.49) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 28 Jan 2026 09:12:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZVcZVv2buX6IW0Actd/wL2KpHw1azfrrXPkjw9dSC6YkXN9NRAz5sg9g8Hhf5ybT8j2ZpGMtBwPoS6sT/609lpCTkikae43xqkuLYpJnMz+UnmvjQdxjbNWUXGvMWT9hcif+hTeyB8tIhs4Oq6Y9J5rOneCH/Z9FPcqtKgXKDGAZb1uMRUrSg4hbSIAIcOsulahrxxnOCik83f4uh4Y+BQnhHQPfOqjxeRRYA84if28nD6eypi0sgAv7PgEwHVMFRwlVxbYj4kv2H3pF93QLKP1rxibwVdXH5hrzJ90hD5rlpw4pHB0C4bxonq6O//HkZ6/nMajAWs7d+l9SUE5UHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3VTjRAihKCO5xUyzM67ckRhXq4KdXy6i+t+Nm5X0PLk=;
 b=NCTxBdWT3Mv7dpjRSe6VmgwdFPCqkeQs6HFsCmQ7R8EJF5SifYM4ndKi+5cwYD5b4t1uLiVZpI6W5i5tNMcsOuy0PdYbpn5Fj3LXfY973JfjrWOHfIFJWFknW3j7yVaLMHN/0MDtR1buyPShQU7qd9iVI2xMfrnNXnxl1c63yLMOZuUGsVvz+NkspGI4lWLdxsXOyi78hxivb5a0+ktV2E92BH4W4i1TTdLhPBbmjnKiOcdv18lFESKYWqOcaL3c5jxILJcXX/cfpVcTtB37BCh1DfBEp4b9ES7XHi3oJ2a7PYtg5w9fDnOvR9zg5MlqXIyzFy7RdHDzcn6ib8LZjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by CYXPR11MB8690.namprd11.prod.outlook.com (2603:10b6:930:e5::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 17:12:23 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%3]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 17:12:23 +0000
Date: Wed, 28 Jan 2026 09:12:21 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: "Moger, Babu" <bmoger@amd.com>
CC: Babu Moger <babu.moger@amd.com>, <corbet@lwn.net>,
	<reinette.chatre@intel.com>, <Dave.Martin@arm.com>, <james.morse@arm.com>,
	<tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<peterz@infradead.org>, <juri.lelli@redhat.com>,
	<vincent.guittot@linaro.org>, <dietmar.eggemann@arm.com>,
	<rostedt@goodmis.org>, <bsegall@google.com>, <mgorman@suse.de>,
	<vschneid@redhat.com>, <akpm@linux-foundation.org>,
	<pawan.kumar.gupta@linux.intel.com>, <pmladek@suse.com>,
	<feng.tang@linux.alibaba.com>, <kees@kernel.org>, <arnd@arndb.de>,
	<fvdl@google.com>, <lirongqing@baidu.com>, <bhelgaas@google.com>,
	<seanjc@google.com>, <xin@zytor.com>, <manali.shukla@amd.com>,
	<dapeng1.mi@linux.intel.com>, <chang.seok.bae@intel.com>,
	<mario.limonciello@amd.com>, <naveen@kernel.org>,
	<elena.reshetova@intel.com>, <thomas.lendacky@amd.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <peternewman@google.com>, <eranian@google.com>,
	<gautham.shenoy@amd.com>
Subject: Re: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
Message-ID: <aXpDdUQHCnQyhcL3@agluck-desk3>
References: <cover.1769029977.git.babu.moger@amd.com>
 <17c9c0c252dcfe707dffe5986e7c98cd121f7cef.1769029977.git.babu.moger@amd.com>
 <aXk8hRtv6ATEjW8A@agluck-desk3>
 <5ec19557-6a62-4158-af82-c70bac75226f@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5ec19557-6a62-4158-af82-c70bac75226f@amd.com>
X-ClientProxiedBy: BY1P220CA0009.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::7) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|CYXPR11MB8690:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a176700-8efc-4795-b28c-08de5e906755
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?hbFDlvbA7RauilVqmXzXPpF+XzC/NzsHRsgmjCny7NyIuPaGDK8lA3EzEu/9?=
 =?us-ascii?Q?xKulaS7e21oHZfGq92FjXPkyXs3S0wAyqVL836ybBcQs73thOJeVaCjcTb/G?=
 =?us-ascii?Q?rHRIWIjQqfgZxbDtG2NPSdMhnzw+3GyGTsFTpjdcDRuMPwYk4xVJrviatzni?=
 =?us-ascii?Q?UAcgw9Zt8PgbavXmmM5z7sH+Lh6qqrgybvJMVmKS5kJ/OecynCPVwhG63YOp?=
 =?us-ascii?Q?4V1Bvq3e0XUj8+w0s2trBvuonTToWxIW90qFy3Kk/vW/qi8OuGq6KPjNwUTA?=
 =?us-ascii?Q?NSmwppA0M0pDk2KK/jlVTh02PfcJgBnqTlTMDxhwwG5TVNIr0PSEJGTI2rOE?=
 =?us-ascii?Q?CFhGrIvuiuNcni9juLrRw3xn3gP3uDBbuH8xxcdlBBiaX1slrseR6yxHt9ml?=
 =?us-ascii?Q?ZinZ/uY7MWjHH2+Qadrx8iz5cBX+Et/dJJw6nkqCN7Mkyb7oHtQwF4YuQlHn?=
 =?us-ascii?Q?WZ0foRUTOPz3Z8Pu+TmplrSivYsvVWXSCCHqi2zQf4fNYWHPkqnlfmpkFDeG?=
 =?us-ascii?Q?Pvn1Dz5wzDwm0ki3i2Y3PgpfAonORfqRS5b4l9zJhiRcLBwBgGm6CXUGkB0Y?=
 =?us-ascii?Q?Ga/HNFwvlDGjLGmmO+ntlGay9yHYXY74jtKoeKjVXoRZjL+O3L9X6cRwI7JZ?=
 =?us-ascii?Q?z98qu5JEJi9HsMJu8/YvhST6dPv1qZVbps8YEohDLs9eTqNgAqiEvWwVMSeP?=
 =?us-ascii?Q?j3hnmWb7uZXaPurk4J5f+h8tu3vH1mr9d/1YFBa5dB5Pwp2ngqAMXpOeR5ZW?=
 =?us-ascii?Q?3HA/hxcXQyiV5E58BosyxakaIf3ykPzYDi21IRC/2lGH3FKQCFIEII9kQTcW?=
 =?us-ascii?Q?tkYIWVh9+wPLtZGWyn7+N8X0Eeewz1Wzpe8iWQcfuZv/NGjZNHTHqoOQ2ClH?=
 =?us-ascii?Q?xMxRfrFeq3FBXNJDByoR/q5QpCaRnAx70go/UW7kjdnGGTCRVTECb4leu7HE?=
 =?us-ascii?Q?skWTkQu+MCqde7oifYrwm6TzlsDfhFWGc/qW6ByJ9Rg894ZXu+EzY0OHShoe?=
 =?us-ascii?Q?7gGgzt357C6amnbTZOgtb4QfvUbQv3sHD8nDe151DUHQPUmrYj3HFvioxhts?=
 =?us-ascii?Q?BeiZfN5/+p137nVgqNGeyUaZMhLCPOCp6UtjY9/9lQOJppPAKayRXeCB1sFN?=
 =?us-ascii?Q?Ar47fDrC0d0c6Il81/9d2grreLxi1QRPlGtIO7Emys43SG6rUeF0wx9XQIzM?=
 =?us-ascii?Q?UkTMSjttcPZQdk1foZxYnbSDgNFSF7/FBAKGzriqomvJYxVNspB+R3LWCCFt?=
 =?us-ascii?Q?UQD44shSfxUg2n4I7mDdGiJBiWLvkRXj87aaIXIG1MggirthbVK5YYFUNnJE?=
 =?us-ascii?Q?LFiGb6Ej2pM9VDwsRCv9/CQBqKOedVlRJqHmyR7C6THol4J/zIsnhnyfHqwS?=
 =?us-ascii?Q?P99/o4xYOtDrWcdXxuonElumrbjQfIEYREBcXowkxVlYd/Lizz3VRbZDJCpc?=
 =?us-ascii?Q?IRHcBlJ6Jo8g6GFv1WhjSz9/oMYdMxBQYaXsxTW6KJgrXu1eqAVTw4p3UEKY?=
 =?us-ascii?Q?iAWKUdJdQXGx8vJY3o221au23Ig79K9s2tTmWnRrWLZz/d4mmfW9wc5wSWmL?=
 =?us-ascii?Q?N7UPRyOOHipbeJGMUpI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6GKGfsEaI2mEDVPU7BL6/8gXwnS5wzDKWDpbpvzw7vxrf2s/74ROZnxO69Ku?=
 =?us-ascii?Q?r222JzIV2/jWEgUOqiemHbXa1Dil3Pi6eP9wQPE/MGHDYKduRmfKcvBfKCLY?=
 =?us-ascii?Q?TB5GIK37nt4MA53lSZPSJtYflpy/+dETtJyUYlTLvR8Tj0EqHOoEdKmgFjE1?=
 =?us-ascii?Q?xIfosaUElmNwdeGddZca3mCHcgZbso93D2yisJvtxTnwF5vMEFzX86FSQMYa?=
 =?us-ascii?Q?oOgecMjDZSbQ9RNc5RHK0OT7DDCGX2eTk4rM+T4HAMt+cq0cJYdDRkjR2S5d?=
 =?us-ascii?Q?e5Ym7fBPdizJWsU3MusnT+KjRnGNGieyXnMIrv/vMsyuwZW4PLu5wyBaTPYK?=
 =?us-ascii?Q?/+2QH5629ofuLU6QE376Ue5pPnjfMskb6KwKF4GtVchbLn55xz5xctN/uV77?=
 =?us-ascii?Q?MalPERPLSiqgwMcpJYG0uzusf01kG40+bOdvDzMnf4iof2kjc1/JuQAGsk4+?=
 =?us-ascii?Q?7XbVdfgse9hyZ2SyF5Io7uXluiJSz5MdjLKl27EtVuYlSZTTF4pP+eq8M9/3?=
 =?us-ascii?Q?J50fe9nleVhD853o+6MknCesqhoXa3ixrYor20MgDIlbi7NQ/TwYz9U20p9c?=
 =?us-ascii?Q?v1wHql5Zhv27uxKpnRKRiQkTlGX9QC9dYvvMqNG++cqm7+EvPRZgkvyDupJ4?=
 =?us-ascii?Q?xLqetzwCZIsVEzgZ1tixgYdGlCrdEPd1fep6Eb7jnKmaW//ko3EwxuPHBcjU?=
 =?us-ascii?Q?Kbg0Gsps1w9Dl9wB/QRbhnhNsNK9OmNxrYpG264bbeAE41UB7LLIAVNDkISY?=
 =?us-ascii?Q?xeDTdsYGB07c09VSuN92vA0jBUh8hLNrdnnV98+2RotpDN0tXfXoC0lri0jg?=
 =?us-ascii?Q?KCVlEMpfbpAKRDW5Bj3Y4Y3nmXUsKpdSw9PYBkRWjwZ2QWFFjaB0RFD97r4q?=
 =?us-ascii?Q?QdV5iinONZMDBJDfJGKcR341NXO1uLmedjhpcRAruhRgA2prmsqnKUaoa+cS?=
 =?us-ascii?Q?PBQvrgBljtPu7TnIul6+ZnSuRjEfFPBbeOnZHndVjNIC5t2A40+xKiHoPp0s?=
 =?us-ascii?Q?97uoguT5Wg5dgsSzU4WnHbBYpUlSgHIs6xHpbWmNUgYrAvEGssC8Zg9UGhBO?=
 =?us-ascii?Q?Lbb7KGrlOsX++WLTA2bv80lhXegoQe+uqRmIJCcgbOuRFsExoZSR1Qzfp0Xo?=
 =?us-ascii?Q?e7nMXtepTWCekoyuvHfaSG6KqY0C7CD+I7Qc/QBCxk22B8C9l8cwe2zKR4XC?=
 =?us-ascii?Q?oVtc0mI2F8z3qOpVpz8cymoYgJeTflHPHBM1NeAhXKB4PjPyU16MemUWRaNR?=
 =?us-ascii?Q?3bP6erre1CfFz8XRzS9+o0s+AnBCRxwdc2M+0gqZpgJZJ3TxL5UOnUOX/MU4?=
 =?us-ascii?Q?iLye0BEJem9+8EUAvuZLzUZxLL6n1+oTO+6iTuAQEDd4uq1rBI6udQFbq9Gj?=
 =?us-ascii?Q?9JMI7C8n00sM1bI0pcBLvGxjOYTAc+OvI73+Jbc4EzJzvlbFoypRIASBFMTd?=
 =?us-ascii?Q?r/wIz6kCJfk4saxMTY6lyJugZAkJdlc/uLfosDw5e3Ho4dauHk5cSqsMh2o6?=
 =?us-ascii?Q?S7Wu7zTn+H/Ut5iVoyatiE7eGySBVsMIXB4w5NPjbMuHkc+Edbsbp9SRmjjn?=
 =?us-ascii?Q?Vf3+U4wba/yBb5N2oVi0sLUYEynwdLYBzzcLZ+VCBlipOh+OAZ49iW0eMYTE?=
 =?us-ascii?Q?3E0uVqagpVJOIj8oAjRlzmgR2WDSjTNvYcmk2eSiXJ32jFQnHySJmSxCUdeX?=
 =?us-ascii?Q?vAhBArpiUtCMcPKcgwDzk77PKwOxNzCVW88IKH3PdxtTT4J6oZsL0BO/z01/?=
 =?us-ascii?Q?zDYaJ8tDwA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a176700-8efc-4795-b28c-08de5e906755
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 17:12:23.6831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u1c1h1OHd/ek7wr7YgN0EEX+QxG3eM+CwxlcDzi6MgpmFQwYorMULFILTkPutxsso3BaHIaG4eG7KkIHDVvfKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR11MB8690
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69357-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[44];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tony.luck@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MAILSPIKE_FAIL(0.00)[172.232.135.74:query timed out];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 1A181A699F
X-Rspamd-Action: no action

On Wed, Jan 28, 2026 at 10:01:39AM -0600, Moger, Babu wrote:
> Hi Tony,
> 
> Thanks for the comment.
> 
> On 1/27/2026 4:30 PM, Luck, Tony wrote:
> > On Wed, Jan 21, 2026 at 03:12:51PM -0600, Babu Moger wrote:
> > > @@ -138,6 +143,20 @@ static inline void __resctrl_sched_in(struct task_struct *tsk)
> > >   		state->cur_rmid = rmid;
> > >   		wrmsr(MSR_IA32_PQR_ASSOC, rmid, closid);
> > >   	}
> > > +
> > > +	if (static_branch_likely(&rdt_plza_enable_key)) {
> > > +		tmp = READ_ONCE(tsk->plza);
> > > +		if (tmp)
> > > +			plza = tmp;
> > > +
> > > +		if (plza != state->cur_plza) {
> > > +			state->cur_plza = plza;
> > > +			wrmsr(MSR_IA32_PQR_PLZA_ASSOC,
> > > +			      RMID_EN | state->plza_rmid,
> > > +			      (plza ? PLZA_EN : 0) | CLOSID_EN | state->plza_closid);
> > > +		}
> > > +	}
> > > +
> > 
> > Babu,
> > 
> > This addition to the context switch code surprised me. After your talk
> > at LPC I had imagined that PLZA would be a single global setting so that
> > every syscall/page-fault/interrupt would run with a different CLOSID
> > (presumably one configured with more cache and memory bandwidth).
> > 
> > But this patch series looks like things are more flexible with the
> > ability to set different values (of RMID as well as CLOSID) per group.
> 
> Yes. this similar what we have with MSR_IA32_PQR_ASSOC. The association can
> be done either thru CPUs (just one MSR write) or task based association(more
> MSR write as task moves around).
> > 
> > It looks like it is possible to have some resctrl group with very
> > limited resources just bump up a bit when in ring0, while other
> > groups may get some different amount.
> > 
> > The additions for plza to the Documentation aren't helping me
> > understand how users will apply this.
> > 
> > Do you have some more examples?
> 
> Group creation is similar to what we have currently.
> 
> 1. create a regular group and setup the limits.
>    # mkdir /sys/fs/resctrl/group
> 
> 2. Assign tasks or CPUs.
>    # echo 1234 > /sys/fs/resctrl/group/tasks
> 
>    This is a regular group.
> 
> 3. Now you figured that you need to change things in CPL0 for this task.
> 
> 4. Now create a PLZA group now and tweek the limits,
> 
>    # mkdir /sys/fs/resctrl/group1
> 
>    # echo 1 > /sys/fs/resctrl/group1/plza
> 
>    # echo "MB:0=100" > /sys/fs/resctrl/group1/schemata
> 
> 5. Assign the same task to the plza group.
> 
>    # echo 1234 > /sys/fs/resctrl/group1/tasks
> 
> 
> Now the task 1234 will be using the limits from group1 when running in CPL0.
> 
> I will add few more details in my next revision.
> 

Babu,

I've read a bit more of the code now and I think I understand more.

Some useful additions to your explanation.

1) Only one CTRL group can be marked as PLZA
2) It can't be the root/default group
3) It can't have sub monitor groups
4) It can't be pseudo-locked

Would a potential use case involve putting *all* tasks into the PLZA
group? That would avoid any additional context switch overhead as the
PLZA MSR would never need to change.

If that is the case, maybe for the PLZA group we should allow user to
do:

# echo '*' > tasks

-Tony

