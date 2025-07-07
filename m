Return-Path: <kvm+bounces-51667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 28BA0AFB466
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 15:22:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7101E4A269F
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 13:22:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 487552BDC06;
	Mon,  7 Jul 2025 13:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cdSxHAcS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDE12874F6;
	Mon,  7 Jul 2025 13:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751894524; cv=fail; b=FKYtsf0uXRyu7Q2XdlOfdmJJuhs1Td1rSdU0oVwrzyE6+Fgre5/e+augf3LT/EbXg2vPl+x29LcknqOql8bXJoYM5rb4vzk5hEasmIXpw2aGCN2SzRilo1xqejN4AgPIHDC+i85/7cFy5NO59+4Kt1pBVOb/lUZFoVCtgvriFA8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751894524; c=relaxed/simple;
	bh=8iqj/6DoSFzNjEo+3FhrSDGilWnjFfEWCT4vs8e4IBE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=F9pndFI2HrxEKnXOnXuORMvq3SDIACgFxjDD14kZL0LKy5su5N4756z3qcsFZNR2HmecQETEQo9Nz92idpjutFdzLSMkrCeLoWWPYz5H8pRKpKNMkecOhWI3VJpv4Z4siRJiDXGTaJCWXOSMjDIpnRXa2WBuXLPVX9WBrEBY3Ls=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cdSxHAcS; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751894523; x=1783430523;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8iqj/6DoSFzNjEo+3FhrSDGilWnjFfEWCT4vs8e4IBE=;
  b=cdSxHAcSm/gbrVwVjeOlXYKOMiAYHw9hUNVDWwM1ACp+R+UBpQrjgsTd
   0na4/xzkmKqFiyhGVZndM1Fzna8hKFHwTgSvJTqY7nxb/RdLaigrghPbS
   hWWGvstAmAZpfdGFTzXkySmy5YoWgtiBRQmLf4bsJfDRowqGqaB/3H6Bh
   ftth6w4h2iD4MtmLs8riiAPdDDMgcmbek/giigdQKRBr63t51Nl5Ojgc7
   QL0btZsFxn6aP3btL8mUVA/Lcib1+d2gFgtsxVcuymJEgCIpGD+ijUipZ
   PefUAh2AUzHl0XcRHo49sIZCYG75m5fo1fADCNwaGgvG7/7hIYn9y8ryY
   g==;
X-CSE-ConnectionGUID: VSq7W+hERBORtcFk1MfjJQ==
X-CSE-MsgGUID: zAkOLRc4T2m4RDyUrbeT3g==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="53997213"
X-IronPort-AV: E=Sophos;i="6.16,294,1744095600"; 
   d="scan'208";a="53997213"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2025 06:22:02 -0700
