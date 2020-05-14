Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 540201D2EEF
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 13:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgENL6Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 07:58:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23656 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726050AbgENL6Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 07:58:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589457495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XGl+5VE42uZb7UUcuppvQrMTFvGL+eHMuXlr/U1lpf8=;
        b=QZD2i6GLyigrYBgHMtRP0fn/eZQRlPyAS8STQjLWyWWrVAECJI+fTTgH5WuzrPBzyjsbMx
        Kd/AoCep5QyA+dFZiPsgjuYpequWXjEAuk9+fncVkW8rsBRN9kM+0RnhWxtYDtuk+dY0dW
        FjHlE99rSnKdfpnn27nK4CRDZOJSwcY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-ECKt9cEeOKKEVGCZCl1RjA-1; Thu, 14 May 2020 07:58:13 -0400
X-MC-Unique: ECKt9cEeOKKEVGCZCl1RjA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C432800053;
        Thu, 14 May 2020 11:58:12 +0000 (UTC)
Received: from gondolin (unknown [10.40.192.240])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 38CF139E;
        Thu, 14 May 2020 11:58:08 +0000 (UTC)
Date:   Thu, 14 May 2020 13:58:05 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v6 04/10] s390x: interrupt registration
Message-ID: <20200514135805.77a7ae82.cohuck@redhat.com>
In-Reply-To: <1587725152-25569-5-git-send-email-pmorel@linux.ibm.com>
References: <1587725152-25569-1-git-send-email-pmorel@linux.ibm.com>
        <1587725152-25569-5-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 24 Apr 2020 12:45:46 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> Let's make it possible to add and remove a custom io interrupt handler,
> that can be used instead of the normal one.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/interrupt.c | 23 ++++++++++++++++++++++-
>  lib/s390x/interrupt.h |  8 ++++++++
>  2 files changed, 30 insertions(+), 1 deletion(-)
>  create mode 100644 lib/s390x/interrupt.h

As the "normal one" means "no handler, just abort", is there any reason
not simply to always provide one? What is the use case for multiple I/O
interrupt handlers?

