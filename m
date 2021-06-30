Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C61D3B7F98
	for <lists+kvm@lfdr.de>; Wed, 30 Jun 2021 11:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233675AbhF3JF4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Jun 2021 05:05:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36149 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233665AbhF3JFz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Jun 2021 05:05:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625043807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CptACCdtWWZszRteSIZXB3oN+I68gCp2IuHcO4182qw=;
        b=UjglVxlA2jKuhzAL9sDETsvtHyJ7cLY9l89VHw7upyWMGEHdxgBkCerTGyf/nhECOAxA0k
        rZBi3yksZFaCeoAJbISV9bGf3ogRICI+7YrCP6+ZC0oWjwlR8IRaviPO0uIlza+5Y7iqGP
        nkTOxYHPL1/wt9toUoJFIBHroE6tXhQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564-HyOqA6IqO6mgDI2xgv8yRw-1; Wed, 30 Jun 2021 05:03:23 -0400
X-MC-Unique: HyOqA6IqO6mgDI2xgv8yRw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B1A75100C662;
        Wed, 30 Jun 2021 09:03:22 +0000 (UTC)
Received: from localhost (ovpn-112-48.ams2.redhat.com [10.36.112.48])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C251A60843;
        Wed, 30 Jun 2021 09:03:19 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH 3/5] lib: s390x: uv: Int type cleanup
In-Reply-To: <20210629133322.19193-4-frankja@linux.ibm.com>
Organization: Red Hat GmbH
References: <20210629133322.19193-1-frankja@linux.ibm.com>
 <20210629133322.19193-4-frankja@linux.ibm.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Wed, 30 Jun 2021 11:03:18 +0200
Message-ID: <87r1gjlo6h.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 29 2021, Janosch Frank <frankja@linux.ibm.com> wrote:

> These structs have largely been copied from the kernel so they still
> have the old uint short types which we want to avoid in favor of the
> uint*_t ones.
>
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/asm/uv.h | 142 +++++++++++++++++++++++----------------------
>  1 file changed, 72 insertions(+), 70 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

