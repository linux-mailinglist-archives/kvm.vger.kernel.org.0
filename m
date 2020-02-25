Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE6416C27E
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 14:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbgBYNiM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 08:38:12 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:54977 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729436AbgBYNiM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Feb 2020 08:38:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582637891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uqrYDGOPvocJH86TyjfBP/1CVx/kl4DKptsJKL9nxzY=;
        b=Klu0Dcfyc8yMMd5RTVgmGICa7rHzOwmVjHcVe4mG3aimi7FaFFy0WTdIHm9EQGOYpuN/Qi
        ZlnCCKI2cOAzKgimBZcwECoNZYyhjPN76ZozjPqB9adn9wk3Hu87xzjG3qRdd6622CAp5z
        WyfIZztDpSGfjpHDh3ewLQFM+D8QeUE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-9elUk2JsPKaJRrdkMluulg-1; Tue, 25 Feb 2020 08:38:07 -0500
X-MC-Unique: 9elUk2JsPKaJRrdkMluulg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 789D818C8C01;
        Tue, 25 Feb 2020 13:38:05 +0000 (UTC)
Received: from gondolin (dhcp-192-175.str.redhat.com [10.33.192.175])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D83DD1BC6D;
        Tue, 25 Feb 2020 13:38:00 +0000 (UTC)
Date:   Tue, 25 Feb 2020 14:37:58 +0100
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
Message-ID: <20200225143758.293fd5fb.cohuck@redhat.com>
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

...oh, and maybe document the new interfaces under Documentation/ABI/
as well?

(No objection if you do that in a follow-up patch.)

