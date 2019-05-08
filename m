Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAF12178EC
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 13:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbfEHLzs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 07:55:48 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53140 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbfEHLzs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 07:55:48 -0400
Received: by mail-wm1-f66.google.com with SMTP id o25so2921683wmf.2
        for <kvm@vger.kernel.org>; Wed, 08 May 2019 04:55:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wsyniKEEHJ0IkIvec+SHSVgCT+tLWu4G0EqejkQMQBg=;
        b=EFDIeYA0kAZvcu4pQoLNp+OVvCVkZDbMhKz5dmtFtjNG5//qF44HYnAEBnr+3NjRpH
         yxb0Uf1N3h7/S28V5HUK9TkDnhsZaO+wFP5rPwHlEPO5FDyHf85zl7BhkfzkCvIVJR7Q
         IDzQ3rMZZQKQOXd8wPy4cXSvSpHGXsxErxGSnq8Qbc9g30dVJlvCu7NrXycGWAAzfdy6
         nSc8dOUeDztSx05+wfc0NFs4OtfYeHei4onCopJ8+mni7OijTsnFACc4LTBShMV+g2KJ
         YK1kz7lt0PD1Pfac+1b0AIOk52XxaCBCeSsz71s6k3RTjOTWZGwFs3QQ0vBejyaYex9F
         t68Q==
X-Gm-Message-State: APjAAAVICTJIGw+qzgMBYWjIA8iPwX7wvjSBeSZzie6SYmajtAI+qV4q
        aAFc8y6Op54pyHZw9IV/kFoywg==
X-Google-Smtp-Source: APXvYqzea7CrHJstRp+CWVKwN+fnT+ols6b0zCOnsSm0NaMs5zAKJ117LpLEU2+uHhRwFwUcfjrwXA==
X-Received: by 2002:a05:600c:40f:: with SMTP id q15mr1736422wmb.92.1557316546161;
        Wed, 08 May 2019 04:55:46 -0700 (PDT)
Received: from [10.201.49.229] (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id h16sm33180021wrb.31.2019.05.08.04.55.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 04:55:45 -0700 (PDT)
Subject: Re: [PATCH v2] tests: kvm: Add tests to .gitignore
To:     Aaron Lewis <aaronlewis@google.com>, rkrcmar@redhat.com,
        jmattson@google.com, pshier@google.com, marcorr@google.com,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>
References: <20190506141910.197288-1-aaronlewis@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c1825cc1-c2fc-4c71-6b2f-737e8619b29b@redhat.com>
Date:   Wed, 8 May 2019 13:55:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190506141910.197288-1-aaronlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/05/19 09:19, Aaron Lewis wrote:
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  tools/testing/selftests/kvm/.gitignore | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index 2689d1ea6d7a..6027b5f3d72d 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -1,9 +1,12 @@
>  /x86_64/cr4_cpuid_sync_test
>  /x86_64/evmcs_test
> +/x86_64/hyperv_cpuid
>  /x86_64/platform_info_test
>  /x86_64/set_sregs_test
> +/x86_64/smm_test
> +/x86_64/state_test
>  /x86_64/sync_regs_test
>  /x86_64/vmx_close_while_nested_test
>  /x86_64/vmx_tsc_adjust_test
> -/x86_64/state_test
> +/clear_dirty_log_test
>  /dirty_log_test
> 

Queued, thanks.

Paolo
