Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA96337958
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 17:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbhCKQaG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 11:30:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38243 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233750AbhCKQ3o (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Mar 2021 11:29:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615480183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kRJOqyfDaUlicETbZC6GzKoFoUyCtPY6jEDl336fEOc=;
        b=N4RekMtGZi/5kaoVjRnSTwfbg7Nh/VtOhc2YgTPynfq9bTuE3HV+867+lt0s1B4XSzjyE8
        qfccxQv9gGVK9FoWaxhffgdn/2zlzcZ97uepyOtbMz1AOP9vkbMqR/aowrLicjF8OChLhj
        XmW/fDoYNIrUHVsr2dfPmiueeyE1sbI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-YvAH38lmPWap9BfvH1Ar1w-1; Thu, 11 Mar 2021 11:29:39 -0500
X-MC-Unique: YvAH38lmPWap9BfvH1Ar1w-1
Received: by mail-wm1-f69.google.com with SMTP id c9so1675163wme.5
        for <kvm@vger.kernel.org>; Thu, 11 Mar 2021 08:29:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kRJOqyfDaUlicETbZC6GzKoFoUyCtPY6jEDl336fEOc=;
        b=aHVTYni5q7LexJmxQUsgKyE/YwCco94S4W6OKQKSY+i2trw5/mRiN0G8ZQllBt9sjO
         uZ4PBikibCOnflWhjcx6CpTKpvlUAtEL+xOS19UWo7VFQwI5AkNOnCQJEcV1615M5H0y
         alipEeaI4fXeWCguk8un+OG8P7qQO/c/IOc9iot31DbK3e2TMZKLfU2JYit3tnFV7qT8
         3MVMi6oQe4HdqoZ1zKFDZheVBKqHJMOKr87cpwA0RJzMeKp4Vx6XJukysjtc8ldP/N/t
         9Pzcm1sy5KJlrKQicqK5bVTeXf86AbgXj6XwZ95NxDMtItJuXBPU7aAQ3ylOcVoX64xy
         NcJg==
X-Gm-Message-State: AOAM530Nts/A2kj0UJdD/rvHbw7mG/ySQkKu22lrxpuhHnti76akfC4i
        R2qVvqvOke7mGPThYf/1jsCobsQPlql5+IgugZEu2W+xe85tcpxhfezMXWKarom+FM+0jVjdQ1E
        2Q/N5SiCsoQUR
X-Received: by 2002:a1c:22c2:: with SMTP id i185mr9007781wmi.99.1615480178188;
        Thu, 11 Mar 2021 08:29:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyEFHHV6ROfRyeJhcfcGGw38UajN0mcbhcLEwuXT8dr51uqlFAl5VOj4+hNEHVIYMJCOM7V5w==
X-Received: by 2002:a1c:22c2:: with SMTP id i185mr9007767wmi.99.1615480178025;
        Thu, 11 Mar 2021 08:29:38 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x13sm4522105wrt.75.2021.03.11.08.29.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 08:29:37 -0800 (PST)
To:     Tobin Feldman-Fitzthum <tobin@linux.ibm.com>, natet@google.com
Cc:     Dov Murik <dovmurik@linux.vnet.ibm.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com, rientjes@google.com,
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Laszlo Ersek <lersek@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Hubertus Franke <frankeh@us.ibm.com>
References: <20210224085915.28751-1-natet@google.com>
 <7829472d-741c-1057-c61f-321fcfb5bdcd@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC] KVM: x86: Support KVM VMs sharing SEV context
Message-ID: <35dde628-f1a8-c3bf-9c7d-7789166b0ee1@redhat.com>
Date:   Thu, 11 Mar 2021 17:29:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <7829472d-741c-1057-c61f-321fcfb5bdcd@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/03/21 16:30, Tobin Feldman-Fitzthum wrote:
> I am not sure how the mirror VM will be supported in QEMU. Usually there 
> is one QEMU process per-vm. Now we would need to run a second VM and 
> communicate with it during migration. Is there a way to do this without 
> adding significant complexity?

I can answer this part.  I think this will actually be simpler than with 
auxiliary vCPUs.  There will be a separate pair of VM+vCPU file 
descriptors within the same QEMU process, and some code to set up the 
memory map using KVM_SET_USER_MEMORY_REGION.

However, the code to run this VM will be very small as the VM does not 
have to do MMIO, interrupts, live migration (of itself), etc.  It just 
starts up and communicates with QEMU using a mailbox at a predetermined 
address.

I also think (but I'm not 100% sure) that the auxiliary VM does not have 
to watch changes in the primary VM's memory map (e.g. mapping and 
unmapping of BARs).  In QEMU terms, the auxiliary VM's memory map tracks 
RAMBlocks, not MemoryRegions, which makes things much simpler.

There are already many examples of mini VMMs running special purpose VMs 
in the kernel's tools/testing/selftests/kvm directory, and I don't think 
the QEMU code would be any more complex than that.

Paolo

