Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B94CDBD136
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 20:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389911AbfIXSJW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 14:09:22 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:41276 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729903AbfIXSJW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 14:09:22 -0400
Received: by mail-io1-f65.google.com with SMTP id r26so6702562ioh.8
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 11:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2q6Y8DpWwY8bnQchRUI8y39I143SSadbFfWszYrC7e8=;
        b=ZwaGDsZ0JGHJWWcLoBpS5vthBAWitcSdlP4bA6U6xQU92hepplzwsH2wUBZLw1P2OA
         73qKyBJdN0dLj7xX8G+ZT+LbsF/bS4EWy2XixUYm4ri2lXbUnbnz4SCXef8ISXvuzusn
         Shal1mpPwZLbfTf9tN1wmEqVSK43bjUHXgQKKyu0oEQ7vaoSCZu++h3g1A4qcEK58QI+
         a1taLxNWlVe4n50LDV/Ex3WbyTr8v/50FQ570ukIKjOo0hul9HnxgaDj7nEa5CUutz86
         o4x9+tQVuF/OZ1PBYyeD3JAn4psIe4VstLXlKPP4QnORwLNcr4rjTxu2QXxKl2KjvTc6
         i6AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2q6Y8DpWwY8bnQchRUI8y39I143SSadbFfWszYrC7e8=;
        b=ZYLY8MGvqNWXJRPd9CAtRTKZmAaYPdaN2dHyEimp8ta9uxNBuszkf2QF3zemGOHJEB
         DXpNtmaSg8X6aZEBQk8CXhdo8CekNDnNAW1GxsgQxYm5IWT/3k5i+H8GVVG59xcPDrGR
         roX/iY2ywdqjYCJ4vT/O1M7EiCvo7JGDChOJhBjBla/6iCYVa0yd5eAwsZiKHasJHP44
         QQ8C64U10rDhBA3aW7psikT631yN55KdbS9ae7lm7ucNagC33jJ7wtV0XKjEjhjPjrYt
         1rYT4Ve+ovWVBhe0lm0HfSIJWmRVebn2yZYxSnthQUZilGYnXoJEtWfww+iOLZwZ7+n8
         BPPQ==
X-Gm-Message-State: APjAAAUw1da7u3kxltjAiKcHg4fU1Zc7Uk0GZKxyOd+VX+9Wc9K7/qRK
        dNsATx+ZJw2LhQDou29Vpaukrr28lcH/h+n00kmtow==
X-Google-Smtp-Source: APXvYqz++VswxkjQ6+lQs5Tfr2nSPg/w5WG5CFKpSob6/FszmCSrrUxBxqESGWJaucDZ9x4S1Vq1EnpDQsXBde2+DE8=
X-Received: by 2002:a02:ac82:: with SMTP id x2mr109445jan.18.1569348559879;
 Tue, 24 Sep 2019 11:09:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190919230225.37796-1-jmattson@google.com> <368a94f2-3614-a9ea-3f72-d53d36a81f68@oracle.com>
 <CALMp9eQh445HEfw0rbUaJQhb7TeFszQX1KXe8YY-18FyMd6+tA@mail.gmail.com> <30499036-99CD-4008-A6CA-130DBC273062@gmail.com>
In-Reply-To: <30499036-99CD-4008-A6CA-130DBC273062@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 24 Sep 2019 11:09:08 -0700
Message-ID: <CALMp9eTT4mhVtkBCqW_YFDiYSoPCsir6u0j+rqOeoFZui+enzg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] kvm-unit-test: x86: Add RDPRU test
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        kvm list <kvm@vger.kernel.org>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 24, 2019 at 10:29 AM Nadav Amit <nadav.amit@gmail.com> wrote:
>
> > On Sep 20, 2019, at 12:44 PM, Jim Mattson <jmattson@google.com> wrote:
> >
> > On Fri, Sep 20, 2019 at 12:36 PM Krish Sadhukhan
> > <krish.sadhukhan@oracle.com> wrote:
> >> On 9/19/19 4:02 PM, Jim Mattson wrote:
> >>> Ensure that support for RDPRU is not enumerated in the guest's CPUID
> >>> and that the RDPRU instruction raises #UD.
> >>
> >>
> >> The AMD spec says,
> >>
> >>         "When the CPL>0 with CR4.TSD=1, the RDPRUinstruction will
> >> generate a #UD fault."
> >>
> >> So we don't need to check the CR4.TSD value here ?
> >
> > KVM should set CPUID Fn8000_0008_EBX[RDPRU] to 0.
> >
> > However, I should modify the test so it passes (or skips) on hardware. :-)
>
> Thanks for making this exception. Just wondering: have you or anyone else
> used this functionality - of running tests on bare-metal?

I have not. However, if there is a simple way to add this testing to
our workflow, I would be happy to ask the team to do so before sending
submissions upstream.

> I ask because it would also save me the trouble of checking (occasionally)
> that nothing broke.
>
