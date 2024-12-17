Return-Path: <kvm+bounces-33941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8449F9F4C57
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 14:33:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7957D1896430
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 13:28:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC3A01F4734;
	Tue, 17 Dec 2024 13:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QXq7LmX6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F258D1E8823;
	Tue, 17 Dec 2024 13:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734442048; cv=fail; b=nATeCry+DqFXVVVT08qtYSs7n3JpHbX0HFA+MNw4gIyvkB8WU+ogqumZIqBaAtDD7GTOCtvMjmjj/IPzez2AdikOLhbd6ZsLISL+bGvYRK1OR+mnjf7aqZrweLaYNkTJYM/kLf4oZ8vUKDWppGIrBvMgRhdjIGxWaT5XGHvHn+g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734442048; c=relaxed/simple;
	bh=dyY4Cvdof3uE6O9+FWnDIuluBslYaFSWbr8QSmQk12U=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HRhBz7dk1gXpbqW8HP+4bEBSKxODnm3Xloqhqaky7g7GchdR0DSfeqRxLYoKA+BEU7YHlE9BZASAfPqZ4yQh7BKfXaFlw7Pg2Y4zZ02515dBvO2+9jB+yP6lZTnT4pBloyUUjAOJ6/g1J0sAZJWsbaX9TfeNziXVo44x+hMlAfk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QXq7LmX6; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734442047; x=1765978047;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=dyY4Cvdof3uE6O9+FWnDIuluBslYaFSWbr8QSmQk12U=;
  b=QXq7LmX6t+PjggUp0qeY3W4xIVWxtSHzVDaWfFLV1tDO6mdAU7gQzud3
   z3UrqrpMsLXOjPi/Qg7ERoxUNGtH3qKxKEeIyqdSj3q2DLbrQVsBPQZew
   4Gpy6EFGtNUa7V8jazugfsFLU0gEEi4e/sikZvZCcDLg2srTstbHi1dv9
   V6LxjCV9dAvlhwZ52O/7V+JwSD/FXUUh5MSG/8Nwr8v5fgxMLrJLN5Q2H
   D7VyXHJs0SBlaj7/o9DL5nudNJxXf1CfsMVnKB5bCeGEXNpHuQmxrgm/O
   I0jgYWokj7ctjvKf/gAElJmr4Ti2wlnC8D7s/jScK4JkTGGNnPEDS/iGW
   Q==;
X-CSE-ConnectionGUID: 6DRcwicESji5rqpYGOhfYw==
X-CSE-MsgGUID: umwdN+mXSCukEg4aiG/K4w==
X-IronPort-AV: E=McAfee;i="6700,10204,11288"; a="38645756"
X-IronPort-AV: E=Sophos;i="6.12,241,1728975600"; 
   d="scan'208";a="38645756"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2024 05:27:26 -0800
