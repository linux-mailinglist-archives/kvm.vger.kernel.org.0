Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 508ED6A63DA
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 00:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbjB1Xnj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 18:43:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjB1Xnh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 18:43:37 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A1A1CAF5;
        Tue, 28 Feb 2023 15:43:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=JsL9Us+x16nTY6Mbk3g2KbIY8zr/WGVU/ALR4CoAkak=; b=OqtSXOxI3ePrB+vZ6juHfxlVHT
        nAwAuxlH2Hn36ORZpyCnwSOXXP+wePYp52D0ftMCrDndOu6Z4Yis6X/UOOCSINdZNajnVLf5QpLRK
        cRMCFs5WVBfi4cEiCP5mXGvwxTmfP8O1aY5YuFQzij42ToP1ZmLEnz1RCiSbaulEVoSQ/OOsmeR/q
        aYgTtQc4GagDcVhfrlfEhcB/UoLAx8mH9+KFV3WtWa48EbgqR/TBHz8pfFA1ikBLt2FaWEwMwa6r9
        DAf7sNwyGYAx4OEAiWfBFe8ZdbSjjFbiNK9LC0mnOLyZ7JDLYhUp7R3J1iREGY+ibLMzMQDXWdUY1
        D8aZkZRw==;
Received: from [2001:8b0:10b:5:3afe:a5a4:6c0b:a34c] (helo=[IPv6:::1])
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pX9cV-00Ehr4-0X;
        Tue, 28 Feb 2023 23:42:55 +0000
Date:   Tue, 28 Feb 2023 23:42:55 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Brian Gerst <brgerst@gmail.com>
CC:     Thomas Gleixner <tglx@linutronix.de>,
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
Subject: Re: [PATCH v12 07/11] x86/smpboot: Remove early_gdt_descr on 64-bit
User-Agent: K-9 Mail for Android
In-Reply-To: <CAMzpN2hQArxf2mAVq55uMx9VhTjUD-VDEVAD406RScfsrjdAjQ@mail.gmail.com>
References: <20230226110802.103134-1-usama.arif@bytedance.com> <20230226110802.103134-8-usama.arif@bytedance.com> <878rghmrn2.ffs@tglx> <35264451eabdf967eb31069cb814e8a05ee3179b.camel@infradead.org> <cf7a1657159219cea61ffef567280e2e88d1f670.camel@infradead.org> <CAMzpN2hQArxf2mAVq55uMx9VhTjUD-VDEVAD406RScfsrjdAjQ@mail.gmail.com>
Message-ID: <0E3AFDDA-039B-40F3-92A4-85CD96B1BB64@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 28 February 2023 22:48:42 GMT, Brian Gerst <brgerst@gmail=2Ecom> wrote:
>On Tue, Feb 28, 2023 at 5:41=E2=80=AFPM David Woodhouse <dwmw2@infradead=
=2Eorg> wrote:
>>
>> On Tue, 2023-02-28 at 21:57 +0000, David Woodhouse wrote:
>> >
>> > ----------------
>> > IN:
>> > 0xffffffffa20000b2:  48 31 d2                 xorq     %rdx, %rdx
>> > 0xffffffffa20000b5:  48 8b 82 c0 74 d5 a3     movq     -0x5c2a8b40(%r=
dx), %rax
>> > 0xffffffffa20000bc:  48 8b a0 58 14 00 00     movq     0x1458(%rax), =
%rsp
>> > 0xffffffffa20000c3:  48 83 ec 10              subq     $0x10, %rsp
>> > 0xffffffffa20000c7:  66 c7 04 24 7f 00        movw     $0x7f, (%rsp)
>> > 0xffffffffa20000cd:  48 8d 82 00 10 81 a3     leaq     -0x5c7ef000(%r=
dx), %rax
>> > 0xffffffffa20000d4:  48 89 44 24 02           movq     %rax, 2(%rsp)
>> > 0xffffffffa20000d9:  0f 01 14 24              lgdtq    (%rsp)
>> > 0xffffffffa20000dd:  48 83 c4 10              addq     $0x10, %rsp
>> > 0xffffffffa20000e1:  31 c0                    xorl     %eax, %eax
>> > 0xffffffffa20000e3:  8e d8                    movl     %eax, %ds
>> >
>> > I cannot work out where the value -0x5c7ef000 comes from, but it
>> > doesn't seem to be the 0xb000 you claimed, and my brain is hurting
>> > again=2E=2E=2E
>>
>> Turning off CONFIG_RANDOMIZE_BASE (or just looking at the vmlinux
>> disassembly instead as Brian did) helps to resolve that FWIW=2E
>>
>> I've changed it to zero all of %rdx and pushed it back to the v12bis
>> branch=2E
>
>xorl %edx, %edx is preferred, as a 32-bit operation zero-extends to
>the full 64-bit register=2E  Using xorq to clear any of the lower 8
>registers adds an unnecessary REX prefix=2E  Just one of many quirks of
>the x86 instruction set=2E=2E=2E

Ewww=2E Couldn't the assembler choose to omit the REX prefix then? It does=
 more tricksy things than that already=2E

I almost prefer having the prefix but (in the morning) if you prefer I can=
 put it back as it was with a comment about the zero-extension=2E
