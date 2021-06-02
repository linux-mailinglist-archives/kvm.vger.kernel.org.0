Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A7F397FC1
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 05:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhFBD6e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 23:58:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24129 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229726AbhFBD6e (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Jun 2021 23:58:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622606211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uA3eZjb5JJ8NaO9JVvpGUQyJtR4AB1k+URnb80+XFJY=;
        b=hhLAJ4lKnJRe3dF62b+r3jDBaCgy0JtGqMagGGVbTPYPF/uP+H1wL1wH8me4tmFsen1ZrU
        OPcYA+jWrpkLsp2UEz2N/mlpngMVV2CZ8dsEx2fVMmnwMIJ9x+96PpUB7Kk94FHimqcFjZ
        4gqpLBonMgf9peyXswBpNTtxGjlkkHY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-gm57F5jLNAmdzti0fVoObA-1; Tue, 01 Jun 2021 23:56:50 -0400
X-MC-Unique: gm57F5jLNAmdzti0fVoObA-1
Received: by mail-wr1-f71.google.com with SMTP id i102-20020adf90ef0000b029010dfcfc46c0so450410wri.1
        for <kvm@vger.kernel.org>; Tue, 01 Jun 2021 20:56:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uA3eZjb5JJ8NaO9JVvpGUQyJtR4AB1k+URnb80+XFJY=;
        b=lRyajbkWpNvNpoTOW/Und7uMGjwU+44O5e0udAlTYR22gEMcJPoBbhqqL6Uq6bA23j
         JNxBkr1SA/Qb3RU7GV6T0P6C74WSXmv9Lw6GIuTcVn4xrl9n9GSlpBPHMc9AIOJlGNCk
         wXzmjgBPrfVQKR3cv2fyxQMlYzaBWqunfNfQZ6GNUJu38RyCFDky3QFrtnpzRmjiTfJn
         SxsnQAso6YPZ/wq+CB7Ug7G2b2yIhkT3/9vCsLneQ4Vnn+lyj1e6YSJOwPy8aXsw3v56
         un2Fi9J2dncbpwXyLzodxGX/UwZXG/tVx/Zn9yMKlMqn71Xf0vUtIt5McrM33Btoe0Lw
         /h5Q==
X-Gm-Message-State: AOAM530+8T7ckumq61lv+f9qaATNTpWPDP/FlQwNmf8oDErJpicqUAzA
        LedKNnMoiroArdYU9ZL49Ur63p9TbbiLHKEc5USq6eXBHlgZSJHLnt9A3wYOKNDNa9TK8up9zLj
        3S+UDasx1LLZ4
X-Received: by 2002:adf:8b09:: with SMTP id n9mr31493147wra.148.1622606208915;
        Tue, 01 Jun 2021 20:56:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxMNoHgl1EXVxoMuGKWjdrCSXO4mnIAzucixAqL6J0PgNUUwb9gvq2fHxVxdSBMtWVy8sB0fg==
X-Received: by 2002:adf:8b09:: with SMTP id n9mr31493134wra.148.1622606208707;
        Tue, 01 Jun 2021 20:56:48 -0700 (PDT)
Received: from thuth.remote.csb (p5791de31.dip0.t-ipconnect.de. [87.145.222.49])
        by smtp.gmail.com with ESMTPSA id 125sm1221530wmb.34.2021.06.01.20.56.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jun 2021 20:56:48 -0700 (PDT)
To:     Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>
References: <20210601161525.462315-1-cohuck@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] s390x: unify header guards
Message-ID: <d87b32d6-1d41-1413-96c6-0d6b2361b079@redhat.com>
Date:   Wed, 2 Jun 2021 05:56:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210601161525.462315-1-cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/06/2021 18.15, Cornelia Huck wrote:
> Let's unify the header guards to _ASM_S390X_FILE_H_ respectively
> _S390X_FILE_H_. This makes it more obvious what the file is
> about, and avoids possible name space collisions.
> 
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
> 
> Only did s390x for now; the other archs seem to be inconsistent in
> places as well, and I can also try to tackle them if it makes sense.
...
> diff --git a/lib/s390x/asm/bitops.h b/lib/s390x/asm/bitops.h
> index 792881ec3249..61cd38fd36b7 100644
> --- a/lib/s390x/asm/bitops.h
> +++ b/lib/s390x/asm/bitops.h
> @@ -8,8 +8,8 @@
>    *    Author(s): Martin Schwidefsky <schwidefsky@de.ibm.com>,
>    *
>    */
> -#ifndef _ASMS390X_BITOPS_H_
> -#define _ASMS390X_BITOPS_H_
> +#ifndef _ASM_S390X_BITOPS_H_
> +#define _ASM_S390X_BITOPS_H_

Why not the other way round (S390X_ASM_BITOPS_H) ?

 > diff --git a/s390x/sthyi.h b/s390x/sthyi.h
 > index bbd74c6197c3..eb92fdd2f2b2 100644
 > --- a/s390x/sthyi.h
 > +++ b/s390x/sthyi.h
 > @@ -7,8 +7,8 @@
 >   * Authors:
 >   *    Janosch Frank <frankja@linux.vnet.ibm.com>
 >   */
 > -#ifndef _STHYI_H_
 > -#define _STHYI_H_
 > +#ifndef _S390X_STHYI_H_
 > +#define _S390X_STHYI_H_

While we're at it: Do we also want to drop the leading (and trailing) 
underscores here? ... since leading underscore followed by a capital letter 
is a reserved namespace in C and you should normally not use these in nice 
programs...? I think I'm ok with keeping the underscores in the files in the 
lib folder (since these are our core libraries, similar to the system and 
libc headers on a normal system), but in files that are not part of the lib 
folder, we should rather avoid them.

  Thomas

