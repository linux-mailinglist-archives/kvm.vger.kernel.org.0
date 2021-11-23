Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C6E459974
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 01:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbhKWBAB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 20:00:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbhKWA76 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 19:59:58 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DCECC061574
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 16:56:51 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so694079pja.1
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 16:56:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZXvoEcLrIGAYAoxovKlZgNb0DwtzZO0ytuqE+a5WWL0=;
        b=ogIpIsg3sg06ztfxFAMnN7UHnHDsDlSDO6ts+2BlChHtSHaNZKXPTxxu5vXTx0LnCn
         YSdAsYxJTSvXNwhD/09DLEwIJVkcoh6fdk5gOmtzdVVLDo2QlPlaiIHrr5rmO0hdtEP+
         VOp0wmzqH8Av2MYELfhNJRzPloGL2gBz8KzAh8eupjuXi/XU7roRauyh5XYKxtglMPRg
         IivlxRLUJC/HgKxKQnBti03sV6oF37yQky4ofR3y+NZSU2wHRIxVE4KxhBpeXrH4mMUt
         wGhSOVhAvLvl4HM1LQS8ud/nG0b4Poir5J+WitnyeLN4urGhIUw9vwjzPFyn7p5IC/di
         vxRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZXvoEcLrIGAYAoxovKlZgNb0DwtzZO0ytuqE+a5WWL0=;
        b=AIxJr70pmtI31hFDQp3OS9kekwYH8RUuZpxkaksS/SW+AM9HfQmXem349vnQCTeuyi
         xcP5QoTxoApbNoU7Us8DQX/6WnLB5fidvxbK32eRUz54X1svrDLzTJoRHzAkMsORDc0o
         s7GTtbh/ktI69YvpPhzljpqm1QAZ3K0C4pWpLo9yCYGvj287nqMuFfcEV8HBvoKBodeI
         8bpuGe+sGwUzN2CWmeRd5k+WTyupKz2E3YRzzPVMCDsZdZMNFS3/vzLZS05gNzteRoux
         CpRRBFQRJl+HB+6ENjC7wzxaNwLLKeguoeTiInc4tU25Cw2rjwg2mSneIvAg3yFoWOM4
         yX5w==
X-Gm-Message-State: AOAM533i4SMNNJ2W8PCUdSvh2QHm6xof+cnTT9r0HPIzZwqMKXvszyFw
        CPhAmEhqfT1fHNywtQJRORW05pgtdHZPFMq1TKpjSA==
X-Google-Smtp-Source: ABdhPJxiNkaElnGL+/0qOxDZz3IwVrLy5Ntwdx8UmLE6q9RCwWPsBv7dFYR/iNcZsdp8VxNtYX3ZSl2LbBW7cQX7klU=
X-Received: by 2002:a17:90b:380d:: with SMTP id mq13mr1521017pjb.110.1637629010508;
 Mon, 22 Nov 2021 16:56:50 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com> <20211117064359.2362060-4-reijiw@google.com>
 <d3fd9d6c-c96c-d7a0-b78d-af36430dbf3f@redhat.com> <CAAeT=FyzvGaksi+-WidHObrGYcqs4vR73ChCGpo8AFuin6UbYw@mail.gmail.com>
 <87ilwlsn0e.wl-maz@kernel.org>
In-Reply-To: <87ilwlsn0e.wl-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 22 Nov 2021 16:56:34 -0800
Message-ID: <CAAeT=FyXc8WrSur5_c9d9Giq0=zJPQLm81g2AAAzs=4GAPe7Xw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 03/29] KVM: arm64: Introduce struct id_reg_info
To:     Marc Zyngier <maz@kernel.org>
Cc:     Eric Auger <eauger@redhat.com>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 21, 2021 at 4:37 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 19 Nov 2021 04:47:53 +0000,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > I am going to add the following comment. Does it look clear enough for you ?
> >
> >         /*
> >          * This is an optional ID register specific validation function.
> >          * When userspace tries to set the ID register, arm64_check_features()
> >          * will check if the requested value indicates any features that cannot
> >          * be supported by KVM on the host.  But, some ID register fields need
> >          * a special checking and this function can be used for such fields.
> >          * e.g. KVM_CREATE_DEVICE must be used to configure GICv3 for a guest.
> >          * ID_AA64PFR0_EL1.GIC shouldn't be set to 1 unless GICv3 is configured.
>
> There is no such requirement. GICv3 has a compatibility interface, and
> although KVM doesn't make use of it, there is no reason not to expose
> that GICv3 exists on the CPU even if not using it. Even more, this has
> been the case forever, and making this change now would probably break
> migration.

Shockingly, I somehow misunderstood what read_id_reg() did for GICv3...
I will use a different example for it.

Thanks,
Reiji
