Return-Path: <kvm+bounces-66894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D87FDCEB005
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 02:38:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9F93130194D7
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 01:38:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 400A22D77E5;
	Wed, 31 Dec 2025 01:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fcyMUlDn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8C02C027A;
	Wed, 31 Dec 2025 01:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767145114; cv=fail; b=aLr9ikt7svCKzQMlbGgSSIAD62UZ43C4kfU8q0otugipwXPDVcUjklKexZVu0/w9Bxzl0E9StAmY6sti6h+cQ7qlU6TBsKvHeiVoqvmHdzVjH2Q5TgtqGEW8culw/KiHb8AZP0/SL0rUjZPCckQTkoZ0cvZorz6trBnK4AQxzCY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767145114; c=relaxed/simple;
	bh=XF1iiGINOH9LCJGnLL2H4Jb5zXpQUodYbc1EPdIw39w=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=T0dvSB4D3lnHGMjhZfzVE6J9+O8QR8NDFkBM/S5VXNmwqYaJxTgPXQp+Qb+hdNUyYVZEVFXSiIjwY2uFm4DYK1OArnldvKi6WSfA14lAzx9gAqBMri68iNQ9nyll6yWIdIoAMJ3ckmWBOBlm17zgYJKZho2pemlzCzIcqIaxGno=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fcyMUlDn; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767145111; x=1798681111;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=XF1iiGINOH9LCJGnLL2H4Jb5zXpQUodYbc1EPdIw39w=;
  b=fcyMUlDn5va62/XGPaZAcQXa6SXwFpyFBLNdHx6kpZo4IAS5V/j9gXPY
   t69doicQALcbukPiCzkBqZeTszRELR+y/YOt4IUQ7Lx6gha71/LXG9GlU
   MVqroS4KcIKHutAmJ/U3EWiNz6qOoxmPC0U+iDTPofaJZO4FB+ozoIqd9
   k3aVY1oBCt79a8pMwYOjhOu/yOQ8kMekWs2saMQTkgtMzJjs00IyDBFK1
   ip+iGaJmu+9z0wFOsXu47HLeZrcbXl1Pgn40DhY8FVdhKzg+C0v9h2/U7
   2mzcUkS/4p7bzMyrEp0PAZcHVQy28HdvNzMrlukFSllHXAmaPKf+EaSjT
   w==;
X-CSE-ConnectionGUID: 3E78+B/fR6W0Kk2ITqcwEg==
X-CSE-MsgGUID: uluVoibkQr6vposCYlOU+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11657"; a="68760501"
X-IronPort-AV: E=Sophos;i="6.21,190,1763452800"; 
   d="scan'208";a="68760501"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Dec 2025 17:38:31 -0800
X-CSE-ConnectionGUID: KNgRZtzaSJawcdDZgYTAjQ==
X-CSE-MsgGUID: tcOW1yFxSJKkA2g4pKFIzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,190,1763452800"; 
   d="scan'208";a="200544959"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Dec 2025 17:38:31 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 30 Dec 2025 17:38:30 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 30 Dec 2025 17:38:30 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.48) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 30 Dec 2025 17:38:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZYFsO06lQyGLALqOdxyNMbwo6y6UpCzhXmdgij9v+OVylXPmh+0abIieChOjMfvhOVQV+SFXe9Ve0YNOysCIUt33xI1WdE9wb9NECEJyUXbEwb+65pNwZ54jIRS5Cbffd7RgzyQwy6lH9Ctxlly/Tx5J9s2J8fN9Z8+ZSREXTZG5gr57tzXrMhbnY0rtu4dMIaDxLOlmZDVySCyXn3BUEJkPt23T54610RmsUgIJN3KH3w/kteuMCXsDB8Y46jMAmf33OR2b6EoQ4RdLeXfUerjl1M3izASMGCzy5T1kdBe2ytlJDRBLjTNIoVrVdu9hxYKzsAL4e2oA+6u9ubGlCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xDYTWfOsJdf8p+Fac6kmjzAJxY8IR5khAFsw4wJ/d5k=;
 b=xi+sCaD+b/EjJae5BX1IBMKfwLHJjz7ej6T+NV1L38eC/8R88wJotqoBqOr3PJYsYX4CoGMdlLbHE5et9pDSp++MWL+9X4E1dZk9p00eo7EjTYuj4MQOgns3vSADYhHjnzHFg72aajTVpwPILABNebJC274Y1yqQw0DrvM1Xzv5RAMcr55VtByzKXiOVjMn2yjTT0EyPqX1cdZ1+pjSgBxy30GDtSNuqbzUdFijrYW9dCiW8V2QN1n4mo0KIYqNg0ocEdWf5GZEyYnGPLqqIaxQA7kbUM7DbYKORt/pwIW9M2VISIZcbXicoIcK78qOiS36zrJtxGQUlqupKbtFtMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by MW3PR11MB4556.namprd11.prod.outlook.com (2603:10b6:303:5b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Wed, 31 Dec
 2025 01:38:27 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9478.004; Wed, 31 Dec 2025
 01:38:26 +0000
Date: Wed, 31 Dec 2025 09:38:18 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/16] KVM: nVMX: Propagate the extended instruction info
 field
