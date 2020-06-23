Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87784204BE8
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 10:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731553AbgFWIGX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 04:06:23 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54502 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731516AbgFWIGW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Jun 2020 04:06:22 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05N84VcZ160977;
        Tue, 23 Jun 2020 04:06:21 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31tysr5yx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Jun 2020 04:06:21 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05N85dfs167189;
        Tue, 23 Jun 2020 04:06:20 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31tysr5yvs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Jun 2020 04:06:20 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05N85qU6014299;
        Tue, 23 Jun 2020 08:06:17 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 31sa381v6u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Jun 2020 08:06:17 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05N86Ff758064968
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Jun 2020 08:06:15 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E909A4051;
        Tue, 23 Jun 2020 08:06:15 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D3788A4040;
        Tue, 23 Jun 2020 08:06:14 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.62.182])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Jun 2020 08:06:14 +0000 (GMT)
Subject: Re: [PATCH] KVM: s390: reduce number of IO pins to 1
To:     David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20200617083620.5409-1-borntraeger@de.ibm.com>
 <d17de7d7-6cca-672a-5519-c67fc147f6a5@redhat.com>
 <6953c580-9b99-1c76-b6eb-510dcb70894c@de.ibm.com>
 <66419659-e678-2daf-2e02-4f2158076ddb@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <7573ef21-9ed8-cbd0-5456-f8389e4fd25c@linux.ibm.com>
Date:   Tue, 23 Jun 2020 10:06:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <66419659-e678-2daf-2e02-4f2158076ddb@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="DkelNSMMLPGsqribB5qmbbqC5kh0zekX1"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_04:2020-06-22,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 spamscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 phishscore=0 mlxlogscore=999
 cotscore=-2147483648 suspectscore=2 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006230059
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DkelNSMMLPGsqribB5qmbbqC5kh0zekX1
Content-Type: multipart/mixed; boundary="CSIFHQ09u4KiIGL2plJVKzRwynvG1JVJY"

--CSIFHQ09u4KiIGL2plJVKzRwynvG1JVJY
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 6/18/20 11:07 AM, David Hildenbrand wrote:
> On 17.06.20 13:04, Christian Borntraeger wrote:
>>
>>
>> On 17.06.20 12:19, David Hildenbrand wrote:
>>> On 17.06.20 10:36, Christian Borntraeger wrote:
>>>> The current number of KVM_IRQCHIP_NUM_PINS results in an order 3
>>>> allocation (32kb) for each guest start/restart. This can result in O=
OM
>>>> killer activity even with free swap when the memory is fragmented
>>>> enough:
>>>>
>>>> kernel: qemu-system-s39 invoked oom-killer: gfp_mask=3D0x440dc0(GFP_=
KERNEL_ACCOUNT|__GFP_COMP|__GFP_ZERO), order=3D3, oom_score_adj=3D0
>>>> kernel: CPU: 1 PID: 357274 Comm: qemu-system-s39 Kdump: loaded Not t=
ainted 5.4.0-29-generic #33-Ubuntu
>>>> kernel: Hardware name: IBM 8562 T02 Z06 (LPAR)
>>>> kernel: Call Trace:
>>>> kernel: ([<00000001f848fe2a>] show_stack+0x7a/0xc0)
>>>> kernel:  [<00000001f8d3437a>] dump_stack+0x8a/0xc0
>>>> kernel:  [<00000001f8687032>] dump_header+0x62/0x258
>>>> kernel:  [<00000001f8686122>] oom_kill_process+0x172/0x180
>>>> kernel:  [<00000001f8686abe>] out_of_memory+0xee/0x580
>>>> kernel:  [<00000001f86e66b8>] __alloc_pages_slowpath+0xd18/0xe90
>>>> kernel:  [<00000001f86e6ad4>] __alloc_pages_nodemask+0x2a4/0x320
>>>> kernel:  [<00000001f86b1ab4>] kmalloc_order+0x34/0xb0
>>>> kernel:  [<00000001f86b1b62>] kmalloc_order_trace+0x32/0xe0
>>>> kernel:  [<00000001f84bb806>] kvm_set_irq_routing+0xa6/0x2e0
>>>> kernel:  [<00000001f84c99a4>] kvm_arch_vm_ioctl+0x544/0x9e0
>>>> kernel:  [<00000001f84b8936>] kvm_vm_ioctl+0x396/0x760
>>>> kernel:  [<00000001f875df66>] do_vfs_ioctl+0x376/0x690
>>>> kernel:  [<00000001f875e304>] ksys_ioctl+0x84/0xb0
>>>> kernel:  [<00000001f875e39a>] __s390x_sys_ioctl+0x2a/0x40
>>>> kernel:  [<00000001f8d55424>] system_call+0xd8/0x2c8
>>>>
>>>> As far as I can tell s390x does not use the iopins as we bail our fo=
r
>>>> anything other than KVM_IRQ_ROUTING_S390_ADAPTER and the chip/pin is=

