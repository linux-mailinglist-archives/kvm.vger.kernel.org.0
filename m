Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6884B24DB97
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 18:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgHUQoM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 12:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728084AbgHUQnw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Aug 2020 12:43:52 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A145C061573
        for <kvm@vger.kernel.org>; Fri, 21 Aug 2020 09:43:52 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id a26so3067931ejc.2
        for <kvm@vger.kernel.org>; Fri, 21 Aug 2020 09:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=timo1NIqJIiWk2L2YbStPp60+R9B7pOppvWspfhRfes=;
        b=X2Wm34n0mBbhWhjXNqHdaBgOhTUPpO/o3vzKnfx1eOVTa8BOb4KAc3O50Sn8lbj2wB
         5VnINDpkK8uKPRKhkx2tHFjGS+lSlcdAInPaligNEg2tQXdFutglFdL6qZZz06Xv5EZw
         vhRZh3m4GLFc9h5tIllw4UWiyL4ftNuVGyuvxmVGppeE1KxSyeo7KFozZw2HdVONQhsI
         cOnJ9RbCZimCdiCMk3drpRdPKaxet3zE+PNgGyaQ4g+c9CbEq6+fj8RrTDT4d6RUG8SC
         o5P66R7V/wIhbg8w7QObRxvw96gZLAQaiFbXEXnEhJ8WFxxMbeB9UTZ0QMyQ7R21BB7t
         4DQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=timo1NIqJIiWk2L2YbStPp60+R9B7pOppvWspfhRfes=;
        b=IDxT3wCs5zh1iJjqWNP6VgS0SGPZf6n8fhHHJfYgOtVcFuEj6xmELvfvnAqzJiVmtQ
         +cX3U0aw1Ig3gyoD6odsnKk0PycNjOytdGytFhm4ql7FQAEkWbtsB+UHgScWk2f/auOT
         R3/7ZFVEPPJT7x877i35J40WLLhYOHv4jwxSk9mQZx/lYFAr71hu58OcWeOY+AitQf4J
         zuM2yXkXnqmnmBe0vw5N/ID3Pw525BcFUnZp8iEziy/PIOIvkIrzaBKKksyu3IsYmbm5
         3Jn3yI3FIEvYMD7O4er+4nnETCMv3CDu40sGcBh/DfhlMzCB2YvjK8WF5PDSp1HuDGBe
         xixw==
X-Gm-Message-State: AOAM533cj8Waa+QkfZx6Qe4Gmw3AnuqTQKmvL1MqNbSsVXbv7v+8WuL7
        6d9NkHeoQkQHweU9SQ7dnWu+JucIYi03PK8Vh6dEUa4wmlg=
X-Google-Smtp-Source: ABdhPJyffvev12D4qDOGdsSp3Y6ACGETYJDKiABPQ0+H067SseppLFgJtKFpwebno4eWn8h7P3w7YpAlNti+EpRGCpA=
X-Received: by 2002:a17:906:e50:: with SMTP id q16mr3934289eji.155.1598028230120;
 Fri, 21 Aug 2020 09:43:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200818211533.849501-1-aaronlewis@google.com>
 <20200818211533.849501-8-aaronlewis@google.com> <522d8a2f-8047-32f6-a329-c9ace7bf3693@amazon.com>
 <CAAAPnDFEKOQjTKcmkFjP6hr6dgmR-61NL_W9=7Fs0THdOOJ7+Q@mail.gmail.com>
 <d75a3862-d4f4-e057-5d45-9edcb3f9b696@amazon.com> <CALMp9eRQ3FYOW08tbLJ79KJ32dD8K7djSoze9rcV0tuGbfVgLw@mail.gmail.com>
 <CAAAPnDGiBw7U6G61kGuAJOn+vSonvkhm_RQ_nL5_G-4yNSdPPw@mail.gmail.com> <161f8df0-9667-8f52-6230-a073590d4646@amazon.com>
In-Reply-To: <161f8df0-9667-8f52-6230-a073590d4646@amazon.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Fri, 21 Aug 2020 09:43:38 -0700
Message-ID: <CAAAPnDHECMmvZNL4omnmOdEeCn1ifv33KPH=Tmw7ThYkV87aCg@mail.gmail.com>
Subject: Re: [PATCH v3 07/12] KVM: x86: Ensure the MSR bitmap never clears
 userspace tracked MSRs
