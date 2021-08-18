Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A22983F006A
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 11:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232484AbhHRJ3N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 05:29:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40164 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232123AbhHRJ3H (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Aug 2021 05:29:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629278913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ss0YteSxGieknf/N001L6Bbd+tVJgnRWWRu4Uer/1WI=;
        b=QKNU1oNzhYZg7M92aodDAEiNp7zZCrZUQZdl28ZE3Fc7GIAKf99/onGmaXCd+0aAKm2USP
        7SXMx4Tt43VaIQp+aLMafZoVP0RGHLpPisB8V7qMHU30aH4e631EfBrFmpO3soGAWZuimR
        Obln96FW5JByJcpW9OYpn7oepotS3q8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-516-XPpWU28pN1es-l1G-6n-AQ-1; Wed, 18 Aug 2021 05:28:32 -0400
X-MC-Unique: XPpWU28pN1es-l1G-6n-AQ-1
Received: by mail-ed1-f69.google.com with SMTP id eg56-20020a05640228b8b02903be79801f9aso713658edb.21
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 02:28:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ss0YteSxGieknf/N001L6Bbd+tVJgnRWWRu4Uer/1WI=;
        b=Yi1wCCUF/NWitd56Yb9MqaAANhSe/HddGyxBBGGgGoKVBEuS1VbwTpssWSqVNCgUFq
         /LeO/w0TV7HoWUOn77qcCsA3XJTkD5hY+EqsA1wYNhhOehR49TsZrZgUa3AZW8HJhlwj
         S3OX+XvlqMZ1JbhdXsyCy5LVDO3U4nED61F9rOt+tCFN7bCWIO8ehSUqCEKG0gFZH04I
         ObvIO6HympV+ZDdBwy1n76iiAFKpeLLsn8jIk3mUPJISQd/T6lR1B1OJ/a0fJRd6WL/n
         VAOiy1T6I9zALzzVexGRp2UBKYtbgcG3x27iDCynJgVo2x0mVEqrO4PyMI9t1eLp/6Ox
         y8vg==
X-Gm-Message-State: AOAM531R9aznzAM62MlZyLlfix0jtP/FpVVYosvY6iZog5cP8W/FgFVF
        QU/uauktGXzrqoEmJjT2KQ4uPu/idPxs+tA37+n9wnE6YOpiSVvOl+pp1k1f8NZ6vpXOwoSPCGW
        8jlZ98u6c9Vbr
X-Received: by 2002:a17:906:c249:: with SMTP id bl9mr8838937ejb.225.1629278910823;
        Wed, 18 Aug 2021 02:28:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy2i3IaJ6FUHdnF7ye+k0n1lpDd35whxOvMpbIkocaOGGDMWrn6gFBYEsKYZJiDIyide4gNYg==
X-Received: by 2002:a17:906:c249:: with SMTP id bl9mr8838930ejb.225.1629278910663;
        Wed, 18 Aug 2021 02:28:30 -0700 (PDT)
Received: from thuth.remote.csb (pd9e83070.dip0.t-ipconnect.de. [217.232.48.112])
        by smtp.gmail.com with ESMTPSA id l19sm2271962edq.62.2021.08.18.02.28.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 02:28:30 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 6/8] lib: s390x: Add PSW_MASK_64
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <20210813073615.32837-1-frankja@linux.ibm.com>
 <20210813073615.32837-7-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <76f5c0bb-6a28-c480-6b69-25056accb5b6@redhat.com>
Date:   Wed, 18 Aug 2021 11:28:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210813073615.32837-7-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/08/2021 09.36, Janosch Frank wrote:
> Let's replace the magic 0x0000000180000000ULL numeric constants with
> PSW_MASK_64 as it's used more often since the introduction of smp and
> sie.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   lib/s390x/asm/arch_def.h | 3 +++
>   lib/s390x/smp.c          | 2 +-
>   s390x/mvpg-sie.c         | 2 +-
>   s390x/sie.c              | 2 +-
>   s390x/skrf.c             | 6 +++---
>   5 files changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 39c5ba99..245453c3 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -50,6 +50,9 @@ struct psw {
>   #define PSW_MASK_DAT			0x0400000000000000UL
>   #define PSW_MASK_WAIT			0x0002000000000000UL
>   #define PSW_MASK_PSTATE			0x0001000000000000UL
> +#define PSW_MASK_EA			0x0000000100000000UL
> +#define PSW_MASK_BA			0x0000000080000000UL
> +#define PSW_MASK_64			PSW_MASK_BA | PSW_MASK_EA;

Please put some parentheses around PSW_MASK_BA | PSW_MASK_EA and remove the 
semicolon at the end.

  Thomas

