Return-Path: <kvm+bounces-64078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 121EBC77C86
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 09:01:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9A83D362DB7
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 08:00:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CE31335BB2;
	Fri, 21 Nov 2025 07:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LM1QOtWa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80BE260578;
	Fri, 21 Nov 2025 07:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763711982; cv=fail; b=bmsTed7F8nEzamrxN/rlEdPtfMk0VEYf46DWe8rH5Q1SK95F+cCr7RoYfLF0o6wv4/I30MjSar3enQbSJor02zngTCA3MBmt8Y0FZxgax32CRJWc2qAtV6TuSNiF569vXPt3yjEk5liDrMV2jF47mlZoEjzKtQCVe8erCLOveGc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763711982; c=relaxed/simple;
	bh=h+KcXIu9rEFdF4UBArUNoijf9e8APwAaJ0fLm9ARR1k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=u9sqT87oTaEAzn7yqY+G+0reuqBofuCWeFpiR4kXq0OTgjCS6s8afh1aw1j5HPc9pecn6rK2yJMH5nWDES56BBLwrg17V4THU762UoDXPg3DvPfxmswywTIY88ohT9lUqHyF3SSwChZ2E4ncJzHKMD5P2LZFo5+HJffvQwjnu1M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LM1QOtWa; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763711981; x=1795247981;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=h+KcXIu9rEFdF4UBArUNoijf9e8APwAaJ0fLm9ARR1k=;
  b=LM1QOtWaku3pXNS5/U/ZFvquAYMBg/69tpGbXnADb6LIazdJNLOp3Mns
   +xrjafnmuNPCKUaKuNf64NmWWypnZM6w4kWkYvNpJ3n455DCxfzDA18Zq
   GbDh5tYDONjpRrEwPnhBc28pg2acrJhbkfE7Ijxcn54vDkvB4hEnYBwD8
   j4NB9ZJd2tbMQYJ6M5fVw/8QcXWc204K3fY9olhimeKB3pMHFJkwVZgrS
   oNi/CJoCfsqNTHPmg7rYiM6NZ845gp3zttnmnp7/cNXRLpU7DlDVuKUmO
   TXcPhibppoBa+onCkkNlJ9hC+75X3g2n8McXonbiDbCjWSb1fKpsjpc3o
   g==;
X-CSE-ConnectionGUID: +6jT/vN8TwKqjvK9w5DIbg==
X-CSE-MsgGUID: TV8ONpaBRUSDgdnZbhshXQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11619"; a="53373012"
X-IronPort-AV: E=Sophos;i="6.20,215,1758610800"; 
   d="scan'208";a="53373012"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 23:59:40 -0800
X-CSE-ConnectionGUID: ycA15y9eRsqTzP6tfbieAQ==
X-CSE-MsgGUID: 0x9ZzMVfRgatxx4KNkf4ZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,215,1758610800"; 
   d="scan'208";a="192081347"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 23:59:40 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 23:59:39 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 20 Nov 2025 23:59:39 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.13) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 23:59:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OWmHNmjyDuW4Z1dPmpP2KV4l9OAJztHzdb5i5+hhjCaelTLv9CK0TT0junnNO9++SyDwtK/dB6Pjnz0/VwKFV9vvX+Ngu4BUFlvzdQalKTerepYeMuycJFpc+O0Q05yFLpIN6EVys7oWc9SpO8+YR7ClLUzik20cRjY02NEDyX9j823WCATkfzVHn7mWhmCbpc/UZNB2MFKtXbEFo/wT4W48NsFqX/h0yShCu7hul5FYAQ1i62RgHLOJe1/xx7AnI+OQF9F5hfc28yzzJxKuCUK3UFJxQegvLzZW3TlbFKwnX4QL/r/Y7O8D9Sz4JTa/l2ka5zRDN2Vo6iRutT1j9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/NFOyOBJmnhmx9Pf4OtTtJIyUUvqfCFlnRx/UlNfSZg=;
 b=fdatzkKkwPZ7K5L3gdY8ruARJFAqQff8tSsqW9CqCtMKy9gQ2SF0G3LVf7RGIiJDGxmoOtinid9JYGutk4nkLopiJWHzHZWWpG7473qWSlWb6CBnQ0ffTQ8aCax7GPrvrzeQ9k8KTKkmzn0U8L1PSpJ4SlevXrSeh43seH5VObrcLF494eOcEyjd62fG6qv5xWyCxiiRU92eTN7nkJkaLIGVXFZAEuy4Mff2yy+Q3J+xFdTYSpxaaO//3a0dOV/xCINL0I/4v22uRvXBT2YipjZTu2O0gbfKiawfw8yM1kRiy5OiQYc+mRfs7c3BJH1ypxBhel0Ar45khCK4nPULVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW4PR11MB7031.namprd11.prod.outlook.com (2603:10b6:303:22c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Fri, 21 Nov
 2025 07:59:36 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.9343.011; Fri, 21 Nov 2025
 07:59:36 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Nicolin Chen <nicolinc@nvidia.com>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"afael@kernel.org" <afael@kernel.org>, "bhelgaas@google.com"
	<bhelgaas@google.com>, "alex@shazbot.org" <alex@shazbot.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>
