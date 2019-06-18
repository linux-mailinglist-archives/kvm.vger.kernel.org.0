Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D56244A5E2
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 17:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729494AbfFRPv7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 11:51:59 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55866 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729246AbfFRPv7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 11:51:59 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IFmbOe087115;
        Tue, 18 Jun 2019 15:50:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=0dQkZ5OV/BT2r87AQQsugZlj1F6vKRtcJ9ht0h0pUTQ=;
 b=QvL6hFJTidKvB2pFmtvpTMQAGn3YFv1kOUwrc4aOacIIvvvk4ImHUIHJ8RG35l9FWHyy
 NCArCN+k75zzadSZe+Dt9dVq5jQcGP2Ppx3QCy6h0RkBe9ORCk0+FUqpdHmVBnlGquPF
 qNn7pCEX4AxL/f1++/OkHXcUm59aUJ8AI2FNFzSXf3fYk1uYcpCuKcbDL5A0k7KwELXU
 I4hSVDchWqtIoI20tSfmMeAY6cVeyPyFwTI3flB/pUZ+z+1Udt1F+dJ9vM9EPduPmB4m
 erBnGQ2l5nqP329+TxcZZ6XlNqGgt+73bfmhT8Zax4KxcP+/WApsOImfItZ1oBaUl0he AQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2t4rmp5cjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 15:50:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IFnEdu133627;
        Tue, 18 Jun 2019 15:50:58 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2t5cpe4k60-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 15:50:58 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5IFovZb030627;
        Tue, 18 Jun 2019 15:50:57 GMT
Received: from [192.168.14.112] (/109.67.217.108)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Jun 2019 08:50:57 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [QEMU PATCH v3 7/9] KVM: i386: Add support for save and restore
 nested state
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20190618154817.GI2850@work-vm>
Date:   Tue, 18 Jun 2019 18:50:50 +0300
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, mtosatti@redhat.com,
        rth@twiddle.net, ehabkost@redhat.com, kvm@vger.kernel.org,
        jmattson@google.com, maran.wilson@oracle.com,
        Nikita Leshenko <nikita.leshchenko@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <31104F26-B541-44CB-82D5-CABB033308E3@oracle.com>
References: <20190617175658.135869-1-liran.alon@oracle.com>
 <20190617175658.135869-8-liran.alon@oracle.com>
 <20190618090316.GC2850@work-vm>
 <32C4B530-A135-475B-B6AF-9288D372920D@oracle.com>
 <20190618154817.GI2850@work-vm>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9291 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=895
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906180125
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9291 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=934 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906180125
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 18 Jun 2019, at 18:48, Dr. David Alan Gilbert <dgilbert@redhat.com> =
wrote:
>=20
> * Liran Alon (liran.alon@oracle.com) wrote:
>>=20
>>> On 18 Jun 2019, at 12:03, Dr. David Alan Gilbert =
<dgilbert@redhat.com> wrote:
>>>=20
>>> * Liran Alon (liran.alon@oracle.com) wrote:
>>>>=20
>>>> +static const VMStateDescription vmstate_vmx_vmcs12 =3D {
>>>> +	.name =3D "cpu/kvm_nested_state/vmx/vmcs12",
>>>> +	.version_id =3D 1,
>>>> +	.minimum_version_id =3D 1,
>>>> +	.needed =3D vmx_vmcs12_needed,
>>>> +	.fields =3D (VMStateField[]) {
>>>> +	    VMSTATE_UINT8_ARRAY(data.vmx[0].vmcs12,
>>>> +	                        struct kvm_nested_state, 0x1000),
>>>=20
>>> Where did that magic 0x1000 come from?
>>=20
>> Currently, KVM folks (including myself), haven=E2=80=99t decided yet =
to expose vmcs12 struct layout to userspace but instead to still leave =
it opaque.
>> The formal size of this size is VMCS12_SIZE (defined in kernel as =
0x1000). I was wondering if we wish to expose VMCS12_SIZE constant to =
userspace or not.
>> So currently I defined these __u8 arrays as 0x1000. But in case Paolo =
agrees to expose VMCS12_SIZE, we can use that instead.
>=20
> Well if it's not defined it's bound to change at some state!

I agree it=E2=80=99s better to expose VMCS12_SIZE to userspace but I =
didn=E2=80=99t want to be the one that decides this.
Let=E2=80=99s let Paolo decide and modify this patch accordingly if he =
decides to expose it.

> Also, do we need to clear it before we get it from the kernel - e.g.
> is the kernel guaranteed to give us 0x1000 ?

Userspace don=E2=80=99t need to clear it before getting it from kernel.
It does guarantee to give you 0x1000. See vmx_get_nested_state() =
implementation in kernel.

-Liran

>=20
> Dave
>=20
>> -Liran
>>=20
>>> --
>>> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
>>=20
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

