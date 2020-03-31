Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25836198D61
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 09:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730032AbgCaHtO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 03:49:14 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26664 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729925AbgCaHtO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Mar 2020 03:49:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585640953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WQidleZHioAbMw3jPUbXbSj/Imf6yrz9eifvO/T2QX4=;
        b=UKD9LCmunWQXMa4+0iMa1CQ7j82o70D9M7hI08xSTvIgO5s+u+IvIcALoj5SxEw1GIp5nb
        2PlAbtYEdNfre4Ts1/z8VMdOFN/+bqOE5O4eNiugEbV1P9b0YVZsMHf65kKKn8EB+gc3ie
        OyFa2NLa2QQXCcocd5GGu7NOy0tl5a8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-94-VP2st1JzOUyUPktB7CCMwg-1; Tue, 31 Mar 2020 03:49:12 -0400
X-MC-Unique: VP2st1JzOUyUPktB7CCMwg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 317101083E84;
        Tue, 31 Mar 2020 07:49:11 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.153])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A77B10016EB;
        Tue, 31 Mar 2020 07:49:06 +0000 (UTC)
Date:   Tue, 31 Mar 2020 09:49:03 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     Wainer dos Santos Moschetta <wainersm@redhat.com>,
        kvm@vger.kernel.org, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests: kvm: Update .gitignore with missing binaries
Message-ID: <20200331074903.lwqjkwyinfw2avzg@kamzik.brq.redhat.com>
References: <20200330211922.24290-1-wainersm@redhat.com>
 <49982d4c-ab12-28e6-d0f2-695c8781b26d@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49982d4c-ab12-28e6-d0f2-695c8781b26d@linux.ibm.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 31, 2020 at 09:09:17AM +0200, Janosch Frank wrote:
> On 3/30/20 11:19 PM, Wainer dos Santos Moschetta wrote:
> > Updated .gitignore to ignore x86_64/svm_vmcall_test and
> > s390x/resets test binaries.
> > 
> > Signed-off-by: Wainer dos Santos Moschetta <wainersm@redhat.com>
> 
> Oh, didn't know I needed to do that...
> Thanks for fixing this up.

I've already sent these, and they've been merged to kvm/queue.

> 
> Acked-by: Janosch Frank <frankja@linux.ibm.com>
> 
> > ---
> >  tools/testing/selftests/kvm/.gitignore | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> > index 30072c3f52fb..489b9cf9eed5 100644
> > --- a/tools/testing/selftests/kvm/.gitignore
> > +++ b/tools/testing/selftests/kvm/.gitignore
> > @@ -1,3 +1,4 @@
> > +/s390x/resets
> >  /s390x/sync_regs_test
> >  /s390x/memop
> >  /x86_64/cr4_cpuid_sync_test
> > @@ -8,6 +9,7 @@
> >  /x86_64/set_sregs_test
> >  /x86_64/smm_test
> >  /x86_64/state_test
> > +/x86_64/svm_vmcall_test
> >  /x86_64/sync_regs_test
> >  /x86_64/vmx_close_while_nested_test
> >  /x86_64/vmx_dirty_log_test
> > 
> 
> 



