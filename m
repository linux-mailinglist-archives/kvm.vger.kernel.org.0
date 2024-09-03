Return-Path: <kvm+bounces-25788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C78F196A85F
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 22:34:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 46D241F24F73
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 20:34:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF9C41D223F;
	Tue,  3 Sep 2024 20:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QWX3VnZR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2071DC745;
	Tue,  3 Sep 2024 20:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725395680; cv=fail; b=GeMdMRtfsocpp591k1KSyBYSJQyrPoKGqbUOTCox6CgdGXNSmY1cV6xi1Cg8L4muHbQCV9xx6u/TMdpME3LRMDNPMdQv3mxvA1jzs1smytc9SRmNJfCz0ifrRdIjVipyekE/qaY5aXXsrFz0EvmfOmoWNMMxax/1dw8/69bHRNA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725395680; c=relaxed/simple;
	bh=yD7syxo8GOryelrP58TgjKTbhhdNt/8bTQFuid+dkak=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RpAiuUBvqVBVN50i183byrmQJn0pbVzeH1cOg8nTAbU9+/XXHYRud88huCoPTAt3MBH6knIjbj8d8OfLExk2+k3H/dwFuzhD6uQaAPTU855lRdMASFyI1rWm1xjnZXF8XTXkQUGbQE2XHGKY8NJwr42M502zu/A+ePTkIltiQtI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QWX3VnZR; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725395679; x=1756931679;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=yD7syxo8GOryelrP58TgjKTbhhdNt/8bTQFuid+dkak=;
  b=QWX3VnZRL8C0AGzSSLcn8omYxS4HW4/hcjzdq1F0fVYOSlwOHSRbsmir
   OW39Upie+BzaxJx+YWS5n8bkfT7UwE+4gyyTUGgI3wyXEHrtT4Po/9yEI
   mdC2da2mp52W3uROIIqwF1ct/y6YNBkCEJIK8c0X7hRX7gcGq6UUMDUm6
   8ER8RMOxybWPN4kypJgnE1HGsXkZm4UHtsWCKyyulC8O7Pn57z6XV8cFL
   LMap5Albq1Sz4zRJ1XwIBuFPCYj8uqGQX9Wg83mNkCFkbaaFfcjT7IX/7
   CPVL/JjElOtnaSB2HjtLVm/YvwnsnWXZgeEYvTcWXOv6inCCRsUUntCcP
   w==;
X-CSE-ConnectionGUID: 5qqaAAMvSJKHtb4L/BmxPg==
X-CSE-MsgGUID: SLR+jpCtT2+dVksOcYlXeg==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="34626160"
X-IronPort-AV: E=Sophos;i="6.10,199,1719903600"; 
   d="scan'208";a="34626160"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 13:34:38 -0700
X-CSE-ConnectionGUID: H1FqkD/qTt+tdHiYtawHlQ==
X-CSE-MsgGUID: mMKj5vAhTiSftjXndc8AMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,199,1719903600"; 
   d="scan'208";a="64850930"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Sep 2024 13:34:37 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 3 Sep 2024 13:34:36 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 3 Sep 2024 13:34:36 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 3 Sep 2024 13:34:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PB+qzCXzrCwHBYLAhz2RqP+m6x9WBe31a1187F6jpWNfNCV7WCVjaxkO9LUqNvAZoDHOfVLU1GIpdfYdLZwIPuff0wjjXvYeh6M8DIUf86i5xyoiIFOsxhUjlzITuV0IX00UeqtrioI4CZgYunkzuQhifYHP18tBLjqCKOuYwO6tiqTIKB4qRcnMVghtnJsU+X/aP+Amg2Tbrryc4qNX9G9APctqWQSmt+v5k/Va3+jeKw/GSlw/SSLK8FWpGkYDU4GoloNWl8ycCYvlvSjdnTfWjNZbA3SCE3vsVnYzLAvltNvtT7v6FUwDSm71JnI0epWj5vwi8lOW1BZZHreLmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bUuJcTZIWpUMMfkxhf9Th1K38ZjUCyvGpv/mCoBoNQI=;
 b=f1k9Uy7SZpeR59Ngumm40MkIgAePhp8i6SSKMZ2t2XgMTawsUFBNKMhos802edsn/sxhqdaI2BM6FIwrzv31o7DdTcuTIIZyos/Bzru6aEWmAiSvYmt969so5s4NNU7PHqwnCeYSy1NU0as/G1O5RlxM6TwAS8IyDSAyfxueybpDlx5Big444vqZUH4Za3NLP6djLcPV3BP6uHrXjKzX+1sypXR9IAawR7a2H0X/XdKRJCpWPXJgFCpiZPfwZmBAiGfycZIiXSpzxO3IlRES0YceIViomMJ4NMIXffjnzzMbmZrI4XLqaAquQuBXT6vMWSh8HjD95J6ixwiGjRlXMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH7PR11MB6907.namprd11.prod.outlook.com (2603:10b6:510:203::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23; Tue, 3 Sep
 2024 20:34:33 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%6]) with mapi id 15.20.7918.024; Tue, 3 Sep 2024
 20:34:33 +0000
