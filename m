Return-Path: <kvm+bounces-49944-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E4707ADFF82
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 10:15:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D4EB17BB38
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 08:15:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02E9D264627;
	Thu, 19 Jun 2025 08:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Oj9eoJuw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505F1261398;
	Thu, 19 Jun 2025 08:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750320908; cv=fail; b=ex2gXFkhk37I3kq9QLRWzejgZLbnJiUK81753oaXzl9K6a8kZIhsgsNH+cwmKyy0b5+TuOLaI9vzivbviB2gDnF1Kw8trAaN2FZCYmWv4wgFq3hNDN2DKbN9cdeHZSQiR3sNJiI61bS4hZeWEOSElv6cwJfXkHIaZGWe2LUiqdA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750320908; c=relaxed/simple;
	bh=bu3jCXmsgZyTiy+mqKesrtukEvc9bg4ohOi4hOcULGM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=H9vHLq7JrE3UieaKcmwFnQkaonTh5JU8h9Ns8T9I39ix80uD3LeE8s/86Rna+e/iNtx57JMcDfn1adYQBuVDSOL7IPZVrIlODkE0EZHXtf9iPcBj/ezbjjEIttDu6hx7HQTjJ6NSjxjVGBMCPT6EEOQvHO5lK/XcvBDzKPhGLTE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Oj9eoJuw; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750320906; x=1781856906;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=bu3jCXmsgZyTiy+mqKesrtukEvc9bg4ohOi4hOcULGM=;
  b=Oj9eoJuwTn6AJ1bGQ4WU1fsgyKC2vu1ek9OUhMN/pSOcfUMewd83iMc8
   Vu9D+phBBXrrP8hjnVC2E9euQwzhu2VDMr171J2/ImlN9JFOPk76tu5PD
   PeY8Ongwy7wsY8qBdbJpCa1tDHuqOXlNSezo/hS1Db1MjvHxtuq8IGpg6
   3GafYuDOBoRmaW4AJit7Sj2z8NDfBbjopLse6Bd7we/dK2mlEvXrPtac/
   XI5DPFpHKbg9b6kccefhWpVIIVSepsz3oTc+IKgWzi85n5RqqpI/WFW3l
   wFKhswvLVhUmJXUZhAuOFjpL65lmn3YUL9zBa9IIsdbuWLK9R3QB0WT7N
   A==;
X-CSE-ConnectionGUID: V7xt1MIrSwmH387k+g8e0g==
X-CSE-MsgGUID: BMWxGrLgSZ2WhLGfx2x3YQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11468"; a="52446203"
X-IronPort-AV: E=Sophos;i="6.16,248,1744095600"; 
   d="scan'208";a="52446203"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2025 01:14:44 -0700
