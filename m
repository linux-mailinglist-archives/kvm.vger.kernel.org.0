Return-Path: <kvm+bounces-48725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 01611AD1968
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 09:54:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 43D3916B9E2
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 07:54:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14811283129;
	Mon,  9 Jun 2025 07:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LHdNiGIf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D372820A5;
	Mon,  9 Jun 2025 07:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749455621; cv=fail; b=QSqvYMd+vxiivudxY3B/ODTnsBq5RG0dbtlzFEX1JCGKg5N2uPOsOBeiqcdYf8oyMVyuYmWvLeMmvPe9Jvhcb9JTvYDJzew5mhZ/QMD/Q21pK2DFytzXjKzNwLJyNbTJiWdlsLI+TWLvfCOodRKuna1blqJHwICVZM0NhjzIBq0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749455621; c=relaxed/simple;
	bh=pf9MtoeUXPeZaxZcTAWeZ29VSV3hfu2ougmkh0hv0dg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BCgGIpdyyUMVqtUBe0sU0nHbF/XPr9mIhN/CJx+VM/BopU8UkH2yafDbNFdoF5zycme2tG0EZVRyP8BBfsteFS5LgZcxAJNrPxI0C+mlb18MFgZVA/IoMz2Y/JIVece6COE6ZedTqHnwTIQMHe9Bvv5YeNJZqE877YwslV+1IAU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LHdNiGIf; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749455620; x=1780991620;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=pf9MtoeUXPeZaxZcTAWeZ29VSV3hfu2ougmkh0hv0dg=;
  b=LHdNiGIfTD7wMjkHy+bg95o9MJb3NgNf7YXYojRSZEzsqbf8WLi+2MoP
   zSz5Olk2XdHVlsAGimSeDLjS2ISVUgjJLWSSikbzS4aR+px7tCt0vdA9H
   XGSpY9yHhFDbNPWU0HmDTmnPySGvG8KMGVRA6PyW+YuJ5FJR3enDp0DY9
   7ffHxWgk5KgRVsws143kuhW7RPQwQqZqsBtU6rh2TS23TKmJRpyFKjuY2
   UAtYuMo/RMgZ/9tMb2Nbt0OetfXNReNtlTCKwTzGbr4mIisc8CXxzYRV6
   X5CtnRF0NYgpcCsJGNKBOA6JUwkfUVA9MaxtT6y8PY6i7a62DnxtO+bVR
   w==;
X-CSE-ConnectionGUID: uhgkYMrIRMO8WoZr/UVnVg==
X-CSE-MsgGUID: 66YMRqPiSbSmBwSiGCyx6w==
X-IronPort-AV: E=McAfee;i="6800,10657,11458"; a="51608324"
X-IronPort-AV: E=Sophos;i="6.16,222,1744095600"; 
   d="scan'208";a="51608324"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 00:53:39 -0700
X-CSE-ConnectionGUID: vIR/pxrMTzy8N1eiga97BA==
X-CSE-MsgGUID: N27/Ws3UTKS43C4lKaZaHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,222,1744095600"; 
   d="scan'208";a="146963074"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 00:53:38 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 9 Jun 2025 00:53:37 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 9 Jun 2025 00:53:37 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.63) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 9 Jun 2025 00:53:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=umuZRVvtF7TYIyVZK6E1mEDEx2gf4W+6nlO9Kbrs1T8j5C5Y48qAVirlKcgQ3VDgfRjdXW0T8Yj+j+9aXnTGob1RgDC6XSdVpqiZ8BYJEIwhEjFVcmeVi3IKLCsw0bI5gliemvJlBOlDbOKfLT+ycdxFeTOKNpJel9mJGJPTD4BJnMv+PArnNWvMMNZ4nTCxIk9G3WRFJjZT0slZQ/xDiqkWPWGnY7b7tRvPdbR/K8+4+xSOxve2kAW7aDyX9Mg+3SLypDBxqSX52w/didwA7+Te054E+FLlvZXcksAVe8ClyHZktiOWWdf8vMA2xkXpp18ZT4G01xaD1tnPjyRDXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fUZ8AyNHBW7XDB4v+Lbu1GaTH+9/LXPm8LC+sd2dH6k=;
 b=mfWxuDPwiLh2VSa2CcozBN+cGwL9QDWURX4EqZCcm3f9EJovTzl3TZpCoIQ3bDVixLJyt3Iw9SO0Ns2QwqV35K1ECHPRwWg7kJG7j2ASBlXKUYe0XECBw0cO6aqMz+WVqjA1ICT/fWNXRnaUzur8V5z9RQ9X3fNsy+97kL6bBZW6bGaWvYzOHQzj+0c2f5LYLfKSu6DAKuv3+u7ni6UGoX482a+LmK6Afhvj5fCno4iyGUIPrYMrzvBBrWb02K2ry1hldhhP1sGxx+cTcto/4CUrnc59PP+NT9mXAgsbqaJeaSzoOYNzCdqPo0uitQyAzy3nASBF61sidbFg25q/ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DM4PR11MB8092.namprd11.prod.outlook.com (2603:10b6:8:184::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.21; Mon, 9 Jun
 2025 07:53:16 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8813.020; Mon, 9 Jun 2025
 07:53:16 +0000
Date: Mon, 9 Jun 2025 15:53:02 +0800
From: Chao Gao <chao.gao@intel.com>
To: Nikolay Borisov <nik.borisov@suse.com>
CC: <linux-coco@lists.linux.dev>, <x86@kernel.org>, <kvm@vger.kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <eddie.dong@intel.com>,
	<kirill.shutemov@intel.com>, <dave.hansen@intel.com>,
	<dan.j.williams@intel.com>, <kai.huang@intel.com>,
	<isaku.yamahata@intel.com>, <elena.reshetova@intel.com>,
	<rick.p.edgecombe@intel.com>, Farrah Chen <farrah.chen@intel.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter
 Anvin" <hpa@zytor.com>, "Kirill A. Shutemov"
	<kirill.shutemov@linux.intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 03/20] x86/virt/seamldr: Introduce a wrapper for
 P-SEAMLDR SEAMCALLs
