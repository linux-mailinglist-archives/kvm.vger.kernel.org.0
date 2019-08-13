Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0ED18B7EF
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 14:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727650AbfHMMFr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 08:05:47 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:32863 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbfHMMFr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 08:05:47 -0400
Received: by mail-wm1-f65.google.com with SMTP id p77so928433wme.0
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2019 05:05:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kYSnU3M9tnu2B5qcAis+c65F8HPZfiPszFaCA/33B2E=;
        b=mrQrrgTwFTWAusVHhdhjosMeYoUz8zBWaorAW47h1FWEIWcWpdUlL9hk2UYQZYK2O+
         +yNQkTJ8BAWBVqWQaXkzsrlb926P3q3O6bz0fssEe8CCqXWr4BARcKHwtLNRs6oAsBUx
         k/TiFKn6VVqjtOJBF+j+PCMcX1B7MMo3fnfW8NRUMkWKBJ7i2BOPyJOTw81F36+FTn48
         fGfRPmKOAeqJYQPjmT73ThwnGehtr90oeYVwXlnSLhwuNOx/gZQs8JhqK/ARhd3Gms+U
         4JnrU7se6ha3Sqr6PffS7QCYGWKaSt/HquB5Sfx8cNvPCSPjILHF24VswwbWRep8yWpy
         hjAg==
X-Gm-Message-State: APjAAAV9yFHMvAPyDs5KnaFWwPFXq27ij+WcFaNGsA6q1/9woPiaOf4S
        zUAy6cO2tZrWcxKChv6+2/Okdw==
X-Google-Smtp-Source: APXvYqwDvXE1vatdw3dMr0IGP0oj23Rxr3k5pb4T9pBfUJblc9ZP55o2J4hoNtnFIQoBFt/yDxh4ag==
X-Received: by 2002:a1c:ca0c:: with SMTP id a12mr2702757wmg.71.1565697945224;
        Tue, 13 Aug 2019 05:05:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5193:b12b:f4df:deb6? ([2001:b07:6468:f312:5193:b12b:f4df:deb6])
        by smtp.gmail.com with ESMTPSA id c11sm5274291wrt.25.2019.08.13.05.05.44
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 05:05:44 -0700 (PDT)
Subject: Re: [PATCH 0/3] Reduce the number of Valgrind reports in unit tests.
To:     Andrey Shinkevich <andrey.shinkevich@virtuozzo.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "qemu-block@nongnu.org" <qemu-block@nongnu.org>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "berto@igalia.com" <berto@igalia.com>,
        "mdroth@linux.vnet.ibm.com" <mdroth@linux.vnet.ibm.com>,
        "armbru@redhat.com" <armbru@redhat.com>,
        "ehabkost@redhat.com" <ehabkost@redhat.com>,
        "rth@twiddle.net" <rth@twiddle.net>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        Denis Lunev <den@virtuozzo.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>
References: <1564502498-805893-1-git-send-email-andrey.shinkevich@virtuozzo.com>
 <fe62e531-dbe9-c96e-d2c0-28fd123df347@virtuozzo.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <92c9ff07-178e-0c7a-c0a0-2c21f3f481db@redhat.com>
Date:   Tue, 13 Aug 2019 14:05:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <fe62e531-dbe9-c96e-d2c0-28fd123df347@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/08/19 14:02, Andrey Shinkevich wrote:
> PINGING...

I thought I had already said I queued the series?

Paolo

> On 30/07/2019 19:01, Andrey Shinkevich wrote:
>> Running unit tests under the Valgrind may help to detect QEMU memory issues
>> (suggested by Denis V. Lunev). Some of the Valgrind reports relate to the
>> unit test code itself. Let's eliminate the detected memory issues to ease
>> locating critical ones.
>>
>> Andrey Shinkevich (3):
>>    test-throttle: Fix uninitialized use of burst_length
>>    tests: Fix uninitialized byte in test_visitor_in_fuzz
>>    i386/kvm: initialize struct at full before ioctl call
>>
>>   target/i386/kvm.c                 | 3 +++
>>   tests/test-string-input-visitor.c | 8 +++-----
>>   tests/test-throttle.c             | 2 ++
>>   3 files changed, 8 insertions(+), 5 deletions(-)
>>
> 

