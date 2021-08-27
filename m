Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0825B3F9ED6
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 20:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbhH0Sad (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 14:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbhH0Sac (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 14:30:32 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62C0AC061757
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 11:29:43 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id q11-20020a9d4b0b000000b0051acbdb2869so4070984otf.2
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 11:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to;
        bh=/OqM7mf0jzASPYq9pdfi/zierK2DVmMzbNUVbhxyVGg=;
        b=Dd4ohUNEnBK+deU8ATQTFsTVRdddPq+AMU8nomRo5hrH/IzZ32CoFct+Uz/SbvIvvE
         ZzMqLG191gs0KoJCQsEgZdJyDSK9s8S6HuqzpWR8GEiPrePV7CHIwYHfYLsHHVVbl/js
         kXW5QjimfyFh5Z0cbnDwlqAhOFvWMhJdaBPC4I63ZHSWNKLu7L5zHIWY3X2IohHt599O
         oJtR7mV5HSY3TID8a8OKYyE2KHhK/uh0A/hiImBT4Ve08e2P+GxJrWwA8KwlJ7XxGHnt
         5MAnRD4yfInIYUmEqcgOgrxjpfR+GucXsRMzPlUx7zuH2VNsPIk/Fti162ax0i++/LiJ
         8Fnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to;
        bh=/OqM7mf0jzASPYq9pdfi/zierK2DVmMzbNUVbhxyVGg=;
        b=o3LxiLRwRon+3APyjXUK7j5jfEFChXlIV8YMMmrBYoXZh25Bv19MvAce21olPQ+qR4
         +ZP/IvD4U+ciX5KArk8rJvhCMkrVE6wzqguutCtwoFKnLEhj4OEzui6o8CLyiA3WLVrL
         zqnH+VReXuKKl+KJLifHaWABeTpumH6dmOvgItIOhUcRSG9+6OqFWp9E3kOMVdTE4QWE
         HdV5v6dmUoxZWfimqZJG/WuXPSAbVLNKwLCb7Os89YSaP86LaMajpCfT+/y2DdtJmfMs
         0sxWDK4B3d8yX4zFUeUeVwJ0ZY7EpFgB2LnTC2Z9Y+FStF8hgdby7KXI4NhA6PT2Vc0h
         pdGQ==
X-Gm-Message-State: AOAM532MUC4ZHGuYj8kpVwOvwZIX+T9mOmd3KMFmyfTRYYbYNW9zQpBm
        5zogLh5Xqs1nzGOwum68/8x4FuHwijeJn59WcA==
X-Google-Smtp-Source: ABdhPJwDEKgV/hEx8VrnlDtk7JBRTDTMwKObJVjGsiiiYQZOuVXf4+XlvyPbrCBuU1chLfLIghB2JC8SH/qhEju1lfk=
X-Received: by 2002:a05:6830:2781:: with SMTP id x1mr9289301otu.334.1630088982317;
 Fri, 27 Aug 2021 11:29:42 -0700 (PDT)
MIME-Version: 1.0
Reply-To: drdavidgilbert2@gmail.com
Sender: generalmarkamilley18@gmail.com
Received: by 2002:a05:6839:178b:0:0:0:0 with HTTP; Fri, 27 Aug 2021 11:29:41
 -0700 (PDT)
From:   Dr David Gilbert <drdavidgilberts2@gmail.com>
Date:   Fri, 27 Aug 2021 11:29:41 -0700
X-Google-Sender-Auth: 4-R7KIEpvsKuIuOLKUBLn7JG0og
Message-ID: <CAHtAHnQOAUmxRec_yBQZEPi=vchAedW+k-gbyZkhRcfoeKYEMg@mail.gmail.com>
Subject: I NEED YOUR URGENT HELP.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I am Dr. David Gilbert, the director of the accounts & auditing
department at the ONLINE Banking Central Bank Of Burkina Faso
Ouagadougou-west Africa, (CBB) With due respect, I have decided to
contact you on a business transaction, I will like you to help me in
receiving of this fund into your Bank Account through online banking,
However; It's just my urgent need for foreign partner that made me to
contact you for this transaction, In my department I discovered an
abandoned sum of (US$8.5 Million dollars) in an account that belongs
to one of our foreign Customer (MR. PAUL LOUIS from Paris, France )
who died along time in 6th of December 2016 in car accident.

I am afraid if this money stays in our bank without claim for long
period of time, our government will step in because the Banking laws
here does not allow such huge amount of money to stay dormant for more
than (Six) 6 years, And you will receiving this money into your Bank
account within 10 or 14 banking days.

The Banking law and guideline here stipulates that if such money
remained unclaimed after 5 or 6 years and above, the money will be
transferred into the Bank treasury as unclaimed fund, I agree that 40%
of this money will be for you as foreign partner in respect to the
provision of a foreign account, and while 50%would be for me, then 10%
will map out for the expenses.

If you agree to my business proposal, further details of the transfer
will be forwarded to you as soon as I receive your return mail, Make
sure you keep this transaction as your top secret and make it
confidential till we receive the fund into your bank account that you
will provide to the Bank, Don't disclose it to anybody, because the
secrecy of this transaction is as well as the success of it.

I quickly inform you because the new system of payment policy has been
adopted and it will be very easy and short listed for payment via
Online Banking, So immediately I receive your update; I will direct
you on how to contact ONLINE Central Banking through their E-mail
address, where the funds will be approved by Central Bank of Burkina
Faso and transfer into your bank account through online Banking and
make assure you follow their online payment instruction to enable the
transaction goes successful.

Yours Sincerely,
Dr. David Gilbert.
Central Bank.
