Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB3D1429C1
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2020 12:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgATLoi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jan 2020 06:44:38 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60524 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726573AbgATLoi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jan 2020 06:44:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579520677;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qwlKSo3YOD1P3NLswDWaeqmfkrzPOf3k9Ypf4gJ1R1k=;
        b=i1202aUuL/vyOq5ltWHuD4/prqeg6+JKMV+DsH/wmPfcfPm1T9wwykYd8oXdM9KLBlH3Lx
        NdCXQFbl0tK5tzdfJdHSZsJDjIJip2IDkoRB4P/SWTvjlJVfEKMHHVFlnb9qi2zUnlTPe9
        Ktao0G4xoDqWZCJmu4TQ3YJr+IVxFho=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-C9mghhGlOTa1ByigwBx3mQ-1; Mon, 20 Jan 2020 06:44:34 -0500
X-MC-Unique: C9mghhGlOTa1ByigwBx3mQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2BCC6100551C;
        Mon, 20 Jan 2020 11:44:33 +0000 (UTC)
Received: from gondolin (ovpn-205-161.brq.redhat.com [10.40.205.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C060385720;
        Mon, 20 Jan 2020 11:44:26 +0000 (UTC)
Date:   Mon, 20 Jan 2020 12:44:23 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, david@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 8/9] s390x: smp: Test all CRs on
 initial reset
Message-ID: <20200120124423.0994c108.cohuck@redhat.com>
In-Reply-To: <20200117104640.1983-9-frankja@linux.ibm.com>
References: <20200117104640.1983-1-frankja@linux.ibm.com>
        <20200117104640.1983-9-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 17 Jan 2020 05:46:39 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> All CRs are set to 0 and CRs 0 and 14 are set to pre-defined values,
> so we also need to test 1-13 and 15 for 0.
> 
> And while we're at it, let's also set some values to cr 1, 7 and 13, so
> we can actually be sure that they will be zeroed.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/smp.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

