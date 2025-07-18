Return-Path: <kvm+bounces-52871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F2166B09EDF
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 11:15:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 723501C45AB5
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 09:15:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A587298989;
	Fri, 18 Jul 2025 09:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SzvHiVyC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3717B29616E;
	Fri, 18 Jul 2025 09:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752830102; cv=fail; b=o4U6yu6F5lfCq1eEiscFcOikSQjTr3J3oZ4mHTg5t8cfW/rXN+JNjQgppLD10LqcQhXuy0JV63AGBMTL3rUuPXijK9V8hCXF9Rai8or02l3FPp7a7xKVtXB83E+bRKsRmgCFjm0wDZ/V4UPGSsqO/OEAYVs3bNuoReNH+jg+8+A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752830102; c=relaxed/simple;
	bh=2f9MMDHLPWLyJv8pTsh6l9XzeAssBFn1cgTc2tc+x5k=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=R3N+6TursMVCVI8u2lPsf82PMddS5YL8kOz0+Ye+4BJ7CBE1GUh+/kxLbjqDH1cj2VAVI1UpGK55cgw2oskryzgKJjjFJ2TftWkGWDYTtp6boyunB/u0MfSjNRw/cG7SKGYhpX/bbLYjYs04GrZJJoBjuVAFYmhe1Edxzbb3GC8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SzvHiVyC; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752830101; x=1784366101;
  h=date:from:to:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=2f9MMDHLPWLyJv8pTsh6l9XzeAssBFn1cgTc2tc+x5k=;
  b=SzvHiVyC/1uxO+NLIIoWAx9KhlV1egI/wNSOsEZZNi+QiOPa7oux+P1U
   XPV69XGIxxsIokKvu0wmklViFTSJxvf8ctvgoYat/Ehahg/2L7Dl7gYAI
   Gyray8rqK77DT4BbbRLdUPE6IlhLK9TNwn/WKviVEtuTpbboQjgsqH7Wj
   Yvm6Hx/Wtd67OofHosx4Tms4oofc55A80GEL/Yh13ioQ3RCx7GrtbpgHj
   QvGXavBgN2HTOE8RaW32aiw65K4BdLruuEUTfGQP7cJM9Umkg3B9A3BNY
   gZBViIjEcgu9V5ebDfla7h7yuMXci9Uye15Qoy7olI5PyIUpKbMVtQvNa
   g==;
X-CSE-ConnectionGUID: K2xG0F7VR5a4xJIyT+qgsA==
X-CSE-MsgGUID: XwM1cjgYTcSMSLeUuE0gWw==
X-IronPort-AV: E=McAfee;i="6800,10657,11495"; a="65811290"
X-IronPort-AV: E=Sophos;i="6.16,321,1744095600"; 
   d="scan'208";a="65811290"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2025 02:15:00 -0700
X-CSE-ConnectionGUID: 8C6W4nqqRLuu3lenyjSjYA==
X-CSE-MsgGUID: RbeTozYNRWu1Wn1q57f0+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,321,1744095600"; 
   d="scan'208";a="158130030"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2025 02:15:00 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 18 Jul 2025 02:14:59 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 18 Jul 2025 02:14:59 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.87)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 18 Jul 2025 02:14:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XueMabxB69Ks5HaG7vA8QBdd4L1V2DIK9OAWXK5AgcxCmLs4a/uaO91LxXqQvWec4cNENonbI0+6rkMeSD30MiB6WlDwx7nUSYhOz9Jqex6F0lS3pqZsE/TFPnpOy30bJVlZTHmYiYzULEA3ePihVJ/bovRaxFDqzym9iQM5uR+XOvF5CHIY0rDzgyYpVxWSfarcCSn7G/juHk5lTUMTon5iD+yMBRNsX/Py4JdupjHjF24EDFbYRTEtRy/sw99m/UsNxGoBrGx1d0lsk3ZZeDng6Slzr1y1NeD/XLtkkTOKdMZYPynEXQh9HnaLxBCt1j2xY6OE+nRQPWg41sljTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WOQfanyfFIa62Mw9yu/mHlEkRyHuPOibM+lOJlghsOI=;
 b=GwHcPH8HZbC5rzzqEXTsrW+8cCwi1nSuhC57a+P4DTdtx9lIJlSGH5QsI+dkfAYKbX6fqu6r30s7Ab7cg9H+x6f7PNAJWosvax0ApX55obSQMJwmTZ/UbThWlYYFmlYDU2jB//HKEeW4iYfSMDX2M9s3DqOkfrSKHzn+hnI1dT2SS5pHxoi+ivnJpEGabq++EZeyWWfNmHHR515tQL3P0xHpGQvjJNfvZzhb7IAnK8OQEV2zILglaFFcui+RKT8bBN5rpb/A3KxxYlR0eZws6uprbOcQS9cYSty+lsj6q/9Tou6El7FQAoZtCDakpDsOxhk9arloAIjLOLvG1TTzoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MW5PR11MB5788.namprd11.prod.outlook.com (2603:10b6:303:198::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.23; Fri, 18 Jul
 2025 09:14:49 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8922.037; Fri, 18 Jul 2025
 09:14:49 +0000
