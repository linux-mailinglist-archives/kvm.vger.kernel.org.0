Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90AEE11730A
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2019 18:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbfLIRpN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Dec 2019 12:45:13 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:25198 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726265AbfLIRpN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Dec 2019 12:45:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575913511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V/U9tfjsxi87gSH4XTYLFr1ktsW4Z3JMWvq0j6RFIks=;
        b=Jq+2m1vKJdgZFBJ+t/uGGm/TwCQSaoQAK4UyHj6S08/8/bdVRH/CotPjfKSFlj3K4D71zq
        ah7m/TFhuGtk2n77DMUtokcRZsQmjayyUIufNdwfecKLsiJGlgJV4E6xX/ahDOZIcj0vVX
        r/Sou0KgCNIhL/iyJB4XVbYAQ4MJz4U=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-Qv7MIV8_MRyx-_EQ9BPqZg-1; Mon, 09 Dec 2019 12:45:08 -0500
Received: by mail-wr1-f70.google.com with SMTP id z10so7770477wrt.21
        for <kvm@vger.kernel.org>; Mon, 09 Dec 2019 09:45:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=V/U9tfjsxi87gSH4XTYLFr1ktsW4Z3JMWvq0j6RFIks=;
        b=oQ/IGPfX72ly8UoiRL+hGhL+mzMdnFPFO2dzYMNA8/XoAJAqgqqgn8zo9bp976Vnsw
         4iaBkmsMIwbgbKAOlQ580Aoc/4GGZuGnE2acIgOLE73x5TIyIw4nHJ63e2FbQGDQtCtL
         BqpESvBAAlQz2uAu+JPPNh/fP1qHrenKHHX29C9dxYUaQV6WDV0vzw0LnQL14A+niOV4
         zH4G8twaDaZLpf24xIJ6KygObL5kXU7x7JaJGxsGZXT55N4Dbu9/AvhNtrfvHmxuPKYc
         ps9kJ7GGGES0U69s7DTuvGc8EUc4afjSJsWX/W898qLunZM8R6aRJZ0xNGDMOvtv2m2W
         GOfg==
X-Gm-Message-State: APjAAAXomkqLWEqPNkh/TRhljDC9tby5FKHbzPW/ocwvriGSRJNHvjeg
        NvbAw1yMFR3iZv6unLi8/pEjgz70hBm93a36zTEQiyPheDdwuW6NRpmJMmFMJsKZVRLNpNN4Nl9
        cA2bQtTt8oSn4
X-Received: by 2002:a05:600c:389:: with SMTP id w9mr211575wmd.5.1575913507071;
        Mon, 09 Dec 2019 09:45:07 -0800 (PST)
X-Google-Smtp-Source: APXvYqznXsxlEBJDGRu4DM5ifJVXe1zDT0MGW/0z8Oq7NnaZokbVoWWe8j9Oaewst2w63kTL5ddmyQ==
X-Received: by 2002:a05:600c:389:: with SMTP id w9mr211554wmd.5.1575913506831;
        Mon, 09 Dec 2019 09:45:06 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9? ([2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9])
        by smtp.gmail.com with ESMTPSA id v3sm220477wru.32.2019.12.09.09.45.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Dec 2019 09:45:06 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH] gitlab-ci.yml: Remove ioapic from the x86
 tests
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>
References: <20191205151610.19299-1-thuth@redhat.com>
 <d592da1d-2a5f-a005-0002-9fde866ed421@redhat.com>
 <7a9b05a0-37e3-91ba-de23-84fd968ca185@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fdbe37df-216f-65bd-cd82-fd46afd278ec@redhat.com>
Date:   Mon, 9 Dec 2019 18:45:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <7a9b05a0-37e3-91ba-de23-84fd968ca185@redhat.com>
Content-Language: en-US
X-MC-Unique: Qv7MIV8_MRyx-_EQ9BPqZg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/12/19 18:33, Thomas Huth wrote:
>> It works for me though:
>>
>> $ /usr/bin/qemu-system-x86_64 -nodefaults -device pc-testdev -device
>> isa-debug-exit,iobase=0xf4,iosize=0x4 -vnc none -serial stdio -device
>> pci-testdev -machine accel=tcg -kernel x86/ioapic.flat
> You have to run the test with "-smp 4" (like in x86/unittests.cfg), then
> it hangs.

The problem was actually that I hadn't recompiled x86/ioapic.flat.  Now
I can see the hang even with "-machine
accel=kvm,kernel_irqchip=off|split", I'll take a look if Nitesh doesn't
beat me.

Paolo

