Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2CD339D920
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 11:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbhFGJ4e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 05:56:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55640 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230193AbhFGJ4e (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Jun 2021 05:56:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623059683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O+yk1vvk5M6nhVZdAiIPxD5S8BSa4ot0LAY3Z3zK7nU=;
        b=ZDWxE9fab6LjhRd/nFUTTkDs2sZooRWgTcGj87dBWeKFacm6Vf89dQ8FIWlVFjHwYKBRaq
        MF0A3y6+ixJI8+f643sp/+omRJFxcbbsRzr3C0UZS0Yy0fhOfPkCSMBNKnLAJzwrTefErq
        U7rmHSzeskAe4DCP9InbhGrwP73l/Dg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-5PtZqskvP-6ec62du9L4fw-1; Mon, 07 Jun 2021 05:54:41 -0400
X-MC-Unique: 5PtZqskvP-6ec62du9L4fw-1
Received: by mail-wm1-f69.google.com with SMTP id v2-20020a7bcb420000b0290146b609814dso3926432wmj.0
        for <kvm@vger.kernel.org>; Mon, 07 Jun 2021 02:54:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O+yk1vvk5M6nhVZdAiIPxD5S8BSa4ot0LAY3Z3zK7nU=;
        b=fYDHOonuFGzV0R6J8kK/q3qvnJBn30kT9hPE5Frymnr6jmv7L1cUX94H+W8erprDun
         HW9nAlGnzFR22KCm4uQkmiwY2K4Wd1Bllw2csD3YFuqcasr1vMYQCrcIm1NZc/5VOaOJ
         X2H1SET8cIUorW3VuBHnD/BxQM5T2LLS99IUYccA1Hn8Stw7OeKXmON8eav9uIrOeFL2
         07A6/72RePhQEdv7mcJsiN73Uace7c6cmbnt2aBK/IgAfPm4mHqRzXB1EAA4yYA9GFoF
         fi1MSS6uVA9aIVVIfy7/GpyiEkBl754/HFO5CEUBhi8y58vtrFowX2Zms7+x4eYMgH6K
         FVLg==
X-Gm-Message-State: AOAM530idu5GN3mJqF+zL9OukxhizI3VlJSLh2toIwJ9lqhKM9YZEeGY
        Pl/d+JDIeVsWQKgg92JV4g8ijkM44Hel/a6Gbv3xtQ2Yj08QBSfuh4P9H3GPu+SpZfKZ4nuHam0
        eR+xtKzofi+Si
X-Received: by 2002:a5d:6209:: with SMTP id y9mr16442460wru.50.1623059680649;
        Mon, 07 Jun 2021 02:54:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy9eylN+klntKzHATJtBRS8zVzE0zWce3VnkSPto195bZq5iNDaPkxRVPjHm7PqvpVLUDgAfg==
X-Received: by 2002:a5d:6209:: with SMTP id y9mr16442451wru.50.1623059680525;
        Mon, 07 Jun 2021 02:54:40 -0700 (PDT)
Received: from thuth.remote.csb (pd957536e.dip0.t-ipconnect.de. [217.87.83.110])
        by smtp.gmail.com with ESMTPSA id m37sm7765719wms.46.2021.06.07.02.54.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jun 2021 02:54:40 -0700 (PDT)
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20210318125015.45502-1-frankja@linux.ibm.com>
 <20210318125015.45502-4-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 3/3] s390x: run: Skip PV tests when tcg is
 the accelerator
Message-ID: <92be69b9-227a-d01c-6877-738a4482b8c6@redhat.com>
Date:   Mon, 7 Jun 2021 11:54:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210318125015.45502-4-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/03/2021 13.50, Janosch Frank wrote:
> TCG doesn't support PV.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   s390x/run | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/s390x/run b/s390x/run
> index df7ef5ca..82922701 100755
> --- a/s390x/run
> +++ b/s390x/run
> @@ -19,6 +19,11 @@ else
>       ACCEL=$DEF_ACCEL
>   fi
>   
> +if [ "${1: -7}" == ".pv.bin" ] || [ "${TESTNAME: -3}" == "_PV" ] && [ $ACCEL == "tcg" ]; then

Put $ACCEL in quotes?

With that nit fixed:

Reviewed-by: Thomas Huth <thuth@redhat.com>


> +	echo "Protected Virtualization isn't supported under TCG"
> +	exit 2
> +fi
> +
>   M='-machine s390-ccw-virtio'
>   M+=",accel=$ACCEL"
>   command="$qemu -nodefaults -nographic $M"
> 

