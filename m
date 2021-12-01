Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AECFB465548
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 19:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352319AbhLAS0D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 13:26:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352331AbhLASZW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 13:25:22 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 189F7C061574;
        Wed,  1 Dec 2021 10:21:59 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id w1so105714404edc.6;
        Wed, 01 Dec 2021 10:21:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0JgqzLHRXuF/J7v9bsu6lScT/g6rtUGa0/shRpS2/ew=;
        b=lRV3wX8jQju/EGeeKhwMd1d5OJIVF3qUiPU7sPDjo09QRsQPwqYY9o4RekWEqw57VE
         Qcor1znB6nwVvvfblTOP24gZtFonM8TOjebmD7PEBpYyVP/HqolPHrB6PtOkgmJlI4Ty
         smtzBa6+CfuTp8V/pPMak11QGOg/BGWYaa+0emRfVWIJJaydw5odvZWTNH1yuOZ/doi2
         jtNXvg+/mWzRXm9tQzC2PG6fFYUmAbT3OmBB9VLZExKSxI1xtH1JZJkNm+lmfhyp8haM
         6mGuT8XsrSViAE5B40sUARFm85ai700BR7QjGpo+y6QepJqtn9cd4aNG+rG2h/5x2nKR
         t6JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0JgqzLHRXuF/J7v9bsu6lScT/g6rtUGa0/shRpS2/ew=;
        b=T5kwoSWouCDNsX4ktUv3TdhDlKmCR707KeBn4rsVxZtWq5IqvNwSP7wTn78zTkf9D4
         QjvjWSQFz03iCe/PZ7Yzmy1YvZL5BXsk0bCqTN3hSh83enJoP8T2s508aAzfAPv5B9h2
         Ef6y4NPYk2hIx19fhh7c/mlgerF0MmXNFKV/Gei//edmTgO79Apb4H/siUlJidnJDxID
         I3+8WB95DY5bAHK6lfJi26e1WUZuDSZ+n6DgYaERsDm+S2fXPTsF5ZXsjsKMjO16G9wn
         E0J7POpec1+a3NIWo9CGVhIMfd+QwxQgV7e4bPYXzRM6SDQW09MWhmWlLYfHxWeqhadQ
         0YOA==
X-Gm-Message-State: AOAM531xe8DEFd1tAO91PcAh4s3wJ191nQ16VWrAswqRrK4+OonP0AOA
        ud19y9HHkrdYyehIw1uePxcpPCSDpBY=
X-Google-Smtp-Source: ABdhPJx8SdnhY5fYiKkj2L+gsW+RU/pHWA3I/ZzHS0zJEX9TEn8gNeby/oEreQTWAwnA9pg6YODLbg==
X-Received: by 2002:a17:906:48cd:: with SMTP id d13mr8769268ejt.35.1638382917548;
        Wed, 01 Dec 2021 10:21:57 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id h7sm412447ede.40.2021.12.01.10.21.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Dec 2021 10:21:57 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <fc583908-ee45-a320-2326-bfae926f0623@redhat.com>
Date:   Wed, 1 Dec 2021 19:21:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 10/12] KVM: SEV: Prohibit migration of a VM that has
 mirrors
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20211123005036.2954379-1-pbonzini@redhat.com>
 <20211123005036.2954379-11-pbonzini@redhat.com>
 <CAMkAt6q9OsrZuEG-fXRh2D26F34RAZcX8KQS22CTLC7S+YF3MA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAMkAt6q9OsrZuEG-fXRh2D26F34RAZcX8KQS22CTLC7S+YF3MA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/1/21 19:17, Peter Gonda wrote:
> On Mon, Nov 22, 2021 at 5:50 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> VMs that mirror an encryption context rely on the owner to keep the
>> ASID allocated.  Performing a KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM
>> would cause a dangling ASID:
>>
>> 1. copy context from A to B (gets ref to A)
>> 2. move context from A to L (moves ASID from A to L)
>> 3. close L (releases ASID from L, B still references it)
>>
>> The right way to do the handoff instead is to create a fresh mirror VM
>> on the destination first:
>>
>> 1. copy context from A to B (gets ref to A)
>> [later] 2. close B (releases ref to A)
>> 3. move context from A to L (moves ASID from A to L)
>> 4. copy context from L to M
>>
>> So, catch the situation by adding a count of how many VMs are
>> mirroring this one's encryption context.
>>
>> Fixes: 0b020f5af092 ("KVM: SEV: Add support for SEV-ES intra host migration")
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>   arch/x86/kvm/svm/sev.c                        | 22 ++++++++++-
>>   arch/x86/kvm/svm/svm.h                        |  1 +
>>   .../selftests/kvm/x86_64/sev_migrate_tests.c  | 37 +++++++++++++++++++
>>   3 files changed, 59 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 025d9731b66c..89a716290fac 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -1696,6 +1696,16 @@ int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
>>          }
>>
>>          src_sev = &to_kvm_svm(source_kvm)->sev_info;
>> +
>> +       /*
>> +        * VMs mirroring src's encryption context rely on it to keep the
>> +        * ASID allocated, but below we are clearing src_sev->asid.
>> +        */
>> +       if (src_sev->num_mirrored_vms) {
>> +               ret = -EBUSY;
>> +               goto out_unlock;
>> +       }
>> +
>>          dst_sev->misc_cg = get_current_misc_cg();
>>          cg_cleanup_sev = dst_sev;
>>          if (dst_sev->misc_cg != src_sev->misc_cg) {
>> @@ -1987,6 +1997,7 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
>>           */
>>          source_sev = &to_kvm_svm(source_kvm)->sev_info;
>>          kvm_get_kvm(source_kvm);
>> +       source_sev->num_mirrored_vms++;
>>
>>          /* Set enc_context_owner and copy its encryption context over */
>>          mirror_sev = &to_kvm_svm(kvm)->sev_info;
>> @@ -2019,12 +2030,21 @@ void sev_vm_destroy(struct kvm *kvm)
>>          struct list_head *head = &sev->regions_list;
>>          struct list_head *pos, *q;
>>
>> +       WARN_ON(sev->num_mirrored_vms);
>> +
> 
> If we don't change to atomic doesn't this need to happen when we have
> the kvm->lock?

Hi,

there can be no concurrency when destroying a VM.  (If you do Rust, it's 
similar to using x.get_mut().get_mut() on an Arc<Mutex<T>>).

Paolo