>>>> only used for KVM_IRQ_ROUTING_IRQCHIP. So let us use a small number =
to
>>>> reduce the memory footprint.
>>>>
>>>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>>>> ---
>>>>  arch/s390/include/asm/kvm_host.h | 8 ++++----
>>>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/as=
m/kvm_host.h
>>>> index cee3cb6455a2..6ea0820e7c7f 100644
>>>> --- a/arch/s390/include/asm/kvm_host.h
>>>> +++ b/arch/s390/include/asm/kvm_host.h
>>>> @@ -31,12 +31,12 @@
>>>>  #define KVM_USER_MEM_SLOTS 32
>>>> =20
>>>>  /*
>>>> - * These seem to be used for allocating ->chip in the routing table=
,
>>>> - * which we don't use. 4096 is an out-of-thin-air value. If we need=

>>>> - * to look at ->chip later on, we'll need to revisit this.
>>>> + * These seem to be used for allocating ->chip in the routing table=
, which we
>>>> + * don't use. 1 is as small as we can get to reduce the needed memo=
ry. If we
>>>> + * need to look at ->chip later on, we'll need to revisit this.
>>>>   */
>>>>  #define KVM_NR_IRQCHIPS 1
>>>> -#define KVM_IRQCHIP_NUM_PINS 4096
>>>> +#define KVM_IRQCHIP_NUM_PINS 1
>>>>  #define KVM_HALT_POLL_NS_DEFAULT 50000
>>>> =20
>>>>  /* s390-specific vcpu->requests bit members */
>>>>
>>>
>>> Guess it doesn't make sense to wrap all the "->chip" handling in a
>>> separate set of defines.
>>>
>>> Reviewed-by: David Hildenbrand <david@redhat.com>
>>
>> I guess this is just the most simple solution. I am asking myself if I=
 should add
>> cc stable of Fixes as I was able to trigger this by having several gue=
sts with a
>> reboot loop and several guests that trigger memory overcommitment.
>>
>=20
> I don't think this classifies as stable material.
>=20
I'd like to have it in stable.
I'm not looking forward to getting bugzillas after distro tests and then
telling them that we already have a patch for that.


--CSIFHQ09u4KiIGL2plJVKzRwynvG1JVJY--

--DkelNSMMLPGsqribB5qmbbqC5kh0zekX1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl7xt/YACgkQ41TmuOI4
ufjzlg//W7axBUXmEBe6ndtBv5zgD9Kuklr/Grf8ZJ4yIuN/S582MQSfGN2dQs23
5CSSQ24zHI0eXvDmSIbV8m3OuqJU8mBHRXY2ElaDtqwY2CtXP4qIz9izdynmua0x
ixJBC58UoXHRt07vwoM9m365smsIUxfQuLfHsrQmRv/AgTGM0T9GYo+3wtArp1vv
xQxgBLR9PKUFTJrs+yOXRMk5Q9tqNEQtebNKbqLyuNk88drOK9cb8S/5bH8g9TEs
XfdCGZdOMaiylfImVZZVHHy+MfIqLbB1ayCtLXaNRZbxNKlnFr+1i7Gt1PZXFqkl
t75sgEA9vCbkTbbiXuI+x34Fx+KP9jjslWMOU/qP7pLbTVzpcSTx54S4jV9Cw2Mu
1ZPjNWhLLkcfluxfjGRMWb9c3kgqpLZR+y/erQ3NQ62q6MDTGsqeEYd2NW5iYdUC
blIVV/Z4bnOc9TxGbcDMK/WgdR8l0+AwIWef/4CL2kEMu0cA89CWm22XziO2gNiv
k8W1IDyRWBjIMXDST1mFuWeqccXQH76+B7/mlQh9yvNzNjnMDp4Kp5AFmraFM2io
bcDDO1LBEzWrxjVR0Z5vIOoRuSM+2EVVWuB3s8qcjx8UI0lbpd8CYLyuh2dqrXVf
ifMwXnUl6vuWnD9IDLNB2remy+OgM5Iwxxidt2nP/StY45rG0Po=
=+gDt
-----END PGP SIGNATURE-----

--DkelNSMMLPGsqribB5qmbbqC5kh0zekX1--

