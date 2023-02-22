Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4FF69FA9C
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 18:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbjBVR7h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 12:59:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjBVR7g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 12:59:36 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB8338B6D
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 09:59:35 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id b12so1021785ils.8
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 09:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Uy5pdeYgUpFGIEf7X91ctTBBE3MBoLcU1hE7QgayOKU=;
        b=RARg57s3eSm29ZIVgj49+EpDoogrHha3wyIOOsXgwx1gtb8nIF/m4M72NPEzw+ceiX
         kxCMjZeDw+GXM7z/Z3n8Zr6ODdpLnXZFAZ5mL3MNsP5AHqf4+iHIpBMXsI6oUoBeTanE
         A/jh+0/xQylOECZ1iI1/zx2okhpmI8Sfpad2s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Uy5pdeYgUpFGIEf7X91ctTBBE3MBoLcU1hE7QgayOKU=;
        b=NTFIacJV4lTRzh/zPhoEVzE+kbQvh/KU41xSvq6uFjIiksVaTV6b6R+UpYKht/EPuy
         uKM7msdSgMyqKDb6p4ctb1Ji+rtXY+4RIMCLKcEfFp8aV7xm2HdlUPGTOOQyUk97TlWi
         2P5arnYhS+Iru8IqFFVkkQ/CDB6eXWbPYXPvaojwMlUEJcEpkRxegunQsTcBxsuIXxFx
         aCjHM17YbJ0Gc5lojr9hqyl6Q+hFxN/nj4Q6ozs2zyAiLrZXg0s4AnAKc7bgdwERZhHf
         yb+xpBY6sPsw7bOzR/SlPfqkoi2hwMjStvGOf32S/EORHHqDoF8BSPb824/xuCP7aPma
         yJ8g==
X-Gm-Message-State: AO0yUKUEi0YEmQXk/F5Wq7joy/iI77IeUELj6s12vIFxek/8ercF6j66
        nPvM3hTq1jpZgRxaw5QwErTZBw==
X-Google-Smtp-Source: AK7set8zfC7rQBLLvFFyGlkHMBrELQeG6gTKOLCBwBe7x3GJv28x5iQWiVhuEGEhS2R9udJ+U6CaYQ==
X-Received: by 2002:a05:6e02:1605:b0:315:2b2a:f458 with SMTP id t5-20020a056e02160500b003152b2af458mr5506062ilu.3.1677088774574;
        Wed, 22 Feb 2023 09:59:34 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id p10-20020a92d48a000000b0030c27c9eea4sm2139981ilg.33.2023.02.22.09.59.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Feb 2023 09:59:33 -0800 (PST)
Message-ID: <30d80f40-247e-f5b6-3693-e8cd9c119d8e@linuxfoundation.org>
Date:   Wed, 22 Feb 2023 10:59:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] KVM: selftests: Depend on kernel headers when making
 selftests
Content-Language: en-US
To:     Colton Lewis <coltonlewis@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ben Gardon <bgardon@google.com>
Cc:     kvm@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230220203529.136013-1-coltonlewis@google.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230220203529.136013-1-coltonlewis@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/20/23 13:35, Colton Lewis wrote:
> Add a makefile dependency for the kernel headers when building KVM
> selftests. As the selftests do depend on the kernel headers, needing
> to do things such as build selftests for a different architecture
> requires rebuilding the headers. That is an extra annoying manual step
> that should be handled by make.
> 

It does if you use the kselftest-* targets from the main Makefile:

# Kernel selftest

PHONY += kselftest
kselftest: headers
         $(Q)$(MAKE) -C $(srctree)/tools/testing/selftests run_tests

kselftest-%: headers FORCE
         $(Q)$(MAKE) -C $(srctree)/tools/testing/selftests $*

You can use the following commands to just build what you want to build:
make kselftest-all TARGETS=kvm

I would like to see the above used to make kselftest easier to maintain
and easier to add features.

If you choose to build from the test directory - then you do have
to manually run headers_install.


> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
> 
> This change has been sitting in my local git repo as a stach for a
> long time to make it easier to build selftests for multiple
> architectures and I just realized I never sent it upstream. I don't
> know if this is the best way to accomplish the goal, but it was the
> only obvious one I found.
> 
>   tools/testing/selftests/kvm/Makefile | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 1750f91dd936..857c6f78e4da 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -221,12 +221,16 @@ LIBKVM_OBJS = $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ) $(LIBKVM_STRING_OBJ)
>   EXTRA_CLEAN += $(LIBKVM_OBJS) cscope.*
> 
>   x := $(shell mkdir -p $(sort $(dir $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ))))
> -$(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c
> +$(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c headers
>   	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
> 
>   $(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S
>   	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
> 
> +PHONY += headers
> +headers:
> +	$(MAKE) -C $(top_srcdir) headers
> +

This will install headers under the repo and doesn't work with out
of tree builds.

thanks,
-- Shuah
