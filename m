Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2EC6F774D
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 16:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbfKKPAb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 10:00:31 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45704 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727136AbfKKPAb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 10:00:31 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABEmXYx144677;
        Mon, 11 Nov 2019 14:59:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=lOs4Q755rWn2yin72lVv51mq0OtKjhD3FBFGWHRvPig=;
 b=dIrSy8/AGjkkTWZ+Nfz4Uu6MBenA7ggIrP9bI8bSzjpdxYV3z6HFxFDyABTYjP2eUa6T
 PcRB1HA2TmYOcCDu+0h+1cYk8+DIy0pvFPW5S9Az9ml2V1JzfTZZ4EsyZo+yYPjD76sC
 PM0BvAzttOOD6KdgMHHIgv/NYCloDsoLWhkp094+yVAQS/PKdeslE4a1Q4EA4H0Dk++Q
 x38ga1YUVMuSn0wcX8ivHgJ/X6BUV7htmFdkVyUoTo7GOMFOu+UC5DKHann4LFA62dzY
 TfUY90p/E1Y9iNnQZ/QYFYyre30BBBdHZCs6AHXo+4RQg0kmc4+T/W9rn7odTTYtps/P TA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2w5mvtfg5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 14:59:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABEmNYt175996;
        Mon, 11 Nov 2019 14:59:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2w6r8jrstx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 14:59:27 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xABExPxL011909;
        Mon, 11 Nov 2019 14:59:26 GMT
Received: from [192.168.14.112] (/79.182.207.213)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Nov 2019 06:59:25 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH v1 2/3] KVM: VMX: Do not change PID.NDST when loading a
 blocked vCPU
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <b61dc2b2-14be-4d4f-f512-5280010d930a@oracle.com>
Date:   Mon, 11 Nov 2019 16:59:20 +0200
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jag Raman <jag.raman@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <4E05E5FC-0064-47DE-B4B2-B3BDAF23C072@oracle.com>
References: <20191106175602.4515-1-joao.m.martins@oracle.com>
 <20191106175602.4515-3-joao.m.martins@oracle.com>
 <15c8c821-25ff-eb62-abd3-8d7d69650744@redhat.com>
 <314a4120-036c-e954-bc9f-e57dee3bbb7c@oracle.com>
 <49912d14-1f79-2658-9471-4193807ad667@redhat.com>
 <b61dc2b2-14be-4d4f-f512-5280010d930a@oracle.com>
To:     Joao Martins <joao.m.martins@oracle.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=980
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911110137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911110137
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 11 Nov 2019, at 16:56, Joao Martins <joao.m.martins@oracle.com> =
wrote:
>=20
> On 11/11/19 2:50 PM, Paolo Bonzini wrote:
>> On 11/11/19 15:48, Joao Martins wrote:
>>>>>=20
>>>>> Fixes: c112b5f50232 ("KVM: x86: Recompute PID.ON when clearing =
PID.SN")
>>>>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>>>>> Signed-off-by: Liran Alon <liran.alon@oracle.com>
>>>> Something wrong in the SoB line?
>>>>=20
>>> I can't spot any mistake; at least it looks chained correctly for =
me. What's the
>>> issue you see with the Sob line?
>>=20
>> Liran's line after yours is confusing.  Did he help with the analysis =
or
>> anything like that?
>>=20
> He was initially reviewing my patches, but then helped improving the =
problem
> description in the commit messages so felt correct to give credit.
>=20
> 	Joao

I think proper action is to just remove me from the SoB line.

-Liran=
