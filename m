Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C1D2F7D1F
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 14:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730547AbhAONuL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 08:50:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30603 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731834AbhAONuK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 08:50:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610718523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UmdXZnJ0rCCxg9loWNAHyICDQUnDFC/MbRNMEAdOfbU=;
        b=RXHm4Dhq1vlZXHrv1wO+X19AVcv8xWatRHd5Lq9a44eUt9PLopdsQ2nzSGIILHj30aeFJ6
        rUqlym8U0kg01NMZK2DDVmnKQNZJxNC7yvr+CNhcrTLDcoXcofEQNXmCN62pqIxDvaGBoR
        7c5zZZnQLBfOpLiyZ0WKZU3jqZgVfw8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-hAr5-N-ZN3aGVA891xfUDA-1; Fri, 15 Jan 2021 08:48:41 -0500
X-MC-Unique: hAr5-N-ZN3aGVA891xfUDA-1
Received: by mail-ed1-f69.google.com with SMTP id f19so3852638edq.20
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 05:48:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UmdXZnJ0rCCxg9loWNAHyICDQUnDFC/MbRNMEAdOfbU=;
        b=iiE3bml4hKOhCQ6Xjv0/cZHQUJvd5XibmRLtfA4Fm84UiP/L08sqAglwCn4DcEKEFy
         pgu68OdR6rLSwQxwd0NGaBmZw7LHPGlvcxOzHrf0WkL325+YXOYvam0GKCbRmmmQ1Z5G
         54puW0q0NfsVYJFNAQrnwSrwep1ezR4cXPdIdOgAGnvKNeFqmj9IgoLV6ZFUhZNiR1Na
         Csbp3qxEONwonMkjktDtZFpV73kTbXC6SsDsUlM728/NP279v6+38DI476n1cY5fDSjL
         qN9foSdHcIjm7cm5GYjrAhdY5xECFhxLzCPKAjmgkvuPzB7IiLImKAsPSt8/lIfBz+Ad
         irEQ==
X-Gm-Message-State: AOAM532+RXrtR+8jj82SNjRJIWQVdcnbI0xAayvWlhyrOiOp4W81c1gU
        47EHmZ1/2FfuteH1AarsnYmlr6JD8F1cxCcqEbTAI6yxJaps5PRQKoUwTTNht6CquRlAijh35ZF
        PgZEk99qx8s0f
X-Received: by 2002:a17:906:1f8e:: with SMTP id t14mr8966252ejr.350.1610718520515;
        Fri, 15 Jan 2021 05:48:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy9EpSEC4BRPwW2BLpZzVG1AVTq23DwCnwPW8rSH7TxniRUbmiTF14i8qMsAaDUXEUKa1kQnA==
X-Received: by 2002:a17:906:1f8e:: with SMTP id t14mr8966234ejr.350.1610718520315;
        Fri, 15 Jan 2021 05:48:40 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id l17sm3487008ejn.122.2021.01.15.05.48.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jan 2021 05:48:39 -0800 (PST)
Subject: Re: [PATCH v2 2/3] KVM: nVMX: add kvm_nested_vmlaunch_resume
 tracepoint
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>
References: <20210114205449.8715-1-mlevitsk@redhat.com>
 <20210114205449.8715-3-mlevitsk@redhat.com> <YADeT8+fssKw3SSi@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <18c386f2-a588-6324-fcde-d13b66f66d4f@redhat.com>
Date:   Fri, 15 Jan 2021 14:48:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <YADeT8+fssKw3SSi@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/01/21 01:14, Sean Christopherson wrote:
>> +	trace_kvm_nested_vmlaunch_resume(kvm_rip_read(vcpu),
> Hmm, won't this RIP be wrong for the migration case?  I.e. it'll be L2, not L1
> as is the case for the "true" nested VM-Enter path.

It will be the previous RIP---might as well be 0xfffffff0 depending on 
what userspace does.  I don't think you can do much better than that, 
using vmcs12->host_rip would be confusing in the SMM case.

>> +					 vmx->nested.current_vmptr,
>> +					 vmcs12->guest_rip,
>> +					 vmcs12->vm_entry_intr_info_field);
> The placement is a bit funky.  I assume you put it here so that calls from
> vmx_set_nested_state() also get traced.  But, that also means
> vmx_pre_leave_smm() will get traced, and it also creates some weirdness where
> some nested VM-Enters that VM-Fail will get traced, but others will not.
> 
> Tracing vmx_pre_leave_smm() isn't necessarily bad, but it could be confusing,
> especially if the debugger looks up the RIP and sees RSM.  Ditto for the
> migration case.

Actually tracing vmx_pre_leave_smm() is good, and pointing to RSM makes 
sense so I'm not worried about that.

Paolo

