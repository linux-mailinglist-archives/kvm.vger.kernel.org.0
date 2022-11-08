Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1506208F6
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 06:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232548AbiKHFg4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 00:36:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiKHFgz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 00:36:55 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A7A6183B3
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 21:36:53 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id y4so13234742plb.2
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 21:36:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BySxdp/7FbkyS9rQ/+SYkYHjIbHSrwzWviAFRY2ZPdQ=;
        b=jlgow3Yb6SgeKXBbO3czTUh+xNvvjFHf5z9ViSJ61Te93gNnScVTxpPdHdT0l7k62F
         lMrHOG03BfSjw2UfLzDRH+RXS0WR4VTQobaYGOSlEeJAzgE29G9Fs3PTFtSoRNJ2lsDP
         rp0PpZoXb1pTQgLNwDewCRkXTSd0VD2UnGaEqh9OBYLx6U4QpTvTGuKtpRiWBAAdeDq6
         BupIKIXcNl5Jz9YKhzqCZK1Zqb6IeNpvb7fpbUcyQY8vS/dUjH/ef8j3NZEU1GlKSkJ5
         KtoaRb8jEUBKaeh9EDW7vyVfw83qUDyWWtZPLL7bbZyLBEvN6jw/u2ubAUqXn8x1atsw
         HieA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BySxdp/7FbkyS9rQ/+SYkYHjIbHSrwzWviAFRY2ZPdQ=;
        b=y7BBNnFgi0T2no3a9/lK8+seaL0X/6NewQv/ifvmoibZd8+ueB6RwGyQIONLElBv1A
         1qU1IXdxgBgyoTj9vPScNTmAu+CiPgWhtwkh7HbrqKfCpB0JEiFf7+hhGPzUGYGOiIIE
         ktAwrH9B4iBu0bNYV8cEdxPDzqa+xzRhTPso5sgE1C7o5Ty/uaTQvBGyivgmNnPFzD3X
         hPRfqG+LArYnhH4x+tooOpVWqdbcvwgDscKVWHw3WW/ez9V4OkgFkkjxivFNqBpCZQl0
         0nn9pgzS4qfIsQayvj0n9nslsXqeq2V7MwsVhm7zgUE6oHahHEis/O7SWZb6XmaN0Bdf
         qtqg==
X-Gm-Message-State: ACrzQf2MqlzDz5xhvYIUTJmbN6zghn4Hs8ni6UTqzswSYOAJvgHMOxyu
        CDQVUKYuTiova9xkz11537RdAX/au83LH0JwHm0COg==
X-Google-Smtp-Source: AMsMyM5h/BK7dlR9tXFEYHomDewWZpzTj+DR/oCqXMDG+trxJqZakFJMlhmhsO/VcM4HGEgEalX+qA4zQQDUKnfZXJ4=
X-Received: by 2002:a17:902:7145:b0:187:2356:c29d with SMTP id
 u5-20020a170902714500b001872356c29dmr43846977plm.154.1667885812893; Mon, 07
 Nov 2022 21:36:52 -0800 (PST)
MIME-Version: 1.0
References: <20221028105402.2030192-1-maz@kernel.org> <20221028105402.2030192-12-maz@kernel.org>
 <CAAeT=FyiNeRun7oRL83AUkVabUSb9pxL2SS9yZwi1rjFnbhH6g@mail.gmail.com>
 <87tu3gfi8u.wl-maz@kernel.org> <CAAeT=FwViQRmyJjf3jxcWnLFQAYob8uvvx7QNhWyj6OmaYDKyg@mail.gmail.com>
 <86bkpmrjv8.wl-maz@kernel.org> <CAAeT=Fzp-7MMBJshAAQBgFwXLH2z5ASDgmDBLNJsQoFA=MSciw@mail.gmail.com>
 <87pme0fdvp.wl-maz@kernel.org>
In-Reply-To: <87pme0fdvp.wl-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 7 Nov 2022 21:36:36 -0800
Message-ID: <CAAeT=Fzgu1iaMmGXWZcmj9ifmchKXZXG2y7ksvQzoTGAQ=G-jw@mail.gmail.com>
Subject: Re: [PATCH v2 11/14] KVM: arm64: PMU: Allow ID_AA64DFR0_EL1.PMUver to
 be set from userspace
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
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

Hi Marc,

> > BTW, if we have no intention of supporting a mix of vCPUs with and
> > without PMU, I think it would be nice if we have a clear comment on
> > that in the code.  Or I'm hoping to disallow it if possible though.
>
> I'm not sure we're in a position to do this right now. The current API
> has always (for good or bad reasons) been per-vcpu as it is tied to
> the vcpu initialisation.

Thank you for your comments!
Then, when a guest that has a mix of vCPUs with and without PMU,
userspace can set kvm->arch.dfr0_pmuver to zero or IMPDEF, and the
PMUVER for vCPUs with PMU will become 0 or IMPDEF as I mentioned.
For instance, on the host whose PMUVER==1, if vCPU#0 has no PMU(PMUVER==0),
vCPU#1 has PMU(PMUVER==1), if the guest is migrated to another host with
same CPU features (PMUVER==1), if SET_ONE_REG of ID_AA64DFR0_EL1 for vCPU#0
is done after for vCPU#1, kvm->arch.dfr0_pmuver will be set to 0, and
the guest will see PMUVER==0 even for vCPU1.

Should we be concerned about this case?

Thank you,
Reiji
