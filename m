Return-Path: <kvm+bounces-40114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A31CA4F4E1
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 03:50:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 71E4C3AA4D5
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 02:50:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E4D316DC12;
	Wed,  5 Mar 2025 02:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q0TBhDhq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C796D1419A9;
	Wed,  5 Mar 2025 02:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741143019; cv=fail; b=V5vspUwgyGYkhQTvHachTwD2CqWOyiVVAXCvPuB9UtNosK2pf49c/Wn847/Hbfqfwo+3NvZxDoen2UvSOgIJa1O9SS8xEqyTJ+RQn4x79Nn/pHOYSL6/62Kt3cVpbqT3N2Qon1RseTnKJSuZvpPphWwXz4D/gZxd4sjpfYenUuI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741143019; c=relaxed/simple;
	bh=JfokFkOOlPV+HoczuGsPKVDrhhgamFaOMiZ8syuc5Uo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=V/nV+6UiZmJnbRnLg78klPtuwFxtMtydKkXAsnPeCU42b3K3RXsivbZ/gbYfMMOugEdYcw3zA6K3dgZQvE6GpnuI2QYV4BsW9UsLcHnvS/gykd/JnCHPG2j1LiHxkpwYq+JPnurL3shS4Oy958f3/jTPtnjecoZpbhxG41azs/0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q0TBhDhq; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741143018; x=1772679018;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=JfokFkOOlPV+HoczuGsPKVDrhhgamFaOMiZ8syuc5Uo=;
  b=Q0TBhDhqv3mz/1Kc7LqXslM4+wtaep4WxxGt3p3U7Bwv/CtEDAh3olQH
   IZR6om2CPU7d2Vm4fIFSAcC8fcKRcV+A+300v2D1XDB/7A9Fs5IN8eRH+
   /fpEsTC9Wm69xTho+8gO6bYgjyOMEyWNz4AA2JFIRFjtWETDuS9qpoZIk
   aKaJocn2j8/Lug2wglNyquVISZoRte+I6ODaHdS3U3yfiASydhTIoo75y
   XSDzexmWnkVCIfx/QdmM1oID05PVUKTkGonUNYBAeeXeUGRkEjv5RDFc2
   SCyVv8Ps1nrqTfS04zFFsO3OSFYE1kZ75WbhtK/NIhkhEbff+Q3znZibN
   w==;
X-CSE-ConnectionGUID: i6fzpOWZQpO1T6ruR6OYMw==
X-CSE-MsgGUID: 8Z+eib3ERmyaw2A8fqmvyg==
X-IronPort-AV: E=McAfee;i="6700,10204,11363"; a="59499956"
X-IronPort-AV: E=Sophos;i="6.14,221,1736841600"; 
   d="scan'208";a="59499956"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 18:50:12 -0800
