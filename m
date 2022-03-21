Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA3644E331F
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 23:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbiCUWvb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 18:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbiCUWvZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 18:51:25 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BB438D2A7
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 15:42:11 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id s207so17782768oie.11
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 15:42:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cWpcGr+6ZtCAxiOUcLCZPyeMFzj0VHLkO5iJ3VF02f4=;
        b=oPx98dOIQ/h3ttHAG6/6YwYcqg7z9+fT8e3p530qSb0AGiFlCEiUBJAA/XHPNn4av5
         IrNtz8J9D20C6CiPUqebgtBCtysnGTdWktCDdQQs23F09r5EekY59q/QOGyFZmB1xxfW
         iPiRF6qWA438fV0Atp3T6GDy4p3WkKjn3pXPJY8DftTvsoIYnhx3dewT0KiDW7OdVKd2
         D5jkB0If67Rs4Rb9WKLpYB9DEaiUmVpxgcsD6wURVIpcpxYxfvS9JbQjxsYeNeAONUGC
         sCJiC5kqVR6g0fxwD0pkSb8T3MyE4sKdLwkPLYGUzH0GZJBZwRKxR5SuRgv3+eWXj/8S
         Db2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cWpcGr+6ZtCAxiOUcLCZPyeMFzj0VHLkO5iJ3VF02f4=;
        b=un7sR9SWBVwEC/3EmcQuGkJdKf9hS8feze+WNNUja0lpaiugQDBKgaTPVkInPuv88P
         A+rlkUZKP5wzb71HGUMp+zBWiIxcJ6hGX9CIgct1/ancOFmjUc/gI4BLcER6cGl98hkZ
         mQwd2IzoAn/CF78Syx0HE7a/E8B3c792E85K2EhiUfL7+iXhFqgN7cePm/HxsCVjbUcL
         6oO6Hgto4OQc29oXD/e6DUtZDA4U80894UhO0Eg9soFRy5RXkG7VeNOdypi0CWR9sc6E
         YdQuIwuhLnBaiwQkJVYeLaa1nuPV/+UL9hlDPhI5d9kfgtoAab0g0wa3PUJmgu79usi4
         W2mQ==
X-Gm-Message-State: AOAM533cGM55vg9bIl3g7yO+rIfMDfJb3Vdg8bpw4f7XAMwP0DZpTbpn
        u4HPWh2CUI1KBm3nA5RzmosBZAhd1k4PtBeITpNLNg==
X-Google-Smtp-Source: ABdhPJzmp3+qClIwuDyUCvItf45iFI8+VRyansEFfvpBFMcmDrxdR8LgWMKyewhdXFB3NkgmvKZ4FjVRRZQaygCfEtc=
X-Received: by 2002:a05:6808:118d:b0:2d9:a01a:48c2 with SMTP id
 j13-20020a056808118d00b002d9a01a48c2mr698989oil.269.1647902530829; Mon, 21
 Mar 2022 15:42:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220301143650.143749-1-mlevitsk@redhat.com> <20220301143650.143749-5-mlevitsk@redhat.com>
 <CALMp9eRjY6sX0OEBeYw4RsQKSjKvXKWOqRe=GVoQnmjy6D8deg@mail.gmail.com>
 <6a7f13d1-ed00-b4a6-c39b-dd8ba189d639@redhat.com> <CALMp9eRRT6pi6tjZvsFbEhrgS+zsNg827iLD4Hvzsa4PeB6W-Q@mail.gmail.com>
 <abe8584fa3691de1d6ae6c6617b8ea750b30fd1c.camel@redhat.com>
 <CALMp9eSUSexhPWMWXE1HpSD+movaYcdge_J95LiLCnJyMEp3WA@mail.gmail.com> <8071f0f0a857b0775f1fb2d1ebd86ffc4fd9096b.camel@redhat.com>
