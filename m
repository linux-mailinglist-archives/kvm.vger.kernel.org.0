Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86242DC142
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 14:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbgLPN22 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 08:28:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:40744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725550AbgLPN22 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Dec 2020 08:28:28 -0500
Date:   Wed, 16 Dec 2020 14:27:42 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608125267;
        bh=0kqyUnhS90m5eS6ffbeZkQJSHy8Oh8fc4tSplwrR/Us=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=cwd8n5r2hhlkUQOLKq05vbxMjkkscRGDvCrLTRWaNvrJXgzZulMrrbEqyxTni/LGQ
         5f7FuDPZUfPDaOcG9g3kvdajLxQmEDXIyBOTcSZt7dljDJUtAEYb67s4PeErfuhOEB
         z8FYG1XT4diaPp/FOdJyYocgs+PJmO9QCTAbjk9AGbE9d1P/A5Uzg3wfgbfKI67/CQ
         U5kcGGfsuhpkxPN9SVg0yLZhsLa94KH27a6I+VdQuIFg6Ea17rZ6X6V2Sl8x76ivZo
         tljREsAkV12RHVmbGXFW4uDuttM7d/nGPNVnXVF8eHB3s5+/rBSRlOK/18zCucwyG9
         SDOw84pu0+IGQ==
From:   Jessica Yu <jeyu@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Dexuan Cui <decui@microsoft.com>, Ingo Molnar <mingo@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: static_branch_enable() does not work from a __init function?
Message-ID: <20201216132742.GD13751@linux-8ccs>
References: <MW4PR21MB1857CC85A6844C89183C93E9BFC59@MW4PR21MB1857.namprd21.prod.outlook.com>
 <20201216092649.GM3040@hirez.programming.kicks-ass.net>
 <20201216115524.GA13751@linux-8ccs>
 <20201216124708.GZ3021@hirez.programming.kicks-ass.net>
 <20201216131016.GC13751@linux-8ccs>
 <20201216132312.GA3021@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201216132312.GA3021@hirez.programming.kicks-ass.net>
X-OS:   Linux linux-8ccs 4.12.14-lp150.12.61-default x86_64
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+++ Peter Zijlstra [16/12/20 14:23 +0100]:
>On Wed, Dec 16, 2020 at 02:10:16PM +0100, Jessica Yu wrote:
>> +++ Peter Zijlstra [16/12/20 13:47 +0100]:
>
>> > Only because we're having .init=false, incorrectly. See the other email.
>>
>> Ah yeah, you're right. I also misread the intention of the if
>> conditional :/ If we're currently running an init function it's fine,
>> but after that it will be unsafe.
>
>Exactly, seeing how it'll end up being freed and such ;-)
>
>> Btw, your patch seems to work for me, using the test module provided
>> by Dexuan.
>
>Ah, excellent. I couldn't be bothered to figure out how to build a
>module ;-)
>
>I'll add your Tested-by and go queue it for /urgent I suppose.

That's fine by me :-)

    Tested-by: Jessica Yu <jeyu@kernel.org>

