Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2C204A5E0E
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 15:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239128AbiBAOO6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 09:14:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239129AbiBAOO5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 09:14:57 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C014CC06173E
        for <kvm@vger.kernel.org>; Tue,  1 Feb 2022 06:14:57 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id e81so33498195oia.6
        for <kvm@vger.kernel.org>; Tue, 01 Feb 2022 06:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6bOJYv1YXi57aXsNUO4DshkJvwNgZBMSvRbTKgSo7IM=;
        b=AWQE60HZuXRdf3uBXurgIDDbIMW/+IJJ25UY1gTmKDmw1WRzhEaf2iJfYhqZVs7/oI
         xkKLM9palj/+QbBbNhpvjIYROJDcGqerVuNAub/Kn4Z0zAa1cFcB2m/YcqKM0fG/P2f1
         Gie4zgekiYmfVvh/p0zxjmcUFtTk+SOrLOAKzRQ5g/gbz8gmqXr152WzTBgSHfVFH5PE
         mkmWGE3LF5kAXIYxKgggPCAoFJvYVaa9DKKEV58MdttyymffgCGu5jkT6y1LGKoTzN4A
         7t2k6zl4sc7JZncOe0WuWVT7JwKUfQHYnDms6xTATvu/dGWd7vJIVNsPhBaCJlFvdbsr
         C9vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6bOJYv1YXi57aXsNUO4DshkJvwNgZBMSvRbTKgSo7IM=;
        b=EB7UyquDIDp/AtU9Rc8akVd23i6qyUz8kBKG5kQM5t6i/XTE9ZAeeEQdAV5Od7wqAl
         OninFo9DqqdM2MS10cz8EH1XEGdVPGDaZaK1K0noaRV6CkKLlHSPrNJYdD70ly+fn2HS
         jN82cFaJVaLJWmuoQY0usgr7LC/l0QP2Hv2nIUXVgp9D/VrrEuOToEYX/8AAk0B2/p+i
         +TWBI770Sxd8eYu48k6KvMz0nwFNO/glwL2DJl5q2zXWSrdTaQXQARLLel+2BqAlhSj3
         BMXBEFAmU33Hu/kHRFsiVmeGjYE0x/cJfRKXqIYGVjQuGs5VDCcntXqu8WFSsjCKoXY2
         Av8g==
X-Gm-Message-State: AOAM531ZLA1StEGAUfq5pdeYMgrRXELVbyoBPlddduPFzHiL9jc4lFdx
        GjYXVm0hhPYa6A72TeGuOIZEXySmTqcSNgkxKe8bcw==
X-Google-Smtp-Source: ABdhPJztijkLEYC0AMBbPf31NVpfBd3j1Dug7ndhyOGAhyIwbOmUQBb7IRhv9Rqqoj8sG1Fm2nt0s7rfxiTUrTZyh3I=
X-Received: by 2002:a05:6808:230f:: with SMTP id bn15mr1264184oib.91.1643724896991;
 Tue, 01 Feb 2022 06:14:56 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com> <20220106042708.2869332-21-reijiw@google.com>
 <CA+EHjTy4L37G89orJ+cPTTZdFUehxNSMy0Pd36PW41JKVB0ohA@mail.gmail.com> <CAAeT=Fx1pM66cQaefkBTAJ7-Y0nzjmABJrp5DiNm4_47hdEyrg@mail.gmail.com>
In-Reply-To: <CAAeT=Fx1pM66cQaefkBTAJ7-Y0nzjmABJrp5DiNm4_47hdEyrg@mail.gmail.com>
From:   Fuad Tabba <tabba@google.com>
Date:   Tue, 1 Feb 2022 14:14:21 +0000
Message-ID: <CA+EHjTx=ztc-RnuazbUcR-JsKocyie+FtrukvzUP=SZ-y9WPuw@mail.gmail.com>
Subject: Re: [RFC PATCH v4 20/26] KVM: arm64: Trap disabled features of ID_AA64PFR0_EL1
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reiji,

...

> > > +static void feature_amu_trap_activate(struct kvm_vcpu *vcpu)
> > > +{
> > > +       feature_trap_activate(vcpu, VCPU_CPTR_EL2, CPTR_EL2_TAM, 0);
> >
> > Covers the CPTR flags for AMU, but as you mentioned, does not
> > explicitly clear HCR_AMVOFFEN.
>
> In my understanding, clearing HCR_EL2.AMVOFFEN is not necessary as
> CPTR_EL2.TAM == 1 traps the guest's accessing AMEVCNTR0<n>_EL0 and
> AMEVCNTR1<n>_EL0 anyway (HCR_EL2.AMVOFFEN doesn't matter).
> (Or is my understanding wrong ??)

You're right. However, I think they should be cleared first for
completeness. Also, if I understand correctly, AMVOFFEN is about
enabling and disabling virtualization of the registers, making
indirect reads of the virtual offset registers as zero, so it's not
just about trapping.

Thanks,
/fuad

> Thanks,
> Reiji
