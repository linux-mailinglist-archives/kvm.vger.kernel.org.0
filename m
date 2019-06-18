Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 322644ADE7
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 00:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730756AbfFRWgr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 18:36:47 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36874 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729982AbfFRWgr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 18:36:47 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IMXaDi107210;
        Tue, 18 Jun 2019 22:36:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=8RgNe7nRFwWepfnFBvzlDwjlM6F4o/z+i9rBVj0AheY=;
 b=A0VwO1r5pE6mC+nS1A1UwVsONWNMBZXsvrUWujPaT313Y8i7U/7/Oaz4Y/agtktiLE3p
 a4gFWMnZxK3WuAkqnk6Phfx5KA9/OU+P2dLdvrAKAjbGIXGCHnam68R2Z8ahWW5OHduH
 3Un8Xtv0GNCMdJh//nkyD5jYkuANE3u8p5QW4kvKRJ7Wmjan3Q+LlC+NmNpY/c+Jg7z4
 bt/mBgdlPBbuzEbsMWwgk0xXBw8Svhf+LNk5HzBgFNRrpK1vvlbtJ7CJEdj4Ei7iKFXB
 yCHN+KuGO7uyw6jnI4qZmpgiuFE+eJuaYajXXBEctKoam36TpBpEkuqV96TNNmqeaz06 RQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2t780985ah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 22:36:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IMaR37045061;
        Tue, 18 Jun 2019 22:36:30 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2t77yngmys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 22:36:30 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5IMaTUt005813;
        Tue, 18 Jun 2019 22:36:29 GMT
Received: from [10.30.3.14] (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Jun 2019 15:36:28 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH v2] KVM: x86: Modify struct kvm_nested_state to have
 explicit fields for data
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <1560875046-26279-1-git-send-email-pbonzini@redhat.com>
Date:   Wed, 19 Jun 2019 01:36:25 +0300
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <D2867F96-6B8D-4A1D-9F6F-CF0F171614BC@oracle.com>
References: <1560875046-26279-1-git-send-email-pbonzini@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=958
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906180181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906180181
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 18 Jun 2019, at 19:24, Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> From: Liran Alon <liran.alon@oracle.com>
>=20
> Improve the KVM_{GET,SET}_NESTED_STATE structs by detailing the format
> of VMX nested state data in a struct.
>=20
> In order to avoid changing the ioctl values of
> KVM_{GET,SET}_NESTED_STATE, there is a need to preserve
> sizeof(struct kvm_nested_state). This is done by defining the data
> struct as "data.vmx[0]". It was the most elegant way I found to
> preserve struct size while still keeping struct readable and easy to
> maintain. It does have a misfortunate side-effect that now it has to =
be
> accessed as "data.vmx[0]" rather than just "data.vmx".
>=20
> Because we are already modifying these structs, I also modified the
> following:
> * Define the "format" field values as macros.
> * Rename vmcs_pa to vmcs12_pa for better readability.
>=20
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> [Remove SVM stubs, add KVM_STATE_NESTED_VMX_VMCS12_SIZE. - Paolo]

1) Why should we remove SVM stubs? I think it makes the interface =
intention more clear.
Do you see any disadvantage of having them?

2) What is the advantage of defining a separate =
KVM_STATE_NESTED_VMX_VMCS12_SIZE
rather than just moving VMCS12_SIZE to userspace header?

-Liran

> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

