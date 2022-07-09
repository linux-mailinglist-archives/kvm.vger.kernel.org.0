Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A09956C5A6
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 03:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiGIBPq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 21:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiGIBPp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 21:15:45 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C497C79EDB
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 18:15:44 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id v10-20020a05600c15ca00b003a2db8aa2c4so127399wmf.2
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 18:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m2rbmI68nFVIfuqr+PmKrXJj44QuaNuC9z2+ZoilH5k=;
        b=BQbxBRgOuEEdOSMbmzR/d8GB00emFvsruI/50lDNNIOi3JcOqZAEaivc49pxpee17d
         OGURQl7BvP1gsVZdMStvEIQAKwe7zxjUo9NXFitVTyHV+EeLQS6OYlAf+zVvn90sN6jl
         3qCMXVHec6oNUYBUjhpbSXBny2cPsTA5jPKtzb4NvPQOJD/7QWdgAO4LOMJV2XqWGjD5
         FKdWc9jYZES5g/tyfe9wF4FbXEvxaa0Rup0k00AkPeo2p0kqXUrPwMkvHA5QV21xtpKt
         DcEj94An/Kt2NIWZhsy0oo+0SFwWCjJIzFMsxkjO/siT1ym2l/OgMh4oEyPKBhXzS3aQ
         IF4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m2rbmI68nFVIfuqr+PmKrXJj44QuaNuC9z2+ZoilH5k=;
        b=tRMHbeo+5P41HFJn6cmWpVSMqf9hJ3J6c2p3EOjxdac/EDfW6YIyDLbhVXfqstnzPS
         ocjUXa5mulEBWk844hLZjcO6smNjemcIhg4T6QlIlAtTRT4ctEvay8i6J5l4WCG9n2ef
         FC8YerCplQbEYrLazaVSMtln4FlazZEuIvFxQ9d7LKaYuRHPlOg/J7QJGULAbcN54Ooa
         k/xNc4KhFi+URI3fjpf2hwoCgygQztu4zuq+dMbK80uW6lOR+VVK6XFrILqrF4mCpzu/
         r+tLOLgKd+bw73pEUcFPijVzC4iGtRGEPDJuCh0QBl6eRP/UA7egrBdi9XJXwkjLzVkQ
         dltg==
X-Gm-Message-State: AJIora/5QDdBgRkLQMCaRcJkqLiTBIOLE4IVu7OGmLdJm9QHWdSfVsoQ
        gbj2+5LZMFwbdQ7SWTkabO8SnZyJ5sLQaSWN6++dr+vqf9A=
X-Google-Smtp-Source: AGRyM1ufRJV3ytRwAoAWbBHWLDjJvFK5ZLyYK26/UX65jwTwhlroMzkukgV93gqeYYX78WizY5Njne1Eu6knNakEXYI=
X-Received: by 2002:a7b:c401:0:b0:3a2:ca58:85bc with SMTP id
 k1-20020a7bc401000000b003a2ca5885bcmr2745441wmi.156.1657329343358; Fri, 08
 Jul 2022 18:15:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220606175248.1884041-1-aaronlewis@google.com>
 <20220606175248.1884041-2-aaronlewis@google.com> <CALMp9eT3U+kLJTJJ_QP66LQPTQywVTuxucx=7JU74Xb7=xeY0g@mail.gmail.com>
 <CAAAPnDHFMdxpsP6TJywQWoMtOudYpc4Z3+pNq7OJA6223L0mcg@mail.gmail.com> <CALMp9eTwpnt6-Js3NHJN8uPAq2Zmgf9LPtyxcXNFefzEpxfyDw@mail.gmail.com>
In-Reply-To: <CALMp9eTwpnt6-Js3NHJN8uPAq2Zmgf9LPtyxcXNFefzEpxfyDw@mail.gmail.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Sat, 9 Jul 2022 01:15:31 +0000
Message-ID: <CAAAPnDGU=Ymdja4x-ZJFWACQ6A3sgeF=q9aTWSoiM3WGzwjWug@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] kvm: x86/pmu: Introduce masked events to the pmu
 event filter
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com
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

>
> Once conflicts are disallowed, how is the behavior changed by an
> 'invert' entry? Isn't the behavior the same as not including the entry
> at all?

Another good point.  I think it should work if I do two passes.  The
first pass to find if the event should be filtered.  Iff it should, do
a second pass to see if a masked event exists to negate that (ie: a
match is found with the invert bit set).
