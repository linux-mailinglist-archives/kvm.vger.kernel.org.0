Return-Path: <kvm+bounces-52079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 71D69B010DF
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 03:40:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C03011C470DF
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 01:40:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6AE813B590;
	Fri, 11 Jul 2025 01:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WRuPInMr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635571A29A;
	Fri, 11 Jul 2025 01:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752197994; cv=fail; b=FRIpqNJYavK7NlIPVBIi9EpVk6guA3pUwhLlq6i3zqzzH0LuPO+j8eQT7qiF1cGdlOdiC4LwEhZJ4yc2jmtHAPsYGc++R2enX569ktq8J/jv3lzY6Q6cdu8EsR440w4WlgWaDeNnYDOAqbgYpvVuKqEIvtV4UeQckT3suyC1WY0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752197994; c=relaxed/simple;
	bh=DYr6P6isUpP9TnkmXpC5lRh5y5pcxmMyiwNc/WKan8A=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ctAMGKDqz3NLJUN9KnZzGB7wzF41eArHsmm3fhw6FoxHuUg7WR94HPr38ucWzC0E6s5SP+GAsqmJYE7qhq/LSui1Oc2Wr+b+L875XMsdtVXGv97TcC7OEFWEMeWqdzutJiP5g/SrvAJtK7KPPE2HW273MdAAA3lrvF2smi/ib3U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WRuPInMr; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752197992; x=1783733992;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=DYr6P6isUpP9TnkmXpC5lRh5y5pcxmMyiwNc/WKan8A=;
  b=WRuPInMrGFu6w+HM+1V3Qed6JaO93PbbMqhWK0fFKvCEawdXMQmfPOJZ
   30wv0Zn+sZ1Du/EuwUCyClnqvbp9ed1BlKvjz0L7EGnzCcRrCjbaIuwDt
   z/z+cXDQsFhqbCnEu9k7J1s7JFx4qvYcWdM7zp/GCY+cRcujPtzsr/cIA
   tSMvdo1UeUpLRU//klz6+aC+z5ifJ7AC3Cc36leJhQSfNW1Xrbm/u09i+
   +SuGrQLD7AQiah0iT3NGnqY6VrKW1alL51Or/rqW+yzUTPrN443K30FuK
   1cUZvo3xhdxZbfD0A16fdnNvou9yjOPD4iStCM35fWwCEnEQUNLaOmMyg
   A==;
X-CSE-ConnectionGUID: c9Ej/PcqQhyy9fdGFzucbw==
X-CSE-MsgGUID: jwbUhPHMTlqF6S9/e3Giqw==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="65076301"
X-IronPort-AV: E=Sophos;i="6.16,302,1744095600"; 
   d="scan'208";a="65076301"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 18:39:47 -0700
X-CSE-ConnectionGUID: m6gaSGJUTueyC1dGCqZF6A==
X-CSE-MsgGUID: rr9Z3mbQQNWhb7t0FNV6Pw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,302,1744095600"; 
   d="scan'208";a="155661914"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 18:39:44 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 10 Jul 2025 18:39:43 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 10 Jul 2025 18:39:43 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.86)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 10 Jul 2025 18:39:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AKMu8awQPuZKXMEfiE9/XKSpmtxhJ3y2b+hwbO8mr0xvRZng9KRz28TsjjTNZSDtL/Ke413liXQIl36JqbVb2R0OrzmBS0DY9L0SunYO9hLwQV3y9Ue0hb/SX0AtOsLYRRBnEMwVodDHXaHPxqGoNbl59zA4o5ELS63Uvr297rcdbhuXR3OVdU9oRLWV9QCjBXDaYllZl1+LDmAfKDvaGKPyzTfG1L4iWoZUg5vFzydayK7Fzo0mKVzXD/uc6x2KtP0zIGtdyoMHnpxdfosk44PzbIXAzizlsgGiJy0GmTFGEuUVzz4SYzaIHO8BxKjHRzXb1V9GTyH9TNqkzH/KOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vOoYt6h/qmr5eeWsmn4pLk52OMY6dISuL+3KEuRsf0w=;
 b=H9xrLKm7V9pj5Ghfv2EB9fENQ9gGic+eXbdQt3arybmW3xglD7QM6A09HVjwu3oTeOOM7t7pW4cFG0sg38GO84wxjLOWdymmSI/c75w0VDaPeIqlOOBBpYEZbviMIwq6ajDN83wNXLG8p3gjYY04cE5thFCjqweXRup4juHXRCnNzIKpCyvdE4vDSxFvl8W3QSFGZgd+9fUCv2clc4SYCtoXFd6CvCOC5CMsUElj1k0yflPnGA49AXEZHfYTx/HasJOKqWpE7mxWJKExte+JmXuCr4uPXGh0wRuNRAMW0TLvElfC8ergYPzVq80B5tbFQvitYQC/7sTSVg2tioQyiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by PH8PR11MB7093.namprd11.prod.outlook.com
 (2603:10b6:510:217::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Fri, 11 Jul
 2025 01:39:39 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::19ef:ed1c:d30:468f]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::19ef:ed1c:d30:468f%5]) with mapi id 15.20.8835.018; Fri, 11 Jul 2025
 01:39:39 +0000
