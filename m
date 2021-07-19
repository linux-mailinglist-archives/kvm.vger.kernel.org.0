Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61F8B3CEE6A
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 23:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388093AbhGSUmv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 16:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385395AbhGSS6z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 14:58:55 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01A5C0613E7
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 12:30:11 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id 8so32068656lfp.9
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 12:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wDda5dbFXyknFG+xoYFL2uxWIVC+IEB+7xC2zqUFwSc=;
        b=C2kt/tLjq50F2/8YiWA2vApdMGBU1c/5g8q0V7XaPGvDRnYu01eyxREz3eqyUTFPjo
         +RkvlkvZfYICjMHAI8gTK9GAf+/flWsUK+v7GAxtmc+xq9D5SUVbZ+DUZ9CiQxzMeanC
         YwYKYS3yuZmuX9KNoLodu1DiX6u9M1TDj8A4sNlA8pqZqXdGe8vk+eCXrW99r7bbq4xn
         aezOsvO51i/RTsOu+xwDKXdMBUxnzitKNY74AjA/4ymoyUgfBT077E45qJa7F/qXUBWW
         ztnTsieI6KT6/2V/OeLJPzcwydkdGfXsTY7HAJUxHWTKjw57wll20Q46XtDXCQNoAQ7m
         jF2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wDda5dbFXyknFG+xoYFL2uxWIVC+IEB+7xC2zqUFwSc=;
        b=BkGQWDcfT1A133PYAfqahJUjSuEX9NWyfWu2Hk/onqJnlUuXPE3bpAGtsptkCzz7lv
         5l4MnCBWGgHAdjRoDHLMHixRH+uE2S/vbVT92WnQewyMJuyBG/PZFcV7GC5dvb04OBDi
         t8NQrqQtNA8aTZBRhTDuBOKSBS6h2b9q8/B/x5o4S3t/fPkE4iYPj0NzuWWoXMKox9+P
         rts8f5o1T2UFFbYG++b1FhaBqyb+a5T5kUJX0l0yJII45j3f40wuxQnwHrkzkoLbaqp2
         8axGMK5BQD839bVAu7G0n7iTBTTe9wsqqGS3t5vBDrlRzCa2FJRn6EWgE+tX2Nd05wvp
         +lKw==
X-Gm-Message-State: AOAM530F10X6fkOPIlsbeXDdbQTbMRKg0cb7XhUZ/frD8ec5l7lHiqnt
        X49EKO9JQ/81nY2Xx8W8chfDd5q/mRBobz/Q6g15GQ==
X-Google-Smtp-Source: ABdhPJyPUYUhTA7ZwgH8jo3MfY2NUldDSUZwBUe+PjpACyXQEbBrAmTn2pGTqyellwWFMuv9G9LvWhR2OIXXWG8rOvc=
X-Received: by 2002:ac2:46d0:: with SMTP id p16mr19415538lfo.23.1626723483858;
 Mon, 19 Jul 2021 12:38:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210608154805.216869-1-jean-philippe@linaro.org>
 <c29ff5c8-9c94-6a6c-6142-3bed440676bf@arm.com> <YPW+Hv3r586zKxpY@myrica>
In-Reply-To: <YPW+Hv3r586zKxpY@myrica>
From:   Oliver Upton <oupton@google.com>
Date:   Mon, 19 Jul 2021 12:37:52 -0700
Message-ID: <CAOQ_QsjyP0PMGOorTss2Fpn011mHPwVqQ72x26Gs2L0bg2amsQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] KVM: arm64: Pass PSCI to userspace
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     Alexandru Elisei <Alexandru.Elisei@arm.com>,
        salil.mehta@huawei.com, lorenzo.pieralisi@arm.com,
        kvm@vger.kernel.org, corbet@lwn.net, maz@kernel.org,
        linux-kernel@vger.kernel.org, jonathan.cameron@huawei.com,
        catalin.marinas@arm.com, pbonzini@redhat.com, will@kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 19, 2021 at 11:02 AM Jean-Philippe Brucker
<jean-philippe@linaro.org> wrote:
> We forward the whole PSCI function range, so it's either KVM or userspace.
> If KVM manages PSCI and the guest calls an unimplemented function, that
> returns directly to the guest without going to userspace.
>
> The concern is valid for any other range, though. If userspace enables the
> HVC cap it receives function calls that at some point KVM might need to
> handle itself. So we need some negotiation between user and KVM about the
> specific HVC ranges that userspace can and will handle.

Are we going to use KVM_CAPs for every interesting HVC range that
userspace may want to trap? I wonder if a more generic interface for
hypercall filtering would have merit to handle the aforementioned
cases, and whatever else a VMM will want to intercept down the line.

For example, x86 has the concept of 'MSR filtering', wherein userspace
can specify a set of registers that it wants to intercept. Doing
something similar for HVCs would avoid the need for a kernel change
each time a VMM wishes to intercept a new hypercall.

--
Thanks,
Oliver
