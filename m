Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E7D4AF90A
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 19:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238655AbiBISLG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 13:11:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238711AbiBISLC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 13:11:02 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CFA9C05CB82
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 10:11:04 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id c3so2915591pls.5
        for <kvm@vger.kernel.org>; Wed, 09 Feb 2022 10:11:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5oY+tYRFthah59PWP99vpDNgjsdfGaS6KaNNBy4kyZY=;
        b=aIJ24nni0G/fFJt3Fk+Xrt1tAddfS8z21PSTPIGPtEOhxBCBIEnzhKwiV19vmBX7MT
         oISG6XEqBsvTSfcGjfrNRzVUmG4G7AVBM0gFg4LHytZ9J5bSvcffaPEM5cml6AqH0occ
         w77hsSKNqCJOr56BrPDZw2uhnmAomC7Hk8H/pOEYde30JF755leO6n1GwZiJy7c+3J8K
         DyQ3vUw/cNfbmWx0UoC0QRlfTTinQmhcd3MzcizC76fS4GKfwPQTqUlQmYwlDDkf/jGD
         tamup+L/i7ikb7HssLBKpqu9jRU4kCPaWb0CzSItdYdqcUxapMlQyZSwhQWZ27JVJnNb
         U4wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5oY+tYRFthah59PWP99vpDNgjsdfGaS6KaNNBy4kyZY=;
        b=lkW+3JdljKVLq2pELAmS5sB2XSr6KPUZLnuQaFxw2xqAvsXB2uiCY99gkbE46+uFr6
         /VMUi32iwAo/Lez4PEIWLFRb9FwZ0qCSGhyoxaClPlBJ+d+kKlv+YQDa0F92RX+M9/BC
         5zPiKPiG0V0E288mZNApyNX0aiPtMhgMKw9i4RLWRfJPJWVKFwJx5pJbSTc2tzZi2gvU
         R5nyxWavS4C95d4oiBklUfLqK9p+TeJh1o7J4TfDOFguuTgZsTlzNOFFebY0sUuvmr/j
         or1qRSrO1IlXCGAaF1tEeK8De9KiRdbWFoXgRsmKvOeZhtKyXAmmzI7qKpcUioi8jKyT
         4E5g==
X-Gm-Message-State: AOAM5334rL+irI2E5+lrpnFMWgBN+GLp0/jkFgSBcqAcN280TgGoLHmM
        MJgojnc6pQlVQeSGA+0aRI7PDw==
X-Google-Smtp-Source: ABdhPJw5SX55TSX40RJDqvn5ur0+05uMulApiGgLUV22l/7HKoDCbNKoi1CdN2tzogRriUQTKhyblA==
X-Received: by 2002:a17:902:dac7:: with SMTP id q7mr3279304plx.125.1644430263971;
        Wed, 09 Feb 2022 10:11:03 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id my18sm6854817pjb.57.2022.02.09.10.11.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 10:11:03 -0800 (PST)
Date:   Wed, 9 Feb 2022 18:10:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, kevin.tian@intel.com,
        tglx@linutronix.de, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/5] KVM: x86: Move check_processor_compatibility from
 init ops to runtime ops
Message-ID: <YgQDswKRZrTnbmeN@google.com>
References: <20220209074109.453116-1-chao.gao@intel.com>
 <20220209074109.453116-2-chao.gao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209074109.453116-2-chao.gao@intel.com>
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

On Wed, Feb 09, 2022, Chao Gao wrote:
> so that KVM can do compatibility checks on hotplugged CPUs. Drop __init
> from check_processor_compatibility() and its callees.
> 
> use a static_call() to invoke .check_processor_compatibility.
> 
> Opportunistically rename {svm,vmx}_check_processor_compat to conform
> to the naming convention of fields of kvm_x86_ops.
> 
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
