Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A158527CBCC
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 14:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732961AbgI2Mas (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 08:30:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38686 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728922AbgI2L3Y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 07:29:24 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601378941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Jgd9+IvcGT8+fG9kgn+qU1iqHDwGn9/rK0K5vQ757us=;
        b=XaBXvrCBo7C+TIY1v+/9Nllr8xK4QYDutPIrQCdr8fGyYT5bLPHpXaVNNfwwf46z3J+CTt
        Y6KEjHSqQaekiYntcEujjpMwZPLu5qsdiKL+YjGVB88DCmgWXYvjvTTnkBZSj7AZjZxc3n
        BlsfiCxvW5ytPiTwOc7n1Orepwb0Onk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-Y2_r3N1sM1GBS9R5ZKxqOw-1; Tue, 29 Sep 2020 07:26:39 -0400
X-MC-Unique: Y2_r3N1sM1GBS9R5ZKxqOw-1
Received: by mail-wm1-f72.google.com with SMTP id x6so1713212wmi.1
        for <kvm@vger.kernel.org>; Tue, 29 Sep 2020 04:26:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Jgd9+IvcGT8+fG9kgn+qU1iqHDwGn9/rK0K5vQ757us=;
        b=MjnKG5g/3ZCBs5q1dCNK/KamQgwxUI49/2a8MfkBf4piPLCIa2JNyuN2uOESoYSgrH
         En4gEvkFU4crksDTxraRu9wiHmQmMnc/5+Esluh2SpNT/ls05IjNLIQ0p4bJBVNf2FCi
         bhPcwo8gYX1b+8PDFHH1Sy3Ip8yo3Y/2hCAtSbO5wSk4SRglFXd+KGiGstfix2x3EVsB
         cJfs7rNvptHNADYL4L2gLMgGd69c5uxwOpbxfzB+PlheYXpaFRYxuYS1tnVzHa8EuvqU
         NrbA/cAoAQEsRehLnxnWqNjvytOcnwX5Jn/jVjexP6tGfKikIo+45BLKZfJvt4xvl5nM
         W9bw==
X-Gm-Message-State: AOAM532VCuQE2qwY5MLJo4WozCIEUH8DipWDK5xMXuYcNMq06TpdaOrK
        JdJPH3DbmbmXfGiAHGzPPXixICKgwwj3bltumicxdy8cN6ObbcX9AszhXrbmccorMQ47UT8jzS8
        +w4Ijnkv+jFmI
X-Received: by 2002:a7b:c192:: with SMTP id y18mr3898921wmi.108.1601378798018;
        Tue, 29 Sep 2020 04:26:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwyxP52XOengRaEtx3AULabzHo2vMHQxAZX3YMtDk64jHdZoOKQWBO6sgitlALK/aRFssPWCA==
X-Received: by 2002:a7b:c192:: with SMTP id y18mr3898895wmi.108.1601378797780;
        Tue, 29 Sep 2020 04:26:37 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id a10sm5010727wmj.38.2020.09.29.04.26.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 04:26:37 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Jon Doron <arilou@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/7] KVM: x86: hyper-v: always advertise HV_STIMER_DIRECT_MODE_AVAILABLE
In-Reply-To: <34ea6c7c-6c10-5cdb-de75-6b4afc023dd2@redhat.com>
References: <20200924145757.1035782-1-vkuznets@redhat.com> <20200924145757.1035782-5-vkuznets@redhat.com> <ded79131-bef1-cb56-68ca-d2bc596a4425@redhat.com> <875z7wdg43.fsf@vitty.brq.redhat.com> <34ea6c7c-6c10-5cdb-de75-6b4afc023dd2@redhat.com>
Date:   Tue, 29 Sep 2020 13:26:36 +0200
Message-ID: <87lfgsbz83.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 29/09/20 12:36, Vitaly Kuznetsov wrote:
>>> Sorry for the late reply.  I think this is making things worse.  It's
>>> obviously okay to add a system KVM_GET_SUPPORTED_HV_CPUID, and I guess
>>> it makes sense to have bits in there that require to enable a
>>> capability.  For example, KVM_GET_SUPPORTED_CPUID has a couple bits such
>>> as X2APIC, that we return even if they require in-kernel irqchip.
>>>
>>> For the vCPU version however we should be able to copy the returned
>>> leaves to KVM_SET_CPUID2, meaning that unsupported features should be
>>> masked.
>> What I don't quite like about exposing HV_STIMER_DIRECT_MODE_AVAILABLE
>> conditionally is that we're requiring userspace to have a certain
>> control flow: first, it needs to create irqchip and only then call
>> KVM_GET_SUPPORTED_HV_CPUID or it won't know that
>> HV_STIMER_DIRECT_MODE_AVAILABLE is supported. 
>> 
>> Also, are you only concerned about HV_STIMER_DIRECT_MODE_AVAILABLE? E.g.
>> PATCH3 of this series is somewhat similar, it exposes eVMCS even when
>> the corresponding CAP wasn't enabled.
>
> All of them, but this was only about the vCPU ioctl.  I agree with you
> that the system ioctl should return everything unconditionally.
>
> But perhaps the best thing to do is to deprecate the vCPU ioctl and just
> leave it as is with all its quirks.
>

Ok, I'll do exactly that. I'm not sure if there are any
KVM_GET_SUPPORTED_HV_CPUID users out there bisedes QEMU/selftest but
let's take the 'safest' approach.

-- 
Vitaly