Date: Thu, 10 Jul 2025 20:41:08 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Sean Christopherson <seanjc@google.com>, Michael Roth
	<michael.roth@amd.com>
CC: Yan Zhao <yan.y.zhao@intel.com>, <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kai.huang@intel.com>,
	<adrian.hunter@intel.com>, <reinette.chatre@intel.com>,
	<xiaoyao.li@intel.com>, <tony.lindgren@intel.com>,
	<binbin.wu@linux.intel.com>, <dmatlack@google.com>,
	<isaku.yamahata@intel.com>, <ira.weiny@intel.com>, <vannapurve@google.com>,
	<david@redhat.com>, <ackerleytng@google.com>, <tabba@google.com>,
	<chao.p.peng@intel.com>
Subject: Re: [RFC PATCH] KVM: TDX: Decouple TDX init mem region from
 kvm_gmem_populate()
Message-ID: <68706bb42efc8_371c7129412@iweiny-mobl.notmuch>
References: <20250703062641.3247-1-yan.y.zhao@intel.com>
 <20250709232103.zwmufocd3l7sqk7y@amd.com>
 <aG_pLUlHdYIZ2luh@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aG_pLUlHdYIZ2luh@google.com>
X-ClientProxiedBy: MW4PR04CA0283.namprd04.prod.outlook.com
 (2603:10b6:303:89::18) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|PH8PR11MB7093:EE_
