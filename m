Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41B8977052
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2019 19:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387779AbfGZRcj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jul 2019 13:32:39 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40922 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387690AbfGZRcj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jul 2019 13:32:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6QHTsQj136188;
        Fri, 26 Jul 2019 17:32:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=P/XqxaxUd1rHZ51rEV59andbQ1JSzhURWfXd8aTIpuE=;
 b=Eba+b/34szGzaT0E256uyFXnxTGqWeGvSw6I+5uhBWRo0gTQwd0eWdPyLzah0ERJieh6
 NCb4vZrkF4pqwfKJCGh9Xe2T1CjEv45ik3SrBKMQ4aje/S5EoK5HHW2w8+lsuQeBMcML
 hWsGmprM4yTd4VdqPMdkIsWA2i53zqM/EJp35SarVNBZUraz7E5P+nfB6FMOgoseerLC
 MogTzNQU/vnNIMDdKF4uVyqbS31Vz6jyDEbRLQZTHGHk5C+37QlxCVv3OU/x0DPItoCT
 PJqV1hjWm+OW72C8rTzBcJ50ZzP0E3UlbkmMNjHEMrdnOE/b6tz6wRBTJGCRStJda79v 3w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2tx61cc9cp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Jul 2019 17:32:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6QHRsWM136588;
        Fri, 26 Jul 2019 17:32:37 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2tyd3ps6pc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Jul 2019 17:32:36 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6QHWZ1x019964;
        Fri, 26 Jul 2019 17:32:35 GMT
Received: from [192.168.14.112] (/79.178.213.159)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 26 Jul 2019 10:32:35 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: Intercepting MOV to/from CR3 when using EPT
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <CALMp9eSYQGy4ZEXtO92zr-NG5cvDdA4qK+PzqbzwFP3TU-=hGg@mail.gmail.com>
Date:   Fri, 26 Jul 2019 20:32:33 +0300
Cc:     kvm list <kvm@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C3CF882E-C7B4-459B-A3A3-25C5E453C512@oracle.com>
References: <CALMp9eSYQGy4ZEXtO92zr-NG5cvDdA4qK+PzqbzwFP3TU-=hGg@mail.gmail.com>
To:     Jim Mattson <jmattson@google.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9330 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=979
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907260211
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9330 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907260211
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> On 26 Jul 2019, at 20:22, Jim Mattson <jmattson@google.com> wrote:
>=20
> When using EPT, why does kvm intercept MOV to/from CR3 when paging is
> disabled in the guest? It doesn't seem necessary to me, but perhaps I
> am missing something.
>=20
> I'm referring to this code in ept_update_paging_mode_cr0():
>=20
> exec_controls_setbit(vmx, CPU_BASED_CR3_LOAD_EXITING |
> CPU_BASED_CR3_STORE_EXITING);
>=20
> Thanks!

Note that ept_update_paging_mode_cr0() is called only in case =
(enable_ept && !enable_unrestricted_guest).
Even though function name doesn=E2=80=99t imply this=E2=80=A6

When unrestricted-guest is not enabled, KVM runs a vCPU with paging =
disabled, with paging enabled in VMCS and CR3 of ept_identity_map_addr.
See how it is initialised at init_rmode_identity_map().

-Liran

