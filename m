Return-Path: <kvm+bounces-41031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C0E23A60D02
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 10:18:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 46EA9174DEF
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 09:18:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1D591EA7E6;
	Fri, 14 Mar 2025 09:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hlo4TMIr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490D91E633C;
	Fri, 14 Mar 2025 09:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741943908; cv=fail; b=NxNQdkJsjpxeOB1qjORZqZMTeIXbqi2hdCPW/+0rtreojKzH+Rc9cUDpekO2UvxgoqkrTpX8ZVcu1W5w8q+PUxo9WEuHELINC/+zbH7m4RPSMb+G7sN5djHpEGqLGIpRSBEOR0wYKq8aYdroFMWOReh6ip4pKNS4fALOFfiQEx4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741943908; c=relaxed/simple;
	bh=LDm4c9uGjaUTezr62ZOW4TmTrPvCCquKGyfGjOJTeCw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LpezfjE8FkIKnJ34tIIOvxldVs+2SVr19PO+efXfrY82C2i5Te/m6lPpwk8ZXXMgW3PxvUpa9No1LTAEHbJLMxQGU1hcjNQ3biMhVfsaDdklZhHRePMH2lehbOO9B8I1lWFBZNpw86q5NBMHeSjOJP+MUwVG+zuSXPdSS9bWLPQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hlo4TMIr; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741943906; x=1773479906;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=LDm4c9uGjaUTezr62ZOW4TmTrPvCCquKGyfGjOJTeCw=;
  b=hlo4TMIrRKUwpAEZHDoX70vKaZ3/0xjTYSvh9JPRLVhS7tigpMD/mF8L
   QqnkhmZ+lBRiRvUrb5yqjsHelXLg7yoXyA8yihUdi/hM78cCqiFbz9r0g
   BsvmO1oGa4PM2z8Vf/EOl5nvB1xqkXJ4eI59l4w5Bcq8f2XFskoEb0omZ
   sgafyVzlPBIg/rALQYbzgZZlIyT2qRssRtyFJLzLEcvA/ia2Oz5Ddmj+V
   SNo+8srZ+7IxG9ghZzPvGKzqzZTuBJYHn1uJLvyIW2cIWPFhCGXcC0Pn+
   S6Xt783m01XqXIHi8LYxS7A6/S9b8FvsYSV0qk07KqbPELDVnk17xVsTZ
   Q==;
X-CSE-ConnectionGUID: hSHurJW6TkGQUh9kz4fNoA==
X-CSE-MsgGUID: oUhkP30dRM6qG1BPnr2hQg==
X-IronPort-AV: E=McAfee;i="6700,10204,11372"; a="42954143"
X-IronPort-AV: E=Sophos;i="6.14,246,1736841600"; 
   d="scan'208";a="42954143"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2025 02:18:25 -0700