X-CSE-ConnectionGUID: KdHX92AwRvK4ttcxC7zKcg==
X-CSE-MsgGUID: l3wu7+raTB6RLjxqSqy2SQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,248,1744095600"; 
   d="scan'208";a="174103685"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2025 01:14:43 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 19 Jun 2025 01:14:42 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 19 Jun 2025 01:14:42 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.79) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 19 Jun 2025 01:14:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BydYq5g0KjQ7PrbmmF679Muoi5dqLW5qugSqtiddH0INHE46bSnB4xJAmRSuxf23nWax1+90muLzYo5ZXxPGNlu4N5tlzYeNAnWH2ZdMasuAdTr6mQNCOjEgPUjr3rEnMgZVlCfQlLxs8K852bAmspoXfnbzH/suXQa9yjKcBA5g9KaX2uaDcSUmnp1JGpq1bRlIxZO9hA3EK7l1FDjGU667xMx/P831zy0Qn0jmd0tTbFXFbaCMCpJg2/G/fXGGki22PpSh50cn/VnW1MQZ6/YMlmqKVWF9EdS+xF2G6Sbu2qPvK+dOZOabMqDXk/UkcCyDwYR/C345eUQq8FLYFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CQg8TQ5KoFN3dODafu8990suqMs5rEi0kp8TgRoF8xI=;
 b=PmZhJ602JeN6bXyp1gUUmdMCogtGCNtY1HX2RVSg3KxNDYtkVEmJFlwK6Y5pcWzHZQCTg6yjn0QMwhB8CXOrN9cIjHC311Gdb6liIrFvt9o/4sjVtlIZfIMx5N9Av8KrDGgJzp76WLxqVoMDke9KyrcdOotn0K4SXjm7Lk0NhaOlBYcU5uTpDvf8fY0ktbOQ/HuJ0PRBu6q1YFXtq3yI/cxBCS/bc2cLFLtVaEw91Px+kUVw9UmzbXxlPgxJZZzxk9fBFNSfqmv5M2QctejRaR4G/yyCEsbmuVL/f+wfP35thMomB+SSzUI8h9ziA7WET6RS5HTbO15OguSdrsqRag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM4PR11MB6408.namprd11.prod.outlook.com (2603:10b6:8:b7::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.29; Thu, 19 Jun 2025 08:14:12 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8835.027; Thu, 19 Jun 2025
 08:14:12 +0000
Date: Thu, 19 Jun 2025 16:11:41 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: <vannapurve@google.com>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@intel.com>, <tabba@google.com>, <quic_eberman@quicinc.com>,
	<michael.roth@amd.com>, <david@redhat.com>, <vbabka@suse.cz>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<zhiquan1.li@intel.com>, <fan.du@intel.com>, <jun.miao@intel.com>,
	<ira.weiny@intel.com>, <isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>,
	<binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Message-ID: <aFPGPVbzo92t565h@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <aCVZIuBHx51o7Pbl@yzhao56-desk.sh.intel.com>
 <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
 <aEEFRXF+HrZVh5He@yzhao56-desk.sh.intel.com>
 <diqzecvxizp5.fsf@ackerleytng-ctop.c.googlers.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <diqzecvxizp5.fsf@ackerleytng-ctop.c.googlers.com>
X-ClientProxiedBy: SI2PR02CA0013.apcprd02.prod.outlook.com
 (2603:1096:4:194::21) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM4PR11MB6408:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e3544d7-5461-408d-68af-08ddaf094627
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|13003099007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?JKjRuIV1gH4iEVFDH8p9MuEqdIxT54vS96LW40w+BZP1KYYihatItX9Je5lU?=
 =?us-ascii?Q?cA8LQ7iidHrjjyB9wVoR8RZ6jE0wQ3er7ySAgy7IXjRIOG/ImTDGMRAWw85Z?=
 =?us-ascii?Q?0dz2ZKgNqdevk3B3kUuJJU059whF4LXhKwdwS5qLhXgp/fybi4U6fAotnXYU?=
 =?us-ascii?Q?FEpzPVTY6JyHCtWljuyd4i+XM/lan6f6em7666x6kSKyG3ZYQjwZCb7zh2SX?=
 =?us-ascii?Q?h9jrCSYAbOz9lDSGSpe0CC6Ak5716gJ5LLaNyEWJTT/HtmY6LBGSz8tedApK?=
 =?us-ascii?Q?gOBz9/gx9/5jRhI6n0LaFh3/nmoLntPUbtVshAdWGVz/wYFbBXsri0Auiw2f?=
 =?us-ascii?Q?rCjjaqeFYGaYJZjRbZ+p/6bnjA9K0K+I5GflCQ8H5fDx0DqvRUZCqOIzm9bU?=
 =?us-ascii?Q?27KpoQmE56jsFK2kPnkRFaGHatxgQKl6AS4XNgVuNrVv0PGr+RB5ybxCF4ZY?=
 =?us-ascii?Q?US+uIsmI6w9DnGoD2Pso08wcMaIunH520KnJY4k7+FCZJkX5t4A6w7DGdX9r?=
 =?us-ascii?Q?zYRAy5asNwcjcSd6I5VZcwy3cJcRkaGr1vCjhjSdnnZDQDEWvIwpBg2O/93j?=
 =?us-ascii?Q?rbfK3wc6X9eXZrrpNUPgdmJkwRaEIhUAs6XRYcbYcKBJgQ96QuFAEAN5vLAH?=
 =?us-ascii?Q?re8BPiXYGmGHvqjejbySFZbmSxXKJyb12V7ESxh+77eImOWAjQOJl3vXWZxZ?=
 =?us-ascii?Q?eysOhGg6GxwEmVreviElzDhVdUpGGfND+PSFvxwntpX8RLedQyGtZ1GyPaTO?=
 =?us-ascii?Q?QgUlK9QQhklYG5M8tqv+FznjU2hdaGQWcX5GYGVA60LPAiqjf5mZeKO3H9iZ?=
 =?us-ascii?Q?uzXNXgOyaLyeQm7QgpiNktUGfzEuzI7cQgfB++7GnM8PcTEUwMz1DNHnV7hI?=
 =?us-ascii?Q?tlifkdQKQwBLYfR4E5xAQFtfnz/0t8+GaOYDnhcZcRYIuy0BHWCOGIDb3Kcd?=
 =?us-ascii?Q?QYEFiU4PQPY0xoZDXlEs58XOm59jaKRfiMhWGj03QwLJ7D6KIhN97v5kXNVq?=
 =?us-ascii?Q?8qcUXu1R8O0383VsaqZWMIFafx1Xvaw0tvoFXNOR9HKdbDf3x7t5x1a9ELO7?=
 =?us-ascii?Q?QxWFMRYGmEMnMFnKJgJZxrvj5YjOyZo65DLbs1jdW+CNn0pWRNDbqcqoxh6n?=
 =?us-ascii?Q?UI5zbI4XO2Ip5IN9sBQL5qvCrRM5R33cyU44TaMeub3x83BUA7wx+qEaZSNE?=
 =?us-ascii?Q?v0j5MTFQAq6JoNozMi/+yjd+NWQ+RfzNx9IsW9cU8Y8ovHIEfcbvpJtcrnmZ?=
 =?us-ascii?Q?xJTy0uZ0FTRU9yABOxtZyccf/uKGm7UV0hrdyYkgqpObibW74pu0+EX3CipN?=
 =?us-ascii?Q?PeZIQAqX5OZ8+kbDRTPccHmUFTo3Y9y/0XPAOUIXrnL7zb92Q0/uOJO+6Dkp?=
 =?us-ascii?Q?dXVaEdjGZnc7JU/PAWY+1O45Gkk8?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IAXH/j5ujq3yMiXv9cTkssPgbgcdlgBwQDRBTd8Ko3kpPaL4VlOPJ6lQh4pH?=
 =?us-ascii?Q?JBmf+1tC3BR0k71ODLGv1mm6O8v2f3bwVQRVfWYOld5xzgxY2MMVyfc9lDPk?=
 =?us-ascii?Q?KBqqmL4zt3edafrFL8TwVRrUMZfaYoth4rVGFvRJnQ/7fx7KLJE92eIPse7W?=
 =?us-ascii?Q?P1R5m42+vQciz11Huh8LyHDQ6gCMOTC35bMWriNBP7iCvYnFhyxp89jNXN4J?=
 =?us-ascii?Q?bQSdrPxq9G6Xy0q/ONGVg6ZUUhMT8Xx0DZ8hbDYNhJwQ5u6HVwjCpYkUjtaL?=
 =?us-ascii?Q?J0PS2325BUBLtsxFXFmaOUPreIqEL2z2ZjntA4fGNOcZQQNBzkzqOUmdwISE?=
 =?us-ascii?Q?ERgjQ5BXhzwPV1wp7nnIav5HcIU5wCJX4U35h3EGOH84TpSSRopLIhuOzwDQ?=
 =?us-ascii?Q?9hj3cp4BbSsKaOPPxW3fKHM+OZR4MzA0ybys5wuTQdVJ13pqUrD5+KIhAouL?=
 =?us-ascii?Q?mY6bzYmyDEF6WZUcbKhgHX6EDEDkQlcXgwtAbu8jmyh8j/vNZHme33p05CiM?=
 =?us-ascii?Q?jJfiCuyHPd2P7pec1iQNc9bOTItLHuHpAMokLl6TXj3MUKSWXFTiCeJLOiAj?=
 =?us-ascii?Q?TmKFDPO8FSjXkVqtfSoe8my7T3EkvueBJwGB2yk4JHd83g81cjofEVR4hxC4?=
 =?us-ascii?Q?zSVJdtR0gCtEevWfta4rzwm8G46oH3VgRDTXlayMxKrFtK8EDsx/sCj/03/X?=
 =?us-ascii?Q?pcZgZxzp+5qhGntINlP6wgr9IFOjJ4dTIj8PPuJ8xA2WLYfGig1SDR8a+scB?=
 =?us-ascii?Q?MbvHvsMdFHnRHMzApRNEDW5mtNWsWyMCAnhu4sXr6EYM2MwVWYM+HSNXjTJc?=
 =?us-ascii?Q?ILQUAyitMABFZ3rCw2iw8IcJOp410H3lyv7OvKexFgxcdz0uLrDGZCIwQhGz?=
 =?us-ascii?Q?a+y9WFlVL6jW85PAKlhsqQwMcpY+iLDvWBT82TFwqdQNeJgNEfyLy8jwTpOb?=
 =?us-ascii?Q?ydHTBKbt357ZQStM5s8yJyXNjzqtEIRc4+8X26Ua8ROvpDKUxKKjKd93sb6m?=
 =?us-ascii?Q?XlVeymTJHSC36Gy9jhzPd6VyUxcHojVsI5tZ2HHBYwkQT2/fcdao7rdB+Geo?=
 =?us-ascii?Q?yVhprzDNMmykQ9rNnlNW08KdTi28jSyNwPH3jXUlD4btMzkEcQIOrnZYYyok?=
 =?us-ascii?Q?ebWIHIPAnKEXjztEk4JBfk0jDc27DMxCRK/0XXrQkwflp591Fn0LZdsXbPw8?=
 =?us-ascii?Q?73lpGi9EbsrQL1m3sej1XMfiUSi+kDtTn+NVEb1vFMwagTfah5iSQQbsH8Z8?=
 =?us-ascii?Q?vSga9VF7p7GTcmapR6w4h4cqJUUSLsuVmXyDmHGJ20LIfpvBNm2JBIgb7wUw?=
 =?us-ascii?Q?e0r32kfUFmkE3UmHviEk6lFDtlNAf4rB6++ab93rBc67KbZHBlqzypiB/2I2?=
 =?us-ascii?Q?E53holleK7YJCPQzD41kR0ZskHcfGM6ymVF7q4W4H2d9fUp1sUsjTaApZhUo?=
 =?us-ascii?Q?rHSErPPlNxUh9zpWb0iMTqtS7qqBskqZ76xDO5wx278mBOpO1J4xKkqv9Q5T?=
 =?us-ascii?Q?bFD7ZKyTPZcRc4+ZBXXDfVwfmqS7BF4JHzenvZvccW3QtSmuQK+AyhdnWsSb?=
 =?us-ascii?Q?Dj4IdZe22znKuTmVw5FAQTDz7NK6uobKMWdCIaGJ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e3544d7-5461-408d-68af-08ddaf094627
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2025 08:14:12.4906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jkQjv9F1jNRXkg3vKPO28ffBvZqduST0/g+B9o+RpqnDGmZ/jIdXNE+fY042PNSipPcCbZfpAfP7cQFKOrD1rQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6408
X-OriginatorOrg: intel.com

On Thu, Jun 05, 2025 at 03:35:50PM -0700, Ackerley Tng wrote:
> Yan Zhao <yan.y.zhao@intel.com> writes:
> 
> > On Wed, Jun 04, 2025 at 01:02:54PM -0700, Ackerley Tng wrote:
> >> Hi Yan,
> >> 
> >> While working on the 1G (aka HugeTLB) page support for guest_memfd
> >> series [1], we took into account conversion failures too. The steps are
> >> in kvm_gmem_convert_range(). (It might be easier to pull the entire
> >> series from GitHub [2] because the steps for conversion changed in two
> >> separate patches.)
> > ...
> >> [2] https://github.com/googleprodkernel/linux-cc/tree/gmem-1g-page-support-rfc-v2
> >
> > Hi Ackerley,
> > Thanks for providing this branch.
> 
> Here's the WIP branch [1], which I initially wasn't intending to make
> super public since it's not even RFC standard yet and I didn't want to
> add to the many guest_memfd in-flight series, but since you referred to
> it, [2] is a v2 of the WIP branch :)
> 
> [1] https://github.com/googleprodkernel/linux-cc/commits/wip-tdx-gmem-conversions-hugetlb-2mept
> [2] https://github.com/googleprodkernel/linux-cc/commits/wip-tdx-gmem-conversions-hugetlb-2mept-v2
Thanks. [2] works. TDX huge pages now has successfully been rebased on top of [2].


