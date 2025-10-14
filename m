Return-Path: <kvm+bounces-59981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F10ABD6FF2
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 03:38:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 8864734FA61
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 01:38:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCF5C26CE37;
	Tue, 14 Oct 2025 01:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oJnuaScO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2007D1DDC35;
	Tue, 14 Oct 2025 01:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760405913; cv=fail; b=oI+JvKQ8j7aEze6dzYZZqjnjFVRNNZoy7nijarRwmuH7oEj4kKZsWr5CFe2AWiNj79sfi2rGRYkmHUCQgkKxYJobbMR1YgA13RNqfSS6Ii+dPOQ80iQojiAO7OXTMm9DAdrqppMG5fkcLB+WZuFWzktTa8eXbfXaOFqppihkCIM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760405913; c=relaxed/simple;
	bh=PaECCrHV+4CNFVsktEQh63baQ34LZN8jLo/QqdefflA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Tgnb29FQpKcfIRqVhEisIDMTj8quaprX5xGqpn3j8Mhz5KYyZnIGLTU1Pv3pWOjQMeN3gXYgOfliQ4HHU8DNBaGuhA+KRd155DY6dDLcyhTKjToZER8Qo5hBErnpp/oM3BZw/iNCcpG+Vuv0dQNj7g2aZwZLxH301/yWeoLBKfo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oJnuaScO; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760405913; x=1791941913;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=PaECCrHV+4CNFVsktEQh63baQ34LZN8jLo/QqdefflA=;
  b=oJnuaScO2AjhTaUqdpsl7nNHjFzyY0zghhi3cEPNR/C4FVNwocTqSUUQ
   rz5iaRUmy8gdqxbaRucVvjon4PFEfnJoD0aFAtN7ILaEEjy8La3aIH51P
   7048QbydJuzlQ20uyFc394tj+b/Ps+IPNJAxqX4mN3UDu5ql6lAMyfQzZ
   b5m7NvPU5SSQcHsL58k9hHEgMftUevih4ew0l5gyLovUp8885cti+EsN/
   Y34H7vr1KsoKJsd2sxfDgMQhmZrQyT25jM81kkTK2N22GJYmAUYDT+c05
   qnxqH6GMQw0P9UAWnYR3U2HMaRSVtmBSK7s4okPeIQVRDwdVVSeSkVhmJ
   A==;
