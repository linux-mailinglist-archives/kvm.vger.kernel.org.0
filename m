Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC827BCD21
	for <lists+kvm@lfdr.de>; Sun,  8 Oct 2023 10:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344496AbjJHIA3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Oct 2023 04:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbjJHIA2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Oct 2023 04:00:28 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55682B9
        for <kvm@vger.kernel.org>; Sun,  8 Oct 2023 01:00:26 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id 2adb3069b0e04-50567477b29so4600824e87.3
        for <kvm@vger.kernel.org>; Sun, 08 Oct 2023 01:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696752024; x=1697356824; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2JxIk8v6+j45HjplK2bvQfVGZCGfurpRwYWShuptrI8=;
        b=FfksDZ0fUiFFAZmyloOU77BQ2ASIlBClKXc5zK9E78z6BOdt8lcaJH8yjsQtor5Joe
         irY9HAMyd8FHmX8psW++Fh/HY+6FUZOwoZCmBKsfNrB028Fbb98L2/otiL5+5sjasTgR
         bYErx9iI62bHrA0Dk7pel24RRvsTnQoSCWK+KZYZiqAXx3m+quqHONu9z6aJAzOCgHb/
         ibcPkthyn+i+TjsQKiOcUFgLuPAlVfwwVpMJqPpyz9wXfATQtIPmqAVsUmwgdj3qnI+0
         c07sg6MebxPxkUWN3t4jKIw3Ne7Jax3tt8P6Ry42+8iPlQ/w4wgzkzxCkUlZGwkZWv8k
         hNKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696752024; x=1697356824;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2JxIk8v6+j45HjplK2bvQfVGZCGfurpRwYWShuptrI8=;
        b=cj1zqyxG6fsmCUpewA/pCF34Namrkg/MRO5JcpgnLQ4rB2X2mdhS20jqNbA5xcR178
         iJ2/2qqEc/nZK8rRTx7NvGlF9adskDAhBE/f8Z0AfvXAVmpJ/PWQxmqUQHYUQlh410Sk
         E60NYRLbzcA/iSmWnhCo1pcW1pIKdvRclO2pzpfK3wrbxLXXe3Jf8DKJRd4gleUrbdRC
         bp8a2RyiqsAAQuju1BRZFq3Gdi/3SuoF/Dz5eM38hH6YSHSstEZt6nHug+IBL8BAoK1k
         qPGdAxSMHqF3UvRMeq2q9xYy6KIKeEdMibMnjL8x1TXHFJGhOUkZP3cuOxR2Lpsohhx2
         3M2w==
X-Gm-Message-State: AOJu0YwnDb1DTKpymK8K73npfliOJH9lH41vzfH7YbjHBpW1D6etLUHi
        KleNA4VmxZOMZjd9C8NupVw5jA6aecX5zdwYasE=
X-Google-Smtp-Source: AGHT+IH3DUmigsgTLUA4bAL/i8lWOUPLzXgTv845twG86jacd+i31feIx3AQ4bWQda1qoypOWYE9zHhefD9azRxf46U=
X-Received: by 2002:a05:6512:128a:b0:503:3278:3221 with SMTP id
 u10-20020a056512128a00b0050332783221mr13373265lfs.69.1696752024222; Sun, 08
 Oct 2023 01:00:24 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6022:5664:b0:47:8abd:96e6 with HTTP; Sun, 8 Oct 2023
 01:00:23 -0700 (PDT)
Reply-To: krp2014@live.fr
From:   "Mrs. Kish Patrick" <mrs.nolinamalook56@gmail.com>
Date:   Sun, 8 Oct 2023 08:00:23 +0000
Message-ID: <CAGL=rfE0FnxFhika+1zJOKOFKjL6uj+bOZ0z_rbB94LD1Y0ZDw@mail.gmail.com>
Subject: CONTACT
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        HK_NAME_FM_MR_MRS,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.0 RCVD_IN_DNSWL_BLOCKED RBL: ADMINISTRATOR NOTICE: The query to
        *      DNSWL was blocked.  See
        *      http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
        *      for more information.
        *      [2a00:1450:4864:20:0:0:0:131 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mrs.nolinamalook56[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [krp2014[at]live.fr]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [mrs.nolinamalook56[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  1.5 HK_NAME_FM_MR_MRS No description available.
        *  2.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

-- 
Dear Freind,

I have sent you two emails and you did not respond, I even sent
another message a few days ago with more details still no response
from you. Please are you still using this email address? I am VERY
SORRY if sincerely you did not receive those emails, I will resend it
now as soon as you confirm you never received them.

Regards,
Mrs. Kish Patrick
