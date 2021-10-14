Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCBDD42D2F0
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 08:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbhJNGwt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 02:52:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:28459 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229502AbhJNGwt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Oct 2021 02:52:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634194244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AQ3c2nRaHzol1pqD1n/jXxR8f1O3T1lWBUtq6eTvBtQ=;
        b=O0e9Nqu2oxOQvHQJd3StaGD8zGg0RIkuibI1sqcU+wPsEmWzZ+V8R2NKwPJZGnb7UEkuh9
        lV59FaG3wnfAQb61qvg8et1UGsOvEHbvZcEH0+Vrcd/5Vm/I3/5U9UEXZeOAjFxTHLnnUx
        KuKGm/XJTbbkNJcvNJE13YDbKSkAefw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-57-etSd0uINMuWLV0FXg-n6hQ-1; Thu, 14 Oct 2021 02:50:43 -0400
X-MC-Unique: etSd0uINMuWLV0FXg-n6hQ-1
Received: by mail-wr1-f71.google.com with SMTP id r16-20020adfbb10000000b00160958ed8acso3751028wrg.16
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 23:50:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AQ3c2nRaHzol1pqD1n/jXxR8f1O3T1lWBUtq6eTvBtQ=;
        b=sh2f1YE6mUKnbZfbp8G64hYQriAfKFLOBFJMNimb7nu3v6EAZsApmNrkQvfoIqd0cW
         Rdw7GU1v3X33LxMQ3VXbvhUe07yFcTi5XhBrBRbXj0oxdh4ekFfImhI+9YCiaCY8nhaH
         JkJW8bIpYjd7wcqCoNSB6+D2YiP6Hk0ki3RHkQVTBS4kDWN8VLK9x55b/UlhQ+oXRxhW
         zWsCWifA3xPDPWQHEBmyhhOz0VIaK/kJpxEuHeIwE4VFUflgYUK5YAIqAqH/LP6gB1RP
         vBDSdsguu3ujwhsweEa0Ex3gMgEiR3+IURJjiuabxcjXDqTYJQ93zu2EM8562BK5tzgh
         I8Xw==
X-Gm-Message-State: AOAM532xHOjpEifAtvLdGu5m5rSi89CaoOyZND9INEMZ1RifL2YRDJZ+
        M7Xb0vRZxLBlRhHeI/s+pr6n/bLXedM4CBnMgaHCl7+qJkbgOq9WKxhXrpc9lfkchvUOkih0rJX
        gAfLnZqQL81Vm
X-Received: by 2002:a1c:ed03:: with SMTP id l3mr3927823wmh.86.1634194241847;
        Wed, 13 Oct 2021 23:50:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyX0mzzxZHETZ2P3FudpW7b4TG21nRN851KzYr/eDS3Qk/lSy8yyDArVf+qhucx2Tf49XkxKg==
X-Received: by 2002:a1c:ed03:: with SMTP id l3mr3927797wmh.86.1634194241503;
        Wed, 13 Oct 2021 23:50:41 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id t21sm1298234wmi.19.2021.10.13.23.50.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 23:50:40 -0700 (PDT)
Message-ID: <ec9c761d-4b5c-71e2-c1fc-d256b6b78c04@redhat.com>
Date:   Thu, 14 Oct 2021 08:50:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>
References: <871r4p9fyh.ffs@tglx>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <871r4p9fyh.ffs@tglx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/10/21 16:06, Thomas Gleixner wrote:
>> - the guest value stored in vcpu->arch.
>>
>> - the "QEMU" value attached to host_fpu.  This one only becomes zero if
>> QEMU requires AMX (which shouldn't happen).
> 
> I don't think that makes sense.
> 
> First of all, if QEMU wants to expose AMX to guests, then it has to ask
> for permission to do so as any other user space process. We're not going
> to make that special just because.

Hmm, I would have preferred if there was no need to enable AMX for the 
QEMU FPU.  But you're saying that guest_fpu needs to swap out to 
current->thread.fpu if the guest is preempted, which would require 
XFD=0; and affect QEMU operation as well.

In principle I don't like it very much; it would be nicer to say "you 
enable it for QEMU itself via arch_prctl(ARCH_SET_STATE_ENABLE), and for 
the guests via ioctl(KVM_SET_CPUID2)".  But I can see why you want to 
keep things simple, so it's not a strong objection at all.

> Anything else will just create more problems than it solves. Especially
> #NM handling (think nested guest) and the XFD_ERR additive behaviour
> will be a nasty playground and easy to get wrong.
> 
> Not having that at all makes life way simpler, right?

It is simpler indeed, and it makes sense to start simple.  I am not sure 
if it will hold, but I agree it's better for the first implementation.

Paolo

