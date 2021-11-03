Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 127CC444B3E
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 00:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbhKCXKh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 19:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbhKCXKg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 19:10:36 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88593C06127A
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 16:07:59 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id y20so3946705pfi.4
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 16:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8yaW7bzXe4yys7yTtEPfAvcvjjvX4R1Y6KiKrJ3surQ=;
        b=BN9M8yhbhfPl4RAvGzgSz0yTDRbGdwqEAZn7Uqiqx8NtTEj7Z8oLPsEl16K3Bc78I2
         8og91Xy589UPQHpUBVAwmehZTG0MfNE9IaqFxOms+QkBaG/ZRdjnwpn/q0/fLR8YnMaY
         Bk1shaKheagMnMhdGSgVTJG4SvBUEbUTYmsz3LzLbA0201mcJykfcLpuU4kvz76tiPo+
         bsA7Tcakz4ciVt62k9xcnasvyAwrUDVRxeR6k8uPIGBg4mcbbT/1m/dF/5lYkiAxF0jT
         L+xVbDJWzwAGxXWaYZy+6QDOSxvX5IvxT9HgfX4gu9cCDsWqOxXTateWnqegjAYsB1Wg
         5OsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8yaW7bzXe4yys7yTtEPfAvcvjjvX4R1Y6KiKrJ3surQ=;
        b=ErKUH1B2xwwyb8d4jRCdNmMXnBLTFEAhSay34WHeQRg76ZCd6FxzCvSdBj2DdQ6ElS
         0AOHJJW4waQ9JycQ92VbWpHk2Qv7MMLTWyC5X3MPTRbMAw1RDocVO/nyS8Tu++PDp4Cz
         sDhO4VFVTgQzwrHqkmuNRUAYc3hIdHW/EeQ1emzZsGmetfm1ggdZB1CHTiPGMLJ3x3mS
         Lz9S8cbIzSAxFr6WV8ZznufBe/8NLh7ydt1qbqZgWEGDSEDd9EdGfFVFBbs/2ic06sMr
         e144aNrMIMoaXyXeEPSpEQ0uiOyC0kjTYAdsapa+vdH1XurMLddFuav/UYs1cnqFpaYo
         tEmw==
X-Gm-Message-State: AOAM533lvzQ/Ir59yGymlMs0L0ttS8qtTcww40p7pPUsGnv/NBgpfAUi
        pH0SOb0Oyc1J6Hpze1Vqa1xLgA==
X-Google-Smtp-Source: ABdhPJxpfqJe3VGZemJkfTGPxc6se4YW+yh21PyNUGidR5vmQBrWCmxkc/4bTNFR3tgDcboY2DHE2g==
X-Received: by 2002:a63:a801:: with SMTP id o1mr36104100pgf.23.1635980878910;
        Wed, 03 Nov 2021 16:07:58 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b10sm3291227pfi.122.2021.11.03.16.07.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 16:07:58 -0700 (PDT)
Date:   Wed, 3 Nov 2021 23:07:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, dmatlack@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] Add wrapper to read GPR of INVPCID, INVVPID, and
 INVEPT
Message-ID: <YYMWSvDlYZ26D4yU@google.com>
References: <20211103205911.1253463-1-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103205911.1253463-1-vipinsh@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 03, 2021, Vipin Sharma wrote:
> Hello,
> 
> v3 is similar to v2 except that the commit message of "PATCH v3 2/2" is now
> clearer and detailed.

Heh, please wait at _minimum_ one day before spinning a new version.  I know it's
a bit weird/silly for such a small series, but even in this case I replied to the
previous version because I circled back to the "series" while waiting for a build
to complete.  For small series and/or single patches, unless there's a reason for
urgency, it's polite to wait a few days between versions to give folks a reasonable
chance to weigh in before getting hit with a new version.
