Return-Path: <kvm+bounces-62035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CB2CC33B6B
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 02:54:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 079BA4EDEA0
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 01:54:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6105A1E9B22;
	Wed,  5 Nov 2025 01:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a+bzryVz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C497D42048;
	Wed,  5 Nov 2025 01:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762307678; cv=fail; b=JDuwtke9nv7j4padU8XjbzQ3XjgbqBXS2bM+gJVJOinNOSNRImJeEKYhRhcQdxZkcRk14Rjw29GvB6m5CbA9zOLoovhWp8IXthsLkIUs5+7B2xjA6u3ZTd8dkcABnIvhUqexFMA6tflVWt4Gfmff6pFNB4gML+SLNwwXC0wrKho=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762307678; c=relaxed/simple;
	bh=Uoc/SOZSntvo59R0XzMYVaiqgYr76xbzdNDeXeFwQcc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=I/Kt2j7N7s/Aq2TXaSUToeG+TvBGnqa5WlRtXpdMHJtZJkrW89XvlrPDUL0YAVEANuf93pZ+KAzopsMlgZpJCtJLZWP/tOpteXgnMo8u1iLgrJUy7gt3fOdiyKyTmsaNKrOvfopmJlvv6OudYA12Jq2uHWy6FZTR/WUoAygJFcg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a+bzryVz; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762307676; x=1793843676;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=Uoc/SOZSntvo59R0XzMYVaiqgYr76xbzdNDeXeFwQcc=;
  b=a+bzryVz2Y5kYh1dQSOJ9JH72NjGv9vl0KFTwF45rsU6GsUQ/r11JIUF
   hGM0+RyQgqgat3QfcYq5Kmf2EUdcYrXrsIRkxuElUyjdtTgXWeZsnrnsw
   KIt35lTzDcaiKffGGPw0aT8YFmQB76JuyQ7gDv9T04COfeKae8anjOrbz
   hGbI87AC030QyTrgH/gsBhfNHR5l52hzcdVNAbVJy4Vhbqc214AV4qhqA
   g8IYtFKZkM+Ib5a0TzNwbdS1xeSQ6XcMMhGET+pxZ1i9SdCqYJ6RUvf3F
   WsfZU6+MpvD1mNQbMZu5wie+WRptV+caLGJxFvJbLGx+4Sq7s7gwqN09h
   g==;
X-CSE-ConnectionGUID: yGSyPtZrRJiy23QE6pwMuQ==
X-CSE-MsgGUID: BxdzASeqRwSr+j6P26kh2A==
X-IronPort-AV: E=McAfee;i="6800,10657,11603"; a="51985018"
X-IronPort-AV: E=Sophos;i="6.19,280,1754982000"; 
   d="scan'208";a="51985018"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 17:54:36 -0800
