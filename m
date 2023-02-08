Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAD2668F7F8
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 20:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbjBHTYS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 14:24:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjBHTYR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 14:24:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA9C166FB
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 11:23:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675884209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WxBVQWvtV/aawV7jPIrjgAv15SXqVJVUYMjJJSkpsFg=;
        b=A/wMYdudP9sk28hFE+FykZbx+5ICWGwbt9oJltQUvImzkKdRsLJdu4zoG/pGjSXOIOncMU
        JVbtpDzWqgMBuQRXg9J4WYxTq2/s2To49kQgMu0bqJFzoucSfOX8YvDpXPOOxfAzBbOi5/
        xsvhIsp3DamYdZHKf9AqwUG0LwBkih0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-124-3Gg_7N3ePyWW5Y8oiEN4hQ-1; Wed, 08 Feb 2023 14:23:27 -0500
X-MC-Unique: 3Gg_7N3ePyWW5Y8oiEN4hQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 479FA8564E1;
        Wed,  8 Feb 2023 19:23:26 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.193.101])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 206C51121315;
        Wed,  8 Feb 2023 19:23:26 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id 0E5A421E6A1F; Wed,  8 Feb 2023 20:23:25 +0100 (CET)
From:   Markus Armbruster <armbru@redhat.com>
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org,
        qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Subject: Re: [PATCH v15 10/11] qapi/s390x/cpu topology: CPU_POLARITY_CHANGE
 qapi event
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
        <20230201132051.126868-11-pmorel@linux.ibm.com>
        <5b26ee514ccbbfaf5670cbf0cb006d8e706fe5ae.camel@linux.ibm.com>
Date:   Wed, 08 Feb 2023 20:23:25 +0100
In-Reply-To: <5b26ee514ccbbfaf5670cbf0cb006d8e706fe5ae.camel@linux.ibm.com>
        (Nina Schoetterl-Glausch's message of "Wed, 08 Feb 2023 18:35:39
        +0100")
Message-ID: <87y1p8q7v6.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nina Schoetterl-Glausch <nsg@linux.ibm.com> writes:

> On Wed, 2023-02-01 at 14:20 +0100, Pierre Morel wrote:
>> When the guest asks to change the polarity this change
>> is forwarded to the admin using QAPI.
>> The admin is supposed to take according decisions concerning
>> CPU provisioning.
>> 
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>  qapi/machine-target.json | 30 ++++++++++++++++++++++++++++++
>>  hw/s390x/cpu-topology.c  |  2 ++
>>  2 files changed, 32 insertions(+)
>> 
>> diff --git a/qapi/machine-target.json b/qapi/machine-target.json
>> index 58df0f5061..5883c3b020 100644
>> --- a/qapi/machine-target.json
>> +++ b/qapi/machine-target.json
>> @@ -371,3 +371,33 @@
>>    },
>>    'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
>>  }
>> +
>> +##
>> +# @CPU_POLARITY_CHANGE:
>> +#
>> +# Emitted when the guest asks to change the polarity.
>> +#
>> +# @polarity: polarity specified by the guest
>> +#
>> +# The guest can tell the host (via the PTF instruction) whether the
>> +# CPUs should be provisioned using horizontal or vertical polarity.
>> +#
>> +# On horizontal polarity the host is expected to provision all vCPUs
>> +# equally.
>> +# On vertical polarity the host can provision each vCPU differently.
>> +# The guest will get information on the details of the provisioning
>> +# the next time it uses the STSI(15) instruction.
>> +#
>> +# Since: 8.0
>> +#
>> +# Example:
>> +#
>> +# <- { "event": "CPU_POLARITY_CHANGE",
>> +#      "data": { "polarity": 0 },
>> +#      "timestamp": { "seconds": 1401385907, "microseconds": 422329 } }
>> +#
>> +##
>> +{ 'event': 'CPU_POLARITY_CHANGE',
>> +  'data': { 'polarity': 'int' },
>> +  'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM'] }
>
> I wonder if you should depend on CONFIG_KVM or not. If tcg gets topology
> support it will use the same event and right now it would just never be emitted.
> On the other hand it's more conservative this way.

TCG vs. KVM should be as transparent as we can make it.

If only KVM can get into the state where the event is emitted, say
because the state is only possible with features only KVM supports, then
making the event conditional on KVM makes sense.  Of course, when
another accelerator acquires these features, we need to emit the event
there as well, which will involve adjusting the condition.

> I also wonder if you should add 'feature' : [ 'unstable' ].
> On the upside, it would mark the event as unstable, but I don't know what the
> consequences are exactly.

docs/devel/qapi-code-gen.rst:

    Special features
    ~~~~~~~~~~~~~~~~

    Feature "deprecated" marks a command, event, enum value, or struct
    member as deprecated.  It is not supported elsewhere so far.
    Interfaces so marked may be withdrawn in future releases in accordance
    with QEMU's deprecation policy.

    Feature "unstable" marks a command, event, enum value, or struct
    member as unstable.  It is not supported elsewhere so far.  Interfaces
    so marked may be withdrawn or changed incompatibly in future releases.

See also -compat parameters unstable-input, unstable-output, both
intended for "testing the future".

> Also I guess one can remove qemu events without breaking backwards compatibility,
> since they just won't be emitted? Unless I guess you specify that a event must
> occur under certain situations and the client waits on it?

Events are part of the interface just like command returns are.  Not
emitting an event in a situation where it was emitted before can easily
break things.  Only when the situation is no longer possible, the event
can be removed safely.

Questions?

[...]

