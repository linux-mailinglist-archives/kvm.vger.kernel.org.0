Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59C24425048
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 11:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234934AbhJGJqK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 05:46:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:49305 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230389AbhJGJqJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 05:46:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633599856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VplPmaU1StyYkGRWpkJjJq1VIPPWnfQsc4epwDxxEuo=;
        b=CK31Y+DPTbZFhLDHAS9FjiXwDK5MQd7yPg2gqRsapKKhdbJqJs8QuLxYS4hIvm8/1g9mrF
        2vNxRpFZyQxgXjuN9sS81kONz0NmllAD7bVx268ygrbqgw064yVQkA9aKUbUB8xS2x1rNk
        8Zj6lXHuYcGJ5k9th+09a8q2TdrTPT8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-iqx7ov2NOZuTrsqjsFfoAQ-1; Thu, 07 Oct 2021 05:44:13 -0400
X-MC-Unique: iqx7ov2NOZuTrsqjsFfoAQ-1
Received: by mail-wr1-f70.google.com with SMTP id k2-20020adfc702000000b0016006b2da9bso4218043wrg.1
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 02:44:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VplPmaU1StyYkGRWpkJjJq1VIPPWnfQsc4epwDxxEuo=;
        b=F8Vx439AknCEKgn1/u93QcXIcSz1tU7s8tcjoktRTE/Y3P/LNoyMSpWts05yNUIm9t
         I6Ag08Np2Lz76V+tKpNn2HpeBoyTzOzHlih6je3sNe+DNCLDV+3ROALKBTNGtbeTsuLI
         Wap2QRO4W0Dt5R/4AevAbEuuGsiL+kqje85elGMI70kREjoyLUh4vrTo+KUTKRmmZNCD
         NlHKSGfGLtQ6i/UONuhQcsZkoVy8BMzrldFxfuQY3ML8acqmi4IqDV0wdjC57arRwmRh
         +d6l6a8VgMUzW7LNjhCAPE/hrU8zFLZJ7V7HadhHjJsMifYIK7M8Rh6gHqyP/pGkkkBu
         T82A==
X-Gm-Message-State: AOAM532zx+69gzP/BGTCt04lIbR4UqN2IH1FzGl0XSGlvc1BZqaWM0RL
        /UDrdaFBoeKyohZ07D25VR+8kuHDLpLA0JWepcijdpN3nmYy1oHdW/b8M65TMNC9lcPNSPRCYry
        xe0X9Bh0KVscN
X-Received: by 2002:a5d:64e2:: with SMTP id g2mr4122486wri.323.1633599851969;
        Thu, 07 Oct 2021 02:44:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwEDcmyCCv6xjzDl/4mg+qgjtqTYB/OD3bV0KHCrlyvddXBUAlb0Yt/JRJesHR+wS+XbBcS/A==
X-Received: by 2002:a5d:64e2:: with SMTP id g2mr4122457wri.323.1633599851746;
        Thu, 07 Oct 2021 02:44:11 -0700 (PDT)
Received: from thuth.remote.csb (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id q3sm7526264wmc.25.2021.10.07.02.44.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Oct 2021 02:44:11 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v3 9/9] s390x: snippets: Define all things
 that are needed to link the lib
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, seiden@linux.ibm.com, scgl@linux.ibm.com
References: <20211007085027.13050-1-frankja@linux.ibm.com>
 <20211007085027.13050-10-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <c3bed287-5c4c-a54b-4276-391c6cdb37f4@redhat.com>
Date:   Thu, 7 Oct 2021 11:44:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211007085027.13050-10-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/10/2021 10.50, Janosch Frank wrote:
> Let's just define all of the needed things so we can link libcflat.
> 
> A significant portion of the lib won't work, like printing and
> allocation but we can still use things like memset() which already
> improves our lives significantly.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   s390x/snippets/c/cstart.S | 14 ++++++++++++++
>   1 file changed, 14 insertions(+)
> 
> diff --git a/s390x/snippets/c/cstart.S b/s390x/snippets/c/cstart.S
> index 031a6b83..2d397669 100644
> --- a/s390x/snippets/c/cstart.S
> +++ b/s390x/snippets/c/cstart.S
> @@ -20,6 +20,20 @@ start:
>   	lghi	%r15, stackptr
>   	sam64
>   	brasl	%r14, main
> +/*
> + * Defining things that the linker needs to link in libcflat and make
> + * them result in sigp stop if called.
> + */
> +.globl sie_exit
> +.globl sie_entry
> +.globl smp_cpu_setup_state
> +.globl ipl_args
> +.globl auxinfo
> +sie_exit:
> +sie_entry:
> +smp_cpu_setup_state:
> +ipl_args:
> +auxinfo:

I think this likely could be done in a somewhat nicer way, e.g. by moving 
mem_init() and sclp_memory_setup() into a separate .c file in the lib, and 
by moving expect_pgm_int(), fixup_pgm_int() and friends into another 
separate .c file, too, so that we e.g. do not need to link against the code 
that uses sie_entry and sie_exit ... but that's a major rework on its own, 
so for the time being:

Acked-by: Thomas Huth <thuth@redhat.com>

