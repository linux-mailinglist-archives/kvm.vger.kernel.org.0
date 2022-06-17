Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84E7C54FB08
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 18:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383252AbiFQQ2s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 12:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383253AbiFQQ2q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 12:28:46 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DEC341FAB
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 09:28:44 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id 73-20020a17090a0fcf00b001eaee69f600so4603364pjz.1
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 09:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ikdZWQajtcXHyKH9cwfe1WfBf7z5hZlJ5ctRUGfamlg=;
        b=bKOqTm4VHtoh+tNs1+zszHl4qT0YMrNAovePO+NULfamQiOqwVXuW1ln4Bh/4sKdg0
         cXGRAf02ro+LfrtUjyEvIJ8kgm0ihYvyksME03mbgpmFBvPrCeOwvSFy27O14i6EDfBb
         qmJmtctX4Dp/Djfs7qZDcEaw85XVtdDf1wPxsF8ddJ1UXcuevlDnld5OMTw6qOhWdEXe
         wB+0CoejzSloI3rmuMW/4ZmyOhQWfWc05l9xlSBjQXdGTHA7scPn/f8qaaIzkclLsSaT
         xhZjNKq1t7QNzRvCIgNsNn55ViSkKG+k50D+hlZrYOUIdBeds9EMX0EceU6RLhnp6FmE
         842A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ikdZWQajtcXHyKH9cwfe1WfBf7z5hZlJ5ctRUGfamlg=;
        b=Zn7rjOkJDoj3VjP4gw6vYYfvqwO69zyQ8Vwp1uo9biexX/ynir7GWgPFYXTAzXVhcO
         FDqKKmXqNlY18wUhMKDKGmuLmyNJWTtTwRxWK5OVINpPiXcoXhj9m1e5/TafLAU6sJt3
         gwNR3S3wE2FLoBjqQn2A7wqtfrJQsU3BFOKdUzB/+z7a94B1im4dVE/6JmFTI/0fn54v
         vzM+yR9Dm/sLC1iciSekjgASGYxPSMT5YZc62RmFAhxSNqL/H5V8jj6nK5ACU9rg8Ibp
         yRwg7QFjBMUcmcHkQupjYD9TDQ9LKhtVwYhc+iqrCaOjQmMVj2AUU5v26uqRAhvMZPTM
         keZQ==
X-Gm-Message-State: AJIora92SItQBSGwiDrWNDwRApOdARqFdKnvVJHb7CLmC5+wry2uldmU
        NVTHF62AkmfnE2WmR9PZPqa+MQ==
X-Google-Smtp-Source: AGRyM1uxx3rxCTzmjYp2x2InU4H6kqXPbe9/j3UBIM4H5kEze44ULSzDQhVLhvnKHdaDYluwfj0+MQ==
X-Received: by 2002:a17:902:efc6:b0:167:8177:60a7 with SMTP id ja6-20020a170902efc600b00167817760a7mr10319625plb.110.1655483323741;
        Fri, 17 Jun 2022 09:28:43 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id a11-20020a056a001d0b00b00518895f0dabsm3877205pfx.59.2022.06.17.09.28.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 09:28:43 -0700 (PDT)
Date:   Fri, 17 Jun 2022 16:28:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Red Hat Product Security <secalert@redhat.com>
Cc:     mingo@redhat.com, bp@alien8.de, pgn@zju.edu.cn,
        pbonzini@redhat.com, wanpengli@tencent.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        kangel@zju.edu.cn, syzkaller@googlegroups.com, jmattson@google.com,
        vkuznets@redhat.com, dave.hansen@linux.intel.com,
        linux-sgx@vger.kernel.org, jarkko@kernel.org, joro@8bytes.org,
        hpa@zytor.com
Subject: Re: 'WARNING in vcpu_enter_guest' bug in arch/x86/kvm/x86.c:9877
Message-ID: <Yqyrt71TG1v0gPSf@google.com>
References: <25270242.531.1655475119097@app133160.ycg3.service-now.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <25270242.531.1655475119097@app133160.ycg3.service-now.com>
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

On Fri, Jun 17, 2022, Red Hat Product Security wrote:
> Hello!
> 
> INC2131147 ('WARNING in vcpu_enter_guest' bug in arch/x86/kvm/x86.c:9877) is pending your review.
> 
> Opened for: pgn@zju.edu.cn
> Followers: Paolo Bonzini, seanjc@google.com, Vitaly Kuznetsov, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, tglx@linutronix.de, Ingo Molnar, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, jarkko@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org, kangel@zju.edu.cn, syzkaller@googlegroups.com
> 
> Mauro Matteo Cascella updated your request with the following comments:
> 
> Hi Sean,
>  Thanks for the fix: https://github.com/torvalds/linux/commit/423ecfea77dda83823c71b0fad1c2ddb2af1e5fc [https://github.com/torvalds/linux/commit/423ecfea77dda83823c71b0fad1c2ddb2af1e5fc].
> Is this CVE worthy? As /dev/kvm is world accessible and unprivileged users could trigger the bug IIUC. We (Red Hat) can assign one if needed.

IMO, it's not CVE worthy.  Unprivileged users can trigger the bug, but the bug
itself is not harmful to the system at large, only to that user's VM/workload.
The splat is a WARN_ON_ONCE() so it won't spam the kernel log.  panic_on_warn
would be problematic, but assigning a CVE for every WARN seems excessive.
