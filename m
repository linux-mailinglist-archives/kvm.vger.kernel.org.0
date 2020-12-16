Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 510D42DC082
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 13:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbgLPMsn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 07:48:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55124 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726044AbgLPMsn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Dec 2020 07:48:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608122836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kfzYxCyTjHrFC4Rv1VBa+4B22tlACHoq5hjmmViJzUY=;
        b=F8NVgsGzPQg+lYzO4uu5gPks/ldmY/WKgnlxDEfFqPTJ+boXKJmOAS0a/hK4LeVUWPToLH
        PP+cfof/yxsjB7fG3Uvvotf9C9I+hDTiNrEWGUDB784k84lpa7AF7iL4EYpn1FanOam5Dm
        yFfNWao0UDQ7LqmHPV67hOzkAHSCUZs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-F1EGZ-4xM0mq9-tWp4Qq9A-1; Wed, 16 Dec 2020 07:47:15 -0500
X-MC-Unique: F1EGZ-4xM0mq9-tWp4Qq9A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0F9C5F9E6;
        Wed, 16 Dec 2020 12:47:12 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.81])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E12E460C82;
        Wed, 16 Dec 2020 12:46:41 +0000 (UTC)
Date:   Wed, 16 Dec 2020 13:46:38 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        bgardon@google.com, peterx@redhat.com
Subject: Re: [PATCH v3 0/4] KVM: selftests: Cleanups, take 2
Message-ID: <20201216124638.paliq7v3erhpgfh6@kamzik.brq.redhat.com>
References: <20201116121942.55031-1-drjones@redhat.com>
 <902d4020-e295-b21f-cc7a-df5cdfc056ea@redhat.com>
 <20201120080556.2enu4ygvlnslmqiz@kamzik.brq.redhat.com>
 <6c53eb4d-32ed-ed94-a3ef-dca139b0003d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c53eb4d-32ed-ed94-a3ef-dca139b0003d@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 20, 2020 at 09:48:26AM +0100, Paolo Bonzini wrote:
> On 20/11/20 09:05, Andrew Jones wrote:
> > So I finally looked closely enough at the dirty-ring stuff to see that
> > patch 2 was always a dumb idea. dirty_ring_create_vm_done() has a comment
> > that says "Switch to dirty ring mode after VM creation but before any of
> > the vcpu creation". I'd argue that that comment would be better served at
> > the log_mode_create_vm_done() call, but that doesn't excuse my sloppiness
> > here. Maybe someday we can add a patch that adds that comment and also
> > tries to use common code for the number of pages calculation for the VM,
> > but not today.
> > 
> > Regarding this series, if the other three patches look good, then we
> > can just drop 2/4. 3/4 and 4/4 should still apply cleanly and work.
> 
> Yes, the rest is good.
>

Ping?

Thanks,
drew 

