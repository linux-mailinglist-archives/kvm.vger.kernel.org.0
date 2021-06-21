Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91B5B3AEBAD
	for <lists+kvm@lfdr.de>; Mon, 21 Jun 2021 16:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhFUOtY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 10:49:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56534 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230076AbhFUOtW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Jun 2021 10:49:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624286828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MYUWWvfas2vfmbE1PFvd5rlCu4u4NSRSDtDz3HiuHqw=;
        b=AuRzsfQKtD/Zn/ArK9x7FM8DLES87ntx4yl6+5kAfmwdn3nZmHuVdA2JHpIZiSn2Ulmse8
        El4vfWo9qCVB51ceTNjiIi71LRKonYbsqAvYxeaj9f9pinNzyCwQcdCpDm/9APKn9T9z5X
        coYnnAXHY5fJlSk7tRxjD9P7HacmOz4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-580-mGQ-nS3PMU6D7W2w11na0A-1; Mon, 21 Jun 2021 10:47:04 -0400
X-MC-Unique: mGQ-nS3PMU6D7W2w11na0A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71CB9800C78;
        Mon, 21 Jun 2021 14:47:03 +0000 (UTC)
Received: from localhost (ovpn-113-141.ams2.redhat.com [10.36.113.141])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 01A601899A;
        Mon, 21 Jun 2021 14:47:00 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2] s390x: selftest: Add prefixes to fix
 report output (was "s390x: selftest: Fix report output")
In-Reply-To: <20210610141913.61553-1-frankja@linux.ibm.com>
Organization: Red Hat GmbH
References: <20210610141913.61553-1-frankja@linux.ibm.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Mon, 21 Jun 2021 16:46:59 +0200
Message-ID: <87pmwfnul8.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 10 2021, Janosch Frank <frankja@linux.ibm.com> wrote:

> To make our TAP parser (and me) happy we don't want to have two reports
> with exactly the same wording so I added in two new prefix pushes.
>
> Also moving the code inside of the region of a prefix will give us
> more data when a problem arises.
>
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  s390x/selftest.c | 26 ++++++++++++++++++--------
>  1 file changed, 18 insertions(+), 8 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

