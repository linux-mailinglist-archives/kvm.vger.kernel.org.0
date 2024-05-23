Return-Path: <kvm+bounces-18016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 441D88CCBC6
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 07:32:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 673001C211B3
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 05:32:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B15813AA37;
	Thu, 23 May 2024 05:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fEbfrMCg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374382135A;
	Thu, 23 May 2024 05:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716442316; cv=fail; b=JOJjQ/wX8OZqUuHdlxZpsz7jvi1dCgxbKm+TiD/QUI4z7x27lPvCdHHE0sLdrVY5USakGeSjlX4Shp8+2HEgaa8l0AAWPVpL+pO7DFTZWfUYQs8Dc1p0nyy09pRKEZZD38L98VqI0KeRap0yCqqnPRPw5Mnlj6hX/tepm+eOSfA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716442316; c=relaxed/simple;
	bh=of2H+713U4/cuZyY8UbD9uH695vEbwixnsMGrexQ9xU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=MXjpyAalOKX7QMYkeWPn8vWobUXwIEidItruMfAUVITY6PQeCvPYJjq7hhwUDwImTgZOO3g/E1mQ+aME/WwK9ssQB5MhB1BBasSIEbI2JbULABxeYUmiGAwbIncRe5ZsZqc+DKHsimA4XTEZ89ckysbUCZkaK97kE272T7ZS9rc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fEbfrMCg; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716442314; x=1747978314;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=of2H+713U4/cuZyY8UbD9uH695vEbwixnsMGrexQ9xU=;
  b=fEbfrMCgc5IwZSQs+2zDIU7HMOMAZY18LzMaUvXEnsuD6/07uRx8x2XM
   0SiKuG1lDDlMVdt93C2059YAkr/t1wD4eRNBppUhMEwVGZWVwofBK43XK
   sEfeoDPF8lMAWJNxJ0wWDUOuJL82yLhk79gYi+rcHF20XJBmupqUddFSg
   AshGlqPvt6iXsse1lXFId4eSar8rxN+4KQ3wKa9Pn0usCn2qF5aqBYr0R
   JMY5GcMyGZ9W4rnISFO6+OnQ4B2zraIhfWoobCWfVpjGLj1xJ22ekMPfz
   JgoHMNCniemtcxYfRQ5LQXrs0cTpKUlv4Aswz2qIy0SS4mfxJ3yq5Bzcz
   Q==;
X-CSE-ConnectionGUID: 0coNT1ZZSoWircYREdMwlg==
X-CSE-MsgGUID: x+/6zMyAS7efqPDUhBOnUw==
X-IronPort-AV: E=McAfee;i="6600,9927,11080"; a="12848066"
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="12848066"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 22:31:54 -0700
X-CSE-ConnectionGUID: onE0i3MYQGumSDol8naljQ==
X-CSE-MsgGUID: dm4YwkZPRLmD3d+CgQVOXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="38016502"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 May 2024 22:31:53 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 22:31:52 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 22 May 2024 22:31:52 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 22 May 2024 22:31:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IsVrJPobMaI7pvXrkZ6iYgzY9l4sRLNxmvyL+GpLXtmBpFFxhap+RSwoxgtEULBR4pskG4MDj67SmkdZ9dbRcoej5FAsP3v+++05TAnuyAEJN6K2RLew58EZlFnTpd2dSKPzkZxSWHL90UNr9PGhMm4/7R6wizHDSvJ+rquY7GQ7ESWUNt4dRAyzHK7LK+YD7zm3UIEm0DAl9Zz3jP9QgpllO1C8ZDYsuMPJ0af9cUrahLBq2zYEPuEfMkTQAdwY4JXRCuwPqQVyo8jYxH8vgG0xdZv+SPgZikEY3nnT0ghhyEzV2fIQXYVGW7xhScmj04q4tM0rYGcEGPT+GQN4HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=of2H+713U4/cuZyY8UbD9uH695vEbwixnsMGrexQ9xU=;
 b=DbZGIqrt3Csi7w5EfDTSItOmOpwm6oT27woVFoGuHhPUuKrAq4/3TQWvzxWjcphqMgpimq9NJHIEkEkGCI9SJJp6aMaxLwuYhONR4++20V39ohiZkeek4GxiWOwDCOvfvoooK+HLO5AOYDK+VN6Iah7+C0yW5IZDAuV0qJR8OyQD4IWVfxl3W5VUWJFAGHZieMs77ykrueV5vn2CnDBjOObyAabRmd/5nD++Oe1FPzsMQDB9rUVCNDgAGrTAZw+aMC1a2uCUEC8nrgYKDs/Pl8nzdxmH90gMWZh4MFua5UwmSSBoNSzSW0EvwCCeuFJldHXUkh3MvXhT4ZaUzVpU3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH0PR11MB5015.namprd11.prod.outlook.com (2603:10b6:510:39::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Thu, 23 May
 2024 05:31:50 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7587.035; Thu, 23 May 2024
 05:31:50 +0000
Date: Thu, 23 May 2024 13:31:43 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v2 4/6] KVM: Add arch hooks for enabling/disabling
 virtualization
