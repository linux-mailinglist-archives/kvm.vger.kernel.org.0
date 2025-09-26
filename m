Return-Path: <kvm+bounces-58853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F2A4BA2E00
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 10:02:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2D46621357
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 08:02:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE82528C006;
	Fri, 26 Sep 2025 08:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZzUvmaaM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724161D6AA;
	Fri, 26 Sep 2025 08:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758873730; cv=fail; b=bCns9zTHsIseckl3Rl5QDsDY+D8PSZobFVvsEMbBU43gZp9my6HbR8ag5nffnsIq3zuFYjaI6RY8P64/6rTtx3qUKd7kBpjGITxIzjiJhM2LI01TW3ZVWXnzaeBkdnsOGxXOWOiIf8n+3dCVfiKSRo8eSuCdhBX02DyguSq5mPE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758873730; c=relaxed/simple;
	bh=O3OtBijwvz2ejMDFbT/pomPID5t9jS4IW6+2z3eoEmc=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=H10kGJzud8pmz/aMcuA8dYllBIon+3s028N++WzH7tokFW0Z0db5MCTmtK/c/imgd2AbHN7XXOEtyRrNwthpp+EftqQUJ7zn5K51ku1LUxl+VlMAi+nZgF5i5udS53d4gvr+0BtW3Pm3AKgqj7uz/cKfrgIlWFEB8NoEGdrGreA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZzUvmaaM; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758873729; x=1790409729;
  h=date:from:to:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=O3OtBijwvz2ejMDFbT/pomPID5t9jS4IW6+2z3eoEmc=;
  b=ZzUvmaaMqWbkF3wUsLn2H4z+edov2RT1YGxRjvvC+RHPrTSnGdatEj6T
   4/UIZYMFWz+RqiIVJJba49F+iKGcaKYDcfXe2Vco1B0fONNnV2zuMNPke
   7andOLBq/pFy10Q2o4vOHE3P8mNz1d3ED0TZZKPae/xlcUPaX3KebTUkM
   QC3KDFnU3cO1HBKsqBownbO8UFR5cwvE6cNTCayTWCvoLOa1ly9rGJAE8
   Ot0sMefYT/6TdN5hGPDD81EwraHzQLr+mzUXbkSbMIIRj0fjhEhI2eMfc
   JkODwfRL2H32keuIJzXtKcPCPe7OrUe6BgaKOdtkWytaPy1g718kX9tl6
   Q==;
X-CSE-ConnectionGUID: mMvZE6t+RoqCsNNGhrUlbA==
X-CSE-MsgGUID: Lf+c3kSbQ32ePX2jaR6nDg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="61117303"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="61117303"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2025 01:02:08 -0700
X-CSE-ConnectionGUID: JhjwUPgrTpi7bRRAsO7WRg==
X-CSE-MsgGUID: hjwFvVsRRWuBLMiKrn9fHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="177117990"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2025 01:02:08 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 26 Sep 2025 01:02:07 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 26 Sep 2025 01:02:07 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.47)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 26 Sep 2025 01:02:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iFtYrt5Q11Sn40bam0YqanuiLC717uTHvtuZ1B0NQ5zITD9jYlu9gYmKIqS0+pYIjILU0b04JVMH/uDzKIX99gSlcVtRasmOzLwhQtafmOUumpJPgwsTfjGgXwjQ6kpEEZmm+TwatGWQGYddtnMd6Q1W2gfyxA01ANOsfGqdCQmVqN6WfwRrZm5bRqHxaLDv8/6Vs9bYKzHGBdUsvKBKCYv3m0Slpbh4hV4EFApUP2yzZ4bdNcUhbQWIPfzMX/PFFWwxQ1CKCyasje6b/PpHTomiJRr7VTlmCNKBECGw2jrB+wwik34AHlyRxVi/Cf8/1OODfkV0j/sR5G/qfzVCBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uIXnnKGJITPFbdERZflqH9zBjVtVWhacunqj8LX435E=;
 b=Jp7ivqWcCTjUHand+u30t+Ix7AeBRlldoVdSxgNfR6yrpSkBa04gxkUcPhIk/2RWVfRJWmkzYKzWOWbD4AQVMBuV+PcBLUPDDR/Il3aa0KAAtGatDe5mAd43BnEV0BAHHzF783LTS8OWvLCRAXcu/cMVTGM60cqdkdnbfxYL3ADwdpcV8ous9VQhXvOJZhv0PWOekGPyuZntXwofwfHEuIVzt32lEw5epThFH8OWLQ5t3kEaOPIZUJnv1d2sH/xfwI79H8zi9GS0AvjyBEqxLfkxDMKo3jJzYU2C0venjpleSF7CxguRXBt1W5tTV+pNkehXxaTRBEBABqfIbdU2Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS0PR11MB8740.namprd11.prod.outlook.com (2603:10b6:8:1b4::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.10; Fri, 26 Sep 2025 08:00:57 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9160.008; Fri, 26 Sep 2025
 08:00:57 +0000
Date: Fri, 26 Sep 2025 15:59:53 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] KVM: selftests: Test prefault memory during
 concurrent memslot removal