Message-ID: <aVR+iofaXS14ChtR@intel.com>
References: <20251221040742.29749-1-chang.seok.bae@intel.com>
 <20251221040742.29749-8-chang.seok.bae@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251221040742.29749-8-chang.seok.bae@intel.com>
X-ClientProxiedBy: TP0P295CA0015.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:2::13) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|MW3PR11MB4556:EE_
X-MS-Office365-Filtering-Correlation-Id: f547d307-d282-44a3-01c4-08de480d4b38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?r6z5Vh4hK14Z1rDA8K9uB0la7c1OhGPM6YKSRtSkNrrX9ETBB6tUbMcJ0TX3?=
 =?us-ascii?Q?2yKxYmUZMvQ24FdnqYqs7xpFcQbfLMn+I5uWz8SNxY52kM7fx0rQhgGaHj5F?=
 =?us-ascii?Q?q80sCzaKD9YD/tnw8lz7dxgHoyVfbgIsnQ49J4t8Xq6jrIfDovBEroQMICCu?=
 =?us-ascii?Q?9rm3IvFZ9Heop/hkIkeoUTQgN3sAAFGHQOuS7SDqjfJlUEOvslTUfv7SyP/D?=
 =?us-ascii?Q?55c+K7lWQ5X6JxReER1hgOE57Z/ZDI/H9G5otdxIFND/Uz7vjrWj9TmuVCYt?=
 =?us-ascii?Q?u2WrdGs0cPEAeAxU3MyRj2k9nFFEvAvpQR6Ws258e1a1HltARhjN6ll+QGDA?=
 =?us-ascii?Q?s/hpk9iHlP8mVIBs9XWpYLWrqoeLmNb6GVci5gqtzy4nh10ZiI7OgbrLrjSo?=
 =?us-ascii?Q?QZHjxkRxc4dpQjPoqV5BodlQd9/njOAW84skbUocKabYXTDFElmbj6RoZgv3?=
 =?us-ascii?Q?4HEXxwO1w0JyPI8DIfcTsC0xUQkMGAE7qbHYvVWdmXo6tSsAgVG9m1QBdXwi?=
 =?us-ascii?Q?4nDtVvh9/S7ZTxMeFISMoSxhkvYbGj9ijSZqOvnKR7dAySgDzqHqcR3weubN?=
 =?us-ascii?Q?xcrExU2BxYTlJs0iRMGqEbMgDApS5yNDb4mkAfiyahMAEK2KTREztuEE/r8N?=
 =?us-ascii?Q?eX2TfG90fuBBJ/f8JG2X6BrDcyy5fU0pU+LNPS/MvCZLYnehqnobNny6obEB?=
 =?us-ascii?Q?FWC5eW5vwBfKdRjUbtxbVlqfLzQRTpmyiUHU7UI8oaYfi9rhHs5a2N5LZGXM?=
 =?us-ascii?Q?tTg+waqeWffnrXVJ4AveuFhoxRpZsLDucw6q2KmYYjUNKq8R3nHSP2nQQAPt?=
 =?us-ascii?Q?8+dbo6wD+Fv4y9CQKL6V5tFmqmcJTwCINw6nDAJhVSRQgk95nCUZl85pAk3j?=
 =?us-ascii?Q?TK+otI7povqyh7yBEwWRk00vQF9SVVD3gHnT2kbQ+/U9Fh2XYQdMlV90DLhC?=
 =?us-ascii?Q?URmq7LgCY02UYKEWKPtlGdeq9wrSRLX2xZ5moNXH3oA5mH2gRgVFGIdykBm0?=
 =?us-ascii?Q?IdRD7EL78hg73FhcNuOmh2TsipODoTIOnATh98+0TkXPp+oFkBF3bycMXKLK?=
 =?us-ascii?Q?mKMXP599dJg4VwjXLg9D+K1c6XUqMf6U4kzQ/gjpXd+bbJC1Zb6+jjF9uhqs?=
 =?us-ascii?Q?oN6WBDWZxLLjFXVRR8rYyMrw7SbrktuorrlMvHJbJj4EwpgOmJ8fPglxyCIV?=
 =?us-ascii?Q?ezMMbu959Sa8X4NlJ154otmKAhHOlZBhEW3LCCv47WM9NYmKog+OP4++0Z1c?=
 =?us-ascii?Q?1WwgxI4aPlFeAD3yTw6lIAUX/w1AJ44C3FeLNCcEFfpGDnqU2oG8xJijKRVg?=
 =?us-ascii?Q?+pZd6zonptmyHxfNjTQdz62iTeVp6jdjsFct1lXYe6SW74Fpe3yYE7q9v9zw?=
 =?us-ascii?Q?XtZHixfdhtiDyYCpqq4ddSevV0vNOA9S6oDzQVveCwrShtbVyE33L+RPy1F3?=
 =?us-ascii?Q?Ydch8O2Uvyg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jrBC8LFsU2AYc2Jh9WL++A5aolCc8bwyq5PZPqM5O7KDG8HHC8Qt/q342h7N?=
 =?us-ascii?Q?5JM7kSYQrw6BzC5i0HpqzeYGlQdTz+SpnsSWzDL06AHNrs8CK1L17+AmDJRN?=
 =?us-ascii?Q?yqFsUgLMGWVxNk91kbKMPkHIkH7ncDWUWPC1pb5N6iiTFVq9QB8hpPM3/Hrl?=
 =?us-ascii?Q?4CHJdqrqvWfxRJiJ2jpoAQBFZ8SIEbvapuxs1o/AFS6TsQmFMPuMXAOCGJ0a?=
 =?us-ascii?Q?LJomGNpMOE2y7w5jvc29SLDZIHB3v9F/6mC5dBVWF+fYGxxgdVVAxSoto/FD?=
 =?us-ascii?Q?DCA81S7DBsczsHOPY1sifqx5/Os/KByQKsMiOqXm4c26NETct5f960WoRCUb?=
 =?us-ascii?Q?QO6JzCBIKXKLPIdcy7VG0lg/zKGDiO5HFJSiN3UWvUbNVVA/BOgUHfYP5npe?=
 =?us-ascii?Q?gIKZNF0nRTzjlUG5CibIuPfpNNOnnBn+rlsIVRH7RlZSCqkRabf+9EzCpt5F?=
 =?us-ascii?Q?HKhha2H6buXGi12ErwnyVKh9z/xcfHll8FSZgL/c7RXKYB8ksnlrQ3KCjh8I?=
 =?us-ascii?Q?xP/WfzoMcODttDj5qNXu24hM15eQx6b4ElzbLTgvhwV34ej4HX6sVRoAMmc1?=
 =?us-ascii?Q?9fP8Cms2azcMu/SmFdG3JPUEIs/RQZLeeuXblhZgKxHVfVTIpun+GD/tTZl6?=
 =?us-ascii?Q?58vvDxuVsRX4MPQb2Yyvo4oK/VHBQ98eameoGd2kjAkkMmViYHSMDi+wGpqz?=
 =?us-ascii?Q?8NNQaXX/rKeNEsBJ3xC7Ez13Tmd5WCgajjW48Xf33UFl6LWr51ryg1CpohWp?=
 =?us-ascii?Q?4suO7e+FumfI54zO/lZ9zxh0I+3dswVpXP7vf/VO5cCyJt+C8vP52DVZjkDk?=
 =?us-ascii?Q?mgRdWExKvC0rS7mk8JOr7JgnbdsPTOOohSkAqhbKHwR3Q3icNrt2A8JUOlb3?=
 =?us-ascii?Q?KgrC+wEaovTDClWyOGgiLUGPbOQUMd3MgtcIidUP6uyP9bH/s4gainGZXj7r?=
 =?us-ascii?Q?+j5I7kd+ofJzJXReFTObWmpciQdMLpdgl2r6Nng/V6djjM3JPv7tIvCmi00F?=
 =?us-ascii?Q?cSw+MM/VjP76BcqiWdsviVGL9d0gzIA9FJjZUC17HjXE9PqH02yr1KYncJSi?=
 =?us-ascii?Q?7RjD1CKRm26lyWW1jGvLpVHpnO4ZIhquroFFQinhUxtzcxQjKRLThevv8K9W?=
 =?us-ascii?Q?Tm+rry3MdzJBKtXMLq0AjtJS4YArl7gMRvyRNpN51HaGsnJuK/ejrVmP+Kcx?=
 =?us-ascii?Q?Zyyefz3iL+/myO0EmeTNk4EgBB+53pk+QqJwRj+J1DNt8Kpigm4st0Mqo+9z?=
 =?us-ascii?Q?bZ2t+xH2H9hGAxRhL+NbDw4gM4IYqPjEZRGC+n72owjfTTeBQjDFnel6oyOf?=
 =?us-ascii?Q?LxuBBVOphXqJPU+Vp9IcaeMFOG7DAKNm9mSO8L0WDSu2GVQpJA5VjteXKmJP?=
 =?us-ascii?Q?9UEF95g05YKjJrJoAuefA5Xptx/WwBVgEUOUciqqBIva+kgwesOw42b3K03r?=
 =?us-ascii?Q?iyh1jQwz6sv4aK2ipjVV328J9adK4HZgSwqUvKvGZ6KWXfeEOMiQyvboKyvw?=
 =?us-ascii?Q?LPoTZFWDgruPevoQ2HHCAVVM+yRRWXr0FeVFM5kGNdhlzdtSCvLzNrjn288A?=
 =?us-ascii?Q?zmVMMAwROoblLJGnOfxQqo7ADPopkAoCo059+A3Oxqv8Hmtwi7MEh3gu+2hm?=
 =?us-ascii?Q?8CzhQsOeQmpAydi+r8rUGIdqabGnNZKIFDdpfUGfLz7lkBZsVFK7GoJvgrKq?=
 =?us-ascii?Q?op7Ace4wF+ViOcq0puTsA724m9kJd4qZg+aq9VTauQETcV0MluI4soRweXh8?=
 =?us-ascii?Q?sRPxlJxsIA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f547d307-d282-44a3-01c4-08de480d4b38
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2025 01:38:26.8986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jJNeCqfPkIdBf9lZqIZ5bYC5ITdFbBHzUL0qKc50HaDH5NjZXpccac8DChsSeOfKNCtadIsinGyT6t4lgYr3nQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4556
X-OriginatorOrg: intel.com

