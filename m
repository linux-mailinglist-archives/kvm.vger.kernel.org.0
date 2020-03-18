Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B319189C36
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 13:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgCRMpP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 08:45:15 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:46889 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726616AbgCRMpP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Mar 2020 08:45:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584535513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pEt6WWu3dM7UAqw+VBZsyoySaNluPsuDu7IMq3V2wc8=;
        b=aoGv43LIOYuShqCaMOFDAeNBQ1XEH4YlKG+GoE15/ypYENMz1ZWyZCgkwigHMNDXE4X4/h
        FQOYY3dJRqQiiDzVbCi35G3HYRw0LZxgzTYjj9TVNCgWi4DuWqHgHlTe2kjUL5c7MLtrcx
        lA2ICe03O3tN9QUhgW9kE2Akx0RGfiM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-TvtYzTcEMweRIGftTvE0Tw-1; Wed, 18 Mar 2020 08:45:11 -0400
X-MC-Unique: TvtYzTcEMweRIGftTvE0Tw-1
Received: by mail-wr1-f69.google.com with SMTP id p2so9763100wrw.8
        for <kvm@vger.kernel.org>; Wed, 18 Mar 2020 05:45:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pEt6WWu3dM7UAqw+VBZsyoySaNluPsuDu7IMq3V2wc8=;
        b=SPXZawwp4EWUEyUGzuND9wcNvxHMvcxhBI70m7tFZlXk+ihzJmQEG5ibxVuA1W1PTA
         kwZLbPbIIkGPZDYiJ0pMfSNoDWh/azAuU4ITrHkC1GLmz5c+/VpLYts3R9X3EDdDZFCF
         P2zg98ajyTMUWUBiKroxuBa8zqVVJz0WrZV7ardNjdQCknvp2T+Ks5+/57kAhxPci+rF
         JLNsg0ZK5JgIbK1E+Z854A4i/wV0D0HAi6akuS5OqVOcFKu+578UvTCSHq398JIsBj1U
         UKpw6FgZTmu2zVN4wOXf5N1afdPxff3ski0A695HI8pWYpuOqVB2txMlYoM/9Umftw1E
         Jz9w==
X-Gm-Message-State: ANhLgQ1ThjCx1TOVDG+ofeauV5Htj1SOfybjL3uf4h+1sKwtF7DrXJbW
        un5X2M2/pQGdEUeagCjinBto2XuJ9ZzkbcMkzUdtRs8zaLkMaWTpukI5B+7Eh8Nbh4oB3Snz6q+
        doLOVYH50yvCp
X-Received: by 2002:a7b:cb97:: with SMTP id m23mr4983520wmi.140.1584535510567;
        Wed, 18 Mar 2020 05:45:10 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsn4EgNf377XBstgYMpron4nyy9A1jZI+KtBo293okoq1n9V7aABpp3/FhZJ+yC5r7WImgGTg==
X-Received: by 2002:a7b:cb97:: with SMTP id m23mr4983501wmi.140.1584535510317;
        Wed, 18 Mar 2020 05:45:10 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.15.43])
        by smtp.gmail.com with ESMTPSA id m10sm3779238wmc.24.2020.03.18.05.45.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2020 05:45:09 -0700 (PDT)
Subject: Re: [PATCH 2/3] kvm-unit-test: nSVM: Add helper functions to write
 and read vmcb fields
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
References: <20200317200537.21593-1-krish.sadhukhan@oracle.com>
 <20200317200537.21593-3-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dc3a5ec0-7309-d181-6eb7-7cf613cabc12@redhat.com>
Date:   Wed, 18 Mar 2020 13:45:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200317200537.21593-3-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/03/20 21:05, Krish Sadhukhan wrote:
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> ---
>  x86/svm.c | 16 ++++++++++++++++
>  x86/svm.h |  2 ++
>  2 files changed, 18 insertions(+)

I prefer to just make vmcb public in svm.h.

Please check kvm-unit-tests.git's master branch and kvm.git's queue branch.

Thanks for contributing to nested SVM tests as well!

Paolo

> diff --git a/x86/svm.c b/x86/svm.c
> index 7ce33a6..3803032 100644
> --- a/x86/svm.c
> +++ b/x86/svm.c
> @@ -233,6 +233,22 @@ int svm_vmrun(void)
>  	return (vmcb->control.exit_code);
>  }
>  
> +u64 vmcb_save_read64(size_t offset)
> +{
> +	u64 *ptr = (u64 *) ((char *) vmcb + offsetof(struct vmcb, save) +
> +	    offset);
> +
> +       return (*ptr);
> +}
> +
> +void vmcb_save_write64(size_t offset, u64 value)
> +{
> +	u64 *ptr = (u64 *) ((char *) vmcb + offsetof(struct vmcb, save) +
> +	    offset);
> +
> +       *ptr = value;
> +}
> +
>  static void test_run(struct svm_test *test)
>  {
>  	u64 vmcb_phys = virt_to_phys(vmcb);
> diff --git a/x86/svm.h b/x86/svm.h
> index 25514de..3a6af6e 100644
> --- a/x86/svm.h
> +++ b/x86/svm.h
> @@ -380,5 +380,7 @@ struct regs get_regs(void);
>  void vmmcall(void);
>  int svm_vmrun(void);
>  void test_set_guest(test_guest_func func);
> +u64 vmcb_save_read64(size_t offset);
> +void vmcb_save_write64(size_t offset, u64 value);
>  
>  #endif
> 

