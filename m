Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76B0E5BD489
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 20:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbiISSKJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 14:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbiISSJa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 14:09:30 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17036476D4
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 11:08:42 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-1278624b7c4so568966fac.5
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 11:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=TJiXMkCUTojlXKbQiyFacYe67YzyD0jjA+qabTsDbHM=;
        b=ju2bOaIH0x2rfWBR2EkNKXtD+zFlJlrmslGAw5GPkTydyo40nU2mIIXyv2TelU5tHO
         XqrygKYF6N7ls5CstZqbkxAOXW7kG8TPicncmVypRq0wuO5k4e/KQxMyaLj94h/heLnA
         3YqZUWkGMtKcZBkuNQZZt0/JtAaUyY32r+kErbm8hAv6ZAzapfJeonMQ+Ld+gt0hoHSC
         YriET+StwTfUXoXl/oTAlgLYp2Dncrqm1FhtXPMPPSRVSsen4yUPFaR0F9F2xUnMD0IR
         Sv9+pHEbDmVPfSX0JGHO+IRu0eHP86NFLmrK6CycdkinEcxd9nuqVsEwxUEXfP7uPxlp
         SNyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=TJiXMkCUTojlXKbQiyFacYe67YzyD0jjA+qabTsDbHM=;
        b=SLMhGugUlyxLI3nbW9eCIxbkWVpgocgtFgL3SghvU02Ub4ntTNib4knjBwA7VNCiL/
         IzoUdzLYg2aL9bKJYjhfy/t0t/uXF7FeJYXUqszCGcFwrFswaL+VmiQAvbwjMaFEo63T
         sBuf/AA0o8ZiKluXmqUKVCeuseU046RSq/+4tvOIn0pPYSrEICaWYJsXzmjv3Ba3dCkH
         p1Dum1q9qlxhbPnuBcg8Zcd9f938gKJ7SDplaHTrjSfU7ccV+whEoEfQ2sCEcryajfUP
         1Eyequ6xJF4+pL9RcNiY3znem5/x1XTVJGxA54adg3ETuVzjWZqpYtYGn7tZ5Q/D2tju
         u6Mg==
X-Gm-Message-State: ACgBeo2rnkVsvHuzVUzh7M+cwe+qV+UtyFdAttBwB6C7WL8JtKxR6KZY
        re7R/w1K13cABM8jURBxLdgr7VYZ4/GrNRTEJWJd5g==
X-Google-Smtp-Source: AA6agR5v80bCpuIGZxW8+dnb0Fm/3JglgbXD42nIcGRa2wRJbTpJtPkJJrNswQZmAUSCoovE0ee1n9GMUxUu1co/F/w=
X-Received: by 2002:a05:6870:580c:b0:12a:f136:a8f5 with SMTP id
 r12-20020a056870580c00b0012af136a8f5mr15701327oap.269.1663610919985; Mon, 19
 Sep 2022 11:08:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210201051039.255478-1-like.xu@linux.intel.com>
 <CALMp9eRC2APJgB3Y7S4MWsTs9wom3iQycd60kM2eJg39N_L4Ag@mail.gmail.com> <ec0f97e9-33b7-61d8-25b8-50175544dbdd@gmail.com>
In-Reply-To: <ec0f97e9-33b7-61d8-25b8-50175544dbdd@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 19 Sep 2022 11:08:28 -0700
Message-ID: <CALMp9eRAv_7UOL8K+15_UsV9ML5M3rnh-Rz2C1GtTkZCHt4Yjg@mail.gmail.com>
Subject: Re: [PATCH v14 00/11] KVM: x86/pmu: Guest Last Branch Recording Enabling
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, ak@linux.intel.com,
        wei.w.wang@intel.com, kan.liang@intel.com,
        alex.shi@linux.alibaba.com, kvm@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 19, 2022 at 12:26 AM Like Xu <like.xu.linux@gmail.com> wrote:
>
> On 14/9/2022 7:42 am, Jim Mattson wrote:
> > How does live migration work? I don't see any mechanism for recording
> > the current LBR MSRs on suspend or restoring them on resume.
>
> Considering that LBR is still a model specific feature, migration is less
> valuable unless
> both LBR_FMT values of the migration side are the same, the compatibility check
> (based on cpu models) is required (gathering dust in my to-do list);

This seems like a problem best solved in the control plane.

> and there is another dusty missing piece is how to ensure that vcpu can get LBR
> hardware in
> vmx transition when KVM lbr event fails in host lbr event competition, the
> complexity here is
> that the host and guest may have different LBR filtering options.

In case of a conflict, who currently wins? The host or the guest? I'd
like the guest to win, but others may feel differently. Maybe we need
a configuration knob?

> The good news is the Architecture LBR will add save/restore support since Paolo
> is not averse to
> putting more msr's into msrs_to_save_all[], perhaps a dynamic addition mechanism
> is a prerequisite.
>
> Please let me know what your priority preferences are for these tasks above.
