Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D26263ECC
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 09:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgIJHad (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 03:30:33 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38266 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726746AbgIJHa3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Sep 2020 03:30:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599723027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=O2/LZQ4SfG2uIyz2Sy8hmaRH8IBqBKbrVmAQjPIOGyA=;
        b=NXFYqvhdyxEuHZwNKUBZDMqUuN6VMQMxdYBq9DIfaO7YO1LyWcenX49vPEkKXqOiYQb6lp
        oUl82EHfUSvcL6iuQovA+4LnF+YuAGQyGsNN83eBN4wldvh4EdexujIzUFQP68Ab9IX9Si
        nc3TD/5Uq2PUH/Q35FnSDrgGXnK18Vs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-nZjQh6XkMo6Gd9RcXNrGRQ-1; Thu, 10 Sep 2020 03:30:23 -0400
X-MC-Unique: nZjQh6XkMo6Gd9RcXNrGRQ-1
Received: by mail-wr1-f71.google.com with SMTP id l15so1921362wro.10
        for <kvm@vger.kernel.org>; Thu, 10 Sep 2020 00:30:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=O2/LZQ4SfG2uIyz2Sy8hmaRH8IBqBKbrVmAQjPIOGyA=;
        b=C+LHEvCWBiKPy/VEgWEI2H+kVswIFi5YRnc7OkY1xlr9J5a8r8MZU/jrxwiPau5EFT
         lyT1k0sYsVbPlx/2mj/lm++5fs8e/KboJRv0a0sLd+Ol9w0J0c9Q6XFphx4bXZ4rXOaK
         xhBwA7I8JCOcgn4CQCYDug/HOD2RImk/U+IEAYRvyXhYkct7x4xBvBZbQiBY1DetTaDo
         6oz0tNHGpZd8fl6Ixqgr08yvT7dAyYHCcwZX/Rqm12DYPuBlE9/qGz4zQXVf4pCk5An0
         rw9qoHo/QUDdm6CdX4s6XdZkxPnVIlKeUzmRKrRYxJVQN7UrdywoqHdY2Ac8mr7kBSR8
         +iqg==
X-Gm-Message-State: AOAM533yBDihBAh3c+j25snl3euvgC/Zh6gWrnSpzgPT3f4gWN7OgZml
        NUyTQonG1DLTTe/BwuzdvpyMPG7cxY8QV3wRKoThwIvCu7XJBzaZD7EsfuEvE0lHq9UQ5lChwm6
        jSgb8hHpsd7RD
X-Received: by 2002:a1c:1f42:: with SMTP id f63mr6842948wmf.1.1599723022616;
        Thu, 10 Sep 2020 00:30:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxa+AilB8jUcoDap4Dj/Q6aT+m/RhHroGA32WyZFmjvYzvEnjSYEsACVxXBGVSjK7VmvtWsJQ==
X-Received: by 2002:a1c:1f42:: with SMTP id f63mr6842931wmf.1.1599723022407;
        Thu, 10 Sep 2020 00:30:22 -0700 (PDT)
Received: from [192.168.1.36] (65.red-83-57-170.dynamicip.rima-tde.net. [83.57.170.65])
        by smtp.gmail.com with ESMTPSA id b76sm2377151wme.45.2020.09.10.00.30.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2020 00:30:21 -0700 (PDT)
Subject: Re: [PATCH 5/6] hw/pci-host/q35: Rename PCI 'black hole as '(memory)
 hole'
To:     Thomas Huth <thuth@redhat.com>, qemu-devel@nongnu.org
Cc:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, qemu-arm@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        Jason Wang <jasowang@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        qemu-trivial@nongnu.org, Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Joel Stanley <joel@jms.id.au>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20200910070131.435543-1-philmd@redhat.com>
 <20200910070131.435543-6-philmd@redhat.com>
 <7dbdef90-1ca6-bf27-7084-af0c716d01d9@redhat.com>
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
Message-ID: <8c883b22-c63a-9c61-8dd5-14f26f5e5237@redhat.com>
Date:   Thu, 10 Sep 2020 09:30:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <7dbdef90-1ca6-bf27-7084-af0c716d01d9@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/10/20 9:15 AM, Thomas Huth wrote:
> On 10/09/2020 09.01, Philippe Mathieu-Daudé wrote:
>> In order to use inclusive terminology, rename "blackhole"
>> as "(memory)hole".
> 
> A black hole is a well-known astronomical term, which is simply named
> that way since it absorbes all light. I doubt that anybody could get
> upset by this term?

Let's put some light in our address space then :)

But you right, the NASA does not consider renaming this one:
https://www.space.com/nasa-stops-racist-nicknames-cosmic-objects.html

Note than for electronic busses design, master/slave are also
well-known terms, but they might be considered offensive.
I changed this one too because I'm not sure about its offensiveness
threshold.

> 
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>> ---
>>  include/hw/pci-host/q35.h |  4 ++--
>>  hw/pci-host/q35.c         | 38 +++++++++++++++++++-------------------
>>  tests/qtest/q35-test.c    |  2 +-
>>  3 files changed, 22 insertions(+), 22 deletions(-)
>>
>> diff --git a/include/hw/pci-host/q35.h b/include/hw/pci-host/q35.h
>> index 070305f83df..0fb90aca18b 100644
>> --- a/include/hw/pci-host/q35.h
>> +++ b/include/hw/pci-host/q35.h
>> @@ -48,8 +48,8 @@ typedef struct MCHPCIState {
>>      PAMMemoryRegion pam_regions[13];
>>      MemoryRegion smram_region, open_high_smram;
>>      MemoryRegion smram, low_smram, high_smram;
>> -    MemoryRegion tseg_blackhole, tseg_window;
>> -    MemoryRegion smbase_blackhole, smbase_window;
>> +    MemoryRegion tseg_hole, tseg_window;
>> +    MemoryRegion smbase_hole, smbase_window;
> 
> Maybe rather use smbase_memhole and tseg_memhole?

OK.

> 
>  Thomas
> 

