Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5832152B17F
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 06:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbiERE1r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 00:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbiERE1p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 00:27:45 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6CCC33A2B
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 21:27:43 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id q2so821009vsr.5
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 21:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fN13pJNCQ7oz0V1a6VyLZjsh0STVPMddJluiS+KeExg=;
        b=WlCChO47c3vDXVCIaGjEVf7IsHZmcxFElzELAX1bTuklI1SJiAii02Y+KhlrHFYMcA
         l0FGFrztHSYpPDGyy8kQ0dO9s3cgF74xrLRcYkXkB5ZXX/jTXS7V/UDH7LpMNoDMUPVD
         +IVOB9LKz5YDLy8a4J3vZUgYFMrDyjbzf5KnnkUX+cIiOSx8TN2bGVFRqcPlaI5YU8/G
         rkJe32cp1+sc8NasjculNggoEIyDRikxGBiYx74LLl/kly1+2tWIx7radm01VM8Yst9i
         HbZ55rTzMDRwqwJ78PMAr5E01gN87P8l+IR8Ie0RqJTnApjh0O4Tqm+p/NhW4DmQnqos
         BTTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fN13pJNCQ7oz0V1a6VyLZjsh0STVPMddJluiS+KeExg=;
        b=cDJ8wMxh2lCT6x+vPxOEae1y0bJUuIsRvBDNGSrPNsY54rXt698Dygyp8ZftqieWGQ
         xAa2+LzFVwW9K0YdRYdma0mG6jPtT40FQTN3oRCwanAyWYoXeZ61IcZw867Fsk1A/X4c
         hMgJcIHJL1VUvHlv2fjvUR0j6oPAMqGPR0NVtJzNp3keosN2JaNkVMhwD1UVnl4Pd/vP
         lOP75sj44QTXRXNuDTT8XgfTWfrOIehUJPA+bmNk6TMizqP4/Ql4fqz0tUgYNgrV3IuN
         t7TCyFvCdryD5Q3g7vkLkMR54GeqkMAooVnsVO9mPbsbXAuev5EO88I/6WKHLJn+WrU0
         kxzg==
X-Gm-Message-State: AOAM533raVMEtuyLVebnoOEjc7h3UhE++5Oaqvvws0YID/0FBaGtMQNE
        a+jOUNqy0sn7mfChPg+rMqOHfT0QMCcwB4dKE9Iamg==
X-Google-Smtp-Source: ABdhPJyzw43sJvn/BjBJ4J3dd+xIY/MZ8OmiSF0fwCF8JKQdEJrryLQyhDsSb7VIBjOrszsdKaAZ80vl8prxdgu+JEo=
X-Received: by 2002:a67:db95:0:b0:335:cd7c:6e9 with SMTP id
 f21-20020a67db95000000b00335cd7c06e9mr1726746vsk.41.1652848062686; Tue, 17
 May 2022 21:27:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220412195846.3692374-1-zhanwei@google.com> <YnmqgFkhqWklrQIw@google.com>
 <CAN86XOYNpzEUN0aL9g=_GQFz5zdXX9Pvcs_TDmBVyJZDTfXREg@mail.gmail.com>
 <YnwRld0aH8489+XQ@google.com> <CAN86XOZdW7aZXhSU2=gP5TrRQc8wLmtTQui0J2kwhchp2pnbeQ@mail.gmail.com>
In-Reply-To: <CAN86XOZdW7aZXhSU2=gP5TrRQc8wLmtTQui0J2kwhchp2pnbeQ@mail.gmail.com>
From:   Suleiman Souhlal <suleiman@google.com>
Date:   Wed, 18 May 2022 13:27:30 +0900
Message-ID: <CABCjUKCCc2irAnJrGWfKAnXJj-pb=YNL4F0uAEr-c0LMX22_hw@mail.gmail.com>
Subject: Re: [PATCH 0/2] KVM: x86: Fix incorrect VM-exit profiling
To:     Wei Zhang <zhanwei@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Sangwhan Moon <sxm@google.com>, Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Jing Zhang <jingzhangos@google.com>,
        David Matlack <dmatlack@google.com>
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

On Tue, May 17, 2022 at 4:30 AM Wei Zhang <zhanwei@google.com> wrote:
>
> > Please don't top-post.  From https://people.kernel.org/tglx/notes-about-netiquette:
>
> Ah, I didn't know this should be avoided. Thanks for the info!
>
> > My preference would be to find a more complete, KVM-specific solution.  The
> > profiling stuff seems like it's a dead end, i.e. will always be flawed in some
> > way.  If this cleanup didn't require a new hypercall then I wouldn't care, but
> > I don't love having to extend KVM's guest/host ABI for something that ideally
> > will become obsolete sooner than later.
>
> I also feel that adding a new hypercall is too much here. A
> KVM-specific solution is definitely better, and the eBPF based
> approach you mentioned sounds like the ultimate solution (at least for
> inspecting exit reasons).
>
> +Suleiman What do you think? The on-going work Sean described sounds
> promising, perhaps we should put this patch aside for the time being.

I'm ok with that.
That said, the advantage of the current solution is that it already
exists and is very easy to use, by anyone, without having to write any
code. The proposed solution doesn't sound like it will be as easy.

Regarding the earlier question about wanting to know which
instructions trigger exits, most times I've needed to get exit
profiles, I actually wanted to know where the guest was at the time of
the exit, regardless of who triggered the exit.

-- Suleiman
