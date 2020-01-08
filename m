Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC4CF1349AB
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 18:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728378AbgAHRqg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 12:46:36 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:33111 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728347AbgAHRqg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Jan 2020 12:46:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578505595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JuFYytAGPZml7H3W4B01Bht6vOFHY4NDQEHoWMOGjN8=;
        b=C3A1CdlXdSBhZTqtlewywvMcEgW/NReBWrYxHXJCiV9inrJSwjkuA+YqqPKtCefWDRRiDg
        p60KkTqzbocgqUyO2VuabnI4G0aitEU2hdRF3ISAWia04rL8bDvJv26/VGBhhyo8RPinfh
        DyzUYkqemQhg1hFavCU6inCN8r4OLEs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-qtvXzH_UPI6yIk95YUn4Mw-1; Wed, 08 Jan 2020 12:46:34 -0500
X-MC-Unique: qtvXzH_UPI6yIk95YUn4Mw-1
Received: by mail-wm1-f69.google.com with SMTP id o24so575645wmh.0
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2020 09:46:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JuFYytAGPZml7H3W4B01Bht6vOFHY4NDQEHoWMOGjN8=;
        b=NEixT20pW/qlYvwVH10P6N/ot05ybe19PetFcUbK2x3wJ6HqSk9Am/GlhEyAk3QSP3
         VEXYStlCl9rHma0goPjG48zpPjkELB5VMu/5H3at5iBW3rvz9RFEL2Rtjisl9qKimL1y
         Hp5J9OTjypaK6y9duhHkmtbaqpJdEwVyE3IKoWvkdpHG/16EVowiSauIDauD6Ggo1Pwz
         XPCoz2jiIY3zbW5R0O3wScz99ybrwCHJKxf677nrRY+9nShRaEVfVNVyh9lQmqbSMyYd
         HWavbTs2bw8kNtDkx/Hj1MSnrlLBPe7wkKxCkiyzlsaQrj01T/zx4ZM1UTBTO59DWolv
         1BTA==
X-Gm-Message-State: APjAAAWDUMYYI9cWUdu7dyiDljfyxv6JxYGG+u7qW84EPWRII3d/6ULQ
        SZafYWEIRGdTRD2InusnXRNj3L6lo4heK5HtCHhz24rlJvoiZ5uw4SQv7SaNRGu9EDmnIREXs8K
        wSFhYuMDP9s4k
X-Received: by 2002:a5d:608e:: with SMTP id w14mr6193602wrt.256.1578505593075;
        Wed, 08 Jan 2020 09:46:33 -0800 (PST)
X-Google-Smtp-Source: APXvYqwEH0d86Wh6sBFvfpn3VoGN+xLAb2tLS/aUw364TALemF5JBmboHvINPJs8R4Ab1RlmC0wE9w==
X-Received: by 2002:a5d:608e:: with SMTP id w14mr6193582wrt.256.1578505592874;
        Wed, 08 Jan 2020 09:46:32 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c6d:4079:b74c:e329? ([2001:b07:6468:f312:c6d:4079:b74c:e329])
        by smtp.gmail.com with ESMTPSA id g2sm4899030wrw.76.2020.01.08.09.46.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 09:46:32 -0800 (PST)
Subject: Re: [PATCH RESEND v2 03/17] KVM: X86: Don't track dirty for
 KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20191221014938.58831-1-peterx@redhat.com>
 <20191221014938.58831-4-peterx@redhat.com>
 <cf232ce8-bc07-0192-580f-d08736980273@redhat.com>
 <20191223172737.GA81196@xz-x1>
 <851bd9ed-3ff3-6aef-725c-b586d819211c@redhat.com>
 <20191223201024.GB90172@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e56d4157-1a0a-3f45-0e02-ac7c10fccf96@redhat.com>
Date:   Wed, 8 Jan 2020 18:46:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191223201024.GB90172@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/12/19 21:10, Peter Xu wrote:
>> Yes, kvm->slots_lock is taken by x86_set_memory_region.  We need to move
>> that to the callers, of which several are already taking the lock (all
>> except vmx_set_tss_addr and kvm_arch_destroy_vm).
> OK, will do.  I'll directly replace the x86_set_memory_region() calls
> in kvm_arch_destroy_vm() to be __x86_set_memory_region() since IIUC
> the slots_lock is helpless when destroying the vm... then drop the
> x86_set_memory_region() helper in the next version.  Thanks,

Be careful because it may cause issues with lockdep.  Better just take
the lock.

Paolo

