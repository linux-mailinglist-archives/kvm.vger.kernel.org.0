Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D28B464D4CA
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 01:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiLOAqj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 19:46:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiLOAqi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 19:46:38 -0500
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1533030F4A
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 16:46:36 -0800 (PST)
Received: from pps.filterd (m0122331.ppops.net [127.0.0.1])
        by mx0b-00190b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BEMH8hM029338;
        Thu, 15 Dec 2022 00:46:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=jan2016.eng;
 bh=hYWnssN3UzE1uginjg9PV2a+rGG2wKWg+IAvfNfbNJo=;
 b=DKH8+q2TaSMC9dWTnoyv2vER2DhYAcuGMjbirS70lC6KBHpPcvofGAlj/5VelCRgKw87
 QTaWuBXZmiGDhy+XYsHp1zdcL6oPFn17/WNOeHM+QXVa1WrAwG9ToUT/je7WQ/B2Sfsm
 0n4qkQdSNCrMBVSuSuyFRzjazPoa+YPvU+IvUOz81p6ksHefrI4a+acqxOTkYi5Afs/J
 rldSbj/Rlfg0HmZXxHLUw4QNzPkUXQ9MreObGYW2tbMMp2xwq1p8YIjy0x/poqlWDhC5
 4zSlrmo2esEClXsiX0TMD9bzfNbpblguppqJqlvxAJygopC2bDHaDZSzlJ7IVtLpfofs EA== 
Received: from prod-mail-ppoint3 (a72-247-45-31.deploy.static.akamaitechnologies.com [72.247.45.31] (may be forged))
        by mx0b-00190b01.pphosted.com (PPS) with ESMTPS id 3mf6r8hh54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 00:46:33 +0000
Received: from pps.filterd (prod-mail-ppoint3.akamai.com [127.0.0.1])
        by prod-mail-ppoint3.akamai.com (8.17.1.5/8.17.1.5) with ESMTP id 2BELS0ol004462;
        Wed, 14 Dec 2022 19:46:32 -0500
Received: from email.msg.corp.akamai.com ([172.27.50.204])
        by prod-mail-ppoint3.akamai.com (PPS) with ESMTPS id 3meytu6b0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Dec 2022 19:46:32 -0500
Received: from ustx2ex-dag4mb8.msg.corp.akamai.com (172.27.50.207) by
 ustx2ex-dag4mb3.msg.corp.akamai.com (172.27.50.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.20; Wed, 14 Dec 2022 16:46:31 -0800
Received: from ustx2ex-dag4mb8.msg.corp.akamai.com ([172.27.50.207]) by
 ustx2ex-dag4mb8.msg.corp.akamai.com ([172.27.50.207]) with mapi id
 15.02.1118.020; Wed, 14 Dec 2022 16:46:31 -0800
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
Thread-Index: AQHY7VUBvAGfvnsQJ0OJYynFST/RMK4pUIaA///MAaGARQyI1YAAsjqA//+FK0g=
Date:   Thu, 15 Dec 2022 00:46:31 +0000
Message-ID: <bdb1d56a377345f3ad08939d9f2cf418@akamai.com>
References: <a49dfacc8a99424a94993171ba2955a0@akamai.com>
 <Y2BFSZ1ExLiOIIi9@google.com> <5394d31b6be148b49b80b33aaa39ff45@akamai.com>
 <46774ef6c59e45bf9b166ca4833dddd7@akamai.com>,<Y5pjEwsdeRXVtjcj@google.com>
In-Reply-To: <Y5pjEwsdeRXVtjcj@google.com>
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
 definitions=2022-12-14_12,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 bulkscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212150002
X-Proofpoint-GUID: PRXCyQALJyVrDVY1Sqf3Y_4CykJRAnTQ
X-Proofpoint-ORIG-GUID: PRXCyQALJyVrDVY1Sqf3Y_4CykJRAnTQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_12,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxscore=0 priorityscore=1501 clxscore=1015 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212150004
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>
Sent: Wednesday, December 14, 2022 6:58 PM
To: Jayaramappa, Srilakshmi
Cc: kvm@vger.kernel.org; pbonzini@redhat.com; vkuznets@redhat.com; mlevitsk=
@redhat.com; suleiman@google.com; Hunt, Joshua
Subject: Re: KVM: x86: snapshotted TSC frequency causing time drifts in vms
=A0  =20
On Wed, Dec 14, 2022, Jayaramappa, Srilakshmi wrote:
> > There doesn't seem to be any response on the v6 of Anton's patch. I wan=
ted to
> > ask if there is further changes in progress or if it is all set to be m=
erged?
>=20
> Drat, it slipped through the cracks.
>=20
> Paolo, can you pick up the below patch?=A0 Oobviously assuming you don't =
spy any
> problems.
>=20
> It has a superficial conflict with commit 938c8745bcf2 ("KVM: x86: Introd=
uce

...

> Could I trouble you to take a look at this patch please?=20

It's already in kvm/next

=A0 3ebcbd2244f5 ("KVM: x86: Use current rather than snapshotted TSC freque=
ncy if it is constant")

but there was a hiccup with the KVM pull request for 6.2[*], which is why i=
t hasn't
made it's way to Linus yet.

[*]  https://urldefense.com/v3/__https://lore.kernel.org/all/6d96a62e-d5a1-=
e606-3bd2-c38f4a6c8545@redhat.com__;!!GjvTz_vk!VYIJqzFNCr9fQP6gLlryCKVNhGb-=
OrtosOocQzLpVk0aIEGoGFKL5OD0Zw8rmEN3QhhX9BmLkMpH7A$
   =20

Oh that's great, thanks, Sean! Appreciate the help.

-Sri=
