Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6B20616ABF
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 18:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbiKBR3i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 13:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231524AbiKBR3b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 13:29:31 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F13B7C7
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 10:29:30 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 64so538790pgc.5
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 10:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZRmrlRPMYwszAcJulOTnZfSODdA48jDXLgPFI/7cr9Y=;
        b=b3djKC1F2QtErS9I7wkFP+5++0fIYME0sIKSH9DC02Ekw+wAY0mMrL6sjw0otxUyi6
         Cf9Vl3dJjJU2gz+dlrhrtaXbBxIucH+AbW5yu9C+zInQDUvooBakZg0xGsSnX+CHP34v
         dhKws/JH4SbSZ5z+V76skUWPbmcmNY/nX6dRzfjpb6wODrHKwxArKrE1YtbcEGyhGjVn
         oP+e+uRtRO6pEPa5BhanMqRem6udfRLJsTg5xZ9uVtQigBZt7YX0p68P3rfzZSX/mQnv
         MTbzrL4eI3+ea5g1kOvEc28wVLFUm5dcPW1B68XfmNdl2F7Gdu84Fa6I+HrP2JK3Of0+
         Sy3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZRmrlRPMYwszAcJulOTnZfSODdA48jDXLgPFI/7cr9Y=;
        b=COAupFUwFSF+Td9CsEkO6TyiqTs3uG8mQx6XDIUu9sGiX4SSiM1ws3VzVgZS8dgbyf
         hqT8sYCflVVQ3aaGAfm1/gwjsyF1vuF0VC+MY/9cnFa/Gxcfaoqzl3Kroip1VV8vQtC8
         0uLvVWudAYF2QTDW+UNgBN/vsPNVuNTtL03Iph5rlIP+us9e4vJNnJ0cCSbb+eXpkcX1
         XrQu0pZsHWsvVfaFNovWwjOHSKHVjkruarRp8XzcIHPvTgFlCe2q7IkkzgxPrW4xfKNM
         VEVuoXStWkvRCBaZjqUPr3SiHZ7y6mnZRZaqGw66YtZwTgtOHyFzPPphnH+pTXtkStGw
         U8QA==
X-Gm-Message-State: ACrzQf1gIn8eUji1FwZaDnx7n4/BY/st1g4N0ncOH8ADBnNHi+nklHQ5
        AoO2VYsfcfW6Kvyeaw0kSf7MmIDVbK9tSAsQ9jw=
X-Google-Smtp-Source: AMsMyM60Yyq82KDOr1vOx6MGhoffC3f/6Ha7he3hjqINgX7kfQq9xOe0TX8vUp2h8hveXxx8169m1M2GuXRZGJkIogA=
X-Received: by 2002:a05:6a00:1304:b0:555:6d3f:1223 with SMTP id
 j4-20020a056a00130400b005556d3f1223mr26386625pfu.60.1667410169841; Wed, 02
 Nov 2022 10:29:29 -0700 (PDT)
MIME-Version: 1.0
Sender: mrs.alicerobert@gmail.com
Received: by 2002:a17:902:d093:b0:186:c168:4d83 with HTTP; Wed, 2 Nov 2022
 10:29:29 -0700 (PDT)
From:   Aisha Gaddafi <aishagaddafi6604@gmail.com>
Date:   Wed, 2 Nov 2022 17:29:29 +0000
X-Google-Sender-Auth: PotLQ9BPCKspvA24xKsoqsf-lsU
Message-ID: <CAGnJkm9Ny=bAfMidSGCAsUhFe1B=Rp-cBpkeRS+QhNeE5_r2Gw@mail.gmail.com>
Subject: Investment proposal,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.6 required=5.0 tests=BAYES_80,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,LOTS_OF_MONEY,
        MILLION_HUNDRED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_MONEY,
        URG_BIZ autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:532 listed in]
        [list.dnswl.org]
        *  2.0 BAYES_80 BODY: Bayes spam probability is 80 to 95%
        *      [score: 0.8838]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mrs.alicerobert[at]gmail.com]
        *  0.0 MILLION_HUNDRED BODY: Million "One to Nine" Hundred
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.6 URG_BIZ Contains urgent matter
        *  3.2 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Dear.,

It=E2=80=99s my pleasure to  contact you through this media as i am in need
of your urgent assistance.  My names are Mrs. Ayesha  Muammar Al-Gaddafi
a single   Mother and a Widow with three Children. I am the only
biological Daughter of late Libyan President(Late Colonel Muammar
Al-Gaddafi ).

I have an investment funds worth Twenty Eight Million  Four Hundred
Thousand United State Dollar ($28.400.000.00) and i need an investment
Partner and because of the asylum status i will authorize you the
ownership of the funds, however,  I am interested in for the
investment project assistance in your country, may be from there, we
can build a business  relationship in the near future.

I am willing to negotiate business profit sharing ratio  with you base
on the future investment earning profits. If you are willing to handle
this project kindly reply  urgently to enable me provide more
information about the investment funds to you. Am waiting for your
urgent response.

Best Regards.
Ms.  Ayesha Al-Gaddafi.
