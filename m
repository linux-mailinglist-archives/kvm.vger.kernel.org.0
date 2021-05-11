Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F407C37AB48
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 18:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbhEKQDy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 12:03:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38551 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231561AbhEKQDw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 12:03:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620748963;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1+PUQWhyA7xuI9B7tooKLXGwGnxIjB14dxLLDAJQnjw=;
        b=RqmoVSLTfaEbzPljOaf3M8u1FIDMyPUirR5m4m4z65tnQS237Oea5lYdum3SvwlB7Np2td
        D0RRyhMWAjaiqgnkdWGUotVdOqz5fxat38C3BgpsR1RR6FMh+j7UeBJU4ONEU2DfnsnV6J
        GJRFzD9P5z9vfrcGpLMy+bMx+UzP3Bo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446--XLR9IhsO5-wBMkJIhxh6A-1; Tue, 11 May 2021 12:02:42 -0400
X-MC-Unique: -XLR9IhsO5-wBMkJIhxh6A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A0AE801817;
        Tue, 11 May 2021 16:02:41 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-172.ams2.redhat.com [10.36.113.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE04B60CC9;
        Tue, 11 May 2021 16:02:39 +0000 (UTC)
Date:   Tue, 11 May 2021 18:02:37 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 2/6] s390x: Add more Ultravisor
 command structure definitions
Message-ID: <20210511180237.66a9b90f.cohuck@redhat.com>
In-Reply-To: <20210510135148.1904-3-frankja@linux.ibm.com>
References: <20210510135148.1904-1-frankja@linux.ibm.com>
        <20210510135148.1904-3-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 10 May 2021 13:51:44 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> They are needed in the new UV tests.
> 
> As we now extend the size of the query struct, we need to set the
> length in the UV guest query test to a constant instead of using
> sizeof.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  lib/s390x/asm/uv.h | 148 ++++++++++++++++++++++++++++++++++++++++++++-
>  s390x/uv-guest.c   |   3 +-
>  2 files changed, 149 insertions(+), 2 deletions(-)

Can't really verify the actual values/layouts, but looks sane to me.

Acked-by: Cornelia Huck <cohuck@redhat.com>

