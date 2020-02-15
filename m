Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4398815FD44
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2020 08:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725880AbgBOHEP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 15 Feb 2020 02:04:15 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33725 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725822AbgBOHEP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 15 Feb 2020 02:04:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581750254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JoY4YLyP2+W0V/opHZ65wp72dJOipTBwrRdMDgcP9iY=;
        b=XmUpgtXNZZPfSM3b5GuYdJ90JHDccSgJdFKCnGsRpApBpv2db4izxuBUpaW+dYsxWR4kTU
        XDhWDjVplR5ESgX2UtmXHm6OgD9wAzvQJoSOI/aBF6DVdA6SU1pX4j16yTLZgV4+bzlpUa
        gIjFlC4D+lMvow+HcDKl+t/XzXU1dYA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-259-zuaqQKtvODaBljT7JkBX6A-1; Sat, 15 Feb 2020 02:04:12 -0500
X-MC-Unique: zuaqQKtvODaBljT7JkBX6A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F831107ACC7;
        Sat, 15 Feb 2020 07:04:11 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A3C91859BF;
        Sat, 15 Feb 2020 07:04:07 +0000 (UTC)
Date:   Sat, 15 Feb 2020 08:04:05 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, bgardon@google.com,
        frankja@linux.ibm.com, thuth@redhat.com, peterx@redhat.com
Subject: Re: [PATCH 02/13] fixup! KVM: selftests: Add support for
 vcpu_args_set to aarch64 and s390x
Message-ID: <20200215070405.ny4ikj62rb66ri3f@kamzik.brq.redhat.com>
References: <20200214145920.30792-1-drjones@redhat.com>
 <20200214145920.30792-3-drjones@redhat.com>
 <40bc77ed-a5d8-bfed-3f77-5445ba667f97@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40bc77ed-a5d8-bfed-3f77-5445ba667f97@de.ibm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 14, 2020 at 09:35:06PM +0100, Christian Borntraeger wrote:
> 
> 
> On 14.02.20 15:59, Andrew Jones wrote:
> > [Fixed array index (num => i) and made some style changes.]
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  .../selftests/kvm/lib/aarch64/processor.c     | 24 ++++---------------
> 
> subject says s390, the patch not.
>

It's a "fixup!" patch. The original subject has s390, so this one must as
well.

Thanks,
drew

