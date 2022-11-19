Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBF26308A1
	for <lists+kvm@lfdr.de>; Sat, 19 Nov 2022 02:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbiKSBpe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 20:45:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiKSBpF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 20:45:05 -0500
Received: from mail-vk1-xa33.google.com (mail-vk1-xa33.google.com [IPv6:2607:f8b0:4864:20::a33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89EB3C75BB
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 17:06:14 -0800 (PST)
Received: by mail-vk1-xa33.google.com with SMTP id f68so3220249vkc.8
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 17:06:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nf/cPq9d8ohAFT7XuHjdBUKX+6aG0Yaxe06dsk7wY4g=;
        b=AzqmezRqoTe/kIl3u/bvcMovHJJE9hR1hKmqmMttBp6fXO3YBcbd19CNAvLPZma0aV
         9yYKwPmQSvxFzHw8G9PjV664JhOr84kKoPjEYdSd2LfgRQxsoCi2OzkEOlci7O+4RCcu
         dScdYi6zgsbyfZxHK9gpCd7g3RxYIbnzEapduJ9wnbPXY8XNjWNtnUoaEuCu2PXDgot8
         kyNWNo9hgAqiV1B/MJ1C3W3AsZ+M9LXy8sw//3jUBRfPTkm1w3geY8mj0A1AmycTDnjW
         3LIbR8stGJZTgT4koqOld+0kSMBSyHG8n+NWtE/qy8GGl0FQaeJCSP6tRyrbzY6ljyaV
         +dzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nf/cPq9d8ohAFT7XuHjdBUKX+6aG0Yaxe06dsk7wY4g=;
        b=tbcV4S0incg4/zaI7fAL06EJsK1DkJJFlPo2SXU2QAg18l++ei1/cM00FNdmwaNr1/
         XkLcFg/zbq8NGgd726cZfs6MIQN+Mo4opHVd4wC98fwAjXwZD6EhefbgGw7dCqqjW24H
         OTtZdurvGK7G8L6AzbBt6iIYYzqkbcMMnoOwlCPOzYbL5G67ZZ903+JWe00/sdR1A8mJ
         UlHRd5L8eDEJBhBkCWgnWs4zw1YMkU+XPufTO8rTCwrA4BLjMdj813t3NnsU4+16VBzc
         I+IEdCF+Jir8KxB84VHBj4iW6RnQkR3jyy7d3m4UW9GmVYVxT7ifpN0g8dd2zOqGwQST
         ZYxg==
X-Gm-Message-State: ANoB5pk0Pqnv9/B0LoTO32Xt+6SY6yCxJASeilm3Mbaow7OqMJVjvbt5
        XAItpAR1nN8dVNs2TFJBhgQTPzhJVWD14o/3rYA=
X-Google-Smtp-Source: AA0mqf640TtU+0sdCbfG3Ct3ZeS24HXqZKzBTkop0EdR/4ChQjEKx62OeMNyMQlT9LwesSkplrtLcCcFIrcljSnGxBQ=
X-Received: by 2002:a05:6122:d87:b0:3b5:e89c:9351 with SMTP id
 bc7-20020a0561220d8700b003b5e89c9351mr5780964vkb.25.1668819973665; Fri, 18
 Nov 2022 17:06:13 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a59:dd04:0:b0:318:7b7:675 with HTTP; Fri, 18 Nov 2022
 17:06:13 -0800 (PST)
Reply-To: thajxoa@gmail.com
From:   Thaj Xoa <houseinemoustapha@gmail.com>
Date:   Sat, 19 Nov 2022 01:06:13 +0000
Message-ID: <CACb7pkA5JkK2wfGT5WBwUKwgzQ3NFJmc8zidFdvnu03_DthjVw@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

-- 
Hello,

You have an important message get back to me for more information.

Sincerely,

Mr Thaj Xoa
