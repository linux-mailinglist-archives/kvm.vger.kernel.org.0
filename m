Return-Path: <kvm+bounces-68499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CDE0D3A654
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 12:09:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C167D30066DC
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 11:09:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ED453596EC;
	Mon, 19 Jan 2026 11:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Yx5Ev/tr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C104A26158C;
	Mon, 19 Jan 2026 11:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768820940; cv=fail; b=Z0Rv+xJPtw6fnTGyrdgy2lqkTTXwO4zd1r+Rkl6mkJWCcui6SmEvzZNY+9JMdYZUJhXivL3AWb/lgUsytmylsCr4bRBI/5De7DH5TOnpyIxIA4Y/L3HjIuxnnjuwOfebWUxeerVayXgAob2+V93cdz1ypX5fpkVTdBOakOUG7Uo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768820940; c=relaxed/simple;
	bh=umQxOwu/NoIjiAnkdLXG4OylQIiVLDpqOsQHLh2oVPc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gZwyXdxXSDswmcerI7kXn4vSV4TU5u72JszmoGN3ieb5P2cKfZzhmrfd3l/CqVF59wPn3a0m7PBdbjgNsDO/lljnqmfCrOo2HrA9HUGWBw/tOZsNTdjkJIs2wIxminTXecYvzjVRqGFmf5POxmbfvOWFtu1lPxqzUZUvHH9hWbg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Yx5Ev/tr; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768820938; x=1800356938;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=umQxOwu/NoIjiAnkdLXG4OylQIiVLDpqOsQHLh2oVPc=;
  b=Yx5Ev/trRLU6+lVzs8fhC2ytTpThNaxVNJ9y23ugXV36ExC95xuKOU0f
   UV2Wku1Wl1eUgPL1CJnAnYpL8xpHsWAjiQOjTt0vhBTaBe2vYAEqOXdO3
   hXM+2aoxUIPChu601FEDRN5H74SS4q5UQURuZexN0Ugk8bKFu1bV2Vk/q
   vU26NAVkSYZEnsGxfaxTcNIRWMeru2EpA6VNlOuhB1tyi5vj0tiw9GIPR
   wA/h7UJuJxKRxQTtZCUnBa2bPC0AKvHpCAaIz2riU/hSVzNcHi27i17Q7
   gC0Ji2dEbV4n7BIXPEd3iR+dcyR40BNekFuFJBZtDkfwuDQ4ROky34X23
   A==;
X-CSE-ConnectionGUID: vjiBk9uFSduHHPv3eKBlYg==
X-CSE-MsgGUID: SALqollCSDeZKU9+YFRdKA==
X-IronPort-AV: E=McAfee;i="6800,10657,11675"; a="69231320"
X-IronPort-AV: E=Sophos;i="6.21,238,1763452800"; 
   d="scan'208";a="69231320"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 03:08:50 -0800
X-CSE-ConnectionGUID: +C2LQI97R765dULJKUOR+w==
X-CSE-MsgGUID: 1ajfyyrpQVKP1pKass0pYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,238,1763452800"; 
   d="scan'208";a="210330520"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 03:08:50 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 19 Jan 2026 03:08:49 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 19 Jan 2026 03:08:49 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.69) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 19 Jan 2026 03:08:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bxNaa5o6hc8sYH1V/TK9zwwJCgn4nyioT9PSU27P1vne8XmqoMHsqllkLNylvq0BvgISn4lxU4tV607GMHwwoFk7xgTU20lvlfvmDEtmscl9oEs8rGTAXLEom04T4v0cISNW1ohuf2qr/slwjUiPgNL46RSmWZ6wf5U9j8Cec+SwmKUTYiIkRfN51O22F0qiFX+ZTARGyydlDvPXV+ZCeZ0iDdntlN/N2F9bWK9NntodAfgUZ7+FpiRN1i8JaxEkyrpPR7sdQqsbPce9j4mcDp+LzpOLqM8AhE4OIjSgVzGUHIRreMyzGOkXH/WC8FzfL5vtD8spNdhZyiqN2nSILg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q4yRPrGjnf4NgZNIlm61Thbc2aLCEeEgsFMY9gnpdvM=;
 b=Gi0VwXutoTSf2VnWp2w96fDIU5U5WiqFc5Hxvfr0JxV/Tkof6o0PufH649jlryBHNbAgaXpOlko9XKWSGIOGMgeRe2VuPkSBfjQan+jzc7g9TEed0Ruqt/nXu7KZhHmRGMQJt1CAgEPD0kAnz2ZcTtjMnUe90IdQkPSatr0Gi5msPEvmFUvehzr3g/yaExo8jojjz1XA9PLTn1+4IwSR8M4y0lh0Wdzp1IF1aCa1S+TMluVoQAxQkvu+VEh6p3EI3WMCWGOZp+/TC+rgQGG/gxRgFr3deoha2tYK4hfsZjmIoUzvWTxW1etavxH9299vxLKJ5XQfBDVbPLf/Hh9CHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SN7PR11MB6558.namprd11.prod.outlook.com (2603:10b6:806:26e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Mon, 19 Jan
 2026 11:08:46 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9520.010; Mon, 19 Jan 2026
 11:08:46 +0000
Date: Mon, 19 Jan 2026 19:06:01 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "david@kernel.org"
	<david@kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "kas@kernel.org"
	<kas@kernel.org>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"Weiny, Ira" <ira.weiny@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "francescolavra.fl@gmail.com"
	<francescolavra.fl@gmail.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"sagis@google.com" <sagis@google.com>, "Gao, Chao" <chao.gao@intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Miao, Jun"
	<jun.miao@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"jgross@suse.com" <jgross@suse.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 11/24] KVM: x86/mmu: Introduce
 kvm_split_cross_boundary_leafs()
