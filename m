Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29B1153B7D7
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 13:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234240AbiFBLc0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 07:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbiFBLcZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 07:32:25 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D3020B7DE
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 04:32:23 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id m26so4964474ljb.0
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 04:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oxidecomputer.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6NrMVnhhkWK9lvKSxoiWwnnt6uTIPLWYoEs5odYNLnk=;
        b=cdVOSpd4IlnPRrSP6NNxkOOuqjjc6I6OSyU6+/EN2VByZHtDRRUfKhgm+T/vY8PCWR
         Y0w8nAqspDLc0IjumwRD2pK0paN4Lgz4snsXdTteQ0cCgvxmSLDduDD5lzmJOHfrcOis
         VNInMTQf65lRgTf99Z0yTWukQETQ9v7FfWM2bB5ToJbtQm6Z2O6pWwMymBxsQjdV5ylK
         9+rUiV/4vr9LwK8Y+juCoat1OyaGcF0bZPhW48qIHt7J98FgrbChBU/S45PiZfKk3jHQ
         HBcHEylD7j8Ipr/Jj3daHfCCux5RvMtaB8D4/lS2/O+74p4U8PRr3upys5NWoLnWCKru
         z1sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6NrMVnhhkWK9lvKSxoiWwnnt6uTIPLWYoEs5odYNLnk=;
        b=pKItnRb5oLe0l3FdCo+tgP6gLSyGw38dlFORrDvDnDw/qhFCL3wiwXptuICjBwtEND
         IF2EgrNMeYXpMCOqMpb3oh17s6LjvE398hBAo0z8r82fwIk/oxCm109+7iB+JCfRIhUP
         DeI6Wu+aNlsoKu7L9/sKisxObKeywUdPp945k5u1+IFphuFdBQE5hTES0+qWetC8AVVA
         5QwbhZvRovt7HSxlA+OgkBu/Mt99D997CTiP9KRkXvpcBkrFZtjp0O/jCr8Cizi2WwHl
         lewyzHV/D5mpPpYDdaaGhTTrmuaNhVD7rs83Nbke8tSvALBw3s7ZV+D9RMmL8WMu19JB
         +BjQ==
X-Gm-Message-State: AOAM531Cv50RQ+pnm+cS13nE0rkiCvwlL2ERcXDLYJPJufWyuKukGYAW
        IlaN588qUbOtpgC+YNN3GeUhW/nHW60pkLCbXVP+uw==
X-Google-Smtp-Source: ABdhPJw5+KrGyS6TH++a2E0YmjhMQbmcERNIXVcHsh+BCamfGfwalbimTk2PIbMsAZfArp1hniEhkUrPdBrR0U32qJQ=
X-Received: by 2002:a2e:a593:0:b0:253:e61d:b681 with SMTP id
 m19-20020a2ea593000000b00253e61db681mr34512762ljp.484.1654169542124; Thu, 02
 Jun 2022 04:32:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAA9fzEHQ49hsCMKG_=R_6R6wN8V8fDDibLJee1a1xLCcrkom-Q@mail.gmail.com>
 <20220601215749.30223-1-cross@oxidecomputer.com> <c34ea319-2493-724d-460c-490881ac34b6@redhat.com>
In-Reply-To: <c34ea319-2493-724d-460c-490881ac34b6@redhat.com>
From:   Dan Cross <cross@oxidecomputer.com>
Date:   Thu, 2 Jun 2022 07:32:11 -0400
Message-ID: <CAA9fzEGdtwvM6+9mooQVZxnNhyQHp-+dbM2QrJbscM+iVXmg1Q@mail.gmail.com>
Subject: Re: [PATCH v4 0/2] kvm-unit-tests: Build changes to support illumos.
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 2, 2022 at 6:53 AM Thomas Huth <thuth@redhat.com> wrote:
> On 01/06/2022 23.57, Dan Cross wrote:
> > We have begun using kvm-unit-tests to test Bhyve under
> > illumos.  We started by cross-compiling the tests on Linux
> > and transfering the binary artifacts to illumos machines,
> > but it proved more convenient to build them directly on
> > illumos.
> >
> > This patch series modifies the build infrastructure to allow
> > building on illumos; the changes were minimal.  I have also
> > tested these changes on Linux to ensure no regressions.
>
> Thanks, this version survived the CI, so I've applied it now.

Thank you very much!

        - Dan C.