Message-ID: <Zk7Uv9dsoet4TPj4@chao-email>
References: <20240522022827.1690416-1-seanjc@google.com>
 <20240522022827.1690416-5-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240522022827.1690416-5-seanjc@google.com>
X-ClientProxiedBy: SI1PR02CA0006.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::11) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH0PR11MB5015:EE_
X-MS-Office365-Filtering-Correlation-Id: 807f7766-53ea-4583-5b16-08dc7ae9a58b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?KygmPdC97rtu576E2p/PoCAAgdCluQVdgjshZBPlHS0gnt7vKFPvXMRQXbop?=
 =?us-ascii?Q?b+KpaFQUzEkYRezqFMf1zW1yfry5MQhdvdLZSNMRFOQBzXavzvQKZ7ybmSCt?=
 =?us-ascii?Q?IhBQAxYx+4pBeSVojevfjjFxuhxxb4tG0nZUiDCdpf4w2MXtJrdNdAxr3qtY?=
 =?us-ascii?Q?lApaD6fIhRj5Kc8tZbTklqnlroVWpyQYOHEkdVunD2AfoqQZ6sLhguijvfRF?=
 =?us-ascii?Q?cMaLfEZRINLCTOasgqTvXcba/4BT2sX+xTyYwa1wJDhJIDprw71mqFv0LF3I?=
 =?us-ascii?Q?TMPsqA7KwaE7Luky4gc5x2us+kuMt+d9/6jc4XKLD3G3jv0W57wDWxQM1PpG?=
 =?us-ascii?Q?zq9cXaPYYlCOQBAgPsDlPcw2YXT1Djv9262PzsFXrKHBkhGYfq+OLswE4Ej6?=
 =?us-ascii?Q?eFt48dFVtu55MNRJ0r9+qY43ZMLaJrrhFgB6Tf15X/4Rtch4LqNWzTntgfwu?=
 =?us-ascii?Q?wP8NWtqHSI1Hkvht+I5nipZvbmIUJquKLQGVExQrSP6A1AytFK9TM88BBBJh?=
 =?us-ascii?Q?z5mNNhnAgkNqf/n/5Gy4PkqxEa4C+2etXwuaZJXyg61yZd28W+mU+1qKB0zL?=
 =?us-ascii?Q?+uPCXKC93pvuTkLYqP5FwGorUlR43veytqMi2TqtlbS4NJMy+94PAlKkY2bp?=
 =?us-ascii?Q?CrMNlEErksB3busGZQ9vZbbXgqmHqg1ruFdmHhTfokTiFF9ui1CS2D0rx3VM?=
 =?us-ascii?Q?18jDCbMOqgg/lqe750yn23uHMGOdvunDvrubNIJAPMYk88uDiD3k4AbRhoa/?=
 =?us-ascii?Q?+qL3HxBxRK8Q9XepMiGfFF7i0wOMQDKRXb2/NRhZLPQcdiFxFHSTWy7Gly3A?=
 =?us-ascii?Q?HoAQwwsdemzDWYwQFzVUqL9ssB0r6hCg+V6VRLQPKi7PYsp+kZA/0o+zS9V0?=
 =?us-ascii?Q?odjiZYWdHlekkr8712UJqxsiEko98nOSiSoOhHcMoWG5bHIfFMMOZPFLeSXQ?=
 =?us-ascii?Q?N7ZFa7xMWtXfPtnxamniPVwFLhlGBvzp3F7WJ5kXWHT8aPaiDzIwHAwIsGoL?=
 =?us-ascii?Q?QJghDvNk3lCpYNm7bpH+5kNEf0v3RdvQTS8nDZ/9KTSoh0+BfxXXW4BtWC4S?=
 =?us-ascii?Q?31kXEb57ryoCQVa9kTK7qh+iOg8GgzyTiGYOo9tk3H+V/Qb3+2rm+w5jOp/o?=
 =?us-ascii?Q?GzdsuLaHVn6XgO30z28ifLfHXpLYCzmz6dCEoES1RJMHrXTmMXPlhrXHExy3?=
 =?us-ascii?Q?YK5xXJGSsO1iExKAJmwK8aUprSBtiBdD7iH8xqpvXSuDXl03iNEVFHMeBwQD?=
 =?us-ascii?Q?I+nzj88SEGx41cRzQ674378kz+Vxkxofzif57DPc0A=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AtwdtzZJgDVoCYJsCTVGyGlm1dEKah+EULsVQ84flNtKDvOt+WeMROD9t1kq?=
 =?us-ascii?Q?mp2hN6/MzW009Pial8Iyc2q25+GsTyPQr7jIKJbGRHwqIogP2lFMxaoQjQ1N?=
 =?us-ascii?Q?aYWJCF4DEqrwdMqOJOo1uQFRvyrF2qYuzHfBOefYWm6MZknE+BhTWLV3Vabk?=
 =?us-ascii?Q?vGgu8wnv+we1eJMwRhKvGtF+mbTknMsSEif+j1LnEYetKEJd2LqbGE2NlCom?=
 =?us-ascii?Q?q3PhgE9NQnzdd/MGcMtk5jEbZKkptp5j77DdQp4aHn0H9AUs/mLovQTL7Y/B?=
 =?us-ascii?Q?+77eZf9hnfdBZ8fdNGtJR1p42K9CLFWS55vpQlXuIUiJ5I9w7L4ugs212XEP?=
 =?us-ascii?Q?DiFPBAHcxAraadurJT3uI/jaCGtuyjH405jPfQ4iFIXXiXoXDOx+rh7UNR0S?=
 =?us-ascii?Q?icCgLGzh8OqQLGjItvfT+8OYEh3bWS5Dkx9NCRxKbq6rY+/iz2LQW4XKVapp?=
 =?us-ascii?Q?EbmJH6oFsZHSsWb1hzplXLrtx1Zt8D6XvNOcg3Ffho6v45kj6AVXsfIeXl/d?=
 =?us-ascii?Q?KmPsTN3rSNfkW+Mn6AQqaKyvRs5rl1aN4CENz4GZHA+Hb4iWwRFGzzXe+/gK?=
 =?us-ascii?Q?IWWJnsgqajhhxPpacw0foNXrbnsxEU23deCqy3w+j1RX3liPvUAOaBOYBR5i?=
 =?us-ascii?Q?A751Zh2FcvyFJ0COBbB1XWHkoUFn87r9pqF62ZTRmoWCJv1HYSH40628bJpS?=
 =?us-ascii?Q?+PO622PigEmxb++J6OHSEnRB/Xs9lI33ScpfZ7Q9kPNkv986iPeLzhQEIKwu?=
 =?us-ascii?Q?wojEEAcinRvP0Jjbpr4xHRN28XrudZDca0LeJ7w/AgOVjAyi9C9TvuvZmepX?=
 =?us-ascii?Q?kzohExlYgYkNoD/pLG62aFtRJs1OtI0pWYEGXP7S6H/16vTi14RU7wq07aCP?=
 =?us-ascii?Q?UFSA4wi6bjrhwZzyuCvATJLtRP1W7TO4O7tMwjZ6con/4Xv4kDQu5D5FOagy?=
 =?us-ascii?Q?CzOS4Nku/b5bowS2N6gI1jmTYvu/3uJVkgrRrdKAi+XbXmvHcS05litZycP9?=
 =?us-ascii?Q?5KmqFT/nhKjaMRz1pgpOHlhX1SxZ2Oau3wowxeVmEPD4EAXI7xRDqvb4LsxA?=
 =?us-ascii?Q?pxTbhSVnWE+9R8JVpwZWoLAm3JsTwUcQkPvnb+telZiAqjqB2EMBFuZoSqAa?=
 =?us-ascii?Q?0Hz7UC0gFoo5xlhnnWUaWRwkQYv8PTmkmoFdgRa8pmrkDio+Caps51f2gatI?=
 =?us-ascii?Q?QejlIiD3rwpTluswkMl7Be+7hlsVSVogwGid8kd3qAhx9qkfvNMjVRVLS8+c?=
 =?us-ascii?Q?XgdWU2gmNKz6P5Bw+rlll0evZAvQjQfSGWM5XKSUjRuwPs59KNz075E0z6l7?=
 =?us-ascii?Q?3C5VvzkREjNjpb70G0P0zxReXLWc6DRapGKXDcpTExQ1z7ciLOW/22B4gmJg?=
 =?us-ascii?Q?qbezd58x9RE43NoPiEf3OEniYYiVSg9WvUPvY2MrtOaPtiy/apQEPqZAiIJd?=
 =?us-ascii?Q?JeXGRvbfvXGDRu8/2cuUk9A98Mv2splcvodUn3jReSieKFna8pyHrQTtOjZd?=
 =?us-ascii?Q?BcM8SqSCUz13tNtc7GcI8xrLC0MePtS1QvMrBZs2v/DFpMvhHZpBzn81GNjs?=
 =?us-ascii?Q?B9hgLHMRDpyP+MtlxvmaYBLsJDcFU18Ps7p1j5DG?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 807f7766-53ea-4583-5b16-08dc7ae9a58b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2024 05:31:50.4281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 12bPieWQ6Bw+YOfCaDNs9lbD1h377dN5yyhtHGwJAPoLU2UdOriXiww7cN5jQ0zqQChZSvug0tGDPQye5jNsEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5015
X-OriginatorOrg: intel.com

On Tue, May 21, 2024 at 07:28:25PM -0700, Sean Christopherson wrote:
>Add arch hooks that are invoked when KVM enables/disable virtualization.
>x86 will use the hooks to register an "emergency disable" callback, which
>is essentially an x86-specific shutdown notifier that is used when the
>kernel is doing an emergency reboot/shutdown/kexec.
>
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

