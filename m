Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E543655138B
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 11:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239573AbiFTI7w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 04:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238018AbiFTI7v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 04:59:51 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448F3DEAE
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 01:59:49 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id l2-20020a05600c4f0200b0039c55c50482so7422361wmq.0
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 01:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UhbqiV0Ln/z8uccUqeNX/XfJm8bU+4E6XGmgA7WoQZ4=;
        b=1nFPBdzSAp7vUSAKAIEYwUqVfc1EngKszrSD5daAJJS9L/gUzz3co+QVs7DjWHb8NL
         OyVi7JeMaZpDTMmCZ9fDCRja2ouJ7BylDdBFmJ/W7OEdBQrno/Arq6liGahflLYGi43T
         QgKGiYwBQ7+H6+UwOtXf9yISqC+1oTEtRToF9R+XA/eRr/Yb2dW+S0FIAJjNihsNiWNA
         ebxH9lvVxxL9z+412j7l6tJko1BTnAIwEzXrmx30bjnHpONrZcLI29QuB2WAxFoBVIkk
         0QaEJ2U6zVlTwOvjRoPiN6ZQs1SrN6TWhSoZz9gbuJa533tlxc6yt9fwJvZQnobB1ePm
         vhIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UhbqiV0Ln/z8uccUqeNX/XfJm8bU+4E6XGmgA7WoQZ4=;
        b=TMo8uTyQerIIp9MK3p3UMAOp7zN8Q7zc48aRl92cDqQ2NA66IDhnq8rC06QrY2YdXP
         OMQh1Jc9P3Ty6erQCcTE4/ABGUXAz6wZuiHakxJzC0ja0bV9kB0yXYZFqKf6RrvUhLbA
         I3l6LQomW4r55zZLiHxB0KYWZqAd6nQCImV/SufGeU7cJa0xe337iJIUkpFrlQLHt1xL
         S5CVLpThiVzF6MeRyMT2cm3ms8ZPfw4SsxmsjLTdwEaxfeEiMvw4OxicrunnXkMhrY05
         CV/QAtDA0pROJ675GFZJkqhs3UgP5D4ecB4+I8cvb0I1czZiJlKwGhgjSQEuF6xSnj+p
         wIWQ==
X-Gm-Message-State: AOAM533FuyPT+PgLhkmjKdUUYZp5QUpa8rZvGDSi9TrAHnZfftCc5W0f
        GAJkCCXet5w2SCymMa/xncXVxG+5g8lAvvBSX/SvUw==
X-Google-Smtp-Source: ABdhPJwAclle+CORSjPjJi7db7HxxfijathTLOpl4t/xDnpFtnPOk3qBJwYvtl+L7pGIQa1vVGSlvbBX2RiLau/aEgs=
X-Received: by 2002:a05:600c:3caa:b0:394:8fb8:716 with SMTP id
 bg42-20020a05600c3caa00b003948fb80716mr33862529wmb.105.1655715587518; Mon, 20
 Jun 2022 01:59:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220615193116.806312-1-coltonlewis@google.com>
 <20220615193116.806312-3-coltonlewis@google.com> <20220616121006.ch6x7du6ycevjo5m@gator>
 <Yqy0ZhmF8NF4Jzpe@google.com> <Yq0Xpzk2Wa6wBXw9@google.com> <20220620072111.ymj2bti6jgw3gsas@gator>
In-Reply-To: <20220620072111.ymj2bti6jgw3gsas@gator>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 20 Jun 2022 14:29:36 +0530
Message-ID: <CAAhSdy03XsyP3B2VYtpLUkWfr5SREsTJWmuStKfS05hib3e7CQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] KVM: selftests: Increase UCALL_MAX_ARGS to 7
To:     Andrew Jones <drjones@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        KVM General <kvm@vger.kernel.org>,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, thuth@redhat.com,
        Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 20, 2022 at 12:51 PM Andrew Jones <drjones@redhat.com> wrote:
>
> On Sat, Jun 18, 2022 at 12:09:11AM +0000, Sean Christopherson wrote:
> > On Fri, Jun 17, 2022, Colton Lewis wrote:
> > > On Thu, Jun 16, 2022 at 02:10:06PM +0200, Andrew Jones wrote:
> > > > We probably want to ensure all architectures are good with this. afaict,
> > > > riscv only expects 6 args and uses UCALL_MAX_ARGS to cap the ucall inputs,
> > > > for example.
> > >
> > > All architectures use UCALL_MAX_ARGS for that. Are you saying there
> > > might be limitations beyond the value of the macro? If so, who should
> > > verify whether this is ok?
> >
> > I thought there were architectural limitations too, but I believe I was thinking
> > of vcpu_args_set(), where the number of params is limited by the function call
> > ABI, e.g. the number of registers.
> >
> > Unless there's something really, really subtle going on, all architectures pass
> > the actual ucall struct purely through memory.  Actually, that code is ripe for
> > deduplication, and amazingly it doesn't conflict with Colton's series.  Patches
> > incoming...
> >
>
> RISC-V uses sbi_ecall() for their implementation of ucall(). CC'ing Anup
> for confirmation, but if I understand the SBI spec correctly, then inputs
> are limited to registers a0-a5.

Yes, we only have 6 parameters in ucall() since it is based on SBI spec.

Actually, a6 and a7 are used to identify the type of SBI call (i.e. extension
and function number) whereas a0-a5 are function parameters.

Regards,
Anup

>
> Thanks,
> drew
>
