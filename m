Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7DCC604C6F
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 17:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232428AbiJSPz2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 11:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbiJSPyx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 11:54:53 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C154E179998
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 08:52:44 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id a13so25963924edj.0
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 08:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D+geK99fBWdp7S2zDM4C3VUidei1SsKnOz1jjdUkhRw=;
        b=dEWV1sDV4kXLHev/Hf0F6/5EgNkXk+jSP5MubJFT1mtMEzrd0Su4L67vw2Cu3FelbA
         7JmGBptdA8n2GhuqqwsT+tOLg5EgVgcAOGWmObLcsrHzKtFDkcKCWl/FITqP53I2kx78
         V8/ZR1YpLgWj+N1ehWQQxqhOAZm4k9knX4TyFTeq3qO52XO5fnUjnaWt1U4TmMijI0uW
         sumVPG5JW5pMYkXeZvOWn7acri4szVe4PDz+ky/QjGRxpy4p+lgLcQcsPtFoI0urf1KU
         OMsJt0D9Cy0S4J+l0z/P3cNydADbJIVuFRhvlzvuFVEwFkZ9stQrrOent6f6qfFNAIfF
         jsPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D+geK99fBWdp7S2zDM4C3VUidei1SsKnOz1jjdUkhRw=;
        b=4cJwbT4BAjXwxBzXVnXZkipJEkTXgS+xbivNIwBZ1B58SS/wDNZY3IzEhVOdoc66zj
         niZyAoccuM/rHaVibUt787LAD9rTg2hRPTuxfK8664Qo3VeH5kSFz4IYPJrT4bK3i8rq
         37+mOZMZp5Ejm3HhQefMqaOrcFkqaf+EZDRV949TooM/ZDgt/MpkKF7q2P3Q3FlnTsWd
         HXzDLFvvQqHW53487Kfu9prH1l0jErQ4+AM8gwz2GYiMi4cl18fN2Ysw7GTt/zILUQde
         lvQH4PP5UWHy/3Co4Jra03sGUf5Ka8hI0oHDXHRYGQS6jEdw/fdjB0IONRGxM9pjJVK1
         qdXA==
X-Gm-Message-State: ACrzQf3z7OH35PzEHQWeHAjG/fecdrYkpJYVQNnJBLAgPivjLvzXXS5I
        QgWlvtT9ylJL8J4STlzpXWkHIw==
X-Google-Smtp-Source: AMsMyM5mBhT44kMTTWFESMD5g2Ta35xFYhiWJ7bOcxwEInRQ0foBv9qN42gqGXbQVduas/FNl/oLJA==
X-Received: by 2002:a05:6402:c7:b0:457:cd5d:d777 with SMTP id i7-20020a05640200c700b00457cd5dd777mr7922898edu.245.1666194733534;
        Wed, 19 Oct 2022 08:52:13 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id v2-20020a1709067d8200b007815c3e95f6sm9274435ejo.146.2022.10.19.08.52.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 08:52:13 -0700 (PDT)
Date:   Wed, 19 Oct 2022 15:52:10 +0000
From:   Quentin Perret <qperret@google.com>
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 20/25] KVM: arm64: Return guest memory from EL2 via
 dedicated teardown memcache
Message-ID: <Y1AdKgqANCzlv/7Q@google.com>
References: <20221017115209.2099-1-will@kernel.org>
 <20221017115209.2099-21-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221017115209.2099-21-will@kernel.org>
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

On Monday 17 Oct 2022 at 12:52:04 (+0100), Will Deacon wrote:
>  struct kvm_protected_vm {
>  	pkvm_handle_t handle;
>  	struct mutex vm_lock;
> -
> -	struct {
> -		void *pgd;
> -		void *vm;
> -		void *vcpus[KVM_MAX_VCPUS];
> -	} hyp_donations;
> +	struct kvm_hyp_memcache teardown_mc;
>  };

Argh, I guess that somewhat invalidates my previous comment. Oh well :-)
