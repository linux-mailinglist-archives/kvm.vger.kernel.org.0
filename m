Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82EE542070E
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 10:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbhJDINQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 04:13:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43062 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230517AbhJDINO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 04:13:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633335085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/v8IuUJOxdE99igoHOKSTqfou1Z3pZ41LzbF7lclFns=;
        b=O6l2+SCSjf/N7CSXnN9KkM+2neCN1Z5reIiAt+eRixIqeY6I0uYYqT/+YihxHPAI/gnrRH
        oxSO5blk44XSm4Oyae4K2E7By85XoSjrnMmGE7AYawyEm14XasXy14o3dZf4QbaZKuhbyt
        wTmMhs6dXfD+FBL3cO+L6gvDFwq0XOg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-565-LnC5ymG0Oby0Q31tXSh7AQ-1; Mon, 04 Oct 2021 04:11:24 -0400
X-MC-Unique: LnC5ymG0Oby0Q31tXSh7AQ-1
Received: by mail-ed1-f71.google.com with SMTP id x96-20020a50bae9000000b003d871ecccd8so1429657ede.18
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 01:11:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/v8IuUJOxdE99igoHOKSTqfou1Z3pZ41LzbF7lclFns=;
        b=KnDCBcInRzQrXSTgqT8i/OcnzHnG5rIpI5Pp86WvxAVonm5SpTNiKrbI+YzumPjPh5
         IELeNBWS1/y2e/9TieJkQ4ckW2b7Q07Stv3QDbMcwAE8qpRPD14ASfl7LxCdFZPtuMl8
         MnD6g1+p/U/CEs+hcZmsaPQhfYmF8FaTK+t+Qg1y/9A1yf4HE6SiZrxD+Sc3mry1DE6w
         GiGjugTQrqQt3B85EYzGA3nsgI8kTe9Z6+TcCMvRvXwEuqB9PPxSZXdqQLpvsFXffKNR
         hQZdlhSlAcqRqNvfrU5PGwXvzuEIB57Aofa5Ux6e/vrDuhVH0v9kgmF+KrvRd8NGJhk1
         8ebQ==
X-Gm-Message-State: AOAM533vri+nadi1lCutf2DKwvC+9c1TexT4b021otc8PToW9BiZyXkC
        HGuiNU7IZs1gOqiiv04FZxhwFyhb/PlDAvflZ08CXi3PBHge+eFSBfIsaB1aBEJe6kyncmSp2cf
        fiOAFwCNXKYzo
X-Received: by 2002:a17:906:b884:: with SMTP id hb4mr15020067ejb.376.1633335083102;
        Mon, 04 Oct 2021 01:11:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwkPJIkziIwqftGpn97RDjz6g6khr3WzHwWLhziFcUldzYrZQu27oHEbu6PGcHJrChqkpjvSA==
X-Received: by 2002:a17:906:b884:: with SMTP id hb4mr15020049ejb.376.1633335082903;
        Mon, 04 Oct 2021 01:11:22 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id d18sm1904189ejo.80.2021.10.04.01.11.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 01:11:22 -0700 (PDT)
Message-ID: <dc17b773-8b40-1793-8234-88deb58414a3@redhat.com>
Date:   Mon, 4 Oct 2021 10:11:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 06/22] target/i386/cpu: Add missing 'qapi/error.h'
 header
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
 <20211002125317.3418648-7-philmd@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211002125317.3418648-7-philmd@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/10/21 14:53, Philippe Mathieu-Daudé wrote:
> Commit 00b81053244 ("target-i386: Remove assert_no_error usage")
> forgot to add the "qapi/error.h" for &error_abort, add it now.
> 
> Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Reviewed-by: Connor Kuehl <ckuehl@redhat.com>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>   target/i386/cpu.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index cacec605bf1..e169a01713d 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -27,6 +27,7 @@
>   #include "sysemu/hvf.h"
>   #include "kvm/kvm_i386.h"
>   #include "sev_i386.h"
> +#include "qapi/error.h"
>   #include "qapi/qapi-visit-machine.h"
>   #include "qapi/qmp/qerror.h"
>   #include "qapi/qapi-commands-machine-target.h"
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

