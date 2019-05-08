Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2AC817DA5
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 18:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbfEHQBY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 12:01:24 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:38052 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbfEHQBY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 12:01:24 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x48FmxMt091759;
        Wed, 8 May 2019 16:01:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=tHWYLnub5C6F8LXQbxnmc4mlity0LLNAd1VNUsbXz+I=;
 b=QJ+cLtNBzDpVhsg4P3WezCiAR5t0fFKwNBY9EQ3TyO0D+r/b84atJVbjme2PhvClEUgR
 8yXBmE1CrXFZtNA5Cc1gC7edo0rjsShNIGI+OtwwmF/mtZi9XJzM6LUQ8tNzXiiM68RK
 7P9s8ns3QONj5RmZVqwZuYuGUaah/AxJx0AIxO029ABjao2HMdAyxnWFaZc9Rnn0Rcym
 QmrdgRT0bBDk3NQlwT6gWmlnbP5rCAA/adGNpYM3lNOllhaGtAR3T8t3tDXH3kv/Xtgx
 7I9IaEbe/fkJJtiUSflqI99uLDYeakfJjFGwVMQFk09VuKx+nSQ/8TQFfq4avRI5MIsi XA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 2s94b652ky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 May 2019 16:01:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x48Fxuss072017;
        Wed, 8 May 2019 16:01:11 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2sagyunf79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 May 2019 16:01:11 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x48G1A5k003598;
        Wed, 8 May 2019 16:01:10 GMT
Received: from [192.168.14.112] (/109.66.243.183)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 08 May 2019 09:01:09 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [Bug 203543] Starting with kernel 5.1.0-rc6,  kvm_intel can no
 longer be loaded in nested kvm/guests
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <bug-203543-28872-daKc1aTVTb@https.bugzilla.kernel.org/>
Date:   Wed, 8 May 2019 19:00:54 +0300
Cc:     kvm list <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <CFB6AAEE-1B47-4D1D-9083-68F138964B68@oracle.com>
References: <bug-203543-28872@https.bugzilla.kernel.org/>
 <bug-203543-28872-daKc1aTVTb@https.bugzilla.kernel.org/>
To:     bugzilla-daemon@bugzilla.kernel.org
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9250 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905080098
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9250 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905080098
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Paolo

What are your thoughts on this?
What is the reason that KVM relies on CPU_BASED_RDPMC_EXITING to be =
exposed from underlying CPU? How is it critical for it=E2=80=99s =
functionality?
If it=E2=80=99s because we want to make sure that we hide host PMCs, we =
should condition this to be a min requirement of kvm_intel only in case =
underlying CPU exposes PMU to begin with.
Do you agree? If yes, I can create the patch to fix this.

-Liran

> On 8 May 2019, at 16:51, bugzilla-daemon@bugzilla.kernel.org wrote:
>=20
> =
https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__bugzilla.kernel.org=
_show-5Fbug.cgi-3Fid-3D203543&d=3DDwIDaQ&c=3DRoP1YumCXCgaWHvlZYR8PZh8Bv7qI=
rMUB65eapI_JnE&r=3DJk6Q8nNzkQ6LJ6g42qARkg6ryIDGQr-yKXPNGZbpTx0&m=3D7TirfLM=
NxYI-3Ygxm3kjDUB49Jwmk8bqD7671wy0hi8&s=3DZ_L1UqH19zon0ohDrCMU91ixA-Wn_vO7d=
-fO8s2G3PI&e=3D
>=20
> --- Comment #5 from David Hill (hilld@binarystorm.net) ---
> I can confirm that reverting that commit solves the problem:
>=20
> e51bfdb68725 ("KVM: nVMX: Expose RDPMC-exiting only when guest =
supports PMU=E2=80=9D)
>=20
> --=20
> You are receiving this mail because:
> You are watching the assignee of the bug.

