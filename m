Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C22E7AE3DE
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 05:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbjIZDA5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 23:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjIZDA4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 23:00:56 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC91FF
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 20:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695697249; x=1727233249;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=7GFl4itdtuMXfst8RL4r9WmQ/Ip+dCbh6Yz8PuvPU+4=;
  b=dQ9GmfnjLCnILESobalqwN9FXMkOGJYu6rAncrLPzrj2cWLXV7YIFYjs
   DKFSKDu9YxHgbu8v5THt2GhVBTK1EUpduuBZYkLKQaKOR1z5KVRPue/QY
   r5rUIamTK46DajvuwCBzSgvvjGQHspghcKvrlrbvQshYdUAphOfqXj9mh
   cg3W82hzs83daCGqp7Z0mNFft5IEg3z6KGsSwYzfaRkD00dQ6KjQ1HswH
   4wgDhzgNwcus62G59v7AE7OBn8QiE/xPa7bb7UewBTget2HDZ85jJmRHl
   w8FymxRzJ+NdzDqyUgBjpbYZy0SGhMhnrd+aqB3PGk1nb7rqC2usVtLKi
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="412386106"
X-IronPort-AV: E=Sophos;i="6.03,176,1694761200"; 
   d="scan'208";a="412386106"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 20:00:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="725285773"
X-IronPort-AV: E=Sophos;i="6.03,176,1694761200"; 
   d="scan'208";a="725285773"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orsmga006.jf.intel.com with ESMTP; 25 Sep 2023 20:00:44 -0700
Date:   Tue, 26 Sep 2023 11:11:51 +0800
From:   Zhao Liu <zhao1.liu@linux.intel.com>
To:     Babu Moger <babu.moger@amd.com>
Cc:     Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Zhenyu Wang <zhenyu.z.wang@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH v4 01/21] i386: Fix comment style in topology.h
Message-ID: <ZRJL99Jc9xOGUBvy@liuzhao-OptiPlex-7080>
References: <20230914072159.1177582-1-zhao1.liu@linux.intel.com>
 <20230914072159.1177582-2-zhao1.liu@linux.intel.com>
 <316dfbed-5b67-4140-8502-d0f32dec5162@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <316dfbed-5b67-4140-8502-d0f32dec5162@amd.com>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023 at 11:05:59AM -0500, Moger, Babu wrote:
> Date: Fri, 22 Sep 2023 11:05:59 -0500
> From: "Moger, Babu" <bmoger@amd.com>
> Subject: Re: [PATCH v4 01/21] i386: Fix comment style in topology.h
> 
> 
> On 9/14/2023 2:21 AM, Zhao Liu wrote:
> > From: Zhao Liu <zhao1.liu@intel.com>
> > 
> > For function comments in this file, keep the comment style consistent
> > with other files in the directory.
> > 
> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> > Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> > Reviewed-by: Yanan Wang <wangyanan55@huawei.com>
> > Reviewed-by: Xiaoyao Li <xiaoyao.li@Intel.com>
> > Acked-by: Michael S. Tsirkin <mst@redhat.com>
> 
> Reviewed-by: Babu Moger <babu.moger@amd.com>

Thanks!

-Zhao

