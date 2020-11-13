Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3AB2B16C6
	for <lists+kvm@lfdr.de>; Fri, 13 Nov 2020 08:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726172AbgKMH5T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 02:57:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47515 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726147AbgKMH5T (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Nov 2020 02:57:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605254237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MlQGsyq2bCGnymTW4K+HmwkU7Tbj8htCqx1DYSzCAfs=;
        b=SU7yzjSsdaDCTIOPmzPX/Z7mvTk2GC3rVyLp8Go9iTXnKNEA7QmGp8n5N7VMbbJ+D2ZLlP
        s2SAaPDEEM+ji4xSAZIoPFuaqLcfNGxxgdN1G57bl5M0rD1TyQPi5IpHdtJNE3am2T8q3u
        map5rqsqmv9Zmu2JHT+0ht/D5NJPe24=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-7nE15YLKPGCh4xzMKLoISw-1; Fri, 13 Nov 2020 02:57:15 -0500
X-MC-Unique: 7nE15YLKPGCh4xzMKLoISw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8563257245;
        Fri, 13 Nov 2020 07:57:14 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.97])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C964E73660;
        Fri, 13 Nov 2020 07:57:09 +0000 (UTC)
Date:   Fri, 13 Nov 2020 08:57:06 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v2 02/11] KVM: selftests: Remove deadcode
Message-ID: <20201113075706.6lteawooppchxsda@kamzik.brq.redhat.com>
References: <20201111122636.73346-1-drjones@redhat.com>
 <20201111122636.73346-3-drjones@redhat.com>
 <20201112181921.GS26342@xz-x1>
 <CANgfPd_R_Rjn+QT_yiUwpCUK3TUfmhSN6XpZ5=L17mhrtMi7Zw@mail.gmail.com>
 <20201112185006.GY26342@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112185006.GY26342@xz-x1>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 12, 2020 at 01:50:06PM -0500, Peter Xu wrote:
> On Thu, Nov 12, 2020 at 10:34:11AM -0800, Ben Gardon wrote:
> > I didn't review this patch closely enough, and assumed the clear dirty
> > log was still being done because of
> > afdb19600719 KVM: selftests: Use a single binary for dirty/clear log test
> > 
> > Looking back now, I see that that is not the case.
> > 
> > I'd like to retract my endorsement in that case. I'd prefer to leave
> > the dead code in and I'll send another series to actually use it once
> > this series is merged. I've already written the code to use it and
> > time the clearing, so it seems a pity to remove it now.
> > 
> > Alternatively I could just revert this commit in that future series,
> > though I suspect not removing the dead code would reduce the chances
> > of merge conflicts. Either way works.
> > 
> > I can extend the dirty log mode functions from dirty_log_test for
> > dirty_log_perf_test in that series too.
> 
> Or... we can just remove all the "#ifdef" lines but assuming clear dirty log is
> always there? :) Assuming that is still acceptable as long as the test is
> matching latest kernel which definitely has the clear dirty log capability.
> 
> It's kind of weird to test get-dirty-log perf without clear dirty log, since
> again if anyone really cares about the perf of that, then imho they should
> first switch to a new kernel with clear dirty log, rather than measuring the
> world without clear dirty log..
>

I have no opinion on this other than I'd prefer KVM selftests to not have
deadcode. If it makes more sense to fix the deadcode by bringing it back
to life than to drop the code, then please send patches to do that, at
which point I'd be happy to recommend dropping this patch.

Thanks,
drew

