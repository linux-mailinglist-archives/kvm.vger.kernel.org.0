Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E07DB6C8726
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 21:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbjCXU7O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 16:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbjCXU7M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 16:59:12 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D66915BA7
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 13:59:10 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id j18-20020a170902da9200b001a055243657so1801520plx.19
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 13:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679691550;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=p9HVc9ROAwxj1T5XSwSM6jTJhWsZF2YjsZMLagutpAk=;
        b=nG+ns6HOKK9IFiuCCbFFXuKgKoM5+4wxnff/E81xdQ9GmY43qhPtjkaZ53NyDXmV/g
         NI7j2o61b8wjKHNY8GQF4YnVO42ZJqPsoAtl38QME2qD4PCsJZHQ3oyvTzU3/g+lVPiH
         tSavc+MJFmCXtZt/e8ZpcNYzFObAQlv06GYcGyRdvxemnLahdmPIfNhCHT3usOt+jpHt
         e4m6tsNvhkhpQ6ZkABuLAK+L37wwS7S8f7vRlRnnNhLk+SQ5tYn6E9s9Ih1egFQSakG9
         DxDuBzqP9fQhpprXRqCdHHlkFqL8hTmRoknipDPVVgBV8ZKJ0P5/ejO/cYYTxO4L0/FU
         4eUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679691550;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p9HVc9ROAwxj1T5XSwSM6jTJhWsZF2YjsZMLagutpAk=;
        b=QGZcWKzrzqSCoQc1Hql/8ryiVzOoAHSsxXF/C3Xr2bmAktw1cI16iftxrgGfq/jlGB
         Pwq6X72Pt86kzdKwoXOX9VervtpA0hl8LbS0/mYst42R3gJBTBR/qHhMDa3vrY1ng70S
         3a1I/tEMJarXeMO9L8aILBhQk9MQUYQ8WtOCLDBdpQs2QbHmaqUuDte1z9EH/HbnC85K
         rIG3ErdaDe+porqzaIwwzQkvoiBdyCYQvhMXPdSCB6bUqvutOsF0qQPOqXpIuJDQ6ZZB
         JuKJw5BgJTbVFjKaTTwPeTohHofQTEdjGSthcEV61mAeOttMwK0yTIj4puA+5gg60ptr
         DuvQ==
X-Gm-Message-State: AAQBX9dJrzd8JFw6TCzWSuMdcVyNS3o3QrBdriEIMagULylWXb4zqeVJ
        ETGYwEL5f3fiST+GGGEkgAlfp4t6cP0=
X-Google-Smtp-Source: AKy350YzPAVVOPgI8VKU2bnl+Wyxr3EsAYeZ7LM9dEPiq3iWHBsFwsxfIepC+EA3/f2ixatSqc9+nSPKsLk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ec04:b0:19c:d14b:ee20 with SMTP id
 l4-20020a170902ec0400b0019cd14bee20mr1400609pld.8.1679691550230; Fri, 24 Mar
 2023 13:59:10 -0700 (PDT)
Date:   Fri, 24 Mar 2023 13:58:48 -0700
In-Reply-To: <20230223001805.2971237-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230223001805.2971237-1-amoorthy@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <167969136798.2756350.4823760762125530813.b4-ty@google.com>
Subject: Re: [PATCH v3] KVM: selftests: Fix nsec to sec conversion in demand_paging_test.
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Anish Moorthy <amoorthy@google.com>
Cc:     oliver.upton@linux.dev, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 23 Feb 2023 00:18:05 +0000, Anish Moorthy wrote:
> demand_paging_test uses 1E8 as the denominator to convert nanoseconds to
> seconds, which is wrong. Use NSEC_PER_SEC instead to fix the issue and
> make the conversion obvious.
> 
> 

Applied to kvm-x86 selftests, thanks!

[1/1] KVM: selftests: Fix nsec to sec conversion in demand_paging_test.
      https://github.com/kvm-x86/linux/commit/f6baabdcadd1

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
