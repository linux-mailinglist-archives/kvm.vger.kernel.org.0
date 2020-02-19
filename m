Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C74BD163C12
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 05:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgBSEcc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 23:32:32 -0500
Received: from sonic311-15.consmr.mail.bf2.yahoo.com ([74.6.131.125]:36883
        "EHLO sonic311-15.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726477AbgBSEcb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Feb 2020 23:32:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1582086750; bh=EoSOra7a2saN4Rx9MPg7CnNKAW+5S8RlMnV+0g1PH1E=; h=Date:From:Reply-To:Subject:References:From:Subject; b=e5Rva6aYOqdK0ttiaX819nHL5JT5KRIYcNQhSSelGF/ikhDPhfcjP4Sq717T3lsuKe/q9sv2skLILDBwKQciSPmHzHc0Woo8LZSRIaywJFas44N7IIGWyLZ0KPHirMwBFHHRvAaScaxlvhqsF+rIAAHnXdPIerRIYo6g6Yn4MhBtJ4cFVlh6f5+tolY21O518RqreOrhGmfr1zJKDjeaKVz/Hw+dUD/7Rb8xIMUdvaNG10XI3pm3dpP/2n4VRZdO9k5qbqoNz7xKJOkYNybLc0+mtclsIW+rO26JDfO8Z1AYjSGpktUWL7TgYBuwa/e8pDVFftVBtCeiz8iSW/hBpw==
X-YMail-OSG: raJc3YEVM1mb_188ssRY6QmEYKHSiwg1dZosWmPHcld.skZhuR1lPGXKn0tA.2U
 2aQD7b.Ehor_dR1IQnae1FSGqkFEKATwyim.wu7Zg7ya4xMKqknirvNgb0z4MAJ9Z7Xgi3jDwqPB
 .CYPlbdYYHOMh2FWE0_sih61GRgqBmCuQCuAy2.CzqjHUuF8nAGVT4eT8AYOZNytNKb8uicf7e8u
 zODvk4zjBulNkBAWZ9MSgyyZHeubf1RxT2JxbZWemEQZ2XqkwIi2MDKYzhURPaqByF1d8VM0VXpc
 oxzs673G.8BChJ7bvbCU6q7xKiV80vEkQY23TB3zgNwwI6efCeWgwWgNZE2JubXVqc_UIV3w_fbY
 rht5EY8kSD0VVc2LIVcMZNHkyhLacL.IpMB8A_vVQ4y_QZp3HlEkOt7L2gWnfd448BOKJLtddgF2
 06z76TKv.6bx7F5SYZSzYKzAP6CqEw11euG1n9C3GP9_cw8VWgTLi.PVGwhsDZNONLcc43PYApNf
 4N6QGOrxnyYG.ty3_t6LCx.eV1alYThPuL0mVVnjJfOw2Ubzk7E1ENgYzJOmDf4TU0cjVmDsz8.P
 rO4DB6Pr.2a.Mbn5A.e78Pn.ZoxLCUsdCuJYk2vnsd8WBaGclxJGlhDyVB26ZDbSA4gUV5hqktVd
 KNsGbimIY5IpuxmrH_dZQBm_rCFmAyBC9FCiIZxhmqx9XeSAh.4LWy7vwL39Ru2lezK7NAZw3eLG
 nkfYmM4Uy4NrkAwYj05oyyInFaX5akMevQ8qZZPVhxUJXB_Ypq0m1ow55JGjLLq.P_fKtY6r1fWr
 TPMYI.uMAhrMclyw9.nqp8JLs.Di9MOs0U1Rl8ZBWe.0JtLaQLdgWkWHfOCLIP3UvNl0l6WXJJhe
 p7bCNZNOSHXW4Gesrf9AE_8Zcx7zQIpq9dkoGjrEnHyvQ7WlnApHrueCeNmNkvmzNTo7y8qypiLP
 JebmmkykOgdhF7y1OxQpT0NIRPUzIxHBYmSTWE7wFn936NIekRSSEcj8lF3akuUT7OIDx02gepJt
 y9YaNaxnRsgLkB8onoivtxrHHC_RwyM4_h5.YTeamni8trZNXV8C61V1ifltlRnUmUOSDe6k_oJ0
 CPHcyD6r9YiQdXRA4G6LpJhBxJkQiRP3qmU3aGlaY7Voe6HeKyebsPiOzyg5tkXuaEJJtmsLkgzG
 M4m_AIWmk8Cd50z7qQgm933EOE2K9TPZxMqGbCzlpyh53MC77pJCBAprn1uquzO66STVsxmx90WK
 6s2nYREKJK.ZrxMrq3NbyjJKhvgyndYkihPD5Q7PgbBZLZ6whU5.op3zAXUnco_lKBuuoUrnwa7w
 wCOXILQ--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.bf2.yahoo.com with HTTP; Wed, 19 Feb 2020 04:32:30 +0000
Date:   Wed, 19 Feb 2020 04:32:27 +0000 (UTC)
From:   Mohaiyani Binti <mohaiyanibintis100@gmail.com>
Reply-To: mohaiyanibintis100@gmail.com
Message-ID: <904205497.3594406.1582086747363@mail.yahoo.com>
Subject: Dear Sir or Madam
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <904205497.3594406.1582086747363.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15199 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:73.0) Gecko/20100101 Firefox/73.0
To:     unlisted-recipients:; (no To-header on input)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear Sir or Madam

I am Mohaiyani binti Shamsudin, who works in ADB (BURKINA FASO) as a non-independent non-executive Director and President of AFRICAN DEVELOPMENT BANK.
During our last banking audits, we discovered that an account abandoned belongs to one of our deceased foreign clients, the Mr. Wang Jian, co-founder and co-chair of the HNA Group, a conglomerate Chinese with important real estate properties throughout the US UU. in a accident during a business trip in France on Tuesday.

Go to this link: https://observer.com/2018/07/wang-jian-hna-founder-dies-tragic-fall/

I am writing to request your assistance to transfer the sum of $ 15,000,000.00 (fifteen million United States dollars) at its counts as Wang Jian's last foreign business partner, which I plan use the fund to invest in public benefit as follows

1. Establish an orphanage home to help orphaned children.
2. Build a hospital to help the poor.
3. Build an asylum for the elderly and homeless.

Meanwhile, before contacting you, I did an investigation staff to locate one of the relatives of the late Mr. Wang Jian who knows the account, but I didn't succeed. However, I took this decision to support orphans and less privileged children with this fund, because I don't want this fund transferred to our Account of Government treasury as unclaimed fund. I am willing to offer you the 40% of the fund for your support and assistant to transfer the fund to your account.

More detailed information will be sent to the disaggregation explaining how The fund will be transferred to you. Please continue to achieve the purpose.

Waiting for your urgent response.
Attentively
Mohaiyani Binti Shamsudin.
