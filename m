Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 678E5420709
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 10:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhJDIND (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 04:13:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55579 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229487AbhJDIM4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 04:12:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633335065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vjYU5cz2y0dGq+dhAQVfGWlPOvLqMZPTP1otInh0ROM=;
        b=dUW5PmEX6oIBRFbLqwF7cp8FW4feiqThA8mi00yAzuLW6XlRvbE9Y/I2tJhnGEzu+SiNeJ
        vP4PWm+FIIqAxpRlkweNcgZnx4JNRCsdbl9c1zLjcD7QsmvNqXWnUQse2atWE/jwN9Gbr8
        sCZZu19NlA2BFnH7/ulyGywNswiPuNc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-600-II9l8j8JMqOIaKNqrL4YpA-1; Mon, 04 Oct 2021 04:11:04 -0400
X-MC-Unique: II9l8j8JMqOIaKNqrL4YpA-1
Received: by mail-ed1-f71.google.com with SMTP id r11-20020aa7cfcb000000b003d4fbd652b9so16349928edy.14
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 01:11:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vjYU5cz2y0dGq+dhAQVfGWlPOvLqMZPTP1otInh0ROM=;
        b=P+/dkColfiqzyQbliXVs30M4wMxCpiuI3KVx8WC6jEE/pK7+OX33bCy/QRvE1z21kv
         PkEiLp0LCFQYLLe1/WX1V8me2Jkq4rH+J6SWv6XVIllbp8KyRJ0KuTzxobSrV7qXn0OX
         8xW2et82C1LHyh3/3Kkupu20szEKhKkePr0juOUQOZpqfZ+zJjxga1Dhqd6mAdLuRYXk
         a5LsrRE+PLC1lk2gk1zseBdzVfPH88kXlAaMO94YjzhZ9t57axKNUm5BLWRsYgoAylCw
         5nLpxEk5to7JWRe+2PKm9rF7xw1eHSvpHrzXeORTgyDCSZsF9wTPuDAMAA+/H6dsHE5K
         13Lg==
X-Gm-Message-State: AOAM532aCaGJrygvksM6aG3gHOu7/VPb/G3l8lgLYxlthD7g9XnI8JKF
        P4sqD60Y4WJPmDUWUhggoMT8UdxCyoXO4EpGcxHjVV3RG5znSIhwVINMs/+NtpJXxF9ekVnes6g
        Qc1eclOAXpUU6
X-Received: by 2002:a50:e043:: with SMTP id g3mr16562254edl.196.1633335063408;
        Mon, 04 Oct 2021 01:11:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx2M4UpxCwd9nP3JrAdk/nNT86mhc/MztbWHvGMl8hJiRsX757o29T7LWjeqTSjTmOaFOJfKQ==
X-Received: by 2002:a50:e043:: with SMTP id g3mr16562244edl.196.1633335063217;
        Mon, 04 Oct 2021 01:11:03 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r10sm1644073edh.61.2021.10.04.01.11.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 01:11:02 -0700 (PDT)
Message-ID: <bef20bd5-7760-3fc7-9914-1eddca800825@redhat.com>
Date:   Mon, 4 Oct 2021 10:11:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 05/22] target/i386/monitor: Return QMP error when SEV
 is disabled in build
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
 <20211002125317.3418648-6-philmd@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211002125317.3418648-6-philmd@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/10/21 14:53, Philippe Mathieu-Daudé wrote:
> If the management layer tries to inject a secret, it gets an empty
> response in case the binary built without SEV:
> 
>    { "execute": "sev-inject-launch-secret",
>      "arguments": { "packet-header": "mypkt", "secret": "mypass", "gpa": 4294959104 }
>    }
>    {
>        "return": {
>        }
>    }
> 
> Make it clearer by returning an error, mentioning the feature is
> disabled:
> 
>    { "execute": "sev-inject-launch-secret",
>      "arguments": { "packet-header": "mypkt", "secret": "mypass", "gpa": 4294959104 }
>    }
>    {
>        "error": {
>            "class": "GenericError",
>            "desc": "this feature or command is not currently supported"
>        }
>    }
> 
> Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Reviewed-by: Connor Kuehl <ckuehl@redhat.com>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>   target/i386/monitor.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/target/i386/monitor.c b/target/i386/monitor.c
> index 196c1c9e77f..a9f85acd473 100644
> --- a/target/i386/monitor.c
> +++ b/target/i386/monitor.c
> @@ -28,6 +28,7 @@
>   #include "monitor/hmp-target.h"
>   #include "monitor/hmp.h"
>   #include "qapi/qmp/qdict.h"
> +#include "qapi/qmp/qerror.h"
>   #include "sysemu/kvm.h"
>   #include "sysemu/sev.h"
>   #include "qapi/error.h"
> @@ -743,6 +744,10 @@ void qmp_sev_inject_launch_secret(const char *packet_hdr,
>                                     bool has_gpa, uint64_t gpa,
>                                     Error **errp)
>   {
> +    if (!sev_enabled()) {
> +        error_setg(errp, QERR_UNSUPPORTED);
> +        return;
> +    }
>       if (!has_gpa) {
>           uint8_t *data;
>           struct sev_secret_area *area;
> 

This should be done in the sev_inject_launch_secret stub instead, I 
think.  Or if you do it here, you can remove the "if (!sev_guest)" 
conditional in the non-stub version.

Paolo

