Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337A237ACC1
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 19:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbhEKRMN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 13:12:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46266 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230315AbhEKRMM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 13:12:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620753065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rZrjJ+O88rA6qykT2B9o+FKt5pQAnvwT/kjMZAbiQ+Y=;
        b=GvfYrs+WBGwpPZ79jOo0n3D6cB/qbcGULUbQzxUefx4gxWYv8vsK5bsm4buapJH5GO2+tc
        IgenZxl9PKcTl5O0qfnQPVd8MIF7gCQ4fqNzWq/nGhM86lTfFz4If0EopJefnnGHOQJHBu
        RuO4IHlsdNikh75eN0ad4bvHk0wVFng=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-U7-0eI8lOzyETb80LzfHpg-1; Tue, 11 May 2021 13:11:00 -0400
X-MC-Unique: U7-0eI8lOzyETb80LzfHpg-1
Received: by mail-ej1-f69.google.com with SMTP id h4-20020a1709067184b02903cbbd4c3d8fso1396005ejk.6
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 10:11:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rZrjJ+O88rA6qykT2B9o+FKt5pQAnvwT/kjMZAbiQ+Y=;
        b=FzEaZY9a90Thpg+wf0VPWIi+2Mffb0Kv2hM5ef1pccpPyVjFJkvnQhjVn7ZZGrE0nK
         WNbDK3norawKZcqrnOUlsT9COWyLfyANToNUazO1R+1nvvb/MuaP4ttUh/AOAijocycP
         /dAshUCgztn3OAg5IStE0/18CQFhLRr2sXZkcHW2Dg8TzcsEYlYm6KX7i195n+plp+LP
         z1xxrsBITaB3N8Ed07pvf3kQ7QhHW0g9sKyZJ/ok7HNwHk9HIC4R9v5rOa7fXSvjiXEE
         zk6XX72dPmk0LXwk3fq2ogKyAPf8Wqu+aOAh+zwyc75+cq37L9/Arbt/3JMg9EGcRRe9
         mVuw==
X-Gm-Message-State: AOAM533GHDmvWqb1+Wd2TyPf95My1QY2SegR5b2L+H5DUCf5OMZQTgu2
        4N1rBWuNCXdKIsucF+1tx7BGNCYSh2hMUhIUotc/eMMxMS8C6zS5oDxo/Dg3z4oVU92NdeIYLrZ
        mUZFIkCU3GvN7
X-Received: by 2002:a05:6402:51c9:: with SMTP id r9mr33684856edd.94.1620753059498;
        Tue, 11 May 2021 10:10:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxpYpw07LI9oOo5kNjsJCNhMuCW/mc5JA7PEVerJPQlbNvE23xRfTktHpr5pHbEO7TKzgF4lg==
X-Received: by 2002:a05:6402:51c9:: with SMTP id r9mr33684840edd.94.1620753059355;
        Tue, 11 May 2021 10:10:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id p14sm14826543eds.28.2021.05.11.10.10.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 May 2021 10:10:58 -0700 (PDT)
Subject: Re: [kvm-unit-tests BUG] lib/ldiv32.c breaks arm compilation
To:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
References: <348f023d-f313-3d98-dc18-b53b6879fe45@arm.com>
 <604b1638-452f-e8e3-b674-014d634e2767@redhat.com>
 <05b5ce5d-4cd8-1fe3-1d2e-d34d4cf31384@arm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <887fb8f1-aa80-88eb-89f3-eda37394c22a@redhat.com>
Date:   Tue, 11 May 2021 19:10:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <05b5ce5d-4cd8-1fe3-1d2e-d34d4cf31384@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/05/21 19:03, Alexandru Elisei wrote:
>> The Fedora one is fixed in the commit immediately after, which replaces
>> inttypes.h with stdint.h.
> $ git remote -v show new
> * remote new
>    Fetch URL:https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git/
>    Push  URL:https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git/
>    HEAD branch: master
>    Remote branches:
>      master  tracked
>      staging tracked
>    Local branch configured for 'git pull':
>      master merges with remote master
>    Local ref configured for 'git push':
>      master pushes to master (up to date)
> $ git pull new
> Already up to date.
> $ git show
> commit 0b2d3dafc0d31025636201df923fa0dc8d2e380e (HEAD -> master, new/master)
> Author: Paolo Bonzini<pbonzini@redhat.com>
> Date:   Wed May 5 08:33:38 2021 -0400
> 
>      libcflat: provide long division routines
> [..]
> 
> I guess the patch has not been merged yet, right?
> 

Oops, it was only in my own tree.  Pushed now.

Paolo

