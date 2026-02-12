Return-Path: <kvm+bounces-71005-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SEXVOAoejmnp/gAAu9opvQ
	(envelope-from <kvm+bounces-71005-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 19:38:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 47EC613052D
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 19:38:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 63EFD30432CD
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 18:37:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69EDB28B4FD;
	Thu, 12 Feb 2026 18:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YVYAnFGs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388042580D1;
	Thu, 12 Feb 2026 18:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770921465; cv=fail; b=ICuBvZEb6k5hPm95u8dVxppjFa9mw5z9Ki8DQNZ418v5pis9OiyhXGa2OwiKMF9eRi6QiRifSttrLo4AP4irzg1LC/Jf+cdxCUhC3iSqnuytdqcBKx9o4LgkmsAm9G6btKECyuJ0p7+gk6CpQ99Dg0kQiBrlnWsb6eOmmz076XY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770921465; c=relaxed/simple;
	bh=1AmyqOUck4A/KscWGh3mlx84u3QDVoLAdQ/h010kxJ4=;
	h=Message-ID:Date:From:Subject:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UAS3y0+DXRDPUm6nt/+4qoFUnMicGyMVeqbL0uKE9z06r1TrOe9cAtklWgfN1xwPc+fckkGEsTLTokZyJ7hFddJyxxfapKlj0D6i0QIK/iLeLoEpXtvsWlyBN8F701yhmPFXkYcg14VAv726cxGkYq9UsRLql88BSLuZmO4AZSA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YVYAnFGs; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770921463; x=1802457463;
  h=message-id:date:from:subject:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1AmyqOUck4A/KscWGh3mlx84u3QDVoLAdQ/h010kxJ4=;
  b=YVYAnFGsgDXhab+h5xrP9/uoHwWwzFC5NgQfyP4u0H+iUAgybAoQKBH3
   zBzdBi6QW2XQpq8EW631rhFE0pp79tCu9pjEMVjlZQER/6WNsR7p/k4i9
   /cehJGPFG5bUgD0KjnmNmJxP9WxrBO3R7egqd19ZsCqJVE8DHDoysSSBp
   rhI28v8BeKAIguRhpTfJLi8lsVZMBvZfLhlhq562CS5FRrlkmQI4pCzmP
   rJNBNNvRMyn/uxKPvyX/6KwgdHMwfIzW8TiY85eCGh2I4aaS3Mo3JOBZg
   MpBmOQv48JNXRplKXNt4bOU8IagVRLH80487xP6LFIvKhCA2BfD1S80AT
   Q==;
X-CSE-ConnectionGUID: tKuuLOkIRz2albiom8GJPg==
X-CSE-MsgGUID: zBazmETaSKuLOT4vtE//2Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11699"; a="71132389"
X-IronPort-AV: E=Sophos;i="6.21,287,1763452800"; 
   d="scan'208";a="71132389"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 10:37:29 -0800
X-CSE-ConnectionGUID: vtqetE1xQbSYTfS/IPTyVw==
X-CSE-MsgGUID: FLbWEtFOQVWLXHXGOFlJ9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,287,1763452800"; 
   d="scan'208";a="217222741"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 10:37:29 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 12 Feb 2026 10:37:28 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 12 Feb 2026 10:37:28 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.19) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 12 Feb 2026 10:37:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z7KTocbu//O6/FL7LfLv8ZVQ8UXahhGYMdJZ471W3ZAr4h5vicS0Eqsh3TEZQ/BhvkNxBwb6sC5bmMm8B1dbupyrvu5VoXPDCR7XnLCXjrVrLcd07ZnsBzX/IdymA0lTw8qm+9xOhGQzeKsWO7YnB/PMuiRX7ouiy04T0IRnR7k48tTFM/unh6OxIJWHCgJD6w7wRXbSOrWFFy2Q3T3LAe+sRfcjzR5y7VPg21419OelHVHNp2eU18mNvqSxaYrjh6fnEPF3A6fYVlpAS/vRGztXLqXB79XS734KMI667rBmzOGtquW/Bj45xw0q9UixPlhM2dSbvdQGAdRpm+Vr7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/V5Y5CyJRlsD3K9Y+6inCMVO13+WKvx5spzV+FCmXUs=;
 b=lgXOfAyf04ew7uG8lcIeVYCA7QC/JSG4ZSWfr27T2/ustLjmk24HU3JJ+pX2aVVMAQGgLTNUHjPfNEpg1XDtfddb5nAo8rBlasCmw6hUljGsetuqx/Rs8hk7/pYWfuDyzMmwvlP74rCPCb0w2Wm9Q1wCUgoa5cERS3HR9Em5TQZfceaM0DJLu+Rn0ASbR4PbpKCzK4ws9JjkLZZ3fuS4w/c115VDmmis+pb/Wyl4tGR/HQpF4TvM//GndntI7ka3g/hcpmMbYQiJw6eM2uRpWjx+QTlFOxk0hVG9d3+uCV0wqkmqvCMFgYwUoLWgtDKuW0Y45XE6/fqg/4Dw67IniA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA1PR11MB7038.namprd11.prod.outlook.com (2603:10b6:806:2b3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Thu, 12 Feb
 2026 18:37:24 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%6]) with mapi id 15.20.9587.017; Thu, 12 Feb 2026
 18:37:24 +0000
