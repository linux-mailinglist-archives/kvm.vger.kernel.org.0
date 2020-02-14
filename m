Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8193C15D863
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 14:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728223AbgBNN1Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 08:27:16 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44598 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726191AbgBNN1Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 08:27:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581686835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CD+OvV1+oyjNi5aOyeFUvCWQKDw5nHNMiDHldwp9R6k=;
        b=PV7vNX8mcnI0xslv26nNPca5ZOT0ds2mB0bE+6PGZ+iTl/TUH/sf3AYRh3HUS+IrrKWPrc
        y1sQyv0qw7dKJd+nzQvDv9e12exky2PGN7hdYPkAS2eem8L/nRhGNMlRNubhSzrVzCahOr
        bcbBNXwRhYliuxQiV4vU/4O47tohRxg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-i5nMgmLfMF6s8VjLYUzTtA-1; Fri, 14 Feb 2020 08:27:11 -0500
X-MC-Unique: i5nMgmLfMF6s8VjLYUzTtA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2EC6E8017CC;
        Fri, 14 Feb 2020 13:27:10 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 187F260BF1;
        Fri, 14 Feb 2020 13:27:08 +0000 (UTC)
Date:   Fri, 14 Feb 2020 14:27:06 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH v2 9/9] vfio-ccw: Remove inline get_schid() routine
Message-ID: <20200214142706.4d6a1efc.cohuck@redhat.com>
In-Reply-To: <20200206213825.11444-10-farman@linux.ibm.com>
References: <20200206213825.11444-1-farman@linux.ibm.com>
        <20200206213825.11444-10-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  6 Feb 2020 22:38:25 +0100
Eric Farman <farman@linux.ibm.com> wrote:

> This seems misplaced in the middle of FSM, returning the schid
> field from inside the private struct.  We could move this macro
> into vfio_ccw_private.h, but this doesn't seem to simplify things
> that much.  Let's just remove it, and use the field directly.

It had been introduced with the first set of traces, I'm now wondering
why, as it doesn't do any checking.

> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_fsm.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)

