Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC74148A366
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 00:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345622AbiAJXH0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 18:07:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345625AbiAJXHZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 18:07:25 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C78DC061748
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 15:07:25 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id g80so42547327ybf.0
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 15:07:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WXezCkJjRPkDROjmNSEXw8KrMNSVatQHflVa4NcIBZ4=;
        b=lT7ThlTt++QvhmmkculwEqKL3uXY7KHRlY1gZM6+NQiGlRD9ipXMMx4+mWy7E0i6H2
         YFeTMNWGyf/XiOMdm8cZbbHWziX6fKd2IX5qBjQCbpvC07ja4ugEzBJKzn05hpgC1SRR
         AekdfWmGnZEjHKsImuXfvSQZ+rOmhk9vwUrAEUMpqVXfV6b9OOJ/ps8P9VpNpvoHUrbT
         BzHh3EIH2sdChxnhiwiBSPlCNDGMnSqOv2qNVaeHVb7nIwPjGi/tvwQnkAh8FxtL726/
         Y35AUh+AK0fQZVMkhY7LAhlUFPIqR4ls8dFOHnDz2cos6MHdV42xAgbIurK7je8UGI33
         1ONA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WXezCkJjRPkDROjmNSEXw8KrMNSVatQHflVa4NcIBZ4=;
        b=InTmV26Z+QWbQSaKiCivsZBocTk4omila9Lh2isX2Jd5UctjrmhUjgZTPUcjeXWzll
         ROvIXKZl13R7uR0GDp90D93OuKL4Ri6v2qw/hxC7D99HmGXlAmIaWSOecbVD1P6rJpdh
         jdYfaH82les5jBncD40o5JCJxnsSZudOhw5YUP4w21/hipz6sIzgQghhMdyTUJW8ERSp
         GhfA2QzSbJFn2P6Da0e9yzKqg6gehrBAuS0ZsEoToLMphSPffWQHlIIkX5lB4wWjtbMh
         MHgjFaBF6opnLP+aSVghvbsFMLWma7B8FInqNBV357KkUrheBKGm+r8MlR+yM32mqUD5
         5NXA==
X-Gm-Message-State: AOAM530R/o/z3gxHroBRuYE2a2Bu8TCPo7WghVskZqUMpx0tPNsvphUm
        YONnwojH7UDdhl+3P87N3iUrVPcJMOEokLUcuASFHA==
X-Google-Smtp-Source: ABdhPJzBJzORsUZLGXrxCBMovCLT/oathXNs3w20UB7mc6qHjBQPdClWy2y/DJ7ReGsZVPvGVSjnvALfMbExKTvbbuk=
X-Received: by 2002:a25:b9d2:: with SMTP id y18mr1128156ybj.615.1641856044191;
 Mon, 10 Jan 2022 15:07:24 -0800 (PST)
MIME-Version: 1.0
References: <20220104194918.373612-1-rananta@google.com> <20220104194918.373612-2-rananta@google.com>
 <CAAeT=Fxyct=WLUvfbpROKwB9huyt+QdJnKTaj8c5NKk+UY51WQ@mail.gmail.com>
 <CAJHc60za+E-zEO5v2QeKuifoXznPnt5n--g1dAN5jgsuq+SxrA@mail.gmail.com> <CALMp9eQDzqoJMck=_agEZNU9FJY9LB=iW-8hkrRc20NtqN=gDA@mail.gmail.com>
In-Reply-To: <CALMp9eQDzqoJMck=_agEZNU9FJY9LB=iW-8hkrRc20NtqN=gDA@mail.gmail.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Mon, 10 Jan 2022 15:07:13 -0800
Message-ID: <CAJHc60xZ9emY9Rs9ZbV+AH-Mjmkyg4JZU7V16TF48C-HJn+n4A@mail.gmail.com>
Subject: Re: [RFC PATCH v3 01/11] KVM: Capture VM start
To:     Jim Mattson <jmattson@google.com>
Cc:     Reiji Watanabe <reijiw@google.com>, Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 7, 2022 at 4:05 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Fri, Jan 7, 2022 at 3:43 PM Raghavendra Rao Ananta
> <rananta@google.com> wrote:
> >
> > Hi Reiji,
> >
> > On Thu, Jan 6, 2022 at 10:07 PM Reiji Watanabe <reijiw@google.com> wrote:
> > >
> > > Hi Raghu,
> > >
> > > On Tue, Jan 4, 2022 at 11:49 AM Raghavendra Rao Ananta
> > > <rananta@google.com> wrote:
> > > >
> > > > Capture the start of the KVM VM, which is basically the
> > > > start of any vCPU run. This state of the VM is helpful
> > > > in the upcoming patches to prevent user-space from
> > > > configuring certain VM features after the VM has started
> > > > running.
>
> What about live migration, where the VM has already technically been
> started before the first call to KVM_RUN?

My understanding is that a new 'struct kvm' is created on the target
machine and this flag should be reset, which would allow the VMM to
restore the firmware registers. However, we would be running KVM_RUN
for the first time on the target machine, thus setting the flag.
So, you are right; It's more of a resume operation from the guest's
point of view. I guess the name of the variable is what's confusing
here.

Thanks,
Raghavendra
