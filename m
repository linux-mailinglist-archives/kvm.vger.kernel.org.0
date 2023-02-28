Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3216A62CA
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 23:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjB1Ws5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 17:48:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjB1Wsz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 17:48:55 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4E934022;
        Tue, 28 Feb 2023 14:48:54 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id h19so12397029qtk.7;
        Tue, 28 Feb 2023 14:48:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677624533;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GMtqDIiFEWDHqHhFJAnoEDLZ4UDoy4mDDU97fKecDF8=;
        b=WIsalkXZRgcopURSxgd68sqTAV+TNnE7NCzw2iNl4mEswIm0aa7+zns9MTJ/4LOmnD
         mX5DxRjJFqOzPVIg70PH7nCJx1xzV9SzmssLTOcm0QBJ+A2WH7w8rLTJ4ADXlSRXKW2L
         u2j7nqIjaYS3IJyHj3Tm++qezDoXTg72vxAjCzoRR++51Pqg/wFansBEhbEZ4udMtL1k
         9LIjBD3gEE8R2ePrAHMxWqD9lIiS6zg630xnU6OwZkniIsmkLRbxoUM3PCLwMegvfTty
         FsTmAX+QDtxlO21V7Wbl2/zCowQTDrnZwB6ws63eAxu4DB8V7k+vxxeHr1QjMPsQ1gT3
         nb2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677624533;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GMtqDIiFEWDHqHhFJAnoEDLZ4UDoy4mDDU97fKecDF8=;
        b=WeTSfJ1HAStY+mYD+93myiICXc4WBdjj1AiU6Fk2PmqubalVK27DAspyEU93efFpKb
         kGEj36VwRcftemfQsOg19m4bBlOzPARvrzIXKWxj+d1SmBMp1epRnTxnqtPVfMN6eNvp
         GqQLmbes2As5oc6WqmzCj1/ELxHYV3G5DYVvKknZqBVloqgYLnzxCqiPbrlDy4dH3uYx
         jtYKAvzChaUIkG6V6qqtwZzTJJedpnNUKHSG+G2XyCFT3Qg5CrLK6f7GdnGxVPc2A7V9
         rPWrTqunvSO1vN/YFKahFUuTzH74SuSge5vWDZD/uyvgClJBjiVr+ByxQzW97k9muWFm
         JcHg==
X-Gm-Message-State: AO0yUKVP4K+Xf9sml8h3PDbdDWWe7LlemK9mFrl//klC+xeLslT+3NJ8
        nLRT9B58zl8OpEuz6oBSH9EMU4gqUaz+Szw72w==
X-Google-Smtp-Source: AK7set+RBzlEbfpSy8+eyRrEcKw3S9nC0Ehapi+Zo4Zw2VvowvF8usAqZdvthYyXq29rxKiE1PP3b4n1tKXga0xATyE=
X-Received: by 2002:ac8:4299:0:b0:3bf:d9e4:8063 with SMTP id
 o25-20020ac84299000000b003bfd9e48063mr995349qtl.10.1677624533552; Tue, 28 Feb
 2023 14:48:53 -0800 (PST)
MIME-Version: 1.0
References: <20230226110802.103134-1-usama.arif@bytedance.com>
 <20230226110802.103134-8-usama.arif@bytedance.com> <878rghmrn2.ffs@tglx>
 <35264451eabdf967eb31069cb814e8a05ee3179b.camel@infradead.org> <cf7a1657159219cea61ffef567280e2e88d1f670.camel@infradead.org>
In-Reply-To: <cf7a1657159219cea61ffef567280e2e88d1f670.camel@infradead.org>
From:   Brian Gerst <brgerst@gmail.com>
Date:   Tue, 28 Feb 2023 17:48:42 -0500
Message-ID: <CAMzpN2hQArxf2mAVq55uMx9VhTjUD-VDEVAD406RScfsrjdAjQ@mail.gmail.com>
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

On Tue, Feb 28, 2023 at 5:41=E2=80=AFPM David Woodhouse <dwmw2@infradead.or=
g> wrote:
>
> On Tue, 2023-02-28 at 21:57 +0000, David Woodhouse wrote:
> >
> > ----------------
> > IN:
> > 0xffffffffa20000b2:  48 31 d2                 xorq     %rdx, %rdx
> > 0xffffffffa20000b5:  48 8b 82 c0 74 d5 a3     movq     -0x5c2a8b40(%rdx=
), %rax
> > 0xffffffffa20000bc:  48 8b a0 58 14 00 00     movq     0x1458(%rax), %r=
sp
> > 0xffffffffa20000c3:  48 83 ec 10              subq     $0x10, %rsp
> > 0xffffffffa20000c7:  66 c7 04 24 7f 00        movw     $0x7f, (%rsp)
> > 0xffffffffa20000cd:  48 8d 82 00 10 81 a3     leaq     -0x5c7ef000(%rdx=
), %rax
> > 0xffffffffa20000d4:  48 89 44 24 02           movq     %rax, 2(%rsp)
> > 0xffffffffa20000d9:  0f 01 14 24              lgdtq    (%rsp)
> > 0xffffffffa20000dd:  48 83 c4 10              addq     $0x10, %rsp
> > 0xffffffffa20000e1:  31 c0                    xorl     %eax, %eax
> > 0xffffffffa20000e3:  8e d8                    movl     %eax, %ds
> >
> > I cannot work out where the value -0x5c7ef000 comes from, but it
> > doesn't seem to be the 0xb000 you claimed, and my brain is hurting
> > again...
>
> Turning off CONFIG_RANDOMIZE_BASE (or just looking at the vmlinux
> disassembly instead as Brian did) helps to resolve that FWIW.
>
> I've changed it to zero all of %rdx and pushed it back to the v12bis
> branch.

xorl %edx, %edx is preferred, as a 32-bit operation zero-extends to
the full 64-bit register.  Using xorq to clear any of the lower 8
registers adds an unnecessary REX prefix.  Just one of many quirks of
the x86 instruction set...

--
Brian Gerst
