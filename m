Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB73F3AD0B8
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 18:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233366AbhFRQt5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 12:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232180AbhFRQt5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Jun 2021 12:49:57 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C55C061574
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 09:47:47 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id m17so1789104plx.7
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 09:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ncQHqGFKlJiY/lX6rE3ziLQ8IMKC557jrx7x6ZWUf/4=;
        b=LwTdy0AB9UhNF0u/3IgeMTfpRQVlVos/vnuc9rGtCVd6cZF//F2ZZoiXM2Hgn4iaJw
         k2zPVcHNjLCFZA64UWBemQ5EnIUHigbJN6w0iRyBRTf5hidH2XLazVg2in6j1RadIvXK
         iRr7hbI+kHidcceM64HgrUIEBSGeMXscXjy5TcYR00APK6o2uP4870e0TErbsSPh0D05
         gNxveadw3tLrIrxZUEFDo1uzXXXerHAkf4kbIo1rZEhyWN6leI9Fo6L+0g42DOpoGLIb
         i6qytxnNvP8U7bd3g9uAC8aXb7MWVVzoKGJCZnf59nrlGpi5uAaxaYzoW6IPDGizHg6e
         C/yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ncQHqGFKlJiY/lX6rE3ziLQ8IMKC557jrx7x6ZWUf/4=;
        b=qs3o5kZyt6mVk78YppPRJtBf6s7+/pU/+Wa3KAQkNKZG3cevbnAlR7wPG3eIHTHFvU
         utjJzQBkcr9E7QmryVPF3Sy2CZg7Ctmei1TtSG7XDbj6Tx6aEyD1llcv32HwvWucPURQ
         6+e2mda1c5wKRM/R53mVempFzmQIL6HhMM+YnW/4rvJQm0LgG9iEaeVySF5VDpDnv56i
         DeArYPwXvOedczyKohDKLpeXsO8dyLVPIPasHMpjwflfxMnmVBnUuj8pj1wcJBVMvv/U
         jL0z8Jt1btCNCOrgEcpIQql6Fb+/nuMzsnmepBaK3pwv+lb1U20XyYEEJnl5fdVrfjpc
         Fk1Q==
X-Gm-Message-State: AOAM530qZ5Z94sADaUkZPW6GODcM37Wn8ULXE3MrO6YTHe8/YJpNZ7RK
        ONc3ZezuHJp6qqo5HxPafzz8qw==
X-Google-Smtp-Source: ABdhPJxJ4onauPNetBneLvzPijOpr4hRd/iyT++IbPkepp2V3q2wNz5HE5sfzkfJ0HOW25Cosq39Kg==
X-Received: by 2002:a17:90a:880c:: with SMTP id s12mr12016787pjn.66.1624034867160;
        Fri, 18 Jun 2021 09:47:47 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id g17sm4071668pfj.158.2021.06.18.09.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 09:47:46 -0700 (PDT)
Date:   Fri, 18 Jun 2021 16:47:42 +0000
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kernel test robot <lkp@intel.com>, kvm@vger.kernel.org,
        kbuild-all@lists.01.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH 2/4] KVM: x86/mmu: Remove redundant is_tdp_mmu_enabled
 check
Message-ID: <YMzOLu2OYn8GC/WD@google.com>
References: <20210617231948.2591431-3-dmatlack@google.com>
 <202106181525.25A3muPf-lkp@intel.com>
 <cb8882a8-4619-5993-f94a-097b1751e532@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb8882a8-4619-5993-f94a-097b1751e532@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 18, 2021 at 12:42:56PM +0200, Paolo Bonzini wrote:
