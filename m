Return-Path: <kvm+bounces-70712-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mNrSHmffimlIOgAAu9opvQ
	(envelope-from <kvm+bounces-70712-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 08:33:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D2B96117F88
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 08:33:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DD5F3303C626
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 07:33:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C604D3358D6;
	Tue, 10 Feb 2026 07:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xbb3xznx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA1A1CAA65;
	Tue, 10 Feb 2026 07:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770708792; cv=fail; b=m90N/Wsn2igY80eI1UecR56Yy0XgAm7V9JznyNdP9WsSntKuAbGNzyPKTb7zBjHz/pa9MVAGhsg24rtAqk4p8aBLiPHxbFPvJqm/XcrPqdK5ldl7T6jTgRzeL5oRVcvMLitGATQGhvOo5eysLZxsbtuOGSo1kbgFiLzGRwXQWxY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770708792; c=relaxed/simple;
	bh=bZbVRXnGnBZiqL/L3/AEptF4kDsvb+TO+h1H7smVSBM=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Jo6CAcdoOy7iXBw7FaqrlYfB57KALYrjKC2bHUEpcOFivbLR2NTSDyQVzTOT5dBKt8q/yMLczb1zhA4DEXqHWV8vOjs522p4n3VH4ARInyg3CztQyTv487kOpO/pjTi0ZWJhQkS0FL6hoR5mIGvKOfv9s5eTbP6IqbRsnHRYTb4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Xbb3xznx; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770708791; x=1802244791;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=bZbVRXnGnBZiqL/L3/AEptF4kDsvb+TO+h1H7smVSBM=;
  b=Xbb3xznxTDq0WA75tICqDWdFinkuRPvNiC/1Rdc1esDb0ZqGsefldbSZ
   YS7uh40p5aeUhrlkA2dyX6HOATDpNw7eScZVHhE5BDAoRDlvzCM7coUtS
   4bLrQO9j7xEVtt8O8Xz1P/rh5kkGO9Rg5JTObl562SLhZ8+H8PHmT0d4T
   R0f1eZ5vj6rp+NjSmFr+zdW5hSfm95qfkXvbfr0OZTFUm3KyyePojOESH
   jRopoW/djJusUS8CYL6olCI7QF2TcKUv6khonZ1WKBgS0IF91wruHbDns
   OfBrFx/L8GkuD/7m4/5CKgkQ1bMkbIJG3ptX9W0LaPbuOC6eddlq241qu
   A==;
X-CSE-ConnectionGUID: TUptWlk3Tryt1pC7uDT1SA==
X-CSE-MsgGUID: qQcSzHeARc2msJfVcRmJcQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11696"; a="83268051"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="83268051"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 23:33:10 -0800
X-CSE-ConnectionGUID: c/keFRvWRNe3kg51b0tUXQ==
X-CSE-MsgGUID: UI+zqSZOTCykTvWs3aBRbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="249475677"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 23:33:10 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 9 Feb 2026 23:33:09 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 9 Feb 2026 23:33:09 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.18) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 9 Feb 2026 23:33:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lwM9JGNcfbRDoREstduzAl7eo1b+7xVxg6AESRFBNSdH6olPvq0V9a+L705eA4Lp5AuCfNPT+HECueYpvJmgf4dIeGmKnzYEGpM0DX9I9PGqFDwRFSR1XmQRa4XKKMEJ7SKls5uHwWkk5KE6nyVyZfy3KTdaWUkutyf+cPEaJvC6ecQ0O5oKm5kHEAk4ytgCzEnZjcMQEMghhThbsRUHKgGBkfY01Ae4ydugUbPzu+Ev6oGITfuMF+4gDViJn7Vn+8jHOQWibXLUFMY1oq0P0hwygc1QdIAyRzJwd9m2L3WjjYR8bD3I7rk9NDdyLU6fnXHBSzd9acM9G00tbVKLfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vJLzLLESMMMphjf/LwjR7P7uTxVyximt4i4+ohaHpFs=;
 b=h49REKomG6Jo/er6DKiv4wAcNOSf9zyI+Jd3cqgUiZeXznagU3O9chskYHOlr9Rn+7wlubGJLySDc71tyYwSbkZ7clR3xoIM0WTAWyLPjbXCcoTmn89DK0IxPWgiLbDyVVPgLc5ERQYN5XqJULRMErCG9q+qlF668vUxlcZQn4JDUKxYducHw23TUpkWa4S75f4NofJpVimLXlCuEI+mnqDHJ05Kr3XUV9KlY5rzvHCjoAc94O0eulxS8aGeB14+bS1NddHXzmdZlk6F/ZgTM41FJvANLvVDvtidiAcYbB2xrNVORhL7+u5Vc6Sdstd6fBnUDkia0n7oqQU49//bVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8468.namprd11.prod.outlook.com (2603:10b6:610:1ba::19)
 by CO1PR11MB4963.namprd11.prod.outlook.com (2603:10b6:303:91::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Tue, 10 Feb
 2026 07:33:07 +0000
Received: from CH3PR11MB8468.namprd11.prod.outlook.com
 ([fe80::8188:d688:bbca:2394]) by CH3PR11MB8468.namprd11.prod.outlook.com
 ([fe80::8188:d688:bbca:2394%5]) with mapi id 15.20.9587.017; Tue, 10 Feb 2026
 07:33:07 +0000
Date: Tue, 10 Feb 2026 15:32:52 +0800
From: kernel test robot <lkp@intel.com>
To: Colton Lewis <coltonlewis@google.com>, <kvm@vger.kernel.org>
CC: <oe-kbuild-all@lists.linux.dev>, Alexandru Elisei
	<alexandru.elisei@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, "Jonathan
 Corbet" <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, "Catalin
 Marinas" <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, "Mingwei
 Zhang" <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Mark
 Rutland <mark.rutland@arm.com>, Shuah Khan <skhan@linuxfoundation.org>,
	"Ganapatrao Kulkarni" <gankulkarni@os.amperecomputing.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<linux-perf-users@vger.kernel.org>, <linux-kselftest@vger.kernel.org>, Colton
 Lewis <coltonlewis@google.com>
Subject: Re: [PATCH v6 14/19] perf: arm_pmuv3: Handle IRQs for Partitioned
 PMU guest counters
Message-ID: <aYrfJCU9my4eiBsG@rli9-mobl>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260209221414.2169465-15-coltonlewis@google.com>
X-ClientProxiedBy: SG2PR04CA0165.apcprd04.prod.outlook.com (2603:1096:4::27)
 To CH3PR11MB8468.namprd11.prod.outlook.com (2603:10b6:610:1ba::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8468:EE_|CO1PR11MB4963:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d2360f9-7f0e-4e1d-6009-08de6876a203
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?z6Mv8zYa9TN2/EkOcnJ7/pSNxHerHdbVniiJ/fFz+ulUV7G0PG/m2aduox/f?=
 =?us-ascii?Q?7StQIeqdUHO4LXfV8NnVXVuh4cDnOHAR8qJamBIvQMxaNrcmoN3TFQM+fn9z?=
 =?us-ascii?Q?3kA4UkB0rzTqxF6b56zX23b72U6lYY61nCp+0w+5PhGZQwvbiHCg5MXKdhp2?=
 =?us-ascii?Q?F6VSaHKwUWIjKDEjrDLGHMoQ7ykG83PnEcm/X5KbXIhpvURMANBgS4ydzmZW?=
 =?us-ascii?Q?fmQ3enPwnMIpZomSktyC5pjrelhWmqJrG+MIrKhUI37Xw2djzG5DhbwODWQc?=
 =?us-ascii?Q?SvVjHcd+InTSHdjKsCJMJW/yGIwWGTV3Zk/pE7G15mBqsgvwPxXoE9O+gUXW?=
 =?us-ascii?Q?elDsIPp/WwlW4wgk2g+xQPG6H3cp3mA5m1GO4mU4JfQJ/oqTv3VGWm6G1lK2?=
 =?us-ascii?Q?KpaDONlfKyKi64/IC7sxHhyp7BaBmV7lquP9E4sZ9pgWDuFn/bRxBEgiu167?=
 =?us-ascii?Q?lKF45v9g4opl+++vSCsy3ifKLGYKY+cIcuMh8+oG1/8+AHa7N6XjrEDpt/0x?=
 =?us-ascii?Q?FFC57Rgr5UPq1OmJTo1eycAYsR5ldAFGsjImzfZ0fLFhE6injaC3Eqlzel4G?=
 =?us-ascii?Q?MKPmYreVhWoh38LZunpaSthSedJH8O4hxxWM7ynD/rV56Ue7NiGM67/WADJ0?=
 =?us-ascii?Q?sYxrQZ1O3inPLB9dEC7eb6WB4aKyvRUes25d5OLzj1e1ii7uXeVGpRT/NJgP?=
 =?us-ascii?Q?zAS35KM3inwqsA7VihgTe6QKzgEZPhIsu/3rsH2X6mButhWqBDxaDHFbbD/G?=
 =?us-ascii?Q?KwzykOm7N0imNRsInvjLv+OrD5YBmj3Bu4in3dq8zpGGTyf3r23A1rhAmxSj?=
 =?us-ascii?Q?Ow9Q4QYByIOvkDoJqaQvvIzf9g73lOmhix6VXj55BN34iVeFvtLhEnFU3fIQ?=
 =?us-ascii?Q?uFNyMyTiY8F2M6n6cW5bheM5ynBdKgYCDhJrppmULgfOlaprkrFQKrAt6VXQ?=
 =?us-ascii?Q?9+xufHoFNKPSG0W6RtTz2/CMcpjsKxQ1aHZjXclqBA4IK88utHdE6bkm+yje?=
 =?us-ascii?Q?KR57KbAefeCd/uCi+c3YAqPh2ubGx5S8c2EUkcVq/m2EX6F2Fd8wlFxAXlFH?=
 =?us-ascii?Q?1WCZzQucjfLeQ7zIwrE7kv+/lYPAgivGt5daSmeExeC1Xc1+Zpw1QuObS8Xe?=
 =?us-ascii?Q?BtF8u8IdGO49yKuXW0wPF/BvK6A7fNqUSsn5RnRlC93QrgvNm1+uunNav5pO?=
 =?us-ascii?Q?hpBD/Kf2Q1Rg1VG/XBcaXO/DscJI5qT0G+4zvkUDJGSx2J8D6k+V80dOZcND?=
 =?us-ascii?Q?voRueWtAAiHNRoBM4ulNVwJIndQkYdjUzcteU3Qh+rMxRQcDbimQ/HoMRoQx?=
 =?us-ascii?Q?ZQ+o6S7vdUMFTkwbJixv5Z1tHEj4Rm8ng7tRaudxlY0UgJHSDxsWOxNd6nAO?=
 =?us-ascii?Q?wVKiLY80nXtFF+zjOLaUPLJfKU29LJGlBLVSDQoeiT/avJLgzDdM2FRrm61o?=
 =?us-ascii?Q?yoG1uCRnCg8d5QNI3MswfuBG+lbzP1/XdyLKxjvdBTNwLDaEvbq2H2ATxDm8?=
 =?us-ascii?Q?mBUZ3PlpoVfrd3sKaAlm8klXHrqQ41g6Jp7j89uvfrJHrHymXAXyRA4zySCC?=
 =?us-ascii?Q?NZ/pfhupWoc7jsMnaBZqu9jagZxQ/jwsC401cvgP?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8468.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aqXIrQ0g2kjsxsLRREEe/uk9rmWYwCyzldtmOwkovZlb84rajGCE4KyWD89P?=
 =?us-ascii?Q?PgkOP0wLFy958sqfIsjtnN0P2Jb1JuFlJp1iD1Eic+LtDrtP7/wsoBBUD9oT?=
 =?us-ascii?Q?Jc48hSTaT52flkO4+fpnfpH559AFX/k4zAXF6cEBbVaUnOuSdpBa9Qw/zbWP?=
 =?us-ascii?Q?fgI7sIk1pMPOmNfH/f1q22cwTJJdMRMFCmS9ILLepWf89xOLWH+BGW7S1Bek?=
 =?us-ascii?Q?+Wmz7Rb0p0jQh490GS5m8KhvrOj+QvI/sh5kzRTIofWNQ30RR9Z7shTLHPnj?=
 =?us-ascii?Q?JV8dmf+ycP4kB1/0ASqHPwpFqd3ZNtj4mYCn1RdAaYSjmhtHGT5nbgG4Y2Ws?=
 =?us-ascii?Q?48JVsQHDtg5/cWlE7QPKQ0osWO1ehLxo46FLy5HSaD8L0Kx76sD+xSehQVFM?=
 =?us-ascii?Q?h/roLiIGc+Of3XLiBoTzmlbZ+OX+CRwdhQksJQovfOdTy2XrwRBF3WQcYFqp?=
 =?us-ascii?Q?nkUkcE5+KIDddPdwo6dO/vhCyIN7IDAKvxwUQSQMFB531QUQ/2wT0kavam7E?=
 =?us-ascii?Q?Gpw50Zl8jZv5QIHXVCGeOMDEKadVydN0/ihVlcBeWLp3S5IDsf5XYuAqnGnc?=
 =?us-ascii?Q?L1VaJjuxVmkovx+t1Iqxtez9I3Il/IOP+WQ42lQJ5CLWUeJMh5TWzwKxjmV0?=
 =?us-ascii?Q?k/r4jykPsY8rtQ9dPljS6tOfHnf5dHcWAEZXuF7iNuv6tNcfP2oY5XmDeEBu?=
 =?us-ascii?Q?4AKWP9V2XUzXDO8XqtGeosiBC+lYPizvGVyQMYqK2MlFsvnAYPnNJFE81ZuP?=
 =?us-ascii?Q?OEPPfEAzDkAI3Ev9dUqVVzEl/1HOK4aCgab8XHfvTt7gg+tF4J6AP6kTd6Ct?=
 =?us-ascii?Q?3NR6vUcsdC63AenL6Z0mxE5/OHylnjiGYZ4jPBYfZAZjTlVNBHo0XihIzo7a?=
 =?us-ascii?Q?tKUqduIjiwbGWtabDDrxAq0Wl+gm3om56ZkfULUQPs4ECRY3sQZECS0o+n46?=
 =?us-ascii?Q?+GFJPCaAPxrDTxwYuu2a6zI6JJ3gSw5EMobULMa3Cgf+zvG1wqnQ2EV7v1gB?=
 =?us-ascii?Q?Ad67Xakizu3+zaesPa2+8kWhQWovq2gPm2jo8cEkPIr2lBBEep+MkPQVyZSo?=
 =?us-ascii?Q?mgxdSsETUAjPp7I4Is7/Gq042uFYZwsEgI8YZpBb8PlmCad/1/fvks26SO9B?=
 =?us-ascii?Q?zddMEiKOKG2ZHH//YL14WpZCQaUrSK2MGgDt6pCNbo7bkoAhCS9ZRdbvlJ48?=
 =?us-ascii?Q?wwsOX9HPU9Qum99IGAz5raeanu0T2pBqMSrkaMqNZ2DpcOVeSiGGxMvLtzt9?=
 =?us-ascii?Q?StwaOz+2rgDIQeJRv3GwAj4imS+L26HTFhIvvKHFxrvCid8zmELOWsqZwgZo?=
 =?us-ascii?Q?2E8Q1yHcXYLXVEoQ2ciiH7DNXP/zWjB0XC3ce89a+/fnxUot28gMNrrAn5Xb?=
 =?us-ascii?Q?8Tz5zLkMiA+jndJEMPtn78ZGPQ6ae1jTyHoYbzIHs2vRxQfzVbsF5EhebgjS?=
 =?us-ascii?Q?Uqu5K8bQ+s9fxavWGky4DpryoW7wvSFn8PZ+rjiwzgwyNwY7PphzhRHNZIQT?=
 =?us-ascii?Q?rpV3XqDGZiE9LhWtq3/L69cR5bhnt58VNnXPkD3lRDGcvedXoC2w6enZV7dl?=
 =?us-ascii?Q?xYFPcqieyw2bmO8HbkjSTaOjFrUdkiGfrPdtPc5NUbCwsVFa9GI/D9PAjCjX?=
 =?us-ascii?Q?ohpTlLeRoeFESm2fLOU8h3GDcQ52jP4KKo/V97FsFpXGWWeqsN1uhdgKWXeW?=
 =?us-ascii?Q?pxTKEw+Tqv/sjSJ3VAyRzSxuoD0/09En1Ck/DlDNfThZz8i2zyHR6OaP97w0?=
 =?us-ascii?Q?6zgYtNiisg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d2360f9-7f0e-4e1d-6009-08de6876a203
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8468.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 07:33:07.0554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2SPymFNgKpvUQNoGGoIOOIb5Hx0MI4/VqVT82mpxSkH7V+QXQHDBZvhWOGFw1JlW3XC+TB5s9yHSnp5ooYVIyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4963
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70712-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[25];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,01.org:url,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lkp@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: D2B96117F88
X-Rspamd-Action: no action

Hi Colton,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 63804fed149a6750ffd28610c5c1c98cce6bd377]

url:    https://github.com/intel-lab-lkp/linux/commits/Colton-Lewis/arm64-cpufeature-Add-cpucap-for-HPMN0/20260210-064939
base:   63804fed149a6750ffd28610c5c1c98cce6bd377
patch link:    https://lore.kernel.org/r/20260209221414.2169465-15-coltonlewis%40google.com
patch subject: [PATCH v6 14/19] perf: arm_pmuv3: Handle IRQs for Partitioned PMU guest counters
config: arm64-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260210/202602100634.QKTI6Wc4-lkp@intel.com/config)
compiler: aarch64-linux-gnu-gcc (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260210/202602100634.QKTI6Wc4-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/r/202602100634.QKTI6Wc4-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from ./arch/arm64/include/asm/kvm_host.h:38,
                    from ./include/linux/kvm_host.h:45,
                    from arch/arm64/kernel/asm-offsets.c:16:
>> ./include/kvm/arm_pmu.h:310:52: warning: 'struct arm_pmu' declared inside parameter list will not be visible outside of this definition or declaration
     310 | static inline void kvm_pmu_handle_guest_irq(struct arm_pmu *pmu, u64 pmovsr) {}
         |                                                    ^~~~~~~
   ./include/kvm/arm_pmu.h:281:12: warning: 'kvm_vcpu_read_pmuserenr' defined but not used [-Wunused-function]
     281 | static u64 kvm_vcpu_read_pmuserenr(struct kvm_vcpu *vcpu)
         |            ^~~~~~~~~~~~~~~~~~~~~~~


vim +310 ./include/kvm/arm_pmu.h

baec257585c39b Colton Lewis 2026-02-09  307  
baec257585c39b Colton Lewis 2026-02-09  308  static inline void kvm_pmu_host_counters_enable(void) {}
baec257585c39b Colton Lewis 2026-02-09  309  static inline void kvm_pmu_host_counters_disable(void) {}
ad5f1148c818bf Colton Lewis 2026-02-09 @310  static inline void kvm_pmu_handle_guest_irq(struct arm_pmu *pmu, u64 pmovsr) {}
baec257585c39b Colton Lewis 2026-02-09  311  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


