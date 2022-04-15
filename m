Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02843502FB8
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 22:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352042AbiDOUVu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 16:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351984AbiDOUVs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 16:21:48 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5CE4DE911
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 13:19:18 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id n17so5618242ljc.11
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 13:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Cr58g6CfShtXO0vPAwUW4nrK3WFLlKprChO+5HKe11I=;
        b=pTQCdrK4nxKkRj5ZtnKlRQMEdwyiG4IxvjveFI+rN+RlG9us7lR4w3qho+5DXLr8YE
         4k5XDSqOYwkEHvEyokqgTPRA5Uo19tN2y3SIs8CTw62wMHAlr9X+pakIqMqsrEaBMtNJ
         PLq0jBQ0MPUGOHpGv6ylkeFpMPdyESc8sFmJCgWM/YcG1TBzostMsQd4S14vFj5mYwhh
         6ri3ijo80wBGP+Y7PMQs9e/vEKhW+pF1jxz2CUwQMZov/huko3a1A3JNyCVE0FL1vPF9
         eCUt0iFpIMZGGGvNtfcTOEAn+gMgQrVn5faLTtDTj5OkwOvEJSwVGkYBzrqZXATBIj58
         gbtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Cr58g6CfShtXO0vPAwUW4nrK3WFLlKprChO+5HKe11I=;
        b=08U7AfsIL+7gaP5gmTONHCvq3OU8GDpBFyYp7R12Nj+YmsEjmlZTj6Quua80C8EhRX
         IyKbkQfWFnRf1E7vegNPp89IGFAjKoxiYqqUZ5jPnVsGVW0XhHzWLmNSi6TKGzFrFRZT
         uV8qY+OknIW7vZEz/UArnPUnZ7Xfj1+kUci9x6E3+3AyfDHqpw4MdFBNYuDgaH2uW2x+
         ja+4hDgaXL1h1e2vgUXfI3iT4jJb7PQZzMKVquUE/13QEO3plWZCZLYKDhiH6NrT9AAD
         QgeHTYwgW1VF1Efy0l2oGAcNG6H4kvg0lH0Ay5uzDQlWa5nkuZqNpcROetk5GO39x/IK
         bUSw==
X-Gm-Message-State: AOAM530ySRxepLPMcYOy9Ldck0gN7kCISVCJM3QNQofh4EQx4fzQHDX7
        8/s3ISMVnWhOkSGThDbeVNgCzk1He5e2StuTZBEPFwT9wus=
X-Google-Smtp-Source: ABdhPJxJiO85Bos5bUVj8dUf57mGhlYFxUljrowrHyO+zNoS7Z3hSAeRAnEnr/34bYX+3RQ00o2tlVFUXYQMummUeg4=
X-Received: by 2002:a2e:998b:0:b0:24d:a08d:8933 with SMTP id
 w11-20020a2e998b000000b0024da08d8933mr409178lji.170.1650053956782; Fri, 15
 Apr 2022 13:19:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220415201542.1496582-1-oupton@google.com>
In-Reply-To: <20220415201542.1496582-1-oupton@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Fri, 15 Apr 2022 13:19:05 -0700
Message-ID: <CAOQ_Qsj+Zq5J=ox9PT8qBeyzgLap9=a451FdDHr6p41LhcyzeA@mail.gmail.com>
Subject: Re: [PATCH 0/5] KVM: Clean up debugfs+stats init/destroy
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, maz@kernel.org,
        KVM ARM <kvmarm@lists.cs.columbia.edu>
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

+cc the actual kvmarm mailing list, what I had before was wishful
thinking that we moved off of the list that always goes to my spam :-)

On Fri, Apr 15, 2022 at 1:15 PM Oliver Upton <oupton@google.com> wrote:
>
> The way KVM handles debugfs initialization and destruction is somewhat
> sloppy. Although the debugfs + stats bits get initialized *after*
> kvm_create_vm(), they are torn down from kvm_destroy_vm(). And yes,
> there is a window where we could theoretically destroy a VM before
> debugfs is ever instantiated.
>
> This series does away with the mess by coupling debugfs+stats to the
> overall VM create/destroy pattern. We already fail the VM creation if
> kvm_create_vm_debugfs() fails, so there really isn't a need to do these
> separately in the first place.
>
> The first two patches hoist some unrelated tidbits of stats state into
> the debugfs constructors just so its all handled under one roof.
>
> The second two patches realize the the intention of the series, changing
> the initialization order so we can get an FD for the vm early.
>
> Lastly, patch 5 is essentially a revert of Sean's proposed fix [1], but
> I deliberately am not proposing a revert outright, in case alarm bells
> go off that a stable patch got reverted (it is correct).
>
> Applies to the following commit w/ the addition of Sean's patch:
>
>   fb649bda6f56 ("Merge tag 'block-5.18-2022-04-15' of git://git.kernel.dk/linux-block")
>
> Tested (I promise) on an Intel Skylake machine with KVM selftests. I
> poked around in debugfs to make sure there were no stragglers, and I ran
> the reproducer for [1] to confirm the null ptr deref wasn't introduced
> yet again.
>
> Oliver Upton (5):
>   KVM: Shove vm stats_id init into kvm_create_vm_debugfs()
>   KVM: Shove vcpu stats_id init into kvm_vcpu_create_debugfs()
>   KVM: Get an fd before creating the VM
>   KVM: Actually create debugfs in kvm_create_vm()
>   KVM: Hoist debugfs_dentry init to kvm_create_vm_debugfs() (again)
>
>  virt/kvm/kvm_main.c | 92 ++++++++++++++++++++++-----------------------
>  1 file changed, 46 insertions(+), 46 deletions(-)
>
> --
> 2.36.0.rc0.470.gd361397f0d-goog
>
