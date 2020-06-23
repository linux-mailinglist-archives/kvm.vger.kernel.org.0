Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B645A205672
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 17:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732973AbgFWP5H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 11:57:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54544 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732781AbgFWP5H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 11:57:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592927825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gJ2mg967LRzEzT8cTOfGmHU7BrYsE9KDV7kkCh+6EXk=;
        b=UHmXkVYPcM4kSWmqMW5XJ58mobMr/4AF52Ze7EQSzSerhIIQ65/uI0IIUa+68zkIjmaHZe
        /Sdj2QKOpLhleMFvDR/VcsV4Zv0S0bC3BQSeZbHmkrWG1DSmq4/Q8lkOf856GPj8vwGEgU
        lMWQ/xBaGYy3yJbvUjSxco4+5z5RL2A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-9S4ux017PKSk4SLjWv0X_A-1; Tue, 23 Jun 2020 11:57:01 -0400
X-MC-Unique: 9S4ux017PKSk4SLjWv0X_A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C324D1940921;
        Tue, 23 Jun 2020 15:56:56 +0000 (UTC)
Received: from gondolin (ovpn-112-222.ams2.redhat.com [10.36.112.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0AEE15C240;
        Tue, 23 Jun 2020 15:56:44 +0000 (UTC)
Date:   Tue, 23 Jun 2020 17:56:42 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Richard Henderson <rth@twiddle.net>, qemu-s390x@nongnu.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Peter Maydell <peter.maydell@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, qemu-arm@nongnu.org,
        qemu-ppc@nongnu.org, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH 5/7] target/i386/kvm: Simplify get_para_features()
Message-ID: <20200623175642.3b6b15d4.cohuck@redhat.com>
In-Reply-To: <20200623105052.1700-6-philmd@redhat.com>
References: <20200623105052.1700-1-philmd@redhat.com>
        <20200623105052.1700-6-philmd@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 23 Jun 2020 12:50:50 +0200
Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com> wrote:

> The KVMState* argument is now unused, drop it.
>=20
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
> ---
>  target/i386/kvm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

