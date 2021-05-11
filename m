Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E28A37ABA3
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 18:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbhEKQRM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 12:17:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21927 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231126AbhEKQRJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 12:17:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620749762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sgDmPnl0vVyDk0SkNwESYJyYCWZ1d0QxscS8wJGiMm8=;
        b=ZsXoLjvWjO2RCtjbkW2n0V9WVNubnbINplctEoef630tPi2e87dSJBaLOHGmZRwiTkPSAs
        oLfjK2YjTyVaTPkwnULMs+TIjufEtchhv85ePe1gKDkUwFHu4ESct7AO5DbH9FLLhnhik6
        XpV62mSWYsd1JN0PjGTgKDFPpIKUK3Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-594-D-DPIQpJOiCFT54zg75wDA-1; Tue, 11 May 2021 12:16:00 -0400
X-MC-Unique: D-DPIQpJOiCFT54zg75wDA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D8E41008065;
        Tue, 11 May 2021 16:15:59 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-172.ams2.redhat.com [10.36.113.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 514C1BA6F;
        Tue, 11 May 2021 16:15:52 +0000 (UTC)
Date:   Tue, 11 May 2021 18:15:49 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 4/6] s390x: Test for share/unshare
 call support before using them
Message-ID: <20210511181549.334015cb.cohuck@redhat.com>
In-Reply-To: <20210510135148.1904-5-frankja@linux.ibm.com>
References: <20210510135148.1904-1-frankja@linux.ibm.com>
        <20210510135148.1904-5-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 10 May 2021 13:51:46 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Testing for facility only means the UV Call facility is available.
> The UV will only indicate the share/unshare calls for a protected
> guest 2, so let's also check that.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  lib/s390x/malloc_io.c | 5 +++--
>  s390x/uv-guest.c      | 6 ++++++
>  2 files changed, 9 insertions(+), 2 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