> This WIP branch has selftests that test 1G aka HugeTLB page support with
> TDX huge page EPT mappings [7]:
> 
> 1. "KVM: selftests: TDX: Test conversion to private at different
>    sizes". This uses the fact that TDX module will return error if the
>    page is faulted into the guest at a different level from the accept
>    level to check the level that the page was faulted in.
> 2. "KVM: selftests: Test TDs in private_mem_conversions_test". Updates
>    private_mem_conversions_test for use with TDs. This test does
>    multi-vCPU conversions and we use this to check for issues to do with
>    conversion races.
> 3. "KVM: selftests: TDX: Test conversions when guest_memfd used for
>    private and shared memory". Adds a selftest similar to/on top of
>    guest_memfd_conversions_test that does conversions via MapGPA.
> 
> Full list of selftests I usually run from tools/testing/selftests/kvm:
> + ./guest_memfd_test
> + ./guest_memfd_conversions_test
> + ./guest_memfd_provide_hugetlb_cgroup_mount.sh ./guest_memfd_wrap_test_check_hugetlb_reporting.sh ./guest_memfd_test
> + ./guest_memfd_provide_hugetlb_cgroup_mount.sh ./guest_memfd_wrap_test_check_hugetlb_reporting.sh ./guest_memfd_conversions_test
> + ./guest_memfd_provide_hugetlb_cgroup_mount.sh ./guest_memfd_wrap_test_check_hugetlb_reporting.sh ./guest_memfd_hugetlb_reporting_test
> + ./x86/private_mem_conversions_test.sh
> + ./set_memory_region_test
> + ./x86/private_mem_kvm_exits_test
> + ./x86/tdx_vm_test
> + ./x86/tdx_upm_test
> + ./x86/tdx_shared_mem_test
> + ./x86/tdx_gmem_private_and_shared_test
> 
> As an overview for anyone who might be interested in this WIP branch:
> 
> 1.  I started with upstream's kvm/next
> 2.  Applied TDX selftests series [3]
> 3.  Applied guest_memfd mmap series [4]
> 4.  Applied conversions (sub)series and HugeTLB (sub)series [5]
> 5.  Added some fixes for 2 of the earlier series (as labeled in commit
>     message)
> 6.  Updated guest_memfd conversions selftests to work with TDX
> 7.  Applied 2M EPT series [6] with some hacks
> 8.  Some patches to make guest_memfd mmap return huge-page-aligned
>     userspace address
> 9.  Selftests for guest_memfd conversion with TDX 2M EPT
> 
> [3] https://lore.kernel.org/all/20250414214801.2693294-1-sagis@google.com/
> [4] https://lore.kernel.org/all/20250513163438.3942405-11-tabba@google.com/T/
> [5] https://lore.kernel.org/all/cover.1747264138.git.ackerleytng@google.com/T/
> [6] https://lore.kernel.org/all/Z%2FOMB7HNO%2FRQyljz@yzhao56-desk.sh.intel.com/
> [7] https://lore.kernel.org/all/20250424030033.32635-1-yan.y.zhao@intel.com/
Thanks.
We noticed that it's not easy for TDX initial memory regions to use in-place
conversion version of guest_memfd, because
- tdh_mem_page_add() requires simultaneous access to shared source memory and
  private target memory.
