Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E514419B64B
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 21:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732532AbgDATNc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Apr 2020 15:13:32 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55472 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732211AbgDATNc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Apr 2020 15:13:32 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 031J3FWk076379
        for <kvm@vger.kernel.org>; Wed, 1 Apr 2020 15:13:30 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 304edx8nvp-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 01 Apr 2020 15:13:30 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Wed, 1 Apr 2020 20:13:26 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 1 Apr 2020 20:13:23 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 031JDOFu44761476
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Apr 2020 19:13:24 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 280A24C040;
        Wed,  1 Apr 2020 19:13:24 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 678F64C044;
        Wed,  1 Apr 2020 19:13:23 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.71.143])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  1 Apr 2020 19:13:23 +0000 (GMT)
Subject: Re: [PATCH v3 0/8] vhost: Reset batched descriptors on SET_VRING_BASE
 call
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Eugenio Perez Martin <eperezma@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        kvm list <kvm@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
References: <20200331192804.6019-1-eperezma@redhat.com>
 <c4d2b0b4-0b6d-cd74-0eb5-e7fdfe063d42@de.ibm.com>
 <CAJaqyWc+fNzHE_p-pApZtj2ypNQfFLawCWf8GJmP8e=k=C+EgA@mail.gmail.com>
 <916e60f8-45fe-5cc1-d5a1-defdcd00d75b@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Wed, 1 Apr 2020 21:13:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <916e60f8-45fe-5cc1-d5a1-defdcd00d75b@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20040119-0028-0000-0000-000003F03378
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040119-0029-0000-0000-000024B5BAC9
Message-Id: <6d16572f-34e9-4806-a5f8-94d8f75db352@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-01_04:2020-03-31,2020-04-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 lowpriorityscore=0
 suspectscore=0 adultscore=0 priorityscore=1501 mlxscore=0 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004010151
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>> Would it be possible to investigate when qemu launches the offending ioctls?
> 
> During guest reboot. This is obvious, no?
> 


For example during reboot we do re-setup the virt queues:

#1  0x00000000010f3e7a in vhost_kernel_set_vring_base (dev=0x21f5f30, ring=0x3ff84d74e88) at /home/cborntra/REPOS/qemu/hw/virtio/vhost-backend.c:126
#2  0x00000000010f2f92 in vhost_virtqueue_start (idx=0, vq=0x21f6180, vdev=0x241d570, dev=0x21f5f30) at /home/cborntra/REPOS/qemu/hw/virtio/vhost.c:1016
#3  vhost_dev_start (hdev=hdev@entry=0x21f5f30, vdev=vdev@entry=0x241d570) at /home/cborntra/REPOS/qemu/hw/virtio/vhost.c:1646
#4  0x00000000011c265a in vhost_net_start_one (dev=0x241d570, net=0x21f5f30) at /home/cborntra/REPOS/qemu/hw/net/vhost_net.c:236
#5  vhost_net_start (dev=dev@entry=0x241d570, ncs=0x2450f40, total_queues=total_queues@entry=1) at /home/cborntra/REPOS/qemu/hw/net/vhost_net.c:338
#6  0x00000000010cfdfe in virtio_net_vhost_status (status=15 '\017', n=0x241d570) at /home/cborntra/REPOS/qemu/hw/net/virtio-net.c:250
#7  virtio_net_set_status (vdev=0x241d570, status=<optimized out>) at /home/cborntra/REPOS/qemu/hw/net/virtio-net.c:331
#8  0x00000000010eaef4 in virtio_set_status (vdev=vdev@entry=0x241d570, val=<optimized out>) at /home/cborntra/REPOS/qemu/hw/virtio/virtio.c:1956
#9  0x000000000110ba78 in virtio_ccw_cb (sch=0x2422c30, ccw=...) at /home/cborntra/REPOS/qemu/hw/s390x/virtio-ccw.c:509
#10 0x00000000011053fc in css_interpret_ccw (sch=sch@entry=0x2422c30, ccw_addr=<optimized out>, suspend_allowed=suspend_allowed@entry=false) at /home/cborntra/REPOS/qemu/hw/s390x/css.c:1108
#11 0x000000000110557c in sch_handle_start_func_virtual (sch=0x2422c30) at /home/cborntra/REPOS/qemu/hw/s390x/css.c:1162
#12 do_subchannel_work_virtual (sch=0x2422c30) at /home/cborntra/REPOS/qemu/hw/s390x/css.c:1256
#13 0x0000000001168592 in ioinst_handle_ssch (cpu=cpu@entry=0x234b920, reg1=<optimized out>, ipb=<optimized out>, ra=ra@entry=0) at /home/cborntra/REPOS/qemu/target/s390x/ioinst.c:218
#14 0x0000000001170012 in handle_b2 (ipa1=<optimized out>, run=0x3ff97880000, cpu=0x234b920) at /home/cborntra/REPOS/qemu/target/s390x/kvm.c:1279
#15 handle_instruction (run=0x3ff97880000, cpu=0x234b920) at /home/cborntra/REPOS/qemu/target/s390x/kvm.c:1664
#16 handle_intercept (cpu=0x234b920) at /home/cborntra/REPOS/qemu/target/s390x/kvm.c:1747
#17 kvm_arch_handle_exit (cs=cs@entry=0x234b920, run=run@entry=0x3ff97880000) at /home/cborntra/REPOS/qemu/target/s390x/kvm.c:1937
#18 0x00000000010972dc in kvm_cpu_exec (cpu=cpu@entry=0x234b920) at /home/cborntra/REPOS/qemu/accel/kvm/kvm-all.c:2445
#19 0x00000000010784f6 in qemu_kvm_cpu_thread_fn (arg=0x234b920) at /home/cborntra/REPOS/qemu/cpus.c:1246
#20 qemu_kvm_cpu_thread_fn (arg=arg@entry=0x234b920) at /home/cborntra/REPOS/qemu/cpus.c:1218
#21 0x00000000013891fa in qemu_thread_start (args=0x2372f30) at /home/cborntra/REPOS/qemu/util/qemu-thread-posix.c:519
#22 0x000003ff93809ed6 in start_thread () from target:/lib64/libpthread.so.0
#23 0x000003ff93705e46 in thread_start () from target:/lib64/libc.so.6

