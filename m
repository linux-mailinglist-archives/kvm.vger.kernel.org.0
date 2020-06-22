Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14685203BBF
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 18:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729511AbgFVQCD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 12:02:03 -0400
Received: from sonic309-21.consmr.mail.ne1.yahoo.com ([66.163.184.147]:37479
        "EHLO sonic309-21.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729349AbgFVQCC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Jun 2020 12:02:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1592841721; bh=cK2qy9Lv5SAgMg9nAvfVmkJPj46H3ss3vOVyjpHm6Nk=; h=Date:From:Reply-To:Subject:References:From:Subject; b=JTETxE5c4VmxIqxusG/RM2eZV8PITO2YLaM87qMBAwWlmjwgCfFCjcnhVxOi654t4AAaGy+DswWjZACYQOeTMxfVHdV/Dl5P3d+9N21+8wBw5o8gzzwm/hv0QwTvk/cj//k3ihNMycBm/3AdLWlwNV728ftYu/aaDrjc8/gwSfv5UB6lflw6wuybykHRKVc/s8Xpu2xuuQoaWtxU16aDxOis4gRStfiu1rJ77Vr7VO4c0E7mEpPNpc6FxDPoHo6cisKrXpgH3VNEhWHkcz1QMeX/B2Lp1IJKmMkKwVSNQiYIv3xuaZwFe+WWtXAMnE9xrXPybfPIaC4JdJGeckV+XQ==
X-YMail-OSG: 1zAFrsAVM1kieiOh8ORK0wfUdGRM.NBHduuqOElv10XrE8lvj_a4MviekME1O5a
 T4Wcgruti.Z9Eqe43ymrsOq1qsGz_yfNoRAP1jAwXMMF1pf0zwOd7d3jIzQf9YtQOWRH2yffK2sH
 6qjaiqXAM6qC2B9TUMJybztP1wQbDMbE_p8MFzqBOqbUr7a9m9XmUaJeVLMaQPEzFJ1P9SIRMWBj
 WfeLRu4dDUKFq1..8jbIithwB2TQLa5J5Zvdsbu03JEAlCSAIRn4NlDsfljw3U39b3THsNBXa3lV
 gxqbcTpSfPMonyZBgAIPrECaz1qg3fKXdhgsgiEKgt9vD__X7ZX1ItajZ3_0iDlRMNmv8SYQLKFY
 rKF2GBcpFzwc6.pQClDNL.rcV7NHqv3VGTG9.0tH7daCi2XbOTJdYGYHqAF3B2MhiKtmGChn4zV4
 Sxvhd1DT2bRnqEV1TiJ8_5TMRg_kEiepWzYIqlAafKE81uUdsP4M_iZXiXAsE9bZaUuZm8KNAo19
 OrIHZMdF5cB1.3cpYIEeX.CVhTkSxtTFxaWQGU7aD_4SVBpSCkYqyP8WZIyG5wXoixcYGpi_nLFa
 NOmGAxhHjg3G5GSQww5sbMu_biatBCf.Fot2kcGJNhB2jnNgPfMgNaPnhosGbZr8iDnSqA6ZWt0i
 TIMjmAxmXK.2w1lJ.LuG13g6S0QBK1fihyDTguab4K.npiWk4qWwJU.NRKQWnlI8MgU8QBnQel5u
 FtE.WmTZiVGoUmgMwoY38kIhzoGdirC9J9D3vJW7cwu8qITj.G4GuDnjkFo8I9kLoPHMuIkNNeOk
 YV66rSFib224yxyqiWlWNRug95eYdQPDUcTL5PQtJ_IQz6xtj7ktGB.e.2tWnB8_xUWkN2nUheUt
 dipCO0HpD.jNm5iyhkimDUjc_DCDbDrcX8cksnOqyROx_Qf.jJLgh58GrrnI3JG0wGq1QHMizaqQ
 FLWdYe_jBOqKCxP6fSGF_uWvPKpEZb2.S9yK2kOUNb6vj_uB7Nvrd1lmA6o73g.FlMWozckFimbW
 8l03wdEN9JG2cbJVVQWyFlpMHB5GZYZIv6iUNRRPetvVKZqVtMyCQ71NXH_IUso68wYLvnTebgSf
 TW5RTJ_tFQ03CDgzHtq2Onsn4oCqTboo7ExJoXketR_fKX4H4ryMUViCbO1h8CZRBWfA.JCd_Oq4
 .hDwFLQ0cpwmKVOolr949Jb0x.7kaAGUrWrS2zmgiz117O0nwzzxlTUJmrq4qyTK6wKIRN13QJiY
 QDpZPKyT8yjCiCxHIYpGJqQbZW1BOYDSz3oPVejZmENYbUHTb.vVYUfxSyAB7pMmNPA--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.ne1.yahoo.com with HTTP; Mon, 22 Jun 2020 16:02:01 +0000
Date:   Mon, 22 Jun 2020 16:02:00 +0000 (UTC)
From:   Karim Zakari <kariim1960z@gmail.com>
Reply-To: kzakari04@gmail.com
Message-ID: <1345703772.1867771.1592841720012@mail.yahoo.com>
Subject: URGENT REPLY.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1345703772.1867771.1592841720012.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16138 YMailNodin Mozilla/5.0 (Windows NT 6.1; ) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.106 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Good-Day Friend,

 Hope you are doing great Today. I have a proposed business deal worthy (US$16.5 Million Dollars) that will benefit both parties. This is legitimate' legal and your personality will not be compromised.

Waiting for your response for more details, As you are willing to execute this business opportunity with me.

Sincerely Yours,
Mr. Karim Zakari.
