Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2C3B447F7C
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 13:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239527AbhKHMg5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 07:36:57 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48634 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238062AbhKHMg4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Nov 2021 07:36:56 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A8BIBH1023131
        for <kvm@vger.kernel.org>; Mon, 8 Nov 2021 12:34:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=7NS8CMNsEiwArAtyTvp86cBvhRaajY3cBqrPQCfgEsk=;
 b=VulHTUyd6uFiK9uHE+OgdQzWobxi/I1haHiODJDRQ+2WcdHSA+mSlAIMEmp1kTCyJKjs
 5gdc+T6EqQ7ZzjZP8TQRrVoPKKZ6TGWRs0L0jLmUT4huF+SnUj+rpSYW7KX1zK73KGef
 lzzwVpADeBUiN5Iouq+c2VJelj+rqaO704HlubXtkzoXmcoPXbhoqcHvU0Kt36TwcASQ
 6r/Dixrh377JEjYTr3zr+6/l3J8C2XmZgII2Cc1SfrVAom0cZU7BydW1nZVXE86wCi6L
 53Ncwd7qclts19eUzOZFeNNs9n8zKisduU/X+fmLo7OSCvxOd2mTOfbPI55zbsQ0dRiC ZA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3c67qcdy92-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 12:34:11 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1A8C5Wk1008071
        for <kvm@vger.kernel.org>; Mon, 8 Nov 2021 12:34:11 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3c67qcdy89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 12:34:10 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A8CLASk021143;
        Mon, 8 Nov 2021 12:34:09 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3c5hb9crww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 12:34:09 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A8CY5Op66584926
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Nov 2021 12:34:05 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C7D2C42079;
        Mon,  8 Nov 2021 12:34:05 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC45E4207A;
        Mon,  8 Nov 2021 12:34:04 +0000 (GMT)
Received: from [9.171.49.228] (unknown [9.171.49.228])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Nov 2021 12:34:04 +0000 (GMT)
Message-ID: <509a8f4f-89cc-fe80-4200-6776c503adbf@linux.ibm.com>
Date:   Mon, 8 Nov 2021 13:34:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH 3/7] s390x: virtio: CCW transport
 implementation
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com, drjones@redhat.com
References: <1630059440-15586-1-git-send-email-pmorel@linux.ibm.com>
 <1630059440-15586-4-git-send-email-pmorel@linux.ibm.com>
 <74901bd1-e69f-99d3-b11e-e0b541226d20@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <74901bd1-e69f-99d3-b11e-e0b541226d20@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: EqBVaxkwpMTqYgtfyf93TtyawTdS2am_
X-Proofpoint-ORIG-GUID: CD6cB5QzAX4ouVVgDiYJJ_HSMG81L49y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-08_03,2021-11-08_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 adultscore=0 impostorscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 priorityscore=1501 spamscore=0 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111080079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/3/21 08:49, Thomas Huth wrote:
> On 27/08/2021 12.17, Pierre Morel wrote:
>> This is the implementation of the virtio-ccw transport level.
>>
>> We only support VIRTIO revision 0.
> 
> That means only legacy virtio? Wouldn't it be better to shoot for modern 
> virtio instead?

Yes but can we do it in a second series?
We will need more chqnges in the comon libraries.


