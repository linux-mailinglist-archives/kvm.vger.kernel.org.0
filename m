Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250F51BDD5F
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 15:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgD2NUJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 09:20:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39172 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726776AbgD2NUI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Apr 2020 09:20:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588166407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n1dpe2R+BaXjYKU81tW2AJJKUbU2yVflRAds1OeIUQA=;
        b=QwobHKi2HvETYpH8Er0vgqNDGXauJ25NdUiT0fNcpM9Wahn8hB28VamL57CU9rtjG+aWcg
        ANvE4mCEMH9MkqqqcQB/qwxD9vg3cZuJ49QUBorf2p56HZf5buVG0aBsIU94kbwwxp7uEp
        a2P4vxoiZJfaQcjq1Y6Ulr4RcpzAXcA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-9Xu4WHEZOvWDy8yo_abDSw-1; Wed, 29 Apr 2020 09:20:03 -0400
X-MC-Unique: 9Xu4WHEZOvWDy8yo_abDSw-1
Received: by mail-wm1-f69.google.com with SMTP id t62so1204136wma.0
        for <kvm@vger.kernel.org>; Wed, 29 Apr 2020 06:20:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n1dpe2R+BaXjYKU81tW2AJJKUbU2yVflRAds1OeIUQA=;
        b=Etel25L8RaFI5sS/ZKeqJ3hqDZmbZZZWTG+EWXu4LNiy6pgjNDrq+zFS+R/jzMPlRH
         Sf/tV1Gla2yAdMgXhbPhc+oKLuyMWQyJ/UjPGJSVR2cZ8p2s2Op1f2Bdq8ZNawTxXxFX
         CJyH+tjS944h+A8dPXJ/v6NXW1/xT/ScnupUa86XWNfomCr0Oj8hO2cLvY/LjID8Wa+e
         YV3djZvn4tw9OtRA3fBLDyaMUuxmg7002sk8UPPysxs8QGHa7+wSWcfwUkOTFWpnPf9U
         wgVygxwAiGxNjinFuXNg9zhTBAjtRE4BAa3T9i0yHpQgHCp06AXNA/vmR4Ciei8qFns5
         rZsA==
X-Gm-Message-State: AGi0PuakHCHBD0pTJnXERRV+3tlaQAvPyRybdUymWQNbcU+cnbxdDnyX
        vrRo8kUNh8KolO4sYap3NijFbwwwbzEqHQ9yUjnrQUeO/wLh/Wc8L8kB4EKNprLsIiYymROrSvF
        Jk/Vm4ZUFLdck
X-Received: by 2002:a5d:650b:: with SMTP id x11mr38608016wru.405.1588166402530;
        Wed, 29 Apr 2020 06:20:02 -0700 (PDT)
X-Google-Smtp-Source: APiQypLLm8qn1Tw91phFnLxp2Md4CBWIVFhkVC0MYgra0vAWcDzU06OmfmNuwnFvZRprLFRjLESqcA==
X-Received: by 2002:a5d:650b:: with SMTP id x11mr38607988wru.405.1588166402233;
        Wed, 29 Apr 2020 06:20:02 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id s14sm8221183wme.33.2020.04.29.06.20.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2020 06:20:01 -0700 (PDT)
Subject: Re: [PATCH v1 00/15] Add support for Nitro Enclaves
To:     Alexander Graf <graf@amazon.com>,
        "Paraschiv, Andra-Irina" <andraprs@amazon.com>,
        linux-kernel@vger.kernel.org
Cc:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>, Balbir Singh <sblbir@amazon.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, kvm@vger.kernel.org,
        ne-devel-upstream@amazon.com
References: <20200421184150.68011-1-andraprs@amazon.com>
 <18406322-dc58-9b59-3f94-88e6b638fe65@redhat.com>
 <ff65b1ed-a980-9ddc-ebae-996869e87308@amazon.com>
 <2a4a15c5-7adb-c574-d558-7540b95e2139@redhat.com>
 <1ee5958d-e13e-5175-faf7-a1074bd9846d@amazon.com>
 <f560aed3-a241-acbd-6d3b-d0c831234235@redhat.com>
 <80489572-72a1-dbe7-5306-60799711dae0@amazon.com>
 <0467ce02-92f3-8456-2727-c4905c98c307@redhat.com>
 <5f8de7da-9d5c-0115-04b5-9f08be0b34b0@amazon.com>
 <095e3e9d-c9e5-61d0-cdfc-2bb099f02932@redhat.com>
 <602565db-d9a6-149a-0e1a-fe9c14a90ce7@amazon.com>
 <fb0bfd95-4732-f3c6-4a59-7227cf50356c@redhat.com>
 <0a4c7a95-af86-270f-6770-0a283cec30df@amazon.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ad01ef35-9ee5-cf94-640c-4c26184946fa@redhat.com>
Date:   Wed, 29 Apr 2020 15:20:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <0a4c7a95-af86-270f-6770-0a283cec30df@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/04/20 17:07, Alexander Graf wrote:
>> So why not just start running the enclave at 0xfffffff0 in real mode?
>> Yes everybody hates it, but that's what OSes are written against.  In
>> the simplest example, the parent enclave can load bzImage and initrd at
>> 0x10000 and place firmware tables (MPTable and DMI) somewhere at
>> 0xf0000; the firmware would just be a few movs to segment registers
>> followed by a long jmp.
> 
> There is a bit of initial attestation flow in the enclave, so that
> you can be sure that the code that is running is actually what you wanted to
> run.

Can you explain this, since it's not documented?

>   vm = ne_create(vcpus = 4)
>   ne_set_memory(vm, hva, len)
>   ne_load_image(vm, addr, len)
>   ne_start(vm)
> 
> That way we would get the EIF loading into kernel space. "LOAD_IMAGE"
> would only be available in the time window between set_memory and start.
> It basically implements a memcpy(), but it would completely hide the
> hidden semantics of where an EIF has to go, so future device versions
> (or even other enclave implementers) could change the logic.
> 
> I think it also makes sense to just allocate those 4 ioctls from
> scratch. Paolo, would you still want to "donate" KVM ioctl space in that
> case?

Sure, that's not a problem.

Paolo

> Overall, the above should address most of the concerns you raised in
> this mail, right? It still requires copying, but at least we don't have
> to keep the copy in kernel space.

