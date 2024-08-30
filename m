Return-Path: <kvm+bounces-25566-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47A43966B56
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 23:37:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 75B491C222FC
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 21:37:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E443A178361;
	Fri, 30 Aug 2024 21:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gg0wCiji"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893DA16D9DF;
	Fri, 30 Aug 2024 21:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725053846; cv=fail; b=PLSWwHQcMz3bX4T7ig2/8eRTMUmmkhre0AtQuD2otCCuyjcbCJJxw+r4PizIE5snOyB7I9qGpC4oQm9/+yeA/7reDUdetq+M8X5IgaTx1cEXyLXPYRIcyqxyQnHfvGilA4Hi9PoE7jbnpmiF+gUg9bZRwhJgNmm8I+nN4IOLxuc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725053846; c=relaxed/simple;
	bh=sH+OuVl4+9LLZfPpF7Gbqpe2gPakHlkCiy+x8pNLVYc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nwvyNpm4OXcfrXdBIqq5lCTOOhN8lgWoKasFMd+32yIiwbRXyPTOgzaNxgUudCquh1fdKpkCvhg547P5KYPIG4c5FByRrP+xQu99hZ2UUDF3FifGypqMfRL7TDEZY6sLsJk9MnN3jW73SQF1x0dKC+8deM4mz85+197i4Op0BMk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gg0wCiji; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725053844; x=1756589844;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=sH+OuVl4+9LLZfPpF7Gbqpe2gPakHlkCiy+x8pNLVYc=;
  b=gg0wCijil/o29WmhTFNNnWcWfSXMAwZnaQZ+IpCVT/3X5rrqLAt/eikr
   PSRP/zkVePutYAfKgfjzhz76KD1heUzliLnnntuxsiLQ5Wc5aGWymoxBU
   Bu3m3y6xB26EHhJ54uORgxRwHb0jtF2yJU02jvqG5AfUsruDiCoYjf9+T
   +tH+2eXDN1xykzHqBZ0cMN4V77D3dWlASIXcqIsMjLUK3oVvgpQdQit/6
   LormOMaJhqWmkjDozRQ3SCeCQXFdurngKVVlDdbhzhu9ujjfyg6N9+rvl
   37X9Jn40iDii7b6UGq36aKsSY6E+dG3JXc48lWM++qf7YRRet7atrQhDQ
   w==;
X-CSE-ConnectionGUID: x6j/QGpOQzesMUF7bBsMgg==
X-CSE-MsgGUID: gV10xOrbSG6gysguNAV1zQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11180"; a="23867071"
X-IronPort-AV: E=Sophos;i="6.10,189,1719903600"; 
   d="scan'208";a="23867071"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 14:37:24 -0700
X-CSE-ConnectionGUID: 1FBxcXKCTVSLq8aqIiPIPw==
X-CSE-MsgGUID: KLU9gSXATOWiSuUle/SXHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,189,1719903600"; 
   d="scan'208";a="64204035"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Aug 2024 14:37:24 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 30 Aug 2024 14:37:23 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 30 Aug 2024 14:37:22 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 30 Aug 2024 14:37:22 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 30 Aug 2024 14:37:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UGhMe3buLi9viOkarE7uzOA9PDxTZz2YdnfHOS0X4HIy7IHWj4yDCeZIyRSjEEGQpMXoyg/xq4yhXUzlSCACJH4lJ1V0caUrInqg0mcf+YZlmH0Rw//VaFvt61830XNH6hAXF8VI+WJ34Q+QRoyFFvl7PCEjDvlcRU3FZR+aUBvJvrmCaGcI7zblU/skqjKcKlmbDptdqyZ1+JzZS8vPNJO6SUP+o/tvZzjsWdU9OavtNBevfLGOaUExOdh3eypVw5o3qZzfeqn4aRDVoVJNUa7ijZj5+ymRpCDRaZshD6hfo0OqxtiQj1hgq9YkGzlnNvsqMUycmKjwmlSPIsSyWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ne0zfUi409fa/dQlbDP1XUQtwhlj/YWR5itZAbq5qw0=;
 b=EzWViuR+9o5UWqbw4d0jmCiPV5v/lkPMoj4ApCJbmgOp3ZkkadhrjRlyDz5mUUOOVqG6O+p9kYHkKULg55MY9V+MoyPoWVCPAZM7mheYO//QNwAElBuW8l4PXoYUVxWWP+dbNyFhGnF3vZ/2HErKyCYIjzjsAx9NNJCWrxbgu1BWbX3DFQzFJbEQPckvj6ZmxI6iWvoi8DEQB9S9vZ/s8mqWAOO8u063Bgb7+XctbUNGwMDveVsSBVxKWPSzZM/QKbK3YGOOkCJ4W9AEMfZwjj5NeTpmvOrpson3UeQAVsuqO/TGVJXYvpryOeGn6UV0zK0+BXxsnpx87U5CHDc0nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by BL3PR11MB6460.namprd11.prod.outlook.com (2603:10b6:208:3bf::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 21:37:20 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%7]) with mapi id 15.20.7897.021; Fri, 30 Aug 2024
 21:37:20 +0000
