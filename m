Return-Path: <kvm+bounces-51365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E04AAF6942
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 06:57:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31C0C4A1C2A
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 04:56:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1453C28DF3C;
	Thu,  3 Jul 2025 04:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CWY9OAQX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E08D2DE6ED;
	Thu,  3 Jul 2025 04:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751518634; cv=fail; b=BRD4nf9OOEu94i7lEne5OdiZmwkOeTVq9actA07DUohmWe9RiU03vCzRcY1TwgTL6oUaRhDNgeYumKMaAf1Fk+OlFkj+6VcOp/PjWnUpz5hZ0Aix2jxuZk/A86yuaJyVDilEEQS4dvRz4bHH1Hi0aED6BOegP2FqMI+iw59qsvI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751518634; c=relaxed/simple;
	bh=R9vvxJ0Hd7ybuuiPwhUcf/52Ye4Br47Y+aav8vpVLxw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=C+jr/Fii9dESgTOliWSvJMYpolf+SSQ10uzFDM2c/ysyOqtBubM3JniTL3B+JI2fZzSpgXQW8L9rkzCisCwqYo9htshsPbkx4wvkYEHBzCRd5UnkoJdvIZgl7H57KADJYjZai7NxjSE3VFbsHG7hdWFeR4kMPqaizHLByGjXfzM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CWY9OAQX; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751518632; x=1783054632;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=R9vvxJ0Hd7ybuuiPwhUcf/52Ye4Br47Y+aav8vpVLxw=;
  b=CWY9OAQXvXWvkoNFMhiaHK3NyWgHjZ65LpUx2HNsA6ToZ0pnfYlnLfSE
   ktAQ2BsJWqlztRDXRxdvVeGj/WKJ5+Ki++jXyHOOMwpEruVol/OnnjK1a
   yYLpDkg88sqHqmKrPIbbZkoWz5pN34wfP6FQpiyOsSXMgKoLCfsOi2JFR
   hmptqs4PaHStTX6udNnJ0ktz+w/qxxVvDXD9yq+f7YvCQ8BOWGyOO30Eo
   aGcV5ICUuTS+MwEJ8fcq3Wg4PcVPJd9xAKVOJdnXRRyNM0chbsvv6Tq5D
   gqLNZkyg7m1QuosEGKnwVBQzreQxW9iCSuL+zFdzUbwyBipeKhS5ZCIk+
   A==;
