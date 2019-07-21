Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0B26F433
	for <lists+kvm@lfdr.de>; Sun, 21 Jul 2019 18:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfGUQvM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Jul 2019 12:51:12 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51149 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfGUQvM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Jul 2019 12:51:12 -0400
Received: by mail-wm1-f66.google.com with SMTP id v15so32946606wml.0
        for <kvm@vger.kernel.org>; Sun, 21 Jul 2019 09:51:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/qhfeHSiMexw5eQJpU5Wbr90RfewcH7B3yhTNyxrERI=;
        b=JoPVvvFQ16ElJV5j+PVhZjI6VkTqoXstzyqxbH7bIf+mQbri0FKm991J4sB3an5g+S
         O0mPuJWgpHA0XKy4HUkHNTcX3bFp9k1XaDRJ4BtUkhlauXI4Wx6GWFZoh9Edu8g7M5Zc
         0kCw98AGCL8DFTzj2w+idm6+Qc1fEkz3VS3BUhmdKeaAgTxPf1V0QPCpSyz8kambumWt
         zdcPQUPDSVr1h12OChqeBPllDkWIQyQl3PAjohriGypiTlZHasjYeUkKvYVyThc60Uvm
         mVI97t6/taseVzNOkCzheG4Vc5EJSRMsPB2ucHXl5kFs7sNlyK+gHcilbCisHr05q9uD
         eI3A==
X-Gm-Message-State: APjAAAU123NDlEz+WOleS6ygT+PBP89DjPniozBe7m2vITO1PUjMUUmR
        D1JrGAcFpv72TNsCIF1qS7CtG7ufe08=
X-Google-Smtp-Source: APXvYqw45mGPmjr0VC0bZVlqCMJtuic0OzY7ShhsPKKAAx7qxIMC7isImmwG7xUe+jEB0AfwUt9gcQ==
X-Received: by 2002:a1c:2e09:: with SMTP id u9mr59966911wmu.137.1563727870194;
        Sun, 21 Jul 2019 09:51:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:59c3:355d:cfd:35b0? ([2001:b07:6468:f312:59c3:355d:cfd:35b0])
        by smtp.gmail.com with ESMTPSA id y16sm75440249wrg.85.2019.07.21.09.51.09
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Jul 2019 09:51:09 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 3/3] x86: Support environments without
 test-devices
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Andrew Jones <drjones@redhat.com>, kvm list <kvm@vger.kernel.org>
References: <20190628203019.3220-1-nadav.amit@gmail.com>
 <20190628203019.3220-4-nadav.amit@gmail.com>
 <20190715154812.mlw4toyzkpwsfrfm@kamzik.brq.redhat.com>
 <FFD1C3FC-C442-4953-AFA6-0FFADDEA8351@gmail.com>
 <ab5e8e73-5214-e455-950d-e837979bb536@redhat.com>
 <9A78B004-E8B8-427A-B522-C0847CBEFDD3@gmail.com>
 <91f59a9e-f225-b225-079b-f4ef32724163@redhat.com>
 <08914961-07E1-4B78-AC80-1755F0B98BCE@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <8a54afaf-09a8-9423-3514-65e38cd14272@redhat.com>
Date:   Sun, 21 Jul 2019 18:51:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <08914961-07E1-4B78-AC80-1755F0B98BCE@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/07/19 18:40, Nadav Amit wrote:
>> On Jul 15, 2019, at 11:54 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 15/07/19 20:43, Nadav Amit wrote:
>>>> On Jul 15, 2019, at 11:26 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>>> On 15/07/19 20:08, Nadav Amit wrote:
>>>>>> This works because setup_multiboot() looks for an initrd, and then,
>>>>>> if present, it gets interpreted as a list of environment variables
>>>>>> which become the unit tests **envp.
>>>>>
>>>>> Looks like a nice solution, but Paolo preferred to see if this information
>>>>> can be extracted from e810 and ACPI MADT. Paolo?
>>>>
>>>> It was mostly a matter of requiring adjustments in the tests.  Andrew's
>>>> solution would be fine!
>>>
>>> Ok, but I must be missing something, because the changes I proposed before
>>> did not require any changes to the tests either (when they are run on top
>>> of KVM).
>>
>> You're right, I was confused.  There were changes to a couple tests but
>> they are not related to fw_cfg.  I only disliked having to repeat the
>> same information (as opposed to just the initrd path) in all the
>> entries.  Memory map and MADT would be my preferred choice, but as a
>> stopgap Andrew's idea is okay.
>>
>> Paolo
>>
>>> Andrew’s solution would just make it easier to set “fixed” boot-loader
>>> entries, although they would still need a different root and
>>> boot-relative-path on different machines.
> 
> Paolo, can you please push all (or at my) queued patches?
> 
> I prefer to work on the latest code (including my patches that were queued),
> and anyhow kvm-unit-tests repository is broken right now and does not build.

Oops, sorry.  I pushed now

Paolo
