Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 071632A9309
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 10:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbgKFJpZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 04:45:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32289 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725868AbgKFJpZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Nov 2020 04:45:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604655924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fJ7sAstwlEzjVqpCmCx9AOq8F4RCIaELE3f6EU6QGdA=;
        b=LjFDEVNLlyOW6YU2o0RQaxnqKsoxCNoeXCaRBM1P9gpG2ko/PPdUCcrbf28yNFq46CYcxV
        3RnZF2ssx15bf/z4BB4lMGKw2KHR/c5wRKCtKvoExh/K40iAkG1l2VzwS4/V5DBshMlW24
        PPYHmBIVqu/Qg0pXOC39Ktq6zY97UKQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-q7D_GGfyP7i7VmchIUomjQ-1; Fri, 06 Nov 2020 04:45:22 -0500
X-MC-Unique: q7D_GGfyP7i7VmchIUomjQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F0D461074644;
        Fri,  6 Nov 2020 09:45:20 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.153])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 67E495C5FD;
        Fri,  6 Nov 2020 09:45:14 +0000 (UTC)
Date:   Fri, 6 Nov 2020 10:45:11 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Peter Xu <peterx@redhat.com>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH 00/11] KVM: selftests: Cleanups
Message-ID: <20201106094511.s4dj2a7n32dawt7m@kamzik.brq.redhat.com>
References: <20201104212357.171559-1-drjones@redhat.com>
 <20201105185554.GD106309@xz-x1>
 <CANgfPd_97QGP+q8-_VAzhJxw_kdiHcFukAZ-dSp4cNrvKdNEpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd_97QGP+q8-_VAzhJxw_kdiHcFukAZ-dSp4cNrvKdNEpg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 05, 2020 at 11:41:24AM -0800, Ben Gardon wrote:
> On Thu, Nov 5, 2020 at 10:56 AM Peter Xu <peterx@redhat.com> wrote:
> >
> > On Wed, Nov 04, 2020 at 10:23:46PM +0100, Andrew Jones wrote:
> > > This series attempts to clean up demand_paging_test and dirty_log_test
> > > by factoring out common code, creating some new API along the way. It's
> > > main goal is to prepare for even more factoring that Ben and Peter want
> > > to do. The series would have a nice negative diff stat, but it also
> > > picks up a few of Peter's patches for his new dirty log test. So, the
> > > +/- diff stat is close to equal. It's not as close as an electoral vote
> > > count, but it's close.
> > >
> > > I've tested on x86 and AArch64 (one config each), but not s390x.
> >
> > The whole series looks good to me (probably except the PTRS_PER_PAGE one; but
> > that's not hurting much anyways, I think).  Thanks for picking up the other
> > patches, even if they made the diff stat much less pretty..
> 
> This series looks good to me too. Thanks for doing this Drew!
> 
> Sorry I'm later than I wanted to be in reviewing this series. I
> learned I was exposed to someone with COVID yesterday, so I've been a
> bit scattered. The dirty log perf test series v3 might be delayed a
> bit as a result, but I'll send it out as soon as I can after this
> series is merged.
>

Yikes! Don't worry about KVM selftests then. Except for one more question?
Can I translate your "looks good to me" into a r-b for the series? And,
same question for Peter. I'll be respinning witht eh PTES_PER_PAGE change
and can add your guys' r-b's if you want to give them.

Thanks,
drew

