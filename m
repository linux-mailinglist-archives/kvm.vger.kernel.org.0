Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBBC421179
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 16:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234290AbhJDOf2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 10:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234490AbhJDOf0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 10:35:26 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B27C061745;
        Mon,  4 Oct 2021 07:33:37 -0700 (PDT)
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:105:465:1:4:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4HNNW32xxLzQkhP;
        Mon,  4 Oct 2021 16:33:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
        content-transfer-encoding:content-type:content-type:mime-version
        :subject:subject:references:in-reply-to:message-id:from:from
        :date:date:received; s=mail20150812; t=1633358011; bh=i464Ru14yK
        p+tO7OJAFrwLQPSlMjtYA/mmJLgmITXH4=; b=OsmnW3zZynDb1Dgz8yOjPO8lYQ
        NHLIkKDcdTUFZtwm0F+3KZA9Y2wIZMtW2rTawq+iEAy6MoOvCk56dZhIK1OXGqWG
        D4jfqu41VLeOw4Eqi/32dr1C+n+xssb6C+3XtgAkcEsjNvgednC4/TEsqPWBWMXS
        kTPFfQTtoEp5IIQuHOb6C3kERfslEEiYmfqpgjqzbwP3l21HzU3DBm6E0jO1oKga
        PZfw1RSUVzhQ6qz7G42wDSuDLtaH2rJkNrJocUfZhfBDOAnybvziZUIcyTlKiCmT
        ZVDS3QAaFZpvCAEZZyI0xS88niEVGXBcZdPvYwIGB+lVioJC8sH2vVwTyFWg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1633358013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rmjeYd7vcU5PyUKxcIasco2LgsFeZ5uHoTR73KzRdkU=;
        b=qosJzPDRamsy1m8+HMsW6BkZ002WDNwtFpshGAY6fIZfXAMg5LGsAUzcjcp5eAbue7dYjZ
        eD6qv80iabD/DDtaD6HsI7UcJnNFxTCm43z2DaBVUzDsKtW54PZTS1nEwHoQlhBgc/bMAC
        I2wHuzSH8qFgLbff4NcipABC0mOrnEQupb4hfAXsCTzKcDznnLnNQbvIQCbnNCHTv+GAvQ
        7aNFJevKbmaz4vxdMOZQpr/Ue6Y7Fmzanll8X/QWv0TUnPEWN0XX6mO4Vz05WWVHJFpeqX
        1SITC32l6/SRNQJcVhS81k+iz7b/GHGEJ29f/MXvfeHIbtPUCjMDxIGT1I2p6A==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Date:   Mon, 4 Oct 2021 16:33:30 +0200 (CEST)
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
Message-ID: <1033024644.226.1633358010150@office.mailbox.org>
In-Reply-To: <1723492337.161319.1633342255263@office.mailbox.org>
References: <1446878298.170497.1633338512925@office.mailbox.org>
 <b6abc5a3-39ea-b463-9df5-f50bdcb16d08@redhat.com>
 <936688112.157288.1633339838738@office.mailbox.org>
 <c4773ecc-053f-9bc6-03af-5039397a4531@redhat.com>
 <1723492337.161319.1633342255263@office.mailbox.org>
Subject: Re: [BUG] [5.15] Compilation error in arch/x86/kvm/mmu/spte.h with
 clang-14
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Rspamd-Queue-Id: C24A526A
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> torvic9@mailbox.org hat am 04.10.2021 12:10 geschrieben:
> 
>  
> > Paolo Bonzini <pbonzini@redhat.com> hat am 04.10.2021 11:49 geschrieben:
> > 
> >  
> > On 04/10/21 11:30, torvic9@mailbox.org wrote:
> > > 
> > >> Paolo Bonzini <pbonzini@redhat.com> hat am 04.10.2021 11:26 geschrieben:
> > >>
> > >>   
> > >> On 04/10/21 11:08, torvic9@mailbox.org wrote:
> > >>> I encounter the following issue when compiling 5.15-rc4 with clang-14:
> > >>>
> > >>> In file included from arch/x86/kvm/mmu/mmu.c:27:
> > >>> arch/x86/kvm/mmu/spte.h:318:9: error: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
> > >>>           return __is_bad_mt_xwr(rsvd_check, spte) |
> > >>>                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > >>>                                                    ||
> > >>> arch/x86/kvm/mmu/spte.h:318:9: note: cast one or both operands to int to silence this warning
> > >>
> > >> The warning is wrong, as mentioned in the line right above:
> > > 
> > > So it's an issue with clang-14 then?
> > > (I add Nick and Nathan)
> > 
> > My clang here doesn't have the option, so I'm going to ask---are you 
> > using W=1?  I can see why clang is warning for KVM's code, but in my 
> > opinion such a check should only be in -Wextra.
> 
> I don't use any options (not that I'm aware of).
> Clang version 14.0.0 5f7a5353301b776ffb0e5fb048992898507bf7ee

Probably the cause for this bug is this recent llvm commit:
https://github.com/llvm/llvm-project/commit/f59cc9542bfb461d16ad12b2cc4be4abbfd9d96e

> 
> > 
> > Paolo
> > 
> > >>
> > >>           /*
> > >>            * Use a bitwise-OR instead of a logical-OR to aggregate the reserved
> > >>            * bits and EPT's invalid memtype/XWR checks to avoid an extra Jcc
> > >>            * (this is extremely unlikely to be short-circuited as true).
> > >>            */
> > >>
> > >> Paolo
> > >
