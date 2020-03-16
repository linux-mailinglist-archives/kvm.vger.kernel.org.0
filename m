Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 098891872E8
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 20:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732365AbgCPTAj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 15:00:39 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:59336 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732298AbgCPTAj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Mar 2020 15:00:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584385238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SBoLIS60m/R8vVlNjtCKtaSpPA1mtOn0IkBdkHi07aA=;
        b=O9alQKMzBvMj6lnfuznusdyYz2Rhx81o32cecvrMrvXDb5w2gpVuP6gZg0abT1zQfBMu7x
        zz+jK6yqjJRfMUolaWLZJPimrAEZyMjWxZOfC/4EK3GJ6yFS6bIkEN5Jmmp/fz4wDr6CnW
        v0qchkPauVTm/McaV9opstqkSQXyXOc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-6Dedcq4_PsW5pcR0eApBgA-1; Mon, 16 Mar 2020 15:00:30 -0400
X-MC-Unique: 6Dedcq4_PsW5pcR0eApBgA-1
Received: by mail-ed1-f72.google.com with SMTP id dm17so13914338edb.3
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 12:00:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SBoLIS60m/R8vVlNjtCKtaSpPA1mtOn0IkBdkHi07aA=;
        b=SKfWFRrCWEWJ4bKcPDe61+84zap9Hvha41I8vRzZQrfc2smOUjZpPYS+zxoMwA7NRi
         9SyOeUW9UE8oFAKecFSLu8l11yDryQf/EVydERr4L1mnfz14236aTBODcL31qABJfM8G
         ejampZZLypWXfgwYniry778/C+e0453U1lUdOj5F3Wx5hMX93IJRisOkH1RzruOiZpUL
         KVhpCR7TyAiVOhozNt7gUeseDC/fKHXp6wlx9sw98T9PG3gro1Dp59HisiADVcftA2gj
         0jeG6B8XqZn3GqNAhVtOcQS2D/P91d4eMTEqUyvnKtAR0lhdrho8ddkxBEiEpdsK2ShJ
         7HTg==
X-Gm-Message-State: ANhLgQ0qJIuCm/JurFEI5Z8A0I4mkBPMi7yBcy0wNBAQVO51HSboaZIr
        C40LfSTvOd2KsFgoXefi/Z++YohBgdb2QKgjp+qpcn1mnDCbZXVWwU3VefJVPVs7Y1i7r+qtR78
        beXyuilw2LFlQ
X-Received: by 2002:a05:6402:180a:: with SMTP id g10mr1396195edy.352.1584385228628;
        Mon, 16 Mar 2020 12:00:28 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtBwTHbkTiIU9n1r6Qr6pyZg2hQ9rRIsQKNUEZ9lnKnt6gBUvvjzB3M5uPPCsZJF+W1RYG4Vw==
X-Received: by 2002:a05:6402:180a:: with SMTP id g10mr1396167edy.352.1584385228380;
        Mon, 16 Mar 2020 12:00:28 -0700 (PDT)
Received: from [192.168.1.34] (96.red-83-59-163.dynamicip.rima-tde.net. [83.59.163.96])
        by smtp.gmail.com with ESMTPSA id d9sm50792ejc.79.2020.03.16.12.00.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2020 12:00:27 -0700 (PDT)
Subject: Re: [PATCH v3 18/19] hw/arm: Do not build to 'virt' machine on Xen
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm-devel <kvm@vger.kernel.org>, Thomas Huth <thuth@redhat.com>,
        qemu-arm <qemu-arm@nongnu.org>, Fam Zheng <fam@euphon.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>,
        "open list:X86" <xen-devel@lists.xenproject.org>
References: <20200316160634.3386-1-philmd@redhat.com>
 <20200316160634.3386-19-philmd@redhat.com>
 <CAFEAcA_bXb_RZFxMSYJ8FAoAahAxrq3c0PBzidu+Z0iXTzZqFw@mail.gmail.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <9a627400-c8bd-fcee-8cf8-9896c5b3760f@redhat.com>
Date:   Mon, 16 Mar 2020 20:00:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAFEAcA_bXb_RZFxMSYJ8FAoAahAxrq3c0PBzidu+Z0iXTzZqFw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/16/20 6:11 PM, Peter Maydell wrote:
> On Mon, 16 Mar 2020 at 16:08, Philippe Mathieu-Daudé <philmd@redhat.com> wrote:
>>
>> Xen on ARM does not use QEMU machines [*]. Disable the 'virt'
>> machine there to avoid odd errors such:
>>
>>      CC      i386-softmmu/hw/cpu/a15mpcore.o
>>    hw/cpu/a15mpcore.c:28:10: fatal error: kvm_arm.h: No such file or directory
>>
>> [*] https://wiki.xenproject.org/wiki/Xen_ARM_with_Virtualization_Extensions#Use_of_qemu-system-i386_on_ARM
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>> ---
>> Cc: Stefano Stabellini <sstabellini@kernel.org>
>> Cc: Anthony Perard <anthony.perard@citrix.com>
>> Cc: Paul Durrant <paul@xen.org>
>> Cc: xen-devel@lists.xenproject.org
>> ---
>>   hw/arm/Kconfig | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/hw/arm/Kconfig b/hw/arm/Kconfig
>> index 8e801cd15f..69a8e30125 100644
>> --- a/hw/arm/Kconfig
>> +++ b/hw/arm/Kconfig
>> @@ -1,5 +1,6 @@
>>   config ARM_VIRT
>>       bool
>> +    depends on !XEN
>>       default y if KVM
>>       imply PCI_DEVICES
>>       imply TEST_DEVICES
>> --
> 
> This seems odd to me:
> (1) the error message you quote is for a15mpcore.c, not virt.c

This is the first device the virt board selects:

config ARM_VIRT
     bool
     imply PCI_DEVICES
     imply TEST_DEVICES
     imply VFIO_AMD_XGBE
     imply VFIO_PLATFORM
     imply VFIO_XGMAC
     imply TPM_TIS_SYSBUS
     select A15MPCORE
     ...

> (2) shouldn't this be prevented by something saying "don't build
> guest architecture X boards into Y-softmmu", rather than a specific
> flag for a specific arm board ?

Yes, agreed. This surgical change was quicker for my testing, but we 
don't need this patch right now, so let's drop it.

> 
> thanks
> -- PMM
> 

