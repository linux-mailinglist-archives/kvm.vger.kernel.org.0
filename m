Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 023B314DB25
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 14:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbgA3NAs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 08:00:48 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39279 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726980AbgA3NAs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 08:00:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580389247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dS2yL7Oo4P/36MkHLuYnmuxDjs+jc8MINOiI7GZ8EbY=;
        b=SUaKtkw8vRh1au8F4zYe4U2Cw427oY4Wk80T9BeCEIC5et9FHnR/FOMMzRMuag3HLudU8m
        8G6Jtpn3theHY9nBQk5qoV8WJAoOYwzOnv6o4FK0U2lvWBjESnXmxCdilBXIL48wmdaeDx
        Z9DRfgLRDV1ZR2dpxbSAye1oEoscy/o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-pHADAcouOuOKCYSZc7l9Yw-1; Thu, 30 Jan 2020 08:00:42 -0500
X-MC-Unique: pHADAcouOuOKCYSZc7l9Yw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 662D913E7;
        Thu, 30 Jan 2020 13:00:41 +0000 (UTC)
Received: from gondolin (ovpn-117-199.ams2.redhat.com [10.36.117.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E14591B422;
        Thu, 30 Jan 2020 13:00:39 +0000 (UTC)
Date:   Thu, 30 Jan 2020 14:00:37 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, borntraeger@de.ibm.com,
        david@redhat.com, linux-s390@vger.kernel.org
Subject: Re: [PATCH v9 1/6] KVM: s390: do not clobber registers during guest
 reset/store status
Message-ID: <20200130140037.11c4cf33.cohuck@redhat.com>
In-Reply-To: <20200130123434.68129-2-frankja@linux.ibm.com>
References: <20200130123434.68129-1-frankja@linux.ibm.com>
        <20200130123434.68129-2-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 30 Jan 2020 07:34:29 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> From: Christian Borntraeger <borntraeger@de.ibm.com>
> 
> The initial CPU reset clobbers the userspace fpc and the store status
> ioctl clobbers the guest acrs + fpr.  As these calls are only done via
> ioctl (and not via vcpu_run), no CPU context is loaded, so we can (and
> must) act directly on the sync regs, not on the thread context.
> 
> Cc: stable@kernel.org
> Fixes: e1788bb995be ("KVM: s390: handle floating point registers in the run ioctl not in vcpu_put/load")
> Fixes: 31d8b8d41a7e ("KVM: s390: handle access registers in the run ioctl not in vcpu_put/load")
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>

Add your s-o-b?

> ---
>  arch/s390/kvm/kvm-s390.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

