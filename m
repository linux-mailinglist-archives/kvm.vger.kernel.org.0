Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F27991FC59
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 23:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfEOVlS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 17:41:18 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36122 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfEOVlR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 17:41:17 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4FLDvoU121102;
        Wed, 15 May 2019 21:41:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=fzGVzml2ttQjCi7j3P1R3TQPk9G5RucsEVTnpsP7YK4=;
 b=lTw90Zo1bQ7hvMB4ub+TivFKyKCTEjikQSQhWUufi85yr7apY8QMXZtHbP4rr+0+zH9P
 Y1fOyO4q23riuFGeeibaulEIYMnvEPW14Bcz26GPCFIyrQMT54G6oauNDB9aHimFVECT
 eLesV+PYGInIgxS5e75Pxj2To/1NGLpDbwZbWMvVoIsE8FgE5cHnC1HrxKJ05ELyoajm
 t0WFxW2XoMyakzMUaIQrFHppll7trV++WK5BjBTEvbpcD5X/oDeStj/feHyudPA3Cw0r
 9Kt0RfzKZoM4GOXuDL+7JWY3NoL8hLehovtSFHhyYzgqqcGwThakZHLxt/QsUH17a3T/ hw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2sdnttypbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 May 2019 21:41:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4FLdWYG171665;
        Wed, 15 May 2019 21:41:00 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2sgp32mp43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 May 2019 21:41:00 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4FLexCi025994;
        Wed, 15 May 2019 21:40:59 GMT
Received: from [10.74.124.190] (/10.74.124.190)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 May 2019 21:40:59 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH kvm-unit-tests] vmware_backdoors: run with -cpu host
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <1557956157-40196-1-git-send-email-pbonzini@redhat.com>
Date:   Thu, 16 May 2019 00:40:56 +0300
Cc:     kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <6B5FAFDD-B593-4AFF-A0B1-EBE64C5BDDA6@oracle.com>
References: <1557956157-40196-1-git-send-email-pbonzini@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9258 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905150129
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9258 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905150129
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> On 16 May 2019, at 0:35, Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> After KVM commit 672ff6cff80ca43bf3258410d2b887036969df5f, reading a =
VMware
> pseudo PMC will fail with #GP unless the PMU is supported by the =
guest.
> Invoke the test with PMU emulation to ensure that it passes.
>=20
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Liran Alon <liran.alon@oracle.com>
I think it will also be more intuitive if in addition, we will check in =
the kvm-unit-test itself the CPUID such that we will skip test in case =
PMU is not exposed by vCPU.

-Liran

> ---
> x86/unittests.cfg | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index 2abf6d5..ed47d3f 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -157,7 +157,7 @@ check =3D /proc/sys/kernel/nmi_watchdog=3D0
>=20
> [vmware_backdoors]
> file =3D vmware_backdoors.flat
> -extra_params =3D -machine vmport=3Don
> +extra_params =3D -machine vmport=3Don -cpu host
> arch =3D x86_64
>=20
> [port80]
> --=20
> 1.8.3.1
>=20

