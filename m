Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC6537ABC9
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 18:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbhEKQXj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 12:23:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48912 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231454AbhEKQXh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 12:23:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620750150;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gNm7B4TSVI5MowxGlD80Vrp67V76f4nfgzEtOQtowGQ=;
        b=BdTEYrVco9cQ/jWeN65dQ4M4ror3hqDC9VNJL5LtQ3WMX4c0TzkcFTxxsLw50flEKGhbuS
        Rf1fDROVxoIinC5hjR4klNp6q6UOxAmG5w3oZFiPrmLgsR5yfwXfm7a03yWWVwJzW+LWuB
        psUBi6Dh4e52K61f/h1TlnOP790fgCk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-456-0-BDVpg0Pa6_jc1xy1hbkQ-1; Tue, 11 May 2021 12:22:23 -0400
X-MC-Unique: 0-BDVpg0Pa6_jc1xy1hbkQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D8BD8014D8;
        Tue, 11 May 2021 16:22:22 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-172.ams2.redhat.com [10.36.113.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C17762B162;
        Tue, 11 May 2021 16:22:16 +0000 (UTC)
Date:   Tue, 11 May 2021 18:22:14 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 5/6] s390x: uv-guest: Test invalid
 commands
Message-ID: <20210511182214.232e3763.cohuck@redhat.com>
In-Reply-To: <20210510135148.1904-6-frankja@linux.ibm.com>
References: <20210510135148.1904-1-frankja@linux.ibm.com>
        <20210510135148.1904-6-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 10 May 2021 13:51:47 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Let's check if the UV calls that should not be available in a
> protected guest 2 are actually not available. Also let's check if they
> are falsely indicated to be available.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/uv-guest.c | 46 +++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 39 insertions(+), 7 deletions(-)

I cannot double check, but these are all commands I'd not expect to be
available.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

