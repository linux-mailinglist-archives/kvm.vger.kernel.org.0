Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E502416330
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 18:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242152AbhIWQ13 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 12:27:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57846 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242077AbhIWQ1X (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Sep 2021 12:27:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632414351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b8Ah2Qh7p6T0mn87VL57RtyibfllbNYrDwoM7m+3Joo=;
        b=Ca0qzmDtNybsVO+eg3J0BzYW7ghYR/kenAkb56bbfELK75MqVZlMsyU+fwe/CKwTkxpDaQ
        RZELhPgXh7yTuaRwerjHuJAzwXIiIlf65v9Ddf/xSucjaapwT/6L/J0i9jE8FJkGmo8q/F
        nhX6IziVcx3Pwv7+PBv3+sSYhSZPbQ8=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-nGrwA-RFON-SjNcRYmsXSQ-1; Thu, 23 Sep 2021 12:25:50 -0400
X-MC-Unique: nGrwA-RFON-SjNcRYmsXSQ-1
Received: by mail-ej1-f71.google.com with SMTP id k23-20020a170906055700b005e8a5cb6925so88004eja.9
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 09:25:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b8Ah2Qh7p6T0mn87VL57RtyibfllbNYrDwoM7m+3Joo=;
        b=oX8Gq5pCGXdx4IHbbTIdWCphO6CaDV73jRdaeUyKXKUnAG9KLgMxs/P2rjdMHqJzUZ
         9ps9b0y2I6lcJn1+VAijFRLTNPA4iq9aUQJjQtliaK/Txgtt9jT3CwfW14nMblR7YddM
         nW1vm9GTJGWn23HtgjPnkhnmtkQwIH8skcnhWP6Trl0OO2+4bn2zuWWGfshT47wNJ/+6
         5F8fahXYckl0bPXIe8RFzhDoqxG5PCnHCp27AKLOY2kWZzgfWJEg8/drBOJex6JQlIU9
         Bq3u123YOQthTuDmrW1OcEhWWU4bgFCtrqv+JdI9P4NqHGNCUEkrW4TFDZ3WDBlreGwL
         squg==
X-Gm-Message-State: AOAM5335BLTCEp9NbYDA0oTLFmQyBITe7zoKy3xMQx+uRwqFT7dWHU4e
        /KRnYEyHtb+jJZ26fnHjmmOw/PTtdCjBKD/WyNShuoTopju3SXuQ9U/rU7dcKTchAu3udOo19vF
        PatyBy83TF4/q
X-Received: by 2002:aa7:da93:: with SMTP id q19mr6706453eds.206.1632414349554;
        Thu, 23 Sep 2021 09:25:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9XnSwLPcjGBamhpDTdT3EiRg8QNymAoajRgXO8jyqO9O2UVhfynrBSpJ2DkEt/MKXS42ECQ==
X-Received: by 2002:aa7:da93:: with SMTP id q19mr6706421eds.206.1632414349350;
        Thu, 23 Sep 2021 09:25:49 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id gl2sm3237224ejb.110.2021.09.23.09.25.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Sep 2021 09:25:48 -0700 (PDT)
Subject: Re: [PATCH] kvm: selftests: Fix spelling mistake "missmatch" ->
 "mismatch"
To:     Colin King <colin.king@canonical.com>,
        Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210826120752.12633-1-colin.king@canonical.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <02094ffc-11c4-8b72-f889-a0654f95d2bb@redhat.com>
Date:   Thu, 23 Sep 2021 18:25:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210826120752.12633-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/08/21 14:07, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in an error message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>   tools/testing/selftests/kvm/lib/sparsebit.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/sparsebit.c b/tools/testing/selftests/kvm/lib/sparsebit.c
> index a0d0c83d83de..50e0cf41a7dd 100644
> --- a/tools/testing/selftests/kvm/lib/sparsebit.c
> +++ b/tools/testing/selftests/kvm/lib/sparsebit.c
> @@ -1866,7 +1866,7 @@ void sparsebit_validate_internal(struct sparsebit *s)
>   		 * of total bits set.
>   		 */
>   		if (s->num_set != total_bits_set) {
> -			fprintf(stderr, "Number of bits set missmatch,\n"
> +			fprintf(stderr, "Number of bits set mismatch,\n"
>   				"  s->num_set: 0x%lx total_bits_set: 0x%lx",
>   				s->num_set, total_bits_set);
>   
> 


Queued, thanks.

Paolo

