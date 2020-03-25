Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02C35192144
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 07:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725815AbgCYGmA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 02:42:00 -0400
Received: from sonic306-1.consmr.mail.bf2.yahoo.com ([74.6.132.40]:37771 "EHLO
        sonic306-1.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725781AbgCYGmA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Mar 2020 02:42:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1585118518; bh=0kmsqXm9K+DyM/96L3DJNmWOe4qYy8f9mpn5lMuhelM=; h=Date:From:Reply-To:Subject:References:From:Subject; b=Qtgt9w0acPnCgiraNCEixE7Ih815eoRH7+AWCrBGfNEMhZEXQCNQWerv/tMBt5V/6e8o+sQWt4eyFVQ6EPUCsSNPF2TncEf5bwyGXhfR0hvk/Ag6BjxPKekxlvQfOf2A86HA8miguwZgvsyqTldCt8cd+ByvlEPgZzQX95zmOT5GLEei/nb3f7AS0w2fRIdEle0j9HzCoXVlaLxUlIIyu/oeFXyfOUMMTeL0zDy/v8iLyR5CDY9uok3/65E7h3OM9y339bWBPFaCJOruOfq7M86GjGRLnGwYP9tAZf7Y/3xLjLPAWCcQklVnpRBpaxq2WqMyfct2hdsgO/6JiFzD4w==
X-YMail-OSG: 0VHvKCYVM1mbXAiQx21nDIpJRIDOOiDMLoTWSoWXtk650qaRvYsl5aLdMXnZTw_
 g2oGwibbf1.DFT8Mp4Pq4k.LnA9b09EvR8xFsfpAwCnLmG38bSog9uNbp8YCuVuMLZLICWryFb.R
 iSC3o9s.o6axRqr64puj18PA4fm2DBfwtcaTMUQ3ro5DCLZUHqsYIs9dXbiVRhUH8O.VHu9VTGaV
 IWDHXy3GKKlMn8ijZDlA9kF_Nu0JupRmtXZih__CSmtx7qmTmraBDFLyOQ8yE1yebq_rHsS5tC_T
 L65gLdZ7P1h2seAH0npWnXY.4LqVrB2n9Tp0JpHSOW.PyeIDk.7B8r7D5.ftGDzi9T5za5hpthhy
 jwrV4y.ja8NYJoGNYof2nSei__f3HQ3urzKoqD2SlMHADskrkwPquOW_y1iSe0pNDAgKWVl2IjXg
 uhm6PBqYXF0.VedUpqP0WwmywHJgkKC2D.mQHVNl9p5UtWKhUGWw0UNTXkGSyI_9V9ZIsg8O1ONU
 Q0PvOWHQwEEM.PI_UIJW7A_5rdJMOu2HQaQVeKRPKJQjfUQMEKbfjekeqgBkznX8n_hgl3U1FQM0
 AjkAdjAgBMg1wkHtT6VyotAmgQdfGOZIN6XO7v.nqvE5MbBHjYyCw1sGt_x5GAPJ.Z_MSlx0RNuH
 pd0tJ7Lyp_WTQvPYy4ps4kjd6WNI1DIZHRIlvZzKrZ8sHFaGYUZDD3ux_XJ3mhE_AmF2Yq5Y3x5Z
 7c5Qnx56XyYFhZWSqm.UD3CLdiB3eh7nfadNvTBJ3AJR.n6iqIM5KAghi.XaceyjpNJ_gSum8wAP
 iujX2cQ6VWj.VMzRgoHNZW91D80JGLJw8V1kYPmy.vccSLckGeAEtIBh4dQVXlObcaJkCueoDWdO
 JYy4B4umfqtnA36md3s..Sf7QyCnwvb1e5VqLx9ceGllkx_IdD9e0bGxe9zNNmGXZmfQBFVe9sR9
 Z76Jna1SYxLArEYOEnB9QX2mDrbmKzPB4GcG92uupXYBIMzxwufa_W0Ie7PLAdqMVKMM7jXjA2h6
 tCIE1LnGu6SEy.PrdcUDuOq7N6yw2QZgqyBmQkWeYU3nPuzyOVYr4l6BeIP31p4cXdyv_QJAYCcM
 AgyCzgbuWTyF2OcwTK8t6PV7vVyaVCkN1Q1vw.d7eKeG7fSDAXYAVy6xYoKfDthLDLN0E1W9_Ph7
 KjtdHHu2IhFno.ts8a.LyBJQFE3QMuDHkHIGgBSw0.gaOpTYujqdUDJAr6dXdzqLecPNIug55vfb
 mfu4BIX4kEWF1HBpIUc6l1G8dfLyTXh7kMfbTtV0DCY2Dqrh7Jq.sRKQHCg--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.bf2.yahoo.com with HTTP; Wed, 25 Mar 2020 06:41:58 +0000
Date:   Wed, 25 Mar 2020 06:41:54 +0000 (UTC)
From:   Doris Laboso <mrabraham.abrahim@gmail.com>
Reply-To: mrsdoris.laboso1@gmail.com
Message-ID: <170490549.1098786.1585118514462@mail.yahoo.com>
Subject: Good day
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <170490549.1098786.1585118514462.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15518 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:74.0) Gecko/20100101 Firefox/74.0
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
