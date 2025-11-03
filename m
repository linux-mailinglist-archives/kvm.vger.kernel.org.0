Return-Path: <kvm+bounces-61783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id BD2F1C2A2A8
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 07:22:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5F50B4E6D09
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 06:22:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE734293C44;
	Mon,  3 Nov 2025 06:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eylQ7PMG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC268288C08;
	Mon,  3 Nov 2025 06:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762150946; cv=fail; b=YcKVIHMfYg6Tv3BnuYpjFf1HqRKtbV0U/QzU5PWJWEtXYWlVKghhrVVuAg1BmYzP1TD/darsYMaMl8c7P8KbdtJZrkWKFfZ51f5DsHmc/TkjzngIWqzfUL6gXxdmAkNkHnFCb4SAjjt1GbkmDWFjcpX6puUAQ7i+n98aMZmTK9Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762150946; c=relaxed/simple;
	bh=JpXfou2h7CqJQ29qrU8oJBXZKH3cPDryTHIslTgCQtQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=b0JTKa2pCUllU7wzRTaJA5N/xAP2H8mHKAAoO8MyNg2mR1B9UXXXm2bh/2UkeckO8But4prVfljWVpKzPm9lJtTqwG6eVsb/cVtnVCbB6VKZI14J5VWOrOKqEbG7xuXHlzh03lem0KwmjqNo3bepSXwZxuWAMcr0Ttj46ut2088=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eylQ7PMG; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762150945; x=1793686945;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=JpXfou2h7CqJQ29qrU8oJBXZKH3cPDryTHIslTgCQtQ=;
  b=eylQ7PMGQ6TWvcsxB1HfGcM9Nu+Bap3RqKTHDJYWHDezfWA4ulue9mca
   FF7eredP97z6oxegYA7PfD0WAeeLizfq4xjxBv+qwRR8kPgR2QepHA1gE
   Iz22YSSTbeWQevOjt5CnwI7+ub7/iR8yGgpFmXCSp8Fl/6IPrTUB9SIzn
   BtQVGHu9mWNP6LvNzuBg4bqKgRie57xh3pAt6CgXdeNhyEgXdp1rxs6lB
   fLUTWUVe7jRuRItmfUumKOnpcg16WoIUpsScJ5EdPuO1aQWhBDJBymsJA
   3b0hiCV+G13Zb75wz983pakEL/qgB06k2g1rmWj1rHH7dJJSJOMIao0MA
   w==;
X-CSE-ConnectionGUID: iKHQyf90TmG0q/T3xyf7YQ==
X-CSE-MsgGUID: IJWqz+5kSlyua5Lbie3l0Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11601"; a="51790881"
X-IronPort-AV: E=Sophos;i="6.19,275,1754982000"; 
   d="scan'208";a="51790881"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2025 22:22:24 -0800
