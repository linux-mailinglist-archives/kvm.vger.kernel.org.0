Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27F0E75A461
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 04:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjGTCaF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 22:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjGTCaD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 22:30:03 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB19E19BC;
        Wed, 19 Jul 2023 19:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689820203; x=1721356203;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=DU8vs4iLAu1Fb1uQbsgi9y4BR4VcF8dQHc7fzNVp67o=;
  b=MzoxZ3SFwl+226v1QAXVcVPtO5X6CjSgFCNfebSBv1wnr+CD/R2rOwIC
   9hSqUWHwfOkTxMIOiYTod4rqygLD9usN130dSJzpwCcYWUrh2TYuVMbzo
   lX+hzu/33ICDg3+jBEDodG/QLl6xGfbJdDFAo4v8+CiEXnQPqcrv8fGWk
   3Ko5VzcKSSSmtlrZEyBX2svdDP/iiiKdpA0fdvQFCjVlijSKzsurU3rot
   uE7UUaIKWzZ0MjvgPGmciRfW3lOIpzob5JIZT1Kjr1gAnkzQ54geW7nRy
   AAN1KlJD0iIhFxfDwKW+XBgeCSx7LJE0WrgBZ7t/D6KpOYIjwpefVCfPO
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10776"; a="397487732"
X-IronPort-AV: E=Sophos;i="6.01,216,1684825200"; 
   d="scan'208";a="397487732"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2023 19:30:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10776"; a="759390950"
X-IronPort-AV: E=Sophos;i="6.01,216,1684825200"; 
   d="scan'208";a="759390950"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 19 Jul 2023 19:30:01 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 19 Jul 2023 19:30:00 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 19 Jul 2023 19:30:00 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 19 Jul 2023 19:30:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z4iCgBHFrRMctWLOKY631F5g7LLohvAWXJBCWg9ELbqU7n8lfoDbQRIpUzLqe69kIzUPSas+CSNlWYkmPD+zDUdeG8Y9noMVQry77rndtNDdmtyFVRq6sVqX82bKm21XhFnUn4qc+S7DuekkU1biAEFqQln0U4mk7XRpTfofF6rpAhKJbBHtxNdAErCePCypSv/CYjNARmJaA6XyqU9w9hnGCCVisyqnzhn7ZVEy7UqdrGJJr/XO8Fs3dO91eZYE5kbN8Z6NfURjLQBZT7uWyvdLJVxS/mM7SR3G4SO+j/QOc8F2U/cTZ58c0fjF2k0bi/QAU8qruoS8+Ve9/fTNag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BmQTGJTsP9iugCJBxQ0Hg7QZ3IiO5jkEaSiumdckb+8=;
 b=b1/BAr0oITIDnsJdqT3BjRMe7K36G0Zjzidz8F/nGO84WChQsYsKgkEVErqv6LLEXKowIKDH04TdZ9ecj9IUfZLlOYSWqKLw+hj3FOGcmNPdcQ8CD+9KynqCrGtYRcQbc4DWg9Y1PR2/kdzHVzRwgTYcJB5JoF/OXuycAz8VvClzSuLCLf51U++ahWl+CzfzAgygKdU42f1IWp+TDTpFptTiobwJ/n7diKOBx3KWr5I93G1oVWNvn/WCtDvxUhBA8P7wn+PdQqbTcyVQCCk3J3gNQK+5UtGWOpt3NDgInPO42zD2r+5g0344C1E2fSgEC/p88W+zsJKZIi0RgGuALQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS0PR11MB7804.namprd11.prod.outlook.com (2603:10b6:8:f3::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6609.24; Thu, 20 Jul 2023 02:29:58 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63%2]) with mapi id 15.20.6609.024; Thu, 20 Jul 2023
 02:29:57 +0000
Date:   Thu, 20 Jul 2023 10:03:15 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <stevensd@chromium.org>
Subject: Re: [PATCH] KVM: allow mapping of compound tail pages for IO or
 PFNMAP mapping
Message-ID: <ZLiV4y5uFJz4GxUr@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230719083332.4584-1-yan.y.zhao@intel.com>
 <ZLgEbalDPD38qHmm@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZLgEbalDPD38qHmm@google.com>
