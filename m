Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5BC7388B8D
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 12:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239372AbhESKUr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 06:20:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51661 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239418AbhESKUr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 May 2021 06:20:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621419567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DjXM8Lzv3u/gqjLMncVn4N04azj1kwg3xnpqiwB1l/g=;
        b=BLAxCieTf5PfsnxfZrX4l0EVYLqH+QdzEx/zC3itGDnpOCpWky2DKsSZK25k1R1eI56Jmz
        1cJ+kQ5uXw/bHELpc2b5pLCl6CQ+p7XU7sa/pWbJ/ODF+jXx9uTPExy7P+4Ws79qR3JAWX
        1Ycfxo1YjnynISJZBn6x9fhVqlAK5BU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-602-w6s5BBU2PvCfRxN18KbYgQ-1; Wed, 19 May 2021 06:19:26 -0400
X-MC-Unique: w6s5BBU2PvCfRxN18KbYgQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 61FD38015C6;
        Wed, 19 May 2021 10:19:25 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-112-33.ams2.redhat.com [10.36.112.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D0731037EB3;
        Wed, 19 May 2021 10:19:18 +0000 (UTC)
Date:   Wed, 19 May 2021 12:19:16 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 3/3] s390x: cpumodel: FMT2 and FMT4
 SCLP test
Message-ID: <20210519121916.540a2017.cohuck@redhat.com>
In-Reply-To: <20210519082648.46803-4-frankja@linux.ibm.com>
References: <20210519082648.46803-1-frankja@linux.ibm.com>
        <20210519082648.46803-4-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 19 May 2021 08:26:48 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> SCLP is also part of the cpumodel, so we need to make sure that the
> features indicated via read info / read cpu info are correct.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> ---
>  s390x/cpumodel.c | 71 +++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 70 insertions(+), 1 deletion(-)

Acked-by: Cornelia Huck <cohuck@redhat.com>

