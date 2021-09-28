Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19EF841A9A2
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 09:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239213AbhI1HZy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 03:25:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55331 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236713AbhI1HZy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Sep 2021 03:25:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632813854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bWGC7oTmfGjxKcdKJd504L6aMYPeDx74J8LvM7PKm0s=;
        b=UXBo4Vt/JmParNzdvclNOlkKETqIKNyFTWuwxu3pVmo4OFfvkgo2VjvF0GIZm1G1GYKWNZ
        lSXVg92tivzGbB6sNWbLvM/tN8U+e+ip1pfFCASlKlepE00ORvFo7FM1SSGsAuupxEu8X5
        Pfs/RHRrMdlDxkEQPY+M0v2eRdw2P2A=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-DhX5ytFyNoqlcF_JfcQQ7g-1; Tue, 28 Sep 2021 03:24:13 -0400
X-MC-Unique: DhX5ytFyNoqlcF_JfcQQ7g-1
Received: by mail-ed1-f71.google.com with SMTP id 2-20020a508e02000000b003d871759f5dso20684941edw.10
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 00:24:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bWGC7oTmfGjxKcdKJd504L6aMYPeDx74J8LvM7PKm0s=;
        b=RktRBR2NiAnCmctmoExpeAxZvfopT4YAKTbJZDJirjz7YMpQWOP8qv43JBATEf+LDK
         9BFEaXwpMNLA7pNfC7IPXT2+MOy/lIAze/2EGTiSinrK5IqbVSGVqGolDksl70Lf01NP
         VBx58aD3QlIE4jUdikj/vBCOM2cD7N5LK4I4e6SZYIL4IQY5I7TcUZ1visGVxgL9NYYU
         m5VuzMiWfMPOK2m4NhkSqlWccrhquWMO1mxYOTczHs0QWNK00zcPodMKi7J2XhE0uiF/
         cfnEubBAkxrg81zugUb9SrBX+zBFTYm0OXQFKTeepT1zvTjbh1wIMVYvEDxGqmA/kDme
         wdwA==
X-Gm-Message-State: AOAM533bGom0IHsdoyrP5es3OTxp0JJU8CwrCXWxmuLqySVVGXLz1I/3
        agc3+URHvgkhkmgbbkgekWgFcE1/SCbWZB1DnUPtL8NokmPsCd40N0u8VNP42Az10lr5Cza9/pk
        Ka3pZf9oKUT8y
X-Received: by 2002:a17:906:6c83:: with SMTP id s3mr5124252ejr.13.1632813852136;
        Tue, 28 Sep 2021 00:24:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxAUxOXAqxe7tw2Hl4EfMfwGMkveziu4koresAVxFaRgDKbcZMqmqP/pKKJj5b+3QAkJO8dxg==
X-Received: by 2002:a17:906:6c83:: with SMTP id s3mr5124236ejr.13.1632813851955;
        Tue, 28 Sep 2021 00:24:11 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id q12sm9791038ejs.58.2021.09.28.00.24.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 00:24:11 -0700 (PDT)
Date:   Tue, 28 Sep 2021 09:24:09 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] selftests: KVM: Call ucall_init when setting up in
 rseq_test
Message-ID: <20210928072409.ks6b6u3rs7qngije@gator.home>
References: <20210923220033.4172362-1-oupton@google.com>
 <YU0XIoeYpfm1Oy0j@google.com>
 <20210924064732.xqv2xjya3pxgmwr2@gator.home>
 <YVIj+gExrHrjlQEm@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVIj+gExrHrjlQEm@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 27, 2021 at 08:05:14PM +0000, Sean Christopherson wrote:
> On Fri, Sep 24, 2021, Andrew Jones wrote:
> > On Fri, Sep 24, 2021 at 12:09:06AM +0000, Sean Christopherson wrote:
> > > On Thu, Sep 23, 2021, Oliver Upton wrote:
> > > > While x86 does not require any additional setup to use the ucall
> > > > infrastructure, arm64 needs to set up the MMIO address used to signal a
> > > > ucall to userspace. rseq_test does not initialize the MMIO address,
> > > > resulting in the test spinning indefinitely.
> > > > 
> > > > Fix the issue by calling ucall_init() during setup.
> > > > 
> > > > Fixes: 61e52f1630f5 ("KVM: selftests: Add a test for KVM_RUN+rseq to detect task migration bugs")
> > > > Signed-off-by: Oliver Upton <oupton@google.com>
> > > > ---
> > > >  tools/testing/selftests/kvm/rseq_test.c | 1 +
> > > >  1 file changed, 1 insertion(+)
> > > > 
> > > > diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
> > > > index 060538bd405a..c5e0dd664a7b 100644
> > > > --- a/tools/testing/selftests/kvm/rseq_test.c
> > > > +++ b/tools/testing/selftests/kvm/rseq_test.c
> > > > @@ -180,6 +180,7 @@ int main(int argc, char *argv[])
> > > >  	 * CPU affinity.
> > > >  	 */
> > > >  	vm = vm_create_default(VCPU_ID, 0, guest_code);
> > > > +	ucall_init(vm, NULL);
> > > 
> > > Any reason not to do this automatically in vm_create()?  There is 0% chance I'm
> > > going to remember to add this next time I write a common selftest, arm64 is the
> > > oddball here.
> 
> Ugh, reading through arm64's ucall_init(), moving this to vm_create() is a bad
> idea.  If a test creates memory regions at hardcoded address, the test could
> randomly fail if ucall_init() selects a conflicting address.  More below.
> 
> > Yes, please. But, it'll take more than just adding a ucall_init(vm, NULL)
> > call to vm_create. We should also modify aarch64's ucall_init to allow
> > a *new* explicit mapping to be made. It already allows an explicit mapping
> > when arg != NULL, but we'll need to unmap the default mapping first, now.
> > The reason is that a unit test may not be happy with the automatically
> > selected address (that hasn't happened yet, but...) and want to set its
> > own.
> 
> My vote would be to rework arm64's ucall_init() as a prep patch and drop the param
> in the process.  There are zero tests that provide a non-NULL value, but that's
> likely because tests that care deliberately defer ucall_init() until after memory
> regions and page tables have been configured.
> 
> IMO, arm64's approach is unnecessarily complex (that's a common theme for KVM's
> selftests...).  The code attempts to avoid magic numbers by not hardcoding the MMIO
> range, but in doing so makes the end result even more magical, e.g. starting at
> 5/8ths of min(MAX_PA, MAX_VA).
> 
> E.g. why not put the ucall MMIO range immediately after the so called "default"
> memory region added at the end of vm_create()?  That way the location of the ucall
> range is completely predictable, and while still arbitrary, less magical.
>

While we do hardcode zero as the guest physical base address, we don't
require tests to use DEFAULT_GUEST_PHY_PAGES for slot0. They only get
that if they use vm_create_default* to create the vm. While trying to
keep the framework flexible for the unit tests does lead to complexity,
I think the ucall mmio address really needs to be something that can move.
It's not part of the test setup, i.e. whatever the unit test wants to
test, it's just part of the framework. It needs to stay out of the way.

You're right that we can't improve things by adding ucall_init to
vm_create though, even if we added my suggestion of changing ucall_init
to be an unmap-old, map-new type of thing, since we'd still always need
the deferred ucall_init call to be sure we got it right.

We could replace the mmio address search with a hardcoded default address
though, probably the start address of the search (most likely that's the
one that's always used). Then, if there's a problem with that address,
an explicit ucall_init with its optional argument would need to be
provided in the unit test, along with a comment explaining why it's
there to ensure nobody removes it.

Thanks,
drew

