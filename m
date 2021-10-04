Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E767420847
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 11:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbhJDJce (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 05:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbhJDJcd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 05:32:33 -0400
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4989BC061745;
        Mon,  4 Oct 2021 02:30:44 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4HNFnZ3JgczQjXt;
        Mon,  4 Oct 2021 11:30:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
        content-transfer-encoding:content-type:content-type:mime-version
        :subject:subject:references:in-reply-to:message-id:from:from
        :date:date:received; s=mail20150812; t=1633339839; bh=sbEfYmQ23Q
        vu8D8/RZouroNeiIIWprZ9RTuGxdV0BSc=; b=eqRUGkp2yL1ikWCRHz8Pp+WnRD
        0hVqOTG2tQJp52WM4V49maypqRWQiEKG20btW1eFInSEkMH5h01+IoM+qikCYGgZ
        23SGPJfVrdNKHfbGfRbvRPwmn0f3k/MybfdRJLWp7pLp9kJ4o3tMH3rNfuryttiS
        irDG9Q9F8MeAozq4790NvVuB/rKZn6eYygMqOpkTyGo9DaxwM1rMKJceWFcRN28t
        bog2xHoAyQpjTlvL5YCLgMK5ZUD+kEfhm1quCKXeTxZ4Eox+XiVS5XGn0gmtvHIN
        ha6jFQ5LqbgEeciGTdNq4Is9YdAC+8Wmh3e2+cUNo3mZAuevkqaOWXW8zaDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1633339840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qDWb0AQbPRhLuuiVXOuwpRGrvAqOKBzlkNJRcCEystg=;
        b=qum8pNN8AuJ/l/+XRPTRfr4C1+ucBBQXjR09LNuRJB38B/6YhqqUhjeN7NajZ1Z0V8hmb+
        AeBAz4DI41IzUWP9uAIgmQ7K4ByYaKjLPAS2XuTKXZpOgGD0Bqx3yt77O6Msc7lr5sdOHV
        F6gSnRsiLvmHSeWPazhCMIqAeizup5ySyeikiQvRnz1NhWYJcm1ha44yFyAzKxe4ecgn+/
        qV/9UfQ3rrQeda1j7dGgeCuIHceACTmHpCoIC+69PzAruMycPLGWEvYv2S6imKRbvCV/OU
        B+PFRXiOYdT/d1PcCEn1v6GJiPN24ZSl22ObbUui4mz3jP1XVgrIWGNvTb3GoQ==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Date:   Mon, 4 Oct 2021 11:30:38 +0200 (CEST)
From:   torvic9@mailbox.org
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "nathan@kernel.org" <nathan@kernel.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>
Message-ID: <936688112.157288.1633339838738@office.mailbox.org>
In-Reply-To: <b6abc5a3-39ea-b463-9df5-f50bdcb16d08@redhat.com>
References: <1446878298.170497.1633338512925@office.mailbox.org>
 <b6abc5a3-39ea-b463-9df5-f50bdcb16d08@redhat.com>
Subject: Re: [BUG] [5.15] Compilation error in arch/x86/kvm/mmu/spte.h with
 clang-14
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Rspamd-Queue-Id: 71A0F1839
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> Paolo Bonzini <pbonzini@redhat.com> hat am 04.10.2021 11:26 geschrieben:
> 
>  
> On 04/10/21 11:08, torvic9@mailbox.org wrote:
> > I encounter the following issue when compiling 5.15-rc4 with clang-14:
> > 
> > In file included from arch/x86/kvm/mmu/mmu.c:27:
> > arch/x86/kvm/mmu/spte.h:318:9: error: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
> >          return __is_bad_mt_xwr(rsvd_check, spte) |
> >                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >                                                   ||
> > arch/x86/kvm/mmu/spte.h:318:9: note: cast one or both operands to int to silence this warning
> 
> The warning is wrong, as mentioned in the line right above:

So it's an issue with clang-14 then?
(I add Nick and Nathan)

> 
>          /*
>           * Use a bitwise-OR instead of a logical-OR to aggregate the reserved
>           * bits and EPT's invalid memtype/XWR checks to avoid an extra Jcc
>           * (this is extremely unlikely to be short-circuited as true).
>           */
> 
> Paolo
