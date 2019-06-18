Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3684A4A59B
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 17:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729249AbfFRPlE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 11:41:04 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39072 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726862AbfFRPlE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 11:41:04 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IFONoq163395;
        Tue, 18 Jun 2019 15:40:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=DqyNB264PtgYlJsNA49v/X6NfcFvz82H1wdab/j0FYE=;
 b=38R50lN7YoFpl3qtDclvGiDWSlMS7IkcsbC7wH1mQOFO3fvpwK+R6QdEQKaijmGwzwEL
 JOAmPDxG899Y7mb8QiLUW8okyPiaoPECNFbXqM2BV6+rxpN+ClH0oXa5VBqsx1NymS4e
 tNfZxr1gIP5J77mgIB+0GNhq8ZeCPSfX17iGah3iD3rQIMca/F1hxxU1iev9BeRL1XWu
 8mp3Ng66oiwMCXP108sz1khMkzVciX0fM4C5m6Wfth7AWYIJq2PhDtz05WQ5/lPT69yH
 E/atSL9ikeONophvezIFMdnCzuRc28kUyJyLHSgcMZ0Cph1Phx1aVJB6qNkMg3Tqla6v og== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2t4saqd9m9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 15:40:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IFdAHI040328;
        Tue, 18 Jun 2019 15:40:22 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2t5h5ttekb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 15:40:22 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5IFeLoa016004;
        Tue, 18 Jun 2019 15:40:21 GMT
Received: from [192.168.14.112] (/109.67.217.108)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Jun 2019 08:40:16 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [QEMU PATCH v3 7/9] KVM: i386: Add support for save and restore
 nested state
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20190618090316.GC2850@work-vm>
Date:   Tue, 18 Jun 2019 18:40:11 +0300
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, mtosatti@redhat.com,
        rth@twiddle.net, ehabkost@redhat.com, kvm@vger.kernel.org,
        jmattson@google.com, maran.wilson@oracle.com,
        Nikita Leshenko <nikita.leshchenko@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <32C4B530-A135-475B-B6AF-9288D372920D@oracle.com>
References: <20190617175658.135869-1-liran.alon@oracle.com>
 <20190617175658.135869-8-liran.alon@oracle.com>
 <20190618090316.GC2850@work-vm>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9291 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=959
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906180123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9291 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906180123
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> On 18 Jun 2019, at 12:03, Dr. David Alan Gilbert <dgilbert@redhat.com> =
wrote:
>=20
> * Liran Alon (liran.alon@oracle.com) wrote:
>>=20
>> +static const VMStateDescription vmstate_vmx_vmcs12 =3D {
>> +	.name =3D "cpu/kvm_nested_state/vmx/vmcs12",
>> +	.version_id =3D 1,
>> +	.minimum_version_id =3D 1,
>> +	.needed =3D vmx_vmcs12_needed,
>> +	.fields =3D (VMStateField[]) {
>> +	    VMSTATE_UINT8_ARRAY(data.vmx[0].vmcs12,
>> +	                        struct kvm_nested_state, 0x1000),
>=20
> Where did that magic 0x1000 come from?

Currently, KVM folks (including myself), haven=E2=80=99t decided yet to =
expose vmcs12 struct layout to userspace but instead to still leave it =
opaque.
The formal size of this size is VMCS12_SIZE (defined in kernel as =
0x1000). I was wondering if we wish to expose VMCS12_SIZE constant to =
userspace or not.
So currently I defined these __u8 arrays as 0x1000. But in case Paolo =
agrees to expose VMCS12_SIZE, we can use that instead.

-Liran

> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

