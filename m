Return-Path: <kvm+bounces-38005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C73BA3389B
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 08:16:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EED2F167F36
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 07:16:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A7E72080EE;
	Thu, 13 Feb 2025 07:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TcFzkWjW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92509207E14;
	Thu, 13 Feb 2025 07:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739430957; cv=fail; b=R6DhutobJI0WZFtCdy8F0m6fZpukxHoyshqkKjnIcv8NXyyoiywqk16tQqfMHH9xHGuh/CxqJs3FNRATk/MzqehG2ikMiKp2H2LCOYZrodyyor61uFKUU5yONnF5j6QqeQ63sFSYJpdrJb8B18vsiDcLypmOEl3B5gB2uS932Rg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739430957; c=relaxed/simple;
	bh=aRHydnByslsIq4DJcGgbSVN0Guvw3peyiriD4XtfsIo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tW69qniMyHBF5J9uy8Bzl74UnH+yg3Lyb6pXJ8hV6cVk/DvAYSD99Colb+kLzKNWU7DqWuaSHkrZjECnM1/lqKC00tOYhXOeM7nN/X3O/8u81sOM+yZbbxCs/gTJNP7HNL/MhQos+h3rq/QCvPCnjxTKHnfSGujW0VyMDDQCKH8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TcFzkWjW; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739430954; x=1770966954;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=aRHydnByslsIq4DJcGgbSVN0Guvw3peyiriD4XtfsIo=;
  b=TcFzkWjW4KbOioHEln3V7Fm/wPxa/DZNohS3nLc3yr202F7y4FH1ttHW
   +Kh6VB9H93v6ujlZB9ZBU+9wpeK0iCGD9WBxBgvgL2HvHykL7OUcSKhXH
   /dNYDOWy/urCPABMBI+Q72ZjGA8LZQP2EstTCr2EmbeYX3XSep91+p54s
   pnk600x66zlNGhqfLWHeXGEqYYu0hYEnoK2lJimqSXMU4tmVDjtnuHakX
   Rw29F4qpt7PAhi/GQRy4pUq6eMkrwYoBwWTn7VTrKCwf4JaWRxybbHOeC
   zPOBv2qMQJpCSpMIAtmuLY0C+FWFhreMz8rlHgxXjRWHhk8sNTcZLQrD/
   g==;
X-CSE-ConnectionGUID: RH+Y+dR6QditgIMc885jpQ==
X-CSE-MsgGUID: AZkhFA5fSJOmeNGGywirOw==
X-IronPort-AV: E=McAfee;i="6700,10204,11343"; a="40037710"
X-IronPort-AV: E=Sophos;i="6.13,282,1732608000"; 
   d="scan'208";a="40037710"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2025 23:15:53 -0800
X-CSE-ConnectionGUID: kMZUgUr9SM+Gq9gH2ph5WA==
X-CSE-MsgGUID: wOhzop91S5ia3m515/QH8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="118242289"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Feb 2025 23:15:54 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 12 Feb 2025 23:15:53 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 12 Feb 2025 23:15:53 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 12 Feb 2025 23:15:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eeqsTev1JFpkLWyb41cQRvN35tyM9R8A+UrH7IZbzx3cZ+IZlHQpbaRmZN/wUhkLRkS0wDUlgay3YvcIBeT+1CyMgc1yQJKGKz4DA25HduM3pc0PGRRDL1whykbZ08Tq5lCnK4jAOAvOIteVHlHSL+zg5SU3dWH14drh4HBUReSAcWGtP2PRWOxtxjEkpzEaevpp0zuw2ZL28+jxRgcd/Vhh9hTfd7GerQZ0Mje2go2tIyVSc/0n5oGn20idAqmJ4tAUAgG7k9drSz1T8/gAztbBthTKLV+rTZOq19hRBrxFGhnH0Y0bO7fBOgGohAgaRdBqa6pRraQxGj7Tez/R3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+oPCgh3GkEnExKCWkZRGOLapfTlmQbgyzL1MsDlxBHs=;
 b=LA5E9yQ1ZNLopr0Wa30HeCrq1U2DVjrvYwEsAgbm10QIYZtCyS3xApSz7tQlKucbLxHQXOJv6ruKyQSQriKxmZ9hOBWCyr4Y+evqXy6ygMlvqe6PikhITJ7jXzvv291mpwg00RS5vIjvVqskQUdDE6DxS4/VLrWJocrWjKqij9E4Z3iIKPKXjCbiS6UWJ/KEwJGNH5Awfj1Ui2XCyEvfJDyIUIGMHhtHohkkuL+7C5EQlUks0NLqci01WmWhLAWJWXZLw7o4zOXjJWGymCnhh3b/oeEAGgpq67MLw525WChP+OPFV0bbkoVBe9aJg6fU8kSxy+sJzO4iZ/ji91DrWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CO1PR11MB5106.namprd11.prod.outlook.com (2603:10b6:303:93::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.11; Thu, 13 Feb
 2025 07:15:49 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8445.013; Thu, 13 Feb 2025
 07:15:49 +0000
Date: Thu, 13 Feb 2025 15:15:39 +0800
From: Chao Gao <chao.gao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kai.huang@intel.com>,
	<adrian.hunter@intel.com>, <reinette.chatre@intel.com>,
	<xiaoyao.li@intel.com>, <tony.lindgren@intel.com>,
	<isaku.yamahata@intel.com>, <yan.y.zhao@intel.com>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 04/17] KVM: TDX: Implement non-NMI interrupt injection
