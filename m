Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4E935178D
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 19:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235174AbhDARmW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 13:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234448AbhDARhk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 13:37:40 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9DF9C08EA6B
        for <kvm@vger.kernel.org>; Thu,  1 Apr 2021 06:24:52 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id o126so2889491lfa.0
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 06:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SyQ6YHSJTCocB3NQ9p3k0kjyZQfF3RDBbodDQ3PiFKs=;
        b=oQFWDPezRXYmSljEhNK7vaDXbjEFYI3M+O8S34WNrUrWwpDr9Eul/RvlVe1HvgIqPc
         01XZyOIs8c4iAPmWSD0G57GbjL2ynXk1cXt4UvDcZN9tFIaN11MqUJQSCqNKjfa3p8Dj
         6LpONXmzBHadDKBXbzTSzYt1Fzw+9oOjkGRrDXQ/Gn9lFFpw2GREW/xm5BUI2Kv7PHTJ
         +aya6FCR/Q6VJ1J+wY9iJAzOm/lfgOZ9CQoWhconGgF5Y6jMoppHv/bySIQF20+Kgenu
         m93cbVf9tVLijon6yyONxVw4eE++Ra5803A5KtmiixIqIm/6VI5I2H1DRHenhM5n+y0Y
         EYcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SyQ6YHSJTCocB3NQ9p3k0kjyZQfF3RDBbodDQ3PiFKs=;
        b=alGbp4eqwCvSlrgy+TsYcMsFQzMcpgsaD1n2Gv43f6XkuGxT6E8Uw6scKG+nQ+8bjb
         bowqR1HJdmexqB4QowgwB+rb7G8vU9NolfbQRi1/+Mn3Ku5mM75/jq/PNXp0Is9OMvi2
         wQsqn9JMTRplOzSy2iMrVReblyx9zXFQqNDFtcxeIfxT5FHPOXP++aGQYd5l11aYNx6E
         vWiqTpB7Mw+q26qUzgy5ikd1ptIMhkh0fnQbMDGfC4O5AkCJB7KqTgKqAdKOMA/LOIdI
         10I51p7OIy40jaVW21j2mu3JfFGSrkFzHHCDnPc0s9tiKZJcTHL60N4cFg/kEJv2hvL+
         5n+Q==
X-Gm-Message-State: AOAM533KwLVZpaqhs5o5CN/PNFwBIEKwZx3mw2/1Up3B+XDLivZKEZTq
        STL40ptmMfw38cYDpo2fHy0XqG9C7Zht0y3SKj6OwA==
X-Google-Smtp-Source: ABdhPJw6yu1Dk/jHqd4pPD6Ij4l08dS0fzTdrC9xpai4ps/1uls7JvYLd2Y5+el37EX3LSF6TDnqQ5nKgLNuQLh6svU=
X-Received: by 2002:ac2:52b9:: with SMTP id r25mr5587707lfm.25.1617283491330;
 Thu, 01 Apr 2021 06:24:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210115121846.114528-1-anup.patel@wdc.com> <mhng-a4e92a0a-085d-4be0-863e-6af99dc27c18@palmerdabbelt-glaptop>
 <CAAhSdy0F7gisk=FZXN7jmqFLVB3456WunwVXhkrnvNuWtrhWWA@mail.gmail.com> <a49a7142-104e-fdaa-4a6a-619505695229@redhat.com>
In-Reply-To: <a49a7142-104e-fdaa-4a6a-619505695229@redhat.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Thu, 1 Apr 2021 18:54:04 +0530
Message-ID: <CAAhSdy1Lt1NSD7pKmm+Xqqz2b7A6r4KgAO7kRhdy-jwAHucVOg@mail.gmail.com>
Subject: Re: [PATCH v16 00/17] KVM RISC-V Support
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Palmer Dabbelt <palmerdabbelt@google.com>,
        Anup Patel <Anup.Patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexander Graf <graf@amazon.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 31, 2021 at 2:52 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 30/03/21 07:48, Anup Patel wrote:
> >
> > It seems Andrew does not want to freeze H-extension until we have virtualization
> > aware interrupt controller (such as RISC-V AIA specification) and IOMMU. Lot
> > of us feel that these things can be done independently because RISC-V
> > H-extension already has provisions for external interrupt controller with
> > virtualization support.
>
> Yes, frankly that's pretty ridiculous as it's perfectly possible to
> emulate the interrupt controller in software (and an IOMMU is not needed
> at all if you are okay with emulated or paravirtualized devices---which
> is almost always the case except for partitioning hypervisors).
>
> Palmer, are you okay with merging RISC-V KVM?  Or should we place it in
> drivers/staging/riscv/kvm?
>
> Either way, the best way to do it would be like this:
>
> 1) you apply patch 1 in a topic branch
>
> 2) you merge the topic branch in the risc-v tree
>
> 3) Anup merges the topic branch too and sends me a pull request.

In any case, I will send v17 based on Linux-5.12-rc5 so that people
can at least try KVM RISC-V based on latest kernel.

Regards,
Anup
