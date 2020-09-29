Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C80127D88D
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 22:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729760AbgI2UhD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 16:37:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44381 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729371AbgI2Ugc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 16:36:32 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601411790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=NqSFfD7QAdpdGCC9Tkrleh4jcF2IKguhqbiW3VFzvOs=;
        b=FxqtGQu8BJZXeqvZ4t51vIwaJqcB72DyM6aYRLOBE/UgEWVHuX9y4VhCHn7L9RVrzC9K+C
        MwM0Z8cRD7OOFDEZva+XEztNnYfhmOwyi4lrhdGLUigvFY5FwcO4x/GUgWq8TRg18N64df
        2S6nRoq/WT8lI8KaAnb8Q1V6WousYoo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-MkmvOLg7Pcaq9dzTs9KFhA-1; Tue, 29 Sep 2020 16:36:26 -0400
X-MC-Unique: MkmvOLg7Pcaq9dzTs9KFhA-1
Received: by mail-wm1-f72.google.com with SMTP id m19so2284333wmg.6
        for <kvm@vger.kernel.org>; Tue, 29 Sep 2020 13:36:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=NqSFfD7QAdpdGCC9Tkrleh4jcF2IKguhqbiW3VFzvOs=;
        b=aqWRSxuYuNQaf4ZoMa5go0D8GNWEzl+IlTWM3pBjEe5cg5nLaT+GXlIJaE91ZCPf3N
         5Ko+WTeZU/RZNKdPpUF97lEJ0KizMzXDI/y60cYfnln2MYcp1kVk57kwtplCC+q56/Xz
         ZDOqFymlVLlfCrH8CZS2/pbqTAFJpUXPe3x5LQYUUS2y18M5D3npeZuWkFx/ejlGPIUw
         cD/YYoMjER/1cRX1907B5p7PhNSmqID5/xOCC57a8g9lDfkLyND0yYItFyE9HC0Pmh4I
         +8tIhYN784bTlde02zIsQj9ofi/MEUnWckRyYUcaR+Cv0PICkJRZTmPQLEiBmwFUAW6R
         oMLw==
X-Gm-Message-State: AOAM530m++kDeLIKK+eVvF+GsoqHxmxxKJXV3E81mEWpiolWuwuW7zMu
        GnFLesw8qxEpu13aH/LQvAoJ3c0t07bMxF+vKsDTBRL1UPOc6z2TQyWMyUyN/jMW3Mtrc1cOtvz
        6oT82SGcIk7pc
X-Received: by 2002:a7b:cd8b:: with SMTP id y11mr6493718wmj.172.1601411784976;
        Tue, 29 Sep 2020 13:36:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzv0Qp/AB5UWqp2781fUzVCZRy+PT3mxWTnB5vOG1PeqC+ApznMQVxwvZ7ue/IGIzRG4PzifA==
X-Received: by 2002:a7b:cd8b:: with SMTP id y11mr6493703wmj.172.1601411784776;
        Tue, 29 Sep 2020 13:36:24 -0700 (PDT)
Received: from [192.168.1.36] (74.red-83-53-161.dynamicip.rima-tde.net. [83.53.161.74])
        by smtp.gmail.com with ESMTPSA id n21sm6788855wmi.21.2020.09.29.13.36.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2020 13:36:24 -0700 (PDT)
Subject: Re: [PATCH v3 17/19] hw/arm: Automatically select the 'virt' machine
 on KVM
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm-devel <kvm@vger.kernel.org>, Thomas Huth <thuth@redhat.com>,
        qemu-arm <qemu-arm@nongnu.org>, Fam Zheng <fam@euphon.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>
