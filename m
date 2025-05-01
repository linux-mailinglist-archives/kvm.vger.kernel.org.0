Return-Path: <kvm+bounces-45145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0038AA62B6
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 20:18:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0614E467F11
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 18:18:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BA3C221274;
	Thu,  1 May 2025 18:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JF9VWvBO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148311C5F37;
	Thu,  1 May 2025 18:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746123520; cv=fail; b=kmyKRKrMgv5nH8zVEbw/KIBOs5wngFe2jCHNegycyzR3wUe756i31XCC1SH8k/64hbCcuS2t+sCnk4zMYeoFPT1+v/70R3lp64PlPOokxOdVW6OuateQZr8+KKNvA5EQAtbNAGrcsUmNJzSkixM7hENJpO+WFft5RDXCo5sZxLA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746123520; c=relaxed/simple;
	bh=Muyk2dcdqEkdxZOVVfe6zE4xeCAg/G0t3DDKeiZSf6g=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KweuhIrESHr5OgeDP0opN1ILxyp2Q6p226ABHX4OkUCmUCJWeL+kQaAGqX5ewlKR7UbZsJvm+5i450fujOqqkHJmhc2cM0nHYBzLYFV6VlUwUaZi4GiG74/dwIgEqp/WVHkYqAFoFV5b4YsF0khbARXnDF3y5IbtOd/i23m1HHo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JF9VWvBO; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746123519; x=1777659519;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Muyk2dcdqEkdxZOVVfe6zE4xeCAg/G0t3DDKeiZSf6g=;
  b=JF9VWvBOFu/vUaBzJB8kjqSnkiEUNcLig9WuG5kYPXIMJfAaxARUT6Id
   15KrqPD2YSGpnHKrpk8C+9R2Wl5+yq511+tLz4WWDUeRl8GZHLTmnH2ZR
   XeN42P48jZd7iOXodJwAga1AxiJlNqur86qaDMgeY3zBU4Sc5AnZupk6r
   Pc8RDd1wArLqbT9akQd0vxAwch7bwlHkEXBXonUSu/+w7C1I/4HKvqR5O
   rSoUOfEK6hNFw4711zMrnggFe09THbrNJoHejSD4PES8kduRBAO/3m+1K
   pHgKfyyD4VdWVVATn9kFKBl3lpgIJSBKt/lfstYshr5LzgPOhmKjRt39G
   Q==;
X-CSE-ConnectionGUID: ng+OUpfbQEmieGQY3fjS3g==
X-CSE-MsgGUID: /uXWbrOqQceZvI7HIo1tmw==
X-IronPort-AV: E=McAfee;i="6700,10204,11420"; a="51614945"
X-IronPort-AV: E=Sophos;i="6.15,254,1739865600"; 
   d="scan'208";a="51614945"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2025 11:18:38 -0700
X-CSE-ConnectionGUID: PGnLttB6RP+bLZhhXPUSpA==
X-CSE-MsgGUID: xhJHzngUT3SamYnawF2TBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,254,1739865600"; 
   d="scan'208";a="165505462"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2025 11:18:37 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 1 May 2025 11:18:36 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 1 May 2025 11:18:36 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 1 May 2025 11:18:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XMky5+Qpb+SPVBcHxUqLZaOYd3uTqKGkz/4h98HnGpUG3kFnQr07d6RGerjGFtuakgXCmgJBdgILe6wAjI9fXb0+3WoRDNFjahY/jLKwl+UB69ItnmJYtFUr4ctLZtPWsUqbCyJB5ziUwdghpEQ+MtOeHN5mA2SxUHekVHtNvOvIn2rHx2FExi0n+vKxkXs7h2WnP99CoEtdQT3BjHl06wrmia45PcD8kAuXLcLIiTWBYZaGoDFy7aZsbZXCiDrfhONTj4DEBtxKzAFAtS2KBrZauEeC0MqBMOj1vOf/l7Qsqj4spU/qp1HJ5EOgcJMcD7qFPCEmjVF7qkuMgiQ6KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sS6BaT3IWrCFasRFqClcpeLFhdiA5F3gK60fhSkHQpc=;
 b=ohLAY/8ydJRB4uZG2vTVYich0cZA69FBVtGOm2ysaOAg5gIFPihxLSqXWOt3CNJz30KRahty9+umLCeNUH0BbR1Uzzakc73E6eCBA4U0R2z7oW7j1e1NHVcpKQCSTFgEHWdR+Caa0B0GvEr1NTwVOlRY4OVSf2Tkme4osX2jvT7ixRrxFXO6il0ab0cIgtAVpzto+pSZrzM2FTCQdsOu7i4TaxfOf6Av+PZK6aHEp+waQt22YseUUOLXu1uW6BErkO3S8+ljI6vgIS+64kkuuxmdc07/RPlZkcyMdmGF3L7h041q5VsraK/MappDovp8+whstGtykoNT8YlCI1UWRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by BL3PR11MB6314.namprd11.prod.outlook.com (2603:10b6:208:3b1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.20; Thu, 1 May
 2025 18:18:31 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%6]) with mapi id 15.20.8699.012; Thu, 1 May 2025
 18:18:31 +0000
