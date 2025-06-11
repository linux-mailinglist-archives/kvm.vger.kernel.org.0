Return-Path: <kvm+bounces-49088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A6E13AD5B97
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 18:15:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7D31A188A70F
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 16:14:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CC8D1E835B;
	Wed, 11 Jun 2025 16:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ClRY1bGj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982131DED53;
	Wed, 11 Jun 2025 16:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749658438; cv=fail; b=WSmfoorx8x49r9J+YL2nNAsKmMyPp7dASdG929+g/sZg6P+/hs4974jaeeLX73e+nJQEVAQ3bgUo25FkZeJltC8XYdtLeDWMz25JsVXVVyjIVxrqo9CsfgpEvUk3LkC2U8c9Sbbmud18k8tunuT9NqAYmfNcS+SfplNT1oA9bvg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749658438; c=relaxed/simple;
	bh=SVpBqjKn+3vtZfPERXUK1TrCV5LfbFmo2+alzw1tHNA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QMo8iAOhyw+0YntwQk+YTwG10JnOUZlo4bB3Mtc36MndQv2pKLoik39WAXPasi86ihZFu2y2vKgyn+vKCI6UfaIFSRnLm9NtBOP8xrZ/t5jMtueGpojguLAZoX1iHDlQa6MBXo8Ne4/7HKyt3/bYYhOBoXw+KHkUubV/HxE5Wbo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ClRY1bGj; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749658437; x=1781194437;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=SVpBqjKn+3vtZfPERXUK1TrCV5LfbFmo2+alzw1tHNA=;
  b=ClRY1bGjmiCBTV2nZE5OZ4kSuVnUW1dVdFI7FYoGbtfRAcJLZArHq8YM
   AfmyroCja3VF4isAO5jp3m8fRuMaTWoNlIdEjXwYfGGd/lVPvFfkoTLc+
   kZg3p0yA0BoTdBKI7JvV/Y8Bk5tWdGHxniWcDqu0qL4n+hRmsdtIArlaV
   +jKVmtuGLgMzGL5UPM2EoRQ6Cpi5/SB0/Uk0oPR2x/DG3dqbpYjrk6/l2
   QCtljNdExS0E5ZbGlanHS8Fcqv0RSETlwMbZ6sSmYDiiABBBmSvTcfyqD
   oiC5MjMUU5F/GSxQYz+EBLKNY5Yj55f7A2/v3vy8DfefyqV0EizXKBYE0
   w==;
X-CSE-ConnectionGUID: khoydyE/S9C204bJXa8aQw==
X-CSE-MsgGUID: ngYieL3RSEq4Ld64Wuqp3g==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="51724416"
X-IronPort-AV: E=Sophos;i="6.16,228,1744095600"; 
   d="scan'208";a="51724416"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 09:13:56 -0700
X-CSE-ConnectionGUID: ShTkvaopT0qChdG6sE0Mog==
X-CSE-MsgGUID: IMQGTbGfTIukqef6yq37MA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,228,1744095600"; 
   d="scan'208";a="152132825"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 09:13:55 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 09:13:54 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 11 Jun 2025 09:13:54 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.59) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 09:13:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jN5NkY7/oExY+QRnenlgVZdl/3d/D2kPEKTyVdagbhevIvj0l/bhdpRv2r2KK/5eUVEPjoNvNsdTi/J9uODf7KjH5yPCqtjS8nRPGdT+dJVLT5YIMSE6KqR5Sur6HyREtuoN5KCLFX0bqqeI1HiggoGOg0xjD8hLrFN+6upJAOM6CrlQxwtBgFNumIxidQeRxipONV+NqRgJL6UMVTtvh9L3warnRdqVtovqHW+D6toykOKknoRKjOy648s1KirZYBNFKcVvFjcDdOuFKrHz04DOhXfiJcFEhj4xg0tjqZ+IUmSyh5Zv+LjR/3PAkXGs34rY3gKFuin8+cLxzpCZiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uHGkWbOqZvH5lFKUporUjZ6wG4QvYIvKV9N10eMEG3w=;
 b=Yq0bDbVYLm5M4Cvw004tyxxTLLJ1s6wEz9Wvv4S4Agv+BIvgol//F0eqRqNhtb/9RG634QPmoGSW0v2rQsb9yiMFcmu95AMjpMN5o0vqaXpl3bOV66c38EwFbs9m+Gz4xVX3AIFFQC0SsoWV5VlvA38xAV/jA8Acw/tT04NqXV9w4aumVGZMo56Lgk85BO/cwOZaG27Y/k+QoxPN0COIoM98gEaWtj43WyIeNguLx2Vt6nTkbCDI+HXG9FQRZahaPJN9Kh8d7nacCVRr4O8Euf8XtT0R7xEKvXTdSbOLcmWEPlXaS3rpSVmgB8JvtsDsxfAuAXJbUqTBU3UQ9wXsPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by DS0PR11MB7651.namprd11.prod.outlook.com (2603:10b6:8:149::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Wed, 11 Jun
 2025 16:13:33 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%3]) with mapi id 15.20.8835.018; Wed, 11 Jun 2025
 16:13:33 +0000
