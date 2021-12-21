Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185E447BDF2
	for <lists+kvm@lfdr.de>; Tue, 21 Dec 2021 11:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232030AbhLUKNB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Dec 2021 05:13:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59040 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230018AbhLUKNB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Dec 2021 05:13:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640081580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0ZWcYFt4dOZiNFHy108ynicEUnLGXxt1oq+4PEwW1O8=;
        b=bxAN+YHsM680n6QtW/pQ9c8YZxknWwBjBLg9jmCNijA5LsGLDhvH3pOT2MzSQm7aIr7sWe
        w03fKKu0DDD74dkRIgbfJ13pJuW81gSA/qC29JBNyns+PfNvdTks7pSZ/f6fiHuFBf+a7O
        De9nohZEwpdgctPF19MrCFSLk8B4E64=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-378-up1kBtb1OeygLsK7D8H46A-1; Tue, 21 Dec 2021 05:12:59 -0500
X-MC-Unique: up1kBtb1OeygLsK7D8H46A-1
Received: by mail-wm1-f70.google.com with SMTP id b83-20020a1c1b56000000b0033283ea5facso580900wmb.1
        for <kvm@vger.kernel.org>; Tue, 21 Dec 2021 02:12:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0ZWcYFt4dOZiNFHy108ynicEUnLGXxt1oq+4PEwW1O8=;
        b=WbrouUpuU2IwKT8f2/V3a5QwC3exur5SZ6pXMW6/ME4HD3/ctlPfrNDa5GIk5HoEcp
         7juzyNdmB0nkqnKaLfgZCIMVu21Q5Cj6yT9yRmzuQoTfELB0b/K4wLmcX95xL4hQdgJQ
         2Rc1tDXYCjpRZ+xnsZioKK0S46G3RDdPI5mrqRIz7bDS8MGa6G5daZ4WMAjC2ugHaafX
         jOOtjXrRf9liSG4ka5F9wztgwVKyDFE3pIVB0PLD2dGGiuEVSAb2O5Op2N4jEipYQaBV
         TcU4rr8rZlVpnBuAxdINLgezr1Meibkia732AL1KSL+g+ZBTW5GowCXFjKtFkhrFNvHb
         tUcw==
X-Gm-Message-State: AOAM532XM2wmEz53wD5ugyixlNkdeNd2vt163t4/IRn8uV0LCcrEelkN
        Wl3Idp5r0KsIFh05twpR1In+pjkyLW47tAkx69S8qyllfBUs+crlTzowrL8d4IMK6158Vf21rxi
        pEgoQpBnQl/os
X-Received: by 2002:adf:ef81:: with SMTP id d1mr2035075wro.132.1640081577970;
        Tue, 21 Dec 2021 02:12:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzt2iiDOniT1iPRYgQvGeFCZZHloWJeydwQM3MmUPjzTemJmeZm8H4bA//9OCzA5aPObc0E4g==
X-Received: by 2002:adf:ef81:: with SMTP id d1mr2035054wro.132.1640081577732;
        Tue, 21 Dec 2021 02:12:57 -0800 (PST)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id f13sm2144696wmq.29.2021.12.21.02.12.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Dec 2021 02:12:57 -0800 (PST)
Message-ID: <f8d97780-1d58-3dfb-10cc-eb1b8cd0c25a@redhat.com>
Date:   Tue, 21 Dec 2021 11:12:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH] scripts/arch-run: Mark migration tests as
 SKIP if ncat is not available
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Laurent Vivier <lvivier@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvm-ppc@vger.kernel.org, Eric Auger <eric.auger@redhat.com>
References: <20211221092130.444225-1-thuth@redhat.com>
 <ae15b86d-6e4d-78be-74da-845c3ef6b9ba@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <ae15b86d-6e4d-78be-74da-845c3ef6b9ba@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/12/2021 10.58, Paolo Bonzini wrote:
> On 12/21/21 10:21, Thomas Huth wrote:
>> Instead of failing the tests, we should rather skip them if ncat is
>> not available.
>> While we're at it, also mention ncat in the README.md file as a
>> requirement for the migration tests.
>>
>> Resolves: https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/issues/4
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
> 
> I would rather remove the migration tests.  There's really no reason for 
> them, the KVM selftests in the Linux tree are much better: they can find 
> migration bugs deterministically and they are really really easy to debug.  
> The only disadvantage is that they are harder to write.

I disagree: We're testing migration with QEMU here - the KVM selftests don't 
include QEMU, so we'd lose some test coverage here.
And at least the powerpc/sprs.c test helped to find some nasty bugs in the 
past already.

  Thomas

