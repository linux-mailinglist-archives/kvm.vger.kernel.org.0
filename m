Return-Path: <kvm+bounces-67993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5488AD1BC6D
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 01:07:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4E9F930286D0
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 00:07:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A42DA288A2;
	Wed, 14 Jan 2026 00:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lN/W0kig"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B92A55;
	Wed, 14 Jan 2026 00:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768349222; cv=fail; b=IFxWXX6O+lh9SdmwoHwRfwMpi0Ww4cYzljNXloH6I3TB/E0mF1e5dAJ/8y9OfkRm18YGowN1or6UX3J87AkAIfD6UOEQ65mO04pl4LijbmWsMu5MC1pyKGCILsab9Tf+0j+db2/j7mYgkq2SMWfIZqFS38n74Bsm6HrnNMp2q5Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768349222; c=relaxed/simple;
	bh=JkWXsbv2gcCa6jI7AFgqR9WUeDipXfRpbFtG0gBYs/E=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lKlBhSZjV3SlyL06tn2/Ywc5koCyntGhd7I/JOpgkao9jO3PAqC+fuV67ZxOpqZClgiyM/1g6jFonDDYKRRGzWmAyTpC0Ec8vUl9jMYmVxnEmsPQcOkkdzK0qLjGbKQ8hSVzsGN9/HpzZ3YvvBzZ3Ta4hrJ56iag75ZQgEsQ0PE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lN/W0kig; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768349221; x=1799885221;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=JkWXsbv2gcCa6jI7AFgqR9WUeDipXfRpbFtG0gBYs/E=;
  b=lN/W0kiguFRAg5fdhhpEZP8nwl4T9xSjFiSGHm3Yh3Gf9D26+si8D9Rl
   q2OTn006t+Lqqk6dPV3rqNQvt5uOgbSA0e4gub2uuXK6QYo/bl+ZzVHyI
   SNay8EAZFgDd6ZntXCmnDO0uNzY1qAeWlH/ficN8cEIoLbGqrA4SjLXnB
   SqvTSpEkxgMBcw49lX2MSqUofuLLCI6c97LthyZ3I3kjTgA76JJoU5qtc
   m6vQNewEr/RHynhrdVAL+aHhQDGD9HtXmWqXkYFEGBWvK7XS+Q0uHQOvd
   hIBTf7YF24I5j3HFwT+1cB5xKg4mzB0tkNDFckqi+M58ydCQvM98ZhNxz
   Q==;
X-CSE-ConnectionGUID: 3W5iiQRSTxSkis/tmZ2amg==
X-CSE-MsgGUID: VbMX8PZZSy2GiySztv11VQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11670"; a="87227269"
X-IronPort-AV: E=Sophos;i="6.21,224,1763452800"; 
   d="scan'208";a="87227269"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2026 16:07:00 -0800
X-CSE-ConnectionGUID: IuTPdHbzSTC6lV+KaAuo3g==
X-CSE-MsgGUID: uUkxo1DwTyGVIO/iuooCpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,224,1763452800"; 
   d="scan'208";a="209577223"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2026 16:07:00 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 13 Jan 2026 16:06:59 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 13 Jan 2026 16:06:59 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.46) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 13 Jan 2026 16:06:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iw7vS+Z+Em+xQ/9Ck4tJdV/h4QsJchubV/veXaHKDrLVXUDk831gRdW+JS1DCESRbakrhT9SwnC01ag1aKuP07V1AhDuqRiY4gj1h6LhBffWe0zEaChoY3KleFsvhEiQREDAeETUsjWBCBKYCJRj0iXkcO+XNntZrFZ1RuoZG0VhIngUeako+hgvl0FuAE5Uhw7g8Fm68r5HSeBWB15fAsiJcCD2l9NxEN9dgJgimWGltb5hDLh39u+9Kjayf5ICzRCCWKq0ZIN9HzD7UXtYu1HJlrcB3/Pupku7YN9Kuk4ZhFb1pe08nxFZyEMvFzvNC6SnJMA1CrRNCqkgabBFvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r5fe2MtElShVFUU0Jb3JEeEU7AUhj8clk+Zk0u3+Vis=;
 b=bdHZda7fJOIFf0681P6tSyqNpAlcGRf//CWcxRIeh9nw2Fe4dpugO0BSJLiW+FBAm/3VD20O4nDHG9MFquskOF9xaGRoBi7DeV15eqYoUHPkn2QLoT7rbZhHqf8zsoVoHH1hdPcWw+cRTg9QR7PlT/yG+2c80KPB/eMA0iKEn9lRusBcB1EMFdgQu1zpxCgCwHMMDFffkq9apI3UBd3zyYLUvIFlYzLyHrGV0UWMdHAyRlgngPaLBl9+S0jlqnETuXEvHZpKGrrHyVVdav4QSDoGtQe416nWVM5qAraxcCmhnVyCJfJbeV1RtMcLom3QqHZbjF/JRWw8shb5cEWSmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Wed, 14 Jan
 2026 00:06:48 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9520.005; Wed, 14 Jan 2026
 00:06:48 +0000
