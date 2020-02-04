Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9AD6151F0F
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 18:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbgBDRPy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 12:15:54 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28240 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727310AbgBDRPy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Feb 2020 12:15:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580836553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FQ7t1k7i0wkmBvdxQkpvy0eDXYy8cnc2qnOKIbY4C8E=;
        b=QQ+r7OuwAdIrOHRWxRc6lyCvT2hVIXzoDcohjxm0L7w4AwmtyxiNxd4pmLzn1O8jhMptSR
        20Jn7AZuM/NKdzHvH/TeZTOsmDoaTIw/oH5Zk+TCG9QOWbiEZYuZ2OWHqYiNiMeThrkarB
        RJpUDbtoCzxKVD7HInEjDtHeRKiDc+k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-51-yZMjxtnoNWi-6iF6-6-Zvg-1; Tue, 04 Feb 2020 12:15:49 -0500
X-MC-Unique: yZMjxtnoNWi-6iF6-6-Zvg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0677800D54;
        Tue,  4 Feb 2020 17:15:47 +0000 (UTC)
Received: from gondolin (ovpn-117-199.ams2.redhat.com [10.36.117.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E5AA38EA0C;
        Tue,  4 Feb 2020 17:15:39 +0000 (UTC)
Date:   Tue, 4 Feb 2020 18:15:37 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 27/37] KVM: s390: protvirt: Only sync fmt4 registers
Message-ID: <20200204181537.5f6bc2ce.cohuck@redhat.com>
In-Reply-To: <20200203131957.383915-28-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-28-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  3 Feb 2020 08:19:47 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Janosch Frank <frankja@linux.ibm.com>
> 
> A lot of the registers are controlled by the Ultravisor and never
> visible to KVM. Also some registers are overlayed, like gbea is with
> sidad, which might leak data to userspace.
> 
> Hence we sync a minimal set of registers for both SIE formats and then
> check and sync format 2 registers if necessary.
> 
> Also we disable set/get one reg for the same reason. It's an old
> interface anyway.

Didn't you already do that in the previous patch?

> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> [Fixes and patch splitting]
> ---
>  arch/s390/kvm/kvm-s390.c | 116 ++++++++++++++++++++++++---------------
>  1 file changed, 72 insertions(+), 44 deletions(-)

