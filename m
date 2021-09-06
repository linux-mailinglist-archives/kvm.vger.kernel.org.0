Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2C0D40198C
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 12:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241736AbhIFKNx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 06:13:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43140 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241725AbhIFKNx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Sep 2021 06:13:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630923168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SVcn6/6NvEGeLtKGE4kybsnptb2WfjpMoWF/N6Bloa8=;
        b=Rx79XMh4xuNCY7NG0f4B7E3Av69qHQa59d/EfyAFd+bHWTlc36ytxrNpE0CkXpeQHXVrn9
        VAUFBIkTHoiaBR/BUgGdcEoKocqpqrfHi19uvv5Y7BrhipWWpUzU5jBwXXdAD50WETZ+0k
        lbkA/dhJSVzWzEnSywc0ym4nwf7jESY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-6pkVFsmyPyiH5S7GB0bTww-1; Mon, 06 Sep 2021 06:12:47 -0400
X-MC-Unique: 6pkVFsmyPyiH5S7GB0bTww-1
Received: by mail-wm1-f69.google.com with SMTP id u14-20020a7bcb0e0000b0290248831d46e4so3044029wmj.6
        for <kvm@vger.kernel.org>; Mon, 06 Sep 2021 03:12:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SVcn6/6NvEGeLtKGE4kybsnptb2WfjpMoWF/N6Bloa8=;
        b=KPK8q56ZkYcAsrMjRv6Dq+BD5ZOEiciqZzZAgn3+ksVkI6eTorpAMYtOcqyNbrWyQ/
         YfuWyp8Q+xj0xxyD9PPKG35N1PwVbctIIyg1Vq8lYfx1R7f/CaNsJy4VvYpll870er8H
         P6MPuPXfVvrq1fplefniJDTAufYRbrFLdDKF+sZwKBTrSBEaCTQSxxVq+aqeRVFKEHHP
         94X/8umVgL6HbCNFDRFUA0VwgodMPAtdO59211n9mxNHaf+Xtsqadxqq904kRSNB3ZFE
         P0X9exRdaRnlbEzaxb0EGTkGDvcWGWlyIfcG1DUxqACOQPI6UGoVBgz9ddEcJztMZKWs
         sFow==
X-Gm-Message-State: AOAM531RrgShLxwiXxidBE6KA41dm+fcXb0u5Yj3voMX34lYtllMD9B1
        zNh+CNUAo9w3pucuEEDsvCDsFS4A/tBnB3KgZknFJkFhXMrSaGP1n9CYGCjuXe8sC13ZECW2tlG
        o2bGjLjW2r6dl
X-Received: by 2002:adf:d0c3:: with SMTP id z3mr12541295wrh.108.1630923166058;
        Mon, 06 Sep 2021 03:12:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyreNwPUDBPG0zKybx6H2XCoqp1O97nFCIlEM5wR223B8etD4cuUMc4r0u5g//AGcIFTS+E4Q==
X-Received: by 2002:adf:d0c3:: with SMTP id z3mr12541279wrh.108.1630923165876;
        Mon, 06 Sep 2021 03:12:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s15sm7335982wrb.22.2021.09.06.03.12.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Sep 2021 03:12:45 -0700 (PDT)
Subject: Re: [PATCH v2 0/3] kvm: x86: Set KVM_MAX_VCPUS=1024,
 KVM_SOFT_MAX_VCPUS=710
To:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Juergen Gross <jgross@suse.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20210903211600.2002377-1-ehabkost@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1111efc8-b32f-bd50-2c0f-4c6f506b544b@redhat.com>
Date:   Mon, 6 Sep 2021 12:12:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210903211600.2002377-1-ehabkost@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/09/21 23:15, Eduardo Habkost wrote:
> This:
> - Increases KVM_MAX_VCPUS 288 to 1024.
> - Increases KVM_MAX_VCPU_ID from 1023 to 4096.
> - Increases KVM_SOFT_MAX_VCPUS from 240 to 710.
> 
> Note that this conflicts with:
>    https://lore.kernel.org/lkml/20210903130808.30142-1-jgross@suse.com
>    Date: Fri,  3 Sep 2021 15:08:01 +0200
>    From: Juergen Gross <jgross@suse.com>
>    Subject: [PATCH v2 0/6] x86/kvm: add boot parameters for max vcpu configs
>    Message-Id: <20210903130808.30142-1-jgross@suse.com>
> 
> I don't intend to block Juergen's work.  I will be happy to
> rebase and resubmit in case Juergen's series is merged first.
> However, I do propose that we set the values above as the default
> even if Juergen's series is merged.
> 
> The additional overhead (on x86_64) of the new defaults will be:
> - struct kvm_ioapic will grow from 1628 to 5084 bytes.
> - struct kvm will grow from 19328 to 22272 bytes.
> - Bitmap stack variables that will grow:
> - At kvm_hv_flush_tlb() & kvm_hv_send_ipi(),
>    vp_bitmap[] and vcpu_bitmap[] will now be 128 bytes long
> - vcpu_bitmap at bioapic_write_indirect() will be 128 bytes long
>    once patch "KVM: x86: Fix stack-out-of-bounds memory access
>    from ioapic_write_indirect()" is applied
> 
> Changes v1 -> v2:
> * KVM_MAX_VCPUS is now 1024 (v1 set it to 710)
> * KVM_MAX_VCPU_ID is now 4096 (v1 left it unchanged, at 1023)
> 
> v1 of this series was:
> 
>    https://lore.kernel.org/lkml/20210831204535.1594297-1-ehabkost@redhat.com
>    Date: Tue, 31 Aug 2021 16:45:35 -0400
>    From: Eduardo Habkost <ehabkost@redhat.com>
>    Subject: [PATCH] kvm: x86: Increase MAX_VCPUS to 710
>    Message-Id: <20210831204535.1594297-1-ehabkost@redhat.com>
> 
> Eduardo Habkost (3):
>    kvm: x86: Set KVM_MAX_VCPU_ID to 4*KVM_MAX_VCPUS
>    kvm: x86: Increase MAX_VCPUS to 1024
>    kvm: x86: Increase KVM_SOFT_MAX_VCPUS to 710
> 
>   arch/x86/include/asm/kvm_host.h | 18 +++++++++++++++---
>   1 file changed, 15 insertions(+), 3 deletions(-)
> 

Queued, thanks.

Paolo

