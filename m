Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBB268E5D2
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 03:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbjBHCIM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 21:08:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjBHCIL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 21:08:11 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BED4CC13
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 18:08:10 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id p27-20020a631e5b000000b004f3880f6673so5852242pgm.14
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 18:08:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kdeur/wsj093xZjhkQILgu2CoCtxzNYrUTV2HfeSqDQ=;
        b=qUvwhQNTASGKsF9jBjCBXYmf8gZ+IZf9UYkjsE+SdjikI0JPapnrcKl5LAU9aGdaWI
         dXC54ZZYDFK74OWwseJ9WBYOQTFIUsGC7Ys2X/WBxmMxWjsl/P8aXvMIatBpxHZqtxaa
         9FFCxk76wyZd7r5uoVAi1hWsPxgQW7WqHMpbJXoIAIFHJa+4dbnr64SNbDFkEeE7YYCH
         aBVK6vzS0zUC8XlxKalgIdcTlodt3NN3Ofg8yVJWbRPDfvLjhW3KFu4hf0Nc2wI3PKdr
         vpr0Fs3XhWUnMb0pARLhuDhAQ4dPDQY96E5nWo0eyKQgFRmf9taPme1RtugRaEy5wQP+
         312w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kdeur/wsj093xZjhkQILgu2CoCtxzNYrUTV2HfeSqDQ=;
        b=DzR1DC/2NeArkmaZWXLh/1dZDO/GsPKOlFx2061a1HviB6rphPenUgSu9sD/0+R6G4
         VoqIt56v2qrPbESbUr4VXx8vHWNmxxmhfKVmPeCqwG5QxzCluQND3pRb3P2oPNLETFUK
         N0Q3+VuPyX+KsqnmeWYVnWT7P4aPkYDze7XYADecVZjHrnQ2na2l7Cxo2XK7EX/3biCM
         vJ3pS+yOFlQK7nh0pNmA2FzPAvrViLmd82IjhKTnBuXOZWZjURUYb9jY8ui6By933Fyk
         nYISVzFGENuvyvFe/UufU8djDr0QvdRs0xZEZdIBmQBK+KbrjBn/eIIgUmwhPIMaFOMq
         JCig==
X-Gm-Message-State: AO0yUKVXmNGtDr2tXmm9w6DVuKRXR/pJUoirkpwwrHC3iwAHJRsN01DG
        PmG/WjnBkrHVbva4fN0FMzUDWlKbqjw=
X-Google-Smtp-Source: AK7set+vgyn3wY4rTBKErGgsYMgn/QHruHs+YGebobew5yCDK3AWs+clhnbFkQa2oXijZ6Lkz5NOgTDv90A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:182:b0:199:21af:cb8e with SMTP id
 z2-20020a170903018200b0019921afcb8emr1323668plg.21.1675822089820; Tue, 07 Feb
 2023 18:08:09 -0800 (PST)
Date:   Wed,  8 Feb 2023 02:07:26 +0000
In-Reply-To: <20230118092133.320003-1-gshan@redhat.com>
Mime-Version: 1.0
References: <20230118092133.320003-1-gshan@redhat.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <167581358112.362323.5029488346682062350.b4-ty@google.com>
Subject: Re: [PATCH 0/2] KVM: selftests: Remove duplicate VM in memslot_perf_test
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, kvmarm@lists.linux.dev,
        Gavin Shan <gshan@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        pbonzini@redhat.com, shuah@kernel.org, maz@kernel.org,
        oliver.upton@linux.dev, maciej.szmigiero@oracle.com,
        shan.gavin@gmail.com
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 18 Jan 2023 17:21:31 +0800, Gavin Shan wrote:
> PATCH[1] Removes the duplicate VM in memslot_perf_test
> PATCH[2] Assign guest page size in the sync area in prepare_vm()
> 
> Gavin Shan (2):
>   KVM: selftests: Remove duplicate VM in memslot_perf_test
>   KVM: selftests: Assign guest page size in sync area early in
>     memslot_perf_test
> 
> [...]

Applied to kvm-x86 selftests, thanks!

[1/2] KVM: selftests: Remove duplicate VM in memslot_perf_test
      https://github.com/kvm-x86/linux/commit/e5b426879fc3
[2/2] KVM: selftests: Assign guest page size in sync area early in memslot_perf_test
      https://github.com/kvm-x86/linux/commit/45f679550d72

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
