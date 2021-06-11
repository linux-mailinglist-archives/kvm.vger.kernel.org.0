Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F993A431C
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 15:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbhFKNhB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 09:37:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27276 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229517AbhFKNhA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Jun 2021 09:37:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623418502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zlTvKdwzw5MkeEEEC9I9PiSc9XRaRFcAGdPS/4M7/T4=;
        b=FRqFKLZsbjoyQruyeiFbH0viF18e7E3266p2IR93NUzAS3/Hn2icFRVHyulwND6ae0khkQ
        Nt9ab2cu9LOa1e+JaNUyg86a5s4sfEMN0XKllXUjrYmulByi5lWUDFp+TDDyohKbM5x93F
        YYtMruKjkOc0KMfeE9PCiSE+Zsf3fto=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-524-U81UOtwcMJ25yFIARdF6Ig-1; Fri, 11 Jun 2021 09:35:00 -0400
X-MC-Unique: U81UOtwcMJ25yFIARdF6Ig-1
Received: by mail-wr1-f69.google.com with SMTP id k11-20020adfe3cb0000b0290115c29d165cso2643592wrm.14
        for <kvm@vger.kernel.org>; Fri, 11 Jun 2021 06:35:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zlTvKdwzw5MkeEEEC9I9PiSc9XRaRFcAGdPS/4M7/T4=;
        b=jUrEXhv3n4HzwxbxGfBmf4zuWUbj5a0EGd41n+3EsagtTX3CMq6UuLrsUyeIx/+UVK
         z+AO5qbvUv6ZLzAeJT0DdZGgkW5XQqLVr/cHSP8NUD39udkoqcoYXS+vAxhgjfImxg6z
         7D1gfdULTpnQUlmK0WVq5FFGT14pBKLKcwsy2QvARkXuz9JRjbXtudTGVyzJ3oITcZHE
         4VnWC5KkL1AiDJ3RBMRcYVq5YPLLV5I2NXtxuPlNJLWDJDDgkBR2drsChnccIuPn++FJ
         bxvzqB7N5rwwIOsw6pHZGwY/dTY+YNoXzoDd22iWfjFEl4PKScKyW5pMW3Wl+hf7HqDi
         iRJg==
X-Gm-Message-State: AOAM531MWpvvAIdbF0X/2y9ztKadrCauveR/2mcoZFt8F0S36DzcIgn5
        B6e/2MhtPqbdzgJbVLTvzHvNq04zTfQM3zIRXDFsEC4m1PS0qR2VUtwctgPkBnXMW0C1Gtupx6Y
        L8IT1XMkfO/k+
X-Received: by 2002:a5d:59a9:: with SMTP id p9mr4118992wrr.86.1623418499453;
        Fri, 11 Jun 2021 06:34:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyQM71M7BxbgLxkAQ6Zmo10Dt54e39XGmZG2f98CnpQkRKj9ZJdrEctz2F/sjq+A79DdtQBVQ==
X-Received: by 2002:a5d:59a9:: with SMTP id p9mr4118955wrr.86.1623418499200;
        Fri, 11 Jun 2021 06:34:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id t4sm7169792wru.53.2021.06.11.06.34.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jun 2021 06:34:58 -0700 (PDT)
To:     Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        KVMARM <kvmarm@lists.cs.columbia.edu>,
        LinuxMIPS <linux-mips@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        LinuxS390 <linux-s390@vger.kernel.org>,
        Linuxkselftest <linux-kselftest@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
References: <20210611124624.1404010-1-jingzhangos@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v8 0/4] KVM statistics data fd-based binary interface
Message-ID: <d9d440f0-ac2d-5a90-4e90-5eaa365f422e@redhat.com>
Date:   Fri, 11 Jun 2021 15:34:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210611124624.1404010-1-jingzhangos@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/06/21 14:46, Jing Zhang wrote:
> This patchset provides a file descriptor for every VM and VCPU to read
> KVM statistics data in binary format.
> It is meant to provide a lightweight, flexible, scalable and efficient
> lock-free solution for user space telemetry applications to pull the
> statistics data periodically for large scale systems. The pulling
> frequency could be as high as a few times per second.
> In this patchset, every statistics data are treated to have some
> attributes as below:
>    * architecture dependent or generic
>    * VM statistics data or VCPU statistics data
>    * type: cumulative, instantaneous,
>    * unit: none for simple counter, nanosecond, microsecond,
>      millisecond, second, Byte, KiByte, MiByte, GiByte. Clock Cycles
> Since no lock/synchronization is used, the consistency between all
> the statistics data is not guaranteed. That means not all statistics
> data are read out at the exact same time, since the statistics date
> are still being updated by KVM subsystems while they are read out.

The binary interface itself looks good.  Can you do a follow-up patch to 
remove struct kvm_stats_debugfs_item and avoid the duplication?  I'd 
rather have that too before committing the code.

Thanks,

Paolo

