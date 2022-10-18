Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB7796030AF
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 18:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiJRQVV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 12:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiJRQVT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 12:21:19 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B179DB2DB5
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 09:21:16 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id r17so33495922eja.7
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 09:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DMD6KRfAh8gLsTdSq1azk8KGRzliZHblOOH99fliBBo=;
        b=eBasbqc45ny3TsN5xHvPYR0nIt0QFeQUPu9c7yPZZOds5097P3BJ2iGt4wRvIS9tEs
         MQXUQQUsNjgY0fpAODB0YF3wYff2bSXANslnUInSERSXgNnTuN5AIVlIdXP/iz/aI3X+
         GpQJ3Rs0eYEM+gfkzYqhYJfC46Px/ETHHCZsR7P0im57GjJyGQG1iBRY1b88haggOhOg
         1qBG96EWS/D8Vm75+m1lJZ3sDzKcFMccO7Dwzdyd0eOs+FHM9TASIL+jgiicEDBZuNhV
         RwL9DybM9+ce3O9iDMzolgdPgxOhI5kXqeP1WGQ70AQkXlbD5KDc5OFbEUaBjCOtaGYE
         zozg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DMD6KRfAh8gLsTdSq1azk8KGRzliZHblOOH99fliBBo=;
        b=3KgEeMmj+YK5GikATpyGaOYK6E5kBNZxZgpaMIJu9TH161mT6kwiA8IXzzTUNS6Vmf
         eEbQDaOwHgHBaWRmGnhhheofjfAQ/qN5/OrKOAi4r8pr5Mrd0kO61pfo/zdVcg3Ttkqs
         5Kmb8izExvFgesgPiN/VOJ1cpFbMgaPuAE9i02sC7nI1WyTxS05cUtwqBNO3TalxAIDG
         xja78hZE3qys71jOtbkx8OGAVtnYLfGFKsd8tP/gDKh1cltF+yl6cLdBGM0gvM5FEvz1
         pdmfwr0dzNxUVyGKGpC/gqIl3IEO3BbWbFflrqxSjb2ywoJeDKLsE/6qSyhQ2KPSLrfK
         uGOg==
X-Gm-Message-State: ACrzQf3G9s0Fw2ZRk+DdnZYTQVgXah6Ilj5YTKPFkzc2nmQO+jcYbjU0
        7vH5Po63+BNbslxOSZRsvhOAqQ==
X-Google-Smtp-Source: AMsMyM4R1wfcxR2Oe0g2nQCwfd6EAIfKtbPVegiEAjUE+BZ0OMN8V8O7plKwhNwKvZQiCe6VCI2RRA==
X-Received: by 2002:a17:906:8a4b:b0:78d:d475:ff74 with SMTP id gx11-20020a1709068a4b00b0078dd475ff74mr2983068ejc.131.1666110074863;
        Tue, 18 Oct 2022 09:21:14 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id fy19-20020a170906b7d300b00781dbdb292asm7716920ejb.155.2022.10.18.09.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 09:21:14 -0700 (PDT)
Date:   Tue, 18 Oct 2022 16:21:11 +0000
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
Message-ID: <Y07Sd6lVfD4IUywQ@google.com>
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
> +struct pkvm_hyp_vm {
> +	struct kvm kvm;
> +
> +	/* Backpointer to the host's (untrusted) KVM instance. */
> +	struct kvm *host_kvm;
> +
> +	/*
> +	 * Total amount of memory donated by the host for maintaining
> +	 * this 'struct pkvm_hyp_vm' in the hypervisor.
> +	 */
> +	size_t donated_memory_size;

I think you could get rid of that member. IIUC, all you need to
re-compute it in the teardown path is the number of created vCPUs on
the host, which we should have safely stored in
pkvm_hyp_vm::kvm::created_vcpus.

> +	/* The guest's stage-2 page-table managed by the hypervisor. */
> +	struct kvm_pgtable pgt;
> +
> +	/*
> +	 * The number of vcpus initialized and ready to run.
> +	 * Modifying this is protected by 'vm_table_lock'.
> +	 */
> +	unsigned int nr_vcpus;
> +
> +	/* Array of the hyp vCPU structures for this VM. */
> +	struct pkvm_hyp_vcpu *vcpus[];
> +};

Cheers,
Quentin
