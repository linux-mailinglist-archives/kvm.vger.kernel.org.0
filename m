Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD2E2491BC
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 02:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgHSATu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 20:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbgHSATu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 20:19:50 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D45C061389
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 17:19:49 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id j7so19546885oij.9
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 17:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3xf/uVvZRRPeQ5/ctm4JBgh76ZQxD/OxXmeSi3iyGm0=;
        b=GVDz5iCieJACXORAqyVyYzT+TPbkZfyvvHXpFJEw5mkQxg6M1YuGz5W/rbqsayHrEq
         VCqaJKHV/Wy5Ygf1kC18Tr6K6sKk1r7FNlQiFa6pvbAA74vTf1HdpgdfE4Ar7F+igwyO
         0mJK+Fups0GcazFj0fQFShIIb98SKYFKpYn27LPIFqIw4qh9DWx6lhbs/vWz1rn6T9z0
         ++VwAcDgROtVKA6bun4PVR49WEA+zOADOoFnwHNEEVSU6WZ6zuUx+OXvEHkPnUklgequ
         tysSt+o+obK3aML0nuelOTcNo4QP7eJftcqTOv1W0JJ0bQpq3TwkF1Uy3KIduWMft1se
         Hf+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3xf/uVvZRRPeQ5/ctm4JBgh76ZQxD/OxXmeSi3iyGm0=;
        b=YBUf5aW54d8giXJjfOsTpC0zki0p6eId9ETEb/Gaoy+1oiKrVOGKS5M1f9Ngax/q4v
         o3tFSPbmz5DXDoTyuXxxl2mj6MKEL0znSyS+sqZ3XQruH2zvw8yFf35CXlCjk7X8FSFY
         sJ4vleqDk6lzdeU9duQ/vjMMwFRojIq9LsdD7YvePBcdavLmIwdZKPWIGkNz+kQakqrN
         zBhJ04b0iA0YklwnuNifgh8hqAx/YiztuU6O6usicjoHzzC88GsZTvWzOhNr4nnNG9Qm
         4xrzx4ZP2JDwULytIzelBYzCwozl6+nNSAf5f2MM3bd9Y0NJSux+gZ6+tPpGL1p82EH5
         OLOw==
X-Gm-Message-State: AOAM530nv/p7Cs9iyAsyVzla9hZ9iUZeTkds+a3uSKsqFQi6sj5PIvkP
        943ODFGkz2jzB/e8oLpu3HzathOQdUsKi/QjLRI=
X-Google-Smtp-Source: ABdhPJxW0uPyquBxs5kFM0bn0v2hiG/70BXVU37YrwXN7+lLKAcqhzkeJsp73PVH2VbOCPZ7opemGn3Vv51EUY4Pdvs=
X-Received: by 2002:aca:4f52:: with SMTP id d79mr1665980oib.141.1597796388909;
 Tue, 18 Aug 2020 17:19:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200818152429.1923996-1-oupton@google.com> <20200818152429.1923996-3-oupton@google.com>
In-Reply-To: <20200818152429.1923996-3-oupton@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 19 Aug 2020 08:19:37 +0800
Message-ID: <CANRm+CxMRA2j8uc-gnqxJtq5UEffaHcqqXcpOHSJrUVE+=r+XQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] kvm: x86: set wall_clock in kvm_write_wall_clock()
To:     Oliver Upton <oupton@google.com>
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 Aug 2020 at 23:24, Oliver Upton <oupton@google.com> wrote:
>
> Small change to avoid meaningless duplication in the subsequent patch.
> No functional change intended.
>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>

Reviewed-by: Wanpeng Li <wanpengli@tencent.com>

> Change-Id: I77ab9cdad239790766b7a49d5cbae5e57a3005ea
> ---
>  arch/x86/kvm/x86.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b7ba8eb0c91b..e16c71fe1b48 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1791,6 +1791,8 @@ static void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock)
>         struct pvclock_wall_clock wc;
>         u64 wall_nsec;
>
> +       kvm->arch.wall_clock = wall_clock;
> +
>         if (!wall_clock)
>                 return;
>
> @@ -2998,7 +3000,6 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>                 break;
>         case MSR_KVM_WALL_CLOCK_NEW:
>         case MSR_KVM_WALL_CLOCK:
> -               vcpu->kvm->arch.wall_clock = data;
>                 kvm_write_wall_clock(vcpu->kvm, data);
>                 break;
>         case MSR_KVM_SYSTEM_TIME_NEW:
> --
> 2.28.0.220.ged08abb693-goog
>
