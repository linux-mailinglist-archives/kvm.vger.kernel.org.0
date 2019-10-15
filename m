Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79935D71AA
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 10:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbfJOI7I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 04:59:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49414 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726335AbfJOI7H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 04:59:07 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 35DE65945B
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 08:59:07 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id l12so9790661wrm.6
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 01:59:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MOmAFdPDWrDEa5AvaNMUKf7NziX00yqzV1UZ/AfIuGk=;
        b=aa8XCb7BGwBDbV3dbD8Vzor6JUicVKEy/u/GZXpBd9COIaTa5Fk4Cee7woDFPCxTol
         mH89d/wO55BcVTzBvzxJ2O3lp84R2+ZVzY51N9xotAp5jFLSV9AK5X5rz1DrrLptlVKf
         R8kxGz592XYZlXV/j+crYbtQCCvrip9O8RkFHZOBZekL475aTqKj416eCK1OOFCFlhNL
         tZd+1jVdqwmZo3sSiBYrE+WlAZcLC4TTqgliSxGktru7mzfq4gAnBWFE2U9K45G1zHfd
         XtlrOLaGWrIy5ipqA9dcVH+9tBxv2gMmOIfegxrv/6PxxAK14WSPGg8l6e5S7ON4Snlz
         x/nA==
X-Gm-Message-State: APjAAAW8bNEXCQwPhm9x2I44a//Thklm9lML1A8kEVcVTjZdMDN00u2y
        opljdCwWF1MUVUneo+uU2yhu8GlH+LwUGOn2klo8oJxEPIpQPCeAEbthr0B7o3jOGkkkbQyTEWN
        im5E4xRzrjd69
X-Received: by 2002:a05:600c:2201:: with SMTP id z1mr18946728wml.169.1571129945825;
        Tue, 15 Oct 2019 01:59:05 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyRgJTYqmv94g8xe+OJCo1AUwh7aXyZIoNlBixvs7ZRNcsijmTRxDzwTcNbJ60P+WUjyGjxfA==
X-Received: by 2002:a05:600c:2201:: with SMTP id z1mr18946700wml.169.1571129945485;
        Tue, 15 Oct 2019 01:59:05 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d001:591b:c73b:6c41? ([2001:b07:6468:f312:d001:591b:c73b:6c41])
        by smtp.gmail.com with ESMTPSA id r13sm30920817wrn.0.2019.10.15.01.59.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Oct 2019 01:59:05 -0700 (PDT)
Subject: Re: [RFC v2 2/2] x86/kvmclock: Introduce kvm-hostclock clocksource.
To:     Suleiman Souhlal <suleiman@google.com>
Cc:     rkrcmar@redhat.com, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>, sboyd@kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Suleiman Souhlal <ssouhlal@freebsd.org>,
        tfiga@chromium.org, Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20191010073055.183635-1-suleiman@google.com>
 <20191010073055.183635-3-suleiman@google.com>
 <2e6e5b14-fa68-67bd-1436-293659c8d92c@redhat.com>
 <CABCjUKAsO9bOW9-VW1gk0O_U=9V6Zhft8LjpcqXVbDVTvWJ5Hw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <b98fcfc6-2759-7293-b3b5-0282830c9379@redhat.com>
Date:   Tue, 15 Oct 2019 10:59:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CABCjUKAsO9bOW9-VW1gk0O_U=9V6Zhft8LjpcqXVbDVTvWJ5Hw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/10/19 10:39, Suleiman Souhlal wrote:
> I think we have that already (pvtk->flags).
> I'll change the if statement above to use pvtk instead of pv_timekeeper.

Of course, thanks.

>>> +kvm_hostclock_init(void)
>>> +{
>>> +     unsigned long pa;
>>> +
>>> +     pa = __pa(&pv_timekeeper);
>>> +     wrmsrl(MSR_KVM_TIMEKEEPER_EN, pa);
>>
>>
>> As Vitaly said, a new CPUID bit must be defined in
>> Documentation/virt/kvm/cpuid.txt, and used here.  Also please make bit 0
>> an enable bit.
> 
> I think I might not be able to move the enable bit to 0 because we
> need the generation count (pvclock_timekeeper.gen) to be the first
> word of the struct due to the way we copy the data to userspace,
> similarly to how kvm_setup_pvclock_page() does it.

I mean bit 0 of the MSR.

Thanks,

Paolo