> On 18/06/21 09:17, kernel test robot wrote:
> > Hi David,
> > 
> > Thank you for the patch! Yet something to improve:
> > 
> > [auto build test ERROR on kvm/queue]
> > [also build test ERROR on vhost/linux-next v5.13-rc6]
> > [If your patch is applied to the wrong git tree, kindly drop us a note.
> > And when submitting patch, we suggest to use '--base' as documented in
> > https://git-scm.com/docs/git-format-patch]
> > 
> > url:https://github.com/0day-ci/linux/commits/David-Matlack/KVM-x86-mmu-Remove-redundant-is_tdp_mmu_root-check/20210618-082018
> > base:https://git.kernel.org/pub/scm/virt/kvm/kvm.git  queue
> > config: i386-randconfig-a016-20210618 (attached as .config)
> > compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
> > reproduce (this is a W=1 build):
> >          #https://github.com/0day-ci/linux/commit/6ab060f3cf9061da492b1eb89808eb2da5406781
> >          git remote add linux-reviewhttps://github.com/0day-ci/linux
> >          git fetch --no-tags linux-review David-Matlack/KVM-x86-mmu-Remove-redundant-is_tdp_mmu_root-check/20210618-082018
> >          git checkout 6ab060f3cf9061da492b1eb89808eb2da5406781
> >          # save the attached .config to linux build tree
> >          make W=1 ARCH=i386
> > 
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot<lkp@intel.com>
> > 
> > All errors (new ones prefixed by >>):
> > 
> >     ld: arch/x86/kvm/mmu/mmu.o: in function `get_mmio_spte':
> > > > arch/x86/kvm/mmu/mmu.c:3612: undefined reference to `kvm_tdp_mmu_get_walk'
> >     ld: arch/x86/kvm/mmu/mmu.o: in function `direct_page_fault':
> > > > arch/x86/kvm/mmu/mmu.c:3830: undefined reference to `kvm_tdp_mmu_map'
> 
> Turns out sometimes is_tdp_mmu_root is not inlined after this patch.
> Fixed thusly:

Thanks for the fix. I guess after I removed the is_tdp_mmu_enabled()
check the compiler couldn't determine what is_tdp_mmu_root() would
return on 32-bit builds anymore.

Pretty nice of the compiler to throw out kvm_tdp_mmu_get_walk() and
kvm_tdp_mmu_map() once it knows they are not reachable so we don't have
to implement stubs for those functions that BUG_ON and pray they never
get called!

> 
> --------- 8< -----------
> Subject: [PATCH] KVM: x86: Stub out is_tdp_mmu_root on 32-bit hosts
> 
> If is_tdp_mmu_root is not inlined, the elimination of TDP MMU calls as dead
> code might not work out.  To avoid this, explicitly declare the stubbed
> is_tdp_mmu_root on 32-bit hosts.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index fabfea947e46..f6e0667cf4b6 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -85,12 +85,6 @@ bool kvm_mmu_init_tdp_mmu(struct kvm *kvm);
>  void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
>  static inline bool is_tdp_mmu_enabled(struct kvm *kvm) { return kvm->arch.tdp_mmu_enabled; }
>  static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return sp->tdp_mmu_page; }
> -#else
> -static inline bool kvm_mmu_init_tdp_mmu(struct kvm *kvm) { return false; }
> -static inline void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm) {}
> -static inline bool is_tdp_mmu_enabled(struct kvm *kvm) { return false; }
> -static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return false; }
> -#endif
>  static inline bool is_tdp_mmu_root(hpa_t hpa)
>  {
> @@ -105,5 +99,12 @@ static inline bool is_tdp_mmu_root(hpa_t hpa)
>         return is_tdp_mmu_page(sp) && sp->root_count;
>  }
> +#else
> +static inline bool kvm_mmu_init_tdp_mmu(struct kvm *kvm) { return false; }
> +static inline void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm) {}
> +static inline bool is_tdp_mmu_enabled(struct kvm *kvm) { return false; }
> +static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return false; }
> +static inline bool is_tdp_mmu_root(hpa_t hpa) { return false; }
> +#endif
>  #endif /* __KVM_X86_MMU_TDP_MMU_H */
> 
