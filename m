Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2A3F87345
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 09:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405836AbfHIHje (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 03:39:34 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54440 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405711AbfHIHja (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Aug 2019 03:39:30 -0400
Received: by mail-wm1-f67.google.com with SMTP id p74so4686934wme.4
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2019 00:39:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xaUE+b2Ivx2DbXYmJvLDQ+HYNnryuMwKv4SoNgWueQs=;
        b=eIU33pw1Z9S6kJsunnMJ0qFOj9tEVdnB+bB/+UcyFh13Z4JrpdZdsrWS66tYxLIqnr
         4mtaRWjO8VrjPMEP+TqFXNFoh36ZDYkUCdAMqlCCh5t2m6DiR7alxf1cwxUyFVBkr73o
         C1rQDRzEdvNVc6bRWnkzqjAj+sHTAUFLURj4uRS955Q6bK7WUWXY9eaL+0kbHOaTSmAe
         SZDKFxGAy+l5zLbdmNsPAt8TsjIJrDYL5fDCLIpVuQl356EmUKrB2dRozjEjPxcmut/b
         +SjmZ/4EiMAGQnFeWgYnk4GeJ89nB+CI0rhGajIKyUs77SzWWq3YODQ7LfA5hVdDEqoA
         9YIw==
X-Gm-Message-State: APjAAAVWxtuhzyfudp4oin2yBQW1VORJ7U+yM+wpCEdi6t3KEm94OcST
        gILRs6h3sXB5kcjxb2iYnUE1BFwrf0Q=
X-Google-Smtp-Source: APXvYqxytvGnBCzeMG9C+zJI7RJIXc4jYF8EQLjKxY1xmaERR0icUaDIN9Wz/zR8CgJLJXbU7OMqZQ==
X-Received: by 2002:a1c:f913:: with SMTP id x19mr9078528wmh.139.1565336368260;
        Fri, 09 Aug 2019 00:39:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b42d:b492:69df:ed61? ([2001:b07:6468:f312:b42d:b492:69df:ed61])
        by smtp.gmail.com with ESMTPSA id m7sm80941667wrx.65.2019.08.09.00.39.27
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Aug 2019 00:39:27 -0700 (PDT)
Subject: Re: [PATCH v3 1/2] selftests: kvm: Adding config fragments
To:     Naresh Kamboju <naresh.kamboju@linaro.org>, shuah@kernel.org
Cc:     linux-kernel@vger.kernel.org, drjones@redhat.com,
        sean.j.christopherson@intel.com, linux-kselftest@vger.kernel.org,
        kvm@vger.kernel.org
References: <20190809072415.29305-1-naresh.kamboju@linaro.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0a0e0563-aba7-e59c-1fbd-547126d404ed@redhat.com>
Date:   Fri, 9 Aug 2019 09:39:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190809072415.29305-1-naresh.kamboju@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/08/19 09:24, Naresh Kamboju wrote:
> selftests kvm all test cases need pre-required kernel config for the
> tests to get pass.
> 
> CONFIG_KVM=y
> 
> The KVM tests are skipped without these configs:
> 
>         dev_fd = open(KVM_DEV_PATH, O_RDONLY);
>         if (dev_fd < 0)
>                 exit(KSFT_SKIP);
> 
> Signed-off-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Acked-by: Shuah Khan <skhan@linuxfoundation.org>
> ---
>  tools/testing/selftests/kvm/config | 1 +
>  1 file changed, 1 insertion(+)
>  create mode 100644 tools/testing/selftests/kvm/config
> 
> diff --git a/tools/testing/selftests/kvm/config b/tools/testing/selftests/kvm/config
> new file mode 100644
> index 000000000000..14f90d8d6801
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/config
> @@ -0,0 +1 @@
> +CONFIG_KVM=y
> 

I think this is more complicated without a real benefit, so I'll merge v2.

Paolo
