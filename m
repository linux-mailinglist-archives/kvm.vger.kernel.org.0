Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B32D421D2E
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 06:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhJEETu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 00:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbhJEETt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Oct 2021 00:19:49 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5006C061745
        for <kvm@vger.kernel.org>; Mon,  4 Oct 2021 21:17:58 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id g198-20020a1c20cf000000b0030d60cd7fd6so1845543wmg.0
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 21:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ldiVl+t8mgo2eZZ+0dm/iKZs4c1YMS7niH0Ehzbu8P8=;
        b=mX/8MC1Z3q3+b/sqPIhdbqw5uqfmCrcEs76Vjy7QBZIqM4i8XiMoDonzMYsjNwBqRt
         MGCYZ+fOYXV0G2moWo6M81hLOqmdevrjwPTpPyw+lK/Rh34oGoJJ9IegpWjjKulNDfHb
         WxuRkFNzvP2V/gkY44cMNb3kUdQ7YbSURd0WyE3zqiFfVXRrD+5Bc3xRH/MLglpHdXaz
         TvDRVp+86tw3nVv7ORBVioPtWWrLnhnOsDSFK8bOlI1oPoMOPr8E1a5/YqUQFKkuFDxr
         pGiEvKmc/WdqOUrqd09M198BYxvYOQQ8uAOdp/tG7x2ffa1USwtXa6mp2UGGs8tI1ubN
         /e7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ldiVl+t8mgo2eZZ+0dm/iKZs4c1YMS7niH0Ehzbu8P8=;
        b=ZyBcjJaaX2+Fx39CKaiTR13TRFt1pzg71puI9IKpJblxvEHkn1rtGaM+TqTGxPAXaK
         b6Ihnanjv13vJIQ3EFPdgwYT0cws6qjYPzqQ4iEsgyfAD4alo9izINHU2P4dJKO6wcAE
         52PQlVt4I6Xuy53egXP/62KG99DSy2mzxGzfY7Zz2DzfLGqzC8RZ4x6GFQ6bBDfGJrt8
         e/UityXMsECQc3cE3FsHQOQHgGL1IG2PzjG9ffSH1jx2c9MEiQxZGkYZIpQ1+Kkj/Rgr
         dH0JiQwicT18KS6hN7y4IHGsS/v5RCF1kNagYvl17wL7nu/bC9pEFWjRM+vkJlPJ+s/L
         tKKA==
X-Gm-Message-State: AOAM530yE15fArEOfM3p1/CKY+jh9xWBRue4gKsX7/0eu0Ubokt3qyOR
        Rgtij0wz28G1bAPmzOI62SVjsILis7fOUidp7Z5Vxw==
X-Google-Smtp-Source: ABdhPJxkt8JmT/tN0OuEY7Eksq2Rbz+Wp8NmhOJfBsAYhp7hTnL8enb3dC/AOksH5NkA9S8xaMNtWDScMwV5ajpKJeA=
X-Received: by 2002:a7b:cb04:: with SMTP id u4mr986462wmj.176.1633407477436;
 Mon, 04 Oct 2021 21:17:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210927114016.1089328-1-anup.patel@wdc.com> <5cadb0b3-5e8f-110b-c6ed-4adaea033e58@redhat.com>
In-Reply-To: <5cadb0b3-5e8f-110b-c6ed-4adaea033e58@redhat.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 5 Oct 2021 09:47:46 +0530
Message-ID: <CAAhSdy2b-xHSQYhypo9=87mrf82B3Faficc6utW6E6XcYqV=JQ@mail.gmail.com>
Subject: Re: [PATCH v20 00/17] KVM RISC-V Support
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Anup Patel <anup.patel@wdc.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 4, 2021 at 2:28 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 27/09/21 13:39, Anup Patel wrote:
> > This series adds initial KVM RISC-V support. Currently, we are able to boot
> > Linux on RV64/RV32 Guest with multiple VCPUs.
> >
> > Key aspects of KVM RISC-V added by this series are:
> > 1. No RISC-V specific KVM IOCTL
> > 2. Loadable KVM RISC-V module supported
> > 3. Minimal possible KVM world-switch which touches only GPRs and few CSRs
> > 4. Both RV64 and RV32 host supported
> > 5. Full Guest/VM switch is done via vcpu_get/vcpu_put infrastructure
> > 6. KVM ONE_REG interface for VCPU register access from user-space
> > 7. PLIC emulation is done in user-space
> > 8. Timer and IPI emuation is done in-kernel
> > 9. Both Sv39x4 and Sv48x4 supported for RV64 host
> > 10. MMU notifiers supported
> > 11. Generic dirtylog supported
> > 12. FP lazy save/restore supported
> > 13. SBI v0.1 emulation for KVM Guest available
> > 14. Forward unhandled SBI calls to KVM userspace
> > 15. Hugepage support for Guest/VM
> > 16. IOEVENTFD support for Vhost
> >
> > Here's a brief TODO list which we will work upon after this series:
> > 1. KVM unit test support
> > 2. KVM selftest support
> > 3. SBI v0.3 emulation in-kernel
> > 4. In-kernel PMU virtualization
> > 5. In-kernel AIA irqchip support
> > 6. Nested virtualizaiton
> > 7. ..... and more .....
>
> Looks good, I prepared a tag "for-riscv" at
> https://git.kernel.org/pub/scm/virt/kvm/kvm.git.  Palmer can pull it and
> you can use it to send me a pull request.

Sure, I have prepared PR for the remaining 16 patches based on the
PATCH1 commit in the KVM tree.

I will send PR today or tomorrow.

>
> I look forward to the test support. :)  Would be nice to have selftest
> support already in 5.16, since there are a few arch-independent
> selftests that cover the hairy parts of the MMU.

I will try my best to send basic kvm-selftest support sooner (preferably
for 5.16).

Regards,
Anup
