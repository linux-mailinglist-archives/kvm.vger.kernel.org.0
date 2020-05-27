Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE471E3DD0
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 11:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbgE0Jp0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 05:45:26 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53992 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725939AbgE0Jp0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 May 2020 05:45:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590572725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Dv8e/8IYWiFZa52nWbfRlHdWMY27KdY53fakPZ6y8BY=;
        b=F1fxVwWVNCIMWJR8/josiRL+h7JONPfQh7Z6pEKBUFJV+jXt7HWCSVPNNsFFf+exjmgcok
        J79P/tcS/jyWk4nNkH5LdGNIxkvgQhwsGQ0Ne4dbkh3TGvqBLkICc0wHxLi3slM+8VzmRP
        lUFB0URnfT8pyNiyQfyvolJZh37hyAM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-Rfh2PV39OXiEwyNUnRMSZw-1; Wed, 27 May 2020 05:45:21 -0400
X-MC-Unique: Rfh2PV39OXiEwyNUnRMSZw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C271D100960F;
        Wed, 27 May 2020 09:45:20 +0000 (UTC)
Received: from gondolin (ovpn-112-223.ams2.redhat.com [10.36.112.223])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A3F1D1CA;
        Wed, 27 May 2020 09:45:16 +0000 (UTC)
Date:   Wed, 27 May 2020 11:45:14 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v7 10/12] s390x: define function to wait
 for interrupt
Message-ID: <20200527114514.0987a3a0.cohuck@redhat.com>
In-Reply-To: <1589818051-20549-11-git-send-email-pmorel@linux.ibm.com>
References: <1589818051-20549-1-git-send-email-pmorel@linux.ibm.com>
        <1589818051-20549-11-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 18 May 2020 18:07:29 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> Allow the program to wait for an interrupt.
> 
> The interrupt handler is in charge to remove the WAIT bit
> when it finished handling the interrupt.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/asm/arch_def.h | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

