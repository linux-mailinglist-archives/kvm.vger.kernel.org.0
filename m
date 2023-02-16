Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 322F56989A2
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 02:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbjBPBG5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 20:06:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBPBGz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 20:06:55 -0500
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E05E62CFCE
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 17:06:52 -0800 (PST)
Received: by mail-vs1-xe2d.google.com with SMTP id j5so345687vsc.8
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 17:06:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ws2T+EssLBYOQsEhkp61JrXbny1ZBtMs5wKOlerlIgQ=;
        b=SSHbins3d8gIJIgYaifHrjin0gx5boIoYpoHRztWw0z3g9+rZie7FqNMnWKK5zd5WM
         APtvvWsD4DkybGPuTTZrS0MoPjffz8QRiWb60ml6WvfOH3b3Vltp0yzbQyFNq+TyxWNj
         KFD373qOgiK1ZI93T0fiInpd4sL2nVF9Zm3IYxKSMsXvm/4ivMTyMnGeis6hD10goskW
         JgVVyIzsy+ycIWoevSt/kNFq4W09xxUND/I26PyczbjgeBHoTPdXYaTX6HjbS2ooIdJC
         1ovBFYOGituMqEm+ugHnyjAbOTViflCtR/VrnOkSs7YH3qvrLrvqpCwvbjgX1ZszAaZb
         XH/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ws2T+EssLBYOQsEhkp61JrXbny1ZBtMs5wKOlerlIgQ=;
        b=g+AldlZi6khBbCty51iCz+dXglYWYz976t2hjdqbgSJwcgH8B3v455ypizdNCe0ilL
         4mqMkiH577TOSnqv1hAu4A+6iVgiGmPAhUcvDJ9gjHhXSrqPPSQdxd34iIenRRN1DLFh
         6GWdkCqRcOTxMXY0eCtgptnc2kqKdpRz166GlIzkpLfP0iikVzowEwT+9zCZXYYU5j/0
         nOiQh3klR4EQk3utsplf+nb6vJ2xJ2s1ueSywgzwGYtZ7TJje9LK6Y1ug+LgeFZ2Ztwb
         uSHcmDJjwjztxSRAUj6SH2L6A5UifP5y7qg4LvNJmdA7/xnnkifBvECECM1ZUzN3gaNW
         PD5A==
X-Gm-Message-State: AO0yUKXmQrvHwYpcxDEbs2ZJAhQdi/6byNo5DiXZ7OmkGHN/h5yK9m5s
        E082LRpA6ChAPIDEJsZbtvZIUyXcoK1XSG0Y3CZoOQ==
X-Google-Smtp-Source: AK7set/O97bNUPMe0ZEVypqa74ysvqyrvyfBT1x8i0mfPaUqmb2pjQAZd1MZ5znfb1fozZDjwFBzCwV8/dRITIVLV+w=
X-Received: by 2002:a67:ebc3:0:b0:3f2:d6cc:e09e with SMTP id
 y3-20020a67ebc3000000b003f2d6cce09emr828556vso.57.1676509611981; Wed, 15 Feb
 2023 17:06:51 -0800 (PST)
MIME-Version: 1.0
References: <20230213212844.3062733-1-dmatlack@google.com> <Y+18f7go7J98XbzR@google.com>
In-Reply-To: <Y+18f7go7J98XbzR@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 15 Feb 2023 17:06:25 -0800
Message-ID: <CALzav=c06gXZme+t5tE3eFgbeKNO+hjFox=sRyU8oiC3VMB3zw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Make @tdp_mmu_allowed static
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        kernel test robot <lkp@intel.com>
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

On Wed, Feb 15, 2023 at 4:44 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Feb 13, 2023, David Matlack wrote:
> > Make @tdp_mmu_allowed static since it is only ever used within
>
> Doesn't "@" usually refer to function parameters?

Oh is that the convention? For some reason I assumed it was used when
referring to any variable.

>
> > arch/x86/kvm/mmu/mmu.c.
> >
> > Link: https://lore.kernel.org/kvm/202302072055.odjDVd5V-lkp@intel.com/
> > Reported-by: kernel test robot <lkp@intel.com>
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
>
> Fixes: 3af15ff47c4d ("KVM: x86/mmu: Change tdp_mmu to a read-only parameter")
> Reviewed-by: Sean Christopherson <seanjc@google.com>
>
> Paolo, want to grab this one directly for 6.3?
