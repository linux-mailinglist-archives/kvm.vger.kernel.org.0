Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C682615D581
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 11:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729125AbgBNK0R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 05:26:17 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:38297 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729014AbgBNK0R (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Feb 2020 05:26:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581675976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ONNmrAeewpZsw1kEozg1dZObc72nt/dFoN8o41OdwuM=;
        b=eiUoQu0+lyPojIBNmwXYc3QyOzRrbRkJWiEZEWpSfrLEI5dmzQZF2oWcH6PuQVK/Ota73q
        lqphiAOs6boHUScHJv3Gkx/DT7jQq2YuJLlR2rRA+ztVRR2FEUUulOC3FfQT1WNdyP2YDF
        g3W63v+wOGuAOO1lQvbz3o9Hr7i9vNA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-n6q_8a96OTCSpC1p1B6cew-1; Fri, 14 Feb 2020 05:26:07 -0500
X-MC-Unique: n6q_8a96OTCSpC1p1B6cew-1
Received: by mail-wm1-f71.google.com with SMTP id o24so3245462wmh.0
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2020 02:26:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ONNmrAeewpZsw1kEozg1dZObc72nt/dFoN8o41OdwuM=;
        b=Igq4L6LhM1o5rKFWCIm31tJkGawzoS3mIutn2xtExnB/BXVBJznpM4Zyq2xNkUMMf3
         ILN7SEJJ9q4WxJLGhupiFetGFQ5xGuETli2MmouwEap7aotgRPuhaUhm5dB2UC7iOnYg
         UUmKwWkQcynmfSq+vQ9f1/CH+NXgMz2UYjHym7wj+3/mP8Hxo4F+3V5S39jwKgXeWqTn
         wTgYeES7uGXkM6n9EGIoU/IOQmWy02LNpbAAA5Wdum+4RwUABkgV9zICqlKSDUCSwiYR
         ch7wNc4GodqP9y9do997B8X0ViSRFt6ztmz/tQOIKaDDLs4akImmUM1aFdqimeDaAMP1
         7Y9A==
X-Gm-Message-State: APjAAAXOy8542l+uK/T8gM/eErpD5zfsSkZS7oBBeGcIPfUH//NoNDGg
        jo+zfr+6INQqTZ5EOMFXNsQ8tF9kzGsPapCam4yoyQLZmDSkNYBeUHHK72nYmItgguJqkYxVjpl
        +xTOGi+I04XYC
X-Received: by 2002:a7b:c5cd:: with SMTP id n13mr3947483wmk.172.1581675966462;
        Fri, 14 Feb 2020 02:26:06 -0800 (PST)
X-Google-Smtp-Source: APXvYqxOxoyuoQgeKU8ruuYi1oJzwcvjf4P2mwb19V73aRm1o42eA+eLa0nXBJck5B62MHQXs5N2Sw==
X-Received: by 2002:a7b:c5cd:: with SMTP id n13mr3947459wmk.172.1581675966123;
        Fri, 14 Feb 2020 02:26:06 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:59c7:c3ee:2dec:d2b4? ([2001:b07:6468:f312:59c7:c3ee:2dec:d2b4])
        by smtp.gmail.com with ESMTPSA id v5sm6694372wrv.86.2020.02.14.02.26.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 02:26:05 -0800 (PST)
Subject: Re: [RFC PATCH 0/3] KVM: x86: honor guest memory type
To:     Chia-I Wu <olvaffe@gmail.com>
Cc:     kvm@vger.kernel.org, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org,
        Gurchetan Singh <gurchetansingh@chromium.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        ML dri-devel <dri-devel@lists.freedesktop.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200213213036.207625-1-olvaffe@gmail.com>
 <8fdb85ea-6441-9519-ae35-eaf91ffe8741@redhat.com>
 <CAPaKu7T8VYXTMc1_GOzJnwBaZSG214qNoqRr8c7Z4Lb3B7dtTg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b82cd76c-0690-c13b-cf2c-75d7911c5c61@redhat.com>
Date:   Fri, 14 Feb 2020 11:26:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CAPaKu7T8VYXTMc1_GOzJnwBaZSG214qNoqRr8c7Z4Lb3B7dtTg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/02/20 23:18, Chia-I Wu wrote:
> 
> The bug you mentioned was probably this one
> 
>   https://bugzilla.kernel.org/show_bug.cgi?id=104091

Yes, indeed.

> From what I can tell, the commit allowed the guests to create cached
> mappings to MMIO regions and caused MCEs.  That is different than what
> I need, which is to allow guests to create uncached mappings to system
> ram (i.e., !kvm_is_mmio_pfn) when the host userspace also has uncached
> mappings.  But it is true that this still allows the userspace & guest
> kernel to create conflicting memory types.

Right, the question is whether the MCEs were tied to MMIO regions 
specifically and if so why.

An interesting remark is in the footnote of table 11-7 in the SDM.  
There, for the MTRR (EPT for us) memory type UC you can read:

  The UC attribute comes from the MTRRs and the processors are not 
  required to snoop their caches since the data could never have
  been cached. This attribute is preferred for performance reasons.

There are two possibilities:

1) the footnote doesn't apply to UC mode coming from EPT page tables.
That would make your change safe.

2) the footnote also applies when the UC attribute comes from the EPT
page tables rather than the MTRRs.  In that case, the host should use
UC as the EPT page attribute if and only if it's consistent with the host
MTRRs; it would be more or less impossible to honor UC in the guest MTRRs.
In that case, something like the patch below would be needed.

It is not clear from the manual why the footnote would not apply to WC; that
is, the manual doesn't say explicitly that the processor does not do snooping
for accesses to WC memory.  But I guess that must be the case, which is why I
used MTRR_TYPE_WRCOMB in the patch below.

Either way, we would have an explanation of why creating cached mapping to
MMIO regions would, and why in practice we're not seeing MCEs for guest RAM
(the guest would have set WB for that memory in its MTRRs, not UC).

One thing you didn't say: how would userspace use KVM_MEM_DMA?  On which
regions would it be set?

Thanks,

Paolo

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index dc331fb06495..2be6f7effa1d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6920,8 +6920,16 @@ static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 	}
 
 	cache = kvm_mtrr_get_guest_memory_type(vcpu, gfn);
-
 exit:
+	if (cache == MTRR_TYPE_UNCACHABLE && !is_mmio) {
+		/*
+		 * We cannot set UC in the EPT page tables as it can cause
+		 * machine check exceptions (??).  Hopefully the guest is
+		 * using PAT.
+		 */
+		cache = MTRR_TYPE_WRCOMB;
+	}
+
 	return (cache << VMX_EPT_MT_EPTE_SHIFT) | ipat;
 }
 