Date: Thu, 1 May 2025 13:19:03 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Fuad Tabba <tabba@google.com>, <kvm@vger.kernel.org>,
	<linux-arm-msm@vger.kernel.org>, <linux-mm@kvack.org>
CC: <pbonzini@redhat.com>, <chenhuacai@kernel.org>, <mpe@ellerman.id.au>,
	<anup@brainfault.org>, <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
	<aou@eecs.berkeley.edu>, <seanjc@google.com>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>, <willy@infradead.org>, <akpm@linux-foundation.org>,
	<xiaoyao.li@intel.com>, <yilun.xu@intel.com>, <chao.p.peng@linux.intel.com>,
	<jarkko@kernel.org>, <amoorthy@google.com>, <dmatlack@google.com>,
	<isaku.yamahata@intel.com>, <mic@digikod.net>, <vbabka@suse.cz>,
	<vannapurve@google.com>, <ackerleytng@google.com>,
	<mail@maciej.szmigiero.name>, <david@redhat.com>, <michael.roth@amd.com>,
	<wei.w.wang@intel.com>, <liam.merwick@oracle.com>,
	<isaku.yamahata@gmail.com>, <kirill.shutemov@linux.intel.com>,
	<suzuki.poulose@arm.com>, <steven.price@arm.com>, <quic_eberman@quicinc.com>,
	<quic_mnalajal@quicinc.com>, <quic_tsoni@quicinc.com>,
	<quic_svaddagi@quicinc.com>, <quic_cvanscha@quicinc.com>,
	<quic_pderrin@quicinc.com>, <quic_pheragu@quicinc.com>,
	<catalin.marinas@arm.com>, <james.morse@arm.com>, <yuzenghui@huawei.com>,
	<oliver.upton@linux.dev>, <maz@kernel.org>, <will@kernel.org>,
	<qperret@google.com>, <keirf@google.com>, <roypat@amazon.co.uk>,
	<shuah@kernel.org>, <hch@infradead.org>, <jgg@nvidia.com>,
	<rientjes@google.com>, <jhubbard@nvidia.com>, <fvdl@google.com>,
	<hughd@google.com>, <jthoughton@google.com>, <peterx@redhat.com>,
	<pankaj.gupta@amd.com>, <tabba@google.com>
Subject: Re: [PATCH v8 04/13] KVM: x86: Rename kvm->arch.has_private_mem to
 kvm->arch.supports_gmem
Message-ID: <6813bb1736903_2614f129487@iweiny-mobl.notmuch>
References: <20250430165655.605595-1-tabba@google.com>
 <20250430165655.605595-5-tabba@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250430165655.605595-5-tabba@google.com>
X-ClientProxiedBy: MW4PR03CA0291.namprd03.prod.outlook.com
 (2603:10b6:303:b5::26) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|BL3PR11MB6314:EE_
