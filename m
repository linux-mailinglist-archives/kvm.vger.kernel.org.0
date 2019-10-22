Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE6DE07AF
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 17:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731476AbfJVPoN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 11:44:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59267 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730305AbfJVPoM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 11:44:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571759051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HIRV4OoEGpsIq1M7/7vc7smAtVYgtd5vhz7zUvougp0=;
        b=PdILS0a7+OiNnWJukvgZTaY2sbOakD3uQ3sqydU/wZoquzUzGDS0f5LyMH80HGs3b+xj8T
        i2uT/3zYVHrD7Sj+YtxIlISDSp5L7igTpIY1gXOuN2bg08owlc3L6rKxpbIXRcHp7NDutC
        d6dOSNqQCWfdFuywRjvVyixN4dlSoPU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-9RmPP_f9NY-zD_WwAsbhfQ-1; Tue, 22 Oct 2019 11:44:09 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A4851800D6A;
        Tue, 22 Oct 2019 15:44:08 +0000 (UTC)
Received: from [10.36.116.248] (ovpn-116-248.ams2.redhat.com [10.36.116.248])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0EF3260856;
        Tue, 22 Oct 2019 15:44:06 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v1 1/5] s390x: remove redundant defines
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
References: <1571741584-17621-1-git-send-email-imbrenda@linux.ibm.com>
 <1571741584-17621-2-git-send-email-imbrenda@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <bc05cdfa-60f5-007c-8df3-ab32f024cda3@redhat.com>
Date:   Tue, 22 Oct 2019 17:44:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1571741584-17621-2-git-send-email-imbrenda@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: 9RmPP_f9NY-zD_WwAsbhfQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22.10.19 12:53, Claudio Imbrenda wrote:
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   lib/s390x/sclp.h | 2 --
>   1 file changed, 2 deletions(-)
>=20
> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
> index 4e69845..f00c3df 100644
> --- a/lib/s390x/sclp.h
> +++ b/lib/s390x/sclp.h
> @@ -27,8 +27,6 @@
>   #define SCLP_ASSIGN_STORAGE                     0x000D0001
>   #define SCLP_CMD_READ_EVENT_DATA                0x00770005
>   #define SCLP_CMD_WRITE_EVENT_DATA               0x00760005
> -#define SCLP_CMD_READ_EVENT_DATA                0x00770005
> -#define SCLP_CMD_WRITE_EVENT_DATA               0x00760005
>   #define SCLP_CMD_WRITE_EVENT_MASK               0x00780005
>  =20
>   /* SCLP Memory hotplug codes */
>=20

Reviewed-by: David Hildenbrand <david@redhat.com>

--=20

Thanks,

David / dhildenb

