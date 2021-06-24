Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09203B3367
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 18:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbhFXQE6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 12:04:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37566 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229445AbhFXQE6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Jun 2021 12:04:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624550558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wh7FfFRwRKHmN3Jxy+axdn4aGV5vraFn3lggiq8SLBQ=;
        b=gx7hrOX7nQa35+jfe6xggBdBiBuBOelYAhDMIRrmalaTmpaV1OLP0KbfHAAwSw4gtZjx27
        pK12m+e3w7BJNf9T00dUvhDeQU903Qp2Oz4AoYHhtKPTn5GiZ4vsYKaO3HQMWTeu9a8XbV
        zHfdByQOnR/sTdoXkvuPVZlLDPuZtF4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-545-SIIykAm1NUK9g6hFvy2-OA-1; Thu, 24 Jun 2021 12:02:34 -0400
X-MC-Unique: SIIykAm1NUK9g6hFvy2-OA-1
Received: by mail-wr1-f72.google.com with SMTP id h104-20020adf90710000b029010de8455a3aso2361043wrh.12
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 09:02:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wh7FfFRwRKHmN3Jxy+axdn4aGV5vraFn3lggiq8SLBQ=;
        b=qkVWXP5OBqCo6qFj+uDuva9BchWx8daZL2lSDgNN2q9Yy9GIMx7f+9to5lqjcp7Mb8
         BrLe+YfuDV+ZCdNoeeeAiZ0eABjxWBH2Gd1X/seimfj9760jVQXj0vVVyAz+gx/weHEv
         4iJ4CMTVcw24dshw0TK+Ys5zDs+m9LNrYdP2XuhW1Yok98/fMugb0gA+qZa2HnWurIbN
         jTRwFgiYaSecQvt/V2C8dqrucb66kK4ZyG0y/9btitmaPEK4l1Ut4uyW/4+PA51LTxZg
         FTDQyXK08D3YuNySK0QWCXdyWowOvCjoXX8Pr2M9qGP+cgEbMud8v5NomP0wJTlpQ+z/
         YKTw==
X-Gm-Message-State: AOAM533PkqQn5CRlEI7JtzyHBvPB07qcW021NVKSJ+ynt/xm5aAniA7v
        aIvoOwCVMjVigCfjWIS+WSZ8a8IaDixQ6tWz204lY21u6AYUEYq+sCKApwR19l/8hREcZRacpbC
        9Q8yNxhSlaFuV
X-Received: by 2002:a5d:5707:: with SMTP id a7mr5303698wrv.179.1624550553568;
        Thu, 24 Jun 2021 09:02:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy/pd3hiplPxW791gJrORcjSNaz63eFXt+17jMtoK/Oz8zj5tSYzneHn7H1zU/vLGPcmtjB2g==
X-Received: by 2002:a5d:5707:: with SMTP id a7mr5303662wrv.179.1624550553317;
        Thu, 24 Jun 2021 09:02:33 -0700 (PDT)
Received: from thuth.remote.csb (pd9575c8c.dip0.t-ipconnect.de. [217.87.92.140])
        by smtp.gmail.com with ESMTPSA id b9sm3662980wrt.55.2021.06.24.09.02.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 09:02:32 -0700 (PDT)
Subject: Re: [PATCH 2/3] s390x: snippets: Add snippet compilation
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, seiden@linux.ibm.com
References: <20210624120152.344009-1-frankja@linux.ibm.com>
 <20210624120152.344009-3-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <d54552af-4694-638f-9100-e7ba720febfa@redhat.com>
Date:   Thu, 24 Jun 2021 18:02:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210624120152.344009-3-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/06/2021 14.01, Janosch Frank wrote:
> From: Steffen Eiden <seiden@linux.ibm.com>
> 
> This patch provides the necessary make targets to properly compile
> snippets and link them into their associated host.
> 
> To define the guest-host definition, we use the make-feature
> `SECONDEXPANSION` in combination with `Target specific Variable
> Values`. The variable `snippets` has different values depending on the
> current target. This enables us to define which snippets (=guests)
> belong to which hosts. Furthermore, using the second-expansion, we can
> use `snippets` in the perquisites of the host's `%.elf` rule, which
> otherwise would be not set.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
> ---
>   s390x/Makefile | 27 +++++++++++++++++++++------
>   1 file changed, 21 insertions(+), 6 deletions(-)
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 8820e99..ba32f4c 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -76,11 +76,26 @@ OBJDIRS += lib/s390x
>   asmlib = $(TEST_DIR)/cstart64.o $(TEST_DIR)/cpu.o
>   
>   FLATLIBS = $(libcflat)
> -%.elf: %.o $(FLATLIBS) $(SRCDIR)/s390x/flat.lds $(asmlib)
> -	$(CC) $(CFLAGS) -c -o $(@:.elf=.aux.o) \
> -		$(SRCDIR)/lib/auxinfo.c -DPROGNAME=\"$@\"
> -	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/flat.lds \
> -		$(filter %.o, $^) $(FLATLIBS) $(@:.elf=.aux.o)
> +
> +SNIPPET_DIR = $(TEST_DIR)/snippets
> +snippet_asmlib = $(SNIPPET_DIR)/c/cstart.o
> +
> +# perquisites (=guests) for the snippet hosts.
> +# $(TEST_DIR)/<snippet-host>.elf: snippets = $(SNIPPET_DIR)/<c/asm>/<snippet>.gbin
> +
> +$(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o $(FLATLIBS)
> +	$(OBJCOPY) -O binary $(patsubst %.gbin,%.o,$@) $@
> +	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $@ $@
> +
> +$(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_asmlib) $(FLATLIBS)
> +	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/c/flat.lds $(patsubst %.gbin,%.o,$@) $(snippet_asmlib) $(FLATLIBS)
> +	$(OBJCOPY) -O binary $@ $@
> +	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $@ $@
> +
> +.SECONDEXPANSION:
> +%.elf: $$(snippets) %.o $(FLATLIBS) $(SRCDIR)/s390x/flat.lds $(asmlib)
> +	$(CC) $(CFLAGS) -c -o $(@:.elf=.aux.o) $(SRCDIR)/lib/auxinfo.c -DPROGNAME=\"$@\"
> +	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/flat.lds $(filter %.o, $^) $(FLATLIBS) $(snippets) $(@:.elf=.aux.o)

Wow, weird Makefile magic, never seend that before ... but it sounds 
reasonable, so:

Acked-by: Thomas Huth <thuth@redhat.com>

