Return-Path: <kvm+bounces-59464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 54D45BB7519
	for <lists+kvm@lfdr.de>; Fri, 03 Oct 2025 17:30:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F3F8E4E6B69
	for <lists+kvm@lfdr.de>; Fri,  3 Oct 2025 15:30:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64E1F23B618;
	Fri,  3 Oct 2025 15:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l6RQmq4r"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEBB4285058;
	Fri,  3 Oct 2025 15:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759505398; cv=fail; b=WwFpyQfRjQ9Cyu19zSvcOTZwTLlq3nePiiZuS6hxqilGJyZCNkASH97mgATlfXYqZ2LqGF4ajt1WOepnI+zmm0oH1miSI6RFZmoEILI/wQyabYjHYz6QTd+YyTNoUi3ZWKz0nBHRd2Ncl2uO6LRT8RhxuUAAo7abYVLdemZx0hw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759505398; c=relaxed/simple;
	bh=eS2TE6SEj41KYL5yAQp8h+qw4n3HWqdmTb7fvIhOvs4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=iL7DL/NUab2Ct17MnNANFhMyxOvCc3hiH5w9YAAT3Ty6gWd5mcF5uHT6HKCTlPgBrbNwr7ufGMFYmyHWTTyfqLMaSgQkJJlxDvuGWigAfxugpUM7UYe5zKpyWfxQU3ZHkcY7o+DfgMoxtu+c7FF6T1nYe9KC050RXgYJCmSE8+E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l6RQmq4r; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759505396; x=1791041396;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=eS2TE6SEj41KYL5yAQp8h+qw4n3HWqdmTb7fvIhOvs4=;
  b=l6RQmq4rZdkG32AoX/rUgO6LAucaJA/WKOWB2HvS7bzHduQIhlvsVghY
   REEYf5JvmKhyr1/p/7HzOzbp1Wa9E0vsrZJBMTv0jit2NzhUaqf2iP9vq
   W+Fvk41/1vtxYgMArERv6bo9hsqEJUord0P16F1A0s/KXfIEQGgGof2cT
   cyrx+bzJzw+DMK5sYokXIjMsW9cph5gcgb4NpyJqHatDxPZsSq5i/u+xW
   KRlwOVvSFwXjqiNJbfPAm/a3EKMqmzw8bW3wLqwP4WvVwk8GfUhU1dQps
   rbHWMJzlRCYEEnJKUNYdcfagalQD2LrPhXLSYhKCRFIOHFh/nm7xbqkyg
   g==;
X-CSE-ConnectionGUID: n8qYYz5dRcuES1kRAShIEA==
X-CSE-MsgGUID: lcCSs2AYTMKhAiMGCg+nvQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11571"; a="79218325"
X-IronPort-AV: E=Sophos;i="6.18,312,1751266800"; 
   d="scan'208";a="79218325"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 08:29:56 -0700
X-CSE-ConnectionGUID: l4Ssn35rQFSimRzi99ZVLw==
X-CSE-MsgGUID: XPiYw6+JRb+dTR/Vdezkpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,312,1751266800"; 
   d="scan'208";a="183598773"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 08:29:56 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 08:29:55 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 3 Oct 2025 08:29:55 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.71) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 08:29:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aYatm6UozxBXIX1t+AB4Py1CXJkf+HMmtY0HZ6IYAu0W+P2mMLRkKMMl5QG8ZW50zkpSQt4fCAhV5THqcFZgIZjmcje+fay9q1AmEJDwK49O8WApgPgzycqkHpDR+OE5g3RNR7b0iDTG1oTiip3P/ZJp7qNUD+E6UkvnykFlmvz6RrWVujpmd9OvITP+2gtOFMmjbrYf8lsVhy3248k96KZ7LT6+IEFJbwB6DD7M381CegqPNTIhpi3cc2Cv9l3NK398ZgFiGCaLAJbCyqy+7F2Hdh7kMCmHkBq2HajtBRlTrdFBJ+gGUJ5iBPBIxKXn+cNV7kL6snOzZHTmsR1NBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dFkYE1YCdvCOO3EVO7ZpzJC+sgK1ynhN5q6Px7iWMgI=;
 b=UlsOJ0MLptPWxlZkRG838H/OD6vdXeWVoenIHPXAw2dSa/sxUKovzdPDD/Ry20FgNDFsnfReaZqzrziu25KuxvufE0S/bv+cdKJLeV7D8zTemjQNtfkOH5uHR+z2PVKKCy9xTgUA/Qz/cVMWdNXPLilw31VyIerlExcz3fBAqpRCE1SROodHzN/N3xUG2VJW+Rw7rHo28E+VkUYiEuIbKWiN4Grwl1wgMbB+okqWKjKSYboD4dtPOBTyNAi0ZUvz8+Gz8AKaRGEmU4sO/x8KDUlxFPS+NbPt1lGdJr5+Z//WLvRQZNka2vOFXSae74DFhvgncUXW3UvfzWABrb0gzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA4PR11MB9131.namprd11.prod.outlook.com (2603:10b6:208:55c::11)
 by LV4PR11MB9514.namprd11.prod.outlook.com (2603:10b6:408:2e0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Fri, 3 Oct
 2025 15:29:52 +0000
Received: from IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2]) by IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2%5]) with mapi id 15.20.9115.020; Fri, 3 Oct 2025
 15:29:52 +0000
