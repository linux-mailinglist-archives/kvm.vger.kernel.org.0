Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09B644EA3EA
	for <lists+kvm@lfdr.de>; Tue, 29 Mar 2022 02:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbiC1X5H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 19:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbiC1X5G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 19:57:06 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A9E583B0B
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 16:55:23 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id i7so3302013oie.7
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 16:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=CNNPGySxSq7bZ1La6vvay1kp1T7RaMnfdFjrr49KhAk=;
        b=OPWmxHBXrFgvGabY2GOHuxG9c+aQG16+AUQ7ckt+Y8GHTQTPAMprUXlshQuFEL5XBW
         FKuNn9o6PngXfrFU704VlQKA8G5TKd6VpWKcZzviUjEKh0QslIOGxGpnJ3iWptAN3cet
         ZyhVT+XkRs7hqYvepLSmMI24mHrM8GbiysN2WCQFID41Ix2a5y3AikSTXC+3N42hVBU4
         d3dsJkAhSkrEPQq+rKl76jL95PjxNetgj1faqqFmmbIuP5/XN9/bJRwNhkw5sVXAGrZl
         5hyQR6w2A+l2zacuU2iAlRLwWroz4uecBlUN7yFrryzJBDEUV72JqZp/KfCfoFUbb3YD
         fevA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=CNNPGySxSq7bZ1La6vvay1kp1T7RaMnfdFjrr49KhAk=;
        b=obZESshBJ6CdUbuaVSMqdWVHzprlZ8dcYbBIA+N72pNAzWVZPtSK5kYrwQecN5dLRT
         Mk7UONc2m63Ywyve3YJV3Pr4hrpng4FJFbcNayRf7T3TBSwS6bQeYS9VYMxSaDvuMiLj
         0fUgidqo8vohUZXf0htBQf9FB+3Qa96XimPXg+FqDHAVx+Sr4chhJ/Vhw0/pw7TxUZV9
         QtnDXxdzOYB6Br9HYe4YTH8YhBdljwv4sW6RPj3g+NEZCAJhR+dZ7EUNchyxMXzNKrCj
         i2c/4vCFukUcY4sNX1y+cyJBIosh+jJPKVYLaQOiPJP0Zku/FIJYRsW+Jlhf45VlOW8G
         B0qw==
X-Gm-Message-State: AOAM533jVMcFxi99oNPCyk8ZXkW0fp11laqYy+L5paQqaPhLYFif0g+a
        5AiXk79GEgugPHDgwE4Y9xk4LuFQkd6hoeEczbo=
X-Google-Smtp-Source: ABdhPJwKAaLe9mXJ3bRTJDB3vM+iqkGaCqvOJGmnPpvI3ecKXYXu5wRh7Bv2f/UNnjy8Gt7BLlf7I2zmMsoYj1PBNq4=
X-Received: by 2002:a05:6808:e8b:b0:2d9:d744:1eee with SMTP id
 k11-20020a0568080e8b00b002d9d7441eeemr809444oil.129.1648511722942; Mon, 28
 Mar 2022 16:55:22 -0700 (PDT)
MIME-Version: 1.0
Sender: mrslila88haber@gmail.com
Received: by 2002:a4a:e08f:0:0:0:0:0 with HTTP; Mon, 28 Mar 2022 16:55:22
 -0700 (PDT)
From:   "Dr. Nance Terry Lee" <nance173terry@gmail.com>
Date:   Mon, 28 Mar 2022 23:55:22 +0000
X-Google-Sender-Auth: HWLTq-QoVGfPHm9MMm4ApaEQKF0
Message-ID: <CAODWenaCOBHLc-a6MXtK4gWs+Djn2bKC6UPe6UXPN61iB5ZUng@mail.gmail.com>
Subject: Hello My Dear Friend
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_SCAM,
        LOTS_OF_MONEY,MONEY_FRAUD_5,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:243 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mrslila88haber[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.8 HK_SCAM No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  3.4 UNDISC_MONEY Undisclosed recipients + money/fraud signs
        *  2.7 MONEY_FRAUD_5 Lots of money and many fraud phrases
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello My Dear Friend,

I am Dr. Nance Terry Lee, the United Nations Representative Washington
-DC - USA.
I hereby inform you that your UN pending compensation funds the sum of
$4.2million has been approved to be released to you through Diplomatic
Courier Service.

In the light of the above, you are advised to send your full receiving
information as below:

1. Your full name
2. Full receiving address
3. Your mobile number
4. Nearest airport

Upon the receipt of the above information, I will proceed with the
delivery process of your compensation funds to your door step through
our special agent, if you have any questions, don't hesitate to ask
me.

Kindly revert back to this office immediately.

Thanks.
Dr. Nance Terry Lee.
United Nations Representative
Washington-DC USA.
Tel: +1-703-9877 5463
Fax: +1-703-9268 5422
