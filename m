Return-Path: <kvm+bounces-55086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A7A0B2D1C3
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 04:10:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB0525604C5
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 02:10:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 025AA2BEC22;
	Wed, 20 Aug 2025 02:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IME6mX59"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2461F25F780;
	Wed, 20 Aug 2025 02:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755655824; cv=fail; b=BJP0eBufJeJBX6wffYl8Gk88kQUw03ANCeCaicFPY5tvbIr/pFeOEqcHB1Xzi7YAqm5fJVUN0StVdX/X67FX2CjvjwqnwO5TsBB2s2IYtSVS8rE0oyBXW0am0M76QJ6wvFCfWcWgLqWpcHyEkyYoxm2wPcr/ZJ8cEqKbHRA8a2c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755655824; c=relaxed/simple;
	bh=HCq4nao3Mp9BAlrVNvSE2n1QXJydMSKztTmZCDHHSCA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Cg+Hjaat5ZW+WdLsa7CgcGvpmjGwOaT3fb3CsWrwqNFk3PYixVtkq9nltWZUYOeN5e+ZGRPVybCJ38znf1pq4zr3aK6I+gRg6HL3QZiZ/nta4Yfpvg3M0wsqvDzwBnjgDCcn2o3Oxr5CNkSblwgRBXnXQtHEnQdvvDbFVLCkLkE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IME6mX59; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755655822; x=1787191822;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=HCq4nao3Mp9BAlrVNvSE2n1QXJydMSKztTmZCDHHSCA=;
  b=IME6mX59VQNWDnOLKCLlu2O9IOQUJFGaEr8yxQGtNWTxTZo/7eqLQtgB
   7g7mYRMUktRMRmCUOtSBEtMD8z6l6MzjlneaHV37os8Zo9HgG4ZqG9QoY
   zqYyrw+WPDKuWsa5mP5PYWJu0NFVU57QN8X9+5mJu1oSg8VVpZUe2WrfN
   OrafcOZOwdXKXGjES3ntlqo/B97A4zgfi6QbbqFEdWsnLYzfzpkU0Q+PZ
   F4+l0UAenwaK8NyzqpPL/aEcvzdKZQ+E3YXQjHjhGLIEdM/r2floe9Er8
   AsCqVHyuHhEOho+URmD2KOEZHOkznGvvgjPlti9ch3Va0HNWC3HeeVkSk
   w==;
