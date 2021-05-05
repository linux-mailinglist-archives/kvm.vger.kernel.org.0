Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E96237365E
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 10:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbhEEIhN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 04:37:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49657 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230490AbhEEIhK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 May 2021 04:37:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620203774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TGsV9oxlRVBsXgbyNSnKusUukT5R+kNB72RhHN5dk9o=;
        b=KfgRD+eUi/fdU9j0kb649c5HUdLVgIL8B0WmDW54bhLvLjmLmeEAI4RsXia6oZ4yWac7OF
        U3FysfPktqvmlE/aeXNdxDQRJBDk6Lfs5VCEr6pAs98tw2MaPr/7i/iADO13llODqHI0LR
        8t+eaLrOjRiOQQCVtJPk4E6jsgbeA6Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-nvsE5nRZM_KjBeXUrwGJYg-1; Wed, 05 May 2021 04:36:12 -0400
X-MC-Unique: nvsE5nRZM_KjBeXUrwGJYg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AC74B1020C24;
        Wed,  5 May 2021 08:36:11 +0000 (UTC)
Received: from starship (unknown [10.40.192.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 349D7131DE;
        Wed,  5 May 2021 08:35:51 +0000 (UTC)
Message-ID: <881137dab90d0779180c075d762f27d2cd612e6c.camel@redhat.com>
Subject: Re: [PATCH 1/2] kvm: update kernel headers for
 KVM_GUESTDBG_BLOCKEVENTS
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Alex =?ISO-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc:     qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        Philippe =?ISO-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>
Date:   Wed, 05 May 2021 11:35:51 +0300
In-Reply-To: <874kg29r8j.fsf@linaro.org>
References: <20210401144152.1031282-1-mlevitsk@redhat.com>
                 <20210401144152.1031282-2-mlevitsk@redhat.com> <874kg29r8j.fsf@linaro.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-04-19 at 17:22 +0100, Alex Bennée wrote:
> Maxim Levitsky <mlevitsk@redhat.com> writes:
> 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> 
> Generally it's a good idea to reference where these are coming from, is
> it a current kernel patch in flight or from an release we haven't synced
> up to yet?
Hi!

As Paolo explained to me, qemu syncs the kernel headers every once in a while
thus when I submit a feature to qemu which uses a new KVM feature, while
I should submit a patch to add it to the kernel headers, the patch is only
for the reference.

In this particular case, I first updated the qemu's kernel headers to
match the kvm/queue branch, then added my feature to the kernel, and updated
the qemu kernel headers again. This patch is the diff between 1st and second
update to make it more readable.

Best regards,
	Maxim Levitsky

> 
> Usually linux header updates are done with semi-regular runs on
> ./scripts/update-linux-headers.sh but obviously it's OK to include
> standalone patches during the review process.
> 
> > ---
> >  linux-headers/asm-x86/kvm.h | 2 ++
> >  linux-headers/linux/kvm.h   | 1 +
> >  2 files changed, 3 insertions(+)
> > 
> > diff --git a/linux-headers/asm-x86/kvm.h b/linux-headers/asm-x86/kvm.h
> > index 8e76d3701d..33878cdc34 100644
> > --- a/linux-headers/asm-x86/kvm.h
> > +++ b/linux-headers/asm-x86/kvm.h
> > @@ -281,6 +281,8 @@ struct kvm_debug_exit_arch {
> >  #define KVM_GUESTDBG_USE_HW_BP		0x00020000
> >  #define KVM_GUESTDBG_INJECT_DB		0x00040000
> >  #define KVM_GUESTDBG_INJECT_BP		0x00080000
> > +#define KVM_GUESTDBG_BLOCKIRQ		0x00100000
> > +
> >  
> >  /* for KVM_SET_GUEST_DEBUG */
> >  struct kvm_guest_debug_arch {
> > diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
> > index 020b62a619..2ded7a0630 100644
> > --- a/linux-headers/linux/kvm.h
> > +++ b/linux-headers/linux/kvm.h
> > @@ -1056,6 +1056,7 @@ struct kvm_ppc_resize_hpt {
> >  #define KVM_CAP_ENFORCE_PV_FEATURE_CPUID 190
> >  #define KVM_CAP_SYS_HYPERV_CPUID 191
> >  #define KVM_CAP_DIRTY_LOG_RING 192
> > +#define KVM_CAP_SET_GUEST_DEBUG2 195
> >  
> >  #ifdef KVM_CAP_IRQ_ROUTING
> 
> 


