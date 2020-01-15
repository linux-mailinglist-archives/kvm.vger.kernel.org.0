Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFD5013CFF9
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 23:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729883AbgAOWQ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 17:16:26 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46448 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728899AbgAOWQ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 17:16:26 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FMCquV071745;
        Wed, 15 Jan 2020 22:16:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=kWn95D7wae65nRj4nlSORIobmXdcMnBeHUgVUuzyXhY=;
 b=N5nMhN0wepiKNICFWx0ZpZujywc7d0Lbais1GvvepzwZEIR6vsRdCtFHEZPwyIejQBwv
 8sFFjdUVUmyIsRFu+vQJcdanFmMCvDMwsJCRDbWqRQAJ6Z6Q47prYMdaAbkytojtPDjT
 x6UZdvua7FXIyjsDJXkiMkjw4bS1afJpZp+oVU3SbjJ48h6IYhihSSRvaAs3qM3lpYDM
 up5ycVv5E9vKXFiar8YLpv9YsaZkDzdMokxohm/krnB2pxjFjh3DAKLIXSzkXtVNp89e
 9Ra5yLcpPt5U/HUFAmmUhEUIkG0ux3wUaAIonh/Mb/dv2cqwyP4yYK6FII7N7A7rMcMi Ng== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2xf73ty0ph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 22:16:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FME5bp038554;
        Wed, 15 Jan 2020 22:16:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2xj1archpt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 22:16:10 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00FMG9pX006623;
        Wed, 15 Jan 2020 22:16:09 GMT
Received: from [192.168.14.112] (/109.66.225.253)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 14:16:09 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] x86: Add a kvm module parameter check for
 vmware_backdoors test
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <157911811499.8078.14507140648862605986.stgit@naples-babu.amd.com>
Date:   Thu, 16 Jan 2020 00:16:06 +0200
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <0FC4B3E3-EA0F-4F5E-B9B2-91AB39E53543@oracle.com>
References: <157911811499.8078.14507140648862605986.stgit@naples-babu.amd.com>
To:     Babu Moger <babu.moger@amd.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001150166
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001150166
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> On 15 Jan 2020, at 21:55, Babu Moger <babu.moger@amd.com> wrote:
>=20
> vmware_backdoors test fails if the kvm module parameter
> enable_vmware_backdoor is not set to Y. Add a check before
> running the test.
>=20
> Suggested-by: Huang2, Wei <Wei.Huang2@amd.com>
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---
> x86/unittests.cfg |    1 +
> 1 file changed, 1 insertion(+)
>=20
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index 51e4ba5..aae1523 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -164,6 +164,7 @@ check =3D /proc/sys/kernel/nmi_watchdog=3D0
> [vmware_backdoors]
> file =3D vmware_backdoors.flat
> extra_params =3D -machine vmport=3Don -cpu host
> +check =3D /sys/module/kvm/parameters/enable_vmware_backdoor=3DY
> arch =3D x86_64
>=20
> [port80]
>=20

Nice!
I didn=E2=80=99t notice there is a =E2=80=9Ccheck=E2=80=9D feature when =
I first introduced vmware_backdoor tests.
Sorry for that.

Reviewed-by: Liran Alon <liran.alon@oracle.com>

-Liran=
