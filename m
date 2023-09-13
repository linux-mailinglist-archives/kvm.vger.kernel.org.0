Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD5D79EB80
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 16:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241472AbjIMOrV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 10:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241397AbjIMOrU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 10:47:20 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D0F98
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 07:47:16 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-68fe3d77ed8so2546630b3a.2
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 07:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694616436; x=1695221236; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aMCw5TG7E2QUMrbjxkEI8JkXPsdAS9lS/ivoHC9sTRs=;
        b=HYNX4JEr5yHH8m2Ge2M++apUrY5Ny341YR3SNs8t9EvtK0OIV1UY3RjOmaQNike3xf
         DGjbtmEUu6EVKf3byo/dq8g3KC5dMCFyXyHROr+lWYSLCg7k5uVF8WK3k6ebRkvQ/CW7
         jz/IY+2Y5VdAKFMSCqezEj6852NcPkYO7kNZk5c8UExHSnRblFJXId1WBfKgNkMMUBZx
         K3gw+8FSDwrNVvTUCTIQfiNGIgkgtaUvXxQb4oybr1mL7PArYNf0lTPMXc+TQbceAny7
         gxaGoXwiLSk6xPVHh3hssQ88SepGXr2aQslMB8vEUoVAuDBM5RDjba/RBt9OlTRBlGMI
         3dZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694616436; x=1695221236;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aMCw5TG7E2QUMrbjxkEI8JkXPsdAS9lS/ivoHC9sTRs=;
        b=cyneZJe6arQADeekRItruM8fCKrqrOzla9mksPI9jyZH8nDy7LO/wfjp/GHietWBpJ
         XTsUuKt1OlMpbx4W0HmHdAcBQFImkjkWSMKQKH3DXMALftQeMuh1cqXaqCZcUV+NFq1t
         nwBNux8vzVLWOuFeuk5tv/AzKG9i5620iKZjT8q81PYt4pjt3PJW1jW69m2S0kZzc8tR
         YV3ns/tis3lBNyH3DezCGi2jzopH2RI0WzdCxJ9S1rxRwYKoTby5S5nR9UESMwDeBFUj
         kbDC5ChcgZdG/4rRXRPxvMUHOov5Ix00jNKw6//k+dSfv+ARtEHQjMYuBFY9jg6Gr6t5
         EO6w==
X-Gm-Message-State: AOJu0Yykea+LqpZPMZvyMpMxyy9x//BB1FMBcFRB/BfQc1jEvxhWAzn+
        ihMVG8hwQUslYfCwhzUWUup5QAT7Tt0=
X-Google-Smtp-Source: AGHT+IFChbN8HMdA2gZsaodcSrytXbT4AwgAFpfF1saADVj4sQEbxn667GNHOFWcQttO8Sn32+P4Mz8Dp1Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1487:b0:68f:fa41:4e94 with SMTP id
 v7-20020a056a00148700b0068ffa414e94mr201334pfu.0.1694616435711; Wed, 13 Sep
 2023 07:47:15 -0700 (PDT)
Date:   Wed, 13 Sep 2023 07:47:14 -0700
In-Reply-To: <2eaf612b-1ce3-0dfe-5d2e-2cf29bba7641@gmail.com>
Mime-Version: 1.0
References: <20230913103729.51194-1-likexu@tencent.com> <5367c45df8e4730564ed7a55ed441a6a2d6ab0f9.camel@infradead.org>
 <2eaf612b-1ce3-0dfe-5d2e-2cf29bba7641@gmail.com>
Message-ID: <ZQHLcs3VGyLUb6wW@google.com>
Subject: Re: [PATCH v6] KVM: x86/tsc: Don't sync user-written TSC against
 startup values
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 13, 2023, Like Xu wrote:
> I'll wait for a cooling off period to see if the maintainers need me to post v7.

You should have waiting to post v5, let alone v6.  Resurrecting a thread after a
month and not waiting even 7 hours for others to respond is extremely frustrating.
