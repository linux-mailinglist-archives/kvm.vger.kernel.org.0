Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A856666F26
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 11:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238463AbjALKLe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 05:11:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239665AbjALKKy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 05:10:54 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9454218B39;
        Thu, 12 Jan 2023 02:06:35 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id v23so18654662pju.3;
        Thu, 12 Jan 2023 02:06:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cV8o0U4qTI0TxZVhOyY3mGcUb8HtKuRa5nMD5AUhlew=;
        b=qQ/v6lNiJNet1HvuPLvU1FPIrevnYcOKIkHSQk2V8J4GTjnJP+M7MVTyfYJeUX7LkH
         INy/oNEQf8hJnXNsloVokWrV9mRv5GbAAEsqSpY+Aul66jKzUrfeTTsD2ZDZjObPkdjy
         NDdcxqb5G/THcIvfRdBrtlLjEdqS3zWAm9z3gaNAcELaQ7ZHKpZlxK0Sd+/7+BBr3C7V
         mcsk1BchooJmSuA0deh7YErL3CCp/5Lbv1UBcVm6Weh8gCDfDvmsPXuPqPGYG8JUQX1U
         p/T2oa3qJHKdX83/nJRBwj2+oSvbpA1cJ2Ct2G+Zo/Gy6XsNDjDCgU4MG4j4ZFU+gxNE
         jZkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cV8o0U4qTI0TxZVhOyY3mGcUb8HtKuRa5nMD5AUhlew=;
        b=JjAzhEZU6U1s4pqpNadBVIjKNyCFUC0M2Q9/b4TqlTgooeaoZ7YgQvTxdzwAflQkf7
         SKyutwwiEjeqFW0JDdxssSgKjlfCUgA5caeApcC76MNjp3pnKvfR4my0UtzKThSQkqkc
         9OK04thDoxMI2nIezEKb+CTY0dCgAIlDoV3f8sJkxQzrtPujnIiCXUPe+1xQ8cJ7KDhE
         B4GBrHUow8/dM1NFjhNQbZjAt5G6zvKqaFx++Gn5Lctu6rRkHf/C96nk2VzHU8yWsELP
         cfqfcIGNqQlBHN1wDurXFUqoHSdKHRPXWHtI9XOt9NPoNcLbTI+luvFFRcIO+zvP4xD6
         WjBA==
X-Gm-Message-State: AFqh2kp3dAQbI1L9PEmJfDOJ1XZ7Kr8H89SwTv1GEi9DZtJBtbDY4X33
        PKN9aLPkZE++GNsx3ABHFzizK+9qshM=
X-Google-Smtp-Source: AMrXdXtMX25FVpi+IYvJ4DJIeOyXmH3amjHl7vyzS5i5YTergjM71gfDTqLWTyMzrVB4ChNI8oWBXg==
X-Received: by 2002:a17:90b:8d5:b0:227:252b:4fe4 with SMTP id ds21-20020a17090b08d500b00227252b4fe4mr10946648pjb.6.1673517994831;
        Thu, 12 Jan 2023 02:06:34 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id k36-20020a635a64000000b0048988ed9e4bsm9549402pgm.19.2023.01.12.02.06.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 02:06:34 -0800 (PST)
Date:   Thu, 12 Jan 2023 02:06:33 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Ackerley Tng <ackerleytng@google.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        pbonzini@redhat.com, erdemaktas@google.com, seanjc@google.com,
        sagis@google.com, dmatlack@google.com
Subject: Re: [PATCH v10 098/108] KVM: TDX: Implement callbacks for MSR
 operations for TDX
Message-ID: <20230112100633.GC2034518@ls.amr.corp.intel.com>
References: <1cacbda18e3c7dcccd92a7390b0ca7f4ba073f85.1667110240.git.isaku.yamahata@intel.com>
 <diqz5ydmov3m.fsf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <diqz5ydmov3m.fsf@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 04, 2023 at 01:20:13PM -0800,
Ackerley Tng <ackerleytng@google.com> wrote:

> 
> I believe we should also have a handler for .msr_filter_changed.
> 
> Without an .msr_filter_changed handler, a host crash can occur if we
> first set up a vcpu for the TD, and then set an MSR filter.
> 
> If we first set up a vcpu for the TD, and then set an MSR filter, upon
> vcpu_enter_guest, the .msr_filter_changed handler (currently
> vmx_msr_filter_changed()) will be invoked. to_vmx(vcpu) interprets the
> containing struct of struct kvm_vcpu to be a struct vcpu_vmx instead of
> a struct vcpu_tdx.
> 
> In my case, I was working on a selftest and the missing handler caused a
> NULL dereference in vmx_disable_intercept_for_msr() because
> vmx->vmcs01.msr_bitmap is NULL.

Nice catch. I'll fix it.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