Message-ID: <aNZH+ftDGaHA7qCT@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250924174255.2141847-1-seanjc@google.com>
 <aNYDtn1FJ65aDC0T@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aNYDtn1FJ65aDC0T@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: SI2PR01CA0035.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::13) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS0PR11MB8740:EE_
X-MS-Office365-Filtering-Correlation-Id: 1530caab-49f5-4c3c-956d-08ddfcd2d351
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?3ilrYHR5b9fTpr0fUsLJlXFPfvKbRPsg8U+ANsihAMskkKD89C+4V1eY0P8x?=
 =?us-ascii?Q?ylN1OQacTXtqn8p4ij7j2/4oBXjYGH+4V6a2l3+21qzYH4Pyz3hGKvfvjHAD?=
 =?us-ascii?Q?NksVMvwXlrvtdrt3K6yC53RKHNdc1wXpLIFbTQozc6x+9v16y/lJ7rcQ6ltm?=
 =?us-ascii?Q?tQxuyEbEcuzPGW0RhIFLl99bV3Bmee+GeZ5goNUoW5pbBpq9Sqgf+u2V9t/C?=
 =?us-ascii?Q?JgSwq+IGcaaN1uRttS3CIVFx2y/kdseBuLb8de6mP08I8EVk3q05g5gDFmHU?=
 =?us-ascii?Q?C5iotUagrghZfYGn89L2JLMRIL/nOnAD/ZbZRnYgdgdeoEvkWg321Obgc2ZQ?=
 =?us-ascii?Q?BM0dSSp3EGtQCJWvwG2NWPbqvxsXdCRwU5nLYPqJoREgyXBd3rGdxsg+iy0H?=
 =?us-ascii?Q?H1/wkr4ZSPw5xfksw3RRc3e6BYNt4/Y7hlkQScJ1KLMUS9upth2D1k9aK/n0?=
 =?us-ascii?Q?QweAtLg3dOTO6RH2lzNtR0MKVsBXoF8HcI2nk/2hkmdeXyYmREYUsbkeaA5D?=
 =?us-ascii?Q?AcMsiv95hDB+1xfnQFAumf8KnFpzmqnihivtCmUZQMzQWvIOFdYvLjIS5qTe?=
 =?us-ascii?Q?Mg4/3Zry+UWw+V/SksmbNYv1u2wRtuppukHpDfdrQLbFvAzevBl+mAmcAw46?=
 =?us-ascii?Q?fgpm23T3PCCaNahtzE8eDp39O7EECqx9zt0LmXlO5wEn59truYDXJK7X67rt?=
 =?us-ascii?Q?/Ntj4dYh8aBeEwwuJhQJZhQ2OVGIRaTlN7/7DMWnkC/gC5QvsSNIA087EHFM?=
 =?us-ascii?Q?btPpjhAuEMMbopK9E9qnGcwu+r6iQ3KU7UFf7KuQcpFjUVPjp/I6S+VKCzb3?=
 =?us-ascii?Q?ygpQSdAQR9xo4EZvn95DQkUDQsEmE261FcI+bEEydLWRwgxs9akSv1qZs6xv?=
 =?us-ascii?Q?2p2J8CCUsSFJJDwkv2MWwDPCEzgV7UxNuZu1ppuQdGksAkGqNXvkqp3wkagy?=
 =?us-ascii?Q?AQcijxkHm3vnBr2fOEa8o7HuiqKKRglY+lkto15MR6c26d7rflkdy47yzPSF?=
 =?us-ascii?Q?Too9W/XAFgNPHle8OVyRrEpqJZ1xUrX7tqwshPghuherHdpvBw6P4Nz0tVLN?=
 =?us-ascii?Q?R5i2QwhmBot+4G3liLocM5XSOrwPWk1Lds9LtCrtGLpKOYEQr0uKJbHd40qd?=
 =?us-ascii?Q?G/cFSSMH/QXeKrvnt7b+UY3Ad8ofMhOnGER8TVrGlI52ElffmyXI0n7X8icQ?=
 =?us-ascii?Q?GfTAYQq+P9oM9RhhJ/MWHAmm1LGiyNP+APeu4JJzd+007ech561FagieYqtp?=
 =?us-ascii?Q?Agse0xdSrbBn7qSjmUasazkUlKgeMZ/i9FpQSVpbBmyoPwEEMooZskMqPmkB?=
 =?us-ascii?Q?rGRZQesIgS9QgLb0rOqu41V89B6wgK780Lxyh3SSroACJ547y2y5nkRgO325?=
 =?us-ascii?Q?nzjICEo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5ELj1wWgdhXKPJB2GBwwdjsY7Di6FFQbjftv3eeZYXz0kaLF0WQUzppdaZap?=
 =?us-ascii?Q?w1hWmOKb8emetfDkxE7Ty2WM6MNJgm4lECwRkGVqeUg0K8QMIj7BoaJrTlNH?=
 =?us-ascii?Q?qJ6/WUkHEzUhf29KQCg7gyFi065MMC7hP03lMiVoCEiW2UuvY6jTR8pWu0p/?=
 =?us-ascii?Q?ttBngz6DRqHlUN2jyM5Ud+omRvSvN3k4D6xEOAv9m9yzP0xJt4CmMtfhHO9w?=
 =?us-ascii?Q?cvWZNEyppBv8CdKMJtdzVzBsT7Gkkm0V2qU4goKpCwp+wYR2K0ojSQNF4xpl?=
 =?us-ascii?Q?xUrnlPK28Fmw+Z5buTOZkzaVN7LAiUot5bJAu6c1cj6hLH4surC3gd/m79vs?=
 =?us-ascii?Q?tNCy/hMKgej+mcXTZP6jLo5yuFv0kZLpr1rTbKYvg+udNDtU5q/X4Andm7wS?=
 =?us-ascii?Q?lE3oQZrodvlnPLXNWZ7Id48kJ3I8ObBU7h6CyRYVSP7NQDB6ux5yotDzc4a0?=
 =?us-ascii?Q?crU2ZPk1n/rxga7n6ecMKC5pxe3+csXZu2Eh6HpwqQH9oZVTFavNvaicWOSl?=
 =?us-ascii?Q?YxBcu0P0e3AXhwVrQQwaDx6GHzDp2TKAGgtNVMU+LUMvEle9oeWCjIA+14Ca?=
 =?us-ascii?Q?oUOJNTV8TP9epqguLrTdVPobbi4g8ZBTadSm4DHGPdX7yyyUJn5zQA33plkV?=
 =?us-ascii?Q?5vCyOs/sEou3PfRzx8O5ZqfiaL4sydOlPUs9lOjjKW6y3bbRbkmXXcjMHoKI?=
 =?us-ascii?Q?URWHtOMRaXwmuOx5Lfc5H0kk5JmKOUiBwADZcsk16rbx1Be9nmRFT+K0Vh5O?=
 =?us-ascii?Q?wCHsvb59xfGfHEkz3lKcg6xZoe/485uriUTJi7fjFaAnpTNQQAWF0D8ckYwV?=
 =?us-ascii?Q?EbTReZqXq0fWE6u8VDp2GgKNO/UuudmNPoDfBrCLyixMGoYzjraDDaIEs9Bj?=
 =?us-ascii?Q?Xt3BhnXfOR49gtxKyzTP6KUcZCogQYy2iWc+skw2WE+ohESFORezgfkDiCvO?=
 =?us-ascii?Q?R8xtfKWiNAt6gdmkIfB13aTiM1hBYPVwen5fgO+DHhHde7QE8CMnxB5PCw5Z?=
 =?us-ascii?Q?/IToJXIc4DSrw/hOd9PrkZv5aL7qJkamGW99HT2J7LKutJp+xATCgMkAxkzm?=
 =?us-ascii?Q?NxW+OG4nBCnznFOzUTA53qpwOSOfCNkCC8FExxQ0FR/DfSTnUXXkmkOkkYb3?=
 =?us-ascii?Q?C6tHO42jtwVmoYu9N8fs5b4WJd8ideEX8T+YA9yuO3N3SyMcXJzrQOe+vHNP?=
 =?us-ascii?Q?gArXhc4+AaubFgtONCysGf0UeeF3imusWkaqS8j7fuCDFTpK50f9GXGC5mud?=
 =?us-ascii?Q?e7iGaUMVB14dsCV6FqnHbW+AJBVC5CBc8a7ZqAXOmAZc/GzMMAX4f/GeybXb?=
 =?us-ascii?Q?nj6ASLfNzzgZCQDvWXwLmLP73VQzJlpTNZqXDvjj1dVuoTqBkRLzZyuQy+nv?=
 =?us-ascii?Q?xbTbDgDfXyiSGJCn8GMji0sNhLjzF+sCpX+TVcfhjs1LmuwqgOV8LNiVsRj5?=
 =?us-ascii?Q?kCRWkPYohUftz7Pi4/e7Y0Cr3NHzNz+xbce9ORxgH0pNhx+bSCcGBzcsqCSv?=
 =?us-ascii?Q?th3SjPpV7gZCGGYOlCVSWfWQ09UMIcOiO2I1rHQ6+Bs+Yere6kaZ4hwQdhtn?=
 =?us-ascii?Q?DdKOQDOmvwyT17dVYzPD0G/h7iywGjGI2+CQ8VmI?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1530caab-49f5-4c3c-956d-08ddfcd2d351
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2025 08:00:57.6686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EmG37SWHDx/+1xhL+RoQqZn61pKKt69V2UDAxw1CjF9TPuNnaXC4JjbmQnxvzyYn9qUiOqUu4ua8UA2HFCD8lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8740
X-OriginatorOrg: intel.com