Date: Wed, 11 Jun 2025 17:13:25 +0100
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Mario Limonciello <superm1@kernel.org>, <bhelgaas@google.com>,
	<mario.limonciello@amd.com>, <rafael.j.wysocki@intel.com>,
	<huang.ying.caritas@gmail.com>, <stern@rowland.harvard.edu>,
	<linux-pci@vger.kernel.org>, <mike.ximing.chen@intel.com>,
	<ahsan.atta@intel.com>, <suman.kumar.chakraborty@intel.com>,
	<kvm@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] PCI: Explicitly put devices into D0 when initializing
 - Bug report
Message-ID: <aEmrJSqhApz/sRe8@gcabiddu-mobl.ger.corp.intel.com>
References: <aEl8J3kv6HAcAkUp@gcabiddu-mobl.ger.corp.intel.com>
 <56d0e247-8095-4793-a5a9-0b5cf2565b88@kernel.org>
 <20250611100002.1e14381a.alex.williamson@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250611100002.1e14381a.alex.williamson@redhat.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DUZPR01CA0246.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b5::12) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|DS0PR11MB7651:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f7d018d-d84b-4873-79b4-08dda902e9d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?iKz/imw/eW23jK4zGPIugiNsdSfV+qZ5hvO70CKeZQLuIkGeCIHnwBRSR/4N?=
 =?us-ascii?Q?OtMeFpEOfo2MDEmoeTbiRoXbedtd0ovzb9ckSRc8HAHfjpbH9rjv7e6bapUM?=
 =?us-ascii?Q?tT0OPmhPHmxkzfguEqEVRjO6OzTLibFDW1P7yHQ1qyFCGMZbi+fdhIizF5YW?=
 =?us-ascii?Q?83JXb3fCuzWa7+dJNYOh11M8idVes2PEItIvtEHGo5TH4ht268QSdPbfsPj8?=
 =?us-ascii?Q?2HVRg3TI27s1ZlhYeV6vKdyEvvkCSErHDu462yvWMijqxw8tAX38F910rQRE?=
 =?us-ascii?Q?sZozCm/bfdFkR0JHMoUx4xeO6vqnmlf2WaZ/cxFY2i2ZzqQFGaewPrfp9Dfg?=
 =?us-ascii?Q?kOHqG/fQyJjPGVVG9LGNCHFBNzc9akE6sxJ/Kf00oV4UHMgipmVg/YBbg33A?=
 =?us-ascii?Q?FCCj7N9MncGciy2NxB/y7w56PSNtj6ZDkOr9Jv9GhX/gZcx70nmQWxsP7hC6?=
 =?us-ascii?Q?Mdva+1s1LelYMkoHxflcV5TcjPn14WKzNUEPy7J1f2eA7+JaMc6fKCPycPV1?=
 =?us-ascii?Q?rSHF/vALupeNSy6yfz4K1S0FI0mIEjULDal11E61AaOjuqy7wuM4aaKJIAet?=
 =?us-ascii?Q?3+pQlcKX1qUhSehBb8pB9SlOhWjJqHo8o6RrxTcJcfByfVNOZ4WVZHzxCj3S?=
 =?us-ascii?Q?NKvTS/d858yHCZRXa//6015H5UeDYWF51DqMlgDB3RE/4ktcqdFh/Kpt5AZa?=
 =?us-ascii?Q?2svfy8qpZPXwEivjpeU0/QGUsD6odRSVkqWA5LNznxhj5VIjsoqxNVOcOyly?=
 =?us-ascii?Q?W07zzeV3G0fMPqL2f3XhGk7rVBKSdxMb/iks4gwYvMj3VE/PBpT1PtNaU9JC?=
 =?us-ascii?Q?1m2tC9/M6Djzxob3sUeaHxCHkLxqnwFsPzwC05uQ40C86iAcJipE5wLYtHE/?=
 =?us-ascii?Q?xsRd0/ar9m2i+2yeQ/fphYM7o6cEhUo9kKCFnbDE4ECfCr/RsqlD+m5MVWwZ?=
 =?us-ascii?Q?5KBvu1ue5mwxbnI5oMsrfagIGcqWtldvSv3YZ2vJSu25mziUt+Ls17x63J8z?=
 =?us-ascii?Q?0zcL7MnEdE98NC6hOocCuPgEyisxpcezV0vxOTj0Yhcw/vbTFrKuHJWXkyEg?=
 =?us-ascii?Q?do4eNFOMDqivu1KABn+4H/fAUFbXSuLjcXUhaYxO2AN1PB6SbBaZxuVvUovw?=
 =?us-ascii?Q?1W/3+OWG+dnLN6xylOfG0l1+9CjAN1Pr8doaGCHFv117q4gbB/uEpsmw8s12?=
 =?us-ascii?Q?XxM4MffqQpnS8Dpo2sELRcQ4s5ZuIxKI8NHi4iDBJMaxh0c61PuglrC9TzDy?=
 =?us-ascii?Q?xIAYrg2qGjnSX8EuaM0OTpyvKIUnUCHga5XRvHvpWTKLS5LgeEfwPWoBel+/?=
 =?us-ascii?Q?CMNiyPTgD/JAny2pn/zXk3ca5RoLpUWAVyoqNN8pJY3YI8kuUyl3K6/taAFk?=
 =?us-ascii?Q?TvyeLU1Oz4VI1i35AJr47RCIhDcTEl5LeiRbIMEJUNXtFp1YIcPz0j0poR8a?=
 =?us-ascii?Q?W4K7HzXsAzc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F6PvAI/wlZYqAhlux8WDx3fX6vzL+FVArAQXLjp8ErhmSgDl3WW+eiiZPwkk?=
 =?us-ascii?Q?vTMfuUIXZlOUZ3qZGvNFSOENGR4ic1+7ICJSHT5cIw8CXYEH1zP4ZISo67jG?=
 =?us-ascii?Q?/whEoi1OzYCi+kD4k6f/pSG8xUPTyJOFf1cS+ojCTLKrmMBgixyDChSICfCc?=
 =?us-ascii?Q?/YwHBgS1bf6XOworIRa0z+n5PrpPFB8rpTQQ5YINuJ31R6u4PgtUSW3x46Yi?=
 =?us-ascii?Q?L7ZYq66XBc0ZLh/ne3C6gbNwfi00E15vQSN5u5WcciEwIYkL88tPHoT23USH?=
 =?us-ascii?Q?2v5rk9S0UQ4Conu4+tD5LWd1bseiKNGCax1zOlA4V3IG1KuV2u9IXrMiGcY8?=
 =?us-ascii?Q?N2OYHoIavawZ12abat/CwtHBIFa02BQ1I9Bs8OAF27MbmOkebKnNVcQTViU4?=
 =?us-ascii?Q?+kIY7beorVQH4ysgdkBfiPIaX9r96p656fp5C+wIFzakOQbHBq2yPee9xIq9?=
 =?us-ascii?Q?f+HGdQIQi1ENpVUVbIyukdhiZ84k6wGxDjIXnKIZ+yEYbb/Y1tWJbsyAmek9?=
 =?us-ascii?Q?fKIsgXeKRio2tcWx0J4BaOH9EmyBj9WsFErmK5ah8b65Sxnn2ga0NMh6r35q?=
 =?us-ascii?Q?RTYHjJPLOs3+CpR09gltIpZMEzyjQ1KuzASbsmeYwGuhlGqkiMhxhgDyKLhG?=
 =?us-ascii?Q?uBNTz2Zr6YLPVfh5Ivb6zofe1RchuljWxsUxNGmEIR5/f/QeephhCcqLZGWB?=
 =?us-ascii?Q?jyMCtD58Lwef6Eo2P5NK1b8MYvmXLp2tC6RfACqwxlkliw7SazoE7ZZfvZJW?=
 =?us-ascii?Q?YQgTfdFbSqXRQvvfCYmFshVMngKz/GCA/QFW0yfRTFalDQ6Bk0BxsBbobzpj?=
 =?us-ascii?Q?ubofIlO+V3xViYfx2NEYV1aHNSgo3b8TAinqVQ+isUPrUkSrX2wAtZH0WItm?=
 =?us-ascii?Q?/ajASLzW0IkSvJyrVVjUhX1VD+qe+kjSLdbH7EmjTiGQJYpLn+q6+0oNOEpn?=
 =?us-ascii?Q?BgFmdBjcm773TFimrHK6K4AdltwRd6g6jFzEF5HVfluEkP959S9mK6xkl3wB?=
 =?us-ascii?Q?jNaFBrFsiYD5NCDDMLpYRvQdbaUTbmFGYEI5/7sEKEjADMgT1V/9I9Ljo1PH?=
 =?us-ascii?Q?nUlYSBq+aHNm7athMJyzUpb2uYx2SR2yqu/RyKNyidyPWiDlDVLStW/OVao9?=
 =?us-ascii?Q?inSO61d61BOtXOU9UeZqihwhv5Ssx0unTdnRbBm/sS+EwPWapOF0qOzCB7g2?=
 =?us-ascii?Q?GuOB8SxKJTieQqo7/gzq3IkNimsiSSwFV9ouV0rjFAPTohuZ3C6VKcrP1Jy5?=
 =?us-ascii?Q?GVnaxQd/CgQ0leMrjFU/P7aehNwe6QdXxSaBxVWfpkIsMCClZV8/Y8PGSpRs?=
 =?us-ascii?Q?DvkTd6mKmF0mQ8LH7MFVkM+DkkzTDE/heXmtqCIcM9dLGlpMcOicf4bd6sO6?=
 =?us-ascii?Q?z1YJtdAEdtIMGlpvmTPOfH4cq2bMaByqePQPg/wkrIzJcpltQc7tf30EzNKG?=
 =?us-ascii?Q?2cWdxQowlGfXRIRiXbul+arWGXxaZKz+OJiMiJy5axvLj/48vgD7TiLPY4LP?=
 =?us-ascii?Q?FOfhSCZaEwXxVPr3Sf8EkzpBATCFoTROtKBR9vOyD4DJ5EJ1/Gnco0A4GxhH?=
 =?us-ascii?Q?fkc0t7khix/kRdNNu0jEAXoO7sYXcC1IJ0y4Y9ux/tcWKQoJtzGA2hSk8t3d?=
 =?us-ascii?Q?VQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f7d018d-d84b-4873-79b4-08dda902e9d1
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2025 16:13:33.5907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EOXsY/gH9rgiDBcrH4K1w7y/N0CnVi7Qqk8kuimAmfCeleaQmv9tDH9KLmFF2xPdW9nKr8vdd+1EwFXTYU9GsPuWG+j/jQMvu2HSsEOqJBE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7651
X-OriginatorOrg: intel.com