To:     Alexander Graf <graf@amazon.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 21, 2020 at 9:08 AM Alexander Graf <graf@amazon.com> wrote:
>
>
>
> On 21.08.20 16:27, Aaron Lewis wrote:
> >
> > On Thu, Aug 20, 2020 at 3:35 PM Jim Mattson <jmattson@google.com> wrote=
:
> >>
> >> On Thu, Aug 20, 2020 at 3:04 PM Alexander Graf <graf@amazon.com> wrote=
:
> >>>
> >>>
> >>>
> >>> On 20.08.20 02:18, Aaron Lewis wrote:
> >>>>
> >>>> On Wed, Aug 19, 2020 at 8:26 AM Alexander Graf <graf@amazon.com> wro=
te:
> >>>>>
> >>>>>
> >>>>>
> >>>>> On 18.08.20 23:15, Aaron Lewis wrote:
> >>>>>>
> >>>>>> SDM volume 3: 24.6.9 "MSR-Bitmap Address" and APM volume 2: 15.11 =
"MS
> >>>>>> intercepts" describe MSR permission bitmaps.  Permission bitmaps a=
re
> >>>>>> used to control whether an execution of rdmsr or wrmsr will cause =
a
> >>>>>> vm exit.  For userspace tracked MSRs it is required they cause a v=
m
> >>>>>> exit, so the host is able to forward the MSR to userspace.  This c=
hange
> >>>>>> adds vmx/svm support to ensure the permission bitmap is properly s=
et to
> >>>>>> cause a vm_exit to the host when rdmsr or wrmsr is used by one of =
the
> >>>>>> userspace tracked MSRs.  Also, to avoid repeatedly setting them,
> >>>>>> kvm_make_request() is used to coalesce these into a single call.
> >>>>>>
> >>>>>> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> >>>>>> Reviewed-by: Oliver Upton <oupton@google.com>
> >>>>>
> >>>>> This is incomplete, as it doesn't cover all of the x2apic registers=
.
> >>>>> There are also a few MSRs that IIRC are handled differently from th=
is
> >>>>> logic, such as EFER.
> >>>>>
> >>>>> I'm really curious if this is worth the effort? I would be inclined=
 to
> >>>>> say that MSRs that KVM has direct access for need special handling =
one
> >>>>> way or another.
> >>>>>
> >>>>
> >>>> Can you please elaborate on this?  It was my understanding that the
> >>>> permission bitmap covers the x2apic registers.  Also, I=E2=80=99m no=
t sure how
> >>>
> >>> So x2apic MSR passthrough is configured specially:
> >>>
> >>>
> >>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tr=
ee/arch/x86/kvm/vmx/vmx.c#n3796
> >>>
> >>> and I think not handled by this patch?
> >>
> >> By happenstance only, I think, since there is also a call there to
> >> vmx_disable_intercept_for_msr() for the TPR when x2APIC is enabled.
> >
> > If we want to be more explicit about it we could add
> > kvm_make_request(KVM_REQ_USER_MSR_UPDATE, vcpu) After the bitmap is
> > modified, but that doesn't seem to be necessary as Jim pointed out as
> > there are calls to vmx_disable_intercept_for_msr() there which will
> > set the update request for us.  And we only have to worry about that
> > if the bitmap is cleared which means MSR_BITMAP_MODE_X2APIC_APICV is
> > set, and that flag can only be set if MSR_BITMAP_MODE_X2APIC is set.
> > So, AFAICT that is covered by my changes.
> >
>
> I don't understand - for most x2APIC MSRs,
> vmx_{en,dis}able_intercept_for_msr() never gets called, no?
>

Sorry, to be clear.  We just need it to be called once for us to be
covered.  When it's invoked we set a flag, so the next time vm enter
is called we run over the list of MSRs userspace cares about and
ensure they are all set correctly.  So, if the x2APIC permission
bitmaps are modified directly and cleared, we just need for
vmx_disable_intercept_for_msr() to be called at least once to tell us
to run over the list and set the bits for all MSRs userspace is
tracking.

>
> Alex
>
>
>
> Amazon Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
> Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> Sitz: Berlin
> Ust-ID: DE 289 237 879
>
>
