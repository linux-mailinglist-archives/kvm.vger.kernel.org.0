Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8872CDB124
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2019 17:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390576AbfJQPbz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Oct 2019 11:31:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60182 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388925AbfJQPby (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Oct 2019 11:31:54 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7FFE12EF169
        for <kvm@vger.kernel.org>; Thu, 17 Oct 2019 15:31:54 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id e14so1123328wrm.21
        for <kvm@vger.kernel.org>; Thu, 17 Oct 2019 08:31:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2F49FEDc7LzFngXJgzRZqW78fRDnmjAzCNR79FZigrE=;
        b=XmD23X36RSdYHcDh7qrU2HDClEPzZ+ovG82hJVyH5U42jaHV1E224f+pzMtW+j1zCC
         vqsMmJx0RB1ZHugITo+BFqAfrfTf8cfI0cbJ+ZLs6bIJH5HIO9ijmxQ6Igjm2pXzh+TC
         7AbQ4pSyUpvNNrYgMyzhnwxmXkRUfOK/KFCNyE4ZYEVU1jlI2kCw4qTMRhWOMnLxQbQO
         1QhAp9CCo9FGh53pIHqhIvLtm78CWKhibwY4hhUf2voT/Kmm5Bt5qU2MTtPJ1eN8ktu0
         9xe/ZssWaxbJ5fW8fAMzgiQIcyvy02k0JKetaBRXNuuiwEugG7psFOJ5rmvwAiyj84AJ
         EGHg==
X-Gm-Message-State: APjAAAXQKSCp/9NzXUoGt4lTqzID7qXiJgAQMcd6POseloh5e4WajulP
        1OmNjDdaFayngvzDaKPG38Xkvz6PnJHbV8DvkIZl/2Amrd1C+/xRQTW6QjUq4m9WJihGPK/n9tk
        LfxhucaAdZ9Kt
X-Received: by 2002:a5d:4644:: with SMTP id j4mr2879853wrs.355.1571326312471;
        Thu, 17 Oct 2019 08:31:52 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwoIjP3X5/5M57pPiqoVb4QqAFAlZi3TJe2flVh04t5Rg9ZUsN3ciAgDSe7HR76Hc+W9yzeqA==
X-Received: by 2002:a5d:4644:: with SMTP id j4mr2879827wrs.355.1571326312297;
        Thu, 17 Oct 2019 08:31:52 -0700 (PDT)
Received: from [192.168.50.32] (243.red-88-26-246.staticip.rima-tde.net. [88.26.246.243])
        by smtp.gmail.com with ESMTPSA id g1sm2872055wrv.68.2019.10.17.08.31.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Oct 2019 08:31:51 -0700 (PDT)
Subject: Re: [PATCH 02/32] hw/i386/pc: Move kvm_i8259_init() declaration to
 sysemu/kvm.h
To:     Thomas Huth <thuth@redhat.com>, qemu-devel@nongnu.org
Cc:     Aleksandar Markovic <amarkovic@wavecomp.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Paul Durrant <paul@xen.org>,
        =?UTF-8?Q?Herv=c3=a9_Poussineau?= <hpoussin@reactos.org>,
        Aleksandar Rikalo <aleksandar.rikalo@rt-rk.com>,
        xen-devel@lists.xenproject.org,
        Laurent Vivier <lvivier@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>, kvm@vger.kernel.org
References: <20191015162705.28087-1-philmd@redhat.com>
 <20191015162705.28087-3-philmd@redhat.com>
 <1e8c724b-8846-255a-eace-6bf135471566@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <1e1bffc6-a7cc-5beb-3f9f-da8e644c8d4b@redhat.com>
Date:   Thu, 17 Oct 2019 17:31:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1e8c724b-8846-255a-eace-6bf135471566@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/17/19 5:04 PM, Thomas Huth wrote:
> On 15/10/2019 18.26, Philippe Mathieu-Daudé wrote:
>> Move the KVM-related call to "sysemu/kvm.h".
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>> ---
>>   include/hw/i386/pc.h | 1 -
>>   include/sysemu/kvm.h | 1 +
>>   2 files changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
>> index 6df4f4b6fb..09e74e7764 100644
>> --- a/include/hw/i386/pc.h
>> +++ b/include/hw/i386/pc.h
>> @@ -158,7 +158,6 @@ typedef struct PCMachineClass {
>>   
>>   extern DeviceState *isa_pic;
>>   qemu_irq *i8259_init(ISABus *bus, qemu_irq parent_irq);
>> -qemu_irq *kvm_i8259_init(ISABus *bus);
>>   int pic_read_irq(DeviceState *d);
>>   int pic_get_output(DeviceState *d);
>>   
>> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
>> index 9d143282bc..da8aa9f5a8 100644
>> --- a/include/sysemu/kvm.h
>> +++ b/include/sysemu/kvm.h
>> @@ -513,6 +513,7 @@ void kvm_irqchip_set_qemuirq_gsi(KVMState *s, qemu_irq irq, int gsi);
>>   void kvm_pc_gsi_handler(void *opaque, int n, int level);
>>   void kvm_pc_setup_irq_routing(bool pci_enabled);
>>   void kvm_init_irq_routing(KVMState *s);
>> +qemu_irq *kvm_i8259_init(ISABus *bus);
> 
> Why? The function is defined in hw/i386/kvm/ - so moving its prototype
> to a generic header sounds wrong to me.

This function is declared when compiling without KVM, and is available 
on the Alpha/HPPA/MIPS which don't have it.

You'd rather move the kvm_pc_* declarations to hw/i386/kvm/?
