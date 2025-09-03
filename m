Return-Path: <kvm+bounces-56681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2917B41AB6
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 11:54:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 45FD1544E50
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 09:54:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3C0D2EA154;
	Wed,  3 Sep 2025 09:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WCpJ9HP/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574AA2E7BB6;
	Wed,  3 Sep 2025 09:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756893169; cv=fail; b=X/wwz+kVDuk3fVlBkLesLBwADaXAFjkewb3UbxUUaKU6nkMECvhDEydrqRT816J3WiYgl/PHCwKF/3Fofnzjq72ZOzMywAx2S5h2PvrnV1b+QeRr46StA//pL4qCTLv7oYjv7sTlbsuP2FSYovsua/sKwCHiUNrAjIM8mY/G3ew=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756893169; c=relaxed/simple;
	bh=z/+nNAiqypswTTygRY1XTjMHFFD07tyGAugfRaSRnZQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IM2N6ztkK5N5nFc2pqpks6wRH0olis2B1qUiIrbQUvjQrEGjp0QZ+cyURaXQ890TrU2vryhD3ZL4zga2vu+4Q1LUKetOEcY3K4E8PGgHBt5+PCLtDLtLpPNOT9ryiobAfciowgI5oEnr5HS2sqJKLSP6hxYFnxaSVisXWB3H+jA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WCpJ9HP/; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756893168; x=1788429168;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=z/+nNAiqypswTTygRY1XTjMHFFD07tyGAugfRaSRnZQ=;
  b=WCpJ9HP/Wz4idLmG+2ZRB9ZJ0UEluHb/Eneu2rT7guTnDJQqClOwqZNK
   f/+h0GDMq2sUIchbuJV6iBQD0fhXOTBud23+Dz2kstTtAtV5e6TmBNy5Q
   S5lhc5huSEaq7jVgfJgMihdztDBiczeczYevtOlNMdo9I9Lxn4MCqirmz
   PGjxr+Xu51XWkRcdcbvh0xNpX5cpTLg29L2SIzXzTgJ1fhH3e4F9fyx1e
   rhgutYfbvJa/8NI7O9aaXxIHmwpbYqJjBD02wno3yTwVYNTTpWRdQGDo8
   TjJO3yhn5aZzPY1AI3TFvB4U+Z3vde/7m/I58TkHqpr2z0dmnbLF7lGM5
   Q==;