Message-ID: <2b2d0168-307a-40c3-98fa-54902482e861@intel.com>
Date: Thu, 12 Feb 2026 10:37:21 -0800
User-Agent: Mozilla Thunderbird
From: Reinette Chatre <reinette.chatre@intel.com>
Subject: Re: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
To: Ben Horgan <ben.horgan@arm.com>
CC: "Moger, Babu" <bmoger@amd.com>, "Moger, Babu" <Babu.Moger@amd.com>, "Luck,
 Tony" <tony.luck@intel.com>, Drew Fustini <fustini@kernel.org>,
	"corbet@lwn.net" <corbet@lwn.net>, "Dave.Martin@arm.com"
	<Dave.Martin@arm.com>, "james.morse@arm.com" <james.morse@arm.com>,
	"tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
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
References: <17c9c0c252dcfe707dffe5986e7c98cd121f7cef.1769029977.git.babu.moger@amd.com>
 <aXk8hRtv6ATEjW8A@agluck-desk3>
 <5ec19557-6a62-4158-af82-c70bac75226f@amd.com>
 <aXpDdUQHCnQyhcL3@agluck-desk3>
 <IA0PPF9A76BB3A655A28E9695C8AD1CC59F9591A@IA0PPF9A76BB3A6.namprd12.prod.outlook.com>
 <bbe80a9a-70f0-4cd1-bd6a-4a45212aa80b@amd.com>
 <7a4ea07d-88e6-4f0f-a3ce-4fd97388cec4@intel.com>
 <1f703c24-a4a9-416e-ae43-21d03f35f0be@intel.com>
 <aYyxAPdTFejzsE42@e134344.arm.com>
 <679dcd01-05e5-476a-91dd-6d1d08637b3e@intel.com>
 <aY3bvKeOcZ9yG686@e134344.arm.com>
