Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBB523260D
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 22:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbgG2UQv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 16:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbgG2UQv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 16:16:51 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46C6C0619D2
        for <kvm@vger.kernel.org>; Wed, 29 Jul 2020 13:16:50 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id l1so25894675ioh.5
        for <kvm@vger.kernel.org>; Wed, 29 Jul 2020 13:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qq+ysuvSU+V8JQG1DuA+Q8eHlgCH1eO+fRWf5OmQClQ=;
        b=YcvEkCx9qexk7f+HNawBWOgq3Ozk6TN2CCHAbw23oQ3VzwAf9Q+gVni2+YeXOSo80m
         wNwNPYLaR+D5PcrJyAE4lrbD2wdX27P0wNO/Y0GesGL7tfLXyFOKSNPWJ8UhME89F2SC
         WW3HOcWX4qfczElt0ALpYlZcC+WRjvve8dFU5bPSu+SbWSM14nknjDRcYRNi/vH8x6Dv
         bEX35VZtg4Q56GYYgrkWRr6bk6MAFZugFyJE60UCLZDE5s9p7DC3pgpzDT1vN2TxTAXz
         VRdn0EwJFjhmR7zFyq9o4uyPUYIjCgcyWccX8a5348RDxrepHllS7xCIzaTGR+DzibhZ
         D1Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qq+ysuvSU+V8JQG1DuA+Q8eHlgCH1eO+fRWf5OmQClQ=;
        b=A69du4DuTnP8xLWQnmyLetUMVacASw3W0gN3Ker2wS8ezd20mJhcRv1C/+Epvq18tB
         +5aUZU1u0YM+5mFoG7czyME0wuuW4uk4R6otBIxgNny73fht4MwRK6LriMgVcYg+lfRE
         7zDkqsHXktjAtd4VBoEvM6QhSJm9HjGruPW34fgEKHh6pBRWAraEHqgbO8ri6NwdteUv
         e1cBXUEZ2AtK4Jdckw6LcYeBJ5MUg40wjb11Cw3icBXM6Y1VycVpYGkyvMqYcvY7FbCn
         WfuxoRZCNYfhfcpBmGwt8rs0odmllKIlDPttlWsrbfkfQgikzwg96JnysNid/QZMZkPv
         z+Vw==
X-Gm-Message-State: AOAM533aP8uNVIKblDkVIHHiJi0C1yO36dAYzM2Mpvnm8Qcvgjs6hwhJ
        huYSrTLjIgzts+iM9GW/d6lNUcgucWYHWW66xd/afA==
X-Google-Smtp-Source: ABdhPJy4w7jgd/UAwb5pPY2xqkZRN3ELOqqLs6AJUHt05VUljtTZQfKhOa5aVXvbhgUsVDCOuYt1rMmZ2zibhre8Xok=
X-Received: by 2002:a6b:b38a:: with SMTP id c132mr17932385iof.75.1596053809764;
 Wed, 29 Jul 2020 13:16:49 -0700 (PDT)
MIME-Version: 1.0
References: <fdc7e57d-4fd6-4d49-22e6-b18003034ff5@gmail.com>
In-Reply-To: <fdc7e57d-4fd6-4d49-22e6-b18003034ff5@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 29 Jul 2020 13:16:38 -0700
Message-ID: <CALMp9eRyyO3d36j6YbcvLEuPLZpByYS8SOCpVithpfqCeKhDUg@mail.gmail.com>
Subject: Re: [PATCH] perf/x86/svm: Convert 'perf kvm stat report' output
 lowercase to uppercase
To:     Haiwei Li <lihaiwei.kernel@gmail.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, acme@redhat.com,
        "hpa@zytor.com" <hpa@zytor.com>, "bp@alien8.de" <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 28, 2020 at 11:24 PM Haiwei Li <lihaiwei.kernel@gmail.com> wrote:
>
> From: Haiwei Li <lihaiwei@tencent.com>
>
> The reason output of 'perf kvm stat report --event=vmexit' is uppercase
> on VMX and lowercase on SVM.
>
> To be consistent with VMX, convert lowercase to uppercase.
>
> Signed-off-by: Haiwei Li <lihaiwei@tencent.com>

Please don't do this. It breaks an existing ABI.
