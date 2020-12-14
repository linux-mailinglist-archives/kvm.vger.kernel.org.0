Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE44A2D9CFE
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 17:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439768AbgLNQxd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 11:53:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40444 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2440217AbgLNQxM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Dec 2020 11:53:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607964694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A72Th0EBzdWevELpcsCRVHitaUekrAGMryjv4g4EB18=;
        b=apq+dgetj8JbGBQaS5EZ3QNjCSzjv/R++A2GjtJjTnbMRnsFNGoxbKzeCW9Pw+7a/DlRLd
        8PcUTMRsNljZ0smPZrCvrK8VJjtVbW6M7vIfwSkv1AFxtBV2M3MYg+G+7RvTa+YswbHWXC
        TFgoDko+kMC4CYlBsMEeM3NqiVARzgk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-56-DRMjPBgGN2aSoxjlAeiN1A-1; Mon, 14 Dec 2020 11:51:29 -0500
X-MC-Unique: DRMjPBgGN2aSoxjlAeiN1A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7515719611B7;
        Mon, 14 Dec 2020 16:51:19 +0000 (UTC)
Received: from gondolin (ovpn-113-171.ams2.redhat.com [10.36.113.171])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3659560BE2;
        Mon, 14 Dec 2020 16:50:24 +0000 (UTC)
Date:   Mon, 14 Dec 2020 17:50:22 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     pair@us.ibm.com, pbonzini@redhat.com, frankja@linux.ibm.com,
        brijesh.singh@amd.com, dgilbert@redhat.com, qemu-devel@nongnu.org,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-ppc@nongnu.org,
        rth@twiddle.net, thuth@redhat.com, berrange@redhat.com,
        mdroth@linux.vnet.ibm.com, Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        david@redhat.com, Richard Henderson <richard.henderson@linaro.org>,
        borntraeger@de.ibm.com, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        pasic@linux.ibm.com,
        Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@redhat.com>
Subject: Re: [for-6.0 v5 07/13] sev: Add Error ** to sev_kvm_init()
Message-ID: <20201214175022.04098f42.cohuck@redhat.com>
In-Reply-To: <20201204054415.579042-8-david@gibson.dropbear.id.au>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
        <20201204054415.579042-8-david@gibson.dropbear.id.au>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  4 Dec 2020 16:44:09 +1100
David Gibson <david@gibson.dropbear.id.au> wrote:

> This allows failures to be reported richly and idiomatically.
>=20
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> Reviewed-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> ---
>  accel/kvm/kvm-all.c  |  4 +++-
>  accel/kvm/sev-stub.c |  5 +++--
>  include/sysemu/sev.h |  2 +-
>  target/i386/sev.c    | 31 +++++++++++++++----------------
>  4 files changed, 22 insertions(+), 20 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

