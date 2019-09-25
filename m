Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7E94BE94B
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 01:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387503AbfIYX5i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 19:57:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35156 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728647AbfIYX5i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 19:57:38 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PNs7ug154859;
        Wed, 25 Sep 2019 23:57:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=/Z3F0xZou+NMPelTAx6uGohmp6R8/bzA9Mw+ZI1ipCs=;
 b=q4T/fiHrMILZ1x3rCn/R1a+MWy/4YdS82V6l6djazee0aFyMazlKQoNGXgKcENMOIzNA
 NwDqTLWl7ZHu5NP2Gjfv4L4hloff7P++xgGwnhjEIt2Gze51tK+vTc8rBWMnLjEuOxs/
 6AYUoIDZiQ4L2oRJ5YGi6qSo9181XMVGP6k7KTRhLrznVTXQXNeO/5bQVDq7cJ2mJoQT
 2+SNGwYPkKYY13TGxKU4Ncz/QN2JXu6FVKRFLNOl5tAebJw9RlV3KMAx6nQoSasixRE/
 5f79EEgUq++N1EYWSyfSYIpf+f0XwK4APgroZ65rQtBoqXckA0d29CdoUulpWGdThE31 rw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2v5b9tyxvu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 23:57:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PNs62b127331;
        Wed, 25 Sep 2019 23:57:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2v7vp0203f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 23:57:26 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8PNvOvd029707;
        Wed, 25 Sep 2019 23:57:25 GMT
Received: from [192.168.14.112] (/79.183.224.28)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 16:57:24 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH kvm-unit-tests 0/8]: x86: vmx: Test INIT processing in
 various CPU VMX states
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <5bcc595a-fffd-616c-9b68-881c0151fe3d@redhat.com>
Date:   Thu, 26 Sep 2019 02:57:21 +0300
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        sean.j.christopherson@intel.com, jmattson@google.com,
        rkrcmar@redhat.com, kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <AED9AA6A-5E62-4F67-A148-14966B71EB08@oracle.com>
References: <20190919125211.18152-1-liran.alon@oracle.com>
 <87a7b09y5g.fsf@vitty.brq.redhat.com>
 <8A53DB10-E776-40CC-BB33-0E9A84479194@oracle.com>
 <5bcc595a-fffd-616c-9b68-881c0151fe3d@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250196
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250196
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo, I have noticed that all the patches of these series were merged =
to origin/master
besides the last one which adds the patch itself.

Have you missed the last patch by mistake?

-Liran

> On 24 Sep 2019, at 18:42, Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> On 24/09/19 17:34, Liran Alon wrote:
>> Gentle ping.
>=20
> I'm going to send another pull request to Linus this week and then =
will
> get back to this patch (and also Krish's performance counter series).
>=20
> Paolo
>=20
>>> On 19 Sep 2019, at 17:08, Vitaly Kuznetsov <vkuznets@redhat.com> =
wrote:
>>>=20
>>> Liran Alon <liran.alon@oracle.com> writes:
>>>=20
>>>> Hi,
>>>>=20
>>>> This patch series aims to add a vmx test to verify the =
functionality
>>>> introduced by KVM commit:
>>>> 4b9852f4f389 ("KVM: x86: Fix INIT signal handling in various CPU =
states")
>>>>=20
>>>> The test verifies the following functionality:
>>>> 1) An INIT signal received when CPU is in VMX operation
>>>> is latched until it exits VMX operation.
>>>> 2) If there is an INIT signal pending when CPU is in
>>>> VMX non-root mode, it result in VMExit with (reason =3D=3D 3).
>>>> 3) Exit from VMX non-root mode on VMExit do not clear
>>>> pending INIT signal in LAPIC.
>>>> 4) When CPU exits VMX operation, pending INIT signal in
>>>> LAPIC is processed.
>>>>=20
>>>> In order to write such a complex test, the vmx tests framework was
>>>> enhanced to support using VMX in non BSP CPUs. This enhancement is
>>>> implemented in patches 1-7. The test itself is implemented at patch =
8.
>>>> This enhancement to the vmx tests framework is a bit hackish, but
>>>> I believe it's OK because this functionality is rarely required by
>>>> other VMX tests.
>>>>=20
>>>=20
>>> Tested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>>>=20
>>> Thanks!
>>>=20
>>> --=20
>>> Vitaly
>>=20
>=20

