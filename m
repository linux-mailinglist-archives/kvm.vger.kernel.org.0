Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C25F33BD755
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 15:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232602AbhGFNDW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 09:03:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24821 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232888AbhGFNDV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 09:03:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625576442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aP7YqwaC5NANUQbhXG09G16vw+w7MYUwX72AIDG0OD0=;
        b=CtxrBpcqYpPgJTEbTlXMMHByawucJPYa7a4WwQJOYkZcZoGnae5C139cjTIAxTYOnE40+b
        7mDLGFWn94MSbEqaEgb/ybAh6mko3ANaJP385s5C9Vu/hDYOKpvtNmbcH1rMW3Bqn4WzLX
        7OFRkGADH/b2kZPXzgZScH+VdovWcDg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-tie2yMiqMVi3bgSVO2sbqA-1; Tue, 06 Jul 2021 09:00:41 -0400
X-MC-Unique: tie2yMiqMVi3bgSVO2sbqA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E2D1100CA89;
        Tue,  6 Jul 2021 13:00:40 +0000 (UTC)
Received: from localhost (ovpn-113-13.ams2.redhat.com [10.36.113.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4FFB319D9D;
        Tue,  6 Jul 2021 13:00:36 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 4/5] lib: s390x: Print if a pgm
 happened while in SIE
In-Reply-To: <20210706121757.24070-5-frankja@linux.ibm.com>
Organization: Red Hat GmbH
References: <20210706121757.24070-1-frankja@linux.ibm.com>
 <20210706121757.24070-5-frankja@linux.ibm.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Tue, 06 Jul 2021 15:00:34 +0200
Message-ID: <878s2jha19.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 06 2021, Janosch Frank <frankja@linux.ibm.com> wrote:

> For debugging it helps if you know if the PGM happened while being in
> SIE or not.
>
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/interrupt.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

