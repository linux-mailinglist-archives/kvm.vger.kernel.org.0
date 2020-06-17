Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 186211FC91B
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 10:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbgFQInI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 04:43:08 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:21896 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726634AbgFQInI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Jun 2020 04:43:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592383387;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g13u0QwXDLpIPhhUZAKx4fDZO+W2IwV1S+FZryUazQ4=;
        b=dPifHTLtsQW4HOZQKX5pGbI2r+VE8XqvPDig4YwI4NLU3llsoA8TP05g0qJsXrvQqtN3VN
        sySQrNSYbYx6NmUhGgN4Ljsrnrk4bu9/rTkWvEInUDqiXFQ44TxNiCjOgUaZX/IFQs817v
        T+VQCbfL8aTzzox9wpkUx7MiZJxPNNQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-AzpeJMQGObWXUYVxHY2aNQ-1; Wed, 17 Jun 2020 04:43:03 -0400
X-MC-Unique: AzpeJMQGObWXUYVxHY2aNQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3DF0A8C31E8;
        Wed, 17 Jun 2020 08:43:02 +0000 (UTC)
Received: from gondolin (ovpn-112-222.ams2.redhat.com [10.36.112.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 423257CAA5;
        Wed, 17 Jun 2020 08:42:58 +0000 (UTC)
Date:   Wed, 17 Jun 2020 10:42:55 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com
Subject: Re: [kvm-unit-tests PATCH v9 09/12] s390x: Library resources for
 CSS tests
Message-ID: <20200617104255.607b670a.cohuck@redhat.com>
In-Reply-To: <c424e6fe-a2f1-65fe-7ed1-2f26bc58587c@redhat.com>
References: <1592213521-19390-1-git-send-email-pmorel@linux.ibm.com>
        <1592213521-19390-10-git-send-email-pmorel@linux.ibm.com>
        <c424e6fe-a2f1-65fe-7ed1-2f26bc58587c@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 16 Jun 2020 12:31:40 +0200
Thomas Huth <thuth@redhat.com> wrote:

> On 15/06/2020 11.31, Pierre Morel wrote:
> > Provide some definitions and library routines that can be used by
> > tests targeting the channel subsystem.
> > 
> > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > ---
> >  lib/s390x/css.h      | 256 +++++++++++++++++++++++++++++++++++++++++++
> >  lib/s390x/css_dump.c | 153 ++++++++++++++++++++++++++
> >  s390x/Makefile       |   1 +
> >  3 files changed, 410 insertions(+)
> >  create mode 100644 lib/s390x/css.h
> >  create mode 100644 lib/s390x/css_dump.c  
> 
> I can't say much about the gory IO details, but at least the inline
> assembly looks fine to me now.
> 
> Acked-by: Thomas Huth <thuth@redhat.com>

I've looked at the gory I/O details, and they seem fine to me.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

