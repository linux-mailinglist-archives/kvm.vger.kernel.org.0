Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE151BD9AC
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 12:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbgD2KeK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 06:34:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44531 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726516AbgD2KeK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Apr 2020 06:34:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588156448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YoohDxSzOfJakVyi+LR58Vbq+jZaX7TPX/6wkZdclCE=;
        b=K1557RuRIXVB7EgUO3NWUY9P2Ka6xrkwQWcgPiPM/Bg6HmT+Kq5RSYBH6Kaz9+ZXIttnwB
        MAYZBtMjHKyIy9+er9PvZCBqzJOWZJJTJomtPpRuN3VDXWENVUIhDkDs0oyxjFnMJ2z3VF
        86rVWsbe9i/OeA/Ka7tBPijRYaWCIBI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-jxk2EV4HMIWUqq6t4oC7sg-1; Wed, 29 Apr 2020 06:34:06 -0400
X-MC-Unique: jxk2EV4HMIWUqq6t4oC7sg-1
Received: by mail-wm1-f69.google.com with SMTP id o26so823877wmh.1
        for <kvm@vger.kernel.org>; Wed, 29 Apr 2020 03:34:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YoohDxSzOfJakVyi+LR58Vbq+jZaX7TPX/6wkZdclCE=;
        b=daPi03eElw3wXGR/nLhy0WwpHsNeDdCBd9F4Ht10/tfmEuRhkmpcA4UPWELzRERSqq
         ZD5f6V8paxu931NSEepwZfvV1WXulfHkJqvKUcuNA+BlqXYIeZv1fJ83iBa5keEdzZCH
         bgRn+DJwRMMghoCsimuPcUgGFpVoK7hH36Ea8l84mVoY6ipm9xbkZ7H4EOIWiBoNq7zr
         OpAr6GR14TSHdWVWqcVf1FkLvv4uETQtxT3EHTAqN9aX3cpzNSqWw4iSz4ymeLKg3KzS
         Npo9OAJdciY3Pzp45JRM7Bq8kk4duiojLmjReI84rCH8UyAWBoxSInkTuwwrOuIn/Dyu
         YBew==
X-Gm-Message-State: AGi0PuadYFTxDupdyAB6IzwM8cDETRwT3fN0vZjkqLyddj+UHXmXamdI
        11nNPeqY+A6vNQWyNx9w5mygnLDqi3WjBBCpGEfQ/fyIxfEUTDudP7v8aiPqDux+FrGzmf6SpT2
        hmgakwi2vGFN1
X-Received: by 2002:a5d:5652:: with SMTP id j18mr41171055wrw.40.1588156445898;
        Wed, 29 Apr 2020 03:34:05 -0700 (PDT)
X-Google-Smtp-Source: APiQypKUplwF1IbfdLddtQvuA8EuJ4mORmXyTwztal2PAvAeQGMBU6PCU39J1Mm8ix5G/AW3NdIW0w==
X-Received: by 2002:a5d:5652:: with SMTP id j18mr41171040wrw.40.1588156445690;
        Wed, 29 Apr 2020 03:34:05 -0700 (PDT)
Received: from localhost.localdomain ([194.230.155.226])
        by smtp.gmail.com with ESMTPSA id d143sm7011018wmd.16.2020.04.29.03.34.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2020 03:34:05 -0700 (PDT)
Subject: Re: [RFC PATCH 5/5] kvm_main: replace debugfs with statsfs
To:     Randy Dunlap <rdunlap@infradead.org>, kvm@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, mst@redhat.com,
        borntraeger@de.ibm.com, Paolo Bonzini <pbonzini@redhat.com>
References: <20200427141816.16703-1-eesposit@redhat.com>
 <20200427141816.16703-6-eesposit@redhat.com>
 <2bb5bb1d-deb8-d6cd-498b-8948bae6d848@infradead.org>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
Message-ID: <48259504-7644-43cf-45a2-219981e59a49@redhat.com>
Date:   Wed, 29 Apr 2020 12:34:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <2bb5bb1d-deb8-d6cd-498b-8948bae6d848@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/28/20 7:56 PM, Randy Dunlap wrote:
> On 4/27/20 7:18 AM, Emanuele Giuseppe Esposito wrote:
>> Use statsfs API instead of debugfs to create sources and add values.
>>
>> This also requires to change all architecture files to replace the old
>> debugfs_entries with statsfs_vcpu_entries and statsfs_vm_entries.
>>
>> The files/folders name and organization is kept unchanged, and a symlink
>> in sys/kernel/debugfs/kvm is left for backward compatibility.
>>
>> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
>> ---
>>   arch/arm64/kvm/guest.c          |   2 +-
>>   arch/mips/kvm/mips.c            |   2 +-
>>   arch/powerpc/kvm/book3s.c       |   6 +-
>>   arch/powerpc/kvm/booke.c        |   8 +-
>>   arch/s390/kvm/kvm-s390.c        |  16 +-
>>   arch/x86/include/asm/kvm_host.h |   2 +-
>>   arch/x86/kvm/Makefile           |   2 +-
>>   arch/x86/kvm/debugfs.c          |  64 -------
>>   arch/x86/kvm/statsfs.c          |  49 +++++
>>   arch/x86/kvm/x86.c              |   6 +-
>>   include/linux/kvm_host.h        |  39 +---
>>   virt/kvm/arm/arm.c              |   2 +-
>>   virt/kvm/kvm_main.c             | 314 ++++----------------------------
>>   13 files changed, 130 insertions(+), 382 deletions(-)
>>   delete mode 100644 arch/x86/kvm/debugfs.c
>>   create mode 100644 arch/x86/kvm/statsfs.c
> 
> 
> You might want to select STATS_FS here (or depend on it if it is required),
> or you could provide stubs in <linux/statsfs.h> for the cases of STATS_FS
> is not set/enabled.

Currently debugfs is not present in the kvm Kconfig, but implements 
empty stubs as you suggested. I guess it would be a good idea to do the 
same for statsfs.

Paolo, what do you think?

Regarding the other suggestions, you are right, I will apply them in v2.

Thank you,
Emanuele

