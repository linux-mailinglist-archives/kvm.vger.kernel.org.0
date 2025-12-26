Return-Path: <kvm+bounces-66699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C06C8CDE585
	for <lists+kvm@lfdr.de>; Fri, 26 Dec 2025 06:16:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 77B46300D426
	for <lists+kvm@lfdr.de>; Fri, 26 Dec 2025 05:16:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 146822594B9;
	Fri, 26 Dec 2025 05:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HOYrs6k8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C527B3A1E7E;
	Fri, 26 Dec 2025 05:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766726191; cv=fail; b=BV55pc/FNt+Q6v2sTynL+keXgL2+7IDL+jL5Y8hCivvsVFQEOoP5VEbSvfsjsc6GGEKeNC17T9IO0P+bEufOgFcKwBxR3XzWAg2VOINGz0sDeXV+6V8Vf7KR90qqAQxpwsZXinG1/BW5Zb++QOTo0kFswdP0bQ9baHmAsDxds6I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766726191; c=relaxed/simple;
	bh=LNBRxX8ZIT0V6jeZvBXfHZbmoPM/TvMNuqO/oT0I0U0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LEA3yM0/fEY0V9IIYMMpiVs8rEYiTb4Y6Upim8BhZwLnekJpHcN0YFbYJI5ivpkLuJZOgHzg6tPl8txTvsvrfDHHv3W5gb3e2sE1r9WMOyB6lsZKv6LZL0LPHVMSMTQnmvbi7W1JI5+uaZYs0VORvBEzxOIQjahlS6/J3Tz8n74=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HOYrs6k8; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766726189; x=1798262189;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=LNBRxX8ZIT0V6jeZvBXfHZbmoPM/TvMNuqO/oT0I0U0=;
  b=HOYrs6k8Ws10dxApJA6VfashbzvWkNFUpKLKt3XMesjTkcT9Teri8Rk+
   FjI3lLF996c3qNANnjUaAs9l/WRecH4D4oaU+ZSJv2RNx/YOsvnIMWB+P
   0Dmebly15aWFTYsQqTe2E9h3ysaO7PeQmv/9ERCKkzOA0fk5+K2niHJWv
   Wh0fUydnyGW9ciWaRbhkuQo+GT3OBzc1LGEGB5PvZlGGNuQMF0+6xw47z
   OLSQi7bOH1ljheC9KzfRjQ6nmOQp3U2hRL5r3B8+5XX08EdtVvSvY7lzO
   o4mwmKPGiz0PTEpCuwISeX9iJxw1nzLSI4eYCFgi3grSSpl7jM4/8FVN/
   g==;
X-CSE-ConnectionGUID: nz2hQgyoTxKeLLQpFgbCXA==
X-CSE-MsgGUID: 6Hk7WMGSTEmSd/YBfGP8xA==
X-IronPort-AV: E=McAfee;i="6800,10657,11652"; a="78802484"
X-IronPort-AV: E=Sophos;i="6.21,177,1763452800"; 
   d="scan'208";a="78802484"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Dec 2025 21:16:28 -0800
