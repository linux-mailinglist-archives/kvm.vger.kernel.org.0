Return-Path: <kvm+bounces-62384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B23EAC426E9
	for <lists+kvm@lfdr.de>; Sat, 08 Nov 2025 05:31:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 392B718918BB
	for <lists+kvm@lfdr.de>; Sat,  8 Nov 2025 04:32:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9429A24EF76;
	Sat,  8 Nov 2025 04:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NvAF+IK4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D251F4174;
	Sat,  8 Nov 2025 04:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762576298; cv=fail; b=N9QO9MO18d69JbBcaRsQgSoh87OD2gfAL26XDP60CKXZ717iwVIhlFeXVmxhU7N5xkzNEaRSslJrq3YaJvd05IZ7pIygmm7Rb1LdgtQZOmECPO+rL7M3J2io5KpGdaQRY8PQwMaDr27hjw6LLWS5jQOz9//mXr7EkILS82/Pi5U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762576298; c=relaxed/simple;
	bh=DyconHZuOHL364hvUUQ8i+9miubRR6EN4oORqbundL4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=eSEPy8ZpYn9xZlIQsWfJ49EP6ENurdjh3phAS84DQMLq9EhigRIcaajpkcu93tsML+CdHD3gBdK0vvYEig27d55lDCqbr+9XClMzXZHzvqWNTS7B/83IEDHzMKSVgsD03775po9HFpPd5Sdyfc+uTV0go8FKAJsuO0dRhr3yQ8c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NvAF+IK4; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762576297; x=1794112297;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=DyconHZuOHL364hvUUQ8i+9miubRR6EN4oORqbundL4=;
  b=NvAF+IK41zh0nyn79iY23hZ2H+gFxcIFa+29I3AF+WGsZgnriauNBb8V
   YKElPEWoiNxy/TaPvOLUnMEnxFKBpUU8RUigRGKuZnCE/ZtBBrIyrP7/y
   hNkgYU25LUSf+ucpUVCLx5XIOlOlSjtaQEYT3mnbos/xMlDQfWOKTU+Qx
   CKjx9GM8tCZ0U8s0J+iY97qMFl4EvYnOz23r/mYX71Xbt1VMY6oEsfJup
   DS7hYJmZQ/3OY6ZC2Xpn6YVpKX+K0718Y2nQIzhqR5/0vrR6vR/pJRkoc
   vdQCl8rXCkLYRaRs5iXLIzppvQtbLBIgG0CrmgLdMCFRrPpqXWIgPLsFu
   g==;
X-CSE-ConnectionGUID: ii9cRcdmSjmh47Rq/trUuw==
X-CSE-MsgGUID: uQbIaLzCQDKRhuZfdghb3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11606"; a="64638803"
X-IronPort-AV: E=Sophos;i="6.19,288,1754982000"; 
   d="scan'208";a="64638803"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2025 20:31:36 -0800
X-CSE-ConnectionGUID: DznPW8E2TnCcE9SrTtrhIg==
X-CSE-MsgGUID: 097Nr1bwRRCwvjA6uigTYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,288,1754982000"; 
   d="scan'208";a="192581563"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2025 20:31:35 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 7 Nov 2025 20:31:34 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 7 Nov 2025 20:31:34 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.17) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 7 Nov 2025 20:31:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NLgtn7+Ih9fTI7NlWdjPjQqMAmPYmzlbTL+4+oEiQkfWJd9BIBUDIRsoyC0PzvjkmeY3zUytj+LkHPYqfJUeePZTOv1SHsAWLlcljWIPNTZbO70uYLz+7iQEN6eWs5jLz/c5yz5xM2RtXs3/d65i83S87kLO4xIRJAmiwV/8WqlQU6ulpN7brGgif/qLU6t9USAZVUnhUxfTZeZ2QEcWzsdDFSumBfu+qbtnCG5cR1wTwXZEDs8bvNjrybgFx2jN+BYAjg+wdGb4tCkWF4E9ue9ohdSmXjfPSVRQxvUDGeRaT5XUu0TVIf8+7FfGKKwtCCumb6si19o4Uw6x8mgEbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rdBa82RDJt108cF2CV896V/AvyRaadmaEsyPiSsRHQs=;
 b=GiLxqe6sVPADDCfQxYn+81F5Y3mU9tQdX6bln+GnPAt+1RQSLcq+voOUqa237IrtRbabbr9ebv56QJQQnHFwIE/BJUIBgEIQatW/+XULItxkaALq6dtC/bDEARVT7GOpAx6bgs0+jlY3rOxGpiwsqXJ21/QD7Smfo+/lSh9PVKYYlnCLZiVBdNHS63fGSlAsf03dkZ57JqY+f51Mzp4k9dnRkTrnS6+XGGI1aaaPFxYCoNqAOz3GlZkY7RVGG7xzSxKZFInUNbcb0LV8EvhuL9ejTq3QLht7umWWvCEV63RW92hEOC6b64MPb0mAU+Iq7ifg1+rZw24hLswIaIAJrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by SA1PR11MB5924.namprd11.prod.outlook.com (2603:10b6:806:23b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.13; Sat, 8 Nov
 2025 04:31:31 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332%3]) with mapi id 15.20.9298.012; Sat, 8 Nov 2025
 04:31:31 +0000
