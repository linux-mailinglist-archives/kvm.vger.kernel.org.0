Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCAA42FC270
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 22:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbhASVfi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 16:35:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30538 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392487AbhASSmL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Jan 2021 13:42:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611081644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vTH/DcuQM5k/SGiS518aLKuzVJjSUqtwRTCW2SXhRpo=;
        b=eiAHxcWk4TUNG9ZoFH64MNYFp4fhHI6vSiqqWUBJnwa8Iy8tGIQs15e1VRmrq3Erhf0U5G
        IZRSwrB0urZDuBvTkwNOizS3c6DH0DEJUmHFomzTda1zPiS0Hgqa79ZgQhAUKNhlF8s883
        wCxspSMGflfrMbu6z6MrR59HE9lQxmQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-_vBsDXShMfSWg2CfEqdO5g-1; Tue, 19 Jan 2021 13:40:42 -0500
X-MC-Unique: _vBsDXShMfSWg2CfEqdO5g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A9000800D55;
        Tue, 19 Jan 2021 18:40:41 +0000 (UTC)
Received: from kamzik.brq.redhat.com (ovpn-112-82.ams2.redhat.com [10.36.112.82])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E1BEA60C0F;
        Tue, 19 Jan 2021 18:40:37 +0000 (UTC)
Date:   Tue, 19 Jan 2021 19:40:35 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        mlevitsk@redhat.com
Subject: Re: [RFC PATCH kvm-unit-tests 0/4] add generic stress test
Message-ID: <20210119184035.7ayrip27hl2euv3g@kamzik.brq.redhat.com>
References: <20201223010850.111882-1-pbonzini@redhat.com>
 <X+pbZ061gTIbM2Ef@google.com>
 <d9a81441-9f15-45c2-69c5-6295f2891874@redhat.com>
 <X/4igkJA1ZY5rCk7@google.com>
 <e94c0b18-6067-a62b-44a2-c1eef9c7b3ff@redhat.com>
 <YACl4jtDc1IGcxiQ@google.com>
 <20210118110944.vsxw7urtbs7fmbhk@kamzik.brq.redhat.com>
 <YAcYz4nxVXHKfkXu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAcYz4nxVXHKfkXu@google.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 19, 2021 at 09:37:19AM -0800, Sean Christopherson wrote:
> On Mon, Jan 18, 2021, Andrew Jones wrote:
> > On Thu, Jan 14, 2021 at 12:13:22PM -0800, Sean Christopherson wrote:
> > > On Wed, Jan 13, 2021, Paolo Bonzini wrote:
> > > > On 12/01/21 23:28, Sean Christopherson wrote:
> > > > > What's the biggest hurdle for doing this completely within the unit test
> > > > > framework?  Is teaching the framework to migrate a unit test the biggest pain?
> > > > 
> > > > Yes, pretty much.  The shell script framework would show its limits.
> > > > 
> > > > That said, I've always treated run_tests.sh as a utility more than an
> > > > integral part of kvm-unit-tests.  There's nothing that prevents a more
> > > > capable framework from parsing unittests.cfg.
> > > 
> > > Heh, got anyone you can "volunteer" to create a new framework?  One-button
> > > migration testing would be very nice to have.  I suspect I'm not the only
> > > contributor that doesn't do migration testing as part of their standard workflow.
> > >
> > 
> > We have one-button migration tests already with kvm-unit-tests. Just
> > compile the tests that use the migration framework as standalone
> > tests and then run them directly.
> 
> Do those exist/work for x86?  I see migration stuff for Arm and PPC, but nothing
> for x86.

Right, we don't have migration tests yet for x86. Of course that's just a
matter of programming... We'll also need to add an x86 __getchar() first.

Thanks,
drew

