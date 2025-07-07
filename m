Return-Path: <kvm+bounces-51634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ED050AFAA26
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 05:16:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 70F6418937D6
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 03:17:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3400B256C6A;
	Mon,  7 Jul 2025 03:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XG1VsW/y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639EE2264C7;
	Mon,  7 Jul 2025 03:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751858208; cv=fail; b=Mt43sx1IfR+BiZe3NKKI5/MnI7vic91wC8Nz94EH09QN9riYYyDzn67XdnO5u1bOMVPzmoQ6MrAFNEtMSG5hoQQgpTHZe67zTu+zwRnQZ8EzStVDgCiFFw0gv6wuUEj3qNJd+N/hBTzs3CXsVIEdEhuvzcB6cQ4zJG1ejV24cpg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751858208; c=relaxed/simple;
	bh=jH+AlRWtIQukd7neMErmLodnI25uxAC8AO5f9U7GCpA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=csncnQ3f4/upYVOOMgR3lNYl9OUNyBt+CpLSdkYbeE2nI5GhSF+vyqtjDLzfM82a4qB9qBS/0HSeZL2w9DrWGeQMNgXAdWAxf9dkxjLW8Vc2xEHAI1C7LAyghvoW80y3TsQA80qvRTRyFqU2IpYnTgwp/d99zMj6o9UXbioUxUo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XG1VsW/y; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751858206; x=1783394206;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=jH+AlRWtIQukd7neMErmLodnI25uxAC8AO5f9U7GCpA=;
  b=XG1VsW/yr9hOJvFuf81iUT4ZTm9foY+MJ1wl4Ru9iwlMvmSP3PZZFRlT
   QG9zi1rKQsr5ZAyn5kacHZ1+pj6hqAM91yE0XgcYC/owSWBTusUhqCL8i
   kp0T6km4iFJW1s77c/gue5Vgyp8c+9q4D3++mCDLz7LnhVy6h32cq2nbn
   xYEjjfAef6KA+qu3HgQAaAy/avKgqtqk02zEXfdkWGSJWTFjEZY5QhBxS
   wyMsxCmCbFtO4JAHLrLglXFLJ6mH0lkZkmyXi15WJv5Y0WRe6vPrFVw7o
   8wBXfC1VGaI1fQttzYTEKR/FyRyBuuhMSYu8HKKpkKuybtEOzt0sq2POL
   A==;
X-CSE-ConnectionGUID: ByhgwQQaQs+Lmz6oylcWxg==
X-CSE-MsgGUID: pZFWtQyRT8ymIRunx0GexA==
X-IronPort-AV: E=McAfee;i="6800,10657,11486"; a="76620868"
X-IronPort-AV: E=Sophos;i="6.16,293,1744095600"; 
   d="scan'208";a="76620868"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2025 20:16:44 -0700
