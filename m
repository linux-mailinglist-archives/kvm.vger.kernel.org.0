Return-Path: <kvm+bounces-18017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AE458CCBD3
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 07:41:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EAD1F1F21A7F
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 05:41:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67F0413B299;
	Thu, 23 May 2024 05:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fTCe/XQd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71EB13AA39;
	Thu, 23 May 2024 05:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716442882; cv=fail; b=C6dJii7LORFOWO/G2G6N/WecRU7NYgJ6/l4fUEOwXvWTuJYyKleWrrcMsr/j87+4YK8ZTUwvO73yI7CXn02fcbe4UrwlVR4HlIA0LN4p9AqXCGJ669qg/ZaCDuPnqWbsXV6DlpkbZpa4IewzJZDGd5GE/PDfqN/lQLKUn5+lJDY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716442882; c=relaxed/simple;
	bh=6zb2ylRkQLn9eXS9EoyMT0GBiTRJDU7GMUSSZVO+yyw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NkKhVLhSJ9ivi5hV+wQiY2rc5Mx/9J0WlB8fAzQQseGNjsL961oo9Jh+W0dmIdCcQaZb3H+VBJ6cWZqsgwnVc1Zv8qYeumy1zwAgy9WlvgENwuQ7vIOrCQo4I5saCEgCs3Ak/jBecCdHZKznuW9OFwuAImqBD5Ce6ABAV9PlS8Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fTCe/XQd; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716442881; x=1747978881;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=6zb2ylRkQLn9eXS9EoyMT0GBiTRJDU7GMUSSZVO+yyw=;
  b=fTCe/XQdieWtw3uwtSwoxnO/l4iLwCQpO1SrM25EWxYAIuPCfCrknx9C
   5l1pi7gCXzpZELlaen66eDpJhsd8ad6yQjStoEGSqjJWfDNUZa0zDNshE
   QZaqP8P4PhXh00tnZ5eoi6MJByat+vTdHerN95cVrhahtQrerDYgI3v5M
   Z3ppgsZT2Ez72Jv4CmO/ulrtYhj1YJxubVcP+yI7qFkWFte7IDdh7lU3u
   nbc/0eLC8i+b1dEdQ8qNBsQumBgnl1qlWGevcXoTSnkl0jiNLUc8Zgywc
   yGr9NaYnLujhbDiF2WycDv9Uy4/svJeQbZcUyby2+EVq9IbXIPRIhEgCO
   A==;
X-CSE-ConnectionGUID: Mi5TciczQXmqxOBDKvMT8Q==
X-CSE-MsgGUID: EeRP6tNWT1is056qyOjccw==
X-IronPort-AV: E=McAfee;i="6600,9927,11080"; a="12584949"
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="12584949"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 22:41:21 -0700
X-CSE-ConnectionGUID: 7iqY4dYLRT6c1y3wuIi4Ww==
X-CSE-MsgGUID: p4s1IrVESUSLrd5TUTlUOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="33647102"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 May 2024 22:41:20 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 22:41:20 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 22:41:19 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 22 May 2024 22:41:19 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 22 May 2024 22:41:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kqMpjkANcgw4A3t4hoa1XL9EXArQg17lG8Sism1IfgCCZvt6okIgMaldnzlUpKfIM9fArnood7qqvUHoFVh+RegmGVOGJHYrhAOqOD6CAkX/mnVBW/mo2cGVlPI6TolB6mpaJeP3CZb1x/YWsL+kTDDo8sSM+vUUUpBDZTVimG8LAJgsawCF2VKaOhYxPio8XyJ4lpPhC+xoWBqBLMvBEzzC5a/m5eaenCK+AT3HvpadbCQDVhCqidoSixNos7F3YnaVaOYUFYRe6O1XrFt3834USdBulPY5KLf9sudR8c7YsY5nMNQj/NceMz3vQ6QvpdakpYqfAUuN6aGTvSNlAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kvFi+5PjN+ghMQHYFYq0l7c4LAXhMO8EztTZrAY6+bg=;
 b=np3pMuqTmZNPhRL/ALPqs9h3WcrlRoP6bdOwijImcGYlDgl8Aho/LtGz0fNjOOBSuxvhf+n27ieERaJY0YyNN3Ho2+0yQCBqrWwLrQhoX7OH16EBulPY0nK/aekdmh7sXmJskdJf27beUklOQnCZxOF/muldugx3n9WtZ4Hq0HXbAedMbac/tC8GNeVoz3jWp4K215n5Sa+McjYX49OXv0QTGeOKxIx0rjZ3E4ou3c4HixtDs+eH/gXi84aIYz8+VWdF5UmNe1w1OSjtDu6ajLEWB/L14d6zRvsZhkJRM+r91GJS675OOPqtXebfLWDeVdvgAKsPFNkVQQ6EoJX7PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA1PR11MB8197.namprd11.prod.outlook.com (2603:10b6:208:446::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.35; Thu, 23 May
 2024 05:41:18 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7587.035; Thu, 23 May 2024
 05:41:18 +0000
Date: Thu, 23 May 2024 13:41:11 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v2 5/6] x86/reboot: Unconditionally define
 cpu_emergency_virt_cb typedef
