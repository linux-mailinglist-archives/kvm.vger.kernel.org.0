Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8833B2097
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 20:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbhFWSvz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 14:51:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56124 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229523AbhFWSvy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 14:51:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624474176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ex6/mXcaG+GKeUSD+NCcVoWSuyt20fqJHwV5zAiTy0I=;
        b=S4BnyGar6Pra7sexrl+s3T+TEXA+crETjkuq6Y/TFomU4mDQTGgh0ExtsKXYP4d5dlfQCC
        VFJ2Y1CUnBMEKZK/oU000oCHXvcnnnkvH7jq9wNISI72usRNXEugwf6PAgGVOMnqG6wcee
        0sq5pFL5PVhDifWzHVdQ0RBsORJvmnA=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-NjyIFU-cOnWk87xypZykrg-1; Wed, 23 Jun 2021 14:49:33 -0400
X-MC-Unique: NjyIFU-cOnWk87xypZykrg-1
Received: by mail-ej1-f70.google.com with SMTP id 16-20020a1709063010b029037417ca2d43so1321788ejz.5
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 11:49:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ex6/mXcaG+GKeUSD+NCcVoWSuyt20fqJHwV5zAiTy0I=;
        b=HShZov7Bo5udQBgGs+nMCwuOAjjx7MELXCGmhR6TafAfsJuStJUGiSEhuGGvAXcCaI
         JDRTsLz7ABK8VGEdjoDtPQP2WCBIvThoOcYL1mCPoiz5Kxda0ppPyl8YM3+ptMJk9+QQ
         L3s1GmxeLpFpfIeAfAJMtBnsnS6ZWq4Me3HJMrN0eYAA/xtYe7Z+JSGLt0Ozbpuc54qw
         o85rbI253J+n3zSc0JIdrW5ZsLTBH61ZaobyvBFjPcruXCUA/YG0qgOKnBcDx59syrwB
         8qWcmhH3JTRa80WdxI3LxJ0wpH+bd0uDMA88MGXWJ7em4A/kvDlYbks15xJY341ZiaFR
         b3Gw==
X-Gm-Message-State: AOAM531mn2a4gxtlFW/hC7TgLQCp+qnw0p9YLizBTtjicFbnRG/u08t4
        Fkpyt08idxHKYCfAcpUncHwz0oh1hgT93NJgL21BHULdt/viSMPFBbUIseW76nYMPj/Q6gNVrvH
        seL88PYPPXKIS
X-Received: by 2002:a05:6402:1d07:: with SMTP id dg7mr1709153edb.298.1624474171845;
        Wed, 23 Jun 2021 11:49:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzluvzRWHHEu2YKGET4gmNdni9lg387FeQ7F9vDL5nOTZZgVcMU3DcuY0x7Gy6DIIg9maZgyQ==
X-Received: by 2002:a05:6402:1d07:: with SMTP id dg7mr1709131edb.298.1624474171621;
        Wed, 23 Jun 2021 11:49:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id v5sm478265edt.55.2021.06.23.11.49.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 11:49:31 -0700 (PDT)
Subject: Re: [PATCH 07/54] KVM: x86: Alert userspace that KVM_SET_CPUID{,2}
 after KVM_RUN is broken
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20210622175739.3610207-1-seanjc@google.com>
 <20210622175739.3610207-8-seanjc@google.com>
 <f031b6bc-c98d-8e46-34ac-79e540674a55@redhat.com>
 <CALMp9eSpEJrr6mNoLcGgV8Pa2abQUkPA1uwNBMJZWexBArB3gg@mail.gmail.com>
 <6f25273e-ad80-4d99-91df-1dd0c847af39@redhat.com>
 <CALMp9eTzJb0gnRzK_2MQyeO2kmrKJwyYYHE5eYEai+_LPg8HrQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <af716f56-9d68-2514-7b85-f9bbb1a82acf@redhat.com>
Date:   Wed, 23 Jun 2021 20:49:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CALMp9eTzJb0gnRzK_2MQyeO2kmrKJwyYYHE5eYEai+_LPg8HrQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/21 20:11, Jim Mattson wrote:
> On Wed, Jun 23, 2021 at 10:11 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>> Nah, that's not the philosophy.  The philosophy is that covering all
>> possible ways for userspace to shoot itself in the foot is impossible.
>>
>> However, here we're talking about 2 lines of code (thanks also to your
>> patches that add last_vmentry_cpu for completely unrelated reasons) to
>> remove a whole set of bullet/foot encounters.
> 
> What about the problems that arise when we have different CPUID tables
> for different vCPUs in the same VM? Can we just replace this
> hole-in-foot inducing ioctl with a KVM_VM_SET_CPUID ioctl on the VM
> level that has to be called before any vCPUs are created?

Are there any KVM bugs that this can fix?  The problem is that, unlike 
this case, it would be effectively impossible to deprecate 
KVM_SET_CPUID2 as a vcpu ioctl, so it would be hard to reap any benefits 
in KVM.

BTW, there is actually a theoretical usecase for KVM_SET_CPUID2 after 
KVM_RUN, which is to test OSes against microcode updates that hide, 
totally random example, the RTM bit.  But it's still not worth keeping 
it given 1) the bugs and complications in KVM, 2) if you really wanted 
that kind of testing so hard, the fact that you can just create a new 
vcpu file descriptor from scratch, possibly in cooperation with 
userspace MSR filtering 3) AFAIK no one has done that anyway in 15 years.

Paolo

