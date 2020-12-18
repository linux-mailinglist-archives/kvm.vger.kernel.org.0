Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4A02DE1DC
	for <lists+kvm@lfdr.de>; Fri, 18 Dec 2020 12:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbgLRLSx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Dec 2020 06:18:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40306 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725897AbgLRLSx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Dec 2020 06:18:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608290247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0U2ng4OgtnIweMJnlOHX7/8gSM+yzUjp4bM4QsfSjIw=;
        b=QyrfGSwUPpXUVslHFXXXj2gtcrRuJSIjVXMvqx3+heajZKk/P/Z+CLSpWCj4abdsiUo3Ue
        AFC88m+4q37uFyArZZEFs6lMbditS4frJS0+e3euzpzyHVI/WfnnihL/sGmkJIi/nTf33j
        QEOYKVQnGwQ2294L6XamXccYM01y08c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-YEK83oKSMdWXZ8vTB5PE0w-1; Fri, 18 Dec 2020 06:17:25 -0500
X-MC-Unique: YEK83oKSMdWXZ8vTB5PE0w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 60B571005504;
        Fri, 18 Dec 2020 11:17:24 +0000 (UTC)
Received: from gondolin (ovpn-113-130.ams2.redhat.com [10.36.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C549519C59;
        Fri, 18 Dec 2020 11:17:19 +0000 (UTC)
Date:   Fri, 18 Dec 2020 12:17:17 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 6/8] s390x: sie: Add first SIE test
Message-ID: <20201218121717.33c06150.cohuck@redhat.com>
In-Reply-To: <20201211100039.63597-7-frankja@linux.ibm.com>
References: <20201211100039.63597-1-frankja@linux.ibm.com>
        <20201211100039.63597-7-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 11 Dec 2020 05:00:37 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> Let's check if we get the correct interception data on a few
> diags. This commit is more of an addition of boilerplate code than a
> real test.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/Makefile      |   1 +
>  s390x/sie.c         | 113 ++++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |   3 ++
>  3 files changed, 117 insertions(+)
>  create mode 100644 s390x/sie.c

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

