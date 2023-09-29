Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09D357B2A49
	for <lists+kvm@lfdr.de>; Fri, 29 Sep 2023 04:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbjI2CVd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 22:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjI2CVc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 22:21:32 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E3D199
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 19:21:30 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c73637061eso14458875ad.3
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 19:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695954090; x=1696558890; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z9zoN6a421MlDMvreAhrHw4b6Jgrx9b02kcGtCdvOkI=;
        b=sRaiZ/i77eX+Tng+f2pnY9Z9xCxNE237q+20gABY7XKx3So2Nkezaa2Sbf7iHwV3F1
         jjj5tPjza9jiaPEyXN2c8sSQGkw0c2oCzWv3jL7+IChUoUD+iKRD8qhTA5u+xOEboXRB
         hSSBmQUE0PeF89QThxlLpw4lxUKb+W7oSaNeERiuXR2W2alFJoKbdHrCuBistPhqBEcF
         zmSUbXN1o79S2++j8KGn3IEFoqeRv+e9XhjXAnYSRM79Bi89fxQsrgUF2mtnI6jdSFIS
         8nJ40f91Gh6C7YKQM3uu06FgS570eM2IzSHfbaQ2YFKq2yDsKP5oQNAXqCebWBIuvISk
         r/JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695954090; x=1696558890;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z9zoN6a421MlDMvreAhrHw4b6Jgrx9b02kcGtCdvOkI=;
        b=cCdmyBMAk8TmuCnEyYChy3j/VNVRad1pVPKrg8D1Ba7zBlDkimSdILfMNAS5daqcnU
         5+JPOm9IVxOfLE8IZg4sz1y9DaNePbnyEIClQcpzTzvLIpiRC8ncTpsz/Icw2wxRL3i1
         JT+gtrshqMtwA4ufK2ynDoFtDNSGZP1nh8FFZhRunO45t0O77wCVTSRCAJwRyoUbkC5V
         EnzNQBSLsfL8KgcAARIb/oN4B6y7wwKhGJU92zciUm7R5VzIEYapz+WfMe/d81Da3QZJ
         jFFBPccr9z2qfO4cU2GlRcxJGvcdWz7/Qs9//jb3Ub2kU37t1JGrRXkP34ej5A32wIhc
         jVMg==
X-Gm-Message-State: AOJu0YxTSaysUELE6Qy7x4aqlQNaAdo3lQxfCM/Ai8Pb9NY6LiYJ188P
        KI53pGZ3lya7GF06CxcsOgcs5brK/Js=
X-Google-Smtp-Source: AGHT+IHnY3PM0N9nXkzTID7pmOvxbshX9bpM4LV5jr3yfP+ll/piv6IfuVpFGkrfmCMVy9vHPXNpcljhxAQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f54e:b0:1c5:de4a:5b44 with SMTP id
 h14-20020a170902f54e00b001c5de4a5b44mr43203plf.0.1695954089709; Thu, 28 Sep
 2023 19:21:29 -0700 (PDT)
Date:   Thu, 28 Sep 2023 19:21:20 -0700
In-Reply-To: <CAPm50aKwbZGeXPK5uig18Br8CF1hOS71CE2j_dLX+ub7oJdpGg@mail.gmail.com>
Mime-Version: 1.0
References: <CAPm50aKwbZGeXPK5uig18Br8CF1hOS71CE2j_dLX+ub7oJdpGg@mail.gmail.com>
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <169592099261.2962597.3938666115023271118.b4-ty@google.com>
Subject: Re: [PATCH RESEND] KVM: X86: Reduce size of kvm_vcpu_arch structure
 when CONFIG_KVM_XEN=n
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
        Hao Peng <flyingpenghao@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 05 Sep 2023 09:07:09 +0800, Hao Peng wrote:
> When CONFIG_KVM_XEN=n, the size of kvm_vcpu_arch can be reduced
> from 5100+ to 4400+ by adding macro control.

Applied to kvm-x86 misc.  Please fix whatever mail client you're using to send
patches, the patch was heavily whitespace damaged.  I fixed up this one because
it was easy to fix and a straightforward patch.

[1/1] KVM: X86: Reduce size of kvm_vcpu_arch structure when CONFIG_KVM_XEN=n
      https://github.com/kvm-x86/linux/commit/fd00e095a031

--
https://github.com/kvm-x86/linux/tree/next
