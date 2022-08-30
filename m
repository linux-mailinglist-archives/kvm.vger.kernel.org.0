Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 403435A5AEF
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 06:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiH3Eyp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 00:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiH3Eyo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 00:54:44 -0400
Received: from mail-vk1-xa33.google.com (mail-vk1-xa33.google.com [IPv6:2607:f8b0:4864:20::a33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FAE9B1BA2
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 21:54:43 -0700 (PDT)
Received: by mail-vk1-xa33.google.com with SMTP id i67so4724328vkb.2
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 21:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=j++opkMOwoopE0QFW7zgcieguS/bf5xl04LLXSqDsLw=;
        b=YxMAxwKFKn+WVskkqgF2Clsq7TotdjQCihFfTWuVcXX7SG3Hv0T05VhCQciookwMXh
         wZ72ibOTMi7Pt0mHOk5bGlz05xo2HBYuDC/D3pxV0gCT76JLE2fl+aFwkwLMLBpPlRNT
         xRVzxbmyxp+nw9x5yLC72QhBIGsQtSr68IsgAWLpMWlQ6Jor/YlWDxAMF30OojLiPaDN
         3/j0MhhNU9x9Gd3CEA2PMQ6m2tgN6wmr/tP3x0yMPasuPGPCtIKsAZOoLQ1/LuoF6mFk
         vJe1nsYhy1Q8CPFYf6TNHRyAENST54ixWOBKhh/a7FJiefYpihNwy5BwMu01LOFOdrkQ
         DMcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=j++opkMOwoopE0QFW7zgcieguS/bf5xl04LLXSqDsLw=;
        b=MIgjWNOQ0f3rRXXz/vEF8fQPycA7/4L5o3IeBfP1TqFmDAMah00Ea9oLT0UOOdcbA8
         YV3NB9IGUPACkuQ3LzqfyAgvENkwF2ee5LORdVwK+drfx18CwPTfRHeSuW4TDpoCwOG/
         uq9p72NBZ3KDIJl1BGWnVql/pFrNbOl50c57hugCGIL0jMnCVaJQYY3Wu31NhIrNN0en
         ojE2tu60fMbmeqcTWG8BoxWQwVQWQHxs+R4mraUUnzsSFw3ocXK0jy3nL652yhYNcCg8
         H7HRXNxWpZyPWN/OyNyUOdHNEUT0gXFnd53A8NRBgtKiUq2FUHF5nTwkj1lU+lv1BNw9
         GnFA==
X-Gm-Message-State: ACgBeo0ues8CWhhfsx6w0ZSwbGx/C7PTVTh9SFtr9TPXKv6V+eOGwQlS
        Bpf9XjSZi2OTEc/V0L6Ix/pOXnNVGOgWh4QpW45bYQ==
X-Google-Smtp-Source: AA6agR4NBt2hLSUAn0G54sRGeKlPCojndb7uJeGXTx5Oh+x2e23RDCtuxkjVQ47CsH7TeYuFVXZWO4QpBbJcXOtZWaI=
X-Received: by 2002:a1f:acd2:0:b0:37b:531:9988 with SMTP id
 v201-20020a1facd2000000b0037b05319988mr4086066vke.19.1661835282107; Mon, 29
 Aug 2022 21:54:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220817214818.3243383-1-oliver.upton@linux.dev> <20220817214818.3243383-2-oliver.upton@linux.dev>
In-Reply-To: <20220817214818.3243383-2-oliver.upton@linux.dev>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 29 Aug 2022 21:54:26 -0700
Message-ID: <CAAeT=FyxeNhTaNdQryTRoiC5AjKLzD7axm1pqaxLTrSuv6imaw@mail.gmail.com>
Subject: Re: [PATCH 1/6] KVM: arm64: Use visibility hook to treat ID regs as RAZ
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Wed, Aug 17, 2022 at 2:48 PM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> The generic id reg accessors already handle RAZ registers by way of the
> visibility hook. Add a visibility hook that returns REG_RAZ
> unconditionally and throw out the RAZ specific accessors.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
