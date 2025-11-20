Return-Path: <kvm+bounces-63983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F3EEC76156
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 20:32:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id D69FD34FE7C
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 19:32:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20F4A27A477;
	Thu, 20 Nov 2025 19:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FwF/gUdT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C0136D4F1;
	Thu, 20 Nov 2025 19:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763667123; cv=fail; b=i0syR8NmHxUKQiDV3fBIpS+lKt/HyOAdrqZDoamh3C5p/YnQA/0F7sdvKyzsfLCUwba7t+splI94RweSwIFFrShxnuRpGri72XVISHYdFqBzCfm4In/mzDH3Wh48nJf3FOMWcbYkhRPJ2wFYzgmTQIiUszgk4P8Za+dewLLj3VM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763667123; c=relaxed/simple;
	bh=1yJJDSWy2YuNYJtGFPkkqM2MNTynxWh0MtzahlWJFcI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=M/sgG63opc/yhVB5V/8ZM7m0RBdwuB428Pzk91dazc8oggQ6KKRtIPLIRD+0ca9HltbjvcibwN9qyFNplSfwEf9eX6dBQ6jq0+5Ajw2rLr56WDm7mOiPIVg+5QR4AhjvlTrihS/zMKzIlzqVwHnFlLNqKwei3dZHqc0eXGzCdHk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FwF/gUdT; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763667120; x=1795203120;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=1yJJDSWy2YuNYJtGFPkkqM2MNTynxWh0MtzahlWJFcI=;
  b=FwF/gUdTpSLDHRDUvcLr59egaB4UuIG+Ajrh6/oo5DYo69s1OdLAkxGV
   MqOnaum/s60OmBBH23tHKAMiJsRB/MVWySfKtlxNqjUXdq2gXjvbUqgm7
   rKCAR10TsuKremqeMbd1Rd1r8ysz4LlHEUmnqn7U/LfLmu1DGzHVddTvM
   fUo2mW3YoDQL/+j0lLUqwA3/qb5zavdVEcSfQtcDmsdDft9yOlO09J/KW
   uoS0Xx4rO2so3TXBEJDxJDeLFx6JKTw08NfEWz4dJs6AkSSM4stuDeKSV
   zDoZahYVu7isNuzxQ+d023AKD0EiL1xKIE0TWpDUx4G7DN6CJLpiThqhF
   Q==;
X-CSE-ConnectionGUID: mLU3GLZXSs63UB7d32wRTg==
X-CSE-MsgGUID: zFqzBkeOQp2kcOLClUFAoQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11619"; a="83373605"
X-IronPort-AV: E=Sophos;i="6.20,213,1758610800"; 
   d="scan'208";a="83373605"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 11:31:59 -0800
X-CSE-ConnectionGUID: z2nGeUxKRgiXhiKrSvXGVg==
X-CSE-MsgGUID: US7qYMWvRx+K9joKofFY1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,213,1758610800"; 
   d="scan'208";a="228761942"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 11:32:00 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 11:31:58 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 20 Nov 2025 11:31:58 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.70) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 11:31:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=unN+ZtpauUHXL+Qq49yMEQTFAR9xZfG1kwZLBiiebQH2tGa190JNe9a9BWPRv3+rAn0t4R7qjZebcdSUfQ7ZbGnzlaEtJuSlP6vB9yOzJYEuf53BZW2uUWI9JEAsRA2KqXiaW21Pio/ohoqFTPjckYnF67dxPLYk+aQ44wlmL1YnAqcegz7U/IUeN+eFnaOUnI6Rl8f3Z6EpNZavOy59wuBSyGsbkrj2HI3JKe7va5AmkL1I3t6ShCxwpvbXXioTElYiPrQFq0ik8NgzCwqvp8ItpVanxuoNS2Z0JN9MlmR+0ptiDBOmu1VvDYq8EG4m//p8WJr3M5Ujm+ps4HJRIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iafKm1SUx+qHsFjzzKAIciZVN1uy05IrM2CS31pYoRI=;
 b=o4U2NPGmkFoos97qhGEnaQ74u7ZoXRWuchNYR+282dGvmY69GWmbDhslLyoWXhz2BaafXD2Vfy+aBUdKGE8KzzTctgayzYpa1JsXFZWdy4Z+xoyUgAcRFeESoCqeuq9kd35sFrDD9e/hoCItRui9QXR1xJzZALTUsS6Q9pyPAv0PUpVnLzJIwqEEh7gOpZIsZ9VobimwenKoPN/KPSRmSEzu5lTKE8FcIkp+0SXV7H7J9z5jJ58VKIBl/rZ2TFCzxlLwJZpZfrhkhLaOQ4DeniLQbIzNFPWAwBrLQ9YvBwgX5suwxSIVPNx63om0jqDJkCEJprowr3us1M8XLcqBcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by CY5PR11MB6344.namprd11.prod.outlook.com
 (2603:10b6:930:3b::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 19:31:54 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::8289:cecc:ea5b:f0c]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::8289:cecc:ea5b:f0c%8]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 19:31:54 +0000
