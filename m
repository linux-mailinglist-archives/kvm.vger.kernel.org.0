Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 569684ED3FD
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 08:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbiCaGiz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 02:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiCaGiy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 02:38:54 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC58103DBC
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 23:37:07 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id m3so39681192lfj.11
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 23:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+AnTQEfUPZso3bsfDtx1jHrDQyOsSxuvg5kE43dRswM=;
        b=Dgyco3ciHGnnMb3HExWdSMpKfMnqnuidkqvevTjoXK+luZ1uYhBqJhE5s7r0ydQ7zM
         asv08bIz4XXhiFuIeEqLsmyI3PRmRjENFaXS1ydU6BhCCJswb2RvYBWhBnpw/SgG2dAa
         IGr6mBxiNrGbYBtG41yFUpn/GlQ0CSG2VFBNzxCE1WmO8lf5OXl4SXTNgVP6Qwd8DBzd
         ltSGG5g0BMwZQNmYrw2ktUAatAwdn35KNXL7WYppV2z5SZLu2xO/rn5CzcL6bT3NFSL3
         xgQ9K4N9Q5Dk7QOuQmP2JfYPC28p1AgVeDBGtYghgOhEfwp7baVM+o0Qg7n3t6MX22xI
         zjHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+AnTQEfUPZso3bsfDtx1jHrDQyOsSxuvg5kE43dRswM=;
        b=1LBMLzZKeJlNtBT+9ToNHiSTFJpv4YrDFgnZ5PHIlII0VYxnn7uf/ogNqn6VjT31Ig
         9UuTtCxHA9QhOpeg2txONV19aSgSmATOll4sXArsokAkpSr/hy5mM3D5j3jZw1oPur9m
         X7O/WlHaV8ycvb1vH9A+2b8UvBaH6j4bCokDhQptjHcTVliJGtI0QoqRwGWGX6hMV+2q
         1o0jRvjo4pX9FfKj/+aFwUM40ne9PCwgBtN8ZSe0d1kS4JIOXPVSUGXB9TRP7lABltK2
         bRsKbgS+ttSOUDDeqiLA+FcYalyLrTRHsQQjyjo2nAm5IuGd6PbNher87C1lVEgZ6OR8
         sEoA==
X-Gm-Message-State: AOAM531Zq9I3ne7sIxY+JVvFW4o3iiH7yJO59fLCS+cYM3CAzjHfdQwG
        TrmDekr8wAtRJpTnRcv3PpvwZAZVAYW5+biI4/ceWg==
X-Google-Smtp-Source: ABdhPJxRPUYU3UNn8baHe79ewvSRzeq8bVgURfPJEYp9tpm+c3wy3szPut7BNfDD0nw5wbXcJS/NCSaVCQ0vzFXs7X4=
X-Received: by 2002:a05:6512:e89:b0:44a:86e0:2294 with SMTP id
 bi9-20020a0565120e8900b0044a86e02294mr9948388lfb.130.1648708624442; Wed, 30
 Mar 2022 23:37:04 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.DEB.2.22.394.2203162205550.3177@hadrien>
In-Reply-To: <alpine.DEB.2.22.394.2203162205550.3177@hadrien>
From:   Anup Patel <apatel@ventanamicro.com>
Date:   Thu, 31 Mar 2022 12:06:51 +0530
Message-ID: <CAK9=C2XYp5a2diGNLf8=a05uPP-gAmUodtMbDWrByiW9skjjmA@mail.gmail.com>
Subject: Re: question about arch/riscv/kvm/mmu.c
To:     Julia Lawall <julia.lawall@inria.fr>
Cc:     kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Anup Patel <anup@brainfault.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 17, 2022 at 2:40 AM Julia Lawall <julia.lawall@inria.fr> wrote:
>
> Hello,
>
> The function kvm_riscv_stage2_map contains the code:
>
> mmu_seq = kvm->mmu_notifier_seq;
>
> I noticed that in every other place in the kernel where the
> mmu_notifier_seq field is read, there is a read barrier after it.  Is
> there some reason why it is not necessary here?

When I did the initial porting of KVM RISC-V (2 years back), I did
not see such a barrier being used along with mmu_notifier_seq
field hence the current code.

I am certainly okay adding it to be consistent with other architectures.

Can you send a patch for this ?

Thanks,
Anup

>
> thanks,
> julia
>
> --
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv
