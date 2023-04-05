Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 792226D75E1
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 09:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237177AbjDEHuD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 03:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237191AbjDEHt6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 03:49:58 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7857D10F1
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 00:49:55 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id ew6so138801018edb.7
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 00:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680680994;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q2eIUIgQam+Znm92t75ub3SSql/5kD/CSnGjaZOIeRE=;
        b=fYSAGAYGszSDI3IfoxS5+hqQ61D0CkgHx+iv+QieP86v0ELv6tk8/H/5Yd8mQ4iaUs
         6lnrgU1LQtli1U/uXBn2dQcN5SLwcYNUwUa5JcY6bXUfwliijx6422/+OqsWBhgCnloO
         uLx98Qh64cpVJHO5ssoJnNiDp/0f69qNC3wkVmFcQRPas52tNv0U41f/K/KXnx3v+/V5
         nZ8vgvyaW9wGZEDZBeLKkWUBtTllAZjP83gtbrRPlC2QuaprRGwKAIQMpDMv1i+al67M
         YucX+TlvRsRP1h2wLxDuD+sBZDkWS4c1JoaZ8/asS0rimOqdOzEKQQ9rQDbW0M+I8L6i
         XLYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680680994;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q2eIUIgQam+Znm92t75ub3SSql/5kD/CSnGjaZOIeRE=;
        b=iuJwBFAXts6TUwK2DjpxTR0J4ewljk5XZK0j0lnvWyoJPLoeAb779QWE84VaWtzsz4
         UWlXqYpreF4HnftCawh9XrPZVer/B818jeh+wXEYk8haTinEwvUUYGku5VaEdcWASFrd
         VjSPaWhrh0YJm6UExHhIeLnUJcskOE+HKw+fdyzu8mDWKB3zvS2Dfbzsu/bE6o6vv2DD
         KYgUr2a2X+Fp5nN+xncUBWMaa9DZCULrkETb/0yXZY04mbreumK8Le2BSsALebB2nAVH
         MYzM/nXeiLOQcWKVZFBhmixJIFrJFqCPXb473kHEkOUTcR3xkruWXjdEeqrIYo+acyY5
         JgYw==
X-Gm-Message-State: AAQBX9eLVZjEZhLn5o7DytPfYtUVO4p57cYnrD40EegGvOlroffmBcXu
        QwkibEugzpbvLjI+w3PLNpRfzTJCs3O/hNKvFZ4=
X-Google-Smtp-Source: AKy350Ym48Hai+74rZtku56r83ywHMKRDTPq7llHjIi24jO9CVd7s/Mrwr1BmU6tztJXUHylLV48BFAazgTMou/4HPg=
X-Received: by 2002:a17:906:b317:b0:932:777a:d34b with SMTP id
 n23-20020a170906b31700b00932777ad34bmr1133187ejz.14.1680680993609; Wed, 05
 Apr 2023 00:49:53 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7208:2202:b0:65:e547:3943 with HTTP; Wed, 5 Apr 2023
 00:49:53 -0700 (PDT)
Reply-To: tamimbinhamadalthani00@gmail.com
From:   Tamim Mohammed Taher <cisskhadidiatou890@gmail.com>
Date:   Wed, 5 Apr 2023 00:49:53 -0700
Message-ID: <CAAYY=dZQrD6vSkE6YvLjaTH=MJC+X5Jgs1UcnVXCprbGeUh1Mg@mail.gmail.com>
Subject: RE:Saudi Arabia-Inquiry about your products.!!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.9 required=5.0 tests=DEAR_SOMETHING,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:52a listed in]
        [list.dnswl.org]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [tamimbinhamadalthani00[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [cisskhadidiatou890[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [cisskhadidiatou890[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  1.7 DEAR_SOMETHING BODY: Contains 'Dear (something)'
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear Sir/Madam,



Can you supply your products to  the government of (Saudi Arabia). We
buy in larger quantity if your company can supply please reply with
your products detail for more information.

Looking forward to hearing from you.

Thanks and Regards

 Mr.Tamim Mohammed Taher

Email:tamimbinhamadalthani00@gmail.com
