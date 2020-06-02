Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 942F91EBE68
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 16:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbgFBOqc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 10:46:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46644 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725958AbgFBOqb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Jun 2020 10:46:31 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 052EXqVR009024;
        Tue, 2 Jun 2020 10:46:30 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31cw8ubwx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Jun 2020 10:46:30 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 052EXsTE009210;
        Tue, 2 Jun 2020 10:46:30 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31cw8ubwwq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Jun 2020 10:46:30 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 052EjVMK022774;
        Tue, 2 Jun 2020 14:46:29 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma01dal.us.ibm.com with ESMTP id 31bwg2gdkp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Jun 2020 14:46:29 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 052EkQmk42664328
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Jun 2020 14:46:26 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A86C6124055;
        Tue,  2 Jun 2020 14:46:26 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF615124052;
        Tue,  2 Jun 2020 14:46:25 +0000 (GMT)
Received: from [9.160.63.236] (unknown [9.160.63.236])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  2 Jun 2020 14:46:25 +0000 (GMT)
Subject: Re: [PULL 08/10] vfio-ccw: Introduce a new CRW region
To:     Cornelia Huck <cohuck@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Farhan Ali <alifm@linux.ibm.com>
References: <20200525094115.222299-1-cohuck@redhat.com>
 <20200525094115.222299-9-cohuck@redhat.com>
 <20200602151313.0e639b57.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Autocrypt: addr=farman@linux.ibm.com; keydata=
 xsFNBF7EiEwBEADGG0EtNKnjp+kQfEVqlqxXoBHjnaQptFpMgxNlz2GtqOujY6nzEWnybIXY
 63XUTmMS/tWUf2DTbNCNoWwumGM/I2Gj1uGyMnc4Q477BQlL/e2/9MRaut11rwHsi4zmWylc
 jO0eFTSLFA8yFBj9osT3uZzk5TwWkD8sf+rD916fFVk0G39uYEd5sjEzjeOf9/dwXyZpjJY6
 api1pUHEw7weRvOnllJAfIKFz+KoR6d7ezvMF9zOYHF73FGeSVIYoIEUhA5Cdg60rSlTtHb2
 cftex3/cEapvY5bK3CKJ33BVVK10Bht9XfVaA/AOcg/3o5ZbhSIwz4xScGsEVf/Yr368YMdr
 3VkCZrmN2ppmVRz/RvAmCyItnmzoVDlSREA6Faw6S0x8Oi7lN0cKh2hy9VPcVupraXJZrdAh
 GtdU+jrJvSbpdsrX8F7K3RwynbiqGrqC0izGla04hhtei/uwthatglukuxep4PknDGbzijg8
 Ef7A8t3qEVklUDrsnNPN5HbR9QQdeF0HuWsDTfILbZv1MICfOK3BCDeT5mJWaJCoQ2rbuljM
 e1hFSt+mr7GV4h6NcBE+uGIqDSzQORtyTo0uBV4et3cSE84JxOfXBMrj0TlL1855JaIoPWEN
 uhDRB/dHW8+Fumq2du5hLcaXPka+MO26cNVKVLF0/JjwMTZ9bQARAQABzSJFcmljIEZhcm1h
 biA8ZmFybWFuQGxpbnV4LmlibS5jb20+wsF/BBMBAgApBQJexIhMAhsDBQkDwmcABwsJCAcD
 AgEGFQgCCQoLBBYCAwECHgECF4AACgkQOCeyEnG/lWJZWg/+NIsaagBT0/xghgkxl6dExEZH
 xKZdT+LqjG7Tpyl0c88SxzwNrpjV2y8SKFW2xAwKRslfJj3dQyleVKgMg92oB4hmBT8WaKQy
 /wj8wY0vP1lG21UMkZVtPHqxJ/AXQ75OpcsUwGVgDlqxmq9w/SJ0Dek7mz2QRdPFIs7UsdgI
 wtNBZJ/vaOpHJ5uiawtl7Y5iuhXDBh7m/+XOwgiOrr0x4mBcCw/T0dmKpOiKW1Kq//+UBAnw
 +PvL0J1/4Xae4RLBGWwlq0KeYxSylTB1GlWO98/shJe7Ao4+Efl9cIpgR8fEPN462MArQ+Wt
 tWjyaaLED76l/8o6rS4+WhioKQeA9CztelMmqp4LGUKw/2AuMQggXomogoYKjxo5JA1xGeqY
 MVOvANVXfsjryKjfB5cS1ulDqQ6ssaFjzCMisOaRFCN9IQzKteShpMrNS/1SPnlucuQRoAmc
 DbT6huCoat/2s+sYjGvRSv9lfp4ynEnxsCLxy4pBF8FjSJ39Hwzm1yLTwcbCpHWr9mJcvbPe
 gbjVgnhevvNwbMJW8qMB6TUIXW0xqGFst1NUJcpmNnM5QW+3BS7oSJNlOYaRhBCi/cwPjAPk
 f2A4V1X1jkvR37BoKwdWKBfAhZxaDAWAxO67Khd/bfoYhABf2pEokFmMJDBaxDhu90FUVecR
 HgGcIy+qC0bOwE0EXs/xBwEIAMjgCwgrSIGN5tWcHDJyT1VYWKlBfC5N323OFWDT+RERmoKC
 SjO5dFALGl6JK9Wh/s8G5Tlq3FhnRgNhKh6BsxY0BVR6hSJVNmDCAULIT9EeEOwrUerPyLp1
 M0HFnT/scbIkpDXiYyVW+9qnXN/WN7f/2xItWLAM8Nr2gRh/ncnhjG2h40zoQ7CXmYjok4zF
 ydq/896fOFUeaEyrkpD7f5GrxGn5Eyy1Fu1v4yL6enmcrtkCPJX1Wn/el4qdmCWOs37ckgre
 KP/y92/z+m5928Xt2RUy9GhCoMKV/WtQG8rGpXOKRvnhaMrXK23hiiXCZRA+5WN2QR1xwldc
 BbNq4jkAEQEAAcLCfgQYAQIACQUCXs/xBwIbAgEpCRA4J7IScb+VYsBdIAQZAQIABgUCXs/x
 BwAKCRC5YxtkvHVPqQOgB/47ODzRBF6TnD7CtbWdJoo8UIo5V3zoOaduAkgOgPxEfKomye+B
 nWyobRVS2vnphFNpJvsGiG6FpfOKw6/M5JmREQ2Io8a4tZgOxmPtiUeGzoyFsDqtH9oJ2+RO
 j2xEdFnFUgKXY1mIVnr8pgImfZjjZxUE0vaz80mJv9J7ldghzBvBlMuvB8swlR/P5MyfSoYJ
 /i2kNO8S62DIVmpxyhopKKzVCvdevrR+DwI4NTB165Rp24LZVzVUvMx8olfaVWBBJ9D0boJp
 AoNHQU4IAhsRnn4QxVohSPbB+inWxXkBpSu7zXpinKAooUXUC4PWOBXquoiv7j6FpK/m1RF2
 R8qNJ7MP/jqNUhre5ZNf6A86vKWdmq1Y8T674g6PE83hIgmk8N1gpSRClIBH7wclNNpJurFn
 m1NN7hY3E1qePonIPdtP6q+XGAoPWLxTZviy2UwnUNbc84UplyqQTSpZl1CjWzmC8ULUuGYz
 0rno5QOfp+07oUQgeG9m8Pa9tw0mQnRYEQF8mdQLR1LZQM6jg709SbnsjL+WhaMgjKoFjrC+
 BYByl7frg8Ga3cF12qL81eyqyqRt9HlC/mcOdoEyAz+hjUl4xwdQqccFHXQ1ps+F7LZOwKNB
 pSxQhRv197tJMBaccIPmGTEuK8cCxjy4Yb+yNrJKKT2e5/ZwshiE0xMCr66a/Ru/PMi7Pp7l
 2bN8Si191w3LydoA+L7cnpQGu8Ig1qsy1OgIFL1+gEIlK0YIwkdTih/DNiwu9Vo83B0lFGkp
 q0GQBKpFZOSKPWhmpyGQjnsX8JZnI4z7Xb6hTCQcuj0jdjVqVPtQYcHS6wCeQvR6bAr8T+3H
 HugjPX5iWL3pDPF45fJAFqRx3pRyo3kewjYpMjdkMZFeiCtioNUe3MGIFT1keNYI7+lN9nym
 DJjN6SL/ou1RmyPbYN8UbrZf4pnznNp+EPU8HLsyZcXBjrAJsUIHzBXzKpzAid4hjR9173tj
 GUMe3n9mjEOpz895uS+WdnAJ/67YjHTzhjeOvCDUEkQ4zsBNBF7P8SABCAC/Q0qm5QmeNgJQ
 Ej6c6DnBMOvOSwd1qpLHUT7qSUypSLc7da6xz+2vrLgVzcqIOtjeWjUDA9WBTs5xTPbtq/Ya
 X6DPiY8p38XQAJ+a9W/GtPeSmzCtEZrzG0pozfsRDQP7kyVrXXAxL2h4bj9YGphiiYMEhchM
 YJyF3VdO/XzBCLSkQVmG0KvD0e+0VvennjQjVpsi48QtUjqVaMkVX9bUVlABV31cTzm2BUDc
 eJFXZxqgQSwOKFnDgYymi4YebWut00VGQjW+/SxVPOaANAb28l5kT7y5BYtG1TbbeBgXt/Sq
 cUuqkPm/i88qlWqJ3+Vk/eGKIErJ56x34HAtmjBDABEBAAHCwV8EGAECAAkFAl7P8SACGwwA
 CgkQOCeyEnG/lWJPnQ/+LJPueYf1/AeqqNz4r2OIZ2zmCWfEpkFnrOjdkYwEltLn5Aocn7UK
 saSy5QLnqi7lghqXD56sNa7iz6rBrLWLBxxcsZkKcxed4G0knurc0tT2HcRp7zr8I+69Nv2z
 IGX5J/+HfT5VZ/UuWtd7EIsB0cjS2p4epg45SqwTs+2YFJFWvrnGa82wz2kn3qo++FMGoLpo
 g4pZixyvFP5sAV2vDzTWFk+WHokh7hu7SfgNIvuWmvLd2LUTrie0Mu3L06LMbmGAN+/mgeED
 uL6eI2QD500Zn+mnQm+Yyssjc832mJ9M5u2N2lu2FIR0aqaj3npyO0E4U4E9ftoVakktiHgj
 C+frRwEOdfO/UQgYtnpcxruhR/P0LfDABIswGtHYjgOEowSx+NA5+b+M5qTRWNjHSceeaIqF
 B2fUlEP/pfqexdXakkOL/w/Jz5YxCM45LdvArhVPn6GIvC127wFfFNTEV6hR0n4H58venlyM
 /HeaCx4x6DjvxfXw50+V37TA5Np9dlvAx4G1VTwWcO/bwsebfnE9lKKf7GOEDV0kauN071ve
 F52YQgFMAOyd+6nx9laZei0tx3NywCemO7puZ8kecla/ZZ2FqMMOoxefGBryFLFLuo38QHuG
 GmSZ8+uivkSx+PJ/h/7ZSAdrUzIbBk4SLVYTR4HzQ7U9ukgRMl78GiM=
