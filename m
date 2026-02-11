Return-Path: <kvm+bounces-70892-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ECTfD8fcjGm3uAAAu9opvQ
	(envelope-from <kvm+bounces-70892-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 20:47:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 93DD1127412
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 20:47:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1EEDD301AD3B
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 19:47:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 336CC347BDB;
	Wed, 11 Feb 2026 19:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A10Hlt//"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09EF0242D83;
	Wed, 11 Feb 2026 19:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770839221; cv=fail; b=pB1brl+DX+ZK/Zdj8Zhuxg3ZKW93KdEebLbiNDXn2t78KeBoaJKUifYkf7VqYFmeF+fYOztGTuz4+TqUvsqnPmKrdpwqx/SuIdKYZQB4IHiaHHHHKp0aBf00xnHA+LM+d4+miiPrruFsAkODw/rPGPuHYvxlKJthtlWM/yVejUE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770839221; c=relaxed/simple;
	bh=ipYRkp5JB37DWQasLT+g8wc6Oei9c2K+GMTbNBS+cxs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GIVHnRFfN13L9062CeszjnyMz5+/ri0r2dXIG4myjamKP3wMRbvg9jQTUqYyhUSmfXjgg5ljyBtiHrgZM05e36ieFbH7fAkYQOygj5eGi/MwL6w3yYpuSCL9GVLGHmEvZDEmdPtDQ2LmzetLBySMKjqHcoiKrvnUNKsfbZJF3Xc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A10Hlt//; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770839219; x=1802375219;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=ipYRkp5JB37DWQasLT+g8wc6Oei9c2K+GMTbNBS+cxs=;
  b=A10Hlt//S9+pfBKqqLE3/lsYr0iIcj/+5oKbXsnnLGuOXYxW5Spjdj/7
   CEpl5+JI1jglJIfkHoeX998hDckQxxaPKtRrlDSRddgj3+4mNr4/B3qv2
   bbi5dvuAr9MPm717bzp250y8wrvHet0vcDNzvGUL3ee9G/38t1Wl+kdXy
   8xJQHHyDqSDW9/OLgq23b8ai2KjPbutuJAAI98qvGo2IM0UebsOHTTfnf
   WdBt5NekrlzPEFH28XAPfjNZZTfpW0JPPnWEF4bwi6pnFmHuM77WyZtuL
   jmZjExtLEoftRK0m9B/47RKF2PO/bBOmyxskNUe5p4a6mnagXuC8RBUqI
   g==;
X-CSE-ConnectionGUID: 3r0EG9WGS+2rdBqKyGB0eA==
X-CSE-MsgGUID: EtLBcmocSYuEmTsHD3rFjw==
X-IronPort-AV: E=McAfee;i="6800,10657,11698"; a="83439587"
X-IronPort-AV: E=Sophos;i="6.21,285,1763452800"; 
   d="scan'208";a="83439587"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2026 11:46:58 -0800
X-CSE-ConnectionGUID: 975eXlPkSLWEKhDhM5PFoQ==
X-CSE-MsgGUID: lMjZGSjhQN67q8AQqmV4Pg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,285,1763452800"; 
   d="scan'208";a="216867076"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2026 11:46:58 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 11 Feb 2026 11:46:57 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 11 Feb 2026 11:46:57 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.65) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 11 Feb 2026 11:46:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tonZDBS45PVYQmRsTsaZikcLQtMOn/h/vBLYyrC/JbKZ0Jq1dkajl0p4lCMON1D/eQkG09ak5bJp66ScJUx4I0vbWwVOEYya9WPA74YMkh1t1O5b9WCkcUJrFqmqKCppz6VCRXDfKOrXB3rxyHcsomciaEhLhElDl74mlPW/w8dIr2JR4gt/4jWogtjdmjbsB/AKyb9W0Xgn7F7ahOGZwoConVo7G+xC1g+dBXkZRkebfhS1zgVbuLffxE12wFhGr7VfwCQnzAB5t7Dhc9h2lnKfzmVy1onwsa7Jagr+VqvIEYzgb9m/HC0C07nDlbOzTac9sGJE1XhLH5POVx0v5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Jbshk8TpYGHx57ZOoORo9YWTh5nTqMtlP2UD7YQC18=;
 b=QTnE2o9B1rMlzVl0Bqcxrd33+dVS6Ahl+BijxHrbzAlK6IYM7GlCxFcqB43WFmAeVdaE+M/OC1MYriHeujTJER3JATG615ynsq4N5uQyIL4i4w5AL6gGbLGkNU5niYgqYqB4zm0nlypWsb/CFGxWAekg3DQrcPTT1mAWzUEEEL08oqjuDrjc+iIj+Kd+bC1BBLbGqDEqrHem5u4F8nyhrSGyiLn0Cy9S2H81wBSUOiSNSTtEnzVMzz1groODhyWoGIklICxAFgvN8idIG7kw7XRi/YWAznHQrUl8olyTR0v0z7ttlt1kLKBeN/9XmtFXoW4t/r+INcdpnTiVObk9Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB6077.namprd11.prod.outlook.com (2603:10b6:8:87::16) by
 DS0PR11MB7958.namprd11.prod.outlook.com (2603:10b6:8:f9::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9611.10; Wed, 11 Feb 2026 19:46:52 +0000
Received: from DS7PR11MB6077.namprd11.prod.outlook.com
 ([fe80::5502:19f9:650b:99d1]) by DS7PR11MB6077.namprd11.prod.outlook.com
 ([fe80::5502:19f9:650b:99d1%7]) with mapi id 15.20.9611.008; Wed, 11 Feb 2026
 19:46:52 +0000
Date: Wed, 11 Feb 2026 11:46:46 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Ben Horgan <ben.horgan@arm.com>
CC: Reinette Chatre <reinette.chatre@intel.com>, "Moger, Babu"
	<bmoger@amd.com>, "Moger, Babu" <Babu.Moger@amd.com>, Drew Fustini
	<fustini@kernel.org>, "corbet@lwn.net" <corbet@lwn.net>,
	"Dave.Martin@arm.com" <Dave.Martin@arm.com>, "james.morse@arm.com"
	<james.morse@arm.com>, "tglx@kernel.org" <tglx@kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
	"vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
	"dietmar.eggemann@arm.com" <dietmar.eggemann@arm.com>, "rostedt@goodmis.org"
	<rostedt@goodmis.org>, "bsegall@google.com" <bsegall@google.com>,
	"mgorman@suse.de" <mgorman@suse.de>, "vschneid@redhat.com"
	<vschneid@redhat.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "pawan.kumar.gupta@linux.intel.com"
	<pawan.kumar.gupta@linux.intel.com>, "pmladek@suse.com" <pmladek@suse.com>,
	"feng.tang@linux.alibaba.com" <feng.tang@linux.alibaba.com>,
	"kees@kernel.org" <kees@kernel.org>, "arnd@arndb.de" <arnd@arndb.de>,
	"fvdl@google.com" <fvdl@google.com>, "lirongqing@baidu.com"
	<lirongqing@baidu.com>, "bhelgaas@google.com" <bhelgaas@google.com>,
	"seanjc@google.com" <seanjc@google.com>, "xin@zytor.com" <xin@zytor.com>,
	"Shukla, Manali" <Manali.Shukla@amd.com>, "dapeng1.mi@linux.intel.com"
	<dapeng1.mi@linux.intel.com>, "chang.seok.bae@intel.com"
	<chang.seok.bae@intel.com>, "Limonciello, Mario" <Mario.Limonciello@amd.com>,
	"naveen@kernel.org" <naveen@kernel.org>, "elena.reshetova@intel.com"
	<elena.reshetova@intel.com>, "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "peternewman@google.com"
	<peternewman@google.com>, "eranian@google.com" <eranian@google.com>, "Shenoy,
 Gautham Ranjal" <gautham.shenoy@amd.com>
Subject: Re: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
Message-ID: <aYzcpuG0PfUaTdqt@agluck-desk3>
References: <cover.1769029977.git.babu.moger@amd.com>
 <17c9c0c252dcfe707dffe5986e7c98cd121f7cef.1769029977.git.babu.moger@amd.com>
 <aXk8hRtv6ATEjW8A@agluck-desk3>
 <5ec19557-6a62-4158-af82-c70bac75226f@amd.com>
 <aXpDdUQHCnQyhcL3@agluck-desk3>
 <IA0PPF9A76BB3A655A28E9695C8AD1CC59F9591A@IA0PPF9A76BB3A6.namprd12.prod.outlook.com>
 <bbe80a9a-70f0-4cd1-bd6a-4a45212aa80b@amd.com>
 <7a4ea07d-88e6-4f0f-a3ce-4fd97388cec4@intel.com>
 <1f703c24-a4a9-416e-ae43-21d03f35f0be@intel.com>
 <aYyxAPdTFejzsE42@e134344.arm.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aYyxAPdTFejzsE42@e134344.arm.com>
X-ClientProxiedBy: SJ0PR03CA0232.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::27) To DS7PR11MB6077.namprd11.prod.outlook.com
 (2603:10b6:8:87::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB6077:EE_|DS0PR11MB7958:EE_
X-MS-Office365-Filtering-Correlation-Id: b1d62691-1749-4921-c86b-08de69a64da4
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YkZvU1B2SnBwY2hoNjEwQW9DTEQ5aThRWkgxSnVBdXpTbWRyc2VLWmUxb3JB?=
 =?utf-8?B?RHdOOEdTVlFvRldvSVNUNzJMTmZlUnJnaEV4aTJOUkYzbTBaL0FDRGVKR3R6?=
 =?utf-8?B?U2ptTlppbjlZWDVqUE9INFV4N1RSZWtDd0JmSE01ek9PZkJ4MldFNTdrVVp6?=
 =?utf-8?B?ZnlPeGpiNFE2d2xEY2ZmVnRzQjg0c3UvUzdjZU9lbGt6Q056TW1uTU93a00y?=
 =?utf-8?B?elFHR0lCZ0ZjdkVNU3pxYklKc2puaXo1UHNWRE9Ibks1U3FlWitpenNjYjcx?=
 =?utf-8?B?c25UQ2FmaVNBVVpkVlhaRUxXenplNDU2ZTMzMHBnc05MS0VKYWxtU013b0Zr?=
 =?utf-8?B?TDkrc3Rrc0NIbENIOEk0YkN1NHZqRWdST3l2WDdINHBFYWFlaUhZWk1Xd3M0?=
 =?utf-8?B?ZVNubTl0VnpwYXNJQ2g4ckhPZUpSUEVSaEVLQ2lmSTIvckZ0c3dBZUVpMmpB?=
 =?utf-8?B?TGNXbXpQcVlUakdNTDN0UGp0QVpPbDZZSTl6RHI3MEEyUjIweWpvVWl4cTZn?=
 =?utf-8?B?d1p5aUxQRmdyQUQ0MUVVMjIzYUx3ZlZac3Y5MEsvcllZTFlkNFdDMmJMUkhT?=
 =?utf-8?B?ZGpFVkpPWFhOYVY4TzViNEI5Y1dGS3hkR0hxZXc4VkJHa3d1OEV3cDVDcDNH?=
 =?utf-8?B?SkVUdW5zQmMzT2FiYXpKd3pzTmk5djYxd1ZVcWQ4dlBrNGYvVFF1aStreVNU?=
 =?utf-8?B?cnhwVVkyZkFBZE4xVnFmcHFyTW1HcFd6V05uSkppdXVMY29pMjZMcXh1WS9F?=
 =?utf-8?B?c05Dd3BrWVA3NHl4czNmVm4vTXpWYlJKNkl4S0owbmNFV2RLTGhkSXNpNWhi?=
 =?utf-8?B?WGxiSHNNWnkrSThubHA5NXltc1hUUjZtQ28yc2Q0NFJpdlhZdGRYV2ZPSnI5?=
 =?utf-8?B?bElIQmxXaHpvMldyYlRBc1RSUTZuN3FtaGRiV2djNU1pcGFYME5pRXhzYlAw?=
 =?utf-8?B?VkNPQTIwTENuOTBicjJ1UzZlRWZKVzYxQlM1Ym1sZ2gxNlBBaEsyRjhPbGZS?=
 =?utf-8?B?dmpENkhXUFpCb2YrSlpMTGZNRjB4UFlEVUZGZEhYZ3BwY0kzUmU1RUdzMCtE?=
 =?utf-8?B?ZjQyOENSK0RFbFlzZi80SGFnMjBHMklCZEhQZEw5V3YvWEJRNExVeTBtdzZR?=
 =?utf-8?B?RTdSSFN5cDlzbGhlNndRSWRDanRrNFA4Q0dYUHN4NHZwY2g3aEhrQ0Q1cTFy?=
 =?utf-8?B?bi9DTjJ3SWR4eUcwZUlicXhBOG1tczZzOVRRanErVVR1V3ZNbnBueTRramtH?=
 =?utf-8?B?VUJmakhJT0FzVnAzcXJGSmRheVdQMHJvcHlyNDA4VnJhTkZUaVZSNDJQNUtE?=
 =?utf-8?B?YkQxUVNwVFRpbUJQcktNR1ViaU1GNUYwdXAwQnJBZk5vUWU4aGU3ME9PWU55?=
 =?utf-8?B?NWZzOVByWlVqelQ0cDcvTlFDWnVxdC8rdVJyS01MY2dWWEsra2xyMHhNemU3?=
 =?utf-8?B?MGNxZlhHdVduYVZHcTFla1JEK1lsS2xsYTNmeUo1ZjBIVnI3YTFabFk2MWlm?=
 =?utf-8?B?U2g1U1k4R0V4TXFrMnkxTjJaYWxxLzBxU2tSbDRIa1F3MjdscE9ZK0VVSTNM?=
 =?utf-8?B?cDdZWkZRSG51K05VR01XNWlQcjBOcDI2RE02WEZIWDlSTmZ3b0ZtVDdTVWpq?=
 =?utf-8?B?ZjQ3OTVBYjNnekp1bUdBMHVOWTNGLy80eThiWE55R0RDdk9LaTZKUTY1c0E1?=
 =?utf-8?B?ZFhPbzVyUDdJU3NBbHd3aDlONVFHb1U3NTkyMmRtZWhsYjFtT2JIN0FBRDVp?=
 =?utf-8?B?eXZ5bzlLWkdQV3hxVjRUdU1DY2pXTnRqZ3c5TEtaMnZ6T0lranZSamtuS1JZ?=
 =?utf-8?B?ak8rcmRoOGF1KzNFZmRTZ3YxZ3dpOWZzMlpaa1JGTDdVZzJ3aitzRmhUQVNq?=
 =?utf-8?B?SWJTNW5tcGVPTk0zY3h4S0t4c3EvcUZ6YXJkcG1PMVQ4bkpYU2t3akpxOHp2?=
 =?utf-8?B?R2pRaVJGS3NtTFd1OXNWa0RLWW4rYWlqekpENVlQblBGYlNRbU1UZTd3Q0w5?=
 =?utf-8?B?ZUZJbkhIQTBTNFZ1UHMzcUtEbU96UWNsSzRWOEhSYmJjZlVXV2JuVDE1TTlh?=
 =?utf-8?Q?NI/2gb?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB6077.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SVhnRC9uNUJWR0p0NWY2cFE2eHo4WEpwRkt5NnZvYk9aZzZuQVhndmFMTnBk?=
 =?utf-8?B?N2dyRk9sSDIyd0ovSWZraDNlR0xZUHh3d1l0Ri9oK0RydElvdTVZNVlZRmVV?=
 =?utf-8?B?U1N4RXFCL0Y2Y1RVNmVyT3FLV042N1NLMGUwQnM5L091VW4rOWwyc1ZXQndy?=
 =?utf-8?B?YjdIOGFFak9PTHJRdmh2b2RKYUdodjVtYm8wRXhNRENTT29Sb0tJaW43SDA1?=
 =?utf-8?B?bHBzUEFiV3NEZ3pUemYzd1N3SFgzRDFCenlTZmpjdmNDNWpqb0pmM1RoS0E3?=
 =?utf-8?B?WktlRFNPbDdHTWRjWGpySndFWWZrOFB4M0x2VHVTVzZvaE83dFlHMFVRZGx5?=
 =?utf-8?B?eVAwdE0wUmhUeVRLUFFDNlZsb1RCanJkbFZFWUJ1dFhjWXFLNjIzRTBBelN4?=
 =?utf-8?B?SHFCMk9UODVZUWJPNkJYdmtyV1pWOFgxOU5zb2RLU1A0dkN3c3BqaEorcUpT?=
 =?utf-8?B?N2hHMGU0L0t2YUJlSmkwWDVSRmtMZWhLa3ZzKzVDTWpWOXZhekZ3a1F0S1BI?=
 =?utf-8?B?dmE5WUU4elY1a1NLU1BZWFpNRkVIbTRlUzNYSVhmMGVOSXR4Y05YSHAvUkRl?=
 =?utf-8?B?LzZRVkFPOXQyL1FOQW4vVHEycUU4bmVRbDNsaFFRVkgvVCt5VVZlUU5mTEZW?=
 =?utf-8?B?dzRObWozL1FOT3dGTng0QVYrTjF0WkNTNGp2OTdKd1J0Q2w2YWlkTjRtd00w?=
 =?utf-8?B?NVV3aVBPKzBJNHAwSDY2UGFxcEFON29Rc2xRZVBPMUtUVXYxNGNrbzA0T2hY?=
 =?utf-8?B?RFAxUkJ2eFNENUl1N3c3b2wvK3dXVExyMVZPSHRacWRKZ0diaDlDTDNDZU1n?=
 =?utf-8?B?R2ZQcXpQMmF6QjJkdzJYaXFWYVlWMXNEMSt2VjVCTFN6Y01tRnBkT2x1L1Yz?=
 =?utf-8?B?N1AzemF4VTB1bTluWkdKOVpVMVFLUWY3VkE4U2M3cmZqeHh1aVJqTVRPWlUv?=
 =?utf-8?B?UHBWZVZSNnlxeHM2Rm1BMkEvT2Q2NE4vam8vNENRb1Vod3J6dlFnZDgreTZx?=
 =?utf-8?B?cHhqYmt2SHBtbDc5ZFZLOHZVUHkyeEJjRjk5Q1JRM3JuZmtHUWFBRktyNzJz?=
 =?utf-8?B?VkZwb0Irby9WR3N6NzhWWUN1VjBscytzTzJ4N2ljekZDRGNoaFY4U000NFgz?=
 =?utf-8?B?dXlkcDBTN05mZEpZaDVQamtCSUNveXJYdHQzN0xyQmJXUmdJdGJ1Q0tIMjJ4?=
 =?utf-8?B?Z2NjYlpicGM0bzNpT2hkcGJwYVBxV2hWR2ladUxyS1JIUVhVTlpvVVdkbTVw?=
 =?utf-8?B?T2xzdUNxdlZsMllrRkszQklBYVRUSkhCZDZDY0o1bTVTS1BuSjBnd0RCQkxO?=
 =?utf-8?B?TlFRUFZvNWYxWUpTNC9zZEVZVzdPUXlOYmMvbElRRkZUS2ZQVlU5bWs0RFc3?=
 =?utf-8?B?aXZHWVFudGhJU0FLSjZlY25BZlorYlVtbTBZTEVFQmMvSGtlS2tiUmVrN3E3?=
 =?utf-8?B?MnJPd1N1dzBWSTFxcUZWRlpNMnV5ODlUQ2VTZWlOUnZDR2lXaWw1SkFuUnQr?=
 =?utf-8?B?eW9SaHhMZDJNeE5MWHRsNEFCc3daRWU4c1puanI4VGsxQTJnUkVyM1dpclQz?=
 =?utf-8?B?anFKKzZ3dThxMERHdkR4cy95N2FqUkR5b2tMUDFxbllMUXpFNjQ3TW9DbFJD?=
 =?utf-8?B?NmJ2MjZXZ29KT1ZkcVcvYUFSb2plU0haMnlCbER3RU5Gd2pHRXV6eThrL1NG?=
 =?utf-8?B?K2pOWmpmcWNreklCcmNjZ0tMV2RVOCtkTnVjNGZQSTFnckR3QVBQejhtWU03?=
 =?utf-8?B?UGg1azQyMVhsM2F5Y0g4ZEl4MnlXMzVoZDkxK2I2TlArL3RlNWxxV1pGeFN2?=
 =?utf-8?B?anBZOThnV211VFNsYXdlN0VaRWREZHczRTNtYmhDRlZtT2JMcWFzb3VSZmM2?=
 =?utf-8?B?NnhSZmFaZ0d1bXZ2OXl3RExnUWJad3lYcVBZQTVuaEEvRjlkcW8wcHJiR2Ux?=
 =?utf-8?B?SXBOQ2RVaHpYZHpYeWNDR1owODlma0Ywa0V1ODZPWnA2N1VNeHJMQnNDbXZT?=
 =?utf-8?B?QVZGZzJqSkRWRVZiN2VGSXNING9RcWZBVVkrMkUyUDl1QnAwczFOcVlGODBL?=
 =?utf-8?B?K0xZTnluejgzR281K2tGejZ5a1BuZHdXS0cyQmw0QTZpSmk3THZSVEF1WjVh?=
 =?utf-8?B?MUQ2Nmg1Y0tWaDV2NWFlTDBkRGJyYUt1WUdDV3B1aHRFNENwZXpJeXcrbVBZ?=
 =?utf-8?B?R0w2Mmc5MUdTekFOVFlvWHpFOTdxTXUramJpMU82WVI2L09mWTlYejg5dXR4?=
 =?utf-8?B?bnRrcHg2VzlaRjFVMlk3ZTcrWTlRNDdGOEZxL1RUVWNLYjVFblVaY1EycGJo?=
 =?utf-8?B?d3U2T1o2ZVUyQzU3YkpGWG9kZGNXSm1URlg1TS9hcnRId2dGaWVpZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b1d62691-1749-4921-c86b-08de69a64da4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB6077.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2026 19:46:52.3764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dAmjEL2ama/QsqAd/FfScqXggvh8Nr/xdJa0uRqC/WlP2j359+ilNYw0lR7+xiFPkb2wTbICt1K01w5DpkYtIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7958
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70892-lists,kvm=lfdr.de];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[46];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:dkim];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tony.luck@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 93DD1127412
X-Rspamd-Action: no action

