Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E22DF19636D
	for <lists+kvm@lfdr.de>; Sat, 28 Mar 2020 04:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgC1Dxk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Mar 2020 23:53:40 -0400
Received: from sonic310-15.consmr.mail.bf2.yahoo.com ([74.6.135.125]:38961
        "EHLO sonic310-15.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726225AbgC1Dxk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Mar 2020 23:53:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1585367619; bh=JAz8LFM6+4vHSsVAr/FuzFq2ArGEZnuE2vSkhU1Q0cc=; h=Date:From:Reply-To:Subject:References:From:Subject; b=aqjFR33+hKOWhOqoYHnG88iO1o70G8zAuo1p4AshQs4Xo6R+GCotwYkaclPxu37aKONvHaG63IEDjjjVZ1wsqqNofuJI7euep4Y1nP3EkRLmT9TQjsiF/IG7fLI36u8vHmrdmU2y+GjE3NNzphzAEckoNjr2NWApGo+hx69eVSbW8dH4ZxNcH6qotpKhlzqpwwLi0npY8Y0d+nHVeoMNl1MxR4272r6HQSjHJr9IGHm4oFzrJYPDk67I7BSx1SBe9fvSaBPOdaC3Lw+SihZW3TOgpHCiG7o292WKhlQ7bxmFRpo5fsY68Kmun3Vz+2h4Hh4iTjEkEw5rPIIZUsiQDQ==
X-YMail-OSG: mlg_8SQVM1nLdOooP3pwusi50D_zV..JAnItx3IzEGkg6McKCwfHQvd9HEJSqmL
 IEGJD6tpwRnbKDw8pA5fRf22FP0YuCwBR.iUgZX_i8e9HxjL2a.WoaKIgNhF_QhMUHd__jG80exE
 P.cNfZ8bfQy0zmJvoAvX9DZ1kO0VRj1HHp0uyF1H2F3DgT5o02zTvKN8sdEixa2jn1zX7Ct0niGq
 CRnwEXCoWPAVw6cgrc5g7GpPAfY6p2kg2FThNzvaDXJOsAY2oyrU4oddghQ7p_VWq1FM8QS3x5Xw
 .KD4IaCiG06oz7VXshbmO5OkL2DlH3lsc.WfHMIL4Cp8YrIv7E.Po4khafCZkot1ErTN.GQglQfk
 3W_eipbxSXD1L7XB2sZNHIzbOy4st0n9rkvmu38dtFqkssDkWIKsKXSV4X1MAyayY7SV5oCie8S8
 ctYEQAVvB6QVVxDvMjOgM4zsKjsudt8WhjAZqTeIxv4uTWHqtg9djK5ClKDx7MF63yKugQEq2K4S
 JnpRcc3tjpCONU8Yx0u2GgQ4TQEVGBpsKjvtvwAoOaQKY9_eb5AzBg5F50MysiRg_F5ILSZEMl2W
 lrDskeSwXjPn4GMGzPy5e4DVX8nwib8DoUNaTlU9vx5A6Z.KpXXL0qNfKu.SrGquUful_jfr7KWt
 lHj4jElxCu16hB9ZLHMGFFcRhmXLzoMcXoIJjpPBuMAT6IN.5aw7_xoXVmfSHD1nDLYeqbg9vkrY
 x_2mmd0Canu8iKG4m5r4fcM_srMUKIaXTXDFU1U9QExERLe0MNEtntlO94kGXk7xfbMvqkl8.k6M
 BbBWCbGxkRkHttzL1iJ09EJDPtWLznMnSyy2NB0OCfavs4.aPOwTxSZ3NBsW5z0BMGqEyqAAHhhU
 uXUnHHAGZpPF4TpdfVT94h7ddf3BDulo0v8ZuF6q.2EZZejVK9CsHD82pTucuOD55_Vtqc3lN.jU
 qPc6ljZ0giKMSvjYiZBhvTsufiyV5ij_q6WspyKYxrcaQIUEfDSuM6897QPcqzRh9zdQLsXNTx3t
 Rlrz78qIhvGc9b0gD25UsxtERd9xNVnXGJKTmvRI0LnC6LWhRgzC8r8esxMI4EkxW7uIoCKuLmp.
 1hIft0pgCfEIU.cLioddHc1j6SpJHq6hgtN_X00zAfkhsVgOQXUm6K3ysDmfm183HmHapdhSniOL
 4ZU.lKlBrrY99ueMkCoaUgm69Bcbr4sd_u16LuNbgsR8l.QQ56H8MPEf8aXg2M5CPORoE0eBjKpJ
 TJtzcxgxJWpbgQaXSroJBfNsoFk9rBvv01SZENVFObqggXRbAIyGr9o.YUcALsZbCYMfzXAE1
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.bf2.yahoo.com with HTTP; Sat, 28 Mar 2020 03:53:39 +0000
Date:   Sat, 28 Mar 2020 03:53:36 +0000 (UTC)
From:   Islam Koudougou <islamkoudougou1@gmail.com>
Reply-To: islamkoudougou2020@gmail.com
Message-ID: <307875094.110371.1585367616794@mail.yahoo.com>
Subject: i need your urgent help and assistance
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <307875094.110371.1585367616794.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15555 YMailNodin Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.149 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Dear  Friend.

I am Mr Islam Koudougou. the director of the accounts & auditing department at  the  bank Ouagadougou-Burkina Faso in west Africa. With due respect, I have decided to contact you on a business transaction that will be beneficial to both of us.

At the bank's last accounts/auditing evaluations, my staffs came across an old account which was being maintained by a foreign client who we learn was among the deceased passengers of motor accident on November.2003, the deceased was unable to run this account since his death. The account has remained dormant without the knowledge of his family since it was put in a safe deposit account in the bank for future investment by the client.

Since his demise, even the members of his family haven't applied for claims over this fund and it has been in the safe deposit account until I discovered that it cannot be claimed since our client is a foreign national and we are sure that he has no next of kin here to file claims over the money. As the director of the department, this discovery was brought to my office so as to decide what is to be done.I decided to seek ways through which to transfer this money out of the bank and out of the country too.

The total amount in the account is ten million five hundred thousand dollars (USD 10,500,000.00).with my positions as staffs of the bank, I am handicapped because I cannot operate foreign accounts and cannot lay bonafide claim over this money. The client was a foreign national and you will only be asked to act as his next of kin and I will supply you with all the necessary information and bank data to assist you in being able to transfer this money to any bank of your choice where this money could be transferred into.

The total sum will be shared as follows: 50% for me, 50% for you and expenses incidental occur during the transfer will be incur by both of us. The transfer is risk free on both sides hence you are going to follow my instruction till the fund transfer to your account.Since I work in this bank that is why you should be confident in the success of this transaction because you will be updated with information as at when desired.

I will wish you to keep this transaction secret and confidential as I am hoping to retire with my share of this money at the end of transaction which will be when this money is safety in your account. I will then come over to your country for sharing according to the previously agreed percentages. You might even have to advise me on possibilities of investment in your country or elsewhere of our choice. May God help you to help me to a restive retirement, Amen.

Please for further information and inquires feel free to contact me back immediately for more explanation and better understanding I want you to assure me your capability of handling this project with trust.

Thanks and remain blessed
Mr Islam Koudougou.
