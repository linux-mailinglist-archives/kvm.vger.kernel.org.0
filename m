Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0D1D281830
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 18:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387692AbgJBQpB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 12:45:01 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:29512 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726017AbgJBQpA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Oct 2020 12:45:00 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 092GVwrx006908;
        Fri, 2 Oct 2020 12:43:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=2+A3Co7DfxkWQ8HV8UobuhVZsZR1j3dufeR3zFyNIJM=;
 b=ZL6lpAo76UUwp11NPj6zYDs8uDEd5Eg4s8Bnu+x6A9pDfY4v17ur2V5/VQAm1Xsa8WoZ
 jF57ZhyECCCEOAt7VEtCJ+X/62wSfpjwuK8OmQILaGAJlfyt2IHdnxk4i2PTbV8C5+y2
 E8QrbmluwZPKJ8nkfjZ4pV2KHv9Srg8dbS4C4+LjouCp1w1golKNt2NX64W5vFoFU3mx
 GraG/FKAidg+fls6cQa0tWqYA9UpnCVqQINCGpM6utTnAAyg9W8PYf1GW7PzOz6aQuMF
 ueSdxKKi3wtCWnYS16nDlnkvuNyIusRowWITviL71dULf4YjNRCfBzdgzDBNFIg1cgvz Tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33x5rycn28-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 12:43:16 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 092GWgtP009181;
        Fri, 2 Oct 2020 12:43:15 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33x5rycn1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 12:43:15 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 092GcU34023331;
        Fri, 2 Oct 2020 16:43:13 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma05wdc.us.ibm.com with ESMTP id 33sw99y7yv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 16:43:13 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 092GhDIh14615524
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Oct 2020 16:43:13 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 120D4AC05B;
        Fri,  2 Oct 2020 16:43:13 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E754AC059;
        Fri,  2 Oct 2020 16:43:04 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.4.25])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  2 Oct 2020 16:43:04 +0000 (GMT)
Subject: Re: [PATCH v3] qemu/atomic.h: rename atomic_ to qatomic_
To:     Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org
Cc:     Fam Zheng <fam@euphon.net>,
        Peter Maydell <peter.maydell@linaro.org>,
        sheepdog@lists.wpkg.org, Paul Durrant <paul@xen.org>,
        Jason Wang <jasowang@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Yuval Shaia <yuval.shaia.ml@gmail.com>,
        Markus Armbruster <armbru@redhat.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Huacai Chen <chenhc@lemote.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Alberto Garcia <berto@igalia.com>, kvm@vger.kernel.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Juan Quintela <quintela@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        =?UTF-8?Q?Marc-Andr=c3=a9_Lureau?= <marcandre.lureau@redhat.com>,
        Liu Yuan <namei.unix@gmail.com>,
        Richard Henderson <rth@twiddle.net>,
        Thomas Huth <thuth@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Stefan Weil <sw@weilnetz.de>, Peter Lieven <pl@kamp.de>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        qemu-s390x@nongnu.org, qemu-arm@nongnu.org,
        xen-devel@lists.xenproject.org, qemu-riscv@nongnu.org,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        John Snow <jsnow@redhat.com>,
        Hailiang Zhang <zhang.zhanghailiang@huawei.com>,
        Kevin Wolf <kwolf@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        qemu-block@nongnu.org,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        Cornelia Huck <cohuck@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>,
        Max Reitz <mreitz@redhat.com>,
        Sagar Karandikar <sagark@eecs.berkeley.edu>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20200923105646.47864-1-stefanha@redhat.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <4e65d6fa-0a7e-015b-eb6f-5dd1cc3ddd91@linux.ibm.com>