X-CSE-ConnectionGUID: ZqgPmUKhRm+Mf/aTuhjuxg==
X-CSE-MsgGUID: Cx/rThVcTrG2xpBrxcsT7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,275,1754982000"; 
   d="scan'208";a="191943413"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2025 22:22:24 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 2 Nov 2025 22:22:23 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Sun, 2 Nov 2025 22:22:23 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.46)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 2 Nov 2025 22:22:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qHFiTuqjMI1Lw9Q/uxETQDf2vs0gskotjEvKaUEgp39STdCMZvstmRiqfYO5R3IIPXFxhd324/UvLVuJcFL8NTM7fBal/HjdopJFcOJSOVZhmf9dLCqGl1YCVbLidMPpUgImzDOf6hr/eCrTnZ5pt5/N8NA8AhUTnlTjWNiW9RJ9ewRbvMcIPnJUVSK9bKa/Z+O3utPgZAydRBu0zhv6Aby1diE/w7YYvLrJZ7XS6K3JZ9ObM44ec8U573nbcFh1Ld+Mo3Ys75WT+1gn/GlCoxRqlZEVSZeEkgZ9ihzOcJz+4mnj29AOQ1DvVDGpIcN/PUsCNKUQKN4mLvOkJxxOTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=em/zTr3sD4PILjUI7EZ60pI+FQdbGcTnvvkX936GtSs=;
 b=fhuvFDWIa12zJuP4b3mKqgdhu5EaTFOwGAB1oWURFrelG0nKeV9FddlAdPxGvt9m7Z6mJfpByn++IEC6VrkarwRuWb6n/Dyw+rQ909Y0F9B+s0R8uRELKOSgpXXT6rMOvQDzsHtVuAqtioR74Z69RJPV1Q2klRMKZ4su8kv1vY7sFL8ku7i76nkoFtC+RQNcfBgJurLRj9IXjc++L/R8zFZkmXAAwsK8nlD49Bds/GFch173ITY3dQeOpHjU5O+Cm0ijKJCbMIUGFF+erdg2niBsnw7N29HQui6zJ+NQab1dHABreFvP8/NRaNZ9PSDd4lVjndYGMj8bJStXrMdU2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM6PR11MB4739.namprd11.prod.outlook.com (2603:10b6:5:2a0::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.15; Mon, 3 Nov 2025 06:22:16 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9275.015; Mon, 3 Nov 2025
 06:22:16 +0000
Date: Mon, 3 Nov 2025 14:20:18 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov"
	<kas@kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>, Xiaoyao Li
	<xiaoyao.li@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, "Hou
 Wenlong" <houwenlong.hwl@antgroup.com>
Subject: Re: [PATCH v5 1/4] KVM: TDX: Explicitly set user-return MSRs that
 *may* be clobbered by the TDX-Module
Message-ID: <aQhJol0CvT6bNCJQ@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20251030191528.3380553-1-seanjc@google.com>
 <20251030191528.3380553-2-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251030191528.3380553-2-seanjc@google.com>
X-ClientProxiedBy: KU2P306CA0043.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:3c::6) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM6PR11MB4739:EE_
X-MS-Office365-Filtering-Correlation-Id: c339e0f6-70d4-4bcd-ab96-08de1aa1557f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?H8bK2vkRiTSsj/MpdQJuFc8azaN7J8Nm7AkuwZi6FvgyExXRLlvAD690049v?=
 =?us-ascii?Q?OsnvcHu88pjEcnDYZ3ZFqZ+tRNKapUuk5mWOWLrK1vzbLOoXdzmMTkMIyl08?=
 =?us-ascii?Q?Y4tBNN+kP+3tvMuqVFB/Q14hGJcLDXILVnmv89hGLt0sqhLkqRC/0thoMjDW?=
 =?us-ascii?Q?AUDwsC4YqbRpVgMgJIQqSFaZmFXUrPlm6uF7x0SlxdL9Qfs/C1ERkF7a6p91?=
 =?us-ascii?Q?oUEYr8gZebHIozCI1vwbd0jlT38AEi61/ee57mc4cue2B67t9b75cpu0PfrJ?=
 =?us-ascii?Q?gaM4fWDttsDti2XJxVyNVr9b+yX/awKWZaI4yQNAtmB+oXJOF4+VmnbnonXm?=
 =?us-ascii?Q?lN/FEQEOKzar9fJGyWjNOjUMHe5K8G4lzQIfIRqChvYzqf8JX5lPndoYGAGl?=
 =?us-ascii?Q?NCpbTY3831JEHMOUUCs6AaqTc1JljG7HRlytvXWqiivOZY7GC8ELFyy+FpIW?=
 =?us-ascii?Q?SozyjyJRXdOeiVFtJhjnNWwPxzAKKRyewHwRIxtiI3yJXxD79JE8izHo9aTD?=
 =?us-ascii?Q?T3IHU6ynGzidRJrRNpOTN0kOn7Gd3SFVPWsU2CSqs91rk0TjJV4rdrGxxDkW?=
 =?us-ascii?Q?NMkFjtpQOuFSG8x7a4TnE+Kzwika2BiJOdsWbpjcAR1s60snzrc/R8e5Hert?=
 =?us-ascii?Q?A7tiGkXIYrUhK8y5dU4QKrSTqDoaG1CnaAPkHfHZZZ/dahqTff1bQmqi8kc1?=
 =?us-ascii?Q?4QZjhw+ouX/c6QF9OwXTK1XcwWq5HHcSWcHuOsxcr6UxPwBfqOPzQMQGBRPP?=
 =?us-ascii?Q?jbZ9vmNjT/G8xEPLpaTEyrQNLkllX8nxdaXvGXWGPs7CzCZ3kjzqLJACKbBx?=
 =?us-ascii?Q?RmAVeSKWEkc01VRVweVcbjOiZBlh4+kvlt382qf1CINakeYfSGkuKVhhpdZL?=
 =?us-ascii?Q?pIO0zTEnUVj/YGtiDRkXNg4/BkfwjWO+HZYMNPDDJS1FYOMniWk0zeTlqTJV?=
 =?us-ascii?Q?0gEPKwmxitdf0gbecAKmbQ/N6DsdDl0UlKf+Oh5W5/xXA5FrnnFidPMgDl17?=
 =?us-ascii?Q?sPJnZoEmH7VMhslyYUJ5owVB48BeTU9ItyhWr1lhGhVHnP62oaIusXAD0gDu?=
 =?us-ascii?Q?UH1Slf2u3G2V9/TyAwIC8xsJ6fUuRap+qnq9Ypmdynv9VcKVPw6WYtQpW0yn?=
 =?us-ascii?Q?dB4ksHXdM5yhsWyw75vbcUM6P0ddz3tKosfWAqvcqHSZTxZ0cD61VIzwQdkF?=
 =?us-ascii?Q?/KPXeY3KwDlulzXxxC7wWtnVwOvnA+BpnihnQmTRnqkRlJiTP2IxbftFpFTp?=
 =?us-ascii?Q?FY1+YU84PPjS8COmZ9xshxF8UreKRlyFiOQXJaF95pOj1eMFioVsDij2OxYm?=
 =?us-ascii?Q?p58waOMC66LX++N9m61AEuQkW7aYzeopDPsCp0pR4g8MY+3wqgvaSm3/ExQl?=
 =?us-ascii?Q?v++KG+JquwJq8wRxWK/H1nqmmXBB8gjvHMY3fNdRMs5EOD/97z/UBsUhD0cZ?=
 =?us-ascii?Q?yrNDdbmcEe+ugbgiPpsMSHT2XSjmf5k/?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MxpH83JXwGFvrzdLgmxQNozSPBGfd8G7y1DL/0Ewd2Hb10uGAXnVPnKta3M3?=
 =?us-ascii?Q?h5jCP136YibAEA11bs1HoK7FTA5oUD6EoCR4DpgXhefxH54ob1+m/w0GmVd3?=
 =?us-ascii?Q?Dq0f2ubdQO+nxzKsU3I4zmXJ0TirWMLRbqek7UJtVR6jWCxkW7YCuCB2paSh?=
 =?us-ascii?Q?DZ3xD9l4CHUks9DFBhZKgPnmBLc5Y8BlY0vLqJBUO3OATRbk7BrxDa1dyBkO?=
 =?us-ascii?Q?iujfVm2gnJCVhPJ/VsbD8ydKBoQsvX/oGmLOm7XbRBE6vLM1QdczZAA5LVou?=
 =?us-ascii?Q?hhA641HSLdDE/omMnbrKoI4r9C8Mxpkmf2K9r9Gz2vpX03m7EdNi1+nq1dpP?=
 =?us-ascii?Q?YF2NL2MTm54xf+0FldQMtuqDGpRVz5WzP2nDKhccgSDeFxT3L7UwG/0CcKt/?=
 =?us-ascii?Q?HlpThZaTde7hF5cEJWzQ2b47IzW12ykmDsvQLEyhosHscxpa5O5vVNL9kPCA?=
 =?us-ascii?Q?G71PBB7I9gl1ZLYPjHAn5bIg5xmGzMllcOgP/vr3aw5qqKYhoAQYEKOvrPQc?=
 =?us-ascii?Q?bqqeaUul21pI3wgTXPWpSpnAx3VNx1kc8n9PhkJmPkGl5ElL0cMjpFi0lw/l?=
 =?us-ascii?Q?Cco63DCoPp/RKJFs2YbF8jRqbkK/z1f0kiQCVNe0QZ5NJwHpSi9LPPgHEwk2?=
 =?us-ascii?Q?xd4TShYL+IyunDrihXteb4lGBIKwytQ9BF/E8ocbv4JYmshQVl1oOISwW/yF?=
 =?us-ascii?Q?UtjVjM1iHjgfsB/E1/JpPXhuGNiZG/qTnPjsREEJAm3PhIX543gR7SubBh9p?=
 =?us-ascii?Q?ESCVZBT0TM3U+P3stjIVmpFFrbxVPRfgPdNFhXjaSYodZUPIxKG81pqnmxOQ?=
 =?us-ascii?Q?GFATCGaxYSssOofe2stR0SKn7YNZiaVXg+V+o/bagwhqp5UH4hWmxBOegoe8?=
 =?us-ascii?Q?3cujD4E4xYpBiLPrUaj0ZSjkoyw6u3GOEZdf/Sa8iiAI/k5Gb3MUjXFGXej+?=
 =?us-ascii?Q?XUgzYC1L0Pj/wuWNzFRRU2VIGIig+ylsSviJXt3sr+YiZGicM2w+QF4JburB?=
 =?us-ascii?Q?fg5hOMbUMBk5J2OII3WagryHTKN+pQrCyo2h2bHbOvZ/N+5l4jc2kUeeShjH?=
 =?us-ascii?Q?OfSFSuWgihAfWDGuIdlR+/ZEnf24Y//UWB25OIMPac7s8BFT354s84xkuRU+?=
 =?us-ascii?Q?G95VU0UoMVb/3Kj6G4tpV1LpLJx1h13eJSEKhj9aHqE0Cj3YL2V9ckFLfzkc?=
 =?us-ascii?Q?fbsTqRiOBHh3EbOD+Q+jqmomH5IhMqSP0wol7aSgoLkKT+lLwfvyiKHkE2zX?=
 =?us-ascii?Q?hjBZ5E/9eEf1sHpQ7ug+mZLFqsoOZG4TuG8r/Qgmzu6Wv1fR2EdM8UmT9DhH?=
 =?us-ascii?Q?L5+VhECurwPX6Ulfka8l8d4Z8yK4KTtAAaUzwVPosrWRBvsGGskTVFgGSigk?=
 =?us-ascii?Q?yp+bzku4gpFwV9eSt/LFO1aUHETk6Hec65VTU8Oa1vhEMypnTtRrEYLojD9W?=
 =?us-ascii?Q?ydAWmaUFac1Ajlv9MnL2kTL+hmvpLLwtoZfQsVSSt+9P5sFJ6Uj/m85CVUBY?=
 =?us-ascii?Q?EOaRV93Cm1lnN2OsGGphogn7aDnL5r3qHVqoQvQpRrG0McdffXSN2EJrH8IZ?=
 =?us-ascii?Q?LFHBFMrvzJ+08WUsMvLx6+hb8vvXHsXx3LKfdryw?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c339e0f6-70d4-4bcd-ab96-08de1aa1557f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2025 06:22:16.1680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y3xpGXqt9A60Ys+ULSmpkJMBc0H/19jaHiZunfQBy+5ocMcT4r48vSUC/Kk4VDlORZlOiq1rbGrbtGd++X37nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4739
