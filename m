Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D859A4E414C
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 15:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbiCVOaT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 10:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237959AbiCVOaM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 10:30:12 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7516C5F8C7
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 07:28:42 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22MCNC6c015818;
        Tue, 22 Mar 2022 14:28:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=Z11ip5jrLOij8BXLnCPgbTlxu3V4V2bH59QABl1feLg=;
 b=BczGLBtEMxnowfT8fLOgC1GFwTyCE/2HfKvumu6qJLy8/qhSr58Xv/NV1gDqqGD7wqfH
 yqnrXGSHgknAZty02m9eyuTGjUhN9WIEu+OHItaqjgUY4/Kpds+UbKra3KuN7l45+3KX
 qwesFXxcS/QcDiDC+znU/AfluG2pfgxbwCEv73crkmiJi5HS5SFyDRF02hQrV+/17PpU
 QcZs6O2904T/FCCI/in2lQ7m92LEh2CUBWeaTcrLF2kMD2nGTsfGfBdw06N9Roa2uWnd
 lVwoz2lSGWvCt7LSGgYncKixjkHN4fMCB/0AQr7G2peUyG2hv2rN4NpBtAQH9VwDqO2w 8Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ey86uucc8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 14:28:29 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22MDPw2E015728;
        Tue, 22 Mar 2022 14:28:29 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ey86uucbe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 14:28:29 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22MEHoxM028025;
        Tue, 22 Mar 2022 14:28:26 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3ew6t8ngak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 14:28:26 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22MESNIX25821494
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Mar 2022 14:28:24 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC18DA4059;
        Tue, 22 Mar 2022 14:28:23 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7AFA8A4040;
        Tue, 22 Mar 2022 14:28:22 +0000 (GMT)
Received: from sig-9-145-28-179.uk.ibm.com (unknown [9.145.28.179])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Mar 2022 14:28:22 +0000 (GMT)
Message-ID: <808a871b3918dc067031085de3e8af6b49c6ef89.camel@linux.ibm.com>
Subject: Re: [PATCH RFC 04/12] kernel/user: Allow user::locked_vm to be
 usable for iommufd
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Date:   Tue, 22 Mar 2022 15:28:22 +0100
In-Reply-To: <4-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
References: <4-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZmEmteEVUeELimln3m8Svl5vaJY_h_ne
X-Proofpoint-ORIG-GUID: 2jgrEHbOtCoiWH372ljhi9hP5boIxdqN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-22_04,2022-03-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 impostorscore=0 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203220082
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-03-18 at 14:27 -0300, Jason Gunthorpe wrote:
> Following the pattern of io_uring, perf, skb, and bpf iommfd will use
                                                iommufd ----^
> user->locked_vm for accounting pinned pages. Ensure the value is included
> in the struct and export free_uid() as iommufd is modular.
> 
> user->locked_vm is the correct accounting to use for ulimit because it is
> per-user, and the ulimit is not supposed to be per-process. Other
> places (vfio, vdpa and infiniband) have used mm->pinned_vm and/or
> mm->locked_vm for accounting pinned pages, but this is only per-process
> and inconsistent with the majority of the kernel.

Since this will replace parts of vfio this difference seems
significant. Can you explain this a bit more?

I'm also a bit confused how io_uring handles this. When I stumbled over
the problem fixed by 6b7898eb180d ("io_uring: fix imbalanced sqo_mm
accounting") and from that commit description I seem to rember that
io_uring also accounts in mm->locked_vm too? In fact I stumbled over
that because the wrong accounting in io_uring exhausted the applied to
vfio (I was using a QEMU utilizing io_uring itself).

> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  include/linux/sched/user.h | 2 +-
>  kernel/user.c              | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/sched/user.h b/include/linux/sched/user.h
> index 00ed419dd46413..c47dae71dad3c8 100644
> --- a/include/linux/sched/user.h
> +++ b/include/linux/sched/user.h
> @@ -24,7 +24,7 @@ struct user_struct {
>  	kuid_t uid;
>  
>  #if defined(CONFIG_PERF_EVENTS) || defined(CONFIG_BPF_SYSCALL) || \
> -    defined(CONFIG_NET) || defined(CONFIG_IO_URING)
> +    defined(CONFIG_NET) || defined(CONFIG_IO_URING) || IS_ENABLED(CONFIG_IOMMUFD)
>  	atomic_long_t locked_vm;
>  #endif
>  #ifdef CONFIG_WATCH_QUEUE
> diff --git a/kernel/user.c b/kernel/user.c
> index e2cf8c22b539a7..d667debeafd609 100644
> --- a/kernel/user.c
> +++ b/kernel/user.c
> @@ -185,6 +185,7 @@ void free_uid(struct user_struct *up)
>  	if (refcount_dec_and_lock_irqsave(&up->__count, &uidhash_lock, &flags))
>  		free_user(up, flags);
>  }
> +EXPORT_SYMBOL_GPL(free_uid);
>  
>  struct user_struct *alloc_uid(kuid_t uid)
>  {


