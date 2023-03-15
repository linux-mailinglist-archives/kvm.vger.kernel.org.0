Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9786BAE5F
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 12:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjCOLAy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 07:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjCOLAt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 07:00:49 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB20D367F4;
        Wed, 15 Mar 2023 04:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678878047; x=1710414047;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=IK2fwQNrf5b7/8mnntrBn4P8KxjF+2u1eIoV1gLvRBQ=;
  b=DpzXl9A0IHNtU8sV+laFgy+6EAdcKPc8O6+bJUd4CWfgOU4a89xDFeib
   nlwUtXpjXRLJGdJmCmbcRaIDpNo57PKQuCRuYqh8WRG1CA9pVgybBJc6F
   fpc88chVi94YQ712PsLCQDixrAyDkHIJr/C6Q7uW/NPOlO+rGSVVCiJKI
   DQW3P41qDUy7kU6vfn8/9QOhkJ80zElbooJKQjbCRqJvgawdIE8eaNpj8
   541TPjwL/lNpqKhkNI8bkP89wvnfhZyu+JxhNBVE4vgn/B4+vQp+Xy5KT
   d9DN2J2qvg0QCGsy5f8kphmFZ/112F7LlyKX2zz1Cj2XTvcCajYwxxF+4
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="317325450"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="317325450"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 04:00:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="803242312"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="803242312"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 15 Mar 2023 04:00:46 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 04:00:46 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 04:00:46 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 04:00:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UxlJn+LTjpBXX+easm3q/zKQpCeKDV2z+AGnRPpIaVEmliidwGxFeA1YfCqKKt1+0FIcqS5ZbmX7K/pyVSUxCPUNYRl+HE/Oc+jBpuYSuANU9KVLYSO3vz94Kmtz/Hyl33wyqhJt/DZ5t374j6fzuP6/fDPClbk+JiJYPS7i5PkJYT5I+YIe4Zh5yZWXqv0xXuFS2Ca50hbTHXMwKCb7ukHTlkAHUFleun/O9kcAK2FucJm9cFgGVOooFCNiyKF7Df/Zt7Yh4AjI/sSsaTYiNrLT3b5RkYYYwYSTHyBOSXdVw7rfRmufQ34nfsUmPRlKyDntF1U+kg7/nSdGJfuQNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hlz6/mk5CLeeNrejrR3lkP1BoIzjFpwImrGaNFPMtcA=;
 b=dY5qIUWrReLjqM8Un6V8r9vqTQRz9DcfVDkDK3hIt+yQrCSKRTOpbW6ya27mwnxn1Etq3F/HNv2HMz27GPHYg9IfkgI/LT/UhDqSjO5MhLUxygCmxvhKn3vR5ghr7ccgwiqJZFgGg0mqmkZvWyr2GvdJ0e7+z5+6d0PRvu62TAsktEZCSdVr/akQBcYIvNSowYiPTKH3k1bBqrT1aiQon9+FKKlPDzzjCQEQ2/0wh7620Ylc7zeehWrsBU392/SQzDtWtCKqMhvDlM+MTDJTt/nuZaLhggudP8IjakwpXn9cAEGWn0YZTkUQEc+pZiCE7pldRweiFwHKvErM//TS3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CY8PR11MB7780.namprd11.prod.outlook.com (2603:10b6:930:78::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.26; Wed, 15 Mar 2023 11:00:44 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e%4]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 11:00:44 +0000
Date:   Wed, 15 Mar 2023 18:36:08 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 20/27] KVM: x86/mmu: Use page-track notifiers iff
 there are external users
Message-ID: <ZBGfmLuORj+ZBziv@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230311002258.852397-1-seanjc@google.com>
 <20230311002258.852397-21-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230311002258.852397-21-seanjc@google.com>
