Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B31063419BF
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 11:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhCSKRF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 06:17:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28613 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229960AbhCSKQh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Mar 2021 06:16:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616148995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cDc8nkCCukeaYyfajMZMG9ZOwhb3rRBPd8/5p2snYX0=;
        b=Nl7u1Z0n4NQIMRloZt0F5TcA0THPUJubNITXhSmc8K0rEOO/dNh0Prcz1N5mK8ZPSW6rz0
        T4vp+ONAEqfanIydbpGyBU3vG89s0aYCkumWpGHQS2VuntcslCumkED2bPZoDv//2aAouD
        q6hGlw3gX1n7qQ92l20cAzTidwKxJSw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-iKdyRhOZOG2b1ZCnZdP1ng-1; Fri, 19 Mar 2021 06:16:34 -0400
X-MC-Unique: iKdyRhOZOG2b1ZCnZdP1ng-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 19BC18189C6;
        Fri, 19 Mar 2021 10:16:33 +0000 (UTC)
Received: from gondolin (ovpn-112-229.ams2.redhat.com [10.36.112.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 66D305C1BB;
        Fri, 19 Mar 2021 10:16:28 +0000 (UTC)
Date:   Fri, 19 Mar 2021 11:16:26 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v1 2/6] s390x: lib: css: SCSW bit
 definitions
Message-ID: <20210319111626.20b9cd72.cohuck@redhat.com>
In-Reply-To: <1616073988-10381-3-git-send-email-pmorel@linux.ibm.com>
References: <1616073988-10381-1-git-send-email-pmorel@linux.ibm.com>
        <1616073988-10381-3-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 18 Mar 2021 14:26:24 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> We need the SCSW definitions to test clear and halt subchannel.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css.h | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> index b0de3a3..460b0bd 100644
> --- a/lib/s390x/css.h
> +++ b/lib/s390x/css.h
> @@ -67,6 +67,29 @@ struct scsw {
>  #define SCSW_SC_PRIMARY		0x00000004
>  #define SCSW_SC_INTERMEDIATE	0x00000008
>  #define SCSW_SC_ALERT		0x00000010
> +#define SCSW_AC_SUSPEND_PEND	0x00000020
> +#define SCSW_AC_DEVICE_PEND	0x00000040
> +#define SCSW_AC_SUBCHANNEL_PEND	0x00000080

Naming: aren't these two rather "active", not "pending"? So maybe
SCSW_AC_DEVICE_ACTIVE and SCSW_AC_SUBCH_ACTIVE?

> +#define SCSW_AC_CLEAR_PEND	0x00000100
> +#define SCSW_AC_HALT_PEND	0x00000200
> +#define SCSW_AC_START_PEND	0x00000400
> +#define SCSW_AC_RESUME_PEND	0x00000800
> +#define SCSW_FC_CLEAR		0x00001000
> +#define SCSW_FC_HALT		0x00002000
> +#define SCSW_FC_START		0x00004000
> +#define SCSW_QDIO_RESERVED	0x00008000
> +#define SCSW_PATH_NON_OP	0x00010000
> +#define SCSW_EXTENDED_CTRL	0x00020000
> +#define SCSW_ZERO_COND		0x00040000
> +#define SCSW_SUPPRESS_SUSP_INT	0x00080000
> +#define SCSW_IRB_FMT_CTRL	0x00100000
> +#define SCSW_INITIAL_IRQ_STATUS	0x00200000
> +#define SCSW_PREFETCH		0x00400000
> +#define SCSW_CCW_FORMAT		0x00800000
> +#define SCSW_DEFERED_CC		0x03000000
> +#define SCSW_ESW_FORMAT		0x04000000
> +#define SCSW_SUSPEND_CTRL	0x08000000
> +#define SCSW_KEY		0xf0000000
>  	uint32_t ctrl;
>  	uint32_t ccw_addr;
>  #define SCSW_DEVS_DEV_END	0x04