X-CSE-ConnectionGUID: roVNDxRMRnObZyBY2d+6Lg==
X-CSE-MsgGUID: hLNGrgclQYCxXyJGzxzHEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="101673255"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Dec 2024 05:27:26 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 17 Dec 2024 05:27:25 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 17 Dec 2024 05:27:25 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 17 Dec 2024 05:27:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cwY4S0IfU1JeDhr8HGNE90xuku1AtXZPDxdDo3m+Iv/F4pIhZNb1kiJfPc/uL9cZ0lkUlY1533lqEs83+MEc1miBlr5oq9LjoZLfet94Dr/pKClDHUCIfKZdFpnPs+NZ28HkEGe7yb2zBPg6LCN/e9+zCiUc7I6OCCBL94hqtKBIv9Okoe6hFho8gQRC3bpvfhkh+dS3yTzd4O2/IIIZGpG6YjB6nayllO3exmJ4NuCKQ9K3BXben+3MQh5xouZ+TBt3tQYvszjeXuDTT8gE0c/ehaF2PgfFpJGldBWfYqtQ0ymkGw7meJz2XJ8DsKJ6tv20NYdHJ61E4ivF6YJqng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OkYJ93nZclUm4VLNkWE4Rr46obv/GvZmCq/k5QbG3Yc=;
 b=p7/7RBXaMF/IP8xOGXvq9lA7NxWYTX/gQvNZDmDEaH533+TiwqTIOALiKPCt86HpvzCMgfm0yK8QxZNL+VV7wH0xZyB8tlde6W52cP8+Tkd3QjPZWqNIr0XbalKcPvLhndLNhY5ahw/o2Va8J4UNk1axvmbB14oSskg/+uHQe2ywC8NUIT2LmD2solEeN04F1PuclbUl2yHqLITXfQ4z8G8goUd68SqMgF4gm5Vw5bTdNkVKk1PcIMsqTqu0aeuLb+q4o3tcyaSNwjFWg0t9gFBF5VhwjoHxxzPoK8Nfz1YO5X0CXw09blPdS/JkUyg2yP5zm5AQSThTQEJeeBOLGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB7500.namprd11.prod.outlook.com (2603:10b6:510:275::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8251.21; Tue, 17 Dec 2024 13:27:23 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.8251.015; Tue, 17 Dec 2024
 13:27:23 +0000
Date: Tue, 17 Dec 2024 20:53:04 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<isaku.yamahata@intel.com>, <binbin.wu@linux.intel.com>,
	<rick.p.edgecombe@intel.com>
Subject: Re: [PATCH 13/18] KVM: x86/tdp_mmu: Propagate attr_filter to MMU
 notifier callbacks
Message-ID: <Z2F0MMiHf/CHwGjd@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20241213195711.316050-1-pbonzini@redhat.com>
 <20241213195711.316050-14-pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241213195711.316050-14-pbonzini@redhat.com>
X-ClientProxiedBy: SI2PR01CA0049.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::13) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB7500:EE_
X-MS-Office365-Filtering-Correlation-Id: 890313cd-c6f5-4506-bd32-08dd1e9e8a2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?k1niDclyGSJHYZQ2kWO3jYemoXz7dugjnIcgo9aqg5UEgVr/0+MYZXPfbXoc?=
 =?us-ascii?Q?gHBISnTJjCUvIXS4GNNU8+vAFcGxY6S4Klv0tQgODng1F3gyUve73t4zH9Sv?=
 =?us-ascii?Q?g/hYRIGGN6pOaCIS+2rWc9VctXW4riks0lX2vK/Qg0HGrCLAZm3SMx5ij6s2?=
 =?us-ascii?Q?p0mszTogcDVdPKeV7HZwtMaFuq/KrJ7QgvktIbIeRC+LEiJ8k+JAHN3b3eli?=
 =?us-ascii?Q?SAGIdsuJzMTgoINjEIWPl3L5CkgiZS3KTCxlOxQEMyDQNyTH7jPwUT5peD1I?=
 =?us-ascii?Q?lHU3rDeYNna8soT08rsNx+HcFS6Vjf94AFDiensaNwaxZ8vCezIpCkinH8Jf?=
 =?us-ascii?Q?ObWWXPMNYJhUsaYHF9vYwKZGfT0dAuQuMZ6zEELTAG+i4GjPKBy8aQnnnbIH?=
 =?us-ascii?Q?2OTcudYxV+pdplPq/fVDipjt2DGxad/27/RV6+2z8yKGCzou/5ypxnRR6gOd?=
 =?us-ascii?Q?6GLiQvdRyHIgyk1LSk67hkdyJHpFORiuZiZcduaWkTwTTypBkFswHREX56Ru?=
 =?us-ascii?Q?Wi7jx2kEeZzPUS1GxGAgqCfFHsDVhJA9YCSDYBfzycXI7vaYiPK2D1vwTPqy?=
 =?us-ascii?Q?I6zuxp3A/oWKRr9Yxr3K9IJwUH1flNCJ6L09MBEkgzYuoPN4rL4ClUiOjaT4?=
 =?us-ascii?Q?dp45TkqHF2AENWnVbNSPgC5ApFYfTZqczuvfoWtRNPOOq6/p7p6eOAEdMUt8?=
 =?us-ascii?Q?oZZUXqyb7+jBpamBQwlsasj0Z3i5s9fF63N2UNPwXjD/pO8nVBXg+R2VVfvW?=
 =?us-ascii?Q?pMW7HJNewRI86sPrGYKD2DB5ZcKCq1q+uKgHMsh4Okw2MMKmDA3bKHTBRDNO?=
 =?us-ascii?Q?Mg3RniwZTws1exeHiiAK7LXjxRJVW47K4KqEbAlKHtzP9BRbWX7LkyKBgjHx?=
 =?us-ascii?Q?Ic6fGg/dNGJcOv4VkdtapXBEBJwEKNg07xUyTAIGfl8bBIv9QGS0COtU+L6k?=
 =?us-ascii?Q?KWwEKWkqYJvuu0WlrB9tgm6/Vqd2jsij6JOXFRNP2DzbdcYNBXYj6CPm60M2?=
 =?us-ascii?Q?RNr/aHus4qKeLnccXBihwWrq25xBJhGEvQdPANP+Iw8JpKiiIVYhQwIliq+/?=
 =?us-ascii?Q?Es2/V+nTACa/oEG9kJhMmXg6jt7UW5hXLn+k5dcQjWdBgIoCyyZxRPLn0eDs?=
 =?us-ascii?Q?X1lzec0OQBAWM3QBC9hAzknbCarUgEg2D3iozldkBCXXw973Zv6tqexxJ3+K?=
 =?us-ascii?Q?kEhFpiCCgj2gUVlo7Jl3WpplNgOmQE0p+tHVwqWdGCr1XveNfXUBECUkKYc6?=
 =?us-ascii?Q?+8I3Pvcv7NrTX9HY2A+ifPCJ74EM/SJ+QoC7QfQXqe8nV0daJMhB1puw+Xm8?=
 =?us-ascii?Q?AqFEiMQnDO5rjCMnvmM5lRaswj6UTrRrpHpHOHBqacoexz/6cGwKuPivsyOo?=
 =?us-ascii?Q?AfWHSZU6TszMkp0hLeGdaTQgunBD?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5cUtYuP/cztQGUJXoOMJf4+hytuHUQwCfjZejfQJ4XsySILY3JF6Nk0TMq1U?=
 =?us-ascii?Q?JK0wr25GtLjEcwCpdJ8TO/CY5E+EwSomFKOfPAPmPdEgWxMcuzcHM7bN9hV+?=
 =?us-ascii?Q?/4O3wkyM6QfTzwpYr/lz3Y9wruL/Axc8i5LXe/s+2MuTKzkK/vaNbqRNdKI7?=
 =?us-ascii?Q?VMeeXb1qpy0A6Rlvoj6LUJt/WEZMsBMOkAncJlfX/KCgCjDBG4ohsK2wbiJj?=
 =?us-ascii?Q?UqlO8r457STxteamh16xlWgFngNuXPjPXB5WpBx8yYYWTLw6zAxNrbNqJWsY?=
 =?us-ascii?Q?4hNAgTu8wiLtB4+AXpyDgYYCb494tNTnfqrMJvCzORFt/puEjh1JR2pkfZnB?=
 =?us-ascii?Q?6Qg55zeQyf6rPmvfv4M7udb9wugatgx644RKjoCb4Mcaqg9i6ssdqmEdxfLK?=
 =?us-ascii?Q?wnaVPiqssBjtwn1jGuGi0Lpf95yhJoJ8zXXJb8ga89Ecwwr7U7dqjBhd4wDm?=
 =?us-ascii?Q?RoHrCUQc9ZmKQ4fyz9LMpNtkGqLggj3g/QOotJFVspc8X6om2yl20n7lcfQk?=
 =?us-ascii?Q?TCZSr9ahSqTi/nTa/oUC44W/1XC1nOOteIMYSmW5I6QKknW7IxITeRUTHJDU?=
 =?us-ascii?Q?oZHl4OQrjyZGfmcz60WB43b6+x4mFZb7UMRW+ue/F32VOSOLfjup/UY922B6?=
 =?us-ascii?Q?7VBYQXSCxOu4EbPiB2Na8kffy4YGKnmORjBiX/yVSR6OuNPQSRwqobe8zhlF?=
 =?us-ascii?Q?NFzKyMoRx7E77P2hppNYwDqBj1KfU/w31b6XByjBmzxCT7rlc3Kru7otP2ix?=
 =?us-ascii?Q?aH0xIn39UpInYSI+AX4GEpO5xXBo4SYQbhHII88Vu7O9cK1KxD9/H7TqyFbL?=
 =?us-ascii?Q?bZJnO0mHDPPZoEsLcuux+S5/oXg0JYQHOgFD3KZk6m0v8D7IoXTR+vZnUebQ?=
 =?us-ascii?Q?r8N5aXe4yzqMGtQGa8DEwl7gsoT0+TyT55TQDkGMp8eu/jbHyOPS4igzRSfO?=
 =?us-ascii?Q?RrEpvfOF/tsX9vwA3gyd1N9rrLf0SIjP7jyM22QIHVGB36xJiymThrihiiNA?=
 =?us-ascii?Q?GZHBufwhlsNUJKYHZixumiC6drwHK5TkFxz9fx6P5Ai3tEueXVF+sYCCt3iS?=
 =?us-ascii?Q?BjYtxBz/ybYy/Qm+rNF9mTzKl45PNutvgQvjlhygWlNn8aWZAt/R57swHhVs?=
 =?us-ascii?Q?wT+HOyeRWkj/BII6xNN3a3BoqlB2hXmxNSK/YNjNR9On3gBl5nIdTmaJnK2Z?=
 =?us-ascii?Q?Q8TDCNAd+f48luEZk68Qd1CrsRKbIxI96JIE/E8bF3EkxyQMF1nBRyvn9JhT?=
 =?us-ascii?Q?75pC0m79bGWaNrAQh9N9IXCV5vz4LNZ8xDDDBPG7w+qxTTe1LV50R1VufSQE?=
 =?us-ascii?Q?1XUC+GuiZQ9YGam/yu4d95O7u+zqJWoxaKKTmReeuDq+MblQM7n90CvsJS3s?=
 =?us-ascii?Q?JASyyGuhNGnrQtj3sWHN/oMRj9e/QiLsijqODtQJ4Qeo2qJPiXccK4YNoDer?=
 =?us-ascii?Q?WTWLNYtQQAeVmHPhVUBR94y3WX1NketGYm99ZAEMS9mNqv3fJmudj/OPcjbY?=
 =?us-ascii?Q?JlVY1THO3N419CpiCdt7DD26V6hKBpu+1ok5wt7gpRqfXm8qeanbkxf67qIh?=
 =?us-ascii?Q?wxd7xFdWIjpjLqQH7STX44qlPgUqhnom0KkB3JYh?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 890313cd-c6f5-4506-bd32-08dd1e9e8a2a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2024 13:27:22.9936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MhKm9OkbWmkFB06Ds1p11XGyrfQjBkfkh/HTvNVknPpscsB60PXuvWAyiGZJpJZf5VeVWiUzqJTfhNmnB8YwjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7500
