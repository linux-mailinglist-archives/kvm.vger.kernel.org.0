Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5309913CBAD
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 19:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729205AbgAOSId (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 13:08:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21180 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728992AbgAOSId (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 13:08:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579111712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w5ayVeHtywtAZ8iHKxphL0A5R/B7E3CKCfl0+VtoYVo=;
        b=Q7Wxsgoa0dx2JjuBDh/XWXW4uHqUBAeCS8YtG7ZiU0A5iorGHueta/vvmCVIkTq/gL04gm
        PeLHFXzzAtVAXLlU7gJX0F23QmKmBMmJpt594tf3i7PUmw3tMkMTKBCbJM1MMROQhc+Hfk
        ZgiytvQXgqPdOC6tSNeYQT/vs9mOmNE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-TCWTh-ODPcORlTrAqKNVVg-1; Wed, 15 Jan 2020 13:08:28 -0500
X-MC-Unique: TCWTh-ODPcORlTrAqKNVVg-1
Received: by mail-wr1-f72.google.com with SMTP id u18so8252156wrn.11
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2020 10:08:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w5ayVeHtywtAZ8iHKxphL0A5R/B7E3CKCfl0+VtoYVo=;
        b=DABGCeKQ/A8yNwiwiDb9ldHwg71nFLHmtr5QcbvvbUo0fAn4oIVVzFmsb5hVC7SX1I
         J16SEoO2a1eGgi2VFVbCfyrFtMHX5pBSUR/g5mqx56RCpxp5rTfQyXL58F38V7LYvyVE
         B/7+j41a2YwBj//x9LNxWz7cJxE1ZYhNkEBTymtvNAliRry6y0WFnprj4zykl17WiKPO
         ECJzdT5TFbKC0V2zc2l38UykS4xEjmd0ZmuoRjKJZxGJ3pjsbhkQ1PIbBcyUlnzVXOKO
         pQuRvjQZhswRLUNmF3o7oMoToxcayAFNdNeBIUtD/0sTM5YhN0TR/HYEhVTV95tWCDMv
         0sew==
X-Gm-Message-State: APjAAAV9J78/pODN8adVKn1vT2W0JyfSmCzM5xF75QEbFsJx14EtUHYl
        HhjHGqOYL5HbFcW+3hafdIVkdVxkTfuundKbqD0ZtaZ2MIFOlw8WnrP6SVG0rYbQEtxY/5r+GWl
        /quDcehASSPjj
X-Received: by 2002:a05:600c:210e:: with SMTP id u14mr1262244wml.28.1579111707653;
        Wed, 15 Jan 2020 10:08:27 -0800 (PST)
X-Google-Smtp-Source: APXvYqzudxSmFCpQ2b8K45MRgV8cH5Fw/TvUv/MQE62HNDVPvCAdHeh4gxH3ZU9jiHwRIX4eZ9tpLg==
X-Received: by 2002:a05:600c:210e:: with SMTP id u14mr1262215wml.28.1579111707469;
        Wed, 15 Jan 2020 10:08:27 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:436:e17d:1fd9:d92a? ([2001:b07:6468:f312:436:e17d:1fd9:d92a])
        by smtp.gmail.com with ESMTPSA id a1sm822476wmj.40.2020.01.15.10.08.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2020 10:08:26 -0800 (PST)
Subject: Re: [PATCH] KVM: vmx: delete meaningless
 nested_vmx_prepare_msr_bitmap() declaration
To:     linmiaohe <linmiaohe@huawei.com>, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
References: <1576306125-18843-1-git-send-email-linmiaohe@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5b52df53-33a5-f7f9-fb1d-6de3abd2c695@redhat.com>
Date:   Wed, 15 Jan 2020 19:08:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1576306125-18843-1-git-send-email-linmiaohe@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/12/19 07:48, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> The function nested_vmx_prepare_msr_bitmap() declaration is below its
> implementation. So this is meaningless and should be removed.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 63ab49de324d..e038a331583c 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3048,9 +3048,6 @@ static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> -static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
> -						 struct vmcs12 *vmcs12);
> -
>  static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
>  {
>  	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
> 

Queued, thanks.

Paolo

