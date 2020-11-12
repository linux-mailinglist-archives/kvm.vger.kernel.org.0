Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7909C2B0CB3
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 19:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgKLSeZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Nov 2020 13:34:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgKLSeX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Nov 2020 13:34:23 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957BCC0613D1
        for <kvm@vger.kernel.org>; Thu, 12 Nov 2020 10:34:23 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id u21so7055152iol.12
        for <kvm@vger.kernel.org>; Thu, 12 Nov 2020 10:34:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xLlRyBYj/EC+kUvkMq1QT1Bh0c0KMjvvUSKRvyp9xSE=;
        b=MZSJXL6MyFjuAbqtjCMCnOlKDLyklin7LSdUZUtvTCT9sHPL3vDeHfpDRwOronaAog
         5JVdcvGhncbp+c70ol556MtnJsMVwtehOgyLVWOZTUOZy3BQEYVG+1pD1gqysZz9/XZm
         4tCat2GrF+cRHAWjpufh/RzFdcz+Hc11roTAnJzaQzM/GbE6wl3aqL/CXs1K1LUQwzHS
         geohbEgTXRVaOjMssLmDKZ0vNDmgyeBO+bBJSX3jc/ZsvULTX9dohLutR5TA9NtKn80f
         /EB+GsKqSlpn9gYA6ePf/UMa/+7CAOvJlXNyQPg9IUGov+aSNCcU/1kXrgvH1M+/USlm
         A6wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xLlRyBYj/EC+kUvkMq1QT1Bh0c0KMjvvUSKRvyp9xSE=;
        b=O9ZEsqtp5D0pjaqrh/RCws57cJFV+xSv+6yUQrOWrKhtAlFPOEMy1YzaRO5DsBoKpm
         GORT5yN9bKHMiutpIW6E2/LGggv4tNgLRV+R94C39wT0TeP6D4pp395YXGUfJIQDm0rZ
         0XNYtDHPnQjiUITMGzocLsl+pVGxJzzW3wsA6VXTnSF6dH7hEtpT25mlYNt0UHCczMJW
         zthuRn+NYazC6FLu8Yht4SwXCZJGoQyn/f4+xro3eDXRb4nnVuLH4O6xZMlwIUwevKkr
         bZolHaWROoOlordFJwZAR4sn3tOXfxp6BudqjKgpB55uhGouLm2PfLmwib5TJSnSQvEg
         eOJg==
X-Gm-Message-State: AOAM5308t2ik6gRg91EeImqWrLL8QAgjdvJAgYgkOHLdn9p5adZ7cuQt
        IGvkgss082ROlVLn9ixQOtotVwtom8wrtG5V5GQcRg==
X-Google-Smtp-Source: ABdhPJyJEXBLt0SBR1np36V/jLTMr/EIoBAG89zkFtp5ElSPTF4Yl/oYeNhNV6Q157Uf6Suo8hArLbD9R5tKQTsVKoI=
X-Received: by 2002:a5e:d515:: with SMTP id e21mr342869iom.9.1605206062740;
 Thu, 12 Nov 2020 10:34:22 -0800 (PST)
MIME-Version: 1.0
References: <20201111122636.73346-1-drjones@redhat.com> <20201111122636.73346-3-drjones@redhat.com>
 <20201112181921.GS26342@xz-x1>
In-Reply-To: <20201112181921.GS26342@xz-x1>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 12 Nov 2020 10:34:11 -0800
Message-ID: <CANgfPd_R_Rjn+QT_yiUwpCUK3TUfmhSN6XpZ5=L17mhrtMi7Zw@mail.gmail.com>
Subject: Re: [PATCH v2 02/11] KVM: selftests: Remove deadcode
To:     Peter Xu <peterx@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 12, 2020 at 10:19 AM Peter Xu <peterx@redhat.com> wrote:
>
> On Wed, Nov 11, 2020 at 01:26:27PM +0100, Andrew Jones wrote:
> > Nothing sets USE_CLEAR_DIRTY_LOG anymore, so anything it surrounds
> > is dead code.
> >
> > Reviewed-by: Ben Gardon <bgardon@google.com>
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
>
> It's kind of a pity that there seem to a few valid measurements for clear dirty
> log from Ben. I'm just thinking whether clear dirty log should be even more
> important since imho that should be the right way to use KVM_GET_DIRTY_LOG on a
> kernel new enough, since it's a total win (not like dirty ring, which depends).

I didn't review this patch closely enough, and assumed the clear dirty
log was still being done because of
afdb19600719 KVM: selftests: Use a single binary for dirty/clear log test

Looking back now, I see that that is not the case.

I'd like to retract my endorsement in that case. I'd prefer to leave
the dead code in and I'll send another series to actually use it once
this series is merged. I've already written the code to use it and
time the clearing, so it seems a pity to remove it now.

Alternatively I could just revert this commit in that future series,
though I suspect not removing the dead code would reduce the chances
of merge conflicts. Either way works.

I can extend the dirty log mode functions from dirty_log_test for
dirty_log_perf_test in that series too.


>
> So far, the statement is definitely true above, since we can always work on
> top.  So:
>
> Reviewed-by: Peter Xu <peterx@redhat.com>
>
> Thanks,
>
> --
> Peter Xu
>
