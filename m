Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7E8190D41
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 13:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbgCXMVU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 08:21:20 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:23838 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727266AbgCXMVU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 08:21:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585052479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0F05w70AiKeJ7PHR6UgwaKer5PtbsnEs91+XR59R64Y=;
        b=iZeXNp3pdsSKB6Z8EsPaMOtV6GkOvraSOfvRB+XmAJeZ2uwWGcAQvC99w9B3NbmEyVyslk
        oDsa4Ypp/Pu8yJ0Iz/fQNr851wfIpMcBoiHpFof54rnxkmVssh5V44o+zSsfWUiLqEk6K/
        bjY5IHEWbTLn+qp8pn+Jl36rXRTb+f0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-zj2EgITHM0W_NrtBQGUthA-1; Tue, 24 Mar 2020 08:21:17 -0400
X-MC-Unique: zj2EgITHM0W_NrtBQGUthA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81CA2800D48;
        Tue, 24 Mar 2020 12:21:16 +0000 (UTC)
Received: from gondolin (ovpn-113-109.ams2.redhat.com [10.36.113.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A994560BF3;
        Tue, 24 Mar 2020 12:21:12 +0000 (UTC)
Date:   Tue, 24 Mar 2020 13:21:10 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, linux-s390@vger.kernel.org,
        david@redhat.com
Subject: Re: [kvm-unit-tests PATCH 05/10] s390x: smp: Loop if secondary cpu
 returns into cpu setup again
Message-ID: <20200324132110.676c6f92.cohuck@redhat.com>
In-Reply-To: <20200324081251.28810-6-frankja@linux.ibm.com>
References: <20200324081251.28810-1-frankja@linux.ibm.com>
        <20200324081251.28810-6-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 24 Mar 2020 04:12:46 -0400
Janosch Frank <frankja@linux.ibm.com> wrote:

> Up to now a secondary cpu could have returned from the function it was
> executing and ending up somewhere in cstart64.S. This was mostly
> circumvented by an endless loop in the function that it executed.
> 
> Let's add a loop to the end of the cpu setup, so we don't have to rely
> on added loops in the tests.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/cstart64.S | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

