Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECD626A6401
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 01:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbjCAADg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 19:03:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjCAADf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 19:03:35 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD753C2A;
        Tue, 28 Feb 2023 16:03:31 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id c19so12502134qtn.13;
        Tue, 28 Feb 2023 16:03:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677629011;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y7xlEzbWy6v9JfLWv2ZpFnkkZM75lFiyxm9Fm1VS9Lo=;
        b=MhDQY0UQ+y5lA4/Grc8SUZ3G1TlC3KIqrvzHzDI/kJi/x+70OIfJjfqdIGxV4g0cwQ
         kxgAc/ybrHWiRPIduKLPvemwtLiUUHZbj/GFcrqmISn5bV2Z7HkIbYskSbx71X44LYFz
         RIEHLjoRplEXyz+ZA8Rhxh2uJ5v9TryoybOXKtlTuwlm8z0B6x3Y+egeAAjZGd+0s4qi
         eB0m95NF1OrZULRACKI3YFhVUh2LJ4F6UqkcYn7NMMI/rrFeBdNtYzqXflC18Y+Kt6Vf
         mwZ2vDYjpjWwWdf1dW2M/mTx29M9mPFoL9X2eh4qMhLfyaO1o1dMQMq3B/LTlRRF37Wq
         HdeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677629011;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y7xlEzbWy6v9JfLWv2ZpFnkkZM75lFiyxm9Fm1VS9Lo=;
        b=4z5+3RwB32zbjBWRRz3hMqCKg24sU1TouQW15kmOHvEyfza4LY7sHPLkxNY8iWONtM
         Qc1Hs7QZdQ2/y3a6W1HGFeooX5FYz3lrd88+oZmlYEoHfEu7CeAP3or+8Yj2RFEH/uE9
         CqvmFXjmMwOHplxd8malnz1Mi7R3kufbd1uIbAh1btCeJKGW0hltHjmscGReQYl2uPZJ
         I7Wthyt295L9nZCL+9S2Uf0epy0E3r1EL2XXYy1noPU4kR39EeP6krTKRxF8S+Hn0Pdh
         /GfexbHiFQ/1qvTzPVMOFXNiqenl46YSVRcK2VplQQww4UVN8ic3qiMO3yvJwpZnes1i
         7L4w==
X-Gm-Message-State: AO0yUKVgS34JWicKZqgfY58w5Tb5ipQP9to6I/UNY+LMLFMhtRhaT+ew
        qvfmXH4GjZnu8Kb3DHTOErk5QJN4B4/4Fz0cnqK+3S6zO0i0
X-Google-Smtp-Source: AK7set+P1K1zJUQOa4fDilf3cLbc+JrET/UoKH5Obbp5N5CViT8tULlyqxFRQ+0WHzNnqBwjP9p/9upM3tM4R346pGU=
X-Received: by 2002:a05:622a:1ba4:b0:3bd:17aa:49b2 with SMTP id
 bp36-20020a05622a1ba400b003bd17aa49b2mr1965901qtb.5.1677629010966; Tue, 28
 Feb 2023 16:03:30 -0800 (PST)
MIME-Version: 1.0
References: <20230226110802.103134-1-usama.arif@bytedance.com>
 <20230226110802.103134-8-usama.arif@bytedance.com> <878rghmrn2.ffs@tglx>
 <35264451eabdf967eb31069cb814e8a05ee3179b.camel@infradead.org>
 <cf7a1657159219cea61ffef567280e2e88d1f670.camel@infradead.org>
 <CAMzpN2hQArxf2mAVq55uMx9VhTjUD-VDEVAD406RScfsrjdAjQ@mail.gmail.com> <0E3AFDDA-039B-40F3-92A4-85CD96B1BB64@infradead.org>
