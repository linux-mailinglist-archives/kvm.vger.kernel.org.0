Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 620FE598B23
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 20:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345449AbiHRS3g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 14:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242260AbiHRS3e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 14:29:34 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3990AED95
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 11:29:32 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id by6so2474505ljb.11
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 11:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=3S29CJf5siLb6c/lIz+fobVK21gASOrKQYD0JCFerP4=;
        b=b363KFtkhLYyvkLVjQQuPUhDgfqsqjy2lVX95L6ZZ7X5C0lKiQcnSGnBoeHchAVG5E
         G0ZYB0lodAv8InopFWg1SzCJRArHWmvxsrV+TYuqzSxsIO9WriwOy5k8diw5T+osf6f1
         lJL9dop6SAyNWUPCdqmF2RQFniu5VJwVXWKNlEYIqQDZwE8LqeNpBoC4D1r3ibuo4YTu
         KLN8tifFbvSlXfUItU8TJHBtIqCw+TL5XAuAou3g2ju0dmXf+N1WsF15OW8jxq1GZVTc
         XCtLnVqWOnwcwR3TtXfRDoIoFyRDEGQ5GS7nc2Pv5CB0zTPw8IMoo1GMpwer17G6hidO
         CZ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=3S29CJf5siLb6c/lIz+fobVK21gASOrKQYD0JCFerP4=;
        b=XM5szI4KFejBXVyC977ZLahhqjHAYGip4OxQu/+Tc89gKvn7vgVkdA7XigsFMpffqV
         YL5VEqR+YO2ug5h9D+p9JTKtQuPU5SAe6SIBPYz0H1ckVeMdaeud5e1GI7N/GHYln5E/
         aWeNKdlAx7BX+dgFrddV6eJ4yzleGnymkFitILj8BRTcmjY9F+/ZWlABBP4janL4RC3a
         3bUqin0gSsoaoMBpUvE9SNvdanNl+x/ytJevWSOben0PfTUtKVGOlybcE3Ogu83UkDf+
         vjfCfNUzo9BI0PdS4G7EE2ETbH74C78xo4H86F0VBFSc30rSer6rONLBX+V4XUTY/Kq2
         rS0w==
X-Gm-Message-State: ACgBeo3KuS9lpf0+NPh4y8vjTyxQ/rNU4Jm/l79QimpIOtpEVnlDnfBL
        zDGCru43gP+U6hsJdVYcHCt5WWOGxTdlFzGqop4BJg==
X-Google-Smtp-Source: AA6agR76LAhlDxQa9VsIZifhFJe/1ypc6DdiOn0X3HcKcfm6o19fiuSJsYJzo8kuwFLn9/kC/RUKD94S3/ysP6FjdJg=
X-Received: by 2002:a2e:a589:0:b0:261:b223:488b with SMTP id
 m9-20020a2ea589000000b00261b223488bmr1233546ljp.33.1660847370896; Thu, 18 Aug
 2022 11:29:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220817152956.4056410-1-vipinsh@google.com> <Yv0kRhSjSqz0i0lG@google.com>
 <CAHVum0fT7zJ0qj39xG7OnAObBqeBiz_kAp+chsh9nFytosf9Yg@mail.gmail.com>
 <Yv1ds4zVCt6hbxC4@google.com> <CAHVum0dJBwtc5yNzK=n2OQn8YZohTxgFST0XBPUWweQ+KuSeWQ@mail.gmail.com>
 <Yv6AiPtRbHv4OSL5@google.com>
In-Reply-To: <Yv6AiPtRbHv4OSL5@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Thu, 18 Aug 2022 11:28:54 -0700
Message-ID: <CAHVum0dpZiG2KWC+Qm+OUiYPwt_bV5qTaY8-pMa16yfJS+joOQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: Run dirty_log_perf_test on specific cpus
To:     Sean Christopherson <seanjc@google.com>
Cc:     dmatlack@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Thu, Aug 18, 2022 at 11:10 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Aug 18, 2022, Vipin Sharma wrote:
> > On Wed, Aug 17, 2022 at 2:29 PM Sean Christopherson <seanjc@google.com> wrote:
>
> > Okay, I will remove -d and only keep -c. I will extend it to support
> > pinning the main worker and vcpus. Arguments to -c will be like:
> > <main woker lcpu>, <vcpu0's lcpu>, <vcpu1's lcpu>, <vcpu2's lcpu>,...
> > Example:
> > ./dirty_log_perf_test -v 3 -c 1,20,21,22
> >
> > Main worker will run on 1 and 3 vcpus  will run on logical cpus 20, 21 and 22.
>
> I think it makes sense to have the vCPUs be first.  That way vcpu0 => task_map[0],
> and we can also extend the option in the future without breaking existing command
> lines, e.g. to add more workers and/or redefine the behavior of the "trailing"
> numbers to say that all workers are affined to those CPUs (to allow sequestering
> the main worker from vCPUs without pinning it to a single CPU).

Make sense. vcpus first followed by worker cpus.

Thanks
