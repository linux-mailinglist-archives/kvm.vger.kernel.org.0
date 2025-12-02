Return-Path: <kvm+bounces-65095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 60910C9AD27
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 10:19:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id D72AF34574A
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 09:19:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AFC930BB8F;
	Tue,  2 Dec 2025 09:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZEdgIUC6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7BF29BDB0;
	Tue,  2 Dec 2025 09:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764667153; cv=fail; b=C2uAClDP7Qwg4PQqbezpskcy5okbMc2OUJbB+8LwE7pSBoLQ+4uwTAmyFcgHkxPH9pXXoeQhMovvnzrXPmpIclOWTjtWg8rVTbqObvj0+zqvtW3juGwCaXfAak/fK4T7gUPN+9NwpkLByVbRqMoXzIHYYoJv2KOiG4iYbguD7mg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764667153; c=relaxed/simple;
	bh=xWfIQDKoSMFBbKoINxc72TlQj/pw/8eoL+IwZhEtXiE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=iAA/RPegXAb5TA0JCqkmrKKNyW1ui4fKtnIOv1uM7KCxyfj1VSPrXa/YAy89O3UEXvHmw5L7nG6nZxrioifr9Ty39vFyBaS6uvPE/+ILUzD6FKxpisQRhosrzjl4wKyYOAe8WlznuCB0unIx2+4uMYlNQsg/azuRvm2XfMn9E3A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZEdgIUC6; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764667152; x=1796203152;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=xWfIQDKoSMFBbKoINxc72TlQj/pw/8eoL+IwZhEtXiE=;
  b=ZEdgIUC6tyKi+DAtH7IDMXw47up7fSet7qZtPdBRmknC3bVYaOUPyfcv
   1/jRbdIck9E/lNHkZ+NsRKEeTbWvFDe0wcKuqX5FWkRpTllfqUVD0gmPY
   qUzI9fWGtu51QTxU2u3TuRsor6/DVsYhLaHTG3wpv33seGY2FDOJ0KGTV
   SXPxht0LAyCZ0rHXFeTRPCs6QEYQDn4IJv80kh3lwe2Uveh13Q6bqeLam
   hNoSTKWiK7lmgJb2pMn05idGGz3f2ZybZdPoKIyzrpTRrsSBbxo97DK6d
   fQ5tyBgh+aR+KqT1/+gzSKIYSXZWLzJPUmpWHPb2FyrtkxvnaZDOAmag0
   w==;
