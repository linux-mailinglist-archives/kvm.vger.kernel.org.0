Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BEA02E86D0
	for <lists+kvm@lfdr.de>; Sat,  2 Jan 2021 09:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbhABIre (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Jan 2021 03:47:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43570 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726360AbhABIrd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 2 Jan 2021 03:47:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609577167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RBdgbdCn6LE+LXjRTDdKPPxtQN2DsX10fwrbe+HXEAI=;
        b=EPwEIbJPqGTxxPzvBNZQXkGYYX6MKpOIacqahS5t30g9xqm+Tz1qEYgdQ/pQSfTdNHcSef
        Y73pQM3OmJFdV5srdzB4g7fJvdNxdrFOR5rCLWppXFtP+Fmmls0WUt1J0mxJh5dKiXmjuY
        GGc6/sb+ym6F20MQc0vYuAQy3VljrFc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-5tASiH8jNkmjxfKISls4uQ-1; Sat, 02 Jan 2021 03:46:05 -0500
X-MC-Unique: 5tASiH8jNkmjxfKISls4uQ-1
Received: by mail-ed1-f70.google.com with SMTP id a9so9327699edy.8
        for <kvm@vger.kernel.org>; Sat, 02 Jan 2021 00:46:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RBdgbdCn6LE+LXjRTDdKPPxtQN2DsX10fwrbe+HXEAI=;
        b=XzC9LgYMsSF+D+A/xCX3PaYlvbyDl+VzfwixflFzybelIsLqTZwpMSUU2YhSJxr2QG
         LkzL8A1+K5BBlblDj1qBsaGquODR1ZVRNwuS8CfHdLHRLxr+O9LdAHfJf1WsjSof15Zu
         WE0Loq+SJtQvoCzisG1nMzizZOsfQ713Y25VwBhbEOKKiqfh3+B1doL69UpX+dRYQVGw
         /Hs5M38I3Zf0jWB8dZEEtEOwB/Tjc1we1KDU/f0ExOSgKak1F9+ZaAq1VcA5a6N2KZmo
         vmMcbq4PCVne9s9n7A7xlxl0ZkAlKnsEU29T0SC7djPiCkYMATwBONV1mO8mzmItDpTF
         4x9w==
X-Gm-Message-State: AOAM532vO4AokBwuGTjwPhHavOnPLsBMOTixX0QcRjenm/W87jYy/cFQ
        /NmHltx4rUg6ibHdL+vZRNLoKKX1XUMcUBh6ezAfDKETnUtViqHAlKi9BnRm5Zqmx2MeLWxrDuz
        axnc75r1dHVmB
X-Received: by 2002:a17:906:c45a:: with SMTP id ck26mr60234215ejb.200.1609577163959;
        Sat, 02 Jan 2021 00:46:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxn6AkP+NOFTzMBZ1wA4MeM+ufY1ZqHx80glMDKSrpb0ozoGj9/5XrQZ4MGiODwP+XffvP9bw==
X-Received: by 2002:a17:906:c45a:: with SMTP id ck26mr60234208ejb.200.1609577163757;
        Sat, 02 Jan 2021 00:46:03 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id r24sm41321774edc.21.2021.01.02.00.46.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Jan 2021 00:46:03 -0800 (PST)
Subject: Re: [RFC PATCH kvm-unit-tests 0/4] add generic stress test
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, mlevitsk@redhat.com
References: <20201223010850.111882-1-pbonzini@redhat.com>
 <X+pbZ061gTIbM2Ef@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d9a81441-9f15-45c2-69c5-6295f2891874@redhat.com>
Date:   Sat, 2 Jan 2021 09:46:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <X+pbZ061gTIbM2Ef@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/12/20 23:25, Sean Christopherson wrote:
> On Wed, Dec 23, 2020, Paolo Bonzini wrote:
>> This short series adds a generic stress test to KVM unit tests that runs a
>> series of
> 
> Unintentional cliffhanger?

... event injections, timer cycles, memory updates and TLB invalidations.

>> The configuration of the test is set individually for each VCPU on
>> the command line, for example:
>>
>>     ./x86/run x86/chaos.flat -smp 2 \
>>        -append 'invtlb=1,mem=12,hz=100  hz=250,edu=1,edu_hz=53,hlt' -device edu
>>
>> runs a continuous INVLPG+write test on 1<<12 pages on CPU 0, interrupted
>> by a 100 Hz timer tick; and keeps CPU 1 mostly idle except for 250 timer
>> ticks and 53 edu device interrupts per second.
> 
> Maybe take the target cpu as part of the command line instead of implicitly
> defining it via group position?

Sure, the command line syntax can be adjusted.

   The "duplicate" hz=??? is confusing.  E.g.
> 
>      ./x86/run x86/chaos.flat -smp 2 \
>        -append 'cpu=0,invtlb=1,mem=12,hz=100 cpu=1,hz=250,edu=1,edu_hz=53,hlt' -device edu
> 
>> For now, the test runs for an infinite time so it's not included in
>> unittests.cfg.  Do you think this is worth including in kvm-unit-tests,
> 
> What's the motivation for this type of test?  What class of bugs can it find
> that won't be found by existing kvm-unit-tests or simple boot tests?

Mostly live migration tests.  For example, Maxim found a corner case in 
KVM_GET_VCPU_EVENTS that affects both nVMX and nSVM live migration 
(patches coming), and it is quite hard to turn it into a selftest 
because it requires the ioctl to be invoked exactly when 
nested_run_pending==1.  Such a test would allow stress-testing live 
migration without having to set up L1 and L2 virtual machine images.

Paolo

