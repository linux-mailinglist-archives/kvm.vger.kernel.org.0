Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E403DBDC3
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 19:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhG3RdD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 13:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbhG3RdC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 13:33:02 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A33FC06175F
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 10:32:56 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id m9so13392326ljp.7
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 10:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yIDDxq5moGpDeArfNpM/54jwiqwmK/kaH7+R0E9/Sq8=;
        b=tor66oVSSmzcDYdetg6yiI3T1AqvGNbsE+Wj5B/xDAkbohTIFqA1yvdtNAudOF+3sV
         uFS6VTpD5R14DJ3MpT+PXwd0n+BK3+C7xr5rc+FEMMQJ9qClpp/p1Pt3ows2mVdPTApj
         Y0sCBbng4bc3Gc9zRR0CU+JCDLzeZZCZEXjwamJRiWyKt2rzvwHJUo4GzPn1xB1Esuju
         SXp60XRLChJxlEmi/7vgPha3GnwSGiXHmrKNza4zPB/fPl4r1Rs7ULQ+MSl99ID1saCL
         Ys1I165II2mEa/N9JG+xiM6CDAOJQ5Evr1RhfFD/fDRmrVX7wUrAbJxEaNOr2NZiMnlM
         65Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yIDDxq5moGpDeArfNpM/54jwiqwmK/kaH7+R0E9/Sq8=;
        b=JvitGcD+QPZ19RriDcef4fX/VPGdUUu40DgdVyOD1n2KbaDjwgOgHu59ZhJZQskjgw
         gFjHNZZSW8tqSv/XyezEXv7JqTTAde59B2+g0qEGkV7ghTH59lRZ75O6ID52tyZgF1i4
         1a+nkhg2RTQMr95Ggzra7sx2bmOkEJKxcUSI+jUE66ju7guuknYl8gt2a0tLKl2IhVao
         NxdEMQGw76SMwLlDMME6ymSZPfNCZX5cVJCWJPn8X7tfbn0K76gXrZ5RDbiE52m6PY4h
         vQ6PEB5krM5dE1i+mVpaSk/UJwfcWwIi236XSAkaw+MqstAFsy7C50BDOoqbn2m4ldXE
         lB+A==
X-Gm-Message-State: AOAM530s2Eqg5T783NVkXitHFrRALsmn8CE5kgjD76NPuMwh9V2qlFwb
        Eac1D9flTjhNyg3IHZJIXqU9Ac9QAG5SrkCBvQPbHQ==
X-Google-Smtp-Source: ABdhPJxDtKG/yZ2AqOdhmuZxb1CtNEbOu/hCPhr++f0lKHDJC8VuTLbMWq4VZrFqOI3MjENPk9AICPrrxEgKH4W2vJo=
X-Received: by 2002:a2e:3307:: with SMTP id d7mr2367208ljc.256.1627666374636;
 Fri, 30 Jul 2021 10:32:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210706180350.2838127-1-jingzhangos@google.com>
 <20210706180350.2838127-3-jingzhangos@google.com> <YOY5QndV0O3giRJ2@google.com>
 <40bb3dd8-346e-81ee-8ec1-b41a46a8cbdf@redhat.com>
In-Reply-To: <40bb3dd8-346e-81ee-8ec1-b41a46a8cbdf@redhat.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Fri, 30 Jul 2021 10:32:43 -0700
Message-ID: <CAAdAUtj-e=bvZ07iH7r7eqg4Fy-KaPPgQiMHHVOh8EL4GfUJqA@mail.gmail.com>
Subject: Re: [PATCH v1 2/4] KVM: stats: Update doc for histogram statistics
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Matlack <dmatlack@google.com>, KVM <kvm@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 28, 2021 at 5:42 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 08/07/21 01:31, David Matlack wrote:
> >> +
> >> +8.35 KVM_CAP_STATS_BINARY_FD
> >> +----------------------------
> >> +
> >> +:Architectures: all
> >> +
> >> +This capability indicates the feature that userspace can get a file descriptor
> >> +for every VM and VCPU to read statistics data in binary format.
> > This should probably be in a separate patch with a Fixes tag.
>
> Generally this chapter (which is probably incomplete, though) only
> includes capabilities for which KVM_CHECK_EXTENSION can return a value
> other than 0 or 1.  So there is no need to include KVM_CAP_STATS_BINARY_FD.
Got it. Will drop this change.
>
> Paolo
>
Thanks,
Jing
