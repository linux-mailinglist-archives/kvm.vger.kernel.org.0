Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9C6A70546B
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 18:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbjEPQ5o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 12:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjEPQ5n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 12:57:43 -0400
Received: from out-42.mta0.migadu.com (out-42.mta0.migadu.com [91.218.175.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EDE97EE1
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 09:57:41 -0700 (PDT)
Date:   Tue, 16 May 2023 16:57:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1684256259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NDIE3ahIKehh4iPVhNy4p8uW83fWb/ed7CSIdO7QIGc=;
        b=qk4ljCIJjJyU9l/f17uF6YaXKw0X9/VSGtVru/t9yLRSbSsvC/SGdwFUDiVJeCfksvXfBv
        rJUO+2BrqvzybVXkNVniFxbIcUW0wnrkKfguBylLQE7HKOzdGV7LH0gbwsMB3wxRHnPIdO
        FkEwVDXb4ocWgPmBAirQc3KeqIfPOUg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v8 0/6] Support writable CPU ID registers from userspace
Message-ID: <ZGO1+nx/qOpTMQa2@linux.dev>
References: <20230503171618.2020461-1-jingzhangos@google.com>
 <2ef9208dabe44f5db445a1061a0d5918@huawei.com>
 <868rdomtfo.wl-maz@kernel.org>
 <1a96a72e87684e2fb3f8c77e32516d04@huawei.com>
 <87cz30h4nx.fsf@redhat.com>
 <867ct8mnel.wl-maz@kernel.org>
 <ZGOv4ZA9qxcC5wKv@linux.dev>
 <86zg64kyyi.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86zg64kyyi.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 16, 2023 at 05:44:53PM +0100, Marc Zyngier wrote:

[...]

> More seriously, I'd expect this to be an ARM spec. But it wouldn't
> hurt having a prototype that serves as a draft for the spec. Better
> doing that than leaving it to... someone else.

Completely agree. My suggestion was not meant to discourage prototyping,
just wanted to make sure we have line of sight on making this someone
else's problem to standardize the interface :)

-- 
Thanks,
Oliver