Message-ID: <Zk7W9yoWG1of1m07@chao-email>
References: <20240522022827.1690416-1-seanjc@google.com>
 <20240522022827.1690416-6-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240522022827.1690416-6-seanjc@google.com>
X-ClientProxiedBy: SI2PR06CA0012.apcprd06.prod.outlook.com
 (2603:1096:4:186::13) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA1PR11MB8197:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d538bbd-83ee-487c-ffdc-08dc7aeaf7d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?SNBv6+HQDeY5hiioWLRduJaVKnGjHGibeAIP6fSCxoG2IXFWABeT7P54luSE?=
 =?us-ascii?Q?W+rBKWSvVKJCMLjB8f/1LsYejQ15iuAlXIh1U3B/Cabh0977w8pnpk4YvGwx?=
 =?us-ascii?Q?L5/3/ShStkTArh1KHkIWFIAWZH3UdXrf+TWESvdkoG5815s0za0dLDuDolqW?=
 =?us-ascii?Q?dGeQce6yYt+tQ8tBwP3J4uVGJ97v89kjnF5dRjJwKwp75N9m/DQ0hXKMh4LX?=
 =?us-ascii?Q?LUnGV9i6IUQ/FCmf8Gv/cI70T6NU+BR1LTj8AdCyueMtrl+o6US9hDcfJ85h?=
 =?us-ascii?Q?tjB6PVLeCr5E00gAQu6v88Fy56oS8hwHk7kTehF2OI303DyOxf7zqH1kjroI?=
 =?us-ascii?Q?AhEZkdycrREN29hFEg0vSGzGKhb5T6C4RPaGkEbLxI/HouDmvLyNXhbkQPSo?=
 =?us-ascii?Q?BNW98wdRDZfcHJawPuZ6Ix+Rlsx1+nTDZYDBTA4WmEPlv3F1ZZp82n8rtyue?=
 =?us-ascii?Q?xrO7EEPsjv1NRNL9TpvYHtAMIP/8nGXqLaBq2/hW9UXJmLKasvJpEoxyizoM?=
 =?us-ascii?Q?5mYNx4CEfLF5pDo2RR/QoXAwHcnZWzi0/hNykb9FmjtOg/d+JsELYdho0rBM?=
 =?us-ascii?Q?126rXelizma/kTluhlXv9gtOi7y80MukfcIYNqkqiU8ecQrxAqRnsskjiNvC?=
 =?us-ascii?Q?rFOlF1pGrBOvbtgmfHD2NnuuDgsevECUxSYGEAifML4Rh1GrIlkbdefuGj/E?=
 =?us-ascii?Q?AujuXwymdh5nOtJKfkDWNSRJSJxPvFzVE3neDe6Ut48Gee6w3a7JoVAArlb+?=
 =?us-ascii?Q?arclnwrEDid3+eRHH3ky/Gu+wWruFUTpBsTk6Hm9PAzQFihqqKTN0t8k299g?=
 =?us-ascii?Q?gO8rdJtPvgERvP74zPTbEFyExXyHytPrIMX5e0LBZrkGW6IDvZcdqjBF7yjR?=
 =?us-ascii?Q?lVxj1kqkqSPcHVkF3olUKnKDDzyZSfDGt728vddiT8b9Qntp7S+hJmB/TnCW?=
 =?us-ascii?Q?P9Oy0Vsh4YVFwwICYuNvXbkqBQQBeVEP4/xS+1kYqA2wf5nMc2r1e6CRol2i?=
 =?us-ascii?Q?MwiSCZYApz3PxyyZ9nyvXp4ify3qkvEQUCH4X+ou9g/u+wdQ4gLPEfsjNt1L?=
 =?us-ascii?Q?Z0IODRYnOms04CbNiuFRN8clf5fNCXL7n5iUBXNar0C5HcuWxiw5u064l/R9?=
 =?us-ascii?Q?YqhjsBdJmcFozV3/3AU+ceE9H96b2z7Lq8ljqd7PcYZ8by/mgpaw4zFFufgP?=
 =?us-ascii?Q?kOlHeXeHpQAPQNtl0D9LG6Yb+yi01XfSm+CEOQjn+Ccc4wFEhtUWAolc0S4c?=
 =?us-ascii?Q?2X4iv/KeNvLRDDV06Z9jWsN3wIGChuJicLOliXiWlw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?X0adaMx+FRrHZ2OuOwy2B6DESlfVGgqzfP3PqqQlaFLfaBUX/+HEZhIJIKCu?=
 =?us-ascii?Q?tW4yUf49dsBYlnGL+LA46PEnR70DpcLZDXoRQoxqw5O0/ySpFPq+LHUw47/G?=
 =?us-ascii?Q?G5e6O5obuARxf6qgVIKc4+flJutSvp3+pQ3cH5n/6oci5BxV6smRC0C66BY2?=
 =?us-ascii?Q?kDFhLuQVNKykqwpLn+4CuDC9Qxfw/ccXOcpQWkRlpo0SNGrRvIBHBRBqcfrg?=
 =?us-ascii?Q?5b6Bi6GNhTY7m68zxdcVDXJzT8L77+z8qLSUC+jwvtL05UOlOC1q2bWRWjD5?=
 =?us-ascii?Q?t4JVAXsffbKiCQN2n1egStqFbvBMKLUsdgLzsZ6ZZbSY9/fs1W5Z/wkQQcsU?=
 =?us-ascii?Q?8JBgrtEE+fmEz9Wy1q6y1JDyHm5sN6bOTw3UPeGFDqjw7CWke4zpeXoTl9zs?=
 =?us-ascii?Q?dAxlG3D3auLbq9rlyh4j+J6zufISfneAOkdvG/IJjuY2Qg1INhlKKeUcati1?=
 =?us-ascii?Q?d70Wlj5ljg+FusfNVNfXtICiJQdjeRh27Cy/rMYNUewLSwyZ0M4nJAQ3W5TJ?=
 =?us-ascii?Q?5WD2iNQo1Af7VEHPB7+MJHypTekGTVGToreON7k4bkijWVEZy+OkjDm2itVA?=
 =?us-ascii?Q?aslfJGfTrZSTI+SXPnkD9CNqOeh0aNLgku78IL/k6Wja5Jc+Z2H0g93n3/ZU?=
 =?us-ascii?Q?epbWYSq8hbjRPQ+emK5PaoLN5oa/k6wUlT5+F72fdvcehZxr5lviP7ccY0RU?=
 =?us-ascii?Q?ET6MeAiWnjQOMwgmUIsWueI2lTu8DdTqm//VofAgbd+khhX8uWRRxa/bXrmt?=
 =?us-ascii?Q?XvGinfhyqYEeJpbZvW4E8wlmNinmKmN6QX/4XTyZJc/9gV0lLpq75JawZgiN?=
 =?us-ascii?Q?Fdpx24jJnmKpyNgre9up1//OwR4NXLoNdndI8nFyXu1F9L3wn411i+zY52pr?=
 =?us-ascii?Q?6LSRT1LD9iZ7uHMo7mlcxyt6248thjvcde2nHcXxoaMo+oe1xsKTRPZ/wfe6?=
 =?us-ascii?Q?P7zgFp2FpNZV5iPosy8UPqh04P+oFzV0i65o6oyvYvLEkmBu/LI9f/nZsM37?=
 =?us-ascii?Q?EdMIcmqP8ACKH3XVF5YGbybbvkZP6OWiBfW6mGfNzlSyvqU7Vkj1smGRgRK9?=
 =?us-ascii?Q?ZSrXrndmfkvtVg2/ly03ibgVeH0sNWiOLEiftqXNSq1ZeV/+vOJEnQprVwYb?=
 =?us-ascii?Q?tSUzId2+dQ3qr1MOINBRrSGSo3K/r/lUTR7B4OgRMXUpxkopNDvKPNd2gRt/?=
 =?us-ascii?Q?2KdOv4J+xa/MQbPkWVn10QJWwlHUvsoicpKNmRhDpA84BC1TMSfpCOERLRMs?=
 =?us-ascii?Q?DXRGcXewA5Hsycbn6qyaMxm4QIdpwRRmyh7gbAj43om4QzKxEUb9EvRxGwjz?=
 =?us-ascii?Q?w4zCLc1AIM1pZM/on0NWX01HExw2yb6BOtmBamBKqKGhwoCPz2C6JW/Suo+I?=
 =?us-ascii?Q?q7RfvbqK/Xl9r1Tww0+SlSmzB+DnKPHWUsLovFy4ELMBixJCpuAril0lKmH7?=
 =?us-ascii?Q?ZSIubvcPFRFSI7WzJaVEAxrED8jKDClskge2rV3jP+M9EOFBxR4O7bMG6K5/?=
 =?us-ascii?Q?klAkmchgXQvX+4H0TqVuYicVnpr4ouBP/HESCP1Jn3mbVFxe/hTHw7v4dL08?=
 =?us-ascii?Q?J8GlI9CFEaUfu7fn9yjvDy/h9sq6W3Bc0mmFE1Ye?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d538bbd-83ee-487c-ffdc-08dc7aeaf7d4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2024 05:41:18.0088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YL2Cm/lNegk4MGaWTJsc8UUAHD5mc6+yn77n0UToB0/430PHzLyIS2ZbvI3xaeCsWU+sR4Df/8O/AvzhhGW6bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8197
