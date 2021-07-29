Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 336823DA811
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 17:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238255AbhG2P5L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 11:57:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30103 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238189AbhG2P5E (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Jul 2021 11:57:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627574220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OdUOSn5PsAyIvz/45Ktqnl2uzGhZFKajWTR316l3Z74=;
        b=bbYtjcoVmU0+FlbJLtmEyn6TMFNDohk9VltIOKevd97vynQdS8iTSoDh7C+OjM1O4fmYoo
        3IkpSoFOAj7aeFPfs+zr4GuiGrVC9sb1h/7SeuMXWPaWvWUqOrByW+sazYDC/56yDNMCFG
        PjijuN8OOA6lUHNc6WweUmJC0kUsuzo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-577-f2s-bEpxPrWERNCQ25pnSQ-1; Thu, 29 Jul 2021 11:56:59 -0400
X-MC-Unique: f2s-bEpxPrWERNCQ25pnSQ-1
Received: by mail-wm1-f70.google.com with SMTP id l12-20020a05600c1d0cb029024e389bb7f1so1940500wms.0
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 08:56:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OdUOSn5PsAyIvz/45Ktqnl2uzGhZFKajWTR316l3Z74=;
        b=afzSqMVjtBxykbgaQnsyRfk2hs9lvVOk/uq1DREPg7UWpDDXXh0zDmGWbx7mwR80t0
         VXBQOveoF9tJaNoRkKGfATOCobmRbDr/UjzrPzEqxPhw4QxseAGQdE7urTr64TaQTV5V
         Xd8kD2fuPtsw/KB4jdxJk3DBleREXv1qyknrn/1ysleWjczhXTd+fmVugl+Uo2V1pl2d
         5zxGTYbU5t2hJtITDWmKpcdxJCwQ8a7k4RUhi68o9jza5AjqJXUlxVS0aSDDO6OgENXC
         zH3OJQMCL/sVfoS485iyIYCQ41arltmWUgFN5xWIFGlwlkV9kgQ9oP86/0ywtyqk8+qh
         BmhA==
X-Gm-Message-State: AOAM531jfo+BOIGCBYPO7DbzzZ7bSxNrWriiDJTZ69FV8P23AdIytVbO
        9qkpIC1YoURZhz1AnXL+bVAOlM9Xzrmq6NAZe/Qa7ur3yjFzhCVpRJEYAt1XN2Q/coQHIK0LNFf
        Nb+G+IsMi4C3j
X-Received: by 2002:adf:ed4a:: with SMTP id u10mr5502879wro.86.1627574217993;
        Thu, 29 Jul 2021 08:56:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwLgrogS1Ps6UnQ/0VQrtQt2MjSbOfI++E0VYu6WLH7GmA/dcP3gaa//uIkUtCBDdxTYVpodw==
X-Received: by 2002:adf:ed4a:: with SMTP id u10mr5502864wro.86.1627574217775;
        Thu, 29 Jul 2021 08:56:57 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id k17sm4088354wrw.53.2021.07.29.08.56.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 08:56:57 -0700 (PDT)
Subject: Re: [PATCH 1/6] x86/feat_ctl: Add new VMX feature, Tertiary
 VM-Execution control
To:     Sean Christopherson <seanjc@google.com>,
        Zeng Guang <guang.zeng@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
        Gao Chao <chao.gao@intel.com>,
        Robert Hoo <robert.hu@linux.intel.com>
References: <20210716064808.14757-1-guang.zeng@intel.com>
 <20210716064808.14757-2-guang.zeng@intel.com> <YQHr6VvNOQclolfc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <20d46894-a42f-88fc-124b-9d6662c57bef@redhat.com>
Date:   Thu, 29 Jul 2021 17:56:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YQHr6VvNOQclolfc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/07/21 01:44, Sean Christopherson wrote:
>> +	rdmsr_safe(MSR_IA32_VMX_PROCBASED_CTLS3, &ign, &supported);
>> +	c->vmx_capability[TERTIARY_CTLS_LOW] = ign;
>> +	c->vmx_capability[TERTIARY_CTLS_HIGH] = supported;
> Assuming only the lower 32 bits are going to be used for the near future (next
> few years), what about defining just TERTIARY_CTLS_LOW and then doing:
> 
> 	/*
> 	 * Tertiary controls are 64-bit allowed-1, so unlikely other MSRs, the
> 	 * upper bits are ignored (because they're not used, yet...).
> 	 */
> 	rdmsr_safe(MSR_IA32_VMX_PROCBASED_CTLS3, &supported, &ign);
> 	c->vmx_capability[TERTIARY_CTLS_LOW] = supported;
> 
> I.e. punt the ugliness issue down the road a few years.
> 

Or use two new variables low/high instead of supported/ign.

Paolo

