Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43FF3BABE5
	for <lists+kvm@lfdr.de>; Sun,  4 Jul 2021 09:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbhGDHyV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Jul 2021 03:54:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44312 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229492AbhGDHyU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 4 Jul 2021 03:54:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625385105;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wFeANVjBL3oUSMOrf3SAKuL3KkWOGgb1KQrWoBxR6aQ=;
        b=AX3hYXlXVcbG54k5R0E2nP9nWFQxln4LRhhIB8mQw/4z4TpqsgTpUdurkWXxxaeMlB3N6m
        0W0xp1w2cg5dRa9lYwgY8CEDGD9hijocPAubMYxrHgYlchHJyLUW6HTxhJUv25B4Lkc//e
        OOst/F4HQ0YtQizxJ+KRkeChEJWHb1g=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-4BQSIj_ZOkOHFEp_6qIhfg-1; Sun, 04 Jul 2021 03:51:42 -0400
X-MC-Unique: 4BQSIj_ZOkOHFEp_6qIhfg-1
Received: by mail-wm1-f71.google.com with SMTP id z127-20020a1c7e850000b02901e46e4d52c0so8184681wmc.6
        for <kvm@vger.kernel.org>; Sun, 04 Jul 2021 00:51:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wFeANVjBL3oUSMOrf3SAKuL3KkWOGgb1KQrWoBxR6aQ=;
        b=G2gJvRCoPbmxiMMkWUYSYYXdUMd5Sal/To1pnykQlTXOtmsYqULTn2Ird1Q1/Y0ZXH
         Hkeyvm0T75mMrqOGngDrqxCkjiTCTReV+jyYKXZn8ShpEo25AS/+H0Pjnh5ug52cnE05
         e4rvQI4kbCZiwmf6X+2ZFFO3jfk13+alUnUfLaxj71cSuKdIwqd32K+WrGflsE/i+t5B
         uoHIHGle6GHuhxV8EJMc2STweTHMx8yYFgGcl5Ay8fWZjE1lNbGcomyKg5l8YS3yof+p
         CNNkbhqcsB3kB+oHcE8Vtp66Dqw3i94ryU6IhnCPKsGPzakWXJNLlB2lIIB6yKqxNHm8
         +1HQ==
X-Gm-Message-State: AOAM531FgL8UbJnck578t4bN8s87z8NAF+cMkpQKGwncMxwqdeHCZilB
        6cscLY2qbEHj/1aIeynlryYQAA5m5rWDJ1bXFxeSuJjn2rQBDMfu/h+mxToapClsioBy8dOJrRe
        +8OaGvoDjTinC
X-Received: by 2002:a5d:4f02:: with SMTP id c2mr9010907wru.229.1625385101004;
        Sun, 04 Jul 2021 00:51:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyYk520209EH2QolTz3Mrr1WNyunXDavMaqdnxg9rca1IBxuGO+U/S3ZzwKrAOcI+hQkkVFNQ==
X-Received: by 2002:a5d:4f02:: with SMTP id c2mr9010899wru.229.1625385100868;
        Sun, 04 Jul 2021 00:51:40 -0700 (PDT)
Received: from thuth.remote.csb (p5791d89b.dip0.t-ipconnect.de. [87.145.216.155])
        by smtp.gmail.com with ESMTPSA id w9sm8531985wmc.19.2021.07.04.00.51.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Jul 2021 00:51:40 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 3/5] lib: s390x: uv: Int type cleanup
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <20210629133322.19193-1-frankja@linux.ibm.com>
 <20210629133322.19193-4-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <d2798bf7-3018-e311-1dfb-120144fb343d@redhat.com>
Date:   Sun, 4 Jul 2021 09:51:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210629133322.19193-4-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/06/2021 15.33, Janosch Frank wrote:
> These structs have largely been copied from the kernel so they still
> have the old uint short types which we want to avoid in favor of the
> uint*_t ones.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   lib/s390x/asm/uv.h | 142 +++++++++++++++++++++++----------------------
>   1 file changed, 72 insertions(+), 70 deletions(-)
> 
> diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
> index dc3e02d..96a2a7e 100644
> --- a/lib/s390x/asm/uv.h
> +++ b/lib/s390x/asm/uv.h
> @@ -12,6 +12,8 @@
>   #ifndef _ASMS390X_UV_H_
>   #define _ASMS390X_UV_H_
>   
> +#include <stdint.h>
> +
>   #define UVC_RC_EXECUTED		0x0001
>   #define UVC_RC_INV_CMD		0x0002
>   #define UVC_RC_INV_STATE	0x0003
> @@ -68,73 +70,73 @@ enum uv_cmds_inst {
>   };
>   
>   struct uv_cb_header {
> -	u16 len;
> -	u16 cmd;	/* Command Code */
> -	u16 rc;		/* Response Code */
> -	u16 rrc;	/* Return Reason Code */
> +	uint16_t len;
> +	uint16_t cmd;	/* Command Code */
> +	uint16_t rc;	/* Response Code */
> +	uint16_t rrc;	/* Return Reason Code */
>   } __attribute__((packed))  __attribute__((aligned(8)));

Hmm, for files that are more or less a copy from the corresponding kernel 
header, I'm not sure whether it makes sense to convert them to the stdint.h 
types? It might be better to keep the kernel types so that updates to this 
header can be ported more easily to the kvm-unit-tests later?

  Thomas

