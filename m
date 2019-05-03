Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0552B12566
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 02:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbfECAWD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 May 2019 20:22:03 -0400
Received: from outprodmail01.cc.columbia.edu ([128.59.72.39]:59360 "EHLO
        outprodmail01.cc.columbia.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726128AbfECAWC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 May 2019 20:22:02 -0400
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
        by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id x430K9DQ013442
        for <kvm@vger.kernel.org>; Thu, 2 May 2019 20:22:00 -0400
Received: from hazelnut (localhost.localdomain [127.0.0.1])
        by hazelnut (Postfix) with ESMTP id C2C636D
        for <kvm@vger.kernel.org>; Thu,  2 May 2019 20:22:00 -0400 (EDT)
Received: from sendprodmail04.cc.columbia.edu (sendprodmail04.cc.columbia.edu [128.59.72.16])
        by hazelnut (Postfix) with ESMTP id AD4926D
        for <kvm@vger.kernel.org>; Thu,  2 May 2019 20:22:00 -0400 (EDT)
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        by sendprodmail04.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id x430LxFN051654
        (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 2 May 2019 20:22:00 -0400
Received: by mail-ed1-f71.google.com with SMTP id t58so2063406edb.22
        for <kvm@vger.kernel.org>; Thu, 02 May 2019 17:22:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mvpBSDDZkU5E9pNRCk0/jzMdoiPAGZAIwA7s43th+4c=;
        b=g4lmwZvJivf6iB6I0wa8YBhb0oAHnfJ7n0ZUvnckI9YtxysgQ0pvdYdbGYJGTxStOF
         krln1d4cUliEIgJNwCg/9ouHKwFJ3aFvrowScmFDcvzcghHfKjnt9y/y/f7HTceVTRW9
         ZN3tCtLqjwp12okW5DOfBr3S+UpvxoS+Vu3B1uaLKtUQICjYNTL3cTIsYz6ZvUfKo/h7
         9oblhzj5MAkaOUHW98Y+VsVzvTvmAkIB+d/BuXUVrrw16fkLWUVxVsbH3RQnesEjI9rH
         YU+xRtiYnrFDSUyCWRG+ewYCh6V9Mi1qvo0O70d0cSZGj9CG62AXTyiPIoKrmtYxxRmc
         FUUg==
X-Gm-Message-State: APjAAAXkt8hIFTt3cyPVlDHeh3GoYbrdt8QzIWkHhOGjAN+Z8VXeZb3I
        l2RDweQjkBVj3s/OF+LhVWtw4tOBnlPOp3Ork1HwgyG9T+wOcY6ANfED2RWHofG5ZyC8uCwofpU
        hI59HMyF3BFdKrWXEdDM0
X-Received: by 2002:a50:9007:: with SMTP id b7mr3976561eda.194.1556842919200;
        Thu, 02 May 2019 17:21:59 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxHyyly0rEkGFceJzlTv2oqAcU7uwzcuyjUL1lsmTlt3Yi9IOLsTEBsk0SIz2f9Ewhq6bwExw==
X-Received: by 2002:a50:9007:: with SMTP id b7mr3976550eda.194.1556842919061;
        Thu, 02 May 2019 17:21:59 -0700 (PDT)
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com. [209.85.221.44])
        by smtp.gmail.com with ESMTPSA id x18sm117128ejd.66.2019.05.02.17.21.57
        for <kvm@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 17:21:58 -0700 (PDT)
Received: by mail-wr1-f44.google.com with SMTP id k16so5653083wrn.5
        for <kvm@vger.kernel.org>; Thu, 02 May 2019 17:21:57 -0700 (PDT)
X-Received: by 2002:adf:ef8c:: with SMTP id d12mr1257712wro.320.1556842917771;
 Thu, 02 May 2019 17:21:57 -0700 (PDT)
MIME-Version: 1.0
References: <1556762959-31705-1-git-send-email-jintack@cs.columbia.edu> <20190502150315.GB26138@linux.intel.com>
In-Reply-To: <20190502150315.GB26138@linux.intel.com>
From:   Jintack Lim <jintack@cs.columbia.edu>
Date:   Thu, 2 May 2019 20:21:46 -0400
X-Gmail-Original-Message-ID: <CAHyh4xihsS6xhGdVQPmNHt3Ugp3pM0oMdio2rr-WFaGeTLj5Hg@mail.gmail.com>
Message-ID: <CAHyh4xihsS6xhGdVQPmNHt3Ugp3pM0oMdio2rr-WFaGeTLj5Hg@mail.gmail.com>
Subject: Re: [PATCH] KVM: nVMX: Set msr bitmap correctly for MSR_FS_BASE in vmcs02
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     KVM General <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-No-Spam-Score: Local
X-Scanned-By: MIMEDefang 2.84 on 128.59.72.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 2, 2019 at 11:03 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> +Cc Jim
>
> On Wed, May 01, 2019 at 10:09:19PM -0400, Jintack Lim wrote:
> > Even when neither L0 nor L1 configured to trap MSR_FS_BASE writes from
> > its own VMs, the current KVM L0 always traps MSR_FS_BASE writes from L2.
> > Let's check if both L0 and L1 disabled trap for MSR_FS_BASE for its VMs
> > respectively, and let L2 write to MSR_FS_BASE without trap if that's the
> > case.
> >
> > Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
> > ---
> >  arch/x86/kvm/vmx/nested.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 0c601d0..ab85aea 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -537,6 +537,7 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
> >        */
> >       bool pred_cmd = !msr_write_intercepted_l01(vcpu, MSR_IA32_PRED_CMD);
> >       bool spec_ctrl = !msr_write_intercepted_l01(vcpu, MSR_IA32_SPEC_CTRL);
> > +     bool fs_base = !msr_write_intercepted_l01(vcpu, MSR_FS_BASE);
>
> This isn't sufficient as we only fall into this code if L2 is in x2APIC
> mode or has accessed the speculation MSRs.  The quick fix is to check if
> we want to pass through MSR_FS_BASE, but if we're going to open up the
> floodgates then we should pass through as many MSRs as possible, e.g.
> GS_BASE, KERNEL_GS_BASE, TSC, SYSENTER_*, etc..., and do so using a
> generic mechanism.
>
> That being said, I think there are other reasons why KVM doesn't pass
> through MSRs to L2.  Unfortunately, I'm struggling to recall what those
> reasons are.
>
> Jim, I'm pretty sure you've looked at this code a lot, do you happen to
> know off hand?  Is it purely a performance thing to avoid merging bitmaps
> on every nested entry, is there a subtle bug/security hole, or is it
> simply that no one has ever gotten around to writing the code?
>
> >
> >       /* Nothing to do if the MSR bitmap is not in use.  */
> >       if (!cpu_has_vmx_msr_bitmap() ||
> > @@ -592,6 +593,12 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
> >               }
> >       }
> >
> > +     if (fs_base)
> > +             nested_vmx_disable_intercept_for_msr(
> > +                                     msr_bitmap_l1, msr_bitmap_l0,
> > +                                     MSR_FS_BASE,
> > +                                     MSR_TYPE_W);
>
> This should be MSR_TYPE_RW.

Should I explicitly check if L1 disabled intercept for read operations
along with write operations?

It seems like the current code only checks write operations for
spec_ctrl while it disables intercept for RW. This is not the case for
pred_cmd, though. I might be missing something here. Could you explain
it?

>
> > +
> >       if (spec_ctrl)
> >               nested_vmx_disable_intercept_for_msr(
> >                                       msr_bitmap_l1, msr_bitmap_l0,
> > --
> > 1.9.1
> >
> >
>