Content-Language: en-US
In-Reply-To: <aY3bvKeOcZ9yG686@e134344.arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR05CA0012.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::25) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA1PR11MB7038:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ccd57a6-a4cc-4c1f-fa9f-08de6a65c3ef
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bnVuSTUyRS90SHIwVm5zNS9iYnUwZCsvVnZCMHFwanpNTU56dUxiQldURDhP?=
 =?utf-8?B?ZlNnNDI5clIxVzFpMnNlK3oxNWlRVkNSSDFUcnhLdTZsZkQ0VVVBNFRNWFU2?=
 =?utf-8?B?bEdEMGJCQkxIdHlBL0RPTjZPZ1B3Z05VVjhITXl5WkRHdEZGQTJUb01Jdmtq?=
 =?utf-8?B?WEdzR1paZUxCdW11WHRUa3Nub05QYXg5cEc5RHN6N3VZMWFjd1N0aVB5YkVG?=
 =?utf-8?B?d0QrYlNIc1JOWUhNTmtBUzBZWXJ6cVcvVi9GSU9ndklaTmU4cTlobzJaN09p?=
 =?utf-8?B?cjdTSVhMYmtsbnZIZGt0dzI4M1JkTzBnSXZYQ1B5U3NGeWJzanBLYlF3ckt5?=
 =?utf-8?B?R3k2RmtDMUJQdnJHZ283VlBseWRLQ2R5N1pTTm1hTWxMaDBOdW5Qemx5djMv?=
 =?utf-8?B?QnUxZFZuT0NIRG1sOXlSOGpGR1BsNnBEU0dqSmQ4WXprYzdMbmxHSXkvM055?=
 =?utf-8?B?bGpuV0tRMHY4OGpEMVlFOXhocS9lWjlON25pUTBEajY3MTZ1QndXL0lIMGhM?=
 =?utf-8?B?aUdwd3JyNExEQ0xvV016ODI2MUZSWXhPbWtVOElKTFowY3BBUW94MWdRZHVl?=
 =?utf-8?B?eDlmc0JvTVp3eGZqOHl1TUk5QnBWSkIrNmwrV3A4cmQ2aEZkK0JueHIyOCtJ?=
 =?utf-8?B?dFlsY0lFQ0dDUzNpeVNETkVFaCt4SGMyaDBlbVZ2NkF1cmlON211VytDRHdB?=
 =?utf-8?B?QjdzRUVQeTh4R3AwUTBBRTh3emg0bWk5Vlg4Y09CU25veER3VVQwelNtUmt5?=
 =?utf-8?B?YTQ4NEFrc2I2TTlYa1BVaWc0eGxkeE0yaVdXY3N1b2RaV2o0VDF5V0tkWFZj?=
 =?utf-8?B?cWlVblNyNGt3aWJPVGhQaVhsMmhPVWpCT2F4elc2MUQ4RzA2OGpzSzdVN28r?=
 =?utf-8?B?R1BhVXNzUFJ3NG1BZWNyeFErTzNlblBqOXF3TjMwVkk5NzgyRjVNWEppNnlU?=
 =?utf-8?B?QXd3VWd4dVRKU21IUC9aekZMdi9adVZLYkZRdkdBeFcxQnJhUkRUUmorN2U0?=
 =?utf-8?B?SnVMK1ozbGlucmpySlJNOEd3NXM4Y0s5NytKdUU1emNIWndzS01aSVNyMWdN?=
 =?utf-8?B?dExBZkpTeFRnUm5ncHEra0JBOS8vMVBIRjYzbDRwL1JicHpZTkY5b3p2bmtF?=
 =?utf-8?B?QUZGUmY5QWdKWVVlcDZjU2pyOGhjRmlyQzQ1MEc3YVhuTUIvdHVQTmVhemc1?=
 =?utf-8?B?ZTRsaDZNYWl5ZTJYbDRTUkVPbWs1SktYcm5HZWZ4OWZyS0NpOWtLbHF2SERw?=
 =?utf-8?B?dEdwQlVKbkpaTzZsQ05nRzRaM1NrUkJrTythbnV4VjRXRHRnb09nY2gwQ2tV?=
 =?utf-8?B?eldtWFpQR1pDQk5naEZLOCtnNjVuOTZRL0c5N05wYWx1d1p4R3IxVC80RDF5?=
 =?utf-8?B?cmF0VWZVKyt6S1RIbDh5Y3YxbVh1d0hqUGNuUzJNSEVNVytjWjliSlBUZ1Rm?=
 =?utf-8?B?K0ZaWGpGZVpqRm13Ulp0c2VMOVBaNEJYOWtRZ3NMeUVxTGlWejVvbXJRcXJ4?=
 =?utf-8?B?MHRNNktPTnFsZXF1YjFIdHNXZXNHbStCRDF3Vm4rd0RJNzgvd0lGQ0NnZkRn?=
 =?utf-8?B?NUdQRFNxL2RzSUxCdE0weUgwS1huUXhGYnNPUmp3eHB4RzJXS2w3MURyN3No?=
 =?utf-8?B?U2p5UVRwU1hLQlA1ZkowWEhxcWZQZ21QTE1PR1dkVlc4eUlQNzVMdXUwUHRF?=
 =?utf-8?B?N0ZMcjNsV29rNEpRUHdqSnd0RlZTSnJxTWFkZnF2MGl6UjNFdDBUZXNxT1c1?=
 =?utf-8?B?U0swVnNJdVh5MHI0SjUyamcrTTBxeWJEY3BLbXdVb2hxUDl0dTJpYjZCbGtm?=
 =?utf-8?B?emdYM3JacVJndm1BeHFNUlpvbU9lQjRFRm1sWWxFcksySGRuQjFjZUpaQlB1?=
 =?utf-8?B?Vmk2bXN4V2dkbkVrd2ZrWnltMEg1aURCVDJFNjNlM2h1VlBBWnVjQXlWQ1Q0?=
 =?utf-8?B?aFlIanYyWU4yRnlWcXVLRFl3MkNhVThRNEl5dGpmMjZQSGtUU2VqbFNkNURX?=
 =?utf-8?B?L0xaRkRwaExpNXI4dnA3eUllblJUSlJCdnB5eFY2WENWOFA2RnBpUlNZZUxq?=
 =?utf-8?B?S3o1VlJ5TmZOOVROTEQ5elB0dEVLMTZ0Qnk4SWU4NUFxWEJPZ0xteXFRa25X?=
 =?utf-8?Q?2QsMb2uV4O++9mCcNa5dUxEWu?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cVlkTElIdjhTaUNld0JpbUJyQ00yc3E2YzlZbFlwWGlIZ0pRTHl6ZFQrb0Zt?=
 =?utf-8?B?REQxQ05ZdWNaRGh2QjBJbjlNUVhnc0Z5VHhDdWlGdjU1MUJHNVdHcFA1Ulgw?=
 =?utf-8?B?dlVXalQzUWdmRlpKNUFaeHRxS3FEclZLMjZsT0RZdVN6bWMxU0ppOTBmU3p2?=
 =?utf-8?B?OGNmTFJFVm91Q0F6ejJidXllQmJEM0d5aW5ISEx5RWlUUXhjNkljUVdmVHR3?=
 =?utf-8?B?d1pyaFRISGZHcEJsZDk4QXE3RkIwUEdHdXN0eFNxK0JVSkY2U1lzVUI0TTZ6?=
 =?utf-8?B?dm9UU1ZENVpGRjJaeEVnY3lNaXZsdzY3K2J4QkdUekszMkV3bUp4TzZkN0Jh?=
 =?utf-8?B?b3l6ZWJ2dUFLVFMxbXVLdW9XaGo5TCtKUkE1WUJJd0w3OERLbk5NaXdlWmw1?=
 =?utf-8?B?bDB1ZXhIR08vNmdYQkdjaS9ISTBXUlFaQm1FdkJ5RE82YzdYaGtoT2N6WDRH?=
 =?utf-8?B?NmcwOWFjeVBMb29zVzZZYkJtQk1vbld1UkJicFNpa3ZISXFlbW9wbXB6SHdS?=
 =?utf-8?B?T1M0NWZGVmFRcHZxbk5GeE5YL1RHSU1McVlWTTRrWmV0S1pLMG9TZVdaM25o?=
 =?utf-8?B?ZUR2N2oydnZZSXIrWGIzR2hVbmJ6SHBob1Y4TTBDRlI5a2xFNkQxVU5ySWI0?=
 =?utf-8?B?M0ZqbGkvWjl5NlhWVXA4SlVqdnF6V3E0V2U4N3FKS1RQRWdWV1BlUlIramRG?=
 =?utf-8?B?OWN1T1hZWWlSejhBNk9DeERjSlFWZnovR2JTOFNvcFZMeHVZQmFsOTZGWnFE?=
 =?utf-8?B?NEhJM1dYQkVxZCt0YUwvVTJFM3l0enpmOGU0S0JWbDdZVlBIb2s1ZDF0cU9W?=
 =?utf-8?B?V0xDNTkvZzhUVytVMC9yemFNWHVpQ1NTelJUVFVxMGRQNXBhd3VkYWhnWTNa?=
 =?utf-8?B?dWg2emhTcUduemdzWk9JS3JHWkhtTHJJK0lUeGxDN2lzNlVYbTJWV2RJSGxx?=
 =?utf-8?B?MXpsaE1QblM4SWZCUEM1cXlqYm5IOVdibkF2ZjlkUXlPS2JrR0RyNklVcUEz?=
 =?utf-8?B?OTZmSkwzRzdqeEtaV1ZBSG91VEdXYWdVOWYzc2ZkN0ozbE50VTc5ZEV0MDYx?=
 =?utf-8?B?R0V3RkVFZnRKZC9yU0h6WUVNRzFuNktxMkdaSVNGU3VabzA0MnZJSi9VNkdR?=
 =?utf-8?B?UUxUd21IZkFReDcxcC90cFhJNTdrQWttQ1hIc2k3UC9nZXF1a2pleGY2UHky?=
 =?utf-8?B?YzZlZ1d5TUhINjUxUVRWTmVMMDJKVHlxOEttc3R0dFVPQzMvTGVyLzNRMTI1?=
 =?utf-8?B?UUVwMWxwOTNDVGFUQzIrdml3TWNncWN4M0h2WG5idzVrMkJiQjc3WGg1SVZC?=
 =?utf-8?B?UmxscEZxZVpXWHRyYkJ1RmNZMExlQk5wMjFJSkEwR3h3WmFYRjhNMEVsRFlC?=
 =?utf-8?B?bDdkWjBrbTlwd2g4c0tnZkdZYnJEcUtGOG5kR2RnRlFjeWNNcGpyaWFwVGtl?=
 =?utf-8?B?NlUrcjlGN252QkRZTFMyZmxYdnVtaVI1UFJmalNRTlVxYlVreFFuRXdIYWor?=
 =?utf-8?B?OWJZVnJiQlJiYkNCREtwZ0hUTnlCcS91Q3NoT3RXa2ZJTUl3STRxY0pSN1Vu?=
 =?utf-8?B?aXlvcTRlWUNua20rbExCVDllY011cjR2Sk9vUWpFaGs3MkMvc1FQWDdNT1Yv?=
 =?utf-8?B?WFBxb01lMjZrSHFDSW5pamlYajY5NEdidGk0a1JvU1ptdzlONkUvUkhPRWJW?=
 =?utf-8?B?ZG9TU21JWldIMFVlZjVxUDhOS1hqUzVWZjdpNnNvRXRscERDb0d0ZUtKSmg1?=
 =?utf-8?B?R25mcm5tcmZrWndMUGZ0b3JnRlNhWlFHZTNtUW1Qam5kOGo2Z2gzVjNNeVpK?=
 =?utf-8?B?RXhKTnRoaEVHWWU5V1QrdTUvSlRhS09QbXhTTExVMVlDMFBGSGhRT2NRVita?=
 =?utf-8?B?UXQ4ci80RjBJVkE2Wm4yY3owWmR5bG9BcjlsaGNWaUZKdmNBRTdCNDRudC9m?=
 =?utf-8?B?NUx4amRBbFRiQ1hxamF5NEVFRzdGTWlDcHJIT1Y2bFpSQk4rV0Zsc0NSdU5F?=
 =?utf-8?B?SUlMUitzYjlBUWFpeGdhRHpZREY3Q0FJZ3FPdTYydVNxZVpxaEtEK3RRNWNK?=
 =?utf-8?B?U1JvU011MzlZWWk5Ny90bGEvOTBycERGSDBpeExNVXBHSXZrR2xqRC9NVmky?=
 =?utf-8?B?SDFaaDZCOVgxdmdVWmd0bWttdjFKeGRwNTV0WllINWFXbkhSaE5SUlJkY091?=
 =?utf-8?B?ZXd5YVVHVGFBVWUwdnM1WlJyOWtiQTM4bXdjUmoyMHNIWExMQU11OGdvK1lM?=
 =?utf-8?B?VDRqeDBiNGFoR0dNUHl5WDlGa1FMMUFDR3ZqVDVacVJNeDZlTkpkeDdkOVJF?=
 =?utf-8?B?eDlheDZhS21HL2xXaUJOUldIUCtKYXd3emwvNXhhd2t5S0RKblFKRjBJNkFz?=
 =?utf-8?Q?QDn0Qw83cy53KJlA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ccd57a6-a4cc-4c1f-fa9f-08de6a65c3ef
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2026 18:37:24.6489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lVk4H5JlG9cXF6yaNC010bkNWwLRMDlPEyxIApG6OGC21fGX/0V2TXg1WSCGuGmAxHdfKy4HWYEJC7lj0EygZd4vEY+MZMT6wT6ougbzZFM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7038
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71005-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[46];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[reinette.chatre@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 47EC613052D
X-Rspamd-Action: no action

Hi Ben,

On 2/12/26 5:55 AM, Ben Horgan wrote:
> On Wed, Feb 11, 2026 at 02:22:55PM -0800, Reinette Chatre wrote:
>> On 2/11/26 8:40 AM, Ben Horgan wrote:
>>> On Tue, Feb 10, 2026 at 10:04:48AM -0800, Reinette Chatre wrote:
>>>> On 2/10/26 8:17 AM, Reinette Chatre wrote:
>>>>> On 1/28/26 9:44 AM, Moger, Babu wrote:
>>>>>>
>>>>>>
>>>>>> On 1/28/2026 11:41 AM, Moger, Babu wrote:
>>>>>>>> On Wed, Jan 28, 2026 at 10:01:39AM -0600, Moger, Babu wrote:
>>>>>>>>> On 1/27/2026 4:30 PM, Luck, Tony wrote:
>>>>>>>> Babu,
>>>>>>>>
>>>>>>>> I've read a bit more of the code now and I think I understand more.
>>>>>>>>
>>>>>>>> Some useful additions to your explanation.
>>>>>>>>
>>>>>>>> 1) Only one CTRL group can be marked as PLZA
>>>>>>>
>>>>>>> Yes. Correct.
>>>>>
>>>>> Why limit it to one CTRL_MON group and why not support it for MON groups?
>>>>>
>>>>> Limiting it to a single CTRL group seems restrictive in a few ways:
>>>>> 1) It requires that the "PLZA" group has a dedicated CLOSID. This reduces the
>>>>>    number of use cases that can be supported. Consider, for example, an existing
>>>>>    "high priority" resource group and a "low priority" resource group. The user may
>>>>>    just want to let the tasks in the "low priority" resource group run as "high priority"
>>>>>    when in CPL0. This of course may depend on what resources are allocated, for example
>>>>>    cache may need more care, but if, for example, user is only interested in memory
>>>>>    bandwidth allocation this seems a reasonable use case?
>>>>> 2) Similar to what Tony [1] mentioned this does not enable what the hardware is
>>>>>    capable of in terms of number of different control groups/CLOSID that can be
>>>>>    assigned to MSR_IA32_PQR_PLZA_ASSOC. Why limit PLZA to one CLOSID?
>>>>> 3) The feature seems to support RMID in MSR_IA32_PQR_PLZA_ASSOC similar to
>>>>>    MSR_IA32_PQR_ASSOC. With this, it should be possible for user space to, for
>>>>>    example, create a resource group that contains tasks of interest and create
>>>>>    a monitor group within it that monitors all tasks' bandwidth usage when in CPL0.
>>>>>    This will give user space better insight into system behavior and from what I can
>>>>>    tell is supported by the feature but not enabled?
>>>>>
>>>>>>>
>>>>>>>> 2) It can't be the root/default group
>>>>>>>
>>>>>>> This is something I added to keep the default group in a un-disturbed,
>>>>>
>>>>> Why was this needed?
>>>>>
>>>>>>>
>>>>>>>> 3) It can't have sub monitor groups
>>>>>
>>>>> Why not?
>>>>>
>>>>>>>> 4) It can't be pseudo-locked
>>>>>>>
>>>>>>> Yes.
>>>>>>>
>>>>>>>>
>>>>>>>> Would a potential use case involve putting *all* tasks into the PLZA group? That
>>>>>>>> would avoid any additional context switch overhead as the PLZA MSR would never
>>>>>>>> need to change.
>>>>>>>
>>>>>>> Yes. That can be one use case.
>>>>>>>
>>>>>>>>
>>>>>>>> If that is the case, maybe for the PLZA group we should allow user to
>>>>>>>> do:
>>>>>>>>
>>>>>>>> # echo '*' > tasks
>>>>>
>>>>> Dedicating a resource group to "PLZA" seems restrictive while also adding many
>>>>> complications since this designation makes resource group behave differently and
>>>>> thus the files need to get extra "treatments" to handle this "PLZA" designation.
> 
> As I commented on another thread, I'm wary of this reuse of existing file types
> as they can confuse existing user-space tools.

