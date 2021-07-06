Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58BBA3BD8E6
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 16:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbhGFOvC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 10:51:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44765 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232441AbhGFOu7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 10:50:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625582900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dyv/6mgjNNKYtygPJuI6vJBV8Q4XF1LGAO51hVfQGwE=;
        b=ePOrNCv3HoIbF6+kN3erOAToDSsbNHCrVYdbFbYQTbJoAhjK3uAmulD7KfNQeAsNA5TBKZ
        TZioa2mcSmAHaEmzBYEsgPHXI+o0+QzHhh1S2Y9pV2PRgTNA3XibwpZtOZx0qp5Ueb2o3r
        IbmPnaSBea+vtcf41XnIuGTu6QxjNK8=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-569-CnY5hTuPOCyBUqlTXpyl_w-1; Tue, 06 Jul 2021 10:48:19 -0400
X-MC-Unique: CnY5hTuPOCyBUqlTXpyl_w-1
Received: by mail-lf1-f69.google.com with SMTP id o16-20020a0565120510b029032f0b0fc9f1so5346857lfb.23
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 07:48:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dyv/6mgjNNKYtygPJuI6vJBV8Q4XF1LGAO51hVfQGwE=;
        b=X72G/HRFp+5CpTx+hFfKyk1CP625RgrdRCkVRi6J1+/1Nnr0FIsGVQtYer9dPuSWzV
         9qUJl8RA3gLOCPEpXwZR6MtAAUF64kOliT7Ycq1ti/QLmPMGDGivHpWPizyEQXpGHey/
         b6nRRZPzLDRg53KrFLkckbxVmPJPQaGw83l5DEM2ZbkLJtXW8L/9J+9/H5KjyiQQEKhc
         NIxBXIbnvJ4jOBa0nwiuFyi0Zc8nV4MAHhQwiBbwdI3KmLTzG5hJRmNPq8u0OJca1oIi
         7Y9fw1nwt9+GLsUbVylwPkrDI1kTmwAOMnsFYNMlL9MArifum0JawU5MNhvgHY12e+AH
         rzSQ==
X-Gm-Message-State: AOAM532rAPidh6eSj/EaVGVEYxZ/4wpt1OpSKTxybAVZOfbdpJ+DOin5
        o0PGWCUUIWMqsKbkl5v6eflorims0u/+ok5YuxFo0bu+YVoCtuM40V7yo7ES8sj1Jz0NfO6tHCK
        6xzyYBNxu/tfr
X-Received: by 2002:a17:907:7b9b:: with SMTP id ne27mr7623794ejc.318.1625582481338;
        Tue, 06 Jul 2021 07:41:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzZjvghyeB5q5KFlIBdTd3M1i6Cs8EjflinMcoeMLrkZQJ5IYpZgPqOp0uSqXUoAAMsURWsrA==
X-Received: by 2002:a17:907:7b9b:: with SMTP id ne27mr7623773ejc.318.1625582481104;
        Tue, 06 Jul 2021 07:41:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id t6sm7263654edd.3.2021.07.06.07.41.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 07:41:19 -0700 (PDT)
Subject: Re: [RFC PATCH v2 39/69] KVM: x86: Add guest_supported_xss placholder
To:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <3bcd7285a0cb15974fdb0e8f81b61143a360f4a5.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <469f9f3d-bf51-1c79-1139-c4ccad4b7b89@redhat.com>
Date:   Tue, 6 Jul 2021 16:41:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <3bcd7285a0cb15974fdb0e8f81b61143a360f4a5.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Add a per-vcpu placeholder for the support XSS of the guest so that the
> TDX configuration code doesn't need to hack in manual computation of the
> supported XSS.  KVM XSS enabling is currently being upstreamed, i.e.
> guest_supported_xss will no longer be a placeholder by the time TDX is
> ready for upstreaming (hopefully).
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 7822b531a5e2..c641654307c6 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -656,6 +656,7 @@ struct kvm_vcpu_arch {
>   
>   	u64 xcr0;
>   	u64 guest_supported_xcr0;
> +	u64 guest_supported_xss;
>   
>   	struct kvm_pio_request pio;
>   	void *pio_data;
> 

Please remove guest_supported_xss from patch 66 for now, instead.

Paolo

