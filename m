Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE1941B309
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 17:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241636AbhI1Phs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 11:37:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38847 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241371AbhI1Phr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Sep 2021 11:37:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632843368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8EjinECMatkFTCmbZUpsV/YBy3fxNZg2OwM3d+ESU80=;
        b=KGT+u7faernaybxCFRamTLCw8WuoWHq1f4+1M8Qz9HKONniKM8IgI6Aiqrmc2FCjhURoWa
        fAxzOHbKqwpAwr7MT0fSloKuvH+yG3lyAd11h34Y/ULUcyfOXESsjkkgc314hqtP0QNrsB
        +LI/N7O/O6Rk/hYTQimyTZt5XAoLSf0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-sPoHKXxHMWaIVO-AurXEQQ-1; Tue, 28 Sep 2021 11:36:06 -0400
X-MC-Unique: sPoHKXxHMWaIVO-AurXEQQ-1
Received: by mail-ed1-f69.google.com with SMTP id ec14-20020a0564020d4e00b003cf5630c190so22410305edb.3
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 08:36:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8EjinECMatkFTCmbZUpsV/YBy3fxNZg2OwM3d+ESU80=;
        b=QUAXwN7nqwGAaZS7W/phDZqGAdbxSr5Etv1gXDMrEWUFUmr67LbIUrS1I9G9wILyv6
         agXcJXfSg6z2NK6GQ8qb8fFZ1bMEuVy0S1fA0nGXrc/Jy3H/uvE3kMdbQv4k49vx+r54
         LaMvUiT/oXVa6wwU1IeRZz1OTw4P7khF3Yee7WftjSzG0nptVih2ShAtyEmcEXr4YwtD
         QedYCDmw3GoueD87yupfprp2py3RG2I13Po//hGcmsEFmbM/S9l/eU3VUU3CY0x6NHbq
         NqwkxnvZ0sJy2VVsXJypXeA2oeU8cmRfkn3Yx9Hm/Qs5L2c1XbkbrVr/8cnIScxTGdY9
         z6AQ==
X-Gm-Message-State: AOAM53229rXuH/OnfbTaD4nTXRMNRaIexUcKkkhANRvcMLp9Ydd5B4VT
        GVC+Etkmk9dZC429WBgLzkjnXidAXJZcQOOAk5z9tKv9l6UcMlrTfgrmdvoLlGsmLlJzzsTJW8R
        2lzuMtMoc/va+
X-Received: by 2002:a17:906:1e11:: with SMTP id g17mr7556131ejj.154.1632843365504;
        Tue, 28 Sep 2021 08:36:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxjOs0Gqnx8wUrScCHtfTbLeGp/7EMBu8QKelc4CtXUbgZMH7hPS5Rk742X6vuqV5GuC9AVMQ==
X-Received: by 2002:a17:906:1e11:: with SMTP id g17mr7556106ejj.154.1632843365154;
        Tue, 28 Sep 2021 08:36:05 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id e28sm4043271ejy.119.2021.09.28.08.36.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Sep 2021 08:36:04 -0700 (PDT)
Message-ID: <a7ab8a21-f0a4-e15f-a34b-1eaea419638a@redhat.com>
Date:   Tue, 28 Sep 2021 17:36:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [kvm-unit-tests PATCH v2 3/3] x86/msr.c generalize to any input
 msr
Content-Language: en-US
To:     ahmeddan@amazon.com, kvm@vger.kernel.org, nikos.nikoleris@arm.com,
        drjones@redhat.com, graf@amazon.com
References: <08d356da-17ce-d380-1fc9-18ba7ec67020@amazon.com>
 <20210927153028.27680-1-ahmeddan@amazon.com>
 <20210927153028.27680-3-ahmeddan@amazon.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210927153028.27680-3-ahmeddan@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/09/21 17:30, ahmeddan@amazon.com wrote:
> From: Daniele Ahmed <ahmeddan@amazon.com>
> 
> If an MSR description is provided as input by the user,
> run the test against that MSR. This allows the user to
> run tests on custom MSR's.
> 
> Otherwise run all default tests.
> 
> This is to validate custom MSR handling in user space
> with an easy-to-use tool. This kvm-unit-test submodule
> is a perfect fit. I'm extending it with a mode that
> takes an MSR index and a value to test arbitrary MSR accesses.
> 
> Signed-off-by: Daniele Ahmed <ahmeddan@amazon.com>

I don't understand; is this a debugging tool, or is it meant to be 
driven by another test suite?

I'm not sure this fits the purpose of kvm-unit-tests very well, though. 
  An alternative is BITS (https://github.com/biosbits/bits/), which is 
relatively easy to use and comes with Python bindings to RDMSR/WRMSR.

Paolo

