Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 808F838E751
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 15:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbhEXNZe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 09:25:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41824 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232401AbhEXNZc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 09:25:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621862643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=53eXAokxRIKiwyPhDqnz0iFPit9Pp7Ww3vTVyba+8os=;
        b=IDMc3kLeoBSjbTv2aKa27oI6F1Y0KSRUhFY+mQgpmy9UZufKhO3rgHIZIN+++onxOL+VdX
        Rwfp9S29KW9kvLTuG0Q5avWDXHaN8IdJ+68u7bTCpEukSzhUqP/HSN9HQJlsFqB1Dm8g6s
        RvHf+J0alssqDpMfh52SaMrKM1OmBQQ=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-550-ijHPDhUxM3G7m16uRwh-DQ-1; Mon, 24 May 2021 09:24:01 -0400
X-MC-Unique: ijHPDhUxM3G7m16uRwh-DQ-1
Received: by mail-ej1-f70.google.com with SMTP id nd10-20020a170907628ab02903a324b229bfso7588465ejc.7
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 06:24:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=53eXAokxRIKiwyPhDqnz0iFPit9Pp7Ww3vTVyba+8os=;
        b=TebrU6g1iMT08P44ydbyMHp8nGOmpPEGXkSxyATyuKdGoHAkgrnPLcGYepx1kWXJUz
         2cw+8ppGIdqlGfEQ2lBnTIzs4r7xL9K/S+LOI9XE1TTQT6b5Nr3C45ZJkmLJGSy7OI/p
         a/ieCE7M/OdNt/n7fAGu+PYpQMqQT5yQmttHIHGXhffrzpd2+9uPeVelQgVUWlc8LU/l
         vih/co2c1rCZpnF8dAT0awmxCWBO0w9cIYvJ87Nbm8jZySDsYJbjHxIf7hWdQSZ6ze/s
         /lmwlT4OCfAebyUVWZgGIpnLe99iYebp/r19+ed2rt/i0lsDEw+vxR6F6rG8WrTZs+gk
         C/Pw==
X-Gm-Message-State: AOAM531GgVtMcAYS+UGwuRims377Xm/aTZc/j6etNTN5aGyfkE0dmJvF
        6lffaZ39dd69047MvhtO8apAnEh9a9dKdybWa57q7NIsLM7leQPSbDVUmHGec2Qyfyh9owt0FTi
        De4i7FNJFAQBB
X-Received: by 2002:aa7:dd55:: with SMTP id o21mr3229153edw.295.1621862640567;
        Mon, 24 May 2021 06:24:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz3DSY6d04QH71BkovxNb1XzNKKyowTagt62xq3s0x3gA/C7y9NGdwxhXHJLyJ1St7d71e/SA==
X-Received: by 2002:aa7:dd55:: with SMTP id o21mr3229117edw.295.1621862640359;
        Mon, 24 May 2021 06:24:00 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s2sm9524965edu.89.2021.05.24.06.23.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 06:23:59 -0700 (PDT)
Subject: Re: [PATCH v2 03/10] KVM: selftests: print a message when skipping
 KVM tests
To:     Ben Gardon <bgardon@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Alexander Graf <graf@amazon.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jacob Xu <jacobhxu@google.com>,
        Makarand Sonare <makarandsonare@google.com>,
        Oliver Upton <oupton@google.com>, Peter Xu <peterx@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org
References: <20210519200339.829146-1-axelrasmussen@google.com>
 <20210519200339.829146-4-axelrasmussen@google.com>
 <CANgfPd_WV+8bAHucE=81eFTEEPv5Q-2ZjQ_beKhZyQnt4PX57Q@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <12a7376b-7bda-8fe6-f3f4-628dbccc69a2@redhat.com>
Date:   Mon, 24 May 2021 15:23:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CANgfPd_WV+8bAHucE=81eFTEEPv5Q-2ZjQ_beKhZyQnt4PX57Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/05/21 23:49, Ben Gardon wrote:
> On Wed, May 19, 2021 at 1:03 PM Axel Rasmussen <axelrasmussen@google.com> wrote:
>>
>> Previously, if this check failed, we'd just exit quietly with no output.
>> This can be confusing, so print out a short message indicating why the
>> test is being skipped.
>>
>> Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
> 
> Reviewed-by: Ben Gardon <bgardon@google.com>
> 
>> ---
>>   tools/testing/selftests/kvm/lib/kvm_util.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
>> index f05ca919cccb..0d6ddee429b9 100644
>> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
>> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
>> @@ -53,8 +53,10 @@ int kvm_check_cap(long cap)
>>          int kvm_fd;
>>
>>          kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
>> -       if (kvm_fd < 0)
>> +       if (kvm_fd < 0) {
>> +               print_skip("KVM not available, errno: %d", errno);
>>                  exit(KSFT_SKIP);
>> +       }
> 
> This is a wonderful change. I believe this will only be hit if KVM is
> built as a module and that module has not yet been loaded, so this
> message could also suggest that the user check if the KVM / KVM
> arch/vendor specific module has been loaded.

Let's make it

                 print_skip("%s not available, is KVM loaded? (errno: %d)",
                            KVM_DEV_PATH, errno);

Paolo