X-CSE-ConnectionGUID: k9LI8fQUTFqKPBb1XTO5EQ==
X-CSE-MsgGUID: 7byeQ0N1SbiC5IOGWB+oZg==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="52949336"
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="52949336"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 21:57:11 -0700
X-CSE-ConnectionGUID: iIVJ42/tTeC2+OF/4Sc/dw==
X-CSE-MsgGUID: 9mRm15YSRjCvW96ouyqLow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="153901813"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 21:57:11 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 21:57:10 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 2 Jul 2025 21:57:10 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.55)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 21:57:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iPbK51v8qUg6VMiIYOcYDQUqOl00PEXu6hYzpKWkRhsQHI4p7o5WeCMV7i3NrRGEv9Rs9xrPIggMJk9Yu9dNMuEK2BLuNWQLDZQozX0bL2iJb9ScZA4fTxFd49R+RIirT0r1xNku4IXYGYHRV39+4tyMSTw7V1AbFwWYeh3VcGl7mNxDU66n2UeezYYCLZ7BzW2tmv1gW7iD7szRMNZIBm/XoeC6sDTafkK4MK42OUqR/Qqi6XsT9aU1+WlIv6hhxcWhEeO7Fzb8NXPoY1C3RJogSOK0cM72KaVK633NizjqWGhWRsT1ki1+U3EeFZumT8zCCWbQkxjhp6SkpnQ9Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ncDilK+9h/Q7I4Q5z4U0pbcmRgCFq7uAGHVt0A44uHY=;
 b=aiJsiMKaw1zsouISYr5JGJWHyvpML7iF6xT5w14vR39se09LKWr4S0kzj3muApsfXS50xPe3r1fh4RTjgyGfLmg2+rbsvGAyw0bz22Ub92v2c/05ASak631qTS6bBvuWkKLUuXCafi8rJvdOf2+WlTjE/gaXzP8asjUTmR7+bdEAvbbY13k68R3QfF0R2lJuCX05SPDCI1qS5nkPWuwkEzB6s9ORimKs2xXUgq2MdbUd9SrboCMKeE5etAk6lMgowDtLImt++vmf57GAiM0hUWoy3R2ITtXOTkZ6/T6kYcKwGg6gLcFql9XZ46jEvcMtAqS3/gtr4+WrFNBvyL7e6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA3PR11MB9040.namprd11.prod.outlook.com (2603:10b6:208:576::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.30; Thu, 3 Jul 2025 04:56:41 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8901.018; Thu, 3 Jul 2025
 04:56:41 +0000
Date: Thu, 3 Jul 2025 12:54:02 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: Vishal Annapurve <vannapurve@google.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Shutemov,
 Kirill" <kirill.shutemov@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"tabba@google.com" <tabba@google.com>, "Du, Fan" <fan.du@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "seanjc@google.com"
	<seanjc@google.com>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Weiny, Ira"
	<ira.weiny@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "Li,
 Zhiquan1" <zhiquan1.li@intel.com>, "jroedel@suse.de" <jroedel@suse.de>,
	"Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Message-ID: <aGYM6uQkFAtdqMs9@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <aGJxU95VvQvQ3bj6@yzhao56-desk.sh.intel.com>
 <a40d2c0105652dfcc01169775d6852bd4729c0a3.camel@intel.com>
 <diqzms9pjaki.fsf@ackerleytng-ctop.c.googlers.com>
 <fe6de7e7d72d0eed6c7a8df4ebff5f79259bd008.camel@intel.com>
 <aGNrlWw1K6nkWdmg@yzhao56-desk.sh.intel.com>
 <CAGtprH-csoPxG0hCexCUg_n4hQpsss83inRUMPRqJSFdBN0yTQ@mail.gmail.com>
 <aGN6GIFxh57ElHPA@yzhao56-desk.sh.intel.com>
 <diqzms9n4l8i.fsf@ackerleytng-ctop.c.googlers.com>
 <aGUW5PlofbcNJ7s1@yzhao56-desk.sh.intel.com>
 <diqzecuy4eno.fsf@ackerleytng-ctop.c.googlers.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <diqzecuy4eno.fsf@ackerleytng-ctop.c.googlers.com>
X-ClientProxiedBy: SG2P153CA0011.APCP153.PROD.OUTLOOK.COM (2603:1096::21) To
 DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA3PR11MB9040:EE_
X-MS-Office365-Filtering-Correlation-Id: 784fef68-8498-4904-f96f-08ddb9edffde
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Ydym33OV5VHgJpRzDbdZChZQpL/Xla1k0sD8BtOeO85JYxbln9+6C9PBi9SR?=
 =?us-ascii?Q?tgD4ejeVt2aXLNN7cYIrK8qk/DaFJhWd7Up5AQvJvvyU7VI+ddrxy6pUpMEA?=
 =?us-ascii?Q?Qx7OywugsHzKEzjkQT1SI955jVFCVlV1RikwTapHoXIqFOEIccx2EDFTlNpQ?=
 =?us-ascii?Q?EAmiLlx1ThePgO5clpc9gqWeDRDVc4Dey57oOE13RBNykDqlfzyZvVhYGk8j?=
 =?us-ascii?Q?iJTwW7In5g+bFC6LJFaE5LLBDoV6SVuGzn+eGtW5ejdFn/VbXlVe+fpcVnl0?=
 =?us-ascii?Q?+rYnzPxKKyFWXx2xXRD9RFY2HViU0UucKO2qc0cM81P3AFogPbfdKRa7Z248?=
 =?us-ascii?Q?5Gs7b1h3ZIaU8RaT1eDnwjS0HduDMYkKr6WfqLDaCKq1F4XrvW4eRK7fvJWS?=
 =?us-ascii?Q?GR5ddzlyZwjUtpATw9+IXaCpHIwFTqxJkm3ic759ktuel4mUECX6HlRKZSWg?=
 =?us-ascii?Q?yvGDQ0tge0H3+Idxt1h9LueL2hF6qeIX4zYsHecj3RHt6oA+LXFWDTJra6tO?=
 =?us-ascii?Q?3GkIfIJdzd68KH3xGB2tJrAwVUsA30qTUD7IUcr7m0rETgw7GkfVNKadvqH2?=
 =?us-ascii?Q?i+sjOExKo7iZnwddrzSZVdoH6ijsUpeK8P8SsF+9+u6IbO3SipLYjWXWPNlD?=
 =?us-ascii?Q?s3JqaojDaVD+PQlXbRVZGZBvcVpTu+LY0cc/a2znxDnlH4inPK4jT/c8IU5e?=
 =?us-ascii?Q?HHvsOCWipdwrij4mfoDG2QcQHT8TICCVa9TFzRW39um772c5DUrF4JphISP9?=
 =?us-ascii?Q?Snvkkj+k530XSlVKT8ta29RL7PesfTxSHknUkNqw12/3cxOwSaxUf5iJ9AmZ?=
 =?us-ascii?Q?pF5bNPxRDmkJSzpXMe2lSgvP7p4+Hbk/CrhwkxFuasUVqHXBrO6wr+G6OxfI?=
 =?us-ascii?Q?cSezgOy5OQF1sDsyQOLxIPKIT3FMQDz/PqLcLZvWCjseiN4XuM9vk2ZVXXzx?=
 =?us-ascii?Q?KG5Mn3BzmllTkfEc+ulDB6vlb5f2RGe0DXiLgUXra/7xfBf8NrASmIRZv2c7?=
 =?us-ascii?Q?wfAiTGJnA/XveDQa2SO0tiKaLIGgfmQOgy5auPAiU5RRW1kdbiRFczibTPTZ?=
 =?us-ascii?Q?PumOWw3+/9RbcyAJF/jfMtxRXkAvWaARvA5KixO4l5rmn1G2920wRXK0JYNA?=
 =?us-ascii?Q?3BoRghEoe79iR8adXcD1j9va3/JsKv2pe3MOq/wESwpW8HmmKdQjIbpjWmwk?=
 =?us-ascii?Q?usdVTHd70fg06tA6460kBz9IDyyteNVIHDnoEIl5EBgr+sNMcGUEPkf6xFry?=
 =?us-ascii?Q?MNx3h08TREXjx/0XVR0rv7MfFh7zj9O+JOco/CB05tXs+lNdPvkVN3zDoyLC?=
 =?us-ascii?Q?XUpL4aSGaJmVh24Nb7LlMRhhMPgSLQth2Jr3lG976Q3RLkVcj3AVe5NxqOqG?=
 =?us-ascii?Q?xd4RvieqR0cDPXh6NWNCcA6F29X835lcM2U+drsdiGh6eG8yF0F4MXdFkAQj?=
 =?us-ascii?Q?zga3pv5aeHM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0PwRtqKNHg2dNYoj70fjFujk17YRoJQGticMQ770x4mHXgURWexiwHvTHRVt?=
 =?us-ascii?Q?Mq7yDXbh4YP0Zt3usAYYjVwjoTyXWEJu2eZI5LR2Ap8VY9xoBBjXEYPqRokT?=
 =?us-ascii?Q?MOhdyzexBzjuHtTHyYTcf0s+kvhRAa4WrPCYMH9d5N5itJJAwWJzt+pKOrTr?=
 =?us-ascii?Q?rIv6hYIKjSD5ECFgYwbmscP2M5l9NKYtIU3OSEvLXdTDIcEuvy0M2JRFYq6m?=
 =?us-ascii?Q?X8ps7+CMvNPaNMSYzh7SRJtOx1KpC8lIHz/4BzACRAbyAKnVw++a30d6T8T1?=
 =?us-ascii?Q?5dYLkvQip9VCMXvTO+cehT+hZZisrFGxHbFKMYboZQ86V0NFapxVnIsJYXLo?=
 =?us-ascii?Q?lKVt6UP259qUDbpcDpolyDx5mf9QVQ4AYAiydA+orAe7TICPMBpxZ4p+6Js4?=
 =?us-ascii?Q?nDpPUotdV1uX3fpQb+Zx1NT5pBLqS46iLWvOvBf7wxucvF3iG4GYLPqRdh2L?=
 =?us-ascii?Q?Na60VzUm5N50ZdMeearsk6STdrtrIrWSuVh0KnEuTRNshfDKMQ3Nf1VZdups?=
 =?us-ascii?Q?zRVtaBKQ+kwdkdCO+EP2lENGzkHQ3SrA4tLnwJqKMkdddcZ1b8eGAmcrwA45?=
 =?us-ascii?Q?u95B7rFZc0Gc2NoyyGrw+HsCUQx7z++015wU2DTIRwfFtXC8ITBgNER810mp?=
 =?us-ascii?Q?8sx6/JVoDKyQZGw3mWTsQ42xZUPo0Jsp6wCHelxLigMIYytbTzRKn2xAD1VG?=
 =?us-ascii?Q?HBGHPaa0387BsCFkfp5kbD+VlOHfze+PIXdEMNiikVX3yhYIGvwCgQ8rIvBU?=
 =?us-ascii?Q?XTiV+HRs5W2WdkdYaTJcx7aVovsD5JaN3GMa0ofcCuQxwsU9TEBZBu6i1RkH?=
 =?us-ascii?Q?uBNthf4M2CqknlDaIdxVX3oxoiohxTOf6IdJmvKNd/Mr4+88z60F6k10Tyn0?=
 =?us-ascii?Q?gZSTMG8EqLN057G0mDmZuXC1Gi8VEGxA3MGDQMzuEYLnikjylNvrxr2UZmMK?=
 =?us-ascii?Q?wXcw8I5dk9ZPJKBpOpqLpqsViSu7sr9+8XqpTSW07JC1HOq7pmDJ+v5tGOza?=
 =?us-ascii?Q?GgBjPMHWnL4sxvT5WgMpQ7QyX1H9FY0PX96Kw068GTpOtIrO/aj+01x/7svM?=
 =?us-ascii?Q?IXQbaS6WlBhYlmMV3PPW+GapJ8COKgTlWnTLq8Cfm+cDxCFaSEQib3wp1990?=
 =?us-ascii?Q?psSoMUsqHOkZDzTCcHqwT9mUkdy1TSjXosw6ZOb1otuw7AIYVD0Db+VnoL0G?=
 =?us-ascii?Q?4LL6gfn0JfU8zZxyBf9N2Qc6T8VKkTjDnpbKWQYC30cWvSHeC4ql6GP9yb5D?=
 =?us-ascii?Q?UnmJ4mBg/PO8BMijxTgtU1+5fQtz15wqwrqWYuHSh5htOnohQH1ZRDf2G5xI?=
 =?us-ascii?Q?Df9WAR1bUpihlT/vkEsnQeNUe1hrkk8/YXN9vQ8uw+/V58jVf+ecQYrfFm4W?=
 =?us-ascii?Q?60vNUiyY4Xw9/2y074/7RU2cUSO/BqBzq6L3aSABt2wpC8XEVfn6XLLygjpH?=
 =?us-ascii?Q?iDYwE01ISCbMTRQnUqt3VOBxbl+63sBKJhEvgGjT82VS+Dx9EmOMpBYOM4Zf?=
 =?us-ascii?Q?g6rJILYgUEFceEX6bsVryg/NPwAwF3IYI2Rr8fffgrbsS+uxzA7chOgPuhrr?=
 =?us-ascii?Q?t790otH7wlBnJeVxWVIcaNdI+RfNT3C6uL4yZphJ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 784fef68-8498-4904-f96f-08ddb9edffde
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2025 04:56:40.9806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DGEarj79uN+OB5z2f+4mP27AH8rFWYEnpT/sb49MtHfyoV4l2oD1czXSadTITQerV1MtqeG/rEtb5bpHZunIPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9040
X-OriginatorOrg: intel.com

On Wed, Jul 02, 2025 at 11:43:23AM -0700, Ackerley Tng wrote:
> >> vmemmap-optimized folios. Setting a page flag on a vmemmap-optimized
> >> folio will be setting the flag on a few pages.
> > BTW, I have a concern regarding to the overhead vmemmap-optimization.
> >
> > In my system,
> > with hugetlb_free_vmemmap=false, the TD boot time is around 30s;
> > with hugetlb_free_vmemmap=true, the TD boot time is around 1m20s;
> 
> I'm aware of this, was investigating this for something similar
> internally. In your system and test, were you working with 1G pages, or
> 2M pages?
2M pages. 

