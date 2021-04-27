Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F09BB36C625
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 14:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236304AbhD0MgH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 08:36:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46755 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236298AbhD0MgG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Apr 2021 08:36:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619526923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tcNRt24x2kZfm24rhq16oGPf741SCZI75GgUnSP1SlE=;
        b=SisDS08PTFog+805LwbtVfyYFRPsWlpUsMpSFCBnbfSrL99eRjkSuvR/7fxHkjZEcVypWg
        SLzDq1WeKRhNz2hy359HpQiOKUH/7RqwH1Cz73F/WvZz0pcYi3tDRAEZltYTj3Eo3Qwkbb
        kjIz4lVYpWXcdkMtGcjE+O2Mi1QS7kA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-147-R-8IKjIYMXyFdI20SmbU9g-1; Tue, 27 Apr 2021 08:35:20 -0400
X-MC-Unique: R-8IKjIYMXyFdI20SmbU9g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76BAC801F98;
        Tue, 27 Apr 2021 12:35:19 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-176.ams2.redhat.com [10.36.113.176])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0470C2CFF6;
        Tue, 27 Apr 2021 12:35:02 +0000 (UTC)
Date:   Tue, 27 Apr 2021 14:35:00 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com,
        david@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 1/1] MAINTAINERS: s390x: add myself as
 reviewer
Message-ID: <20210427143500.28820d99.cohuck@redhat.com>
In-Reply-To: <20210427121608.157783-1-imbrenda@linux.ibm.com>
References: <20210427121608.157783-1-imbrenda@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 27 Apr 2021 14:16:08 +0200
Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:

> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e2505985..aaa404cf 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -85,6 +85,7 @@ M: Thomas Huth <thuth@redhat.com>
>  M: David Hildenbrand <david@redhat.com>
>  M: Janosch Frank <frankja@linux.ibm.com>
>  R: Cornelia Huck <cohuck@redhat.com>
> +R: Claudio Imbrenda <imbrenda@linux.ibm.com>
>  L: kvm@vger.kernel.org
>  L: linux-s390@vger.kernel.org
>  F: s390x/*

Acked-by: Cornelia Huck <cohuck@redhat.com>

