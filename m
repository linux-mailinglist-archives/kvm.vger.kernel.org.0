Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 048243C7DF2
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 07:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237913AbhGNFdH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 01:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237802AbhGNFdG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jul 2021 01:33:06 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B82C0613DD
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 22:30:15 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id 22so1455432lfy.12
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 22:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C3Z9CFxob2kEmCEAlCKWUPaU9hX+53zK6v4wQ2QlHFg=;
        b=VPTgdfil+GwXO7aZSuEge0uSYQQpIq8WFDOqaG4kz23mRyTm20rQHqJ6c9s9XXZR2d
         NDmm00L1EkY2wl7TcNTtMHSYWCjs7970YZtlzfApInzryHYZRQ8Wmn65qSFQpKv/JAbz
         l35cCt+Dzou82ybFA/qs2UQhP6a16jKNVg4z48ozplhKIzsp4+W7TvoLj/RDE7mvagKw
         6SBHHeVgj4aBy24TfbEaTnyGJMCTI1XxY7uM+po33N5UcLNnT50dJunb9RlylUGPfI4X
         tx3Arba6kUxkzNCayOii13Hr2/rvB5I5BH7H+PxmDpPgFEw+OB9XeMQcGpl3iTnYUkaT
         gkBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C3Z9CFxob2kEmCEAlCKWUPaU9hX+53zK6v4wQ2QlHFg=;
        b=bpjRpIf2L1a6J21VUP0UKJ+TR7DC56rMCSNgAxkUyS7elDq8BhgWLXhZDIa/X3aKV8
         pWjDPwBz891spgDqwO3DvsmAGn40Kv0HCmafPK1T/R3IBuGS5xM6VRghqqJZleYA/pK3
         opJcDXN20WEhYozpQ1PLR2oAGozy8tkfO4e4ZBtMZBmVE4lE2wtCAics4waylBovW6x+
         fvLoyflgJgp6emeYGDquuv0EW914zw2X/UNQVVcNWtJxk1IgEnkO+5yRNyeULLgIEt7s
         q9MuQTb89UauLpCFjdoFdJGeYpc9ZvzbSrxEVnIItwr1pJuWPj7mFYnF4xdeFbrGzz3w
         3Byg==
X-Gm-Message-State: AOAM532znL2pgnrS5I10RnuuAK6F8547g/tqK4JnR3Fc5N5/ExIzYYrL
        XjzHLiM+K2dLmhdvdvEbre7hSs6DhlZ2o7zYLHW7Aiu/rGQ=
X-Google-Smtp-Source: ABdhPJzwGzp1+TAupobQLPbG3N+XphKRuUSDwilCNDvuT3/BEtaVEVbBuQflBmok1a5NdcLA6b+zt0OuoEJ3TExFYWg=
X-Received: by 2002:a19:5f43:: with SMTP id a3mr6316001lfj.504.1626240613790;
 Tue, 13 Jul 2021 22:30:13 -0700 (PDT)
MIME-Version: 1.0
References: <CA+-xGqNUX4dpzFV7coJSoJnPz6cE5gdPy1kzRKsQtGD371hyEg@mail.gmail.com>
 <d79db3d7c443f392f5a8b3cf631e5607b72b6208.camel@redhat.com>
 <CA+-xGqOdu1rjhkG0FhxfzF1N1Uiq+z0b3MBJ=sjuVStHP5TBKg@mail.gmail.com>
 <d95d40428ec07ee07e7c583a383d5f324f89686a.camel@redhat.com> <YOxYM+8qCIyV+rTJ@google.com>
In-Reply-To: <YOxYM+8qCIyV+rTJ@google.com>
From:   harry harry <hiharryharryharry@gmail.com>
Date:   Wed, 14 Jul 2021 00:30:12 -0500
Message-ID: <CA+-xGqOSd0yhU4fEcobf3tW0mLb0TmLGycTwXNVUteyvvnXjdw@mail.gmail.com>
Subject: Re: About two-dimensional page translation (e.g., Intel EPT) and
 shadow page table in Linux QEMU/KVM
To:     Sean Christopherson <seanjc@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, stefanha@redhat.com,
        mathieu.tarral@protonmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear Sean,

Thanks for the comments!


> Heh, because the MMUs are all per-vCPU, it actually wouldn't be that much effort
> beyond supporting !TDP and TDP for different VMs...
>

Sorry, may I know what do you mean by "MMUs are all per-vCPU"? Do you
mean the MMUs walk the page tables of each vCPU?


> ...but supporting !TDP and TDP in a single KVM instance isn't going to happen.
> It's certainly possible, but comes with a very high complexity cost, and likely
> even performance costs.

For one KVM instance, I think it might be possible to let several
physical cores use !TDP and other cores use TDP but I am not sure
about the implementation complexity.

>
> The more sane way to support !TDP and TDP on a single host would be to support
> multiple instances of KVM, e.g. /dev/kvm0, /dev/kvm1, etc...  Being able to use
> !TDP and TDP isn't strong justification for the work required, but supporting
> multiple KVM instances would allow upgrading KVM without having to migrate VMs
> off the host, which is very desirable.  If multiple KVM instances are supported,
> running !TDP and TDP KVM instances should Just Work.

Yes, for different KVM instances, it may be much easier but there
might be some other issues, e.g., communication overhead between
different instances. I think the upgrading idea is great but is very
limited to local upgrading.

Best,
Harry
