Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A2341611E
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 16:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241666AbhIWOiG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 10:38:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46044 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241605AbhIWOiG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Sep 2021 10:38:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632407794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tM3g7fUHbsu5UDZIXRUIRPhWsRqGb+aH3IjlBpgEGsU=;
        b=VqRhG2tC0TwluiuLGMRhbvsdRyJvCJ6wYtsfsJe8SJcLFbmYQ2uW2bgSPaEQ/PYLtHdlMM
        fytT326rLAd/K7XELk4/R7X/OoJaEKLo2qe8wbrB0RxVklQoSMdLwOWrSrKKogOKWUQnbD
        oXUXcS3mxeGk6qswZ3EHIv0ydodYafg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-593-TpdOc-n8Pk6UOw-vhok0Jg-1; Thu, 23 Sep 2021 10:36:33 -0400
X-MC-Unique: TpdOc-n8Pk6UOw-vhok0Jg-1
Received: by mail-wr1-f72.google.com with SMTP id f7-20020a5d50c7000000b0015e288741a4so5317558wrt.9
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 07:36:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tM3g7fUHbsu5UDZIXRUIRPhWsRqGb+aH3IjlBpgEGsU=;
        b=56VjqeCN8uiA6g47EEaqSGaP3io0mNznl0wg7yxDRjgaxM/q48uA2nH8AL6LL96c93
         8Dh6OeYSENkqTVEyP/0M01t5IZB003HTmH+k9ArLRgHwO/vhF423AibTlEyq7Y6Uwemg
         DtW/dqeeI3Zhegvw8cyJDgU6VDh8u2tAQtVqcLOolJYyh0nt+odGZBeW0KqLpSs3B87Y
         Q9wk8mVrQO1ZuzDWLuj+ZVGrH7wIcAeXGNwvlqtV2b9Qv1OrWyQPiqOm/f4pGaCH6OcD
         pTYatHxRmjwNMm8KLwKYmxsdF/7WpCnKHDEHoSoLMI7vCtggoN0+QmIO4WtQIaeuc/rm
         toKA==
X-Gm-Message-State: AOAM533FSYiU+8ZK5PA1odcGiyw5dS4xZqo7+IQxOMZ5BHAieN1dO8CI
        U5yoxVBX1uoFEZ3pZHOUuvQd294jwM2jHw70vI9PNtrfmknEszJeL/ZDHZmi0y2JhX9//tk+KlX
        LEkRj8K+JAgX06epSfD725pyBZcdKGV/5gDw1WdiGmUer2RoRUFPLLQhIx6i4p+xP
X-Received: by 2002:a5d:568a:: with SMTP id f10mr5484180wrv.314.1632407791718;
        Thu, 23 Sep 2021 07:36:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzI7VO+gl5FNNX2Qjt40hO60rJs1kdwuEagO0synF/stcFYOiwV4VSXa+cDxEnaUvFMYPBXcA==
X-Received: by 2002:a5d:568a:: with SMTP id f10mr5484141wrv.314.1632407791497;
        Thu, 23 Sep 2021 07:36:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id c9sm3493853wmb.41.2021.09.23.07.36.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Sep 2021 07:36:30 -0700 (PDT)
Subject: Re: [PATCH V2 02/10] KVM: X86: Synchronize the shadow pagetable
 before link it
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org
References: <20210918005636.3675-1-jiangshanlai@gmail.com>
 <20210918005636.3675-3-jiangshanlai@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <40f67a70-5076-3806-1ec7-a4ac50d13774@redhat.com>
Date:   Thu, 23 Sep 2021 16:36:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210918005636.3675-3-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/09/21 02:56, Lai Jiangshan wrote:
> +			 * It also makes KVM_REQ_MMU_SYNC request if the @sp
> +			 * is linked on a different addr to expedite it.
> +			 */
> +			if (sp->unsync_children &&
> +			    mmu_sync_children(vcpu, sp, false)) {
> +				kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
> +				return RET_PF_RETRY;
> +			}
>   		}

I think we can put the sync in mmu_sync_children:

-			if (!can_yield)
+			if (!can_yield) {
+				/*
+				 * Some progress has been made so the caller
+				 * can simply retry, but we can expedite the
+				 * process by forcing a sync to happen.
+				 */
+				kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
  				return -EINTR;
+			}

Paolo

