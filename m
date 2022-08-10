Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E06D58F2BB
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 21:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbiHJTGk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 15:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbiHJTGg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 15:06:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 936A520F6A
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 12:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660158394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8rfFcHSiajP+J2gXP+bpp/DZQZAx31Zg34iclchs7q0=;
        b=XkLIi6MN1h6XpQ5Xq4lagzvLjGYWYklCzIYXhcEAH+gWh6b388X6Djp+CAXWM4eY98GAgm
        5xqdyKjV1S579TghsEB7Um5w6XwbXLYAyrVIvrAsevVKMkAG/TT527voRcQOjTZ8vEiTq7
        YYGZ3/D6NTOjflfkcrkEHUFRjs5L264=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562--0Hf51DOO96iE20s55eVVA-1; Wed, 10 Aug 2022 15:06:33 -0400
X-MC-Unique: -0Hf51DOO96iE20s55eVVA-1
Received: by mail-ed1-f72.google.com with SMTP id w5-20020a05640234c500b0043dda025648so9742700edc.8
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 12:06:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=8rfFcHSiajP+J2gXP+bpp/DZQZAx31Zg34iclchs7q0=;
        b=jDgodadUNLzXlVhX+4awG1idcl+GdAK9L0G/n10RhnMgvpUo9apmkvk8/BBWscP+kv
         awwQ7EOH5JMeovHwVcmMLw+HJoI80EBY/AclvScUqcK94Gm1MhD95/uXLp5d8xZXZ0Ns
         k6ZA5GlENyplhxqLoFRAn5vFwhJwb91L51lRDuNLUdnXgMwgi5r8wQ6zAR65fvvkxQO6
         b03xI3MayOB6FJ/d7eexOI4mJOj8JC4SEkK4zefH3Zi5kwvHbqagJbgjt0IyZukol85D
         8DxKmWXC7C69oWYYX9G46BbRueuZ8OVclBT59FvIl65J+/pyHujHjvRFXH2CSZlyxmxR
         rk6Q==
X-Gm-Message-State: ACgBeo1KDHPLxYtOTSD4nGH82zLRNu2bLJaVLr37Gm/ooCGWYJRhaxWT
        EyWK7fXsYPxaHy6tBRjqHfPhl9Z8XRBpiBruTyeaT3caALFnY3V8fS87usfjqJ7tguDXN5VZ9+z
        BSNDpY1rrVRG9
X-Received: by 2002:a17:906:9b09:b0:730:9480:9729 with SMTP id eo9-20020a1709069b0900b0073094809729mr21600420ejc.588.1660158391728;
        Wed, 10 Aug 2022 12:06:31 -0700 (PDT)
X-Google-Smtp-Source: AA6agR75ZwJqPIZNRHSsoz4IRbD8Fo2O2P/BKOzX/26JcZkhg/wjloJ+SPnUD4HxiL7+rJ2spNE9jA==
X-Received: by 2002:a17:906:9b09:b0:730:9480:9729 with SMTP id eo9-20020a1709069b0900b0073094809729mr21600404ejc.588.1660158391471;
        Wed, 10 Aug 2022 12:06:31 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id i22-20020a50fd16000000b0043df40e4cfdsm8083027eds.35.2022.08.10.12.06.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Aug 2022 12:06:30 -0700 (PDT)
Message-ID: <67a767ad-2140-ee03-9057-c0e184e45869@redhat.com>
Date:   Wed, 10 Aug 2022 21:06:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [kvm-unit-tests PATCH v3 0/7] x86: Illegal LEA test and FEP
 cleanups
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Michal Luczaj <mhal@rbox.co>
References: <20220808164707.537067-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220808164707.537067-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/8/22 18:47, Sean Christopherson wrote:
> Slightly reworked version of Michal's series clean up the FEP mess and add
> a testcase for illegal LEA.  Core ideas are all the same, just moved the
> common FEP functionality to desc.h to make it easier to use in other tests.
> 
> v3:
>   - Define __ASM_SEL/__ASM_FORM in desc.h to fix circular dependency.
>   - Move ASM_TRY_FEP() to desc.h
>   - Add is_fep_available() helper to simplify probing FEP.
>   - Use is_fep_available() in PMU test.
> 
> Michal Luczaj (4):
>    x86: emulator.c: Save and restore exception handlers
>    x86: Introduce ASM_TRY_FEP() to handle exceptions on forced emulation
>    x86: emulator.c: Use ASM_TRY() for the UD_VECTOR cases
>    x86: Test emulator's handling of LEA with /reg
> 
> Sean Christopherson (3):
>    x86: Dedup 32-bit vs. 64-bit ASM_TRY() by stealing kernel's
>      __ASM_SEL()
>    x86: Add helper to detect if forced emulation prefix is available
>    x86/pmu: Run the "emulation" test iff forced emulation is available
> 
>   lib/x86/desc.h    |  52 ++++++++++++++-----
>   x86/emulator.c    | 127 +++++++++++++++++++++++-----------------------
>   x86/pmu.c         |  18 +++----
>   x86/unittests.cfg |   7 ---
>   4 files changed, 110 insertions(+), 94 deletions(-)
> 
> 
> base-commit: a106b30d39425b7afbaa3bbd4aab16fd26d333e7

Queued, thanks.

Paolo

