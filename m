Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8E7B23168C
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 02:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730450AbgG2ABj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 20:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730110AbgG2ABj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 20:01:39 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC98C061794
        for <kvm@vger.kernel.org>; Tue, 28 Jul 2020 17:01:39 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id s189so15433297iod.2
        for <kvm@vger.kernel.org>; Tue, 28 Jul 2020 17:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8XkyWGDBtbZKzOaOShYJKTEnyEVVaISF88UxbpxpW24=;
        b=hPhGUzs6xSlbNCUnN5ENUQ2bqcOMwofvm/bSyqjDn5UZrSkmnkTfoNc4UzdIZ/7m6X
         DIQM3w4QSO+rpZ7k6v57H0Jq2S/b7myCXPs2//qDk9W/el5a0vQGb4m3UxuZiCMJEe6G
         QbcXWnEH7feItnmCLtdl3qstnxvZphTXmxihMJh13J53vNdDn+YchYG6NWsxkUsAQtmT
         7VsoljeD6LrmxtMmSbJWgca7xja+Nvp+9KGmCALC5MbZttZh9Xvo6SuNQHBFCBlZFpSk
         7cZwKUnjT9KVr5SY7LWz4ILiytfrY4M5eev+6QZcXWlgArK5Zb8lbVFyUPRUsVwfiP56
         CuEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8XkyWGDBtbZKzOaOShYJKTEnyEVVaISF88UxbpxpW24=;
        b=bjfi0dkaBFPCAyZZISiu7F/toP6nOe2LH20YkssMdsFjFfrdm95vamhbOP1jtfJ4eu
         RRbHMcLGxAJqers9g4Zv98ZJgcPzbqFRs6F06A3nVzOTa07rIU7f6T+u+7mod6sO5Cy/
         XwUkibQpJokM7XdbxnBssNTuWeDvCfXLtNNyCDfkBxihJyf3aw5R+Nops7bBNVoSXCYD
         yhHoIjYX2jUJDfUU1+lgXPpD5kpni1yFXq8V1cfrqTJoYLX81XD3PEUlQJh79w0txWXc
         ZkLIjmUrHuQuHbZtBSRwEnGqUAjomdq2mTfuX+Cpxv0fNxgVn7rN1SE0yBMvcUoqMxCF
         +LtA==
X-Gm-Message-State: AOAM531odiCsvTWnG/sbfY1P9K6SMBKBVOKb2tYLYOrTNsz/PQoqqWKJ
        uyao6lgk4EWMupAq/8rA0DCcRYru/OrJ68h5OCXjcA==
X-Google-Smtp-Source: ABdhPJzjWvD542dhVukYVQQMW5U9zxcyUVZ+VZBDt1u6koTpGVlpV1NuE6aVl5uBNUoGzpd3RzJqE1naVz43ToAHomY=
X-Received: by 2002:a5e:c311:: with SMTP id a17mr31245268iok.12.1595980898226;
 Tue, 28 Jul 2020 17:01:38 -0700 (PDT)
MIME-Version: 1.0
References: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu> <159597952011.12744.5966486013997025592.stgit@bmoger-ubuntu>
In-Reply-To: <159597952011.12744.5966486013997025592.stgit@bmoger-ubuntu>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 28 Jul 2020 17:01:27 -0700
Message-ID: <CALMp9eRQyA+Mbu0iLqt88wv_sVxvJ=PX735tG99ji4WqSeWkPg@mail.gmail.com>
Subject: Re: [PATCH v3 08/11] KVM: SVM: Remove set_cr_intercept,
 clr_cr_intercept and is_cr_intercept
To:     Babu Moger <babu.moger@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 28, 2020 at 4:38 PM Babu Moger <babu.moger@amd.com> wrote:
>
> Remove set_cr_intercept, clr_cr_intercept and is_cr_intercept. Instead
> call generic set_intercept, clr_intercept and is_intercept for all
> cr intercepts.
>
> Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
