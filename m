Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 493B86C2A42
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 07:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbjCUGOc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 02:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjCUGOa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 02:14:30 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1AE185
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 23:14:29 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id k2so14992346pll.8
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 23:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679379269;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Hv33fIuyzWrpPNOhwXyMnK2Osr5j5jrVm6wuMJwEGo=;
        b=jcLtPjox8yaJKvcik6ldfPraHUAFu0NRxgtNszsuTrcnUnhZU4oG+hKwiJdhpQfktE
         olxzuQb4UNZlDg5L4truU8y24PypOUAsdXbXCWkQMZc8uC+n0Iweh2f+/i0Jt4GCewBg
         85+Lo4FhBzRK0MYTex/PdwZIRDCF1llW4z7IE4JcJgCiBEz5uNPo45WlodfdGzvuSZVB
         gaQypJmfW0R5Xt9bq/UNYZVjFwtrgVlNiHpc2sCbq0lFZYEsA1224E0C8z/+1YFP5vV6
         qhVCT68sV1kOEUXqntJL2n+6lUfYI0e1pmcEUczRrXJGYbXXZMpWl7rqZM2WZ+Q7z69S
         MslQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679379269;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1Hv33fIuyzWrpPNOhwXyMnK2Osr5j5jrVm6wuMJwEGo=;
        b=qqnkKus3nE/WQ/7eZfnAOv74asXht1lrwJN2etPDhzA+TR7qCXYhnjvKTUg7yuGZQK
         XUBKZ4y6voSvJCwt1L56Rja5GbdNJ0ME4UlCfZKuA5jeMSnuXVz2BWTgxuwa8hVWRJTn
         hKpkV/CqeP0B01VS0Bp0aJNRIVEHYJRcXDMIMpXLeLr/0Cq96RkU2FkbWHB8NlEPTzdr
         j22fok95xipMim24Tfd1voO201qRlurHDh31DqYZrQwgVb7Jqu6smnGhINbIR3VLblq6
         /5/43M28IZ5j8puLYAPzvooSPyPunW4k7/eCMUrdOkyED9mBl8+kQ8OEmg6l/AfdyjFR
         X9VQ==
X-Gm-Message-State: AO0yUKUGKUS2awhWUc9z/DyzXkTHbXL+JfCCRVQxXfE6bSZQTqLnW+Df
        A1ya+PJ8Zr7H0icBRx94ShpbGHkd4sI=
X-Google-Smtp-Source: AK7set+IGQr/Gyi3tCMdxzG5V3SGiniaHiXhH64UIDad+ZC4DjuZeAWIh0gUu6vatmMI8uZM6qeB0w==
X-Received: by 2002:a17:903:246:b0:19c:be0c:738 with SMTP id j6-20020a170903024600b0019cbe0c0738mr1265226plh.59.1679379269274;
        Mon, 20 Mar 2023 23:14:29 -0700 (PDT)
Received: from localhost (121-44-69-75.tpgi.com.au. [121.44.69.75])
        by smtp.gmail.com with ESMTPSA id u19-20020a170902a61300b001a1dc2be791sm1746933plq.259.2023.03.20.23.14.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 23:14:28 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 21 Mar 2023 16:14:24 +1000
Message-Id: <CRBU9JHY52KF.1RQWXLU6SPDIR@bobo>
Cc:     <linuxppc-dev@lists.ozlabs.org>,
        "Laurent Vivier" <lvivier@redhat.com>,
        "Thomas Huth" <thuth@redhat.com>
Subject: Re: [kvm-unit-tests v2 00/10] powerpc: updates, P10, PNV support
From:   "Nicholas Piggin" <npiggin@gmail.com>
To:     "Nicholas Piggin" <npiggin@gmail.com>, <kvm@vger.kernel.org>
X-Mailer: aerc 0.13.0
References: <20230320070339.915172-1-npiggin@gmail.com>
In-Reply-To: <20230320070339.915172-1-npiggin@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon Mar 20, 2023 at 5:03 PM AEST, Nicholas Piggin wrote:
> Since v1 series, I fixed the sleep API and implementation in patch 2
> as noted by Thomas. Added usleep and msleep variants to match [um]delay
> we already have.
>
> Also some minor tidy ups and fixes mainly with reporting format in the
> sprs test rework.
>
> And added PowerNV support to the harness with the 3 new patches at the
> end because it didn't turn out to be too hard. We could parse the dt to
> get a console UART directly for a really minimal firmware, but it is
> better for us to have a test harness like this that can also be used for
> skiboot testing.

I'll send out one more series, I have a couple of fixes for PowerNV code
(I didn't make the OPAL call to set interrupts little endian for LE
builds, for one). I'll wait for a week or so for more feedback though.

Thanks,
Nick