X-CSE-ConnectionGUID: sZ6F0HkxSSOmStk97VnyAA==
X-CSE-MsgGUID: 1mhaCouUS3WJl3j9a/E6ug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,177,1763452800"; 
   d="scan'208";a="231391738"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Dec 2025 21:16:28 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 25 Dec 2025 21:16:27 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 25 Dec 2025 21:16:27 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.25)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 25 Dec 2025 21:16:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oL/E0jpSuMo99EWznk1H1aHir5NNGL5m+YPTCLUUjcYbOl5vI0EHclJai1i6nwZviLCFtQ4LbS46m9GEiIjbP7Sh1HS7UEshltxIM3wUPg4Gmknxe6kc4wKHD02twBvpRyllyyFJtZqagdSrW9B9O08IpRyq9/5gDXTeMacvKV5kSj0gUGhEulS2dr8meIWIwTkpc5D6nWA6+LyAJvx48yv6GeaiWYVWFn6xNIXidTccRQoibzogxbbU/5/olZTL5M+hk1S2GZhTXd2rxUoD0KTs4/kVYZRbomCHAPestKxrIqmoHPDYthFr5zdpDODbSOQqLKVdzto9rSnAa9gXOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ybqb58fI3mWlamYOUq4zQAxmm1sdEvkdLHhYTQywP14=;
 b=KT9/x1k/STQZuC7IbELGOa/XolzlprsbNnskieDYTR1muvpBryVc+n00NUajOiUE63iVr6mWBNfHJzs/R3DnPbITPlM6LDzkG7lOHcVFs0MRFSxCkRuHY7nm/WAH3LV+l70BrvzsCc5OT0WX8sNgoh+yCsmm25yVOoSNT42OCeTO8RAF6EuyO8aeBPhVsMAIDKE9GeukJfr7gU67XAoRGqX0mf2B3ALAEPg8/qj5Ve6kRRT3qMbaw2vBUHP7dtw6fr/hfFgtI2ObfpskCymjsoP5ky5UH3DJQ9WQMuiaAIC3vHAWo4vx4JF7ag3O9Ial5KufIo1mQ3egonIU837jGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH0PR11MB4791.namprd11.prod.outlook.com (2603:10b6:510:43::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.11; Fri, 26 Dec
 2025 05:16:24 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9456.008; Fri, 26 Dec 2025
 05:16:24 +0000
Date: Fri, 26 Dec 2025 13:16:15 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Dongli Zhang <dongli.zhang@oracle.com>
Subject: Re: [PATCH v3 09/10] KVM: nVMX: Switch to vmcs01 to set virtual
 APICv mode on-demand if L2 is active
Message-ID: <aU4aH/3j6w9Yw1hu@intel.com>
References: <20251205231913.441872-1-seanjc@google.com>
 <20251205231913.441872-10-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251205231913.441872-10-seanjc@google.com>
X-ClientProxiedBy: SI2PR04CA0018.apcprd04.prod.outlook.com
 (2603:1096:4:197::9) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH0PR11MB4791:EE_
X-MS-Office365-Filtering-Correlation-Id: 284aeb2b-c348-4c40-4630-08de443dea1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?CYVzR+XDU46k1rUqaAuqyLbJD02PMGTVmZ8xs714TtNUwgfi5HuHHgwI+kou?=
 =?us-ascii?Q?93FScVNcdGWG9llI9B9JAS2BvO9DaN78XzHKSr2wTGIDL1tFBGYp3A+ClpOw?=
 =?us-ascii?Q?c/Qe930uPcnYNHqbG8QN8I/X9beEd37LzbTeIXauS9W9lK/UU8GfWbFIyojZ?=
 =?us-ascii?Q?Z17jQY5P6Pmj9CxpDyFgA0O32dzqD98k/Yjr9y5RZaC7Yj5Oko7ZZ/pI2dNb?=
 =?us-ascii?Q?WXOGp1WT7ZqTRiwwWMm7uRTW1jmn6eATAdrjRM+lS0+K96s24vgxFXEqZmDA?=
 =?us-ascii?Q?sBxg7xIGIhLB5c3pYICpgkuNKCEWefG+qVpOPjDVehe5imZzisehhtTA10Ki?=
 =?us-ascii?Q?/+jMxY1NpWGP49c9jAmjWPZ9g+ej1HjXn+GM0j3NnXcMeQzIpBESrwQupvj6?=
 =?us-ascii?Q?LFjsHmxtpYVA1rMSG4Lg2SYw/sSxp3fAFaAwRVsifbkRQuBtkxAWtyhBGsS4?=
 =?us-ascii?Q?ogFRHXSREFd6W7CbHRoY6A3yTYFh4BWhhDXERiGuOS05FJTgaORg4wfIlyNs?=
 =?us-ascii?Q?g1/oxLy3+bV0BciE/fci2yEsG0Rm6WgkoHTgYLG3zOEhYay2JW+fqmPaM8uA?=
 =?us-ascii?Q?sMs9CmTBHxEQtTrix5faDYipC+w0lASo4fyG4fyFuqdvkVZniZE2PiOUkpzL?=
 =?us-ascii?Q?ygeYaV8u/Gl+IYmrLP5J14MH2ebuFLSs3qEBrJBkT3Ju1qpdwNUhkqY8B776?=
 =?us-ascii?Q?GILLL+A8B1kHHj32jWQCBTf8U9E6KY8b00WqyQLBKVPYksXitAI9C2/bTGqo?=
 =?us-ascii?Q?W4JRn1zV1jaqqTl1lZELXw+1dNQGIDEn3b7nymdbbTEH/Kvua5A9ZhkkpGbD?=
 =?us-ascii?Q?RyuDuMgkVNEdBVwYsxulPJ0B2YFhj1pDMD5dSDtWXp3nYzxFoHCh4Df55Frz?=
 =?us-ascii?Q?aBSNjkBT4CBwUDiS12MELmjFky27ZA4CROoV2I6DyB1TFjrZeYr2ZfwA6h2Q?=
 =?us-ascii?Q?KjxzQp3we2Vh2CPnUn2OEOkfy3umwmCyd9kkfdKrKA3aselQoGJfoS22f9Aq?=
 =?us-ascii?Q?JsM9z7QNMOlyNDnEZj+xM1+bwikZBf5/6kyln1R+h86B+bUKgXbyL7GDc2GI?=
 =?us-ascii?Q?H2Q7BN/eDZP6LhbZylamR87NbE9tW6mEkytHZibV96EzO7S8vRjegbVIxuif?=
 =?us-ascii?Q?OyPnMI+5MDBQ5KjqJtmMFJ4Q7KtqXDbNhdy+ADlK32n+JYGElGJyoIBvkyce?=
 =?us-ascii?Q?LmKGlNYGHBQV+LLart+FgHsuz3YPlQWOTmFxawFUzV5+fGkrMi3k8M3h/vwW?=
 =?us-ascii?Q?apMrdD07H771q6bh5aOWyxdEXwmmLC50TpuGCCXexcwQoQfdqNfQePOiIiPQ?=
 =?us-ascii?Q?7PfDicXiqPA3tlQRH1QtyPWo+KZhOhIeeUzSQVnzMfDF9GUB02xs8kaiAXt/?=
 =?us-ascii?Q?2kjtxXJ3l2sB39tr0691qFkNBdDQhOryPVW9rD5jMWbikHaGMltwgnwzSpkr?=
 =?us-ascii?Q?KryUu2ot6GWLEoBiSPlJEAURiTpcxouQ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3N2Lo11Wk0HO/O6q6CKGXm8so30h4oi4ZXw+GX+E7OJRqd0J6jsKFCttzDvr?=
 =?us-ascii?Q?zdTKq5+btrg7ldqIK0bID3VOn/efrlWfXBgpz4s968iSqtOXqeJil2S4MnZ8?=
 =?us-ascii?Q?GYyhqc6WaEgGm8U03Y2wr+lcCTILkAEROKi/9GbVzstGTldXuvrUGkF5jshv?=
 =?us-ascii?Q?3TUAGNyEiP8U0SwbY5O1ma4HEai3vevo8MHH6JZDhKnKoBwZYRU5SSiMCP6u?=
 =?us-ascii?Q?b0FmhFH/AsOwgkSQsqwWLO6w9kpsfJzXBBeX+7+nX8XIq4cpKhKvpypwkJU6?=
 =?us-ascii?Q?0D+2L+ReCukQd8Mh6Ty6aFVGDN9stLhn32RzIMZyCdrYILrmQVhkW1JFCq6b?=
 =?us-ascii?Q?L0r0pgzVtJ9/EPQHd0UQ3X2moHRUfgTovpQ2wYCMVa54XWAsx8dY/Hmufvuq?=
 =?us-ascii?Q?Sm3GN2yCBCeDstsi0AGJcio4rI0D4cxljoMy/SlEyRqjYYlud7I55jE9VQEo?=
 =?us-ascii?Q?95Bjicwb2aN3E/2Jho5Hza0yCY/eEfN/rWNYQKxvCv+BGibZarc3F5CKuT2V?=
 =?us-ascii?Q?LL74y89L+gTyZRD+2lpAsZLJ3OzoZ4zki7Yg15lLFkVFwEaTCu6QTCg+hIC5?=
 =?us-ascii?Q?dbWsClN/GL1ug8X/K637hBy9HPu3OE9q7f72ZuX94j5EJUiJQ8oUZPW2CAfv?=
 =?us-ascii?Q?LaSPebSkwqcIuEwnnzxxBPIJP/A6pUrZ+Ik6CDRzbJLgMpD/XHX4LyrRfIkK?=
 =?us-ascii?Q?sOYhnt3QHeNjnaFxmyMcPl6opK8PitwPsQugN5FGuk2+fMy0A6A+923vXBSh?=
 =?us-ascii?Q?t4hsQbWK5+K0dibDEPsPs2w9QJqGR6N4Aqyzi8wXn7SwCXM6HbAUn/Sejgj+?=
 =?us-ascii?Q?ztIa3NjgWAsvlxm6R7ky8ZkyZmNstWLmtpwBxNakDnaH0SiPsCO8wEnFQRnv?=
 =?us-ascii?Q?8SV5WrnDZXAZm7R43C3PJ2D+SRHxBRRDOXMHDWo0giOg7NE/qPByraMQd8PJ?=
 =?us-ascii?Q?9Cm/Vdz7g1bWAT3XdkYuloFKXbbtBlZuIduKOpEXclYqqXclh9lUowUQSei2?=
 =?us-ascii?Q?K8XwJRBrdSQqCzZLtgnlEWNDyWpjdCrHVAZF2c8506JXNmps9tZhucuGr5c5?=
 =?us-ascii?Q?eXC2b3ZmD3sjljBV1JvNMNC5zCqJtJCN9UAvTp7+Z1sLJieE8ZBw+oTcgyfs?=
 =?us-ascii?Q?P4pGPqrgyQ2lxIeK8JQdbqG9ZKK4wPnB1pjcTtXviOKIre4c/loTygdLN0bQ?=
 =?us-ascii?Q?Gglv4iqqrlOmqa4NTo7TR4vHqOA9KX8hM9al4WVC5tac80pIpNIdwWYv7YGx?=
 =?us-ascii?Q?GwPi/35HqnoVjt0NGKrWj0Ss4Sk1OuT7p2KY9s8pvXpG87w/k2wXCpl97Oll?=
 =?us-ascii?Q?Cm4yrlolChfxb7bj9bFyFQN2NuGQZxfzs4nUKY6abAVBpJ9MiJfbENkl9+OL?=
 =?us-ascii?Q?g9W6+RckgVG13RKUJJK1MHg2AjBL6HFyEW5mwifbPqLwyH6vLMr9XuezRNIF?=
 =?us-ascii?Q?diqIgy57/vT0TOp5EkMu8ofOxKmD+ORzf+QgWt/j9qZiwDT3j+7wUwL8tcDF?=
 =?us-ascii?Q?YtOQRFsnwCEd3d0CLnM6TNWTFEY7qhWe/ApAHboLirb7TX0WI3bWT3gF0bu8?=
 =?us-ascii?Q?4GpzpBfZVuqk8hCFT4poTzkRqkL6u7k2T9jPub54qcC2b6AFwRQQP+1xk/S+?=
 =?us-ascii?Q?qwxCDymDnnXdtUMoi+pS2doWzzwMZ4FBBPVXITIimPOIPV4XjggNK32jSFxL?=
 =?us-ascii?Q?jZOmBzyFVnBP0TW3GQ/+Z5EuB74jp8Jd6f80L1SLyjdXIV4oUhZ12JKk166V?=
 =?us-ascii?Q?Fsumpi1Chw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 284aeb2b-c348-4c40-4630-08de443dea1f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Dec 2025 05:16:24.6659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LVP+0uZ9oEOTdr4+2Lqhb2VzEYBWNnKzFOd0bNjJ+WS2Q4gySL/PmBeIk7rbelGsEw2acT04WqJkVmjuxOyTlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4791
X-OriginatorOrg: intel.com

On Fri, Dec 05, 2025 at 03:19:12PM -0800, Sean Christopherson wrote:
>If L1's virtual APIC mode changes while L2 is active, e.g. because L1
>doesn't intercept writes to the APIC_BASE MSR and L2 changes the mode,
>temporarily load vmcs01 and do all of the necessary actions instead of
>deferring the update until the next nested VM-Exit.
>
>This will help in fixing yet more issues related to updates while L2 is
>active, e.g. KVM neglects to update vmcs02 MSR intercepts if vmcs01's MSR
>intercepts are modified while L2 is active.  Not updating x2APIC MSRs is
>benign because vmcs01's settings are not factored into vmcs02's bitmap, but
>deferring the x2APIC MSR updates would create a weird, inconsistent state.
>
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

>@@ -6869,8 +6865,17 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
> 			 * only do so if its physical address has changed, but
> 			 * the guest may have inserted a non-APIC mapping into
> 			 * the TLB while the APIC access page was disabled.
>+			 *
>+			 * If L2 is active, immediately flush L1's TLB instead
>+			 * of requesting a flush of the current TLB, because
>+			 * the current TLB context is L2's.
> 			 */
>-			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
>+			if (!is_guest_mode(vcpu))
>+				kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
>+			else if (!enable_ept)
>+				vpid_sync_context(to_vmx(vcpu)->vpid);

Nit: there's already a local "vmx" variable available. you can use it directly.

