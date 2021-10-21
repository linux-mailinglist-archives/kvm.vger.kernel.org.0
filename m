Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771FE436B92
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 21:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbhJUT4x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 15:56:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40563 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231984AbhJUT4v (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 15:56:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634846072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XQQxB68/bqgix0H59OBXlceD3gg5Noo7Iow2EZ2n7yg=;
        b=IPCHsUFujQzn7aTNpej8zRJrbF6mDzgwNsfjoDfb2TK+fkyyT9fGV1eleKlakTevTKD2zb
        KI4+s6w2qQ7BG0ts9wCzy+aYyOTwOuh+15jk+mVw2G0L6jYT4/Q4dhu8I6EouOHmcUL6B6
        +mk6avsUeX6oi2dvMWYeKfcGqYzuBaw=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-Bfu7W-zMMdqHEp9LS0wEWg-1; Thu, 21 Oct 2021 15:54:31 -0400
X-MC-Unique: Bfu7W-zMMdqHEp9LS0wEWg-1
Received: by mail-ed1-f69.google.com with SMTP id u10-20020a50d94a000000b003dc51565894so1423983edj.21
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 12:54:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XQQxB68/bqgix0H59OBXlceD3gg5Noo7Iow2EZ2n7yg=;
        b=JqJZuSxpwgXnzCvdZep85IEMcM/8Gh0Jv1vuI3oFmEuw8rgwsbF4M2J6jgRak3flpl
         rl8rU5RWKIaqtRfA/HmFRnDicRuK2NpxC7pWKGkQwn729CQ5iwPiQrUnvr4MVZtwNcrv
         LNcfHtKl6EFPas2JcLWRvqJmPWBu/FVsisCcLdxW28eNkvEJ61FR/xkabMpAUnGvHdI/
         i2sSAFxmGFbSKhF2f4V5L0IZzbmn7D6qiRTzf90/zDFjgKBYHbjDwLaQ5ed2NLmGDx9L
         NzhsiQTWsCWMrgvJ9ETv6f6pZ5/SahmmagTF3bosKdKAgajPWjMZJ7h8Sc/tjY2DFYnd
         TNfA==
X-Gm-Message-State: AOAM533sihQqOw+wjryXsXCgUwP4j4Gpw6+x0HhgY0EN1WBcZtXu/WK6
        dDG5k3T57WFV7iIyhLHrYkP9kTgg7QUF8gdK29bMDd7OszxKB+LxORnbA2DcLFpy+LPzjAamb6M
        tNWaKIyIYDdqF
X-Received: by 2002:a05:6402:50c7:: with SMTP id h7mr10509070edb.191.1634846070222;
        Thu, 21 Oct 2021 12:54:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzmJnU7g6ZVD24HMPBsZgL0Jyl+qXHtE9LJnZE9S9oVAH4QKW2i7BfFAIN7nIyagvTLyj43JA==
X-Received: by 2002:a05:6402:50c7:: with SMTP id h7mr10509049edb.191.1634846070077;
        Thu, 21 Oct 2021 12:54:30 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id t18sm3616082edd.18.2021.10.21.12.54.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 12:54:29 -0700 (PDT)
Message-ID: <7edcd370-41a5-f7e8-1ea9-a6073c97638d@redhat.com>
Date:   Thu, 21 Oct 2021 21:54:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2] selftests: kvm: fix mismatched fclose() after popen()
Content-Language: en-US
To:     Shuah Khan <skhan@linuxfoundation.org>, shuah@kernel.org
Cc:     kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211021175603.22391-1-skhan@linuxfoundation.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211021175603.22391-1-skhan@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/10/21 19:56, Shuah Khan wrote:
> get_warnings_count() does fclose() using File * returned from popen().
> Fix it to call pclose() as it should.
> 
> tools/testing/selftests/kvm/x86_64/mmio_warning_test
> x86_64/mmio_warning_test.c: In function ‘get_warnings_count’:
> x86_64/mmio_warning_test.c:87:9: warning: ‘fclose’ called on pointer returned from a mismatched allocation function [-Wmismatched-dealloc]
>     87 |         fclose(f);
>        |         ^~~~~~~~~
> x86_64/mmio_warning_test.c:84:13: note: returned from ‘popen’
>     84 |         f = popen("dmesg | grep \"WARNING:\" | wc -l", "r");
>        |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> ---
>   tools/testing/selftests/kvm/x86_64/mmio_warning_test.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c b/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
> index 8039e1eff938..9f55ccd169a1 100644
> --- a/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
> @@ -84,7 +84,7 @@ int get_warnings_count(void)
>   	f = popen("dmesg | grep \"WARNING:\" | wc -l", "r");
>   	if (fscanf(f, "%d", &warnings) < 1)
>   		warnings = 0;
> -	fclose(f);
> +	pclose(f);
>   
>   	return warnings;
>   }
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Thanks,

Paolo

