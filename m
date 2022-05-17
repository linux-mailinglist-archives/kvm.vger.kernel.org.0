Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29D4A529E1F
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 11:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243315AbiEQJfI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 05:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233890AbiEQJfH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 05:35:07 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE8A03BF85
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 02:35:06 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id z126so14133731qkb.2
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 02:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=PLPmlGGL/gTvueqKEBdKiHKfa75D3rcCxU1z3taEYt8=;
        b=jqebeasaAh/puxs6wrntMo4IiE08jwbp+s19usrIJFnPFwIklwuX0j513WvBJwz6qp
         QSbrYRcARE+uuyDHtELRaGkI2l3aYyVQ9zECMOpi3QiElZVK+pY/OCgwdNjfbzbEIYXf
         URwD88jSQeZzD2XFeU05XdI5UoywQsDxNp9ev+CiU9VBOxcTYw9nVahr4gK7eaU1f5KU
         TgkkSx29Wq+Oqs27p1RMdffkJG0Nao68rcahKrTTeGsTzlSgeXxSX68m0omi0iPuvkG1
         eMKHIhzsJmb1VCehkaKW6Q3qiYQ0Q0gygGHlOIPLFQrRJQpjbF060lKhEPQMGNQCvk/i
         AM3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=PLPmlGGL/gTvueqKEBdKiHKfa75D3rcCxU1z3taEYt8=;
        b=gomlTkIffWPk+V7Mf8GUU7yE3VPaX0EDK8EwrIHuOWE7bYezMxHoSQ5YCoV5IriuYH
         +mZdOUYNmqNfnliHpxir35E3wnYNGTbS0HRd5XEA8pn1a8maj0xFN7KjB3OXhyJgK7uh
         HeDtdCzHQwLYWF1DhsoPcUDQXtACPe39PRX1ZTvNyit+tDtW/SBKWbJrEE7fD+PG0l19
         Y3IgzI/DMrPXHsq6f8uIs1CpBgmrWxny4AUq9pWESuu/TovNASTpKrhlC2oHGohdUTGR
         F6uxgGHUrKK8RW3UlijxGPNvXun+TNhKN7che/kMumJmckYK27pE1NQ4W6ZRrKb8hLGW
         7WWQ==
X-Gm-Message-State: AOAM531bLudAp5yUG3t3koocFahywo+sxXgYWYtdZNmpklMb3Ny4T88j
        5n+W84xYQj6S9GzKWhS4mMZ3GzNi8B0L2ILiFiQ=
X-Google-Smtp-Source: ABdhPJzKY09Z/T1GpoFUeIPqTJ9giLc5K4puU1AFn29gHEL8kQNlRmUCaxBr27abo8nMqEWyQJB9zFnnzTIAL0xiPbk=
X-Received: by 2002:a37:aa87:0:b0:6a0:6596:a367 with SMTP id
 t129-20020a37aa87000000b006a06596a367mr14979308qke.507.1652780105886; Tue, 17
 May 2022 02:35:05 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6214:20a9:0:0:0:0 with HTTP; Tue, 17 May 2022 02:35:05
 -0700 (PDT)
Reply-To: richardwilson19091@gmail.com
From:   Richard Wilson <mckayokey77@gmail.com>
Date:   Tue, 17 May 2022 09:35:05 +0000
Message-ID: <CALnAWWNOpmhMqSNCAN=_dB+KxYLEu_8WgTJ+PtDihYxOLNmk+A@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:72a listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5241]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mckayokey77[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [mckayokey77[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [richardwilson19091[at]gmail.com]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.4 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear,
I am contacting you to assist retrieve his huge deposit Mr. Alexander
left in the bank before its get confiscated by the bank. Get back to
me for more detail's

Barr. Richard Wilson