I agree. Changing how user space interacts with existing files is a change that would
require a mount option and this can be avoided by using new files instead.

>>>>> I am wondering if it will not be simpler to introduce just one new file, for example
>>>>> "tasks_cpl0" in both CTRL_MON and MON groups. When user space writes a task ID to the
>>>>> file it "enables" PLZA for this task and that group's CLOSID and RMID is the associated
>>>>> task's "PLZA" CLOSID and RMID. This gives user space the flexibility to use the same
>>>>> resource group to manage user space and kernel space allocations while also supporting
>>>>> various monitoring use cases. This still supports the "dedicate a resource group to PLZA"
>>>>> use case where user space can create a new resource group with certain allocations but the
>>>>> "tasks" file will be empty and "tasks_cpl0" contains the tasks needing to run with
>>>>> the resource group's allocations when in CPL0.
>>>
>>> If there is a "tasks_cpl0"  then I'd expect a "cpus_cpl0" too.
>>
>> That is reasonable, yes.
> 
> I think the "tasks_cpl0" approach suffers from one of the same faults as the
> "kernel_groups" approach. If you want to run a task with userspace configuration
> closid-A rmid-Y but to run in kernel space in closid-B but the same rmid-Y then
> there can't exist monitor_group in resctrl for both.

This assumes that "tasks" and "tasks_cpl0"/"tasks_kernel" have the same rules for
task assignment. When a user assigns a task to the "tasks" file of a MON group it
is required that the task is a member of the parent CTRL_MON group and if so, that
task's CLOSID and RMID are both updated. Theoretically there could be different rules
for task assignment to the "tasks_cpl0"/"tasks_kernel" file that does not place such
restriction and only updates CLOSID when moving to a CTRL_MON group and only updates
RMID when moving to a MON group. 

