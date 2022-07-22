Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8753A57EA6B
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 01:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236452AbiGVXuA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 19:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234919AbiGVXt5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 19:49:57 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FEB3C06CD
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 16:49:57 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d7so5762845plr.9
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 16:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Js8QiHziuijv16DRJ7w1nD2pqN06FjnDg+o72AhTw7U=;
        b=Z/PsvRcva+XJA2wurOimE48Wl7e0nVz5oMMjsc8l4n3+ulY8DO4ktwqBb//eRIfF5p
         wQqrhbO6J2Qc7WZk+LIo5dK5m99ez4e7sLE3n2pVauMy2SuNNou919nStktsCtyCkoCd
         HtY8eVBtpm1nOxyCgD0RfxZS8vwznn8pBmAAwYhB6vCaPjrSrgncRD7JtN14Zp/AMvOv
         J3Os05/WX9QbK37nsiBYaOpZ+/XkxsPmNUFQOVbEgvOFkUcsZDK67fR12wuN9/gIpmGI
         7ybvtBBcCziahUaQh6zkWkSzveq5typOBWsZbCLaRLT7MuZE3mQJLPtSMO8V539Lw3dt
         tnVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Js8QiHziuijv16DRJ7w1nD2pqN06FjnDg+o72AhTw7U=;
        b=j+p0nAelc+w+NiK9OKYOUZIIACswb/K3L1DbjTv11nav/h+ZugxE1I0jShQDbF4Hfc
         r6JSfo8QMFyOcapcr/29R2H5JKMhscLgKa1BB98yKCpmoifDoEW7+/66BK9xCKoMMWIf
         dI67EFOI4EUCRMwoFjHFjGzSKo3UoLfifYTzdpUtuHhZ193tDgZUFNra4LhQGmUxkNg0
         REvABWU8h2HEhlPnw0dxFF8eiTW689WNnY7HoYFxsKGXPYM+y1OOoq8BftydGDz4237P
         /ZED+pGD2mTzxcuF1WYxJoQSNnpjhOx21njE/ERzEJC3XwwQihWax7jEciJ3U1ua4NrO
         R4AA==
X-Gm-Message-State: AJIora/oXbeh2SRiDmi4KVak0xTnn8DT2hu69e+9hijmZ15C8QiNR8+3
        gwfSoZwqUxqa0CHgWdD3H0Ebkg==
X-Google-Smtp-Source: AGRyM1tmKNy7nzqxvFM1gB8002n04gH5GT6VKAbb/8qhEYzXEK0Ko8Vq8df5/cSbVs8wpSINzu/8FA==
X-Received: by 2002:a17:90b:3b51:b0:1f0:5ebc:ac9 with SMTP id ot17-20020a17090b3b5100b001f05ebc0ac9mr2108057pjb.229.1658533796497;
        Fri, 22 Jul 2022 16:49:56 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id b4-20020a62cf04000000b0052ab92772a0sm4618191pfg.98.2022.07.22.16.49.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 16:49:56 -0700 (PDT)
Date:   Fri, 22 Jul 2022 23:49:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     kernel test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: Re: [kvm:queue 23/35] arch/x86/kvm/mmu/mmu.c:6391:19: warning:
 variable 'pfn' set but not used
Message-ID: <Yts3oLhqJ2SNGurV@google.com>
References: <202207230706.VfX9Ycxh-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202207230706.VfX9Ycxh-lkp@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jul 23, 2022, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
> head:   1a4d88a361af4f2e91861d632c6a1fe87a9665c2
> commit: fe631a46409403616aa0c28c2c16cae7f7c92b1e [23/35] KVM: x86/mmu: Don't require refcounted "struct page" to create huge SPTEs
> config: x86_64-randconfig-a015 (https://download.01.org/0day-ci/archive/20220723/202207230706.VfX9Ycxh-lkp@intel.com/config)
> compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
> reproduce (this is a W=1 build):
>         # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=fe631a46409403616aa0c28c2c16cae7f7c92b1e
>         git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.git
>         git fetch --no-tags kvm queue
>         git checkout fe631a46409403616aa0c28c2c16cae7f7c92b1e
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash arch/x86/kvm/
> 
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
>    arch/x86/kvm/mmu/mmu.c: In function 'kvm_mmu_zap_collapsible_spte':
> >> arch/x86/kvm/mmu/mmu.c:6391:19: warning: variable 'pfn' set but not used [-Wunused-but-set-variable]
>     6391 |         kvm_pfn_t pfn;
>          |                   ^~~
> 
> 
> vim +/pfn +6391 arch/x86/kvm/mmu/mmu.c
> 
> a3fe5dbda0a4bb arch/x86/kvm/mmu/mmu.c David Matlack       2022-01-19  6383  
> 3ea3b7fa9af067 arch/x86/kvm/mmu.c     Wanpeng Li          2015-04-03  6384  static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
> 0a234f5dd06582 arch/x86/kvm/mmu/mmu.c Sean Christopherson 2021-02-12  6385  					 struct kvm_rmap_head *rmap_head,
> 269e9552d20817 arch/x86/kvm/mmu/mmu.c Hamza Mahfooz       2021-07-12  6386  					 const struct kvm_memory_slot *slot)
> 3ea3b7fa9af067 arch/x86/kvm/mmu.c     Wanpeng Li          2015-04-03  6387  {
> 3ea3b7fa9af067 arch/x86/kvm/mmu.c     Wanpeng Li          2015-04-03  6388  	u64 *sptep;
> 3ea3b7fa9af067 arch/x86/kvm/mmu.c     Wanpeng Li          2015-04-03  6389  	struct rmap_iterator iter;
> 3ea3b7fa9af067 arch/x86/kvm/mmu.c     Wanpeng Li          2015-04-03  6390  	int need_tlb_flush = 0;
> ba049e93aef7e8 arch/x86/kvm/mmu.c     Dan Williams        2016-01-15 @6391  	kvm_pfn_t pfn;
> 3ea3b7fa9af067 arch/x86/kvm/mmu.c     Wanpeng Li          2015-04-03  6392  	struct kvm_mmu_page *sp;
> 3ea3b7fa9af067 arch/x86/kvm/mmu.c     Wanpeng Li          2015-04-03  6393  
> 0d5367900a319a arch/x86/kvm/mmu.c     Xiao Guangrong      2015-05-13  6394  restart:
> 018aabb56d6109 arch/x86/kvm/mmu.c     Takuya Yoshikawa    2015-11-20  6395  	for_each_rmap_spte(rmap_head, &iter, sptep) {
> 573546820b792e arch/x86/kvm/mmu/mmu.c Sean Christopherson 2020-06-22  6396  		sp = sptep_to_sp(sptep);
> 3ea3b7fa9af067 arch/x86/kvm/mmu.c     Wanpeng Li          2015-04-03  6397  		pfn = spte_to_pfn(*sptep);

Dagnabbit, I caught the TDP MMU case where "pfn" was completely unused, but not
this one.  I'll send a fixup/follow-up.
