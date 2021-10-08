Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8477426F33
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 18:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhJHQm1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 12:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbhJHQmT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 12:42:19 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A89C061755
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 09:40:23 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id qe4-20020a17090b4f8400b0019f663cfcd1so9796700pjb.1
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 09:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mUcY/9Xio5KlOC5vY2lc5GwaqZQNDlMOshNSxCHvCME=;
        b=OLMf5xzveKLvHzuCwEfGDRwq56nBPA75iXbZpcnVZ7XoZFSodHKSIYC+fpcTKQgbQI
         hd17TPLSAyXtP5Zkb3O8PyHm9M/Cm+oka0oViLVXxKrPGRriAjdll7OFdx4LZRM5tQii
         HXO3tbLwlnw1d/ZwS/S3cSf1Tm1m+ewNEXl3/GB2/Hd9P6CgQKpWYHuCuic+uv6387Dr
         NYC0Zu5/fpTPIJUMgORkoUNttSDpNoejmpKIs7N9nyNuBfL8JsXen3U/CRcSm/KNHite
         4Y59yV6A4zkX/SQq377YNDieT9XHmQ2RK/6wdgKDpIEWiIkWNE1UhNmc3FmUVTjxAsh+
         9Mjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mUcY/9Xio5KlOC5vY2lc5GwaqZQNDlMOshNSxCHvCME=;
        b=wrPjs3Aslps0jE+uajILJF8ScYlgq8f8Sh3ac1PVR7PX44IbiYwWXn/H4Tme9nf5va
         pEV1NngiLZI+VxfDXLbFEDbaQlEkdneDYUnMpCtfw4PZAPi6AVA6wtA659wdvn4//2O5
         hJIOeJihndiraOhdk0hLNESRfpQEo0jD5oKsW13V3XSfmb8bupvhXmojzkMR97zRxa/8
         6K90lOHPLtOgkKlEI7Z/m88nmHroSmmPRNPBiIY/boNBr3RV5LcOoeknztLWzCJzr/hg
         IZhO70iZYoI+B2TkbuX47dDqVS09DXKCvm8NfbaeR8TwvE8XPa6NzTLDFH7JlJZMrN/c
         pNvQ==
X-Gm-Message-State: AOAM530VmcuIqk83bjt9J5Tj79gmdLAC8cFMwRDSlaWI00MsButTyl/C
        EwxYad6KhIMskSbSvrfoM5IJFnZb7se8sA==
X-Google-Smtp-Source: ABdhPJzSgL0lhhT/arNmCAlNen9kKKqqC9t5n3HGp7xGO1VF17pol0024zkJlOKBgAJBgcIKcg1L9w==
X-Received: by 2002:a17:90a:bd08:: with SMTP id y8mr12547257pjr.123.1633711222587;
        Fri, 08 Oct 2021 09:40:22 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id p4sm3208658pgc.15.2021.10.08.09.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 09:40:22 -0700 (PDT)
Date:   Fri, 8 Oct 2021 09:40:18 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, lvivier@redhat.com, thuth@redhat.com
Subject: Re: [PATCH kvm-unit-tests] parse_keyval: Allow hex vals
Message-ID: <YWB0cgmSyLg3LmLe@google.com>
References: <20211008070309.84205-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211008070309.84205-1-drjones@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 08, 2021 at 09:03:09AM +0200, Andrew Jones wrote:
> When parse_keyval was first written we didn't yet have strtol.
> Now we do, let's give users more flexibility.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  lib/util.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/util.c b/lib/util.c
> index a90554138952..682ca2db09e6 100644
> --- a/lib/util.c
> +++ b/lib/util.c
> @@ -4,6 +4,7 @@
>   * This work is licensed under the terms of the GNU LGPL, version 2.
>   */
>  #include <libcflat.h>
> +#include <stdlib.h>
>  #include "util.h"
>  
>  int parse_keyval(char *s, long *val)
> @@ -14,6 +15,6 @@ int parse_keyval(char *s, long *val)
>  	if (!p)
>  		return -1;
>  
> -	*val = atol(p+1);
> +	*val = strtol(p+1, NULL, 0);
>  	return p - s;
>  }
> -- 
> 2.31.1
> 

Reviewed-by: Ricardo Koller <ricarkol@google.com>
