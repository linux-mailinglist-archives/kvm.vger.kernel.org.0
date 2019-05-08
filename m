Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0672C178F9
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 14:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbfEHMBb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 08:01:31 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37363 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbfEHMBb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 08:01:31 -0400
Received: by mail-wm1-f68.google.com with SMTP id y5so2920990wma.2
        for <kvm@vger.kernel.org>; Wed, 08 May 2019 05:01:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wSeaUbXO/G2ABMpG3ZI9l6xSWSvPrig0J/Ul+97pYOo=;
        b=XiGKe7JiX2uDrBPGlvIq/7nbK1foi+32axiTez7e4NO5bCePFL8Kmv2Ukd9xXHV9HU
         s1OqRPHMbA8ZXTTF0gP+z4RIEh17NMVRC5g9n0OstXClTL9BWsRqWyZqovEcii60By7W
         8GCX9JcyxCV7UoXX84ctKoLpo+mmejRO+ZOxaqiVxL5tWN9WVmcSDIAPqiNN24WDC97U
         T3oYVRcD/1RolY6+3Kn5ZPJl8GH6mLeXTaBWOjZ5xhI7ddQGXWQYapH4PWdKXgWI5wJT
         DF11d+dH8BPLZu/H3EjJIspZuLTUCysku8gghFUgh/iu94R3plRoIq/1jBXWMvK7GVUA
         2vYA==
X-Gm-Message-State: APjAAAUYQ2FVZTsWaTxSbOVV1xjvO2Jk8DLtI1TOlxiDoN3NBuCkVfeq
        kYDhUyreEtZkHLBG72BhTLKY9A==
X-Google-Smtp-Source: APXvYqzPfHhQrT3wTWDmIYx1ukM94t//a8L8XjugHMiQFA+o8sTuiHo8J/nt1OPUBal9DFBpzn5wPA==
X-Received: by 2002:a1c:f310:: with SMTP id q16mr2972248wmq.102.1557316889187;
        Wed, 08 May 2019 05:01:29 -0700 (PDT)
Received: from [10.201.49.229] (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id z7sm1558435wme.26.2019.05.08.05.01.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 05:01:28 -0700 (PDT)
Subject: Re: [PATCH] tests: kvm: Add tests to .gitignore
To:     Aaron Lewis <aaronlewis@google.com>, rkrcmar@redhat.com,
        jmattson@google.com, marcorr@google.com, kvm@vger.kernel.org
Cc:     Peter Shier <pshier@google.com>
References: <20190502183150.259633-1-aaronlewis@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2b7db69d-f2f4-0d42-4541-01d1c6cce8f0@redhat.com>
Date:   Wed, 8 May 2019 14:01:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190502183150.259633-1-aaronlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/05/19 13:31, Aaron Lewis wrote:
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> ---
>  tools/testing/selftests/kvm/.gitignore | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index 2689d1ea6d7a..391a19231618 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -6,4 +6,7 @@
>  /x86_64/vmx_close_while_nested_test
>  /x86_64/vmx_tsc_adjust_test
>  /x86_64/state_test
> +/x86_64/hyperv_cpuid
> +/x86_64/smm_test
> +/clear_dirty_log_test
>  /dirty_log_test
> 

Queued, thanks.

Paolo