Date: Thu, 20 Nov 2025 13:34:21 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Michael Roth <michael.roth@amd.com>, <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>, <yan.y.zhao@intel.com>
Subject: Re: [PATCH 3/3] KVM: guest_memfd: GUP source pages prior to
 populating guest memory
Message-ID: <691f6d3d93231_502d810036@iweiny-mobl.notmuch>
References: <20251113230759.1562024-1-michael.roth@amd.com>
 <20251113230759.1562024-4-michael.roth@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251113230759.1562024-4-michael.roth@amd.com>
X-ClientProxiedBy: BYAPR11CA0108.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::49) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|CY5PR11MB6344:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c46c5a8-3968-47af-663b-08de286b764c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Hx566/TbUSpBne1ll22J/BIgXiZ86PyAMSNGGxjcf9g0HYRmZqKzzWEOC40g?=
 =?us-ascii?Q?L2Rt9D1MO8lf9pSzRGtmswtzks4gEX4Mw/XFprUh1Xb0rP3G5847W0ZRqHWu?=
 =?us-ascii?Q?VyI4P+NqoYisVhdFJ1Qj4jUn0etp+iA6Bv0Gc5eHZfo0Xq9CVOsvn7BoTsJ4?=
 =?us-ascii?Q?jv1xoiWNZz2cVGUpylyZFzd7m2x1k0276VhZxIDP+PSpWkEajoQWyRPzXEEK?=
 =?us-ascii?Q?6wA8+ngjJ9dnNHfz4R8W4KIwfAAeWKdA/YP1jkdZLNi87T6Jb3pdf7B68BCZ?=
 =?us-ascii?Q?WSjmtZ1jtaXHjTDEv8Q7xkczo72sHhfkVdS1s9jQqcH4SO3YRBK/ts6pkmae?=
 =?us-ascii?Q?peh0lIkiIUXtnYKrX6DnH0zBVO9sbBJLOyiDxdZ4Gy1scMpykK/Ov/nrMJaB?=
 =?us-ascii?Q?KWTdXmeDuJ6Ih23Ptd17JhxeGjCtno4jgJSSDNA4cYHpo6WD8w/G3DDBk3Wx?=
 =?us-ascii?Q?gZbma8BdvnG5WjjeLXR8VJKdJWYCVlBrLC9M8rQ4RMKzLg89VKj4Q4XCwA+U?=
 =?us-ascii?Q?XexOIB6gnC/m6m2BbRaFNCAPkN0IC19iOifmRIXVQ8SJdoMe73LBiZEnB9mN?=
 =?us-ascii?Q?woBx/zX9tHGov6RBdOr+/NrN//cTCsXEhDxDY1yw+wV8SRlI3AYgT5eoAgz2?=
 =?us-ascii?Q?fbFuhR/PiKRLZi4QHQ6qbooOU4yMpcm5fydzBUknDu0tK0VS2axq12+A8RA1?=
 =?us-ascii?Q?xZiaQ7AExNaL9gEpXFGAgwJtJmHa8NjSfNjgrRJ6EK+lKbTqd8BLUANIkmk6?=
 =?us-ascii?Q?Whhd8sn95Z/KV3nSqR5BSI9cYZZINIgqkyuEeymvuL7nJIthYNkl3Eoy+9ki?=
 =?us-ascii?Q?ovGiEYVNj/OFpJuSshFf7bVM4/SXWlYeWppfTapUdxWTpqWuaA2mAcvjogxY?=
 =?us-ascii?Q?5Wllxk23eGCaYN+uNn/OhTLHem1HiYjYXE4mFjScjKwdkbaT9/tQ+Vk+qpZ3?=
 =?us-ascii?Q?oLqGaBk1rJS9IqYlbZ6WfUHEfmFmxNp0KTQBH0i1GLVT5EXiyhKiI9qubTUu?=
 =?us-ascii?Q?x3s/UjfrdiV0iehBY4xDa4PlsTsSyYFE/6mEP/Q7Q4vRlHkJoMS/XrzfFdXp?=
 =?us-ascii?Q?Dj5UzSM+zq81IxqR6olsHwhiEemtt5U/DTn0kMNk1uaOM9Tohc9kLQ2GzC2C?=
 =?us-ascii?Q?Y0haXRI57MfFH1NsZKyf/Ntz7UpAxkmzWj47Eol8vgDvSvgIQHiZigMviDRH?=
 =?us-ascii?Q?qu0WtIbiX4ZjCOZ5Fq2AKHS1sI8IRklPX+W8VAy7FPEKK2Gfnh4n/xnsSdSN?=
 =?us-ascii?Q?yg1uCY0EatUO/yv/9tl7eHbXdJB0r4/T6u3n5AT4tagAzyuZUGXu3n6tyiTX?=
 =?us-ascii?Q?YbFHICZkzjaxx5NECZ0kPKNY+ftCqOswpWeDyvAJKlx+qSlnXE7cJYIhwcBl?=
 =?us-ascii?Q?Qp5zWI79m5AxJEsx63X0w7KIi1iJxdLsfUb8FaVZAJPAUQBOIJMYlnDu07uc?=
 =?us-ascii?Q?sakQFvlNYZdUKuU0F7dnPMA1nPK6lqpG?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IXdi3O2qq2BB1WKCR4hojWUWmKipyxYbqQjW4IyyWMVDWSTkyAsj1f4Seh1K?=
 =?us-ascii?Q?j8b/6lykrZrlRZT/09BIzVStnKgtGQzULyPSmknmX2tdaFNytpYQMTM1LMZO?=
 =?us-ascii?Q?4bUNCoC2vH3XBEqsRNCH+U3lvr+asdfD/c7uEKP3hHZ6GAJ/CH4sYXOFoEk3?=
 =?us-ascii?Q?/b6Z9srIGEaFOXELNv6V6ZoM6F4ONj1EoEACmVCzj5XOMJKlqIImpbo1UiwX?=
 =?us-ascii?Q?5xr6ZIB8UJNL08umBgK8x6VfTVP9+EeETV/jT9fd74Rnp+Tw2JfFXJG4iE6g?=
 =?us-ascii?Q?nmCRvvMFZvWmssbGGXDGhN8R7H3ds4Vmyx+xSS6Z13++//gpe2MzE0Ai+sfe?=
 =?us-ascii?Q?zrZhXVf9ydweCmrJuofwv/XdGVxlozJwF7g9eDgDfjU8dSeouK7K9XrjDHRG?=
 =?us-ascii?Q?89LuqB5RwcwNCk5etuVTh2/OGdlLVPkHHBoKwla9MFdDys7qzfQdPQdMFUdh?=
 =?us-ascii?Q?cZl4aSeKuuiHdkMsUgIaiPdTo7lW3PbCfV0hkK9rx6pnsRUMoZoSBhHnwwo/?=
 =?us-ascii?Q?xgwzmcDZnXrFXChRM7OIN8oiXB1u7URKv/tvZzT3/Uq5HHBxwhRoAneHcxiA?=
 =?us-ascii?Q?qs01kMj36/NcnSupD8KWRpUmbi05uqlV8rTi7FNfwpAuOMjw+kNGY2N/Q0Lv?=
 =?us-ascii?Q?n4BS2tReP1bCdTC1FgTPsDhK/1NXo+FMOghaZfhBe02xTXqRkBqCUBjkVhLa?=
 =?us-ascii?Q?ghcxk4hPouG2IprSdNdnBy8K7hGDI7TZ5uBsDQR7Gzs7Og+J75NgBhWXr9tI?=
 =?us-ascii?Q?AIMgc66EoODTkViBGvfCrMYcf0sHru98pEZaY3qd48qH+zRfcc5NxL58rVUL?=
 =?us-ascii?Q?uZgFHq1zjzyrl6w1FlryWRDWGKxwvAAc0picsgS8L1qddF95GQpnGYnZ7RIG?=
 =?us-ascii?Q?5MkxJmHHxdKmvqf4moskp8pzLCokQoJYi3g0uhjhC8ESVxBvcKrMp85PNPDr?=
 =?us-ascii?Q?ujfyOTU+sqQMEij26b9cjKpC/ftLXvtPjkyPC98ftvbfj6CSo1MKk9VBuuOb?=
 =?us-ascii?Q?sLk0cqVd1Lk5B6vl3Qp8wOT0YDoNtyJEBiZI4VKujKgYRYu6AF5k3pgUWpGK?=
 =?us-ascii?Q?7jc/cFCG7mzjARvsM72gNdonjTR4SQYZvrnfQpRDH/xFhRO6r7vwXYyJ4Dwy?=
 =?us-ascii?Q?9646G/DxmC6wg3g+ktrCkEm2qLKoe5wNPPrZct7V7LpbMs6o47oFFws84yW3?=
 =?us-ascii?Q?0TOGVGOp6Zvquzp1sk4nNQhRD9vyknAIwBBHbTRpEAXmAQLA5+gkWWVh6wgw?=
 =?us-ascii?Q?i3WJprRJJnvS563S63Fk7BKdm9WgjGkMD/1C+MTA+IhrLlXxp7Yu/OKZbOsD?=
 =?us-ascii?Q?F4yYEj4mKW+DkQ58/I3vg3v0TxMphICKF/OpYR+uG3yOAKDxGW35HUM+Eoja?=
 =?us-ascii?Q?ZfjY3Mx/2mb6HQsEEdu6lTWqIlgsamCBY+geuB2MJs6k9s1bIu2DfKhBMnRy?=
 =?us-ascii?Q?T4uxpazPWLrUaw/r6hgb/OD9M4Jshdd8WpekfHgSizOjWo+FGboNPL4VrJzA?=
 =?us-ascii?Q?FAIxRssoTkZbuRaJI4UaZhDRthkAB+5R2h8+ymeWE+O4V9WV2SDkqdUMQO6o?=
 =?us-ascii?Q?01W/FLyHIJivmemAQ/cviUQZ/KpSRucQZhSg/FhB?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c46c5a8-3968-47af-663b-08de286b764c
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 19:31:54.7947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2m7iWXYswwDxkn7YiKsmO9WD03OSf38L6T5+myEKUXVbSYST1RJzQpjma5QoBIycHV6lSSPsWima6Q8ZSdMuAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6344
X-OriginatorOrg: intel.com

