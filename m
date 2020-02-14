Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 906FA15D780
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 13:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728522AbgBNMf6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 07:35:58 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16332 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726220AbgBNMf5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Feb 2020 07:35:57 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01ECZZPW134295
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2020 07:35:55 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y5ssubwg3-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2020 07:35:47 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Fri, 14 Feb 2020 12:35:00 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 14 Feb 2020 12:34:57 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01ECY1jJ48562472
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Feb 2020 12:34:01 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4F3BCAE053;
        Fri, 14 Feb 2020 12:34:56 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3422AE045;
        Fri, 14 Feb 2020 12:34:55 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.152.224.211])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 14 Feb 2020 12:34:55 +0000 (GMT)
Subject: Re: vhost changes (batched) in linux-next after 12/13 trigger random
 crashes in KVM guests after reboot
To:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
References: <20200107042401-mutt-send-email-mst@kernel.org>
 <43a5dbaa-9129-e220-8483-45c60a82c945@de.ibm.com>
 <e299afca8e22044916abbf9fbbd0bff6b0ee9e13.camel@redhat.com>
 <4c3f70b7-723a-8b0f-ac49-babef1bcc180@de.ibm.com>
 <50a79c3491ac483583c97df2fac29e2c3248fdea.camel@redhat.com>
 <8fbbfb49-99d1-7fee-e713-d6d5790fe866@de.ibm.com>
 <2364d0728c3bb4bcc0c13b591f774109a9274a30.camel@redhat.com>
 <bb9fb726-306c-5330-05aa-a86bd1b18097@de.ibm.com>
 <468983fad50a5e74a739f71487f0ea11e8d4dfd1.camel@redhat.com>
 <2dc1df65-1431-3917-40e5-c2b12096e2a7@de.ibm.com>
 <bd9c9b4d99abd20d5420583af5a4954ea1cf4618.camel@redhat.com>
 <e11ba53c-a5fa-0518-2e06-9296897ed529@de.ibm.com>
 <CAJaqyWfJFArAdpOwehTn5ci-frqai+pazGgcn2VvQSebqGRVtg@mail.gmail.com>
 <80520391-d90d-e10d-a107-7a18f2810900@de.ibm.com>
 <dabe59fe-e068-5935-f49e-bc1da3d8471a@de.ibm.com>
 <35dca16b9a85eb203f35d3e55dcaa9d0dae5a922.camel@redhat.com>
 <3144806d-436e-86a1-2e29-74f7027f7f0b@de.ibm.com>
 <8e226821a8878f53585d967b8af547526d84c73e.camel@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 xsFNBE6cPPgBEAC2VpALY0UJjGmgAmavkL/iAdqul2/F9ONz42K6NrwmT+SI9CylKHIX+fdf
 J34pLNJDmDVEdeb+brtpwC9JEZOLVE0nb+SR83CsAINJYKG3V1b3Kfs0hydseYKsBYqJTN2j
 CmUXDYq9J7uOyQQ7TNVoQejmpp5ifR4EzwIFfmYDekxRVZDJygD0wL/EzUr8Je3/j548NLyL
 4Uhv6CIPf3TY3/aLVKXdxz/ntbLgMcfZsDoHgDk3lY3r1iwbWwEM2+eYRdSZaR4VD+JRD7p8
 0FBadNwWnBce1fmQp3EklodGi5y7TNZ/CKdJ+jRPAAnw7SINhSd7PhJMruDAJaUlbYaIm23A
 +82g+IGe4z9tRGQ9TAflezVMhT5J3ccu6cpIjjvwDlbxucSmtVi5VtPAMTLmfjYp7VY2Tgr+
 T92v7+V96jAfE3Zy2nq52e8RDdUo/F6faxcumdl+aLhhKLXgrozpoe2nL0Nyc2uqFjkjwXXI
 OBQiaqGeWtxeKJP+O8MIpjyGuHUGzvjNx5S/592TQO3phpT5IFWfMgbu4OreZ9yekDhf7Cvn
 /fkYsiLDz9W6Clihd/xlpm79+jlhm4E3xBPiQOPCZowmHjx57mXVAypOP2Eu+i2nyQrkapaY
 IdisDQfWPdNeHNOiPnPS3+GhVlPcqSJAIWnuO7Ofw1ZVOyg/jwARAQABzUNDaHJpc3RpYW4g
 Qm9ybnRyYWVnZXIgKDJuZCBJQk0gYWRkcmVzcykgPGJvcm50cmFlZ2VyQGxpbnV4LmlibS5j
 b20+wsF5BBMBAgAjBQJdP/hMAhsDBwsJCAcDAgEGFQgCCQoLBBYCAwECHgECF4AACgkQEXu8
 gLWmHHy/pA/+JHjpEnd01A0CCyfVnb5fmcOlQ0LdmoKWLWPvU840q65HycCBFTt6V62cDljB
 kXFFxMNA4y/2wqU0H5/CiL963y3gWIiJsZa4ent+KrHl5GK1nIgbbesfJyA7JqlB0w/E/SuY
 NRQwIWOo/uEvOgXnk/7+rtvBzNaPGoGiiV1LZzeaxBVWrqLtmdi1iulW/0X/AlQPuF9dD1Px
 hx+0mPjZ8ClLpdSp5d0yfpwgHtM1B7KMuQPQZGFKMXXTUd3ceBUGGczsgIMipZWJukqMJiJj
 QIMH0IN7XYErEnhf0GCxJ3xAn/J7iFpPFv8sFZTvukntJXSUssONnwiKuld6ttUaFhSuSoQg
 OFYR5v7pOfinM0FcScPKTkrRsB5iUvpdthLq5qgwdQjmyINt3cb+5aSvBX2nNN135oGOtlb5
 tf4dh00kUR8XFHRrFxXx4Dbaw4PKgV3QLIHKEENlqnthH5t0tahDygQPnSucuXbVQEcDZaL9
 WgJqlRAAj0pG8M6JNU5+2ftTFXoTcoIUbb0KTOibaO9zHVeGegwAvPLLNlKHiHXcgLX1tkjC
 DrvE2Z0e2/4q7wgZgn1kbvz7ZHQZB76OM2mjkFu7QNHlRJ2VXJA8tMXyTgBX6kq1cYMmd/Hl
 OhFrAU3QO1SjCsXA2CDk9MM1471mYB3CTXQuKzXckJnxHkHOwU0ETpw8+AEQAJjyNXvMQdJN
 t07BIPDtbAQk15FfB0hKuyZVs+0lsjPKBZCamAAexNRk11eVGXK/YrqwjChkk60rt3q5i42u
 PpNMO9aS8cLPOfVft89Y654Qd3Rs1WRFIQq9xLjdLfHh0i0jMq5Ty+aiddSXpZ7oU6E+ud+X
 Czs3k5RAnOdW6eV3+v10sUjEGiFNZwzN9Udd6PfKET0J70qjnpY3NuWn5Sp1ZEn6lkq2Zm+G
 9G3FlBRVClT30OWeiRHCYB6e6j1x1u/rSU4JiNYjPwSJA8EPKnt1s/Eeq37qXXvk+9DYiHdT
 PcOa3aNCSbIygD3jyjkg6EV9ZLHibE2R/PMMid9FrqhKh/cwcYn9FrT0FE48/2IBW5mfDpAd
 YvpawQlRz3XJr2rYZJwMUm1y+49+1ZmDclaF3s9dcz2JvuywNq78z/VsUfGz4Sbxy4ShpNpG
 REojRcz/xOK+FqNuBk+HoWKw6OxgRzfNleDvScVmbY6cQQZfGx/T7xlgZjl5Mu/2z+ofeoxb
 vWWM1YCJAT91GFvj29Wvm8OAPN/+SJj8LQazd9uGzVMTz6lFjVtH7YkeW/NZrP6znAwv5P1a
 DdQfiB5F63AX++NlTiyA+GD/ggfRl68LheSskOcxDwgI5TqmaKtX1/8RkrLpnzO3evzkfJb1
 D5qh3wM1t7PZ+JWTluSX8W25ABEBAAHCwV8EGAECAAkFAk6cPPgCGwwACgkQEXu8gLWmHHz8
 2w//VjRlX+tKF3szc0lQi4X0t+pf88uIsvR/a1GRZpppQbn1jgE44hgF559K6/yYemcvTR7r
 6Xt7cjWGS4wfaR0+pkWV+2dbw8Xi4DI07/fN00NoVEpYUUnOnupBgychtVpxkGqsplJZQpng
 v6fauZtyEcUK3dLJH3TdVQDLbUcL4qZpzHbsuUnTWsmNmG4Vi0NsEt1xyd/Wuw+0kM/oFEH1
 4BN6X9xZcG8GYUbVUd8+bmio8ao8m0tzo4pseDZFo4ncDmlFWU6hHnAVfkAs4tqA6/fl7RLN
 JuWBiOL/mP5B6HDQT9JsnaRdzqF73FnU2+WrZPjinHPLeE74istVgjbowvsgUqtzjPIG5pOj
 cAsKoR0M1womzJVRfYauWhYiW/KeECklci4TPBDNx7YhahSUlexfoftltJA8swRshNA/M90/
 i9zDo9ySSZHwsGxG06ZOH5/MzG6HpLja7g8NTgA0TD5YaFm/oOnsQVsf2DeAGPS2xNirmknD
 jaqYefx7yQ7FJXXETd2uVURiDeNEFhVZWb5CiBJM5c6qQMhmkS4VyT7/+raaEGgkEKEgHOWf
 ZDP8BHfXtszHqI3Fo1F4IKFo/AP8GOFFxMRgbvlAs8z/+rEEaQYjxYJqj08raw6P4LFBqozr
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Fri, 14 Feb 2020 13:34:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <8e226821a8878f53585d967b8af547526d84c73e.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20021412-0012-0000-0000-00000386CC25
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021412-0013-0000-0000-000021C352D5
Message-Id: <1ee3a272-e391-e2e8-9cbb-5d3e2d40bec2@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-14_03:2020-02-12,2020-02-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=826 impostorscore=0 lowpriorityscore=0 malwarescore=0
 phishscore=0 spamscore=0 priorityscore=1501 adultscore=0 clxscore=1015
 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002140103
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 14.02.20 13:26, Eugenio Pérez wrote:
> On Fri, 2020-02-14 at 13:22 +0100, Christian Borntraeger wrote:
>>
>> On 14.02.20 13:17, Eugenio Pérez wrote:
>>> Can you try the inlined patch over 52c36ce7f334 ("vhost: use batched version by default")? My intention is to check
>>> if
>>> "strange VHOST_SET_VRING_BASE" line appears. In previous tests, it appears very fast, but maybe it takes some time
>>> for
>>> it to appear, or it does not appear anymore.


