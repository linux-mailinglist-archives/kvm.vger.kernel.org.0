Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB04341E64C
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 05:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351807AbhJADw6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 23:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbhJADw5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 23:52:57 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C97E0C06176A
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 20:51:13 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id bb10so5462796plb.2
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 20:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MDJiiCfvJNK5/+V9oinRHjl1k/Y3Wr0K/+VSMV+jnd8=;
        b=NR86AkPKaehiTaJXMV/LFZjgJYQEHqqBB5nq0sO+OJ4nEEQuF0iSYeP244NpLce1BR
         u2hX4aEZf8E2x0iQWPWR8ewdENMsixmj1nuHsSEOl6GLsIZj+lzY59eoc63en+bIgOBf
         xcRMUMu7sb+WbMQArAhQepLeXgDr1gYpkWZlJ4960gFPJuOnX5gXvGn7jgD4nvSceZup
         BOo6qYLOFyprrGNeT05+G87oYllitnMcY+iqCh0PKvSr697e6lAjXIB3CO6rE1zvWVfE
         kGJlKwPfb3ponQxLaasK2FzMqXxKGeNaME01IVKMIwiHUd50zzOHrOzg4P9Z6x8DnBUZ
         u+3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MDJiiCfvJNK5/+V9oinRHjl1k/Y3Wr0K/+VSMV+jnd8=;
        b=jD/ZODL7sRB4ywmZ0zwV3apo3ca4lv/bvkt/mP3CstSx3QVOLdRjMvIQ0Rnt0BN5/s
         8HlJGWk8q7RhdP5UH/hfWNcFpsPBQvPLXl34XvzpqlhIJIXGzeRe6rYJicEHu8fvE9Y3
         Nqm7uo3DsRn4G3jQMBNv2WvRgYd5Zy5QAfOXV6+FNZDVS5Bk5asoh9yTa5YkMgz7DzbT
         7qBfWDnU/hm3Xb7KTAgVt3l9Ctbz9wTe7Wo7PcX0TT+IyGZuczKiRz5dqBBSAYKhl/ci
         h+c2JFa3BZrwKDjuDwzgzj8cJLoGkjNhzFRKwkxQFw7eAcEvKzBY4+nFo9bNx+IgmsdN
         z6Nw==
X-Gm-Message-State: AOAM532QjCv+GHsUuEyAsa09hVxK7rkNOa9mdLq+bit75ERIiqhf9Qew
        sqXTCXOY0/gJopIHQ9RPPN6ZsmesHPK/VMDoyzVpDg==
X-Google-Smtp-Source: ABdhPJy3P7Ud/pDJ7IBx1wc5kDlJRJR5BQ/sfvGyHGTxat49B6SmygHHt7Fd10MN/zUAHtaaj2BvM7wtGuLIOlpemZ4=
X-Received: by 2002:a17:90a:5d11:: with SMTP id s17mr1209502pji.230.1633060272948;
 Thu, 30 Sep 2021 20:51:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com> <20210923191610.3814698-2-oupton@google.com>
In-Reply-To: <20210923191610.3814698-2-oupton@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Thu, 30 Sep 2021 20:50:57 -0700
Message-ID: <CAAeT=FzwwHGtUz+0nn4HEZr80+Pw0TVA_Wc0iASPs8y1HK4g_A@mail.gmail.com>
Subject: Re: [PATCH v2 01/11] KVM: arm64: Drop unused vcpu param to kvm_psci_valid_affinity()
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 23, 2021 at 12:16 PM Oliver Upton <oupton@google.com> wrote:
>
> The helper function does not need a pointer to the vCPU, as it only
> consults a constant mask; drop the unused vcpu parameter.
>
> Signed-off-by: Oliver Upton <oupton@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
