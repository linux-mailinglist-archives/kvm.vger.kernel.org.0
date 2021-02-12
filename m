Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83B5F319CB5
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 11:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhBLKep (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 05:34:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36498 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230389AbhBLKef (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Feb 2021 05:34:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613125989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qPlQOMzj03nx5JCRjigQK4RasyyRp674ycyXkROq6/0=;
        b=KFJ28PzP1Pbi1a2WEn1c35gyY5rBb9sGLrUi//zJnsTIN1HItzKLJXFQYHJEUgJMB6rSq/
        5inlL08+WYimY20ARTpC0faZFywa/tWvXutxWHtvx0ScrcqUtkQQZRDGyxOhpWywxU72ZB
        V1Cvu6lhL2G6INqpk2utqPWoDvLDSXM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-SsilzsLKP-eVcwmY0MU3Rw-1; Fri, 12 Feb 2021 05:33:07 -0500
X-MC-Unique: SsilzsLKP-eVcwmY0MU3Rw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 438E7801975;
        Fri, 12 Feb 2021 10:33:06 +0000 (UTC)
Received: from gondolin (ovpn-113-189.ams2.redhat.com [10.36.113.189])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B934019D9F;
        Fri, 12 Feb 2021 10:33:01 +0000 (UTC)
Date:   Fri, 12 Feb 2021 11:32:59 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 1/5] s390x: css: Store CSS
 Characteristics
Message-ID: <20210212113259.32fe6906.cohuck@redhat.com>
In-Reply-To: <1612963214-30397-2-git-send-email-pmorel@linux.ibm.com>
References: <1612963214-30397-1-git-send-email-pmorel@linux.ibm.com>
        <1612963214-30397-2-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 10 Feb 2021 14:20:10 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> CSS characteristics exposes the features of the Channel SubSystem.
> Let's use Store Channel Subsystem Characteristics to retrieve
> the features of the CSS.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css.h     |  69 +++++++++++++++++++++++++++
>  lib/s390x/css_lib.c | 112 +++++++++++++++++++++++++++++++++++++++++++-
>  s390x/css.c         |  12 +++++
>  3 files changed, 192 insertions(+), 1 deletion(-)
> 

(...)

> +static const char *chsc_rsp_description[] = {
> +	"CHSC unknown error",
> +	"Command executed",
> +	"Invalid command",
> +	"Request-block error",
> +	"Command not installed",
> +	"Data not available",
> +		"Absolute address of channel-subsystem"
> +	"communication block exceeds 2 - 1.",

"2G - 1", I think?

> +	"Invalid command format",
> +	"Invalid channel-subsystem identification (CSSID)",
> +	"The command-request block specified an invalid format"
> +		"for the command response block.",
> +	"Invalid subchannel-set identification (SSID)",
> +	"A busy condition precludes execution.",
> +};

(...)

This matches both the Linux implementation and my memories, so

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

