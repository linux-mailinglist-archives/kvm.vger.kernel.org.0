Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F59317F6E7
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 12:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgCJL62 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 07:58:28 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:27801 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726504AbgCJL62 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Mar 2020 07:58:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583841506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DFEYOi762ktZ28oFvK/Q8wZ18K/YmHLuA5ThDt2pDts=;
        b=Hc02r8yrB/cAKSy6VbEzLe3V3Q9WFzolSi2MbxEfnldAOujttDY7KF6mn0Tyu8nmNGPdPC
        WYJ/ZEtxQq3mQbzvbNMrpDZIPOt/4K1V0S5+eikJ70hKy/7Y6MP9FsQXPMU9Sh8o3QCdSh
        wLKbzqbkJlms1M7SNB2LIjY/W4DzVjA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-U0OBpWCcMU-i2eRv4ZiVfA-1; Tue, 10 Mar 2020 07:58:25 -0400
X-MC-Unique: U0OBpWCcMU-i2eRv4ZiVfA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F236E801E53;
        Tue, 10 Mar 2020 11:58:23 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 11B3F8F35C;
        Tue, 10 Mar 2020 11:58:16 +0000 (UTC)
Date:   Tue, 10 Mar 2020 12:58:14 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, peterx@redhat.com,
        thuth@redhat.com
Subject: Re: [PATCH 0/4] KVM: selftests: Various cleanups and fixes
Message-ID: <20200310115814.fxgbfrxn62zge2jp@kamzik.brq.redhat.com>
References: <20200310091556.4701-1-drjones@redhat.com>
 <1b6d5b6a-f323-14d5-f423-d59547637819@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b6d5b6a-f323-14d5-f423-d59547637819@de.ibm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 10, 2020 at 10:45:43AM +0100, Christian Borntraeger wrote:
> On 10.03.20 10:15, Andrew Jones wrote:
> > 
> > Andrew Jones (4):
> >   fixup! selftests: KVM: SVM: Add vmcall test
> >   KVM: selftests: Share common API documentation
> >   KVM: selftests: Enable printf format warnings for TEST_ASSERT
> >   KVM: selftests: Use consistent message for test skipping
> 
> This looks like a nice cleanup but this does not seem to apply
> cleanly on kvm/master or linus/master. Which tree is this based on?

This is based on kvm/queue. Sorry, I should have mentioned that in
the cover letter.

Thanks,
drew

> 
> > 
> >  tools/testing/selftests/kvm/.gitignore        |   5 +-
> >  .../selftests/kvm/demand_paging_test.c        |   6 +-
> >  tools/testing/selftests/kvm/dirty_log_test.c  |   3 +-
> >  .../testing/selftests/kvm/include/kvm_util.h  | 100 ++++++++-
> >  .../testing/selftests/kvm/include/test_util.h |   5 +-
> >  .../selftests/kvm/lib/aarch64/processor.c     |  17 --
> >  tools/testing/selftests/kvm/lib/assert.c      |   6 +-
> >  tools/testing/selftests/kvm/lib/kvm_util.c    |  10 +-
> >  .../selftests/kvm/lib/kvm_util_internal.h     |  48 +++++
> >  .../selftests/kvm/lib/s390x/processor.c       |  74 -------
> >  tools/testing/selftests/kvm/lib/test_util.c   |  12 ++
> >  .../selftests/kvm/lib/x86_64/processor.c      | 196 ++++--------------
> >  tools/testing/selftests/kvm/lib/x86_64/svm.c  |   2 +-
> >  tools/testing/selftests/kvm/lib/x86_64/vmx.c  |   2 +-
> >  tools/testing/selftests/kvm/s390x/memop.c     |   2 +-
> >  .../selftests/kvm/s390x/sync_regs_test.c      |   2 +-
> >  .../kvm/x86_64/cr4_cpuid_sync_test.c          |   2 +-
> >  .../testing/selftests/kvm/x86_64/evmcs_test.c |   6 +-
> >  .../selftests/kvm/x86_64/hyperv_cpuid.c       |   8 +-
> >  .../selftests/kvm/x86_64/mmio_warning_test.c  |   4 +-
> >  .../selftests/kvm/x86_64/platform_info_test.c |   3 +-
> >  .../kvm/x86_64/set_memory_region_test.c       |   3 +-
> >  .../testing/selftests/kvm/x86_64/state_test.c |   4 +-
> >  .../selftests/kvm/x86_64/svm_vmcall_test.c    |   3 +-
> >  .../selftests/kvm/x86_64/sync_regs_test.c     |   4 +-
> >  .../selftests/kvm/x86_64/vmx_dirty_log_test.c |   2 +-
> >  .../kvm/x86_64/vmx_set_nested_state_test.c    |   4 +-
> >  .../selftests/kvm/x86_64/xss_msr_test.c       |   2 +-
> >  28 files changed, 243 insertions(+), 292 deletions(-)
> > 
> 

