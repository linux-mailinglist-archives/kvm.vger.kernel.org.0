Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6189420915
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 12:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbhJDKMu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 06:12:50 -0400
Received: from mout-p-102.mailbox.org ([80.241.56.152]:60732 "EHLO
        mout-p-102.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbhJDKMs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 06:12:48 -0400
X-Greylist: delayed 3742 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Oct 2021 06:12:48 EDT
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4HNGh303SZzQkBK;
        Mon,  4 Oct 2021 12:10:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
        content-transfer-encoding:content-type:content-type:mime-version
        :subject:subject:references:in-reply-to:message-id:from:from
        :date:date:received; s=mail20150812; t=1633342256; bh=eS2EPe4eHl
        2N1wDjzplFdaJCLfRzATCMbKor42NuLwQ=; b=E5gsHViEF9b6Qz9kxmyyixgv63
        kgOfreOt975wyzF4qnLA2hTIqdcoBa6zprAKzC7UN8NqIyAveBotnzd+GFVX+PfP
        VDd7q3wkmW+pvIaTlZJhU9asm/yJkqZSUJm7q/ii1UVv1gfA9wjvrSSYeF76j3s4
        98tCJbElMG2Jw0Jq6IBILOrC1JOV1mJMMG0hCxM997GDW3JDayTrGSvITetvgTBa
        trBUEvv5iPUe/kAa6CRzc4ZPyK352eHuMuXfNrP7dYRkVN2WZQat2OGb8yx8F1TP
        3Hid3uLhVNoYn2lr/ZGbicG6EBqV8OuU8i+4Gkb4DFkCaKZYnYSofJaiwdgg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1633342257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zP6aY9O1wW8f739eGeU+KeGXD/SGH19xgBt/Oo3Iwx8=;
        b=X+A/g8xWEi631k+mYpNmmMPDPuTcV9ftD+BsgNIoMqmOSUSFoILCzqjftRpMzGneEQ8PjR
        lL6UYvywXHAciMZ2qSJxr2p5Xzh1FRRo+wGdoPAeKB1Cqgpp6u0bLsxedHz4ZWvNNLp59U
        hitOCjveWwngbocwdfcOUqmUQPBh2b1YmMXCd1QrVGh9KFPqX1mUwZfIaN2zjREwGnVR7J
        jIJlZOJsfV7ZxItfzPC5ILIkWuLFcJA4/Fd9gtaxbWiuQYLAmG5tQK+/yzOH4BlNNlGsYo
        z52jIWktVJuJkVKp+DiPIVtoSlWSfCqaqdOa0iIcxdRBBfIpInSo6aeg7kPKBQ==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Date:   Mon, 4 Oct 2021 12:10:55 +0200 (CEST)
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
Message-ID: <1723492337.161319.1633342255263@office.mailbox.org>
In-Reply-To: <c4773ecc-053f-9bc6-03af-5039397a4531@redhat.com>
References: <1446878298.170497.1633338512925@office.mailbox.org>
 <b6abc5a3-39ea-b463-9df5-f50bdcb16d08@redhat.com>
 <936688112.157288.1633339838738@office.mailbox.org>
 <c4773ecc-053f-9bc6-03af-5039397a4531@redhat.com>
Subject: Re: [BUG] [5.15] Compilation error in arch/x86/kvm/mmu/spte.h with
 clang-14
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Rspamd-Queue-Id: 02CE317FC
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> Paolo Bonzini <pbonzini@redhat.com> hat am 04.10.2021 11:49 geschrieben:
> 
>  
> On 04/10/21 11:30, torvic9@mailbox.org wrote:
> > 
> >> Paolo Bonzini <pbonzini@redhat.com> hat am 04.10.2021 11:26 geschrieben:
> >>
> >>   
> >> On 04/10/21 11:08, torvic9@mailbox.org wrote:
> >>> I encounter the following issue when compiling 5.15-rc4 with clang-14:
> >>>
> >>> In file included from arch/x86/kvm/mmu/mmu.c:27:
> >>> arch/x86/kvm/mmu/spte.h:318:9: error: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
> >>>           return __is_bad_mt_xwr(rsvd_check, spte) |
> >>>                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >>>                                                    ||
> >>> arch/x86/kvm/mmu/spte.h:318:9: note: cast one or both operands to int to silence this warning
> >>
> >> The warning is wrong, as mentioned in the line right above:
> > 
> > So it's an issue with clang-14 then?
> > (I add Nick and Nathan)
> 
> My clang here doesn't have the option, so I'm going to ask---are you 
> using W=1?  I can see why clang is warning for KVM's code, but in my 
> opinion such a check should only be in -Wextra.

I don't use any options (not that I'm aware of).
Clang version 14.0.0 5f7a5353301b776ffb0e5fb048992898507bf7ee

> 
> Paolo
> 
> >>
> >>           /*
> >>            * Use a bitwise-OR instead of a logical-OR to aggregate the reserved
> >>            * bits and EPT's invalid memtype/XWR checks to avoid an extra Jcc
> >>            * (this is extremely unlikely to be short-circuited as true).
> >>            */
> >>
> >> Paolo
> >
