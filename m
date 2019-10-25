Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4E11E45A2
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 10:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406729AbfJYIYn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 04:24:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29353 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2406061AbfJYIYn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 04:24:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571991882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jZ3ObiMH0F7j1wSA9zzxBruHE+ktLAVpPAJA85XUiWU=;
        b=gJJdg1jQxhkDIsIo/fsm8A6Adot0dpOfhx0SpALLFmimo58aYtFrbFmgeCCATn5YO8S67w
        3HW7E3fULBH67m/qPgDFvfOurDpD0OkT/HeVF8TfzOkwzZ+O9eAUVdCTkLGBgN/6lGZidL
        HmgQZtSV+hAQJTwlTTSFfVsf5Bbk+eE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-qDmLouTCOL-Pj66QQpcQeg-1; Fri, 25 Oct 2019 04:24:38 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 511DA1800E00;
        Fri, 25 Oct 2019 08:24:37 +0000 (UTC)
Received: from [10.36.116.205] (ovpn-116-205.ams2.redhat.com [10.36.116.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7691E5D70E;
        Fri, 25 Oct 2019 08:24:35 +0000 (UTC)
Subject: Re: [RFC 08/37] KVM: s390: add missing include in gmap.h
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-9-frankja@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <2055e82a-5fea-1903-1c76-b3a8c8fb544f@redhat.com>
Date:   Fri, 25 Oct 2019 10:24:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191024114059.102802-9-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: qDmLouTCOL-Pj66QQpcQeg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24.10.19 13:40, Janosch Frank wrote:
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
>   arch/s390/include/asm/gmap.h | 1 +
>   1 file changed, 1 insertion(+)
>=20
> diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
> index eab6a2ec3599..99b3eedda26e 100644
> --- a/arch/s390/include/asm/gmap.h
> +++ b/arch/s390/include/asm/gmap.h
> @@ -10,6 +10,7 @@
>   #define _ASM_S390_GMAP_H
>  =20
>   #include <linux/refcount.h>
> +#include <linux/radix-tree.h>
>  =20
>   /* Generic bits for GMAP notification on DAT table entry changes. */
>   #define GMAP_NOTIFY_SHADOW=090x2
>=20

Not sure if that's worth a separate patch, just squash it into the patch=20
that needs it?

We usually don't care about includes as long as it compiles ...

--=20

Thanks,

David / dhildenb

