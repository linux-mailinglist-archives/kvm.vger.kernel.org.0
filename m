Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57868420715
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 10:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbhJDIO0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 04:14:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36779 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230175AbhJDIO0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 04:14:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633335157;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e0UHtQzp8oujg3rZsnhle2eR7E5p5dl5+wOwIQeKhoo=;
        b=jIrtiBbJZcvv+7U4qXiKDzVOxoNj/mnqacoVkBCSdio/rwRbxX5no953HxS1gjU/ocQ7WL
        K1s2i9ZAsRpEjlEXZ/qCiqmJF7du+ZMb7LEb0DvwpcOYsMz0NJacyeRMIctBe0EwN2xY2J
        jyqeT8FDYwDPqUFEq+zVcf8lZ99oJy4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-MPaTfX51O5633gwGUv9gxg-1; Mon, 04 Oct 2021 04:12:36 -0400
X-MC-Unique: MPaTfX51O5633gwGUv9gxg-1
Received: by mail-ed1-f70.google.com with SMTP id 1-20020a508741000000b003da559ba1eeso16460788edv.13
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 01:12:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=e0UHtQzp8oujg3rZsnhle2eR7E5p5dl5+wOwIQeKhoo=;
        b=rqvCn9et7BxM0//Hp90oZCIpTKzl+4tW60zn03r1sCQJ6Irl2sPZv6OJcWgJKWHq23
         c6fxlNWXOqBfaDFvChjnxoilK5JSlexmhwGlF9dAAH19ACjbkzIyWFFC2qA7wEc10DwT
         +zGTNtkDxtpUiwHwUKodIkz18ixn13NoRBreuVpaY4/v6ubHl9/fC1MdJyjE350C2FjM
         YY3jlVSygUMAzZMKRYlMuKJvbM3wElZtUcYvLV3T75kpgvy9ovE58F7rrk2lLjl56mBn
         UvO72TOqbariZACnDswdLUOQVFwJvBF7sE2dDHleZwa6y+I1RYsl14sN6xA829oqluzi
         RF2w==
X-Gm-Message-State: AOAM5301uU1yhsqkx2Au90gaTm1yfw74WXKz6XSXhXGGy2W+SybZkUbt
        SEGXBVqGxgijQN+NN6/sFKAgGIK5PeUa0CnLzEz1hRQjHCgaf7BhTd1qHsjY4S30q1ZgOkptgWQ
        BQm1d7ZkHwvlD
X-Received: by 2002:a05:6402:450:: with SMTP id p16mr16403664edw.162.1633335155219;
        Mon, 04 Oct 2021 01:12:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJznX5n3F5L83hX4XCbBgkS3HW4SPDb/COrH2fP1mwdhedrepAo6IAJoi1jkNUJ4mstKAYwRHQ==
X-Received: by 2002:a05:6402:450:: with SMTP id p16mr16403642edw.162.1633335154995;
        Mon, 04 Oct 2021 01:12:34 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q6sm6033517ejm.106.2021.10.04.01.12.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 01:12:34 -0700 (PDT)
Message-ID: <0890d543-1c65-2594-cbdb-17ae05c2af02@redhat.com>
Date:   Mon, 4 Oct 2021 10:12:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 09/22] target/i386/sev: Mark unreachable code with
 g_assert_not_reached()
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org,
        Sergio Lopez <slp@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        "Daniel P . Berrange" <berrange@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>
References: <20211002125317.3418648-1-philmd@redhat.com>
 <20211002125317.3418648-10-philmd@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211002125317.3418648-10-philmd@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/10/21 14:53, Philippe Mathieu-Daudé wrote:
> The unique sev_encrypt_flash() invocation (in pc_system_flash_map)
> is protected by the "if (sev_enabled())" check, so is not
> reacheable.
> Replace the abort() call in sev_es_save_reset_vector() by
> g_assert_not_reached() which meaning is clearer.
> 
> Reviewed-by: Connor Kuehl <ckuehl@redhat.com>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>   target/i386/sev-stub.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/target/i386/sev-stub.c b/target/i386/sev-stub.c
> index eb0c89bf2be..4668365fd3e 100644
> --- a/target/i386/sev-stub.c
> +++ b/target/i386/sev-stub.c
> @@ -54,7 +54,7 @@ int sev_inject_launch_secret(const char *hdr, const char *secret,
>   
>   int sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp)
>   {
> -    return 0;
> +    g_assert_not_reached();
>   }
>   
>   bool sev_es_enabled(void)
> @@ -68,7 +68,7 @@ void sev_es_set_reset_vector(CPUState *cpu)
>   
>   int sev_es_save_reset_vector(void *flash_ptr, uint64_t flash_size)
>   {
> -    abort();
> +    g_assert_not_reached();
>   }
>   
>   SevAttestationReport *
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

