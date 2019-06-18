Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 310E74A5CF
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 17:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729774AbfFRPst (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 11:48:49 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47494 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729209AbfFRPst (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 11:48:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IFhstc181357;
        Tue, 18 Jun 2019 15:47:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=eQ0nzYc0ULSE4m2y4q5Mz8s0ptpwHBMMjmAA5sE9wTU=;
 b=T/cifKLn+gaKLiMPSbleb/QR4ykPfNCEo5Qp2Jzyn83zQJgmLZMXNxtFIPIJyro9vRhM
 LIsz4r5fvmSwY/wNij1IViAOP48noN1JeistJsBBH54+HtgIMaXksSJ4AiC6SSEEL2yp
 78sJo8wh8bmiAGme/ZmGdhmCFQzV/4i/ooc3gbmjmxxR0sZyd9qJZnO681Qs1NCz8MEA
 wc07PVV7u6caNdjm3uFTtd1Uo+0EHxtWAAFS/NwAsEprotwtAD0H18rmUhKxRagvcHIe
 OeHoTKHdEnCfYpbVbu7qm0b4ADNp9hjcRZ4tDbtkPAEqR83hHOFZLY6H4N+Puj71377k Ag== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2t4saqdb6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 15:47:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IFiQqd181563;
        Tue, 18 Jun 2019 15:45:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2t5mgc1dhm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 15:45:48 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5IFjmor019118;
        Tue, 18 Jun 2019 15:45:48 GMT
Received: from [192.168.14.112] (/109.67.217.108)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Jun 2019 08:45:48 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [QEMU PATCH v3 8/9] KVM: i386: Add support for
 KVM_CAP_EXCEPTION_PAYLOAD
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20190618090752.GD2850@work-vm>
Date:   Tue, 18 Jun 2019 18:45:43 +0300
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, mtosatti@redhat.com,
        rth@twiddle.net, ehabkost@redhat.com, kvm@vger.kernel.org,
        jmattson@google.com, maran.wilson@oracle.com,
        Nikita Leshenko <nikita.leshchenko@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <350BC330-8877-4B93-A8B3-0C001AEDD879@oracle.com>
References: <20190617175658.135869-1-liran.alon@oracle.com>
 <20190617175658.135869-9-liran.alon@oracle.com>
 <20190618090752.GD2850@work-vm>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9291 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=944
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906180124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9291 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=998 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906180124
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 18 Jun 2019, at 12:07, Dr. David Alan Gilbert <dgilbert@redhat.com> =
wrote:
>=20
> * Liran Alon (liran.alon@oracle.com) wrote:
>> Kernel commit c4f55198c7c2 ("kvm: x86: Introduce =
KVM_CAP_EXCEPTION_PAYLOAD")
>> introduced a new KVM capability which allows userspace to correctly
>> distinguish between pending and injected exceptions.
>>=20
>> This distinguish is important in case of nested virtualization =
scenarios
>> because a L2 pending exception can still be intercepted by the L1 =
hypervisor
>> while a L2 injected exception cannot.
>>=20
>> Furthermore, when an exception is attempted to be injected by QEMU,
>> QEMU should specify the exception payload (CR2 in case of #PF or
>> DR6 in case of #DB) instead of having the payload already delivered =
in
>> the respective vCPU register. Because in case exception is injected =
to
>> L2 guest and is intercepted by L1 hypervisor, then payload needs to =
be
>> reported to L1 intercept (VMExit handler) while still preserving
>> respective vCPU register unchanged.
>>=20
>> This commit adds support for QEMU to properly utilise this new KVM
>> capability (KVM_CAP_EXCEPTION_PAYLOAD).
>=20
> Does this kvm capability become a requirement for the nested migration
> then? If so, is it wired into the blockers?
>=20
> Dave
>=20

That=E2=80=99s a very good point.
Yes this capability is required in order to correctly migrate VMs =
running nested hypervisors.
I agree that I should add a migration blocker for nested in case it =
isn=E2=80=99t present.
Nice catch.

-Liran