Date: Fri, 18 Jul 2025 17:14:19 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>, Michael Roth
	<michael.roth@amd.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
	<kai.huang@intel.com>, <adrian.hunter@intel.com>,
	<reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@intel.com>, <binbin.wu@linux.intel.com>,
	<dmatlack@google.com>, <isaku.yamahata@intel.com>, <ira.weiny@intel.com>,
	<vannapurve@google.com>, <david@redhat.com>, <ackerleytng@google.com>,
	<tabba@google.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH] KVM: TDX: Decouple TDX init mem region from
 kvm_gmem_populate()
Message-ID: <aHoQa4dBSi877f1a@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250703062641.3247-1-yan.y.zhao@intel.com>
 <20250709232103.zwmufocd3l7sqk7y@amd.com>
 <aG_pLUlHdYIZ2luh@google.com>
 <aHCUyKJ4I4BQnfFP@yzhao56-desk>
 <20250711151719.goee7eqti4xyhsqr@amd.com>
 <aHEwT4X0RcfZzHlt@google.com>
 <aHSgdEJpY/JF+a1f@yzhao56-desk>
 <aHUmcxuh0a6WfiVr@google.com>
 <aHWqkodwIDZZOtX8@yzhao56-desk>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aHWqkodwIDZZOtX8@yzhao56-desk>
