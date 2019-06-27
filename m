Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93380582B3
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 14:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbfF0Mgs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jun 2019 08:36:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60564 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726945AbfF0Mgs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jun 2019 08:36:48 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5724680F79
        for <kvm@vger.kernel.org>; Thu, 27 Jun 2019 12:36:48 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1340A600CC;
        Thu, 27 Jun 2019 12:36:44 +0000 (UTC)
Date:   Thu, 27 Jun 2019 14:36:42 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, rkrcmar@redhat.com, thuth@redhat.com,
        peterx@redhat.com
Subject: Re: [PATCH v2 0/4] kvm: selftests: aarch64: use struct kvm_vcpu_init
Message-ID: <20190627123642.looqpfqdcrjkbtwx@kamzik.brq.redhat.com>
References: <20190527143141.13883-1-drjones@redhat.com>
 <39548ccf-0628-06db-7f49-329c4ce87536@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39548ccf-0628-06db-7f49-329c4ce87536@redhat.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 27 Jun 2019 12:36:48 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 04, 2019 at 07:17:23PM +0200, Paolo Bonzini wrote:
> On 27/05/19 16:31, Andrew Jones wrote:
> > aarch64 vcpu setup requires a vcpu init step that takes a kvm_vcpu_init
> > struct. So far we've just hard coded that to be one that requests no
> > features and always uses KVM_ARM_TARGET_GENERIC_V8 for the target. We
> > should have used the preferred target from the beginning, so we do that
> > now, and we also provide an API to unit tests to select a target of their
> > choosing and/or cpu features.
> > 
> > Switching to the preferred target fixes running on platforms that don't
> > like KVM_ARM_TARGET_GENERIC_V8. The new API will be made use of with
> > some coming unit tests.
> > 
> > v2:
> > - rename vm_vcpu_add_memslots to vm_vcpu_add_with_memslots
> > 
> > Andrew Jones (4):
> >   kvm: selftests: rename vm_vcpu_add to vm_vcpu_add_with_memslots
> >   kvm: selftests: introduce vm_vcpu_add
> >   kvm: selftests: introduce aarch64_vcpu_setup
> >   kvm: selftests: introduce aarch64_vcpu_add_default
> > 
> >  .../selftests/kvm/include/aarch64/processor.h |  4 +++
> >  .../testing/selftests/kvm/include/kvm_util.h  |  5 +--
> >  .../selftests/kvm/lib/aarch64/processor.c     | 33 +++++++++++++++----
> >  tools/testing/selftests/kvm/lib/kvm_util.c    | 29 +++++++++++++---
> >  .../selftests/kvm/lib/x86_64/processor.c      |  2 +-
> >  .../testing/selftests/kvm/x86_64/evmcs_test.c |  2 +-
> >  .../kvm/x86_64/kvm_create_max_vcpus.c         |  2 +-
> >  tools/testing/selftests/kvm/x86_64/smm_test.c |  2 +-
> >  .../testing/selftests/kvm/x86_64/state_test.c |  2 +-
> >  9 files changed, 63 insertions(+), 18 deletions(-)
> > 
> 
> Queued with my replacement for patches 1 and 2 (but please do review it).
>

Sorry I forgot to follow up on this until now. I've reviewed tested the
commits on kvm/queue. LGTM.

Thanks,
drew 
