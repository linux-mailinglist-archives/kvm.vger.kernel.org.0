Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CACEF77B5BC
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 11:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232747AbjHNJro (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 05:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233521AbjHNJrh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 05:47:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1A79CC
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 02:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692006407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K4sGVUE43D+9dWlB8T8cOXLzUkJGkxQXnJLqjpcMDso=;
        b=OPSnHqhBMZtzaIyxguXzzz/ATheIKyfnz9+M/hRai/C+I1mwkmSazoPLfLBwNn7vQK2Hih
        4Pv4WE3V5vqTnjTpf03IowpeLQWagGeKTv1KGl1+zkcD9GQ63mWirOPk6yw/+9P9nmr7Wl
        rxExQEj1movDBqIypLXhKDeVd0XNH8U=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-59-V1JhcZPKNna7_WvWh_0YbA-1; Mon, 14 Aug 2023 05:46:42 -0400
X-MC-Unique: V1JhcZPKNna7_WvWh_0YbA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 299DD3815F62;
        Mon, 14 Aug 2023 09:46:41 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DC2D12166B25;
        Mon, 14 Aug 2023 09:46:40 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>
Cc:     Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v8 02/11] KVM: arm64: Document
 KVM_ARM_GET_REG_WRITABLE_MASKS
In-Reply-To: <20230807162210.2528230-3-jingzhangos@google.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20230807162210.2528230-1-jingzhangos@google.com>
 <20230807162210.2528230-3-jingzhangos@google.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Mon, 14 Aug 2023 11:46:39 +0200
Message-ID: <878raex8g0.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 07 2023, Jing Zhang <jingzhangos@google.com> wrote:

> Add some basic documentation on how to get feature ID register writable
> masks from userspace.
>
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  Documentation/virt/kvm/api.rst | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index c0ddd3035462..92a9b20f970e 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6068,6 +6068,35 @@ writes to the CNTVCT_EL0 and CNTPCT_EL0 registers using the SET_ONE_REG
>  interface. No error will be returned, but the resulting offset will not be
>  applied.
>  
> +4.139 KVM_ARM_GET_REG_WRITABLE_MASKS
> +-------------------------------------------
> +
> +:Capability: none
> +:Architectures: arm64
> +:Type: vm ioctl
> +:Parameters: struct reg_mask_range (in/out)
> +:Returns: 0 on success, < 0 on error
> +
> +
> +::
> +
> +        #define ARM64_FEATURE_ID_SPACE_SIZE	(3 * 8 * 8)
> +
> +        struct reg_mask_range {
> +                __u64 addr;             /* Pointer to mask array */
> +                __u64 reserved[7];
> +        };
> +
> +This ioctl would copy the writable masks for feature ID registers to userspace.
> +The Feature ID space is defined as the System register space in AArch64 with
> +op0==3, op1=={0, 1, 3}, CRn==0, CRm=={0-7}, op2=={0-7}.
> +To get the index in the mask array pointed by ``addr`` for a specified feature
> +ID register, use the macro ``ARM64_FEATURE_ID_SPACE_IDX(op0, op1, crn, crm, op2)``.
> +This allows the userspace to know upfront whether it can actually tweak the
> +contents of a feature ID register or not.
> +The ``reserved[7]`` is reserved for future use to add other register space. For
> +feature ID registers, it should be 0, otherwise, KVM may return error.

In case of future extensions, this means that userspace needs to figure
out what the kernel supports via different content in reg_mask_range
(i.e. try with a value in one of the currently reserved fields and fall
back to using addr only if that doesn't work.) Can we do better?

Maybe we could introduce a capability that returns the supported ranges
as flags, i.e. now we would return 1 for id regs masks, and for the
future case where we have some values in the next reserved field we
could return 1 & 2 etc. Would make life easier for userspace that needs
to work with different kernels, but might be overkill if reserved[] is
more like an insurance without any concrete plans for extensions.

