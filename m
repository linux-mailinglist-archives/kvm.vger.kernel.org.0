Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 714B81D12E1
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 14:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731993AbgEMMho (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 08:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731709AbgEMMhn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 08:37:43 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121F7C061A0C;
        Wed, 13 May 2020 05:37:43 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id 50so20157478wrc.11;
        Wed, 13 May 2020 05:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RugSmt8EF7xoG6N6QG3k7oUUaKf1LBbQK6iqg3uhGVc=;
        b=qiEe/AP6Y7hTMs8NMLImXg2L/Phr4eeIxHDRhD785laWQqbfL9ya9SdFimerZsS7e5
         EZz6fLOS6GRM1Dkm/WocGcAFDtxJ5qny46T/4laIXT7VFBF/KD/6/w3ZMvYuiYYHoE0H
         t3Ac7YS6NbOMeU2F8v99xtd51Dm6dOr1t+kWYrhZQCo9EHPhSZsl+sMV38GEvYcgnGM+
         9XIJdVQ/YGKMpuwoDi9QUZOVSreSmPdgylX+wP8QFq+FCNF0GzJ0FBA604V2ljhreUsK
         4qZIaygdkTGGlpEp/y7BBXtr7VUKw+UbQeJVaD26gvUYbJqPcNuWhXpa81Eq90VVy6sB
         t/6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RugSmt8EF7xoG6N6QG3k7oUUaKf1LBbQK6iqg3uhGVc=;
        b=QRgnYd39446SmCi4Gs2Cce+hhCLx1EePhDFBW/ZaTKcvVH68/TikZYoJ6K+oDjDttw
         Xp2Ankx3YAmXi+SO1kWkWq8grbduDQZcr+v02T4pNkWcHh8E/IZncs7hbGc82D8pcrW4
         a3GK1etZbqReYy3q+feNh8DZjKKca9r6JIzr4LJxsm5QgzQMDHq0KZcaKPN+S8mB+HsQ
         o4DvpwpaWjJsDytIrTSwAb4SW2uZkUPCXPvu626oNww3QXOdOMdE+qwTrZeVDEVmWqIL
         nY5CAlR9LZC19lSfBUIXey/qD3jtKCeG+WwF7tUmwglhZeR0R4q1RpS+OesMfGvseUX8
         JgdQ==
X-Gm-Message-State: AGi0PuYUF8hQQih0uWCn5q94/KszxKyFed4EmcLdyKyT+OVOt8l1XjaA
        k3r/bOU3ogjveOYVCSgY4GBpaweIA/0=
X-Google-Smtp-Source: APiQypIuZgHeW59b+htFw4Jnpdw5Sl6YGiRwJ7ShlCMxkzwiZVpwnj41JMjaTpW96gZejYjXP59wHA==
X-Received: by 2002:a5d:6750:: with SMTP id l16mr11615310wrw.295.1589373461755;
        Wed, 13 May 2020 05:37:41 -0700 (PDT)
Received: from jondnuc (IGLD-84-229-154-20.inter.net.il. [84.229.154.20])
        by smtp.gmail.com with ESMTPSA id d126sm16529520wmd.32.2020.05.13.05.37.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 05:37:41 -0700 (PDT)
Date:   Wed, 13 May 2020 15:37:39 +0300
From:   Jon Doron <arilou@gmail.com>
To:     Roman Kagan <rvkagan@yandex-team.ru>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, vkuznets@redhat.com
Subject: Re: [PATCH v11 5/7] x86/kvm/hyper-v: enable hypercalls without
 hypercall page with syndbg
Message-ID: <20200513123739.GK2862@jondnuc>
References: <20200424113746.3473563-1-arilou@gmail.com>
 <20200424113746.3473563-6-arilou@gmail.com>
 <20200513095738.GC29650@rvkaganb.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200513095738.GC29650@rvkaganb.lan>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/05/2020, Roman Kagan wrote:
>On Fri, Apr 24, 2020 at 02:37:44PM +0300, Jon Doron wrote:
>> Microsoft's kdvm.dll dbgtransport module does not respect the hypercall
>> page and simply identifies the CPU being used (AMD/Intel) and according
>> to it simply makes hypercalls with the relevant instruction
>> (vmmcall/vmcall respectively).
>>
>> The relevant function in kdvm is KdHvConnectHypervisor which first checks
>> if the hypercall page has been enabled via HV_X64_MSR_HYPERCALL_ENABLE,
>> and in case it was not it simply sets the HV_X64_MSR_GUEST_OS_ID to
>> 0x1000101010001 which means:
>> build_number = 0x0001
>> service_version = 0x01
>> minor_version = 0x01
>> major_version = 0x01
>> os_id = 0x00 (Undefined)
>> vendor_id = 1 (Microsoft)
>> os_type = 0 (A value of 0 indicates a proprietary, closed source OS)
>>
>> and starts issuing the hypercall without setting the hypercall page.
>
>I guess this is to avoid interfering with the OS being debugged
>requesting its own hypercall page at a different address.
>
>> To resolve this issue simply enable hypercalls also if the guest_os_id
>> is not 0 and the syndbg feature is enabled.
>>
>> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> Signed-off-by: Jon Doron <arilou@gmail.com>
>> ---
>>  arch/x86/kvm/hyperv.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
>> index 435516595090..524b5466a515 100644
>> --- a/arch/x86/kvm/hyperv.c
>> +++ b/arch/x86/kvm/hyperv.c
>> @@ -1650,7 +1650,10 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *current_vcpu, u64 ingpa, u64 outgpa,
>>
>>  bool kvm_hv_hypercall_enabled(struct kvm *kvm)
>>  {
>> -	return READ_ONCE(kvm->arch.hyperv.hv_hypercall) & HV_X64_MSR_HYPERCALL_ENABLE;
>> +	struct kvm_hv *hv = &kvm->arch.hyperv;
>> +
>> +	return READ_ONCE(hv->hv_hypercall) & HV_X64_MSR_HYPERCALL_ENABLE ||
>> +	       (hv->hv_syndbg.active && READ_ONCE(hv->hv_guest_os_id) != 0);
>
>This function is meant to tell if the hypercall should be interpreted as
>following KVM or HyperV conventions.  Quoting from the spec
>
>  3.5 Legal Hypercall Environments
>
>  ...
>  All hypercalls should be invoked through the architecturally-defined
>  hypercall interface. (See the following sections for instructions on
>  discovering and establishing this interface.) An attempt to invoke a
>  hypercall by any other means (for example, copying the code from the
>  hypercall code page to an alternate location and executing it from
>  there) might result in an undefined operation (#UD) exception.  The
>  hypervisor is not guaranteed to deliver this exception.
>
>so I think we can simply test for hv_guest_os_id != 0 and ignore
>HV_X64_MSR_HYPERCALL_ENABLE (it's about hypercall page being enabled,
>not the hypercalls per se).
>
>Thanks,
>Roman.
>
>>  }
>>
>>  static void kvm_hv_hypercall_set_result(struct kvm_vcpu *vcpu, u64 result)
>> --
>> 2.24.1
>>

Hi Roman,

I agree this was the original implementation of this patchset (see v1) I 
will send a v12 with the suggested change, but I would prefer that you 
will review the mailing list previous comments which caused to this 
specific behaviour.

Thanks,
-- Jon.