X-CSE-ConnectionGUID: uML/GBsnRcu9ouAWTqkbqw==
X-CSE-MsgGUID: YB96El27T8iekHmgTPO4Fw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,280,1754982000"; 
   d="scan'208";a="191612858"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 17:54:36 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 4 Nov 2025 17:54:35 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 4 Nov 2025 17:54:35 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.6) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 4 Nov 2025 17:54:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NCtFR+u7JmF9GmHRGoE1fBhF8aA+nePP5Curdf+Ms+h71zHBkqe1c6H75LkJVM/QRlnmHgNnLI2u2xV2lnpqilX5Ijq2+W71qShK+5Q4DqmFBDZF4LAtib0tmai4T5RLYQyGQT9FmBlxDHcWSQxBPFjMsgPqTbbSzaZHuLB2kbGerF115JQaHoMJbwAR5JoiMiQtRORQ7QRKfA+ePnPasH/o6sk+NVynyobnqYWaTl9WikrPdcIzTik3O6LQHhZqgiaaiPaUG1MNlALUbpasRqtd67Tn+lwxkAGL2c0kZTtjTXEgPs3e/MJJsiECgOGgQyzhRKutLwk2UuQc0HNQjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nsAf0OBdsSzYCj1xYVleLO2D4BYIONL/AzCQJT9V7/M=;
 b=LByh7139Z8mVxYX4metqKg+/SlXiJPsExcjLgjg/t21RvbKvCfTtUd1Py/Ty0fJNeIUSR/Ms3i5ElUfVNk8bHGjALJNdbffTR7AuNoO540krGIJ4TA3OJFhwxplKwMRr3y03tRDhb8vtWjheyXXzez/x9Af3vFFiv+CUHw8QxBgC1MJvuuW+k3FDzvKZlpzPypb+j1+B49D+ig87uOgEAajNdQGqSyz4Vr3HVap6UfV7tEVGyYuDBxaKGhLsvHewX17WXS0mXHz6IBetrGXGQAen0V+gAHeWQpQAHjOX8DZrg/3cfse9wwijwLHZ+i2qcFb0/tybnXhXTSHZESrH9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB6380.namprd11.prod.outlook.com (2603:10b6:510:1f8::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9298.9; Wed, 5 Nov 2025 01:54:27 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9275.015; Wed, 5 Nov 2025
 01:54:27 +0000
Date: Wed, 5 Nov 2025 09:52:26 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Xiaoyao Li <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
	"Kirill A. Shutemov" <kas@kernel.org>, <kvm@vger.kernel.org>,
	<x86@kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Hou Wenlong <houwenlong.hwl@antgroup.com>
Subject: Re: [PATCH v5 1/4] KVM: TDX: Explicitly set user-return MSRs that
 *may* be clobbered by the TDX-Module
Message-ID: <aQqt2s/Xv4jtjFFE@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20251030191528.3380553-1-seanjc@google.com>
 <20251030191528.3380553-2-seanjc@google.com>
 <aQhJol0CvT6bNCJQ@yzhao56-desk.sh.intel.com>
 <aQmmBadeFp/7CDmH@yzhao56-desk.sh.intel.com>
 <969d1b3a-2a82-4ff1-85c5-705c102f0f8b@intel.com>
 <aQnH3EmN97cAKDEO@yzhao56-desk.sh.intel.com>
 <aQo-KhJ9nb0MMAy4@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aQo-KhJ9nb0MMAy4@google.com>
X-ClientProxiedBy: MA5P287CA0078.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1d8::6) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB6380:EE_
X-MS-Office365-Filtering-Correlation-Id: ce899b30-887d-4b91-7a89-08de1c0e4098
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?orwmU338pdO+ng4ZzfdAk5jsRCDSij1Yp/AR3ltbSfxkNLY4plL1dROV7CoT?=
 =?us-ascii?Q?Tq8LZ5bV4pCp/BDy3JPZdcogX7quZb7Ijzl3LWJlf+3CZs/N3wkE83ECqm7b?=
 =?us-ascii?Q?8iksa7YA8XnBiCgHEUAoc2qMYpKcW92ZOLmi/s/VGWZ/OdQTcQnMVjFrEjqV?=
 =?us-ascii?Q?/Zxy8s5p9XaYHQlVf/v9eVLNukdJXrPCCahidJm3IAGGtY1VS0hkFTTy0AG8?=
 =?us-ascii?Q?0S9tJTIt6JILU5TbMEmGvI8JH4lidT5GEk134TtZgmZ+AKal6bxBqyYmMjIE?=
 =?us-ascii?Q?sUxmlushwLeUvhZJCFWHtaOk2XeEsoG7AQp/qtx7eqKUSAQmtYCVJnNSZlkn?=
 =?us-ascii?Q?T5ulayD8XjRMKDO2uaxo43fPyXOqIs0GIINYoSfdUB6hHDmG+7dCVUmu6FVg?=
 =?us-ascii?Q?JT3aMdS+ed0i9YEr87dGGJ/12BjUoft59dZss4gqBN9eGVzK0DC/R8bukcCp?=
 =?us-ascii?Q?f42r0p/hAWLcM9FQNejorwbR1I0mL/+t9Z3n8vajqnZf+vNDZAEE3VGYujop?=
 =?us-ascii?Q?ufDLZZYwaFNVXYSDKe0GLb6z+kyYReJk06cfFp8aAC9A7YB4PbgZFpjb/d79?=
 =?us-ascii?Q?7jC3DXGrgn5gh6qHhf5wQCIhoV4ngBjhnF4/UMqbcDmmyru1yGDxxVtXVxKU?=
 =?us-ascii?Q?8zYKmsl3h8q3VGdNaGB+Y8vhyc36WH1odtE8O5Ie67i9RlizH4epbcuZJnMA?=
 =?us-ascii?Q?As2dKfnM9SuIwv7qnCcq6acpPmOG38v3JWxhrc1nrdUa9s+nbo/NYiNyhZtR?=
 =?us-ascii?Q?swRPWIEvUZNrE5Px4mH2m8cHiC8ZZeu9/1LjUuPhbJeYoP8DNP06WdUbu5le?=
 =?us-ascii?Q?AR1+jy4UJACy9Y6C2Z0ftl4usGpRXVmHwJKwYps7jRz8QXKHbSkFBghJ+gxU?=
 =?us-ascii?Q?DtN2M80d96s50sSgo5UmwvSZmHpKmTc+0itgaL2H/YZaxVFjvcr2ULmeBReT?=
 =?us-ascii?Q?RhWK4gzVgmi3C8HPK6HqZHx8tSOtPfTXFYJuzp1EGUvEdnm7QUh2M3KCNU15?=
 =?us-ascii?Q?DOiMnPnOPS+aou4ZlhasnTGrtaY4S8LQMoYafsdqOdJXe7HaPBpQaJLNzEgE?=
 =?us-ascii?Q?oNNkGNB9pDahWIlpHBe3OwiYjfFDTx/1tFO+P2vaE+HE97eszlsN375x5lHK?=
 =?us-ascii?Q?zO3wcvcDsn7cOmi+hy/hoAkdY0s03AKBVWTcIcMyWbVcaXegAWSUlPxfSx0o?=
 =?us-ascii?Q?sK//xGQsgMi7A2fu3iawF9feGMAADC04wIw02t2vSLyJwE2OmXdUwfGqmkCs?=
 =?us-ascii?Q?dr8+xwxMpfR64IeIgCpJnua5KidG6rmDgEtydKQz2mdKfi/uCVRuImQawsuz?=
 =?us-ascii?Q?dl9gqxYkny4uLVF8DTP+uluTitfabcY3HE1OtaaTLtyS2zsMKxgECnrMkW4R?=
 =?us-ascii?Q?jhTIzHgiWl24mJEIoQ06h3JctFERVBRj+l9pxYOhFyhAU4dgFMF2GLEhRkSq?=
 =?us-ascii?Q?0HXolimz2upTs4lJ0LaCBxKKGAAcE6eZ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IkkBEk0Lx53DHpO+w8LK5PklIy+Dk6tOy/u2skMy77F0J7z/T36XZlzuIG36?=
 =?us-ascii?Q?4Gf7lTYsKB+nmW6dK2wJVxRjTdmliPeqKASpL95mQcA8rQutoxSv/WiOtfO7?=
 =?us-ascii?Q?hNjDYRg0sdwQW7MHj6qXDr2tpMg9v3CGQeYUTHAdg0pIuOVdftz6JRLuV5MZ?=
 =?us-ascii?Q?P0suScr/adSo052iyJAH8mI0TmB5rSEglsBX395wQt5obzznqJ6ahvzbyTzH?=
 =?us-ascii?Q?pnWXe1RFqTk4r88ADpEWkMUbV7VJPlhy+S87PCM7f8J9wc7THp+T+lqDfsmD?=
 =?us-ascii?Q?COlyldhYN2OJ8xi4gzvB85nP/Uk++D3KH88BgLPrOVuZY//pXSjPw1dvJmBV?=
 =?us-ascii?Q?J/deQV/oy6J3hNZDivYP5AwQPOlV96FrXNSwoLgP2Kr8dIJ65lBGNPuZFLoV?=
 =?us-ascii?Q?YgCctPA5PGhz6XgUUDURgWN+AfuC0+DXutMu2xSzmkA2G5puP/2xxTsPAnD3?=
 =?us-ascii?Q?DmblfT+ulrA8G6vPRIRdA9pOmThAejb0O2WvYYBgbauYC55irGvw5vVaFXcT?=
 =?us-ascii?Q?0L7yjEkZYbutO2B5iJXt24TS7R0Ij0r5x0SDgWfGO3FgIW6K496xlgqCYl0h?=
 =?us-ascii?Q?dsBdQMlk4xPN4G3XFeNq5kkXMmnJ0sB+q+tvSTscirJyKy57eDzfPPkux79U?=
 =?us-ascii?Q?tidvPX2n5CC+lmHOP6yhAAFo288WpiiVTR7N1dx034B2mHHQzwcw4OU2o1hU?=
 =?us-ascii?Q?xdLzN0viGiCVJovoob3WSQ27fjGHQzICsgkfUgfS5JjhqOjnbEvyN2g2P+Ok?=
 =?us-ascii?Q?idcw7TvCVxs9jp2wUHPVS6cpH/sSo8XOh4K5q2W7jh/UT6Vu09Bz82cRsfsb?=
 =?us-ascii?Q?PESoM8BkhoYAFAw8UEnizyNauWo+nF+XhozK5jXnPbFJV2JUoSHqRKCH+rze?=
 =?us-ascii?Q?2KjKMcuwvmAjS9XIbSAP67SH0TFCqgslr4ObfpSFQDypzoY22bEWpkukRFpy?=
 =?us-ascii?Q?sz4xqOyXrgs5OBuZeWGFVYShyH4Ot9BHaC4h314ABNzOuyLexhtJkq+6HBis?=
 =?us-ascii?Q?pFbbVgzkcAfS+J2MZRegtjBlh65LV1ZzGqDl52kGetBtPZ86aWh77jHuPhU3?=
 =?us-ascii?Q?o4R5GemFTCuvrmnYHSVdBARGgYv8jIb0nI72NL+tV54a0G7EKfuD6UrrVEVj?=
 =?us-ascii?Q?jG7ihijjefbvy5klq4RKodCYwdLel+4P8Xj2u+9MJbk6f/kt1sxbxmlW2Jww?=
 =?us-ascii?Q?el8RGgbbvDJPXJbwUC02sVgWwrIC6XmvNDoc4EcqG2jB/lFyIFdgd0l0uxd6?=
 =?us-ascii?Q?AMgMKu27L26orrGrBvIDXTz3asbIrDjdexWh2wsWswayc9/4OYkDvlixJal5?=
 =?us-ascii?Q?LqK27jutfNiZeJlf8/WsLCoJOUAziIG0PGhEbTja9EJl+ZcGaXFyAgMOAPv7?=
 =?us-ascii?Q?W4pziFpr6m8pNowP+A0bZ14Q5ifsWhQE6cKBmBxBBes6V7AmjRdWoZwtZZZJ?=
 =?us-ascii?Q?EU4ad0qTicYe3rI6lyCN6XVNeTBC7V4hr1JZSMaC1XjvXRq3IPVrEBiSmIKH?=
 =?us-ascii?Q?jBUHbFQZatJbcTNjNTesbNJH7vPq/vYLUDk0qet1XbkZQcerHlOGBGoSJj3l?=
 =?us-ascii?Q?uFbyW7I7zo5ajVyM9WQT4KIBXo+RNrsx3fUkJQPX?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ce899b30-887d-4b91-7a89-08de1c0e4098
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2025 01:54:27.5539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fEt67ofxGS83/8a/fyrX+snMu4D+a4Tpjq+fmyqwc68VINqwmrIIRPWCFqFT01jwuHxMVZh7+itcJxWeGQ+BTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6380
X-OriginatorOrg: intel.com