References: <20200316160634.3386-1-philmd@redhat.com>
 <20200316160634.3386-18-philmd@redhat.com>
 <CAFEAcA-Rt__Du0TqqVFov4mNoBvC9hTt7t7e-3G45Eck4z94tQ@mail.gmail.com>
 <CAFEAcA-u53dVdv8EJdeeOWxw+SfPJueTq7M6g0vBF5XM2Go4zw@mail.gmail.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Autocrypt: addr=philmd@redhat.com; keydata=
 mQINBDXML8YBEADXCtUkDBKQvNsQA7sDpw6YLE/1tKHwm24A1au9Hfy/OFmkpzo+MD+dYc+7
 bvnqWAeGweq2SDq8zbzFZ1gJBd6+e5v1a/UrTxvwBk51yEkadrpRbi+r2bDpTJwXc/uEtYAB
 GvsTZMtiQVA4kRID1KCdgLa3zztPLCj5H1VZhqZsiGvXa/nMIlhvacRXdbgllPPJ72cLUkXf
 z1Zu4AkEKpccZaJspmLWGSzGu6UTZ7UfVeR2Hcc2KI9oZB1qthmZ1+PZyGZ/Dy+z+zklC0xl
 XIpQPmnfy9+/1hj1LzJ+pe3HzEodtlVA+rdttSvA6nmHKIt8Ul6b/h1DFTmUT1lN1WbAGxmg
 CH1O26cz5nTrzdjoqC/b8PpZiT0kO5MKKgiu5S4PRIxW2+RA4H9nq7nztNZ1Y39bDpzwE5Sp
 bDHzd5owmLxMLZAINtCtQuRbSOcMjZlg4zohA9TQP9krGIk+qTR+H4CV22sWldSkVtsoTaA2
 qNeSJhfHQY0TyQvFbqRsSNIe2gTDzzEQ8itsmdHHE/yzhcCVvlUzXhAT6pIN0OT+cdsTTfif
 MIcDboys92auTuJ7U+4jWF1+WUaJ8gDL69ThAsu7mGDBbm80P3vvUZ4fQM14NkxOnuGRrJxO
 qjWNJ2ZUxgyHAh5TCxMLKWZoL5hpnvx3dF3Ti9HW2dsUUWICSQARAQABtDJQaGlsaXBwZSBN
 YXRoaWV1LURhdWTDqSAoUGhpbCkgPHBoaWxtZEByZWRoYXQuY29tPokCVQQTAQgAPwIbDwYL
 CQgHAwIGFQgCCQoLBBYCAwECHgECF4AWIQSJweePYB7obIZ0lcuio/1u3q3A3gUCXsfWwAUJ
 KtymWgAKCRCio/1u3q3A3ircD/9Vjh3aFNJ3uF3hddeoFg1H038wZr/xi8/rX27M1Vj2j9VH
 0B8Olp4KUQw/hyO6kUxqkoojmzRpmzvlpZ0cUiZJo2bQIWnvScyHxFCv33kHe+YEIqoJlaQc
 JfKYlbCoubz+02E2A6bFD9+BvCY0LBbEj5POwyKGiDMjHKCGuzSuDRbCn0Mz4kCa7nFMF5Jv
 piC+JemRdiBd6102ThqgIsyGEBXuf1sy0QIVyXgaqr9O2b/0VoXpQId7yY7OJuYYxs7kQoXI
 6WzSMpmuXGkmfxOgbc/L6YbzB0JOriX0iRClxu4dEUg8Bs2pNnr6huY2Ft+qb41RzCJvvMyu
 gS32LfN0bTZ6Qm2A8ayMtUQgnwZDSO23OKgQWZVglGliY3ezHZ6lVwC24Vjkmq/2yBSLakZE
 6DZUjZzCW1nvtRK05ebyK6tofRsx8xB8pL/kcBb9nCuh70aLR+5cmE41X4O+MVJbwfP5s/RW
 9BFSL3qgXuXso/3XuWTQjJJGgKhB6xXjMmb1J4q/h5IuVV4juv1Fem9sfmyrh+Wi5V1IzKI7
 RPJ3KVb937eBgSENk53P0gUorwzUcO+ASEo3Z1cBKkJSPigDbeEjVfXQMzNt0oDRzpQqH2vp
 apo2jHnidWt8BsckuWZpxcZ9+/9obQ55DyVQHGiTN39hkETy3Emdnz1JVHTU0Q==
Message-ID: <c7d07e18-57dd-7b55-f3dc-283c9d13e4b5@redhat.com>
Date:   Tue, 29 Sep 2020 22:36:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CAFEAcA-u53dVdv8EJdeeOWxw+SfPJueTq7M6g0vBF5XM2Go4zw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/29/20 10:11 PM, Peter Maydell wrote:
> On Tue, 29 Sep 2020 at 21:06, Peter Maydell <peter.maydell@linaro.org> wrote:
>>
>> On Mon, 16 Mar 2020 at 16:08, Philippe Mathieu-Daudé <philmd@redhat.com> wrote:
>>>
>>> When building a KVM-only QEMU, the 'virt' machine is a good
>>> default :)
>>>
>>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>>> ---
>>>  hw/arm/Kconfig | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/hw/arm/Kconfig b/hw/arm/Kconfig
>>> index d0903d8544..8e801cd15f 100644
>>> --- a/hw/arm/Kconfig
>>> +++ b/hw/arm/Kconfig
>>> @@ -1,5 +1,6 @@
>>>  config ARM_VIRT
>>>      bool
>>> +    default y if KVM
>>>      imply PCI_DEVICES
>>>      imply TEST_DEVICES
>>>      imply VFIO_AMD_XGBE
>>
>> What does this actually do ? Why should the choice of
>> accelerator affect what boards we pull in by default?
> 
> Put another way, our current default is "build everything",
> so "default y if ..." on a board is a no-op...

Yes, the problem if I don't restrict to KVM, when
using the Xen accelerator odd things occur
(using configure --enable-xen --disable-tcg --disable-kvm):

Compiling C object libqemu-i386-softmmu.fa.p/hw_cpu_a15mpcore.c.o
hw/cpu/a15mpcore.c:28:10: fatal error: kvm_arm.h: No such file or directory

See
https://wiki.xenproject.org/wiki/Xen_ARM_with_Virtualization_Extensions#Use_of_qemu-system-i386_on_ARM

We can't have the 'virt' machine automatically selected if
Xen is the only accelerator...

I'm looking for a simple way to avoid modifying the Xen code.

> 
> -- PMM
> 

