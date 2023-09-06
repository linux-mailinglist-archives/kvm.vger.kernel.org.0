Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 685247943FF
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 21:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242697AbjIFT4K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 15:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241865AbjIFT4G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 15:56:06 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B711724
        for <kvm@vger.kernel.org>; Wed,  6 Sep 2023 12:56:02 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-59501b014f4so2806027b3.0
        for <kvm@vger.kernel.org>; Wed, 06 Sep 2023 12:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694030161; x=1694634961; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Op44xSZ18T8lyHwRCrYU4O2AD6VMTohVe5tEwcZQ8PA=;
        b=Zj01IHhRpMb54nSiAFiV2XFNau9q3QVhxr6qq2Z7O8aauullFtg12IT9qJ4DQ0EP0K
         //F+CSzIm4eFcejdZMLjLc+C+ZB8jORSn6jOYMilI1PF/S0RGrnkvnjRmF8+VfDau/cc
         NZzRPGizPjozqvQeJAdbyTodqj4R19y7XKXBtqBabVkHhAkm1cMtdWOYahsT2JCLM4Gf
         QHX3m3ES3VgyAm6VqgyEiRpzb62jJbS7XQlWsJOrqDZ+0WVikB0ZNu8yuQi/Ll9wDNcJ
         Kf8DX+dcUW/knoO3+1hsUyawL9tNlb+Zyh77HO7MbrqplKfFgj0xXZckYhY3mhcFYsVF
         TbGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694030161; x=1694634961;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Op44xSZ18T8lyHwRCrYU4O2AD6VMTohVe5tEwcZQ8PA=;
        b=O/C+iPVA4xKjTVt2DVb1ddzg+Rvt40zXsub+/yF/MVF/hqMedReNV1trvV3YO42Ecg
         C/egVsBOoMEGWRRVyb+JcMc5XlEv394y6lO7YpYTU2mELu5sZsEK01n4Mj7PLy6h+PZ4
         GeGQdtWdPLaXaEBYzm/DDMCLykSe94+KAXGCPYrARRLOuHfzR82dxSVZ9+pU51YglYtJ
         JfuI/9RDnJorRA6M9ye31mIe/u0k1LlefeCZPU//9m62EoktPTlMs2LVfuH5mTX00IJR
         gXLd6bNY5+6eNtqArHARsw42yLbrURm2SeMQJ626pfQrvpGfw6e5MvPCQdja/dp/o4JO
         LpqA==
X-Gm-Message-State: AOJu0Yxzl4C54aQU4QWxeu2XAB/Kx6ldZ6weYmM7B/POKU0jJervHTza
        41Ug1Sp1w+9qYkdMksgiTXveRT3dSXZhBcy86w8wDMkvdRq+dzUvPlOVAka3OwgA5qAedKbupJW
        zhLrTyOfV/4IEaDd7GaDl4XvaLlUPcH4aC3mWqCRHfnc0sgdTSK9G8dmqQg==
X-Google-Smtp-Source: AGHT+IElmezyAZuhMQzTl/Sk7vPNTCNoUPzlYa2syrQ7BTn8+o6eKVIx89oi4Cuo7O2wkISUyMw/EFo9ef0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:e40b:0:b0:592:8069:540a with SMTP id
 r11-20020a81e40b000000b005928069540amr420956ywl.8.1694030161662; Wed, 06 Sep
 2023 12:56:01 -0700 (PDT)
Date:   Wed, 6 Sep 2023 19:56:00 +0000
Mime-Version: 1.0
Message-ID: <ZPjZUE2qmXhb7So8@google.com>
Subject: [ANNOUNCE] KVM LPC Microconference Call for Abstracts closing on
 Friday, September 8th
From:   Sean Christopherson <seanjc@google.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The call for abstracts for the KVM Microconference will "officially" close this
Friday, September 8th.  We will review submissions next week and publish the
schedule no later than September 15th.
 
Apologies for the short notice, I was originally thinking we'd wait to publish
the schedule until October 1st, but we ultimately decided to go with September 15th
to give everyone more time to prepare, book travel, etc.

Thanks!
