Return-Path: <kvm+bounces-69729-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gHYANhjEfGmgOgIAu9opvQ
	(envelope-from <kvm+bounces-69729-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 15:45:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E347BBB57
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 15:45:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4C5873020A59
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 14:45:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30BA432BF41;
	Fri, 30 Jan 2026 14:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WHKpWlGd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4C5487BE;
	Fri, 30 Jan 2026 14:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769784324; cv=fail; b=pr0zTFQkB8Ynl4CKfbw8Y6WMrlDEWb9HLoHVzU/Qit60ZLLclTZi0pJwL4CoQdTteJj/gqslgjKeS02sZAxZMiciqgwxQnw6PwEch0I1D6Mfz4KNTZ8g7m4KauhDGUL53y8BrVRqmsDEuji3cAJXchLvjfqoFsTHbNR1X+2E/90=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769784324; c=relaxed/simple;
	bh=LRMToScj5X/Xy5oR0L3KCXWsEvdYMRBBzyx2QlPNdTk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=R+Oldenn9qrO01qg53xbRDQ0lLdxVPytbTdzBQ1s1dUVwc36kc1LJQJ815t/8/tPUA8BYBlIsV4JzQkWZVkoNSGhOWrv5f5tVCU8mZtR5E8QomZ3O0Gzk8KNDQYpfwjW3ckDI9LGxxrH4F8308G7a3ZDEbV1AvLG2bm58+M24I8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WHKpWlGd; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769784323; x=1801320323;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=LRMToScj5X/Xy5oR0L3KCXWsEvdYMRBBzyx2QlPNdTk=;
  b=WHKpWlGdBAn1v1i4WkmBxTPnJn2hEDshiE221XQlhWYNXK9NF10v8Hum
   QdWj0eQfpPirQu7VNZZuJlX7WCBtaz+R5tLYHhVY2IRrZBmeIm3AJuG9x
   gogftlATmTOm6hyTJvDeWRcKDWyCp6Z4p1TmxQb1Jge86QV8Cs1RxmrGv
   T6GqCLyNv5eLVFPqI8VTJO0MH2K+WioCsK83WK+WUzT6+zv8QLQzd4i7P
   SIpnzkX7d83sUmDRise8jLK5T0KoEkjewiZXViorLnbDWEQdCkpr2KPY6
   tLAcgs8EO3prBgDW2y2f4fZT4emKAzux+bneeKBDaEgzummrNhbmI/z+A
   Q==;
X-CSE-ConnectionGUID: pN8ip7WtSBieyV65UC3VGw==
X-CSE-MsgGUID: zlYcYn0kS7GGfv2u2VYdCw==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="88451335"
X-IronPort-AV: E=Sophos;i="6.21,263,1763452800"; 
   d="scan'208";a="88451335"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 06:45:22 -0800
X-CSE-ConnectionGUID: +XXj254iRHCO5dGGXSQy6w==
X-CSE-MsgGUID: ankFwLbgS0S70oCcHYXldw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,263,1763452800"; 
   d="scan'208";a="240137411"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 06:45:20 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 30 Jan 2026 06:45:19 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Fri, 30 Jan 2026 06:45:19 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.70) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 30 Jan 2026 06:45:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P5tpCl2Hem38FWlSzq8sv7KDUNhN8U2J+FvBpgFpJy1au5RYADNbP6EMlDqZYdw+vbFGT8fhKO2u72j2vVw1XNx5rCDr9QpG2tPM1BMEazpzrllEqyfYvjp0RfaGDQP7GSAE9qhkvJCtS61KitFp21Q3ZdDDle6DEe+zSezIWjDb+kSjEkwFAZCRF6MWyOkxzk6Ly9A+ucra7MfD+pmXYLcfBFp3lPxUtywOBDPBwULMan6QKod8Tq4DkNwJUPqn+OgCeZvQyFnoPXUBEzeW2Xl2Fy7sqrnyEd2U7EAq1D87jwYD1Hz/it8Z8mZRFG7eWHUNZPXES2nTEgIYHE1Qag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3hnaisO56c9lMbPbIemJff+tibFKQGFn7iNiEoWz9cU=;
 b=jhgRtV5rqM3EfrcSZHYU5jnwN/A0Cy5RkvpQmfaRHs6Rc7XdEnfgc5w/JXZA0egeLlDPe1nIgz/bf+dhDZUiDt1gZuj/2CIf15bzTDu+i9ewDgiX1M1h+EhXJeqefgcJwFheICjVVW0PzDR2yxlTocTHn9Go5qJq45aPzqi+CqT7IDjPfn0cKBuFO3e6rTczBAuCIv1vZkv/oYdImdF5gxKix36mNGN9VQNLMHhrhcS+lSh8VlEiDaTHgyBiwv/fKWFBWUxvAWppI00I5+VkO518kCZcZhhLUEjtKl+XC0Urb13kJxwOoflry3Xr/2ZhEb1Canhs545Y8vdYxMC+jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SJ0PR11MB7156.namprd11.prod.outlook.com (2603:10b6:a03:48d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.12; Fri, 30 Jan
 2026 14:45:07 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9564.006; Fri, 30 Jan 2026
 14:45:06 +0000
Date: Fri, 30 Jan 2026 22:44:54 +0800
From: Chao Gao <chao.gao@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <x86@kernel.org>, <reinette.chatre@intel.com>,
	<ira.weiny@intel.com>, <kai.huang@intel.com>, <dan.j.williams@intel.com>,
	<yilun.xu@linux.intel.com>, <sagis@google.com>, <vannapurve@google.com>,
	<paulmck@kernel.org>, <nik.borisov@suse.com>, <zhenzhong.duan@intel.com>,
	<seanjc@google.com>, <rick.p.edgecombe@intel.com>, <kas@kernel.org>,
	<dave.hansen@linux.intel.com>, <vishal.l.verma@intel.com>, Farrah Chen
	<farrah.chen@intel.com>
Subject: Re: [PATCH v3 09/26] coco/tdx-host: Expose P-SEAMLDR information via
 sysfs
Message-ID: <aXzD5nOW0NhCHG7+@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-10-chao.gao@intel.com>
 <9fb1bbf3-0623-447e-86d7-d48ef20fb42c@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9fb1bbf3-0623-447e-86d7-d48ef20fb42c@intel.com>
X-ClientProxiedBy: TPYP295CA0046.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:8::17) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SJ0PR11MB7156:EE_
X-MS-Office365-Filtering-Correlation-Id: 9540c028-3060-4b24-b865-08de600e28fd
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?oBl5uB6+JMykaVOSbwLQQdKFXElaTc9K+JdaoqdQdlGNwPiMRzI31H/h04J4?=
 =?us-ascii?Q?eDCeUWNccmig7SeYWA6wbH7hHUYesnZpsbMuknz3vtB4i4XZKBTmTot3UuVV?=
 =?us-ascii?Q?2qVpRr8CKdCpZetBrbGYTKz35XMe6jy8cvwT/6ZVIXtxH1uapVAKSBHIQw/0?=
 =?us-ascii?Q?bRr5qUxxYJt8TE2zBtbR3QquSaK/1CqIApuQeK6KttzFdWUBGsfVzloLV6S9?=
 =?us-ascii?Q?ABl++cis71bz5VrroY5vQ429kCxWKzzmzsY2Bye8ZKFNYY5kDYTPoFe7cv65?=
 =?us-ascii?Q?cY4oaiWG8oF1eChOEhYCEtM5U5jNy+d07cdMB22uOKSFLsij5mRKQeqvXh9y?=
 =?us-ascii?Q?BSDC1/UD08rW9VbmjR0JNE4R3nzrI1GY8QVulvyPhM04YaYiZp7YHRCcFigK?=
 =?us-ascii?Q?5tDZxoxwoqMPQBJ9RPyP7TQ6QPuNUyI2N36zjBYGm+myv1qPeEt6hkQRWH6s?=
 =?us-ascii?Q?Dq0eC8Jx7a1GM6OASt3uApMiiQOCUNqGdt343ZYt+db7AvAaUYQ3wv4Mt0sX?=
 =?us-ascii?Q?4ZXXppCK+X8pkixSQAjuj7lAG4fQkpKEgzR1scOl+KihhqgiVCxx+dI37R/+?=
 =?us-ascii?Q?6Ku5ut81OZFq5BBXMbKwZgKjTPegpakbHkFQeeRHZv9WC4ZI64pZaOguPVdv?=
 =?us-ascii?Q?PDZDqW11b8n70hA4OFAwRqZdUDd4WOXcOPUeKBicbc6nnGhFAe3uyv0a5J9N?=
 =?us-ascii?Q?Dd7u/rvubosYszMyjCfIFsgTB7B5ORjxv/t4D7wK8jJWrb0bN7UUdgIIAa4r?=
 =?us-ascii?Q?27u6153UK2mmqzEY5cHcwvrT79laC3PT60SrzAX8w6E792SygAcgb2p4cDdt?=
 =?us-ascii?Q?d3JE/q/P88Eqhgvq4Ioc/y8OLN8P8P7Uw/43XBdXbf8S3tC2OvsadBqsYp7S?=
 =?us-ascii?Q?KMGnEa59Q4Y30+a2Op75asOf21grsiNbwS5/bcF0kQYxYpaGhv0tp5rzCc9P?=
 =?us-ascii?Q?IZHUcK5oSrPEBP10sIZ2pTROSk+ao/7WuB/IYXVlMMILa9dp8d3zAq2ZkdzV?=
 =?us-ascii?Q?84SMZY4NEoaKZgCkuZYgiBgKrubtXeU6i20kFgl8gn5KBnDVI/8Ps8AbFK7c?=
 =?us-ascii?Q?Hqwf4ESSyZXJp4Nmy7yXGrvsm19VRwiyRNRiyc+thNT5XKWTcAFbs3NIiRbM?=
 =?us-ascii?Q?5tBuTXLhZLLOdwjVz+bL7R3+B7Buupu2oOlGJ1i5o8F0MuNZWTgmQ8Wt0cA3?=
 =?us-ascii?Q?enjGR+j4eWJNkYUDqRxYURftdnH0NONMLmBpRtQm/O/O/76VMB+6kDS62lYw?=
 =?us-ascii?Q?L5tgu8ctlfwhd1wDTd2aH31ucKokrtdgXGHneWKEWCCswQ+9r95h+/8B9mYn?=
 =?us-ascii?Q?SlYxWFElZg0c8M926zLW4lu4rPTa8pcR1S2Vo+Bz6TBfQzLraaNCN2S/YIMC?=
 =?us-ascii?Q?nAzXD1BnAlPTovv6Vr3sa23ZHWe00pir8h0on9F3v0L2pY4yRqUfQ7232Ptr?=
 =?us-ascii?Q?2XHxYX7vypR42rnMaPE4D0P5g1Fvmd0TfMdDFF2iRZvUPUJDoEQ4Hf0sq0xu?=
 =?us-ascii?Q?TM1xBJZeKfTaaXq55GGkwzkSjRAK0t1gU0EuJv6x4k34+uq1I1DeX11YFTck?=
 =?us-ascii?Q?+HI0T3Md+jCiLBrLMO8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YgO98AdVLbEDsEvE573gpbcvzyKK9M4z60SWi2D1c4Zno9AlIVqMtyOuW0Fl?=
 =?us-ascii?Q?Dloh2jIkaqBQviIiKEdS2iTDswDdowjFriiFQFR0dyirH8MLni2IoWiVkPfD?=
 =?us-ascii?Q?iIamI9WWQwKyvok4OQasyB5dUDfe0Zst163x4sj2XByAR8G5Rk7XxCImEySt?=
 =?us-ascii?Q?iS3Zpcs3iCcPEfwHtXYV3/RSrJ5wOB8KKXzf3pnrB7R9lcGKcQf6GLLBESC0?=
 =?us-ascii?Q?VkTK1iRB5F2zCthvPFfl2JtVX1AaCL8YZVpvwm2KkmXYHQRS1CSXjAmNS0Hs?=
 =?us-ascii?Q?uig7MtxySiwgOK0iBy36kEJ/7q2TnouKDPrN45Z+onX99Jw0/esfroFTgo4S?=
 =?us-ascii?Q?ekGJw/wg+Ok4b45f9Z4/bGrU9yani7YxmpYaEdvjtmXovWmT3JBUmrVld1im?=
 =?us-ascii?Q?51U18o5pDekkfI78+Rc2syPW6n0uBpsmXcER8e8b6a4DxLddmciyecjB0Z/j?=
 =?us-ascii?Q?2yqj/uy7//hgTw88X/i7UAq8Pya8X5Zj7A2L1aYQ9WwgEa8GvwXb83b9UKyi?=
 =?us-ascii?Q?2mBTp92JE+lG3s+0U6SbVa8drfQAOnGUoCf4JM5ZDcOpd6F/vSLTcElRd4vs?=
 =?us-ascii?Q?PZsg+wnqHdkUOzcYjrsdgDP5XKcyQ1S30F3Svm5kXPhDj0OTx1AwMY0c0kzt?=
 =?us-ascii?Q?STdgctQjvxDfeG96z8rOJruRmsZjqubzcxoN/hRYODXRvjDkgSZFkpc7ffQU?=
 =?us-ascii?Q?BR89hnraWR+aHlh7fICcwMJe3M4b8v3q9Vq2GdFTV+LT6F/7YBmb/pB4+s0L?=
 =?us-ascii?Q?Jbsk/D2RzdjXMxF6UygHBZqwupgw1eFWYGA7ki3b2e9p/aPIEqqgNshoVaWR?=
 =?us-ascii?Q?Cj27fYmPFugnYsGgD93fZ5pEfopOhV0r95POlXxMinrVpkOFc85jq18yOGQO?=
 =?us-ascii?Q?cPew3vSIOyIxaMoGVJRRDXYzMK9o2Ew6CM0Dg0yiY/y/1iYsjc6WeHSv4m14?=
 =?us-ascii?Q?GRNYjW8URdMHnTEBXSUGU0s6HJ2WU5zCV8RMg0oeKM5fWyXU9NST8PF6PSxk?=
 =?us-ascii?Q?ckgYD9V1QnV8zXxff98u4v44QKq+ma+yRN19uyXwvjai8wcwJevIOFDs4Gwa?=
 =?us-ascii?Q?w7dGhI0tPI89wSCxTMzlW7OXagg8I3axI4z1XmRKhzrhzfKiaE2/SmjyUWEH?=
 =?us-ascii?Q?PyIHUQFpdkyXAZ6XLdTmfVHyzJ5VZiUzAa/mufACrvM77PA+yW+e6Hn93CQS?=
 =?us-ascii?Q?fg4CNxUXIda+mQsBjw8EIn6UHG02uuj+2nrPHdvG03Id4gVWzpRy4GcU6NNS?=
 =?us-ascii?Q?8360hiJthPLfrLtjQgqDz0CJtkYiz1twFxdWm4/vjGlp5eT6wkOVEabO4LkL?=
 =?us-ascii?Q?kzyHAkOq91G8JKdSwJuBhMsBSnOjFp9UxciFR4F7vFD5ePgMLYawT33Lk1xJ?=
 =?us-ascii?Q?kMiz4ipGuDhOHsDPMRQkzFIOZJI3eUDkRYEKwgJc/0R8MqQ7DM1A7okPVoM7?=
 =?us-ascii?Q?9vklteptekh+jcdXZGbn4zkPm/b4dDdhlM9aAke8iAS5bRSC2RRPLULP2rCi?=
 =?us-ascii?Q?1gLWKVvbxlA897juJRGKCibXpY0nTEkmxD3GZ+qaeM4C+Bxw5BYezmFnvCzt?=
 =?us-ascii?Q?NvRrHKOa2bNgqtOWZEaaWaa22mwt+NlBmOyXB0XZpT3DQ1p0SzHWN+bvnAl4?=
 =?us-ascii?Q?/UPux5OKQirkaX7zCuk9e6uZG/7a0kY1MDS+ijy+2vj8KbCllBZP8ddpSWZw?=
 =?us-ascii?Q?l7mXB4VGzukqAUOKRjmJWP29gJXPX8um+3Crbe/Lp5sBy9I45/f9g8EEhaiG?=
 =?us-ascii?Q?k1cpBKeALw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9540c028-3060-4b24-b865-08de600e28fd
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 14:45:06.9116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LBk8uJkYJ8T50JBioi0jNebvzq2BmtrMd72EV5gACJXrSzHWbEalpx9yjmYUWdYsDlzAPtS0SUxLvB8E99U/+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB7156
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69729-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.dev:email];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 3E347BBB57
X-Rspamd-Action: no action

