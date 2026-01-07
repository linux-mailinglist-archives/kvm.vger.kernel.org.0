Return-Path: <kvm+bounces-67195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B241CFBA2B
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 02:55:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 14479300484C
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 01:55:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B839D235358;
	Wed,  7 Jan 2026 01:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XCe9UdDd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6E310FD;
	Wed,  7 Jan 2026 01:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767750930; cv=fail; b=bLz/uLEk3yk2tBPkgWwDF468tkqyqoNtPArtAmTDUagMsWcGJssFUJNlxmfbMCZTyKbJWMf3EijhfdOSeNC0ci/H2mg7/vlggAA1hPm10t2qhezcdYHdO0QNB30CFCDdvTmhHw1vMhpzWBGMnmkG3GXE5gYIytTGvFDv+DyFWb4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767750930; c=relaxed/simple;
	bh=Pnj1+QpHkvdjcPk9duxXRAjw18H9L32Hq6AcrtVt3Yc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rAcAU6sCF8lRokQ5QfB/nrK7UDqMZ3C8bziuRTZLrBIZSsB5oRyCmE45upfV++hXGNlOyIONR/llB+GTva0YzIPFr3/4f4EE9D8FPD9y4s+eWiRP/3PZfW0BttluySekxib57Sj6FfBq99UTBcZnfFY3xS1VdN6SE2mFyfrgmm8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XCe9UdDd; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767750929; x=1799286929;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Pnj1+QpHkvdjcPk9duxXRAjw18H9L32Hq6AcrtVt3Yc=;
  b=XCe9UdDdtRTbawc8SWUH87SVEENsLX6wSc6WD59nGgDCmdsvsUMMWZcP
   eV4EgtrzK9CgVFYAUAPA/eXSGRkBv+znVYIXQtxva+ePnS9Kf65p7bMG9
   6Pb/ljpVTtPc25bMoZ9kShVf22qfv2+Lf/gwUBjqX6A9wSb2F9BF3ozH+
   Ck5rkRFZfq3is3c9OfjromTdab74olMKNBeGkwOMuNQ51Tj1SdKDX7OFh
   UCK7VYK8TmBBm9/oUI2i2aGvYuA6lGVrWSool6A32M0MN5P6T7tYvGQpX
   HFq1eMus3wMaJNXtexVjZiIIzbmZwYqIpxx0/K/QkqZ97SbvvW0NUCq40
   Q==;
X-CSE-ConnectionGUID: NCrxv9IYSu2dA+wwijK1rw==
X-CSE-MsgGUID: Ho5jMXtZTPiZcZw+vJOQ5w==
X-IronPort-AV: E=McAfee;i="6800,10657,11663"; a="69168079"
X-IronPort-AV: E=Sophos;i="6.21,206,1763452800"; 
   d="scan'208";a="69168079"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 17:55:28 -0800
