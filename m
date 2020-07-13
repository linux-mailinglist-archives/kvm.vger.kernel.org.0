Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B8521D9FD
	for <lists+kvm@lfdr.de>; Mon, 13 Jul 2020 17:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729581AbgGMPXV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jul 2020 11:23:21 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:22016 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729027AbgGMPXV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Jul 2020 11:23:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594653800;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=7ajBPh1qmyCh5SZCEXU80uesDCoVozHqIKx5UkBXBwc=;
        b=F4js00WCNsrM9HPHeukzP81/gkbEr2ZPcN0G/7IfhpVeXKPzRs0YTIyYlbwcj6r0AgwGNK
        TZSBPngQTMaCcGphPT9SxCXM9KnU8p+DH+u5E7L72dnzRd0zggiicABL8BHCJ0Am11a9c8
        XrrYRcfBMlF6t6l3P/1S0wJyFf5YJbs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-9nRBJpFVOSqdfKHxm2NmFA-1; Mon, 13 Jul 2020 11:23:17 -0400
X-MC-Unique: 9nRBJpFVOSqdfKHxm2NmFA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 451EA800685;
        Mon, 13 Jul 2020 15:23:16 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-125.ams2.redhat.com [10.36.112.125])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C41C5C1BB;
        Mon, 13 Jul 2020 15:23:15 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] x86: reverse FW_CFG_MAX_ENTRY and
 FW_CFG_MAX_RAM
To:     Nadav Amit <namit@vmware.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20200711161432.32862-1-namit@vmware.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5fb8b8c6-bb1d-ba97-6ecf-770959199bff@redhat.com>
Date:   Mon, 13 Jul 2020 17:23:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200711161432.32862-1-namit@vmware.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/07/2020 18.14, Nadav Amit wrote:
> FW_CFG_MAX_ENTRY should obviously be the last entry.
> 
> Signed-off-by: Nadav Amit <namit@vmware.com>
> ---
>  lib/x86/fwcfg.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/x86/fwcfg.h b/lib/x86/fwcfg.h
> index 64d4c6e..8095d8a 100644
> --- a/lib/x86/fwcfg.h
> +++ b/lib/x86/fwcfg.h
> @@ -20,8 +20,8 @@
>  #define FW_CFG_NUMA             0x0d
>  #define FW_CFG_BOOT_MENU        0x0e
>  #define FW_CFG_MAX_CPUS         0x0f
> -#define FW_CFG_MAX_ENTRY        0x10
> -#define FW_CFG_MAX_RAM		0x11
> +#define FW_CFG_MAX_RAM		0x10
> +#define FW_CFG_MAX_ENTRY        0x11

That should hopefully also fix the problem with Clang that I've just seen:

 https://gitlab.com/huth/kvm-unit-tests/-/jobs/635782173#L1372

Reviewed-by: Thomas Huth <thuth@redhat.com>

