Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 893FD17B9B8
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 11:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbgCFKAS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 05:00:18 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25300 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726070AbgCFKAS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 05:00:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583488817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AVZKZRodnT8m61EYZkSnJRTdxqQpltbB/y6KfgTIT1g=;
        b=gIKx0pE3ayOl+1aP25PpEwEthcB4DRRm00Ge3I8PzBP96wlK1r5WxeLP5UoX7pc7WyvuuD
        7IZSBbuMKfR3XVt6NnzvItQhuwVoBqKHlolzOz+i1LRZMB8e4WjcnJokrh6UHgsuLIuxdA
        AqNYGPeMxs58SHZ15xkmp9UKLTLLSbk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-fQ2y1-PbM0qqirFVn_iJqA-1; Fri, 06 Mar 2020 05:00:16 -0500
X-MC-Unique: fQ2y1-PbM0qqirFVn_iJqA-1
Received: by mail-wm1-f72.google.com with SMTP id f207so680332wme.6
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2020 02:00:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AVZKZRodnT8m61EYZkSnJRTdxqQpltbB/y6KfgTIT1g=;
        b=FmaGQIKptNUFlQNZunbwHgciShU1IL4Rwl6lCX9nyKzI+txq45DpnNPSL6JQwh8KM6
         2C3EVL/jh68cGHjn2NMyc7FNUT2gHK7pbGxaVKvACNTasZuIOrNB/9coDRIqdvl4AMdk
         91Dfo+ht9Z+ur2jcba6HDrKIBp0G1eHs3eR8u7Yas5ERaETQxhAHH1qBAzEUThdjb8uy
         bJsxVkidYU0csHLZKVvC4nLOfL+H3tzUaonNIIphd9jS0XcXDmtjHKQSYltNNoh0Z4U1
         V9VoODSFGnVkYwwzKtsP0jn+FKkDQ4pKK0CPydg7g08LJH3pWWuTq62SPrtB0aAccf09
         ZOaA==
X-Gm-Message-State: ANhLgQ1sO6VdzY2n+trtepW/MNfUmqZVJEZTe9uy+cO0YYyv3CVRYhxh
        44Uzil2GxSfj6UPb6GBwaUTjm7YEjPjSMNoDhOZ2LfkPuRVl+XHSXhBtie044aWqyDxQBVxknZN
        DrnQF/ZMwLlW6
X-Received: by 2002:adf:ee03:: with SMTP id y3mr3344816wrn.5.1583488814290;
        Fri, 06 Mar 2020 02:00:14 -0800 (PST)
X-Google-Smtp-Source: ADFU+vsV7StFA621WH1U3poGeCCFj5kAbCl4GYqaDAZLKVQ5l065AMt9smou8/Ov0naR1gFtRC+gAw==
X-Received: by 2002:adf:ee03:: with SMTP id y3mr3344781wrn.5.1583488814004;
        Fri, 06 Mar 2020 02:00:14 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b99a:4374:773d:f32e? ([2001:b07:6468:f312:b99a:4374:773d:f32e])
        by smtp.gmail.com with ESMTPSA id i67sm25991960wri.50.2020.03.06.02.00.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2020 02:00:13 -0800 (PST)
Subject: Re: [PATCH] KVM: VMX: Use wrapper macro
 ~RMODE_GUEST_OWNED_EFLAGS_BITS directly
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        linmiaohe <linmiaohe@huawei.com>
Cc:     "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
References: <f1b01b4903564f2c8c267a3996e1ac29@huawei.com>
 <1e3f7ff0-0159-98e8-ba21-8806c3a14820@redhat.com>
 <87sgiles16.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2cde5e91-b357-81f9-9e39-fd5d99bb81fd@redhat.com>
Date:   Fri, 6 Mar 2020 11:00:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <87sgiles16.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/03/20 10:44, Vitaly Kuznetsov wrote:
>>> Define a macro RMODE_HOST_OWNED_EFLAGS_BITS for (X86_EFLAGS_IOPL |
>>> X86_EFLAGS_VM) as suggested by Vitaly seems a good way to fix this ?
>>> Thanks.
>> No, what if a host-owned flag was zero?  I'd just leave it as is.
>>
> I'm not saying my suggestion was a good idea but honestly I'm failing to
> wrap my head around this. The suggested 'RMODE_HOST_OWNED_EFLAGS_BITS'
> would just be a define for (X86_EFLAGS_IOPL | X86_EFLAGS_VM) so
> technically the patch would just be nop, no?

It would not be a nop for the reader.

Something called RMODE_{GUEST,HOST}_OWNED_EFLAGS_BITS is a mask.  It
tells you nothing about whether those bugs are 0 or 1.  It's just by
chance that all three host-owned EFLAGS bits are 1 while in real mode.
It wouldn't be the case if, for example, we ran the guest using vm86
mode extensions (i.e. setting CR4.VME=1).  Then VIF would be host-owned,
but it wouldn't necessarily be 1.

Paolo

