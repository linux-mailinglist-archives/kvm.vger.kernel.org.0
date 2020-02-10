Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC92F158176
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 18:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbgBJRdJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 12:33:09 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:38132 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727054AbgBJRdJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Feb 2020 12:33:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581355988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iaFGWS0IAB6K0YRvn+Y4XtzpaCoSBrE6E/83m3NOqTw=;
        b=W7Dp1bVv3OIe8Kme2LR8V1wywgSknkPs5PxoQeL6amlupoMqLQGT1xI5TmiXdNTUiEta4U
        zmcQfnGGVFVwncUctjL0aDlBRdwnuk3E/pWHaWAe0a2IbLuzlMLdee9AvNEl+uPDxsTcVI
        pvzX45sr3AIFPR5oPGmCCUbwetJ/Cb8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-QnTdQC9-Pn2QQVCqj7lKvQ-1; Mon, 10 Feb 2020 12:32:58 -0500
X-MC-Unique: QnTdQC9-Pn2QQVCqj7lKvQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE3621137841;
        Mon, 10 Feb 2020 17:32:56 +0000 (UTC)
Received: from gondolin (ovpn-117-244.ams2.redhat.com [10.36.117.244])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A03975D9CA;
        Mon, 10 Feb 2020 17:32:52 +0000 (UTC)
Date:   Mon, 10 Feb 2020 18:32:49 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH 0/1] s390/uv: fix for ultravisor query function
Message-ID: <20200210183249.7816e316.cohuck@redhat.com>
In-Reply-To: <20200210165439.3767-1-borntraeger@de.ibm.com>
References: <20200210165439.3767-1-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 10 Feb 2020 11:54:38 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> As outlined by the architects the query command could actually return more
> than the minimal 168 bytes.
> 
> I will carry this with the KVM host support for protected virtualization

As this is cc:stable (and also relevant for the guest side), why not
merge it right now?

> 
> Christian Borntraeger (1):
>   s390/uv: Fix handling of length extensions
> 
>  arch/s390/boot/uv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

