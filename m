Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2520120437B
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 00:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730840AbgFVWUl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 18:20:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26130 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730933AbgFVWUh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 18:20:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592864435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+r7BKrKGWvMG5qhiOpLap0PhRC2znMPWIsJQP36DWQY=;
        b=VK6ChV+wDwg+q1eJh+i/rDxWGL8AtD52pYuj74JfT5V1eAqWygre6lS1JV2DxFpOZCC7IO
        gqHB5Zna7uD1hbTPZElrLdI/MS4ZPPrRfJfhOUeCQniXlreV0GiKjCDi01K0iBnLO4EppK
        ukcASzcmfv/mo7cj8bF7TmdhZljsmW0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-_mPhyJJRN920vYvHUCWgzg-1; Mon, 22 Jun 2020 18:20:31 -0400
X-MC-Unique: _mPhyJJRN920vYvHUCWgzg-1
Received: by mail-wr1-f69.google.com with SMTP id b14so11763852wrp.0
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 15:20:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+r7BKrKGWvMG5qhiOpLap0PhRC2znMPWIsJQP36DWQY=;
        b=Lrs6nZSTPhFppBOcUENSoUcPOwG6iYHMPihwm0O2Q64zGdk0cDVfg++hzltkGXSweq
         jjM4oLlcnYMZiLeqUx8k0dgoZg7PiRWt0uyXk0zzy04ml1JHX+Wn1pIFA15w4w+bjk3g
         4lnlKeyy46mi4Doub9vuwp0Fseat/2RSWcgGsI+SR/YRjotUu3NzDoHWW1q+M7+b0dWy
         MSpGB242vbG3l/bsCY270+i9TnAPavos+U/SHJFSLFojrWXwnKAOGBv0Mm9j+xcApFF1
         hUoM+/8a1+w01B99vRCmwmkPn3+d38rYw7yD/mY5oRKCHq6mM8cLnhqH2CQLEFItxtkb
         sYhg==
X-Gm-Message-State: AOAM531UC2bZTwGhD/etso8OdiuYeqMOTi8Ut3KKR04VGyNEwGZG/fL6
        E+kui5OJnuyw+TlwlRzsOBaPDV+467SXP3Dj5FeaEQxfZ1zOqSTIDRgUcE249/+TzRWBpQ7nZnO
        0sZmjCO3XuiFE
X-Received: by 2002:a5d:50c9:: with SMTP id f9mr22339318wrt.9.1592864430214;
        Mon, 22 Jun 2020 15:20:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz45s3tZQ+/TSVf6JTtKxvVlACFv07bLL+dxB020RBft9zTO3YnObOaP7u62VAjD6X6NaUs3w==
X-Received: by 2002:a5d:50c9:: with SMTP id f9mr22339302wrt.9.1592864429972;
        Mon, 22 Jun 2020 15:20:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:fd64:dd90:5ad5:d2e1? ([2001:b07:6468:f312:fd64:dd90:5ad5:d2e1])
        by smtp.gmail.com with ESMTPSA id d201sm1024184wmd.34.2020.06.22.15.20.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 15:20:29 -0700 (PDT)
Subject: Re: [PATCH v2 00/11] KVM: Support guest MAXPHYADDR < host MAXPHYADDR
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Mohammed Gamal <mgamal@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, babu.moger@amd.com
References: <20200619153925.79106-1-mgamal@redhat.com>
 <5a52fd65-e1b2-ca87-e923-1d5ac167cfb9@amd.com>
 <52295811-f78a-46c5-ff9e-23709ba95a3d@redhat.com>
 <0d1acded-93a4-c1fa-b8f8-cfca9e082cd1@amd.com>
 <40ac43a1-468f-24d5-fdbf-d012bdae49ed@redhat.com>
 <c89bda4a-2db9-6cb1-8b01-0a6e69694f43@amd.com>
 <4ed45f38-6a31-32ab-cec7-baade67a8c1b@redhat.com>
 <77388079-6e1b-5788-4912-86ad4c28ee70@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b0f3c36d-a6a5-f10d-443a-3270047d7bec@redhat.com>
Date:   Tue, 23 Jun 2020 00:20:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <77388079-6e1b-5788-4912-86ad4c28ee70@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/20 21:14, Tom Lendacky wrote:
>>> I guess I'm trying to understand why RSVD has to be reported to the guest
>>> on a #PF (vs an NPF) when there's no guarantee that it can receive that
>>> error code today even when guest MAXPHYADDR == host MAXPHYADDR. That would
>>> eliminate the need to trap #PF.
>>
>> That's an interesting observation!  But do processors exist where either:
>>
>> 1) RSVD doesn't win over all other bits, assuming no race conditions
> 
> There may not be any today, but, present bit aside (which is always
> checked), there is no architectural statement that says every error
> condition has to be checked and reported in a #PF error code. So software
> can't rely on RSVD being present when there are other errors present.
> That's why I'm saying I don't think trapping #PF just to check and report
> RSVD should be done.

Fair enough---if I could get rid of the #PF case I would only be happy.
 But I'm worried about guests being upset if they see non-RSVD page
faults for a page table entry that has one or more reserved bits set.

>> 2) A/D bits can be clobbered in a page table entry that has reserved
>> bits set?
> 
> There is nothing we can do about this one. The APM documents this when
> using nested page tables.

Understood.

> If the guest is using the same MAXPHYADDR as the
> host, then I'm pretty sure this doesn't happen, correct? So it's only when
> the guest is using something less than the host MAXPHYADDR that this occurs.
> I'm not arguing against injecting a #PF with the RSVD on an NPF where it's
> detected that bits are set above the guest MAXPHYADDR, just the #PF trapping.

Got it.  My question is: is there an architectural guarantee that the
dirty bit is not set if the instruction raises a page fault?  (And what
about the accessed bit?).

If so, the NPF behavior makes it impossible to emulate lower MAXPHYADDR
values from the NPF vmexit handler.  It would be incorrect to inject a
#PF with the RSVD error code from the NPF handler, because the guest
would not expect the dirty bits to be set in the page table entry.

Even if there's no such guarantee, I would be reluctant to break it
because software could well be expecting it.

Paolo

> Thanks,
> Tom
> 
>>
>> Running the x86/access.flat testcase from kvm-unit-tests on bare metal
>> suggests that all existing processors do neither of the above.
>>
>> In particular, the second would be a showstopper on AMD.
>>
>> Paolo
>>
> 

