Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 640296F354E
	for <lists+kvm@lfdr.de>; Mon,  1 May 2023 20:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbjEASBx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 May 2023 14:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbjEASBw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 May 2023 14:01:52 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8302C1701
        for <kvm@vger.kernel.org>; Mon,  1 May 2023 11:01:50 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-3f315712406so138689165e9.0
        for <kvm@vger.kernel.org>; Mon, 01 May 2023 11:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682964109; x=1685556109;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UGfxzS53bu6T6J0Ou4GBb9j+9uGsl9LMhYdI8VnO+SU=;
        b=Gsd4Zc9jxsjWdHsRoQX72VkOR4zfHqEy11VsBwLKLOUdgOTiEu7VYTmsxmZf91xIG8
         k0m9HnpuqOlOuELqweWNO4OMZdAD+cVemapLDw5yIW7fGJ6teU6QviZQBxY3+I5qD4G7
         om2Xf51JPiUXWF4yMgTaGkmFktVTNx+2us1YeJnKdHEx4Ps3tlGzATiuXRod/NII+sWh
         X/ZQqqCdGbcvlONoAXd0+e2LvRJgGfsp9EnIGtE4Xfogs399J3yasIQdpTczUfbabvoO
         ai9nWTbjhBbj7sr9Rq7Bxod/Duq/oNqUIYhuB0bGHSqIDfRbZ0V+Pr256sLwiznEmtyg
         NqIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682964109; x=1685556109;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UGfxzS53bu6T6J0Ou4GBb9j+9uGsl9LMhYdI8VnO+SU=;
        b=Ga2gsuWWTK9saNRU/NSPgGhTjbsUClO1lDF08xYuzAcgFVuZGlfAqCUOi8rZjfQLyV
         uAYIaP2F73THyLYN6dnXhlqJjL+xrogl7EwreNKhV0EnQ5JyDe568kmDPCahRIQXzEYW
         82ekS8Yw4LsOPtO+fVhD2+/aKyuYPV1+OwJzh2cAtILXzpFQHLZSsg6TWSHbLcY8zdPQ
         SvvnBwnubcoV6RpyjV8qLZk8qV7R609ripM3/Lhy9IRx8Qtg1PUTQVt7B2xRlZhvxnes
         02AgSPj9GNeY9YQJM7qZtE3SigYXhsVF+Z1U68y+h0wApyQwWNNrnHGu56F4rCEeQsID
         x41A==
X-Gm-Message-State: AC+VfDwDsThfrsgNiZku6m0oCZUFlVstEoxtE5Ks0W+1aEHhDmLSn85e
        y3Qw4DqoyjiCsy541Yl656CyM3HP5mP900UrOzsRmg==
X-Google-Smtp-Source: ACHHUZ56YjfJ40pnMhaesG6zsYJHPdRG1M1bkCZUAJldIumQNV8sWiZgRgRxBg+cUG2vuRpjRz7PxoEwW0S7hz2I+HY=
X-Received: by 2002:a05:600c:1d8b:b0:3f1:7619:f0f6 with SMTP id
 p11-20020a05600c1d8b00b003f17619f0f6mr13746634wms.9.1682964108932; Mon, 01
 May 2023 11:01:48 -0700 (PDT)
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <20230412213510.1220557-23-amoorthy@google.com>
 <CADrL8HUQWFtY+2XgT0f6fBhWrdTCvQ1n-99k9oV_5UiFnamv9Q@mail.gmail.com>
In-Reply-To: <CADrL8HUQWFtY+2XgT0f6fBhWrdTCvQ1n-99k9oV_5UiFnamv9Q@mail.gmail.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Mon, 1 May 2023 11:01:12 -0700
Message-ID: <CAF7b7mqVPqGFkBvB2w3VahX0TFTxhnQGcXPQ04ANkO5fWO3Adg@mail.gmail.com>
Subject: Re: [PATCH v3 22/22] KVM: selftests: Handle memory fault exits in demand_paging_test
To:     James Houghton <jthoughton@google.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev,
        seanjc@google.com, bgardon@google.com, dmatlack@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Thu, Apr 27, 2023 at 8:48=E2=80=AFAM James Houghton <jthoughton@google.c=
om> wrote:
>
> This comment sounds a little bit strange because we're always passing
> MODE_DONTWAKE to UFFDIO_COPY/CONTINUE.
>
> You *could* update the comment to reflect what this test is really
> doing, but I think you actually probably want the test to do what the
> comment suggests. That is, I think the code you should write should:
> 1. DONTWAKE if is_vcpu
> 2. UFFDIO_WAKE if !is_vcpu && UFFDIO_COPY/CONTINUE failed (with
> EEXIST, but we would have already crashed if it weren't).
>
> This way, we can save a syscall with almost no added complexity, and
> the existing userfaultfd tests remain basically untouched (i.e., no
> longer always need an explicit UFFDIO_WAKE).
>
> Thanks!

Good points, and taken: though in practice I suspect that every fault
read from the uffd will EEXIST and necessitate the wake anyways.
