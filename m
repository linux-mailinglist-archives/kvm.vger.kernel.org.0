Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC33864FC06
	for <lists+kvm@lfdr.de>; Sat, 17 Dec 2022 20:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbiLQTIq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Dec 2022 14:08:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbiLQTIX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Dec 2022 14:08:23 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6348D381
        for <kvm@vger.kernel.org>; Sat, 17 Dec 2022 11:04:22 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id x66so3811901pfx.3
        for <kvm@vger.kernel.org>; Sat, 17 Dec 2022 11:04:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UleXfybfkB/Pp7XCNYIxvDWfUpO/oLpvjkUbrsMk7bk=;
        b=Xqyb/07zaGru4SFKDg80uZaZlfpRRh3l/M9ySOf8bvZiaINFe6lPpGBNDE5nXYWlsh
         Dg2a/PlsWmsmLjf/1uOhh9L7EfI/uU5MYk5HVCYyeHPxPNPPR62QCuS+4hc/SofTnEgH
         6eP/aXE0afxBTbJR85Zdb0jrOt5XKk29gVvT7/zuFzSYamK/BkjLwp9GeaqmboAP93fm
         OJ9uvZT7tmINOe9xTRNW+xBOIRpipxG3d+mc8pS8eo89XpiWDaibL4YGW73J+23bglHc
         RyfJq8BKg/f7eLRcPwewCbK/Tk05sVCg6VIL3Wz0ULmF4blJDBgegmLLEZJ11Fbq4rDu
         ra6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UleXfybfkB/Pp7XCNYIxvDWfUpO/oLpvjkUbrsMk7bk=;
        b=WU7lJfA0EanU2T8OAYyHHRHwdI8riOjUL5n8yo21Hn4S09fO3X5MtMZ1nlKCWbzG4S
         g2idaYJUdPuR6ROL1iG8aabvcPfC6RBa1Z/PKxkfPEOvbztq3cy42HZcWxBQfcesfx/8
         u/3rVLAJV45nnAVbOlB3lfMOEz2P5aUHdZt5sDKVLjHZlrK2pVv6AMxcTzknLEkgy29n
         kwjf1PHmwD8sKWi32fXMkl9RQKNGXuTrpzEN1dDgVIERoP91kjpMHcJ3tuTOw2X1CU/o
         lu4S4QeeUd6EdKk4Ci8KaUSS5TfnyP6nVVzglXRFK0XnRTHgS6lcRBwESAOh6SbLSOq8
         gx8A==
X-Gm-Message-State: ANoB5pk7oC5ZjnQkC3UgHktXIkE6adRPBgJahA5v2R0p15SEJANUDvNd
        NTMG3Iv2rY4NRRm+Y0ZojTtBylk1oEaglcfoDg4=
X-Google-Smtp-Source: AA0mqf4yYVzCrrwkpacoSHJgBGhZuKZZCWm5X/gKcxR9oeQlwgZULqinFXkDGnNOQOG++PLfSBRqE8CiliBRxu1PsXs=
X-Received: by 2002:a65:55cd:0:b0:479:3911:ef0a with SMTP id
 k13-20020a6555cd000000b004793911ef0amr1493541pgs.603.1671303861947; Sat, 17
 Dec 2022 11:04:21 -0800 (PST)
MIME-Version: 1.0
Sender: akouviassogbagan@gmail.com
Received: by 2002:a05:6a11:449e:b0:365:1b63:e5d2 with HTTP; Sat, 17 Dec 2022
 11:04:21 -0800 (PST)
From:   John Kumor <jer.91244914@gmail.com>
Date:   Sat, 17 Dec 2022 19:04:21 +0000
X-Google-Sender-Auth: _mQvotZPZHVmEcp_x8ORLO03G-4
Message-ID: <CAG=NNVTCF4BtiWND+6ytU0Gxc_Ui50e+W09K-wyefB6mSC4jvQ@mail.gmail.com>
Subject: It's very urgent.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Greetings!!
Did you receive my previous email?
Regards,
John Kumor,
