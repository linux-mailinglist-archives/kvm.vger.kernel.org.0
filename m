Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4EFD24FE07
	for <lists+kvm@lfdr.de>; Mon, 24 Aug 2020 14:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbgHXMsw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Aug 2020 08:48:52 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48380 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725916AbgHXMst (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Aug 2020 08:48:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598273328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gMjAzN3rEvppXD1PW4/DC05E+6rjJ+zyLI6QVLwoEDo=;
        b=b0nwL+M1YfXlizmVPX24t3gfkRHRcJEPNVObvddn+3ZuyN0ggq6Jq3yuMMPSUsV4W5mw18
        iHQ5Gb1qh2W5V62hDo8ZIBZAR8MNVsouJXWwjchhvR3w9920GoFyQegCmmCU0oZ8guzJ+b
        hkRaYFFMSAyx24H28v1HVs2mb+VLL3M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-Qd7HYce5P1Smy9wOaT33tw-1; Mon, 24 Aug 2020 08:48:45 -0400
X-MC-Unique: Qd7HYce5P1Smy9wOaT33tw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A1CD1007B01;
        Mon, 24 Aug 2020 12:48:44 +0000 (UTC)
Received: from gondolin (ovpn-113-235.ams2.redhat.com [10.36.113.235])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7A2EF1A268;
        Mon, 24 Aug 2020 12:48:39 +0000 (UTC)
Date:   Mon, 24 Aug 2020 14:48:36 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Marc Hartmayer <mhartmay@linux.ibm.com>
Cc:     <kvm@vger.kernel.org>, Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 1/2] runtime.bash: remove outdated
 comment
Message-ID: <20200824144836.0f621683.cohuck@redhat.com>
In-Reply-To: <20200821123744.33173-2-mhartmay@linux.ibm.com>
References: <20200821123744.33173-1-mhartmay@linux.ibm.com>
        <20200821123744.33173-2-mhartmay@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 21 Aug 2020 14:37:43 +0200
Marc Hartmayer <mhartmay@linux.ibm.com> wrote:

> Since commit 6e1d3752d7ca ("tap13: list testcases individually") the
> comment is no longer valid. Therefore let's remove it.
> 
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> ---
>  scripts/runtime.bash | 3 ---
>  1 file changed, 3 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

