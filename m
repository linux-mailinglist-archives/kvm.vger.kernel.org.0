Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE3922F4B99
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 13:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbhAMMq2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 07:46:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46918 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726444AbhAMMq1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 07:46:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610541901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F3WiU78RlY++Bnrxe9JspTUC7PCyi5iSAB/acj+rOEw=;
        b=ZPTksQXEXcCwTfx3MPA/EQirid02w2wGiWebYKEl8iMq+agWxPbBq4Zka20mGTePX6686V
        VPyEhIk9R9GBaFzu0g0sl3d3U6gv6rODDL2tL881YALI/0Gf4Zc+5Jn3VIGfjGQFiSQzHG
        ORPebOgbFoEWS9mAYq3UJUsJ9DTtvTo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-OIB277CQNtu9GXwXViB-1Q-1; Wed, 13 Jan 2021 07:44:59 -0500
X-MC-Unique: OIB277CQNtu9GXwXViB-1Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8BB3680666B;
        Wed, 13 Jan 2021 12:44:58 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-122.ams2.redhat.com [10.36.112.122])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 22EB71042A40;
        Wed, 13 Jan 2021 12:44:53 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v4 5/9] s390x: sie: Add SIE to lib
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20210112132054.49756-1-frankja@linux.ibm.com>
 <20210112132054.49756-6-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <85cd46f1-fd09-752d-a85f-2a5907ee0802@redhat.com>
Date:   Wed, 13 Jan 2021 13:44:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210112132054.49756-6-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/01/2021 14.20, Janosch Frank wrote:
> This commit adds the definition of the SIE control block struct and
> the assembly to execute SIE and save/restore guest registers.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   lib/s390x/asm-offsets.c  |  11 +++
>   lib/s390x/asm/arch_def.h |   9 ++
>   lib/s390x/interrupt.c    |   7 ++
>   lib/s390x/sie.h          | 197 +++++++++++++++++++++++++++++++++++++++
>   s390x/lib.S              |  56 +++++++++++
>   5 files changed, 280 insertions(+)
>   create mode 100644 lib/s390x/sie.h
[...]
> diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
> new file mode 100644
> index 0000000..66aa3b8
> --- /dev/null
> +++ b/lib/s390x/sie.h
> @@ -0,0 +1,197 @@
> +#ifndef SIE_H
> +#define SIE_H

Add a SPDX license identifier at the top of the new file?

Apart from that looks ok to me.

Acked-by: Thomas Huth <thuth@redhat.com>

