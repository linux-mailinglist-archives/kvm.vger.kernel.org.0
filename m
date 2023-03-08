Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41CCB6B1271
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 20:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjCHTv3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 14:51:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCHTv0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 14:51:26 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8BA393E2D
        for <kvm@vger.kernel.org>; Wed,  8 Mar 2023 11:51:25 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id h1-20020a62de01000000b005d943b97706so9284990pfg.0
        for <kvm@vger.kernel.org>; Wed, 08 Mar 2023 11:51:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678305085;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BqRdGV496wguSjSBGNt8xtvrGLxfsCYn5R1NqvnxW3M=;
        b=Av+obHS+/kmmkCKfGCw/rTZ/wndwL0zv9a1F2o/tINx1eC4Qaj8+9hNADGji3MlZYj
         KtKVV1CeMHfkZWasVcHSAsSGJHjEQTEu8FhbCbrs06fRRo1r9lh7pLPrsBxUbXKC2TVJ
         xAuHgf2sun79JijAKVKfwmkQrGVmfPgLE7tu9XFwPLmn9QDKKn8VgvzTSz+gqNUGI3sC
         Se2Po5soEynhgJr+iqlexE/2wXrQxvabH5mLgEmVhmfABiBQ3u5vAIwFlqvmd7dR3mh8
         9urw84RBuN/wpT8P20Rd1THMfjy/FxwsFX1nQ55zqZpkM1Kic+3+7xnuCL8Qq51vU59y
         KH7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678305085;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BqRdGV496wguSjSBGNt8xtvrGLxfsCYn5R1NqvnxW3M=;
        b=x8TTaQXC1Sw70gEdhjqe/PLyI9mDqBb1LTr4a5SJtFFCuavB8KrTDLyUp+BIyL1CXH
         Z13V9zp/KLjupeJbF0GDXjt1FFm74Cgb56Un4+f/KbUqNxfh9C3HexB4TJg5rOwSzv1g
         rqAHmSdxRJylQRoMhBpkofeNv83fA4CrrvJANUF1Nxou9DLlcM5/68/GgrgdAAQlplrr
         L9U82U8rOEYBhPLzfsgoFRkAn1Sf6esqzyV0gX3GmhmSe9eHaWXKujFVhEJcLvsk91UV
         eHeYv/DQyPxQ8xapH50DifxZcLd9GET8GlxqD60TcAdaQ3H7N7PHO+ZLTdWIAOJr0ySZ
         Iorw==
X-Gm-Message-State: AO0yUKX6FwO0hYEU3+xW4fQAB/AvmtooxFkhH/VwsUXXio5XPR9ok1R3
        VnSP2MKq5QU+Qia0thhcKYdE3Nid49E=
X-Google-Smtp-Source: AK7set+zXM2A/3jQ6mFWU40wgUXEVVXmwsnbkwyiVs3Z4LqZxA+s3gLC/gCi3VwThQP8OXkTwB8b7Cn7Kmk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:e113:0:b0:4f0:2691:a0ee with SMTP id
 z19-20020a63e113000000b004f02691a0eemr7816685pgh.0.1678305085161; Wed, 08 Mar
 2023 11:51:25 -0800 (PST)
Date:   Wed, 8 Mar 2023 11:51:23 -0800
In-Reply-To: <20230308104707.27284-1-likexu@tencent.com>
Mime-Version: 1.0
References: <20230308104707.27284-1-likexu@tencent.com>
Message-ID: <ZAjnO7NeGIYuCgMv@google.com>
Subject: Re: [PATCH] KVM: x86/pmu/misc: Fix a typo on kvm_pmu_request_counter_reprogam()
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 08, 2023, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> The typo first appeared in the comments [*], then smoothly escaped the
> eyes of the developer and survived multiple iterations. Now we had to
> regretfully append a minor follow-up fix, which pollutes our Git history.

This does not belong in the changelog.  Instead of writing an editorial, please
provide a Fixes: tag, which is much more useful.

> [*] Yw5N+eGfOsCgtHpw@google.com

Not a valid link.
