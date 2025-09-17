Return-Path: <kvm+bounces-57824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EE33B7C3E1
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 13:56:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 716D4173C04
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 08:17:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F7A2307AEB;
	Wed, 17 Sep 2025 08:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aLgO6Oyl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE222307AC6;
	Wed, 17 Sep 2025 08:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758097020; cv=fail; b=G0k037euPEf+7XY5Gz+tl9IDe4IwNZOX3vMkcVR/615Z/M1tiGqDWCn8PBticxnjlOyzkcL5FWbx5lRoye00dxZ2Bmlgj3TT8/+eG6Lu/pVzADBrP/cq3Q7XfJJw49g1Aok24vGjD0pbNNa50IQMah4iHM8CRYjdC2xwNCwyLTI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758097020; c=relaxed/simple;
	bh=WfiOsq9dknrChgRzb0bpqOdbYs2MaFeIK/dlNkLf+EE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ba3xSSkWYgcOhZ/QeLpjfUD9pi8Fms8J8QPVL6uzeRYeMLfqNWWWvLeieiI3z/cRkX3N49yay9cciLMS9HvD5mbWV12d5e+OhT8Rc13oPhjNauBgk6ESGQYhsnWqoQQQm+HiZ9nCIo2W8Ud4tyclEsCg0L23H31JdIUcybCAVl8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aLgO6Oyl; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758097018; x=1789633018;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=WfiOsq9dknrChgRzb0bpqOdbYs2MaFeIK/dlNkLf+EE=;
  b=aLgO6Oyl/dmfWHv3PHRiRzoPfWWc2DsigbS8d/3hGAFseQlcVZoAlg7G
   qrpadCky3T/11nfycGDizg0rtDfinFF6fpPlZabSMJcfDCFVeO4KMjQBo
   j5qLS581HIAR4Iqo0Y4tlifud5uKVhdJA9+Ed58TosiaRXAHYtwXWwJ4Y
   11Tdr9RI6x7s8NTT7nUaGVsx8wi0oaHGfqCFWVnwTB1R5Pvy+vPPgL+bw
   rX9+BabUm/NpzfDxP9eh8EmlnQrBb6ZCcrMH7TrHmj10PXy9LC+MA5s0/
   8BgdP1SRVah8qKEzF3PUZ3xEdUg5K/EyfYS4baaPtlUnZoa4uLWq3eZ9F
   Q==;
X-CSE-ConnectionGUID: euyIe5tbScGfcKTCuCEqig==
X-CSE-MsgGUID: mc39FyL1SNekdO4YCpnXMQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11555"; a="77834860"
X-IronPort-AV: E=Sophos;i="6.18,271,1751266800"; 
   d="scan'208";a="77834860"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 01:16:58 -0700
