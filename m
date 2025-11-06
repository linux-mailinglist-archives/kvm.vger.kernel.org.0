Return-Path: <kvm+bounces-62145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 66B6AC38DC0
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 03:25:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AB9A918C7F9A
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 02:25:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC41621E0BB;
	Thu,  6 Nov 2025 02:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fI8Kszjb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750FF18DF9D;
	Thu,  6 Nov 2025 02:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762395865; cv=fail; b=FMMklIjdrad6H7EZe7hE9nIFjmFwnOWvx6XvtaZMoktkSe7f8izoH/PAekBpJiZHgT91sYLiy13eCXt4vgl5aaeDTKHe4M+w6B1MQwo16XixChz4B7iVBm4nkZVFN//LgvkjNzMyvj+mS0MVgBHYUxYSZs5eAlYWjsL4upSc0zM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762395865; c=relaxed/simple;
	bh=JvkL4M/uOoJuefMZTPptDFCGEQDF3cJa8SwRaQGHKz4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ur7h0KYpZJUowxoTKIhuNtsz5uySizXHXz33dO0NIK5YtNTWhuDTc5aCZv3Zy8BIkp22A1UgPa8L+n6uSsuD940J1Agj/aC4RJdgxPcWPIfnVZZyjSNF48kA51Yi8bokxJpt5J7LIGJ01E/PSGSKPORUj4nwgbh9P6hPg3mOIfg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fI8Kszjb; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762395863; x=1793931863;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=JvkL4M/uOoJuefMZTPptDFCGEQDF3cJa8SwRaQGHKz4=;
  b=fI8KszjbZVUM4e3lYMNueyXPaCgMkytRlCuUR30/CcaiMXc1s0BNl6rk
   KqaAFF+1iEKCQxY9KlTe7FAe7mYr8GF2WLw3zI8tG3am590QfypiORt+S
   Yer9yFd/sW9io4RT36c7ORTb6PWFbxmQ3gSFo7UOWSxlGV9XYesgdXEVt
   md3I5+SNt6FEM0tQFDYYLoKzST5n4KTD+K4YvyFAFqgbtXD4HkZzN0bIL
   C75NST8m41ZMDrZXFvIfPHtFrC8/MNXsxNhdejGcY+WO7A4P0BH3pD+1u
   5OX5BkU8yHDRI8TNsvRys2Ql6fvTDC92L1PQMhDNddmKSEJDGJdlytf+Y
   w==;
X-CSE-ConnectionGUID: +J8Rmn3pTJ2HA/V1r5CzIA==
X-CSE-MsgGUID: jsH91WktTr+iM+l9I8MP/Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11604"; a="64221497"
X-IronPort-AV: E=Sophos;i="6.19,283,1754982000"; 
   d="scan'208";a="64221497"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 18:24:22 -0800
X-CSE-ConnectionGUID: Zfhhwg8xTreduE0IpvQaKg==
X-CSE-MsgGUID: RamX2LNURbOFq3Ux13juIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,283,1754982000"; 
   d="scan'208";a="186916968"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 18:24:21 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 5 Nov 2025 18:24:21 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 5 Nov 2025 18:24:21 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.17) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 5 Nov 2025 18:24:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vr9Hv9ARFpDv+cYB+H6zGr2Th9WR1fa5fjzIuZlIwQXiugAdA0Ay5AOu1Ap3rp7i1RcsypauRNVvDxX1WzmMdaA2zf0SPRC9SCfDgAcoIGDNVD1iI64B/sITox0rMZKfRM4pAaJJ5rwLAWYEX7XSIYVpCP+h29CqRLQTBL5ZsLfCwkgxfRWCKjepjTvYeDwDgRKiJcV3+aFTpnyDW9AlQlRwJP5s8LBVd77Z1ygBGO0/BgfDfurty/6D5ZDj7bZ6A0iAcPDGQIQOVaBsIEdZJUKgBaFCw1cA3p0u/LLoRZ2udz8hFDIrh++JMH55fBbCNmNW7I1Kxq6fUhaOpjEZpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gzibx/aUN5y1gYQwBFUu28LEMmXIXijvHnvoaLFOA7U=;
 b=LJtCSpcoB/o4Giot0Ne0yPJMLPZt305wjuOBxEANOawljdAiAROI5R2j31yWI8hF32IwNx5hh9dA0daaNjswv+hMpsVRUcwmuFKEDEXc/Y+wfwg2Mr4pRgHThMzHNW6t7RAKZGLUjK04uhQRMk//oR0qDGwyCR02nHbMG9IDGdvRWHaWRrEFk5yu8UxzFcTvD/MF4mYdSuDvUElAEyBRCCUGaM122/5Bhnusj4lHyzctlHvXrXuWraUhXglnF4bLqIWMsouXid59M59FQNZiLl2FbmE1MwfkYr+x1LV/4fY9H0iW/HqvyX8C5cOjzS39PdyPL50U6A8WrXZbj+YdeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MW3PR11MB4747.namprd11.prod.outlook.com (2603:10b6:303:2f::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9298.9; Thu, 6 Nov 2025 02:24:18 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9275.015; Thu, 6 Nov 2025
 02:24:17 +0000
