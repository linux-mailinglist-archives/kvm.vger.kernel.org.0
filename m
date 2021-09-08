Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46C75403ADB
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 15:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349379AbhIHNn0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 09:43:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26520 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348970AbhIHNnZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Sep 2021 09:43:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631108537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fuGy5OOl1BDAOfZOmjSgNM6SnXA/iPvMi1tfPhWc/iI=;
        b=SNXc+W2auWzTNKp/VEk8vXrFxuov+gBoMZ/0WZF9O0ZGZcPGaRbE/vBX6tzmcchC5rNXX7
        ygRi0D5HgyOOd4SYvYr9XI9x7SI5xJ6eazW2zP0y+Lg0y2V/HLGL/ZkVTpu10cBJprCTgy
        B6ottX1q2lXvXCY+RYHZslQ256rqzGc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-579-6mX7FCQGOluuYEMOqBOwlw-1; Wed, 08 Sep 2021 09:42:16 -0400
X-MC-Unique: 6mX7FCQGOluuYEMOqBOwlw-1
Received: by mail-wm1-f72.google.com with SMTP id f17-20020a05600c155100b002f05f30ff03so1095653wmg.3
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 06:42:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=fuGy5OOl1BDAOfZOmjSgNM6SnXA/iPvMi1tfPhWc/iI=;
        b=sNiPmWraNhsdDj6pbnZhOBPiM4G05PlgCQvj3V5RKn9FJr24DSgt2cRDTCEW0Dmzt/
         IwAON3eKVyKzuXnnJqkCMNYVRmTyx0ny2N57DkbySa8UO+/lPtxULY5hRHKxb49pdJFj
         Qlhn4QHtmwzV4f/mz+85uADrj3+8jqQ08x2kzD7CNWXw7e0u22aVDnbS7OOWtW8F1Pqr
         IIkAMMurmlvYwNcOUYzCXOEKW7aVS1v4NI23+rFtSckJ6MUa+K8ZBhUiM3tafq4jPt/p
         vM4fwdQ76n5tTccfgGcjULIH2+CyT4GHdYIyusC3T0Scxw7pfrWmM7i7sWfNV5rtExEH
         OM6A==
X-Gm-Message-State: AOAM531sizp7gm/BZB9d8na4KcQniSnVn5tR6vgvHiY9qQev2Nvk55+j
        qh5wXeBtG0jURDuexycrmL1gjunnGozOdgMzpV6012NCgqAhp6N23jb33Kdgck69t2d8ryaOwKv
        cRpF5ijDcBT3F
X-Received: by 2002:a05:600c:3ba3:: with SMTP id n35mr3629815wms.166.1631108535277;
        Wed, 08 Sep 2021 06:42:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzvHcnnS7MP3mZPfZE2jXaaeg34pU4rY4GeR9ZOGIHALmoLe6qfMvd5sMR9ubN8iZrFnb7hyA==
X-Received: by 2002:a05:600c:3ba3:: with SMTP id n35mr3629794wms.166.1631108534994;
        Wed, 08 Sep 2021 06:42:14 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id r25sm2624372wrc.26.2021.09.08.06.42.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 06:42:14 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org
Subject: Re: [PATCH] KVM: nVMX: fix comments of handle_vmon()
In-Reply-To: <20210908130145.3uwmywgjaahyb6iw@linux.intel.com>
References: <20210908171731.18885-1-yu.c.zhang@linux.intel.com>
 <87lf474ci8.fsf@vitty.brq.redhat.com>
 <20210908130145.3uwmywgjaahyb6iw@linux.intel.com>
Date:   Wed, 08 Sep 2021 15:42:13 +0200
Message-ID: <87ilzb4216.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Yu Zhang <yu.c.zhang@linux.intel.com> writes:

> On Wed, Sep 08, 2021 at 11:55:59AM +0200, Vitaly Kuznetsov wrote:
>> Indeed,
>> 
>> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> 
>> On a slightly related note: we don't seem to reset
>> 'vmx->nested.vmxon_ptr' upon VMXOFF emulation; this is not a problem per
>> se as we never access it when !vmx->nested.vmxon but I'd still suggest
>> we do something like
>> 
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index bc6327950657..8beb41d02d21 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -290,6 +290,7 @@ static void free_nested(struct kvm_vcpu *vcpu)
>>  
>>         vmx->nested.vmxon = false;
>>         vmx->nested.smm.vmxon = false;
>> +       vmx->nested.vmxon_ptr = -1ull;
>>         free_vpid(vmx->nested.vpid02);
>>         vmx->nested.posted_intr_nv = -1;
>>         vmx->nested.current_vmptr = -1ull;
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index d7c5257eb5c0..2214e6bd4713 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -6884,6 +6884,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
>>  
>>         vcpu_setup_sgx_lepubkeyhash(vcpu);
>>  
>> +       vmx->nested.vmxon_ptr = -1ull;
>>         vmx->nested.posted_intr_nv = -1;
>>         vmx->nested.current_vmptr = -1ull;
>>         vmx->nested.hv_evmcs_vmptr = EVMPTR_INVALID;
>> 
>> to avoid issues in the future.
>> 
> Thanks, Vitaly. And above suggestion sounds reasonable to me. :)
>
> I can add this in V2 later, if no one objects. 
>

Sure, this is rather a separate patch. Thanks!

-- 
Vitaly