X-CSE-ConnectionGUID: s5I0wWDWTnidv91vyER2Eg==
X-CSE-MsgGUID: MOS0KCWxTWuUqHkG3NyC7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,271,1751266800"; 
   d="scan'208";a="175612664"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 01:16:57 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 17 Sep 2025 01:16:55 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 17 Sep 2025 01:16:55 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.13) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 17 Sep 2025 01:16:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cMm5zuGzVXuobKgvbYZX28gb7rVkLwGumlPqsRx0L/lZpOkE1ODmpNzgedx+I05qSD8o5B0SVleawdhlCjjzwWMjcrrr2cmYzSts0UBvx5bpY6t3IjMJRl1HGI0RyjSzkVMLDW2PJB4/TvZ0cMEIAPsGpUf2g2T+ubAD9PtORYQaQGSKeK0OJf8zLe+4lnZ6pJvsWlRofmbLDrpkpCie7FcfGYP5QvcMsEA4D7IJjkdzfhbyHQAHjqI8fx7hXENunFnn6/+fLH0h2LkEx4nRSpskuoWyTkQnY+LU44utRN+aY5JlTo02IZp7nSEj1MZgc2yb2Vhg109/7iSaLcDXJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p7agYuf/wDjF/Te1GVc+bCAq2MoCxvD/Tt01509J5WQ=;
 b=L3Z/65X+J7Z1Zr9In5lDQjFYJCKLVBAMPvSQafDVvX2qIQifgf4LlqrBum06GF1c2OKUqWRDyXYFl59/7oA/eYeYrGGjsPjyPHMUPp/7gpCNW2cXtcqGSTKUHaQ60Jj1YDR9i4C4SCDv8h99P7EaS+KXoCSS6wQrIcYhcbUXK3V2TUyDLPRCVeqZy5vZjvINNXiUHF5i3erctsbLldOdo+8hUrjxk/wZPco5gSCnVMhkjPhk1WGks0UD/CJbEXePy54nq2E+GkXt7dY4d/oHb10gip8woYkUqznoT/89k+7F/bYepzb7vcFNvc58bi05aZH7lMZc0q9/A4AV0AwFHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DM3PPF7D18F34A1.namprd11.prod.outlook.com (2603:10b6:f:fc00::f32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Wed, 17 Sep
 2025 08:16:52 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9115.022; Wed, 17 Sep 2025
 08:16:52 +0000
Date: Wed, 17 Sep 2025 16:16:41 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Maxim Levitsky
	<mlevitsk@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z
	<yi.z.zhang@linux.intel.com>
Subject: Re: [PATCH v15 18/41] KVM: x86: Don't emulate instructions affected
 by CET features
Message-ID: <aMpuaVeaVQr3ajvB@intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-19-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250912232319.429659-19-seanjc@google.com>
X-ClientProxiedBy: SI1PR02CA0041.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::18) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DM3PPF7D18F34A1:EE_
X-MS-Office365-Filtering-Correlation-Id: c4d4f593-280d-44ee-d7e6-08ddf5c28e5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?4BVRD5zvD/PjpTqFMclYzALEqhbJlxWe++P73kliy3r30Tba8TW0RC7eU6XX?=
 =?us-ascii?Q?0CZOd5CvonBuHtsm/YbNRDRYCSmyJeN0ndd0ma8vtrL7MBq1QcIjGvwDGLuP?=
 =?us-ascii?Q?w9UW/k4AySNvLwhHQ5/DKDpEhWiD/1cn1l4BIbK7PQnL+znKDhoug0wMVUes?=
 =?us-ascii?Q?cm+TUf9FlsnnJTh1ldPJ7hMuXWo6FRG3dBtDV0BYJTHK03w2/ekiyrdfmEeL?=
 =?us-ascii?Q?miIoiD/nX0hLOTS/Ky4H/nj8HQzpLr4En3OdbBVroIeCLAyIDSTi3bqZyG0C?=
 =?us-ascii?Q?Mq9/xkz2SxpVCoRj0USgCcUEnUJv0QMduOjl76wwCd4Xcc12aQiRfoY1e3rT?=
 =?us-ascii?Q?ToWZ3r3hUFM3v3VN2/bFhtwQA0f6I3wMR3SpAxQGqmre61tXQo5KsIERNIOv?=
 =?us-ascii?Q?alGYIyR+5Fz6g4Hh5P4B6AcDGAIoWBPUKnT4tBmxNd31HPTBzoVzjyqpyhto?=
 =?us-ascii?Q?ajvk/65jD9WSYS4fKNCvzMY1DTkoMKmNEU8VH2KwJ+NEsFukINB5vPZX5wQg?=
 =?us-ascii?Q?C6xSHlyrc6b8cD6xzlm6lQBaTvYXrtoyaHKZ98u4ImcTuarchKOoYlIO+Bz/?=
 =?us-ascii?Q?CQBXgquElprqTLlorhAEVYhyXuXwmXOO334PPXMNrI3YxCXli2H3UWbRRJIc?=
 =?us-ascii?Q?cPgupNBqA9O1mIXmHI+W4kif0hwtGlDKyUm2Ar+OOmz1d0bszuNwfJ+6UrAj?=
 =?us-ascii?Q?YQc9I0iQiIP2obTpYbuFDK38/umJhinYbZgAEoGh5WVKg4HpeTrlPgosw2E3?=
 =?us-ascii?Q?+ZOblrOvoWprK/urgG9kHlEmFyNYhwV6eAzdENoc9cFzEdeHNAIXXtIP52G7?=
 =?us-ascii?Q?N0COiQNQ57nOOdog4IvuagEiGoo+mtpj5Ud5JQW2OZRinjJKT7y2pFg+qixI?=
 =?us-ascii?Q?WQ6GBXTtTqY30vHCrYBN1Ax31aBjHTvs/fg8tcyLphfagbLeNva2OnThpgPm?=
 =?us-ascii?Q?as3MZx9bAxjAAeMxg+LoMdaLsK1lrshCpXVns2R2X1LsEwfcZXj7VzyQQkCy?=
 =?us-ascii?Q?CfykOxnb2/qYo24wKAJDTy4x4xX9QQvedurwEWShv8L4MUXxv6saK3H6Xyuq?=
 =?us-ascii?Q?sV3rC+g0fM0ZAQQIkxxwQPb2j6dV5Wn/0qCxm9cHUcFcUXyq72q24wZdbBTw?=
 =?us-ascii?Q?ZnEhMJ07Fo1ZuIgdcE0McmfOVSOJ/AvKQ6tKFhcsGSvr0tJLAmVEUgzZxe8o?=
 =?us-ascii?Q?+DZglrloDlDSQ3HDhOhFOPTC3QPXphJerIlGn7W603d+tyZlPJOIBFet5+ng?=
 =?us-ascii?Q?jhcNOf82tK86zjPVg31CiJIiIe+T5mZ4dUfvJAnv5zDGSA4hT4y2gCcWZBaG?=
 =?us-ascii?Q?CpRqj83y9uUoyC//wUBzVgDluxtdfM0sNyZxjVO9RwSb7m4tlFSXGoMoUXNT?=
 =?us-ascii?Q?Y+vafvtH8DoyOVKLXGodKBvVj7/tmsof0H/VXVxw1cyR8v8P9R4cUWemhkcf?=
 =?us-ascii?Q?Up1cizElnSE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aaLdu6aSTLvGgXlvEK/9ZbqqDUFN9ALWs8rQK5lTYpCUke51Hw8z2y93EPYq?=
 =?us-ascii?Q?+3LOOeDLPiEJoJdgTMygkS4VTnSNoRiW37uNiihk0SZJH5d6LvisNceIcgxe?=
 =?us-ascii?Q?nZbeRtM4LEyv+401ovvebGLBivz+a1QjfkXvprEnQPgye/wPVfzYVs+YWKsB?=
 =?us-ascii?Q?wHVTUQRQ+LddQWfNVpCmGU9ai2jKuh++8pkcJyqdDVZcw/f4+pE2x6TIGOz6?=
 =?us-ascii?Q?8U+rGOEWJmvl4tkKfeU3CIN/mBtMjOq7qewK71xO/SmGIbhmRo1X3313m/5g?=
 =?us-ascii?Q?azLPcB3NyF/EdOyv+1bdPxfpxQSEmQmLooboKTS4VCLFKvEPeySSigMPFRYm?=
 =?us-ascii?Q?a/UiHbCJX7A0azVh6W+ClE/vIHCLaAephTg5s1xVbBYncFSK7J6ORGJEPQa6?=
 =?us-ascii?Q?qHDihwJP4gMGfpaRd9UNYBpm2EC7pJKCJt7DbAeRklDQ6QKLBZVfvdKNqUMU?=
 =?us-ascii?Q?/mHsD6ZqMBxc/6yBosdyrE4e3atZqzeimHaX8wmwlHR9sfmZZOWwc4vR1nXW?=
 =?us-ascii?Q?KCPf0+t5xf3y07e6s8QdBr+zPUolxBOARZLXuIarw1app00DxAPV2u+GeH4U?=
 =?us-ascii?Q?3QlQR3CqGO2YgdRe7SReT3rdcLCxgEnrZKNKbHgvEkYHnTGIbQxW2gZe1vGl?=
 =?us-ascii?Q?e4A767t2cU2dfFjZLl5OqfXV7xjYTSSj9J1gQUkBEs9lnfjxpFZg2AcHEIV1?=
 =?us-ascii?Q?KLqMo2xQCyRHFk9+lUy4+/uVKPLyfquC6kBzAF2S3gMbjOWLlvh2ondZ/cDf?=
 =?us-ascii?Q?BoS8J3JX8QByvZVCsAyd1k9T9kdB8cL6STCChkXI5XwMqllUI0LnDtTSltFs?=
 =?us-ascii?Q?MdYEhgXtzamyiALg0at2hq8/Kd4EZJ3/GYujKsWcsZyBThU9bMO6NWdsACmv?=
 =?us-ascii?Q?Nn/GBlDQT6xg848fEL4x9MfT0+OKQtq4PbCZq+HgN9h3KONqb7UyOuCxdH6K?=
 =?us-ascii?Q?l9e+469HSWvCs/qJukBeenVDWunrrFs9JOONeQoteHsVbiVmE9Z3ddo1U9O+?=
 =?us-ascii?Q?S2SZNPPSbqEUqC4wY/PhdgbwwaeRDRyILUG4eGvX+vcUNItuqMU5uKKRACc1?=
 =?us-ascii?Q?PM7fzKVAdLJDPyuw/W8FEReKeNUwt6qOynQpw3CACi4Hegm6PDK0qc5UmgsU?=
 =?us-ascii?Q?q03aadboWN5iQnNguPRcq2tt7K+jbf30F5sE2+yo/qiJmXifUCDnC10fVbrS?=
 =?us-ascii?Q?g4qIs46fRfXKgtq2rc6PoWWzDv1yGLJ3ekWSram1uuoCapzyWI69Gm7y7utE?=
 =?us-ascii?Q?SLGsC0xCqPMjZNz9Lnr3DX9zKZq3mxORslBtAklcpQkhnXz5TezIz80HUraq?=
 =?us-ascii?Q?eA6f19fsZWTj/YnS+Ngh6+MI5Ic9pRD4IFvBheTcZueDEWrQ3tmYizwBroiD?=
 =?us-ascii?Q?vLoCxteJtTQ+elgdYgDzCfstoMJjuGvnynrTMHtuC6M6o3mCiOus8AjSq7Zk?=
 =?us-ascii?Q?XeLEUl510yrnhG9C6kDnlBlktSl13JAeyxTMBopeF28qOzUI/THTnPUzsYCr?=
 =?us-ascii?Q?B3pEHaEXGZW00zmsvLU9l5eJexXW6/yCzBTGEHUkDA+CMS5PGmYg3ucuS5n6?=
 =?us-ascii?Q?qPGYs2ThWocErf66dT3Q4oGRF9BOIf5B16lJzFAr?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c4d4f593-280d-44ee-d7e6-08ddf5c28e5e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 08:16:51.9142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: usz8EWYkDxneqtTpCavop/8X5vymAvKVPe4HOqfJ1gOUXTL12/isAPW/fznBZaWn+cT6h0dNgd8Y+xvxDyC7cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF7D18F34A1
