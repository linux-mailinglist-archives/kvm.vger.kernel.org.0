Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3D4F2F9DB4
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 12:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388710AbhARLL1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 06:11:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50956 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390051AbhARLLS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 06:11:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610968191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mbmg+uJYPTfhUMaZzAVKCaqtDELncDrVhg7kfvU9aBU=;
        b=hqGSaEF839Eg7B74mzj2jqT1T/uA6ouJFrdWLiwgNoIAzh8gakXgoo6t92O5f8SKwHE3Tl
        oRiWweUQejRQ3ggwwfMeBDIVIVzLQcZZgYkqrtFyAW+p4S5fMw68Uc19GT7mV1Bp09O/hH
        egqYdhPPQgIroEY7KECZolmZYkNH33M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-110-MnzDvEYKOaCRvXM6GiurpQ-1; Mon, 18 Jan 2021 06:09:49 -0500
X-MC-Unique: MnzDvEYKOaCRvXM6GiurpQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DF32F180A096;
        Mon, 18 Jan 2021 11:09:48 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.195.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AC2C010023AD;
        Mon, 18 Jan 2021 11:09:47 +0000 (UTC)
Date:   Mon, 18 Jan 2021 12:09:44 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        mlevitsk@redhat.com
Subject: Re: [RFC PATCH kvm-unit-tests 0/4] add generic stress test
Message-ID: <20210118110944.vsxw7urtbs7fmbhk@kamzik.brq.redhat.com>
References: <20201223010850.111882-1-pbonzini@redhat.com>
 <X+pbZ061gTIbM2Ef@google.com>
 <d9a81441-9f15-45c2-69c5-6295f2891874@redhat.com>
 <X/4igkJA1ZY5rCk7@google.com>
 <e94c0b18-6067-a62b-44a2-c1eef9c7b3ff@redhat.com>
 <YACl4jtDc1IGcxiQ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YACl4jtDc1IGcxiQ@google.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 14, 2021 at 12:13:22PM -0800, Sean Christopherson wrote:
> On Wed, Jan 13, 2021, Paolo Bonzini wrote:
> > On 12/01/21 23:28, Sean Christopherson wrote:
> > > What's the biggest hurdle for doing this completely within the unit test
> > > framework?  Is teaching the framework to migrate a unit test the biggest pain?
> > 
> > Yes, pretty much.  The shell script framework would show its limits.
> > 
> > That said, I've always treated run_tests.sh as a utility more than an
> > integral part of kvm-unit-tests.  There's nothing that prevents a more
> > capable framework from parsing unittests.cfg.
> 
> Heh, got anyone you can "volunteer" to create a new framework?  One-button
> migration testing would be very nice to have.  I suspect I'm not the only
> contributor that doesn't do migration testing as part of their standard workflow.
>

We have one-button migration tests already with kvm-unit-tests. Just
compile the tests that use the migration framework as standalone
tests and then run them directly.

I agree, though, that Bash is a pain for some of the stuff we're trying
to do. However, we do have requests to keep the framework written in Bash,
because KVM testing is regularly done with simulators and even in embedded
environments. It's not desirable, or even possible, to have e.g. Python
everywhere we want kvm-unit-tests.

Thanks,
drew