Message-ID: <aW4QGYQ+qMytZ4Jq@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
 <20260106102136.25108-1-yan.y.zhao@intel.com>
 <2906b4d3b789985917a063d095c4063ee6ab7b72.camel@intel.com>
 <aWrMIeCw2eaTbK5Z@google.com>
 <aW2Iwpuwoyod8eQc@yzhao56-desk.sh.intel.com>
 <3ef110f63cbbc65d6d4cbf737b26c09cb7b44e7c.camel@intel.com>
 <e69815db698474e113dec16bd33116e54cb21c2a.camel@intel.com>
 <aW4DXajAzC9nn3aJ@yzhao56-desk.sh.intel.com>
 <d9b677b4f4cbbf8a8c3dadb056077aa55feb5c30.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d9b677b4f4cbbf8a8c3dadb056077aa55feb5c30.camel@intel.com>
X-ClientProxiedBy: TPYP295CA0056.TWNP295.PROD.OUTLOOK.COM (2603:1096:7d0:8::7)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SN7PR11MB6558:EE_
X-MS-Office365-Filtering-Correlation-Id: a063489e-5f96-4b5b-c4b4-08de574b1d9c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?MG7ktZrGeDA/mHJtNok5r3nFHY+ha+3Q58yxd1/1B9aB95NhB3yCqkC8EG?=
 =?iso-8859-1?Q?VjhazciRLW64KWJy1YVBv06fTsEJKRK0QD4mx4j6mzpIyXVB+7/tBjiEY+?=
 =?iso-8859-1?Q?mpZcAY2n+f+JoDlr9/yFxQ9vei0DgyDFmx5+14ilizRSVlUUBIc3HLzJpT?=
 =?iso-8859-1?Q?9FVtKPtZRykJ8Kb7oA/ILHr38tjkJDX8H+WhJwXlpbhG036etgBJvYwrFd?=
 =?iso-8859-1?Q?cGBhl/fwgR9QkriKSCKhWykGo1JkLV7mlbMCWX+byPRVfB3zo4swws2Lll?=
 =?iso-8859-1?Q?irmukvBKrysl0mVwiER/ymZf/6Kbn5GbYZIEhgDmMNoAZMxFqHgmeFVNCY?=
 =?iso-8859-1?Q?M7Yhg8knWM35QMgjFOfYIKl79h86mWyY23ghtMThRkuHi16xc1r08zSTJ6?=
 =?iso-8859-1?Q?B6H5GWEdyy8EvqC9uNY1iS5V5IRwLqWLLxXZozmt3tr0zNH8oKiWx6i5Fd?=
 =?iso-8859-1?Q?PWO+Im+XvX9tfYGntUH51ZPrKH5eUfy9FYyPDcursQbVaJwsm8OGByWpHW?=
 =?iso-8859-1?Q?sYClHlxDnNLN/iHdY9g5+e+HEeCRHkYYfXF1wawIZVzHLYEtBW148otKzm?=
 =?iso-8859-1?Q?T6xzTtmRrbo0XcqEQdpvNA7sjom1tbkUxc1yYcYyrWY3AXW7LU4rGy6NoJ?=
 =?iso-8859-1?Q?eE5VnCvx0Vzp7X/EPDI2Bnb8RJw+ifnoyFUuGDKYeGmDwilcExNEvfF7Ie?=
 =?iso-8859-1?Q?p869NM236hI52xoTy0B4HlHIDBVjFPyyCYN4f0EScqlrufRAp3aagrbC1g?=
 =?iso-8859-1?Q?wy2EOEg+aI1Fxkl5ku5d/wNLvOpTC9HO0D6h+2txjPCPnmAPxJp6Lz7vf8?=
 =?iso-8859-1?Q?W5ZqLbsh6qUrnxcIwEifISr+0nJ1Fb2UZWD220HbaE7H5n+gOihaxbhd9+?=
 =?iso-8859-1?Q?4cq58YJ0Muvo4o9OwDHP+TSs/a7W2MI6twQTj36zYaUO5yQqcHMdFCChIE?=
 =?iso-8859-1?Q?A9DoEZAhquLiDPgmU/6SuWXS3kYC0TWjKhPiRBE0BhHnD18gukNntEfd8o?=
 =?iso-8859-1?Q?i9Yh8fZsYmSuvWVUL7jDW1yJGU7Kf0K7UvuL/FhsFmObPexMbVT134xcNa?=
 =?iso-8859-1?Q?uemAvKqsGTKm0n0EYEYsZ/Wvi3LaaQP0LO2OosHbgW9HJeQfDizuco3GaT?=
 =?iso-8859-1?Q?G7O1tetkzlN+BPCzLx2/ynN1TL99J+je7DaE8eBWMb1LX5KLkpPOrNp3Gm?=
 =?iso-8859-1?Q?U7wNdPXHKP+swBsSiDIOFLWJ054ro8NNXvjXCc7dT7K/+K2IvnWstHEDHJ?=
 =?iso-8859-1?Q?/VAop4V0tfEbcwHfBx52kzXCaZ90cvv7oXAsHBSuC065+8e7/N5H6cGBfM?=
 =?iso-8859-1?Q?KVrXvvj7FtbTkVxiOnvuC6H1+HcWa3CIuqMfyxuYRJtMKLRWDxMrHiBxUh?=
 =?iso-8859-1?Q?L/9iaAIciB4QoUR7hpBZEjHdVTz/wCZfgIuSoUX64gVLW8oK7E6RFYqehC?=
 =?iso-8859-1?Q?+5nSf2bsgdcmdwD3zTqytJyGSuOUckNOjockET6NB9KbjgnUS5zzlth28L?=
 =?iso-8859-1?Q?v2oUzfHieo1mn1GbJt//thfo2HHibNGhXN53OoZCJ/As2wwGs74RUWMgd8?=
 =?iso-8859-1?Q?HaNyzEsyDeok2hAGgCnfZH4ZJUmcJle+HU5oUgITPdIolwQB8VzGyP7iap?=
 =?iso-8859-1?Q?d37YcJQ2II/YE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?Qn8jqqilQUKcljnSzmCpXk8KbRLqkZ7nClnujWHkAZuoiC+WrT+b7p78sp?=
 =?iso-8859-1?Q?G9ZcPM9bTH2OKKcFCr1fket2nvzrTkCThGxUd3GUT3zx6+gmGqoM2Bhvdv?=
 =?iso-8859-1?Q?Jf1OOYzPTl8r4tCl8lyL8c+oUcAyyorbdK297mmlq6jHjyGhR/r+9nzA9A?=
 =?iso-8859-1?Q?170EFXmYumHd0ok5z4Ifr77YFbwiybsE/7f5z2r+baz8huizpK3bnxFW3l?=
 =?iso-8859-1?Q?DFGgkAiFgNzAM4304dB0zIuNHo12mdCbSFvdl8yfXxpJOLt1hYYE67+FQi?=
 =?iso-8859-1?Q?y7Xvw5GtUy2Tn0Hs4On1A5d8iffmmseGi0sOK7zlmeDRhhul0wtq/AFpYH?=
 =?iso-8859-1?Q?BJW01SURQx37bKs90dq5OS3jgDe62deolmXu7ryQyXR3DFNundCa3fyzdN?=
 =?iso-8859-1?Q?9NeI8vFRwcR5X2wnZ12UEFDRb8bEnZfjty1n9sULg1yAsNQy3b30n0o1rf?=
 =?iso-8859-1?Q?OmbWIe39pVHvXvU0uhhHBoExEISx6c8WBo7cOumRtBFbuXDQ46C9CGdkrB?=
 =?iso-8859-1?Q?725dHPMzJ4pKnO8B5TVGBDLaekm7XjI2nD17/V6n37D9KLMKh1uls9nKen?=
 =?iso-8859-1?Q?I88IeEt/OtdrVtIbJiAgpLRecSyBdgwvNQTIm0Ktazx+M5At4P8S8usnux?=
 =?iso-8859-1?Q?m9hO4CYKEctQThI8/A2bhrR+e2jeCLPvCLbFkK7v0XFLaIZgxO5hw1l8W5?=
 =?iso-8859-1?Q?tUaIMJRitcjkYBybZfzIqNpQ9GzsCLhJcySWgn4h78hSALCWucKVjAbDN8?=
 =?iso-8859-1?Q?kjBI57nE9oFh/WQlMKmN8kKMg+8gDcJppzgAE2HMf2HvxlHX1v/HhrKkWw?=
 =?iso-8859-1?Q?159EgC4vXizj5XCayx+yhzaDGTolfFz6aH7ChlrWGoRRZB6p27smABOuhU?=
 =?iso-8859-1?Q?Tgowfg3leB1QJZ6I2DYkdUhIwYsDUT8t4thq4A1dD5V1PfOYVhWlez6/3p?=
 =?iso-8859-1?Q?sAQ3PZ5MrNNY/Hw8U10BEOA3Un3UqgZ8e14yxWuMrOD/C56yCn9uu4WPXy?=
 =?iso-8859-1?Q?RY3Bpuq60fptsJOXXzQr8kd0XdbK0hRtazU+ej0bR/dLIuiIisZRUNUoTj?=
 =?iso-8859-1?Q?tDjEgNGR2yZIqmlXz93akZzmfs76jn337zohpmk7HeB7exaNHRtIv9mVJ0?=
 =?iso-8859-1?Q?q5o1WyyhM25LLz9lnhKRuYR1qNbvHvaqpZYJAcEq9InqcTtnx827tRpq4z?=
 =?iso-8859-1?Q?6eOYJ7HXSzu4l9UNJNbbAybpKGUcLeHeWc9X+XO+ifl7WZfa3bQcnJv700?=
 =?iso-8859-1?Q?3YX0sPR8Gs6KTB7uLuXVtXeRQ+nR1rZEbTkp8NxmiJDwiZP6xw8+4rAMOI?=
 =?iso-8859-1?Q?TDR8iYY/BnWbon9IYqVCkUiim1Rbbb4SW8JIi+iiON0QbpceUE7XYIpWRl?=
 =?iso-8859-1?Q?QkylGjA6hscTu3sM/ERkgpN9f5iZYORlqkwm4bRsdfbRUldnOLhmpU/l7S?=
 =?iso-8859-1?Q?XDjEF5Ch3zCygqjqZQhMIejVgWQRTd9zFGX/zdmHlezKP2Q9lDY6FjOT/H?=
 =?iso-8859-1?Q?1hgw6s9vcZG1RZYFMjnLfa3MjACRpfzrUQzdjb3ryo1gzEO7ZUuBeKstyu?=
 =?iso-8859-1?Q?83X1nO40UK+/26ZE08+XYecgZcDaLjqkIIbtgWMI2g5rHJNazu/ayqobpn?=
 =?iso-8859-1?Q?pTeXl0iXtydfib9WsPVWWuwW3olKKrzMUAzdfchd/zduOmcdu7ZNxgYrcG?=
 =?iso-8859-1?Q?BH+/vMtPAgBr93pKDsl2PeWaoBIwBascu+Zeh1F6RMx6bwTPWVxFin6FAM?=
 =?iso-8859-1?Q?/aZ9QTUifB8Kys9OMeGwum3NrdxYKx3dsfKDjNJewEMCRuVEyqAkwtvZhj?=
 =?iso-8859-1?Q?FT4hVDtBLg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a063489e-5f96-4b5b-c4b4-08de574b1d9c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2026 11:08:46.5347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EnjQzKRTAW4wl/2Q8BPJo54zKNBEj1aFlDW8hmvXg7JoOldNCgyCiUjewEbh/EA7JGXL2jaisqVdA0BPYgZv/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6558
