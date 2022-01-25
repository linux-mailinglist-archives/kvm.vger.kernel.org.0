Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 862E749B912
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 17:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1585791AbiAYQo4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 11:44:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:53454 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1584998AbiAYQlF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Jan 2022 11:41:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643128864;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=xd2iJ+kOBVbi8g1JjppUEpmyYWG+P3BqcYqwStylD5c=;
        b=Bz1+2tp59pNLuPoJNV1nWnfaWt2UzO+njEykI8xI465RUvFyBPE2eaj35GkXHtWJl5Fm3U
        tC7OCxXLTs11w68Id5jyPg9f1t3QZJ47eyP1mYe2Hwc+hsVqt1RPIrL3omE2mDqi9bqKIu
        RpauFE/FGI3APDOQMAkaWvhU+8vpveI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-n3r2MP6jNbewKHrq4IJOzw-1; Tue, 25 Jan 2022 11:41:03 -0500
X-MC-Unique: n3r2MP6jNbewKHrq4IJOzw-1
Received: by mail-wr1-f70.google.com with SMTP id g8-20020adfa488000000b001d8e6467fe8so3298015wrb.6
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 08:41:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :user-agent:reply-to:date:message-id:mime-version;
        bh=xd2iJ+kOBVbi8g1JjppUEpmyYWG+P3BqcYqwStylD5c=;
        b=0bq+Y1V5rMr3LmRCc1crF0EXELovaDYzTjCqLoYvT3Pi5fXLpALhiiiEPcLqg7haOx
         rG8mkjp6M/hXKB8+BXeuNBFbcVoHB7kpqh/yjEXNZIN6esS3FYzEEb4/WXG0QafVHcHx
         fYD9KMsWFSdsc3QF50/gss1wJyBzwRUmSzKGXOecX/hv77W+Ucz9KRLh+X4/Iiw0KbF/
         lZukWHMnVGWEpc/ZjzUg5TsgasSO4gMJVE/kht0RiApksqoiui33e6knQxPdSv5UbLDa
         4QVRX6W3V/0lvx20caiCJhrsqISi2CXhUXsvOrnjbTldjW6lvtKt+qFqBOZiQsNjyLBy
         cTnA==
X-Gm-Message-State: AOAM530mRitk7ynq9m1QXNDaJT5CoVU6kUTCWboJ0IOPi/46Po9hYVKe
        U+fQ9XXDoCiCr/A/4KkCZEx2chkCbNsrJheJtUOn1bUTS8gE8TE0/ZSHnSrccVsHU1FkRQJwgma
        PCDaeFIVKjVKQhV8RIZpx2/o1hWd5RFJjydKK18EYGCIxdLrDckM830g8cK/0Eyrl
X-Received: by 2002:a5d:608c:: with SMTP id w12mr18554791wrt.313.1643128862111;
        Tue, 25 Jan 2022 08:41:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyPu5bbVO0Sbr+n4WfTfdT8jjkPffILQqZVx9MHejWuC/mdWjfGKfDdN8hgo8M+I441xVnkKw==
X-Received: by 2002:a5d:608c:: with SMTP id w12mr18554771wrt.313.1643128861849;
        Tue, 25 Jan 2022 08:41:01 -0800 (PST)
Received: from localhost ([47.61.17.76])
        by smtp.gmail.com with ESMTPSA id s9sm16970988wrr.84.2022.01.25.08.41.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 08:41:01 -0800 (PST)
From:   Juan Quintela <quintela@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>
Cc:     qemu-devel@nongnu.org
Subject: Re: KVM call minutes for 2022-01-25
In-Reply-To: <87k0enrcr0.fsf@secure.mitica> (Juan Quintela's message of "Tue,
        25 Jan 2022 17:39:15 +0100")
References: <87k0enrcr0.fsf@secure.mitica>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Tue, 25 Jan 2022 17:41:00 +0100
Message-ID: <87a6fjrco3.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Juan Quintela <quintela@redhat.com> wrote:
> Hi
>
> Today we have the KVM devel call.  We discussed how to create machines
> from QMP without needing to recompile QEMU.
>
>
> Three different problems:
> - startup QMP (*)
>   not discussed today
> - one binary or two
>   not discussed today
> - being able to create machines dynamically.
>   everybody agrees that we want this. Problem is how.
> - current greensocs approach
> - interested for all architectures, they need a couple of them
>
> what greensocs have:
> - python program that is able to read a blob that have a device tree from the blob
> - basically the machine type is empty and is configured from there
> - 100 machines around 400 devices models
> - Need to do the configuration before the machine construction happens
> - different hotplug/coldplug
> - How to describe devices that have multiple connections
>
> As the discussion is quite complicated, here is the recording of it.
>
> Later, Juan.
>
>
> https://redhat.bluejeans.com/m/TFyaUsLqt3T/?share=True

And now the link that works without a login.

https://bluejeans.com/s/KetOlwoxLa3

Later, Juan.

