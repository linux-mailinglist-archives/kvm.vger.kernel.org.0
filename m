Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE2F6C2B59
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 02:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbfJAAeM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 20:34:12 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43260 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfJAAeM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 20:34:12 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x910TTEq025765;
        Tue, 1 Oct 2019 00:33:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=7buIYWeANCPzGO4QVzUABuMvzE5lzUjOHCrOGz6nBkY=;
 b=JygfBir/3e/zpsS19b289YHEc3zdaeCLzW+rkKk2uYLDxt6srdO0tprLQ8M99Z28OzE2
 yRL95VcTNfvCK8vk0K2b7SDKOeTrq+j1X+PtR2loo+V20/dek/mOGuWytDUMkiU+5Vs0
 V3citIF29dRtHCgmNKq10mxwniXPz9fVsIdkcVH4RtS589gqluC31s3fHcMJB1kO08Bc
 5WlAoPt2iBazUWo102cWeaIx9KXSuNpyCsmM/wHEnlvjKe1X0bIIZ97ZpzLXy+nini2u
 M2X8C4nxPZhVZ3e0ghLDf6x09qnuDQSSJXhAz8EOsmqxWtdFPwBLK27qKz35eyr3pFtB rw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2va05rjeqj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 00:33:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x910Swqc040727;
        Tue, 1 Oct 2019 00:33:47 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2vbqcyvx5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 00:33:47 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x910Xkx1006772;
        Tue, 1 Oct 2019 00:33:46 GMT
Received: from [192.168.14.112] (/79.183.234.224)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Sep 2019 17:33:46 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] KVM: VMX: Remove proprietary handling of unexpected
 exit-reasons
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20190930172038.GE14693@linux.intel.com>
Date:   Tue, 1 Oct 2019 03:33:42 +0300
Cc:     Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, tao3.xu@intel.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm list <kvm@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <2299BCA8-8FEF-4857-9680-8CE3E58034A6@oracle.com>
References: <20190929145018.120753-1-liran.alon@oracle.com>
 <874l0u5jb4.fsf@vitty.brq.redhat.com>
 <CALMp9eS7wF1b6yBJrj_VL+HMEYjuZrYhmMHiCqJq8-33d9QE6A@mail.gmail.com>
 <20190930172038.GE14693@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910010004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910010004
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 30 Sep 2019, at 20:20, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> On Mon, Sep 30, 2019 at 09:35:59AM -0700, Jim Mattson wrote:
>> On Mon, Sep 30, 2019 at 12:34 AM Vitaly Kuznetsov =
<vkuznets@redhat.com> wrote:
>>>=20
>>> Liran Alon <liran.alon@oracle.com> writes:
>>>=20
>>>> Commit bf653b78f960 ("KVM: vmx: Introduce handle_unexpected_vmexit
>>>> and handle WAITPKG vmexit") introduced proprietary handling of
>>>> specific exit-reasons that should not be raised by CPU because
>>>> KVM configures VMCS such that they should never be raised.
>>>>=20
>>>> However, since commit 7396d337cfad ("KVM: x86: Return to userspace
>>>> with internal error on unexpected exit reason"), VMX & SVM
>>>> exit handlers were modified to generically handle all unexpected
>>>> exit-reasons by returning to userspace with internal error.
>>>>=20
>>>> Therefore, there is no need for proprietary handling of specific
>>>> unexpected exit-reasons (This proprietary handling also introduced
>>>> inconsistency for these exit-reasons to silently skip guest =
instruction
>>>> instead of return to userspace on internal-error).
>>>>=20
>>>> Fixes: bf653b78f960 ("KVM: vmx: Introduce handle_unexpected_vmexit =
and handle WAITPKG vmexit")
>>>>=20
>>>> Signed-off-by: Liran Alon <liran.alon@oracle.com>
>>>=20
>>> (It's been awhile since in software world the word 'proprietary' =
became
>>> an opposite of free/open-source to me so I have to admit your =
subject
>>> line really got me interested :-)
>>>=20
>>> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>>=20
>> I agree that proprietary is an unusual word choice.
>=20
> It's one way to get quick reviews though :-)

OK Ok I apologise for my bad English. ^_^
Paolo, feel free to reword this commit title & message to something else =
when applying=E2=80=A6

-Liran
=20

