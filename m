Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8DE1AE3AA
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 19:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729952AbgDQRTH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 13:19:07 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59642 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728687AbgDQRTE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Apr 2020 13:19:04 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03HHINbo186809;
        Fri, 17 Apr 2020 17:19:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=25HeETnDnR2PxQjlyV33fajnIc7liEYzX8aI8+mpJN4=;
 b=SKG/dESlO0VfeT6yPL0/D3K0yazC/I/byZ8MFk3LusNAxgSL6NSbbNL0sFUJrFzkKBQR
 gQdx/HPf6oYtifk2zCnY+BgFn1YmuvvuwCN2fas6606gnw40H+KTsgHc/kRxgVH3misw
 L58JW6FAoq2yc6nu1t5nSPj+7Z38K72g0SHqGATEhXjvZ0CGxrLPGu0LQyjnjboMMvSq
 jd8alQ1OpygCBeW6orl/+PkdBt7LkiXg6B78RjHDKO+IiIfCivcBmlXiYkl2IMJAfJwY
 l5BY3efHPAMY496bYFZnYioAwP36EnXhUW2zdFkCoQ/ijfedfSyb6rqAtryydlPxrDf6 AQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30dn960aav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 17:19:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03HHHK6N169775;
        Fri, 17 Apr 2020 17:18:59 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 30dn91w4k2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 17:18:59 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03HHIwSG016869;
        Fri, 17 Apr 2020 17:18:58 GMT
Received: from localhost.localdomain (/10.159.153.74)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Apr 2020 10:18:58 -0700
Subject: Re: [kvm-unit-tests PATCH] nVMX: Add testcase to cover VMWRITE to
 nonexistent CR3-target values
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org
References: <20200416162814.32065-1-sean.j.christopherson@intel.com>
 <d0423845-db40-b9ce-62b7-63bc36006a28@oracle.com>
 <0b673c58-0440-883e-2a29-b06603e49aad@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <1ca58cca-48b2-f981-4d25-cd25609b9f17@oracle.com>
Date:   Fri, 17 Apr 2020 10:18:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <0b673c58-0440-883e-2a29-b06603e49aad@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9594 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004170133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9594 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 mlxscore=0 phishscore=0 spamscore=0 impostorscore=0 suspectscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004170133
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/17/20 12:00 AM, Paolo Bonzini wrote:
> On 17/04/20 03:35, Krish Sadhukhan wrote:
>> On 4/16/20 9:28 AM, Sean Christopherson wrote:
>>> Enhance test_cr3_targets() to verify that attempting to write CR3-target
>>> value fields beyond the reported number of supported targets fails.
>>>
>>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>>> ---
>>>    x86/vmx_tests.c | 4 ++++
>>>    1 file changed, 4 insertions(+)
>>>
>>> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
>>> index 1f97fe3..f5c72e6 100644
>>> --- a/x86/vmx_tests.c
>>> +++ b/x86/vmx_tests.c
>>> @@ -3570,6 +3570,10 @@ static void test_cr3_targets(void)
>>>        for (i = 0; i <= supported_targets + 1; i++)
>>>            try_cr3_target_count(i, supported_targets);
>>>        vmcs_write(CR3_TARGET_COUNT, cr3_targets);
>>> +
>>> +    /* VMWRITE to nonexistent target fields should fail. */
>>> +    for (i = supported_targets; i < 256; i++)
>>> +        TEST_ASSERT(vmcs_write(CR3_TARGET_0 + i*2, 0));
>>>    }
>>>      /*
>> We don't need VMREAD testing ?
> Patches are welcome. :D
>
> Paolo
>
OK, I will send it along with my next test patch :-)

Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