X-OriginatorOrg: intel.com

On Thu, Oct 30, 2025 at 12:15:25PM -0700, Sean Christopherson wrote:
> Set all user-return MSRs to their post-TD-exit value when preparing to run
> a TDX vCPU to ensure the value that KVM expects to be loaded after running
> the vCPU is indeed the value that's loaded in hardware.  If the TDX-Module
> doesn't actually enter the guest, i.e. doesn't do VM-Enter, then it won't
> "restore" VMM state, i.e. won't clobber user-return MSRs to their expected
> post-run values, in which case simply updating KVM's "cached" value will
> effectively corrupt the cache due to hardware still holding the original
> value.
This paragraph is confusing.

The flow for the TDX module for the user-return MSRs is:

1. Before entering guest, i.e., inside tdh_vp_enter(), 
   a) if VM-Enter is guaranteed to succeed, load MSRs with saved guest value;
   b) otherwise, do nothing and return to VMM.

2. After VMExit, before returning to VMM,
   save guest value and restore MSRs to default values.


Failure of tdh_vp_enter() (i.e., in case of 1.b), the hardware values of the
MSRs should be either host value or default value, while with
msrs->values[slot].curr being default value.

As a result, the reasoning of "hardware still holding the original value" is not
convincing, since the original value is exactly the host value.

