Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC54E32B6
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 14:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502089AbfJXMrp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 08:47:45 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36065 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502084AbfJXMro (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 08:47:44 -0400
Received: by mail-pl1-f195.google.com with SMTP id j11so11814484plk.3
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 05:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y4ncbMnMEtA1qAkMboIsumwXax5XKlWZu/q81F2wabk=;
        b=e9cDGPbmTXAb+YkQ5S9s/56Z3uqMXqW4gHBFBYz+bV8KTh+3a88UQhYXRpHyqfS7BQ
         PZjycwx3cT+k8sYG3mRd/HCMFByN7OaZoZMSlL2GtMemaxTqL1OD/141ilU1oAQDIQzu
         KJ8b1+Xgpgx7uzXiyKXPuHr305ouKpNkWXI4QUQqkq7rQw5SdhRKXiKyR90E+32RbAQ2
         9d3SAKAhXu5dQLF2kIUO84ixKJ6jd6PDlOYtXKMUEdlr5huB+x89yciHSBUVzv3u2+aX
         DIKfp1Al2ETSdaXfA/OXTVeO1KdXE6I8sYlnIK3l75Hp1dPLGynIRgIqGtEhlk5GhPBp
         Es5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y4ncbMnMEtA1qAkMboIsumwXax5XKlWZu/q81F2wabk=;
        b=SRmgKqftFO+Z7oToRwyo2jnISVKIPN83wC492Oknhfz5xqtb/QvHDr0JCJQTaGR49F
         XsN0z0nEqmkrecF9pBPnt/W9vRtg+cxd6ItzQN+5WxQH6XH4q185Rk9/6+Iy6aPCt/xW
         b/NTi3TnOtSKQtm8TZAHVxfrDkky/l3zZMwBfoSHQYbnPXjkRKBzPp+bgJ26L/mMCoVb
         2yLVLBRv52TK9OTrM9qigWao315Y55QK5wZTbdMHPu8Gp0gx1rtzu9tIX1z7JrbEvssO
         qwR1BS6Yk6VkF7VwroUtKpjzHQN2aArT6BqjAkQWdLfAe9Y86rscNMWk7Lcgywa1Koys
         tGAA==
X-Gm-Message-State: APjAAAWVApHXvR24UzPOZx6t1cxwTPO0u3jmL95ciWtxFbg2NIzRKqFH
        kjLgk3rhg3r7YF86+xEoBOhw4i6VhstxhzN19oKEfw==
X-Google-Smtp-Source: APXvYqxRS6HGNnHzHSPymtVkY09S+iBm4JI3sHN15mEeri6ajpLBq2/r8E0WfqlqHp2woWQhXECmk6sxOT239ePNQY8=
X-Received: by 2002:a17:902:9002:: with SMTP id a2mr16175819plp.147.1571921263469;
 Thu, 24 Oct 2019 05:47:43 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1571844200.git.andreyknvl@google.com> <20191023150413.8aa05549bd840deccfed5539@linux-foundation.org>
In-Reply-To: <20191023150413.8aa05549bd840deccfed5539@linux-foundation.org>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Thu, 24 Oct 2019 14:47:31 +0200
Message-ID: <CAAeHK+xLS8TVioJeqYrf9Kso9TsiWiH0O-k+RrRBCKPPS9_Hrg@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] kcov: collect coverage from usb and vhost
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     USB list <linux-usb@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Windsor <dwindsor@gmail.com>,
        Elena Reshetova <elena.reshetova@intel.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Alexander Potapenko <glider@google.com>,
        Marco Elver <elver@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 24, 2019 at 12:04 AM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Wed, 23 Oct 2019 17:24:28 +0200 Andrey Konovalov <andreyknvl@google.com> wrote:
>
> > This patchset extends kcov to allow collecting coverage from the USB
> > subsystem and vhost workers. See the first patch description for details
> > about the kcov extension. The other two patches apply this kcov extension
> > to USB and vhost.
> >
> > These patches have been used to enable coverage-guided USB fuzzing with
> > syzkaller for the last few years
>
> I find it surprising that this material is so focused on USB.  Is
> there something unique about USB that gave rise to this situation, or

USB fuzzing is the thing that I've been working on that requires this
functionality. But the idea is to make the interface generic enough to
make it useful for other subsystems as well as long as the annotations
are added.

> is it expected that the new kcov feature will be used elsewhere in the
> kernel?
>
> If the latter, which are the expected subsystems?

Currently we encountered two cases where this is useful: USB and vhost
workers. Most probably there are more subsystems that will benefit
from this kcov extension to get better fuzzing coverage. I don't have
a list of them, but the provided interface should be easy to use when
more of such cases are encountered.
