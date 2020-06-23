Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2017B204EFB
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 12:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732244AbgFWKYq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 06:24:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59180 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732135AbgFWKYp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 06:24:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592907884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K0VMF+zOglKc79uK7nAPfjf+HV37t2ditCPtYi6hRnc=;
        b=fj0KjKiBRki4CRZ/41MI8NTE6klsTXqaJpu37yuRSd1wPUBqjVGdhMP8gk5cUhDLe1bMEf
        KyROxz8NyF1OMl07ij2V/gNihYJtyGFON2qreiiheOvHrVE+H1RfdX8MawFyMKPqlPA9NU
        sVlVEi4xWk6GGzeBhswX0Qb5KTuXpbc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-437-72wpnWpAOpurDso_bqQA7Q-1; Tue, 23 Jun 2020 06:24:42 -0400
X-MC-Unique: 72wpnWpAOpurDso_bqQA7Q-1
Received: by mail-wr1-f70.google.com with SMTP id o25so12852781wro.16
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 03:24:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K0VMF+zOglKc79uK7nAPfjf+HV37t2ditCPtYi6hRnc=;
        b=K0jBP4vl+lpDFhkBcQVZhgOpzOk2YQ4wWi2eEMd1UBXhpdTL60hJfioBty86A9TS76
         3NuIEiZp7p8FkPznI+uttap0UfZQJbsvFZWmslNkqcXwk+2B9GPyvoxxsXLhAZSby9yU
         4Wj30/08YTkJy7oiAnPDPEGl+xCSH76Z/coPG92Mr8ivTRbcCLvOGzTCNloDbnAMal0b
         1DYCVVMiMmuH+b9fIqqcPd+NXc/m1udrCHFkfVzJQsGkLB+/6YKyDHZl2xnUW0BDb/ze
         uIq01tmJnZ0Cx1RmJEiTF6g+cp5xQP5dNoJ3XjQm60QYqVr4I+fBev4GsB5x19ZW82KX
         Ui0g==
X-Gm-Message-State: AOAM533CfQW3PsGix7ZSoyK3D3n3ea8kE8VMI/oFIlsMrBOZeIP/5+Lp
        q8nzSWektie8xhCM6RgOD2mPvn80rXiJixP9S41ArouqWoK0sIsFR+VUEKAVhGm9ESvU1RCQse6
        trQ0Ji3eAdEf7
X-Received: by 2002:a05:6000:ce:: with SMTP id q14mr16454562wrx.294.1592907881327;
        Tue, 23 Jun 2020 03:24:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw7GKxnJWV0b4Mz/7lWJjdPl3+rZwUgIO80Ac5HDjj13PmRVjDey+yK0l49hJjTmncjlmTnYw==
X-Received: by 2002:a05:6000:ce:: with SMTP id q14mr16454534wrx.294.1592907881013;
        Tue, 23 Jun 2020 03:24:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:24f5:23b:4085:b879? ([2001:b07:6468:f312:24f5:23b:4085:b879])
        by smtp.gmail.com with ESMTPSA id c66sm3351206wma.20.2020.06.23.03.24.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2020 03:24:40 -0700 (PDT)
Subject: Re: [PATCH v4 0/7] clean up redundant 'kvm_run' parameters
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        tsbogend@alpha.franken.de, paulus@ozlabs.org, mpe@ellerman.id.au,
        benh@kernel.crashing.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, maz@kernel.org, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        christoffer.dall@arm.com, peterx@redhat.com, thuth@redhat.com,
        chenhuacai@gmail.com
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200427043514.16144-1-tianjia.zhang@linux.alibaba.com>
 <fe463233-d094-fca5-b4e9-c1d97124fd69@redhat.com>
 <3a2bee8b-20b4-5d33-7d12-09c374a5afde@linux.alibaba.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bad08799-274e-0a6f-9638-92c0010b1ba1@redhat.com>
Date:   Tue, 23 Jun 2020 12:24:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <3a2bee8b-20b4-5d33-7d12-09c374a5afde@linux.alibaba.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/20 12:00, Tianjia Zhang wrote:
> 
> 
> On 2020/6/23 17:42, Paolo Bonzini wrote:
>> On 27/04/20 06:35, Tianjia Zhang wrote:
>>> In the current kvm version, 'kvm_run' has been included in the
>>> 'kvm_vcpu'
>>> structure. For historical reasons, many kvm-related function parameters
>>> retain the 'kvm_run' and 'kvm_vcpu' parameters at the same time. This
>>> patch does a unified cleanup of these remaining redundant parameters.
>>>
>>> This series of patches has completely cleaned the architecture of
>>> arm64, mips, ppc, and s390 (no such redundant code on x86). Due to
>>> the large number of modified codes, a separate patch is made for each
>>> platform. On the ppc platform, there is also a redundant structure
>>> pointer of 'kvm_run' in 'vcpu_arch', which has also been cleaned
>>> separately.
>>
>> Tianjia, can you please refresh the patches so that each architecture
>> maintainer can pick them up?  Thanks very much for this work!
>>
>> Paolo
>>
> 
> No problem, this is what I should do.
> After I update, do I submit separately for each architecture or submit
> them together in a patchset?

You can send them together.

Paolo

