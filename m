Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA11E24243A
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 05:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgHLDSY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Aug 2020 23:18:24 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:41532 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726333AbgHLDSY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Aug 2020 23:18:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597202303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7bSgMTikkOoBiiFOJJO1JmXZqy2k64tzUAstOOkGvOA=;
        b=G4XPXWue8uRrCdSK5zpROCRYPGSLdUbtjt/4bqwdwer1jpxGWp/s6pCktMFBFLuvjaS2E0
        /GDF9Rtv7/6C5nwbfHXWCXGuav18LN84Fj/ssgVxXi9w1sPqD+GcsIIqgdg6kLfsaPcVi7
        pQ5SkzB60OjfmUNi5cxTizcZNd26jIo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-tZlBju8PP7mf44l-DNIYJA-1; Tue, 11 Aug 2020 23:18:14 -0400
X-MC-Unique: tZlBju8PP7mf44l-DNIYJA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC027100A614;
        Wed, 12 Aug 2020 03:18:13 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 588FC61462;
        Wed, 12 Aug 2020 03:18:13 +0000 (UTC)
Date:   Tue, 11 Aug 2020 21:18:12 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>,
        Laszlo Ersek <lersek@redhat.com>
Subject: Re: [PATCH] kvm: x86: Read PDPTEs on CR0.CD and CR0.NW changes
Message-ID: <20200811211812.31e8dd63@x1.home>
In-Reply-To: <CALMp9eSq-PenitkYiCJu3hXcYsWqi4FCpPnAA2TXfH_rmAxgAw@mail.gmail.com>
References: <20200707223630.336700-1-jmattson@google.com>
        <20200811193437.286ba711@x1.home>
        <CALMp9eSq-PenitkYiCJu3hXcYsWqi4FCpPnAA2TXfH_rmAxgAw@mail.gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 Aug 2020 19:45:17 -0700
Jim Mattson <jmattson@google.com> wrote:

> On Tue, Aug 11, 2020 at 6:34 PM Alex Williamson
> <alex.williamson@redhat.com> wrote:
> >
> > On Tue,  7 Jul 2020 15:36:30 -0700
> > Jim Mattson <jmattson@google.com> wrote:
> >  
> > > According to the SDM, when PAE paging would be in use following a
> > > MOV-to-CR0 that modifies any of CR0.CD, CR0.NW, or CR0.PG, then the
> > > PDPTEs are loaded from the address in CR3. Previously, kvm only loaded
> > > the PDPTEs when PAE paging would be in use following a MOV-to-CR0 that
> > > modified CR0.PG.
> > >
> > > Signed-off-by: Jim Mattson <jmattson@google.com>
> > > Reviewed-by: Oliver Upton <oupton@google.com>
> > > Reviewed-by: Peter Shier <pshier@google.com>
> > > ---  
> >
> > I can't even boot the simplest edk2 VM with this commit:  
> 
> You'll probably want to apply Sean's [PATCH] KVM: x86: Don't attempt
> to load PDPTRs when 64-bit mode is enabled.

Thanks for the pointer, yes, that resolves it.  Thanks,

Alex

