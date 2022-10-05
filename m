Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19AD75F5D2D
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 01:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbiJEXSc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 19:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiJEXSb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 19:18:31 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28C085A8E
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 16:18:30 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id q9so282511pgq.8
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 16:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Usj5iN5cemtFO03tRyeDJUMi4SFYYsF6bTitkecHHS8=;
        b=j3zs3KAEaPWgtX6tZgalJEuiwLIyUl87wkB3ggQ3onOc9jQvcWUCy4UsyHhAViS9Po
         RoUcQ27y39xLtVVRejuRGOGet6FgwPRsqMmW1ujK6WYDP9WuAnea1Kly4gTI8z493GKT
         spDHRGsm8FoJ9VFL5Aoaq7mpUvj1mCiB7WebTELx6wh80KBUoCbKeQkLsIRxZ8+xhlou
         vgbGEURTtLkw8uf1YQUbrfZlv5x6H4k40UrAU4QTMhZsMTJOJWyIExsOWqUqEzhRdknx
         qd6DCa/ZZMNo3EwrCq6aMo6gZwIDAOGcGuwVrI56dvy2oBQgragviesJgArek5ldbPBV
         n3BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Usj5iN5cemtFO03tRyeDJUMi4SFYYsF6bTitkecHHS8=;
        b=fKsDrkz81U2P7rhDJkOHl1DE5liedeVwK0MQh+oqdLlYrynkQmDugeWnaU3OBWuF4H
         6qIjPFbyoOeORFFNhDxx9lqlXjnSM9T+09dQYKZX/ap8jM9mLK5ChB/LuxwgaZA7Nbyb
         Xyu3sycER3fxNaKbUpV5JaB7l+D+BBnRp7YrPE8ML+zorRcG6rSbN2GU/QziJ4UVOC6N
         ZXU6U8JqKnIND1roM5kl/QSC73jI6a47CxNesTIXP+2FE3NosqFGSkLWDztNz+Nz1bzj
         XOOMyk31l/W6DG/5RwlVJOp6Z9Q32BqLk611wQuMFAdrTQO/AUZqXTyFOkzcQStSlhWb
         q/Xg==
X-Gm-Message-State: ACrzQf0Ad2CX2QbgQNOfp0x9g/w0hB/5pivWCb/weLf5qgmWiTsqcdll
        gwMx2p83RhZPkM/BArzpPLrt8yqV+XRxJQ==
X-Google-Smtp-Source: AMsMyM7A7KvY6St4CE7qxKnv2asB2yszh7h9VQYoEoOkepexJamGw32aJRuayc+2elmBxqeTW1DCcg==
X-Received: by 2002:a63:5244:0:b0:434:a3b1:bbe8 with SMTP id s4-20020a635244000000b00434a3b1bbe8mr1880685pgl.57.1665011909956;
        Wed, 05 Oct 2022 16:18:29 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id q19-20020a17090a2e1300b001fb1de10a4dsm262295pjd.33.2022.10.05.16.18.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 16:18:29 -0700 (PDT)
Date:   Wed, 5 Oct 2022 23:18:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Miaohe Lin <linmiaohe@huawei.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: fix some comment typos
Message-ID: <Yz4QwcnhNTRAl68A@google.com>
References: <20220913091725.35953-1-linmiaohe@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220913091725.35953-1-linmiaohe@huawei.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 13, 2022, Miaohe Lin wrote:
> Fix some typos in comments.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