Date: Fri, 3 Oct 2025 10:31:57 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Sean Christopherson <seanjc@google.com>, Ira Weiny <ira.weiny@intel.com>
CC: Vishal Annapurve <vannapurve@google.com>, Yan Zhao <yan.y.zhao@intel.com>,
	Michael Roth <michael.roth@amd.com>, <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kai.huang@intel.com>,
	<adrian.hunter@intel.com>, <reinette.chatre@intel.com>,
	<xiaoyao.li@intel.com>, <tony.lindgren@intel.com>,
	<binbin.wu@linux.intel.com>, <dmatlack@google.com>,
	<isaku.yamahata@intel.com>, <david@redhat.com>, <ackerleytng@google.com>,
	<tabba@google.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH] KVM: TDX: Decouple TDX init mem region from
 kvm_gmem_populate()
Message-ID: <68dfec6db50a5_2a45d629486@iweiny-mobl.notmuch>
References: <aIdHdCzhrXtwVqAO@yzhao56-desk.sh.intel.com>
 <CAGtprH-xGHGfieOCV2xJen+GG66rVrpFw_s9jdWABuLQ2hos5A@mail.gmail.com>
 <aIgl7pl5ZiEJKpwk@yzhao56-desk.sh.intel.com>
 <6888f7e4129b9_ec573294fa@iweiny-mobl.notmuch>
 <aJFOt64k2EFjaufd@google.com>
 <CAGtprH9ELoYmwA+brSx-kWH5qSK==u8huW=4otEZ5evu_GTvtQ@mail.gmail.com>
 <aJJimk8FnfnYaZ2j@google.com>
 <CAGtprH9JifhhmTdseXLi9ax_imnY5b=K_+_bhkTXKSaW8VMFRQ@mail.gmail.com>
 <68dee81d79199_296d74294b9@iweiny-mobl.notmuch>
 <aN8Vn9iD7OMzspp5@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aN8Vn9iD7OMzspp5@google.com>
X-ClientProxiedBy: MW4PR03CA0242.namprd03.prod.outlook.com
 (2603:10b6:303:b4::7) To IA4PR11MB9131.namprd11.prod.outlook.com
 (2603:10b6:208:55c::11)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR11MB9131:EE_|LV4PR11MB9514:EE_