On Sun, Dec 21, 2025 at 04:07:33AM +0000, Chang S. Bae wrote:
>Define the VMCS field offset for the extended instruction information.
>Then, propagate the field to nested VMX.
>
>When a virtual CPU enumerates the APX capability, nested VMX should
>expose the extended field to address higher register indices.
>
>Link: https://lore.kernel.org/CABgObfa-vqWCenVvvTAoB773AQ+9a1OOT9n5hjqT=zZBDQbb+Q@mail.gmail.com
>Suggested-by: Chao Gao <chao.gao@intel.com>
>Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
>---
>Changes since last version:
>* Check the availability based on the guest APX capability (Chao)
>* Massage the changelog to reflect this fact.
>---
> arch/x86/include/asm/vmx.h | 2 ++
> arch/x86/kvm/vmx/nested.c  | 6 ++++++
> arch/x86/kvm/vmx/vmcs12.c  | 1 +
> arch/x86/kvm/vmx/vmcs12.h  | 3 ++-
> 4 files changed, 11 insertions(+), 1 deletion(-)
>
>diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
>index c85c50019523..ab0684948c56 100644
>--- a/arch/x86/include/asm/vmx.h
>+++ b/arch/x86/include/asm/vmx.h
>@@ -264,6 +264,8 @@ enum vmcs_field {
> 	PID_POINTER_TABLE_HIGH		= 0x00002043,
> 	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
> 	GUEST_PHYSICAL_ADDRESS_HIGH     = 0x00002401,
>+	EXTENDED_INSTRUCTION_INFO	= 0x00002406,
>+	EXTENDED_INSTRUCTION_INFO_HIGH	= 0x00002407,

Would you mind moving this hunk to patch 8 and swapping patches 7 and 8?

This would separate nested support for EXTENDED_INSTRUCTION_INFO into its own
patch and make it come after the basic (i.e., non-nested) support.

And, an ongoing cleanup [*] may intersect with the new field, so we'll need to
add:
	VMCS12_CASE64(EXTENDED_INSTRUCTION_INFO):
		return vmx_insn_info_extended();

to cpu_has_vmcs12_field() (note: it's a new function added by that cleanup).

[*]: https://lore.kernel.org/kvm/20251230220220.4122282-2-seanjc@google.com/

> 	VMCS_LINK_POINTER               = 0x00002800,
> 	VMCS_LINK_POINTER_HIGH          = 0x00002801,
> 	GUEST_IA32_DEBUGCTL             = 0x00002802,
>diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>index 1e35e1923aec..ce972eeaa6f7 100644
>--- a/arch/x86/kvm/vmx/nested.c
>+++ b/arch/x86/kvm/vmx/nested.c
>@@ -4746,6 +4746,12 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
> 		vmcs12->vm_exit_intr_info = exit_intr_info;
> 		vmcs12->vm_exit_instruction_len = exit_insn_len;
> 		vmcs12->vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
>+		/*
>+		 * The APX enumeration guarantees the presence of the extended
>+		 * fields. This CPUID bit alone is sufficient to rely on it.
>+		 */
>+		if (guest_cpu_cap_has(vcpu, X86_FEATURE_APX))
>+			vmcs12->extended_instruction_info = vmcs_read64(EXTENDED_INSTRUCTION_INFO);
> 
> 		/*
> 		 * According to spec, there's no need to store the guest's
>diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
>index 4233b5ca9461..ea2b690a419e 100644
>--- a/arch/x86/kvm/vmx/vmcs12.c
>+++ b/arch/x86/kvm/vmx/vmcs12.c
>@@ -53,6 +53,7 @@ const unsigned short vmcs12_field_offsets[] = {
> 	FIELD64(XSS_EXIT_BITMAP, xss_exit_bitmap),
> 	FIELD64(ENCLS_EXITING_BITMAP, encls_exiting_bitmap),
> 	FIELD64(GUEST_PHYSICAL_ADDRESS, guest_physical_address),
>+	FIELD64(EXTENDED_INSTRUCTION_INFO, extended_instruction_info),
> 	FIELD64(VMCS_LINK_POINTER, vmcs_link_pointer),
> 	FIELD64(GUEST_IA32_DEBUGCTL, guest_ia32_debugctl),
> 	FIELD64(GUEST_IA32_PAT, guest_ia32_pat),
>diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
>index 4ad6b16525b9..2146e45aaade 100644
>--- a/arch/x86/kvm/vmx/vmcs12.h
>+++ b/arch/x86/kvm/vmx/vmcs12.h
>@@ -71,7 +71,7 @@ struct __packed vmcs12 {
> 	u64 pml_address;
> 	u64 encls_exiting_bitmap;
> 	u64 tsc_multiplier;
>-	u64 padding64[1]; /* room for future expansion */
>+	u64 extended_instruction_info;
> 	/*
> 	 * To allow migration of L1 (complete with its L2 guests) between
> 	 * machines of different natural widths (32 or 64 bit), we cannot have
>@@ -261,6 +261,7 @@ static inline void vmx_check_vmcs12_offsets(void)
> 	CHECK_OFFSET(pml_address, 312);
> 	CHECK_OFFSET(encls_exiting_bitmap, 320);
> 	CHECK_OFFSET(tsc_multiplier, 328);
>+	CHECK_OFFSET(extended_instruction_info, 336);
> 	CHECK_OFFSET(cr0_guest_host_mask, 344);
> 	CHECK_OFFSET(cr4_guest_host_mask, 352);
> 	CHECK_OFFSET(cr0_read_shadow, 360);
>-- 
>2.51.0
>

