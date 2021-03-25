Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5AB3492F6
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 14:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbhCYNSW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 09:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbhCYNSH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 09:18:07 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F76C06174A;
        Thu, 25 Mar 2021 06:18:07 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id ce10so2846680ejb.6;
        Thu, 25 Mar 2021 06:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kn6Rs3ZyKaxJyTUe4ToXQORRNUfNJ+kfvLe6bzjFTIE=;
        b=OlJjwEdru1gspB1qdTLRNVSVcJeyyzS6kRz8jBHMSI9K9lUKfpZlM01XZuQYLcKL5C
         UdCe7mAu29/pNA71F7ovXhAIFCVGa3X63cujZ/Q9dJyEre4pJnhvg++cPLXYek9CtodV
         rubxkx1PpToPgs3cQAs2GKuN5T7Z4WYINm+bvGxoDhZ0m500JBqEWacCPoW0jn7EFJNH
         28XephHeO7cErYSW8/kH1t2nHXNgvwKq/Ov+4g43PZjZ0tj68CYu66iFF86+PZzD87q7
         uIRS2QIwIZnxEzJpdYVk/p+jxmIxHK7vSMGtp7QqHiSZqOoK1kMmBXBr4MK7bXZZh1n6
         ncig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kn6Rs3ZyKaxJyTUe4ToXQORRNUfNJ+kfvLe6bzjFTIE=;
        b=WzYcHanXln9M0AzctcM7FjrxM3jBbToYmEwncAs45vtOLU13dYdWnA4qCb6sxkxa4U
         RUoULU90iA7iPHTMTjU8ojiTPIZVzmRwMFqQpMedELPa5bkWIt8phNB6sM7/mHguXqCE
         aLVi7cFliYYtQynO4TdIxcaDa/O6XcuOtC6L+cfYTwXc4HzI1UOWN2o1kJOW81otGUyA
         oZ9/c0ODUH6/SREFL/YC4V2Yi76Cbkl78ku5Kq9KnztYP1pLvTLgjgL0n/MSh/MDEc+D
         1Yf31ZOTt93JgA0jXsefav+8VPQXlrYVYL0tgV1ZLTd7OXlupx/k87hZ0taAbRmVEEFu
         zebw==
X-Gm-Message-State: AOAM532Z4Q5vLFRy7LTBzXNDQhookURgrw1wZ42Qe21468Q6Kj8xLpIf
        8gKP/ccOSpOWNaHuxMWUHT7ALTCay4qFuALLAA==
X-Google-Smtp-Source: ABdhPJwaswh2XK6LRzaqp0vXAXoWNB7/HBMjqfnpBw9W8lUg3StOIdDVWbvIovfensVeQZEoPgdjnVBP8+2uzK0q7js=
X-Received: by 2002:a17:906:3c46:: with SMTP id i6mr9567894ejg.80.1616678285828;
 Thu, 25 Mar 2021 06:18:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210313051032.4171-1-lihaiwei.kernel@gmail.com> <4b51bbfd-66f6-1593-3718-9789f9179a2f@huawei.com>
In-Reply-To: <4b51bbfd-66f6-1593-3718-9789f9179a2f@huawei.com>
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Date:   Thu, 25 Mar 2021 21:17:27 +0800
Message-ID: <CAB5KdObg_G9aoBCzjmTetwUb9+23spm3=RKw8SUCfntUf=q-aA@mail.gmail.com>
Subject: Re: [PATCH] KVM: clean up the unused argument
To:     Keqian Zhu <zhukeqian1@huawei.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kindly ping. :)

On Mon, Mar 15, 2021 at 12:40 PM Keqian Zhu <zhukeqian1@huawei.com> wrote:
>
>
> This looks OK. The use of vcpu argument is removed in commit d383b3146d80 (KVM: x86: Fix NULL dereference at kvm_msr_ignored_check())
>
> Reviewed-by: Keqian Zhu <zhukeqian1@huawei.com>
>
> On 2021/3/13 13:10, lihaiwei.kernel@gmail.com wrote:
> > From: Haiwei Li <lihaiwei@tencent.com>
> >
> > kvm_msr_ignored_check function never uses vcpu argument. Clean up the
> > function and invokers.
> >
> > Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
> > ---
> >  arch/x86/kvm/x86.c | 9 ++++-----
> >  1 file changed, 4 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 012d5df..27e9ee8 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -271,8 +271,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
> >   * When called, it means the previous get/set msr reached an invalid msr.
> >   * Return true if we want to ignore/silent this failed msr access.
> >   */
> > -static bool kvm_msr_ignored_check(struct kvm_vcpu *vcpu, u32 msr,
> > -                               u64 data, bool write)
> > +static bool kvm_msr_ignored_check(u32 msr, u64 data, bool write)
> >  {
> >       const char *op = write ? "wrmsr" : "rdmsr";
> >
> > @@ -1447,7 +1446,7 @@ static int do_get_msr_feature(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
> >       if (r == KVM_MSR_RET_INVALID) {
> >               /* Unconditionally clear the output for simplicity */
> >               *data = 0;
> > -             if (kvm_msr_ignored_check(vcpu, index, 0, false))
> > +             if (kvm_msr_ignored_check(index, 0, false))
> >                       r = 0;
> >       }
> >
> > @@ -1613,7 +1612,7 @@ static int kvm_set_msr_ignored_check(struct kvm_vcpu *vcpu,
> >       int ret = __kvm_set_msr(vcpu, index, data, host_initiated);
> >
> >       if (ret == KVM_MSR_RET_INVALID)
> > -             if (kvm_msr_ignored_check(vcpu, index, data, true))
> > +             if (kvm_msr_ignored_check(index, data, true))
> >                       ret = 0;
> >
> >       return ret;
> > @@ -1651,7 +1650,7 @@ static int kvm_get_msr_ignored_check(struct kvm_vcpu *vcpu,
> >       if (ret == KVM_MSR_RET_INVALID) {
> >               /* Unconditionally clear *data for simplicity */
> >               *data = 0;
> > -             if (kvm_msr_ignored_check(vcpu, index, 0, false))
> > +             if (kvm_msr_ignored_check(index, 0, false))
> >                       ret = 0;
> >       }
> >
> >
