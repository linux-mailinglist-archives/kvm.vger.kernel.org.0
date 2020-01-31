Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D41614EA87
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 11:16:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728299AbgAaKQm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 05:16:42 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:35742 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728284AbgAaKQm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 Jan 2020 05:16:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580465801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c4/TP52zB2rgf49sVdFp/BDIc+OU9+7xo+6h5U1jUqc=;
        b=dgsFXN+aVRzybY+3R54wYxQnqiP8DlsB86avwStJDK/1iIE4AaGOGd251w63Lh/7gAJeYv
        J7U7547Nh0FgpxOGsKtVDguUMDcEQFSkKnbB9W3c35wBe64JmAtbioSgzrM3gHQbUFf28t
        +lCX408d9NMTdPQ04wdEEEAHJm22ErA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-JzpDvVxJMC-01AuvKOKGiA-1; Fri, 31 Jan 2020 05:16:37 -0500
X-MC-Unique: JzpDvVxJMC-01AuvKOKGiA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F4FF92692;
        Fri, 31 Jan 2020 10:16:36 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1928787B20;
        Fri, 31 Jan 2020 10:16:34 +0000 (UTC)
Date:   Fri, 31 Jan 2020 11:16:32 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, borntraeger@de.ibm.com,
        david@redhat.com, linux-s390@vger.kernel.org
Subject: Re: [PATCH v10 6/6] selftests: KVM: testing the local IRQs resets
Message-ID: <20200131111632.2a3c41a4.cohuck@redhat.com>
In-Reply-To: <20200131100205.74720-7-frankja@linux.ibm.com>
References: <20200131100205.74720-1-frankja@linux.ibm.com>
        <20200131100205.74720-7-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 31 Jan 2020 05:02:05 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> From: Pierre Morel <pmorel@linux.ibm.com>
> 
> Local IRQs are reset by a normal cpu reset.  The initial cpu reset and
> the clear cpu reset, as superset of the normal reset, both clear the
> IRQs too.
> 
> Let's inject an interrupt to a vCPU before calling a reset and see if
> it is gone after the reset.
> 
> We choose to inject only an emergency interrupt at this point and can
> extend the test to other types of IRQs later.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>[minor fixups]

I usually keep a blank between the email address and any annotations
(not sure if that might trip some scripts).

> ---
>  tools/testing/selftests/kvm/s390x/resets.c | 42 ++++++++++++++++++++++
>  1 file changed, 42 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

