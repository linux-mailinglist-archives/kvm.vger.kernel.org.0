Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 825C115AD62
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 17:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbgBLQ2Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 11:28:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:42408 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728226AbgBLQ2Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 11:28:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A042FB071;
        Wed, 12 Feb 2020 16:28:23 +0000 (UTC)
Subject: Re: [PATCH 23/62] x86/idt: Move IDT to data segment
To:     Andy Lutomirski <luto@amacapital.net>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>
References: <20200212115516.GE20066@8bytes.org>
 <EEAC8672-C98F-45D0-9F2D-0802516C3908@amacapital.net>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <879ace44-cee3-98aa-0dff-549b69355096@suse.com>
Date:   Wed, 12 Feb 2020 17:28:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <EEAC8672-C98F-45D0-9F2D-0802516C3908@amacapital.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12.02.20 17:23, Andy Lutomirski wrote:
> 
> 
>> On Feb 12, 2020, at 3:55 AM, Joerg Roedel <joro@8bytes.org> wrote:
>>
>> ﻿On Tue, Feb 11, 2020 at 02:41:25PM -0800, Andy Lutomirski wrote:
>>>> On Tue, Feb 11, 2020 at 5:53 AM Joerg Roedel <joro@8bytes.org> wrote:
>>>>
>>>> From: Joerg Roedel <jroedel@suse.de>
>>>>
>>>> With SEV-ES, exception handling is needed very early, even before the
>>>> kernel has cleared the bss segment. In order to prevent clearing the
>>>> currently used IDT, move the IDT to the data segment.
>>>
>>> Ugh.  At the very least this needs a comment in the code.
>>
>> Yes, right, added a comment for that.
>>
>>> I had a patch to fix the kernel ELF loader to clear BSS, which would
>>> fix this problem once and for all, but it didn't work due to the messy
>>> way that the decompressor handles memory.  I never got around to
>>> fixing this, sadly.
>>
>> Aren't there other ways of booting (Xen-PV?) which don't use the kernel
>> ELF loader?
> 
> Dunno. I would hope the any sane loader would clear BSS before executing anything. This isn’t currently the case, though. Oh well.

Xen-PV is clearing BSS as the very first action.


Juergen
