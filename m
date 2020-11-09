Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 495DE2AC1E2
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 18:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730208AbgKIRLf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 12:11:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729432AbgKIRLf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 12:11:35 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BACAC0613CF
        for <kvm@vger.kernel.org>; Mon,  9 Nov 2020 09:11:34 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id k21so10549177ioa.9
        for <kvm@vger.kernel.org>; Mon, 09 Nov 2020 09:11:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P7u70PYKGiI0eRkh5NpQgC8KQUNro+UyZhli4N8InKI=;
        b=Amqlrsz2wodJrKO/6JXvJI9HlqosYhqO3IVvLHsRxO8wMdjRlXjxEl+o6fj+Mi/2Fc
         RQW8h4N3KlKNegU/PSpfUST87iI80n+NFR0ywnW1I62Q8yyxLR8fc0uC+r0xGhxpQRCG
         GYOI1hCWh4C/C11UNvVgRdvIJIAbg/jTjxLKPfuSieCQ0J96+9AwJkaHKAYwPlOH6mwP
         uu7UZ4gFv+wnehMQMLmkPgFjS0jFLEoMHSvIq0Nn839e98ZvYV5OrSqkcDY1TVpkT8ni
         n3lEK8YCsnuvux/fne0lIXzfcwDs5awkzvH6r2fOfTABaZ3ITVDHVRBNDtYgnozRfLmt
         YlyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P7u70PYKGiI0eRkh5NpQgC8KQUNro+UyZhli4N8InKI=;
        b=EWKrTF3lWxBISReqpC1Z0JPulgshNog2qXuH8fLZxCnVtnyAX2+clDt40esfVRumbi
         JKbPiGdQAM5yulmjDRaPCcz1zHcjISB3ylWezlhSzrxPBSZ7mxLxjzE18/lMIVp1beV5
         jR5VxuvUtO5BfSiVZk4aEksH54QOgCeApP+L9vd7ABcXhuPFAlQT6gG+n1t7JxmF4Fdh
         lojW8CIec+VYno5vYYECDfcCBpFKLgt1MG0AqjfKuh9FO1Uqjsj4fkysUle4CpZIKVEJ
         qWrFon2P5oyL9yEbjP2PdxZKjlCcIHTeB+uACPVmv9Q5RT7U68wWhVDd7Ha41Et3o+BC
         7FCg==
X-Gm-Message-State: AOAM531qcwDv96BSN6tMcxk7e0AvMvoE4mhQ8okkDpVHKVCz9SBDdm6L
        QvNDpdzbsOsZ825kzkre2IuQE3VkQV/HiS8tzpeoYw==
X-Google-Smtp-Source: ABdhPJxB1JicA1FOsZGDfygi1wkeDEPeYwPrKW03KNbXOSJhs/y3w7IhHTqQcWD4ygD1upsT2TLeLiIjCthW0xkhLNU=
X-Received: by 2002:a05:6638:124f:: with SMTP id o15mr11618258jas.40.1604941893375;
 Mon, 09 Nov 2020 09:11:33 -0800 (PST)
MIME-Version: 1.0
References: <20201104212357.171559-1-drjones@redhat.com> <20201105185554.GD106309@xz-x1>
 <CANgfPd_97QGP+q8-_VAzhJxw_kdiHcFukAZ-dSp4cNrvKdNEpg@mail.gmail.com>
 <20201106094511.s4dj2a7n32dawt7m@kamzik.brq.redhat.com> <20201106150401.GB138364@xz-x1>
In-Reply-To: <20201106150401.GB138364@xz-x1>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 9 Nov 2020 09:11:22 -0800
Message-ID: <CANgfPd-GGqqH6eJoitSsOsJMGPxFusDOTrOZNtGEJiHzHSLHZA@mail.gmail.com>
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

On Fri, Nov 6, 2020 at 7:04 AM Peter Xu <peterx@redhat.com> wrote:
>
> On Fri, Nov 06, 2020 at 10:45:11AM +0100, Andrew Jones wrote:
> > Yikes! Don't worry about KVM selftests then. Except for one more question?
> > Can I translate your "looks good to me" into a r-b for the series? And,
> > same question for Peter. I'll be respinning witht eh PTES_PER_PAGE change
> > and can add your guys' r-b's if you want to give them.

Ah yes, please add my reviewed-by as well, sorry that wasn't clear.

>
> Yes, please feel free to add with mine (if there's a repost).  Though I see
> that Paolo has queued the series already, so maybe it's even easier to directly
> work on top.
>
> Thanks!
>
> --
> Peter Xu
>