X-CSE-ConnectionGUID: dMcNBkT4QuKFzz9xs0kaQA==
X-CSE-MsgGUID: 5HGW+Xr1SXmRWQnNn1p3Mg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,246,1736841600"; 
   d="scan'208";a="121913759"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2025 02:18:24 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 14 Mar 2025 02:18:23 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 14 Mar 2025 02:18:23 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 14 Mar 2025 02:18:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jv2f3lnSo8OHMJ2fYGjjm5FRApJOYBWPdBsJT1Ma0hG95VJdU0WYMe3f8Sdi0ZS+LlIDmmYloM9R8YORZrX2gwDrlr9/BGIT92ThgMMfety/Z0VDsOo10K6dcwzf2x5TOh4bN+Ue//vI/QGknQ4YTO+yDvLU7x2hbzT//dWrEDhyWNc4eIdSDvWvLos2tOkN48ECYJJE4g0H3HWMIQXSSsBtUnqExXwcL3KYwWK1oxjaA2HHvcCiSCTI84DMclnP/HSeQDCC3FIK7UUNfqyl5JmNiTJh469+Wz628gaM483+JkbA/5GCmX36q0QuxdPLMdcSi6h7RHpL1Xq4JAGoCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6/yWKMnuYs6MXUppwed8uoN+BpE6MWHS+Nre5efDPdA=;
 b=M2NiyPy4tmfZsAQKWNOrxvo5U2Wvg4gfiQk27U0UtqBxOAAysSoD9SZ4N9FSaCVqrHB4cvfFFQZP1UX7G7JSM1gYl9TA+X31iNOWQpB9VlnOu+FvLC6y3qixraF+5fSDTEfyh3vJhvDqKYRzHsXGeSEp120R/fG8YV3ZlfnXMNtjISjtfxciz8uLAfHrXeTxPmlwEPwUuVhMQmDHkB7E8sAFL1AfbJvlJ/xcyg98tnR9W9gE4578K2Ogp73UutA2y6YiSCLwK12K1GkL0ka977Pu04rawZPTDwHH4+LWb6FtKu1TjEnH9DC/U3qzDL9CECZ3CDVpP4kShxQl2ZSQuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH0PR11MB4888.namprd11.prod.outlook.com (2603:10b6:510:32::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8511.28; Fri, 14 Mar 2025 09:18:20 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8511.026; Fri, 14 Mar 2025
 09:18:20 +0000
Date: Fri, 14 Mar 2025 17:16:50 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Michael Roth <michael.roth@amd.com>
CC: Vishal Annapurve <vannapurve@google.com>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<amit.shah@amd.com>, <pratikrajesh.sampat@amd.com>, <ashish.kalra@amd.com>,
	<liam.merwick@oracle.com>, <david@redhat.com>, <ackerleytng@google.com>,
	<quic_eberman@quicinc.com>
Subject: Re: [PATCH RFC v1 0/5] KVM: gmem: 2MB THP support and preparedness
 tracking changes
Message-ID: <Z9P0As/Wv/8PDBNN@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20241212063635.712877-1-michael.roth@amd.com>
 <CAGtprH9ehiz+yKfQqj6JeObaPv0DPUsoAH+YVdSeuzL9zhw9tA@mail.gmail.com>
 <20250220010957.cueewk2qliqlpe45@amd.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250220010957.cueewk2qliqlpe45@amd.com>
X-ClientProxiedBy: SI2PR02CA0002.apcprd02.prod.outlook.com
 (2603:1096:4:194::22) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH0PR11MB4888:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f7627e6-f890-4d05-f082-08dd62d92987
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WTBzNExmMzFjNDBDMUlZR2tJdk9KODBkOWdCUjQ5NzRWck5UV2RNV1lNRVdw?=
 =?utf-8?B?SmdhbjJUTVd0cVpyTmxjZ0FyMXJFUUdIcFEzTkd3TzczMEpFdE55YlNLNEJX?=
 =?utf-8?B?VUpqem1sWG11b2IrZ3BQU0VCKzV0ZW53alExeGZyRjliU0d1c01kVHRHN3Aw?=
 =?utf-8?B?dDc4UE9VUUpVKzFDRmVuRFN1Y1E0Z3B2RytiR1M2alFTU0pvckJVaENXSzFq?=
 =?utf-8?B?RGlrdm1xR0dIaHlybVBMQ1BwV1BxMGlmdGZWRlBJQkZiTjd1V3gyRXlLSytm?=
 =?utf-8?B?NFdVN3g4UGtMKzY4Z3luNlJMSUlSOUJ4dTFjL2xMWVp5Z2tieEVYZkMxUytH?=
 =?utf-8?B?K0FoSmpUYndEMGxyeTczV3ZDd0ltVzA5RmpWck9KMzFYRTFEMGhmWlZuKzFr?=
 =?utf-8?B?MHZ3dTYrTnFSdWt0eDhPOEQ2dkRsSU01UmlVUW53YllRTm9zUjlWT2xRczJ3?=
 =?utf-8?B?WWxzVG9IbnNOaS94bXpKZUc2THZ0RW5VcFlBWEEwV2RJVzZQenQwbHVlOTRI?=
 =?utf-8?B?SWZBeTN2ZExBWkNDaTlISU10NDI0SkVpMnIzd0FqUm5OVndYWTQvQmZNc2NL?=
 =?utf-8?B?ZmpFdGJvMkI2Mi91QkEvRDYzOVF1QnlxTzNSMUhxZ0pKZjd0TmExUmxsMzdD?=
 =?utf-8?B?b3dKY3FzNW1rL1B0YTRySEpXWCtxS1pGK3IzYUhXSFlLYzI2cmdaZ2U0cUtO?=
 =?utf-8?B?Y1pFVnFUV3JQMkdJNmM1OVJPZDFvcGlGT2NXWHBpYVlIcWo0T0I2OTB3bnRH?=
 =?utf-8?B?Q1UvK05ObWN3QzdNaDFCTWtNNjA3QmloVnc5VU1BbFo3VFY0MjJwa2Y0dGVL?=
 =?utf-8?B?TDF2TTJRemZWQ2FPWWsxdTFiekN5ZElISVh0SklRU2tDU3pCNGt5ck5DVXlF?=
 =?utf-8?B?R0h3SWhIWEQyY0JBQy95YUowVDdqUmFXTlRjUWdYSkNZWHpjSXc4VW1lK2lk?=
 =?utf-8?B?eE9VTEpMUzBzUk1rL1A5dUdUazZ1djdCUENCTmlzZzgxZmovYnUwOTlsU21M?=
 =?utf-8?B?SW5RSDZ6Tno3SzMwK015MkJxcUlBNGJ5Y1luRWliZ1dLYVNjTVlkZ3pvZjE2?=
 =?utf-8?B?SW9FVGFjN3ZQY2szQzh0ZmticCtEdUFVai9oNWRPMEhhRDlkZ05LQ1dQQ3ZK?=
 =?utf-8?B?Ni9GWmJqNWllbXM0TDZEL0JDbDZ0LzRja2owVTFUc1ZMSXZqUTMvRjgraWJm?=
 =?utf-8?B?WXhPZnBMYjFlZmErQVJlbHp4UkNNblI3VmQ2UUVCcHZxZ0RQdjYrWmtLUzJ0?=
 =?utf-8?B?OUY2Y2dobUtoajFLaVU5WHJFM0Q2V045L2RnVkViaXA4T0ZTVDRESjFQVWY5?=
 =?utf-8?B?WnlXNDM2K1ZBdkoyUVQ1SFh6OExnWHJOcGl1NDg0UE9ZS0xISUduNzFHR0J2?=
 =?utf-8?B?OHdDMkpuRUExK2FwMFZxWithYXE2YTNjRVVyM3NTc0lTL09xdmlIdG5ra09P?=
 =?utf-8?B?QXFFTmNsRmZpZkk2TzI4eGxXbVZIbUdqNmx6azc0OWxmQjdCL01TcU93MWJw?=
 =?utf-8?B?M2dFSEZEdUEwQWppSFJlNWRZSnZYSmNqbllwNHBXdnZwU3lNbkQ4QldWc0JO?=
 =?utf-8?B?bUNsRWZFUjExZUF3OFpsMENFSVR3S3NVVXZDZmk2NHJlWkE2SVZ0Y3dtOGZr?=
 =?utf-8?B?NnNnWE9tQXJWQnMyUFZhLytjcWlpc1RQTnFWeDhtNllKNFBsNFovSGlscFYz?=
 =?utf-8?B?MTIvVUNESjJGK1RiNDJNSWZORnI0d3VMQ1MyMlI5bEk5S1FKNHViNzBPMHpJ?=
 =?utf-8?B?T0R4WDFUVzFSdlE4TmNCSlhYU2EzUGx5czk4WXdadDJrRE83MTR6Qk5mN3R6?=
 =?utf-8?B?WTk3OUhxa01jekdyVGNyUTR1TXlhZVJJSGpwWC8vRVpIN25hYURmbmVCMzdG?=
 =?utf-8?B?dGM4czRMMVAwMzYwRHJhQU15S3R2YU5RQ09vYVBid1N2UkE9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R1FnSjE4SEdzaHBuUzNKRWJYRm8wQXZXalFGalBoaFBUYVhqVHhwa2gwQzY2?=
 =?utf-8?B?STdFNitqRG5Yd0pGZG1lRUd1eENvZXZnYzRKODNUb2dOZ3ZIcmE4aW1CckdM?=
 =?utf-8?B?SmV6NlB6S2dNSUVLU0pMKzRmNGw4RXd3bDU2S1MxeTltL0RDSFRiQkVUby83?=
 =?utf-8?B?a1RhZmU0ZDRlNjlUeU5IeVhjRSt1cThMQWJiRVlGZnNXMmExMW1NMHNJaC9U?=
 =?utf-8?B?VDk0dFl2THEwVGZDVjN5cTNlbzRsaERPQ2FON1VtMlovRGQwSkd4NFo1Nm14?=
 =?utf-8?B?ZHhUVnBnQjFJK1c4QndkNzI3MnFGSDZTaVdycFdtVUtjRkJUaFRLTGh4Q1pC?=
 =?utf-8?B?TmJEYmg3c1NvdXlUL1dzeGExSFNtVjJhMm1OT2Z5TjlCSTJ4dG9BbnpmK2Jw?=
 =?utf-8?B?TEkrS3Y4UGtTVHUxMFdzMThWR1lGSktNRTdhWEI1ZVFFM2paTTJuK29MbHdq?=
 =?utf-8?B?aGxxTTZYbEFiLzJaNDBHdjRBa2IzNTY3d3NCL2dpajhUUXZTd3p6Q0YvUmhk?=
 =?utf-8?B?eWI4WlVmWk1RZjNhRTJMa3FTTHlyYXo1Q3JiRG1wczk3cElXOTVaK3BwN0Q4?=
 =?utf-8?B?cjZHdGVCMjdENExjUk5ySjd0UGQ3NDVrT3RPRE1admIwdCtnN1hTMDZZRW1a?=
 =?utf-8?B?Nlo4bnlVQmpPdzNaSHc1OGpSbXV1SXlXcG1xRVZPcXhTcDlyQnk2cnVZU0JU?=
 =?utf-8?B?VVF6K0hwS1dFTGFLZjlWbWZtNkdtSjBEc3ovQ2c4RWd2OFErcGJKSStrRXBM?=
 =?utf-8?B?WE0vSUF0MGdoak9IWjF1MFRnMFltcXg4ellhU3lrbkh5aVpTaGxRR1h5Nlhq?=
 =?utf-8?B?Q2RkdTIreWNQVUkvbVVVdStxU0ZZU0prM2piODdHc2YwTitxaml1YjduTGZL?=
 =?utf-8?B?dnJmZ0MxTkdaWGdLQVhyWHA1bGxRS3ZJaVNPdXdxT2RsTjZ1QlluYzdVVVFH?=
 =?utf-8?B?K2g4TEtmSUpBSy9wcUVOalE1SnRtUFdLSG1SOEF5aHhjT0RHeWs3WHNJZ2Fm?=
 =?utf-8?B?WVJlVUR4eWtZMU9MNzFtcXl2MTNaTzdzS2xTOS9TdFNmM3BkZktoUGV0Qitx?=
 =?utf-8?B?MG9kNHFrRDhXVVI1NEMxRGJ1OXB5NDgrNW1aN0tYTmE4aEFtU2lVVVo2TGpr?=
 =?utf-8?B?bWRQMnZneUlIWmRUbS9YR3VsSU5uQ3YyckJPVHoxdytWK2lveE1ObFNtVjRn?=
 =?utf-8?B?WWlBa3ZHZ3JtVG41aThqUzZGNUpVYm1EODcxbXpEUFlkQ0ZVZktQd0ZBcjF4?=
 =?utf-8?B?L0M0RVFIcWxnWHVXT3drTFBCNzVDRCt0czdSVGpsSUVKNFEvUVk5ZERyZEEz?=
 =?utf-8?B?NTl5V0kzZ2FocENIS3Z5TmlGM2hrR2JVYjBHK2x2Qk43THhTUzZjYU82b3Bz?=
 =?utf-8?B?cFZBM3IzV2VvY29VcHdFMDhxN0NBQnNTaGtoa2wvWC9ZdDMya2xPNXQyMlUz?=
 =?utf-8?B?YTQrUXVIcExXbkowSFlwNVpwQ2JNbS9kNFFValFUWittUFp5WFZRVXowMm1H?=
 =?utf-8?B?cU8yQ3VUd2NXUVFOcW9tcVl2K0tJemQwZ29FM2FtR1Q2ODYxK3krVW9pbTMv?=
 =?utf-8?B?SzV1UUZ1d001V0lES1VoamlZbUhiMlZ0bUE2SkprdlNLOHFIRU5NdVhwOUc5?=
 =?utf-8?B?NG1xY21mU1pHTDEwbTRlRnlPTmwrUzhxTVNsSHZEaGIxQTdVY1d5Z3BDRU9t?=
 =?utf-8?B?eEhabzFXQjF1aTVleG1Mc1JOZ1JJV1g5ckZrc2VxRjBIdDNRVFhQSFRzZXdG?=
 =?utf-8?B?UXpob0VjL3A4c0Vza3Q5dXdLQ2tNQXJEbWIvNlpKYjJKenErZXF0blZ2Y0d6?=
 =?utf-8?B?NVhoTGtOMEtqKzhFdTFiSGFFcEdkNjlEYU16VitTdGc2UmRUTi9pVVN3US9S?=
 =?utf-8?B?dUZneEh1bnZaZU5oQ0k2QXdYNDM5RHBaZ2x4KzVmUDM5ZjRDWW04dHlPSDRY?=
 =?utf-8?B?NUtsRnRCZkZHMUNZK2FYMEYwdkxCUTYvOEQ2WFFlZXNTWWNtckVzbWFqYTVM?=
 =?utf-8?B?NVVFTG1iUjhtK1BCT0t4d2NicjRJbHR5OWoxU2dQcUNFK05paWtoTkoyZ3d3?=
 =?utf-8?B?SDFZK0pvNEYzOW5GN3N6Z3A3eUdYMktuajZIaTZlY2F2RWlzdEVYaGlyV1BL?=
 =?utf-8?Q?0fZkjy11gBtjOJRXjqaWo6ePR?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f7627e6-f890-4d05-f082-08dd62d92987
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2025 09:18:20.1782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X4halgYSSf65DuVHk7oQ3k3yOUx5bbKidOFnkiqbTZV0vMFQidBARvsUaMKuqJtotJTBEqeGT9U5Z7ZjPsP8Ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4888
X-OriginatorOrg: intel.com

On Wed, Feb 19, 2025 at 07:09:57PM -0600, Michael Roth wrote:
> On Mon, Feb 10, 2025 at 05:16:33PM -0800, Vishal Annapurve wrote:
> > On Wed, Dec 11, 2024 at 10:37 PM Michael Roth <michael.roth@amd.com> wrote:
> > >
> > > This patchset is also available at:
> > >
> > >   https://github.com/amdese/linux/commits/snp-prepare-thp-rfc1
> > >
> > > and is based on top of Paolo's kvm-coco-queue-2024-11 tag which includes
> > > a snapshot of his patches[1] to provide tracking of whether or not
> > > sub-pages of a huge folio need to have kvm_arch_gmem_prepare() hooks issued
> > > before guest access:
> > >
> > >   d55475f23cea KVM: gmem: track preparedness a page at a time
> > >   64b46ca6cd6d KVM: gmem: limit hole-punching to ranges within the file
> > >   17df70a5ea65 KVM: gmem: add a complete set of functions to query page preparedness
> > >   e3449f6841ef KVM: gmem: allocate private data for the gmem inode
> > >
> > >   [1] https://lore.kernel.org/lkml/20241108155056.332412-1-pbonzini@redhat.com/
> > >
> > > This series addresses some of the pending review comments for those patches
> > > (feel free to squash/rework as-needed), and implements a first real user in
> > > the form of a reworked version of Sean's original 2MB THP support for gmem.
> > >
> > 
> > Looking at the work targeted by Fuad to add in-place memory conversion
> > support via [1] and Ackerley in future to address hugetlb page
> > support, can the state tracking for preparedness be simplified as?
> > i) prepare guest memfd ranges when "first time an offset with
> > mappability = GUEST is allocated or first time an allocated offset has
> > mappability = GUEST". Some scenarios that would lead to guest memfd
> > range preparation:
> >      - Create file with default mappability to host, fallocate, convert
> >      - Create file with default mappability to Guest, guest faults on
> > private memory
> 
> Yes, this seems like a compelling approach. One aspect that still
> remains is knowing *when* the preparation has been done, so that the
> next time a private page is accessed, either to re-fault into the guest
> (e.g. because it was originally mapped 2MB and then a sub-page got
> converted to shared so the still-private pages need to get re-faulted
> in as 4K), or maybe some other path where KVM needs to grab the private
> PFN via kvm_gmem_get_pfn() but not actually read/write to it (I think
> the GHCB AP_CREATION path for bringing up APs might do this).
> 
> We could just keep re-checking the RMP table to see if the PFN was
> already set to private in the RMP table, but I think one of the design
> goals of the preparedness tracking was to have gmem itself be aware of
> this and not farm it out to platform-specific data structures/tracking.
> 
> So as a proof of concept I've been experimenting with using Fuad's
> series ([1] in your response) and adding an additional GUEST_PREPARED
> state so that it can be tracked via the same mappability xarray (or
> whatever data structure we end up using for mappability-tracking).
> In that case GUEST becomes sort of a transient state that can be set
> in advance of actual allocation/fault-time.
Hi Michael,

We are currently working on enabling 2M huge pages on TDX.
We noticed this series and hope if could also work with TDX huge pages.

While disallowing <2M page conversion is also not ideal for TDX, we also think
that it would be great if we could start with 2M and non-in-place conversion
first. In that case, is memory fragmentation caused by partial discarding a
problem for you [1]? Is page promotion a must in your initial huge page support?

Do you have any repo containing your latest POC?

Thanks
Yan

[1] https://lore.kernel.org/all/Z9PyLE%2FLCrSr2jCM@yzhao56-desk.sh.intel.com/

