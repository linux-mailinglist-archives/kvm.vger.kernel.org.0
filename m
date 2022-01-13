Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9C048D348
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 09:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232535AbiAMIAx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 03:00:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:53310 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231223AbiAMIAw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jan 2022 03:00:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642060852;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yrpcw7YUTOUtHCgNDfajqgyLxv5jTMntW/pzZ7ls5fc=;
        b=GRw32gOrb9EIM94PCpClHHhWRczDt1sXp6E2T9gH93lOXsytRTYnVloj57yIrNq5eRAuo7
        CsKerfKGYacl0ewlec0f6gx9/35GjLtdOzoSM9JYMXUVBsW1TjC4HuXHRQHSzJWJxmFCwM
        UeGQfL8uv0ajzWB2QsSXwMI+I+lepXU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-511-ythulDzxPZaGrVntYfIi7g-1; Thu, 13 Jan 2022 03:00:48 -0500
X-MC-Unique: ythulDzxPZaGrVntYfIi7g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EAE5F100C611;
        Thu, 13 Jan 2022 08:00:46 +0000 (UTC)
Received: from [10.72.13.202] (ovpn-13-202.pek2.redhat.com [10.72.13.202])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 018266E1EF;
        Thu, 13 Jan 2022 08:00:38 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v4 06/15] KVM: arm64: Add paravirtualization header files
To:     Eric Auger <eauger@redhat.com>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
        shan.gavin@gmail.com, Jonathan.Cameron@huawei.com,
        pbonzini@redhat.com, vkuznets@redhat.com, will@kernel.org
References: <20210815005947.83699-1-gshan@redhat.com>
 <20210815005947.83699-7-gshan@redhat.com>
 <82506a31-7b32-f8e2-c0cb-0f39d204ef3a@redhat.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <0335878f-2dc0-edc3-97ec-3f4d6ed01b48@redhat.com>
Date:   Thu, 13 Jan 2022 16:00:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <82506a31-7b32-f8e2-c0cb-0f39d204ef3a@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 11/11/21 2:06 AM, Eric Auger wrote:
> On 8/15/21 2:59 AM, Gavin Shan wrote:
>> We need put more stuff in the paravirtualization header files when
>> the asynchronous page fault is supported. The generic header files
>> can't meet the goal.
> you need to explain why
>   This duplicate the generic header files to be
> s/This duplicate/Duplicate

Ok.

>> our platform specific header files. It's the preparatory work to
>> support the asynchronous page fault in the subsequent patches:
> why duplication and not move. Shouldn't it be squashed with another
> subsequent patch?
> 

It's also fine to squash this one to PATCH[v4 07/15]. My intent was
to keep them separate to make PATCH[v4 07/17] a bit easier to be
reviewed. So lets keep it as separate patch :)

>>
>>     include/uapi/asm-generic/kvm_para.h
>>     include/asm-generic/kvm_para.h
>>
>>     arch/arm64/include/uapi/asm/kvm_para.h
>>     arch/arm64/include/asm/kvm_para.h
>>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>>   arch/arm64/include/asm/kvm_para.h      | 27 ++++++++++++++++++++++++++
>>   arch/arm64/include/uapi/asm/Kbuild     |  2 --
>>   arch/arm64/include/uapi/asm/kvm_para.h |  5 +++++
>>   3 files changed, 32 insertions(+), 2 deletions(-)
>>   create mode 100644 arch/arm64/include/asm/kvm_para.h
>>   create mode 100644 arch/arm64/include/uapi/asm/kvm_para.h
>>
>> diff --git a/arch/arm64/include/asm/kvm_para.h b/arch/arm64/include/asm/kvm_para.h
>> new file mode 100644
>> index 000000000000..0ea481dd1c7a
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/kvm_para.h
>> @@ -0,0 +1,27 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#ifndef _ASM_ARM_KVM_PARA_H
>> +#define _ASM_ARM_KVM_PARA_H
>> +
>> +#include <uapi/asm/kvm_para.h>
>> +
>> +static inline bool kvm_check_and_clear_guest_paused(void)
>> +{
>> +	return false;
>> +}
>> +
>> +static inline unsigned int kvm_arch_para_features(void)
>> +{
>> +	return 0;
>> +}
>> +
>> +static inline unsigned int kvm_arch_para_hints(void)
>> +{
>> +	return 0;
>> +}
>> +
>> +static inline bool kvm_para_available(void)
>> +{
>> +	return false;
>> +}
>> +
>> +#endif /* _ASM_ARM_KVM_PARA_H */
>> diff --git a/arch/arm64/include/uapi/asm/Kbuild b/arch/arm64/include/uapi/asm/Kbuild
>> index 602d137932dc..f66554cd5c45 100644
>> --- a/arch/arm64/include/uapi/asm/Kbuild
>> +++ b/arch/arm64/include/uapi/asm/Kbuild
>> @@ -1,3 +1 @@
>>   # SPDX-License-Identifier: GPL-2.0
>> -
>> -generic-y += kvm_para.h
>> diff --git a/arch/arm64/include/uapi/asm/kvm_para.h b/arch/arm64/include/uapi/asm/kvm_para.h
>> new file mode 100644
>> index 000000000000..cd212282b90c
>> --- /dev/null
>> +++ b/arch/arm64/include/uapi/asm/kvm_para.h
>> @@ -0,0 +1,5 @@
>> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>> +#ifndef _UAPI_ASM_ARM_KVM_PARA_H
>> +#define _UAPI_ASM_ARM_KVM_PARA_H
>> +
>> +#endif /* _UAPI_ASM_ARM_KVM_PARA_H */
>>

Thanks,
Gavin

