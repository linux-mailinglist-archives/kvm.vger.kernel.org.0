Return-Path: <kvm+bounces-48369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0173FACD785
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 07:43:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B6DC6165A97
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 05:43:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A7C3262FC1;
	Wed,  4 Jun 2025 05:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VJv0+SZv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE229139B;
	Wed,  4 Jun 2025 05:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749015802; cv=fail; b=LfCNl9K+jRWTr1HxNPFH68L75zzoWN6CJrlI1f6bGbMa9JciRN4yIb6w9NhU8wr/N+qwfCtwKrqzSqQVRYFCCBzEUg45z6j1b5wOytBTQOP4PWqF0U1uMNd6G++c7dK5qPj8lQChiSKAQ8NbidZ9+OjbgDoafWE554XvapU2al4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749015802; c=relaxed/simple;
	bh=MPHw25y4DmUAgp23TMA8uwg+FMpH3wMAc7BegigXDlw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OThQTSMBHvrhFNym6mpi4kWqQY5bR/AAB7vcIbB7XVRrm8AT4RR3FNb3RNSC8lTjAgBSQnvigEMohZ2VdILQbW8SZvYmCwnKFU33eCyXKP+cBnPvLJq0IGDp8jApq476wV/IdjjdOPcE4Dv6LwcupDI/a4RGPAtQ8L4FjTeKVRM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VJv0+SZv; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749015801; x=1780551801;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=MPHw25y4DmUAgp23TMA8uwg+FMpH3wMAc7BegigXDlw=;
  b=VJv0+SZvq9AcnDA2ubNOA9dPkXzL7oNQ+HkTRYzCggqUk0cxF/KBMlQP
   GjvWhmE+X1wWU3jHizLvXDdOY98yiVCNtt3WiIny/rTzIhsEh6VIOi7QG
   VVtzhrQIWjIvTtUCSyfnzK10dtVTli3By5O5hxCQfgQ8CBnWbPbHmk8TH
   NLNEhj/zaAAVHXe21dqB3i299Za0POiSbKVsaAtK0aepJxolDyT9NMOkn
   MfKG4RfzDDjWgL7rsOcXiei34Hhuf4Pw/8bgykFSbJMw4FcVAYLYvZUGO
   AUZ+YV4gj8L56jtOkrYPBUWD0lCqrP1fQ8kh7czm2KAuQHfwjr56b/IE9
   Q==;
