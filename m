Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D83E22330B2
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 13:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgG3LEN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 07:04:13 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:36417 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726615AbgG3LEN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jul 2020 07:04:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596107052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OeGegbiB9jjsFAXOxn33T1CGGo87BHXcyd7yPvoWBCA=;
        b=ioYNsNljFmvsbTbAhI6pEX7x/uGu1r35c1yq9UUGlcURhyWap0NUhLfHGXg3RhwTZEhoIJ
        VLo/y4OKYrui8RxVQeLwDcl0YSLzrWQbgEUwDdyhHKExywEX0Hv3rlnBsYxUO+uPAhBxzc
        8zvxXBqb90ZNWzRDDoABlKyfj7aiZag=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-l4kq5gwGP7mYBok_wWMp3A-1; Thu, 30 Jul 2020 07:04:10 -0400
X-MC-Unique: l4kq5gwGP7mYBok_wWMp3A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EEB6C800460;
        Thu, 30 Jul 2020 11:04:08 +0000 (UTC)
Received: from gondolin (ovpn-112-203.ams2.redhat.com [10.36.112.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E1EB8A18A;
        Thu, 30 Jul 2020 11:04:01 +0000 (UTC)
Date:   Thu, 30 Jul 2020 13:03:58 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, linux-s390@vger.kernel.org,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 2/3] s390x: skrf: Add exception new
 skey test and add test to unittests.cfg
Message-ID: <20200730130358.6d0bf615.cohuck@redhat.com>
In-Reply-To: <20200727095415.494318-3-frankja@linux.ibm.com>
References: <20200727095415.494318-1-frankja@linux.ibm.com>
        <20200727095415.494318-3-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 27 Jul 2020 05:54:14 -0400
Janosch Frank <frankja@linux.ibm.com> wrote:

> When an exception new psw with a storage key in its mask is loaded
> from lowcore, a specification exception is raised. This differs from
> the behavior when trying to execute skey related instructions, which
> will result in special operation exceptions.
> 
> Also let's add the test unittests.cfg so it is run more often.

when you respin: s/add the test/add the test to/

> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  s390x/skrf.c        | 80 +++++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |  4 +++
>  2 files changed, 84 insertions(+)

