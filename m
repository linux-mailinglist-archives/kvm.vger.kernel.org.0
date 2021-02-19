Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7ED31F9AE
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 14:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbhBSNLl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 08:11:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52750 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229808AbhBSNLl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Feb 2021 08:11:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613740214;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6jGcGI7NMghM+yk1S+/9TaFdhXOwNXb9bOpWsAjCScw=;
        b=cx42WunMQpxM3c70bI7a8hK5znIiSQP5Jf16fQl7F2h1q0P1WCEcNUZAaFptv/fHHGmtJU
        z/CnjO1/MPTPPUgHXKlyu0taeUvhupJruyP9gyHxbcRrO2HvQxwnR5C1TmZMJ7UuxTrsa5
        TRTWINTp8qklVZL8/hjmlOuiJFptxNE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-Df7ju6juNxyYhYetFjaDAQ-1; Fri, 19 Feb 2021 08:10:13 -0500
X-MC-Unique: Df7ju6juNxyYhYetFjaDAQ-1
Received: by mail-wr1-f72.google.com with SMTP id o16so2460169wrn.1
        for <kvm@vger.kernel.org>; Fri, 19 Feb 2021 05:10:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6jGcGI7NMghM+yk1S+/9TaFdhXOwNXb9bOpWsAjCScw=;
        b=P3qC4J4dQsiZxISJb6TcbnkuXYeJ6bONrS27TQaLsPuP8l/1AY+MBuuDjNuAM/395D
         u7jANqiBHTnCdoBDVA98nnzPLB6tbmPs0l4A/ULuNn+sx03MbJ5lWGfmh/p5WzhF3Ju0
         2iCDNoVA7j3ZEc7w6WewJSWGJ5wUFGPUZHbvrK9eoGQ4Ild0dA4bGOIahMW7nz52wSsr
         E0myYqsZ9TY+/xpvkQF9b/s0WPR4nq17Sz+JhNPlmJO9nN7DN0V21eCyQVzY58T9DEN6
         4UEWHjRJEcG17hGWpMjQt7wGn/y8b38SNkP1JKeU6Vz/e/Lm94J57q64HRg8HlE0QHTe
         GPHQ==
X-Gm-Message-State: AOAM531dvDBJIzlrqt7OBhrX1nVsyGVSMNbW2hMsnfVfAvpdCnedIL1O
        oJomOW2+TSxY8mEcfU2i8jK+DCyjDawW87obMgP9kbD56TWooLoqqOvHAhyRCdUgrUo+T6iU5yg
        BkbwuR8IfFP+l
X-Received: by 2002:a1c:6285:: with SMTP id w127mr8350352wmb.73.1613740211379;
        Fri, 19 Feb 2021 05:10:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy4PULfk9OFDjBUSPC4GzRniF6nKl/EuIq4jXzq+iccnrD0VYLy4CJeVgC3SwgGnwklt1SYQg==
X-Received: by 2002:a1c:6285:: with SMTP id w127mr8350322wmb.73.1613740211223;
        Fri, 19 Feb 2021 05:10:11 -0800 (PST)
Received: from [192.168.1.36] (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id c6sm12723259wrt.26.2021.02.19.05.10.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Feb 2021 05:10:10 -0800 (PST)
Subject: Re: [PATCH 0/7] hw/kvm: Exit gracefully when KVM is not supported
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
Cc:     qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
        Radoslaw Biernacki <rad@semihalf.com>, kvm@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Thomas Huth <thuth@redhat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        =?UTF-8?Q?Herv=c3=a9_Poussineau?= <hpoussin@reactos.org>,
        Leif Lindholm <leif@nuviainc.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        Richard Henderson <richard.henderson@linaro.org>,
        Greg Kurz <groug@kaod.org>, qemu-s390x@nongnu.org,
        qemu-arm@nongnu.org, David Gibson <david@gibson.dropbear.id.au>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20210219114428.1936109-1-philmd@redhat.com>
 <YC+oZWDs3PnWHPQo@redhat.com>
 <9540912b-1a81-1fd2-4710-2b81d5e69c5f@redhat.com>
 <YC+sgaN1EyKeyyOQ@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <a1bc4d09-804d-66a5-a3ef-6feea8606d2c@redhat.com>
Date:   Fri, 19 Feb 2021 14:10:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YC+sgaN1EyKeyyOQ@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/19/21 1:18 PM, Daniel P. Berrangé wrote:
> On Fri, Feb 19, 2021 at 01:15:25PM +0100, Philippe Mathieu-Daudé wrote:
>> On 2/19/21 1:00 PM, Daniel P. Berrangé wrote:
>>> On Fri, Feb 19, 2021 at 12:44:21PM +0100, Philippe Mathieu-Daudé wrote:
>>>> Hi,
>>>>
>>>> This series aims to improve user experience by providing
>>>> a better error message when the user tries to enable KVM
>>>> on machines not supporting it.
>>>
>>> Improved error message is good, but it is better if the mgmt apps knows
>>> not to try this in the first place.
>>
>> I am not sure this is the same problem. This series addresses
>> users from the command line (without mgmt app).
> 
> Users of mgmt apps can launch the same problematic raspbi + KVM config
> as people who  don't use a mgmt app.
> 
>>> IOW, I think we want "query-machines" to filter out machines
>>> which are not available with the currently configured accelerator.
>>>
>>> libvirt will probe separately with both TCG and KVM enabled, so if
>>> query-machines can give the right answer in these cases, libvirt
>>> will probably "just work" and not offer to even start such a VM.
>>
>> Yes, agreed. There are other discussions about 'query-machines'
>> and an eventual 'query-accels'. This series doesn't aim to fix
>> the mgmt app problems.
> 
> I think this should be fixing query-machines right now. It shouldn't
> be much harder than a single if (...) test in the code.

OK I misunderstood you at first, now I got it. Will include that in v2.

