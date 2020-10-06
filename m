Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 838F2285189
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 20:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbgJFSVn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 14:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbgJFSVn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Oct 2020 14:21:43 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E69C061755
        for <kvm@vger.kernel.org>; Tue,  6 Oct 2020 11:21:41 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id c6so1618273plr.9
        for <kvm@vger.kernel.org>; Tue, 06 Oct 2020 11:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qIaZQS3HbyTjv/g2etusfT9JyxHP7d3TupGt6jXqf4k=;
        b=Y6QQZn1wwnKJXhr96kGWtiLTpC3WX56lIkP63/ACCL8LQPC732fk7yBYbwq3mmM7EL
         0gvNtTlxOuD5RrOiPm1w9pkgrDySNEmGj0CNjk/nb60iau3+h8FSfssHxBCCZrszLgu3
         G8f0rpwcYlgFsQwXboBZavsE3wYr+5nEToe+eTentoSztN6QKzhfhNFgNXwzmOiaflfI
         6/Q78T0qnqbXD5pi0KhstmuSM3zu4sPhHbPvmX2qpUvLakN/Diy13lOS2CrXHA1LMN2u
         amkpD7Oulf0XF75NSKIOInJGA56fiVFOzz5K71BrKRYvGCykIot4y3q8Z/KNNvOfTRKt
         zzCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qIaZQS3HbyTjv/g2etusfT9JyxHP7d3TupGt6jXqf4k=;
        b=G5M8VegFVgj/kxgnDfnMZIVJg0leLZBUcL8P0UXcmViUqxeH2bqt/3fIIiqRFJwlap
         Quemfky3nbfjqJFw3gWFyh5tEE2tZjlryliOh/kaEeI+qbnYERFOLbfFF0F6hky/VxwZ
         Y3G5JmHP15fLejwfiHnkM4ONwTeCeOGZv6tC8bxXgPuB6dT4e8txocohdeIfVHNfRKXw
         J7x2IaXB1SEL3b2ad9LKVh/82UtuOwxkE86NidhpdKUsjuOAuuer+tIasQ1wxyfD8Hbq
         R8t62I431QRrHUhP2kozGIsfdrTGcRF4x6e/2rJSC6EBDQ4YAto94UNXVS3zfGFXWic2
         zyqA==
X-Gm-Message-State: AOAM530ndxzq0yU5JDUnbNZpcOgNfEfyCagM90Lelo29/drYRTacGG3J
        Qf3UF/B444W2l20R4zJd+DKUM6FwqYRwIuZDABk=
X-Google-Smtp-Source: ABdhPJyYTL6qaF1uzL8mYEsobTUFEL2o0oBnqlqTWbmnwWMhzXoORfy4bhVuPclvoC7G0TSFLNYCwy5p+jYMQYBq9mE=
X-Received: by 2002:a17:902:7687:b029:d2:8d1f:1079 with SMTP id
 m7-20020a1709027687b02900d28d1f1079mr4452269pll.2.1602008501199; Tue, 06 Oct
 2020 11:21:41 -0700 (PDT)
MIME-Version: 1.0
References: <874kndm1t3.fsf@secure.mitica> <20201005144615.GE5029@stefanha-x1.localdomain>
In-Reply-To: <20201005144615.GE5029@stefanha-x1.localdomain>
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Tue, 6 Oct 2020 19:21:29 +0100
Message-ID: <CAJSP0QVZcEQueXG1gjwuLszdUtXWi1tgB5muLL6QHJjNTOmyfQ@mail.gmail.com>
Subject: Re: KVM call for agenda for 2020-10-06
To:     Juan Quintela <quintela@redhat.com>
Cc:     kvm-devel <kvm@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>, John Snow <jsnow@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thank you everyone who joined the call. The meeting notes are below.

Stefan
---
*KVM Community Call - Tue Oct 6th
*Topic: QEMU CLI QAPI conversion

    * John Snow's summary of command-line options:
