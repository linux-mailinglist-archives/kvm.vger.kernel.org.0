Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B53AA6D1CF3
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 11:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbjCaJuL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 05:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232361AbjCaJto (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 05:49:44 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D67821F78E
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 02:48:37 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id dw4so5919452qkb.10
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 02:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680256117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dTYufiTa8RDU0UzDOhAuB0+mFfR3PLIeeeccIx8HQg4=;
        b=KI7Bv9HAoKbhzh4mwQHUprIYwMvWHqdCMto7UXYV1C0zImjrtB4ig0L4Ualk3bCRO8
         Vh0W/nSVcZgwSfJbLgHMutI9eBjG/1jjt/8npAPGP/SPSnIsuDa4L2wEqy7A0jwRaz5m
         7fG4ob1KUUYqo+GGrLYilNjRXc5op++A2kgE8E54PVLMm+F+6K40UyHJq342aQhDkPac
         YOFjaK2ZRedsLJFxEdFIEBblAOkmYsm4eP3vo7yA03XO/2dlakUC9QLmVeOeX0bMQkGj
         lSJayKEdzJLYoaeZ/NndeEQcz7sELo19Rvy3bZG5/SnNgRJj4LIbwLEq6QA79QUNwv0g
         M33A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680256117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dTYufiTa8RDU0UzDOhAuB0+mFfR3PLIeeeccIx8HQg4=;
        b=sUTCbGkRifhjiwZC2JLPemtEMCYreINdIZ/UGgeBsIGMCe1cU5r4/bDgaRisF09vLz
         dczMxayNSW6X9VGE+u/+SGt5Ntw0Q8tQwB/UXjsQI9oxRR6qPiRk0p6cnqp8E+K2sTFH
         iMpwbjkanhtdlxTvgdyFyRpM0/KNZOhX44R84aIHAGQXUzHczJgREZmbC7hMIk597LXy
         UFOBwQCJ9ZiXuD7XsqHl6yCP+7lNPd6/otRJsrXKaEColG6EP+Zl7MkTM/jtHr1JN0m8
         QeTQ+UGY9Y8mG+TCQcW9sWEi5RC9SliZUTSIsoFT/uF0uJYioqCqR4fndCEBEjwJSmIs
         CGqQ==
X-Gm-Message-State: AO0yUKW1dM1WyvxcW/kgw2fa9Aqy0v1s8TFW9pJ2ckMR7iXFb6HddAOq
        Zu87E5zgAHvPOewy+tFFQ6PklwmTo8/rmeVulYE=
X-Google-Smtp-Source: AK7set/xFqTgtelVtukwYOeh2vJmxR8iFg5jxz200UgBkBa/wQvlX+S23nER8RNncEJgKcULKxQh3Q72+qQw35tjqss=
X-Received: by 2002:a05:620a:44d5:b0:746:b32:a43d with SMTP id
 y21-20020a05620a44d500b007460b32a43dmr6088072qkp.11.1680256117039; Fri, 31
 Mar 2023 02:48:37 -0700 (PDT)
MIME-Version: 1.0
References: <20230310125718.1442088-1-robert.hu@intel.com> <20230310125718.1442088-2-robert.hu@intel.com>
 <ZAtT5pFPqjM1Ocq0@google.com> <CA+wubQBWgz4YAi=T3MV82HrC3=gXSC_yD50ip0=N_x3MnTE1UA@mail.gmail.com>
 <ZBIFgH4YBC71n6KR@google.com>
In-Reply-To: <ZBIFgH4YBC71n6KR@google.com>
From:   Robert Hoo <robert.hoo.linux@gmail.com>
Date:   Fri, 31 Mar 2023 17:48:26 +0800
Message-ID: <CA+wubQA3HP2s6dq7JUvxHj8jkjfK5E__RenzAk7tyf3xtmgoJg@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: VMX: Rename vmx_umip_emulated() to cpu_has_vmx_desc()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Robert Hoo <robert.hu@intel.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> =E4=BA=8E2023=E5=B9=B43=E6=9C=8816=
=E6=97=A5=E5=91=A8=E5=9B=9B 01:50=E5=86=99=E9=81=93=EF=BC=9A
>
> Please fix your editor or whatever it is that is resulting your emails be=
ing
> wrapped at very bizarre boundaries.
>
(Sorry for late reply.)
Yes, I also noticed this. Just began using Gmail web portal for community m=
ails.
I worried that it has no auto wrapping (didn't find the setting), so manual=
ly
wrapped; but now looks like it has some.
Give me some time, I'm going to switch to some mail client.
Welcome suggestions of mail clients which is suited for community
communications, on Windows platform.=F0=9F=99=82

> On Sat, Mar 11, 2023, Robert Hoo wrote:
> > Also, vmx_umip_emulated() =3D=3D true doesn't necessarily mean, as its =
name
> > indicates, UMIP-being-emulated, e.g. Host has UMIP capability, then UMI=
P
> > isn't emulated though vmx_umip_emulated() indicates true.
>
[...]
> there's no
> legitimate use for checking if UMIP _can_ be emulated.

Agree.
>
> Functionally, this should be a glorified nop,

Personally, I think it is more than this; good naming, not misleading
its user, saving their time to look into, is always good.

> but I agree it's worth changing.
> I'll formally post this after testing.

Thanks, looks good to me, it enriches the original patch, i.e. the
cr4_fixed1 part is beyond my original findings. Just don't quite
understand the last paragraph of the description. I ask inline below.
>
> From: Sean Christopherson <seanjc@google.com>
> Date: Wed, 15 Mar 2023 10:27:40 -0700
> Subject: [PATCH] KVM: VMX: Treat UMIP as emulated if and only if the host
>  doesn't have UMIP
>
> Advertise UMIP as emulated if and only if the host doesn't natively
> support UMIP, otherwise vmx_umip_emulated() is misleading when the host
> _does_ support UMIP.  Of the four users of vmx_umip_emulated(), two
> already check for native support, and the logic in vmx_set_cpu_caps() is
> relevant if and only if UMIP isn't natively supported as UMIP is set in
> KVM's caps by kvm_set_cpu_caps() when UMIP is present in hardware.
>
Sorry I don't fully understand the paragraph below, though I believe
you're right.:)

> That leaves KVM's stuffing of X86_CR4_UMIP into the default cr4_fixed1
> value enumerated for nested VMX.  In that case, checking for (lack of)
> host support is actually a bug fix of sorts,

What bug?
By your assumption below:
    * host supports UMIP, host doesn't allow (nested?) vmx
    * UMIP enumerated to L1, L1 thinks it has UMIP capability and
enumerates to L2
    * L1 MSR_IA32_VMX_CR4_FIXED1.UMIP is set (meaning allow 1, not fixed to=
 1)

L2 can use UMIP, no matter L1's UMIP capability is backed by L0 host's
HW UMIP or L0's vmx emulation, I don't see any problem. Shed more
light?

> as enumerating UMIP support
> based solely on descriptor table

What "descriptor table" do you mean here?

> existing works only because KVM doesn't
> sanity check MSR_IA32_VMX_CR4_FIXED1.

Emm, nested_cr4_valid() should be applied to vmx_set_cr4()?

> E.g. if a (very theoretical) host
> supported UMIP in hardware but didn't allow UMIP+VMX, KVM would advertise
> UMIP but not actually emulate UMIP.  Of course, KVM would explode long
> before it could run a nested VM on said theoretical CPU, as KVM doesn't
> modify host CR4 when enabling VMX.
