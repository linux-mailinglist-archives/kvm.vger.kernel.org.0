Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC303AE405
	for <lists+kvm@lfdr.de>; Mon, 21 Jun 2021 09:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbhFUH0J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 03:26:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46506 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229621AbhFUH0J (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Jun 2021 03:26:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624260234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XMRgq2dq9kVJTZ06aFTv9LxsxXDee8st/7DFnnRNKMI=;
        b=dudKPdGoHZ/nfXtpjl5qNjSRc77B0giKk5x57EJlS6jbT4cgSoZ7kGDS3DXS/ZtGxD9yQ4
        YbA/BIZWege3/FHkuLVy0tZqk0q6TB47uwN4epVvJ1cLPgEk4k/0X8cDHoWiqqEuqj6ovb
        afoVvorYl50IrxS8Wsurirat9FfiDA0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-73-hNq8hjn4NKOSJGqjvAzl2w-1; Mon, 21 Jun 2021 03:23:52 -0400
X-MC-Unique: hNq8hjn4NKOSJGqjvAzl2w-1
Received: by mail-wr1-f69.google.com with SMTP id k3-20020a5d62830000b029011a69a4d069so7870828wru.21
        for <kvm@vger.kernel.org>; Mon, 21 Jun 2021 00:23:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XMRgq2dq9kVJTZ06aFTv9LxsxXDee8st/7DFnnRNKMI=;
        b=lAN5UIq0apNHNMAG+b+FiwQA8RjvTTjim0mKyxhK84Ae8dXFT8ro2Jj27/Lin2o+yL
         TNvIg53c3xotUUZAnnn1Qokx++AkYnvdwTu7mYwtVO5Rrb/TQjIWVn8bIUgwdD0YGssV
         DwaasJMIdZ1R9gGmwdPTZpN/j3FBNzglRCki9iD10NQvx9dwFOZcJh0QpnQ0NmvcJkkv
         9wc/Ssj9kkTOOYpjKN6W6bPSQm5AJ2r4N+BhMHpgIT3COZhhc9pTSHZIv292UAqn87YQ
         CpItE+IAkiJ/HzEDTrcp4yE/VCaqecJqA2G4DE3I0J9aOnK3TdoDGxESTKQi+aOo+Ujr
         1QcQ==
X-Gm-Message-State: AOAM533K0ZatCsmR9eIqyDPLigVgSVd+Tusk16JNv8qF5L4mDTdxGxhQ
        /18SHTYepBw1DduGdokwRIWkq+FGnPk5u7CJABiV1BPduYmQjWZa+LNLT2E4bKIeKfKvhr5NTBh
        ahMYsQk8RnAqb
X-Received: by 2002:a5d:4b8d:: with SMTP id b13mr9202955wrt.147.1624260231574;
        Mon, 21 Jun 2021 00:23:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy3Lar56js4Qw/UWTvkTUkug7AiZzh4z2h5/A0kNZOD2bew5P7Tki50hdqUzbtUwt/ciGAVnQ==
X-Received: by 2002:a5d:4b8d:: with SMTP id b13mr9202936wrt.147.1624260231341;
        Mon, 21 Jun 2021 00:23:51 -0700 (PDT)
Received: from thuth.remote.csb (pd9575fcd.dip0.t-ipconnect.de. [217.87.95.205])
        by smtp.gmail.com with ESMTPSA id x14sm16500110wrq.78.2021.06.21.00.23.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 00:23:50 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2] s390x: selftest: Add prefixes to fix
 report output (was "s390x: selftest: Fix report output")
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <20210610141913.61553-1-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <d8edba2f-e976-3167-abf6-e1eb15a3f481@redhat.com>
Date:   Mon, 21 Jun 2021 09:23:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210610141913.61553-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/06/2021 16.19, Janosch Frank wrote:
> To make our TAP parser (and me) happy we don't want to have two reports
> with exactly the same wording so I added in two new prefix pushes.
> 
> Also moving the code inside of the region of a prefix will give us
> more data when a problem arises.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   s390x/selftest.c | 26 ++++++++++++++++++--------
>   1 file changed, 18 insertions(+), 8 deletions(-)
> 
> diff --git a/s390x/selftest.c b/s390x/selftest.c
> index b2fe2e7b..0f099ca0 100644
> --- a/s390x/selftest.c
> +++ b/s390x/selftest.c
> @@ -40,19 +40,28 @@ static void test_pgm_int(void)
>   
>   static void test_malloc(void)
>   {
> -	int *tmp = malloc(sizeof(int));
> -	int *tmp2 = malloc(sizeof(int));
> +	int *tmp, *tmp2;
>   
> +	report_prefix_push("malloc");
> +
> +	report_prefix_push("ptr_0");
> +	tmp = malloc(sizeof(int));
> +	report((uintptr_t)tmp & 0xf000000000000000ul, "allocated memory");
>   	*tmp = 123456789;
> +	mb();
> +	report(*tmp == 123456789, "wrote allocated memory");
> +	report_prefix_pop();
> +
> +	report_prefix_push("ptr_1");
> +	tmp2 = malloc(sizeof(int));
> +	report((uintptr_t)tmp2 & 0xf000000000000000ul,
> +	       "allocated memory");
>   	*tmp2 = 123456789;
>   	mb();
> +	report((*tmp2 == 123456789), "wrote allocated memory");
> +	report_prefix_pop();
>   
> -	report((uintptr_t)tmp & 0xf000000000000000ul, "malloc: got vaddr");
> -	report(*tmp == 123456789, "malloc: access works");
> -	report((uintptr_t)tmp2 & 0xf000000000000000ul,
> -	       "malloc: got 2nd vaddr");
> -	report((*tmp2 == 123456789), "malloc: access works");
> -	report(tmp != tmp2, "malloc: addresses differ");
> +	report(tmp != tmp2, "allocated memory addresses differ");
>   
>   	expect_pgm_int();
>   	configure_dat(0);
> @@ -62,6 +71,7 @@ static void test_malloc(void)
>   
>   	free(tmp);
>   	free(tmp2);
> +	report_prefix_pop();
>   }
>   
>   int main(int argc, char**argv)
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

