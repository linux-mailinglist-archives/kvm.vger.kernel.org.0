Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2883B681A21
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 20:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238301AbjA3TPg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 14:15:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238337AbjA3TPe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 14:15:34 -0500
Received: from out-233.mta0.migadu.com (out-233.mta0.migadu.com [91.218.175.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D57226A4A
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 11:15:31 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1675106130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E+5+M1fZRXIei8d8P6yWFfFsredz08+MOgbKH0fySN4=;
        b=D6FB6HU1V2MIGGiYr/nqB0udQo2NJe+R6gxeZ4MqMGy70deo6LZcB8qj/8O6+zVStbYekH
        5aVkrK9abBN4ecLrJkedOuR5kj84TvR4pDdOl5U1GHiZCmbWUxMOgMzGqDp/M88X2HIEwF
        l6hyoug6dttTUEyKsGiE86UVpRc4+jE=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvm@vger.kernel.org, Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>, pbonzini@redhat.com,
        paul@xen.org, alexandru.elisei@arm.com, maz@kernel.org,
        catalin.marinas@arm.com, suzuki.poulose@arm.com,
        james.morse@arm.com, will@kernel.org, seanjc@google.com
Subject: Re: [PATCH v5] KVM: MMU: Make the definition of 'INVALID_GPA' common
Date:   Mon, 30 Jan 2023 19:15:19 +0000
Message-Id: <167510336266.1083059.8287102674653927839.b4-ty@linux.dev>
In-Reply-To: <20230105130127.866171-1-yu.c.zhang@linux.intel.com>
References: <20230105130127.866171-1-yu.c.zhang@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 5 Jan 2023 21:01:27 +0800, Yu Zhang wrote:
> KVM already has a 'GPA_INVALID' defined as (~(gpa_t)0) in kvm_types.h,
> and it is used by ARM code. We do not need another definition of
> 'INVALID_GPA' for X86 specifically.
> 
> Instead of using the common 'GPA_INVALID' for X86, replace it with
> 'INVALID_GPA', and change the users of 'GPA_INVALID' so that the diff
> can be smaller. Also because the name 'INVALID_GPA' tells the user we
> are using an invalid GPA, while the name 'GPA_INVALID' is emphasizing
> the GPA is an invalid one.
> 
> [...]

Applied to kvmarm/next, thanks!

[1/1] KVM: MMU: Make the definition of 'INVALID_GPA' common
      https://git.kernel.org/kvmarm/kvmarm/c/cecafc0a830f

--
Best,
Oliver
