Return-Path: <kvm+bounces-69341-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YKpMA1kEemlE1gEAu9opvQ
	(envelope-from <kvm+bounces-69341-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 13:43:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AF73A164C
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 13:43:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 696C6300D631
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 12:43:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 093FB350298;
	Wed, 28 Jan 2026 12:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I2ZbZmBU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95CC3451CE;
	Wed, 28 Jan 2026 12:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769604180; cv=fail; b=fXHhPu2WmXmIsqoLQVtUSZWrzfQeYqAmHgGbPwoLn6D1Ggag7MP7e3UGD46nba+KXWjBGgLGa5PbXTW9mCFj6wABW6lkY+9UvGKv21pncwqqcX9Gpp2lABuX56zMTAfEUk3oxqGYJWeyssSUA3VU+CX65Utwa6brYVMOrmIo91k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769604180; c=relaxed/simple;
	bh=uoUPexcG2/MvSspMt6LUEoSVhmWkt1oidGkka+3r1aA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=aB/69jSPeP1UEtthj+eh4m7jgWflHRj8Yn58DQKeY1RGjhwriNWyP0fZPfvFv/NZCH3iUf+KriG7VniQVvRI8IFcSSydEp8yJuh06czkWhDVlYE4Qlttdc03AqHtaX3XR5Uk842jmDVLArFZN3i4reyiAjoTXkAyBFOYeR6hekk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I2ZbZmBU; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769604179; x=1801140179;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=uoUPexcG2/MvSspMt6LUEoSVhmWkt1oidGkka+3r1aA=;
  b=I2ZbZmBUppDAQQ3wA69oC0Es43CC5R5fqoy1PDvrt8nj8LppV/DzYBcY
   IukBD69ErC5LCLwbdCinERV6sm+3f7Vmonawc7uo4FCit78FdFGf5JXQc
   KHDYoD1lmvAX7ZExnIUO/pI/bscCS7/ZyL/WmT0/abaAxudfFSJ10ajZe
   2o6azC2ANvMvnxudmjeklaO8bQulfEgbyObvOGjUPKuHDoiHA7a1sD0IS
   V7ocn5wNCNSPFHKgU9f5kpGUHRVfHmL9ZH7RYDyfAWG3DsQyNvEN+D8oF
   zh29R5sQpWrcbpaGpodpe1N5wfKpGHvit8cH3DaevMX+f7h2d7gvQvRAG
   g==;
X-CSE-ConnectionGUID: xaFM65RSQCiDeHdHfYR8kA==
X-CSE-MsgGUID: 8yAuFBBzT2qiXVJbVhdlmg==
X-IronPort-AV: E=McAfee;i="6800,10657,11684"; a="70978400"
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="70978400"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 04:42:59 -0800
X-CSE-ConnectionGUID: jrIzrzQ9SVue7rjpKCTHUQ==
X-CSE-MsgGUID: /w/w29dASOmUsLshWtOcRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="208495656"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 04:42:57 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 28 Jan 2026 04:42:56 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 28 Jan 2026 04:42:56 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.16) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 28 Jan 2026 04:42:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PvaHgzWwIgSyJ1uvTQbvcDx2nxqF5a0h/S1FD7+bQ3IKLlXtCto+189MvR9lc3ynohh38Fb8vOkxDH399GOIkBtvplB61/rOoaHHHyzCuM+pHfqqFE3GPBcf+GXWQG0WBADIYZ5buKwmtoD0RFosCSFcEhlmeK7EnbX6HDyT3MpHjpaKanfRf2jlnYPHTExX8Q3L1GfDT11FCKbL4Sdh+id6Km3zrBMQ55Z6YYmTF5pPjtvYJTLDfrPcWnfP9WGCLvG0aXlND8m3s8LJEDh7VA/7uwAGkzEt5LxWj+0Cy8xiS9n/Vyu5Z6eXW8kraTGLlMFOoA92/kIHplSC40A/Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zTn9Xe1dYJmgRE9oA77TUbPpyU1uiE5QXyyhAnxiVCI=;
 b=yxXd5rrtxC4mIZ0mC4dhj3AeQakulV4jGGKhmurkwcU8PC5DQAw3/JEbjngmEyEkKnoT1zDGI1YOyu4aiW3M8bATd1Qm+EUVjghkorx2SdKQnxBFYAChM+jZ9TzqUfj5P7IMuYhGxIFc9/ce+lvkyvyJZZb1qPLYnvJbrQWTBss7R7czatm47AMmM8AHkFKKHE/9lFIVYz/tocb8LYvI2grEE4dCY4TSSFPFFo09bZhsmdkMqH9B8Zv9UQLjeDIZMckQBmA12mA3g8un6PLHRf+aQaNaOZ5KkplPZCkWDk54PjcT+W0K6VREAvOmu9cCuGfupW3Bdc6ZgJZD2ByVng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA3PR11MB9350.namprd11.prod.outlook.com (2603:10b6:208:574::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 12:42:54 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9542.010; Wed, 28 Jan 2026
 12:42:54 +0000
Date: Wed, 28 Jan 2026 20:42:40 +0800
From: Chao Gao <chao.gao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <x86@kernel.org>, <reinette.chatre@intel.com>,
	<ira.weiny@intel.com>, <kai.huang@intel.com>, <dan.j.williams@intel.com>,
	<yilun.xu@linux.intel.com>, <sagis@google.com>, <vannapurve@google.com>,
	<paulmck@kernel.org>, <nik.borisov@suse.com>, <zhenzhong.duan@intel.com>,
	<seanjc@google.com>, <rick.p.edgecombe@intel.com>, <kas@kernel.org>,
	<dave.hansen@linux.intel.com>, <vishal.l.verma@intel.com>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3 03/26] x86/virt/tdx: Move low level SEAMCALL helpers
 out of <asm/tdx.h>
