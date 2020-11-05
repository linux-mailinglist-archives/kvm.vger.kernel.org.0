Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDA52A877D
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 20:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgKETlh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 14:41:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgKETlg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Nov 2020 14:41:36 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F59C0613CF
        for <kvm@vger.kernel.org>; Thu,  5 Nov 2020 11:41:36 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id k21so2994002ioa.9
        for <kvm@vger.kernel.org>; Thu, 05 Nov 2020 11:41:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mMFl7uDCeYwVS0C8S8zRSor49WAEG9e91B/j0qjCYGg=;
        b=cMBDgo01u1y5glr7vy+92CIYd5kF8DIh7ommjoibm3d+BWX6YoaGxyKGQou+oA0n8H
         LpHXZWrzMM5VnUHllAsiyA5by0mfZg4HnUgK2Hx2EY4C5tVgIlbJwSnTgosrneHJkurC
         E/If95DuKACobDiVZKcGgYxaIGE9w4S0h7j0QFDHoNfji/o6lK+ZwARtIKG0FMlT2eIE
         0KugoE6nOS8cwAZB6w1Zjj6+MK94d5+XT6MSSD4+jY22s2s0QeFIy6t3OebiyeKACIbd
         TgctHk8vrQ34G2kvj8c5Mo0L+hhRNqlRQQGz6IZWQJ6ad+haTGHfHTC3eBWW+c+AnSli
         S1nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mMFl7uDCeYwVS0C8S8zRSor49WAEG9e91B/j0qjCYGg=;
        b=habLPq+DV/1TWz7aZKNzVtnvG++KfF9mDZVZ68CbXQQtGj72aRMEfp9/EUIvWUbeH7
         LHMqv/KIzMkSeKfj9BT31JeguqgXIoIp9vAncXmTq8uv8ScVQYbhYiDs5K3aiGenrcUb
         MZj7J9ME+honDzwzyMvYvbdZByxMI6nakG6acKLfUptKpzkOGmuJtZ+Yd9l4rSQOHzW7
         ARQyMky6ApT2OxnJrzYnfo0hbW54DGfAQgk0bacCvfXsFopeTuzc88D1+cJx610cRxNi
         cuigw+R+3QlebiaR4aemnyeJuCT6LAOvYTbXhWlJCQ0HqhiOwok8O0Rbig9mrJC2/agy
         Rrlg==
X-Gm-Message-State: AOAM5337w9oMCvEZmZjaRgH5vAINWSJM+PU4n609M9GdNKh7Pq8K0f+I
        TZdlMTUcUewlJIBXV+ByQhS35Q7fNjeE4OIgUW6kFL0V4Fw=
X-Google-Smtp-Source: ABdhPJwGuQvFw+6T9g0dYx38ZdxoBXCHyyIBsUe+/TrGsn9xwCLI9D3OcJFcmjc0/5OE5PuGML335AmahLVGl7J66iQ=
X-Received: by 2002:a05:6638:15a:: with SMTP id y26mr3440665jao.57.1604605295752;
 Thu, 05 Nov 2020 11:41:35 -0800 (PST)
MIME-Version: 1.0
References: <20201104212357.171559-1-drjones@redhat.com> <20201105185554.GD106309@xz-x1>
In-Reply-To: <20201105185554.GD106309@xz-x1>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 5 Nov 2020 11:41:24 -0800
Message-ID: <CANgfPd_97QGP+q8-_VAzhJxw_kdiHcFukAZ-dSp4cNrvKdNEpg@mail.gmail.com>
Subject: Re: [PATCH 00/11] KVM: selftests: Cleanups
To:     Peter Xu <peterx@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 5, 2020 at 10:56 AM Peter Xu <peterx@redhat.com> wrote:
>
> On Wed, Nov 04, 2020 at 10:23:46PM +0100, Andrew Jones wrote:
> > This series attempts to clean up demand_paging_test and dirty_log_test
> > by factoring out common code, creating some new API along the way. It's
> > main goal is to prepare for even more factoring that Ben and Peter want
> > to do. The series would have a nice negative diff stat, but it also
> > picks up a few of Peter's patches for his new dirty log test. So, the
> > +/- diff stat is close to equal. It's not as close as an electoral vote
> > count, but it's close.
> >
> > I've tested on x86 and AArch64 (one config each), but not s390x.
>
> The whole series looks good to me (probably except the PTRS_PER_PAGE one; but
> that's not hurting much anyways, I think).  Thanks for picking up the other
> patches, even if they made the diff stat much less pretty..

This series looks good to me too. Thanks for doing this Drew!

Sorry I'm later than I wanted to be in reviewing this series. I
learned I was exposed to someone with COVID yesterday, so I've been a
bit scattered. The dirty log perf test series v3 might be delayed a
bit as a result, but I'll send it out as soon as I can after this
series is merged.

>
> --
> Peter Xu
>
