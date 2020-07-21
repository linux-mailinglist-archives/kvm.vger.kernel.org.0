Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E08322798A
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 09:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgGUHdL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 03:33:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50880 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726039AbgGUHdK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 03:33:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595316789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=qAXnI74UDL++X7U9OYE6dP7WQDOiJ2USrhQV/FD9I9U=;
        b=ETn6f+SQ+Al3jV5FkSHp1IkYmZs9eAX+D98xCqFtxzqCuluRdKeCjpFpaJ1tl2lDozw0lz
        9w+VEZuH+F+zWd7m/VeE7BXDBklX2aNniiNn59ZnXE7RsoO5MgRAmFcfV8Huo075xV/Vt1
        Q4u0OfCAdssT7JdsuZlMaKpS9P69M+c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-N8_TvY2kOvSL_oVXgBmuGg-1; Tue, 21 Jul 2020 03:33:05 -0400
X-MC-Unique: N8_TvY2kOvSL_oVXgBmuGg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 194A758;
        Tue, 21 Jul 2020 07:33:04 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-102.ams2.redhat.com [10.36.112.102])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AA56879339;
        Tue, 21 Jul 2020 07:32:59 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 3/3] s390x: Ultavisor guest API test
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, imbrenda@linux.ibm.com
References: <20200717145813.62573-1-frankja@linux.ibm.com>
 <20200717145813.62573-4-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <6f4cd41a-aa33-d9c9-b998-1257429b3c4a@redhat.com>
Date:   Tue, 21 Jul 2020 09:32:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200717145813.62573-4-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/07/2020 16.58, Janosch Frank wrote:
> Test the error conditions of guest 2 Ultravisor calls, namely:
>      * Query Ultravisor information
>      * Set shared access
>      * Remove shared access
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/asm/uv.h  |  68 +++++++++++++++++++
>  s390x/Makefile      |   1 +
>  s390x/unittests.cfg |   3 +
>  s390x/uv-guest.c    | 156 ++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 228 insertions(+)
>  create mode 100644 lib/s390x/asm/uv.h
>  create mode 100644 s390x/uv-guest.c
[...]
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index b35269b..38c3257 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -92,3 +92,6 @@ extra_params = -device virtio-net-ccw
>  [skrf]
>  file = skrf.elf
>  smp = 2
> +
> +[uv-guest]
> +file = uv-guest.elf
> \ No newline at end of file

Add the newline, please.

 Thomas