yep it does:

[   67.801012] [1917] vhost:vhost_vring_ioctl:1655: VHOST_SET_VRING_BASE [vq=0000000088199421][vq->last_avail_idx=0][vq->avail_idx=0][s.index=0][s.num=0]
[   67.801018] [1917] vhost:vhost_vring_ioctl:1655: VHOST_SET_VRING_BASE [vq=00000000175f11ec][vq->last_avail_idx=0][vq->avail_idx=0][s.index=1][s.num=0]
[   67.801026] [1917] vhost_net:vhost_net_ioctl:1726: VHOST_NET_SET_BACKEND
[   67.801028] [1917] vhost_net:vhost_net_set_backend:1538: sock=0000000082d8d291 != oldsock=000000001ae027fd index=0 fd=39 vq=0000000088199421
[   67.801032] [1917] vhost_net:vhost_net_set_backend:1573: sock=0000000082d8d291
[   67.801033] [1917] vhost_net:vhost_net_ioctl:1726: VHOST_NET_SET_BACKEND
[   67.801034] [1917] vhost_net:vhost_net_set_backend:1538: sock=0000000082d8d291 != oldsock=000000001ae027fd index=1 fd=39 vq=00000000175f11ec
[   67.801035] [1917] vhost_net:vhost_net_set_backend:1573: sock=0000000082d8d291
[   67.801037] [1915] vhost:vhost_discard_vq_desc:2424: DISCARD [vq=0000000088199421][vq->last_avail_idx=0][vq->avail_idx=0][n=0]
[   68.648803] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=0][vq->avail_idx=256][vq->ndescs=1]
[   68.648810] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=1][vq->avail_idx=256][vq->ndescs=1]
[   68.648812] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=2][vq->avail_idx=256][vq->ndescs=1]
[   68.648815] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=3][vq->avail_idx=256][vq->ndescs=1]
[   68.648817] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=4][vq->avail_idx=256][vq->ndescs=1]
[   68.648818] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=5][vq->avail_idx=256][vq->ndescs=1]
[   68.648820] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=6][vq->avail_idx=256][vq->ndescs=1]
[   68.648822] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=7][vq->avail_idx=256][vq->ndescs=1]
[   68.648824] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=8][vq->avail_idx=256][vq->ndescs=1]
[   68.648826] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=9][vq->avail_idx=256][vq->ndescs=1]
[   68.648828] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=10][vq->avail_idx=256][vq->ndescs=1]
[   68.648829] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=11][vq->avail_idx=256][vq->ndescs=1]
[   68.648831] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=12][vq->avail_idx=256][vq->ndescs=1]
[   68.648832] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=13][vq->avail_idx=256][vq->ndescs=1]
[   68.648833] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=14][vq->avail_idx=256][vq->ndescs=1]
[   68.670292] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=0][vq->avail_idx=1][vq->ndescs=1]
[   68.687187] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=1][vq->avail_idx=2][vq->ndescs=1]
[   68.687623] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=15][vq->avail_idx=256][vq->ndescs=1]
[   68.687641] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=2][vq->avail_idx=4][vq->ndescs=1]
[   68.687642] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=3][vq->avail_idx=4][vq->ndescs=1]
[   68.690274] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=16][vq->avail_idx=256][vq->ndescs=1]
[   68.690539] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=4][vq->avail_idx=5][vq->ndescs=1]
[   68.715379] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=17][vq->avail_idx=256][vq->ndescs=1]
[   68.800525] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=5][vq->avail_idx=6][vq->ndescs=1]
[   68.890537] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=6][vq->avail_idx=7][vq->ndescs=1]
[   68.900587] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=7][vq->avail_idx=8][vq->ndescs=1]
[   68.916837] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=8][vq->avail_idx=9][vq->ndescs=2]
[   68.928828] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=18][vq->avail_idx=256][vq->ndescs=1]
[   69.090540] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=9][vq->avail_idx=10][vq->ndescs=1]
[   69.119651] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=10][vq->avail_idx=11][vq->ndescs=2]
[   69.132325] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=19][vq->avail_idx=256][vq->ndescs=1]
[   69.323473] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=11][vq->avail_idx=12][vq->ndescs=2]
[   69.354557] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=20][vq->avail_idx=256][vq->ndescs=1]
[   69.442550] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=21][vq->avail_idx=256][vq->ndescs=1]
[   69.523593] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=12][vq->avail_idx=13][vq->ndescs=2]
[   69.557360] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=22][vq->avail_idx=256][vq->ndescs=1]
[   69.980634] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=13][vq->avail_idx=14][vq->ndescs=1]
[   69.981364] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=14][vq->avail_idx=15][vq->ndescs=1]
[   70.010545] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=15][vq->avail_idx=16][vq->ndescs=1]
[   70.161316] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=23][vq->avail_idx=256][vq->ndescs=1]
[   70.177640] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=24][vq->avail_idx=256][vq->ndescs=1]
[   70.280564] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=16][vq->avail_idx=17][vq->ndescs=1]
[   70.670327] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=17][vq->avail_idx=18][vq->ndescs=1]
[   70.932887] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=18][vq->avail_idx=19][vq->ndescs=2]
[   70.940587] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=19][vq->avail_idx=20][vq->ndescs=1]
[   70.947598] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=25][vq->avail_idx=256][vq->ndescs=1]
[   71.070388] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=20][vq->avail_idx=21][vq->ndescs=1]
[   71.070770] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=26][vq->avail_idx=256][vq->ndescs=1]
[   71.070805] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=21][vq->avail_idx=22][vq->ndescs=1]
[   71.070977] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=27][vq->avail_idx=256][vq->ndescs=1]
[   71.071049] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=22][vq->avail_idx=23][vq->ndescs=1]
[   71.071195] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=28][vq->avail_idx=256][vq->ndescs=1]
[   71.071243] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=23][vq->avail_idx=24][vq->ndescs=1]
[   71.071386] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=29][vq->avail_idx=256][vq->ndescs=1]
[   71.071433] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=24][vq->avail_idx=25][vq->ndescs=1]
[   71.071575] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=30][vq->avail_idx=256][vq->ndescs=1]
[   71.071611] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=25][vq->avail_idx=26][vq->ndescs=1]
[   71.071747] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=31][vq->avail_idx=256][vq->ndescs=1]
[   71.071789] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=26][vq->avail_idx=27][vq->ndescs=1]
[   71.071923] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=32][vq->avail_idx=256][vq->ndescs=1]
[   71.071960] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=27][vq->avail_idx=28][vq->ndescs=1]
[   71.072096] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=33][vq->avail_idx=256][vq->ndescs=1]
[   71.072128] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=28][vq->avail_idx=29][vq->ndescs=1]
[   71.072267] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=34][vq->avail_idx=256][vq->ndescs=1]
[   71.072300] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=29][vq->avail_idx=30][vq->ndescs=1]
[   71.072432] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=35][vq->avail_idx=256][vq->ndescs=1]
[   71.072463] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=30][vq->avail_idx=31][vq->ndescs=1]
[   71.072596] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=36][vq->avail_idx=256][vq->ndescs=1]
[   71.072630] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=31][vq->avail_idx=32][vq->ndescs=1]
[   71.072759] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=37][vq->avail_idx=256][vq->ndescs=1]
[   71.072791] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=32][vq->avail_idx=33][vq->ndescs=1]
[   71.072933] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=38][vq->avail_idx=256][vq->ndescs=1]
[   71.073054] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=33][vq->avail_idx=34][vq->ndescs=1]
[   71.073193] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=39][vq->avail_idx=256][vq->ndescs=1]
[   71.073247] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=34][vq->avail_idx=35][vq->ndescs=1]
[   71.073383] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=40][vq->avail_idx=256][vq->ndescs=1]
[   71.073434] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=35][vq->avail_idx=36][vq->ndescs=1]
[   71.073571] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=41][vq->avail_idx=256][vq->ndescs=1]
[   71.073627] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=36][vq->avail_idx=37][vq->ndescs=1]
[   71.073762] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=42][vq->avail_idx=256][vq->ndescs=1]
[   71.073813] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=37][vq->avail_idx=38][vq->ndescs=1]
[   71.073948] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=43][vq->avail_idx=256][vq->ndescs=1]
[   71.073998] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=38][vq->avail_idx=39][vq->ndescs=1]
[   71.074136] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=44][vq->avail_idx=256][vq->ndescs=1]
[   71.074186] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=39][vq->avail_idx=40][vq->ndescs=1]
[   71.074320] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=45][vq->avail_idx=256][vq->ndescs=1]
[   71.074370] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=40][vq->avail_idx=41][vq->ndescs=1]
[   71.074503] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=46][vq->avail_idx=256][vq->ndescs=1]
[   72.344493] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=47][vq->avail_idx=256][vq->ndescs=1]
[   72.553413] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=48][vq->avail_idx=256][vq->ndescs=1]
[   73.522174] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=49][vq->avail_idx=256][vq->ndescs=1]
[   73.705202] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=50][vq->avail_idx=256][vq->ndescs=1]
[   73.705239] [1915] vhost:fetch_descs:2328: [vq=00000000175f11ec][vq->last_avail_idx=41][vq->avail_idx=42][vq->ndescs=1]
[   73.994388] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=51][vq->avail_idx=256][vq->ndescs=1]
[   74.208443] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=52][vq->avail_idx=256][vq->ndescs=1]
[   74.433345] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=53][vq->avail_idx=256][vq->ndescs=1]
[   74.594756] [1910] vhost_net:vhost_net_ioctl:1726: VHOST_NET_SET_BACKEND
[   74.594761] [1910] vhost_net:vhost_net_set_backend:1538: sock=000000001ae027fd != oldsock=0000000082d8d291 index=0 fd=-1 vq=0000000088199421
[   74.594762] [1910] vhost_net:vhost_net_set_backend:1573: sock=000000001ae027fd
[   74.594803] [1910] vhost_net:vhost_net_ioctl:1726: VHOST_NET_SET_BACKEND
[   74.594804] [1910] vhost_net:vhost_net_set_backend:1538: sock=000000001ae027fd != oldsock=0000000082d8d291 index=1 fd=-1 vq=00000000175f11ec
[   74.594805] [1910] vhost_net:vhost_net_set_backend:1573: sock=000000001ae027fd
[   74.594847] [1910] vhost:vhost_vring_ioctl:1664: VHOST_GET_VRING_BASE [vq=0000000088199421][vq->last_avail_idx=54][vq->avail_idx=256][s.index=0][s.num=54]
[   74.594850] [1910] vhost:vhost_vring_ioctl:1664: VHOST_GET_VRING_BASE [vq=00000000175f11ec][vq->last_avail_idx=42][vq->avail_idx=42][s.index=1][s.num=42]
[   77.003191] [1918] vhost:vhost_vring_ioctl:1645: strange VHOST_SET_VRING_BASE [vq=0000000088199421][s.index=0][s.num=0]
[   77.003194] CPU: 62 PID: 1918 Comm: CPU 1/KVM Not tainted 5.5.0+ #22
[   77.003197] Hardware name: IBM 3906 M04 704 (LPAR)
[   77.003198] Call Trace:
[   77.003207]  [<0000000b8d93c132>] show_stack+0x8a/0xd0 
[   77.003211]  [<0000000b8e32e72a>] dump_stack+0x8a/0xb8 
[   77.003224]  [<000003ff803567ae>] vhost_vring_ioctl+0x6fe/0x858 [vhost] 
[   77.003228]  [<000003ff8036c670>] vhost_net_ioctl+0x510/0x570 [vhost_net] 
[   77.003234]  [<0000000b8dbecdd8>] do_vfs_ioctl+0x430/0x6f8 
[   77.003235]  [<0000000b8dbed124>] ksys_ioctl+0x84/0xb0 
[   77.003237]  [<0000000b8dbed1ba>] __s390x_sys_ioctl+0x2a/0x38 
[   77.003240]  [<0000000b8e34ff72>] system_call+0x2a6/0x2c8 
[   77.003261] [1918] vhost:vhost_vring_ioctl:1645: strange VHOST_SET_VRING_BASE [vq=00000000175f11ec][s.index=1][s.num=0]
[   77.003262] CPU: 62 PID: 1918 Comm: CPU 1/KVM Not tainted 5.5.0+ #22
[   77.003263] Hardware name: IBM 3906 M04 704 (LPAR)
[   77.003264] Call Trace:
[   77.003266]  [<0000000b8d93c132>] show_stack+0x8a/0xd0 
[   77.003267]  [<0000000b8e32e72a>] dump_stack+0x8a/0xb8 
[   77.003270]  [<000003ff803567ae>] vhost_vring_ioctl+0x6fe/0x858 [vhost] 
[   77.003271]  [<000003ff8036c670>] vhost_net_ioctl+0x510/0x570 [vhost_net] 
[   77.003273]  [<0000000b8dbecdd8>] do_vfs_ioctl+0x430/0x6f8 
[   77.003274]  [<0000000b8dbed124>] ksys_ioctl+0x84/0xb0 
[   77.003276]  [<0000000b8dbed1ba>] __s390x_sys_ioctl+0x2a/0x38 
[   77.003277]  [<0000000b8e34ff72>] system_call+0x2a6/0x2c8 
[   77.003297] [1918] vhost_net:vhost_net_ioctl:1726: VHOST_NET_SET_BACKEND
[   77.003300] [1918] vhost_net:vhost_net_set_backend:1538: sock=0000000082d8d291 != oldsock=000000001ae027fd index=0 fd=39 vq=0000000088199421
[   77.003304] [1918] vhost_net:vhost_net_set_backend:1573: sock=0000000082d8d291
[   77.003305] [1918] vhost_net:vhost_net_ioctl:1726: VHOST_NET_SET_BACKEND
[   77.003306] [1918] vhost_net:vhost_net_set_backend:1538: sock=0000000082d8d291 != oldsock=000000001ae027fd index=1 fd=39 vq=00000000175f11ec
[   77.003308] [1915] vhost:fetch_descs:2328: [vq=0000000088199421][vq->last_avail_idx=54][vq->avail_idx=256][vq->ndescs=1]
[   77.003308] [1918] vhost_net:vhost_net_set_backend:1573: sock=0000000082d8d291
[   77.003310] [1915] vhost_net:get_rx_bufs:1061: unexpected descriptor format for RX: out 0, in 0
[   77.003312] [1915] vhost:vhost_discard_vq_desc:2424: DISCARD [vq=0000000088199421][vq->last_avail_idx=55][vq->avail_idx=256][n=0]

