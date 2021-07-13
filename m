Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5636C3C758F
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 19:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbhGMRPD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 13:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbhGMRPD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 13:15:03 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44EBBC0613E9
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 10:12:13 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id l26so29398712oic.7
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 10:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n5veVY6Aaqiwela1VTgvyQeZvKjk2HOBHm+S80Fosp4=;
        b=Nhq89+zvRlnrFJm1BqHy2q61n3E4rKBojKAwuo5+Qa8zsj2pSrQrpRfVTSJOXaoJl5
         L8UGZWVhp5tD0AAm5sf+gUxy+xgGFJCAlM3KqG/iQcLKfELoepqYj00fak8AE7PdDNIJ
         X1HwdiJXt4y0M/vxC/Ae1lUopA4jUnMDhSq7Kk2RjBm8cpSOLCtrz6AtrxxoSWV1lf/j
         uY0TO2Y3xNUDKhKVxkLlfonquQGTYQPH58yli+dCaol0USNrGgPl1FfRywN+wXn71hFw
         LgAeiSAQ0YaOinCG5pT9G1kEH1V5VJ8JHhFzMCuNI/UGj9SrQ2WHmS01984wlnqlbf9H
         LBBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n5veVY6Aaqiwela1VTgvyQeZvKjk2HOBHm+S80Fosp4=;
        b=iOh9CvVePOuk+GBqv3yrjQ/v8LVKkjTgDQi8FYyg3rXnFMoa6iKbz9T3pu5MSxnCb0
         3AVNOODmHjqzAD3uY6g+Yq9pQIsFf1Nr8j9A36nPqbOrz7qWdXPfDU44J4/2RI8xW8Dg
         BCwgvXLxsg/KDPTll0VhXJRL4AJaxRae5C0voMiCNrA9xLHa5+0U2lsDH6U6V8TWhyZ7
         QP0N595sJAwDN9j1xNnwNnLwhmXRhjepmyeGSGqba6PEjAhTbjgtIHtCmyyKrVxtwwgY
         BkKc3bIIrE+SU4nl4BhxcIfxqTGYJZso4GYJhmD9pArJyBANdqmtoXo5//0fvRDREXgx
         zCvQ==
X-Gm-Message-State: AOAM5319+c528fg84X/gCS/af48IAwmK4hPJMsYN/9bOos91hIPiCnY2
        gDKahZfx6O0g5o2pzRB+mr+GAoPDmFywG700zmXeDw==
X-Google-Smtp-Source: ABdhPJxi1iNIG51zOSsQQLi9TRZ3R+CvAU+7ctLD3c3G0E9vI40AtM+Vi9LVN+oWPPejUf7jhqENJxCd6j1HI1/thtg=
X-Received: by 2002:aca:1e07:: with SMTP id m7mr3825205oic.28.1626196332203;
 Tue, 13 Jul 2021 10:12:12 -0700 (PDT)
MIME-Version: 1.0
References: <1625825111-6604-1-git-send-email-weijiang.yang@intel.com>
 <1625825111-6604-7-git-send-email-weijiang.yang@intel.com>
 <CALMp9eQEs9pUyy1PpwLPG0_PtF07tR2Opw+1b=w4-knOwYPvvg@mail.gmail.com>
 <20210712095034.GD12162@intel.com> <CALMp9eQLHfXQwPCfqtc_y34sKGkZsCxEFL+BGx8wHgz7A8cOPA@mail.gmail.com>
 <20210713094713.GB13824@intel.com> <1be1fde6-37c5-4697-cff0-b15af419975e@gmail.com>