On Fri, Sep 26, 2025 at 11:08:38AM +0800, Yan Zhao wrote:
> Thank you, Sean!
> It looks good to me.
> Testing passed on my side.
> 
> On Wed, Sep 24, 2025 at 10:42:55AM -0700, Sean Christopherson wrote:
> > From: Yan Zhao <yan.y.zhao@intel.com>
> > 
> > Expand the prefault memory selftest to add a regression test for a KVM bug
> > where TDX's retry logic (to avoid tripping the zero-step mitigation) would
> > result in deadlock due to the memslot deletion waiting on prefaulting to
> > release SRCU, and prefaulting waiting on the memslot to fully disappear
Nit: it's not for the bug of "TDX's retry logic" (we have a separate TDX
selftest from Reinette for that one).

This selftest is for the KVM bug for generic VMs and TDs, where the SRCU lock is
held in kvm_vcpu_pre_fault_memory(). Previously, prefetching an invalid memslot
caused kvm_tdp_map_page() to retry on RET_PF_RETRY endlessly, preventing the
SRCU lock from being released.

> > (KVM uses a two-step process to delete memslots, and KVM x86 retries page
> > faults if a to-be-deleted, a.k.a. INVALID, memslot is encountered).
> > 
> > To exercise concurrent memslot remove, spawn a second thread to initiate
> > memslot removal at roughly the same time as prefaulting.  Test memslot
> > removal for all testcases, i.e. don't limit concurrent removal to only the
> > success case.  There are essentially three prefault scenarios (so far)
> > that are of interest:
> > 
> >  1. Success
> >  2. ENOENT due to no memslot
> >  3. EAGAIN due to INVALID memslot
> > 
> > For all intents and purposes, #1 and #2 are mutually exclusive, or rather,
> > easier to test via separate testcases since writing to non-existent memory
> > is trivial.  But for #3, making it mutually exclusive with #1 _or_ #2 is
> > actually more complex than testing memslot removal for all scenarios.  The
> > only requirement to let memslot removal coexist with other scenarios is a
> > way to guarantee a stable result, e.g. that the "no memslot" test observes
> > ENOENT, not EAGAIN, for the final checks.
> > 
> > So, rather than make memslot removal mutually exclusive with the ENOENT
> > scenario, simply restore the memslot and retry prefaulting.  For the "no
> > memslot" case, KVM_PRE_FAULT_MEMORY should be idempotent, i.e. should
> > always fail with ENOENT regardless of how many times userspace attempts
> > prefaulting.
> > 
> > Pass in both the base GPA and the offset (instead of the "full" GPA) so
> > that the worker can recreate the memslot.
> > 
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > Co-developed-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> > 
> > v3 of Yan's series to fix a deadlock when prefaulting memory for a TDX
> > guest.  The KVM fixes have already been applied, all that remains is this
So it's for generic and TDX guests.

> > selftest.
> > 
> > v3: Test memslot removal for both positive and negative testcases, and simply
> >     ensure a stable result by restoring the memslot and retrying if necessary.
> > 
> > v2: https://lore.kernel.org/all/20250822070305.26427-1-yan.y.zhao@intel.com
> > 
> >  .../selftests/kvm/pre_fault_memory_test.c     | 131 +++++++++++++++---
> >  1 file changed, 114 insertions(+), 17 deletions(-)


