Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D196142ABE0
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 20:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233644AbhJLS2K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 14:28:10 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:57532 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232880AbhJLS2J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 14:28:09 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634063149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=970N41MnZaYG7XtxW9PflsvxxFaQSnO5Y31eDQi0zqs=;
        b=KQX3sdrxdFpb4/y3y2CrcGl6ttIYlsFbIf8Fu4vUFaCzJvTq2sC+TrnTgvHuyQpCz63/5M
        fpgsnK+JX/x0p4p7eq8pJESz8sOwlLQ9r09NuD3AJRykdnpoQGZo0aSXg3nJwKNcFhApdU
        8LkB/NvAY3qqvXZ3EOtFW4Xlh6jwtm38Rs6bgr82bRHaiHWskdOB3U/sekFLRBuVZwiYpJ
        kwS2sCBvEIgUZ2tBIaDb8FOAdf9A1m8IGkHe/hG4X6X+A6dmB4BE4TXI9YinMCK/06ABF/
        Oyd53rHJ1HcS9QSYHqzm9WMCI2e96QVq49p9dR/wzH1Sfm+rl/Myov6ydBzu5w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634063149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=970N41MnZaYG7XtxW9PflsvxxFaQSnO5Y31eDQi0zqs=;
        b=282idd15MvIFaubRWInSIyOBhseW/Xxnvokrt+2EY3RMBlR96iUJmjM6M2ZxIS5VWgc2d3
        DJr+N/UDe8lNmtAQ==
To:     Borislav Petkov <bp@alien8.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
In-Reply-To: <YWW9ksxtp4hpT0GI@zn.tnic>
References: <20211011215813.558681373@linutronix.de>
 <20211011223611.069324121@linutronix.de> <YWW9ksxtp4hpT0GI@zn.tnic>
Date:   Tue, 12 Oct 2021 20:25:48 +0200
Message-ID: <87czoaaymr.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 12 2021 at 18:53, Borislav Petkov wrote:
> On Tue, Oct 12, 2021 at 02:00:17AM +0200, Thomas Gleixner wrote:
>>  	/*
>> -	 * Guests with protected state can't have it set by the hypervisor,
>> -	 * so skip trying to set it.
>> +	 * Guest with protected state have guest_fpu == NULL which makes
>
> "Guests ... "
>
>> +	 * the swap only safe the host state. Exclude PKRU from restore as
>
> "save"

No I meant safe, but let me rephrase it, Swap does both save and
restore. But it's not safe to dereference a NULL pointer :)

 .... makes the swap only handle the host state. Exclude PKRU from restore as

Thanks,

        tglx