> In theory, KVM could conditionally update the current user-return value if
> and only if tdh_vp_enter() succeeds, but in practice "success" doesn't
> guarantee the TDX-Module actually entered the guest, e.g. if the TDX-Module
> synthesizes an EPT Violation because it suspects a zero-step attack.
> 
> Force-load the expected values instead of trying to decipher whether or
> not the TDX-Module restored/clobbered MSRs, as the risk doesn't justify
> the benefits.  Effectively avoiding four WRMSRs once per run loop (even if
> the vCPU is scheduled out, user-return MSRs only need to be reloaded if
> the CPU exits to userspace or runs a non-TDX vCPU) is likely in the noise
> when amortized over all entries, given the cost of running a TDX vCPU.
> E.g. the cost of the WRMSRs is somewhere between ~300 and ~500 cycles,
> whereas the cost of a _single_ roundtrip to/from a TDX guest is thousands
> of cycles.
> 
> Fixes: e0b4f31a3c65 ("KVM: TDX: restore user ret MSRs")
> Cc: stable@vger.kernel.org
> Cc: Yan Zhao <yan.y.zhao@intel.com>
> Cc: Xiaoyao Li <xiaoyao.li@intel.com>
> Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 -
>  arch/x86/kvm/vmx/tdx.c          | 52 +++++++++++++++------------------
>  arch/x86/kvm/vmx/tdx.h          |  1 -
>  arch/x86/kvm/x86.c              |  9 ------
>  4 files changed, 23 insertions(+), 40 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 48598d017d6f..d158dfd1842e 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2378,7 +2378,6 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
>  int kvm_add_user_return_msr(u32 msr);
>  int kvm_find_user_return_msr(u32 msr);
>  int kvm_set_user_return_msr(unsigned index, u64 val, u64 mask);
> -void kvm_user_return_msr_update_cache(unsigned int index, u64 val);
>  u64 kvm_get_user_return_msr(unsigned int slot);
>  
>  static inline bool kvm_is_supported_user_return_msr(u32 msr)
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 326db9b9c567..cde91a995076 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -763,25 +763,6 @@ static bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu)
>  	return tdx_vcpu_state_details_intr_pending(vcpu_state_details);
>  }
>  
> -/*
> - * Compared to vmx_prepare_switch_to_guest(), there is not much to do
> - * as SEAMCALL/SEAMRET calls take care of most of save and restore.
> - */
> -void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
> -{
> -	struct vcpu_vt *vt = to_vt(vcpu);
> -
> -	if (vt->guest_state_loaded)
> -		return;
> -
> -	if (likely(is_64bit_mm(current->mm)))
> -		vt->msr_host_kernel_gs_base = current->thread.gsbase;
> -	else
> -		vt->msr_host_kernel_gs_base = read_msr(MSR_KERNEL_GS_BASE);
> -
> -	vt->guest_state_loaded = true;
> -}
> -
>  struct tdx_uret_msr {
>  	u32 msr;
>  	unsigned int slot;
> @@ -795,19 +776,38 @@ static struct tdx_uret_msr tdx_uret_msrs[] = {
>  	{.msr = MSR_TSC_AUX,},
>  };
>  
> -static void tdx_user_return_msr_update_cache(void)
> +void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>  {
> +	struct vcpu_vt *vt = to_vt(vcpu);
>  	int i;
>  
> +	if (vt->guest_state_loaded)
> +		return;
> +
> +	if (likely(is_64bit_mm(current->mm)))
> +		vt->msr_host_kernel_gs_base = current->thread.gsbase;
> +	else
> +		vt->msr_host_kernel_gs_base = read_msr(MSR_KERNEL_GS_BASE);
> +
> +	vt->guest_state_loaded = true;
> +
> +	/*
> +	 * Explicitly set user-return MSRs that are clobbered by the TDX-Module
> +	 * if VP.ENTER succeeds, i.e. on TD-Exit, with the values that would be
> +	 * written by the TDX-Module.  Don't rely on the TDX-Module to actually
> +	 * clobber the MSRs, as the contract is poorly defined and not upheld.
> +	 * E.g. the TDX-Module will synthesize an EPT Violation without doing
> +	 * VM-Enter if it suspects a zero-step attack, and never "restore" VMM
> +	 * state.
> +	 */
>  	for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++)
> -		kvm_user_return_msr_update_cache(tdx_uret_msrs[i].slot,
> -						 tdx_uret_msrs[i].defval);
> +		kvm_set_user_return_msr(tdx_uret_msrs[i].slot,
> +					tdx_uret_msrs[i].defval, -1ull);
>  }
>  
>  static void tdx_prepare_switch_to_host(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vt *vt = to_vt(vcpu);
> -	struct vcpu_tdx *tdx = to_tdx(vcpu);
>  
>  	if (!vt->guest_state_loaded)
>  		return;
> @@ -815,11 +815,6 @@ static void tdx_prepare_switch_to_host(struct kvm_vcpu *vcpu)
>  	++vcpu->stat.host_state_reload;
>  	wrmsrl(MSR_KERNEL_GS_BASE, vt->msr_host_kernel_gs_base);
>  
> -	if (tdx->guest_entered) {
> -		tdx_user_return_msr_update_cache();
> -		tdx->guest_entered = false;
> -	}
> -
>  	vt->guest_state_loaded = false;
>  }
>  
> @@ -1059,7 +1054,6 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
>  		update_debugctlmsr(vcpu->arch.host_debugctl);
>  
>  	tdx_load_host_xsave_state(vcpu);
> -	tdx->guest_entered = true;
>  
>  	vcpu->arch.regs_avail &= TDX_REGS_AVAIL_SET;
>  
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index ca39a9391db1..7f258870dc41 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -67,7 +67,6 @@ struct vcpu_tdx {
>  	u64 vp_enter_ret;
>  
>  	enum vcpu_tdx_state state;
> -	bool guest_entered;
>  
>  	u64 map_gpa_next;
>  	u64 map_gpa_end;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b4b5d2d09634..639589af7cbe 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -681,15 +681,6 @@ int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
>  }
>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_set_user_return_msr);
>  
> -void kvm_user_return_msr_update_cache(unsigned int slot, u64 value)
> -{
> -	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
> -
> -	msrs->values[slot].curr = value;
> -	kvm_user_return_register_notifier(msrs);
> -}
> -EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_user_return_msr_update_cache);
> -
>  u64 kvm_get_user_return_msr(unsigned int slot)
>  {
>  	return this_cpu_ptr(user_return_msrs)->values[slot].curr;
> -- 
> 2.51.1.930.gacf6e81ea2-goog
> 

