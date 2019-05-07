Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC0B16DCE
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 01:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbfEGXXh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 19:23:37 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39028 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbfEGXXg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 May 2019 19:23:36 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x47NJ1hi107154;
        Tue, 7 May 2019 23:23:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=rJXSgj6cFMra5Wryh7XT72Jj3fdPuPP/81WeLPq7k+U=;
 b=FeAYN9sIyIPg98+Hj+CqLGQo7vzsPZfERpMRhpk1wlxOIkjnQFi13oqD3+2TQ1oKsEr+
 WsshddUqK3218r+WQKsL2obguGXetdbFcoKphqcm7ZibPmVL8Ger2acUmKKUJtLiFCcJ
 rpZqiJhkFiD9sLQRgAtNvpG3XsZSRqm03T0Raqx6u1rLE2ZsemvQ25m1hqfrsdVzZo4D
 6E8wF9bvkCsiBiunwYA08ApVjvcHePSKKRp75nqwlP0mSVsYoJcWQaO4D1im+RH2633c
 l507RC1QurOs6PuU46NVol/YmAVNXiYew2pYnHX9vBj/fpWXDg+KgPAdydhLjT2+MXU2 nw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2s94b0rh5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 May 2019 23:23:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x47NNJx7065725;
        Tue, 7 May 2019 23:23:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2s94afrvkt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 May 2019 23:23:33 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x47NNXkU023537;
        Tue, 7 May 2019 23:23:33 GMT
Received: from [192.168.14.112] (/109.65.236.43)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 May 2019 16:23:32 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [Bug 203543] New: Starting with kernel 5.1.0-rc6,  kvm_intel can
 no longer be loaded in nested kvm/guests
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <bug-203543-28872@https.bugzilla.kernel.org/>
Date:   Wed, 8 May 2019 02:23:29 +0300
Cc:     kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <80CB120B-1015-4B10-BD99-14102E245068@oracle.com>
References: <bug-203543-28872@https.bugzilla.kernel.org/>
To:     bugzilla-daemon@bugzilla.kernel.org
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9250 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905070144
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9250 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905070145
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If I would have to guess, I would blame my own commit:
e51bfdb68725 ("KVM: nVMX: Expose RDPMC-exiting only when guest supports =
PMU=E2=80=9D)

As in kvm_intel=E2=80=99s setup_vmcs_config() it can be seen that =
CPU_BASED_RDPMC_EXITING is required in order for KVM to load.
Therefore, I assume the issue is that now L1 guest is not exposed with =
CPU_BASED_RDPMC_EXITING.

My patch is suppose to hide CPU_BASED_RDPMC_EXITING from L1 only in case =
L1 vCPU is not exposed with PMU.

Can you provide more details on the vCPU your setup expose to L1?
Have you explicitly disabled PMU from L1 vCPU?
Can you run =E2=80=9Ccpuid -r=E2=80=9D on shell and post here it=E2=80=99s=
 output?

-Liran

> On 7 May 2019, at 23:45, bugzilla-daemon@bugzilla.kernel.org wrote:
>=20
> =
https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__bugzilla.kernel.org=
_show-5Fbug.cgi-3Fid-3D203543&d=3DDwIDaQ&c=3DRoP1YumCXCgaWHvlZYR8PZh8Bv7qI=
rMUB65eapI_JnE&r=3DJk6Q8nNzkQ6LJ6g42qARkg6ryIDGQr-yKXPNGZbpTx0&m=3DcB5pEya=
2zKbSTvVpkeIHKYlQ1F9qW__mnLe0hXnlBCM&s=3DO2zSR2K1fTcD1Ps40Q_i-ZmS9tVsPYjup=
bQmw-LCMPk&e=3D
>=20
>            Bug ID: 203543
>           Summary: Starting with kernel 5.1.0-rc6,  kvm_intel can no
>                    longer be loaded in nested kvm/guests
>           Product: Virtualization
>           Version: unspecified
>    Kernel Version: 5.1.0-rc6
>          Hardware: Intel
>                OS: Linux
>              Tree: Mainline
>            Status: NEW
>          Severity: blocking
>          Priority: P1
>         Component: kvm
>          Assignee: virtualization_kvm@kernel-bugs.osdl.org
>          Reporter: hilld@binarystorm.net
>        Regression: No
>=20
> 1. Please describe the problem:
> Starting with kernel 5.1.0-rc6,  kvm_intel can no longer be loaded in =
nested
> kvm/guests
>=20
> [root@undercloud-0-rhosp10 ~]# modprobe kvm_intel
> modprobe: ERROR: could not insert 'kvm_intel': Input/output error
>=20
>=20
> 2. What is the Version-Release number of the kernel:
> 5.1.0-rc7
>=20
> 3. Did it work previously in Fedora? If so, what kernel version did =
the issue
>   *first* appear?  Old kernels are available for download at
>   =
https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__koji.fedoraproject.=
org_koji_packageinfo-3FpackageID-3D8&d=3DDwIDaQ&c=3DRoP1YumCXCgaWHvlZYR8PZ=
h8Bv7qIrMUB65eapI_JnE&r=3DJk6Q8nNzkQ6LJ6g42qARkg6ryIDGQr-yKXPNGZbpTx0&m=3D=
cB5pEya2zKbSTvVpkeIHKYlQ1F9qW__mnLe0hXnlBCM&s=3D1wtgL9MEqhN6ZwOZRMKlcW6LYP=
3zCgz4-1lh8aXyTWo&e=3D :
> Yes it seems to have appearded between 5.1.0-rc4 (it worked) and =
5.1.0-rc6 (it
> no longer worked)
>=20
> 4. Can you reproduce this issue? If so, please provide the steps to =
reproduce
>   the issue below:
> Yes, update to 5.1.0-rc6 and try to modprobe kvm_intel inside a guest =
where the
> VMX capabilities has been exposted
>=20
>=20
> 5. Does this problem occur with the latest Rawhide kernel? To install =
the
>   Rawhide kernel, run ``sudo dnf install fedora-repos-rawhide`` =
followed by
>   ``sudo dnf update --enablerepo=3Drawhide kernel``:
> Yes
>=20
>=20
> 6. Are you running any modules that not shipped with directly Fedora's =
kernel?:
> No
>=20
> 7. Please attach the kernel logs. You can get the complete kernel log
>   for a boot with ``journalctl --no-hostname -k > dmesg.txt``. If the
>   issue occurred on a previous boot, use the journalctl ``-b`` flag.
>=20
> --=20
> You are receiving this mail because:
> You are watching the assignee of the bug.

