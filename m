Return-Path: <kvm+bounces-63180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 71932C5B7A6
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 07:12:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 946BF3552CB
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 06:12:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B3812E11D2;
	Fri, 14 Nov 2025 06:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f4szJuTD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB2DB2DF6E6;
	Fri, 14 Nov 2025 06:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763100739; cv=fail; b=OQ6zY+rUDdtdHkLtFV9i1xWgzx6pbgV2al0sitcuNQesKEh8dYATPSZi8rxRFg1btPPiwqu2PIfW765ff1uqD9XqujXSEMnp6P4GeEBAY0p29NHZp46fjLuuve1sbO7n0uY4a6/40xgKXey1xlYhTX6TijlyDZFzcbhvQNt5zS8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763100739; c=relaxed/simple;
	bh=N5uWyxzVyZwbvSIkwLkyM1vBFzZ7aM+F3r0ShozuOWM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=X9+HGSNljii4Pykte/G7VRhdXwgNTShEJD/LzPDjUtzUBZ0+7kc0bfMV+sPsEwDPJ82GoPhDoK7K8mdS+/aTM9/P6oTK19+Za+XY5sHTPGdIpGuZ34zDa/rK+x53JaMu8pzWHzumv7oGSj7CJ0N0qq7qGyjXnfZkzCNqM3sG5mc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f4szJuTD; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763100737; x=1794636737;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=N5uWyxzVyZwbvSIkwLkyM1vBFzZ7aM+F3r0ShozuOWM=;
  b=f4szJuTDpRNHEEbFk5hhjTmRSETxiFBjrubE36v0ZnUrKdHzge88FAtG
   SucbKPeffGjcAJStbySA77Mmp2tTk7k64+hV9sLFqTNUCe8OQuMq4/2e+
   7PH+Mv1jqF98Cb+LhOqRoIFse9kllGfuZyECX4x3WHnDobAlOX4A4UFRe
   IGFI+ahUdNIX+hjELQ1tQ+XFDt23r7BpRYyal8h0A8g4Yipsqo8pzYpFe
   0fkESAUcrumAN4BXB8xiPtHWEOrEuCzostaERUXdy8Q+rPLhggRSYMwFP
   CBBPIlJzNqcy1gADcZKQjaZs6Ii7jD5mRNpywY0uni5IQYjgRPBpAFZd5
   Q==;
X-CSE-ConnectionGUID: dsOx7G4xSdm4lLFJjDEp3Q==
X-CSE-MsgGUID: dn4iGS9+Te+8dYJLhNS5Wg==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="76651569"
X-IronPort-AV: E=Sophos;i="6.19,304,1754982000"; 
   d="scan'208";a="76651569"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 22:12:16 -0800
