Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC92752EEEE
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 17:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240572AbiETPUn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 11:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234738AbiETPUl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 11:20:41 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F791778B7;
        Fri, 20 May 2022 08:20:40 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id wh22so16073391ejb.7;
        Fri, 20 May 2022 08:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9HTaK+V9ZiDiK1i2vlbbpCkD2/xh0tAla8E3HggozQY=;
        b=BSRx5Z5tm6wPBmbRw+L6iv01M0mxWLakRDU1Fshi/8cmtyCW4nFYuwEkMsA0aB97EE
         FzB+3peMTk26SJTMrCkSv+puJddtXwM49ZIGWCdN1QxR8e3yej/b+YWFD/vRUDx+9i66
         NkLXYs7UkS+pZRRO6RoCHTqrMkTXw+ZJFF9LcIIMAJQKcl6EflIjSQmReXIL9z5bXlzP
         0txnvAar7jb+VjuGOAfsOayrcNl0Hdc5lUCUY9yIVu9+gnuvSVSmBcbuckSY5D8rCjsD
         llXpQSG0MsUA90jGpHxJV6lDBM7Oxi8LCSuJVwU2jpCeTzac+6MHNZp0yVUMj7MX9AsP
         d73w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9HTaK+V9ZiDiK1i2vlbbpCkD2/xh0tAla8E3HggozQY=;
        b=nKU48s+NGaM29ugH3B2XfgI4QFW4qOE9KT/+pDFUIlK/NqukBs2gaSgXajFstF2DO1
         668dR2U+O27etDu4VFpWKy5UFqG0hNg5ck1DtEYIXMzbssyXnLTcyCd91vBfmeHOa3rC
         GgAkkIJ2pbjgSCT9lgVVSd5dfqLEiKuMEtBOVbeOzJ1RMYCZ98XUjKMfGJn4IOTpP9Xw
         L3EZ1L7BZ9m55gfMR7S8T8mAaEPVqgl41f5ZiTfm0EQEM2JHDONBWSj/PPMDvIp0WT9B
         09Ws7fS63n/1gPlNmvlP72VVx3fOWPIUdcyjuhfOjZPUhYVQ1gf0V/LnFeghOmIZIWZs
         35Cg==
X-Gm-Message-State: AOAM532kEgJA6nSRP5bJjpFOg/lVMIFM/niWT7JgEGm0JUKBcc3JKnqh
        UNvO7c50ZSbf5sMEHQV7dnQ=
X-Google-Smtp-Source: ABdhPJwSFrnTnzwIxD4CF5hQegGI00d/gtJIbpbGQ9sMCHRp8qU0jBb9OAfnyXhm0w5TWxxsrDX48A==
X-Received: by 2002:a17:907:6d8a:b0:6fe:1b36:dfcc with SMTP id sb10-20020a1709076d8a00b006fe1b36dfccmr9038948ejc.579.1653060039247;
        Fri, 20 May 2022 08:20:39 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id el22-20020a170907285600b006f3ef214e57sm3203545ejc.189.2022.05.20.08.20.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 May 2022 08:20:38 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <d54216c8-e936-1ee4-8280-ae5e2b5f0ba7@redhat.com>
Date:   Fri, 20 May 2022 17:20:37 +0200
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
 <3d30f1ac-558f-0ce6-3d46-e223f117899b@redhat.com>
 <6b30a3bc-9509-d506-4f81-2db0baeedad2@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <6b30a3bc-9509-d506-4f81-2db0baeedad2@gmail.com>
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

On 5/20/22 16:27, Like Xu wrote:
> 
>> 
>> Apart from patch 3, the series looks good.  I'll probably delay it
>> to 5.20 so that you can confirm the SRCU issue, but it's queued.
> 
> I have checked it's protected under srcu_read_lock/unlock() for
> existing usages, so did JimM.
> 
> TBH, patch 3 is only inspired by the fact why the protection against
>  kvm->arch.msr_filter does not appear for kvm->arch.pmu_event_filter,
> and my limited searching scope has not yet confirmed whether it
> prevents the same spider.

Ok, I'll drop it.

Paolo
