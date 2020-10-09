Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526EF288CC4
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 17:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389259AbgJIPct (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 11:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389231AbgJIPcs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Oct 2020 11:32:48 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E22C0613D2
        for <kvm@vger.kernel.org>; Fri,  9 Oct 2020 08:32:48 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id a3so13623840ejy.11
        for <kvm@vger.kernel.org>; Fri, 09 Oct 2020 08:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2vA1lwubOImADFwVCjeFGaGpOgSIrNrQT5H2Del/lPk=;
        b=g75lchhrvuDyJKmp/ywKbvm0hOaSTfgI3dMkgO52osJJZAy5cSe3G8L9cCz+8CMd+Y
         usqebuZbmuc1O1zAG22WJNxlJb//h5bpOxuN+cSFL6dLGs7T2TSMEnN2uJWZwex6k6jm
         SsnoYyMteBbJ6nteeRQ/xo20hxxVZBFvYzSrnphUt7HTlWPXgg4+T9PTJ02Jm99VNg0p
         LlvzhHE/aI0fBQS2XEBI24ZhSVm0KTwCR5vWCwQjDyLeh9o3jRW/vcjPBwLGfM2lp6I/
         QOWNpN0ySOiiDQd88vjZJEfkEC7wDwzcpRI9Te4817PqC1DmnBGdbyf1Drz6SAZfZO5g
         wgJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2vA1lwubOImADFwVCjeFGaGpOgSIrNrQT5H2Del/lPk=;
        b=GzrxEgXOP1gumQnCwwDoogU1NQffmPDfWcN1K/UKrpVHdwNyAmdqR23VcmSjb6DKiS
         uEBEucxBGCd3i7IQ6hT0Vwg7Y6bpnBgxwQWCpB3Y1c1V7xXWg8hte6wLm8HYG+dfF+iE
         bNSgY5tSNV8S9DotM1xMx7xGeyNN8nr081spSvTbo/1UDQYAG9caFfa4wWf+jkxYqAJY
         9Z9sD/icCCkDUhpFAS0Ax3ChD5i7VRGOEIZCZWeh52VYDGE+aK6CQ6O+yzzXeDsYid8Q
         A4wgSUHJY1zbwtn5eBm1cegNPDv002/ITmebS6Zb9raG9/oTD/owhDGAcUAg6yM/DIyt
         h0QQ==
X-Gm-Message-State: AOAM530p/ABs9M45rczw+gVGXn53hAmNwc/b7U8n8h8FlD0bttMCZKj4
        JJI3CsHvEHpAkc9sH+L8ECk3fRnr5YIGyoEyxtTtgg==
X-Google-Smtp-Source: ABdhPJyPZIu9JkQ+iJCuEfsXkITsx8gjTuBdFAhkm/OBiIp2W7Zv4+UUYvjOapMkYH2XDfQR1H5nTjdnSV8qftRbs2w=
X-Received: by 2002:a17:906:d159:: with SMTP id br25mr15472697ejb.155.1602257566971;
 Fri, 09 Oct 2020 08:32:46 -0700 (PDT)
MIME-Version: 1.0
References: <20201009114615.2187411-1-aaronlewis@google.com>
 <20201009114615.2187411-4-aaronlewis@google.com> <fbaf1a2d-04b2-6c19-d80f-6fc0459a8583@amazon.com>
In-Reply-To: <fbaf1a2d-04b2-6c19-d80f-6fc0459a8583@amazon.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Fri, 9 Oct 2020 08:32:35 -0700
Message-ID: <CAAAPnDFTwb3o44gxdC7ONTJLob44BLus0zEza--j0exhsys=aA@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] selftests: kvm: Add exception handling to selftests
To:     Alexander Graf <graf@amazon.com>
Cc:     Peter Shier <pshier@google.com>, Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > +#ifdef __x86_64__
> > +       assert_on_unhandled_exception(vm, vcpuid);
> > +#endif
>
> Can we avoid the #ifdef and instead just implement a stub function for
> the other archs? Then move the prototype the the function to a generic
> header of course.
>
> Alex

I considered that, I even implemented it that way at first, but when I
looked around I saw no examples of stubs in the other archs, and I saw
an example of leaving the #ifdef with a corresponding arch specific
implementation  (ie: kvm_get_cpu_address_width()).  That's why I went
with it this way.  If the stub is preferred I can change it.