X-ClientProxiedBy: SG2PR01CA0154.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::34) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CY8PR11MB7780:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e9fe086-a66a-41e5-0d37-08db254485e8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OAPNw3m4+Wkndy9N74d0iUuT33GUA/Hn56JVzdMHPkAGmdIBqoiHmOxppbHm/eC2aQN9gweA0K6KBbv5fRr+dn+Ng7txuNbCsWJDeqQQQI3UgaxFMZW1pBNmhpUVlPIvxsNfpsOSOMaY7Lxxud82oXQYHYvYBedI1bVKhVif3Z79nNFzVXtr7hMa0f7qolE0Mpih+t2OLAmZofBhErR7oIAgkPTC4WbH8E2gAQNVIdB0weRGWHjOmUZEoP3RWRL78R4OjXF1Ag0Yd945354wl1FIvHV1n56o7P4DN94rpjKm1qNamhbctQVmae6aGw+hrwPEGflbujiypk0H2VZohI1RBdABik/Z/PfRRF14i8kiWa1d6tOFVYVwDhnmnJpr5XPDng8mAyjJMBOja6SdaY1IDg0ujbg15a9I7NOh0axHGSswd0cBKaeOj6mM7GKZuNXZdYeQ2HDyNmGzpu/JfgqrVGTdYELIkquIR3v0Vqx71lZn4BNFfgKoUPHJ7ZgdrdZVBaNZgHiLyh5zDTzCADvJvR63N8KnfvIQkp4iC4kSscO47H3HeAt+79411ECeEDqS/R/C6/Rb+Ushw8z+IyIbTxqZaKIiPOVUiJkGfkxck769GupsRu5Okng1JqmA09veOnuUFG9hAVRxqsRZgoITnLbChdgS3JDo2J1AA34Zpa9cFW5gc2xOpm0AOeQAvq8lSYMZ9RiS4oYLEJyWen/12iYOhU9aXilB+BSLT1tttHCA75fTsmS7dS456/uR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(346002)(376002)(396003)(39860400002)(451199018)(6486002)(6916009)(66556008)(66946007)(186003)(66476007)(8676002)(41300700001)(4326008)(5660300002)(83380400001)(8936002)(26005)(6506007)(6666004)(6512007)(316002)(478600001)(54906003)(2906002)(82960400001)(38100700002)(3450700001)(86362001)(26730200005)(19860200003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IPq4shFE2C9bVerqXsk2YoOGHZBjbVyAqU310dxm6R0FN7rknnw6iK/sHqu4?=
 =?us-ascii?Q?hIOAAkpdlmWng7oAAyEL6r6QPkbJfo80r8KcIqYshd9cxQtx7WuXcs4/SomQ?=
 =?us-ascii?Q?CIMka2mX2fMwp60AOwytZKExyoOhsC1DO/15hkCZEoy8aLZUKM3a104+Bklj?=
 =?us-ascii?Q?urDiXTBfSFQbZjgTQ5hZyfhbhW3/mKXevxZMWB9fDJi25mTw+1lrWEJE6nbh?=
 =?us-ascii?Q?mvZQQcOkhRvAqI+VZaa3pyh5MjvU4qGncydDCudliz77YQo/AyaEAA3DTWMa?=
 =?us-ascii?Q?XqePX/XMAmLnKol3nYJnJb3NUN6Fu6qsioYXddTiDr+wjvXEvfst3nkKSVtC?=
 =?us-ascii?Q?C0yKJuMXcwWii9ejiBChDudG0E0nMS4ln0QM1oIk4qDlvhQ4zFh+kiy3i1Rj?=
 =?us-ascii?Q?g0GZ+Vwl9DgB7Pj46E5/lX+aRgDqY4pJ49p6t9dtckzmD9J91HYYIVXUfKbq?=
 =?us-ascii?Q?HJyrTriwmmh6b+fqFQ3ZPtmra5Fu6i+wi3kZaQqmA5oQygf1f2e5JPWMs3Wz?=
 =?us-ascii?Q?PdDW9fnOXc6MH+ngp76NgIo2nLhD9sWEiqsHeJiD7Hl9NxXhkxM8/PJjRxxD?=
 =?us-ascii?Q?CmixT+us6whKcXEfUQuOIgPJl5LENw0pndcEyiSE7C9cdLUYkuaqOhbavuhA?=
 =?us-ascii?Q?zQWybxAXdAznsTiqwKiyot3wFoiRp7Yr5xbvIoPm/aUtHjICYyziDK02CA24?=
 =?us-ascii?Q?NY86r4tkbN79xoEOAeZJbZLpIg7TE0drcgxQhoFC1x6kdFmua9gMBCJbebeq?=
 =?us-ascii?Q?mHY+zGC6G2b9qztqdcI/QZXb1swTSnuC5fUqnNiSm45MNuFOO9OfJD5hBwdk?=
 =?us-ascii?Q?P/Sj9ewAsc17Vcf84AGeMDN3rHxwsQ+BCQJOFpQUo1LAvbhFM9H/TEjVz+0+?=
 =?us-ascii?Q?AQBAba4bOG8QKwFBq2Nr1lBdLzZ8y7VzXkrmCpp8xscZHYLLYCcEX9HtyC82?=
 =?us-ascii?Q?mQDtRv8t2h6qQ3nmygGN2v3+FABYT8M1pX2VPF69sdDDGGllR63df51Px80T?=
 =?us-ascii?Q?Qd+fxRmA9yVsnOvEqAkcgmPdaMr2RR8Jp7T4wp+2Doyk5d4XuL+ZZSHEMjbS?=
 =?us-ascii?Q?bDjZSZl1bY07lZeJyZlAPKd1Yk/IF7GfFqt7dbL97bquMi6TKrozH8SEEuDY?=
 =?us-ascii?Q?PON70+F71YMUPQ1VnAeHyBavee5pSPROH6vmjo1ATa1chsiSCc/v3lB4Qqmv?=
 =?us-ascii?Q?L3yCZsZ6LCQBDFJCcfglYynxvKyH/ELm2lMJgqR3Qunp9H4g4ayqBCJ6605+?=
 =?us-ascii?Q?QsVYKz+8XctQDZZO7/nlpv0sYsHZRKHkeBjAt+c7IG/xncJDr0dIyEshAvZl?=
 =?us-ascii?Q?NOqLbs1C0H7HcNT9Ks29HQCH7xNYagZCKa3SQafG8PBCbCqiZysuP6byyBAe?=
 =?us-ascii?Q?pqQgMsujyOT/YiIRkjS8WHzsfdXLfU5OQNcT3gMcz8DJXgASg1hmZJTODObg?=
 =?us-ascii?Q?jZxHgsewtiYrNpdVw50t2mnzmmZ0tyye3gdSN7Wz+L7mxOvQ6xzLhEZQHEJy?=
 =?us-ascii?Q?pztH3fBWimWca5GYdMwMsWBAsGE3/Zy2G89oeuPj9LosVj/lwTCHQlw+QwxW?=
 =?us-ascii?Q?tPQ0ggINctVVQ6ECfFCY4gLUJPLpllo/dw9FsjOLXAU3qZE1seJ2qI8XS9y+?=
 =?us-ascii?Q?Ig=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e9fe086-a66a-41e5-0d37-08db254485e8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 11:00:43.9513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J+UMm2WgbH0D8xMlgWRnD4G5ox+cq/nyB8hTAbRTuwAz09l7G4DgEaJJIdKEsq5HJvD9NXiYwl5lCp3EidEc/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7780
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 10, 2023 at 04:22:51PM -0800, Sean Christopherson wrote:
> Disable the page-track notifier code at compile time if there are no
> external users, i.e. if CONFIG_KVM_EXTERNAL_WRITE_TRACKING=n.  KVM itself
> now hooks emulated writes directly instead of relying on the page-track
> mechanism.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h       |  2 ++
>  arch/x86/include/asm/kvm_page_track.h |  2 ++
>  arch/x86/kvm/mmu/page_track.c         |  9 ++++-----
>  arch/x86/kvm/mmu/page_track.h         | 29 +++++++++++++++++++++++----
>  4 files changed, 33 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 1a4225237564..a3423711e403 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1265,7 +1265,9 @@ struct kvm_arch {
>  	 * create an NX huge page (without hanging the guest).
>  	 */
>  	struct list_head possible_nx_huge_pages;
> +#ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING
>  	struct kvm_page_track_notifier_head track_notifier_head;
> +#endif
>  	/*
>  	 * Protects marking pages unsync during page faults, as TDP MMU page
>  	 * faults only take mmu_lock for read.  For simplicity, the unsync
> diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
> index deece45936a5..53c2adb25a07 100644
> --- a/arch/x86/include/asm/kvm_page_track.h
> +++ b/arch/x86/include/asm/kvm_page_track.h
The "#ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING" can be moved to the
front of this file?
All the structures are only exposed for external users now.

> @@ -55,6 +55,7 @@ void kvm_slot_page_track_remove_page(struct kvm *kvm,
>  				     struct kvm_memory_slot *slot, gfn_t gfn,
>  				     enum kvm_page_track_mode mode);
>  
> +#ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING
>  enum pg_level kvm_page_track_max_mapping_level(struct kvm *kvm, gfn_t gfn,
>  					       enum pg_level max_level);
>  
> @@ -64,5 +65,6 @@ kvm_page_track_register_notifier(struct kvm *kvm,
>  void
>  kvm_page_track_unregister_notifier(struct kvm *kvm,
>  				   struct kvm_page_track_notifier_node *n);
> +#endif /* CONFIG_KVM_EXTERNAL_WRITE_TRACKING */
>  
>  #endif