CC: "will@kernel.org" <will@kernel.org>, "lenb@kernel.org" <lenb@kernel.org>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, "Jaroszynski, Piotr"
	<pjaroszynski@nvidia.com>, "Sethi, Vikram" <vsethi@nvidia.com>,
	"helgaas@kernel.org" <helgaas@kernel.org>, "etzhao1900@gmail.com"
	<etzhao1900@gmail.com>
Subject: RE: [PATCH v6 5/5] PCI: Suspend iommu function prior to resetting a
 device
Thread-Topic: [PATCH v6 5/5] PCI: Suspend iommu function prior to resetting a
 device
Thread-Index: AQHcWO7jc0OFm26Gq02eZzZpNDi/+rT8x5+w
Date: Fri, 21 Nov 2025 07:59:36 +0000
Message-ID: <BN9PR11MB527606B1150A36D5E3F6E03D8CD5A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1763512374.git.nicolinc@nvidia.com>
 <9f6caaedc278fe057aacb813d94f44a93d8cab3c.1763512374.git.nicolinc@nvidia.com>
In-Reply-To: <9f6caaedc278fe057aacb813d94f44a93d8cab3c.1763512374.git.nicolinc@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW4PR11MB7031:EE_
x-ms-office365-filtering-correlation-id: da9486ad-fbfe-4a32-c67c-08de28d3ea37
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?nK14XPdpbAJXGX1CHcxl+bpsfLjZZ1LmB5sEKtWMhAVNFv6oU03/+yTviWRM?=
 =?us-ascii?Q?Bi+CI1A0djuCBBopolDIGBtsMoedqxwdjjM+j1jeEZ5cqdub3QsepQYIgBWw?=
 =?us-ascii?Q?0PUd9nfHboaMgiOAWfkFSl803bBhTcFB//92hLpQOgqMy1Rp+OK5Vm61nzbr?=
 =?us-ascii?Q?xI44292GUXzKG3y62rf2hU6+0qrRKNETa5y+x4JIwmg/PdxnP9h/7pS1/c1x?=
 =?us-ascii?Q?yjnfuxzkPNPPy7J4zNDFrrlr9868mYU4aOgs3kR2xyMqNAcimZcmimvEUGZ3?=
 =?us-ascii?Q?d08EGXDa/tASbUPOTqw2GI5MdEnnK/P16H/lSRq1Z3SmPD0d9sZuDAQqXnr4?=
 =?us-ascii?Q?0VHGCiNETD1w3Rueefw22WE2R/BgMTH15ZUPnXgeaDFkDmt4jCtzW/AwcgY2?=
 =?us-ascii?Q?TryKPUQwpMNq3qVB87jB/5oIcjpRDY5qtLjnuZVhjZY6yCdln8ngxv5lTm5A?=
 =?us-ascii?Q?/iddyV6PSUnL/v5a5V9tHXwfg+niokGoGt525JIVcMn39qmGS+orixOKw3Va?=
 =?us-ascii?Q?ZbRUDNxItgIW/DF2vdXXKqAiSWnkaAd9np+0zyd8OnrJmaJgvG9BdJi388kc?=
 =?us-ascii?Q?42lVJMVtqh7FEzGO3nxGZT2Xo9ryxpZmTOb749soxb0GdEELUhlzpBdGPEve?=
 =?us-ascii?Q?0O2B26dzwwzHpJaFgLEyuEJTb1Jbnt55vt3C9kf/vDRw2gFiubd7nLnOftFt?=
 =?us-ascii?Q?dd6DBw1bdPjYm2EGAnVNvqAnR0yWhfZCMKvNiQV8DB9F/4VHx6lsTkFA5O2A?=
 =?us-ascii?Q?lvZBR/v4uYM5wsA1OAiYiacGgS/uk/WT1zXWqqzF6vIPwLfbZ2Z7sfTqo/R9?=
 =?us-ascii?Q?Y3I/bIKvSmEBCyblJ2Qi5A+wmyhDGoCPo4kcvKr+/5PLXsHToJCRcoS9+HOP?=
 =?us-ascii?Q?Fmx6ttAFbgR0ofSVEVsH/b73OT5w98U0Gv0Fm04Njb8OAkQNkzAh6phTLB6K?=
 =?us-ascii?Q?rPN7vB16AX2WFIWF6xo9r6nQQJJUjZEEDr70L40YI7RMe3f5RwA2fLHQslI4?=
 =?us-ascii?Q?Sbgiv6JVTYG0Q/gEnwdtkXcvgH1yX9QmpC8Ku/L2+FDU4lGLToodT1RZuNa3?=
 =?us-ascii?Q?EriZOAFdKeMUmHlOL2t0mzy9v9ruoaLI1ycWQHmG2ixc9b7JlAvRnOlxxg0m?=
 =?us-ascii?Q?MKXQJBa6EmNf70gS2q+Hq3bvF+AxIPdMtwS5sb6iy/UKPVW4TY6gZbRqyjG3?=
 =?us-ascii?Q?b+VFqRpQc1t04sk1HzZa7q4aV6yxjftXvrDuti8aTibRJ1WfD3ekD60wYCi7?=
 =?us-ascii?Q?dzVtE2jRW37BVPKn+L5SnAErsNmLRvk4fjAVdQ7dAaK6CRZeYP7yWUECISkL?=
 =?us-ascii?Q?10vJyklvdOkvGoAUCgPQDIkWUGT3DxgcStJtPVuCGBg9Vtq1igSItmCEWCRO?=
 =?us-ascii?Q?2yTtbMi3X5XphPHux91T4xsAKsNYKZ7Fxnd3+DwqiOoP4NAXkwCP5R5vcKUd?=
 =?us-ascii?Q?RkbGLY6w+99snpRsZ3b2x2InA9nDGK0n4WB8qlvVI72EtAlxAkfRBLoMHjjx?=
 =?us-ascii?Q?YEwYPejvx+4MyQXmjFdeRk5iR3RBhgBfPCWS?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nCSk+JBqhj/lZiSOddddpqO0BrRlDbTegGkJT3rLRlOvGJlLhVlmSuO3sVQ2?=
 =?us-ascii?Q?NxWChQQfvE2JKYok87x77Af7Qdu7nhyX0/6KNIbQ095PtlmQaOtg+P6Skh0i?=
 =?us-ascii?Q?qTRFIyvuFric/v7EkTZRa33l/DhNgLeEPZmbSDQzckD1eTr+BUNAHP9WC708?=
 =?us-ascii?Q?D9AMYJTW93EA5G6tUy8z/eANaKOxQNJ/RanY6XhC9mGCac9G4fGNpJM0nFSU?=
 =?us-ascii?Q?qQj+K3VoPnp77VT5J17QJrWzueI1qgbA5gZ2kIRlD3ftnk6ZvpK/THl+U7dg?=
 =?us-ascii?Q?1KgLS+A3ezu8hDBcT4tQa+pAWhFGEgIXYdrwBnfK05TXC3nn+/HbGTtEJlE8?=
 =?us-ascii?Q?Y7Uj3rUv7+uH4tkN+cNJ5rrjKnhJvgf9yCppic7iXbmn3Jz0EuuYnNiUIogQ?=
 =?us-ascii?Q?f4m94FdH1oNjm3QLJiWleQQ5AfECioRHjlGIx0A6U/SYttV+9wRK2+vv8sKM?=
 =?us-ascii?Q?8SlwIS7/U9gx0fx65ktqRRLZUQZBiela5TR4rwiAWPz7BK7L20KAFwqXKuCx?=
 =?us-ascii?Q?I0r1/3O9rfFhfA7ehagKibEMii800TfbIBb1pS++Ie2IP4LZgOe8Aocw/LAI?=
 =?us-ascii?Q?6Id2r6YqgNr8/NK4nJEeZlgSJG+XEzQY8/4Gj/pcdSW5udFtgXj557xdNjI0?=
 =?us-ascii?Q?iSw4rv3cFPVdhxloU+aMPt6tujgyylgahuhW4iaoDZCGLdYqEmD1IugeIopi?=
 =?us-ascii?Q?eBg6kWU9w3Ccp24fhVqaX8N+TBTAOphzyiT8WLwjVh7DCuJH21wLRx30XQRB?=
 =?us-ascii?Q?xQgkJinP5hzyn9ExrsBzUg08fzkNCo1sghBj1qHAL/cc8WfktJUpcLbc6gnd?=
 =?us-ascii?Q?fr/GhHo2anAzxrD8tNZV+ic5MwXYr7vXkJzNxM83KMDvTFPXRtnfLyE6rGHy?=
 =?us-ascii?Q?X1YgzSxMj+PPDOPqs+N6e1gbwnq/Rh/g9El+itHqdrJp6TCpE8mmvRJYQN+G?=
 =?us-ascii?Q?uYF9pR3TzdWp5sVUJUihJozouRbn+iy1V/7ESmdWvwyx5mEdI7EfXfpVuYtB?=
 =?us-ascii?Q?lI1NvNOG1zc9hB+wv9Bik64pRFtluajXCl/cpaOWJ+XcMkcaajgFDGC4syth?=
 =?us-ascii?Q?zH9n4nSaqnqlsFNmcD821P1NyVonjhfJRqHFGcu+St+dANCVL+JGlK+tNro4?=
 =?us-ascii?Q?OvC22ZL4276/CpUQLs11501aY5H5/lfGvpTnLDN5X/VWL/cPX+217nNdNdxU?=
 =?us-ascii?Q?/mEW6NeJof87V1eVIOdTMHWzNE9kpE4ExM4zKWObdmOpyI8/k308Y373Z6pJ?=
 =?us-ascii?Q?f02wC8fxFp0JUabcEqCPmL9WEiKiXzRLRCs2WZhduOvgbXBjAKAXt60xOPA8?=
 =?us-ascii?Q?57B+b1rkyG4kH9QEOuwl5jwnnvychPfppfikjtA3kULnPFwd+cYqcEuf1Knw?=
 =?us-ascii?Q?MbJp5WPHIX0EeCac6pJNt5TAu86ySrA2GsiVDAoMxtSYShuVWzCvLTl8LpZ0?=
 =?us-ascii?Q?A6dlcg5ci+FBHsqPOIeB3lWfc7+V/ZTs5dKWtJivxxaN03VzODrv0oxMGRHv?=
 =?us-ascii?Q?qXpu07uX1YBlM5/0whjkI4fk005WJ7NGSQF1q0WmQoFIIWL6pNSxnQzlt4KL?=
 =?us-ascii?Q?hBjmBPWqQ7qXRRhfFwNtjevhDvjT5YfQCeLSKITL?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da9486ad-fbfe-4a32-c67c-08de28d3ea37
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2025 07:59:36.5792
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vBPd+Q523u6IbDu/J2UnIGXcYvIBD1mjgeOtPEg658WaWXsNa0zehjAMuAbbRsOZmoUGZZfH4KgHpWc4DUebVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7031
X-OriginatorOrg: intel.com

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Wednesday, November 19, 2025 8:52 AM
>=20
> PCIe permits a device to ignore ATS invalidation TLPs while processing a
> reset. This creates a problem visible to the OS where an ATS invalidation
> command will time out: e.g. an SVA domain will have no coordination with =
a
> reset event and can racily issue ATS invalidations to a resetting device.
>=20
> The PCIe r6.0, sec 10.3.1 IMPLEMENTATION NOTE recommends SW to
> disable and
> block ATS before initiating a Function Level Reset. It also mentions that
> other reset methods could have the same vulnerability as well.
>=20
> The IOMMU subsystem provides pci_dev_reset_iommu_prepare/done()
> callback
> helpers for this matter. Use them in all the existing reset functions.
>=20
> This will attach the device to its iommu_group->blocking_domain during th=
e
> device reset, so as to allow IOMMU driver to:
>  - invoke pci_disable_ats() and pci_enable_ats(), if necessary
>  - wait for all ATS invalidations to complete
>  - stop issuing new ATS invalidations
>  - fence any incoming ATS queries
>=20
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

