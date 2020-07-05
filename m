Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B3B214A91
	for <lists+kvm@lfdr.de>; Sun,  5 Jul 2020 08:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725964AbgGEGQw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Jul 2020 02:16:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35885 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725873AbgGEGQw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Jul 2020 02:16:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593929810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3VADVZ6Ej0tDqIflCyu2IGJa04QpD6Nw95M1AmRUqy0=;
        b=G7qAeS2myoTUTH1ULpx+FehAkbZc3PBZXN+azjMSkuFNYeZnz3dUx7ey3GzjTauUYfi5uf
        v1qNuyw8UFIAXB9gwmYnelnFXMIx1WFoynr3d9g8UvnQKk+HCr0mxMDI8i8ER4aVsCLiMD
        4AStgZfRcpsztkVzvdq+ytyMdxQ5NGU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-vKC1CGMgMqe4rdICUKEzUg-1; Sun, 05 Jul 2020 02:16:46 -0400
X-MC-Unique: vKC1CGMgMqe4rdICUKEzUg-1
Received: by mail-wm1-f71.google.com with SMTP id z11so41318338wmg.5
        for <kvm@vger.kernel.org>; Sat, 04 Jul 2020 23:16:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3VADVZ6Ej0tDqIflCyu2IGJa04QpD6Nw95M1AmRUqy0=;
        b=OaVPJNgrPOT3aMxb8qFGVM6syh2dJ6nZ4f2HPjF2QXzbEjVM4GkbietWNWHqn2fgZB
         Cqb4UtU23CCYe24Isi2boVJCmufMpl2hFiYrS9wFv2QV7+aJ8nOBeBRz6vbrXRYh5xji
         kB73JfvSWlMaCju1/gs2DAuJOED4YyffF8wvfj9bz8BQMpy8TS11r1m6EI0ysjuPqisO
         PgWWa6kjNYTKHnaxAtugGlyKvjh1VS6IDUOFgLQoZ3SArV1UrqVAOLN85EXEHJJaJICm
         1QayNvX5OPTvU8Y1RKLSGYcKOCs5xFgrQcCTVOPp7VGkRZBKQayltbeXTrJ0Kk4edSVb
         y/RA==
X-Gm-Message-State: AOAM533FeWGNft54PNOBqB3Hgu7tBtx22FRK5qHFrbl7I/bq4t1sYKyM
        XP4mTKnLfEMoxQ66DwPOxJ6zpN0VcIUfq1kjxErfwZWLDKbLpSlT575CY/oyrAAkPYUlCA/fw+i
        z2jVPuckrGG6X
X-Received: by 2002:adf:80e6:: with SMTP id 93mr42026010wrl.17.1593929805301;
        Sat, 04 Jul 2020 23:16:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx6bzwIY05j8xBSW3ojgumYkCmyZgKwMx4W7zE3X9NPf1kOCVtE21TGfIM3nG2WCzL7CpksAw==
X-Received: by 2002:adf:80e6:: with SMTP id 93mr42025995wrl.17.1593929805116;
        Sat, 04 Jul 2020 23:16:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:adf2:29a0:7689:d40c? ([2001:b07:6468:f312:adf2:29a0:7689:d40c])
        by smtp.gmail.com with ESMTPSA id w7sm19014289wmc.32.2020.07.04.23.16.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Jul 2020 23:16:44 -0700 (PDT)
Subject: Re: [PATCH 0/7] accel/kvm: Simplify few functions that can use global
 kvm_state
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Richard Henderson <rth@twiddle.net>, qemu-s390x@nongnu.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Peter Maydell <peter.maydell@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, qemu-arm@nongnu.org,
        Cornelia Huck <cohuck@redhat.com>, qemu-ppc@nongnu.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Huth <thuth@redhat.com>
References: <20200623105052.1700-1-philmd@redhat.com>
 <a36faa0a-6aa9-463d-03a0-b862141a427d@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ad581a87-03dd-17d3-6ad2-cd6c90170f97@redhat.com>
Date:   Sun, 5 Jul 2020 08:16:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <a36faa0a-6aa9-463d-03a0-b862141a427d@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/07/20 18:50, Philippe Mathieu-Daudé wrote:
> kind ping :)

Queued all except 4.

Paolo

> On 6/23/20 12:50 PM, Philippe Mathieu-Daudé wrote:
>> Following Paolo's idea on kvm_check_extension():
>> https://www.mail-archive.com/qemu-devel@nongnu.org/msg713794.html
>>
>> CI:
>> https://travis-ci.org/github/philmd/qemu/builds/701213438
>>
>> Philippe Mathieu-Daudé (7):
>>   accel/kvm: Let kvm_check_extension use global KVM state
>>   accel/kvm: Simplify kvm_check_extension()
>>   accel/kvm: Simplify kvm_check_extension_list()
>>   accel/kvm: Simplify kvm_set_sigmask_len()
>>   target/i386/kvm: Simplify get_para_features()
>>   target/i386/kvm: Simplify kvm_get_mce_cap_supported()
>>   target/i386/kvm: Simplify kvm_get_supported_[feature]_msrs()
>>
>>  include/sysemu/kvm.h         |  4 +-
>>  accel/kvm/kvm-all.c          | 76 +++++++++++++++----------------
>>  hw/hyperv/hyperv.c           |  2 +-
>>  hw/i386/kvm/clock.c          |  2 +-
>>  hw/i386/kvm/i8254.c          |  4 +-
>>  hw/i386/kvm/ioapic.c         |  2 +-
>>  hw/intc/arm_gic_kvm.c        |  2 +-
>>  hw/intc/openpic_kvm.c        |  2 +-
>>  hw/intc/xics_kvm.c           |  2 +-
>>  hw/s390x/s390-stattrib-kvm.c |  2 +-
>>  target/arm/kvm.c             | 13 +++---
>>  target/arm/kvm32.c           |  2 +-
>>  target/arm/kvm64.c           | 15 +++---
>>  target/i386/kvm.c            | 88 +++++++++++++++++-------------------
>>  target/mips/kvm.c            |  6 +--
>>  target/ppc/kvm.c             | 34 +++++++-------
>>  target/s390x/cpu_models.c    |  3 +-
>>  target/s390x/kvm.c           | 30 ++++++------
>>  18 files changed, 141 insertions(+), 148 deletions(-)
>>
> 

