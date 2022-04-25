Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C25850DD3B
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 11:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236709AbiDYJ5D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 05:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233478AbiDYJ5B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 05:57:01 -0400
Received: from mail-yw1-x1143.google.com (mail-yw1-x1143.google.com [IPv6:2607:f8b0:4864:20::1143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382A41AF1A
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 02:53:46 -0700 (PDT)
Received: by mail-yw1-x1143.google.com with SMTP id 00721157ae682-2ebf4b91212so142075217b3.8
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 02:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=s9IGPqOTuFEFxKMxMPq1P/MfyJrhGXNasZNiCUUGkGw=;
        b=LY7CvNjjcLyhSUaU2BvEYh7HW/cb05qbW3n1dwSYXBWmxhaREkQGXoZ7nua0AXIXgS
         nSqxTo554wjvNh3doyLlCM6MUMB1SB12UMZ3tj0v2RWNK7SN8i9cM8iMeSVEeRkeeQKn
         dA2IfVqWUgng+14OjQTCoMYB+CoSUxalc75sCHgHAIDZtKohu/mdQR2fyJEX9tiDkK9h
         G9BPJBb8zjw52EhCU7pxs/x5rxXfmeoNjFgMA76cSR+M+D0o2oqUvxglhDgJzmrxrgYa
         TqmWZu3H9vcrmrLmn4sJXj/sKvdaydE+GuZrfPuT03j2YacBut4JNbZ9AKjbvbGFFh6V
         jF2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=s9IGPqOTuFEFxKMxMPq1P/MfyJrhGXNasZNiCUUGkGw=;
        b=QBn8EKU4Ck8NBw4QNYO7qUNsT5IqSpORit+ADt+8S2fj37DymQ2w9NoTqw/F12s5qJ
         gCVfw8+OG6xrGPe8bpVzHNV1q9yh055noJw/P8kkmB+xuJwJaU33iyZu+5P7K/1gLfne
         wQD+MElvrkLgm3ELg+5jXLmz3l3q9foN9Xlf6NjggvErigx0Rni8c7HsVy0NxrergSwv
         qqBciZ+GeSia2oj+BUbRy9e6vy5U5oKhPFRIB/QbrePT+BjdxqxIAZKSTXEizAsApC8H
         5VYoNULDMjBsECVgA3gdCvcvHPFJiQ6S2HNFwq9nobb0wcqVMVmycyk/GBtWKz1hbBkO
         TLiQ==
X-Gm-Message-State: AOAM531D0UH/MWiHlX8jLycmb42juXTktx1UIQXBOsmcqxXiIqQnP3mn
        cV+UwNXco6Sx79OCRMZammTshM3pTdgtdldMrd8=
X-Google-Smtp-Source: ABdhPJwgPnNtAzwUn47E1NAsjxU7a9I262Kuju5mryRmNxlB2rsHLHubKv7mRfsE6vW1JIv9aSNp1nlXhoIOULCovA4=
X-Received: by 2002:a81:3d0:0:b0:2f4:e200:2ebd with SMTP id
 199-20020a8103d0000000b002f4e2002ebdmr15849394ywd.207.1650880425448; Mon, 25
 Apr 2022 02:53:45 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7000:bf06:0:0:0:0 with HTTP; Mon, 25 Apr 2022 02:53:45
 -0700 (PDT)
Reply-To: lawrencetansanco.y@gmail.com
From:   Lawrence Tansanco <lt01102203@gmail.com>
Date:   Mon, 25 Apr 2022 09:53:45 +0000
Message-ID: <CAHP1huHZFYrHRxtDhfnkS-hGqvQ7FFxcmF7mdFCsDe4NN6reYA@mail.gmail.com>
Subject: THANKS FOR YOUR RESPONSE AND GOD BLESS
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,SUBJ_ALL_CAPS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1143 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4726]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [lt01102203[at]gmail.com]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [lt01102203[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  3.6 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

.
I will like to disclose something very important to you,
get back for more details please.

Regards.
Mr Lawrence Tansanco Y.
