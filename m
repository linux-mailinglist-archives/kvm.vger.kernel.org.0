Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E37E93F7285
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 12:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239873AbhHYKD3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 06:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239879AbhHYKD2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 06:03:28 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC5F3C0613CF
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 03:02:42 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id d16so42639893ljq.4
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 03:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k3coRg+J3p197hAlCFr3Vj1C8Vm9KFllOcMKF9YzS/k=;
        b=cUCTblyL7c27KuwJuwJwQBvBF+zGyPs1LoT5cyb1NhbCWvEsgHwTS6wl/PEiO303Cw
         gJJRULtOxqWElvOp/NXfn3kI0QPgq+csxIwej+GRq71MCI3wyIBEn/NSVB5tGFwkPTnf
         EneqBzFzs7qVMGE6nDOBtyHlV05OrOVkJrrFQRsTt6bN+W3F4qdDcU3CECaFf7f361Bf
         1n3XgDV0zWubWVCGgT9pAkYKSmZbCqQ4no8593xoWzxgPxA10aBBCLfWQHVouS8qAIi3
         Bn4IfggRl6ekReQHAd5BL0gQO2jxUhFREzZdRfO+rqE3AYViw3ewVvcz8UcBzrbHNc58
         Kz0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k3coRg+J3p197hAlCFr3Vj1C8Vm9KFllOcMKF9YzS/k=;
        b=rG+ACz3ac7rR2Z7V6QicpDcdkByf0RopDQt7DtG46ZXNmmlca880aXTlkS0ZBeym61
         p2OGr6tca7j7cYw6kc81bAVSguFTbrRS0YucetzFZRjvuFGKjvCCODoPQC126PTaCuyf
         teyA7W+mqdweiiZGRmDzmYPZ8N1XwDwWZlEIpxFBSI+spo6KXfy+1TT6B8xKTZLdlkB9
         mFxxn0DN/aj5c/Ja0q1Qo3aeRk5ZA/V9/DZap/2WDEc6xkrBcymDqGRuyWOosXyZ2vnh
         451zvji7d7IyolkRuZ781BShneLrwqvMh6scVkonBFUma/v56VXyAef54alzFuwuuSHy
         RwKA==
X-Gm-Message-State: AOAM532x6rk/n7WmfRfr/Yuw6GPI0aTzvIburoCBTABYB0D6d7FPjDuW
        y8uQrSlrP0J7icE8wqCfgGLEqE8upkA6qQ8RGvUAtA==
X-Google-Smtp-Source: ABdhPJwvsAjsRykTCreTtC16fO1xL5nuWVpWNxzP6GpLgqqYLx9mvjmH2w0HkFOJ93i9pThzDyeIsCSDi55qWS19CpY=
X-Received: by 2002:a05:651c:33b:: with SMTP id b27mr36824255ljp.314.1629885759909;
 Wed, 25 Aug 2021 03:02:39 -0700 (PDT)
MIME-Version: 1.0
References: <YSVhV+UIMY12u2PW@google.com> <87mtp5q3gx.wl-maz@kernel.org>
In-Reply-To: <87mtp5q3gx.wl-maz@kernel.org>
From:   Oliver Upton <oupton@google.com>
Date:   Wed, 25 Aug 2021 03:02:28 -0700
Message-ID: <CAOQ_QshSaEm_cMYQfRTaXJwnVqeoN29rMLBej-snWd6_0HsgGw@mail.gmail.com>
Subject: Re: KVM/arm64: Guest ABI changes do not appear rollback-safe
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, pshier@google.com,
        ricarkol@google.com, rananta@google.com, reijiw@google.com,
        jingzhangos@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
        Alexandru.Elisei@arm.com, suzuki.poulose@arm.com,
        Drew Jones <drjones@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 25, 2021 at 2:27 AM Marc Zyngier <maz@kernel.org> wrote:
> > Exposing new hypercalls to guests in this manner seems very unsafe to
> > me. Suppose an operator is trying to upgrade from kernel N to kernel
> > N+1, which brings in the new 'widget' hypercall. Guests are live
> > migrated onto the N+1 kernel, but the operator finds a defect that
> > warrants a kernel rollback. VMs are then migrated from kernel N+1 -> N.
> > Any guests that discovered the 'widget' hypercall are likely going to
> > get fussy _very_ quickly on the old kernel.
>
> This goes against what we decided to support for the *only* publicly
> available VMM that cares about save/restore, which is that we only
> move forward and don't rollback.

Ah, I was definitely missing this context. Current behavior makes much
more sense then.

> Hypercalls are the least of your
> worries, and there is a whole range of other architectural features
> that will have also appeared/disappeared (your own CNTPOFF series is a
> glaring example of this).

Isn't that a tad bit different though? I'll admit, I'm just as guilty
with my own series forgetting to add a KVM_CAP (oops), but it is in my
queue to kick out with the fix for nVHE/ptimer. Nonetheless, if a user
takes up a new KVM UAPI, it is up to the user to run on a new kernel.

My concerns are explicitly with the 'under the nose' changes, where
KVM modifies the guest feature set without userspace opting in. Based
on your comment, though, it would appear that other parts of KVM are
affected too. It doesn't have to be rollback safety, either. There may
simply be a hypercall which an operator doesn't want to give its
guests, and it needs a way to tell KVM to hide it.

> > Have I missed something blatantly obvious, or do others see this as an
> > issue as well? I'll reply with an example of adding opt-out for PTP.
> > I'm sure other hypercalls could be handled similarly.
>
> Why do we need this? For future hypercalls, we could have some buy-in
> capabilities. For existing ones, it is too late, and negative features
> are just too horrible.

Oh, agreed on the nastiness. Lazy hack to realize the intended
functional change..

> For KVM-specific hypercalls, we could get the VMM to save/restore the
> bitmap of supported functions. That would be "less horrible". This
> could be implemented using extra "firmware pseudo-registers" such as
> the ones described in Documentation/virt/kvm/arm/psci.rst.

This seems more reasonable, especially since we do this for migrating
the guest's PSCI version.

Alternatively, I had thought about using a VM attribute, given the
fact that it is non-architectural information and we avoid ABI issues
in KVM_GET_REG_LIST without buy-in through a KVM_CAP.

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
