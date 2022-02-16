Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 372344B7E55
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 04:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343835AbiBPCw5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 21:52:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237229AbiBPCw4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 21:52:56 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 117F127B0D
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 18:52:45 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id v22so239991pgb.0
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 18:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T+3VYyLTECeMOgMEiaC+u6xcJ2KtTI5ankI+rDGci68=;
        b=RkVxrBBbGlwz2LwLmUz7vynCN/Hz6yebDI6Ug4N2e6KSbowJjnGGfo5/oRl3W3bahj
         BXiCJ6uViTXhNvdB+Q1ElZW8lUxk09g/v0mpKVFDy4YreCxrvmtSoAgcFeAyPzl0J03Y
         NalWLIGV6CHe//5ceFpoG+T9OmXOa9zJcOOI11Qu0mISxXAD1ox/Hh1sIiW7Kt6qwA6F
         7dbKufKasGrPiQB+Pb6KeLT5s7PHj7otdLDc+GTw10M4r80oDXeQzY7BVvQncPIs7TQL
         wPZljBtKv12fMLemhmd3fg/JzWyUM7+ueJehkzw0uJ8/RXsz/uUjqCH9L//u3dyT5cwZ
         d4Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T+3VYyLTECeMOgMEiaC+u6xcJ2KtTI5ankI+rDGci68=;
        b=6vqrJ+fA8zF44ceOxs6IW1c4UvSYed3sFWZnqRlSS1sPMObluQgrj0uzJXjYYaJSuW
         AijBETlao5rF+hkBgrw/pdPCNjEz0Ba3jUKSXjCXVh/v/mN62jwFhV7Sv/q2592j2CXp
         69pL7ImblxUyWpVFfyH1NtKjyQ6QQ2VFHFtq1JNRJ+vh4wIXL6ZsODbe4p2hi3B5rGaO
         hIDFmiRmISMTxrJTqJXo82idIUMwzSFKNdH3/d5UcoKN6WQVWLxrBrNDtMCCyE8Cu9/i
         Z8gpHmlAx7pHmwjmRiNDjMG3na+Svk/6RnVnVbZNsNySxTF+ak4TB2O4kyWXKPmdkWHq
         HPxw==
X-Gm-Message-State: AOAM5306RF22JYJrko/Qir9jZs88wPa8xwdeFkC28EWHMgQNf3jgsJJN
        i206dc7YsqRbCPLu1WUrodD3eFMmJNHpbWJcZShoMg==
X-Google-Smtp-Source: ABdhPJwiN0rD8LslLaIwFI6zgh4dyuMS3WAvh9+7lnEbHj9G2opQoU8bmKoO6GTQVnjXTzExS+VwI7tNaAlZNrS7rkA=
X-Received: by 2002:a63:5525:0:b0:372:c376:74f1 with SMTP id
 j37-20020a635525000000b00372c37674f1mr504815pgb.433.1644979964245; Tue, 15
 Feb 2022 18:52:44 -0800 (PST)
MIME-Version: 1.0
References: <20220214065746.1230608-1-reijiw@google.com> <20220214065746.1230608-11-reijiw@google.com>
 <Ygv3q/+arejIWnzs@google.com>
In-Reply-To: <Ygv3q/+arejIWnzs@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 15 Feb 2022 18:52:27 -0800
Message-ID: <CAAeT=Fxvsniq4NW92LESqJ1ie6e+N1J793JrX0UBf2mq9B35dg@mail.gmail.com>
Subject: Re: [PATCH v5 10/27] KVM: arm64: Hide IMPLEMENTATION DEFINED PMU
 support for the guest
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

Thank you for the review!

On Tue, Feb 15, 2022 at 10:57 AM Oliver Upton <oupton@google.com> wrote:
>
> Hi Reiji,
>
> On Sun, Feb 13, 2022 at 10:57:29PM -0800, Reiji Watanabe wrote:
> > When ID_AA64DFR0_EL1.PMUVER or ID_DFR0_EL1.PERFMON is 0xf, which
> > means IMPLEMENTATION DEFINED PMU supported, KVM unconditionally
> > expose the value for the guest as it is.  Since KVM doesn't support
> > IMPLEMENTATION DEFINED PMU for the guest, in that case KVM should
> > expose 0x0 (PMU is not implemented) instead.
> >
> > Change cpuid_feature_cap_perfmon_field() to update the field value
> > to 0x0 when it is 0xf.
>
> Definitely agree with the change in this patch. Do we need to tolerate
> writes of 0xf for ABI compatibility (even if it is nonsensical)?
> Otherwise a guest with IMP_DEF PMU cannot be migrated to a newer kernel.

Hmm, yes, I think KVM should tolerate writes of 0xf so that we can
avoid the migration failure.  I will make this change in v6.

Since ID registers are immutable with the current KVM, I think a live
migration failure to a newer kernel happens when the newer kernel/KVM
supports more CPU features (or when an ID register field is newly
masked or capped by KVM, etc).  So, I would assume such migration
breakage on KVM/ARM has been introduced from time to time though.

Thanks,
Reiji
