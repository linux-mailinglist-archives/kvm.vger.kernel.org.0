Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757341D9181
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 09:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbgESH6N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 03:58:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58483 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726943AbgESH6M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 03:58:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589875091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a4VuYgpozh5k2UbrW8UQBTZQVsj6kKrTwTGf6FkRTGs=;
        b=bbNGh2kgT189Adii9+5OQBE9tqQYhlnRDcgSY3YvOjlRjiclxklDymDilNWo3hRFlaeXy8
        SXcPSZohWjcYB0lCxC32Cf00Zy50r0ugmmbTmi0Uv8ktZs8OLFnPraqsbClvyztXQ3ZiT1
        hP9aEALyyrYhqTNrXyfW3J8TMpEif6w=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-WPHoRY7eNkq_rmM9tqZrUQ-1; Tue, 19 May 2020 03:58:09 -0400
X-MC-Unique: WPHoRY7eNkq_rmM9tqZrUQ-1
Received: by mail-wr1-f70.google.com with SMTP id 30so6885474wrq.15
        for <kvm@vger.kernel.org>; Tue, 19 May 2020 00:58:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=a4VuYgpozh5k2UbrW8UQBTZQVsj6kKrTwTGf6FkRTGs=;
        b=jcJ7LY/wVgFRoLtoe4OMRam3EzlNqDHIsnxinS02H9nE9Zer6nIqVOfkayU5yb3pCP
         WfnwQNwmmRxGj+5ClIjYSdKgXo2gNERAn35lpZFvtI4t1Zh7KgSFjoeAaNycTLRuAaLb
         5YYzlbcQfoivPfrwuIMNyOky7MFjc2/pb3IZHkoCV84z1o3IQiPJMKlbtvIXHN9rEBSD
         PdubMT2WPB9PRvMvrxIKzFpwOcqzIAxqbFGVn94m1HCScrMRFB8EWlTxj8//lScXPm3b
         SW5XfRVKgD+PuHuc7yIHRC+So40K5RcCB7omsRLlrxSY3w0UBXE5tVgdP4MT8Vu8Rpvx
         kweQ==
X-Gm-Message-State: AOAM532IuCIZ2YudJs+rP8TtJPVBC30aWIIz1vdd7tS1gnmuZtczOoSR
        Jxy+imMfwcgNiDqvzP84odXZs3TxxCynNvh/OKvUe8I5rpZhPmpTFQL1ECEFAFX9sETgXcDYEVB
        r3naaf6aVen7Y
X-Received: by 2002:a1c:81d0:: with SMTP id c199mr3722633wmd.125.1589875088194;
        Tue, 19 May 2020 00:58:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4zUWIr5Vf/tlEhDR0rq0R/jTKJhRvXHGdvGcm88dpkx7Sw27ojPyqT3C/AlRhCE4+C7dpxA==
X-Received: by 2002:a1c:81d0:: with SMTP id c199mr3722606wmd.125.1589875087928;
        Tue, 19 May 2020 00:58:07 -0700 (PDT)
Received: from steredhat (host108-207-dynamic.49-79-r.retail.telecomitalia.it. [79.49.207.108])
        by smtp.gmail.com with ESMTPSA id l19sm2876436wmj.14.2020.05.19.00.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 00:58:07 -0700 (PDT)
Date:   Tue, 19 May 2020 09:58:05 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Cc:     qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        qemu-arm@nongnu.org, Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH v2 4/7] hw/elf_ops: Do not ignore write failures when
 loading ELF
Message-ID: <20200519075805.tgrzbz2qscco5thh@steredhat>
References: <20200518155308.15851-1-f4bug@amsat.org>
 <20200518155308.15851-5-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200518155308.15851-5-f4bug@amsat.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 18, 2020 at 05:53:05PM +0200, Philippe Mathieu-Daudé wrote:
> Do not ignore the MemTxResult error type returned by
> address_space_write().
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  include/hw/elf_ops.h | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

> 
> diff --git a/include/hw/elf_ops.h b/include/hw/elf_ops.h
> index 398a4a2c85..6fdff3dced 100644
> --- a/include/hw/elf_ops.h
> +++ b/include/hw/elf_ops.h
> @@ -553,9 +553,14 @@ static int glue(load_elf, SZ)(const char *name, int fd,
>                      rom_add_elf_program(label, mapped_file, data, file_size,
>                                          mem_size, addr, as);
>                  } else {
> -                    address_space_write(as ? as : &address_space_memory,
> -                                        addr, MEMTXATTRS_UNSPECIFIED,
> -                                        data, file_size);
> +                    MemTxResult res;
> +
> +                    res = address_space_write(as ? as : &address_space_memory,
> +                                              addr, MEMTXATTRS_UNSPECIFIED,
> +                                              data, file_size);
> +                    if (res != MEMTX_OK) {
> +                        goto fail;
> +                    }
>                  }
>              }
>  
> -- 
> 2.21.3
> 

