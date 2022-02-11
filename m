Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA6C74B242C
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 12:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349422AbiBKLVY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 06:21:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233695AbiBKLVX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 06:21:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E0483E72
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 03:21:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644578482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mcgICshyxTEM99QbGCGkkiKtT/0wC3VZNERlXjvTdTI=;
        b=dbGkudwMu3ciaABen/jsVHNkX2dnsZFcO+f0nHlAphfxsjNQkSzvMtL4W2oWrc5e6d+UEF
        z+VYGDEuk0gVJXmNnV+SyUwgdFT/BItWqEYVwo/1zzZwTFzTHlG2juUtxEFBQmVlTHnTgJ
        D6VKbrBdJ7V+Lt7JSrx3GO/jkC0fPyg=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-454-w9LnjkEpOEWxA2ErI5OG1A-1; Fri, 11 Feb 2022 06:21:20 -0500
X-MC-Unique: w9LnjkEpOEWxA2ErI5OG1A-1
Received: by mail-ej1-f70.google.com with SMTP id hr36-20020a1709073fa400b006cd2c703959so3950287ejc.14
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 03:21:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mcgICshyxTEM99QbGCGkkiKtT/0wC3VZNERlXjvTdTI=;
        b=DV9ifW2OBUQ6NfEeu5JIZY1E7qfZDYBR1MC3y7RCH+gp+g5s+S5YzEOFKjJ/WeYdfU
         oG5UprqRnpHZ6pt0OHmr5OH/7T+qQgYmWlZJ+WKsPhJ7b3468NYORQmmwP3WztemG5UY
         YZnXDOKH5svraMbVzYNfKE1iA5eX2EtC231M/jxHMNNvDHlWD/Iyvp/N8YOGgWbWxddB
         dnq+C+xrEFVVSw5L0Q6W2grn7xo4hEs4lm8orOWSsB0mwypSJWckMVeN1Y5Ys/e01Vbp
         scPxVUAHtwj9CjWc3lwJHfRuChMDifwu0DUlOYAtsbO88ehqGyCBd3vINzKkeXvBI1cO
         sVuw==
X-Gm-Message-State: AOAM533xQeuZ9/qG7zC3CcQVAruMXKqYBXS3myVSANpq1SGsRPe1PGOk
        BCOHhTHxvkIRfIgZisF81lytdPZDQQRPhFd5jTOGXhGLR3qBeU3xXlYy4riheA6pXF4VCPdY8mC
        M5M+hNTm3uYmu
X-Received: by 2002:a05:6402:515a:: with SMTP id n26mr1316480edd.191.1644578479770;
        Fri, 11 Feb 2022 03:21:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx03m4GZECfPSlFPtgmNIhReLUsyNrSICW1a0Ijl/jprKKjCAXNif6CBbh2k7C1sRiesa5wZQ==
X-Received: by 2002:a05:6402:515a:: with SMTP id n26mr1316459edd.191.1644578479546;
        Fri, 11 Feb 2022 03:21:19 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id qh12sm4389384ejb.172.2022.02.11.03.21.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Feb 2022 03:21:19 -0800 (PST)
Message-ID: <18042cd3-c1fe-a54a-8682-2b5d1523c3d9@redhat.com>
Date:   Fri, 11 Feb 2022 12:21:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 05/12] KVM: MMU: avoid NULL-pointer dereference on page
 freeing bugs
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, mlevitsk@redhat.com, dmatlack@google.com
References: <20220209170020.1775368-1-pbonzini@redhat.com>
 <20220209170020.1775368-6-pbonzini@redhat.com> <YgWsoKskWnahgR8j@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YgWsoKskWnahgR8j@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/11/22 01:24, Sean Christopherson wrote:
>>   
>>   	sp = to_shadow_page(*root_hpa & PT64_BASE_ADDR_MASK);
>> +	if (WARN_ON(!sp))
>
> Should this be KVM_BUG_ON()?  I.e. when you triggered these, would continuing on
> potentially corrupt guest data, or was it truly benign-ish?

It only triggered on the mode_switch SVM unit test (with npt=0); so, in 
a very small test which just hung after the bug.  The WARN however was 
the 10-minute difference between rmmod and reboot...

I didn't use KVM_BUG_ON because we're in a pretty deep call stack 
(kvm_mmu_new_pgd, itself called from nested vmentry) and all sort of 
stuff will happen before bailing out.  My mental model is to use 
KVM_BUG_ON in situations for which error propagation is possible and clean.

Paolo