Michael Roth wrote:
> Currently the post-populate callbacks handle copying source pages into
> private GPA ranges backed by guest_memfd, where kvm_gmem_populate()
> acquires the filemap invalidate lock, then calls a post-populate
> callback which may issue a get_user_pages() on the source pages prior to
> copying them into the private GPA (e.g. TDX).
> 
> This will not be compatible with in-place conversion, where the
> userspace page fault path will attempt to acquire filemap invalidate
> lock while holding the mm->mmap_lock, leading to a potential ABBA
> deadlock[1].
> 
> Address this by hoisting the GUP above the filemap invalidate lock so
> that these page faults path can be taken early, prior to acquiring the
> filemap invalidate lock.
> 
> It's not currently clear whether this issue is reachable with the
> current implementation of guest_memfd, which doesn't support in-place
> conversion, however it does provide a consistent mechanism to provide
> stable source/target PFNs to callbacks rather than punting to
> vendor-specific code, which allows for more commonality across
> architectures, which may be worthwhile even without in-place conversion.

After thinking on the alignment issue:

In the direction we are going, in-place conversion, I'm struggling to
see why keeping the complexity of allowing a miss-aligned src pointer for
the data (which BTW seems to require at least an aligned size to (x *
PAGE_SIZE to not leak data?) is valuable.

Once in-place is complete the entire page needs to be converted to private
and so it seems keeping that alignment just makes things cleaner without
really restricting any known use cases.

General comments below.

[snip]

> @@ -2284,14 +2285,21 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
>  			goto err;
>  		}
>  
> -		if (src) {
> -			void *vaddr = kmap_local_pfn(pfn + i);
> +		if (src_pages) {
> +			void *src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i]));
> +			void *dst_vaddr = kmap_local_pfn(pfn + i);
>  
> -			if (copy_from_user(vaddr, src + i * PAGE_SIZE, PAGE_SIZE)) {
> -				ret = -EFAULT;
> -				goto err;
> +			memcpy(dst_vaddr, src_vaddr + src_offset, PAGE_SIZE - src_offset);
> +			kunmap_local(src_vaddr);
> +
> +			if (src_offset) {
> +				src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i + 1]));
> +
> +				memcpy(dst_vaddr + PAGE_SIZE - src_offset, src_vaddr, src_offset);
                                                                                      ^^^^^^^^^^
									PAGE_SIZE - src_offset?

