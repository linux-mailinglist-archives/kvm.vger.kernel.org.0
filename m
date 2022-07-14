Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1EDF575352
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 18:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240497AbiGNQrk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 12:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240501AbiGNQrV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 12:47:21 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 459E119039;
        Thu, 14 Jul 2022 09:45:30 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id z23so4435614eju.8;
        Thu, 14 Jul 2022 09:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hhxIWNbzrgE/4mMvH3ENhNTONUeqoY/2MuWDy67vgak=;
        b=JeRIQYogWxTP7m+CyHQWOmmYu9LcGJBf9gdIglPrxd7QCli6YzRtV9SUWnPcaDcUfs
         dtjfW8wjbQNPUNuePp7TDaE+ApuVYMSI2yKVcOMMdShGqwmRJKcfIbSUziOTv41muYIM
         JwFHjRnw3YdHIB/aJbSmn1CiYFLsu3HcC8EhTt4dXCdnSeBkdn6MktdFcxwjPZYFVr8Q
         jvrQc2pHoVLVO29N3o0zZUvRi8oIPfuYV1kfOx0IK1ksOl8lin/Lwb7fYJI8Wk0Av0dC
         JIU9pcuR9EH6ai3CYiGvLjMwiL2KmF6NtjvcWTSdO2RZIOffY7cHrqbSotcKD5KNNLuW
         DXyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hhxIWNbzrgE/4mMvH3ENhNTONUeqoY/2MuWDy67vgak=;
        b=c4I7nqtNI/40zKJP71Pz/AM1LkttcaRo7hO6QqsrkiUfMVeSgKcqShO8vNY9ozKiVG
         7gYTJ3ItcOg5jeSTOzOcfwJ1JyErIq11nROCLbs1tw26aT75bzVg2Nz/rtcDyDDVpzGF
         qZCvyJ5KAzunQIDlUEirYzLl01QzZaYEJWtT/FlZQcfX5HW1tMmzzhORRj0/2FRyi5wU
         NSrPDX9OYSnCwilCutF1v4ypFiAie95dBq6JGDlT1loP2b2d+OBW0n5TUEmJuCpC4/KV
         PhaF4A8HaScGYxrybTyNlgaAgUkJi1isAk6brlwjfPS6xChw5r3d091m/auhc1jhPE24
         jprQ==
X-Gm-Message-State: AJIora/smS1Rh9kG4BuLVBTmwpQP1QBwuseRcT3aXs2UAm2sHDqXDNKh
        cXqcV2ivy35uwm2OHuUOhXBTlJpdsIc=
X-Google-Smtp-Source: AGRyM1tqOzj/60GEr+33fLXoqzb/CRFI3uqNFX7HBU77x45YOmmBmz+qwFRTOZ3e2n3ukqWQe2Q/jw==
X-Received: by 2002:a17:907:2854:b0:72b:8f44:26a3 with SMTP id el20-20020a170907285400b0072b8f4426a3mr9566677ejc.96.1657817128297;
        Thu, 14 Jul 2022 09:45:28 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id t10-20020a05640203ca00b0043a26e3db72sm1341586edw.54.2022.07.14.09.45.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jul 2022 09:45:27 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <bc2c1af3-33ec-d97e-f604-12a991c7cd5e@redhat.com>
Date:   Thu, 14 Jul 2022 18:45:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 0/5] KVM: x86: Clean up rmap zap helpers
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220712015558.1247978-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220712015558.1247978-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/12/22 03:55, Sean Christopherson wrote:
> Clean up the rmap helpers (mostly renames) to yield a more coherent set of
> APIs, and to purge the irritating and inconsistent "rmapp" (p is for pointer)
> nomenclature.
> 
> Patch 1 is a tangentially related fix for a benign bug.
> 
> Sean Christopherson (5):
>    KVM: x86/mmu: Return a u64 (the old SPTE) from
>      mmu_spte_clear_track_bits()
>    KVM: x86/mmu: Rename rmap zap helpers to better show relationships
>    KVM: x86/mmu: Remove underscores from __pte_list_remove()
>    KVM: x86/mmu: Use innermost rmap zap helper when recycling rmaps
>    KVM: x86/mmu: Drop the "p is for pointer" from rmap helpers
> 
>   arch/x86/kvm/mmu/mmu.c | 73 +++++++++++++++++++++---------------------
>   1 file changed, 36 insertions(+), 37 deletions(-)
> 
> 
> base-commit: b9b71f43683ae9d76b0989249607bbe8c9eb6c5c

I'm not sure I dig the ____, I'll take a closer look tomorrow or next 
week since it's dinner time here.

I'm pushing what you and I collected over the past 3 weeks, for now I 
only checked that it compiles.

Paolo
