Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF3002C82A0
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 11:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725842AbgK3KvM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 05:51:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58650 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726270AbgK3KvM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Nov 2020 05:51:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606733386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wppRsENeoPqQw9Z5WKXXBt8O24NGqvQ0rKFRFVoWq9Y=;
        b=P06nEh/FZ0KjDnYhkmSiJg7iKJH8d3zn+PLaBipA7T6L9otCJ7XSSl2DLkSsg71M9JsFZ3
        stdTJo8YYx8YPghq6rg4IMz147Wh/Br7fC1PG4wDdTR5UqvabpHG5lw4nzL3u6K77doi5s
        gCa+n/RrCnbWy2FPrHVEe2WDn+MfXlc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-uh4WnNuFOjO0SN8zxmRPTw-1; Mon, 30 Nov 2020 05:49:43 -0500
X-MC-Unique: uh4WnNuFOjO0SN8zxmRPTw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C99F18C89D9;
        Mon, 30 Nov 2020 10:49:42 +0000 (UTC)
Received: from gondolin (ovpn-113-87.ams2.redhat.com [10.36.113.87])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EE13E60C62;
        Mon, 30 Nov 2020 10:49:37 +0000 (UTC)
Date:   Mon, 30 Nov 2020 11:49:35 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 7/7] s390x: Fix sclp.h style issues
Message-ID: <20201130114935.5b047f46.cohuck@redhat.com>
In-Reply-To: <20201127130629.120469-8-frankja@linux.ibm.com>
References: <20201127130629.120469-1-frankja@linux.ibm.com>
        <20201127130629.120469-8-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 27 Nov 2020 08:06:29 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> Fix indentation
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/sclp.h | 172 +++++++++++++++++++++++------------------------
>  1 file changed, 86 insertions(+), 86 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