X-CSE-ConnectionGUID: H7oedgx1R0iF4YWcKIBmbw==
X-CSE-MsgGUID: Lf/zoWrlTQSyzk1pVlOXWQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="76642863"
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="76642863"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2025 02:52:47 -0700
X-CSE-ConnectionGUID: pD5CNFFzT02n235osoUmNQ==
X-CSE-MsgGUID: JNwzvRODRGOl5ycCIg5aVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="176793707"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2025 02:52:46 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 3 Sep 2025 02:52:45 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 3 Sep 2025 02:52:45 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.42) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 3 Sep 2025 02:52:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j2pSusPjLkfipfQUzk4PzhRLQ5Dxep2K9objleaysoP+JbyqPRU5n3xehw49MC17lRiQjwCnbcTLhcf7os8gPqYMWJ8FBJMYdxklFbiWpyJig699ieGJtsFhs5bzBIZI1DVIiWflprI5VzPxas66WEkMKEoRDQG2JGlx7sj0GiQ4X+OdX7CdwJdD6WRZP1LaA+xy6j2DaSkq4Q2u9uuC0ZC8nTf5svq82ocz27LPfti/UF+aV2HEzSfoL5hMACh/8oTFzzHiIeu7U3gbGZoE08QHqcZ25ab7BJfwAhSXFga9QuQtwm1cy9sERPQOrj43lGI1fZ23D+wuTVl4bWX5oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VkLa8gGLacms+GUl1hb8gm+zx8p9IkcINaIVOko0WjE=;
 b=Lm4TYCvc2SEizBJJE9koRINjJW/3UuuUnN7UtyzPtENChqKB92iiXFRkz/MtpmgVUcRSa+UIuNC+QSjrVrdUkRFP2/tFCQ4Ta6ETcd963XV6/KPLMGP9JUPtsSJMSg55Wge07v+vAnK8g3BJx3xHqtmmr3CYAXv2KYspJbIftO31v6KgBmDyqve43lWwlJEKE1FXqGME1mlJzNaH2e2sQH3SmqO2cB72WBp3yViLkpd5/GTlH14CLhzN4pSpcHIOoAYt+SyFuVyOkCeyA4YgaDUK+t3k5SGeP5c05vfTZheH6hVMQSSZidaOMMs8f1BlhJp7nNH7d9YTTMLCkgmakg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM4PR11MB5996.namprd11.prod.outlook.com (2603:10b6:8:5f::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9073.27; Wed, 3 Sep 2025 09:52:43 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9073.026; Wed, 3 Sep 2025
 09:52:42 +0000
Date: Wed, 3 Sep 2025 17:51:45 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>, <kas@kernel.org>,
	<tabba@google.com>, <ackerleytng@google.com>, <quic_eberman@quicinc.com>,
	<michael.roth@amd.com>, <david@redhat.com>, <vannapurve@google.com>,
	<vbabka@suse.cz>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<zhiquan1.li@intel.com>, <fan.du@intel.com>, <jun.miao@intel.com>,
	<ira.weiny@intel.com>, <isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>,
	<chao.p.peng@intel.com>
Subject: Re: [RFC PATCH v2 04/23] KVM: TDX: Introduce tdx_clear_folio() to
 clear huge pages
Message-ID: <aLgPsZ6PxGVqmeZl@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094214.4495-1-yan.y.zhao@intel.com>
 <04d6d306-b495-428f-ac3a-44057fd6ccfc@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <04d6d306-b495-428f-ac3a-44057fd6ccfc@linux.intel.com>
X-ClientProxiedBy: SI1PR02CA0049.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::18) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM4PR11MB5996:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b98f1d0-5179-4b09-1b2d-08ddeacfa04c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?qgNy0I+Hb5tc0JA8Yts/SOkacYq92rKy6+UHTzsXehbrMiLEUhIhxRFyGCHZ?=
 =?us-ascii?Q?PoctNu3Jk99yfaOqV+sDf4+/GaEfPvh+r1sTBloL+lRU2aGLYSjc8LVbMjl6?=
 =?us-ascii?Q?yF2RhnKtXQRjNRilblpKYuqLXNj/e9sV/zmv0wS7akoyMjM6XKPplE2qMOxv?=
 =?us-ascii?Q?0YMc80U0WM7kn1IFWkxP1SjGhAZaRpG5Z2FaRKMF1MyfKrgwF/e0N3lCKGc7?=
 =?us-ascii?Q?k2m2fQm/De3rkLm/RUx1g4eCCv3FKKghkzzpW6cW+tD5uK9bv69oSTKMQfWX?=
 =?us-ascii?Q?1+/1f9HPRsA5dD42q1AR3dt6VE2ns6vdxK9LHOncBWI2qrtiaIBkNsk2TdfG?=
 =?us-ascii?Q?92D8x1mlzHIPZiso126MF2SW/qggnzXN/FzFKGpppBYH7PgFp1Phcjq+31dr?=
 =?us-ascii?Q?lNIh9xpS1G4rSDW7W5i6T5ljzRs+TlLK0eoqaN5IDIzH3oCONR/TgcJx+J6M?=
 =?us-ascii?Q?4rHwA9dhbsSppuF6Zd7T//0QBpRjx5uQKN4JF/bGHP1pi1umEsGoMuZN/2Wl?=
 =?us-ascii?Q?UFVrMMYSlQ1RkxBRCX0LWI4p+qb4KRrkLrTZPQcMyrfh6CBu2U0Zl+8S7/Qp?=
 =?us-ascii?Q?YqiE7KfVuamt9qb66AwU+vs/IaP89PS9Z9FOsFytfvve9+pb9gcVzxSzNmM8?=
 =?us-ascii?Q?ozMZ88ylWLfFQraAfFreI+qa8MzhesCX7ls/NyeGtqJiNptqtsPuBvTJKAuA?=
 =?us-ascii?Q?AZBTaERgmV2/EEMeyZO14BZIZM3o1Sph7kXlCdhMbioLtIQF3Psai9CtM5V1?=
 =?us-ascii?Q?iPm5uMCqwajfK79qXdUQmz0uKn1t0wHzUyxGGbpJuRG51UrWOk++UbxmJcq6?=
 =?us-ascii?Q?VuWSaXsRhbLhv0j9XfRr7sMd+0NffUpEz1w8nFZiWDMGaOKb/xPVwEPVflv+?=
 =?us-ascii?Q?XxIDIjJRBAb+wBUpZ03Fdp9hG/Ms+zjZRYl1ZbyRQ9I48iRrNJilth2xaDoR?=
 =?us-ascii?Q?JiMPRmhEvGWNJXgPdSxYYXQ64dqf2aOjDvZmh/Cn93fsaSoF377bjcOUwS1/?=
 =?us-ascii?Q?E1ESxa17Eo+OlMB7XwSorIMsUzOxQee/zF0v3uZxZLvguiJHGgHUvCzCFTzb?=
 =?us-ascii?Q?mvZouWEIeKIa4Gj+WmOIJQJJ6QNk288hbz0j2FWYZO2fLwYGdb/6D0x4Yopf?=
 =?us-ascii?Q?n2wJvkWHPbL4jHXZ42G0Y6XJ4FfPkHN0tZ9gCrXIOMXCzrvApiVVPsFdkfz7?=
 =?us-ascii?Q?ZLamVNhelfoOd6SN3b9NxjqJIf23AoIGRjGkmo4hX+o0Oql1jSh+jIP0xpiB?=
 =?us-ascii?Q?XZJV7xMIJndriXiseqrnKEPKzby+wBG/iKWcC8U1aImSAvZnVxmSM1R5ZLpl?=
 =?us-ascii?Q?vThOJbl+m+AaqVTHxt9BwnQVYSttq7KqPZUhESk8Ct5yoKuhNNE0IPTcKbsb?=
 =?us-ascii?Q?3ulVg6ce8fPc5HKj9AKOHNAOl1igZxMNxENMQA5+j4S3pi0tMwOjHXBs8U0k?=
 =?us-ascii?Q?OWBvAF5Qbh4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7kNWxaDleuQRo6TBBbArX3FOg38Csiot6YP1YkjZMaAxzt4aBgqfwgIrCc1g?=
 =?us-ascii?Q?7e4xn5Rp7cp2wG1E3e8Wt6TXazJNmpKNPP2SVLlTDgKqhuIkY9sJHB0ceM5i?=
 =?us-ascii?Q?RliZn7a6CKFh8F29YCPJbYMPsgBx5Cmt+R0FU3/5AzAVnPKU3hrbmwQ7z2wf?=
 =?us-ascii?Q?O/SROcaeRSXd0hsPEzDne7V1TxiTMP8DE5NxzhmDtTdakNSahDIPP+k4wm+B?=
 =?us-ascii?Q?16hWW0vYMR3oydJAN7944bMLEtjpBVdZXINv6+t34aJZ0OEAhVQ9df4eNNNj?=
 =?us-ascii?Q?9IzNV8VjiXmoUNM6mykhq4KyLA4XGL3VsX8828P5sl3QGjriTf3I0ubwOeAk?=
 =?us-ascii?Q?4YdB21ExGVm9vhmuYLRQI1wbs8sAu+VIAyfg9EPkI15JiwHNIGRRRKnRn3SV?=
 =?us-ascii?Q?wXe7lKAs1KUDd8MnsbtzSjozXSRx80iVI5qzAE02dOufv/Dk4PGGX7rbXcvB?=
 =?us-ascii?Q?NQ3/lVI4KRQERq7BX9KifvQFRSV6aX7mFEdvcWe/vIs+l5GL3ndUTGrQ39Jx?=
 =?us-ascii?Q?3F/QjQ6z5d2w3+qlaCEdbT5wWcPM+vkdHaHcXHjD8tcC1Zs1fV/ZAlno+0JD?=
 =?us-ascii?Q?GAIIOeRsUeB3+y02n5cuLbdTwILIzqJIEBCkz7cyBoaoQOzkwbQrpObD8gTm?=
 =?us-ascii?Q?w0GBVZ0n/gLCFnjVGUJHPwjNhRy6nSwkRMHgL2ZZQUwG06YGynuX3oeHtgof?=
 =?us-ascii?Q?OU6FJzgRixAGjeLFa+yOh6LCQJkxDCfrJLa+fNfC/thVpfxwjICAmD1NAJUO?=
 =?us-ascii?Q?ZFZRyxwjKKuq6VLLxA/VoydUszZYRZ3hfLnQn7yGpRNt1TyKvk9jmFpdGKeu?=
 =?us-ascii?Q?j3YZJ8x11sQBoPvPTlspllfSsHQaikvPIZCSEhJU4/c9pw+bUae5IG6RulwB?=
 =?us-ascii?Q?3xAIG6OFbEI843fVamhO6HAU3tM/L9XQQe3+5H5JDxaur5sfTyyseu3QrIGU?=
 =?us-ascii?Q?arOO4nglUjisGZHCLAN91yI8L7qxdpqDG2P9RAlsTLeo6MuSGqHesOBflvIq?=
 =?us-ascii?Q?4LKir0N8d8JcSy+X61x0nDYsmNy4X4ynncsqc2XCexLgZPWs9s8TJcT0FHp8?=
 =?us-ascii?Q?5z0CilXspwaYAEKxJ3YMEvN59P7zkhHRieX9930px5CjvtIlsC1wJriUyuPp?=
 =?us-ascii?Q?1s35N1E9vA3yxk211RIFdXjPXRBbnGBAHzqEtRqkwfPqUGMfzKIKc1jsFudT?=
 =?us-ascii?Q?HWLiZyF5VqDdAGaFSZ88p1AAfniBVldBWiJgCvN+ogLdUlLJminaMR4om84k?=
 =?us-ascii?Q?UizrMwBGMkERNtk49FbiohH7Or67WDrgivuydohCnmbVQ39Bet4bAJCnemGz?=
 =?us-ascii?Q?qpCrFqWNm67fH3UnrTQ8CMIaMl7IGJEOGaKk7NpoIb9gVM3aqfTSGwsrpyHX?=
 =?us-ascii?Q?Zkwd0Qi8gyQtjYKEWcJXrnO8H/N55pUfTqs0h4mL3IgW48KItG4SMzkh7PiJ?=
 =?us-ascii?Q?b0T0PemKNAbBqck00dZ/bP6Dcwo1/8W9HsX6URfBS99izLax4h3fhRtsqHgc?=
 =?us-ascii?Q?5vl2S+H1vWq92rSe25M1P8sfzwhRlXg/VjpWmz1ZJN4eXfOvgM8OxzX4hkQ9?=
 =?us-ascii?Q?nmKstGHcoPxKkyMh0JLr7fxeu5w4PUYwquhzug3F?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b98f1d0-5179-4b09-1b2d-08ddeacfa04c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 09:52:42.6820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IzLRsEFANzdcGU2XdfyWX7lNmtO1efiIIU9D+Hh6y7ct84iJMNqdBKwJGwc7zZeYP+MIwJZKUBT3DtOvf2Om1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5996
