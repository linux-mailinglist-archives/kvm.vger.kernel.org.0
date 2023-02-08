Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53A0268EA2E
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 09:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjBHIuQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 03:50:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbjBHIuN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 03:50:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86C31457CF
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 00:49:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675846169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xhxVetMf39eyBYLaK7+c2bWPPz3BvXeYT/Jkcp+eZuU=;
        b=fKICRazTzyIXGz9B1HXGQ2OWzmKB5qsI3XXX+vM3BUlSLLwCDngr2NkAGGI5SZzeEwOCvp
        4rVXzgQmclu3/WyhDoYlv+lPvhQsuKAhOU03sGm3yh+CRDCmn7B/nsOJNOrSaPDJvTHtFr
        xTg0bVCJQqXnxG5s4L4PddZsstcASF0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-114-5dvcoJ_qPimOmvke9wf4xA-1; Wed, 08 Feb 2023 03:49:26 -0500
X-MC-Unique: 5dvcoJ_qPimOmvke9wf4xA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C25D61C07581;
        Wed,  8 Feb 2023 08:49:25 +0000 (UTC)
Received: from localhost (unknown [10.39.193.252])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A495C15BAE;
        Wed,  8 Feb 2023 08:49:18 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Gavin Shan <gshan@redhat.com>, Thomas Huth <thuth@redhat.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Steven Price <steven.price@arm.com>
Cc:     kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linuxppc-dev@lists.ozlabs.org, Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH 6/7] KVM: arm64: Change return type of
 kvm_vm_ioctl_mte_copy_tags() to "int"
In-Reply-To: <d0b3a1e7-0864-f169-cdea-60ad95951b3f@redhat.com>
Organization: Red Hat GmbH
References: <20230203094230.266952-1-thuth@redhat.com>
 <20230203094230.266952-7-thuth@redhat.com>
 <c6e605fe-f251-d8b6-64ed-bd1e17e79512@redhat.com>
 <7b32d58b-846f-b8d7-165b-9f505e5f00f0@redhat.com>
 <d0b3a1e7-0864-f169-cdea-60ad95951b3f@redhat.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Wed, 08 Feb 2023 09:49:16 +0100
Message-ID: <87zg9oleyb.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 08 2023, Gavin Shan <gshan@redhat.com> wrote:

> On 2/7/23 9:09 PM, Thomas Huth wrote:
>> Oh, drat, I thought I had checked all return statements ... this must have fallen through the cracks, sorry!
>> 
>> Anyway, this is already a problem now: The function is called from kvm_arch_vm_ioctl() (which still returns a long), which in turn is called from kvm_vm_ioctl() in virt/kvm/kvm_main.c. And that functions stores the return value in an "int r" variable. So the upper bits are already lost there.
>> 
>> Also, how is this supposed to work from user space? The normal "ioctl()" libc function just returns an "int" ? Is this ioctl already used in a userspace application somewhere? ... at least in QEMU, I didn't spot it yet...
>> 

We will need it in QEMU to implement migration with MTE (the current
proposal simply adds a migration blocker when MTE is enabled, as there
are various other things that need to be figured out for this to work.)
But maybe other VMMs already use it (and have been lucky because they
always dealt with shorter lengths?)

>
> The ioctl command KVM_ARM_MTE_COPY_TAGS was merged recently and not used
> by QEMU yet. I think struct kvm_arm_copy_mte_tags::length needs to be
> '__u32' instead of '__u64' in order to standardize the return value.
> Something like below. Documentation/virt/kvm/api.rst::section-4.130
> needs update accordingly.
>
>     struct kvm_arm_copy_mte_tags {
>          __u64 guest_ipa;
>          __u32 pad;
>          __u32 length;
>          void __user *addr;
>          __u64 flags;
>          __u64 reserved[2];
>    };

Can we do this in a more compatible way, as we are dealing with an API?
Like returning -EINVAL if length is too big?

