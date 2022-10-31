Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDCEA614215
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 01:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiKAAFz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 20:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiKAAFv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 20:05:51 -0400
X-Greylist: delayed 3928 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 31 Oct 2022 17:05:50 PDT
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8553A11A1A
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 17:05:50 -0700 (PDT)
Received: from pps.filterd (m0050096.ppops.net [127.0.0.1])
        by m0050096.ppops.net-00190b01. (8.17.1.19/8.17.1.19) with ESMTP id 29VKxi4a018339;
        Mon, 31 Oct 2022 23:00:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=jan2016.eng;
 bh=E0duj+AzpkH4laHokeHVWzVk4gjxS08+GRiACXqmFPg=;
 b=ZXYRFdpCei4Koi7qvfkOGCgUsIejnX67DuGHIGao2kOMxTkbL4h5pCNcH4Rs+tiUL5wm
 lJz7I582dhGy9ChXzsQQSYk2lQyNXrrRtr85/Jy47AlivymfpZ39ZfEYLWQsNIWACJDa
 n4pprS96E+6QuaK9JMo5zcuq5LfT9LWnTW0lJEi4GfaQyrOB86kZUYt2hhMInEYcTdYU
 gbKcPbBiAR0Yi3tXA6JBsl8g4Zxv+YpRb7tZgDL1K6rkq4XKhpxid4jH3aRMbjrUihu0
 6f2I43DaZ2rHOr/jcSwSYWq+IklbwmdaECzaeONEQSl0WAFMs2UFJFPVWyKOkGAV6GgG Yg== 
Received: from prod-mail-ppoint2 (prod-mail-ppoint2.akamai.com [184.51.33.19] (may be forged))
        by m0050096.ppops.net-00190b01. (PPS) with ESMTPS id 3kjjwpf0s9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Oct 2022 23:00:18 +0000
Received: from pps.filterd (prod-mail-ppoint2.akamai.com [127.0.0.1])
        by prod-mail-ppoint2.akamai.com (8.17.1.5/8.17.1.5) with ESMTP id 29VMh5ZG032182;
        Mon, 31 Oct 2022 19:00:18 -0400
Received: from email.msg.corp.akamai.com ([172.27.91.26])
        by prod-mail-ppoint2.akamai.com (PPS) with ESMTPS id 3kgygxqmep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Oct 2022 19:00:18 -0400
Received: from usma1ex-dag4mb8.msg.corp.akamai.com (172.27.91.27) by
 usma1ex-dag4mb7.msg.corp.akamai.com (172.27.91.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.12; Mon, 31 Oct 2022 19:00:17 -0400
Received: from usma1ex-dag4mb8.msg.corp.akamai.com ([172.27.91.27]) by
 usma1ex-dag4mb8.msg.corp.akamai.com ([172.27.91.27]) with mapi id
 15.02.1118.012; Mon, 31 Oct 2022 19:00:17 -0400
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
Thread-Index: AQHY7VUBvAGfvnsQJ0OJYynFST/RMK4pUIaA///MAaE=
Date:   Mon, 31 Oct 2022 23:00:17 +0000
Message-ID: <5394d31b6be148b49b80b33aaa39ff45@akamai.com>
References: <a49dfacc8a99424a94993171ba2955a0@akamai.com>,<Y2BFSZ1ExLiOIIi9@google.com>
In-Reply-To: <Y2BFSZ1ExLiOIIi9@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.27.164.27]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-31_21,2022-10-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210310142
X-Proofpoint-GUID: Hx8VAXfcyKdVMdrhsl3NDRnnsLA-_KxW
X-Proofpoint-ORIG-GUID: Hx8VAXfcyKdVMdrhsl3NDRnnsLA-_KxW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-31_21,2022-10-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 priorityscore=1501 impostorscore=0 mlxscore=0 bulkscore=0
 adultscore=0 phishscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210310143
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


From: Sean Christopherson <seanjc@google.com>
Sent: Monday, October 31, 2022 5:59 PM
To: Jayaramappa, Srilakshmi
Cc: kvm@vger.kernel.org; pbonzini@redhat.com; vkuznets@redhat.com; mlevitsk=
@redhat.com; suleiman@google.com; Hunt, Joshua
Subject: Re: KVM: x86: snapshotted TSC frequency causing time drifts in vms
=A0  =20
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

> [2]  https://urldefense.com/v3/__https://lore.kernel.org/all/202206081835=
25.1143682-1-romanton@google.com/__;!!GjvTz_vk!QH6DrxJkEWcYdjwasd9zcBVokREj=
7lO9qb6tynY5SpQoRRXRxi959dCvoy_sbU9oRcrSbNCxXwA_dw$



Thanks, Sean! Appreciate it.

-Sri


    =
