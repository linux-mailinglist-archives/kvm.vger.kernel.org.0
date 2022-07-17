Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7F25775AA
	for <lists+kvm@lfdr.de>; Sun, 17 Jul 2022 12:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233233AbiGQKOR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Jul 2022 06:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233231AbiGQKOE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 Jul 2022 06:14:04 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 980A7DFCB
        for <kvm@vger.kernel.org>; Sun, 17 Jul 2022 03:13:57 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id i8-20020a17090a4b8800b001ef8a65bfbdso10061531pjh.1
        for <kvm@vger.kernel.org>; Sun, 17 Jul 2022 03:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=7mYxe+Tk0t2uOTwa7+L8ZX58aZOXiBxNE8SIVnNuwrw=;
        b=kqMuSdCpwc8QoLuyP/pKvMJCLhDVLtaInPvrDLVxF3XLvCQd0MZ0GUE/smPdmETbjs
         JBs9hRxolHI/WediOcKd6U7cbv6am/0erwDQAojNdJyqrt5V/UO8ywj1LknUQCzTVtSL
         oerdE9PsmiDBKEG/UAy9T6kOewkZIH4sJFabvZkSn8Bl+tRmmnJe9gkC/PyAS5KLgbpI
         IhAyNLYaZMY6FJP0HDOd1B9vLdu9+cauFeEoJdrF/QByPAZuFQlhc58M4qz6f04mzqTC
         4QivoNfk7uGs4F1EfHS4ZRiVo2Oi59SMJGJezFzLqQlIKty5D3Vk3WYK1q+a/rqMP2nh
         7UvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=7mYxe+Tk0t2uOTwa7+L8ZX58aZOXiBxNE8SIVnNuwrw=;
        b=Kq6gbC7lBNQfA/t53+e5hlrCm5oy32V4xcI3ojJjTobyn2+orcAIVcum4PcxB7VK9z
         5lZLtJuGMq/0C4zWCOx2wMzdw56BIlXo4QYZVZceKKn2Z/RNBEKXKBcULadLu+vx2Wzi
         VipgBZzPDERNF5XJT6ylJ2dxIOHW0+2JaFJ1zLOQxs4EdlC1fWA2PhyY/pfOnurp5rOr
         wu+MIhh+tLLoQlnGiL1z3eCNtt/BCDVXPkrF9sSnA8NHEgkHi/HZRbYM6Dut8AoJIRAS
         avioNdMbBHync4jzWXcnSwev3DAWscHcLPqyd5rGBo7Nr+U6msBT9ZfOZ+DTolk0Vtx3
         VYgQ==
X-Gm-Message-State: AJIora9uY2ZRdGDjNHV2Oo7f3clHlwQ8WgxdOu0AE6pZ8sK9R36tqLjY
        4ddcBmeQy1/Wir9xownv3U7J4KA2Ir7B6dE7I7k=
X-Google-Smtp-Source: AGRyM1tmYN7nzKFlNe/oPpOnRdox1smxnhdLR2A2UWhVPzYrxA/BjVb38E5KKpQHQNBBdU3PbdjUEfdCMOUkmMejzuo=
X-Received: by 2002:a17:902:c947:b0:16c:5897:7e9a with SMTP id
 i7-20020a170902c94700b0016c58977e9amr22370985pla.70.1658052836512; Sun, 17
 Jul 2022 03:13:56 -0700 (PDT)
MIME-Version: 1.0
Sender: ndubuisiu000@gmail.com
Received: by 2002:a17:90b:1b01:0:0:0:0 with HTTP; Sun, 17 Jul 2022 03:13:56
 -0700 (PDT)
From:   Jessica Daniel <jessicadaniel7833@gmail.com>
Date:   Sun, 17 Jul 2022 10:13:56 +0000
X-Google-Sender-Auth: 7qsD9FVdhpgSCl3pB3Afr6oBt2o
Message-ID: <CAPxcwwgvL+Q6D2rAqiAFyQVqMqVJ_iaj9XKDmjveCju0tHv_uA@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_05,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

-- 
Hello sweetheart
???