Date: Fri, 7 Nov 2025 20:31:28 -0800
From: Matthew Brost <matthew.brost@intel.com>
To: =?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>
CC: Alex Williamson <alex@shazbot.org>, Lucas De Marchi
	<lucas.demarchi@intel.com>, Thomas =?iso-8859-1?Q?Hellstr=F6m?=
	<thomas.hellstrom@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, Kevin Tian
	<kevin.tian@intel.com>, Shameer Kolothum <skolothumtho@nvidia.com>,
	<intel-xe@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, Michal Wajdeczko <michal.wajdeczko@intel.com>,
	<dri-devel@lists.freedesktop.org>, Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Tvrtko Ursulin
	<tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, Simona Vetter
	<simona@ffwll.ch>, Lukasz Laguna <lukasz.laguna@intel.com>, Christoph Hellwig
	<hch@infradead.org>
Subject: Re: [PATCH v4 22/28] drm/xe/pf: Handle VRAM migration data as part
 of PF control
Message-ID: <aQ7HoF9SlR6T4BEz@lstrano-desk.jf.intel.com>
References: <20251105151027.540712-1-michal.winiarski@intel.com>
 <20251105151027.540712-23-michal.winiarski@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251105151027.540712-23-michal.winiarski@intel.com>
X-ClientProxiedBy: BY3PR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::33) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|SA1PR11MB5924:EE_
X-MS-Office365-Filtering-Correlation-Id: c052d0f3-a871-4b2e-0352-08de1e7fb0f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MnpzTWZnS1ZRN05xUE80UFkxaVcrSnE1N1dKY0Fad2dpMS9NeVEzZklnc0ZT?=
 =?utf-8?B?ZXlqdGRNUlNMWTZyRzB3dnVJdk40NjQ4bmVnVkNJeHJTQ0pTTHNRZXpUSCtY?=
 =?utf-8?B?d0IzT3FPR0dOU0NUTVFFeHZRZXBVeklidFZJcjRLRnUrQWgrVHRpRDg0N2tS?=
 =?utf-8?B?UmlTQTNGdVRzU3dCbWorV2k4YmM5VzB5RHQ5UTQveUIrM01QZnR0Ni9ZS1la?=
 =?utf-8?B?SGRNVzdNM2c4enVzTjdOZ09zTDJnclVLS1NoTzJDZ01jQXBsR3RLNFdQbllM?=
 =?utf-8?B?S2t2VGtHU09nVDRCT01qMkJqRmx4N1MwQWJlTHlPNlQrdUUyTSszR056YkJL?=
 =?utf-8?B?SFBjM2RMSGppN1preDJyWVhYNnhEZ2pNYjRNZit3dHpoNCtJMFZYN1pFRzZm?=
 =?utf-8?B?dWNVckZQa041ZEs1Q2c3VmkxVm9JOENsYnZtakpMcktheTdjSFhHblpvajE3?=
 =?utf-8?B?ZkFGazhnSnB1cW5mRFV2WnRMV1FlYUIxK0E4Q01oUW5qSWZ6K3hLaFNwdUd4?=
 =?utf-8?B?QkhhUnNLWExCS0FQMTRpRGFHOXo0UkxZN21LVDB2U2ZCc2NJM3Bub25VVTRi?=
 =?utf-8?B?Zll5a2RQL2JiRzRqa0NFSEpHVFhra1FRVG40eTZxZUpaNzJpeG01blNhV1ZF?=
 =?utf-8?B?SmRxRHF6S3g5Sm9Xb0xoTG5LNnFKaWJ4aWsxclNXYll0cnFudEh1Mk1oZ1NH?=
 =?utf-8?B?azUrZm0xNE5LU3RPQ1cxR2tQbHlqTGVCMzlJRHVUY1Eyb0V2eWNVYmtLbG1V?=
 =?utf-8?B?L0hhaDZzcmpzblZCQjN0QnhtSkJVWW9jcmNVTWhqaEd5YTExd3FBNTJJN0Fq?=
 =?utf-8?B?cHV4SGUxMWlYYkJVaENHSFF5SjgzN0FabklVdVd2NEdkL2hhUzVPMjFpdUtR?=
 =?utf-8?B?dkZPTVV2Uk01UERtelltK1BpajFGeEx6TlJoVFVYbG5XZzJwSEIyV3pIaERw?=
 =?utf-8?B?dXlSYm5YV3EyTjhmcWgrV1hBVHIycEphNDBzSWtLdlVBQVpNbTdKYlNsUzl2?=
 =?utf-8?B?VXRaRWthV2VSUmJwUEZIRXNUdWZWTEJ4SmM4UEtQZjdIWDBPc2daL0RKTHNV?=
 =?utf-8?B?Q3F2UzZXTlBPbU1DcjZTOVJlT1oraWtZZDhweG9hTHFFUzUzWVRpdFRUZk81?=
 =?utf-8?B?bVB1Z3ovY0dDRGV3cFFUTWxHem9pZUozZWEzWXpESGxYd0F0bGVyZGxWZ3ZE?=
 =?utf-8?B?VWNyQTRIRWFsQkdqbzRob3k2TTR4SStzRWJMWjNXUjNiSjRUdmwzMTlNWElJ?=
 =?utf-8?B?RXd5aitQbmdFRGN0RFBReW96eW56b1poQ1NHVW0zanZKNzFUVHNQMU5ObTNp?=
 =?utf-8?B?K1JsVFBMWTdEU3JvWElnMFRXR00xRG9lWFZaRVMrdXEzaSt4dXZkM1ZIdEFh?=
 =?utf-8?B?MXpWZ0lCL3FjTEFmdmVXSFFGZW1YMzhtSEoxZUFiS2tWQkY0SklCRWZscXFa?=
 =?utf-8?B?VVRpZEdLWTliK3FVaGZ2Nk9oSlk1bTMyRmN4SXN4d0puZ2JiaEkyNEx5eElO?=
 =?utf-8?B?MU9aSGQvdi9rSTE1TjZyb2tJQjJHbmptWjY3dTNuWlJDVFRkV0hsdU01Q29h?=
 =?utf-8?B?Q3lFcVJRa1hJN2xxbnBEaG1OTWJ2dGZSL0RQWjNHdGJZbFJZODBSSWcrNnhl?=
 =?utf-8?B?OS9mWnlUVUxHbytKMDlkTStNNVlLYkN4MU5ORUh6OU5DYkhFWWlhU3dFRDhE?=
 =?utf-8?B?bHIrNmRCaXk4emxZNE11WmwzenB3OEhsWmhtMVJxVnZCcE5SYzB3UVdQUWtQ?=
 =?utf-8?B?Z1Fuckp4RFdYblVpeHkwRGZ0c2NVenQyRktOVHZQVjBDdDZTbXNUcjEralkw?=
 =?utf-8?B?UGZjTkxlOCsxYmRxWWh3ZFBIT1ZTbVNSR1dsaW84Z3F4bmdEdFgzaU5qNFM4?=
 =?utf-8?B?dmFBSXJZK1ZJb0FydEdwVVBaVnRKeVVMOFZ3K2hLcmUrdCs0TzlhUkhiamh1?=
 =?utf-8?Q?AWNEt6Qwu20W3Q6PcsHJd/PxH7w8Iic4?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YnJaV3FIVFpZN1ZLSDJyR0pyanJ3Q1dHTG85VVRhcWVJZmZTSDRjcHhaTHZ3?=
 =?utf-8?B?RURNMWZpbW9lTGo3QXlwNXZMT3p0OXRvelMxS01seWkreUhFaFZTN3JDQzM1?=
 =?utf-8?B?a052VlBDcFQ2aVRBNTdTdFp0WnhobU03RWQ1MXRZalRhb2xTWEZRUFhzK1lv?=
 =?utf-8?B?R2VPMEFxK0RwMjg2TjJsTXAwVGpYcHFGQkRUaHBWNEZ1UDFaT2twOHk3VjZS?=
 =?utf-8?B?cXE2eTd6YW5SVVJFQ093d2gyN1ZGaXRWTEZMU1R4dWlyQVRRZmtYc2FyQzM3?=
 =?utf-8?B?cGFJYmptUDl0b2w0eDVENTNSbUFPUXRCN01oazNCS3BtUFRML1hENWtlUlZX?=
 =?utf-8?B?VWY0eDlUc2V0cnJacU5ialhsS2kwcjUyUGlTMERROFBOTUJhR0ttREtZMlBx?=
 =?utf-8?B?U2ovUE04Ulk5QWlIUVlaN3RzdDdtNkdLRS84RFJvV3FtSUp1eGdBU3p2akJn?=
 =?utf-8?B?QURBMm4rbHo2TUlKZnNzUnFQQVFncDFobjFjUFliU0RMK2dlYXhCbFpObWcr?=
 =?utf-8?B?ejMvQmxlYzFWckxudHZpQXl0czBhZGZpcGYvYzN3THNUMmtVb3FvYUlqeVJ5?=
 =?utf-8?B?QmxlNWJldVZyMFVhSlNxRUp1SGxSUFZzL25icXFaUWhESXZJeVBZcFBrNnRB?=
 =?utf-8?B?MzQ0cWpiLzcwS1VYZlcrNjJmU0lSYVdGeWw0b0Q2eENORDdQYnA0MW5XU2U2?=
 =?utf-8?B?VktlTm9vVENqMm14MEh2VFA4bW9vMGZBR2w1eXgxNk52Zk1sUkM3L1c5WUZC?=
 =?utf-8?B?UzNhMVNmWVNxdnNEN2hHbFpHVDQzUGZOSnpoS1lpNlM2STU1bDltN3l1Rkkv?=
 =?utf-8?B?UXBETmQ4K1p6OUhRNVprRVYvYkpCTCtnMHZUaWZ0L3d0TFBBTkFPakdsa2xy?=
 =?utf-8?B?UW1pMHlFK2NjQzZtR3RUeEhEZHVTZjlCTDlDelVRTFk1cnJkdTZvam9yWU9t?=
 =?utf-8?B?U1VCdGNKK3o0QzM3OElMeitVbmNkVUJGWTUyY05seE5GVG4ydVl1R0x1L215?=
 =?utf-8?B?SXFvREFDL0s0bjZQblFLdmlkSDV3bU05d1BNZkdCVWlwUVZWU2d3VXQxVkxu?=
 =?utf-8?B?dmM1aS93SUNBYTBPVGR0V0x6QVJWclRONzJEN3lwejRnMnBpSm9IN3RyTWVK?=
 =?utf-8?B?NzEzaTZCQndETU9RTmhnbVptQkVDRDBXcHJJYkJXbURvS2p4Y2x6akozWm9a?=
 =?utf-8?B?ZE1EMVZKMDgwYkZxY0pGYVcxNmhWcDBqc1dOOEhLOC9LTzlvR2dMU0d1cmg1?=
 =?utf-8?B?QXNMNm05MDlyZ3pScEFORUg1R2VxWVVibE43NkIwd3JoakRxTy9nZW1xajNG?=
 =?utf-8?B?TTUxNktJSWFveUlEd0ZuUmFZYzM0M0JZYzlHWFAwTXcwMTJGSDNSQ0xTamxS?=
 =?utf-8?B?SHFWQnR1eVZ3MzhUbDhFdmpIdERSK2J4UldDbHFaZlRpK3owVkt6TnBSSVh5?=
 =?utf-8?B?eUVFaW4rdmlwQzdnTDhNUmRQQmhwSDBUb0NQNTZFSTRaRXZNblloMUlkaGtt?=
 =?utf-8?B?NjQrbXV4NWsyS3Z4SSsyVzBlQkt4R0F0RlNTZWcwVXpVdlV6MjRPM3J2VHBq?=
 =?utf-8?B?ei9jSG1zNytqekFZN3B3VnlEWU9mY2NzU01rSXlac01RMGVOT3d6TTBkR01I?=
 =?utf-8?B?ekY4NWNmRElaREJRK3BObGRmdVdkcGppcExIOFMxZXFHUElDNTRUMHgyNWhO?=
 =?utf-8?B?UzNhMDIwWW0razQ2c0d2K1VPM0lWTGVPNXpIb3BkbDZ2SUpCdURKb3lYUUxi?=
 =?utf-8?B?T2JyUEtDNUZENU9jbmJuR1MvZ3dWdkNpc0hlbzgyR05GSklxaUxGL3N0RHNw?=
 =?utf-8?B?Qm1ocTVod2hmYmk0MDEwdHJYZlFOM21aZHVWaWtVZlN6U0dranhYYlNGMG1Y?=
 =?utf-8?B?OFE3ZjQwbEdwMDA5SGtYdlhNK2xoRTJDdXZxZnF4Y2JLSHhVYmRLNmNjMVkv?=
 =?utf-8?B?RWxUdnhMNHowUUZrY3M2Z3I1anA3WHZvcWRFRjZqN0lJcEltWEpmRnV1M0t5?=
 =?utf-8?B?N0dIYXZnaXcwZ3RlbVJ2TzI1S0FucENvWVJpSm41ZVhGWU8vYVFtNU1uUEIy?=
 =?utf-8?B?bTZEbUszM0tGVDhOVUV5WWtzNUdaRGdTOW14VG0xdGFsbU54dkpGSnhwVllu?=
 =?utf-8?B?amF3ZUZmVXMxbTZ5NEY0YUNuTGdubDdkc2RLMnBkZlhITEgreitNSG1vT0xj?=
 =?utf-8?B?UkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c052d0f3-a871-4b2e-0352-08de1e7fb0f6
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2025 04:31:31.4166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H50BfSb6Gy2P/i7ILP+xV/GAQUEUwkW9VLgTmwmrXvWSnd2Pp61CsruNn2o+M7IxbCwU0Nz2IlQkE6alOiScGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5924
X-OriginatorOrg: intel.com

