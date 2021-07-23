Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD8D3D3650
	for <lists+kvm@lfdr.de>; Fri, 23 Jul 2021 10:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234319AbhGWHeu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jul 2021 03:34:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40873 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234302AbhGWHes (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Jul 2021 03:34:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627028121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S5h8CfPGc3/EAnylIwz0BlyTxAcAAXtFB/keJHiRdL0=;
        b=HSEvPrLq4eMtBkSo6XhIO7jEKG2CBCcbgATJ/lXnmiim8xXEk+f61m1imVbBa3b5uGjnWX
        bw8toDrKZQi2Z745yy15g7LfqIXBIPzPO6v7LM8kDHJhTVS2015D4U3CITqbfyOkClkP6T
        d3+j5RVunlMsjXdKd0iAcfjuSGbhVwk=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-I7Dj_yz3ONycg2eUUt8VnA-1; Fri, 23 Jul 2021 04:15:20 -0400
X-MC-Unique: I7Dj_yz3ONycg2eUUt8VnA-1
Received: by mail-ed1-f70.google.com with SMTP id h16-20020aa7de100000b02903a6620f87feso313409edv.18
        for <kvm@vger.kernel.org>; Fri, 23 Jul 2021 01:15:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S5h8CfPGc3/EAnylIwz0BlyTxAcAAXtFB/keJHiRdL0=;
        b=C7iYblDKvIWuUFhM41+CX9B+rGUJmOfJ1zl2/VQ7xjYoI6nxl5EvkfCuYR4txp9XPp
         Eb7Tprv4mmb2Pwyr9emohWoCwOdEQpprq/hFVsUL72scy14vLWWPSb3dlMMolykfaMJ1
         QRaosRj5Phttj+ZCnmcaEG4xfX//QFrFUsoYzRQ6QYViZAZ02gJWDV0C6ZnUGgakqPpI
         eAXSiy8lUrQZW5k3cZnmL4KyKDIjAUo7BLYakp0FK/26tKYHXG5vsSMh89hz88L9cu69
         lLuno9UW1cHKMWp0Tvy0SCbbdwAow8p5DMDWZUA5wEc9n7zMrqjK8ty2X5IQ3JkRIL29
         aGOg==
X-Gm-Message-State: AOAM532eYfaIuWoCrFW/tHJzm9opLPM7e2R8do1pdCsXuqy0b+5u9dqS
        2wH7V2eh8bI3IkwO+YWtG/DvC6JwtURm2yOc6EEtIKncBTDrqeYoXA2gvnnNBJYkN81ApTRLjP0
        b3XgNcj5P2NUl
X-Received: by 2002:aa7:c74e:: with SMTP id c14mr4238389eds.40.1627028119259;
        Fri, 23 Jul 2021 01:15:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyAevn/HV6ZQPhA4/0iP0NZbQddJwXQZkug6NTv3prcxjJErW78BlMXlDr65tIAh9UTL7lwZA==
X-Received: by 2002:aa7:c74e:: with SMTP id c14mr4238379eds.40.1627028119140;
        Fri, 23 Jul 2021 01:15:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.gmail.com with ESMTPSA id n13sm10243194ejk.97.2021.07.23.01.15.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jul 2021 01:15:18 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] travis.yml: Disable the failing gicv2-mmio
 test
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>
References: <20210722172354.3759847-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b2ec5161-9380-c96d-8405-d16b7e41170d@redhat.com>
Date:   Fri, 23 Jul 2021 10:15:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210722172354.3759847-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/07/21 19:23, Thomas Huth wrote:
> The test is constantly failing now. After trying the old commit
> that re-introduced the .travis.yml file again in Travis-CI, it is
> now also failing there, so this is likely not a regression in the
> kvm-unit-tests, but a regression in the Travis-CI / Ubuntu build
> environment. Thus let's simply disable the test for now, since
> there is not much else we can do from the kvm-unit-test side here.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>   .travis.yml | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/.travis.yml b/.travis.yml
> index 4fcb687..9b98764 100644
> --- a/.travis.yml
> +++ b/.travis.yml
> @@ -13,7 +13,7 @@ jobs:
>           apt_packages: qemu-system-aarch64
>         env:
>         - CONFIG="--arch=arm64 --cc=clang"
> -      - TESTS="cache gicv2-active gicv2-ipi gicv2-mmio gicv3-active gicv3-ipi
> +      - TESTS="cache gicv2-active gicv2-ipi gicv3-active gicv3-ipi
>             pci-test pmu-cycle-counter pmu-event-counter-config pmu-sw-incr
>             selftest-setup selftest-smp selftest-vectors-kernel
>             selftest-vectors-user timer"
> 

Please apply, thanks!

Paolo

