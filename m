Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F411F2F7520
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 10:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbhAOJVp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 04:21:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbhAOJVo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 04:21:44 -0500
X-Greylist: delayed 1444 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 15 Jan 2021 01:21:04 PST
Received: from manul.sfritsch.de (manul.sfritsch.de [IPv6:2a01:4f8:172:195f:112::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43BB7C061757;
        Fri, 15 Jan 2021 01:21:04 -0800 (PST)
Subject: Re: [PATCH] kvm: Add emulation for movups/movupd
To:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20180401155444.7006-1-sf@sfritsch.de>
 <20180404171040.GW5438@char.us.oracle.com>
 <288c32e4-a1ec-7b43-0d6a-6a7c0e1a04b2@redhat.com> <1883982.uaQK4EgVKX@k>
 <321b36c9-d6fc-b562-5f87-3d3594e7ead9@redhat.com>
 <CALMp9eR0OjUV7LsWQ_r4o20wSZ0dw0eGs=LJ0htLmwwvcuUP_A@mail.gmail.com>
From:   Stefan Fritsch <sf@sfritsch.de>
Message-ID: <884f1474-3654-95c4-9a57-338d28e65b38@sfritsch.de>
Date:   Fri, 15 Jan 2021 09:56:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eR0OjUV7LsWQ_r4o20wSZ0dw0eGs=LJ0htLmwwvcuUP_A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 13.01.21 um 00:47 schrieb Jim Mattson:
> On Wed, Apr 4, 2018 at 10:44 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 04/04/2018 19:35, Stefan Fritsch wrote:
>>> On Wednesday, 4 April 2018 19:24:20 CEST Paolo Bonzini wrote:
>>>> On 04/04/2018 19:10, Konrad Rzeszutek Wilk wrote:
>>>>> Should there be a corresponding test-case?
>>>>
>>>> Good point!  Stefan, could you write one?
>>>
>>> Is there infrastructure for such tests? If yes, can you give me a pointer to
>>> it?
>>
>> Yes, check out x86/emulator.c in
>> https://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git.  There is
>> already a movaps test.
> 
> Whatever became of this unit test? I don't see it in the
> kvm-unit-tests repository.
> 

Sorry, I did not get around to doing this. And it is unlikely that I 
will have time to do it in the near future.

Cheers,
Stefan
