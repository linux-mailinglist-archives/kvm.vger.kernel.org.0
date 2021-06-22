Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A425D3B0A77
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 18:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhFVQlF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 12:41:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29652 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230433AbhFVQlC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 12:41:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624379926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G7ViLK53DDsNzq1tHJCi11YMXm8GNRKV0PJ0yut8RKc=;
        b=OFsYpkkX1fvsa3Q9RcDtg/SJY/QydmKMeDBUbxavanqHKF7XHljP1GuYfkHBDROowEkXKl
        Kvr+jOaM/d71PTj1INlAjxlNFlHVS2ptqEDLl23bD3aFKT6fwNpXo/jIof4DBIv0jT2onP
        JxUT7CHquWLwabY0KyRjB4Hr+DeSktU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556-r1fg8FwdPWi0xwcRuRxr4Q-1; Tue, 22 Jun 2021 12:38:44 -0400
X-MC-Unique: r1fg8FwdPWi0xwcRuRxr4Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3AD1101C8A8;
        Tue, 22 Jun 2021 16:38:43 +0000 (UTC)
Received: from localhost (ovpn-113-161.ams2.redhat.com [10.36.113.161])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2D3685C1A3;
        Tue, 22 Jun 2021 16:38:40 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: Re: [PATCH 1/2] KVM: s390: gen_facilities: allow facilities 165,
 193, 194 and 196
In-Reply-To: <20210622143412.143369-2-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
References: <20210622143412.143369-1-borntraeger@de.ibm.com>
 <20210622143412.143369-2-borntraeger@de.ibm.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Tue, 22 Jun 2021 18:38:38 +0200
Message-ID: <877dilonw1.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 22 2021, Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> This enables the neural NNPA, BEAR enhancement,reset DAT protection and
> processor activity counter facilities via the cpu model.
>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/tools/gen_facilities.c | 4 ++++
>  1 file changed, 4 insertions(+)

Acked-by: Cornelia Huck <cohuck@redhat.com>