> 
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/virtio-ccw.c | 374 +++++++++++++++++++++++++++++++++++++++++
>>   lib/s390x/virtio-ccw.h | 111 ++++++++++++
>>   lib/virtio-config.h    |  30 ++++
>>   s390x/Makefile         |   2 +
>>   4 files changed, 517 insertions(+)
>>   create mode 100644 lib/s390x/virtio-ccw.c
>>   create mode 100644 lib/s390x/virtio-ccw.h
>>   create mode 100644 lib/virtio-config.h
>>
>> diff --git a/lib/s390x/virtio-ccw.c b/lib/s390x/virtio-ccw.c
>> new file mode 100644
>> index 00000000..cf447de6
>> --- /dev/null
>> +++ b/lib/s390x/virtio-ccw.c
>> @@ -0,0 +1,374 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * Virtio CCW Library
>> + *
>> + * Copyright (c) 2021 IBM Corp
>> + *
>> + * Authors:
>> + *  Pierre Morel <pmorel@linux.ibm.com>
>> + *
>> + */
>> +
>> +#include <libcflat.h>
>> +#include <alloc_page.h>
>> +#include <asm/page.h>
>> +#include <string.h>
>> +#include <interrupt.h>
>> +#include <asm/arch_def.h>
>> +#include <asm/facility.h>
>> +#include <asm/uv.h>
>> +
>> +#include <css.h>
>> +#include <virtio.h>
>> +#include <virtio-config.h>
>> +#include <virtio-ccw.h>
>> +#include <malloc_io.h>
>> +
>> +static struct linked_list vcdev_list = {
>> +    .prev = &vcdev_list,
>> +    .next = &vcdev_list
>> +};
>> +
>> +static inline uint32_t swap16(uint32_t b)
>> +{
>> +        return (((b & 0xff00U) <<  8) |
>> +        ((b & 0x00ff) >>  8));
>> +}
>> +
>> +static inline uint32_t swap32(uint32_t b)
>> +{
>> +    return (((b & 0x000000ffU) << 24) |
>> +        ((b & 0x0000ff00U) <<  8) |
>> +        ((b & 0x00ff0000U) >>  8) |
>> +        ((b & 0xff000000U) >> 24));
>> +}
>> +
>> +static inline uint64_t swap64(uint64_t x)
>> +{
>> +    return (((x & 0x00000000000000ffULL) << 56) |
>> +        ((x & 0x000000000000ff00ULL) << 40) |
>> +        ((x & 0x0000000000ff0000ULL) << 24) |
>> +        ((x & 0x00000000ff000000ULL) <<  8) |
>> +        ((x & 0x000000ff00000000ULL) >>  8) |
>> +        ((x & 0x0000ff0000000000ULL) >> 24) |
>> +        ((x & 0x00ff000000000000ULL) >> 40) |
>> +        ((x & 0xff00000000000000ULL) >> 56));
>> +}
> 
> We already have macros for swapping in lib/asm-generic/io.h ... could 
> you use those instead?

Yes, I will.

