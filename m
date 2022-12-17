Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6598564F913
	for <lists+kvm@lfdr.de>; Sat, 17 Dec 2022 14:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbiLQNZa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Dec 2022 08:25:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiLQNZ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Dec 2022 08:25:28 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E044217434
        for <kvm@vger.kernel.org>; Sat, 17 Dec 2022 05:25:27 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id jo4so3176610ejb.7
        for <kvm@vger.kernel.org>; Sat, 17 Dec 2022 05:25:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UleXfybfkB/Pp7XCNYIxvDWfUpO/oLpvjkUbrsMk7bk=;
        b=ol+zJurJI2kejfA9rs6h5TChQ3RV8KW4sTELfNK6bKMKq9fmFXVjOHQpoxbEDu4kUR
         ruag2V8e2bljpACn2x9aB51C0bXxNX9wVi9ufAM9SBp9pewDLCKGMkZRXAzHvOuqpGDN
         UJ1VWPGezkW1Eln4tixP644wv60oPbyqWqbnJvVlfBRW9YsdYvrA+bwTNgd/7Nu1Up8H
         UvIAyslaWSxxaTKgxrt0/zc400BKx1kCx5V35H/Pu/BOTsMI7rvvq6B504V5lgLMx3Jm
         VCPXQStB5G+ays8JdD5bmEz61Lp98+oSJb4hSqgTl6+UgcP8t+YGTGLpsSaxxYQq4+2t
         8dFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UleXfybfkB/Pp7XCNYIxvDWfUpO/oLpvjkUbrsMk7bk=;
        b=mJXeYbtWGQqYlnq8MC386tTnnGnPlSkajn412l9uCxSiWm4tky3FYNwQMWLeaQS4J/
         RV9/BqgxO8XnfUbeAfpRTztqpi2KUalMGoRJHAKqaFhw99e2GhcJl58YN3OHxUCd44y4
         mI/9NUYRaXpZddayGl6cpGUwdk5Uaid/EUv6SAek5i5LfMN/nHjdiX7ylSwaZ95hHuty
         QPcJNaI/i7rQ/SJtnHnxMOCEp+hhCGozaTzHOxdKxbNdLxxEa+k8F0DwjfywQ9ufm7Nf
         h8vfZg9Kz2Y1/jIj91SBnW5ODs4aQbEfyvIKvTQP8RiRoYCm8zKkNxe6a3v7VBg5jUwu
         tv5w==
X-Gm-Message-State: ANoB5pnqItR2Bhv81BSpp/DxLq881y+HsOB1aDzuTEW5/nCpOmF5LxFx
        IaIrbgOQJxWvmVxhtbkmh5TmWTtT5ThojdipMbRDWCwOuuU=
X-Google-Smtp-Source: AA0mqf5qVT3Hls5jT2+Qr2JEZ7yilKmPZJPx8Zj03AjXjZ++YIAbdiDiNY/1YKArwF8apiF6qA/IA+ZZppg4WYgdGj8=
X-Received: by 2002:a17:906:a40d:b0:7c0:fd17:5b68 with SMTP id
 l13-20020a170906a40d00b007c0fd175b68mr17160421ejz.347.1671283526375; Sat, 17
 Dec 2022 05:25:26 -0800 (PST)
MIME-Version: 1.0
Sender: noureniouroifa@gmail.com
Received: by 2002:a05:7412:8412:b0:8f:5ea9:b82c with HTTP; Sat, 17 Dec 2022
 05:25:25 -0800 (PST)
From:   John Kumor <mrwuso3@gmail.com>
Date:   Sat, 17 Dec 2022 13:25:25 +0000
X-Google-Sender-Auth: y80dF9lSqR-hnLBJiHhHddiAHi4
Message-ID: <CAGUuoFABC1PeY-S6XbftFS1co_6kEckDjVW0rMgU1qAruxHC5g@mail.gmail.com>
Subject: Kindly reply back.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
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