- shared-to-private in-place conversion first unmaps the shared memory and tests
  if any extra folio refcount is held before the conversion is allowed.

Therefore, though tdh_mem_page_add() actually supports in-place add, see [8],
we can't store the initial content in the mmap-ed VA of the in-place conversion
version of guest_memfd.

So, I modified QEMU to workaround this issue by adding an extra anonymous
backend to hold source pages in shared memory, with the target private PFN
allocated from guest_memfd with GUEST_MEMFD_FLAG_SUPPORT_SHARED set.

The goal is to test whether kvm_gmem_populate() works for TDX huge pages.
This testing exposed a bug in kvm_gmem_populate(), which has been fixed in the
following patch.

commit 5f33ed7ca26f00a61c611d2d1fbc001a7ecd8dca
Author: Yan Zhao <yan.y.zhao@intel.com>
Date:   Mon Jun 9 03:01:21 2025 -0700

    Bug fix: Reduce max_order when GFN is not aligned

    Fix the warning hit in kvm_gmem_populate().

    "WARNING: CPU: 7 PID: 4421 at arch/x86/kvm/../../../virt/kvm/guest_memfd.c:
    2496 kvm_gmem_populate+0x4a4/0x5b0"

    The GFN passed to kvm_gmem_populate() may have an offset so it may not be
    aligned to folio order. In this case, reduce the max_order to decrease the
    mapping level.

    Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 4b8047020f17..af7943c0a8ba 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -2493,7 +2493,8 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
                }

                folio_unlock(folio);
-               WARN_ON(!IS_ALIGNED(gfn, 1 << max_order));
+               while (!IS_ALIGNED(gfn, 1 << max_order))
+                       max_order--;

                npages_to_populate = min(npages - i, 1 << max_order);
                npages_to_populate = private_npages_to_populate(



[8] https://cdrdv2-public.intel.com/839195/intel-tdx-module-1.5-abi-spec-348551002.pdf
"In-Place Add: It is allowed to set the TD page HPA in R8 to the same address as
the source page HPA in R9. In this case the source page is converted to be a TD
private page".

