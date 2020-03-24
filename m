Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 650EB190D09
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 13:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727400AbgCXMG7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 08:06:59 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:41914 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727238AbgCXMG6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 08:06:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585051618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nG0VEraRSIXnVGKyUsHl2LafJtwNNCSNaGa7mHgAeEE=;
        b=LGsc+9rdReUjZPL03Ve4Jgj3Rwn7UHcOeJDN0AXa8GH+HDAfWNJb2cave+SShqySk3bWyq
        Y0V2wyc9GFQkwp+JhHyS2UExKvODRyHXJEczA9ib2vDFWu1KHiDxGSF47dSHjQ7DRi5wN3
        7OTOu9HaarbcCNJn9KQ4l5HLSEOAfs0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-_a3NlULiPXG-5jAvkV_TfQ-1; Tue, 24 Mar 2020 08:06:56 -0400
X-MC-Unique: _a3NlULiPXG-5jAvkV_TfQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 38CE51851C1D;
        Tue, 24 Mar 2020 12:06:55 +0000 (UTC)
Received: from gondolin (ovpn-113-109.ams2.redhat.com [10.36.113.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F629194BB;
        Tue, 24 Mar 2020 12:06:51 +0000 (UTC)
Date:   Tue, 24 Mar 2020 13:06:48 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, linux-s390@vger.kernel.org,
        david@redhat.com
Subject: Re: [kvm-unit-tests PATCH 04/10] s390x: smp: Test local interrupts
 after cpu reset
Message-ID: <20200324130648.4d973757.cohuck@redhat.com>
In-Reply-To: <20200324081251.28810-5-frankja@linux.ibm.com>
References: <20200324081251.28810-1-frankja@linux.ibm.com>
        <20200324081251.28810-5-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 24 Mar 2020 04:12:45 -0400
Janosch Frank <frankja@linux.ibm.com> wrote:

> Local interrupts (external and emergency call) should be cleared after
> any cpu reset.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/smp.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

