Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C879C6BF85D
	for <lists+kvm@lfdr.de>; Sat, 18 Mar 2023 07:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbjCRGdr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Mar 2023 02:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjCRGdp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Mar 2023 02:33:45 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6438C24116;
        Fri, 17 Mar 2023 23:33:43 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id l9-20020a17090a3f0900b0023d32684e7fso9555312pjc.1;
        Fri, 17 Mar 2023 23:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679121223;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0kGhEEWrhLYeTtU2Bv6lz7VXigjqaU4IzIFbxg6rvM0=;
        b=FBL0NdrFcTtVowhrBPqcyYigisj6uc2l1vdqX3qK/PGnBtOKzdjj0R3T2oTrd3NhfU
         U8d+TLKw0php2Q2slPwPIylSFfVWIbnZJvR164rfa3GlnLjcrIzWYzKmJoGN8Adf0iyg
         D58WWD/t8oc7vOd+vSlN9ToQeldXpfNnOZ0DWAKPBk0oJFPah7voCATtlPUL76vdeNSW
         K6pocOk6A1gCVJcVw9RnGFZigBxsRwID109k2RqS5Th82ILMOKPIEAZZIfI1B19H480V
         eanchH1ILubLO1R4AQ6vThvUl7KvxMqshSvsNDHClyCbF6QKC2by3XptwfgRaQRsBsdF
         XN2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679121223;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0kGhEEWrhLYeTtU2Bv6lz7VXigjqaU4IzIFbxg6rvM0=;
        b=Ql83fxq6KIyeQp8VW4yIDPIydEmgjcyu1p6n7yDALYAUEJil0iYAb8tsh7rqJEoLnk
         sGfdfvr2zkbAF7KtE/LFnyxQc5SYsu6hq+f7v3R9jHipvxBUB6fN9gRFIV74CB94WVxX
         qrv0w/ivev/SOVi3ISmZs2i8lFHUE4o3ns+bPesSo2Sj8btWWgr72+ptXcvqw94nyPO/
         13Ljx2voXvCGJdUf0/DesD7Zt7CVMdqVDIc7DeCaacMrc8gFrk6ft24yuGhvfeOr+AUp
         BYJS8DIKlfIkRiwTR4Tkj9jkFk39W7sLCW3h2l1XvswaEoYrNZh0V1itF65FPOA6wiaX
         JUzQ==
X-Gm-Message-State: AO0yUKXvIXUkAfZXn4AyyQCpmOvuFskzUYhjmw9buC2iHK816CmPNWWj
        gWyB5r5pri/hK6wiOhwagIT1Yci32ozTYuCzk6M=
X-Google-Smtp-Source: AK7set8iH3ILskrWrZgxfDPT0iW2Owd9Wy/7osipvBJJ8qCjWuPuLZvNSkzuc7Kh22apoE4MUanqGkfTlEiPeqZ4MpY=
X-Received: by 2002:a17:90a:f2c4:b0:23d:1121:f211 with SMTP id
 gt4-20020a17090af2c400b0023d1121f211mr2841345pjb.5.1679121222740; Fri, 17 Mar
 2023 23:33:42 -0700 (PDT)
MIME-Version: 1.0
References: <20230307023946.14516-1-xin3.li@intel.com> <20230307023946.14516-23-xin3.li@intel.com>
 <CAJhGHyADXz-3PCFS3M_7TJ8qLGJ=4NcV9aBWrpjemuXB_SnMGg@mail.gmail.com> <5D679723-D84F-42F0-AD8A-8BD1A38FB6CD@zytor.com>
In-Reply-To: <5D679723-D84F-42F0-AD8A-8BD1A38FB6CD@zytor.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Sat, 18 Mar 2023 14:33:30 +0800
Message-ID: <CAJhGHyC0_1xJD2R03-NoRVpMXFTHR4v8CdzyJOZe_k0rdv=NfQ@mail.gmail.com>
Subject: Re: [PATCH v5 22/34] x86/fred: FRED initialization code
To:     "H. Peter Anvin" <hpa@zytor.com>
Cc:     Xin Li <xin3.li@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        peterz@infradead.org, andrew.cooper3@citrix.com, seanjc@google.com,
        pbonzini@redhat.com, ravi.v.shankar@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Mar 18, 2023 at 5:32=E2=80=AFAM H. Peter Anvin <hpa@zytor.com> wrot=
e:
>
> On March 17, 2023 6:35:57 AM PDT, Lai Jiangshan <jiangshanlai@gmail.com> =
wrote:
> >Hello
> >
> >
> >Comments in cpu_init_fred_exceptions() seem scarce for understanding.
> >
> >On Tue, Mar 7, 2023 at 11:07=E2=80=AFAM Xin Li <xin3.li@intel.com> wrote=
:
> >
> >> +/*
> >> + * Initialize FRED on this CPU. This cannot be __init as it is called
> >> + * during CPU hotplug.
> >> + */
> >> +void cpu_init_fred_exceptions(void)
> >> +{
> >> +       wrmsrl(MSR_IA32_FRED_CONFIG,
> >> +              FRED_CONFIG_ENTRYPOINT(fred_entrypoint_user) |
> >> +              FRED_CONFIG_REDZONE(8) | /* Reserve for CALL emulation =
*/
> >> +              FRED_CONFIG_INT_STKLVL(0));
> >
> >What is it about "Reserve for CALL emulation"?
> >
> >I guess it relates to X86_TRAP_BP. In entry_64.S:
> >
> >        .if \vector =3D=3D X86_TRAP_BP
> >                /*
> >                 * If coming from kernel space, create a 6-word gap to a=
llow the
> >                 * int3 handler to emulate a call instruction.
> >                 */
> >
> >> +
> >> +       wrmsrl(MSR_IA32_FRED_STKLVLS,
> >> +              FRED_STKLVL(X86_TRAP_DB,  1) |
> >> +              FRED_STKLVL(X86_TRAP_NMI, 2) |
> >> +              FRED_STKLVL(X86_TRAP_MC,  2) |
> >> +              FRED_STKLVL(X86_TRAP_DF,  3));
> >
> >Why each exception here needs a stack level > 0?
> >Especially for X86_TRAP_DB and X86_TRAP_NMI.
> >
> >Why does or why does not X86_TRAP_VE have a stack level > 0?
> >
> >X86_TRAP_DF is the highest stack level, is it accidental
> >or deliberate?
> >
> >Thanks
> >Lai
> >
>
> Yes, the extra redzone space is there to allow for the call emulation wit=
hout having to adjust the stack frame "manually".
>
> In theory we could enable it only while code patching is in progress, but=
 that would probably just result in stack overflows becoming utterly imposs=
ible to debug as we have to consider the worst case.
>
> The purpose of separate stacks for NMI, #DB and #MC *in the kernel* (reme=
mber that user space faults are always taken on stack level 0) is to avoid =
overflowing the kernel stack. #DB in the kernel would imply the use of a ke=
rnel debugger.

Could you add it to the code, please? I think it can help other reviewers.

If there is no other concrete reason other than overflowing for
assigning NMI and #DB with a stack level > 0, #VE should also
be assigned with a stack level > 0, and #BP too. #VE can happen
anytime and anywhere, so it is subject to overflowing too.

>
>
> #DF is the highest level because a #DF means "something went wrong *while=
 delivering an exception*." The number of cases for which that can happen w=
ith FRED is drastically reduced and basically amount to "the stack you poin=
ted me to is broken."
>
> Thus, you basically always want to change stacks on #DF, which means it s=
hould be at the highest level.