You are correct that resctrl cannot have monitor groups to track such configuration
and there may indeed be some consequences that I have not considered.

I understand this is not something that MPAM can support and I also do not know if this
is even a valid use case. If doing something like this user space will need to take care
since the monitoring data will be presented with the allocations used when tasks are in
user space but also contain the monitoring data for allocations used when tasks are in
kernel space that are tracked in another control group hierarchy (to which I expect the
task's kernel space monitoring can move when the MON group is deleted).


>>>> It looks like MPAM has a few more capabilities here and the Arm levels are numbered differently
>>>> with EL0 meaning user space. We should thus aim to keep things as generic as possible. For example,
>>>> instead of CPL0 using something like "kernel" or ... ?
>>>
>>> Yes, PLZA does open up more possibilities for MPAM usage.  I've talked to James
>>> internally and here are a few thoughts.
>>>
>>> If the user case is just that an option run all tasks with the same closid/rmid
>>> (partid/pmg) configuration when they are running in the kernel then I'd favour a
>>> mount option. The resctrl filesytem interface doesn't need to change and
>>
>> I view mount options as an interface of last resort. Why would a mount option be needed
>> in this case? The existence of the file used to configure the feature seems sufficient?
> 
> If we are taking away a closid from the user then the number of CTRL_MON groups
> that can be created changes. It seems reasonable for user-space to expect
> num_closid to be a fixed value.

I do you see why we need to take away a CLOSID from the user. Consider a user space that
runs with just two resource groups, for example, "high priority" and "low priority", it seems
reasonable to make it possible to let the "low priority" tasks run with "high priority"
allocations when in kernel space without needing to dedicate a new CLOSID? More reasonable
when only considering memory bandwidth allocation though.

> 
>>
>> Also ...
>>
>> I do not think resctrl should unnecessarily place constraints on what the hardware
>> features are capable of. As I understand, both PLZA and MPAM supports use case where
>> tasks may use different CLOSID/RMID (PARTID/PMG) when running in the kernel. Limiting
>> this to only one CLOSID/PARTID seems like an unmotivated constraint to me at the moment.
>> This may be because I am not familiar with all the requirements here so please do
>> help with insight on how the hardware feature is intended to be used as it relates
>> to its design.
>>
>> We have to be very careful when constraining a feature this much  If resctrl does something
>> like this it essentially restricts what users could do forever.
> 
> Indeed, we don't want to unnecessarily restrict ourselves here. I was hoping a
> fixed kernel CLOSID/RMID configuration option might just give all we need for
> usecases we know we have and be minimally intrusive enough to not preclude a
> more featureful PLZA later when new usecases come about.

Having ability to grow features would be ideal. I do not see how a fixed kernel CLOSID/RMID
configuration leaves room to build on top though. Could you please elaborate?

I wonder if the benefit of the fixed CLOSID/RMID is perhaps mostly in the cost of
context switching which I do not think is a concern for MPAM but it may be for PLZA?

One option to support fixed kernel CLOSID/RMID at the beginning and leave room to build
may be to create the kernel_group or "tasks_kernel" interface as a baseline but in first
implementation only allow user space to write the same group to all "kernel_group" files or
to only allow to write to one of the "tasks_kernel" files in the resctrl fs hierarchy. At
that time the associated CLOSID/RMID would become the "fixed configuration" and attempts to
write to others can return "ENOSPC"?

From what I can tell this still does not require to take away a CLOSID/RMID from user space
though. Dedicating a CLOSID/RMID to kernel work can still be done but be in control of user
that can, for example leave the "tasks" and "cpus" files empty.

> One complication is that for fixed kernel CLOSID/RMID option is that for x86 you
> may want to be able to monitor a tasks resource usage whether or not it is in
> the kernel or userspace and so only have a fixed CLOSID. However, for MPAM this
> wouldn't work as PMG (~RMID) is scoped to PARTID (~CLOSID).
> 
>>
>>> userspace software doesn't need to change. This could either take away a
>>> closid/rmid from userspace and dedicate it to the kernel or perhaps have a
>>> policy to have the default group as the kernel group. If you use the default
>>
>> Similar to above I do not see PLZA or MPAM preventing sharing of CLOSID/RMID (PARTID/PMG)
>> between user space and kernel. I do not see a motivation for resctrl to place such
>> constraint.
>>
>>> configuration, at least for MPAM, the kernel may not be running at the highest
>>> priority as a minimum bandwidth can be used to give a priority boost. (Once we
>>> have a resctrl schema for this.)
>>>
>>> It could be useful to have something a bit more featureful though. Is there a
>>> need for the two mappings, task->cpl0 config and task->cpl1 to be independent or
>>> would as task->(cp0 config, cp1 config) be sufficient? It seems awkward that
>>> it's not a single write to move a task. If a single mapping is sufficient, then
>>
>> Moving a task in x86 is currently two writes by writing the CLOSID and RMID separately.
>> I think the MPAM approach is better and there may be opportunity to do this in a similar
>> way and both architectures use the same field(s) in the task_struct.
> 
> I was referring to the userspace file write but unifying on a the same fields in
> task_struct could be good. The single write is necessary for MPAM as PMG is
> scoped to PARTID and I don't think x86 behaviour changes if it moves to the same
> approach.
> 

ah - I misunderstood. You are suggesting to have one file that user writes to
to set both user space and kernel space CLOSID/RMID? This sounds like what the
existing "tasks" file does but only supports the same CLOSID/RMID for both user
space and kernel space. To support the new hardware features where the CLOSID/RMID
can be different we cannot just change "tasks" interface and would need to keep it
backward compatible. So far I assumed that it would be ok for the "tasks" file
to essentially get new meaning as the CLOSID/RMID for just user space work, which 
seems to require a second file for kernel space as a consequence? So far I have
not seen an option that does not change meaning of the "tasks" file.

>>> as single new file, kernel_group,per CTRL_MON group (maybe MON groups) as
>>> suggested above but rather than a task that file could hold a path to the
>>> CTRL_MON/MON group that provides the kernel configuraion for tasks running in
>>> that group. So that this can be transparent to existing software an empty string
>>
>> Something like this would force all tasks of a group to run with the same CLOSID/RMID
>> (PARTID/PMG) when in kernel space. This seems to restrict what the hardware supports
>> and may reduce the possible use case of this feature.
>>
>> For example,
>> - There may be a scenario where there is a set of tasks with a particular allocation 
>>   when running in user space but when in kernel these tasks benefit from different
>>   allocations. Consider for example below arrangement where tasks 1, 2, and 3 run in
>>   user space with allocations from resource_groupA. While these tasks are ok with this
>>   allocation when in user space they have different requirements when it comes to
>>   kernel space. There may be a resource_groupB that allocates a lot of resources ("high
>>   priority") that task 1 should use for kernel work and a resource_groupC that allocates
>>   fewer resources that tasks 2 and 3 should use for kernel work ("medium priority").  
>>   
>>   resource_groupA:
>> 	schemata: <average allocations that work for tasks 1, 2, and 3 when in user space>
>> 	tasks when in user space: 1, 2, 3
>>
>>   resource_groupB:
>> 	schemata: <high priority allocations>
>> 	tasks when in kernel space: 1
>>
>>   resource_groupC:
>> 	schemata: <medium priority allocations>
>> 	tasks when in kernel space: 2, 3
> 
> I'm not sure if this would happen in the real world or not.

Ack. I would like to echo Tony's request for feedback from resctrl users
 https://lore.kernel.org/lkml/aYzcpuG0PfUaTdqt@agluck-desk3/

> 
>>
>>   If user space is forced to have the same tasks have the same user space and kernel
>>   allocations then that will force user space to create additional resource groups that
>>   will use up CLOSID/PARTID that is a scarce resource.
> 
> This may be undesirable even if CLOSID/PARTID were unlimited as controls which set
> a per-CLOSID/PARTID maximum don't have the same effect if the tasks are spread across
> more than one CLOSID/PARTID.

Thank you for bringing this up. I did not consider the mechanics of the memory bandwidth
controls.

> 
>>
>> - There may be a scenario where the user is attempting to understand system behavior by
>>   monitoring individual or subsets of tasks' bandwidth usage when in kernel space. 
> 
> This seems useful to me.
> 
>>
>> - From what I can tell PLZA also supports *different* allocations when in user vs
>>   kernel space while using the *same* monitoring group for both. This does not seem
>>   transferable to MPAM and would take more effort to support in resctrl but it is
>>   a use case that the hardware enables. 
> 
> Ah yes, I think this ends the 'kernel_group' idea then. I was too focused on
> MPAM and forgotten to consider the case where PMG and PARTID are independent.

Of course we would want user space to have consistent experience from resctrl no matter the
architecture so these places where architectures behave different needs more care.

>> When enabling a feature I would of course prefer not to add unnecessary complexity. Even so,
>> resctrl is expected to expose hardware capabilities to user space. There seems to be some
>> opinions on how user space will now and forever interact with these features that
>> are not clear to me so I would appreciate more insight in why these constraints are
>> appropriate.
> 
> Yes, care definitely needs to be taken here in order to not back ourselves into
> a corner.

I really appreciate the discussions to help create a useful interface.

Reinette

> 
>>
>> Reinette
>>
>>> can mean use the current group's when in the kernel (as well as for
>>> userspace). A slash, /, could be used to refer to the default group. This would
>>> give something like the below under /sys/fs/resctrl.
>>>
>>> .
>>> ├── cpus
>>> ├── tasks
>>> ├── ctrl1
>>> │   ├── cpus
>>> │   ├── kernel_group -> mon_groups/mon1
>>> │   └── tasks
>>> ├── kernel_group -> ctrl1
>>> └── mon_groups
>>>     └── mon1
>>>         ├── cpus
>>>         ├── kernel_group -> ctrl1
>>>         └── tasks
>>>
>>>>
>>>> I have not read anything about the RISC-V side of this yet.
>>>>
>>>> Reinette
>>>>
>>>>>
>>>>> Reinette
>>>>>
>>>>> [1] https://lore.kernel.org/lkml/aXpgragcLS2L8ROe@agluck-desk3/
>>>>
>>>
>>> Thanks,
>>>
>>> Ben
>>
> 
> Thanks,
> 
> Ben