Message-ID: <aXoEQP0jyXgR6ohs@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-4-chao.gao@intel.com>
 <f8329aaf-7074-4bcc-b05b-b50a639cc970@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f8329aaf-7074-4bcc-b05b-b50a639cc970@linux.intel.com>
X-ClientProxiedBy: SI2PR02CA0044.apcprd02.prod.outlook.com
 (2603:1096:4:196::17) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA3PR11MB9350:EE_
X-MS-Office365-Filtering-Correlation-Id: 0664565f-6cf9-4fb7-baba-08de5e6ac179
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?CapC525UJAOwReut75XtBNaXxj5SMbaLQqqxIFsarFA/40ou97uj3voMRAAb?=
 =?us-ascii?Q?3YUSdZWoa+zlm303h66Mx8HKhWacYXGJBfoUo3yoeFIrm9tUPJVmzypOIPq7?=
 =?us-ascii?Q?aWW+fNOKS9Ik1HRnz8SxongZH08y4jgHJzjOsgrbtWG1fHdQMfUoQidtMquQ?=
 =?us-ascii?Q?7JZE6mUh9zZV+F9Y5ynHugrvOxlkYNcSWntG/t6yRxNk1eCvvGBtKFp4AF+g?=
 =?us-ascii?Q?BxYouvUY5Hr/p78CWSaEv1+QfFLiRZtkyXHNhbW7stFooLRx9bDzPTXx3TDu?=
 =?us-ascii?Q?FywN/EtK9RkZb3RER0RT73LhEClSfNzsh9FDWKSPLkCV/xFRA4S7qiBKIx/6?=
 =?us-ascii?Q?8ozNh4uPTeZrUFg/tsFWjNtltxCCq2Bhm3f6dSIIqf2mV8bQzq/up+JfczLm?=
 =?us-ascii?Q?QMszrTnu8+fhr00JxUVIjXHlJ+FMdrymclOyUlEy0OqjiMFwkVlkaPawRA7M?=
 =?us-ascii?Q?7/qXPMIKjVdkTTQ3ZQqx/YxHDzJYEsUI5xOvdISxmqYSQtOAxdt0IKTqkMHC?=
 =?us-ascii?Q?KeVauuMAMTzSnfhn0dny1JiMmrgi3FoxcjZkYAxCJWPBF72w7k3kqEpp/VDU?=
 =?us-ascii?Q?T0ceQJpHZU2+Z0svZ9hKTLGzqBuTvE+67TObEEkeaQleZ2cnxyhcIuJJZ2Iq?=
 =?us-ascii?Q?9rzr3eY5y2BsrXN2dFWk+8JE3FqaRfSs37irp6+gtyJ0rgtpM4BcpMIfTKV8?=
 =?us-ascii?Q?wuk7DX8RmRLf45xVx6tQvxGHrlmMy0N9hzQ9P1w37A6DNuTEvwV0TehROCJf?=
 =?us-ascii?Q?MusQ734mZSOU1guMgW3ONhCm2gK5mdcQIi5L9iCJB/rpHNcaeigUxaYDO+Ma?=
 =?us-ascii?Q?qWPUhKI3sX6P3ie/Zrpt6SoE3CV2Iyz33i08AvPA9W71HCaF8lq5/8T8rdIr?=
 =?us-ascii?Q?+1RbrXdQvVN1otBfpmuYnwCDo6aqhf7V86ftALXv245DXgyNgXschpagPgTW?=
 =?us-ascii?Q?8ZVncZ4qqpZCyc6FRsv8f/n1tRtu9zNVZZ9FyRDphIuzlAY8oY5gdtceBfvG?=
 =?us-ascii?Q?VDfJjqQzvxSaec+6HVvSIl5Fkxq+QQlM8gxZpgDA2ZM6yYVI0ge3WN4DUShV?=
 =?us-ascii?Q?Wy/2QOZ9MJKqWWP38iZzFquUPICCHFe4JWf5GAv6AQ/X9RfaM/wqEI9kBgQf?=
 =?us-ascii?Q?D3VSe38/ArsbVDzt0JQlKsWZqsJ3+Zu88ga6TvEVRHqRqBQrdVaGr4zZsOcn?=
 =?us-ascii?Q?0pkbIIHgphc0iyCVDNAeRofSWlCfG3Rs7qA6ypzx+fp8NNXB51j/b8N6lKbh?=
 =?us-ascii?Q?nQEsQIFc4r67JFd24ehTFOFInJW9NW5BIScGCKqyZYiqavjf6/pbelvt40QR?=
 =?us-ascii?Q?nJqph1ed07KBHiQaRd243pXz1nyIkbvBO4KOCE+cG/GIzO+tYofMbaJf59b4?=
 =?us-ascii?Q?M9Lw7tMPolforlGF2VQe1lL12KgWMtVHrtYw2gKlalGRjMx9F/ZBoqJ68k6w?=
 =?us-ascii?Q?V9OfoZXmYjAL+p29Kb8X3MtxJea6Oc/vdLP35dtzHBo5zdy8GvblK79QqpKr?=
 =?us-ascii?Q?eJnkoq3414L8iD5+jiCck0AmCcLTJgy5bOylCIY0yZTJPpHezhyvzfGy8py1?=
 =?us-ascii?Q?+pYs5/WfrfsXTnvAoQg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uZGmTfPnPMrQEdWW4chuxsm+oSjw6aaDa0839P2XUHvhQqDyf+w2WGJLduoa?=
 =?us-ascii?Q?xULu7/q/ffEwBuGx8ZLAz+cp0RgtrKRmMyhzH3e1uzP5N38g/Ad/yf5Cc7ZH?=
 =?us-ascii?Q?DgpgXFZw2smRdgJWr6OvN6x0mycHEhhJGaQ7ZRJqwUDtm6wzoDlURnI4mKxG?=
 =?us-ascii?Q?szk8cY8KZYD27NQ+BAPJ4ucRw0EF2eiutuIdfp4s6lvObBLWYOxSoWSoMqKN?=
 =?us-ascii?Q?GdLWUYXVdnzWKpa0WCSNgujCpSQABt0SVd5joS+9m8JKNGBrVuFEMaNH9E53?=
 =?us-ascii?Q?46vIIUtz7fSy9u+sKXNgZx0fEhdB7iTeNoWf/CWZ8d5k6gODENdPoryDYZCo?=
 =?us-ascii?Q?hKvqiHHGJ03t197a95tUyoQS7tVaZ0iJw8u/chkpem0MoWWi3OV9sq0V7Yry?=
 =?us-ascii?Q?HX1X8N9/YXaE0qylH0/Yabmn/GVQ4gOubPJSHmTnrX8iHd/pso/sCH9gLdyV?=
 =?us-ascii?Q?koV/jH2U4B4KHgpzs8DbTc+mtRbXiVMJBBp8qbruhErzaSgxGNgsT1IkqgVr?=
 =?us-ascii?Q?n4gZDlypJ7JcKEUbebuOhl3DA/d+pbw51r0HJ7gvMOWmCCIgV/G1Etj3mLYw?=
 =?us-ascii?Q?QxAzMCzeIxwpJiS3xG5ZtitXHe8S/1B8tPBgu3U7curX9zPp5BMbBErk6vxq?=
 =?us-ascii?Q?1PTqNFPLGZhL5OUmB+7cfx4oq5aRzGsbPPAlTZId5U3T7S+I1QS/UrxhAq24?=
 =?us-ascii?Q?xNCxty6z1XBfaa6/7a19bYDVxw+iW6gom7rye5R4cc6SCp3P/vDQ/9v2o35I?=
 =?us-ascii?Q?FtQp5qtcEGBHzeoeo/d8Ar78qJ61ZUaX+RfId1m5VrLPx1q31XP9a9LRMFEt?=
 =?us-ascii?Q?SiKlsCRh6f25D6/OhzKN92Iq0UIbZSBuUepu9U7UY17cruY/7vM+9IAmXT7R?=
 =?us-ascii?Q?so3++U2hOQr6NwTgEkiap0QT71ubyLgj8jDODnVKf3QgBXvHk3ZcSvMnyDSq?=
 =?us-ascii?Q?mOMNkU6xv+8FI4d0XGKpU4Yh4/xwB4efzr+zoN7M0uXAa3B2ci8ZeS62SUeS?=
 =?us-ascii?Q?9eWzE0esT/loZtb5dsSwoULSgcdu1P8LXSfQKRnEYUm9qbS+8I5X+4IenI7r?=
 =?us-ascii?Q?qfVOerS1zraXFwdMrsP9WjV+z02wrQ7GA3OIpZsefAV4Z5xJ+VcBlK7lu2LW?=
 =?us-ascii?Q?DJWhB0Mp3175h98VOsrosw21HCGUq79BJIDeOtsUmYQt/bXatYglOXq2kQow?=
 =?us-ascii?Q?w7p2zBi/X4dYVJPKs6qZZosovxBRTrt6EapCxbUoUadVC6VXtsi48aOW8pit?=
 =?us-ascii?Q?84N3j8ROZiK1A+1Q/kncL3WHPQFb1Xf2Y+Py14WuN732WnQEhbF5pxhic6BU?=
 =?us-ascii?Q?N8uRsHAmCZ01gdyKXk/I34WsDXs/krkhFIv7j7B2saq0b1/Cjin65FvcefA4?=
 =?us-ascii?Q?7+wQfz5ldUY2FN4Y5b9XmGu9WYU/gH5OtsAaZ28NaBD/AS4F95ub9RsEK97S?=
 =?us-ascii?Q?1PmxoZwMWrU3vRvggjM+LKHrZpOxyHd8B1cUSGMBbM2Qas2bl89Wb0q042/n?=
 =?us-ascii?Q?11gzpMZGJ1+5JPhil9Peq1OXncyUx4Ori1m3uOfD3OIDNMsI0kvIebCAcDcU?=
 =?us-ascii?Q?BZOiOIXM1vRKnaJeipvSjyG1z2gM0iWQqwh/hV5P9bjXM3/A+QR1mVvUOgrp?=
 =?us-ascii?Q?rsIFOpyMKMfT8XpmSTVRLYoqF7Xbd7BDvlZ2D1hKMTJXm4XhfwG1qPiL6kMP?=
 =?us-ascii?Q?Q0wcm7eGJd6RRyZKlkuMaULnh2mRMNpjMQ9Q22MuAFWMbdy4nQJBc2XcbpaE?=
 =?us-ascii?Q?IuXniGryGg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0664565f-6cf9-4fb7-baba-08de5e6ac179
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 12:42:53.9833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YDvwPNIwG78qlBlLQzX4MTaH+EfYSyrJIjLrCf+KJ/iwG0MohRZFt0/CMfgI2EVlRKhsKO7ZaNq9ce0yKpRgpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9350
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69341-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,intel.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linuxfoundation.org:url,lwn.net:url];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 8AF73A164C
X-Rspamd-Action: no action