X-CSE-ConnectionGUID: N4hZJ+oxRk2L+eQowAemuw==
X-CSE-MsgGUID: e1NdSYTwRRComnzYsivWwQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="50774428"
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="50774428"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 22:43:20 -0700
X-CSE-ConnectionGUID: PC0XtmGuTdGLgJTvMz8ErA==
X-CSE-MsgGUID: enmYR96eRwm5R7JGteSNmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="145045886"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 22:43:19 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 22:43:18 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 3 Jun 2025 22:43:18 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.83)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 3 Jun 2025 22:43:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BgiPgSp47NvlmSJb2vaYGEIcL5NKqEidoPuzKO02ps6ASgkCCzX2rl74KseQlbXSQ+j9dZBYDpSrGsu6LEVtXtRy8w7mx1OqZ7DX1nCpRcRm4GauQzHLcnvDH2Da741GER8UHZRS9UKO0SNCIqPucnEZ1orZ7Dt4CSiLD3vZ1b5ESK37/vU3OTbkzFX3n8I5uhZR1SbPBKkYouma6rkojvgh4ejyptRrPxmotqr3RFsEdmCFCXROeLbI49K8dqKLKZMAcT4nP6es1ttRO2FV9OoQiWrspilvDXLPsO6xNugj/+gOJejciZJizfCGiVJnXZHF8FBAY9pcV1XfydYi9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bsWqvCZ+PpdzGloWkeLf2h6E8QlNG43zHQO2bO6Tk8g=;
 b=BKnTMeEjAHonb83scM3q3W+6sRV8Je/RXZ2ZCXwv7QTSVPE13IORsS/gwr0qRnln3OUNKnmqgdFzJAHALq1gFlKbOwbVpQHvkPge3S1gO42gghBBS8QGRnbINCLwjJgD0L0lHkWQdUZaDGfaMxQNCOy4xon3m38OYLnTYbs8HA0bm7xidTwURMn0wz94VhJju8BwvvsAEkBDcTivyS7lKBKlgSgBTF5J3AX3xBZfqkvYDjzHQ1Am0uzKBH0Nsyv/ykB8ZKlC3Z/hAVTVaBfImwbmNCLCJrIcnmW2Ah4siEaMYHyrZgEGtYwPwxhXmse5GWfaz5kytv8l24b2aARjaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH0PR11MB5031.namprd11.prod.outlook.com (2603:10b6:510:33::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.32; Wed, 4 Jun
 2025 05:43:15 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8769.031; Wed, 4 Jun 2025
 05:43:14 +0000
Date: Wed, 4 Jun 2025 13:43:05 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Xin Li
	<xin@zytor.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: Re: [PATCH 08/28] KVM: nSVM: Use dedicated array of MSRPM offsets to
 merge L0 and L1 bitmaps
Message-ID: <aD/c6RZvE7a1KSqk@intel.com>
References: <20250529234013.3826933-1-seanjc@google.com>
 <20250529234013.3826933-9-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250529234013.3826933-9-seanjc@google.com>
X-ClientProxiedBy: SG2P153CA0025.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::12)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH0PR11MB5031:EE_
X-MS-Office365-Filtering-Correlation-Id: a5d1875b-f743-4729-21a4-08dda32ab2ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?uq1PqCRHzysYKdHgsfr7qMaOndcS3apdDLwsFvAiSA//9Ebz6gypkfbOiw8h?=
 =?us-ascii?Q?WLZsulzZ0gRM75qMrtD9olcHDsUy4BL9xuXimS1n6JJn/ttaRPT7Vz93cZaf?=
 =?us-ascii?Q?ljTx+HqwycR2dbJ7UwPme/uvNjmDaoaciCSr7X5oWVSMA27kMjQWow3dZ7BK?=
 =?us-ascii?Q?ilagS8vaTTXA9GvTy08Rrf+zMljXca2dm3ncGo2govH0efj8nz7qvGQ5kjgT?=
 =?us-ascii?Q?8Ec6/s7EBrYh1Hj003w0DbBQYIwPJMPY0lftrUtGbV7VGwoJilWX8mLuR+vt?=
 =?us-ascii?Q?i7pULxY2aoSh30kDjTQVRXnSnM0/q6ofTHbsTqZ7wmAe5cwsU8Z1cBPUJcHY?=
 =?us-ascii?Q?e70wU3+LStoEKiOTb8paj+yIAf7Y4HQXNi+PWwI8VBMdbAfGiLhHGvJLXSVF?=
 =?us-ascii?Q?k2RriatbhJVlJIo21QqWv/edcLGkLXJ+lUyQxTEPqmrq8OfY5OlUczFlX+fv?=
 =?us-ascii?Q?+UA9cypSV38g3LvlKmMz5iw/vMTWgo2wIFsI/E9eFNaXlx6UOx68MF6w7bbz?=
 =?us-ascii?Q?PlMtKbraLjIJbWOUdbmEqAPX0NPUcvqvK6UxukZ5PCjT+qnhlKr+9AOuwpEV?=
 =?us-ascii?Q?pgtA4UUfEF3mGVn9R75rBqf+I8FWymCPd0zngFNtzlLN9gmYo0MZbDWog5rD?=
 =?us-ascii?Q?f5ajru8nOKhjfo4DW5O98IY6hqP6a6PKzu5gfsjIgBFxLU04ztK0+JEThKIe?=
 =?us-ascii?Q?UkhbjbE9Ht6YboUXrAf2sqV/AgcSxfIjoRaU3P+sawsw8vLAqEBeYv3O24pa?=
 =?us-ascii?Q?9xx6Cml9U0olxih9qKNKUA47z+HLP7Yn3TtJ1w03mSjP1HQuVkYCvZTwvqrh?=
 =?us-ascii?Q?eeLGCjVzchhjwcaJD8mnUypaL5Fo3Tdmg26WqlYPaAcG8hXpuBK7utlRO9rN?=
 =?us-ascii?Q?h5Sk0ojeoirzw4eVulnqZ/Qslgt2R86Y2Sdh0JcoFKccdkv1xWA3ld+cTnUw?=
 =?us-ascii?Q?NqyyORF7oBPGvv6X1La3VGbPkrgU5q4Px7ywl9indW1c6HMhj+BrPZ9iQOZ+?=
 =?us-ascii?Q?dFsI6Gnch5nx7QAJiGbLlznIpnXous56Z5oXF1vEGYPRwaiP5+fwOgvKwC+O?=
 =?us-ascii?Q?+uILbjqVBl8tPXyJk8NrLSf8xjpTpUD7UATrB2ehfEXN3C3kaLoxyo1qNy2G?=
 =?us-ascii?Q?JgK6feDOz6MMStd8n93LUK2Z2Gh6aP0TOwGNR+qJDhFywsk2UgMy90LpDeR/?=
 =?us-ascii?Q?ZAuuAM/LUYlIbdJB0IAiAGUtMAqaFtMAsyZS6MwvayYcviA6aVbKhUr5Wjct?=
 =?us-ascii?Q?zvacU/AG+ooVAplFFYPqC1REQdC6L3fRTMcPWmhB3ouVjDhoSCkMaFi/gwMQ?=
 =?us-ascii?Q?9cmU6vHlZIoaXJ9WXnFJULgJBj733iZOPxa5pU5t3fFKxU+BTeZS/o3+OLjE?=
 =?us-ascii?Q?jd6O0h+mXIr0HMCYydm5q9fLzlcHpNl7pIcw5zlUzyOVPrPj65uo1NmLGLEh?=
 =?us-ascii?Q?zDmr+NI9rb4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qKRJQrdqNVcYZeIg7/yiLVHcs+qIiaOjDCClUyNHeUCJ9ZsHv+NdEY2Y+oHd?=
 =?us-ascii?Q?ydVijiZKh7Wjc+w6KYj0t0pWUiX6sf48TmLcBSnb88azz1KP/QqFO/iXO4va?=
 =?us-ascii?Q?8bgKtTkerSdCpmPwXyCmevFgdyn1iPhRSxfTvkRwW19Cwh90dGzsUXXx70Lr?=
 =?us-ascii?Q?tjkFHO2BWRaY4hFKdX2rqSIPaekQoM5ZLKPkcoj7nE8jXfKMgpg35NMwE2dg?=
 =?us-ascii?Q?+VB+dlhHfmZ2GxWR1glNw6XfvkvZiZirRTw50dNj7LKpslJMRDYaxcJqSwr0?=
 =?us-ascii?Q?MEhX9NTARfaGRVLrJRUiHlMrypBl8MB1M6yX/JTMoqxAY5Upp9zGiLzWIzQc?=
 =?us-ascii?Q?We+wHd5wXNlnjO++QOBYAH8ze2h6bqx6FCx5vOvSP1vaWqPnY5vp1MBtBvJb?=
 =?us-ascii?Q?zxFHhMySCgPx5w6ZltmoTq2OPyvqQryFScrQOhFcFilPvCaHoxsY9AraeEQt?=
 =?us-ascii?Q?3erdCpl0i4zvXkFBkNpHgflekX71nJyXA/qb1nYGlyumfmrtUiQzkAluPfZF?=
 =?us-ascii?Q?EF4P/lPTHgaUyThk+DY0k55z5iWLf18767gRDNIsWvyXSAeqzfnHI3/m2Lki?=
 =?us-ascii?Q?y05+tuNDHJ6JBW+LtYYIQRcOrIBgiSR/NK1OLJC42tKipxpuXZ9BjT/1qozB?=
 =?us-ascii?Q?AGTHuye9zbOZCakGueSOL0gXptAom4qOkswfTdXN9A/o/F55gEiFicp8wFqL?=
 =?us-ascii?Q?2r3ndu3HuJOmDnEpxhvJEXrAY6hGrqr4eHh35TqNmGC6+OLkgJb2beQqr4Zo?=
 =?us-ascii?Q?+bYvD5cKX7q1GMMPAbMJ8PaZ/OX0V+VZ6/CK6VswxFxmS0386mt2111iRq1Q?=
 =?us-ascii?Q?Uw4jaBGTsuZMnxQJm/homPzd4tx1IfG13t57iJ4MYG4jDWzVbAmG/4hiHWwv?=
 =?us-ascii?Q?HVper2SWtMAYFPcmKgrQwf9d7s4Osw5YsjtRbBpx79aJVuSJPanlFav7RL/P?=
 =?us-ascii?Q?WrAu9eXisq3TMXw42kvtwcaDfllYe/3q2zN7V+LPPhQFQ4K/gJ5eFuN4SNnk?=
 =?us-ascii?Q?REyTx2ZQoL/ElGp3nV7Ofcf0WFn0hxqmL0S0TznLcD18i1jyjLJrC72wy0FY?=
 =?us-ascii?Q?/uH5lGKlh3MUlyizKi9aGt4Vy/E0yRdFeaVURvyhv54uWD4FxV3oVcxkpCNQ?=
 =?us-ascii?Q?z/B8DPPLlJch9UvBA9XBRxA7jrktRyJ3lRMkSK7GuoqdHP+hjChuaog4SFs4?=
 =?us-ascii?Q?3wzhP6Oz7fpTMt9xYK3Ri0RSnDMwq1P6kZ4QaClIfjmNsh2Cz/mgarB+NY6N?=
 =?us-ascii?Q?4mJkOMTpMX7IEIYz1utPv+5UCdBX1v95zaxVdS15IKuohnK9EMKxgY49lz/K?=
 =?us-ascii?Q?wVjlxZoUiIfwPBw782wvU9OPEZxqvRx/qPlT0LyiCIUUcrGj7dCxIaOFDHO8?=
 =?us-ascii?Q?L0X+hh1FiztHKp8VDdH0XzHrVsdpldVzCxoHDqAg+i3pazJxTO8phXNH7R9q?=
 =?us-ascii?Q?61ODvpCzNWrqT4ZrWF/F7QC3YIbGzlsubHTXJ10RjX7jXvCNfge+2x54LPIp?=
 =?us-ascii?Q?5uHktkYcFsJSlVIrUpy7AWFDCj9bQrFhbO9slIXBUi4RqrRqboYXcpOR4SDd?=
 =?us-ascii?Q?NDJKZpmZvPejeQY/NUf2DWpUV7hlO8pPAJEj5OQN?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a5d1875b-f743-4729-21a4-08dda32ab2ef
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 05:43:14.5080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NPZZlGcGN5blfBTRsnvK7fBrgG0fuS2E9QVrRJQDKzCBTq+c1tOKQHMOAqghpjcVQGD/WpTKZlcC6UnK79KkZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5031
X-OriginatorOrg: intel.com