Date: Wed, 14 Jan 2026 08:04:38 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Michael Roth <michael.roth@amd.com>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <vbabka@suse.cz>, <ashish.kalra@amd.com>,
	<liam.merwick@oracle.com>, <david@redhat.com>, <vannapurve@google.com>,
	<ackerleytng@google.com>, <aik@amd.com>, <ira.weiny@intel.com>,
	<pankaj.gupta@amd.com>, Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v3 6/6] KVM: guest_memfd: GUP source pages prior to
 populating guest memory
Message-ID: <aWbdlg/VKvjiKiaF@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260108214622.1084057-1-michael.roth@amd.com>
 <20260108214622.1084057-7-michael.roth@amd.com>
 <aWabORpkzEJygYNQ@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aWabORpkzEJygYNQ@google.com>
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
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH8PR11MB6780:EE_
X-MS-Office365-Filtering-Correlation-Id: b19beed1-6a05-47af-a86d-08de5300cfd8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?sY463vfcPNlyd5wyNo/2W8cxz7zf2Z0laiCdCIaArNJo99d9Jh1/YzWBPpP2?=
 =?us-ascii?Q?vwBnoCAaVbXAJmmIC0tOIXP6wa3mRoOmhL1RGqF6L3001GqXPdcBwSt2NrJ5?=
 =?us-ascii?Q?gltVyp6amvTpDb8cSv9RGWQbmCBQ6q9Bm00msxujaJIyzQqsnr2MdFbpMN/G?=
 =?us-ascii?Q?/Qm0Zl8eGyCzox7RzOEiE0+cT5SRc4yPiFyuapc6540h+ihM7LaqSJcrteBr?=
 =?us-ascii?Q?wTVbTENfHvqq3eN1hC+kQo5nYH8NHMAlrvlcmG2tDQA2vR//z08jgJNM6LHa?=
 =?us-ascii?Q?S/YMib7gxF996cp1Jzj+hQttoa1zno7eVjtsGqoHumzriA27MZcwEt1Pqt+K?=
 =?us-ascii?Q?0r9RyQwXW8+FyybFJkVWZ2fDByOqjP3BJldAg3YlMnlWUyY/EYqdv0HpTxOB?=
 =?us-ascii?Q?0kQseZq8VS1HXVW1Z9HWwcc3Q7ZZMj8rF1ek39aAINBtwr18khisvHkMOKc6?=
 =?us-ascii?Q?vojTFb4ITQOMgMtPh324nKhT+M1iJqMOmxwAw+PtbsLD9bGoJFBSY3Nn2DJn?=
 =?us-ascii?Q?ycm5eTRIvLjuXONTYiE2dLDL2nD3yhRtedXUkYSIcwkzogTn2nr+2lsMfjpj?=
 =?us-ascii?Q?QgWFHZYf8gC2cdAnN7AOfHlOq/DU6A41d4vx3XUPvLQXRZAkaGmPsGqXgF+a?=
 =?us-ascii?Q?GzgppVhkytw+D5KdfU1gv+Z546vv4o+bcyNkLjKMKV6yKUvbO5hjefafwusH?=
 =?us-ascii?Q?r/hTUnFIn4Nv+0A78H8SBz4UrQ7VJXdjLmNo0B5WgSzsIA3Yq6ajpxHw3MVg?=
 =?us-ascii?Q?brG+gKqcYotwpMFkVV2U8KAkIYmta95SMP3PhuMmAp/YmLGEPDSR6QzjWjkb?=
 =?us-ascii?Q?GIfH5tsO0gYfnEtRSOtvgnEMiFEVb/eOl8CoDP/3Whnt+Eguftg7q1HfgFse?=
 =?us-ascii?Q?k9BkG+GRYJ4tH/DQJhFjuZBGIQhUcIhSgAQiANWrJWhojldgaW/3LVVzQFiJ?=
 =?us-ascii?Q?ipFquvd7FJ9RPsMCjo5pT59oFCHnnPGMf/zaaDFGQlm2ubY2RcFc73zxhmnG?=
 =?us-ascii?Q?X2S7q9O9JldRtdNct1Yo7jLN+roOSwWLRwjChLjbTTYuR58FVSf6fy6vuh6P?=
 =?us-ascii?Q?cbUlojaCSvYzTcJGBE1agZpYUk9EDUIXdPae7Nj0z/x2kJHdrolcYlOMIkX1?=
 =?us-ascii?Q?F7mJQrt2UT0DFpZFHCwHVqGviFpPVwS33DezNlHGUT4aauRrrhEbQrCCjp6e?=
 =?us-ascii?Q?kB2iyMtIsZDQwO5Td2dARbZdKbWXPzSn2UXMgNV/svv+DS+oNKhLMYewaFsB?=
 =?us-ascii?Q?ZqosKk128KSXvKs03BIPVH9mQu1tSnJYjzYZYxurqBy0SLZAgmUgMMg+fltc?=
 =?us-ascii?Q?/LE9G6yj8JW6Kvu1MxVjCIXvvoEhAtGFeDjFEa0idpz/E6NI8+Z0rSNElcbN?=
 =?us-ascii?Q?ORuhMUj0MWiA7uWegIbVkjUtn2s+5DDkdmrMHAt2FPGreagxzW1xfRoVbH5L?=
 =?us-ascii?Q?osKOv+INrRcYXRAJ2gc+lbUrPUv3vIIB?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?235UkLlQy98XUiNt/F+KJ7JQ2W/ta9ILAUFhNrepo63hrZi7n7sAb2l110ff?=
 =?us-ascii?Q?dbjNJSnK1jzMnzToJ7D+7m1FdzJE0HzCnP6VqY1oDzuVSfR5imRrIakoenCk?=
 =?us-ascii?Q?iJ75qLJcfIKWIM1kwOmiwAoMveRW+ntg7Thk4NbTnOXmM69b2WL5QDtk6ABy?=
 =?us-ascii?Q?RJjMU9gLEFl6kY+DAyz9qLvm5ec3M/oDSdg9fxBtr5dxkqgs5ufwS687yWaZ?=
 =?us-ascii?Q?8eAWcwWmDAfMAIOcT289Zc1l9BldKeWs4g5Uv0Qc2JexHQXUHFN0wUiaW3pg?=
 =?us-ascii?Q?wgYNLLI9lhzROiHp5P3M4WE64jdRZldc/XYVKyDbuQYfzy6NSjx+3ptf5MBT?=
 =?us-ascii?Q?qf8bjtilFnu5U5QnsBMsaD8bTpHzczgJZdC+WSPc+OVXQNLuEZVoGJ8hr+tz?=
 =?us-ascii?Q?F4JoduOs2dHU3fU2i3MRDhH3LSsxzLZFQI6/o/I3a8Qz4wfBEhd1LbwLe47e?=
 =?us-ascii?Q?5CsjlVtdp9D3RuxLECoouSI6CMFh61kSTvSmHAAOsbCeLPQW3XIYMULRNLCe?=
 =?us-ascii?Q?tznx+Bl87Pq732Rjdmt8fCPI6pHuYmbVdKlQSo/h2IG5POVgm9Ju0HLZVvgW?=
 =?us-ascii?Q?sKMhIklLglHaDflfZfm422MOAnd98gvXAGmq6ieS9Juliqyb4OBwQgy8uyTK?=
 =?us-ascii?Q?YjqSxofTJRIN+5ZKAaZDIoJ7tJVSuRHpIXpK+G8QdTlt642T3pA6/0gEesUB?=
 =?us-ascii?Q?N7Yp4s848LPmyBadnCcFabnju3jT8Gn9oKOYiZgYxJ6k4BWhYSke7a1m4NA8?=
 =?us-ascii?Q?pZzwae+0l8v4qFaVBLiAI74Ojsmu7r7oYNRqxv1G5+mlQPm+cj8BCDSnrbYT?=
 =?us-ascii?Q?1zr1tZkjFiBRIDz0MgObLUof9XIJEqbZX6r2RP6H9Bb6lKxxKNkvlUD9PxiA?=
 =?us-ascii?Q?BTSHY52GoXegPCPiIjj2gI7KjODjJPA/pV5ntRa/mf1la7ufJN1jjzkd5Xr+?=
 =?us-ascii?Q?wH4No+qmV6MxetULc6tBQw/ay5slE4bI+DEGKJeIkvMCTh4WwzZRB3UaesxB?=
 =?us-ascii?Q?/Io9i8EUNjAD51hFLC15oqhTjKuFyPouQQ9IsM+UPPiq00Dq0qAJEbvakMuc?=
 =?us-ascii?Q?JTkGEdPzPOOnsrgetcIxZ7bCE1iiHNFO4QhlpW5D+yjmvwOpoEI/LvvCiJtp?=
 =?us-ascii?Q?gC12e1mIoIE7fRJ52Y2LwosLX+Bpbpjl1A2XCQSDBOwDVCICD1yLxOtO3HZA?=
 =?us-ascii?Q?w99Ui2tEk8Lb+SPYIuJ03XXbNgRwWg2MFFltZsSeo+aXUbNcBNkM21hsPN5c?=
 =?us-ascii?Q?FxZB2VpJp9oa+yd+SNbv636JJGsyclAvuTeXq+F9bDfqsU9yk4j/GK8lRjyx?=
 =?us-ascii?Q?j3StY1BXPdo42FKAZBUbSKQaPVSxht3MfIkeXjK5Boi6h0XsIEgtiaBwfiI1?=
 =?us-ascii?Q?kx019SCpeZS1HaRftog9TXvcaY/v2F3bM1CSuOEFkh+0QHBHLnvy7m1Os5NV?=
 =?us-ascii?Q?0eJ4QRKOze32dZxzjdVGlBcYzsyUtun6DduahrDnmk5uGXsfT6AJ+cS1HCXa?=
 =?us-ascii?Q?86FWvm/rRXieYjsKgtk9XxNi/O3OAhqzomMbwru6La59ikbSHmfBHkslaTVv?=
 =?us-ascii?Q?xUWFuQZ+Lmnw7mB9ZfDMF7JPR9Y5FewjqIjCZv19OEg4b2W451aD60pRyyRP?=
 =?us-ascii?Q?HX2sHAAMCZnMgdqZUtta+zP9kfsh+R45wk81FnNTSm+Hkh3J1OR9NEGa3Mjp?=
 =?us-ascii?Q?IiOWGJWggCqqevo1dkA2X4t6pSiOKrt4BwQ7fpmjs3uKLgmX0WPaBWob5Dw+?=
 =?us-ascii?Q?4+esBNXi+Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b19beed1-6a05-47af-a86d-08de5300cfd8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 00:06:48.6799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IDy0C5b/ws8uhFwA0yWlBNuP+slhCMB56fowZRNB4S7Bd4GZWjbKVnplkHKaUJLQrAjeI/L911OIeMh3lBqltQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6780