X-CSE-ConnectionGUID: AQ7c57FyR0y2rdrsEgFaIw==
X-CSE-MsgGUID: BrMBpQ1kT7i7oTBLuVnCmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,293,1744095600"; 
   d="scan'208";a="155678385"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2025 20:16:43 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 6 Jul 2025 20:16:42 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Sun, 6 Jul 2025 20:16:42 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.75)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 6 Jul 2025 20:16:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RA56NcZIcrMc5r3SmrJD4RfommALVHHatxVAZfTPGEosnj1seqT/PVI25o4JIZQIQtIczdDpCirlG+iMy+YkMocKeJS0FZp8ool3cpuBv+x8OO5AoSXCh0N7I9UNixDgXd2YGvXXBZDHV9Q+rVX5CS2XSUFc2DQzdITvw0xGtSPP/kD2b7FChhVRfNX+Wv+jAJBSsri/Uv6DdrsYtvl89cXPpszlaUUZh7zoTpyo8n3s6HjLSmRvqoVD/1yZ9V2BWo/teP0mj6QTbO4Th4ypMG35FbP+Xk2MZo5nx5+MkTu1KtdsRTkz74J8N7QpQiIW93BCuRtcLW/hV8FpbAqFlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d6p7IknC99Hdvm8k8mjRPUX7JBc0edj7WUE6A3N8UxE=;
 b=Hyyinr7PYXWNz6qUcQjZ+qbX1XR/7npYfkMM+sVIIfDw+cH8OtsEJ4Bk9Cj8j2nhM11ZqbejA6Hu6s3VU3Gx0bsQB/0QBbzBlukeUTLkvtX+6RY02FoORjpiSiuEwqaNAVNlRJ0BVh/JbyqqQArQW7KBRJ0CY8xui7SdNNtM6RzZKIW3/qDa6ox2waOSgSkqaO3vPBgNpa8ulFPKu3W45MRRl5gfuGQGl1X5bN+LLwccmf/I7rcWjGUH0r328vBcqkHB/tUZ7Kt3/dIaPuMp9FFYEJzU9g0CfAjSW/5u2fCYqHvue7uOF/kAKvbozhJet4mkAx2eErdRQWtRxVC6Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH0PR11MB4967.namprd11.prod.outlook.com (2603:10b6:510:41::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Mon, 7 Jul
 2025 03:16:25 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8835.025; Mon, 7 Jul 2025
 03:16:25 +0000
Date: Mon, 7 Jul 2025 11:16:12 +0800
From: Chao Gao <chao.gao@intel.com>
To: Adrian Hunter <adrian.hunter@intel.com>
CC: Dave Hansen <dave.hansen@linux.intel.com>, <pbonzini@redhat.com>,
	<seanjc@google.com>, <vannapurve@google.com>, Tony Luck
	<tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, <x86@kernel.org>, "H
 Peter Anvin" <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
	<kirill.shutemov@linux.intel.com>, <kai.huang@intel.com>,
	<reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<isaku.yamahata@intel.com>, <yan.y.zhao@intel.com>
Subject: Re: [PATCH V2 2/2] x86/tdx: Skip clearing reclaimed pages unless
 X86_BUG_TDX_PW_MCE is present
Message-ID: <aGs7/C0W58nEUVNk@intel.com>
References: <20250703153712.155600-1-adrian.hunter@intel.com>
 <20250703153712.155600-3-adrian.hunter@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250703153712.155600-3-adrian.hunter@intel.com>
X-ClientProxiedBy: SG2PR04CA0152.apcprd04.prod.outlook.com (2603:1096:4::14)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH0PR11MB4967:EE_
X-MS-Office365-Filtering-Correlation-Id: 74be2a56-3d1a-4081-3c26-08ddbd04a7e6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?eJqAzFwvqV9a5n68NI+23I8rO4ViLE/ulaH3ClRNtX8Ha3OQuCru1xCNYY6o?=
 =?us-ascii?Q?8J2eiKrEHkNqSt8LKsSaVxhL3cQwkuqDKXs9YJ6x8TtOqb61BhNJFYD9f7DC?=
 =?us-ascii?Q?kEJDdX1yUVivxxJaQFAGiOk2WbHJzSHNLYp3uoaMhfrF3k8gmDNofiGFB6CG?=
 =?us-ascii?Q?91f90O7BmofD0iyiep5OSa4kPHkPshm9MjsMtW6IZAkYzfaz2Gdo2wWjI5By?=
 =?us-ascii?Q?JmPQrZu8t5R3BBuKaqYjzhS0d0015mD9VedBi9HQh9vxZbTjtvQ/pipD2+by?=
 =?us-ascii?Q?6aBm41x69OFG8jdt3q+E1DabiG9vYAs6PuOUE3IiidS3FtWrdqHgl0vmUW6C?=
 =?us-ascii?Q?5DnnbYbbsIGIfocg5bB3ZG3gmm2Ju+LiC58Yi6ZfDnDmEKZZ6+AmJAzgbTIL?=
 =?us-ascii?Q?z3mLx6Sy7GKbShgA4p5gcGmCwZYtSihPkBYIRvFPzxqbhSmCXcCm8WBdoH0V?=
 =?us-ascii?Q?T352Z09E3V/ToYx840vS0pPIbPgf/F1gYKlwssfjdwzyf2zsbaNdaWQBSa+s?=
 =?us-ascii?Q?4nZlELpJyleu3ZhLB3jjdH3t2gaPIOPXlFtB8vIc2BZPDyWkQoqYiH6z7Fon?=
 =?us-ascii?Q?KORaT0b9BJ8R2VNJrsK6MJORwa9djylCseLOD1eKyzEHIXXrNl2nfYaNubXO?=
 =?us-ascii?Q?+rnEafVkNAKsMP5hgoRlBuy/qtk2AVatZKmng4Pa+ZFCP8H7U7/Wpxz+4taP?=
 =?us-ascii?Q?uKsf791K0zkDCfzz1j7/wAtWfLRYTAx3BLWLoUf3ujsw8J2AOCjuYuDjaABC?=
 =?us-ascii?Q?X+PzHcqV88MH4IsjoC5oa1yQ1SZJXIDp8tMgwNRqHbwT+4cS2Z4R6Bt/yKsa?=
 =?us-ascii?Q?K4RtynyW0rg480CEezigqun/OQgBxBKCFETILnfwChdbfdQGUr0KzIxVvOMF?=
 =?us-ascii?Q?8Qq9+myHmQYttESBNH/4InhlrFJNG/8Uxnx8FnkzYZvTXgdBv86VqmM5R58L?=
 =?us-ascii?Q?oa0jbhAq0OuUwn7rLWVvnXJT5uQrKN+vq4V38s9M2kYZv14jBQG+u8xtFzXn?=
 =?us-ascii?Q?IyJJJ+LyyUMd0t6Murqx0wk8cPGUGYU6bHjy8TomV0XfemajmhiEFSjTiwXJ?=
 =?us-ascii?Q?bB8PthkTphSRNhb9vrN5fHHMVSMn+PKv9FqGCXWOL+P1pjsfgv9TA4WMDy1u?=
 =?us-ascii?Q?I7FPgb9Trv9kE7+E44YVh5YG76z/Ux8gjH4UPQwEw9Zajbi/2XUH0DWiG3x9?=
 =?us-ascii?Q?Xiz8by0Enkqfg/YWSB+moA0ldKztb6+stkYtFfXCLRRGVrgsKsNPCqxAyXyy?=
 =?us-ascii?Q?M7xUgG/e44/WaoVXoAZFyECjGgrNxOiCz0o4MFKDnzoolELn9UjV3Z5JfApN?=
 =?us-ascii?Q?ezULTvQIlWRWN081YaXNFvIT95cSisjEKBO5rynD31CwpvzZrHHms/1vcmS8?=
 =?us-ascii?Q?P2OYw1mJKlL1bDw9msGvfKzZz8BmhkbT8xWRrc5t1NL/AK8Ds6xOHvmH4Syn?=
 =?us-ascii?Q?GprWQvfmDL4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ry5psarMByASBc2CTfc25KWOMsDTHEepU74yBUrT8PC/ZHxI/Kcx4InT36tx?=
 =?us-ascii?Q?BnC7NDOnn3qf58Y6L7Kma9ZfLdvR169ed2+xJ1WaEVHKcL05IzgGfEKvginZ?=
 =?us-ascii?Q?LiXD4/KcA/dCstSvxckJB4WCHMuU36yQxBcVY+SRDxi3WOfRFpjNmlNPm5Ad?=
 =?us-ascii?Q?V/E+dWGT884xD9yRjirob08Ht4WDLWaufR/FPyf5VMvxRhP48DI3hZauT183?=
 =?us-ascii?Q?Qfspuii03v5mra7RK2hcs6MXHe3u9tTE1ny+vX6EJCjAKv1ixwF1E9jDz/hx?=
 =?us-ascii?Q?YE8ed7WTKCHhmQgjXeJRvjQq68LQyZemvok6CSx6X3NZZMQIRG/QXfPbxGuh?=
 =?us-ascii?Q?ig/NL7PzrQE+8XIoIu0S9tTVARF6MOZo/TPkfK9I9rPwTCaIFyQZDgBkKUpZ?=
 =?us-ascii?Q?gUFuIJTgYbUcxme/tHWs2b36tWt1+zkVlGLSNU5vHfqkV4NDkjAJhi2jK/ov?=
 =?us-ascii?Q?GWuIBlMQy4INvf2T9zk+RGPf12UWly4e40PapbLrj6pzgukxMzwVx/dTyGid?=
 =?us-ascii?Q?pETUogdbhHhNZ3iH3bw5Qh46uV+WLlSTAsezUYNOUB47jsFtljoev8L1Iywm?=
 =?us-ascii?Q?j4Dho8rawMVbeV4QPs46qsL2t5jRMAoZE8CpLB9iUDLLaZ0oO4R0//9X0v+J?=
 =?us-ascii?Q?X2eLgV26S1cgy9gq5BH/+Z81T9ZxK8bU+yLo8Ogu3IhkC69EBZH/0aBmuCly?=
 =?us-ascii?Q?ipMUS51v5NBY4w7kGjnHb9ghPYoefHqApcX85sIsaIVeAbwwoTfzcZxClp+t?=
 =?us-ascii?Q?7LOS11SzbmYHzwKTo+4whYem/NjfEoNzKYTuUsIcrxdm94fS/oTRbITthE4P?=
 =?us-ascii?Q?c+s0LcI/svVtq8Ee4DkuTM5fbYMvBg+BqhncVDQ2utjsq0ugbfjn0CgRTFVw?=
 =?us-ascii?Q?Fke8YPFC8ANWb7X9oVo9xfx7FKvxf2ZPjSTU3zkYoHqSV5W6bFWkIMda3QW+?=
 =?us-ascii?Q?rMZrCxpv4+G63oqvlzGYD0RG9rUAwNy3wp2Vdi/RlGPHuRIBnLdn0SfJG8sH?=
 =?us-ascii?Q?ULGaOSt83uXDZzGnOiAg+GvYGguRTo4vblN4OY+FIekXsgpqFGGJA7XAv2jN?=
 =?us-ascii?Q?Ej7NnTVN9xfy4SX8i4qO+f+4avwyrwvzjCFQmBtlNHzGOnec1grgkTB5j4Qr?=
 =?us-ascii?Q?uqB2LOlDq7M+PGzNuDZJbnC9aBkKS57dk2atZfpQmIzK7uBeU16fA0ZzsDzZ?=
 =?us-ascii?Q?a+wTb+SQ7SK19qlcRbU5tsQKg0a3Vzs+0QcK2PLN2pN7VWWYjn6faDiPzaS5?=
 =?us-ascii?Q?l7PCwiDjb+agA0B6x+DlEC/YvYPBqwZOR8sJNaOpfyAKBt0pVA9NvJBf6xpN?=
 =?us-ascii?Q?Sc12UB8sko3p9M69Py3du/KmEvBSU62P6IQ3E6n2jH0WrSY5XftI1937+89y?=
 =?us-ascii?Q?E3UyJA3IuxQwUnWYGxC4CMhlvnZurWKpOsMiB4PKcj5FGs6B6gAj3vzvo5M+?=
 =?us-ascii?Q?VBlYPLbkh9tR+tGvXOyYxylCs/UNkTCBcLDK624d5Pu4YBFfR11UfSMlK84m?=
 =?us-ascii?Q?AiHPH2jisHvMX+E4L79fxS8izD/qDg2byruRJWo/74ocLcjPWe4yJIMDbaNZ?=
 =?us-ascii?Q?PBT2Nlwop1AKu0nd/8jRTbpjqYZWeqm2f+/CLf9T?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 74be2a56-3d1a-4081-3c26-08ddbd04a7e6
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2025 03:16:25.2038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mj+uJ6yZ4kt29Ou0VB0/PaTvK+BKlTJBU3eLKWefoip+O3oOpxjWSPNAW/47cK3He6aVnb85RPYpSodQYCrs3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4967
X-OriginatorOrg: intel.com

On Thu, Jul 03, 2025 at 06:37:12PM +0300, Adrian Hunter wrote:
>Avoid clearing reclaimed TDX private pages unless the platform is affected
>by the X86_BUG_TDX_PW_MCE erratum. This significantly reduces VM shutdown
>time on unaffected systems.
>
>Background
>
>KVM currently clears reclaimed TDX private pages using MOVDIR64B, which:
>
>   - Clears the TD Owner bit (which identifies TDX private memory) and
>     integrity metadata without triggering integrity violations.
>   - Clears poison from cache lines without consuming it, avoiding MCEs on
>     access (refer TDX Module Base spec. 16.5. Handling Machine Check
>     Events during Guest TD Operation).
>
>The TDX module also uses MOVDIR64B to initialize private pages before use.
>If cache flushing is needed, it sets TDX_FEATURES.CLFLUSH_BEFORE_ALLOC.
>However, KVM currently flushes unconditionally, refer commit 94c477a751c7b
>("x86/virt/tdx: Add SEAMCALL wrappers to add TD private pages")
>
>In contrast, when private pages are reclaimed, the TDX Module handles
>flushing via the TDH.PHYMEM.CACHE.WB SEAMCALL.
>
>Problem
>
>Clearing all private pages during VM shutdown is costly. For guests
>with a large amount of memory it can take minutes.
>
>Solution
>
>TDX Module Base Architecture spec. documents that private pages reclaimed
>from a TD should be initialized using MOVDIR64B, in order to avoid
>integrity violation or TD bit mismatch detection when later being read
>using a shared HKID, refer April 2025 spec. "Page Initialization" in
>section "8.6.2. Platforms not Using ACT: Required Cache Flush and
>Initialization by the Host VMM"
>
>That is an overstatement and will be clarified in coming versions of the
>spec. In fact, as outlined in "Table 16.2: Non-ACT Platforms Checks on
>Memory" and "Table 16.3: Non-ACT Platforms Checks on Memory Reads in Li
>Mode" in the same spec, there is no issue accessing such reclaimed pages
>using a shared key that does not have integrity enabled. Linux always uses
>KeyID 0 which never has integrity enabled. KeyID 0 is also the TME KeyID
>which disallows integrity, refer "TME Policy/Encryption Algorithm" bit
>description in "Intel Architecture Memory Encryption Technologies" spec
>version 1.6 April 2025. So there is no need to clear pages to avoid
>integrity violations.
>
>There remains a risk of poison consumption. However, in the context of
>TDX, it is expected that there would be a machine check associated with the
>original poisoning. On some platforms that results in a panic. However
>platforms may support "SEAM_NR" Machine Check capability, in which case
>Linux machine check handler marks the page as poisoned, which prevents it
>from being allocated anymore, refer commit 7911f145de5fe ("x86/mce:
>Implement recovery for errors in TDX/SEAM non-root mode")

Even on a CPU w/ SEAM_NR and w/o X86_BUG_TDX_PW_MCE, is there still a risk of
poisoned memory being returned to the host kernel? Since only poison
consumption causes #MCE, if a poisoned page is never consumed in SEAM non-root
mode, there will be no #MCE, and the mentioned commit won't mark the page as
poisoned.

A reclaimed poisoned page could be reused and potentially cause a kernel panic.
While WBINVD could help, we believe it's not worth it as it will slow down the
vast majority of cases. Is my understanding correct?

