Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7FC1FAB93
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 10:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727907AbgFPIsK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 04:48:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36294 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725710AbgFPIsJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 04:48:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592297288;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M8KB+cTLS7xorWY/8wkVIPQKcO1yqa/ZtcbOQCRk7fw=;
        b=QA3iypAmaAEJurC13tHN5Dmd6DCBNwPHBww6BlyckgiWvI518DFTCyw8q8/HKb+igdbLPC
        vwyaaY7mIQ0wNmQ9URQVjhiLytwhcnqrMkOp57GAIEhQpg/Z+UqNdP2tpXUCgdHzFf9irG
        0gYKn/Boe4kGEtuQBonq1vVlvuFPAxc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-492-VAqHAvSINC--U-re_Sk9eg-1; Tue, 16 Jun 2020 04:48:04 -0400
X-MC-Unique: VAqHAvSINC--U-re_Sk9eg-1
Received: by mail-wr1-f71.google.com with SMTP id r5so8044902wrt.9
        for <kvm@vger.kernel.org>; Tue, 16 Jun 2020 01:48:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :user-agent:reply-to:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M8KB+cTLS7xorWY/8wkVIPQKcO1yqa/ZtcbOQCRk7fw=;
        b=t811rVkrwjOt4SpTA0LJlVdy3ePGWikPcA6ZAw/R1KPnyBAMZpz9b7cRfpvG5fPGwG
         GssXO2pMecl2SYcGKsyQ71sIHp4yW3g9HR3kOir3cTvYHjFhFrLBVUWa5hINgto5a8AG
         CCnVgNN5uS/xb+ioE37Ccu4Lz44VvbfWfzDeDLVwtWlDpLvbobGGjCctMOJXLa6K8S7N
         74qJVQo9yBhdQBSUUrsIZM7d8DHCWixWeGAlJ5GRVArNs19xZE0ftn4SQM0nYblor4Ph
         XdW+JpAUdtlhpqzgjVteg9azct6dWy2KlUYDnf7L6FsuS0GJptgTX0P93vUi9F3iV+8J
         9Jgw==
X-Gm-Message-State: AOAM530SZqJNdoU+6VL6HkAUwFH7EIxD+BLDXoW3tUFu6bLNTdR2AY07
        kJpDHHFI6UBdsQ/+7RQGTX3lMEhpVpNhxJYr3CKQ3qCUaQuZj8fr54C4D/YflgB7pkond6I8l8w
        J3hODGsEo6NyS
X-Received: by 2002:a7b:c11a:: with SMTP id w26mr2029654wmi.0.1592297283225;
        Tue, 16 Jun 2020 01:48:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwvZnUjAE4GDabkYeFSd57AxeyTiGDyShyzrSQHYgdOvkCCTgddGvqjYyXzr8kCLBpWD5eVJA==
X-Received: by 2002:a7b:c11a:: with SMTP id w26mr2029638wmi.0.1592297282996;
        Tue, 16 Jun 2020 01:48:02 -0700 (PDT)
Received: from localhost (trasno.trasno.org. [83.165.45.250])
        by smtp.gmail.com with ESMTPSA id f185sm3009408wmf.43.2020.06.16.01.48.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 01:48:02 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>
Cc:     qemu-devel@nongnu.org
Subject: Re: KVM call for 2016-06-16
In-Reply-To: <87wo48n047.fsf@secure.mitica> (Juan Quintela's message of "Mon,
        15 Jun 2020 11:34:32 +0200")
References: <87wo48n047.fsf@secure.mitica>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Tue, 16 Jun 2020 10:48:01 +0200
Message-ID: <87h7vbxupq.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Juan Quintela <quintela@redhat.com> wrote:
> Hi

Hi

As there are no topics, this calls gets cancelled.

Happy hacking.

Later, Juan.


>
> Please, send any topic that you are interested in covering.
> There is already a topic from last call:
>
> Last minute suggestion after recent IRC chat with Alex Benn=C3=A9e and
> Thomas Huth:
>
> "Move some of the build/CI infrastructure to GitLab."
>
> Pro/Con?
>
>  - GitLab does not offer s390x/ppc64el =3D> keep Travis for these?
>
> How to coordinate efforts?
>
> What we want to improve? Priorities?
>
> Who can do which task / is motivated.
>
> What has bugged us recently:
> - Cross-build images (currently rebuilt all the time on Shippable)
>
> Long term interests:
>
> - Collect quality metrics
>   . build time
>   . test duration
>   . performances
>   . binary size
>   . runtime memory used
>
> - Collect code coverage
>
> Note, this is orthogonal to the "Gating CI" task Cleber is working on:
> https://www.mail-archive.com/qemu-devel@nongnu.org/msg688150.html
>
>
>
>
> At the end of Monday I will send an email with the agenda or the
> cancellation of the call, so hurry up.
>
> After discussions on the QEMU Summit, we are going to have always open a
> KVM call where you can add topics.
>
>  Call details:
>
> By popular demand, a google calendar public entry with it
>
>   https://www.google.com/calendar/embed?src=3DdG9iMXRqcXAzN3Y4ZXZwNzRoMHE=
4a3BqcXNAZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ
>
> (Let me know if you have any problems with the calendar entry.  I just
> gave up about getting right at the same time CEST, CET, EDT and DST).
>
> If you need phone number details,  contact me privately
>
> Thanks, Juan.