X-OriginatorOrg: intel.com

On Mon, Jan 19, 2026 at 06:40:50PM +0800, Huang, Kai wrote:
> On Mon, 2026-01-19 at 18:11 +0800, Yan Zhao wrote:
> > On Mon, Jan 19, 2026 at 04:49:58PM +0800, Huang, Kai wrote:
> > > On Mon, 2026-01-19 at 08:35 +0000, Huang, Kai wrote:
> > > > On Mon, 2026-01-19 at 09:28 +0800, Zhao, Yan Y wrote:
> > > > > > I find the "cross_boundary" termininology extremely confusing.  I also dislike
> > > > > > the concept itself, in the sense that it shoves a weird, specific concept into
> > > > > > the guts of the TDP MMU.
> > > > > > The other wart is that it's inefficient when punching a large hole.  E.g. say
> > > > > > there's a 16TiB guest_memfd instance (no idea if that's even possible), and then
> > > > > > userpace punches a 12TiB hole.  Walking all ~12TiB just to _maybe_ split the head
> > > > > > and tail pages is asinine.
> > > > > That's a reasonable concern. I actually thought about it.
> > > > > My consideration was as follows:
> > > > > Currently, we don't have such large areas. Usually, the conversion ranges are
> > > > > less than 1GB. Though the initial conversion which converts all memory from
> > > > > private to shared may be wide, there are usually no mappings at that stage. So,
> > > > > the traversal should be very fast (since the traversal doesn't even need to go
> > > > > down to the 2MB/1GB level).
> > > > > 
> > > > > If the caller of kvm_split_cross_boundary_leafs() finds it needs to convert a
> > > > > very large range at runtime, it can optimize by invoking the API twice:
> > > > > once for range [start, ALIGN(start, 1GB)), and
> > > > > once for range [ALIGN_DOWN(end, 1GB), end).
> > > > > 
> > > > > I can also implement this optimization within kvm_split_cross_boundary_leafs()
> > > > > by checking the range size if you think that would be better.
> > > > 
> > > > I am not sure why do we even need kvm_split_cross_boundary_leafs(), if you
> > > > want to do optimization.
> > > > 
> > > > I think I've raised this in v2, and asked why not just letting the caller
> > > > to figure out the ranges to split for a given range (see at the end of
> > > > [*]), because the "cross boundary" can only happen at the beginning and
> > > > end of the given range, if possible.
> > Hmm, the caller can only figure out when splitting is NOT necessary, e.g., if
> > start is 1GB-aligned, then there's no need to split for start. However, if start
> > is not 1GB/2MB-aligned, the caller has no idea if there's a 2MB mapping covering
> > start - 1 and start.
> 
> Why does the caller need to know?
> 
> Let's only talk about 'start' for simplicity:
> 
> - If start is 1G aligned, then no split is needed.
> 
> - If start is not 1G-aligned but 2M-aligned, you split the range:
> 
>    [ALIGN_DOWN(start, 1G), ALIGN(start, 1G)) to 2M level.
> 
> - If start is 4K-aligned only, you firstly split
> 
>    [ALIGN_DOWN(start, 1G), ALIGN(start, 1G))
> 
>   to 2M level, then you split
> 
>    [ALIGN_DOWN(start, 2M), ALIGN(start, 2M))
> 
>   to 4K level.
> 
> Similar handling to 'end'.  An additional thing is if one to-be-split-
> range calculated from 'start' overlaps one calculated from 'end', the
> split is only needed once. 
> 
> Wouldn't this work?
It can work. But I don't think the calculations are necessary if the length
of [start, end) is less than 1G or 2MB.

