Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0023E8355
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 20:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbhHJS5K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 14:57:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53003 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230351AbhHJS5J (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 14:57:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628621807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=v76VOxsokd0mSV5ZPY9TpeuYqmlLz6EMYRsxAWqLLcU=;
        b=HbL27tbZvT2z+WrHy1wqEX5o9y5DnLlPo5zBgSELPNH9BHoGBWmvJCoFQ4D0jPVihMH34+
        qX71j2EuZs/2NOb0xsmrBVd9LoTuEpdlOYgcWJhZZhoTHN6dcDbwJvJg66CL/YixClRYta
        aAjom0VmkKWY9VANx2wYnq9OA3FqXrw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-94J7-OEHPA2mCk-0TaMo4Q-1; Tue, 10 Aug 2021 14:56:46 -0400
X-MC-Unique: 94J7-OEHPA2mCk-0TaMo4Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ECA95100E422;
        Tue, 10 Aug 2021 18:56:44 +0000 (UTC)
Received: from localhost (unknown [10.22.32.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF06A60BF1;
        Tue, 10 Aug 2021 18:56:44 +0000 (UTC)
Date:   Tue, 10 Aug 2021 14:56:44 -0400
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     Markus Armbruster <armbru@redhat.com>
Cc:     Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>,
        qemu-devel@nongnu.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eric Blake <eblake@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
        Denis Lunev <den@openvz.org>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>
Subject: Re: [PATCH v12] qapi: introduce 'query-x86-cpuid' QMP command.
Message-ID: <20210810185644.iyqt3iao2qdqd5jk@habkost.net>
References: <20210728125402.2496-1-valeriy.vdovin@virtuozzo.com>
 <87eeb59vwt.fsf@dusky.pond.sub.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87eeb59vwt.fsf@dusky.pond.sub.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Aug 07, 2021 at 04:22:42PM +0200, Markus Armbruster wrote:
> Is this intended to be a stable interface?  Interfaces intended just for
> debugging usually aren't.

I don't think we need to make it a stable interface, but I won't
mind if we declare it stable.

> 
> Eduardo, what's your take on this version?
> 

I sent my comments as reply to v14:
https://lore.kernel.org/qemu-devel/20210810185245.kivvmrmvew6e5xtr@habkost.net/

-- 
Eduardo

