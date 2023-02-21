Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 573CC69E274
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 15:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234479AbjBUOhE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 09:37:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234496AbjBUOhC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 09:37:02 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97AB2A6C6
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 06:36:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676990207; x=1708526207;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=56/amPO7umkfCno8KWBQ2OJYcCSCPe2SCOmLV8mpFWE=;
  b=MfuNQ+G1QVOOBW+anoIB6yw4tRGhOTcMU00XCS+BrzUtorGv2eBF+kIB
   ScUb71XyaLaSUvwWBTNcdm6wJbJL9trXkoqaK9okihPofIl07KRlKkJzP
   679KXU8/MLsDg8eRa6+iaHG2t3WfjJLSv9LpECMWM4yIBxH297g+e5UOW
   iAed2WFtaKThItOxKE8M5bPEHwulejUcmOaNGp3tpdkDPi9LvXsfhN3pi
   tnbLqMh4LhfoX2KwJZyoUL5gAZA3SsIsXdQGx+RFOSMAOGLcwITqn8Fnr
   WxYM+ghdK8inOFccY4XmWdMQMdtNF2fXWKCMS3b9HsR7e4Y8bIGUYdCkc
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="316366325"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="316366325"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 06:36:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="845697060"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="845697060"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga005.jf.intel.com with ESMTP; 21 Feb 2023 06:36:24 -0800
Message-ID: <c4057e5a1648714832f0a29ab6a4a28d991e27c0.camel@linux.intel.com>
Subject: Re: [PATCH v4 9/9] KVM: x86: LAM: Expose LAM CPUID to user space VMM
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, yuan.yao@linux.intel.com,
        jingqi.liu@intel.com, weijiang.yang@intel.com, chao.gao@intel.com,
        isaku.yamahata@intel.com, kirill.shutemov@linux.intel.com,
        kvm@vger.kernel.org
Date:   Tue, 21 Feb 2023 22:36:24 +0800
In-Reply-To: <ccf06c0d-8ca9-9693-c580-d832e162fbfa@linux.intel.com>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
         <20230209024022.3371768-10-robert.hu@linux.intel.com>
         <2c7c4d73-810e-6c9c-0480-46d68dedadc8@linux.intel.com>
         <587054f9715283ef4414af64dd69cda1f7597380.camel@linux.intel.com>
         <fc84dd84-67c5-5565-b989-7e6bb9116c6e@linux.intel.com>
         <20230221111328.jaosfrcw2da7jx76@linux.intel.com>
         <ccf06c0d-8ca9-9693-c580-d832e162fbfa@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2023-02-21 at 21:18 +0800, Binbin Wu wrote:
> On 2/21/2023 7:13 PM, Yu Zhang wrote:
> > > The special handling for LA57 is from the patch "kvm: x86: Return
> > > LA57
> > > feature based on hardware capability".
> > > https://lore.kernel.org/lkml/1548950983-18458-1-git-send-email-yu.c.zhang@linux.intel.com/
> > > 
> > > The reason is host kernel may disable 5-level paging using
> > > cmdline parameter
> > > 'no5lvl', and it will clear the feature bit for LA57 in
> > > boot_cpu_data.
> > > boot_cpu_data is queried in kvm_set_cpu_caps to derive kvm cpu
> > > cap masks.
> > > 
> > > " VMs can still benefit from extended linear address width, e.g.
> > > to enhance
> > > features like ASLR" even when host  doesn't use 5-level paging.
> > > So, the patch sets LA57 based on hardware capability.
> > > 
> > > I was just wondering  whether LAM could be the similar case that
> > > the host
> > > disabled the feature somehow (e.g via clearcpuid), and the guest
> > > still want
> > > to use it.
> > 
> > Paging modes in root & non-root are orthogonal, so should LAM.
> 
> Agree.
> 
Understand

In 
https://lore.kernel.org/lkml/1548950983-18458-1-git-send-email-yu.c.zhang@linux.intel.com/
, it mentioned
"As discussed earlier, VMs can still benefit from extended linear
address width, e.g. to enhance features like ASLR. So we would like to
fix this..."

Apparently something was "discussed earlier", some request was made for
that (perhaps related to ASLR).
Read through kvm_set_cpu_caps(), such kind of handling, i.e. bypass
host/KVM and expose the feature as long as HW supports it, is exception
case.
Therefore, though LAM could be done like LA57, I hesitate to make LAM
exception case to break existing framework, unless analogous
discussion/request for it occurs.

