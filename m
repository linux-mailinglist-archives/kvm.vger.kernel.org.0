Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFD16282A60
	for <lists+kvm@lfdr.de>; Sun,  4 Oct 2020 13:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725956AbgJDLVR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Oct 2020 07:21:17 -0400
Received: from sonic316-13.consmr.mail.bf2.yahoo.com ([74.6.130.123]:32961
        "EHLO sonic316-13.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725999AbgJDLUC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 4 Oct 2020 07:20:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1601810401; bh=NajTNMrfMLb6UXcjRhYpYerQX8PtVBLz0oFgaMINSWY=; h=Date:From:Reply-To:Subject:References:From:Subject; b=e62Rtdp8GDCxoc4DGBWh2dZ+Q5sqGKD4EcbpciLRqqHlq9iEXWWrS2Amoa/7n5JvA9vwtR+mL2Y973H9RU0rW0spQoFrm0HjhW8pKOrhEqFsjS2y2/oYZArFFiurNwh4+/YEQkqFZsmmJZl/24chRn0YD3zsmtY9C1aS2ALNT4sbeR04v9RPtcR+tiwrAm5jWy8X+FHuTgL0EVh9OYlEVxl4Q41MJVxfrSKCeWgRgfTI+ZE0CQCtmYyK+lVr2G2DYvhHz55RQ2GYsHtyF1QR3aBF1XhbemLbWq0BrZDcV3SCY+bLSHtEN/F5q7UjW+rg+dR4QBvVA2L3r4NUiJOPrg==
X-YMail-OSG: ksh3IvAVM1nt_CUShHZ5mJQ3ypkvc4clSuR.HH8KERo7pC5QOlWo.UE7w6KGklk
 uoTWcxu9AcuJIipJP0z36ebJrh8sogs..PR3TbX_KWmDspfOz_ViiCn40C7Y7fcJYeiH9LL084Q3
 t5wWF9W2CzgpZMESr5a58QKwyZFL4xoRoXubCHLpP8wgPCm8tsEhkJMEkQkjhLOF01Yr9FqHMEi_
 sE8cubhzWSDO7kEuxQyDuiTSqlxYg9sDEy50r6qIXZztEhfxRA1NsIBS2B4DWdup1KXEBJSececG
 wyN.a5YbmKdXrKqnnPAeFZs0l4UNuw51FhwspxbwZvRMVS931K7qkA4cV3M7kRu48b8lLlH0L8Sk
 N2hFAvvYQf8RAcIdfuF6z_oMJmmSAfN8vuw0m6jRpKJQDKzTCywKz2bkSbOjTuVUHIH4rycgJGGT
 PWtF1X8m95GnxU_ALSVrVLW8X8Pc4KAM87vraMETUeSS.RYItWtxpftpUb3kFmw64g3VgOIaMfZ4
 cI4eZGEUjb8cBBoSRHYxaibzLsWKFEe9SuddyGhdojdrI3l5EU6GWnxd.tUTTLw5FN.m8WLCV6Rt
 giE48NjAeBpROPPu2TGvwwuxku3J08qnmPqoQVU5MJXBaXhOmsC_LJa2T2tBngxhiciCjr82H4ao
 WpMIWPE5iZ8_N4NXc46w07QRrWPpjWiHk4g0Ilq6PAcA4QeZ6UKzXftmkJBNFWH33FULS98_kl6D
 IXDS1r79Lj3htF6AU78Zwggl1H9Y3jt_Iz2OyIwUZiTIqzMMwb1uAaMWEgS_LoLG4ikNRa2leFHO
 2M6vpRHJ4E3z25wmgPaJJoO08MWdd3MPoyYyzBIdn7AMD8gnpc6bfPSLojGrAmbw0zSJ0Pld6gvC
 oNOueHVNhq96cT1Ub8yZn3feZQei7Y62xTdvQb32oXqSkNQIqt.0us3B8ijjxJhLPYA.0lNLl1KG
 r63uXHi1_51Ck2nkFiDGBvcRL2wxjaVR1NeKRY_jcTEz5pUx1USQx10DMevRpfUoPsE1fcQdcGum
 5kejWp6JyvNbpNjaJYf25j1eWschQ9fotznY2.PDVlLB1d9Qp2T4gKqhj6OEX8amjaJ3jN8_12w5
 gQz0p2jNq7mACg6Mjs3yD_TUmCehI0FkL7lFPM86XMEHJuidKR7UAdp1294maBD.WgPD2LWNIeqe
 KcX1bXXh_4vXlTQMmBDK3U6r_zFuWO7gA3rrtRUOxv1cT1n1vO9m74W_jnpbh8f1rrIf7SVMH_Hb
 AwBEzybU.PrVsYbMl.TsOF1_NgJDvp4WY5ZLTlFi73x0xQbZ2eOtTRFmnvx8jsw7QGXF9jS8pot6
 b.eXD4iSeg_CMTGJkNl0GGS64awdGM0GvOVcPXo38LLl8ueqqYLaCKMPqGPC3oZgTnzwgdceryMj
 qxH8zdQk9LDpnV.G.dpCAQJgjAFfSNSdEmS30krbaCbrltA--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.bf2.yahoo.com with HTTP; Sun, 4 Oct 2020 11:20:01 +0000
Date:   Sun, 4 Oct 2020 11:19:58 +0000 (UTC)
From:   Ms lisa Hugh <lisahugh531@gmail.com>
Reply-To: ms.lisahugh000@gmail.com
Message-ID: <886420288.1575104.1601810398140@mail.yahoo.com>
Subject: BUSINESS CO-OPERATION BENEFIT(Ms Lisa Hugh).
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <886420288.1575104.1601810398140.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16718 YMailNodin Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:81.0) Gecko/20100101 Firefox/81.0
To:     unlisted-recipients:; (no To-header on input)
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
