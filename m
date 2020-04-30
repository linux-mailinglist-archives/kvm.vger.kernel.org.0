Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636161BF75F
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 13:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgD3L6W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 07:58:22 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:27416 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726546AbgD3L6V (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Apr 2020 07:58:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588247900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PwkVlLlTF6QMPUlS0NrS9fdfO5mc8bH+SjES/5fPWp0=;
        b=QjdzC+xT2f1d+EnrxUgCZILGUiCMQrwuqMVA4t8vQLwIqi61JF55x7Qha1IdEWuK6D9N47
        5JxWVcK7tv0DinU4Q4y3oj4b3ZQ8DTDkBB/v2ByRV7Kffw+94q/FigFFfvL9LjbWeuZo5N
        Pz0IqbyIXolsbRdq5+5jn/UXt3LD+0A=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-K0fCbqXGMBOx4iGT0PZF1Q-1; Thu, 30 Apr 2020 07:58:18 -0400
X-MC-Unique: K0fCbqXGMBOx4iGT0PZF1Q-1
Received: by mail-wr1-f70.google.com with SMTP id m5so3733003wru.15
        for <kvm@vger.kernel.org>; Thu, 30 Apr 2020 04:58:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PwkVlLlTF6QMPUlS0NrS9fdfO5mc8bH+SjES/5fPWp0=;
        b=Rr2S9TAzSStrNWWRRnvbyM8SJ72rudqazvnrdAUjGst9Cc1DPP+S/zksfmGUIkQiio
         HTJ8QRLjSER+QmLY0fO/lKRiyYVykYUDV3nw5Jl/2bZ5iH8kTRYHKALVwGNNZy+LOrBS
         KmQ5ovyr1k5+LtT838anDt9U/OZA0dWhgTfU8mTr2WQh08Z7aRyvbr3fCRTYIiVbZ+Bb
         AZ92453n0Gf5nAts3RYQfQ5F0K36BMSAklucGPVQC8id8AuE2omJzk7Xh67CLphqHJQu
         Bv3IE7mO82qU+itAGcUghCn9plJNOVXJ5nbTcsTxghf/mRaIa/tFjtyPMtTlVgn6ky6N
         DdBQ==
X-Gm-Message-State: AGi0PuYWIBoY/ZMKbO1x4n4PKLZjGfv8WJZR2sSqlQKrCTzLaw1f0kFQ
        k3yuioic+HUWMXqZJ1eX4Zv/hVuQM2lcDDjR7oqbU7HJbMi9HUWy8gkV8zrjnry3Q7qoXGKHOf2
        KPvm95+qGqA/x
X-Received: by 2002:adf:ce0d:: with SMTP id p13mr3952856wrn.66.1588247897405;
        Thu, 30 Apr 2020 04:58:17 -0700 (PDT)
X-Google-Smtp-Source: APiQypJed6abco1HDellE1WqxYwYzBLnxa31uFxiz2O4UjVM2SCevc5wILN+RctADRgeJ3od8ZOhzw==
X-Received: by 2002:adf:ce0d:: with SMTP id p13mr3952839wrn.66.1588247897133;
        Thu, 30 Apr 2020 04:58:17 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac19:d1fb:3f5f:d54f? ([2001:b07:6468:f312:ac19:d1fb:3f5f:d54f])
        by smtp.gmail.com with ESMTPSA id b12sm4006595wro.18.2020.04.30.04.58.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 04:58:16 -0700 (PDT)
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
 <0c919928-00ed-beda-e984-35f7b6ca42fb@redhat.com>
 <702b2eaa-e425-204e-e19d-649282bfe170@amazon.com>
 <d13f3c5c-33f5-375b-8582-fe37402777cb@redhat.com>
 <d4091c63-6df6-8980-72c6-282cc553527e@amazon.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bed6e250-9de5-d719-623b-b72db78ebcb9@redhat.com>
Date:   Thu, 30 Apr 2020 13:58:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <d4091c63-6df6-8980-72c6-282cc553527e@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/04/20 13:47, Alexander Graf wrote:
>>
>> So the issue would be that a firmware image provided by the parent could
>> be tampered with by something malicious running in the parent enclave?
> 
> You have to have a root of trust somewhere. That root then checks and
> attests everything it runs. What exactly would you attest for with a
> flat address space model?
> 
> So the issue is that the enclave code can not trust its own integrity if
> it doesn't have anything at a higher level attesting it. The way this is
> usually solved on bare metal systems is that you trust your CPU which
> then checks the firmware integrity (Boot Guard). Where would you put
> that check in a VM model?

In the enclave device driver, I would just limit the attestation to the
firmware image

So yeah it wouldn't be a mode where ne_load_image is not invoked and
the enclave starts in real mode at 0xffffff0.  You would still need
"load image" functionality.

> How close would it be to a normal VM then? And
> if it's not, what's the point of sticking to such terrible legacy boot
> paths?

The point is that there's already two plausible loaders for the kernel
(bzImage and ELF), so I'd like to decouple the loader and the image.

Paolo

