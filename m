Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 244F71F3330
	for <lists+kvm@lfdr.de>; Tue,  9 Jun 2020 06:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgFIE4F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jun 2020 00:56:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29202 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725770AbgFIE4E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jun 2020 00:56:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591678563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=8CZewMm2pePHSd55eyFInMAbo9R9wa72FHyY0AUAJAI=;
        b=E0e0hODE8nanUcRQ8qusmQDFlXwD7IlkrGFkhUTb9LYLXr9pTD2XS/z0ubXXRlj4X9/fJm
        xdZt+1IC1Gc6Oy/2eNNvBF9aiGDi7zcfJLyBbDb6tnZle/8tDPWqSqW25if92ynWkdfOyC
        w2210KtvL1ORgTAfT1SJUrosp195kxw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-Mk1HueekNOSeaUCS9rq_sg-1; Tue, 09 Jun 2020 00:56:01 -0400
X-MC-Unique: Mk1HueekNOSeaUCS9rq_sg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0194D800053
        for <kvm@vger.kernel.org>; Tue,  9 Jun 2020 04:56:01 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-109.ams2.redhat.com [10.36.112.109])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 594A060BF3;
        Tue,  9 Jun 2020 04:56:00 +0000 (UTC)
Subject: Re: [PATCH kvm-unit-tests] remove unused file
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20200608124222.371807-1-pbonzini@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <1f1936ab-0658-57cc-8803-44c3ce46a9d3@redhat.com>
Date:   Tue, 9 Jun 2020 06:55:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200608124222.371807-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Unused since the beginning (of the repository)!

Reviewed-by: Thomas Huth <thuth@redhat.com>

On 08/06/2020 14.42, Paolo Bonzini wrote:
> ---
>  lib/x86/fake-apic.h | 14 --------------
>  1 file changed, 14 deletions(-)
>  delete mode 100644 lib/x86/fake-apic.h
> 
> diff --git a/lib/x86/fake-apic.h b/lib/x86/fake-apic.h
> deleted file mode 100644
> index eed63ba..0000000
> --- a/lib/x86/fake-apic.h
> +++ /dev/null
> @@ -1,14 +0,0 @@
> -#ifndef SILLY_APIC_H
> -#define SILLY_APIC_H
> -
> -#define APIC_BASE 0x1000
> -#define APIC_SIZE 0x100
> -
> -#define APIC_REG_NCPU        0x00
> -#define APIC_REG_ID          0x04
> -#define APIC_REG_SIPI_ADDR   0x08
> -#define APIC_REG_SEND_SIPI   0x0c
> -#define APIC_REG_IPI_VECTOR  0x10
> -#define APIC_REG_SEND_IPI    0x14
> -
> -#endif
> 

