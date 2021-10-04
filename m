Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 227E34206FC
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 10:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhJDIH7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 04:07:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30751 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230217AbhJDIH4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 04:07:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633334763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hw+xbDWc7dtQn72C5ECQKBz7jDmamUcokktZX7IgWEo=;
        b=GjgIWGS3ppAf76FfnS+9vxgs5o1Ey9ZhOHffxs8i5OelAqJtLl2tVT8Y8mGt3J/1nD5d4V
        02qGA1ECy1wzf7L9T2AJYOlwM8ec4+cck460okUJAypOJq7AHnxWX2ThsYLIJfmJ/a7Efm
        BMMTMqQWZuqavJb0+JdqR/u2x3/WxFM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-ZObjU2nvM-qsUD0MaC7UAg-1; Mon, 04 Oct 2021 04:06:02 -0400
X-MC-Unique: ZObjU2nvM-qsUD0MaC7UAg-1
Received: by mail-ed1-f72.google.com with SMTP id z62-20020a509e44000000b003da839b9821so16298901ede.15
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 01:06:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hw+xbDWc7dtQn72C5ECQKBz7jDmamUcokktZX7IgWEo=;
        b=e0ox6YDHckuIXYdyPtUhGLxXEX3qwAl06i0K0j/2nCQarIlCOOVulHzbpAMt6Lfkki
         6wg3Qbl6ssNoNMh/EOo/wx8fo4lwj8cSGFqnotHv2Q4RiavYZ8gmPuO4HhJONjeJnf/9
         Eh/6N2tEbnyJSia8T6Wh0oI8uPEcj+hLCgS3OCHNtiOQf8yNnKZqOdJhdAsdv96l6bHA
         ktaWDgaWhgKVkzna7x8HpXVHZHRNfvNUM5KODx4JMmcSCM/AzqPmIVEfQm/PNlbXpaOP
         zTSPj0YzjngOCDbq8DD0LUhuVCDgIanyPMkJgwOgsylDwXZlxYM7jEJM2aniBckAJe8l
         +MZQ==
X-Gm-Message-State: AOAM530ZjpDXj6OFJ6c6THJBOU8QBjuk8PmO3VS2NQbFImyfOszI2MpS
        09+/MaDqhU7Y2C4bcZeGY1u2DrfIdLvHpC+ghxIxpUU8ORfiTru6p9NInXE0GhUaNtGgwP3ma8P
        BdyXUphvPxL+I
X-Received: by 2002:a17:907:a411:: with SMTP id sg17mr15692046ejc.412.1633334761282;
        Mon, 04 Oct 2021 01:06:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw9YElamJHoHOVWhZSmRK0N3iqP1SylotX6RwYdcZ8fP4UXOoe1vZcZ5a3/Mg9aLskU8ulBig==
X-Received: by 2002:a17:907:a411:: with SMTP id sg17mr15692029ejc.412.1633334761079;
        Mon, 04 Oct 2021 01:06:01 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u18sm6291149ejc.26.2021.10.04.01.05.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 01:06:00 -0700 (PDT)
Message-ID: <df27af6d-e75a-916d-e8cc-4ac9fab2c104@redhat.com>
Date:   Mon, 4 Oct 2021 10:05:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 02/22] qapi/misc-target: Group SEV QAPI definitions
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org,
        Sergio Lopez <slp@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        "Daniel P . Berrange" <berrange@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>
References: <20211002125317.3418648-1-philmd@redhat.com>
 <20211002125317.3418648-3-philmd@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211002125317.3418648-3-philmd@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/10/21 14:52, Philippe Mathieu-Daudé wrote:
> There is already a section with various SEV commands / types,
> so move the SEV guest attestation together.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>   qapi/misc-target.json | 80 +++++++++++++++++++++----------------------
>   1 file changed, 40 insertions(+), 40 deletions(-)
> 
> diff --git a/qapi/misc-target.json b/qapi/misc-target.json
> index ae5577e0390..5aa2b95b7d4 100644
> --- a/qapi/misc-target.json
> +++ b/qapi/misc-target.json
> @@ -229,6 +229,46 @@
>     'data': { 'packet-header': 'str', 'secret': 'str', '*gpa': 'uint64' },
>     'if': 'TARGET_I386' }
>   
> +##
> +# @SevAttestationReport:
> +#
> +# The struct describes attestation report for a Secure Encrypted
> +# Virtualization feature.
> +#
> +# @data:  guest attestation report (base64 encoded)
> +#
> +#
> +# Since: 6.1
> +##
> +{ 'struct': 'SevAttestationReport',
> +  'data': { 'data': 'str'},
> +  'if': 'TARGET_I386' }
> +
> +##
> +# @query-sev-attestation-report:
> +#
> +# This command is used to get the SEV attestation report, and is
> +# supported on AMD X86 platforms only.
> +#
> +# @mnonce: a random 16 bytes value encoded in base64 (it will be
> +#          included in report)
> +#
> +# Returns: SevAttestationReport objects.
> +#
> +# Since: 6.1
> +#
> +# Example:
> +#
> +# -> { "execute" : "query-sev-attestation-report",
> +#                  "arguments": { "mnonce": "aaaaaaa" } }
> +# <- { "return" : { "data": "aaaaaaaabbbddddd"} }
> +#
> +##
> +{ 'command': 'query-sev-attestation-report',
> +  'data': { 'mnonce': 'str' },
> +  'returns': 'SevAttestationReport',
> +  'if': 'TARGET_I386' }
> +
>   ##
>   # @dump-skeys:
>   #
> @@ -297,46 +337,6 @@
>     'if': 'TARGET_ARM' }
>   
>   
> -##
> -# @SevAttestationReport:
> -#
> -# The struct describes attestation report for a Secure Encrypted
> -# Virtualization feature.
> -#
> -# @data:  guest attestation report (base64 encoded)
> -#
> -#
> -# Since: 6.1
> -##
> -{ 'struct': 'SevAttestationReport',
> -  'data': { 'data': 'str'},
> -  'if': 'TARGET_I386' }
> -
> -##
> -# @query-sev-attestation-report:
> -#
> -# This command is used to get the SEV attestation report, and is
> -# supported on AMD X86 platforms only.
> -#
> -# @mnonce: a random 16 bytes value encoded in base64 (it will be
> -#          included in report)
> -#
> -# Returns: SevAttestationReport objects.
> -#
> -# Since: 6.1
> -#
> -# Example:
> -#
> -# -> { "execute" : "query-sev-attestation-report",
> -#                  "arguments": { "mnonce": "aaaaaaa" } }
> -# <- { "return" : { "data": "aaaaaaaabbbddddd"} }
> -#
> -##
> -{ 'command': 'query-sev-attestation-report',
> -  'data': { 'mnonce': 'str' },
> -  'returns': 'SevAttestationReport',
> -  'if': 'TARGET_I386' }
> -
>   ##
>   # @SGXInfo:
>   #
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