X-CSE-ConnectionGUID: ttYMFs4uSS253Rodo3HtXw==
X-CSE-MsgGUID: cBksZt1VTF+Vuz0dEGdVbA==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="77726362"
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="77726362"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 01:19:11 -0800
X-CSE-ConnectionGUID: XlXtdepdTJ6FmKQH60bWJg==
X-CSE-MsgGUID: eksDM8NzTGaOizgex8AYag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="193436350"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 01:19:11 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 01:19:10 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 2 Dec 2025 01:19:10 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.9) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 01:19:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iY/k2cmSU6YKhyuPxvZqN0O+IQecQ1wgEGx3zFMuhVQ5E0jf4rh1b/PGO+8vYUF1nluTw9cIELEQ86nZzukK/4or6P6P7g19BC3vAJqOvM+0io28JsIcSfqS+AL1Ari2Q+u/zKJEsfvYhdtTNpq/mkT7+UHz3IgE0X2xmnkoHvqvfQaHX9+lUkix6VQmOKB28SXiKemc4QZmmkzLujN4K5EPvJfPJr2zwzbaOGErGBO5qt6Gw5Xaw80aVOuU1f2J+knHM+7kiVVIk5W724zh/SjyT1SDveEcR+0fPLAX2Wl3s8adG0upm0gDKa7sZuC64GMTneXWqQ47CofnDd5n/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zJ5hFH2fG+Vz7TWV9WOqNM08BwHXOXMXRxJIWbg3WGo=;
 b=yeJTWk6FcQ+6L1r9yxi4OL1iI0bpvP0xRuiCH/r3tTO0WZPKfr/9fFWyGSvvWpAwJPRN1SDWvkeN6OMZR2ODgZuC7P4dvhfsjfRYflSKQVPaXRa6Z15lyTHc76BtJsA52Qvtn59myI7U6MgopQkYP8vp1BuGamPH7F3iHXrd8rO7dh1cn3/vgjnXMXm5SNlVB2Ap1Cb4h+hlBiqR6XLkUqA6LBGO1eWJFmIxeXti4dm/umcNHja8mSKfvX9evNzs1o2W7nNLT0QXU949FWjI4iMXVy3FFNHOjwDmkg29Vn6ogTOGA+MaZZQkSAApLVQ1h7L4th43bxEVdyCMxLAOKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA1PR11MB6989.namprd11.prod.outlook.com (2603:10b6:806:2be::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.17; Tue, 2 Dec 2025 09:19:07 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 09:19:06 +0000
Date: Tue, 2 Dec 2025 17:17:20 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Michael Roth <michael.roth@amd.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>
Subject: Re: [PATCH 1/3] KVM: guest_memfd: Remove preparation tracking
Message-ID: <aS6uoFyqF+SdGWlI@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20251113230759.1562024-1-michael.roth@amd.com>
 <20251113230759.1562024-2-michael.roth@amd.com>
 <aR7blxIx6tKD2xiQ@yzhao56-desk.sh.intel.com>
 <20251121124314.36zlpzhwm5zglih2@amd.com>
 <aSUe1UfD3hXg2iMZ@yzhao56-desk.sh.intel.com>
 <20251201234447.5x62vhlg3d5mmtpw@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251201234447.5x62vhlg3d5mmtpw@amd.com>
X-ClientProxiedBy: KU0P306CA0017.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:16::11) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA1PR11MB6989:EE_
X-MS-Office365-Filtering-Correlation-Id: b9eee779-c25b-49f4-ab4f-08de3183d7fe
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?kuO0x5a+KTzVuVXC/6yksoPBOSgXp0vxxYajdC2x7EH4bm/R+Msnj3EmiC1X?=
 =?us-ascii?Q?8oiv42+WrL9Bu8GIxhl2fr2oMkQ/nujrcMp7ZWHPvWTSkLs4gODCLhIXICEd?=
 =?us-ascii?Q?hy7+QjZGa89k/zLvrhUYHiVeuPPL/SEAEPK7SJprnmhwdwES66fVDPdQugJ8?=
 =?us-ascii?Q?Lo9davhauoLkTailIC6WPHpuQG95yiPDMTxONRDHd+hzFtL0Ln0K03QYmYFz?=
 =?us-ascii?Q?Wl2Sgl14obC29neOwt1MCgUYWJ4bnMrYxWFKrYZcNFv+l/km4789FtA4qFCj?=
 =?us-ascii?Q?AWSe8D5Z/WxYeBs/dNPVkpjvInNNLUujsy0XxO+JKVzvpt4JvwoV1FaTDu4C?=
 =?us-ascii?Q?6mp2pHgTjkLq2JsD1dYprmbnGVJZARirK7gMZ99+Hcv7xuTFxvKJR2zh0r75?=
 =?us-ascii?Q?nOTy4UxbIcBGmp7N7udKHFrUTZ5jDHbApWQTDhvi2j7U6S2LcVFsCNDoUY+q?=
 =?us-ascii?Q?J2YM8QsfHmHEBuK0B7vPcPCdRQk2k9dSJML/r7ikL9oWqYrmuVwSh6q2bTWB?=
 =?us-ascii?Q?jnwV2+veN5/KdO7r4UECdlmWUB+dtvL8qkxMmIkYmeNCyMvprEqInc89vuCP?=
 =?us-ascii?Q?LYfK+JcOeAIIoMmkjMqDZGfK+NLQJfZlSra2HizYuGacn2PUe29kqB+L3cMo?=
 =?us-ascii?Q?zH8A3w11EqABpp0xF0vJhoslvvAWMtupdhqIfHLXWbCaC3MrM9tmDANUgnzX?=
 =?us-ascii?Q?Kk1vaJohFo/fbwQJtciVQEV9WG3e/V6iARoSKctbUIzZfjIXjq7xqDtKxhSK?=
 =?us-ascii?Q?ajnBYTCZQIao0eBHF4YgegSypBpFVpJ6bvp03U1e03pceIJisaDA5gUILN6c?=
 =?us-ascii?Q?Nk1rtZzPnYWsc2L9mPQh4Fg0IZrP0F/mYsqc/Vx11cLQN1+2q9sBnyc1n/Jo?=
 =?us-ascii?Q?Xx/XHEhHsxTmlDuXIeP+T2otSSEBuwk7iDmTR2NtBwH8l4n2LDmU/TnprF0B?=
 =?us-ascii?Q?fujwt9ukQdqWcWqF7ieIp4lGJtXOMOP/2yZ0kw73bFmStD/y8z/+DOmFGoa/?=
 =?us-ascii?Q?aZgXV7qTw4oO396sz7yDqZqaR/FqNnPcGKCc5JVEJv7BiL1r8mMT6ABfL4GG?=
 =?us-ascii?Q?vb+pZClU+det1HZOLb38M0E7tdICRpx1D4PwjMabldQBV/1/GvL1wcKZI4UH?=
 =?us-ascii?Q?Zc4/+6WhF8ZKBuetPAtRZC1v5Nagi0vmdZ17xqsN7XrBiANZoIIhiY1xELVb?=
 =?us-ascii?Q?IIBF7E9TEeJptu5JW5DICs22HD5glLel7npuevxQUAeuWaGqSP/yqZiSS8W8?=
 =?us-ascii?Q?zAtCfeO6HdOwCnSqpfujNHEgja/acJHiXugWc6mNqLdMb3eVAE2u5YzeTrNw?=
 =?us-ascii?Q?l+PmxrgwV0REmjXRyEBZoSJUHeSDW/OXMOGq9DXBxLoBv1PZaQV9IHqDew6d?=
 =?us-ascii?Q?1oWc8at6g/o3yxOhZymKlHsd8//hi6KsWFOsIIm6IRWqeO5K4GsTho1edDez?=
 =?us-ascii?Q?7ze8LV78JoA7c5S39SJTBXfvZNchBwaLcZeNOa4wzOosl0hZCyK9PA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pG6W5HKxc31l7Jp+dFIRRKZ3KuxYtW5icTKA5cxlhtRTkLUY1gWIHAmKuIW3?=
 =?us-ascii?Q?UV0jf6BMCZH4mwDdkSibBi2HiHmVcJL3IPpeXAGV+SAsWEYxeyee6upmzNjB?=
 =?us-ascii?Q?zvFBQCGJs2NkMm2ydaZHWHT6gVsnr/dIzEUHLQYnN57g8wuVyMJONiv2SFNv?=
 =?us-ascii?Q?N05YULTCpLbz5Q9gsN6WXqOffm7MK9HfjPAuf/7dnEMm98zseSVn2xoO2cVu?=
 =?us-ascii?Q?fhhMrAyzxUX3pfh67XbVbFdq//PwpO+VkqyiI88+8o6QYpWHU+V5ahjrgxwm?=
 =?us-ascii?Q?QhfmCnKFg/XDEY8mV1HZSeEu9XPBuJTWudoZ1c+mKobeYMZAk+2yrDl7I6Cv?=
 =?us-ascii?Q?evssIU+oOCvkok/ExF8CkZDn4U4NiuMzmU9MiZi7hMQjtzXDz1I5v5n619Iu?=
 =?us-ascii?Q?DGzEzyqrfq0IqntzMJF7WMANUOAOZTSqlWGm5hplDERgBM6Q0EQ2T/tx0vqp?=
 =?us-ascii?Q?i3pOTcoVlGY7HpFOfaxfvfT8z7GniiWV4nTxGsr7rH8XtoNHxfbtPZAx9Mnk?=
 =?us-ascii?Q?NXkkKY7L1EvifbG1R4ieJobAWraMM7CvzC5vl0ZkBmVVVfDQ8mW66nn14XUl?=
 =?us-ascii?Q?bI5lwuB0Js75ze166kY8Z8FKqv3orucA+JUiLujNDFC33wYunF/QPWdxSiJQ?=
 =?us-ascii?Q?NmmafFdK/F4OTLtI0Q4cIDcu//suE1VX3qL0WfrTyCbZaoY1IJVSmfzePsEk?=
 =?us-ascii?Q?v1xcg/T5RrvghJ0IjahYW9qaKdgOpPiOPnBLVHAxb7Oco95iKml4YP6nKugx?=
 =?us-ascii?Q?BefdM5xMJfN5yaNZqqrqF1oOnYqxDANqzSarLG1nkzQM+3f7E4zc90mIDlyL?=
 =?us-ascii?Q?JG0w+fXxvB+D9OfgugDUQhCDnb6zjR+NAxGTS1i8C5T5Tg2RhyzMZcpTiTv9?=
 =?us-ascii?Q?qgZiNI8fvB1x9pplKEbnY1vVHJh+ojLK4hkH4qRyWzb6/VCkGECoYrkyh03x?=
 =?us-ascii?Q?YYlU9HDOK0nJVU5dfQMJ0WaWNSknfKaCaEuqKlWDvaaLsSbezwtuXDpJ1Kmx?=
 =?us-ascii?Q?buuVqs2kEXf7zhzklQhQ+la7BNkbVSS1UL8bax6rweZr6tcDLWVttpkGNZGU?=
 =?us-ascii?Q?bjrSVaCXQnbeJ7hdcnFgQMjXP7sM37jFvpIU62amyseYHJeitUbUf0z/jXEj?=
 =?us-ascii?Q?rm6OP6BIN0OhsKmIyf8x7nIba3V5HuMeEn1beQRUHkkfKJP7zam2pr73myT0?=
 =?us-ascii?Q?NzCiOehmSHbCMikTOJXR2+PNUNxYHsxaFw7xHMUrcAekrNPGmFlxD3qUeB59?=
 =?us-ascii?Q?xKvnAI0XiieeC+V2H06KqaOqlbeAdLBLxX7WJLChZTgffvAbAagEKzodwogJ?=
 =?us-ascii?Q?0T2Vp7ouSvoQWUUKomd+yLvBRN3dTk/1UyyfbaAKl2dwa3shReA/lk3FnUHP?=
 =?us-ascii?Q?eN5ZZXXDs40ZzlfDtNliF3SV7VoHTAb+TurdqAYUmGio3b+EoRTkXT2VwChs?=
 =?us-ascii?Q?tJsBi+xXeFMPl8G2wHWvbvqpzRseR2O66xmFtiSkyb9F8743DvTcdq3smuqC?=
 =?us-ascii?Q?LOA92ZYXo1tt2ywG5Av6FrmDqXa7Qd4AdU5Nkg1plHzzWKjZdGy/S5aTIKc9?=
 =?us-ascii?Q?6+FTnls2psxArMdYHWc17eiRWr9vy6dxSpYjfI6q?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b9eee779-c25b-49f4-ab4f-08de3183d7fe
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 09:19:06.8756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g16+orCFuHTUIIXARdsui61HI2PbaFjzi7WHLW7BOYWOw5MQAnIWjct0xwachbUfuqh94UhAPAvU1ZTa6pUDOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6989
X-OriginatorOrg: intel.com

