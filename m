Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3C036473C
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 17:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235788AbhDSPlo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 11:41:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21858 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232986AbhDSPln (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Apr 2021 11:41:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618846872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YNXfeUWJzMhTvHjWB9KiLtIu2FPbXxQmBXeu2HfwhgU=;
        b=ghevEqZT2klWovr2aX7bAjuEaxY1hhLIoxeomtjQVtgFtKEqcoA5VXG6KPn0JywAdH1281
        /jzbcjtgFFO1yct4f2FUoXQsIb3vjeGg9DTMPmLQ/BNxdwHEKuUiiLZmtQbmHkyCXzxo3q
        XaeqN3PE0tH/5hnTMaunsZsXSyNdLeU=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-xggQSNtbMA2UugSCYoAo8w-1; Mon, 19 Apr 2021 11:41:11 -0400
X-MC-Unique: xggQSNtbMA2UugSCYoAo8w-1
Received: by mail-ej1-f69.google.com with SMTP id 16-20020a1709063010b029037417ca2d43so3796652ejz.5
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 08:41:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=YNXfeUWJzMhTvHjWB9KiLtIu2FPbXxQmBXeu2HfwhgU=;
        b=ZTiDO2u9bK9IIyhwaxlYFuZdsmQxXvYkGYVX9q+gaas3U679dXExPwnioJF/nCWp9c
         dIoxuSP5DfeMnNN7qh44+H4+7d64kC82LX95qNTnk7u22a3/uIUdPWu0obtZiwcvEEmD
         IbfVD7kdpFtBtmY3DVRL7oociYtqCEqkAS/tujcNMFml1ahgXaHkBxCSa3NY4G8zaJqM
         ZTLaGc6WNPOA0w/D7YHe3+nR4gPOla5ZPabyy1/vrziLq3ysB6bsgDUHDw/aFwycPsmi
         VLoj8VTdRnIZTHSNuz+TGTXcNe2wz6eTBQVWyS53iJTOhPdQyq6KXZ/hnt8a33gEGG4k
         qRLg==
X-Gm-Message-State: AOAM5329GBLv2COOdDLhvxkTldnPAJMolgYuPtHxwcqD/ZjXks1OjBNG
        kFhRe368PKDn1+WygUkl6l9JUE+B1Q8hQGODFXi+w7RJVQfL9NhB0vfQImwqF/vuppz154tUw7b
        axyZtcVYIwMYG
X-Received: by 2002:a05:6402:1013:: with SMTP id c19mr26575094edu.213.1618846869876;
        Mon, 19 Apr 2021 08:41:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9oDf26/SAnj6GvXNUx5gbX+R9bYfE8m8xnLsZWPQz8bCEwd7vAIxDi85jmWinKrf82UlsAA==
X-Received: by 2002:a05:6402:1013:: with SMTP id c19mr26575062edu.213.1618846869630;
        Mon, 19 Apr 2021 08:41:09 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id p13sm5857908ejr.87.2021.04.19.08.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 08:41:09 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH kvm-unit-tests v2 0/4] x86: hyperv_stimer: test direct mode
In-Reply-To: <20210224163547.197100-1-vkuznets@redhat.com>
References: <20210224163547.197100-1-vkuznets@redhat.com>
Date:   Mon, 19 Apr 2021 17:41:08 +0200
Message-ID: <87zgxui8ob.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

> Changes since v1:
> - Minor cosmetic changes. v1 was sent in October, 2019 and I completely
>  forgot about it. Time to dust it off!

Ping) Patches should still apply to 'master' with no issues.

>
> Original description:
>
> Testing 'direct' mode requires us to add 'hv_stimer_direct' CPU flag to
> QEMU, create a new entry in unittests.cfg to not lose the ability to test
> stimers in 'VMbus message' mode.
>
> Vitaly Kuznetsov (4):
>   x86: hyperv_stimer: keep SINT number parameter in 'struct stimer'
>   x86: hyperv_stimer: define union hv_stimer_config
>   x86: hyperv_stimer: don't require hyperv-testdev
>   x86: hyperv_stimer: add direct mode tests
>
>  x86/hyperv.h        |  29 ++++++--
>  x86/hyperv_stimer.c | 159 +++++++++++++++++++++++++++++++++++---------
>  x86/unittests.cfg   |   8 ++-
>  3 files changed, 157 insertions(+), 39 deletions(-)

-- 
Vitaly

