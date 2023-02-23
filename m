Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1B996A1287
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 23:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbjBWWEo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 17:04:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjBWWEn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 17:04:43 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A5154A34
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 14:04:42 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id m10-20020a17090a668a00b002371fb8da57so254023pjj.0
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 14:04:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=op+oy1YDQ7KvdZybV8OQUjUsRVDUyPKIIdxPtDryYlQ=;
        b=loBUhV2zLEQLuXPAW0C42cV8HChQm+pD/ZksSVAMsDKYrQdAR3kp9e9EJq4/oYonCT
         bkTf7yAdDIo6UGCpl9Qrmya6clGcxszcv4f25JRukUVThLzanXyrYQJ9vIjFMDF2LpvR
         hDgLQqCguoqdP6p43Mjdij9EHG/hnrHRMrt/QvC5L35IHXK5AjHSqu0tDk/4XkBRNHn3
         x5gKkgDmQ+cxcN2X6vAf6lJyVYtfYS/H81gwvSRPAWl4rTcZvf3W2Gjdo8hWTH30njae
         /mZZd4VR+cDnHLfmh/nxOMWOzWA8lyKh0OrsOW0Ztc3+LKv77rHYp1iodZo8My1zLiJM
         HDPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=op+oy1YDQ7KvdZybV8OQUjUsRVDUyPKIIdxPtDryYlQ=;
        b=v0OgYUrqzi1ICOjDlG6jtmEv1w2tJJb2brOc00ZyrBZS5xk8HL0UXWxJgpL7fw7JxV
         otMv8wCZqh3gEEl8jgNloHFdvw+FCvcNWQhUvB+XZvKSx/2hbniU1+9mDeceOQV5bNZA
         jjZhOworGHLfBXl1uL6+X6AZbndAKpQIkeYYaGaPE61i4LfrLWW2YfzcITOlP/JgTO6Q
         GyIsMx0RCeyW/HQEb+BIeM+AXU/hXTtbujLkJes4htOnFsivzu/r7Thkc2J2vCsQSQ7W
         MkTkgiM16vmp+u9p8HSHFHbUKPnnhwOyXGdncMyjoCn5kTc/c0RHk+bRaETVode6eveR
         OyYA==
X-Gm-Message-State: AO0yUKXRqFs0dKhxT6+uKpX7NviLwD54Q5GQjdNECa7aiYziJKZvqY28
        vLfHrLH8MbUlPoi7AX/ceaqBdH/lELM=
X-Google-Smtp-Source: AK7set+y2SobsE7Atxlq3uiiFWoOB6fnx5tYBQ74THwpR6KRCJyGX9C9kHG0Txo1l5oIjPYqGARtUtw1MR0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:7e41:b0:196:433e:2378 with SMTP id
 a1-20020a1709027e4100b00196433e2378mr2165787pln.4.1677189881819; Thu, 23 Feb
 2023 14:04:41 -0800 (PST)
Date:   Thu, 23 Feb 2023 14:04:39 -0800
In-Reply-To: <87o7qof00m.fsf@secure.mitica>
Mime-Version: 1.0
References: <87o7qof00m.fsf@secure.mitica>
Message-ID: <Y/fi95ksLZSVc9/T@google.com>
Subject: Re: Fortnightly KVM call for 2023-02-07
From:   Sean Christopherson <seanjc@google.com>
To:     Juan Quintela <quintela@redhat.com>
Cc:     kvm-devel <kvm@vger.kernel.org>, qemu-devel@nongnu.org,
        Markus Armbruster <armbru@redhat.com>,
        Paul Moore <pmoore@redhat.com>, peter.maydell@linaro.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 24, 2023, Juan Quintela wrote:
> Please, send any topic that you are interested in covering in the next
> call in 2 weeks.
> 
> We have already topics:
> - single qemu binary
>   People on previous call (today) asked if Markus, Paolo and Peter could
>   be there on next one to further discuss the topic.
> 
> - Huge Memory guests
> 
>   Will send a separate email with the questions that we want to discuss
>   later during the week.
> 
> After discussions on the QEMU Summit, we are going to have always open a
> KVM call where you can add topics.

Hi Juan!

I have a somewhat odd request: can I convince you to rename "KVM call" to something
like "QEMU+KVM call"?

I would like to kickstart a recurring public meeting/forum that (almost) exclusively
targets internal KVM development, but I don't to cause confusion and definitely don't
want to usurp your meeting.  The goal/purpose of the KVM-specific meeting would be to
do design reviews, syncs, etc. on KVM internals and things like KVM selftests, while,
IIUC, the current "KVM call" is aimed at at the entire KVM+QEMU+VFIO ecosystem.

Thanks!