X-MS-Office365-Filtering-Correlation-Id: ad12964e-3371-4d0f-27de-08ddc01bccbc
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?B29udPnHS9a+yKqm7oOK6apCoVPav5uHy1//eDv3QmJ7NTrwOe2P/VL90vZW?=
 =?us-ascii?Q?Lyx1lU6RppwewqqGyzo462FnTnjVKJc0Bv2gK7IufNR2oisvZmFi6Et/dFHm?=
 =?us-ascii?Q?H3GYpYoXP7E85S5Udn8lToPbCfF3M4toqCVPZ/lFFfbYSNJVccjFvrz1b0P7?=
 =?us-ascii?Q?0VPlcF3fRIn/Zecyc5tn+6DiKAo8GuQGftZnGj3tG2PcithLNSmIDT7KZr8K?=
 =?us-ascii?Q?zuSnsAXvYbWIqFMAMzid9xu7+/VR06bUY5KAxxucPnC2oXYiawt3GVkFc7BQ?=
 =?us-ascii?Q?WH16Hr/0N6N3PMSaqlll/rBGMMRkqRU1NRVsVN2Kjx5bKqW8fldv1fmS4Z9R?=
 =?us-ascii?Q?NM+Cbju8Emo+zK4JG94IPc+aTpQkfvGyu9nKVJiYdIBNvauAeqkMuE2SRjAO?=
 =?us-ascii?Q?7EG8DjG9vR2QswpsBiEwta7jNccQms3jws9Z8yCilOPITIWOur5Kn4el+7u7?=
 =?us-ascii?Q?HueqJ1fI6mzhqgnaoFD6hgZ9oCOQhDYaNx8cv57TSlEyRcdDnACGox3ApZ9n?=
 =?us-ascii?Q?mIbo6hcaNcS4Zxg1C4oYyiukRUd3IlPmfMY7NYKaVVMPutz114L0CL18gf4f?=
 =?us-ascii?Q?BCHeDXq7mNNtvKVd5Ri55ulk8YbnJD+ojLjooSTYnuHMXcie81PV+HoPLZqN?=
 =?us-ascii?Q?25vQVVidkC/1JNRdgmLopBaGHdg80PtS+bQ9HIpUU5X3K4zOCTZdr7PtKw6D?=
 =?us-ascii?Q?YA0eLRXgs6mdIXZyex8hw2DDv0FfVYcpZZWyDzac1XuY7LxGA4E7XuHu4Lfc?=
 =?us-ascii?Q?zgjmjEmOAOWdE+Pv/S+yA1F262jxNUO1EJTjTowTTsy8uCRw1/EgO/d4/Sso?=
 =?us-ascii?Q?OBXGrH/ftOS6DZOPQL97NbV1cYEFVxKMztIdZbYaqXxrOXZbEMcZrLCjK3Hw?=
 =?us-ascii?Q?42tqhaN4U02+9bRLOBlkPh9la8B8KO+Hhwm4H79pQ7AAQIVt7BtGQALdYbXZ?=
 =?us-ascii?Q?xUYVRUPXmi86irbKxZPFTUXBSbLOB+k1y6xpkIwXmaZ0tKgkl319L7Skzd7L?=
 =?us-ascii?Q?b3XqeV0hWXvx0Vmxlte683pF5yzwUNMwbr7XBcaRjc0+XJfuLEhi5ver+boU?=
 =?us-ascii?Q?yiLjqVZMZIIPsnS2+lXt4xmoZ96GE5ELUKuRau4XZ9FiuyndH5AArhH5kscM?=
 =?us-ascii?Q?iDvMD1RaVjMz115D20iCC27DpfnKDj1Wn9MALG1t2UAHrnHVX43zMTkVIagl?=
 =?us-ascii?Q?Wx+P8ZTGI6X4nw2IwKKM8Ruyz8hqVpqHzFcucsOuDKAYRPFnMMKINlwZ9PWH?=
 =?us-ascii?Q?m++r7LQq6OUPeNIA+YUvd70miKJv+NNvoe+Z9nSk9x7hc09JHoX7/2qAZIyf?=
 =?us-ascii?Q?RTAvBVxAmzZH95l6R1PNiRs8DRnwmdfkmycRIaNxyZzjVTzmTwhA0fmyPGJq?=
 =?us-ascii?Q?AV67f4nJjKexfy5D6BtT7leimw9oZmYp/1YF5+6CrpnNwDKPCcgCkhewnZMZ?=
 =?us-ascii?Q?X/FDuv/XAL0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8yADFrTh5bPS22FBz227vqYirTsvs5mxmix77y9Tg8l6mJTQASrhHT3hbLqy?=
 =?us-ascii?Q?uzMbNQeAUsDK9DAEvJfXJA5zo0WSghzdE1eCcvVoFiG+nR3GhBtFKeGLfbHq?=
 =?us-ascii?Q?b0Yq/w26Tj0wGhBuoy/9GYA8HoneI5GOJTZfgAu28eUEs7Q2Ijue14cnWPAR?=
 =?us-ascii?Q?GsGz/NFbtKbchc76d5tlrCRpQQLH0jCRnsZ8elGVE/0oIRi6QPcGf5wrERgd?=
 =?us-ascii?Q?gAtdubo43ZbeW5k7LpL6KtSVpJJwuHKdTKpGONuBoHn2PBJIvX2U+QMJdA/o?=
 =?us-ascii?Q?ori00vUqCQ5nFxC4Zp8K/Impn5yM+nVXQH8H/VvZcn2rR5qBBdNwQ5psuSxO?=
 =?us-ascii?Q?ZD1MAmGL7UTOSH1LG1Ae94j/DDBTFWkO0hmMCwW9LCEJnqanXz307Xk53Vyt?=
 =?us-ascii?Q?2Hh0JhTYcEPurEVjjBUVuU6ftnAP7pv3S2xyriq/SCWYOsg+EDmdfrxdWqFX?=
 =?us-ascii?Q?aQTeNYi4FszSFdwhhdltTyrUB1ZtbV0oH1yz1PTLIMUzHtsgj/EUexbxZ6WP?=
 =?us-ascii?Q?QFPSClAhrvaIxZ5H51xJeSN0mLvrb6CSLfEwJraLN9s2dDREyaf1svR+/H7d?=
 =?us-ascii?Q?dAE9Hji9Id1ipjELc5ld6HnnHxav22ui/OEtGxdTVsw00ovjszDoSQdJsfAQ?=
 =?us-ascii?Q?uFCUYNHrwrwbK8f5YUKfXHI9fFH8jDSwFamfPqPn/nV+arihGMm4WRJUF/SR?=
 =?us-ascii?Q?yKX9BAeYV6WHjmLRivJhocLL19kfOczF7C3sqMmwilqQVoX6Y2c3reNKo0YC?=
 =?us-ascii?Q?vEbDFzeaWzcw8ZAVY5dyzcapY6JtnrmGPI3XURyZ+YZbmDv79AlS/rERnS9G?=
 =?us-ascii?Q?ZwiX8mMu4Yzeibb036LIQqVnab/PmhgjTypp+EF6EOGn7yIQr+rKx8afbaJn?=
 =?us-ascii?Q?cqQsBdd7TZK5Az/XuA3tuwSYo8IRleD16IHYEHC4TlAO72PiHnqzJ0LwTND0?=
 =?us-ascii?Q?Ox0rS9PEq1jp+4vD+MpTgkjhbXfI9+T6KqEYHh+Gs1xNrgvW3cVzoqIqFihZ?=
 =?us-ascii?Q?knQjVjGG1g/Avhd1B/eiS/R4BBKltidmyCc0gb+uh+W6YI4Q/BWe23PfdW61?=
 =?us-ascii?Q?elLYjZAvAnjMsYVdbjT/ZxNlixAuRuUseDlnP0e+NLeu9/gBo/IFu+69e/r8?=
 =?us-ascii?Q?yNrNRvmIYu2mblX5rzSyeWZo3qNYPsK/nDjTSm6Y144P+EZX23Ep5NvVvW1u?=
 =?us-ascii?Q?KKeb8Wb2Z5KzrajXYWgOYAU34VIPBvUfeyNu1uHRia+18Z7TiVIGfhGE/ZhW?=
 =?us-ascii?Q?c8yDggsPDKxopQRz0Mf4k/j7A/S/TkcoM51EvqT69p2A/Ep5EF+8K8yn8JFc?=
 =?us-ascii?Q?TRboZ6n6jMKNi1cYjkYECyKPo5J7tNPeK+ybFV58XzTRE2kAe5PCUMfurMi3?=
 =?us-ascii?Q?G2cK/f1o6R6iM0/+Z5NRAm0EvPBVZu67i6RW1ReddBonrnP78Kc+m5DpL2fU?=
 =?us-ascii?Q?vc1ahOIgrcbr1R1Uw+QHRMF+2BwDpZVcBEXEBKzK8EIP2Up/+7eSQVjxl9LY?=
 =?us-ascii?Q?9MfzKUND9aycCjRTdscKaKWLOmQSVg63LKIx3DQXjpm7uoqKdpECPDk2EsmE?=
 =?us-ascii?Q?zORE+xhYe26vtI6YYw8/8HyCzgozxyvBAIB4Ae16?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ad12964e-3371-4d0f-27de-08ddc01bccbc
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2025 01:39:39.1847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O7CmgtF/56IzjDoILqiA1Wx0P+7d1qH125J8elqdyUM8iNs+eNXXLVbpFuXAU6Z6sQRpt6fIFZHo9o4w9aNTfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7093
X-OriginatorOrg: intel.com

