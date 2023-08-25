Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 679D3788F7D
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 22:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbjHYUAi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 16:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbjHYUAH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 16:00:07 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7087269F
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 12:59:58 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-500913779f5so1994675e87.2
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 12:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=firstdatasolution.com; s=google; t=1692993597; x=1693598397;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2mJBOpmBBjW3YYepuO3umIyutC/2LEvzV7CTxk25B6M=;
        b=PDkYFclXM6oAlChLj2LV6jC54kEghM92g5LtDLSiLKKwMFNV8L8hPRjXvPqW9gz7XM
         8B4SwrRnSyE0Nz7viYZB4VfD4e1kpnSfcZjKw9LRZVoMdc8QeDciDhsLjLzyR2/Ih5J9
         Tjon+MqqZs1I/IMy/AL8jZ16JWIHnIlph+m8k+3qHB4/U9P7rbpeZn/h+f+IuXvdnQdy
         5KiIgmBFFHpidMjKUu1ouixdJgTu7GGkIj2G+rsrx/GlbA9Vy3e985l35XyPhIx0+MPO
         Pn8brLmcJAcvOSI216briOiC3DmcKwJnOICg52YAjevHaq7eqxl4UtDmIAmc9SBXexu1
         OCpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692993597; x=1693598397;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2mJBOpmBBjW3YYepuO3umIyutC/2LEvzV7CTxk25B6M=;
        b=UaM5KyVaSv5ZQZebAYB7t1EU1MOI3bkcp6yt0FmtFkvhauurdoRbBP/oxXG/LjCEfS
         lvpnPYD6WjeWMwPJUtyBaK4usKmRzTnDb7iekP6MonnrNmuLoXvL2MLOsfHgJcPLih5i
         QdZZgNre3AmP7tx4g/XCQyL5dgv2JvC6WMH8mFSVZ9EClle3eiZ+LvuU1JxChNMER9Bk
         +VNLIF3/RDcTpNfJYSVmoYQvNkzMYEXfYZUsA4EqM7VGWZhGBilF39ABTGVoQtmb5yfZ
         Pea8buET6lVURmLLnmutRCazjYOaOzBhI+s2sbtUKYT02W/hvp5c0mIrWlO3pwFIc72Q
         p8+g==
X-Gm-Message-State: AOJu0YyyQGvivVS9AQ3NXmP0+N9yY3vOb2Oo1yZ8YzuOMIAh4WuKphgR
        b5G71jTcr9hmres+ApMSPchoKGHgkdPDfRRGYBb93g==
X-Google-Smtp-Source: AGHT+IEbN4sOYodikWQ09secWzKZVyTz2YdCL0Rn4Ine+cGlG+qF15E2WEEfF3Bpki1/a0dpbsBb07aXBd2sARbro48=
X-Received: by 2002:a05:6512:31ca:b0:4fb:8eec:ce49 with SMTP id
 j10-20020a05651231ca00b004fb8eecce49mr18207613lfe.31.1692993597236; Fri, 25
 Aug 2023 12:59:57 -0700 (PDT)
MIME-Version: 1.0
From:   Sarah Jones <sarah@firstdatasolution.com>
Date:   Fri, 25 Aug 2023 14:59:44 -0500
Message-ID: <CAGrML=FaX1rN7Gweu6J5ic6RU43+KFA7Y=0B0ndSa_Ppy+CMmQ@mail.gmail.com>
Subject: RE: IT Security Professionals Database- 2023
To:     Sarah Jones <sarah@firstdatasolution.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=2.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FILL_THIS_FORM,
        FILL_THIS_FORM_LONG,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Would you be interested in acquiring IT Security Professionals
Data List 2023?

List Includes: Company Name, First Name, Last Name, Full Name, Contact
Job Title, Verified Email Address, Website URL, Mailing address, Phone
number, Industry and many more=E2=80=A6

Number of Contacts: - 130,768 Verified Contacts.
Cost: - $6,989

If you=E2=80=99re interested please let me know I will assist you with furt=
her details.

Kind Regards,
Sarah
Marketing Coordinator

To unsubscribe kindly reply with "Leave Out" in the subject line.
