Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2602D2E008F
	for <lists+kvm@lfdr.de>; Mon, 21 Dec 2020 19:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgLUS6F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Dec 2020 13:58:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgLUS6E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Dec 2020 13:58:04 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92828C0613D6;
        Mon, 21 Dec 2020 10:57:24 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id a6so7317779qtw.6;
        Mon, 21 Dec 2020 10:57:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cElhcZNm2VH8i/cYThR7pA2axscEXIqRP6jzTA+ItnI=;
        b=kbsl16KmA3LValskyJ0UyOS4jCb+3f967y6f/GWmrtwQEdmmcBgFM4Fjo8ItNuZgmN
         jDrVV4Y3wjariyzCu9KQG3sHOLu/df4Fg5+Xa5hunvMUmHo3EjmC3JvyDcjxTXeCzBst
         fynuWEJRaNlfvgtM2TvtKutmuD11tjoDE0b/EGu3cpRaMZOn1KJPSn59opoRQQbRtrU5
         0RT0UpIbBf/KeM97xfhxLfnjulULOg1Qx8cUfMt2FoYGa58QJ/UZ9nx8cUyUhMx/dsqY
         2O4ceT9y70DWwaWS3wwA1l6+j24LseZPhKPU/9q1hi+j0QXUJaDoBi/KeegaUWo+aN42
         SIUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cElhcZNm2VH8i/cYThR7pA2axscEXIqRP6jzTA+ItnI=;
        b=kC/oW54lGJNCl4tYPaRDQhJPWcsbs3+B66vuuAX23mAFsmcVSBSgyVUkJTMW5zEn+/
         InZXGXhzn+AoReg+DBknJT6hWBAiX0fhGlYj4hyeD9ny8QgrvLSbhtWxO2svp/5FAfcN
         DrVDHA2jH8B3oXXXnV3oJUhqvVojWxl2jwOAWQrP+7UkS+wlLxEFNblHDUezhA4yHcHR
         InP6BPj0wjjZQMllHePFHpgogT84Rn70uiRT0pMCKEvG8oGxAngh2RetJ/SLYhhLId4p
         pgnAavKdVJGC32vQU62BLj3FliXKBSxFCztrxVKKCFyW0pCUJuXlFwYt4+Urp2pY9Qc5
         SUIQ==
X-Gm-Message-State: AOAM533rxZZHL9Xn+jnpzsltoq9Ue3M2Vi4Ugo93khyDKblV5iVGwqci
        UppGv0+bEsIffCV/LZCXcTipebh66+Lle3FH0Bg=
X-Google-Smtp-Source: ABdhPJzyLrMQ8ycuXsop4tziI6RiOyhBJIwxEPsvizoxLd0t5dz+0oJN5ijUb5U4bVhvOYF4LxhypqIWyqNYIn9BEcc=
X-Received: by 2002:ac8:5806:: with SMTP id g6mr17655674qtg.292.1608577043802;
 Mon, 21 Dec 2020 10:57:23 -0800 (PST)
MIME-Version: 1.0
References: <20201220211109.129946-1-ubizjak@gmail.com> <X+DnRcYVNdkkgI3j@google.com>
In-Reply-To: <X+DnRcYVNdkkgI3j@google.com>
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Mon, 21 Dec 2020 19:57:12 +0100
Message-ID: <CAFULd4aBWqQmwYNo74_zmP22Lu79jnRJVu5+PrKkOD2Dbp6-FQ@mail.gmail.com>
Subject: Re: [PATCH v2] KVM/x86: Move definition of __ex to x86.h
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 21, 2020 at 7:19 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Sun, Dec 20, 2020, Uros Bizjak wrote:
> > Merge __kvm_handle_fault_on_reboot with its sole user
>
> There's also a comment in vmx.c above kvm_cpu_vmxoff() that should be updated.
> Alternatively, and probably preferably for me, what about keeping the long
> __kvm_handle_fault_on_reboot() name for the macro itself and simply moving the
> __ex() macro?
>
> That would also allow keeping kvm_spurious_fault() and
> __kvm_handle_fault_on_reboot() where they are (for no reason other than to avoid
> code churn).  Though I'm also ok if folks would prefer to move everything to
> x86.h.

The new patch is vaguely based on our correspondence on the prototype patch:

--q--
Moving this to asm/kvm_host.h is a bit sketchy as __ex() isn't exactly the
most unique name.  arch/x86/kvm/x86.h would probably be a better
destination as it's "private".  __ex() is only used in vmx.c, nested.c and
svm.c, all of which already include x86.h.
--/q--

where you mentioned that x86.h would be a better destination for
__ex(). IMO, __kvm_handle_fault_on_reboot also belongs in x86.h, as it
deals with a low-level access to the processor, and there is really no
reason for this #define to be available for the whole x86 architecture
directory. I remember looking for the __kvm_handle_falult_on_reboot,
and was surprised to find it in a global x86 include directory.

I tried to keep __ex as a redefine to __kvm_hanlde_fault_on_reboot in
x86.h, but it just looked weird, since __ex is the only user and the
introductory document explains in detail, what
__kvm_hanlde_fault_on_reboot (aka __ex) does.

Uros.