On Wed, Jan 28, 2026 at 09:37:05AM +0800, Binbin Wu wrote:
>
>
>On 1/23/2026 10:55 PM, Chao Gao wrote:
>> From: Kai Huang <kai.huang@intel.com>
>> 
>> TDX host core code implements three seamcall*() helpers to make SEAMCALL
>> to the TDX module.  Currently, they are implemented in <asm/tdx.h> and
>> are exposed to other kernel code which includes <asm/tdx.h>.
>> 
>> However, other than the TDX host core, seamcall*() are not expected to
>> be used by other kernel code directly.  For instance, for all SEAMCALLs
>> that are used by KVM, the TDX host core exports a wrapper function for
>> each of them.
>> 
>> Move seamcall*() and related code out of <asm/tdx.h> and make them only
>> visible to TDX host core.
>> 
>> Since TDX host core tdx.c is already very heavy, don't put low level
>> seamcall*() code there but to a new dedicated "seamcall.h".  Also,
>> currently tdx.c has seamcall_prerr*() helpers which additionally print
>> error message when calling seamcall*() fails.  Move them to "seamcall.h"
>> as well.  In such way all low level SEAMCALL helpers are in a dedicated
>> place, which is much more readable.
>> 
>> Signed-off-by: Kai Huang <kai.huang@intel.com>
>> Signed-off-by: Chao Gao <chao.gao@intel.com>
>> Reviewed-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
>
>Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
>
>One question below.
>
>[...]
>
>> diff --git a/arch/x86/virt/vmx/tdx/seamcall.h b/arch/x86/virt/vmx/tdx/seamcall.h
>> new file mode 100644
>> index 000000000000..0912e03fabfe
>> --- /dev/null
>> +++ b/arch/x86/virt/vmx/tdx/seamcall.h
>> @@ -0,0 +1,99 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/* Copyright (C) 2025 Intel Corporation */
>
>Should this be updated to 2026?

Yes. And I may drop the copyright notice if it is not necessary.

According to [1][2], it seems to be optional or even discouraged.

[1]: https://lwn.net/Articles/912355/
[2]: https://www.linuxfoundation.org/blog/blog/copyright-notices-in-open-source-software-projects