On Thu, May 29, 2025 at 04:39:53PM -0700, Sean Christopherson wrote:
>Use a dedicated array of MSRPM offsets to merge L0 and L1 bitmaps, i.e. to
>merge KVM's vmcb01 bitmap with L1's vmcb12 bitmap.  This will eventually
>allow for the removal of direct_access_msrs, as the only path where
>tracking the offsets is truly justified is the merge for nested SVM, where
>merging in chunks is an easy way to batch uaccess reads/writes.
>
>Opportunistically omit the x2APIC MSRs from the merge-specific array
>instead of filtering them out at runtime.
>
>Note, disabling interception of XSS, EFER, PAT, GHCB, and TSC_AUX is
>mutually exclusive with nested virtualization, as KVM passes through the
>MSRs only for SEV-ES guests, and KVM doesn't support nested virtualization
>for SEV+ guests.  Defer removing those MSRs to a future cleanup in order
>to make this refactoring as benign as possible.
>
>Signed-off-by: Sean Christopherson <seanjc@google.com>
>---
> arch/x86/kvm/svm/nested.c | 72 +++++++++++++++++++++++++++++++++------
> arch/x86/kvm/svm/svm.c    |  4 +++
> arch/x86/kvm/svm/svm.h    |  2 ++
> 3 files changed, 67 insertions(+), 11 deletions(-)
>
>diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
>index 89a77f0f1cc8..e53020939e60 100644
>--- a/arch/x86/kvm/svm/nested.c
>+++ b/arch/x86/kvm/svm/nested.c
>@@ -184,6 +184,64 @@ void recalc_intercepts(struct vcpu_svm *svm)
> 	}
> }
> 
>+static int nested_svm_msrpm_merge_offsets[9] __ro_after_init;

