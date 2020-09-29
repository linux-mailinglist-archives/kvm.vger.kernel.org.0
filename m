Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 424C427D5BD
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 20:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728240AbgI2S1E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 14:27:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38930 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727605AbgI2S1E (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 14:27:04 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601404022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=Jybl1D4ZSZouXyfbqfXTgUYFscYvt7JB+EcoN7nDhLI=;
        b=YFzBNynwrptnLU0NGJECKNkyv8DZs8y3ghDVndK2qQUSKRZOrBOXbqEefQJ9MqEgI87Xx5
        PrgDDHaWeTJvqsWxSqTZlKbwDhei3D9tYDruDDiEV7x/tgb4zXsfk1Q6ybciZALv5GXFKG
        ZVCzieFhMmLLuVFXHs0c2zYrLgxzSEY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-82-agYGU8iwPQO8fKra9c17mw-1; Tue, 29 Sep 2020 14:27:00 -0400
X-MC-Unique: agYGU8iwPQO8fKra9c17mw-1
Received: by mail-wm1-f71.google.com with SMTP id y18so2031511wma.4
        for <kvm@vger.kernel.org>; Tue, 29 Sep 2020 11:27:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Jybl1D4ZSZouXyfbqfXTgUYFscYvt7JB+EcoN7nDhLI=;
        b=RcmELwaEfrqxd3qn8GKpGfAmzYO+ZmVW7nosFL8Y4qujxE7NW0v+VH+cxD/Tm9iwDs
         gPunrqOYpCHCKVC3bTO6QiWbFzCjVduUFhm8qs8lgwBEtGHRj2wUf5ucs5mj6SnhzEMS
         6qBXH+M2SiH2/uhRr7Gdt5zRe/Kks7quE6LoIOjxwsmKGi0+jOWlqo1Uy1kg2R1ggKQn
         1vkIP8Bbq71Ln8cnO8KwsKb6MUZwd1PstRDiHDwrlaeKJXPgJlcJq+fKpJB4cloKylH/
         Cg2rcKSnM5hJ7UYsn+b5SM/SS/v9aTxkGGhWfvfR/KSJ4RocAI4xKjK5Tti7vhZ0fpxz
         YHuQ==
X-Gm-Message-State: AOAM531GUtpqCQNOwkEMF95O43n4KisYXefNM+5HlRrO3fVjTxNoTYDi
        dK+ChXEzoPGyJH9sk8XR+awRu9iIVP+QJVY+CtG5+SPjyxn/6abpkMMH6I0+0Ez/ftyLyWRyJG6
        ZpRm17tgrQ+ap
X-Received: by 2002:a5d:60d0:: with SMTP id x16mr5759666wrt.196.1601404019394;
        Tue, 29 Sep 2020 11:26:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzFivTaNKRwK2b9BARnlAvat64Fm257HJeP3L8ZaaZaO6NjStZBNfC+JkoBXLiIlGn26t/hrg==
X-Received: by 2002:a5d:60d0:: with SMTP id x16mr5759650wrt.196.1601404019236;
        Tue, 29 Sep 2020 11:26:59 -0700 (PDT)
Received: from [192.168.1.36] (74.red-83-53-161.dynamicip.rima-tde.net. [83.53.161.74])
        by smtp.gmail.com with ESMTPSA id n14sm6199885wmi.33.2020.09.29.11.26.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2020 11:26:58 -0700 (PDT)
Subject: Re: [PATCH v3 17/19] hw/arm: Automatically select the 'virt' machine
 on KVM
To:     Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org
Cc:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        qemu-arm@nongnu.org, Fam Zheng <fam@euphon.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
References: <20200316160634.3386-1-philmd@redhat.com>
 <20200316160634.3386-18-philmd@redhat.com>
 <d0842e82-8640-5903-e59b-99963584b89a@linaro.org>
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
Message-ID: <34599763-9e6f-cade-fd23-c6efbac60a94@redhat.com>
Date:   Tue, 29 Sep 2020 20:26:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <d0842e82-8640-5903-e59b-99963584b89a@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/16/20 9:06 PM, Richard Henderson wrote:
> On 3/16/20 9:06 AM, Philippe Mathieu-Daudé wrote:
>> When building a KVM-only QEMU, the 'virt' machine is a good
>> default :)
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>> ---
>>  hw/arm/Kconfig | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/hw/arm/Kconfig b/hw/arm/Kconfig
>> index d0903d8544..8e801cd15f 100644
>> --- a/hw/arm/Kconfig
>> +++ b/hw/arm/Kconfig
>> @@ -1,5 +1,6 @@
>>  config ARM_VIRT
>>      bool
>> +    default y if KVM
>>      imply PCI_DEVICES
>>      imply TEST_DEVICES
>>      imply VFIO_AMD_XGBE
>>
> 
> Likewise SBSA_REF?

OK.

> Otherwise, what is this for?
> Did you remove ARM_VIRT from default-config/*?

This is to use custom config (and easily test by
blowing default-config/).

> 
> 
> r~
> 

