Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30E4923EEFF
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 16:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbgHGO0J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 10:26:09 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15584 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725815AbgHGO0I (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Aug 2020 10:26:08 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 077E2T5P039928;
        Fri, 7 Aug 2020 10:26:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=12G63m6nNUgCxJtOgPkzXIunifSEIVC0Gdm1Kr5ju1s=;
 b=gr1HUEKms1mv9AqL8ggWBTQ58s6WG7idRLg+G/5EbIth69Vzb1RwDBvx7GuBVAvIAc2e
 jyrbQs+u23QTMTB+B9TmkEB82i89neQl2WmuvneCBAM0oj3S2bVoj7Js4P4HevHYaEzG
 /2/k6PU1irClBB47uqMWftd5uG63SjV4BGaunLzN9U6YvY1PcZ56UeMzlWXneEqLk9FP
 NlbovIg0e/R1hSDtymap1SjMxOWMzlq9TXpaQ38yOELsJPbj2xD1Wo/yQe+2O7bm3iua
 9zPo2X2wBvNs8qvF74Hl1WF26G21yLm4qDFAmrU6eXnTGmWY1XYi8cCNyOwoQJ3+0PSr BA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32rjd9xnkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Aug 2020 10:26:06 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 077E2iMk041530;
        Fri, 7 Aug 2020 10:26:05 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32rjd9xnjv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Aug 2020 10:26:05 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 077EPlOT020463;
        Fri, 7 Aug 2020 14:26:02 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 32n018c4tg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Aug 2020 14:26:02 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 077EPxl326214762
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 7 Aug 2020 14:26:00 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD1AE42042;
        Fri,  7 Aug 2020 14:25:59 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51C974203F;
        Fri,  7 Aug 2020 14:25:59 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.47.252])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  7 Aug 2020 14:25:59 +0000 (GMT)
Subject: Re: [PATCH v1 0/1] s390: virtio-ccw: PV needs VIRTIO I/O device
 protection
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     linux-kernel@vger.kernel.org, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, mst@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org
References: <1596723782-12798-1-git-send-email-pmorel@linux.ibm.com>
 <20200806174744.595b9c8c.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <7a79725f-14d9-5b1a-f0e0-77c3ce596420@linux.ibm.com>
Date:   Fri, 7 Aug 2020 16:25:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200806174744.595b9c8c.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-07_09:2020-08-06,2020-08-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 bulkscore=0 lowpriorityscore=0 phishscore=0 priorityscore=1501
 adultscore=0 clxscore=1015 malwarescore=0 spamscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008070097
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-08-06 17:47, Cornelia Huck wrote:
> On Thu,  6 Aug 2020 16:23:01 +0200
...
> This does work, and I'm tempted to queue this patch, but I'm wondering
> whether we need to give up on a cross-architecture solution already
> (especially keeping in mind that ccw is the only transport that is
> really architecture-specific).
> 
> I know that we've gone through a few rounds already, and I'm not sure
> whether we've been there already, but:
> 
> Could virtio_finalize_features() call an optional
> arch_has_restricted_memory_access() function and do the enforcing of
> IOMMU_PLATFORM? That would catch all transports, and things should work
> once an architecture opts in. That direction also shouldn't be a
> problem if virtio is a module.

Yes thanks, I rework it in this direction.


-- 
Pierre Morel
IBM Lab Boeblingen
