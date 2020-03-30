Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94F121975CA
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 09:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729463AbgC3Hec (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 03:34:32 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53916 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728955AbgC3Hec (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 03:34:32 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02U7XZUH108856
        for <kvm@vger.kernel.org>; Mon, 30 Mar 2020 03:34:30 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3020qrjtr9-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 30 Mar 2020 03:34:30 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 30 Mar 2020 08:34:27 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 30 Mar 2020 08:34:23 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02U7XKhM46203184
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Mar 2020 07:33:20 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82E984C05A;
        Mon, 30 Mar 2020 07:34:23 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0242D4C050;
        Mon, 30 Mar 2020 07:34:23 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.3.56])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 30 Mar 2020 07:34:22 +0000 (GMT)
Subject: Re: [PATCH 0/6] vhost: Reset batched descriptors on SET_VRING_BASE
 call
To:     Eugenio Perez Martin <eperezma@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200329113359.30960-1-eperezma@redhat.com>
 <bb95e827-f219-32fd-0046-41046eec058b@de.ibm.com>
 <CAJaqyWePfMcXhYEPxKYV22J3cYtO=DUXCj1Yf=7XH+khXHop9A@mail.gmail.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Mon, 30 Mar 2020 09:34:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAJaqyWePfMcXhYEPxKYV22J3cYtO=DUXCj1Yf=7XH+khXHop9A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20033007-0028-0000-0000-000003EE85D0
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20033007-0029-0000-0000-000024B40335
Message-Id: <41dfa0e5-8013-db15-cbfe-aa4574cfb9a0@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-30_01:2020-03-27,2020-03-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 suspectscore=0 lowpriorityscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003300067
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 30.03.20 09:18, Eugenio Perez Martin wrote:
> On Mon, Mar 30, 2020 at 9:14 AM Christian Borntraeger
> <borntraeger@de.ibm.com> wrote:
>>
>>
>> On 29.03.20 13:33, Eugenio Pérez wrote:
>>> Vhost did not reset properly the batched descriptors on SET_VRING_BASE event. Because of that, is possible to return an invalid descriptor to the guest.
>>
>> I guess this could explain my problems that I have seen during reset?
>>
> 
> Yes, I think so. The series has a test that should reproduce more or
> less what you are seeing. However, it would be useful to reproduce on
> your system and to know what causes qemu to send the reset :).

I do see SET_VRING_BASE in the debug output
[228101.438630] [2113] vhost:vhost_vring_ioctl:1668: VHOST_GET_VRING_BASE [vq=00000000618905fc][s.index=1][s.num=42424][vq->avail_idx=42424][vq->last_avail_idx=42424][vq->ndescs=0][vq->first_desc=0]
[228101.438631] CPU: 54 PID: 2113 Comm: qemu-system-s39 Not tainted 5.5.0+ #344
[228101.438632] Hardware name: IBM 3906 M04 704 (LPAR)
[228101.438633] Call Trace:
[228101.438634]  [<00000004fc71c132>] show_stack+0x8a/0xd0 
[228101.438636]  [<00000004fd10e72a>] dump_stack+0x8a/0xb8 
[228101.438639]  [<000003ff80377600>] vhost_vring_ioctl+0x668/0x848 [vhost] 
[228101.438640]  [<000003ff80395fd4>] vhost_net_ioctl+0x4f4/0x570 [vhost_net] 
[228101.438642]  [<00000004fc9ccdd8>] do_vfs_ioctl+0x430/0x6f8 
[228101.438643]  [<00000004fc9cd124>] ksys_ioctl+0x84/0xb0 
[228101.438645]  [<00000004fc9cd1ba>] __s390x_sys_ioctl+0x2a/0x38 
[228101.438646]  [<00000004fd12ff72>] system_call+0x2a6/0x2c8 
[228103.682732] [2122] vhost:vhost_vring_ioctl:1653: VHOST_SET_VRING_BASE [vq=000000009e1ac3e7][s.index=0][s.num=0][vq->avail_idx=27875][vq->last_avail_idx=27709][vq->ndescs=65][vq->first_desc=22]
[228103.682735] CPU: 44 PID: 2122 Comm: CPU 0/KVM Not tainted 5.5.0+ #344
[228103.682739] Hardware name: IBM 3906 M04 704 (LPAR)
[228103.682741] Call Trace:
[228103.682748]  [<00000004fc71c132>] show_stack+0x8a/0xd0 
[228103.682752]  [<00000004fd10e72a>] dump_stack+0x8a/0xb8 
[228103.682761]  [<000003ff80377422>] vhost_vring_ioctl+0x48a/0x848 [vhost] 
[228103.682764]  [<000003ff80395fd4>] vhost_net_ioctl+0x4f4/0x570 [vhost_net] 
[228103.682767]  [<00000004fc9ccdd8>] do_vfs_ioctl+0x430/0x6f8 
[228103.682769]  [<00000004fc9cd124>] ksys_ioctl+0x84/0xb0 
[228103.682771]  [<00000004fc9cd1ba>] __s390x_sys_ioctl+0x2a/0x38 
[228103.682773]  [<00000004fd12ff72>] system_call+0x2a6/0x2c8 
[228103.682794] [2122] vhost:vhost_vring_ioctl:1653: VHOST_SET_VRING_BASE [vq=00000000618905fc][s.index=1][s.num=0][vq->avail_idx=42424][vq->last_avail_idx=42424][vq->ndescs=0][vq->first_desc=0]
[228103.682795] CPU: 44 PID: 2122 Comm: CPU 0/KVM Not tainted 5.5.0+ #344
[228103.682797] Hardware name: IBM 3906 M04 704 (LPAR)
[228103.682797] Call Trace:
[228103.682799]  [<00000004fc71c132>] show_stack+0x8a/0xd0 
[228103.682801]  [<00000004fd10e72a>] dump_stack+0x8a/0xb8 
[228103.682804]  [<000003ff80377422>] vhost_vring_ioctl+0x48a/0x848 [vhost] 
[228103.682806]  [<000003ff80395fd4>] vhost_net_ioctl+0x4f4/0x570 [vhost_net] 
[228103.682808]  [<00000004fc9ccdd8>] do_vfs_ioctl+0x430/0x6f8 
[228103.682810]  [<00000004fc9cd124>] ksys_ioctl+0x84/0xb0 
[228103.682812]  [<00000004fc9cd1ba>] __s390x_sys_ioctl+0x2a/0x38 
[228103.682813]  [<00000004fd12ff72>] system_call+0x2a6/0x2c8 


Isnt that triggered by resetting the virtio devices during system reboot?

