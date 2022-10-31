Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFD52613D71
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 19:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbiJaShg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 14:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbiJaShf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 14:37:35 -0400
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [IPv6:2620:100:9001:583::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83CEE13DCE
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 11:37:34 -0700 (PDT)
Received: from pps.filterd (m0122332.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 29VIPMjX017695;
        Mon, 31 Oct 2022 18:35:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=jan2016.eng;
 bh=+4kfrzPP193PjoFjOWGnNtmxl6Ecgsk0i6Dad+FhCNw=;
 b=LSLMB5XynVdbwern9M38t38FaUNOVo7UYT1UewZz942H43XgAhwG7J6HhzxXMVMVZBlX
 CK6cgSnsTft+AZJ2WXhSWqa1qFYELbZR8cQ3GC69NYhX2k5d4ROSgx9xyuXckWo5fbgF
 1eWy9yP136sY4J8+wVKL08wVpPMnLPza2vGFvz3Y1lwHFEbkePPaPVZXUCYABncrWse8
 kX/7iFsFrkJEjaOBrje24r/6+K1tGjViNCNkX7MKXvovFpEzrVgj5FEK/ibyYr27pEy9
 bLEfqmnJ6hu/F1i51z2K11wuxiF2uLg0bdvOn/HywmWSfg8pj0yaphWEE30luoRO+ycw uw== 
Received: from prod-mail-ppoint6 (prod-mail-ppoint6.akamai.com [184.51.33.61] (may be forged))
        by mx0a-00190b01.pphosted.com (PPS) with ESMTPS id 3kjfds8mvf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Oct 2022 18:35:30 +0000
Received: from pps.filterd (prod-mail-ppoint6.akamai.com [127.0.0.1])
        by prod-mail-ppoint6.akamai.com (8.17.1.5/8.17.1.5) with ESMTP id 29VGJIwS011192;
        Mon, 31 Oct 2022 14:35:29 -0400
Received: from email.msg.corp.akamai.com ([172.27.91.22])
        by prod-mail-ppoint6.akamai.com (PPS) with ESMTPS id 3kgygxy1w1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Oct 2022 14:35:29 -0400
Received: from usma1ex-dag4mb8.msg.corp.akamai.com (172.27.91.27) by
 usma1ex-dag4mb6.msg.corp.akamai.com (172.27.91.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.12; Mon, 31 Oct 2022 14:35:28 -0400
Received: from usma1ex-dag4mb8.msg.corp.akamai.com ([172.27.91.27]) by
 usma1ex-dag4mb8.msg.corp.akamai.com ([172.27.91.27]) with mapi id
 15.02.1118.012; Mon, 31 Oct 2022 14:35:28 -0400
From:   "Jayaramappa, Srilakshmi" <sjayaram@akamai.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "seanjc@google.com" <seanjc@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "suleiman@google.com" <suleiman@google.com>,
        "Hunt, Joshua" <johunt@akamai.com>
Subject: KVM: x86: snapshotted TSC frequency causing time drifts in vms
Thread-Topic: x86: snapshotted TSC frequency causing time drifts in vms
Thread-Index: AQHY7VUBvAGfvnsQJ0OJYynFST/RMA==
Date:   Mon, 31 Oct 2022 18:35:28 +0000
Message-ID: <a49dfacc8a99424a94993171ba2955a0@akamai.com>
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
 definitions=2022-10-31_19,2022-10-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210310115
X-Proofpoint-ORIG-GUID: i0vgYpKmlG0Vwzpyrb4-Gz7wunVJeROS
X-Proofpoint-GUID: i0vgYpKmlG0Vwzpyrb4-Gz7wunVJeROS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-31_19,2022-10-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 clxscore=1011 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210310115
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

We were recently notified of significant time drift on some of our virtual =
machines. Upon investigation it was found that the jumps in time were large=
r than ntp was able to gracefully correct. After further probing we discove=
red that the affected vms booted with tsc frequency equal to the early tsc =
frequency of the host and not the calibrated frequency.

There were two variables that cached tsc_khz - cpu_tsc_khz and max_tsc_khz.
Caching max_tsc_khz would cause further scaling of the user_tsc_khz when th=
e vcpu is created after the host tsc calibrabration and kvm is loaded befor=
e calibration. But it appears that Sean's commit "KVM: x86: Don't snapshot =
"max" TSC if host TSC is constant" would fix that issue. [1]

The cached cpu_tsc_khz is used in
1. get_kvmclock_ns() which incorrectly sets the factors hv_clock.tsc_to_sys=
tem_mul and hv_clock.shift that estimate passage of time.
2. kvm_guest_time_update()

We came across Anton Romanov's patch "KVM: x86: Use current rather than sna=
pshotted TSC frequency if it is constant" [2] that seems to address the cac=
hed cpu_tsc_khz  case. The patch description says "the race can be hit if a=
nd only if userspace is able to create a VM before TSC refinement completes=
". We think as long as the kvm module is loaded before the host tsc calibra=
tion happens the vms can be created anytime and they will have the problem =
(confirmed this by shutting down an affected vm and relaunching it - it con=
tinued to experience time issues). VMs need not be created before tsc refin=
ement.

Even if kvm module loads and vcpu is created before the host tsc refinement=
 and have incorrect time estimation on the vm until the tsc refinement, the=
 patches referenced here would subsequently provide the correct factors to =
determine time. And any error in time in that small interval can be correct=
ed by ntp if it is running on the guest. If there was no ntp, the error wou=
ld probably be negligible and would not accumulate.

There doesn't seem to be any response on the v6 of Anton's patch. I wanted =
to ask if there is further changes in progress or if it is all set to be me=
rged ?

I'd appreciate you taking the time with this query.

Thanks
-Sri


[1] commit id: 741e511b42086a100c05dbe8fd1baeec42e7c584
[2] https://lore.kernel.org/all/20220608183525.1143682-1-romanton@google.co=
m/=
