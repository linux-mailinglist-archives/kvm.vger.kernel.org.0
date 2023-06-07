Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB74472683E
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 20:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbjFGSQB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 14:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231415AbjFGSP6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 14:15:58 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B8F91FE6
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 11:15:28 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id e9e14a558f8ab-33b5dba8c6cso4659385ab.2
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 11:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686161677; x=1688753677;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u5iMSeOKpFSmRZGHk7AHtYahJMrc6/q+PHYUICyADXw=;
        b=YAlZ/+mozlG80V/t2BtfDtl+iFp+40Mi7LNkiZiZ6FbnFdcPJlRcQLWv2SZ4eQ8eU8
         4578xZybWU8uML4gjwp89xsLfU3C4ALPD0ZmovzjbzlCi38H4GfzbgJR9lcaRVe93fcR
         4T1kdBau/SZx+K94afUk1WqnNgyDpjYXUr+NbzDkZ0t8B1WecJwQb/tXMUzWZPcDUcvt
         Bs+79G97jt5pdDU/iNhVx5SivsGs/jCA1R4dUe13/bYwUl2u3YCbNJa9e/GzBW08Z47f
         h3RcHkjEEVcNULBdp1s6JGjiIDdlt42ko4IwyvaAym0k2WlpnPJKFO4viavnmZpxmbr/
         JAzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686161677; x=1688753677;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u5iMSeOKpFSmRZGHk7AHtYahJMrc6/q+PHYUICyADXw=;
        b=ey2CCmFGEjwByrHYwB+sNhkpEbEgXV2g0EwzEauseqjhlP26+0YS8l64Cep7gHKV91
         jWv43Es9FpvgHp8A2SRenqbjU9pOQDMWRZRnzO1k1iOwBBQcFBZiYbhZZGa5ZUvLc5EW
         DHqbiOQnSOP19RIHhPW0fNxuDH/Cf+n/iC69ix++r4ffTK0T1zM3G569eTnmz7YzbxSZ
         hIf/uJIAxX5yjNZjra4g/1bU0fIEKRiCGm78rvk2sNiRtaKvogbX+HvqKsZHSFhJFqCF
         MsGkf9MvNysbfZlR8s/eMO1Rb4LPZQeZZaEhAoRrQhkfcxZjsDK7dR3vjuEZ+n53vW2J
         qnWQ==
X-Gm-Message-State: AC+VfDzgtpDvQfkrmJtz5/PQi1U54ih3uzDJUrXMRRVkfjtLaY8XSpE9
        Ydi7s240xOz0Hv6UrxUqoMx5VUO9kkAZv/sQdpg=
X-Google-Smtp-Source: ACHHUZ6O0IM+kDh47Z0qfaejhYM3dW6HZQEgax2Yhuq1CRHKG0ydV1txYIzcA1tParE02p8+m2AFYYWuMWG8lL/rg18=
X-Received: by 2002:a05:6e02:810:b0:33d:67c8:aebe with SMTP id
 u16-20020a056e02081000b0033d67c8aebemr4789690ilm.31.1686161676978; Wed, 07
 Jun 2023 11:14:36 -0700 (PDT)
MIME-Version: 1.0
Sender: kimleemoon20@gmail.com
Received: by 2002:a92:c503:0:b0:335:7c2e:10df with HTTP; Wed, 7 Jun 2023
 11:14:36 -0700 (PDT)
From:   Aisha Algaddafi <algaddafiaisha247@gmail.com>
Date:   Wed, 7 Jun 2023 19:14:36 +0100
X-Google-Sender-Auth: W6RpFxSvbXMCoqyf85jLPUpoAcE
Message-ID: <CALPmVKL2w_0hEO9K=xbGP5Ehk9e0GQM8Jzo-NTw_TCHv_oNgvA@mail.gmail.com>
Subject: PLEASE I NEED YOUR HELP.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.2 required=5.0 tests=BAYES_60,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORM_FRAUD_5,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,
        MONEY_FORM_SHORT,MONEY_FRAUD_5,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,SUBJ_ALL_CAPS,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY,URG_BIZ,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I want to use this medium to open a mutual conversations  with you
seeking for your acceptance towards investing in your country under
your management as my partner,

My name is Aisha  Gaddaf and presently living in Oman, i am a Widow
and single Mother with three Children, the only biological Daughter of
late Libyan President (Late Colonel Muammar Gaddafi) and presently i
am under political asylum protection by the Omani Government.

I have funds worth " [ $7.500.000.00 US Dollars ] " [ $7.500.000.00 US
Dollars ] which I want to entrust to you for investment projects in
your country. If you are willing to handle this project on my behalf,
kindly reply urgent to enable me provide you more details to start the
transfer process, I shall appreciate your urgent response through my
private email address below:

algaddafiaisha247@gmail.com

You can know more through the BBC news links below:

http://www.bbc.com/news/world-africa-19966059


Thanks
Yours Truly
Aisha Gaddafi
