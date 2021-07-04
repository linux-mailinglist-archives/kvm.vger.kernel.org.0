Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF0773BABE3
	for <lists+kvm@lfdr.de>; Sun,  4 Jul 2021 09:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbhGDHua (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Jul 2021 03:50:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33182 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229532AbhGDHu3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 4 Jul 2021 03:50:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625384874;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q2QZWUksOoTjx73EYiROtjmd+mxZplTS5TZg9mRj4g0=;
        b=GVxb6AFApVPLxNCx8SX3dsZd+cDbOSE6kMI2j31XL5F/K8+JbOmpHwDJSCUBPX86OyTtf/
        bcJfJekVPN8Q9dOm6NxMnqubBRVNJ1rT95B6sdba0oxZ+CbPkB0gdny2e7OeKqyyq/Bd7j
        40roePpAgV6WxW1L3h4AjGNzKHZbUZU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-gsRDcloLM3qgKmw-J-iSYA-1; Sun, 04 Jul 2021 03:47:53 -0400
X-MC-Unique: gsRDcloLM3qgKmw-J-iSYA-1
Received: by mail-wr1-f69.google.com with SMTP id e13-20020a5d530d0000b0290126d989c76eso5361232wrv.18
        for <kvm@vger.kernel.org>; Sun, 04 Jul 2021 00:47:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q2QZWUksOoTjx73EYiROtjmd+mxZplTS5TZg9mRj4g0=;
        b=jWL8bWL6xsTE8ezIh1tMGtvLUhp2SZO4xz5YzffkiWcDDLQNP/SXT2uIad3roarxjh
         uljpuMOBStlM4F459qWpNSrqS9CjacGhy49YWNNX3kSzatfaoFArWi/Fjw5EmN3HYytO
         GKwNSaaKgjUuTH5JGHIZMCaCNwHBYuQcyZAGJAorAe6RLUwfrtiqSxaNXRoi7Ude/yJG
         PjUMu+y/mtMxQM0U34qjPuLdTUEzyX8jltoUjY63TDAGO9+XQHl0ENSSCgRNmsj3ycvW
         YI9fDb0q0pkm1/oTssAoZmWAG5Z1N8b5vrBB8tC3uA/D1PZQraNdSvObnmbhA7FeUymX
         bB4Q==
X-Gm-Message-State: AOAM530Nup9rzJYVQe0T4rflFIIcZ2TyAHAFvoM7x8y9gBUrUvb2A3mE
        t6HgiJvu3gy2t8etQ3qSUL58SOl+pnddfkOgD8M7r1BCY2HczzlqF8gXcQItk5LNtW5STvHczQL
        SDEOtaENEhpZC
X-Received: by 2002:a5d:4107:: with SMTP id l7mr9047891wrp.16.1625384872152;
        Sun, 04 Jul 2021 00:47:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyEkaoLKqVQpoHqg0xR5+a4fuPkf+KKWvPySuhByQzTCUMeuUQNKUB3BDYiHo3dPiqVOznI5Q==
X-Received: by 2002:a5d:4107:: with SMTP id l7mr9047862wrp.16.1625384871907;
        Sun, 04 Jul 2021 00:47:51 -0700 (PDT)
Received: from thuth.remote.csb (p5791d89b.dip0.t-ipconnect.de. [87.145.216.155])
        by smtp.gmail.com with ESMTPSA id a9sm8750588wrv.37.2021.07.04.00.47.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Jul 2021 00:47:51 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 1/5] s390x: sie: Add missing includes
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <20210629133322.19193-1-frankja@linux.ibm.com>
 <20210629133322.19193-2-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <1fdf3f12-987f-7452-0f72-ef2999c218cb@redhat.com>
Date:   Sun, 4 Jul 2021 09:47:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210629133322.19193-2-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/06/2021 15.33, Janosch Frank wrote:
> arch_def.h is needed for struct psw.
> stdint.h is needed for the uint*_t types.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   lib/s390x/sie.h | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
> index db30d61..b4bb78c 100644
> --- a/lib/s390x/sie.h
> +++ b/lib/s390x/sie.h
> @@ -2,6 +2,9 @@
>   #ifndef _S390X_SIE_H_
>   #define _S390X_SIE_H_
>   
> +#include <stdint.h>
> +#include <asm/arch_def.h>
> +
>   #define CPUSTAT_STOPPED    0x80000000
>   #define CPUSTAT_WAIT       0x10000000
>   #define CPUSTAT_ECALL_PEND 0x08000000
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

