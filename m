Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B2B23D73F
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 09:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbgHFH0J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 03:26:09 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:50784 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726204AbgHFH0F (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Aug 2020 03:26:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596698762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=8Kr6PVxIv0ilgCcjZONBE+baG7kiKGwF9rYrlS6BQWY=;
        b=TwoBMcC6DbfdwCyrqUR2i05TcWKOrZPVV0jKsg7lKdW0mLIXGRB3GSEmcD8WX9b+mjL/0e
        bydkd/eeDvqMaJEimrkCXPWfz8qFqiq0qXUsu/w6G9/fzTVNqMKFHlR23mgIsN0+BXHB6w
        /VJ5SScPANbkBNxU6w48mH7Pgpb4Ax8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-Has8BSrSPy-2oX40pg6KsQ-1; Thu, 06 Aug 2020 03:18:51 -0400
X-MC-Unique: Has8BSrSPy-2oX40pg6KsQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 689001005510;
        Thu,  6 Aug 2020 07:18:49 +0000 (UTC)
Received: from [10.36.112.9] (ovpn-112-9.ams2.redhat.com [10.36.112.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3D8EB6842F;
        Thu,  6 Aug 2020 07:18:35 +0000 (UTC)
Subject: Re: [for-5.2 v4 10/10] s390: Recognize host-trust-limitation option
To:     David Gibson <david@gibson.dropbear.id.au>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     dgilbert@redhat.com, frankja@linux.ibm.com, pair@us.ibm.com,
        qemu-devel@nongnu.org, pbonzini@redhat.com, brijesh.singh@amd.com,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-ppc@nongnu.org,
        kvm@vger.kernel.org, pasic@linux.ibm.com, qemu-s390x@nongnu.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Richard Henderson <rth@twiddle.net>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        mdroth@linux.vnet.ibm.com, Thomas Huth <thuth@redhat.com>
References: <20200724025744.69644-1-david@gibson.dropbear.id.au>
 <20200724025744.69644-11-david@gibson.dropbear.id.au>
 <20200727175040.7beca3dd.cohuck@redhat.com>
 <20200806061412.GB157233@yekko.fritz.box>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 WNyWQQ==
Organization: Red Hat GmbH
Message-ID: <47ec89ce-f0e2-d716-426a-3028ff0404ba@redhat.com>
Date:   Thu, 6 Aug 2020 09:18:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200806061412.GB157233@yekko.fritz.box>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06.08.20 08:14, David Gibson wrote:
> On Mon, Jul 27, 2020 at 05:50:40PM +0200, Cornelia Huck wrote:
>> On Fri, 24 Jul 2020 12:57:44 +1000
>> David Gibson <david@gibson.dropbear.id.au> wrote:
>>
>>> At least some s390 cpu models support "Protected Virtualization" (PV),
>>> a mechanism to protect guests from eavesdropping by a compromised
>>> hypervisor.
>>>
>>> This is similar in function to other mechanisms like AMD's SEV and
>>> POWER's PEF, which are controlled bythe "host-trust-limitation"
>>> machine option.  s390 is a slightly special case, because we already
>>> supported PV, simply by using a CPU model with the required feature
>>> (S390_FEAT_UNPACK).
>>>
>>> To integrate this with the option used by other platforms, we
>>> implement the following compromise:
>>>
>>>  - When the host-trust-limitation option is set, s390 will recognize
>>>    it, verify that the CPU can support PV (failing if not) and set
>>>    virtio default options necessary for encrypted or protected guests,
>>>    as on other platforms.  i.e. if host-trust-limitation is set, we
>>>    will either create a guest capable of entering PV mode, or fail
>>>    outright
>>>
>>>  - If host-trust-limitation is not set, guest's might still be able to
>>>    enter PV mode, if the CPU has the right model.  This may be a
>>>    little surprising, but shouldn't actually be harmful.
>>
>> This could be workable, I guess. Would like a second opinion, though.
>>
>>>
>>> To start a guest supporting Protected Virtualization using the new
>>> option use the command line arguments:
>>>     -object s390-pv-guest,id=pv0 -machine host-trust-limitation=pv0
>>>
>>> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
>>> ---
>>>  hw/s390x/pv.c | 61 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>>  1 file changed, 61 insertions(+)
>>>
>>> diff --git a/hw/s390x/pv.c b/hw/s390x/pv.c
>>> index ab3a2482aa..4bf3b345b6 100644
>>> --- a/hw/s390x/pv.c
>>> +++ b/hw/s390x/pv.c
>>> @@ -14,8 +14,11 @@
>>>  #include <linux/kvm.h>
>>>  
>>>  #include "cpu.h"
>>> +#include "qapi/error.h"
>>>  #include "qemu/error-report.h"
>>>  #include "sysemu/kvm.h"
>>> +#include "qom/object_interfaces.h"
>>> +#include "exec/host-trust-limitation.h"
>>>  #include "hw/s390x/ipl.h"
>>>  #include "hw/s390x/pv.h"
>>>  
>>> @@ -111,3 +114,61 @@ void s390_pv_inject_reset_error(CPUState *cs)
>>>      /* Report that we are unable to enter protected mode */
>>>      env->regs[r1 + 1] = DIAG_308_RC_INVAL_FOR_PV;
>>>  }
>>> +
>>> +#define TYPE_S390_PV_GUEST "s390-pv-guest"
>>> +#define S390_PV_GUEST(obj)                              \
>>> +    OBJECT_CHECK(S390PVGuestState, (obj), TYPE_S390_PV_GUEST)
>>> +
>>> +typedef struct S390PVGuestState S390PVGuestState;
>>> +
>>> +/**
>>> + * S390PVGuestState:
>>> + *
>>> + * The S390PVGuestState object is basically a dummy used to tell the
>>> + * host trust limitation system to use s390's PV mechanism.  guest.
>>> + *
>>> + * # $QEMU \
>>> + *         -object s390-pv-guest,id=pv0 \
>>> + *         -machine ...,host-trust-limitation=pv0
>>> + */
>>> +struct S390PVGuestState {
>>> +    Object parent_obj;
>>> +};
>>> +
>>> +static int s390_pv_kvm_init(HostTrustLimitation *gmpo, Error **errp)
>>> +{
>>> +    if (!s390_has_feat(S390_FEAT_UNPACK)) {
>>> +        error_setg(errp,
>>> +                   "CPU model does not support Protected Virtualization");
>>> +        return -1;
>>> +    }
>>> +
>>> +    return 0;
>>> +}
>>
>> So here's where I'm confused: If I follow the code correctly, the
>> ->kvm_init callback is invoked before kvm_arch_init() is called. The
>> kvm_arch_init() implementation for s390x checks whether
>> KVM_CAP_S390_PROTECTED is available, which is a pre-req for
>> S390_FEAT_UNPACK. Am I missing something? Can someone with access to PV
>> hardware check whether this works as intended?
> 
> Ah, yes, I need to rethink this.  kvm_arch_init() happens
> substantially earlier than I realized.  Plus the setup of s390 cpu
> models is confusing to me, it seems to set up the model after the cpu
> instance is created, rather than having cpu models correspond to cpu
> classes and thus existing before the cpus are actually instantiated.

The class only contains the cpu definition, the instance contains the
actual model. A definition is static and immutable at runtime (e.g., a
z15 with all possible features), a model is a variation of that (e.g.,
enable/disable features, e.g., a z15 with features available in the
current configuration).

We initialize the actual model in instance_init() (so during init, not
after init), where we create and initialize cpu->model, based on the cpu
definition in the class information (xcc->cpu_def).

In case of qemu/host/max model, we have to construct the cpu model at
init time, because the cpu model does not match an exact cpu definition
we have at hand.

So whenever we init a cpu, we already have to have kvm running such that
we can query the actual host/max model to construct cpu->model.

-- 
Thanks,

David / dhildenb

