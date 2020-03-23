Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC0E18FDD0
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 20:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725866AbgCWTkH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 15:40:07 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:28301 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725710AbgCWTkG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Mar 2020 15:40:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584992405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uFP2aeHKGeRXBgby7kJAWTWaWKoNQIcpjzLubNvUNy4=;
        b=YHFNMZAy3PRHh8Vr78P+HyxwEOyJUs1Hr9Aw9sBs0Wet2cKQvXNHh6y1pIFs9zNrtemUuZ
        2hfzq7ghiejgvQlVDDIhKjdBdDUW31y7stfrg1U//VNtyLlFtPqDc3YYROK3SrkEnVd4h4
        EgaQ7vZREjLK4lhXtItw/qzx1/8O+2E=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-77W2aAS8O7qc8_U4kRs5Jw-1; Mon, 23 Mar 2020 15:40:01 -0400
X-MC-Unique: 77W2aAS8O7qc8_U4kRs5Jw-1
Received: by mail-wm1-f71.google.com with SMTP id g26so239402wmk.6
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 12:40:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uFP2aeHKGeRXBgby7kJAWTWaWKoNQIcpjzLubNvUNy4=;
        b=kwwrRf4D4/Ei4bQfPfm9QXj6MpVDjZN1z7LWxDK9zBwiHCZ5Z39xPgpejxcM15+zmf
         pvMe7aBudQxxHf91ZakNfWBIA7Tk+nxwF0WvsnVEOX+i9n/tLyuHo55k/kh129L1k0hB
         QscPzrmYiZofDD8RWmKEVf6yzuRTxqE0/vkPee09yfSMH6mzLBhfBhP1Fctat4gEl5Kr
         hTLmqt2IdgnqHnzEvPj+SPP05BFaPWcCmYkOe4ikj/nfcNna8G8DmkSy477fWzLRHaMn
         0VAjrvuCFdnBet3V3BF+DfMRtunPjkdZNMMMfrb/VsuofITwxLBlJ1aX9CxLzqyt/xP7
         PI8w==
X-Gm-Message-State: ANhLgQ3m8jvxYxBRY+3ETMeuJMiS+gD/HL0AXkLana8Lekm2aYJ+Sg08
        XmIjj+eb5MiOFCDJO5b9KjMkgpNEuP6Laq427DhZIU+yQuwJMni2jrPidrYysEGzqC03vkb5R0B
        F+bLZ7fppRdGE
X-Received: by 2002:adf:f68b:: with SMTP id v11mr15340135wrp.270.1584992400618;
        Mon, 23 Mar 2020 12:40:00 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtb9sJ0klZwvu/ku5OHvFSKtheHaljJAS9COoNF60eMSuAIuFOCsUvPZQRvAlkMozUi9uetmA==
X-Received: by 2002:adf:f68b:: with SMTP id v11mr15340093wrp.270.1584992400294;
        Mon, 23 Mar 2020 12:40:00 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:24d8:ed40:c82a:8a01? ([2001:b07:6468:f312:24d8:ed40:c82a:8a01])
        by smtp.gmail.com with ESMTPSA id c23sm25417876wrb.79.2020.03.23.12.39.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2020 12:39:59 -0700 (PDT)
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in
 handle_external_interrupt_irqoff
To:     Nick Desaulniers <ndesaulniers@google.com>,
        Alexander Potapenko <glider@google.com>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+3f29ca2efb056a761e38@syzkaller.appspotmail.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <000000000000277a0405a16bd5c9@google.com>
 <CACT4Y+b1WFT87pWQaXD3CWjyjoQaP1jcycHdHF+rtxoR5xW1ww@mail.gmail.com>
 <5058aabe-f32d-b8ef-57ed-f9c0206304c5@redhat.com>
 <CAG_fn=WYtSoyi63ACaz-ya=Dbi+BFU-_mADDpL6gQvDimQscmw@mail.gmail.com>
 <20200323163925.GP28711@linux.intel.com>
 <CAKwvOdkE8OAu=Gj4MKWwpctka6==6EtrbF3e1tvF=jS2hBB3Ow@mail.gmail.com>
 <CAKwvOdkXi1MN2Yqqoa6ghw14tQ25WYgyJkSv35-+1KRb=cmhZw@mail.gmail.com>
 <CAG_fn=WE0BmuHSxUoBJWQ9dnZ4X5ZpBqcT9rQaDE_6HAfTYKQA@mail.gmail.com>
 <CAG_fn=Uf2dDo4K9X==wE=eL8HQMc1an8m8H18tvWd9Mkyhpskg@mail.gmail.com>
 <CAKwvOdntYiM8afOA2nX6dtLp9FWk-1E3Mc+oVRJ_Y8X-9kr81Q@mail.gmail.com>
 <CAKwvOdn10Ts_AU6i+7toj7NkMwK-+0yr5wTrN0XEDudBWS0sPQ@mail.gmail.com>
 <CAKwvOdnwhoHe8ouao2VBo1meRd8H4EOC7Nr8hnFkbXBACWRm9w@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <887add8e-cc74-b50b-46f8-f51d39c12dff@redhat.com>
Date:   Mon, 23 Mar 2020 20:39:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAKwvOdnwhoHe8ouao2VBo1meRd8H4EOC7Nr8hnFkbXBACWRm9w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/03/20 20:30, Nick Desaulniers wrote:
> <ndesaulniers@google.com> wrote:
>> So maybe we can find why
>> commit 76b043848fd2 ("x86/retpoline: Add initial retpoline support")
>> added THUNK_TARGET with and without "m" constraint, and either:
>> - remove "m" from THUNK_TARGET. (Maybe this doesn't compile somewhere)
>> or
>> - use my above recommendation locally avoiding THUNK_TARGET.  We can
>> use "r" rather than "a" (what Clang would have picked) or "b (what GCC
>> would have picked) to give the compilers maximal flexibility.
> So I've sent a patch for the latter; my reason for not pursuing the former is:
> 1. I assume that the thunk target could be spilled, or a pointer, and
> we'd like to keep flexibility for the general case of inline asm that
> doesn't modify the stack pointer.
> 2. `entry` is local to `handle_external_interrupt_irqoff`; it's not
> being passed in via pointer as a function parameter.
> 3. register pressure is irrelevant if the resulting code is incorrect.

Yes, this is fair enough.  I've queued your patch and will send it
shortly to Linus.

Paolo

