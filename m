Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC1D07D69FE
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 13:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233782AbjJYLYq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 07:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbjJYLYp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 07:24:45 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69B6AE8;
        Wed, 25 Oct 2023 04:24:43 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id 98e67ed59e1d1-27d4b280e4eso604856a91.1;
        Wed, 25 Oct 2023 04:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698233083; x=1698837883; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z8Z+tYRzui7BaJuiaZnyDHDcWrbR6sR0khHhdgWMTK0=;
        b=Uogu5R6NiorHh7DCI/9zY4nv8zOLuluoQ0guDV3Ozy46RTj6zOp/EP+vYbK6JDBsg3
         BeI2yJE1IgHX3OHQvwrV9rKPU6dt3Ez/zwifapxw1882oiUr6DLRwpgpmJ28XG5OyVDA
         HZWBagVbnqjc38osyGP/6kVQgG4fKEZXUBTlpYm1vfJxu/uzZQFLFfcu4BkJix1NERqo
         r3MkV691EayVYjeEOh9gdNPkFzBY4iKTxgBPUKNFKAMsCVr6BeLe8bow/4q1eh3tLbil
         RoBPOrwznvEE3OEMv+NCc/Ku/GTRUkJTw++B8rg5NIf6UpeLAz2hL/3x8skCPOQfg6E2
         sDBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698233083; x=1698837883;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z8Z+tYRzui7BaJuiaZnyDHDcWrbR6sR0khHhdgWMTK0=;
        b=p2aUdiaKSqgc/jKil3caX0mSoRw8hHP258N8p6+Qef/IaRzjZ19d/kxRIPO68hcMCF
         Gp4Fu9HVEc0kNifBUMY8urUZSQyzlzzJYK3BPLBcGIO/VAImiWyMdJBuUaZJ1vfjC8j7
         JbnzhGgR806vizM/PNeGEj85z3KMJRkukiCyU91DblX1/AV2/Y2sre4ph4fQOycKzXX/
         z7TuZ7N91yZo2lEH2/he8tpi6fpt7qmDLU6RR9So4x+MthLgTr1h3pk11CsObq4p+AN1
         rPnU93W0mnDC/L/6CVOf+SHxUYOrtbRAF1QaiFDtU6O90S36i4ZjkO5aH2KHjWo4ccRs
         5THQ==
X-Gm-Message-State: AOJu0Yw+uKxbo1uA32f2CK6zpMBFrP+rOy/ESRDw5ySpUyY+lafKmJCI
        Lzlk/urzrokaLuCEp3Jqviw=
X-Google-Smtp-Source: AGHT+IGo7WioyE6T60WElBAE+qqcB9BUrGyOmNrgzD0IHWwguA2y5too62V1ajdxZCs0XWEO+XnjjQ==
X-Received: by 2002:a17:90b:8c:b0:27d:1aa:32b8 with SMTP id bb12-20020a17090b008c00b0027d01aa32b8mr24636071pjb.9.1698233082761;
        Wed, 25 Oct 2023 04:24:42 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id k5-20020a17090a7f0500b00267b38f5e13sm8545467pjl.2.2023.10.25.04.24.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Oct 2023 04:24:42 -0700 (PDT)
Message-ID: <53d7caba-8b00-42ab-849a-d8c8d94aea37@gmail.com>
Date:   Wed, 25 Oct 2023 19:24:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86/xsave: Remove 'return void' expression for 'void
 function'
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
References: <20231007064019.17472-1-likexu@tencent.com>
 <e4d6c6a5030f49f44febf99ba4c7040938c3c483.camel@redhat.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <e4d6c6a5030f49f44febf99ba4c7040938c3c483.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Emm, did we miss this little fix ?

On 11/10/2023 12:12 am, Maxim Levitsky wrote:
> У сб, 2023-10-07 у 14:40 +0800, Like Xu пише:
>> From: Like Xu <likexu@tencent.com>
>>
>> The requested info will be stored in 'guest_xsave->region' referenced by
>> the incoming pointer "struct kvm_xsave *guest_xsave", thus there is no need
>> to explicitly use return void expression for a void function "static void
>> kvm_vcpu_ioctl_x86_get_xsave(...)". The issue is caught with [-Wpedantic].
>>
>> Fixes: 2d287ec65e79 ("x86/fpu: Allow caller to constrain xfeatures when copying to uabi buffer")
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>>   arch/x86/kvm/x86.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index fdb2b0e61c43..2571466a317f 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -5503,8 +5503,8 @@ static void kvm_vcpu_ioctl_x86_get_xsave2(struct kvm_vcpu *vcpu,
>>   static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
>>   					 struct kvm_xsave *guest_xsave)
>>   {
>> -	return kvm_vcpu_ioctl_x86_get_xsave2(vcpu, (void *)guest_xsave->region,
>> -					     sizeof(guest_xsave->region));
>> +	kvm_vcpu_ioctl_x86_get_xsave2(vcpu, (void *)guest_xsave->region,
>> +				      sizeof(guest_xsave->region));
>>   }
>>   
>>   static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
>>
>> base-commit: 86701e115030e020a052216baa942e8547e0b487
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> 
> Best regards,
> 	Maxim Levitsky
> 