X-OriginatorOrg: intel.com

On Tue, Sep 02, 2025 at 10:56:25AM +0800, Binbin Wu wrote:
> 
> 
> On 8/7/2025 5:42 PM, Yan Zhao wrote:
> > After removing or reclaiming a guest private page or a control page from a
> > TD, zero the physical page using movdir64b(), enabling the kernel to reuse
> > the pages.
> > 
> > Introduce the function tdx_clear_folio() to zero out physical memory using
> > movdir64b(), starting from the page at "start_idx" within a "folio" and
> > spanning "npages" contiguous PFNs.
> > 
> > Convert tdx_clear_page() to be a helper function to facilitate the
> > zeroing of 4KB pages.
> 
> I think this sentence is outdated?
No? tdx_clear_page() is still invoked to clear tdr_page.

> > 
> > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> > RFC v2:
> > - Add tdx_clear_folio().
> > - Drop inner loop _tdx_clear_page() and move __mb() outside of the loop.
> >    (Rick)
> > - Use C99-style definition of variables inside a for loop.
> > - Note: [1] also changes tdx_clear_page(). RFC v2 is not based on [1] now.
> > 
> > [1] https://lore.kernel.org/all/20250724130354.79392-2-adrian.hunter@intel.com
> > 
> > RFC v1:
> > - split out, let tdx_clear_page() accept level.
> > ---
> >   arch/x86/kvm/vmx/tdx.c | 22 ++++++++++++++++------
> >   1 file changed, 16 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 8eaf8431c5f1..4fabefb27135 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -277,18 +277,21 @@ static inline void tdx_disassociate_vp(struct kvm_vcpu *vcpu)
> >   	vcpu->cpu = -1;
> >   }
> > -static void tdx_clear_page(struct page *page)
> > +static void tdx_clear_folio(struct folio *folio, unsigned long start_idx,
> > +			    unsigned long npages)
> >   {
> >   	const void *zero_page = (const void *) page_to_virt(ZERO_PAGE(0));
> > -	void *dest = page_to_virt(page);
> > -	unsigned long i;
> >   	/*
> >   	 * The page could have been poisoned.  MOVDIR64B also clears
> >   	 * the poison bit so the kernel can safely use the page again.
> >   	 */
> > -	for (i = 0; i < PAGE_SIZE; i += 64)
> > -		movdir64b(dest + i, zero_page);
> > +	for (unsigned long j = 0; j < npages; j++) {
> > +		void *dest = page_to_virt(folio_page(folio, start_idx + j));
> > +
> > +		for (unsigned long i = 0; i < PAGE_SIZE; i += 64)
> > +			movdir64b(dest + i, zero_page);
> > +	}
> >   	/*
> >   	 * MOVDIR64B store uses WC buffer.  Prevent following memory reads
> >   	 * from seeing potentially poisoned cache.
> > @@ -296,6 +299,13 @@ static void tdx_clear_page(struct page *page)
> >   	__mb();
> >   }
> > +static inline void tdx_clear_page(struct page *page)
> No need to tag a local static function with "inline".
Ok.


