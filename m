Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 944C66106E1
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 02:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235368AbiJ1AeX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 20:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234235AbiJ1AeW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 20:34:22 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94DB2A2A9A
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 17:34:21 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id d59-20020a17090a6f4100b00213202d77e1so8366542pjk.2
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 17:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=icna4+Gu1RP4+DJwZuedByDksSgjiCoE4+VfX4uy3uQ=;
        b=EyALZ25U4GiYfLdrtMYveLMFQhC8eQRTXFl0exgeUON1yCrJHBEsc1PFvw0lq5bCpB
         15FZvYQnfc+qLgobi14B3k6jfFy6NBEtbuCHgpA7uqrFQbkctZ/UPF5TebbacinkKqNE
         9FvG1USRocJSRWwsVM2hX3zV2by44Sbh3hAAq9tSG6NLR8RaleyhVIji0HfC5ndxIaXn
         6kBpF+HlhIgmd4HWizZSBHuMKCp5LzLv8mBO+9j8KNqjLZQgvIB3wo6funG5d23SoOTL
         mc5/3CH7+M96VThlAyeMHxpuc2nYI9TIgSssswNZ2QHLdJwscLU338n1vcVLbYofOZED
         SlEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=icna4+Gu1RP4+DJwZuedByDksSgjiCoE4+VfX4uy3uQ=;
        b=zVekQthDA9MFFjIH8wwXrpko9Y0+mhjKISeRo+22sav1ECCjs9DCx4BYeCrGgC0xSh
         lmj1TOu2h7Wm1sVp5xzOszI8x/Ijp5lACLOc9ENYX2DT8+3LjokY/nrlLqVK1S4mcSfm
         U6p6u+UukRnVAHnqymT0/nM6ojY99UdN8FJfh8It/SmVHYyM627b7sIVzEXIsPHAeifi
         65uqfiJC0GoqofvSVVKJALZAs1VfNzgacBajTqIp5cVsHO59iUMjHwxg3lI6teXc6kqC
         UH80HZRxKloftfJwUO5ajDKKvLuO68dFSa2sguVqz9vsheI+hg4lQm+30V+f6l87jSFK
         fHyg==
X-Gm-Message-State: ACrzQf1FcV+zaa2uuVrhzarkY1rfOZmfBD5BgQqtFrKpFj3NweZ41Ai9
        4fmlaGfA2W21nlXlcrCPw423QQ==
X-Google-Smtp-Source: AMsMyM4klZhTIJ0yPhdf8WAZkt1M9acIUdCSr6cgqic2Drgj+d80HK9U/cTmZ8vTwu6Gr8gNAnfelw==
X-Received: by 2002:a17:902:ccc4:b0:186:6fcb:3fcf with SMTP id z4-20020a170902ccc400b001866fcb3fcfmr38985186ple.100.1666917261012;
        Thu, 27 Oct 2022 17:34:21 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id h4-20020a056a00000400b0053e4baecc14sm1723064pfk.108.2022.10.27.17.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 17:34:20 -0700 (PDT)
Date:   Fri, 28 Oct 2022 00:34:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>,
        Colton Lewis <coltonlewis@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 8/8] KVM: selftest: Add a test for
 KVM_CAP_EXIT_ON_EMULATION_FAILURE
Message-ID: <Y1sjicBP104CUAtM@google.com>
References: <20221018214612.3445074-1-dmatlack@google.com>
 <20221018214612.3445074-9-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018214612.3445074-9-dmatlack@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

s/selftest/selftests

On Tue, Oct 18, 2022, David Matlack wrote:
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index c484ff164000..22807badd510 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -16,6 +16,7 @@
>  /x86_64/cr4_cpuid_sync_test
>  /x86_64/debug_regs
>  /x86_64/evmcs_test
> +/x86_64/exit_on_emulation_failure_test
>  /x86_64/fix_hypercall_test
>  /x86_64/get_msr_index_features
>  /x86_64/kvm_clock_test
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 90c19e1753f7..55b6f4efa57c 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -81,6 +81,7 @@ TEST_GEN_PROGS_x86_64 = x86_64/cpuid_test
>  TEST_GEN_PROGS_x86_64 += x86_64/cr4_cpuid_sync_test
>  TEST_GEN_PROGS_x86_64 += x86_64/get_msr_index_features
>  TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
> +TEST_GEN_PROGS_x86_64 += x86_64/exit_on_emulation_failure_test

We really should figure out an automation solution, both for .gitignore (easier)
and for selecting which binaries to compile.  The makefile especially is getting
unwieldy.
