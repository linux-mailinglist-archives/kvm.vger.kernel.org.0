Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 395AA4C222C
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 04:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiBXDPE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 22:15:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiBXDPD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 22:15:03 -0500
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF48473A4
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 19:14:34 -0800 (PST)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-2d07ae0b1c4so10587127b3.11
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 19:14:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=Mjq4AeSfAukSYQXZoPINSnP8fNDRpRcn7A0p2UzvbkLHVMaj1L6OVPqZ/iO2QDMuFS
         u5Tdin4i90icxHV6KA0g2w5/mxTfV3JYzBv3XjdKVm0MmH+pS01CagfzryX6KBdlIeFA
         LtHWtlrZ2tI58xJdfFmjgTjNfypcqmy35QauUqZWkwb1nAkAzuCNr3YacTjQeB2tYkmB
         uGg4KgYfWGdH82HZ7asyzszlnxUnMCXZl9mOoL0pczO5qi/A5G78qSOK61jI5Oids/fL
         jbYP2f3Z2L/7jIuxrLlzlNRphgffCv5nWVPUx4YbPoPvMXALj/TcUsenlM4be11wC/G9
         ZM2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=n7Ksk8YY0TFVbmlwMUdxxwxvsfK176OkaAtU76W5gQrsMVSKnsKBJIN3I9LYMGfSam
         ucDJWN7TDJ/61I+WNji/znXyK5w1/javfy1XmBOMfWRc/F+OU7uaUessAXFMP/KlBCi2
         GD9UBpKRrLFko7rSvmKRlOEV3Bf8F9tsSkO0jOjE9cN1qTZZDqNSv1luAgUFmFa8HlB7
         de/2zk+V6fO8EoAV/CiMVD2JrpW/z6qwkp8QgoGMhD3rKXFSPnYyHMX+SW//wdr9dwil
         6igb0CDaFtWv3Z9o2mSmDwplFzE5DjnObqLBExx16fniFAtULOxbek97QvvuOagTxptd
         pqMw==
X-Gm-Message-State: AOAM530BGjK8Pm37bRtiEX9F0KbuwxHlR0NLnxvrO8F4NSCkD6ger44a
        qMmgM+q7LUOaKqRppBVlFmgEJPIpJ6K2K/oK0vE=
X-Google-Smtp-Source: ABdhPJxuoziEKCYvwpWIKGYnP2ddGGsrEfSJXLTct30ub5ZeK1tZ1+iUUstNoghNzi1JnnnrH4XWaBNLRZpVBlUcA5A=
X-Received: by 2002:a0d:eb50:0:b0:2d6:4010:ae65 with SMTP id
 u77-20020a0deb50000000b002d64010ae65mr586425ywe.15.1645672473343; Wed, 23 Feb
 2022 19:14:33 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7010:738a:b0:210:6fe6:62e1 with HTTP; Wed, 23 Feb 2022
 19:14:32 -0800 (PST)
Reply-To: dravasmith27@gmail.com
From:   Dr Ava Smith <gracebanneth@gmail.com>
Date:   Wed, 23 Feb 2022 19:14:32 -0800
Message-ID: <CABo=7A1jcDfXR+poZBYkqmRH-xD4+b3n5j1PjDaRM8abG2MoOQ@mail.gmail.com>
Subject: GREETINGS FROM DR AVA SMITH
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.5 required=5.0 tests=BAYES_05,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        SUBJ_ALL_CAPS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
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