X-OriginatorOrg: intel.com

On Fri, Dec 13, 2024 at 02:57:06PM -0500, Paolo Bonzini wrote:
> Teach the MMU notifier callbacks how to check kvm_gfn_range.process to
> filter which KVM MMU root types to operate on.
> 
> The private GPAs are backed by guest memfd. Such memory is not subjected
> to MMU notifier callbacks because it can't be mapped into the host user
> address space. Now kvm_gfn_range conveys info about which root to operate
> on. Enhance the callback to filter the root page table type.
> 
> The KVM MMU notifier comes down to two functions.
> kvm_tdp_mmu_unmap_gfn_range() and __kvm_tdp_mmu_age_gfn_range():
> - invalidate_range_start() calls kvm_tdp_mmu_unmap_gfn_range()
> - invalidate_range_end() doesn't call into arch code
> - the other callbacks call __kvm_tdp_mmu_age_gfn_range()
> 
> For VM's without a private/shared split in the EPT, all operations
> should target the normal(direct) root.
> 
> With the switch from for_each_tdp_mmu_root() to
> __for_each_tdp_mmu_root() in kvm_tdp_mmu_handle_gfn(), there are no
> longer any users of for_each_tdp_mmu_root(). Remove it.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Message-ID: <20240718211230.1492011-14-rick.p.edgecombe@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index d17a3cf1596d..9a004c999a28 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -193,9 +193,6 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
>  		     !tdp_mmu_root_match((_root), (_types)))) {			\
>  		} else
>  
> -#define for_each_tdp_mmu_root(_kvm, _root, _as_id)			\
> -	__for_each_tdp_mmu_root(_kvm, _root, _as_id, KVM_ALL_ROOTS)
> -
>  #define for_each_valid_tdp_mmu_root(_kvm, _root, _as_id)		\
>  	__for_each_tdp_mmu_root(_kvm, _root, _as_id, KVM_VALID_ROOTS)
>  
> @@ -1172,12 +1169,16 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  	return ret;
>  }
>  
> +/* Used by mmu notifier via kvm_unmap_gfn_range() */
>  bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
>  				 bool flush)
>  {
> +	enum kvm_tdp_mmu_root_types types;
>  	struct kvm_mmu_page *root;
>  
> -	__for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, KVM_ALL_ROOTS)
> +	types = kvm_gfn_range_filter_to_root_types(kvm, range->attr_filter) | KVM_INVALID_ROOTS;
Just curious: 
though adding KVM_INVALID_ROOTS matches the old KVM_ALL_ROOTS, why do we need
to unmap an invalid root?