X-CSE-ConnectionGUID: /al8DgCwQp2uFrwpq3vFnQ==
X-CSE-MsgGUID: 2HZBautEQ8WfUxFv9+IKcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,294,1744095600"; 
   d="scan'208";a="155799404"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2025 06:22:01 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 7 Jul 2025 06:22:00 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 7 Jul 2025 06:22:00 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.54)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 7 Jul 2025 06:22:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K1ihy0HJ2EBxv73fvEOog6SAHA0vMcxdHUGbB6kIz8AKhmwqynCtF2u/uUC9726INOk8YjxyRCQ3OvMwlIOrzRe8qWoS0LA+xGoOr33pWOI37/tp/KiQwjgvKIO2TfvidYprxkqByuBYkdYLCLPeIQm10gWhkIc/rOx/t1X5kxCnRqNYwztdjKU+fa/6hHiie7+LpL5EUALzYZm+Jcimriw0uyzpBt6aGLioDbn1NZ9ogbRNSdXYOZi1P9nIE+EbYAzJeT32QXdYWksNdedI8Qynt68v+bLEqB9L47PK65Ofen24dLIfb4WlpZIC67MlRBubh43VWIoIm9o3a9UNpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8iqj/6DoSFzNjEo+3FhrSDGilWnjFfEWCT4vs8e4IBE=;
 b=bCcAfFjEWwSmPKC7esWK/lp5/cWksDqK4ATHJOF3YL6/hphKxhIqCv0FvRTFGayW0iKQhOGGa405sFnE3rfYp9xVo48QIVmfHYl0LUYQDL9BLppmSvi+cmeLaDnjAIr6SlgnrGqJcIFSpA+d/PLI+gM0HELADOg2Nn3UE7OyAKBpEOsfPhYPeD19je7MGWfpWoCyahCgFwLJ4UnVOBfJYZH/RpUD8V/FhDNow2ereqK2FKnMhLLqPOEOrLH70dveEKSkUsqQ2le2nhEkG2JTFfnDwoI0N3ZsAQfdjNuE2jv6i3GVi+qGH8pZZVYvTH5rFmXJ8bgfkqgwW5ovM6Tdug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY8PR11MB7134.namprd11.prod.outlook.com (2603:10b6:930:62::17)
 by CY8PR11MB7686.namprd11.prod.outlook.com (2603:10b6:930:70::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Mon, 7 Jul
 2025 13:21:58 +0000
Received: from CY8PR11MB7134.namprd11.prod.outlook.com
 ([fe80::cd87:9086:122c:be3d]) by CY8PR11MB7134.namprd11.prod.outlook.com
 ([fe80::cd87:9086:122c:be3d%7]) with mapi id 15.20.8880.027; Mon, 7 Jul 2025
 13:21:58 +0000
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
Subject: RE: [PATCH v7 05/10] x86/nmi: Assign and register NMI-source vectors
Thread-Topic: [PATCH v7 05/10] x86/nmi: Assign and register NMI-source vectors
Thread-Index: AQHb2+RNN65/PxV/uEC8CYMFPk1A1LQmyF0A
Date: Mon, 7 Jul 2025 13:21:58 +0000
Message-ID: <CY8PR11MB71349E0943913F8AE944B3EF894FA@CY8PR11MB7134.namprd11.prod.outlook.com>
References: <20250612214849.3950094-1-sohil.mehta@intel.com>
 <20250612214849.3950094-6-sohil.mehta@intel.com>
In-Reply-To: <20250612214849.3950094-6-sohil.mehta@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY8PR11MB7134:EE_|CY8PR11MB7686:EE_
x-ms-office365-filtering-correlation-id: 1356007c-64a6-4c3b-59c5-08ddbd594018
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?QjiQ8AA6sHLePMPkkaGvDSftI/Sy96PMmcjVdxFNkQt016YMdwHEv+EjnGsw?=
 =?us-ascii?Q?yspRoNJN2Js1egcEMz91ARQbM4c/9KH5mbJgP0fMVb4de+0v8WYpmUorYF93?=
 =?us-ascii?Q?HNJD2hICqfc0G24Z/B/P173EQXVTvWoRdDPkzm9+lj1X0tMby7vDxPQTIPR1?=
 =?us-ascii?Q?v9ySOAumb9FAtTDLb9yBkKd557m+cOh5pgt5egGka23ur4GCrcjDJkrNLyee?=
 =?us-ascii?Q?QAGfZCQGYMIGeRubOKSDVOl3RNM2iM3YnlyM3A+Pnp9VdWySG5rdC4GiRgKs?=
 =?us-ascii?Q?DTCWxrsiB6z1V0priBsGkqIDeDpeYRMM9x9Y+iPQRJe3/Vz3F/iHmjtp4sZe?=
 =?us-ascii?Q?AJZAEc1w8n6QgPW6REgrcz8au5/eStj6L0L6mvaDzxJjKlCflOK6+kfn/FQt?=
 =?us-ascii?Q?LIVHqlOaPp90X1LGq1Yq1L8i/R/rvAukzK+VxYgrJZl8dwXWlAC4VlXiqEow?=
 =?us-ascii?Q?xPIZ3n59F6JlWOHKNfGJqBb8Weq8v56wvvt7y+9myj8xg1/8YYpRnXowA9IQ?=
 =?us-ascii?Q?ZYCsxu1m73KUrIGV82YtgQ7IY4OTC1hQ6yvlhabbPyM8GYzceJCmRxhLfRmm?=
 =?us-ascii?Q?ZWE4CjdgLRjAEyEFOkqF4u3GQJHRY0p11ecwrKr8LV93Hyg+LPb1h+UbQwh7?=
 =?us-ascii?Q?jsYVKFmRmDifNUx8a+mW/zDXGg6yriCG3u77M5o7K5cFmtDCglJilzZVHVYu?=
 =?us-ascii?Q?Fg14hNs0C/PMsbINMfz6p2p2WUB5iWDuEp6j2ekiVk76BBUqcvF3VjFyZI+n?=
 =?us-ascii?Q?tR27YNNlk6S75aiecxp1OS6P6ZPYvXOb7ueekaGVOVC+s+eI23lgGCHsJ7p4?=
 =?us-ascii?Q?lFf98BAj3AeLaj4j8QErF3OtIhPk+j7IX5AUC0FPbLiJVZd6Q39XZ5PYPxA0?=
 =?us-ascii?Q?nJyDYWwFNFNFwWIs/AznHuegolIfMV9MuchIKq2DsYhdd2EVHsdKQdhXmbvQ?=
 =?us-ascii?Q?FGsOJT3CaOaDllK7+/B8s1/Nk+qViK6P2IV+FVlvv+qXK7g0NtqXGXlcGqA7?=
 =?us-ascii?Q?I7SIZ1tiYBs+c6vzcjtRf561M5abEOvE/JR4LPxgWx5TIANui4Z8vmUpiIqz?=
 =?us-ascii?Q?v8mUz+DyHRNNuMNfFrq5snnAP74RPSxFR6l0L1pUNG+KWSXjkWdQokO/8kk+?=
 =?us-ascii?Q?vQDkEpvnnyn1ZK0y4R0/6+NoX/Puz820wE2msj2Wj82Duvb7UpKMQQgbQawD?=
 =?us-ascii?Q?Qy/B+tq0jH3RglMo8uAr/FeH8B7sZ6UjpxsgfFWaWWp86smJjAVmXJmVQ0Sa?=
 =?us-ascii?Q?1PmoXYA7ondK70McowLgxbUOG6JliGCtPhJUI4g+NVZqrKzLjEkJF/FnpmvL?=
 =?us-ascii?Q?qvRgZ0hezIS6XMUBAK/93ITvFoXGcccsk5LIhccLOdPu3ccFwbMvUWovHd17?=
 =?us-ascii?Q?dyWhxBQofbyKPudg5I87TZ69Upf55s249rB34iXdl0z0Q0prmn9lFRnfaoLP?=
 =?us-ascii?Q?smho75XHSWkvTabca4ubiBH5J57AgXkZ?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR11MB7134.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lYflqLx1SJxpwpB4tu0+HaFlUsnbBKAqFo6P5FwpT5OgVvPJ0Ed0S02jgQuS?=
 =?us-ascii?Q?Tve+iuKSZub2GUXpvPxrzk8jp/uHhhFltfI6Y4rl42qK+U/Ebi9CMBy9ElGi?=
 =?us-ascii?Q?x12ub2NyBQ15hYuI1ZBNTx3hvzl3BTLuykCQ7GdRe2kFU7F6iewmTHRVehpW?=
 =?us-ascii?Q?hpzPmWByIuzvazbvjInwA8jHDUTvUZMJhux8NAJTo25bShX7++t3HP8V2+GH?=
 =?us-ascii?Q?Z0+qh9WiPtdVrZ05d9DYkI63dnLDaGG7shTh9M1pOvyhzftVhB8SMlnstTNM?=
 =?us-ascii?Q?g8lMWZbobxFJqe4J549Re54zCzMBif+elGHHS69cQ7fiuJsV0OkbAcr+k7A6?=
 =?us-ascii?Q?75B2glhN8Cr30MrxZUA6a6NUDGPWUG+lkO3aiJ6yz8oNJvz6ysD88gE74EsM?=
 =?us-ascii?Q?3Diip4z5y2+2ZsZT/ZPODejJEXuNsy0MDFRrX6AZ0ANA01gmoojpKG4zOeA1?=
 =?us-ascii?Q?VGP/yY5BQx92wzvfjcFtRLkXstUpo7AFTED8CpTfU8x56tvwgFUEM4vnizSQ?=
 =?us-ascii?Q?B43qh4I8gg6Xda595lRGqAkh/H1PY3sGekKyBykYpEZ2wNJ3um+vESwlIlj9?=
 =?us-ascii?Q?VW9T9Q76bWq36q2NJeGmD0iunrB61ApNRvXsxkxfM0Yf0/PtEX9VAERLTW2W?=
 =?us-ascii?Q?WHKWF7nnRkg1LWPimVMQXt7Xy8PH1z4wFrGZJmRtshfArGXfKK6F4ieOHYjs?=
 =?us-ascii?Q?3x2mzM1jE4+HhTXBVTARcNjWLfQdHZNlUOQr75wwsNc+N+TJptkPmNFFt9MS?=
 =?us-ascii?Q?o1gorBqt0RqPMcWcEOxoCqsTxGMss9nYWWGGa5W41ZJI/nZ+J1fHM/2GxIOw?=
 =?us-ascii?Q?NFEXBGAXi4Yanz3YGqqXSDvOXqDAZN2zuTLw9iyWbZVF4EDm8R85a4D4Qfba?=
 =?us-ascii?Q?juEwac13dm6ZCyGUBGTYaHjXVzTmPBidt1hIabZAweO8SLYPb8GbZHASmxlY?=
 =?us-ascii?Q?lBWN0QnwV4URLCg+dl7nYa3YSbqGfn5NoMUyZuZRuWmMr4id4QTPvra7Dph6?=
 =?us-ascii?Q?nHiOLTBEJ9dq9yJgMe5ZfZfkizHYMrqW30Imja3dNs84qNpjMaEuC8Mk/Mwp?=
 =?us-ascii?Q?wzIu9h4fepiFWIxkRiK5QZqkzcsxp9Sv+gpXjcmsfcWhqU5XQuMf6BZqUKNH?=
 =?us-ascii?Q?m3o+JiO/tvR307cl17a/ke2Kh6OtlKlHBC7XYNaYvWhbGq9dIvJuqPefR0Zv?=
 =?us-ascii?Q?OB5e4EwgKPBZNoWjckPt70kQ8eETvzNKM1XcL4sW8Sw44WlQk3jxnfD6mR+l?=
 =?us-ascii?Q?HVRhjDQrFcdqG8ikJuCAij6qF6mFxG8B4OfXU7hq7vTM0Drm6+gg+aAFQa7b?=
 =?us-ascii?Q?V1G6Uv80oWjabnQhR+TRh2Fn5P9qS5r4IG2MQ0yloio44U80sduqpvBOM/v5?=
 =?us-ascii?Q?xyynGNYmmCNbKyYRZDw773g32ndIiYrpbEz5aeQk3f6aKmzWQ5W9FIT5m62k?=
 =?us-ascii?Q?Y0k3J9lRV2xxAFmmvkYRj1P4oMvPLFqvs9QfwKQKh0iKkyhP13xKfI4TIZ0Z?=
 =?us-ascii?Q?RmwcqUjqpy3muvuJ5QtN/t7ermGT9t/VfjbSD+K9LRLjedIYk7hum6YgNSZO?=
 =?us-ascii?Q?JKLmGkrLapr8D78L7xg7E/BM4RMKOwvjV+X3iapl?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 1356007c-64a6-4c3b-59c5-08ddbd594018
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2025 13:21:58.1297
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ch080fGgUyWUmP+g7yppsaqibHWfZ1H9u0fXryVDd1EtvWITKnajK8kIij40JS20JtXDqOebJkP2oQ1gzOXqeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7686
X-OriginatorOrg: intel.com

> From: Sohil Mehta <sohil.mehta@intel.com>
> [...]
> Vector 2 is reserved for external NMIs corresponding to the Local APIC -
> LINT1 pin. Some third-party chipsets may send NMI messages with a fixed
> vector value of 2. Using vector 2 for something else would lead to confus=
ion
> about the exact source. Do not assign it to any handler.
>=20
> NMI-source vectors are only assigned for NMI_LOCAL type handlers.
> Platform NMI handlers have a single handler registered per type. They don=
't

From the current NMI code point of view [1] or [2],
a type of platform NMI handler may have multiple handlers registered.=20

[1] https://web.git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
tree/arch/x86/kernel/nmi.c#n199
[2] https://web.git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
tree/arch/x86/kernel/nmi.c#n201

> need additional source information to differentiate among them.
>=20
> [...]

