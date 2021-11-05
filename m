Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E19445F07
	for <lists+kvm@lfdr.de>; Fri,  5 Nov 2021 05:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbhKEEKV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Nov 2021 00:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbhKEEKU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Nov 2021 00:10:20 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0090DC061714
        for <kvm@vger.kernel.org>; Thu,  4 Nov 2021 21:07:41 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id b4so7317086pgh.10
        for <kvm@vger.kernel.org>; Thu, 04 Nov 2021 21:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=llkuSb5L0jD6uE3X1Ynlqc/ho6/ZjfVGOP1jb8IlvtY=;
        b=CgwWzLxvp/Ys6iQTLaSFINNjrWrsZdvERBVFUf3pSsp/7dAeAcEh26sO9s5OX7LKIn
         /tvZ5i96zuyLM5qyJ5VLuq2/eadmyISfLgq4vOTCoWAgXLTMRQifAlFsL0wOys+sI84c
         F7Xi7LQvdqEk8Y4KVvMA0q1XtBCYw4kJLHh7z/Ll7t4JeGUbn9POCmevvBusXDpooJ+B
         k2wKoTf5Hcocrh8CB678iONSG3+zGZhYpXmyQlahA8bwRu96JYhMK8CdopRjBCDYUOdd
         92dr6qBNNDMj2LwqJzYGedCU6jdT87c/LF61IlnuEnPCIIHAECe13I+ozU9X4MzRwszn
         R2qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=llkuSb5L0jD6uE3X1Ynlqc/ho6/ZjfVGOP1jb8IlvtY=;
        b=wWjttyCnKao2xqU4AzfYz6ril49YQRv+sqUGeU3au1u1uqXIkJlWB//NdHtC76Tg/W
         E4yzmBZP2n3EDI2nyG3CO22xji33IqdLyZDklGz7YXffAjGYOpvg6brjxnHy0lvzikzQ
         QIJ5NMlXMoPhr32OhTHi4YFOaqosoMROTU7J5+Ra59WFCb/M8lghIveX5siGeRuxdsN6
         AbBukPE1Gyg3VZCjuaGarEpWHLEnTt1JdONLcU6cWLaQj+7PsIErD/OQyogJAsOzo0k5
         4Swe5NmuuruWISdsLaLPiffbZMMXwWsmzbElHW3OKQ4cifIekVFXXRdoXmsjNiYERij+
         kpfw==
X-Gm-Message-State: AOAM5315m2aUYrYU6rdPQkCVPXj5wymmkRC4D8brrLgHBOqwisRF7N1A
        8Ya2VSphHiFSs0iErEBjqVFnD0E2O34pk6qJzREqDA==
X-Google-Smtp-Source: ABdhPJxVWPCzurrkxGOQvESM60+vz35M7q2DOzwppoBNuuLOlob6+tQKsQpwQXnfvWq5G62psSFMc58PWrB/iRPN4HM=
X-Received: by 2002:a65:4889:: with SMTP id n9mr1402858pgs.303.1636085261047;
 Thu, 04 Nov 2021 21:07:41 -0700 (PDT)
MIME-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com> <20211103062520.1445832-19-reijiw@google.com>
 <YYQNGqpy1NiUEXYD@google.com>
In-Reply-To: <YYQNGqpy1NiUEXYD@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Thu, 4 Nov 2021 21:07:25 -0700
Message-ID: <CAAeT=FyowLxUTpLDoAxrETbOyCTCcfc1==hy-Q4F5fdswqS-yg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 18/28] KVM: arm64: Introduce KVM_CAP_ARM_ID_REG_WRITABLE
 capability
To:     Oliver Upton <oupton@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 4, 2021 at 9:41 AM Oliver Upton <oupton@google.com> wrote:
>
> On Tue, Nov 02, 2021 at 11:25:10PM -0700, Reiji Watanabe wrote:
> > Introduce a new capability KVM_CAP_ARM_ID_REG_WRITABLE to indicate
> > that ID registers are writable by userspace.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  Documentation/virt/kvm/api.rst | 8 ++++++++
> >  arch/arm64/kvm/arm.c           | 1 +
> >  include/uapi/linux/kvm.h       | 1 +
> >  3 files changed, 10 insertions(+)
> >
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index a6729c8cf063..f7dfb5127310 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -7265,3 +7265,11 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
> >  of the result of KVM_CHECK_EXTENSION.  KVM will forward to userspace
> >  the hypercalls whose corresponding bit is in the argument, and return
> >  ENOSYS for the others.
> > +
> > +8.35 KVM_CAP_ARM_ID_REG_WRITABLE
> > +--------------------------------
>
> ID registers are technically already writable, KVM just rejects any
> value other than what it derives from sanitising the host ID registers.
> I agree that the nuance being added warrants a KVM_CAP, as it informs
> userspace it can deliberately configure ID registers with a more limited
> value than what KVM returns.
>
> KVM_CAP_ARM_ID_REG_CONFIGURABLE maybe? Naming is hard :)

Thank you for the suggestion.  Yes, that sounds better.
I will change the name as you suggested.

Regards,
Reiji