X-CSE-ConnectionGUID: wI83LSoBT06ND5SKs/sapg==
X-CSE-MsgGUID: gJ4w+/v6TsG8O0c+CXNwqA==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="58064516"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="58064516"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 19:10:22 -0700
X-CSE-ConnectionGUID: zc0K044BSsOsdMhpCUQ+Gw==
X-CSE-MsgGUID: Uo2Iy5CXQW2okaXoeAzl9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="198861156"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 19:10:21 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 19 Aug 2025 19:10:20 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 19 Aug 2025 19:10:20 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.75)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 19 Aug 2025 19:10:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iCmS/ZbW5hwjTpH4AVVA+t6SzyzBggZegup21A7VCipIchizMVGYu9HugPFNYJcvD7LQNo+pHPy+2EYFN67kw8cVFh5LvjvZ1whQu5NDIagMVXir0y4OF7YYZVfkGrvcItcrL1VbYwmYWm40oAb+m3e/gx9gxazafm0qJkTfAehdclQRzgATuoxFPfcwqi+eHuPdY61JMydfOjcPPcvSAGz7kvVcbXdJ3LYf5Ed6BwT1SnV4+KiiBnrNGy+D88XyfA/2h59FElhVtUXAGV1wUdPQybZBqlRFd/2rI2LHV0Vhf+qk26McKIxEPyAhy463mS9kDQ7Hz7YV6hY0S6omUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eY22uxJmklGFens4nRs3QkZFMG9MoMwTcUo5KBcKmy8=;
 b=qO8GbMiKd41dVmhLKmabu9ncN/h+8FjFwL/4hQuUqlnQmGWyfCvQFigptuhjlYW3WU8ob4XJZpw5Gq6RE49bY3cFEzBB2bhKElB4NB+wlkiKtHQ9PB3Rp3NxgJAviDQEVlxmJDeoZGVTCxtHJwldia49flYQGTLbRHZq78pUu6E7VZ2itfLyduWQoAyJZqYfaSCDU1bOt3yGDl3AX7vxL9BxVCHaQW9/Y+IqjapJ/9/zPNX8I6NMoe2+EakwVaQ6rf1cC3IrJ/Q7Tpc5tSXHq1CrdtA4EDM3QFg/eC58z3o/HpOt6eIVWE8m2e3J/ueTZgHlSsl6oKLFdyTRxuNO8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA1PR11MB6895.namprd11.prod.outlook.com (2603:10b6:806:2b2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Wed, 20 Aug
 2025 02:10:12 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9031.024; Wed, 20 Aug 2025
 02:10:12 +0000
Date: Wed, 20 Aug 2025 10:10:00 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Xin Li <xin@zytor.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <mlevitsk@redhat.com>,
	<rick.p.edgecombe@intel.com>, <weijiang.yang@intel.com>, Mathias Krause
	<minipli@grsecurity.net>, John Allen <john.allen@amd.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>
Subject: Re: [PATCH v12 17/24] KVM: VMX: Set up interception for CET MSRs
Message-ID: <aKUueJpCHxC+xmCo@intel.com>
References: <20250812025606.74625-1-chao.gao@intel.com>
 <20250812025606.74625-18-chao.gao@intel.com>
 <aKSiNh43UCosGIVh@google.com>
 <77edb8d9-4093-49fe-963c-56da76514d4c@zytor.com>
 <aKTGVvOb8PZ7mzVr@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aKTGVvOb8PZ7mzVr@google.com>
X-ClientProxiedBy: SG2P153CA0051.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::20)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA1PR11MB6895:EE_
X-MS-Office365-Filtering-Correlation-Id: 4768c667-07ef-4f28-6fad-08dddf8eb23d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?XwUeTjryFK3wXU7O24NibDzHp/YkFAOMPEDX0TvUGVG6pC+XzMyYMJSZ5GkD?=
 =?us-ascii?Q?8WNYqchbjd27PERgQqFShEwuTQGKGjYNBjEe7tuMle3ULpJsr0BJO3Hk95M5?=
 =?us-ascii?Q?3Go/7wlyp59rY2wfyGOz9scrQBChdfC7j3xV1OZRJQYvkT40Gemad65sWzJg?=
 =?us-ascii?Q?IqewUasSpRPyVVr5vUVV6biQAvFj1uwss4kflMRZk2HYlH6lN9W479AVWAwR?=
 =?us-ascii?Q?KDFk8NPcwTSaRdf7D/XV39OHOW3KOJKioJFAwS4JMUO4uywnk+ebMobslaJf?=
 =?us-ascii?Q?Pi3ShTWpTiVh3yKXJh+LOQ2bk3W1VhP4kjvUypsPVZChAd1XHW2J3/hsyCI/?=
 =?us-ascii?Q?kx4a7aAbK6sRdidOG8cjLO9GimwB3fF6BLli3KxeXc2rfTL++efTo4TezIg1?=
 =?us-ascii?Q?4KZ1covVIXjkkPX/8uw9jeGJEkMOUsmcz9TihCg8sMSmW0C+4j5qQ9pP7IBY?=
 =?us-ascii?Q?MJ2vqNAeplQTUmioje3G0hW69ua9iP8nqWEIzWGAHz4boTKp4FiVm2DFOXRc?=
 =?us-ascii?Q?fGJuqRNj+T6skU/hYdD5S2QNtGgNhyjPhwDkWHcFCYFo1ZeYDpW1NylMLqic?=
 =?us-ascii?Q?slKCqHL6uC5UBOUoBnb+frDOBXlp7gYYUH9E8cgvFnpjVJgWKBWxiYIfZkRS?=
 =?us-ascii?Q?sKxrwAFr5yas+ujsDvRzjSveTZI0keBD9SBd95zcj+fV4V4N/k8yp0Okmsdg?=
 =?us-ascii?Q?7tKOutz+2IaM8vu5t6JMr2p38P+mEOVA2bpbr59vvSEPKnov09+ERTwyFIyF?=
 =?us-ascii?Q?XkDqhSIzHgILEbXIZfHdtA/mNgx/mpbb/qI/BtL169NSEOjigec10meNz84a?=
 =?us-ascii?Q?28cjqH+UZi1lwKim8lPw9FfrFU1HKF+FULEgPdso8DQYcm7dWTUTEgbpTSRg?=
 =?us-ascii?Q?tqHBUyv16Xc7/A8fAv/yGnNMCQQFiluJfj2gtd39PVvPh7aDyylfzoI484gP?=
 =?us-ascii?Q?a9HVT4zAj3Yh4e6X5tAy/bIg5X1/F6zANYl4gov/B4IiB1UQEX13Aha0eGZk?=
 =?us-ascii?Q?HVlw3f/xtteTbj8zb7pdsJb/2s3KUEO4nbylY0Dd/lgGWDgj0mA78FfIwm4V?=
 =?us-ascii?Q?010zAKrHkYOb7gEemXINmfZ59CsnSaPI9lVv1JewThZ04DG+yfS+t00Nn3jY?=
 =?us-ascii?Q?VNmabBQOdkYk6mL25Opl9SYCKG3ZK37fHsIEKkZez/IuFYCUHLJ2rlecWsw9?=
 =?us-ascii?Q?hDGrmm4BAcKRjuqM+cjPbGE4HppD0WJ8BaVzLDWPvy4pr/X/PhMiUPqOYuZV?=
 =?us-ascii?Q?2ubVvtLcdMD4+TKdd/Bxan8LUtvzVvgDbbsCjYd03PUjfaufV44xUa5Kc2HM?=
 =?us-ascii?Q?F3CsLJpTSR/gxYJtJa/xSMouUvcYu0tJ1RdhJ6K30IZXmE+tn7oT5yGa6Pfm?=
 =?us-ascii?Q?Y4VVNicAa54t/SwpB1SXxuOnpUAKxniHS4qQxdToROneY3ZSp59ADeQuDM0I?=
 =?us-ascii?Q?tyLSxtqcwmI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k1IN9ITOPU0mtDqPQoAO7tIvK7OvquUGU1ng+r9vfQ7XPDglarJ9NYctyuFF?=
 =?us-ascii?Q?V3mvXgFccBTBaWP0wD0Byz/srkkANub6dRdlXExHXOMDmRDeaqlnIwM8f/74?=
 =?us-ascii?Q?LVeanTNTOsT6GXmzNvweid67YQ82mOyYtk2PD+b/2lOJ7eryWzxDmfIhV8MR?=
 =?us-ascii?Q?RnUols0X8JPLbapiKdInJ3Ls8sWkYnaUoynMusBAC23jAG4/8rhlOkKrurzj?=
 =?us-ascii?Q?/9pNQY40H8yyZ19jJNH37Jo0FmJ+vcDLu5w/O7AfFTCV3kpaOxJDl+pb0lj3?=
 =?us-ascii?Q?l2BJf9ozExDGxWlVgBCL1yMh/AMK7vsjxo+m+0YpxurI4vMslg0v4PoxNp9p?=
 =?us-ascii?Q?hGQVCypWlhAEuqCGDF4skBIYlVHZbw3b5w6g+oIvRI1PZ09n+LWmlScHx6ky?=
 =?us-ascii?Q?HGWk4J8C6pntlI5iYr+BfKReZZ7no33xaO8Z2PXX/3jCAylgPzRMJIJ3UdVL?=
 =?us-ascii?Q?TCPLQLzOItivNI9Bse4CLdLiLnaJuDLxPx4qsh0U0gZcyVbDiUOtnH2v3n3n?=
 =?us-ascii?Q?wXfMYKjGTca9U68e4RgwFYpgKerpG+KsMPKwnSiQ4HvDl4JGx81zaWr3oeDZ?=
 =?us-ascii?Q?ala+0tsoWQLdJGbmxGQpaXC1qv0P9tOGbH8rXgE7BPC550nwfeJvI00Tvnw7?=
 =?us-ascii?Q?oefA57v11NoqC/9pfsHXX5S9kX+IHdE+uup9l3BSJ9BkZkrvgW6ZDsu67N9u?=
 =?us-ascii?Q?3KfMpSnqJhvH87+eTHgBAEYuUs4Gyf80arwG2G/3UDy8S2vjEDTzZcLM7xam?=
 =?us-ascii?Q?PlqMpC49iuVf2tcTPQNKVawfPEu77vpwmfeEZjMToqKYEW8kb2ebK0Mqv+oA?=
 =?us-ascii?Q?Bz839ofbwyVCzrxLIuesTYwM6vx+E1ErK2WTlKExyEvnDlJ+YE/QZiRClG43?=
 =?us-ascii?Q?oNfuVXFYJK2jofI9NtDOk75DCfhH4U5i0tXtSV30cEy7r6jDchq6IL2KQPNQ?=
 =?us-ascii?Q?Rez6Pwdc0h0nkadaWkhPGSmxT2jerf6N6ds2F3l7KNQgZOXtL+j9N9YfcGPe?=
 =?us-ascii?Q?9qFf2JgeJjlX925nUXaxdu3lGFHswJeFCKnan9FRoo6bzzVOaF0KSnfxkYYw?=
 =?us-ascii?Q?BWFg/7QyI8h0hle+sxiAhUEHVHI8XSudbQMtG8RTYYWYENj5LFMRuM6QWLwA?=
 =?us-ascii?Q?d4i6D5hE1rBPzSh0q7yKggVWY6mOiglYVLTHCh/rqMLibOPfm5eVnG8XEwFw?=
 =?us-ascii?Q?DHkngq41pQHQSKxpyQ1tXPyPTYhoZOS64tHwjKk8mp2kYX6rXsJsajcuUPKE?=
 =?us-ascii?Q?/raOSvXPKPmjfrD42VPAUF+qJdRmKbr+PQB9iXt7ZptjUfBu1wFyX/H3+/c9?=
 =?us-ascii?Q?mJkY1RNka40O0aUyTdfAO8fVr334Q4VVkBqfNKRVZNYeSVZE/gy8p31efmN5?=
 =?us-ascii?Q?dfa1x9JaC8pWMl5OHck498iUfwMgPIDw+GsSC1EGAntFX8fizkFQ87q2n36R?=
 =?us-ascii?Q?riGVVBWaoYYDMMrfBZShHCGoboLmYvhx8AFhoymKix+jRPDE3Cf1TF6FVvPN?=
 =?us-ascii?Q?JDEUSq5GiWGte+LFFwcfmMeAf0XGO3cCHcI9E0Hvj9wtw1sqnsz3EpW1aywu?=
 =?us-ascii?Q?8jAdyx3+GmDODji8FuUz+6U270PtZjWfg6czbc9b?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4768c667-07ef-4f28-6fad-08dddf8eb23d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 02:10:12.7179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3aGE69uPVDJ7ad04CmIf+ykrYiRjae1NhAYAiewWYZAlrWXwNKC+ajvhbPUzamW2ophl+FgGDeHYbUcFGGQE5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6895
