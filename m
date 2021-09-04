Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27E6E400A55
	for <lists+kvm@lfdr.de>; Sat,  4 Sep 2021 09:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233340AbhIDH6U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Sep 2021 03:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231925AbhIDH6T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Sep 2021 03:58:19 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6DAC061757
        for <kvm@vger.kernel.org>; Sat,  4 Sep 2021 00:57:18 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id w19-20020a17090aaf9300b00191e6d10a19so1094376pjq.1
        for <kvm@vger.kernel.org>; Sat, 04 Sep 2021 00:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Zg/5AKd9rdTjuzlyeiWM5OX1JBziXc62n7CLuQ994yM=;
        b=xtfl4wl+NWVGH7rOUy0KNcIxiDObzlRzsF3RwGJ8Hq+T5o8wW1yfBMndLkDEbJVuwS
         O96pOsSBunZsOV4VAiMINHYv8fxaJvTapgpafMMiL0EBNA0an0LG4IPFNh1X7stjlEFW
         rMQz7NmuU+NqFWUOy/rFGB9ESbAzgXhpmKkfVMurVfpwSaPl9rTx7pufjGRl3RNHHY37
         K1M8/MoBKxilbApE8WoMNjvplmaFRDZQYIia5IJVpExvnqTjFYa1FdDTR94jbuMNiD4c
         ec4kK9qRrYJw3MC9nyBzBgAD25l+VbN02/zhFK+UDG6NhYNltqu4O7B5E5Kh14QUmmFS
         VLUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Zg/5AKd9rdTjuzlyeiWM5OX1JBziXc62n7CLuQ994yM=;
        b=OwKQ1w8B5/ANIRLzprugSL9+URkuTL0Sk04He6KuesKLmtOze7wLV+wPSRCXebnQRe
         OBn8R0uxwrapgf62JNBWWShf77A3Zi8c4Dat/X1MWAh/rNt9KMxaOnYEKQf5vhbW9QeW
         s+x71bAkWpeSaxHkZSQZin7mQPXFRUnnce0MWlK3VrTJXstiT1XwdGRmpY/fA+BJCM3Y
         WMe50dvf2G1GjvhQJjNKyERBY8l+fvljwT4GGIeL8t6+9xJzLZkTAsdhqNKHPJDkyTsk
         QcHH1HKbue6EuYdcTfsmCQ6Jh5HftmaDpLHjPGwcpVtU6T2pCLQIVkpr4s4oRbdr0YTm
         38zQ==
X-Gm-Message-State: AOAM533zICeq2q1cd28odcZigWqcWTWHF2kSB6C6gxBUl3f5iZOK7NnL
        6eWENU5dT6K4mn+oiwi2mlo9aw==
X-Google-Smtp-Source: ABdhPJx+UeSZg4JLkZTUSXeiLtdyFeKDx7uVNh7Vt19oevVW0XSdIQYPrdN5KEmR9Wkqd95uZG7KXg==
X-Received: by 2002:a17:90a:1b2a:: with SMTP id q39mr2996000pjq.219.1630742237827;
        Sat, 04 Sep 2021 00:57:17 -0700 (PDT)
Received: from [192.168.10.23] (124-171-108-209.dyn.iinet.net.au. [124.171.108.209])
        by smtp.gmail.com with ESMTPSA id v6sm1506534pfv.83.2021.09.04.00.57.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Sep 2021 00:57:17 -0700 (PDT)
Message-ID: <327b1ca9-f05e-dfc0-7d59-7b7b6bda5394@ozlabs.ru>
Date:   Sat, 4 Sep 2021 17:57:12 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:92.0) Gecko/20100101
 Thunderbird/92.0
Subject: Re: [PATCH kernel] KVM: PPC: Book3S: Merge powerpc's debugfs entry
 content into generic entry
Content-Language: en-US
To:     Fabiano Rosas <farosas@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>
References: <20210903052257.2348036-1-aik@ozlabs.ru>
 <87v93hens6.fsf@linux.ibm.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <87v93hens6.fsf@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 04/09/2021 00:28, Fabiano Rosas wrote:
> Alexey Kardashevskiy <aik@ozlabs.ru> writes:
> 
>> At the moment the generic KVM code creates an "%pid-%fd" entry per a KVM
>> instance; and the PPC HV KVM creates its own at "vm%pid".
>>
>> The rproblems with the PPC entries are:
>> 1. they do not allow multiple VMs in the same process (which is extremely
>> rare case mostly used by syzkaller fuzzer);
>> 2. prone to race bugs like the generic KVM code had fixed in
>> commit 85cd39af14f4 ("KVM: Do not leak memory for duplicate debugfs
>> directories").
>>
>> This defines kvm_arch_create_kvm_debugfs() similar to one for vcpus.
> 
> I think kvm_arch_create_vm_debugfs is a bit mode accurate?


ah yes, it is better.

>                          ^
>> This defines 2 hooks in kvmppc_ops for allowing specific KVM
>> implementations to add necessary entries.
>>
>> This makes use of already existing kvm_arch_create_vcpu_debugfs.
>>
>> This removes no more used debugfs_dir pointers from PPC kvm_arch structs.
>>
>> Suggested-by: Fabiano Rosas <farosas@linux.ibm.com>
>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> 
> ...
> 
>> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
>> index c8f12b056968..325b388c725a 100644
>> --- a/arch/powerpc/kvm/book3s_hv.c
>> +++ b/arch/powerpc/kvm/book3s_hv.c
>> @@ -2771,19 +2771,14 @@ static const struct file_operations debugfs_timings_ops = {
>>   };
>>   
>>   /* Create a debugfs directory for the vcpu */
>> -static void debugfs_vcpu_init(struct kvm_vcpu *vcpu, unsigned int id)
>> +static void kvmppc_arch_create_vcpu_debugfs_hv(struct kvm_vcpu *vcpu, struct dentry *debugfs_dentry)
> 
> This could lose the 'arch' since it is already inside our code and
> accessed only via ops. I see that we already have a
> kvmppc_create_vcpu_debugfs that's used for some BookE processor, this

Ouch, missed kvmppc_create_vcpu_debugfs(). Good eye :)


> would make:
> 
> kvmppc_create_vcpu_debugfs
> kvmppc_create_vcpu_debugfs_hv
> kvmppc_create_vcpu_debugfs_pr (possibly)
> 
> which perhaps is more consistent.


Or  kvm_arch_vm_ioctl_hv(). I really like having "arch" in the name, 
tells right away what it is about. "kvmppc" might be excessive. Thanks,



>>   {
>> -	char buf[16];
>> -	struct kvm *kvm = vcpu->kvm;
>> -
>> -	snprintf(buf, sizeof(buf), "vcpu%u", id);
>> -	vcpu->arch.debugfs_dir = debugfs_create_dir(buf, kvm->arch.debugfs_dir);
>> -	debugfs_create_file("timings", 0444, vcpu->arch.debugfs_dir, vcpu,
>> +	debugfs_create_file("timings", 0444, debugfs_dentry, vcpu,
>>   			    &debugfs_timings_ops);
>>   }
>>   
>>   #else /* CONFIG_KVM_BOOK3S_HV_EXIT_TIMING */
>> -static void debugfs_vcpu_init(struct kvm_vcpu *vcpu, unsigned int id)
>> +static void kvmppc_arch_create_vcpu_debugfs_hv(struct kvm_vcpu *vcpu, struct dentry *debugfs_dentry)
>>   {
>>   }
>>   #endif /* CONFIG_KVM_BOOK3S_HV_EXIT_TIMING */

-- 
Alexey
