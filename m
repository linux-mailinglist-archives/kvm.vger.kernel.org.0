Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB58D373164
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 22:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232853AbhEDU3L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 16:29:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35800 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232560AbhEDU3H (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 May 2021 16:29:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620160092;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FbsHJVMfILlnS5Wi41hoQHAxs4c8Dc+Z1Og1/gTmS3c=;
        b=J7v0LT2wOO+CQELf7onYGMi57UtUIMnWBfIqSD6eRYFQSnCD/wxMc/dfebnyNO3D1z6ZRU
        oASaP1yJ60KhHjZJGKO4SQGHP7GiTZm9axQ0mlFTTXLe5u9EIo5E5T3I0VdktTW6h5HDuh
        cM2XD4JwTYVMo5K/u9MhoiyNtPuQLB0=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-OMVqNXpfPFqMrca-21j91A-1; Tue, 04 May 2021 16:28:08 -0400
X-MC-Unique: OMVqNXpfPFqMrca-21j91A-1
Received: by mail-ej1-f71.google.com with SMTP id yh1-20020a17090706e1b029038d0f848c7aso3622817ejb.12
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 13:28:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FbsHJVMfILlnS5Wi41hoQHAxs4c8Dc+Z1Og1/gTmS3c=;
        b=lsmEqNq2DvMqdmUfEucv6u/+gCubEtv5ea3DGe3c6c5klDzIURHjpIAsqdSZpb2er2
         3AY7gxVZGpqPfdCvaY0YfvIe5nr2AFAPbSAANu02r9sw2CiMZGf/+6Gr7GooTbgVO9OL
         /85IJV0/1p9T/ZTAt1daVYo3uVjw8AXSOdb8Co9spmuPiSEIi118EIhn1R2au9lC2dmd
         Y0TJz7R0ahr+tnyElKASVi+WCKPxIBFbEecft0c/0PQLizenWhXL2Vtnfor0Kgy/aWd8
         eK7KkHZowk/F8vLHFLtfR/iMVy/gQn0JzLKKZ5iuCy2kl7KQwP1KoQF9uAobKVvJGv1f
         1dBw==
X-Gm-Message-State: AOAM530L45Sa8+CwunIKnv1pFTBQ5k12KB4DvxXxku6ZhkgJgrgAiKop
        VftIWcunXcIADTu4XuZeVB/5GFryL7WYfS331eVEJgZW8rOzkbWjYiZeGDWy+kHEOXxIKIhNXGw
        ltzvpCcHsbs/N
X-Received: by 2002:a17:906:414d:: with SMTP id l13mr23123472ejk.527.1620160087433;
        Tue, 04 May 2021 13:28:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxl5vGIFlk8ABdz+SL+2HU6NV1sbi8oeO0R+cNsAQCQnnpf/2epVEQ5+x0V5jftLyZ2SiwKrA==
X-Received: by 2002:a17:906:414d:: with SMTP id l13mr23123463ejk.527.1620160087260;
        Tue, 04 May 2021 13:28:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id c7sm6558812ede.37.2021.05.04.13.28.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 May 2021 13:28:06 -0700 (PDT)
Subject: Re: [PATCH v3 2/2] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS
 hypercall
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        srutherford@google.com, joro@8bytes.org, brijesh.singh@amd.com,
        thomas.lendacky@amd.com, ashish.kalra@amd.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>,
        x86@kernel.org
References: <20210429104707.203055-1-pbonzini@redhat.com>
 <20210429104707.203055-3-pbonzini@redhat.com> <YIxkTZsblAzUzsf7@google.com>
 <c4bf8a05-ec0d-9723-bb64-444fe1f088b5@redhat.com>
 <YJF/3d+VBfJKqXV4@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f7300393-6527-005f-d824-eed5f7f2f8a8@redhat.com>
Date:   Tue, 4 May 2021 22:27:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YJF/3d+VBfJKqXV4@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/05/21 19:09, Sean Christopherson wrote:
> On Sat, May 01, 2021, Paolo Bonzini wrote:
>> - make it completely independent from migration, i.e. it's just a facet of
>> MSR_KVM_PAGE_ENC_STATUS saying whether the bitmap is up-to-date.  It would
>> use CPUID bit as the encryption status bitmap and have no code at all in KVM
>> (userspace needs to set up the filter and implement everything).
> 
> If the bit is purely a "page encryption status is up-to-date", what about
> overloading KVM_HC_PAGE_ENC_STATUS to handle that status update as well?   That
> would eliminate my biggest complaint about having what is effectively a single
> paravirt feature split into two separate, but intertwined chunks of ABI.

It's true that they are intertwined, but I dislike not having a way to 
read the current state.

Paolo

> 
> #define KVM_HC_PAGE_ENC_UPDATE		12
> 
> #define KVM_HC_PAGE_ENC_REGION_UPDATE	0 /* encrypted vs. plain text */
> #define KVM_HC_PAGE_ENC_STATUS_UPDATE	1 /* up-to-date vs. stale */
> 
> 		ret = -KVM_ENOSYS;
> 		if (!vcpu->kvm->arch.hypercall_exit_enabled)
> 		        break;
> 
> 		ret = -EINVAL;
> 		if (a0 == KVM_HC_PAGE_ENC_REGION_UPDATE) {
> 			u64 gpa = a1, npages = a2;
> 
> 			if (!PAGE_ALIGNED(gpa) || !npages ||
> 			    gpa_to_gfn(gpa) + npages <= gpa_to_gfn(gpa))
> 				break;
> 		} else if (a0 != KVM_HC_PAGE_ENC_STATUS_UPDATE) {
> 			break;
> 		}
> 
> 		vcpu->run->exit_reason        = KVM_EXIT_HYPERCALL;
> 		vcpu->run->hypercall.nr       = KVM_HC_PAGE_ENC_STATUS;
> 		vcpu->run->hypercall.args[0]  = a0;
> 		vcpu->run->hypercall.args[1]  = a1;
> 		vcpu->run->hypercall.args[2]  = a2;
> 		vcpu->run->hypercall.args[3]  = a3;
> 		vcpu->run->hypercall.longmode = op_64_bit;
> 		vcpu->arch.complete_userspace_io = complete_hypercall_exit;
> 		return 0;
> 

