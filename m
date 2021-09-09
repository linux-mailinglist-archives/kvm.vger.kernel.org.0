Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F6A405B1E
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 18:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237302AbhIIQoy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 12:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236823AbhIIQoy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 12:44:54 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C623FC061575
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 09:43:44 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id s16so5224661ybe.0
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 09:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8rBbbtBdxJo/z24uZXVl1WsJ9x865p3tX3wOkYNw8zI=;
        b=CxwyPEJx4brKYyNJfKH8xuVZVHNOb+imoHwqrC+m2OvLlX1CF4dc26BHqiDbb0sFdk
         FmFt0zmLzKgCa1DNQCsc6xZr9y3Z4pPNnzfIhUb3+16a9bNWy6ONfjK/aT8G5S4TT4x2
         SkyR9dYU1Bc3NWOfR/N8Xx4cdUqvv0TI5ThmKPXKlq0Dk9Zn2TJzowps8qXs4ziXJamP
         twWLDiVKUzt9dDskgQnZ+tuA0VajMO+0ZZb02gUUe6KXZatND7/Lkxi5UJx9cL/zyBl2
         9opFUHOSodvBlEv+qiApY+wGv/xCn72PWdKYkA+dJ2BOP4oZE/fSnYIKWCoQG3Sc2S3C
         kONA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8rBbbtBdxJo/z24uZXVl1WsJ9x865p3tX3wOkYNw8zI=;
        b=DsVYr+WeoPHGDR9rk20r4m/MaOJIYn5YWlIVle5Ira2j5yHQzZl412SY7mpXZ4NtxV
         GlcKvSOGnceA8buy5jLcjdmkA5/w2kLoDaXBHGwNsV+8Wx4/HWn/I59h5ze46JU5blLN
         7BtwkiR1mtqsBIlmCFxg+l4UX551F/op/SipPOHIRhRf04TDLY055TZOm5FH7yV1fplv
         233OFVAT/57JQI/5q2HMUBv/oUQq14c3ZcjBq8L1XdM2bqanBfj5Ur/1O9baEz9Yyt/4
         hdrNNqlJ7B+G3Zpp9mKdZ2Eat2Mrt0apaUSCOdjKePVlYavNvC1nxzyN9Jj+zBLtOOJW
         d5CQ==
X-Gm-Message-State: AOAM530VH4s5jA4UfdYPAGP6TgVNEsAnjBQRx8jkCXlLWoTb8cHUugqw
        jVRWn951ql1v1XZgC7HE3TyE+QGq3uIGhm/T7Pcmrg==
X-Google-Smtp-Source: ABdhPJxK5TixXHGpQ0HcjLdTV1bZ1SKePd5PRIPCrE5JXb/3IBGHK3nqLVQvIpatA9h6OifefO1lBmdtxEyNyano2rg=
X-Received: by 2002:a25:cd82:: with SMTP id d124mr5096262ybf.491.1631205823874;
 Thu, 09 Sep 2021 09:43:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com> <20210909013818.1191270-4-rananta@google.com>
 <20210909065612.d36255fur5alf6sl@gator>
In-Reply-To: <20210909065612.d36255fur5alf6sl@gator>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Thu, 9 Sep 2021 09:43:32 -0700
Message-ID: <CAJHc60y2i9AT5rEat0pK-h2BsNjzp_1tbqGAM5Lx=V3WfBBaMA@mail.gmail.com>
Subject: Re: [PATCH v4 03/18] KVM: arm64: selftests: Use read/write
 definitions from sysreg.h
To:     Andrew Jones <drjones@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 8, 2021 at 11:56 PM Andrew Jones <drjones@redhat.com> wrote:
>
> On Thu, Sep 09, 2021 at 01:38:03AM +0000, Raghavendra Rao Ananta wrote:
> > Make use of the register read/write definitions from
> > sysreg.h, instead of the existing definitions. A syntax
> > correction is needed for the files that use write_sysreg()
> > to make it compliant with the new (kernel's) syntax.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  .../selftests/kvm/aarch64/debug-exceptions.c  | 28 +++++++++----------
> >  .../selftests/kvm/include/aarch64/processor.h | 13 +--------
> >  2 files changed, 15 insertions(+), 26 deletions(-)
> >
>
> Same comment as Oliver, otherwise
>
Will fix.

Regards,
Raghavendra
> Reviewed-by: Andrew Jones <drjones@redhat.com>
>
