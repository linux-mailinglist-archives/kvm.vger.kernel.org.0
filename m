Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2CA058B73D
	for <lists+kvm@lfdr.de>; Sat,  6 Aug 2022 19:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233881AbiHFROf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Aug 2022 13:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiHFROe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Aug 2022 13:14:34 -0400
X-Greylist: delayed 1096 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 06 Aug 2022 10:14:32 PDT
Received: from mail.chesp.com.br (mail.chesp.com.br [186.195.108.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36838F5A2;
        Sat,  6 Aug 2022 10:14:32 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.chesp.com.br (Postfix) with ESMTP id BEAD65229B9;
        Sat,  6 Aug 2022 13:54:29 -0300 (-03)
Received: from mail.chesp.com.br ([127.0.0.1])
        by localhost (mail.chesp.com.br [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id hJeasz2uXq4h; Sat,  6 Aug 2022 13:54:29 -0300 (-03)
Received: from localhost (localhost [127.0.0.1])
        by mail.chesp.com.br (Postfix) with ESMTP id BC00B5221A7;
        Sat,  6 Aug 2022 13:49:44 -0300 (-03)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.chesp.com.br BC00B5221A7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chesp.com.br;
        s=3C038ADA-7747-11E6-B1D8-1CDF186269DF; t=1659804586;
        bh=tvQl5Cv0ChD6vA4I/J397OSiPoTe3zGLvZkAUXlzids=;
        h=MIME-Version:To:From:Date:Message-Id;
        b=K/9Vjg6uBlMLkxOglZAmFR2neqe+TT2dmoowY+4glLEBY9+osCLtqey1Jx3Tlbm2l
         K4fDlV3VDUCv1DibsX6UYilmKSf/+TzdrImBbicFN044cHZ6UFFv6laDmbIUlZnA8I
         y6tX5hgPabVdgMbYQ6mmCksKJmoxmbTB4OaiP+64NcYz+x6pnlPGkuACgqD8ok0BZb
         ShIJ0aCqJ5GByQYp9mJYgi3xBvZ2pA2pzLLeyKb0QuWOtrZMvOvQyG99Nmhmt5TIh+
         pPi/chd+5h4sRQ3TsGVWDAMXRlnn8O4bRWGl6RKdNhcb2CybbU7aOiqgpNslzW/0Vs
         aFo6KiHcOVSnA==
X-Virus-Scanned: amavisd-new at chesp.com.br
Received: from mail.chesp.com.br ([127.0.0.1])
        by localhost (mail.chesp.com.br [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id wqV9UuDw0BDs; Sat,  6 Aug 2022 13:49:44 -0300 (-03)
Received: from [10.22.18.10] (unknown [154.21.20.55])
        by mail.chesp.com.br (Postfix) with ESMTPSA id A2C9C522065;
        Sat,  6 Aug 2022 13:48:47 -0300 (-03)
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Ress
To:     Recipients <Edson.pereira@chesp.com.br>
From:   "Smadar Barber" <Edson.pereira@chesp.com.br>
Date:   Sat, 06 Aug 2022 22:18:13 +0530
Reply-To: smadartsadike@gmail.com
Message-Id: <20220806164847.A2C9C522065@mail.chesp.com.br>
X-Spam-Status: Yes, score=6.0 required=5.0 tests=BAYES_99,BAYES_999,
        DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_REPLYTO,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: *  0.2 BAYES_999 BODY: Bayes spam probability is 99.9 to 100%
        *      [score: 1.0000]
        *  3.5 BAYES_99 BODY: Bayes spam probability is 99 to 100%
        *      [score: 1.0000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.1 DKIM_INVALID DKIM or DK signature exists, but is not valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.1 FREEMAIL_FORGED_REPLYTO Freemail in Reply-To, but not From
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

How are you doing today? I'm the Chief Executive Officer of the First Inter=
national Bank of Israel. I have a very lucrative deal to discuss with you.

I will await your response to proceed with the details.

Regards.
Smadar Barber-Tsadik
