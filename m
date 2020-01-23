Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74F83146B04
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 15:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbgAWOTS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 09:19:18 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:37660 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726780AbgAWOTR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Jan 2020 09:19:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579789156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YDv2ef9FnrxorJ3CMFZYXY9B9eJCmqU4SC6oBu9gqLE=;
        b=BnauTAydgNTgBxJ5kCjizNafZ1fNWO4VyV5Antf7AOKDnutPlEtF4KJleBlOE4Pts3Nn7F
        FbMwRFN7J4b/6C72ZSD2EkO9ti7vpTDnCamFkposa5ijKmWzrhsh+sd2bpVnT12+JVTVJP
        wEiHUZewiZzMpoQK0WOeAmARPvFauA4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-AmDa6WwENuuzwtfxySk11Q-1; Thu, 23 Jan 2020 09:19:15 -0500
X-MC-Unique: AmDa6WwENuuzwtfxySk11Q-1
Received: by mail-wr1-f71.google.com with SMTP id z15so1827731wrw.0
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2020 06:19:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YDv2ef9FnrxorJ3CMFZYXY9B9eJCmqU4SC6oBu9gqLE=;
        b=nelOqKgAvu987zyydRg0xG0lAzsiAfMCwFT/IIsspeao/gOaB8shl6HkDh2JARVhwE
         uksULXHY3VtpcwVy+pg+HyTTSnv9vkoc7UEWA74WuhKJqsV4tzp/3JAOTPtSFeqCX9OV
         PzZeYbYVWmg+vZMNyofJ6lUVyY9Sx+NKT/SyiK9i5aAhu7KGrC3UmZtfYE3pJzcANROT
         jgdrkVTDlF+mVbFmUcZR4fCzE1jWzluePeq02qUK5hCNcWoSjpx3acrYl+G742J2ntof
         Herv7EYfLqY7xYdKKQvvFb1+7XZkVsMpZzXvdlGqByKWcYCJPyZ7KTzefLKGuz4RjLIS
         FzMg==
X-Gm-Message-State: APjAAAVJWGj0nQb/nIvKvDE3k2Isbt7KKRye8N2RCQiNn0EH0d6wGpd5
        GE2iH7xJmppJ0agIJpNgirJx6yED6fBcH9fDmjM/8stPRP3tB12G+E3l6Cd67oL0HI8jOnxfrut
        sj58KFFxmVbt4
X-Received: by 2002:a7b:cbc8:: with SMTP id n8mr4492369wmi.35.1579789153820;
        Thu, 23 Jan 2020 06:19:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqwGkYAw9vZnAV9XdbWRiZp068hmOXpvS0ijNkKCbRvYjQzYqzzifxujgdjHNuDqClUTkOiNVA==
X-Received: by 2002:a7b:cbc8:: with SMTP id n8mr4492343wmi.35.1579789153571;
        Thu, 23 Jan 2020 06:19:13 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b8fe:679e:87eb:c059? ([2001:b07:6468:f312:b8fe:679e:87eb:c059])
        by smtp.gmail.com with ESMTPSA id c195sm3213035wmd.45.2020.01.23.06.19.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2020 06:19:13 -0800 (PST)
Subject: Re: [PATCH 2/2] kvm: Add ioctl for gathering debug counters
To:     Alexander Graf <graf@amazon.de>, milanpa@amazon.com,
        Milan Pandurov <milanpa@amazon.de>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, borntraeger@de.ibm.com
References: <20200115134303.30668-1-milanpa@amazon.de>
 <18820df0-273a-9592-5018-c50a85a75205@amazon.de>
 <8584d6c2-323c-14e2-39c0-21a47a91bbda@amazon.com>
 <ab84ee05-7e2b-e0cc-6994-fc485012a51a@amazon.de>
 <668ea6d3-06ae-4586-9818-cdea094419fe@redhat.com>
 <e77a2477-6010-ae1d-0afd-0c5498ba2117@amazon.de>
 <30358a22-084c-6b0b-ae67-acfb7e69ba8e@amazon.com>
 <7f206904-be2b-7901-1a88-37ed033b4de3@amazon.de>
 <7e6093f1-1d80-8278-c843-b4425ce098bf@redhat.com>
 <6f13c197-b242-90a5-3f53-b75aa8a0e5aa@amazon.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b69546be-a25c-bbea-7e37-c07f019dcf85@redhat.com>
Date:   Thu, 23 Jan 2020 15:19:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <6f13c197-b242-90a5-3f53-b75aa8a0e5aa@amazon.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/01/20 13:32, Alexander Graf wrote:
>> See above: I am not sure they are the same story because their consumers
>> might be very different from registers.  Registers are generally
>> consumed by programs (to migrate VMs, for example) and only occasionally
>> by humans, while stats are meant to be consumed by humans.  We may
>> disagree on whether this justifies a completely different API...
> 
> I don't fully agree on the "human" part here.

I agree it's not entirely about humans, but in general it's going to be
rules and queries on monitoring tools, where 1) the monitoring tools'
output is generally not KVM-specific, 2) the rules and queries will be
written by humans.

So if the kernel produces insn_emulation_fail, the plugin for the
monitoring tool will just log kvm.insn_emulation_fail.  If the kernel
produces 0x10042, the plugin will have to convert it and then log it.
This is why I'm not sure that providing strings is actually less work
for userspace.

Paolo

> At the end of the day, you
> want stats because you want to act on stats. Ideally, you want to do
> that fully automatically. Let me give you a few examples:
> 
> 1) insn_emulation_fail triggers
> 
> You may want to feed all the failures into a database to check whether
> there is something wrong in the emulator.
> 
> 2) (remote_)tlb_flush beyond certain threshold
> 
> If you see that you're constantly flushing remote TLBs, there's a good
> chance that you found a workload that may need tuning in KVM. You want
> to gather those stats across your full fleet of hosts, so that for the
> few occasions when you hit it, you can work with the actual VM owners to
> potentially improve their performance
> 
> 3) exits beyond certain threshold
> 
> You know roughly how many exits your fleet would usually see, so you can
> configure an upper threshold on that. When you now have an automated way
> to notify you when the threshold is exceeded, you can check what that
> particular guest did to raise so many exits.
> 
> 
> ... and I'm sure there's room for a lot more potential stats that could
> be useful to gather to determine the health of a KVM environment, such
> as a "vcpu steal time" one or a "maximum time between two VMENTERS while
> the guest was in running state".
> 
> All of these should eventually feed into something bigger that collects
> the numbers across your full VM fleet, so that a human can take actions
> based on them. However, that means the values are no longer directly
> impacting a human, they need to feed into machines. And for that, exact,
> constant identifiers make much more sense