> 
>> +/*
>> + * flags: flags for CCW
>> + * Returns !0 on failure
>> + * Returns 0 on success
>> + */
>> +int ccw_send(struct virtio_ccw_device *vcdev, int code, void *data, 
>> int count,
>> +         unsigned char flags)
>> +{
>> +    struct ccw1 *ccw;
>> +    int ret = -1;
>> +
>> +    ccw = alloc_io_mem(sizeof(*ccw), 0);
>> +    if (!ccw)
>> +        return ret;
>> +
>> +    /* Build the CCW chain with a single CCW */
>> +    ccw->code = code;
>> +    ccw->flags = flags;
>> +    ccw->count = count;
>> +    ccw->data_address = (unsigned long)data;
>> +
>> +    ret = start_ccw1_chain(vcdev->schid, ccw);
>> +    if (!ret)
>> +        ret = wait_and_check_io_completion(vcdev->schid);
>> +
>> +    free_io_mem(ccw, sizeof(*ccw));
>> +    return ret;
>> +}
>> +
>> +int virtio_ccw_set_revision(struct virtio_ccw_device *vcdev)
>> +{
>> +    struct virtio_rev_info *rev_info;
>> +    int ret = -1;
>> +
>> +    rev_info = alloc_io_mem(sizeof(*rev_info), 0);
>> +    if (!rev_info)
>> +        return ret;
>> +
>> +    rev_info->revision = VIRTIO_CCW_REV_MAX;
>> +    rev_info->revision = 0;
> 
> Either VIRTIO_CCW_REV_MAX or 0, but not both?

:D
Seems the second line has been forgotten.


> 
>> +    do {
>> +        ret = ccw_send(vcdev, CCW_CMD_SET_VIRTIO_REV, rev_info,
>> +                   sizeof(*rev_info), 0);
>> +    } while (ret && rev_info->revision--);
>> +
>> +    free_io_mem(rev_info, sizeof(*rev_info));
>> +
>> +    return ret ? -1 : rev_info->revision;
>> +}
>> +
>> +int virtio_ccw_reset(struct virtio_ccw_device *vcdev)
>> +{
>> +    return ccw_send(vcdev, CCW_CMD_VDEV_RESET, 0, 0, 0);
>> +}
>> +
>> +int virtio_ccw_read_status(struct virtio_ccw_device *vcdev)
>> +{
>> +    return ccw_send(vcdev, CCW_CMD_READ_STATUS, &vcdev->status,
>> +            sizeof(vcdev->status), 0);
>> +}
>> +
>> +int virtio_ccw_write_status(struct virtio_ccw_device *vcdev)
>> +{
>> +    return ccw_send(vcdev, CCW_CMD_WRITE_STATUS, &vcdev->status,
>> +            sizeof(vcdev->status), 0);
>> +}
>> +
>> +int virtio_ccw_read_features(struct virtio_ccw_device *vcdev, 
>> uint64_t *features)
>> +{
>> +    struct virtio_feature_desc *f_desc = &vcdev->f_desc;
>> +
>> +    f_desc->index = 0;
>> +    if (ccw_send(vcdev, CCW_CMD_READ_FEAT, f_desc, sizeof(*f_desc), 0))
>> +        return -1;
>> +    *features = swap32(f_desc->features);
>> +
>> +    f_desc->index = 1;
>> +    if (ccw_send(vcdev, CCW_CMD_READ_FEAT, f_desc, sizeof(*f_desc), 0))
>> +        return -1;
>> +    *features |= (uint64_t)swap32(f_desc->features) << 32;
> 
> Weren't the upper feature bits only available for modern virtio anyway?

Yes.
I have the intention to upgrade to Rev. 1 when I get enough time for it.
Should I remove this? It does not induce problem does it?

> 
>> +    return 0;
>> +}
>> +
>> +int virtio_ccw_write_features(struct virtio_ccw_device *vcdev, 
>> uint64_t features)
>> +{
>> +    struct virtio_feature_desc *f_desc = &vcdev->f_desc;
>> +
>> +    f_desc->index = 0;
>> +    f_desc->features = swap32((uint32_t)features & 0xffffffff);
>> +    if (ccw_send(vcdev, CCW_CMD_WRITE_FEAT, &f_desc, sizeof(*f_desc), 
>> 0))
>> +        return -1;
>> +
>> +    f_desc->index = 1;
>> +    f_desc->features = swap32((uint32_t)(features >> 32) & 0xffffffff);
>> +    if (ccw_send(vcdev, CCW_CMD_WRITE_FEAT, &f_desc, sizeof(*f_desc), 
>> 0))
>> +        return -1;
>> +
>> +    return 0;
>> +}
>> +
>> +int virtio_ccw_read_config(struct virtio_ccw_device *vcdev)
>> +{
>> +    return ccw_send(vcdev, CCW_CMD_READ_CONF, &vcdev->config,
>> +            sizeof(vcdev->config), 0);
>> +}
>> +
>> +int virtio_ccw_write_config(struct virtio_ccw_device *vcdev)
>> +{
>> +    return ccw_send(vcdev, CCW_CMD_WRITE_CONF, &vcdev->config,
>> +            sizeof(vcdev->config), 0);
>> +}
>> +
>> +int virtio_ccw_setup_indicators(struct virtio_ccw_device *vcdev)
>> +{
>> +    vcdev->ind = alloc_io_mem(sizeof(PAGE_SIZE), 0);
>> +    if (ccw_send(vcdev, CCW_CMD_SET_IND, &vcdev->ind,
>> +             sizeof(vcdev->ind), 0))
>> +        return -1;
>> +
>> +    vcdev->conf_ind = alloc_io_mem(PAGE_SIZE, 0);
>> +    if (ccw_send(vcdev, CCW_CMD_SET_CONF_IND, &vcdev->conf_ind,
>> +             sizeof(vcdev->conf_ind), 0))
>> +        return -1;
>> +
>> +    return 0;
>> +}
>> +
>> +static uint64_t virtio_ccw_notify_host(int schid, int queue, uint64_t 
>> cookie)
>> +{
>> +    register unsigned long nr asm("1") = 0x03;
>> +    register unsigned long s asm("2") = schid;
>> +    register unsigned long q asm("3") = queue;
>> +    register long rc asm("2");
> 
> Using asm("2") for two variables looks somewhat weird ... but ok, as 
> long as it works... (otherwise you could also use only one variable and 
> mark it as input + output parameter below).

OK

> 
>> +    register long c asm("4") = cookie;
>> +
>> +    asm volatile ("diag 2,4,0x500\n"
>> +            : "=d" (rc)
>> +            : "d" (nr), "d" (s), "d" (q), "d"(c)
>> +            : "memory", "cc");
>> +    return rc;
>> +}
>> +
>> +static bool virtio_ccw_notify(struct virtqueue *vq)
>> +{
>> +    struct virtio_ccw_device *vcdev = to_vc_device(vq->vdev);
>> +    struct virtio_ccw_vq_info *info = vq->priv;
>> +
>> +    info->cookie = virtio_ccw_notify_host(vcdev->schid, vq->index,
>> +                          info->cookie);
>> +    if (info->cookie < 0)
>> +        return false;
>> +    return true;
>> +}
>> +
>> +/* allocates a vring_virtqueue but returns a pointer to the
>> + * virtqueue inside of it or NULL on error.
>> + */
>> +static struct virtqueue *setup_vq(struct virtio_device *vdev, int index,
>> +                  void (*callback)(struct virtqueue *vq),
>> +                  const char *name)
>> +{
>> +    struct virtio_ccw_device *vcdev = to_vc_device(vdev);
>> +    struct virtio_ccw_vq_info *info;
>> +    struct vring_virtqueue *vq;
>> +    struct vring *vr;
>> +    void *queue;
>> +
>> +    vq = alloc_io_mem(sizeof(*vq), 0);
>> +    info = alloc_io_mem(sizeof(*info), 0);
>> +    queue = alloc_io_mem(4 * PAGE_SIZE, 0);
>> +    assert(vq && queue && info);
>> +
>> +    info->info_block = alloc_io_mem(sizeof(*info->info_block), 0);
>> +    assert(info->info_block);
>> +
>> +    vcdev->vq_conf.index = index;
>> +    if (ccw_send(vcdev, CCW_CMD_READ_VQ_CONF, &vcdev->vq_conf,
>> +             sizeof(vcdev->vq_conf), 0))
>> +        return NULL;
>> +
>> +    vring_init_virtqueue(vq, index, vcdev->vq_conf.max_num, 
>> PAGE_SIZE, vdev,
>> +                 queue, virtio_ccw_notify, callback, name);
>> +
>> +    vr = &vq->vring;
>> +    info->info_block->s.desc = vr->desc;
>> +    info->info_block->s.index = index;
>> +    info->info_block->s.num = vr->num;
>> +    info->info_block->s.avail = vr->avail;
>> +    info->info_block->s.used = vr->used;
>> +
>> +    info->info_block->l.desc = vr->desc;
>> +    info->info_block->l.index = index;
>> +    info->info_block->l.num = vr->num;
>> +    info->info_block->l.align = PAGE_SIZE;
>> +
>> +    if (ccw_send(vcdev, CCW_CMD_SET_VQ, info->info_block,
>> +             sizeof(info->info_block->l), 0))
>> +        return NULL;
>> +
>> +    info->vq = &vq->vq;
>> +    vq->vq.priv = info;
>> +
>> +    return &vq->vq;
>> +}
>> +
>> +static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned 
>> int nvqs,
>> +                   struct virtqueue *vqs[], vq_callback_t *callbacks[],
>> +                   const char *names[])
>> +{
>> +    int i;
>> +
>> +    for (i = 0; i < nvqs; ++i) {
>> +        vqs[i] = setup_vq(vdev, i,
>> +                  callbacks ? callbacks[i] : NULL,
>> +                  names ? names[i] : "");
>> +        if (!vqs[i])
>> +            return -1;
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>> +static void virtio_ccw_config_get(struct virtio_device *vdev,
>> +                  unsigned int offset, void *buf,
>> +                  unsigned int len)
>> +{
>> +    struct virtio_ccw_device *vcdev = to_vc_device(vdev);
>> +
>> +    if (virtio_ccw_read_config(vcdev))
>> +        return;
>> +    memcpy(buf, vcdev->config, len);
>> +}
>> +
>> +static void virtio_ccw_config_set(struct virtio_device *vdev,
>> +                  unsigned int offset, const void *buf,
>> +                  unsigned int len)
>> +{
>> +    struct virtio_ccw_device *vcdev = to_vc_device(vdev);
>> +
>> +    memcpy(vcdev->config, buf, len);
>> +    virtio_ccw_write_config(vcdev);
>> +}
>> +
>> +static const struct virtio_config_ops virtio_ccw_ops = {
>> +    .get = virtio_ccw_config_get,
>> +    .set = virtio_ccw_config_set,
>> +    .find_vqs = virtio_ccw_find_vqs,
>> +};
>> +
>> +const struct virtio_config_ops *virtio_ccw_register(void)
>> +{
>> +    return &virtio_ccw_ops;
>> +}
>> +
>> +static int sense(struct virtio_ccw_device *vcdev)
>> +{
>> +    struct senseid *senseid;
>> +
>> +    senseid = alloc_io_mem(sizeof(*senseid), 0);
>> +    assert(senseid);
>> +
>> +    assert(!ccw_send(vcdev, CCW_CMD_SENSE_ID, senseid, 
>> sizeof(*senseid), 0));
>> +
>> +    assert(senseid->reserved == 0xff);
>> +
>> +    vcdev->cu_type = senseid->cu_type;
>> +    vcdev->cu_model = senseid->cu_model;
>> +    vcdev->dev_type = senseid->dev_type;
>> +    vcdev->dev_model = senseid->dev_model;
>> +
>> +    return 0;
>> +}
>> +
>> +static struct virtio_ccw_device *find_vcdev_by_devid(int devid)
>> +{
>> +    struct virtio_ccw_device *dev;
>> +    struct linked_list *l;
>> +
>> +    for (l = vcdev_list.next; l != &vcdev_list; l = l->next) {
>> +        dev = container_of(l, struct virtio_ccw_device, list);
>> +        if (dev->cu_model == devid)
>> +            return dev;
>> +    }
>> +    return NULL;
>> +}
>> +
>> +struct virtio_device *virtio_bind(u32 devid)
>> +{
>> +    struct virtio_ccw_device *vcdev;
>> +
>> +    vcdev = find_vcdev_by_devid(devid);
>> +
>> +    return &vcdev->vdev;
>> +}
>> +
>> +static int virtio_enumerate(int schid)
>> +{
>> +    struct virtio_ccw_device *vcdev;
>> +
>> +    vcdev = alloc_io_mem(sizeof(*vcdev), 0);
>> +    assert(vcdev);
>> +    vcdev->schid = schid;
>> +
>> +    list_add(&vcdev_list, &vcdev->list);
>> +
>> +    assert(css_enable(schid, IO_SCH_ISC) == 0);
>> +    sense(vcdev);
>> +
>> +    return 0;
>> +}
>> +
>> +/* Must get a param */
> 
> I don't understand that comment, could you elaborate?

No, sorry.
I forgot what I wanted to say here.
May be it comes back when I will work on the comments from you and Andrew.


Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
