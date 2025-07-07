Return-Path: <kvm+bounces-51669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B7A9AFB536
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 15:51:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 903651644F9
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 13:51:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08F462BD598;
	Mon,  7 Jul 2025 13:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jGKQb6Un"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB511FCF41;
	Mon,  7 Jul 2025 13:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751896290; cv=fail; b=u0JR9TNdxIaQx4cmCdgboJg+rp+Fln3dApqCNnS8MNaSVRDdL6pr9lHsGr9bFjybkrgqK/9WDBZvRAxB6QoUy13SKdV44t0Y56Y4b1/SOjkBZZqdMi9ct0U+MAdqTPwt1KuO9wZ8VktFsyZx8LYkhC/nxraioJZi/EOqOxjexuU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751896290; c=relaxed/simple;
	bh=bH3giT8iaSEsSKeyf+LrLc0oHHLAYnkzz7cF8c3vf3I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eGSuqSMTxis3yr4JXfrG/31LqSirlv0Duld4j1AIoPpegI131wXPO8Lp42vbIdvjBLRd/tQZp5suykyVUAgpxdOxizfPjidgFV5N4tIXnT1cVY/wNySbaL3NrnY1glAP3xwqtqnDbqCqdrAoy7zEe2P3AjvWXdHJY/W0ddC5eqI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jGKQb6Un; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751896289; x=1783432289;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bH3giT8iaSEsSKeyf+LrLc0oHHLAYnkzz7cF8c3vf3I=;
  b=jGKQb6UnnnENd7NeT5tQsrWZYEOnFotU3wGOg7nnGqt4lX19NxXZhthd
   PTDrKg3F4tvdRFvSAKltlH7BYp++mvyEUEpO555tlIanhy95dMEw8XitF
   MXePbNo8R4qGKjATicmf90pb4B2FusLAWh0s8pxjSPkjWh3RZmAOePjVk
   YMDo7Hp3bUxynOX04/b7Eh+8QDHh+U6IaPZzl0jGYC5QuB3W7TJNzjNPB
   y9uVICA/zLJ6U5E4ohhTSm3Uc5TYLDrqaWZ+au3zI0MFMBJZ8nfqZjTYQ
   NOitvIwZ5Ptfxg71hvB37k7fj54UFC9tO5OATJh7l5+sHfavp9h7rAkKT
   A==;
X-CSE-ConnectionGUID: AzFXMgcvTCaHow/dudIFww==
X-CSE-MsgGUID: qOMeXhu1RF+hNR2NlxJRrQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="65464719"
X-IronPort-AV: E=Sophos;i="6.16,294,1744095600"; 
   d="scan'208";a="65464719"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2025 06:51:28 -0700
