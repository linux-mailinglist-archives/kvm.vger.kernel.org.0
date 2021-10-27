Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18C243BF49
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 04:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237774AbhJ0CLC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 22:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237733AbhJ0CLC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Oct 2021 22:11:02 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95ABFC061745
        for <kvm@vger.kernel.org>; Tue, 26 Oct 2021 19:08:37 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id na16-20020a17090b4c1000b0019f5bb661f9so946617pjb.0
        for <kvm@vger.kernel.org>; Tue, 26 Oct 2021 19:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=+OhYyTKGmAf5Y61RBhMkXMlQv+hOjswu4u5NSWPSjMI=;
        b=WtFjl58Ja9SkTeqYe6PMiZeDsEybgFENQscnZ5OPWzN9F7+J8cQbxdC5nYflnzJvot
         iuRIGKyVv6maGnWkXhO211Ct+P9LLkuZJOm5NxDlrR3V98X+Cgy1qN6akUet8cG/H0vF
         GaiRmJvj0m3xRBGoexv5r5uzxGQUenarIwkqfNhjEuqEnDrlbUsx9OQsoe+SxoAkxoDX
         wn8caoBGb2Ug3n90oWxngqeoxzcy28Z24zTJrQA6+m1DUTHimyBKqYpEXa3I27qzedsP
         Ot5JKavrVOTwZkBPl0NpXBKvCgC+d6AwcHgGy/NQER6L4f5in1TMaRX7jqgFB+ZkrKR8
         SrWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=+OhYyTKGmAf5Y61RBhMkXMlQv+hOjswu4u5NSWPSjMI=;
        b=s4pMUJ5R4SMTVf+eN7CcXUl7E/EDNzpv6tKAjyYPvXKTu7XcoJ7ZuY1b8aDIgMJyRm
         fCZVJZyekacp+3UvZua4PROOhMIFTu6IvqZP/GSUxt5szNDklR/cSiTx3W9/dk+OXBFe
         xV0y4GFS0dlP2VFsPqzsYYIal1Q9rJJhiloyiwsPGr9/aDej2O2aJnYqZVVl4hncBkDl
         M3uEaD4+6SG/X8GTAs2UH6d6skDzRbJBjc4+2++tGCaVVr8u2cO7712Y5eAVJvbdkTOh
         5ybpjfa4Rw4xDQq45Hy97jtU9/5dtgYNf7uk5ld2+eh8p0n0EImo3Acy6Is6qbYcbC1k
         kraA==
X-Gm-Message-State: AOAM532M8d7z1C2S9yi7mKB5wM5hSWwS+Se2IT6OY3rT8Ivk3doccyZg
        a+d7/OgLiNwq2lN5F0by8DbnSBfVZ1hu0M/v3w8=
X-Google-Smtp-Source: ABdhPJzOEgSZh4weh2FswrAFbMDlJCF6NiLt96gK+5PvmVw5NEO+Ax8QEfEYs6cRfMm1FFJlX36EbjKXkPUlvaMrhag=
X-Received: by 2002:a17:903:3112:b0:141:5a79:ae41 with SMTP id
 w18-20020a170903311200b001415a79ae41mr5650901plc.56.1635300516847; Tue, 26
 Oct 2021 19:08:36 -0700 (PDT)
MIME-Version: 1.0
Sender: officedeskofgeneral0@gmail.com
Received: by 2002:a17:90b:4c11:0:0:0:0 with HTTP; Tue, 26 Oct 2021 19:08:36
 -0700 (PDT)
From:   "Mr. Mustafa Ali." <muafalia@gmail.com>
Date:   Wed, 27 Oct 2021 03:08:36 +0100
X-Google-Sender-Auth: mrPIqM9CZaqZ4TK8-5DxZqPIptI
Message-ID: <CAL=mczUMguKXuyD_Mo7oKMCyoA1wcYgF1QE-ZcqrAtS9e-_V1g@mail.gmail.com>
Subject: Greetings Dear Friend.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Friend,

This message might meet you in utmost surprise. However, It's just my
urgent need for a foreign partner that made me contact you for this
transaction. I assured you of honesty and reliability to champion this
business opportunity. I am a banker by profession in Turkey, and
currently holding the post of Auditor in Standard Chartered Bank.

I have the opportunity of transferring the leftover funds ($15 Million
Dollars) of one of my clients who died along with his entire family in
a crisis in Myanmar Asia. I am inviting you for a business deal where
this money can be shared between us if you agree to my business
proposal.

Further details of the transfer will be forwarded to you immediately
after I receive your return letter.

Best Regards,
Mr. Mustafa Ali.
mustafa.ali@rahroco.com
