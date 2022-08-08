Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECAC758CD04
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 19:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244173AbiHHRs3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 13:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244022AbiHHRsB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 13:48:01 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D0063B6
        for <kvm@vger.kernel.org>; Mon,  8 Aug 2022 10:47:48 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id t5so12235369edc.11
        for <kvm@vger.kernel.org>; Mon, 08 Aug 2022 10:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :reply-to:mime-version:from:to:cc;
        bh=TcA92jQhUmVL9NUdzNddBpPNztYcniP4mrRV38OuDxw=;
        b=On5UtQoPkiQI086zlK2ATDZ2C/qPbmf4WrLtcB+ZbDR6pXmdHaKN/8cTXHLZhgVRnn
         Jt3h03CFGmnJsXVaItXx7OZGeUmiEHrKdpjVNcryptPStixsnFJl44gBPBQFSdF7l+cr
         IrdHtrYIz56oiqyuLh2XEecZ2zf8hTgPU4GinS1a2Mr8fuU74I20QQg4boiHoxUi0gKM
         KbArVXBDO0cLmDHDNJcXYfP6gh1oISleAnhAzk42ghbbHicaa2OFPkltk10B+5XAqlx/
         7XH9sPOIK8PhEiAj1/YzXnskLw0uwd2p9ltq2wVXeBxVNXSvybBM++NNMXJ4/WRWxuwo
         iYfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :reply-to:mime-version:x-gm-message-state:from:to:cc;
        bh=TcA92jQhUmVL9NUdzNddBpPNztYcniP4mrRV38OuDxw=;
        b=iabxQ4Bvdxt3WWpjrJFfn5EdJAGTKcnDhp+bpI0iU4h8a24ErhLlZx5dR6z66BjOXq
         0gZLDxtacUMbMcXNo7cumlCtBgfrtw0qZoto8lq2R4HlcQAMHi7azFiJvjn6hO5OdvTQ
         7LUheZK6MMHkwukDVl/BhWhksRB8WQXNkn4IzFhPR4IgFA4W8rBh89X+0MisPHPNEHeG
         UPuMb44K987htQwTyOK5Stu6wz73KTlGrtXlX+KdEM1FbUrx2D3PwpFcA3zF4tdwB/ge
         VX98he2ElkSbAQVs3NBQ09zqhDqT0QOTDkH4xHBxZh8aktzYM4isBXdXBgkxka1Tb/G0
         rbGQ==
X-Gm-Message-State: ACgBeo1pKvtZsGXa2WOFcqQcpY8qwmV1SPrfS0C6QygHVGDJdhOwCRfI
        Hvia+ox9fq4KQDvPweq/88CFUcdQhf9HJQO/SWQ=
X-Google-Smtp-Source: AA6agR46lZaYhrsCTTVKGYJMk3clzkRoJBLA+nuJjtpBIRnfUddYKSy9PIPpX3+ZijwWc1JiyVyxz5wRaDaQBq+L14o=
X-Received: by 2002:a05:6402:35d5:b0:43d:a02f:cbfb with SMTP id
 z21-20020a05640235d500b0043da02fcbfbmr18037323edc.275.1659980866370; Mon, 08
 Aug 2022 10:47:46 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sgtkaylama@gmail.com
Sender: jj7303405@gmail.com
Received: by 2002:a05:6f02:126:b0:20:ecf3:415e with HTTP; Mon, 8 Aug 2022
 10:47:45 -0700 (PDT)
From:   sgtkaylama <sgtkaylama@gmail.com>
Date:   Mon, 8 Aug 2022 17:47:45 +0000
X-Google-Sender-Auth: ZwQgVIY_Z4tt6RjxL4zHFg3oEAk
Message-ID: <CABUCCYyd9yK1dfqR1DxfSHLPvJD8fLfPNA9C=OyF6w-5JjnJ5g@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

16nXnNeV150sINeU15DXnSDXp9eZ15HXnNeqINeQ16og16nXqteZINeU15TXldeT16LXldeqINeU
16fXldeT157XldeqINep15zXmT8NCg==