X-ClientProxiedBy: SI2P153CA0034.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::17) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS0PR11MB7804:EE_
X-MS-Office365-Filtering-Correlation-Id: 1873af08-9839-4d53-35bc-08db88c935ac
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sdfn4mxt4qZFsa04sv/rubj7JO0bn3Wyx8v2sOHBlUgqfPPG2YbaOFbYpfcVGMc+eutcNUzHJoc62nuz/xzGjGMb947K/9L+4fxmsp/jWhNbfHtEiM2y3GJYSwag9IQdJqRIXIEORyvkceoNUZjVxm3hijcqptzIbGnFhQfwy8Xkrd9YHsZ8ZU3Fxxml91aUS37e9wNnFq8rkYZOid9K9NZTLIBLKaOvyNzOcKKl5EKLsHd1AENU3UT8sxRphOEFEiIyDWr/tMbif1NYXefKOJJi8gXga0ZNsTSUSEyKSDIlaGe/4ujUjX83+3BnCmbaBO8h34hRqght+kNZa3PIFUqPSDnky6MdEXSe70+5O7HD3HAP36TpeAa/lsYIjnh4t0VhVzsearESgZY2yZuV+WDlrZBxg8iQZFlQ1bMZkoZKD87qcuYrD/QZ1b013pliw6rtYKxDA9cca7K+V9nPFQ3tmNBuvw7mxo2ZoVv/1sh8WNYzUgfER72nIMO/USt+AKcwnI2ZZoBEI59/r9iEAaYEqEE74QG3eQ4ljqHTXrpU2mtojbs/10VSVsUcTcZt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(136003)(396003)(376002)(366004)(451199021)(86362001)(478600001)(83380400001)(3450700001)(186003)(38100700002)(41300700001)(26005)(6916009)(316002)(8936002)(4326008)(8676002)(2906002)(6512007)(66556008)(66946007)(66476007)(6486002)(6666004)(6506007)(82960400001)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ssjMsR50F51Z/6XSq7932vZ4pBcx63R4vUbgoMyL5cG5aKJTctJ6Z//+TuZF?=
 =?us-ascii?Q?WklCL64LmObjvP+UvA6zHCC5watLHQ3tiaGUXoqubH2x8xJiqaHPOGgaAHv4?=
 =?us-ascii?Q?y85SPQZJ0mRB5HA6/mUN7qxgWa230qyO9pUkkXcsFnOuJ4UB2mCSlURd5uXQ?=
 =?us-ascii?Q?ugrdOE3+fBIfAYoQKmYhrzkr7ScIEnawJPkM1Z83K4dzGLokxdrprUmQB0D6?=
 =?us-ascii?Q?brFXFDaRqQCZVQNvt2u6fsJUi/1pjJ4LRR+6tiszlvfpwC/77escTxNKYaxK?=
 =?us-ascii?Q?IN+rjeFYyxCLeC7gmOmoPyJR0ShmqDVnKq3M+wEBvTbCDdHhl54XbkVCStuG?=
 =?us-ascii?Q?jc3xsP3xOPWRWYFAyf0qVIT1PwSqCj424OsSsP0aXfhe4xOh2WSbl4bWghUg?=
 =?us-ascii?Q?DI1bYVHgFOOKQkPPBxVGjfW+JozmLWiOxwut74jSjzRjI9z8Cn4pTE5p+8TA?=
 =?us-ascii?Q?SllXi8RgvTidDZpR7dHEl05mAVHk/ZuXgJ7mP2SVTQtyXtQ93bgNvkwN88EG?=
 =?us-ascii?Q?zgIeR0SV8b5NGuEGVAfVgOX2nCR5svMSY5M+qGEV+bwR5Jx928PnngzBWgWY?=
 =?us-ascii?Q?fe3BOYmx8cV3v/ouSzyGSWHeDwigX5FC33gxq/Uauh2VUrHcz/vVlQzoCOxY?=
 =?us-ascii?Q?jh/PSPCEBTnmP+vUYzO9vNecFQPyJCGW3D9rRcHfXJIZB9lfy3IDHrMxqqQV?=
 =?us-ascii?Q?mp9wPBMcpW/Azrz8w8sTxaxtxwIuXY5Ck01q5sQT+kO1DamjzM5xxMcZar/K?=
 =?us-ascii?Q?hDjuaDLGmi/Ufd8kMorXdCLg2MTROArNbpZJCL3tfzPlYM7tUWulFv9qFRk4?=
 =?us-ascii?Q?l4Zg10VSNnuqiohyhmfnRUL45iAGjmoMSQ1Sb7CPLZ8Gx15unVaSkwQpWX+7?=
 =?us-ascii?Q?ssdvFoX2yJTjnN6ffMc8Q+04BknLbm1BW4KC5inqVxkOuqgoLBNAzrF4QpO2?=
 =?us-ascii?Q?MSDvKgGZT21sXTpx5ahXPcLwa30UFTxlA3/AmRAZiuuwXpaDOdFpAoMwwR9e?=
 =?us-ascii?Q?hWiRdUBft0bxmEkEvRlzpN0C49FDpePb+ZBIq7oKQU99hjEnomQe7mZKBYPn?=
 =?us-ascii?Q?2H43+CQegJ2Zrc8ml3yCDM8fp25BVK2VaezPC8C6I783uFZIMqU+scT0oRzM?=
 =?us-ascii?Q?A7JIVJ2uByuM5t8kayIoAo+0eW5HJaKStu+rL8yS62YAf1SChfgdqAVs6cam?=
 =?us-ascii?Q?MxrcpTRPeX/lCz+bXu/y0orP8oAEWJFkvi2llZSAyZv/Ev2iPUz21492VY2E?=
 =?us-ascii?Q?1VRzLqPSeW4SBrRTZIxCngrzdOKQpSc/yAc3XfnwY3sAhcWCiJz59j3l5ux4?=
 =?us-ascii?Q?wHocA3qfEVE/xQbvFxhqHvadZA+Drofsnm7evcoTVDwhl8xSO9PCdJgjVVUF?=
 =?us-ascii?Q?xgRzIHoTt4l7SSYjuzHu3WY+gCfhZH/bGbELW9rFzBjPoMQXwNl1c0M+Zp3I?=
 =?us-ascii?Q?k86Tb8qyM2Be+A39sSbyNRD1cwwEfAihzOhiywQk94zH9UKORE/JYyfHWCGo?=
 =?us-ascii?Q?7nOaBGBcGZLsFs5aB7xUo7vJBiM9tWex3X971SaeNnPGAmgOrs4Cx31/hV+H?=
 =?us-ascii?Q?2VtYMqpL+0R1f/GZayWk/QjkYVrmjETlVEGSljAU?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1873af08-9839-4d53-35bc-08db88c935ac
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2023 02:29:57.6149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pfPCNzQajbezMexpwnhj8wEaD0vLseiHt1052ZHViiIGU+OFfBNG+580X3U3LUP6G5SmZEBJmgP8UwF1tkZ3nA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7804
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 19, 2023 at 08:42:37AM -0700, Sean Christopherson wrote:
> On Wed, Jul 19, 2023, Yan Zhao wrote:
> > Allow mapping of tail pages of compound pages for IO or PFNMAP mapping
> > by trying and getting ref count of its head page.
> > 
> > For IO or PFNMAP mapping, sometimes it's backed by compound pages.
> > KVM will just return error on mapping of tail pages of the compound pages,
> > as ref count of the tail pages are always 0.
> > 
> > So, rather than check and add ref count of a tail page, check and add ref
> > count of its folio (head page) to allow mapping of the compound tail pages.
> > 
> > This will not break the origial intention to disallow mapping of tail pages
> > of non-compound higher order allocations as the folio of a non-compound
> > tail page is the same as the page itself.
> > 
> > On the other side, put_page() has already converted page to folio before
> > putting page ref.
> 
> Is there an actual use case for this?  It's not necessarily a strict requirement,
> but it would be helpful to know if KVM supports this for a specific use case, or
> just because it can.
Well, the actual use case is a kind of "yes and no".
In VFIO we now have the concept of "variant drivers" which work with
specific PCI IDs. The variant drivers can inject device specific
knowledge into VFIO. I tested this patch by writing a variant driver to
my e1000e NIC and composing a BAR whose backends are compound pages of 4M in
length.

I guess there might be real use case when the backend pages are in
ZONE_DEVICE but I haven't spent enough time to setup such kind of
environment for verification.

> Either way, this needs a selftest, KVM has had way too many bugs in this area.
Sure, I'll try to provide a selftest.
Thanks for bringing it out!

