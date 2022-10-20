Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60286606A75
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 23:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiJTVqv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 17:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiJTVqu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 17:46:50 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4288622658E
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 14:46:49 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id l6so765884pgu.7
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 14:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HwnpFYWQDbBqf/HVke+KN92XJat8rq7IpPFgfqGLXV4=;
        b=AplpxoXDrCQ/SesytqkfgcV3522sEAF//LP8xkEam/FjSrvMZ9tfwf6xUFZ5ZusEhA
         M/2AYggZy0tw231owaLyuJtJVG5cW77xpByya+F/+5PiFujQIbMPyL3NxQ2rvnT1NPz2
         nJgU0twGpUteMBeAD0HsjL9GNiw29r1F0FnCR/sm3I5otT/Way3xBik6iqNjXDG8ePg6
         ZlOLLIvPzUr9kVNUHqkj+xMsifSG5uSLPrFwos4AKfI31Qe0mAXgVi+7kJtrdT0PdRfy
         Plf/GpshnPjyy44QoQ/XYq4JJuPZkeFbYF+bpNoPnmmxGLL8XjHB+RfQxSxeXL316VxO
         iJxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HwnpFYWQDbBqf/HVke+KN92XJat8rq7IpPFgfqGLXV4=;
        b=nQ88FNvBYs7sLmpdy8HUgNhPfyDATrhfrd4P6BBz4X6yZiYP6R7BtywFBn/Ku+0MTX
         SVlJjqHOyre2bHxpV7zZT50mzskyOBcti897xIRcT17AMIhk4P7ByGSxGTvRHbwsRnZ9
         4MCniiCGQmPU36MIuw8OBa1gg7iDverKf2S99QuGY6V3wEUoofovTMOw39P0oJdjOzfo
         pWOPmGmJcOdKTABKB2MrELvigsKW8ONrIdHDmohjq8pg8PILABxWjSvGSh8GEphji5QC
         OdxNUFonAGcbQTahQ6RuTLDbEazhco54suJfu1vgn4IWRndcs5Wn26+JacYHATHKA2WA
         hLRg==
X-Gm-Message-State: ACrzQf0bL0ATGJgovNci7wSqtXxb8eZZ4CDC0vFG9Yc0Zq9rS0yLY7uv
        hu59Ee2cjSWNfRrBLVt04fkoKw==
X-Google-Smtp-Source: AMsMyM4TyZwOyuQ6Ifu81kQ8Rjc33K17CGu+b1kM9e9Tlr5b2t8mypv9P2/U5o1Yzh36qvPs3J/cKQ==
X-Received: by 2002:a63:5a41:0:b0:430:673e:1e13 with SMTP id k1-20020a635a41000000b00430673e1e13mr13692789pgm.435.1666302408707;
        Thu, 20 Oct 2022 14:46:48 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id h9-20020a170902f54900b001788ccecbf5sm13554028plf.31.2022.10.20.14.46.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 14:46:48 -0700 (PDT)
Date:   Thu, 20 Oct 2022 21:46:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     pbonzini@redhat.com, dmatlack@google.com, andrew.jones@linux.dev,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/5] dirty_log_perf_test vCPU pinning
Message-ID: <Y1HBxL0frhyK3qhx@google.com>
References: <20221010220538.1154054-1-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221010220538.1154054-1-vipinsh@google.com>
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

On Mon, Oct 10, 2022, Vipin Sharma wrote:
> Pin vCPUs to a host physical CPUs (pCPUs) in dirty_log_perf_test and
> optionally pin the main application thread to a physical cpu if
> provided. All tests based on perf_test_util framework can take advantage
> of it if needed.
> 
> While at it, I changed atoi() to atoi_paranoid(), atoi_positive,
> atoi_non_negative() in other tests, sorted command line options
> alphabetically in dirty_log_perf_test, and added break between -e and -g
> which was missed in original commit when -e was introduced.

...

> Vipin Sharma (5):
>   KVM: selftests: Add missing break between -e and -g option in
>     dirty_log_perf_test
>   KVM: selftests: Put command line options in alphabetical order in
>     dirty_log_perf_test
>   KVM: selftests: Add atoi_paranoid() to catch errors missed by atoi()
>   KVM: selftests: Add atoi_positive() and atoi_non_negative() for input
>     validation
>   KVM: selftests: Run dirty_log_perf_test on specific CPUs

Minor nits on patch 5, but otherwise looks good.  Might be worth sending a v6
just so there's no confusion.
