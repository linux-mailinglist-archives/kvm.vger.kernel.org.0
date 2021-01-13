Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B662A2F4BA0
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 13:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725969AbhAMMtS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 07:49:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38904 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725857AbhAMMtS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 07:49:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610542071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MN//j4KfkaQDO4C4FoLF4BEjv0MtOHoXDo9L7ieqXmM=;
        b=NHjSkQHz9jQcl9a80dpZY0b4s3q9z+eoPONAPwQXTQO8yrLpuAHyyQPipqjYXSZjmhX8NT
        pMv99fYgkiW+LQPBs6CjXrsMfr9I4K2giQXWlcQ4NN8xwTJIg3UIcnZwJEpg5JobW8fSDy
        HOF3XJB3zjp4sXB3r8JcBmJQMfV+Wzw=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-543-S7KKF__yP-e0Ixdnin5TkQ-1; Wed, 13 Jan 2021 07:47:49 -0500
X-MC-Unique: S7KKF__yP-e0Ixdnin5TkQ-1
Received: by mail-ej1-f70.google.com with SMTP id j14so682100eja.15
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 04:47:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MN//j4KfkaQDO4C4FoLF4BEjv0MtOHoXDo9L7ieqXmM=;
        b=UR0+zXj3ewobXdUn7ceQu/N7IYR11T8SE28sBtdYT5R6bFyRf1aNpRBrt4OqGxNgzc
         tjlwusecSvg/YA1QzytB15qPY9wugmn2mYB7p9z43UcinKw4oX5+QCQm7nomONEus7oi
         L4ioBN6e8S2Jsmr3v6yff7uRqaaO/XoiowEtfQ6w/Duh1Dc/zW70ayCKPbJnuAgmQP38
         /W6xxkGF47ZpXB1vqJNBfVdmofatjOVTOpnuYdV/66Pq/12tI7AkRYw4EMYTDgRKAJlW
         fFQxnaUHWXsoVYgt3R7aa4p3ttqWsq/fwGWBNfC9/9b8WZitxqF8yE6s/uyVX0FMl8CE
         KeTg==
X-Gm-Message-State: AOAM5326yCTcppEEoFspS3QTUif0YK328jqQsDroHoBPBR1h4O8zodI5
        +JOCk6zhbe1JtZOp9LOCb1wdPPPpgfmSq3kI4tSv+dPD8XATIKcTOAKGBlbziYBQ8vUoYAY65a0
        mWZyAjkgB1yGK
X-Received: by 2002:a50:9ee6:: with SMTP id a93mr1676108edf.174.1610542068533;
        Wed, 13 Jan 2021 04:47:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyikRdfoGYoew5FvAMydezcXlv1r36t0us5uCD3RBdb1UXRawJ6L+W5SY23B2IER8QAu0mx/A==
X-Received: by 2002:a50:9ee6:: with SMTP id a93mr1676096edf.174.1610542068394;
        Wed, 13 Jan 2021 04:47:48 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id z25sm684934ejd.23.2021.01.13.04.47.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jan 2021 04:47:47 -0800 (PST)
Subject: Re: [PATCH 1/2] KVM: x86: introduce definitions to support static
 calls for kvm_x86_ops
To:     Jason Baron <jbaron@akamai.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, peterz@infradead.org, aarcange@redhat.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
References: <cover.1610379877.git.jbaron@akamai.com>
 <ce483ce4a1920a3c1c4e5deea11648d75f2a7b80.1610379877.git.jbaron@akamai.com>
 <X/4q/OKvW9RKQ+gk@google.com>
 <1784355c-e53e-5363-31e3-faeba4ba9e8f@akamai.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <86972c56-4d2e-a6ab-11ad-c972a395386a@redhat.com>
Date:   Wed, 13 Jan 2021 13:47:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <1784355c-e53e-5363-31e3-faeba4ba9e8f@akamai.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/01/21 05:12, Jason Baron wrote:
>>
> Looking at the vmx definitions I see quite a few that don't
> match that naming. For example:
> 
> hardware_unsetup,
> hardware_enable,
> hardware_disable,
> report_flexpriority,
> update_exception_bitmap,
> enable_nmi_window,
> enable_irq_window,
> update_cr8_intercept,
> pi_has_pending_interrupt,
> cpu_has_vmx_wbinvd_exit,
> pi_update_irte,
> kvm_complete_insn_gp,
> 
> So I'm not sure if we want to extend these macros to
> vmx/svm.

Don't do it yourself, but once you introduce the new header it becomes a 
no-brainer to switch the declarations to use it.  So let's plan the new 
header to make that switch easy.

Using trailing commas unconditionally would be okay, i.e.

#define X86_OP(func)     .func = vmx_##func,
#include "kvm-x86-ops.h"

and leave out the terminator/delimiter in kvm-x86-ops.h.  This is 
similar to how we use vmx/vmcs_shadow_fields.h:

#define SHADOW_FIELD_RO(x, y) { x, offsetof(struct vmcs12, y) },
#include "vmcs_shadow_fields.h"

#define SHADOW_FIELD_RW(x, y) case x:
#include "vmcs_shadow_fields.h"

Thanks,

Paolo

