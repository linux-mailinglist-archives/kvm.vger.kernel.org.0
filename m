Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9A58143F89
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 15:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728913AbgAUOaU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 09:30:20 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38047 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728896AbgAUOaU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jan 2020 09:30:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579617019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J4eiEY1Vp5G7V7G87XuZJdLRm7ASud/whs4zoxGnlW0=;
        b=idCObEF8P2Nd3l4aHbYLtD3WZiL6DFeQNUI/822TN6vrBqoD1aHzYyBdlk8hzpVT3FLHWN
        niI9ogf3S8LD0c5SKsc/7ZyD0Z76zq+/tg/5UrXoXyu5FSKhzaN7ICKR6cqSqplsrNx34v
        3jG6Kq7oX3pmpwtFh3IVVPuuEk+hzSM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-F66iR9aAM3eCoDb5nk58xw-1; Tue, 21 Jan 2020 09:30:14 -0500
X-MC-Unique: F66iR9aAM3eCoDb5nk58xw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B1AC18FE86B;
        Tue, 21 Jan 2020 14:30:13 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2194485733;
        Tue, 21 Jan 2020 14:30:03 +0000 (UTC)
Date:   Tue, 21 Jan 2020 15:30:01 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, david@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 7/9] s390x: smp: Remove unneeded cpu
 loops
Message-ID: <20200121153001.2354b787.cohuck@redhat.com>
In-Reply-To: <20200121134254.4570-8-frankja@linux.ibm.com>
References: <20200121134254.4570-1-frankja@linux.ibm.com>
        <20200121134254.4570-8-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 21 Jan 2020 08:42:52 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> Now that we have a loop which is executed after we return from the
> main function of a secondary cpu, we can remove the surplus loops.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/smp.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