Message-ID: <71bf02e5-dbb4-0b3f-0956-b1b13dadf42a@linux.ibm.com>
Date:   Tue, 2 Jun 2020 10:46:25 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200602151313.0e639b57.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-02_13:2020-06-02,2020-06-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 phishscore=0 impostorscore=0 clxscore=1015 adultscore=0
 suspectscore=0 mlxlogscore=999 cotscore=-2147483648 priorityscore=1501
 spamscore=0 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006020104
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/2/20 9:13 AM, Cornelia Huck wrote:
> On Mon, 25 May 2020 11:41:13 +0200
> Cornelia Huck <cohuck@redhat.com> wrote:
> 
>> From: Farhan Ali <alifm@linux.ibm.com>
>>
>> This region provides a mechanism to pass a Channel Report Word
>> that affect vfio-ccw devices, and needs to be passed to the guest
>> for its awareness and/or processing.
>>
>> The base driver (see crw_collect_info()) provides space for two
>> CRWs, as a subchannel event may have two CRWs chained together
>> (one for the ssid, one for the subchannel).  As vfio-ccw will
>> deal with everything at the subchannel level, provide space
>> for a single CRW to be transferred in one shot.
>>
>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>> Message-Id: <20200505122745.53208-7-farman@linux.ibm.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>  Documentation/s390/vfio-ccw.rst     | 19 ++++++++++
>>  drivers/s390/cio/vfio_ccw_chp.c     | 55 +++++++++++++++++++++++++++++
>>  drivers/s390/cio/vfio_ccw_drv.c     | 20 +++++++++++
>>  drivers/s390/cio/vfio_ccw_ops.c     |  8 +++++
>>  drivers/s390/cio/vfio_ccw_private.h |  4 +++
>>  include/uapi/linux/vfio.h           |  2 ++
>>  include/uapi/linux/vfio_ccw.h       |  8 +++++
>>  7 files changed, 116 insertions(+)
>>
> 
> (...)
> 
>> @@ -413,6 +423,16 @@ static int __init vfio_ccw_sch_init(void)
>>  		goto out_err;
>>  	}
>>  
>> +	vfio_ccw_crw_region = kmem_cache_create_usercopy("vfio_ccw_crw_region",
>> +					sizeof(struct ccw_crw_region), 0,
>> +					SLAB_ACCOUNT, 0,
>> +					sizeof(struct ccw_crw_region), NULL);
> 
> Ugh, I just tested this rebased to the s390 features branch, and I must
> have used some different options, because I now get
> 
>    kmem_cache_create(vfio_ccw_crw_region) integrity check failed
> 
> presumably due to the size of the ccw_crw_region.
> 
> We maybe need to pad it up (leave it unpacked)? Eric, what do you think?

