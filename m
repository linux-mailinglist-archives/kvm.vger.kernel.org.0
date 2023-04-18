Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A95646E67E7
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 17:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbjDRPTJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 11:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbjDRPTI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 11:19:08 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A6E118DF
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 08:19:02 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 188-20020a2504c5000000b00b8f6f5dca5dso9692543ybe.7
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 08:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681831141; x=1684423141;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7MmhDtuqEjzktXZMZUjTd5/IRF+IYVg/to26fXE0GgA=;
        b=cXwIKIbKcePgE0q1ohaCKDZjHkJcA4ZV0ksHYDn//I4wmobuvoBzNsVE0c5gNwcOTo
         qfw6MfVqURVUymOpmFD/viT8NRh+/QPqkWGEP/zZC6JAcCptnls0LrnevKyEF9kelJ7S
         srbQuo+GMmO8LJnlvFoQmWfdUkTjc8FC4m5lkUQlme08GLiW6DAKOYmxR0yi50X4h+qv
         h8By7Kfva1zzmByAJbHa/Mytmh7tykK5D/Pel80uXRpiw8cLZsffNvZIqTuZC8MRYm2J
         7vneSyP+Ito5NYrvaeBljLBKmrP/DymNuxovYVToho1y7CNqmZEUY0dyY3rMDWtKG2kh
         AQXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681831141; x=1684423141;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7MmhDtuqEjzktXZMZUjTd5/IRF+IYVg/to26fXE0GgA=;
        b=emuN5aZHhoLYzitLyYlf0uoMVXMVqJbPFhy/qksC2ODdGWtQdO1KbtfKFvxdibQdCU
         ebAXZUcXEph7XRrh66GElGfVga8TeRRQZOMrOLmWO4h67iTiDMh1p+SEY2TjwxuTm9+g
         lamGDs73sXbfq4xzdHgixssFW8yfg/slan0WZhFAWX1HE8e59TtxO1T8NTBhl5KeC8C5
         rRQ2zHNxrSMOmZj0cEyj+0lYMNnSQVIU9jojWUllr8T1mlAZLXgjsdaWMkI8e3JTFNHb
         X6eGNGnttUMRjXgUS+9SvpAVI6ZErA4mFOC4TJfd6IRPxz2vxvzAv8b7qU9lmKqTAM19
         fVjg==
X-Gm-Message-State: AAQBX9fz84A3m6RAebPfqZRZkIbcp4MuoLP8uayDbHVmxcG3DKQXp2i+
        +cdB8GDH97DRGY5CfmaIq5Kd/fRs29k=
X-Google-Smtp-Source: AKy350Y+AP5rglL+RyREvKohVZkyrZn94gtw9e/Bj39GeBvGlorG7JZnxzCrYv3zUY1rwsaF5NPi9Vbvcww=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d651:0:b0:b95:f0de:240e with SMTP id
 n78-20020a25d651000000b00b95f0de240emr560829ybg.11.1681831141681; Tue, 18 Apr
 2023 08:19:01 -0700 (PDT)
Date:   Tue, 18 Apr 2023 08:19:00 -0700
In-Reply-To: <20230418104743.842683-3-alexjlzheng@tencent.com>
Mime-Version: 1.0
References: <20230418104743.842683-1-alexjlzheng@tencent.com> <20230418104743.842683-3-alexjlzheng@tencent.com>
Message-ID: <ZD605NFbjiCBX9jW@google.com>
Subject: Re: [PATCH 2/2] KVM: x86: Adjust return value of pic_poll_read()
From:   Sean Christopherson <seanjc@google.com>
To:     alexjlzheng@gmail.com
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jinliang Zheng <alexjlzheng@tencent.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 18, 2023, alexjlzheng@gmail.com wrote:
> From: Jinliang Zheng <alexjlzheng@tencent.com>
> 
> Returning 0x07 raises ambiguity when no interrupt is in pic_poll_read().
> Although it will not cause a functional exception (Bit 7 is 0 means no

From KVM's perspective, it's a functional change.  It _shouldn't_ impact the
overall functionality of the guest, but we have no idea what guest code exists
in the wild.

> interrupt), it will easily make developers mistakenly think that a
> spurious interrupt (IRQ 7) has been returned.
> 
> Return 0x00 instread of 0x07.

Again, I do not want to introduce a functional change in this code without evidence
that the change fixes something for a real world guest.  Based on your response[*],
that is not the case.

A comment explaining the KVM behavior would be very welcome, but I'm not taking
this patch.

[*] https://lore.kernel.org/all/20230418075923.752113-1-alexjlzheng@tencent.com