X-OriginatorOrg: intel.com

On Fri, Sep 12, 2025 at 04:22:56PM -0700, Sean Christopherson wrote:
>From: Yang Weijiang <weijiang.yang@intel.com>
>
>Don't emulate branch instructions, e.g. CALL/RET/JMP etc., that are
>affected by Shadow Stacks and/or Indirect Branch Tracking when said
>features are enabled in the guest, as fully emulating CET would require
>significant complexity for no practical benefit (KVM shouldn't need to
>emulate branch instructions on modern hosts).  Simply doing nothing isn't
>an option as that would allow a malicious entity to subvert CET
>protections via the emulator.
>
>Note!  On far transfers, do NOT consult the current privilege level and
>instead treat SHSTK/IBT as being enabled if they're enabled for User *or*
>Supervisor mode.  On inter-privilege level far transfers, SHSTK and IBT
>can be in play for the target privilege level, i.e. checking the current
>privilege could get a false negative, and KVM doesn't know the target
>privilege level until emulation gets under way.

I modified KUT's cet.c to verify that near jumps, near returns, and far
transfers (e.g., IRET) trigger the emulation failure logic added by this
patch when guests enable Shadow Stack or IBT.

I found only one minor issue: near return instructions were not tagged with
ShadowStack. The following diff fixes this issue:

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index e4be54a677b0..b1c9816bd5c6 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4326,8 +4326,8 @@ static const struct opcode opcode_table[256] = {
	X8(I(DstReg | SrcImm64 | Mov, em_mov)),
	/* 0xC0 - 0xC7 */
	G(ByteOp | Src2ImmByte, group2), G(Src2ImmByte, group2),
-	I(ImplicitOps | NearBranch | SrcImmU16 | IsBranch, em_ret_near_imm),
-	I(ImplicitOps | NearBranch | IsBranch, em_ret),
+	I(ImplicitOps | NearBranch | SrcImmU16 | IsBranch | ShadowStack, em_ret_near_imm),
+	I(ImplicitOps | NearBranch | IsBranch | ShadowStack, em_ret),
	I(DstReg | SrcMemFAddr | ModRM | No64 | Src2ES, em_lseg),
	I(DstReg | SrcMemFAddr | ModRM | No64 | Src2DS, em_lseg),
	G(ByteOp, group11), G(0, group11),


And for reference, below are the changes I made to KUT's cet.c

diff --git a/x86/cet.c b/x86/cet.c
index 42d2b1fc..ff6b17f6 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -30,6 +30,8 @@ static u64 cet_shstk_func(void)
	 */
	printf("Try to temper the return-address, this causes #CP on returning...\n");
	*(ret_addr + 1) = 0xdeaddead;
+	/* Verify that near return causes emulation failure */
+	asm volatile (KVM_FEP "ret\n");
 
	return 0;
 }
@@ -45,7 +47,8 @@ static u64 cet_ibt_func(void)
	asm volatile ("movq $2, %rcx\n"
		      "dec %rcx\n"
		      "leaq 2f(%rip), %rax\n"
-		      "jmp *%rax \n"
+		      /* Verify that near jmp causes emulation failure */
+		      KVM_FEP "jmp *%rax \n"
		      "2:\n"
		      "dec %rcx\n");
	return 0;
@@ -111,6 +114,12 @@ int main(int ac, char **av)
	/* Enable CET master control bit in CR4. */
	write_cr4(read_cr4() | X86_CR4_CET);
 
+	/*
+	 * Verify "Far transfers" causes emulation failure even if shadow
+	 * stack isn't enabled for the current privilege level
+	 */
+	asm volatile (KVM_FEP "iret\n");
+
	printf("Unit test for CET user mode...\n");
	run_in_user((usermode_func)cet_shstk_func, GP_VECTOR, 0, 0, 0, 0, &rvc);
	report(cp_count == 1, "Completed shadow-stack protection test successfully.");

