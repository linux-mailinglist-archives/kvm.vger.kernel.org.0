Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8E91B6613
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 23:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbgDWVSX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 17:18:23 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58135 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725877AbgDWVSX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Apr 2020 17:18:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587676702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9nGzQ0bB//L/EVOCbLS7Mlym6VvCqRSKRv5MSeYNnwA=;
        b=YhqMz0L81oDR6OJZVRRWExOF0NO5rSAw2HGYsJcAf5FBBqFpHk5byXzwVwSS9QLJve6RLe
        ScsljcXRy8+Y1g0U8mrCp2LLt3XPJHPr7GH2jmmkQgDdlcMq6S9LS6/Io/tt/Fe8Q2/o+D
        cqghPQ9yS5mpRIQWr/GCNHLj9fZzqio=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-vGxqEhq6Nb28eiJzyCfbdw-1; Thu, 23 Apr 2020 17:18:19 -0400
X-MC-Unique: vGxqEhq6Nb28eiJzyCfbdw-1
Received: by mail-wr1-f69.google.com with SMTP id v9so3462422wrt.7
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 14:18:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9nGzQ0bB//L/EVOCbLS7Mlym6VvCqRSKRv5MSeYNnwA=;
        b=L84drm+Y7agqQ9UAAoMpMEnasX5dF026+MvMmjREi0daqf97ikKzykecpbTsYgF1q3
         QmDgaqL1uiFztJUXHK+Af+u4tPxWj4W4J58751tIh+E2Y86aX0TPzH+7yk2Tf7Xm+GPu
         yQ0IKaNV9qTqv51V9HJGQ0urvjzN6apwTrRAvqDpusKBlSp8ZuO4Ab3M1HYI8vYGSuuG
         Ya3PxpsjpUW0tNSXozsy2FhemtvO8wRE53ko9qTpCaPYJW0nQ8U670qtfGDV3TtBFxW3
         x1AzBSJQQub2kEKdmlfdwjjIEyxA8PMHrBLig8iuqAP/VYeJ8tLwhhlP7T/a4nfbElUq
         IKiw==
X-Gm-Message-State: AGi0PuYx/0rJvh9QkwSnAG4sRH4R4TkaXbRK0GkiDDkVYVlnpoxRqrvP
        MaGqpG/sDxABMXa3ndIh7Fwfndz6KSdy19dYrxEeYteYGM9mzW4z7L6oYB+zgYM6gNJMHL3ja/J
        192aX9EKxq6Ie
X-Received: by 2002:adf:ce0d:: with SMTP id p13mr7578460wrn.66.1587676697646;
        Thu, 23 Apr 2020 14:18:17 -0700 (PDT)
X-Google-Smtp-Source: APiQypK490SNxHzCaV48m1le0j+sCEacwFqBQWOjRYW3RokrQ9H80Z4m9+h6gU0VfcWk8De2zIoLrQ==
X-Received: by 2002:adf:ce0d:: with SMTP id p13mr7578434wrn.66.1587676697281;
        Thu, 23 Apr 2020 14:18:17 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f43b:97b2:4c89:7446? ([2001:b07:6468:f312:f43b:97b2:4c89:7446])
        by smtp.gmail.com with ESMTPSA id b82sm56046wmh.1.2020.04.23.14.18.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 14:18:16 -0700 (PDT)
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
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0467ce02-92f3-8456-2727-c4905c98c307@redhat.com>
Date:   Thu, 23 Apr 2020 23:18:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <80489572-72a1-dbe7-5306-60799711dae0@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/04/20 22:56, Alexander Graf wrote:
>>
>> CPL3 is how the user application run, but does the enclave's Linux boot
>> process start in real mode at the reset vector (0xfffffff0), in 16-bit
>> protected mode at the Linux bzImage entry point, or at the ELF entry
>> point?
> 
> There is no "entry point" per se. You prepopulate at target bzImage into
> the enclave memory on boot which then follows the standard boot
> protocol. Everything

There's still a "where" missing in that sentence. :)  I assume you put
it at 0x10000 (and so the entry point at 0x10200)?  That should be
documented because that is absolutely not what the KVM API looks like.

> before that (enclave firmware, etc.) is provided by
> the enclave environment.
>
> Think of it like a mechanism to launch a second QEMU instance on the
> host, but all you can actually control are the -smp, -m, -kernel and
> -initrd parameters.

Are there requirements on how to populate the memory to ensure that the
host firmware doesn't crash and burn?  E.g. some free memory right below
4GiB (for the firmware, the LAPIC/IOAPIC or any other special MMIO
devices you have, PCI BARs, and the like)?

> The only I/O channel you have between your VM and
> that new VM is a vsock channel which is configured by the host on your
> behalf.

Is this virtio-mmio or virtio-pci, and what other emulated devices are
there and how do you discover them?  Are there any ISA devices
(RTC/PIC/PIT), and are there SMBIOS/RSDP/MP tables in the F segment?

Thanks,

Paolo