In-Reply-To: <8071f0f0a857b0775f1fb2d1ebd86ffc4fd9096b.camel@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 21 Mar 2022 15:41:59 -0700
Message-ID: <CALMp9eQgDpL0eD_GZde-s+THPWvQ0v6kmj3z_023f_KPERAyyA@mail.gmail.com>
Subject: Re: [PATCH v3 4/7] KVM: x86: nSVM: support PAUSE filter threshold and
 count when cpu_pm=on
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 21, 2022 at 3:11 PM Maxim Levitsky <mlevitsk@redhat.com> wrote:
>
> On Mon, 2022-03-21 at 14:59 -0700, Jim Mattson wrote:
> > On Mon, Mar 21, 2022 at 2:36 PM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> > > On Wed, 2022-03-09 at 11:07 -0800, Jim Mattson wrote:
> > > > On Wed, Mar 9, 2022 at 10:47 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > > > > On 3/9/22 19:35, Jim Mattson wrote:
> > > > > > I didn't think pause filtering was virtualizable, since the value of
> > > > > > the internal counter isn't exposed on VM-exit.
> > > > > >
> > > > > > On bare metal, for instance, assuming the hypervisor doesn't intercept
> > > > > > CPUID, the following code would quickly trigger a PAUSE #VMEXIT with
> > > > > > the filter count set to 2.
> > > > > >
> > > > > > 1:
> > > > > > pause
> > > > > > cpuid
> > > > > > jmp 1
> > > > > >
> > > > > > Since L0 intercepts CPUID, however, L2 will exit to L0 on each loop
> > > > > > iteration, and when L0 resumes L2, the internal counter will be set to
> > > > > > 2 again. L1 will never see a PAUSE #VMEXIT.
> > > > > >
> > > > > > How do you handle this?
> > > > > >
> > > > >
> > > > > I would expect that the same would happen on an SMI or a host interrupt.
> > > > >
> > > > >         1:
> > > > >         pause
> > > > >         outl al, 0xb2
> > > > >         jmp 1
> > > > >
> > > > > In general a PAUSE vmexit will mostly benefit the VM that is pausing, so
> > > > > having a partial implementation would be better than disabling it
> > > > > altogether.
> > > >
> > > > Indeed, the APM does say, "Certain events, including SMI, can cause
> > > > the internal count to be reloaded from the VMCB." However, expanding
> > > > that set of events so much that some pause loops will *never* trigger
> > > > a #VMEXIT seems problematic. If the hypervisor knew that the PAUSE
> > > > filter may not be triggered, it could always choose to exit on every
> > > > PAUSE.
> > > >
> > > > Having a partial implementation is only better than disabling it
> > > > altogether if the L2 pause loop doesn't contain a hidden #VMEXIT to
> > > > L0.
> > > >
> > >
> > > Hi!
> > >
> > > You bring up a very valid point, which I didn't think about.
> > >
> > > However after thinking about this, I think that in practice,
> > > this isn't a show stopper problem for exposing this feature to the guest.
> > >
> > >
> > > This is what I am thinking:
> > >
> > > First lets assume that the L2 is malicious. In this case no doubt
> > > it can craft such a loop which will not VMexit on PAUSE.
> > > But that isn't a problem - instead of this guest could have just used NOP
> > > which is not possible to intercept anyway - no harm is done.
> > >
> > > Now lets assume a non malicious L2:
> > >
> > >
> > > First of all the problem can only happen when a VM exit is intercepted by L0,
> > > and not by L1. Both above cases usually don't pass this criteria since L1 is highly
> > > likely to intercept both CPUID and IO port access. It is also highly unlikely
> > > to allow L2 direct access to L1's mmio ranges.
> > >
> > > Overall there are very few cases of deterministic vm exit which is intercepted
> > > by L0 but not L1. If that happens then L1 will not catch the PAUSE loop,
> > > which is not different much from not catching it because of not suitable
> > > thresholds.
> > >
> > > Also note that this is an optimization only - due to count and threshold,
> > > it is not guaranteed to catch all pause loops - in fact hypervisor has
> > > to guess these values, and update them in attempt to catch as many such
> > > loops as it can.
> > >
> > > I think overall it is OK to expose that feature to the guest
> > > and it should even improve performance in some cases - currently
> > > at least nested KVM intercepts every PAUSE otherwise.
> >
> > Can I at least request that this behavior be documented as a KVM
> > virtual CPU erratum?
>
> 100%. Do you have a pointer where to document it?

I think this will be the first KVM virtual CPU erratum documented,
though there are plenty of others that I'd like to see documented
(e.g. nVMX processes posted interrupts on emulated VM-entry, AMD's
merged PMU counters are only 48 bits wide, etc.).

Maybe Paolo has some ideas?

> Best regards,
>         Maxim Levitsky
>
> >
> > > Best regards,
> > >         Maxim Levitsky
> > >
> > >
> > >
> > >
>
>