X-CSE-ConnectionGUID: mWJz1u7iQBi71tdHw8Bb9A==
X-CSE-MsgGUID: /AeDyVH6SoibsIN+vXwgMQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="72824787"
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="72824787"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 18:38:32 -0700
X-CSE-ConnectionGUID: gdshuQ7hRJuuR+oYjM4U1g==
X-CSE-MsgGUID: 8lRpwNqqRzqOzPo559zAiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="212715310"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 18:38:31 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 13 Oct 2025 18:38:31 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 13 Oct 2025 18:38:31 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.44) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 13 Oct 2025 18:38:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gnUt0RwniemXQJJQEm9ViCggiRu35FxdH24QQMzgrGP2kGvLiVXoR4MfyBv1zFaOirtUTpepGAFCKgu8HUI/B56AEWM6XEOVJsBXWp5E9yT+tVCX3EdV+Ru+ndMTstaOyO+jBbAPuwtAKU4HxgGbEzY/P1ki0/1T8Snonw32bU7QOhVP5G/DolH2hvm/ynqbCy+a/stURgmKu/j1N5B96fWLYWP6kR0+SAy2gpidVCTefkK8M14bQ0sPgNGU3N/nwg4ebcPT0EaCyeI9dVob04cLjs2FjI1d+WrfjDeilUMLqaQqMfZD3XiqK9DKej4nfFay4GqmjpuifHJmuJmFYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bLjyx5rCxyzK1j53zZb1l3eL1lP7oJz1YfGew3jInxY=;
 b=N/0FpZSGIGQtc76OdAj6AbPcEEHLObFIyTMjyPWvqItO11irWbtB0oFqj8Y71J0mpguMrCc1ireHw2Cr6fg6aonb1cJboHr/tdGcXmGYVswz7u/UQ1HM5rchFmOlJ9psKtWrfCZf+E0My2C4t437ooiG6IZTruyZksll1fGDqm726u6jzyiKnaR3r2QC5vhMUHsJdzuyChX17xzcUB6GwPLuqDFuzvZVt5QHS0z2mQbfxrMmTu1ZO+TdNGuoz3Ql8IyhL23J726c5wn9UcxGb0oocZk8RcxQwyiqBY6gyCBCSdH9OEeSPBkkTp32kkgKVbhJWQuhyhtuigSOO7Vb9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 LV3PR11MB8767.namprd11.prod.outlook.com (2603:10b6:408:215::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.13; Tue, 14 Oct
 2025 01:38:24 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9203.009; Tue, 14 Oct 2025
 01:38:24 +0000
Date: Tue, 14 Oct 2025 09:37:08 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: selftests: Use "gpa" and "gva" for local variable
 names in pre-fault test
Message-ID: <aO2pROT5K+4J7j9k@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20251007224515.374516-1-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251007224515.374516-1-seanjc@google.com>
X-ClientProxiedBy: SG2PR02CA0136.apcprd02.prod.outlook.com
 (2603:1096:4:188::16) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|LV3PR11MB8767:EE_
X-MS-Office365-Filtering-Correlation-Id: e6bec3a9-b922-4464-49e1-08de0ac25d67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?WRM4J6QRrM4HK/2UyLA8uGKVRyEnboh39peRatVgiRcptN+BpZK3yisZWRFh?=
 =?us-ascii?Q?V6lZc7v5oMJG70g+K7zA6twtCsrINR3C3onpGWAneboF+PG0SyjzE6MSiisz?=
 =?us-ascii?Q?c7tZ69ffcuFBwHgF7eUzmA1R6t+ObqjZq8T+uOB/ie3nMPnsaadnqqzzCoSx?=
 =?us-ascii?Q?OJiRlFx37AwAY0+pF/rLY3UD4fNaWqkbIPga93Nf2HcbhgTArlUefzSqkgTX?=
 =?us-ascii?Q?fhwRrqkwPbFyLWFMLvJ7COCKThWPE+nux8ttg3asDM8VvFN5DRCz/7JtONL/?=
 =?us-ascii?Q?O6HizxdO9BmJ3t5ubbKB4hB93moj7nKe5H6qP3vCQf42BvaJUUiH/N5z8i7l?=
 =?us-ascii?Q?obXVgIrr+Kq/ZBpnnx9g9Raq+dsiSUD6M0kruLwbU+u0oWnlsj6/0+C7+iRx?=
 =?us-ascii?Q?V4/EsHJNdLFNpd4e4mWqJpQVM/SW5KksWIuMn3HDJBGZx54jHdea0UVHkIcj?=
 =?us-ascii?Q?xedwZRZMXPrvniU4KF8FLf+hUGjR0mY3IL9O73JJznbGbZYUmOU4aYOqMAph?=
 =?us-ascii?Q?LqYyXoeMu0bOUSgPkjbOhgYZkSOSHZPgNrzGVSs2pIIZ1BT4rcaJPfIoH5IE?=
 =?us-ascii?Q?/jy3GZo1lToKd7HVC45sh+VUWdEXNxpimFQO3vn096T5y4thuERu2FAtrfGv?=
 =?us-ascii?Q?PY/M7v//wz6nlTOSVepTxYf+c0D7UIToQOkAaabrJAi6PggSZT0IhFsQHhc6?=
 =?us-ascii?Q?HswY1P8/5WYhD0XcNWL1S9clka5D3w3ritNMWQPg3c0lCgaLG6UnPb98pzvr?=
 =?us-ascii?Q?LAQdp2EGiwt86iAsD/ZrzQd6u1rxa8chRKtvw1Xu1p5gahoGdnKGvEAAWLCx?=
 =?us-ascii?Q?lTeWl21OjP8EnKtjZ+HBuOtwAmyKnxQaWKeDehELcTCh7liGbx5/MOqE/koa?=
 =?us-ascii?Q?s+PB5zL9ggD/zZBE55/0Tb2zYXDEm4zYSCASch3i8EbC/xAZQOHfOTgifJPe?=
 =?us-ascii?Q?QIY06gBORD1MJL75HOrBcTGDMVtrkrT1VbE3WQhD45gu2DoVyGs/DN5OD1Sn?=
 =?us-ascii?Q?Pe4mezEG05VjGbwQ5HZZlFzwoFWJXy5RSXYfcFCxw2YAE73YqrO2i3O91vrs?=
 =?us-ascii?Q?pdZGx0RLSt6RUekN2UBDiaVvO3BEIbKrUU2350TQvy5UixBukSbwkRhpnGZb?=
 =?us-ascii?Q?vZGmJWPAzlKPP8YergOKTbkPCIRwI6jwlj7DaXieCW0XpFszBqO+TC8Bkafy?=
 =?us-ascii?Q?ybuuNzgsvZpjFHfTWKeXo2GfMKup4Nxxy9picHOxHwW5xQvAFsQXVlylZKqr?=
 =?us-ascii?Q?xCvBlP/Tfc4xwQB+yRli+c0JEbrFSzhtKXtY8nXCXo8zpZdJpL2Wd3ofxHwZ?=
 =?us-ascii?Q?9MZfZt0GAicdfxTYyKDM9o1HkTFcw2O3M4px4hPjUHLg62FHxEC74/4lI2kQ?=
 =?us-ascii?Q?bUaezWXN44ievy07R8Q2/uhTRHyWR3jEA3NhcbPESls4ju+hcuOP0ug1nFp3?=
 =?us-ascii?Q?ZT8OCdofohWdoHhLK63lVPCtHmJoQl6y?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1RJei5yuqMEvoh3XTvTzeU1NX6OcytPCe+Ikgl35JUTcpHXLKOHNODIIf0f9?=
 =?us-ascii?Q?hIRKzAwbUkzpKrYeMTH7bxaZnhSlYooUMIqTvCEK7BASeMQ+mUiGuKbXLrwp?=
 =?us-ascii?Q?m1TDck75KYBiw1Gj6dyEnvFinYh9Up0Apcx3qAukuGd/TUwQnRO0FsQ3TBYD?=
 =?us-ascii?Q?ajtKwurvj1iB7fg4Vm94OzoWHbZBIg+W3oejJcfuTppsNjJcbIJ3HNceCvCp?=
 =?us-ascii?Q?ksBiO7mbMHPv+SwcgxtqmxDea5A7jl0ihfeXL0PwO6FLDmhbThdOeO0A8NQy?=
 =?us-ascii?Q?dF+wtC4RE36lK0zDJ7wIdxCZsFjw7Ws/Q8Q5kdH1aLs0s/L1FKesOGAi4+j/?=
 =?us-ascii?Q?6oIXI1mpxyuKncPC38FxJ8j6QG2S4tgaTrdg6YJ2/nsabVMox7/wVZq3azdF?=
 =?us-ascii?Q?QHZ+CXELQvwZllvC7fqCZsDlD+4MKunXdVCETqtVOOp4RyU3jmLxy3yVZsWD?=
 =?us-ascii?Q?xZ3dwcX5Q7H8fLCdLxDSD9i4/2/NgNNkhd028L3fwvRX2VRM/pbVBVd0CK2B?=
 =?us-ascii?Q?ig1BI53ZBBtYtp7M9gTvnKOCL46zMLesNgPz+oK5zoyNWokiZoQ6nLT4usoN?=
 =?us-ascii?Q?Nawpcqs0i0pkJjkTs+sLOcTzOdLF16/X91SDWfu5J3vJlvPzSgz7n996I1zt?=
 =?us-ascii?Q?Nw4PR/D+nQfkUBtztUq4OMlcjybufNbsh7+316AGVEblveNjw0r2a6hqKLZ2?=
 =?us-ascii?Q?BiUdPZjjGkdtZu2HTJPcI2EOPsK6FHqCJ+M1Vq53ngKprqfXubwhYznFqoHA?=
 =?us-ascii?Q?V5bgGuTmmhKqXQpQTA1KAtHL6FgzUGY55FInGMFV9b/+h3vRLuPBr56iKlPn?=
 =?us-ascii?Q?4vJnuaoDbBDKTt99s1OPRsOepFhPDH1jhG0sQbRfJhUOxJFPjCfLaXoWJQDy?=
 =?us-ascii?Q?YYSyyPZCpC5z3cYxwzBAP7/Pq++TyMn56bGc7gL+j0LEA5XgsXlWlg/9zgBO?=
 =?us-ascii?Q?LjelYHo7dclXbSNCOOl94AvkYTE2UmmZb7ZVW8bSaaUD6QS+2EK3U5w5ONf4?=
 =?us-ascii?Q?e30QuC0fqjBh3ET2vmTCFvmQXz4rcEQTTQ7gic+Co8Bi+hwZ/E4GMPd1W0Ol?=
 =?us-ascii?Q?ekTuYcwMtl0u8YaK72itDTbRlUD/xQVWLh/q7bviKZtecSOM4yGRv9Q41DmD?=
 =?us-ascii?Q?uN+PTCb3fsbZn7qeGDR75htxI5raGq4o7yOotCVB3s404R7Ep/SPCcUlDV4Q?=
 =?us-ascii?Q?iBx8CbBVzJIku0Hx+07eNuulmTF+1SiELosbW/FWGb2KcL0vIKyHtYt2ZKbL?=
 =?us-ascii?Q?UzIn5g9WXjXqRWLvWRjODGbxwwTuUMGRd0jy+GiqqN1QgMpx9nIjQNlBq5gs?=
 =?us-ascii?Q?n4tmLxuCEluJGTzzXfZY30jON9S3JTunbGleBFesISeJlU6xRkEBBn9Fq0mL?=
 =?us-ascii?Q?0SDGseVYHq2Bu3nC+gZfGnMdJfnt5+sTGeoth4ENBsOxT3KUaLTVAEhpUmks?=
 =?us-ascii?Q?o5+qy0CqbZvUlGifXm4FkqBmJUlYRgjdllA4/tKaGqVIttU0VrmmCQH5dcnt?=
 =?us-ascii?Q?Cxm881HBL4UzfOmAnTgPil8em0mKvtPB5ToZReOQ0CKjx8AfEE4LfzXO40Uh?=
 =?us-ascii?Q?7On5/KCNpCFBaKSxJ1MZjBmfmcnB35TyOyHqN3LC?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e6bec3a9-b922-4464-49e1-08de0ac25d67
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 01:38:24.2146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z0MzdgsDoqH+3KirdzURPsEt0XZ5Hk0RiA6bym241PaZ5oOqBEsD4Ng/82tx8vaTM3FH7Cp0PbU8Q+iwWL83xA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8767
X-OriginatorOrg: intel.com

On Tue, Oct 07, 2025 at 03:45:15PM -0700, Sean Christopherson wrote:
> Rename guest_test_{phys,virt}_mem to g{p,v}a in the pre-fault memory test
> to shorten line lengths and to use standard terminology.
> 
> No functional change intended.
> 
> Cc: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../selftests/kvm/pre_fault_memory_test.c     | 27 +++++++++----------
>  1 file changed, 12 insertions(+), 15 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
> index f04768c1d2e4..6db75946a4f8 100644
> --- a/tools/testing/selftests/kvm/pre_fault_memory_test.c
> +++ b/tools/testing/selftests/kvm/pre_fault_memory_test.c
> @@ -161,6 +161,7 @@ static void pre_fault_memory(struct kvm_vcpu *vcpu, u64 base_gpa, u64 offset,
>  
>  static void __test_pre_fault_memory(unsigned long vm_type, bool private)
>  {
> +	uint64_t gpa, gva, alignment, guest_page_size;
>  	const struct vm_shape shape = {
>  		.mode = VM_MODE_DEFAULT,
>  		.type = vm_type,
> @@ -170,35 +171,31 @@ static void __test_pre_fault_memory(unsigned long vm_type, bool private)
>  	struct kvm_vm *vm;
>  	struct ucall uc;
>  
> -	uint64_t guest_test_phys_mem;
> -	uint64_t guest_test_virt_mem;
> -	uint64_t alignment, guest_page_size;
> -
>  	vm = vm_create_shape_with_one_vcpu(shape, &vcpu, guest_code);
>  
>  	alignment = guest_page_size = vm_guest_mode_params[VM_MODE_DEFAULT].page_size;
> -	guest_test_phys_mem = (vm->max_gfn - TEST_NPAGES) * guest_page_size;
> +	gpa = (vm->max_gfn - TEST_NPAGES) * guest_page_size;
>  #ifdef __s390x__
>  	alignment = max(0x100000UL, guest_page_size);
>  #else
>  	alignment = SZ_2M;
>  #endif
> -	guest_test_phys_mem = align_down(guest_test_phys_mem, alignment);
> -	guest_test_virt_mem = guest_test_phys_mem & ((1ULL << (vm->va_bits - 1)) - 1);
> +	gpa = align_down(gpa, alignment);
> +	gva = gpa & ((1ULL << (vm->va_bits - 1)) - 1);
>  
> -	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
> -				    guest_test_phys_mem, TEST_SLOT, TEST_NPAGES,
> +	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, gpa,
Wrap at 80 characters?

> +				    TEST_SLOT, TEST_NPAGES,
>  				    private ? KVM_MEM_GUEST_MEMFD : 0);
> -	virt_map(vm, guest_test_virt_mem, guest_test_phys_mem, TEST_NPAGES);
> +	virt_map(vm, gva, gpa, TEST_NPAGES);
>  
>  	if (private)
> -		vm_mem_set_private(vm, guest_test_phys_mem, TEST_SIZE);
> +		vm_mem_set_private(vm, gpa, TEST_SIZE);
>  
> -	pre_fault_memory(vcpu, guest_test_phys_mem, 0, SZ_2M, 0, private);
> -	pre_fault_memory(vcpu, guest_test_phys_mem, SZ_2M, PAGE_SIZE * 2, PAGE_SIZE, private);
> -	pre_fault_memory(vcpu, guest_test_phys_mem, TEST_SIZE, PAGE_SIZE, PAGE_SIZE, private);
> +	pre_fault_memory(vcpu, gpa, 0, SZ_2M, 0, private);
> +	pre_fault_memory(vcpu, gpa, SZ_2M, PAGE_SIZE * 2, PAGE_SIZE, private);
> +	pre_fault_memory(vcpu, gpa, TEST_SIZE, PAGE_SIZE, PAGE_SIZE, private);
>  
> -	vcpu_args_set(vcpu, 1, guest_test_virt_mem);
> +	vcpu_args_set(vcpu, 1, gva);
Should we cleanup guest_code() as below?

-static void guest_code(uint64_t base_gpa)
+static void guest_code(uint64_t base_gva)
 {
        volatile uint64_t val __used;
        int i;

        for (i = 0; i < TEST_NPAGES; i++) {
-               uint64_t *src = (uint64_t *)(base_gpa + i * PAGE_SIZE);
+               uint64_t *src = (uint64_t *)(base_gva + i * PAGE_SIZE);

                val = *src;
        }

>  	vcpu_run(vcpu);
>  
>  	run = vcpu->run;
> 
> base-commit: efcebc8f7aeeba15feb1a5bde70af74d96bf1a76
> -- 
> 2.51.0.710.ga91ca5db03-goog
> 
> 