Date: Thu, 6 Nov 2025 10:22:17 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>,
	<kvm@vger.kernel.org>, <x86@kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Hou Wenlong <houwenlong.hwl@antgroup.com>
Subject: Re: [PATCH v5 1/4] KVM: TDX: Explicitly set user-return MSRs that
 *may* be clobbered by the TDX-Module
Message-ID: <aQwGWXmu0a72m1RE@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20251030191528.3380553-1-seanjc@google.com>
 <20251030191528.3380553-2-seanjc@google.com>
 <aQhJol0CvT6bNCJQ@yzhao56-desk.sh.intel.com>
 <aQmmBadeFp/7CDmH@yzhao56-desk.sh.intel.com>
 <969d1b3a-2a82-4ff1-85c5-705c102f0f8b@intel.com>
 <aQnH3EmN97cAKDEO@yzhao56-desk.sh.intel.com>
 <aQo-KhJ9nb0MMAy4@google.com>
 <aQqt2s/Xv4jtjFFE@yzhao56-desk.sh.intel.com>
 <6ca6f19e-0bdd-4ad8-aaca-93a1247d2588@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6ca6f19e-0bdd-4ad8-aaca-93a1247d2588@intel.com>
X-ClientProxiedBy: KL1P15301CA0049.APCP153.PROD.OUTLOOK.COM
 (2603:1096:820:3d::6) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MW3PR11MB4747:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c092626-2c2d-4843-52d7-08de1cdb95be
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?1xpXUAz74sp4eWMzvTcr3lMWL0KHIiNXkUBpDw238y2uIhwcHE/O6ystWZ6F?=
 =?us-ascii?Q?BdSBNxmxXafqBM4c3IcvUPzZvDxLxvLz0f1MwQgEiJCXvIjR1W+DQVRRNVQe?=
 =?us-ascii?Q?7tcn8u3Jvdit8yUxRiLwpefnFj+dtUn0QS5pwl10P1XQkAv3+tXbLfS3smQy?=
 =?us-ascii?Q?qYsWX38iR81z9xksdoSDf3M1OvFyQe9XlvlF77BEqOVDq88vLATXD9fGvVMr?=
 =?us-ascii?Q?mMG1p3mEj8miYpA7KDUiwICK7Zf17tqDQ2yJfYhKny77G/xcZ3EnT36fxbJM?=
 =?us-ascii?Q?XJBneV+rmxmp6uvBHSsYg+8sjQjIxMfpuVlsGwzV8aTPCbYiz77KMKXLq1IX?=
 =?us-ascii?Q?s5YGAnP/gDy+HJMsgHeSueFCyOWTiWYAW6D3OFZS3psk5VyXci7pzmnhsx38?=
 =?us-ascii?Q?VXuynMHUceypYPsn1mtRThtLBkIi+kYwfkencTyBVfxrkGlnj2V1oQ2QLmSR?=
 =?us-ascii?Q?2uSUExhu8TmMuSla2Kjqatn92EpNt5OwPB57PQYIVZNKxd1bKeTDVfZ/y0Uh?=
 =?us-ascii?Q?bjYejyuTj+Bvc+Ce0IpNFVAyleEdSaYTpJ/nv9d1l4ycA31UG3+wWRvsM/W+?=
 =?us-ascii?Q?rwqKYNxUN6Lz/79n1wi2GUOxiKI8LUIHZR36YBCZZJP1Zh5hkdAEZ12EgFZw?=
 =?us-ascii?Q?l3vOUWZNkkKO2tNyMpQcnDKZ+r+QR3GcgJ8lmSUOnReZ+8RyLp1D4T0jXxJV?=
 =?us-ascii?Q?qEvX/DcOjKODyVC/PqBVvGsuo3U6wFo9mQAaTV0j3JYWwxvc6A1k1LskuJF1?=
 =?us-ascii?Q?4ZH0BgIpQWHiqLSMaHLA895BzGScBbmQBphvHCpdoeMY53wNwjB/VngaG8BZ?=
 =?us-ascii?Q?fSw2wRseuoBz40VJVJ69CbeJ0khe3HEvNhwMiY9xHD/JK7wb5xOcuSrUDZlu?=
 =?us-ascii?Q?uoneR/nh3SICVlzkJJEjlln1RckO4VpBSubssKQBLFGfnps+dyOwgWFzTVWW?=
 =?us-ascii?Q?R+nAVnoKPdjGe4K5NFsPde670BA+/7N5wlY31O/8g/7BGJzzig8O7WFTr7X5?=
 =?us-ascii?Q?IRgHUyHCMioifQZ3jDbVewEskaYJnpNi4rYUfiq/zt8ibT8OpeCZ3XY2YJul?=
 =?us-ascii?Q?Td/owKY0pq+RA162+oJQrFmEwtEUmJA1rjdJOQZDmzgu/s3Zj6bpY8oafU29?=
 =?us-ascii?Q?t0fY5gxiLRUOguvunV2ktvxZQOOMcBQFXZol86HAbDyEy3+0dgjRc+WJ/CHJ?=
 =?us-ascii?Q?LxDrEuxIsNU3SZaMM5p495+ibashuy/j9iaw9Brl0hoXGh7ALhyqat3EsDyJ?=
 =?us-ascii?Q?Gl56fv37LGezP+S4qAz3A5mZeLR36bLanWBV+ymGmgnRNwwxQf01+ggRyWSn?=
 =?us-ascii?Q?FQMZJ859ZZu9ni1CiEmEe6A5txJy+Lp5o2+IekHUfqNvZ09L36nIjLwRK5fD?=
 =?us-ascii?Q?SGk0cg1P8Xd+AnHR/viRTrgEYJwuqqZLXEzZW1pgFLGjnFLESR0SVOQZ7Tbz?=
 =?us-ascii?Q?ajwytDMo6F7NMwrnr7UB/odF+hA4yYRT?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f6s1SZRAuLePZ+ODxRWG8nuZkhu74+uEQx+NIFo3FUogygthyS+JyWqTZR6j?=
 =?us-ascii?Q?dLmxy+HwZBsZPLdcm1vPX72MtNwCgjDZTLwHCt6ChLc2zOQ9brZFBEsCw4YP?=
 =?us-ascii?Q?8x8htLgECEB29IsbHpkcXNN2/rgmXtvvEdkFi1d3/Iz3tBkICONQNZTiDAs9?=
 =?us-ascii?Q?/dSi7LFt0QbaEuvUZzJc4Q9nAO04Qu81kjx8inD7g6SkK2gXMpHoZXnc8f7y?=
 =?us-ascii?Q?39nw0ad/nONuDjZhspHQanoF/yW3u4HrMHKJF7ShR/Z0CkK4Ej7oF9q9W8Gc?=
 =?us-ascii?Q?ErAwazGV2OR+YeKpR4UTuU+fPH1QKXLaUIYUwbAkDlcNzkKXQz1J1KfJWutx?=
 =?us-ascii?Q?8onLEVAisjarKM+03xygw2aMfqAJW4zg5u127Q+BdTbcwFLddsvIg/ythBpX?=
 =?us-ascii?Q?q1E0HFucYJbhwqaKi2KNc+dhfac7NwTFlEABgOYglus+42YLRMES0Al4bDYi?=
 =?us-ascii?Q?J9BKEgXD55ljF/LsnDq6QRiMAk1x6rj6zEt7D0Un5BZYivO9Ea9Av2HgoPH9?=
 =?us-ascii?Q?R4GNjJi3l+Gt8bN23zCrK1NWHf0tc7oRef1jwagEkGj5locofN3sA4eaOOJT?=
 =?us-ascii?Q?NhYnx/EVUPDS1OX4MNGvVKOqMt/yBq0BHV28OEx/BBCLKgEEXKRbTPHzuI5u?=
 =?us-ascii?Q?9S0Y84wVx8LKeeyDRE8Bi+rrUDOaSDzGBVEfBs7NNCARI5yZreTbpMDArGKU?=
 =?us-ascii?Q?xdFjQBHbalz7tNl8/jY9t8UMYFrO8TwFobjsNPJ0ZCN7lIXd7u+S1BlHyJvs?=
 =?us-ascii?Q?3rQvjVQVqEbYLeEpuHxh/sra5NhgObe3caK66c1lXDAyUYTjfQObFReWqEPT?=
 =?us-ascii?Q?WFIYwkyE2fHQ8EQP995CZv9RDihd7UEyMJpjY3MRQUSvH0jZzTY+wMf51oml?=
 =?us-ascii?Q?HDkvwK5Wyq/z+9fst5gO06fF6G/MuT7yDkrDt7STsaUfPdjU1Tlyl+wUPi7q?=
 =?us-ascii?Q?B3lh6EmfP3pojUjOCuiwEfRmMepydHsERzgp4zWRPi1ZqV5LDIVNPJ2z16fd?=
 =?us-ascii?Q?Cbo+AVcph5of+txl+bT/QB2sSZ2Vh77+cyuovID+S8yWmSod8QSDJL8SpHMv?=
 =?us-ascii?Q?EQBC++Xb/2iXbyEwwk2KQeH72WG3VN2QUk1dNgbIO2nc7mJWyfHaVwUpeQZQ?=
 =?us-ascii?Q?VsFLRl2C4/WQhJxPtk4GV6avv0h00JwWWTddjOQcErKWE9XdOI2fabNSQjaH?=
 =?us-ascii?Q?FRytW06++ZsBa2ETDKUlM7Nlvq92l2CK3KpdMfZTqZ6kNT627VqlKQr6bJrb?=
 =?us-ascii?Q?RJ6fjLqKnEtWMib9Cii/d8UZmoGzd+A0Ib9p8sXkYajwfErZiWtFPVk/xG74?=
 =?us-ascii?Q?sw34TtfM7iL4A/Et1TGqZyfGskNkXIdbWQFiUmmqjAqCZ3rkH7TV3PdxKxox?=
 =?us-ascii?Q?ygWBAkFaVsufIIhWvbuoDkQkZAiaq+2BXJ+APwiUbuZIX5YsHTKbQVDWihTi?=
 =?us-ascii?Q?KEcxPhp5yLolS7dz37/I6o87KjJY4fISGZ6pTSgX45MOptmaCXcWPKVxrfZp?=
 =?us-ascii?Q?wa2KN11oYe+zaK8/hO2GusTa872zZa9QcaoAjDUjuQh0+AEm5N9M9ypV+DJU?=
 =?us-ascii?Q?Ymq/Yp6SJ7Q/WFJ48PQeVUqA/UFz4tGq3bkOdFvd?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c092626-2c2d-4843-52d7-08de1cdb95be
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2025 02:24:17.2041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wfpr6J3c5Lr7da8/QF6/21cERSsBGEAjNYwV/yJoqUM8Tgb9mFcbUqV6SqueGHrquFF1RgPDoO+aBTjtg2Wb7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4747
X-OriginatorOrg: intel.com

