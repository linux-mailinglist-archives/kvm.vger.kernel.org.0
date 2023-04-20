Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91A4E6EA00E
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 01:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbjDTXfZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 19:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231944AbjDTXfX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 19:35:23 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE89F2721
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 16:35:16 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-2f40b891420so1061805f8f.0
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 16:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682033715; x=1684625715;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NUhrXhh0/hcZCWZDl1Tk2c8ju/E7pQLDIHpl+CKmb0E=;
        b=z7mogAtlJCz5lRBGK5WeqsgYonoKTQLIKI8OQw7l6SdimjW8LQSAJlWm1u+zChKKN5
         1fcooPR2ndBkEVy8Zfj9Rz1fNJunEPiV17AelmC28DrpJBm5S2uDuDuM/HuZLGWdQnp9
         ohWg+eARB6XRg4MBVIpLFiFu0iKfXrlWcYHhSjSTluVaprlO8vNsrf+aZocoFRiTOWyK
         fc5z6lhp9GPzE86BDEGiPCU+xhtikVNnIcNtamkSWQl80LqGAoY0tt3bGYueEUvV968m
         UJhGuixJitGF3NZVKUf4k2udB9lau1Eb5xdZhxLKe119FdTYZjFj2Nujl6wkPfRLYodq
         E8mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682033715; x=1684625715;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NUhrXhh0/hcZCWZDl1Tk2c8ju/E7pQLDIHpl+CKmb0E=;
        b=T9r2F7EpIbDPqHzIQAVoXny5fmnObd7uWTaDRk5aPqooFjHrwz3G8CioG2tfXsPxLr
         q1vl3n43Vh7lnWH27mhVhk7gw3EdsSly9g9SPsuONJJZi+MepXt/9Sm01WVmTtF+Xqvf
         wVcb6UKMQhvRQYtpdDUo/GkngwHwGIob3XdHUm9u7oQ1yAoltlAEreuCvTCFvTjuPc2r
         wcPtnlr0BZYsmvQHsdlWHDs9O2hEZYyBSA5Tw6ar6l4pCdqc6P0T1xGS5tLHFR9VFlxp
         t84casIn5pFwBpbLjrr2S1cQvRxUlQqM8vxM+GLkgZNDDCBwbob9OaRv8o1TqiznrlFh
         fGKA==
X-Gm-Message-State: AAQBX9dkHJWaJrsMnDuy8nHYcG26QEfbhZGT/T7BK7+TsiZjUSKZ+EWf
        i92R2iSwSjwfuvnlcObPQaSLc2yIYDdvmR3o4Bb7Fw==
X-Google-Smtp-Source: AKy350bMxv6ZYG/ggLLo0tXGFwNpSPRozJLJLdxCCH5WW00BgzPcFY7p2lb1Y1GF1e11fkY+l7gMXZ8ogyL0lg/eNUg=
X-Received: by 2002:a5d:58f5:0:b0:2f9:896a:7554 with SMTP id
 f21-20020a5d58f5000000b002f9896a7554mr2496862wrd.13.1682033715155; Thu, 20
 Apr 2023 16:35:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <20230412213510.1220557-10-amoorthy@google.com>
 <ZEGmWrnqI3SBUW7A@x1n>
In-Reply-To: <ZEGmWrnqI3SBUW7A@x1n>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Thu, 20 Apr 2023 16:34:39 -0700
Message-ID: <CAF7b7mq-9yOqCRsJ96dm7NMFMLOYw=Q=Q5gMWukpde9ZqQCAEA@mail.gmail.com>
Subject: Re: [PATCH v3 09/22] KVM: Annotate -EFAULTs from kvm_vcpu_map()
To:     Peter Xu <peterx@redhat.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev,
        seanjc@google.com, jthoughton@google.com, bgardon@google.com,
        dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com,
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

On Thu, Apr 20, 2023 at 1:53=E2=80=AFPM Peter Xu <peterx@redhat.com> wrote:
>
> Totally not familiar with nested, just a pure question on whether all the
> kvm_vcpu_map() callers will be prepared to receive this -EFAULT yet?

The return values of this function aren't being changed: I'm just
setting some extra state in the kvm_run_struct in the case where this
function already returns -EFAULT.
