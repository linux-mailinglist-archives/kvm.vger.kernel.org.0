Return-Path: <kvm+bounces-48266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D829DACC118
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 09:17:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4B1D1675FF
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 07:17:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0D9B2690EB;
	Tue,  3 Jun 2025 07:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l5Zq842k"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B88268FFF;
	Tue,  3 Jun 2025 07:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748935060; cv=fail; b=WZCGq5eq8hyMkeOOP07YEFLX32ZKhsYnZ3nbDM4OsF3TVaz4uZfWlnACxCy0D1qedLDKVa10PD+bFFJcIs+FmoOniQIse+3EXEDp+FDrPW4ksJS62AtmYD3OX9zwi7rCtgyXFn0alzRWdOiiKTgfWsDQktojuhwYMJiGD/J+AsQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748935060; c=relaxed/simple;
	bh=b8q4x2SCZKgKtbMnWXe3RyHwKSMc0Dh4AomFpZtGV9c=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tQ4sNkadi07ZbgeRBed0I406yT7Xsx4xIY1DE1DnP4O/HZbAB7bDhDY5jSNdy6vk+pIRtDVCLpFGdTlp8Atvl8isAqGG3Tbyw3Z6peqorI48+0ioLDDnIkpsLVy85Po0LlSRUwpDNqTFBs7lIX+RoWn8p7nYSKCmCs4QuLUJZ/c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l5Zq842k; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748935058; x=1780471058;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=b8q4x2SCZKgKtbMnWXe3RyHwKSMc0Dh4AomFpZtGV9c=;
  b=l5Zq842karUu0tf03CSbhDa00/dhOkxtnscVsLdLmOpoZgZGkDnmWCUK
   Vo00ob/MVgFrEdAZZxnsoudsRNOsbZwjuBurhM2rZs1JHbxN+3lmz2uh+
   OowKQlkKyft58YmQJ2PkqWcfK4A8GUN7Iool5OAbuxHaJnLcbUFe08eLh
   5ufVbIACIqTnNYSEVJ1rkCJAXqnd3lXbAiEPkZNglZPafISTQU7uXc1XM
   Kt8Q47HS4H5ui7lCc01KhZaOMK40oAv9KBQlm+wfCqK0jbFsQNWn30a6N
   pp+yVw1U3lZ6+/nyKfIC1F1vS8oYqlsVjftWcNp19OLVIXduOpHJuCOs8
   A==;
X-CSE-ConnectionGUID: lAbE2rzqQoKytVM+fdX/tA==
X-CSE-MsgGUID: XHP6U09nTlSXmfuJjbOinQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11451"; a="50084317"
X-IronPort-AV: E=Sophos;i="6.16,205,1744095600"; 
   d="scan'208";a="50084317"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 00:17:38 -0700
