Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC181141D6
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 14:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729426AbfLENo7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 08:44:59 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:36766 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729165AbfLENo7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Dec 2019 08:44:59 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB5DYmh4186732;
        Thu, 5 Dec 2019 13:43:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=brsXaC0VRHRwZqPZpGYZ7XL2fHsN26kLdCH5fW1y8tQ=;
 b=h05b834cY//3Xz7W17CnMMvLsJbuSVaca/Bu2F2onCLkfB9Df1KaIGdX51SwH0kS41Ea
 MJIFx9oZNJIbRXoDW0/ZPGoo3JtVlUBsy/OtsH5mKHj6Mp1h/sGnjlM/mR8zeTngFHzG
 hfRphqYKJwjt7g+OOXNv4qf1/hK4yUdb+uJ8JMyROwS1iCbtH/L7hQyLqVjDxsnUbHsD
 gZECoCch8ZxM9gGsmshhIDJCXQy/Eb723FJjm5OyUTD1fbMJU762vWWPcER+VvhSxAqT
 dlvUnQu9HyUKcEWVay2upKh+arVvpUK+QSLQGH+8fGbtsHzYbxCq8RwIwWbNgy1yCXoM Tg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2wkfuunbs1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Dec 2019 13:43:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB5DYiIk196384;
        Thu, 5 Dec 2019 13:43:24 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2wpp745bfe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Dec 2019 13:43:24 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xB5DhJ0q029345;
        Thu, 5 Dec 2019 13:43:19 GMT
Received: from [192.168.14.112] (/79.183.203.182)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Dec 2019 05:43:19 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] KVM: vmx: remove unreachable statement in
 vmx_get_msr_feature()
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <1575512678-22058-1-git-send-email-linmiaohe@huawei.com>
Date:   Thu, 5 Dec 2019 15:43:13 +0200
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <DFEE8544-A246-45D0-A2DD-4AC4E7EC415E@oracle.com>
References: <1575512678-22058-1-git-send-email-linmiaohe@huawei.com>
To:     linmiaohe <linmiaohe@huawei.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9461 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912050115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9461 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912050115
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 5 Dec 2019, at 4:24, linmiaohe <linmiaohe@huawei.com> wrote:
>=20
> From: Miaohe Lin <linmiaohe@huawei.com>
>=20
> We have no way to reach the final statement, remove it.
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
> arch/x86/kvm/vmx/vmx.c | 2 --
> 1 file changed, 2 deletions(-)
>=20
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index e7ea332ad1e8..e58a0daf0f86 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1781,8 +1781,6 @@ static int vmx_get_msr_feature(struct =
kvm_msr_entry *msr)
> 	default:
> 		return 1;
> 	}
> -
> -	return 0;
> }

I personally just prefer to remove the =E2=80=9Cdefault=E2=80=9D case =
and change this =E2=80=9Creturn 0;=E2=80=9D to =E2=80=9Creturn 1;=E2=80=9D=
.
But it=E2=80=99s a matter of taste of course.