On Wed, Jun 11, 2025 at 10:00:02AM -0600, Alex Williamson wrote:
> On Wed, 11 Jun 2025 06:50:59 -0700
> Mario Limonciello <superm1@kernel.org> wrote:
> 
> > On 6/11/2025 5:52 AM, Cabiddu, Giovanni wrote:
> > > Hi Mario, Bjorn and Alex,
> > > 
> > > On Wed, Apr 23, 2025 at 11:31:32PM -0500, Mario Limonciello wrote:  
> > >> From: Mario Limonciello <mario.limonciello@amd.com>
> > >>
> > >> AMD BIOS team has root caused an issue that NVME storage failed to come
> > >> back from suspend to a lack of a call to _REG when NVME device was probed.
> > >>
> > >> commit 112a7f9c8edbf ("PCI/ACPI: Call _REG when transitioning D-states")
> > >> added support for calling _REG when transitioning D-states, but this only
> > >> works if the device actually "transitions" D-states.
> > >>
> > >> commit 967577b062417 ("PCI/PM: Keep runtime PM enabled for unbound PCI
> > >> devices") added support for runtime PM on PCI devices, but never actually
> > >> 'explicitly' sets the device to D0.
> > >>
> > >> To make sure that devices are in D0 and that platform methods such as
> > >> _REG are called, explicitly set all devices into D0 during initialization.
> > >>
> > >> Fixes: 967577b062417 ("PCI/PM: Keep runtime PM enabled for unbound PCI devices")
> > >> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> > >> ---  
> > > Through a bisect, we identified that this patch, in v6.16-rc1,
> > > introduces a regression on vfio-pci across all Intel QuickAssist (QAT)
> > > devices. Specifically, the ioctl VFIO_GROUP_GET_DEVICE_FD call fails
> > > with -EACCES.
> > > 
> > > Upon further investigation, the -EACCES appears to originate from the
> > > rpm_resume() function, which is called by pm_runtime_resume_and_get()
> > > within vfio_pci_core_enable(). Here is the exact call trace:
> > > 
> > >      drivers/base/power/runtime.c: rpm_resume()
> > >      drivers/base/power/runtime.c: __pm_runtime_resume()
> > >      include/linux/pm_runtime.h: pm_runtime_resume_and_get()
> > >      drivers/vfio/pci/vfio_pci_core.c: vfio_pci_core_enable()
> > >      drivers/vfio/pci/vfio_pci.c: vfio_pci_open_device()
> > >      drivers/vfio/vfio_main.c: device->ops->open_device()
> > >      drivers/vfio/vfio_main.c: vfio_df_device_first_open()
> > >      drivers/vfio/vfio_main.c: vfio_df_open()
> > >      drivers/vfio/group.c: vfio_df_group_open()
> > >      drivers/vfio/group.c: vfio_device_open_file()
> > >      drivers/vfio/group.c: vfio_group_ioctl_get_device_fd()
> > >      drivers/vfio/group.c: vfio_group_fops_unl_ioctl(..., VFIO_GROUP_GET_DEVICE_FD, ...)
> > > 
> > > Is this a known issue that affects other devices? Is there any ongoing
> > > discussion or fix in progress?
> > > 
> > > Thanks,
> > >   
> > 
> > This is the first I've heard about an issue with that patch.
> > 
> > Does setting the VFIO parameter disable_idle_d3 help?
> > 
> > If so; this feels like an imbalance of runtime PM calls in the VFIO 
> > stack that this patch exposed.
> > 
> > Alex, any ideas?
> 
> Does the device in question have a PM capability?  I note that
> 4d4c10f763d7 makes the sequence:
> 
>        pm_runtime_forbid(&dev->dev);
>        pm_runtime_set_active(&dev->dev);
>        pm_runtime_enable(&dev->dev);
> 
> Dependent on the presence of a PM capability.  The PM capability is
> optional on SR-IOV VFs.  This feels like a bug in the original patch,
> we should be able to use pm_runtime ops on a device without
> specifically checking if the device supports PCI PM.
> 
> vfio-pci also has a somewhat unique sequence versus other drivers, we
> don't call pci_enable_device() until the user opens the device, but we
> want to put the device into low power before that occurs.  Historically
> PCI-core left device in an unknown power state between driver uses, so
> we've needed to manually move the device to D0 before calling
> pm_runtime_allow() and pm_runtime_put() (see
> vfio_pci_core_register_device()).  Possibly this is redundant now but
> we're using pci_set_power_state() which shouldn't interact with
> pm_runtime, so my initial guess is that we might be unbalanced because
> this is a VF w/o a PM capability and we've missed the expected
> pm_runtime initialization sequence.  Thanks,

Yes, for Intel QAT, the issue occurs with a VF without the PM capability.

Thanks,

-- 
Giovanni