> +
> +	__for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, types)
>  		flush = tdp_mmu_zap_leafs(kvm, root, range->start, range->end,
>  					  range->may_block, flush);
>  
> @@ -1217,17 +1218,21 @@ static bool __kvm_tdp_mmu_age_gfn_range(struct kvm *kvm,
>  					struct kvm_gfn_range *range,
>  					bool test_only)
>  {
> +	enum kvm_tdp_mmu_root_types types;
>  	struct kvm_mmu_page *root;
>  	struct tdp_iter iter;
>  	bool ret = false;
>  
> +	types = kvm_gfn_range_filter_to_root_types(kvm, range->attr_filter);
> +
>  	/*
>  	 * Don't support rescheduling, none of the MMU notifiers that funnel
>  	 * into this helper allow blocking; it'd be dead, wasteful code.  Note,
>  	 * this helper must NOT be used to unmap GFNs, as it processes only
>  	 * valid roots!
>  	 */
> -	for_each_valid_tdp_mmu_root(kvm, root, range->slot->as_id) {
> +	WARN_ON(types & ~KVM_VALID_ROOTS);
> +	__for_each_tdp_mmu_root(kvm, root, range->slot->as_id, types) {
>  		guard(rcu)();
>  
>  		tdp_root_for_each_leaf_pte(iter, kvm, root, range->start, range->end) {
> -- 
> 2.43.5
> 
> 

