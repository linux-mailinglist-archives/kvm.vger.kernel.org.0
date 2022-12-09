Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00006648743
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 18:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbiLIRHo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 12:07:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbiLIRHF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 12:07:05 -0500
Received: from out-91.mta0.migadu.com (out-91.mta0.migadu.com [IPv6:2001:41d0:1004:224b::5b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B8130B
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 09:05:32 -0800 (PST)
Date:   Fri, 9 Dec 2022 17:05:21 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1670605531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7PHXtVfxL4Wco+emkfnuAlef7YnCwHHQo9a8I78AtDM=;
        b=XLTfOjcaFKd5ETBncO1R51Wln8mQ4dix7kBINL1+Hznswp0sRnYGkvxDCZj5uEpEGO5iwo
        O2aPG/8KAn7awL9px9tK0Ty+Q1XhHBeu2K4bSsTJbKy343i3ISeE4lO/vpKnbNwmp+mjLL
        vGPTlSpOfaLEzO/mtStWIp8ML4jY2oE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        Andrew Jones <andrew.jones@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Ben Gardon <bgardon@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Fuad Tabba <tabba@google.com>, Gavin Shan <gshan@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        James Morse <james.morse@arm.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Collingbourne <pcc@google.com>,
        Peter Xu <peterx@redhat.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
        Quentin Perret <qperret@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Ryan Roberts <ryan.roberts@arm.com>,
        Sean Christopherson <seanjc@google.com>,
        Steven Price <steven.price@arm.com>,
        Usama Arif <usama.arif@bytedance.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Will Deacon <will@kernel.org>,
        Zhiyuan Dai <daizhiyuan@phytium.com.cn>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [GIT PULL] KVM/arm64 updates for 6.2
Message-ID: <Y5Nq0a2JxUP+JuP+@google.com>
References: <20221205155845.233018-1-maz@kernel.org>
 <3230b8bd-b763-9ad1-769b-68e6555e4100@redhat.com>
 <Y5EK5dDBhutOQTf6@google.com>
 <5e51cf73-5d51-835f-8748-7554a65d9111@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e51cf73-5d51-835f-8748-7554a65d9111@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Paolo,

On Fri, Dec 09, 2022 at 05:56:50PM +0100, Paolo Bonzini wrote:
> On 12/7/22 22:51, Oliver Upton wrote:
> > > 
> > > I haven't pushed to kvm/next yet to give you time to check, so the
> > > merge is currently in kvm/queue only.
> > Have a look at this series, which gets things building and actually
> > passing again:
> > 
> > https://lore.kernel.org/kvm/20221207214809.489070-1-oliver.upton@linux.dev/
> 
> Thank you!  Squashed 1-2 and applied 3-4.

I actually wound up sending a v2 for this :)

1-2 are the same, but I addressed some of Sean's feedback and also
pulled in more fixes. In addition to the problems with page_fault_test,
other KVM selftests were magically failing on arm64 because identity
mapping ucall MMIO punched a hole straight through the program image.

Mind dumping what I had in v1 and applying this instead?

https://lore.kernel.org/kvm/20221209015307.1781352-1-oliver.upton@linux.dev/

Thanks!

--
Best,
Oliver
