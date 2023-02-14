Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C31A69630D
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 13:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232019AbjBNMEG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 07:04:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232071AbjBNMDk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 07:03:40 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F4086EA6
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 04:03:14 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id bt14so3139215pfb.13
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 04:03:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1676376194;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4OFLKQfANhjw7P3sAHZTMOClrII680RXItiJwvYhcnQ=;
        b=hiPFJAr7vRYTapkWRa9ybzVL7Z8dBMLUjvIFSZ6CL4rF0XCQ2A+iMrSiNlUcz8qLiM
         bCPLNEwnU5kv5dDShz2PycIuvw869/B/zw2qzjoN9bKlQWsplZsEsaq9xHzUwEeGLqQR
         m5jCHRmOebGW1MPINYH/f+ClCp2dcdUv8I9l+pGwvUEYaM91clC7uQ+v98QvDlsDtLBS
         ZJ6qb1FzjICLubEqrsc1/OlLp+2JzAArL69uKGHGPMS0FbYX3LeFZKbFHn/XkLS/0k77
         8dx8Pch+J0W8AHyzfW92QzH/BuoihKYLrSRKsX8HXDQBbee+0bh7WvD0yyrIfp8vzGQM
         J4nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676376194;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4OFLKQfANhjw7P3sAHZTMOClrII680RXItiJwvYhcnQ=;
        b=l6UTnqehjqKbPvcoZHP59p5rAUewoHz/VSn5CrpekjmIFCB+0uvA9VcR5Ce2h/UhLM
         Pso0t7mYJgDqt+CT5MfZtjurUaHb3bYZvIVIaSzx1TgojsZLUiFmaNFKz7QyJrxgjtLF
         TTpykvDZ6VB4Y2y12yUVsfcGfA8EpquEdQC5W6gRSVf9Mb4ipjkoIzOv0IiTTMC/zXCv
         NrRBHgqwNNueYNTK3xdmhpUsfzWM34b2befObYyPyFlMwAdHxRCxqHbOtnflKnyolIxB
         rLhti/aDvFgxDkE/gz2F+XKH/9QPw1Uvu/I+nXAAO5qUOIIDTpiSoTG8t/WS6oDqGEIL
         kTpA==
X-Gm-Message-State: AO0yUKWXksLBQdHpqKQySOZ2wwhRBmQtsNbWYR6kHczVh16qMiizgnJ4
        5z2nVerfjDZ+aT7dGgPfVOrHYugonRTQ2LZ7rPQ=
X-Google-Smtp-Source: AK7set/woFlNqZhwk99TalgElsfu5fJ6AX6LQoxOwN9Fb7RYaKb9v1T7XJVc9BV+L6RVoofs9zJgVl9j3aFykzBPcfk=
X-Received: by 2002:a62:1cc1:0:b0:5a8:a56a:c580 with SMTP id
 c184-20020a621cc1000000b005a8a56ac580mr483970pfc.2.1676376193897; Tue, 14 Feb
 2023 04:03:13 -0800 (PST)
MIME-Version: 1.0
References: <20230214103304.3689213-1-gregkh@linuxfoundation.org>
In-Reply-To: <20230214103304.3689213-1-gregkh@linuxfoundation.org>
From:   Xingyuan Mo <hdthky0@gmail.com>
Date:   Tue, 14 Feb 2023 20:03:03 +0800
Message-ID: <CALV6CNMLfwdMDztTxW6Lc_im-3BRHaiLq6BhS31Kz1c7WV3vDA@mail.gmail.com>
Subject: Re: [PATCH] kvm: initialize all of the kvm_debugregs structure before
 sending it to userspace
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, stable <stable@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 14, 2023 at 6:33 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> When calling the KVM_GET_DEBUGREGS ioctl, on some configurations, there
> might be some unitialized portions of the kvm_debugregs structure that
> could be copied to userspace.  Prevent this as is done in the other kvm
> ioctls, by setting the whole structure to 0 before copying anything into
> it.
>
> Bonus is that this reduces the lines of code as the explicit flag
> setting and reserved space zeroing out can be removed.
>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: <x86@kernel.org>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: stable <stable@kernel.org>
> Reported-by: Xingyuan Mo <hdthky0@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  arch/x86/kvm/x86.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index da4bbd043a7b..50a95c8082fa 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5254,12 +5254,11 @@ static void kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
>  {
>         unsigned long val;
>
> +       memset(dbgregs, 0, sizeof(*dbgregs));
>         memcpy(dbgregs->db, vcpu->arch.db, sizeof(vcpu->arch.db));
>         kvm_get_dr(vcpu, 6, &val);
>         dbgregs->dr6 = val;
>         dbgregs->dr7 = vcpu->arch.dr7;
> -       dbgregs->flags = 0;
> -       memset(&dbgregs->reserved, 0, sizeof(dbgregs->reserved));
>  }
>
>  static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
> --
> 2.39.1
>

Tested-by: Xingyuan Mo <hdthky0@gmail.com>