Message-ID: <aEaS3i5JhgFX2MCh@intel.com>
References: <20250523095322.88774-1-chao.gao@intel.com>
 <20250523095322.88774-4-chao.gao@intel.com>
 <d1ec91ad-b368-4993-aadb-18af489ea87e@suse.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d1ec91ad-b368-4993-aadb-18af489ea87e@suse.com>
X-ClientProxiedBy: SI1PR02CA0045.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::16) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DM4PR11MB8092:EE_
X-MS-Office365-Filtering-Correlation-Id: fd72945b-993d-4422-8637-08dda72ab135
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?vIOYjPaTwvoywgzSsE/sCRPs+EUXlW1A3WA5xP0DNCyzg6Z7ysG0hNhYl7KN?=
 =?us-ascii?Q?J6hKC72yXpeJJmil7DfUCePS9RJsIQdI6aycEKkiKjr8CLxeYJ2CKM6FHAUs?=
 =?us-ascii?Q?0zFtj+vXtfuSsmLylBZEtjx9/1bcqUvUuxPd8nGaYy/tCJXbFUGWuksLK9yT?=
 =?us-ascii?Q?PTQTmtVw69TFFX4flJtLoFTtv7MtLjUgtlgTjENHwJ5XkXlAg6JVndrrHgv9?=
 =?us-ascii?Q?iSLvLwn7+6vqDlhAqUa83lqMWstXF5EsjKGkgZFWb6SwdePZmL1OEA3gKSyG?=
 =?us-ascii?Q?Ulk0P4v68RDA011fkM6wa0NopJZLoIbRJShmX5Zy8Vk1mGpjXZkqPNOK8V9R?=
 =?us-ascii?Q?xIxND0FXx1X/4eUxbKN7sPavx74gpr27mZu3YP6epbKySEyCbYincAD02JqV?=
 =?us-ascii?Q?29wTy0n8OVL3puOgCCFHCYBPmiGWiaMVacI7FdiYYRTc5UbDSWS1sDsO4f0e?=
 =?us-ascii?Q?iiirhyNfp+wej3zD864x7C4zGn3sRaO7NSyinmOshZCeXm0YuymInpNo/uYb?=
 =?us-ascii?Q?okwzCZUR2swFODA9kzdlRHhWqui38qmLFrDxysKUa+xcgJgdBEMqdHq+DK9I?=
 =?us-ascii?Q?Nn1OTF1plGuKGxacUaQrdIo9RmFDkkLlo0E2YW5YpNZWhKOKI20k+HeIJnFk?=
 =?us-ascii?Q?lrDizVZ0ZY7XDFZ8swbeLMfUyuZKMntlDXvnAoVV302qtkjfCbysD+VRpbTc?=
 =?us-ascii?Q?mzuO8Jvw05jc9P/vZN/g41r3QGDRl8MaAgN6atgDGog6l15QRVNDCINmox32?=
 =?us-ascii?Q?uIB7N7Xl92TcMIiTDUEX6R+wVLIQ7V2ivW+ht0kZa3tIu1PxVEq+CXh1vl7f?=
 =?us-ascii?Q?jBQwpVTmuIjnuvr/tfl8zws6cBXfJ2ZR3XjvG4cH6G8oF6hDPv81RxOq/hef?=
 =?us-ascii?Q?qTjpv7a58JdL9xlfDibPwpgFysnd0gIy2CSuPv8+G6MBfFrATYMoTGOljP1k?=
 =?us-ascii?Q?8775fBzlORJEoVseoHoAk//w7MDzQlL48Kkz64+STI0THoco6RdYDLrn6SY5?=
 =?us-ascii?Q?5Yk8/+ijd9F7wS+eDJrV1+Sl6PyHg+fcsHPIr5pgJLaz5AaXIE9orK92vgNr?=
 =?us-ascii?Q?NJMDATCoNkqX4sKKByadxDV/0YI7rrZK7hSYC+aTGvbng+Zvx7OfRpi86paL?=
 =?us-ascii?Q?hfYPCye71sZwsJ/4kF6nEnX+lQ45BNLjQokTp18i8ZhZUhiZCLq2pKTtNpij?=
 =?us-ascii?Q?GS2IZWUtLoOBWC6OB/ISdngJLJUZhKV2ASYgXf5W1gjeNM0ysgV6XJvxoh/n?=
 =?us-ascii?Q?Tf+IzLVOpIynDK6z2PU5kezzQAug9UFK0lyG4iYcAW0MLBtZChJP4FfCMG6Q?=
 =?us-ascii?Q?96ILoPzDB6YUiwznmNXE/NwxUu5Mnn254qf6ZrYTFVySUL2uxZTOq9erSZ1F?=
 =?us-ascii?Q?vIsG66XVs3M2uWN3PkmmvvdOpFlgf583LmJRXKUdnN7grTDheJC0covyXpPu?=
 =?us-ascii?Q?RuJiZAknCDE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7CiQn2Ixbg7CEmQiQO5lF1s20BtkyiHLYLz3LzUz8O5jQZ5PeJ5j3mMd/9wg?=
 =?us-ascii?Q?yhvDiudW09E41mRz8FKppx+T4bTqIfFUr+phOydUe+xuoOcXhne2GRfjY6xd?=
 =?us-ascii?Q?HR6kxrZFqPYHPe6XqN6mkCEzoIx9MtOlBxrcxpGEqsZ/IVPhvTVJO21zTV+a?=
 =?us-ascii?Q?EVcKfRMdnX2NY1BjUPdX7pdq27Dki+r2dipRu93FexRRFqdU1xeNQTcA0b1s?=
 =?us-ascii?Q?Q7ZJVjLhM31A1dV3FsPcjXKpxsXOUisi+u/MB1Scw0ozV5FUuZeE20kjHd8X?=
 =?us-ascii?Q?qIm5pvnh3ZjVCPvuHPJur9OtfFj4wWSiaGyORyvmgg6T0j2c4FeuSCcPD9fY?=
 =?us-ascii?Q?PPz6+sr9FA92J0uUkt4jw2b+1yQ/uEQYztrbXCayBqN5Nlz4yqWWKpLQ+fgF?=
 =?us-ascii?Q?XrYLmlD+MwDVuAlBiTnxNcioQtltd0G/iionDz35jCOmv9SnbUXbXOO7Tf+B?=
 =?us-ascii?Q?R9k6HyUkdhNCuMq34uk+TrKXNgGsaku3c7xf3uyxYxLR0wrp7n9qoRpup/V+?=
 =?us-ascii?Q?n4+LNNTI5nmapUvt3OoEHWAN8gD1sqhRE/Z45Ci74iFcG/tmTP8Pm2ptqp0n?=
 =?us-ascii?Q?Pq0Xl2MUbX6zzqa20dx+HSj2wa//GCS1/L+kwvgatHdu8YD9VbSoArPmClAK?=
 =?us-ascii?Q?SE+vh0WXK3UneJUU5JS2EoRalgj80XcGEkf/WH9WoS/6KHsGBibZjCqzi2x1?=
 =?us-ascii?Q?INOiBl7089DpfOkF5wB0PSn09yfc6+bxAOzYi42euw7H8TMaVCuUKXB6gTzz?=
 =?us-ascii?Q?eaQUGA4DODvi6HoL6XixS5N5dxY/jiqkL8tQEThirRJjtbdPyo4oSSHqgIaG?=
 =?us-ascii?Q?YsDIhQXP4Fy6tQxemPUP05mZpONh7uVz0eL63p6eh8W0/kDg0aDrPthjr3in?=
 =?us-ascii?Q?doHq9OhEybihRQqIXbqRTprTR7qq4KxHTRSRhQGFMqkiwjPF6v6IK3dOnL4q?=
 =?us-ascii?Q?K5rTQ31UCFGeBc8Ya6i6h2SKM8HnlKyMf4kfv1wArSU4wLmGK59t+4kBPoI+?=
 =?us-ascii?Q?xDkXNhGuowS8q4NrgGm2EPdhP/XTLDPAue1kUrA7v1Cxnj6Aaj9jNn7up6L8?=
 =?us-ascii?Q?2y8MOfLAevXnHEig5jCxSkUtZykRFNX+E7If25MIPr+mezpZ+kvurdTeIDko?=
 =?us-ascii?Q?mhSUI0evrjZk0BrZBPJffrvwP+Z1rfAqpc51A67XLAa77/PW2avoiPEp/V5r?=
 =?us-ascii?Q?pc0h6YYdr2WT3cDJqZXHLIXgmb5bGf5gkcONahAfO5zUQ+tGiiMg3uNDSVDc?=
 =?us-ascii?Q?GIAgm5770eqf8oqBkG4gLS6QGZYrC7J73jurMhvFwXIkL+3cY4BAOaCZ4biR?=
 =?us-ascii?Q?MoQgeFSRcr9QUzWDryDmjjucUPfn6CDHLo1XqMxXXtX92JiI0mANU47z9XC/?=
 =?us-ascii?Q?nfPIoGc2x9D70ymshf7LYEw25qAe6mLrAx/1oE9/1KObVuIJ00sM4u7YFF4c?=
 =?us-ascii?Q?XBipkWGQSkE9a4obVdHtR9+xweg9H5kma5Pt85OERTNvrHiSzZookBu+HCBf?=
 =?us-ascii?Q?T5Wd04uicpul4LH6UsO8f2k7sbMpZizkk7+JZB7y475aoEY9jIma96kgvDYh?=
 =?us-ascii?Q?TwUtYsYOCgoVCuyWiZ0CSmTLYF8Nn1ZKmZhk/V8X?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fd72945b-993d-4422-8637-08dda72ab135
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 07:53:16.4295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g4W4/YRIvRDUoG3kxZHFE0QbDRIWVl1eWYShp68WJqHpLZx0pYoEvpnkSJ+kH5ynOwvKXb5/tGxztn7cDqYxuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8092
X-OriginatorOrg: intel.com

