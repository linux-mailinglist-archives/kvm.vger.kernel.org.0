Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECB5F6030EF
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 18:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiJRQpe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 12:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiJRQpc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 12:45:32 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4FF69D50D
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 09:45:31 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id r14so21368118edc.7
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 09:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OCJsHqR3fQYSgnggViyn3fMnrEwEtr4DogQg4RXYXfU=;
        b=OTRdidlgd4M+FwW6O5/QmVZjVoFUteHzrGjxAXNpavm6P0/bJ2oKKpVtri2Z7qkcWS
         5JWQYnY7afyOrgZhzZHFjmw9efVV2gjkQeFaMP+fmwcjwuS82qAivOdVz5DIm0te1MzR
         Pwchuxk3ooNK3QdvuAjNh9l1YqcgHyan06709W1zjjCD+KSz3zjOVbT3bqFpQ2yp4hIC
         qbJxL5Oy7NcTMET5jxqyahqZNxTVKcYbOiWxUa0zcvNgixzWyb14gNlz2O+9P7yC8xtY
         EREtg4jooDmz6U6w/mtou9+3RUms1DMcQaOFJyWn+75HCVGcEWNWxCPIirthBvftBJoq
         VGaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OCJsHqR3fQYSgnggViyn3fMnrEwEtr4DogQg4RXYXfU=;
        b=SHwGylS6ccopqPUl0byc67SSXoYqOEywNIzymTzSv4M+8rzBhLkm2vFLnJ1p/Zhlls
         mjgb18f4B9L798/w+E0lGhz8X0nZHAdYnjvPXkQbLsd3lkoSe/ic1AoJ8mgMjRF+E1L3
         8ebaRj7a44pDGSoXGfTlKKgGaA3q5nIiTtZtcbmIA95TXM06eX2RhQCzG0IRp+sDmLeY
         uNk4E0SxK3GBZ2VXU5IxpsPaAEDn4Nwbe+CKllIUR1rj3c2Cv5ibP4S3aTHuT1UxfyQp
         0YyX2A0UeOE0PtkI1H6qk7ZbnKu+gtsfVfmXPZmkEQ+8FsdPkyf3IWhIAhQXvNP56Tq/
         3EcA==
X-Gm-Message-State: ACrzQf33mKx7yBmdCzP5Z7jXsheHAgdL8lN5cHBDor+11QIHu1zaX4/7
        bcnxniyE4+d3B3EjoWp1Z0pMAA==
X-Google-Smtp-Source: AMsMyM6I0P0S9DziDRNVM+YYRXKEEihJKzfSjWKlLw6I00yhLT/182go6gfMS7BANtRyQPharE/Otw==
X-Received: by 2002:a05:6402:909:b0:435:a8b:5232 with SMTP id g9-20020a056402090900b004350a8b5232mr3457453edz.240.1666111529948;
        Tue, 18 Oct 2022 09:45:29 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id hx15-20020a170906846f00b0074134543f82sm7856285ejc.90.2022.10.18.09.45.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 09:45:29 -0700 (PDT)
Date:   Tue, 18 Oct 2022 16:45:26 +0000
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
Subject: Re: [PATCH v4 12/25] KVM: arm64: Add infrastructure to create and
 track pKVM instances at EL2
Message-ID: <Y07YJvEsUnjSasA0@google.com>
References: <20221017115209.2099-1-will@kernel.org>
 <20221017115209.2099-13-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221017115209.2099-13-will@kernel.org>
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

On Monday 17 Oct 2022 at 12:51:56 (+0100), Will Deacon wrote:
> +static int find_free_vm_table_entry(struct kvm *host_kvm)
> +{
> +	int i, ret = -ENOMEM;
> +
> +	for (i = 0; i < KVM_MAX_PVMS; ++i) {
> +		struct pkvm_hyp_vm *vm = vm_table[i];
> +
> +		if (!vm) {
> +			if (ret < 0)
> +				ret = i;
> +			continue;
> +		}
> +
> +		if (unlikely(vm->host_kvm == host_kvm)) {
> +			ret = -EEXIST;
> +			break;
> +		}

That would be funny if the host passed the same struct twice, but do we
care? If the host wants to shoot itself in the foot, it's not our
problem I guess :) ? Also, we don't do the same check for vCPUs so ...
