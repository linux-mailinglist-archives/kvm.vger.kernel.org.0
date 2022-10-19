Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B841E604C95
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 18:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbiJSQBV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 12:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbiJSQAw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 12:00:52 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6DA4E1A3
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 09:00:11 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id l22so25954787edj.5
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 09:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=O1cLnZm/LoMDz6+B+n/voHfjErB3lHfA2RpQhUASGvA=;
        b=QEfVmhM5sGU3Xc0Ip8XZ+3M85MM3WzsDLdEFW3/OAoq7D2HKb5EimjYNE7sB4wabyQ
         ZlHQaVlLKXDEtCh+ZZkYC5z9NFwm+WSCKWH5t2oFd8Kl5q8JrIzPaKiQhzbAiI/uq0Y0
         sJJU+pEMOHvIpNtacM8sw/bQrS+ML3efhbqVqQlZH5D9NN8ky4KyzOkuCuAgJPVM1Nvz
         TozCIkrRoDHYWCaMPkyWN9GQRlw7F0C1XlpVvJ63Xc642eXLgBdDwC3OUZdHDhc6L+9U
         ODt5w2q7btTathGgOFXcYTeddKewwVS0Xs2ttNN0sLafHgUsZOC/n6tvTuusev3NFqDk
         nD/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O1cLnZm/LoMDz6+B+n/voHfjErB3lHfA2RpQhUASGvA=;
        b=j2BjGOndq+bQqzPWYT2HOvdXkt8mHcsjVhcK+gMR7KHK/t+xEJIMBv+ieKCYIDyYwb
         EF/WH8wePwOQhVzchVl9voSI/EflwtPZu8e6k9mZ9BdNZhp80UTLtG7g+wywRp09H4rO
         m86v4NCn3X9zo11wJZoRg33k/B/t0D2C+9iwBr9zdIXqJouEKQKzEyMb2Jdzz6eW1W9X
         hd/1/6RtH6xH5VPMSZjU+7dXeYPSPIqmWXXezB0vhh32NUjTVigx+VuwsMGpvPz9fT4W
         Rb7Z+WZMdP0XSWc22M/LSRecp73MiLmHnySmzfxtgDjPIh3ljeCc0ObIVsYnRxH2Hml3
         Edkw==
X-Gm-Message-State: ACrzQf2TkEQ3UgPUexKrOLi2RYorFeCmW5d029pzGWgAHYHLsp0qOS30
        mrNfd7u9JndRxZVwHuN/l59/Og==
X-Google-Smtp-Source: AMsMyM5QMuc5Rbw4TEB4HtWjB3v+wmX3RoEZYauNqEalxnRU7JT9FpVZpYv0p3M9Zr/IdzmzP0TTcQ==
X-Received: by 2002:a05:6402:26d5:b0:45d:8d93:d5be with SMTP id x21-20020a05640226d500b0045d8d93d5bemr8108248edd.13.1666195209385;
        Wed, 19 Oct 2022 09:00:09 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id 16-20020a170906309000b0078d22b0bcf2sm9204303ejv.168.2022.10.19.09.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 09:00:08 -0700 (PDT)
Date:   Wed, 19 Oct 2022 16:00:06 +0000
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
Subject: Re: [PATCH v4 13/25] KVM: arm64: Instantiate pKVM hypervisor VM and
 vCPU structures from EL1
Message-ID: <Y1AfBrXcYlWBxig8@google.com>
References: <20221017115209.2099-1-will@kernel.org>
 <20221017115209.2099-14-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221017115209.2099-14-will@kernel.org>
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

On Monday 17 Oct 2022 at 12:51:57 (+0100), Will Deacon wrote:
> +struct kvm_protected_vm {
> +	pkvm_handle_t handle;
> +	struct mutex vm_lock;

Why is this lock needed btw? Isn't kvm->lock good enough?

> +
> +	struct {
> +		void *pgd;
> +		void *vm;
> +		void *vcpus[KVM_MAX_VCPUS];
> +	} hyp_donations;
> +};
