Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E42011E7D14
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 14:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgE2MXI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 08:23:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28987 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725865AbgE2MXI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 08:23:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590754986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tmGLttgPBGZ9XH5hVdAchN0aFxvGTE4asWU7gNX3l5c=;
        b=cFqOiA0adTmNjfaFzkDhppa2trgX+WYVavkzscdems6eYI9nr48Jfmm3oknJWY3ixu3SXC
        45Wk7al2QBhiBo2aYFXfJYD9iWoPMMAkEoEz+92khIuwvIiCdbTWTPAZJmi3n9M6HCa2RE
        grmj/nCTbkldQVxsfrYcGSfSVzBD2Jo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-Op5BGK0vMra4_35FvVJB_w-1; Fri, 29 May 2020 08:23:02 -0400
X-MC-Unique: Op5BGK0vMra4_35FvVJB_w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A7AF107ACF4;
        Fri, 29 May 2020 12:23:01 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.208.78])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 495551001B07;
        Fri, 29 May 2020 12:22:59 +0000 (UTC)
Message-ID: <9126d22f6349c8b09884ebe5b02769b1f2645a0b.camel@redhat.com>
Subject: Re: [PATCH kvm-unit-tests] access: disable phys-bits=36 for now
From:   Mohammed Gamal <mgamal@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org
Date:   Fri, 29 May 2020 14:22:55 +0200
In-Reply-To: <4832b457-3b6b-b489-4364-a7f5593189a8@redhat.com>
References: <20200528124742.28953-1-pbonzini@redhat.com>
         <87d06o2fbb.fsf@vitty.brq.redhat.com>
         <20200528214527.GG30353@linux.intel.com>
         <4832b457-3b6b-b489-4364-a7f5593189a8@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2020-05-29 at 10:48 +0200, Paolo Bonzini wrote:
> On 28/05/20 23:45, Sean Christopherson wrote:
> > On Thu, May 28, 2020 at 06:29:44PM +0200, Vitaly Kuznetsov wrote:
> > > Paolo Bonzini <pbonzini@redhat.com> writes:
> > > 
> > > > Support for guest-MAXPHYADDR < host-MAXPHYADDR is not upstream
> > > > yet,
> > > > it should not be enabled.  Otherwise, all the pde.36 and pte.36
> > > > fail and the test takes so long that it times out.
> > > > 
> > > > Reported-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> > > > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > > > ---
> > > >  x86/unittests.cfg | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> > > > index bf0d02e..d658bc8 100644
> > > > --- a/x86/unittests.cfg
> > > > +++ b/x86/unittests.cfg
> > > > @@ -116,7 +116,7 @@ extra_params = -cpu qemu64,+x2apic,+tsc-
> > > > deadline -append tscdeadline_immed
> > > >  [access]
> > > >  file = access.flat
> > > >  arch = x86_64
> > > > -extra_params = -cpu host,phys-bits=36
> > > > +extra_params = -cpu host
> > > >  
> > > >  [smap]
> > > >  file = smap.flat
> > > 
> > > Works both VMX and SVM, thanks!
> > 
> > What's the status of the "guest-MAXPHYADDR < host-MAXPHYADDR" work?
> 
> Mohammed was working on it, we should have it in 5.9.
> 
> > I ask because the AC_PTE_BIT51 and AC_PDE_BIT51 subtests are broken
> > on CPUs with 52 bit PAs.  Is it worth sending a patch to
> > temporarily
> > disable those tests if MAXPHYADDR=52?
> It's a QEMU bug that it does not enable host_phys_bits=on by default
> for
> "-cpu host".  For now I'll tweak this patch to add it manually.
> 
> Paolo
> 

I actually did send a fix earlier

https://www.spinics.net/lists/kvm/msg215716.html

