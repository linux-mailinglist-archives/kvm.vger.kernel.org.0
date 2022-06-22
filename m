Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF6EF5547C6
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 14:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354312AbiFVLDo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 07:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353857AbiFVLDm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 07:03:42 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D0239831
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 04:03:41 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id y10-20020a9d634a000000b006167f7ce0c5so1674438otk.0
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 04:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=Jh3M8LDovYWs/mBJiVJoI/DS8xun0EDDqspVSX/swmY=;
        b=XgqLpGIneaFWRWaUD+jkJysxVIxNg4E8B5AvaTiXg23qhtiWyVjaFIZ1BVAhFJAgxb
         tBG2AmiWljfArCLwCA4r6h5fsdI5S5YEAbNWEOAXK/QrIvmpaxOpviUbFrHkkJ677nWb
         GrqciI5HMXk9SNkSTfEu5PHvuj8lOGOPkzV+dLsHOlPc2q17VRYSiOsn5vghHwpYzVcb
         AodIEKiAx/SjszR4ab7QqmFHwhqZkozanxqt7b+MrIGqaLBG37SFcLTXpC+wMGQ/NqSS
         QuRdO0KEQtMeuKmQXFz6vHgF/f2ccvQ+f9BtfMSW36lHEDxhNaxbNTJ1rtKjzK3RFbOp
         nbBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=Jh3M8LDovYWs/mBJiVJoI/DS8xun0EDDqspVSX/swmY=;
        b=lDorsWgZ+IbB1XoJzLhhQPwrSWMPJwocSg+XS0Fr0+Jmstpq/6ra5kNJ/dGucVw2bo
         zWQ8gByU0yYurnPzIZf7I4bu3A/ftpAKvv1Nd9ZhsCo13wL+tRhdH41cv9WRStGmQyq7
         8tV5cLlNS8ooDcdqsT5h5e6bGLCBNdqKpf0tBb7n1g0zSzVOsWgtxUsxJJaiQ8tWwyFd
         dFYqlKb68hJsJqhioWtW1HWuaJ0XnosZLyWsBay46WGeQ2PQ4X73dx6GpqoNMN4Oa+/4
         yPSzu2SWiTiqZ93STwTQKqqbhc0c7iEDXwoqIE0MlIYZwKA5oRMkrGCZJXX6ypUHGL16
         k7uA==
X-Gm-Message-State: AJIora+jR8xXAAPGT7PplIGSzhC0pMF7706n6hdhI1MYqICUkRzN7zjL
        naTYB0L0TvlWK66S0Lf83IkbCG6XAGPHuwKPEHs=
X-Google-Smtp-Source: AGRyM1urkqMDrJM+QsnloLgLikbfVypGN8BLJXm/CfF6UetzotXtTQ4NJHsAsTWAPWrjYpGMAMPaUjA9t1uUgjIYes0=
X-Received: by 2002:a9d:1925:0:b0:60b:e717:80f7 with SMTP id
 j37-20020a9d1925000000b0060be71780f7mr1223920ota.145.1655895821146; Wed, 22
 Jun 2022 04:03:41 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:7347:0:0:0:0:0 with HTTP; Wed, 22 Jun 2022 04:03:40
 -0700 (PDT)
Reply-To: sj7209917@gmail.com
From:   Joseph smith <etienneawou@gmail.com>
Date:   Wed, 22 Jun 2022 04:03:40 -0700
Message-ID: <CAGLYB+MDT5M0tiM_YPyDyEfuPiD6-HLog6VNG_KZ3eCU1j=aQw@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi   are you available to  speak now
Thanks
