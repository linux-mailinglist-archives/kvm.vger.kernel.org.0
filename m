Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 297572DE1D7
	for <lists+kvm@lfdr.de>; Fri, 18 Dec 2020 12:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728251AbgLRLOv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Dec 2020 06:14:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29507 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725875AbgLRLOv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Dec 2020 06:14:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608290004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Pi20OFL0G7DiRmJwORfQ7ueQMYvyNOyiwdsJ9Ix1NZ4=;
        b=cxuIapG4pHDvSo/jJ0fxSv9ufpwWDqSRPj+ylJvMQnxxvizAcHNpqTA+/mWga9KLPxKsVN
        1vV9TmkVz9pKvOfAxXODphnrHn5c3Zt0RlTdeu1waF/v8pf9E91yK0oCgjOS3AB/cA3Z+y
        JfsY6yvPX7KZeb+8QC4gRNrU4tzhADs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-I5SuSiGLNgSwt3369NKVDQ-1; Fri, 18 Dec 2020 06:13:23 -0500
X-MC-Unique: I5SuSiGLNgSwt3369NKVDQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B19AF107ACF6;
        Fri, 18 Dec 2020 11:13:21 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.59])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D9AED60C15;
        Fri, 18 Dec 2020 11:13:16 +0000 (UTC)
Date:   Fri, 18 Dec 2020 12:13:13 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        bgardon@google.com, peterx@redhat.com
Subject: Re: [PATCH v3 0/4] KVM: selftests: Cleanups, take 2
Message-ID: <20201218111313.d6n6t4mrsgpvwxwu@kamzik.brq.redhat.com>
References: <20201116121942.55031-1-drjones@redhat.com>
 <902d4020-e295-b21f-cc7a-df5cdfc056ea@redhat.com>
 <20201120080556.2enu4ygvlnslmqiz@kamzik.brq.redhat.com>
 <6c53eb4d-32ed-ed94-a3ef-dca139b0003d@redhat.com>
 <20201216124638.paliq7v3erhpgfh6@kamzik.brq.redhat.com>
 <72e73cdc-dcbd-871d-13fb-57ee3a65d407@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72e73cdc-dcbd-871d-13fb-57ee3a65d407@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 18, 2020 at 11:32:02AM +0100, Paolo Bonzini wrote:
> On 16/12/20 13:46, Andrew Jones wrote:
> > On Fri, Nov 20, 2020 at 09:48:26AM +0100, Paolo Bonzini wrote:
> > > On 20/11/20 09:05, Andrew Jones wrote:
> > > > So I finally looked closely enough at the dirty-ring stuff to see that
> > > > patch 2 was always a dumb idea. dirty_ring_create_vm_done() has a comment
> > > > that says "Switch to dirty ring mode after VM creation but before any of
> > > > the vcpu creation". I'd argue that that comment would be better served at
> > > > the log_mode_create_vm_done() call, but that doesn't excuse my sloppiness
> > > > here. Maybe someday we can add a patch that adds that comment and also
> > > > tries to use common code for the number of pages calculation for the VM,
> > > > but not today.
> > > > 
> > > > Regarding this series, if the other three patches look good, then we
> > > > can just drop 2/4. 3/4 and 4/4 should still apply cleanly and work.
> > > 
> > > Yes, the rest is good.
> > > 
> > 
> > Ping?
> 
> Sorry, I was waiting for a resend.
>

Oops, I understood that we'd just drop 2/4 while applying. Should I resend
now?

Thanks,
drew 

