Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6797415D5B6
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 11:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729251AbgBNKbN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 05:31:13 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:26609 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729247AbgBNKbM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Feb 2020 05:31:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581676271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9HKoyoVg/u/CUbmrFogk2SqCeYpRd2bRWzXRnc2aTCA=;
        b=R54y6Ao+cD+7YDb2E4teh8OW8PSpMFElj8VDrbrmi13CdV3UKYDZb/fnWv8uthhuENXxKE
        GASulEeohGHeISss3LAkMkex8YrjUuk8GGQWnGnu6pe+V14DrQd3G5UXoQsIjBdznkIZFU
        M/xxQQMGLHbudnolZDV4W8FZnhAGveo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-JBHWFknxOQisFpuOznl5yg-1; Fri, 14 Feb 2020 05:31:10 -0500
X-MC-Unique: JBHWFknxOQisFpuOznl5yg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1444A13E6;
        Fri, 14 Feb 2020 10:31:09 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A78EB26E7D;
        Fri, 14 Feb 2020 10:31:02 +0000 (UTC)
Date:   Fri, 14 Feb 2020 11:30:59 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, peter.maydell@linaro.org,
        alex.bennee@linaro.org, pbonzini@redhat.com, lvivier@redhat.com,
        thuth@redhat.com, frankja@linux.ibm.com, eric.auger@redhat.com
Subject: Re: [PATCH kvm-unit-tests 2/2] runtime: Introduce VMM_PARAMS
Message-ID: <20200214103059.vcvsg6mfr3mo7dnm@kamzik.brq.redhat.com>
References: <20200213143300.32141-1-drjones@redhat.com>
 <20200213143300.32141-3-drjones@redhat.com>
 <b455b420-bdbd-8389-4a9c-c28a9970bfc2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b455b420-bdbd-8389-4a9c-c28a9970bfc2@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 14, 2020 at 11:14:49AM +0100, David Hildenbrand wrote:
> On 13.02.20 15:33, Andrew Jones wrote:
> > Users may need to temporarily provide additional VMM parameters.
> > The VMM_PARAMS environment variable provides a way to do that.
> > We take care to make sure when executing ./run_tests.sh that
> > the VMM_PARAMS parameters come last, allowing unittests.cfg
> > parameters to be overridden. However, when running a command
> > line like `$ARCH/run $TEST $PARAMS` we want $PARAMS to override
> > $VMM_PARAMS, so we ensure that too.
> 
> While reading this, I was wondering why not simply "$QEMU_PARAMS"?

I'd like to slowly move away from assuming QEMU is the VMM. We
already have support for kvmtool (to some degree) and I'd like
to see that support increase. Also, maybe we'll eventually add
support for a rust-vmm reference VMM to drive kvm-unit-tests.
IOW, rather than add yet another QEMU named variable I'd like
to start a trend of using VMM named variables. Actually, we
could add VMM named alternatives for the QEMU named ones we have
now and start using them in the scripts. We'd just need to remap
the old names for backward compatibility early in the run.

Thanks,
drew