On Mon, Dec 01, 2025 at 05:44:47PM -0600, Michael Roth wrote:
> On Tue, Nov 25, 2025 at 11:13:25AM +0800, Yan Zhao wrote:
> > On Fri, Nov 21, 2025 at 06:43:14AM -0600, Michael Roth wrote:
> > > On Thu, Nov 20, 2025 at 05:12:55PM +0800, Yan Zhao wrote:
> > > > On Thu, Nov 13, 2025 at 05:07:57PM -0600, Michael Roth wrote:
> > > > > @@ -797,19 +782,25 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> > > > >  {
> > > > >  	pgoff_t index = kvm_gmem_get_index(slot, gfn);
> > > > >  	struct folio *folio;
> > > > > -	bool is_prepared = false;
> > > > >  	int r = 0;
> > > > >  
> > > > >  	CLASS(gmem_get_file, file)(slot);
> > > > >  	if (!file)
> > > > >  		return -EFAULT;
> > > > >  
> > > > > -	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, &is_prepared, max_order);
> > > > > +	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
> > > > >  	if (IS_ERR(folio))
> > > > >  		return PTR_ERR(folio);
> > > > >  
> > > > > -	if (!is_prepared)
> > > > > -		r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
> > > > > +	if (!folio_test_uptodate(folio)) {
> > > > > +		unsigned long i, nr_pages = folio_nr_pages(folio);
> > > > > +
> > > > > +		for (i = 0; i < nr_pages; i++)
> > > > > +			clear_highpage(folio_page(folio, i));
> > > > > +		folio_mark_uptodate(folio);
> > > > Here, the entire folio is cleared only when the folio is not marked uptodate.
> > > > Then, please check my questions at the bottom
> > > 
> > > Yes, in this patch at least where I tried to mirror the current logic. I
> > > would not be surprised if we need to rework things for inplace/hugepage
> > > support though, but decoupling 'preparation' from the uptodate flag is
> > > the main goal here.
> > Could you elaborate a little why the decoupling is needed if it's not for
> > hugepage?
> 
> For instance, for in-place conversion:
> 
>   1. initial allocation: clear, set uptodate, fault in as private
>   2. private->shared: call invalidate hook, fault in as shared
>   3. shared->private: call prep hook, fault in as private
> 
> Here, 2/3 need to track where the current state is shared/private in
> order to make appropriate architecture-specific changes (e.g. RMP table
> updates). But we want to allow for non-destructive in-place conversion,
> where a page is 'uptodate', but not in the desired shared/private state.
> So 'uptodate' becomes a separate piece of state, which is still
> reasonable for gmem to track in the current 4K-only implementation, and
> provides for a reasonable approach to upstreaming in-place conversion,
> which isn't far off for either SNP or TDX.
To me, "1. initial allocation: clear, set uptodate" is more appropriate to
be done in kvm_gmem_get_folio(), instead of in kvm_gmem_get_pfn().

With it, below looks reasonable to me.
> For hugepages, we'll have other things to consider, but those things are
> probably still somewhat far off, and so we shouldn't block steps toward
> in-place conversion based on uncertainty around hugepages. I think it's
> gotten enough attention at least that we know it *can* work, e.g. even
> if we take the inefficient/easy route of zero'ing the whole folio on
> initial access, setting it uptodate, and never doing anything with 
> uptodate again, it's still a usable implementation.

<...>
> > > Assuming this patch goes upstream in some form, we will now have the
> > > following major differences versus previous code:
> > > 
> > >   1) uptodate flag only tracks whether a folio has been cleared
> > >   2) gmem always calls kvm_arch_gmem_prepare() via kvm_gmem_get_pfn() and
> > >      the architecture can handle it's own tracking at whatever granularity
> > >      it likes.
> > 2) looks good to me.
> > 
> > > My hope is that 1) can similarly be done in such a way that gmem does not
> > > need to track things at sub-hugepage granularity and necessitate the need
> > > for some new data structure/state/flag to track sub-page status.
> > I actually don't understand what uptodate flag helps gmem to track.
> > Why can't clear_highpage() be done inside arch specific code? TDX doesn't need
> > this clearing after all.
> 
> It could. E.g. via the kernel-internal gmem flag that I mentioned in my
> earlier reply, or some alternative. 
> 
> In the context of this series, uptodate flag continues to instruct
> kvm_gmem_get_pfn() that it doesn't not need to re-clear pages, because
> a prior kvm_gmem_get_pfn() or kvm_gmem_populate() already initialized
> the folio, and it is no longer tied to any notion of
> preparedness-tracking.
> 
> What use uptodate will have in the context of hugepages: I'm not sure.
> For non-in-place conversion, it's tempting to just let it continue to be
> per-folio and require clearing the whole folio on initial access, but
> it's not efficient. It may make sense to farm it out to
> post-populate/prep hooks instead, as you're suggesting for TDX.
> 
> But then, for in-place conversion, you have to deal with pages initially
> faulted in as shared. They might be split prior to initial access as a
> private page, where we can't assume TDX will have scrubbed things. So in
> that case it might still make sense to rely on it.
> 
> Definitely things that require some more thought. But having it inextricably
> tied to preparedness just makes preparation tracking similarly more
> complicated as it pulls it back into gmem when that does not seem to be
> the direction any architectures other SNP have/want to go.
> 
> > 
> > > My understanding based on prior discussion in guest_memfd calls was that
> > > it would be okay to go ahead and clear the entire folio at initial allocation
> > > time, and basically never mess with it again. It was also my understanding
> > That's where I don't follow in this patch.
> > I don't see where the entire folio A is cleared if it's only partially mapped by
> > kvm_gmem_populate(). kvm_gmem_get_pfn() won't clear folio A either due to
> > kvm_gmem_populate() has set the uptodate flag.
> > 
> > > that for TDX it might even be optimal to completely skip clearing the folio
> > > if it is getting mapped into SecureEPT as a hugepage since the TDX module
> > > would handle that, but that maybe conversely after private->shared there
> > > would be some need to reclear... I'll try to find that discussion and
> > > refresh. Vishal I believe suggested some flags to provide more control over
> > > this behavior.
> > > 
> > > > 
> > > > It's possible (at least for TDX) that a huge folio is only partially populated
> > > > by kvm_gmem_populate(). Then kvm_gmem_get_pfn() faults in another part of the
> > > > huge folio. For example, in TDX, GFN 0x81f belongs to the init memory region,
> > > > while GFN 0x820 is faulted after TD is running. However, these two GFNs can
> > > > belong to the same folio of order 9.
> > > 
> > > Would the above scheme of clearing the entire folio up front and not re-clearing
> > > at fault time work for this case?
> > This case doesn't affect TDX, because TDX clearing private pages internally in
> > SEAM APIs. So, as long as kvm_gmem_get_pfn() does not invoke clear_highpage()
> > after making a folio private, it works fine for TDX.
> > 
> > I was just trying to understand why SNP needs the clearing of entire folio in
> > kvm_gmem_get_pfn() while I don't see how the entire folio is cleared when it's
> > partially mapped in kvm_gmem_populate().
> > Also, I'm wondering if it would be better if SNP could move the clearing of
> > folio into something like kvm_arch_gmem_clear(), just as kvm_arch_gmem_prepare()
> > which is always invoked by kvm_gmem_get_pfn() and the architecture can handle
> > it's own tracking at whatever granularity.
> 
> Possibly, but I touched elsewhere on where in-place conversion might
> trip up this approach. At least decoupling them allows for the prep side
> of things to be moved to architecture-specific tracking. We can deal
> with uptodate separately I think.
> 
> -Mike
> 
> > 
> >  
> > > > Note: the current code should not impact TDX. I'm just asking out of curiosity:)
> > > > 
> > > > [1] https://lore.kernel.org/all/aQ3uj4BZL6uFQzrD@yzhao56-desk.sh.intel.com/
> > > > 
> > > >  

