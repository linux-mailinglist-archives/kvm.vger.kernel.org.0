Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53D11FB0F5
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 14:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfKMNA7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 08:00:59 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:41691 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbfKMNA7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 08:00:59 -0500
Received: by mail-lf1-f67.google.com with SMTP id j14so1871255lfb.8;
        Wed, 13 Nov 2019 05:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WnzZhtRreAIWxuwmCKHNMalZLOkw0H9aqmNi29JUxIc=;
        b=trfM+umqxP6c48jNkHj+tgFzSKfW+943fS2g1KK/wcRpLzMOs1lwTCLvi5B5+R+jC5
         Bd5ZW/VzJxPyR8/XUA3qw1P0eXFqG6SKP4dajZGBIg4VicAqzlrPD4LQanKmnnqmE7+x
         o1aEJ725jfEo+GF4Nau/ijvwUMEyo7zf6+zsBk6b8pT16RNuPEk3W6PmOfojLtYEMXuk
         e25oqhelgqHpsq4xv855gLRYFXlE/XNmA4/+UynSIr2gsAu3gIJ9MRxpLdPvPdn9f4LF
         CWWrz5oHZjG2Cz623RKCVR5bO9zT7DHTsbDCIVureHEir7tn1DMdDI530f/C1f0Cq8qm
         cXyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WnzZhtRreAIWxuwmCKHNMalZLOkw0H9aqmNi29JUxIc=;
        b=Ilgi+ul+An3kZIM1Oqpp8tpOE/UnuOFQWuXK6NWkWj53QlLfuHUrbJBRg6F/i0ZF9z
         y8d9z2EA5hbto2FCibbUrejtaAgswqVmXy2bB3AhwL2PRPppEK+XlYq3ZXwwgNMjsP3y
         s+qXI534nO6z7D5hTbiXpxg2NZ9iukuWTA3sux0dP99Q641BXLdjF6AM4T4PgUsQ1p1O
         yFIqiCCN6Fzhos0AOQFM/LlctNmy7itlJt0BAE86DnpG42u0XaiehowDanLjZQPjJD4p
         mwhnsI1K2jMwLqLCz7J6Lb4YTXPAPa+0Jo0tp6RVfl4zku9Xbjv3Q04qUD0qa2fqGv7m
         I8Zg==
X-Gm-Message-State: APjAAAWSD63Bo0NXvOVGHJlNu1TK/ZpbVJlZmTQMgfeXD41+OAiTEJ4w
        iCAOy02qNxlkw0OJ8edlrhKJZPIlCa5NjtSyFCg=
X-Google-Smtp-Source: APXvYqyErq57WtUbNlrDiVvkqeQ/abCgFor7vZSkkflK3ihYcPbUzRwFWIni0JRl791CfVAg0D0A5azHtp3sev9uaIQ=
X-Received: by 2002:a19:800a:: with SMTP id b10mr2740407lfd.15.1573650055635;
 Wed, 13 Nov 2019 05:00:55 -0800 (PST)
MIME-Version: 1.0
References: <1573593697-25061-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1573593697-25061-1-git-send-email-pbonzini@redhat.com>
From:   Jinpu Wang <jinpuwang@gmail.com>
Date:   Wed, 13 Nov 2019 14:00:44 +0100
Message-ID: <CAD9gYJ+9sDYh+8RkbaaRrMEbJ1EJrkMdJFCa6HVPUE4_FA13ag@mail.gmail.com>
Subject: Re: [FYI PATCH 0/7] Mitigation for CVE-2018-12207
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "KVM-ML (kvm@vger.kernel.org)" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> =E4=BA=8E2019=E5=B9=B411=E6=9C=8812=E6=
=97=A5=E5=91=A8=E4=BA=8C =E4=B8=8B=E5=8D=8810:23=E5=86=99=E9=81=93=EF=BC=9A
>
> CVE-2018-12207 is a microarchitectural implementation issue
> that could allow an unprivileged local attacker to cause system wide
> denial-of-service condition.
>
> Privileged software may change the page size (ex. 4KB, 2MB, 1GB) in the
> paging structures, without following such paging structure changes with
> invalidation of the TLB entries corresponding to the changed pages. In
> this case, the attacker could invoke instruction fetch, which will result
> in the processor hitting multiple TLB entries, reporting a machine check
> error exception, and ultimately hanging the system.
>
> The attached patches mitigate the vulnerability by making huge pages
> non-executable. The processor will not be able to execute an instruction
> residing in a large page (ie. 2MB, 1GB, etc.) without causing a trap into
> the host kernel/hypervisor; KVM will then break the large page into 4KB
> pages and gives executable permission to 4KB pages.
>
> Thanks to everyone that was involved in the development of these patches,
> especially Junaid Shahid, who provided the first version of the code,
> and Thomas Gleixner.
>
> Paolo
Hi Paolo, hi list,

Thanks for info, do we need qemu patch for full mitigation?
Debian mentioned:
https://linuxsecurity.com/advisories/debian/debian-dsa-4566-1-qemu-security=
-update-17-10-10
"
    A qemu update adding support for the PSCHANGE_MC_NO feature, which
    allows to disable iTLB Multihit mitigations in nested hypervisors
    will be provided via DSA 4566-1.

"
But It's not yet available  publicly.
About the performance hit, do you know any number? probably the answer
is workload dependent.

Regards,
Jack Wang
