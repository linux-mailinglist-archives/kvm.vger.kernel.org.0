Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71E3A538580
	for <lists+kvm@lfdr.de>; Mon, 30 May 2022 17:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240655AbiE3Pxf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 May 2022 11:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240121AbiE3PxG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 May 2022 11:53:06 -0400
Received: from mail-vk1-xa33.google.com (mail-vk1-xa33.google.com [IPv6:2607:f8b0:4864:20::a33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BFBA488B7
        for <kvm@vger.kernel.org>; Mon, 30 May 2022 08:28:07 -0700 (PDT)
Received: by mail-vk1-xa33.google.com with SMTP id n135so5050377vkn.7
        for <kvm@vger.kernel.org>; Mon, 30 May 2022 08:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=XJqXgw0Qi4Ge6Q57wB4GlvotoYnhUuSq68y9152a6AE=;
        b=HG9jjzwsem6I8HITcCm+mxozluHX2cl0ot3OPL4X08aG6nPfTvo4ID8FNgGvy3p/sz
         F4Q9RQW2LgxQueJyCF4y1hi5Lrv9OBvtFfB2trSoxkNlco3QHxKf6fjEcSAbFFBz1wXG
         gef8GyWSvkDURM1MC+BW41Z0/h+S3EltX4N+FjEY7YkqJBpqAdwkVIJ0ww0/92Ve5HBG
         oLVf3sG989rZL4QFP2yauDFFgD6wDhlRtqtPHHdN6vlQpNt2/HRbWdJ9wra1LG7cXlMc
         PH6eE3JIyPZrcijQZL8D2Gix8m3IIylksbdvHV5V7Uei8Qqb3U9eE4cpPI4W8ZnZA4Uc
         askw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=XJqXgw0Qi4Ge6Q57wB4GlvotoYnhUuSq68y9152a6AE=;
        b=I7UgFSC123MQn7Zubwxn95RBgW+QHlZ8uH16BMGYDakbZDcImI54gH0yQKwNadeA4P
         b5xJIndLJ3cmAOBjoPPJ9QrsVwEgTeJv0KfRgFHj5TF0NBeEBgIKzvHkvVCQ1ijAOPEY
         y0FmLL58ZSzDTV49gpnzQEiNXFKCwwWGYhZ2UhFdnNBaxlwkCyrAMRSl9S4TxTi7VpB/
         02jhcNkcFLvzgP0c+vuUtsXTOTQboOKd6s7S2RRci5Ud2a7Em9wSan4ZS0Oh0yqZcINU
         xLi2RLbphTEIG5X9wiwwbUIVZ8tKPlkVOdl68DOS9825UAxNblkAnYUflGlrnku+TXl0
         7GfA==
X-Gm-Message-State: AOAM53387F+cEuY+5VF68LKffpr9mYrIY/vBKBxQEACAMzu4zav7ftHa
        p6f0RK36m5jF51RmC9Jv4qTlyDKEVsTQtekWXGQ=
X-Google-Smtp-Source: ABdhPJyktVWQ+e7TIlwCmbQpUcB9YOW3/bjYQMNb99AKpKuB2nLjGJ/ZbYVDHJ2BFt8M5vQJiOTWTkDbP8KyAQgesBY=
X-Received: by 2002:a05:6122:17a5:b0:357:239e:7b9e with SMTP id
 o37-20020a05612217a500b00357239e7b9emr20700812vkf.18.1653924486373; Mon, 30
 May 2022 08:28:06 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a59:c94c:0:b0:2a8:7408:9cd2 with HTTP; Mon, 30 May 2022
 08:28:05 -0700 (PDT)
Reply-To: barristerbenjamin221@gmail.com
From:   Attorney Amadou <djatodes@gmail.com>
Date:   Mon, 30 May 2022 08:28:05 -0700
Message-ID: <CAN_5zZhxobp0-xqM=cjOod9td4NPcf4M4TpTQyO_m8w=WshCkg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: Yes, score=5.8 required=5.0 tests=BAYES_80,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:a33 listed in]
        [list.dnswl.org]
        *  2.0 BAYES_80 BODY: Bayes spam probability is 80 to 95%
        *      [score: 0.8528]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [djatodes[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [barristerbenjamin221[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGVsbG8gZGVhciBmcmllbmQuDQoNClBsZWFzZSBJIHdpbGwgbG92ZSB0byBkaXNjdXNzIHNvbWV0
aGluZyB2ZXJ5IGltcG9ydGFudCB3aXRoIHlvdSwgSQ0Kd2lsbCBhcHByZWNpYXRlIGl0IGlmIHlv
dSBncmFudCBtZSBhdWRpZW5jZS4NCg0KU2luY2VyZWx5Lg0KQmFycmlzdGVyIEFtYWRvdSBCZW5q
YW1pbiBFc3EuDQouLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4NCuimquaEm+OB
quOCi+WPi+S6uuOAgeOBk+OCk+OBq+OBoeOBr+OAgg0KDQrnp4Hjga/jgYLjgarjgZ/jgajpnZ7l
uLjjgavph43opoHjgarjgZPjgajjgavjgaTjgYTjgaboqbHjgZflkIjjgYbjga7jgYzlpKflpb3j
gY3jgafjgZnjgIHjgYLjgarjgZ/jgYznp4HjgavogbTooYbjgpLkuI7jgYjjgabjgY/jgozjgozj
gbDnp4Hjga/jgZ3jgozjgpLmhJ/orJ3jgZfjgb7jgZnjgIINCg0K5b+D44GL44KJ44CCDQrjg5Dj
g6rjgrnjgr/jg7zjgqLjg57jg4njgqXjg5njg7Pjgrjjg6Pjg5/jg7NFc3HjgIINCg==
