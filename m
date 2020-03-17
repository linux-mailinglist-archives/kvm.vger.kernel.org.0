Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9896187B5A
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 09:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbgCQIdl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 04:33:41 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:41722 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725870AbgCQIdl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Mar 2020 04:33:41 -0400
X-Greylist: delayed 374 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Mar 2020 04:33:40 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584434019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=foL6JJOYZrFK3mSnjY6WUeWsSQCHtrDfHzZTVEx4CZc=;
        b=LAr2du4uzQ4PaTkoxzLpOxTBhCapU7UWAtXES01nxCukiCVDcmUWpO01zGaX99CmGkYUmn
        Kh2JaiNjsRkMDXeQbrRBtOHQ/ZWHWE+pYYhUAFN8JS4gCz7UiNODuDewZEXgRHgz3fTAr4
        zxaan2alxa7W9tXF5dhmPcTnysLvZOE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-W1-dEQ1yMNKq8nAsEB0fMw-1; Tue, 17 Mar 2020 04:27:23 -0400
X-MC-Unique: W1-dEQ1yMNKq8nAsEB0fMw-1
Received: by mail-wm1-f72.google.com with SMTP id g26so5431762wmk.6
        for <kvm@vger.kernel.org>; Tue, 17 Mar 2020 01:27:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=foL6JJOYZrFK3mSnjY6WUeWsSQCHtrDfHzZTVEx4CZc=;
        b=m7uyIIsAp6SBqF0lEtVM+xyErzx6Ya/j4ajVLQJ2zmcf1cXIV80dPmiqQLdxeRoT+W
         C5F4unaNz8g4MWgq1sViu4DRyjhDMB7Ofh/htyWYzZzwnv17ApfkyeOrj5O+BDdV34tW
         QXpELaHHOV2IPQYEbf8lJ7gHCrxOqYeH4Xxcg6TWJySEpJCqXE1ZasxpnPs2JhVlBQLI
         7HD5TpUiCA8dJO1bPAP3ofy3RLpJTfZpeQkgtplHM/ZA/1QzNd7aytZFcfxDTaleGB7H
         QkTlQKiaQmg0JenEBMCqssMt79v4/PzHnWOQBCWYBTuSkT/geAlKO2Z9spseqp/BQ3ej
         6Jxw==
X-Gm-Message-State: ANhLgQ38kO0+faWUvBwSA6foQtoXpDOhVnr8TkYmO3lhkVluQxfTE8Iz
        419KSvULygLdR4dGp8h+t16poqnxmDDy6UdMrrhB6vXd64wFUGedwGd+66GX22+4dqMCapTe7h+
        EHfZZBwxm4Zhx
X-Received: by 2002:adf:f8cf:: with SMTP id f15mr4550928wrq.79.1584433642581;
        Tue, 17 Mar 2020 01:27:22 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtzsfYZvt8nfYEYXfZXarAl3GIPsJCUzStTnjN3KlFioXLSxKAYt9rYm3Jvv7s4DtIWPmCwQQ==
X-Received: by 2002:adf:f8cf:: with SMTP id f15mr4550890wrq.79.1584433642260;
        Tue, 17 Mar 2020 01:27:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:24d8:ed40:c82a:8a01? ([2001:b07:6468:f312:24d8:ed40:c82a:8a01])
        by smtp.gmail.com with ESMTPSA id t5sm2922781wmi.34.2020.03.17.01.27.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Mar 2020 01:27:21 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: Expose AVX512 VP2INTERSECT in cpuid for TGL
To:     Zhenyu Wang <zhenyuw@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Zhong, Yang" <yang.zhong@intel.com>
References: <20200317065553.64790-1-zhenyuw@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dcc9899c-f5af-9a4f-3ac2-f37fd8b930f7@redhat.com>
Date:   Tue, 17 Mar 2020 09:27:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200317065553.64790-1-zhenyuw@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/03/20 07:55, Zhenyu Wang wrote:
> On Tigerlake new AVX512 VP2INTERSECT feature is available.
> This would expose it for KVM supported cpuid.
> 
> Cc: "Zhong, Yang" <yang.zhong@intel.com>
> Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index b1c469446b07..b4e25ff6ab0a 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -374,7 +374,7 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
>  	const u32 kvm_cpuid_7_0_edx_x86_features =
>  		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
>  		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
> -		F(MD_CLEAR);
> +		F(MD_CLEAR) | F(AVX512_VP2INTERSECT);
>  
>  	/* cpuid 7.1.eax */
>  	const u32 kvm_cpuid_7_1_eax_x86_features =
> 

Hi Zhenyu,

please rebase - the CPUID mechanism is completely rewritten in kvm/queue.

Thanks,

Paolo