X-CSE-ConnectionGUID: K9nVC9/oRqemEBDs342iTw==
X-CSE-MsgGUID: KDmTXRucR8G5A82JyPTFJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,205,1744095600"; 
   d="scan'208";a="149934515"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 00:17:37 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 00:17:37 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 3 Jun 2025 00:17:37 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.42) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 00:17:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yd3wo0wbnqj17tO49pwI1qPTLZFeYgyC77DA/D4tolAxQnHG/8ZskhsKwQbJ/DyUMf7wwmSY+p7Z/qy8HvN+seXDrqDhagNy5mnuk0aBuso6O1Np/3enmtMJ38weQ5xFZj8xmMyVg2M0pb/ClR//C0Gg1iOCczyYpdTaeRERBOvpxqBrSSQDM9gx48ehC3mbkQ8XvHYBVZCxTehyJLngsQ1Z2TXqI7O+ZpJcBGrN7QIrmS+1i1wa/vk0sD0CJ6u15SP5+oldsgbcGn7tDOcqWrMWFPx6hkLhLC7I41LwNsk32BZva/1DKfb/kXVPG9TjhXFmu61w6xyLJSTfoEgEKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9dmeUgoIcabX8uA8O6Aeh6sV9U8VcDS7dBSPDTNkeGI=;
 b=rtmyuW+3yXp0I8xoDxnMf4FXT/DRkByHidRQeSltm5X8LbVbnVpPnc2tDr2WFlOGCqNGOhp0CAgqQlo/eGC+WT0q/hiWaHGmWgsv1bakcMiJJLjWmdrEi2/7u9RV6Eb/fAomT/4PxtyrmCW/+ktIjhldmUZBxJknGUeUJIBi6iQZKbSAhsns1OezV5yygKDf7diXg6x1RWaS2aeskusYCoJg+vvmZqfN4VTh3Jk29WW/5/aT/fquGNDGhvkeus0Hrp2O25Adh4JGqSGsdPSWjtpNNcu4kYZXMjxpdyZvUMNxc696170cdnpiVTJTDsmvJjBpAdD6q+NN/ejJ437U1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA0PR11MB7953.namprd11.prod.outlook.com (2603:10b6:208:40d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.33; Tue, 3 Jun
 2025 07:17:34 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8769.031; Tue, 3 Jun 2025
 07:17:34 +0000
Date: Tue, 3 Jun 2025 15:17:25 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Xin Li
	<xin@zytor.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: Re: [PATCH 01/28] KVM: SVM: Don't BUG if setting up the MSR
 intercept bitmaps fails
Message-ID: <aD6hhTABOQstdlBL@intel.com>
References: <20250529234013.3826933-1-seanjc@google.com>
 <20250529234013.3826933-2-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250529234013.3826933-2-seanjc@google.com>
X-ClientProxiedBy: SI1PR02CA0034.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::10) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA0PR11MB7953:EE_
X-MS-Office365-Filtering-Correlation-Id: b762fc51-94a8-439f-ae05-08dda26eb619
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?bZahgJkHGpLEG6o+eUouUBgBk0i/YYKqvwEUxC+gKJ9v90enoecVtdSbomFs?=
 =?us-ascii?Q?qBHYFHHyAPidLn04TK7lY6OmItzg5QNTAZbL3XRgU9/D8wr7+AfyOGP0dB/y?=
 =?us-ascii?Q?963IBefWuR/uaRbPttWT+riEbdKECr/rrPoFk5Fc405Ywxw5sXPl0R2lghYs?=
 =?us-ascii?Q?9Y8hYd5JgSc3vc0iXeoAPgIvGoZ7TA4hcUq40rWgQjvzhzBYAgCNnCfK5V18?=
 =?us-ascii?Q?TnjCDb206XhOYOYo83v4XkNxxDHsGN52YmwcSg4asglX+mCtltkWiepQW7BK?=
 =?us-ascii?Q?qKM4IvyLMJV10lA5CCRtwn9HBZddGU8m64lSZjGHjH3PTNvZ/kCXUYFSavNV?=
 =?us-ascii?Q?UJorYc2BAJydZJzR6cOslUJgLS8k2Lj4iNPb82AJwixTnpO0mVFd81jm8Fjo?=
 =?us-ascii?Q?/NeaaVj6JTZHqJdaRHcHAHsBUXb6Dov6jOwc5sCoJPTPXzzApH8+3fa+pcX7?=
 =?us-ascii?Q?BL8yjvxHiQpF7hvUA3lk5RvvmrZ5RSG4r24WQe7vCkpIzymbe4x2UivRN2EI?=
 =?us-ascii?Q?B2BXn3zGXqQLivnL+fnQFz/F4cLuWqKOnhHqxXStlpe2QE1tgSDrs3tiC0EX?=
 =?us-ascii?Q?r5dlwN1QtSnWpthxTonIyDgzGF21JI1ZI3fWhGjsEENi59N2q30FXZvY8zv7?=
 =?us-ascii?Q?SQwUs87Vn11ESWZrtLuQTs5HZlxBJTdUY3aVn1vuywIuzVTJnW0BH/yiGhn5?=
 =?us-ascii?Q?KAJQHBSSCliLcZ+bg0eonWe+RSfKGbm6RvGAgvISmKCynUNj63OhOTK8x7ej?=
 =?us-ascii?Q?UjPS5zDMYO50796mlCs19EH1CCm4qsdvKi2PqMEZXFE0jwa1p0aJiq+DuwZN?=
 =?us-ascii?Q?iBukhlQANPNF6hvHGBhJoNGM/BUAzDpI75S+ma3+iLRXXzR0kIGFT0btHiUt?=
 =?us-ascii?Q?l3hcGgcq4xgrfSqIHkRkMHl2u0NiFck7BfILsZ/l8jdcwLvu5zcNhx5TWJ7e?=
 =?us-ascii?Q?Y8QaMku3VLX2fwtO1MKl31rzEBb0HdoBmueaU0SY4yU9me7Py/lIUCJ6XtNK?=
 =?us-ascii?Q?2ot8FzPlvqPvzWSKFw/ji8iHQusW8h7ZFWB2Ymu1PEo6uNeyL5hveQ4Opi5m?=
 =?us-ascii?Q?b+HvTc55wXTBsFub1YQgIAwf7zuHcXRSQJW3zmfW8+07UYpberzMDMnlx02N?=
 =?us-ascii?Q?tIdZDRem4cZfw5qB7C1akqazW0euaV1Ck6TEokMlmo85ZHLdM4uQni3WFcx1?=
 =?us-ascii?Q?9Xm6O6WOD1Fb6HxlZs7QfCJk1OfqqmRgU/iIDh+/S8YJlqgajn8FM3R/Y8ka?=
 =?us-ascii?Q?J+9I8eSJTrXqwaRDy70O2eqd166VsiPwV84ccm21cwyqemTO7uWFtQoSD/yk?=
 =?us-ascii?Q?h3PGTPy1MfoX+bt2EBfAmC+3gxLJl/mhivc8K22/yGq4RcyUEKs7+FQ5/xaE?=
 =?us-ascii?Q?UB4Q9M1GxM2vgesRa8JBycWccWzg95y2tN9rfNiMWyM73ClJp5LAsLNtgHec?=
 =?us-ascii?Q?c7H8fEmQCaY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wWNCEpKE63uUPsCfcRhBW3p3kgEYq1PWbVExGyGKgEoVSAKS8xLdx5AVsDpk?=
 =?us-ascii?Q?RKa4Wx2iQKPHkV13Nw0zYh1FzKLKYAtX/cUqG76QRdnftzAKIWUF3d8zdCIZ?=
 =?us-ascii?Q?rcEjTHwD7P2GM8C2FK01pYdw21LGArRH7doCdE6RLrEkHIP6Fm7K+YHqYExn?=
 =?us-ascii?Q?aLg0SWyFWDgJpBrFQQSgkE5NTbRBB7V/miAYLthlOhyBhCZ8/mLOCDrictkv?=
 =?us-ascii?Q?ptmc8X5AA6BuRQl1P94Ji3qWuTs/w8xSLU9Ssfc9bdzi/HFftibM+g1b5YE8?=
 =?us-ascii?Q?FxllNgk0CoUq1RfZEfr9bsQX36prMzg6gPBDZIaYKY22oqGJU3K27/WLF6/S?=
 =?us-ascii?Q?yFBmjt3+eG8VischUb83RLZhVU9nNmFbvmPaV3R7bMSaCiOlUooPsopmHng6?=
 =?us-ascii?Q?0dB1HyPI1K8Lv4jshe9/EWyESy7ZqbdT+K9u5eawDr5pKH9/BCkTNy2QlIPQ?=
 =?us-ascii?Q?H9P17AODKvpbprjkM5zPlA89BbCF7MXleyRD3of1E7wPRlWWdXch7Imm9xC6?=
 =?us-ascii?Q?qhl+IPOY92fB2E40qTKHtyiJEZ34WQuEYaZ3dgzCvhMeKB0awPrmH2Cs1SOb?=
 =?us-ascii?Q?/KUxjWRBw1l7dqSiyswrwQoqp0jYsvf6p4O57ZFqcKtQrx80XsrduMiqlHvS?=
 =?us-ascii?Q?ygfz/IXlzZMZBdRyQwEilOBZhH7DKxoAG93tveSSPjq3rOJBI2jEp6XuHZD4?=
 =?us-ascii?Q?2oyqxudPHWZ0TCj8iXbZsA31e4oqGtxsWSOgLj6eTPt8r48fxuWYZxxxZ5t2?=
 =?us-ascii?Q?8ZrVU9O87c6gVZYRec8fGAh8EDyt9kNW2L3K4afYeuZtoN2fQJ5USuk2YJRN?=
 =?us-ascii?Q?k6z/GloVJnbxkzAME/OLMXYSqZOVbLsJF/CR909hXnUhprRo3SlumEcog9XB?=
 =?us-ascii?Q?9neOpftWhxpnAhS3pAVCwX/f+IhIgkfDBySi3aqikwmzbhsHngKFnI6G6VYd?=
 =?us-ascii?Q?No7+GQ5GhjkSohr0jqRe6OCS5n3uc0HvNUwB7/j+7hERojge2luSxFi6JQYE?=
 =?us-ascii?Q?O7UbZlHOWwdPejsRcQxbQVfKkg5uXSo6dxAuNB4oKZUqBNGHmTTbD+9GuM+M?=
 =?us-ascii?Q?bUl8YoOgUlx2hdxWxib/p735Sy5sKaMJ713uTJ2K4JuMvVV2JS9372tg+AIz?=
 =?us-ascii?Q?CUWjvSh35FSndiU28M4DT9aXbK0kkE1rYeTl0wy6tcKF/CNOXWlN1qL50ps9?=
 =?us-ascii?Q?+uEjv2PcQloDHlWeq1su2wah3ETzr4FJMDlhqGCSfuT3Ds7MR3zO/7NgZtVJ?=
 =?us-ascii?Q?rvBAuL8P7lz0JvPsQ+DNrfZjjcQviP83YiC5MdYRaQgIOtSdEGhD9rIWQnMF?=
 =?us-ascii?Q?jb7wGacIzzZ30wc2Kuaw5eHDroG1g479ZG5R+5rzK+kUiqVwVgZXVi9uJcFG?=
 =?us-ascii?Q?ijh1p14yMSfAqWVGun0pcGPSo9hWLo8evCG9QHUmehRC3edPVFu1XhBgjEgy?=
 =?us-ascii?Q?wLZlaOEZCyUIe5FKs8j0GSJ5DIvmQBmuMH258DWnxSCjMWDKzhCLtyUr+BVq?=
 =?us-ascii?Q?HzuU2IrikNWu6fK3N1Oj+RBkE0G0ssixaEOcR0hrRSxMP2oop2T11YMLCOsV?=
 =?us-ascii?Q?6znVP4KI3FLuzx7QjnFxhROfBIded50LairT1x4y?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b762fc51-94a8-439f-ae05-08dda26eb619
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2025 07:17:34.3480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OhNzCAi+oD1bQuTTvRSYRUhASaq5wpuXorD9TTllZY1hdAG5t+Xr8PsJS6ZdM99UMgStK0XbJwltGYrQIhPr+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7953
X-OriginatorOrg: intel.com

