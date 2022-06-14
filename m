Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAA6F54B3BA
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 16:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236244AbiFNOoU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 10:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356249AbiFNOnm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 10:43:42 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5728E1A391
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 07:43:39 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id v11-20020a17090a4ecb00b001e2c5b837ccso11966543pjl.3
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 07:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BjMtNFrHev59P8JrA6x8VC/0SCbAjmaVxOnzjl9xyPo=;
        b=Irznq41D4JwzODMvCXf615k4IPwoT+vhOuBFpX/HXdCybZvjLw0Lr5OLG3jsA0bVMS
         /16XhDGLJnqia6N6qcTeSXMWzDb2YMRq9UgQtL87ZmBWWKltGVUQackAegnoRONEebqb
         ahlEwP8S9yr8YzRfnXfwy+Q4qwfS19E+byrqNDhylt3wS/3R2IubBltEE6iPWJ7srJ7P
         FJXs0W/gOHaR52LWWWyPZvS8sEGZNqxtG9YP4DcVF3RVUJN58Q8kwY0ytuB0BsAdcERA
         FVi9LrYu7N3eW25n64y91pUgugjahf6tBxTDh53hot9WxhfpiMV4jBxdSA/nNOhgE6v/
         eaGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BjMtNFrHev59P8JrA6x8VC/0SCbAjmaVxOnzjl9xyPo=;
        b=OSUmiaHjFrDORDyM5CsXodtsSFsvihvhbc8LDxfgTh7qHBDxOVmW0lI1araWB3O424
         lTnSLwtvwjIcYdhCiPsOMGMhIh3PRfViQA8Uj8P57UQ4ol7tLQFBbUh17OhegGpV6iiu
         B1fq0f8ZInPD1oDReldL+kfArHIi1klFOIw31+AmwyKZSZRF9r+kAUCJAV6d/TAzi5bt
         FgHbERfeOBK8bF3eqOaPVCq6Bmlp+9GEol+vkjrhdMhRxm2SqjTK+VzXW4kA11q+ryzY
         GN4pErqAmFc9lIoee0VHXKYauvT2JSBjW8Fp5Kvv2oYvocLRXBLKDU7j5iJFk1UuZO44
         Youw==
X-Gm-Message-State: AJIora+wkJKew9ZsBAd7DSsq1h02wt9hW+2+84si7Md8STwXCDPNmhN+
        3cmdqHPD//K7v6IqiY1mDQXDlw==
X-Google-Smtp-Source: AGRyM1uQDmd+XTaC6ky7C2ZAFwv+iO59Og2nuLOoRelbEx7do9z41dETqk4zuyxaCtYrGu0CnaD3Rg==
X-Received: by 2002:a17:90a:a016:b0:1ea:97b9:6c1b with SMTP id q22-20020a17090aa01600b001ea97b96c1bmr4985018pjp.212.1655217818620;
        Tue, 14 Jun 2022 07:43:38 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t64-20020a628143000000b0051bbc198f3fsm7975713pfd.13.2022.06.14.07.43.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 07:43:38 -0700 (PDT)
Date:   Tue, 14 Jun 2022 14:43:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH] KVM: selftests: kvm_binary_stats_test: Fix index
 expressions
Message-ID: <YqielsFTtL6yhQmi@google.com>
References: <20220614081041.2571511-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614081041.2571511-1-drjones@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 14, 2022, Andrew Jones wrote:
> kvm_binary_stats_test accepts two arguments, the number of vms
> and number of vcpus. If these inputs are not equal then the
> test would likely crash for one reason or another due to using
> miscalculated indices for the vcpus array. Fix the index
> expressions by swapping the use of i and j.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---

Thanks!  I had done this locally but lost track of it when updating kvm/queue.

Reviewed-by: Sean Christopherson <seanjc@google.com>
