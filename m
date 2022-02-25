Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E42D4C3B0D
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 02:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236440AbiBYBfo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 20:35:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236429AbiBYBfk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 20:35:40 -0500
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C054D2819A6
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 17:35:09 -0800 (PST)
Received: by mail-oo1-xc33.google.com with SMTP id u47-20020a4a9732000000b00316d0257de0so4447190ooi.7
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 17:35:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gJmZ1Ik14yTa54sZzh2cKdcUTTcI6YTSDsPnhoTpIgM=;
        b=bjZL3mDe+fHmzkZqyf2jBUlXG5GLQbGMp20j2gssduzQth7+ogt8yWfBBHxC3GhDtX
         NZpktaKcQLtEHy7arBalhkmvluX6Q4Li3lJ8rviQRRN7Tkuh+R/dqparC/JIJl2whK40
         ZbPlQmXYvs9jlB5VClxKIiZkYAsJpmF/rAEoSyQ7O71/PYEWkRWU0fqOzJNq2U2wtiqZ
         DHErmthT0ToCkk+WUo8+mcPGp5GzZ8/iKbysUddzXGx50iuPzt2expHeveBZRQzpSyho
         4vho9PZZW5fE/0vcaqKvpH+huh+7TV8bnkeWu81FnKvddkCSZl3VoSihAm7lE/j4dZRI
         qW0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gJmZ1Ik14yTa54sZzh2cKdcUTTcI6YTSDsPnhoTpIgM=;
        b=PlTME4cZ9tLLFyuNNo5Zn5eT89mfQWksUR04XdOjIkVvwKKI6pRZgtXNA3TwdKle5F
         hvJ68xiT2ucEz1uQa2qRxOHTB00Y2ZK68ECplcXzfKTa3HHsMjeWQlPHoXXdjQgb4sXB
         Dy4iAuCSU98nfLiTdVkbRZVqYpk8TR0neNoa9Z7g0MhaJ1r/STVwBbDQdAhIoGAC9Fjg
         2ExZmYHyJJovHyBw/NWAmCGkLuV7w6UFPAgOWv/WXVvJYWcvBVEYp7N00pqqIcSvIbpH
         8+n92eGu+XBJaMReOw58Eb+oZNj8Fo2pBYJVF/Zk/t/MeVgYzS9cO40wX4v5L1u2qJh/
         kdkA==
X-Gm-Message-State: AOAM532ABX3/CjcK54RKO/imTTsGHqSe/FQkX7iNIM3p0xIBDQYheTl7
        nx2zk7CQsOqE6l7RpmmdpaSNfpW+Gx8QERvkHsKFzLS0TUE=
X-Google-Smtp-Source: ABdhPJy3SrFewlpLYNV5PYcbYbWoamAHprFT5UjYWGzwVgdYF+c76ziLOrqfYs36jAIN9+7oOQo9j7NLcUcMixPns+g=
X-Received: by 2002:a05:6870:6490:b0:d6:d161:6dbb with SMTP id
 cz16-20020a056870649000b000d6d1616dbbmr380975oab.129.1645752908999; Thu, 24
 Feb 2022 17:35:08 -0800 (PST)
MIME-Version: 1.0
References: <20220225012959.1554168-1-jmattson@google.com> <YhgxvA4KBEZc/4VG@google.com>
In-Reply-To: <YhgxvA4KBEZc/4VG@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 24 Feb 2022 17:34:58 -0800
Message-ID: <CALMp9eTnB51PL8VUc2Do0wyJ_VqDDEoYKF_Hm_sF56x5-MxM1A@mail.gmail.com>
Subject: Re: [PATCH] KVM: VMX: Fix header file dependency of asm/vmx.h
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 24, 2022 at 5:32 PM Sean Christopherson <seanjc@google.com> wrote:

> Paolo, any chance you want to put these in alphabetical order when applying? :-)

Alphabetical?!? Not reverse fir tree?