X-ClientProxiedBy: SG2PR03CA0125.apcprd03.prod.outlook.com
 (2603:1096:4:91::29) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MW5PR11MB5788:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f4e8962-f006-417d-2bcb-08ddc5db8b4c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?4aUc8pSKPxRs/WG1hk3aqtbNrTHNQvGpt3Z56eJsAUGaHixAlq2/bpGybuSx?=
 =?us-ascii?Q?vpWBi5+jvCi89YatwONDQOIe/TBlufpuctHU2nhh0kMtzdzmN/JO2jtiORbt?=
 =?us-ascii?Q?DifsbZYcY2Z+eXXDJnNF1Ya1HXGoBhemuJ7+vmRgVyPWrlcTgfU1s1CpLHcz?=
 =?us-ascii?Q?9GloWiua0gwRlCXvdMXlteHTcpEfuJbqYnt2BLpPDRhUrg5YrOurSeTYV7VT?=
 =?us-ascii?Q?UvkHB4C9vLbm8EyYuINfNqiN1MVkdSYU9CZz5A8B73f5MHsSwyopZPJwfb10?=
 =?us-ascii?Q?J1QHzcy4D1OAk0DrxBkOv6oT9cKrMxNYKieYH7vNuUCj4DZztuL/2RCBDPwm?=
 =?us-ascii?Q?xdBQUf1Uh9zuZFGvZPq0N4ARV39IMwwH/GBi05lJmjfSd3KccMcbkKGtl2Kx?=
 =?us-ascii?Q?nw+76eXcR/7YjwFOpOPn/vpVhrcQvBbddMBMBAfdfbDfZEjn1iiQYYp1uYU+?=
 =?us-ascii?Q?BGDy8qxO/UlSPTT+7ORhN5Tp1p7LHoKA+XyNciCjxFDYJTBBaFqfuOd7p0+O?=
 =?us-ascii?Q?+yfFHcI84CvLYoIeLCbASd4DPrtB6E5s6YK3oHJs63aNeTcUuRvRMuSJB1CC?=
 =?us-ascii?Q?ukIkew881n29Oe9HplAcAaZaSayi4EuQWHB2GAJRwX3ZaGTBZ5F3KyRYY7nE?=
 =?us-ascii?Q?TV12ok173amy1S6fRsPwzDl8Ja1r88YYuKwIncHpn3kcU1rWHPy1F1aA4+/Y?=
 =?us-ascii?Q?3QW/DdmOr1DVdnzbkx4tGS5UZ6tMYHO92YY+EDj9la3Ktndj+kolfcXhNr54?=
 =?us-ascii?Q?Facds0LxtRy7WnaYp5GYAFe5c2+qce/vtvNE+Vi6BnE4N2hw9yp/1e8hiJNz?=
 =?us-ascii?Q?igFCfUSa6Fy+tO5M7q4oz/o3B51xlfIKpcDa0rmj6tpkQM7kU3XNT8JuKbAF?=
 =?us-ascii?Q?MLkbKP0C9uNMSTxx5L0olUpszg/jVvbVC3yhkQqO0riXuWDG6B5n8a7/XEqn?=
 =?us-ascii?Q?0y1/JjyFpqPS8UCBibiBYhCvurIm+ovZlQ1biiuUchAYpfT1ffGmHybwnA+x?=
 =?us-ascii?Q?KzoOV2mnVPB88Y/5OTC7V7EQ/dEtzIGlwBZVv1m0s/ZMLazahnzDZaJzVaVj?=
 =?us-ascii?Q?72wlYsV4hGdzDte0xdHjbis/KcdE1q1yR9Q2g+nBMSFBgOD4ECp8zCP17dTG?=
 =?us-ascii?Q?mWap87lKPk8bp6kU2brt5r4jb99F4/rVslelJzEtsysSTYLQ+4kC6A5XygPW?=
 =?us-ascii?Q?ZsbMxvltCA5V6jPRVWxx1g2vJWmy0oK1hoiZC21GksC0ynEX675IpwJ8SBdi?=
 =?us-ascii?Q?KGASiiRbk9GujSsoGxbJ1enZBFInWJsQ9zrUTfb3k6ZnJb7Y8GqH0WObW5/i?=
 =?us-ascii?Q?rxluJA1aYEqvFAxBtNUulCzwDHug4RI6Ff9D8QhVWBFNdXxcSl1tP5OMjBF9?=
 =?us-ascii?Q?5/iq8lEDyQWhqovv6E4n+duQplTw1S7O06iPk0ogBq+BvLMj6LyrqEEY0llw?=
 =?us-ascii?Q?hr0f+gb+F6q58UJpa+mkn88pUQIVrxFioXbr8tg88PobZzE+vr+tOw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8/BepKovyj/Wy9w4e/aOADq/K5RO8hc4Cghtgduk2qA3/EneOpnsnGcR+gi+?=
 =?us-ascii?Q?+uBgBHE0isUfrUrujP9z9Ur5gMNQSB1UUlMwi0LgU6OrvWI87JNy9y/FuLf4?=
 =?us-ascii?Q?WjwHqrIumUONoXvS16QcdWyzG7uwr/8F+Nm3OfbkRLH2KuuV2GTI0Si4ziOJ?=
 =?us-ascii?Q?l7wWelZ1ijsGDHFfYrv97I6ZkhjGVnFp+a/Yd2iU/V1pxVloqO4xi3ncPnk9?=
 =?us-ascii?Q?xWGZr3VmyKn53gGQJ03itLJDg7xYRJMucwW/TzmSyaZDnlDzy0J/+yCYsMx1?=
 =?us-ascii?Q?9m/DGWBdjd/ohox6Dev9MXYx5R7RsZr7l5e6tl0YuoQORREnmtOy9ayHYO0P?=
 =?us-ascii?Q?L82wMyMcjB8z/sIhnq9218OTgwBLgMtIdRvnBzYl/ZIxbhSX5VZVJkpSSAKT?=
 =?us-ascii?Q?v7GUxvenJqsMDTMK4NJUxnGmArtfrghF91Cq9dAhlqJ4Ai4CPjCNdcfHuOVa?=
 =?us-ascii?Q?Jr6iveF4cI6yb6CFN8SWgfw2fDAWjX8PvQgK6a+01dcaSnXCxgPdp4x8EDDz?=
 =?us-ascii?Q?sNHn5yxG15mTTPR12pjagKifx4HO5bMCBTIn/5kknGtHWqGG1fFO0TmFjPF8?=
 =?us-ascii?Q?MbLElFDsqqtXeC2ircQvDZiB9DUR56U/ATkIARLKcnvG7gPrhxRL1ieedd5E?=
 =?us-ascii?Q?/odOItBIFejOE2iZiNxmKN3QgYQl/+ZF9od0sG1UjGz72t0WdrbXBZK0yiDu?=
 =?us-ascii?Q?4na9CMAl7kxbr6IaI0WR8xGDoCui1Qcq/Gji0LwIKYbsW4vZVljRscVPsJV1?=
 =?us-ascii?Q?FJ0Z6Erj4dsBUHOoZ3OwXynya7gONkjAkQdN0/C424owEyruP1eLCgm9VD95?=
 =?us-ascii?Q?fG8Rjjvalah8nfjSSgUI42S+4aCt0AXlr0i41K1O+kg2TpryEycmPx7a3DKG?=
 =?us-ascii?Q?aj3cP3IL/fXUU1eRgLfghuEAezlGH+BuXXYWbCvmW+by9pP0RAZ6i6PqWxll?=
 =?us-ascii?Q?QxSWC5Ex/DyPV7Gu/bUxBzwlg3U+z4B0/4s7TkNDPyhOsqa2hWtKcU0HqM6k?=
 =?us-ascii?Q?bcZUuUeyohVXuC9yaqeoPvwXmd1KyZNHF9VlKM0+vq6HNPoeaYKReUCOMT4L?=
 =?us-ascii?Q?OIwY56tsyDXDgQGQxjKxkoOgoKrEpAuNTuzuDP9DJT7OMHYRNhKsdCKqxOlq?=
 =?us-ascii?Q?4YfmbIxa7HjrxCeiRetNqMsAyUtE6P4E3dce8D9gaCDBBABDZkNrb6GA/1QH?=
 =?us-ascii?Q?iURGXvAB511cKNqzggTu9DBbhQ8I5M8IuOc30VxFE47IMOESVtsayWwZWPTl?=
 =?us-ascii?Q?wvVIpSqxSeh741cOEwgIOHXRi0RG0ktQFICFRZJXNTUh7VTbRgvFJnQB7Jqv?=
 =?us-ascii?Q?n1aeE7qL+Oj3vj23cLJfIxEuxotkVH8RMd4/mQKA8zpazanorCSED3cX48KQ?=
 =?us-ascii?Q?TXvmriNtVyBQH+3P8Q7FnkIsNT3LINCEOFwNL8q4NuyGJdWm4k80qJKFkefo?=
 =?us-ascii?Q?i5jENozVlMVfGmgtH1v0/EvJT1G/h6fH1Fz0R6oFspRpfROBpoescuLfi0TV?=
 =?us-ascii?Q?052IHC9SCjZdNH05P2i1UzwIR3OJOfRvX9YFsrzHJQOWJ7W6N+xm5sCyOdAe?=
 =?us-ascii?Q?lfEQWB9K+5WeqQAB4Xn4oJ6+KdeT53uxKw/yhkJg?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f4e8962-f006-417d-2bcb-08ddc5db8b4c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2025 09:14:48.9085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iIPv45ULSzoAPeAqiQgMabp4QbZpoYn1G8c9dJfZQnKt6St5OoWScZwtRxoPdL7RWw9g6CO3xMSCeVIdRpMy3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5788
