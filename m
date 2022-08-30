Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD635A6CB1
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 21:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbiH3TCf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 15:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbiH3TCe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 15:02:34 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC18D5E326
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 12:02:32 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-33d9f6f4656so188043417b3.21
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 12:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc;
        bh=g9fHXRQMjR1WftTF0Pm4Vs2SJMWfpbzJ6q7WYa79n+I=;
        b=JLH7lKBfePsfrglOvQ2HP0oY4AxeJa8QDowxrEDfRLI6kG/axJlipsOAyw9AbowhSq
         WrDmAd5/bJbyctVgqRiHKtghPnkdEDWhUQvtUEdHmBZriTUgV7FJZbOAgBB7ToMiQm6Z
         4p8z/A4j7e8OnmG0/1O5xnKRZmogeXxO0heDQahdOq5wRwT29PgIszI5FAE7gEsfJlN3
         yDa+VxSvCAStnNGQ5FJ73DeLmaYSb1Z5CuUYWDTi16WiZ9HJexzu+ptGkcCOEyS718fj
         NZPoc4DGjpSR694EDzq4XtzOtYzkXqm3wOyqpCaUdswtR712L0akQxzFXxcjaDrTE9we
         w7Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc;
        bh=g9fHXRQMjR1WftTF0Pm4Vs2SJMWfpbzJ6q7WYa79n+I=;
        b=tHm8nk0GT3na+m8UK4zvxjVFkMJ2XGF7VBsX44dRgKCXwmKeSR3Q5wMw64byThlB2+
         m/zUG8QwRRW7QcsDFZhAGo4pDxH/LhEnr59pGkuMBmsQgYLewcwIexNdTCZbquIP8afU
         /eDzWrpHubHIfnRyI2mhxNKeFgGFYFb7P2/k290mEN1IUockNaEs6hJl0o4sJGmwdgal
         MR7kqmQ5rP1KHniprxEM5ly9mzkqR9TKMqwcC6z2mBM+JoJt94aGfoXLhoXf5Oim4qVK
         01lfPa6/3DtAYAfKtonSN6hjtqm40/vejmmkToe0UAOy3P6aVvPykdGEluVCbxshMRQJ
         Y74Q==
X-Gm-Message-State: ACgBeo2rdghcdRXaQqWpVn94xndI5pk/Wu651VQCSr/mGhlZr6yNfgiD
        eRq0FBBKGZv7jyNzT3F+VZ+Qr/OGx0wuhw/8iA==
X-Google-Smtp-Source: AA6agR6ykG8d45Ks/qTR6H/S7+HK1XSqEaPyvYIwAMk22mnFVplimzAxSy6ucXyKJ4saux1dkzwOQvJHNIe+6d48eQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a25:741:0:b0:696:4b8c:956 with SMTP id
 62-20020a250741000000b006964b8c0956mr12253220ybh.266.1661886152061; Tue, 30
 Aug 2022 12:02:32 -0700 (PDT)
Date:   Tue, 30 Aug 2022 19:02:31 +0000
In-Reply-To: <YwlHJnZORkp2XRmJ@google.com> (message from David Matlack on Fri,
 26 Aug 2022 15:20:22 -0700)
Mime-Version: 1.0
Message-ID: <gsnth71two54.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v2 3/3] KVM: selftests: Randomize page access order.
From:   Colton Lewis <coltonlewis@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        seanjc@google.com, oupton@google.com, ricarkol@google.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

David Matlack <dmatlack@google.com> writes:

> On Wed, Aug 17, 2022 at 09:41:46PM +0000, Colton Lewis wrote:
>> @@ -271,6 +272,9 @@ static void run_test(enum vm_guest_mode mode, void  
>> *arg)
>>   	pr_info("Enabling dirty logging time: %ld.%.9lds\n\n",
>>   		ts_diff.tv_sec, ts_diff.tv_nsec);

>> +	/* Set random access here, after population phase. */
>> +	perf_test_set_random_access(vm, p->random_access);

> Optional suggestion: We don't have any use-case for disabling random
> access, so perhaps this would be simpler as:

>    if (p->random_access)
>            perf_test_enable_random_access(vm);

> And then:

>    void perf_test_enable_random_access(struct kvm_vm *vm)
>    {
>            perf_test_args.random_access = true;
>            sync_global_to_guest(vm, perf_test_args);
>    }


I don't think it's simpler and it's less flexible.