Date:   Fri, 2 Oct 2020 12:43:03 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200923105646.47864-1-stefanha@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-02_10:2020-10-02,2020-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 phishscore=0 adultscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1011 bulkscore=0 priorityscore=1501 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020121
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/23/20 6:56 AM, Stefan Hajnoczi wrote:
> clang's C11 atomic_fetch_*() functions only take a C11 atomic type
> pointer argument. QEMU uses direct types (int, etc) and this causes a
> compiler error when a QEMU code calls these functions in a source file
> that also included <stdatomic.h> via a system header file:
> 
>    $ CC=clang CXX=clang++ ./configure ... && make
>    ../util/async.c:79:17: error: address argument to atomic operation must be a pointer to _Atomic type ('unsigned int *' invalid)
> 
> Avoid using atomic_*() names in QEMU's atomic.h since that namespace is
> used by <stdatomic.h>. Prefix QEMU's APIs with 'q' so that atomic.h
> and <stdatomic.h> can co-exist. I checked /usr/include on my machine and
> searched GitHub for existing "qatomic_" users but there seem to be none.
> 
> This patch was generated using:
> 
>    $ git grep -h -o '\<atomic\(64\)\?_[a-z0-9_]\+' include/qemu/atomic.h | \
>      sort -u >/tmp/changed_identifiers
>    $ for identifier in $(</tmp/changed_identifiers); do
>          sed -i "s%\<$identifier\>%q$identifier%g" \
>              $(git grep -I -l "\<$identifier\>")
>      done
> 
> I manually fixed line-wrap issues and misaligned rST tables.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
..snip..
> diff --git a/include/standard-headers/drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h b/include/standard-headers/drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h
> index acd4c8346d..7b4062a1a1 100644
> --- a/include/standard-headers/drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h
> +++ b/include/standard-headers/drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h
> @@ -68,7 +68,7 @@ static inline int pvrdma_idx_valid(uint32_t idx, uint32_t max_elems)
>   
>   static inline int32_t pvrdma_idx(int *var, uint32_t max_elems)
>   {
> -	const unsigned int idx = atomic_read(var);
> +	const unsigned int idx = qatomic_read(var);
>   
>   	if (pvrdma_idx_valid(idx, max_elems))
>   		return idx & (max_elems - 1);
> @@ -77,17 +77,17 @@ static inline int32_t pvrdma_idx(int *var, uint32_t max_elems)
>   
>   static inline void pvrdma_idx_ring_inc(int *var, uint32_t max_elems)
>   {
> -	uint32_t idx = atomic_read(var) + 1;	/* Increment. */
> +	uint32_t idx = qatomic_read(var) + 1;	/* Increment. */
>   
>   	idx &= (max_elems << 1) - 1;		/* Modulo size, flip gen. */
> -	atomic_set(var, idx);
> +	qatomic_set(var, idx);
>   }
>   
>   static inline int32_t pvrdma_idx_ring_has_space(const struct pvrdma_ring *r,
>   					      uint32_t max_elems, uint32_t *out_tail)
>   {
> -	const uint32_t tail = atomic_read(&r->prod_tail);
> -	const uint32_t head = atomic_read(&r->cons_head);
> +	const uint32_t tail = qatomic_read(&r->prod_tail);
> +	const uint32_t head = qatomic_read(&r->cons_head);
>   
>   	if (pvrdma_idx_valid(tail, max_elems) &&
>   	    pvrdma_idx_valid(head, max_elems)) {
> @@ -100,8 +100,8 @@ static inline int32_t pvrdma_idx_ring_has_space(const struct pvrdma_ring *r,
>   static inline int32_t pvrdma_idx_ring_has_data(const struct pvrdma_ring *r,
>   					     uint32_t max_elems, uint32_t *out_head)
>   {
> -	const uint32_t tail = atomic_read(&r->prod_tail);
> -	const uint32_t head = atomic_read(&r->cons_head);
> +	const uint32_t tail = qatomic_read(&r->prod_tail);
> +	const uint32_t head = qatomic_read(&r->cons_head);
>   
>   	if (pvrdma_idx_valid(tail, max_elems) &&
>   	    pvrdma_idx_valid(head, max_elems)) {


It looks like the changes in this file are going to get reverted the 
next time someone does a linux header sync.

