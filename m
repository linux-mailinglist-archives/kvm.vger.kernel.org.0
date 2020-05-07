Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6AEA1C8407
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 09:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725849AbgEGH5b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 03:57:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30145 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725900AbgEGH5a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 May 2020 03:57:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588838249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=94+p4rTx3aXgc1s8HtnXaNBbbzovzVYBrsIG0gSLOL0=;
        b=cFP21NDtUbz/Zzl4b3C3l/TiWH4zX+aLkk36UTcWWB3L0Nosfs/DXat60cyBEsNbI0QoVo
        6hogHOu+A3tSlffiyn18sEVf323bPZAerY3S2pk1m+0Wg2QNAI4ExDb9RYyEivvgtdXdyr
        F3Q5nwAvjsyl0ia+R5tYdO3YbeazuLM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-3T9-L8_pN6GS_ZhT3SbRsg-1; Thu, 07 May 2020 03:57:27 -0400
X-MC-Unique: 3T9-L8_pN6GS_ZhT3SbRsg-1
Received: by mail-wr1-f71.google.com with SMTP id 30so2911853wrq.15
        for <kvm@vger.kernel.org>; Thu, 07 May 2020 00:57:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=94+p4rTx3aXgc1s8HtnXaNBbbzovzVYBrsIG0gSLOL0=;
        b=jZ5UduajoaY0g+zlV5XlxxS60FFXXSevOTA9hG8Qr+ayGLVJ7bbXMiyIIJVWvtMzyR
         LCQWjoZwHpQOuaHnJHk7oEao5NDew2NJCUpNTT9EvhkDgsS23FTZA5pkK7EiJRp/dnhY
         gozRPpz+aICS9QWCSYREJ7wuJ2i4oMDhWhv3EJgjX8GPVlL5NZ3ek3PgrxN/D4pmWDyd
         8bqtjGLm1+x+gfyC65/ht437o8FifRp2p6WtFiIBe3CQlV6dZDQxwxe2gKsULWU/YKPP
         FZF3V2lJGtEVd/WkZkXvNWkZixUug7801igl1NNbfVufqD3ULHJsf/JPVGfZpxhErdRG
         nNYQ==
X-Gm-Message-State: AGi0PuYS3ARLo9qtCEzaVpiIhFKJap1oDDXhJGGAEBXKnCIvpj534e2A
        MQy3lM39uEn9Oe8mnlAzMWISvduYCLqJ6N/4Osguu+4lL58ffcM56CzdXrv0UBvV5dyEyOmxpKw
        BUoWRlxO/vhFx
X-Received: by 2002:a1c:5402:: with SMTP id i2mr8528339wmb.2.1588838245996;
        Thu, 07 May 2020 00:57:25 -0700 (PDT)
X-Google-Smtp-Source: APiQypLS9zfhthG/IcPQ1OXwTaDPpA5GtnV/LzhaWTU+KmBhNY4Vze9DeatJeXZ7ts1IL1uZA+t+sQ==
X-Received: by 2002:a1c:5402:: with SMTP id i2mr8528315wmb.2.1588838245719;
        Thu, 07 May 2020 00:57:25 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:8d3e:39e5:cd88:13cc? ([2001:b07:6468:f312:8d3e:39e5:cd88:13cc])
        by smtp.gmail.com with ESMTPSA id v124sm4823503wme.45.2020.05.07.00.57.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 00:57:25 -0700 (PDT)
Subject: Re: [PATCH v11 0/7] x86/kvm/hyper-v: add support for synthetic
 debugger
To:     Jon Doron <arilou@gmail.com>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com
References: <20200424113746.3473563-1-arilou@gmail.com>
 <20200507030141.GF2862@jondnuc>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d1a07fdd-c9ae-a042-3325-54a5cf42dab5@redhat.com>
Date:   Thu, 7 May 2020 09:57:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200507030141.GF2862@jondnuc>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/05/20 05:01, Jon Doron wrote:
> Paolo was this merged in or by any chance in the queue?

No, I'll get to it today.

Paolo

> Thanks,
> -- Jon.
> 
> On 24/04/2020, Jon Doron wrote:
>> Add support for the synthetic debugger interface of hyper-v, the
>> synthetic debugger has 2 modes.
>> 1. Use a set of MSRs to send/recv information (undocumented so it's not
>>   going to the hyperv-tlfs.h)
>> 2. Use hypercalls
>>
>> The first mode is based the following MSRs:
>> 1. Control/Status MSRs which either asks for a send/recv .
>> 2. Send/Recv MSRs each holds GPA where the send/recv buffers are.
>> 3. Pending MSR, holds a GPA to a PAGE that simply has a boolean that
>>   indicates if there is data pending to issue a recv VMEXIT.
>>
>> The first mode implementation is to simply exit to user-space when
>> either the control MSR or the pending MSR are being set.
>> Then it's up-to userspace to implement the rest of the logic of
>> sending/recving.
>>
>> In the second mode instead of using MSRs KNet will simply issue
>> Hypercalls with the information to send/recv, in this mode the data
>> being transferred is UDP encapsulated, unlike in the previous mode in
>> which you get just the data to send.
>>
>> The new hypercalls will exit to userspace which will be incharge of
>> re-encapsulating if needed the UDP packets to be sent.
>>
>> There is an issue though in which KDNet does not respect the hypercall
>> page and simply issues vmcall/vmmcall instructions depending on the cpu
>> type expecting them to be handled as it a real hypercall was issued.
>>
>> It's important to note that part of this feature has been subject to be
>> removed in future versions of Windows, which is why some of the
>> defintions will not be present the the TLFS but in the kvm hyperv header
>> instead.
>>
>> v11:
>> Fixed all reviewed by and rebased on latest origin/master
>>
>> Jon Doron (6):
>>  x86/kvm/hyper-v: Explicitly align hcall param for kvm_hyperv_exit
>>  x86/kvm/hyper-v: Simplify addition for custom cpuid leafs
>>  x86/hyper-v: Add synthetic debugger definitions
>>  x86/kvm/hyper-v: Add support for synthetic debugger capability
>>  x86/kvm/hyper-v: enable hypercalls without hypercall page with syndbg
>>  x86/kvm/hyper-v: Add support for synthetic debugger via hypercalls
>>
>> Vitaly Kuznetsov (1):
>>  KVM: selftests: update hyperv_cpuid with SynDBG tests
>>
>> Documentation/virt/kvm/api.rst                |  18 ++
>> arch/x86/include/asm/hyperv-tlfs.h            |   6 +
>> arch/x86/include/asm/kvm_host.h               |  14 +
>> arch/x86/kvm/hyperv.c                         | 242 ++++++++++++++++--
>> arch/x86/kvm/hyperv.h                         |  33 +++
>> arch/x86/kvm/trace.h                          |  51 ++++
>> arch/x86/kvm/x86.c                            |  13 +
>> include/uapi/linux/kvm.h                      |  13 +
>> .../selftests/kvm/x86_64/hyperv_cpuid.c       | 143 +++++++----
>> 9 files changed, 468 insertions(+), 65 deletions(-)
>>
>> -- 
>> 2.24.1
>>
> 

