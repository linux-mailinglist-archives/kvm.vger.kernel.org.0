Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8F975C00D0
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 17:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbiIUPLp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 11:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiIUPLm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 11:11:42 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83679868BE
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 08:11:41 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-127ba06d03fso9513806fac.3
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 08:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=6seli6VLFqb7s/vLQoso8OmUADmAW+pE7vYAGBPbbyI=;
        b=etjpJoNXGVkFiG4OBJic4LPqZtmTQ0n9boz4HdSEyiDdllFPXuw6S1ue1xA4TlUZJG
         9BRy2EhSuzebayCVEbJm+s0/cFkbE1bvzWyZTx2MqIjPX1PJbEvGc+YHb2dVoPkh2/Dl
         gFh2S4sDw25wTzzAN/pkUGhOyBZkwNsve9zNrBzyxiOZa1X/CCq9MmKTD24Tap7kwsFk
         bVp4yYaza39DrFr/eTWqZQnDYMz8BhfekoJFIlWLliIpISSWsqLF4LsKk3SZSd6YaIOC
         e5yMgri9SqbX27lRYPvcDR6wQues28X68ubh//td0FFnrU1EjbyEan0Y5L3A4SUUuZwC
         g99g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=6seli6VLFqb7s/vLQoso8OmUADmAW+pE7vYAGBPbbyI=;
        b=Ydli+ot99jdaaKRpvLO0/AcsF++q8MN0YgOD+N2XgBec1E0h8a/W/RwInXx90444MP
         HraBlZDkejGVnoVbJ8yjgXazA2szEeoS2QRfwQzUsPJsf4mS1gRuTnUX9sQOKrYEDrHP
         Z3AMIuEtOvfgD8msRprbs8NAcMx1Yck8saX9QV0Fr/qGwv7v7YWCqeFcmUZFOcg1Lczt
         5VeDEMGKZ0YXYwrHPkcTElB0+lIKeTEzcysV3FpMAYgfHa0EhvXEanu2jZF+jcieTL9y
         tYixQknBpnEmsFrEbsfmfFZCyx+zGGH0b81KYG5CEVuXjwpqdRz1I7/2+UrbBfNHEGxJ
         bPfg==
X-Gm-Message-State: ACrzQf2y2EFg3G08ZGyNVv111f0zj65Mt9GnlXxcgPA+mX0TsEyZsHB9
        jXKWmIjxnRLqYNZoD9ljE1UnHF0AFgKM/U4E3iUrjw==
X-Google-Smtp-Source: AMsMyM6oBh2n+kuTR831V6c4Bg71RfUVnJpPesV6bfkJahpbjin8CoSac13b1yjmp7HgvXVEouGnXaa8w42JX7u3rj0=
X-Received: by 2002:a05:6870:580c:b0:12a:f136:a8f5 with SMTP id
 r12-20020a056870580c00b0012af136a8f5mr5207627oap.269.1663773100626; Wed, 21
 Sep 2022 08:11:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220920205922.1564814-1-jmattson@google.com> <Yyot34LGkFR2/j5f@zn.tnic>
 <CALMp9eQijCKS-E_OWJkxdqAur3BthciOWEtEPH5YKd0-HJiQQA@mail.gmail.com>
 <YyrZOLq8z+lIORvP@zn.tnic> <CALMp9eRG6g-95zCxTD1NnxpZ+Vm6VMTA0_uaHV=b-hDkeOYSuA@mail.gmail.com>
 <YysXeXKY36yXj68q@zn.tnic>
In-Reply-To: <YysXeXKY36yXj68q@zn.tnic>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 21 Sep 2022 08:11:29 -0700
Message-ID: <CALMp9eTuO79+NfHxLi8FnqdOpzXO7eQUntvN23EfR+shg+wg2Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] KVM: EFER.LMSLE cleanup
To:     Borislav Petkov <bp@alien8.de>
Cc:     Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 21, 2022 at 6:54 AM Borislav Petkov <bp@alien8.de> wrote:
>
> On Wed, Sep 21, 2022 at 06:45:24AM -0700, Jim Mattson wrote:
> > EFER.LMLSE is not a reserved bit on AMD64 CPUs, unless
> > CPUID.80000008:EBX[20] is set (or you're running very, very old
> > hardware).
> >
> > We really shouldn't just decide on a whim to treat EFER.LMSLE as
> > reserved under KVM. The guest CPUID information represents our
> > detailed contract with the guest software. By setting
> > CPUID.80000008:EBX[20], we are telling the guest that if it tries to
> > set EFER.LMSLE, we will raise a #GP.
>
> I understand all that. What I'm asking is, what happens in KVM *after*
> your patch 1/3 is applied when a guest tries to set EFER.LMSLE? Does it
> #GP or does it allow the WRMSR to succeed? I.e., does KVM check when
> reserved bits in that MSR are being set?
>
> By looking at it, there's kvm_enable_efer_bits() so it looks like KVM
> does control which bits are allowed to set and which not...?

Yes, after the revert, KVM will treat the bit as reserved, and it will
synthesize a #GP, *in violation of the architectural specification.*
As I said, we could document this behavior as a KVM erratum.

> > If we don't set that bit in the guest CPUID information and we raise
> > #GP on an attempt to set EFER.LMSLE, the virtual hardware is
> > defective.
>
> See, this is what I don't get - why is it defective? After the revert,
> that bit to KVM is reserved.

KVM can't just decide willy nilly to reserve arbitrary bits. If it is
in violation of AMD's architectural specification, the virtual CPU is
defective.

> > We could document this behavior as an erratum, but since a
> > mechanism exists to declare that the guest can expect EFER.LMSLE to
> > #GP, doesn't it make sense to use it?
>
> I don't mind all that and the X86_FEATURE bit and so on - I'm just
> trying to ask you guys: what is KVM's behavior when the guest tries to
> set a reserved EFER bit.
>
> Maybe I'm not expressing myself precisely enough...

I feel the same way. :-(

The two patches after the revert are to amend the contract with the
guest (as expressed by the guest CPUID table) so that the KVM virtual
CPU can raise a #GP on EFER.LMSLE and still conform to the
architectural specification.

From the APM, volume 2, 4.12.2 Data Limit Checks in 64-bit Mode:

> Data segment limit checking in 64-bit mode is not supported by all proces=
sor implementations and has been deprecated. If CPUID Fn8000_0008_EBX[EferL=
mlseUnsupported](bit 20) =3D 1, 64-bit mode segment limit checking is not s=
upported and attempting to enable this feature by setting EFER.LMSLE =3D1 w=
ill result in a #GP exception.
