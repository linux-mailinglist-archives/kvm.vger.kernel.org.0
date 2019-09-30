Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2655C1F81
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2019 12:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730621AbfI3KsY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 06:48:24 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51284 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729415AbfI3KsY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 06:48:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8UAe6Ll116477;
        Mon, 30 Sep 2019 10:48:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=7F7H5SLjs3foMT+TynlSB46iUyy63RErIehHNIdggJs=;
 b=iymTYXHAlaUQ8w+e7EahgHelGL1bOZGxtZ55HkYA1TaOYHWhkrrjeXX8iB+0S6WDg4yX
 IhlFY3BFG4lyXvV4N+/U+bfA3qNG7R4idIffJ+9/JHvTuVFG0qZogk0PR6U97BOrCep9
 0YSQebTUuTxU70yrpPVJDhsefVR4cS69hs6DKc5bbx2e6JIQTC9lKcc/TlQFC3oO5xhi
 hVIzf5xdlLh8DGx7wqUjPMyFNiQ16gNH4LoE6SEeow1plsfFmiCvVfPm1bw2P14+Yh2G
 YQ2CyKrPBo5g5TkzEChBfct/5brNoaJvRjd3frMU67OPgaFk2akQIHZmMwTiuMeAIpx9 3w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2v9xxue8p3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Sep 2019 10:48:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8UAhZZ1135147;
        Mon, 30 Sep 2019 10:48:21 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2vahngdyx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Sep 2019 10:48:20 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8UAmIEf030868;
        Mon, 30 Sep 2019 10:48:19 GMT
Received: from [10.0.0.13] (/79.180.87.74)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Sep 2019 03:48:18 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: Broadwell server reboot with vmx: unexpected exit reason 0x3
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <CAMGffE=JTrCvj900OeMJQh06vogxKepRFn=7tdA965VJ9zSWow@mail.gmail.com>
Date:   Mon, 30 Sep 2019 13:48:15 +0300
Cc:     kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <DDC3DE27-46A3-4CB4-9AB8-C3C2F1D54777@oracle.com>
References: <CAMGffE=JTrCvj900OeMJQh06vogxKepRFn=7tdA965VJ9zSWow@mail.gmail.com>
To:     Jinpu Wang <jinpu.wang@cloud.ionos.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9395 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909300116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9395 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909300116
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 30 Sep 2019, at 11:43, Jinpu Wang <jinpu.wang@cloud.ionos.com> =
wrote:
>=20
> Dear KVM experts,
>=20
> We have a Broadwell server reboot itself recently, before the reboot,
> there were error messages from KVM in netconsole:
> [5599380.317055] kvm [9046]: vcpu1, guest rIP: 0xffffffff816ad716 vmx:
> unexpected exit reason 0x3
> [5599380.317060] kvm [49626]: vcpu0, guest rIP: 0xffffffff81060fe6
> vmx: unexpected exit reason 0x3
> [5599380.317062] kvm [36632]: vcpu0, guest rIP: 0xffffffff8103970d
> vmx: unexpected exit reason 0x3
> [5599380.317064] kvm [9620]: vcpu1, guest rIP: 0xffffffffb6c1b08e vmx:
> unexpected exit reason 0x3
> [5599380.317067] kvm [49925]: vcpu5, guest rIP: 0xffffffff9b406ea2
> vmx: unexpected exit reason 0x3
> [5599380.317068] kvm [49925]: vcpu3, guest rIP: 0xffffffff9b406ea2
> vmx: unexpected exit reason 0x3
> [5599380.317070] kvm [33871]: vcpu2, guest rIP: 0xffffffff81060fe6
> vmx: unexpected exit reason 0x3
> [5599380.317072] kvm [49925]: vcpu4, guest rIP: 0xffffffff9b406ea2
> vmx: unexpected exit reason 0x3
> [5599380.317074] kvm [48505]: vcpu1, guest rIP: 0xffffffffaf36bf9b
> vmx: unexpected exit reason 0x3
> [5599380.317076] kvm [21880]: vcpu1, guest rIP: 0xffffffff8103970d
> vmx: unexpected exit reason 0x3

The only way a CPU will raise this exit-reason (3 =3D=3D =
EXIT_REASON_INIT_SIGNAL)
is if CPU is in VMX non-root mode while it has a pending INIT signal in =
LAPIC.

In simple terms, it means that one CPU was running inside guest while
another CPU have sent it a signal to reset itself.

I see in code that kvm_init() does =
register_reboot_notifier(&kvm_reboot_notifier).
kvm_reboot() runs hardware_disable_nolock() on each CPU before reboot.
Which should result on every CPU running VMX=E2=80=99s =
hardware_disable() which should
exit VMX operation (VMXOFF) and disable VMX (Clear CR4.VMXE).

Therefore, I=E2=80=99m quite puzzled on how a server reboot triggers the =
scenario you present here.
Can you send your full kernel log?

>=20
> Kernel version is: 4.14.129
> CPU is Intel(R) Xeon(R) CPU E5-2680 v4 @ 2.40GHz
> There is no crashdump generated, only above message right before =
server reboot.
>=20
> Anyone has an idea, what could cause the reboot? is there a known
> problem in this regards?
>=20
> I notice EXIT_REASON_INIT_SIGNAL(3) is introduced recently, is it =
related?
> =
https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__git.kernel.org_pub_=
scm_linux_kernel_git_torvalds_linux.git_commit_arch_x86_kvm-3Fid-3D4b9852f=
4f38909a9ca74e71afb35aafba0871aa1&d=3DDwIBaQ&c=3DRoP1YumCXCgaWHvlZYR8PZh8B=
v7qIrMUB65eapI_JnE&r=3DJk6Q8nNzkQ6LJ6g42qARkg6ryIDGQr-yKXPNGZbpTx0&m=3D3JM=
SVEOhF1eCpny7VowcBwzScGDxjUkUZpipoP8Hlqw&s=3Dwar3Qw8cey9BewvAWmnGQdx3TY7En=
L6O5aUkrg3FQUg&e=3D=20

As the author of this commit, this shouldn=E2=80=99t be related. i.e. It =
won=E2=80=99t help you to apply this commit to your kernel.
That commit changes the handling of *virtual* INIT signals inside guest.
What you are seeing here are exits which results from a *physical* INIT =
signal while CPU was in guest.

-Liran

>=20
> Regards,
> Jinpu