Date: Tue, 3 Sep 2024 13:34:29 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Xu Yilun <yilun.xu@linux.intel.com>
CC: "Tian, Kevin" <kevin.tian@intel.com>, Alexey Kardashevskiy <aik@amd.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"pratikrajesh.sampat@amd.com" <pratikrajesh.sampat@amd.com>,
	"michael.day@amd.com" <michael.day@amd.com>, "david.kaplan@amd.com"
	<david.kaplan@amd.com>, "dhaval.giani@amd.com" <dhaval.giani@amd.com>,
	Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>, "david@redhat.com"
	<david@redhat.com>
Subject: Re: [RFC PATCH 12/21] KVM: IOMMUFD: MEMFD: Map private pages
Message-ID: <66d772d568321_397529458@dwillia2-xfh.jf.intel.com.notmuch>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-13-aik@amd.com>
 <BN9PR11MB5276D14D4E3F9CB26FBDE36C8C8B2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240826123024.GF3773488@nvidia.com>
 <ZtBAvKyWWiF5mYqc@yilunxu-OptiPlex-7050>
 <20240829121549.GF3773488@nvidia.com>
 <ZtFWjHPv79u8eQFG@yilunxu-OptiPlex-7050>
 <20240830123658.GO3773488@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240830123658.GO3773488@nvidia.com>
X-ClientProxiedBy: MW4PR03CA0353.namprd03.prod.outlook.com
 (2603:10b6:303:dc::28) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH7PR11MB6907:EE_