On Tue, Nov 04, 2025 at 09:55:54AM -0800, Sean Christopherson wrote:
> On Tue, Nov 04, 2025, Yan Zhao wrote:
> > On Tue, Nov 04, 2025 at 04:40:44PM +0800, Xiaoyao Li wrote:
> > > On 11/4/2025 3:06 PM, Yan Zhao wrote:
> > > > Another nit:
> > > > Remove the tdx_user_return_msr_update_cache() in the comment of __tdx_bringup().
> > > > 
> > > > Or could we just invoke tdx_user_return_msr_update_cache() in
> > > > tdx_prepare_switch_to_guest()?
> > > 
> > > No. It lacks the WRMSR operation to update the hardware value, which is the
> > > key of this patch.
> > As [1], I don't think the WRMSR operation to update the hardware value is
> > necessary. The value will be updated to guest value soon any way if
> > tdh_vp_enter() succeeds, or the hardware value remains to be the host value or
> > the default value.
> 
> As explained in the original thread:  
> 
>  : > If the MSR's do not get clobbered, does it matter whether or not they get
>  : > restored.
>  : 
>  : It matters because KVM needs to know the actual value in hardware.  If KVM thinks
>  : an MSR is 'X', but it's actually 'Y', then KVM could fail to write the correct
>  : value into hardware when returning to userspace and/or when running a different
>  : vCPU.
> 
> I.e. updating the cache effectively corrupts state if the TDX-Module doesn't
> clobber MSRs as expected, i.e. if the current value is preserved in hardware.
I'm not against this patch. But I think the above explanation is not that
convincing, (or somewhat confusing).


By "if the TDX-Module doesn't clobber MSRs as expected",
- if it occurs due to tdh_vp_enter() failure, I think it's fine.
  Though KVM thinks the MSR is 'X', the actual value in hardware should be
  either 'Y' (the host value) or 'X' (the expected clobbered value).
  It's benign to preserving value 'Y', no?

- if it occurs due to TDX module bugs, e.g., if after a successful
  tdh_vp_enter() and VM exits, the TDX module clobbers the MSR to 'Z', while
  the host value for the MSR is 'Y' and KVM thinks the actual value is 'X'.
  Then the hardware state will be incorrect after returning to userspace if
  'X' == 'Y'. But this patch can't guard against this condition as well, right?


> > But I think invoking tdx_user_return_msr_update_cache() in
> > tdx_prepare_switch_to_guest() is better than in
> > tdx_prepare_switch_to_host().
> > 
> > [1] https://lore.kernel.org/kvm/aQhJol0CvT6bNCJQ@yzhao56-desk.sh.intel.com/
> >  

