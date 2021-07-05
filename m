Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7974F3BBB4F
	for <lists+kvm@lfdr.de>; Mon,  5 Jul 2021 12:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbhGEKgq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jul 2021 06:36:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38028 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230421AbhGEKgp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Jul 2021 06:36:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625481248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MLsg6ynw9oeo8+beNTRKOhPo0W4oRUWZoQkESCG4mkc=;
        b=STB8+J9YyLJVX29zfzjQp63Gv3NFp1rmm7a1D3oSTEPM2M5Q6pnJZg0GoowpeyfglUJwrG
        9hf5vUF2vfAMfcbpiEgr8eyy3Y/A02v3/nezzEryvtpSZEV2dwnNGHeNTefl+72BIzwZtc
        A8vNUtkH1ijlXp6l8tFjjwBW1JsC0JA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-534-t-5dCkwNNXW0csR0zYahGg-1; Mon, 05 Jul 2021 06:34:07 -0400
X-MC-Unique: t-5dCkwNNXW0csR0zYahGg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4BEC69126B;
        Mon,  5 Jul 2021 10:34:06 +0000 (UTC)
Received: from localhost (ovpn-112-39.ams2.redhat.com [10.36.112.39])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 34CF35C1A1;
        Mon,  5 Jul 2021 10:34:02 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        KVM <kvm@vger.kernel.org>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH/RFC] KVM: selftests: introduce P44V64 for z196 and EC12
In-Reply-To: <20210701153853.33063-1-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
References: <20210701153853.33063-1-borntraeger@de.ibm.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Mon, 05 Jul 2021 12:34:00 +0200
Message-ID: <87o8bhhwx3.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 01 2021, Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> Older machines likes z196 and zEC12 do only support 44 bits of physical

s/likes/like/

> addresses. Make this the default and check via IBC if we are on a later
> machine. We then add P47V64 as an additional model.
>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Fixes: 1bc603af73dd ("KVM: selftests: introduce P47V64 for s390x")
> ---
>  tools/testing/selftests/kvm/include/kvm_util.h |  3 ++-
>  tools/testing/selftests/kvm/lib/guest_modes.c  | 16 ++++++++++++++++
>  tools/testing/selftests/kvm/lib/kvm_util.c     |  5 +++++
>  3 files changed, 23 insertions(+), 1 deletion(-)
>

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