On Thu, May 29, 2025 at 04:39:46PM -0700, Sean Christopherson wrote:
>WARN and reject module loading if there is a problem with KVM's MSR
>interception bitmaps.  Panicking the host in this situation is inexcusable
>since it is trivially easy to propagate the error up the stack.
>
>Signed-off-by: Sean Christopherson <seanjc@google.com>
>---
> arch/x86/kvm/svm/svm.c | 27 +++++++++++++++------------
> 1 file changed, 15 insertions(+), 12 deletions(-)
>
>diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>index 0ad1a6d4fb6d..bd75ff8e4f20 100644
>--- a/arch/x86/kvm/svm/svm.c
>+++ b/arch/x86/kvm/svm/svm.c
>@@ -945,7 +945,7 @@ static void svm_msr_filter_changed(struct kvm_vcpu *vcpu)
> 	}
> }
> 
>-static void add_msr_offset(u32 offset)
>+static int add_msr_offset(u32 offset)
> {
> 	int i;
> 
>@@ -953,7 +953,7 @@ static void add_msr_offset(u32 offset)
> 
> 		/* Offset already in list? */
> 		if (msrpm_offsets[i] == offset)
>-			return;
>+			return 0;
> 
> 		/* Slot used by another offset? */
> 		if (msrpm_offsets[i] != MSR_INVALID)
>@@ -962,17 +962,13 @@ static void add_msr_offset(u32 offset)
> 		/* Add offset to list */
> 		msrpm_offsets[i] = offset;
> 
>-		return;
>+		return 0;
> 	}
> 
>-	/*
>-	 * If this BUG triggers the msrpm_offsets table has an overflow. Just
>-	 * increase MSRPM_OFFSETS in this case.
>-	 */
>-	BUG();
>+	return -EIO;

