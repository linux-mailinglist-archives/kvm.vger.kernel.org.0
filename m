Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54CA161FD1D
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 19:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233110AbiKGSQK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 13:16:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233048AbiKGSPO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 13:15:14 -0500
Received: from mail-oa1-x49.google.com (mail-oa1-x49.google.com [IPv6:2001:4860:4864:20::49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A210B1F2EC
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 10:14:28 -0800 (PST)
Received: by mail-oa1-x49.google.com with SMTP id 586e51a60fabf-13bca69ac96so5897928fac.2
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 10:14:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nK8Vi+UjziRLoue7EXArRiXmO/Z+70ll0i0TcleoCDE=;
        b=YrLgJSVOZMNPqyb3i4wSMTgWh2zywqXhE9T6cHo3Q2z7f21F2/Y9i5M/NFqA8Io6o6
         lOi9CCmOAga/Kw5oIGp5uBI6l7CIure9/fvz+WWxAW95gZ+24gKSssnkcTnsSIMi5HgA
         mUc0N9opT3ANTzj8QcEF78wnUJxN6oQnpI7kZ6BGOAjrqZ7GkmVwy3tO687Qt8V79iYx
         Fe9cq6I5KTeRlSsT3gmQMGBt3oene+jquFybvZLpSChHr7UhswitLcVfz1oWKF9RS179
         QAq81gtbMk4TGwxO17a2MbZGCXJVlvf9yeQy9lNs//hWYU6NwJk5ICeRcozMBhBVtOWV
         4odw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nK8Vi+UjziRLoue7EXArRiXmO/Z+70ll0i0TcleoCDE=;
        b=N+W8NUmHYZx4G41twxwrxpwW8y5CL+1gRTdow2qE4/3hNOsrHPXHDqfhxFxvhYHx3A
         Q837z4pox55Jnfsz+33WKc3DF7z131HBn2p1wXkp8Tp8HgtC7WUaFjrAZwxEJVH94txk
         MJX7NCq/iGf4ZoL6dOWM/OF4j8GwmDDD6Uuq8VhLnXrO30IlXhBbR91qPQoj1aU/xsxP
         Eg8pDXhFD6ACZf06MIfpLFHdIf6/Q20xTzjOeJSnW/Vb+24PRDUnxEjv8dnDM3bFfiEA
         XIu6A0qW0NDHdOMtsJzEGOclj+dUGvO+4ckdaGcWOqHKcFQuPPQ7tkGrj3oPc4Q9R/kw
         BK4g==
X-Gm-Message-State: ACrzQf0+TI8nAC9h2oPQD4wlnlbdNOeItZCtfeF0oSNRJzOktC6RhpRA
        KlYjVxWap2MhOER2q6Wp/DWysvCruYsw8WWH8Q==
X-Google-Smtp-Source: AMsMyM7c8hSzpHeT5UcGrZh2ugvvmwT5aeF+JYFGKMdTbPcKND+3ppbfd6QQUHpCFcOJ/BP/TaZ18C56Ln5mU9SVrg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6808:490:b0:359:fcf5:3c0f with
 SMTP id z16-20020a056808049000b00359fcf53c0fmr24850369oid.65.1667844867752;
 Mon, 07 Nov 2022 10:14:27 -0800 (PST)
Date:   Mon, 07 Nov 2022 18:14:26 +0000
In-Reply-To: <Y2PtlfbdebGfy47k@google.com> (message from David Matlack on Thu,
 3 Nov 2022 09:34:29 -0700)
Mime-Version: 1.0
Message-ID: <gsnt7d06tywt.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v9 1/4] KVM: selftests: implement random number generator
 for guest code
From:   Colton Lewis <coltonlewis@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        seanjc@google.com, oupton@google.com, ricarkol@google.com
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

David Matlack <dmatlack@google.com> writes:

> On Wed, Nov 02, 2022 at 04:00:04PM +0000, Colton Lewis wrote:
>> Implement random number generator for guest code to randomize parts
>> of the test, making it less predictable and a more accurate reflection
>> of reality.

>> The random number generator chosen is the Park-Miller Linear
>> Congruential Generator, a fancy name for a basic and well-understood
>> random number generator entirely sufficient for this purpose. Each
>> vCPU calculates its own seed by adding its index to the seed provided.

> Move this last sentence to patch 3?


Will do.
