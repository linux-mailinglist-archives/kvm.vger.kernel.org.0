Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A12A769317A
	for <lists+kvm@lfdr.de>; Sat, 11 Feb 2023 15:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjBKOZR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Feb 2023 09:25:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBKOZP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Feb 2023 09:25:15 -0500
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D183523C6C
        for <kvm@vger.kernel.org>; Sat, 11 Feb 2023 06:25:14 -0800 (PST)
Received: by mail-vs1-xe2f.google.com with SMTP id w17so4774920vsq.8
        for <kvm@vger.kernel.org>; Sat, 11 Feb 2023 06:25:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=IJaFVW31ac7M5ds+0RnQWlcTPgOOp2VbL86L+Gw/zbUCkNJLGBH6em9/5fF08evUfa
         9I8um8Lkx5f978wmeIqyHfzASP/TilmkfvuNPQRaETGhp+5l3hPIjfDDyIEwglfCaSDN
         bP5zeBg0JXni6hxobmCuc3ScnTHIkbO8Welmg4F0p6x8z4hORZ2dC3gQtvCLL37UjXzg
         GWcJxS4qQeZ7Fp+NsD3dSgG5TP3r058MY67j+AS6BN14yRsGOPk/bbK/u7oBkTmfkP7B
         vxNXoUviQougwgAfA8f5Lek0FN+6g9yB/AZYrcPRo9veLkTZbdGEJh/wp44i0+vSmA7t
         N6fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=sbqO8XtW5dE5NwGcW/DU0onGPrWvsEZnNNfR3QjOXOgl9tzEn84KPMhS4L5uyepyRv
         0lR8m3QVnMK5r1JN2+2ehHYWQogVRi/7CQFeiZiazfDxPgEJpP7mmvZZeUzsa8dZTVBY
         yOfeNyzDg2EjZGNBvfAk4u1IvjgXdlQ6ye26IEjSKlSyanL9o8Ed/3Igo3LktGPopeKd
         HlF4roi9NJiWJwLz1HjLOO3SOW5VwYPb1JyqllgjZ7sdX+nVC8VueHuwkl0KEGxVVKja
         1BfjDciHwfjvHrIx1WlPxPEpXX49/1yG+4+yU/6DHc0UF3n/X0NSeSQD3Uh5U/U4+ccV
         A7iw==
X-Gm-Message-State: AO0yUKXeFvZBuTkaHup83gQEz2Wx/fJVXfdaqScaT0FWq0lhNRMw0yr7
        3KOhJVqanbOdDFrXOEQO+zJ9Njzs+RQZxxHGlJY=
X-Google-Smtp-Source: AK7set8AuwvgX+dr+QoYSDq/aqxeWPdXZP8JvcSBA82xaoc4pi+dAc5U4NagOeQjC1/G88+TRyDNC1Cv0LV6pvNKKz4=
X-Received: by 2002:a05:6102:fa9:b0:3d0:ea5f:2ebe with SMTP id
 e41-20020a0561020fa900b003d0ea5f2ebemr4133012vsv.24.1676125513689; Sat, 11
 Feb 2023 06:25:13 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a59:c587:0:b0:399:45ad:34be with HTTP; Sat, 11 Feb 2023
 06:25:13 -0800 (PST)
Reply-To: dravasmith27@gmail.com
From:   Dr Ava Smith <khanadbul01@gmail.com>
Date:   Sat, 11 Feb 2023 06:25:13 -0800
Message-ID: <CALr78wV6THp=FxFuUu1L+NLf-SWVBdDQZh2b-eifX3+W_WntoQ@mail.gmail.com>
Subject: GREETINGS FROM DR AVA SMITH
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,UNDISC_FREEM
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:e2f listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5002]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [khanadbul01[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [dravasmith27[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [khanadbul01[at]gmail.com]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
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

-- 
Hello Dear,
how are you today?hope you are fine
My name is Dr Ava Smith ,Am an English and French nationalities.
I will give you pictures and more details about me as soon as i hear from you
Thanks
Ava
