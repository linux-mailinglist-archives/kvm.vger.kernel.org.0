Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6F57783BE
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 00:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjHJWqA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 18:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjHJWqA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 18:46:00 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E14273D
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 15:45:59 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-586c59cd582so17606157b3.3
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 15:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691707559; x=1692312359;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=H4ULGci66U2bXOQOw2/WG/HzrEX/K4iTLMow73bqLrI=;
        b=AAjBT0o5auDHY2sPvkLbXrS5P+a748N7MXxIlZ4Kj06hg67kx3n3G0JhdWXDbk0cvO
         5CYM97j4+6fi/V8QERHYoktT1EkGxPbsBv7TVWqLQ3RBZsRvCSD8vjFy98rsborhEqeg
         qxMjYs25DTG4ecnpfsE4+s1ZEEaqpT0XX9QEHRs7oICPXMv5JJb5ARtZkKUrMxDyPRbZ
         GFJnxSQ3SZ9RltlVq6wSgM0HukJiuF2ulB+M/VrMFjp9JLeeN0UeYZ1RUP5zRFOuRJwI
         vsEjb1ZIt6vTN3lzyBO30xzSfahiilsRINhuFYYRWjbZFG6W1w4qNR4OfwyxOM5iDl3n
         TAgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691707559; x=1692312359;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H4ULGci66U2bXOQOw2/WG/HzrEX/K4iTLMow73bqLrI=;
        b=chMx9Ta4OdYLKY45b6Fzo5iw4l0ST5QqNKjBHVD0J2lr+tadYXYf4iHvHRHxQODmcm
         LA78MF7HdHZqHNhK8tcjLTRZ6nL7lu+0feWqnc4Q+l62gn7ajKJHPnWAkAiTFKqjT+0Q
         352QaNfl9XdeWSfD1W+g6Rl0XYN8TcB6ywXsdnQgNIwUIK6NrRLrFI8FLphOmd/Z/n0C
         YWpvYlpSZacnLs6sJ2NcIbfT2N42Gxwpnilx3ysLdOb1SpCQ0IdaTFGxyvrHxLiTjZZj
         X6need0na9lSYaQFAwatlONDfMJpufiZJgaU+8c7w0VqVh3hhH+hgTCc7+/p7+Hqri3h
         +Img==
X-Gm-Message-State: AOJu0YzAqWqbM9m//2S7YMUdeld2hPr+8j33prK6YU45gxl0swpNsE9+
        GsVU8WKC2WPBB2S1i3/OvsEqHmW5P7M=
X-Google-Smtp-Source: AGHT+IF2KQFLhJci/blcOPeyU0KNDK+T3UeogeP2CoDEVfwDeku2bwRWUSUvQVGD0J3LCrLiu28Up1cCYM8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:25c1:0:b0:d07:cb52:a3cf with SMTP id
 l184-20020a2525c1000000b00d07cb52a3cfmr1686ybl.5.1691707559060; Thu, 10 Aug
 2023 15:45:59 -0700 (PDT)
Date:   Thu, 10 Aug 2023 15:45:57 -0700
In-Reply-To: <de474347-122d-54cd-eabf-9dcc95ab9eae@amd.com>
Mime-Version: 1.0
References: <de474347-122d-54cd-eabf-9dcc95ab9eae@amd.com>
Message-ID: <ZNVopRMWRfBjahB9@google.com>
Subject: Re: next-20230809: kvm unittest fail: emulator
From:   Sean Christopherson <seanjc@google.com>
To:     Srikanth Aithal <sraithal@amd.com>
Cc:     kvm@vger.kernel.org, linux-next@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 10, 2023, Srikanth Aithal wrote:
> Hello,
> 
> On linux-next 20230809 build kvm emulator unittest failed.
> 
> ===================
> Recreation steps:
> ===================
> 
> 1. git clone https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git
> 2. export QEMU=<location of QEMU binary> I used v8.0.2
> 3. cd kvm-unit-tests/;./configure;make standalone;tests/emulator

What hardware are you running on?  I've tested on a variety of hardware, Intel
and AMD, and haven't observed any problems.