On Wed, Feb 11, 2026 at 04:40:32PM +0000, Ben Horgan wrote:
> Hi,
> 
> Thanks for including me.
> 
> On Tue, Feb 10, 2026 at 10:04:48AM -0800, Reinette Chatre wrote:
> > +Ben and Drew
> > 
> > On 2/10/26 8:17 AM, Reinette Chatre wrote:
> > > Hi Babu,
> > > 
> > > On 1/28/26 9:44 AM, Moger, Babu wrote:
> > >>
> > >>
> > >> On 1/28/2026 11:41 AM, Moger, Babu wrote:
> > >>>> On Wed, Jan 28, 2026 at 10:01:39AM -0600, Moger, Babu wrote:
> > >>>>> On 1/27/2026 4:30 PM, Luck, Tony wrote:
> > >>>> Babu,
> > >>>>
> > >>>> I've read a bit more of the code now and I think I understand more.
> > >>>>
> > >>>> Some useful additions to your explanation.
> > >>>>
> > >>>> 1) Only one CTRL group can be marked as PLZA
> > >>>
> > >>> Yes. Correct.
> > > 
> > > Why limit it to one CTRL_MON group and why not support it for MON groups?
> > > 
> > > Limiting it to a single CTRL group seems restrictive in a few ways:
> > > 1) It requires that the "PLZA" group has a dedicated CLOSID. This reduces the
> > >    number of use cases that can be supported. Consider, for example, an existing
> > >    "high priority" resource group and a "low priority" resource group. The user may
> > >    just want to let the tasks in the "low priority" resource group run as "high priority"
> > >    when in CPL0. This of course may depend on what resources are allocated, for example
> > >    cache may need more care, but if, for example, user is only interested in memory
> > >    bandwidth allocation this seems a reasonable use case?
> > > 2) Similar to what Tony [1] mentioned this does not enable what the hardware is
> > >    capable of in terms of number of different control groups/CLOSID that can be
> > >    assigned to MSR_IA32_PQR_PLZA_ASSOC. Why limit PLZA to one CLOSID?
> > > 3) The feature seems to support RMID in MSR_IA32_PQR_PLZA_ASSOC similar to
> > >    MSR_IA32_PQR_ASSOC. With this, it should be possible for user space to, for
> > >    example, create a resource group that contains tasks of interest and create
> > >    a monitor group within it that monitors all tasks' bandwidth usage when in CPL0.
> > >    This will give user space better insight into system behavior and from what I can
> > >    tell is supported by the feature but not enabled?
> > > 
> > >>>
> > >>>> 2) It can't be the root/default group
> > >>>
> > >>> This is something I added to keep the default group in a un-disturbed,
> > > 
> > > Why was this needed?
> > > 
> > >>>
> > >>>> 3) It can't have sub monitor groups
> > > 
> > > Why not?
> > > 
> > >>>> 4) It can't be pseudo-locked
> > >>>
> > >>> Yes.
> > >>>
> > >>>>
> > >>>> Would a potential use case involve putting *all* tasks into the PLZA group? That
> > >>>> would avoid any additional context switch overhead as the PLZA MSR would never
> > >>>> need to change.
> > >>>
> > >>> Yes. That can be one use case.
> > >>>
> > >>>>
> > >>>> If that is the case, maybe for the PLZA group we should allow user to
> > >>>> do:
> > >>>>
> > >>>> # echo '*' > tasks
> > > 
> > > Dedicating a resource group to "PLZA" seems restrictive while also adding many
> > > complications since this designation makes resource group behave differently and
> > > thus the files need to get extra "treatments" to handle this "PLZA" designation.
> > > 
> > > I am wondering if it will not be simpler to introduce just one new file, for example
> > > "tasks_cpl0" in both CTRL_MON and MON groups. When user space writes a task ID to the
> > > file it "enables" PLZA for this task and that group's CLOSID and RMID is the associated
> > > task's "PLZA" CLOSID and RMID. This gives user space the flexibility to use the same
> > > resource group to manage user space and kernel space allocations while also supporting
> > > various monitoring use cases. This still supports the "dedicate a resource group to PLZA"
> > > use case where user space can create a new resource group with certain allocations but the
> > > "tasks" file will be empty and "tasks_cpl0" contains the tasks needing to run with
> > > the resource group's allocations when in CPL0.
> 
> If there is a "tasks_cpl0"  then I'd expect a "cpus_cpl0" too.
> 
> > 
> > It looks like MPAM has a few more capabilities here and the Arm levels are numbered differently
> > with EL0 meaning user space. We should thus aim to keep things as generic as possible. For example,
> > instead of CPL0 using something like "kernel" or ... ?
> 
> Yes, PLZA does open up more possibilities for MPAM usage.  I've talked to James
> internally and here are a few thoughts.
> 
> If the user case is just that an option run all tasks with the same closid/rmid
> (partid/pmg) configuration when they are running in the kernel then I'd favour a
> mount option. The resctrl filesytem interface doesn't need to change and
> userspace software doesn't need to change. This could either take away a
> closid/rmid from userspace and dedicate it to the kernel or perhaps have a
> policy to have the default group as the kernel group. If you use the default
> configuration, at least for MPAM, the kernel may not be running at the highest
> priority as a minimum bandwidth can be used to give a priority boost. (Once we
> have a resctrl schema for this.)