Message-ID: <Z62cGysScanH4dcT@intel.com>
References: <20250211025828.3072076-1-binbin.wu@linux.intel.com>
 <20250211025828.3072076-5-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250211025828.3072076-5-binbin.wu@linux.intel.com>
X-ClientProxiedBy: SI2P153CA0011.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::14) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CO1PR11MB5106:EE_
X-MS-Office365-Filtering-Correlation-Id: c0d212a2-abb9-4091-f63c-08dd4bfe3dff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Z7Lz4j2EFNVjTbaF5gXhOnUZsGO8Y7BhEW7dBkdt2en/3RlOsc6tpCZ0Ybqw?=
 =?us-ascii?Q?POSsB/W0zDLhEIYh5yvqTdibBnVhPKY5jiHwnCJhQPOCENaWYwA+vPMi3I03?=
 =?us-ascii?Q?K3m8e3yhyfsYO8vy1TvvQBksUO9YFkmjfo2vaYVrMSl+5ASxVHoTmuLjLMq5?=
 =?us-ascii?Q?q8vxkDnx5lCJKKmDm+0OGVFd/i6c1o+ot1g8ZFfN/4H/nRPQHtIaoZeflyO1?=
 =?us-ascii?Q?FDcL2uMFUStGtr13JFpQ+OYvnUKROW/plPMy1G2oo6AVLlRazvPiPpUi5+0T?=
 =?us-ascii?Q?JK38sqS0F6eC+vDafZL7vpLzhl3zCfC49/vRSS+LdqiQW6jw9Iuimk1IQ4gI?=
 =?us-ascii?Q?keatHue/KcFj1CBAnSuyO/EIggnuYj5soQeLwy+5pt5lpZc5mhPdQzGhSkfU?=
 =?us-ascii?Q?dn1kLcNZ2tGcEHdCRzAVYMf8+Q/dZtvjeHrnAg4nRw3IyZrKfexzcqN+q+Gq?=
 =?us-ascii?Q?aO1OU16wA6TreLOV+yxY3M8k0EABppSvDhUV4St+SqZXOv7s+xnITQuRi2pR?=
 =?us-ascii?Q?jlknlzYdT8sALs7QdZr0gbhgQUUzDvA3et8bIrVdKEv6U+x9ihKDqr+5PE+4?=
 =?us-ascii?Q?kX1annKrLOJtv3j86ob5ke/9PdZjVwjI63PQttGa/N0eMeD60w0hHRJCIGI1?=
 =?us-ascii?Q?oYdDQlq0EknF/DWa9/XEUdss0LzXsSKLPeBFoat0J07pH1N3z8U+04zElSsg?=
 =?us-ascii?Q?Yb2teNked0dA4/c7MC6eKPKTmxEn7qYFAX+TGYL8ojRgpkgRU42yUO3/xtwW?=
 =?us-ascii?Q?Z/4+kdOpvZDw2vJ6UvNkX8elWqty8Us4E0NuvfPbJPmzCUzPAeppSAAJe03e?=
 =?us-ascii?Q?ZAaiJu8sxNzUZINRV/3FILYLvxX1wkx8XKxB+uUWbcjESPAkP5UIWB5bTn8I?=
 =?us-ascii?Q?TqeFFp575K9WILOGcTQRDSueMG6PAZZ+p3jo1k5dP3vnUCdxdj8cDXzKpabp?=
 =?us-ascii?Q?XSPDaizinz7JYmSTcD+Onu2l8l6IsIp4VLEMLbR4VjCx19W2GuiyIlmjw+l0?=
 =?us-ascii?Q?iJIv/XK7tWZ/zKrjDB4nU1gHh/7xPqAs3ILKfR4Hm44TMsUbxCoURfcMik42?=
 =?us-ascii?Q?rytijPm88Nu0fxdu90ILDjuI5Tu28EDAfZSnxM/8A1F0df89u0B71ew3H8it?=
 =?us-ascii?Q?YXfJp46AZQ2GDB/eG2Em5AMuDwZ6lgClxPxOPxlePAwDhj9BAKUlhvPyw1Sl?=
 =?us-ascii?Q?05KGRrN41aX3v0NEVBC3+9wYp/5KzVWs1iPYJCpbRi0kk7vvjwba3VVV1oQ6?=
 =?us-ascii?Q?tWodI2hboHX3853VXEmcJAdUqqtavF0BKwOg9BtV7T07x8h3x4C6x/vmzWFb?=
 =?us-ascii?Q?gu2AEQmIu8ieiVhvCv9R5x3+05V8rPuwQx9EcQtH6aJSwwPfrAmsmk4dDQcB?=
 =?us-ascii?Q?/RPXXdrZOj24hpMrvCT03MOD5HLS?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6i2ENNjV1wTujlHjqYqTZhtXiUhq7eGwrwpQK21ja834XiP7q02wLIEzwzcb?=
 =?us-ascii?Q?RAfN76wWkZLcGdnkoAamZUP1ovNyE1U+CrOrRRzd5Dk9I97Fk/oxR+5QSwO+?=
 =?us-ascii?Q?SvWbnPSVAqfnseDwzMYy4ztpyXfGyUgct+rhKHeQGEMRoJsaDNivZxYcSvOZ?=
 =?us-ascii?Q?dyGJoYPf8wSii7cP36XNjTvGiAQJZ36ok46M6zWI0nhwOWFyhZcI9gmL24fi?=
 =?us-ascii?Q?iAyPWw2qwZxbhqkcL/sOIkH/0Hg2tBcGBx4FjM5+++heJdATU3HUPB8kiLf/?=
 =?us-ascii?Q?BZE8qRqgbKirNgF2MuE/N4LhffTSeumRlh9D6Ve3kZDHBNyNE9Hk47KQKMZs?=
 =?us-ascii?Q?g40hbIIWCozRuHjMzl1mNbLMXl0k+4yHE7pvT+nFZujrSmppNBE/zXBlrcw6?=
 =?us-ascii?Q?AsAF1GmpQLYEo4PpO1CykhFtywf2EdFz7mTBv6x3jrjV6bZuv3rpFJ1Yf4fq?=
 =?us-ascii?Q?Cyd5IdfoglDd94DDIoO5MVWl4DSO37qKnknb+tsFEgTFmF478GoTaJBD9Q1u?=
 =?us-ascii?Q?yY0TuAqPyx0SDWMLHo+hrSEJ6KvFsCg0oBL/m/JZRzGK1JZS8l4ZlWUebsyx?=
 =?us-ascii?Q?mYCgSKWzkPIfbrah5x6T9I+74XasMzcLyIFTqYUoaYYg+zkdoLAmP9lThjKT?=
 =?us-ascii?Q?AaxANU2QvvDMRY8OW3k9ZlvyrXKWT2XpXly8A9TP14T1j64wGjlMYE5MePz0?=
 =?us-ascii?Q?+3rXxu6g7VXkfw9CqrTkMIJWW1WmvU0/yGeKY4s7PmcoUzzh+gcG8BCjypXu?=
 =?us-ascii?Q?s1aS4T3SY3w1EvHVD3nTfl4YmMpuxnPKNjXaJ+9IOwgrCkd7RCwzsiiDS+Bd?=
 =?us-ascii?Q?4m3U6Ummd6sX9qxA3tQ2y2RFFCSuP8ZpKLmubnGHa9AQzpoC1To2b2M8MZNu?=
 =?us-ascii?Q?3QpeJg8aWvBYNAE63e2j65c1pWWFbuw32VoBe1py/ChcvA16FzN2TOow2YL0?=
 =?us-ascii?Q?x8A59WrQC+teD2rsGWP/eyWcK/kZkKONbFBTAuS0hREAor0VkNotLvRUV0zn?=
 =?us-ascii?Q?MKWy/eg2SJhfVbBRD6h3oExgKSH5zdpn6UZwO/R9JGuV/IbehS+7GqI08m9k?=
 =?us-ascii?Q?/j2RWNRucyojnyR6/K3nxuaFBMB/JgmQIgoaa15rVkPHHNZlID6SblS8Ce2W?=
 =?us-ascii?Q?aHfIyFGCNsTshmeX9d5aWioirvyTDuRrBvy/o4dXi1oG8bfXGyBdfJaPpgO/?=
 =?us-ascii?Q?nnCWV35BwucRRzbZphKDeFYmoLkUKwWSlMu/C8ewdufNmHCvDgd2HOQtVhOQ?=
 =?us-ascii?Q?W3kkgrYCoHesA7+XmGnmkCvaWJt8r0L7ujXX1c2dxA2NqhnZKnX9pUpq3xJa?=
 =?us-ascii?Q?0mNQYqTxDhHHBt7mthYAXYiOSa/mApjmhX6C1SNzox5ziSk9jCsg0KlMH6Hq?=
 =?us-ascii?Q?GMf9zlO65sQVcwCWPdd64ijz0o4+It/MGl+IyFlS5CxvKaB2x2pqu1tqD+8e?=
 =?us-ascii?Q?+3lWbmfodB9Rep7i2Zobzy0+Z3kQhnsQX8zswV5hfi9LiI1WFpbGvgYG+UZo?=
 =?us-ascii?Q?Ut2htZ9kOFvIYHdR/FwLQ2yvr91SFhuSQlg9Ztpk09lmpepv1oNa43LxfruC?=
 =?us-ascii?Q?cqreRi+zw5qH7xUo7TTeYUnq/plO1zbI+0iw3u5k?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c0d212a2-abb9-4091-f63c-08dd4bfe3dff
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2025 07:15:49.1500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m4YJmBWvSxAj5qTyQKCGSa8jYbEol+ZA/7rGp2m4bApvyLZEPlNO86skVndSmRAW9g8uRH8WN9ax0g0C/nBRbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5106
X-OriginatorOrg: intel.com

