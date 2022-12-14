Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC84A64D1B7
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 22:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbiLNVZL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 16:25:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiLNVY5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 16:24:57 -0500
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [IPv6:2620:100:9001:583::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7670736C7A
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 13:24:56 -0800 (PST)
Received: from pps.filterd (m0050095.ppops.net [127.0.0.1])
        by m0050095.ppops.net-00190b01. (8.17.1.19/8.17.1.19) with ESMTP id 2BEDrk7R000375;
        Wed, 14 Dec 2022 21:24:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=jan2016.eng;
 bh=+pSzADNuSc9khj9EMHkDS0nXT7AkjJ+vRYHowkBKjI4=;
 b=Onf+8Aztl5HaEtXvvzas4LuEvvrY5Iw4eLJOquAOTC4jbnnJiJZI3qVE6ha2rL52TJIf
 x9v1xkKbdPH60H9q81Ie/amlZ+TTMNk1gbT/uGcrVtAyjW1w1a/DfrBZAUVt2GKi477v
 r2DNonknXnh+AEni2ZX+7Ki3CMAFbMVfv4ZIGV5fUhKvU+T6UT4Pu7jTk2FpbU7/ks75
 EcFT9GXpaR7/YS9G8QzwAvGakIotiWTAQhfc9FDfn6et9hSU1DFllcrXyYOdBN6ygB3e
 55+DIyG+jHnKWgClCEQkQmoAH8usdxr1EWzU+V1wNi1ncDsJDa04m0Wi2r9Z89fy0jdK 9A== 
Received: from prod-mail-ppoint8 (a72-247-45-34.deploy.static.akamaitechnologies.com [72.247.45.34] (may be forged))
        by m0050095.ppops.net-00190b01. (PPS) with ESMTPS id 3mf6rrk4f2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Dec 2022 21:24:49 +0000
Received: from pps.filterd (prod-mail-ppoint8.akamai.com [127.0.0.1])
        by prod-mail-ppoint8.akamai.com (8.17.1.5/8.17.1.5) with ESMTP id 2BELDGDo014740;
        Wed, 14 Dec 2022 16:24:49 -0500
Received: from email.msg.corp.akamai.com ([172.27.50.201])
        by prod-mail-ppoint8.akamai.com (PPS) with ESMTPS id 3mf01gnjap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Dec 2022 16:24:48 -0500
Received: from ustx2ex-dag4mb8.msg.corp.akamai.com (172.27.50.207) by
 ustx2ex-dag4mb7.msg.corp.akamai.com (172.27.50.206) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.20; Wed, 14 Dec 2022 13:24:48 -0800
Received: from ustx2ex-dag4mb8.msg.corp.akamai.com ([172.27.50.207]) by
 ustx2ex-dag4mb8.msg.corp.akamai.com ([172.27.50.207]) with mapi id
 15.02.1118.020; Wed, 14 Dec 2022 13:24:48 -0800
From:   "Jayaramappa, Srilakshmi" <sjayaram@akamai.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "suleiman@google.com" <suleiman@google.com>,
        "Hunt, Joshua" <johunt@akamai.com>
Subject: Re: KVM: x86: snapshotted TSC frequency causing time drifts in vms
Thread-Topic: KVM: x86: snapshotted TSC frequency causing time drifts in vms
Thread-Index: AQHY7VUBvAGfvnsQJ0OJYynFST/RMK4pUIaA///MAaGARQyI1Q==
Date:   Wed, 14 Dec 2022 21:24:48 +0000
Message-ID: <46774ef6c59e45bf9b166ca4833dddd7@akamai.com>
References: <a49dfacc8a99424a94993171ba2955a0@akamai.com>,<Y2BFSZ1ExLiOIIi9@google.com>,<5394d31b6be148b49b80b33aaa39ff45@akamai.com>
In-Reply-To: <5394d31b6be148b49b80b33aaa39ff45@akamai.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.27.97.87]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_11,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 adultscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212140174
X-Proofpoint-ORIG-GUID: s8OG0OroL3GNWYTd3unSnAaTlTowHKTu
X-Proofpoint-GUID: s8OG0OroL3GNWYTd3unSnAaTlTowHKTu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_11,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 phishscore=0 clxscore=1011 suspectscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212140175
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jayaramappa, Srilakshmi
 Sent: Monday, October 31, 2022 7:00 PM