Sean Christopherson wrote:
> On Wed, Jul 09, 2025, Michael Roth wrote:
> > On Thu, Jul 03, 2025 at 02:26:41PM +0800, Yan Zhao wrote:
> > > Rather than invoking kvm_gmem_populate(), allow tdx_vcpu_init_mem_region()
> > > to use open code to populate the initial memory region into the mirror page
> > > table, and add the region to S-EPT.
> > > 
> > > Background
> > > ===
> > > Sean initially suggested TDX to populate initial memory region in a 4-step
> > > way [1]. Paolo refactored guest_memfd and introduced kvm_gmem_populate()
> > > interface [2] to help TDX populate init memory region.
> 
> I wouldn't give my suggestion too much weight; I did qualify it with "Crazy idea."
> after all :-)
> 
> > > tdx_vcpu_init_mem_region
> > >     guard(mutex)(&kvm->slots_lock)
> > >     kvm_gmem_populate
> > >         filemap_invalidate_lock(file->f_mapping)
> > >             __kvm_gmem_get_pfn      //1. get private PFN
> > >             post_populate           //tdx_gmem_post_populate
> > >                 get_user_pages_fast //2. get source page
> > >                 kvm_tdp_map_page    //3. map private PFN to mirror root
> > >                 tdh_mem_page_add    //4. add private PFN to S-EPT and copy
> > >                                          source page to it.
> > > 
> > > kvm_gmem_populate() helps TDX to "get private PFN" in step 1. Its file
> > > invalidate lock also helps ensure the private PFN remains valid when
> > > tdh_mem_page_add() is invoked in TDX's post_populate hook.
> > > 
> > > Though TDX does not need the folio prepration code, kvm_gmem_populate()
> > > helps on sharing common code between SEV-SNP and TDX.
> > > 
> > > Problem
> > > ===
> > > (1)
> > > In Michael's series "KVM: gmem: 2MB THP support and preparedness tracking
> > > changes" [4], kvm_gmem_get_pfn() was modified to rely on the filemap
> > > invalidation lock for protecting its preparedness tracking. Similarly, the
> > > in-place conversion version of guest_memfd series by Ackerly also requires
> > > kvm_gmem_get_pfn() to acquire filemap invalidation lock [5].
> > > 
> > > kvm_gmem_get_pfn
> > >     filemap_invalidate_lock_shared(file_inode(file)->i_mapping);
> > > 
> > > However, since kvm_gmem_get_pfn() is called by kvm_tdp_map_page(), which is
> > > in turn invoked within kvm_gmem_populate() in TDX, a deadlock occurs on the
> > > filemap invalidation lock.
> > 
> > Bringing the prior discussion over to here: it seems wrong that
> > kvm_gmem_get_pfn() is getting called within the kvm_gmem_populate()
> > chain, because:
> > 
> > 1) kvm_gmem_populate() is specifically passing the gmem PFN down to
> >    tdx_gmem_post_populate(), but we are throwing it away to grab it
> >    again kvm_gmem_get_pfn(), which is then creating these locking issues
> >    that we are trying to work around. If we could simply pass that PFN down
> >    to kvm_tdp_map_page() (or some variant), then we would not trigger any
> >    deadlocks in the first place.
> 
> Yes, doing kvm_mmu_faultin_pfn() in tdx_gmem_post_populate() is a major flaw.
> 
> > 2) kvm_gmem_populate() is intended for pre-boot population of guest
> >    memory, and allows the post_populate callback to handle setting
> >    up the architecture-specific preparation, whereas kvm_gmem_get_pfn()
> >    calls kvm_arch_gmem_prepare(), which is intended to handle post-boot
> >    setup of private memory. Having kvm_gmem_get_pfn() called as part of
> >    kvm_gmem_populate() chain brings things 2 things in conflict with
> >    each other, and TDX seems to be relying on that fact that it doesn't
> >    implement a handler for kvm_arch_gmem_prepare(). 
> > 
> > I don't think this hurts anything in the current code, and I don't
> > personally see any issue with open-coding the population path if it doesn't
> > fit TDX very well, but there was some effort put into making
> > kvm_gmem_populate() usable for both TDX/SNP, and if the real issue isn't the
> > design of the interface itself, but instead just some inflexibility on the
> > KVM MMU mapping side, then it seems more robust to address the latter if
> > possible.
> > 
> > Would something like the below be reasonable? 
> 
> No, polluting the page fault paths is a non-starter for me.  TDX really shouldn't
> be synthesizing a page fault when it has the PFN in hand.  And some of the behavior
> that's desirable for pre-faults looks flat out wrong for TDX.  E.g. returning '0'
> on RET_PF_WRITE_PROTECTED and RET_PF_SPURIOUS (though maybe spurious is fine?).
> 
> I would much rather special case this path, because it absolutely is a special
> snowflake.  This even eliminates several exports of low level helpers that frankly
> have no business being used by TDX, e.g. kvm_mmu_reload().

