Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71D655E8FA3
	for <lists+kvm@lfdr.de>; Sat, 24 Sep 2022 22:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233733AbiIXU0A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Sep 2022 16:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiIXUZ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Sep 2022 16:25:58 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C301C3B97A
        for <kvm@vger.kernel.org>; Sat, 24 Sep 2022 13:25:57 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id r34-20020a05683044a200b0065a12392fd7so2123613otv.3
        for <kvm@vger.kernel.org>; Sat, 24 Sep 2022 13:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date;
        bh=m7KtlTRQ/940R7kWNpP3Vz5Bs4+fmR2cZz2mXb6ruwc=;
        b=o/j6TYB0hLCyOCwHzpUw/Hx4WFeL4LjHBvDhaTRxy9nD5L9Yj5MY6N/S5xXVTz9Ca+
         qp/aCH97Mro/J3JLa5sAUX7LR3H0y5Acotuh0v1QpM9vpyAa0/9In5kBDrokKy3xmTG8
         szZSroRthPVEHP0X9LuZ3BLZaEqhwjL3w12FmEY8xgW4OBRutjtOaifcQdn4QIykPu1l
         JNC5uDB+dPiW4X3vdK8emHl5q/HgAlWHlpfhRrtrOxrMoh+d/83RsCd79+65336W20h+
         xFDm2i6ZIFdNiREg3eBOxB62f/4TmeTQjzPllYmkg3wFDnl1iQjmjeVerlqMqhYd6Hpu
         d1yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=m7KtlTRQ/940R7kWNpP3Vz5Bs4+fmR2cZz2mXb6ruwc=;
        b=JBhp1+j/cZaTV4wgO42DUxYKIvpXmfTLNFTrkxJ1SpMMv4r9nl3mqpHNw2E85L2MuA
         /+i5z+sLk2EJpPiYyYqLQh4KRoOkMOVQZux0UmMVgZBu6Rqdhg2YJSIIlWQnVz9Xt8uv
         +2ciUWwbWRTetamAs9TYVbZrLDI2bEWRRTioCWAuI5zTzjKXBceew3mpYtrxUyJvQVZc
         8QaVSv3rRTFdc/MaVtyd3IxkhHkBTz4Lnn1Nm32Z7qrDqzp7PVJZJFp2GERJNLzq7t0k
         dnI77aYdYklidxvTdzXzbcYXiBe1nPpSusnDvb0r6ETLQTISnuid03UXkdKhC2uJnYA1
         FRHw==
X-Gm-Message-State: ACrzQf3OD3MfmqPX1EvI1Q6GS87iOgj5BtGkfsFiMKWrKLB9AVG7/+Ji
        aEd9gT6/380w5XpR0IG9CTxgMN4/RyuLrXVXnts=
X-Google-Smtp-Source: AMsMyM6z51yFXoEklRool/IqRRMiGtlU3wa3BoMhOtLoHawAZv7ySC98Y2CXOkjdMuUTD+uAtdX7/C5OuhlEU68beUc=
X-Received: by 2002:a9d:7d81:0:b0:655:d419:54f1 with SMTP id
 j1-20020a9d7d81000000b00655d41954f1mr6734330otn.177.1664051156968; Sat, 24
 Sep 2022 13:25:56 -0700 (PDT)
MIME-Version: 1.0
Sender: anitaabdallae2017@gmail.com
Received: by 2002:a05:6820:1620:0:0:0:0 with HTTP; Sat, 24 Sep 2022 13:25:56
 -0700 (PDT)
From:   Monica Karim <monicakarima38@gmail.com>
Date:   Sat, 24 Sep 2022 21:25:56 +0100
X-Google-Sender-Auth: M8R9IfuH1a2dr9wfueHCFNfAvTw
Message-ID: <CALrj+s9ER815OAHKR8TATZJFKZPk15BNbVkG40UbsBtgKK9M4Q@mail.gmail.com>
Subject: Hi
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

How are you? I am Monica a Nurse from Netherlands .What about you?I
need to discuss very important thing with you.
