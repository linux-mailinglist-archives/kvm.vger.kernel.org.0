Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDB42B019F
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 10:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbgKLJHT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Nov 2020 04:07:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50406 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727863AbgKLJHN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Nov 2020 04:07:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605172029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6vBnRXhtUZgvBjyOFeGNMppAU2xGHGRxN/O7fO2Hu3Q=;
        b=cc3Aax8uAQkFOCOAR6rOvWZnrUT2/lfgxRW4G99xLE930K4hR2/kEv2g4x3wMxkl7kO3tT
        zBH3RYqzXwkex3+LX9a70vCNeo4rXyKFXWmSKxaKitXbCFOhxLjsk4w8STwPSFhtL9cVei
        DsTkdwghEBuBapZZswulUu38Sqvoais=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-wgavTCQEPreRrTAV_Wdfag-1; Thu, 12 Nov 2020 04:07:08 -0500
X-MC-Unique: wgavTCQEPreRrTAV_Wdfag-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C5D9487951F;
        Thu, 12 Nov 2020 09:07:06 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.0])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 393775DA7E;
        Thu, 12 Nov 2020 09:07:02 +0000 (UTC)
Date:   Thu, 12 Nov 2020 10:06:59 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v2 08/11] KVM: selftests: Implement perf_test_util more
 conventionally
Message-ID: <20201112090659.oqavzaevaz4dbthr@kamzik.brq.redhat.com>
References: <20201111122636.73346-1-drjones@redhat.com>
 <20201111122636.73346-9-drjones@redhat.com>
 <CANgfPd_F5BAzs8p58QuqPS7HpxdfKzMUZF1XR_vwR90_97E7BQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd_F5BAzs8p58QuqPS7HpxdfKzMUZF1XR_vwR90_97E7BQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 11, 2020 at 03:08:59PM -0800, Ben Gardon wrote:
> On Wed, Nov 11, 2020 at 4:27 AM Andrew Jones <drjones@redhat.com> wrote:
> >
> > It's not conventional C to put non-inline functions in header
> > files. Create a source file for the functions instead. Also
> > reduce the amount of globals and rename the functions to
> > something less generic.
> >
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> 
> Reviewed-by: Ben Gardon <bgardon@google.com>

Thanks!

> > +
> > +void perf_test_add_vcpus(struct kvm_vm *vm, int vcpus, uint64_t vcpu_memory_bytes)
> 
> NIT: Since we're actually creating the vcpus in vm_create_with_vcpus,
> and renaming functions anyway, it might make sense to change this to
> perf_test_setup_vcpus or similar here.
> This could also be called from perf_test_create_vm and made static,
> but that might be outside the scope of this commit. Either way works.
>

Yup, I agree there's still room for some more cleanup / renaming.
I'll be happy to review the patches ;-)

Thanks,
drew

