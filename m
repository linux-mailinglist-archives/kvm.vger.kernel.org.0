Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4D4F4206FB
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 10:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbhJDIHz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 04:07:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20411 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229685AbhJDIHc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 04:07:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633334743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=slfMiRI8yIsbj6y8gHoWoDRQToV+/o2ShBbAZIHwZf8=;
        b=YJaYfzfJ2oUNyJmt4n5O2JAl7qGUCudbraCcKhnBmTLtKnxYwjkBrOXimtgEFa72QZRTUI
        84ZngZdG2elUfQlZlcyurpExExQipRRHAbg4VuTkO5FvdMgtZBw8/MX9wNY69Y/e/RdyDR
        YebJIU6qPy2YbCBER5KyvMIsCblYSUM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-HytUmgw_NAGXrFMwobiuXg-1; Mon, 04 Oct 2021 04:05:42 -0400
X-MC-Unique: HytUmgw_NAGXrFMwobiuXg-1
Received: by mail-ed1-f70.google.com with SMTP id m20-20020aa7c2d4000000b003d1add00b8aso16428517edp.0
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 01:05:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=slfMiRI8yIsbj6y8gHoWoDRQToV+/o2ShBbAZIHwZf8=;
        b=A4o45f8UOiRUlXiW1dAiKk9+WoIER/nY8ctbE1t8/IIZPCZirTGQgpFCuIgNY35Ywk
         0iqO2AT5AhCCFRlgXHNwy0DmneCMxtEScj00ZqPp3VLhGZynm1duyBbjJH0cLXioxhr6
         dbmtHv1xF8f3iLZ08fQw7vV6Y3Opk/f2AvR7yIaIzZGZXBWH0JkT7rN3fOxNOro7Z2eB
         YHgdOtlpapByeyuEkz8D9W3+sYUZx8JIM8SAsFWWiun/om8vkmsIiWllBFreTrZIggD6
         l34kf7tTvNmrPg1Cumqm8hI+BzSkW2dL2uygQ624vOFQG9QN48LELDEgxr4T3EkzoBhI
         oprw==
X-Gm-Message-State: AOAM530SMfcCBJCJ7Dlhl6WCckeK7Hki3pTl12Gd7kA9JVFsa5JzZQ/9
        oaDwFn3zmMDNTTh9mUmK1vj+qKw5p1/ArWT4cGCEJNXokpMvQdgScWt1dDYHlqfpXYeGT+WIiY6
        y+ljuwIUXXWXR
X-Received: by 2002:a05:6402:410:: with SMTP id q16mr16420214edv.286.1633334741388;
        Mon, 04 Oct 2021 01:05:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwgSMDwVDhoo9oYCOfILVhORmQy41yqG5m8Z7uMCtAir4/VB5g48B74F4Ns1FeIIMAIDFL1+A==
X-Received: by 2002:a05:6402:410:: with SMTP id q16mr16420189edv.286.1633334741128;
        Mon, 04 Oct 2021 01:05:41 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id bj21sm6172910ejb.42.2021.10.04.01.05.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 01:05:40 -0700 (PDT)
Message-ID: <569c9eae-6ad6-14f2-0e06-b3a0c0e5b31b@redhat.com>
Date:   Mon, 4 Oct 2021 10:05:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 01/22] qapi/misc-target: Wrap long 'SEV Attestation
 Report' long lines
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org,
        Sergio Lopez <slp@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        "Daniel P . Berrange" <berrange@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>
References: <20211002125317.3418648-1-philmd@redhat.com>
 <20211002125317.3418648-2-philmd@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211002125317.3418648-2-philmd@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/10/21 14:52, Philippe Mathieu-Daudé wrote:
> Wrap long lines before 70 characters for legibility.
> 
> Suggested-by: Markus Armbruster <armbru@redhat.com>
> Reviewed-by: Markus Armbruster <armbru@redhat.com>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>   qapi/misc-target.json | 17 ++++++++++-------
>   1 file changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/qapi/misc-target.json b/qapi/misc-target.json
> index 594fbd1577f..ae5577e0390 100644
> --- a/qapi/misc-target.json
> +++ b/qapi/misc-target.json
> @@ -300,8 +300,8 @@
>   ##
>   # @SevAttestationReport:
>   #
> -# The struct describes attestation report for a Secure Encrypted Virtualization
> -# feature.
> +# The struct describes attestation report for a Secure Encrypted
> +# Virtualization feature.
>   #
>   # @data:  guest attestation report (base64 encoded)
>   #
> @@ -315,10 +315,11 @@
>   ##
>   # @query-sev-attestation-report:
>   #
> -# This command is used to get the SEV attestation report, and is supported on AMD
> -# X86 platforms only.
> +# This command is used to get the SEV attestation report, and is
> +# supported on AMD X86 platforms only.
>   #
> -# @mnonce: a random 16 bytes value encoded in base64 (it will be included in report)
> +# @mnonce: a random 16 bytes value encoded in base64 (it will be
> +#          included in report)
>   #
>   # Returns: SevAttestationReport objects.
>   #
> @@ -326,11 +327,13 @@
>   #
>   # Example:
>   #
> -# -> { "execute" : "query-sev-attestation-report", "arguments": { "mnonce": "aaaaaaa" } }
> +# -> { "execute" : "query-sev-attestation-report",
> +#                  "arguments": { "mnonce": "aaaaaaa" } }
>   # <- { "return" : { "data": "aaaaaaaabbbddddd"} }
>   #
>   ##
> -{ 'command': 'query-sev-attestation-report', 'data': { 'mnonce': 'str' },
> +{ 'command': 'query-sev-attestation-report',
> +  'data': { 'mnonce': 'str' },
>     'returns': 'SevAttestationReport',
>     'if': 'TARGET_I386' }
>   
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

