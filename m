Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D54A16837A
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 17:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727636AbgBUQbw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 11:31:52 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38383 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726710AbgBUQbu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 11:31:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582302709;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x+/PwYVfKF+sGaYhdBB/ka7rcNSOJveuT3O5v5Xs6QM=;
        b=ESGbxVw1HJjq1oBx2t4O0MDWKKz6SfhdePNBXnwuTwm+Kgsi9mC9O5yeauKJx/cAMn/urq
        JaQVqrcB9TTqFczfM77GT0UG1stkXdcO6QIjovzMla2lc446NS9qY2+Y85YFZu78SQYYwU
        6hIeUdWF4VBnXppaTwIzrUjCswVO298=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-e8qgw5_xPKK3VlNMCuQdkQ-1; Fri, 21 Feb 2020 11:31:47 -0500
X-MC-Unique: e8qgw5_xPKK3VlNMCuQdkQ-1
Received: by mail-wr1-f71.google.com with SMTP id d7so1250163wrx.9
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 08:31:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x+/PwYVfKF+sGaYhdBB/ka7rcNSOJveuT3O5v5Xs6QM=;
        b=MjGOlm+l2V7+NOP2u54DwD5TPIeKCpPWqQwb+/7AD/jWN2jy/nAZrQNNeMlCt85Rwt
         39cmx70y0cKJf9kQrGsXzOnsjW3yUG8FSCSruWfp7RszflnQfJNHM5pCXcHldI6Ik9bz
         BKxz2sXTAara1VPapvx58potGFHwCAgJ4+rKkz2p+PfectuIRXF+r7L+HDg4/RLyIo2j
         8ua44fW/xrNDg8LT6vYnkaxDWYiXTQaS5IQx+DsrCa5bMYt09PsQ6ze9UTEy8PIzjbik
         MVyfje71sWXxKYutGLQw0H2G608rVre7W3R0sf8LHH5xb8S9Uvdp0KhtA2u+JMh3Ib2D
         IUXw==
X-Gm-Message-State: APjAAAUji7u3AKrdgse5IaC3fRBY2MMneaJPocJDvmYUUnDu8WP1fKoR
        ExDHBxCRBHXW0u7R31FqUhWIKC4LU0ZFc/WQe8ZyN4+D7Ua2Ns5do5MEOxJRTQ7KYLGpTvpp2ZG
        lulEe5uAykjxR
X-Received: by 2002:a1c:f606:: with SMTP id w6mr4632374wmc.109.1582302706099;
        Fri, 21 Feb 2020 08:31:46 -0800 (PST)
X-Google-Smtp-Source: APXvYqzHPzw+vtsYsE0OyDcSB1eD9HXtMyBCN3d5TeUuNu7HSh1hgyKVqB1VcO5l07mSlsTnqf40YA==
X-Received: by 2002:a1c:f606:: with SMTP id w6mr4632358wmc.109.1582302705882;
        Fri, 21 Feb 2020 08:31:45 -0800 (PST)
Received: from [192.168.178.40] ([151.20.135.128])
        by smtp.gmail.com with ESMTPSA id w1sm4297148wmc.11.2020.02.21.08.31.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 08:31:44 -0800 (PST)
Subject: Re: [PATCH] KVM: X86: eliminate some meaningless code
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linmiaohe <linmiaohe@huawei.com>
Cc:     rkrcmar@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
References: <1582293926-23388-1-git-send-email-linmiaohe@huawei.com>
 <20200221152358.GC12665@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e393431b-9e5e-9bcb-c03a-d40baeafa435@redhat.com>
Date:   Fri, 21 Feb 2020 17:31:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200221152358.GC12665@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/02/20 16:23, Sean Christopherson wrote:
> 
> I'm guessing no VMM actually uses this ioctl(), e.g. neither Qemu or CrosVM
> use it, which is why the broken behavior has gone unnoticed.  Don't suppose
> you'd want to write a selftest to hammer KVM_{SET,GET}_CPUID2?
> 
> int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
>                               struct kvm_cpuid2 *cpuid,
>                               struct kvm_cpuid_entry2 __user *entries)
> {
>         if (cpuid->nent < vcpu->arch.cpuid_nent)
>                 return -E2BIG;
> 
>         if (copy_to_user(entries, &vcpu->arch.cpuid_entries,
>                          vcpu->arch.cpuid_nent * sizeof(struct kvm_cpuid_entry2)))
>                 return -EFAULT;
> 
> 	cpuid->nent = vcpu->arch.cpuid_nent;
> 
>         return 0;
> }

I would just drop KVM_GET_CPUID2 altogether and see if someone complains.

Paolo

