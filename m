Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 378ED67A9A9
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 05:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233488AbjAYEhV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 23:37:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbjAYEhU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 23:37:20 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 831AF470B6
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 20:37:18 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id d3so16789975plr.10
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 20:37:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WO4GpmDSCs0S854pshGkZUEPT69IcB0aJp3A2QbXxAU=;
        b=NjfDfL86fBgRGbkayyp567ulj0sP4RgCggm2zRbKDACmcUvv2H+INIeRgNO24RsD+E
         Oy7bsR0zPAf+n7lCT493PULnK7+VJsqU/A2rcqazWHIuEjyYFnedlbRspQWkun46yoG7
         Pn34bedMhEyXdjFKy7QRK+ysr0yptHSxsiVNXxnxUpoIHkGc32kjTAnuSDPecC8GMVqb
         lxCS+kmsoUUJvkZ2YUTlJZQ9z1i/Vjd4pirpX1T8vn4jp9RWnMqIrg04ZlX5kmfgqDJB
         yeT7HYsAbUbkEMlVDXTKLLiGFQxp3deqd5UGsjmpT6CHriDIz/IynkN7yxoq38PJi1yW
         yM2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WO4GpmDSCs0S854pshGkZUEPT69IcB0aJp3A2QbXxAU=;
        b=CA5FqOBVigyLT9exwuNllcyj1/RJAfsKy4kT8IYohrbdwxkQbjQF1ewwzbkDwnbnKi
         DYTplcR97p4RHymJZyC6Lfts0Xo0lQnA7Envl/ru4Yvhp+davVJmOltwbNJa072+j9a9
         stCWY7XR5o8Yo05Dm0fpW/qylVVd/D3Cx4qo6JR+x1S2IxkzMgJtI1n1lL7IwPH456/C
         Zu2UBtAx96IX0DlNwTfJtbMNfecJlJxNtZ463tZJCC/7PDBbi/WM0ijBmaWsshDkE+EA
         nJ1ZmFN+stq/hGzLcQCWDPS5DkLxWMnmdQfHqMVCI0sVBfyjbiSfMRD3Xp3yZVjSe5Nx
         wACw==
X-Gm-Message-State: AFqh2kp2SgIfWestC9XE+5AOVlu1DBipF8MXm2tdMhwwYKNSUeuGZbXc
        OZzn4XhiV8V0Q6Ym1SwhYU0OVUruTjnTWRVafwIogg==
X-Google-Smtp-Source: AMrXdXuar2zro7h1CyWUyGP6uMC4vWzwKdCkCenLjuKqrP+ipVK6jvRtMOJN0+ExZ20gsKOdPKsGLF+OKl81gSk5B9g=
X-Received: by 2002:a17:90a:8546:b0:227:1d0b:5379 with SMTP id
 a6-20020a17090a854600b002271d0b5379mr3368427pjw.103.1674621437753; Tue, 24
 Jan 2023 20:37:17 -0800 (PST)
MIME-Version: 1.0
References: <20230109211754.67144-1-ricarkol@google.com> <20230109211754.67144-5-ricarkol@google.com>
 <31614401-8669-1f74-aa01-bed3ad3d2cf0@redhat.com>
In-Reply-To: <31614401-8669-1f74-aa01-bed3ad3d2cf0@redhat.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 24 Jan 2023 20:37:01 -0800
Message-ID: <CAAeT=FxYxE6xvQ5Q_MAG74EN0FC2P6xg_mAg=7GPC2h2LiA8cw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v3 4/4] arm: pmu: Print counter values as hexadecimals
To:     eric.auger@redhat.com
Cc:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev, maz@kernel.org,
        alexandru.elisei@arm.com, oliver.upton@linux.dev
Content-Type: text/plain; charset="UTF-8"
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

> On 1/9/23 22:17, Ricardo Koller wrote:
> > The arm/pmu test prints the value of counters as %ld.  Most tests start
> > with counters around 0 or UINT_MAX, so having something like -16 instead of
> > 0xffff_fff0 is not very useful.
> >
> > Report counter values as hexadecimals.
> >
> > Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