X-MS-Office365-Filtering-Correlation-Id: 80947a5c-8930-4ec6-b07f-08dccc57d191
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?3fW2YGGKi39j9JLtZz0aPXQvStdqOMSJi43OqKbvnQe9YkevqSAi30+Prw+V?=
 =?us-ascii?Q?BfrxT98EEiXBWv4TBf4IHHjstxN+62Svx7XscUws1j99qJVNZa/i4jfc3qnc?=
 =?us-ascii?Q?8qd/mc8dPdpl2I5RRNsz+VTxqOfvRn4vkRVEwjaDHQ3SfS8+nK2/fIjFoA1M?=
 =?us-ascii?Q?XgdeG0bmdp2O2VMPeXcp9qLSb6UGpAvAGKby/RJFFQFm2FkC++Zpz8KTWTcM?=
 =?us-ascii?Q?da1jKxwxOfZBiW1ptw/66YtmpI3AoDbDwY0X9bLGjqyyXViBfgzTIj4Uz43s?=
 =?us-ascii?Q?zoJlxIdoD1tGT13cvqAcmBBXQl4iyogNPEym1lgdCgseHtVZU7blhPFSO5hn?=
 =?us-ascii?Q?8QAjMrjVhTfaOng+VXpqG2iXUM2majm3qDIbvsnxmiQUsV3Tr0hW+1QCHNWZ?=
 =?us-ascii?Q?1kRD9SzBQHbX+FtuN4RmUudZxCPICBa7XuxnTK+1hC1/opcJRaiGLpXPqmQE?=
 =?us-ascii?Q?vZE4cNIvWIpaJJgYO/3e7YRXxVHrwsrGbpNqmXOjT+RahsYEiwB9SC9zG6LP?=
 =?us-ascii?Q?4YXLYo/FhTWtKDYn8riUshZIUI3xtmA+zy6phHwuMJ6ldg0/HF5+5h8VCVac?=
 =?us-ascii?Q?U3MqUheoXk/icxxSEAOF2fzIrS8XcxUFC69yz9RSfEd7aKDZahIA3BTrkQFg?=
 =?us-ascii?Q?j/sQoJRNOFi52wTTkfZsTktolghWuFnT30NFu4kK6bEDAFs8/G3hwEuPaOrv?=
 =?us-ascii?Q?LOYBU4prwU9rxdTH3W1dpqKVF8MJOMmkWlZHl4NPEg8W7Q6Ul5iPcRU+Vi9H?=
 =?us-ascii?Q?8C9BCKbKs/9v1UvCiYLMfW0ZDobAxuQ9ix+52vO2fdxMxn9c2DCRLv7iilVm?=
 =?us-ascii?Q?ZNxjlM7D0eOPz/O6HijxVrcfHF91+IYCs0bzbsg7wvaUJ/AO6ZHYduez7uWw?=
 =?us-ascii?Q?NxR6wZGOp2GYfLxz2CrHuNhCo5EHLUT2Yo5FODw+tFRRgm6VO3pDmoNXu1AZ?=
 =?us-ascii?Q?Bp8PS6yUoe4H1HlQlyC8NDH8WWODRFhu4cp8pzdu8NId5NU/KqtvmzJMDY+m?=
 =?us-ascii?Q?o4aY5hZ7jmuaY/WNhoIGSsxsfHjUrV+UHfdQBbeKoJRNE4Odu/JlmCON9PyJ?=
 =?us-ascii?Q?WX3/5mCpCShzKc0xOLTLedTW4BwQgTuDrNt0d55amSFyP0yB97C07paZgx4t?=
 =?us-ascii?Q?YSD/My5xHZCTxKq6be8w0U6gzHpOQs+V4qgPf3wJWz4fjNWM2UHIZe8Zj1id?=
 =?us-ascii?Q?Nqvh0BXzksajxCI4lHIzjGZSbBsG3/0Nru+5EBnBFJ8Ln86SXUYmzIaUDPgn?=
 =?us-ascii?Q?46o1crEhlOWrxYfV0UGsfBUGI6pZRg5W0wyi+uIOP4wx2FIND7Z1JsGoTSKj?=
 =?us-ascii?Q?nT6xJ6xxEZ5ZAa7iCRk4aWx9mxUiwaJ5ngeIVwzZQt7fLA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xrgLKgHe+zEeNURhz9+C83vYQX5LNXj1L9e5EdKgJ6nsCWY39o8MM4TfiUku?=
 =?us-ascii?Q?kg/iRUROuPldnsxJXTS1IP0flhV2qbS582qJOrCZjf/Lc01h8+6g4360Dcju?=
 =?us-ascii?Q?bkZDgB1voBvy0Tua10fu7jdAjtwkiCuQlzIl1nCCV3Jm/qmUu/n4yRdwHj15?=
 =?us-ascii?Q?3QtbgHrXqti9qNEmuMvWD+p+i5ykQhjskjgNSWViJMlgs7VtpSf1MDRcN5Ef?=
 =?us-ascii?Q?1LTaJAdTtNPp8lKDgffHB6huQIFJ4mbkIlBCIAY2VifQohRt3Ms6P9KFf6hh?=
 =?us-ascii?Q?py5nGv/S9EintbRgnEyShcy5MCrXJMnsy3vJRNG1KV2x9LpHlLRnkhuQebDi?=
 =?us-ascii?Q?tHjRcyu7dfgmFvJPnR2TeS37c1CjksUhmrKXlAEF/Y2njMTc5mayBEKF4+j/?=
 =?us-ascii?Q?FA6wNED20W+RB9knELHSwC9Ur65/23+l7VK4JvVknQytY5KZktzdV+IDLgds?=
 =?us-ascii?Q?/5zh8xusgF9wjxlZ4UMLk9o8IC9orQlysuXqxuGopVpTyD6mFPOUTszFHaJy?=
 =?us-ascii?Q?3zdJtUULTCy4wqf3rEXHtCbULpBLhzLFioLk5xSrxIcz6OYiLsyfuInQZiBs?=
 =?us-ascii?Q?dd2F2ORvzj7OBUaNt3rsbCHc5WDbwtWkV3s3iYiZTmugwoAiMkSxswrGmSDB?=
 =?us-ascii?Q?ViGOyf7rarJSUf1pGDJ+CKv48ibBs3dSIRj0nW4n6GPm1v4FAxjTJy0Et2OP?=
 =?us-ascii?Q?KagQRbWf50I5n4G40ZqHaBaBHr9OKvVG3qD/fxzVKfNn6sU38FD2+20RY32B?=
 =?us-ascii?Q?BRluYhm52nuocJtJRfPWlX2/mN27lIYt8toU2DytRM7S/3ppBzNHqUFhNxwJ?=
 =?us-ascii?Q?tVP0ZIOUF52hyTkPZxYfq71JEDSpQRmywi5CGroVvTT1y95fcfw/Hf9eo/JU?=
 =?us-ascii?Q?eR17tT8kunTve997PaKLSXBtrk447IQCw9a0da/SSQZFJSVuFk+ASl1yS/Uf?=
 =?us-ascii?Q?wj7YR3ztT83+YJrUFRU14DO//HEXDCiM43Cs4BY0b1VuCts+N/d0gQokxWLM?=
 =?us-ascii?Q?0E6d0tIzZgYvLKMXsbscYLQdQhnC6iibwkeT7A30gq7xrf5LLVRNI7Mt2uLn?=
 =?us-ascii?Q?NtQbDS7DxGadqtbudeN8mKJdEoYrQl0eDSKHxWtYFK87TCy7Un+B8VHb9aZ8?=
 =?us-ascii?Q?Adfz3ppaVKozLgrT66XLuCK3MT2V4JVboAgSPrshqWpkh1YE6BFerymhSVJU?=
 =?us-ascii?Q?16+y/JtDCxZvi1Eqb5DbOKca94WAENmi55Yif20SrOdPRZ+X6mYmT7x8TQn1?=
 =?us-ascii?Q?oFXSXQKJ3UEzEkrLw3gGjfmbnWD3RzMJVX9V08O+7UewJvDY445b+NjYWbHQ?=
 =?us-ascii?Q?x+T4N/xU2xwXKwxjVFRgnyn8akSnEMXcyLiv+q7ahX5rDeiAnMxXFwhJJCsM?=
 =?us-ascii?Q?n6zRAWXMIrFCPNX/AObjk2Bg+ooVVL1mcnxh7EpJHfbbi6EC7V5IM2Hs+Une?=
 =?us-ascii?Q?fGKuIOQqOPUHAm0H7EO4/MPqLveVjkholYMOSxOSaozNxyWMt0WfsQX8u0eZ?=
 =?us-ascii?Q?nP8WYxAwUo0I7qYKGGFrbspFqO7L7t4z1N0on7oIkfXjExErqnEynovYKeHW?=
 =?us-ascii?Q?1MTxZ9bAoiRdBcIcbnSgEdvvL5Hu+/HmU42gScibaWn83D3ZJcchI9PP5jle?=
 =?us-ascii?Q?5Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 80947a5c-8930-4ec6-b07f-08dccc57d191
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 20:34:33.1853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 77g4q0V/9Orm1i3O2lKxR3nLtgyhQ3/tJomEFSvdgd7uPQbpwKyjSliU+L8FfZFS4XKOQaynfjB21ri0BkrM9su4q3Xwc7fJGguuVj1Z+48=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6907
X-OriginatorOrg: intel.com

Jason Gunthorpe wrote:
> On Fri, Aug 30, 2024 at 01:20:12PM +0800, Xu Yilun wrote:
> 
> > > If that is true for the confidential compute, I don't know.
> > 
> > For Intel TDX TEE-IO, there may be a different story.
> > 
> > Architechturely the secure IOMMU page table has to share with KVM secure
> > stage 2 (SEPT). The SEPT is managed by firmware (TDX Module), TDX Module
> > ensures the SEPT operations good for secure IOMMU, so there is no much
> > trick to play for SEPT.
> 
> Yes, I think ARM will do the same as well.
> 
> From a uAPI perspective we need some way to create a secure vPCI
> function linked to a KVM and some IOMMUs will implicitly get a
> translation from the secure world and some IOMMUs will need to manage
> it in untrusted hypervisor memory.

Yes. This matches the line of though I had for the PCI TSM core
interface. It allows establishing the connection to the device's
security manager and facilitates linking that to a KVM context. So part
of the uAPI is charged with managing device-security independent of a
VM, and binding a vPCI device involves a rendezvous of the
secure-world IOMMU setup with secure-world PCI via IOMMU and PCI-TSM
coordination.

