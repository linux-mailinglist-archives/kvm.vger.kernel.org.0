Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 960BC2330FC
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 13:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbgG3Lcd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 07:32:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48254 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726615AbgG3Lcc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 07:32:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596108750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=McSuEto/YPhol+OeRLXWUqvMQxiQchWIBSGrGWcv4NM=;
        b=Wqrh85l9yGLioNDho1ddM+l1tZPWVWlRG7NcW3s1Tv2nwzCkUM9cvbMbkyd4mWpTUuEd5S
        6T+5xn0T9i7jISkDgZSJl3OHwwQ+wjtBu6vzkzLvof5nMqfITAwBOmblhQ+9q7WIQyG67U
        M5R0qVASnSaRHrrfyuOWC4UauUznPVU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-wVeI_XPbPQSEY5S7NuSbWw-1; Thu, 30 Jul 2020 07:32:25 -0400
X-MC-Unique: wVeI_XPbPQSEY5S7NuSbWw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D62E803AE8;
        Thu, 30 Jul 2020 11:32:24 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.106])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 45188920C0;
        Thu, 30 Jul 2020 11:32:18 +0000 (UTC)
Date:   Thu, 30 Jul 2020 13:32:15 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Nadav Amit <namit@vmware.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Thomas Huth <thuth@redhat.com>, KVM <kvm@vger.kernel.org>,
        Laurent Vivier <lvivier@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Liran Alon <liran.alon@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: A new name for kvm-unit-tests ?
Message-ID: <20200730113215.dakrrilcdz5p4z7e@kamzik.brq.redhat.com>
References: <dc518389-945a-1887-7ad0-00ebaf9ae30e@redhat.com>
 <682fe35c-f4ea-2540-f692-f23a42c6d56b@de.ibm.com>
 <c8e83bff-1762-f719-924f-618bd29e7894@redhat.com>
 <CANRm+Czsb79JYAHcOm49tg=M2vHdOzh_XFaEcSS_RUPfX3dRuw@mail.gmail.com>
 <c92c6905-fcfb-ea5b-8c80-1025488adc98@redhat.com>
 <1B9660BF-6A81-475E-B80C-632C6D8F4BF9@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1B9660BF-6A81-475E-B80C-632C6D8F4BF9@vmware.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 30, 2020 at 07:50:39AM +0000, Nadav Amit wrote:
> > On Jul 30, 2020, at 12:35 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> > 
> > On 30/07/20 09:13, Wanpeng Li wrote:
> >>>> I personally dislike renames as you will have old references lurking in
> >>>> the internet for decades. A rename will result in people continue to using
> >>>> the old code because the old name is the only thing that they know.
> >>> 
> >>> +1 for keeping the old name.
> >>> 
> >>> cpu-unit-tests might also not be completely fitting (I remember we
> >>> already do test, or will test in the future I/O stuff like PCI, CCW, ...).
> >>> 
> >>> IMHO, It's much more a collection of tests to verify
> >>> architecture/standard/whatever compliance (including paravirtualized
> >>> interfaces if available).
> > 
> > Good point.
> > 
> >> Vote for keeping the old name.
> > 
> > Ok, so either old name or alternatively arch-unit-tests?  But the
> > majority seems to be for kvm-unit-tests, and if Nadav has no trouble
> > contributing to them I suppose everyone else can too.
> 
> Indeed. My employer (VMware) did not give me hard time (so far) in
> contributing to the project just because it has KVM in its name. We (VMware)
> also benefit from kvm-unit-tests, and Paolo and others were receptive to
> changes that I made to make it more kvm/qemu -independent. This is what
> matters.
> 
> So I am ok with the name being kvm-unit-tests. But I would ask/recommend
> that the project description [1] be updated to reflect the fact that the
> project is hypervisor-agnostic.

Good idea. Although while I authored what you see there, I don't really
want to sign up to do all the writing. How about when we create the gitlab
project we also create a .md file that we redirect [1] to? Then anybody
can submit patches for it going forward.

> 
> This should have practical implications. I remember, for example, that I had
> a discussion with Paolo in the past regarding “xpass” being reported as a
> failure. The rationale was that if a test that is expected to fail on KVM
> (since KVM is known to be broken) surprisingly passes, there is some problem
> that should be reported as a failure. I would argue that if the project is
> hypervisor-agnostic, “xpass” is not a failure.

We can use compile-time or run-time logic that depends on the target to
decide whether a test should be a normal test (pass/fail) or an
xpass/xfail test.

Thanks,
drew

> 
> So it is much more important how the project is defined than how it is
> named.
> 
> [1] http://www.linux-kvm.org/page/KVM-unit-tests

