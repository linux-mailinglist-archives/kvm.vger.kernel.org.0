Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09CB4578E2
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 03:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbfF0BLs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 21:11:48 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50642 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726606AbfF0BLs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 21:11:48 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5R19nB5000896;
        Thu, 27 Jun 2019 01:11:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=TIOuSGHtb/ocKkJpBewddOrFIlnobqZYYn9hycu74Ys=;
 b=SOrsLcJ+rJDklIv940/yg1jzZwkPBdStjsllTDGRxZXZiQVpxsZGK7zlZgeBigePA5lp
 EiwDAzfU7Lf/++6qk+N32dis2nVoaC2mTLK+DhdW0c2ImuggGO3SG4e8JwZlIPpHFbua
 azZPP21z2YjFceo5EmwR4ICo6nXEZoIiMo35Pvk9vUB6X1NUWlKYgtQZRoX0fuaJp1Wu
 iaHSLZJayA8+LEiY3Sov3g7Ry2bEi1ECyA+Mbz/8mDJc/AUIUZOuyy62y9qR/tk5+xEP
 Eq8aRpkMnDkcLA4mH0pgwMP84syfPUVB/AXPnJvb563QjoSX17XH7YfT1DQxvArU3oJg Bw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2t9cyqn8t9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 01:11:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5R1AmfN120872;
        Thu, 27 Jun 2019 01:11:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2t9p6v2kmn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 01:11:35 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5R1BXYY025170;
        Thu, 27 Jun 2019 01:11:33 GMT
Received: from localhost.localdomain (/10.159.235.117)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Jun 2019 18:11:33 -0700
Subject: Re: [kvm-unit-tests PATCH] x86: Mark APR as reserved in x2APIC
To:     Marc Orr <marcorr@google.com>
Cc:     Nadav Amit <nadav.amit@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20190625120627.8705-1-nadav.amit@gmail.com>
 <367500e0-c8f8-f7ca-7f07-5424a05eea80@oracle.com>
 <CAA03e5G7kn3UYjZzRUsJScDJ=cBmqO-pdDm5Ri180vyi-vRa2A@mail.gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <4c5ce63b-b5c7-b658-3754-99a0f8bfbbca@oracle.com>
Date:   Wed, 26 Jun 2019 18:11:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAA03e5G7kn3UYjZzRUsJScDJ=cBmqO-pdDm5Ri180vyi-vRa2A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906270011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906270011
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/26/19 5:14 PM, Marc Orr wrote:
> On Wed, Jun 26, 2019 at 3:32 PM Krish Sadhukhan
> <krish.sadhukhan@oracle.com> wrote:
>>
>> On 6/25/19 5:06 AM, Nadav Amit wrote:
>>> Cc: Marc Orr <marcorr@google.com>
>>> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
>>> ---
>>>    lib/x86/apic.h | 1 +
>>>    1 file changed, 1 insertion(+)
>>>
>>> diff --git a/lib/x86/apic.h b/lib/x86/apic.h
>>> index 537fdfb..b5bf208 100644
>>> --- a/lib/x86/apic.h
>>> +++ b/lib/x86/apic.h
>>> @@ -75,6 +75,7 @@ static inline bool x2apic_reg_reserved(u32 reg)
>>>        switch (reg) {
>>>        case 0x000 ... 0x010:
>>>        case 0x040 ... 0x070:
>>> +     case 0x090:
>>>        case 0x0c0:
>>>        case 0x0e0:
>>>        case 0x290 ... 0x2e0:
>>
>>    0x02f0 which is also reserved, is missing from the above list.
> 0x02f0 is "LVT CMCI register", right?


That's right.

