Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0BA8BF527
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 16:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727200AbfIZOhk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 10:37:40 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47042 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727116AbfIZOhj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 10:37:39 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8QEXxBQ098149;
        Thu, 26 Sep 2019 14:37:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=/n09d61ZP+RAVBYSmOAXG9FxB4/deQHBW2k6e6Xhu3M=;
 b=BUvUSBDSTzxkaKOxbPkxqAt+auIPf3exnZvvcbViihIZXkCNJMD0QXb4llVZTQCb2+1+
 AoKX940i24geG2aiQTvDX7XGt0wz9HNqGEnSdZCdu7sSOvOn++bhuqdsumd1XKRRivtR
 c826Pzuvx3qJYoNx8bjEkDBqGeL8OY1yVBa1Pl1BGiQqBl0myFoJfJ73wXJBZaoYgsmV
 t/r0tSRN4TtpqfsoniCtOJA5zKOBTnZtjNRTa7a8qs/kTlXzJRhN4VZPwv7JNMSMXcA7
 r7/Mf1wvH4/chhPPgesbesedWKhE5VIh0+c5qO0hf3uK5iiKAV8KLwjLzwq/lVwakUG4 /w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2v5b9u4974-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Sep 2019 14:37:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8QET7LE157490;
        Thu, 26 Sep 2019 14:35:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2v8rvtcexx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Sep 2019 14:35:25 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8QEZO4o025208;
        Thu, 26 Sep 2019 14:35:24 GMT
Received: from [192.168.14.112] (/79.179.213.143)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 26 Sep 2019 07:35:24 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [kvm-unit-tests PATCH v7 2/2] x86: nvmx: test max atomic switch
 MSRs
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20190926143201.GA4738@linux.intel.com>
Date:   Thu, 26 Sep 2019 17:35:19 +0300
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Orr <marcorr@google.com>,
        kvm@vger.kernel.org, jmattson@google.com, pshier@google.com,
        krish.sadhukhan@oracle.com, rkrcmar@redhat.com, dinechin@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <5B33C98B-E58D-460B-A9C3-CBE25077FA92@oracle.com>
References: <20190925011821.24523-1-marcorr@google.com>
 <20190925011821.24523-2-marcorr@google.com>
 <91eb40a0-c436-5737-aa8a-c657b7221be2@redhat.com>
 <20190926143201.GA4738@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=996
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909260134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909260135
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 26 Sep 2019, at 17:32, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> On Thu, Sep 26, 2019 at 11:24:57AM +0200, Paolo Bonzini wrote:
>> On 25/09/19 03:18, Marc Orr wrote:
>>> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
>>> index 694ee3d42f3a..05122cf91ea1 100644
>>> --- a/x86/unittests.cfg
>>> +++ b/x86/unittests.cfg
>>> @@ -227,7 +227,7 @@ extra_params =3D -cpu qemu64,+umip
>>>=20
>>> [vmx]
>>> file =3D vmx.flat
>>> -extra_params =3D -cpu host,+vmx -append "-exit_monitor_from_l2_test =
-ept_access* -vmx_smp* -vmx_vmcs_shadow_test"
>>> +extra_params =3D -cpu host,+vmx -append "-exit_monitor_from_l2_test =
-ept_access* -vmx_smp* -vmx_vmcs_shadow_test =
-atomic_switch_overflow_msrs_test"
>>> arch =3D x86_64
>>> groups =3D vmx
>>=20
>> I just noticed this, why is the test disabled by default?
>=20
> The negative test triggers undefined behavior, e.g. on bare metal the
> test would fail because VM-Enter would succeed due to lack of an =
explicit
> check on the MSR count.
>=20
> Since the test relies on somehwat arbitrary KVM behavior, we made it =
opt-in.

Just note that when commit 5ac120c23753 ("x86: vmx: Test INIT processing =
during various CPU VMX states=E2=80=9D)
was merged to master, it was changed to accidentally remove =
=E2=80=9C-atomic_switch_overflow_msrs_test=E2=80=9D.
(Probably a merge mistake).

So this should be fixed by a new patch :P

-Liran

