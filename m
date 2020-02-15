Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60D1415FD45
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2020 08:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbgBOHEt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 15 Feb 2020 02:04:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42115 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725901AbgBOHEt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 15 Feb 2020 02:04:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581750288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PrsQ1Qw9AgQOvSRorRQoOmCLJumbYsZ8sS8oW7XJ8zY=;
        b=O7PseP5oJE9jFV6CJ2TZ8JRw6sMQeryt9mFtbaLoQpPjXySoITQjOYnUh36O2zRNotybG8
        jDQ9tUHeNtjqoiX1RITzWJdgCzPZpt0werFx0L0P1ntpfElXCQK/plmnDUSa2nKUfTtNCE
        2Ng40xGZde2M5iGyKFr1eyk1hCXRPTg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-HDVtKzjkNyGXZPTMEgX1sg-1; Sat, 15 Feb 2020 02:04:46 -0500
X-MC-Unique: HDVtKzjkNyGXZPTMEgX1sg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DEC3D107ACCA;
        Sat, 15 Feb 2020 07:04:44 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ECAEE5C1C3;
        Sat, 15 Feb 2020 07:04:40 +0000 (UTC)
Date:   Sat, 15 Feb 2020 08:04:38 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, bgardon@google.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, thuth@redhat.com, peterx@redhat.com
Subject: Re: [PATCH 00/13] KVM: selftests: Various fixes and cleanups
Message-ID: <20200215070438.vxhin6f4hl6y3qfc@kamzik.brq.redhat.com>
References: <20200214145920.30792-1-drjones@redhat.com>
 <8e6f6dad-6404-94b6-044f-156ab7647009@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e6f6dad-6404-94b6-044f-156ab7647009@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 14, 2020 at 04:23:56PM +0100, Paolo Bonzini wrote:
> On 14/02/20 15:59, Andrew Jones wrote:
> > This series has several parts:
> > 
> >  * First, a hack to get x86 to compile. The missing __NR_userfaultfd
> >    define should be fixed a better way.
> > 
> >  * Then, fixups for several commits in kvm/queue. These fixups correspond
> >    to review comments that didn't have a chance to get addressed before
> >    the commits were applied.
> 
> Right, that's why they're in kvm/queue only. :)  Did you test this
> series on aarch64?

Yup

> 
> Paolo
> 
> > 
> >  * Next, a few unnecessary #define/#ifdef deletions.
> > 
> >  * Then, a rework of debug and info message printing.
> > 
> >  * Finally, an addition to the API, num-pages conversion utilities,
> >    which cleans up all the num-pages calculations.
> 

