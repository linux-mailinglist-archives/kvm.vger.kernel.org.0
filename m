Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 393DC666D35
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 09:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239174AbjALI7o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 03:59:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231752AbjALI5p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 03:57:45 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0A9555AD;
        Thu, 12 Jan 2023 00:55:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673513714; x=1705049714;
  h=date:from:to:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=vmGdStxWSGjX99+ydxshsxKvGBb6U5VPZEgzN42VR8c=;
  b=BHiHPIRviqCQw28+nofYnq706qaPA7xkG+hTtt0sZC1BJC2mTlGgJ4Do
   kIPHO71evlo/4JVVGd2QOSC8srLv2z8iDxnfZou9cO947iRRCbRpQSY8o
   QkKR0p9zJSKpLlKW2rkiBHNda6lQwXN8KzhqWwOpJ0OccU4QCGoi/n1r3
   OIBdZEd0f20kiiMThra1+gyBybKrqL1zPsfcPj6KDMa3+qongx5FyliSU
   gczINoyoWtxUbpPQhpTF5j5LQlFhdzqhttjgNAdRqORVEfk/TIrYXfO6/
   7E0227oKVvvDHqAtQGtWGyYU62yED1MC/NSO4MrJi+9UYAJq7nE+hkcfL
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="304027642"
X-IronPort-AV: E=Sophos;i="5.96,319,1665471600"; 
   d="scan'208";a="304027642"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 00:55:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="690048742"
X-IronPort-AV: E=Sophos;i="5.96,319,1665471600"; 
   d="scan'208";a="690048742"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga001.jf.intel.com with ESMTP; 12 Jan 2023 00:55:07 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 12 Jan 2023 00:55:07 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 12 Jan 2023 00:55:07 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 12 Jan 2023 00:55:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k8ex2aaYwSzi5Ly87G1R+GZMfzAPUnNK8iYiMpQKczLfBJCn/EXsoQGa9E6lRhSFkMbw18QoQLIUzpu6q0G6gZeZbOQzhhKq5+Pka1saeN9UkCr4gLkKTDT6sKa+GHCfwojb/PiyfNazxQGW7r0/d+qSMap/+B2Raqh7lDv8jZCOCdOP/Yhj/9dQnwkkHM7VZJ6NZRJYphfokeDR75STRC8w+Q3r8nQCoAx8Tv5tMos/gurFR5zFXP0ada5xCwGqUPnROKut+PfClssivv48gW0/z218/lqOJTLCHQd+0gneXcYw0OxWZmGvZJ/dti4hCb4NIgYmPC8J9cWkyr8Igw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UkzOm0ZW7h4xBHLtH9iyAm4NDZoU3ZHTl8bjpyGoqdw=;
 b=EVf+++6Wv6fqCrX5lHTCvBl77JzwWSjxdf6B5tOHxRxaa6fNdFHtF2SbaB6jWSXvE2NqL246VkdnUpEKNkS/pHjtCfQWgKDDuiPD+s+0mcOzzULjxq6qAeR6PjG7qrPRWA5O8uIxzKp3rR2zKpEcMD8W6266dc5nNz2VKPgINCj2NMqi7FRiWQ/CCwREm7PzSkvp/WmQgYQemAlqtH37i7jptUbltPqw6KiuNMKC93aNN9frMbgbWFaDAtZBT/MC8FXMZB3BRTrIP55fr7ApMB8vabtVQnD8e0oz5CMOrfIRRrdAfkENMAKSuZsUfVMfxgBpx3u6YpoWazQyjQulvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ0PR11MB5120.namprd11.prod.outlook.com (2603:10b6:a03:2d1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Thu, 12 Jan
 2023 08:55:04 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::bd50:2cf7:f362:3734]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::bd50:2cf7:f362:3734%8]) with mapi id 15.20.6002.013; Thu, 12 Jan 2023
 08:55:04 +0000
Date:   Thu, 12 Jan 2023 16:31:34 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>, <kvm@vger.kernel.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        "Zhenyu Wang" <zhenyuw@linux.intel.com>,
        Ben Gardon <bgardon@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        <intel-gvt-dev@lists.freedesktop.org>,
        "Zhi Wang" <zhi.a.wang@intel.com>
Subject: Re: [PATCH 03/27] drm/i915/gvt: Incorporate KVM memslot info into
 check for 2MiB GTT entry
