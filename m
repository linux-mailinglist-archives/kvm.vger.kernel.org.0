Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65FB242745F
	for <lists+kvm@lfdr.de>; Sat,  9 Oct 2021 01:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243904AbhJHXvZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 19:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243797AbhJHXvY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 19:51:24 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B335C061570
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 16:49:29 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id u20-20020a9d7214000000b0054e170300adso13457763otj.13
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 16:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p+6RhTkQ284WnCu+Y+KA9bvKDb1KSKyyQaCPtzVRk6A=;
        b=Nkbgq7YEc1uvtvSSgX4z2rtmq7x8Wa3VPBmsoAEz5af5abE1/IUa9bMVsdPTweaZgn
         zFRXd3/j4f/yV9TXeHJmQKWBH7z2j7rikHV2WAqX93tr70YRx0mHIqf8T25vHiU/msP3
         9taKIWhXScqjVJKHohiuSRt2ExuDY4lUQH6/42kBd3QtS9K0Aan4frQ6gNChGAXHttZI
         ETZ5yYAyn8D/1jSLwikiynPJk9updRSljQcWZm5RaKAztiAa/J2t3U8AGZwLQGInR32c
         oFFbTF5T7STX6WxI867VhqTCDkEcWfE1qgmx3TYvc1+8ilXJh/cXb6PKXkmIrv5aWjW+
         zwcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p+6RhTkQ284WnCu+Y+KA9bvKDb1KSKyyQaCPtzVRk6A=;
        b=XKQJl2eFGLh3GCyXuW7r0ZFWUTkLHa4jljFPL04KzmfPIv6wSFbPkH17HoUgDBg1fE
         yBPYn+LRQ0BF5vm8F+bcs46lPgB9ecXHEIUa/pRYEL3HvrUJ1j2F0ZnQBwEt8LlUX80n
         nn/AHbooobOxsfnZZVXgbWpoHCrpmoUIU6WEiptNyCjIJhU8Y26PHZQtHtVQBwclap8X
         OP6DB7hFPc0W2rtECy8JYTSMoxEIOc93sQSxj9TxrVb8wJoyzSxbSpiykxVDTDbRNxVL
         9U0H0XMFB+a6C1RuCIkCv4s2qhUohvw6/dINZAMOdRUFzn6l0Xk0tdVhXq793U/M11WS
         xc2w==
X-Gm-Message-State: AOAM530dkb10hDOi/16kV/1nBE+VyUF6pkxf91UpQNI2A1AuqCcm6F77
        3sPVejGUwzD1HjCkPc63XuqqO2YItcizD8Whd7Czcw==
X-Google-Smtp-Source: ABdhPJy2ohqnuEm0OauvBNSQpPsXmV5T2Gl5iq8OY0VWaehIW9sTUS8Bg2nyBGU7pwkCaXZ+N20UsgjEbZK2L5Bgkxo=
X-Received: by 2002:a9d:458a:: with SMTP id x10mr11113582ote.267.1633736968042;
 Fri, 08 Oct 2021 16:49:28 -0700 (PDT)
MIME-Version: 1.0
References: <0b94844844521fc0446e3df0aa02d4df183f8107.camel@linux.intel.com>
 <YTI7K9RozNIWXTyg@google.com> <64aad01b6bffd70fa3170cf262fe5d7c66f6b2d4.camel@linux.intel.com>
 <YVx6Oesi7X3jfnaM@google.com> <CALMp9eRyhAygfh1piNEDE+WGVzK1cTWJJR1aC_zqn=c2fy+c-A@mail.gmail.com>
 <YVySdKOWTXqU4y3R@google.com> <CALMp9eQvRYpZg+G7vMcaCq0HYPDfZVpPtDRO9bRa0w2fyyU9Og@mail.gmail.com>
 <YVy6gj2+XsghsP3j@google.com> <CALMp9eT+uAvPv7LhJKrJGDN31-aVy6DYBrP+PUDiTk0zWuCX4g@mail.gmail.com>
 <YVzeJ59/yCpqgTX2@google.com> <20211008082302.txckaasmsystigeu@linux.intel.com>
 <85da4484902e5a4b1be645669c95dba7934d98b5.camel@linux.intel.com>
In-Reply-To: <85da4484902e5a4b1be645669c95dba7934d98b5.camel@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 8 Oct 2021 16:49:17 -0700
Message-ID: <CALMp9eTSkK2+-W8AVRdYv3MEsMKj-Xc2-v7DsavJRh5FLsVuCQ@mail.gmail.com>
Subject: Re: [PATCH v1 3/5] KVM: x86: nVMX: VMCS12 field's read/write respects
 field existence bitmap
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     Yu Zhang <yu.c.zhang@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We have some internal patches for virtualizing VMCS shadowing which
may break if there is a guest VMCS field with index greater than
VMX_VMCS_ENUM.MAX_INDEX. I plan to upstream them soon.

