Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AEBF4BC729
	for <lists+kvm@lfdr.de>; Sat, 19 Feb 2022 10:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234214AbiBSJmp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Feb 2022 04:42:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231863AbiBSJmn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Feb 2022 04:42:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958DA6622E
        for <kvm@vger.kernel.org>; Sat, 19 Feb 2022 01:42:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F276B80881
        for <kvm@vger.kernel.org>; Sat, 19 Feb 2022 09:42:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E747CC004E1;
        Sat, 19 Feb 2022 09:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645263742;
        bh=JHGMB5wyXhuUeu/pJD4Q++IqqHBbSh5JNv1xBjTAPEA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CSFEtGbLDSfNNskaealbTBWwp5XwQV4VUJ6arAPCR4vH1cHFzWXl3FW/exhom/Tc3
         AAsAhGeSLlPWBb0j4cX8KN2yKftFgH8nLbv5fprXL0I7sQAPJtdo6XOcuhDEV6lIwE
         IhICjv5j+WER0/YYudn+WmplDvUF2u414sqrX8dy538qwrrV1Gjw40PzusVIld4dhl
         dSC03amXgOTf6aBwicxF+zyhxTEQPo+UoXU7A7ALYXHPqF1jd3dlTGThhCAlhFxS/y
         ptnRQgnG8PpTTI7YX2a+7q7tIYziIMAI5FAuJk6Rf08W1fTQImOrAhAJZ1Siwox6c+
         s/YKMlwyu9JNA==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nLMFv-008xGO-Ul; Sat, 19 Feb 2022 09:42:20 +0000
MIME-Version: 1.0
Date:   Sat, 19 Feb 2022 09:42:19 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Oliver Upton <oupton@google.com>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [PATCH 2/2] KVM: arm64: selftests: Introduce get_set_regs_perf
 test
In-Reply-To: <CAAeT=FxbbBq0sxUZAOSJW_wM+6M=xQe-p+=aeqpg=-y9VbpnnA@mail.gmail.com>
References: <20220217034947.180935-1-reijiw@google.com>
 <20220217034947.180935-2-reijiw@google.com> <Yg3Uer/K6n/h6oBz@google.com>
 <874k4x502u.wl-maz@kernel.org>
 <CAAeT=FxbbBq0sxUZAOSJW_wM+6M=xQe-p+=aeqpg=-y9VbpnnA@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <3878ff49741733d6dd76aae57b594cb2@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: reijiw@google.com, oupton@google.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com, drjones@redhat.com, pbonzini@redhat.com, will@kernel.org, pshier@google.com, ricarkol@google.com, jingzhangos@google.com, rananta@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reiji,

On 2022-02-19 04:50, Reiji Watanabe wrote:
> Hi Marc,
> 
> On Thu, Feb 17, 2022 at 1:12 AM Marc Zyngier <maz@kernel.org> wrote:
>> 
>> On Thu, 17 Feb 2022 04:52:10 +0000,
>> Oliver Upton <oupton@google.com> wrote:
>> 
>> > Would it make sense to test some opt-in capabilities that expose
>> > additional registers (PMU, SVE, etc.)?
>> 
>> I think this is important. System registers are usually saved/restored
> 
> Yes, I will fix the test to include registers for opt-in features
> when supported.
> 
>> in groups, and due to the way we walk the sysreg array, timings are
>> unlikely to be uniform. Getting a grip on that could help restructure
>> the walking if required (either per-group arrays, or maybe a tree
>> structure).
> 
> The biggest system register table that I know is sys_reg_descs[],
> and KVM_SET_ONE_REG/KVM_GET_ONE_REG/emulation code already uses
> binary search to find the target entry.  So, the search itself
> isn't that bad.  The difference between the min and the max
> latency of KVM_GET_ONE_REG for the registers is always around
> 200nsec on Ampere Altra machine as far as I checked.

Even if it is OK so far, it is bound to get worse over time, as
the architecture keeps adding all sort of things that we'll
eventually have to save/restore.

I see this test as a way to monitor this trend and work out when
we need to invest in something better.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
