Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7934B7360
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 17:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238669AbiBOPZP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 10:25:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231962AbiBOPZO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 10:25:14 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2AE8A333
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 07:25:04 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id e79so24156626iof.13
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 07:25:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=STSfeMkR8sO6JKdBEzPJOeiPGWaxCEMoqHon21FihTU=;
        b=YJUS8WZ6GALIAGJCgBqidA/jRC7Y4VlfQon9K7eJGbV5JFiV8G0w1bkomi5BZCStpo
         emu7g8n7Y+/hd7YAaj3mNC5X9GOT0unsqyZ6koBcMT4NHVx/u3LydOeUDO6Ov0P1JZAE
         iT3hqQ4GGlayHiq7Kauf4oVzTr3qwGqqaWZNE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=STSfeMkR8sO6JKdBEzPJOeiPGWaxCEMoqHon21FihTU=;
        b=flyExHsLNEy3cwOV4IdZPxzEJu6EwrYTXL2VWpPkXpgKdJac5ttVDzI/oxyGd8pDlS
         Sv9sIGM500Awhyn1al4VtYqH/Ih6gONem+uPNS8NzpriJUIpTE13wdntZMYXiRGfqWRf
         ZwGMxxSqXh0Cf/APg6L8rH5DSUVIuHL0r9lqs41is+fZnczU1ibabn9Qmp2X7qfTWFrx
         ppUKKSxL+OE5/RyE7nUw3x63qL1ei3eXR1NlOw0SCYrSjOIeVje2PI+ZM0eFwOP33/kb
         XiL4rkkLsJ11KRbUoHAIK36TpV/yPfKQ7av3rY2pFw9y0evAcetvarJZKioD4CiQcXBm
         B2xw==
X-Gm-Message-State: AOAM5310shG1UUeXuC+I15rWcP9/tJOfqpd0G4mULfpsD1o0M7Qc3zC/
        0PxT4KfAiHFMW8LEgihYEyqxjw==
X-Google-Smtp-Source: ABdhPJy+IcgP1I/EPyq/Kpzq9SYpM21us3QTIGn6lhDEubr9KH/TzO2vI54UO9yXV6od31OPqFQCyA==
X-Received: by 2002:a05:6602:2ac1:: with SMTP id m1mr2681467iov.123.1644938703517;
        Tue, 15 Feb 2022 07:25:03 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id r13sm10603485ilb.35.2022.02.15.07.25.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 07:25:03 -0800 (PST)
Subject: Re: [PATCH] selftests: kvm: Check whether SIDA memop fails for normal
 guests
To:     Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220215074824.188440-1-thuth@redhat.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <d576d8f7-980f-3bc6-87ad-5a6ae45609b8@linuxfoundation.org>
Date:   Tue, 15 Feb 2022 08:25:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220215074824.188440-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/15/22 12:48 AM, Thomas Huth wrote:
> Commit 2c212e1baedc ("KVM: s390: Return error on SIDA memop on normal
> guest") fixed the behavior of the SIDA memops for normal guests. It
> would be nice to have a way to test whether the current kernel has
> the fix applied or not. Thus add a check to the KVM selftests for
> these two memops.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>   tools/testing/selftests/kvm/s390x/memop.c | 15 +++++++++++++++
>   1 file changed, 15 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/s390x/memop.c b/tools/testing/selftests/kvm/s390x/memop.c
> index 9f49ead380ab..d19c3ffdea3f 100644
> --- a/tools/testing/selftests/kvm/s390x/memop.c
> +++ b/tools/testing/selftests/kvm/s390x/memop.c
> @@ -160,6 +160,21 @@ int main(int argc, char *argv[])
>   	run->psw_mask &= ~(3UL << (63 - 17));   /* Disable AR mode */
>   	vcpu_run(vm, VCPU_ID);                  /* Run to sync new state */
>   
> +	/* Check that the SIDA calls are rejected for non-protected guests */
> +	ksmo.gaddr = 0;
> +	ksmo.flags = 0;
> +	ksmo.size = 8;
> +	ksmo.op = KVM_S390_MEMOP_SIDA_READ;
> +	ksmo.buf = (uintptr_t)mem1;
> +	ksmo.sida_offset = 0x1c0;
> +	rv = _vcpu_ioctl(vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
> +	TEST_ASSERT(rv == -1 && errno == EINVAL,
> +		    "ioctl does not reject SIDA_READ in non-protected mode");

Printing what passed would be a good addition to understand the tests that
get run and expected to pass.

> +	ksmo.op = KVM_S390_MEMOP_SIDA_WRITE;
> +	rv = _vcpu_ioctl(vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
> +	TEST_ASSERT(rv == -1 && errno == EINVAL,
> +		    "ioctl does not reject SIDA_WRITE in non-protected mode");
> +

Same here.

>   	kvm_vm_free(vm);
>   
>   	return 0;
> 

Something to consider in a follow-on patch and future changes to these tests.

Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
