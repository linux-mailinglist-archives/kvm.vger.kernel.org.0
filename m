Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B923B0A7A
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 18:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbhFVQlh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 12:41:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47403 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230330AbhFVQlg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 12:41:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624379960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZylNfd/zkkqrI5epOo0fvRHSkbimYQVl9gPOvHylbT8=;
        b=H0kxLsXjG+t8Zft8E10HY1cVcd2Dy9rDPQhOyaHl8xHJWYdjX78XAH1oiymMEPmASfM9Wp
        WUwKxavYSBDV7b5PG9i9Ut1uvRK5hSKJPkfNm2VNF79OdZIppyC16PfWIAUF8mEFFrhUT6
        1bl7AzRdZfRxGfDAa1VzrOFWEaK8Odg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556-DnAg_apwN7WwhbU0Nj5EIQ-1; Tue, 22 Jun 2021 12:39:17 -0400
X-MC-Unique: DnAg_apwN7WwhbU0Nj5EIQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 33B5F362F9;
        Tue, 22 Jun 2021 16:39:16 +0000 (UTC)
Received: from localhost (ovpn-113-161.ams2.redhat.com [10.36.113.161])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6541A5D705;
        Tue, 22 Jun 2021 16:39:12 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: Re: [PATCH 2/2] KVM: s390: allow facility 192
 (vector-packed-decimal-enhancement facility 2)
In-Reply-To: <20210622143412.143369-3-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
References: <20210622143412.143369-1-borntraeger@de.ibm.com>
 <20210622143412.143369-3-borntraeger@de.ibm.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Tue, 22 Jun 2021 18:39:10 +0200
Message-ID: <874kdponv5.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 22 2021, Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> pass through newer vector instructions if vector support is enabled.
>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 4 ++++
>  1 file changed, 4 insertions(+)

Acked-by: Cornelia Huck <cohuck@redhat.com>

