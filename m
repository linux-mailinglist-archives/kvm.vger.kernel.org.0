Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7A67B86E6
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 19:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233938AbjJDRqi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 13:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233497AbjJDRqi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 13:46:38 -0400
Received: from out-203.mta1.migadu.com (out-203.mta1.migadu.com [IPv6:2001:41d0:203:375::cb])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A1CFA7
        for <kvm@vger.kernel.org>; Wed,  4 Oct 2023 10:46:34 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1696441592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FkXfxAF8p4JcZ7Pgy7Z1Q9RH1IQGdPoaImpvpiU5zcw=;
        b=U4zjpIP83Uxl+7rjo0sTildgwacnqciJTm6QY/T3AeDFIuqjNRTfKwzbypYgy1si7Exq0O
        8YaE6RzMZhL5G8SofpSyVd0oTepEW7InblkabJTkS2QwlIlWLzC+TI8ZCkIjvjOZjHn47T
        DTm85bDbtssLEoIANq63HHfifD/tlg4=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev, Oliver Upton <oliver.upton@linux.dev>
Cc:     Zenghui Yu <yuzenghui@huawei.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v11 00/12] KVM: arm64: Enable 'writable' ID registers
Date:   Wed,  4 Oct 2023 17:46:21 +0000
Message-ID: <169644154288.3677537.15121340860793882283.b4-ty@linux.dev>
In-Reply-To: <20231003230408.3405722-1-oliver.upton@linux.dev>
References: <20231003230408.3405722-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        TO_EQ_FM_DIRECT_MX,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 3 Oct 2023 23:03:56 +0000, Oliver Upton wrote:
> Few more fixes that I threw on top:
> 
> v10 -> v11:
>  - Drop the custom handling of FEAT_BC as it is now fixed on the arm64
>    side (Kristina)
>  - Bikeshed on the naming of the masks ioctl to keep things in the KVM_
>    namespace
>  - Apply more bikeshedding to the ioctl documentation, spinning off
>    separate blocks for the 'generic' description and the Feature ID
>    documentation
>  - Fix referencing in the vCPU features doc
>  - Fix use of uninitialized data in selftest
> 
> [...]

Applied to kvmarm/next, thanks!

[01/12] KVM: arm64: Allow userspace to get the writable masks for feature ID registers
        https://git.kernel.org/kvmarm/kvmarm/c/3f9cd0ca8484
[02/12] KVM: arm64: Document KVM_ARM_GET_REG_WRITABLE_MASKS
        https://git.kernel.org/kvmarm/kvmarm/c/6656cda0f3b2
[03/12] KVM: arm64: Use guest ID register values for the sake of emulation
        https://git.kernel.org/kvmarm/kvmarm/c/8b6958d6ace1
[04/12] KVM: arm64: Reject attempts to set invalid debug arch version
        https://git.kernel.org/kvmarm/kvmarm/c/a9bc4a1c1e0c
[05/12] KVM: arm64: Bump up the default KVM sanitised debug version to v8p8
        https://git.kernel.org/kvmarm/kvmarm/c/9f9917bc71b0
[06/12] KVM: arm64: Allow userspace to change ID_AA64ISAR{0-2}_EL1
        https://git.kernel.org/kvmarm/kvmarm/c/56d77aa8bdf5
[07/12] KVM: arm64: Allow userspace to change ID_AA64MMFR{0-2}_EL1
        https://git.kernel.org/kvmarm/kvmarm/c/d5a32b60dc18
[08/12] KVM: arm64: Allow userspace to change ID_AA64PFR0_EL1
        https://git.kernel.org/kvmarm/kvmarm/c/8cfd5be88ebe
[09/12] KVM: arm64: Allow userspace to change ID_AA64ZFR0_EL1
        https://git.kernel.org/kvmarm/kvmarm/c/f89fbb350dd7
[10/12] KVM: arm64: Document vCPU feature selection UAPIs
        https://git.kernel.org/kvmarm/kvmarm/c/dafa493dd01d
[11/12] KVM: arm64: selftests: Import automatic generation of sysreg defs
        https://git.kernel.org/kvmarm/kvmarm/c/6a4c6c6a56c1
[12/12] KVM: arm64: selftests: Test for setting ID register from usersapce
        https://git.kernel.org/kvmarm/kvmarm/c/3b44c2008bf0

--
Best,
Oliver