e.g., if both start and end are just 4KB-aligned, of a length 8KB, the current
implementation can invoke a single tdp_mmu_split_huge_pages_root() to split
a 1GB mapping to 4KB directly. Why bother splitting twice for start or end?

> > (for non-TDX cases, if start is not 1GB-aligned and is just 2MB-aligned,
> > invoking tdp_mmu_split_huge_pages_root() is still necessary because there may
> > exist a 1GB mapping covering start -1 and start).
> > 
> > In my reply to [*], I didn't want to do the calculation because I didn't see
> > much overhead from always invoking tdp_mmu_split_huge_pages_root().
> > But the scenario Sean pointed out is different. When both start and end are not
> > 2MB-aligned, if [start, end) covers a huge range, we can still pre-calculate to
> > reduce the iterations in tdp_mmu_split_huge_pages_root().
> 
> I don't see much difference.  Maybe I am missing something.
The difference is the length of the range.
For lengths < 1GB, always invoking tdp_mmu_split_huge_pages_root() without any
calculation is simpler and more efficient.

> > 
> > Opportunistically, optimization to skip splits for 1GB-aligned start or end is
> > possible :)
> 
> If this makes code easier to review/maintain then sure.
> 
> As long as the solution is easy to review (i.e., not too complicated to
> understand/maintain) then I am fine with whatever Sean/you prefer.
> 
> However the 'cross_boundary_only' thing was indeed a bit odd to me when I
> firstly saw this :-)

