Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23124BDC4D
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 12:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732188AbfIYKk6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 06:40:58 -0400
Received: from sonic307-20.consmr.mail.sg3.yahoo.com ([106.10.241.37]:37866
        "EHLO sonic307-20.consmr.mail.sg3.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729862AbfIYKk5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Sep 2019 06:40:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1569408054; bh=VvuyvMElMBxMgVM065W8Mb7OgboYNAf/LGiLQZjTnyM=; h=Date:From:Reply-To:Subject:From:Subject; b=jMuowT+s1s/kUV2ZtD+EgNEFMDXOg0wKjWeS2fT940HjnfgVMjyRcwYOM89P5eGrVrnszJ72eJ4DBQgoy1SrLoANGh9mXpffpWEXTJ+KFFg8Krip+Vcvx/MVNXwIRnXwC492sgiwfYyE07ze8xxXjEy6hKGn+wfBTaRZPFqE6Y6cqg7tetp608duGZjoum1Dqu6/klM4AvD/P5ajCW0gpVmpobPpS/nUCtYt7IfrTEt/LGW6dJ3UkrfAOSJBqwsJhWPHq35u1Jg/A9KCK31cMV6YIO2ETVqgkaQZRORxgtlHAeJOXxxlQQjsMeFs/VaMWTxD2F0DITEKz1PxE7jLRA==
X-YMail-OSG: 3_fNMkwVM1nni.LkxBVcwQy8yCUJvVmz6AHkQkAz6o233W6lo6y2R3.IxNNJsXb
 wUkwyet_luk.RGGiQEAn0DZ9x_eIOXk_U1QF9sv12LkNwASBHU7v1j53qMnNk4aNK28t.PK0bnE_
 JEPSCDpZQaAPD9t0GbqAyAyXL_hFbHygkR38TR5gnB4WHo2tJ1JKlTM4j8KGgngPh3BO92S5ut9q
 6F.MNVtBpjEvilzPMa_1BYY8sKAZsg0P1lRnNQ9KIQZ820NuNjS5yN5I0mcW5Pnh8L8y5Ztz8Ebw
 We7tFyUDGMSOxkZwbYhZJS.Gmz6tOwbHRigIgT3wMyNEfoNxfdnFhK4cl46z.EhcVWGveX5u7yFY
 0X9tEELh3RvKa0_ahmTMP9Mpa2zrG0oDN0WsbVoeqlDb74bn.cZrIA9Q9bB9awtpnT4lWtaDejHP
 h0v.yqQ8dzuirXXUMt2LGqA26cNKoFY0FG5QRhGSAqLt6tM.CZRoVV66IyMd.cTYoIiHg5pdNmUu
 hvu1kPXyBBSy93pmTOhUo2gGlvbCyxrGd8cPyeqoc5V8kPNeGTdBEPRVPgoSuhKISqnT7MeGRA_y
 uOB40TRZvAVsgvf.Dj6loyWvgvkbWgwBS_7TT0omhlMnAsSlm_HqdqU5ofGJAei4nIPneELrr8dF
 UYbf_JYYCdVgyyevqCkRsNlMs.BmTdA3SNFwEERc.xU8y7GBNNKbfTCKtaPmr3BTk1lgdlLzusjF
 ahx2naVYqgOxvbAYZdFNbs.ph6fASblIpjdNZ0ygY_ZSJRFcrBFaaC1Yk2RkV4KkcqLQQ8r5d9e1
 6o2KhAdLrgAD1EdQq7db3vC2xEOksSw3nxoOHxX8vEA0OIWNAp.d.D9uM5MSybeZWjkmQ83Hi0F6
 Fq5NcQwfGtUXpHnPqE5Ty44fIqv4_ZrEHrQYAI77H0CitENxQkXOD9BxpHqdej5RINI6.LoKvN8T
 JsMLZJBTUU5zw5P8MdDsO9xlK5r.6z.ebj5CwKZgIusjWCipnu.lfg0_Tzp5f5n6P1tK4zzap0rA
 VE9HWKP8Rija7drL15nUMzhcl9TSne.cnV3rOS2boXSfgTKYChATJi7SbHaQ7ACpbRYktngTnlva
 7HMC1._Ce6_Dx4eaf1Fdnw_x4FzaIZLmih46valO4SP7NEgYXTzTHhseMLPAsrZci15453xXXY1Z
 ELwrZ6pjnPE0TUDWgYn7e.5U7.uDAwwSQ3mZ7I47jsYmJVC6P6YoCkcCxFd5V56K9dQvcxcgProt
 nzaSj6QPKApx3qZu11DnLaAdwO9XFitXr
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.sg3.yahoo.com with HTTP; Wed, 25 Sep 2019 10:40:54 +0000
Date:   Wed, 25 Sep 2019 10:40:49 +0000 (UTC)
From:   mohamed <mohamed4bennani@gmail.com>
Reply-To: mohamed4bennani@gmail.com
Message-ID: <1133317183.9961766.1569408049310@mail.yahoo.com>
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
