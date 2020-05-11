Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F18F1CD454
	for <lists+kvm@lfdr.de>; Mon, 11 May 2020 11:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728260AbgEKJA0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 May 2020 05:00:26 -0400
Received: from sonic301-2.consmr.mail.bf2.yahoo.com ([74.6.129.41]:39419 "EHLO
        sonic301-2.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725790AbgEKJAZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 May 2020 05:00:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1589187624; bh=SnohaWCihTHtX2WADwWUldF3lvCDQyg/hKd3r7Maw3k=; h=Date:From:Reply-To:Subject:References:From:Subject; b=Lk7f7OOKkACrMkyypcbant/aBabRb+5L0ezghiRqUG+PFFfablKukn9wRGbqxWflUOq3AxVJffjfa0Wyp3Et7NlpvA2GvLfYEMe4iJeyU3hlOUINNUJfDvyuNvPjxHefyM2xT9SxpHZI0RfV956fL39WqCP8c2Zfe3uyRlqK9XlMxosYPmwtwCpziGHiMq8lwqGFavZ5d9SM8NgrJit5JjXoKGpfCK92U1TCfwQ0NmnMV1zYRT8SZtWt9q6riQfkbYw9q62NORUzIiYlgXJZ8B4bf7Oh9QpoNagRFDBL2x0Beq8bNIL1WO1dvFKcl8XaBxMtjz5wZnnqdS1CcE5d1w==
X-YMail-OSG: 3xOnYiAVM1l3koaBsOdOHky3CwFD7nZf4cntDMJ4MsB5RzGlcsiej5h8pwHszuG
 7syF0sbtSUqK6H6hSIO19p2OKx16D0gEluSc_3zgmQnmQu1M0F6hu8AeXUXRJoiBo4xUsWdzcyxm
 c2pY0kwtYxxyIgVJSV7rT4IVdA0gXMmwnuy6.lrS79jQi4j3itt0h6JtBjU0p02e.kjmchKUB6.P
 0WYQR0L2EQnPlW3mMbjKKKKVqu.JqAzBRH.M_tqe4lO4WdPAyfFTOAm71gyHJki9wZlGmrojOo_y
 3L8CUes0sfRGIkbVf7d5lUogVSwGLgGWt4e6p3uW3AD3Qz1XxxGy6Et154M02mdppvE6YDxV2qu5
 1NH8MFz7lksvoX5O5aHdxuk5kIyitnJ0iJ3.rHli7yyugXWgFh4.HQlZF8gsxGUzoJRysbPsUqJL
 mEuKb3H2IlnN8vWzHM5qfGzynDofFDZ0CZ93H37CiRmfVGREP5wc985fQ_.zZ3Pb0Gm3XEo3oX_6
 qYZ_6gz6w0_NTy3Mta.9BL6Z6kSx7F8LJO0Q5Jdtc532W9OpOcfAFE230KTgyitG27KzhyByg2Qa
 W4tdjh.E3WFYqJL_66OOw2F99tJFKOQCm8rmWVpY0NmXac5JcsGCFKmMdr5i7_97.8puURtFhdre
 fFcTJ5FAS96ag7B52t8Wcy35fQ36TDt_x.F8kMxi1GQ_PS79gWwmh.MwHFRYCf9MnLXFtAdOgxCn
 fCQGsnIyOYtw4v9rVn6tQxiZqYByO3lVtvWkxs2CCSVFEvmxsVnd7.qy5xOWbI3ahmUBZnV.5Y4t
 sGx37wDb78HJ6VBRpY9yldXZytnqT0FBXOfpIurlGd37QeqhPrVzpoCCqCFctuRTyiiDFC9RvGtU
 wyipS5sGaOvW6pINhKwrXY4xigub92gSYvtITceJPdw_pEQ5ch2nDYwXAsFs490BuODeGXaD9Ph4
 SjX8bNlUzuxd5btkIP9YRCdFqoi.1h6jicUFii_Pje.kVEC_rrNEuPEb7jUuNc2q_oyYI9yt75sz
 R5P_XUl_GuqPUDgpk11RlXBJG4u_0ka3r5CCZNZpDIZa9T8rc9WYJe7637fguB2fEXYouZYuR5EY
 oK8Ka9dYx_6tkLSMezmkKaxDYdc0EcA7uZRV.ILvvVqdz6OUo_b3BpnQ5CiNbAa4qKKBX.hq_75W
 lCTvZ0gKsm58LidxeTK3xx5hfb9PHuPb8Hd5zWCuvj47MSQRJuMCI2JTFG53r9foPswqIMtpcrVM
 dYPNDJ9axZ.bOVRUXqSTRSx3Vbtsd71lNQaWNTAAJuzWF8b9pic7HPzB8uW36C44v97n9HFRD1tV
 MgA9ndjTdQ1iJGmlBc3V2T3aY2._ZVzFWs6zV
Received: from sonic.gate.mail.ne1.yahoo.com by sonic301.consmr.mail.bf2.yahoo.com with HTTP; Mon, 11 May 2020 09:00:24 +0000
Date:   Mon, 11 May 2020 09:00:23 +0000 (UTC)
From:   "Mr.Solomon Omar" <mr.solomonomar776@gmail.com>
Reply-To: mr.solomonomar00@gmail.com
Message-ID: <116129701.511812.1589187623869@mail.yahoo.com>
Subject: Hello dear,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <116129701.511812.1589187623869.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15904 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:76.0) Gecko/20100101 Firefox/76.0
To:     unlisted-recipients:; (no To-header on input)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org




Hello dear,

I'm working with Bank International in Ouagadougou the capital city
of Burkina Faso.
=20
I'm one of the senior director of the bank, I=E2=80=99m writing you this me=
mo
because I have this urgent deal/business proposal that will benefit me
and you. Please write me on my personal email for more detail
information concerning the issue at hand

Email:  mr.solomonomar00@gmail.com

Thanks,

Mr.Solomon Omar






