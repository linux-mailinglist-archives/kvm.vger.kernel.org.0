Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBBF5630A9
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 11:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbiGAJt2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 05:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233158AbiGAJt0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 05:49:26 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1876A76940
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 02:49:24 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-f2a4c51c45so2816851fac.9
        for <kvm@vger.kernel.org>; Fri, 01 Jul 2022 02:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=DMyolhHXpmu1+9rKonQ8Ub5Er3bhcnEayHaPyRlkSA4=;
        b=GBrFvYFYOVBzzpmDHs3IrrfJPWTh6RCiSsJBTWQSl2QmDgws/O5CzbbvaoYo7P/SJf
         cyhOGlDu6Sy/aJd1T9ENNALBTKHhubukyjTytEz5ksj1SfTpIDkxMeNNkK0i66J2J7aD
         T22Pj2T34mGGznldlkSe4GcLvzDzzbDCAUo7xC7XmHsgEQxx4Prha3Uyr4yPd9WzTZBj
         US+cZB51ElKLZPX1ckN42uJz3Y2Q8FOvCJ/Eq7TyFFGPJ6Pi6rl84Q2WgBKtR3UVOJtR
         jt03u3XwJDf3PfURRZlrovDUFv44xp0ZXH7T7lRQEM3b4E/TBU4sOFbPamIb3L9f9yf1
         kSlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=DMyolhHXpmu1+9rKonQ8Ub5Er3bhcnEayHaPyRlkSA4=;
        b=tLBYimMp8paEnAyaKNq0ukVEJ/lsLqXZWdo9rZEQL8pPXatbc0sh8brABwgwACLQLj
         BwoeZ9omTJYbjEikmheiJXm/keqjrPMxW8wLcWOktY9Gjj2uQQTQm76HpI7YEMnKHWd9
         NsZu+B8Q7l9pWcChYfAamJCMP3EzSJbCaW89XJaw0dTHr9w548INz1NcTTZbrOr1ZnGM
         5evj1xB/sxPwY5yu4nTUAibgJTay8+W4nd8ogzRtKWqlsPOny0VpbfyVuF1C52J+byTd
         E2QI0eSkPdhGv8ZicoCLN+EAb69bsNpVQpVPHDl478xOKV0rg9ac53MeycFgBY8nEPH1
         qTaQ==
X-Gm-Message-State: AJIora/FCxI+oB5lqlsbUDa+pnK0LSy0W+tj9b+2SmJh/veI+o3uSp22
        tIgtJQAyK+m8D8OV5Sa/+5npznl1V36vzymiibA=
X-Google-Smtp-Source: AGRyM1vUEnxfVBXnLthcFdYPBiJex2ydqSUkRs3JBYl50JOjTOlBaOXlFT8Lm5+/LueeNt5C1Zsv3fMm8ZXYb+a7VHM=
X-Received: by 2002:a05:6870:8195:b0:101:9342:bf1a with SMTP id
 k21-20020a056870819500b001019342bf1amr7805666oae.149.1656668963662; Fri, 01
 Jul 2022 02:49:23 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6839:f85:0:0:0:0 with HTTP; Fri, 1 Jul 2022 02:49:23
 -0700 (PDT)
Reply-To: fredrich.david.mail@gmail.com
From:   Mr Fredrich David <randywoods212@gmail.com>
Date:   Fri, 1 Jul 2022 09:49:23 +0000
Message-ID: <CAAAmqEZoJXvR7bNFTw7wgM9EcEBmT+Vx+5RsO3evURK6PFAN0Q@mail.gmail.com>
Subject: dcv3
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

-In risposta alle tue email, ti scrivo per informarti che i progetti
sono ora completati e sei stato approvato!
Cordiali saluti,
Signor Fredrich David
