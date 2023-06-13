Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 404D972EA2F
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 19:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbjFMRpn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 13:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjFMRpm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 13:45:42 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B74FA6
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 10:45:41 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-564fb1018bcso92202007b3.0
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 10:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686678340; x=1689270340;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ADMJ0sndnPT3yOiCL+HFQO118eU5+oZr+ELkoI41Z1U=;
        b=YjnM75c2eV9NHMlfq4l5TYfoHOUup0/n02C7O6mVdAXFCdhvRQMZVBUqm1hReLvPU4
         6ZnGHDHE7P9CFQt4P+vv/C99S8qGwFMcfg+WoUPQCQuzYy2vEuGmFiT5zKG/JsPkkDze
         ky8FmC/PKElT6xMoE5zgA8vdRywfpOUFjpGZNET7k4VpILR8kRVxGIWPONWIth/duHKN
         i3ulQj25lbBSgIDJ0k2aB8zkmvC5UeWbGIq3Tc8/ZLgb8bPrRt4kKejpeyD/QrTZHEnW
         KAvLI49/4kHLA4F17fZAvLtzU2tO1I3P4971r/Jn6v3spvMUCtld3LvgLLd0iIhV/P1v
         yIMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686678340; x=1689270340;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ADMJ0sndnPT3yOiCL+HFQO118eU5+oZr+ELkoI41Z1U=;
        b=PbMV9nyu34oRdKwySldDhSrG2IHxmTaTMPjYwX+MM4kTG2Pu4xjYpTgUfGyTVYiNFX
         XVqg631v6WFp60i9Yht7UYCYcpG2Tvqz9s6xPZO1K0nmiMd5QSdkfGWfY977Z48GD1Jp
         2cbhD42z152AZp6qbHONR0ggV7YQ8iYVe8EaR4sdUHSdIw7lh6VJQqbkuubLzK6MIe9q
         1eCAF0ChukxOEn/Kz3iOZ+EsylOzQ9rEt/NNca4cbQ//VyMQl1mPe4VkGhtP4mgMDVXg
         p5mqvVCC3fdyAxKfGbk4CvddbhNOHmZcGnjLS2p4nLuN6pFK+UU8uuNQOK1/W+hDJWby
         l41w==
X-Gm-Message-State: AC+VfDzeJo8Pz7Iepe8DV05C8DnGaAABfmY5rE1wXaDeHDaCzbaGS6nY
        120kO46wXg+Ln2topFP4dbaDQ76BVwA=
X-Google-Smtp-Source: ACHHUZ6XDcDlRp7VwHQs1Taec1H+4aU7gyQknIQlu8hYPtu9tYXOjZODacx+Mg8HR0CwekLbXaA3CPYe2q4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b710:0:b0:565:a33a:a49f with SMTP id
 v16-20020a81b710000000b00565a33aa49fmr1174503ywh.6.1686678340654; Tue, 13 Jun
 2023 10:45:40 -0700 (PDT)
Date:   Tue, 13 Jun 2023 10:45:38 -0700
In-Reply-To: <bbc0b864-8a5f-50dd-40a2-14a8ae18af3b@quicinc.com>
Mime-Version: 1.0
References: <20230312180048.1778187-1-jason.cj.chen@intel.com>
 <ZA9QZcADubkx/3Ev@google.com> <ZBCeH5JB14Gl3wOM@jiechen-ubuntu-dev>
 <ZBCC3qEPHGWnx2JO@google.com> <ZB17s69rC9ioomF7@google.com>
 <883b7419-b8ac-f16a-e102-d3408c29bbff@semihalf.com> <bbc0b864-8a5f-50dd-40a2-14a8ae18af3b@quicinc.com>
Message-ID: <ZIirQj0IOKRa/E2+@google.com>
Subject: Re: [RFC PATCH part-1 0/5] pKVM on Intel Platform Introduction
From:   Sean Christopherson <seanjc@google.com>
To:     Trilok Soni <quic_tsoni@quicinc.com>
Cc:     Dmytro Maluka <dmy@semihalf.com>, Keir Fraser <keirf@google.com>,
        Jason Chen CJ <jason.cj.chen@intel.com>, kvm@vger.kernel.org,
        android-kvm@google.com, Dmitry Torokhov <dtor@chromium.org>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 09, 2023, Trilok Soni wrote:
> Do we have the recording of the PUCK meeting?

Link below.  You should have access, though any non-Googlers lurking will likely
need to request access (which I'll grant, I just can't make the folder shared with
literally everyone due to the configuration of our corp accounts).

https://drive.google.com/file/d/1JZ6e8ZgR2gUfB4uBYxsJUxp1KVL5YEA_/view?usp=drive_link&resourcekey=0-MGjMLec-8JEIFC3-vmZeLg