> +				kunmap_local(src_vaddr);
>  			}
> -			kunmap_local(vaddr);
> +
> +			kunmap_local(dst_vaddr);
>  		}
>  
>  		ret = rmp_make_private(pfn + i, gfn << PAGE_SHIFT, PG_LEVEL_4K,
> @@ -2331,12 +2339,20 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
>  	if (!snp_page_reclaim(kvm, pfn + i) &&
>  	    sev_populate_args->type == KVM_SEV_SNP_PAGE_TYPE_CPUID &&
>  	    sev_populate_args->fw_error == SEV_RET_INVALID_PARAM) {
> -		void *vaddr = kmap_local_pfn(pfn + i);
> +		void *src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i]));
> +		void *dst_vaddr = kmap_local_pfn(pfn + i);
>  
> -		if (copy_to_user(src + i * PAGE_SIZE, vaddr, PAGE_SIZE))
> -			pr_debug("Failed to write CPUID page back to userspace\n");
> +		memcpy(src_vaddr + src_offset, dst_vaddr, PAGE_SIZE - src_offset);
> +		kunmap_local(src_vaddr);
> +
> +		if (src_offset) {
> +			src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i + 1]));
> +
> +			memcpy(src_vaddr, dst_vaddr + PAGE_SIZE - src_offset, src_offset);
                                                                                      ^^^^^^^^^^
									PAGE_SIZE - src_offset?
