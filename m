Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9E295FA211
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 18:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiJJQl1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 12:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiJJQlZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 12:41:25 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316C6631F2
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 09:41:25 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id b15so10284232pje.1
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 09:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kBInphdFTXa+77vEzA8kMD40VeRTtiaezhjgTdUa2c8=;
        b=Ioiculmaz1YAb5NVneZFkhzIt6X3SGkkzMsJwSvkJM6hcobICfyHe8TyvymAj0qT6b
         ZUTFM5KCdpQ44aCQ6ZLyNYfcp7TdGyBlm6MHHCa9Xva8V7nYYCsWlnlGomhQ4vjy3ISU
         fofiNRh3k1oPiS7NFLW3+NnTgREVsoOmZgqppbAUpof32omJtwTC9CDvpj/rq5Uef4ea
         TrFijDKYWipyHQC0rTUk9udh11czrQEaL9YvVRs2irIIdadWKHS7KgNC0GeptcqF7p6+
         Az+Ht15iu3F4rgLfUy7OPBt3a6yh596fLSnKYBNDCWdRz1C67Mv05ysWrHYEgtGUi+kP
         IHFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kBInphdFTXa+77vEzA8kMD40VeRTtiaezhjgTdUa2c8=;
        b=2kRE/wR9KU0kxagtY7YqASyYjZOI5iFlg0a1WC69VyQ8ha/d77MsmDZ14/i3zSFEaz
         570+4YmlvVAnG895K520WZaDa6KwSqs2L3bSS43V/qjmZFknEZkbNRDKwyuRJAbJVEft
         gaEgo+zg0iRup0GOMu4mrxxAhECXvLNTxLC+H9blfZdBG7IaJDHmvPH8rUG9EMYlYHuD
         PUnfOIfQglxZVzePIYL1U75Nriq8R2Bvuy5kdtUkNuUfg4Cnwhn1JZb2oV49Be5TEZHf
         NLSNd3qXKKWjIR3BfuYcbSN6jwckVkLG8HyfG55Ly+Kh7Q5BVPiddQFQ5g2s8Azj4jLv
         sFLg==
X-Gm-Message-State: ACrzQf1JFBEYC9WKEroxZVzNEbObLzKRoxI4MuaZRUnuGekm36mXkJjO
        MfYF2E6S3bGzuw7PbP/Ry+O9aw==
X-Google-Smtp-Source: AMsMyM4hWhFMlChYX1VJsTIrwqLA5NexCdb9SNtPs67uwYmXA6KlZ7sCtrOQtTR2AySyoPBQZhFe3Q==
X-Received: by 2002:a17:902:eb87:b0:180:dfae:553a with SMTP id q7-20020a170902eb8700b00180dfae553amr14133045plg.114.1665420084555;
        Mon, 10 Oct 2022 09:41:24 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id g12-20020a170902868c00b0017f7f8bb718sm6818970plo.232.2022.10.10.09.41.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 09:41:24 -0700 (PDT)
Date:   Mon, 10 Oct 2022 16:41:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     kernel test robot <yujie.liu@intel.com>
Cc:     lkp@lists.01.org, lkp@intel.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [KVM] 21d4c575eb: perf-sanity-tests.Test_event_parsing.fail
Message-ID: <Y0RLMJW27AmKTgLQ@google.com>
References: <202210091636.2f13027d-yujie.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202210091636.2f13027d-yujie.liu@intel.com>
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

On Sun, Oct 09, 2022, kernel test robot wrote:
> Greeting,
> 
> FYI, we noticed the following commit (built with gcc-11):
> 
> commit: 21d4c575eb4a1e6d956b61b5e9c162895fa7d4ba ("KVM: x86: Print error code in exception injection tracepoint iff valid")
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> 
> in testcase: perf-sanity-tests
> version: 
> with following parameters:
> 
> 	perf_compiler: gcc
> 
> on test machine: 4 threads Intel(R) Core(TM) i5-6500 CPU @ 3.20GHz (Skylake) with 32G memory
> 
> caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):

What exactly is changing?  I see some "FAILED!" entries, but I don't see how a
commit that only affects tracepoint string output can be related to things like
"Lookup mmap thread".  If the issue is that the output change caused
"Parse event definition strings" to fail, and that propagated to everything else,
then this is effectively "working as intended".

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index d07428e660e3..385436d12024 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -376,10 +376,11 @@ TRACE_EVENT(kvm_inj_exception,
                __entry->reinjected     = reinjected;
        ),
 
-       TP_printk("%s (0x%x)%s",
+       TP_printk("%s%s%s%s%s",
                  __print_symbolic(__entry->exception, kvm_trace_sym_exc),
-                 /* FIXME: don't print error_code if not present */
-                 __entry->has_error ? __entry->error_code : 0,
+                 !__entry->has_error ? "" : " (",
+                 !__entry->has_error ? "" : __print_symbolic(__entry->error_code, { }),
+                 !__entry->has_error ? "" : ")",
                  __entry->reinjected ? " [reinjected]" : "")
 );

> 2022-10-08 04:47:24 sudo /usr/src/perf_selftests-x86_64-rhel-8.3-func-21d4c575eb4a1e6d956b61b5e9c162895fa7d4ba/tools/perf/perf test 6
>   6: Parse event definition strings                                  :
>   6.1: Test event parsing                                            : FAILED!

> 2022-10-08 04:48:12 sudo /usr/src/perf_selftests-x86_64-rhel-8.3-func-21d4c575eb4a1e6d956b61b5e9c162895fa7d4ba/tools/perf/perf test 19
>  19: 'import perf' in python                                         : FAILED!

> 2022-10-08 04:48:36 sudo /usr/src/perf_selftests-x86_64-rhel-8.3-func-21d4c575eb4a1e6d956b61b5e9c162895fa7d4ba/tools/perf/perf test 31
>  31: Lookup mmap thread                                              : FAILED!

> 2022-10-08 04:48:45 sudo /usr/src/perf_selftests-x86_64-rhel-8.3-func-21d4c575eb4a1e6d956b61b5e9c162895fa7d4ba/tools/perf/perf test 72
>  72: dlfilter C API                                                  : FAILED!

> 2022-10-08 04:48:46 sudo /usr/src/perf_selftests-x86_64-rhel-8.3-func-21d4c575eb4a1e6d956b61b5e9c162895fa7d4ba/tools/perf/perf test 75
>  75: Test dwarf unwind                                               : FAILED!

> 2022-10-08 04:48:47 sudo /usr/src/perf_selftests-x86_64-rhel-8.3-func-21d4c575eb4a1e6d956b61b5e9c162895fa7d4ba/tools/perf/perf test 80
>  80: build id cache operations                                       : FAILED!

> 2022-10-08 04:49:27 sudo /usr/src/perf_selftests-x86_64-rhel-8.3-func-21d4c575eb4a1e6d956b61b5e9c162895fa7d4ba/tools/perf/perf test 89
>  89: perf stat CSV output linter                                     : FAILED!

> 2022-10-08 04:49:51 sudo /usr/src/perf_selftests-x86_64-rhel-8.3-func-21d4c575eb4a1e6d956b61b5e9c162895fa7d4ba/tools/perf/perf test 94
>  94: perf all metrics test                                           : FAILED!

> 2022-10-08 04:56:05 sudo /usr/src/perf_selftests-x86_64-rhel-8.3-func-21d4c575eb4a1e6d956b61b5e9c162895fa7d4ba/tools/perf/perf test 101
> 101: Miscellaneous Intel PT testing                                  : FAILED!