https://docs.google.com/spreadsheets/d/1OJvzDwLpo2XsGytNp9Pr-vYIrb0pWrFKBNP=
tOyH80ew/edit?usp=3Dsharing
    * What is the first milestone?
        * Is it QemuOpts for everything? Straight to QAPI? something else?
        * Markus: The goal is to represent the configuration interface
in QAPI types
            * Don't parse QemuOpts, go straight to QAPI
    * How do we distribute this work to multiple engineers?
        * Examples:
            * --blockdev API is used on the command-line
            * --display
            * qemu-storage-daemon command-line is largely QAPI-fied
    * Alex Bennee:
        * We should have a gold-standard reference with documentation
if we are to expect maintainers to convert their own flags
        * -> John Snow will work on this document
    * Do we have good examples of turning QemuOpts to QAPI?
        * 53 of our 93 CLI flags that take arguments are QemuOpts, so
this is a major component
        * Kevin: -monitor for the Qemu Storage Daemon, recently
    * John Snow: Final milestone might be an automated QAPI-based CLI
parser, but only once QAPI types have been defined

    * Does command-line order matter?
        * Two options: allow any order OR left-to-right ordering
        * Andrea Bolognani: Most users expect left-to-right ordering,
why allow any order?
        * Eduardo Habkost: Can we enforce left-to-right ordering or do
we need to follow the deprecation process?
        * Daniel Berrange: Solve compability by introducing new
binaries without the burden of backwards compability
            * Unclear whether we will reach consensus on this call
about this. Maybe raise it on qemu-devel. [stefanha]
            * Philippe: Easy command-line options (-drive) and
managent-friendly options (-blockdev) could be offered by different
binaries
                * Daniel Berrange: Focussing on one new binary is more
achievable

    * Board defaults, configuration file options
        * How to set properties on existing objects (e.g. board defaults)?
        * Andrea Bolognani: Perhaps represent the board defaults as a
list of ordered options, append user-provided options, and *only then*
create the object?
            * Currently the boards create QOM objects directly, they
don't involve QAPI
        * Stefan: How do QOM objects/properties fit into QAPI
CLI/configuration parsing?
            * QAPI objects are processed by functions that will create
QOM objects
        * Markus: -global is broken

    * Eduardo: Long-term goal to describe QOM properties in QAPI
        * Daniel Berrange: eliminate QOM boilerplate by describing
object properties in QAPI
        * Markus: It's hard to use QAPI because QOM properties are
dynamic and can change at runtime

    * Next steps
        * John Snow and Markus will work on reference documentation



Bluejeans Chat Log
    [ 9:02] Stefan Hajnoczi: https://etherpad.opendev.org/p/QEMUCLI
    [ 9:05] John Ferlan: @stefan - there are some people in a different roo=
m....
    [ 9:08] Daniel Berrange: if you're not talking please mute
    [ 9:24] Alex Benn=C3=A9e: I ran into this ordering stuff w.r.t
semihosting and chardevs so knowing how to properly order things in
the "new world" would be useful
    [ 9:33] Phil: YAML &anchor symbol is helpful to use a definition
from a previous layer
    [ 9:34] Mdasoh: It makes sense to have ordered options when you're
talking about putting objects within objects; at the same time it
doesn't make so much sense to order them when you're talking about
running them all through a BNF parser (flex+yacc?) for user-friendly
configuration. So of course there would be two layers, and you would
translate the unordered options into a set of encapsulating or ordered
options.
    [ 9:49] Andrea Bolognani: It Will Be Totally Different This Time=E2=84=
=A2
    [ 9:50] John Snow: ^ that's partly why I wanted to discuss this,
to set concrete goals and to be able to measure progress
    [ 9:51] Alex Benn=C3=A9e: I'm afraid I have to drop off for the school
run - look forward to reading the reference docs ;-)
    [ 9:51] John Snow: ^ ty Alex
    [10:00] Stefan Hajnoczi: I need to drop now. I'll send the meeting
notes to the mailing list. Bye!
    [10:00] Kevin: Same for me
    [10:00] John Snow: OK!
