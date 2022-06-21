Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB425532C6
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 15:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351244AbiFUNA7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 09:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350994AbiFUNAl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 09:00:41 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3C72C649;
        Tue, 21 Jun 2022 06:00:03 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id o9so10014703edt.12;
        Tue, 21 Jun 2022 06:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8INa2kPyzcZH9CnKwbMbKSxmSgTkhO3NBae7S1rnzH0=;
        b=BcsQb3hSoUxdwromvNkIlPo20H2WIW07ZuKzSAP+jxxg3wjsoboTyA54fN6c1X//aN
         r9mYAukOItGxApr48zCs3ixk51quGi9PeOddGoakJMvjLOE2o3sGxyf0FzS36lINjV/1
         BDndAbmi0Bj2Mo0oPkvLZLKg7hdQt/gOY6zORp02MxHbNDuaTSm5SoZ34hLngNPfDR7m
         m74DevLtfCxsWh1XOcKQcEv0UWGEzYFMTwkze8lGTKYiGAMW8YmW+kB8I/T7AxMRsjxz
         +aL2/m3ArpUigXD+F14kIWrbGfpLzAyTb4+7yqn74ch5dSFzC0UVDVnufy6pQgqPAlT4
         pteA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8INa2kPyzcZH9CnKwbMbKSxmSgTkhO3NBae7S1rnzH0=;
        b=x+iCawcEQ+C6sMBu8WGdJN7zBseqOmGt27/rzFzGaLex0UuNXbRYwnu7DRjI3kz1eX
         Zqq4q1wbArPU+LFOMoyRo0KHVSckH1YJc2wjHlZA3LRou0lrdRYKu9D5kt/ZqTSs442p
         tweFJ1x6KNjouSy/NMUmwhzpLf1xOTy+s4zOAaG4el8x5ClxPEGYoJT3L1+W9OiyfddL
         Iv6iCutf0s34qfukizHq0txjF0xJ8Xh7Wx9lvoZUd+/gfMyEbXNnGTLQyxxhWRs1QjJJ
         sGyoIkGbUb/IVX+6fTxIfbCnJ/KWd1xn6r7iCnUOLc5zU10xisxCqKsStMPSYyVK6/k3
         WFXQ==
X-Gm-Message-State: AJIora8cDQeO1MiMWY8TAod9M1j7xRts2AQzRLr96p28zmXzBrjiBk4E
        iWy4CyXAb31w3IiTTluvbmY=
X-Google-Smtp-Source: AGRyM1tWDNdc5MQ+KQjo8sIQcgGuNcU5pOGpPXY9E4OF+8Sp9L5OJLj+DKUL/9kMSDxoxfDYnDprEg==
X-Received: by 2002:a05:6402:5c9:b0:420:aac6:257b with SMTP id n9-20020a05640205c900b00420aac6257bmr34865206edx.128.1655816401127;
        Tue, 21 Jun 2022 06:00:01 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id b16-20020a056402351000b0042de8155fa1sm13140776edd.0.2022.06.21.05.59.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jun 2022 06:00:00 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <e22c7352-bafa-3ebf-c842-ed706579a619@redhat.com>
Date:   Tue, 21 Jun 2022 14:59:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v7 17/39] KVM: x86: hyper-v: L2 TLB flush
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220613133922.2875594-1-vkuznets@redhat.com>
 <20220613133922.2875594-18-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220613133922.2875594-18-vkuznets@redhat.com>
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

On 6/13/22 15:39, Vitaly Kuznetsov wrote:
> -	tlb_flush_fifo = kvm_hv_get_tlb_flush_fifo(vcpu);
> +	tlb_flush_fifo = kvm_hv_get_tlb_flush_fifo(vcpu, is_guest_mode(vcpu));
>   

Any reason to add this parameter?  It is always set to 
is_guest_mode(vcpu) and, even if it wasn't, I would add the parameter 
directly in patch 11.

Paolo
