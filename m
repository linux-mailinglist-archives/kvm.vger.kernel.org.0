Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4DF44E69CB
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 21:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353371AbiCXUZd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 16:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242893AbiCXUZc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 16:25:32 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17603B8209
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 13:24:00 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id k14so4762033pga.0
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 13:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+deFKAAvG1IExHzs7Ey5q7jagiNbsrjto223/L+snd0=;
        b=Znk/UqwO6g8KsGi2N1lmUXz1sgxGNyiUkGWZGoYcktt4qVmXNELV/cuiFM8vVcoG6V
         5LYbQfMxUkMyjkNmsBDR7Q1x/zXVNmiSMr9wd7y2fhNICdoqsIxWywmo2gxWT/JF1jQo
         FeLRbi2ORaHUo3DbO/F1JRhrMqb9nARAgsK1S6ATPfDD8U2E85M076204H0Pem8tssav
         R3nJc6Piyi21cn/P7+5/ka4ENAqFGOqReCQIpHHdU3ZoJBrGcTOtkizT/WPMtEUC9K5g
         jmBPepdm1skpcfaekubV4AB06LZrc/NAST30WQ+fMvYIxASJ5F5f+38VPSq35AyrK65J
         oKDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+deFKAAvG1IExHzs7Ey5q7jagiNbsrjto223/L+snd0=;
        b=Fwo0zk/SxzM/Meatjv20dW2ZdC68c/lPVy4TsdsHCwEYuF3xRmwQ8WMaq72RTm9/vx
         XbGJJ0UyrBnaP5msft2Qz/MLrUl/GyVMXGSLW4YaxWENOsg2V6D2S3WbDQdBu8nbM96j
         /2iU1tAb5FoSxC/difgClLcRSTODI/ytG3tkxyKTamJCALddch+LCRrShPsYMq06Msp6
         paX1ZkzpMErv8p9sioR/dOQ0/hYXuVMgG9c1gz06ZTt0VBkdwGk3LuOlSv+uwpjoi6SK
         luRhoJe8f8cfz9V96SLm+Bmterir22lpzohu5ZkFX+FTDPTzvIPKfrtodHL07zAnWUfi
         RxKA==
X-Gm-Message-State: AOAM533kGPUye5U8AY5GhllTRifbjivngq4aTSql4yzMlrOTwrJw/no7
        8GHxt2+1US2zSCEaQxLXFRoZg6apGRfffJNiqy2z7w==
X-Google-Smtp-Source: ABdhPJxTwFMhv13gS2/VlfiC3K4DQxqCgghC0iWGormtJ2+ksX6zo9S2rpGpYpjojaRk5suMxroWbFg91R/7jupEX7w=
X-Received: by 2002:a65:56cb:0:b0:378:82ed:d74 with SMTP id
 w11-20020a6556cb000000b0037882ed0d74mr5346825pgs.491.1648153439287; Thu, 24
 Mar 2022 13:23:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220311044811.1980336-1-reijiw@google.com> <20220311044811.1980336-12-reijiw@google.com>
 <Yjt6qvYliEDqzF9j@google.com>
In-Reply-To: <Yjt6qvYliEDqzF9j@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Thu, 24 Mar 2022 13:23:42 -0700
Message-ID: <CAAeT=FwkXSpwtCOrggwg=V72TYCRb24rqHYVUGd+gTEA-jN66w@mail.gmail.com>
Subject: Re: [PATCH v6 11/25] KVM: arm64: Add remaining ID registers to id_reg_desc_table
To:     Oliver Upton <oupton@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On Wed, Mar 23, 2022 at 12:53 PM Oliver Upton <oupton@google.com> wrote:
>
> Hi Reiji,
>
> On Thu, Mar 10, 2022 at 08:47:57PM -0800, Reiji Watanabe wrote:
> > Add hidden or reserved ID registers, and remaining ID registers,
> > which don't require special handling, to id_reg_desc_table.
> > Add 'flags' field to id_reg_desc, which is used to indicates hiddden
> > or reserved registers. Since now id_reg_desc_init() is called even
> > for hidden/reserved registers, change it to not do anything for them.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
>
> I think there is a very important detail of the series that probably
> should be highlighted. We are only allowing AArch64 feature registers to
> be configurable, right? AArch32 feature registers remain visible with
> their default values passed through to the guest. If you've already
> stated this as a precondition elsewhere then my apologies for the noise.
>
> I don't know if adding support for this to AArch32 registers is
> necessarily the right step forward, either. 32 bit support is working
> just fine and IMO its OK to limit new KVM features to AArch64-only so
> long as it doesn't break 32 bit support. Marc of course is the authority
> on that, though :-)
>
> If for any reason a guest uses a feature present in the AArch32 feature
> register but hidden from the AArch64 register, we could be in a
> particularly difficult position. Especially if we enabled traps based on
> the AArch64 value and UNDEF the guest.
>
> One hack we could do is skip trap configuration if AArch32 is visible at
> either EL1 or EL0, but that may not be the most elegant solution.
> Otherwise, if we are AArch64-only at every EL then the definition of the
> AArch32 feature registers is architecturally UNKNOWN, so we can dodge
> the problem altogether. What are your thoughts?

Thank you so much for your review, Oliver!

For aarch32 guests (when KVM_ARM_VCPU_EL1_32BIT is configured),
yes, the current series is problematic as you mentioned...
I am thinking of disallowing configuring ID registers (keep ID
registers immutable) for the aarch32 guests for now at least.
(will document that)

For aarch64 guests that support EL0 aarch32, it would generally
be a userspace bug if userspace sets inconsistent values in 32bit
and 64bit ID registers. KVM doesn't provide a complete consistency
checking for ID registers, but this could be added later as needed.

It might be a good idea to skip trap configuration to avoid being
affected by the issue.  On the other hand, this might provide a
good opportunity to detect such userspace issue.  As this could
happen only with new userspace code that changes ID registers,
I might rather prefer the latter?

Thanks,
Reiji
