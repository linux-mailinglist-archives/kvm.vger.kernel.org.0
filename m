Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE6D418F0B3
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 09:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727510AbgCWISY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 04:18:24 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:31360 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727486AbgCWISY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Mar 2020 04:18:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584951502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9+djlOZkkG34kATfFU8ToSkWmnwBYyFJfZBQaAAXqqE=;
        b=ff3H/1U83yRD14IAenehHTsYOnLxAwE1b63zNc8hvl86g8isngV8/njcJlULsHserMUqGh
        B5TjJvinmKaApA1mw/Noc3sZWyRimlAzOXbiozbpTA/SpHmGLe8tjEg4yk8YisHtb94c24
        RO02CYBxb8T1I2eg7I4+wOY/sJ8xm24=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-XvRx1DvcPZKUMqk9mJyBUA-1; Mon, 23 Mar 2020 04:18:19 -0400
X-MC-Unique: XvRx1DvcPZKUMqk9mJyBUA-1
Received: by mail-wr1-f69.google.com with SMTP id d17so6991658wrw.19
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 01:18:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9+djlOZkkG34kATfFU8ToSkWmnwBYyFJfZBQaAAXqqE=;
        b=An1dR0zvdj0NrFXFWOrHUkqg6cjdWWDae6Tqn09corlf2yfP2Ao1FHK5QVVPbxGXS8
         t9dBV9MEronRCjuVdnrCj/RQHYJTAS+UY9CbNGlK7vbRznZt0V2TeqHeR1tvtLAWD/PQ
         MChTEcQegI82Vta4VlN6j6rJY4U7ZnosywqhNgV46lzRPKG1/HEBDBeztgHTpIU4kyjW
         snjjR3OSpuFtFQNsQEQFMZd2k8ZefmasT2fywBsFiUx0RolDQg8VOVRippjYhu5uFNLq
         TVnrjjqS9m6ZwCLa5sTR9alf1pkfwJZ7lfx6occHBU2ATC/qLPbKeWVRzGkGxsV4DiMI
         g0/w==
X-Gm-Message-State: ANhLgQ0knva7rgGZSzWkm15ua5YFXTAjdSxy33jkAYcILouMLm+eKMno
        7j9xpfDPxKhgQU0rTz8axebna/QjFvLQI6haQ2t57qnRI8648CCnPNPSK1T0gXNq2M0orWEPjxE
        12q6M8C1q6xR9
X-Received: by 2002:adf:fa8a:: with SMTP id h10mr6852183wrr.160.1584951497496;
        Mon, 23 Mar 2020 01:18:17 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuglqGpMjyGAXtjGXC9VUQZ55Okh6SKZ0pRVVSMnctABMUeYyFbQ50ib/snd3MA/dgnb/Bz0A==
X-Received: by 2002:adf:fa8a:: with SMTP id h10mr6852142wrr.160.1584951497210;
        Mon, 23 Mar 2020 01:18:17 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:24d8:ed40:c82a:8a01? ([2001:b07:6468:f312:24d8:ed40:c82a:8a01])
        by smtp.gmail.com with ESMTPSA id t126sm21823703wmb.27.2020.03.23.01.18.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2020 01:18:16 -0700 (PDT)
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in
 handle_external_interrupt_irqoff
To:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+3f29ca2efb056a761e38@syzkaller.appspotmail.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Cc:     Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, wanpengli@tencent.com,
        the arch/x86 maintainers <x86@kernel.org>
References: <000000000000277a0405a16bd5c9@google.com>
 <CACT4Y+b1WFT87pWQaXD3CWjyjoQaP1jcycHdHF+rtxoR5xW1ww@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5058aabe-f32d-b8ef-57ed-f9c0206304c5@redhat.com>
Date:   Mon, 23 Mar 2020 09:18:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CACT4Y+b1WFT87pWQaXD3CWjyjoQaP1jcycHdHF+rtxoR5xW1ww@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/03/20 07:59, Dmitry Vyukov wrote:
> 
> The commit range is presumably
> fb279f4e238617417b132a550f24c1e86d922558..63849c8f410717eb2e6662f3953ff674727303e7
> But I don't see anything that says "it's me". The only commit that
> does non-trivial changes to x86/vmx seems to be "KVM: VMX: check
> descriptor table exits on instruction emulation":

That seems unlikely, it's a completely different file and it would only
affect the outside (non-nested) environment rather than your own kernel.

The only instance of "0x86" in the registers is in the flags:

> RSP: 0018:ffffc90001ac7998 EFLAGS: 00010086
> RAX: ffffc90001ac79c8 RBX: fffffe0000000000 RCX: 0000000000040000
> RDX: ffffc9000e20f000 RSI: 000000000000b452 RDI: 000000000000b453
> RBP: 0000000000000ec0 R08: ffffffff83987523 R09: ffffffff811c7eca
> R10: ffff8880a4e94200 R11: 0000000000000002 R12: dffffc0000000000
> R13: fffffe0000000ec8 R14: ffffffff880016f0 R15: fffffe0000000ecb
> FS:  00007fb50e370700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000000000005c CR3: 0000000092fc7000 CR4: 00000000001426f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

That would suggest a miscompilation of the inline assembly, which does
push the flags:

#ifdef CONFIG_X86_64
                "mov %%" _ASM_SP ", %[sp]\n\t"
                "and $0xfffffffffffffff0, %%" _ASM_SP "\n\t"
                "push $%c[ss]\n\t"
                "push %[sp]\n\t"
#endif
                "pushf\n\t"
                __ASM_SIZE(push) " $%c[cs]\n\t"
                CALL_NOSPEC


It would not explain why it suddenly started to break, unless the clang
version also changed, but it would be easy to ascertain and fix (in
either KVM or clang).  Dmitry, can you send me the vmx.o and
kvm-intel.ko files?

Thanks,

Paolo