> +			kunmap_local(src_vaddr);
> +		}
>  
> -		kunmap_local(vaddr);
> +		kunmap_local(dst_vaddr);
>  	}
>  
>  	/* pfn + i is hypervisor-owned now, so skip below cleanup for it. */
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 57ed101a1181..dd5439ec1473 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -3115,37 +3115,26 @@ struct tdx_gmem_post_populate_arg {
>  };
>  
>  static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> -				  void __user *src, int order, void *_arg)
> +				  struct page **src_pages, loff_t src_offset,
> +				  int order, void *_arg)
>  {
>  	struct tdx_gmem_post_populate_arg *arg = _arg;
>  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
>  	u64 err, entry, level_state;
>  	gpa_t gpa = gfn_to_gpa(gfn);
> -	struct page *src_page;
>  	int ret, i;
>  
>  	if (KVM_BUG_ON(kvm_tdx->page_add_src, kvm))
>  		return -EIO;
>  
> -	if (KVM_BUG_ON(!PAGE_ALIGNED(src), kvm))
> +	/* Source should be page-aligned, in which case src_offset will be 0. */
> +	if (KVM_BUG_ON(src_offset))

This failed to compile, need the kvm parameter in the macro.

>  		return -EINVAL;
>  
> -	/*
> -	 * Get the source page if it has been faulted in. Return failure if the
> -	 * source page has been swapped out or unmapped in primary memory.
> -	 */
> -	ret = get_user_pages_fast((unsigned long)src, 1, 0, &src_page);
> -	if (ret < 0)
> -		return ret;
> -	if (ret != 1)
> -		return -ENOMEM;
> -
> -	kvm_tdx->page_add_src = src_page;
> +	kvm_tdx->page_add_src = src_pages[i];

i is uninitialized here.  src_pages[0] should be fine.

All the src_offset stuff in the rest of the patch would just go away if we
made that restriction for SNP.  You mentioned there was not a real use
case for it.  Also technically I think TDX _could_ do the same thing SNP
populate is doing.  The kernel could map the buffer do the offset copy to
the destination page and do the in-place encryption.  But I've not tried
it because I really think this is more effort than the whole kernel needs
to do.  If a use case becomes necessary it may be better to have that in
the gmem core once TDX is tested.

Thoughts?
Ira

[snip]

