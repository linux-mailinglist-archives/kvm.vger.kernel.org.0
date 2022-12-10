Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1400E648FD9
	for <lists+kvm@lfdr.de>; Sat, 10 Dec 2022 17:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbiLJQ6B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Dec 2022 11:58:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiLJQ57 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Dec 2022 11:57:59 -0500
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629B56592
        for <kvm@vger.kernel.org>; Sat, 10 Dec 2022 08:57:57 -0800 (PST)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-3b5d9050e48so91558787b3.2
        for <kvm@vger.kernel.org>; Sat, 10 Dec 2022 08:57:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=u0nAkLHKV0vpo/DjFQeWuCjnIFWvWxAPsVOMOIFtGSk=;
        b=N/YuNhCKlrbachtomiLXy24YBN/H6neRhw4cwQXT8dL0WgGlwB3i8pc64bRVB0Pn3N
         wQxW3Bc72d4+iszA8RReFGm+MiB5hdjdoIqJs9bE7h4aS39s/cc7IwHklW6sQSFRZh0r
         Kpuxhyz8zPCAkFtPQjQrFhaHWTKMiA3jPKci0IN973Z9Wh5NIaDcCelz8vzp6v2z3VfG
         lxe/qEWaM473REetwgWR7bGCFDtNfB/MIS9fe6ACb1Z5C8dd8VlWe88sxMBbTLYtxXkH
         zHJX9Zt8tF53XSx2IeHf0uzXh1IAMV6+1J8uIW3XCHG0Ux1Us+mVUKiTMpVrG56ftrqG
         AN4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u0nAkLHKV0vpo/DjFQeWuCjnIFWvWxAPsVOMOIFtGSk=;
        b=sit8ePCQoLODfWTAADpCilfGsYe2o9QjYQ/wXyN3Ztm0lq6hJBiLOZe38o/zhjODFx
         q7HBWMYMTSued8DMMYKMUgHLAjBnu7D9c1mg80e6GoG9wYb3QkXLdPLXhEx4Swib8UKT
         c1pgnt66RpH+Nh/rprPqOEVFthiTu52Sry78bkac9KVVwZJdWpIOftlzTA+m4F6tiwRD
         0kpA8GKBkvOkQSkvm97FbmlxwU7+4WlKyBf4qYTuQ50joufUNHvrPnNuX/AesY56lTWG
         67Y+MhkGMORQCRZw1ctKr/eF3VIBcMVSSKgUZLPnu7BpjPMp3t5IRjCGo1chHT2lF2Bn
         KjVw==
X-Gm-Message-State: ANoB5pkT7cu1md3Mc3WTE5qDZXG3pzI/MrZuJXXT0DY/irX8MnAznJ+E
        TMJLUgrlJbMoKVPGndqnwkDkMvyUGspHClM7crzP6g==
X-Google-Smtp-Source: AA0mqf4tOd40aLLxRbmUXdMSoQbY/EaeotDpeaV8ESmuINdzRMBUeoJFodD0+L2vQuaHQGEsLB1BUNoHV92FUt3m6rQ=
X-Received: by 2002:a0d:f101:0:b0:3ef:23fb:124b with SMTP id
 a1-20020a0df101000000b003ef23fb124bmr16630287ywf.111.1670691476514; Sat, 10
 Dec 2022 08:57:56 -0800 (PST)
MIME-Version: 1.0
References: <20221205191430.2455108-1-vipinsh@google.com> <20221205191430.2455108-14-vipinsh@google.com>
 <Y5OxMBSlzjv3w9YW@google.com> <Y5PjUwTU2KGo5xq3@google.com>
In-Reply-To: <Y5PjUwTU2KGo5xq3@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Sat, 10 Dec 2022 08:57:30 -0800
Message-ID: <CALzav=f0+Tc3=adUm5vwyw8g3872vDW28x7+c53aeu4c0-JCyg@mail.gmail.com>
Subject: Re: [Patch v3 13/13] KVM: selftests: Test Hyper-V extended hypercall
 exit to userspace
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vipin Sharma <vipinsh@google.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Fri, Dec 9, 2022 at 5:39 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Dec 09, 2022, David Matlack wrote:
> > On Mon, Dec 05, 2022 at 11:14:30AM -0800, Vipin Sharma wrote:
> > > Hyper-V extended hypercalls by default exit to userspace. Verify
> > > userspace gets the call, update the result and then verify in guest
> > > correct result is received.
> > >
> > > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
>
> Reviewed-by: perhaps?

Oops, yes.

Reviewed-by: David Matlack <dmatlack@google.com>