I'm not quite following what the code below is for.  Is it an addition to
Yan's patch to eliminate the use of kvm_gmem_populate() from TDX?
I don't see how this code helps with the lock invalidation so I think we
still need Yan's patch, correct?

From a higher level, as Yan said, TDX does not need to prepare folios.  So
the elimination of the use of kvm_gmem_populate() makes more sense to me.

Ira

> 
> ---
>  arch/x86/kvm/mmu.h         |  2 +-
>  arch/x86/kvm/mmu/mmu.c     | 78 ++++++++++++++++++++++++++++++++++++--
>  arch/x86/kvm/mmu/tdp_mmu.c |  1 -
>  arch/x86/kvm/vmx/tdx.c     | 24 ++----------
>  4 files changed, 78 insertions(+), 27 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index b4b6860ab971..9cd7a34333af 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -258,7 +258,7 @@ extern bool tdp_mmu_enabled;
>  #endif
>  
>  bool kvm_tdp_mmu_gpa_is_mapped(struct kvm_vcpu *vcpu, u64 gpa);
> -int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level);
> +int kvm_tdp_mmu_map_private_pfn(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn);
>  
>  static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
>  {
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6e838cb6c9e1..bc937f8ed5a0 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4900,7 +4900,8 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  	return direct_page_fault(vcpu, fault);
>  }
>  
> -int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level)
> +static int kvm_tdp_prefault_page(struct kvm_vcpu *vcpu, gpa_t gpa,
> +				 u64 error_code, u8 *level)
>  {
>  	int r;
>  
> @@ -4942,7 +4943,6 @@ int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level
>  		return -EIO;
>  	}
>  }
> -EXPORT_SYMBOL_GPL(kvm_tdp_map_page);
>  
>  long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>  				    struct kvm_pre_fault_memory *range)
> @@ -4978,7 +4978,7 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>  	 * Shadow paging uses GVA for kvm page fault, so restrict to
>  	 * two-dimensional paging.
>  	 */
> -	r = kvm_tdp_map_page(vcpu, range->gpa | direct_bits, error_code, &level);
> +	r = kvm_tdp_prefault_page(vcpu, range->gpa | direct_bits, error_code, &level);
>  	if (r < 0)
>  		return r;
>  
> @@ -4990,6 +4990,77 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>  	return min(range->size, end - range->gpa);
>  }
>  
> +int kvm_tdp_mmu_map_private_pfn(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
> +{
> +	struct kvm_page_fault fault = {
> +		.addr = gfn_to_gpa(gfn),
> +		.error_code = PFERR_GUEST_FINAL_MASK | PFERR_PRIVATE_ACCESS,
> +		.prefetch = true,
> +		.is_tdp = true,
> +		.nx_huge_page_workaround_enabled = is_nx_huge_page_enabled(vcpu->kvm),
> +
> +		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
> +		.req_level = PG_LEVEL_4K,
> +		.goal_level = PG_LEVEL_4K,
> +		.is_private = true,
> +
> +		.gfn = gfn,
> +		.slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn),
> +		.pfn = pfn,
> +		.map_writable = true,
> +	};
> +	struct kvm *kvm = vcpu->kvm;
> +	int r;
> +
> +	lockdep_assert_held(&kvm->slots_lock);
> +
> +	if (KVM_BUG_ON(!tdp_mmu_enabled, kvm))
> +		return -EIO;
> +
> +	if (kvm_gfn_is_write_tracked(kvm, fault.slot, fault.gfn))
> +		return -EPERM;
> +
> +	r = kvm_mmu_reload(vcpu);
> +	if (r)
> +		return r;
> +
> +	r = mmu_topup_memory_caches(vcpu, false);
> +	if (r)
> +		return r;
> +
> +	do {
> +		if (signal_pending(current))
> +			return -EINTR;
> +
> +		if (kvm_test_request(KVM_REQ_VM_DEAD, vcpu))
> +			return -EIO;
> +
> +		cond_resched();
> +
> +		guard(read_lock)(&kvm->mmu_lock);
> +
> +		r = kvm_tdp_mmu_map(vcpu, &fault);
> +	} while (r == RET_PF_RETRY);
> +
> +	if (r != RET_PF_FIXED)
> +		return -EIO;
> +
> +	/*
> +	 * The caller is responsible for ensuring that no MMU invalidations can
> +	 * occur.  Sanity check that the mapping hasn't been zapped.
> +	 */
> +	if (IS_ENABLED(CONFIG_KVM_PROVE_MMU)) {
> +		cond_resched();
> +
> +		scoped_guard(read_lock, &kvm->mmu_lock) {
> +			if (KVM_BUG_ON(!kvm_tdp_mmu_gpa_is_mapped(vcpu, fault.addr), kvm))
> +				return -EIO;
> +		}
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(kvm_tdp_mmu_map_private_pfn);
> +
>  static void nonpaging_init_context(struct kvm_mmu *context)
>  {
>  	context->page_fault = nonpaging_page_fault;
> @@ -5973,7 +6044,6 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
>  out:
>  	return r;
>  }
> -EXPORT_SYMBOL_GPL(kvm_mmu_load);
>  
>  void kvm_mmu_unload(struct kvm_vcpu *vcpu)
>  {
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 7f3d7229b2c1..4f73d5341ebe 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1953,7 +1953,6 @@ bool kvm_tdp_mmu_gpa_is_mapped(struct kvm_vcpu *vcpu, u64 gpa)
>  	spte = sptes[leaf];
>  	return is_shadow_present_pte(spte) && is_last_spte(spte, leaf);
>  }
> -EXPORT_SYMBOL_GPL(kvm_tdp_mmu_gpa_is_mapped);
>  
>  /*
>   * Returns the last level spte pointer of the shadow page walk for the given
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index f4d4fd5cc6e8..02142496754f 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -3170,15 +3170,12 @@ struct tdx_gmem_post_populate_arg {
>  static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>  				  void __user *src, int order, void *_arg)
>  {
> -	u64 error_code = PFERR_GUEST_FINAL_MASK | PFERR_PRIVATE_ACCESS;
> -	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
>  	struct tdx_gmem_post_populate_arg *arg = _arg;
> -	struct kvm_vcpu *vcpu = arg->vcpu;
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	u64 err, entry, level_state;
>  	gpa_t gpa = gfn_to_gpa(gfn);
> -	u8 level = PG_LEVEL_4K;
>  	struct page *src_page;
>  	int ret, i;
> -	u64 err, entry, level_state;
>  
>  	/*
>  	 * Get the source page if it has been faulted in. Return failure if the
> @@ -3190,24 +3187,10 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>  	if (ret != 1)
>  		return -ENOMEM;
>  
> -	ret = kvm_tdp_map_page(vcpu, gpa, error_code, &level);
> +	ret = kvm_tdp_mmu_map_private_pfn(arg->vcpu, gfn, pfn);
>  	if (ret < 0)
>  		goto out;
>  
> -	/*
> -	 * The private mem cannot be zapped after kvm_tdp_map_page()
> -	 * because all paths are covered by slots_lock and the
> -	 * filemap invalidate lock.  Check that they are indeed enough.
> -	 */
> -	if (IS_ENABLED(CONFIG_KVM_PROVE_MMU)) {
> -		scoped_guard(read_lock, &kvm->mmu_lock) {
> -			if (KVM_BUG_ON(!kvm_tdp_mmu_gpa_is_mapped(vcpu, gpa), kvm)) {
> -				ret = -EIO;
> -				goto out;
> -			}
> -		}
> -	}
> -
>  	ret = 0;
>  	err = tdh_mem_page_add(&kvm_tdx->td, gpa, pfn_to_page(pfn),
>  			       src_page, &entry, &level_state);
> @@ -3267,7 +3250,6 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
>  	    !vt_is_tdx_private_gpa(kvm, region.gpa + (region.nr_pages << PAGE_SHIFT) - 1))
>  		return -EINVAL;
>  
> -	kvm_mmu_reload(vcpu);
>  	ret = 0;
>  	while (region.nr_pages) {
>  		if (signal_pending(current)) {
> 
> base-commit: 6c7ecd725e503bf2ca69ff52c6cc48bb650b1f11
> --



