Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3AE1DF601
	for <lists+kvm@lfdr.de>; Sat, 23 May 2020 10:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387498AbgEWIUW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 May 2020 04:20:22 -0400
Received: from sonic305-1.consmr.mail.bf2.yahoo.com ([74.6.133.40]:43434 "EHLO
        sonic305-1.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387471AbgEWIUV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 23 May 2020 04:20:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1590222020; bh=0kmsqXm9K+DyM/96L3DJNmWOe4qYy8f9mpn5lMuhelM=; h=Date:From:Reply-To:Subject:References:From:Subject; b=adc9omJJvak4rJeuKAd/rumUfBEcJTp2UoasSTkMpnn3kWJafSxCvDliqxR+X6Z36tf+HfZEEWuks0Uh75HxqbGxOp4cFPgqYOZJPfCfXeZJbHuacMqd3ypOuSlS9QvcKwKNof/XypGg0adys0TkJje2tDWstJJhhyFjnbtnx8ln1DYVAFF24t3rNefpiEy9BEO7dZmPVxEfwOnxT4kwD1qg/YLn1re9zQLJcvgJ6urBf3ROEoSt+BYeLAsxSa2eWmQHGntfxMhCWmliYpajW3mbQpiByA4Inv7MyQZRBf7gmpNnfgvI6Qacd+8u8eX/ck1l3vM3NLXf9VV4XkNp2A==
X-YMail-OSG: 5HXfBkgVM1lddSPXBjMiVqtZJEPUQXWGEPPmBJPtf7vMvvNcGLmCTMBBSwrW454
 jgA0pb0n4jIrD1uFidcohXuKh9DYS7smcTkrmRpKziZckD2f0YPsytNy8XRCa.4QOyg5sW2sgI67
 RhJjqUL8PCF2PV1O8FsYnfJX2hyaZpfC_3E1_CWr6eG8JNUkFpW_7hD0IvnyU_P_aKeZ0klVRD7d
 NuXIdayu_cC0jx3WeWVW00q9A2FvcMgb4Gb5cahpx5k9TGtKGIDebz.CJ.S.HjS_Mov1uxM5xkF1
 E7itNUo6CdqakY4gyWTYKoh2nBuikL9xV6AQqGoWBMdi9VgFG4Sv3q2CELl4d_dwIZwQeMMFs0Jd
 UmfDrNgGliKu96Vr3BhSic8eSb1r6uaqapGuzbnHImd086RGbdy3MfTDTAL3Dc54CgZBKcnY6b4Z
 kKChFZyCuK3c5ZnUMeYP0nZZPjXNa8zLOrsa_fzJWtSfU8Eo5SPzi3LwxfSBMfZqKtHaeU4TsXW5
 qVl9aHYFju.BrHlEAdSb7FIvTeFJcu94Be22Yk8ZTTCJQ1FKh5gOLK2EmbpIOLOyix27gIRBf.cI
 sYMVhsAP20hT4.CYXzPD9P57EcsBJCNE1TAGj2fpbSqXKVxW4v_JnQXJX4PKuk8D2vDyyGWzMzpj
 buHkYzoA_AyhckY1CIz1TuRPwjT4B5jvbygLw7.cLaverNouX61ba_IH1j4sQ.2yEW_z2KqPjdr.
 zRLxJlwZNXmJwaZ_O49q8Rw1ZFjc758rkuJMVJq67gJPOj309l8btDXlfa2SF6YedKGkGHs8T1kZ
 fYy73bOXwfBEqzREL9iutFp0VTGcktavQt21kvxomV5CzQstLeMm31eAhjbqia9LOZLO29HbNhxx
 qj_mPk5YUm6oC9VNdDjmVslC6itrh6NXIYhs3n0E0yS4W_iD7QjEH3UBdf3e8O0dhFngWMJqiJ60
 JO1sEO5eC2vux_Kl1SoHG3M7jG5qUiSAlbouQiNky3MgtAc1WMJCSoHeGGj7Bn3TJQbExj6feYta
 dsIF2SNE8dMv2x.hGyrNvidXpO0LA7xPOwNRToKbyIv7sZLTMVtUasS8cMPOh7pXRrRH3cfxM1C5
 9NgxkI4IdyuJrvKHaN1OU2E3SSh7d9L9pLoFZwoQqnjmydnb5sJv_JURwfe_VLEQKfZ_3micuWxW
 tuzrKcFHIwxere1Oiida1ZxtODsgHsN2rD6ZC8F4nY9Q4on3hxnrvWldBUvHuG589Z7jbEuDaKFE
 1uCAClKvJjdyu0j5iiEAPxs7LkEAJL.ufMiOndnecABDzkVqmv80wCVKE8tx.My8A8LXCXbsbnUQ
 Iu_MH0ZmtZ.ShozGsT7SI1DrD3nAhOL3fLnRy6_Gjl74QsU.tcOKbRM7NzzPiADiZgRL4kA--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic305.consmr.mail.bf2.yahoo.com with HTTP; Sat, 23 May 2020 08:20:20 +0000
Date:   Sat, 23 May 2020 08:20:19 +0000 (UTC)
From:   Mrs Doris Laboso <mrabraham.abrahim@gmail.com>
Reply-To: mrsdoris.laboso1@gmail.com
Message-ID: <218752893.2520168.1590222019676@mail.yahoo.com>
Subject: Good day
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <218752893.2520168.1590222019676.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15960 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:76.0) Gecko/20100101 Firefox/76.0
To:     unlisted-recipients:; (no To-header on input)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Good day and God bless you as you read this massage, I am by name Doris  La=
boso am 27 years old girl from Kenya, yes my Mother was Late Mrs. Lorna Lab=
oso the former Kenyan Assistant Minister of Home and affairs who was among =
the plan that crash on board in the remote area of Kalong=E2=80=99s western=
 Kenya Read more about the crash with the below web site

http://edition.cnn.com/2008/WORLD/africa/06/10/kenya.crash/index.html I am =
constrained to contact you because of the maltreatment I am receiving from =
my step mother. She planned to take away all my late mothers treasury and p=
roperties from me since the unexpected death of my beloved mother. One day =
I opened my mother brave case and secretly found out that my mother deposit=
ed the sum of $ 27.5 million in BOA bank Burkina Faso with my name as the n=
ext of kin, then I visited Burkina Faso to withdraw the money and take care=
 of myself and start a new life, on my arrival the Bank Director whom I mee=
t in person Mr. Batish Zongo told me that my mother left an instruction to =
the bank, that the money should be release to me only when I am married or =
I present a trustee who will help me and invest the money overseas.

That is the reason why I am in search of a honest and reliable person who w=
ill help me and stand as my trustee for the Bank to transfer the money to h=
is account for me to come over and join you. It will be my great pleasure t=
o compensate you with 30% of the money for your help and the balance shall =
be my capital with your kind idea for me to invest under your control over =
there in your country.

As soon as I receive your positive response showing your interest I will se=
nd you my picture's in my next mail and death certificate of my Mon and how=
 you will receive the money in your account.

Thanks and God bless you
Sincerely Doris Laboso =20
