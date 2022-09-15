Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 206BB5B930F
	for <lists+kvm@lfdr.de>; Thu, 15 Sep 2022 05:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbiIOD2q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Sep 2022 23:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiIOD2l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Sep 2022 23:28:41 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F714C61A
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 20:28:38 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id gh9so39155106ejc.8
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 20:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date;
        bh=aDnRL1ZmQxOMFMNGZoJPqBH20uB7idv9vdFa8r24GwU=;
        b=b7UMAOiYFA3XPKWS1pOuso+8+d2lCGa5GGPLyxhKCOnpmXs12m0FJWpqqX4YE6q29C
         WCjnqRX9JYrYBNPJQrUYfXSUrCxvkFEsxT+QR8zASMwThcCaxkvRkeTsDZKGVpkoYuuF
         juimCVmJWWpbIWIHGQUMe2w+o9X6Gkpzx90ITGDpol2BzG6zKm7FSo46bjFy4Tzt23ec
         rnkKMusvPRGrP4oIQupGtUfU5ZsUpTM58a1kVPS4TiX0m4rXQNdDzKI7SIdLufuX2L/r
         MA7Y/237k8vrGihOrfmDwt6ixZNyFGbv2PlGKWEepvT1wNcYO+OXXpua6s6UFdLCeGcS
         5LiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=aDnRL1ZmQxOMFMNGZoJPqBH20uB7idv9vdFa8r24GwU=;
        b=NSpH6ksT02s8wo+qn+CSzepbzhOOLU29LxKJ7F6R5n00Zi9I9zlB4f/Q9PPqTmxgjs
         NKz8a/1uzAX+Mtv62sQcd4s12v8iMACbFfvZ2SC63ZAbTgFlpy3HuqlXTJMh450d8APK
         e0dxfiPO0wUJyrX/A7/+i8pB3CAnnO7RpXtRTsS1q/evCBIhoU3I7bkDqRV2lkAnIlrn
         TW2MkesE7A1c722lmi5T2Bj9rTy469fbVVcOCfMZH+6QyHyHlCTl1gIjwvqUl0qyVFef
         QhF9zI349i/XyOQDmA7KE4E1f6NbpZwvtGK3aZjYYDl4EW7ZBPs1NgtXLmZaODArn9hX
         WZbg==
X-Gm-Message-State: ACgBeo1IQocEx6N2mF2Bt/RUObWkDmXh2nJ14pbfd3HW1iLjAnw4rifL
        8NxJFfJc6OFJl7NeCsM7kiM2c9V2K9VHZkEH0Bo=
X-Google-Smtp-Source: AA6agR6BaL1u7vgR/+BWVC/gVEIT9o1iTF2gIhV8hICCFlfG9MyJyaYgmY5QO0ZyFTw1eV4LkAWWDtbZ4LtNlyY+gTE=
X-Received: by 2002:a17:907:75d4:b0:77a:fcb7:a2cc with SMTP id
 jl20-20020a17090775d400b0077afcb7a2ccmr17387083ejc.480.1663212517121; Wed, 14
 Sep 2022 20:28:37 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6f02:a053:b0:24:3aff:af78 with HTTP; Wed, 14 Sep 2022
 20:28:36 -0700 (PDT)
Reply-To: ninacoulibaly04@hotmail.com
From:   nina coulibaly <coulibalynina107@gmail.com>
Date:   Thu, 15 Sep 2022 03:28:36 +0000
Message-ID: <CA+4vKa=wX6kH7wWHm1kY5WFDmdqBoUMOryGju8aF_uJ8eyTAcA@mail.gmail.com>
Subject: from nina coulibaly
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:643 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5033]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [coulibalynina107[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [coulibalynina107[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [ninacoulibaly04[at]hotmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

-- 
Dear,

Please grant me the permission to share important discussion with you.
I am looking forward to hearing from you at your earliest convenience.

Best Regards.

Mrs. Nina Coulibaly