X-CSE-ConnectionGUID: tmzVrRHfT3iGmg7mUHJfYw==
X-CSE-MsgGUID: jHoZVbSeQuGFLp54tgMuYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,304,1754982000"; 
   d="scan'208";a="188955611"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 22:12:16 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 22:12:15 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 13 Nov 2025 22:12:15 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.33) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 22:12:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oUNGT4TwavDItX1cHhdQ7QZtn9ihcfBS+oCNd2f026qc8BU+NTX7KVYkB3cve2kp7AzJTP3ked3nrZpdif+ZMDfD0VxBPmOfjqPzSHVsRCrX+iRXx0s9K1Sq6eIHuDmDbiIUO2+SZqYM7FPd/1Z5R7vrQNe7O21QddCVWyoT1cjM6NirZcJ8eR+796U+MN1lZKx3bkPIEV6e7TFoH4GktHxCCz7SA+K5xfuodt1Ykb4j1ARcgknKcQowPZftvlG75j6182uyoqUizQRFfY8IEY0fSBJ6YkCJ+Nf15x6K8fkbT8tnoalQwej2OIC2m+R14GOTJxpLM/yslKsrgk95zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7PEzHlNtqqkcZ5UUfFEHBYgLOparDY9Jjk8tIjggRa4=;
 b=n3/hNzgjTb7rOD1vFmyTQDUuC3sgAAlJlaPE9DNtAN1j9pEqzjw7tbXgBrb4XmtlXsugy8Y90/3gPHqxo4PNUAh7CVRzfVmHEv1O8qbvJO/fXCXhvn1B5/P3JEQtnySc6hWD90lE9CBp4mgOPpoJnhtR9JVwpU9j3Irbz393RUBcpqdKyf1fNG1oTqdLDJM67+vXm2QX2VxFdtPpFXIacLNZYu2eoWFTqekyva/haXEX9+QZqIl6QCv8lJ1GPCWa0jDm/sNkyDH2Rh47fT2lay7w65D65aB/KuMwIlDimlnCwAXDOJuB97WuoA+K6IjK3LBmpnr4z88NJeQJYnYPtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MW4PR11MB7078.namprd11.prod.outlook.com (2603:10b6:303:219::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Fri, 14 Nov
 2025 06:12:06 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9298.012; Fri, 14 Nov 2025
 06:12:06 +0000
Date: Fri, 14 Nov 2025 14:09:58 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "kas@kernel.org" <kas@kernel.org>, "Weiny, Ira"
	<ira.weiny@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Miao, Jun" <jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"pgonda@google.com" <pgonda@google.com>
Subject: Re: [RFC PATCH v2 12/23] KVM: x86/mmu: Introduce
 kvm_split_cross_boundary_leafs()
Message-ID: <aRbHtnMcoqM1gmL9@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094358.4607-1-yan.y.zhao@intel.com>
 <0929fe0f36d8116142155cb2c983fd4c4ae55478.camel@intel.com>
 <aRWcyf0TOQMEO77Y@yzhao56-desk.sh.intel.com>
 <31c58b990d2c838552aa92b3c0890fa5e72c53a4.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <31c58b990d2c838552aa92b3c0890fa5e72c53a4.camel@intel.com>
X-ClientProxiedBy: SG2PR02CA0135.apcprd02.prod.outlook.com
 (2603:1096:4:188::23) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MW4PR11MB7078:EE_
X-MS-Office365-Filtering-Correlation-Id: 9223f004-5128-4c87-1eca-08de2344bcc3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?XY1eeM3zY4LuSUpfAHsZEntkUFupkxd7dKE/QTZo99g3ExNpqTBF7TJkWe?=
 =?iso-8859-1?Q?35mr5HnXEMR7H5H3ttKFR8GPy8ReZTz4JCUrt7rqH4e9q29eBB90QbBFJa?=
 =?iso-8859-1?Q?cSbkKiCkBBe/M+NsBM9G4NHvF9fswbjgUhm80kp2FPTn6uSGd4xfKFrRGj?=
 =?iso-8859-1?Q?8EH7HhgFYch1bOCjpo698aNSFtt8cuvOWi5OyaIKYzsq43md9AyxN14LhL?=
 =?iso-8859-1?Q?PBwOgzJGZ/EtURlENIKg8NlIsPn81Jiz9zoB6IMEvC8q6iFfpttjboH7AW?=
 =?iso-8859-1?Q?EVO7y+aTAo1fcwc/oBIanM/xKfvgbGHf3wROxNY56TOIuYgQHdIPm6LbUR?=
 =?iso-8859-1?Q?POq3Qz+tT4hP3Ta5Gnsv2I277KyrhLibPZqkfZpi8K0N7feMpAAed0cYpe?=
 =?iso-8859-1?Q?FPOK0llIDSG9m86wU/oplK/uw9qWpZpqijyF7kebcqws2ndsWylgeCJo88?=
 =?iso-8859-1?Q?cuXLDYLSMlw373pHEKkKdeVOndiDyr5uOA8/7vnZ5nuiIFOtjGYr/pgEOh?=
 =?iso-8859-1?Q?kdxanr9Q9NLFHK7mfvWTlaqOEpXML7+z88bp+NG49WxR3y6+KuP/qLioWi?=
 =?iso-8859-1?Q?ARTbrqVZRLF3Sr58eiy9b6VlJIondweMHceZ+Rb/7Rc6JXV20J3PuVM4wy?=
 =?iso-8859-1?Q?4pO8H7No4k8rZSsDsdcABvIS6wpWITa9JIjllkn8sK16/kQzs9WtHs8XpD?=
 =?iso-8859-1?Q?On3iFVWMbjL9YbsjEHschbPbJoxYrkE5oVmtDS90o6udevpwd4crZr14oh?=
 =?iso-8859-1?Q?EZCs/A+Moho1G1iS48BOXrep746sM0AYQH6sm7Hfj19fdC8/G16ZM0WC/u?=
 =?iso-8859-1?Q?Dg/QlJtYt2F/SBcMLGKdFbtj1/1kHxZVuV3lzp9laucQ0HYU6DHiQoKZq7?=
 =?iso-8859-1?Q?aB+MgQPWjauw0+jZycAi0W8QevHvODS7BXwTE0bb5vaO8JdP4FFbfmiRBV?=
 =?iso-8859-1?Q?TUDO5WHBA9ASuP9KLet/B/5A3/1VxCkzMKYakA14gQwlWerbaoEhvRxSUW?=
 =?iso-8859-1?Q?/sUrM+627TUEtAv5ukWtWjNznM6m+jcc1zjrkA8txHqphsa3Pb1omIQNzB?=
 =?iso-8859-1?Q?lEv/3a+zTUBN6pfnNcuEg9WhIpSSUo1zPtcS864hDZgNwpM9/Q+CY5JBzP?=
 =?iso-8859-1?Q?XwHSwmJB8PEKY7Za+kJRQUOF4SrWlvOu2BGuCQHpo1F0IMRxoAhGvu/BHs?=
 =?iso-8859-1?Q?5XQjnerXU35nDjFy94Z0U54SZAFBjsSTQ+QmC8YkLa6aeHfJalrhV+IuzI?=
 =?iso-8859-1?Q?sWJeoirMLdvNx3RZTdukDpWATFmQ+8r0ZoJI8bZzJ/EI0qP2k0XxMaiG3c?=
 =?iso-8859-1?Q?TSKRY13quYI7qlnVSQ90ypsB0npyVTPSCMLR33DyWP9Y4uvM6uD9ZKNPwt?=
 =?iso-8859-1?Q?+ytW7CtlSy11ieUTo1EGHKKFHpWC6qwnhWGcI9afVfAcrLrHnsbMg4Q25C?=
 =?iso-8859-1?Q?FiUw1vhR8muQimYFeF1TRZkwjOMVFwvawPPcHj52oyMXGvTwNu62tDWIqG?=
 =?iso-8859-1?Q?Im/OZBUa3ykz2eociZC4Ah?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?gCvQbLdj8vgp11h+589HdjGebOK3KZ/mjKj69ub7QZxcotoimXKGYq+Dht?=
 =?iso-8859-1?Q?hcsrVMBMQogk6uA+/9Zha2SjHhCVNoWp5nZ05y6YNNQTIoDOQx6fMx9XsP?=
 =?iso-8859-1?Q?/Kat+d2lVYgrIq1YV6kk3V5aVeK4oBczs0c+x0968SHyDEoZNTsntJAF0x?=
 =?iso-8859-1?Q?Z7M3cy46K1pL1TjSkl0V4ApWkbNcpvrGxOZKN0mA8cXe0kdq5Z3cp6KEcA?=
 =?iso-8859-1?Q?/NcgT3lAAP91/MDMfr8H+5Pt2F9p0CWM413+4HY+2bSR0mwpMzLrj85xm8?=
 =?iso-8859-1?Q?YyTYi4GI3xXoOais317BA7d9m/TG5k7sJYpgHUverwgJ9w5lRxXCFM02Ji?=
 =?iso-8859-1?Q?Ui/NAsaUdvDJgWriBf88WG7kFvtNg6rUHtqiWKVvL8Hxr3hfRS4ZUYgw4L?=
 =?iso-8859-1?Q?61EA0eu/t45fewTP8IPRUKZZkcSU5fSKNKsSook0gnmajCElAzioL7it+k?=
 =?iso-8859-1?Q?GZhyqs1+V724lCEOTBqNfOl9P1UU38Fw2QpZh5E7keumfXks/8ziQOtuGA?=
 =?iso-8859-1?Q?jMNKSWtJQ0BWxuoEm8tmWUIgOEkGtydtDt0D2TyUZ4vQDVQenVXPNetV2S?=
 =?iso-8859-1?Q?BeEQWEJsaYoJR/YwwN/u/1MbV0gOUM+1XtnjhxL1xECdkCVGke5SOpXCM2?=
 =?iso-8859-1?Q?dsz4Y6FRsrswQS8yf94Gm8f95hCHQl4uxrR57qPVv2AcoeUk3MF0CYstJd?=
 =?iso-8859-1?Q?1csHlMxdFp7JdVxbye+LjK/Vn6XIDSfSLngL6JhN2AoQasWeIyfv508L9y?=
 =?iso-8859-1?Q?p1OyAb8BNQLU0Wb25U7ycV6J/kYGEn3yKnZM4Y2xgKsdnBxY6Q8AIdN5Qg?=
 =?iso-8859-1?Q?nlKZAi5nLhCUhefsTyOwZxitEpznqolm++cofGBiq0GcRxSnLWRj0BQ8Qi?=
 =?iso-8859-1?Q?2cGOqSC8Ee+SEVbuVM5bAJmq2pEn5m6YqpSbekMd3l0/c+fsOI/thrqwip?=
 =?iso-8859-1?Q?9rCjeuD9N1sdsVGIliT6fNhOZaghHZVPdLc2dW1QNh3svT0xlHfsVomKQq?=
 =?iso-8859-1?Q?4iQVIsGVZmMfbTkScm+FldkZ60dwJPOFSmHCUltOt2SndFwp4IauOKrL1X?=
 =?iso-8859-1?Q?coSjccjyJezAYCgkga0k8ob9EJ4h7l4fd5U5vM7rTbrZFBMEA0pkK8pFit?=
 =?iso-8859-1?Q?9gujJkbiuo8/zgchqfeiZbhBscpWP0a3/Gn4cPpLFi2MfxLgP0m4FFTQRB?=
 =?iso-8859-1?Q?CRr3MfVdoszVEDLpjomXCuvhIO0c7ZD162uHTjyyvwgSV+e5zXHMINsVLS?=
 =?iso-8859-1?Q?LMGb1ctFjBjBOZXLz3F1Ulfp0SmQCi3gn/rUlemljoDze32f4PL+YdY9ot?=
 =?iso-8859-1?Q?5BU7BReEIeXfrKDsjrd2Alce14mbslsHJRy5lNhs9Yx+8sX1Jn839HwK1e?=
 =?iso-8859-1?Q?XAeGx83ymq4SQwF9khYb/eDBy2kJhe5WqEaLbLJGJsExxhwsIg+8VBGfys?=
 =?iso-8859-1?Q?iBKZbSrLlHAiqTnFJYGVThkQ6UeNMzpmYOzlqug5H0GLhY25ZINz59sbym?=
 =?iso-8859-1?Q?ODSXu0Z/BVNOdovDRj/vW6VCwixZCfkpfXHTQa1xJ+FOLQbifVafwg6ABC?=
 =?iso-8859-1?Q?w5N1WKD1Np9qkztfZ4sEAHNtQ82bMxHMoQLnRPZA0h5KKrdEdIcBZgCl2m?=
 =?iso-8859-1?Q?wX7NNNRiIg0rUscAg+OIVI8Kkx1SrqLKR4?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9223f004-5128-4c87-1eca-08de2344bcc3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 06:12:06.7056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8AUSR0dKx0h3XsK1Y5OB4yHM3lm7p3qmohZwyPLFZqBVNj3Gjs8ATGFjVJM6hXaFXHyymrpRhpERZs7QNcKGoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7078
X-OriginatorOrg: intel.com

On Thu, Nov 13, 2025 at 07:02:59PM +0800, Huang, Kai wrote:
> On Thu, 2025-11-13 at 16:54 +0800, Yan Zhao wrote:
> > On Tue, Nov 11, 2025 at 06:42:55PM +0800, Huang, Kai wrote:
> > > On Thu, 2025-08-07 at 17:43 +0800, Yan Zhao wrote:
> > > >  static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
> > > >  					 struct kvm_mmu_page *root,
> > > >  					 gfn_t start, gfn_t end,
> > > > -					 int target_level, bool shared)
> > > > +					 int target_level, bool shared,
> > > > +					 bool only_cross_bounday, bool *flush)
> > > >  {
> > > >  	struct kvm_mmu_page *sp = NULL;
> > > >  	struct tdp_iter iter;
> > > > @@ -1589,6 +1596,13 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
> > > >  	 * level into one lower level. For example, if we encounter a 1GB page
> > > >  	 * we split it into 512 2MB pages.
> > > >  	 *
> > > > +	 * When only_cross_bounday is true, just split huge pages above the
> > > > +	 * target level into one lower level if the huge pages cross the start
> > > > +	 * or end boundary.
> > > > +	 *
> > > > +	 * No need to update @flush for !only_cross_bounday cases, which rely
> > > > +	 * on the callers to do the TLB flush in the end.
> > > > +	 *
> > > 
> > > s/only_cross_bounday/only_cross_boundary
> > > 
> > > From tdp_mmu_split_huge_pages_root()'s perspective, it's quite odd to only
> > > update 'flush' when 'only_cross_bounday' is true, because
> > > 'only_cross_bounday' can only results in less splitting.
> > I have to say it's a reasonable point.
> > 
> > > I understand this is because splitting S-EPT mapping needs flush (at least
> > > before non-block DEMOTE is implemented?).  Would it better to also let the
> > Actually the flush is only required for !TDX cases.
> > 
> > For TDX, either the flush has been performed internally within
> > tdx_sept_split_private_spt() 
> > 
> 
> AFAICT tdx_sept_split_private_spt() only does tdh_mem_track(), so KVM should
> still kick all vCPUs out of guest mode so other vCPUs can actually flush the
> TLB?
tdx_sept_split_private_spt() actually invokes tdx_track(), which performs the
kicking off all vCPUs by invoking
"kvm_make_all_cpus_request(kvm, KVM_REQ_OUTSIDE_GUEST_MODE)".

> > or the flush is not required for future non-block
> > DEMOTE. So, the flush in KVM core on the mirror root may be skipped as a future
> > optimization for TDX if necessary.
> > 
> > > caller to decide whether TLB flush is needed?  E.g., we can make
> > > tdp_mmu_split_huge_pages_root() return whether any split has been done or
> > > not.  I think this should also work?
> > Do you mean just skipping the changes in the below "Hunk 1"?
> > 
> > Since tdp_mmu_split_huge_pages_root() originally did not do flush by itself,
> > which relied on the end callers (i.e.,kvm_mmu_slot_apply_flags(),
> > kvm_clear_dirty_log_protect(), and kvm_get_dirty_log_protect()) to do the flush
> > unconditionally, tdp_mmu_split_huge_pages_root() previously did not return
> > whether any split has been done or not.
> 
> Right.  But making it return any split has been done doesn't harm.
> 
> > 
> > So, if we want callers of kvm_split_cross_boundary_leafs() to do flush only
> > after splitting occurs, we have to return whether flush is required.
> 
> But assuming we always return whether "split has been done", the caller can also
> effectively know whether the flush is needed.
> 
> > 
> > Then, in this patch, seems only the changes in "Hunk 1" can be dropped.
> 
> I am thinking dropping both "Hunk 1" and "Hunk 3".  This at least makes
> kvm_split_cross_boundary_leafs() more reasonable, IMHO.
> 
> Something like below:
> 
> @@ -1558,7 +1558,9 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct
> tdp_iter *iter,
>  static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
>                                          struct kvm_mmu_page *root,
>                                          gfn_t start, gfn_t end,
> -                                        int target_level, bool shared)
> +                                        int target_level, bool shared,
> +                                        bool only_cross_boundary,
> +                                        bool *split)
>  {
>         struct kvm_mmu_page *sp = NULL;
>         struct tdp_iter iter;
> @@ -1584,6 +1586,9 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
>                 if (!is_shadow_present_pte(iter.old_spte) ||
> !is_large_pte(iter.old_spte))
>                         continue;
>  
> +               if (only_cross_boundary && !iter_cross_boundary(&iter, start,
> end))
> +                       continue;
> +
>                 if (!sp) {
>                         rcu_read_unlock();
>  
> @@ -1618,6 +1623,7 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
>                         goto retry;
>  
>                 sp = NULL;
> +               *split = true;
>         }
>  
>         rcu_read_unlock();
This looks more reasonable for tdp_mmu_split_huge_pages_root();

Given that splitting only adds a new page to the paging structure (unlike page
merging), I currently can't think of any current use cases that would be broken
by the lack of TLB flush before tdp_mmu_iter_cond_resched() releases the
mmu_lock.

This is because:
1) if the split is triggered in a fault path, the hardware shouldn't have cached
   the old huge translation.
2) if the split is triggered in a zap or convert path,
   - there shouldn't be concurrent faults on the range due to the protection of
     mmu_invalidate_range*.
   - for concurrent splits on the same range, though the other vCPUs may
     temporally see stale huge TLB entries after they believe they have
     performed a split, they will be kicked off to flush the cache soon after
     tdp_mmu_split_huge_pages_root() returns in the first vCPU/host thread.
     This should be acceptable since I don't see any special guest needs that
     rely on pure splits.

So I tend to agree with your suggestion though the implementation in this patch
is safer.

> Btw, I have to follow up this next week, since tomorrow is public holiday.
NP.

