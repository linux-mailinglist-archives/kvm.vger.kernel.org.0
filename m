Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28F995504DA
	for <lists+kvm@lfdr.de>; Sat, 18 Jun 2022 14:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235699AbiFRMsx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Jun 2022 08:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235510AbiFRMst (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Jun 2022 08:48:49 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2691175A8
        for <kvm@vger.kernel.org>; Sat, 18 Jun 2022 05:48:48 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id e4so7360148ljl.1
        for <kvm@vger.kernel.org>; Sat, 18 Jun 2022 05:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=Jh3M8LDovYWs/mBJiVJoI/DS8xun0EDDqspVSX/swmY=;
        b=WE7iSlwCign+xcZNqdcWgAOEqm+Pbt6+Xcl3u12RrAqjypfdUotCO5k8h1nhnJuTrD
         NArGb8XgzOyUdJDvd2l5KchDe6UAmUpNtAfQ7juBgQaue9ZJ96aHbomLW2lk3Y6ECnBM
         HotFBMQm+HG5JLPEb7yyOi/aNHeRL5aDGSIhOjUTzsm/oAm1WODzUUUoPFEUPVmI5mnc
         W/ZGtyrw2FBFGWdIHPLJJ0uZ9fWRPj3F5q3wH0fMbZYseKW1XdhBZrEsQ9gRC5xGFfPn
         hWIs4E2cgLmgM7Z+88e5eksumZXiTIPxfF0y5ZHYyvUlW1g7J4uTYQBc6ZZ4zsjuSaBx
         tBmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=Jh3M8LDovYWs/mBJiVJoI/DS8xun0EDDqspVSX/swmY=;
        b=mzT3JqlyIKJLNKcgwzntx6Ksu1Gz1RaD0Kx37XjBrYY6FwHNFWc7ZWchFjfZGgTr3z
         xHORJIO4o1UK6pWRRctcLBSgLeC+TZIZISKmtN+7d3pNtck3iTc1ndEMWLJfDFhuQURA
         O26Iy+jPOKbc5cize6aDKZ3C6DnXdC0Znyr3Ees3MNdHP6a1k1rrVZSd0e7LCwbe539E
         xuNxunc8RMfSymBbVv95zGABQj2jVF4ohdxriHrhYX3v4uuPFdvWEMIUYY1tdPF9qli0
         E24q8v42qSZqtrcghWIJUxQW7eo8To1k37Nz+t5NJnUK+gEM7kJr4GNbcyg89hghen5H
         +2Pg==
X-Gm-Message-State: AJIora8O2LEI2e+idtlFaJvgI1xbD05pmk2kVAzgbV2sUCtiIakrE/GS
        TuEtqCmOCMNvdmJoAN75eZzUc6qmxaIeOFEhXrU=
X-Google-Smtp-Source: AGRyM1vZFDiizfIBPYqc5ERP0tT0XdNd5CEUwtPfwpkoptWXP6mDjcDZ8chZw+75lYM0VbD2r/xxsAG26AGLTpY9dcw=
X-Received: by 2002:a2e:a807:0:b0:25a:673b:5ae8 with SMTP id
 l7-20020a2ea807000000b0025a673b5ae8mr77176ljq.68.1655556527393; Sat, 18 Jun
 2022 05:48:47 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6520:1741:b0:1d0:3d7b:46fe with HTTP; Sat, 18 Jun 2022
 05:48:46 -0700 (PDT)
Reply-To: josephkavin71@gmail.com
From:   Joseph Kavin <toudjirose46@gmail.com>
Date:   Sat, 18 Jun 2022 06:48:46 -0600
Message-ID: <CACudhEVDK2Rnai=qXKWTT4Fu4ptw65F9ugBwyMF8=UcH6FAgMQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.4 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi   are you available to  speak now
Thanks
