Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F11652ECC6
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 15:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347710AbiETNAE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 09:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236247AbiETNAB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 09:00:01 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0386D169E27;
        Fri, 20 May 2022 06:00:01 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id f9so15567197ejc.0;
        Fri, 20 May 2022 06:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=29WlRMrgqsqkyq2cXG/yY/s3COdSKBJEo/H2xfm8Y7k=;
        b=RNKnYlXb1TsZpVz8ygubB2uyiiRyQvd+Vf3UZWaApaglAYyunwuJQRe+nOa/iDWQBQ
         sQ/AsLAhYqVdmZmB/T9DCV7hiuNaw9hKySBKAzmDqPz22lK3H6BWrV5OgBU1oKyosIF/
         5v6xJYzQX2jVIdS6CYxoAcAvIrOP2gvDsz0yC2RqsskSsOqY8x0abU60+oRUYQu2196k
         t+9AhLQtIY9szFh2vIbT/3d6o8anOQb4YpSjH2XxW3j/QMqxPa0z/EmPg4LjM6B5cyf7
         q70+BLQREtBsL3dmMNld4bE+UDqBScgtJxosA4ipmGMPjYW2fg2TRMT505L+0Ij2fsfu
         8cKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=29WlRMrgqsqkyq2cXG/yY/s3COdSKBJEo/H2xfm8Y7k=;
        b=IO3IQzulad3+y5G91Mkl6lRypSOA69vsR8ijAOmyoLBUelu2SgY7I7VmRkmmEevA/0
         S87EJN6em6A7zIBXHZmNdqtMvukCjW/GWX8qOfH079rLQ7OYuv+MTCUHsug2lP7PKyij
         Et+jcZ04JDiUD46qrioE9QvUcTe7msgGMG9G4RYeiGSbv0J6QnuQaeteJnGxR4ZR6KKN
         prg7rVrNah4WPtT7cnLyPm6lYI35rzLHZo62BuATKzl0M7aE2l9FBe1wMygLyOpCNAqj
         tAl5r7ujrarKxRUz/x5L5BGBIhNPEI/uR/lhiST/0/D0xFLvd/6mFPSvFzec/+FzEXi5
         ItaQ==
X-Gm-Message-State: AOAM53244hzbmbNdDlRa34Ob3G0oB4asuOm75+g/8U5RN1bsTYt/elmy
        urhJ88HDaLUzyw7RwWXwjkE=
X-Google-Smtp-Source: ABdhPJyL/n1KfLo7Nf1z5lBz2l68E4sxuMo89GrxheGeUfKF1v0thfjKcOHe8pm7UkfGE5fn5NiTqg==
X-Received: by 2002:a17:907:e8b:b0:6fe:b76d:bd18 with SMTP id ho11-20020a1709070e8b00b006feb76dbd18mr519965ejc.294.1653051599504;
        Fri, 20 May 2022 05:59:59 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id h24-20020a1709070b1800b006f3ef214e5csm1293345ejl.194.2022.05.20.05.59.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 May 2022 05:59:58 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <3d30f1ac-558f-0ce6-3d46-e223f117899b@redhat.com>
Date:   Fri, 20 May 2022 14:59:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH RESEND v3 11/11] KVM: x86/pmu: Drop amd_event_mapping[] in
 the KVM context
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20220518132512.37864-1-likexu@tencent.com>
 <20220518132512.37864-12-likexu@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220518132512.37864-12-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/18/22 15:25, Like Xu wrote:
> +	if (static_call(kvm_x86_pmu_hw_event_is_unavail)(pmc))
> +		return false;
> +

I think it's clearer to make this positive and also not abbreviate the 
name; that is, hw_event_available.

Apart from patch 3, the series looks good.  I'll probably delay it to 
5.20 so that you can confirm the SRCU issue, but it's queued.

Thanks,

Paolo
