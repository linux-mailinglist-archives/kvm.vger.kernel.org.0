Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0ACC730DAC
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 05:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237672AbjFODss (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 23:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjFODsq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 23:48:46 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01C9211D;
        Wed, 14 Jun 2023 20:48:44 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4QhSvH41JTz4wgC;
        Thu, 15 Jun 2023 13:48:43 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1686800923;
        bh=O3Nn8Xh+c9qsZ7K3m6q6+78dSP1PlveI8k991knHxzY=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=rngbIqFZyQUlXkDaUO52vlPUCfjrvwv6pqSZLgeTIz+Fk06/lHWN20ro0sa5vpg9n
         FBjQ/1nhp+VtqgKDe5vmnbl676jFkLWoJygwBk9bIgtjzpo4nScFZ0UEugRgwYdp9B
         LOrQp2x6r/kXwYObUJg0+9IzGrYnr+ZPUcKxMb7ShUapPFKS0uWK4wlX3T0lNAFnzs
         5w640BoEfKN6TnQySLYcKrH7WGCx0OGu9XGZ95GTzDCHyxeNCGroys716R5ScTF5qH
         6pf9f9f4gKfi5VEtX7JNPfPgVHEKHEtTGG7ZE6dqQGmEIz/hPkPh0CwvOVk4wPkPaA
         jSkMSqrsp8BQw==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Wei Wang <wei.w.wang@intel.com>, seanjc@google.com,
        pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wei Wang <wei.w.wang@intel.com>
Subject: Re: [PATCH RESEND v2] KVM: move KVM_CAP_DEVICE_CTRL to the generic
 check
In-Reply-To: <20230315101606.10636-1-wei.w.wang@intel.com>
References: <20230315101606.10636-1-wei.w.wang@intel.com>
Date:   Thu, 15 Jun 2023 13:48:42 +1000
Message-ID: <87cz1xfkrp.fsf@mail.lhotse>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wei Wang <wei.w.wang@intel.com> writes:

> KVM_CAP_DEVICE_CTRL allows userspace to check if the kvm_device
> framework (e.g. KVM_CREATE_DEVICE) is supported by KVM. Move
> KVM_CAP_DEVICE_CTRL to the generic check for the two reasons:
> 1) it already supports arch agnostic usages (i.e. KVM_DEV_TYPE_VFIO).
> For example, userspace VFIO implementation may needs to create
> KVM_DEV_TYPE_VFIO on x86, riscv, or arm etc. It is simpler to have it
> checked at the generic code than at each arch's code.
> 2) KVM_CREATE_DEVICE has been added to the generic code.
>
> Link: https://lore.kernel.org/all/20221215115207.14784-1-wei.w.wang@intel.com
> Signed-off-by: Wei Wang <wei.w.wang@intel.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/arm64/kvm/arm.c       | 1 -
>  arch/powerpc/kvm/powerpc.c | 1 -

Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)

cheers
