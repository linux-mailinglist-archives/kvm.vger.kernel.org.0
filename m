Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA5804C7D39
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 23:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbiB1WXE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 17:23:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbiB1WXC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 17:23:02 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B4F855BD1
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 14:22:23 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id d10so27702447eje.10
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 14:22:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WcgYqHBBOWbueB0Fsjd5eUaC1NU5WnaGHWt3Uee30NI=;
        b=KYt1K1Jx2L6voa6GU07qVfXechSDb2mLanaNKHRTjyqEXgFE9PKAoFACZofXoCPI8G
         QZFmcDvrg90GxhB1jY3c6O+8OYG1CEBzVpRh5Awh4Zx7jXoa2saQ8fOUq3I5zLlEeBhG
         ubKb45uchZbz/dr9a05PbHRO9tKLijOyLbPFwFAMpCKd7wcSUJ46oV/CZMmiMpH9cA5r
         DT+QdKixm3EMjwD1Bn4JC3WoP3oH9nEp4ekSxW+iVktZqbRthDa61QsijDN6XHHCtD7E
         LxGLi2uFHaNjGpC1bN+V+wUDoCTAJ1avbLwQeOvU374T2iXZp0xEz6wWb7kUXmna4ZO2
         duAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WcgYqHBBOWbueB0Fsjd5eUaC1NU5WnaGHWt3Uee30NI=;
        b=mmUG3CVEgU2kM++Ra04/htTYFQ7v+/X2u9E7pI3YabfgnkoC6mUMxCwUzehBOEhZcu
         2e06LptcOdq8rPxsdGNvMGUWDpbwp/M+oK7OkGCFChTVHrSiWhvr5Zqo332XSphisxN/
         2/HUgfK+ZIFASfHZ2ov6GKxP+3j1AkKp3Yx8I4CK68/E+la6/v6eoYwx6XbSNKcfFXmz
         rJrG1YvACtOdPJ7/SuJosqC8z1zAr//6l9Wxwr1gOoLgm2S8hEFoi4oUWYYdE9GW7xIb
         15UsZq2/Wu4cc01kdmyJUZ7jOGWVNs3bnsjvv0pI63jbf/GRzk3ghUK7h9xlqomryObR
         v0Kw==
X-Gm-Message-State: AOAM533QkLonIfbSEproKjfIFvEOFMETHJ65vEPClUbJ/My7Fya+MU8f
        C+cNkDauuf9py+rzxd4y81YA4X6VAGFoIgDZMJXJqA==
X-Google-Smtp-Source: ABdhPJzG0297DBQ5+SxCvd2F7jAol+DJfAm+LDqNBC40put8N/ojjvgl4jwS2L2L59KvTJIZOJ5ivyvjTNPAdIOGjqA=
X-Received: by 2002:a17:906:eda9:b0:6ce:e24e:7b95 with SMTP id
 sa9-20020a170906eda900b006cee24e7b95mr16966410ejb.314.1646086941618; Mon, 28
 Feb 2022 14:22:21 -0800 (PST)
MIME-Version: 1.0
References: <20220225182248.3812651-1-seanjc@google.com> <20220225182248.3812651-7-seanjc@google.com>
In-Reply-To: <20220225182248.3812651-7-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 28 Feb 2022 14:22:10 -0800
Message-ID: <CANgfPd83Q04bOXFsuTy0p1=bLMGXMJBEpcQmxFguCms=pNLtWg@mail.gmail.com>
Subject: Re: [PATCH v2 6/7] KVM: Drop KVM_REQ_MMU_RELOAD and update
 vcpu-requests.rst documentation
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 25, 2022 at 10:23 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Remove the now unused KVM_REQ_MMU_RELOAD, shift KVM_REQ_VM_DEAD into the
> unoccupied space, and update vcpu-requests.rst, which was missing an
> entry for KVM_REQ_VM_DEAD.  Switching KVM_REQ_VM_DEAD to entry '1' also
> fixes the stale comment about bits 4-7 being reserved.
>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  Documentation/virt/kvm/vcpu-requests.rst | 7 +++----
>  include/linux/kvm_host.h                 | 3 +--
>  2 files changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/Documentation/virt/kvm/vcpu-requests.rst b/Documentation/virt/kvm/vcpu-requests.rst
> index ad2915ef7020..b61d48aec36c 100644
> --- a/Documentation/virt/kvm/vcpu-requests.rst
> +++ b/Documentation/virt/kvm/vcpu-requests.rst
> @@ -112,11 +112,10 @@ KVM_REQ_TLB_FLUSH
>    choose to use the common kvm_flush_remote_tlbs() implementation will
>    need to handle this VCPU request.
>
> -KVM_REQ_MMU_RELOAD
> +KVM_REQ_VM_DEAD
>
> -  When shadow page tables are used and memory slots are removed it's
> -  necessary to inform each VCPU to completely refresh the tables.  This
> -  request is used for that.
> +  This request informs all VCPUs that the VM is dead and unusable, e.g. due to
> +  fatal error or because the VM's state has been intentionally destroyed.
>
>  KVM_REQ_UNBLOCK
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 0aeb47cffd43..9536ffa0473b 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -153,10 +153,9 @@ static inline bool is_error_page(struct page *page)
>   * Bits 4-7 are reserved for more arch-independent bits.
>   */
>  #define KVM_REQ_TLB_FLUSH         (0 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> -#define KVM_REQ_MMU_RELOAD        (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> +#define KVM_REQ_VM_DEAD           (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>  #define KVM_REQ_UNBLOCK           2
>  #define KVM_REQ_UNHALT            3
> -#define KVM_REQ_VM_DEAD           (4 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>  #define KVM_REQ_GPC_INVALIDATE    (5 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>  #define KVM_REQUEST_ARCH_BASE     8
>
> --
> 2.35.1.574.g5d30c73bfb-goog
>
