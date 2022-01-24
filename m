Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45832497C4E
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 10:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234958AbiAXJn5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 04:43:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:24885 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236650AbiAXJn4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Jan 2022 04:43:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643017435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5whi9gy34EzBT6oRXdsnI40HJtniV5XtISLyrn/RpLs=;
        b=XzDW6QfLajExsvnRx+0cRrOKxiT4IA2Ey2bAOKVRhV2CzcOWxCMJuyOgZJFCHOmUQwfet8
        Xvbc+aD9fWxtrQYc9nssMN87nghrtqzzcxrrWMWFX2+yxz1AmL7WoRylebLBBSq3sokGmP
        vz3XEHXSayRLG8Lh/in627A2a9JaIkk=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-295-rkPvXkUGNDex-AURswvF5Q-1; Mon, 24 Jan 2022 04:43:52 -0500
X-MC-Unique: rkPvXkUGNDex-AURswvF5Q-1
Received: by mail-ej1-f69.google.com with SMTP id m21-20020a1709061ed500b006b3003ec50dso1852681ejj.17
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 01:43:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5whi9gy34EzBT6oRXdsnI40HJtniV5XtISLyrn/RpLs=;
        b=s7dOou82+aAbTZ0f3lahULrDoVnVjckRxFrj4cNyWH6vRUXoiGYq0Qz+1AvjNpYe+p
         OJUmAv67rPHPbtazx2utAbCcfCix1HpvLk4RB9GnAtJOU/YRjtPsWBJ4lnNavIjZlpc5
         V04Ofqu5ohGB7VN8ognSMhqXRX6YyMesznJ05NXU4BJ21qRmPbvoLAaptSNw9Nf6mhZ1
         PaT1eSkgusYEazFjVRG4sNTiIPmonnqpSDqVky5BzAGEUSMEWcSV8YSZAIMlQVBkUM/w
         StJT2PpnzkZDILC0ca/d+VtP7QV4vR1mnJbVDFuZIPH7vap9wUlkmefoOiPkbs6fLdy8
         xnGQ==
X-Gm-Message-State: AOAM531nIWsIcLyCftImtYw0uaJDzYOtvInKMxC/ap3db811V8sKPlK3
        c7wsO1WRzv+CIjR/Jhpl+ktvi7vbYs0J6EOZluR2ZAONcP+wbQa83IZh0h7LMr+0WdvDbIIeZs3
        wArR+YaUvy0YK
X-Received: by 2002:a05:6402:354f:: with SMTP id f15mr4093521edd.212.1643017431605;
        Mon, 24 Jan 2022 01:43:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyrbHSLz/9hTpbyF7mWrMWTzXf6TYNvdE6O7WNdnYuPlfpzw9OQ+RpHcZ9j93eeAVLsA5Sprw==
X-Received: by 2002:a05:6402:354f:: with SMTP id f15mr4093514edd.212.1643017431429;
        Mon, 24 Jan 2022 01:43:51 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id j20sm4606280eje.81.2022.01.24.01.43.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 01:43:50 -0800 (PST)
Message-ID: <45a6395e-63f3-12b2-e6d1-52ccf00272e7@redhat.com>
Date:   Mon, 24 Jan 2022 10:43:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] gvisor: add some missing definitions to vmx.h
Content-Language: en-US
To:     Ayush Ranjan <ayushranjan@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ben Gardon <bgardon@google.com>, Jim Mattson <jmattson@google.com>,
        Andrei Vagin <avagin@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Davidson <md@google.com>
References: <20220123195337.509882-1-ayushranjan@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220123195337.509882-1-ayushranjan@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/23/22 20:53, Ayush Ranjan wrote:
> From: Michael Davidson <md@google.com>
> 
> gvisor needs definitions for some additional secondary exec controls.
> 
> Tested: builds
> Signed-off-by: Ayush Ranjan <ayushranjan@google.com>
> Signed-off-by: Michael Davidson <md@google.com>

Incorrect order of the Signed-off-by header (author goes first, 
submitter goes last).

> ---
>   arch/x86/include/asm/vmx.h | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index c77ad687cdf7..df40dc568eb9 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -67,6 +67,7 @@
>   #define SECONDARY_EXEC_ENCLS_EXITING		VMCS_CONTROL_BIT(ENCLS_EXITING)
>   #define SECONDARY_EXEC_RDSEED_EXITING		VMCS_CONTROL_BIT(RDSEED_EXITING)
>   #define SECONDARY_EXEC_ENABLE_PML               VMCS_CONTROL_BIT(PAGE_MOD_LOGGING)
> +#define SECONDARY_EXEC_EPT_VE			VMCS_CONTROL_BIT(EPT_VIOLATION_VE)
>   #define SECONDARY_EXEC_PT_CONCEAL_VMX		VMCS_CONTROL_BIT(PT_CONCEAL_VMX)
>   #define SECONDARY_EXEC_XSAVES			VMCS_CONTROL_BIT(XSAVES)
>   #define SECONDARY_EXEC_MODE_BASED_EPT_EXEC	VMCS_CONTROL_BIT(MODE_BASED_EPT_EXEC)

I'm not sure why gvisor would care about an internal Linux header. 
gvisor should only use arch/x86/include/uapi headers.

Paolo

