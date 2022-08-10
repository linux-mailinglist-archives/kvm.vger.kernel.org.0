Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94E0858EC08
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 14:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbiHJMbb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 08:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiHJMba (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 08:31:30 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04CFE7331D
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 05:31:29 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id l22so17587413wrz.7
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 05:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :reply-to:mime-version:from:to:cc;
        bh=7CJ2H+mwqwi3qTSuDIQlMPG5AfOpvwm6RnkGrDapEZ4=;
        b=i90YqIvse2D5bTOiGV7DhZTmbuRpL9DlqIQLEmEkQzYVrzJ1ADIvyyLbtkrrnRh5s0
         kPV+6luLEaXgZOx34DFSiTuBmzbjAiHShXxwUOBQw22Zdh0xfSjLJfepZ/w7MKNDRsCK
         BrEvdzDOGF5l/nM4/jKe/PEo8LLp3PFet/0CPh2WXDXXKzv7q4QIsM3wFgQruumTiYGF
         f1bY+CCcbehOhAOtdxMn25cHgafA2OW13FFz1e41xjC8d/pCPjQadxdZt1rh+ccneFpb
         yZ77zEN8wwPuKjGaz97y286QRH/ghk9pJ26Fj1mHQtZVATl168OF1D7KigNMlJNQAxsA
         ojGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :reply-to:mime-version:x-gm-message-state:from:to:cc;
        bh=7CJ2H+mwqwi3qTSuDIQlMPG5AfOpvwm6RnkGrDapEZ4=;
        b=iUYyHCMkslTL5d1h8DmlYFFzn4Rqc3vhbFCjTMePaHIiE7X2+IREn5rJ9kcEsz1qI7
         ZVTGxtlkImd1qylyQBX+7p8jwCxdRs6FWPSgftpUTFEoA8ohp4maSa+f1gdLSwGhmThy
         cYsFrfaGA4+gcPYRT+gXnEVMY13xak5yWJeGlDX1bHHVWtqOaOvFiJe6IE/wesAfk9y2
         9jx/4wVnCsv1h6i15HEY4fFhDvjARDTB2y0aZbK1cutE60N6o3XgtYaOWbkw8Anlyqo9
         U+QIyxe7Rqn4sCo7ueIeChKOdIC//n68Y447iX7uuf2s+eyqVqrmr2k6CyIscbnIdiaL
         zAAw==
X-Gm-Message-State: ACgBeo35qutdrYrJuKHHcucAA0AuRoKBObzPNESGMxm/QNA5w+BlWth8
        E8h+Wu82NPlHHiim1rebMnTQUpjhVqNLahX+D7s=
X-Google-Smtp-Source: AA6agR4ggWLXElmKiov7/GRVu0jtnF60FCNt3YWdvfv7mPkhJTgikbUDFdbXo7P21T3/Z9PAXcaCpFslxhZpWVerpIA=
X-Received: by 2002:adf:fc08:0:b0:21e:d133:3500 with SMTP id
 i8-20020adffc08000000b0021ed1333500mr18044951wrr.353.1660134687551; Wed, 10
 Aug 2022 05:31:27 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sgtkaylama@gmail.com
Sender: senyodeh@gmail.com
Received: by 2002:a5d:530c:0:0:0:0:0 with HTTP; Wed, 10 Aug 2022 05:31:27
 -0700 (PDT)
From:   sgtkaylama <sgtkaylama@gmail.com>
Date:   Wed, 10 Aug 2022 12:31:27 +0000
X-Google-Sender-Auth: uegAOBSdnSKG7tbWgpHkCaTpens
Message-ID: <CAPsh9JRBMP=rzxi8QWfHDAXudxmioeTQZc=CjUvLiXMSJVyACA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_20,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

16nXnNeV150sINeU15DXnSDXp9eZ15HXnNeqINeQ16og16nXqteZINeU15TXldeT16LXldeqINeU
16fXldeT157XldeqINep15zXmT8g15HXkden16nXlCDXqteR15PXldenINeV16rXoteg15Qg15zX
mQ0K