X-OriginatorOrg: intel.com

On Tue, Jul 15, 2025 at 09:10:42AM +0800, Yan Zhao wrote:
> On Mon, Jul 14, 2025 at 08:46:59AM -0700, Sean Christopherson wrote:
> > > > 	folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &is_prepared, &max_order);
> > > If max_order > 0 is returned, the next invocation of __kvm_gmem_populate() for
> > > GFN+1 will return is_prepared == true.
> > 
> > I don't see any reason to try and make the current code truly work with hugepages.
> > Unless I've misundertood where we stand, the correctness of hugepage support is
> Hmm. I thought your stand was to address the AB-BA lock issue which will be
> introduced by huge pages, so you moved the get_user_pages() from vendor code to
> the common code in guest_memfd :)
> 
> > going to depend heavily on the implementation for preparedness.  I.e. trying to
> > make this all work with per-folio granulartiy just isn't possible, no?
> Ah. I understand now. You mean the right implementation of __kvm_gmem_get_pfn()
> should return is_prepared at 4KB granularity rather than per-folio granularity.
> 
> So, huge pages still has dependency on the implementation for preparedness.
Looks with [3], is_prepared will not be checked in kvm_gmem_populate().

> Will you post code [1][2] to fix non-hugepages first? Or can I pull them to use
> as prerequisites for TDX huge page v2?
So, maybe I can use [1][2][3] as the base.

> [1] https://lore.kernel.org/all/aG_pLUlHdYIZ2luh@google.com/
> [2] https://lore.kernel.org/all/aHEwT4X0RcfZzHlt@google.com/
[3] https://lore.kernel.org/lkml/20250613005400.3694904-2-michael.roth@amd.com,