X-CSE-ConnectionGUID: ddjuBSdpR4OCHyiBMTQL1w==
X-CSE-MsgGUID: HY+JEwL0T7OAVf6C4fhJCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,206,1763452800"; 
   d="scan'208";a="207855713"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 17:55:28 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 6 Jan 2026 17:55:27 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 6 Jan 2026 17:55:27 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.50) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 6 Jan 2026 17:55:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B+SuQlZzu3orWoCXETfOOaE4VyNdaupl7i75vN9JFItcochlhST0ZS6QmJcvSk/zS2tCXDzZgJrkEc7M78DrGkygxXIot6CrNnxCRV1Kvxt+YdJBXpRT6X+YPvMW/wNPwniuDFZCp1F7AK95Jq6Af0WCQAzFFrvSXa4swMiQtEZTLQldpzUNWNp93hbpxszSTkluNPvFNMdVfDjZQDcudMp/O2c6oS5VX61tsvld/6AvBV0pEJ/RxQebn+llsHTqR6deciuUXou9Q6kWTZqvljLPWG9lY2OBxYtJFfUUunDQYYNG8B3Xdt9EEHwca2KeWKbcWhjujstLRnpiP1XpFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hHVs+TuuQsGAy1FCseKx0mQPot68IkpIlOYjbKnXUM=;
 b=VkO2/ORp+xaYVlTj2izLUCbmHOVFht/EVYaBhkbFCK5GLUQ9pAPJbukYnIPQjryyvk/dMpRKUMcuenwm/945+Urqabhn8UV/UNq32u837VIVjehynwWBgtN/47RvxAGBbjbeNAe7qZ2x4gkQ7clu5x88VmeIQPEW81lgpy9UcbuXi/z4V3UKRFl5BOfxW4qjacK7ky4O8YXUHOYOm9p8kOTqZFzQk/hDVr2Kk473NQDg3vc222M2+o8EBu60dwPDPgHzmJKZD5o4LBfmWutoFr5eix1HqiG9FoEZH4CDWfaxi3Pbq8sQJCISY960kklcehZttSLdtLNdVSQLwmzzqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA1PR11MB6121.namprd11.prod.outlook.com (2603:10b6:208:3ef::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 01:55:25 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9478.004; Wed, 7 Jan 2026
 01:55:25 +0000
Date: Wed, 7 Jan 2026 09:55:17 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Xin Li <xin@zytor.com>, Yosry Ahmed
	<yosry.ahmed@linux.dev>
Subject: Re: [PATCH v2 2/2] KVM: nVMX: Remove explicit filtering of
 GUEST_INTR_STATUS from shadow VMCS fields
Message-ID: <aV29BchY51qFD2UO@intel.com>
References: <20251230220220.4122282-1-seanjc@google.com>
 <20251230220220.4122282-3-seanjc@google.com>
 <aVSZGRpvMIrmUku1@intel.com>
 <aVv3-V1mXohnyeFK@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aVv3-V1mXohnyeFK@google.com>
X-ClientProxiedBy: TP0P295CA0029.TWNP295.PROD.OUTLOOK.COM (2603:1096:910:5::9)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA1PR11MB6121:EE_
X-MS-Office365-Filtering-Correlation-Id: 79db39ec-6dc1-4266-567d-08de4d8fd336
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?vGayC4BY9Xkv53ZHB2LC8S2EbaoSrPXBMuq4P5WXpxDe/1zVCBF6Hz+OlSNw?=
 =?us-ascii?Q?lIy1C/zsILYUCbhUwj+wEByC0aDVwZBTC3G4BI7wVb5IXILcanpkZySpiG/9?=
 =?us-ascii?Q?qQ1E0t3baQ0ohkbDQn499DTGhOwI9Z5ZZp/wiIjPv8ucsu9ZTjxJjD243C2C?=
 =?us-ascii?Q?dS8iRXvZTey+eUUjXDv9mQDD4HFPQxSLJuAJVDjBtb4xw+eu+aP/k4fV94kh?=
 =?us-ascii?Q?wm1uliB/iw73vpYdh5KcbQqnxj3UK0X/Bw9KJxhhlnOqrQisWcvAStDRRLqL?=
 =?us-ascii?Q?cZZNQ5TimBhfyp3rbL8mUHFbzgmpqb3sGVjX3F5YwtzVbOid2NbcnLlcxv92?=
 =?us-ascii?Q?QO5834FebQHNNk+OUgnOtS+VdLIstPjcREJFuMJtSgEwb/ypdPZTxKIrFOaZ?=
 =?us-ascii?Q?ZsZb8lZ+zNktOKhdLAR8gQIeu97EVXeZSac1XOFtHoFG9s+GURPL8FkKbEkR?=
 =?us-ascii?Q?4cd3bymnwqkITKEoE9iJMxtEsL5kRUX72sEbbilH4II9HaaqbElHhV4lJ/rm?=
 =?us-ascii?Q?Er8eGc1ICcdIyOzjH97NlBCevwipklQsgJ2lFMIkyvqG1Z0VeRosj02HEBiW?=
 =?us-ascii?Q?TN8iYJVWMhIl/N/wLfNv8aDFGPigbc6ow50mp9C5L366Q9/RVWL+6GoOgAA0?=
 =?us-ascii?Q?ha5Qhz7S5H6KUqDW/iikrcVs3EFuChx9plgG4qbSA4DOXT3LlX2hTQj9/QlK?=
 =?us-ascii?Q?ntye7buVt4VKhQHSAQYjmggZw2xrdVOClEIvbbN70EQ7++RFKnhjxOKecj4C?=
 =?us-ascii?Q?SxGjFjuNP9tpu53ilAc+F+ikcmGmoHbK64I0hPj41027M9miwUyuEfKcOPQE?=
 =?us-ascii?Q?hQt4HaV4bdUDC9xI8KHBEIOtm22HoEVGXrkGTp3XOg8PiWXcGD+JHj5x8H6y?=
 =?us-ascii?Q?uNBAZ/00NLsE3OtXl+z+VJrseyNwfePgiDnvy+8g4a2YDiin7T2Gr9vWifTE?=
 =?us-ascii?Q?TcRLuO9NJQMTaruDQlcWgh/o+VuuTLKYn2W5kOkXLv6iYBRTwT41PpsyHure?=
 =?us-ascii?Q?VKkA85IMSkjfyv5OAMU349IRZDoywDYPd2skt1ijAd5JqdJuN0SDqiJ+uUF7?=
 =?us-ascii?Q?Tioq+3gFNqP1URzgPEU7wnOT1ylL3pEpViTacw+OjeKd7AwdxeDNDg0F8XuC?=
 =?us-ascii?Q?iIOHu+zi2o+23TrBCOIzqRdcfAP2EG3e2k0B/atOFVgvTRbNt359VM/n6BlO?=
 =?us-ascii?Q?ziXnJzWjW50EKOc7xHW008eGeRUbQ4Gb20WdHyZvtWqRkq2hfeY3XW/OM/YR?=
 =?us-ascii?Q?LF7yTAGjEOjPT6YKu3LpawkOeNbOTrIXAa/DAsFJZs1KJijKXXDVt20R5wQ6?=
 =?us-ascii?Q?lbOKMNkzWX6foiwTJY6jZ9ctYfaa3qoc6B6lH5TRLXZt6rpu3vFN2Q5iDTBp?=
 =?us-ascii?Q?5k0m665UjioKXXJx+soFbtVXpwfkFBXNz8/Fv4AteUaGaS2lZ8io3oy8+6t0?=
 =?us-ascii?Q?GPxrZMOf7vmwVJMuCJ9itcQrIR2dBBiO?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8RFMSQLiAvjAuveMcfuOztneQOwH+VavE7srilIWGwwFsYsfdTwtRgflQcTj?=
 =?us-ascii?Q?0OS6R6vAJxaPMuCXKVJIz5HJcUCgSO1eaQHwTj9HfEXaSPhlmsBprWMFbQr0?=
 =?us-ascii?Q?uU9Ta2qCzs2iJrQ06beufwCTwQxfNvRQvJnpJmtpBytsSAmyn5yWpTaD3q2P?=
 =?us-ascii?Q?fnllgy2cDpiDHO39jFwJjorPHTHdMxK2/SXpWqD6hYuB6ToIi0Gz8mJmCoPy?=
 =?us-ascii?Q?WXwQL8OTWO0lJeaRvG2drjgZ/ouLXPBdwWw3tVECJBCiVpUQObGH0XJ+hZao?=
 =?us-ascii?Q?OtW//qvSyrz9lZ7GnQ5v6x7N/Euwr0Fe6JYwA4n+unjgUdhzcUctyGIEsL61?=
 =?us-ascii?Q?3+Nygj6NryIU9OCcErUPfwAW33+t6Wf3atzd150Mp/U8lXFENjU/r72/ct0X?=
 =?us-ascii?Q?/gXsRbxqqxvHo7+7iOTFZl+TD10YRwoItyBGsJ2jh8zJab5GT6I4NXVbP1rT?=
 =?us-ascii?Q?5wG0dbvemwcAGOjW7sFyoiOKUzGqp/L+i6gBhX4Rse1YN7RjkItARg0/yrSo?=
 =?us-ascii?Q?TA5/GlhireugJn8qwYoitglngI9v2j2AtnMiEfXV80D+GNb0hSw2Snh8gNHj?=
 =?us-ascii?Q?O4fJgf9FdMMQVjlXsACUBSUTfi5J8C+Jg2Vp0bZGKD0aYVPN3EsivDkqvHG/?=
 =?us-ascii?Q?5hNHEQXW1INCr8CHEcuV6w3OjKnFH8quZv6dQQeP1DpHlc2bOkreUNWk0Rs3?=
 =?us-ascii?Q?d6mq0RV7w0kcd8+rKhJlpu5T/5rd77sRoczUKmXg85YAEDZf6Cf3iM9aJpKm?=
 =?us-ascii?Q?rMByO+4frmMYp2UrgVXh5i1VuUQKlzXsUvz3FImxIRf0yxYeSm4PggbVqeFh?=
 =?us-ascii?Q?8Q+vrFxGc2yGiXo7EQr1hr3VhVlk60SPHcZ3qnTs0kek4hBsTnX4tZpe3v3E?=
 =?us-ascii?Q?s5PdOrGYmBfF8kuORrUnsgLItwXXy/lgSD8h28/EieDUDiLVxZ11cIiw1/He?=
 =?us-ascii?Q?eiZfdOEb9DkvcTvxxuoZrNMWTt+XspmtNrZvmN9ImxDeJZX5wLugHCa9Nbe7?=
 =?us-ascii?Q?vu78UQiDX9Igf+Ou3V12w7nTHnrS6DZftlf2AXNUwmd9kMVUnktU2O86f5ms?=
 =?us-ascii?Q?e7LNNPltoFPszUuK5/QSoUAJ4ttxCnhBQ/tBsLuDQSkwWYBTHrnIzBTDYADi?=
 =?us-ascii?Q?GD0NfMeA0l6X2QItvVmAGKqqaJ45f0JM7N1dDspDyDdnfUVkRny6Ig18UJ92?=
 =?us-ascii?Q?MmHPPJRbnJABgtFOUnX8eItjC5OOZ1w4x64D8MaQmQXAo/wqdbEJOdYo7zXl?=
 =?us-ascii?Q?dlIe5WNiwrkdCDUpGKa07RLG6BE4PHk82pUeWkOgw83nPvARKYbw+dZ5vKSQ?=
 =?us-ascii?Q?0C4jLXFXI6QkxfG/ih9LAVVaVFbcMf5+E+RlRRJJ7K57ayp8FA46mV33RoFO?=
 =?us-ascii?Q?v6plf/6xAXjE9/3ZUZpjeE5ThPE9Uc3h3CXdmaBntrwdkcV2JriVU/dm4kxG?=
 =?us-ascii?Q?KqE31Koh3I4mwBwHPWADWzK+aZrBIoLXADjk1mu5Cn0BRbG0utD6sIzWW2LO?=
 =?us-ascii?Q?XsDpsCCUqhV9JS39ZLmgHWRvBiXa+aKrkdwayRXZ12Y84IHjsiavKEiNBSdq?=
 =?us-ascii?Q?nRJ5bi4xvx1uMtKZXssI7dUV6VncZn0QLAfGu1xXSQMf6QUfGiJqey0crHPy?=
 =?us-ascii?Q?t2rc9a3OuNtQ6DJlt2TJ/fJyoBjr8JyJhIY3xEAKjtJqv4n79HNtkN5zMryJ?=
 =?us-ascii?Q?xrswtUBYzXunLjCLUFqbK1Qp/7sdAvJaSelJwUjF04bd0+G9hB4kCqr9N5Nm?=
 =?us-ascii?Q?C3aJEA6gJQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 79db39ec-6dc1-4266-567d-08de4d8fd336
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 01:55:25.4185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EjrnALoALQ3EXUlR+V3eh9zwlWdPw9kHi1OUEebdM/S9VquMFdAzmTOjI3eHCCMa3YCd8WrL56R+h1UDH2smBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6121
X-OriginatorOrg: intel.com

>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index f50d21a6a2d7..08433b3713d2 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -127,6 +127,8 @@ static void init_vmcs_shadow_fields(void)
>> 				continue;
>> 			break;
>> 		default:
>> +			if (!cpu_has_vmcs12_field(field))
>
>This can be
>
>			if (get_vmcs12_field_offset(field) < 0)
>
>And I think I'll put it outside the switch statement, because the requirement
>applies to all fields, even those that have additional restrictions.

Agree.

>
>I also think it makes sense to have patch 1 call nested_vmx_setup_vmcs12_fields()
>from nested_vmx_hardware_setup(), so that the ordering and dependency between
>configuring vmcs12 fields and shadow VMCS fields can be explicitly documented.

Looks good to me.

