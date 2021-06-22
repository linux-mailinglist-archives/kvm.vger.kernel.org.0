Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 596273B0A7C
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 18:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbhFVQme (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 12:42:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56318 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229501AbhFVQmc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 12:42:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624380016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=se+zilMB7X1YP4dRxTYQDj5HcIOKP3pN2V5c15IDvTc=;
        b=FVNtfa6NYvgSZUEVcmSBKWYZVu2B8XWpxweoliSren163wl836k03J/aDMrxmpley7bOL4
        7Qas5FidmlN7XCuXHjXqRA+6XcXBQ+CK1r5Gs9gm4IzpCoHAyPEKqCnaU9uN1dahftCY4X
        Hk/IEQ4/PEzainlx2+YEUnCT6Z2+lKI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-OVj-DHpuNDe-YCe4wqQoWg-1; Tue, 22 Jun 2021 12:40:15 -0400
X-MC-Unique: OVj-DHpuNDe-YCe4wqQoWg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 535A15074F;
        Tue, 22 Jun 2021 16:40:14 +0000 (UTC)
Received: from localhost (ovpn-113-161.ams2.redhat.com [10.36.113.161])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A066D60C13;
        Tue, 22 Jun 2021 16:40:10 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: Re: [PATCH 0/2] KVM: s390: Enable some more facilities
In-Reply-To: <20210622143412.143369-1-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
References: <20210622143412.143369-1-borntraeger@de.ibm.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Tue, 22 Jun 2021 18:40:08 +0200
Message-ID: <871r8tontj.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 22 2021, Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> Some more facilities that can be enabled in the future.
>
> Christian Borntraeger (2):
>   KVM: s390: gen_facilities: allow facilities 165, 193, 194 and 196
>   KVM: s390: allow facility 192 (vector-packed-decimal-enhancement
>     facility 2)
>
>  arch/s390/kvm/kvm-s390.c         | 4 ++++
>  arch/s390/tools/gen_facilities.c | 4 ++++
>  2 files changed, 8 insertions(+)

I assume we can also expect some QEMU patches sometime in the future
that add some new features?