X-OriginatorOrg: intel.com

On Tue, May 21, 2024 at 07:28:26PM -0700, Sean Christopherson wrote:
>Define cpu_emergency_virt_cb even if the kernel is being built without KVM
>support so that KVM can reference the typedef in asm/kvm_host.h without
>needing yet more #ifdefs.
>
>No functional change intended.
>
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

Perhaps x86 maintainers need to be CC'ed.

>---
> arch/x86/include/asm/reboot.h | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/arch/x86/include/asm/reboot.h b/arch/x86/include/asm/reboot.h
>index 6536873f8fc0..d0ef2a678d66 100644
>--- a/arch/x86/include/asm/reboot.h
>+++ b/arch/x86/include/asm/reboot.h
>@@ -25,8 +25,8 @@ void __noreturn machine_real_restart(unsigned int type);
> #define MRR_BIOS	0
> #define MRR_APM		1
> 
>-#if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(CONFIG_KVM_AMD)
> typedef void (cpu_emergency_virt_cb)(void);
>+#if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(CONFIG_KVM_AMD)
> void cpu_emergency_register_virt_callback(cpu_emergency_virt_cb *callback);
> void cpu_emergency_unregister_virt_callback(cpu_emergency_virt_cb *callback);
> void cpu_emergency_disable_virtualization(void);
>-- 
>2.45.0.215.g3402c0e53f-goog
>

