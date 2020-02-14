Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 367A315D74F
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 13:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbgBNMW6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 07:22:58 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26990 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728748AbgBNMWz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Feb 2020 07:22:55 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01ECKld1134686
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2020 07:22:53 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y1tn7cefc-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2020 07:22:53 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Fri, 14 Feb 2020 12:22:51 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 14 Feb 2020 12:22:48 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01ECMlxl42729754
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Feb 2020 12:22:47 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98774AE057;
        Fri, 14 Feb 2020 12:22:47 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 501FDAE056;
        Fri, 14 Feb 2020 12:22:47 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.152.224.211])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 14 Feb 2020 12:22:47 +0000 (GMT)
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
 <CAJaqyWfngzP4d01B6+Sqt8FXN6jX7kGegjx8ie4no_1Er3igQA@mail.gmail.com>
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
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Fri, 14 Feb 2020 13:22:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <35dca16b9a85eb203f35d3e55dcaa9d0dae5a922.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20021412-0016-0000-0000-000002E6C505
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021412-0017-0000-0000-00003349CC77
Message-Id: <3144806d-436e-86a1-2e29-74f7027f7f0b@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-14_03:2020-02-12,2020-02-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 malwarescore=0 mlxscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002140102
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 14.02.20 13:17, Eugenio Pérez wrote:
> Can you try the inlined patch over 52c36ce7f334 ("vhost: use batched version by default")? My intention is to check if
> "strange VHOST_SET_VRING_BASE" line appears. In previous tests, it appears very fast, but maybe it takes some time for
> it to appear, or it does not appear anymore.

  LD [M]  drivers/vhost/vhost_vsock.o
  CC [M]  drivers/vhost/vhost.o
In file included from ./include/linux/printk.h:331,
                 from ./include/linux/kernel.h:15,
                 from ./include/linux/list.h:9,
                 from ./include/linux/wait.h:7,
                 from ./include/linux/eventfd.h:13,
                 from drivers/vhost/vhost.c:13:
drivers/vhost/vhost.c: In function ‘fetch_descs’:
drivers/vhost/vhost.c:2330:56: error: ‘struct vhost_virtqueue’ has no member named ‘first_desc’
 2330 |   vq, vq->last_avail_idx, vq->avail_idx, vq->ndescs, vq->first_desc);
      |                                                        ^~
./include/linux/dynamic_debug.h:125:15: note: in definition of macro ‘__dynamic_func_call’
  125 |   func(&id, ##__VA_ARGS__);  \
      |               ^~~~~~~~~~~
./include/linux/dynamic_debug.h:153:2: note: in expansion of macro ‘_dynamic_func_call’
  153 |  _dynamic_func_call(fmt, __dynamic_pr_debug,  \
      |  ^~~~~~~~~~~~~~~~~~
./include/linux/printk.h:335:2: note: in expansion of macro ‘dynamic_pr_debug’
  335 |  dynamic_pr_debug(fmt, ##__VA_ARGS__)
      |  ^~~~~~~~~~~~~~~~
drivers/vhost/vhost.c:2328:2: note: in expansion of macro ‘pr_debug’
 2328 |  pr_debug(
      |  ^~~~~~~~
make[2]: *** [scripts/Makefile.build:266: drivers/vhost/vhost.o] Error 1
make[1]: *** [scripts/Makefile.build:503: drivers/vhost] Error 2

