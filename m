Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA9F63EF48
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 12:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbiLALSc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 06:18:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiLALRq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 06:17:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA44AD98E
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 03:12:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669893125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hSpcoi42VLcc/zf5D12uItqsofact4/D/isv3xkhS+A=;
        b=dUhh03FXQtiJ5fPcddE0+LUUAMHFXzVyzLzAnc8GHB8Mnz+QOD8rxqLVnwO1gT9kcOGvY1
        Nw1I4V42XSt0tG6UrsgjsRZ0R2kEHNK/174200HhqPzom7nbWAs3dYc5YEijUPWc+bNhXQ
        EULeDmTVbgM/XIzBBSauq2WJOiymCd0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-619-hNqf8r-GNmmdPKfcqOf3SA-1; Thu, 01 Dec 2022 06:12:02 -0500
X-MC-Unique: hNqf8r-GNmmdPKfcqOf3SA-1
Received: by mail-wr1-f70.google.com with SMTP id a7-20020adfbc47000000b002421f817287so314307wrh.4
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 03:12:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hSpcoi42VLcc/zf5D12uItqsofact4/D/isv3xkhS+A=;
        b=QjPi2d29/wDokAkMEda2jZSNaHPqtglw+rilJ64sQfMgbm5qHCBI/a5uDaTm9bgN9V
         nlR1GTfpFwS9l+1r+0Bcyx6jokIJFoTAPs211o77SxweaR+C4mh3AXkrCwVrvAlrYr73
         Ghc09Zoi2f3JJTZEFebOGlOxJoDl+LJxzx/r6K4bUAA0ZzJsKaAfVmYVsCJpMfa+zC9x
         i1xIcGYwR/NDeKQKz7AHdz/Q10hyj6SHmkg6QZ3PAB0mwL8USAjhghcNQAoJ0LcEOpm/
         fJmJarAdwqfUFXhshB1JVFQdP2CL3X9GKSAd/KyAV9ymOsfPxslPypqW1InsMG8XLcBm
         oTAg==
X-Gm-Message-State: ANoB5pmoh3OqgXCe3SMvqPxbKCpvgLY/fFUw/Jtd5KQ5qvYr+AML+X7B
        OnS3PhyHdwIZRNR0JXFzO7YtIxjDzr8CuJ6uS95Dd6C8Bs+URaVXB37DAY6Yb1AAAgsmhP0QDHb
        X2pH/sOpzelQB
X-Received: by 2002:a5d:430e:0:b0:241:bfb6:c6da with SMTP id h14-20020a5d430e000000b00241bfb6c6damr29646831wrq.204.1669893121122;
        Thu, 01 Dec 2022 03:12:01 -0800 (PST)
X-Google-Smtp-Source: AA0mqf75D43ftxl96kEFfG/CqGh57ZhqsLRUYWismk0mz5HWJ61yRM5mhJrzWvYKcwtXRSFWy2vHrQ==
X-Received: by 2002:a5d:430e:0:b0:241:bfb6:c6da with SMTP id h14-20020a5d430e000000b00241bfb6c6damr29646818wrq.204.1669893120905;
        Thu, 01 Dec 2022 03:12:00 -0800 (PST)
Received: from [192.168.149.123] (58.254.164.109.static.wline.lns.sme.cust.swisscom.ch. [109.164.254.58])
        by smtp.gmail.com with ESMTPSA id p33-20020a05600c1da100b003d070e45574sm5237751wms.11.2022.12.01.03.11.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 03:12:00 -0800 (PST)
Message-ID: <2f13db3f-76bb-26c1-34e3-17c97106095c@redhat.com>
Date:   Thu, 1 Dec 2022 12:11:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 0/2] KVM: selftests: Fixes for access tracking perf test
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>
References: <20221129175300.4052283-1-seanjc@google.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <20221129175300.4052283-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 29/11/2022 um 18:52 schrieb Sean Christopherson:
> Fix an inverted check in the access tracking perf test, and restore the
> assert that there aren't too many dangling idle pages when running the
> test on x86-64 bare metal.
> 
> Sean Christopherson (2):
>   KVM: selftests: Fix inverted "warning" in access tracking perf test
>   KVM: selftests: Restore assert for non-nested VMs in access tracking
>     test
> 
>  .../selftests/kvm/access_tracking_perf_test.c | 22 ++++++++++++-------
>  .../selftests/kvm/include/x86_64/processor.h  |  1 +
>  2 files changed, 15 insertions(+), 8 deletions(-)
> 
> 
> base-commit: 3e04435fe60590a1c79ec94d60e9897c3ff7d73b
> 

Makes sense, apologies for inverting the check.

Reviewed-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>

