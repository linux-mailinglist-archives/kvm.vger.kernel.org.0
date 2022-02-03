Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A10524A7CFF
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 01:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348580AbiBCAo7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 19:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239535AbiBCAo5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 19:44:57 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A62C061714
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 16:44:57 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id a25so1526515lji.9
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 16:44:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Clr9DnpK5X9QbR4waWDD/RDesC1yIr9sPjUEQqYA5FU=;
        b=dn2pQKQ6ISt1FIjtoJenVCQokscckXaDQEInIdRoMoBYebBTemXHdrQPZ+upUNgcHh
         LKxIp7wUf8axAQMAKC5VXB+fEjsovqF/1Mv7Lupk3wNJFZOkCDaRom4aonn06PEi9T7X
         eDLMhoYvBahIt+z9IC3xl3wgR2cjIl21xTaQTj0bZyV1TFWKtK5kebUbH2imDQuBvEz6
         mh/FCG4DH2Q6zVz4o617gup9++Ru4pRwW11FYniv6274XWmUOZVMIj0RbQ0Fy1djiW8n
         MPpa69Ww34SZOHhPKf0R1QHbYW603+cqdJh2aovWfqHoXwLZWQzWkEY6ZiK4rl9JLkEo
         +naA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Clr9DnpK5X9QbR4waWDD/RDesC1yIr9sPjUEQqYA5FU=;
        b=ZXO9afXV1nnS0a2tol1RKZpGaTqC1L+3KLSaWtwc7OycCMc41lnqVirKhrfWKnAk9G
         Rk5WpDFbSeL37rObQl6R5lw/9HlWvAR3uVaGGYO/9Ucknxp1HwQT9RBOokaV5uGYMR/k
         H4/kiEvO4PJaY1zwfsXnwfNEs04Az9yXTdnJtt+tmMDB/zj3/1zxuvNGAa9/SKqbm4sl
         nTzVuquHkw5sszCqOaR4WSAKgoMTp5KbrAauDz0zySSKiDXn6ZMTq73ePnH8uVNnHoFw
         hUhvPJ9goMxdbUKs4jeP7/ecMXjQJEO69p6KxG93b11FcPwkg6KujsvH0d4jr4IjmFnJ
         VphA==
X-Gm-Message-State: AOAM531yUb6w8b9JMtYClZdzWE+6ailo7PLbca3kygE9QWWzwzvjkXqu
        aulPtQ211msWnkKxS83iaPbK1yCODGTaaT3/Y2ND1w==
X-Google-Smtp-Source: ABdhPJyF3ok0L0G7HS4CKFMuzTQGAfy189ohIrhpT2oVqWWr/a+A29hpIfjphxYoVXrdxccq1KbZ7oChvFkqyutTpF8=
X-Received: by 2002:a2e:b058:: with SMTP id d24mr14259180ljl.374.1643849095513;
 Wed, 02 Feb 2022 16:44:55 -0800 (PST)
MIME-Version: 1.0
References: <20220202230433.2468479-1-oupton@google.com> <CALMp9eRotJRKXwPp=kVdfDjGBkqMJ+6wM+N=-7WnN7yr-azvxQ@mail.gmail.com>
 <Yfsi2dSZ6Ga3SnIh@google.com> <CALMp9eRDickv-1FYvWTMpoowde=QG+Ar4VUg77XsHgwgzBtBTg@mail.gmail.com>
In-Reply-To: <CALMp9eRDickv-1FYvWTMpoowde=QG+Ar4VUg77XsHgwgzBtBTg@mail.gmail.com>
From:   Oliver Upton <oupton@google.com>
Date:   Wed, 2 Feb 2022 16:44:44 -0800
Message-ID: <CAOQ_Qsh8ND+yGjum+qBeBCn7RCaLjfVdgh+hQHcD-7HTWiuygg@mail.gmail.com>
Subject: Re: [PATCH 0/4] KVM: nVMX: Fixes for VMX capability MSR invariance
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 2, 2022 at 4:38 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Wed, Feb 2, 2022 at 4:33 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Wed, Feb 02, 2022, Jim Mattson wrote:
> > > On Wed, Feb 2, 2022 at 3:04 PM Oliver Upton <oupton@google.com> wrote:
> > > >
> > > > Ultimately, it is the responsibility of userspace to configure an
> > > > appropriate MSR value for the CPUID it provides its guest. However,
> > > > there are a few bits in VMX capability MSRs where KVM intervenes. The
> > > > "load IA32_PERF_GLOBAL_CTRL", "load IA32_BNDCFGS", and "clear
> > > > IA32_BNDCFGS" bits in the VMX VM-{Entry,Exit} control capability MSRs
> > > > are updated every time userspace sets the guest's CPUID. In so doing,
> > > > there is an imposed ordering between ioctls, that userspace must set MSR
> > > > values *after* setting the guest's CPUID.
> > >
> > >  Do you mean *before*?
> >
> > No, after, otherwise the CPUID updates will override the MSR updates.
>
> Wasn't that the intention behind this code in the first place (to
> override KVM_SET_MSR based on CPUID bits)? If not, what was the
> intention behind this code?

Suppose a VMM desperately wants to hide the "load
IA32_PERF_GLOBAL_CTRL" bits, in spite of providing a supporting vPMU.
The only way to do so at the moment is to write the control MSR after
the CPUID write.
