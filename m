Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 510CE2F50FA
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 18:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbhAMRUE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 12:20:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24370 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728033AbhAMRUE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 12:20:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610558318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A5hNzXnRtBLkRY+uChUouzv6yCzi7yuTb2zBLYxeP94=;
        b=J1vUH/hoUkf5rwYxU8UNNDXqj9aedtiico9xrcbpLYMSb4NacWUCSSUqqwnvbWNpwaV+f/
        GOninNBHYrANYcnVAWmORBwV4+m1913ZIiG4sd1K+m4Y1UBgje4NvSSuE0IR9VOrU3Q4RC
        CkaHlUw7LkwRuqaktKmotpsuIblcgvo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-CS-aG-nUM0mMe2mBZ18P1A-1; Wed, 13 Jan 2021 12:18:23 -0500
X-MC-Unique: CS-aG-nUM0mMe2mBZ18P1A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F62380A5C0;
        Wed, 13 Jan 2021 17:18:22 +0000 (UTC)
Received: from [10.36.114.165] (ovpn-114-165.ams2.redhat.com [10.36.114.165])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4581074AA9;
        Wed, 13 Jan 2021 17:18:19 +0000 (UTC)
Subject: Re: [PATCH 6/9] docs: kvm: devices/arm-vgic-v3: enhance
 KVM_DEV_ARM_VGIC_CTRL_INIT doc
To:     Alexandru Elisei <alexandru.elisei@arm.com>,
        eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        drjones@redhat.com
Cc:     james.morse@arm.com, julien.thierry.kdev@gmail.com,
        suzuki.poulose@arm.com, shuah@kernel.org, pbonzini@redhat.com
References: <20201212185010.26579-1-eric.auger@redhat.com>
 <20201212185010.26579-7-eric.auger@redhat.com>
 <4c0b3988-904c-a922-d0be-87a354c3203c@arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <0f6f4848-b7df-9e9f-8b25-5009a5650350@redhat.com>
Date:   Wed, 13 Jan 2021 18:18:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <4c0b3988-904c-a922-d0be-87a354c3203c@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alexandru,

On 1/12/21 4:39 PM, Alexandru Elisei wrote:
> Hi Eric,
> 
> On 12/12/20 6:50 PM, Eric Auger wrote:
>> kvm_arch_vcpu_precreate() returns -EBUSY if the vgic is
>> already initialized. So let's document that KVM_DEV_ARM_VGIC_CTRL_INIT
>> must be called after all vcpu creations.
> 
> Checked and this is indeed the case,
> kvm_vm_ioctl_create_vcpu()->kvm_arch_vcpu_precreate() returns -EBUSY is
> vgic_initialized() is true.
thanks!
> 
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> ---
>>  Documentation/virt/kvm/devices/arm-vgic-v3.rst | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/Documentation/virt/kvm/devices/arm-vgic-v3.rst b/Documentation/virt/kvm/devices/arm-vgic-v3.rst
>> index 5dd3bff51978..322de6aebdec 100644
>> --- a/Documentation/virt/kvm/devices/arm-vgic-v3.rst
>> +++ b/Documentation/virt/kvm/devices/arm-vgic-v3.rst
>> @@ -228,7 +228,7 @@ Groups:
>>  
>>      KVM_DEV_ARM_VGIC_CTRL_INIT
>>        request the initialization of the VGIC, no additional parameter in
>> -      kvm_device_attr.addr.
>> +      kvm_device_attr.addr. Must be called after all vcpu creations.
> 
> Nitpick here: the document writes VCPU with all caps. This also sounds a bit
> weird, I think something like "Must be called after all VCPUs have been created"
> is clearer.
I took your suggestion.

Thanks

Eric
> 
> Thanks,
> Alex
>>      KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES
>>        save all LPI pending bits into guest RAM pending tables.
>>  
> 