>--- a/arch/x86/kvm/vmx/tdx.c
>+++ b/arch/x86/kvm/vmx/tdx.c
>@@ -685,6 +685,10 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
> 	if ((kvm_tdx->xfam & XFEATURE_MASK_XTILE) == XFEATURE_MASK_XTILE)
> 		vcpu->arch.xfd_no_write_intercept = true;
> 
>+

remove this newline.

>+	tdx->vt.pi_desc.nv = POSTED_INTR_VECTOR;
>+	__pi_set_sn(&tdx->vt.pi_desc);
>+
> 	tdx->state = VCPU_TD_STATE_UNINITIALIZED;
> 
> 	return 0;
>@@ -694,6 +698,7 @@ void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> {
> 	struct vcpu_tdx *tdx = to_tdx(vcpu);
> 
>+	vmx_vcpu_pi_load(vcpu, cpu);
> 	if (vcpu->cpu == cpu)
> 		return;
> 
>@@ -950,6 +955,9 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
> 
> 	trace_kvm_entry(vcpu, force_immediate_exit);
> 
>+	if (pi_test_on(&vt->pi_desc))
>+		apic->send_IPI_self(POSTED_INTR_VECTOR);
>+
> 	tdx_vcpu_enter_exit(vcpu);
> 
> 	if (vt->host_debugctlmsr & ~TDX_DEBUGCTL_PRESERVED)
>@@ -1607,6 +1615,16 @@ int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
> 	return tdx_sept_drop_private_spte(kvm, gfn, level, pfn_to_page(pfn));
> }
> 
>+void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
>+			   int trig_mode, int vector)
>+{
>+	struct kvm_vcpu *vcpu = apic->vcpu;
>+	struct vcpu_tdx *tdx = to_tdx(vcpu);
>+
>+	/* TDX supports only posted interrupt.  No lapic emulation. */
>+	__vmx_deliver_posted_interrupt(vcpu, &tdx->vt.pi_desc, vector);

trace_kvm_apicv_accept_irq() is missing compared to the VMX counterpart.