On Wed, Nov 05, 2025 at 04:10:20PM +0100, Michał Winiarski wrote:
> Connect the helpers to allow save and restore of VRAM migration data in
> stop_copy / resume device state.
> 
> Co-developed-by: Lukasz Laguna <lukasz.laguna@intel.com>
> Signed-off-by: Lukasz Laguna <lukasz.laguna@intel.com>
> Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>

Reviewed-by: Matthew Brost <matthew.brost@intel.com>

> ---
>  drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c   |  17 ++
>  drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c | 211 ++++++++++++++++++
>  drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.h |   3 +
>  .../drm/xe/xe_gt_sriov_pf_migration_types.h   |   2 +
>  drivers/gpu/drm/xe/xe_sriov_pf_control.c      |   3 +
>  5 files changed, 236 insertions(+)
> 
> diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c b/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c
> index abc2bd09288ea..aae0c98657408 100644
> --- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c
> +++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c
> @@ -891,6 +891,20 @@ static int pf_handle_vf_save_data(struct xe_gt *gt, unsigned int vfid)
>  		return -EAGAIN;
>  	}
>  
> +	if (xe_gt_sriov_pf_migration_save_data_pending(gt, vfid,
> +						       XE_SRIOV_PACKET_TYPE_VRAM)) {
> +		ret = xe_gt_sriov_pf_migration_vram_save(gt, vfid);
> +		if (ret == -EAGAIN)
> +			return -EAGAIN;
> +		else if (ret)
> +			return ret;
> +
> +		xe_gt_sriov_pf_migration_save_data_complete(gt, vfid,
> +							    XE_SRIOV_PACKET_TYPE_VRAM);
> +
> +		return -EAGAIN;
> +	}
> +
>  	return 0;
>  }
>  
> @@ -1129,6 +1143,9 @@ static int pf_handle_vf_restore_data(struct xe_gt *gt, unsigned int vfid)
>  	case XE_SRIOV_PACKET_TYPE_GUC:
>  		ret = xe_gt_sriov_pf_migration_guc_restore(gt, vfid, data);
>  		break;
> +	case XE_SRIOV_PACKET_TYPE_VRAM:
> +		ret = xe_gt_sriov_pf_migration_vram_restore(gt, vfid, data);
> +		break;
>  	default:
>  		xe_gt_sriov_notice(gt, "Skipping VF%u unknown data type: %d\n", vfid, data->type);
>  		break;
> diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c b/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c
> index 22f471f269cfa..c62bb67c20a6b 100644
> --- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c
> +++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c
> @@ -19,6 +19,7 @@
>  #include "xe_gt_sriov_printk.h"
>  #include "xe_guc_buf.h"
>  #include "xe_guc_ct.h"
> +#include "xe_migrate.h"
>  #include "xe_mmio.h"
>  #include "xe_sriov.h"
>  #include "xe_sriov_packet.h"
> @@ -501,6 +502,205 @@ int xe_gt_sriov_pf_migration_mmio_restore(struct xe_gt *gt, unsigned int vfid,
>  	return pf_restore_vf_mmio_mig_data(gt, vfid, data);
>  }
>  
> +static ssize_t pf_migration_vram_size(struct xe_gt *gt, unsigned int vfid)
> +{
> +	if (!xe_gt_is_main_type(gt))
> +		return 0;
> +
> +	return xe_gt_sriov_pf_config_get_lmem(gt, vfid);
> +}
> +
> +static struct dma_fence *__pf_save_restore_vram(struct xe_gt *gt, unsigned int vfid,
> +						struct xe_bo *vram, u64 vram_offset,
> +						struct xe_bo *sysmem, u64 sysmem_offset,
> +						size_t size, bool save)
> +{
> +	struct dma_fence *ret = NULL;
> +	struct drm_exec exec;
> +	int err;
> +
> +	drm_exec_init(&exec, 0, 0);
> +	drm_exec_until_all_locked(&exec) {
> +		err = drm_exec_lock_obj(&exec, &vram->ttm.base);
> +		drm_exec_retry_on_contention(&exec);
> +		if (err) {
> +			ret = ERR_PTR(err);
> +			goto err;
> +		}
> +
> +		err = drm_exec_lock_obj(&exec, &sysmem->ttm.base);
> +		drm_exec_retry_on_contention(&exec);
> +		if (err) {
> +			ret = ERR_PTR(err);
> +			goto err;
> +		}
> +	}
> +
> +	ret = xe_migrate_vram_copy_chunk(vram, vram_offset, sysmem, sysmem_offset, size,
> +					 save ? XE_MIGRATE_COPY_TO_SRAM : XE_MIGRATE_COPY_TO_VRAM);
> +
> +err:
> +	drm_exec_fini(&exec);
> +
> +	return ret;
> +}
> +
> +#define PF_VRAM_SAVE_RESTORE_TIMEOUT (5 * HZ)
> +static int pf_save_vram_chunk(struct xe_gt *gt, unsigned int vfid,
> +			      struct xe_bo *src_vram, u64 src_vram_offset,
> +			      size_t size)
> +{
> +	struct xe_sriov_packet *data;
> +	struct dma_fence *fence;
> +	int ret;
> +
> +	data = xe_sriov_packet_alloc(gt_to_xe(gt));
> +	if (!data)
> +		return -ENOMEM;
> +
> +	ret = xe_sriov_packet_init(data, gt->tile->id, gt->info.id,
> +				   XE_SRIOV_PACKET_TYPE_VRAM, src_vram_offset,
> +				   size);
> +	if (ret)
> +		goto fail;
> +
> +	fence = __pf_save_restore_vram(gt, vfid,
> +				       src_vram, src_vram_offset,
> +				       data->bo, 0, size, true);
> +
> +	ret = dma_fence_wait_timeout(fence, false, PF_VRAM_SAVE_RESTORE_TIMEOUT);
> +	dma_fence_put(fence);
> +	if (!ret) {
> +		ret = -ETIME;
> +		goto fail;
> +	}
> +
> +	pf_dump_mig_data(gt, vfid, data, "VRAM data save");
> +
> +	ret = xe_gt_sriov_pf_migration_save_produce(gt, vfid, data);
> +	if (ret)
> +		goto fail;
> +
> +	return 0;
> +
> +fail:
> +	xe_sriov_packet_free(data);
> +	return ret;
> +}
> +
> +#define VF_VRAM_STATE_CHUNK_MAX_SIZE SZ_512M
> +static int pf_save_vf_vram_mig_data(struct xe_gt *gt, unsigned int vfid)
> +{
> +	struct xe_gt_sriov_migration_data *migration = pf_pick_gt_migration(gt, vfid);
> +	loff_t *offset = &migration->save.vram_offset;
> +	struct xe_bo *vram;
> +	size_t vram_size, chunk_size;
> +	int ret;
> +
> +	vram = xe_gt_sriov_pf_config_get_lmem_obj(gt, vfid);
> +	if (!vram)
> +		return -ENXIO;
> +
> +	vram_size = xe_bo_size(vram);
> +
> +	xe_gt_assert(gt, *offset < vram_size);
> +
> +	chunk_size = min(vram_size - *offset, VF_VRAM_STATE_CHUNK_MAX_SIZE);
> +
> +	ret = pf_save_vram_chunk(gt, vfid, vram, *offset, chunk_size);
> +	if (ret)
> +		goto fail;
> +
> +	*offset += chunk_size;
> +
> +	xe_bo_put(vram);
> +
> +	if (*offset < vram_size)
> +		return -EAGAIN;
> +
> +	return 0;
> +
> +fail:
> +	xe_bo_put(vram);
> +	xe_gt_sriov_err(gt, "Failed to save VF%u VRAM data (%pe)\n", vfid, ERR_PTR(ret));
> +	return ret;
> +}
> +
> +static int pf_restore_vf_vram_mig_data(struct xe_gt *gt, unsigned int vfid,
> +				       struct xe_sriov_packet *data)
> +{
> +	u64 end = data->hdr.offset + data->hdr.size;
> +	struct dma_fence *fence;
> +	struct xe_bo *vram;
> +	size_t size;
> +	int ret = 0;
> +
> +	vram = xe_gt_sriov_pf_config_get_lmem_obj(gt, vfid);
> +	if (!vram)
> +		return -ENXIO;
> +
> +	size = xe_bo_size(vram);
> +
> +	if (end > size || end < data->hdr.size) {
> +		ret = -EINVAL;
> +		goto err;
> +	}
> +
> +	pf_dump_mig_data(gt, vfid, data, "VRAM data restore");
> +
> +	fence = __pf_save_restore_vram(gt, vfid, vram, data->hdr.offset,
> +				       data->bo, 0, data->hdr.size, false);
> +	ret = dma_fence_wait_timeout(fence, false, PF_VRAM_SAVE_RESTORE_TIMEOUT);
> +	dma_fence_put(fence);
> +	if (!ret) {
> +		ret = -ETIME;
> +		goto err;
> +	}
> +
> +	return 0;
> +err:
> +	xe_bo_put(vram);
> +	xe_gt_sriov_err(gt, "Failed to restore VF%u VRAM data (%pe)\n", vfid, ERR_PTR(ret));
> +	return ret;
> +}
> +
> +/**
> + * xe_gt_sriov_pf_migration_vram_save() - Save VF VRAM migration data.
> + * @gt: the &xe_gt
> + * @vfid: the VF identifier (can't be 0)
> + *
> + * This function is for PF only.
> + *
> + * Return: 0 on success or a negative error code on failure.
> + */
> +int xe_gt_sriov_pf_migration_vram_save(struct xe_gt *gt, unsigned int vfid)
> +{
> +	xe_gt_assert(gt, IS_SRIOV_PF(gt_to_xe(gt)));
> +	xe_gt_assert(gt, vfid != PFID);
> +	xe_gt_assert(gt, vfid <= xe_sriov_pf_get_totalvfs(gt_to_xe(gt)));
> +
> +	return pf_save_vf_vram_mig_data(gt, vfid);
> +}
> +
> +/**
> + * xe_gt_sriov_pf_migration_vram_restore() - Restore VF VRAM migration data.
> + * @gt: the &xe_gt
> + * @vfid: the VF identifier (can't be 0)
> + *
> + * This function is for PF only.
> + *
> + * Return: 0 on success or a negative error code on failure.
> + */
> +int xe_gt_sriov_pf_migration_vram_restore(struct xe_gt *gt, unsigned int vfid,
> +					  struct xe_sriov_packet *data)
> +{
> +	xe_gt_assert(gt, IS_SRIOV_PF(gt_to_xe(gt)));
> +	xe_gt_assert(gt, vfid != PFID);
> +	xe_gt_assert(gt, vfid <= xe_sriov_pf_get_totalvfs(gt_to_xe(gt)));
> +
> +	return pf_restore_vf_vram_mig_data(gt, vfid, data);
> +}
> +
>  /**
>   * xe_gt_sriov_pf_migration_size() - Total size of migration data from all components within a GT.
>   * @gt: the &xe_gt
> @@ -540,6 +740,13 @@ ssize_t xe_gt_sriov_pf_migration_size(struct xe_gt *gt, unsigned int vfid)
>  		size += sizeof(struct xe_sriov_pf_migration_hdr);
>  	total += size;
>  
> +	size = pf_migration_vram_size(gt, vfid);
> +	if (size < 0)
> +		return size;
> +	if (size > 0)
> +		size += sizeof(struct xe_sriov_pf_migration_hdr);
> +	total += size;
> +
>  	return total;
>  }
>  
> @@ -602,6 +809,7 @@ void xe_gt_sriov_pf_migration_save_init(struct xe_gt *gt, unsigned int vfid)
>  	struct xe_gt_sriov_migration_data *migration = pf_pick_gt_migration(gt, vfid);
>  
>  	migration->save.data_remaining = 0;
> +	migration->save.vram_offset = 0;
>  
>  	xe_gt_assert(gt, pf_migration_guc_size(gt, vfid) > 0);
>  	pf_migration_save_data_todo(gt, vfid, XE_SRIOV_PACKET_TYPE_GUC);
> @@ -611,6 +819,9 @@ void xe_gt_sriov_pf_migration_save_init(struct xe_gt *gt, unsigned int vfid)
>  
>  	xe_gt_assert(gt, pf_migration_mmio_size(gt, vfid) > 0);
>  	pf_migration_save_data_todo(gt, vfid, XE_SRIOV_PACKET_TYPE_MMIO);
> +
> +	if (pf_migration_vram_size(gt, vfid) > 0)
> +		pf_migration_save_data_todo(gt, vfid, XE_SRIOV_PACKET_TYPE_VRAM);
>  }
>  
>  /**
> diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.h b/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.h
> index 04b3ed0d2aa23..181207a637b93 100644
> --- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.h
> +++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.h
> @@ -25,6 +25,9 @@ int xe_gt_sriov_pf_migration_ggtt_restore(struct xe_gt *gt, unsigned int vfid,
>  int xe_gt_sriov_pf_migration_mmio_save(struct xe_gt *gt, unsigned int vfid);
>  int xe_gt_sriov_pf_migration_mmio_restore(struct xe_gt *gt, unsigned int vfid,
>  					  struct xe_sriov_packet *data);
> +int xe_gt_sriov_pf_migration_vram_save(struct xe_gt *gt, unsigned int vfid);
> +int xe_gt_sriov_pf_migration_vram_restore(struct xe_gt *gt, unsigned int vfid,
> +					  struct xe_sriov_packet *data);
>  
>  ssize_t xe_gt_sriov_pf_migration_size(struct xe_gt *gt, unsigned int vfid);
>  
> diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration_types.h b/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration_types.h
> index 9f24878690d9c..f50c64241e9c0 100644
> --- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration_types.h
> +++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration_types.h
> @@ -20,6 +20,8 @@ struct xe_gt_sriov_migration_data {
>  	struct {
>  		/** @save.data_remaining: bitmap of migration types that need to be saved */
>  		unsigned long data_remaining;
> +		/** @save.vram_offset: last saved offset within VRAM, used for chunked VRAM save */
> +		loff_t vram_offset;
>  	} save;
>  };
>  
> diff --git a/drivers/gpu/drm/xe/xe_sriov_pf_control.c b/drivers/gpu/drm/xe/xe_sriov_pf_control.c
> index 87205f0505ad0..eec218c710278 100644
> --- a/drivers/gpu/drm/xe/xe_sriov_pf_control.c
> +++ b/drivers/gpu/drm/xe/xe_sriov_pf_control.c
> @@ -5,6 +5,7 @@
>  
>  #include "xe_device.h"
>  #include "xe_gt_sriov_pf_control.h"
> +#include "xe_gt_sriov_pf_migration.h"
>  #include "xe_sriov_packet.h"
>  #include "xe_sriov_pf_control.h"
>  #include "xe_sriov_printk.h"
> @@ -171,6 +172,8 @@ int xe_sriov_pf_control_trigger_save_vf(struct xe_device *xe, unsigned int vfid)
>  		return ret;
>  
>  	for_each_gt(gt, xe, id) {
> +		xe_gt_sriov_pf_migration_save_init(gt, vfid);
> +
>  		ret = xe_gt_sriov_pf_control_trigger_save_vf(gt, vfid);
>  		if (ret)
>  			return ret;
> -- 
> 2.51.2
> 

