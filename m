Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80A58247028
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 20:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730856AbgHQSEe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 14:04:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55060 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389187AbgHQSBJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Aug 2020 14:01:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597687265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qqyeS+9IC/amrYQ+e7XmNFqASQdZw1AwC4c5vP7yh44=;
        b=bdX7lSmt9KSC1C//3nxqh/AWgfkgjbadz+deHMGFpGcXC0N17Mk1HMCMhrgcb2BxlIKlQv
        bAey/qjaZ6P9DhLMBYVMnd3b6IjR47Z7tSodoGPkT01/2cU7VNRi2Vxp/jju4TEghJ1D6R
        +D83pfdB3oex7v+hYJcuK61eL92+W0I=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-D9Kij50nNXK7sLcJoOaa4g-1; Mon, 17 Aug 2020 14:01:03 -0400
X-MC-Unique: D9Kij50nNXK7sLcJoOaa4g-1
Received: by mail-wr1-f69.google.com with SMTP id d6so7334967wrv.23
        for <kvm@vger.kernel.org>; Mon, 17 Aug 2020 11:01:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qqyeS+9IC/amrYQ+e7XmNFqASQdZw1AwC4c5vP7yh44=;
        b=E48UFYbAnKHBJesO1GWA2fK7wPv5m5YU9jelPMpqTLU00qj2HxGCHFBY/h2yPqjoGA
         302BlrT57x317e/PJ+txAN82EZ1Whm86a3NG9Q57/6ng/mu9B1hsUoajlVmBJbNrOUHT
         JR3pjKqBRCoYsQYVeI0i5t9oSA44o1lMhi+181bhPK4RPJtg5gMq1tujdsXh5yG3E6a1
         44Jyen38eUwqAvan7PbGucG/a5ZqxL+8TsFhOiOz1LXtWF4iwGKRDW/Km+wU96/6PKqm
         //aJM63D6ajRoc0ioW+TRB3eIPG/jI8r7KVdkUTAIiNuUt7buiz/Wi8tDRSenH4wbeIY
         +PtA==
X-Gm-Message-State: AOAM532HIBuHYGG7IeXfJ2g7E808qvurQYVFsGTYKxBEFadQuAJhPKSX
        KRgkCtdOIYfgk69nt+fvTdo1L7bhkiNW+j1RktYJnC0llSRLYueESMUiSgN93wGNrVgU25vzKDK
        IduPAuc3/lPJp
X-Received: by 2002:a5d:4c47:: with SMTP id n7mr16354153wrt.91.1597687262367;
        Mon, 17 Aug 2020 11:01:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxAhxieT6QpX/fLPoPSTQkaGqwRYwftZmk8+5FwC8rtE7g/Sg70OBuAvNPg+GbA63ZR+JjROg==
X-Received: by 2002:a5d:4c47:: with SMTP id n7mr16354132wrt.91.1597687262126;
        Mon, 17 Aug 2020 11:01:02 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:a0d1:fc42:c610:f977? ([2001:b07:6468:f312:a0d1:fc42:c610:f977])
        by smtp.gmail.com with ESMTPSA id a10sm31354680wro.35.2020.08.17.11.01.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 11:01:01 -0700 (PDT)
Subject: Re: [PATCH v3 7/9] KVM: VMX: Add guest physical address check in EPT
 violation and misconfig
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Mohammed Gamal <mgamal@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org
References: <20200710154811.418214-1-mgamal@redhat.com>
 <20200710154811.418214-8-mgamal@redhat.com>
 <20200715230006.GF12349@linux.intel.com>
 <20200817172233.GF22407@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f3595331-07e2-55d8-d390-4f421d8e5561@redhat.com>
Date:   Mon, 17 Aug 2020 20:01:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200817172233.GF22407@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/08/20 19:22, Sean Christopherson wrote:
>> This splats when running the PKU unit test, although the test still passed.
>> I haven't yet spent the brain power to determine if this is a benign warning,
>> i.e. simply unexpected, or if permission_fault() fault truly can't handle PK
>> faults.

It's more or less unexpected; the error is in the caller.  This is not
an error code but an access mask so only U/F/W bits are valid.  Patch
sent, thanks.

Paolo

>>   WARNING: CPU: 25 PID: 5465 at arch/x86/kvm/mmu.h:197 paging64_walk_addr_generic+0x594/0x750 [kvm]
>>   Hardware name: Intel Corporation WilsonCity/WilsonCity, BIOS WLYDCRB1.SYS.0014.D62.2001092233 01/09/2020
>>   RIP: 0010:paging64_walk_addr_generic+0x594/0x750 [kvm]
>>   Code: <0f> 0b e9 db fe ff ff 44 8b 43 04 4c 89 6c 24 30 8b 13 41 39 d0 89
>>   RSP: 0018:ff53778fc623fb60 EFLAGS: 00010202
>>   RAX: 0000000000000001 RBX: ff53778fc623fbf0 RCX: 0000000000000007
>>   RDX: 0000000000000001 RSI: 0000000000000002 RDI: ff4501efba818000
>>   RBP: 0000000000000020 R08: 0000000000000005 R09: 00000000004000e7
>>   R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000007
>>   R13: ff4501efba818388 R14: 10000000004000e7 R15: 0000000000000000
>>   FS:  00007f2dcf31a700(0000) GS:ff4501f1c8040000(0000) knlGS:0000000000000000
>>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>   CR2: 0000000000000000 CR3: 0000001dea475005 CR4: 0000000000763ee0
>>   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>   DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>   PKRU: 55555554
>>   Call Trace:
>>    paging64_gva_to_gpa+0x3f/0xb0 [kvm]
>>    kvm_fixup_and_inject_pf_error+0x48/0xa0 [kvm]
>>    handle_exception_nmi+0x4fc/0x5b0 [kvm_intel]
>>    kvm_arch_vcpu_ioctl_run+0x911/0x1c10 [kvm]
>>    kvm_vcpu_ioctl+0x23e/0x5d0 [kvm]
>>    ksys_ioctl+0x92/0xb0
>>    __x64_sys_ioctl+0x16/0x20
>>    do_syscall_64+0x3e/0xb0
>>    entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>   ---[ end trace d17eb998aee991da ]---
> 
> Looks like this series got pulled for 5.9, has anyone looked into this?
> 

