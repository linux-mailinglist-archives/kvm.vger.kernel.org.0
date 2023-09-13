Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C18E79EE1E
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 18:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbjIMQQX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 12:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbjIMQQR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 12:16:17 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7EA1B8
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 09:16:13 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-594e5e2e608so79275487b3.2
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 09:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694621773; x=1695226573; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4JiE4DdxUMHfTS70Z4Y1GxX9A0Rg/BgOzVpxxMDofuU=;
        b=d5lG24biiIxs2IX1D6Eb6aMsY6oZ5Ztz3fYvlSNYYKUXz+ljPtrdPKx1TCuu8Alu0z
         /OrmlbfOQn2BailNLtXXvuuR5Hkc5+ydkv/wMJl35PktEUnlGuh8CGzMryhvKCrcQuJF
         O1BUm3tN8b+KC4m1g0du+ZhfPQNaL/K93iAWKbWCJym1Pgmqx3GXwGQhPPb/sUyMJAKy
         UQmTb4cIj65UZvLGrIKxmvfFlW+x8tU5tdJpxgl14y6piBP3kSHqq0cRcrG36RaJO8fK
         AmpeqNIWU3XYOyB44D8bt5ioxJjPQtYSHpASnIh+WYXrKRo7b9qqK+K4lC8w/55V14+m
         z1Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694621773; x=1695226573;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4JiE4DdxUMHfTS70Z4Y1GxX9A0Rg/BgOzVpxxMDofuU=;
        b=Q0G8kLJBSkUwN1f9xNP+VwJRtJ0dy9sqC+PJ+Y69HPq+VsPYCbuWRt/u95dXqfb4kX
         riacB45ryyI5DiMz9G1AaItcQZ/YNAdwGhETb8nwC7eYxa+JMJOQhuNpSJtWYtpTNxdd
         /rViLjWyywHccHvBq6xg9m7Lh0HzrtwCIWyZBC+6htobJ/AXqw0jYP5SM0IBZfrxN+iM
         FkpokeTZlnlkLp2vV1eSgRTBO+euC39Jj+7Ay2ZOlhU66607s/8d55QBrxSFX/XbDMyS
         GRETVto2Lj3mIHrogA7tDqDgbvpkDva2/nGCWsZBCAA8ttyBidVU3AgsIiJETWmJBFoC
         x9VA==
X-Gm-Message-State: AOJu0Yy278eVqU6rk0bqzwdA49k02c9PWbwFOD8peVU9gFH2neAngjKP
        bZaZn6Lahvl4zUFlBTH4uiItGLCk77I=
X-Google-Smtp-Source: AGHT+IHPHKf4QXfFQhCv9rVUa7JrPB8sTnwxipNESGJoGValFttp6Gj7lD6PQrORyTMLg/nP1eKBYhCE38I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b71e:0:b0:583:4f82:b9d9 with SMTP id
 v30-20020a81b71e000000b005834f82b9d9mr84623ywh.5.1694621772950; Wed, 13 Sep
 2023 09:16:12 -0700 (PDT)
Date:   Wed, 13 Sep 2023 09:16:11 -0700
In-Reply-To: <56cd2f6f42351f2f27a07e5764bab7f689cc0059.1694599703.git.isaku.yamahata@intel.com>
Mime-Version: 1.0
References: <cover.1694599703.git.isaku.yamahata@intel.com> <56cd2f6f42351f2f27a07e5764bab7f689cc0059.1694599703.git.isaku.yamahata@intel.com>
Message-ID: <ZQHgS13+QBChjYNw@google.com>
Subject: Re: [RFC PATCH 1/6] KVM: guest_memfd: Add config to show the
 capability to handle error page
From:   Sean Christopherson <seanjc@google.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Xu Yilun <yilun.xu@intel.com>,
        Quentin Perret <qperret@google.com>, wei.w.wang@intel.com,
        Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 13, 2023, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Add config, HAVE_GENERIC_PRIVATE_MEM_HANDLE_ERROR, to indicate kvm arch
> can handle gmem error page.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  virt/kvm/Kconfig     | 3 +++
>  virt/kvm/guest_mem.c | 3 +++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 1a48cb530092..624df45baff0 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -112,3 +112,6 @@ config KVM_GENERIC_PRIVATE_MEM
>         select KVM_GENERIC_MEMORY_ATTRIBUTES
>         select KVM_PRIVATE_MEM
>         bool
> +
> +config HAVE_GENERIC_PRIVATE_MEM_HANDLE_ERROR
> +	bool
> diff --git a/virt/kvm/guest_mem.c b/virt/kvm/guest_mem.c
> index 85903c32163f..35d8f03e7937 100644
> --- a/virt/kvm/guest_mem.c
> +++ b/virt/kvm/guest_mem.c
> @@ -307,6 +307,9 @@ static int kvm_gmem_error_page(struct address_space *mapping, struct page *page)
>  	pgoff_t start, end;
>  	gfn_t gfn;
>  
> +	if (!IS_ENABLED(CONFIG_HAVE_GENERIC_PRIVATE_MEM_HANDLE_ERROR))
> +		return MF_IGNORED;

I don't see the point, KVM can and should always zap SPTEs, i.e. can force the
geust to re-fault on the affected memory.  At that point kvm_gmem_get_pfn() will
return -EHWPOISON and architectures that don't support graceful recovery can
simply terminate the VM.
