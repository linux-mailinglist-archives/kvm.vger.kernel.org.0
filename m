Return-Path: <kvm+bounces-63443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id C7C1DC66DA5
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 02:39:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id 93B1A29848
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 01:39:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E6A12F99BC;
	Tue, 18 Nov 2025 01:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CB9VvPuU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7405326C3BE;
	Tue, 18 Nov 2025 01:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763429984; cv=fail; b=Fx3UXHM67TNhiGaMqAW9JCjCgeubdutUdrH50nwxjDoMEjQtLf3xCMAiDdwYbQGGtkp9yKxH0/1Svqv0sVdqzpsGQ3F/lcftcTGU7VMr0MIYYVdFIjdRd12xG48EohL2KeZ2ohV5/kpIj8veEQtTAjzGeEtmtM73n4CfWy9/DvE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763429984; c=relaxed/simple;
	bh=HRsOwVRhkg6+t3eke+s00giA0hVd03TmMBErYCMcHIg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tsQBx4bs+cDqOP+VceLfEHEAX+1BMKn5L0cnq7Al3DnCmmrWytpDxqzIpvgEAj/MbxC/EBX1TYu/mUJj+/C2T84dqqzhO69Mzbb3KgnMYgr7AiECNRLqYQtTc2MlqUSWu8SD83RhVa1hG0ZSdPJ/K6A4reKuIdJQq7DSC/5oTW0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CB9VvPuU; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763429982; x=1794965982;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=HRsOwVRhkg6+t3eke+s00giA0hVd03TmMBErYCMcHIg=;
  b=CB9VvPuU/eH1TGNNWX4zDEgmXy/UjeorfrP76UwEEQTxdvfJ2Mq3cQXS
   6yXojeJgBtUmxRw6mJmmYTNuQGSq8GugwC4hoU+/CMaI4c352qBo/rGgm
   uO0baGFDLli6HZBRmzueRqao5/70iIis5yRcnhSwuRiichSwcFjmU857y
   2QLD3EEFveUnmQ9zZ21XlauQ73H7DoLRBxzVC1s/Ez85yB70IR4SUf7ZS
   7SlRGRBtAeLcDMUpaLZnUbeu/9UH2ixPWIGi4YScSBL3haB4+x0zeLizD
   UnKCjrR7vq8BxGgrrGyTnTYoNdJ0FfbD+MCFvRCVMWz5Fg11LBrYHRkVl
   g==;
