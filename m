Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33A1AC8F20
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2019 18:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbfJBQ7L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Oct 2019 12:59:11 -0400
Received: from sonic306-20.consmr.mail.sg3.yahoo.com ([106.10.241.140]:39310
        "EHLO sonic306-20.consmr.mail.sg3.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726101AbfJBQ7L (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Oct 2019 12:59:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1570035546; bh=VvuyvMElMBxMgVM065W8Mb7OgboYNAf/LGiLQZjTnyM=; h=Date:From:Reply-To:Subject:From:Subject; b=ZRzaoDHvRmejkQyd//WTcsXk8APRjLIL8WY1aYSOYj1Gv13Do1mYeCLb5b7TK9z1cYL4U/T5dM7mbIa6eo+UHC15K+0WUfZLPOFagf3Zigp2fNgtcybfjiYiEIcuas3JQYI3bGg6IkBL3GIcJzwWq1K6OqGThUkZq2bmjxv4zHpTON36EcNfD+ncVmci8D4jG5U95KHl8WOtqdMVFxc0AuOtzeab22cbHqQMcEb82KdpPD5XFCkK946el2r1cKCiY+DsNyY+zhly9gSDPy5S0h2VIO6SFbdyBRurnr9Rehe8BGhM8/883CPjJFoc5SY07ofzJMOwPO4on0pAFyaZyg==
X-YMail-OSG: 9RoNTQ0VM1kVYLK4ih7paeKhbgVTdzagnuHnbeYMaSo7DfsxDFKDnHD84aUyMyY
 u8cIzGc6IdYxRMs8MOaN5Ki4UbAt9f4mF_I9S5j.gE6bh5pCp61ey0P52o0svIVHa5H.8Ucki0Sr
 QLlgNLsCDv0DGXDMZVL6V7KA4ofOTASUPJUNs6dEfLLC10k65Wtzko2iIk8bm.fiMknQLbVwQBGL
 2NalyAHvu2qru7NAwAO.Xt8uWJt6TzkaUiGvN4zO1daYXidkM4V9R1dnvLdwilrgE1ZExRkf2iin
 VWbTdnBw.GaWSYsOSfSj3HwHcc8W5QZHvMNZbW49QCI8wzdX4UBr.4kJGeDn5_vcr9MosxvLnV5Q
 jZZvOtUQvutq2mOJHv8aeVK78qxxZ9XyQtmpNuMn6VDLS4A2QUC3o0rh6y0f_dA8sN28OcIdnLq.
 9TLMKwdj7XboRamrQL73Fc9Q3uOg5gUkpAfP9LxJxUKGByd74w7Qa1GUzolaMxB5HxBeqNqmbCsc
 m9xwpBTe.IG2dcETdILxWfxW9VMwQTTliG1.kG2GZdpbMjL0UMoK1O8Zd.uV6SipcdDJ5NUr6tAz
 hoj_6Bf1UH8aak5qSBr98jeuq.MywW66IryfQwuwXPbUJMkXlGP1cQoOheGI0JkP8jSsYZhKuiUm
 LTEY2spZSGEni8XiR8OVq5bJVkHd3_ixTHI4vr5jPw2xVTyBudrxBsAl0oprqQ.V7RGhhZAS_Qbm
 SpComhfGVD7hNqxJN6jEmHlkeVDvAL3lodkC873cw8OFyZguIyJPR1Bg053fWWZbsLer9VxtNKIm
 PK.ArR0IZIj5g_rU3jNU3mKl6U7_JXeAAYXUrf6ry36dPW4JJY7HcMsuFxh6FUatr7xWI3e16h5b
 fnm3VrebuUeuUGCBMQk_eSP_GPTeYFlQVsqpQbYNnfB0Uo6zDozZFUK1M4HgyIaQWgqXBct9po_.
 bIjX89vhkEWWK_XxGiwAtO2PgjJ_KzodCoYreSM53YexplmSBp2FsHyqWdNWJ1SY7B93R.chFF8K
 hC_Xn2VLnHJMELazguc9eBBmJLzpwW2b6099J3bxssElswKsC1m.z9oyMFLMPhQN01BSk2pcAhiA
 1Ku7mmy11B8wJswxGkUUayMm3rzB5T.RwAYuMC_ga5hzcSyLKuJRkM4xuoLgtzHXjEi8SE5pRNqv
 HcPys4cMsiEOwVqxBkMU0Gtrx35dehvdw7tkRpvR3jMmWrGX5o9uuyYK19SauGr0aDAQrMXS0QHl
 wM5xA2vzNniShqjKG9HLi51FBCEEGZTtknH3PSa1P1BFVfSMF1ItN
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.sg3.yahoo.com with HTTP; Wed, 2 Oct 2019 16:59:06 +0000
Date:   Wed, 2 Oct 2019 16:59:05 +0000 (UTC)
From:   mohamed <mohamed4bennani@gmail.com>
Reply-To: mohamed4bennani@gmail.com
Message-ID: <1900136144.2293884.1570035545049@mail.yahoo.com>
Subject: Greetings My Dear Friend,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To:     unlisted-recipients:; (no To-header on input)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Greetings My Dear Friend,

 Before I introduce myself, I wish to inform you that this letter is not a =
hoax mail and I urge you to treat it serious.This letter must come to you a=
s a big surprise, but I believe it is only a day that people meet and becom=
e great friends and business partners. Please I want you to read this lette=
r very carefully and I must apologize for barging this message into your ma=
il box without any formal introduction due to the urgency and confidentiali=
ty of this business and I know that this message will come to you as a surp=
rise. Please this is not a joke and I will not like you to joke with it ok,=
With due respect to your person and much sincerity of purpose, I make this =
contact with you as I believe that you can be of great assistance to me. My=
 name is Mr.Mohamed Bennani, from Burkina Faso, West Africa. I work in Bank=
 Of Africa (BOA) as telex manager, please see this as a confidential messag=
e and do not reveal it to another person and let me know whether you can be=
 of assistance regarding my proposal below because it is top secret.

 I am about to retire from active Banking service to start a new life but I=
 am skeptical to reveal this particular secret to a stranger. You must assu=
re me that everything will be handled confidentially because we are not goi=
ng to suffer again in life. It has been 10 years now that most of the greed=
y African Politicians used our bank to launder money overseas through the h=
elp of their Political advisers. Most of the funds which they transferred o=
ut of the shores of Africa were gold and oil money that was supposed to hav=
e been used to develop the continent. Their Political advisers always infla=
ted the amounts before transferring to foreign accounts, so I also used the=
 opportunity to divert part of the funds hence I am aware that there is no =
official trace of how much was transferred as all the accounts used for suc=
h transfers were being closed after transfer. I acted as the Bank Officer t=
o most of the politicians and when I discovered that they were using me to =
succeed in their greedy act; I also cleaned some of their banking records f=
rom the Bank files and no one cared to ask me because the money was too muc=
h for them to control. They laundered over $5billion Dollars during the pro=
cess.

 Before I send this message to you, I have already diverted ($10.5million D=
ollars) to an escrow account belonging to no one in the bank. The bank is a=
nxious now to know who the beneficiary to the funds is because they have ma=
de a lot of profits with the funds. It is more than Eight years now and mos=
t of the politicians are no longer using our bank to transfer funds oversea=
s. The ($10.5million Dollars) has been laying waste in our bank and I don=
=E2=80=99t want to retire from the bank without transferring the funds to a=
 foreign account to enable me share the proceeds with the receiver (a forei=
gner). The money will be shared 60% for me and 40% for you. There is no one=
 coming to ask you about the funds because I secured everything. I only wan=
t you to assist me by providing a reliable bank account where the funds can=
 be transferred.

 You are not to face any difficulties or legal implications as I am going t=
o handle the transfer personally. If you are capable of receiving the funds=
, do let me know immediately to enable me give you a detailed information o=
n what to do. For me, I have not stolen the money from anyone because the o=
ther people that took the whole money did not face any problems. This is my=
 chance to grab my own life opportunity but you must keep the details of th=
e funds secret to avoid any leakages as no one in the bank knows about my p=
lans.Please get back to me if you are interested and capable to handle this=
 project, I shall intimate you on what to do when I hear from your confirma=
tion and acceptance.If you are capable of being my trusted associate, do de=
clare your consent to me I am looking forward to hear from you immediately =
for further information.

 Thanks with my best regards.
 Mr.Mohamed Bennani
 Telex Manager
 Bank Of Africa (BOA)
 Burkina Faso.
