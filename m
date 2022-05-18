Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1DA52C6ED
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 00:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbiERW5A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 18:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbiERW4Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 18:56:25 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A62665F76
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 15:55:50 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-2f83983782fso40097437b3.6
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 15:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=mZ3wqB4NmL7z6lpFr/h15h1rYqsZKafJnUpMVahbEPg=;
        b=p8fiWWMb4K6vAhdOe8VKZerkdUQMDVJgKLgE754bVp+3Cyncx4kDcAYcyOsZ4DUoCj
         vIOMTMDL5FdSFmxyNOrFzrv33nw2rGUgBlzbvWUCdiEWxKjBHEBpraXxppSGpbHn/y0p
         H3DJZRYjJxfhfra06szeDETu+83MDMsB0k98VAU76xyJlcQ2cUEU1VLAiNud/6lncGsP
         VQV+DMsQxM7qcHOonORm8BW+DpUxuvn3s3Ar8mju0JO8I+6PJnZWABk4ONbydxpbzfXi
         QF1QysMYOVS0xkmDO75FFZdOhEiyPsW4YIq9atIDpOVN+rFwIwJhyeuUczgSqspsyVzT
         ZvQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=mZ3wqB4NmL7z6lpFr/h15h1rYqsZKafJnUpMVahbEPg=;
        b=RismJ4YHUiEEzy0i2P553jKMsBajbXZDIkFF2m925v0h9ehZSiSPuIxfR5E8saXJ5j
         T8ZikAS5hqFqiN5sWUSEBxyh0b8iALz0I5gMiO8dsgmOn0JCFBBBz/vPwA36kEWtqXDq
         Id6njr+cQzRoq2jMy/ucPqcHcSl0q7El7w825EadYQ0LTwLQqdVCO3DtvQmk3NF8hZAg
         jeFRaJPVRnj1zEIWKm3nNxwcf5omHuwuopcAn2LWppWrbrKeRKmvYQZ0G+vqMKH+PKOo
         s0cn5OwNEWelxuHlMkhyreACHcNtBS5g435ivkT4m07wXJsNGfH7FLfcdKorm8nc8Kfj
         n48Q==
X-Gm-Message-State: AOAM5331+AZBEOYVmVSDB6cOlFC6yIobUaTwOho4JRiQeAoQZkA13vml
        FtVzFW9JIhKlkJiKzPJpMbNVrQB8mGBogZTkKgA=
X-Google-Smtp-Source: ABdhPJx47RRhjSewOHgyZp1a7bXlKOcpSvb3KBuAIYTKH4XfjBdTNGEBa5yqgTA6zdoxd/SSoA86DmWvDbVAOV521yo=
X-Received: by 2002:a0d:d906:0:b0:2ff:3e6f:4d7 with SMTP id
 b6-20020a0dd906000000b002ff3e6f04d7mr1778955ywe.174.1652914549876; Wed, 18
 May 2022 15:55:49 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7000:7143:0:0:0:0 with HTTP; Wed, 18 May 2022 15:55:49
 -0700 (PDT)
Reply-To: tonywenn@asia.com
From:   Tony Wen <weboutloock4@gmail.com>
Date:   Thu, 19 May 2022 06:55:49 +0800
Message-ID: <CAE2_YrBqD7uOA1O-bn5ZB63b4S1fEPu8ZD6GQWD1Q5jbupkpDw@mail.gmail.com>
Subject: engage
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:112a listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4864]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [weboutloock4[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [weboutloock4[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.4 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Can I engage your services?
