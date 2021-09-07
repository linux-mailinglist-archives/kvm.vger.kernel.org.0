Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADEB402AEF
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 16:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245118AbhIGOkf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 10:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232105AbhIGOkb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Sep 2021 10:40:31 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84469C061575
        for <kvm@vger.kernel.org>; Tue,  7 Sep 2021 07:39:25 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id s10so19932480lfr.11
        for <kvm@vger.kernel.org>; Tue, 07 Sep 2021 07:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x6okiQWF8AWFwYz1Cx6jMTOqJOfQYTektKqGR290ROg=;
        b=V2qEkRgiMmtEYTFLxX6J+B9SOiG5pqyIEk6sT9arTMp/i8bI0688TfDreT7NZMcLKi
         L9Pnx1OXuIi+1cpOVc7i09msj9YvfeKnBTBjqTRqYFA48qZ4gscqoBQidGUlEMBOO6f8
         iMFQkB8sPVF2+bpefC4VYQf31ojrDtyWi4TknWwpJDRd0g1N6A3VLt9YrTXcKTRacyhp
         7OtzpSCO6xBruPi96UCYckSWqfMAVNeNVabDnbl+ot9T0ExTMvb7UoKhazKaeKnenGML
         qJwu4Rylbzt0rFgXd8xURIzCzAsuZNeLpeRn0mMBr+deeD6st1CD5muzrNq04SHUE5Fg
         yzlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x6okiQWF8AWFwYz1Cx6jMTOqJOfQYTektKqGR290ROg=;
        b=YptVcY7IeAIUYPCyUhXB5mhFKauv5608hU4YzKd5sguCtAVUBTx9rfEXKcFqtiU0id
         nI3ftKCIFebQOqHTTSGv25mS/rUkH3+KrV2ABYAd6r9NgPqEFshKAo2ciir92K8nhCZS
         qk4+da3rNhP4cSQKCcafiQmT7R/tvQkvwNVEb0OsiSZswhJUlqoN2dXwmwlEUeH90Oak
         WxA5PNAz82GyU2DRp02iAECuXa+IRJ6jFXIxIE5hxqgZ4LMTvzVSLC7/wLCs2ncpS+dG
         N92ibcGyL4LV8+TN3cKRqEbaNCXrhD6PetxHMUGA0THs4PRMZE/zqZsknzlJqWTrj+Pd
         AZmw==
X-Gm-Message-State: AOAM5325ASPIvOSnvxofUlDnmaTscSC2PC2SPudfDbE4jrMYAKDjVE7Z
        C3Xx9mn63p0xLNlTB4g7m6z4a0YmqVoAraYaU6O7yQ==
X-Google-Smtp-Source: ABdhPJzVua1emB5yUEIXuBSevHAq/VVvrfNQXiKWKkwtCPQFHxdZHjnKt3AtlFnJ/ycmAv2naidJ2mOsUgS8wJ8aCaI=
X-Received: by 2002:ac2:51a2:: with SMTP id f2mr13195347lfk.685.1631025563601;
 Tue, 07 Sep 2021 07:39:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210903231154.25091-1-ricarkol@google.com> <20210903231154.25091-3-ricarkol@google.com>
In-Reply-To: <20210903231154.25091-3-ricarkol@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Tue, 7 Sep 2021 09:39:12 -0500
Message-ID: <CAOQ_QshLu-EiLdPDY-d1dS3qvNjJBiN=B=a-W7_70Fdt=GbOcw@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: selftests: build the memslot tests for arm64
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        maciej.szmigiero@oracle.com, maz@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ricardo,

On Fri, Sep 3, 2021 at 6:12 PM Ricardo Koller <ricarkol@google.com> wrote:
>
> Add memslot_perf_test and memslot_modification_stress_test to the list
> of aarch64 selftests.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>

There isn't anything that prevents these tests from being used for
s390x too right? Of course, we haven't anything to test on but just a
thought.

Besides Drew's comments:

Reviewed-by: Oliver Upton <oupton@google.com>
