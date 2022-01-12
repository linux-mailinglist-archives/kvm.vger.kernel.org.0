Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F67548C390
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 12:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240276AbiALLxD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 06:53:03 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47946 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231301AbiALLxA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Jan 2022 06:53:00 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20CBZu2Z018712;
        Wed, 12 Jan 2022 11:52:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=2IYjVAcUZFYCWjH34ePtxnIej+sBhsH6eWJhxUehLgQ=;
 b=lc4X+w7YCdn7TYurfA2ykuki5m2UWKKTPyinpUkAI2CLTaSp+7d5mBmI6XasATJBKxRk
 US/bJBXNOI2cfLFIZwouCx1Widi3xHEsB8+bjL522rTEIizeQxxDRg4Kk4hs8zB5MQXc
 J/g7OXt5PU1bjgZQCYvjuHKc5YJwd4qNZyg5i7KIZ6DO/QA7gyS/vvH0Sv6K5W6emeIR
 gIpV1flsjgU9ZV6f85VB0rwuPWa3PP0P3lwEz4+bK5yjD/So6igHK0EUEY2UFcIEfFK8
 9LQz+1pXJtEzRpsAAnfp4RQhAuZ1W7lOzDrPfLNPmdJ+sTCcETYAVhIKLQObrDs9xCm4 HA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dhvrc3rfv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 11:52:57 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20CBFrKU029814;
        Wed, 12 Jan 2022 11:52:56 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dhvrc3rf4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 11:52:56 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20CBm1HS026909;
        Wed, 12 Jan 2022 11:52:55 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3df289thnb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 11:52:55 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20CBhm9N26673494
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jan 2022 11:43:48 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 953114C081;
        Wed, 12 Jan 2022 11:52:51 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E0E474C097;
        Wed, 12 Jan 2022 11:52:50 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.56.243])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Wed, 12 Jan 2022 11:52:50 +0000 (GMT)
Date:   Wed, 12 Jan 2022 12:52:17 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH v17 06/15] s390/vfio-ap: refresh guest's APCB by
 filtering APQNs assigned to mdev
Message-ID: <20220112125217.108e0fba.pasic@linux.ibm.com>
In-Reply-To: <831f8897-b7cd-8240-c607-be3a106bad5c@linux.ibm.com>
References: <20211021152332.70455-1-akrowiak@linux.ibm.com>
        <20211021152332.70455-7-akrowiak@linux.ibm.com>
        <20211227095301.34a91ca4.pasic@linux.ibm.com>
        <831f8897-b7cd-8240-c607-be3a106bad5c@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Q7ASgJJCw0MbMLlHkqBjCNcRucoRahkS
X-Proofpoint-GUID: uUTllvUaeYlvT8nOgTEphpbBF84PcXzw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-12_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 adultscore=0 mlxscore=0
 phishscore=0 impostorscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201120075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 Jan 2022 16:19:06 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> >
> > Also we could probably do the filtering incrementally. In a sense that
> > at a time only so much changes, and we know that the invariant was
> > preserved without that change. But that would probably end up trading
> > complexity for cycles. I will trust your judgment and your tests on this
> > matter.  
> 
> I am not entirely clear on what you are suggesting. I think you are
> suggesting that there may not be a need to look at every APQN
> assigned to the mdev when an adapter or domain is assigned or
> unassigned or a queue is probed or removed. Maybe you can clarify
> what you are suggesting here.

Exactly. For example if we have the following assigned
adapters:
1, 2, 3
domains:
1, 2, 3
and the operation we are trying to perform is assign domain 4, then it
is sufficient to have a look at the queues with the APQNs (1,4), (2,4)
and (3, 4). We don't have to examine all the 14 queues.

When an unassign dapter is performed, there is no need to do the
re-filtering, because there is nothing that can pop-back or go away. And
on unassign domain is performed, then all we care about are the queues
of that domain on the filtered adapters.

Similarly if after that successful assign the queue (3,4) gets removed
(from vfio_ap) and then added back again and probed, we only have to
look at the queues (3, 1), (3, 2), (3, 3).

But I'm OK with the current design of this. It is certainly conceptually
simpler to say we have a master-copy and we filter that master-copy based
on the very same rules every time something changes. I'm really fine
either way as log as it works well. :D

Regards,
Halil