X-CSE-ConnectionGUID: qEMkELjPTuK0JulfGzyUtg==
X-CSE-MsgGUID: gtiD+fFbS4O8IG6fZzc5Vw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="118461903"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 18:50:12 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 4 Mar 2025 18:50:11 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 4 Mar 2025 18:50:11 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.45) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 4 Mar 2025 18:50:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sxSQkRw5RoL2GyGD8lZY0YRw7hAlcOmf7SFFl/PLr5e8T89H+sIz1U3l5I9XLoictBHG7pNceWGOON3a5LgGUonYVQCBWfucNNshSUyYozacHAV5GyyjJttKnmKYGU0u1cSmpV47Hcgw/BZyNn6XkOw1c4YcnNqk8DTjuKZeieZEMBVxNOzFKDV8XJyN5fcPzyJ4I4qp3hzejqPSoiPQsxzfkDdcm4/Qx0oD1kUR1ezrIEhB6lsgYWX6lsAaQaBen4ZL7QklP9cf+gv14nVAnJ1KpiBbgTVm+ykrKv7hV8SnkD0cmMfDFRTvWo/QkRMrIoj2EipIxqlVTztLcts3hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ABfuTnCAUk0f5Si0eaikFYCoCI9pnAc9Yt7L6VFLDIs=;
 b=ARlddL1HqFEmoY5HMMgQz/e3+ylk5iJ86H7KvPeXzUB+0bibr/Sfa9uEVuQQ4NYpGQjI7dUtUxTcFzQ/b7wgAjMRQrWUnog/5LpEXAFDigUZ0jllZWnGuFC62WC2iVYiD7y5fq6ZA7x9raHIRokX33Mg/Oa6zr5iB0iYgnWzkkcYXbWotwxdWqUAViwDsep7Hvon3JMXpQu/sRhvqfoNEst+xk2MSDjUgMNd3Lqz/goLIz81eCZAXq/c6fVT4Kk3bEUrALguqgAdwIe1Z3jOwyzjAk0A0ceVoIesgFqf4PXTPGBcIJ/SxQ4SvqdMN88QyyeHziADqGijMwKqPrRfDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 LV1PR11MB8791.namprd11.prod.outlook.com (2603:10b6:408:2b2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.28; Wed, 5 Mar
 2025 02:50:09 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8511.017; Wed, 5 Mar 2025
 02:50:08 +0000
Date: Wed, 5 Mar 2025 10:48:48 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<xiaoyao.li@intel.com>, <seanjc@google.com>
Subject: Re: [PATCH v3 6/6] KVM: TDX: Always honor guest PAT on TDX enabled
 guests
Message-ID: <Z8e7kJgfgDRZFFk4@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250304060647.2903469-1-pbonzini@redhat.com>
 <20250304060647.2903469-7-pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250304060647.2903469-7-pbonzini@redhat.com>
X-ClientProxiedBy: OSTPR01CA0018.jpnprd01.prod.outlook.com
 (2603:1096:604:221::16) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|LV1PR11MB8791:EE_
X-MS-Office365-Filtering-Correlation-Id: 6dc1873b-9b7c-4911-7694-08dd5b907119
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?YAeIGuYLCNppkaCmIw2CCt2KtLUJAPFlsAeyQPnKnTGB18OicL082+VUE5Pq?=
 =?us-ascii?Q?BnqTparJ07h1tQjfVxn2GAJCRl7mu9oyil8dpN5pZexZYKMu9jh+UTKnqeiC?=
 =?us-ascii?Q?SRvJ9kMbSquPI9tLdvrjgOKsjJggpdw+uvR3ih/XG+znOmd47lIjaB8ET792?=
 =?us-ascii?Q?JZGUOlgVBvKwkp64Zot8+ZABHOG2hhHFtkonlnL34JxZ+Y8VeQmk1x5kmrtJ?=
 =?us-ascii?Q?jrPym27h5qHaA63Rkh7lnawq8A+UBVykIDSHiKdeBuE5ABT8LNCSLkyqDPN9?=
 =?us-ascii?Q?WS9APBN020m4mmqpVVfrdcFPqul/mmzdib23l8DTDOJbC1FbQiHvgQ7yTVGg?=
 =?us-ascii?Q?yQcm70qYItUhUh1EYjyalEZOvVD1hjpbvR/vo5sEsBthjNUnpotfrYUAVpDd?=
 =?us-ascii?Q?b4g5jTmo6Rfczm9Pen+NAOflz74pKwd2wIcy+6nZEKQxwyyyTRBWNTDJhxG2?=
 =?us-ascii?Q?QAPkvV5HZ4hL1iayeXWMFYB6uDtM755G5GrSA1awwN99b8rvUai4Ole6pDv8?=
 =?us-ascii?Q?/FDMSeN29bZl6f/fb9NbWSulqJS/KuoJoHZOlmDTFKeZukssGIEmn+iV4R1L?=
 =?us-ascii?Q?vY0DcGsjlS5dH9U1ZnhZdul0/kuA1g9rPkfvbg1ap6Gzzuu3AFdoGsLRKjHH?=
 =?us-ascii?Q?HXdBco/QKvUW33R9cxuSwUTBd6bD4tX2l8kKqlabITx1iNso1+a9ErUHj06W?=
 =?us-ascii?Q?fdFRd2+gJD9LkgLA82DSZwBOa25TdIgYeiECAfSGb6bz7d8th6yILkwC9vJG?=
 =?us-ascii?Q?U5EtH+JaV9p1sD7UQvxuj/ePzZ6OJPKlSM/WsAOMZJ7fB0w1KgA7oxMjbdnV?=
 =?us-ascii?Q?eugs4wTTD22T8GGBGKXu23VMYUMv+v6Wga8gb6zgCsWRFOLm++o0mU0vP9MB?=
 =?us-ascii?Q?s5Qk6rTQqg93/0Xg4AXvlbKe1a5ax9oPZ74hUf5OyawsY3P/UIrJq2cDpZX/?=
 =?us-ascii?Q?QRQuJFu8yVwbV+8Onl4Tt+DZHcC9y1tTE7wYXLWwAWzmnCOZT+U90qeUMEK+?=
 =?us-ascii?Q?BPELvPhM66QU0XT+AeXAOPfvdN3Ipkrrgv6LrIo/TGD38xC7iOknUe94QKqg?=
 =?us-ascii?Q?nrYPsy1jK47EM+Zl8St4iAnPm3AkV3DxfNLyMWLFsU3jOFbiG62APT+dLQN4?=
 =?us-ascii?Q?0BYOlYs9iXe0PXNq1qHGQ/lo3cdp53Hnk8KZFTa8/5WqWzOPU5B9vhh1sFa6?=
 =?us-ascii?Q?knuDiM8qgP8Mk+eqydBEuv1gZ6w+jAv0UvsxpbaGWDr6CXoBY2mtDErf1kWt?=
 =?us-ascii?Q?JXfoLG7WJUBTH7zTBVRI0PDN5TsNqDLgqm+m3d1GV6X8w0/Yt0i07hteKkCP?=
 =?us-ascii?Q?YjwZWIAAMw2WuizvcIL+ykoCNIleHGxKz7HjoygXOpbQeLC1++shgIEDzCWs?=
 =?us-ascii?Q?Xf/K/hjqG8OCw2KoJB/5wJP+HFpl?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7l3RsLAdw0S/egvIIqbAMCNIo4LSf9oaPN0NcKrW3IddSuRMWM+Q49wSH0vJ?=
 =?us-ascii?Q?u4wQoo7BXP13BtRqsJVDddcL+fwVD+A0Ci5ETY1b3VWPL4shZbdajcEfvUG5?=
 =?us-ascii?Q?l3fKZ0K7aAgTIXN/UB1KFDjDkOcBA77vSX+8POLwbF2iNSS+tN/+7Q7X+BQ9?=
 =?us-ascii?Q?ni1eREFlViguRdgFnCyZZAhDx80RpCGds0dkpM2Scz1Ck4gz3+FI98AitniP?=
 =?us-ascii?Q?JHvaeTk2NTuySniF70++MJosv3DzlSPtr30p/J6Hn6y7ZrxsPG7KypDXu6xK?=
 =?us-ascii?Q?rv33eLf1cWrpNMKKNvHpdHbqFVrBzythhLPikaA2tCExPmGBqczo7lUg5a4N?=
 =?us-ascii?Q?jJ4B+/ff2BnECmLyDGCeLlj/K4sgpLuk5EGmbOfiNIp90luCJdpH4DkRE5OW?=
 =?us-ascii?Q?3sGNf6d+A4t3RQLyZdcH1SnPnmFiU0rwZr4EfLdBsj3Ph0ZyhOkYJe0g/z0f?=
 =?us-ascii?Q?MW4Jbpukw6cm4QWuVURJrvDqFgkrr5tJOeY7+WumsL34k6MCkJpvIHO2mMkD?=
 =?us-ascii?Q?sjev24Rv/6viHJK4rVYu087vvjD8A4Ru1rhvW1yh5Vm0m7BOVC4C/7ml38Pv?=
 =?us-ascii?Q?+UlITC0umUdmjvuWtflqxGpSJmnU73QgkIKN5SFF6OjbxbniDwpxb3K3Nw9A?=
 =?us-ascii?Q?M+hbS6EpkGEtM/if8QhDzLOijkdQDmyugCxzkSf+LNIRBENI3wQXliudv/U0?=
 =?us-ascii?Q?UTGhCt2jTch3indmkPDAfiUVb002IDfBmySQXFSfvx2mxRC6xLUykPjY9SZF?=
 =?us-ascii?Q?YZsZKd2gHh4LU7fbo1E1HcesXM/gGQtQsuVeRiwRO9sso+1nILwC61EgMbW3?=
 =?us-ascii?Q?ztKOoAn6Sapfl9iQZQdlb3QU/iCG5qBle++0UQe2SDr9llTkKvGptQTWK/+J?=
 =?us-ascii?Q?I5BNIWScEB6fUqMdZtO1kwDqdgkXAXGmzJBESEqWYSn2bwAUmmKLFZGaD8ty?=
 =?us-ascii?Q?sLrj8GhZX3P6ueTMhDKDekHVLJkxAl6vm0HCBkskZerKosKjo43JxpntbYaR?=
 =?us-ascii?Q?E185Qx/1aadq+iP4VXcELCJcAwqCO6uRhsJd11sgkoERWKJV7D8jQstfE/wQ?=
 =?us-ascii?Q?4/VLPuun7bJDDfmXQVoIMjU5CfGcHl5juOew9O/URU0pXQnaGJ7MccWuPyyN?=
 =?us-ascii?Q?hq1GRDEWeY8qYQU6/6y8VAYOH7V6dV1X2JrpTksBq7fHi5TiheHsUSKH+z99?=
 =?us-ascii?Q?HTPiFVI6XvXKqrt33sud4VmzjXiCYoVJv695Hi6J5UA28sigZCbyw6K2ikIm?=
 =?us-ascii?Q?7bb3THxI5c4EA/2QwNFgruPgeDINCH6BinKkNkSv3BnlhsCVa1JxzY2cq/Jq?=
 =?us-ascii?Q?tdsSOMDy1sh5v4onZ7bzmNw/+yTMs7pMpPhlxzvTKZE0pJH/d+EAtZ3RQJD0?=
 =?us-ascii?Q?NT/rdN870tRPSTrLGNz2ewm/OPq6rh5wSMfs3sqQTG6nhCg+u5PtEYW9xjfB?=
 =?us-ascii?Q?8XSe/cdIgAHS3xPp+bipCP+xAK5xp3YUjnv2WDw0dSWcA+HESUKa8QgGgSZF?=
 =?us-ascii?Q?pf5b9SxvC4CqAC/pSgODc2qB+uxLp0JCN2mqDLQ4pgpYs0tn///WD0z+Iexx?=
 =?us-ascii?Q?5Qpi4jx+9cqFBDshNw/G8+c4w0tjvCTYNIBgwywP?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dc1873b-9b7c-4911-7694-08dd5b907119
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2025 02:50:08.8615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zll7WUSljZkecL2td6xsoVAFE2MnquYCSzznoF4HQDGCUNG+vsJh1IGsvQmsZayfm0ZiZk8ewWEXD2Uzg/r8Yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV1PR11MB8791
X-OriginatorOrg: intel.com

On Tue, Mar 04, 2025 at 01:06:47AM -0500, Paolo Bonzini wrote:
> From: Yan Zhao <yan.y.zhao@intel.com>
> 
> Always honor guest PAT in KVM-managed EPTs on TDX enabled guests by
> making self-snoop feature a hard dependency for TDX and making quirk
> KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT not a valid quirk once TDX is enabled.
> The quirk KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT only affects memory type of
Two left-overs :)

s/KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT/KVM_X86_QUIRK_IGNORE_GUEST_PAT
 