X-OriginatorOrg: intel.com

On Tue, Jan 13, 2026 at 11:21:29AM -0800, Sean Christopherson wrote:
> On Thu, Jan 08, 2026, Michael Roth wrote:
> > @@ -842,47 +881,38 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> >  	if (!file)
> >  		return -EFAULT;
> >  
> > -	filemap_invalidate_lock(file->f_mapping);
> > -
> >  	npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
> >  	for (i = 0; i < npages; i++) {
> > -		struct folio *folio;
> > -		gfn_t gfn = start_gfn + i;
> > -		pgoff_t index = kvm_gmem_get_index(slot, gfn);
> > -		kvm_pfn_t pfn;
> > +		struct page *src_page = NULL;
> > +		void __user *p;
> >  
> >  		if (signal_pending(current)) {
> >  			ret = -EINTR;
> >  			break;
> >  		}
> >  
> > -		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, NULL);
> > -		if (IS_ERR(folio)) {
> > -			ret = PTR_ERR(folio);
> > -			break;
> > -		}
> > +		p = src ? src + i * PAGE_SIZE : NULL;
> >  
> > -		folio_unlock(folio);
> > +		if (p) {
> 
> Computing 'p' when src==NULL is unnecessary and makes it hard to see that gup()
> is done if and only if src!=NULL.
> 
> Anyone object to this fixup?
LGTM. I also like this change :)

> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 18ae59b92257..66afab8f08a3 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -884,17 +884,16 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>         npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
>         for (i = 0; i < npages; i++) {
>                 struct page *src_page = NULL;
> -               void __user *p;
>  
>                 if (signal_pending(current)) {
>                         ret = -EINTR;
>                         break;
>                 }
>  
> -               p = src ? src + i * PAGE_SIZE : NULL;
> +               if (src) {
> +                       unsigned long uaddr = (unsigned long)src + i * PAGE_SIZE;
>  
> -               if (p) {
> -                       ret = get_user_pages_fast((unsigned long)p, 1, 0, &src_page);
> +                       ret = get_user_pages_fast(uaddr, 1, 0, &src_page);
>                         if (ret < 0)
>                                 break;
>                         if (ret != 1) {
> 
> To end up with:
> 
> 		struct page *src_page = NULL;
> 
> 		if (signal_pending(current)) {
> 			ret = -EINTR;
> 			break;
> 		}
> 
> 		if (src) {
> 			unsigned long uaddr = (unsigned long)src + i * PAGE_SIZE;
> 
> 			ret = get_user_pages_fast(uaddr, 1, 0, &src_page);
> 			if (ret < 0)
> 				break;
> 			if (ret != 1) {
> 				ret = -ENOMEM;
> 				break;
> 			}
> 		}
> 
> 		...