In-Reply-To: <0E3AFDDA-039B-40F3-92A4-85CD96B1BB64@infradead.org>
From:   Brian Gerst <brgerst@gmail.com>
Date:   Tue, 28 Feb 2023 19:03:19 -0500
Message-ID: <CAMzpN2gEhC5q-FPv2iGmEzuk+LiRHF+Mn7EKWw7KbQ5NQUmG2g@mail.gmail.com>
Subject: Re: [PATCH v12 07/11] x86/smpboot: Remove early_gdt_descr on 64-bit
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Usama Arif <usama.arif@bytedance.com>, kim.phillips@amd.com,
        piotrgorski@cachyos.org, oleksandr@natalenko.name,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com
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

On Tue, Feb 28, 2023 at 6:43=E2=80=AFPM David Woodhouse <dwmw2@infradead.or=
g> wrote:
>
>
>
> On 28 February 2023 22:48:42 GMT, Brian Gerst <brgerst@gmail.com> wrote:
> >On Tue, Feb 28, 2023 at 5:41=E2=80=AFPM David Woodhouse <dwmw2@infradead=
.org> wrote:
> >>
> >> On Tue, 2023-02-28 at 21:57 +0000, David Woodhouse wrote:
> >> >
> >> > ----------------
> >> > IN:
> >> > 0xffffffffa20000b2:  48 31 d2                 xorq     %rdx, %rdx
> >> > 0xffffffffa20000b5:  48 8b 82 c0 74 d5 a3     movq     -0x5c2a8b40(%=
rdx), %rax
> >> > 0xffffffffa20000bc:  48 8b a0 58 14 00 00     movq     0x1458(%rax),=
 %rsp
> >> > 0xffffffffa20000c3:  48 83 ec 10              subq     $0x10, %rsp
> >> > 0xffffffffa20000c7:  66 c7 04 24 7f 00        movw     $0x7f, (%rsp)
> >> > 0xffffffffa20000cd:  48 8d 82 00 10 81 a3     leaq     -0x5c7ef000(%=
rdx), %rax
> >> > 0xffffffffa20000d4:  48 89 44 24 02           movq     %rax, 2(%rsp)
> >> > 0xffffffffa20000d9:  0f 01 14 24              lgdtq    (%rsp)
> >> > 0xffffffffa20000dd:  48 83 c4 10              addq     $0x10, %rsp
> >> > 0xffffffffa20000e1:  31 c0                    xorl     %eax, %eax
> >> > 0xffffffffa20000e3:  8e d8                    movl     %eax, %ds
> >> >
> >> > I cannot work out where the value -0x5c7ef000 comes from, but it
> >> > doesn't seem to be the 0xb000 you claimed, and my brain is hurting
> >> > again...
> >>
> >> Turning off CONFIG_RANDOMIZE_BASE (or just looking at the vmlinux
> >> disassembly instead as Brian did) helps to resolve that FWIW.
> >>
> >> I've changed it to zero all of %rdx and pushed it back to the v12bis
> >> branch.
> >
> >xorl %edx, %edx is preferred, as a 32-bit operation zero-extends to
> >the full 64-bit register.  Using xorq to clear any of the lower 8
> >registers adds an unnecessary REX prefix.  Just one of many quirks of
> >the x86 instruction set...
>
> Ewww. Couldn't the assembler choose to omit the REX prefix then? It does =
more tricksy things than that already.
>
> I almost prefer having the prefix but (in the morning) if you prefer I ca=
n put it back as it was with a comment about the zero-extension.

commit a7bea8308933aaeea76dad7d42a6e51000417626
Author: Jan Beulich <JBeulich@suse.com>
Date:   Mon Jul 2 04:31:54 2018 -0600

    x86/asm/64: Use 32-bit XOR to zero registers

    Some Intel CPUs don't recognize 64-bit XORs as zeroing idioms. Zeroing
    idioms don't require execution bandwidth, as they're being taken care
    of in the frontend (through register renaming). Use 32-bit XORs instead=
.

Not that speed is important here, but it's good to be consistent
across the whole kernel.  Someone will eventually come by and fix it
up anyways, as there have been a few of these patches already in the
git history.

--
Brian Gerst
