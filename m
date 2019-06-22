Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6065B4F640
	for <lists+kvm@lfdr.de>; Sat, 22 Jun 2019 16:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbfFVOiL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Jun 2019 10:38:11 -0400
Received: from sonic303-2.consmr.mail.bf2.yahoo.com ([74.6.131.41]:44234 "EHLO
        sonic303-2.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726276AbfFVOiL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 22 Jun 2019 10:38:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1561214289; bh=3fXYToOZXvh5MOJ1JSawYDThjnynC/Ekt2gucIg6zZg=; h=Date:From:Reply-To:Subject:From:Subject; b=drNAGbXF8Rm0D1utDg11UciDUgVYypm0wXEUkBEmLoKGzwbruQAQSip9D6U+70o7XTNb+xV2MzT4sFIiC6BwPo3bK1X1HoL/BTLKkK8Kt8nHoxS7+hUtooyIh6UDYB8cXE6Qdtqm0Iy31yy4lmazVUPDcoThXTIWc+om04kxd3yvep2zvqItqzFJS+irfPglP/a684mulTq9qpDA4Ec6JSMRohiayaYJbn+Q8CwfnzbAyLD8vzpxK6XI1mVBknIK2wcUdkJobbtNO8gEM0Y3ua4TgFIosU525yG70DpJgFP2luRHIuiWbPDw6JDBbGezX306Pa8u+WxFcLejM2jptg==
X-YMail-OSG: jgN7BSMVM1k1hG5xptM9CZs7jNUXn8Z2QkzXMMoZGwowejlx0pgYzJi4IJJekUK
 PyhPoCZvGvxf7jkyfvcFh4YstunywgsVDpeHnHyOrq4_kZIlxqI58U4AlwECjPrNgUkK56HoV0SR
 udEJanEurUew74KAmJ0yD533R597p5spd2jiL3GA2hP.aJOZXfkfHXZHEjmWr5nPKVbUlUAIz1ky
 inRlQiIoFwduKfLRWKowgVGVbvSlPCUsm3mDTSULFmFzobLgTzwL0.Vwtq9QaqRf54xG7E3AZ4dD
 CJaiXWSZJo0wNMqiBxkssMis_w2MmtS3HYcUSEe.NY_.yJpQ.cOrHg09hk2R.obcFbCdLY2bsekO
 Xvlwb_YOkv3CNZNLkGPfyzj1zhfSC9sD_jtDdvVbWqTAkVU0cyS3YyqTzvC8aY4.dKLVX36Nvbrn
 uKA8bOUaD_Xt2TYtlQJxz4usUjE7QO08jwKysv_Bxqx7egiG2vyMEETv9Yx6q.2WElH2UtxnXcII
 EMXRXhcdKLl9Nu5ydnKFhI7.gOyZ8CN6F3BjdYYamU6Q6PRmky7wf3AiKFxN1260vJD0_9h3udZU
 VkQtm2My.FbbC87IPbND32ShHpA0L6N9KJWWj4Pbg1W3CBj8q5VVab10lel9vPOgjQgVbCoodxwX
 RTM6FurZMIte2EporPZNPMus9Pqg7kt7Ggr1P.0mWS1j3XRmljI.yQRYmepdvEXFi1.Srn6JfCr4
 AxTKnlE0_Mymj49moFwkAsHckQPF2xY5xDEH1vDZqCqK4TdRLvlm1U_2I8o_.XIRwAFdOzzDujvT
 0ItoG_izcQjwggH12etti8976ChXDVeSx76eeZQlDamDcPl4bLLliZlH.15EYPRq2ubex8I6DPUO
 cg49_vZc4XY..N9kKtswGiB4pikzQ59MnjvJfhk2P8RmVyki.aQZc9pNmmN8wkXyS3UbPuhqSzWa
 o1cKUwkUqe8Au6odheu08qpV3zvkN2pugTemjM7xY5OhgcaC_RCkIcl39q9XLyYK6qKMctpsLcnE
 m1RvA9B6K8ye4De7He3Pl9RnO60dIYDduimdSx36B9KR__mY2hMjGjSn3Ae8zMwgkJ92_tzExVgp
 IB8iuy7kcVAcC3zm5HHGL4HTHPYdBVCids4T1IASXMA1dhLqsraIm9cTwW7gkRS5SMZlZbeTDI7p
 b1ZSxNCl33r848.oYj5Hmn8Vy01yOZiIbRMWK8XE5x6ejJn9htUapTtZg
Received: from sonic.gate.mail.ne1.yahoo.com by sonic303.consmr.mail.bf2.yahoo.com with HTTP; Sat, 22 Jun 2019 14:38:09 +0000
Date:   Sat, 22 Jun 2019 14:38:06 +0000 (UTC)
From:   "Miss.Fatima Yusuf" <fatimayusuf5@outlook.fr>
Reply-To: miss.fmayusuf11@gmail.com
Message-ID: <1358850798.259423.1561214286867@mail.yahoo.com>
Subject: From:Miss: Fatima Yusuf.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To:     unlisted-recipients:; (no To-header on input)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



From:Miss: Fatima Yusuf.

For sure this mail would definitely come to you as a surprise, but do take your good time to go through it, My name is Ms. Fatima Yusuf,i am from Ivory Coast.

I lost my parents a year and couple of months ago. My father was a serving director of the Agro-exporting board until his death. He was assassinated by his business partners.Before his death, he made a deposit of US$9.7 Million Dollars here in Cote d'ivoire which was for the purchase of cocoa processing machine and development of another factory before his untimely death.

Being that this part of the world experiences political and crises time without number, there is no guarantee of lives and properties. I cannot invest this money here any long, despite the fact it had been my late father's industrial plans.

I want you to do me a favor to receive this funds into your country or any safer place as the beneficiary, I have plans to invest this money in continuation with the investment vision of my late father, but not in this place again rather in your country. I have the vision of going into real estate and industrial production or any profitable business venture.

I will be ready to compensate you with 20% of the total Amount, now all my hope is banked on you and i really wants to invest this money in your country, where there is stability of Government, political and economic welfare.

My greatest worry now is how to move out of this country because my uncle is threatening to kill me as he killed my father,Please do not let anybody hear about this, it is between me and you alone because of my security reason.

I am waiting to hear from you.
Yours Sincerely,
Miss.Fatima Yusuf.
