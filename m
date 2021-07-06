Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC253BD7F6
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 15:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbhGFNnY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 09:43:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40566 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232146AbhGFNnX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 09:43:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625578844;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZxW9Rv0F8Pv8lXM8dccMdV9Dj0K23zHOKjCbKUj49i4=;
        b=L51ChAVOX9HzAiOnbMSwYFbQDkO5bMCii4Ta1I8MzvmDDUy1gEiVMueiS0idZ+0qrMYj4k
        EWjAPI4ZU9dAv2NX2RX6Fv5cP8MIp61708/3n2xbtjk816NIqYfk1LTdqUTMIz2lAUqMH9
        hUEPuKaFcDy6P2e4yFnv1aEag0P9nxU=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-uLf5FtpjMPe5LsqTRnGwzQ-1; Tue, 06 Jul 2021 09:40:43 -0400
X-MC-Unique: uLf5FtpjMPe5LsqTRnGwzQ-1
Received: by mail-ej1-f71.google.com with SMTP id hg14-20020a1709072cceb02904dcfba77bceso1430936ejc.19
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 06:40:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZxW9Rv0F8Pv8lXM8dccMdV9Dj0K23zHOKjCbKUj49i4=;
        b=NzPoC4PWkXWokou9hhoHnQQ0QenTVOg1SexTUiQJaHAFC9G9zeqRsk6k7+AkKtYNfA
         IKu6U5VLdjRUOfYT9Jns1X2fkb82syCKi2z4jztxSG6YZk1VaXwklBugpeFprh4X8HlJ
         +luDmBWI2w9JtMM1WZyTyQiFcE63BafDipDOV1mmQA1YuA0+EV/fUZhbPcOYJ5YuSsUA
         mREgt1rx7weo1kBgqritBYAWNtim+h1POrQ7u9+AmPKyIsyQdl8/ls8Dzy5NtGJKbVFH
         nD3i3xesz7VGsUZgrjkV3OvcsvyMGAgzzHX6w9c/lR7MEqsYzc/v8ik3ojZBg/g88oZW
         k6Mw==
X-Gm-Message-State: AOAM533wkZEWu1xVDbMwvnfTLAPPbxdGHp5n00zik05at8+wDRdc9Tve
        PNPVpowjkUC8E8VyKXQ+5xzEReb8slEZvJGUV5633TS7926KjkXvoBnb98NOud66cw3FmeOKeP4
        K3SjdYo6ywiBX
X-Received: by 2002:a17:907:da3:: with SMTP id go35mr16895065ejc.243.1625578841909;
        Tue, 06 Jul 2021 06:40:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwdaGhDKPtpgk6uOSNbmgS3wnoUauh3h3g6NmiRNp1Wxp4bCyyNa8unAwVj+iDFaS7+XW47sQ==
X-Received: by 2002:a17:907:da3:: with SMTP id go35mr16895046ejc.243.1625578841737;
        Tue, 06 Jul 2021 06:40:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q5sm5727972ejc.117.2021.07.06.06.40.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 06:40:41 -0700 (PDT)
Subject: Re: [RFC PATCH v2 15/69] KVM: x86: Export kvm_mmio tracepoint for use
 by TDX for PV MMIO
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
 <e775afde604680b9a05fd97ddc188953db7c7555.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <323b4e32-1db4-ef2b-4780-cdd1bce55eae@redhat.com>
Date:   Tue, 6 Jul 2021 15:40:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <e775afde604680b9a05fd97ddc188953db7c7555.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Later kvm_intel.ko will use it.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/x86.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 795f83a1cf9a..cc45b2c47672 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11962,6 +11962,7 @@ EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
>   
>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_entry);
>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_mmio);
>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_page_fault);
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

