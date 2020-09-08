Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6910D260AF7
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 08:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728881AbgIHG3K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 02:29:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51033 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728922AbgIHG3G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Sep 2020 02:29:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599546544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hcS4bohu+7qrBxlXWC4Kf3mI9aW+AequAk++olk9s6U=;
        b=Etid05sCjjMQ6+D0fm7RDSBt6dBUfyI5Nbs/ut+0/1wRCHPSYhOzH0aezTtsr5pFkP/HH4
        WAHjdM5dwQcz1P9IeHtrKdBH9rqi2eENpvALOBKLKz1Tfq9IKwSl4+bJOao0XsRJmLMxVB
        s+hcvOG84zC2r9aJvqg4fhpSJlB+4A4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-YEAqneceNfePVWUixWtEgQ-1; Tue, 08 Sep 2020 02:28:59 -0400
X-MC-Unique: YEAqneceNfePVWUixWtEgQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B9C610ABDA5;
        Tue,  8 Sep 2020 06:28:58 +0000 (UTC)
Received: from gondolin (ovpn-112-243.ams2.redhat.com [10.36.112.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B3B3F1002D40;
        Tue,  8 Sep 2020 06:28:52 +0000 (UTC)
Date:   Tue, 8 Sep 2020 08:28:49 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        gor@linux.ibm.com, imbrenda@linux.ibm.com, kvm@vger.kernel.org,
        david@redhat.com, hca@linux.ibm.com
Subject: Re: [PATCH v2 1/2] s390x: uv: Add destroy page call
Message-ID: <20200908082849.7e4a661d.cohuck@redhat.com>
In-Reply-To: <20200907124700.10374-2-frankja@linux.ibm.com>
References: <20200907124700.10374-1-frankja@linux.ibm.com>
        <20200907124700.10374-2-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  7 Sep 2020 08:46:59 -0400
Janosch Frank <frankja@linux.ibm.com> wrote:

> We don't need to export pages if we destroy the VM configuration
> afterwards anyway. Instead we can destroy the page which will zero it
> and then make it accessible to the host.
> 
> Destroying is about twice as fast as the export.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/include/asm/uv.h |  7 +++++++
>  arch/s390/kernel/uv.c      | 20 ++++++++++++++++++++
>  arch/s390/mm/gmap.c        |  2 +-
>  3 files changed, 28 insertions(+), 1 deletion(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

