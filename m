Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3622B16BC
	for <lists+kvm@lfdr.de>; Fri, 13 Nov 2020 08:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726172AbgKMHwe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 02:52:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25251 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725866AbgKMHwe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Nov 2020 02:52:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605253952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T2tLd9EHV9oYJEl4B/bjBLxpB/1xyR4rLIQOw+DQNAc=;
        b=fbwevVqy7ufMmkbJgNC0GgkesVAfbmOs+klNF0nztn1txqRdn5bbkQdGCjv7zpEnz56qwP
        VZVuWUfrjH4T46fn4+5CjQTy8ikxQ3+kEUyE8lvVFTpfR+QxWFpZWWEcz4sZPmegDG+sMe
        TR4HxWEYWqR+mOkYHcnCMgUSIHo0R0U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-5NU3Dyk4OCGNlV5K7zZDYg-1; Fri, 13 Nov 2020 02:52:30 -0500
X-MC-Unique: 5NU3Dyk4OCGNlV5K7zZDYg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E6B8518CB73C;
        Fri, 13 Nov 2020 07:52:28 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.97])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 40A9F1C4;
        Fri, 13 Nov 2020 07:52:26 +0000 (UTC)
Date:   Fri, 13 Nov 2020 08:52:23 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, bgardon@google.com
Subject: Re: [PATCH v2 01/11] KVM: selftests: Update .gitignore
Message-ID: <20201113075223.6y3u77jjl3syupvf@kamzik.brq.redhat.com>
References: <20201111122636.73346-1-drjones@redhat.com>
 <20201111122636.73346-2-drjones@redhat.com>
 <20201112181201.GR26342@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112181201.GR26342@xz-x1>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 12, 2020 at 01:12:01PM -0500, Peter Xu wrote:
> On Wed, Nov 11, 2020 at 01:26:26PM +0100, Andrew Jones wrote:
> > Add x86_64/tsc_msrs_test and remove clear_dirty_log_test.
> > 
> > Reviewed-by: Ben Gardon <bgardon@google.com>
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  tools/testing/selftests/kvm/.gitignore | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> > index 7a2c242b7152..ceff9f4c1781 100644
> > --- a/tools/testing/selftests/kvm/.gitignore
> > +++ b/tools/testing/selftests/kvm/.gitignore
> > @@ -18,13 +18,13 @@
> >  /x86_64/vmx_preemption_timer_test
> >  /x86_64/svm_vmcall_test
> >  /x86_64/sync_regs_test
> > +/x86_64/tsc_msrs_test
> >  /x86_64/vmx_apic_access_test
> >  /x86_64/vmx_close_while_nested_test
> >  /x86_64/vmx_dirty_log_test
> >  /x86_64/vmx_set_nested_state_test
> >  /x86_64/vmx_tsc_adjust_test
> >  /x86_64/xss_msr_test
> > -/clear_dirty_log_test
> >  /demand_paging_test
> >  /dirty_log_test
> >  /dirty_log_perf_test
> 
> This seems to conflict with another patch that are already on kvm/queue, so
> this series may need a rebase (and, seems this is not the only conflict)...
>

It looks like Paolo added "selftests: kvm: keep .gitignore add to date",
which does what this patch does plus re-alphabetizes everything.

So this patch can be dropped.

Thanks,
drew