Certainly packing a single one-word struct is weird, and the message is
coming out of the tiny struct itself:

mm/slab-common.c:88:
        if (!name || in_interrupt() || size < sizeof(void *) ||
                size > KMALLOC_MAX_SIZE) {
                pr_err("kmem_cache_create(%s) integrity check failed\n",
name);

That's protected by CONFIG_DEBUG_VM which wasn't enabled in my config.
So playing around with things, we'd have to explicitly add a pad (or the
second CRW, ha!) to get the struct back up to a doubleword. That'd be
fine with me.

> 
>> +
>> +	if (!vfio_ccw_crw_region) {
>> +		ret = -ENOMEM;
>> +		goto out_err;
>> +	}
>> +
>>  	isc_register(VFIO_CCW_ISC);
>>  	ret = css_driver_register(&vfio_ccw_sch_driver);
>>  	if (ret) {
> 
> (...)
> 
>> diff --git a/include/uapi/linux/vfio_ccw.h b/include/uapi/linux/vfio_ccw.h
>> index 758bf214898d..cff5076586df 100644
>> --- a/include/uapi/linux/vfio_ccw.h
>> +++ b/include/uapi/linux/vfio_ccw.h
>> @@ -44,4 +44,12 @@ struct ccw_schib_region {
>>  	__u8 schib_area[SCHIB_AREA_SIZE];
>>  } __packed;
>>  
>> +/*
>> + * Used for returning a Channel Report Word to userspace.
>> + * Note: this is controlled by a capability
>> + */
>> +struct ccw_crw_region {
>> +	__u32 crw;
>> +} __packed;
>> +
>>  #endif
> 
