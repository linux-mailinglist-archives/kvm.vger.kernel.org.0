Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFC437ABFF
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 18:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbhEKQeR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 12:34:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41655 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230505AbhEKQeQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 12:34:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620750789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M+ksFwxjTs/QRoFUyPbTXTRCYq3iQMXvgPGdfXvbbww=;
        b=NgcViNN6Cz6NIB1JtDmnFRyrFkjssj1Y8zAUTUtlfpJYqKFkFEUOvvy/u9FeHViBUAYTA1
        0DHE2yQwGnQXajdSK6GToWMM2B1VXu/gd09g88PB29kfCWY8jbt9c2NrHjNHPvBofFA9Ew
        qwcaF3w9BPrPpxc8QAPM6uOH7SdXReg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-BhKAiYeyM5O_NYdWgFdrtg-1; Tue, 11 May 2021 12:33:07 -0400
X-MC-Unique: BhKAiYeyM5O_NYdWgFdrtg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40497107ACCD;
        Tue, 11 May 2021 16:33:06 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-172.ams2.redhat.com [10.36.113.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9321010016F9;
        Tue, 11 May 2021 16:33:01 +0000 (UTC)
Date:   Tue, 11 May 2021 18:32:58 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH 1/4] s390x: sclp: Only fetch read info
 byte 134 if cpu entries are above it
Message-ID: <20210511183258.4a104b1e.cohuck@redhat.com>
In-Reply-To: <20210510150015.11119-2-frankja@linux.ibm.com>
References: <20210510150015.11119-1-frankja@linux.ibm.com>
        <20210510150015.11119-2-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 10 May 2021 15:00:12 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> The cpu offset tells us where the cpu entries are in the sclp read
> info structure.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  lib/s390x/sclp.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

