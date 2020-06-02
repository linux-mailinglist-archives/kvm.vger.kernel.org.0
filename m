Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 506DA1EC0FA
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 19:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgFBReE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 13:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725969AbgFBReD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jun 2020 13:34:03 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DFD9C05BD1E
        for <kvm@vger.kernel.org>; Tue,  2 Jun 2020 10:34:03 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id p5so12621994ile.6
        for <kvm@vger.kernel.org>; Tue, 02 Jun 2020 10:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a7kbNdp9/+TTRsp34LdUnr9ANQb5YeqZ5qFrQUOBSSM=;
        b=l1YjfjRDsCvg7vMJqjD4ww4Ar7Gbj/9EScwVL9TTSpChiR5lG3T7yW9nVyOP0eGj/L
         OHvB6VsOAynd5W4A1fkWzTba0RKL8PU0M6xct0kQR6tYZs4VHn7boNtk5dtJbAqnbhIU
         diIm+86/VYbqttYruwcM5+C7dcbcHLeIfp0tm9twGg3POuup4Zzj4tJroUJkD6AUgyac
         uoPC+yxZzTpICsPW4dit+wxtvD5p00JxzCAiZDKkhum5tBe9QP9O2SC0DNwp8abuKb7t
         Fovk3552LG/E4WkGjR6VIVcbQJh3czvNw4ZWatPK6+i37fy6qh8fZOJjg+B7LBl5hkWk
         Ybhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a7kbNdp9/+TTRsp34LdUnr9ANQb5YeqZ5qFrQUOBSSM=;
        b=pj23dyRijwRlti1VUcla/JvUeu6PRSG6Z6bD7obxj9qOeGWppzTRkx440ZDPFTFnee
         vKByEKltJn5jrBPsAsUhypxqWpooOJJBPdC4/JcZMq6e0IafOjd72ttvcHk/MK6kkh7Q
         VHxlUPe26rHKvg566dBW/e9UQrHWlG1u35Y5UtQjeKTolHywRItRiBhSn+noJlaZ5Ahx
         zUcrd+lvu1sqZWvtkNEj0BUoWP3pUvz7wPEfuuLkA7uitFH2zqtBlRCSj56YZT29gye+
         De+TK6GQ7iaTbvQFHFDZn33O66xXjqKIVEYEOjq45+NyT0G0D1F7aWhnKqSR5O95hS3q
         Icpw==
X-Gm-Message-State: AOAM533ASfIOidnTVrgE+rAYrspqGUHYd62er/WvRSNax6c3cMPCq6r9
        G0tjyE+vdcPZ84x+mgatz30ChdmzbVd747AW0TQ8hA3b
X-Google-Smtp-Source: ABdhPJwmVukUnP3qOc+xdAikJVLlF9Pyg0SwrugRxdVE/bYMkwPYUONixhx1fX4uranO8KgNPx4bk2/y9KnCE/JX1yA=
X-Received: by 2002:a92:5e4a:: with SMTP id s71mr421123ilb.119.1591119242474;
 Tue, 02 Jun 2020 10:34:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200601222416.71303-1-jmattson@google.com> <20200601222416.71303-4-jmattson@google.com>
 <20200602012139.GF21661@linux.intel.com>
In-Reply-To: <20200602012139.GF21661@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 2 Jun 2020 10:33:51 -0700
Message-ID: <CALMp9eS3XEVdZ-_pRsevOiKRBSbCr96saicxC+stPfUqsM1u1A@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] kvm: vmx: Add last_cpu to struct vcpu_vmx
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liran Alon <liran.alon@oracle.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 1, 2020 at 6:21 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Mon, Jun 01, 2020 at 03:24:15PM -0700, Jim Mattson wrote:
> > As we already do in svm, record the last logical processor on which a
> > vCPU has run, so that it can be communicated to userspace for
> > potential hardware errors.
> >
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > Reviewed-by: Oliver Upton <oupton@google.com>
> > Reviewed-by: Peter Shier <pshier@google.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 1 +
> >  arch/x86/kvm/vmx/vmx.h | 3 +++
> >  2 files changed, 4 insertions(+)
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 170cc76a581f..42856970d3b8 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -6730,6 +6730,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
> >       if (vcpu->arch.cr2 != read_cr2())
> >               write_cr2(vcpu->arch.cr2);
> >
> > +     vmx->last_cpu = vcpu->cpu;
>
> This is redundant in the EXIT_FASTPATH_REENTER_GUEST case.  Setting it
> before reenter_guest is technically wrong if emulation_required is true, but
> that doesn't seem like it'd be an issue in practice.

I really would like to capture the last logical processor to execute
VMLAUNCH/VMRESUME (or VMRUN on the AMD side) on behalf of this vCPU.

> >       vmx->fail = __vmx_vcpu_run(vmx, (unsigned long *)&vcpu->arch.regs,
> >                                  vmx->loaded_vmcs->launched);
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > index 672c28f17e49..8a1e833cf4fb 100644
> > --- a/arch/x86/kvm/vmx/vmx.h
> > +++ b/arch/x86/kvm/vmx/vmx.h
> > @@ -302,6 +302,9 @@ struct vcpu_vmx {
> >       u64 ept_pointer;
> >
> >       struct pt_desc pt_desc;
> > +
> > +     /* which host CPU was used for running this vcpu */
> > +     unsigned int last_cpu;
>
> Why not put this in struct kvm_vcpu_arch?  I'd also vote to name it
> last_run_cpu, as last_cpu is super misleading.

I think last_run_cpu may also be misleading, since in the cases of
interest, nothing actually 'ran.' Maybe last_attempted_vmentry_cpu?

> And if it's in arch, what about setting it vcpu_enter_guest?

As you point out above, this isn't entirely accurate. (But that's the
way we roll in kvm, isn't it? :-)

> >  };
> >
> >  enum ept_pointers_status {
> > --
> > 2.27.0.rc2.251.g90737beb825-goog
> >
