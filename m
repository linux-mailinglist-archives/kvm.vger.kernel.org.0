Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9BD573782
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 15:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234672AbiGMNfT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 09:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234201AbiGMNfQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 09:35:16 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A085201A1;
        Wed, 13 Jul 2022 06:35:12 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id p129so19293515yba.7;
        Wed, 13 Jul 2022 06:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1jAT5Y354YkJw84h1P0PI0w1TxH9IevY3/tBtyCFWjk=;
        b=dh9XjpuO88cns/3aH1EgOF6kUYXzevYwYmFDL8w5uEnW8xDaPfFc6Xu8O9sxqU82Qi
         kWy0JdOcV6yWAeOc2QNAf7pp6Axw14QrJNcSk7EE/7EzZZgMpSLOTfoWziLJVSiECZpG
         YJFRa4r+EIOZR3oG+RyHyK4nqDtj+f2vYUSoNzQrrdpNKZsPKFL6uQmuhDYkmj5Jkq7i
         t/hslzaJY/qS3jEJF6XUU5QlmlvDXiPyKo/NN+gQdfFdzCCLm44+A+1f+rddJ1Fe40HZ
         qyV7QyWlCgnstQDoeZ4VKJAopbghBJ/Zf7hXGHIe3ciGY2nbIo7INSXG0tTZWV4FHkkO
         TTIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1jAT5Y354YkJw84h1P0PI0w1TxH9IevY3/tBtyCFWjk=;
        b=735QOxrSR2N+hdLt8O6yBMkAypFhmXBc2Sci2J4njAnsszpD95DxxblBwEoYzqbN6F
         yoniLuOfoD4pN5yebQ5joqqJreAOIC5xgty1wGATQ7XUS8XHrJ2LcYsc1oNnzic4Apx2
         jyegvy/9sA8VfMHJvXq0QEBHVqIfEETbKkPY4rqO/3XGAiMzpCJcOFQz+VPpdoc8FNRL
         gEFWhtqsn9y3digeGKWmxt8+Zr40L1y0VWU8VkURuRfSuKH5GNcv2xf5lyP8cFxzCcVA
         9LjzCbRpytgDAVXHJRtXAQGb0XTLrNrJ0YXf2NzRwJGchYJPyrxByg7pqlELnYVWIiYd
         yQbg==
X-Gm-Message-State: AJIora8bgFQXa+bbi0hRgMSkqIZ7bFS2KBvOEreoIGPCVbxX7xHgINjP
        InNSy28v0U0H2AX0t7tOdXBEZfw1KvgiIvLKt7FJGdi6gYE=
X-Google-Smtp-Source: AGRyM1sjtw6rsqcZfxRlukEyESkBV6p43H1uEV0wEVveC9SL7eaF9iF/13N3A+SMwKPorR+oCRgpL1D5uQIOzsD4GUM=
X-Received: by 2002:a5b:20d:0:b0:66e:3b19:82c5 with SMTP id
 z13-20020a5b020d000000b0066e3b1982c5mr3819369ybl.517.1657719311574; Wed, 13
 Jul 2022 06:35:11 -0700 (PDT)
MIME-Version: 1.0
References: <Ys6sZj6KYthnDppq@debian> <Ys6t+q4/y4DTjLQh@hirez.programming.kicks-ass.net>
 <Ys646XwC8SorCogQ@hirez.programming.kicks-ass.net>
In-Reply-To: <Ys646XwC8SorCogQ@hirez.programming.kicks-ass.net>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Wed, 13 Jul 2022 14:34:35 +0100
Message-ID: <CADVatmNrdRJB+xcGSOdCf86ZuTrUATnpOhxSeA5HkUR9RT89+A@mail.gmail.com>
Subject: Re: mainline build failure due to fc02735b14ff ("KVM: VMX: Prevent
 guest RSB poisoning attacks with eIBRS")
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>, Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 13, 2022 at 1:22 PM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Wed, Jul 13, 2022 at 01:35:22PM +0200, Peter Zijlstra wrote:
> > On Wed, Jul 13, 2022 at 12:28:38PM +0100, Sudip Mukherjee (Codethink) wrote:
> > > Hi All,
> > >
> > > The latest mainline kernel branch fails to build for x86_64 allmodconfig
> > > with clang and the error is:
> > >

<snip>

> >  extern u64 spec_ctrl_current(void);
> >
>
> I hate headers...

very short commit message :D

>
> ---
> diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
> index bb05ed4f46bd..cbc3b8348939 100644
> --- a/arch/x86/include/asm/nospec-branch.h
> +++ b/arch/x86/include/asm/nospec-branch.h
> @@ -280,7 +280,6 @@ static inline void indirect_branch_prediction_barrier(void)
>
>  /* The Intel SPEC CTRL MSR base value cache */
>  extern u64 x86_spec_ctrl_base;
> -extern u64 x86_spec_ctrl_current;
>  extern void write_spec_ctrl_current(u64 val, bool force);
>  extern u64 spec_ctrl_current(void);
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index be7c19374fdd..b64512978534 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6831,6 +6831,8 @@ void noinstr vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
>         }
>  }
>
> +DECLARE_PER_CPU(u64, x86_spec_ctrl_current);
> +
>  void noinstr vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx,
>                                         unsigned int flags)
>  {

The build failure is fixed with this change. Thanks.


-- 
Regards
Sudip
