Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCEC33F0F1
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 14:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhCQNPn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 09:15:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50852 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230353AbhCQNPO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Mar 2021 09:15:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615986913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XZJdEeunzwNk70+oFRPGk8WEPnwuyPe914Z6NlRRz+8=;
        b=StAz4J2yULTMyaIAY5Wex22ZucLBmA/GthuW6PJqjGE1tfaIyADS3MN2B1WEqRnPg6lQV7
        FqJtmdBOIven453idk/oRdARZkYsQGaqNN7MzpRoOOTjTlPWnRKCZoixg4iRhQULZQkKrf
        J3lESdgQnsfMvI8pUoaZXH6fpSuHXAg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-THCrTRb8NZ2TxNgGwV0f_g-1; Wed, 17 Mar 2021 09:15:11 -0400
X-MC-Unique: THCrTRb8NZ2TxNgGwV0f_g-1
Received: by mail-wm1-f70.google.com with SMTP id b20so4998071wmj.3
        for <kvm@vger.kernel.org>; Wed, 17 Mar 2021 06:15:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XZJdEeunzwNk70+oFRPGk8WEPnwuyPe914Z6NlRRz+8=;
        b=p4Bi76r5lLpgqE9x8SehhNx6lz/QmcxHs1r743jxlzCKC5GUIfAzvcw9N6fM2o8+AQ
         biyRAzJg6n4FEW4FxgoH60eENChSnY7IalzYZLaQXdB2tojNGrZVV73V0wzHLzttpHUX
         +pP0p8cPR5uiPaGRGNwmRKOKDdSnp3U6Qr+gxu4M1kwmPN+dKi0iQUSgWkVcWDg0Vopi
         VY5z6mV3c/Iso1ga5Ka9HDDwZVJCzdY648FtiSuQW4gCCtzqRAxIFgjjvWpAijuscs2V
         dLPxJpWQE/X4Hio4sUVD4X0OB478PmfPCNn6G3HRJrY7eOfqcxDraDzdRgut4Hr7nZgi
         SOPw==
X-Gm-Message-State: AOAM532A+MBQbwnPWwr8MfptQJxCXruzntt8FnpLg8p5u9ckrMmgQjw+
        5DMxt+qe3reD11w9k6Rw0BvuDQbjRQ8OdM2uDR/r3z2zAuW0cyIfkp+2Wt5gHUy1Nr0CfJiPGE+
        JVDQp7p8acYnh
X-Received: by 2002:adf:fac1:: with SMTP id a1mr4576711wrs.98.1615986909596;
        Wed, 17 Mar 2021 06:15:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyZ2dfEsieu9J241DYA3s8c2or2c3fDFAPaeacFxyxanimtAaKIxHG7SAHnH2UL0oytvdAGIA==
X-Received: by 2002:adf:fac1:: with SMTP id a1mr4576689wrs.98.1615986909373;
        Wed, 17 Mar 2021 06:15:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x8sm25487700wru.46.2021.03.17.06.15.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Mar 2021 06:15:08 -0700 (PDT)
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Graf <graf@amazon.com>,
        Yuan Yao <yaoyuan0329os@gmail.com>
References: <20210316184436.2544875-1-seanjc@google.com>
 <20210316184436.2544875-4-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 3/4] KVM: VMX: Macrofy the MSR bitmap getters and setters
Message-ID: <f4934b3e-4d5f-a242-e14f-ad5841079349@redhat.com>
Date:   Wed, 17 Mar 2021 14:15:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210316184436.2544875-4-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/03/21 19:44, Sean Christopherson wrote:
> +	return (ret)true;						      \

I'm not sure if (void)true is amazing or disgusting, but anyway...

> +BUILD_VMX_MSR_BITMAP_HELPER(bool, test, read)
> +BUILD_VMX_MSR_BITMAP_HELPER(bool, test, write)
> +BUILD_VMX_MSR_BITMAP_HELPER(void, clear, read, __)
> +BUILD_VMX_MSR_BITMAP_HELPER(void, clear, write, __)
> +BUILD_VMX_MSR_BITMAP_HELPER(void, set, read, __)
> +BUILD_VMX_MSR_BITMAP_HELPER(void, set, write, __)

... I guess we have an armed truce where you let me do my bit 
manipulation magic and I let you do your macro magic.

Still, I think gluing the variadic arguments with ## is a bit too much. 
  This would be slightly less mysterious:

+BUILD_VMX_MSR_BITMAP_HELPER(bool, vmx_test_msr_bitmap_, read, test_bit)
+BUILD_VMX_MSR_BITMAP_HELPER(bool, vmx_test_msr_bitmap_, write, test_bit)
+BUILD_VMX_MSR_BITMAP_HELPER(void, vmx_clear_msr_bitmap_, read, __clear_bit)
+BUILD_VMX_MSR_BITMAP_HELPER(void, vmx_clear_msr_bitmap_, write, 
__clear_bit)
+BUILD_VMX_MSR_BITMAP_HELPER(void, vmx_set_msr_bitmap_, read, __set_bit)
+BUILD_VMX_MSR_BITMAP_HELPER(void, vmx_set_msr_bitmap_, write, __set_bit)

And I also wonder if we really need to expand all six functions one at a 
time.  You could remove the third argument and VMX_MSR_BITMAP_BASE_*, at 
the cost of expanding the inline functions' body twice in 
BUILD_VMX_MSR_BITMAP_HELPER.

Thanks,

Paolo