X-CSE-ConnectionGUID: FWupGCajQyyWW4Jyhq1L0g==
X-CSE-MsgGUID: UqjELT05QI6DZjIbn4unlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,294,1744095600"; 
   d="scan'208";a="192402814"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2025 06:51:27 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 7 Jul 2025 06:51:26 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 7 Jul 2025 06:51:26 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (40.107.102.87)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 7 Jul 2025 06:51:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ko1MiJczz4YHBiOom9TmQ8qYwBmvFJmpgRI3sY6dQJ7cr9V4p37J1pynTwJ8qSlTlEkMD5m+P16fM1HsgqluPQgXPjAlaTvwGHs44kr+N9+s6wd4yKPe5O5U5ft6CYMKR7zZRH1aRhPMAACqoNub5P1NA4nDxAG63dDxRLU+QMIEJREFqmF7+Vo8vSjx4PsQpGCKdxPtOAY1e6sKVhl5Wq0BpUsC6h0yDsrimfnOBU3moc5Y5/jhthXQBQKRGkQJxM/EbS9UfxeB2n8lp7hG0as80vsGOO0hATWgvSXQAwovgQC95F3Ybtc4DdjONd+hGEHtqNm1Esa0XSWurrC0BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c0MkC5bqaE2eM1rPvH9THQ40WZHufBz3TzQjLtgybA8=;
 b=TgyOQGXfiu/mxUgsAJJ6ZIYwXPhhbID5RxonZA2qkGulhSmth3FDcY4Rf7WAS6P64L4MQ+1xf303cvx31uTi3gfBTkO8vy5dC+SKsvl9ZzPi8w2CxQuPWSE4QgLukFKhsA4Wrm9t46ydFgVwRaJLrKJaZ62utyn7apdxUVIvlCL+7I5w0QzgttrtENQbK4auLK1kaW44CbetzLMfq0XpY4NR5NBiBBp+gtmKT0fFHudySLqtICr3Vyh494yB+uZ1v4f7fYaKd7JlyHvUc1AVGbZg5NqdM/2QkrTSjKb0bBiZv76ReKeKpTHr1SFXAidRNTw0vCu6uZ3pAU6kL7X1ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY8PR11MB7134.namprd11.prod.outlook.com (2603:10b6:930:62::17)
 by MW4PR11MB6761.namprd11.prod.outlook.com (2603:10b6:303:20d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Mon, 7 Jul
 2025 13:50:43 +0000
Received: from CY8PR11MB7134.namprd11.prod.outlook.com
 ([fe80::cd87:9086:122c:be3d]) by CY8PR11MB7134.namprd11.prod.outlook.com
 ([fe80::cd87:9086:122c:be3d%7]) with mapi id 15.20.8880.027; Mon, 7 Jul 2025
 13:50:43 +0000
From: "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>
To: "Mehta, Sohil" <sohil.mehta@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Xin Li <xin@zytor.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski
	<luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, "Sean
 Christopherson" <seanjc@google.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, Kan Liang <kan.liang@linux.intel.com>, "Luck,
 Tony" <tony.luck@intel.com>, "Zhang, Rui" <rui.zhang@intel.com>, "Steven
 Rostedt" <rostedt@goodmis.org>, "Mehta, Sohil" <sohil.mehta@intel.com>,
	"andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>, "Kirill A .
 Shutemov" <kirill.shutemov@linux.intel.com>, Jacob Pan
	<jacob.pan@linux.microsoft.com>, Andi Kleen <ak@linux.intel.com>, "Huang,
 Kai" <kai.huang@intel.com>, Sandipan Das <sandipan.das@amd.com>,
	"linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-pm@vger.kernel.org"
	<linux-pm@vger.kernel.org>, "linux-trace-kernel@vger.kernel.org"
	<linux-trace-kernel@vger.kernel.org>
Subject: RE: [PATCH v7 06/10] x86/nmi: Add support to handle NMIs with source
 information
Thread-Topic: [PATCH v7 06/10] x86/nmi: Add support to handle NMIs with source
 information
Thread-Index: AQHb2+RCFxzdJeTc7kelOkq/4aA2wrQm0fDQ
Date: Mon, 7 Jul 2025 13:50:43 +0000
Message-ID: <CY8PR11MB7134EC0ACDE4772F2CB8A87A894FA@CY8PR11MB7134.namprd11.prod.outlook.com>
References: <20250612214849.3950094-1-sohil.mehta@intel.com>
 <20250612214849.3950094-7-sohil.mehta@intel.com>
In-Reply-To: <20250612214849.3950094-7-sohil.mehta@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY8PR11MB7134:EE_|MW4PR11MB6761:EE_
x-ms-office365-filtering-correlation-id: fbd12009-73da-4aa6-256f-08ddbd5d4470
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?5PgKR/tZ+IiGw0AB1DJyQUq6Yq5UmkkET43a1n0FNTIQtOqjRDmtFl2IXlQn?=
 =?us-ascii?Q?+n78kUSc30meAa611Lclm9Pqs5rQ9NuXphA0RprICmBVrfA19n3ZVZxdrg23?=
 =?us-ascii?Q?e7HzCzKbn5LZhqwl2R4vFsxiuTYK8CjYT7YnWRj+wXbpXV270Mgk5lvp73yd?=
 =?us-ascii?Q?zCLcRgspHlrY0WVe+11Y5KYR3Yd3O2eB5uQa0VSUtBwd4sdTArpRg2gGWGIi?=
 =?us-ascii?Q?UPJvOI5HDgoGJ4V+6kjcwgeOSrdogT5h7d3yoGKqqxYAVip4jKmDUyM7GPsh?=
 =?us-ascii?Q?cTqQx7zLDhG5Ap0jM7/0IU3gbCIX297KeSw0SX032b18/weBoPBKbC0M+4oa?=
 =?us-ascii?Q?XN4g6eyVmCx8VWgELuiEJM5ScVr/mlpdCQ0BRzeW7DuO1NvaHU+RNpYT80st?=
 =?us-ascii?Q?aCDl+stHU4Ch2/OftdxPiVk7AW5qnaZd5D+whyuZFil4YfH/RukuB06LnmdO?=
 =?us-ascii?Q?I9sOqZUOJSGEf4jER8tECTRZn4kdFYxTeK9jeE3NEGBaJlgxcLZYhBz41sT4?=
 =?us-ascii?Q?P8rtWFTy5ntonhHdK/MzIeaHn5AvjimDp9fu5UeSa+GLBgFWnIvpb7lf/7gc?=
 =?us-ascii?Q?3VVQ8OS9jQJ4Pul6yz4dBVLeQlknIyyzigNnnSSpsncRPAUa5rgH8/+zKerw?=
 =?us-ascii?Q?SKPo4NNFPhIcjZFIKyWxiip7WOj8gDflNgBPPehXOxtQXEix+sIJJWcSTrwu?=
 =?us-ascii?Q?Bw40Q/4SAWFX0wrwoja/do0+vtC4iiyYBhmvjDaR+OAWZEeuoPsXSQJ4BZlv?=
 =?us-ascii?Q?oGscrK2MnMDOajP7vMQbvmizuGK/zIq3bMhloJ9nRb8+xTO55OfpTRSQcPAj?=
 =?us-ascii?Q?4HBJS6YimYlnEk0ddn7hnLU8ncAwrRXElua3AgeRnb/EazYdmmjw5ypskIid?=
 =?us-ascii?Q?3lbhT7drqwUzh2sN2sa/cWdhkJj62TYg+YDX5edDCq/uvkj8Gi5BuTAcWqyW?=
 =?us-ascii?Q?bTgaS67fXgnXIbBBiyO5d2ED+VHfK0oUNzoViD2480cNShAWMe8SJ4vAX+7J?=
 =?us-ascii?Q?f+bEpaFl1mlxA4MJ7Loj6P/PHG+bQYEwSk5WceeNMIrojAIAyrxzEgzWeJgq?=
 =?us-ascii?Q?2gQqSuCRAdoda/KNnFbVhZ620e5yrGSTtyF82YlOc8F9xZ4xpAM8S9rHz4U4?=
 =?us-ascii?Q?BjhdXajTsEcRSvuTAO4eXhVgZUYhtJh1I+RpUpE32etUTL3emLdNqW8uGE0Z?=
 =?us-ascii?Q?tFp7ICfMW6qniA0fhRLruZ0t51adtPO+nZw68WYtiPqPAQTFoiti8tP05/js?=
 =?us-ascii?Q?XMgM/qbRVnEvyRhMIOXaJpOvQt7tI6oDTpCcRvEz0jQzaBdyieZZY++vBuMw?=
 =?us-ascii?Q?r65hH/i/HMfG9vcrVB5NB08+qV+oNZQ0O9cLCs72zBe5Pe2zO+puWHefjTzA?=
 =?us-ascii?Q?FVSPl/lWuh13GNDr/4lwCirZPcRr/z4DgRIFKwLDk7R0Sd8M+cAJHtjl7FZM?=
 =?us-ascii?Q?LN84OxYHeRQEIkHvlxc2acapPK8kLHu/e44yAKrg8ZE2uF1Kg9ySGg=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR11MB7134.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/npKdqM+ymG9SnO0OQdyY4P6HmajuMsV/5kfEJTagmtVBrI/lUuY3SLj+m33?=
 =?us-ascii?Q?U0+bdj0sEAKofh+cDRoBDpPrNPhlRmaWGr1+hKIKvfZxk9dqV5m2WcOapkOA?=
 =?us-ascii?Q?LEoLMPcGYgQpsBfT6+3ur5Inu1ajcfxNhK3+AdTUtcXrpvJILFy4afB6FHp9?=
 =?us-ascii?Q?OBzvVoYjh7Pit3RWCM4O/JezYFTFp4LKGYNJawbISCigupNkWllwtv1F/F0L?=
 =?us-ascii?Q?ghYe7t3qycRbB6F6Y9WKk1UAvqmZQLzmkWyMS7q5Kvjt0LfpXv6SoekoUiIg?=
 =?us-ascii?Q?ARWPDdwqY3RS1ldf5wjzQA8T2mV3TOzLWnmk6yJRrwd4nn9Cxz2Nc2Qi+twe?=
 =?us-ascii?Q?r5ob9Ysca8wetqT9jaT1NwAzulhtEH/ANiM/vwhQFufJB0X5p+5LBpDLxOP1?=
 =?us-ascii?Q?BNg1EJeDcrcY2klSDMs2TywVETUzu421SvxE2shisp89eM2TqLTSRcD+g19X?=
 =?us-ascii?Q?db6klDlx8iNJZDoUjpC+62Gu6Pv9a8BjCMmwldL5Ak1pTmGPFcTQ7fHLPyIw?=
 =?us-ascii?Q?aITiJv2rUWJAB4/Fbh8wJPPSSe1KKJCye9Q/W17O+bNQLRXgv+hEnkcrHfgi?=
 =?us-ascii?Q?ZqYajRqU9kIDAATLKvx2RSZiaiLEWv71vDaz28OYkwxkQIyCED+uSrOG13+Q?=
 =?us-ascii?Q?kxxQ9FNKxqJI0EcMXb9S2GbvG6MSjCXmn441GgkDC0nMj6lLN0e82pfEZS0Y?=
 =?us-ascii?Q?QrkzcQVYpZn/cXp22q+adXgE/+R9GSIplPz1PgSv4sbimwcfsJkfH1oWbjv+?=
 =?us-ascii?Q?l7H5anSUuzrdNDghyXRD2WaJA36wIW63zc1gXmNVLf0O128xvwKEDZE7Xtv3?=
 =?us-ascii?Q?cPiJQy5oWuxcwV00YvR4r7se8X++vIyZCwt835Y18Y3s2KCGCxpofawzfZbN?=
 =?us-ascii?Q?3fAnOwJXZCTTMzTpx9og7PFQU7M2AHl7bOlcBiUJgZs7U2x1ebPan+2NJXpg?=
 =?us-ascii?Q?PLap35DfmIZYbu0qgFWyAJSGjlJiRROXtJvEAqeEwrIFP/b4Jkcpi5Bok1JJ?=
 =?us-ascii?Q?VIroOYSaJOzjBqWnnLEVjI0+qcIl57Mb+3AeX7YYhWnxP/NHCeCaqHikqzog?=
 =?us-ascii?Q?gcRXaPpqRxN+S7Wzr3Ffacb/w4woEYF5xTyz+qydwh/1fAEiAnyS3xUsT6Fn?=
 =?us-ascii?Q?pnpG3/1r1C1kq8feNkTS4i9WC+qO0F4pahLzsURNx+ib4F/J90XHwwlxqdLe?=
 =?us-ascii?Q?NDCD88eJ5vnSa45TNeq27PcLZz8gFN2g+BZ+IcvpH2EbMjoD0/I0WpHIlUTF?=
 =?us-ascii?Q?oWPAafssVaZ7ixge3Y2YkaBQO5h0oE9ddmYSJRs4TEjKHJjCKNRIUnXwE7Wh?=
 =?us-ascii?Q?lh7BD7mwVgdq4PknLWmZ2mjN9Mc8iJT9+4Mlylp1NzwXueslXTNmdhgf98p4?=
 =?us-ascii?Q?AKi6gatwAT5xIxOjUwwVSja9pPF+Le42Grf1IKh9eFylJ7UIg2/NpND5xF3G?=
 =?us-ascii?Q?rnQv8b4mQGZDYqiFi7VZCFOg8TdHTNJAG1/3+Q31iGo85lEHrdf6D9MxOtiK?=
 =?us-ascii?Q?91Pm1tIUMif7GVOp1plLnTX4EUoHF4/fLr5PK92WaJ9ypXr6viMktkihlwdD?=
 =?us-ascii?Q?gnjitBXs2zaefCi4qAra0FSGuwKKIH/AWA9CUk6N?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY8PR11MB7134.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbd12009-73da-4aa6-256f-08ddbd5d4470
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2025 13:50:43.4236
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mtV9461qsye5JURJ8R8CCjzjia2LPbU/i9UTU/mF+Q91JMTTVrpxSRhnMnIsgDwlFoee9bgIpjmktCoBoLMKGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6761
X-OriginatorOrg: intel.com

> From: Sohil Mehta <sohil.mehta@intel.com>
> [...]
> Activate NMI-source based filtering only for Local NMIs. While handling
> platform NMI types (such as SERR and IOCHK), do not use the source bitmap=
.
> They have only one handler registered per type, so there is no need to

Same as the comments for patch 6.=20
Platform NMI types may have multiple handlers registered per type.

> [...]

> --- a/arch/x86/kernel/nmi.c
> +++ b/arch/x86/kernel/nmi.c
> @@ -130,6 +130,7 @@ static void nmi_check_duration(struct nmiaction
> *action, u64 duration)  static int nmi_handle(unsigned int type, struct p=
t_regs
> *regs)  {
>  	struct nmi_desc *desc =3D nmi_to_desc(type);
> +	unsigned long source_bitmap =3D ULONG_MAX;
>  	nmi_handler_t ehandler;
>  	struct nmiaction *a;
>  	int handled=3D0;
> @@ -148,16 +149,45 @@ static int nmi_handle(unsigned int type, struct
> pt_regs *regs)
>=20
>  	rcu_read_lock();
>=20
> +	/*
> +	 * Activate NMI source-based filtering only for Local NMIs.
> +	 *
> +	 * Platform NMI types (such as SERR and IOCHK) have only one
> +	 * handler registered per type, so there is no need to

Ditto.

> +	 * disambiguate between multiple handlers.
> +	 *
> +	 * Also, if a platform source ends up setting bit 2 in the
> +	 * source bitmap, the local NMI handlers would be skipped since
> +	 * none of them use this reserved vector.
> +	 *
> +	 * For Unknown NMIs, avoid using the source bitmap to ensure all
> +	 * potential handlers have a chance to claim responsibility.
> +	 */
> +	if (cpu_feature_enabled(X86_FEATURE_NMI_SOURCE) && type =3D=3D
> NMI_LOCAL) {
> +		source_bitmap =3D fred_event_data(regs);
> +
> +		/* Reset the bitmap if a valid source could not be identified */
> +		if (WARN_ON_ONCE(!source_bitmap) || (source_bitmap &
> BIT(NMIS_NO_SOURCE)))
> +			source_bitmap =3D ULONG_MAX;
> +	}
> +
>  	/*
>  	 * NMIs are edge-triggered, which means if you have enough
>  	 * of them concurrently, you can lose some because only one
>  	 * can be latched at any given time.  Walk the whole list
>  	 * to handle those situations.
> +	 *
> +	 * However, NMI-source reporting does not have this limitation.
> +	 * When NMI sources have been identified, only run the handlers
> +	 * that match the reported vectors.
>  	 */
>  	list_for_each_entry_rcu(a, &desc->head, list) {
>  		int thishandled;
>  		u64 delta;
>=20
> +		if (!(source_bitmap & BIT(a->source_vector)))
> +			continue;
> +

Is it possible for the "source_bitmap" to have some non-NMIS_NO_SOURCE bit =
set=20
while the user registers their NMI handler with the NMIS_NO_SOURCE type?=20

If so, we may need to allow the NMI handler with the NMIS_NO_SOURCE type to=
 be=20
invoked unconditionally to ensure no NMIs are lost.

>  		delta =3D sched_clock();
>  		thishandled =3D a->handler(type, regs);
>  		handled +=3D thishandled;
> --
> 2.43.0
>=20