I understand how the array size (i.e., 9) was determined :). But, adding a
comment explaining this would be quite helpful 

>+static int nested_svm_nr_msrpm_merge_offsets __ro_after_init;
>+
>+int __init nested_svm_init_msrpm_merge_offsets(void)
>+{
>+	const u32 merge_msrs[] = {
>+		MSR_STAR,
>+		MSR_IA32_SYSENTER_CS,
>+		MSR_IA32_SYSENTER_EIP,
>+		MSR_IA32_SYSENTER_ESP,
>+	#ifdef CONFIG_X86_64
>+		MSR_GS_BASE,
>+		MSR_FS_BASE,
>+		MSR_KERNEL_GS_BASE,
>+		MSR_LSTAR,
>+		MSR_CSTAR,
>+		MSR_SYSCALL_MASK,
>+	#endif
>+		MSR_IA32_SPEC_CTRL,
>+		MSR_IA32_PRED_CMD,
>+		MSR_IA32_FLUSH_CMD,

MSR_IA32_DEBUGCTLMSR is missing, but it's benign since it shares the same
offset as MSR_IA32_LAST* below.

I'm a bit concerned that we might overlook adding new MSRs to this array in the
future, which could lead to tricky bugs. But I have no idea how to avoid this.
Removing this array and iterating over direct_access_msrs[] directly is an
option but it contradicts this series as one of its purposes is to remove
direct_access_msrs[].

>+		MSR_IA32_LASTBRANCHFROMIP,
>+		MSR_IA32_LASTBRANCHTOIP,
>+		MSR_IA32_LASTINTFROMIP,
>+		MSR_IA32_LASTINTTOIP,
>+
>+		MSR_IA32_XSS,
>+		MSR_EFER,
>+		MSR_IA32_CR_PAT,
>+		MSR_AMD64_SEV_ES_GHCB,
>+		MSR_TSC_AUX,
>+	};


> 
> 		if (kvm_vcpu_read_guest(vcpu, offset, &value, 4))
>diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>index 1c70293400bc..84dd1f220986 100644
>--- a/arch/x86/kvm/svm/svm.c
>+++ b/arch/x86/kvm/svm/svm.c
>@@ -5689,6 +5689,10 @@ static int __init svm_init(void)
> 	if (!kvm_is_svm_supported())
> 		return -EOPNOTSUPP;
> 
>+	r = nested_svm_init_msrpm_merge_offsets();
>+	if (r)
>+		return r;
>+

If the offset array is used for nested virtualization only, how about guarding
this with nested virtualization? For example, in svm_hardware_setup():

	if (nested) {
		r = nested_svm_init_msrpm_merge_offsets();
		if (r)
			goto err;

		pr_info("Nested Virtualization enabled\n");
		kvm_enable_efer_bits(EFER_SVME | EFER_LMSLE);
	}


> 	r = kvm_x86_vendor_init(&svm_init_ops);
> 	if (r)
> 		return r;
>diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
>index 909b9af6b3c1..0a8041d70994 100644
>--- a/arch/x86/kvm/svm/svm.h
>+++ b/arch/x86/kvm/svm/svm.h
>@@ -686,6 +686,8 @@ static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
> 	return vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_NMI);
> }
> 
>+int __init nested_svm_init_msrpm_merge_offsets(void);
>+
> int enter_svm_guest_mode(struct kvm_vcpu *vcpu,
> 			 u64 vmcb_gpa, struct vmcb *vmcb12, bool from_vmrun);
> void svm_leave_nested(struct kvm_vcpu *vcpu);
>-- 
>2.49.0.1204.g71687c7c1d-goog
>

