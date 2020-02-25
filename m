Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5668C16C259
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 14:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729501AbgBYNaY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 08:30:24 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37854 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725788AbgBYNaX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 08:30:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582637422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YO6MQmEEMQfOmyvhbXpIKIzhT3zJKVA8WvfnyBwcYvs=;
        b=Ht/ixZOGDV9BJOYfcl6OgfIwDEWWSF6ZXCCnDTCYts27r4WkqSYUv+zTKoYEnFL9NLM9ab
        2U8tP3oWsAX/XMid1MSCE4HBxloy85+6FT14MfzANpKfZFDk5vPKV0f4JsCm7rIlX6cUzx
        uitXQrZi/ZPOOo55+2hVyXh6CZ1kTac=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-yoKG_WUxPdiTmM8AxW-_Hw-1; Tue, 25 Feb 2020 08:30:13 -0500
X-MC-Unique: yoKG_WUxPdiTmM8AxW-_Hw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9756E800EB5;
        Tue, 25 Feb 2020 13:30:11 +0000 (UTC)
Received: from gondolin (dhcp-192-175.str.redhat.com [10.33.192.175])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 102235C13D;
        Tue, 25 Feb 2020 13:30:06 +0000 (UTC)
Date:   Tue, 25 Feb 2020 14:30:04 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v4 34/36] s390: protvirt: Add sysfs firmware interface
 for Ultravisor information
Message-ID: <20200225143004.4c47f1b8.cohuck@redhat.com>
In-Reply-To: <20200224114107.4646-35-borntraeger@de.ibm.com>
References: <20200224114107.4646-1-borntraeger@de.ibm.com>
        <20200224114107.4646-35-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 24 Feb 2020 06:41:05 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Janosch Frank <frankja@linux.ibm.com>
> 
> That information, e.g. the maximum number of guests or installed
> Ultravisor facilities, is interesting for QEMU, Libvirt and
> administrators.
> 
> Let's provide an easily parsable API to get that information.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/kernel/uv.c | 86 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 86 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