> 
> 
> > ---
> > Changes since v3:
> >   * Optimized the description in commit message: Change "with other
> >     places" to "with other files in the directory". (Babu)
> > ---
> >   include/hw/i386/topology.h | 33 +++++++++++++++++----------------
> >   1 file changed, 17 insertions(+), 16 deletions(-)
> > 
> > diff --git a/include/hw/i386/topology.h b/include/hw/i386/topology.h
> > index 81573f6cfde0..5a19679f618b 100644
> > --- a/include/hw/i386/topology.h
> > +++ b/include/hw/i386/topology.h
> > @@ -24,7 +24,8 @@
> >   #ifndef HW_I386_TOPOLOGY_H
> >   #define HW_I386_TOPOLOGY_H
> > -/* This file implements the APIC-ID-based CPU topology enumeration logic,
> > +/*
> > + * This file implements the APIC-ID-based CPU topology enumeration logic,
> >    * documented at the following document:
> >    *   Intel® 64 Architecture Processor Topology Enumeration
> >    *   http://software.intel.com/en-us/articles/intel-64-architecture-processor-topology-enumeration/
> > @@ -41,7 +42,8 @@
> >   #include "qemu/bitops.h"
> > -/* APIC IDs can be 32-bit, but beware: APIC IDs > 255 require x2APIC support
> > +/*
> > + * APIC IDs can be 32-bit, but beware: APIC IDs > 255 require x2APIC support
> >    */
> >   typedef uint32_t apic_id_t;
> > @@ -58,8 +60,7 @@ typedef struct X86CPUTopoInfo {
> >       unsigned threads_per_core;
> >   } X86CPUTopoInfo;
> > -/* Return the bit width needed for 'count' IDs
> > - */
> > +/* Return the bit width needed for 'count' IDs */
> >   static unsigned apicid_bitwidth_for_count(unsigned count)
> >   {
> >       g_assert(count >= 1);
> > @@ -67,15 +68,13 @@ static unsigned apicid_bitwidth_for_count(unsigned count)
> >       return count ? 32 - clz32(count) : 0;
> >   }
> > -/* Bit width of the SMT_ID (thread ID) field on the APIC ID
> > - */
> > +/* Bit width of the SMT_ID (thread ID) field on the APIC ID */
> >   static inline unsigned apicid_smt_width(X86CPUTopoInfo *topo_info)
> >   {
> >       return apicid_bitwidth_for_count(topo_info->threads_per_core);
> >   }
> > -/* Bit width of the Core_ID field
> > - */
> > +/* Bit width of the Core_ID field */
> >   static inline unsigned apicid_core_width(X86CPUTopoInfo *topo_info)
> >   {
> >       return apicid_bitwidth_for_count(topo_info->cores_per_die);
> > @@ -87,8 +86,7 @@ static inline unsigned apicid_die_width(X86CPUTopoInfo *topo_info)
> >       return apicid_bitwidth_for_count(topo_info->dies_per_pkg);
> >   }
> > -/* Bit offset of the Core_ID field
> > - */
> > +/* Bit offset of the Core_ID field */
> >   static inline unsigned apicid_core_offset(X86CPUTopoInfo *topo_info)
> >   {
> >       return apicid_smt_width(topo_info);
> > @@ -100,14 +98,14 @@ static inline unsigned apicid_die_offset(X86CPUTopoInfo *topo_info)
> >       return apicid_core_offset(topo_info) + apicid_core_width(topo_info);
> >   }
> > -/* Bit offset of the Pkg_ID (socket ID) field
> > - */
> > +/* Bit offset of the Pkg_ID (socket ID) field */
> >   static inline unsigned apicid_pkg_offset(X86CPUTopoInfo *topo_info)
> >   {
> >       return apicid_die_offset(topo_info) + apicid_die_width(topo_info);
> >   }
> > -/* Make APIC ID for the CPU based on Pkg_ID, Core_ID, SMT_ID
> > +/*
> > + * Make APIC ID for the CPU based on Pkg_ID, Core_ID, SMT_ID
> >    *
> >    * The caller must make sure core_id < nr_cores and smt_id < nr_threads.
> >    */
> > @@ -120,7 +118,8 @@ static inline apic_id_t x86_apicid_from_topo_ids(X86CPUTopoInfo *topo_info,
> >              topo_ids->smt_id;
> >   }
> > -/* Calculate thread/core/package IDs for a specific topology,
> > +/*
> > + * Calculate thread/core/package IDs for a specific topology,
> >    * based on (contiguous) CPU index
> >    */
> >   static inline void x86_topo_ids_from_idx(X86CPUTopoInfo *topo_info,
> > @@ -137,7 +136,8 @@ static inline void x86_topo_ids_from_idx(X86CPUTopoInfo *topo_info,
> >       topo_ids->smt_id = cpu_index % nr_threads;
> >   }
> > -/* Calculate thread/core/package IDs for a specific topology,
> > +/*
> > + * Calculate thread/core/package IDs for a specific topology,
> >    * based on APIC ID
> >    */
> >   static inline void x86_topo_ids_from_apicid(apic_id_t apicid,
> > @@ -155,7 +155,8 @@ static inline void x86_topo_ids_from_apicid(apic_id_t apicid,
> >       topo_ids->pkg_id = apicid >> apicid_pkg_offset(topo_info);
> >   }
> > -/* Make APIC ID for the CPU 'cpu_index'
> > +/*
> > + * Make APIC ID for the CPU 'cpu_index'
> >    *
> >    * 'cpu_index' is a sequential, contiguous ID for the CPU.
> >    */
