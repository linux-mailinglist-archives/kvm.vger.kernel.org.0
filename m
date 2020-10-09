Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCCE28860B
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 11:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733101AbgJIJiU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 05:38:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37126 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733132AbgJIJiS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Oct 2020 05:38:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602236298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6NBJSYlvfZHWze2N1l/klbUKCpQ65WesNQZgDHDHlo0=;
        b=BtsxfnVcPf5j+DGiSksR2wgVCQwLl1t69nUvaUWDFmQOqQbJcRi6Oik7UysH4sLajkbvTY
        m1fTKFZbUDYJwV1jsqb+ZFRqYQIhk+D6k5kTcvboUhjY4d9w0Lw1Tk/xtFYfihxnJNIgHK
        wvqRMcdQAFONyyutD6L2wfCkaOj+TOs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-480-H9ceGU0_O2qlXp24GhJ_7w-1; Fri, 09 Oct 2020 05:38:14 -0400
X-MC-Unique: H9ceGU0_O2qlXp24GhJ_7w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9491085EE94;
        Fri,  9 Oct 2020 09:38:12 +0000 (UTC)
Received: from gondolin (ovpn-113-40.ams2.redhat.com [10.36.113.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6983F60E1C;
        Fri,  9 Oct 2020 09:38:07 +0000 (UTC)
Date:   Fri, 9 Oct 2020 11:38:04 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/5] vfio: Introduce capability definitions for
 VFIO_DEVICE_GET_INFO
Message-ID: <20201009113804.6ccc9738.cohuck@redhat.com>
In-Reply-To: <1602096984-13703-4-git-send-email-mjrosato@linux.ibm.com>
References: <1602096984-13703-1-git-send-email-mjrosato@linux.ibm.com>
        <1602096984-13703-4-git-send-email-mjrosato@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  7 Oct 2020 14:56:22 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> Allow the VFIO_DEVICE_GET_INFO ioctl to include a capability chain.
> Add a flag indicating capability chain support, and introduce the
> definitions for the first set of capabilities which are specified to
> s390 zPCI devices.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  include/uapi/linux/vfio.h      | 11 ++++++
>  include/uapi/linux/vfio_zdev.h | 78 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 89 insertions(+)
>  create mode 100644 include/uapi/linux/vfio_zdev.h

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