I'm a big fan of this use case. It's easy to understand why users would
want this. It avoids the issue that syscalls, page-faults, and
interrupts from a task with very limited resources will spend ages in
the kernel. Users have complained about the priority inversions that
this can cause.

It also has a simpler implementation. No changes to the context switch
code. On x86 some simple method to steal a CLOSID and configure
resources for that CLOSID.
> 
> It could be useful to have something a bit more featureful though. Is there a

Many things have theoretical use cases. I'd like to hear from some
resctrl users whether they will make use of these extra features.

Babu's RFC allows for some tasks to be in the PLZA group while others
will run in kernel mode with the same resources that are granted to
the CTRL group they belong too.

Reinette asked[1] whether the PLZA mode should be extended to multiple
CTRL groups and their child CTRL_MON groups for even greater
flexibility.

[1] https://lore.kernel.org/all/7a4ea07d-88e6-4f0f-a3ce-4fd97388cec4@intel.com/

> need for the two mappings, task->cpl0 config and task->cpl1 to be independent or
> would as task->(cp0 config, cp1 config) be sufficient? It seems awkward that
> it's not a single write to move a task. If a single mapping is sufficient, then
> as single new file, kernel_group,per CTRL_MON group (maybe MON groups) as
> suggested above but rather than a task that file could hold a path to the
> CTRL_MON/MON group that provides the kernel configuraion for tasks running in
> that group. So that this can be transparent to existing software an empty string
> can mean use the current group's when in the kernel (as well as for
> userspace). A slash, /, could be used to refer to the default group. This would
> give something like the below under /sys/fs/resctrl.
> 
> .
> ├── cpus
> ├── tasks
> ├── ctrl1
> │   ├── cpus
> │   ├── kernel_group -> mon_groups/mon1
> │   └── tasks
> ├── kernel_group -> ctrl1
> └── mon_groups
>     └── mon1
>         ├── cpus
>         ├── kernel_group -> ctrl1
>         └── tasks
> 
> > 
> > I have not read anything about the RISC-V side of this yet.
> > 
> > Reinette
> > 
> > > 
> > > Reinette
> > > 
> > > [1] https://lore.kernel.org/lkml/aXpgragcLS2L8ROe@agluck-desk3/
> > 
> 
> Thanks,
> 
> Ben

-Tony

