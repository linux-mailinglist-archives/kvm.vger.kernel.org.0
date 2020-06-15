Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1BA1F92C2
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 11:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729251AbgFOJII (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 05:08:08 -0400
Received: from sonic304-56.consmr.mail.bf2.yahoo.com ([74.6.128.31]:36229 "EHLO
        sonic304-56.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728953AbgFOJIH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Jun 2020 05:08:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1592212086; bh=NajTNMrfMLb6UXcjRhYpYerQX8PtVBLz0oFgaMINSWY=; h=Date:From:Reply-To:Subject:References:From:Subject; b=fJwHrABtjVer10c5B7UIB6m2/JKOgeznMU1v29ABl8wS3QU6WDbRMl0Cm4YiyqqvHapGNHDS7FadxhetbgDwZBsbjCKNBWL2aLNWgTF8IwiHQMWiKPqBohVKttR5NqTbbIsM9G8YxXCeLROzihNh3P/MCCMTMHM3lG30nyCPQuB5Ji83QB8BZleY7zToqZwV/98D/Z582qpWRy7Cxxgf6hwK7LSlfgRx1y5b2ciwk/S6uOnGSBNxXbIRXmQf/BVL85n4fn0U1AS3CHXa+zJLDQ3l2MGcldrbjpTBVvG2QXF4/zuq/vsk4HCtPrXnXT23oXyDkIdOdp3l8+KK16LL7w==
X-YMail-OSG: mOksHJYVM1nLYKD.HqFcgYc3shNTGSaThlWgsl6qtdgx7_Fl56VVMcUvobnNd_w
 Gdjsxe8XgYv6YtOFKcRqhP3Gdmzt4uvHiu7hLZQpSYaVHLLuwQhjBAZpGUixBXKGp2oxpmmrUcsW
 CpTMlhohBdTWRoosow3rm9npfS7kx1nDCFh53eoQHyy7Jv82x7TfZ_eokDhgTEJvf3ICEEPAx.XV
 MsLiw1h65EkcnVpkJ5JwvbR4bhmQtqVIoHI7m3ObR7jBLjmxfZkDBIRE0AJcYriMpJc_6M4gSlOj
 3sgGed8IXw5nYK1XUv59lI2CbrnIAedZyA2TMc4zsAHdhZK7e3eU5Njr6vdYmxjr08daSUykcuQt
 HKqIvTc099E4s90bcmEP3gNB4js8N4CcNsuD4UbzdoS3HuUAngfPWypWA6WOof34HF9tlJCjrFqu
 nskTzo77E_c9FEZK8zZ48EjPb0QcdcscCyBlAL3MaYVqL96DrKOewrORwdmyTB9rXfN8bKQbfUc_
 QMH4.EbMS4EYxwqGYq8U5VBhuRIuG0_ZPfkLdo_NVzPKYWrmBX4hdMUHQWUenN090ozYWiuK5ecT
 GIutzFqTF4oKTgpVqOgNfgdapK2OCrDONV75pCrd26x.Z5cNq_7UiEfsQQ3NRN_EXttb3RAxqZgH
 ZIPscGLx4iS_w017bpUhfT29raRKYiorHQTH9sSHDTxhwxIjp1ynTkSZtf9NMhe35fHUbRpoSArd
 6MT3OJI6ZHGe78TywggjnjegSLlCiybw6RLu3S4AnIWgbKP0JGLs4y69TIQ0z8AXtwvQfe3D.Dcd
 lgYi7jS6jCdxVSkfYSUyTzh5kQw7aGd9Iitpujygl5_9jpHk_2qtT5WsHy5tRm_Xg4Bm5RaeU3WD
 SlulgWcMqZLxG6qq6BMEWz6flbs8mMuubCzqE.kDhjZd_09YruwWsa.nvspvqDVHW5dUj5o.uEGY
 ypAYcKn2TZSDioe4_YoWwtys47QmQqqnPDQYpamhk0LpkwiH1Bz9u32ot5HDHDYZyQIl71X3npil
 n18k3TskidSGk2N5iCJ6SQOceMK1m9TAgd1FXI8cGF71_GvK_5sehRp10dJP7BevN.LvMHJKg7K7
 1NDDIqi3wcG_VER1sMRB0MpFSzhO06rqXhKUnqTDSUNtyj5lLaZ.ceVaB7_x2cqDZ_aAdAycJwio
 Af0D.580ciaUiT.vlx8cbRyWDBiQkI0RXpgWoshskAygLL0wwi1p5EtsSXFfmZKya0CSHCakMOKj
 ke4UDYQaX4aGdI61ESVroc0nkmsMMZZW43w1QbTR0cHRfIuJ.H.Lo3M9nKg5pic6m0YPh4WcawsL
 bE00-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.bf2.yahoo.com with HTTP; Mon, 15 Jun 2020 09:08:06 +0000
Date:   Mon, 15 Jun 2020 09:08:03 +0000 (UTC)
From:   Ms Lisa Hugh <lisa.hugh111@gmail.com>
Reply-To: ms.lisahugh000@gmail.com
Message-ID: <1444476700.620133.1592212083863@mail.yahoo.com>
Subject: BUSINESS FROM(Ms Lisa hugh).
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1444476700.620133.1592212083863.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16119 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:77.0) Gecko/20100101 Firefox/77.0
To:     unlisted-recipients:; (no To-header on input)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Dear Friend,

I am Ms Lisa hugh, work with the department of Audit and accounting manager here in the Bank(B.O.A).

Please i need your assistance for the transferring of thIs fund to your bank account for both of us benefit for life time investment, amount (US$4.5M DOLLARS).

I have every inquiry details to make the bank believe you and release the fund in within 5 banking working days with your full co-operation with me for success.

Note/ 50% for you why 50% for me after success of the transfer to your bank account.

Below information is what i need from you so will can be reaching each other

1)Full name ...
2)Private telephone number...
3)Age...
4)Nationality...
5)Occupation ...


Thanks.

Ms Lisa hugh.
