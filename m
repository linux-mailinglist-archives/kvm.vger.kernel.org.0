Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 156E56C876F
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 22:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbjCXVZb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 17:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbjCXVZ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 17:25:29 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E5D6BDFC
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 14:25:28 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id k17-20020a170902d59100b0019abcf45d75so1809116plh.8
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 14:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679693128;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zodHA9qFwPM7FM3/i/LVmpVkVaDmmsdXQrDcFc+B+NY=;
        b=hEVJMNMvymwu0rssShTLoH4LK8MacXdJdWKhEBNGJ5fJmoH82ZlGrK/Fk+T0pxgaUu
         OtAWRqA1yFkoSBC368Issjgg7M1VImQne2uReDy1xBqgjvBIR8A2QGlS8UtvfArOQq9n
         QzrftqFhKr8L6HefQ3S75AS8Z6g4gaoSqeXxf/ZqtYiygrdmviICH90PcpgSlZY5+m+X
         KbZaC42xMHN5UEGht661mPxeYuAeU1fia7xZbnIRzCvJosppj+jZ3b+yXuqNqKJd3CpF
         Sy6dMWLAMXBwNv3R2cQRi0iSfYxISHUgUr4shwVBCcIR/W65oggGf8tb7QKL+cFZ7kfw
         PD1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679693128;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zodHA9qFwPM7FM3/i/LVmpVkVaDmmsdXQrDcFc+B+NY=;
        b=OnTZD1B8Zc6NcflfXS7FpWN8WCoM4iPiHtxEjRR/G283pvGEqDR3gK4w5t/QYBMwtr
         /h8/UL9hOCTTGXp+hFZb3D2oC6JcHPl/6scSftaPdeBiOWjmGcf2qCHsNUDEHx2pqVB0
         7ggaCZobgfXNnuo4Vyw7EvfdFAaeoQIghw2/DFjs6MssMklp0YOdXOBOBwWhuHF5h4qQ
         hnHxQvQOTpSFrPlFDRDioYecXkZcRRfHMj/PLZ7z7oEwQsOsllZm8/dCMExZrmPljAFT
         9ieLT3n5KSBwxSUZG3wydgWu7XuOZwISClxK4QlosP3leAznOJMqQuOoDl/ORlZMbsuN
         AFPw==
X-Gm-Message-State: AAQBX9elrMfMUyzU+swNw3MeWN8qIiojB1Y+ZW6pxSjkBZ33zN3TGHZu
        zxsGoSbFCFKhTW87WPVHdBAjp3RHInk=
X-Google-Smtp-Source: AKy350aBPofblWh3QIw6tmKvOGplsa5ky59fnNaATx62FJsqq1sXA7XckNvwaTfDCQUwZiU1gGyuGKJyujU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:88c9:0:b0:5f1:b1:6dc4 with SMTP id
 k9-20020aa788c9000000b005f100b16dc4mr2211266pff.3.1679693127931; Fri, 24 Mar
 2023 14:25:27 -0700 (PDT)
Date:   Fri, 24 Mar 2023 14:25:26 -0700
In-Reply-To: <167969136143.2756283.9405259236021680651.b4-ty@google.com>
Mime-Version: 1.0
References: <20230214084920.59787-1-likexu@tencent.com> <167969136143.2756283.9405259236021680651.b4-ty@google.com>
Message-ID: <ZB4VRvjUP75kpw71@google.com>
Subject: Re: [PATCH 0/2] KVM: selftests: Report enable_pmu module value when
 test is skipped
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 24, 2023, Sean Christopherson wrote:
> On Tue, 14 Feb 2023 16:49:18 +0800, Like Xu wrote:
> > Adequate info can help developers quickly distinguish whether the cause
> > is a code flaw or a platform limitation when a test fails or is skipped,
> > and this minor patch-set is doing a little work in that direction.
> > 
> > Base: kvm-x86/next
> > 
> > Like Xu (2):
> >   KVM: selftests: Add a helper to read kvm boolean module parameters
> >   KVM: selftests: Report enable_pmu module value when test is skipped
> > 
> > [...]
> 
> Applied to kvm-x86 selftests, thanks!
> 
> [1/2] KVM: selftests: Add a helper to read kvm boolean module parameters
>       https://github.com/kvm-x86/linux/commit/d14d9139c023
> [2/2] KVM: selftests: Report enable_pmu module value when test is skipped
>       https://github.com/kvm-x86/linux/commit/6cf332e8eca6

Replaced patch 2 with your v2:

  KVM: selftests: Report enable_pmu module value when test is skipped
  https://github.com/kvm-x86/linux/commit/5b1abc285a08
