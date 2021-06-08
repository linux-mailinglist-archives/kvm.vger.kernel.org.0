Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6161139FA1F
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 17:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232506AbhFHPQz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 11:16:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57161 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231919AbhFHPQz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Jun 2021 11:16:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623165302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DBzZ0giUi0clYylDFixzw8klb95kxm2/f8ftRAoXrk0=;
        b=WETDj9CQNAY7yYOzg7rTCptVNaDNqayIA5xvgJGiyCQ3ft2QRDkdyluOPc6oxDgP7CC46K
        Tnba7HVDnaoRx+JK0AfRz0Qw1eHv0GbwEqDpP3lexLAJmXVkEIpjd2drzKLIZ/PDXRD+AK
        UZmKpPFMZKYCNI33m3PPt0hqyAj7qBY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-532-7F4o8x6gMH-JubwOibInOw-1; Tue, 08 Jun 2021 11:15:00 -0400
X-MC-Unique: 7F4o8x6gMH-JubwOibInOw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1520E19611B3;
        Tue,  8 Jun 2021 15:14:18 +0000 (UTC)
Received: from blackfin.pond.sub.org (ovpn-112-222.ams2.redhat.com [10.36.112.222])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AE4151001281;
        Tue,  8 Jun 2021 15:14:17 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id 473AD113865F; Tue,  8 Jun 2021 17:14:16 +0200 (CEST)
From:   Markus Armbruster <armbru@redhat.com>
To:     Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
Cc:     qemu-devel@nongnu.org, Eduardo Habkost <ehabkost@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eric Blake <eblake@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
        Denis Lunev <den@openvz.org>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>
Subject: Re: [PATCH v8] qapi: introduce 'query-kvm-cpuid' action
References: <20210531123806.23030-1-valeriy.vdovin@virtuozzo.com>
Date:   Tue, 08 Jun 2021 17:14:16 +0200
In-Reply-To: <20210531123806.23030-1-valeriy.vdovin@virtuozzo.com> (Valeriy
        Vdovin's message of "Mon, 31 May 2021 15:38:06 +0300")
Message-ID: <87y2bkwfqv.fsf@dusky.pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Double-checking: this supersedes "[PATCH v7 0/1] qapi: introduce
'query-cpu-model-cpuid' action"?