Message-ID: <Y7/FZpizEyIaL+Su@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20221223005739.1295925-1-seanjc@google.com>
 <20221223005739.1295925-4-seanjc@google.com>
 <Y6vXTcxDNovrmeVB@yzhao56-desk.sh.intel.com>
 <Y7SaklDQD0EoIs8l@google.com>
 <Y7Y+759IN2DH5h3h@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y7Y+759IN2DH5h3h@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: SG2PR03CA0098.apcprd03.prod.outlook.com
 (2603:1096:4:7c::26) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ0PR11MB5120:EE_
X-MS-Office365-Filtering-Correlation-Id: 432ede82-7faf-4544-5852-08daf47ab265
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: imcO0uLCIjcZjK8mn12EK2FAHFXnPJld1vIdRKG9Kn5zCx3Av5bYtv18LG+xJxqg4tuJtG/ZFavbPRnl1FGnZWJsvD6++y37m77cxjps7xlOErC06TJEPodMezMHO2aNL32DXhkh1wJdR47atwYIjhNp8M12QozFk2j4s1dWoOJTLvVmti0/9zQTqwKU5NnDVbitHREHEy7/QLpIhzv9FQ7AgzJ+2mEkFhVzpChT0qkaPAQoZ7lZc/wU4lLFQxXzeVkvOgP3v3fveHlkcy+oH2NNmPUOH+WZ8MSWeMDoscWg1mVU1rsyPr7jAIBsr6qLZKcn+LoHk8cNk+eJ6RcTHaW7eo1E6OyvR9es3JVe0KkvZnql04ntuelSgPW7yibDv1D4S6xvhad1iwB/WJccszrvQSZpe1XpUDb0Kk2PmoKm8pFBkSev74ILH5vb/1tDJ4gCWJiK/bvy9ZjCyNh4Fyd9Mt2iSC0nBluDdJW9v5sXs+ftuClLpb91r9U+HhoERPAPdFWQGmN+3FTCY4o7vvKQopKki1GFT8DCcu52KSjhvGZDBKVqf57yccyNwLZWOOgSkrGg3oSrvb8pGzHwN3VHLF37NYTIzoptEW7PFPNADzCKrLdNjknchp3/1n2J
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(39860400002)(136003)(366004)(396003)(451199015)(26005)(6506007)(6486002)(478600001)(186003)(6512007)(66476007)(66946007)(6666004)(41300700001)(8676002)(110136005)(6636002)(316002)(82960400001)(83380400001)(86362001)(38100700002)(66556008)(3450700001)(8936002)(5660300002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B6R8NXezC8bEDu7gj07TB8c+ZtOuern151OpxogjEtIxWSuem2I8V9jZe1DF?=
 =?us-ascii?Q?L8s5w7JO6IhSRnjoAsaa9yFGPtqkeCblfFsBMElEL5tjg/mKezHCKSUBLUmw?=
 =?us-ascii?Q?ud8RclDs5K5YS60aR9EY6kk58hzdpG9ZFOwy5AVlvavGiJwwJbOYikoC7eNg?=
 =?us-ascii?Q?uoxsqoVRZcIz/8sZ0mc1rMU7UIoLmclZxVDAuffskf+bTDebiRpD+nFTrDI7?=
 =?us-ascii?Q?Xs2sGeEVi+sTBPR+Rcy5WD35fFcesZdrlNSkCY0tqrvRvOvnLitsa678pvut?=
 =?us-ascii?Q?nbPlYqE8sHxDisRkdQfS4+5rS45sdnN88+94GA4eoKvx56yU1p6oTtHG+7fv?=
 =?us-ascii?Q?hdSX5DMbUsdEC3Vip/D9otIME4QlnglgHdHZ9tfmklNigkDg7sOZTNzI1WF6?=
 =?us-ascii?Q?miuOrQdFaX5pfWI22MlehZipoVydHugAIOU9TLxkgPOaZNbFrKkJGxeu0aIF?=
 =?us-ascii?Q?MB311XbKRAe37BJ8fJErokRwRhrcErYTvmuwg+bqvDquy1VERistPSANmtaF?=
 =?us-ascii?Q?9GWa0noJFqRO7fpYeFA8x4dvCNEgyLtkugM3fm/5RbDr10v4iFw3TTbK56e3?=
 =?us-ascii?Q?qvvGcMB55yyNwdhDBFW/oBGmquXr2C/hlT7HdjzhxsMHd2uAbX2Sf1Il/kIl?=
 =?us-ascii?Q?6SGM3Hj0XnBRb8RTrhEqrgQwanmhHURaqOCCaGAd1nLe7ueyq9VhdBRaT2k2?=
 =?us-ascii?Q?3qHzda+eO8ba8DUXlkZk9ycFV/Q3WNMdcH+t1JQRa35p8UF/diUvGR24RB6T?=
 =?us-ascii?Q?LdWnqfwtm2PP20LHNJVkSVvZMm0bJsAETh95Aiigg5APInf/CPbblw2cc/Ij?=
 =?us-ascii?Q?z/AgRqsAKKD5AnE7fqWM0+jeADmKnBnzlr8iltRgJBXB3B0y+HOoX8jHMMUi?=
 =?us-ascii?Q?5jFnH4JzLHmpGhdf2nk2NgVoTqJVePHihe9+XHZQV/E85q9tH4ST8cYgFsuh?=
 =?us-ascii?Q?TOE6crgg4ucGG3xbrq/c2AdyY9mjvDXvBQAC8fi56WA6TG+VYzyXpVmjdmCu?=
 =?us-ascii?Q?XjTWRxkeReFQcpHfRDHrQRa4HLENV+GPGWPQMH2D3rc/80ms9apdOinz7x8b?=
 =?us-ascii?Q?ayzDSVMszHjJf5DE49wn8pqZWavOigaLq8bLekoOqqSCfBkSZCuFVCimCueT?=
 =?us-ascii?Q?QrUCPhECt7hD/IzAyRiyLTquLcZ/UHVsgjxGJJua+fOcG414KQttxky+j6Z9?=
 =?us-ascii?Q?Mkf3ysBT8vopXtW6030/mWXhapttHTISZ+4ft0UnGtuaHkpdXSCXsfguqUZg?=
 =?us-ascii?Q?nBo9Syg5LjgkIddj+KzK0xWj2U8gjZtm4YygL2oTQC+i3VfuHG4wFUU+BZfI?=
 =?us-ascii?Q?zP2QXkFZxfEffzRjVzPt/efM/uW2Ih2Q6/OkD9BRFt/HAxpJz/4FZ9BV/n+n?=
 =?us-ascii?Q?vTUPxmKT4QtRxNC3BnxTFVeqICsK8SkTX3ey/kT32LpuYC+fNE1Jx8tcrkzs?=
 =?us-ascii?Q?oBL/0NSCHkjm485uT0xkytGInZwvdKle5i9AwM2341gex39ksJQUVkiMP8R5?=
 =?us-ascii?Q?4Co3Z1dzX0ZUUIRYNqtog5xC64VWltcbGOX/qTDRLDN1HvNcY1DyC1bnFYnx?=
 =?us-ascii?Q?M0fGUUsB5esURyQe2h7LPgpMb9JhPGUIRdArhqf3?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 432ede82-7faf-4544-5852-08daf47ab265
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 08:55:04.3927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TpmUvJA2hs8vbydJ4JJEbgb7fcrJQAyRd6xDEGzdqiOt0bmhyCsW/Pk6TLVvH4yXLwlyyENNDn0CG9hz78Mzbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5120
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > > > Note, KVM may also restrict the mapping size for reasons that aren't
> > > > relevant to KVMGT, e.g. for KVM's iTLB multi-hit workaround or if the gfn
> > > Will iTLB multi-hit affect DMA?
> > 
> > I highly doubt it, I can't imagine an IOMMU would have a dedicated instruction
> > TLB :-)
> I can double check it with IOMMU hardware experts.
> But if DMA would tamper instruction TLB, it should have been reported
> as an issue with normal VFIO pass-through?

hi Sean,
This is the feedback:

- CPU Instruction TLB is only filled when CPU fetches an instruction.
- IOMMU uses IOTLB to cache IOVA translation.
  A remapping hardware may implement multiple IOTLBs, and some of these may
  be for special purposes, e.g., only for instruction fetches.
  There is no way for software to be aware that multiple
  translations for smaller pages have been used for a large page. If software
  modifies the paging structures so that the page size used for a 4-KByte range
  of input-addresses changes, the IOTLBs may subsequently contain multiple
  translations for the address range (one for each page size).
  A reference to a input-address in the address range may use any of these
  translations. Which translation is used may vary from one execution to
  another, and the choice may be implementation-specific.
- Theres no similar bug related to DMA requests for instruction fetch hitting
  multiple IOTLB entries reported in IOMMU side.
  The X bit in IOMMU paging structure is to be removed in future and is
  currently always unset.

Thanks
Yan
