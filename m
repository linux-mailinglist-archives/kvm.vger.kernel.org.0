Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C82011EA9
	for <lists+kvm@lfdr.de>; Thu,  2 May 2019 17:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbfEBPjQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 May 2019 11:39:16 -0400
Received: from outprodmail02.cc.columbia.edu ([128.59.72.51]:35020 "EHLO
        outprodmail02.cc.columbia.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727498AbfEBPjP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 May 2019 11:39:15 -0400
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
        by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id x42FcdNP041940
        for <kvm@vger.kernel.org>; Thu, 2 May 2019 11:39:13 -0400
Received: from hazelnut (localhost.localdomain [127.0.0.1])
        by hazelnut (Postfix) with ESMTP id BFCD07E
        for <kvm@vger.kernel.org>; Thu,  2 May 2019 11:39:13 -0400 (EDT)
Received: from sendprodmail03.cc.columbia.edu (sendprodmail03.cc.columbia.edu [128.59.72.15])
        by hazelnut (Postfix) with ESMTP id 87C437E
        for <kvm@vger.kernel.org>; Thu,  2 May 2019 11:39:13 -0400 (EDT)
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        by sendprodmail03.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id x42FdCPg058118
        (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 2 May 2019 11:39:13 -0400
Received: by mail-ed1-f71.google.com with SMTP id t58so1250366edb.22
        for <kvm@vger.kernel.org>; Thu, 02 May 2019 08:39:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=40ETRYBmUagyAtSHXk2N59zJo5vD9yEg1DQrF+dpAxI=;
        b=itJbAa10+KDjjos6A43getPPWOdrTvQpn0cQBef56TeHpK+K3bYTPiPdoTtA4DUP2J
         4yz9vxN6PCbX84F45O4nArZjWJlYtHQgHW2r0GeiewzPpidoMdGamtw7AAH6/p7uXqh0
         3fYGlQIHARwuLFGfREkhMzcBmyuDPTMmTf3izG0IpVi3gApnYAPuDmCy7z7JbCRO0GAn
         ET/gmcZHMbZo3RAryX6FKWmYWFRNOZDI+P0WdozfDnThPV8L5bxjbVLM8F6s1xn7mwbX
         XBIp5jkIvG9D3QRKa5GKTvl9kf2FveoZgfuWfsIumwf/AxmzIEmAcGsEevezPSXduhil
         kj4w==
X-Gm-Message-State: APjAAAU5mEG5tQtA3GFN3qTopVW1amphx9SJ14xQpQ5bsR/OS89lWBHp
        UDVjTXwKHmHb7BaTsg7c0nyRrYjItlKBYTY4egxx8yJCLXh+mkx8RgJ6fra7HS/7iwbWc+zpfOu
        +jN/nIkCjJZrhGhYIEcna
X-Received: by 2002:a50:a953:: with SMTP id m19mr3014104edc.93.1556811552371;
        Thu, 02 May 2019 08:39:12 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyrtb5AuEAMDsVNZL3B/+3zANIZYDzaykwI/pOXNXnnoYlF0EpxW43L7sqhyVf6HzMolNcU0A==
X-Received: by 2002:a50:a953:: with SMTP id m19mr3014093edc.93.1556811552218;
        Thu, 02 May 2019 08:39:12 -0700 (PDT)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com. [209.85.221.54])
        by smtp.gmail.com with ESMTPSA id g32sm5525964ede.88.2019.05.02.08.39.11
        for <kvm@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 08:39:11 -0700 (PDT)
Received: by mail-wr1-f54.google.com with SMTP id a12so3986440wrq.10
        for <kvm@vger.kernel.org>; Thu, 02 May 2019 08:39:11 -0700 (PDT)
X-Received: by 2002:a5d:6a04:: with SMTP id m4mr2372667wru.84.1556811551280;
 Thu, 02 May 2019 08:39:11 -0700 (PDT)
MIME-Version: 1.0
References: <1556762959-31705-1-git-send-email-jintack@cs.columbia.edu> <20190502150315.GB26138@linux.intel.com>
In-Reply-To: <20190502150315.GB26138@linux.intel.com>
From:   Jintack Lim <jintack@cs.columbia.edu>
Date:   Thu, 2 May 2019 11:39:00 -0400
X-Gmail-Original-Message-ID: <CAHyh4xgcGKtCqDdfqb6343nawGHYv=Jo-he1xPZQAiYkJM4bAw@mail.gmail.com>
Message-ID: <CAHyh4xgcGKtCqDdfqb6343nawGHYv=Jo-he1xPZQAiYkJM4bAw@mail.gmail.com>
Subject: Re: [PATCH] KVM: nVMX: Set msr bitmap correctly for MSR_FS_BASE in vmcs02
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     KVM General <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-No-Spam-Score: Local
X-Scanned-By: MIMEDefang 2.84 on 128.59.72.15
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

Thanks Sean for the review.

I agree that the fix should be passing through as many MSRs as possible.

>
> That being said, I think there are other reasons why KVM doesn't pass
> through MSRs to L2.  Unfortunately, I'm struggling to recall what those
> reasons are.

I'm also curious if there are other reasons!

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