On Fri, Oct 8, 2021 at 8:09 AM Robert Hoo <robert.hu@linux.intel.com> wrote:
>
> On Fri, 2021-10-08 at 16:23 +0800, Yu Zhang wrote:
> > On Tue, Oct 05, 2021 at 11:22:15PM +0000, Sean Christopherson wrote:
> > > On Tue, Oct 05, 2021, Jim Mattson wrote:
> > > > On Tue, Oct 5, 2021 at 1:50 PM Sean Christopherson <
> > > > seanjc@google.com> wrote:
> > > > >
> > > > > On Tue, Oct 05, 2021, Jim Mattson wrote:
> > > > > > On Tue, Oct 5, 2021 at 10:59 AM Sean Christopherson <
> > > > > > seanjc@google.com> wrote:
> > > > > > >
> > > > > > > On Tue, Oct 05, 2021, Jim Mattson wrote:
> > > > > > > > On Tue, Oct 5, 2021 at 9:16 AM Sean Christopherson <
> > > > > > > > seanjc@google.com> wrote:
> > > > > > > > >
> > > > > > > > > On Tue, Sep 28, 2021, Robert Hoo wrote:
> > > > > > > > > > On Fri, 2021-09-03 at 15:11 +0000, Sean
> > > > > > > > > > Christopherson wrote:
> > > > > > > > > >       You also said, "This is quite the complicated
> > > > > > > > > > mess for
> > > > > > > > > > something I'm guessing no one actually cares
> > > > > > > > > > about.  At what point do
> > > > > > > > > > we chalk this up as a virtualization hole and sweep
> > > > > > > > > > it under the rug?"
> > > > > > > > > > -- I couldn't agree more.
> > > > > > > > >
> > > > > > > > > ...
> > > > > > > > >
> > > > > > > > > > So, Sean, can you help converge our discussion and
> > > > > > > > > > settle next step?
> > > > > > > > >
> > > > > > > > > Any objection to simply keeping KVM's current behavior,
> > > > > > > > > i.e. sweeping this under
> > > > > > > > > the proverbial rug?
> > > > > > > >
> > > > > > > > Adding 8 KiB per vCPU seems like no big deal to me, but,
> > > > > > > > on the other
> > > > > > > > hand, Paolo recently argued that slightly less than 1 KiB
> > > > > > > > per vCPU was
> > > > > > > > unreasonable for VM-exit statistics, so maybe I've got a
> > > > > > > > warped
> > > > > > > > perspective. I'm all for pedantic adherence to the
> > > > > > > > specification, but
> > > > > > > > I have to admit that no actual hypervisor is likely to
> > > > > > > > care (or ever
> > > > > > > > will).
> > > > > > >
> > > > > > > It's not just the memory, it's also the complexity, e.g. to
> > > > > > > get VMCS shadowing
> > > > > > > working correctly, both now and in the future.
> > > > > >
> > > > > > As far as CPU feature virtualization goes, this one doesn't
> > > > > > seem that
> > > > > > complex to me. It's not anywhere near as complex as
> > > > > > virtualizing MTF,
> > > > > > for instance, and KVM *claims* to do that! :-)
> > > > >
> > > > > There aren't many things as complex as MTF.  But unlike MTF,
> > > > > this behavior doesn't
> > > > > have a concrete use case to justify the risk vs. reward.  IMO
> > > > > the odds of us breaking
> > > > > something in KVM for "normal" use cases are higher than the
> > > > > odds of an L1 VMM breaking
> > > > > because a VMREAD/VMWRITE didn't fail when it technically should
> > > > > have failed.
> > > >
> > > > Playing devil's advocate here, because I totally agree with
> > > > you...
> > > >
> > > > Who's to say what's "normal"? It's a slippery slope when we start
> > > > making personal value judgments about which parts of the
> > > > architectural
> > > > specification are important and which aren't.
> > >
> > > I agree, but in a very similar case Intel chose to take an erratum
> > > instead of
> > > fixing what was in all likelihood a microcode bug, i.e. could have
> > > been patched
> > > in the field.  So it's not _just_ personal value judgment, though
> > > it's definitely
> > > that too :-)
> > >
> > > I'm not saying I'd actively oppose support for strict
> > > VMREAD/VMWRITE adherence
> > > to the vCPU model, but I'm also not going to advise anyone to go
> > > spend their time
> > > implementing a non-trivial fix for behavior that, AFAIK, doesn't
> > > adversely affect
> > > any real world use cases.
> > >
> >
> > Thank you all for the discussion, Sean & Jim.
> >
> > Could we draw a conclusion to just keep KVM as it is now? If yes, how
> > about we
> > depricate the check against max index value from
> > MSR_IA32_VMX_VMCS_ENUM in vmx.c
> > of the kvm-unit-test?
> >
> > After all, we have not witnessed any real system doing so.
> >
> > E.g.,
> >
> > diff --git a/x86/vmx.c b/x86/vmx.c
> > index f0b853a..63623e5 100644
> > --- a/x86/vmx.c
> > +++ b/x86/vmx.c
> > @@ -380,8 +380,7 @@ static void test_vmwrite_vmread(void)
> >         vmcs_enum_max = (rdmsr(MSR_IA32_VMX_VMCS_ENUM) &
> > VMCS_FIELD_INDEX_MASK)
> >                         >> VMCS_FIELD_INDEX_SHIFT;
> >         max_index = find_vmcs_max_index();
> > -       report(vmcs_enum_max == max_index,
> > -              "VMX_VMCS_ENUM.MAX_INDEX expected: %x, actual: %x",
> > +       printf("VMX_VMCS_ENUM.MAX_INDEX expected: %x, actual: %x",
> >                max_index, vmcs_enum_max);
> >
> >         assert(!vmcs_clear(vmcs));
> >
> > B.R.
> > Yu
>
> I think this patch series has its value of fixing the be-forced hard-
> code VMX_VMCS_ENUM.
> My understanding of Sean's "simply keeping KVM's current behavior, i.e.
> sweeping this under the proverbial rug", is about vmcs shadowing will
> fail some VMCS field validation. Of course, this in turn will fail some
> case of this KVM unit test case (theoretically), though we haven't met
> yet.
>
>
