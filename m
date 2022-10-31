Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8FD613DA4
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 19:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbiJaSrD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 14:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiJaSrC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 14:47:02 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F83213E14
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 11:47:01 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id k15so3383285pfg.2
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 11:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OD+Dj6QiqQPcqUwOclLcNaDdFbYYrYUChNSiJbOcpjk=;
        b=MmCFekFLbUuohkmlHUThG37fqm1rxlUpqslpZv9CWTa/v26nXUdjpHv6eNdc8/PJtn
         I2prhfaNkukF8aWSGoDe3ZPxGua9A8jA+3U+unJxUeUzL6QV43+Ck5Iv9zi8dnTe+NYu
         0w1H0ZqxlQbgZmhQv7eTrsz0CuqPMA7pRLWezCFJhK3nLQGNn2eWspfKpG0Ux361GVHz
         9UTmRjOh1YqraEz2+Y1NMAZgAP04PHibnLksQrvJh1rJFcd13Rt2+1mVeC9glFCNkAJ2
         XMnoLzr+l1fEsGsd8vbfUxJO8jMWdRz2AW397dtiVTelWFgGiCPMA61RJaMQi4qch2I/
         IOjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OD+Dj6QiqQPcqUwOclLcNaDdFbYYrYUChNSiJbOcpjk=;
        b=hccaC1CDOBv9y7hcarHw4E0xj26lEqdsXNM+67qIK5z8uV9KvmKHnIV/DommKwvrHl
         fMO3j1sk7uKIEdSTJcsSr230UhhATDV7hZKg5R+Uy1GhiFgLHqSwdbxmem5htaOVu6Ut
         SchS5J0dIB4QwhJEGloQLHVQIDRgKjvyu/5byz8EvyecUYze55AdmMf9sX2UyvR7/ANQ
         rJ+azurB02dfjnUo4+P8IuLKoUhjjmETBBELEwZ+i5vB3SK0oxXSj26yatTtgD+qlWL6
         XE32A20nUN5NJ9Y1ezsRyVmvm7UsbEhgtpAyF00rXlh0TVS/MWXyVZy/4iWBs9M65qUX
         oUZA==
X-Gm-Message-State: ACrzQf1bbJYN+t32/mHSf5spFgDipf0krcLU891NcliHubLuzEkIl7sH
        PFPGzOlE6Qp/bmsS6/jWm0ThX0gWJfx92A==
X-Google-Smtp-Source: AMsMyM4htz0IkD7YSKcI/7Xm9dLC93O2StWjcFH36bHWeLHkCtn/nHx1byMNzCL16k2BSRcfoK8fGg==
X-Received: by 2002:a05:6a00:14cf:b0:56d:88a8:32cf with SMTP id w15-20020a056a0014cf00b0056d88a832cfmr4973710pfu.27.1667242020859;
        Mon, 31 Oct 2022 11:47:00 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id z190-20020a6233c7000000b0056ba7ce4d5asm4959985pfz.52.2022.10.31.11.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 11:47:00 -0700 (PDT)
Date:   Mon, 31 Oct 2022 18:46:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     pbonzini@redhat.com, dmatlack@google.com, andrew.jones@linux.dev,
        wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 1/5] KVM: selftests: Add missing break between -e and
 -g option in dirty_log_perf_test
Message-ID: <Y2AYIbZrpd4heE1H@google.com>
References: <20221031173819.1035684-1-vipinsh@google.com>
 <20221031173819.1035684-2-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031173819.1035684-2-vipinsh@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 31, 2022, Vipin Sharma wrote:
> Passing -e option (Run VCPUs while dirty logging is being disabled) in
> dirty_log_perf_test also unintentionally enables -g (Do not enable
> KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2). Add break between two switch case
> logic.
> 
> Fixes: cfe12e64b065 ("KVM: selftests: Add an option to run vCPUs while disabling dirty logging")
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
