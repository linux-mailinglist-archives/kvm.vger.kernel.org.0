Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D59E1504D7
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 12:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbgBCLEX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 06:04:23 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:35227 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726369AbgBCLEX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Feb 2020 06:04:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580727861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lNIpyKIbuYkhKH52mLKQud1I8hBk+d/n2+bRNdOYVrE=;
        b=Q1ApFLu9MZqj9g1qGl1D7FncUtH8C+3AxcKHVlBfc//tOxL05kTwyY67D0Aj6dRGAWmG/0
        LcSFulWzv05l4bdG5NFE6HMejQ7649VmVHG0hcRrellrDVJ6NYdFBFglLYoDWwu5auyeKH
        T2kMNkjFkkDv68vHSoSbfCz0yOUedUk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-2FZG1MiKOJOzvG_8PecjDA-1; Mon, 03 Feb 2020 06:04:20 -0500
X-MC-Unique: 2FZG1MiKOJOzvG_8PecjDA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB8CE107ACC4;
        Mon,  3 Feb 2020 11:04:18 +0000 (UTC)
Received: from gondolin (ovpn-117-79.ams2.redhat.com [10.36.117.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DFFEC8642F;
        Mon,  3 Feb 2020 11:04:14 +0000 (UTC)
Date:   Mon, 3 Feb 2020 12:04:12 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, david@redhat.com
Subject: Re: [kvm-unit-tests PATCH v5 1/7] s390x: smp: Cleanup smp.c
Message-ID: <20200203120412.7ae7bb60.cohuck@redhat.com>
In-Reply-To: <20200201152851.82867-2-frankja@linux.ibm.com>
References: <20200201152851.82867-1-frankja@linux.ibm.com>
        <20200201152851.82867-2-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat,  1 Feb 2020 10:28:45 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> Let's remove a lot of badly formatted code by introducing the
> wait_for_flag() and set_flag functions.
> 
> Also let's remove some stray spaces and always set the tesflag before

s/tesflag/testflag/

> using it.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> ---
>  s390x/smp.c | 55 ++++++++++++++++++++++++++++++++---------------------
>  1 file changed, 33 insertions(+), 22 deletions(-)

