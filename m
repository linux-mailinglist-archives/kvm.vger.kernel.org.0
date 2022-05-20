Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BADA052EE40
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 16:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350322AbiETOdF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 10:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241428AbiETOdD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 10:33:03 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C434BC6EB;
        Fri, 20 May 2022 07:33:02 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id p26so11046001eds.5;
        Fri, 20 May 2022 07:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=e7/5Mqbg3NKwZvPGrLt+et0ueayqCCb6Fft104EwBxQ=;
        b=qpy+SoavgtKN3D6wO5k65YhCRggP0U9mL9vkT2rjzZjObGNIupjxhPOMaY355u3fVp
         3dOYTij+WbcjZEBCjtrHEd+zR8ii24l/IDytCHVue02zoo5YlZQz+vYuBkdDlJkqvjhy
         WFovyI78Zv5V/US/gQkWR2jXgHHv/v7dn01TLpfNIMMY0LHtal0tDSVlSKgk50HAr17F
         Hd+DbB9mXG1cXHDGAFWEgZyNl6XQyXcWJ9OVvIS6xZXft7ppXlO2llr/7ULWc5/QdC6u
         hDW0nzYbUzrXiI7+4TvXFvw26D7SUUQphlPBPGqgj8f3hMWK/yJdtKC9lVK5KHJE2daC
         FoSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=e7/5Mqbg3NKwZvPGrLt+et0ueayqCCb6Fft104EwBxQ=;
        b=KsjyH0cPKZyqljwc66nTKuSVZPxl+iTYVsoPuThokL8hBNXX6TgdnY8phZb+2ZAQ1S
         sQQmgRqhJqzNzpoB41UT5Ly1S0WBfJrsaicwkN0eNjGMyz8iDPv8Ty40bPCgP9W22IMV
         kP7/7tFwHpLH62qkZmwyP+Ookasfmm6cD3rCTHIJ3IpDcaP5KVvt0PCsou9x8m334Qw+
         p7WDQMM4x1A+erWaIzl6/vLggq4yK+k8S4tCwaZ8yQcrVHSphvTvWB0127pLbGlvAxiw
         lE1qSDCFPRaj+eAy4x5MMpcHhFW1WK1b2oFvmatriu7i6xoKY6NxIhviXHTRZ50V+fcS
         Vn9A==
X-Gm-Message-State: AOAM531L39Qm4coCQMiWB41HNyvgWhxCJNL3m9QXpK2Tcu9pbg0A4SDz
        QRc5ag7vxlF722FV+ewLSodBN0mjArRvIQ==
X-Google-Smtp-Source: ABdhPJxC7Dbtz1fJut5ZrmdxrdrHWkQvRO0tmqmld5lw8eT3A4zMz40DkXbrBuizqJuKw7QXMuMqrA==
X-Received: by 2002:aa7:d8c2:0:b0:42a:b9fa:bad8 with SMTP id k2-20020aa7d8c2000000b0042ab9fabad8mr11506416eds.304.1653057180909;
        Fri, 20 May 2022 07:33:00 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id b24-20020aa7dc18000000b0042617ba63cfsm4306405edu.89.2022.05.20.07.32.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 May 2022 07:33:00 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <06217d85-181d-4b52-724d-cb216c4fe8da@redhat.com>
Date:   Fri, 20 May 2022 16:32:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 3/3] KVM: x86/pmu: Drop redundant-clumsy-asymmetric
 PERFCTR_CORE MSRs handling
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220509102204.62389-1-likexu@tencent.com>
 <20220509102204.62389-3-likexu@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220509102204.62389-3-likexu@tencent.com>
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

On 5/9/22 12:22, Like Xu wrote:
> In commit c51eb52b8f98 ("KVM: x86: Add support for AMD Core Perf Extension
> in guest"), the entry "case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5 " is
> introduced asymmetrically into kvm_get_msr_common(), ignoring the set part.
> 
> The missing guest PERFCTR_CORE cpuid check from the above commit leads to
> the commit c28fa560c5bb ("KVM: x86/vPMU: Forbid reading from MSR_F15H_PERF
> MSRs when guest doesn't have X86_FEATURE_PERFCTR_CORE"), but it simply
> duplicates the default entry at the end of the switch statement explicitly.
> 
> Removing the PERFCTR_CORE MSRs entry in kvm_get_msr_common() thoroughly
> would be more maintainable, as we did for the same group of MSRs in the
> kvm_set_msr_common() at the very beginning when the feature was enabled.

The code and the commit message suggest that some guests are expecting a 
#GP, and complain if they don't get it.

Paolo