On Wed, Nov 05, 2025 at 05:16:56PM +0800, Xiaoyao Li wrote:
> On 11/5/2025 9:52 AM, Yan Zhao wrote:
> > On Tue, Nov 04, 2025 at 09:55:54AM -0800, Sean Christopherson wrote:
> > > On Tue, Nov 04, 2025, Yan Zhao wrote:
> > > > On Tue, Nov 04, 2025 at 04:40:44PM +0800, Xiaoyao Li wrote:
> > > > > On 11/4/2025 3:06 PM, Yan Zhao wrote:
> > > > > > Another nit:
> > > > > > Remove the tdx_user_return_msr_update_cache() in the comment of __tdx_bringup().
> > > > > > 
> > > > > > Or could we just invoke tdx_user_return_msr_update_cache() in
> > > > > > tdx_prepare_switch_to_guest()?
> > > > > 
> > > > > No. It lacks the WRMSR operation to update the hardware value, which is the
> > > > > key of this patch.
> > > > As [1], I don't think the WRMSR operation to update the hardware value is
> > > > necessary. The value will be updated to guest value soon any way if
> > > > tdh_vp_enter() succeeds, or the hardware value remains to be the host value or
> > > > the default value.
> > > 
> > > As explained in the original thread:
> > > 
> > >   : > If the MSR's do not get clobbered, does it matter whether or not they get
> > >   : > restored.
> > >   :
> > >   : It matters because KVM needs to know the actual value in hardware.  If KVM thinks
> > >   : an MSR is 'X', but it's actually 'Y', then KVM could fail to write the correct
> > >   : value into hardware when returning to userspace and/or when running a different
> > >   : vCPU.
> > > 
> > > I.e. updating the cache effectively corrupts state if the TDX-Module doesn't
> > > clobber MSRs as expected, i.e. if the current value is preserved in hardware.
> > I'm not against this patch. But I think the above explanation is not that
> > convincing, (or somewhat confusing).
> > 
> > 
> > By "if the TDX-Module doesn't clobber MSRs as expected",
> > - if it occurs due to tdh_vp_enter() failure, I think it's fine.
> >    Though KVM thinks the MSR is 'X', the actual value in hardware should be
> >    either 'Y' (the host value) or 'X' (the expected clobbered value).
> >    It's benign to preserving value 'Y', no?
> 
> For example, after tdh_vp_enter() failure, the state becomes
> 
>     .curr == 'X'
>     hardware == 'Y'
> 
> and the TD vcpu thread is preempted and the pcpu is scheduled to run another
> VM's vcpu, which is a normal VMX vcpu and it happens to have the MSR value
> of 'X'. So in
> 
>   vmx_prepare_switch_to_guest()
>     -> kvm_set_user_return_msr()
> 
> it will skip the WRMSR because written_value == .curr == 'X', but the
> hardware value is 'Y'. Then KVM fails to load the expected value 'X' for the
> VMX vcpu.
Oh. Thanks! I overlooked that there's another checking of .curr in
kvm_set_user_return_msr(). It explains why .curr must be equal to the hardware
value when outside guest mode.

> > - if it occurs due to TDX module bugs, e.g., if after a successful
> >    tdh_vp_enter() and VM exits, the TDX module clobbers the MSR to 'Z', while
> >    the host value for the MSR is 'Y' and KVM thinks the actual value is 'X'.
> >    Then the hardware state will be incorrect after returning to userspace if
> >    'X' == 'Y'. But this patch can't guard against this condition as well, right?
> > 
> > 
> > > > But I think invoking tdx_user_return_msr_update_cache() in
> > > > tdx_prepare_switch_to_guest() is better than in
> > > > tdx_prepare_switch_to_host().
> > > > 
> > > > [1] https://lore.kernel.org/kvm/aQhJol0CvT6bNCJQ@yzhao56-desk.sh.intel.com/
> 

