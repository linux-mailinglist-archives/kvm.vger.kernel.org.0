Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 954F058AB9C
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 15:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238148AbiHEN2R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 09:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236071AbiHEN2Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 09:28:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 33EA924F2D
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 06:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659706095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fRbt4fpz05nevLDfsfu7iCvaJBx1mn8My8tX2QVvnwc=;
        b=R+d5nLzhA5rVvBJgQCLvfiq+FOP44gXNlOa2KCqxdgLXzPtcbvQcBD7lcqAV7fKRXLCG+B
        0J6rX7iPbq3Rozw0wTgCqQDcuHWoVj9wArEivDGRDFIYvQwLA07CPYe0ODU3/o4KOuhqSY
        jv7PE1DzYXZXKzvDfIRa9TORlz5zopo=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-79-GZBGi0Z6P2qPg1BKRwOb0g-1; Fri, 05 Aug 2022 09:28:14 -0400
X-MC-Unique: GZBGi0Z6P2qPg1BKRwOb0g-1
Received: by mail-ed1-f70.google.com with SMTP id z6-20020a05640240c600b0043e1d52fd98so1612035edb.22
        for <kvm@vger.kernel.org>; Fri, 05 Aug 2022 06:28:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=fRbt4fpz05nevLDfsfu7iCvaJBx1mn8My8tX2QVvnwc=;
        b=fAAlSTQjLlr+pWO5yRq+GigTbN63bulKhFThKB2kyhhNjZoetF5C4K2i/tQmGzBLw0
         vJ3M7MNBpoq5aYS8R8dw6C7sFpIg/8KlObeBPkOxnSPTWrJzcU5ooZuSiNN5Hlgz6sW/
         hIP2muPl1V4UaizAaU8NpC607augerRVCtKRqCTJh4EOLp8w2SCy5/8jj6kHSi6aKVTM
         Ayx4cWgQCpsOqfei5UgjDRog47KHoP7WuvzKfngAXiNHrIEic5nPd8oIohy3SVhpK13Z
         gDj47zv26A09Hzl537/5aPncrJTY3WCudD61cIrsKovbWlzkpYDGzIKzr14q0r1rzwBe
         Jnog==
X-Gm-Message-State: ACgBeo0c/Nfc1IH68VyCCdQ66BPiHHus63aURq8KbHIQaTRtJV8xrBMc
        QmCEtj68yWFQqK8ed8/YFgabAYcv/FzdvsyKqqlkXWuSr5Oe8QckKJoF0KL72Yc2OD4IUSg0e5g
        FR5srcG2Jg30M
X-Received: by 2002:a17:907:2848:b0:730:cab8:3ce5 with SMTP id el8-20020a170907284800b00730cab83ce5mr5338387ejc.718.1659706093044;
        Fri, 05 Aug 2022 06:28:13 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5xldLLLvz8qg5b+ssfHI2sHLwEBkwCJ0KlFDFJBUJnjmXsAKS3ftTvCFr7Pt3NCXHMJWtXgw==
X-Received: by 2002:a17:907:2848:b0:730:cab8:3ce5 with SMTP id el8-20020a170907284800b00730cab83ce5mr5338380ejc.718.1659706092872;
        Fri, 05 Aug 2022 06:28:12 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id lb6-20020a170907784600b0072b13ac9ca3sm1565446ejc.183.2022.08.05.06.28.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Aug 2022 06:28:12 -0700 (PDT)
Message-ID: <fbc62d04-bcff-d8e9-02b1-cf3510f80866@redhat.com>
Date:   Fri, 5 Aug 2022 15:28:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org
Cc:     Anup Patel <anup@brainfault.org>
References: <20220805130256.683070-1-ajones@ventanamicro.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] RISC-V: KVM: Fix compile after merge
In-Reply-To: <20220805130256.683070-1-ajones@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/5/22 15:02, Andrew Jones wrote:
> The compiler usually complains that we've forgotten to dot our i's and
> cross our t's, but this time it was complaining that we dotted our
> commas. Undot the commas (a.k.a change ; to ,) to restore compilation.
> 
> Applies to kvm/queue.
> 
> Fixes: 24688433d2ef ("Merge remote-tracking branch 'kvm/next' into kvm-next-5.20")
> Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>   arch/riscv/kvm/mmu.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index f9edfe31656c..3a35b2d95697 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -352,8 +352,8 @@ int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
>   	unsigned long pfn;
>   	phys_addr_t addr, end;
>   	struct kvm_mmu_memory_cache pcache = {
> -		.gfp_custom = (in_atomic) ? GFP_ATOMIC | __GFP_ACCOUNT : 0;
> -		.gfp_zero = __GFP_ZERO;
> +		.gfp_custom = (in_atomic) ? GFP_ATOMIC | __GFP_ACCOUNT : 0,
> +		.gfp_zero = __GFP_ZERO,
>   	};
>   
>   	end = (gpa + size + PAGE_SIZE - 1) & PAGE_MASK;

Hi, this is already fixed in Linus's tree.  I will rebase kvm/queue soon.

Paolo