To: Sean Christopherson
Cc: kvm@vger.kernel.org; pbonzini@redhat.com; vkuznets@redhat.com; mlevitsk=
@redhat.com; suleiman@google.com; Hunt, Joshua
Subject: Re: KVM: x86: snapshotted TSC frequency causing time drifts in vms
=A0  =20

From: Sean Christopherson <seanjc@google.com>
Sent: Monday, October 31, 2022 5:59 PM
To: Jayaramappa, Srilakshmi
Cc: kvm@vger.kernel.org; pbonzini@redhat.com; vkuznets@redhat.com; mlevitsk=
@redhat.com; suleiman@google.com; Hunt, Joshua
Subject: Re: KVM: x86: snapshotted TSC frequency causing time drifts in vms
=A0=A0=A0=20
On Mon, Oct 31, 2022, Jayaramappa, Srilakshmi wrote:
> Hi,
>=20
> We were recently notified of significant time drift on some of our virtua=
l
> machines. Upon investigation it was found that the jumps in time were lar=
ger
> than ntp was able to gracefully correct. After further probing we discove=
red
> that the affected vms booted with tsc frequency equal to the early tsc
> frequency of the host and not the calibrated frequency.
>=20
> There were two variables that cached tsc_khz - cpu_tsc_khz and max_tsc_kh=
z.
> Caching max_tsc_khz would cause further scaling of the user_tsc_khz when =
the
> vcpu is created after the host tsc calibrabration and kvm is loaded befor=
e
> calibration. But it appears that Sean's commit "KVM: x86: Don't snapshot
> "max" TSC if host TSC is constant" would fix that issue. [1]
>=20
> The cached cpu_tsc_khz is used in 1. get_kvmclock_ns() which incorrectly =
sets
> the factors hv_clock.tsc_to_system_mul and hv_clock.shift that estimate
> passage of time.=A0 2. kvm_guest_time_update()
>=20
> We came across Anton Romanov's patch "KVM: x86: Use current rather than
> snapshotted TSC frequency if it is constant" [2] that seems to address th=
e
> cached cpu_tsc_khz=A0 case. The patch description says "the race can be h=
it if
> and only if userspace is able to create a VM before TSC refinement
> completes". We think as long as the kvm module is loaded before the host =
tsc
> calibration happens the vms can be created anytime and they will have the
> problem (confirmed this by shutting down an affected vm and relaunching i=
t -
> it continued to experience time issues). VMs need not be created before t=
sc
> refinement.
>=20
> Even if kvm module loads and vcpu is created before the host tsc refineme=
nt
> and have incorrect time estimation on the vm until the tsc refinement, th=
e
> patches referenced here would subsequently provide the correct factors to
> determine time. And any error in time in that small interval can be corre=
cted
> by ntp if it is running on the guest. If there was no ntp, the error woul=
d
> probably be negligible and would not accumulate.
>=20
> There doesn't seem to be any response on the v6 of Anton's patch. I wante=
d to
> ask if there is further changes in progress or if it is all set to be mer=
ged?

Drat, it slipped through the cracks.

Paolo, can you pick up the below patch?=A0 Oobviously assuming you don't sp=
y any
problems.

It has a superficial conflict with commit 938c8745bcf2 ("KVM: x86: Introduc=
e
"struct kvm_caps" to track misc caps/settings"), but otherwise applies clea=
nly.

> [2]=A0  https://urldefense.com/v3/__https://lore.kernel.org/all/202206081=
83525.1143682-1-romanton@google.com/__;!!GjvTz_vk!QH6DrxJkEWcYdjwasd9zcBVok=
REj7lO9qb6tynY5SpQoRRXRxi959dCvoy_sbU9oRcrSbNCxXwA_dw$



Thanks, Sean! Appreciate it.

-Sri



Hi Paolo,

Could I trouble you to take a look at this patch please?=20

Thanks
-Sri=