>> +config INTEL_TDX_MODULE_UPDATE
>> +	bool "Intel TDX module runtime update"
>> +	depends on INTEL_TDX_HOST
>> +	help
>> +	  This enables the kernel to support TDX module runtime update. This allows
>> +	  the admin to upgrade the TDX module to a newer one without the need to
>> +	  terminate running TDX guests.
>> +
>> +	  If unsure, say N.
>> +
>
>WHy should this be conditional?
>

Good question. I don't have a strong reason, but here are my considerations:

1. Runtime updates aren't strictly necessary for TDX functionalities. Users can
   update the TDX module via BIOS updates and reboot if service downtime isn't
   a concern.

2. Selecting TDX module updates requires selecting FW_UPLOAD and FW_LOADER,
   which I think will significantly increase the kernel size if FW_UPLOAD/LOADER
   won't otherwise be selected.

It may or may not be wise to assume that most TDX users will enable TDX module
updates. so, I'm taking a conservative approach by making it optional. The
resulting code isn't that complex, as CONFIG_INTEL_TDX_MODULE_UPDATE
appears in only two places:

1. in the Makefile:

  obj-y += seamcall.o tdx.o
  obj-$(CONFIG_INTEL_TDX_MODULE_UPDATE) += seamldr.o

2. in the seamldr.h:

  #ifdef CONFIG_INTEL_TDX_MODULE_UPDATE
  extern struct attribute_group seamldr_group;
  #define SEAMLDR_GROUP (&seamldr_group)
  int get_seamldr_info(void);
  void seamldr_init(struct device *dev);
  #else
  #define SEAMLDR_GROUP NULL
  static inline int get_seamldr_info(void) { return 0; }
  static inline void seamldr_init(struct device *dev) { }
  #endif

That said, I'm open to keeping or dropping the Kconfig option.