X-MS-Office365-Filtering-Correlation-Id: a6c34f89-4e16-46e9-b55b-08dd88dc93bb
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?OTicI3GJqrzNp8xrc9RUJ/j8EmyTTU4/FiGFwTwUi65sDVIgaZIXjNRnyxmg?=
 =?us-ascii?Q?rJO5kBrKohYSZIizzvvbzmrb6qkOC8QNSTLZfwCtSr8UCpJga/yUxNh3tu2x?=
 =?us-ascii?Q?9w2s76XkpRMd7kpz99Ijb+SUPfP4xHUKzes/5Um9VyKMYf6F1q86Y/LD8uhp?=
 =?us-ascii?Q?tdksI1m+IrTXkdon7vu/10deOy3T2IhD3C6J/JHsqBC496z6J6DDAigD+H6L?=
 =?us-ascii?Q?Pci4IAg9cIJNxlD/0jaYrAcBr/Sz/zFek+S7Eqqx+mXEAiYflWF+VWCqZ52g?=
 =?us-ascii?Q?0hhAeqYOZOWOqJQj8G+/NMtjf9dESbZd2u95RuE6Vxh8x3wOkFWuswJEUSe1?=
 =?us-ascii?Q?DMYEvfVTA8bh8fEQe0UFet6QhraahVXW1AsuKPMZ2RSnNIjTfhXQZnlPRGeo?=
 =?us-ascii?Q?ea2+ketKXZ65Ai/4i6FyLQTZpG5Mu246PgM3GBqK4smM8sXmmzMx9UBsBfre?=
 =?us-ascii?Q?ljY8h2fFr/gZ+xqard0sEtrjgVikwaM+13Lgf0QEtt4pt5vfwmxAVOlNpxPJ?=
 =?us-ascii?Q?RYvGLXUx1m7dnZknsrJBAkEOTzwBvmML5Rsmc2CFLjp1M4ba8trBBIJBbcvg?=
 =?us-ascii?Q?9SY1Y/MiU9ua2bq4o1dF1HM6S8eplTRMEIZdSqkm33mZQavGJqv53l1INaPr?=
 =?us-ascii?Q?zCMpQLsaEoBRbJNlnfkgF2kEdUrCRyWO8dE4wELPZZ0c4atBtaVPkk2eWoFJ?=
 =?us-ascii?Q?osPltL3HtD6/qZcPljseuFmdgPciUAeuZpkDjoCPqrgWlDJSzgUhAs6i85QL?=
 =?us-ascii?Q?rSLf1WrI0wYpC7nqsdV+AEbGF6MvDwszfTGjmw+DvM3oLtmnys0fI8dl0qrz?=
 =?us-ascii?Q?fPQOIGmEbv0H69vlZJFRugQWsCkS/F9hy2FuU69xp9+/JF8HsVJi4GmnxHAm?=
 =?us-ascii?Q?+Vk+i4QBziLzad/S4jcoG6/asj3ol5WOFONl8ULuhBAaSRjAEImTM2VMZK65?=
 =?us-ascii?Q?kVAhhpHvQefp0qoQztLfxjJOkVryAKkTJO3NmiyUS/pdRJTMIKLdYWSaJq1g?=
 =?us-ascii?Q?ibpzXtoqidv4LwUhWvHitn6vwwK1/tZssHoIMyKn8zCXfcrtWQiK/XZllLNH?=
 =?us-ascii?Q?k2QySJs4qlY217Ra0GiA7sQqoTpV84oZ8PiVAsqsiqXlc38oJQm7v/kdN6mW?=
 =?us-ascii?Q?BKfo95kdVcb/pJA3DJ0YaAIcPTKVcHBGkGvrf66y4WprgwvwYIXoM/J622Q6?=
 =?us-ascii?Q?cM0R8nTXmogRLN8OjdWbAk1U/UcZcSwMTmXeLhGDP0RcVLHg+lXv3jv3Y7ay?=
 =?us-ascii?Q?pTm/3Wh3nzVD+3AaDTFyFPJgrCX8dWeY6KXgGNo8UwsO2LMUscwJNAOiubHi?=
 =?us-ascii?Q?u5IbDaPAv1nUaGLE6/LBEZDTtXoefa/slfzsdTVABxIOfJl4/XbdDf8b2z2v?=
 =?us-ascii?Q?fDgsXONq0iCuavAM+IQGpqf9V/TGHRfeSx96UUwod8MphWEnA3TNBKiie1QU?=
 =?us-ascii?Q?kQzeBFdD1+Y=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QzL8iqk2n/Jkn9c/0Md0kRUqoRYk8NdtgYCv6YsiIjy0uEN45TAYMcpD3r0q?=
 =?us-ascii?Q?yWrR7pxXP2QNDSeFbm+uHCLUhKm7Pzz664DDsQf5yEwvzk66C5+S/J6sC/sd?=
 =?us-ascii?Q?2I3Mg4V5N1nLLyyR/Mr6hNS2Wipt7/Ey8N7NF7G4a7Fc73q0L/QTeBZY4Bqf?=
 =?us-ascii?Q?N09dDNQYIUbmVBSxTvWULtDYxJkbs2h8pAR1h391FYJqUt4VzSfGbPnwZ1Uu?=
 =?us-ascii?Q?b18ukBDyf4BQZYVVD3Q1GKpJzFjkRe4vKye0E8GO4ybJFtPQOR5rZAzI2dcb?=
 =?us-ascii?Q?uoB3p4PSz6E2ELtG8t8GQeS7XOcQ3fIns5uUWf2i9S3vtP4F6jEUNidM4mAE?=
 =?us-ascii?Q?/9JsBuMVVcvLboyZSaxJrkXZ2isbHR8BDHEHLlBDrdU1UO/7EhfIZrcM6Ne/?=
 =?us-ascii?Q?WbUQyDSVDgQ4J26AhlXr7YFWGuUWRkrjsGv1EssTbwsLPtz5WPSmPByGFRGo?=
 =?us-ascii?Q?216f8hl6WjURojMpvm08bh631sGbNnZCbISGPz4JSrNhZuyn/HDLuQbgcez+?=
 =?us-ascii?Q?bWNbRF0W2me2WAUcWI6FrEuo8FW+aJmnxuY6O1zvgi8XVDpxLRkVV9tM/I+b?=
 =?us-ascii?Q?Fhfe5RHsz7zx7Prbj+Qxe0+GQ+HgNFac7ht3+q2LSI/UMOBQMhRg+yQwiEKW?=
 =?us-ascii?Q?ojS8FtE5PCemhBt0JgcmnO4kFMIpdLi2aISuaNQ9IBK4uh83h0cc8zniXKHR?=
 =?us-ascii?Q?8cBXLzEApvo2elKqYqNvu2PK65ztMktcDI4mQxeSMXcw6Sf4ZYMWhTywm03x?=
 =?us-ascii?Q?E9+pKrm/D1yTJzHpXNoBU2UXhDcXHzOZbnuT1dZ1thbqsEyYmwX4zLl5iozU?=
 =?us-ascii?Q?Q/4fZaiTjmjS8zdskp5Bqhfp8GZ2PTiLk2TKLIoC5fyCvZXKviJGdGDYezX+?=
 =?us-ascii?Q?JsjXyNgF4BIhZt5tJcHSzJ9DCgfipAWzXdGBzwxnM236rwho2hB43eq3dyLT?=
 =?us-ascii?Q?zNxUInVJgVnJCjZ/yp2Xv+RxPUVo9CxzZRbBuMJmynQagGw/u09Hiqri0MvA?=
 =?us-ascii?Q?XCdc4PGpuH24TPIOIxO+ZZ6D8gtloUWjZDzxYMlAZF0H4Wxv6Xj/1D3Bt8j4?=
 =?us-ascii?Q?3ZBlgIhGoQaFT6LxXDllKKFpUzIIVS///Zisnh/0R/hGdFPNdEgj8IK+nT+o?=
 =?us-ascii?Q?XiwrPBme/HxDVPy4/2suaJaM/9qkPBfoKhadrxhd2z0/IlAaZsHs02lZYc9G?=
 =?us-ascii?Q?x4Qo0fNCh7HEeB81+miG5DTgt/Rgt/6H2BdIimnBlbh+OH4S2BSqWV5GmQW0?=
 =?us-ascii?Q?v523EGeWbyFMzCkXn8wn25Mb2PHYq+DvVJqh75Q38xA77WaS4Wl7rACPx+WR?=
 =?us-ascii?Q?UcD3PfL4dcy4DObKGEGYZScmWSUSc89ohut+nR8gWOrKIQ9krbouI4+zGY7S?=
 =?us-ascii?Q?dFbH61Gwb0a5WOoIpErVcBFuKpRoZiwatTzN2Q8X5XtF0JPww0WA3PGZOjkR?=
 =?us-ascii?Q?0R/esxQgvilf05kJUueWqSOnogjNn0Swm1bc7ax6fkSRUv/ayVY2pPKv3rvt?=
 =?us-ascii?Q?rBr0Sws7TZ1uOQKOeyfAsS0YxPFHTEfl1QK3YftF8ecU5wkL7Kut8p9GaD8E?=
 =?us-ascii?Q?nd+Gqzqk+TbuIMCoDD/s/zCEdazgVeOJGVicfIQE?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a6c34f89-4e16-46e9-b55b-08dd88dc93bb
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2025 18:18:31.0645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5o66+cU24t/OJbek24ikPaiESG12WDcV1uX8UMwzarqVMmHgDPiyF9iffHgMRmgvrssnBXdGhp/7NW/Ln7XxnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6314
X-OriginatorOrg: intel.com

Fuad Tabba wrote:
> The bool has_private_mem is used to indicate whether guest_memfd is
> supported. Rename it to supports_gmem to make its meaning clearer and to
> decouple memory being private from guest_memfd.
> 
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

[snip]

