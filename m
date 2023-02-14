Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B05C269595A
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 07:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbjBNGnH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 01:43:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjBNGnF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 01:43:05 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E561CEB79
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 22:43:04 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id b5so16064183plz.5
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 22:43:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=content-whale.com; s=google;
        h=reply-to:date:from:to:subject:content-description
         :content-transfer-encoding:mime-version:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uGBjYP28D3okmr5Xt527kkwOXwKdyhGp//IAIPGp8tw=;
        b=jP3nBKd8mvT64FuXH3GKKQ7s6dSgjeshP1DMOSQUmd8Yvgf8Dme9m6Sp7lPLzVxho3
         fEiZYZO7LSTm9n7E2t8FT/2so9EuAXnHJRR1Z0Bql3EVQ/FcJ3k9/4IafyYgrhLRP0ou
         b3w9zNV6CyxakTpMd98UfrXvCBBwrV3P0jjBhyxGzV86p5SFq5fulbXWeT0FnkNlFx77
         QBas0Mtf0BtsWr2OjGcq4m9EAEDqEPij3eCpvYZZCe2d/s65fbAyz0LU5AXjgLoF6qtj
         iIV5V6go9U3Q/OMLouo483uDz2a5TVgG4/5EXwaDqKwD8EMM2vFVG4aRoQGnRdvYvipH
         m0Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=reply-to:date:from:to:subject:content-description
         :content-transfer-encoding:mime-version:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uGBjYP28D3okmr5Xt527kkwOXwKdyhGp//IAIPGp8tw=;
        b=4kmhvsvIoS7VqXcTt5gTz2zBO6lxEM05c8z647FMrB6VHzm7kYKfKwFJFavd3t9UjH
         4moqAegcg4snTXt4hT0+KtvMptqi/asLVmEt7MtIBcRdhxg6igj0jpVSn/c0RP2yHCJx
         nP5JtnnkLyMDEASmiZizKKSO4m+dmiSDUBFoqzuZ4V4/yMuO7EWnENlr5bcsk5qOb4kG
         R+efJ3bepYbthFhMsD0HKtKm4x5eLCsEZDa4RVV7sUVvOsUrSOu1H8ADKRN4n4eJXnYc
         wnNsrpV11JNdBvHy60ESbzjhQ3zCJs+lbmQGxFQHZ23+IkC0CZ9m786bsnBcG269OH8H
         /QgA==
X-Gm-Message-State: AO0yUKXYFvLlL0loZBZdOorbKteshhW6z8wk2DLNfzytVsYml4n0eEuo
        JibCEN4rEpX3vQM/c4dF0exv3w==
X-Google-Smtp-Source: AK7set+YuUmbqpqSI535aOcbhXZYEAvmw3CjA4R1POY2L77jMKhzrzO14EqJh/GT8Rz3G1/oYPI/LQ==
X-Received: by 2002:a17:902:dad2:b0:199:1f42:8bed with SMTP id q18-20020a170902dad200b001991f428bedmr1077611plx.12.1676356984284;
        Mon, 13 Feb 2023 22:43:04 -0800 (PST)
Received: from [192.168.8.100] ([203.144.79.69])
        by smtp.gmail.com with ESMTPSA id b5-20020a170902d88500b00196896d6d04sm9287686plz.258.2023.02.13.22.42.58
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Mon, 13 Feb 2023 22:43:03 -0800 (PST)
Message-ID: <63eb2d77.170a0220.7638e.117f@mx.google.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: From Heang S
To:     Recipients <editors@content-whale.com>
From:   "Sopath Heang" <editors@content-whale.com>
Date:   Tue, 14 Feb 2023 13:42:51 +0700
Reply-To: sopaheg@gmail.com
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DEAR_FRIEND,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_FORGED_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        T_SPF_PERMERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:644 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 T_SPF_PERMERROR SPF: test of record failed (permerror)
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  2.6 DEAR_FRIEND BODY: Dear Friend? That's not very dear!
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  2.1 FREEMAIL_FORGED_REPLYTO Freemail in Reply-To, but not From
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear Friend,

My name is Sopath Heang,a Banker,here in Asia.

A late investor/Business man of our bank died and left a worth substantial =
amount in our bank.

If you are interested and like to know more, kindly write to me,I will give=
 you more details.

Best Regards.