Would -ENOSPC be more appropriate here? And, instead of returning an integer,
using a boolean might be better since the error code isn't propagated upwards.

> }
> 
>-static void init_msrpm_offsets(void)
>+static int init_msrpm_offsets(void)
> {
> 	int i;
> 
>@@ -982,10 +978,13 @@ static void init_msrpm_offsets(void)
> 		u32 offset;
> 
> 		offset = svm_msrpm_offset(direct_access_msrs[i].index);
>-		BUG_ON(offset == MSR_INVALID);
>+		if (WARN_ON(offset == MSR_INVALID))
>+			return -EIO;
> 
>-		add_msr_offset(offset);
>+		if (WARN_ON_ONCE(add_msr_offset(offset)))
>+			return -EIO;
> 	}
>+	return 0;
> }
> 
> void svm_copy_lbrs(struct vmcb *to_vmcb, struct vmcb *from_vmcb)
>@@ -5511,7 +5510,11 @@ static __init int svm_hardware_setup(void)
> 	memset(iopm_va, 0xff, PAGE_SIZE * (1 << order));
> 	iopm_base = __sme_page_pa(iopm_pages);
> 
>-	init_msrpm_offsets();
>+	r = init_msrpm_offsets();
>+	if (r) {
>+		__free_pages(__sme_pa_to_page(iopm_base), get_order(IOPM_SIZE));

__free_pages(iopm_pages, order);

And we can move init_msrpm_offsets() above the allocation of iopm_pages to
avoid the need for rewinding. But I don't have a strong opinion on this, as
it goes beyond a simple change to the return type.

>+		return r;
>+	}
> 
> 	kvm_caps.supported_xcr0 &= ~(XFEATURE_MASK_BNDREGS |
> 				     XFEATURE_MASK_BNDCSR);
>-- 
>2.49.0.1204.g71687c7c1d-goog
>

