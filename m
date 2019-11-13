Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1BFFFB077
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 13:28:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbfKMM2D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 07:28:03 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26022 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725908AbfKMM2D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 07:28:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573648082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bKuS8wTsnbp+QgxRK9BwYMzAVyr0x1vb2LMNy0oBV1k=;
        b=WtlgphTfk4BBG+IdXOtN4OveNpwBuzeUF+3ZaUUIeyvMZ0MCDWeboPkm/+RJqgv3bUsyTh
        Lv6Tr0oJGTz9Q5NU+tvw6hWy048H/fcrHk3DNnOlaOuuBVEzoAXlMGleI+IMYFLR4NfKwE
        Xxx9n4AF9f/Hb/sjVZ7ijb/VQB6bYrs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-egTl0RBENzGSz28MvmWxGw-1; Wed, 13 Nov 2019 07:27:59 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9FF8D800C77;
        Wed, 13 Nov 2019 12:27:57 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-183.ams2.redhat.com [10.36.116.183])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4633D61075;
        Wed, 13 Nov 2019 12:27:53 +0000 (UTC)
Subject: Re: [RFC 08/37] KVM: s390: add missing include in gmap.h
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-9-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <2eeb323f-0bf0-60d7-e8ea-58bd0262fd76@redhat.com>
Date:   Wed, 13 Nov 2019 13:27:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191024114059.102802-9-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: egTl0RBENzGSz28MvmWxGw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/10/2019 13.40, Janosch Frank wrote:
> From: Claudio Imbrenda <imbrenda@linux.ibm.com>
>=20
> gmap.h references radix trees, but does not include linux/radix-tree.h
> itself. Sources that include gmap.h but not also radix-tree.h will
> therefore fail to compile.
>=20
> This simple patch adds the include for linux/radix-tree.h in gmap.h so
> that users of gmap.h will be able to compile.
>=20
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/include/asm/gmap.h | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
> index eab6a2ec3599..99b3eedda26e 100644
> --- a/arch/s390/include/asm/gmap.h
> +++ b/arch/s390/include/asm/gmap.h
> @@ -10,6 +10,7 @@
>  #define _ASM_S390_GMAP_H
> =20
>  #include <linux/refcount.h>
> +#include <linux/radix-tree.h>
> =20
>  /* Generic bits for GMAP notification on DAT table entry changes. */
>  #define GMAP_NOTIFY_SHADOW=090x2
>=20

Reviewed-by: Thomas Huth <thuth@redhat.com>

