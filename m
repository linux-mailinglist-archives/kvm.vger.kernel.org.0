Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2B454E823
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 18:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233441AbiFPQxf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 12:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378240AbiFPQsV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 12:48:21 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C426620194
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 09:47:41 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id s6so3053881lfo.13
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 09:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ma+cQgxf4eaYFFNkDorw41RhIratRGMLiSnvn0U+ZYI=;
        b=rSekvEmNvj6W2U+61h2xi2LHRNXk7NFne+/XF8MTBVA/dLaHuCQPklth1kBkFA+WGw
         IXm92gGMZAf2tSEOXVZAnsPWqQlv6x0OLzMdZ6F0XyIsn+e4dNrmCo5W6DMsK7IWWDI2
         VofO56DT68LiDTwWFf/e9WFb75csGGLBXDXnh+g42tZFmq+5jDra37r026DuydlxnW61
         e3/KkG74R6jwN3a3bPc6vw7JyT5Tb31NdKC9HSkUC9k/Xz3F/6h33TMykeM7mqF9/a5u
         oJBW5TcBpPzsIvQMxNgGt0dtovHqAL5gKl6XpF5HalCydMvC5dE2P2mVNR3Lc7I+T3fb
         dfpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ma+cQgxf4eaYFFNkDorw41RhIratRGMLiSnvn0U+ZYI=;
        b=YDUkR6RCPzpVj/wGvUywQ7cYfwGqtUvaVOINw4xTGqdknfByAc0UjXMq6BojqDqKN9
         theAQhbgo0+4MYdxTl7oo/fDE86dCdNSTrb9mC4UC4ivibQAtzHG/YMTWgX+YL+v/NTG
         c0LXmoFgEqGGYcrcFHnt9KwpsiFnZfpq1vU7UVzrqMQguwBLkIf5XMPqYsshT51J7tIC
         +VgpH4i63yaiRZf6zN3eN615TFcNUbv1nPGEmhodE70fkcWSOkRLifC8NWAT2N5uVvxB
         yH6uYcmdpsCR2aTblsUos/LRUiT3y9InhaJOY3IzeuyxL0EAIqrtI9aeBnmK0NC44Gp9
         Vu2Q==
X-Gm-Message-State: AJIora8++KYtAp8zjM6D3Mvwil9pApHZ7/hZU5xD0+BGghNchyHXD3HB
        GhWxnZwWrO9EBF1/+F1sE9HndItOYyow+7Ky2VhoTA==
X-Google-Smtp-Source: AGRyM1t2wXiSqrp+/hCsncfT7hZVQUaXE+aX/b80uh35Ci0QwSm1VxZlUHpOtCbANAJ7fxBPOZRLFJupOCDM2AW34kA=
X-Received: by 2002:a05:6512:220f:b0:479:65e1:c802 with SMTP id
 h15-20020a056512220f00b0047965e1c802mr3239500lfu.250.1655398059857; Thu, 16
 Jun 2022 09:47:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220613145022.183105-1-kyle.meyer@hpe.com> <CALzav=eWPiii4_zmYifdi_pSS6nUvMEchwQcvD+W2CfOR+-s8Q@mail.gmail.com>
 <8735g7k5u2.fsf@redhat.com>
In-Reply-To: <8735g7k5u2.fsf@redhat.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 16 Jun 2022 09:47:13 -0700
Message-ID: <CALzav=fjvO0csAV5onsdXijDnvYJNMccoNHKPiraU6tHhCURuQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Increase KVM_MAX_VCPUS to 2048
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Kyle Meyer <kyle.meyer@hpe.com>, kvm list <kvm@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, russ.anderson@hpe.com,
        payton@hpe.com, "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 14, 2022 at 1:28 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> David Matlack <dmatlack@google.com> writes:
>
> > On Mon, Jun 13, 2022 at 11:35 AM Kyle Meyer <kyle.meyer@hpe.com> wrote:
> >>
> >> Increase KVM_MAX_VCPUS to 2048 so we can run larger virtual machines.
> >
> > Does the host machine have 2048 CPUs (or more) as well in your usecase?
> >
> > I'm wondering if it makes sense to start configuring KVM_MAX_VCPUS
> > based on NR_CPUS. That way KVM can scale up on large machines without
> > using more memory on small machines.
> >
> > e.g.
> >
> > /* Provide backwards compatibility. */
> > #if NR_CPUS < 1024
> >   #define KVM_MAX_VCPUS 1024
> > #else
> >   #define KVM_MAX_VCPUS NR_CPUS
> > #endif
> >
> > The only downside I can see for this approach is if you are trying to
> > kick the tires a new large VM on a smaller host because the new "large
> > host" hardware hasn't landed yet.

Heh. My point here doesn't make sense. The actual number of CPUs in
the host machine wouldn't matter, just the host kernel's NR_CPUS.

>
> FWIW, while I don't think there's anything wrong with such approach, it
> won't help much distro kernels which are not recompiled to meet the
> needs of a particular host.

But is there a use-case for running a VM with more vCPUs than the
kernel's NR_CPUS?


> According to Kyle's numbers, the biggest
> growth is observed with 'struct kvm_ioapic' and that's only because of
> 'struct rtc_status' embedded in it. Maybe it's possible to use something
> different from a KVM_MAX_VCPU_IDS-bound flat bitmask there? I'm not sure
> how important this is as it's just another 4K per-VM and when guest's
> memory is taken into account it's probably not much.
>
> The growth in 'struct kvm'/'struct kvm_arch' seems to be insignificant
> and on-stack allocations are probably OK.
>
> --
> Vitaly
>
