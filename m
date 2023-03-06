Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 740EB6AD128
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 23:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjCFWII (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 17:08:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjCFWIG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 17:08:06 -0500
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F68234C6
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 14:08:05 -0800 (PST)
Received: by mail-il1-x149.google.com with SMTP id l5-20020a92d8c5000000b00316f26477d6so6017673ilo.10
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 14:08:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678140485;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=O2cEi75bvpWmHU9egbpkR6oY/ujBMoJwfRR97U/i4FI=;
        b=AZW/wYSQI/0cMhcJDHbqcNA4uJo74U3fqrAa/4Ys3S6ysIcE7zcvKSAJ0b6ELHNRzs
         uC5c1TcUc1qo+SKzXcDQyXcDnXtl8fDUYViyrshryjJtiobn/uNURwAxGtCK+svqZf6x
         r0lZhDSFur/YhXzdF6cE1jLRtV6Pq/ijrKNgOritasuRN3BCFe+C2+nY/afgg91EqRCJ
         9hjEXt1XktFVNQmCCKQzfWfIEL7jSHdlV5O4EquZI9ebc91U+2R6dhDXBc4UtYf3eusI
         7YUMqMPyWitfNxrIt4LocjqEMXlGomxFvqSYRDfHCQUkMop9PNZ2dB793heP5TNN7TH3
         WmKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678140485;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O2cEi75bvpWmHU9egbpkR6oY/ujBMoJwfRR97U/i4FI=;
        b=xdIh8fbSmV0+n7ABUpBtSdbd3iuuAX9xL2x64rp7DHXxzfnZNQOlnCDv7ktWu/rFO2
         DmDxnR+MQF0iBEdUPQghwbEaDxOYbJ7niEM8f5OJlkRw7Z/cA/NkbwqeTxxpc/g0jEyV
         a013mGN5GkY8OwzuKAli0dE08PAqPX3p1Zb5bG1yHsX3VTg8YwOlBK7r04dE7K2PuEjz
         bsluzss+oe0xVRVxpvj6NzGSQi1LRIdyd/Q93Jjh8sB3FR7Kfz1kE4x/oTFUJBB9TEv8
         O5DeqSgWQUrfzRCC5MTljmP7fwaWOehrN49bdXv0cIqhYH2TDeHjs2mwBWI+73hDwgMf
         9aeQ==
X-Gm-Message-State: AO0yUKUUtLscbZL4eMD1SnI03ayTRLdVjNr5w7zzabZ8+49OMCePTFmy
        urpQBgmAVSZ/PX52HYkq0Bms5cIyP9csrVS5sw==
X-Google-Smtp-Source: AK7set84D89LW2JBMKLJQ8HQvLSBXW2i45PmvFm623iO6ZX1ecHaKF8zMs78U1/PZFK33LnTbyLGYk2ngqBmMTJYlg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a5d:8d87:0:b0:744:f5bb:6e60 with SMTP
 id b7-20020a5d8d87000000b00744f5bb6e60mr6404696ioj.1.1678140485037; Mon, 06
 Mar 2023 14:08:05 -0800 (PST)
Date:   Mon, 06 Mar 2023 22:08:04 +0000
In-Reply-To: <20230216142123.2638675-16-maz@kernel.org> (message from Marc
 Zyngier on Thu, 16 Feb 2023 14:21:22 +0000)
Mime-Version: 1.0
Message-ID: <gsntedq18rej.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 15/16] KVM: arm64: selftests: Augment existing timer test
 to handle variable offsets
From:   Colton Lewis <coltonlewis@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
        suzuki.poulose@arm.com, oliver.upton@linux.dev,
        yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de,
        dwmw2@infradead.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

First of all, thanks for your previous responses to my comments. Many of
them clarified things I did not fully understand on my own.

As I stated in another email, I've been testing this series on ECV
capable hardware. Things look good but I have been able to reproduce a
consistent assertion failure in this selftest when setting a
sufficiently large physical offset. I have so far not been able to
determine the cause of the failure and wonder if you have any insight as
to what might be causing this and how to debug.

The following example reproduces the error every time I have tried:

mvbbq9:/data/coltonlewis/ecv/arm64-obj/kselftest/kvm# ./aarch64/arch_timer  
-O 0xffff
==== Test Assertion Failure ====
   aarch64/arch_timer.c:239: false
   pid=48094 tid=48095 errno=4 - Interrupted system call
      1  0x4010fb: test_vcpu_run at arch_timer.c:239
      2  0x42a5bf: start_thread at pthread_create.o:0
      3  0x46845b: thread_start at clone.o:0
   Failed guest assert: xcnt >= cval at aarch64/arch_timer.c:151
values: 2500645901305, 2500645961845; 9939, vcpu 0; stage; 3; iter: 2

Observations:

- Failure always occurs at stage 3 or 4 (physical timer stages)
- xcnt_diff_us is always slightly less than 10000, or 10 ms
- Reducing offset size reduces the probability of failure linearly (for
   example, -O 0x8000 will fail close to half the time)
- Failure occurs with a wide range of different period values and
   whether or not migrations happen

