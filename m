Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67A1866410B
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 14:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbjAJNBB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 08:01:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231727AbjAJNBA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 08:01:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF2826543
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 05:00:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673355615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2lyt+LeqAra/2an80GVSavy/Ah+MElPYQlCaDsqLXoo=;
        b=J3B0pJ3NhWeCY9fzPASRONRGshP9QWSLIfMgkWFnr5pp9ICgxAwO5Ze9ie4k5+6k+5lD8P
        jJ2rCAaS+fH1saXNm/j5Rcng5Nch10soJhnighZx7dZtaLM8HOghinZPtI4l9e5Vgrw0lD
        K66lnRQ3rLBtvLeSpZAXS/9QyfjsbvI=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-567-YJ9SQU9tPWe2EsR5gCxk5Q-1; Tue, 10 Jan 2023 08:00:13 -0500
X-MC-Unique: YJ9SQU9tPWe2EsR5gCxk5Q-1
Received: by mail-qt1-f198.google.com with SMTP id n26-20020ac8675a000000b003a97d74d134so5452474qtp.3
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 05:00:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2lyt+LeqAra/2an80GVSavy/Ah+MElPYQlCaDsqLXoo=;
        b=QgZyNnWO76Rbng6iWjUscxo0OdPh3Tz2POKb1He+wC/JngOWc+uMV4NYfhCqi2dzxi
         Pbwi3+mKJl3S/m1UKBzVicfXN+01Xd+F2JrIPvZE4uM19+FfUmVCTKmhRWWAZKpdy67z
         X7AWy9aPWd3C3H/z4hrfMX9ddvtVZWE4KugDZdvJNh4LfX1WbYNMHYr7WonZRWUQMndM
         kROgw17QPADMXKjIMgnR2dxIG2LJBYYjyRFqAiU0CIA2n8M1wt2puch1UwAHiZHW1zTs
         22juGhoDiaY6gwcrUy4eP24An1gu9GslQ5mLkvUORv9jphlDFUJF2RuefjuO0vgm08wk
         tKyA==
X-Gm-Message-State: AFqh2kooMcfDanhhiPIBtV2vm8PrwjMiHvjqXuSk6WYMmLNpY+DnytDc
        qplnQn4N7FXSlz8HCm+//h/pKid9uIo0geVZZsTlD2tCNCX4TR70iMOyhR4B0Zu43vAQK0QCk3K
        VSl3i8Dunc7/Z
X-Received: by 2002:a05:622a:a07:b0:39c:da20:626 with SMTP id bv7-20020a05622a0a0700b0039cda200626mr4675640qtb.48.1673355613379;
        Tue, 10 Jan 2023 05:00:13 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsyzI1XcrBxI7qdGiOhKArruwrgxzRvM+y22AXkx12eOQm5ESrddG1TdhyP1H9zKvr7IKlhqQ==
X-Received: by 2002:a05:622a:a07:b0:39c:da20:626 with SMTP id bv7-20020a05622a0a0700b0039cda200626mr4675582qtb.48.1673355613004;
        Tue, 10 Jan 2023 05:00:13 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-179-237.web.vodafone.de. [109.43.179.237])
        by smtp.gmail.com with ESMTPSA id y10-20020a05620a25ca00b006fa4cac54a5sm7069613qko.72.2023.01.10.05.00.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jan 2023 05:00:12 -0800 (PST)
Message-ID: <5c8a22bb-5a35-d71e-9e5a-39675fa04e66@redhat.com>
Date:   Tue, 10 Jan 2023 14:00:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-3-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v14 02/11] s390x/cpu topology: add topology entries on CPU
 hotplug
In-Reply-To: <20230105145313.168489-3-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/01/2023 15.53, Pierre Morel wrote:
> The topology information are attributes of the CPU and are
> specified during the CPU device creation.
> 
> On hot plug, we gather the topology information on the core,
> creates a list of topology entries, each entry contains a single
> core mask of each core with identical topology and finaly we
> orders the list in topological order.
> The topological order is, from higher to lower priority:
> - physical topology
>      - drawer
>      - book
>      - socket
>      - core origin, offset in 64bit increment from core 0.
> - modifier attributes
>      - CPU type
>      - polarization entitlement
>      - dedication
> 
> The possibility to insert a CPU in a mask is dependent on the
> number of cores allowed in a socket, a book or a drawer, the
> checking is done during the hot plug of the CPU to have an
> immediate answer.
> 
> If the complete topology is not specified, the core is added
> in the physical topology based on its core ID and it gets
> defaults values for the modifier attributes.
> 
> This way, starting QEMU without specifying the topology can
> still get some adventage of the CPU topology.

s/adventage/advantage/

> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   include/hw/s390x/cpu-topology.h |  48 ++++++
>   hw/s390x/cpu-topology.c         | 293 ++++++++++++++++++++++++++++++++
>   hw/s390x/s390-virtio-ccw.c      |  10 ++
>   hw/s390x/meson.build            |   1 +
>   4 files changed, 352 insertions(+)
>   create mode 100644 hw/s390x/cpu-topology.c
> 
> diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
> index d945b57fc3..b3fd752d8d 100644
> --- a/include/hw/s390x/cpu-topology.h
> +++ b/include/hw/s390x/cpu-topology.h
> @@ -10,7 +10,11 @@
>   #ifndef HW_S390X_CPU_TOPOLOGY_H
>   #define HW_S390X_CPU_TOPOLOGY_H
>   
> +#include "qemu/queue.h"
> +#include "hw/boards.h"
> +
>   #define S390_TOPOLOGY_CPU_IFL   0x03
> +#define S390_TOPOLOGY_MAX_ORIGIN ((63 + S390_MAX_CPUS) / 64)
>   
>   #define S390_TOPOLOGY_POLARITY_HORIZONTAL      0x00
>   #define S390_TOPOLOGY_POLARITY_VERTICAL_LOW    0x01
> @@ -20,4 +24,48 @@
>   #define S390_TOPOLOGY_SHARED    0x00
>   #define S390_TOPOLOGY_DEDICATED 0x01
>   
> +typedef union s390_topology_id {
> +    uint64_t id;
> +    struct {
> +        uint64_t level_6:8; /* byte 0 BE */
> +        uint64_t level_5:8; /* byte 1 BE */
> +        uint64_t drawer:8;  /* byte 2 BE */
> +        uint64_t book:8;    /* byte 3 BE */
> +        uint64_t socket:8;  /* byte 4 BE */
> +        uint64_t rsrv:5;
> +        uint64_t d:1;
> +        uint64_t p:2;       /* byte 5 BE */
> +        uint64_t type:8;    /* byte 6 BE */
> +        uint64_t origin:2;
> +        uint64_t core:6;    /* byte 7 BE */
> +    };
> +} s390_topology_id;

Bitmasks are OK for code that will definitely only ever work with KVM ... 
but this will certainly fail completely if we ever try to get it running 
with TCG later. Do we care? ... if so, you should certainly avoid a bitfield 
here. Especially since most of the fields are 8-bit anyway and could easily 
be represented by a "uint8_t" variable. Otherwise, just ignore my comment.

> +#define TOPO_CPU_MASK       0x000000000000003fUL
> +
> +typedef struct S390TopologyEntry {
> +    s390_topology_id id;
> +    QTAILQ_ENTRY(S390TopologyEntry) next;
> +    uint64_t mask;
> +} S390TopologyEntry;
> +
> +typedef struct S390Topology {
> +    QTAILQ_HEAD(, S390TopologyEntry) list;
> +    uint8_t *sockets;

So this "uint8_t" basically is a hidden limit of a maximum of 256 sockets 
that can be used for per book? Do we check that limit somewhere? (I looked 
for it, but I didn't spot such a check)

> +    CpuTopology *smp;
> +} S390Topology;
> +
> +#ifdef CONFIG_KVM
> +bool s390_has_topology(void);
> +void s390_topology_set_cpu(MachineState *ms, S390CPU *cpu, Error **errp);
> +#else
> +static inline bool s390_has_topology(void)
> +{
> +       return false;
> +}
> +static inline void s390_topology_set_cpu(MachineState *ms,
> +                                         S390CPU *cpu,
> +                                         Error **errp) {}
> +#endif
> +extern S390Topology s390_topology;
> +
>   #endif
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> new file mode 100644
> index 0000000000..438055c612
> --- /dev/null
> +++ b/hw/s390x/cpu-topology.c
> @@ -0,0 +1,293 @@
> +/*
> + * CPU Topology
> + *
> + * Copyright IBM Corp. 2022

Want to update to 2023 now?

> + * Author(s): Pierre Morel <pmorel@linux.ibm.com>
> +
> + * This work is licensed under the terms of the GNU GPL, version 2 or (at
> + * your option) any later version. See the COPYING file in the top-level
> + * directory.
> + */
> +
> +#include "qemu/osdep.h"
> +#include "qapi/error.h"
> +#include "qemu/error-report.h"
> +#include "hw/qdev-properties.h"
> +#include "hw/boards.h"
> +#include "qemu/typedefs.h"
> +#include "target/s390x/cpu.h"
> +#include "hw/s390x/s390-virtio-ccw.h"
> +#include "hw/s390x/cpu-topology.h"
> +
> +/*
> + * s390_topology is used to keep the topology information.
> + * .list: queue the topology entries inside which
> + *        we keep the information on the CPU topology.
> + *
> + * .smp: keeps track of the machine topology.
> + *
> + * .socket: tracks information on the count of cores per socket.
> + *
> + */
> +S390Topology s390_topology = {
> +    .list = QTAILQ_HEAD_INITIALIZER(s390_topology.list),
> +    .sockets = NULL, /* will be initialized after the cpu model is realized */
> +};
> +
> +/**
> + * s390_socket_nb:
> + * @id: s390_topology_id
> + *
> + * Returns the socket number used inside the socket array.
> + */
> +static int s390_socket_nb(s390_topology_id id)
> +{
> +    return (id.socket + 1) * (id.book + 1) * (id.drawer + 1); > +}
I think there might be an off-by-one error in here - you likely need a "- 1" 
at the very end.

For example, assume that we have one socket, one book and one drawer, so 
id.socket, id.book and id.drawer would all be 0. The function then returns 1 ...

> +static void s390_topology_init(MachineState *ms)
> +{
> +    CpuTopology *smp = &ms->smp;
> +
> +    s390_topology.smp = smp;
> +    if (!s390_topology.sockets) {
> +        s390_topology.sockets = g_new0(uint8_t, smp->sockets *
> +                                       smp->books * smp->drawers);

... but here you only allocated one byte. So you later access 
s390_topology.sockets[s390_socket_nb(id)], i.e. s390_topology.sockets[1] 
which is out of bounds.

> +    }
> +}

  Thomas