X-MS-Office365-Filtering-Correlation-Id: 882879e6-51f9-4a15-e142-08de0291b29c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?hhSLzc4pS00WYM6c8b66oQBpNIqveZ3tAA63Yjh6qnqMpRRbvl8I8nu84UEa?=
 =?us-ascii?Q?ArWFDH/onOZ0W4ONGp+3rc0lawY0BAI1xn9IS6j8DyaeDTtdwqZZS522j74A?=
 =?us-ascii?Q?rfRflSN/vq3yGGXPdl4VWVCv+QTRcqxdKcSWvLhmgXxUAV09+xB3s3Q9kQyZ?=
 =?us-ascii?Q?mnDaHhmgAEWDyzHpAXPO/PiFoOH0FL16AKI5DAmgkcFMMEef/ZbfbR+U7AHy?=
 =?us-ascii?Q?ohf5hniTVa7WIpWIgeBFPrD0v9HDxXWtozdOgN4DKvwGVfYlllBU9wA9RKqs?=
 =?us-ascii?Q?SJD7q7OeLy5Fx2Z63xs9x2KpHIPsStcV4mY2XRnbc2rW5itPinhCMHoOHcYe?=
 =?us-ascii?Q?pW+DnLTS8Cahhi8RB2IvvcGwK9skwIUUIg1bG6GX+oa4HuJAB/KNLgc3aLor?=
 =?us-ascii?Q?XXDWZAgpg04aAM4RUG/jU0nhix/86Lfo0QmfDUsYdk0nj2lLf/ccQt7Qh0Wf?=
 =?us-ascii?Q?/MkUWd0UQ06+EX4J2CQtp4lj4uRJlNW4rHIhvaIDMakfrl/tCgxeJHtzfn99?=
 =?us-ascii?Q?eFb1lxCyn9lUhM6mrIAPgWw5a9TcvWd1KtPSiqWbB5Yk/pXVIAIF4XWgW5ve?=
 =?us-ascii?Q?E7KaufQa+CZfJ5qlisTT/B87JtOs5rqWq4T32/3rQABkZTntxSoHDZiH3Vqo?=
 =?us-ascii?Q?dFBjrq2GbQqBFWHL15vQvn7sYp4/vRl+HEPgqFMOuNJS2K/p913n0Y7akqi1?=
 =?us-ascii?Q?7VEXlJrsLbOUcd4uuJa9d7IRFWEnPgjR1LD4bTdqHn+yBUYOpuql3kmywCm1?=
 =?us-ascii?Q?e55d2OiQDV5913uFUwpPE7fXCaNUyNCmNjGZe1yYNriU4n5zhPUS+FRqbMXP?=
 =?us-ascii?Q?SH3tw3/jBvbBoqrKf6Cj3512EMVJVRsF+2pVgLVdZzDWN3dW6ygtHZdV7xmo?=
 =?us-ascii?Q?UqWXuARiKFck/xPFB8B2oLv5uBNzNw0qPJcThHtIXyxx6uqPaxdkZKJzBODE?=
 =?us-ascii?Q?eMimIosK2G/3yOtTFt5FEhUlSwbaHQyzELjIuNEzzOrR+UW1zq5xyYN33/vx?=
 =?us-ascii?Q?tYpIpqcBiBzslc+2LNE3OK0nLtFjy76DlB7IFbtNoEhWaQYuH1ueV6FoYzal?=
 =?us-ascii?Q?taV+LHaYFCVjwYr7sHDTjGgEDK0N4nIAUDnzrSswYLp9DsNxLkFSfsFS3PbQ?=
 =?us-ascii?Q?VUQg+OM8H7lHIwVCumccvYGpo2oB7Vvjni0/Az8ckD21ryAWudfr1s89BwF2?=
 =?us-ascii?Q?pg9vwqBptnTNkAKySZmXGRd+4KATez3aQVILeFnGUvfZCEPa+3VurhHFX9vK?=
 =?us-ascii?Q?NNwNbdRK1jcjBWyvNZ9Hu9ofjl2vlnS6n2nrDLNPfke/0+r1eox1vn+wkHry?=
 =?us-ascii?Q?/VnafHk3usCwhRPHdpGjiubDkFjlnmZ524Xbz1C0A9eY9FcOV9wuTBUeDNDu?=
 =?us-ascii?Q?4D6E/w83JzfVWTxfe6f2slZRoTIFde69g3i2UUHHN7err001z4lx8KKU1XTv?=
 =?us-ascii?Q?UhiPlZ46dAKPINRVvgivMAx9z0e69XSV4UGLWw0QxykaMnY3LUJTBw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR11MB9131.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qW4gDHGsRDs+iViTk+BR9xCQ4OvsNUkY1VtXo/5y7ku3ZgX8miBRffDdzGrX?=
 =?us-ascii?Q?r+EHbmin+wPgKZRO9d7H3uhL6WwCuy2yHjAcjhCJhyIN4J/OkCVwcmnD5H9N?=
 =?us-ascii?Q?YsILAQ7sQfbOsULMeoRuqUekKBVBFyMC7eKD1Y+nCWMgU+jddxivYpZEElzn?=
 =?us-ascii?Q?R4L6ksGHocE/CKZhgIWyny469dMbJEA7kCjzJzgImJZ5N+FZGty5UIgUVpni?=
 =?us-ascii?Q?F5nLijVp2pZ34G/pBoAfdDsJZ9yJ0Ycj3LcAaDOTPCSwec+LfmIoMMm5p25q?=
 =?us-ascii?Q?GW6odE2zOYm6Njy/O9Az3sauHjYiQOZiCdLg6tY2hWRtpLVJ5wFXseYwbM+a?=
 =?us-ascii?Q?a9d0EitXZOgHozlXhAB9mQja+xXb+dsfEa0gUo7FlQh5YQwQ3V9pAZV/gkcu?=
 =?us-ascii?Q?39rG4A8Bdz/T7D2maqMYgXLeO69wAe6Mf5ZkddhKPb6FIHCq0NRLrlEuUtRe?=
 =?us-ascii?Q?tjFZFnjtsFrZyJAfRdh/C1/0G0y/TnZfbEWuy4+tiSzxcKEqV+J1/CddifNz?=
 =?us-ascii?Q?jqaF2PQhnxsO+sK7RLYp7edDm1heOzbVrqll621DFS9IGRdA67HF3IUVAAtU?=
 =?us-ascii?Q?JXKCN6DpJ9BiYx0rgIZs0GwG2ib6D2Y2HjT15q7ZKCyqco9lSBR08117a80h?=
 =?us-ascii?Q?BtkmcBAUzkfY1+X9vOHPZecSlzEWZ2WjgTer/OqpT6OB5hlkcP1TTBf8lFLV?=
 =?us-ascii?Q?fkTI5YyhUeLJdbTSE49XXpWAFD4jIe4jEYBWLCTyhWe/XZliNIDLxU/0E6j0?=
 =?us-ascii?Q?XtZ0NNnY94AIAKHDxp/dICsfFIxJ7q2vMI8stzW0CtVpkC1os7pvAabIBiOb?=
 =?us-ascii?Q?tE+2cHHogGfFWOvfvYtIj8tJ8lSemXWCkVAs0PLCRTAdYUSddazdSNh6D8mC?=
 =?us-ascii?Q?XfNnAVHXY8Bvrfc4402nwe7sVVIGMEViVkb7FRps6Ro3rb6YoVSroMO7GXQx?=
 =?us-ascii?Q?PoujX5xIWRKzzH8D/1cyUk5YVqQYxs76yyGbahuULyawmiTGamAr8FXdIy3o?=
 =?us-ascii?Q?F7ZoX5SI6/GBMkkjN1fGPKYzaA0X35YKaEa+w5fOMFMb+/pjIjGHi6SIo6kJ?=
 =?us-ascii?Q?xJ5WU6BbuC4mMhZAfA8kuaGzu4ZWVhyayVkyIA4YWRm1UMiCwHD4BUd0G2Xm?=
 =?us-ascii?Q?sPUUN7u5SzrTxCxSu3vj7fyy+LbS7hcnPWXKXoD0Qt+/5eCOeibUxpGsJEE1?=
 =?us-ascii?Q?pzE57f65d/HfEahuw063LPCHfNydjB5OeLN5Qgtoh5z8dpeboQeNDYA2JXDC?=
 =?us-ascii?Q?5q07a/WOPMxU4rkmgEcjKhX1VSK8B1fPn+QVulG6FM5HvZ1HV8F7HRjDlX1w?=
 =?us-ascii?Q?06Lrfc0e2l8sHaHo8K63Ye3RODohUC3J9wGBODATBfKM4tIRUQZPQh0IOl81?=
 =?us-ascii?Q?hJ4nE46MQUfv+hxkPKt2ebO5efDL9Skk2juDqvX4GkTjdwD/wRhjGcGUPwQJ?=
 =?us-ascii?Q?5d50F9kAhrYwTmLGuF3Lu59Fg5rGFOSTLU4qxJLvZHv4m/gpnZj326q9gCRL?=
 =?us-ascii?Q?FH3lgoS6LLIUop0wYDZeqm6k0ym4kXSV4rJAR7HvXqHcm65sJKltYsOvS0th?=
 =?us-ascii?Q?+kkw3vxvOjiBrGu+qvDkS2nDgpWslTiXvs+9LYLl?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 882879e6-51f9-4a15-e142-08de0291b29c
X-MS-Exchange-CrossTenant-AuthSource: IA4PR11MB9131.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2025 15:29:52.5473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o899k5QtiFWhwUeA9OxOqCjqCTQEqWsKzVbzVLwsOwXleqoCcpinzBZRnaMymiAajhiB309ZZTjleX2UKkvEnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV4PR11MB9514
X-OriginatorOrg: intel.com

Sean Christopherson wrote:

[snip]

> > 
> > Sean,
> > 
> > Where did this thread land?  Was there a follow on series which came out
> > of this?  I thought you sent a patch with the suggestions in this thread
> > but I can't find it.
> 
> Are you referring to "KVM: x86/mmu: TDX post-populate cleanups"[*]?

Yep.

> If so, my
> goal is to send v3 next week.

Thanks,
Ira

> If you're talking about something else, then no idea :-)
> 
> [*] https://lore.kernel.org/all/20250829000618.351013-1-seanjc@google.com

