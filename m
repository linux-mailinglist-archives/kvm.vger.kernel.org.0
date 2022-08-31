Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2754B5A8705
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 21:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbiHaTyQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 15:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiHaTyO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 15:54:14 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E387EE6A1
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 12:54:13 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id z3-20020a17090abd8300b001fd803e34f1so317933pjr.1
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 12:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=i1fxz0Si79I0x6/Tol+AeOK8ljyJ1ydzgNsYRl83dw4=;
        b=nz4DrZ4pPGU/omZF1St7jI238P/OlFOfl94ByncU9Q1XJe4fKq9DtBBK2Sq97vu8Az
         Wy2vuPn1ekSvIdK+TqIUjuM4H111kod4RumfP2bxqhwbvAgrYp0Csy6hrXdsqe1ze5ja
         sE70n2wdT8pLG5wc64en7JUGFXmh/L4+s/zp4b5+VGXjCF+/BI/ypSC82egUpXaAn9Xo
         TBAHDEX4mZtDFi+KC1q1/klBQxwUdWreLeiuuPkdl3gzMt4vioCNhdoZX6fOEG4ZxRCz
         6QNfaEOXmYsyMDzYdQbhDqrAaWfev6wQvPa7BG88mGP56uIYjybyaUDVxwQ8rMS/RO6V
         XxYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=i1fxz0Si79I0x6/Tol+AeOK8ljyJ1ydzgNsYRl83dw4=;
        b=YwucekOX6xY9IVh9rvoLQLv4nIiAEFn/qYraTw8KBFDnwthaDQSEn73YgqSLTaL7h/
         Miqee59XCZS+xkSxPjSut0IsUQBwff/NNjpdDl+71k5idm+/GA9Y3Y/P7CIzDawMXXsX
         KotQmcWKhWx5vKHAWVTlTIluelTE4k2QK7l2AqFaiPlIiL6n1TSj6Uz6aZwAf61Av+2O
         VJRA0fTH8iA5HHAC6UtvCwdO7M3PQlmDiFUtdXxgBSWdAPaywZ4AqveGf3mQzREkFrSL
         +ZMW/jRWHR1S7OqKFUEghPSwUd0Bmm5CCrpXDB2vUyhp0akieuFdStBubJTgoYarovmT
         X5qQ==
X-Gm-Message-State: ACgBeo1vrmfE+g/24rQKIpqakRERqPHcv34ELwK1yUx7AmtsUvigzvOd
        KM4pCCOkLvcbT5EemvXnT43vZQ==
X-Google-Smtp-Source: AA6agR794xW6Z+MfG5Ib9/crU2BZBN5/rJBCdOsohFLApMk8X0TGCCHkHKAvwd3Y9PrLWVE0a3cZtA==
X-Received: by 2002:a17:902:e841:b0:174:9605:e96a with SMTP id t1-20020a170902e84100b001749605e96amr18478841plg.108.1661975652680;
        Wed, 31 Aug 2022 12:54:12 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id mn22-20020a17090b189600b001fd7cde9990sm1771283pjb.0.2022.08.31.12.54.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 12:54:12 -0700 (PDT)
Date:   Wed, 31 Aug 2022 19:54:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     kernel test robot <lkp@intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kbuild-all@lists.01.org,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Subject: Re: [PATCH v3 3/3] KVM: VMX: Advertise PMU LBRs if and only if perf
 supports LBRs
Message-ID: <Yw+8YMuhPRdTdLDv@google.com>
References: <20220831000051.4015031-4-seanjc@google.com>
 <202208311831.zQ4oCG1b-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202208311831.zQ4oCG1b-lkp@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 31, 2022, kernel test robot wrote:
> Hi Sean,
> 
> I love your patch! Yet something to improve:
> 
> [auto build test ERROR on 372d07084593dc7a399bf9bee815711b1fb1bcf2]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Sean-Christopherson/KVM-x86-Intel-LBR-related-perf-cleanups/20220831-080309
> base:   372d07084593dc7a399bf9bee815711b1fb1bcf2
> config: i386-randconfig-s001 (https://download.01.org/0day-ci/archive/20220831/202208311831.zQ4oCG1b-lkp@intel.com/config)
> compiler: gcc-11 (Debian 11.3.0-5) 11.3.0
> reproduce:
>         # apt-get install sparse
>         # sparse version: v0.6.4-39-gce1a6720-dirty
>         # https://github.com/intel-lab-lkp/linux/commit/094f42374997562fff3f9f9637ec9aa8257490a0
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Sean-Christopherson/KVM-x86-Intel-LBR-related-perf-cleanups/20220831-080309
>         git checkout 094f42374997562fff3f9f9637ec9aa8257490a0
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=i386 prepare
> 
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from arch/x86/kernel/../kvm/vmx/vmx.h:11,
>                     from arch/x86/kernel/asm-offsets.c:22:

Argh, KVM's "internal" vmx.h gets included by arch/x86/kernel/asm-offsets.c even
when KVM is disabled, and vmx_get_perf_capabilities() is oddly inlined there.

The simple fix is to move the definition of vmx_get_perf_capabilities() into vmx.c.

Long term, I want to figure out a way to break the dependency on asm-offsets.  I
ran afoul of this a week ago for something else, but couldn't figure an easy
solution and it wasn't (yet) a blocking issue.
