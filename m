Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E746D3B20BF
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 21:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbhFWTEw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 15:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbhFWTEu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 15:04:50 -0400
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D89C061574
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 12:02:31 -0700 (PDT)
Received: by mail-oo1-xc32.google.com with SMTP id u14-20020a4ae68e0000b029024bf1563f62so989798oot.3
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 12:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MRqftscF1FzfzzSjl5zFo7iO4VJxE2+eaqEj1NzMIwk=;
        b=N3zmO53vFPvwU+U7IahzduZVgdhRclf7RioMWOY+16NWHJ0+cf/uqdULwG4OvgCQzk
         Z6QN1tXNYwWWK9PuDVzuLkTlINpbkyhFYm6US7NUtvm7pzLLQV3daJvVqQnGZxOAjy0l
         jAnBACNa/mO2/NxRq+VFB9DvMh8xuTW6lKvZ86vb97EtPEi7hZv/zYhR+pd/cvohlto8
         Pq8LEF2+gZaR0LjsQz1yiiPJsC/kP+mxmUZ1/1VRzEyQhxW8yW27q7qb6OeNRa4e6Pwm
         5xUykPTFC1nvHZJ79TwbMEjjtMA45P1oAGfvzsW9OIoYtpz0Qj/tsyhCfORb8jz1hG9i
         KYag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MRqftscF1FzfzzSjl5zFo7iO4VJxE2+eaqEj1NzMIwk=;
        b=O6ElrJy/Vv1e2kjZpehiqIYZx8leEIZ7EV6zKiffcu6+EgDikz9kBBPyDYkAp51BOw
         +x/sU4v3XB2VZ+qrPq1fN5oMaDna4WTnY2W3BcZk/N9OsG6csBa0H9bmmRrP64oN21Vv
         XDRLNX7ChpwnAWaQUH7DKN4JNmbft6FxoalhRZJ9XdIohlWWrYw9RgXItM8u9+k+gP4x
         27PF3Rz68yv2idwgYBE84zt/yYRMmjm37hkzmKRNJ/HpS1KMXqVbgPtOARrLyJFJwHrZ
         OyrerT/aI2fyBuW0ziLviVLjiDvAwa4CjUqUm3noYz/srnqmuY8bn2qdRNmWUyQTRyZu
         EiRA==
X-Gm-Message-State: AOAM530PM7BszsuRV58QQhztw5AtD/aAeRe0CY8NDdU7BmRrx6fuSjxM
        sqxBjnKzgEvN96KUZM6x31YMXiMa3FND47nH3XbpSw==
X-Google-Smtp-Source: ABdhPJx1rKEuvgjZXk4Aa0YPqdFzImQ6xpZMX639CAYw+F7eQsq6FSOuI4g8MPeykoozbRPJyFgLT8+n15pY7iONbVI=
X-Received: by 2002:a4a:6c0c:: with SMTP id q12mr1045468ooc.81.1624474950658;
 Wed, 23 Jun 2021 12:02:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com> <20210622175739.3610207-8-seanjc@google.com>
 <f031b6bc-c98d-8e46-34ac-79e540674a55@redhat.com> <CALMp9eSpEJrr6mNoLcGgV8Pa2abQUkPA1uwNBMJZWexBArB3gg@mail.gmail.com>
 <6f25273e-ad80-4d99-91df-1dd0c847af39@redhat.com> <CALMp9eTzJb0gnRzK_2MQyeO2kmrKJwyYYHE5eYEai+_LPg8HrQ@mail.gmail.com>
 <af716f56-9d68-2514-7b85-f9bbb1a82acf@redhat.com>
In-Reply-To: <af716f56-9d68-2514-7b85-f9bbb1a82acf@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 23 Jun 2021 12:02:19 -0700
Message-ID: <CALMp9eQG-QLm1xRXw2CxLEsRukH0q6HoaQKPraDo-TyCSv6EKg@mail.gmail.com>
Subject: Re: [PATCH 07/54] KVM: x86: Alert userspace that KVM_SET_CPUID{,2}
 after KVM_RUN is broken
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 23, 2021 at 11:49 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 23/06/21 20:11, Jim Mattson wrote:
> > On Wed, Jun 23, 2021 at 10:11 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >> Nah, that's not the philosophy.  The philosophy is that covering all
> >> possible ways for userspace to shoot itself in the foot is impossible.
> >>
> >> However, here we're talking about 2 lines of code (thanks also to your
> >> patches that add last_vmentry_cpu for completely unrelated reasons) to
> >> remove a whole set of bullet/foot encounters.
> >
> > What about the problems that arise when we have different CPUID tables
> > for different vCPUs in the same VM? Can we just replace this
> > hole-in-foot inducing ioctl with a KVM_VM_SET_CPUID ioctl on the VM
> > level that has to be called before any vCPUs are created?
>
> Are there any KVM bugs that this can fix?  The problem is that, unlike
> this case, it would be effectively impossible to deprecate
> KVM_SET_CPUID2 as a vcpu ioctl, so it would be hard to reap any benefits
> in KVM.
>
> BTW, there is actually a theoretical usecase for KVM_SET_CPUID2 after
> KVM_RUN, which is to test OSes against microcode updates that hide,
> totally random example, the RTM bit.  But it's still not worth keeping
> it given 1) the bugs and complications in KVM, 2) if you really wanted
> that kind of testing so hard, the fact that you can just create a new
> vcpu file descriptor from scratch, possibly in cooperation with
> userspace MSR filtering 3) AFAIK no one has done that anyway in 15 years.

Though such a usecase may exist, I don't think it actually works
today. For example, kvm_vcpu_after_set_cpuid() potentially changes the
value of the guest IA32_PERF_GLOBAL_CTRL MSR.