>> +What:		/sys/devices/faux/tdx_host/seamldr/num_remaining_updates
>> +Contact:	linux-coco@lists.linux.dev
>> +Description:	(RO) Report the number of remaining updates that can be performed.
>> +		The CPU keeps track of TCB versions for each TDX Module that
>> +		has been loaded. Since this tracking database has finite
>> +		capacity, there's a maximum number of Module updates that can
>> +		be performed.
>
>Is it really the CPU? Or some SEAM software construct?

It is the CPU. The CPU provides the database and gives instructions to
P-SEAMLDR for adding records or cleaning up the entire database.

<snip>

>> +#ifdef CONFIG_INTEL_TDX_MODULE_UPDATE
>> +static ssize_t seamldr_version_show(struct device *dev, struct device_attribute *attr,
>> +				    char *buf)
>> +{
>> +	const struct seamldr_info *info = seamldr_get_info();
>
>Uhh... seamldr_get_info() calls down into the SEAMLDR. It happily zaps
>the VMCS and this is surely a slow thing. This also has 0444 permissions
>which means *ANYONE* can call this. Constantly. As fast as they can make
>a few syscalls.
>
>Right?

You are absolutely right. 

>
>Are there any concerns about making SEAMLDR calls? Are there any
>system-wide performance implications? How long of an interrupt-blocking
>blip is there for this?
>
>Also, what's the locking around seamldr_get_info()? It writes into a
>global, shared structure. I guess you disabled interrupts so it's
>preempt safe at least. <sigh>
>
>I guess it won't change *that* much. But, sheesh, it seems like an
>awfully bad idea to have lots of CPUs writing into a common data
>structure all at the same time.

/facepalm. Sorry for missing these important considerations.

I overlooked a critical constraint: only one CPU can call P-SEAMLDR at a time;
any second CPU gets VMFailInvalid. Patch 19 adds a lock for SEAMLDR.INSTALL
serialization, but we actually need to serialize all P-SEAMLDR calls or handle
VMFailInvalid with retries.

I will make the following changes to see how they look:

1. Move the lock from patch 19 to seamldr_call() to serialize all P-SEAMLDR calls
2. Cache seamldr_info and only update it after successful updates
3. Make seamldr_get_info() return cached data instead of calling P-SEAMLDR every time