Date: Fri, 30 Aug 2024 14:37:16 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Alexey Kardashevskiy <aik@amd.com>, Dan Williams
	<dan.j.williams@intel.com>, <kvm@vger.kernel.org>
CC: <iommu@lists.linux.dev>, <linux-coco@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, <pratikrajesh.sampat@amd.com>,
	<michael.day@amd.com>, <david.kaplan@amd.com>, <dhaval.giani@amd.com>,
	Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
Subject: Re: [RFC PATCH 03/21] pci: Define TEE-IO bit in PCIe device
 capabilities
Message-ID: <66d23b8c7d64f_1836294e@dwillia2-xfh.jf.intel.com.notmuch>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-4-aik@amd.com>
 <66d12cb51dc9b_31daf294e9@dwillia2-xfh.jf.intel.com.notmuch>
 <63d577c7-2c2e-4cd6-b5af-b2d10237793d@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <63d577c7-2c2e-4cd6-b5af-b2d10237793d@amd.com>
X-ClientProxiedBy: MW4PR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:303:8f::33) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|BL3PR11MB6460:EE_
X-MS-Office365-Filtering-Correlation-Id: 803998c7-3f42-47c1-fd31-08dcc93bed42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?L6OiwHDHwNEK1I+qwW7ERwtxd4cLexRnU6hIKsN4apOfdjA2x6FXUWNkFL9t?=
 =?us-ascii?Q?+GbmuGDYKLTfit7Tx6nbQe4RzhnhcFtTnd7fDXI4H9bsxFaGUIKaoGuQx4gS?=
 =?us-ascii?Q?vDsX6NtgWVAzKfRa9N6jJeVPyESSJ1yQj08sUGdzvDTYhxSH1o2GOS8skE0L?=
 =?us-ascii?Q?HcWV2/Tj0al6m/eattaR7rme2mUT/J/C2GFHeXZV2wJkh0JFiM4FdFixCYnX?=
 =?us-ascii?Q?EEI1FIuQH8sYl918VPt/fAsTRfNzPilPOHnvjzecm0pvjVAfcb6tBQO65bah?=
 =?us-ascii?Q?M60mDSGTS0urrKjLJDvvT92rQSk/8g2Bloox228FlVjrv9dj/XrkiiJ+S8WL?=
 =?us-ascii?Q?mZAV7IAQCLH7FwaA8/AbiG65X8kvfDNBt8RyEoMBQLJJNF4MiyIvL7UbqluD?=
 =?us-ascii?Q?wbvfgFV8vd3faiDI+trC54cFM8mzYjvA4soRq6QAVVtbGgvjOkk2sOTF2DQF?=
 =?us-ascii?Q?T+I8CsrGEp1J0JVhgvJkII2eVFG51Mk0j2ozHiYWy7gQZbgy4uegJ9xHgXWQ?=
 =?us-ascii?Q?UAaq/PwDGQQiUcF7Q3zw9Lh8kBFbBRqCtK2PMOlGiGsZXcBatqSLbg7QRYgO?=
 =?us-ascii?Q?M5WSQIvw6rWuKm4s9zfR1QOaP+HtTIt23oObp6EJ6My61ZGsm+8XFpPILp71?=
 =?us-ascii?Q?G83/k2vx/1Dvau6UppBRfHE6RYpRi+Ba5uN9vFg4OAYgDWzZ/1qEI7ZzibYh?=
 =?us-ascii?Q?d8F3tM2YR1O+Slreib1wG4t9pXsQFrlQX8QbcPkNZGtTZFJVmYFQ/YjsGcsy?=
 =?us-ascii?Q?/rpR9d4nWs3Pb3fDG7phu/g/r/SPwTTfrIWIcAllWoloMUjdSSTVUhejVyrz?=
 =?us-ascii?Q?urKttuXeijpBiDiv2q4rqX8fgb+eg5yi0VI9ubVXQYHD7Vo0wmnr3D8exuGy?=
 =?us-ascii?Q?0mg+b+CGTsQRTUdBoB3POQl9Y3W52Q9jjBcAgZlAYDICpFIpBvIDnXb8JG9Y?=
 =?us-ascii?Q?/9U1cT2elDYZFTWeewzZ5yYyM6vkYezNoQe/G/DREN2xc7YY0haqczjV0Dwu?=
 =?us-ascii?Q?kNrk4FNJ9LQgmnKq3XQ8PhLvZZxFI7dnBjQrQUqKN7HfcZ7DQZ527V8OFwtT?=
 =?us-ascii?Q?qJE9035LE+hiMZNFWI3wceYm3kXA6vEu3wGYPAWtNniLEQw0woRiB3qrVRaf?=
 =?us-ascii?Q?3Ihj/VXhZ1CjkVDUtNGDtYnZzkQuwd9rdER10xhYtVqRu+dsIJ/t7V6X/2Nz?=
 =?us-ascii?Q?G/yFtGo2OyT2iSNATvqnI+G+2POyZ6k18bTJakxpumBH4J7glsjSFK9mmJG0?=
 =?us-ascii?Q?Zzm60PTrKZjU7HxLNC68rTEpedfyWNPk0zaa2pCU50npuRDBuFGy8b5R5AuL?=
 =?us-ascii?Q?0zJRgkb7QFB7jMSZxlRnjhDU3Qq4Wf/Na9HuhM3N3O8vEA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cC2Wk+RzgF9s+V5KlL7L38488nXK811KqLOl0Q56TUy8ymgqhW4TwT2whSxV?=
 =?us-ascii?Q?Pbeu+E75FcmIstHYa9ZdgcZynodtXJB2vrgreDZ82OzW9aeHFc4Jodkv5pxX?=
 =?us-ascii?Q?73s/fDC0RcUGPrxOA2sneVN3rHAosSFuLAvV5X15CYLSDmslgGAw5iJcc2pO?=
 =?us-ascii?Q?X/kLk73OeKpdsH5SmL/PJx/h3bqnDa2/gpemUD9LzSw+ntdURs4yGMtC9YjD?=
 =?us-ascii?Q?C1MkDvjOoBJ/zuRia90x08G/+LGFg72xYkXT0dkOztWB5OJdOBdFc6RlV1If?=
 =?us-ascii?Q?etG2wc0ry5+PQTPyD6ZQeJCZl2cb0MCnMOAIhwytoKvi0d6g5Ksa9KdTuI96?=
 =?us-ascii?Q?ZxIZY/VKCK7/2emxfBUR4uBGgujfGNHnPgNZm4fvzzWm6K+fqZQkWbdBqd/u?=
 =?us-ascii?Q?3aY11KPjg49nkFUGeeVekhyQJQ//qFLH4dVWKtzbaS60pc99qCxE6KCUvNpO?=
 =?us-ascii?Q?//mOfkgSqOR4+JO7Y/FUKZooM3b7+5Scf+9DJH64RVDiuQBsmOLzVf7PkPHN?=
 =?us-ascii?Q?7JN1+RbhcZx8TCJf4QP9VkInNXDjWJgdOEPPMaBM5HP+pNh4Nw9by15Sq1Dh?=
 =?us-ascii?Q?kf0KF/9KNPzcIwdibF4MaXoKk8+xjEZCf2nn+XJoiJ10hrOMfR5qorInBuaG?=
 =?us-ascii?Q?R86WL37hvTufy1ivYsI0I99apEJlvOjTVdDgZ8x8Pv/wwnXPoTGZcgaEMLFX?=
 =?us-ascii?Q?Yj426NeeDEEU3fitY0+vzCTIjYeoZYZIk25pqdoKkKZAbFGopC4OGzVGCyHn?=
 =?us-ascii?Q?cUnRAPWEW37D6aVUkTT3+X4NpOrXMoJSuVWXLmHQOd7dEH1pu99KL7YR+n5B?=
 =?us-ascii?Q?nJT3eSSI/Cue/BU+6mrlaDRcJ3aUGf/2NjR7U0Oxq5TRSdwG6pWV1jB7xHIA?=
 =?us-ascii?Q?LsafUF7CU4bf6jQ1rNQcBf+vemwrhtfKlE/8tt9wED/mRcSlo9lmnnjpU0/8?=
 =?us-ascii?Q?feumbIq6OReN94tKOUMJp6FP4+miyipNneITQHVONw7NYXBDr6PZVss2TwG5?=
 =?us-ascii?Q?cBlihp5dhwKGYJeVoxCqhET5HWKf4lhR4RsUh8IT0R2YbSu09dio23td9lZJ?=
 =?us-ascii?Q?fMymYN7UZo946PRIAos6RVPY/Lp9osiOLysjMD+C3r49EjJeL/1VH1QbzD8D?=
 =?us-ascii?Q?PsGlX1I4lWRDWIChhseKLqOVlODz3xRVD6W0xwBZmfaZ5RIvpMWxHzvbeIdj?=
 =?us-ascii?Q?kY5viQDkc2pqIomKEesIk/QvztdBwN/JvjNIWogUxTNcIYYgxYYF3X+1p4zV?=
 =?us-ascii?Q?8Fhvk/uGlKns8i0PRjLf+rwu6vBSLs0WV2i8smK8H80/qZE7owD+GgDVIu8K?=
 =?us-ascii?Q?9fUg7B4/QnwO16Ad3DbgN7fyO96LBI3ELb5gGzteaUKPoIiO7yYtytvfVII3?=
 =?us-ascii?Q?sdCuKN0K/9yyw4iyB2t9dnRwH3UL9LxeJZTvTbxL2wsBF8dFeRXTyIzN0Bu2?=
 =?us-ascii?Q?KCZ+iEAAChNCrbf0mAiNMPJCNxNk/93ZjSBm6pFSRnv9rz6skqcyHK+LNOM4?=
 =?us-ascii?Q?FAG+Hs1/DVTaPeEsw/FxLrutwNo2Mqy7Pd86dvGsLzZjuLx9uSfI5dW6W3s5?=
 =?us-ascii?Q?QKk0pkX+eBp9759M4lO2HeBKbzApLDfYllB6riCy6a5WjQDCH573YyVZS3Uq?=
 =?us-ascii?Q?lA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 803998c7-3f42-47c1-fd31-08dcc93bed42
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 21:37:20.1721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lIofchrE06k9MCo+9QP9crXjczxkA1iv0rCWo8anPsH1GN814VNNlQRnrI8Zh9NI6UJRv0iDfxX1B9salidvFHEZ9AQrxnEu8g0RBvzgvuw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6460
X-OriginatorOrg: intel.com

Alexey Kardashevskiy wrote:
> On 30/8/24 12:21, Dan Williams wrote:
> > Alexey Kardashevskiy wrote:
> >> A new bit #30 from the PCI Express Device Capabilities Register is defined
> >> in PCIe 6.1 as "TEE Device Interface Security Protocol (TDISP)".
> >>
> >> Define the macro.
> >>
> >> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> >> ---
> >>   include/uapi/linux/pci_regs.h | 1 +
> >>   1 file changed, 1 insertion(+)
> > 
> > Not sure this is justified as a standalone patch, lets fold it in with
> > its user.
> 
> not sure either but this one is already defined in the PCIe spec for 
> some time and lspci knows it but it is going quite some time before "its 
> user" makes it to the upstream linux.

So, wait. I.e. if the answer to the question "what does Linux lose by
not merging a patch?" is "nothing", then there is no urgency to merge
it.

