Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFEB1DC034
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 22:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgETUdr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 16:33:47 -0400
Received: from sonic315-21.consmr.mail.ne1.yahoo.com ([66.163.190.147]:46104
        "EHLO sonic315-21.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726827AbgETUdq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 May 2020 16:33:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1590006826; bh=6mffK3RH01pMSJbI3gzRyn/TJ4jPuu2pqeTpPbg3ras=; h=Date:From:Reply-To:Subject:References:From:Subject; b=sxbnDsk78ZnI2Ac+TzutllkDrJ52YbqMPKSfIM9j1C7SqDCF7pfvmbyetog/qd1PTESA5MlDNyxTKScxTfg38XVqbZegmIquPQaTRvhu6kx/ykn4w1Fr9Uj5vRhd4VtD+kEIcMK/8RJx4+39DuJGwWA5/lQ3Y8VTavAxr0wXTC1Fz8d9UuMMWFjAC5sL/OrNdNNZWhQfMn23aki1LWwD4Oy8xWEIDnM7Dc8WS0jJTkRwiGDb5qZ3SdnZaEDOerhgsI0ej1bGfD98sA823DaW0V55ROu7P8eTUVuijhtAjFd3aqrNkMYDkIPua2JPvaqP8A1Hl8ByQBkM9+LrLkaMfA==
X-YMail-OSG: GVvSrTMVM1nDLZPK6gaGIsIHLtO.ut.iaUAumpa6fDhpDlYfMWslegHirbCt9GL
 oe2q5F0NUey9lyUFqMJ6D5w2L_ALLMVmuCBt.QD9bqkynlLF773tLvlbx5PMESCa4ZYobyM_ZqVa
 K1Hd_l0vm0BHkEDQvFXxM80J4xb449pMHmHGXUpBO5kptSftC28fD4x3jWdHBRl6_Q5_rRxo9mR3
 BTSEI.B_2DeIVInWTDMn8T88Z.Vm7npQtW__DkIIvRIfElaGSLV1uqGR5JZ7pxVRDRIyPU5U9hfa
 dpnnvhhGBtI5_QO4SFit3uv5CBU9YXoGOiZwz9eNKOeN77NanP81pT5X8ZXCZpP4JtfS2bc._UDt
 d91axKD3RDMbCfZcMTlrMkninbHRkAtfzn_diHzh2VfjqQpYx1sSDmQoKgsClq5TyIoPqzggKM1t
 kY3F4Skvg44AJJ39Og0CZWAzA09Uwozmqj4.Q5AZKDaOQ0NGn_82EdgCvbBk54Z7BuVbUYjh6LMU
 Rp70f9CcI5dJHmYC7ZWSjLFDyGEDA6BJPTaiIUdKn9tZyHULnxyrQj_o3ydaBQDrKJ.Gug3PgHO3
 Vkb08JbZzVVnrYfCgkqnEarq6dStdhaEAlj3j1H94s_6C5Szbi_2YuGdq40QLbN3T_OKQNdgKF5k
 8MWuaqEz7MJzcPK4BqIzZ1uxeasTJlntrNpII5p7uOK5ZvoYqrte_1KkVNabm7R7ROCbSF6xkxLh
 Cstmn_KZxSzXHdGgDM6EOBnrJFuixSNFS2qrr7M8y31XNF2i2y0lbdZRNGHUqXDSzWK8bir3qiOh
 fHegAW5jmAJz0qVq6y2IabzO1lnRmyAmQM0sVIus89vrGNm7EY6MeMrXZcrN1yZa1oTZ_X7Pp4NY
 zIBXeZwLasQQQnoSyI7HOl.19jnRTnTyvw1MWGuio4gout4bSAsy4y01nKhSIL.W3NO8j4vL0ygr
 45lOlVa8AVXwH3sN5R3a0EMesBaUl3QFLg6QzZKwuOt_RVoA6zvH2LpIADf5nbcUZlIpK20q3u5Z
 JHsTO5gz7TzSUhrKqaFMFN0FaxVrZXoCuM0XpCoMfpf7oY29VjugWmAhcwuND6eORKe7Laq7wUNq
 2TdRSygRRdwIAiWLyDTDYBzz_CquYr8ZV.6R_IlbZqcjnwI6XlhHmMUkwD5coy99EcLM.Xrqo7DZ
 NKIi3QOnQTErf5U78Zv9YHEavgYwugc_xMUi7xxzFyGlMG7lh7Tk3pitaeqsU7P6mPP9uQTxqNY7
 mQ_yRhF37DrCkl2ZDRjcpqeSsC5uK0WMowLit1BLa5OZS._Y85ZRqH0maRb6cp4jCsP19RephZPW
 9W84-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.ne1.yahoo.com with HTTP; Wed, 20 May 2020 20:33:46 +0000
Date:   Wed, 20 May 2020 20:33:42 +0000 (UTC)
From:   Rose Gordon <rosegordonor@gmail.com>
Reply-To: rosegordonor@gmail.com
Message-ID: <1423033643.49505.1590006822030@mail.yahoo.com>
Subject: Hi there
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1423033643.49505.1590006822030.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15959 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:72.0) Gecko/20100101 Firefox/72.0
To:     unlisted-recipients:; (no To-header on input)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Best of the day to you I'm Rose by name 32years old single lady, Can we be friends? i was born and raised in london in United Kingdom Take care Rose.
