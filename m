Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDBD6A9461
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 10:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbjCCJqV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 04:46:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjCCJqU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 04:46:20 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A65B770
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 01:46:19 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id az36so1198629wmb.1
        for <kvm@vger.kernel.org>; Fri, 03 Mar 2023 01:46:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1677836777;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Rlu8PtRZf5UJyL60KngpFOw4CS6fsjOoK7SRwFml2s4=;
        b=jLYJo7rXTiA42dbXtWsh8mOHcTggzfeyvoDhCfgisV8SCVTzw0rsOo/pCSkhghPFOH
         lWanw1LuX5ivAGsVHi7WWYYAJrRIOH/ZJIvYfOGVHEnTLcfE0HYWIyJtlzrlbTQC5FZL
         tqs1hWKCwMnJqVEgL68ihFtOLSuJg+0fv18dFG4sM6kCgeBVWdLp9pIrXsVySgTLiDPc
         AmCHQjQCn0kuweiW6dp1gmKh705jsKpfy1ZaEEIdjuUX97igkfh1ozASaD90+knpMrYf
         h+6lTlXPr9XE6zrNtkQyBFt1z2ERNMVlJ/UsQ/zbDc54QxU+xRzrBt+SRniNSmp5eeXV
         svrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677836777;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rlu8PtRZf5UJyL60KngpFOw4CS6fsjOoK7SRwFml2s4=;
        b=YYOwySklviNL/G61be+LLR2P/5A6CD63zH7DfMq/KCNriXjh9rVaB7oze2zrIB2QlW
         RmCOtdhm394B7PFI0T27abzEcLhnAWZVEieR8FPv620j988a+ZKBrGUKXHG/59Aw+IHQ
         cz7pfaBE15HOhoq0jk1wAe153y0Bu3ZDqcsfOV9JscRt9IyyvOkE6pPwWyzQXtR6BDc5
         OTzVQBbMDV/EnVNUrdXwJl9/Fvmr9kNWh1uTOkEfeL4PQNyQ10TG0LLWiCXhrDL4R+Es
         vw8qZnElbihEoeTFdGm13w3GFyKHo5gIV2E/+fFRGaQlSQXA6WniCn7YTpvX8MhHlJCp
         aFLQ==
X-Gm-Message-State: AO0yUKXCQJyMTRqSpggYAYxGwjmT5FDbCzLNooCXZF7KG8FKET+s6Me2
        ZRol3POSBmZFmDciempM2cNIfw==
X-Google-Smtp-Source: AK7set/cpnwjuX7fSaoNvFw6A/hbtKjeIM5Ymf/9/ZQ+x+h+WhBRCjZlZUxPJkws3AKcfOSMvtL2AA==
X-Received: by 2002:a05:600c:3506:b0:3dc:405b:99bf with SMTP id h6-20020a05600c350600b003dc405b99bfmr1095246wmq.15.1677836777678;
        Fri, 03 Mar 2023 01:46:17 -0800 (PST)
Received: from myrica (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id r20-20020a05600c425400b003dc47d458cdsm1921298wmm.15.2023.03.03.01.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 01:46:17 -0800 (PST)
Date:   Fri, 3 Mar 2023 09:46:18 +0000
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Itaru Kitayama <itaru.kitayama@gmail.com>
Cc:     Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>,
        James Morse <james.morse@arm.com>,
        Joey Gouly <Joey.Gouly@arm.com>, Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Steven Price <steven.price@arm.com>,
        Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.cs.columbia.edu
Subject: Re: [RFC] Support for Arm CCA VMs on Linux
Message-ID: <20230303094618.GC361458@myrica>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <Y9PtKJ3Wicc19JF1@myrica>
 <CANW9uyud8RTkqgiL=64wV712QMxtAyubqeyCJ0vpcADJ42VqJA@mail.gmail.com>
 <Y/8Y3WLmiw6+Z5AS@myrica>
 <CANW9uysnvGCwANu+_6dp9+3rvHGOkThT9d0K2qpQV4exdmYWoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANW9uysnvGCwANu+_6dp9+3rvHGOkThT9d0K2qpQV4exdmYWoA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 02, 2023 at 07:12:24AM +0900, Itaru Kitayama wrote:
> > > I've tried your series in Real on CCA Host, but the KVM arch init
> > > emits an Invalid argument error and terminates.

This was the KVM_SET_ONE_REG for the SVE vector size. During my tests I
didn't enable SVE in the host but shrinkwrap enables more options.

Until we figure out support for SVE, disable it on the QEMU command-line
(similarly to '--disable-sve' needed for kvmtool boot):

	-cpu host,sve=off

Thanks,
Jean