X-CSE-ConnectionGUID: 0XG8psatSD+L4/3lfrOOZg==
X-CSE-MsgGUID: bCWP5YqqQIqdg9Q9PGdriw==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="76795373"
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="76795373"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 17:39:42 -0800
X-CSE-ConnectionGUID: Je9kzW84S+OM6AXcgPVOug==
X-CSE-MsgGUID: 0oUFYr4AQYqaaMwIOn1N6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="227946539"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 17:39:41 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 17:39:41 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 17 Nov 2025 17:39:41 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.25) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 17:39:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IOq94k4rorCbxku0bdFu2K00FWt3HEj4Q+o7UBOd+aEDgx238b8mvpuHcdWY4AWrA7NFzJHp5If4t5eznTjgoBrckzh35sBjWpaYNvnttr0OsKeeQlJkWl7mAcml9APFxsXkW2cDX5/YaqwzvGLUj9oBanBj5f6THCFp6KBBmkUv7gKQ2ZK8msI1L7vMWz2RA+F0rON2ewpL4r3RnNnNZ/5Fg96hesIycZk7zHShtUSntyF94FInX/GFKMbtoz77hRCcjm5eP6vC3CJ6v1D+xvGN83CTXzmeolhyOQHKkzZrtJJXo2+gtg4n+5LXV6d3jDe4dtq9GRL/QfSl88F3XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HRsOwVRhkg6+t3eke+s00giA0hVd03TmMBErYCMcHIg=;
 b=QnP9rSZ1m57N/ddg/mqmnahSBslWK9bsBrMSEnAmn0EdiwHIe17oyUxCE3sQY7I1rvUAHlTy7IHGgAzX3mNcewZcOhIWfM81ZiUkGHnGk9TuRQSGF3tl+5AmsDN1/q0+ZwLe+Gu72O86L7/zTDBh6GaiCj7a0NAGX4p9qPICQVGb+0NwhflSkWyUT13GIqezGzA8R/nfw+GVOGeZq8/Fjnw9OqruMyqeDDsH8+Xv4o5gl5T7o7j1PBkbns1iLbTU3EKW00wJQPt1xh8yK1xynvubOqrin+sboUo7kCZ4H5gKb5EXO77XyNLSGXZ8tI66Y390N5gLhvhr1KoGuR9NpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SJ0PR11MB6813.namprd11.prod.outlook.com (2603:10b6:a03:47f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Tue, 18 Nov
 2025 01:39:32 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9320.013; Tue, 18 Nov 2025
 01:39:32 +0000
Date: Tue, 18 Nov 2025 09:39:22 +0800
From: Chao Gao <chao.gao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: "Chang S. Bae" <chang.seok.bae@intel.com>, kvm <kvm@vger.kernel.org>,
	"Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>, "Sean
 Christopherson" <seanjc@google.com>, Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH RFC v1 07/20] KVM: nVMX: Support the extended instruction
 info field
Message-ID: <aRvOSnaUt1E+/pkC@intel.com>
References: <20251110180131.28264-1-chang.seok.bae@intel.com>
 <20251110180131.28264-8-chang.seok.bae@intel.com>
 <ebda0c03-b21e-48df-a885-8543882a3f3b@redhat.com>
 <aRPo2oxGGEG5LEWv@intel.com>
 <CABgObfaF4YO0Zd5PKJ3u7kRB0engmsSywnzztV8BKm5yUyQdmQ@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CABgObfaF4YO0Zd5PKJ3u7kRB0engmsSywnzztV8BKm5yUyQdmQ@mail.gmail.com>
X-ClientProxiedBy: SI2PR06CA0002.apcprd06.prod.outlook.com
 (2603:1096:4:186::10) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SJ0PR11MB6813:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bff3101-d8c4-436c-24c7-08de2643525e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?5n/3RUkREk+iH/dIDU2XIp0RTkon/N3EmuWcC4Y8pN9ohOWaEzCvD7OE5e1h?=
 =?us-ascii?Q?WNXZhwlsyn5PxdB95Xaj28isbDJL0mGzooJztb2DNIA4eCMif2euR2Zd2YEC?=
 =?us-ascii?Q?LSSFBcbOIqTBwHhoYzNuSzUf84UBB4w81nInjcxa21fk1eS8j87gTJkafHEC?=
 =?us-ascii?Q?hGUWH+tV7o0f2y80ECJH7FDSs3hLNwgt1gbtknp/o3piN1ug/uHODjeYQD7y?=
 =?us-ascii?Q?N6rUYRp942szQohWPHy/sFc5vj4061/a7vn9i5evNrlEPYXg/dG6wL0YfLPR?=
 =?us-ascii?Q?jekzViKmPUJmsviWAlJoqqHZE7wNb020V12SiAlu//5acaQEPHHOO4dzsgPh?=
 =?us-ascii?Q?R4XwxWGknaZsRGeuVRy+JKJIQzYB+KQQWlhzuqw6FupPaXbkm3PWD6wgIrBN?=
 =?us-ascii?Q?4kz6meNLkQgXH63SodefWnfoo0BWV7KboOSzWkQFbMVcGB5uiQ2seA8wXBPb?=
 =?us-ascii?Q?aBjBH67IwWN+7eOk4gWctpGxZJiByQIgNG20RqUhtrwM4akI4bZ9H4N0vYPX?=
 =?us-ascii?Q?HzUJAZJW+LRNRwoV6urpD11rawTVmEM8zA3GkM0BzW3+I0vFqH081UDZJSuX?=
 =?us-ascii?Q?HIw8mA8CJKmgVpcvRU2pC6fZQzUf0qkIw6yr14S0bhuGbFVmnCJ478wEPVD4?=
 =?us-ascii?Q?ua4yV161gmlYtH+MbX+HjuM2bWswMDpp0gwt18n25BF10Efz0he7BGZLJuC2?=
 =?us-ascii?Q?D4LoNG+A7rIJsDugM/a3eY2zZjicH3IZUEB6Ik20qSsbqnamdqULKzzzt3jr?=
 =?us-ascii?Q?RqJCXG43X0681N7KZPK7cR06hmJ0hHTUyqBciB4ERSg21pVQ/l830DoEamMZ?=
 =?us-ascii?Q?IxKhXTWonJJXCUkp6lx116PHepsT1azGY+TVOFULs+GRxApSdG8gBxv44UEi?=
 =?us-ascii?Q?ZVHH7SKoVfr9RRXBt2XoDUlr91r2q6IvW33cUByW8/XwuPmiN57u8/k8n6yF?=
 =?us-ascii?Q?u8chiYuAHQ0qAfLK40WWVTbGo6uDW6zpyYqiyY5M57aRZoit2b+JxLvb3lyY?=
 =?us-ascii?Q?/yDtgJeA8rwuP6VawLy4qX6oVcqf7dd1FOAI70m1buViq+iMookhublwwDvg?=
 =?us-ascii?Q?d8ajt+i5qLMG5IPIZVwDi85gTe3lBX35lXW49dgY2z9WGq+DiD/zFD9+lP/c?=
 =?us-ascii?Q?0F+6VQr9yJO8iGRx7h8f/g4aYsixPQOCAbsTYC7cst53zJBfOTyD6IeJi1rg?=
 =?us-ascii?Q?EXxKk4R0v8EnUkajiQAMj88NhNuD7JwA7DefdRYotwQ9n8VwQRHqyE7bntfI?=
 =?us-ascii?Q?nY0mNd65iJSuwVuLdxFsxMtif9swN3MLRU+B5bb0aSt1WSRkCEqms7BZmnrl?=
 =?us-ascii?Q?/MkxwscVVD+TUEPgaVi/n3XvASR3BRXhBlyh+bcziHqDhJPU828PYARbzgkL?=
 =?us-ascii?Q?XT4t4CWY5NRrE/NrcAI0Q4tbse+XXwv9GnKIwGZNCEq8HCInQ6mvTsMs8zsB?=
 =?us-ascii?Q?4imUUg11436hAQKH02iODjaZZ0qdgrzT?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LHlM00SEk0WJ6GgITLJ2H4LXUgvNYYpoaydHrECrvDTogrIs6oOM2k41wXZc?=
 =?us-ascii?Q?KIW7Yvm2acoGCHCU6mY/4o+xHIc3sZfFrEBHB+ooeRt5Ma7BsVB4/p1uJml0?=
 =?us-ascii?Q?faZNvMJw1QjnHKXhmq+yB9CqpcDfbXy23agWt0RTs7n1JLiATqjo0KDsJfEr?=
 =?us-ascii?Q?wXbBFONhH4LejSvW/aL3gOfGTpat35lqwg/xKD58Yf64M63VnA3Nga7LZ9mZ?=
 =?us-ascii?Q?P42aV4UXVYuTkvn0lsCHPtsqzsNdxgTHYujBlr3agJiBjvdmNYE673BxgTcO?=
 =?us-ascii?Q?H89spLHUa7pl8YIc0lI1LdjTt5ja4csy0InB1Tcr48WDsCCvV3g/f4jwZ3oN?=
 =?us-ascii?Q?d41Ocpvg+cYmePxnt5M/fKKjVA5Es5fY8kcamoton2gMGyZKXNfnH1Sv2Hto?=
 =?us-ascii?Q?mY0risFyPZkT1xJzClM43dNckf9saW04A1tqdRLCoht4US1JejurXLa4AB9/?=
 =?us-ascii?Q?ewtcc8VgoOMfy4u5gfRp0iRFJQ91g5YaWYv82KEorjXf50jTxl2b+HUJaEFY?=
 =?us-ascii?Q?M9eJ5n24up+giss+cW8Qsaj6LxJevlB0RrceXuU7+axigalcKp1Xu4MZY3fZ?=
 =?us-ascii?Q?0V2RjZyLXplHoslqK0UWz7fQmPxrXC6n4T57dOKCq6w6sL2mFm+iChOIPNnR?=
 =?us-ascii?Q?IIByAmc+yljtGYe9TCfOrKvnHIKiZo94XGrYz+whKlcBm0rfk5SJTObV6TZc?=
 =?us-ascii?Q?4yeVGiJxzWu8F6RDBlsu76iXov+WCTjc6IiKDCKLp9jSzl1K/yxuZInk0UGK?=
 =?us-ascii?Q?nam9OKMALAGjUq1WtlQuSPIQZ0sjcKIny8e/yzEbIYKi8erBuwridVXy61sN?=
 =?us-ascii?Q?B8yeW9Ifnqewlg3U1e9DZj2nKb4IQrEYgybIk+45bebUJdCrUn58PUdOyXk9?=
 =?us-ascii?Q?OrkB1PL/tg+TDBn0kGJEgcNb/5HUoqer8sgJ04fUlHiso4Du6W8w7qOowGEr?=
 =?us-ascii?Q?p60U9hIjLnv7++hiUqtUQ+dnL5C1SNNQpR8FEf80+o41NboafwsqYs3XKGiC?=
 =?us-ascii?Q?ARYeecbVFoREzRWjDpxyG4n6l0iEAay5kL4hDIVkLjFFmbOQsqFeGulkm7K5?=
 =?us-ascii?Q?chblmxe3Xm7aAV5sFyYqtWyrGdPpOdEqqck2mWd/haUnH6OAbypj5S8WRGH0?=
 =?us-ascii?Q?zF0nHwsiSPbczDaRfd7QTAW8PJ/sO8VRkZXToix3tSrEL0Z0Bn/KVaua0/h5?=
 =?us-ascii?Q?Yg3uXXCK0lDZQTRU4wwfz65VHWkMc6gclD1JkEuaBMF89r0YiSrzltn5Sbuf?=
 =?us-ascii?Q?vAwwm9kTH+nenK7QppSomwF9FA8wL9WXEn7x4yUf/qVqWrKzqG1UkRRjU3rV?=
 =?us-ascii?Q?W3Z3hGqPTgUWNOQ6TOA65LhT7CEjxMw6gLqJzMYgAvaKCuSwvdwLzDqpFR2N?=
 =?us-ascii?Q?9jNMN348H/9qmFvqmH747Mei+khdywOvqZpX5GTXiqA1u9S2BwCo4X7v1Egg?=
 =?us-ascii?Q?qzShkYZPS/L24LyvyHQIvNGU1Mm6JZa+fThm7yWXRo4DXIvEk0UOHwJjb6I2?=
 =?us-ascii?Q?5ZOJJo1a8WcaWsgh5H9iYC7GkJC3FF4s1RC2JHBomkgbv/RLn+bA/xNvfb0i?=
 =?us-ascii?Q?ncxVxytLvWPgRI/w57IS/9UhHeov6qt5Cg6oKnnR?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bff3101-d8c4-436c-24c7-08de2643525e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 01:39:32.1387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IjONt0mAGckhe7Ad1/MIoUnnWwkgEafvcMOs9eqg1eApsqlBO31xrGABGK0av2orhMt8GfBDm/efBL5A69uEDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6813
X-OriginatorOrg: intel.com

On Tue, Nov 18, 2025 at 12:29:19AM +0100, Paolo Bonzini wrote:
>Il mer 12 nov 2025, 02:54 Chao Gao <chao.gao@intel.com> ha scritto:
>>
>> Shouldn't we check guest's capabilities rather than host's,
>>
>> i.e., guest_cpu_cap_has(X86_FEATURE_APX)?
>
>As the manual says, you're free to use the extended field if
>available, and it's faster.

The point is, from the guest's perspective, the field is available iff the vCPU
supports APX. KVM (L0) doesn't need to virtualize VMCS12's EII field if the vCPU
doesn't have APX.

For other call sites of vmx_egpr_enabled(), I agree we should just check host
capabilities.

