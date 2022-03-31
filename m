Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37E594ED3F7
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 08:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbiCaGfY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 02:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiCaGfW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 02:35:22 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA363D64F8
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 23:33:34 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id e5so22532922pls.4
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 23:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to;
        bh=y/WwzOufdV8bFjC2XhKxeIddPBCZMNKZVHLfMOMvj6I=;
        b=qjDlL94i/udsj7Mh8HqjNqfR4u85OD70mA0L5h77qGlepAW9z9p5SDcToVibZp4zoe
         gyPsjIN56gdMHhZqqcXNisF86OqDJbq6zLYFiuYabt1VoGYmh4Oy8NcBntmRLGIAW+6P
         vaxT/gCOIdOFdKZV95nf9jeG6y5q56Ry358SMHRs3ibgTxulp+P9AFnjNRmFqCH39I+G
         3a/uteowVZnmSxowI/lw29g2Ov18e/tQ8ddtFDQkzVtWISfGVI1TS7zVYPq/gFqL96Zf
         /uRphEKSjYAuDUvwHfcnrzfdpIk+KUXKi1NBZh/d1iPNcIYQKaW0jwVhH1J+pHjBKf8w
         22Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to;
        bh=y/WwzOufdV8bFjC2XhKxeIddPBCZMNKZVHLfMOMvj6I=;
        b=6UfcXcwJoRE5WMlMfmX+XwbSUVAiqG0JUX+qWnmoJq4Mpb8SPm+tQeA0ksvKQKVTER
         aX62y+E2m4HfAL9aDqY7TKn+zmbf/P7aVjpVMmVfVk1IUD7qrXOXwRWiVJpuxpaAlcGF
         aWPLZb0QG36/jBP7U4VQvqQJ6K69xAUxGdj0cTw3OuXIgKVwRWqZ74CSycWfgniQtRop
         tBWc8qzWYdzvx4Qe0gqx0LHADhUhymhNkfy00aoiH4RGi+A+Z/zTQEm7aZqQY8QpYnBz
         YhnfTUfhmqQrZYa8UglENqCmzzXLe5qo/9whiYFk8FiDlzJXsSJIAdreBLoHf7/4M3Ef
         eXUg==
X-Gm-Message-State: AOAM533f84szKHxIYripSpoc0RZ0FrL8lF/1YiG7lqoKtrpI8QKWaHTL
        htxAKQHtnID+9UHArXzY+lSUoH4CbOucA7a7VMY=
X-Google-Smtp-Source: ABdhPJwhRvLCNm7W8rICV9465yZi7KooN2GNcNQk+M3h1KtqX4Xqd3Q3PA3k/4Z7myLyHZ8sBoiL4OcEZibQ4bA1P7Y=
X-Received: by 2002:a17:902:dac2:b0:154:5d6d:cd02 with SMTP id
 q2-20020a170902dac200b001545d6dcd02mr3880977plx.123.1648708414213; Wed, 30
 Mar 2022 23:33:34 -0700 (PDT)
MIME-Version: 1.0
Reply-To: drtracywilliams89@gmail.com
Sender: reverendsantos@gmail.com
Received: by 2002:a17:90b:4b02:0:0:0:0 with HTTP; Wed, 30 Mar 2022 23:33:33
 -0700 (PDT)
From:   "Dr. Tracy Williams" <tracy0wiliams@gmail.com>
Date:   Wed, 30 Mar 2022 23:33:33 -0700
X-Google-Sender-Auth: 1mavJr-6Y_HK_xiZjmvmQVBV43U
Message-ID: <CAA2s_tHg5TGAQ44NFCmSE+LeDMJivFNNDvnCV6K_57DVHTSAng@mail.gmail.com>
Subject: From Dr. Tracy Williams.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:641 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4773]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [reverendsantos[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [drtracywilliams89[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Dear,

how are you today,I hope you are doing great. It is my great pleasure
to contact you,I want to make a new and special friend,I hope you
don't mind. My name is Tracy Williams

from the United States, Am a french and English nationality. I will
give you pictures and more details about my self as soon as i hear
from you in my email account bellow,
Here is my email address; drtracywilliams89@gmail.com


Please send your reply to my PRIVATE  mail box.
Thanks,

Tracy Williams.
