Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3A6B456C3D
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 10:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234227AbhKSJW1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 04:22:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:32021 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232838AbhKSJW1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Nov 2021 04:22:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637313565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E266SDXzLHIxl43LIS73TeDZ/d3Fcnvgvqms81b0A3s=;
        b=EoklNpjV55LxXjM6jp21B+v8BjUPzAsWreOMXD08VC8KDoxtP5EGMrmxtsU4LBoPTwkPd5
        vpJx4I1CfG+Dyw86x/wVCniQsKAWGUAtWbUWPKilhtRfx8eBPyLtagvR+lmR8cdj9BXfej
        vFWsWx5AJNKS02Ale71JGQyKRtRIDjA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-27-dP6U_VvsO3GLMi9SqOjUNA-1; Fri, 19 Nov 2021 04:19:24 -0500
X-MC-Unique: dP6U_VvsO3GLMi9SqOjUNA-1
Received: by mail-wm1-f72.google.com with SMTP id j25-20020a05600c1c1900b00332372c252dso4455277wms.1
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 01:19:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=E266SDXzLHIxl43LIS73TeDZ/d3Fcnvgvqms81b0A3s=;
        b=yJM8L3riw7eDEi0zyaYfgbV5bZZ0YroVzuFWNvRJac0YPStgzobdBKkaZ6aBWvlrRl
         TzfXjFaKZhwnpSYKAyyYR2O9xoy4UJKSqmZg4OpP/pCTXz/c/rZesG79HV8HG/lgsT+J
         MbBepoU6KUieF/U8dTIwdf0ICHPVNvatOEFLcOLhPiS/vBpSr932DPVSD1yo5ZOZ/isH
         rtX1e3+yEJx5ZMx2EgyprtaoJkr96jNfGhTSA+fJwpC2boPqx8ES2tjRWM1fCaRPS8+8
         /lKrwUrTMi04fQzght1mgi2aLmVp/G4a+MwfPQr1GjEDuZR2Dqn3NFzACL7UdjDI8UJz
         oJyQ==
X-Gm-Message-State: AOAM531hPnlz3vjDwwgPLVbUyrgiVOsHx14sNMTdQ09asWcYzZTTskAi
        lBWqVcuWHtmYq2a4NR1JpZ3GA7YDLC2CocK/ujOvPi7vIkFUHG8h0V+N9CnYAbjJbOM5HM/Hqyc
        7DU2oJZZkXL/3
X-Received: by 2002:a05:600c:35cb:: with SMTP id r11mr4967477wmq.190.1637313562522;
        Fri, 19 Nov 2021 01:19:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwvskJ5YMGzatLiohpJn7UHdjsMomT+A1M1dedr5UQ9uBQx3VoVwV6+wnHcC9M9t8vTf7kiTQ==
X-Received: by 2002:a05:600c:35cb:: with SMTP id r11mr4967462wmq.190.1637313562395;
        Fri, 19 Nov 2021 01:19:22 -0800 (PST)
Received: from [192.168.1.36] (62.red-83-57-168.dynamicip.rima-tde.net. [83.57.168.62])
        by smtp.gmail.com with ESMTPSA id g13sm2177762wmk.37.2021.11.19.01.19.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Nov 2021 01:19:21 -0800 (PST)
Message-ID: <56364602-300e-1ff7-da3d-83fdc30ee4cc@redhat.com>
Date:   Fri, 19 Nov 2021 10:19:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH-for-6.2?] docs: Spell QEMU all caps
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        qemu-block@nongnu.org, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>, Eric Blake <eblake@redhat.com>
References: <20211118143401.4101497-1-philmd@redhat.com>
 <3bb56b6f-6547-ec56-accd-93ae7f4f592d@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
In-Reply-To: <3bb56b6f-6547-ec56-accd-93ae7f4f592d@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/19/21 10:17, Paolo Bonzini wrote:
> On 11/18/21 15:34, Philippe Mathieu-Daudé wrote:
>> Replace Qemu -> QEMU.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>> ---
>>   docs/devel/modules.rst                |  2 +-
>>   docs/devel/multi-thread-tcg.rst       |  2 +-
>>   docs/devel/style.rst                  |  2 +-
>>   docs/devel/ui.rst                     |  4 ++--
>>   docs/interop/nbd.txt                  |  6 +++---
>>   docs/interop/qcow2.txt                |  8 ++++----
>>   docs/multiseat.txt                    |  2 +-
>>   docs/system/device-url-syntax.rst.inc |  2 +-
>>   docs/system/i386/sgx.rst              | 26 +++++++++++++-------------
>>   docs/u2f.txt                          |  2 +-
>>   10 files changed, 28 insertions(+), 28 deletions(-)

>>  
> 
> Queued, thanks.

Hmm I just sent v2 with improved commit description:
https://lore.kernel.org/kvm/20211119091701.277973-2-philmd@redhat.com/

