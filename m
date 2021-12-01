Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4125346521F
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 16:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351166AbhLAP4c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 10:56:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351168AbhLAP4S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 10:56:18 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D27C061757
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 07:52:56 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id 13so48970469ljj.11
        for <kvm@vger.kernel.org>; Wed, 01 Dec 2021 07:52:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mx5dsdfz5OCSLF2KexsR17z+OQVCcJktBVTzMjmEoJ8=;
        b=pexgAzRgXY/1geXePlsTBZDrzBDu1p2gRtnq2cRAfzBigxzIRbaII3NH13sBhkLIee
         /nFW/nNnG9+OMmAxicgRbZFlKD2OV7cYVtEU2o1q4gT7TsuTO2+ooiICqsSJJJ0rJV7G
         xB0agkG8fYIRXG6gvbc9if22pm9BgEZEo/ypoWkUr7z5662IqhIdZB5qqVhHIsE60s0/
         RpRRuCQdkd+3Fm81SDwxk0BahKKEH8QM05C+Awzy9IT4GfS3OnlxwDvD2FMXNMsIlqPx
         Ab/b63eleqMsZzTomJZ/RQ9pknKr72R+bJ/Z04b00bqCZX/E27c4YzIyEgMxp66HfSNz
         dxnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mx5dsdfz5OCSLF2KexsR17z+OQVCcJktBVTzMjmEoJ8=;
        b=Q7DWX6eeqEnyRcvhHValDtXhFTU5m23Dj/jQnCVywjwpSkQFD2o+o1UjE2lEFBentm
         16CAX8irXV4aHKkJBVoYsiHAnFnGqfqmSK5g/ka+2C3GsxAZYakyDj5Z8Z78ZPBUsGrY
         /o1/CZnAbhln8ggjIwDxg9QUoxskqWFMGAlb+/y3Vb/JVqVUZZqBbDK3uKXZAM9iN312
         lmLmHO1ybmp08hvSzzRyB1vcHlerKiLRPyCoWxkuRgwzLno7VD8P0QJa7/xuQlALa7eO
         7Us/UF0lCU4NBtDqgraMmxabJxG1rFVDC288hiG597GfGCKQsc9wZ355KqAKMxie5OyC
         ZG3w==
X-Gm-Message-State: AOAM530tUWw13kFf6bMwu1p6W6c54lmj4g6Hh1/jxfB8JmoN5V9YPZDn
        ayQpCf4fTgoSvjpuPgbSuJxqfh9zVJj6hGA18IMB+3yuznc=
X-Google-Smtp-Source: ABdhPJyQQe0BOvRpWo1wHLFVy65HP5wS2wZVjEw+auOl6P3ynLiLkdMNzIgQDrp1SMsIPpe3icDwQCYfW2jHpS+lgvs=
X-Received: by 2002:a05:651c:1035:: with SMTP id w21mr6160729ljm.278.1638373974799;
 Wed, 01 Dec 2021 07:52:54 -0800 (PST)
MIME-Version: 1.0
References: <20211123005036.2954379-1-pbonzini@redhat.com> <20211123005036.2954379-2-pbonzini@redhat.com>
In-Reply-To: <20211123005036.2954379-2-pbonzini@redhat.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Wed, 1 Dec 2021 08:52:43 -0700
Message-ID: <CAMkAt6qOuXX1NCe=wwVXP7CeWdUiPQ0cdJr21jQn=h5pyEkpSA@mail.gmail.com>
Subject: Re: [PATCH 01/12] selftests: fix check for circular KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 22, 2021 at 5:50 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM leaves the source VM in a dead state,
> so migrating back to the original source VM fails the ioctl.  Adjust
> the test.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Peter Gonda <pgonda@google.com>