X-OriginatorOrg: intel.com

On Tue, Aug 19, 2025 at 11:45:42AM -0700, Sean Christopherson wrote:
>On Tue, Aug 19, 2025, Xin Li wrote:
>> On 8/19/2025 9:11 AM, Sean Christopherson wrote:
>> > On Mon, Aug 11, 2025, Chao Gao wrote:
>> > > From: Yang Weijiang <weijiang.yang@intel.com>
>> > > 
>> > > Enable/disable CET MSRs interception per associated feature configuration.
>> > > 
>> > > Shadow Stack feature requires all CET MSRs passed through to guest to make
>> > > it supported in user and supervisor mode
>> > 
>> > I doubt that SS _requires_ CET MSRs to be passed through.  IIRC, the actual
>> > reason for passing through most of the MSRs is that they are managed via XSAVE,
>> > i.e. _can't_ be intercepted without also intercepting XRSTOR.

Agreed. Will update the changelog.

>> > 
>> > > while IBT feature only depends on
>> > > MSR_IA32_{U,S}_CETS_CET to enable user and supervisor IBT.
>> > > 
>> > > Note, this MSR design introduced an architectural limitation of SHSTK and
>> > > IBT control for guest, i.e., when SHSTK is exposed, IBT is also available
>> > > to guest from architectural perspective since IBT relies on subset of SHSTK
>> > > relevant MSRs.
>> > > 
>> > > Suggested-by: Sean Christopherson <seanjc@google.com>
>> > > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> > > Tested-by: Mathias Krause <minipli@grsecurity.net>
>> > > Tested-by: John Allen <john.allen@amd.com>
>> > > Signed-off-by: Chao Gao <chao.gao@intel.com>
>> > > ---
>> > >   arch/x86/kvm/vmx/vmx.c | 20 ++++++++++++++++++++
>> > >   1 file changed, 20 insertions(+)
>> > > 
>> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> > > index bd572c8c7bc3..130ffbe7dc1a 100644
>> > > --- a/arch/x86/kvm/vmx/vmx.c
>> > > +++ b/arch/x86/kvm/vmx/vmx.c
>> > > @@ -4088,6 +4088,8 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
>> > >   void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
>> > >   {
>> > > +	bool set;
>> > 
>> > s/set/intercept
>> > 
>> 
>> Maybe because you asked me to change "flag" to "set" when reviewing FRED
>> patches, however "intercept" does sound better, and I just changed it :)
>
>Ah crud.  I had a feeling I was flip-flopping.  I obviously don't have a strong
>preference.