In-Reply-To: <1be1fde6-37c5-4697-cff0-b15af419975e@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 13 Jul 2021 10:12:00 -0700
Message-ID: <CALMp9eSTVVH1fZ361o0Zpf8A3AG24efqGhM6tnYAbv0M5xyhZw@mail.gmail.com>
Subject: Re: [PATCH v5 06/13] KVM: x86/vmx: Save/Restore host MSR_ARCH_LBR_CTL state
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        seanjc@google.com, vkuznets@redhat.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 13, 2021 at 3:16 AM Like Xu <like.xu.linux@gmail.com> wrote:
>
> On 13/7/2021 5:47 pm, Yang Weijiang wrote:
> > On Mon, Jul 12, 2021 at 10:23:02AM -0700, Jim Mattson wrote:
> >> On Mon, Jul 12, 2021 at 2:36 AM Yang Weijiang <weijiang.yang@intel.com> wrote:
> >>>
> >>> On Fri, Jul 09, 2021 at 03:54:53PM -0700, Jim Mattson wrote:
> >>>> On Fri, Jul 9, 2021 at 2:51 AM Yang Weijiang <weijiang.yang@intel.com> wrote:
> >>>>>
> >>>>> If host is using MSR_ARCH_LBR_CTL then save it before vm-entry
> >>>>> and reload it after vm-exit.
> >>>>
> >>>> I don't see anything being done here "before VM-entry" or "after
> >>>> VM-exit." This code seems to be invoked on vcpu_load and vcpu_put.
> >>>>
> >>>> In any case, I don't see why this one MSR is special. It seems that if
> >>>> the host is using the architectural LBR MSRs, then *all* of the host
> >>>> architectural LBR MSRs have to be saved on vcpu_load and restored on
> >>>> vcpu_put. Shouldn't  kvm_load_guest_fpu() and kvm_put_guest_fpu() do
> >>>> that via the calls to kvm_save_current_fpu(vcpu->arch.user_fpu) and
> >>>> restore_fpregs_from_fpstate(&vcpu->arch.user_fpu->state)?
> >>> I looked back on the discussion thread:
> >>> https://patchwork.kernel.org/project/kvm/patch/20210303135756.1546253-8-like.xu@linux.intel.com/
> >>> not sure why this code is added, but IMO, although fpu save/restore in outer loop
> >>> covers this LBR MSR, but the operation points are far away from vm-entry/exit
> >>> point, i.e., the guest MSR setting could leak to host side for a signicant
> >>> long of time, it may cause host side profiling accuracy. if we save/restore it
> >>> manually, it'll mitigate the issue signifcantly.
> >>
> >> I'll be interested to see how you distinguish the intermingled branch
> >> streams, if you allow the host to record LBRs while the LBR MSRs
> >> contain guest values!
>
> The guest is pretty fine that the real LBR MSRs contain the guest values
> even after vm-exit if there is no other LBR user in the current thread.
>
> (The perf subsystem makes this data visible only to the current thread)
>
> Except for MSR_ARCH_LBR_CTL, we don't want to add msr switch overhead to
> the vmx transaction (just think about {from, to, info} * 32 entries).
>
> If we have other LBR user (such as a "perf kvm") in the current thread,
> the host/guest LBR user will create separate LBR events to compete for
> who can use the LBR in the the current thread.
>
> The final arbiter is the host perf scheduler. The host perf will
> save/restore the contents of the LBR when switching between two
> LBR events.
>
> Indeed, if the LBR hardware is assigned to the host LBR event before
> vm-entry, then the guest LBR feature will be broken and a warning
> will be triggered on the host.

Are you saying that the guest LBR feature only works some of the time?
How are failures communicated to the guest? If this feature doesn't
follow the architectural specification, perhaps you should consider
offering a paravirtual feature instead.

Warnings on the host, by the way, are almost completely useless. How
do I surface such a warning to a customer who has a misbehaving VM? At
the very least, user space should be notified of KVM emulation errors,
so I can get an appropriate message to the customer.

> LBR is the kind of exclusive hardware resource and cannot be shared
> by different host/guest lbr_select configurations.

In that case, it definitely sounds like guest architectural LBRs
should be a paravirtual feature, since you can't actually virtualize
the hardware.

> > I'll check if an inner simplified xsave/restore to guest/host LBR MSRs is meaningful,
> > the worst case is to drop this patch since it's not correct to only enable host lbr ctl
> > while still leaves guest LBR data in the MSRs. Thanks for the reminder!
> >
