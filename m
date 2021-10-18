Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E00431693
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 12:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbhJRK4T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 06:56:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36371 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229491AbhJRK4R (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 06:56:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634554446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0UGHEy0KSirReAesLAC81k90uijHa8m3tA+7RLpvJyE=;
        b=cE0Xt1kVHlmDMIKUmLQ97Ifn/F9tNi76Hl/HO4D25UQgRUEewHZfA/ngA6BGNO8ec3g6Hv
        Udbr5l1Ky1tuQhvrHqnOv/g9wgixPs8pr5/or5zprknkuonrgOGqjVfdtq7KTYRJxjR1v6
        qBwAh4sr88rWU7IKrcmu/pSGrdIVIv0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-82-uKiBUX5GOOqFOtrQTRpBOw-1; Mon, 18 Oct 2021 06:54:05 -0400
X-MC-Unique: uKiBUX5GOOqFOtrQTRpBOw-1
Received: by mail-ed1-f70.google.com with SMTP id h19-20020aa7de13000000b003db6ad5245bso14044959edv.9
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 03:54:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0UGHEy0KSirReAesLAC81k90uijHa8m3tA+7RLpvJyE=;
        b=liveH/ohZrUnVmtoswa1JMrvetmdNrify+SO9Z8SUcJDUWosrAmq9up5UqpnXQlrB/
         dDAG05KJriJ9cnjDfW47wg8Fze+P0nNRYhDclHPDcQT1U20wUe8k/41muWj3PmKxB8H7
         OlHTCaVSFudRg2JAJ643T3CydzvX37ljv8b9dqjHnlo+Eg2AImJzY6jb9aQQHeR62Zal
         JujVlR3ZdTmzXcoi6p65A6F0BpydF+6BcQQT008wZKcWpuayLtgkLMxd956eCahOnzjW
         LhfljGmHnCtgKJKHRqGB8UqxatZlmy8IzxhNHAlN+wvI6jchTBgyf2cerjBPxPEJCxdF
         pp7g==
X-Gm-Message-State: AOAM530zzi9zVQBe/Vn0xeURdGHeV0QCQnCQy28J5xH5Ia6hXQDLrpaX
        +m6gR9N+P30LlwMyhI1jxuoJxhMRWPO08j38su2uEZdzs3GvQx52gDxSDOrRTeVe9lL6t0i8qbU
        +W/o/QTqC9mUc
X-Received: by 2002:a05:6402:5c2:: with SMTP id n2mr43155545edx.239.1634554444235;
        Mon, 18 Oct 2021 03:54:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzbl37EsBUhONWzuO27hrT5ZHC1cXxi9YO8Bwu86QC8GVaSRChD1xgLAyG+l/wNJUb3pkjEiA==
X-Received: by 2002:a05:6402:5c2:: with SMTP id n2mr43155511edx.239.1634554444025;
        Mon, 18 Oct 2021 03:54:04 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id t19sm8824456ejb.115.2021.10.18.03.54.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 03:54:03 -0700 (PDT)
Message-ID: <3da8fd50-bdb3-93bd-3d27-0b3f961bd531@redhat.com>
Date:   Mon, 18 Oct 2021 12:54:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 1/8] KVM: SEV-ES: fix length of string I/O
Content-Language: en-US
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        thomas.lendacky@amd.com, fwilhelm@google.com,
        kvm list <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, oupton@google.com,
        Sean Christopherson <seanjc@google.com>,
        linux-stable <stable@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
References: <CA+G9fYt7FMXbp47ObVZ4B7X917186Fu39+LM04PcbqZ2-f7-qg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CA+G9fYt7FMXbp47ObVZ4B7X917186Fu39+LM04PcbqZ2-f7-qg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/10/21 12:21, Naresh Kamboju wrote:
> [Please ignore this email if it already reported ]
> 
> Following build errors noticed while building Linux next 20211018
> with gcc-11 for i386 architecture.
> 
> i686-linux-gnu-ld: arch/x86/kvm/svm/sev.o: in function `sev_es_string_io':
> sev.c:(.text+0x110f): undefined reference to `__udivdi3'
> make[1]: *** [/builds/linux/Makefile:1247: vmlinux] Error 1
> make[1]: Target '__all' not remade because of errors.
> make: *** [Makefile:226: __sub-make] Error 2

Thank you very much, I have sent a simple fix of changing the variable 
to u32.

Paolo