Anyway, I will use "intercept".

>
>> > > +
>> > >   	if (!cpu_has_vmx_msr_bitmap())
>> > >   		return;
>> > > @@ -4133,6 +4135,24 @@ void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
>> > >   		vmx_set_intercept_for_msr(vcpu, MSR_IA32_FLUSH_CMD, MSR_TYPE_W,
>> > >   					  !guest_cpu_cap_has(vcpu, X86_FEATURE_FLUSH_L1D));
>> > > +	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
>> > > +		set = !guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK);
>> > > +
>> > > +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP, MSR_TYPE_RW, set);
>> > > +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP, MSR_TYPE_RW, set);
>> > > +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP, MSR_TYPE_RW, set);
>> > > +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP, MSR_TYPE_RW, set);
>> > > +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB, MSR_TYPE_RW, set);
>> > 
>> > MSR_IA32_INT_SSP_TAB isn't managed via XSAVE, so why is it being passed through?
>> 
>> It's managed in VMCS host and guest areas, i.e. HOST_INTR_SSP_TABLE and
>> GUEST_INTR_SSP_TABLE, if the "load CET" bits are set in both VM entry
>> and exit controls.
>
>Ah, "because it's essentially free".  Unless there's a true need to pass it through,
>I think it makes sense to intercept.  Merging KVM's bitmap with vmcs12's bitmap
>isn't completely free (though it's quite cheap).  More importantly, this is technically
>wrong due to MSR_IA32_INT_SSP_TAB not existing if the vCPU doesn't have LM.  That's
>obviously easy to solve, I just don't see the point.

Sure. I will leave MSR_IA32_INT_SSP_TAB intercept and add a LM check on its emulation.

