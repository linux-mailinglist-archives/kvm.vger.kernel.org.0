Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 586B869DE88
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 12:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233452AbjBULNj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 06:13:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233042AbjBULNh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 06:13:37 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39DE5AD2C
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 03:13:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676978016; x=1708514016;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=WSd4BVvHWZHUSE/Axf3e5vPaIuQlc5kJNW45XHFjR6w=;
  b=R/D6SY33QImc5FFSOs2HqJx/bZnnGunlOwvNQoPY28MaH0l/vmqb8wtM
   YFoOKzf2sdV7KF8ceJzDsB2nNl6B1Les+8TC43S0xS8M6YZZv0oBkEWtS
   zBaMx7jtYaTR+cwyi3Z+hHVAPyY7tpBChSomA6E1vtcX500Y14atDb7G3
   GD2WmaQiV3PYWfK0vQbdxFMzN6ajYyAtp5mcmUGEzWWN/WAi0V4pDTWCW
   v7bAVmObMHTKO/RTsmYDgahUk1djH+LDlp87MKB6C03lFFsTVCVPkbqYn
   1GayZ66Fe/JV0BBVtuQ3Uiimhy43a8n5AncFYoGZBih6VsNUcGt7Mmrof
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="360074466"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="360074466"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 03:13:35 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="795481352"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="795481352"
Received: from yichaohu-mobl.ccr.corp.intel.com (HELO localhost) ([10.254.208.83])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 03:13:31 -0800
Date:   Tue, 21 Feb 2023 19:13:28 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     Robert Hoo <robert.hu@linux.intel.com>, seanjc@google.com,
        pbonzini@redhat.com, yuan.yao@linux.intel.com,
        jingqi.liu@intel.com, weijiang.yang@intel.com, chao.gao@intel.com,
        isaku.yamahata@intel.com, kirill.shutemov@linux.intel.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH v4 9/9] KVM: x86: LAM: Expose LAM CPUID to user space VMM
Message-ID: <20230221111328.jaosfrcw2da7jx76@linux.intel.com>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
 <20230209024022.3371768-10-robert.hu@linux.intel.com>
 <2c7c4d73-810e-6c9c-0480-46d68dedadc8@linux.intel.com>
 <587054f9715283ef4414af64dd69cda1f7597380.camel@linux.intel.com>
 <fc84dd84-67c5-5565-b989-7e6bb9116c6e@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fc84dd84-67c5-5565-b989-7e6bb9116c6e@linux.intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> 
> The special handling for LA57 is from the patch "kvm: x86: Return LA57
> feature based on hardware capability".
> https://lore.kernel.org/lkml/1548950983-18458-1-git-send-email-yu.c.zhang@linux.intel.com/
> 
> The reason is host kernel may disable 5-level paging using cmdline parameter
> 'no5lvl', and it will clear the feature bit for LA57 in boot_cpu_data.
> boot_cpu_data is queried in kvm_set_cpu_caps to derive kvm cpu cap masks.
> 
> " VMs can still benefit from extended linear address width, e.g. to enhance
> features like ASLR" even when host  doesn't use 5-level paging.
> So, the patch sets LA57 based on hardware capability.
> 
> I was just wondering  whether LAM could be the similar case that the host
> disabled the feature somehow (e.g via clearcpuid), and the guest still want
> to use it.

Paging modes in root & non-root are orthogonal, so should LAM.

B.R.
Yu
